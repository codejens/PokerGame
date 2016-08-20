-- PlayerAvatar.lua
-- created by aXing on 2012-12-1
-- 游戏场景中主角玩家的实体类

require "entity/Avatar"
require 'effect/TimeLerp'
require "utils/bit"
-- require "control/MoveCC"
-- require "config/SkillConfig"
-- require "action/ActionConfig"
local _refWidth =  UIScreenPos.relativeWidth
local _refHeight = UIScreenPos.relativeHeight

PlayerAvatar = simple_class(Avatar)

-- 记录连续移动路点(x,y,...)
local _Astar_path = {}
-- 记录当前去到哪个路点
local _current_path_index = 1
-- 记录当前动作
local _current_action = nil
-- 记录下一个动作
local _next_action = ZX_ACTION_IDLE
-- 等待动作队列
local _waiting_queue = {}
-- 后续的动作队列
local _continue_queue = {}
-- 当前的移动目标坐标
local _cur_target_x = 0
local _cur_target_y = 0
-- 当前是否需要广播移动协议
local _need_update_move = false
local old_selected_entity = nil;

local _BLOOD_HIDE_DELAY = 4 --血条销毁时间
function PlayerAvatar:get_curaction()
	return _current_action
end

-- 取得是否可打断当前action
function PlayerAvatar:is_can_break_action()
	if ( _current_action and _current_action.can_break == false ) then
		return false;
	end
	return true;
end

function PlayerAvatar:get_waiting_queue()
	return _waiting_queue
end

function PlayerAvatar:get_continue_queue()
	return _continue_queue
end

-- 判断是否能成为目标
function PlayerAvatar:can_attack_target( target )

	--print("target.type = ",target.type );

	-- 判断
	-- 如果目标是自己，或者目标已死，则不能攻击
	if target == self  then
		print("PlayerAvatar:can_attack_target:不能攻击目标:不能攻击自己")
		return false
	end
	-- 传送门不能攻击
	if ( target.type == 9 or target.type == 12 ) then
		print("PlayerAvatar:can_attack_target:不能攻击目标:传送门不能攻击")
		return false;
	end

	-- NPC不能攻击
	if EntityConfig:is_npc(target.type) then
		print("PlayerAvatar:can_attack_target:不能攻击目标:NPC不能攻击")
		return false
	end
	-- 判断怪物是否不能攻击( 有些怪物是自己人不能攻击 )
	if ( ZXLuaUtils:band(target.state, EntityConfig.ACTOR_STATE_ATTACK_FORBIDEN) > 0 ) then
		print("PlayerAvatar:can_attack_target:目标不能被攻击")
		return false;
	end
	-- 如果目标已经死亡
	if ( ZXLuaUtils:band(target.state, EntityConfig.ACTOR_STATE_DEATH) > 0 ) then
		print("PlayerAvatar:can_attack_target:不能攻击目标:目标已死亡 ");
		return false;
	end
	-- 采集怪不能攻击
	if ( target.type == 12 ) then
		print("PlayerAvatar:can_attack_target:采集怪不能攻击")
		return false;
	end
	--print("self.camp,target.camp",self.camp,target.camp);
	-- 如果是玩家
	if EntityConfig:is_player(target.type) or EntityConfig:is_pet( target.type ) then
		-- TODO:: 这里还有很多判断，以后添加
		-- 和平模式：不可攻击任何玩家，也不可以被任何玩家攻击
		-- 队伍模式：不可攻击同队伍中的玩家，可攻击本队伍以外的非和平模式玩家
		-- 仙宗模式：不可攻击同仙宗玩家，可攻击本仙宗以外的非和平模式玩家
		-- 阵营模式：不可攻击同阵营玩家，可攻击本阵营以外的非和平模式玩家
		-- 全体模式：可攻击全部非和平模式玩家
		-- 联盟模式：（特殊模式）不可攻击联盟阵营玩家
		print("target.pkMode",target.pkMode,self.pkMode);
		if (  EntityConfig:is_pet( target.type ) ) then
			target = EntityManager:get_entity( target.master_handle );
			print("判断宠物的主人",target.name);
		end

		-- 判断当前场景是否安全区
		local tx,ty = SceneConfig:pos2grid( target.model.m_x ,target.model.m_y );
		if  SceneConfig:get_curr_scene_can_pk( tx,ty ) == false then
			print("PlayerAvatar:can_attack_target:不能攻击目标:在安全区")
			return false
		end
		if ( self.pkMode == 0 or target.pkMode == 0   ) then
			print("PlayerAvatar:两人都是和平模式")
			return false;
		elseif ( self.pkMode == 1 ) then
			if ( TeamModel:is_teammate( target.id ) ) then
				print("PlayerAvatar:can_attack_target:队伍模式:不能攻击队友");
				return false;
			end
		elseif ( self.pkMode == 2 ) then
			--print("player.guildName,target.guildName",player.guildName,target.guildName);
			if ( self.guildName ~= "" and target.guildName~= "" and self.guildName == target.guildName  ) then
				print("PlayerAvatar:can_attack_target:帮派模式:不能攻击同帮派的玩家")
				return false;
			end
			if ( TeamModel:is_teammate( target.id ) ) then
				print("PlayerAvatar:can_attack_target:帮派模式:不能攻击队友");
				return false;
			end
		elseif ( self.pkMode == 3 ) then
			if ( self.camp ~= 0 and target.camp~=0 and self.camp == target.camp  ) then
				print("PlayerAvatar:can_attack_target:阵营模式:不能攻击同阵营的玩家")
				return false;
			end
		elseif ( self.pkMode == 4 ) then

		elseif  ( self.pkMode == 5 ) then
			local lianmeng_info = FubenTongjiModel:get_league_data(  );
			-- 联盟模式的需要判断联盟id
			if ( lianmeng_info ~= nil ) then
				print("")
				if ( lianmeng_info[target.camp] == 1 ) then
					print("PlayerAvatar:can_attack_target:联盟模式:不能攻击同联盟阵营")
					return false;
				end
			end 
			
		end

	-- 怪物也有阵营
	elseif EntityConfig:is_monster(target.type) then
		if ( self.camp ~= 0 and target.camp~= 0 and self.camp == target.camp  ) then
			print("阵营模式:不能攻击同阵营的玩家")
			return false;
		end
		return true;
	-- elseif  then
	-- 	-- 判断当前场景是否安全区
	-- 	local tx,ty = SceneConfig:pos2grid( target.model.m_x ,target.model.m_y );
	-- 	if  SceneConfig:get_curr_scene_can_pk( tx,ty ) == false then
	-- 		print("不能攻击目标:在安全区")
	-- 		return false
	-- 	end
	-- 	return true;
		end

	return true
end

-- 获取动作序列的最高优先级别
local function get_action_queue_priority( queue )
	local max = ActionConfig.PRIORITY_NONE
	for k,action in pairs(queue) do
		max = math.max(max, action.priority)
	end
	return max
end

-- 公有函数

function PlayerAvatar:__init( handle )
	Avatar.__init(self,handle)

	self.type = "PlayerAvatar"

	require "model/MiniMapModel"
	local function tick( dt )
		self:think(dt)
	end
	self.think_timer = timer()
	self.think_timer:start(t_pavtr_,tick)

	-- 待机时间
	self.stand_time = 0;
	-- 使用药品的cd
	self.use_blood_bottle_cd = ItemModel:get_item_cd_time( 18302 ) / 1000;
	self.use_magic_bottle_cd = ItemModel:get_item_cd_time( 18310 ) / 1000;
	self.is_use_blood_bottle = false;
	self.is_use_magic_bottle = false;
	-- 是否正在进行剧情动画，剧情动画的时候不能打坐
	self.is_jqdh = false;
	self.mvzs_zy = false;
	self.entity_type = EntityConfig.TYPE_PLAYER_AVATAR 

	ZXPlayerAvatar:setCameraMoveLimit(80, 32);


	self.zoomer = TimeLerpSin()

	self._jump_zoom = true

	self._teleporting = false

