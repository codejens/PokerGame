-- MagicTreeCangkuWin.lua
-- created by chj on 2015-3-16
-- 昆仑神树窗口

require "UI/component/Window"
super_class.MagicTreeCangkuWin(NormalStyleWindow)

-- 控件table
local _items_object     = {};

-- 仓库的格子数
local slot_num_w = 5
local slot_num_h = 5

--底板尺寸
-- local _base_bg_size = CCSize(900, 605) 
local _win_big_w = 900
local _win_w = 456
local _win_h = 605
 -- 最大显示页数      
local _num_page_max = 5

--单元格尺寸 & 横向竖向的数量
local _slot_w = 82
local _slot_h = 82
-- local _slot_size = CCSize(70, 70) --单元格尺寸
-- local _slot_num_size = CCSize(9, 4) --单元格矩阵尺寸
local _slot_num_w = 5
local _slot_num_h = 5

-- 每页的个数 & 总个数
local _per_page_count = _slot_num_w*_slot_num_h
local _changku_sum = _per_page_count*_num_page_max

--单元格区域
local _slot_padding = {left=35, top=58, right=20, bottom=142} --单元格区域相对底板的间距 left top right bottom
 --单元格区域尺寸
local _slot_region_w = _win_w - _slot_padding.right - _slot_padding.left
local _slot_region_h = _win_h - _slot_padding.top - _slot_padding.bottom

--单元格区域相对底板的位置
local _slot_reg_rect_x = _slot_padding.left
local _slot_reg_rect_y = _win_h -_slot_padding.top - _slot_region_h
local _slot_reg_rect_w = _slot_region_w
local _slot_reg_rect_h = _slot_region_h

--翻页按钮
local _page_btn_padding = {left=38, bottom=32} --翻页按钮与二层底板的间距
local _page_btn_w = 56
local _page_btn_h = 35
-- local _page_btn_size = CCSize(56, 35) 

local _slot_bg_padding = {left=15, top=40, right=15, bottom=82} --单元格背景相对底板的间距
local _slot_bg_size = CCSize(  --单元格背景面板尺寸 二层底板
    _win_w - _slot_bg_padding.left - _slot_bg_padding.right, 
    _win_h - _slot_bg_padding.top - _slot_bg_padding.bottom)
local _slot_bg_pos = CCPoint(_slot_bg_padding.left, _slot_bg_padding.bottom) --单元格背景面板底部位置 二层底板

--页码
local _page_num_bg_padding={bottom=_page_btn_padding.bottom}
local _page_num_bg_size = CCSize(110, 30)
local _page_num = nil

--圈圈
-- local _circle_top_padding = 6 --圈圈与上部的间距
-- local _circle_size = CCSize(25, 25) --圈圈尺寸
-- local _circle_side_gap = 30 --圈圈的边距
-- local _circle_center_gap = _circle_side_gap + _circle_size.width --圈圈中心间隔 
-- local _circle_hui_image = UIPIC_BagWin_0005 --未选中的圈圈图片路径
-- local _circle_lan_image = UIPIC_BagWin_0006 --选中的圈圈图片路径

--全部取出按钮
local _getall_btn_padding = {top=15, right=110, bottom=24} --全部取出按钮与上部的间距
local _getall_btn_size = CCSize(121, 53) --全部取出按钮的尺寸
local _getall_btn_textfontsize = 16 --全部取出按钮的文本字体大小


--单元格垂直间距
local _slot_gap_v = (_slot_region_h-_slot_h*_slot_num_h)/(_slot_num_h-1) 

local _font_size = 16 --字体大小

-- UI end

-- =====================================
-- data -- start 
local current_page_num  = 1;

-- 版本遗漏，暂时放此处，方便更新
local t_tips = {
        [1] = Lang.Magictree[13],
        [2] = Lang.Magictree[14],
        [3] = Lang.Magictree[15],
    }

