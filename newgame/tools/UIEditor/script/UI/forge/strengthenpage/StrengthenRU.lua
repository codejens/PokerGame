-- StrengthenRU.lua
-- created by lyl on 2012-12-7
-- 炼器--强化装备页面中的右上侧面板
-- 左

super_class.StrengthenRU()


--item 的type，表示装备的号码。用于某件物品是否是装备判断
local _equi_num_t = { [1] = true, [2] = true, [3] = true, [4] = true,
                      [5] = true, [6] = true, [7] = true, [8] = true,
                      [9] = true, [10] = true, }


--记录右侧装备区，是背包还是人物状态.默认时人物
local _r_up_equi_or_bag = "equipment"

local font_size = 16
local color_yellow = "#cffff00"

----------------------------
----HJH 2014-9-22
----notic begin
----隐藏你的杀意，就算那代码写得不堪入目，就算你想操翻人家代码
----
---- _t_scroll_info 信息初始化在__init函数中
local _t_scroll_item_info = {}
----notic end
-----------------------------

function StrengthenRU:__init( pos_x, pos_y, width, height, texture_name , fath_object)

    self.fath_object = fath_object
    self.r_up_but_t = {}               -- 按钮做成单选用,需要操作所有按钮，设置状态
    self.show_item_panel_t = {}        -- 所有道具展示面板
    self.equip_scroll = nil

    _t_scroll_item_info.x = 10
    _t_scroll_item_info.y = 18
    _t_scroll_item_info.width = width - _t_scroll_item_info.x * 2
    _t_scroll_item_info.height = height - _t_scroll_item_info.y * 2
    _t_scroll_item_info.x_num = 2

    local panel = CCBasePanel:panelWithFile( pos_x, pos_y, width, height, texture_name, 500, 500 )

    --创建item; 默认显示角色中的装备
    self:create_char_slot_char( panel )

    self.view = panel
end

