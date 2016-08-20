-- Avatar.lua
-- created by aXing on 2012-12-1
-- 游戏场景中玩家的实体
-- 主要实现了玩家的属性，如装备，翅膀，法宝等

-- require "entity/Actor"
-- require "config/EntityConfig"
require '../data/action_effects/effects'

Avatar = simple_class(Actor)



local tremove = table.remove

local GUANGHUAN_EFFECT_TAG = 666;		-- 角色光环特效TAG;

local TYPE_CHENG_HAO = 1;		--称号
local TYPE_XIAN_ZONG = 2;		--仙宗
local TYPE_BIAN_SHEN = 3;		--变身

local show_title_type = TYPE_CHENG_HAO		-- 在普通地图上显示称号,在pk地图上显示仙宗

local SETBODYQUEUE_BODY   = 1
local SETBODYQUEUE_MOUNT  = 2
local SETBODYQUEUE_WEAPON = 3
local SETBODYQUEUE_WING   = 4
local SETBODYQUEUE_FABAO  = 5

local _math_max = math.max
local JUMPTIME_MOD = 2000000

local eAnimationAvatar = 0

local _transform_model_id = 0    --变身id,0表示不变身，其他正整数表示当前变身id
local _transform_stage_level = 0 --当前变身的阶数
local _cpplogicScene = ZXLogicScene:sharedScene()

local _is_need_reset_shangma = false

function Avatar:__init( handle )
	-- 称号对应的控件 {1:image,...}
	Actor.__init(self,handle)
	self._title_component = {}
	self._if_show_title = true       -- 是否显示称号
	self.title_root = nil            -- 称号的根结点
	self.action_count = 0

	self.did_change_body = false;	--是否至少change过一次body

	--设置Body的队列，分时装配Avatar
	self._setBodyJobQueue = {}
	--移动和脚印检查timer
	self.movment_check_timer = timer()

	self.jumpCallbacks = {}

	--阻止动作
	self._jumping = false;

	self._teleporting = false

	-- 当前变身的id和等级
	self._current_transforms_id=0
	self._current_transforms_level=0

	--因为body在wing和weapon同步以后才发过来，但是装备是依赖body的
	--所以需要先存起来等有body了再加载
	self._slots_load_after_set_body = {}
end

