-- MagicTreeWin.lua
-- created by chj on 2015-3-16
-- 昆仑神树窗口

require "UI/component/Window"
super_class.MagicTreeWin(NormalStyleWindow)

-- 收获排行是否显示
-- 朋友列表是否显示
MagicTreeWin.rec_is_open = false
MagicTreeWin.fri_is_open = false

-- crollview 类型
MagicTreeWin.SCROLL_REC = 0
MagicTreeWin.SCROLL_FRI = 1
MagicTreeWin.cur_scroll_type = MagicTreeWin.SCROLL_REC

-- 一键成熟提示状态
MagicTreeWin.is_mature_once_tip = false
MagicTreeWin.is_getfruit_tip = false

-- 初始化
function MagicTreeWin:__init( window_name, texture_name )

	-- 大背景 =============================
	self.panel_bg = CCBasePanel:panelWithFile( 10, 10, 880, 550, UILH_COMMON.normal_bg_v2, 500, 500 )
    self.view:addChild( self.panel_bg)

    -- 大树
    self.panel_tree = CCBasePanel:panelWithFile( 12, 12, 855, 525, "nopack/BigImage/kunlun_magictree.jpg")
    self.panel_bg:addChild( self.panel_tree)

    -- 收获提示
    self.receive_tip = ZLabel:create( self.panel_tree, LH_COLOR[11] .. Lang.Magictree[1], 350, 170, 16)

    -- 活动剩余时间
    local function end_call_func()
        ZLabel:create( self.panel_bg, LH_COLOR[2] .. Lang.Magictree[2], 440, 495, 16, ALIGN_CENTER )
    end
    local remain_time = MagicTreeModel:get_actvity_time( )
    -- local remain_time = 25330
    if remain_time > 0 then
        ZLabel:create( self.panel_bg, LH_COLOR[2] .. Lang.Magictree[3], 403, 495, 16, ALIGN_RIGHT)
        self.timer_label = TimerLabel:create_label( self.panel_bg, 410, 495, 16, remain_time, LH_COLOR[2], end_call_func, nil, nil, ALIGN_LEFT )
    else  
        end_call_func()
    end
    -- 果实
    self.ui_fruit_t = {}
    -- 当前成熟度 & 是否已经成熟
    self.cur_maturity = 0
    self.flag_matured = false

-- up -----------------------------------------
    local function fri_info_func( )
        self.btn_friend_rec.view:setScaleY(1)
        self.btn_world_rec.view:setScaleY(1.1)
        MagicTreeCC:req_receive_log( )
    end
    -- 收获排行按钮
    local function receive_rank_func( eventType)
        print("----收获日志")
        if self.rec_is_open then
            self.panel_rec_rank:setIsVisible( false)
            self.rec_is_open = false
        else
            self.panel_rec_rank:setIsVisible( true)
            self.rec_is_open = true
            fri_info_func()
        end
    end
    self.btn_rec_rank = ZTextButton:create(self.panel_bg, LH_COLOR[2] .. Lang.Magictree[4], UILH_COMMON.button6_4, receive_rank_func, 10, 475, 200, 53, 1)

    -- 好友列表
    local function friend_open_func( eventType)
        print("----好友列表")
        if self.fri_is_open then
            self.panel_friend_rank:setIsVisible( false)
            self.fri_is_open = false
        else
            self.panel_friend_rank:setIsVisible( true)
            self.fri_is_open = true
            MagicTreeCC:req_friend_info()
        end
    end
    self.btn_friend = ZTextButton:create(self.panel_bg, LH_COLOR[2] .. Lang.Magictree[5], UILH_COMMON.button6_4, friend_open_func, 670, 475, 200, 53, 1)

