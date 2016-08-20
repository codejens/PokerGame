-- DreamlandCangkuWin.lua 
-- createed by fangjiehua on 2012-12-24
-- 梦境仓库窗口

 
super_class.DreamlandCangkuWin(NormalStyleWindow)

local _window_name="dreamland_cangku_win"
local cangku_grid_lab   = nil;
local current_page_num  = 1;
local _circle_objects   = {};
local _items_object     = {};

local _base_bg_size = CCSize(435, 605) --底板尺寸
local _max_page_index = 5           -- 最大显示页数

--单元格
local _slot_size = CCSize(70, 70) --单元格尺寸
local _slot_num_size = CCSize(5, 5) --单元格矩阵尺寸


local _per_page_count = _slot_num_size.width*_slot_num_size.height
local _changku_sum = _per_page_count*_max_page_index

--单元格背景
local _slot_bg_padding = {left=15, top=40, right=15, bottom=82} --单元格背景相对底板的间距
local _slot_bg_size = CCSize(  --单元格背景面板尺寸 二层底板
    _base_bg_size.width - _slot_bg_padding.left - _slot_bg_padding.right, 
    _base_bg_size.height - _slot_bg_padding.top - _slot_bg_padding.bottom) 
local _slot_bg_pos = CCPoint(_slot_bg_padding.left, _slot_bg_padding.bottom) --单元格背景面板底部位置 二层底板

--扩展图片
local _slot_kuozhan_size = CCSize(50, 50) --"点击可扩展"图片尺寸
local _slot_kuozhan_image = {UILH_BAG_AND_CANGKU.dian,    --"点击可扩展"图片路径
                            UILH_BAG_AND_CANGKU.ji,
                            UILH_BAG_AND_CANGKU.ke, 
                            UILH_BAG_AND_CANGKU.kuo,
                            UILH_BAG_AND_CANGKU.zhan}
--翻页按钮
local _page_btn_padding = {left=38, bottom=32} --翻页按钮与二层底板的间距
local _page_btn_size = CCSize(56, 35) --翻页按钮尺寸

--页码
local _page_num_bg_padding={bottom=_page_btn_padding.bottom}
local _page_num_bg_size = CCSize(110, 30)
local _page_num = nil

--圈圈
local _circle_top_padding = 6 --圈圈与上部的间距
local _circle_size = CCSize(25, 25) --圈圈尺寸
local _circle_side_gap = 30 --圈圈的边距
local _circle_center_gap = _circle_side_gap + _circle_size.width --圈圈中心间隔 
local _circle_hui_image = UIPIC_BagWin_0005 --未选中的圈圈图片路径
local _circle_lan_image = UIPIC_BagWin_0006 --选中的圈圈图片路径

--全部取出按钮
local _getall_btn_padding = {top=15, right=110, bottom=24} --全部取出按钮与上部的间距
local _getall_btn_size = CCSize(121, 53) --全部取出按钮的尺寸
local _getall_btn_textfontsize = 16 --全部取出按钮的文本字体大小

--单元格区域
local _slot_region_padding = {left=25, top=58, right=25, bottom=142} --单元格区域相对底板的间距 left top right bottom
local _slot_region_size = CCSize(   --单元格区域尺寸
    _base_bg_size.width - _slot_region_padding.right - _slot_region_padding.left,
    _base_bg_size.height - _slot_region_padding.top - _slot_region_padding.bottom)
local _slot_region_rect = CCRect(  --单元格区域相对底板的位置
    _slot_region_padding.left,  --left
    _base_bg_size.height -_slot_region_padding.top - _slot_region_size.height,  --bottom
    _slot_region_size.width,  --宽度
    _slot_region_size.height  --高度
    )

local _font_size = 16 --字体大小
local _icon_offset = 0 --物品偏移
local _slot_gap_v = (_slot_region_size.height-_slot_size.height*_slot_num_size.height)/(_slot_num_size.height-1) --单元格垂直间距




function DreamlandCangkuWin:__init(window_name, texture_name)
	-- body
	self:initPanel(self.view);
end

