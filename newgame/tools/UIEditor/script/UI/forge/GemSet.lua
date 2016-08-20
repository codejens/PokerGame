-- GemSet.lua
-- created by lyl on 2012-12-13
-- 炼器--宝石镶嵌面板
-- 附灵

super_class.GemSet(Window)


local _left_slotitem_equi = nil       --左侧的装备item，保存起来，动态修改
local _left_slotitem_gem_atta = nil   --左侧的宝石item，保存起来，动态修改
local _left_slotitem_gem_prot= nil    --中间的宝石item，保存起来，动态修改
local _left_slotitem_gem_life = nil   --右侧的宝石item，保存起来，动态修改

local _left_gem_attr_but = nil        --攻击，原有宝石，下面会有摘除按钮，也需要动态修改
local _left_gem_prot_but = nil        --防御，原有宝石，下面会有摘除按钮，也需要动态修改
local _left_gem_life_but = nil        --生命，原有宝石，下面会有摘除按钮，也需要动态修改

local _is_upgrade_gem = false -- 当前是升级宝石状态还是镶嵌宝石状态

local font_size = 16
local color_yellow = "#cffff00"
local color_green = "#c66ff66"
local color_red = "#cFC5100"
local color_purple = "#ce5e9cb"
local _retain_panels = {}
--item 的type，表示装备的号码。用于某件物品是否是装备判断
local _equi_num_t = { [1] = true, [2] = true, [3] = true, [4] = true,
                      [5] = true, [6] = true, [7] = true, [8] = true,
                      [9] = true, [10] = true }

--记录左侧装备区，是背包还是人物状态.默认是人物
local _r_up_equi_or_bag = "equipment"
local _tself = nil
function GemSet:__init(  )
    self.panel_t = {}                  --存储panel的表。用于改变panel内容
    self.label_t = {}                  --存储label的表。用于改变label显示的内容
    self.r_up_all_item_t = {}          --存储左侧部分的所有item。用于清空处理
    self.r_down_all_item_t = {}        --存储右侧下部分的所有item。用于清空处理
    self.r_up_scroll = nil
    self.r_down_scroll = nil
    self.r_up_but_t = {}               -- 按钮做成单选用,需要操作所有按钮，设置状态
    self.gem_slotitem_t = {}
    self.selected_equip = nil
    self.meta_preview_item_t = {}

    -- 三种宝石是否已经镶嵌
    self._is_atta_ins = false
    self._is_prot_ins = false
    self._is_life_ins = false

    -- 创建一个大底板
    -- local bg_panel = CCBasePanel:panelWithFile( 0, -3, 880, 500, UIPIC_COMMOM_006, 500, 500 )        
    -- self.view:addChild(bg_panel)
    --右面板
    local right_bg_panel = CCBasePanel:panelWithFile( 428, 10, 430, 488, UILH_COMMON.bottom_bg, 500, 500 )    
    --左底板
    -- local panel1 = CCBasePanel:panelWithFile( 429, 3, 216, 487, UILH_FORGE.bg, 500, 500 ) 
    --对称的右底板
    -- local panel2 = CCBasePanel:panelWithFile(428.5 + panel1:getSize().width, 3, 214, 487, UILH_FORGE.bg, 500, 500 ) 
    -- panel2:setFlipX(true)  
    self.view:addChild(right_bg_panel)
    -- self.view:addChild(panel1)
    -- self.view:addChild(panel2)

    --右下面板
    local down_bg_panel = CCBasePanel:panelWithFile( 432, 18, 420, 160, UILH_COMMON.bg_10, 500, 500 )        
    self.view:addChild(down_bg_panel)

	-- 创建个区域的面板
    self.view:addChild( self:create_equip_panel( 10, 10, 420, 488, UILH_COMMON.bottom_bg ) )   --装备区
    self.view:addChild( self:create_forge_panel( 433, 194, 433, 306 ) )             --锻造区
    self.view:addChild( self:create_meta_panel( 433, 3, 433, 193 )  )    --材料去

    self.lastValue = {}
    self.lastGemProp = { [1] = {} , [2] = {}, [3] = {} , [4] = {} }
    _tself = self
end

function GemSet:update( update_type )
    if update_type == "bag_change" then
        self:update_insert_item(  )
        self:udpate_gem_atta(  )
        self:udpate_gem_prot(  )
        self:udpate_gem_life(  )
        self:update_all_item_date_up(  )
        self:update_all_item_date_down(  )
    elseif update_type == "bag_add" or update_type == "bag_remove" then
        self:update_insert_item(  )
        self:udpate_gem_atta(  )
        self:udpate_gem_prot(  )
        self:udpate_gem_life(  )
        self:reflash_all_item_r_up( _r_up_equi_or_bag )
        self:reflash_all_item_r_down(  )
    elseif update_type == "insert_item_series" then
        self:update_insert_item(  )
        self:update_select_state_up(  )
    elseif update_type == "insert_atta_series" then
        self:udpate_gem_atta(  )
        self:update_select_state_down(  )
    elseif update_type == "insert_prot_series" then
        self:udpate_gem_prot(  )
        self:update_select_state_down(  )
    elseif update_type == "insert_life_series" then
        self:udpate_gem_life(  )
        self:update_select_state_down(  )
    elseif update_type == "all" then
        LuaEffectManager:stop_view_effect( 11008,self.view)
        ForgeModel:set_insert_item_series( nil )            -- 每次打开都清空选中道具
        self:set_default_item()
        self:update_insert_item(  )
        self:udpate_gem_atta(  )
        self:udpate_gem_prot(  )
        self:udpate_gem_life(  )
        -- self:reflash_all_item_r_up( _r_up_equi_or_bag )
        self:reflash_all_item_r_down(  )
    end 
