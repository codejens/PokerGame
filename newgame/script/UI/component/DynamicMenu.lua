-- DynamicMenu.lua
-- created by lyl on 2013-3-20
-- 动态菜单
-- 功能：根据字符串表，显示菜单.每项点击，返回对应字符串在该表的位置index

super_class.DynamicMenu(  )

-- 常量定义
DynamicMenu.COORDINATE_TYPE_TOP    = 1                -- 坐标类型：提供的坐标是左 上 角坐标，菜单往 下 弹
DynamicMenu.COORDINATE_TYPE_BOTTOM = 2                -- 坐标类型：提供的坐标是左 下 角坐标，菜单往 上 弹

local _margin_x         = 5                           -- 项的x边距
local _margin_y         = 2                           -- 项的y边距
local _item_begin_x     = _margin_x                   -- 项的起始坐标
local _item_begin_y     = _margin_y                   -- 
local _item_height      = 35                          -- 每项的高度
local _item_intervale_y = _item_height + _margin_y    -- 坐标间距
local _scale_anim_param = { 0.1, 1.1 , 0.1, 1.0 }

local _createScaleInOut = effectCreator.createScaleInOut
-- ==========================================
-- 创建动态菜单
-- string_table  　　　要显示的项的字符串表。 每个元素是一个字符串
-- menu_x  menu_y 　　 菜单的坐标
-- coordinate_type：   坐标的类型，可使用最上面的坐标类型常量定义。 控制菜单弹出的方向。 （往上或者往下）
-- menu_width：  　　　菜单宽度
-- menu_bg： 　　　　　菜单背景图
-- item_callback：　　 回调函数
-- ==========================================
function DynamicMenu:create_menu( string_table, menu_x, menu_y, coordinate_type, menu_width, menu_bg, item_callback, item_texturename, item_color_table )
    local menu_x = menu_x or 0
    local menu_height = _item_intervale_y * (#string_table) + _margin_y            -- 菜单背景面板的高度

    if coordinate_type == DynamicMenu.COORDINATE_TYPE_TOP then                     -- 如果是顶部坐标，坐标要下移面板高度的位置
        menu_y = menu_y - menu_height
    end
    
    -- 菜单面板
    local name_menu_panel = CCBasePanel:panelWithFile( menu_x, menu_y, menu_width, menu_height, menu_bg, 500, 500 )
    

    self.item_texturename = item_texturename or UILH_COMMON.bottom_bg
    self.item_color_table = item_color_table


    -- 创建所有选项
    local item_width = menu_width - _margin_x * 2      

    _item_begin_x = _margin_x + item_width * 0.5
    _item_begin_y = _margin_y + _item_height * 0.5

    -- item宽度
    local forward_ratio = ( coordinate_type == DynamicMenu.COORDINATE_TYPE_TOP ) and 1 or -1             -- 方向系数. 控制是向上延伸还是向下延伸
    for i = 1, #string_table do
        local item = self:create_menu_item( _item_begin_x, _item_begin_y + _item_intervale_y * ( #string_table - i ), item_width, _item_height, string_table[i], i, item_callback )
        item.view:setAnchorPoint(0.5,0.5)
        name_menu_panel:addChild( item.view )
    end

    

    return name_menu_panel
end

-- ==========================================
-- 显示动态菜单
-- string_table  　　　要显示的项的字符串表。 每个元素是一个字符串
-- menu_x  menu_y 　　 菜单的坐标
-- coordinate_type：   坐标的类型，可使用最上面的坐标类型常量定义。 控制菜单弹出的方向。 （往上或者往下）
-- menu_width：  　　　菜单宽度
-- menu_bg： 　　　　　菜单背景图
-- item_callback：　　 回调函数
-- ==========================================
function DynamicMenu:show_menu(  )
    require "UI/component/AlertWin"
    local menu =  DynamicMenu:create_menu( string_table, menu_x, menu_y, coordinate_type, menu_width, menu_bg, item_callback )
    local function f1(eventType,x,y)
        if eventType == TOUCH_ENDED then                                           -- 不让面板区域可以点穿，否则会触发alert关闭，导致按钮相应不到事件。
            AlertWin:close_alert(  )                                               -- 直接关闭alert
            return true
        elseif eventType then
            return true
        end
        return true
    end
    menu:registerScriptHandler(f1)

    -- 显示菜单到alertwin， 点击其他位置可以关闭
    AlertWin:show_new_alert( menu )
end

-- 创建一个选项
function DynamicMenu:create_menu_item( but_x, but_y, but_w, but_h, name, index, callback_func )
    -- 选项底板
    local menu_item = {}
    local menu_item_bg = CCBasePanel:panelWithFile( but_x, but_y, but_w, but_h, self.item_texturename, 500, 500 )

    menu_item.view = menu_item_bg

    local function callback_fun( eventType,x,y )
        if eventType == TOUCH_ENDED then

            if callback_func then
                callback_func( index )
            end
            --[[
            local act = _createScaleInOut(_scale_anim_param[1],_scale_anim_param[2],
                                          _scale_anim_param[3],_scale_anim_param[4])
            menu_item:runAction(act)
            ]]--
            return false
        end
        return true
    end

    if self.item_color_table then
        local ci = index % #self.item_color_table + 1
        menu_item.view:setColor(self.item_color_table[ci])
    end

    --(0xffc0c0c0)
    menu_item.view:registerScriptHandler( callback_fun )

    -- 文字
    menu_item.view:addChild( UILabel:create_lable_2( name, but_w / 2, 12, 20, ALIGN_CENTER ) )

    menu_item.index = index
    return menu_item
end