function Avatar:slot_load_after_set_body(v)
	--因为body在后面才发过来，但是装备是依赖body的
	self._slots_load_after_set_body[#self._slots_load_after_set_body+1] = v
end

-- 设置变身
function Avatar:set_transform_id_and_level( _transforms_id,_transform_level )
	self._current_transforms_id=_transforms_id
	self._current_transforms_level=_transform_level
end
-- 获取是否变身
function Avatar:get_transform_id_and_level( _transforms_id )
	return self._current_transforms_id,self._current_transforms_level
end

-- 实体析构
function Avatar:destroy()
	for i, cb in ipairs(self.jumpCallbacks) do
		cb:cancel()
	end
	if self.movment_check_timer then
		self.movment_check_timer:stop()
		self.movment_check_timer=nil
	end
	self.model = nil
	Actor.destroy(self)
end

function Avatar:update_title_type( title_type, is_shangma )
	show_title_type = title_type;
	--print("Avatar:update_title_type( title_type )",title_type)

	-- 称号
	if ( show_title_type == TYPE_CHENG_HAO ) then
		self:set_if_show_title( true, is_shangma );
		if ( self.xz_title ) then
			self.xz_title:removeFromParentAndCleanup(true);
			self.xz_title = nil;
		end
	--仙踪
	elseif ( show_title_type == TYPE_XIAN_ZONG ) then
		self:set_if_show_title( false );
		--取消家族显示
		--self.xz_title = MUtils:create_zxfont(self.model:getBillboardNode(),"#c00c0ff"..self.guildName,0,18,2,16);
	end

	-- if self._current_transforms_id~=0 and self._current_transforms_level~=0  and self.model then
	-- if self._current_transforms_id~=0 and self.model then
	-- 	-- 添加变身图标
	-- 	local icon_path = string.format("icon/bianshen/tag/%d.pd",self._current_transforms_level)
	-- 	-- self.head_img=MUtils:create_zximg(nil, icon_path, -48,-10, 32, 32);

	-- 	self.head_img=CCSprite:spriteWithFile(icon_path)
		
	-- 	local temp_panel_size = self.head_img:getContentSize()

	-- 	local bill_board_node = self.model:getBillboardNode()
	--     local bill_board_node_size = bill_board_node:getContentSize()

	--     local bill_board_node_pos_x, bill_board_node_pos_y = bill_board_node:getPosition()

	--     self.head_img:setPosition( ( bill_board_node_size.width - temp_panel_size.width ) / 2, 6 )

	--     bill_board_node:addChild(self.head_img)

	-- elseif 	self._current_transforms_id==0 then
	-- 	if self.head_img~=nil then
	-- 		self.head_img:removeFromParentAndCleanup(true)
	-- 		self.head_img=nil
	-- 	end
	-- end
end

-- 实体析构
function Avatar:destroy(  )
	Actor.destroy(self)
	self.model = nil
	self.movment_check_timer:stop()
end

-- 玩家属性变更函数
function Avatar:change_entity_attri( attri_type, attri_value )
	--print("Avatar:change_entity_attri:attri_type, attri_value",attri_type, attri_value);
	local old_value 	= self[attri_type]
	Actor.change_entity_attri(self, attri_type, attri_value)
	self[attri_type]	= attri_value
	--print("Avatar", attri_type, attri_value)

	-- 以下是属性变更的时候，触发的事件
	if attri_type == "model" then
		self.model = ZXEntityMgr:toAvatar(attri_value)
		if self.model == nil then
			print("ERROR:: entity转换player avatar出错！")
			return
		end
        
		self:register_click_event()
	elseif attri_type == "body" then
		--print("-----改变body---------Avatar:change_entity_attri( attri_type, attri_value )-------------",attri_type,attri_value)
		self:update_default_body( attri_value )
	elseif attri_type == "mount" then
		if ( self.type == 0 ) then 
			self.mount = attri_value;
			print("其他玩家的坐骑",attri_value);
			self:ride_a_mount(attri_value);
		end
	elseif attri_type == "weapon" then
	--	print("装备更换:",attri_value);
		self:update_weapon( attri_value );
	elseif attri_type == "wing" then
		
		self:update_wing_and_fabao( attri_value )
		-- self:update_wing( attri_value );

	elseif attri_type == "state" then

		-- if ( self.type == -1 ) then
		-- 	-- print("change_entity_attri..........................",attri_type,attri_value)
		-- 	print("self.state  ===== ",self.state,"old_value = ",old_value);
		-- else
		-- 	print("其他人的state  ===== ",self.state,"old_value = ",old_value);
		-- end
		-- 如果被攻击关闭交易
		if ( self.type == -1 and old_value and ZXLuaUtils:band(old_value, EntityConfig.ACTOR_STATE_BATTLE) == 0 and ZXLuaUtils:band(attri_value, EntityConfig.ACTOR_STATE_BATTLE) > 0 ) then
			-- local buniess_win = UIManager:find_visible_window("buniess_win")
			-- if buniess_win ~= nil then
			-- 	BuniessModel:exit_btn_function()
			-- end
		end

		-- -- 如果被攻击关闭交易
		-- if ( self.type == -1 and old_value and ZXLuaUtils:band(old_value, EntityConfig.ACTOR_STATE_BATTLE) == 0 and ZXLuaUtils:band(attri_value, EntityConfig.ACTOR_STATE_BATTLE) > 0 ) then
		-- 	local 
		-- end
		-- 进入战斗状态时创建血条
		if attri_value and attri_value == EntityConfig.ACTOR_STATE_BATTLE then
			self:show_hide_blood(true)
		else
			self:show_hide_blood(false)
		end

		--如果之前是打坐 并且现在不是打坐和双修，则站立
		if ( old_value and ZXLuaUtils:band(old_value, EntityConfig.ACTOR_STATE_ZANZEN) > 0 and ZXLuaUtils:band(attri_value, EntityConfig.ACTOR_STATE_COUPLE_ZANZEN) == 0 
			  and ZXLuaUtils:band(attri_value, EntityConfig.ACTOR_STATE_ZANZEN) == 0) then
			-- print(self.id.."恢复站立"..self.state);
			self:stand_up(  );
			if ( self.type == -1 ) then
				UIManager:hide_window("dazuo_win");
			end
		end
		-- 如果之前是双修,并且现在不是双修和打坐,则站立
		if ( old_value and ZXLuaUtils:band(old_value, EntityConfig.ACTOR_STATE_COUPLE_ZANZEN) > 0 and ZXLuaUtils:band(attri_value, EntityConfig.ACTOR_STATE_COUPLE_ZANZEN) == 0 ) then
			print("双修恢复站立")
			if ( ZXLuaUtils:band(attri_value, EntityConfig.ACTOR_STATE_ZANZEN) == 0  ) then
				-- 取消打坐的时候判断现在是否在坐骑上
				if ( ZXLuaUtils:band(attri_value, EntityConfig.ACTOR_STATE_RIDE) > 0 ) then
					self:ride_a_mount(self.mount);
				else
					self:stand_up(  );
				end
			elseif ( ZXLuaUtils:band(attri_value, EntityConfig.ACTOR_STATE_ZANZEN) > 0  ) then
				-- 取消双修
				self:stop_shuangxiu()
				-- 重新进入打坐
				self:sit_down(  );
			end
		end

		-- 下坐骑
		if ( self.type ~= -1 and old_value and ZXLuaUtils:band(old_value, EntityConfig.ACTOR_STATE_RIDE) > 0 and  ZXLuaUtils:band(attri_value, EntityConfig.ACTOR_STATE_RIDE) == 0) then
			self:get_down_mount();
		end

		-- 站立，移动，坐骑，打坐，采集，死亡，双修，游泳，这几种状态应该是互斥的，不能同时存在
		-- 站立
		if ( ZXLuaUtils:band(attri_value, EntityConfig.ACTOR_STATE_STAND) > 0  ) then
			self:stand_up(  )
		-- 双修
		elseif ( ( old_value == nil or ZXLuaUtils:band(old_value, EntityConfig.ACTOR_STATE_COUPLE_ZANZEN) == 0 ) and ZXLuaUtils:band(attri_value, EntityConfig.ACTOR_STATE_COUPLE_ZANZEN) > 0 ) then
			-- 如果之前没有在打坐
			-- if ( ( old_value == nil or ZXLuaUtils:band(old_value, EntityConfig.ACTOR_STATE_ZANZEN) == 0 ) and ZXLuaUtils:band(attri_value, EntityConfig.ACTOR_STATE_ZANZEN) > 0 ) then
				self:get_down_mount();
				self:sit_down(  );
			-- end
			self:shuangxiu();
			if ( self.type == -1 ) then
				--print(self.id.."-----------------进入双修状态-----------------------------")
				local win = UIManager:show_window("dazuo_win");
				if ( win ) then
					win:change_state(2);
				end
				print("主角进入双修")
			else
				print("其他玩家进入双修")
			end
		-- 如果之前不是打坐状态并且当前进入打坐状态
		elseif ( ( old_value == nil or ZXLuaUtils:band(old_value, EntityConfig.ACTOR_STATE_ZANZEN) == 0 ) and ZXLuaUtils:band(attri_value, EntityConfig.ACTOR_STATE_ZANZEN) > 0 ) then
			print(self.id.."-----------------进入打坐状态-----------------------------")
			self:sit_down();
		-- 死亡
		elseif ( ( old_value == nil or ZXLuaUtils:band(old_value, EntityConfig.ACTOR_STATE_DEATH) == 0 )  and ZXLuaUtils:band(attri_value, EntityConfig.ACTOR_STATE_DEATH) > 0 ) then
			self:die();
		-- -- 上坐骑
		-- elseif ( ( old_value == nil or ZXLuaUtils:band(old_value, EntityConfig.ACTOR_STATE_RIDE) == 0 ) and  ZXLuaUtils:band(attri_value, EntityConfig.ACTOR_STATE_RIDE) > 0 ) then
		-- 	print("avatar上坐骑----------------------self.mount",self.mount);
		-- 	self:ride_a_mount( self.mount )
		end
		local is_shangma = not (ZXLuaUtils:band( attri_value , EntityConfig.ACTOR_STATE_RIDE) == 0)
		-- model创建在state之后，所以只能把天元之主的判断加在这了
		if ( not is_shangma and old_value and ZXLuaUtils:band(old_value, EntityConfig.ACTOR_STATE_CASTELLAN) == 0 and ZXLuaUtils:band(attri_value, EntityConfig.ACTOR_STATE_CASTELLAN) > 0 ) then
			print("-------------------------播放天元之主特效--------------------------");
			local ani_table = effect_config[79];
			local effect_node = self.model:getChildByTag(79)
			if not effect_node then
				self.model:playEffect(ani_table[1],79,7,ani_table[3],nil,0,0,10,ani_table[2]);
			end
		end

		-- 取消天元之主
		if ( old_value and ZXLuaUtils:band(old_value, EntityConfig.ACTOR_STATE_CASTELLAN) > 0 and ZXLuaUtils:band(attri_value, EntityConfig.ACTOR_STATE_CASTELLAN) == 0) then
			self.model:stopEffect(79);
		end

		-- 播放眩晕特效
		if ( old_value and ZXLuaUtils:band(old_value, EntityConfig.ACTOR_STATE_DIZZY) == 0 and ZXLuaUtils:band(attri_value, EntityConfig.ACTOR_STATE_DIZZY) > 0 ) then
			if ( self.type == -1  ) then
				print("主角开始眩晕特效............................................................")
			end
			local effect_node = self.model:getChildByTag(30001)
			if ( effect_node == nil ) then
				local ani_table = effect_config[30001];
				self.model:playEffect(ani_table[1],30001,7,ani_table[3],nil,0,0,10,ani_table[2]);
			else
				if ( self.type == -1  ) then
					print("主角重复眩晕特效...........");
				end
			end
			-- 如果是主角的话，被眩晕了要马上停止当前动作
			if ( self.type == -1 ) then
				self:stop_curr_action();
			end
		-- 取消眩晕特效
		elseif 	( old_value and ZXLuaUtils:band(old_value, EntityConfig.ACTOR_STATE_DIZZY) > 0 and ZXLuaUtils:band(attri_value, EntityConfig.ACTOR_STATE_DIZZY) == 0) then
			if (self.type == -1 ) then
				print("停止眩晕特效..............................................................")
			end
			self.model:stopEffect(30001);
		elseif ( old_value and ZXLuaUtils:band(old_value, EntityConfig.ACTOR_STATE_MOVE_FORBID) == 0 and ZXLuaUtils:band(attri_value, EntityConfig.ACTOR_STATE_MOVE_FORBID) > 0 ) then
			print("禁止行动。。。。。。。。。。。。。。。。。。。。。。。。。。。。。",self.name)
			-- 如果是主角的话，被眩晕了要马上停止当前动作
			if ( self.type == -1 ) then
				self:stop_curr_action();
			end
		end

		-- Boss归属者
		if ( ( old_value == nil or ZXLuaUtils:band(old_value, EntityConfig.ACTOR_STATE_SHOW_BOSS_NAME) == 0 ) and ZXLuaUtils:band(attri_value, EntityConfig.ACTOR_STATE_SHOW_BOSS_NAME) > 0 ) then
			self:add_title( 20000 );
		elseif ( old_value and ZXLuaUtils:band(old_value, EntityConfig.ACTOR_STATE_SHOW_BOSS_NAME) > 0 and ZXLuaUtils:band(attri_value, EntityConfig.ACTOR_STATE_SHOW_BOSS_NAME) == 0 ) then
			self:remove_title( 20000 );
		end

		-- 复活状态
		if old_value ~= nil and ZXLuaUtils:band(old_value, EntityConfig.ACTOR_STATE_DEATH) > 0 
			and ZXLuaUtils:band(attri_value, EntityConfig.ACTOR_STATE_DEATH) == 0 then
			print("-------------------------复活-------------------------------");
			self:relive()
		end
	elseif attri_type == "sex" then
		-- print("其他玩家改变了性别");
	elseif attri_type == "hp" then
		-- TODO:: 当血量改变的时候
	elseif attri_type == "mp" then
		-- TODO:: 当蓝量改变的时候
	elseif attri_type == "teamId" then
		--print("................................teamId = ",self.teamId);
	elseif attri_type == "guildName" then
		--print("................................guildName = ",self.guildName);
	elseif attri_type == "QQVIP" then
		self:update_qqvip(attri_value)
	elseif attri_type == "practiceEffect" then
		self:change_run_effect(attri_value)
	elseif attri_type == "super" then		
		local stage    		 = Utils:low_word(attri_value) 
		local stage_level    = Utils:high_word(attri_value)
		-- ZXLog('---------------变身属性改变-------------------',stage,stage_level)
		if self.model and self.role_name_panel then
			self.role_name_panel.change_super_icon(stage_level)
			--xiehande  添加变身特效
             MenusPanel:play_tran_effect();
		end
	end

end
-- 死亡
function Avatar:die(  )
	if ( self.model and self.did_change_body) then
		-- 死的时候收起武器
--CUSTOMTODO delete
--[[
		self.model:takeOffWeapon()
]]--
		self.model:die()
		Actor.die(self)
		-- 死亡时取消眩晕特效
		self.model:stopEffect(30001)
		print("self.id  die",self.id)
	end
--@debug_begin
	--print('Avatar:die', self.name, self.handle)
	if not self.did_change_body then
		print('Avatar:die before did_change_body')
	end
	--assert(self.did_change_body)
--@debug_end
end

-- 复活
function Avatar:relive(  )
	self.model:relive()
	-- 复活的时候拿起武器
	if self.weapon_name then 
		--CUSTOMTODO delete
		--self.model:putOnWeapon(self.weapon_name);
		--
	end
	if self.weapon_effect_name then
		self.model:putOnEffect(self.weapon_effect_name)
		-- self.model:showWeaponEffect(self.weapon_effect_name);
	end
end

-- 打坐
function Avatar:sit_down(  )

	--print("sit_down");
	if SceneManager:get_cur_scene() ~= 1077 then
		self.model:sitDown()
		-- 打坐要收起武器
--CUSTOMTODO delete
--[[
		self.model:takeOffWeapon()
]]--
		-- 防止重复播放特效
		local effect_node = self.model:getChildByTag(106);
		if ( effect_node == nil ) then 
--			print("播放打坐特效.................................")
			-- 播放打坐特效
			local animatioin_table = effect_config[106];
			self.model:playEffect( animatioin_table[1], 106,7,animatioin_table[3],nil,0 ,0,500,animatioin_table[2]);
		end
		if ( self.type == -1 ) then
		    -- 如果是主角，显示双修按钮
			DaZuoWin:show( self.x,self.y );
		end
	end
end

-- 不打坐
function Avatar:stand_up(  )
	--print("stand_up");
	-- 先取消打坐特效
	self.model:stopEffect( 106 );
	self.model:stopEffect( 105 );
	self.model:standUp()
	-- 不打坐的时候，拿起武器
	--CUSTOMTODO delete
	if self.weapon_name and SceneManager:get_cur_scene() ~= 1077 then
		self.model:putOnWeapon(self.weapon_name)
	end


	if self.weapon_effect_name and SceneManager:get_cur_scene() ~= 1077 then
		self.model:putOnEffect(self.weapon_effect_name)
		-- self.model:showWeaponEffect(self.weapon_effect_name);
	end
end

-- 双修特效
function Avatar:shuangxiu()
	-- -- 先取消打坐特效
	self.model:stopEffect( 106 );
	local animatioin_table = effect_config[105];
	-- 播放双修特效
	self.model:playEffect( animatioin_table[1], 105,7,animatioin_table[3],nil,0 ,0,500,animatioin_table[2]);

end

-- 停止双修
function Avatar:stop_shuangxiu()
	self.model:stopEffect( 105 );
end

-- 不同的坐骑需要调节不同的坐标;
-- 这里做成了配置文件，让策划配置坐骑是偏移像素
-- local mount_pos_table = {10,10,15,15,15,20,23,23 }

-- 骑上坐骑
function Avatar:ride_a_mount( mount_id )
	self._setBodyJobQueue[SETBODYQUEUE_MOUNT] = function() self:_delay_ride_mount( mount_id ) end
	EntityManager.setAvatarBody(self)
	local is_shangma;
	if mount_id > 0 then
		is_shangma = true;
	end
	self:update_name(is_shangma)
	self:update_title(is_shangma)
	self:update_zhenlong(is_shangma)
end

function Avatar:update_zhenlong( is_shangma )
	local attri_value 	= self["state"]
	if is_shangma then
		self.model:stopEffect(79)
	elseif ( attri_value and ZXLuaUtils:band(attri_value, EntityConfig.ACTOR_STATE_CASTELLAN) > 0) then
		local effect_node = self.model:getChildByTag(79)
		if not effect_node then
			local ani_table = effect_config[79]
			self.model:playEffect(ani_table[1],79,7,ani_table[3],nil,0,0,10,ani_table[2]);
		end
	end
end
--上坐骑
function Avatar:_delay_ride_mount( mount_id )
	-- print("ride_a_mount..................................mount_id = ",mount_id);
	if self.model and mount_id > 0 then
	
		local path = "frame/mount/"..mount_id;
		self.model:rideOnMount(path);
		-- 骑上坐骑要收起武器
--CUSTOMTODO delete
--[[
		self.model:takeOffWeapon()
]]--
		-- print( string.format( "run Avatar:ride_a_mount mount_id=%d,path=%s",mount_id, path) )
		
		-- 潜规则 上坐骑的时候人物的光环要往下移
		local effect_node = self.model:getChildByTag(GUANGHUAN_EFFECT_TAG)

		local mount_pos_table=mount_offset_config

		-- 预防一下  add by gzn
		local tmp_offset = mount_pos_table[ mount_id ];
		if tmp_offset == nil then
			tmp_offset = -8;
		end

		if ( effect_node ) then
			effect_node:setPosition( CCPoint(0,-tmp_offset) );
		end
	end
end

function Avatar:change_mount( mount_id )
	self._setBodyJobQueue[SETBODYQUEUE_MOUNT] = function() self:_delay_change_mount( mount_id ) end
	EntityManager.setAvatarBody(self)
end


-- 改变坐骑的外观
function Avatar:_delay_change_mount( mount_id )

	if not ( ZXLuaUtils:band(self.state, EntityConfig.ACTOR_STATE_RIDE) > 0 ) then
		--如果没有乘骑坐骑，则不变化坐骑场景上的形象
		return;
	end

	if MountsModel:get_is_shangma() then
		local path = "frame/mount/"..mount_id;
		self.model:rideOnMount(path);
	end

	-- 潜规则 上坐骑的时候人物的光环要往下移
	local effect_node = self.model:getChildByTag(GUANGHUAN_EFFECT_TAG)
	
	local mount_pos_table=mount_offset_config

	-- 预防一下  add by gzn
	local tmp_offset = mount_pos_table[ mount_id ];
	if tmp_offset == nil then
		tmp_offset = -8;
	end

	if ( effect_node ) then
		effect_node:setPosition( CCPoint(0,-tmp_offset) );
	end
end

-- 下坐骑
function Avatar:get_down_mount(  )

	self._setBodyJobQueue[SETBODYQUEUE_MOUNT] = nil

	-- print("下坐骑..........................................")
	self.model:getDownMount()
	-- 下坐骑要拿起武器
	--print("self.weapon_name",self.weapon_name)
	--CUSTOMTODO delete
	--[[
	if self.weapon_name then
		self.model:putOnWeapon(self.weapon_name)
		
	end
	]]--
	if self.weapon_effect_name then
		self.model:putOnEffect(self.weapon_effect_name)
		-- self.model:showWeaponEffect(self.weapon_effect_name);
	end

	-- 潜规则 下坐骑的时候人物的光环要往上移
	local effect_node = self.model:getChildByTag(GUANGHUAN_EFFECT_TAG)
	if ( effect_node ) then
		effect_node:setPosition( CCPoint(0,0) );
	end
end

-- 设置根据角色当前属性的默认形象
-- 如果身体外形索引为0则应按照职业和性别设置默认的形象
-- 外观资源包编号规则：类型 + 职业 + 性别 + 等级 + 种类，共5位
-- 类型：0-衣服，2-时装，1用于武器
-- 职业和性别：0表示通用，否则表示对应的编号
-- 等级：int(角色真实等级 / 20)
-- 种类：如果最高位为0，则表示是否套装，0-散件，1-套装；如果最高位为2，则表示时装的编号
function Avatar:update_default_body( attri_value )
    --print("Avatar:update_default_body( attri_value )",attri_value,self.name)
	self._setBodyJobQueue[SETBODYQUEUE_BODY] = function() self:_delay_set_body( attri_value ) end
	EntityManager.setAvatarBody(self)
end

function Avatar:_delay_set_body( attri_value )
	-- print("_delay_set_body......................................................",attri_value,self.job);

	if SceneManager:get_cur_fuben() == 75  then
		if self.job and attri_value ~=  EntityFrameConfig:get_60lv_body_id( self.job ) then
			-- 特殊处理，在新手副本中，客户端给主角穿上60级装备
			-- 在玩家创建完毕的时候就会给玩家穿上60装备,所以这里直接返回
			return;
		end
	end

	if attri_value ~= 0  then

		--self.body 包含了2个数据，高位16是人物特效id，低16为是body的modelid
		local body_effect_id = ZXLuaUtils:highByte( attri_value );
		-- print("----更改body属性, 特效id", body_effect_id);

		self.body_id = ZXLuaUtils:lowByte( attri_value );
		
		if SceneManager:get_cur_scene() == 1077 then
			self.body_name =  EntityFrameConfig:get_xianyun_human_path( self.body_id )
			-- 在灵泉仙浴生成其他玩家是要隐藏掉其装备，翅膀，坐骑，人物特效
			self.model:stopEffect(GUANGHUAN_EFFECT_TAG);
		else
			self.body_name =  EntityFrameConfig:get_human_path( self.body_id );--string.format("frame/human/%05d" ,self.body );	
		    if ( body_effect_id~= 0 ) then
				-- print( "人物特效", body_effect_id );
				-- 播放人物特效
				local ani_table = effect_config[body_effect_id]
				-- 先删除之前的特效
				self.model:stopEffect(GUANGHUAN_EFFECT_TAG);
				-- 特定副本不显示角色光环
				if SetSystemModel:is_fuben_optimize() == false then 
					-- modify by msy@2014.05.29
					-- 这里修正了下，变身返回人物模型id可能找不到人物光环特效的情况，加个判断吧
					if  ani_table and ani_table[1] then
						self.model:playEffect( ani_table[1],GUANGHUAN_EFFECT_TAG,7,ani_table[3],nil,0 ,0,-5,ani_table[2]);
					end
				end
			else
				-- effect id 为0时候 删除之前的特效
				self.model:stopEffect(GUANGHUAN_EFFECT_TAG);
			end
		end
		
		-- print('Avatar:update_default_body',self.body_name,self.body_id)

		if self.model ~= nil then

			self.did_change_body = true;

			self:setBody( self.body_name )

			if ( self.state and ZXLuaUtils:band(self.state, EntityConfig.ACTOR_STATE_ZANZEN) > 0  ) then
				-- 如果是正在打坐中换了body，则紧接着打坐
				self.model:sitDown();
			end
			if (self.state and ZXLuaUtils:band(self.state, EntityConfig.ACTOR_STATE_RIDE) > 0) then
				self:playAction(7, self.dir, true);
			end
		end
	end
	
	--现在有body了，加载之前没加载的身体部件
	for i , slot_to_load in ipairs(self._slots_load_after_set_body) do
		slot_to_load()
	end
	self._slots_load_after_set_body = {}
end

-- 删除光环
function Avatar:remove_guanghuan()
	self.model:stopEffect(GUANGHUAN_EFFECT_TAG);
end

-- 更新武器
function Avatar:update_weapon( weapon_id )
	self._setBodyJobQueue[SETBODYQUEUE_WEAPON] = function() self:_delay_set_weapon( weapon_id ) end
	EntityManager.setAvatarBody(self)
end

function Avatar:_delay_set_weapon(weapon_id)
	-- print("Avatar:_delay_set_weapon(weapon_id)",weapon_id)
	-- body
	-- if self.state then
	-- 	if ( ZXLuaUtils:band(self.state, EntityConfig.ACTOR_STATE_RIDE) > 0 ) then
	-- 		-- 如果当前正在乘骑中，则不显示穿戴武器
	-- 		return;
	-- 	end
	-- 	if ( ZXLuaUtils:band(self.state, EntityConfig.ACTOR_STATE_ZANZEN) > 0  ) then
	-- 		-- 如果正在打坐中，则不显示穿戴武器
	-- 		return;
	-- 	end
	-- end

	-- 特殊处理，在新手副本中，客户端给主角穿上60级装备
	if SceneManager:get_cur_fuben() == 75 and self.model and self.job then
		weapon_id = EntityFrameConfig:get_60lv_weapon_id( self.job );
	end

	if weapon_id ~= 0 then

		self.weapon_effect_id = ZXLuaUtils:highByte(weapon_id);
		if self.weapon_effect_id ~= 0 then
			self.weapon_effect_name = "frame/effect/buff/"..self.weapon_effect_id;
		else 
			self.weapon_effect_name = nil;
		end

		self.weapon_id = ZXLuaUtils:lowByte(weapon_id);
		
		self.weapon_name = EntityFrameConfig:get_weapon_path( self.weapon_id ) --"frame/weapon/"..self.weapon;
		
		-- print("更新武器模型: "..self.weapon_name, "武器特效:", self.weapon_effect_name);
		
		if self.state then
			-- 天降雄师项目乘骑时候也有武器
			-- if ( ZXLuaUtils:band(self.state, EntityConfig.ACTOR_STATE_RIDE) > 0 ) then
			-- 	-- 如果当前正在乘骑中，则不许穿戴武器
			-- 	return;
			-- end
			if ( ZXLuaUtils:band(self.state, EntityConfig.ACTOR_STATE_ZANZEN) > 0  ) then
				-- 如果正在打坐中，则不显示穿戴武器
				return;
			end
		end

		if self.model then
			if self.weapon_name then
				self.model:putOnWeapon(self.weapon_name);
			end
			if self.weapon_effect_name then
				self.model:putOnEffect(self.weapon_effect_name)
				-- self.model:showWeaponEffect(self.weapon_effect_name);
			else
				self.model:takeOffEffect()
			end
		end

	else 
		-- 当weapon_id 为0时，把身上装备脱掉
		self.weapon_id = 0;
		self.weapon_name = nil;
		if self.model then
			self.model:takeOffEffect()
		end
		self.weapon_effect_name = nil;
		self:take_off_weapon();

	end
end

--卸下武器
function Avatar:take_off_weapon(  )
	if self.model ~= nil then
		self.model:takeOffWeapon();
		self._setBodyJobQueue[SETBODYQUEUE_WEAPON] = nil
		-- self.weapon_name = nil;
		-- self.weapon_effect_name = nil;
	end
end


function Avatar:update_wing_and_fabao( attri_value )
 	
 	local fabao_id = ZXLuaUtils:highByte( attri_value );
 
	if fabao_id ~= 0 then
		self:update_fabao( fabao_id );
	end

	local wing_id = ZXLuaUtils:lowByte( attri_value );
	-- print("Avatar:update_wing_and_fabao( attri_value )",wing_id)
	if wing_id ~= 0 then
		
		self:update_wing(wing_id);
	else
		-- print("卸下翅膀")
		self:take_off_wing();
	end
end 


function Avatar:update_wing( wing_id )
	-- print("Avatar:update_wing( wing_id )",wing_id);
	self._setBodyJobQueue[SETBODYQUEUE_WING] = function() self:_delay_set_wing( wing_id ) end
	EntityManager.setAvatarBody(self)
end

--戴上翅膀
function Avatar:_delay_set_wing( wing_id )
	--因为body在wing和weapon同步以后才发过来，但是装备是依赖body的
	--所以需要先存起来等有body了再加载
	if self.body_name == nil then
		self:slot_load_after_set_body(function() self:_delay_set_wing(wing_id) end)
		return
	end

	-- print("Avatar:_delay_set_wing( wing_id )",wing_id);
	if wing_id ~= 0 and  self.model ~= nil then

		self.wing_id = wing_id;
		self.wing_name = "frame/wing/"..self.wing_id;
		if SceneManager:get_cur_fuben() ~= 61 then
		    -- 特定副本场景不显示翅膀
		    --print("SetSystemModel:is_fuben_optimize()",SetSystemModel:is_fuben_optimize())
			if SetSystemModel:is_fuben_optimize() == false then 
				--如果是在灵泉仙浴里穿戴翅膀的话，则不显示出来
				self.model:putOnWing(self.wing_name);
			end
			-- print("self.model:putOnWing(self.wing_name);",self.wing_name)
		end
		-- print("self.wing_name",self.wing_name)
		
		if self.state ~= nil and  ZXLuaUtils:band(self.state, EntityConfig.ACTOR_STATE_ZANZEN) > 0  then
			-- 如果打坐的时候化形翅膀，则服务器下发更新翅膀后要恢复打坐
			self.model:sitDown();
		end
	end
end

--卸下翅膀
function Avatar:take_off_wing(  )
--CUSTOMTODO delete
---[[
	if self.model ~= nil then
		self.model:takeOffWing();
		self._setBodyJobQueue[SETBODYQUEUE_WING] = nil
		if self.type == -1 then
			WingModel:take_off_wing()
		end
	end
--]]--
end

--隐藏翅膀，但不卸下翅膀（进入灵泉仙浴时候的处理）
function Avatar:hide_wing()
	if self.model ~= nil then
		self.model:takeOffWing();
		self._setBodyJobQueue[SETBODYQUEUE_WING] = nil
	end
end

function Avatar:update_fabao( fabao_id )
	self._setBodyJobQueue[SETBODYQUEUE_FABAO] = function() self:_delay_set_fabao( fabao_id ) end
	EntityManager.setAvatarBody(self)
end

-- 显示法宝
function Avatar:_delay_set_fabao( fabao_id )
	if fabao_id ~= 0 and self.model ~= nil then
		self.fabao_id = fabao_id;
		self.fabao_name = string.format("frame/gem/%05d",self.fabao_id);
		-- 特定副本不显示角色法宝
		if SetSystemModel:is_fuben_optimize() == false then 
			print("self.model:showFabao(self.fabao_name)",self.fabao_name)
			-- self.model:showFabao(self.fabao_name);	
		end
	end
end
-- 隐藏法宝
function Avatar:hide_fabao(  )
	
	if self.model ~= nil then
		self.model:hideFabao();
		self._setBodyJobQueue[SETBODYQUEUE_FABAO] = nil
	end

end

function Avatar:change_avatar_dir_left(  )
	if self.model then
		self.model:changeAvatarDir(6);
	end
end
function Avatar:change_avatar_dir_right(  )
	if self.model then
		self.model:changeAvatarDir(0);
	end
end




-----------------------------------------------------------
--
--       下面是处理称号的代码
--
-----------------------------------------------------------

-- local TITLE_START_Y = 18;

-- -- 添加一个头顶上面的称号
-- function Avatar:add_title( title_index )
-- 	--print("Avatar:add_title( title_index )",title_index)
-- 	local path  = string.format("ui/title/%05d.png", title_index)
-- 	local image = CCZXImage:imageWithFile( 0, 0, -1, -1, path )
-- 	image:setAnchorPoint(0.5, 0);
-- 	self._title_component[title_index] = image
-- 	self:update_title()
-- end

-- -- 减少一个头顶上面的称号
-- function Avatar:remove_title( title_index )
-- 	if self._title_component[title_index] then
-- 		self._title_component[title_index]:removeFromParentAndCleanup(true)
-- 		self._title_component[title_index] = nil
-- 	end
-- 	self:update_title()
-- end

-- -- 宠物要增加宠物品阶称号
-- function Avatar:add_pet_pj( pj_value )
-- 	local wx =  ZXLuaUtils:lowByte(pj_value); --悟性
-- 	local cz =  ZXLuaUtils:highByte(pj_value); --成长
-- 	print("wx,cz",wx,cz);
-- 	--self.lab_pj_title = MUtils:create_zxfont("")
-- end

-- -- 更新头顶称号的位置
-- function Avatar:update_title(  )
-- 	--print("update_title")
-- 	local dy = TITLE_START_Y		-- 从18像素开始往上排称号 名字的16号字

-- 	-- 这里要排序
-- 	local key_list = {}
-- 	for k,component in pairs(self._title_component) do
-- 		table.insert(key_list, k)
-- 	end

-- 	table.sort(key_list)

-- 	for i,key in ipairs(key_list) do
-- 		local component = self._title_component[key]
-- 		if component:getParent() == nil then
-- 			self.model:getBillboardNode():addChild(component)
-- 		end
-- 		component:setPosition(0, dy)
-- 		dy = dy + component:getSize().height
-- 		component:setIsVisible(self._if_show_title)
-- 	end
-- end

-- -- 设置是否显示称号
function Avatar:set_if_show_title( if_show, is_shangma )
	self._if_show_title = if_show
	self:update_title( is_shangma )
end

function Avatar:playAction(action_id, dir, loop)
	--xprint('Avatar:playAction',action_id)
	loop = loop or false
	-- if self.lastAction == 2 then
	-- 	action_id = 3
	-- end

	-- hcl 2013/6/20 攻击动作不适用random，改成策划要求的普通攻击动作2，技能攻击动作1
	-- if self.action_count % 5 == 0 and 
	-- 	action_id == 2 or action_id == 3 then
	-- 	action_id = math.random(2,3)
	-- end

	self.last_action_id = action_id
	self.model:playAction(action_id, dir, loop)
	self.action_count = self.action_count + 1
end

function Avatar:update_qqvip(value)
	---------HJH 2013-9-12
    ---------qqvip and role name
    -- print("Avatar:update_qqvip value", value)
    if self.model == nil then
    	return
    end
    QQVipInterface:reinit_info( self.role_name_panel, value, self.model.name )
end

function Avatar:setBodyQueue()
	-- body
	-----------------------------------------
	local k,job = next(self._setBodyJobQueue)
	if not k then
		return true
	end
	-----------------------------------------
	job()
	self._setBodyJobQueue[k] = nil
	-----------------------------------------
	k,job = next(self._setBodyJobQueue)
	if not k then
		return true
	end
	-----------------------------------------
	return false
end


function Avatar:stopMovmentCheck()
	self.movment_check_timer:stop()
end

function Avatar:showFootStep(footstep_id)
	--footstep_id = 9999
	self.footstep_id = footstep_id
	if footstep_id == nil then
		self:stopMovmentCheck()
	else
		local lx, ly = self.model:getPosition()
		self.lx = nil 
		self.ly = nil

		local ani_table = effect_config[footstep_id];
		local offsetY = ani_table[effect_config_iOffsetY]

		if self.movment_check_timer:isIdle() then
			self.movment_check_timer:start(0.4,
			function(dt)
				local mx, my = self.model:getPosition()
				if self.lx ~= mx and self.ly ~= my then
					LuaEffectManager:play_map_effect( self.footstep_id, mx, my + offsetY,false,10000,199 )
				else
					self.movment_check_timer:stop()
				end
				self.lx = mx
				self.ly = my
			end)
		end
	end
end

-- 开始朝某个方向移动
function Avatar:startMoveFrom( cur_x, cur_y, target_x, target_y )
	-- print(string.format("来到Actor start move: %d %d %d %d", cur_x, cur_y, target_x, target_y), self.scheduler_id)
	-- 不需要跟服务器做同步
	-- self.x = cur_x
	-- self.y = cur_y
	--xprint('startMoveFrom')
	self:face_to(target_x, target_y)
	self.model:startMove(self.dir, cur_x, cur_y, target_x, target_y)

	if self.footstep_id then
		self:showFootStep(self.footstep_id)
	end
end

--由Action驱动的移动事件
function Avatar:startMove(tx,ty,IdleOnStopMove)
	self:face_to(tx, ty)
	--print('startMove @@@@@@@@@@@@@@@@@dir=',self.dir)
	self.model:startMove(self.dir, 
						 self.x, self.y, 
						 tx, ty,
						 IdleOnStopMove)

	if self.footstep_id then
		self:showFootStep(self.footstep_id)
	end
end

function Avatar:stopMove()
	self.model:stopMove(self.x, self.y)
end

-- 结束移动
function Avatar:stopMoveAt(x,y)
	self.model:stopMove(x, y)
end

function Avatar:change_run_effect(value)	
	local foot_index = ZXLuaUtils:lowByte(value)
	--print("foot_index",foot_index)
	if foot_index > 0 then
		local effect_id = effect_config:index_to_foot_effect_id(foot_index)
		--print("Avatar:change_run_effect value---------------------", value, foot_index)
		self:showFootStep(effect_id)
	else
		self:showFootStep(nil)
	end
end

function Avatar:_jumpTime(tx,ty)
	local m = self.model
	local dx = tx - m.m_x
	local dy = ty - m.m_y
	local d = dx * dx + dy * dy
	return _math_max(d / JUMPTIME_MOD * JUMPING_ACTION_T,0.5)

end

function Avatar:_onPrepareJump(jump_time,tx,ty)
	-- body
	self.model:playAction(ZX_JUMPING_ID,self.dir,true)
	local p = CCPointMake(tx,ty)
	SceneManager.game_scene:mapPosToGLPos(p)
	local j = CCJumpTo:actionWithDuration(jump_time,p,JUMPING_DEFAULT_HEIGHT,1);
	self.model:runAction(j)
	SoundManager:playUISound('jump',false)
end

function Avatar:_onEndJump()
	self._jumping = false
	if self.model then
		self.model:playAction(ZX_JUMP_FINISH_ID,self.dir,false)
		local action = self.jumpLandingAction
		if action then
			self.jumpLandingAction = nil
			action()
		end
		 self:setShadowTail(false)
	end
end

		--
function Avatar:jump(tx,ty,action)
	local m = self.model

	if self.jumpCallbacks then
		for i, cb in ipairs(self.jumpCallbacks) do
			cb:cancel()
		end
	end
	local jump_time = self:_jumpTime(tx,ty)
	local old_dir = self.dir
	-- 停止移动,准备瞬间移动
	self.dir = self.model:prepareTeleport(tx,ty)
	self.dir = old_dir

	self.model:playAction(ZX_JUMP_PREPARE_ID,self.dir)

	local cb1 = callback:new()
	local cb2 = callback:new()

	cb1:start(JUMP_PREPARE_ACTION_T, function()
		self:_onPrepareJump(jump_time,tx,ty)
	end)

	cb2:start(jump_time + JUMPING_LAND_ACTION_T, function()
		self:_onEndJump()
	end)

	self.jumpCallbacks = { cb1, cb2 }

	self.jumpLandingAction  = action

	self._jumping = true
end

function Avatar:teleportAction(tel_effect_id, pos_x, pos_y, jumpLandAction)
	-- body
	self:face_to(pos_x, pos_y)
	self._teleporting = true
	local _telQueue = teleport_action_effect[tel_effect_id]
	local _queue_i = 1
	local function _jumpLandFunc()
		if _is_need_reset_shangma then
			_is_need_reset_shangma=false
			MountsModel:ride_a_mount( )
		end
		if jumpLandAction then
			jumpLandAction()
		end
	end
	local function _nextJump()
		if _queue_i > #_telQueue then
			self._teleporting = false
			self._is_end_jump=true
			self:jump(pos_x,pos_y,_jumpLandFunc);
		else
			local is_shangma = MountsModel:get_is_shangma(  )
			if ( is_shangma ) then
				_is_need_reset_shangma=true
				MountsModel:ride_a_mount( )
			end
			local p = _telQueue[_queue_i]
			_queue_i = _queue_i + 1
			self:jump(p[1]*32,p[2]*32,_nextJump);
		end
	end
	_nextJump()
end

function Avatar:isActionBlocking()
	return self._jumping or self._teleporting
end


function Avatar:createShadowAction(action)
	--[[
	local path = self.body_path
	LoadFrameTextureAsync(path, function(_filename)
	if not _filename then
		return
	end
	
	local _model = self.model
	if not _model then
		return
	end
	local r = math.random(1,2)
	if r == 1 then
		local dir = self.dir
		local speed = ( self.attackSpeed or 700 ) / 1000

		callback:new():start(0.2, function()
			local sp = effectCreator.createEffect_entityAction(path,
															   eAnimationAvatar,
															   action,
															   dir,
															   false,
															   speed + 0.12)
			sp:setColor(ccc3(0,0,0))
			sp:setOpacity(200)

			_cpplogicScene:addChildSceneLayer( sp,
									   2, 
									   _model.m_x, _model.m_y , 20,
									   0)
		end)
	
	elseif r == 2 then
		local dir = 6
		local x = 100
		if self.dir >= 4 and self.dir <= 7 then
			dir = 2
			x = -100
		end
		local speed = ( self.attackSpeed or 700 ) / 1000

		callback:new():start(0.2, function()
			local sp = effectCreator.createEffect_entityAction(path,
															   eAnimationAvatar,
															   action,
															   dir,
															   false,
															   speed + 0.12)
			sp:setColor(ccc3(0,0,0))
			sp:setOpacity(200)
			_cpplogicScene:addChildSceneLayer( sp, 2, _model.m_x + x, _model.m_y,20,0)
		end)
	end

	end)
	]]
end

function Avatar:stopShadowAction(action)
	--self:setShadowTail(false)
end

function Avatar:update_name( is_shangma )
	-- if self.model and self.name_lab then
	-- 	local bill_board_node      = self.model:getBillboardNode();
	-- 	local bill_board_node_size = bill_board_node:getContentSize();
	-- 	local name_lab_size = self.name_lab:getSize();
	
	-- 	if self.name_lab then
	-- 		self.name_lab.view:setAnchorPoint( CCPointMake(-0.5,0) );
	-- 	end

	-- 	if is_shangma then
	-- 		self.name_lab.view:setPosition( ( bill_board_node_size.width - name_lab_size.width ) / 2, 30 )
	-- 	else
	-- 		self.name_lab:setPosition( ( bill_board_node_size.width - name_lab_size.width ) / 2, 0 )
	-- 	end
	-- end

	-- by yongrui.liang 14/6/14
	if self.model and self.role_name_panel then
		local temp_panel_size = self.role_name_panel:getSize()
	    local bill_board_node = self.model:getBillboardNode()
	    local bill_board_node_size = bill_board_node:getContentSize()
		if is_shangma then
			self.role_name_panel.view:setPosition( ( bill_board_node_size.width - temp_panel_size.width ) / 2, 30 )
		else
			self.role_name_panel.view:setPosition( ( bill_board_node_size.width - temp_panel_size.width ) / 2, 0 )
		end
	end
end

function Avatar:addBloodBar( max_hp )
	if self.hp_bg then return end
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

function Avatar:changeBlood(change_hp,hp,max_hp)
	if not self.hp_bg then
		self:addBloodBar(max_hp)
	end
	local player = EntityManager:get_player_avatar()
	if not player:can_attack_target(self) then
		return
	end
	if self.hp_bg and self.hp_bar and change_hp ~= 0 and hp > 0 then
		self.hp_bg:setIsVisible(true)
		self.hp_bar:update_hp(change_hp,hp,max_hp)
		self.hp_bar2:setTextureRect(CCRect(0, 0, 84 *hp/max_hp, 6))
		self.hp_bar2:setPosition(0, 0)
	elseif hp <= 0 and self.hp_bar then
		self.hp_bar:destroy()
		self.hp_bar = nil
		self:show_hide_blood(false)
	end
end

function Avatar:destroyBlood()
	if self.hp_bar then
		self.hp_bar:destroy()
		self.hp_bar = nil
	end
	if self.hp_bg then
		self.hp_bg:removeFromParentAndCleanup(true)
		self.hp_bg = nil
	end
end

function Avatar:show_hide_blood(flag)
	if self.hp_bg then
		self.hp_bg:setIsVisible(flag)
	end
end