-- StrengthenRD.lua
-- created by lyl on 2012-12-7
-- 炼器--强化装备页面中的右下侧面板
-- 右

super_class.StrengthenRD()


local font_size = 16
local color_yellow = "#cffff00"

-- 不能购买的材料（只能合成）的id集合
local _mate_item_id_no_buy_t = {  [18721] = true, [18722] = true, [18723] = true, }

local gap_w = 3
local left_begin_pos_x = 0
local left_size_w = 0
local left_size_h = 0
local right_size_w = 0
local right_begin_pos_x = 0

function StrengthenRD:__init( pos_x, pos_y, width, height, texture_name , fath_object )
    self.fath_object = fath_object
    self.r_down_all_item_t = {}        --存储右侧下部分的所有item。
    self.r_down_scroll = nil           -- 滚动面板
    self.show_item_panel_t = {}        -- 所有道具展示面板
    self.label_t = {}

    local bg_panel = CCBasePanel:panelWithFile( pos_x, pos_y, width, height, texture_name, 500, 500 )

    -- local _right_btm_panel = CCBasePanel:panelWithFile( 0, 0, 230, 118+40, UIPIC_FORGE_001, 500, 500 )
    -- bg_panel:addChild(_right_btm_panel)
    -- self.right_btm_panel = _right_btm_panel
    ZImage:create(bg_panel, UILH_COMMON.split_line_v, width / 2 - 1, 0, 2, height , nil)
    
    gap_w = 3
    left_begin_pos_x = gap_w
    left_size_w = ( width - gap_w * 2 ) / 2
    left_size_h = height
    right_size_w = left_size_w - 5
    --width - left_size_w - gap_w * 5
    right_begin_pos_x = left_size_w + gap_w

    local _bg_l = ZImage:create( bg_panel, "", left_begin_pos_x, 0, left_size_w, height, nil, 600, 600 )

    local _title_bg = ZImage:create( bg_panel, UILH_NORMAL.title_bg3, width / 2, height, -1, -1, nil, 600, 600)
    _title_bg:setAnchorPoint(0.5,0.5)
    local _title_bg_size = _title_bg:getSize()
    local _title_label = ZLabel:create( _title_bg, Lang.forge.tab_one.metrial, 0, 0)
    local _title_label_size = _title_label:getSize()
    _title_label:setPosition( ( _title_bg_size.width - _title_label_size.width ) / 2, ( _title_bg_size.height - _title_label_size.height ) / 2 )

    local _bg_r = ZImage:create( bg_panel, "", right_begin_pos_x, 0, right_size_w, height, nil, 600, 600 )


    -- 是否自动购买材料
    local auto_buy_fun = function( ... )
        -- body
    end
    _auto_buy_stone_btn = UIButton:create_switch_button( right_begin_pos_x + 20, 15, 110, 33, 
        UILH_COMMON.dg_sel_1, 
        UILH_COMMON.dg_sel_2, 
        Lang.forge.tab_one.is_auto_buy, 40, font_size, 40, 38, nil, nil, 
        auto_buy_fun ) -- [2322]="自动购买材料"
    bg_panel:addChild(_auto_buy_stone_btn.view, 2);

    --_auto_buy_stone_btn.view:setPosition( )


    -- 强化按钮  :对于不用在其他代码位置获取的按钮，直接使用数字命名，方便复制到其他位置使用
    local btn_1 = CCNGBtnMulTex:buttonWithFile( 0, 0, -1, -1, UILH_NORMAL.special_btn )
    local btn_1_size = btn_1:getSize()
    btn_1:setPosition( right_begin_pos_x + ( right_size_w - btn_1_size.width ) / 2, ( height - btn_1_size.height ) / 2 )
    btn_1:addTexWithFile(CLICK_STATE_DISABLE, UILH_NORMAL.special_btn_d)

    local btn_img = ZImage:create( btn_1, UILH_FORGE.strength, 0, 0, -1, -1 )
    local btn_img_size = btn_img:getSize()
    btn_img:setPosition( ( btn_1_size.width - btn_img_size.width ) / 2, ( btn_1_size.height - btn_img_size.height ) / 2 )

    local function btn_1_fun(eventType,x,y)
        if eventType == TOUCH_CLICK then 
            Instruction:handleUIComponentClick(instruct_comps.StrengthenRD_WIN_OK_BTN)
            Analyze:parse_click_main_menu_info(255)
            if ForgeModel:check_gem_series_select() == false and _auto_buy_stone_btn.if_selected == false then --有没有选择材料
                GlobalFunc:create_screen_notic("材料不足")
                return
            end
            ForgeModel:do_strengthen( _auto_buy_stone_btn.if_selected , _auto_buy_stone_btn.if_selected)

            -- -- 新手引导代码
            -- if ( XSZYManager:get_state() == XSZYConfig.LIAN_QI_ZY ) then
            --     XSZYManager:destroy_jt( XSZYConfig.OTHER_SELECT_TAG );
            --     -- 指向关闭按钮  705,420,62, 56
            --     XSZYManager:play_jt_and_kuang_animation_by_id( XSZYConfig.LIAN_QI_ZY,3 ,XSZYConfig.OTHER_SELECT_TAG);
                
            -- end
        end
        return true
    end
    btn_1:registerScriptHandler(btn_1_fun)    --注册
    btn_1:setCurState(CLICK_STATE_DISABLE)
    bg_panel:addChild(btn_1)
    self.strengthen_btn = btn_1

    --按钮显示的名称
    -- local forge_lab = ZLabel:create(btn_1, Lang.forge.tab_one.used, 0, 0 )
    -- local forge_lab_size = forge_lab:getSize()
    -- local btn_1_size = btn_1:getSize()
    -- forge_lab:setPosition( ( btn_1_size.width - forge_lab_size.width ) / 2, ( btn_1_size.height - forge_lab_size.height ) / 2 )
    -- local name_image = CCZXImage:imageWithFile(  73, 30 , 72, 29, UIPIC_FORGE_042 ); 
    -- name_image:setAnchorPoint(0.5,0.5);
    -- btn_1:addChild( name_image )
    self.strengthen_but = btn_1

    local label_temp = ZLabel:create( bg_panel, Lang.forge.tab_one.used, right_begin_pos_x + 20, height - 60 )
    local label_temp_pos = label_temp:getPosition()
    --UILabel:create_lable_2(color_yellow .. "", right_begin_pos_x + 15, 75+40, font_size, ALIGN_LEFT)
    -- bg_panel:addChild( label_temp.view )

    -- local gold_png = CCZXImage:imageWithFile(right_begin_pos_x + 55, 68+40, -1, -1, UIPIC_FORGE_049)
    -- bg_panel:addChild(gold_png)

    self.label_t[ "need_money" ]  = UILabel:create_lable_2( color_yellow .. "0", label_temp_pos.x + 85, label_temp_pos.y, font_size, ALIGN_LEFT )  
    bg_panel:addChild( self.label_t[ "need_money" ] )

    -- local panel = CCBasePanel:panelWithFile( 0, 120+40, 230, 355, UIPIC_FORGE_001, 500, 500 )
    -- bg_panel:addChild(panel)

    -- local top_panel_size = panel:getSize()

    -- -- title
    -- local title_bg = CCZXImage:imageWithFile( 1, top_panel_size.height-32, 127, 28, UIPIC_FORGE_002)
    -- local title_img = CCZXImage:imageWithFile( 25, 2, 71, 22, UIPIC_FORGE_030 )
    -- title_bg:addChild( title_img )
    -- panel:addChild( title_bg )

    -- self.panel_t["right_mate_panel"] = panel        --存入table，用于动态修改
    self.rifht_top_panel = bg_panel
    self.view = bg_panel
