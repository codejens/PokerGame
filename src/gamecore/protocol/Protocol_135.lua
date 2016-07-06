protocol_func_map_client[135] = {

}



protocol_func_map_server[135] = {
    --租用仓库的结果
    --接收服务器
    [1] = function ( np )
        local var_1_bool = np:readChar( ) --租用仓库结果
        PacketDispatcher:dispather( 135, 1, var_1_bool )--分发数据
    end,


}
