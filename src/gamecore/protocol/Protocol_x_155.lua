    if ( protocol_func_map_server[155] == nil ) then
        protocol_func_map_server[155] = {}
    end



    --下发三月活动信息
    --接收服务器
    protocol_func_map_server[155][1] = function ( np )
        local var_1_int = np:readInt( ) --数组长度
        -- 活动时间 --s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        local var_3_int = np:readInt( ) --图标闪烁--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 155, 1, var_1_int, var_2_array, var_3_int )--分发数据
    end

    --领取礼包
    --接收服务器
    protocol_func_map_server[155][2] = function ( np )
        local var_1_int = np:readInt( ) --数组长度
        -- --s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 155, 2, var_1_int, var_2_array )--分发数据
    end

