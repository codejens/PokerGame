-- DailyActivityPage.lua  
-- created by lyl on 2013-2-20
-- 日常活动页  

super_class.DailyActivityPage(Window)

-- 副本图标尺寸
local icon_width = 102
local icon_height = 112
-- 副本图标间隔
local icon_space_x = 54+14
local icon_space_y = 22-8
-- 每行显示的图标个数
local icon_count_per_line = 4
-- 建议等级坐标
local sugLv_x = 60
local sugLv_y = 38
-- 页面期望宽度
local exp_width = 743

-- ui param
local panel_w = 860
local panel_h = 500
local panel_up_h = 330
local panel_bttm_h = 500-panel_up_h-6
local line_y = 70

-- local fb_item = { "试炼场", "一骑当先", "校武场", "金窟宝穴", "爬塔副本1", "情人岛", "爬塔副本2", "决战雁门关", "叛军营地", "罗马古塔" }
-- local fb_item = 1
local image_t = UILH_ACTIVITY.daily_image_t

function DailyActivityPage:create(  )
    return DailyActivityPage( "DailyActivityPage", "", false, panel_w, panel_h )
end

function DailyActivityPage:__init( window_name, window_info )

    -- 副本item以及选中的item
    self._t_fb_item = {}
    self._index_sld = nil  -- 选择的index
    self._act_id_sld = nil -- 选择的部分id

    -- 副本配置数据 根据level排序
    local fuben_list_data = ActivityModel:get_activity_info_by_class( "daily" )
    self._fuben_list_data = fuben_list_data

    -- 上面板界面，副本列表
    self:create_up_panel()
    self:create_bttm_panel()

    -- 请求各个副本次数
    -- ActivityModel:request_enter_fuben_times()

    self:slt_fb_item(1)
end

-- 上部面板 ===========================================
function DailyActivityPage:create_up_panel( )
    self.panel_up = CCBasePanel:panelWithFile(3, panel_bttm_h+6, panel_w-6, panel_up_h-15, UILH_COMMON.bottom_bg, 500, 500);
    self.view:addChild(self.panel_up);

    -- title
    -- self.title_up = CCBasePanel:panelWithFile( 0, 300, panel_w-6, -1, UILH_NORMAL.title_bg4 )
    -- title(354, 44) & (75, 22)
    self.title_up = CCBasePanel:panelWithFile( 248, 286, -1, -1, UILH_NORMAL.title_bg3 )
    self.panel_up:addChild( self.title_up )
    -- local title_txt = ZLabel:create(self.title_up, Lang.wanfadating[2], 178, 17, 16, 2)
    local title_txt = CCZXImage:imageWithFile( (354-75)*0.5, (44-22)*0.5,-1, -1, UILH_ACTIVITY.daily_activity )
    self.title_up:addChild( title_txt )
    -- 创建 scrollview
    self:create_scroll_area(self.panel_up, 0, line_y+9, panel_w-10, panel_up_h-line_y-30, "", self._fuben_list_data )

    -- 分割线
    local line = CCZXImage:imageWithFile( 10, line_y, panel_w-25, 3, UILH_COMMON.split_line )
    self.panel_up:addChild(line)

    -- 道具提示
    ZLabel:create(self.panel_up, LH_COLOR[2] .. Lang.wanfadating[37], 15, 40, 16, 1, 1)
    ZLabel:create(self.panel_up, LH_COLOR[2] .. Lang.wanfadating[38], 15, 20, 16, 1, 1)

    -- 道具
    local item_t = ActivityModel:get_fuben_activity_award_items( self._fuben_list_data[1].id )
    if #item_t > 0 then
        self.award_item_list = self:create_item_scroll( item_t , 225-60, 0, 55, 55, 7, "")
        self.panel_up:addChild( self.award_item_list )
    end
end