local function cangku_close_fun( eventType,x,y )
	if eventType == TOUCH_CLICK then
		UIManager:hide_window("dreamland_cangku_win");
        -- if UIManager:find_visible_window("dreamland_info_win") == false then
        --     UIManager:show_window("dreamland_info_win");
        -- end
	end
    return true
end

--创建物品项
local function create_item_obj (tag,x, y, width, height,icon,count,lock_flag)
    local item_obj = SlotBag( 58, 58 );
    item_obj:setPosition (x, y);
    item_obj:set_icon_texture(icon);
    item_obj:set_tag(tag);
    item_obj:set_count(count);
    item_obj:set_icon_size(58, 58);
    item_obj:set_icon_bg_texture(UIPIC_DREAMLAND.slot_item, -6, -6, _slot_size.width, _slot_size.height);

    -- 道具双击事件回调,从仓库里取出单个物品
    local function item_double_clicked ()
        local index = DreamlandCangkuWin:get_item_index_in_model(current_page_num,item_obj:get_tag());
        local cangku_model = DreamlandModel:get_cangku_table();
        local item = cangku_model[index];
        if item then
            -- DreamlandCC:request_moveItem_to_package(item.series);
            DreamlandModel:move_item_to_package(item.series)
        end
    end

    item_obj:set_double_click_event(item_double_clicked);

    --道具单击事件回调
    local function item_clicked(  )
        local index = DreamlandCangkuWin:get_item_index_in_model(current_page_num,item_obj:get_tag());
        local item_model = DreamlandModel:get_item_in_cangku_by_index( index );

        TipsModel:show_tip( 400, 240, item_model, item_double_clicked, nil, false, LangGameString[837],nil, TipsModel.LAYOUT_LEFT ); -- [837]="取出"
    end
    item_obj:set_click_event(item_clicked);

    return item_obj;
end

--计算当前页的tag在model数据中的index下标
function DreamlandCangkuWin:get_item_index_in_model(_current_page_num, tag)
    -- print("点中了那个index",_current_page_num, tag, (_current_page_num-1)*_per_page_count+tag);
    return (_current_page_num-1)*_per_page_count+tag;
end

