---------HJH
---------2012-2-15
---------
require "UI/component/AbstractBase"
----------------------------------------------------------------------
----------------------------------------------------------------------
---------
---------单选按钮组
super_class.ZXSynthSpinner(AbstractBasePanel)
---------
---------

local top_bottom_h = 40+80

local function ZXSynthSpinnerCreateFunction(self, x, y, width, height, image, topLeftWidth, topLeftHeight, topRightWidth, topRightHeight, bottomLeftWidth, bottomLeftHeight, bottomRightWidth, bottomRightHeight)
    local tPosX = x or 0
    local tPosY = y or 0
    local tWidth = width or 0
    local tHeight = height or 0
    local tImage = image or ''
    local tTopLeftWidth = topLeftWidth or 0
    local tTopLeftHeight = topLeftHeight or 0
    local tTopRightWidth = topRightWidth or 0
    local tTopRightHeight = topRightHeight or 0 
    local tBottomLeftWidth = bottomLeftWidth or 0
    local tBottomLeftHeight = bottomLeftHeight or 0
    local tBottomRightWidth = bottomRightWidth or 0
    local tBottomRightHeight = bottomRightHeight or 0
    ---------
    local base_anel = CCBasePanel:panelWithFile(tPosX, tPosY, tWidth, tHeight, tImage, tTopLeftWidth, tTopLeftHeight, tTopRightWidth, tTopRightHeight, tBottomLeftWidth, tBottomLeftHeight, tBottomRightWidth, tBottomRightHeight)
    return base_anel
end
---------
---------初始化，创建时调用
function ZXSynthSpinner:__init(fatherPanel)
    -- 当前item的选择
    self.cur_title_index = nil
    self.cur_item_index = nil

    -- title 按钮移动标志
    self.isAnim = false

    -- title和item的点击注册方法
    self.registerTitleFunc = nil
    self.registerItemFunc = nil

    -- items的临时存储table(item的等级，item的名字, item 的物品id)
    self.temp_items_l = {}
    self.temp_items_n = {}
    self.temp_items_id = {}
    
    -- 存储title  --存储item列表(items-tabel)
    self.title_t = {}
    -- 存储4个scroll
    self.scroll_items_t = {}
    -- 存储4个scrollview里面的items
    self.scroll_items_arr = {}


    -- 选中标志
    self.sld_sign = nil

    -- params参数,用于调整ui位置
    self.btn_h = nil
    self.win_h = nil

    self.click_num = 0
    if addType == nil then
        addType = 0
    end
    self.add_type = addType
    self.item_group = {}

end
---------
---------创建
--------- item_t = 放入item的的数据, params参数(如:btn的高)
------ local params = {
------     btn_h = 40,
------ }              -- params 格式
function ZXSynthSpinner:create(fatherPanel, item_data, params, x, y, width, height, image, topLeftWidth, topLeftHeight, topRightWidth, topRightHeight, bottomLeftWidth, bottomLeftHeight, bottomRightWidth, bottomRightHeight)
    -- init初始化
    local sprite = ZXSynthSpinner(fatherPanel)
    sprite.btn_h = params.btn_h   -- item按钮的高度
    sprite.btn_w = params.btn_w
    sprite.item_h = params.item_h   -- item按钮的高度
    sprite.item_w = params.item_w
    sprite.title_x = params.title_x
    sprite.win_h = height          -- 窗口高度
    sprite.scroll_h = sprite.win_h - sprite.btn_h*4 -10 -- top_bottom_h  -- scrollview 高度
    sprite.scroll_w = params.btn_w

    -- 选中框
    sprite.sld_sign = CCBasePanel:panelWithFile( 0, 0, sprite.btn_w, sprite.btn_h, "ui/lh_common/slot_focus.png", 500, 500 )
    -- sprite.sld_sign:setPosition( 0, 0 )

    -- 创建，调用其他控件
    sprite.view = ZXSynthSpinnerCreateFunction(sprite, x, y, width, height, image, topLeftWidth, topLeftHeight, topRightWidth, topRightHeight, bottomLeftWidth, bottomLeftHeight, bottomRightWidth, bottomRightHeight)
    fatherPanel:addChild(sprite.view)
    sprite:registerScriptFun()

    -- 创建裁剪区域（整个控件为裁剪区，用于控制动画）
    sprite.touch_panel = CCTouchPanel:touchPanel( sprite.title_x, 5, sprite.scroll_w, sprite.scroll_h )
    sprite.view:addChild( sprite.touch_panel )

    -- 创建scrollview 及其 panel, 添加到裁剪区
    sprite.scroll_bg = CCBasePanel:panelWithFile( 0, 0, sprite.scroll_w, sprite.scroll_h, "", 500, 500)
    sprite.touch_panel:addChild( sprite.scroll_bg )

    -- 添加scrollview
    sprite.temp_items_l = item_data.item_lv or {}
    sprite.temp_items_n = item_data.item_name or {}
    sprite.temp_items_id = item_data.item_id or {}

    return sprite