end

--创建材料item
function StrengthenRD:create_meta_slot( panel )
    local mete_series_t = {}
    --local mete_series_t = ForgeModel:get_strengthen_meterial(  )
    local if_gem_exist, if_prot_exist = ForgeModel:check_if_exist_mate(  )

    -- 如果没有材料，就要特别显示一个购买按钮
    if ForgeModel:had_selected_strengthen_item(  )  then
    --if not if_gem_exist and ForgeModel:had_selected_strengthen_item(  ) then
        table.insert( mete_series_t, -1 )   -- -1 表示创建一个 强化石 构面显示面板
    end

    --if not if_prot_exist and ForgeModel:had_selected_strengthen_item(  ) and ForgeModel:check_strengthen_item_need_prot(  ) then
    if ForgeModel:check_strengthen_item_need_prot(  ) then
       table.insert( mete_series_t, -2 )   -- -2 表示创建一个 保护符 构面显示面板
    end

    local scroll = self:create_scroll_area( mete_series_t, left_begin_pos_x + 5, 5, left_size_w - 10, left_size_h - 40, 1, 3, nil)
    panel:addChild( scroll )
    self.r_down_scroll = scroll
end

-- 创建可拖动区域   参数：放入scroll的panel的集合, 坐标， 区域大小，列数， 背景名称
function StrengthenRD:create_scroll_area( panel_table_para ,pos_x, pos_y, size_w, size_h, colu_num, sight_num, bg_name)
    local row_num = #panel_table_para / colu_num - #panel_table_para / colu_num % 1
    local _scroll_info = { x = pos_x, y = pos_y, width = size_w, height = size_h, maxnum = row_num, image = bg_name, stype = TYPE_HORIZONTAL }
    local scroll = CCScrollDynamicArea:scrollWithFile( _scroll_info.x, _scroll_info.y, _scroll_info.width, _scroll_info.height, _scroll_info.maxnum, _scroll_info.image, _scroll_info.stype )
    scroll:setEnableScroll(true)

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
            -- print("重新创建了啊啊啊啊啊啊啊啊啊啊_scroll_info.maxnum=",_scroll_info.maxnum)
            local temparg = Utils:Split(args,":")
            local x = temparg[1]              -- 行
            local index = x * colu_num 
            local row_h = 94
            local row_w = 226
            local bg_vertical = CCBasePanel:panelWithFile( 0, 0, row_w, row_h, "")
            local colu_with = 190
            local indent_x= 5   --缩进
            local space_x = 0   --列距
            for i = 1, colu_num do
                -- local itemBg = CCZXImage:imageWithFile((i - 1) * (colu_with+space_x)+indent_x, 0, 74, 74, UIPIC_FORGE_029)
                -- bg_vertical:addChild(itemBg)
                if panel_table_para[index + i] then
                    local bg = self:create_show_panel( panel_table_para[index + i], 
                            (i - 1) * (colu_with+space_x), 0, 
                            row_w, row_h )
                    bg_vertical:addChild(bg.view)
                    local line = CCBasePanel:panelWithFile(10, 0, 190 , 3, UILH_COMMON.split_line )
                    bg_vertical:addChild(line)
                -- else
                --     local bg = CCBasePanel:panelWithFileS(CCPointMake(0,0),CCSizeMake(0,0),nil)
                --     bg_vertical:addChild(bg)
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

