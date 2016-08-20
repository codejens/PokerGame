--SimpleTipView
--简单的tip，只有一段文本,字号16


super_class.SimpleTipView(Window)



function SimpleTipView:__init(  )
	self.dialog = ZDialog:create(self.view, self.data.str, 10, 5, 160, 140, 16)
end

function SimpleTipView:create( data )
	self.data = data;
	local temp_info = { texture ="", x = 0, y = 0, width = 170, height = 150 }
	if data.width then
		temp_info.width = data.width
	end
	if data.height then
		temp_info.height = data.height
	end
	return SimpleTipView("simple_tip", UILH_COMMON.bottom_bg, 0, 180, 150, 200)
end
