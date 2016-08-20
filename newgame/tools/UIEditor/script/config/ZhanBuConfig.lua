---------------------
------HJH
------2013-9-6
ZhanBuConfig = {}
----------------------
ZhanBuUpdateType = {
	update_time = 1,
	update_scroll = 2,
}
----------------------
function ZhanBuConfig:get_index_event_info(index)
	require "../data/zhanbuconf"
	local temp_index = { { value = 100, index = 1} , { value = 200, index = 2 }, { value = 300, index = 3 } }
	local cur_index = 1
	for i = 1, #temp_index do
		if temp_index[i].value > index then
			cur_index = temp_index[i].index
			break
		end
	end
	--print("ZhanBuConfig:get_index_event_info cur_index, index", cur_index, index)
	return { ttype = zhanbuconf.events[cur_index].type, info = zhanbuconf.events[cur_index].eventlist[index] }
end
----------------------
function ZhanBuConfig:get_open_limit_level()
	require "../data/zhanbuconf"
	return zhanbuconf.minlv
end