-- 创建一个包括tip的显示面板
function StrengthenRD:create_show_panel( panel_date, x, y, w, h  )
    local item_series = panel_date

    if self.show_item_panel_t[item_series] then
        return self.show_item_panel_t[item_series]
    end

    local show_item_panel = {}
    local show_item_panel_bg = CCBasePanel:panelWithFile( x, y , w, h , nil )
    show_item_panel.view = show_item_panel_bg

    local slotItem = MUtils:create_one_slotItem( nil, 15, 15, 64, 64 )              --创建slotitem
    slotItem.view:setScale( 68 / 64)
    show_item_panel.view:addChild( slotItem.view )

    local item_date = ForgeModel:get_item_in_bag_or_body( item_series )
    --------------
    ---HJH 2014-9-23
    ---modify begin
    ---由于策划对炼器案子修改原有的方面更改为将item_data显示为空，以做出只显示购买效果
    ---
    item_date = nil
    ---modify end
    --------------
    slotItem.set_date( item_date )


    local function f2( ... )
        local a,b,arg = ...
        local position = Utils:Split(arg,":");
            -- 将相对坐标转化成屏幕坐标(即OpenGL坐标 800x480)
        local pos = slotItem.view:convertToWorldSpace( CCPointMake(position[1],position[2]) );
        if show_item_panel.item_series == -1 or show_item_panel.item_series == -2 then
            TipsModel:show_shop_tip(pos.x, pos.y, show_item_panel.item_id)
        else
            ForgeModel:show_tips_by_series( show_item_panel.item_series, pos.x, pos.y )
        end
    end
    slotItem:set_click_event( f2 )

    -- 如果和选中的装备是同一个，就设置道具为不可选状态
    if ForgeModel:check_is_strengthen_mate( item_series ) then
        -- slotItem:set_slot_disable(  )

    end

    --显示信息:名称和数字
    local item_id_temp = nil
    local gem_item_id_need, prot_item_id_need = ForgeModel:get_strengthen_gem_prot_id(  )

    if item_date then
        local item_name = ForgeModel:get_item_name_with_color( item_date.item_id )
        local name_lable = UILabel:create_lable_2( item_name, 90, 60, font_size, ALIGN_LEFT )
        show_item_panel.view:addChild( name_lable )
        
        local num_lable = UILabel:create_lable_2( "#cffff00x "..1, 115, 20, font_size, ALIGN_LEFT ) -- [1003]="#cffff00数量:"
        show_item_panel.view:addChild( num_lable ) 

        if ForgeModel:check_item_is_gem( item_date.item_id ) then
            ForgeModel:set_strengthen_gem_id(item_date.item_id)
            ForgeModel:set_strengthen_gem_series( item_series )
        else
            ForgeModel:set_strengthen_prot_series( item_series )
            ForgeModel:set_strengthen_prot_id(item_date.item_id)
        end
    else
        item_id_temp = item_series
        print("item_series",item_series)
        if item_series == -1 then
            item_id_temp = gem_item_id_need
        elseif item_series == -2 then
            item_id_temp = prot_item_id_need
        end
        local item_name = ForgeModel:get_item_name_with_color( item_id_temp )
        local name_lable = UILabel:create_lable_2( item_name, 90, 68, font_size, ALIGN_LEFT )
        show_item_panel.view:addChild( name_lable )
        
        local temp_num = ItemModel:get_item_total_num_by_id( item_id_temp )
        local num_lable = ZLabel:create( nil, Lang.forge.tab_one.cur_num .. temp_num, 90, 45 )
        --UILabel:create_lable_2( "#cffff00x "..1, 115, 20, font_size, ALIGN_LEFT ) -- [1003]="#cffff00数量:"
        show_item_panel.view:addChild( num_lable.view ) 

        slotItem.set_base_date( item_id_temp )
        self:add_buy_but_to_show_panel( show_item_panel, item_id_temp)
        show_item_panel.item_id = item_id_temp
        -- local item_name = ForgeModel:get_item_name_with_color( item_id_temp )
        -- local name_lable = UILabel:create_lable_2( item_name, 90, 60, font_size, ALIGN_LEFT )
        -- show_item_panel:addChild( name_lable )           
        
    end

    -- ***************提供方法**************
    -- 设置该道具为选中状态 （灰色）
    show_item_panel.set_state = function( if_selected )
        if if_selected or item_series == -1 or item_series == -2 then
            -- slotItem:set_slot_disable(  )
        else
            -- slotItem:set_slot_enable(  )
        end
    end

    -- 重新更新数据
    show_item_panel.update_date = function(  )
      --   if item_series ~= -1 and item_series ~= -2 then
      --       local item_date_temp = ForgeModel:get_item_in_bag_or_body( item_series )
      --       slotItem.set_date( item_date_temp )
      -- -- print("@@@@@@@@@item_series=",item_series)
      
      --   -- if item_series == -1 or item_series == -2 then
      --       -- slotItem:set_base_date( item_id_temp )
      --   end
    end

    show_item_panel.item_series = item_series
    safe_retain(show_item_panel.view)
    self.show_item_panel_t[item_series] = show_item_panel
    return show_item_panel