end

--================================================================================================================================
--================================================================================================================================
--
--装备区
--
--================================================================================================================================
--================================================================================================================================
---创建装备区
---创建装备区
function GemSet:create_equip_panel( pos_x, pos_y, width, height, texture_name )

    local panel = CCBasePanel:panelWithFile( pos_x, pos_y, width, height, texture_name, 500, 500 )

    --创建item; 默认显示角色中的装备
    self:create_char_slot_char( panel )
  
    -- self:but_select_one( "right_up", 1 )            -- 设置当前选择按钮(单选实现)
    self.panel_t["right_equi_panel"] = panel              --存入table，用于动态修改
    return panel
end

-- 设置按钮状态（实现单选），参数：位置标记，按钮序列号
-- function GemSet:but_select_one( place, index )
--     local but_table = {}
--     if place == "right_up" then
--         but_table = self.r_up_but_t
--     end
--     for i, v in ipairs( but_table ) do
--         v:setCurState( CLICK_STATE_DOWN )
--     end
--     if but_table[ index ] then
--         but_table[ index ]:setCurState( CLICK_STATE_UP )
--     end
-- end

-- 创建一个包括tip的显示面板
function GemSet:create_show_panel( panel_date, x, y, w, h )
    local item_series = panel_date[1]
    if self.r_up_all_item_t[item_series] then
        local item_date = ForgeModel:get_item_in_bag_or_body( item_series )
        local item_base = ItemConfig:get_item_by_id( item_date.item_id )
        local pj = ItemModel:get_item_pj( item_base )
        self.r_up_all_item_t[item_series].slot_item:set_item_quality(item_date.void_bytes_tab[1],pj);

        return self.r_up_all_item_t[item_series]
    end

    if self.r_down_all_item_t[item_series] then
        return self.r_down_all_item_t[item_series]
    end

    local panel_if_equip = ForgeModel:check_if_equip_by_series( item_series )    --判断传入的是装备还是宝石
    local image_bg = panel_if_equip and UILH_COMMON.bg_10 or ""
    local show_item_panel = {}
    local item_panel_bg1 = CCBasePanel:panelWithFile(x, y, w, h, image_bg, 500, 500)
    show_item_panel.view = item_panel_bg1
    if not panel_if_equip then
        local line = ZImage:create(show_item_panel.view, UILH_COMMON.split_line, 10, 0, w-15, 3, 500, 500)
    end
    local slotItem = MUtils:create_one_slotItem( nil, 15, (h-54)/2, 54, 54)              --创建slotitem
    show_item_panel.view:addChild( slotItem.view )

    local item_date = ForgeModel:get_item_in_bag_or_body( item_series )
    local item_base = ItemConfig:get_item_by_id( item_date.item_id )
    local pj = ItemModel:get_item_pj( item_base )
    slotItem.set_date( item_date )
    -- 设置品质特效
    slotItem:set_item_quality(item_date.void_bytes_tab[1],pj);

    -- 双击回调
    local function f1()
        ForgeModel:insert_select_item( item_series )
    end
    slotItem:set_double_click_event( f1 )

    local function f2( ... )
        local a, b, arg = ...
        local position = Utils:Split(arg,":");
            -- 将相对坐标转化成屏幕坐标(即OpenGL坐标 800x480)
        local pos = slotItem.view:getParent():convertToWorldSpace( CCPointMake(position[1],position[2]) );
        if slotItem.item_date then
            ForgeModel:show_tips_by_series( slotItem.item_date.series, pos.x, pos.y )
        end
    end
    -- slotItem:set_click_event( f2 )
    slotItem:set_click_event( f1 )

    -- 如果和选中的装备是同一个，就设置道具为不可选状态
    if ForgeModel:check_insert_item_selected( item_series ) then
        slotItem:set_slot_disable(  )
    end

    --显示信息:名称和数字
    local attr_lable = nil           -- 在这里定义，更行数据的时候需要修改它的值
    if item_date then
        local item_name = ForgeModel:get_item_name_with_color( item_date.item_id )
        local name_lable = UILabel:create_lable_2( item_name, 75, 55, panel_if_equip and font_size or 14)
        show_item_panel.view:addChild( name_lable )
        
        if panel_if_equip then       -- 装备
            local total_gem = ForgeModel:equip_gem_add_up( item_series )
            attr_lable = UILabel:create_lable_2( Lang.forge.gem_set[4]..total_gem.."/3", 75, 20, font_size ) -- [4]="#cffff00镶嵌 "
            show_item_panel.view:addChild( attr_lable ) 
        else
            attr_lable = UILabel:create_lable_2( Lang.forge.gem_set[5]..item_date.count, 75, 20, font_size ) -- [5]="#cffff00数量:"
            show_item_panel.view:addChild( attr_lable ) 
        end
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
            slotItem:set_slot_disable(  )
            show_item_panel.set_selected(true)
        else
            slotItem:set_slot_enable(  )
            show_item_panel.set_selected(false)
        end
    end

    -- 重新更新数据
    show_item_panel.update_date = function(  )
        local item_date_temp = ForgeModel:get_item_in_bag_or_body( item_series )
        slotItem.set_date( item_date_temp )
        -- 选中状态
        if ForgeModel:check_insert_item_selected( show_item_panel.item_series ) then
            slotItem:set_slot_disable(  )
            show_item_panel.set_selected(true)
        end
        if item_date_temp then
            if panel_if_equip then       -- 装备
                local total_gem = ForgeModel:equip_gem_add_up( item_series )
                attr_lable:setString( Lang.forge.gem_set[4]..total_gem.."/3" ) -- [4]="#cffff00镶嵌 "
            else
                attr_lable:setString( Lang.forge.gem_set[5]..item_date_temp.count ) -- [5]="#cffff00数量:"
            end
        end
    end

     -- 如果和选中的装备是同一个，就设置道具为不可选状态
    if ForgeModel:check_insert_item_selected( item_series ) then
        -- slotItem:set_slot_disable(  )
        show_item_panel.set_selected(true)
    end
    show_item_panel.item_series = item_series
    show_item_panel.slot_item = slotItem;
    show_item_panel.view:retain()

    if item_date and panel_if_equip then
        local function f3(eventType)
            if eventType == TOUCH_CLICK then
                if not ForgeModel:check_insert_item_selected( show_item_panel.item_series ) then
                    self:unselecte_all_item()
                    show_item_panel.set_selected(true)
                    f1()
                end
            end
        end
        local function f4( ... )
            if not ForgeModel:check_insert_item_selected( item_series ) then
                self:unselecte_all_item()
                show_item_panel.set_selected(true)
                f1()
            end
        end
        show_item_panel.do_click = f4
        show_item_panel.view:registerScriptHandler(f3)
        self.r_up_all_item_t[item_series] = show_item_panel
    else
        local function f4(eventType)
            if eventType == TOUCH_CLICK then
                f1()
            end
        end
        show_item_panel.view:registerScriptHandler(f4)
        self.r_down_all_item_t[item_series] = show_item_panel
    end

    return show_item_panel