-- 创建可拖动区域                  
function DailyActivityPage:create_scroll_area( panel , pos_x, pos_y, size_w, size_h, bg_name, list_date)
    -- ui param
    local row_h = 90 
    local row_w = 135
    local row_inter_h = 20
    local row_num = 6
    local item_num = #list_date --self.fuben_config
    local line_num = math.ceil(item_num/row_num)
    local panel_scr_h = row_h*line_num+row_inter_h*line_num

    --总行数，每列的最大值
    local _scroll_info = { x = pos_x, y = pos_y, width = size_w, height = size_h, maxnum = 1, image = bg_name, stype= TYPE_HORIZONTAL }
    local scroll = CCScrollDynamicArea:scrollWithFile( _scroll_info.x, _scroll_info.y, _scroll_info.width, _scroll_info.height, _scroll_info.maxnum, _scroll_info.image, _scroll_info.stype, 500, 500 )
    scroll:setEnableScroll(false)
    -- scroll:setScrollLump(UIResourcePath.FileLocate.common .. "common_progress.png", UIResourcePath.FileLocate.common .. "input_frame_bg.png", 10, 40, 42)
    --scroll:setEnableCut(true)
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
            local x = temparg[1]              -- 行
            local y = temparg[2]              -- 列
            local index = x + 1
            local panel_items = CCBasePanel:panelWithFile( 0, 0, panel_w-10, panel_scr_h, "" )
            scroll:addItem(panel_items)

            for i=1, item_num do
                local num_y = math.ceil(i/row_num)
                local num_x = math.mod(i,row_num)
                if num_x == 0 then
                    num_x = row_num
                end
                self:create_fb_item( panel_items, 26+(num_x-1)*(row_w+5), panel_scr_h - num_y*(row_h+row_inter_h), -1, -1, i , list_date[i], image_t[i])
            end

            scroll:refresh()
            return false
        end
    end
    scroll:registerScriptHandler(scrollfun)
    scroll:refresh()

    panel:addChild( scroll )

    return scroll
end

-- 创建副本item -----------------
function DailyActivityPage:create_fb_item( panel, x, y, w, h, index, item_data, image )
    local fb_item = {}
    -- 背景框
    local fb_item_gb = CCBasePanel:panelWithFile( x, y, w, h, UILH_NORMAL.item_bg3, 500, 500 )
    panel:addChild( fb_item_gb )
    fb_item.bg = fb_item_gb
    fb_item.bg:setScale(0.9)

    -- 图标
    local lttl_map = CCBasePanel:panelWithFile( 14, 10, -1, -1, image)
    fb_item.bg:addChild(lttl_map)
    fb_item.lttl_map = lttl_map

    -- 副本名字
    -- if item_data.name then
    --     fb_item.name = ZLabel:create(fb_item.bg, LH_COLOR[1] .. item_data.name, 103*0.5, 95, 16, 2, 2)
    -- end

    -- 标志 是否开始
    fb_item.item_sign = CCZXImage:imageWithFile( 15, 70, -1, -1, UILH_ACTIVITY.in_activity )
    fb_item.item_sign:setAnchorPoint(0, 1)
    fb_item.item_sign:setIsVisible(false)
    fb_item.bg:addChild( fb_item.item_sign, 2 )

    -- 选中标志
    fb_item.frame_sld = CCZXImage:imageWithFile( 0, 0, -1, -1, UILH_NORMAL.item_bg3_sld, 500, 500 )
    fb_item.bg:addChild(fb_item.frame_sld)
    fb_item.frame_sld:setIsVisible(false)

    fb_item.time_tip = ZLabel:create(fb_item.bg, LH_COLOR[15] .. "17:00-21:00", 114*0.5, -5, 14, 2)
    fb_item.time_tip_2 = ZLabel:create(fb_item.bg, LH_COLOR[15] .. "", 114*0.5, -20, 14, 2)

    -- 活动item事件 ------------------------------------------------------
    local function fb_item_func(eventType, arg, msgid, selfitem)
        if eventType == nil or arg == nil or msgid == nil or selfitem == nil then
            return
        end
        if eventType == TOUCH_BEGAN then
            self:slt_fb_item( index )
            return true
        elseif eventType == TOUCH_CLICK then
            return true;
        end
        return true;
    end
    fb_item.bg:registerScriptHandler( fb_item_func )  --注册 -------------

    self._t_fb_item[index] = fb_item
    return fb_item
