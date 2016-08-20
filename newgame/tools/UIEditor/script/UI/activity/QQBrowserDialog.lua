-- QQBrowserDialog.lua 
-- created by liuguowang on 2014-2-25
-- QQ浏览器活动窗口
 

local _btn_state    --按钮状态变量

local get_award_text  --领取奖励 字体
local had_award_text  --已领取   字体

 local _QQ_BTN_CANNOT_GET = 0    --不可领取
 local _QQ_BTN_CAN_GET = 1  --可领取
 local _QQ_BTN_HAD_GET = 2    --已领取

local points = {{x=154,y=252},{x=185,y=258},{x=274,y=273},{x=304,y=277}}

super_class.QQBrowserDialog(Window)
require "../data/activity_config/qq_browser_conf"
local _qq_browser_install_link = "http://mdc.html5.qq.com/d/directdown.jsp?channel_id=33337"




function QQBrowserDialog:__init(window_name, window_info)
    _btn_state = _QQ_BTN_CANNOT_GET 

    ZImage:create( self.view, UIResourcePath.FileLocate.QQactive .. "QQbrowserBk.png", 0, 0, -1, -1)
    ----------------------------------------------------------------
    local function install_fun( )--一键安装按钮
        phoneGotoURL(_qq_browser_install_link)
        OnlineAwardCC:req_get_award_state(1)  --申请按钮状态
    end 

    ZButton:create( self.view, UIResourcePath.FileLocate.QQactive .. "install.png", install_fun, 198, 150, -1, -1)    ----------------------------------------------------------------
    ----------------------------------------------------------------
    local function get_btn_fun( )--领取按钮
        if ItemModel:check_bag_if_full() then
            GlobalFunc:create_screen_notic( LangModelString[11] ) -- [11]="背包已满,不能领取奖励"
            return
        end
        if _btn_state == _QQ_BTN_CAN_GET then
            OnlineAwardCC:req_get_award()  --服务器下发有 update
        end
    end

    self.get_btn = UIButton:create_button_with_name( 137, 15,-1,-1,  UIResourcePath.FileLocate.common .. "button_red.png",  UIResourcePath.FileLocate.common .. "button_red.png", nil, nil, get_btn_fun )
    self.view:addChild( self.get_btn );
    self.get_btn:setCurState( CLICK_STATE_DISABLE ) -- 默认不可点击
    --  "领取奖励"  文字
    get_award_text = CCZXImage:imageWithFile( 12, 10,-1, -1, UIResourcePath.FileLocate.normal .. "get_award.png");
    self.get_btn:addChild( get_award_text );
    --  "已领取"  文字
    had_award_text = CCZXImage:imageWithFile( 26, 10,-1, -1, UIResourcePath.FileLocate.normal .. "text_4.png" );
    self.get_btn:addChild( had_award_text );
    had_award_text:setIsVisible( false )    -- 默认按钮上是显示  领取奖励 文字


    -- self.get_btn = ZButton:create( self.view, UIResourcePath.FileLocate.common .. "button4.png",get_btn_fun,window_info.width / 2, 15,115,35)
    -- self.get_btn:setAnchorPoint( 0.5, 0 )
    -- self.btn_text = ZImage:create( self.view,UIResourcePath.FileLocate.normal .. "get_award.png",115/2,5)
    -- self.btn_text.view:setAnchorPoint(0.5,0)
    -- self.get_btn.view:addChild(self.btn_text.view)
    ----------------------------------------------------------------  
    local offerFrame = 20  
    local one_width = (window_info.width-offerFrame*2)/#_qq_browser_get_slot_id
    self.slot_item = {}
    for i=1,#_qq_browser_get_slot_id do  --领取的图标id
        self.slot_item[i] = MUtils:create_slot_item(self.view,UIPIC_ITEMSLOT,offerFrame+one_width/2 - 60 /2 + (i-1) *one_width,70,60,60,_qq_browser_get_slot_id[i].id);
        self.slot_item[i]:set_item_count(_qq_browser_get_slot_id[i].num)
        self.slot_item[i]:play_activity_effect();        
    end
    ----------------------------------------------------------------

    local startTime ,end_time = SmallOperationModel:get_start_end_time(ServerActivityConfig.ACT_TYPE_QQBROWSER)
    print("startTime= ",startTime)
    local start_month,start_day = Utils:second_to_month_day( startTime )
    local end_month,end_day = Utils:second_to_month_day( end_time )
    ZLabel:create(self.view,start_month,points[1].x,points[1].y)
    ZLabel:create(self.view,start_day,points[2].x,points[2].y)
    ZLabel:create(self.view,end_month,points[3].x,points[3].y)
    ZLabel:create(self.view,end_day,points[4].x,points[4].y)
    print("start_time_str=",start_time_str)
    print("end_time_str=",end_time_str)
end

function QQBrowserDialog:active(active)
    if active == true then
        OnlineAwardCC:req_get_award_state(0)  --申请按钮状态
        -- self:update()
    end
end


function QQBrowserDialog:update(state)
    print("state=",state)
    if state ~= nil then
        _btn_state = state
    end
    print("update _btn_state = ",_btn_state)
    if _btn_state == _QQ_BTN_CAN_GET then  --可领取
        self.get_btn:setCurState( CLICK_STATE_UP)
        get_award_text:setIsVisible(true)
        had_award_text:setIsVisible(false)
    elseif _btn_state ~= nil then
        self.get_btn:setCurState( CLICK_STATE_DISABLE)
        print("2 state=",state)

        if _btn_state == _QQ_BTN_HAD_GET then  -- 已领取
        print("3 state=",state)
            get_award_text:setIsVisible(false)
            had_award_text:setIsVisible(true)
        elseif _btn_state == _QQ_BTN_CANNOT_GET then -- 不能领取
            get_award_text:setIsVisible(true)
            had_award_text:setIsVisible(false)
        end
    end

    for i=1,#_qq_browser_get_slot_id do  --领取的图标id 
        if self.slot_item[i] then
            self.slot_item[i]:play_activity_effect();        
        end
    end
end
