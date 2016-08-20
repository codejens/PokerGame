-- ZSlotMove.lua
-- created by aXing on 2014-5-12
-- 实现格子可移动属性

super_class.ZSlotMove(ZSlotBase)

function ZSlotMove:__init( width, height )

	self.enable_drag = true			-- 默认可以拖动

end

function ZSlotMove:fini(  )
	XSlotBase.fini(self)			-- 先调用基类
end