--领奖页面  整合在线领奖和七日狂欢页面
--created by xiehande on 2015.1.15
--AwardWin

super_class.AwardWin(NormalStyleWindow)


require "UI/guild/GuildCommon"
require "config/ComAttribute"


--窗体大小
local window_width = 900
local window_height = 605

-- 时候显示登陆送元宝分页
local is_show_login_page = true

-- 创建一个按钮:参数： 要加入的panel， 坐标和长宽，按钮两种状态背景图，显示文字图片，文字图片的长宽，序列号（用于触发事件判断调用的方法）
function AwardWin:create_a_button(panel, pos_x, pos_y, size_w, size_h, image_n, image_s ,but_name, but_name_s,but_name_siz_w, but_name_siz_h, but_index)

    local radio_button = CCRadioButton:radioButtonWithFile(pos_x, pos_y, size_w, size_h, image_n)
    radio_button:addTexWithFile(CLICK_STATE_DOWN,image_s)
    local function but_1_fun(eventType,x,y)
        if eventType == TOUCH_CLICK then 
            Instruction:handleUIComponentClick(instruct_comps.AWARD_WIN_TAB_BASE + but_index)
            self:change_page( but_index )
            return true;
        elseif eventType == TOUCH_BEGAN then
            
            return true;
        elseif eventType == TOUCH_ENDED then
            return true;
        end
    end
    radio_button:registerScriptHandler(but_1_fun)    --注册
    panel:addGroup(radio_button)

    --按钮显示的名称
    --self.btn_name_t[but_index] = AwardWin:create_btn_name(but_name,but_name_s,size_w/2,size_h/2,but_name_siz_w,but_name_siz_h)

    self.btn_name_t[but_index] = ZLabel:create( nil, but_name, 0, 0, 14)
    local btn_size = radio_button:getSize()
    local lab_size = self.btn_name_t[but_index]:getSize()
    self.btn_name_t[but_index]:setPosition( ( btn_size.width - lab_size.width ) / 2, ( btn_size.height - lab_size.height ) / 2 )

    radio_button:addChild( self.btn_name_t[but_index].view )
    self.btn_radio_t[but_index] = radio_button
    return radio_button
end


--xiehande  
-- function  AwardWin:create_btn_name( btn_name_n,btn_name_s,name_x,name_y,btn_name_size_w,btn_name_size_h )
--     -- 按钮名称贴图集合
--     local  button_name = {}
--     local  button_name_image = CCZXImage:imageWithFile(name_x,name_y,btn_name_size_w,btn_name_size_h,btn_name_n)
--     button_name_image:setAnchorPoint(0.5,0.5)
--     button_name.view = button_name_image
--     --按钮被选中，调用函数切换贴图至btn_name_s
--     button_name.change_to_selected = function ( )
--         button_name_image:setTexture(btn_name_s)
--     end

--     --按钮变为未选时  切换贴图到btn_name_n
--     button_name.change_to_no_selected = function ( )
--         button_name_image:setTexture(btn_name_n)
--     end

--     return button_name

-- end

--切换功能窗口:   
function AwardWin:change_page( but_index )
    --    for k,v in pairs(self.btn_name_t) do
    --    v.change_to_no_selected()
    -- end
    -- self.btn_name_t[but_index].change_to_selected()
    -- 把当前显示的页隐藏
    if self.current_panel then
        self.current_panel.view:setIsVisible(false)
    end
    
    local curr_page_width = 860
    local curr_page_height = 410
   
    if but_index == AWARD_ONLINE_TAG then   -- 在线奖励
        if self.all_page_t[AWARD_ONLINE_TAG] == nil then
            self.all_page_t[AWARD_ONLINE_TAG] =  onlineAwardPage()
            curr_page_width =  self.all_page_t[AWARD_ONLINE_TAG].view:getSize().width
            self.all_page_t[AWARD_ONLINE_TAG].view:setPosition(window_width/2-curr_page_width/2, 13)
            self.view:addChild( self.all_page_t[AWARD_ONLINE_TAG].view )
        end
        self.current_panel = self.all_page_t[AWARD_ONLINE_TAG]
    elseif  but_index == AWARD_SEVEN_TAG then  -- 7天奖励
        if self.all_page_t[AWARD_SEVEN_TAG] == nil then
            self.all_page_t[AWARD_SEVEN_TAG] =  sevenDayAwardNew()
            curr_page_width =  self.all_page_t[AWARD_SEVEN_TAG].view:getSize().width
            self.all_page_t[AWARD_SEVEN_TAG].view:setPosition(window_width/2-curr_page_width/2, 13)
            self.view:addChild( self.all_page_t[AWARD_SEVEN_TAG].view )
        end
        self.current_panel = self.all_page_t[AWARD_SEVEN_TAG]
    elseif  but_index == AWARD_LOGIN_TAG then  -- 登陆送元宝
        if self.all_page_t[AWARD_LOGIN_TAG] == nil then
            self.all_page_t[AWARD_LOGIN_TAG] =  loginAwardPage()
            curr_page_width =  self.all_page_t[AWARD_LOGIN_TAG].view:getSize().width
            self.all_page_t[AWARD_LOGIN_TAG].view:setPosition(window_width/2-curr_page_width/2, 13)
            self.view:addChild( self.all_page_t[AWARD_LOGIN_TAG].view )
        end
        self.current_panel = self.all_page_t[AWARD_LOGIN_TAG]
    end
    
    if self.current_panel and self.current_panel.update then
        self.current_panel:update( "all" )
    end
    self.current_panel.view:setIsVisible(true)
