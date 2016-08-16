--MainWin.lua
super_class.RoomListWin(BaseEditWin)
-- RoomListWin = simple_class(GUIWindow)

function RoomListWin:__init()
	print("RoomListWin:__init()")
	self:update("update_scroll")
end

function RoomListWin:init(is_fini)
	if is_fini then
	end
end

function RoomListWin:save_widget()
	self:init()
	self.btn_back = self:get_widget_by_name("btn_back")
	self.btn_chuji = self:get_widget_by_name("btn_chuji")
	self.btn_zhongji = self:get_widget_by_name("btn_zhongji")
	self.btn_gaoji = self:get_widget_by_name("btn_gaoji")
	self.scroll_room_list = self:get_widget_by_name("scroll_room_list")
end

function RoomListWin:update(utype,data)
	if utype == "update_scroll" then
		self:get_room_list_data()
		self:update_scroll()
	end
end

function RoomListWin:update_scroll()
	if self.scroll_room_list then
		local max_count = #self.room_list_data
		self.scroll_room_list:update(max_count)
	end
end

function RoomListWin:get_room_list_data()
	self.room_list_data = {
	1,
	2,
	3,
	4,
	1,
	2,
	3,
	4,
	1,
	2,
	3,
	4,
	1,
	2,
	3,
	4,
	1,
	2,
	3,
	4,
	1,
	2,
	3,
	4,
	1,
	2,
	3,
	4,
	1,
	2,
	3,
	4,
	}
end

function RoomListWin:registered_envetn_func()
	local function scroll_create_func(index)
		return self:create_scroll_cell(index+1)
	end
	self.scroll_room_list:set_touch_func(SCROLL_CREATE_ITEM,scroll_create_func)

	local function btn_back_func()
		RoomListModel:close_win()
	end
	self.btn_back:set_click_func(btn_back_func)
end

function RoomListWin:create_scroll_cell(index)
	local cell_data = self.room_list_data[index]
	local panel = SPanel:quick_create(0,0,w,h,"sui/common/unselected_panel_2.png",true)
	if cell_data then
		SLabel:quick_create(index,50,50,panel)
	end
	return panel.view
end

function RoomListWin:destory()

end