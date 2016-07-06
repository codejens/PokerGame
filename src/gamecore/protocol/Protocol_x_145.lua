    if ( protocol_func_map_server[145] == nil ) then
        protocol_func_map_server[145] = {}
    end



    --通知短期目标奖励状态
    --接收服务器
    protocol_func_map_server[145][1] = function ( np )
        local var_1_char = np:readChar( ) --状态--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_int = np:readInt( ) --可领取等级
        local var_3_int = np:readInt( ) --奖励物品列表长度
        -- 奖励物品列表--s本参数存在特殊说明，请查阅协议编辑器
        local var_4_array = {}
        for i = 1, var_3_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_4_array, structObj )
        end
        PacketDispatcher:dispather( 145, 1, var_1_char, var_2_int, var_3_int, var_4_array )--分发数据
    end