-- down --------------------------------------

	-- 回自家神树
    local function own_tree_func( eventType)
        local player_id = EntityManager:get_player_avatar().id
        print("----自家神树:", player_id)
        MagicTreeCC:req_magictree_info( player_id)
    end
    self.btn_own_tree = ZTextButton:create(self.panel_bg, "", UILH_COMMON.page, own_tree_func, 30, 50, -1, -1, 1)


    -- 浇水
    local function water_func( eventType)
        -- local player_id = EntityManager:get_player_avatar().id
        local player_id = MagicTreeModel:get_cur_player_id( )
        print("----浇水", player_id)
        MagicTreeCC:req_water( player_id)
    end
    self.btn_water = ZTextButton:create(self.panel_bg, "", UILH_MAGICTREE.mt_btn, water_func, 195, 50, -1, -1, 1)
    local water_img = CCBasePanel:panelWithFile(10, 20, -1, -1, UILH_MAGICTREE.mt_water_tool)
    self.btn_water:addChild( water_img)
    local water_font = CCBasePanel:panelWithFile( 20, 2, -1, -1, UILH_MAGICTREE.mt_water)
    self.btn_water:addChild( water_font)

    -- 一键成熟
    local function mature_once_func( eventType)
        if self.flag_matured then
            local function refresh_tree_func()
                MagicTreeCC:req_next_mature()
            end
            ConfirmWin2:show( 3, nil, LH_COLOR[2] .. Lang.Magictree[6], refresh_tree_func)
        else
            local function req_mature_once_func()
                MagicTreeCC:req_mature_once()
            end

            local function switch_func( if_selected )
                self.is_mature_once_tip = if_selected
            end

            local maturity_all = MagicTreeConfig:get_magictree_maturity( )
            if maturity_all == self.cur_maturity then
                GlobalFunc:create_screen_notic( Lang.Magictree[7])
                return
            end

            if self.is_mature_once_tip == false then
                local cost_ybs = MagicTreeConfig:get_yb_mature_once( )
                local str = string.format( LH_COLOR[2] .. Lang.Magictree[8], cost_ybs[self.cur_maturity] )
                ConfirmWin2:show( 1, nil, str, req_mature_once_func, switch_func)
            elseif self.is_mature_once_tip == true then
                req_mature_once_func()
            end
        end
    end
    self.btn_mature_once = ZTextButton:create(self.panel_bg, "", UILH_MAGICTREE.mt_btn, mature_once_func, 370, 50, -1, -1, 1)
    local mature_img = CCBasePanel:panelWithFile(16, 18, -1, -1, UILH_MAGICTREE.mt_fruit)
    self.btn_mature_once:addChild( mature_img)
    self.mature_font = CCBasePanel:panelWithFile( 4, 2, -1, -1, UILH_MAGICTREE.mt_mature_once)
    self.btn_mature_once:addChild( self.mature_font)

    -- 仓库
    local function warehouse_func( eventType)
        print("----仓库")
        UIManager:show_window( "magictree_cangku_win")
    end
    self.btn_warehouse = ZTextButton:create(self.panel_bg, "", UILH_MAGICTREE.mt_btn, warehouse_func, 550, 50, -1, -1, 1)
    local warehouse_img = CCBasePanel:panelWithFile(16, 14, -1, -1, UILH_MAGICTREE.mt_bag)
    self.btn_warehouse:addChild( warehouse_img)
    local warehouse_font = CCBasePanel:panelWithFile( 20, 2, -1, -1, UILH_MAGICTREE.title_cangku)
    self.btn_warehouse:addChild( warehouse_font)

    -- 进度条
    self.maturity_num = MagicTreeConfig:get_magictree_maturity( )
    self.process_bar_fix = ZXProgress:createWithValueEx(1,6,580,17,UILH_NORMAL.progress_bg2,UILH_NORMAL.progress_bar, true);
    self.process_bar_fix:setPosition(CCPointMake(145,163));
    self.process_bar_fix:setProgressValue( 0, self.maturity_num )
    self.view:addChild(self.process_bar_fix)

    -- 进度条两边的箭头
    self.pro_arrow_l = CCBasePanel:panelWithFile( -10, -10, -1, -1, UILH_NORMAL.progress_left)
    self.process_bar_fix:addChild( self.pro_arrow_l)
    self.pro_arrow_r = CCBasePanel:panelWithFile( 560, -10, -1, -1, UILH_NORMAL.progress_left)
    self.process_bar_fix:addChild( self.pro_arrow_r)
    self.pro_arrow_r:setFlipX( true)

    -- 进度条的分割线
    local x_temp = math.ceil(560/self.maturity_num )
    for i=1, self.maturity_num-1 do
        local split_c = CCBasePanel:panelWithFile( 95*i, 5, -1, -1, UILH_MAGICTREE.mt_split)
        self.process_bar_fix:addChild( split_c)
    end

    -- 神树主人名字
    ZLabel:create( self.view, LH_COLOR[2] .. Lang.Magictree[8], 780, 100, 16, ALIGN_RIGHT)
    self.name_master = ZLabel:create( self.view, "master's name", 780, 100, 16, ALIGN_LEFT)

    self:create_receive_rank()
    self:create_friends_rank()
end


