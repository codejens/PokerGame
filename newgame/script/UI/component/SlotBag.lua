-- SlotBag.lua
-- created by aXing on 2012-12-10
-- 继承自SlotItem
-- 实现一些背包和仓库里面格子的功能，例如显示上锁标志

require "UI/component/SlotItem"

super_class.SlotBag(SlotItem)

function SlotBag:__init( width, height )
end

-- 设置无效
function SlotBag:set_slot_disable(  )
	self.view:setCurState( CLICK_STATE_DISABLE )
	if self.cur_icon_texture ~= '' then
		local grayname = MUtils.GetGrayscaleName(self.cur_icon_texture)
		self.cur_icon_texture = grayname
		self.icon:replaceTexture(grayname)
	end
end

-- 设置生效
function SlotBag:set_slot_enable(  )
	self.view:setCurState( CLICK_STATE_UP )
	--self.icon:setCurState( CLICK_STATE_UP )
	self.cur_icon_texture = MUtils.GetNormalName(self.cur_icon_texture)
	self.icon:replaceTexture(self.cur_icon_texture)
	if self.icon_bg then
        self.icon_bg:setCurState( CLICK_STATE_UP )
	end
	if self.color_frame then
        self.color_frame:setCurState( CLICK_STATE_UP )
	end
end