end

function GemSet:unselecte_all_item( ... )
    for k,show_item_panel in pairs(self.r_up_all_item_t) do
        show_item_panel.set_selected(false)
    end
end

--创建人物中的装备slotitem
function GemSet:create_char_slot_char( panel )
    --遍历玩家装备，变成item显示出来
    local slot_par = {}
    local user_equi_info = UserInfoModel:get_equi_info()        --所有装备信息
    local equip = nil
    local item_base = nil
    for i = 1, #user_equi_info do
        equip = user_equi_info[i]
        require "config/ItemConfig"
        item_base = ItemConfig:get_item_by_id( equip.item_id )
        if item_base and _equi_num_t[ item_base.type ] and item_base.flags.hasHole then 
            slot_par[ #slot_par + 1] = { equip.series }
        end
    end
    local scroll = self:create_scroll_area( slot_par, 5, 18, 400, 452, 2, 5, nil, true)
    scroll:setScrollLump(UILH_COMMON.up_progress, UILH_COMMON.down_progress, 10, 18, 480 )
    scroll:setScrollLumpPos(400)
    local arrow_up = CCZXImage:imageWithFile(405, 465, 10, -1 , UILH_COMMON.scrollbar_up, 500, 500)
    local arrow_down = CCZXImage:imageWithFile(405, 8, 10, -1, UILH_COMMON.scrollbar_down, 500 , 500)
    panel:addChild( scroll )
    panel:addChild(arrow_up)
    panel:addChild(arrow_down)
    self.r_up_scroll = scroll
    self.slot_par = slot_par
end

--创建背包中的装备slotitem
function GemSet:create_bag_slot_char( panel )
    local bag_items, bag_item_count = ItemModel:get_bag_data() --背包中物品的集合和数量
    local equip = nil         --背包中存储的item数据，注意和基本item数据区分
    local place_index = 1     --这里物品不是每个都显示的，要判断（类型，和是否合适装备使用），所以位置要分开计数
    local item_base = nil     --基础item数据，用来回去改物品的公共属性

    require "config/ItemConfig"
    local slot_par = {}
    --遍历背包中的所有装备，创建出item显示出来
    for i = 1, bag_item_count do
        equip = bag_items[i]
        if equip then
            item_base = ItemConfig:get_item_by_id( equip.item_id )
        end
        --判断是否是装备
        -- 在_equi_num_t中定义了所有装备的type的值对应为true
        if ( equip and item_base and _equi_num_t[ item_base.type ]  and item_base.flags.hasHole )then  
            slot_par[ #slot_par + 1] = { equip.series }
        end
    end

    local scroll = self:create_scroll_area( slot_par, 5, 5, 415, 487, 2, 5, nil, true)
    local arrow_up = CCZXImage:imageWithFile(407, 474, 11, -1 , UILH_COMMON.scrollbar_up, 500, 500)
    local arrow_down = CCZXImage:imageWithFile(407, 5, 11, -1, UILH_COMMON.scrollbar_down, 500 , 500)
    scroll:setScrollLump(UILH_COMMON.up_progress, UILH_COMMON.down_progress, 11, 30, 480 )
    scroll:setScrollLumpPos(402)
    panel:addChild( scroll )
    panel:addChild(arrow_up)
    panel:addChild(arrow_down)
    self.r_up_scroll = scroll
    self.slot_par = slot_par
end

--刷新左侧面板的所有item.  参数：item的类型（人物或者背包）
function GemSet:reflash_all_item_r_up( item_type )
    self:remove_all_item_up(  )
    if "equipment" == item_type then
        self:create_char_slot_char( self.panel_t["right_equi_panel"] )
    elseif "bag" == item_type then
        self:create_bag_slot_char( self.panel_t["right_equi_panel"] )
    end
end

--清空面板所有item:  参数：panel_name ：面板的名称
function GemSet:remove_all_item_up(  )
    self.panel_t["right_equi_panel"]:removeChild(self.r_up_scroll, true) 
    for key, show_item_panel in pairs(self.r_up_all_item_t) do 
        safe_release(show_item_panel.view)
    end
    self.r_up_all_item_t = {}
end

function GemSet:update_select_state_up(  )
    -- 必须先设置其他为有效装备
    for i, show_item_panel in pairs(self.r_up_all_item_t) do 
        if ForgeModel:check_insert_item_selected( show_item_panel.item_series ) then
            show_item_panel.set_state( true )
        else 
            show_item_panel.set_state( false )
        end
    end
end

-- 更新道具数据
function GemSet:update_all_item_date_up(  )
    for key, show_item_panel in pairs(self.r_up_all_item_t) do 
        show_item_panel.update_date()
    end
end

-- 默认选中第一个
function GemSet:set_default_item(  )
    -- 默认选中第一个
    local slot_par = self.slot_par
    if not slot_par then
        return
    end
    if #slot_par > 0 then
        local item_panel = self.r_up_all_item_t[slot_par[1][1]]
        if item_panel then
            item_panel:do_click()
        end
    end
end

--================================================================================================================================
--================================================================================================================================
--
--锻造区
--
--================================================================================================================================
--================================================================================================================================
--创建
function GemSet:create_forge_panel( pos_x, pos_y, width, height, texture_name )
    local bg_panel = CCBasePanel:panelWithFile( pos_x, pos_y, width, height, texture_name, 500, 500 )
    -- self:create_gem_meta_panel(bg_panel)

    local panel = CCBasePanel:panelWithFile( 0, 0, 370, 295, "", 500, 500 )
    bg_panel:addChild(panel)

    -- 说明按钮
    local function help_btn_callback( ... )
        -- print("help_btn click")
        ForgeModel:show_help_panel( UILH_FORGE.xq_notic, Lang.forge.gem_info )
    end
    local help_panel = ZBasePanel:create( bg_panel, "", 280, 245, 115, 40 )
    help_panel:setTouchClickFun(help_btn_callback)

    local help_btn = ZButton:create(help_panel, UILH_NORMAL.wenhao, help_btn_callback, 0, 0, -1, -1)
    local help_btn_size = help_btn:getSize()
    local help_img = ZImage:create(help_panel, UILH_FORGE.xq_img, 0, 0, -1, -1)  
    local help_img_size = help_img:getSize()
    help_img:setPosition( help_btn_size.width, ( help_btn_size.height - help_img_size.height ) / 2 )    
    --锻造区三个item。  初始化的时候，图标都是使用默认图标。传入nil
    local equip_itembg  = ZImage:create(panel, UILH_NORMAL.special_grid, 150, 179, 114, 115, 0, 500, 500)
    _left_slotitem_equi     = self:create_item( panel, nil, 170, 199, 74, 74, "equi" )              --装备
    ZImage:create(_left_slotitem_equi.icon_bg, UILH_FORGE.zb_img, 20, 27, -1, -1)
    -- _left_slotitem_equi.view:setIsVisible(false)
    
    _left_slotitem_gem_atta = self:create_item( panel, nil,  40, 145, 74, 74, "gem_atta" )          --左侧侧宝石
    ZImage:create(_left_slotitem_gem_atta.icon_bg, UILH_FORGE.gj_img, 20, 27, -1, -1)

    _left_slotitem_gem_prot = self:create_item( panel, nil, 170, 90, 74, 74, "gem_prot" )          --中间宝石
    ZImage:create(_left_slotitem_gem_prot.icon_bg, UILH_FORGE.fy_img, 20, 27, -1, -1)

    _left_slotitem_gem_life = self:create_item( panel, nil, 300 , 145, 74, 74, "gem_life" )          --右侧宝石
    ZImage:create(_left_slotitem_gem_life.icon_bg, UILH_FORGE.sm_img, 20, 27, -1, -1)

    local function gem_atta_func()
        ForgeModel:do_remove_gem( "atta" )
    end
    self.gem_atta_but = UIButton:create_button_with_name( 48, 85, 65, 30, UILH_COMMON.button5_nor, UILH_COMMON.button5_nor, nil, "", gem_atta_func, true )
    self.gem_atta_but.view:addChild( UILabel:create_lable_2( Lang.forge.gem_set[3], 32, 10, 14, ALIGN_CENTER ) ) --摘除
    self.gem_atta_but.view:addTexWithFile( CLICK_STATE_DISABLE, UILH_COMMON.button5_dis)
    self.gem_atta_but.view:setCurState( CLICK_STATE_DISABLE )
    panel:addChild( self.gem_atta_but.view )

    -- 保护宝石
    local function gem_prot_func()
        ForgeModel:do_remove_gem( "prot" )
    end
    self.gem_prot_but = UIButton:create_button_with_name( 178, 30, 65, 30, UILH_COMMON.button5_nor, UILH_COMMON.button5_nor, nil, "", gem_prot_func, true )
    self.gem_prot_but.view:addChild( UILabel:create_lable_2( Lang.forge.gem_set[3], 32, 10, 14, ALIGN_CENTER ) ) --摘除
    self.gem_prot_but.view:addTexWithFile( CLICK_STATE_DISABLE, UILH_COMMON.button5_dis)
    self.gem_prot_but.view:setCurState( CLICK_STATE_DISABLE )
    panel:addChild( self.gem_prot_but.view )

    -- 生命宝石
    local function gem_life_func()
        ForgeModel:do_remove_gem( "life" )
    end
    self.gem_life_but = UIButton:create_button_with_name( 308, 85, 65, 30, UILH_COMMON.button5_nor, UILH_COMMON.button5_nor, nil, "", gem_life_func, true )
    self.gem_life_but.view:addChild( UILabel:create_lable_2( Lang.forge.gem_set[3], 32, 10, 14, ALIGN_CENTER ) ) --摘除
    self.gem_life_but.view:addTexWithFile( CLICK_STATE_DISABLE, UILH_COMMON.button5_dis)
    self.gem_life_but.view:setCurState( CLICK_STATE_DISABLE )
    panel:addChild( self.gem_life_but.view )


    --显示的一些文字
    local dimensions = CCSize(300,15)

    local label_temp = UILabel:create_label_1("", CCSize(100,20), 75, 160 - 28, 15, CCTextAlignmentCenter, 255, 255, 0)
    self.label_t[ "atta_add_label" ]  = label_temp  --加成属性 存储起来，使用关键字获取并修改显示内容
    panel:addChild( label_temp )

    label_temp = UILabel:create_label_1("", CCSize(100,20), 205, 160 - 83, 15, CCTextAlignmentCenter, 255, 255, 0)
    self.label_t[ "prot_add_label" ]  = label_temp  --加成属性 存储起来，使用关键字获取并修改显示内容
    panel:addChild( label_temp )

    label_temp = UILabel:create_label_1("", CCSize(150,20), 335, 160 - 28, 15, CCTextAlignmentCenter, 255, 255, 0)
    self.label_t[ "life_add_label" ]  = label_temp  --加成属性 存储起来，使用关键字获取并修改显示内容
    panel:addChild( label_temp )

    -- 镶嵌按钮 
    local but_1 = CCNGBtnMulTex:buttonWithFile( 295, 8, -1, -1, UILH_COMMON.lh_button2, 500, 500)
    -- but_1:addTexWithFile(CLICK_STATE_DOWN, UUIPIC_COMMON_BUTTON_001)
    but_1:addTexWithFile(CLICK_STATE_DISABLE, UILH_COMMON.lh_button2_disable )
    local function but_1_fun(eventType,x,y)
        if eventType == TOUCH_CLICK then 
            ForgeModel:do_insert_gem(  )
            return true
        end
        return true
    end
    but_1:registerScriptHandler(but_1_fun)    --注册
    panel:addChild(but_1)
    --按钮显示的名称
    but_1:addChild( UILabel:create_lable_2( Lang.forge.gem_set[2], 50, 20, 16, ALIGN_CENTER ) )  -- [2] = 镶嵌
    self.set_but = but_1
    but_1:setCurState( CLICK_STATE_DISABLE ) 

    self.panel_t["left_panel"] = panel        --存入table，用于动态修改
    return bg_panel
end
-- 创建一个item 包括slotitem和信息 
function GemSet:create_equip_item( panel, item_series, po_x , po_y, size_w, size_h , item_type)
    local slotItem = MUtils:create_one_slotItem( nil, po_x , po_y, size_w, size_h )

    local function f2( ... )
        local a, b, arg = ...
        local position = Utils:Split(arg,":");
            -- 将相对坐标转化成屏幕坐标(即OpenGL坐标 800x480)
        local pos = slotItem.view:getParent():convertToWorldSpace( CCPointMake(position[1],position[2]) );
        if slotItem.item_date then
            ForgeModel:show_tips_by_series( slotItem.item_date.series, pos.x, pos.y )
        elseif slotItem.item_id then
            ForgeModel:show_item_tips( slotItem.item_id, pos.x, pos.y )
        end
    end
    slotItem:set_click_event( f2 )

    panel:addChild( slotItem.view )

    return slotItem
end

-- 创建一个item 包括slotitem和信息 
function GemSet:create_item( panel, item_series, po_x , po_y, size_w, size_h , item_type)
    local slotItem = MUtils:create_one_slotItem( item_series, po_x , po_y, size_w, size_h )

    -- 设置回调单击函数
    local function f1()
        if "equi" == item_type then
            ForgeModel:set_insert_item_series( nil )
            -- 取消品质特效
            _left_slotitem_equi:set_item_quality( nil );
        elseif "gem_atta" == item_type then
            ForgeModel:set_insert_atta_series( nil )
        elseif "gem_prot" ==  item_type then
            ForgeModel:set_insert_prot_series( nil )
        elseif "gem_life" ==  item_type then
            ForgeModel:set_insert_life_series( nil )
        end
    end
    slotItem:set_double_click_event( f1 )

    local function f2( ... )
        local a, b, arg = ...
        local position = Utils:Split(arg,":");
            -- 将相对坐标转化成屏幕坐标(即OpenGL坐标 800x480)
        local pos = slotItem.view:getParent():convertToWorldSpace( CCPointMake(position[1],position[2]) );
        if slotItem.item_date then
            ForgeModel:show_tips_by_series( slotItem.item_date.series, pos.x, pos.y )
        elseif slotItem.item_id then
            ForgeModel:show_item_tips( slotItem.item_id, pos.x, pos.y )
        end
    end
    slotItem:set_click_event( f2 )

    -- local word_bg = CCZXImage:imageWithFile( 7, 12, 34, 36, UIPIC_FORGE_060 )
    -- slotItem.view:addChild(word_bg)

    panel:addChild( slotItem.view )

    return slotItem
end
-- 更新选中的装备
function GemSet:update_insert_item(server_resp)
    local item_date = ForgeModel:get_insert_item_date(  )
    _left_slotitem_equi.set_date( item_date )
    if ( item_date ) then
        local item_base = ItemConfig:get_item_by_id( item_date.item_id )
        local pj = ItemModel:get_item_pj( item_base )
        -- 增加品质特效
        _left_slotitem_equi:set_item_quality( item_date.void_bytes_tab[1],pj );
    else
        _left_slotitem_equi:set_item_quality( nil ,nil);
    end
    -- if self.cur_selected_item then
    --     self.cur_selected_item.update_date()
    -- end
    self:syn_atta_gem()
    self:syn_prot_gem()
    self:syn_life_gem()
    self:check_but_enable()

    -- 同步镶嵌按钮
    self:syn_insert_btn_state()
end
--[[
--跟踪宝石改变了
function GemSet:onGemChange(which, server_resp, gem_id)
    --如果不知道是哪一个一般就是防御和法防宝石的卸下事件
    if not which then
        local prot2 = self.lastGemProp[2].id or 0
        local prot3 = self.lastGemProp[3].id or 0
        if prot2 ~= 0 then
            which = 2
        else
            which = 3
        end
    end

    --print('LLLLLLLLLLLLLLLLLLLLL',which, self.lastGemProp[which].id,  gem_id, self.lastGemProp[which].id == gem_id,server_resp)
    local same = self.lastGemProp[which].id == gem_id
    --xprint(">>>>>>", same, which,self.lastGemProp[which].id, gem_id, server_resp)
    if gem_id and gem_id ~= 0 then
        if server_resp and not same then
            self:getTailEffect(which,false)
        end
    else
        if server_resp and not same then
            self:getTailEffect(which,true)
        end
    end
    self.lastGemProp[which] = { id = gem_id }
end
]]

-- 同步攻击宝石
function GemSet:syn_atta_gem()
    local atta_gem_id = ForgeModel:get_insert_item_gem( "atta" )
    if atta_gem_id and atta_gem_id ~= 0 then
        _left_slotitem_gem_atta.set_base_date( atta_gem_id )
        -- self.gem_atta_but.view:setIsVisible( true )
        self.gem_atta_but.view:setCurState( CLICK_STATE_UP )
        self._is_atta_ins = true
    else
        _left_slotitem_gem_atta.set_base_date( nil )
        self.gem_atta_but.view:setCurState( CLICK_STATE_DISABLE )
        self._is_atta_ins = false
    end
    -- self:onGemChange(1,server_resp,atta_gem_id)
    self:set_gem_add_attr_num( self.label_t[ "atta_add_label" ], atta_gem_id )
end

-- 同步防御宝石
function GemSet:syn_prot_gem()
    local prot_item_id = ForgeModel:get_insert_item_gem( "prot" )
    local _type = ItemConfig:get_gem_type_by_id(prot_item_id)
    if prot_item_id and prot_item_id ~= 0 then
        _left_slotitem_gem_prot.set_base_date( prot_item_id )
        self.gem_prot_but.view:setCurState( CLICK_STATE_UP )
        self._is_prot_ins = true
    else
        _left_slotitem_gem_prot.set_base_date( nil )
        self.gem_prot_but.view:setCurState( CLICK_STATE_DISABLE )
        self._is_prot_ins = false
    end
    -- self:onGemChange(_type,server_resp,prot_item_id)
    self:set_gem_add_attr_num( self.label_t[ "prot_add_label" ], prot_item_id )
end

-- 同步生命宝石
function GemSet:syn_life_gem()
    local life_item_id = ForgeModel:get_insert_item_gem( "life" )
    if life_item_id and life_item_id ~= 0 then
        _left_slotitem_gem_life.set_base_date( life_item_id )
        self.gem_life_but.view:setCurState( CLICK_STATE_UP )
        self._is_life_ins = true
    else
        _left_slotitem_gem_life.set_base_date( nil )
        self.gem_life_but.view:setCurState( CLICK_STATE_DISABLE )
        self._is_life_ins = false
    end
    -- self:onGemChange(4,server_resp,life_item_id)
    self:set_gem_add_attr_num( self.label_t[ "life_add_label" ], life_item_id )
end

-- 同步镶嵌按钮
function GemSet:syn_insert_btn_state()
    if self._is_atta_ins and self._is_prot_ins and self._is_life_ins then
        self.set_but:setCurState(CLICK_STATE_DISABLE)
    else
        self.set_but:setCurState(CLICK_STATE_UP)
    end
end

function GemSet:set_gem_add_attr_num( label, item_id)
    local attr_name, attr_value = ForgeModel:get_gem_add_attribute( item_id )
    if attr_name and attr_value then
        label:setString("#c00c0ff" .. attr_name .. " +" .. attr_value )
    else
        label:setString( "" )
    end
end
--[[
function GemSet:after_remove_gem( )
    local gem_type = ForgeModel:get_gem_type()
    local gem_item = nil
    if gem_type == 1 then
        gem_item = self.gem_slotitem_t["gem_atta"]
    elseif gem_type == 2 or gem_type == 3 then
        gem_item = self.gem_slotitem_t["gem_prot"]
    elseif gem_type == 4 then
        gem_item = self.gem_slotitem_t["gem_life"]
    end

    if gem_item then
        gem_item.do_click()
    end
    ForgeModel:req_gem_meta()
end
]]
-- 更新攻击宝石
function GemSet:udpate_gem_atta(  )
    local item_date = ForgeModel:get_insert_atta_date(  )
    if item_date then
        _left_slotitem_gem_atta.set_base_date( item_date.item_id )
        _left_slotitem_gem_atta:set_lock( item_date.flag == 1 )
        self:set_gem_add_attr_num( self.label_t[ "atta_add_label" ], item_date.item_id )
    else
        if ForgeModel:get_insert_item_gem( "atta" )  == 0 then
            _left_slotitem_gem_atta.set_base_date( nil )
            self:set_gem_add_attr_num( self.label_t[ "atta_add_label" ], nil )
        end
    end
    -- self:syn_atta_gem()
    self:check_but_enable(  )
end

-- -- 更新防御宝石
function GemSet:udpate_gem_prot(  )
    local item_date = ForgeModel:get_insert_prot_date(  )
    local gem_type = ForgeModel:get_gem_type()

    if item_date then
        _left_slotitem_gem_prot.set_base_date( item_date.item_id )
        _left_slotitem_gem_prot:set_lock( item_date.flag == 1 )
        self:set_gem_add_attr_num( self.label_t[ "prot_add_label" ], item_date.item_id )
    else
        if ForgeModel:get_insert_item_gem( "prot" ) == 0 then
            _left_slotitem_gem_prot.set_base_date( nil )
            self:set_gem_add_attr_num( self.label_t[ "prot_add_label" ], nil )
        end
    end
    -- self:syn_prot_gem()
    self:check_but_enable(  )
end

-- -- 更新生命宝石
function GemSet:udpate_gem_life(  )
    local item_date = ForgeModel:get_insert_life_date(  )
    if item_date then
        _left_slotitem_gem_life.set_base_date( item_date.item_id )
        _left_slotitem_gem_life:set_lock( item_date.flag == 1 )
        self:set_gem_add_attr_num( self.label_t[ "life_add_label" ], item_date.item_id )
    else
        if ForgeModel:get_insert_item_gem( "life" ) == 0 then
            _left_slotitem_gem_life.set_base_date( nil )
            self:set_gem_add_attr_num( self.label_t[ "life_add_label" ], nil )
        end
    end
    -- self:syn_life_gem()
    self:check_but_enable(  )
end

-- 检查按钮是否可以生效。  当有选择的宝石的时候，可以生效
function GemSet:check_but_enable(  )
    -- print("========ForgeModel:check_insert_enable(  ): ", ForgeModel:check_insert_enable(  ))
    local gem_type = ForgeModel:get_gem_type()
    local gem_level = 0
    local item_id = nil
    if gem_type == 1 then
        item_id = _left_slotitem_gem_atta.item_id
    elseif gem_type == 2 or gem_type == 3 then
        item_id = _left_slotitem_gem_prot.item_id
    elseif gem_type == 4 then
        item_id = _left_slotitem_gem_life.item_id
    end

    if item_id then
        local gem_item = ItemConfig:get_item_by_id(item_id)
        gem_level = gem_item.suitId
    else
    end

    if ForgeModel:check_insert_enable() and ForgeModel:check_selected_gem() and gem_level < 10 then
        self.tips:setIsVisible(false)
        self.cost_panel:setIsVisible(true)
        self.action_btn:setCurState( CLICK_STATE_UP )
    else
        if self.tips then
            self.tips:setIsVisible(true)
            if gem_level >= 10 then
                self.tips:setString(Lang.forge.gem_set[7]) --[7] = "#cffff00已满级"
                if self.action_btn then
                    self.action_btn:setCurState( CLICK_STATE_DISABLE )
                end
            else
                self.tips:setString(Lang.forge.gem_set[6])  -- [6] "请先选择将要镶嵌的宝石""
            end
        end
        if self.cost_panel then
            self.cost_panel:setIsVisible(false)
        end
    end
end

--================================================================================================================================
--================================================================================================================================
--
--右侧材料区
--
--================================================================================================================================
--================================================================================================================================

function GemSet:create_meta_panel( pos_x, pos_y, width, height, texture_name )
    local bg_panel = CCBasePanel:panelWithFile( pos_x, pos_y, width, height, texture_name, 500, 500 )
    -- local panel = CCBasePanel:panelWithFile( 0, 180, 230, 296+40, UIPIC_FORGE_001, 500, 500 )
    -- bg_panel:addChild(panel)
    self:create_meta_slot( bg_panel )
    self.right_top_panel = bg_panel
    local btn_1       = ZImage:create(bg_panel, UILH_NORMAL.title_bg3, width / 2, height - 20, -1, -1, nil, 500)
    btn_1:setAnchorPoint(0.5, 0.5)
    local label_but_1 = ZLabel:create(bg_panel, COLOR.y .. Lang.forge.synth[19], 3+width*0.5, 163, 15, ALIGN_CENTER, 3)   --[8] = "#ce0fcff材料"
    self.panel_t["right_mate_panel"] = bg_panel        --存入table，用于动态修改

    return bg_panel
end

--创建材料item
function GemSet:create_meta_slot( panel )
    local bag_items, bag_item_count = ItemModel:get_bag_data() --背包中物品的集合和数量
    local item_bag = nil                                       --背包中存储的item数据，注意和基本item数据区分
    local place_index = 1                                      --这里物品不是每个都显示的，要判断（类型，和是否合适装备使用），所以位置要分开计数
    local item_base = nil                                      --基础item数据，用来回去改物品的公共属性

    require "config/ItemConfig"
    local slotItem_t = {}
    local slot_par = {}
    for i = 1, bag_item_count do
        item_bag = bag_items[i]
        --判断是否是强化类型物品，是否合适选中的物品的强化
        if item_bag then
            item_base = ItemConfig:get_item_by_id( item_bag.item_id )
        end
        -- 202表示“宝石”。    quality属性表示物品品质等级
        if ( item_bag and item_base and (item_base.type == ItemConfig.ITEM_TYPE_GEM) )then  
            slot_par[ #slot_par + 1] = { item_bag.series }
        end
    end
    local scroll = self:create_scroll_area( slot_par, 0, 20, 405, 130, 2, 2, nil, false)
    scroll:setScrollLump(UILH_COMMON.up_progress, UILH_COMMON.down_progress, 11, 30, 480 )
    scroll:setScrollLumpPos(405)
    local arrow_up = CCZXImage:imageWithFile(405 , 149, 11, -1 , UILH_COMMON.scrollbar_up, 500, 500)
    local arrow_down = CCZXImage:imageWithFile(405, 8, 11, -1, UILH_COMMON.scrollbar_down, 500 , 500)
    panel:addChild( scroll )
    panel:addChild(arrow_up)
    panel:addChild(arrow_down)
    self.r_down_scroll = scroll
end

-- 创建可拖动区域   参数：放入scroll的panel的集合, 坐标， 区域大小，列数， 背景名称, 是否装备
function GemSet:create_scroll_area( panel_table_para ,pos_x, pos_y, size_w, size_h, colu_num, sight_num, bg_name, if_equip)
    local row_num = math.ceil( #panel_table_para / colu_num )
    local _scroll_info = { x = pos_x, y = pos_y, width = size_w, height = size_h, maxnum = row_num, image = bg_name, stype = TYPE_HORIZONTAL }
    local scroll = CCScroll:scrollWithFile( _scroll_info.x, _scroll_info.y, 
        _scroll_info.width, _scroll_info.height, 
        _scroll_info.maxnum, _scroll_info.image, 
        _scroll_info.stype )
    -- scroll:setEnableScroll(false)

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
            local row_h = if_equip and 93 or 75
            local row_w = if_equip and 190 or 205
            local colu_height = if_equip and row_h+3 or row_h
            local bg_vertical = CCBasePanel:panelWithFile( 0, 0, size_w, colu_height, "", 500, 500)
            local indent_x= 22   --缩进
            local space_x = 5    --列距
            local space_x = ( 400 - 190 * 2 ) / 4
            for i = 1, colu_num do
                if panel_table_para[index + i] then
                    local bg = self:create_show_panel( panel_table_para[index + i], 
                        (i - 1) * row_w + space_x * i, 0, 
                        row_w, row_h )
                    bg_vertical:addChild(bg.view)
                else
                    local bg = CCBasePanel:panelWithFileS(CCPointMake(0,0),CCSizeMake(0,0),nil)
                    bg_vertical:addChild(bg)
                end
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

--刷新右侧下面面板的所有item.  参数：item的类型（人物或者背包）
function GemSet:reflash_all_item_r_down( item_type )
    self:remove_all_item_down(  )
    self:create_meta_slot( self.panel_t["right_mate_panel"] )
end

--清空右侧下面板所有item:  
function GemSet:remove_all_item_down(  )
    self.panel_t["right_mate_panel"]:removeChild(self.r_down_scroll, true) 
    for key, show_item_panel in pairs(self.r_down_all_item_t) do 
        -- _retain_panels[show_item_panel.view] = nil
        safe_release(show_item_panel.view)
    end
    self.r_down_all_item_t = {}
end

function GemSet:update_select_state_down(  )
    -- 必须先设置其他为有效装备
    for i, show_item_panel in pairs(self.r_down_all_item_t) do 
        if ForgeModel:check_insert_item_selected( show_item_panel.item_series ) then
            show_item_panel.set_state( true )
        else 
            show_item_panel.set_state( false )
        end
    end
end

-- 更新右侧下道具数据
function GemSet:update_all_item_date_down(  )
    for key, show_item_panel in pairs(self.r_down_all_item_t) do 
        show_item_panel.update_date()
    end
end



function GemSet:destroy()
    Window.destroy(self)
    for key, show_item_panel in pairs(self.r_up_all_item_t) do 
        _retain_panels[show_item_panel.view] = nil
        safe_release(show_item_panel.view)
        
    end
    for key, show_item_panel in pairs(self.r_down_all_item_t) do 
        _retain_panels[show_item_panel.view] = nil
        safe_release(show_item_panel.view)
    end

    --最后检查是否是忘了release
    for k, v in pairs(_retain_panels) do
        assert(false)
    end
    _retain_panels = {}
end

function GemSet:active()

end

--[[
--宝石操作tail特效
function GemSet:getTailEffect(id, revese)
    local config = _gem_taileffect_info[id]
    if revese then
        LuaEffectManager:getTailEffect(self.view,
                                       meta_icon_t[id],
                                       config.gem_color,
                                       _gem_taileffect_info.time,
                                       config.dst[1],config.dst[2],
                                       config.src[1],config.src[2],
                                       _gem_taileffect_info.seg0,
                                       _gem_taileffect_info.seg1,
                                       config.offset)
    else
        LuaEffectManager:getTailEffect(self.view,
                                       meta_icon_t[id],
                                       config.gem_color,
                                       _gem_taileffect_info.time,
                                       config.src[1],config.src[2],
                                       config.dst[1],config.dst[2],
                                       _gem_taileffect_info.seg0,
                                       _gem_taileffect_info.seg1,
                                       config.offset)
    end
end

--xiehande
 --附灵/升级  成功特效
function GemSet:play_gemset_effect(pro_x,pro_y)
    -- body
    LuaEffectManager:play_view_effect(400,pro_x,pro_y,self.view,false,5 );
end

--摘除 特效
function GemSet:play_remove_effect(pro_x,pro_y)
    -- body
    LuaEffectManager:play_view_effect(404,pro_x,pro_y,self.view,false,5 );
end
]]