    if ( protocol_func_map_server[140] == nil ) then
        protocol_func_map_server[140] = {}
    end



    --通知客户端打开成就礼包界面
    --接收服务器
    protocol_func_map_server[140][1] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --物品个数
        -- 物品信息--s本参数存在特殊说明，请查阅协议编辑器
        -- protocol manual server 结构体
         local var_2_struct = nil
        --var_2_struct = struct( np )
        local var_3_string = np:readString( ) --抽奖界面标题
        local var_4_unsigned_char = np:readByte( ) --抽奖结果
        local var_5_unsigned_short = np:readWord( ) --抽奖物品ID
        PacketDispatcher:dispather( 140, 1, var_1_unsigned_char, var_2_struct, var_3_string, var_4_unsigned_char, var_5_unsigned_short )--分发数据
    end