-- 创建收获排行 ============================
function MagicTreeWin:create_receive_rank( )
	self.panel_rec_rank = CCBasePanel:panelWithFile( 20, 140, 200, 350, UILH_COMMON.bottom_bg, 500, 500)
	self.view:addChild( self.panel_rec_rank, 1)

    -- scrollview 
    self.scroll_rec = self:create_scroll_view(7, 50, 175, 288, MagicTreeWin.SCROLL_REC)
    self.panel_rec_rank:addChild( self.scroll_rec)

    -- 添加滚动条上下箭头
    local arrow_up = CCZXImage:imageWithFile(182, 332, -1, -1, UILH_COMMON.scrollbar_up)
    self.panel_rec_rank:addChild(arrow_up, 10)
    local arrow_down = CCZXImage:imageWithFile(182, 49, -1, -1, UILH_COMMON.scrollbar_down)
    self.panel_rec_rank:addChild(arrow_down, 10)

    -- 好友收获日志按钮
    local function fri_info_func( )
        -- self.scroll_rec:clear()
        -- self.scroll_data_rec = data1
        -- self.scroll_rec:refresh()
        self.btn_friend_rec.view:setScaleY(1)
        self.btn_world_rec.view:setScaleY(1.1)
        MagicTreeCC:req_receive_log( )
    end
    self.btn_world_rec = ZTextButton:create(self.panel_rec_rank, LH_COLOR[2] .. Lang.Magictree[10], UILH_COMMON.button6_4, fri_info_func, 10, 6, -1, -1, 1)


    -- 自己按钮
    local function own_info_func( ... )
        self.btn_world_rec.view:setScaleY(1)
        self.btn_friend_rec.view:setScaleY(1.1)
        MagicTreeCC:req_opera_log( )
    end
    self.btn_friend_rec = ZTextButton:create(self.panel_rec_rank, LH_COLOR[2] .. Lang.Magictree[11], UILH_COMMON.button6_4, own_info_func, 100, 6, -1, -1, 1)

    self.panel_rec_rank:setIsVisible( false)
end

-- 创建好友列表 ============================
function MagicTreeWin:create_friends_rank( )
    self.panel_friend_rank = CCBasePanel:panelWithFile( 680, 140, 200, 350, UILH_COMMON.bottom_bg, 500, 500)
    self.view:addChild( self.panel_friend_rank, 1)

    self.scroll_data_fri = fri
    self.scroll_friend = self:create_scroll_view( 7, 7, 175, 335, MagicTreeWin.SCROLL_FRI)
    self.panel_friend_rank:addChild( self.scroll_friend)

    -- 添加滚动条上下箭头
    local arrow_up = CCZXImage:imageWithFile(182, 332, -1, -1, UILH_COMMON.scrollbar_up)
    self.panel_friend_rank:addChild(arrow_up, 10)
    local arrow_down = CCZXImage:imageWithFile(182, 6, -1, -1, UILH_COMMON.scrollbar_down)
    self.panel_friend_rank:addChild(arrow_down, 10)

    self.panel_friend_rank:setIsVisible( false)
end

