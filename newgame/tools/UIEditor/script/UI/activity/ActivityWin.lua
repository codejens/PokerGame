-- ActivityWin.lua  
-- created by lyl on 2013-2-20
-- 活动主窗口  activity_Win

super_class.ActivityWin(NormalStyleWindow)

-- win_change_page
ActivityWin.EXPERIENCE = 1
ActivityWin.MONEY = 2

-- 控件坐标
local win_w = 900
local win_h = 605
local align_x = 10
local panel_interval = 5
local radio_b_w = 101 -- 从ui获取的尺寸,radiobtn
local radio_b_h = 45
local panel_h_b = win_h-40
local panel_w = 900-align_x*2
local panel_h = panel_h_b-radio_b_h

function ActivityWin:__init( window_name, texture_name, is_grid, width, height )
	self.all_page_t = {}              -- 存储所有已经创建的页面
	self.current_panel = nil          -- 当前的面板。用于记录 界面。在切换的时候做操作
    self.page_tips_t = {}             -- 分页按钮上的提示标志
    -- self.but_name_t = {}
     self.player =EntityManager:get_player_avatar()
    local bgPanel = self.view

    local but_beg_x = 20;          --按钮起始x坐标
    local btn_num = 5

    self.radio_buts = CCRadioButtonGroup:buttonGroupWithFile(but_beg_x, panel_h+5 , radio_b_w*btn_num, 50, nil)
    self.view:addChild(self.radio_buts)

    self:create_a_button(self.radio_buts, 1+radio_b_w*(btn_num-5),1,  -1, -1, UILH_COMMON.tab_gray, UILH_COMMON.tab_light, Lang.wanfadating[1], 1)
    self:create_a_button(self.radio_buts, 1+radio_b_w*(btn_num-4),1,  -1, -1, UILH_COMMON.tab_gray, UILH_COMMON.tab_light, Lang.wanfadating[2], 2)
    self:create_a_button(self.radio_buts, 1+radio_b_w*(btn_num-3),1,  -1, -1, UILH_COMMON.tab_gray, UILH_COMMON.tab_light, Lang.wanfadating[3], 3)

    -- 背景图片
    local page_bg = CCBasePanel:panelWithFile( 10, 15, panel_w, panel_h, UILH_COMMON.normal_bg_v2, 500, 500 )
    self.view:addChild(page_bg)

    --默认显示第一页
    self:change_page( 1 )
end

-- 创建一个按钮:参数： 要加入的panel， 坐标和长宽，按钮两种状态背景图，显示文字图片，文字图片的长宽，序列号（用于触发事件判断调用的方法）
function ActivityWin:create_a_button(panel, pos_x, pos_y, size_w, size_h, image_n, image_s , but_name_txt, but_index)
    local radio_button = CCRadioButton:radioButtonWithFile(pos_x, pos_y, size_w, size_h, image_n)
    radio_button:addTexWithFile(CLICK_STATE_DOWN,image_s)
    --按钮显示的名称

    ZLabel:create( radio_button, but_name_txt, 101*0.5, 12, 16, ALIGN_CENTER, 1)
	local function but_1_fun(eventType,x,y)
        if eventType == TOUCH_BEGAN  then 
            --根据序列号来调用方法
            return true
        elseif eventType == TOUCH_CLICK then
            -- if but_index == 2 then 
            --     Instruction:handleUIComponentClick(instruct_comps.FUBENTIAOZHANG)
            -- end
            self:change_page( but_index )
            return true;
        elseif eventType == TOUCH_ENDED then
            return true;
        end
	end
    radio_button:registerScriptHandler(but_1_fun)    --注册
    panel:addGroup(radio_button)
end

function ActivityWin:create_but_name(but_index, but_name_n, but_name_s )
    local but_name = {}
    local but_name_label = nil
    if but_index == 1 then
        but_name_label = CCZXImage:imageWithFile( 96/2 - 70/2-13 , 42/2 - 18/2+7, -1, -1, but_name_n )
    else 
        but_name_label = CCZXImage:imageWithFile( 96/2 - 70/2-1 , 42/2 - 18/2+7, -1, -1, but_name_n )
    end
    but_name.view = but_name_label

    but_name.change_to_selected = function (  )
        but_name_label:setTexture( but_name_s )
    end
    but_name.change_to_no_selected = function (  )
        but_name_label:setTexture( but_name_n )
    end
    return but_name
