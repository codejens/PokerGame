    if ( protocol_func_map_server[129] == nil ) then
        protocol_func_map_server[129] = {}
    end



    --下发自动战斗的保存的内容
    --接收服务器
    protocol_func_map_server[129][1] = function ( np )
        local var_1_int = np:readInt( ) --数据的数量（个数）
        -- --s本参数存在特殊说明，请查阅协议编辑器
        -- protocol manual server 结构体
         local var_2_struct = nil
        --var_2_struct = struct( np )
        PacketDispatcher:dispather( 129, 1, var_1_int, var_2_struct )--分发数据
    end

