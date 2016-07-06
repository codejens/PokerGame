    if ( protocol_func_map_server[131] == nil ) then
        protocol_func_map_server[131] = {}
    end



    --下发角色所在队伍的在线成员的信息，用于选择队员结拜
    --接收服务器
    protocol_func_map_server[131][2] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --队员的人数
        local var_2_unsigned_char = np:readByte( ) --本人已经结拜的兄弟数量--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_unsigned_char = np:readByte( ) --最多可以结拜的数量
        local var_4_unsigned_int = np:readUInt( ) --每个结拜所需要的银两
        -- 每个队员的信息--s本参数存在特殊说明，请查阅协议编辑器
        -- protocol manual server 结构体
         local var_5_struct = nil
        --var_5_struct = struct( np )
        PacketDispatcher:dispather( 131, 2, var_1_unsigned_char, var_2_unsigned_char, var_3_unsigned_char, var_4_unsigned_int, var_5_struct )--分发数据
    end