--更新物品栏,传入当前页码
function DreamlandCangkuWin:update(_current_page_num )
    --更新仓库格子数量
    local grid_count_str = string.format("%d/%d",#DreamlandModel:get_cangku_table(), _changku_sum);
    cangku_grid_lab:setText(grid_count_str);

    local pagenumstr = string.format("#cd58a08%d/%d", _current_page_num, _max_page_index)
    _page_num:setText(pagenumstr)

    --model的索引
    local model_index = self:get_item_index_in_model(_current_page_num,1);

    current_page_num = _current_page_num
    self.show_page_circle.change_page_index( current_page_num )
    
    for i=model_index, model_index+_per_page_count-1 do
        --视图容器的索引
        local item_index = i%_per_page_count;
        if item_index == 0 then
            item_index = _per_page_count;
        end
        --取出对于视图对象
        local item = _items_object[item_index];
        --仓库model
        local cangku_model = DreamlandModel:get_cangku_table();
        --物品model
        local item_model = cangku_model[i];
        --开始更新视图
        if item_model ~= nil and item ~= nil then
            local item_icon = ItemConfig:get_item_icon(item_model.item_id);
            item.icon:setIsVisible(true);
            item:set_icon_texture(item_icon);
            item:set_count(item_model.count);
            item:set_color_frame( item_model.item_id, 0, 0, 58, 58 );
            item:set_gem_level( item_model.item_id )
            -- 是否绑定(锁)
            if item_model.flag ==1 then
                item:set_lock(true)         
            else
                item:set_lock(false)
            end
        else
            item.icon:setIsVisible(false);
            item:set_count(0);
            item:set_color_frame( nil );
            item:set_gem_level( nil )
            item:set_lock(false)
        end
    end

    -- 如果已经到了上一页，或者最后一页，就变暗
    local page_index = _current_page_num
    if page_index == 1 then 
        self.left_but.view:setCurState( CLICK_STATE_DISABLE )        
        self.right_but.view:setCurState( CLICK_STATE_UP )   
        --print("first page")     
    elseif page_index == _max_page_index then  
        self.left_but.view:setCurState( CLICK_STATE_UP )          
        self.right_but.view:setCurState( CLICK_STATE_DISABLE )   
       -- print("last page")       
    else
        self.left_but.view:setCurState( CLICK_STATE_UP )        
        self.right_but.view:setCurState( CLICK_STATE_UP )     
       -- print("middle page")     
    end
end

--仓库物品发生变化
function DreamlandCangkuWin:cangku_item_changed( )
    self:update(current_page_num);
end

--取出全部
local function get_all_out(eventType,x,y )
    if eventType == TOUCH_BEGAN then
        return true
    elseif eventType == TOUCH_CLICK then
        -- 0：意味着物品全部取出。
        -- DreamlandCC:request_moveItem_to_package(0);
        Instruction:handleUIComponentClick(instruct_comps.DREAMLAND_WAREHOUSE_TAKEALL)
        DreamlandModel:move_item_to_package(0);
        return true
    end
    return true
end

function DreamlandCangkuWin:initPanel( self_panel )

    local now_y=_slot_region_rect.origin.y + _slot_region_size.height - _slot_size.height
    local page_btn_bottom = 0  
    local ytest = math.ceil(_slot_num_size.height/2) 
    local v_num = _slot_num_size.height --垂直高度 单元格数
    local h_num = _slot_num_size.width --水平宽度 单元格数
    local slot_height = _slot_size.height --单元格高度
    for i = 1, v_num do         
        if i==ytest then
            if ytest%2==0 then
                page_btn_bottom = now_y - _slot_gap_v/2 - _page_btn_size.height/2
            else
                page_btn_bottom = now_y + _slot_size.height/2 - _page_btn_size.height/2
            end            
        end       
        --now_x = start_x
        if i<v_num then 
            now_y = now_y - slot_height - _slot_gap_v
        end
    end    

      
    --local left_btn_size = _page_btn_size
    --local left_btn_bottom = page_btn_bottom
    local left_btn_pos = CCPoint(_page_btn_padding.left, _page_btn_padding.bottom)
    
    --local right_btn_size = _page_btn_size
    --local right_btn_bottom = page_btn_bottom
    local right_btn_pos = CCPoint(_slot_bg_size.width - _page_btn_padding.left, _page_btn_padding.bottom)
    
    local frame_bg = ZImage:create(self_panel, UILH_COMMON.normal_bg_v2,8, 15, 420, 550, 0, 500, 500)
	-- 物品背景九宫格底图
    local wupin_nine_grid = CCBasePanel:panelWithFile(_slot_bg_pos.x, _slot_bg_pos.y, _slot_bg_size.width, _slot_bg_size.height, "", 500, 500);
    self_panel:addChild(wupin_nine_grid);

    local start_x = 6  -- 单元格相对item_page开始x坐标
    local start_y = _slot_region_size.height - _slot_size.height + 6-- 单元格相对item_page开始y坐标
    local slot_width = _slot_size.width --单元格宽度
    local slot_height = _slot_size.height --单元格高度
    local gap_h = (_slot_region_rect.size.width - _slot_size.width*_slot_num_size.width)/(_slot_num_size.width-1)   --_slot_gap --单元格间隙
    --print("gap_h:" .. gap_h)
    local cursorx = start_x
    local cursory = start_y
    local v_num = _slot_num_size.height --垂直高度 单元格数
    local h_num = _slot_num_size.width --水平宽度 单元格数



    for i=1, _per_page_count do
        --每个物品格子的tag从1到25，定位具体哪一页的哪个物品需要乘以页数，current_page_num
        local item_icon = "";
        local count = 1;
        local lock_flag = nil;
         
        --从仓库model里取出
        local c_tabel = DreamlandModel:get_cangku_table();
        if c_tabel[i] ~= nil then
            item_icon = ItemConfig:get_item_icon(c_tabel[i].item_id);
            count = c_tabel[i].count;
            lock_flag = c_tabel[i].flag;
        end

        _items_object[i] = create_item_obj(i, cursorx, cursory, slot_width, slot_height, item_icon, count, lock_flag);
        
        local item_page = {}           
        item_page.view = CCBasePanel:panelWithFile( 
            _slot_region_rect.origin.x,  --单元格区域left
            _slot_region_rect.origin.y,  --单元格区域bottom
            _slot_region_size.width, --单元格区域宽度
            _slot_region_size.height, --单元格区域高度
            "" )  
        self_panel:addChild(item_page.view)

        item_page.view:addChild(_items_object[i].view)
        --wupin_nine_grid:addChild(_items_object[i].view);
        
        --坐标排列
        cursorx = cursorx + slot_width + gap_h
        if (i%5==0) then  -- 每5列换行
            cursorx = start_x
            --if (i/5 ~= 5) then --最后一行Y坐标不再下移
            cursory = cursory - slot_height - _slot_gap_v
            --end
        end
    end

    -- 圆圈表示页数
    -- 高亮表示第几页
    -- 改对象用局部全局变量保存，以被其他函数引用
    local function circle_callback_func( page_index )
        if page_index then
            self:update(page_index)
        end
    end
    local circle_num = _max_page_index
    local circle_x = _slot_bg_pos.x + (_slot_bg_size.width - (_circle_size.width+_circle_center_gap*(circle_num-1)))/2  --圈圈的绝对x坐标
    local circle_y = now_y - _circle_top_padding - _circle_size.height  --_slot_bg_pos.y + _height_circle_bg --圈圈的绝对y坐标
   
    self.show_page_circle = MUtils:create_page_circle(circle_x, circle_y, _max_page_index, 
        _circle_hui_image, _circle_lan_image, _circle_size.width, _circle_size.height, _circle_center_gap, circle_callback_func)
    self_panel:addChild(self.show_page_circle.view)
    self.show_page_circle.view:setIsVisible(false) --隐藏圈圈

    --左翻按钮
    local function left_but_callback()
        print("leftpage")
        --if eventType == TOUCH_CLICK then
            if current_page_num >1 then 
                current_page_num = current_page_num-1;
                --更新物品栏
                self:update(current_page_num);
            end
        --end
        return true
    end
    --右翻按钮
    local function right_but_callback()
        print("rightpage")
        --if eventType == TOUCH_CLICK then
            if current_page_num <5 then 
                current_page_num = current_page_num+1;
                -- --更新物品栏
                self:update(current_page_num);
            end
        -- end
        return true
    end

    -- 左箭头按钮
    self.left_but = UIButton:create_button_with_name( left_btn_pos.x, left_btn_pos.y, _page_btn_size.width, _page_btn_size.height, 
        UIPIC_CangKuWin_0004, UIPIC_CangKuWin_0004, UIPIC_CangKuWin_0005, "", left_but_callback )
    --self.left_but:registerScriptHandler(left_page_btn_event)
    wupin_nine_grid:addChild(self.left_but.view)  
    self.left_but.set_double_click_func( left_but_callback )     
    self.left_but.view:addTexWithFile(CLICK_STATE_DISABLE, UIPIC_CangKuWin_0005 )
    self.left_but.view:setAnchorPoint(0, 0.5)
    --self.left_but.view:setFlipX(true)

    -- 右箭头按钮
    self.right_but = UIButton:create_button_with_name( right_btn_pos.x, right_btn_pos.y, _page_btn_size.width, _page_btn_size.height, 
        UIPIC_CangKuWin_0004, UIPIC_CangKuWin_0004, UIPIC_CangKuWin_0005, "", right_but_callback )
    --self.right_but:registerScriptHandler(right_page_btn_event)
    self.right_but.set_double_click_func( right_but_callback )
    wupin_nine_grid:addChild(self.right_but.view)
    self.right_but.view:addTexWithFile(CLICK_STATE_DISABLE, UIPIC_CangKuWin_0005 )
    self.right_but.view:setAnchorPoint(1, 0.5)
    self.right_but.view:setFlipX(true)
	
    --页码
    ZImage:create(wupin_nine_grid, UILH_COMMON.bg_10,152, 16, 100, 30, 0, 500, 500)
    local page_num_bg = ZImage:create(
        wupin_nine_grid, UIPIC_DREAMLAND.text_bg2, _slot_bg_size.width/2, _page_num_bg_padding.bottom, 
        _page_num_bg_size.width, _page_num_bg_size.height, 999, 500 ,500)
    page_num_bg:setAnchorPoint(0.5, 0.5)
    _page_num = CCZXLabel:labelWithTextS(
        CCPointMake(_page_num_bg_size.width/2, _page_num_bg_size.height/2+2),  --_page_num_bg_size.width/2
        "", 
        _font_size,ALIGN_LEFT);
    _page_num:setAnchorPoint(CCPointMake(0.5, 0.5))
    page_num_bg:addChild(_page_num);

    
    --local btn_getall_pos = CCPointMake(_base_bg_size.width/2, _slot_bg_pos.y - _getall_btn_padding.top) --label的位置
    local btn_getall_pos = CCPointMake(340, _getall_btn_padding.bottom) --label的位置

    --print("circle_y " .. circle_y)
    --print("btn_getall_pos.y " .. btn_getall_pos.y)
    local function back_dream_fun( )
       local win = UIManager:show_window("new_dreamland_win")

        if DreamlandModel:get_dreamland_type() == DreamlandModel.DREAMLAND_TYPE_XY  then
           win:choose_xymj_tab()
        elseif DreamlandModel:get_dreamland_type() == DreamlandModel.DREAMLAND_TYPE_YH  then
           win:choose_yhmj_tab()
        elseif DreamlandModel:get_dreamland_type() == DreamlandModel.DREAMLAND_TYPE_TBS  then
          win:choose_tbmj_tba()
        end
    
    end
    local back_dream = ZTextButton:create(self_panel, Lang.dreamland_cangku.back, UILH_COMMON.btn4_nor, back_dream_fun, 35, 35, -1, -1)
    local btn_getall = CCNGBtnMulTex:buttonWithFile(
        btn_getall_pos.x, 35, _getall_btn_size.width, _getall_btn_size.height, 
        UIPIC_CangKuWin_0003, TYPE_MUL_TEX)
    btn_getall:setAnchorPoint(0.5, 0)
    self_panel:addChild(btn_getall)
    btn_getall:registerScriptHandler(get_all_out)
    local get_all_lab = MUtils:create_zxfont(
        btn_getall, Lang.dreamland_cangku.btn_getall_text, _getall_btn_size.width/2, _getall_btn_size.height/2+4, 
        ALIGN_CENTER, _getall_btn_textfontsize)
    get_all_lab:setAnchorPoint(CCPointMake(0, 0.5))

    -- [880]="#c00c0ff仓库空间"
    local cangku_lab_pos = CCPointMake(220, 10 + btn_getall_pos.y+_getall_btn_size.height)
	local cangku_lab = CCZXLabel:labelWithTextS(cangku_lab_pos, Lang.dreamland_cangku.label_cangkuspace, _font_size,ALIGN_CENTER);
	self_panel:addChild(cangku_lab);
    cangku_lab:setAnchorPoint(CCPointMake(0, 1))
    --print("cangku_lab_pos:" .. cangku_lab_pos.x .. " " .. cangku_lab_pos.y)
    local cangku_lab_size = cangku_lab:getSize()
    local grid_count_str = string.format("%d/%d",#DreamlandModel:get_cangku_table(),_changku_sum)
    local cangkuspace_count_pos = CCPointMake(220, cangku_lab_pos.y - cangku_lab_size.height - 5)
	cangku_grid_lab = CCZXLabel:labelWithTextS(cangkuspace_count_pos, grid_count_str, _font_size, ALIGN_CENTER);
	cangku_grid_lab:setAnchorPoint(CCPointMake(0, 1))
    self_panel:addChild(cangku_grid_lab);

    self:update(1);
end


-- -- 创建函数
-- function DreamlandCangkuWin:create(texture_name)
-- 	print("DreamlandWin:create")
-- 	return DreamlandCangkuWin(texture_name,404,50,389,429);
-- end

function DreamlandCangkuWin:active(show)
    if show == false then
        -- if UIManager:find_visible_window("dreamland_info_win") == false then
        --     UIManager:show_window("dreamland_info_win");
        -- end
    end
end

function DreamlandCangkuWin:getwinname()
    return _window_name
end