end

-- 实体析构(主角的一般不会调用)
function PlayerAvatar:destroy(  )
	print("PlayerAvatar.destroy.........................")
	self.think_timer:stop()

	self.zoomer:stop()

	-- AIManager:fini()
	Avatar.destroy(self)
	_Astar_path = {}
	_current_path_index = 1
	_current_action = nil
	_next_action = ZX_ACTION_IDLE
	_cur_target_x = 0
	_cur_target_y = 0
	_need_update_move = false
	old_selected_entity = nil;

	if _current_action ~= nil then
		_current_action:stop_action()
		_current_action = nil
	end

	for i,v in ipairs(_waiting_queue) do
		v:stop_action()
	end
	_waiting_queue = {}

	for i,v in ipairs(_continue_queue) do
		v:stop_action()
	end
	_continue_queue = {}
end

-- 主角属性变更函数
function PlayerAvatar:change_entity_attri( attri_type, attri_value )
     -- print("主角属性:::   ", attri_type, attri_value)
	local old_value 	= self[attri_type]
	Avatar.change_entity_attri(self, attri_type, attri_value)
	self[attri_type]	= attri_value
	
	-- 以下是主角属性变更的时候，触发的事件
	if attri_type == "model"  then
		self.model = ZXEntityMgr:toPlayerAvatar(attri_value)
		if self.model == nil then
			print("ERROR:: entity转换player avatar出错！")
			return
		end
	elseif attri_type == "hp" then
		local win = UIManager:find_window("user_panel");
		if ( self.hp and self.maxHp ) then
			if ( win ) then
				local change_hp = 0;
				if ( old_value ) then
					change_hp = self.hp - old_value;
				end
			 	win:update(5,{ self.hp,self.maxHp,change_hp });
			end
			--角色头上血条管理
			if not self.hp_bg then
				self:addBloodBar(self.maxHp)
			else
				local change_hp = 0;
				if ( old_value ) then
					change_hp = self.hp - old_value;
				end
				self:changeBlood(change_hp, self.hp,self.maxHp)
			end
		end
	elseif attri_type == "mp" then
		-- 要更新主界面玩家的法力值
		local win = UIManager:find_window("user_panel");
		if ( win ) then
			if ( self.mp and self.maxMp ) then
			 	win:update(8,{ self.mp,self.maxMp });
			end
		end	
	elseif attri_type == "yuanbao" then
		-- TODO:: 当主角 元宝 改变的时候
		MallModel:date_change_udpate( attri_type )

		-- 神秘商店
		MysticalShopModel:update_win( "yuanbao" )

		JiShouModel:update_yb_yl()
		-- 梦境
		DreamlandModel:update_yuanbao( )
		--法宝系统
		FabaoModel:update_yb_yl()

		--神秘商店
		ShenMiShopModel:update_yuanbao(  )

	elseif attri_type == "bindYuanbao" then
		-- TODO:: 当主角 绑定元宝 改变的时候
		MallModel:date_change_udpate( attri_type )
      
		-- 神秘商店
		MysticalShopModel:update_win( "bindYuanbao" )
		-- 梦境
		DreamlandModel:update_bindYb( )

	

	elseif attri_type == "yinliang" then
		-- 如果打开了灵根，要更新灵根界面
		local win = UIManager:find_visible_window("linggen_win");
		if ( win ) then
			win:update_view()
		end
		JiShouModel:update_yb_yl()
		-- TODO:: 当主角 银两 改变的时候
		-- 	--法宝系统
		-- FabaoModel:update_yb_yl()

	elseif attri_type == "bindYinliang" then
		-- TODO:: 当主角 忍 改变的时候
		--法宝系统
		FabaoModel:update_yb_yl()
	elseif attri_type == "guildId" then
		-- TODO:: 当主角 仙宗 改变的时候
        GuildModel:update_user_guild_date( "guildId" )
    elseif attri_type == "lilian" then
		-- TODO:: 当主角 历练 改变的时候
        ExchangeModel:date_change_udpate( attri_type )

    elseif attri_type == "honor" then 
    	ExchangeModel:date_change_udpate( attri_type )
	elseif attri_type == "sysOpenState" then
		-- 当玩家系统开启状态发生改变的时候
		GameSysModel:update_state(attri_value);
	elseif attri_type == "level" then
		if ( self.model ) then
			-- 播放升级特效
			local ani_table = effect_config[20];
			self.model:playEffect(ani_table[1],20,2,ani_table[3],nil,0,0,500,ani_table[2],-15,115);
			-- local ani_table2 = effect_config[10008];
			-- -- 升级字
			-- ZXLogicScene:sharedScene():playEffect(ani_table2[1],ani_table2[3],ani_table2[2]);
			--xiehande 屏蔽升级
			-- LuaEffectManager:play_scene_effect( 10008,_refWidth(0.5), _refHeight(0.6),999 )
			-- -- 播放升级音效 
			SoundManager:playUISound('level_up',false)
		end
		-- print("---------------old_value,attri_value",old_value,attri_value)
		if ( old_value and old_value ~= attri_value ) then 
			-- print("old_value and old_value ~= attri_value ")
			local win = UIManager:find_window("user_panel");
			if ( win ) then
				win:update_lv_up();
			end
			local win = UIManager:find_window("right_top_panel")
		    if win then
		    	win:check_sys_open_state( true );

			    if old_value <= 21 and attri_value >= 22 then
			    	-- 刚从21级升级到22级或连续升几级的时候，让右上角的“开服活动”按钮闪烁
			    	-- 代码中已经避免了重复添加特效的问题，所以这里不必预防
					win:shanshuo_btn( 3, true )
			    end
		    end

		    -- 当前是否已打开坐骑界面
		    local mounts_win = UIManager:find_visible_window( "mounts_win_new" );
		    if mounts_win then
		    	-- "坐骑洗练"标签,要求在45级才能开启
		    	-- if old_value < 45 and attri_value >=45 then
		    	-- 	mounts_win:update_xilian_visible( true );
		    	-- end
		    	-- "坐骑灵犀"标签,要求在50级才能开启
		    	if old_value < 50 and attri_value >= 50 then
		    		mounts_win:update_lingxi_visible( true );
		    	end
		    end

		    if old_value < 20 and attri_value >= 20 then
		    	LinggenModel:check_lingqi_minibtn()
		    end

		    EventSystem.postEvent("levelUp", attri_value)
		    if PlatformInterface.onPlayerLevelUp then
    			PlatformInterface:onPlayerLevelUp()
    		end
		end

		local win2 = UIManager:find_window("right_top_panel")
	    if win2 then
	    	win2:reset_first_row_btns_pos( )
	    	win2:update_activity_remain_tips()
	    end

	    MallModel:handle_taozhuang(  )

		EntityManager:update_all_fb_npc()
		ActivityWin:update_page_tips()
		-- BenefitModel:show_benefit_miniBtn()
	
		if PlatformInterface.userInfo then
			PlatformInterface:userInfo()
		end
		
	elseif attri_type == "anger" then
		-- 更新怒气值
		local win = UIManager:find_window("menus_panel");
		if ( win ) then
			win:updateAngerBar(self.anger);
		end
	elseif attri_type == "pkMode" then
		-- pk模式
		local win = UIManager:find_visible_window("user_panel");
		if ( win ) then
			win:update(9,{ self.pkMode });
		end
	elseif attri_type == "expH" then
		if ( old_value ) then
			-- 更新经验值
			local win = UIManager:find_window("exp_panel");
			if ( win ) then
				win:updateExp();
			end
		end
	-- 更新灵气
	elseif attri_type == "lingQi" then
		local win = UIManager:find_visible_window("linggen_win");
		if ( win ) then
			win:update_lingqi();
			win:update_view();
		end
		TransformModel:update_right_win()
	elseif attri_type == "job" then
		-- 初始化必杀技和普通攻击
		self:init_bsj_and_normal_attack()
	elseif attri_type == "weapon" then
		-- print("PlayerAvatar -- 主角的属性发生变化",attri_type, attri_value);
		self:update_weapon( attri_value );
	elseif attri_type == "sex" then
			-- print("修改左上角的人物头像", attri_value);
		-- 修改左上角的人物头像
		local user_panel = UIManager:find_visible_window("user_panel");
		if user_panel then
			user_panel:update_head( attri_value );
		end

		-- 如果人物界面有打开，修改人物形象
		local user_attri_win = UIManager:find_visible_window("user_equip_win");
		if user_attri_win then
			user_attri_win:update_equip_panel_model( "body" );
		end

		-- 如果翅膀界面有打开
		-- local wing_win = UIManager:find_visible_window("wing_sys_win");
		-- if wing_win then
		-- 	wing_win:update_all_avatar_body();
		-- end
		WingModel:updateWingLeftWin()

	elseif attri_type == "fightValue" then
		if ( old_value ) then
			LuaEffectManager:play_fight_value_effect( self.fightValue,old_value )
			local win = UIManager:find_visible_window("user_panel") 
			if win then 
				win:update_fight_value( self.fightValue )
			end
		end
	
	elseif attri_type == "attackSpeed" then
		UserSkillModel:set_simple_attack_with_attackSpeed(self.attackSpeed / 1000)
		
	elseif attri_type == "renown" then
		local win = UIManager:find_visible_window("genius_win");
		if win then
			win.lunhui_panel:update_sprite_info();
		end
		WingModel:updateWingRightWin("renown")
	elseif attri_type == "state" then
		if attri_value and ZXLuaUtils:band(self.state, EntityConfig.ACTOR_STATE_BATTLE) > 0 then
			self:show_hide_blood(true)
		else
			self:show_hide_blood(false)
		end
	end

	if ( old_value  ) then 
		-- 执行属性变化时的动画
		self:save_attr_animation( attri_type,old_value,attri_value )
	end

    -- 更新数据
	PlayerAvatar:do_model_update( attri_type )