--创建物品项
local function create_item_obj (tag,x, y, width, height,icon,count,lock_flag)
    local item_obj = SlotBag( 65, 65 );
    item_obj:setPosition (x, y);
    item_obj:set_icon_texture(icon);
    item_obj:set_tag(tag);
    item_obj:set_count(count);
    item_obj:set_icon_size(65, 65);
    item_obj:set_icon_bg_texture(UIPIC_DREAMLAND.slot_item, -6, -6, _slot_w, _slot_h);

    local function item_use_function()
        -- local index = MagicTreeCangkuWin:get_item_index_in_model(current_page_num,item_obj:get_tag());
        local index_temp = MagicTreeCangkuWin:get_item_index_in_model(current_page_num, index)
        local cangku_model = MagicTreeModel:get_cangku_table()
        local item = cangku_model[index_temp]
        if item then
            -- DreamlandCC:request_moveItem_to_package(item.series);
            DreamlandModel:move_item_to_package(item.series)
        end
    end

    -- 道具双击事件回调,从仓库里取出单个物品
    local function item_double_clicked ()
        -- local fruit_index = nil
        -- local index_temp = MagicTreeCangkuWin:get_item_index_in_model(current_page_num, index)
        -- local cangku_model = MagicTreeModel:get_cangku_table()
        -- local item = cangku_model[index_temp]

        -- if item then
        --     fruit_index = MagicTreeModel:get_fruit_index_by_item_id( item.item_id)
        -- end
        -- -- print("----------fruit_index", fruit_index)
        -- if fruit_index then
        --     local str = MagicTreeConfig:get_cost_for_fruit( fruit_index) 
        --     ConfirmWin2:show( 4, nil, LH_COLOR[2] .. "需消耗" .. str, item_use_function, nil)
        -- else
        --     item_use_function()
        -- end

        -- -- local index = MagicTreeCangkuWin:get_item_index_in_model(current_page_num,item_obj:get_tag());
        -- local index_temp = MagicTreeCangkuWin:get_item_index_in_model(current_page_num, index)
        -- local cangku_model = MagicTreeModel:get_cangku_table()
        -- local item = cangku_model[index_temp]
        -- if item then
        --     -- DreamlandCC:request_moveItem_to_package(item.series);
        --     -- DreamlandModel:move_item_to_package(item.series)
        --     print( item.series)
        --     MagicTreeCC:req_use_item( item.series)
        -- end
        MagicTreeCC:req_to_bag_once( index)
    end

    local function cost_tip_func()
        -- local fruit_index = nil
        -- local index_temp = MagicTreeCangkuWin:get_item_index_in_model(current_page_num, index)
        -- local cangku_model = MagicTreeModel:get_cangku_table()
        -- local item = cangku_model[index_temp]

        -- if item then
        --     fruit_index = MagicTreeModel:get_fruit_index_by_item_id( item.item_id)
        -- end
        -- -- print("----------fruit_index", fruit_index)
        -- if fruit_index then
        --     local str = MagicTreeConfig:get_cost_for_fruit( fruit_index) 
        --     ConfirmWin2:show( 4, nil, LH_COLOR[2] .. "需消耗" .. str, item_use_function, nil)
        -- else
        --     item_use_function()
        -- end
        MagicTreeCC:req_to_bag_once( index)
    end

    item_obj:set_double_click_event(item_double_clicked);

    --道具单击事件回调
    local function item_clicked(  )
        -- local index = MagicTreeCangkuWin:get_item_index_in_model(current_page_num,item_obj:get_tag());
        -- local item_model = MagicTreeModel:get_item_in_cangku_by_index( index );
        local index_temp = MagicTreeCangkuWin:get_item_index_in_model(current_page_num, index)
        local item_model = MagicTreeModel:get_item_in_cangku_by_index( index_temp)
        -- 拼假数据，防止提示出错
        if item_model then
            item_model.void_bytes_tab = {};
            item_model.void_bytes_tab[1] = 1
            item_model.void_bytes_tab[2] = 0
            item_model.strong = 0
            item_model.holes = {}
            item_model.holes[1]       = 1
            item_model.holes[2]       = 1
            item_model.holes[3]       = 1
        end

        TipsModel:show_tip( 400, 240, item_model, cost_tip_func, nil, false, LH_COLOR[2] .. Lang.Magictree[18],nil, TipsModel.LAYOUT_LEFT ); -- [837]="取出"
    end
    item_obj:set_click_event(item_clicked);

    return item_obj;
