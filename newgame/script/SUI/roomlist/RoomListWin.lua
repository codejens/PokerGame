--MainWin.lua
super_class.RoomListWin(BaseEditWin)
-- RoomListWin = simple_class(GUIWindow)

function RoomListWin:__init(name,texture)
	print("RoomListWin:__init(),name,texture=",name,texture)
	self:update("update_scroll")
end

function RoomListWin:init(is_fini)
	self.array_btn_main_room = {}
	self._cur_select_main_id = 1
	if is_fini then
	end
end

function RoomListWin:save_widget()
	self:init()
	self.array_btn_main_room[1] = self:get_widget_by_name("btn_chuji")
	self.array_btn_main_room[2] = self:get_widget_by_name("btn_zhongji")
	self.array_btn_main_room[3] = self:get_widget_by_name("btn_gaoji")
	self.btn_back = self:get_widget_by_name("btn_back")
	self.scroll_room_list = self:get_widget_by_name("scroll_room_list")
end

function RoomListWin:update(utype,data)
	if utype == "update_scroll" then
		self:get_main_room_config()
		self:update_scroll()
	end
end

function RoomListWin:update_scroll()
	if self.scroll_room_list then
		local max_count = #self.room_list_config
		self.scroll_room_list:update(max_count)
	end
end

function RoomListWin:clear_room_config()
	self.room_list_config = {}
end

function RoomListWin:get_main_room_config()
	self:clear_room_config()
	local main_room_config = RoomListConfig:get_main_room_config(self._cur_select_main_id)
	for _ , room_config in pairs(main_room_config) do
		for room_index = 1 , room_config.room_num do
			table.insert(self.room_list_config,room_config)
		end
	end
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

	local function array_btn_main_room_func(main_id)
		self._cur_select_main_id = main_id
		self:set_new_view_bg()
		self:update("update_scroll")
	end
	for main_id , btn in pairs(self.array_btn_main_room) do
		btn:set_click_func(bind(array_btn_main_room_func,main_id))
	end
end

function RoomListWin:create_scroll_cell(index)
	local cell_data = self.room_list_config[index]
	local panel = SPanel:quick_create(0,0,w,h,"sui/common/unselected_panel_2.png",true)
	if cell_data then
		SLabel:quick_create(cell_data.name .. index,50,0,panel)
	end
	return panel.view
end

function RoomListWin:set_new_view_bg()
	local path = ""
	if self._cur_select_main_id == 3 then
		--高级
		path = "nopack/gaoji_bg.jpg"
	else
		path = "nopack/chuji_bg.jpg"
	end
	if self.last_bg_path == path then
		return
	end
	self.last_bg_path = path
	self:reset_view_bg()
end

function RoomListWin:reset_view_bg()
	self.view:setTexture(self.last_bg_path)
end

function RoomListWin:destory()
	
end