end

-- 创建可拖动区域   参数：放入scroll的panel的集合, 坐标， 区域大小，列数，可见行数， 背景名称
function DailyActivityPage:create_item_scroll( panel_table_para , pos_x, pos_y, item_w, item_h, item_inter, img_bg)
    require "UI/activity/ActivityCommon"
    -- local scroll = ActivityCommon:create_item_scroll( panel_table_para , pos_x, pos_y, size_w, size_h, colu_num, sight_num, bg_name)
        -- return scroll
    local item_panel = ActivityCommon:create_item_horizontal(panel_table_para, pos_x, pos_y, item_w, item_h, item_inter, img_bg)
    return item_panel
end

-- 底部列表 ===========================================
function DailyActivityPage:create_bttm_panel(  )
    self.panel_bttm = CCBasePanel:panelWithFile(3, 3, panel_w-6, panel_bttm_h, UILH_COMMON.bottom_bg, 500, 500);
    self.view:addChild(self.panel_bttm);

    -- 分割线
    local line = CCZXImage:imageWithFile( (panel_w-20)*0.5, 5, 3, 155, UILH_COMMON.split_line_v )
    self.panel_bttm:addChild(line)

    -- 左边title --------------
    self.title_left = CCBasePanel:panelWithFile( 0, 130, 425, -1, UILH_NORMAL.title_bg4, 500, 500 )
    self.panel_bttm:addChild( self.title_left )
    local title_txt_left = ZLabel:create(self.title_left, Lang.wanfadating[9], 425*0.5, (31-16)*0.5, 16, 2)

    -- 活动介绍
    self.act_desc = CCDialogEx:dialogWithFile( 15, 130, 380, 75, 10, "", TYPE_VERTICAL ,ADD_LIST_DIR_UP);
    self.act_desc:setAnchorPoint(0,1);
    self.act_desc:setFontSize(16);
    self.act_desc:setText( "我是介绍" );  -- "#cffff00当前效果:#cffffff:"
    self.act_desc:setTag(0)
    self.act_desc:setLineEmptySpace (5)
    self.panel_bttm:addChild(self.act_desc)

    -- 是否自动购买材料勾选按钮
    self.transmit_but = UIButton:create_switch_button(10, 10, 150, 44, 
        UILH_COMMON.dg_sel_1, 
        UILH_COMMON.dg_sel_2, 
        Lang.wanfadating[6], 40, 16, nil, nil, nil, nil, 
        autoBuyFunc )
    self.panel_bttm:addChild(self.transmit_but.view, 2);

    -- ZLabel:create(self.panel_bttm, LH_COLOR[2] .. "点击进行传送", 50, 22, 16, 1, 1)
    self.trans_item = ZLabel:create(self.panel_bttm, LH_COLOR[15] .. "(小飞鞋剩余5个)", 170, 22, 16, 1, 1)

    -- 右边title --------------
    self.title_right = CCBasePanel:panelWithFile( 430, 130, 425, -1, UILH_NORMAL.title_bg4, 500, 500 )
    self.panel_bttm:addChild( self.title_right )
    local title_txt_right = ZLabel:create(self.title_right, Lang.wanfadating[8], 425*0.5, (31-16)*0.5, 16, 2)

    -- 经验 & 道具 & 剩余次数
    -- self.star_name_1 = ZLabel:create(self.panel_bttm, LH_COLOR[2] .. "经验：", 445, 105, 14, 1, 1)
    -- self.star_name_2 = ZLabel:create(self.panel_bttm, LH_COLOR[2] .. "道具：", 445, 77, 14, 1, 1)
    -- -- -- 经验5颗星
    -- self.exp_star = CCBasePanel:panelWithFile(495, 93, 185, 45, "")
    -- self.panel_bttm:addChild( self.exp_star )
    -- MUtils:drawStart3(self.exp_star, 5)
    -- -- 道具5颗星
    -- self.exp_star = CCBasePanel:panelWithFile(495, 60, 185, 45, "")
    -- self.panel_bttm:addChild( self.exp_star )
    -- MUtils:drawStart3(self.exp_star, 5)

    -- 星星 第一列
    self.star_name_1   = ZLabel:create(self.panel_bttm, LH_COLOR[2] .. Lang.wanfadating[27][1], 445, 105, 14, 1, 1)
    self.star_range_1  = MUtils:create_star_range( self.panel_bttm, 495, 100, 25, 25, 4 ) 
    self.star_range_1.change_star_interval( 10 )

    -- 星星 第二列
    self.star_name_2 = ZLabel:create(self.panel_bttm, LH_COLOR[2] .. Lang.wanfadating[27][1], 445, 77, 14, 1, 1)
    self.star_range_2  = MUtils:create_star_range( self.panel_bttm, 495, 70, 25, 25, 5 ) 
    self.star_range_2.change_star_interval( 10 )


    -- 剩余次数
    -- ZLabel:create(self.panel_bttm, LH_COLOR[2] .. "剩余次数：", 680, 60, 14, 1, 1)
    -- self.go_num = ZLabel:create(self.panel_bttm, LH_COLOR[15] .. "0/3", 765, 60, 14, 1, 1)

    -- btn 委托 & 前往活动npc
    -- local function entrust_func()
    --     if self._act_id_sld then
    --         ActivityModel:open_fuben_entrust( self._act_id_sld )
    --     end
    -- end
    -- self.btn_entrust = ZTextButton:create(self.panel_bttm, LH_COLOR[2] .. Lang.wanfadating[11], UILH_COMMON.btn4_nor, 
    --     entrust_func, 490, 3, -1, -1)
     local function goto_func()
        local item_data = self._fuben_list_data[self._index_sld]
        -- #1
        if ActivityConfig.ACTIVITY_LINGQUANXIANYU == item_data.id then
            GlobalFunc:create_screen_notic("暂未开放")
            return
        end

        -- if ActivityConfig.ACTIVITY_QUESTION == item_data.id then
        --     -- 答题活动
        --     local player = EntityManager:get_player_avatar();
        --     if player.level >= 30 then
        --         local jion_times = QuestionActivityModel:get_jion_times( );
        --         if jion_times < 1 then
        --             GlobalFunc:create_screen_notic( LangGameString[553] ); -- [553]="此活动每日只能参加一次"
        --         else
        --             UIManager:show_window("question_win");
        --         end
        --     else
        --         GlobalFunc:create_screen_notic( LangGameString[554] ); -- [554]="人物等级需要达到30级"
        --     end
        --     return 
        -- end

        -- local fu_id = {[3]=59, [6]=69}
        local win = nil
        if ActivityConfig.ACTIVITY_ZHENYINGZHAN == item_data.id then
            -- MiscCC:req_enter_battle(1)
            win = UIManager:show_window("camp_win");
            win:set_is_show_from_activityWin(true)
            return 
        end
        if (ActivityConfig.ACTIVITY_BAGUADIGONG == item_data.id) or (ActivityConfig.ACTIVITY_QUESTION == item_data.id)then
            -- MiscCC:enter_baguadigong(  )
            win = UIManager:show_window("activity_sub_win");
            win:set_is_show_from_activityWin(true)
            win:update(item_data.id);
            return 
        end

        if (ActivityConfig.ACTIVITY_FREE_MATCH == item_data.id) or (ActivityConfig.ACTIVITY_DOMINATION_MATCH == item_data.id) then
            local win = UIManager:show_window("activity_sub_win");
            if win ~= nil then
                win:update(item_data.id);
            end
            return
        end

        
        local if_transmit = self.transmit_but.if_selected     -- 是否选择了传送
        ActivityModel:go_to_activity( item_data.location.sceneid, item_data.location.entityName, if_transmit )

        -- #2
        -- GlobalFunc:create_screen_notic("暂未开放")
    end
    self.btn_goto = ZTextButton:create(self.panel_bttm, LH_COLOR[2] .. Lang.wanfadating[12], UILH_COMMON.btn4_nor, 
        goto_func, 680, 3, -1, -1)