end



--取出全部
local function get_all_out(eventType,x,y )
    if eventType == TOUCH_BEGAN then
        return true
    elseif eventType == TOUCH_CLICK then
        -- 0：意味着物品全部取出。
        -- DreamlandCC:request_moveItem_to_package(0);
        -- Instruction:handleUIComponentClick(instruct_comps.DREAMLAND_WAREHOUSE_TAKEALL)
        -- DreamlandModel:move_item_to_package(0);
        UIManager:show_window( "exchange_win")
        return true
    end
    return true
end

--计算当前页的tag在model数据中的index下标
function MagicTreeCangkuWin:get_item_index_in_model(_current_page_num, tag)
    -- print("点中了那个index",_current_page_num, tag, (_current_page_num-1)*_per_page_count+tag);
    return (_current_page_num-1)*_per_page_count+tag;
end


-- 初始化
function MagicTreeCangkuWin:__init( window_name, texture_name )

    -- 大背景 =============================
    self.panel_bg = CCBasePanel:panelWithFile( 10, 10, _win_big_w-20, _win_h-50, UILH_COMMON.normal_bg_v2, 500, 500 )
    self.view:addChild( self.panel_bg)

    -- 左面板
    self.panel_left = CCBasePanel:panelWithFile( 23, 23, _win_w-30, _win_h -75, UILH_COMMON.bottom_bg, 500, 500)
    self.view:addChild( self.panel_left)

    -- 右面板
    self.panel_right = CCBasePanel:panelWithFile( _win_w-8, 23, _win_big_w-_win_w-15, _win_h -75, UILH_COMMON.bottom_bg, 500, 500)
    self.view:addChild( self.panel_right)

    -- body
    self:initPanel(self.view);

    -- 兑换的物品
    self.exc_item_id = nil
end

