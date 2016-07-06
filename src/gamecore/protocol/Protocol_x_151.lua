    if ( protocol_func_map_server[151] == nil ) then
        protocol_func_map_server[151] = {}
    end



    --发送魅力奖励信息
    --接收服务器
    protocol_func_map_server[151][4] = function ( np )
        local var_1_int = np:readInt( ) --活动剩余时间（秒）
        local var_2_int = np:readInt( ) --多少项
        -- 排行榜项（第一名，第二名。。。）--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_array = {}
        for i = 1, var_2_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_3_array, structObj )
        end
        PacketDispatcher:dispather( 151, 4, var_1_int, var_2_int, var_3_array )--分发数据
    end

