---------CHJ
---------2014-10-9
---------
require "UI/component/AbstractBase"
----------------------------------------------------------------------
----------------------------------------------------------------------
---------
---------单选按钮组
super_class.LHExpandListView(AbstractBasePanel)
---------
---------

local top_bottom_h = 40+80
local pic_align = 10
local title_align = 5

local function LHExpandListViewCreateFunction(self, x, y, width, height, image, topLeftWidth, topLeftHeight, topRightWidth, topRightHeight, bottomLeftWidth, bottomLeftHeight, bottomRightWidth, bottomRightHeight)
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
function LHExpandListView:__init(fatherPanel)
    -- 当前item的选择
    self.cur_title_index = 1
    self.cur_item_index = 1

    -- title和item的点击注册方法
    self.registerTitleFunc = nil
    self.registerItemFunc = nil
    -- 当初始化时没有title或item调用的事件
    self.registerNilFunc = nil

    -- 存储 title 和 item 的数据
    self.item_data = {}                     
    
    self.title_t = {}                       -- 存储title  --存储item列表(items-tabel)
    self.scroll_items_t = {}                -- 存储n个scroll
    self.scroll_h_t = {}                    -- 存储n个scroll的高度
    self.scroll_items_arr = {}              -- 存储n个scrollview里面的items

    -- 选中标志
    -- self.sld_sign = nil

    -- params参数,用于调整ui位置
    self.title_h = nil
    self.win_h = nil

    self.scroll_max_h = 0          -- scrollview 的最长高度

    self.click_num = 0
    if addType == nil then
        addType = 0
    end
    self.add_type = addType
    self.item_group = {}

end
------ 
------ 创建
------ item_t = 放入item的的数据, params参数(如:btn的高)
------ local ui_params = {
------     title_h = 40,
------ }              -- ui_params 格式
------ data_type scroll中的item是图片还是文字按钮
function LHExpandListView:create(fatherPanel, item_data, ui_params, data_type, x, y, width, height, image, topLeftWidth, topLeftHeight, topRightWidth, topRightHeight, bottomLeftWidth, bottomLeftHeight, bottomRightWidth, bottomRightHeight)
    -- init初始化
    local sprite = LHExpandListView(fatherPanel)
    sprite.title_h = ui_params.title_h   -- item按钮的高度
    sprite.title_w = ui_params.title_w
    sprite.item_h = ui_params.item_h   -- item按钮的高度
    sprite.item_w = ui_params.item_w
    sprite.title_x = ui_params.title_x
    sprite.data_type = data_type
    sprite.win_h = height          -- 窗口高度
    sprite.scroll_h = sprite.win_h - sprite.title_h*4 -pic_align -- top_bottom_h  -- scrollview 高度
    sprite.scroll_w = ui_params.title_w

    -- 存储 title 和 item 的数据
    sprite.item_data = item_data

    --计算 scrollview 的最长高度， scrollview 的高度有item个数决定，超过最长高度就为最长高度
    local title_num = #item_data
    sprite.scroll_max_h = sprite.win_h-title_num*sprite.title_h-pic_align

    -- -- 选中框
    -- sprite.sld_sign = CCBasePanel:panelWithFile( 0, 0, sprite.title_w, sprite.title_h, UILH_COMMON.slot_focus, 500, 500 )
    -- sprite.sld_sign:setPosition( 0, 0 )


    -- 创建，调用其他控件
    sprite.view = LHExpandListViewCreateFunction(sprite, x, y, width, height, image, topLeftWidth, topLeftHeight, topRightWidth, topRightHeight, bottomLeftWidth, bottomLeftHeight, bottomRightWidth, bottomRightHeight)
    fatherPanel:addChild(sprite.view, 999)
    sprite:registerScriptFun()

    -- 创建scrollview背景框 及其 panel
    sprite.scroll_bg = CCBasePanel:panelWithFile( sprite.title_x, 5, sprite.scroll_w, sprite.scroll_h, "", 500, 500)
    sprite.view:addChild( sprite.scroll_bg )



    return sprite 
end

---------
---------添加btnItem
function LHExpandListView:addTitle(item_btn, title_index)
    
    -------------------
    local function title_btn_fun(eventType, arg, msgid, selfitem)
        if eventType == nil or arg == nil or msgid == nil or selfitem == nil then
            return
        end
        if eventType == TOUCH_BEGAN then
            self:slt_title_func( title_index )
            return true
        elseif eventType == TOUCH_CLICK then
            return true;
        end
        return true;
    end

    ----------------
    item_btn:registerScriptHandler(title_btn_fun)  --注册
    self.view:addChild(item_btn)

    -- 标题文字
    local title_label = UILabel:create_lable_2( COLOR.y .. self.item_data[title_index][1], self.title_w*0.5, self.title_h*0.5+4, item_font_size, ALIGN_CENTER )
    title_label:setAnchorPoint(CCPointMake(0, 0.5))
    item_btn:addChild( title_label )

    -- 添加一个title的同事添加一个item数组，存放该title下面的item
    self.scroll_items_arr[title_index] = {}

    -- 把item_btn添加到table中
    table.insert(self.title_t, title_index, item_btn)