end

-- =====================================================================================================================
-- 更新 数据
-- =====================================================================================================================
function DailyActivityPage:update( update_type )
    self:update_fuben_status()
end

-- 更新各个副本item的状态
function DailyActivityPage:update_fuben_status()
    -- for i=1,#self._t_fb_item do
        -- if i ~= self._fb_item_sld then
            -- local require_level = self._fuben_list_data[i].level
            -- local player_level = EntityManager:get_player_avatar().level
            -- if player_level<require_level then
                -- self._t_fb_item[i].times_bg:setIsVisible(false)
                -- self._t_fb_item[i].view:setCurState(CLICK_STATE_DISABLE)
                -- self._t_fb_item[i].item_sign:setIsVisible(false)
                -- self._t_fb_item[i].name_bg:setIsVisible(false)
                -- self._t_fb_item[i].lttl_map:setTexture( UILH_ACTIVITY.lttl_map_d )
                -- self._t_fb_item[i].lock:setIsVisible(true)
            -- else
                -- self._t_fb_item[i].times_bg:setIsVisible(true)
                -- self._t_fb_item[i].view:setCurState(CLICK_STATE_UP)
                -- self._t_fb_item[i].item_sign:setIsVisible(true)
                -- self._t_fb_item[i].name_bg:setIsVisible(true)
                -- self._t_fb_item[i].lttl_map:setTexture( UILH_ACTIVITY.lttl_map )
                -- self._t_fb_item[i].lock:setIsVisible(false)
            -- end 
            -- self._t_fb_item[i].frame_sld:setIsVisible(false)
        -- else
            -- self._t_fb_item[i].frame_sld:setIsVisible(true)
        -- end 
    -- end
