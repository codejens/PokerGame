-- JingKuangWin.lua
-- create by xiehande on 2015-1-22
-- 幻梦晶矿
super_class.JingKuangWin(NormalStyleWindow)
--构造函数
local window_width = nil
local window_height = nil
local radio_button_array = {}
function JingKuangWin:__init( window_name, window_info )
    self.all_page_t = {}              -- 存储所有已经创建的页面
    self.current_panel = nil      -- 当前的面板。用于记录 界面。在切换的时候做操作
    self.btn_name_t = {}  --标签不同文字贴图集合
      --背景框
    local bgPanel = self.view
     window_width = bgPanel:getSize().width
     window_height = bgPanel:getSize().height

    -- 顶部所有按钮
    local win_size = self.view:getSize();
    local but_beg_x = 35          --按钮起始x坐标
    local but_beg_y = win_size.height - 105        --按钮起始y坐标
    local but_int_x = 101          --按钮x坐标间隔 102
    local btn_w = -1  
    local btn_h = -1

    self.top_radio_group = CCRadioButtonGroup:buttonGroupWithFile(but_beg_x ,
        but_beg_y, 
        but_int_x * 8, 
        42,
        nil)
    bgPanel:addChild( self.top_radio_group )


    local i = 1
    --78 11 ->-1 -1
   radio_button_array[i] =  self:create_a_button(self.top_radio_group, 
        1 + but_int_x * (i - 1), 1, btn_w, btn_h, 
        UILH_COMMON.tab_gray,
        UILH_COMMON.tab_light,
        "矿 脉",
        "",
        -1, -1, i)

    MY_KUANG_TAG = i

    i = i + 1   -- i = 2
   radio_button_array[i] =  self:create_a_button(self.top_radio_group, 
        1 + but_int_x * (i - 1), 1, btn_w, btn_h, 
        UILH_COMMON.tab_gray,
        UILH_COMMON.tab_light,
        "选 矿",
        "",
        -1, -1, i)
    XUAN_KUANG_TAG = i
    self:change_page(1)
end


--当界面被UIManager:show_window, hide_window的时候调用
function JingKuangWin:active(show)
    print("active 方法")
	if show then
		-- 刷新
        if ( self.all_page_t[1] ) then
            self.all_page_t[1]:on_active();
        end
        
        if ( self.all_page_t[2] ) then
            self.all_page_t[2]:on_active();
        end
        -- self:set_xuankuang_status( )
        self:update_remain_time(  )
	end
end





function JingKuangWin:create_a_button(panel, pos_x, pos_y, size_w, size_h, image_n, image_s ,but_name, but_name_s,but_name_siz_w, but_name_siz_h, but_index)
    local radio_button = CCRadioButton:radioButtonWithFile(pos_x, pos_y, size_w, size_h, image_n)
    radio_button:addTexWithFile(CLICK_STATE_DOWN,image_s)
    local function but_1_fun(eventType,x,y)
        if eventType == TOUCH_CLICK then 
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
    --self.btn_name_t[but_index] = GuildWin:create_btn_name(but_name,but_name_s,size_w/2,size_h/2,but_name_siz_w,but_name_siz_h)

    self.btn_name_t[but_index] = ZLabel:create( nil, but_name, 0, 0)
    local btn_size = radio_button:getSize()
    local lab_size = self.btn_name_t[but_index]:getSize()
    self.btn_name_t[but_index]:setPosition( ( btn_size.width - lab_size.width ) / 2, ( btn_size.height - lab_size.height ) / 2 )

    radio_button:addChild( self.btn_name_t[but_index].view )
    return radio_button
end


