-- DouFaTaiHistory.lua
-- created by guozhinan on 2015/4/30
-- 显示斗法台弹出的挑战历史窗口

super_class.DouFaTaiHistory(Window)


function DouFaTaiHistory:show(data)
    -- 阻止连续打开行为
    local win = UIManager:find_visible_window("doufatai_history")
    if win then
        return;
    end

    local win = UIManager:show_window("doufatai_history",true);
    if win then
        win:update(data)
    end
end

-- 
function DouFaTaiHistory:__init( window_name, texture_name, is_grid, width, height,title_text )
    local panel = self.view;

    ZImage:create( self.view, UILH_COMMON.dialog_bg, 0, 0, width, height, -1,500,500 )
    
    local bg = CCBasePanel:panelWithFile(12, 60, width-24, 255,UILH_COMMON.bottom_bg,500,500);
    self.view:addChild(bg)

    self.history_scroll = CCScroll:scrollWithFile(0,17,485,220,0,nil,TYPE_HORIZONTAL,500,500);
        
    --设滚动条
    self.history_scroll:setScrollLump(UILH_COMMON.up_progress, UILH_COMMON.down_progress, 11, 30, 220 )
    self.history_scroll:setScrollLumpPos( 494 )
    local arrow_up = CCZXImage:imageWithFile(494 , 237, 11, -1 , UILH_COMMON.scrollbar_up, 500, 500)
    local arrow_down = CCZXImage:imageWithFile(494, 6, 11, -1, UILH_COMMON.scrollbar_down, 500 , 500)
    bg:addChild(arrow_up,1)
    bg:addChild(arrow_down,1)
    bg:addChild(self.history_scroll);

    self.history_text_btn = {}
    local function scrollfun(eventType, args, msg_id)
        if eventType == nil or args == nil or msg_id == nil then 
            return
        end
        if eventType == TOUCH_BEGAN then
            return true
        elseif eventType == TOUCH_MOVED then
            return true
        elseif eventType == TOUCH_ENDED then
            return true
        elseif eventType == SCROLL_CREATE_ITEM then
            local temparg = Utils:Split(args,":")
            local row = temparg[1] +1             -- 行
            -- print("row",row)
            -- 每行的背景panel
            local panel = CCBasePanel:panelWithFile(0,10,485,45,nil,0,0);
            -- 分割线
            MUtils:create_zximg(panel,UILH_COMMON.split_line,10,12,475,3,0,0)
            self.history_scroll:addItem(panel);

            local function func( eventType ,args,msg_id)
                if ( eventType == TOUCH_CLICK ) then
                    self.tab_zj = DFTModel:get_dft_ZJ_info();
                    local zj_struct = self.tab_zj[row];
                    if zj_struct then
                        local tempdata = { roleId = zj_struct.enemy_id, roleName = zj_struct.enemy_name, qqvip = zj_struct.qqVip ,level = zj_struct.enemy_lv, camp = zj_struct.enemy_clan, job = zj_struct.enemy_job, sex = zj_struct.enemy_sex }
                        LeftClickMenuMgr:show_left_menu("chat_other_list_menu", tempdata)
                    end
                end
                return true
            end
            self.history_text_btn[row] = MUtils:create_text_btn(panel,"",20,28,485,20,func)
            self.history_text_btn[row]:setText( self.tab_zj[row].str );

            -- 分割线
            -- MUtils:create_zximg(panel,UILH_COMMON.split_line,-10,0,550,3,0,0)

            self.history_scroll:refresh();
            return false
        elseif eventType == ITEM_DELETE then           
            local temparg = Utils:Split(args,":")
            local row = temparg[1] +1             -- 行
            self.history_text_btn[row] = nil
        end
    end
    self.history_scroll:registerScriptHandler(scrollfun);
    self.history_scroll:refresh();  

    local function btn_cancel_fun(eventType,x,y)
        if eventType == TOUCH_CLICK then
           UIManager:destroy_window("doufatai_history");
        end
        return true
    end
    self.btn2 = MUtils:create_btn(panel,UILH_COMMON.lh_button2, UILH_COMMON.lh_button2_s,btn_cancel_fun,(width-99)/2,6,-1,-1)
    MUtils:create_zxfont(self.btn2, Lang.common.confirm[0], 99/2, 20, 2, 18)   --[0]=确定

    --关闭按钮
    -- local function _close_btn_fun()
    --     UIManager:destroy_window(window_name)
    -- end

    -- local _exit_btn_info = { img = UILH_COMMON.close_btn_z, z = 1000, width = 60, height = 60 }
    -- self._exit_btn = ZButton:create(self.view, _exit_btn_info.img, _close_btn_fun,0,0,_exit_btn_info.width,_exit_btn_info.height,_exit_btn_info.z);
    -- local exit_btn_size = self._exit_btn:getSize()
    -- self._exit_btn:setPosition( width - exit_btn_size.width+11 , height - exit_btn_size.height)
end

function DouFaTaiHistory:update(data)
    if ( data ~= nil ) then
        self.tab_zj = data;
        local len = #self.tab_zj;
        len = math.min(len,10);

        self.history_scroll:clear();
        self.history_scroll:setMaxNum(len);
        self.history_scroll:refresh();  
    end
end

function DouFaTaiHistory:active( show )

end

function DouFaTaiHistory:destroy(  )
    Window.destroy(self)
end