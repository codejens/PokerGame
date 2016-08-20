-- BenefitWin.lua
-- created by LittleWhite 2014-7-23 
-- 福利中心主界面

super_class.BenefitWin(NormalStyleWindow)

-- local _index_to_category_name = { [1] = "login_benefit",[2] = "active_benefit",[3] = "experience_benefit",[4] = "chakela_benefit"}

--窗体大小
local window_width = 900
local window_height = 605

function BenefitWin:__init(  )
    self.all_page_t = {}              -- 存储所有已经创建的页面
    self.current_panel = nil          -- 当前的面板。用于记录 界面。在切换的时候做操作
        self.btn_name_t = {}  --标签不同文字贴图集合
    local bgPanel = self.view
    local bg_size = bgPanel:getSize()
    self:create_btn_panel(bgPanel)

 -- self.show_six = false
    -- print("activity win ActivityModel:get_chongzhilibao_state() ",ActivityModel:get_chongzhilibao_state() )

    --充值礼包部分
      -- if ActivityModel:get_chongzhilibao_state() then
      --   local index = 7
      --   if self.show_six == false then
      --       index = 6 
      --   end
      --  self.chongzhilibao_button,self.chongzhilibao_text = self:create_a_button(self.radio_buts, 1 + but_int_x * (index-1), 1, 94, 37, UIResourcePath.FileLocate.common .. "common_tab_n.png", UIResourcePath.FileLocate.common .. "common_tab_s.png", UIResourcePath.FileLocate.newactivity .. "xiaofeilibao.png",70, 20, 8)
    -- end
    self:change_page( 1 )
end

-- 提供外部静态调用的更新窗口方法
function BenefitWin:win_change_page( index )
    local win = UIManager:show_window( "benefit_win" )
    if win then
        win:change_page( index )
    end
end

--更新数据
function BenefitWin:update( update_type )
    if update_type == "all" then
    elseif update_type == "page_tips" then
    else
        self.current_panel:update( update_type )
    end
end

function BenefitWin:active( show )
    if show then
        -- 如果签到分页已经被创建，就刷新一下数据
        if self.all_page_t[3] then
            self.all_page_t[3]:active(show)
        end
    end
end

--创建标签集合
function BenefitWin:create_btn_panel( bgPanel )

        -- 顶部所有按钮
    local win_size = bgPanel:getSize();
    local btn_num = 4
    local but_beg_x = 35          --按钮起始x坐标
    local but_beg_y = win_size.height - 105        --按钮起始y坐标
    local but_int_x = 101          --按钮x坐标间隔 102
    local btn_w = -1  
    local btn_h = -1

    --标签集合面板
    self.radio_buts = CCRadioButtonGroup:buttonGroupWithFile( but_beg_x ,
        but_beg_y , 
        but_int_x *btn_num ,
        42, nil )
    bgPanel:addChild( self.radio_buts )

    local i = 1
    self:create_a_button(self.radio_buts, 
        1 + but_int_x * (i - 1), 1, btn_w, btn_h, 
        UILH_COMMON.tab_gray,
        UILH_COMMON.tab_light,
        Lang.benefit.tab[1],
        "",
        -1, -1, i)
    BENEFIT_FULI_TAG = i

    i = i + 1   -- i = 2     --活跃奖励
    self:create_a_button(self.radio_buts, 
        1 + but_int_x * (i - 1), 1, btn_w, btn_h, 
        UILH_COMMON.tab_gray,
        UILH_COMMON.tab_light,
        Lang.benefit.tab[2],
        "",
        -1, -1, i)
    BENEFIT_HUOYE_TAG = i

    i = i + 1   -- i = 3
    self:create_a_button(self.radio_buts,  --签到奖励
        1 + but_int_x * (i - 1), 1, btn_w, btn_h,
        UILH_COMMON.tab_gray,
        UILH_COMMON.tab_light,
        Lang.benefit.tab[3],
        "",
        -1, -1, i)
    BENEFIT_ACTIVITY_TAG = i

        i = i + 1   -- i = 3
    self:create_a_button(self.radio_buts,  --离线奖励
        1 + but_int_x * (i - 1), 1, btn_w, btn_h,
        UILH_COMMON.tab_gray,
        UILH_COMMON.tab_light,
        "离线奖励",
        "",
        -1, -1, i)
    BENEFIT_OFFLINE_TAG = i


