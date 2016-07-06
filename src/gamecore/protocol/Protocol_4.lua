protocol_func_map_client[4] = {

}



protocol_func_map_server[4] = {
    --添加Buff
    --接收服务器
    [1] = function ( np )
        local var_1_int64 = np:readInt64( ) --实体的handle
        local var_2_unsigned_char = np:readByte( ) --Buff的类型
        local var_3_unsigned_char = np:readByte( ) --Buff的groupID
        local var_4_int = np:readInt( ) --剩余的时间
        local var_5_unsigned_char = np:readByte( ) --buff数值的类型--s本参数存在特殊说明，请查阅协议编辑器
        local var_6_union = np:readInt( ) --BUFF数值--s本参数存在特殊说明，请查阅协议编辑器
        local var_7_unsigned_short = np:readWord( ) --buff的间隔
        local var_8_string = np:readString( ) --Buff的名字
        PacketDispatcher:dispather( 4, 1, var_1_int64, var_2_unsigned_char, var_3_unsigned_char, var_4_int, var_5_unsigned_char, var_6_union, var_7_unsigned_short, var_8_string )--分发数据
    end,

    --删除一个Buff
    --接收服务器
    [2] = function ( np )
        local var_1_int64 = np:readInt64( ) --实体的handle
        local var_2_unsigned_char = np:readByte( ) --Buff的类型
        local var_3_unsigned_char = np:readByte( ) --Buff的group ID
        PacketDispatcher:dispather( 4, 2, var_1_int64, var_2_unsigned_char, var_3_unsigned_char )--分发数据
    end,

    --删除一类Buff
    --接收服务器
    [3] = function ( np )
        local var_1_int64 = np:readInt64( ) --实体的handle
        local var_2_unsigned_char = np:readByte( ) --Buff的类型
        PacketDispatcher:dispather( 4, 3, var_1_int64, var_2_unsigned_char )--分发数据
    end,

    --嘲讽buff-下发被嘲讽实体的buff来源
    --接收服务器
    [5] = function ( np )
        local var_1_int64 = np:readInt64( ) --sourceHdl，实体hdl，buff的来源
        local var_2_int64 = np:readInt64( ) --petHdl，宠物句柄--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 4, 5, var_1_int64, var_2_int64 )--分发数据
    end,


}