end

--切换功能窗口:   2:副本活动   3：日常活动   1:boss挑战   4：跑环任务   5：组队副本
function ActivityWin:change_page( but_index )
    -- 特殊处理
    local radio_but_index = but_index
    if but_index == 8 then    -- 8表示消费奖励页，但是可能并没有那么多页（根据条件）
        if self.show_six == false then
            radio_but_index = 6 
        else
            radio_but_index = 7
        end
    end
    self.radio_buts:selectItem( radio_but_index - 1)
    
     -- 把当前显示的页隐藏
    if self.current_panel then
        self.current_panel.view:setIsVisible(false)
    end
    Analyze:parse_click_main_menu_info(but_index + 140)
    if but_index == 1 then
        if self.all_page_t[1] == nil then
            self.all_page_t[1] = FubenActivityPage:create()
            -- self.all_page_t[1] = FBChallengePage:create()
            self.all_page_t[1]:setPosition(20, 23)
            self.view:addChild( self.all_page_t[1].view )
        end
        self.current_panel = self.all_page_t[1]
        -- self.all_page_t[1]:update_new_state()
        -- self.all_page_t[1]:update_tips_count()
    elseif  but_index == 2 then
        if self.all_page_t[2] == nil then
            self.all_page_t[2] =  DailyActivityPage:create(  )
            self.all_page_t[2]:setPosition(20, 23)
            self.view:addChild( self.all_page_t[2].view )
        end
        self.current_panel = self.all_page_t[2]
        -- self.all_page_t[2]:update_new_state()
        --发送请求 服务器时间
        MiscCC:send_req_server_time()
    elseif  but_index == 3 then
        if self.all_page_t[3] == nil then
            self.all_page_t[3] =  BossActivityPage:create()
            self.all_page_t[3]:setPosition(20, 23)
            self.view:addChild( self.all_page_t[3].view )
        end
        self.current_panel = self.all_page_t[3]
        -- 申请世界boss数据
        ActivityModel:apply_world_boss_date(  )     
    -- elseif  but_index == 4 then


    --    if(self.player.level>=PaoHuanModel:get_max_level()) then 
    --         if self.all_page_t[4] == nil then
    --             self.all_page_t[4] = LoopTaskActivityPage:create()
    --             curr_page_width =  self.all_page_t[4]:getSize().width
    --             self.all_page_t[4].view:setPosition(win_w/2-curr_page_width/2, 28)
    --             self.view:addChild( self.all_page_t[4].view )
    --         end
    --         self.current_panel = self.all_page_t[4]    
    --     end
    end
    if self.current_panel and self.current_panel.update then
        self.current_panel:update( "all" )
    end
    self.current_panel.view:setIsVisible(true)

    return self.current_panel
end

-- 外部静态调用，切换页
-- data: 外部引导界面使用(经验，金钱，战力)，对应
function ActivityWin:win_change_page( index, data )
    local win = UIManager:show_window( "activity_Win" )
    if win then
        local cur_page = win:change_page( index )
        if index == 1 then -- 副本分页
            -- 第二个参数表示 推荐
            if ActivityWin.EXPERIENCE == data then
                self:sld_exp_fuben_item( cur_page )
                return
            elseif ActivityWin.MONEY == data then
                cur_page:slt_fb_item(4, true)  -- 金窟宝穴
            end
        end
    end
end

-- 推荐有经验的副本
function ActivityWin:sld_exp_fuben_item( cur_page )
    local enter_times= ActivityModel:get_enter_fuben_count(11) 
    if enter_times > 0 then
        cur_page:slt_fb_item(2, true)  -- 雁门关
        return
    end
    enter_times= ActivityModel:get_enter_fuben_count(65) 
    if enter_times > 0 then
        cur_page:slt_fb_item(5, true)  -- 皇陵秘境
        return
    end
    enter_times= ActivityModel:get_enter_fuben_count(12) 
    if enter_times > 0 then
        cur_page:slt_fb_item(6, true)  -- 比翼双飞
        return
    end
    enter_times= ActivityModel:get_enter_fuben_count(58) 
    if enter_times > 0 then
        cur_page:slt_fb_item(7, true)  -- 破狱之战
        return
    end
    enter_times= ActivityModel:get_enter_fuben_count(60) 
    if enter_times > 0 then
        cur_page:slt_fb_item(8, true)  -- 决战雁门关
        return
    end
    enter_times= ActivityModel:get_enter_fuben_count(66) 
    if enter_times > 0 then
        cur_page:slt_fb_item(9, true)  -- 马踏联营
        return
    end
    enter_times= ActivityModel:get_enter_fuben_count(64) 
    if enter_times > 0 then
        cur_page:slt_fb_item(10, true)  -- 密宗佛塔
        return
    end
