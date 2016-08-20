-- DaZuoWin.lua
-- create by hcl on 2013-2-17
-- 主角普通打坐时显示双修按钮，并且点击屏幕任务一个地方取消打坐，
-- 当主角与别人双修时，点击屏幕任何地方会弹二次确认框，提示是否取消打坐

-- require "UI/component/Window"
super_class.DaZuoWin(Window)

function DaZuoWin:show( world_pos_x,world_pos_y )
	local win = UIManager:show_window("dazuo_win");
	if ( win ) then

        -- 调整人的位置
        --world_pos_y = world_pos_y + 48

        local pos_x,pos_y = SceneManager:world_pos_to_view_pos( world_pos_x, world_pos_y )
        
		-- win.view:setPosition(pos_x-28,pos_y-35);
        pos_x = pos_x / GameScaleFactors.viewPort_ui_x - 28
        pos_y = pos_y / GameScaleFactors.viewPort_ui_y - 35
        -- print("打坐双修按钮坐标,pos_x,pos_y",pos_x,pos_y, world_pos_x, world_pos_y)
        win:setPosition(pos_x,pos_y);
		win:change_state( 1 );
	end
end

-- state 1 = 普通打坐 2 = 双修,0 = 取消
function DaZuoWin:change_state( state )
	if ( state == 0  ) then
		UIManager:hide_window("dazuo_win");
	elseif ( state == 1 ) then
        --print("change_state 1")
		--self.sx_btn:setIsVisible(true);
		--xiehande  暂时屏蔽
self.sx_btn:setIsVisible(false);
	elseif ( state == 2 ) then
		self.sx_btn:setIsVisible(false);
	end
	self.state = state;
end

function DaZuoWin:__init( window_name, texture_name)
 --    self.view:setDefaultMessageReturn(false)
	-- local function panel_fun(eventType,arg,msg_id)
 --        if  eventType == TOUCH_BEGAN then 
 --            return true;
 --        elseif eventType == TOUCH_CLICK then
 --           -- print("panel_fun TOUCH_CLICK")
        
 --            return true;
 --        end
 --    end
 --    self.view:registerScriptHandler(panel_fun);

	local function sx_fun(eventType,arg,msg_id)
        if  eventType == TOUCH_BEGAN then 
            return true;
        elseif  eventType == TOUCH_CLICK then
           -- print("sx_fun TOUCH_CLICK")
        	XunRenShuangXiuWin:show(  );
            return true;
        end
        return true
    end
    self.sx_btn = MUtils:create_btn(self.view,UILH_NORMAL.sx_btn,UILH_NORMAL.sx_btn,
    	sx_fun,0,0,55,30);
    self.sx_btn:setIsVisible(false);
end
-- 停止打坐
function DaZuoWin:stop_dazuo()
    UIManager:hide_window("dazuo_win");
    ShuangXiuCC:req_start_normal_dazuo( 0, 0 )
   -- print("通知服务器停止打坐...............")
end

-- 当点击外面的时候的事件
function DaZuoWin:scene_on_click()
    local win = UIManager:find_visible_window("dazuo_win");
    if ( win ) then
        local player = EntityManager:get_player_avatar();
        if ( win.state == 1 ) then
            -- 停止打坐
            player:stop_dazuo()
        elseif ( win.state == 2 ) then
            local function fun()
                -- 停止打坐
                player:stop_dazuo()
            end
            NormalDialog:show(LangGameString[1899],fun); -- [1899]="确定要取消双修吗?"
            print("player.state ===================",player.state);
            return false;
        end 
    end
    return true;
end
