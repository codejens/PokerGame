--- LuaEffectManager.lua
-- created by hcl on 2013-4-18
-- 特效管理器 C++层负责特效的创建，Lua层控制如何播放

LuaEffectManager = {}
--求相对屏幕大小的函数
local _refWidth =  UIScreenPos.relativeWidth
local _refHeight = UIScreenPos.relativeHeight

--全屏大小
local _ui_width = GameScreenConfig.ui_screen_width 
local _ui_height = GameScreenConfig.ui_screen_height
	
--半屏大小
local _ui_half_width = _ui_width * 0.5
local _ui_half_height = _ui_height * 0.5

local _ui_bag_x = 120
local _ui_forge_x = 426

local _ui_tongji_x = 120
local _ui_tongji_y = 377

local math_random = math.random
local math_pow = math.pow
local math_sqrt = math.sqrt
local math_abs = math.abs
local math_floor = math.floor
local math_pi = math.pi
local math_cos = math.cos
local math_sin = math.sin
local math_acos = math.acos
local math_dot = math.dot
function LuaEffectManager:init(root)
	require 'effect/EffectBuilder'
	self.sceneRoot = root
	self.UIRoot    = SceneManager.UIRoot
	self.SceneRoot = SceneManager.SceneNode
	self.EffectMgr = ZXEffectManager:sharedZXEffectManager();
	self.get_item_effect_timer = timer()
	self.get_item_effect_queue = {}

	local _logicScene = ZXLogicScene:sharedScene()

	EffectBuilder:init(_logicScene)
end

-- 播放场景特效  
-- scene_effect_id 场景特效id
-- x,y 场景特效播放的位置
function LuaEffectManager:play_scene_effect( scene_effect_id,x,y,z,times )
	local ani_table = effect_config[scene_effect_id];
	--ZXLogicScene:sharedScene():playEffect(ani_table[1],ani_table[3],ani_table[2],x,y);
	if ( z == nil ) then
		z = 20;
	end
	local view = self.UIRoot 
	if times == nil or times <= 0 then
		self.EffectMgr:run_one_animation_action(ani_table[1], view ,ani_table[3],scene_effect_id,0,0,ani_table[2],x , y,z);
	else
		self.EffectMgr:run_one_animation_action(ani_table[1], view ,ani_table[3],scene_effect_id,0,times,ani_table[2],x , y,z)
	end
end

-- 控件播放特效
-- view_effect_id 特效id
-- x,y 特效播放的位置
function LuaEffectManager:play_view_effect( view_effect_id,x,y,view,is_forever,z,times )
	if view then
		local ani_table = effect_config[view_effect_id];
		if ( z == nil ) then
			z = 10;
		end

		local sp = nil
		if ( is_forever ) then 
			--self.EffectMgr:run_forever_action(ani_table[1], view ,ani_table[3],view_effect_id ,x , y,z,ani_table[2]);
			sp = EffectBuilder.createAnimation(ani_table[1],ani_table[3],-1)
			
		elseif times ~= nil and times > 1 then
			sp = EffectBuilder.createAnimation(ani_table[1],ani_table[3],times)
		else
			sp = EffectBuilder.createAnimation(ani_table[1],ani_table[3],1)
		end
		--sp:setAnchorPoint(CCPointMake(0,0))
		local size = view:getContentSize()
		x = x or size.width*0.5
		y = y or size.height*0.5
		sp:setPosition(CCPointMake(x,y))
		-- sp:setPosition(x,y)
		view:addChild(sp,z,view_effect_id)
		return sp;
	end
	--sp:setTag(view_effect_id)
end

-- 停止控件的特效播放
function LuaEffectManager:stop_view_effect( view_effect_id,view )
	local effect_node  = view:getChildByTag( view_effect_id );
	if ( effect_node ) then
		--print("删除特效")
		effect_node:removeFromParentAndCleanup(true);
	end
end

-- 播放在地图上的特效
function LuaEffectManager:play_map_effect( view_effect_id,x,y,is_forever,z,time ,tag,times)
	--xprint('LuaEffectManager:play_map_effect',view_effect_id)
	local ani_table = effect_config[view_effect_id];

	if ( z == nil ) then
		z = 10;
	end
	if ( time == nil ) then
		time = 0;
	end
	if ( tag == nil ) then
		tag = view_effect_id;
	end
	local view = ZXLogicScene:sharedScene():getSceneNode();
	-- 不知道这里self.EffectMgr在哪置空,手动赋值一次 使其不报错
	if not self.EffectMgr then
		self.EffectMgr = ZXEffectManager:sharedZXEffectManager();
	end
	if ( is_forever ) then 
		self.EffectMgr:run_forever_action(ani_table[1], view ,ani_table[3],tag ,x , y,z,ani_table[2]);
	elseif times ~= nil and times > 1 then
		--self.EffectMgr:runNTimesAnimationAction(ani_table[1] ,view, ani_table[3], tag, 0, 0, ani_table[2], x, y, z, times );
	else
		self.EffectMgr:run_one_animation_action( ani_table[1] ,view,ani_table[3],tag,0,time ,ani_table[2] , x , y, z );
	end
end

function LuaEffectManager:play_entity_root_effect( view_effect_id,x,y,is_forever,z,time ,tag,times)
	
	local ani_table = effect_config[view_effect_id];

	if ( z == nil ) then
		z = 0;
	end
	if ( time == nil ) then
		time = 0;
	end
	if ( tag == nil ) then
		tag = view_effect_id;
	end
	local view = ZXLogicScene:sharedScene():getEntityNode();
	if ( is_forever ) then 
		self.EffectMgr:run_forever_action(ani_table[1], view ,ani_table[3],tag ,x , y,z,ani_table[2]);
	elseif times ~= nil and times > 1 then
		--self.EffectMgr:runNTimesAnimationAction(ani_table[1] ,view, ani_table[3], tag, 0, 0, ani_table[2], x, y, z, times );
	else
		self.EffectMgr:run_one_animation_action( ani_table[1] ,view,ani_table[3],tag,0,time ,ani_table[2] , x , y, z );
	end
end

function LuaEffectManager:stop_map_effect( effect_id )
	local view = ZXLogicScene:sharedScene():getSceneNode();
	local effect_node = view:getChildByTag(effect_id)
	if ( effect_node ) then
		effect_node:removeFromParentAndCleanup(true);
	end
end

-- 播放血条闪烁的特效
function LuaEffectManager:play_hp_blink_effect( view )
	if not AppGameMessages.isForeGround then
		return
	end
	-- print("LuaEffectManager:play_hp_blink_effect( view )")
	local blink_rect = MUtils:create_sprite( view.view ,"nopack/hp_ani.png",43.5,7.5);
    --blink_rect:setColor(0xffff0000)
    --blink_rect:setOpacity(100);

    local fade_out = CCFadeOut:actionWithDuration(1);
    local fade_in = CCFadeIn:actionWithDuration(1);
	local array = CCArray:array();
	array:addObject(fade_out);
	array:addObject(fade_in);
	local seq = CCSequence:actionsWithArray(array);
	local action = CCRepeatForever:actionWithAction(seq);
	blink_rect:runAction( action );
	return blink_rect;
end

-- 怪物死亡的动画
function LuaEffectManager:play_monster_dead_effect( _entity ,is_hit_fly)
	local time_miss = 0.35
	if not AppGameMessages.isForeGround then
		return
	end
--	print("播放怪物死亡动画")
	local entity = _entity;

	local hit_fly_x = 0;

	-- if ( is_hit_fly == 1 ) then
		local player = EntityManager:get_player_avatar();
		if ( player.x > entity.model.m_x ) then 
			hit_fly_x = -150;
		else
			hit_fly_x = 150;
		end

		local act_dead = CCMoveBy:actionWithDuration( 0.1, CCPoint(hit_fly_x,0));
		local dead_act_arr = CCArray:array()
	    dead_act_arr:addObject(CCDelayTime:actionWithDuration(0.25))
	    dead_act_arr:addObject(act_dead)
	    local seq_dead = CCSequence:actionsWithArray(dead_act_arr)
		-- local action = CCEaseIn:actionWithAction(action,4.5);
		entity.model:runAction(seq_dead);
	-- end

	--local fade_out_action = CCFadeOut:actionWithDuration(0.3);
	--entity.model:get_body():runAction(fade_out_action);

	local fadeto_cb = callback:new();
	-- 怪物死亡时所在的坐标
	local ccp = CCPoint(entity.model.m_x + hit_fly_x,entity.model.m_y);
	SceneManager.game_scene:mapPosToGLPos(ccp)

	-- 死亡播放特效(渐变消失)

	-- local function dismiss( dt )
	-- 	if ( entity.model ) then
	-- 		entity.model:get_body():setIsVisible(false);
	-- 	end
	-- 	-- 去掉云雾效果
	-- 	-- LuaEffectManager:play_entity_root_effect( 23,ccp.x,ccp.y,false);
 --    end
 --    fadeto_cb:start( time_miss,dismiss);
    entity.model:fadeOut( time_miss )
    -- local fadeOut = CCFadeOut:actionWithDuration(1.8)
    -- entity.model:get_body():runAction(fadeOut)
    entity:dieAction()
