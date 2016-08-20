-- MakeCardPage.lua
-- created by chj on 2015-4-23
-- 铸卡牌分页

super_class.MakeCardPage(Window)

require "../data/collectcard"

--美人卡牌数组
local meiren_pai = {
   [1] = UILH_LINGQI.pai1,
   [2] = UILH_LINGQI.pai2,
   [3] = UILH_LINGQI.pai3,
   [4] = UILH_LINGQI.pai4,
   [5] = UILH_LINGQI.pai5,
}

MakeCardPage.fenjie_tip_flag = false

--创建方法
function MakeCardPage:create( )
	return MakeCardPage( "MakeCardPage", "", true, 880, 500)
end

--初始化
function MakeCardPage:__init(window_name, texture_name, is_grid, width, height)
	local  bg_panel = self.view
    
    --背景底图
    -- self.panel_base = CCBasePanel:panelWithFile(8,0,865,500,"",500,500);
    -- self.view:addChild(self.panel_base);

    -- 选择的美人卡
    self._curr_selec_card = nil
    -- 展示
    self.card_sltd = nil

    -- 左面板
    self:create_left_panel()

    -- 右界面
    self:create_right_panel()
end

-- 创建左界面
function MakeCardPage:create_left_panel()
    self.panel_left = CCBasePanel:panelWithFile(5, 0, 540, 499, "")
    self.view:addChild( self.panel_left)

    self.panel_tab = CCBasePanel:panelWithFile( 3, 94, 115, 405, UILH_COMMON.bottom_bg, 500, 500)
    self.panel_left:addChild( self.panel_tab)

    -- 底部背景
    self.panel_bottom = CCBasePanel:panelWithFile( 3, 0, 535, 95, UILH_COMMON.bottom_bg, 500, 500)
    self.panel_left:addChild( self.panel_bottom)

    -- 左边面板tab按钮 2
    --这里应该使用配置来读取主目录和子目录
    self.card_info = {}
    self.cards = {}
    local item_data = {}

    --设置
    for i = 1, #collectcard.cardGroup do
        local card_data = collectcard.cardGroup[i]
        table.insert(self.card_info, card_data)
        local title = card_data.typeName
        local temp = { items = {} }
        temp[1] = title

        --获取子目录

        for i=1,#card_data.subList do
            local sub_card_id =  card_data.subList[i]
            local sub_data = collectcard.cardSubGroup[sub_card_id].typeName
            local item = {[1] = sub_data,[2]=""}
            table.insert(temp.items,item)

        end
        item_data[#item_data+1] = temp
    end

    local beg_y = 490
    local int_h = 45
    local ui_params = { title_h = 45, title_w = 115, item_h = 45, item_w = 100, title_x = -7, item_bg = UILH_COMMON.button6_4 }
    require "UI/fabao/LHDirectoryList"
    self.synthSpinner = LHDirectoryList:create( self.panel_left, item_data, ui_params, 0, 5, 100, 110, 390, ""
    , 500, 500 ) 

    for i, chapter in ipairs(self.card_info) do
        local title_item = CCBasePanel:panelWithFile( -10, beg_y - int_h*i, ui_params.title_w, -1, UILH_COMMON.button3_d, 500, 500)
        self.synthSpinner:addTitle(title_item, i)
    end

--主目录的触发事件
    local function spinner_title_func( title_index)
        self.selectIndex = title_index
        local series = HeLuoConfig.getBookSeriesTable(  )
        self.meiren_id_list = {}
        local series_array =series[title_index].subList
        for i=1,#series_array do
             local cardsubGroups = HeLuoConfig.getCardSubGroup( series_array[i] )
            for i=1,#cardsubGroups do
                local seriesGroup =  HeLuoConfig.getCardSeriesGroup( cardsubGroups[i] )
                for k=1,#seriesGroup do 
                     table.insert(self.meiren_id_list,seriesGroup[k])
                end  
            end
        end
        print("主目录的个数",#self.meiren_id_list)
        if self.right_scroll then
            HeLuoBooksCC:req_base_heluo_info( )
            self.right_scroll:clear()
            -- self.right_scroll:setMaxNum(math.ceil(#self.meiren_id_list/4))
            self.right_scroll:refresh()
        end

        -- 清除数据
        self:clear_selected()
    end
    self.synthSpinner:registerScriptFunc_t( spinner_title_func )
--子目录的触发事件
    local function spinner_item_func( title_index, item_index )
        self.sub_selectIndex = item_index
        -- print("子目录的触发事件",title_index,item_index)
        --系列
        local series = HeLuoConfig.getBookSeriesTable(  )
        self.meiren_id_list = {}
        local series_info =series[title_index].subList[item_index]
        local cardsubGroups = HeLuoConfig.getCardSubGroup( series_info )
        for i=1,#cardsubGroups do
            local seriesGroup =  HeLuoConfig.getCardSeriesGroup( cardsubGroups[i] )
            for k=1,#seriesGroup do 
                 table.insert(self.meiren_id_list,seriesGroup[k])
            end  
        end       

        if self.right_scroll then
            HeLuoBooksCC:req_base_heluo_info( )
            self.right_scroll:clear()
            -- self.right_scroll:setMaxNum(math.ceil(#self.meiren_id_list/4))
            self.right_scroll:refresh()
        end
        -- 清除选择数据
        self:clear_selected()
    end
    self.synthSpinner:registerScriptFunc_i( spinner_item_func)
    --默认选中第一个
    self.synthSpinner:slt_title_func(1)
    -- 目录 -------------------------------------------------------------------

    -- 卡牌面板
    self.panel_card = CCBasePanel:panelWithFile(120, 94, 418, 405, UILH_COMMON.bottom_bg, 500, 590)
    self.panel_left:addChild( self.panel_card)
    -- 创建scrollview
    local scroll_info = {x = 5, y = 5, width = 410, height = 395}
    self.right_scroll = self:create_scroll_area( self.panel_card, scroll_info.x, scroll_info.y, scroll_info.width, scroll_info.height, "", self.meiren_id_list)

    -- =============== 按钮们 ========================================
    -- 分解按钮1
    local function resolve_func()
        if self._curr_selec_card then
            local item_id = HeLuoConfig:get_itemid_by_cardindex( self._curr_selec_card.meiren_id )
            local jihuo = HeluoBooksModel:get_card_star_by_item_id( item_id)
            if jihuo then
                local item_count = ItemModel:get_item_count_by_id( item_id)
                if item_count == 0 then
                    GlobalFunc:create_screen_notic( Lang.MakeCard[1]);
                else
                    -- ================================================================
                    local function fenjie_card( ... )
                        local series_t = {}
                        -- 从背包获取物品序列号(同一物品)，可能多个
                        local item_serieses = HeluoBooksModel:get_card_series_by_id( item_id)
                        if #item_serieses > 0 then
                            -- 使用第一个
                            local item_date = ItemModel:get_item_in_bag_or_body( item_serieses[1] )
                            local _curr_card_series = {}
                            _curr_card_series[item_date.series] = true
                            --交换K-V
                            for k,v in pairs(_curr_card_series) do
                             series_t[#series_t + 1] = k
                            end
                            HeLuoBooksCC:req_fenjie_books( 1, self._curr_selec_card.meiren_id, series_t )
                        else
                            -- 其实上面已经提醒，此处再次处理有点累赘
                            GlobalFunc:create_screen_notic( Lang.MakeCard[1]);
                        end
                    end
                    local function switch_func( if_selected )
                        self.fenjie_tip_flag = if_selected
                    end
                    if self.fenjie_tip_flag == false then
                        local str = Lang.MakeCard[2]
                        ConfirmWin2:show( 1, nil, str, fenjie_card, switch_func)
                    elseif self.fenjie_tip_flag == true then
                        fenjie_card()
                    end
                    -- ================================================================
                        
                    --====================================
                end
            else
                GlobalFunc:create_screen_notic( Lang.MakeCard[3]); -- [1]="当前不能移动"
            end
        else
            GlobalFunc:create_screen_notic( Lang.MakeCard[4]); -- [1]="当前不能移动"
        end
    end
    self.btn_resolve = ZTextButton:create( self.panel_left, LH_COLOR[2] .. Lang.MakeCard[5], UILH_COMMON.lh_button_4_r, resolve_func, 40, 33, -1, -1, 1)

    -- 批量分解按钮2
    local function resolve_batch_func()
        if not self._curr_selec_card then
            GlobalFunc:create_screen_notic( Lang.MakeCard[6])
            return
        end
        local item_id = HeLuoConfig:get_itemid_by_cardindex( self._curr_selec_card.meiren_id )
        local max_count = ItemModel:get_item_count_by_id(item_id)
        if max_count == 0 then
            GlobalFunc:create_screen_notic( Lang.MakeCard[7])
            return
        end
        -- 批量使用回调函数
        local function batch_use_fun(num)        

            local card_id = HeLuoConfig.getDecomposeIDByItemID( self._curr_selec_card.meiren_id)
            

            local item_id = HeLuoConfig:get_itemid_by_cardindex( self._curr_selec_card.meiren_id )
            local item_serieses = HeluoBooksModel:get_card_series_by_id( item_id)
            local bag_count_t = {}
            for i=1, #item_serieses do
                bag_count_t[i]= ItemModel:get_item_count_by_series( item_serieses[i])
                -- print("--------item_count:", bag_count_t[i])
            end

            local num_temp = num 
            for i=1, #item_serieses do
                local series_t = {}
                local item_date = ItemModel:get_item_in_bag_or_body( item_serieses[i] )
                local _curr_card_series = {}
                _curr_card_series[item_date.series] = true
                --交换K-V
                for k,v in pairs(_curr_card_series) do
                    series_t[#series_t + 1] = k
                end

                if num_temp < bag_count_t[i] then
                    HeLuoBooksCC:req_fenjie_books( num_temp, self._curr_selec_card.meiren_id, series_t )
                    break
                else
                    HeLuoBooksCC:req_fenjie_books( bag_count_t[i], self._curr_selec_card.meiren_id, series_t )
                    num_temp = num_temp - bag_count_t[i]
                end
            end



            -- local item_date = ItemModel:get_item_in_bag_or_body( item_serieses[1] )
            -- local _curr_card_series = {}
            -- _curr_card_series[item_date.series] = true
            -- --交换K-V
            --  for k,v in pairs(_curr_card_series) do
            --      series_t[#series_t + 1] = k
            --  end

            -- local max_count = ItemModel:get_item_count_by_id(item_id)
            -- if max_count <= num then
            --     item_id = nil
            --     -- self.fenjie_card:clearCard()
            -- end
            -- HeLuoBooksCC:req_fenjie_books( num, self._curr_selec_card.meiren_id, series_t )
        end
        local item_id = HeLuoConfig:get_itemid_by_cardindex( self._curr_selec_card.meiren_id )
        local item_count = ItemModel:get_item_count_by_id( item_id)
        BuyKeyboardWin:show(item_id, batch_use_fun, 14, item_count, { Lang.MakeCard[8]} ) 
    end
    self.btn_resolve_batch = ZTextButton:create( self.panel_left, LH_COLOR[2] .. Lang.MakeCard[9], UILH_COMMON.lh_button_4_r, resolve_batch_func, 210, 33, -1, -1, 1)

    -- 兑换按钮3
    local function exchange_func()
        UIManager:show_window("meiren_exchange_win")
    end
    self.btn_exchage = ZTextButton:create( self.panel_left, LH_COLOR[2] .. Lang.MakeCard[10], UILH_COMMON.btn4_nor, exchange_func, 370, 33, -1, -1, 1)

    -- 月神碎片
    ZLabel:create( self.panel_left, LH_COLOR[1] .. Lang.MakeCard[11], 305, 15, 14, ALIGN_RIGHT)
    self.yueshen_split = ZLabel:create( self.panel_left, LH_COLOR[2] .. "999999999", 305, 15, 14, ALIGN_LEFT)
end


-- 创建可拖动区域 
--list_data 为美人的配置数据ID    //cardConfig          
function MakeCardPage:create_scroll_area( panel, pos_x, pos_y, size_w, size_h, bg_name, list_date)
    -- ui param
    local row_h = 200
    local row_w = 135
    local row_inter_h = 15
    local colu_num = 3 --一行中列数
    local item_num = #self.meiren_id_list
    local line_num = math.ceil(item_num/colu_num)   --行数

    --总行数，每列的最大值
    local _scroll_info = { x = pos_x, y = pos_y, width = size_w, height = size_h, maxnum =1, image = bg_name, stype= TYPE_HORIZONTAL }
    local  scroll  = CCScroll:scrollWithFile( _scroll_info.x, _scroll_info.y, _scroll_info.width, _scroll_info.height, _scroll_info.maxnum, _scroll_info.image, _scroll_info.stype, 500, 500 )
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
            local index = x * colu_num    
            -- local panel_items = CCBasePanel:panelWithFile( 0, 0, size_w-5, row_h, "" )
            -- scroll:addItem(panel_items)

            -- 创建一个大面板
            local panel_scroll = CCBasePanel:panelWithFile( 0, 0, 175, row_h*line_num, "")
            scroll:addItem( panel_scroll)

            for i=1, item_num do
                local num_l = math.ceil(i/colu_num)   --第n行数
                local num_z, num_yu  = math.modf(i/colu_num)   --行数
                local flag_x = 0
                -- if num_yu == 0 then
                    flag_x = i - (num_l-1)*colu_num
                -- end
                print("---flag_x", num_l, flag_x)
                -- self:create_meiren_item( panel_scroll, 3+(i-1)*(row_w), 10, row_w, row_h, self.meiren_id_list[index+i])
                self:create_meiren_item( panel_scroll, 5+(flag_x-1)*(row_w), 10+(line_num-num_l)*row_h, row_w, row_h, self.meiren_id_list[index+i])
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

-- 创建一张美人卡
function  MakeCardPage:create_meiren_item( panel, x, y, w, h, meiren_id, flag_stove )
    print("美人卡牌信息数据 meiren_id",meiren_id)
    if meiren_id then
        local meiren_item = {}
        local card_data = HeLuoConfig.getCardConfig( meiren_id )             -- 卡牌静态数据
        --创建比请求返回的数据早，这里starNum未拿到值  在update时再次赋值
        local starNum = HeluoBooksModel:get_card_star_by_id( card_data.id )      -- 卡牌动态数据
        local item = ItemModel:get_item_info_by_id( card_data.itemId)         -- 卡牌物品数据
        local series = item and item.series
        meiren_item.card_data =card_data
        meiren_item.starNum =starNum
        meiren_item.item =item
        meiren_item.series =series
        meiren_item.meiren_id = meiren_id
        meiren_item.bag_itemId = card_data.itemId

        --美人卡牌图片
        local resPath = string.format( "%s%s.png","ui/lh_lingqi_hg/", string.format("kapai_%04d",card_data.id))
        meiren_item.meiren = CCBasePanel:panelWithFile(x, y, 166*0.97, 221*0.97, resPath )
        meiren_item.meiren:setScale(0.76)
        panel:addChild(meiren_item.meiren)
        meiren_item.bg = meiren_item.meiren
        meiren_item.bg:setEnableDoubleClick(true)

        -- 背景框
        self.meiren_item_gb = CCBasePanel:panelWithFile( -5, -9, -1, -1, meiren_pai[card_data.quality], 500, 500 )
        meiren_item.bg:addChild( self.meiren_item_gb )

        --美人名字    
        local name_color = ItemModel:get_item_color( card_data.itemId )
        local item_base = ItemConfig:get_item_by_id( card_data.itemId )
        if item_base == nil then
            return 
        end

        local index_table  = string.find(item_base.name,"·")
        index_table = index_table+2
        local name =  string.sub(item_base.name,index_table,#item_base.name)
        -- local name = string.sub(item_base.name, 11,#item_base.name) --手动减去前面星级
        meiren_item.name = ZLabel:create(meiren_item.bg, name_color..name, 84, 222, 14, 2)
        -- -- 选中标志
        meiren_item.frame_sld = CCZXImage:imageWithFile( -3, -10, w, h, UILH_COMMON.slot_focus, 500, 500 )
        meiren_item.frame_sld:setScale(1.31)
        meiren_item.bg:addChild(meiren_item.frame_sld)
        meiren_item.frame_sld:setIsVisible(false)

        --激活状态
        local item = ItemModel:get_item_info_by_id(card_data.itemId)
        local series = item  and item.series

        local jihuo = HeluoBooksModel:get_card_star_by_item_id( card_data.itemId)
        if jihuo then
            meiren_item.status_img =  CCZXImage:imageWithFile( 18, 17, -1,-1, UILH_LINGQI.had_active, 500, 500 )
        else
            meiren_item.status_img =  CCZXImage:imageWithFile( 18, 17, -1,-1, UILH_LINGQI.no_active, 500, 500 )
            if series then
                meiren_item.status_img:setTexture(UILH_LINGQI.can_active)
            end
        end

        meiren_item.bg:addChild(meiren_item.status_img)
        -- 副本item事件 ------------------------------------------------------
        local function meiren_item_func(eventType, arg, msgid, selfitem)
            if eventType == nil or arg == nil or msgid == nil or selfitem == nil then
                return
            end
            if eventType == TOUCH_BEGAN then
                return true
            elseif eventType == TOUCH_CLICK then
                --显示tip
                if card_data then


                    -- 选中框处理
                    if not flag_stove then
                        for i=1,#self.cards do
                            self.cards[i].frame_sld:setIsVisible(false)
                        end
                        meiren_item.frame_sld:setIsVisible(true)
                        --当前的卡牌
                        self._curr_selec_card = meiren_item

                        -- 删除当前选择的卡片
                        if self.card_sltd then
                            self.card_sltd.meiren:removeFromParentAndCleanup(true)
                            self.card_sltd = nil
                        end
                        self.card_sltd = self:create_meiren_item( self.panel_right, 100, 190, -1, -1, meiren_id, true)
                    end
                end
                return true;
            elseif eventType == TOUCH_DOUBLE_CLICK then
                if card_data then
                                        -- print("美人卡牌信息数据 meiren_id",meiren_id)
                    local starNum = HeluoBooksModel:get_card_star_by_id( card_data.id ) 
                    -- print("starNum",starNum)
                    local click_pos = Utils:Split(arg, ":")
                    local start_x = click_pos[1];
                    local start_y = click_pos[2];
                    -- 选中
                    local attr = HeluoBooksModel:getCardAttrs( card_data )
                    local data = HeluoBooksModel:get_tips_attr_data( attr)
                    data.attr = attr
                    data.card_data = card_data
                    TipsModel:show_meiren_tip( start_x + 100, 200, data ) 
                end
            end
            return true;
        end
        meiren_item.bg:registerScriptHandler( meiren_item_func )  --注册 -------------
        if not flag_stove then
            self.cards[meiren_id] = meiren_item

        end

        --价格，星级，状态，数量
        -- 代币（月神碎片）
        local cost_val = HeLuoConfig.getDuihuanConfig(meiren_id).value
        meiren_item.cost_daibi = ZLabel:create( meiren_item.meiren, LH_COLOR[1] .. cost_val, 10, 200, 16, ALIGN_LEFT)

        -- 数量
        local item_count = ItemModel:get_item_count_by_id( card_data.itemId)
        meiren_item.count = ZLabel:create( meiren_item.meiren, LH_COLOR[1] .. item_count, 150, 10, 16, ALIGN_RIGHT)
        return meiren_item
    end
end

-- 右界面(炉子) ====================================
function MakeCardPage:create_right_panel( )
    -- 背景面板
    self.panel_right = CCBasePanel:panelWithFile( 543, 0, -1, -1, "nopack/BigImage/heating_stove.png")
    self.view:addChild( self.panel_right)

    -- tip
    self.tip_txt = CCDialogEx:dialogWithFile(35, 450, 255, 80, 10, "", TYPE_VERTICAL ,ADD_LIST_DIR_UP);
    self.tip_txt:setAnchorPoint(0,1);
    self.tip_txt:setFontSize(14);
    self.tip_txt:setText( LH_COLOR[1] .. "选择美人卡片进行分解，获得经验，经验可用于美人卡片的升星（卡片未激活不可分解）".. LH_COLOR[15] );  -- "#cffff00当前效果:#cffffff:"
    self.tip_txt:setTag(0)
    self.tip_txt:setLineEmptySpace (5)
    self.panel_right:addChild(self.tip_txt)
    -- 炉子
    -- self.stove = CCBasePanel:panelWithFile( 5, 5, 315, 485, "nopack/BigImage/heating_stove.png")
    -- self.panel_right:addChild( self.stove)

    -- 选择卡牌
    -- self.card_sltd = MakeCardPage:create_meiren_item( self.stove, 20, 20, -1, -1, 7 , true)

    -- 升星按钮
    local function update_star_func( )
        if not self._curr_selec_card then
            GlobalFunc:create_screen_notic( Lang.MakeCard[12])
            return
        end
        HeLuoBooksCC:req_update_one_book( 1, self.card_sltd.meiren_id)
    end
    self.btn_updateStar = ZTextButton:create( self.panel_right, LH_COLOR[3] .. Lang.MakeCard[14], UILH_MAGICTREE.mt_btn, update_star_func, 125, 65, -1, -1, 1)

    -- 当前卡片经验
    ZLabel:create( self.panel_right, LH_COLOR[1] .. Lang.MakeCard[13], 180, 20, 14, ALIGN_RIGHT)
    self.card_exp = ZLabel:create( self.panel_right, LH_COLOR[2] .. HeluoBooksModel.jingyan, 190, 20, 14, ALIGN_LEFT)
end

-- 生成星星
function MakeCardPage:create_star_by_num( panel, num)

    local panel_star = CCBasePanel:panelWithFile( 0, 0, 25, 185, "")
    panel:addChild( panel_star)
    if num == 0 then
        return panel_star
    end
    for i=1, num do
        local img_star = CCBasePanel:panelWithFile(0, 185-i*20, -1, -1, UILH_NORMAL.star)
        img_star:setScale(0.4)
        panel_star:addChild( img_star)
    end
    return panel_star
end

--  清除选择的数据
function MakeCardPage:clear_selected( )
    if self._curr_selec_card then
        self._curr_selec_card = nil
    end
    -- 右边展示展示
    if self.card_sltd then
        self.card_sltd.meiren:removeFromParentAndCleanup(true)
        self.card_sltd = nil
    end
end

-- 进入界面触发函数
function MakeCardPage:active( show)
    if show then
        HeLuoBooksCC:req_base_heluo_info( )
    end
end

--刷新方法
function MakeCardPage:update( update_type )
    if update_type == "all" then
        self:update_all()
    elseif update_type == "jingyan" then
        self.card_exp:setText( HeluoBooksModel.jingyan)
    elseif update_type == "daibi" then
        self.yueshen_split:setText( HeluoBooksModel.meiren_po_data.yu)
    end
end

function MakeCardPage:update_all( )
    for id, star in pairs( HeluoBooksModel.cards_date) do
        -- self.cards[id].frame_sld:setIsVisible(false)
        --在创建的时候还没拿到值 现在赋值
        if self.cards[id] then
            self.cards[id].starNum = star
            self.cards[id].status_img:setTexture(UILH_LINGQI.had_active)
            self.cards[id].status_img:setSize(142,134)

            -- 星
            if self.cards[id].panel_star then
                self.cards[id].panel_star:removeFromParentAndCleanup(true)
                self.cards[id].panel_star = nil
            end
            local num_star = HeluoBooksModel:get_card_star_by_id( self.cards[id].meiren_id )
            if num_star then
                -- self.cards[id].num_star = ZLabel:create( self.cards[id].meiren, LH_COLOR[1] .. num_star, 150, 200, 16, ALIGN_RIGHT)
                local num_exc = tonumber(num_star)
                print(num_exc> 0)
                if num_exc > 0 then
                    self.cards[id].panel_star = self:create_star_by_num( self.cards[id].meiren, num_exc-1)
                    self.cards[id].panel_star:setPosition( 130, 50)
                end
            end
        end
    end
end

function MakeCardPage:update_card_panel( update_type)

    if update_type == "all" then
        self:update_all()
    elseif update_type == "jingyan" then
        self.card_exp:setText( HeluoBooksModel.jingyan)
    elseif update_type == "daibi" then
        self.yueshen_split:setText( HeluoBooksModel.meiren_po_data[1])
    elseif update_type == "card_num" then
        local item_num = #self.meiren_id_list
        for i=1, item_num do
            local item_count = ItemModel:get_item_count_by_id( self.cards[i].bag_itemId)
            self.cards[i].count:setText( LH_COLOR[2] .. item_count)
        end
    end
end



function MakeCardPage:destroy(  )
    Window.destroy(self);
end
