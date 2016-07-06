-- ModalWin.lua
-- created by liubo on 2015-5-15
-- 模态窗口

ModalWin = simple_class(GUIWindow)

--构造方法
function ModalWin:__init( view )
    local function click_func()
        ModalCC:click_func()
    end
    self:addCLickEventListener( click_func )
end

function ModalWin:create()
    self.bg = GUIWidget:create()
    self.bg:setPosition(0, 0)
    self.bg:setContentSize(CC_DESIGN_RESOLUTION.width, CC_DESIGN_RESOLUTION.height)
    self.bg:setAnchorPoint(0, 0)
    return self(self.bg.view)
end

-- 添加子控件
function ModalWin:add_widget(widget)
    if widget then
        self:addChild(widget)
    end
end