end

---------
---------
function LHExpandListView:create_scrollView( panel, title_index )

    -- 遍历已创建的，并隐藏掉
    for _, v in pairs(self.scroll_items_t) do
        v:setIsVisible(false)
    end

    -- 如果 self.scroll_items_t 里面有，直接拿出
    if self.scroll_items_t[title_index] ~= nil then
        self.scroll_items_t[title_index]:setIsVisible(true)
        return self.scroll_items_t[title_index]
    end

    -- 获取 item, item个数 以及 scrollview 的高度并将此高度存储
    local item_t = self.item_data[title_index].items
    local ver_line_num = #item_t
    local scroll_real_h = ver_line_num*self.item_h
    if scroll_real_h > self.scroll_max_h then
        scroll_real_h = self.scroll_max_h
    end
    self.scroll_h_t[title_index] = scroll_real_h
    -- 获取 scrollview 的 y轴位置
    local scroll_real_y = self.win_h-self.title_h*title_index - scroll_real_h - title_align

    -- 创建scroll_view
    local _scroll_info = { x = self.title_x, y = 0, width = self.scroll_w, height = scroll_real_h, 
        maxnum = 1, image = nil, stype = TYPE_HORIZONTAL }
    local scroll = CCScroll:scrollWithFile( _scroll_info.x, scroll_real_y, _scroll_info.width, 
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
            local temparg = Utils:Split(args, ":")
            -- 由0开始算；需要+1
            local x = temparg[1]              -- 1行(此处创建只有一行)
            -- 一个item大面板，放入10个小item
            local scr_cont_panel = CCBasePanel:panelWithFile( 0, 0, item_w, item_h*ver_line_num, "", 500, 500)

            for i=1, ver_line_num do
                -- item create
                local bg_item = CCBasePanel:panelWithFile( 0, item_h*(ver_line_num-i), item_w, item_h, "", 500, 500)
                local bg = self:create_item_panel( 0, 0, item_w, item_h, i, title_index )
                bg_item:addChild( bg.item_panel_bg )
                -- 把item插入表中
                self.scroll_items_arr[title_index][i] = bg_item
                scr_cont_panel:addChild( bg_item )

                -- 分割线
                local split_line = CCZXImage:imageWithFile( 5, -1, self.title_w-15,2, UILH_COMMON.split_line );
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

function LHExpandListView:create_item_panel( x, y, w, h, item_index, title_index )
    local panel = {}
    
    -- 添加 item 背景
    local item_panel_bg = CCBasePanel:panelWithFile( x, y , w, h, "", 500, 500 )
    panel.item_panel_bg = item_panel_bg

    local function item_sld_func(eventType, arg, msgid, selfitem)
        if eventType == nil or arg == nil or msgid == nil or selfitem == nil then
            return
        end
        if eventType == TOUCH_BEGAN then
            if self.data_type ~= 2 then
                self:slt_item_func( title_index, item_index, self.item_data[title_index].items[item_index][2])              
            end
            return true;
        elseif eventType == TOUCH_CLICK then
            return true;
        end
        return true;
    end
    item_panel_bg:registerScriptHandler(item_sld_func)

    -- 添加 item 名称信息(如：一级攻击宝石)
    local label_temp = nil
    if self.data_type == 2 then
        local img = self.item_data[title_index].items[item_index]
        label_temp = CCZXImage:imageWithFile( self.item_w*0.5, self.item_h*0.5, self.item_w,self.item_h, img );
        label_temp:setAnchorPoint(0.5, 0.5)
    else
        local lv_txt = self.item_data[title_index].items[item_index][1]
        label_temp = UILabel:create_lable_2( lv_txt .. "", self.item_w*0.5, 15, item_font_size, ALIGN_CENTER )
    end
    panel.item_panel_bg:addChild( label_temp )

    return panel
end

---------
-- 注册title_btn点击按钮事件
function LHExpandListView:registerScriptFunc_t( func )
    self.registerTitleFunc = func
end

-- 注册item点击事件
function LHExpandListView:registerScriptFunc_i( func )
    self.registerItemFunc = func
end

-- 注册 没有title或item的触发事件
function LHExpandListView:registerNilFunc_nil( func )
    self.registerNilFunc = func
end

-------------------
-- 更新btn按钮位置
function LHExpandListView:update_title_btn_pos( title_index )
    -- body
    local title_x = self.title_x
    local title_align_top = 5
    local title_align_bottom = 5
    local title_up_y = {
        self.win_h-self.title_h - title_align_top, 
        self.win_h-self.title_h*2 - title_align_top, 
        self.win_h-self.title_h*3 - title_align_top, 
        self.win_h-self.title_h*4 - title_align_top
    }

    -- 设置前面的
    for i=1, title_index do
        local py = self.win_h - self.title_h*i - title_align_top
        self.title_t[i]:setPosition( title_x, py)
    end

    -- 设置后面的
    if title_index ~= #self.title_t then
        for i=title_index+1, #self.title_t do
            self.title_t[i]:setPosition( title_x, self.win_h-self.title_h*i-self.scroll_h_t[title_index]-title_align_bottom )
        end
    end

    --self.scroll_bg:setPosition( self.title_x, self.title_h*(#self.title_t-title_index)+5 )
end

-- 更新 item 选择
-- function LHExpandListView:update_item_sld( item_index )
--     if self.scroll_items_arr[self.cur_title_index][self.cur_item_index] ~= nil then
--         -- self.scroll_items_arr[self.cur_title_index][self.cur_item_index]:setIsVisible( true )
--         self.scroll_items_arr[self.cur_title_index][self.cur_item_index]:removeChildByTag( 5, true )
--     end
--     self.cur_item_index = item_index
--     local show_sld = CCBasePanel:panelWithFile( 0, 0, self.title_w, self.title_h, "ui/lh_common/slot_focus.png", 500, 500 )
--     self.scroll_items_arr[self.cur_title_index][self.cur_item_index]:addChild( show_sld, 99, 5 )
-- end

-- title点击调用方法,选择title-----------------------------------------------
function LHExpandListView:slt_title_func( title_index )
    if self.cur_title_index ~= nil and self.cur_item_index ~= nil then
        if self.scroll_items_arr[self.cur_title_index][self.cur_item_index] ~= nil then
            self.scroll_items_arr[self.cur_title_index][self.cur_item_index]:removeChildByTag( 5, true )
        end
    end
    -- 
    self.cur_title_index = title_index
    self.cur_item_index = nil
    -- print("------------------------------------------------------true:", title_index, #self.item_data[title_index].items, #self.item_data[title_index].items > 0)
    if #self.item_data[title_index].items > 0 then
        -- 回调
        if self.scroll_items_arr[title_index] == nil then
            self.scroll_items_arr[title_index] = {}
        end
        self:create_scrollView( self.view, self.cur_title_index )
        self:update_title_btn_pos( self.cur_title_index )
    end
    local f = self.registerTitleFunc
    if f ~= nil then
        f(self.cur_title_index, nil)
    end
end

---------选择一个item-------------------------------------------------------
function LHExpandListView:slt_item_func( title_index, item_index, item_value )
    if self.view ~= nil then 
        if self.cur_title_index ~= nil and self.cur_item_index ~= nil then
            if self.scroll_items_arr[self.cur_title_index][self.cur_item_index] ~= nil then
                self.scroll_items_arr[self.cur_title_index][self.cur_item_index]:removeChildByTag( 5, true )
            end
        end

        self.cur_item_index = item_index
        self.cur_title_index = title_index
        local show_sld = CCBasePanel:panelWithFile( 0, 0, self.title_w, self.title_h, "ui/lh_common/slot_focus.png", 500, 500 )
        self.scroll_items_arr[self.cur_title_index][self.cur_item_index]:addChild( show_sld, 99, 5 )

        local f = self.registerItemFunc
        if f ~= nil then
            f( self.cur_title_index, self.cur_item_index, item_value )
        end
    end
end

-- 初始化
function LHExpandListView:init_slt( ... )
    if #self.item_data > 0 then
        for i=1, #self.item_data do
            if #self.item_data[i].items > 0 then
                for j=1, #self.item_data[i].items do
                    self:slt_title_func(i)
                    self:slt_item_func(i, j, self.item_data[i].items[j][2])
                    return 
                end
            else
                self:call_func_nil()
            end
        end
    else
        self:call_func_nil()
    end
end

-- 触发 没有title或item的事件
function LHExpandListView:call_func_nil()
    if self.registerNilFunc ~= nil then
        self.registerNilFunc()
    end
end

---------
---------
function LHExpandListView:getCurSelect()
    if self.view ~= nil then 
        return self.view:getCurSelect()
    else
        return nil
    end
end

---------
---------
function LHExpandListView:getCurNum()
    if self.view ~= nil then
        return self.view:getCurNum()
    else
        return nil
    end
end
---------
---------
function LHExpandListView:getIndexItem(index)
    if self.view ~= nil then
        return self.item_group[index + 1]
    else
        return nil
    end
end