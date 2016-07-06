    if ( protocol_func_map_server[25] == nil ) then
        protocol_func_map_server[25] = {}
    end



    --获取好友、仇人、隔离区列表
    --接收服务器
    protocol_func_map_server[25][1] = function ( np )
        local var_1_int = np:readInt( ) --数量
        -- 好友数据--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 25, 1, var_1_int, var_2_array )--分发数据
    end

    --加好友，黑名单或者仇人，至于是那样，看好友数据里面的类型字段
    --接收服务器
    protocol_func_map_server[25][7] = function ( np )
        -- 好友数据--s本参数存在特殊说明，请查阅协议编辑器
        -- protocol manual server 结构体
         local var_1_struct = nil
        --var_1_struct = struct( np )
        PacketDispatcher:dispather( 25, 7, var_1_struct )--分发数据
    end

    --下发一键征友列表
    --接收服务器
    protocol_func_map_server[25][14] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --数量
        -- 玩家信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 25, 14, var_1_unsigned_char, var_2_array )--分发数据
    end

