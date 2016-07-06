    if ( protocol_func_map_server[22] == nil ) then
        protocol_func_map_server[22] = {}
    end



    --增加新的消息
    --接收服务器
    protocol_func_map_server[22][1] = function ( np )
        local var_1_unsigned_short = np:readWord( ) --消息的总数
        -- 消息内容--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_unsigned_short do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 22, 1, var_1_unsigned_short, var_2_array )--分发数据
    end

