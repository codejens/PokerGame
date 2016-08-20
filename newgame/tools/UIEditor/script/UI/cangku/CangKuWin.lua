-- 
-- filename: CangKuWin.lua
-- created by liuguowang on 2014-3-25
-- 仓库窗口


super_class.CangKuWin(NormalStyleWindow);


local _win_name = "cangku_win"
local _base_bg_size = CCSize(435, 605) --底板尺寸
local _max_page_index = 5           -- 最大显示页数

--单元格
local _slot_size = CCSize(65, 65) --单元格尺寸
local _slot_num_size = CCSize(5, 5) --单元格矩阵尺寸
--local _slot_gap_v = 20 --单元格垂直间距

--单元格背景
local _slot_bg_padding = {left=15, top=40, right=15, bottom=10} --单元格背景相对底板的间距
local _slot_bg_size = CCSize(  --单元格背景面板尺寸 二层底板
    _base_bg_size.width - _slot_bg_padding.left - _slot_bg_padding.right, 
    _base_bg_size.height - _slot_bg_padding.top - _slot_bg_padding.bottom) 
local _slot_bg_pos = CCPoint(_slot_bg_padding.left, _slot_bg_padding.bottom) --单元格背景面板底部位置 二层底板
local _slot_bg_region = nil

--扩展图片
local _slot_kuozhan_size = CCSize(50, 50) --"点击可扩展"图片尺寸
local _slot_kuozhan_image = {UILH_BAG_AND_CANGKU.dian,    --"点击可扩展"图片路径
                            UILH_BAG_AND_CANGKU.ji,
                            UILH_BAG_AND_CANGKU.ke, 
                            UILH_BAG_AND_CANGKU.kuo,
                            UILH_BAG_AND_CANGKU.zhan}
--翻页按钮
local _page_btn_padding = {left=38, bottom=96} --翻页按钮与底板的间距
local _page_btn_size = CCSize(-1, -1) --翻页按钮尺寸

--页码
local _page_num_bg_padding={bottom=_page_btn_padding.bottom}
local _page_num_bg_size = CCSize(110, 30)
local _page_num=nil

--圈圈
local _circle_top_padding = 25 --圈圈与上部的间距
local _circle_size = CCSize(25, 25) --圈圈尺寸
local _circle_side_gap = 30 --圈圈的边距
local _circle_center_gap = _circle_side_gap + _circle_size.width --圈圈中心间隔 
local _circle_hui_image = UILH_COMMON.fy_bg --未选中的圈圈图片路径
local _circle_lan_image = UILH_COMMON.fy_select --选中的圈圈图片路径

--整理按钮
local _arrange_btn_padding = {bottom=23} --整理按钮与上部的间距
local _arrange_btn_size = CCSize(95, 50) --整理按钮的尺寸
local _font_size = 16 --整理按钮的文本字体大小

--单元格区域
local _slot_region_padding = {left=15, top=15, right=15, bottom=82} --单元格区域相对二层底板的间距 left top right bottom
local _slot_region_size = CCSize(   --单元格区域尺寸
    _slot_bg_size.width - _slot_region_padding.right - _slot_region_padding.left,
    _slot_bg_size.height - _slot_region_padding.top - _slot_region_padding.bottom)
local _slot_region_rect = CCRect(  --单元格区域相对底板的位置
    _slot_region_padding.left,  --left
    _slot_region_padding.bottom,  --bottom
    _slot_region_size.width,  --宽度
    _slot_region_size.height  --高度
    )
local _slot_gap_size = CCSize(
        (_slot_region_rect.size.width - _slot_size.width*_slot_num_size.width)/(_slot_num_size.width-1), 
        (_slot_region_rect.size.height - _slot_size.height*_slot_num_size.height)/(_slot_num_size.height-1)-62/4 )

local _icon_offset=4
local _icon_offset2=_icon_offset*2
-- 点击右上角关闭按钮是关闭仓库窗口
-- local function cangku_win_cb_close(eventType, x, y)
--     if (eventType == TOUCH_CLICK) then
--         UIManager:hide_window(_win_name);
--     end

--     return true;
-- end

