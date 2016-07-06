    if ( protocol_func_map_server[146] == nil ) then
        protocol_func_map_server[146] = {}
    end



    --下发周环任务信息
    --接收服务器
    protocol_func_map_server[146][1] = function ( np )
        local var_1_char = np:readChar( ) --图标状态--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_int = np:readInt( ) --总环数
        local var_3_int = np:readInt( ) --已完成环数
        local var_4_int = np:readInt( ) --当前环数
        local var_5_int = np:readInt( ) --当前环任务ID
        local var_6_int = np:readInt( ) --奖励领取情况列表长度
        -- 领奖情况--s本参数存在特殊说明，请查阅协议编辑器
        local var_7_array = {}
        for i = 1, var_6_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_7_array, structObj )
        end
        PacketDispatcher:dispather( 146, 1, var_1_char, var_2_int, var_3_int, var_4_int, var_5_int, var_6_int, var_7_array )--分发数据
    end

