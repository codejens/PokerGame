--MainWin.lua
RoomListWin = simple_class(GUIWindow)

function RoomListWin:update(param_1,param_2,param_3,param_4)
end

function RoomListWin:__init()
	
end

function RoomListWin:init(is_fini)
	if is_fini then
		
	end
end

--获取服务器下发的数据
function RoomListWin:get_data()
end

function RoomListWin:init_widget()
	
end

function RoomListWin:registered_envetn_func()

end

function RoomListWin:destory()

	self:init(true)
end