end

---------
---------添加btnItem
function ZXSynthSpinner:addTitle(item_btn, title_index)
    
    -------------------
    local function title_btn_fun(eventType, arg, msgid, selfitem)
        if eventType == nil or arg == nil or msgid == nil or selfitem == nil then
            return
        end
        if eventType == TOUCH_BEGAN then
            if not self.isAnim then
                self:slt_title_func( title_index )
            end
            return true
        elseif eventType == TOUCH_CLICK then
            return true;
        end
        return true;
    end

    ----------------
    item_btn:registerScriptHandler( title_btn_fun )  --注册
    self.view:addChild( item_btn, 2 )

    -- 标题文字
    local title_label = UILabel:create_lable_2( COLOR.y .. self.temp_items_n[title_index], self.btn_w*0.5, 15, item_font_size, ALIGN_CENTER )
    item_btn:addChild( title_label )

    -- 添加一个title的同事添加一个item数组，存放该title下面的item
    self.scroll_items_arr[title_index] = {}

    -- 把item_btn添加到table中
    table.insert( self.title_t, title_index, item_btn )
end

---------
---------
function ZXSynthSpinner:create_scrollView( panel, title_index )

    -- 遍历已创建的，并隐藏掉
    for _, v in pairs(self.scroll_items_t) do
        v:setIsVisible(false)
    end

    -- 如果 self.scroll_items_t 里面有，直接拿出
    if self.scroll_items_t[title_index] ~= nil then
        self.scroll_items_t[title_index]:setIsVisible(true)
        return self.scroll_items_t[title_index]
    end

    local item_t = self.temp_items_l
    -- 创建scroll_view
    local _scroll_info = { x = 0, y = 0, width = self.scroll_w, height = self.scroll_h, 
        maxnum = 1, image = nil, stype = TYPE_HORIZONTAL }
    local scroll = CCScroll:scrollWithFile( _scroll_info.x, _scroll_info.y, _scroll_info.width, 
        _scroll_info.height, _scroll_info.maxnum, _scroll_info.image, _scroll_info.stype )
    panel:addChild( scroll )

    -- scroll_view 里面的 panel
    local item_h = self.item_h
    local item_w = self.item_w

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
            -- 由0开始算；需要+1
            local x = temparg[1]              -- 1行(此处创建只有一行)
            local ver_line_num = #item_t
            -- 一个item大面板，放入10个小item
            local scr_cont_panel = CCBasePanel:panelWithFile( 0, 0, item_w, item_h*ver_line_num, "", 500, 500)
            -- 显示合成宝石明细
            local synth_detail = ForgeModel:onekeyMixDetail( title_index )
            for i=1, ver_line_num do
                -- item create
                local bg_item = CCBasePanel:panelWithFile( 0, item_h*(ver_line_num-i), item_w, item_h, "", 500, 500)
                local bg = self:create_item_panel( 0, 0, item_w, item_h, i, title_index, synth_detail )
                bg_item:addChild( bg.item_panel_bg )
                -- 把item插入表中
                self.scroll_items_arr[title_index][i] = bg_item
                scr_cont_panel:addChild( bg_item )

                -- 分割线
                local split_line = CCZXImage:imageWithFile( 5, -1, self.btn_w-15,2, UILH_COMMON.split_line );
                bg_item:addChild( split_line );
            end
            scroll:addItem(scr_cont_panel)
            scroll:refresh()

            return false
        end
    end

    scroll:registerScriptHandler(scrollfun)
    scroll:refresh()
    table.insert( self.scroll_items_t, title_index, scroll )

    return scroll