-- 整理按钮回调
local function arrange_cangku_item( eventType, x, y )
    --if eventType == TOUCH_CLICK then
        CangKuItemModel:item_arrange(  )
        CangKuItemModel:request_arrange_cangku(  )
        --print("call arrange_cangku_item")
    --end
    --print("arrange_cangku_item eventType:#" .. eventType .. "#")
    return true
end

-- 创建仓库窗口,(背景图名称)
function CangKuWin:create_loadenter(panel)

    --local now_x=0
    local now_y=_slot_region_rect.origin.y + _slot_region_size.height - _slot_size.height
    local page_btn_bottom = 0
    local ytest = math.ceil(_slot_num_size.height/2)
    --print ("ytest:" .. ytest)
    local v_num = _slot_num_size.height --垂直高度 单元格数
    local h_num = _slot_num_size.width --水平宽度 单元格数
    local slot_height = _slot_size.height --单元格高度
    for i = 1, v_num do         
        if i==ytest then
            if ytest%2==0 then
                --page_btn_bottom = now_y - _slot_gap_size.height/2 - _page_btn_size.height/2
            else
                --page_btn_bottom = now_y + _slot_size.height/2 - _page_btn_size.height/2
            end            
        end       
        --now_x = start_x
        if i<v_num then 
            now_y = now_y - slot_height - _slot_gap_size.height
        end
    end

    
    -- local left_btn_size = _page_btn_size
    -- local left_btn_bottom = page_btn_bottom
    -- local left_btn_pos = CCPoint(_page_btn_padding.left, page_btn_bottom) --CCPoint(14, 362)
    
    -- local right_btn_size = _page_btn_size
    -- local right_btn_bottom = page_btn_bottom
    -- local right_btn_pos = CCPoint(_base_bg_size.width - _page_btn_size.width - _page_btn_padding.right, right_btn_bottom) --CCPoint(399, 362)
    

    local left_btn_pos = CCPoint(_page_btn_padding.left, _page_btn_padding.bottom)    
    local right_btn_pos = CCPoint(_slot_bg_size.width - _page_btn_padding.left, _page_btn_padding.bottom)

    --二层底板
    _slot_bg_region = CCBasePanel:panelWithFile( _slot_bg_pos.x, _slot_bg_pos.y, _slot_bg_size.width, _slot_bg_size.height, UILH_COMMON.normal_bg_v2, 500, 500)
    panel:addChild(_slot_bg_region)   


    -- 页数指示
    -- 左翻页
    local function left_but_callback()
        self:change_to_pre_page()
    end
    self.left_but = UIButton:create_button_with_name( left_btn_pos.x, left_btn_pos.y, _page_btn_size.width, _page_btn_size.height, 
        UILH_COMMON.page, UILH_COMMON.page, UILH_COMMON.page_disable, "", left_but_callback )
    _slot_bg_region:addChild(self.left_but.view )
    self.left_but.set_double_click_func( left_but_callback )
    --self.left_but.view:setFlipX(true)
    --self.left_but.view:setFlipY(true)
    self.left_but.view:addTexWithFile(CLICK_STATE_DISABLE, UILH_COMMON.page_disable )
    self.left_but.view:setAnchorPoint(0, 0.5)

    -- 右翻页
    local function right_but_callback()
        self:change_to_next_page()
    end
    self.right_but = UIButton:create_button_with_name( right_btn_pos.x, right_btn_pos.y, _page_btn_size.width, _page_btn_size.height, 
        UILH_COMMON.page, UILH_COMMON.page, UILH_COMMON.page_disable, "", right_but_callback )
    _slot_bg_region:addChild( self.right_but.view )    
    self.right_but.set_double_click_func( right_but_callback )  -- 双击
    self.right_but.view:addTexWithFile(CLICK_STATE_DISABLE, UILH_COMMON.page_disable )
    self.right_but.view:setAnchorPoint(1, 0.5)
    --self.right_but.view:setFlipY(true)
    self.right_but.view:setFlipX(true)
    
    -- 点数
    local function circle_callback_func( page_index )
        if page_index then
            self:change_item_page_by_index( page_index )
        end
    end

    
    local circle_num = _max_page_index

    local circle_x = _slot_bg_pos.x + (_slot_bg_size.width - (_circle_size.width+_circle_center_gap*(circle_num-1)))/2  --圈圈的绝对x坐标
    local circle_y = now_y - _circle_top_padding - _circle_size.height  --_slot_bg_pos.y + _height_circle_bg --圈圈的绝对y坐标
    --print("circle_x:#" .. circle_x .. "# circle_y:#" .. circle_y .. "#")


    --self.show_page_circle = MUtils:create_page_circle( circle_x, circle_y, _max_page_index, 
        --_circle_hui_image, _circle_lan_image, _circle_size.width, _circle_size.height, _circle_center_gap, circle_callback_func )
    --panel:addChild( self.show_page_circle.view )  -- 双击

    local page_num_bg = ZImage:create(
        _slot_bg_region, UILH_NORMAL.text_bg2, _slot_bg_size.width/2, _page_num_bg_padding.bottom, 
        _page_num_bg_size.width, _page_num_bg_size.height, 999, 500 ,500)
    page_num_bg:setAnchorPoint(0.5, 0.5)
    _page_num = CCZXLabel:labelWithTextS(
        CCPointMake(_page_num_bg_size.width/2, _page_num_bg_size.height/2+2),  --_page_num_bg_size.width/2
        "", _font_size, ALIGN_LEFT);
    _page_num:setAnchorPoint(CCPointMake(0.5, 0.5))
    page_num_bg:addChild(_page_num)


    -- 整理按钮背景   
    local arrange_btn_left = _slot_bg_pos.x + (_slot_bg_size.width - _arrange_btn_size.width)/2  --整理按钮的左边位置  165
    --local arrange_btn_bottom = circle_y - _arrange_btn_top_padding - _arrange_btn_size.height
    --local arrange_btn_bottom = _arrange_btn_padding.bottom
    local arrange_btn_pos = CCPointMake(_base_bg_size.width/2, _arrange_btn_padding.bottom)
    local arrange_btn = ZTextButton:create(panel, Lang.cangku.arrange_btn_text, UILH_COMMON.lh_button2, 
        arrange_cangku_item, arrange_btn_pos.x, arrange_btn_pos.y, _arrange_btn_size.width, _arrange_btn_size.height)
    arrange_btn:setFontSize(_font_size) --设置字体大小
    arrange_btn.view:setAnchorPoint(0.5, 0)
    -- local arrange_btn = MUtils:create_btn(panel, UIPIC_CangKuWin_0003, UIPIC_CangKuWin_0006, arrange_cangku_item,
    --     arrange_btn_left, arrange_btn_bottom, _arrange_btn_size.width, _arrange_btn_size.height)   
    -- MUtils:create_zxfont(arrange_btn, Lang.cangku.arrange_btn_text, _arrange_btn_size.width/2, _arrange_btn_size.height/2 - _font_size/2, ALIGN_CENTER, _font_size)
    
    --local arrange_btn = CCNGBtnMulTex:buttonWithFile( arrange_btn_left, arrange_btn_bottom, _arrange_btn_size.width, _arrange_btn_size.height, UIPIC_COMMOM_002, TYPE_MUL_TEX);
    --panel:addChild(arrange_btn)

    return panel;