--创建人物中的装备slotitem
function StrengthenRU:create_char_slot_char( panel, x, y, width, height )
    -- 遍历玩家装备，变成item显示出来
    local slot_par = {}
    local user_equi_info = UserInfoModel:get_bag_equip_attack_head()        --所有装备信息
    local item_base = nil
    require "config/ItemConfig"
    for i, equip in ipairs(user_equi_info) do
       
        item_base = ItemConfig:get_item_by_id( equip.item_id )
        if item_base and _equi_num_t[ item_base.type ] and equip.strong < 15 then
            slot_par[ #slot_par + 1] = { equip.series }
        end
    end
    local scroll = self:create_scroll_area( slot_par, _t_scroll_item_info.x - 5, _t_scroll_item_info.y,
     _t_scroll_item_info.width, _t_scroll_item_info.height, _t_scroll_item_info.x_num, 4, nil)
    scroll:setScrollLump(UILH_COMMON.up_progress, UILH_COMMON.down_progress, 10, 18, 105)
    scroll:setScrollLumpPos(_t_scroll_item_info.width )
    panel:addChild( scroll )
    local _t_scrol_lump_down_img = ZImage:create( panel, UILH_COMMON.scrollbar_down, _t_scroll_item_info.x - 5 + _t_scroll_item_info.width ,
        _t_scroll_item_info.y - 5, -1, -1)
    local _t_scroll_lump_up_img = ZImage:create( panel, UILH_COMMON.scrollbar_up, _t_scroll_item_info.x - 5 + _t_scroll_item_info.width ,
        _t_scroll_item_info.y + _t_scroll_item_info.height-5, -1, -1)
    self.equip_scroll = scroll
    self.slot_par = slot_par
end

-- 默认选中第一个
function StrengthenRU:set_default_item(  )
    -- 默认选中第一个
    local slot_par = self.slot_par
    if not slot_par then
        return
    end
    if #slot_par > 0 then
        local item_panel = self.show_item_panel_t[slot_par[1][1]]
        if item_panel then
            item_panel.do_click()
        end
    end
end

--创建背包中的装备slotitem
function StrengthenRU:create_bag_slot_char( panel )
    -- local bag_items = ForgeModel:get_bag_equip_attack_head(  ) --背包中物品的集合和数量
    -- local equip = nil                                          --背包中存储的item数据，注意和基本item数据区分
    -- local item_base = nil                                      --基础item数据，用来回去改物品的公共属性

    -- require "config/ItemConfig"
    -- local slot_par = {}
    -- --遍历背包中的所有装备，创建出item显示出来
    -- for i = 1, #bag_items do
    --     equip = bag_items[i]
    --     --判断是否是装备
    --     if equip then
    --         item_base = ItemConfig:get_item_by_id( equip.item_id )
    --     end
    --     -- 在_equi_num_t中定义了所有装备的type的值对应为true
    --     if ( equip and _equi_num_t[ item_base.type ] and equip.strong < 15 )then  
    --         -- slot_par[ #slot_par + 1] = { panel, equip.item_id, 10, 10 , 55, 55, equip.strong, equip.series , equip.flag }
    --         slot_par[ #slot_par + 1] = { equip.series }
    --     end
    -- end

    -- -- local scroll = self:create_scroll_area( slot_par, _t_scroll_info.x, _t_scroll_info.y,
    -- --  _t_scroll_info.width, _t_scroll_info.height, 1, 4, nil)
    -- -- panel:addChild( scroll )
    -- -- self.equip_scroll = scroll

    -- -- 默认选中第一个
    -- if #slot_par > 0 then
    --     local item_panel = self.show_item_panel_t[slot_par[1][1]]
    --     if item_panel then
    --         item_panel.do_click()
    --     end
    -- end
end

-- 创建可拖动区域   参数：放入scroll的panel的集合, 坐标， 区域大小，列数， 背景名称
function StrengthenRU:create_scroll_area( panel_table_para ,pos_x, pos_y, size_w, size_h, colu_num, sight_num, bg_name)
    local row_num = math.ceil( #panel_table_para / colu_num )
    local _scroll_info = { 
        x = pos_x, 
        y = pos_y, 
        width = size_w, 
        height = size_h, 
        maxnum = row_num, 
        image = bg_name, 
        stype = TYPE_HORIZONTAL }
    --print("_scroll_info.maxnum,row_num,#panel_table_para,colu_num",_scroll_info.maxnum,row_num,#panel_table_para,colu_num)
    local scroll = CCScroll:scrollWithFile( _scroll_info.x, 
        _scroll_info.y, _scroll_info.width, 
        _scroll_info.height, 
        _scroll_info.maxnum, 
        _scroll_info.image, 
        _scroll_info.stype )

    local had_add_t = {}
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
            local index = x * colu_num 
            local row_h = 93
            local t_dis_y = 3
            local row_w = _t_scroll_item_info.width
            local bg_vertical = CCBasePanel:panelWithFile( 0, t_dis_y / 2, row_w, row_h, "" )
            local colu_with = 190
            local indent_x= 22   --缩进
            local space_x = ( _t_scroll_item_info.width - colu_with * 2 ) / 4    --列距
            for i = 1, colu_num do
                if panel_table_para[index + i] then
                    local bg = self:create_show_panel( panel_table_para[index + i], 
                        (i - 1) * colu_with + space_x * i, 0, 
                        colu_with, row_h )
                    bg_vertical:addChild(bg.view)
                else
                    local bg = CCBasePanel:panelWithFileS(CCPointMake(0,0),CCSizeMake(colu_with,row_h),nil)
                    bg_vertical:addChild(bg)
                end
            end

            local item = CCBasePanel:panelWithFile(0, 0, row_w, row_h + t_dis_y, "")
            item:addChild(bg_vertical)

            scroll:addItem(item)
            scroll:refresh()
            return false
        end
    end
    scroll:registerScriptHandler(scrollfun)
    scroll:refresh()

    return scroll
end

-- 创建一个包括tip的显示面板
function StrengthenRU:create_show_panel( panel_date, x, y, w, h  )
    local item_series = panel_date[1]

    if self.show_item_panel_t[item_series] then
        -- 设置品质特效 /hcl/on 2013/7/17-----------------------------------
        local item_date = ForgeModel:get_item_in_bag_or_body( item_series )
        local item_base = ItemConfig:get_item_by_id( item_date.item_id )
        local pj = ItemModel:get_item_pj( item_base )
        self.show_item_panel_t[item_series].slot_item:set_item_quality(item_date.void_bytes_tab[1],pj);
        -------------------------------------------------------------------------
        return self.show_item_panel_t[item_series]
    end
    local show_item_panel = {}
    local show_item_panel_bg = CCBasePanel:panelWithFile( x, y , w, h, UILH_COMMON.bg_10, 500, 500 )
    show_item_panel.view = show_item_panel_bg

    local slotItem = MUtils:create_one_slotItem( nil, 15, 20, 64, 64 )    --创建slotitem
    slotItem.view:setScale( 50 / 60 )
    show_item_panel.view:addChild( slotItem.view )

    local item_date = ForgeModel:get_item_in_bag_or_body( item_series )
    slotItem.set_date( item_date )
    local item_base = ItemConfig:get_item_by_id( item_date.item_id )
    local pj = ItemModel:get_item_pj( item_base )
    -- 设置品质特效
    slotItem:set_item_quality(item_date.void_bytes_tab[1],pj);

    -- 单击回调
    local function f1()
        ForgeModel:set_strengthen_item_series( item_series )
    end
    -- slotItem:set_double_click_event( f1 )

    -- 显示信息:名称和数字
    local strong_lable = nil
    if item_date then
        local item_name = ForgeModel:get_item_name_with_color( item_date.item_id )
        local name_lable = UILabel:create_lable_2( item_name, 75, 55, font_size, ALIGN_LEFT )
        show_item_panel.view:addChild( name_lable )
        
        strong_lable = UILabel:create_lable_2( LangGameString[1018]..item_date.strong, 75, 20, font_size, ALIGN_LEFT ) -- [1018]="#cffff00强化 +"
        show_item_panel.view:addChild( strong_lable ) 
    end

    local selected_bg = CCBasePanel:panelWithFile(0, 0, w, h, UILH_COMMON.slot_focus, 500, 500)
    show_item_panel.view:addChild(selected_bg)
    selected_bg:setIsVisible(false)
    show_item_panel.set_selected = function( show_flash )
        selected_bg:setIsVisible(show_flash)
    end

    -- 设置该道具为选中状态 
    show_item_panel.set_state = function( if_selected )
        if if_selected then
            -- slotItem:set_slot_disable(  )
            show_item_panel.set_selected(true)
        else
            -- slotItem:set_slot_enable(  )
            show_item_panel.set_selected(false)
        end
    end

    -- 如果和选中的装备是同一个，就设置道具为不可选状态
    if ForgeModel:check_is_strengthen_item( item_series ) then
        -- slotItem:set_slot_disable(  )
        show_item_panel.set_selected(true)
    end

    -- 重新更新数据
    show_item_panel.update_date = function(  )
        local item_date_temp = ForgeModel:get_item_in_bag_or_body( item_series )
        slotItem.set_date( item_date_temp )
        -- 选中状态
        if ForgeModel:check_is_strengthen_item( item_series ) then
            -- slotItem:set_slot_disable(  )
            show_item_panel.set_selected(true)
        end
        if item_date_temp then
            strong_lable:setString( LangGameString[1018]..item_date_temp.strong ) -- [1018]="#cffff00强化 +"
        end
    end

    local function f3( eventType )
        if eventType == TOUCH_CLICK then
            if not ForgeModel:check_is_strengthen_item( item_series ) then
                self:unselecte_all_item()
                show_item_panel.set_selected(true)
                f1()
            end
        end
    end
    local function f4( ... )
        if not ForgeModel:check_is_strengthen_item( item_series ) then
            self:unselecte_all_item()
            show_item_panel.set_selected(true)
            f1()
        end
    end
    slotItem:set_click_event(f4)
    show_item_panel.view:registerScriptHandler(f3)
    show_item_panel.do_click = f4
    show_item_panel.item_series = item_series
    show_item_panel.slot_item = slotItem;
    safe_retain(show_item_panel.view)
    self.show_item_panel_t[item_series] = show_item_panel
    return show_item_panel
end

function StrengthenRU:unselecte_all_item( ... )
    for k,show_item_panel in pairs(self.show_item_panel_t) do
        show_item_panel.set_selected(false)
    end
    ForgeModel:set_insert_item_series(nil)
end

-- -- 更新选中状态
function StrengthenRU:update_select_state(  )
    -- 必须先设置其他为有效装备
    for i, show_item_panel in pairs(self.show_item_panel_t) do 
        if ForgeModel:check_is_strengthen_item( show_item_panel.item_series ) then
            -- show_item_panel.set_state( true )
            show_item_panel.set_selected(true)
        else 
            -- show_item_panel.set_state( false )
            show_item_panel.set_selected(false)
        end
    end
end

--刷新装备面板的所有item.  参数：item的类型（人物或者背包）
function StrengthenRU:flash_all_item_r_up(  )
    self:remove_all_item()
-- print("==========StrengthenRU:flash_all_item_r_up=============")
    if "equipment" == _r_up_equi_or_bag then
        self:create_char_slot_char( self.view )
    elseif "bag" == _r_up_equi_or_bag then
        self:create_bag_slot_char( self.view )
    end
end

-- 更新道具数据
function StrengthenRU:update_all_item_date(  )
    for key, show_item_panel in pairs(self.show_item_panel_t) do 
        show_item_panel.update_date()
    end
end

--清空面板所有item:  参数：panel_name ：面板的名称
function StrengthenRU:remove_all_item()
    if self.equip_scroll then
        self.view:removeChild(self.equip_scroll, true) 
        self.equip_scroll = nil
    end
    for key, show_item_panel in pairs(self.show_item_panel_t) do 
        safe_release(show_item_panel.view)
    end
    self.show_item_panel_t = {}
end

-- 设置按钮状态（实现单选），参数：位置标记，按钮序列号
function StrengthenRU:but_select_one( place, index )
    local but_table = {}
    if place == "right_up" then
        but_table = self.r_up_but_t
    end
    for i, v in ipairs( but_table ) do
        v:setCurState( CLICK_STATE_DOWN )
    end
    if but_table[ index ] then
        but_table[ index ]:setCurState( CLICK_STATE_UP )
    end
end


function StrengthenRU:destroy()
    for key, show_item_panel in pairs(self.show_item_panel_t) do 
        safe_release(show_item_panel.view)
    end
    -- self:remove_all_item()
end