--切换功能窗口:   
function JingKuangWin:change_page( but_index )

    --    for k,v in pairs(self.btn_name_t) do
    --    v.change_to_no_selected()
    -- end
    -- self.btn_name_t[but_index].change_to_selected()
    for i=1,#radio_button_array do
        if i == but_index then 
            radio_button_array[i]:setCurState(CLICK_STATE_DOWN)
        else
            radio_button_array[i]:setCurState(CLICK_STATE_UP)
        end
    end
    -- 把当前显示的页隐藏
    if self.current_panel then
        self.current_panel.view:setIsVisible(false)
    end
    
    local curr_page_width = 860
    local curr_page_height = 410
   
    if but_index == MY_KUANG_TAG then   --矿脉
        if self.all_page_t[MY_KUANG_TAG] == nil then
            self.all_page_t[MY_KUANG_TAG] =  MyKuangPage:create(  )
            curr_page_width =  self.all_page_t[MY_KUANG_TAG].view:getSize().width
            self.all_page_t[MY_KUANG_TAG].view:setPosition(window_width/2-curr_page_width/2, 13)
            self.view:addChild( self.all_page_t[MY_KUANG_TAG].view )
        end
        self.current_panel = self.all_page_t[MY_KUANG_TAG]
    elseif  but_index == XUAN_KUANG_TAG then  --选矿
        if self.all_page_t[XUAN_KUANG_TAG] == nil then
            self.all_page_t[XUAN_KUANG_TAG] =   XuanKuangPage:create( )
            curr_page_width =  self.all_page_t[XUAN_KUANG_TAG].view:getSize().width
            self.all_page_t[XUAN_KUANG_TAG].view:setPosition(window_width/2-curr_page_width/2, 13)
            self.view:addChild( self.all_page_t[XUAN_KUANG_TAG].view )
        end
        self.current_panel = self.all_page_t[XUAN_KUANG_TAG]
    end
    
    if self.current_panel and self.current_panel.update then
        self.current_panel:update( "all" )
    end

    self.current_panel.view:setIsVisible(true)
end


function JingKuangWin:update_jing_kuang( type)
    if type==1 then
        if self.all_page_t[2] then
            self.all_page_t[2]:update_cur_kuang()
        end
    elseif type==2 then
        if self.all_page_t[1] then
            self.all_page_t[1]:update_my_kuang()
        end
    elseif type==3 then
        if self.all_page_t[1] then
            self.all_page_t[1]:update_fiend_scroll()
            self.all_page_t[1]:update_my_kuang()

        end
    end
end

-- 更新刷新剩余时间
function JingKuangWin:update_remain_time(  )
    if self.time then 
        self.time:destroy();
        self.time = nil;
    end
    local time = SmallOperationModel:get_act_time( 3 ); 
    print("time=",time);
    local function finish_call(  )
        if self.time then
          self.time:setString("0秒")
        end
    end
    -- #cFFFF00活动结束倒计时：
    self.time = TimerLabel:create_label( self.view, 350-52,540 , 19, time,LH_COLOR[1].."活动结束倒计时：#c08d53d" , finish_call, false,ALIGN_LEFT);   -- lyl ms

    if time == nil or time <= 0 then
        if self.time then
          self.time:setPosition(350,540)
    end
        finish_call();
    end 


end

-- -- 设置选矿按钮状态
function JingKuangWin:set_xuankuang_status(   )
    -- local xuan_kuang =  ZImageButton:create(self.view, UILH_COMMON.button4, UILH_COMMON.button4, go_btn_fun, 94, 10, 77, 78, 1)
    local shen_fen = JingkuangModel:get_shenfen(  )
    print("设置选矿按钮状态",shen_fen)
    if shen_fen~= 2 then    

        radio_button_array[2]:setCurState(CLICK_STATE_UP)
        radio_button_array[1]:setCurState(CLICK_STATE_DOWN)
        radio_button_array[2]:setIsVisible(true)
    else
        -- xuan_kuang.view:setIsVisible(false);
        radio_button_array[1]:setCurState(CLICK_STATE_DOWN)
        radio_button_array[2]:setCurState(CLICK_STATE_UP)
        radio_button_array[2]:setIsVisible(false)
        self:change_page(1)
    end
end


--销毁方法
function JingKuangWin:destroy()
    if self.time then
        self.time:destroy();
        self.time = nil;
    end

    if self.all_page_t[MY_KUANG_TAG].time then
        self.all_page_t[MY_KUANG_TAG].time:destroy();
        self.all_page_t[MY_KUANG_TAG].time = nil;
    end

    if self.all_page_t ~= nil and type(self.all_page_t) == "table" then
        for key, page in pairs(self.all_page_t) do
            self.view:removeChild( page.view, true )
            self.all_page_t[key] = nil
        end 
    end
    Window.destroy(self);
end
