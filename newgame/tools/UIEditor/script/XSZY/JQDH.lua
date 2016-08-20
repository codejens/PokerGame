-- JQDH.lua
-- created by hcl on 2013-3-14
-- 剧情动画播放器

super_class.JQDH()

local ui_node = nil;

local hand_pos_x_1 = 635;
local hand_pos_x_2 = 495;
local JQDH_ENTITY_START_HANDLE = 8888888;

-- 主角跪着frame
local PLAYER_KNEEL_FRAME = {5009,5010,5013,5014};

function JQDH:init()
	ui_node = ZXLogicScene:sharedScene():getUINode();
end

-- 面板
local panel = nil;
-- 对话
local dialog = nil;
-- 当前的对话Index
local dialog_index = 0;
-- 背景框，需要时要翻转
local bottom_bg = nil;
-- 手
local hand = nil;
-- 玩家实体
local player = nil;
-- 剧情类型
local jq_type = nil;
-- 实体列表
local jq_entity_table = {};
-- 实体动作列表
local jq_action_table = {};
-- 实体头像列表
local jq_head_table = {};
-- 之前显示的头像id
local old_head_id = nil;

-- 有时候剧情人物移动的时候，不能点击
local is_entitiy_moving = false ;
-- 文字动画的时候再点一次直接结束文字动画
local is_text_animation_playing = false;

local dismiss_cb = nil;

-- 是否显示怪物
local is_show_monster = true;
-- 黑色屏幕
local black_screen_img = nil;
-- 黑色屏幕上的文字
local black_screen_str = nil;
-- 动作1的callback ,用于对话中，玩家3秒不点就自动帮他点
local _action_one_cb = nil;
-- 跳过按钮
local pass_btn = nil;

-- type 1 万剑愁动画 2 渡劫动画 3:封魔殿 蚩尤复苏 4:蚩尤挂掉动画 5:姥魔动画 6击杀姥魔后动画
-- 7 开启灵根动画 8 云霄动画(任务id-171) 9炎帝幻境动画(任务id-197),10炎帝挂了以后动画
-- 11 南诏王 (当有221任务完成后) 12 黑龙之魂(244任务完成后)
function JQDH:play_animation( _type ) 

	if ( panel ) then
		print("出bug了！同一个动画播了多次.........");
		return;
	end

	-- 停止玩家所有动作以及停止挂机
    player = EntityManager:get_player_avatar();
	if player then
		player:stop_all_action(  )
		AIManager:set_AIManager_idle(  )
	else
		print("主角没有创建完毕。。。。。。。。。。。。。")
	end
	player.is_jqdh = true;
	player.model:setIsVisible(false);
	print("播放第".._type.."个剧情动画");
	jq_type = _type;
	--隐藏主界面的所有东西
	JQDH:hide_main_window(  )
	panel = CCBasePanel:panelWithFile(0,-200,800,680,nil,0,0);
	local function panel_fun(eventType,x,y)
		-- print("panel_fun",eventType)
        if	eventType == TOUCH_CLICK then
        	if ( is_entitiy_moving == false ) then 
	        	-- 显示下一张图片
	        	JQDH:next_jq()
	        end
        end
        return true;
    end
    panel:registerScriptHandler(panel_fun);
	
	-- 跳过按钮
	local function pass_fun( eventType )
		if eventType == TOUCH_CLICK then
	    	local function cb()
	   			-- 显示所有怪物
				EntityManager:show_all_monster();
				require "control/GameLogicCC"
				GameLogicCC:req_talk_to_npc(0, "startPlay")		-- 这是跟服务器约定的
		    	OnlineAwardCC:req_enter_xinshoucun()
	  		end
	  		JQDH:hide_panel_action(cb,true)  			
		end
		return true;
	end
	pass_btn = MUtils:create_common_btn(panel,"跳过",pass_fun,700,400,10000000)

	-- 初始化剧情数据
	JQDH:init_with_type( jq_type )
	-- 背景，不同的阵营需要翻转x
	bottom_bg = MUtils:create_sprite(panel,"",400,107.5,-1);
	ui_node:addChild(panel,9999);

	-- local head_id = jq_action_table[ 1 ].entity_face_id;
	-- -- 初始化一些静态配置
	-- if ( head_id > 0 ) then
	-- 	bottom_bg:setFlipX(true);
	-- else
	-- 	bottom_bg:setFlipX(false);
	-- end
	
	dialog = MUtils:create_ccdialogEx( panel,"",245,70,400,10,20,15);
	dialog:setAnchorPoint(0, 1);
	dialog:setCurState(CLICK_STATE_DISABLE)
	-- 把框弹起来
	-- JQDH:show_panel_action(  )
	--print("播放第".._type.."个剧情动画结束");
	-- 开始第一步
	JQDH:next_jq();

end