end


-- 创建一个按钮:参数： 要加入的panel， 坐标和长宽，按钮两种状态背景图，显示文字图片，文字图片的长宽，序列号（用于触发事件判断调用的方法）
function BenefitWin:create_a_button(panel, pos_x, pos_y, size_w, size_h, image_n, image_s ,but_name, but_name_s,but_name_siz_w, but_name_siz_h, but_index)
    local radio_button = CCRadioButton:radioButtonWithFile(pos_x, pos_y, size_w, size_h, image_n)
    radio_button:addTexWithFile(CLICK_STATE_DOWN,image_s)
    local function but_1_fun(eventType,x,y)
        if eventType == TOUCH_CLICK then 
            Instruction:handleUIComponentClick(instruct_comps.BENEFIT_WIN_BASE + but_index)
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

--切换标签的文字效果
-- function  BenefitWin:create_btn_name( btn_name_n,btn_name_s,name_x,name_y,btn_name_size_w,btn_name_size_h )
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
function BenefitWin:change_page( but_index )
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
   
    if but_index == BENEFIT_FULI_TAG then   --每日福利
        if self.all_page_t[BENEFIT_FULI_TAG] == nil then
            self.all_page_t[BENEFIT_FULI_TAG] =  DailyWelfarePage:create()
            curr_page_width =  self.all_page_t[BENEFIT_FULI_TAG]:getSize().width
            self.all_page_t[BENEFIT_FULI_TAG].view:setPosition(window_width/2-curr_page_width/2, 17)
            self.view:addChild( self.all_page_t[BENEFIT_FULI_TAG].view )
        end
        
        self.current_panel = self.all_page_t[BENEFIT_FULI_TAG]

    elseif  but_index == BENEFIT_HUOYE_TAG then  --活跃奖励
        if self.all_page_t[BENEFIT_HUOYE_TAG] == nil then
            self.all_page_t[BENEFIT_HUOYE_TAG] =  ActivityAwardPage:create()
            curr_page_width =  self.all_page_t[BENEFIT_HUOYE_TAG]:getSize().width
            self.all_page_t[BENEFIT_HUOYE_TAG].view:setPosition(window_width/2-curr_page_width/2, 12)
            self.view:addChild( self.all_page_t[BENEFIT_HUOYE_TAG].view )
        end
        self.current_panel = self.all_page_t[BENEFIT_HUOYE_TAG]

    elseif  but_index == 3 then   --签到分页
        if self.all_page_t[3] == nil then
            self.all_page_t[3] =  QianDaoPage:create()
            curr_page_width =  self.all_page_t[3]:getSize().width
            self.all_page_t[3].view:setPosition(window_width/2-curr_page_width/2, 10)
            self.view:addChild( self.all_page_t[3].view )
        end
        self.current_panel = self.all_page_t[3]

    elseif  but_index == BENEFIT_OFFLINE_TAG then   --离线奖励分页
        if self.all_page_t[BENEFIT_OFFLINE_TAG] == nil then
            self.all_page_t[BENEFIT_OFFLINE_TAG] =  OffLinePage:create()
            curr_page_width =  self.all_page_t[BENEFIT_OFFLINE_TAG]:getSize().width
            self.all_page_t[BENEFIT_OFFLINE_TAG].view:setPosition(window_width/2-curr_page_width/2, 17)
            self.view:addChild( self.all_page_t[BENEFIT_OFFLINE_TAG].view )
        end
        self.current_panel = self.all_page_t[BENEFIT_OFFLINE_TAG]

    end
    
    if self.current_panel and self.current_panel.update then
        self.current_panel:update( "all" )
    end
    self.current_panel.view:setIsVisible(true)
    self.radio_buts:selectItem(but_index - 1)
end



--销毁方法
function BenefitWin:destroy()
      --福字下发受多条请求影响 已设置为不自动删除 这里需手动移除 added by xiehande 2015-2-9
     local is_already_exist,index = MiniBtnWin:is_already_exist( 20 );
    if  is_already_exist then
        MiniBtnWin:remove_btn_and_layout(20)
    end
    is_already_exist,index = MiniBtnWin:is_already_exist( 20 );
    --记得还原状态喔
    MiniBtnWin:set_aoto_remove_flag(true)
    Window.destroy(self)
    if self.all_page_t ~= nil and type(self.all_page_t) == "table" then
        for key, page in pairs(self.all_page_t) do
            page:destroy()
        end 
    end