end

-- 副本选择
function DailyActivityPage:slt_fb_item( index )
    self._act_id_sld = self._fuben_list_data[index].id
    self._index_sld = index
    for i=1, #self._t_fb_item do
        self._t_fb_item[i].frame_sld:setIsVisible(false)
    end
    self._t_fb_item[index].frame_sld:setIsVisible(true)
    self:update_introduce( self._act_id_sld ) 
    self:update_award( self._act_id_sld )
    -- self:update_time( self._act_id_sld )
    self:update_cloud_num()
end

-- 更新介绍
function DailyActivityPage:update_introduce( activity_id )
    local activity_introduce = ActivityModel:get_activity_introduce_by_id( activity_id )
    self.act_desc:setText( "" )
    self.act_desc:setText( activity_introduce )
end

-- 更新副本奖励
function DailyActivityPage:update_award( activity_id )
    -- 星星
    local stars_info_ret_t = ActivityModel:get_activity_star( activity_id )
    if stars_info_ret_t[1] then
        self.star_name_1:setText( LH_COLOR[2] ..stars_info_ret_t[1].name .. ": " )
        self.star_range_1.change_star_num( stars_info_ret_t[1].num )
    else
        self.star_name_1:setText("")
        self.star_range_1.change_star_num( 0 )
    end
    if stars_info_ret_t[2] then
        self.star_name_2:setText( LH_COLOR[2] .. stars_info_ret_t[2].name .. ": " )
        self.star_range_2.change_star_num( stars_info_ret_t[2].num )
    else
        self.star_name_2:setText("")
        self.star_range_2.change_star_num( 0 )
    end

    self.panel_up:removeChild( self.award_item_list, true)
    -- 道具
    local item_t = ActivityModel:get_fuben_activity_award_items( activity_id )
    if #item_t > 0 then
        self.award_item_list = self:create_item_scroll( item_t , 225-60, 3, 55, 55, 7, "")
        self.panel_up:addChild( self.award_item_list )
    end
end

