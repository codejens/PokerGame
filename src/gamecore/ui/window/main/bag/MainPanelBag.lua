--MainPanelBag.lua
--created by liubo on 2015-05-14
--主界面背包模块
MainPanelBag = simple_class(GUIStudioView)

local _LAYOUT_FILE = "layout/studio/mainpanel/bag/stu_mainpanel_bag.lua"     -- 本页的布局文件

---对外接口---

--背包点击回调
local function bag_cb_func()
    MainPanelCC:bag_cb()
end

--------------

function MainPanelBag:__init( view )
	self:register_listener()
end

--初始化页
function MainPanelBag:viewCreateCompleted() 
	self.view:setPosition(240,18)
end

-- 注册事件回调
function MainPanelBag:register_listener( ... )
	--背包监听
    local function cb_func( sender,eventType )
        if eventType == ccui.TouchEventType.ended then
            bag_cb_func()
        end
    end 
    self:widgetTouchEventListener('B_Bag',cb_func)
end

-- 创建接口
function MainPanelBag:create(  )
	return self:createWithLayout( _LAYOUT_FILE )
end

-- 更新
-- @param update_type 更新类型
-- @param data 更新的数据 
function MainPanelBag:update( update_type, data )
	if update_type == "" then

	end
end

--- 变成激活（显示）情况调用
function MainPanelBag:active(  )

end

-- 变成 非激活
function MainPanelBag:unActive(  )

end