end

--初始化仓库窗口
function CangKuWin:__init( window_name, texture_name, is_grid, width, height )
    self.item_page_t = {}             -- 存放页的表
    self.item_slot_t = {}            -- 存放所有已经创建的slot，key 对应背包位置. 这样就不用每次滑动都创建了。但要注意release
    self.current_page_index = 1       -- 当前页

    self.view = self:create_loadenter(self.view)  -- 初始化构建控件

    CangKuItemModel:request_cangku_model(  )       -- 创建窗口时，要初始化仓库的数据

    self:change_item_page_by_index( 1 )
    
    -- 服务器有点bug，先实验用
    -- CangKuItemModel:set_items_date( ItemModel:get_bag_data() )
end

-- 创建一页
function CangKuWin:create_one_item_page( page )
    local item_page = {}           
    item_page.view = CCBasePanel:panelWithFile( 
        _slot_region_rect.origin.x,  --单元格区域left
        _slot_region_rect.origin.y-4,  --单元格区域bottom
       _slot_region_size.width, --单元格区域宽度
       _slot_region_size.height, --单元格区域高度
        "" )  


    local start_x = 0  -- 单元格相对item_page开始x坐标
    local start_y = _slot_region_size.height - _slot_size.height-- 单元格相对开始y坐标
    local slot_width = _slot_size.width --单元格宽度
    local slot_height = _slot_size.height --单元格高度
    
    --print("gap_h:" .. gap_h)
    local now_x = start_x
    local now_y = start_y
    local v_num = _slot_num_size.height --垂直高度 单元格数
    local h_num = _slot_num_size.width --水平宽度 单元格数

    --print("start_x start_y " .. start_x .. " " .. start_y)
    --local ytest = math.ceil(_slot_num_size.height/2)
    for i = 1, v_num do
        for j = 1, h_num do 
            local index = (i - 1) * h_num + j + (page - 1) * v_num * h_num
            local item_slot = self:create_item_slot( now_x, now_y, slot_width, slot_height, index )
            item_page.view:addChild( item_slot.view )

            --print("now_x, now_y " .. now_x .. " " .. now_y)
            now_x = now_x + slot_width + _slot_gap_size.width
        end
        now_x = start_x
        --if i<v_num then 
            now_y = now_y - slot_height - _slot_gap_size.height
        --end
    end
    return item_page