function JQDH:init_with_type( _type )
	pass_btn:setIsVisible(false);
	if ( _type == 1 ) then
	elseif ( _type == 2 ) then
	elseif ( _type == 3 ) then
	elseif ( _type == 4 ) then
	elseif ( _type == 5 )then
	elseif ( _type == 6 )then
	elseif ( _type == 7 ) then 
		-- 隐藏掉周围玩家和宠物
		EntityManager:hide_all_player_and_pet(  )
	elseif ( _type == 13 ) then
		-- 显示跳过按钮
		pass_btn:setIsVisible(true);
	end
	-- print("JQDH:114--------------------------------------------------------------------------")
	is_show_monster = false;
	-- 隐藏所有怪物
	EntityManager:hide_all_monster()

	require "../data/jqdh"
	-- 创建实体
	local entity_table = jqdh[_type].entity;
	for i=1,#entity_table do
		local info = entity_table[i];
		local create_type = info.create_type;
		JQDH:create_entity_by_type( create_type ,info,true)
	end
	print("_type",_type)
	-- 保存动作数据
	jq_action_table = jqdh[_type].step;
end

function JQDH:show_panel_action( is_ani )

	-- local player = EntityManager:get_player_avatar();
	-- player.is_jqdh = true;
	if is_ani then
		is_entitiy_moving = true;
		local move_by = CCMoveBy:actionWithDuration(1.5,CCPoint(0,200));
	   	local move_ease_in = CCEaseIn:actionWithAction(move_by,5.0);
	   	panel:runAction(move_ease_in);
	else
		panel:setPosition(0,0);
	end
end

function JQDH:hide_panel_action(cb,is_pass_ani)
	if ( self.text_play_timer ) then
		self.text_play_timer:stop();
		self.text_play_timer = nil;
	end
	is_entitiy_moving = true;
	if is_pass_ani then

	else
		JQDH:hide_panel()
	end
	
   	dismiss_cb = callback:new();
    local function dismiss( dt )
	    panel:removeFromParentAndCleanup(true);
  		panel = nil;
  		JQDH:show_main_window(  );
  		local player = EntityManager:get_player_avatar();
		player.is_jqdh = false;
		old_head_id = nil;
		jq_entity_table = {};
		jq_action_table = {};
		jq_head_table = {};
      	if ( cb ) then
      		cb();
      	end
    end
    dismiss_cb:start(1.6,dismiss)
end

function JQDH:hide_panel()
	local move_by = CCMoveBy:actionWithDuration(1.5,CCPoint(0,-200));
   	local move_ease_in = CCEaseIn:actionWithAction(move_by,5.0);
   	panel:runAction(move_ease_in);

   	dismiss_cb = callback:new();
    local function dismiss( dt )
    	if jq_head_table[ old_head_id ] then 
		   	jq_head_table[ old_head_id ].view:removeFromParentAndCleanup(true);
		   	jq_head_table[ old_head_id ] = nil;	
		end
    end
    dismiss_cb:start(1.6,dismiss)
end

-- 隐藏主界面的所有东西
function JQDH:hide_main_window(  )
	UIManager:hide_window("user_panel");
	UIManager:hide_window("right_top_panel");
	UIManager:hide_window("menus_panel");
	XSZYManager:set_dqmb_visible( false )
	dialog_index = 0;
end 

-- 显示主界面的所有东西
function JQDH:show_main_window(  )
	UIManager:show_window("user_panel");
	UIManager:show_window("menus_panel");
	-- 新手副本不显示右上角
	if SceneManager:get_cur_fuben()~=75 then
		local win = UIManager:show_window("right_top_panel");
		if win.is_show then
			XSZYManager:set_dqmb_visible( true )
		end
	end
	dialog_index = 0;
	player.model:setIsVisible(true);
end 