end

function ZXSynthSpinner:create_item_panel( x, y, w, h, item_index, title_index, synth_detail )
    local panel = {}

    -- 获取数据 等级，名字
    local item_lv_t = self.temp_items_l
    local item_name_t = self.temp_items_n
    local item_id_t = self.temp_items_id
    
    -- 添加 item 背景
    local item_panel_bg = CCBasePanel:panelWithFile( x, y , w, h, "", 500, 500 )
    panel.item_panel_bg = item_panel_bg

    self.item = 3

    local function item_sld_func(eventType, arg, msgid, selfitem)
        if eventType == nil or arg == nil or msgid == nil or selfitem == nil then
            return
        end
        if eventType == TOUCH_BEGAN then
            
            self:slt_item_func( item_index )   --gai            
            return true;
        elseif eventType == TOUCH_CLICK then
            return true;
        end
        return true;
    end
    item_panel_bg:registerScriptHandler(item_sld_func)

    -- 添加主信息(如：一级攻击宝石)
    local lv_txt = item_lv_t[item_index]
    local name_txt = item_name_t[title_index]
    local item_id = item_id_t[title_index][item_index]

    -- 颜色标志位
    local color_sign = nil

    if synth_detail[item_index] == 0 then
        color_sign = COLOR.r
    else
        color_sign = COLOR.w
    end

    -- local label_temp = UILabel:create_lable_2( lv_txt .. name_txt .. "  " .. color_sign .. item_num_have .. "/" ..item_num_need .. "   " .. COLOR.w .. synth_detail[item_index] , self.item_w*0.5, 15, item_font_size, ALIGN_CENTER )
    local label_temp = UILabel:create_lable_2( lv_txt .. name_txt .. "  " .. color_sign .. "(" .. synth_detail[item_index] .. ")", self.item_w*0.5, 15, item_font_size, ALIGN_CENTER )
    panel.item_panel_bg:addChild( label_temp )

    return panel
end

---------
-- 注册title_btn点击按钮事件
function ZXSynthSpinner:registerScriptFunc_t( func )
    self.registerTitleFunc = func
end

-- 注册item点击事件
function ZXSynthSpinner:registerScriptFunc_i( func )
    self.registerItemFunc = func
end

