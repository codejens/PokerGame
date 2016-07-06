protocol_func_map_client[15] = {
    --拾取一个掉落物品
    --客户端发送
    [1] = function ( 
                param_1_int64 -- 包裹的handle
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int64, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 15, 1 ) 
        np:writeInt64( param_1_int64 )
        NetManager:send_packet( np )
    end,


}



protocol_func_map_server[15] = {
    --包裹出现
    --接收服务器
    [2] = function ( np )
        local var_1_int64 = np:readInt64( ) --包裹的handle
        local var_2_int = np:readInt( ) --x坐标
        local var_3_int = np:readInt( ) --y坐标
        local var_4_int = np:readInt( ) --怪物id，也就是哪个怪物死亡掉落的
        local var_5_int = np:readInt( ) --killer，玩家id
        local var_6_unsigned_int = np:readUInt( ) --队伍id--s本参数存在特殊说明，请查阅协议编辑器
        local var_7_int = np:readInt( ) --物品id--s本参数存在特殊说明，请查阅协议编辑器
        local var_8_int = np:readInt( ) --金钱类型，如果物品id不为0，这个字段没意义，不过客户端还是要读
        local var_9_int = np:readInt( ) --数量，如果是 物品，表示是物品的数量，否则是金钱的数量
        local var_10_int = np:readInt( ) --变成自由状态剩余的时间（单位秒），如果是0，表示已经是自由状态了--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 15, 2, var_1_int64, var_2_int, var_3_int, var_4_int, var_5_int, var_6_unsigned_int, var_7_int, var_8_int, var_9_int, var_10_int )--分发数据
    end,

    --包裹消失
    --接收服务器
    [3] = function ( np )
        local var_1_int64 = np:readInt64( ) --包裹的handle
        PacketDispatcher:dispather( 15, 3, var_1_int64 )--分发数据
    end,

    --拾取物品返回结果
    --接收服务器
    [1] = function ( np )
        local var_1_int = np:readInt( ) --拾取类型--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_int = np:readInt( ) --物品ID或金钱类型--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 15, 1, var_1_int, var_2_int )--分发数据
    end,


}