end

-- 上一页
function CangKuWin:change_to_pre_page(  )
    if self.current_page_index - 1 > 0 then
        self:change_item_page_by_index( self.current_page_index - 1 )
    end
end

-- 下一页
function CangKuWin:change_to_next_page(  )

    --print("change_to_next_page")
    if self.current_page_index < _max_page_index then
       self:change_item_page_by_index( self.current_page_index + 1 )
    end
end

-- 切换道具页，如果还没有，会创建
function CangKuWin:change_item_page_by_index( page_index )
    -- 先隐藏
    for key, one_page in pairs(self.item_page_t) do
        one_page.view:setIsVisible( false )
    end

    -- 创建
    if self.item_page_t[page_index] == nil then
        self.item_page_t[page_index] = self:create_one_item_page(page_index)
        _slot_bg_region:addChild( self.item_page_t[page_index].view )
    end
    
    -- 显示
    if self.item_page_t[page_index] then
        self.item_page_t[page_index].view:setIsVisible( true )
    end

    self.current_page_index = page_index
    
    --self.show_page_circle.change_page_index( self.current_page_index )
    local pagenumstr = string.format("%d/%d", page_index, _max_page_index)
    _page_num:setText("#cD7A755"..pagenumstr)

        -- 如果已经到了上一页，或者最后一页，就变暗
    if page_index == 1 then 
        self.left_but.view:setCurState( CLICK_STATE_DISABLE )        
        self.right_but.view:setCurState( CLICK_STATE_UP )   
        --print("first page")     
    elseif page_index == _max_page_index then  
        self.left_but.view:setCurState( CLICK_STATE_UP )          
        self.right_but.view:setCurState( CLICK_STATE_DISABLE )   
        --print("last page")       
    else
        self.left_but.view:setCurState( CLICK_STATE_UP )        
        self.right_but.view:setCurState( CLICK_STATE_UP )     
        --print("middle page")     
    end
end


