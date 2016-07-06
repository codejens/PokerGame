protocol_func_map_client[148] = {
    --戒指进阶-婚戒升级
    --客户端发送
    [2] = function ( 
                param_1_unsigned_char -- 0:普通升级，1：高级升级
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 148, 2 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --婚礼-举办婚礼
    --客户端发送
    [3] = function ( 
                param_1_int,  -- 1：普通婚礼，2：豪华
                param_2_int -- 婚礼时间--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" }, { param_name = param_2_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 148, 3 ) 
        np:writeInt( param_1_int )
        np:writeInt( param_2_int )
        NetManager:send_packet( np )
    end,

    --获取本服仙侣记录
    --客户端发送
    [4] = function ( 
                param_1_int,  -- 每页的个数
                param_2_int -- 当前第几页--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" }, { param_name = param_2_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 148, 4 ) 
        np:writeInt( param_1_int )
        np:writeInt( param_2_int )
        NetManager:send_packet( np )
    end,

    --A向B求婚
    --客户端发送
    [5] = function ( 
                param_1_int,  -- 对方id
                param_2_string -- 对方名字
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" }, { param_name = param_2_string, lua_type = "string" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 148, 5 ) 
        np:writeInt( param_1_int )
        np:writeString( param_2_string )
        NetManager:send_packet( np )
    end,

    --B同意或拒绝求婚
    --客户端发送
    [6] = function ( 
                param_1_int,  -- 1：同意，2：拒绝
                param_2_int -- 对方的id
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" }, { param_name = param_2_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 148, 6 ) 
        np:writeInt( param_1_int )
        np:writeInt( param_2_int )
        NetManager:send_packet( np )
    end,

    --升级仙缘，成功会下发协议7
    --客户端发送
    [8] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 148, 8 ) 
        NetManager:send_packet( np )
    end,

    --婚礼-参加婚礼
    --客户端发送
    [9] = function ( 
                param_1_int -- 婚礼id
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 148, 9 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --婚礼-婚礼互动
    --客户端发送
    [10] = function ( 
                param_1_int -- 互动类型--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 148, 10 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --婚礼-增加撒喜糖次数
    --客户端发送
    [11] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 148, 11 ) 
        NetManager:send_packet( np )
    end,

    --巡游-开启巡游
    --客户端发送
    [12] = function ( 
                param_1_int -- 巡游类型--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 148, 12 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --婚礼-获取婚礼列表
    --客户端发送
    [13] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 148, 13 ) 
        NetManager:send_packet( np )
    end,

    --戒指进阶-激活戒指
    --客户端发送
    [21] = function ( 
                param_1_unsigned_char -- autoBuy，是否自动购买--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 148, 21 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --跳转到B身边
    --客户端发送
    [22] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 148, 22 ) 
        NetManager:send_packet( np )
    end,


}



protocol_func_map_server[148] = {
    --结婚系统的初始化数据
    --接收服务器
    [1] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --state，状态--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_int = np:readInt( ) --亲密度
        local var_3_int = np:readInt( ) --结婚对象的角色id，如果是0，表示未婚
        local var_4_string = np:readString( ) --对象的角色名称
        local var_5_unsigned_char = np:readByte( ) --sex，性别
        local var_6_unsigned_char = np:readByte( ) --job，职业
        local var_7_int = np:readInt( ) --level，等级
        local var_8_unsigned_char = np:readByte( ) --ringStage，戒指等级--s本参数存在特殊说明，请查阅协议编辑器
        local var_9_int = np:readInt( ) --ringZhufu，戒指祝福值
        local var_10_unsigned_char = np:readByte( ) --extraStage，对方的戒指等级
        local var_11_int = np:readInt( ) --高2位是仙缘的等级，低2位是开启仙缘的个数--s本参数存在特殊说明，请查阅协议编辑器
        local var_12_int = np:readInt( ) --戒指进阶高级进阶剩余次数
        PacketDispatcher:dispather( 148, 1, var_1_unsigned_char, var_2_int, var_3_int, var_4_string, var_5_unsigned_char, var_6_unsigned_char, var_7_int, var_8_unsigned_char, var_9_int, var_10_unsigned_char, var_11_int, var_12_int )--分发数据
    end,

    --转发A的求婚到B
    --接收服务器
    [5] = function ( np )
        local var_1_int = np:readInt( ) --发起求婚的人的id
        local var_2_unsigned_char = np:readByte( ) --性别
        local var_3_unsigned_char = np:readByte( ) --职业
        local var_4_unsigned_char = np:readByte( ) --阵营id
        local var_5_unsigned_char = np:readByte( ) --等级
        local var_6_string = np:readString( ) --对方名字
        PacketDispatcher:dispather( 148, 5, var_1_int, var_2_unsigned_char, var_3_unsigned_char, var_4_unsigned_char, var_5_unsigned_char, var_6_string )--分发数据
    end,

    --仙缘信息
    --接收服务器
    [7] = function ( np )
        local var_1_int = np:readInt( ) --高2位是仙缘的等级，低2位是开启仙缘的个数--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 148, 7, var_1_int )--分发数据
    end,

    --婚礼-成功进入婚礼，下发婚礼的各项数据
    --接收服务器
    [9] = function ( np )
        local var_1_int = np:readInt( ) --敬酒次数
        local var_2_int = np:readInt( ) --祝福次数
        local var_3_int = np:readInt( ) --扮鬼脸次数
        local var_4_int = np:readInt( ) --撒喜糖次数
        local var_5_int = np:readInt( ) --新娘id,用于判断能否撒喜糖和增加喜糖次数
        local var_6_int = np:readInt( ) --新郎id
        PacketDispatcher:dispather( 148, 9, var_1_int, var_2_int, var_3_int, var_4_int, var_5_int, var_6_int )--分发数据
    end,

    --婚礼互动，用于服务器广播
    --接收服务器
    [11] = function ( np )
        PacketDispatcher:dispather( 148, 11 )--分发数据
    end,

    --婚礼-应答婚礼列表请求，协议内容同3
    --接收服务器
    [13] = function ( np )
        PacketDispatcher:dispather( 148, 13 )--分发数据
    end,

    --婚礼-广播婚礼结束
    --接收服务器
    [15] = function ( np )
        local var_1_int = np:readInt( ) --婚礼id
        PacketDispatcher:dispather( 148, 15, var_1_int )--分发数据
    end,

    --戒指进阶-进阶成功
    --接收服务器
    [22] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --stage，进阶成功后的阶值
        PacketDispatcher:dispather( 148, 22, var_1_unsigned_char )--分发数据
    end,

    --戒指进阶-祝福值变化
    --接收服务器
    [23] = function ( np )
        local var_1_int = np:readInt( ) --value，变化后的祝福值
        local var_2_int = np:readInt( ) --高级进阶剩余次数
        PacketDispatcher:dispather( 148, 23, var_1_int, var_2_int )--分发数据
    end,

    --发送亲密值信息
    --接收服务器
    [24] = function ( np )
        local var_1_int = np:readInt( ) --value
        PacketDispatcher:dispather( 148, 24, var_1_int )--分发数据
    end,

    --戒指进阶-通知伴侣自己当前的戒指等级
    --接收服务器
    [25] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --ringStage，戒指等级
        PacketDispatcher:dispather( 148, 25, var_1_unsigned_char )--分发数据
    end,

    --戒指进阶-下发夫妻额外加成属性战力
    --接收服务器
    [26] = function ( np )
        local var_1_int = np:readInt( ) --战力值
        PacketDispatcher:dispather( 148, 26, var_1_int )--分发数据
    end,


}
