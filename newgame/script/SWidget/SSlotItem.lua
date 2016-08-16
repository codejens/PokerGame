--SSlotItem.lua
--二次封装 slotiteam 方便编辑器编辑

super_class.SSlotItem(SlotItem)

function SSlotItem:__init(w, h)
end

function SSlotItem:create_by_layout(layout)
	local slot = self(layout.size[1], layout.size[2], layout.img_n)
	slot:setPosition(layout.pos[1], layout.pos[2])
	slot.layout = layout
	return slot
end

--仅提供给编辑器使用的
function SSlotItem:setSize(w, h)
	self.icon_bg:setSize(w, h)
end

--仅提供给编辑器使用的
function SSlotItem:setTexture(t)
	self:set_icon_bg_texture(t)
end

function SSlotItem:set_click_func(func)
	self:set_click_event(func)
end

-- 显示与隐藏
function SSlotItem:setIsVisible(flag)
	self.view:setIsVisible(flag)
end

function SSlotItem:addChild(node)
	self.view:addChild(node.view or node)
end