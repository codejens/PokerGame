-- ClickMenu.lua
-- created by liubo on 2015-05-15
-- 点击菜单

ClickMenu = simple_class()


local _BTN_POS_X = 20 --菜单按钮X轴位置
local _BTN_INTERVAL_Y = 66 --按钮垂直间隔
local _BG_WIDTH = 160 --背景宽度

local _bg_height = 0 --背景高度

--创建
--data = {{func=cb_function, param=cb_func_param, name="私聊"},...} 
--data[i].func 菜单回调函数 | data[i].param 透传参数，通过回调函数透传 | data[i].name 菜单名字
function ClickMenu:create(data)
    return self(data)
end

--构造方法
function ClickMenu:__init(data)
    self.btn = {}
    self.view = GUIImg:create9Img(_PATH_COMMON_SLOT_BG)
    if not data then
        return self.view
    end

    --初始化背景
    self:init_bg(data) 

    --初始化菜单按钮
    self:init_menu_btn(data)

    return self.view
end

--初始化背景
function ClickMenu:init_bg(data)
    _bg_height = (#data * _BTN_INTERVAL_Y) + (10 * 2)
    if _bg_height > CC_DESIGN_RESOLUTION.height then
        _bg_height = CC_DESIGN_RESOLUTION.height
    end
    self:setBgContentSize(_BG_WIDTH, _bg_height)
    self:setBgAnchorPoint(0, 0)
end

--初始化菜单按钮
function ClickMenu:init_menu_btn(data)
    local pos_y
    for i,v in ipairs(data) do
        pos_y = _bg_height - (i * _BTN_INTERVAL_Y ) - 8
        if pos_y < 0 then
            pos_y = 0
        end
        self.btn[i] = GUIButton:create(_PATH_COMMON_TAB_BTN_NORMAL)
        self.btn[i]:setTitleText(v.name,FONT_SIZE_NORMAL)
        self.btn[i]:setPosition(_BTN_POS_X, pos_y)
        self.btn[i]:setAnchorPoint(0, 0)
        self.btn[i]:setTexturePressed(_PATH_COMMON_TAB_BTN_SELECTED)
        
        local function touchfunc( sender,eventType )
            if eventType == ccui.TouchEventType.ended then
                v.func(v.param)
            end
        end 
        self.btn[i]:addTouchEventListener(touchfunc)
        self.view:addChild(self.btn[i])
    end
end

--设置菜单背景大小
function ClickMenu:setBgContentSize(width, height)
    self.view:setContentSize(width, height)
end

--设置菜单背景材质
function ClickMenu:loadBgTexture(texture)
    self.view:loadTexture(texture)
end

--设置菜单背景位置
function ClickMenu:setBgPosition(pos_x, pos_y)
    self.view:setPosition(pos_x, pos_y)
end

--设置菜单背景锚点
function ClickMenu:setBgAnchorPoint(p_x, p_y)
    self.view:setAnchorPoint(p_x, p_y)
end

--获取索引获取按钮
function ClickMenu:get_btn_by_index(index)
    return self.btn[i]
end

--获取菜单背景
function ClickMenu:get_bg()
    return self.view
end