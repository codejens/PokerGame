-- BuffModel.lua
-- 人物buff
BuffModel = {}

local _buff_time_info = {}
function BuffModel:add_time_by_type(buff_type, buff_group)
	_buff_time_info[buff_type] = {}
	_buff_time_info[buff_type][buff_group] = os.time()
end

function BuffModel:get_past_time(buff_type, buff_group)
	if not buff_type or not buff_group then return 0 end
	if _buff_time_info[buff_type][buff_group] then
		return os.time() - _buff_time_info[buff_type][buff_group]
	else
		return 0
	end
end

function BuffModel:remove_time_by_type(buff_type, buff_group)
	if not buff_type or not buff_group then return end
	_buff_time_info[buff_type][buff_group] = nil
end

function BuffModel:fini( ... )
    _buff_time_info = {}
end