end


function AwardWin:__init( window_name, texture_name )
    self.all_page_t = {}              -- 存储所有已经创建的页面
    self.current_panel = nil      -- 当前的面板。用于记录 界面。在切换的时候做操作
    self.btn_radio_t = {}    -- btn
    self.btn_name_t = {}  --标签不同文字贴图集合
      --背景框
    local bgPanel = self.view
    window_width = bgPanel:getSize().width
    window_height = bgPanel:getSize().height

    local win_size = self.view:getSize();
    local but_beg_x = 35          --按钮起始x坐标
    local but_beg_y = win_size.height - 105        --按钮起始y坐标
    local but_int_x = 101          --按钮x坐标间隔 102
    local btn_w = -1  
    local btn_h = -1

    self.radio_buts = CCRadioButtonGroup:buttonGroupWithFile(but_beg_x ,
        but_beg_y, 
        but_int_x * 3, 
        42,
        nil)
    bgPanel:addChild( self.radio_buts )


    -- 在线奖励
    local i = 1
    --78 11 ->-1 -1
    self:create_a_button(self.radio_buts, 
        1 + but_int_x * (i - 1), 1, btn_w, btn_h, 
        UILH_COMMON.tab_gray,
        UILH_COMMON.tab_light,
        Lang.award[3],
        "",
        -1, -1, i)
     AWARD_ONLINE_TAG = i

     -- 
    i = i + 1   -- i = 2
    self:create_a_button(self.radio_buts, 
        1 + but_int_x * (i - 1), 1, btn_w, btn_h, 
        UILH_COMMON.tab_gray,
        UILH_COMMON.tab_light,
        Lang.award[4],
        "",
        -1, -1, i)
    AWARD_SEVEN_TAG = i

    print("---2----is_show_login_page:", is_show_login_page)
    -- if is_show_login_page then
        i = i + 1
        self:create_a_button(self.radio_buts, 
            1 + but_int_x * (i - 1), 1, btn_w, btn_h, 
            UILH_COMMON.tab_gray,
            UILH_COMMON.tab_light,
            Lang.award[6],
            "",
            -1, -1, i)
        AWARD_LOGIN_TAG = i
    -- end
end

-- 更新在线奖励界面
function AwardWin:update_online_award()
    if self.all_page_t[AWARD_ONLINE_TAG] then
        self.all_page_t[AWARD_ONLINE_TAG]:update_data()
    end
end

function AwardWin:create( texture_name )
    return AwardWin("AwardWin", texture_name, false, window_width, window_height);
end

-- 提供外部调用更新的静态方法
function AwardWin:update_award_win( update_type )
    local win = UIManager:find_visible_window( "award_win" )
    if win ~= nil then
        win:update( update_type )
    end
end

function AwardWin:update( update_type )

    if update_type == "login_draw" then
        if self.all_page_t[3] then
            self.all_page_t[3]:update("update_data")
        else
            local is_get, num_t = LoginLuckyDrawModel:get_data()
            if is_get then
                if self.btn_radio_t[3] then
                    self.btn_radio_t[3]:setIsVisible(false)
                end
            end
        end
    else
        self.current_panel:update( update_type )
    end
end


-- 激活窗口更新 
function AwardWin:active( show )
    if show then
        -- 请求登陆送元宝的数据
        LoginLuckyDrawModel:req_login_award_data()
        -- 判断是否有这个登陆送元宝这个活动
        is_show_login_page = LoginLuckyDrawModel:is_show( )
        if not is_show_login_page then
            if self.btn_radio_t[3] then
                self.btn_radio_t[3]:setIsVisible(false)
            end
        end
        self:change_page(1)
        if self.current_panel and self.current_panel.update then
            self.current_panel:update("all")
        end
    end
end


function AwardWin:destroy()
    Window.destroy(self)
    if self.all_page_t ~= nil and type(self.all_page_t) == "table" then
        for key, page in pairs(self.all_page_t) do
            page:destroy()
        end 
    end
end

function AwardWin:set_is_show_login_page( flag )
    is_show_login_page = flag
end