end

local function doGetItemTick( dt )
	-- body
	if #LuaEffectManager.get_item_effect_queue == 0 then
		LuaEffectManager.get_item_effect_timer:stop()
	else
		local _job = table.remove(LuaEffectManager.get_item_effect_queue, 1)
		_job()
	end
end
-- 播放得到一定数量的道具特效 139 67
function LuaEffectManager:play_get_items_effect( item_effect_table )
	if not AppGameMessages.isForeGround then
		return
	end

	local len  =#item_effect_table/3
	--[[
	local i = 1;
	
	local function cb()
		-- 1物品2金钱
		if ( item_effect_table[(i-1)*3+1] == 1 ) then
			local item_id = item_effect_table[(i-1)*3+2];
			local item_path = ItemConfig:get_item_icon( item_id );
			print("播放获取道具的特效.........................",item_id,item_path);
			LuaEffectManager:play_get_item_effect( item_path ,395,300 ,item_effect_table[(i-1)*3+3])
		else -- 金钱
			local money_type = item_effect_table[(i-1)*3+2];
			print("LuaEffectManager:play_get_items_effect:::",money_type);
			local item_path = "icon/money/"..money_type..".png";
			LuaEffectManager:play_get_item_effect( item_path ,395,300 ,item_effect_table[(i-1)*3+3] )
		end
		i = i + 1;
		if ( i > len ) then
			effect_timer:stop();
		end
	end
	]]--

	for i=1, len do
		local isitem = ( item_effect_table[(i-1)*3+1] == 1 )
		local isMoney = ( item_effect_table[(i-1)*3+1] == 2 )
		local isGemMeta = ( item_effect_table[(i-1)*3+1] == 3 )
		if isitem then
			local item_id = item_effect_table[(i-1)*3+2];

			-- 暂时屏蔽装备的动画飘落 
			local item_info = ItemConfig:get_item_by_id( item_id )
			local player = EntityManager:get_player_avatar()
			if player.level > 32 or item_info.type == ItemConfig.ITEM_TYPE_UNDEFINE or item_info.type > ItemConfig.ITEM_TYPE_SHOES then
				local item_path = ItemConfig:get_item_icon( item_id );
				local item_count = item_effect_table[(i-1)*3+3]

				--放入队列
				self.get_item_effect_queue[#self.get_item_effect_queue+1] = 
				function()
					LuaEffectManager:play_get_item_effect( item_path ,_ui_half_width,_ui_half_height ,item_count, _ui_bag_x)
				end
			end	
		elseif isMoney then
			local money_type = item_effect_table[(i-1)*3+2];
			local item_path = "icon/money/"..money_type..".pd";
			--local item_path = "icon/money/"..money_type..".png";
			local item_count = item_effect_table[(i-1)*3+3] 
			--放入队列
			self.get_item_effect_queue[#self.get_item_effect_queue+1] = 
			function()
				LuaEffectManager:play_get_item_effect( item_path ,_ui_half_width,_ui_half_height,item_count, _ui_bag_x)
			end
		elseif isGemMeta then
			local meta_type = item_effect_table[(i-1)*3+2]
			local item_path = ForgeDialog:get_meta_icon_path( meta_type )
			local item_count = item_effect_table[(i-1)*3+3]
			-- 放入队列
			self.get_item_effect_queue[#self.get_item_effect_queue+1] = 
			function()
				LuaEffectManager:play_get_item_effect( item_path, _ui_half_width, _ui_half_height, item_count, _ui_forge_x)
			end
		end
	end

	if self.get_item_effect_timer:isIdle() then
		self.get_item_effect_timer:start(0.3,doGetItemTick)
	end

	--effect_timer:start(0.2,cb);
end


--天降雄狮  得到一个物品时飘到统计面板动画  add by xiehande
function  LuaEffectManager:play_get_items_effect2(item_type,item_id,item_num)

	if not AppGameMessages.isForeGround then
		return
	end
    
	local isitem = ( item_type == 2 )
	local isMoney = ( item_type== 1 )
	local isGemMeta = ( item_type == 3 )  --目前无用字段 宝石材料 

	if isitem then
		local item_path = ItemConfig:get_item_icon( item_id );
		local item_count = item_num
		--放入队列
		self.get_item_effect_queue[#self.get_item_effect_queue+1] = 
		function()
			LuaEffectManager:play_get_item_effect( item_path ,_ui_half_width,_ui_half_height ,item_count, _ui_tongji_x,_ui_tongji_y)
		end

	elseif isMoney then
		local money_type = item_id;
        
        print("掉落的不是装备类型的物品类型",money_type)
       
		if money_type==11 or money_type ==12 then    --历练
           --只有历练副本从怪物身上掉历练值 在GameLogicCC:do_entity_died 已处理特效 这里不需要处理  by xiehande
		else
			local item_path = "icon/money/"..money_type..".pd";
			local item_count = item_num
			--放入队列
			self.get_item_effect_queue[#self.get_item_effect_queue+1] = 
			function()
				LuaEffectManager:play_get_item_effect( item_path ,_ui_half_width,_ui_half_height,item_count, _ui_tongji_x,_ui_tongji_y)
			end
		end
		


	elseif isGemMeta then
		local meta_type = item_id
		local item_path = ForgeDialog:get_meta_icon_path( meta_type )
		local item_count = item_num
		-- 放入队列
		self.get_item_effect_queue[#self.get_item_effect_queue+1] = 
		function()
			LuaEffectManager:play_get_item_effect( item_path, _ui_half_width, _ui_half_height, item_count, _ui_tongji_x,_ui_tongji_y)
		end
	end

	if self.get_item_effect_timer:isIdle() then
		self.get_item_effect_timer:start(0.3,doGetItemTick)
	end
end


-- 得到一个物品时飘道具到背包栏的动画 139 68
function LuaEffectManager:play_get_item_effect( icon_path ,x,y ,count, to_x, to_y)
	
	if not AppGameMessages.isForeGround then
		return
	end

	local ui_node = ZXLogicScene:sharedScene():getUINode();
    --local spr = MUtils:create_sprite(ui_node,icon_path,x,y,99999);
    local spr = SlotBase(48,48);
    spr.view:setScale(1.3333)
    spr.view:setPosition(x,y);
    spr.view:setAnchorPoint(0.5,0.5);
    spr:set_icon_texture( icon_path );
    spr:set_count(count);
    ui_node:addChild(spr.view,99999)

 --    if ( count > 1 ) then 
	--     -- 物品数量
	--     MUtils:create_zxfont(spr,tostring(count),30,5,1,9);
	-- end
	-- 创建加速移动动画
	local move_to = CCMoveTo:actionWithDuration(2.0,CCPoint(to_x or 70+66+33+15, to_y or 52));
	local move_ease_in = CCEaseIn:actionWithAction(move_to,3.0);
	local move_to2 = CCMoveTo:actionWithDuration(0.5,CCPoint(to_x or 70+66+33+15, to_y or 42));
	local move_ease_out = CCEaseOut:actionWithAction(move_to2,3.0)
	local remove_act = CCRemove:action()

	local array = CCArray:array();
	array:addObject(move_ease_in);
	array:addObject(move_ease_out);
	array:addObject(remove_act);
	local sequence = CCSequence:actionsWithArray(array);
    spr.view:runAction( sequence );
end



-- 播放必杀技按钮飘到必杀技位置的特效
function LuaEffectManager:play_bishaji_create_effect()
	local ui_node = ZXLogicScene:sharedScene():getUINode();
	local new_sys_panel = CCArcRect:arcRectWithColor(0,0,800,480, 0x00000000);
	ui_node:addChild(new_sys_panel,99998);
	local function panel_fun(eventType,x,y)
        if  eventType == TOUCH_BEGAN then
            return true;
        elseif eventType == TOUCH_CLICK then
        	return true;
        end
        return true;
    end
    new_sys_panel:registerScriptHandler(panel_fun);
    local anger_bg = MUtils:create_sprite(ui_node,"ui/main/m_anger_bg2.png",400,300,99999);
    anger_bg:setAnchorPoint(CCPoint(0,0));
    local anger_spr = MUtils:create_sprite( anger_bg ,"nopack/m_anger.png",31.5,0);
    anger_spr:setAnchorPoint(CCPoint(0.5,0));
    -- 播放燃烧的特效
    LuaEffectManager:play_view_effect( 10011,0,0,anger_spr ,true);
	-- 创建加速移动动画
	local move_to = CCMoveTo:actionWithDuration(2,CCPoint(740,33));
	local move_ease_in = CCEaseIn:actionWithAction(move_to,5.0);
	local cb = callback:new();
	local function dismiss( dt )
		anger_bg:removeFromParentAndCleanup(true);
    	new_sys_panel:removeFromParentAndCleanup(true);
        local win = UIManager:find_window("menus_panel");
        -- 显示必杀技按钮
        win.anger_btn.view:setIsVisible(true);
        print("指向必杀技按钮........................");
        -- 然后指向必杀技按钮
        -- XSZYManager:play_jt_and_kuang_animation_by_id( XSZYConfig.BISHAJI_BTN,1 , XSZYConfig.OTHER_SELECT_TAG);
        local function cb()
        	Analyze:parse_click_main_menu_info(32)
	        local player = EntityManager:get_player_avatar();
	        -- 如果怒气值满了
	        if ( player.anger == 100 ) then
	        	local win = UIManager:find_visible_window("menus_panel")
		        if ( ZXLuaUtils:band(player.state, EntityConfig.ACTOR_STATE_ZANZEN) == 0  ) then
	                player.anger = 0;
	                -- print("使用必杀技");
	                win.anger_spr.view:setTextureRect(CCRectMake(0,48,48.0,0));
	                -- 取消怒气值满的特效
	                LuaEffectManager:stop_view_effect( 10011,win.anger_spr.view );
	                CommandManager:use_bishaji();
	                -- 如果当前是必杀技指引
	                --[[if ( XSZYManager:get_state() == XSZYConfig.BISHAJI_ZY ) then 
	                    XSZYManager:destroy_jt( XSZYConfig.OTHER_SELECT_TAG );
	                    -- 指向退出副本按钮
	                    XSZYManager:play_jt_and_kuang_animation_by_id( XSZYConfig.TUICHUFUBEN_BTN ,1,XSZYConfig.OTHER_SELECT_TAG );
	                elseif XSZYManager:get_state() == XSZYConfig.XINSHOUFUBEN_ZY then
	                    XSZYManager:destroy_jt( XSZYConfig.OTHER_SELECT_TAG );
	                    OnlineAwardCC:req_create_boss(  )
	                    GlobalFunc:create_center_notic("#c66ff66前方传来界王神的波动")
	                    -- 创建一个移动的图片
	                    LuaEffectManager:play_map_effect(11008,1300,520,true,1000)

	                end--]]
		        end
	        else
	            GlobalFunc:create_screen_notic( "怒气值不足，不能释放" ); -- [1449]="怒气值不足，不能释放"
	        end
        end
        -- XSZYManager:lock_screen_by_id( XSZYConfig.BISHAJI_BTN,1 ,cb );
    end
    cb:start( 2,dismiss)
    anger_bg:runAction( move_ease_in );
end

-- 播放左右移动的动画
function LuaEffectManager:run_move_animation( direction ,view)
	--print("direction = ",direction);
	local x,y;
	if ( direction == 1 ) then
		x = 20;
		y = 0;
	elseif ( direction == 2 ) then
		x = -20;
		y = 0;
	elseif ( direction == 3 ) then
		x = 0;
		y = -20;
	elseif ( direction == 4 ) then
		x = 0;
		y = 20;
	end
	-- local array = CCArray:array();
	local moveby = CCMoveBy:actionWithDuration(0.4,CCPoint(x,y));
	local moveby2 = CCMoveBy:actionWithDuration(0.4,CCPoint(-x,-y));
	-- array:addObject(moveby);
	-- array:addObject(moveby2);
	local sequence = CCSequence:actionOneTwo(moveby,moveby2 );
	local action = CCRepeatForever:actionWithAction(sequence)
	view:runAction(action)

end

-- 播放地图重复滚动的动画
function LuaEffectManager:play_bg_scroll( parent,bg1_path,bg2_path )
	require "utils/MUtils"
	local bg1 = MUtils:create_sprite(parent,bg1_path,400,240);
	local moveto = CCMoveTo:actionWithDuration(4,CCPoint(-400,240));
	
	local timer1 = timer();
	local function time_fun1()
		bg1:setPosition(1200,240);
		local moveto = CCMoveTo:actionWithDuration(4,CCPoint(-400,240));
		bg1:runAction(move_to);
	end

	local bg2 = MUtils:create_sprite(parent,bg1_path,1200,240);
	local moveto = CCMoveTo:actionWithDuration(8,CCPoint(-400,240));
	local timer2 = timer();
	local function time_fun2()
		bg1:setPosition(1200,240);
		local moveto = CCMoveTo:actionWithDuration(4,CCPoint(-400,240));
		bg1:runAction(move_to);
	end

	bg1:runAction(move_to);
	timer1:start(4,time_fun1)
end

-- 播放取得经验特效
function LuaEffectManager:play_get_exp_effect( exp )
	print("播放取得经验特效............................")
	local ui_node = ZXLogicScene:sharedScene():getUINode();
	ZXEffectManager:sharedZXEffectManager():run_get_exp_action(ui_node,600,6);

	--local _node = CCNode:node();
	--_node:setPosition(600,6);
	--ui_node:addChild(_node,1000);
	local function cb()
		local player = EntityManager:get_player_avatar();
		local entity_top_node = player.model:getBillboardNode();
		local yOffset = entity_top_node:getPositionY();
		-- TextEffect:FlowText(player.model, yOffset ,'exp', FLOW_COLOR_TYPE_GREEN, '+' .. tostring(exp))
		TextEffect:FlowText(player.model, yOffset ,'exp', 'exp', '+' .. tostring(exp))
		--ZXEffectManager:sharedZXEffectManager():run_attr_change_action( _node,"#c66ff66获得经验+"..exp);
	end
	local callback_get_exp = callback:new();
	callback_get_exp:start(3,cb);
end


-- 播放取得历练值特效
function LuaEffectManager:play_get_lilian_effect( dead_entity )
	print("播放取得历练值特效............................")
	local ui_node = ZXLogicScene:sharedScene():getUINode();
	local node = CCNode:node();
	local x,y = SceneManager:world_pos_to_view_pos(dead_entity.model.m_x,dead_entity.model.m_y )
	node:setPosition(x,y+40)
	ui_node:addChild(node,100000);
	LuaEffectManager:play_view_effect( 46,0,0,node,true,100000 )

	if node then
		local move_to = CCMoveTo:actionWithDuration(2,CCPoint(90,_ui_tongji_y));--飘到统计面板
		local move_ease_in = CCEaseIn:actionWithAction(move_to,3.0);
		local array = CCArray:array();
		array:addObject(move_ease_in)
		array:addObject(CCRemove:action());
		local seq = CCSequence:actionsWithArray(array)
		node:runAction(seq);
		local function cb()
			LuaEffectManager:play_view_effect( 47,90,_ui_tongji_y,ui_node,false,100000 )
		end
		local callback_get_lilian = callback:new();
		callback_get_lilian:start(2,cb);
	end
end

-- 播放淡入淡出特效
function LuaEffectManager:play_fade_in_fade_out_effect( view )
	local fade_out = CCFadeOut:actionWithDuration(1);
    local fade_in = CCFadeIn:actionWithDuration(1);
	local array = CCArray:array();
	array:addObject(fade_out);
	array:addObject(fade_in);
	local seq = CCSequence:actionsWithArray(array);
	local action = CCRepeatForever:actionWithAction(seq);
	view:runAction( action );
end 

local thunder_cb = nil;
local function thunder_function()
	-- 随即1-3个雷
	local num = math_random(1,10);
	local x,y,len = 0;
	if ( num < 7 ) then
		len = 1;
	elseif num < 9 then
		len = 2;
	else
		len = 3;
	end
	for i=1,len do
		x = math_random(652,1800);
		y = math_random(502,768);
		LuaEffectManager:play_map_effect(55,x,y,false ,5,0,i +1000*55 );
	end
	thunder_cb = callback:new()
	local time = math_random(2,8);
	thunder_cb:start(time,thunder_function);
end

-- 随即播放打雷特效
function LuaEffectManager:play_thunder_effect( )

	if not AppGameMessages.isForeGround then
		return
	end
	math_random(0,3);

	if ( thunder_cb ) then
		thunder_cb:cancel();
	end

	thunder_cb = callback:new()

	local time = math_random(2,8);
	thunder_cb:start(time,thunder_function);

end
-- 停止打雷特效
function LuaEffectManager:stop_thunder_effect()
	if ( thunder_cb ) then 
		thunder_cb:cancel();
		thunder_cb = nil;
	end
	for i=1,3 do
		LuaEffectManager:stop_map_effect( i +1000*55 );
	end
end

-- 定时让某个怪物说话
function LuaEffectManager:play_monster_talk( talk_content_index ,entity_handle,other_entity_handle,talk_order_table)
	local player = EntityManager:get_player_avatar();
	player.is_jqdh = true;
	-- 仙灵封印的怪物需要播放剧情动画 
	local jqdh_timer = timer();
	-- 对话内容
	require "../data/actions"
	local dialog_content_table = Actions[talk_content_index];
	local index = 1;
	local target_handle = nil;
	local function cb()
		if ( talk_order_table[index] == 1 ) then
			target_handle = entity_handle;
		else
			target_handle = other_entity_handle;
		end
		local entity = EntityManager:get_entity( target_handle )
		-- 如果实体还存在就说话，不存在就停止timer
		if ( entity ) then
			entity:talk( dialog_content_table[index] );
			index = index + 1;
			if ( index > #dialog_content_table ) then
				jqdh_timer:stop();
				jqdh_timer = nil;
				player.is_jqdh = false;
			end
		else
			jqdh_timer:stop();
			jqdh_timer = nil;
		end
	end
	jqdh_timer:start( t_talk_duration,cb );
end

-- 定时让血少于一直值的某个怪物说话 
function LuaEffectManager:play_monster_talk_with_hp( talk_content_index ,entity_handle,hp_rate_table)
	
	-- 主角进入剧情动画
	local player = EntityManager:get_player_avatar();
	player.is_jqdh = true;

	-- 仙灵封印的怪物需要播放剧情动画 
	local jqdh_timer = timer();
	-- 对话内容
	require "../data/actions"
	local dialog_content_table = Actions[talk_content_index];
	local index = 1;
	local function cb()
		local entity = EntityManager:get_entity( entity_handle )
		-- 如果实体还存在就说话，不存在就停止timer
		if ( entity ) then
			if ( entity.hp/entity.maxHp < hp_rate_table[index] ) then
				entity:talk( dialog_content_table[index] );
				index = index + 1;
				if ( index > #dialog_content_table ) then
					jqdh_timer:stop();
					jqdh_timer = nil;
					player.is_jqdh = false;
				end
			end
		else
			jqdh_timer:stop();
			jqdh_timer = nil;
		end
	end
	jqdh_timer:start( 1,cb );
end

-- 播放让某个图片飘到某到地方的动画
function LuaEffectManager:play_fly_animation( img_path ,img_start_pos_x,img_start_pos_y,img_to_pos_x,img_to_pos_y,cb_fun)
	if not AppGameMessages.isForeGround then
		return
	end

	local ui_node = ZXLogicScene:sharedScene():getUINode();

	local spr = MUtils:create_sprite(ui_node,img_path,img_start_pos_x,img_start_pos_y,5000);
	spr:setScaleX(54/65);
	spr:setScaleY(54/65);
	-- 创建加速移动动画
	local move_to = CCMoveTo:actionWithDuration(2,CCPoint(img_to_pos_x,img_to_pos_y));
	local move_ease_in = CCEaseIn:actionWithAction(move_to,5.0);
	local cb = callback:new();
	local function dismiss( dt )
		cb_fun();
		spr:removeFromParentAndCleanup(true);
    end
    cb:start( 2,dismiss)
    spr:runAction( move_ease_in );
end

-- 播放手指动画
function LuaEffectManager:playAniWithArgs( parent,tab_ani_path,width,height,speed,z )
	local first_frame = nil;
	local tab_size = #tab_ani_path;
	local animFrames = CCMutableArray_CCSpriteFrame__:new_local(tab_size)
	for i=1,tab_size do
		local pTexture = CCTextureCache:sharedTextureCache():addImage(tab_ani_path[i]);
		local sprFrame = CCSpriteFrame:frameWithTexture(pTexture,CCRectMake(0,0,width,height));
		if i == 1 then
			first_frame = sprFrame;
		end
		animFrames:addObject(sprFrame)
	end
    local animation = CCAnimation:animationWithFrames(animFrames, speed)
    local animate = CCAnimate:actionWithAnimation(animation, false);
	local repeat_action = CCRepeatForever:actionWithAction(animate);
	local spr = CCSprite:spriteWithSpriteFrame(first_frame);
	parent:addChild(spr,z);
	spr:setAnchorPoint(CCPoint(0,0));
	spr:runAction(repeat_action);
	return spr;
end


function LuaEffectManager:SpellEffect(skill_id,entity)

	if not AppGameMessages.isForeGround then
		return
	end

	if skill_id == 30 then
		local model = entity.model
		local tp = CCPointMake(model.m_x, model.m_y)
		local p = CCParticleSystemQuadEx:particleWithFile('particle/tp.plist')
		local cb = callback:new()
		ZXGameScene:sharedScene():mapPosToGLPos(tp)
		p:setPosition(tp.x,tp.y)
		WeatherSystem.root:addChild(p,6)
		cb:start(1.0, function() p:removeFromParentAndCleanup(true) end)
   end

end

function LuaEffectManager:scene_leave()
	self.get_item_effect_timer:stop()
	self.get_item_effect_queue = {}

	-- 退出的时候检查当前是否在播放战斗力特效
	LuaEffectManager:destroy_fight_value_effect()
	-- 退出的时候检查是否正在播放场景文字特效
	LuaEffectManager:destroy_scene_font_effect();
end

function LuaEffectManager:onPause()
	self.get_item_effect_timer:stop()
	self.get_item_effect_queue = {}

	-- 退出的时候检查当前是否在播放战斗力特效
	LuaEffectManager:destroy_fight_value_effect()
	-- 退出的时候检查是否正在播放场景文字特效
	LuaEffectManager:destroy_scene_font_effect();
end

function LuaEffectManager:onResume()
end

function LuaEffectManager:showEffect(effect_id, time)
	if effect_id == 1 then
		FlowerEffect:play(time)
	elseif effect_id == 5 then
		FlowerEffect:play(time)
	elseif effect_id == 6 then
		LuaEffectManager:play_comb_effect_by_id(effect_id, time)
	end
end

-- 播放战斗力变化的特效
function LuaEffectManager:play_fight_value_effect( curr_fight_value,old_value )

	if ( self.fight_value_effect_panel ) then
		LuaEffectManager:destroy_fight_value_effect();
	end

	local frame_time = 0.05;

	local temp_value = curr_fight_value - old_value;

	local x = _refWidth(0.5) + 70
	local y = _refHeight(0.35)

	local basepanel = CCBasePanel:panelWithFile( x, y, 400, 50,nil);
	basepanel:setAnchorPoint(0.5,0.5)
	self.fight_value_effect_panel = basepanel;
	self.UIRoot:addChild(basepanel,999);
	--basepanel:addChild(CCDebugRect:create())
	-- 战斗力 
	self.prefix = MUtils:create_sprite(basepanel,"ui/fonteffect/f_v.png",-70,30);

	self.prefix:setScale(0.0)
	self.prefix:runAction(effectCreator.createScaleInOut(0.1,1.2,0.2,1.0))
	local cur_panel = CCTouchPanel:touchPanel(0, 0, 400, 50);
	basepanel:addChild(cur_panel,999);

	--cur_panel:addChild(CCDebugRect:create())
	-- 战斗力动画
	local num_len = string.len(curr_fight_value)
	local size = { num_len*51,50 }
	basepanel:setSize(size[1],size[2])
	cur_panel:setSize(size[1],size[2])
	-- 根据数字的长度调整位置
	--basepanel:setPosition( 300+(6-num_len)*51,150 );

	-- 保存所有动画精灵
	local ani_info_table = {}; 
	for i=1,num_len do
		local fight_value = curr_fight_value;
		if ( i~=1 ) then
			fight_value = fight_value % math_pow(10,num_len+1-i);
		end
		local pow_num = math_pow(10,num_len-i);
		local num = math_floor( fight_value/pow_num);
		-- print(fight_value,num,pow_num);
		local x = (i-1)*45;
		ani_info_table[i] = {};
		ani_info_table[i].spr = MUtils:create_sprite(cur_panel,"ui/fonteffect/f_v"..num..".png",x,51*num);
		ani_info_table[i].spr:setAnchorPoint(CCPoint(0,0));
		ani_info_table[i].spr:setIsVisible(false);
		ani_info_table[i].time = frame_time*num;
		ani_info_table[i].num = num;
		if ( ani_info_table[i-1] ) then 
			ani_info_table[i].time = ani_info_table[i].time + ani_info_table[i-1].time;
		end
		for j=0,num-1 do
			local spr = MUtils:create_sprite(ani_info_table[i].spr,"ui/fonteffect/f_v"..j..".png",0,-51*(num-j));
			spr:setAnchorPoint(CCPoint(0,0));
		end
	end

	self.fight_value_effect_timer = timer();
	local curr_time = 0;
	local index = 1;
	local next_ani_time = 0;
	--xiehande 添加的特效
	LuaEffectManager:play_fight_value_effect_add(basepanel,-70+100,39)
	local function ani_cb_fun()
		if ( curr_time >= next_ani_time ) then
			if ( index > #ani_info_table ) then
				self.fight_value_effect_timer:stop();
				self.fight_value_effect_timer = nil;
				--cur_panel:removeFromParentAndCleanup(true);
				LuaEffectManager:create_num_view( basepanel, temp_value ,51*num_len-20 );
				local function cb_fun()

					local remove_act = CCRemove:action()
					local moveby_act = CCMoveBy:actionWithDuration( 0.25 ,CCPoint(0,32) );
					local spr = self.fight_value_effect_panel
					local array = CCArray:array();
					array:addObject(moveby_act);
					array:addObject(remove_act);
					local sequence = CCSequence:actionsWithArray(array);
					spr:runAction(sequence);

					self.fight_value_effect_cb = nil;
					self.fight_value_effect_panel = nil;
					
					for k, v in ipairs(ani_info_table) do
						local fade_out = CCFadeOut:actionWithDuration(0.25);
						v.spr:runAction(fade_out);
					end
					local fade_out = CCFadeOut:actionWithDuration(0.25);
					self.prefix:runAction(fade_out);
				end
				self.fight_value_effect_cb = callback:new();
				self.fight_value_effect_cb:start( 2,cb_fun );
				return;
			end
			local move_by_time = ani_info_table[index].num*frame_time;
			local moveto_action = CCMoveBy:actionWithDuration( move_by_time ,CCPoint(0,-51*ani_info_table[index].num) );
			local spr = ani_info_table[index].spr
			spr:setOpacity(255)
			spr:setIsVisible(true);
			spr:runAction(moveto_action);
			next_ani_time = ani_info_table[index].time;
			index = index + 1;
			-- print("next_ani_time",next_ani_time);
		end
		curr_time = curr_time + 0.05;
		--print("curr_time",curr_time);
	end
	self.fight_value_effect_timer:start(0.05,ani_cb_fun);

end

--xiehande 
function LuaEffectManager:play_fight_value_effect_add(view, pos_x,pos_y )
	--function LuaEffectManager:play_view_effect( view_effect_id,x,y,view,is_forever,z,times )
   LuaEffectManager:play_view_effect( 406,pos_x,pos_y,view,true,-1);
end

function LuaEffectManager:create_num_view(parent, num,pos_x)
	
	local basepanel = CCBasePanel:panelWithFile( pos_x, 0, 200, 50,nil);
	basepanel:setAnchorPoint(0,0.5);
	parent:addChild(basepanel,999);
	local base_path = "ui/fonteffect/f_r";
	local action = nil;
	local num_len = string.len( num )
	if ( num < 0 ) then
		base_path = "ui/fonteffect/f_g";
		MUtils:create_sprite(basepanel,"ui/fonteffect/f_g.png",0,0);
		basepanel:setPosition(pos_x,90)
		action = CCMoveBy:actionWithDuration(1.0,CCPoint(0,-80));
		-- 因为负号占了一位
		num_len = num_len - 1;
	else
		MUtils:create_sprite(basepanel,"ui/fonteffect/f_r.png",0,0);
		basepanel:setPosition(pos_x,-10)
		action = CCMoveBy:actionWithDuration(1.0,CCPoint(0,80));
	end
	
	for i=1,num_len do
		local fight_value = math_abs(num);
		if ( i~=1 ) then
			fight_value = fight_value % math_pow(10,num_len+1-i);
		end
		local pow_num = math_pow(10,num_len-i);
		local num = math_floor( fight_value/pow_num);
		MUtils:create_sprite(basepanel,base_path..num..".png",i*25,0);
	end
	basepanel:runAction(action);
	return basepanel;
end

function LuaEffectManager:destroy_fight_value_effect()
	if ( self.fight_value_effect_panel ) then
		self.fight_value_effect_panel:removeFromParentAndCleanup(true);
		self.fight_value_effect_panel = nil;
	end
	if ( self.fight_value_effect_timer ) then
		self.fight_value_effect_timer:stop();
		self.fight_value_effect_timer = nil;
	end
	if ( self.fight_value_effect_cb ) then
		self.fight_value_effect_cb:cancel();
		self.fight_value_effect_cb = nil;
	end
end


local scene_timer = nil;
local scene_font_timer = nil;
local scene_font_panel = nil;
local skill_font_panel = nil
local all_font_tab= nil;
 
-- 播放场景描述字特效
function LuaEffectManager:play_scene_font_effect( scene_id )
	require "../data/scene_font"
	local str_tab = scene_font[scene_id];

	if ( str_tab == nil ) then
		return;
	end

	if ( scene_font_panel ) then
		LuaEffectManager:destroy_scene_font_effect();
	end

	scene_font_panel = CCBasePanel:panelWithFile( 750, 520, 200, 50,nil)
	SceneManager.UIRoot:addChild(scene_font_panel,100);
	
	scene_timer = timer();
	local index = 1;
	local function cb()
		if ( index == 1 ) then
			-- 重新拷贝一份
			local new_str_tab = {};
			for i=1,3 do
				new_str_tab[i] = str_tab[i];
			end
			LuaEffectManager:play_font_effect( new_str_tab );
		end	
		index = index + 1;
		if ( index == 7 ) then
			scene_timer:stop();
			scene_timer = nil;
			LuaEffectManager:destroy_scene_font_effect();
		elseif index == 6 then
			for i,v in ipairs(all_font_tab) do
				local fade_in = CCFadeOut:actionWithDuration(1);
				v:runAction( fade_in );
			end
		end
 	end
	scene_timer:start(1.5,cb);
	
end

-- 播放字体特效
function LuaEffectManager:play_font_effect( str_table )
	-- print("LuaEffectManager:play_font_effect( str_table )",str_table[1]);
	scene_font_timer = timer();
	local index = 1;
	local pos_x = 0;
	local pos_y = 0;
	local spr = nil;
	local font_tab = nil;
	all_font_tab = {};
	local function timer_fun()
		if index == 1 then
			-- print("timer_fun...............")
			local str = table.remove(str_table,1);
		    spr,font_tab = MUtils:create_font_spr( str,scene_font_panel,pos_x,pos_y,"ui/scene_font/",2)
			for i,v in ipairs(font_tab) do
				v:setOpacity(0);
			end
		end
		if font_tab[index] then
			local fade_in = CCFadeIn:actionWithDuration(0.15);
			font_tab[index]:runAction( fade_in );
			table.insert(all_font_tab,font_tab[index])
		end
		index = index + 1;
		if ( index > #font_tab ) then
			index = 1;
			pos_x = pos_x - 50;
			pos_y = pos_y - 20;
			if ( #str_table == 0 ) then
				scene_font_timer:stop();
				scene_font_timer = nil;
			end
		end
	end
	-- 马上执行一次
	timer_fun();
	scene_font_timer:start(0.15,timer_fun)
end

-- =================================
-- 播放字体临时使用
-- =================================
local just_timer = nil
local start_cb = nil
function LuaEffectManager:play_scene_font_effect_2( scene_id, fb_id )

	if fb_id ~= 0 then
		if ( scene_font_panel ) then
			LuaEffectManager:destroy_scene_font_effect();
		end
		return 
	end
	require "../data/scene_font"
	local str_tab = scene_font_2[scene_id]

	if ( str_tab == nil ) then
		return;
	end

	if ( scene_font_panel ) then
		LuaEffectManager:destroy_scene_font_effect();
	end

	-- local _refHeight = UIScreenPos.relativeHeight
	local panelHeight =  _refHeight(1.0)
	scene_font_panel = CCBasePanel:panelWithFile( 250, panelHeight*0.5+120, 120, 50,nil)
	SceneManager.UIRoot:addChild( scene_font_panel, 100 )

	local words_node = {}
	-- local cp_word_node = {}
	-- 添加文字图片
	local x_t = scene_font_2_pos[1]
	local y_t = scene_font_2_pos[2]
	for i=1, #str_tab do
		words_node[i] = MUtils:create_sprite( scene_font_panel, str_tab[i], x_t[i], y_t[i] )
		words_node[i]:setAnchorPoint(CCPoint(0, 1))
		-- if i == 3 then
		-- 	words_node[i]:setScale(1.2)
		-- else
			words_node[i]:setScale(1.2)
		-- end
		-- scene_font_panel:addChild( words_node[i] )
		words_node[i]:setOpacity(0)
		-- cp_word_node[i] = words_node[i]
	end

	-- 淡出
	local function  fade_out_func( )
		for i=1, #str_tab do
			local fade_out = CCFadeOut:actionWithDuration(3);
			words_node[i]:runAction(fade_out)
		end

		local cb = callback:new();
		local function cb_fun()
			LuaEffectManager:destroy_scene_font_effect()
			if cb then
				cb = nil
			end
		end
		cb:start(3,cb_fun);
	end

	-- 1
	just_timer = timer();
	local index = 0
	local num_str_tab = #str_tab
	local function time_func()
		index = index + 1
		if words_node[index] then
			local fade_in = CCFadeIn:actionWithDuration(1.5);
			words_node[index]:runAction(fade_in)
		end
		if index == num_str_tab+1 then
			fade_out_func()
			if just_timer then
				just_timer:stop()
				just_timer = nil
			end
		end
	end
	start_cb = callback:new()
	local function start_cb_func( ... )
		time_func()
		just_timer:start(1.5,time_func);
		if start_cb then
			start_cb = nil
		end
	end 
	start_cb:start(2,start_cb_func);
end

-- 添加技能特效文字
function LuaEffectManager:play_skill_effect( effect_id, player )
	local png_path_inter = "";
	if effect_id > 2500 then
		png_path_inter = "2500/"
	elseif effect_id >1700 then
		png_path_inter = "1700/"
	elseif effect_id >1600 then
		png_path_inter = "1600/"
	elseif effect_id >1100 then
		png_path_inter = "1100/"
	end

	local skill_word = CCSprite:spriteWithFile("ui/lh_skill_font/" .. png_path_inter .. effect_id .. ".png");
	local _logic_scene = ZXLogicScene:sharedScene()
	local temp_x = 50
	if player.dir < 4 then
		temp_x = -50
	else
		temp_x = 50
	end
	_logic_scene:addChildSceneLayer( skill_word, 2, player.model.m_x+temp_x, player.model.m_y-50, 1000, 1 )

	local fade_in = CCFadeOut:actionWithDuration(1.0)
	skill_word:runAction(fade_in)
	-- 特效
	local time_effect = 1.0
    self.cb_skill_effect = callback:new()
    local function cb_skill_effect_func()
    	if skill_word then
    		skill_word:removeFromParentAndCleanup(true)
    		skill_word = nil
    	end
    end
    self.cb_skill_effect:start( time_effect, cb_skill_effect_func )
end

-- 删除场景文字特效
function LuaEffectManager:destroy_scene_font_effect()
	-- print("删除场景文字特效LuaEffectManager:destroy_scene_font_effect()")
	if scene_timer then
		-- print("删除场景文字特效scene_timer")
		scene_timer:stop();
		scene_timer = nil;
	end
    if scene_font_timer then
    	-- print("删除场景文字特效scene_font_timer")
    	scene_font_timer:stop();
		scene_font_timer = nil;
    end
    if scene_font_panel then
    	scene_font_panel:removeFromParentAndCleanup(true);
    	scene_font_panel = nil;
    end
    all_font_tab = nil;

    if just_timer then
    	just_timer:stop()
    	just_timer = nil
    end
    if start_cb then
    	start_cb:cancel()
    	start_cb = nil
    end
end

----
function LuaEffectManager:play_comb_effect_by_id(id, time)
	local centerx = _refWidth(0.5)
	local centery = _refHeight(0.5)
	local dis_x = _refWidth(1/11)
	local dis_y = _refHeight(1/5)
	local pos_info = 
	{
		{ x = dis_x * 2, y = dis_y * 4 },
		{ x = dis_x * 4, y = dis_y * 4 + 20 },
		{ x = dis_x * 6, y = dis_y * 4 + 50 },
		{ x = dis_x * 8, y = dis_y * 4 + 20 },
		{ x = dis_x * 10, y = dis_y * 4 },
		{ x = dis_x * 2 + 30, y = dis_y * 2 },
		{ x = dis_x * 4 - 10, y = dis_y * 2 + 30 },
		{ x = dis_x * 6, y = dis_y * 2 }, 
		{ x = dis_x * 8, y = dis_y * 2 + 40 },
		{ x = dis_x * 10, y = dis_y * 2 },
	}
	if id == 6 then
		LuaEffectManager:play_scene_effect( 20006,centerx,centery,1000,10 * 1000 )
		for i = 1, #pos_info do
			LuaEffectManager:play_scene_effect( 20004,pos_info[i].x - 50,pos_info[i].y - 80,1000, 12.45 * 1000 )
		end
	end
end

function LuaEffectManager:fireEffect()

	-- local model = entity.model
	-- local tp = CCPointMake(model.m_x, model.m_y)
	local player = EntityManager:get_player_avatar();
	local p = CCParticleSystemQuad:particleWithFile('particle/test2.plist')
	p:setPosition(20,20)
	-- local cb = callback:new()
	-- ZXGameScene:sharedScene():mapPosToGLPos(tp)
	-- p:setPosition(tp.x,tp.y)
	-- self.UIRoot:addChild(p,10000);

	-- local move1 = CCMoveBy:actionWithDuration(1,CCPoint(300,0));
 --    local move2 = CCMoveBy:actionWithDuration(1,CCPoint(-300,0));
	-- local array = CCArray:array();
	-- array:addObject(move1);
	-- array:addObject(move2);
	-- local seq = CCSequence:actionsWithArray(array);
	-- local action = CCRepeatForever:actionWithAction(seq);
	player.model:getWeapon():addChild(p);
	-- p:runAction(action);
	-- cb:start(1.0, function() p:removeFromParentAndCleanup(true) end)

end

function LuaEffectManager:bodyEffect()

	local player = EntityManager:get_player_avatar();
	local p = CCParticleSystemQuad:particleWithFile('particle/test3.plist')
	p:setPosition(30,30)

	player.model:addChild(p);

end

function LuaEffectManager:testParticle()
	LuaEffectManager:BezierParticleY(2.0, 480, 320 - 180, 
										  480, 320 + 180, 0.3, 0.3, 
										  256 )	
end

function LuaEffectManager:getTailEffect( root, gem_path, gem_color, time, sx,sy, dx, dy, seg0, seg1, xOffset)
	
	local point = CCPoint(sx,sy)
	local y1 = dy * seg0 + sy * (1.0 - seg0)
	local y2 = dy * seg1 + sy * (1.0 - seg1)
	local rot = CCRotateBy:actionWithDuration(10, 1800);
	local png = CCSprite:spriteWithFile(gem_path)
	local flytime = time[1]
	local parTime = time[2]
	png:runAction(rot)
	local array = CCArray:array();
	array:addObject(CCDelayTime:actionWithDuration(flytime))
	array:addObject(CCFadeOut:actionWithDuration(0.25))
	local seq = CCSequence:actionsWithArray(array);
	png:runAction(seq)
	
	local par = CCParticleSystemQuad:particleWithFile('particle/gem_tails.plist')
	par:setPosition(point.x,point.y)
	local bezier1 = ccBezierConfig();
	bezier1.controlPoint_1 = CCPoint( sx + math_random(xOffset[1], xOffset[2]), y1 );
	bezier1.controlPoint_2 = CCPoint( sx + math_random(xOffset[1], xOffset[2]), y2);
	bezier1.endPosition = CCPoint(dx,dy);
	local bezierTo1 = CCBezierTo:actionWithDuration(flytime, bezier1 );
	
	local array = CCArray:array();
	array:addObject(bezierTo1)
	array:addObject(CCDelayTime:actionWithDuration(0.5))
	array:addObject(CCRemove:action())
	local seq = CCSequence:actionsWithArray(array);
	par:runAction(seq)
	par:setPositionType(1)
	par:setDuration(parTime)
	par:setStartColor(ccc4f(gem_color[1],gem_color[2],gem_color[3],255))
	par:addChild(png)
	root:addChild(par,100000);
end

function LuaEffectManager:addAngerValueEffect( entity_x,entity_y )
	print("LuaEffectManager:addAngerValueEffect( entity_x,entity_y )")
	local player = EntityManager:get_player_avatar();
	local p = CCParticleSystemQuad:particleWithFile('particle/test6.plist')
	-- local random_x = math_random(-100,100)
	-- local random_y = math_random(-100,100)
	local _y = -50;
	local old_x = player.model.m_x;
	local old_y = player.model.m_y + _y;
	-- print("old_x,old_y",old_x,old_y)
	local point = CCPoint(entity_x,entity_y)
	ZXGameScene:sharedScene():mapPosToGLPos(point)
	p:setPosition(point.x,point.y)
	p:setPositionType(1)
	-- p:setStartColor(ccc4f(math_random(0.1,1),math_random(0.1,1),math_random(0.1,1),1.0))
	-- p:setEndColor(ccColor4F(1,1,1,1.0))
	player.model:getParent():addChild(p,65565);

	local _speed = 0.1;
	local _timer = timer();
	local is_first = true;
	local index = 0;
	local speed = 300;
	local move_time = 0;
	local function timer_fun()
		if is_first then
			is_first = false;
			local random_x = math_random(-100,100)
			local random_y = math_random(-100,100)			
			local array = CCArray:array();
			local _time = math_random(0.3,0.5);
			move_time = move_time + _time;
			array:addObject(CCMoveBy:actionWithDuration(_time,CCPoint(random_x,random_y)))
			random_y = math_random(-60,0);
			_time = math_random(0.3,0.5);
			move_time = move_time + _time;
			array:addObject( CCMoveBy:actionWithDuration(_time,CCPoint(0,random_y) ) )
			_time = 0.3;	
			move_time = move_time + _time;	
			array:addObject(CCJumpBy:actionWithDuration(_time,CCPoint(math_random(-60,60),math_random(0,60)),10,1))	
			-- _time = math_random(0.2,0.3);	
			-- move_time = move_time + _time;	
			-- array:addObject(CCJumpBy:actionWithDuration(0.3,CCPoint(math_random(-40,40),math_random(0,40)),10,1))	

			local action = CCSequence:actionsWithArray(array);
			p:runAction(action);

		elseif math_abs(index - move_time*10)<1.5 then
			local player_x = player.model.m_x;
			local player_y = player.model.m_y + _y;
			local point2 = CCPoint(player_x,player_y)
			ZXGameScene:sharedScene():mapPosToGLPos(point2)
			local x,y = p:getPosition();
			local time = math_sqrt(math_pow(point2.x - x,2) + math_pow(point2.y - y,2))/speed;
			print("time = ",time,index,move_time);
			local move = CCEaseIn:actionWithAction(CCMoveTo:actionWithDuration(time,point2),1.0);
			p:runAction(move);

		elseif index > move_time*10 then
			local player_x = player.model.m_x;
			local player_y = player.model.m_y + _y;
			local point2 = CCPoint(player_x,player_y)
			ZXGameScene:sharedScene():mapPosToGLPos(point2)
			local x,y = p:getPosition();
			if math_abs(x - point2.x) < 20 and math_abs( y - point2.y ) < 20 then
				_timer:stop();
				_timer = nil;
				-- 停止动画
				p:removeFromParentAndCleanup(true);
			else
				if player_x ~= old_x or player_y ~= old_y then
					old_x = player_x;
					old_y = player_y;
					local time = math_sqrt(math_pow(point2.x - x,2) + math_pow(point2.y - y,2))/speed;
					p:stopAllActions();
					local move = CCEaseIn:actionWithAction(CCMoveTo:actionWithDuration(time,point2),1.0);
					p:runAction(move)
				end
			end
		end

		index = index + 1;
	end
	_timer:start(_speed,timer_fun);

end


function LuaEffectManager:angerEffect( entity_x,entity_y )
	print("LuaEffectManager:angerEffect( entity_x,entity_y )")
	local player = EntityManager:get_player_avatar();
	local p = CCParticleSystemQuad:particleWithFile('particle/test6.plist')
	local random_x = math_random(-100,100)
	local random_y = math_random(-100,100)
	local _y = -50;
	local old_x = player.model.m_x;
	local old_y = player.model.m_y + _y;
	-- print("old_x,old_y",old_x,old_y)
	local point = CCPoint(entity_x+random_x,entity_y+random_y)
	ZXGameScene:sharedScene():mapPosToGLPos(point)
	p:setPosition(point.x,point.y)
	p:setPositionType(1)
	SceneManager.SceneNode:addChild(p,100000);

	local _speed = 0.1;
	local _timer = timer();
	local is_first = true;
	local index = 1;
	local speed = 300;
	local function timer_fun()

		if is_first then
			is_first = false;
			local random_x = 0;
			local random_y = 0;
			if entity_x > old_x then
				random_x = math_random(-50,50)
			else
				random_x = math_random(-50,50)
			end
			if entity_y > old_y then
				random_y = math_random(-50,0)
			else
				random_y = math_random(0,50)
			end

			local player_x = player.model.m_x;
			local player_y = player.model.m_y + _y;
			local point2 = CCPoint(player_x,player_y);
			ZXGameScene:sharedScene():mapPosToGLPos(point2)
			local hlaf_x = (point2.x-point.x)/2
			local hlaf_y = (point2.y-point.y)/2

			local bezier1 = ccBezierConfig();
			bezier1.controlPoint_1 = CCPoint( point.x-hlaf_x,point.y + hlaf_y );
			bezier1.controlPoint_2 = CCPoint( point.x+hlaf_x,point.y + hlaf_y*3);
			bezier1.endPosition = point2;
			local bezierTo1 = CCBezierTo:actionWithDuration(0.8, bezier1 );
			p:runAction(bezierTo1);
		-- elseif index == 8 then
		-- 	local player_x = player.model.m_x;
		-- 	local player_y = player.model.m_y + _y;
		-- 	local point = CCPoint(player_x,player_y);
		-- 	ZXGameScene:sharedScene():mapPosToGLPos(point)
		-- 	local x,y = p:getPosition();
		-- 	local time = math_sqrt(math_pow(math_abs(point.x - x),2) + math_pow(math_abs(point.y - y),2))/speed;
		-- 	p:stopAllActions();
		-- 	print("time = ",time);

		-- 	p:runAction(CCMoveTo:actionWithDuration(time,point))
		elseif index > 8 then
			local player_x = player.model.m_x;
			local player_y = player.model.m_y + _y;
			local point2 = CCPoint(player_x,player_y)
			ZXGameScene:sharedScene():mapPosToGLPos(point2)
			local x,y = p:getPosition();
			print("x,y",x,y,point2.x,point2.y)
			if math_abs(x - point2.x) < 20 and math_abs( y - point2.y ) < 20 then
				_timer:stop();
				_timer = nil;
				-- 停止动画
				p:removeFromParentAndCleanup(true);
			else
				if player_x ~= old_x or player_y ~= old_y then
					old_x = player_x;
					old_y = player_y;
					local time = math_sqrt(math_pow(math_abs(point2.x - x),2) + math_pow(math_abs(point2.y - y),2))/speed;
					p:stopAllActions();
					print("time = ",time);
					p:runAction(CCMoveTo:actionWithDuration(time,point2))
				end
			end
		end

		index = index + 1;
	end
	_timer:start(_speed,timer_fun);
end

function LuaEffectManager:jump( _entity,x,y,height,_time )
	local action = CCJumpBy:actionWithDuration(_time,CCPoint(x,y),height,1)
	_entity.model:runAction(action)
end

--@params
-- root 根节点
-- sx,sy 来源的x,y
-- dx,dy 目标位置x,y
-- offsetX 曲线的offset，移动路径是从沿着Y轴的贝塞尔曲线，offsetX表示要绕X轴的距离
-- icon_path openSys的icon
function LuaEffectManager:openSysEffect(root,pos_x,pos_y,to_pos_x,to_pos_y, offsetX,icon_path, z)
	local textures =
	{
		'ui/opensys_effect/00004.png',
		'ui/opensys_effect/00005.png',
		'ui/opensys_effect/00006.png',
		'ui/opensys_effect/00007.png',
		'ui/opensys_effect/00008.png',
	}
	--------------------------------------------------------------
	root = root or self.UIRoot
	local rootNode = CCNode:node()
	-- local centerNode = CCSpriteBatchNode:batchNodeWithFile('ui/opensys_effect/ui_opensys_effect1.pd')
	-- local n = 32
	-- local slice = 2*math_pi/n
	-- local R = 36
	-- local rot_incr = 1/n*360
	-- local rot = 0
	-- local r2d = 180 / math_pi 
	-- degree = 90
	--------------------------------------------------------------
	--中心光圈动画特效，旋转
	-- local ct = CCSprite:spriteWithFile('ui/opensys_effect/00001.png')
	-- local cs0 = CCScaleTo:actionWithDuration(math_random(10,20)/10,1.25)
	-- local cs1 = CCScaleTo:actionWithDuration(math_random(10,20)/10,1.0)
	-- local array = CCArray:array();
	-- array:addObject(cs0);
	-- array:addObject(cs1);
	-- local seq = CCSequence:actionsWithArray(array);
	-- local rep = CCRepeatForever:actionWithAction(seq)
	-- ct:setOpacity(0)
	-- ct:runAction(CCFadeIn:actionWithDuration(0.5))
	-- ct:runAction(rep)
	-- ct:runAction(CCRotateBy:actionWithDuration(320, 7200))
	-- local array = CCArray:array();
	-- array:addObject(CCDelayTime:actionWithDuration(5.0))
	-- array:addObject(CCFadeOut:actionWithDuration(0.5))
	-- local seq = CCSequence:actionsWithArray(array);
	-- ct:runAction(seq)
	--光芒特效
	-- for i=0, n-1 do 
	-- 	local x = R*math_cos(slice*i)
	-- 	local y = R*math_sin(slice*i)
	-- 	local c0 = CCSprite:spriteWithFile(textures[math_random(1,5)])
	-- 	c0:setPosition(CCPointMake(x,y))
	-- 	c0:setAnchorPoint(CCPointMake(0.5,0))
	-- 	--local nx,ny = normalize(x,y)
	-- 	local d = math_dot(x,y,0,1)
	-- 	local r = math_acos(d)
	-- 	c0:setRotation(degree)
	-- 	centerNode:addChild(c0)
	-- 	degree = degree - rot_incr

	-- 	c0:setIsVisible(false)
	-- 	c0:setScale(0)

	-- 	-----------------------------------------------------------
	-- 	local array = CCArray:array();
	-- 	array:addObject(CCDelayTime:actionWithDuration(0.05*(n-i)))
	-- 	array:addObject(CCShow:action())
	-- 	array:addObject(CCScaleTo:actionWithDuration(0.05,1.1))
	-- 	array:addObject(CCScaleTo:actionWithDuration(0.1,0.8))
	-- 	array:addObject(CCScaleTo:actionWithDuration(0.1,1.1))
	-- 	array:addObject(CCScaleTo:actionWithDuration(0.1,1.0))
	-- 	local seq = CCSequence:actionsWithArray(array);
	-- 	c0:runAction(seq)
	-- 	c0:setOpacity(0)
	-- 	c0:runAction(CCFadeIn:actionWithDuration(0.5))

	-- 	-------------------------------------------------------------
	-- 	local array = CCArray:array();
	-- 	array:addObject(CCDelayTime:actionWithDuration(0.05*i + 2.5))
	-- 	array:addObject(CCFadeOut:actionWithDuration(0.5))
	-- 	local seq = CCSequence:actionsWithArray(array);
	-- 	c0:runAction(seq)

	-- 	-------------------------------------------------------------
	-- 	local array = CCArray:array();
	-- 	array:addObject(CCDelayTime:actionWithDuration(0.05*i + 1.5))
	-- 	array:addObject(CCScaleTo:actionWithDuration(1.0,3.0))
	-- 	local seq = CCSequence:actionsWithArray(array);
	-- 	c0:runAction(seq)
	-- end

	--中心旋转
	-- local cs0 = CCScaleTo:actionWithDuration(1.5,1.5)
	-- local cs1 = CCScaleTo:actionWithDuration(1.5,1.0)
	-- local array = CCArray:array();
	-- array:addObject(cs0);
	-- array:addObject(cs1);
	-- local seq = CCSequence:actionsWithArray(array);
	-- local rep = CCRepeatForever:actionWithAction(seq)
	-- centerNode:runAction(rep)
	-- centerNode:runAction(CCRotateBy:actionWithDuration(160, -7200))
	-- rootNode:addChild(centerNode)
	-- rootNode:addChild(ct)
	-- 创建闪烁特效
    LuaEffectManager:play_view_effect( 30002,21,12,rootNode,icon_path,-1 )
	root:addChild(rootNode,z)

	-- --移动到目标位置
	rootNode:setPosition(CCPointMake(pos_x,pos_y))

	-- local seg0 = 0.3
	-- local seg1 = 0.3
	-- local y1 = to_pos_y * seg0 + pos_y * (1.0 - seg0)
	-- local y2 = to_pos_y * seg1 + pos_y * (1.0 - seg1)

	-- local x1 = to_pos_x * seg0 + pos_x * (1.0 - seg0) - offsetX
	-- local x2 = to_pos_x * seg1 + pos_x * (1.0 - seg1) - offsetX

	-- local bezier1 = ccBezierConfig();
	-- bezier1.controlPoint_1 = CCPoint( x1,y1 );
	-- bezier1.controlPoint_2 = CCPoint( x2,y2 );
	-- bezier1.endPosition = CCPoint(to_pos_x,to_pos_y);
	-- local bezierTo1 = CCBezierTo:actionWithDuration(4, bezier1 );
	-- local array = CCArray:array();
	-- array:addObject(CCDelayTime:actionWithDuration(1))
	-- array:addObject(CCEaseBackInOut:actionWithAction(bezierTo1))
	-- array:addObject(CCRemove:action())
	-- local seq = CCSequence:actionsWithArray(array);
	-- rootNode:runAction(seq)
	local icon = CCSprite:spriteWithFile(icon_path)
	rootNode:addChild(icon)

	local function fly_and_fade()
		local array = CCArray:array()
		array:addObject(CCDelayTime:actionWithDuration(0.5))
		array:addObject(CCMoveTo:actionWithDuration(1,CCPoint(to_pos_x,to_pos_y)))
		array:addObject(CCFadeOut:actionWithDuration(0.5))
		local seq = CCSequence:actionsWithArray(array)
		rootNode:runAction(seq)

		local array = CCArray:array()
		array:addObject(CCDelayTime:actionWithDuration(1.5))
		array:addObject(CCFadeOut:actionWithDuration(0.5))
		local seq = CCSequence:actionsWithArray(array)
		icon:runAction(seq)

	end

	local cb = callback:new()
    cb:start(1,fly_and_fade)

    local function dismiss()
    	LuaEffectManager:stop_view_effect(30002, rootNode)
    end

	local cb2 = callback:new()
	cb2:start(2.5, dismiss)
    local effect = {}
    effect.rootNode = rootNode
    effect.icon = icon
    effect.fly_and_fade = fly_and_fade

    return effect	
end
--@params
-- root 根节点
-- sx,sy 来源的x,y
-- dx,dy 目标位置x,y
-- icon_path 技能的icon
function LuaEffectManager:play_jineng_effect(root ,sx, sy, dx, dy, icon_path, z,call_back)
	ZXLog("LuaEffectManager:play_jineng_effect(root, sx, sy, dx, dy, icon_path, z)")

	root = root or self.UIRoot
	local rootNode = CCNode:node()

		-- 创建闪烁特效
    LuaEffectManager:play_view_effect( 30002,21,12,rootNode,icon_path,-1 )
	root:addChild(rootNode,z)

	-- --移动到目标位置
	rootNode:setPosition(CCPointMake(sx,sy))

	-- time = 1 + 0.5 + 1 + 0.5 = 1 + 1.5 + 0.5 = 3
	-- time should > 2.5 and < 3.5
	local back = callback:new()
	back:start(3, call_back)
	
	-- if call_back then 
	-- 	call_back()
	-- end 
	local icon = CCSprite:spriteWithFile(icon_path)
	rootNode:addChild(icon)
	local function fly_and_fade()
		local array = CCArray:array()
		array:addObject(CCDelayTime:actionWithDuration(0.5))
		array:addObject(CCMoveTo:actionWithDuration(1,CCPoint(dx,dy)))
		array:addObject(CCFadeOut:actionWithDuration(0.5))
		local seq = CCSequence:actionsWithArray(array)
		rootNode:runAction(seq)

		local array = CCArray:array()
		array:addObject(CCDelayTime:actionWithDuration(1.5))
		array:addObject(CCFadeOut:actionWithDuration(0.5))
		local seq = CCSequence:actionsWithArray(array)
		icon:runAction(seq)

	end

	local cb = callback:new()
    cb:start(1,fly_and_fade)

    local function dismiss()
    	LuaEffectManager:stop_view_effect(30002, rootNode)
    end

	local cb2 = callback:new()
	cb2:start(2.5, dismiss)
    local effect = {}
    effect.rootNode = rootNode
    effect.icon = icon
    effect.fly_and_fade = fly_and_fade

    return effect, {back, cb, cb2}
end


-- create by chj @2015-3-11
-- 处理 书生和弓箭手的远程群攻技能，服务器会广播多个，客户端只需要一个
LuaEffectManager.skill_playing = {}
-- 把服务器广播的添加进表
function LuaEffectManager:add_playing_skill( player_handle, effect_id, effect_animation_table)
	if self.skill_playing[player_handle] == nil then
		self.skill_playing[player_handle] = {}
	end
	if self.skill_playing[player_handle][effect_id] == nil then
		self.skill_playing[player_handle][effect_id] = true
		-- 技能最短的cd是3.5s，设置2s的时间删除，考虑到网络延迟问题，没取帧动画播放的时间
		local cb_temp = callback:new()
		local function cb_remove_func()
			LuaEffectManager:remove_playing_skill( player_handle, effect_id)
		end 
		cb_temp:start( 2, cb_remove_func)
	end
end

-- 把广播完的技能从表中移除
function LuaEffectManager:remove_playing_skill( player_handle, effect_id)
	if self.skill_playing[player_handle] then
		if self.skill_playing[player_handle][effect_id] then
			self.skill_playing[player_handle][effect_id] = nil
		end

		-- 如果某个玩家的技能施放表删除
		local is_nil_table = true
		for k,v in pairs( self.skill_playing[player_handle]) do
			if v then
				is_nil_table = false
			end
		end
		if is_nil_table then
			self.skill_playing[player_handle] = nil
		end
	end
end

-- 判断是否有这个玩家播放的这个技能
function LuaEffectManager:is_playing_skill( player_handle, effect_id)
	if self.skill_playing[player_handle] == nil then
		return false
	else
		if self.skill_playing[player_handle][effect_id] == nil then
			return false
		else
			return true
		end
	end
end
