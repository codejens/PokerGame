-- Monster.lua
-- created by aXing on 2012-12-1
-- 游戏场景中的怪物基类

require "entity/Actor"

Monster = simple_class(Actor)

local GUANGHUAN_EFFECT_TAG = 666;		-- 角色光环特效TAG;
local frameloc = "scene/monster/"

function Monster:__init( handle )
	Actor.__init(self,handle)
	self.type = "Monster"
	self.__classname = "Monster"
end

-- 实体更改自己的属性
function Monster:change_entity_attri( attri_type, attri_value )
	local old_value 	= self[attri_type]
	Actor.change_entity_attri(self, attri_type, attri_value)
	self[attri_type]	= attri_value
	
	-- 以下是怪物属性变更的时候，触发的事件
	if attri_type == "model" then
		self.model = ZXEntityMgr:toMonster(attri_value)
		if self.model == nil then
			print("ERROR:: entity转换actor出错！")
			return
		end
		self:register_click_event()
	elseif attri_type == "body" then
		self._body_id = attri_value
		EntityManager.setNPCBody(self)

	elseif attri_type == "name" then
		-- 如果是仙灵封印里面的仙灵，则要播放剧情动画
		-- if ( SceneManager:get_cur_scene() == 1046   ) then
		-- 	if ( string.find(self.name,"仙灵") ) then 
		-- 		LuaEffectManager:play_monster_talk_with_hp( 1 ,self.handle,{0.95,0.9,0.85});
		-- 	elseif ( self.name == "赤元子" ) then
		-- 		local other_entity_handle = EntityManager:get_handler_by_sub_name( "仙灵" );
		-- 		LuaEffectManager:play_monster_talk( 2 ,self.handle,other_entity_handle,{1,2,1,2,1});
		-- 	end
		-- end
	end
end

-- 特殊需求，需要设置怪物不能点击
-- 斗法台中宠物时一只怪物，然后宠物要设置为不能被玩家点击到，因为斗法台的地方很小
function Monster:disable_click_event( )
	self.model:setClickEvent(0)
end

function Monster:talk( str )
	EntityDialog(self.model:getBillboardNode(), str );
end

function Monster:_setBody(path)
	--宠物当作怪物
	print('--------Monster:_setBody',self._body_id)
	local _body_info = EntityFrameConfig.MONSTER_FRAME_WITH_ACTIONS[self._body_id]
	if _body_info then
		self.model:setAnimationType(_body_info.entity_type)
		self.model:changeBody(_body_info.path)
		self.body_info = _body_info
	else
		self.model:changeBody(path)
	end
end

function Monster:setBody()
	local attri_value = self._body_id
	if self.model ~= nil then
		local path;
		-- 潜规则，在斗法台场景的时候，对手的人物和怪物都是一个monster，这里要做下特殊处理
		if ( SceneManager:get_cur_scene() == 1078 ) then
			--self.body 包含了2个数据，高位16是人物特效id，低16为是body的modelid
			local body_effect_id = ZXLuaUtils:highByte( attri_value );
			if ( body_effect_id~= 0 ) then
				-- 播放人物特效
				local ani_table = effect_config[body_effect_id]
				-- 先删除之前的特效
				self.model:stopEffect(GUANGHUAN_EFFECT_TAG);
				self.model:playEffect( ani_table[1],GUANGHUAN_EFFECT_TAG,7,ani_table[3],nil,0 ,0,-1,ani_table[2]);
			end
			self.body = ZXLuaUtils:lowByte( attri_value );
			
			if ( self.body < 1000 ) or ((self.body >= 1300) and (self.body <= 1500))then
				--斗法台中，model id 小于1000是宠物id
				--天降雄师项目组1300-1500的模型id是伙伴id
				path = EntityFrameConfig:get_doufatai_pet_path( self.body );
				print("self.id = ",self.id,"pet_id = ",PetModel:get_current_pet_id());
			else
				--斗法台中，model id 大于等于1000是人物的body id
				path = EntityFrameConfig:get_human_path( self.body );
			end

		else
			-- 普通的怪物创建方式
			local current_scene_name = SceneManager:get_current_scene_name()
			path = frameloc .. attri_value
		end
		self:_setBody(path)
	end