end

-- 即将要播放的属性变化动画列表
local attr_change_animation_table = {};

-- 记录属性变化
function PlayerAvatar:save_attr_animation( attri_type,attr_old,attr_new )
	local attr_str = "";
	if ( attri_type == "maxHp" ) then 
		attr_str = attri_type;
		-- 要更新主界面玩家的生命值
		local win = UIManager:find_window("user_panel");
		if ( win ) then
			if ( self.hp and self.maxHp ) then
				local change_hp = self.hp - attr_old;
			 	win:update(5,{ self.hp,self.maxHp,change_hp });
			end
		end
		if ( self.hp and self.maxHp ) then
			--角色头上血条管理
			if not self.hp_bg then
				self:addBloodBar(self.maxHp)
			else
				local change_hp = self.hp - attr_old;
				self:changeBlood(change_hp, self.hp,self.maxHp)
			end
		end
		if ( self.hp and self.maxHp ) then
			--角色头上血条管理
			if not self.hp_bg then
				self:addBloodBar(self.maxHp)
			else
				local change_hp = self.hp - attr_old;
				self:changeBlood(change_hp, self.hp,self.maxHp)
			end
		end
	elseif ( attri_type == "maxMp" ) then 
		attr_str = attri_type;
		-- 要更新主界面玩家的法力值
		local win = UIManager:find_window("user_panel");
		if ( win ) then
			if ( self.mp and self.maxMp ) then
			 	win:update(8,{ self.mp,self.maxMp });
			end
		end	
	elseif ( attri_type == "outAttack" ) then 
		attr_str = attri_type;
	elseif ( attri_type == "outDefence" ) then 
		attr_str = attri_type;
	elseif ( attri_type == "innerAttack" ) then 
		attr_str = attri_type;
	elseif ( attri_type == "innerDefence" ) then 
		attr_str = attri_type;
	elseif ( attri_type == "criticalStrikes" ) then 
		attr_str = attri_type;
	elseif ( attri_type == "dodge" ) then 
		attr_str = attri_type;
	elseif ( attri_type == "hit" ) then 
		attr_str = attri_type;				
	end
	if ( attr_str ~= "") then
		-- 因为必须要顺序播放这些动画，所以必须要先记录下来
		--ZXEffectManager:sharedZXEffectManager():run_attr_change_action( self.model:getBillboardNode(),attr_str..(attr_new-attr_old) );
		local differ = attr_new - attr_old
		--table.insert(attr_change_animation_table, { attr_str , differ } );
		self:play_attr_animation(attr_str,differ)
		--print("attr_str = ",attr_str..( attr_new - attr_old ));
	end
end

