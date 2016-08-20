-- XDHTongjiActionPanel.lua
-- create by guozhinan on 2015-3-7
-- 仙道會点击统计面板后弹出的下注、扔鸡蛋等行为的操作面板
-- (页面抄袭TeamBtnsPanel，但是TeamBtnsPanel那种不释放页面，仅是让点击事件穿透的做法应该是不好的，所以这里改了)

super_class.XDHTongjiActionPanel(Window)

function XDHTongjiActionPanel:__init()

    local function panel_fun( eventType,args,msgid )
        if ( eventType == TOUCH_BEGAN ) then
            UIManager:hide_window( "xdh_tongji_action_panel" )
            return false
        elseif (eventType == TOUCH_CLICK ) then
            
            return false
        elseif ( eventType == TOUCH_ENDED) then
            
            return false
        end
        
    end
    self.view:registerScriptHandler(panel_fun);
    --self.view:setDefaultMessageReturn(false);

    -- 背景框
    self.btn_bg = CCZXImage:imageWithFile( 265, 273, 110, 140, UILH_COMMON.bottom_bg,500,500);
    self.view:addChild(self.btn_bg)

    -- 送花按钮
    local function btn_xiazhu_fun(eventType,args,msgid)
        if ( eventType == TOUCH_BEGAN ) then
            return true;
        elseif ( eventType == TOUCH_CLICK ) then
            if self.select_name == nil then
                GlobalFunc:create_screen_notic(Lang.xiandaohui.play_win[1])--"只能对十六强玩家使用"
                return;
            end
            if self.flower_cd == true then
                GlobalFunc:create_screen_notic(Lang.xiandaohui.play_win[2])--"送飞吻冷却时间未结束"
                return;
            end
            if (self.select_name) then
                XianDaoHuiCC:req_flower( 0,self.select_name )
                UIManager:hide_window( "xdh_tongji_action_panel" )
            end
            return true;
        end
        return true
    end

    --送花按钮
    self.btn_xiazhu = MUtils:create_btn(self.view,UILH_XIANDAOHUI.zbs_action1,UILH_XIANDAOHUI.zbs_action1,btn_xiazhu_fun,270,349,-1,-1);
    -- MUtils:create_zxfont(self.btn_xiazhu, Lang.team[18], 99/2, 20, 2, 18)   --[18] = "委任",

    -- 扔鸡蛋按钮
    local function btn_kiss_fun(eventType,args,msgid)
        if ( eventType == TOUCH_BEGAN ) then
            return true;
        elseif ( eventType == TOUCH_CLICK ) then
            if self.select_name == nil then
                GlobalFunc:create_screen_notic(Lang.xiandaohui.play_win[1])--"只能对十六强玩家使用"
                return;
            end
            if self.egg_cd == true then
                GlobalFunc:create_screen_notic(Lang.xiandaohui.play_win[3])--"扔鸡蛋冷却时间未结束"
                return;
            end
            if (self.select_name) then
                XianDaoHuiCC:req_flower( 1,self.select_name )
                UIManager:hide_window( "xdh_tongji_action_panel" )
            end
            return true;
        end
        return true
    end

    self.btn_kiss = MUtils:create_btn(self.view,UILH_XIANDAOHUI.zbs_action2,UILH_XIANDAOHUI.zbs_action2,btn_kiss_fun,270,283,-1,-1);
    -- MUtils:create_zxfont(self.btn_kiss, Lang.team[19], 99/2, 20, 2, 18)   --[19] = "踢出",

    self.select_name = nil;
end

function XDHTongjiActionPanel:set_select_name( select_name )
    self.select_name = select_name;
end

function XDHTongjiActionPanel:destroy( )
    Window.destroy(self)
end