-- -- 更新次数
-- function DailyActivityPage:update_time( activity_id )
--     local enter_times, max_times, extra_award = ActivityModel:get_enter_fuben_count( activity_id ) 
--     print("更新所有副本的进入次数", activity_id, enter_times, max_times, extra_award )
--     self.go_num:setText( string.format("%d/%d", enter_times, max_times) )
-- end

-- 更新筋斗云个数
function DailyActivityPage:update_cloud_num(  )
    local cloud_num = ActivityModel:get_cloud_num(  )
    -- self.transmit_but.setString( LangGameString[545]..cloud_num..LangGameString[546] ) -- [545]="自动传送(筋斗云剩余" -- [546]="个)"
    self.trans_item:setText( Lang.wanfadating[13] .. cloud_num .. Lang.wanfadating[14] )
end

function DailyActivityPage:update_selected( activity_id )

end

-- 调用方法 =========================================================================
-- 显示本日内开启的倒计时文本信息          ==========================================
local function showOpenTimeInDay(txt,p_now_sec,p_start_sec)
    local del = p_start_sec - p_now_sec
    local temp = 0
    if del >= 3600 then
        temp = math.floor(del/3600)
        txt:setText( string.format( Lang.wanfadating[32],temp) )
    elseif del >= 60 then
        temp = math.floor(del/60)
        txt:setText(string.format(Lang.wanfadating[33],temp))
    else
        txt:setText(string.format(Lang.wanfadating[33],1))
    end
end
-- 显示本日后开启的日期提示信息
local function showOpenTimeOutDay(txt,p_today_t,p_openday_t,hour_time)
    local del = p_openday_t.totalDay - p_today_t.totalDay
    if p_openday_t.totalDay == p_today_t.totalDay+1 then
        txt:setText(string.format( Lang.wanfadating[22],hour_time))
    elseif p_openday_t.totalWeek == p_today_t.totalWeek then 
        txt:setText(string.format( Lang.wanfadating[23],LangGameString[2313][p_openday_t.weekday],hour_time))
    elseif p_openday_t.totalWeek - p_today_t.totalWeek == 1 then
        txt:setText(string.format( Lang.wanfadating[24],LangGameString[2313][p_openday_t.weekday]))
    elseif p_openday_t.totalWeek - p_today_t.totalWeek > 1 then
        txt:setText(string.format( Lang.wanfadating[25],p_openday_t.month,p_openday_t.day))
    end     
end

