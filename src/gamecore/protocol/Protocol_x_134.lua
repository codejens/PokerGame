    if ( protocol_func_map_server[134] == nil ) then
        protocol_func_map_server[134] = {}
    end



    --返回客户端该玩家的快捷键设置
    --接收服务器
    protocol_func_map_server[134][2] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --快捷键设置项个数
        -- 快捷键设置项--s本参数存在特殊说明，请查阅协议编辑器
        -- protocol manual server 结构体
         local var_2_struct = nil
        --var_2_struct = struct( np )
        PacketDispatcher:dispather( 134, 2, var_1_unsigned_char, var_2_struct )--分发数据
    end