-- 创建道具显示对象
-- item_id: 物品ID
-- x, y, w, h: 坐标及尺寸大小
function CangKuWin:create_item_slot (x, y, width, height, index)
   -- 如果已经创建过，就不再创建
    if self.item_slot_t[ index ] then
        return self.item_slot_t[ index ]
    end

    -- 基本的显示
    local item_obj = SlotBag(width, height);
    item_obj.index = index
    item_obj:set_icon_bg_texture( UILH_COMMON.slot_bg, -_icon_offset2, -_icon_offset2, _slot_size.width+_icon_offset2*2, _slot_size.height+_icon_offset2*2 )   -- 背框
    item_obj:setPosition(x, y);
    item_obj:set_icon_texture("");
    item_obj:set_select_effect_state( true )
    item_obj.grid_had_open = true                        -- 标记该格子是否已经开启

    -- 位置超出最大格子数的情况
    local max_grid_num = CangKuItemModel:get_cangku_max_grid_num(  )
    if index > max_grid_num then
        self:set_slot_not_open( item_obj, index - max_grid_num )  -- 设置未开启状态
    end

    -- 背包该位置有数据才显示
    local item_date = CangKuItemModel:get_item_by_position( index )
    if item_date then
        item_obj.item_date = Utils:table_clone( item_date )
        item_obj.item_base  = CangKuItemModel:get_item_base_by_id( item_date.item_id )             -- 基础数据

        -- slot 具体道具的显示
        item_obj:set_drag_info( 1, _win_name, item_obj.item_date) -- 设置拖动传入的信息
        item_obj:set_icon (item_date.item_id);
        item_obj:set_lock( item_date.flag == 1 )         -- 是否绑定(锁)
        item_obj:set_color_frame( item_date.item_id, 0, 0, 65, 65 )    -- 边框颜色
        item_obj:set_item_count( item_date.count )       -- 数量
        -- 背包中的秘籍道具，不显示强化等级 add by gzn
        if item_obj.item_base ~= nil and item_obj.item_base.type == ItemConfig.ITEM_TYPE_SKILL_MIJI then
            
        else
            item_obj:set_strong_level( item_date.strong )    -- 强化等级
        end
        -- item_obj:set_strong_level( item_date.strong )    -- 强化等级
        item_obj:set_gem_level( item_date.item_id )      -- 宝石的等级
    end

    -- 道具双击事件回调
    local function item_double_clicked ()
        CangKuItemModel:item_double_click( item_obj )
    end
    -- 单击回调函数
    local function item_click_fun ()
        CangKuItemModel:item_click( item_obj )
    end
    local function drag_out( self_item )
        -- item_obj:set_icon_texture("");
    end
    local function drag_in( source_item )
        -- print("仓库~~~~~~~~~drag_in~~~~~", source_item.win, source_item, source_item.obj_data.item_id )
        local source_win = source_item.win      -- 源窗口的名称
        -- 在本窗口内拖动， 就直接在dragin方法中给处理。直接改变两个slot的显示
        if source_win == _win_name then
            local slotitem_source = self:get_slot_by_series( source_item.obj_data.series )   
            -- 如果是窗口内拖动，就交换位置. 源必须有物品，否则就不会有任何交换
            if slotitem_source and item_obj.grid_had_open then
                -- 如果是同一类物品（id一样），并且是否锁定也一样，就合并
                if item_obj.item_date and item_obj.item_date.item_id == source_item.obj_data.item_id and item_obj.item_date.flag == source_item.obj_data.flag then
                    CangKuCC:req_merge_items( item_obj.item_date.series, source_item.obj_data.series  )
                end
                -- item_obj.slot_index：本slot的index，  source_item.obj_data： 拖进来的数据， slotitem_source.slot_index：源的index， item_obj.obj_data 本slot数据
                CangKuItemModel:change_item_by_index( item_obj.index, source_item.obj_data, slotitem_source.index, item_obj.item_date )
            end
        -- 背包窗口拖进来的
        elseif source_win == "bag_win" then
            CangKuItemModel:item_drag_in_from_bag( source_item, item_obj )
        end
    end
    local function drag_callback( target_win )
        -- 成功拖到其他地方，把这个slot置空.  
        if target_win ~= _win_name then
            -- CangKuWin:init_one_slotItem( item_obj )
        end
    end
    local function drag_invalid_callback(drag_object )
        -- drag_object:set_icon_texture(ItemConfig:get_item_icon(drag_object.obj_data.item_id));
    end 
    local function discard_item_callback( drag_object )
    end

    item_obj:set_double_click_event(item_double_clicked);
    item_obj:set_click_event(item_click_fun)
    item_obj:set_drag_out_event(drag_out)
    item_obj:set_drag_in_event(drag_in)
    item_obj:set_drag_in_callback(drag_callback)
    item_obj:set_drag_invalid_callback(drag_invalid_callback);
    item_obj:set_discard_item_callback(discard_item_callback);

    -- scroll 在看不到的时候，会把slot的view销毁。这里 引用加1 ，不让销毁。但要记得要在窗口destroy的时候，release
    safe_retain(item_obj.view)
    self.item_slot_t[ index ] = item_obj
    return item_obj;