function JQDH:next_jq()
	-- xprint("JQDH:next_jq()")
	if ( dialog_index == 0 ) then
		-- 创建手
		hand = LuaEffectManager:playAniWithArgs( panel,{"nopack/ani/hand1.png","nopack/ani/hand2.png"},90,50,0.5,10000000 )
		hand:setPosition(hand_pos_x_1,30)
	end

	dialog_index = dialog_index + 1;
	-- print("dialog_index",dialog_index, #jq_action_table)
	if ( dialog_index > #jq_action_table ) then
		self:finish();
		return;
	end

	-- 取得动作数据
	local action_info = jq_action_table[ dialog_index ];
	JQDH:do_action( action_info );

	if ( jq_type == 1 and dialog_index == 3 ) then
		-- 显示所有怪物
		EntityManager:show_all_monster();
	end

end

-- 执行动作
function JQDH:do_action( action_info )
	print("JQDH:do_action( action_info",action_info.action_type)
		-- 动作2移动
	if ( action_info.action_type == 2 ) then
		local entity_tag = action_info.entity_tag;
		local move_x = action_info.move_x;
		if move_x == nil then
			move_x = 500
		end
		local _time = action_info.delay_time;
		if _time == nil then
			_time = 2;
		end
		JQDH:entity_move( jq_entity_table[ entity_tag ],move_x,_time );
		
	-- 动作1对话
	elseif ( action_info.action_type == 1 ) then
		-- 先隐藏旧的头像
		if ( old_head_id ) then
			jq_head_table[ old_head_id ].view:setIsVisible(false);
		end
		-- 头像id
		local head_id = action_info.entity_face_id;
		-- 如果这个头像不存在就创建它
		if ( jq_head_table[head_id] == nil ) then
			if head_id == 0 then
				local str = "nopack/half_body"..player.job..player.sex..".png";
				jq_head_table[head_id] = ZImage:create(panel,str,0,0);
			elseif head_id == -1 then
				jq_head_table[head_id] = ZImage:create(panel,"nopack/xuaner.png",0,0);
			else
				require "../data/npc"
    			local tab_npc_info = npc_dialog_config[head_id];
				local str = string.format("ui/npc/npc_%s",tab_npc_info[1]);
				jq_head_table[head_id] = ZImage:create(panel,str,550,0);
				jq_head_table[head_id].view:setScale(294/329)			
			end
		else
			jq_head_table[head_id].view:setIsVisible(true);
		end
		-- 保存旧头像
		old_head_id = head_id;
		if ( head_id > 0 ) then
			bottom_bg:setFlipX(true);
			hand:setPosition(CCPoint(hand_pos_x_2,30));
			dialog:setPosition(105,70);
		else
			bottom_bg:setFlipX(false);
			hand:setPosition(CCPoint(hand_pos_x_1,30));
			dialog:setPosition(245,70);
		end
		-- 播放文字动画
		local text = action_info.jq_str;
		-- 处理文字
		text = string.gsub(text, "@player", player.name);
		JQDH:play_text_animation( text )

		-- -- 3秒没有点的话自动跳到下一个
		-- _action_one_cb = callback:new();
		-- local function cb_fun()
		-- 	_action_one_cb:cancel();
		-- 	print( "_action_one_cb:",is_entitiy_moving );
  --       	if ( is_entitiy_moving == false ) then 
	 --        	-- 显示下一张图片
	 --        	JQDH:next_jq()
	 --        end			
		-- end
		-- _action_one_cb:start(5,cb_fun)

	-- 动作3 创建实体
	elseif ( action_info.action_type == 3 ) then
		is_entitiy_moving = true;
		local create_type = action_info.create_type;
		JQDH:create_entity_by_type( create_type ,action_info,false)
		
	-- 动作4 屏幕变黑，然后显示文字
	elseif ( action_info.action_type == 4 ) then
		is_entitiy_moving = true;
		local show_type = action_info.show_type;
		if show_type == 1 then
			black_screen_img = ZCCSprite:create(panel,"nopack/black.png",400,240,999999);
			-- img.view:setScaleX(800);
			-- img.view:setScaleY(480);
			black_screen_img.view:setTextureRect(CCRect(0,0,800,680))
			-- img.view:setOpacity(0);
			-- local fade_out = CCFadeOut:actionWithDuration(1);
		    local fade_in = CCFadeIn:actionWithDuration(1);
			-- local array = CCArray:array();
			-- array:addObject(fade_in);
			-- -- array:addObject(CCDelayTime:actionWithDuration(2));
			-- -- array:addObject(fade_out);
			-- local seq = CCSequence:actionsWithArray(array);
			black_screen_img.view:runAction(fade_in);
			-- -- 播放文字动画
			-- local text = action_info.jq_str;
			-- local lab = ZLabel:create(panel,text,400,240,25,2,1000000)
			-- -- lab.view:setAnchorPoint(CCPoint(0.5,0.5))
			-- local array = CCArray:array();
			-- array:addObject(CCDelayTime:actionWithDuration(1));
			-- array:addObject(CCShow:action());
			-- array:addObject(CCDelayTime:actionWithDuration(2));
			-- array:addObject(CCHide:action());
			-- local seq = CCSequence:actionsWithArray(array);
			-- lab.view:runAction(seq);
			JQDH:delay_do_action(1)
		elseif show_type == 2 then
			if black_screen_img then
				local fade_out = CCFadeOut:actionWithDuration(1);
				black_screen_img.view:runAction(fade_out);
				local _cb = callback:new();
				local function _cb_fun()
					black_screen_img.view:removeFromParentAndCleanup(true);
					black_screen_img = nil;
					black_screen_str:removeFromParentAndCleanup(true);
					black_screen_str = nil;
					is_entitiy_moving = false;
					JQDH:next_jq();
				end
				_cb:start(1,_cb_fun);
			end
		end
	    
	-- 动作5 删除实体
	elseif ( action_info.action_type == 5 ) then
		is_entitiy_moving = true;
		JQDH:destroy_jqdh_entity( jq_entity_table[ action_info.entity_tag ],action_info.die_type );
		local delay_time = action_info.delay_time
		JQDH:delay_do_action(delay_time)
	-- 动作6 在黑色屏幕上显示文字
	elseif ( action_info.action_type == 6 ) then
		local text = action_info.jq_str;
		if black_screen_str then
			black_screen_str:setText(text)
		else
			black_screen_str = MUtils:create_ccdialogEx( panel,text,100,400,600,200,99,20,1000000);
			black_screen_str:setAnchorPoint(0, 1);
			black_screen_str:setCurState(CLICK_STATE_DISABLE)
		end
	-- 动作7,实体身上添加特效 8泡泡框 9实体执行动作(倒地，攻击)
	elseif ( action_info.action_type == 7 ) then
		is_entitiy_moving = true;
		local effect_id = action_info.effect_id;
		local effect_type = action_info.effect_type;
		local entity_tag = action_info.entity_tag;
		local effect_animation_table = effect_config[effect_id];
		if ( effect_animation_table  ) then
			local _entity = nil;
			-- 0 代表主角
			if entity_tag then
				if entity_tag == 0 then
					_entity = player;
				else
					_entity = jq_entity_table[ entity_tag ]
				end
			end
			-- effect_type: 1-爆炸 2-身上持续 3-地图增加特效 4-飞行
			if effect_type == 1 then 
				print("entity_tag",entity_tag,"播放特效",effect_id)
				_entity.model:playEffect( effect_animation_table[1],effect_id, 2, effect_animation_table[3],nil,1,0,500,effect_animation_table[2] );		
			elseif effect_type == 2 then
				print("entity_tag",entity_tag,"播放特效",effect_id)
				_entity.model:playEffect( effect_animation_table[1],effect_id, 6, effect_animation_table[3],nil,1,10000000,500,effect_animation_table[2]);
			elseif effect_type == 3 then
				local view_pos_x = action_info.pos_x;
				local view_pos_y = action_info.pos_y;
				local x,y = SceneManager:view_pos_to_map_pos( view_pos_x, view_pos_y )
				local effect_time = nil;
				if action_info.effect_time then
					effect_time = action_info.effect_time;
				end
				LuaEffectManager:play_map_effect( effect_id,x,y,false,10000,effect_time )
			elseif effect_type == 4 then
				local target_entity = jq_entity_table[ action_info.target_tag ];
				if ( _entity and target_entity ) then
					local dir = _entity.dir;
					print("dir = ",dir)
					_entity.model:playEffect( effect_animation_table[1],effect_id,3,effect_animation_table[3],target_entity.model,dir ,0,500,effect_animation_table[2]);
				end						
			end
		end
		local delay_time = action_info.delay_time
		JQDH:delay_do_action(delay_time)
	elseif ( action_info.action_type == 8 ) then
		is_entitiy_moving = true;
		local entity_tag = action_info.entity_tag;
		local entity = jq_entity_table[ entity_tag ]
		local talk_str = action_info.jq_str;
		EntityDialog( entity.model:getBillboardNode(),talk_str );
		local delay_time = action_info.delay_time
		-- print("delay_time=",delay_time)
		JQDH:delay_do_action(delay_time)
	elseif ( action_info.action_type == 9 ) then
		is_entitiy_moving = true;
		local _entity = nil;
		if action_info.entity_body_id == 0 then
			_entity = player;
		else
			_entity = jq_entity_table[ action_info.entity_tag ]
		end
		local action_id = action_info.action_id;
		-- action_id 0:倒地 1:攻击
		if action_id == 0 then
			_entity.model:takeOffWeapon()
			_entity.model:die()
		elseif action_id == 1 then
			if action_info.entity_body_id == 0 then
				_entity:playAction(0, _entity.dir, false)
				local action_time = action_info.action_time
				if action_time then 
					local function cb_fun()
						-- 暂停动作
						_entity.model:pauseSchedulerAndActions();
					end
					callback:new():start(action_time,cb_fun)
				end
			else
				_entity:use_skill( 39, 1, _entity.dir )
			end
		elseif action_id == 2 then
			local _pos_x = action_info.pos_x;
			local _pos_y = action_info.pos_y;
			local height = action_info.height
			local jump_time = action_info.jump_time;
			LuaEffectManager:jump( _entity,_pos_x,_pos_y,height,jump_time );
			_entity.model.m_x = _entity.model.m_x + _pos_x;
			_entity.model.m_y = _entity.model.m_y + _pos_y;
		end
		local delay_time = action_info.delay_time
		JQDH:delay_do_action(delay_time)
	elseif ( action_info.action_type == 10 ) then
		is_entitiy_moving = true;
		local entity_tag = action_info.entity_tag;
		local entity = jq_entity_table[ entity_tag ]
		local move_x = action_info.move_x;--/5
		local move_y = action_info.move_y
		local need_shadow = action_info.need_shadow;
		if need_shadow == nil then
			need_shadow = 0;
		end
		if move_y == nil then
			move_y = 0;
		end

		entity.model:runAction(CCMoveBy:actionWithDuration(0.5,CCPoint(move_x,-move_y)))
		entity.model.m_x = entity.model.m_x + move_x;
		entity.model.m_y = entity.model.m_y + move_y;
		if need_shadow == 1 then
			local index = 1;
			local _timer = timer();
			local old_spr = nil;
			local function _timer_fun()
				if old_spr then
					old_spr:removeFromParentAndCleanup(true);
					old_spr = nil;
				end
				old_spr = entity.model:get_body():createCurrentFrame( true )
				SceneManager.SceneNode:addChild(old_spr)
				-- entity.model:relocate( move_x + entity.model.m_x,entity.model.m_y + move_y )
				index = index + 1;
				if index == 10 then
					_timer:stop();
					if old_spr then
						old_spr:removeFromParentAndCleanup(true);
						old_spr = nil;
					end
				end
			end
			_timer:start(0.05,_timer_fun);
		end
	
		local delay_time = action_info.delay_time
		JQDH:delay_do_action( delay_time )
	elseif  action_info.action_type == 11 then
		is_entitiy_moving = true;
		if action_info.show_type == 2 then
			JQDH:hide_panel();
		elseif action_info.show_type == 1 then
			local show_panel_type = action_info.show_panel_type;
			local is_ani = action_info.is_ani;
			if is_ani == nil then
				is_ani = true;
			end
			if show_panel_type == 2 then
				bottom_bg:setFlipX(true);
			else
				bottom_bg:setFlipX(false);
			end
			JQDH:show_panel_action(is_ani);
		end
		JQDH:delay_do_action(1.5)
	elseif action_info.action_type == 12 then
		is_entitiy_moving = true;
		local delay_time = 1
		local _game_scene = ZXGameScene:sharedScene();
		local center_p = _game_scene:getCameraPositionInPixels();
		local move_x = action_info.move_x; 
		-- local y = center_p.y;  center_p的y值与player.model.m_y值不同
		local y = player.model.m_y;
		local d_x = move_x/100;
		local index = 1;
		-- 缓慢移动镜头
		local _timer = timer();
		local function timer_fun()
			_game_scene:cameraMoveInPixels(center_p.x + index *d_x, y);
			-- print("移动镜头",index);
			if index == 100 then
				_timer:stop();
				_timer = nil;
			end
			index = index + 1;
		end
		_timer:start(0.01,timer_fun)
		JQDH:delay_do_action(1.5)
	elseif action_info.action_type == 13 then
		is_entitiy_moving = true;
		local delay_time = action_info.delay_time
		GlobalFunc:create_center_notic( action_info.jq_str )
		JQDH:delay_do_action(delay_time)
	elseif action_info.action_type == 14 then
		SpecialSceneEffect:perform2( 5 )
		JQDH:delay_do_action(0.5)
	end
end

function JQDH:delay_do_action(delay_time)
	if delay_time == nil then
		delay_time = 0;
	end
	local cb = callback:new();
	local function cb_fun()
		is_entitiy_moving = false;
		JQDH:next_jq();				
	end
	cb:start(delay_time,cb_fun)	
end

-- 剧情动画结束
function JQDH:finish()
	-- xprint("JQDH:finish()")
	-- 所有动画都播完了，这时候要禁止点击
	is_entitiy_moving = true;
	is_show_monster = true;
	-- 销毁实体
	for k,v in pairs(jq_entity_table) do
		print("销毁实体",k,v)
		JQDH:destroy_jqdh_entity( v )
	end
	-- 剧情动画播完后继续新手指引
	-- 万剑愁动画完了后 指向必杀技按钮
	if ( jq_type == 1 ) then
		local function cb()
			local win = UIManager:find_window("menus_panel");
			if ( win ) then
				win:show_or_hide_panel(false);
				XSZYManager:set_state_and_data( XSZYConfig.BISHAJI_ZY,XSZYManager:get_data());
				DialogManager:show( nil , DialogManager.DIALOG_BISHAJI );
			end
		end
		JQDH:hide_panel_action(cb)
	elseif (  jq_type == 2 ) then
		local function cb()
			-- 指向挂机按钮
			XSZYManager:play_jt_and_kuang_animation_by_id( XSZYConfig.GUAJI_BTN,1 , XSZYConfig.OTHER_SELECT_TAG );
			-- 显示所有怪物
			EntityManager:show_all_monster();
			XSZYManager:set_step(2);
			-- local sceneid = TaskModel:get_commit_quest_scene( XSZYManager:get_data() );
--             AIManager:set_after_pos_change_command( sceneid ,AIConfig.COMMAND_DO_QUEST, {XSZYManager:get_data(),1});
		end
		JQDH:hide_panel_action(cb)
	elseif ( jq_type == 3 ) then
		--JQDH:entity_move( chiyou_entity,550,500, 900, 500 )
		-- 开始计时
		local dismiss_cb = callback:new();
	    local function dismiss( dt )
	    	local function cb()
				-- 显示所有怪物
				EntityManager:show_all_monster();
				XSZYManager:set_step(2);
				-- 指向挂机按钮
				XSZYManager:play_jt_and_kuang_animation_by_id( XSZYConfig.GUAJI_BTN,1, XSZYConfig.OTHER_SELECT_TAG );
			end
			JQDH:hide_panel_action(cb)
	    end
	    dismiss_cb:start(2,dismiss)
	elseif ( jq_type == 4 ) then 
		local function cb()
			XSZYManager:set_state_and_data( XSZYConfig.FENMODIAN,284 );
            -- 指向退出副本按钮
            XSZYManager:play_jt_and_kuang_animation_by_id(  XSZYConfig.TUICHUFUBEN_BTN,1 ,XSZYConfig.OTHER_SELECT_TAG );
        end
        JQDH:hide_panel_action(cb)
	elseif ( jq_type == 5 ) then
		local function cb() 
			EntityManager:show_all_monster();
			XSZYManager:set_step(2);
			-- 指向挂机按钮
			XSZYManager:play_jt_and_kuang_animation_by_id( XSZYConfig.GUAJI_BTN,1, XSZYConfig.OTHER_SELECT_TAG );
		end
		JQDH:hide_panel_action(cb)
	elseif ( jq_type == 6 ) then
		local function cb()  
			-- 指向退出副本按钮
            XSZYManager:play_jt_and_kuang_animation_by_id(  XSZYConfig.TUICHUFUBEN_BTN,1 ,XSZYConfig.OTHER_SELECT_TAG );
        end
        JQDH:hide_panel_action(cb)
    elseif ( jq_type == 7 ) then
		local function cb()  
			EntityManager:show_all_player_and_pet(  )
			-- 接着灵根指引
			XSZYManager:set_state_and_data( XSZYConfig.LINGGEN_ZY,333 )
			-- 显示右上角的图标 
			local win = UIManager:find_visible_window("right_top_panel")
			if win then
				if win.is_show == false then
					win:do_hide_menus_fun();
        			win.hide_btn:show_frame(1) 
				end
			end
			-- 指向功能菜单
			XSZYManager:play_jt_and_kuang_animation_by_id( XSZYConfig.GONGNENGCAIDAN_BTN,1 , XSZYConfig.OTHER_SELECT_TAG );
        end
        JQDH:hide_panel_action(cb)
    elseif ( jq_type == 8 ) then
		local function cb()
			XSZYManager:set_state_and_data( XSZYConfig.FUBEN_ZY );
            -- 指向退出副本按钮
            XSZYManager:play_jt_and_kuang_animation_by_id(  XSZYConfig.TUICHUFUBEN_BTN,1 ,XSZYConfig.OTHER_SELECT_TAG );
        end
        JQDH:hide_panel_action(cb)  
    elseif ( jq_type == 9 ) then
    	local function cb()
    		XSZYManager:set_state_and_data( XSZYConfig.FUBEN_ZY );
			-- 指向挂机按钮
			XSZYManager:play_jt_and_kuang_animation_by_id( XSZYConfig.GUAJI_BTN,1 , XSZYConfig.OTHER_SELECT_TAG );
			-- 显示所有怪物
			EntityManager:show_all_monster();
		end
		JQDH:hide_panel_action(cb)  
	elseif ( jq_type == 10 ) then	
		local function cb()
			XSZYManager:set_state_and_data( XSZYConfig.FUBEN_ZY );
            -- 指向退出副本按钮
            XSZYManager:play_jt_and_kuang_animation_by_id(  XSZYConfig.TUICHUFUBEN_BTN,1 ,XSZYConfig.OTHER_SELECT_TAG );
        end
        JQDH:hide_panel_action(cb)  
    elseif ( jq_type == 11 ) then
  		local function cb()
  			-- 显示所有怪物
			EntityManager:show_all_monster();
  			XSZYManager:continue_do_quest(2)
  		end	
    	JQDH:hide_panel_action(cb)
    elseif ( jq_type == 12 ) then
   		local function cb()
   			-- 显示所有怪物
			EntityManager:show_all_monster();
   			XSZYManager:continue_do_quest(2)
  		end	  	
    	JQDH:hide_panel_action(cb)
    elseif ( jq_type == 13 ) then
    	JQDH:destroy()
    	JQDH:play_animation(14)
    elseif jq_type == 14 then
   		local function cb()
   			-- 显示所有怪物
			EntityManager:show_all_monster();
			XSZYManager:set_state_and_data(XSZYConfig.XINSHOUFUBEN_ZY);
			-- 增加一个技能指引
			XSZYManager:play_jt_and_kuang_animation( 588,7,1 ,2,60,60,XSZYConfig.OTHER_SELECT_TAG );
  		end	  	
    	JQDH:hide_panel_action(cb)
    elseif jq_type == 15 then
    	local function cb()
   			-- 显示所有怪物
			EntityManager:show_all_monster();
			-- 向服务器申请刷小兵
			OnlineAwardCC:req_enter_birth_fuben()
			-- 向服务器申请加满怒气
			OnlineAwardCC:req_max_anger_value(  )
  			local win = UIManager:find_window("menus_panel");
			if ( win ) then
				win:show_or_hide_panel(false);
				XSZYManager:set_state_and_data( XSZYConfig.XINSHOUFUBEN_ZY,XSZYManager:get_data());
				DialogManager:show( nil , DialogManager.DIALOG_BISHAJI );
			end
  		end	  	
    	JQDH:hide_panel_action(cb)   	    	
    elseif jq_type == 16 then
   		local function cb()
   			-- 显示所有怪物
			EntityManager:show_all_monster();
  		end	  	
    	JQDH:hide_panel_action(cb)    
    elseif ( jq_type == 17 ) then
    	local function cb()
   			-- 显示所有怪物
			EntityManager:show_all_monster();
			-- require "control/GameLogicCC"
			-- GameLogicCC:req_talk_to_npc(0, "startPlay")		-- 这是跟服务器约定的
	    	OnlineAwardCC:req_enter_xinshoucun()
  		end
  		JQDH:hide_panel_action(cb,true)   	  
	end
end

-- 播放文字动画
function JQDH:play_text_animation( str )
	dialog:setText( "" );
	if ( self.text_play_timer ) then
		self.text_play_timer:stop();
		self.text_play_timer = nil;
	end

	self.text_play_timer = timer();
	local text_index = 0;
	local old_index = 0;
	local str_len = string.len(str);
	local function text_cb()
		-- 如果读完所有字符串，结束文字动画
		if ( text_index >= str_len ) then
			self.text_play_timer:stop();
			self.text_play_timer = nil;
			return;
		end
		-- 判断下一个字符是否为#
		--------------old
	-- 	local curr_str = string.sub(str,text_index+1,text_index+1);
	-- --	print("curr_str =",curr_str);
	-- 	if ( curr_str == "#") then
	-- 		old_index = text_index + 1;
	-- 		text_index = text_index + 11;
	-- 	else
	-- 		old_index = text_index + 1;
	-- 		text_index = text_index + 3;
	-- 	end
		--print("text_index",text_index )
		local curr_str = string.sub(str,text_index+1,text_index+1);
		--print("curr_str =",curr_str);
		if ( curr_str == "#") then
			-- print("run if")
			old_index = text_index + 1;
			text_index = text_index + 8;
			local temp_str = string.sub( str, text_index+1, text_index + 2)
			-- print("temp_str", temp_str)
			local world_num =  ZXTexAn:shareTexAn():getUTF8Len( temp_str )
			-- print("world_num", world_num)
			text_index = text_index + world_num
		else
			-- print("run else")
			local sumnum =  ZXTexAn:shareTexAn():getUTF8Len(curr_str)
			-- print("sumnum",sumnum)
			old_index = text_index + 1;
			text_index = text_index + sumnum;
		end
		local result_str = string.sub(str,old_index,text_index)
		-- print("result_str = ",result_str);
		-- print("----------------------")
		dialog:insertText(result_str);	
	end
	self.text_play_timer:start(0.05,text_cb);
end

function JQDH:entity_move( entity,move_x,_time )
	is_entitiy_moving = true;
	local start_x = entity.model.m_x;
	local start_y = entity.model.m_y;
	entity:startMoveFrom(start_x,start_y, start_x + move_x, start_y );
	-- 开始计时
	local dismiss_cb = callback:new();
    local function dismiss( dt )
    	if ( dialog_index <= #jq_action_table ) then 
			is_entitiy_moving = false;
			JQDH:next_jq();
		end
    end
    dismiss_cb:start(_time,dismiss)

end

function JQDH:create_entity_by_type( create_type,action_info,is_init )
	if create_type == nil then
		create_type = 0;
	end

	if create_type == 1 then
		local offect_y = 200;
		JQDH_ENTITY_START_HANDLE = JQDH_ENTITY_START_HANDLE + 1
		local entity_body_id = action_info.entity_body_id;
		local entity_tag = action_info.entity_tag;
		local x,y = SceneManager:view_pos_to_world_pos( action_info.pos_x, action_info.pos_y+offect_y )
		local entity_name = "";
		if entity_body_id == 0 then
			entity_body_id = player.body;
			entity_name = player.name;
		else
			entity_name = action_info.entity_name;
		end
		jq_entity_table[ entity_tag ] = JQDH:create_entity( JQDH_ENTITY_START_HANDLE,action_info.entity_type,
			entity_name,x,y,entity_body_id,action_info.dir,600,
			EntityConfig.ENTITY_TYPE[action_info.entity_type]);
		local _timer = timer();
		local _index = 1;
		local _old_spr = nil;
		local _entity = jq_entity_table[ entity_tag ];
		local _move_y = offect_y/20;
		-- 播放特效
		local point = CCPoint(_entity.model.m_x ,_entity.model.m_y+200)
		ZXGameScene:sharedScene():mapPosToGLPos(point)
		LuaEffectManager:play_map_effect( 9001,point.x,point.y,false,10000 )
		-- -- 实体从天而降
		local function timer_fun()
			if old_spr then
				old_spr:removeFromParentAndCleanup(true);
				old_spr = nil;
			end
			old_spr = _entity.model:get_body():createCurrentFrame( true )
			SceneManager.SceneNode:addChild(old_spr)
			_entity.model:relocate( _entity.model.m_x,_entity.model.m_y + _move_y )
			_index = _index + 1;
			if _index == 20 then
				is_entitiy_moving = false;
				_timer:stop();
				_timer = nil;
				if old_spr then
					old_spr:removeFromParentAndCleanup(true);
					old_spr = nil;
				end
				JQDH:next_jq();
			end
		end
		_timer:start(0.05,timer_fun);
	elseif create_type == 0 then
		JQDH_ENTITY_START_HANDLE = JQDH_ENTITY_START_HANDLE + 1
		local entity_body_id = action_info.entity_body_id;
		local entity_tag = action_info.entity_tag;
		local x,y = SceneManager:view_pos_to_world_pos( action_info.pos_x, action_info.pos_y )
		local entity_name = "";
		-- 是否需要更新武器
		local weapon_id = nil;
		if entity_body_id == 0 then
			if action_info.entity_type == 2 then
				entity_body_id = PLAYER_KNEEL_FRAME[player.job]
			else
				entity_body_id = player.body;
				if SceneManager:get_cur_fuben() == 75 then
					entity_body_id = EntityFrameConfig:get_60lv_body_id( player.job );
					weapon_id = EntityFrameConfig:get_60lv_weapon_id( player.job )
					print("weapon_id",weapon_id);	
				end			
			end
			entity_name = player.name;
		else
			entity_name = action_info.entity_name;
			-- entity_name = string.gsub(entity_name, "@player", player.name);
		end
		jq_entity_table[ entity_tag ] = JQDH:create_entity( JQDH_ENTITY_START_HANDLE,action_info.entity_type,
			entity_name,x,y,entity_body_id,action_info.dir,600,
			EntityConfig.ENTITY_TYPE[action_info.entity_type]);
		is_entitiy_moving = false;
		if is_init == false then
			local delay_time = action_info.delay_time;
			JQDH:delay_do_action( delay_time )
		end
		if weapon_id then
			jq_entity_table[ entity_tag ]:update_weapon(weapon_id)
		end

	elseif create_type == 2 then
		JQDH_ENTITY_START_HANDLE = JQDH_ENTITY_START_HANDLE + 1
		local entity_body_id = action_info.entity_body_id;
		local entity_tag = action_info.entity_tag;
		local x,y = SceneManager:view_pos_to_world_pos( action_info.pos_x, action_info.pos_y )
		local entity_name = "";
		if entity_body_id == 0 then
			entity_body_id = player.body;
			entity_name = player.name;
		else
			entity_name = action_info.entity_name;
		end
		jq_entity_table[ entity_tag ] = JQDH:create_entity( JQDH_ENTITY_START_HANDLE,action_info.entity_type,
			entity_name,x,y,entity_body_id,action_info.dir,600,
			EntityConfig.ENTITY_TYPE[action_info.entity_type]);
		local effect_animation_table = effect_config[3];
		-- 播放特效
		jq_entity_table[ entity_tag ].model:playEffect( effect_animation_table[1],3, 2, effect_animation_table[3],nil,1,0,500,effect_animation_table[2] );		

		if is_init == false then
			local delay_time = action_info.delay_time;
			JQDH:delay_do_action( delay_time )
		else
			is_entitiy_moving = false;
		end		
	end
end

function JQDH:create_entity( handle,entity_type,name,x,y,body_id,dir,moveSpeed,entity_type_str)
	local new_entity = EntityManager:create_entity( handle, entity_type_str );
	local model = ZXEntityMgr:sharedManager():createEntity(handle, entity_type, x, y, body_id, dir, moveSpeed)
	new_entity:change_entity_attri("model", model)
	new_entity:change_entity_attri("body", body_id)	
	new_entity:change_entity_attri("dir", dir)	
	if new_entity.name_lab == nil then
		local bill_board_node = model:getBillboardNode()
		local bill_board_node_size = bill_board_node:getContentSize()
		local bill_board_node_pos_x, bill_board_node_pos_y = bill_board_node:getPosition()
		local name_lab = Label:create( nil, 0, 0, name )
		new_entity.name_lab = name_lab
		local name_lab_size = name_lab:getSize()			
		bill_board_node:addChild(name_lab.view)
		name_lab:setPosition( ( bill_board_node_size.width - name_lab_size.width ) / 2, 0 )	
	else
		new_entity.name_lab.view:setText( name )
	end
	--model:setName(name)
	return new_entity;
end

function JQDH:destroy_jqdh_entity( entity,die_type )
	if die_type == nil then
		die_type = 1;
	end

	if die_type == 2 then
		LuaEffectManager:play_monster_dead_effect( entity ,0)
		local _cb = callback:new();
		local function cb_fun()
			entity:destroy()
		end
		_cb:start(0.5,cb_fun);
	elseif die_type == 1 then
		if entity ~= nil then
			entity:destroy()
		end	
	end
end

function JQDH:destroy()
	if ( dismiss_cb ) then
		dismiss_cb:cancel();
		dismiss_cb = nil;
	end
	if ( panel ) then
		panel:removeFromParentAndCleanup(true);
		panel = nil;
	end

	dialog = nil;
	dialog_index = 0;
	bottom_bg = nil;
	pcall(function()
		if hand then
			hand:removeFromParentAndCleanup(true)
		end
	end)
	hand = nil;
	player = nil;
	jq_type = nil;
	jq_entity_table = {};
	jq_action_table = {};
	jq_head_table = {};
	old_head_id = nil;
	black_screen_str = nil;
	is_show_monster = true;

	is_entitiy_moving = false ;
	is_text_animation_playing = false;
	JQDH_ENTITY_START_HANDLE = 8888888;
	local player = EntityManager:get_player_avatar();
	if player then
		player.is_jqdh = false;
		player.model:setIsVisible(true);
	end
end

function JQDH:is_show_monster()
	return is_show_monster;
end