end



-- 更新签到分页的“是否已签到”数据
function BenefitWin:update_qd_state()
    if self.all_page_t[3] then
        self.all_page_t[3]:update_qd_state()
    end
end

-- 更新签到分页的“签到奖励”数据
function BenefitWin:update_qiandao_award_accept_btn_state()
    if self.all_page_t[3] then
        self.all_page_t[3]:update_award_accept_btn_state()
    end
end

































    --火影中的福利系统
	-- 标题
    -- local win_title_bg = CCZXImage:imageWithFile(175, 558, 574, 80, UIPIC_Benefit_001)
    -- self.view:addChild(win_title_bg,1000)

    -- local win_title = CCZXImage:imageWithFile(191, 22, 188, 58,UIPIC_Benefit_002)
    -- win_title_bg:addChild(win_title)

    -- 背景
    -- local page_bg = CCBasePanel:panelWithFile(30, 20, 852, 562, UIPIC_GRID_nine_grid_bg3, 500, 500)
    -- self.view:addChild(page_bg)

--     -- 左列表
--     self:create_left_panel()

--     -- 记录每个列表，控制显示与隐藏
--     self.right_page_tab = {}        
--     -- 登陆页
--     self.login_panel = BenefitLoginPage(215,32)
--     self.view:addChild( self.login_panel.view )
--     table.insert( self.right_page_tab, self.login_panel)

--     -- 活跃页
--     self.active_panel = BenefitActivePage(215,32)
--     self.view:addChild( self.active_panel.view )
--     table.insert( self.right_page_tab, self.active_panel)

--     -- 经验页
--     self.exp_panel = BenefitEXPPage(215,32)
--     self.view:addChild( self.exp_panel.view )
--     table.insert( self.right_page_tab, self.exp_panel)

--     -- 查克拉页
--     self.chakela_panel = BenefitChakelaPage(215,32)
--     self.view:addChild( self.chakela_panel.view )
--     table.insert( self.right_page_tab, self.chakela_panel )

--     self.current_panel = nil
--     self:Choose_panel( "login_benefit" )
-- end

-- function BenefitWin:create_left_panel()
--     -- 活动列表
--     local list_panel = CCBasePanel:panelWithFile(41, 32, 170, 537,UIPIC_Benefit_003, 500, 500);
--     self.view:addChild(list_panel);

--     self.benefit_scroll = CCScroll:scrollWithFile( 0, 0, 170, 537, 1, "", TYPE_HORIZONTAL, 600, 600 )

--     local btn_num = 4
--     self.raido_btn_group = CCRadioButtonGroup:buttonGroupWithFile(0 ,0, 170, 125 * btn_num, nil)

--     for i=1,btn_num do
--         local function did_selected_act(  )
--             self:change_page(i)
--         end

--         local act_button = self:create_a_button(0, 125 * (btn_num-i), -1, -1, UIPIC_Benefit_021, UIPIC_Benefit_022, i, did_selected_act)
--         self.raido_btn_group:addGroup(act_button)
--     end

--     self.benefit_scroll:addItem(self.raido_btn_group)
--     self.benefit_scroll:refresh()
--     list_panel:addChild(self.benefit_scroll)
-- end

-- function BenefitWin:create_a_button(pos_x, pos_y, size_w, size_h, image_n, image_s, index, func)
--     local one_btn =  CCRadioButton:radioButtonWithFile(pos_x, pos_y, size_w, size_h, image_n)
--     one_btn:addTexWithFile(CLICK_STATE_DOWN, image_s)

--     local function but_1_fun(eventType,x,y)
--         if eventType == TOUCH_BEGAN  then 
--             return true
--         elseif eventType == TOUCH_CLICK then
--             func(index)
--             return true
--         elseif eventType == TOUCH_ENDED then
--             return true
--         end
--     end
--     one_btn:registerScriptHandler(but_1_fun)    --注册