end

-- 给一个显示面板加购买按钮 
function StrengthenRD:add_buy_but_to_show_panel( show_panel, item_id,Type)
    --xiehande 通用按钮修改  UIPIC_FORGE_061 ->UIPIC_COMMOM_001
    local but_1 = CCNGBtnMulTex:buttonWithFile( 135, 10, 62, 28, UILH_COMMON.button4 )

    local function but_1_fun(eventType,x,y)
        if eventType == TOUCH_CLICK then 
            ForgeModel:show_buy_win( item_id )
            return true
        end
        return true
    end
    -- 部分材料不能购买，只能合成。这时按钮是合成 按钮，跳至合成界面
    local function but_2_fun(eventType,x,y)
        if eventType == TOUCH_CLICK then 
            local win = UIManager:find_visible_window( "forge_win" )
            if win then
                win:goto_synth()
                return 
            end 
        end
        return true
    end

    local but_name 
    if _mate_item_id_no_buy_t[ item_id ] then
        but_1:registerScriptHandler(but_2_fun)    --注册
        but_name = LangGameString[1017] -- [1017]="合成"
    else --购买
        but_1:registerScriptHandler(but_1_fun)    --注册
        but_name = LangGameString[1016] -- [1016]="购买"
    end
    
    --按钮显示的名称
    local label_but_1 = ZLabel:create( but_1, but_name, 0, 0 )
    local but_1_size = but_1:getSize()
    label_but_1_size = label_but_1:getSize()
    label_but_1:setPosition( ( but_1_size.width - label_but_1_size.width ) / 2, ( but_1_size.height - label_but_1_size.height ) / 2 + 3 )
    --UILabel:create_lable_2(but_name, 0, 0, font_size, ALIGN_CENTER)
    --but_1:addChild( label_but_1 ) 

    show_panel.view:addChild(but_1)