-- 更新btn按钮位置 version2
function ZXSynthSpinner:update_title_btn_pos( title_index, isInit )
    -- 播放动画时间
    local time_move = 0.1
    self.isAnim = true

    -- body
    local title_x = self.title_x
    local title_up_y = {
        450, 405, 360, 315
    }
    local title_down_y = {
        140, 95, 50, 5
    }
    -- 设置前面的
    for i=1, title_index do
        if isInit then
            self.title_t[i]:setPosition( title_x, title_up_y[i] )
        else
            local moveTo = CCMoveTo:actionWithDuration( time_move ,CCPoint(title_x, title_up_y[i]) );
            self.title_t[i]:runAction( moveTo )
        end
    end

    -- 设置后面的
    if title_index ~= #self.title_t then
        for i=title_index+1, #self.title_t do
            if isInit then
                self.title_t[i]:setPosition( title_x, title_down_y[i] )
            else
                local moveTo = CCMoveTo:actionWithDuration( time_move ,CCPoint(title_x, title_down_y[i]) );
                self.title_t[i]:runAction( moveTo )
            end
        end
    end

    -- 控制scroll_vew
    if isInit then 
        self.touch_panel:setPosition( self.title_x, self.btn_h*(#self.title_t-title_index)+5 )
        self.isAnim = false
    else
        -- 回调，设置移动过程中，title不可点击
        local cb = callback:new();
        local function fun_back( ... )
            self.isAnim = false
        end
        cb:start( time_move, fun_back );

        -- 设置scroll_bg的动态
        self.touch_panel:setPosition( CCPoint(title_x, self.btn_h*(#self.title_t-title_index)+5) )
        if title_index < self.cur_title_index then
            self.scroll_bg:setPosition( CCPoint(title_x, self.scroll_h) )
            local moveTo = CCMoveTo:actionWithDuration( time_move ,CCPoint(title_x, 0) );
            self.scroll_bg:runAction( moveTo )
        else
            self.scroll_bg:setPosition( self.title_x, -self.scroll_h )
            local moveTo = CCMoveTo:actionWithDuration( time_move ,CCPoint(title_x, 0) );
            self.scroll_bg:runAction( moveTo )
        end
    end
end



-- title点击调用方法,选择title, 是否初始化-----------------------------------------------
-- warn: 此方法中调用严格按照顺序，更改顺序需谨慎
function ZXSynthSpinner:slt_title_func( title_index , isInit )
    if self.cur_title_index ~= nil and self.cur_item_index ~= nil then
        if self.scroll_items_arr[self.cur_title_index][self.cur_item_index] ~= nil then
            self.scroll_items_arr[self.cur_title_index][self.cur_item_index]:removeChildByTag( 5, true )
        end
    end
    -- 创建scrollview
    self:create_scrollView( self.scroll_bg, title_index )

    -- 更新控件位置和播放动画
    if self.cur_title_index ~= title_index then
        self:update_title_btn_pos( title_index, isInit )
    end

    -- 设置当前title_index
    self.cur_title_index = title_index
    self.cur_item_index = nil
    
    if self.scroll_items_arr[title_index] == nil then
        self.scroll_items_arr[title_index] = {}
    end
    local f = self.registerTitleFunc
    f(self.cur_title_index, nil)
end

---------选择一个item-------------------------------------------------------
function ZXSynthSpinner:slt_item_func( item_index )
    if self.view ~= nil then 
        if self.cur_title_index ~= nil and self.cur_item_index ~= nil then
            if self.scroll_items_arr[self.cur_title_index][self.cur_item_index] ~= nil then
                self.scroll_items_arr[self.cur_title_index][self.cur_item_index]:removeChildByTag( 5, true )
            end
        end

        self.cur_item_index = item_index
        local show_sld = CCBasePanel:panelWithFile( 0, 0, self.btn_w, self.btn_h, "ui/lh_common/slot_focus.png", 500, 500 )
        self.scroll_items_arr[self.cur_title_index][self.cur_item_index]:addChild( show_sld, 99, 5 )

        local f = self.registerItemFunc
        f( self.cur_title_index, self.cur_item_index )
    end
end

function ZXSynthSpinner:init_slt( ... )
    self:slt_title_func( 1 , true )
    self:slt_item_func( 1 )
end

---------
---------
function ZXSynthSpinner:getCurSelect()
    if self.view ~= nil then 
        return self.view:getCurSelect()
    else
        return nil
    end
end

---------
---------
function ZXSynthSpinner:getCurNum()
    if self.view ~= nil then
        return self.view:getCurNum()
    else
        return nil
    end
end
---------
---------
function ZXSynthSpinner:getIndexItem(index)
    if self.view ~= nil then
        return self.item_group[index + 1]
    else
        return nil
    end
end