end

-- 根据一个item model数据来设置slot
function CangKuWin:set_one_slotItem_by_item_date( slotitem, item_date, slot_index )
    -- print("print先保留，测试背包开启的刷新平率使用：：：根据一个item model数据来设置slot")
    if item_date == nil then
        self:init_one_slotItem( slotitem )
        return 
    end
    slotitem.item_date = Utils:table_clone( item_date )
    --require "config/ItemConfig" 
    local item_base = ItemConfig:get_item_by_id( item_date.item_id )
    if item_base ~= nil then
        slotitem.item_base = item_base
    end
    slotitem.slot_index = slot_index                 -- 序列号，用来找到格子和数据的对应关系
    slotitem:set_drag_info( 1, _win_name, item_date) -- 设置拖动传入的信息
    slotitem:set_icon (item_date.item_id);
    slotitem:set_lock( item_date.flag == 1 )         -- 是否绑定(锁)
    slotitem:set_color_frame( item_date.item_id, 2, 2, 65, 65  )    -- 边框颜色
    slotitem:set_item_count( item_date.count )       -- 数量
    -- 背包中的秘籍道具，不显示强化等级 add by gzn
    if item_base ~= nil and item_base.type == ItemConfig.ITEM_TYPE_SKILL_MIJI then

    else
        slotitem:set_strong_level( item_date.strong )    -- 强化等级
    end
    -- slotitem:set_strong_level( item_date.strong )    -- 强化等级
    slotitem:set_gem_level( item_date.item_id )      -- 宝石的等级
    slotitem.grid_had_open = true
    slotitem:set_select_effect_state( true )
end

-- 设置一个slotitem为空
function CangKuWin:init_one_slotItem( slotitem )
    slotitem.item_date = nil
    slotitem.item_base = nil

    slotitem:set_drag_info( 1, _win_name, nil)
    slotitem:set_icon_texture("");
    slotitem:set_lock( false )
    slotitem:set_color_frame( nil )
    slotitem:set_item_count( 0 )
    slotitem:set_strong_level( 0 ) 
    slotitem:set_gem_level( nil )
    slotitem.grid_had_open = true
    slotitem:set_select_effect_state( false )

    if slotitem.bag_lock_pic then
        slotitem.view:removeChild( slotitem.bag_lock_pic, true )
        slotitem.bag_lock_pic = nil
    end

    if slotitem.not_open_word then
        slotitem.view:removeChild( slotitem.not_open_word, true )
        slotitem.not_open_word = nil          -- 必须设置为nil，单击是否弹出扩展提示，根据这个来
    end
end

-- 设置一个slotitem为未开启,  未开启格子前五个，要显示几个字: 点击可扩展
function CangKuWin:set_slot_not_open( slotitem, count)
    -- print("设置一个slotitem为未开启,  未开启格子前五个，要显示几个字: 点击可扩展")
    self:init_one_slotItem( slotitem )

    -- slotitem:set_icon_texture(UIResourcePath.FileLocate.normal .. "item_bg22.png")
    -- edited by aXing on 2014-4-19
    -- icon有缩放，所以不能用以前的set_icon_texture的方法
    if slotitem.bag_lock_pic == nil then
        slotitem.bag_lock_pic = CCZXImage:imageWithFile( -_icon_offset2, -_icon_offset2, _slot_size.width+_icon_offset2*2, _slot_size.height+_icon_offset2*2 , UILH_BAG_AND_CANGKU.wkq)
        slotitem.view:addChild( slotitem.bag_lock_pic, 4 )
    end

    slotitem.grid_had_open = false                        -- 标记该格子是否已经开启
    slotitem:set_select_effect_state( false )
    -- 文字
    
    if count <= 5 and count >= 1 then
        if slotitem.not_open_word == nil then
            slotitem.not_open_word = CCZXImage:imageWithFile( (_slot_size.width - _slot_kuozhan_size.width)/2, (_slot_size.height - _slot_kuozhan_size.height)/2, -1, -1, _slot_kuozhan_image[count] )
            slotitem.view:addChild( slotitem.not_open_word, 5 )
        end
    end
end