end

-- 显示强化需要消耗的金钱
function StrengthenRD:show_need_money( ... )
    local cost = ForgeModel:get_strength_cost(  )
    if cost then
        self.label_t[ "need_money" ]:setString( color_yellow .. cost ) -- [1011]="消耗仙币：#c66ff66"
    else 
        self.label_t[ "need_money" ]:setString(color_yellow .. "0" )
    end
    self:check_action_but_able()
end

--刷新右侧下面面板的所有item.
function StrengthenRD:flash_all_item_r_dow(  )
    self:remove_all_item( )
    self:create_meta_slot( self.rifht_top_panel )
    self:show_need_money()
end

--清空面板所有item:  参数：panel_name ：面板的名称
function StrengthenRD:remove_all_item(  )
    self.rifht_top_panel:removeChild(self.r_down_scroll, true) 
    for key, show_item_panel in pairs(self.show_item_panel_t) do 
        safe_release(show_item_panel.view)
    end
    self.show_item_panel_t = {}
end

-- -- 更新选中状态  
function StrengthenRD:update_select_state(  )
    -- 必须先设置其他为有效装备
    -- for i, show_item_panel in pairs(self.show_item_panel_t) do 
    --     if ForgeModel:check_is_strengthen_mate( show_item_panel.item_series ) then
    --         show_item_panel.set_state( true )
    --     else 
    --         show_item_panel.set_state( false )
    --     end
    -- end
end

-- 设置强化按钮是否可以有效
function StrengthenRD:check_action_but_able(  )
    if ForgeModel:check_equip_can_strengthen(  ) then
        self.strengthen_but:setCurState( CLICK_STATE_UP )
    else
        self.strengthen_but:setCurState( CLICK_STATE_DISABLE )
    end

    local strengthen_item_date = ForgeModel:get_strengthen_item_date(  )
    if strengthen_item_date and strengthen_item_date.strong > 8 then
        _auto_buy_stone_btn.set_state(false, false)
        _auto_buy_stone_btn.set_enable(false)
    else
        _auto_buy_stone_btn.set_enable(true)
    end
end

-- 更新道具数据
function StrengthenRD:update_all_item_date(  )
    for key, show_item_panel in pairs(self.show_item_panel_t) do 
        -- print("更新道具数据=",key)
        show_item_panel.update_date()
    end
end

function StrengthenRD:destroy()
    for key, show_item_panel in pairs(self.show_item_panel_t) do 
        safe_release(show_item_panel.view)
    end
end

--xiehande
--装备强化 特效
function StrengthenRD:play_success_effect(  )
    -- body
    LuaEffectManager:play_view_effect( 10014,630,160,panel,false,999 )
end
