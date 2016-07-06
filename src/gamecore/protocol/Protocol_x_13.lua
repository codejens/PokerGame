    if ( protocol_func_map_server[13] == nil ) then
        protocol_func_map_server[13] = {}
    end



    --交易对方添加物品
    --接收服务器
    protocol_func_map_server[13][5] = function ( np )
        local var_1_int = np:readInt( ) --0删除， 1增加--s本参数存在特殊说明，请查阅协议编辑器
        -- 物品数据--s本参数存在特殊说明，请查阅协议编辑器
        -- protocol manual server 结构体
         local var_2_struct = nil
        --var_2_struct = struct( np )
        PacketDispatcher:dispather( 13, 5, var_1_int, var_2_struct )--分发数据
    end

