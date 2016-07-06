    if ( protocol_func_map_server[156] == nil ) then
        protocol_func_map_server[156] = {}
    end



    --下发清明活动信息
    --接收服务器
    protocol_func_map_server[156][1] = function ( np )
        local var_1_int = np:readInt( ) --数组长度
        -- 活动内容--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        local var_3_int = np:readInt( ) --图标闪烁--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 156, 1, var_1_int, var_2_array, var_3_int )--分发数据
    end

    --下发清明登陆活动信息
    --接收服务器
    protocol_func_map_server[156][3] = function ( np )
        local var_1_short = np:readShort( ) --累积登陆天数
        local var_2_short = np:readShort( ) --数组长度--s本参数存在特殊说明，请查阅协议编辑器
        -- --s本参数存在特殊说明，请查阅协议编辑器
        local var_3_array = {}
        for i = 1, var_2_short do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_3_array, structObj )
        end
        PacketDispatcher:dispather( 156, 3, var_1_short, var_2_short, var_3_array )--分发数据
    end