-- 创建scrollview
function MagicTreeWin:create_scroll_view( _x, _y, _w, _h, _type)
    self.cur_scroll_type = _type
    local item_w = 180
    local item_h = 60

    local _scroll_info = { x = _x, y = _y, width = _w, height = _h, maxnum = 1, image = "", stype= TYPE_HORIZONTAL }
    local scroll = CCScroll:scrollWithFile( _scroll_info.x, _scroll_info.y, _scroll_info.width, _scroll_info.height, _scroll_info.maxnum, _scroll_info.image, _scroll_info.stype )
    scroll:setScrollLump(UILH_COMMON.up_progress, UILH_COMMON.down_progress, 10, 30, 95 )


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
            -- 数据赋值
            local data = nil
            if MagicTreeWin.SCROLL_REC == self.cur_scroll_type then
                item_h = 70
                data = self.scroll_data_rec or {}
                -- print("---------------#self.scroll_data_rec:", self.scroll_data_rec)
            elseif MagicTreeWin.SCROLL_FRI == self.cur_scroll_type then
                item_h = 60
                data = self.scroll_data_fri or {}
                -- print("---------------#self.scroll_data_fri:", self.scroll_data_fri)
            end
            -- print("----------:", #data)
            local num_item = #data
            -- 创建item面板
            local bg_vertical = CCBasePanel:panelWithFile( 0, 0, item_w, item_h* num_item, "")
            for i = 1, num_item do
                local bg = self:create_scroll_item( 0, (num_item-i)*item_h, item_w, item_h, data[i], self.cur_scroll_type)
                bg_vertical:addChild(bg)
            end

            scroll:addItem(bg_vertical)
            scroll:refresh()
            return false
        end
    end
    scroll:registerScriptHandler(scrollfun)
    scroll:refresh()

    return scroll
end

-- 创建scrollview item
function MagicTreeWin:create_scroll_item(  _x, _y, _w, _h, _data, _type)
    local item = CCBasePanel:panelWithFile( _x, _y, _w, _h, "")

    if MagicTreeWin.SCROLL_REC == _type then
            -- 技能描述 ------------------------------------------------------------
        local rec_desc = CCDialogEx:dialogWithFile(10, 60, 165, 80, 10, "", TYPE_VERTICAL ,ADD_LIST_DIR_UP);
        rec_desc:setAnchorPoint(0,1);
        rec_desc:setFontSize(14);
        rec_desc:setText( _data.content );  -- "#cffff00当前效果:#cffffff:"
        rec_desc:setTag(0)
        rec_desc:setLineEmptySpace (0)
        item:addChild( rec_desc)
    elseif MagicTreeWin.SCROLL_FRI == _type then
        ZLabel:create( item, _data.name, 5, 15, 14)
        if _data.water_state == MagicTreeModel.RECEIVE_YES then
            local sign_rec = CCBasePanel:panelWithFile( 100, 10, -1, -1, UILH_MAGICTREE.rec_hand)
            item:addChild( sign_rec)
        end
        if _data.rec_state == MagicTreeModel.WATER_YES then
            local sign_water = CCBasePanel:panelWithFile( 135, 10, -1, -1, UILH_MAGICTREE.waters)
            item:addChild( sign_water)
        end

        -- 点击好友item 方法
        local function friend_func(eventType, arg, msgid, selfitem)
            if eventType == nil or arg == nil or msgid == nil or selfitem == nil then
                return
            end
            if eventType == TOUCH_BEGAN then
                print("--------friend_func")
                -- local player_id = EntityManager:get_player_avatar().id
                -- 点击效果 -- start
                local item_blink = CCBasePanel:panelWithFile( 0, 0, _w, _h, UILH_COMMON.select_focus, 500, 500)
                item:addChild( item_blink)
                local function cb_func()
                    if item_blink then
                        item_blink:removeFromParentAndCleanup(true)
                        item_blink = nil
                    end
                end 
                local cb_blink = callback:new()
                cb_blink:start(0.2, cb_func)
                -- 点击效果 --end

                MagicTreeCC:req_magictree_info( _data.id)
                return true
            elseif eventType == TOUCH_CLICK then
                return true;
            end
            return true;
        end
        item:registerScriptHandler( friend_func)  --注册
    end

    ZImage:create(item,UILH_COMMON.split_line, 5, 4, 320, 3)

    return item
end

-- 更新数据： 参数：更新的类型
function MagicTreeWin:update( update_type )
    -- 主界面信息
    if update_type == "main" then
        self:update_main_info( )
    elseif update_type == "fri_rec_log" then
        self.cur_scroll_type = MagicTreeWin.SCROLL_REC
        local fri_rec_log = MagicTreeModel:getFriendReceiveLog()
        self.scroll_rec:clear()
        self.scroll_data_rec = fri_rec_log
        self.scroll_rec:refresh()
    elseif update_type == "own_opr_log" then
        self.cur_scroll_type = MagicTreeWin.SCROLL_REC
        local own_opr_log = MagicTreeModel:getOwnOprLog()
        self.scroll_rec:clear()
        self.scroll_data_rec = own_opr_log
        self.scroll_rec:refresh()
    elseif update_type == "friend_lsit" then
        self.cur_scroll_type = MagicTreeWin.SCROLL_FRI
        local friendlist = MagicTreeModel:getFriendList()
        self.scroll_friend:clear()
        self.scroll_data_fri = friendlist
        self.scroll_friend:refresh()
    end
end

function MagicTreeWin:update_main_info( )
    -- 浇水倒计时
    local main_info = MagicTreeModel:get_main_info()
    if main_info.remaintime_water > 0 then
        if self.timer_water then
            self.timer_water:destroy(  )
            self.timer_water = nil
        end
        self.timer_water = TimerLabel:create_label( self.view, 250, 30, 16, main_info.remaintime_water, LH_COLOR[2], nil, nil, ALIGN_CENTER )
    else
        if self.timer_water then
            self.timer_water:destroy(  )
            self.timer_water = nil
        end
    end
    -- 成熟度
    -- local maturity_all = MagicTreeModel:get_maturity()
    self.cur_maturity = main_info.maturity
    self.process_bar_fix:setProgressValue( main_info.maturity, self.maturity_num )

    -- 如果成熟度满了，一键成熟按钮换位刷新按钮
    local all_maturity = MagicTreeConfig:get_magictree_maturity( )
    if self.cur_maturity == all_maturity then
        -- UILH_MAGICTREE.mt_freshtree
        self.mature_font:setTexture(UILH_MAGICTREE.mt_freshtree)
        self.flag_matured = true
    else
        self.mature_font:setTexture(UILH_MAGICTREE.mt_mature_once)
        self.flag_matured = false
    end

    -- 是否自己家
    local player_id = EntityManager:get_player_avatar().id
    if player_id == main_info.player_id then
        self.btn_own_tree.view:setIsVisible(false)
        self.btn_water.view:setPosition(195, 50)
        self.btn_mature_once.view:setIsVisible(true)
        self.btn_warehouse.view:setIsVisible(true)
        if self.timer_water then
            self.timer_water.panel.view:setPosition(250, 30)
        end
        self.name_master:setText( LH_COLOR[2] .. main_info.player_name)
    else
        self.btn_own_tree.view:setIsVisible(true)
        self.btn_water.view:setPosition(370, 50)
        self.btn_mature_once.view:setIsVisible(false)
        self.btn_warehouse.view:setIsVisible(false)
        if self.timer_water then
            self.timer_water.panel.view:setPosition(425, 30)
        end
        self.name_master:setText( LH_COLOR[2] .. main_info.player_name)
    end
    -- 显示果实
    self:clear_fruit( )
    local fruit_t = main_info.fruit_tabel
    local icon_path = "icon/item/"
    local fruit_pos = MagicTreeConfig:get_fruit_position()
    local img_t = { [1]=UILH_MAGICTREE.fruit_blue, [2]=UILH_MAGICTREE.fruit_gold, [3]=UILH_MAGICTREE.fruit_perple}

    for i=1, #fruit_t do
        -- local str_id = string.format( "%05d", fruit_t[i].id)
        local index = fruit_t[i].index

        local item_icon = ItemConfig:get_item_icon( fruit_t[i].id)

        --摘果子方法
        local function get_fruit_func(eventType, arg, msgid, selfitem)
            if eventType == nil or arg == nil or msgid == nil or selfitem == nil then
                return
            end
            if eventType == TOUCH_BEGAN then
                local function req_mature_once_func()
                    local player_id = MagicTreeModel:get_cur_player_id( )
                    MagicTreeCC:req_get_fruit( player_id, index)
                end
                local function switch_func( if_selected )
                    self.is_getfruit_tip = if_selected
                end
                if self.is_getfruit_tip == false then
                    local fruit_index = MagicTreeModel:get_fruit_index_by_item_id( fruit_t[i].id)
                    local cost_ybs = MagicTreeConfig:get_cost_for_fruit( fruit_index) 
                    local str = Lang.Magictree[12] .. cost_ybs 
                    ConfirmWin2:show( 1, nil, str, req_mature_once_func, switch_func)
                elseif self.is_getfruit_tip == true then
                    req_mature_once_func()
                end
                ------------------------
                return true
            elseif eventType == TOUCH_CLICK then
                return true;
            end
            return true;
        end

        self.ui_fruit_t[i] = CCBasePanel:panelWithFile( fruit_pos[index][1], fruit_pos[index][2], -1, -1, item_icon)
        self.view:addChild( self.ui_fruit_t[i])
        self.ui_fruit_t[i]:registerScriptHandler( get_fruit_func)
    end
end

-- 清除所有果实
function MagicTreeWin:clear_fruit( )
    if self.ui_fruit_t then
        for i=1, #self.ui_fruit_t do
            if self.ui_fruit_t[i] then
                self.ui_fruit_t[i]:removeFromParentAndCleanup(true)
                self.ui_fruit_t[i] = nil
            end
        end
    end
end

--
function MagicTreeWin:active( show )
    if show then
        local player_id = EntityManager:get_player_avatar().id
        MagicTreeCC:req_magictree_info( player_id)
    end
end



function MagicTreeWin:destroy()
    if self.timer_label then
        self.timer_label:destroy(  )
        self.timer_label = nil
    end
    if self.timer_water then
        self.timer_water:destroy(  )
        self.timer_water = nil
    end
    Window.destroy(self)
end