end

-- 实体死亡
-- called from LuaEffectManager:play_monster_dead_effect
function Monster:dieAction()
	-- 暂时只有玩家角色才享有死亡动作
	local rand = math.random(0,2)
	if rand == 0 then
		self.model:playAction(ZX_ACTION_STRUCK,self.dir,false)
	else
		self.model:playAction(ZX_ACTION_STRUCK_2,self.dir,false)
	end
end

function Monster:playAction(action_id, dir, loop)
	if self.body_info then
		local actionGroup =  self.body_info.actions[action_id]
		if actionGroup then
			local rand = math.random(1,#actionGroup)
			Actor.playAction(self,actionGroup[rand],dir,loop)
		else
			Actor.playAction(self,action_id,dir,loop)
		end
	else
		Actor.playAction(self,action_id,dir,loop)
	end
end

function Monster:addBloodBar( max_hp )
	local maxHp = max_hp or 0
	local bill_board_node = self.model:getBillboardNode()
	local hp_bg = MUtils:create_zximg(bill_board_node,UILH_OTHER.blood_bg,0,0,-1,-1)
    hp_bg:setTag(0)
	hp_bg:setAnchorPoint(0.5,0)
	local bill_board_node_size = bill_board_node:getContentSize()
	hp_bg:setPosition(bill_board_node_size.width / 2, bill_board_node_size.height+20)
    -- 血条1
	-- local hp_bar_bg = MUtils:create_progress_bar( 0, 0, 109, 23, UILH_OTHER.blood_bg, UILH_OTHER.blood, maxHp, {16,nil}, {11,11,10,8}, false )
	self.hp_bar = HPBar( hp_bg,
                            "nopack/main/m_monster2.png",
                            "nopack/main/m_monster2.png",
                            11,8,84,6,nil,1 ); 
	self.hp_bar:set_hp(max_hp, max_hp)
	local hp_bar2 = MUtils:create_sprite(self.hp_bar.view, "nopack/main/m_monster.png",0,0,100)
	-- hp_bg:addChild(hp_bar2.view)
	hp_bar2:setAnchorPoint(CCPoint(0,0));
	self.hp_bar2 = hp_bar2

	hp_bg:setIsVisible(false)
	self.hp_bg = hp_bg
end

function Monster:changeBlood(change_hp,hp,max_hp)
	if self.hp_bg and self.hp_bar and change_hp ~= 0 and hp > 0 then
		self.hp_bg:setIsVisible(true)
		self.hp_bar:update_hp(change_hp,hp,max_hp)
		self.hp_bar2:setTextureRect(CCRect(0, 0, 84 *hp/max_hp, 6))
		self.hp_bar2:setPosition(0, 0)
	elseif hp <= 0 and self.hp_bar then
		self.hp_bar:destroy()
		self.hp_bar = nil
	end
end

function Monster:destroyBlood()
	if self.hp_bar then
		self.hp_bar:destroy()
		self.hp_bar = nil
	end
	if self.hp_bg then
		self.hp_bg:removeFromParentAndCleanup(true)
		self.hp_bg = nil
	end
end

function Monster:setName(name_color,name,level)
	local model = self.model
	local bill_board_node = model:getBillboardNode()
	local bill_board_node_size = bill_board_node:getContentSize()
	local temp = "#c" .. Utils:c3_dec_to_hex(name_color) .. name
	self:change_entity_attri("name_color", Utils:c3_dec_to_hex(name_color))
	temp = temp .. "(" .. level .. LangGameString[438] -- [438]="级)"
	local name_lab = Label:create( nil, 0, 0, temp )
	self.name_lab = name_lab
	local name_lab_size = name_lab:getSize()			
	bill_board_node:addChild(name_lab.view)
	name_lab:setPosition( ( bill_board_node_size.width - name_lab_size.width ) / 2, 0 )	
end