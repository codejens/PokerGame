-- TeamFilterDialog.lua
-- created by guozhinan on 2015/4/24
-- 设置组队系统显示的队伍类型的对话框

super_class.TeamFilterDialog(Window)

local _cb_fun = nil;

function TeamFilterDialog:show(cb_fun)
    -- 阻止连续打开行为
    local win = UIManager:find_visible_window("team_filter_dialog")
    if win then
        return;
    end

    local win = UIManager:show_window("team_filter_dialog",true);
    if win then
        _cb_fun = cb_fun;
    end
end

-- 
function TeamFilterDialog:__init( window_name, texture_name, is_grid, width, height,title_text )
    local panel = self.view;

    ZImage:create( self.view, UILH_COMMON.dialog_bg, 0, 0, width, height, -1,500,500 )
    
    local bg = CCZXImage:imageWithFile( 12, 79, width-24, 205, UILH_COMMON.bottom_bg,500,500);
    self.view:addChild(bg)

    local subtitle_bg = ZImage:create(self.view, UILH_NORMAL.title_bg5, 3, height-39, width-6, 36, 0, 500, 500)   
    self.title_label = MUtils:create_zxfont(subtitle_bg,Lang.team[26],(width-6)/2,10,2,16); -- [26] = "队伍筛选",

    MUtils:create_zxfont(panel,Lang.team[27],19,255,1,16);  -- [27] = "目标副本",


    self.selected_state_table = TeamActivityMode:get_team_display_state_table()
    self.switch_but_table = {}
    self.switch_but_title = {Lang.team[20],Lang.team[21],Lang.team[22],Lang.team[23],Lang.team[24]}
    local begin_x = 40;
    local top_y = 250;
    local x_interval = 200
    local y_interval = 50

    for i=1,5 do
        local row = math.ceil(i/2);
        local col = (i+1)%2

        local function switch_button_func( is_selected )
            self.selected_state_table[i] = is_selected;
        end
        -- 用create_switch_button2，便于设置文本的y值
        local switch_but = UIButton:create_switch_button2( begin_x + col*x_interval, top_y - row*y_interval, 160, 33, UILH_COMMON.dg_sel_1, UILH_COMMON.dg_sel_2, self.switch_but_title[i], 40, 13, 15, nil, nil, nil, nil, switch_button_func )
        self.switch_but_table[i] = switch_but
        self.switch_but_table[i].set_state(self.selected_state_table[i])
        self.view:addChild(switch_but.view)
    end

    local function btn_ok_fun(eventType,x,y)
        if eventType == TOUCH_CLICK then
            local has_choice = false
            for i=1,5 do
                if self.selected_state_table[i] == true then
                    has_choice = true;
                    break;
                end
            end
            if has_choice == true then
                if ( _cb_fun ) then
                     _cb_fun(self.selected_state_table);
                end
                UIManager:destroy_window("team_filter_dialog");
            else
                GlobalFunc:create_screen_notic(Lang.team[30]); --"至少勾选一种类型！"
            end
        end
        return true
    end

    self.btn1 = MUtils:create_btn(panel,UILH_COMMON.lh_button2, UILH_COMMON.lh_button2_s,btn_ok_fun,60,18,-1,-1)
    MUtils:create_zxfont(self.btn1, Lang.common.confirm[0], 99/2, 20, 2, 18)   --[0]=确定

    local function btn_cancel_fun(eventType,x,y)
        if eventType == TOUCH_CLICK then
           UIManager:destroy_window("team_filter_dialog");
        end
        return true
    end
    self.btn2 = MUtils:create_btn(panel,UILH_COMMON.lh_button2, UILH_COMMON.lh_button2_s,btn_cancel_fun,239,18,-1,-1)
    MUtils:create_zxfont(self.btn2, Lang.common.confirm[9], 99/2, 20, 2, 18)   --[9]=取消

    --关闭按钮
    -- local function _close_btn_fun()
    --     UIManager:destroy_window(window_name)
    -- end

    -- local _exit_btn_info = { img = UILH_COMMON.close_btn_z, z = 1000, width = 60, height = 60 }
    -- self._exit_btn = ZButton:create(self.view, _exit_btn_info.img, _close_btn_fun,0,0,_exit_btn_info.width,_exit_btn_info.height,_exit_btn_info.z);
    -- local exit_btn_size = self._exit_btn:getSize()
    -- self._exit_btn:setPosition( width - exit_btn_size.width+11 , height - exit_btn_size.height)
end

function TeamFilterDialog:active( show )

end

function TeamFilterDialog:destroy(  )
    _cb_fun = nil;
    Window.destroy(self)
end