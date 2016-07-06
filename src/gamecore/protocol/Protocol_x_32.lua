    if ( protocol_func_map_server[32] == nil ) then
        protocol_func_map_server[32] = {}
    end



    --下发玩家初始化阵营数据
    --接收服务器
    protocol_func_map_server[32][1] = function ( np )
        local var_1_int = np:readInt( ) --阵营Id
        local var_2_int = np:readInt( ) --江湖地位Id--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_int = np:readInt( ) --阵营实力值
        local var_4_int = np:readInt( ) --结盟阵营Id
        local var_5_unsigned_int = np:readUInt( ) --结盟操作冷却时间（短时间格式）
        local var_6_string = np:readString( ) --阵营盟主名称--s本参数存在特殊说明，请查阅协议编辑器
        local var_7_string = np:readString( ) --阵营公告
        -- 阵营Buff--s本参数存在特殊说明，请查阅协议编辑器
        -- protocol manual server 结构体
         local var_8_struct = nil
        --var_8_struct = struct( np )
        PacketDispatcher:dispather( 32, 1, var_1_int, var_2_int, var_3_int, var_4_int, var_5_unsigned_int, var_6_string, var_7_string, var_8_struct )--分发数据
    end

    --下发阵营职位
    --接收服务器
    protocol_func_map_server[32][5] = function ( np )
        local var_1_int = np:readInt( ) --阵营职位数量
        -- 职位信息--s本参数存在特殊说明，请查阅协议编辑器
        -- protocol manual server 结构体
         local var_2_struct = nil
        --var_2_struct = struct( np )
        PacketDispatcher:dispather( 32, 5, var_1_int, var_2_struct )--分发数据
    end

    --下发阵营实力排行数据
    --接收服务器
    protocol_func_map_server[32][13] = function ( np )
        local var_1_int = np:readInt( ) --排行元素数量
        -- 阵营排行信息--s本参数存在特殊说明，请查阅协议编辑器
        -- protocol manual server 结构体
         local var_2_struct = nil
        --var_2_struct = struct( np )
        PacketDispatcher:dispather( 32, 13, var_1_int, var_2_struct )--分发数据
    end

    --下发阵营buff数据
    --接收服务器
    protocol_func_map_server[32][16] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --buff数量
        -- buff数据--s本参数存在特殊说明，请查阅协议编辑器
        -- protocol manual server 结构体
         local var_2_struct = nil
        --var_2_struct = struct( np )
        PacketDispatcher:dispather( 32, 16, var_1_unsigned_char, var_2_struct )--分发数据
    end