function MagicTreeCangkuWin:initPanel( self_panel)
    local now_y= _slot_reg_rect_y + _slot_region_h - _slot_h
    local page_btn_bottom = 0  
    local ytest = math.ceil(_slot_num_h/2) 
    local v_num = _slot_num_h --垂直高度 单元格数
    local h_num = _slot_num_w --水平宽度 单元格数
    local slot_height = _slot_h --单元格高度
    for i = 1, v_num do        
        if i==ytest then
            if ytest%2==0 then
                page_btn_bottom = now_y - _slot_gap_v/2 - _page_btn_h/2
            else
                page_btn_bottom = now_y + _slot_h/2 - _page_btn_h/2
            end            
        end       
        --now_x = start_x
        if i<v_num then 
            now_y = now_y - slot_height - _slot_gap_v
        end
    end    

      
    --local left_btn_bottom = page_btn_bottom
    local left_btn_pos = CCPoint(_page_btn_padding.left, _page_btn_padding.bottom)
    
    --local right_btn_bottom = page_btn_bottom
    local right_btn_pos = CCPoint(_slot_bg_size.width - _page_btn_padding.left, _page_btn_padding.bottom)
    
    -- 物品背景九宫格底图
    local wupin_nine_grid = CCBasePanel:panelWithFile(_slot_bg_pos.x, _slot_bg_pos.y, _slot_bg_size.width, _slot_bg_size.height, "", 500, 500);
    self_panel:addChild(wupin_nine_grid);

    local start_x = 6  -- 单元格相对item_page开始x坐标
    local start_y = _slot_region_h - _slot_h + 6-- 单元格相对item_page开始y坐标
    local slot_width = _slot_w --单元格宽度
    local slot_height = _slot_h --单元格高度
    local gap_h = ( _slot_reg_rect_w - _slot_w*_slot_num_w)/(_slot_num_w-1)   --_slot_gap --单元格间隙
    --print("gap_h:" .. gap_h)
    local cursorx = start_x
    local cursory = start_y
    local v_num = _slot_num_h --垂直高度 单元格数
    local h_num = _slot_num_w --水平宽度 单元格数

    self.item_page = {}           
    self.item_page = CCBasePanel:panelWithFile( 
        _slot_reg_rect_x,  --单元格区域left
        _slot_reg_rect_y,  --单元格区域bottom
        _slot_region_w, --单元格区域宽度
        _slot_region_h, --单元格区域高度
        "" )  
    self_panel:addChild( self.item_page)

    --从仓库model里取出
    local c_tabel = MagicTreeModel:get_cangku_table();
    for i=1, _per_page_count do
        --每个物品格子的tag从1到25，定位具体哪一页的哪个物品需要乘以页数，current_page_num
        local item_icon = "";
        local count = 1;
        local lock_flag = nil;
         
        if c_tabel[i] ~= nil then
            item_icon = ItemConfig:get_item_icon(c_tabel[i].item_id);
            count = c_tabel[i].count;
            lock_flag = c_tabel[i].flag;
        end

        _items_object[i] = create_item_obj(i, cursorx, cursory, slot_width, slot_height, item_icon, count, lock_flag);
        
        self.item_page:addChild(_items_object[i].view)
        
        --坐标排列
        cursorx = cursorx + slot_width + gap_h
        if (i%_slot_num_w==0) then  -- 每5列换行
            cursorx = start_x
            cursory = cursory - slot_height - _slot_gap_v
        end
    end

    --左翻按钮
    -- local function left_but_callback()
    --     if current_page_num >1 then 
    --         current_page_num = current_page_num-1;
    --         --更新物品栏
    --         self:update_item(current_page_num);
    --     end
    --     return true
    -- end
    -- --右翻按钮
    -- local function right_but_callback()
    --     if current_page_num <5 then 
    --         current_page_num = current_page_num+1;
    --         --更新物品栏
    --         self:update_item(current_page_num);
    --     end
    --     return true
    -- end

    -- 左箭头按钮
    -- self.left_but = UIButton:create_button_with_name( 38, 32, -1, -1, 
    --     UIPIC_CangKuWin_0004, UIPIC_CangKuWin_0004, UIPIC_CangKuWin_0005, "", left_but_callback )
    -- --self.left_but:registerScriptHandler(left_page_btn_event)
    -- wupin_nine_grid:addChild(self.left_but.view)  
    -- self.left_but.set_double_click_func( left_but_callback )     
    -- self.left_but.view:addTexWithFile(CLICK_STATE_DISABLE, UIPIC_CangKuWin_0005 )
    -- self.left_but.view:setAnchorPoint(0, 0.5)

    -- 右箭头按钮
    -- self.right_but = UIButton:create_button_with_name( right_btn_pos.x, right_btn_pos.y, -1, -1, 
    --     UIPIC_CangKuWin_0004, UIPIC_CangKuWin_0004, UIPIC_CangKuWin_0005, "", right_but_callback )
    -- --self.right_but:registerScriptHandler(right_page_btn_event)
    -- self.right_but.set_double_click_func( right_but_callback )
    -- wupin_nine_grid:addChild(self.right_but.view)
    -- self.right_but.view:addTexWithFile(CLICK_STATE_DISABLE, UIPIC_CangKuWin_0005 )
    -- self.right_but.view:setAnchorPoint(1, 0.5)
    -- self.right_but.view:setFlipX(true)
    
    --页码
    -- ZImage:create(wupin_nine_grid, UILH_COMMON.bg_10,152, 16, 100, 30, 0, 500, 500)
    -- local page_num_bg = ZImage:create(
    --     wupin_nine_grid, UIPIC_DREAMLAND.text_bg2, _slot_bg_size.width/2, _page_num_bg_padding.bottom, 
    --     _page_num_bg_size.width, _page_num_bg_size.height, 999, 500 ,500)
    -- page_num_bg:setAnchorPoint(0.5, 0.5)
    -- _page_num = CCZXLabel:labelWithTextS(
    --     CCPointMake(_page_num_bg_size.width/2, _page_num_bg_size.height/2+2),  --_page_num_bg_size.width/2
    --     "", 
    --     _font_size,ALIGN_LEFT);
    -- _page_num:setAnchorPoint(CCPointMake(0.5, 0.5))
    -- page_num_bg:addChild(_page_num);

    -- 显示提示
    local panel_tip = CCBasePanel:panelWithFile(45, 100, 365, 35, UILH_NORMAL.title_bg4)
    self_panel:addChild( panel_tip)
    ZLabel:create( panel_tip, LH_COLOR[2] .. Lang.Magictree[16], 365 * 0.5, 10, 16, ALIGN_CENTER)

    
    --local btn_getall_pos = CCPointMake(_base_bg_size.width/2, _slot_bg_pos.y - _getall_btn_padding.top) --label的位置
    local btn_getall_pos = CCPointMake(340, _getall_btn_padding.bottom) --label的位置

    -- local function open_once_func( )
    --     -- 一键开启
    --     -- MagicTreeCC:req_use_item_once( )
    --     UIManager:show_window("magictree_win")
    -- end
    -- local back_dream = ZTextButton:create(self_panel, LH_COLOR[2] .. "返回神树", UILH_COMMON.btn4_nor, open_once_func, 35, 35, -1, -1)
    -- local btn_getall = CCNGBtnMulTex:buttonWithFile(
    --     btn_getall_pos.x, 35, _getall_btn_size.width, _getall_btn_size.height, 
    --     UIPIC_CangKuWin_0003, TYPE_MUL_TEX)
    -- btn_getall:setAnchorPoint(0.5, 0)
    -- self_panel:addChild(btn_getall)
    -- btn_getall:registerScriptHandler(get_all_out)
    -- local get_all_lab = MUtils:create_zxfont(
    --     btn_getall, LH_COLOR[2] .. "前往兑换", _getall_btn_size.width/2, _getall_btn_size.height/2+4, 
    --     ALIGN_CENTER, _getall_btn_textfontsize)
    -- get_all_lab:setAnchorPoint(CCPointMake(0, 0.5))

    -- [880]="#c00c0ff仓库空间"
    local cangku_lab_pos = CCPointMake(220, 10 + btn_getall_pos.y+_getall_btn_size.height)
    local cangku_lab = CCZXLabel:labelWithTextS(cangku_lab_pos, "", _font_size,ALIGN_CENTER);
    self_panel:addChild(cangku_lab);
    cangku_lab:setAnchorPoint(CCPointMake(0, 1))
    print("cangku_lab_pos:" .. cangku_lab_pos.x .. " " .. cangku_lab_pos.y)
    local cangku_lab_size = cangku_lab:getSize()
    local grid_count_str = string.format("%d/%d",#MagicTreeModel:get_cangku_table(),_changku_sum)
    local cangkuspace_count_pos = CCPointMake(580, cangku_lab_pos.y - cangku_lab_size.height - 5 + 20)
    cangku_grid_lab = CCZXLabel:labelWithTextS(cangkuspace_count_pos, grid_count_str, 20, ALIGN_CENTER);
    cangku_grid_lab:setAnchorPoint(CCPointMake(0, 1))
    self_panel:addChild(cangku_grid_lab);

    -- 放入背包按钮
    local function to_bag_func() 
        -- 判断仓库有没有东西
        local cangku_t = MagicTreeModel:get_cangku_table( )
        if #cangku_t > 0 then
            MagicTreeCC:req_to_bag()
        else
            GlobalFunc:create_screen_notic(LH_COLOR[2] .. Lang.Magictree[17])
        end
    end
    self.btn_to_bag = ZTextButton:create( self_panel, LH_COLOR[2] .. Lang.Magictree[18], UILH_COMMON.btn4_nor, to_bag_func, 170, 45, -1, -1, 1)

    -- 右面板
    self.box_btns = {}
    self.box_effects = {}
    

    for i=1, 3 do
        self:create_show_item( self_panel, i)
    end
    local panel_select_tip = CCBasePanel:panelWithFile( 445, 90, 300, 35, UILH_NORMAL.bg_red)
    self_panel:addChild( panel_select_tip)
    self.select_tip = ZLabel:create( panel_select_tip, LH_COLOR[2] .. Lang.Magictree[19], 150, 10, 12, ALIGN_CENTER)

    function exchange_func( )
        -- print("--------exchange_func", propId, activityId)
        if self.exc_item_id ~= nil then
            local activityId = MagicTreeModel:get_act_id( )
            OnlineAwardCC:reqExchangeProp(self.exc_item_id, activityId)
        else
            GlobalFunc:create_screen_notic( LH_COLOR[2] .. Lang.Magictree[20])
        end
    end
    -- 兑换按钮
    self.btn_exc_rank = ZTextButton:create( self_panel, LH_COLOR[2] .. Lang.Magictree[21], UILH_COMMON.b_bg_n, exchange_func, 740, 50, 100, 100, 1)

    -- self:update(1);
end


-- 创建有面板展示item
function MagicTreeCangkuWin:create_show_item( panel, index)
    local box_imgs = MagicTreeConfig:get_magictree_boximg( )
    local panel_item = CCBasePanel:panelWithFile( 450, 420-(index-1)* 130, 400, 120, "" )
    panel:addChild( panel_item)

    local panel_bg = CCBasePanel:panelWithFile(35, 10, -1, -1, UILH_NORMAL.skill_bg_b)
    panel_item:addChild( panel_bg, 1)

    local txt = MagicTreeConfig:get_magictree_item_lable( )
    local box_names = MagicTreeConfig:get_magictree_box_name( )

    -- 点击宝箱
    local function get_box_func(eventType, arg, msgid, selfitem)
        if eventType == nil or arg == nil or msgid == nil or selfitem == nil then
            return
        end
        if eventType == TOUCH_BEGAN then
            print("--------get_box_func")
            local box_ids =  MagicTreeConfig:get_magictree_box_id( )
            self.exc_item_id = box_ids[index]
            self.select_tip.view:setText( Lang.Magictree[22] .. box_names[index] .. Lang.Magictree[23] .. txt[index] .. "积分")
            -- 特效
            for i=1, #self.box_effects do
                self.box_effects[i]:setIsVisible(false)
            end
            self.box_effects[index]:setIsVisible(true)
            return true
        elseif eventType == TOUCH_CLICK then
            return true;
        end
        return true;
    end
    self.box_btns[index] = CCBasePanel:panelWithFile(45, 20, -1, -1, box_imgs[index])
    panel_item:addChild( self.box_btns[index], 2)
    self.box_btns[index]:registerScriptHandler( get_box_func)

    -- 特效
    self.box_effects[index] = LuaEffectManager:play_view_effect( 11041, 38, 35, self.box_btns[index], true)
    self.box_effects[index]:setScale(1.2)
    self.box_effects[index]:setIsVisible(false)

    ZLabel:create( panel_item, LH_COLOR[2] .. Lang.Magictree[24] .. txt[index] .. Lang.Magictree[25], 160, 95, 12, ALIGN_LEFT)

    local name_bg = CCBasePanel:panelWithFile(75, 55, 300, 40, UILH_NORMAL.title_bg)
    panel_item:addChild( name_bg)


    ZLabel:create( name_bg, LH_COLOR[2] .. box_names[index], 150, 10, 20, ALIGN_CENTER)

    local item_imgs = MagicTreeConfig:get_magictree_itemimg( )
    local item_img = CCBasePanel:panelWithFile( 132, 30, -1, -1, item_imgs[index] )
    item_img:setScale(0.7)
    panel_item:addChild( item_img)

    -- 更新添加
    ZLabel:create( panel_item, LH_COLOR[2] .. t_tips[index], 130, 15, 12, ALIGN_LEFT)
end

-- 更新数据： 参数：更新的类型
function MagicTreeCangkuWin:update( update_type )
    if update_type == "point" then
        local cur_point = MagicTreeModel:get_point( )
        cangku_grid_lab:setText( LH_COLOR[2] .. Lang.Magictree[26] .. LH_COLOR[6] .. cur_point);
    else
        self:update_item( current_page_num)
    end
end

-- 更新道具
function MagicTreeCangkuWin:update_item( cur_page_num)

    --更新仓库格子数量
    -- local grid_count_str = string.format("%d/%d",#MagicTreeModel:get_cangku_table(), _changku_sum);
    -- 积分
    local num_point = MagicTreeModel:get_point( )
    cangku_grid_lab:setText( LH_COLOR[2] .. Lang.Magictree[26] .. LH_COLOR[6] .. num_point);

    -- local pagenumstr = string.format("#cd58a08%d/%d", cur_page_num, _num_page_max)
    -- _page_num:setText(pagenumstr)

    local model_index = self:get_item_index_in_model( cur_page_num,1);
    -- local model_index = 1
    for i=model_index, model_index+_per_page_count-1 do
        --视图容器的索引
        local item_index = i%_per_page_count;
        if item_index == 0 then
            item_index = _per_page_count;
        end
        --取出对于视图对象
        local item = _items_object[item_index];
        --仓库model
        local cangku_model = MagicTreeModel:get_cangku_table();
        --物品model
        local item_model = cangku_model[i];
        --开始更新视图
        if item_model ~= nil and item ~= nil then
            local item_icon = ItemConfig:get_item_icon(item_model.item_id)
            -- local item_icon = MagicTreeModel:get_icon_by_id( item_model.item_id )
            -- print("-------item_icon:", item_icon)
            item.icon:setIsVisible(true)
            item:set_icon_texture(item_icon)
            item:set_count(item_model.count)
            item:set_color_frame( item_model.item_id, 2, 2, 65, 65 )
            item:set_gem_level( item_model.item_id )
            -- 是否绑定(锁)
            if item_model.flag ==1 then
                item:set_lock(true)         
            else
                item:set_lock(false)
            end
        else
            item.icon:setIsVisible(false)
            item:set_count(0)
            item:set_color_frame( nil )
            item:set_gem_level( nil )
            item:set_lock(false)
        end
    end

    -- 如果已经到了上一页，或者最后一页，就变暗
    -- local page_index = _current_page_num
    -- if page_index == 1 then 
    --     self.left_but.view:setCurState( CLICK_STATE_DISABLE )        
    --     self.right_but.view:setCurState( CLICK_STATE_UP )   
    --     --print("first page")     
    -- elseif page_index == _max_page_index then  
    --     self.left_but.view:setCurState( CLICK_STATE_UP )          
    --     self.right_but.view:setCurState( CLICK_STATE_DISABLE )   
    --    -- print("last page")       
    -- else
    --     self.left_but.view:setCurState( CLICK_STATE_UP )        
    --     self.right_but.view:setCurState( CLICK_STATE_UP )     
    --    -- print("middle page")     
    -- end
end

--
function MagicTreeCangkuWin:active( show )

end



function MagicTreeCangkuWin:destroy()
    Window.destroy(self)
end
