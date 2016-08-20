-- TeamMemberView.lua
-- created by hcl on 2013/2/25
-- 队伍面板的item项

require "utils/MUtils"
super_class.TeamMemberView()

local COLOR_GRAY = ccc3(70,70,70);
local COLOR_RIGHT = ccc3(255,255,255);

function TeamMemberView:__init(x,y,lv,name,hp,max_hp,mp,max_mp,sex,job,index,actor_id,handle)
    -- print("创建TeamMemberView index = ",index,"name = ",name,"actor_id",actor_id,hp,max_hp,mp,max_mp);
  	local panel = CCBasePanel:panelWithFile(0,y,250,80,"",500,500);
    self.index = index;

    -- 这个类被重用了，一种情况是普通的队友item，另一种情况是纯粹作为一个退伍按钮
    self.is_team_item = true
    if lv == nil then
        self.is_team_item = false
    end
    if self.is_team_item then

        self.actor_id = actor_id;
        -- 选中效果图
        -- self.select_spr = MUtils:create_zximg(panel,UIResourcePath.FileLocate.main .. "m_team_select.png", 0, 0, -1, 78);
        -- self.select_spr:setIsVisible(false);

        local spr_bg = MUtils:create_zximg(panel,UILH_MAIN.m_team_bg,20,10, -1, -1);

        -- 头像
        local head_path = UIResourcePath.FileLocate.lh_normal .. "head/head"..job..sex..".png";  
        local head = MUtils:create_sprite(spr_bg, head_path, 7, 7);
        head:setScale(50/68)
        head:setAnchorPoint(CCPointMake(0, 0))
        -- local size = head:getContentSize();
        -- head:setScaleX(64/size.width);
        -- head:setScaleY(64/size.height);
        --等级
        local spr_lv_bg = MUtils:create_zximg(spr_bg,UILH_MAIN.m_other_lv,-4,37,-1,-1);
        self.lv = ZLabel:create(spr_lv_bg,tostring(lv),15,13,10,2);
        -- 队长标志
        self.leader_spr = MUtils:create_zximg(spr_bg,UILH_MAIN.duizhang, 180, 48, -1,-1)
        local team_leader_actorID = TeamModel:get_leader_actor_id();
        self:set_leader_spr( team_leader_actorID );
        -- 名字
        self.name = MUtils:create_zxfont(spr_bg,LH_COLOR[2]..name,73,50,1,16);

        -- 血条
        -- self.hp = CCZXImage:imageWithFile(60,31,46,6,UIResourcePath.FileLocate.main .. "m_hp.png",8,5,8,5,8,5,8,5); 
        -- self.hp:setAnchorPoint(0.0,0.5);
        -- spr_bg:addChild( self.hp );
        self.hp = HPBar( spr_bg,"nopack/main/m_team_red.png","nopack/main/m_team_red.png",61,31,130,13,nil,1);
        self.old_hp = hp;
        self.hp:set_hp( hp,max_hp );
        -- 蓝条
        self.mp = MUtils:create_zximg(spr_bg,UILH_MAIN.m_team_blue,59,17, -1, -1);
        -- self.mp.view:setAnchorPoint(CCPoint(0,0));

        local function panel_fun(eventType,arg,msgid)
            if eventType == nil or arg == nil or msgid == nil  then
                return false
            end
            if eventType == TOUCH_BEGAN then
                --return true;
            --elseif  eventType == TOUCH_CLICK then
               -- 选中状态
               print("选中self.index  = ",self.index ,self.actor_id,name);
               self:set_select(true);
               local win = UIManager:find_window("user_panel");
               if ( win ) then
                   win.miniTaskPanel:select_item( self.index );
               end
               --return true;
            elseif eventType == ITEM_DELETE then
                print("MiniTaskPanel:on_team_item_delete index = ",self.index);
                local win = MiniTaskPanel:get_miniTaskPanel() 
                if win then 
                    win:on_team_item_delete( self.index )
                end
            end
            return true
        end
        --panel:setMessageCut(true)
        panel:registerScriptHandler(panel_fun)
        --print("script headler=",panel:getScriptHandler())

        -- self:update_mp( mp,max_mp )

        if handle == 0 then
            self.zl_spr = ZCCSprite:create(spr_bg,UILH_MAIN.zanli,33,13)
            head:setColor(COLOR_GRAY);
        end

        self.head = head;
        self.spr_bg = spr_bg;
    else
        local function panel_fun(eventType,arg,msgid)
            if eventType == nil or arg == nil or msgid == nil  then
                return false
            end
            if eventType == TOUCH_BEGAN then

            elseif eventType == ITEM_DELETE then
                print("MiniTaskPanel:on_team_item_delete index = ",self.index);
                local win = MiniTaskPanel:get_miniTaskPanel() 
                if win then
                    win:on_team_item_delete( self.index )
                end
            end
            return true
        end
        panel:registerScriptHandler(panel_fun)

        -- 退出队伍或解散队伍按钮
        local function btn_exit_team_fun(eventType,args,msgid)
            if ( eventType == TOUCH_BEGAN ) then
                return true;
            elseif ( eventType == TOUCH_CLICK ) then
                TeamModel:exit_team()
                return true;
            end
            return true
        end

        self.btn_exit_team = MUtils:create_btn(panel,UILH_COMMON.lh_button2,UILH_COMMON.lh_button2_s,btn_exit_team_fun,76,26,-1,-1);
        MUtils:create_zxfont(self.btn_exit_team, Lang.team[17], 99/2, 20, 2, 18)   --[17] = "退伍"
    end
    self.view = panel;
    return self;
end
-- 更新血
function TeamMemberView:update_hp( hp,max_hp )
    if self.is_team_item then
        local change_hp = hp - self.old_hp;
        print("队伍view更新血量................................",hp,max_hp);
        self.hp:update_hp( change_hp,hp,max_hp )
        self.old_hp = hp;
    end
end
-- 更新蓝
function TeamMemberView:update_mp( mp,max_mp )
    -- print("队伍view更新血量................................",mp,max_mp);
    -- local rate = math.max( mp/max_mp ,0)
    -- rate = math.min(rate,1);
    -- self.mp.view:setScaleX( rate );
end
-- 选中状态图片显示隐藏
function TeamMemberView:set_select( is_select ) 
    -- self.select_spr:setIsVisible(is_select);
end

function TeamMemberView:update_lv( lv )
    if self.is_team_item then
        self.lv:setText(tostring(lv));
    end
end

-- 设置队长标志
function TeamMemberView:set_leader_spr( leader_actor_id )
   -- print("self.actor_id = ",self.actor_id,leader_actor_id);
   if self.is_team_item then
        if ( self.actor_id == leader_actor_id ) then
            self.leader_spr:setIsVisible(true);
        else
            self.leader_spr:setIsVisible(false);
        end
    end
end
-- 更新队员的状态
function TeamMemberView:update_state( state )
    if self.is_team_item then
        if state == TeamModel.STATE_ONLINE then
            if self.zl_spr then
                self.zl_spr.view:removeFromParentAndCleanup(true);
                self.zl_spr = nil;
            end
            self.head:setColor(COLOR_RIGHT)
        elseif state == TeamModel.STATE_OFFLINE then
            self.head:setColor(COLOR_GRAY)
            self.zl_spr = ZCCSprite:create(self.spr_bg,UILH_MAIN.zanli,33,13)
        elseif state == TeamModel.STATE_OUTOFRANGE then
            if self.zl_spr then
                self.zl_spr.view:removeFromParentAndCleanup(true);
                self.zl_spr = nil;
            end
            self.head:setColor(COLOR_GRAY)
        end
    end
end