-- 更新系统时间
--获取下次开放的时间信息
-- st:tabel 服务器时间
-- ot:tabel 开服时间
-- de:tabel 活动延迟开放时间
-- ptime:string 活动时间配置
local function get_open_date( st, ot, de, ptime, pname)
    -- 计算与2013年1月1日的日期差
    print("--------st:", st, ot, de, ptime, pname )
    local today_del   = MUtils:now_to_day(st.year,st.month,st.day)
    local openday_del = MUtils:now_to_day(ot.year,ot.month,ot.day)
    local delt        = today_del - openday_del --间隔天数
    local delt2       = nil                     --跨越的周末数
    --//判断服务器时间是否超过了延时开放限制
    local if_out_of_delay = false --是否超过延时期
    if de == nil then 
        if_out_of_delay = true
    elseif de[1] == 0 then
        if delt >= de[2] then   --跨越的天数
            if_out_of_delay = true
        else
            if_out_of_delay = false
        end
    elseif de[1] == 1 then
        local openday_to_weekend = 7 - ot.weekday                      --开服日期距离最近的周日
        local open_weekend = openday_del +  openday_to_weekend         --开服周的周日距离原始时间（2013.1.1）
        delt2 = math.ceil((today_del - open_weekend)/7)
        if delt2 >= de[2] then
            if_out_of_delay = true
        else
            if_out_of_delay = false
        end
    end
    --//查询活动最近可开放的日期
    local activity_next_openday_del = nil    --活动下一次开启日与2013年1月1日的日期差
    local activity_next_openday_t   = nil    --活动下一次开启日的时间数据
    local activity_delay_del = nil      --活动延时的结束日与2013年1月1日的日期差(当日可开启活动)
    local s_day = nil     --遍历起始日期
    local day_len = 7   --遍历长度
    if if_out_of_delay == false then 
        if de[1] == 0 then 
            activity_delay_del = openday_del + de[2]
        elseif de[1] == 1 then 
            activity_delay_del = openday_del + (7 - ot.weekday) + (delt2-1)*7 +1
        end
        s_day = activity_delay_del
    else
        s_day = today_del
    end

    local temp_weekday = nil     --记录活动开启日的星期几
    for i=0,day_len do
        local s_day_weekday = (s_day+i+2)%7    --获取s_day对应的 星期几
        local if_day_in_cfg = Utils:match_weekday(s_day_weekday,ptime)  --这天是否在配置表中有对应
        if if_day_in_cfg == true then
            activity_next_openday_del = s_day+i
            temp_weekday = s_day_weekday
            break
        end
    end
    local temp_info = Utils:format_time_to_info(activity_next_openday_del*24*3600) --计算年月日
    local temp_total_week = math.ceil((activity_next_openday_del+2)/7)
    activity_next_openday_t = {
        totalDay = activity_next_openday_del,
        totalWeek= temp_total_week,
        year     = temp_info.year,
        month    = temp_info.month,
        day      = temp_info.day,
        weekday  = temp_weekday,
    }

    --计算再下一个活动开启日
    local activity_next_openday_del2 = nil 
    local activity_next_openday_t2   = nil
    local s_day2 = activity_next_openday_del + 1
    local temp_weekday2 = nil 
    for i=0,day_len do
        local s_day_weekday = (s_day2+i+2)%7
        local if_day_in_cfg = Utils:match_weekday(s_day_weekday,ptime)
        if if_day_in_cfg == true then
            activity_next_openday_del2 = s_day2+i
            temp_weekday2 = s_day_weekday
            break
        end
    end
    local temp_info2 = Utils:format_time_to_info(activity_next_openday_del2*24*3600)
    local temp_total_week2 = math.ceil((activity_next_openday_del2+2)/7)
    activity_next_openday_t2 = {
        totalDay = activity_next_openday_del2,
        totalWeek= temp_total_week2,
        year     = temp_info2.year,
        month    = temp_info2.month,
        day      = temp_info2.day,
        weekday  = temp_weekday2,
    }

    return activity_next_openday_t,activity_next_openday_t2
end

-- 更新开放状态的显示
local time_desc = Lang.wanfadating[39]
function DailyActivityPage:update_open_state(server_time,server_open_time)
    print("---------time:", server_time, server_open_time )
    local player_data = EntityManager:get_player_avatar()
    for i=1, #self._t_fb_item do
        -- if player_data.level < self._fuben_list_data[i].level then

        -- else

            -- 7个活动
            self._t_fb_item[i].time_tip:setText(time_desc[i][1])
            self._t_fb_item[i].time_tip_2:setText(time_desc[i][2])


            -- 秦皇地宫，判断时候开服两天后
            if i == 6 then
                local today_del   = MUtils:now_to_day( server_time.year, server_time.month, server_time.day)
                local openday_del = MUtils:now_to_day( server_open_time.year,server_open_time.month, server_open_time.day)
                local delt        = today_del - openday_del --间隔天数
                if delt > 2 then
                    self._t_fb_item[i].time_tip:setText(time_desc[i][3])
                    self._t_fb_item[i].time_tip_2:setText(time_desc[i][4])
                end
            end
        -- end
    end
end

-- 更新活动图标上的提示剩余次数的标志
function DailyActivityPage:update_tips_count()

end

function DailyActivityPage:destroy( )
    for i=1, #self._t_fb_item do
        if self._t_fb_item[i].refresh_time then
            self._t_fb_item[i].refresh_time:destroy()
            self._t_fb_item[i].refresh_time = nil
        end
    end
    Window.destroy(self)
end