end

-- 提供外部静态调用的更新窗口方法
function ActivityWin:update_win( update_type,update_data)
    local win = UIManager:find_visible_window("activity_Win")
    if win then
        -- 把数据交给背包窗口显示
        win:update( update_type,update_data);   
    end
end

-- 更新数据
function ActivityWin:update( update_type,update_data)
    if update_type == "all" then
        -- self:update_all()
    elseif update_type == "page_tips" then
        -- self:update_page_tips()
    else
        self.current_panel:update( update_type , update_data)
    end
end

function ActivityWin:active( if_active )
    if if_active then
        MiscCC:send_req_server_time()
        if self.current_panel then
            self.current_panel:update("all")
            if ActivityModel:get_refresh_default_page() then
                self:change_page( 1 )
                ActivityModel:set_refresh_default_page(false)
            end
        end
    else
        LuaEffectManager:stop_view_effect( 9,self.view );
        -- LuaEffectManager:stop_view_effect( 9,self.view );
        WelfareModel:set_is_check_off_line(false)
        WelfareModel:check_offer_line_time()
       --[[ if XSZYManager:get_state() == XSZYConfig.HUOYUE_ZY then 
            -- 自动继续主线任务
            -- AIManager:do_quest(TaskModel:get_zhuxian_quest());
            XSZYManager:continue_do_quest(2)
            XSZYManager:destroy_jt(XSZYConfig.OTHER_SELECT_TAG);
        end--]]
    end
end

function ActivityWin:destroy()
    if self.all_page_t ~= nil and type(self.all_page_t) == "table" then
        for key, page in pairs(self.all_page_t) do
            page:destroy()
        end 
    end
    Window.destroy(self)
end

-- function ActivityWin:create_chongzhilibao_button()
--     local index = 7
--     if self.all_page_t[6] == nil then
--         index = 6 
--     end
--    self.chongzhilibao_button,self.chongzhilibao_text = self:create_a_button(self.radio_buts, 1 + 94 * (index-1), 1, 94, 37,
--     UIResourcePath.FileLocate.common .. "common_tab_n.png", UIResourcePath.FileLocate.common .. "common_tab_s.png",
--     "ui/newactivity/xiaofeilibao.png",70, 20, 8)
-- end

function ActivityWin:update_page_tips()
    -- local b = 0 
    -- local win = UIManager:find_visible_window("activity_Win")
    -- if win then
    --     for key,value in ipairs(win.page_tips_t) do 
    --         if key == 1 then 
    --             b = ActivityModel:get_all_fuben_remain_times()
    --             win.page_tips_t[key].update_tips(2,b)
    --         elseif key == 2 then
    --             b = ActivityModel:get_all_activities_intime()
    --             win.page_tips_t[key].update_tips(1,b)
    --         elseif key == 3 then 
    --             b = ActivityModel:get_field_boss_exist_count()
    --             win.page_tips_t[key].update_tips(1,b)
    --         elseif key == 4 then
    --             b = ActivityModel:statistic_activity_award_can_get()
    --             win.page_tips_t[key].update_tips(1,b)
    --         elseif key == 5 then
    --             -- b = DailyWelfarePage:update_tips_count()
    --             b = WelfareModel:get_daily_awrads_state()
    --             win.page_tips_t[key].update_tips(1,b)
    --         end
    --     end
    -- end
end

function ActivityWin:change_fuli_index_page(index)
    if self.all_page_t[5] ~= nil then
        self.all_page_t[5]:change_index_page(index)
    end
end

    -- if(self.player.level>=PaoHuanModel:get_max_level()) then 
    --     self:create_a_button(self.radio_buts, 1+radio_b_w*(btn_num-2),1,  -1, -1, UILH_COMMON.tab_gray, UILH_COMMON.tab_light, "每周跑环", 4)
    -- else
    --     btn_num=btn_num - 1
    -- end