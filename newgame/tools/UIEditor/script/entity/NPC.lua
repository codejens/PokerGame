-- NPC.lua
-- created by aXing on 2012-12-1
-- 游戏场景中NPC实体类

require "entity/Actor"
-- require "utils/MUtils"
NPC = simple_class(Actor)

local frameloc = "scene/npc/"

function NPC:__init( handle )
	Actor.__init(self,handle)
	self.type = "NPC"
end

-- 实体析构
function NPC:destroy(  )
	if self.fbid then
		EntityManager:remove_fb_quest_npc(self.fbid)
	end
	if self.quest_anim_timer then
		self.quest_anim_timer:stop()
	end
	ZXEntityMgr:sharedManager():destroyEntity(self.handle)
	self.model = nil
end

-- 实体更改自己的属性
function NPC:change_entity_attri( attri_type, attri_value )
	local old_value 	= self[attri_type]
	Actor.change_entity_attri(self, attri_type, attri_value)
	self[attri_type]	= attri_value
	
	-- 以下是怪物属性变更的时候，触发的事件
	if attri_type == "model" then
		self.model = ZXEntityMgr:toNPC(attri_value)
		if self.model == nil then
			print("ERROR:: entity转换actor出错！")
			return
		end
		self:register_click_event()
	elseif attri_type == "body" then
		self._body_id = attri_value
		print('NPC change body', attri_value)
		EntityManager.setNPCBody(self)

	elseif attri_type == "name" then
		self.npc_name = attri_value
	end
end

local NPC_STATE_TAG = 400;

-- 改变npc的状态 0 没有任务 1 可以接任务 2 有任务可以在Npc上交 3 有任务在这个npc上交，但未完成
function NPC:change_quest_state( npc_state )
	local top_node = self.model:getBillboardNode();
	local old_spr = top_node:getChildByTag( NPC_STATE_TAG );
	if ( old_spr ) then
		old_spr:removeFromParentAndCleanup(true);
	end
	
	if self.quest_anim_timer == nil then
		self.quest_anim_timer = timer()
	end
	self.quest_anim_timer:stop()

	if ( npc_state ~= 0 ) then
		local spr = MUtils:create_sprite(top_node,"nopack/task/npc_state"..npc_state..".png",0,60,5);
		spr:setTag(NPC_STATE_TAG);

		local offset = 12
		self.quest_anim_timer:start(1.5, function() 
			offset = offset * -1
			local action0 = CCMoveBy:actionWithDuration(1.5,CCPoint(0,offset));
			spr:runAction(action0)
		end)

	end
	self.npc_state = npc_state;
end

-- NPC头顶上面的称号
-- npc有自己的一套头顶称号，是场景配置表里面有的
-- funcId NPC的功能的ID,1、仙宗；2、仓库；3、装备；4、药品；5、日常；6、副本，默认是0可以不配置
function NPC:update_title( title_index )
	if title_index ~= nil then
		local path  = string.format(UIResourcePath.FileLocate.npcTitle .. "%05d.png", title_index)
		--print("run NPC:update_titel~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
		-----HJH 2014-1-25
		-----将CCZXImage改为CCSprite实现
		-----new code
		local image = CCSprite:spriteWithFile( path )
		image:setAnchorPoint(CCPointMake(0.5, 0));
		image:setPosition(CCPointMake(0, 18))			-- 从18像素开始往上排称号 名字的16号字
		-----old code
		-- local image = CCZXImage:imageWithFile( 0, 0, -1, -1, path )
		-- image:setAnchorPoint(0.5, 0);
		-- image:setPosition(0, 18)			-- 从18像素开始往上排称号 名字的16号字
		self.model:getBillboardNode():addChild(image)

		---
		if title_index == 6 then
			self:init_fb_quest_npc()
		end
		---
	end
end

function NPC:init_fb_quest_npc()

	print("--------init_fb_quest_npc----------",self.npc_name)
	
	local fbdata = FubenConfig:get_fuben_by_name(self.npc_name)

	local fbid = fbdata.fbid
	local enter_times, max_tiems = ActivityModel:get_enter_fuben_count( fbid ) 

	local f = self.change_quest_state
	self.change_quest_state = function(...) end
	self.change_quest_state_fb = f

	local player = EntityManager:get_player_avatar()

	if player and max_tiems > enter_times and player.level >= fbdata.minLevel then
		self:change_quest_state_fb(1)
	end

	self.fbid = fbid
	self.fbdata = fbdata
	EntityManager:add_fb_quest_npc(self.fbid,self)
end

function NPC:update_fb_quest_state()
	local player = EntityManager:get_player_avatar()
	local enter_times, max_tiems = ActivityModel:get_enter_fuben_count( self.fbid ) 
	if player and max_tiems > enter_times and player.level >= self.fbdata.minLevel then
		self:change_quest_state_fb(1)
	else
		self:change_quest_state_fb(0)
	end
end

function NPC:setBody()
	local attri_value = self._body_id
	if self.model ~= nil then
		local current_scene_name = SceneManager:get_current_scene_name();

		local path = EntityFrameConfig:get_npc_path( attri_value );--frameloc .. attri_value
		self.model:changeBody(path)
		local npc = SceneConfig:get_npc_data(SceneManager:get_cur_scene(), self.name)
		if npc ~= nil then
			self:update_title(npc.funcid)
		end
	end
end

function NPC:setName(name_color,name)
	name = Utils:parseNPCName(name)
	local model = self.model
	local bill_board_node = model:getBillboardNode()
	local bill_board_node_size = bill_board_node:getContentSize()
	
	local temp = "#c" .. Utils:c3_dec_to_hex(name_color) .. name
	self:change_entity_attri("name_color", Utils:c3_dec_to_hex(name_color))
	
	local name_lab = Label:create( nil, 0, 0, temp )
	self.name_lab = name_lab
	local name_lab_size = name_lab:getSize()			
	bill_board_node:addChild(name_lab.view)
	name_lab:setPosition( ( bill_board_node_size.width - name_lab_size.width ) / 2, 0 )	
end