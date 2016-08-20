-- LeftClickMenu.lua
-- created by lyl on 2012-1-25
-- 左键菜单

super_class.LeftClickMenu(  )

require "model/LeftClickMenuMgr"
require "UI/component/AlertWin"
require "utils/UI/UIButton"
require "utils/UI/UILabel"

-- 菜单统一配置数据
local _word_font_size         = 16         -- 字号
local _item_height            = 45         -- 选项高度
local _item_width             = 121          -- 选项宽度
local _word_margin            = 3
local _item_direction_margin  = 2          -- 纵向间距
local _Item_horizonal_margin  = 5          -- 横向间距

-- 初始化方法
-- 与LeftClickMenuMgr配合使用右键菜单
-- menu_key:   字符串 ，用于获取具体菜单项
-- if_disposable  bool 型: 不填则默认为true。  true，点击任何地方都会关闭菜单。 false： 点击菜单后，菜单仍然存在
-- x, y  :  坐标，默认为0
function LeftClickMenu:__init( menu_key, x, y )
    self.items_t = {}                                 -- 存储所有item
    self.select_item_key = ""                         -- 当前选中的item的key

	-- 计算显示数值
	-- local max_word_num = LeftClickMenuMgr:get_menu_max_length( menu_key )                                      -- 选项中最大字符数
	local items_key    = LeftClickMenuMgr:get_one_menu_item( menu_key )                                        -- 所有选项关键字
    -- self.item_width    = max_word_num * _word_font_size + _word_margin * 2                                     -- 选项宽度
	self.menu_width    = _item_width + _Item_horizonal_margin * 2                                          -- 菜单宽     
	self.menu_height   = table.maxn( items_key ) * ( _item_height + _item_direction_margin ) + _item_direction_margin  -- 菜单高      
    
    -- 背景
    local pos_x = x or 0
    local pos_y = y or 0
    self.view = CCBasePanel:panelWithFile( pos_x, pos_y, self.menu_width+20, self.menu_height+20, UILH_COMMON.bottom_bg, 500, 500 )

    local function f1(eventType,x,y)
        if eventType == TOUCH_ENDED then
            -- 不让面板区域可以点穿，直接关闭alert
            -- UIManager:hide_window( "alert_win" )
            -- ----print("右键菜单背景被按到。。。。。")
            AlertWin:close_alert(  )
            return true
        elseif eventType then
            return true
        end
    end
    self.view:registerScriptHandler(f1)
    
    -- 按钮
    local item_x_temp = 0
    local item_y_temp = 0
    for i = 1, table.maxn( items_key ) do
        if items_key[i] then     -- 支持中间有空格的特殊情况. 当nil，则空格。
            item_x_temp = _Item_horizonal_margin+10
            item_y_temp = ( _item_height + _item_direction_margin )* ( table.maxn( items_key ) - i ) + _item_direction_margin+10
            self:create_menu_item( item_x_temp, item_y_temp, _item_width, _item_height, items_key[i] )
        end
    end
end

-- 创建一个 item（按钮）
function LeftClickMenu:create_menu_item( but_x, but_y, but_w, but_h, item_key )
	-- 选项底板
    -- UIResourcePath.FileLocate.common .. "liebiao_xuan.png"
    local menu_item = {}
    local menu_item_bg = CCBasePanel:panelWithFile( but_x, but_y, but_w, but_h, "" , 500, 500 )
    menu_item.view = menu_item_bg

	-- local function callback_fun( eventType,x,y )
 --        if eventType == TOUCH_BEGIN then
 --            self.view:setTexture(UIPIC_friend_011)
 --        elseif eventType == TOUCH_ENDED then
 --            -- AlertWin:close_alert(  )
 --            -- ----print("邮件菜单想想想项  背景被按到。。。。。", item_key)
        -- local function BtnClickFun()
            local function callback_fun(  )
                self.select_item_key = item_key
                LeftClickMenuMgr:run_item_fun( item_key )
                AlertWin:close_alert(  )
            end
			-- local callback_temp = callback:new()
   --          callback_temp:start( 0, callback_fun )
   --      end
 --            
 --        return true
	-- end

	-- menu_item.view:registerScriptHandler( callback_fun )
    local itemBtn = ZButton:create(nil, {UILH_COMMON.btn4_nor, UILH_COMMON.btn4_sel}, callback_fun, but_x, but_y, but_w, but_h)
    self.view:addChild( itemBtn.view)
    -- 选项名称
    local item_name = LeftClickMenuMgr:get_item_name_by_key( item_key )                    -- 获取名称
    local item_name_x = 0 + but_w / 2
    local item_name_y = ( _item_height - _word_font_size ) / 2+2
    local item_name_lable = UILabel:create_lable_2( item_name, item_name_x, item_name_y , _word_font_size, ALIGN_CENTER )

    -- if item_name == "邀请组队" or item_name == "赠送鲜花" then
    --     itemBtn.view:addTexWithFile(CLICK_STATE_DISABLE, UILH_COMMON.btn4_dis)
    --     itemBtn.view:setCurState(CLICK_STATE_DISABLE)
    -- end
    -- 选项选中状态框
    -- menu_item.seleted_frame = CCZXImage:imageWithFile( 0, 0, but_w, but_h, "ui/common/list_select.png", 500, 500 )
    -- menu_item.seleted_frame:setIsVisible(false)

    -- menu_item:addChild( menu_item.seleted_frame )
    menu_item.view:addChild( item_name_lable )
	self.view:addChild( menu_item.view)

    menu_item.item_key = item_key
    table.insert( self.items_t, menu_item )
end

-- -- 刷新选中状态
-- function LeftClickMenu:flash_selected_item(  )
--     for key, item in pairs( self.items_t ) do
--         if item.item_key == self.select_item_key then
--             item.seleted_frame:setIsVisible(true)
--         else
--             item.seleted_frame:setIsVisible(false)
--         end
--     end
-- end

-- 显示左键菜单 (静态调用)
-- 参数1： 菜单选项 的 key （ 用于获取菜单项的名称和回调函数 ）
-- 参数2  3：显示menu的坐标
function LeftClickMenu:show_Left_click_menu( menu_key, x, y )
	local menu =  LeftClickMenu( menu_key, x, y )
    -- 需要实现点击关闭。 把菜单显示在 AlertWin 中
    AlertWin:show_new_alert( menu.view )
    return menu
end