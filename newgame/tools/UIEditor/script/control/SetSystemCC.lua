-- SetSystemCC.lua
-- created by lyl on 2013-3-18
-- 设置系统

-- super_class.SetSystemCC()
SetSystemCC = {}

-- c->s 129,1  读取所有设置的数据
function SetSystemCC:request_set_date(  )
	-- print("c->s 129,1  读取所有设置的数据")
	local pack = NetManager:get_socket():alloc(129, 1)
	NetManager:get_socket():SendToSrv(pack)
end

-- s->c 129,1 服务器下发所有设置的数据
function SetSystemCC:do_result_set_date( pack )
	-- print("s->c 129,1 服务器下发所有设置的数据")
	local count = pack:readInt()
	local set_date = {}                    -- 设置数据表 
	local key_temp = nil                   -- 数据的每个元素是键值对
	local value_temp = nil
	for i = 1, count do 
		key_temp = pack:readInt()
		value_temp = pack:readInt()
		-- print(" s->c 129,1,,,,,,,, ", key_temp, value_temp )
        set_date[ key_temp ] = value_temp
	end

	require "model/SetSystemModel"
	SetSystemModel:set_all_date( set_date )
end

-- c->s 129,2  保存所有设置数据
function SetSystemCC:request_save_set_date( count, set_date_t )
	-- print("c->s 129,2  保存所有设置数据")
	local pack = NetManager:get_socket():alloc(129, 2)
	pack:writeInt(count)
    for key, value in pairs( set_date_t ) do               -- set_date_t 中不是按顺序存的，是键值对。所以无所谓顺序，可以用pairs
    	-- print(" c->s 129,2......... ", key, value)
        pack:writeInt(key)
        pack:writeUInt(value)
    end
	NetManager:get_socket():SendToSrv(pack)
end