-- 根据 series 找到一个当前显示的slot
function CangKuWin:get_slot_by_series( series )
    -- for i = 1, #self.item_slot_t do
    --     if self.item_slot_t[i].item_date and self.item_slot_t[i].item_date.series == series then
    --         return self.item_slot_t[i]
    --     end
    -- end
    for key, item_slot in pairs(self.item_slot_t) do
        if item_slot.item_date and item_slot.item_date.series == series then
            return item_slot
        end
    end
end

function CangKuWin:active( if_show )
    if if_show then
        self:update("")
        SlotEffectManager.stop_current_effect()
        UIManager:show_window("bag_win")
    end
end

-- 更新仓库窗口，数据变更时，提供给其他地方使用
function CangKuWin:update_cangku_win( update_type )
    local win = UIManager:find_visible_window(_win_name)
    if win then
        win:update( update_type ); 
    end
end

-- 更新数据, 参数：类型:  cangku   player  
function CangKuWin:update( update_type )
    if update_type == "cangku" then         -- 仓库数据更新
        self:update_cangku()
    elseif update_type == "player" then     -- 玩家数据更新
        self:update_cangku()
    else                                    -- 全部更新
        self:update_cangku()
    end
end

-- 仓库数据变动引起的更新
function CangKuWin:update_cangku(  )
    -- print("同步和仓库不一样道具的显示")
    local item_slot = nil          -- 临时变量
    local item_date = nil          -- 临时变量
    local max_grid_num = CangKuItemModel:get_cangku_max_grid_num(  )
    -- print("max_grid_num::", max_grid_num)
    for i = 1, max_grid_num + 5 do
        item_slot = self.item_slot_t[i]
        if item_slot then
            -- print( 1, ":: ", i )
            if not CangKuItemModel:check_item_date_if_same( i, item_slot.item_date ) then    -- 判断界面显示数据是否和最新数据一样
                item_date = CangKuItemModel:get_item_by_position( i )
                self:set_one_slotItem_by_item_date( item_slot, item_date, i ) 
            end

            -- 检查是否是“点击可扩展”的位置，如果不是就要去掉，是就加上
            if i > max_grid_num then
                self:set_slot_not_open( item_slot, i - max_grid_num )      -- 设置未开锁状态            
            else
                if item_slot.not_open_word then
                    item_slot.view:removeChild( item_slot.not_open_word, true )
                    item_slot.not_open_word = nil                                       -- 必须设置为nil，单击是否弹出扩展提示，根据这个来
                    item_slot.grid_had_open = true
                    if item_slot.item_date == nil then                                  -- 开通格子的情况，本来会有一个 禁用 图标，这里要去掉
                        item_slot:set_icon_texture("")
                    end
                end

                if item_slot.bag_lock_pic then
                    item_slot.view:removeChild(item_slot.bag_lock_pic, true)
                    item_slot.bag_lock_pic = nil
                    item_slot.grid_had_open = true
                    if item_slot.item_date == nil then
                        item_slot:set_icon_texture("")
                    end
                end
            end
        end
    end
end


-- 发送扩展格子的请求
-- local function send_expand_cangku(  )
--     CangKuCC:req_expand_grid_count ()
-- end

-- 显示扩展背包需要的金钱的提示窗口
function CangKuWin:show_expand_bag_confirm_win( money_count, grid_count )
    local count = grid_count or 0
    local money = money_count or 0

    local money_type = 3
    local param = {money_type}
    local expand_func = function( param )
        CangKuCC:req_expand_grid_count(param[1])
    end

    local function send_expand_cangku(  )
        MallModel:handle_auto_buy( money, expand_func, param )
    end
    
    local notice_words = Lang.cangku.model[1]..count..Lang.cangku.model[2]..money..Lang.cangku.model[3] -- [709]="扩展" -- [710]="格仓库,需要花费" -- [711]="元宝，是否继续？"
    ConfirmWin( "select_confirm", nil, notice_words, send_expand_cangku, nil, 50, nil)
end

function CangKuWin:destroy()
    Window.destroy(self)
    -- 所有slot值创建一次，使用retain来保留，这里要全部释放
    for key, slot in pairs( self.item_slot_t ) do
        safe_release(slot.view)
    end
end
