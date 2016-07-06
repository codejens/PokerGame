protocol_func_map_server = {}
protocol_func_map_client = {}
protocol_func_map = {}



-- 类型检查
function protocol_func_map:check_param_type( check_table )
    for i = 1, #check_table do 
    	local type_map = check_table[i] or {}
    	local param_type = type( type_map.param_name )
    	print("check_table : ", type_map.param_name, param_type, type_map.lua_type )
        if ( param_type == "nil" or param_type ~= type_map.lua_type ) then
        	print("传入参数类型错误!!! 第 " .. i .. " 个参数应该是 ", tostring(type_map.lua_type), " 类型")
            return false
        end
    end
    return true
end