--     -- 按钮标题
--     local btn_text = ZImage.new("ui/benefit/list_text_" .. index .. ".png")
--     btn_text:setPosition(82, 44)
--     btn_text.view:setAnchorPoint(0.5,0.5)
--     one_btn:addChild(btn_text.view)

--     return one_btn
-- end

-- -- 选择显示的面板
-- function BenefitWin:Choose_panel( panel_type,info)
--     for key, right_panel in pairs(self.right_page_tab) do
--         right_panel.view:setIsVisible( false )
--     end

--     if panel_type == "login_benefit" then
--         self.login_panel.view:setIsVisible( true )
--         self.login_panel:update(  ) 
--         self.current_panel = self.login_panel
--     elseif panel_type == "active_benefit" then
--         self.active_panel.view:setIsVisible( true )
--         self.active_panel:update(  ) 
--         self.current_panel = self.active_panel
--     elseif panel_type == "experience_benefit" then 
--         self.exp_panel.view:setIsVisible( true )
--         self.exp_panel:update(  ) 
--         self.current_panel = self.exp_panel
--     elseif panel_type == "chakela_benefit" then
--         self.chakela_panel.view:setIsVisible( true )
--         self.chakela_panel:update()
--         self.current_panel = self.chakela_panel
--     end
-- end

-- --切页
-- function BenefitWin:change_page( page_index )
-- 	self:Choose_panel( _index_to_category_name[page_index] )
--     self.raido_btn_group:selectItem(page_index-1)
-- end

-- -- 销毁窗体
-- function BenefitWin:destroy()
--     if self.login_panel then
--         self.login_panel:destroy()
--     end 
--     if self.active_panel then
--         self.active_panel:destroy()
--     end
--     if self.exp_panel then
--         self.exp_panel:destroy()
--     end
--     if self.chakela_panel then
--         self.chakela_panel:destroy()
--     end
--     Window.destroy(self)
-- end

-- function BenefitWin:update( update_type, data )  
--     self.current_panel:update(update_type)
-- end

-- -- 判断当前的panel是否是查克拉领取页面
-- function BenefitWin:isCurrentPanelChakela()
--     if self.current_panel == self.chakela_panel then
--         return true
--     else
--         return false
--     end
-- end

-- -- 获取指定的子页面
-- function BenefitWin:getPanelByType( panel_type )
--     if panel_type == "login_benefit" then
--         return self.login_panel
--     elseif panel_type == "active_benefit" then
--         return self.active_panel
--     elseif panel_type == "experience_benefit" then
--         return self.exp_panel
--     elseif panel_type == "chakela_benefit" then
--         return self.chakela_panel
--     end
-- end

-- -- 播放成功领取查克拉特效
-- function BenefitWin:play_chakela_success_effect(effect_id)
--     if self:isCurrentPanelChakela() then
--         LuaEffectManager:play_view_effect( effect_id, 340, 250, self.chakela_panel.view )
--     end
-- end

-- -- 改变关闭按钮被点击时的响应函数
-- function BenefitWin:on_exit_btn_create_finish()
--     if self.exit_btn then
--         local function on_exit_btn_clicked()
--             UIManager:hide_window("benefit_win")

--             -- 检查在"福利中心"窗口被关闭的时候,是否还有灵气没有被领取,如果有的话,就要弹出"领"字按钮
--             -- 20级以下不弹出"领"字提示
--             local player = EntityManager:get_player_avatar()
--             if not player or player.level < 20 then
--                 return
--             end

--             local curStage = LinggenModel:getCurLingqiStage()
--             local curState = LinggenModel:getCurLingqiState()
--             if curStage ~= 0 then
--                 -- 是否已领取判断
--                 local isHasGot = Utils:get_bit_by_position(curState, curStage)
--                 -- 还未领取,判断是否已经有"领"字按钮在主界面,没有时才创建"领"字按钮
--                 if isHasGot == 0 then
--                     if MiniBtnWin:is_already_exist(22) then
--                         return
--                     else
--                         local function click_callback()
--                             local benefitWin = UIManager:show_window("benefit_win")
--                             benefitWin:change_page(4)
--                         end
--                         MiniBtnWin:show(22, click_callback)
--                     end
--                 end
--             end
--         end
--         self.exit_btn:setTouchClickFun(on_exit_btn_clicked)
--     end
-- end