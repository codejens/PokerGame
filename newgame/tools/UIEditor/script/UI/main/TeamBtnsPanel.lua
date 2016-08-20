-- TeamBtnsPanel.lua
-- create by hcl on 2012-12-3
-- 队伍栏的按钮

require "UI/component/Window"
require "utils/MUtils"
super_class.TeamBtnsPanel(Window)

local _select_index = -1
-- x = 170, y = 245
function TeamBtnsPanel:__init()

    local function panel_fun( eventType,args,msgid )
        if ( eventType == TOUCH_BEGAN ) then
            self:select_btn( false )
            return false
        elseif (eventType == TOUCH_CLICK ) then
            
            return false
        elseif ( eventType == TOUCH_ENDED) then
            
            return false
        end
        
    end
    self.view:registerScriptHandler(panel_fun);
    --self.view:setDefaultMessageReturn(false);


    -- 退出队伍或解散队伍按钮
    -- local function btn_exit_team_fun(eventType,args,msgid)
    --     if ( eventType == TOUCH_BEGAN ) then
    --         return true;
    --     elseif ( eventType == TOUCH_CLICK ) then
    --         TeamModel:exit_team()
    --         return true;
    --     end
    --     return true
    -- end

    -- self.btn_exit_team = MUtils:create_btn(self.view,UILH_COMMON.lh_button2,UILH_COMMON.lh_button2_s,btn_exit_team_fun,222,426+40,-1,-1);
    -- MUtils:create_zxfont(self.btn_exit_team, Lang.team[17], 99/2, 20, 2, 18)   --[17] = "退伍"
    --self.btn_exit_team:setIsVisible(false);

    -- 背景框
    self.btn_bg = CCZXImage:imageWithFile( 265, 273, 110, 140, UILH_COMMON.bottom_bg,500,500);
    self.btn_bg:setIsVisible(false)
    self.view:addChild(self.btn_bg)

    -- 委任队长按钮
    local function btn_set_leader_fun(eventType,args,msgid)
        if ( eventType == TOUCH_BEGAN ) then
            return true;
        elseif ( eventType == TOUCH_CLICK ) then
            if ( _select_index ~= -1 ) then
                local team_member_table = TeamModel:get_team_table();
                local actorID = team_member_table[ _select_index ].actor_id;
                TeamCC:req_set_leader( actorID )
                self:select_btn( false )
            end
            return true;
        end
        return true
    end

    self.btn_set_leader = MUtils:create_btn(self.view,UILH_COMMON.lh_button2,UILH_COMMON.lh_button2_s,btn_set_leader_fun,270,349,-1,-1);
    MUtils:create_zxfont(self.btn_set_leader, Lang.team[18], 99/2, 20, 2, 18)   --[18] = "委任",
    self.btn_set_leader:setIsVisible(false);

    -- 踢出按钮
    local function btn_kick_fun(eventType,args,msgid)
        if ( eventType == TOUCH_BEGAN ) then
            return true;
        elseif ( eventType == TOUCH_CLICK ) then
            if ( _select_index ~= -1 ) then
                local team_member_table = TeamModel:get_team_table();
                local actorID = team_member_table[_select_index].actor_id;
                TeamCC:req_kick_player( actorID )
                self:select_btn( false )
            end
            return true;
        end
        return true
    end

    self.btn_kick = MUtils:create_btn(self.view,UILH_COMMON.lh_button2,UILH_COMMON.lh_button2_s,btn_kick_fun,270,283,-1,-1);
    MUtils:create_zxfont(self.btn_kick, Lang.team[19], 99/2, 20, 2, 18)   --[19] = "踢出",
    self.btn_kick:setIsVisible(false);
end

function TeamBtnsPanel:select_btn( is_visible )
	-- 弹出委任按钮和踢出按钮
    self.btn_bg:setIsVisible(is_visible)
    self.btn_set_leader:setIsVisible(is_visible);
    self.btn_kick:setIsVisible(is_visible);
end

function TeamBtnsPanel:set_select_index( select_index )
    _select_index = select_index;
end