-- 属性更新的执行飘属性的动画
function PlayerAvatar:play_attr_animation( attr_str, differ)

	--if ( #attr_change_animation_table > 0 ) then
		--if ( self.is_playing_attr_animation == nil or self.is_playing_attr_animation == false )	then
		--	self.is_playing_attr_animation = true;
	--local attr_table = table.remove(attr_change_animation_table, 1);
		--local yOffset = self.model:getPositionY()
	--local v = attr_table[2],
	-- print("PlayerAvatar:play_attr_animation(differ,self.handle,attr_str,FLOW_COLOR_TYPE_BLUE)",differ,self.handle,attr_str,FLOW_COLOR_TYPE_BLUE)
	if differ > 0 then
		TextEffect:FlowAttr(self.handle,attr_str,FLOW_COLOR_TYPE_BLUE,'+' .. tostring(differ))
	else
		TextEffect:FlowAttr(self.handle,attr_str,FLOW_COLOR_TYPE_RED,tostring(differ))
	end
			--[[
			local attr_ani_timer = timer();
			local function dismiss( dt )
				
				ZXEffectManager:sharedZXEffectManager():run_attr_change_action( self.model:getBillboardNode(),attr_str );
				if ( #attr_change_animation_table == 0 ) then
			        attr_ani_timer:stop();
			        self.is_playing_attr_animation = false;
			    end
		    end
		    attr_ani_timer:start( t_attr_speed,dismiss)
		    ]]--
		--end
	--end
end

-- 释放技能
function PlayerAvatar:use_skill( skill )

	if self:is_dead() then
		-- 如果挂了，就不能放技能了
		return
	end

	-- 只要技能没有cd，就可以释放
	if skill.cd == 0 then
		-- 当没有目标的时候，去寻找最近的目标
		if self.target_id == nil or EntityManager:get_entity(self.target_id) == nil then
			self.target_id = EntityManager:find_nearest_target(1)
			if self.target_id == nil then
				-- 找不到目标
				return		
			end
		end

		local target = EntityManager:get_entity(self.target_id)

		self:set_target(target)
		-- 判断该技能是否满足释放条件
		if self:can_use_skill(skill, target) then
			self.next_skill = skill
			self:set_next_action(ZX_ACTION_HIT)
		end
	else
		print("技能在冷却中")
	end
end

-- 设置主角当前目标
function PlayerAvatar:set_target( target )

	-- 首先更新主界面 如果当前选中的目标是之前的目标，那么只更新它的Hp,mp
	-- 更新主界面
	local win = UIManager:find_window("user_panel");
	if ( win and target) then
		if ( self.target_id == nil or self.target_id ~= target.handle) then
			win:update_other_entity(target);
			--print("user_panel:update_other_entity.......................")
		end
	end
	--print("action_time4.....................",GameStateManager:get_total_milliseconds(  ))
	-- 取得玩家的宠物
	local pet = EntityManager:get_player_pet();
	-- 目标能否被攻击
	local can_attack_target = false;
	if ( target == nil ) then
		self.target_id = nil;
		-- 隐藏掉选中的目标 
		win:set_select_entity_panel_visible(false);
		-- AIManager设置旧的选中目标为空
		AIManager:on_clear_select_target(  );
		if ( pet ) then
			pet.target_id = nil;
		end
		-- 更新主界面的动作按钮状态
		local win = UIManager:find_visible_window("menus_panel")
		if ( win ) then
			win:set_action_btn_state( 1 )
		end
	else
		self:on_select_target( target );
		--print("action_time5.....................",GameStateManager:get_total_milliseconds(  ))
		-- 如果能够攻击目标的话，就把人物和宠物都设置改实体为攻击目标
		can_attack_target = self:can_attack_target( target );
		-- print("can_attack_target",can_attack_target);
		if ( can_attack_target ) then 
			self.target_id = target.handle;
			if ( pet ) then
				pet.target_id = target.handle;
			end
		else
			self.target_id = nil;
			if ( pet ) then
			    pet.target_id = nil;
			end
		end
		-- 
		if target and target.model then                    -- 设置系统，如果设置不显示怪物名称。选中的时候，要把怪物名称显示
	        target.name_lab.view:setIsVisible( true )
	        --target.model:showName( true )
	    end
		if ( target ) then
		--	print("action_time6.....................",GameStateManager:get_total_milliseconds(  )) 
			-- 交给AIManager处理选中后的事件
			AIManager:on_selected_entity(target,can_attack_target);
			--print("action_time7.....................",GameStateManager:get_total_milliseconds(  ))
		end
	end
	print("PlayerAvatar:set_target:",target)
	
end

-- 玩家选中一个角色时要做的操作
function PlayerAvatar:on_select_target( entity )
	local color = EntityConfig.SELECT_COLOR_ENTITY[entity.type] or EntityConfig.SELECT_COLOR_DEFAULT
	if ( old_selected_entity ) then
		-- 如果选中的是同一个就不重新生成特效
		if ( old_selected_entity.handle == entity.handle ) then

        else
        	-- 重新取旧实体，看它是否还存在
	        old_selected_entity = EntityManager:get_entity( old_selected_entity.handle );
			if ( old_selected_entity and old_selected_entity.model ) then 
				--print("old_selected_entity",old_selected_entity.handle,old_selected_entity.name)
				-- 停止旧的特效
				if ( old_selected_entity.type ~= 9 ) then
					old_selected_entity.model:stopEffect(7)
					old_selected_entity.model:SetSelected(false)
				end
			end
			-- 传送门不播放选中特效
			if (  entity.type ~= 9 ) then 
				local ani_table = effect_config[7]
				-- 播放选中特效
				entity.model:playEffect( ani_table[1],7,7,ani_table[3],nil,0 ,0,0,ani_table[2]);
			end
			if not entity.setSelectColor then
				entity.model:SetSelectedColor(color[1],color[2],color[3],color[4]);
				entity.setSelectColor = true
			end
			entity.model:SetSelected(true)
		end
	else
		-- 传送门不播放选中特效
		if (  entity.type ~= 9 ) then 
			local ani_table = effect_config[7]
			-- 播放选中特效
			entity.model:playEffect( ani_table[1],7,7,ani_table[3],nil,0 ,0,0,ani_table[2]);
		end

		if not entity.setSelectColor then
			entity.model:SetSelectedColor(color[1],color[2],color[3],color[4]);
			entity.setSelectColor = true
		end
		entity.model:SetSelected(true)
	end
	old_selected_entity = entity;

	-- 更新主界面的动作按钮状态
	local win = UIManager:find_visible_window("menus_panel")
	if ( win ) then
		if ( entity.type == 1 or entity.type == 0 or entity.type == 4 ) then
			win:set_action_btn_state( 3 )
		elseif entity.type == 2 then
			win:set_action_btn_state( 2 )
		elseif entity.type == 12 then
		 	win:set_action_btn_state( 4 )
		end
	end
end

-- 设置主角面向目标
function PlayerAvatar:face_to_target( target )
	------------------------
	----HJH 2014-9-30 modify begin
	----face to target居然写死了方向，坑!
	----old
	-- if target.model.m_x < self.x then
	-- 	self.dir = 6
	-- else
	-- 	self.dir = 0
	-- end
	---new
	self:face_to(target.model.m_x, target.model.m_y)
end


-- 判断是否能使用技能
function PlayerAvatar:can_use_skill( skill, target )
	
	local std_skill 	= SkillConfig:get_skill_by_id(skill.id)		-- 技能静态配置
	local skill_entity 	= std_skill.skillSubLevel[skill.level]		-- 技能每个等级的配置

	if target == nil then
		print("技能需要目标")
		return false
	end

	-- 检查技能使用条件
	if skill_entity.spellConds then
		for key,cond in pairs(skill_entity.spellConds) do
			-- print("释放条件2:", key, cond.cond)
			if cond.cond == SkillConfig.SC_MP then
				if self.mp < cond.value then
					print("不够魔法使用技能")
					return false
				else
					print("够魔法")
				end
			elseif cond.cond == SkillConfig.SC_ASSAULTABLE_TARGET then
				if not can_attack_target(target) then
					print("不可攻击的目标")
					return false
				end
			elseif cond.cond == SkillConfig.SC_APPOINT_TARGET then
				if (cond.value == 0) ~= can_attack_target(target) then
					print("不可攻击的目标")
					return false
				end
			elseif cond.cond == SkillConfig.SC_TARGET then
				-- 暂无判断
			elseif cond.cond == SkillConfig.SC_MAX_TARGET_DIST then
				-- 必须不得判断与目标的距离限制，在tryAttackActor函数中会判断距离并主动移动

			elseif cond.cond == SkillConfig.SC_NOT_OVERLAP_TARGET then
				if cond.value == 0 then
					if self.tx ~= target.tx or self.ty ~= target.ty then
						print("你必须与目标重叠")
						return false
					else
						print("与目标距离太近")
						return false
					end
				end
			elseif cond.cond == SkillConfig.SC_ITEM then
				local item_id = ZXLuaUtils:lowByte(cond.value)
				local need_count = ZXLuaUtils:highByte(cond.value)
				if ItemModel:get_item_count_by_id(item_id) < need_count then
					print("缺少释放技能所必需的物品")
					return false
				end
			elseif cond.cond == SkillConfig.SC_HP then
				if self.hp < cond.value then
					print("体力不足，无法使用技能")
					return false
				end
			end
		end
	end
	return true
end

-- 主角思考下一步动作
function PlayerAvatar:think( dt )
	-- print("PlayerAvatar:think( dt )",self.x);
	-- 做一些额外的同步工作
	self.x = self.model.m_x
	self.y = self.model.m_y


	-- 如果小地图打开了，同步主角的移动
	MiniMapModel:sync_player_position(self.x, self.y);

	--原子操作中
	if self:isActionBlocking() then
		return
	end

	if self:is_dead() then
		-- 如果死了就什么都不用想了
		if _current_action ~= nil then
			_current_action:stop_action()
			_current_action = nil
		end
		return
	end

	-- 如果玩家当前处于眩晕或者禁止行动的状态，则直接返回
	if self.state and ZXLuaUtils:band(self.state, EntityConfig.ACTOR_STATE_DIZZY) > 0 or 
		ZXLuaUtils:band(self.state, EntityConfig.ACTOR_STATE_MOVE_FORBID) > 0 then 
		return;
	end

	if _current_action == nil then
		_current_action = self:get_next_action()
	end

	if _current_action ~= nil then
		--print("_current_action",_current_action.class_name)
		-- 如果执行了任何操作，待机时间重新计算
        self.stand_time = 0;
        
		local result = _current_action:do_action()
		if result == ActionConfig.ACTION_DOING then
			
			return
		elseif result == ActionConfig.ACTION_FAIL then
			self:clean_waiting_queue()
            _current_action = nil
            --print("ACTION_FAIL")
        elseif result == ActionConfig.ACTION_END then
        	_current_action = nil
--        	print("ACTION_END")
        else
        	for k,v in pairs(_current_action) do
        		print(k,v)
        	end
        end
    else
    	-- 玩家当前没动作的时候就通知AIManager
    	AIManager:on_player_curr_action_nil()
    	-- 如果当前什么都不做的话就更新待机时间
    	self:update_stand_time(dt);
	end

	-- 要更新主界面玩家的法力值
	local win = UIManager:find_window("user_panel");
	if ( win ) then
		if ( self.mp and self.maxMp ) then
		 	win:update(8,{ self.mp,self.maxMp });
		end
	end	
end

-- 添加动作队列
function PlayerAvatar:add_action_queue( queue )

	-- 跟当前动作相比，如果新的动作队列优先级较高，则顶掉当前队列
	if _current_action ~= nil then
		local new_queue_priority = get_action_queue_priority(queue)
		local current_priority 	= _current_action.priority
		if current_priority < new_queue_priority then
			_current_action:stop_action()
			_current_action = nil
		-- 如果优先级别相同，而当前动作可以被打断，则打断
		elseif current_priority == new_queue_priority and _current_action.can_break then
			--print("打断当前动作..........")
			_current_action:stop_action()
			_current_action = nil
		end
	end

	-- 添加进入等待队列
	self:set_waiting_queue(queue)
	-- for i=1,#queue do
	-- 	table.insert( _waiting_queue,queue[i] );
	-- end
	--print("/....................#_waiting_queue=",#_waiting_queue)
end

-- -- 添加动作到等待队列 
-- -- 这个函数用于 玩家快速点击多个技能时，主角要依次施放这些技能
-- function PlayerAvatar:add_queue_to_waiting_queue( queue )
-- 	for i=1,#queue do
-- 		table.insert( _waiting_queue,queue[i] );
-- 	end
-- end

-- 设置等待队列
function PlayerAvatar:set_waiting_queue( queue )
	--xprint('aaaaaaaaaaaaaaaaa')
	_waiting_queue = queue
end

-- 设置后续队列
function PlayerAvatar:set_continue_queue( queue )
	_continue_queue = queue
end

-- 清除队列
function PlayerAvatar:clean_waiting_queue(  )
	_waiting_queue = {}
end

-- 获取下一个动作
function PlayerAvatar:get_next_action(  )
	if _waiting_queue ~= nil then
		local ret = table.remove(_waiting_queue, 1)
		--print('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!',ret)
		return ret;
	end
	return nil
end

-- 停止全部动作
function PlayerAvatar:stop_all_action(tellServer)
	
	if _current_action ~= nil then
		_current_action:stop_action()
	end
	_current_action = nil
	_waiting_queue  = {}
	-- added by aXing on 2013-3-6
	-- 停止所有动作还包括把模型当前的动作帧也停止了
	local target_x = self.model.m_x
	local target_y = self.model.m_y
	self:stopMoveAt(target_x, target_y)
	-- 通知服务器广播自己停止动作了
	if tellServer then
		MoveCC:request_stop_move(target_x, target_y, self.dir)
	end
	--xprint("主角停止所有动作.............................", tellServer)
end

-- 停止当前动作
function PlayerAvatar:stop_curr_action()
	if _current_action ~= nil then
		_current_action:stop_action()
	end
	_current_action = nil
	_waiting_queue  = {}
	-- added by aXing on 2013-3-6
	-- 停止所有动作还包括把模型当前的动作帧也停止了
	local target_x = self.model.m_x
	local target_y = self.model.m_y
	self:stopMoveAt(target_x, target_y)
end

-- -- 上坐骑
-- function PlayerAvatar:ride_a_mount( mount_id )
-- 	-- 暂时先乱写
-- 	Avatar.ride_a_mount(self, mount_id)
	
-- end

-- -- 下坐骑
-- function PlayerAvatar:get_down_mount(  )
-- 	Avatar.get_down_mount(self)
-- end

-- 主角取得最近的一个攻击目标的handle
function PlayerAvatar:get_nearest_target()

	-- 如果挂了，就不能放技能了
	if self:is_dead() then
		return
	end

	-- 当没有目标的时候，去寻找最近的目标
	if self.target_id == nil or EntityManager:get_entity(self.target_id) == nil then
		self.target_id = EntityManager:find_nearest_target(1)
		if self.target_id == nil then
			-- 找不到目标
			return		
		end
	end

	local target = EntityManager:get_entity(self.target_id)
	self:set_target(target)
	return self.target_id;
end

-- 死亡
function PlayerAvatar:die()
	if ( self.model ) then
		print("主角阵亡!");
		self:stop_all_action();
		AIManager:set_AIManager_idle();

		Avatar.die(self);
		-- Actor.die(self)
		-- self.model:die()
	end
end

function PlayerAvatar:show_resurretionDialog_dialog( killer_name )
	if (SceneManager:get_cur_fuben() >=9 and SceneManager:get_cur_fuben()<= 10) 
		or (SceneManager:get_cur_fuben() >=13 and SceneManager:get_cur_fuben()<= 55) 
		or  SceneManager:get_cur_scene() == 1078 then

	else
		print("killer_name=",killer_name)
		-- 上坐骑的时候死亡的要申请下坐骑
	    if ( ZXLuaUtils:band( self.state , EntityConfig.ACTOR_STATE_RIDE) > 0 ) then
	    	-- 下坐骑
	    	MountsModel:ride_a_mount( )
	    end
		-- 根据系统设置里面的设置判断
		if ( AIManager:get_state() == AIConfig.COMMAND_GUAJI or AIManager:get_state() == AIConfig.COMMAND_FUBEN_GUAJI ) then
			-- 挂机的时候死亡是否自动使用复活石
			local is_fuhuo  = SetSystemModel:get_date_value_by_key( SetSystemModel.AUTO_USE_STONE_RELIVE )
			if ( is_fuhuo ) then
				-- 取得复活石数量
				local fuhuoshi_count = ItemModel:get_item_count_by_id( 18600 );
	            if ( fuhuoshi_count > 0) then
	            	local cb = callback:new();
	            	local function fh()
	            		local money_type = MallModel:get_only_use_yb() and 3 or 2
	            		MiscCC:req_relive(2, money_type)
	            		-- ZXLog('----------fh-------------------')
	            		AIManager:toggle_guaji(  );
	            	end
	                cb:start(2,fh);
				else
					ResurrectionDialog:show(killer_name);
				end
			else
				ResurrectionDialog:show(killer_name);
			end
		else	
			ResurrectionDialog:show(killer_name);
		end
	end
end


-- 判断玩家身上的货币够不够，不够则弹提示框 cb_func按确定后的回调
function PlayerAvatar:check_is_enough_money(money_type,money_count)
	--{"bindYinliang", "uint",},							-- 绑定银两
	--{"yinliang", "uint",},								-- 银两
	--{"bindYuanbao", "uint",},							-- 绑定元宝
	--{"yuanbao", "uint",},								-- 元宝

	local _player_avatar = EntityManager:get_player_avatar();
	if _player_avatar then 
		-- money_type 1忍,2银两,3绑定元宝,4元宝
		if ( money_type == 1 and _player_avatar.bindYinliang < money_count) then
			--NormalDialog:show("忍不足",cb_func,2)
			-- GlobalFunc:create_screen_notic(Lang.screen_notic[0]);
			--天降雄狮修改  xiehande 如果是铜币不足/银两不足/经验不足 做我要变强处理
            ConfirmWin2:show( nil, 15, Lang.screen_notic[11],  need_money_callback, nil, nil )
			return false;
		elseif ( money_type == 2 and _player_avatar.yinliang < money_count) then
			--NormalDialog:show("银两不足",cb_func,2)
			-- GlobalFunc:create_screen_notic(Lang.screen_notic[1]);

			--天降雄狮修改 xiehande  如果是铜币不足/银两不足/经验不足 做我要变强处理
       	    ConfirmWin2:show( nil, 15, Lang.screen_notic[13],  need_money_callback, nil, nil )

			return false;
		elseif ( money_type == 3 and _player_avatar.bindYuanbao < money_count) then
			-- 绑定元宝改成礼券
			--NormalDialog:show("礼券不足",cb_func,2)
			GlobalFunc:create_screen_notic(Lang.screen_notic[2]);
			return false;
		elseif ( money_type == 4 and _player_avatar.yuanbao < money_count) then
			--NormalDialog:show("元宝不足",cb_func,2)
			local function confirm2_func()
				GlobalFunc:chong_zhi_enter_fun()
	            --UIManager:show_window( "chong_zhi_win" )
	    	end
	    	ConfirmWin2:show( 2, 2, "",  confirm2_func)
			return false;
		end
		return true;
	end
	print("主角实体未创建.....")
end

-- 获取主角当前是否在做动作
function PlayerAvatar:get_doing_action_num()
	return self.model:numberOfRunningActions();
end

-- 取得自己职业的必杀技技能id
function PlayerAvatar:getUniqueSkillId()
	if ( self.job == 1 ) then
		return 33;
	elseif ( self.job == 2 ) then
		return 34;
	elseif ( self.job == 3 ) then
		return 35;
	elseif ( self.job == 4 ) then
		return 36;
	end
end

-- 初始化自己的必杀技和普通攻击技能id
function PlayerAvatar:init_bsj_and_normal_attack()
	if ( self.job == 1 ) then
		self.bsj_id = 33;
		self.simple_attack_id = 41;
	elseif ( self.job == 2 ) then
		self.bsj_id = 34;
		self.simple_attack_id = 42;
	elseif ( self.job == 3 ) then
		self.bsj_id = 35;
		self.simple_attack_id = 43;
	elseif ( self.job == 4 ) then
		self.bsj_id = 36;
		self.simple_attack_id = 44;
	end
end

require "config/InstructionConfig"
-- 多少级之前帮玩家自动执行任务
local AUTO_QUEST_LEVEL = InstructionConfig:get_auto_quest_level( )
-- 进入打坐的时间
local DAZUO_TIME = 10;
-- 自动主线任务的时间
local AUTO_QUEST_TIME = InstructionConfig:get_auto_quest_time( )
-- 自动指向主界面日常的时间
local AUTO_RICHANG_TIME = 5;
-- 玩家4秒不动就会提示他点击快捷任务栏继续做任务
local XSZY_TIME = 5;
local is_daiji_xszy = false; -- 是否在进行待机新手指引

-- 主角DAZUO_TIME秒不动就进入打坐状态
function PlayerAvatar:update_stand_time( dt )


	-- 如果当前在挂机,跟随 或者在新手指引中 // or XSZYManager:get_state() ~= XSZYConfig.NONE
	if ( AIManager:get_state() == AIConfig.COMMAND_GUAJI or 
		 AIManager:get_state() == AIConfig.COMMAND_FUBEN_GUAJI or 
		 AIManager:get_state() == AIConfig.COMMAND_FOLLOW or  
		 AIManager:get_state() == AIConfig.COMMAND_SCENE_TELEPORT or
		 UIManager:find_is_show_window_or_dialog() ) then
		return;
	end
	-- 如果玩家等级小于20并且当前没有进行待机指引并且待机时间大于5并且npc对话框没有打开
	-- if ( self.level < 20 and is_daiji_xszy == false and  self.stand_time > XSZY_TIME and UIManager:find_visible_window("npc_dialog") == nil ) then
	-- 	is_daiji_xszy = true;
	-- 	-- 指向快捷任务栏的主线任务
	-- 	local win = UIManager:find_window("user_panel");
	-- 	if ( win ) then
	-- 		win:xszy_main_quest( 5 );
	-- 	end
	-- end
	-- 争霸赛不能打坐
	local fuben_id = SceneManager:get_cur_fuben();
	if fuben_id == 72 then
		return ;
	end

	-- 32级以下，玩家站立状态在原地5秒，则自动帮助玩家寻路主线任务(如无主线，则不启动。排除在副本中的状态)
	-- 当前没有打开窗口或者对话框
	-- print(self.stand_time,self.level,UIManager:find_is_show_window_or_dialog(),SceneManager:get_cur_fuben(),self.is_jqdh) 
	if ( Instruction:get_is_instruct() == false and self.stand_time > AUTO_QUEST_TIME and self.level < AUTO_QUEST_LEVEL  and SceneManager:get_cur_fuben() == 0 and self.is_jqdh == false ) then
		local zx_quest_id,quest_type = TaskModel:get_zhuxian_quest()
		if ( zx_quest_id and quest_type ) then
			AIManager:do_quest( zx_quest_id , quest_type );
			self.stand_time = 0.1;
			return;
		end
	end
	-- -- 32级-40级 玩家站立状态在原地5秒，则指引箭头自动指向主界面美女助手
	-- if ( XSZYManager:is_have_zy_ani() == false and self.mvzs_zy == false and self.stand_time > AUTO_RICHANG_TIME and self.level > 31 and self.level < 41  and SceneManager:get_cur_fuben() == 0 and self.is_jqdh == false ) then
	-- 	self.mvzs_zy = true;
	-- 	XSZYManager:play_jt_and_kuang_animation_by_id( 31, 1, XSZYConfig.OTHER_SELECT_TAG )
	-- 	self.stand_time = 0.1;
	-- 	return;
	-- end

	-- 如果没有开启打坐或者正在剧情动画中，不能打坐
	if ( self.is_jqdh ) then
		return ;
	end
	--print("self.state = ",self.state,self.stand_time);
	-- 如果状态不是站立状态和只有禁止被攻击状态 和天元之主
	if ( self.state ~= 0 and self.state ~= 65536 and self.state~= 1048576 and self.state ~= 1114112 ) then
		return;
	end

	-- if fuben_id == 75 and self.stand_time > 10 then
	-- 	AIManager:guaji();
	-- end
	
	self.stand_time = self.stand_time + dt;
	if ( self.is_enable_dazuo and self.stand_time > DAZUO_TIME ) then
		self.stand_time = 0.1;
		print("进入打坐状态。。。。。。。。。。。。。。。。。。。。。。。。。。。");
		-- 进入打坐状态
		self:client_sit_down();
	end
end

-- 如果主角点击的任务面板，就设置is_xszy = fasle
function PlayerAvatar:set_is_xszy_false()
	is_daiji_xszy = false;
end

-- 取得is_xszy
function PlayerAvatar:get_is_daiji_xszy()
	return is_daiji_xszy;
end

-- 重置玩家的状态
function PlayerAvatar:reset()

	self:stop_dazuo();
	-- 如果玩家当前没有在自动任务，才把ai置空
	if ( AIManager:get_state() ~= AIConfig.COMMAND_ENTER_SCENE and AIManager:get_state() ~= AIConfig.COMMAND_ENTER_FUBEN) then
		--print("AIManager:get_state() = " , AIManager:get_state());
		-- AIManager置空
		AIManager:set_AIManager_idle(  );
	else
		
	end

	-- TODO 玩家停止移动
	self:stop_all_action();
end

-- 隐身状态
function PlayerAvatar:hide_body(  )
	self.model:setInvisibleBodyState(true)
end

-- 现身
function PlayerAvatar:show_body(  )
	self.model:setInvisibleBodyState(false)
end

------------------------------------------
-- 玩家buff相关
------------------------------------------
-- 添加一个buff
function PlayerAvatar:add_buff( buff )
	-- 调用基类
	Avatar.add_buff(self, buff)
	
	-- 这里开始添加一些表现
	if buff.buff_type == 92 then
		-- 赏金副本的buff id
		require "model/FubenModel/FubenCenterModel"
		FubenCenterModel:show_shangjin_buff(buff);

	elseif buff.buff_type == 73 then
		-- 隐身buff id
		self:hide_body()
	end
end

-- 删除一个buff
function PlayerAvatar:remove_buff( buff_type, buff_group )
	Avatar.remove_buff(self, buff_type, buff_group)
	
	-- 这里添加一些表现
	if buff_type == 73 then
		-- 隐身buff id
		self:show_body()
	end

end

-- =======================================
-- 更新管理
-- =======================================
-- 更新面板的具体方法
-- 更新角色面板
local function update_user_attr_win( update_type )
	require "model/UserInfoModel"
	UserInfoModel:update_user_attr_win( update_type )
end

-- 属性变化时，要调用的方法配置
local _attri_to_func_t = {
	body = { update_user_attr_win, },
	wing = { update_user_attr_win, },
	weapon = { update_user_attr_win, },
	fightValue = { update_user_attr_win, },
}

-- 更新    根据更新的属性，找到要更新的配置
function PlayerAvatar:do_model_update( attri_type )
	-- print("更新    根据更新的属性，找到要更新的配置~~~~~~~~~~~~~~~~~", attri_type)
	if _attri_to_func_t[ attri_type ] then
        local do_update_info = _attri_to_func_t[ attri_type ]

        for key, func in pairs( do_update_info ) do
            func( attri_type )
        end
	end 
end

-- 如果在打坐的话就停止打坐
function PlayerAvatar:stop_dazuo()

	-- 如果当前是打坐状态就取消打坐
	if ( ZXLuaUtils:band( self.state , EntityConfig.ACTOR_STATE_ZANZEN) > 0 ) then
		-- print("self.stand_time",self.stand_time)
		-- if ( self.stand_time == 0 and ZXLuaUtils:band( self.state, EntityConfig.ACTOR_STATE_RIDE) == 0) then
		-- 	return;
		-- end
		-- 要取消打坐双修按钮
		local win = UIManager:find_visible_window("dazuo_win");
		if ( win ) then
			-- 玩家站起来
			self:client_stand_up( )
			win:stop_dazuo()
			-- 跑马灯提示
			GlobalFunc:create_screen_notic( LangGameString[465] ); -- [465]="您的打坐已取消"
		end
	end
--	print('取消打坐')
	self.isDazuo = false
end

-- 判断玩家是否有足够的蓝使用技能
function PlayerAvatar:check_is_enough_magic_use_skill( user_skill )
	local skill_info = SkillConfig:get_skill_by_id( user_skill.id )
	local spellConds_table = skill_info.skillSubLevel[user_skill.level].spellConds;
	local magic_use = 0;
	for i=1,#spellConds_table do
		-- cond 8 = 耗蓝量
		if ( spellConds_table[i].cond == 8 ) then
			magic_use = spellConds_table[i].value;
		end
	end
	if ( self.mp >= magic_use ) then
		return true;
	end
	return false;
end

-- -- 注册选中事件
-- function PlayerAvatar:register_click_event(  )
	
-- end

-- 主角打坐和 其他玩家打坐不一样。。主角打坐需要发协议和立刻做动作
function PlayerAvatar:client_sit_down()
	print("self.state",self.state)

	-- 主角的state添加打坐
	-- self.state = self.state + 8; -- 打坐要加8
	--xiehande 改成按位或形式 2015-2-12
	self.state = bit:_xor(self.state,8)
	print("client_sit_down..................",self.state)

	self:sit_down();
	ShuangXiuCC:req_start_normal_dazuo( 1, 1 );
	-- 如果是主角，显示双修按钮
	DaZuoWin:show( self.x,self.y );

	PowerCenter:OnAvatarDazuo()
	-- print("PlayerAvatar:client_sit_down() 打坐")
	
end


function PlayerAvatar:stand_up()
	Avatar.stand_up(self);
	self.isDazuo = false
end

function PlayerAvatar:sit_down()
	Avatar.sit_down(self);
	self.isDazuo = true
end

function PlayerAvatar:client_stand_up(  )
	print("self.state",self.state)

	-- self.state = self.state - 8;
	--xiehande 改成按位或形式 2015-2-12
	self.state = bit:_and(self.state,bit:_not(8))
	print("client_stand_up..................",self.state)

	self:stand_up();
	-- 如果是主角的话要隐藏双修按钮
	UIManager:hide_window("dazuo_win");
	PowerCenter:OnAvatarStand()

end



-- 上坐骑
function PlayerAvatar:client_ride_a_mount( mount_id )
	print("self.state",self.state)
	-- self.state = self.state + 4;
	--xiehande 改成按位与形式
	self.state = bit:_xor(self.state,4)
	print("ride_a_mount..................",self.state)
	self:ride_a_mount(mount_id );
	self:update_name( true );
	self:update_title( true );
	SoundManager:playUISound('mounts_up',false)
	self:update_zhenlong()
end

-- 下坐骑
function PlayerAvatar:client_get_down_mount(  )
	print("self.state",self.state)
	-- self.state = self.state - 4;

	--xiehande 改成按位或形式 2015-2-12
	self.state = bit:_and(self.state,bit:_not(4))
    
	print("client_get_down_mount ========================",self.state);
	self:get_down_mount();
	self:update_name( false );
	self:update_title( false );
	SoundManager:playUISound('mounts_down',false)
	self:update_zhenlong()
end
-- 当玩家创建完毕
function PlayerAvatar:on_player_avatar_create_finish()
	-- 更新主界面的数据
	local win = UIManager:find_visible_window("user_panel");
	if ( win ) then
		win:update(2);
	end
	-- 根据玩家系统开启的数量显示对应的按钮
	win = UIManager:find_visible_window("menus_panel");
	if ( win ) then
		win:create_btns();
	end
	
	win = UIManager:find_visible_window("exp_panel");
	if ( win ) then
		win:updateExp();
	end

	---hjh 2013-6-3
	local achieveNum = AchieveModel:getAchieveExistNum()
	if achieveNum > 0 and EntityManager:get_player_avatar().level > 31 then
		local function openfun()
			UIManager:show_window("achieve_win")
		end
		MiniBtnWin:show(18, openfun, achieveNum )
	end




	-- model创建在state之后，所以只能把天元之主的判断加在这了
	-- if ( ZXLuaUtils:band(self.state, EntityConfig.ACTOR_STATE_CASTELLAN) > 0 ) then
	-- 	print("-------------------------播放天元之主特效--------------------------");
	-- 	local ani_table = effect_config[79];
	-- 	self.model:playEffect(ani_table[1],79,7,ani_table[3],nil,0,0,10,ani_table[2]);
	-- end

	-- 判断是否开启打坐
	self.is_enable_dazuo = GameSysModel:isSysEnabled(GameSysModel.PRACTICE, false);
	--print("self.is_enable_dazuo = ",self.is_enable_dazuo);

    -- 每次上线，打开活动的每日福利界面
    ActivityModel:enter_game_open_activity_win(  )


    -- 每次上线后请求灵根信息，然后判断是否可以升级
    LingGenCC:req_get_linggen_info();
    
    -- 每次上线检查是否有开服活动
    OpenSerModel:check_op_server_active(  )
   
    -- 潜规则 每次上线后要向服务器请求免费洗练次数
    ItemCC:req_free_xilian_count()
    -- 每次上线后向服务器请求仙道会争霸赛信息
    XianDaoHuiCC:req_zbs_info(  )
    -- print("---------------------------------------------主角创建完毕--------------------------主角攻击速度为",self.attackSpeed,self.honor)
 	-- 每次上线后向服务器请求活动信息
 	OnlineAwardCC:req_get_activitys_list()
 	-- 请求世界boss数据
 	OthersCC:request_world_boss_date()
 	-- 寄售
 	JiShouCC:send_get_my_item_list()
 	-- 渡劫
 	MiscCC:request_dujie_info( )
 	-- 法宝
 	FabaoCC:req_fabao_info(  )

    if ( self.level < 18 ) then
    	local win = UIManager:find_visible_window("menus_panel");
    	if win then
    		win:set_yp_and_xq_btn_visible(false);
    	end
    end

    local win = UIManager:find_window("right_top_panel")
    if win then
    	-- win:create_sys_open_btn(  );
    end
	-- 在第一个地图新手副本中，要给玩家穿上60级装备和武器
	if SceneManager:get_cur_fuben() == 75 then
    	-- 给主角穿上60级的装备和武器
		local player = EntityManager:get_player_avatar();
		player:update_default_body(EntityFrameConfig:get_60lv_body_id( player.job ) )
		player:update_weapon(EntityFrameConfig:get_60lv_weapon_id( player.job ))
		UIManager:hide_window("right_top_panel");
	end

	-- 潜规则, 查询式神探险状态
	ElfinCC:req_explore_status()
	
end

-- 更新：真龙之魂特效   静态调用
function PlayerAvatar:update_zhenlong(  )
	-- by xiehande 14.12.20
	-- 不显示
	local player = EntityManager:get_player_avatar()
	local is_shangma = MountsModel:get_is_shangma()
	if not is_shangma and UserInfoModel:check_if_equip_zhenlong(  ) then
		player.model:stopEffect(79)
        local ani_table = effect_config[79];
		player.model:playEffect(ani_table[1],79,7,ani_table[3],nil,0,0,10,ani_table[2]);
	else
        player.model:stopEffect(79)
	end

end

-- 更新主角的联盟状态 
function PlayerAvatar:change_lianmeng_state( lianmeng_info )
	local player = EntityManager:get_player_avatar()
	if ( lianmeng_info ) then
		player.lianmeng_info = lianmeng_info;
	else
		player.lianmeng_info = nil;
	end
end

function PlayerAvatar:is_pk_scene()
	 -- print("PlayerAvatar:update_title()")
	-- -- 判断是否pk场景，如果是就隐藏称号显示仙宗
    if ( SceneManager:get_is_pk_scene() ) then
    	Avatar.update_title_type(self, 2 )
    else
    	Avatar.update_title_type(self, 1 )
    end
end

function PlayerAvatar:update_default_body( attri_value )
	self:_delay_set_body(attri_value)
end

function PlayerAvatar:ride_a_mount( mount_id )
	self:_delay_ride_mount( mount_id )
end

function PlayerAvatar:change_mount( mount_id )
	self:_delay_change_mount( mount_id )
end

function PlayerAvatar:update_weapon( weapon_id )
	self:_delay_set_weapon( weapon_id )
end

function PlayerAvatar:update_wing( wing_id )
	self:_delay_set_wing( wing_id )
end

function PlayerAvatar:update_fabao( fabao_id )
	 self:_delay_set_fabao( fabao_id )
end

function PlayerAvatar:is_have_state( )

	if ZXLuaUtils:band(self.state, EntityConfig.ACTOR_STATE_MOVE_FORBID) > 0 
		or ZXLuaUtils:band(self.state, EntityConfig.ACTOR_STATE_DIZZY) > 0 then
		return true;
	end

	return false;
end

function PlayerAvatar:set_curr_use_skill_info( id)
	self.curr_use_skill_id = id;

end

function PlayerAvatar:test( action_id  )
	local player = EntityManager:get_player_avatar();
	player.model:playAction(action_id, player.dir, false)
	local action_time = 0.3
	local function cb_fun()
		-- 暂停动作
		player.model:stopAllActions();
		print("主角暂停动作")
	end
	callback:new():start(action_time,cb_fun)
end

function PlayerAvatar:enableJumpZoom(state)
	self._jump_zoom = state
end

function PlayerAvatar:_onPrepareJump(jump_time,tx,ty)
	-- body
	

	self:setShadowTail(true,0.03,0.4)
	Avatar._onPrepareJump(self,jump_time,tx,ty)

	if self._jump_zoom then
		ZXLogicScene:sharedScene():zoom(1.0)
		SceneCamera:zoomSin(1.0, 0.1,jump_time)
	end
end

function PlayerAvatar:_onEndJump()
	
	if self._jump_zoom then
		SceneCamera:zoom(1.0)
	end
	
	self:setShadowTail(false)
	Avatar._onEndJump(self)
	
end


function PlayerAvatar:update_wing_and_fabao( attri_value )

 	local fabao_id = ZXLuaUtils:highByte( attri_value );
 	print('PlayerAvatar:update_wing_and_fabao',attri_value,fabao_id)
	if fabao_id ~= 0 then
		self:update_fabao( fabao_id );
	end

	local wing_id = ZXLuaUtils:lowByte( attri_value );
	print("Avatar:update_wing_and_fabao( attri_value )",wing_id)
	if wing_id ~= 0 then
		
		self:update_wing(wing_id);
	else
		-- print("卸下翅膀")
		self:take_off_wing()
	end
end


function PlayerAvatar:onActionMove(tx,ty)
	if not tx or not ty then
		return
	end


	if ( GameSysModel:isSysEnabled(GameSysModel.MOUNT, false) and SceneManager:get_cur_fuben() == 0 ) then
		local ManhattanFactorX = math.abs(self.model.m_x - tx) 
		local ManhattanFactorY = math.abs(self.model.m_y - ty)
		local hw = GameScreenConfig.viewPort_width * 0.25
		local hh = GameScreenConfig.viewPort_height * 0.25
		--print('>>>>>>>>',hw,hh,ManhattanFactorX,ManhattanFactorY,ManhattanFactorX > hw,ManhattanFactorY > hh)
		if ManhattanFactorX > hw or ManhattanFactorY > hh then
			if not MountsModel:get_is_shangma() then
				 MountsModel:ride_a_mount()
			end
		end
	end
end

function PlayerAvatar:addBloodBar( max_hp )
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

function PlayerAvatar:changeBlood(change_hp,hp,max_hp)
	if not change_hp then change_hp = 0 end
	if self.hp_bg and self.hp_bar and change_hp ~= 0 and hp > 0 then
		self.hp_bg:setIsVisible(true)
		self.hp_bar:update_hp(change_hp,hp,max_hp)
		self.hp_bar2:setTextureRect(CCRect(0, 0, 84 *hp/max_hp, 6))
		self.hp_bar2:setPosition(0, 0)
		if self.add_timer then
			self.add_timer:cancel()
			self.add_timer = nil
		end
		if change_hp > 0 then
			local function hide_cb()
				self:show_hide_blood(false)
			end 
			self.add_timer = callback:new()
			self.add_timer:start(_BLOOD_HIDE_DELAY, hide_cb)
		end
	elseif hp <= 0 and self.hp_bar then
		self.hp_bar:destroy()
		self.hp_bar = nil
		self:show_hide_blood(false)
	end
end

function PlayerAvatar:destroyBlood()
	if self.add_timer then
		self.add_timer:cancel()
		self.add_timer = nil
	end
	if self.hp_bar then
		self.hp_bar:destroy()
		self.hp_bar = nil
	end
	if self.hp_bg then
		self.hp_bg:removeFromParentAndCleanup(true)
		self.hp_bg = nil
	end
end

function PlayerAvatar:show_hide_blood(flag)
	if self.hp_bg then
		self.hp_bg:setIsVisible(flag)
	end
	if flag and self.add_timer then
		self.add_timer:cancel()
		self.add_timer = nil
	end
end