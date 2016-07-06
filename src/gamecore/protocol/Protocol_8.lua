protocol_func_map_client[8] = {
    --删除一个物品
    --客户端发送
    [1] = function ( 
                param_1_int64 -- 物品的GUID
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int64, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 8, 1 ) 
        np:writeInt64( param_1_int64 )
        NetManager:send_packet( np )
    end,

    --获取玩家的背包物品列表
    --客户端发送
    [2] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 8, 2 ) 
        NetManager:send_packet( np )
    end,

    --获取扩展背包格子的费用列表
    --客户端发送
    [3] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 8, 3 ) 
        NetManager:send_packet( np )
    end,

    --扩展背包
    --客户端发送
    [4] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 8, 4 ) 
        NetManager:send_packet( np )
    end,

    --拆分背包物品
    --客户端发送
    [5] = function ( 
                param_1_int64,  -- 物品的GUID
                param_2_unsigned_short -- 拆分出来的物品的数量
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int64, lua_type = "number" }, { param_name = param_2_unsigned_short, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 8, 5 ) 
        np:writeInt64( param_1_int64 )
        np:writeWord( param_2_unsigned_short )
        NetManager:send_packet( np )
    end,

    --合并背包的格子
    --客户端发送
    [6] = function ( 
                param_1_int64,  -- 源物品的GUID
                param_2_int64 -- 目标物品的GUID
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int64, lua_type = "number" }, { param_name = param_2_int64, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 8, 6 ) 
        np:writeInt64( param_1_int64 )
        np:writeInt64( param_2_int64 )
        NetManager:send_packet( np )
    end,

    --使用物品
    --客户端发送
    [7] = function ( 
                param_1_int64,  -- 物品的GUID
                param_2_int -- 扩展参数--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int64, lua_type = "number" }, { param_name = param_2_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 8, 7 ) 
        np:writeInt64( param_1_int64 )
        np:writeInt( param_2_int )
        NetManager:send_packet( np )
    end,

    --处理一件装备(强化，镶嵌等通用)
    --客户端发送
    [8] = function ( 
                param_1_unsigned_char,  -- 物品的GUID个数
                param_2_array,  -- 物品GUID列表--c本参数存在特殊说明，请查阅协议编辑器
                param_3_unsigned_char,  -- 处理的类型--c本参数存在特殊说明，请查阅协议编辑器
                param_4_unsigned_char,  -- 参数的个数--c本参数存在特殊说明，请查阅协议编辑器
                param_5_array -- 参数的列表--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" }, { param_name = param_2_array, lua_type = "table" }, { param_name = param_3_unsigned_char, lua_type = "number" }, { param_name = param_4_unsigned_char, lua_type = "number" }, { param_name = param_5_array, lua_type = "table" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 8, 8 ) 
        np:writeByte( param_1_unsigned_char )
        for i = 1, param_1_unsigned_char do 
            -- protocol manual client 数组
            -- 物品GUID列表--c本参数存在特殊说明，请查阅协议编辑器
            local structObj = param_2_array[i]
            structObj:write_pack( np )
        end
        np:writeByte( param_3_unsigned_char )
        np:writeByte( param_4_unsigned_char )
        for i = 1, param_4_unsigned_char do 
            -- protocol manual client 数组
            -- 参数的列表--c本参数存在特殊说明，请查阅协议编辑器
            local structObj = param_5_array[i]
            structObj:write_pack( np )
        end
        NetManager:send_packet( np )
    end,

    --获取处理一件装备需要的消耗
    --客户端发送
    [9] = function ( 
                param_1_int64,  -- 物品的GUID
                param_2_unsigned_char,  -- 处理的类型--c本参数存在特殊说明，请查阅协议编辑器
                param_3_unsigned_char,  -- 参数个数
                param_4_array -- 参数列表--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int64, lua_type = "number" }, { param_name = param_2_unsigned_char, lua_type = "number" }, { param_name = param_3_unsigned_char, lua_type = "number" }, { param_name = param_4_array, lua_type = "table" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 8, 9 ) 
        np:writeInt64( param_1_int64 )
        np:writeByte( param_2_unsigned_char )
        np:writeByte( param_3_unsigned_char )
        for i = 1, param_3_unsigned_char do 
            -- protocol manual client 数组
            -- 参数列表--c本参数存在特殊说明，请查阅协议编辑器
            local structObj = param_4_array[i]
            structObj:write_pack( np )
        end
        NetManager:send_packet( np )
    end,

    --获取物品处理的一些配置
    --客户端发送
    [10] = function ( 
                param_1_unsigned_char -- 物品配置的ID--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 8, 10 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --灌注源泉
    --客户端发送
    [11] = function ( 
                param_1_unsigned_int64,  -- 灌注源泉药品的guid
                param_2_unsigned_int64 -- 源泉装备的guid
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_int64, lua_type = "number" }, { param_name = param_2_unsigned_int64, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 8, 11 ) 
        np:writeUint64( param_1_unsigned_int64 )
        np:writeUint64( param_2_unsigned_int64 )
        NetManager:send_packet( np )
    end,

    --整理背包，如果成功，服务器会重新下发背包物品
    --客户端发送
    [12] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 8, 12 ) 
        NetManager:send_packet( np )
    end,

    --领取某个活动背包的物品
    --客户端发送
    [13] = function ( 
                param_1_int64,  -- 物品的序列号，即消息号11里面的id字段
                param_2_unsigned_char -- 绑定类型，1：账户绑定，2角色绑定
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int64, lua_type = "number" }, { param_name = param_2_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 8, 13 ) 
        np:writeInt64( param_1_int64 )
        np:writeByte( param_2_unsigned_char )
        NetManager:send_packet( np )
    end,

    --使用气血储量
    --客户端发送
    [16] = function ( 
                param_1_int -- 类型,1:生命,2:法力
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 8, 16 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --通过在线时间累计打开背包格子
    --客户端发送
    [23] = function ( 
                param_1_int,  -- 打开背包的格子数量
                param_2_int -- 第几个背包格子
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" }, { param_name = param_2_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 8, 23 ) 
        np:writeInt( param_1_int )
        np:writeInt( param_2_int )
        NetManager:send_packet( np )
    end,

    --请求通过元宝打开背包格子的信息
    --客户端发送
    [24] = function ( 
                param_1_int,  -- 打开背包格子的数量
                param_2_int,  -- 打开背包格子中的第一个格子的位置--c本参数存在特殊说明，请查阅协议编辑器
                param_3_int -- 第一个格子开启的剩余时间
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" }, { param_name = param_2_int, lua_type = "number" }, { param_name = param_3_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 8, 24 ) 
        np:writeInt( param_1_int )
        np:writeInt( param_2_int )
        np:writeInt( param_3_int )
        NetManager:send_packet( np )
    end,

    --通过元宝打开背包格子
    --客户端发送
    [25] = function ( 
                param_1_int,  -- 打开背包格子的数量
                param_2_int,  -- 打开背包格子中的第一个格子的位置--c本参数存在特殊说明，请查阅协议编辑器
                param_3_int -- 第一个格子开启的剩余时间
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" }, { param_name = param_2_int, lua_type = "number" }, { param_name = param_3_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 8, 25 ) 
        np:writeInt( param_1_int )
        np:writeInt( param_2_int )
        np:writeInt( param_3_int )
        NetManager:send_packet( np )
    end,

    --熔炼
    --客户端发送
    [26] = function ( 
                param_1_unsigned_char,  -- 类型，1为分件熔炼，2为一键熔炼
                param_2_unsigned_char,  -- 熔炼装备数
                param_3_array -- 熔炼装备guid数组，每一个为int64类型
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" }, { param_name = param_2_unsigned_char, lua_type = "number" }, { param_name = param_3_array, lua_type = "table" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 8, 26 ) 
        np:writeByte( param_1_unsigned_char )
        np:writeByte( param_2_unsigned_char )
        for i = 1, param_2_unsigned_char do 
            -- protocol manual client 数组
            -- 熔炼装备guid数组，每一个为int64类型
            local structObj = param_3_array[i]
            structObj:write_pack( np )
        end
        NetManager:send_packet( np )
    end,

    --批量使用物品
    --客户端发送
    [19] = function ( 
                param_1_int64,  -- 物品的GUID
                param_2_int -- 使用个数
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int64, lua_type = "number" }, { param_name = param_2_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 8, 19 ) 
        np:writeInt64( param_1_int64 )
        np:writeInt( param_2_int )
        NetManager:send_packet( np )
    end,

    --特殊物品：客户端使用神秘大礼
    --客户端发送
    [28] = function ( 
                param_1_int64,  -- 物品GUID
                param_2_unsigned_char -- 是否使用黄金手，0不使用 1使用
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int64, lua_type = "number" }, { param_name = param_2_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 8, 28 ) 
        np:writeInt64( param_1_int64 )
        np:writeByte( param_2_unsigned_char )
        NetManager:send_packet( np )
    end,

    --各个进阶类系统的部位（强化、镶嵌等通用）
    --客户端发送
    [29] = function ( 
                param_1_unsigned_char,  -- 系统id--c本参数存在特殊说明，请查阅协议编辑器
                param_2_unsigned_char,  -- 部位序号1~4--c本参数存在特殊说明，请查阅协议编辑器
                param_3_unsigned_char,  -- 物品GUID个数
                param_4_array,  -- 物品的GUID列表--c本参数存在特殊说明，请查阅协议编辑器
                param_5_unsigned_char,  -- 处理类型--c本参数存在特殊说明，请查阅协议编辑器
                param_6_unsigned_char,  -- 参数个数
                param_7_array -- 参数列表--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" }, { param_name = param_2_unsigned_char, lua_type = "number" }, { param_name = param_3_unsigned_char, lua_type = "number" }, { param_name = param_4_array, lua_type = "table" }, { param_name = param_5_unsigned_char, lua_type = "number" }, { param_name = param_6_unsigned_char, lua_type = "number" }, { param_name = param_7_array, lua_type = "table" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 8, 29 ) 
        np:writeByte( param_1_unsigned_char )
        np:writeByte( param_2_unsigned_char )
        np:writeByte( param_3_unsigned_char )
        for i = 1, param_3_unsigned_char do 
            -- protocol manual client 数组
            -- 物品的GUID列表--c本参数存在特殊说明，请查阅协议编辑器
            local structObj = param_4_array[i]
            structObj:write_pack( np )
        end
        np:writeByte( param_5_unsigned_char )
        np:writeByte( param_6_unsigned_char )
        for i = 1, param_6_unsigned_char do 
            -- protocol manual client 数组
            -- 参数列表--c本参数存在特殊说明，请查阅协议编辑器
            local structObj = param_7_array[i]
            structObj:write_pack( np )
        end
        NetManager:send_packet( np )
    end,

    --部位宝石一键合成
    --客户端发送
    [30] = function ( 
                param_1_unsigned_char,  -- 系统id--c本参数存在特殊说明，请查阅协议编辑器
                param_2_unsigned_char,  -- 部位序号1~4--c本参数存在特殊说明，请查阅协议编辑器
                param_3_unsigned_char,  -- 欲合成的宝石级别--c本参数存在特殊说明，请查阅协议编辑器
                param_4_unsigned_char -- 宝石类型--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" }, { param_name = param_2_unsigned_char, lua_type = "number" }, { param_name = param_3_unsigned_char, lua_type = "number" }, { param_name = param_4_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 8, 30 ) 
        np:writeByte( param_1_unsigned_char )
        np:writeByte( param_2_unsigned_char )
        np:writeByte( param_3_unsigned_char )
        np:writeByte( param_4_unsigned_char )
        NetManager:send_packet( np )
    end,


}



protocol_func_map_server[8] = {
    --删除一个物品
    --接收服务器
    [1] = function ( np )
        local var_1_int64 = np:readInt64( ) --物品的GUID--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 8, 1, var_1_int64 )--分发数据
    end,

    --物品的数量发生改变
    --接收服务器
    [3] = function ( np )
        local var_1_int64 = np:readInt64( ) --物品的GUID
        local var_2_unsigned_short = np:readWord( ) --物品的新数量
        PacketDispatcher:dispather( 8, 3, var_1_int64, var_2_unsigned_short )--分发数据
    end,

    --发送背包扩展需要的费用
    --接收服务器
    [5] = function ( np )
        local var_1_int = np:readInt( ) --需要的元宝数量
        local var_2_unsigned_char = np:readByte( ) --扩展的背包的格子数量
        PacketDispatcher:dispather( 8, 5, var_1_int, var_2_unsigned_char )--分发数据
    end,

    --通知客户端装备处理的消耗(比如强化)
    --接收服务器
    [6] = function ( np )
        local var_1_int64 = np:readInt64( ) --物品的GUID
        local var_2_unsigned_char = np:readByte( ) --消耗物品的数量
        local var_3_unsigned_char = np:readByte( ) --金钱类型
        local var_4_int = np:readInt( ) --金钱数量--s本参数存在特殊说明，请查阅协议编辑器
        local var_5_unsigned_short = np:readWord( ) --消耗物品的ID(强化石的ID)
        local var_6_unsigned_char = np:readByte( ) --物品的处理类型
        PacketDispatcher:dispather( 8, 6, var_1_int64, var_2_unsigned_char, var_3_unsigned_char, var_4_int, var_5_unsigned_short, var_6_unsigned_char )--分发数据
    end,

    --装备处理的结果
    --接收服务器
    [8] = function ( np )
        local var_1_int64 = np:readInt64( ) --物品的GUID
        local var_2_unsigned_char = np:readByte( ) --处理的类型--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_unsigned_char = np:readByte( ) --处理的结果--s本参数存在特殊说明，请查阅协议编辑器
        local var_4_string = np:readString( ) --处理结果提示消息
        PacketDispatcher:dispather( 8, 8, var_1_int64, var_2_unsigned_char, var_3_unsigned_char, var_4_string )--分发数据
    end,

    --使用物品的结果
    --接收服务器
    [10] = function ( np )
        local var_1_unsigned_short = np:readWord( ) --物品的ID
        local var_2_unsigned_char = np:readByte( ) --使用物品的结果--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 8, 10, var_1_unsigned_short, var_2_unsigned_char )--分发数据
    end,

    --是否领取物品成功
    --接收服务器
    [12] = function ( np )
        local var_1_int64 = np:readInt64( ) --序列号
        local var_2_unsigned_char = np:readByte( ) --是否成功，0：不成功，1成功--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_unsigned_char = np:readByte( ) --绑定类型，1：账户绑定，2角色绑定
        PacketDispatcher:dispather( 8, 12, var_1_int64, var_2_unsigned_char, var_3_unsigned_char )--分发数据
    end,

    --背包获得了一件新的装备(包括源泉)
    --接收服务器
    [13] = function ( np )
        local var_1_int64 = np:readInt64( ) --物品的guid
        PacketDispatcher:dispather( 8, 13, var_1_int64 )--分发数据
    end,

    --使用气血储量的结果
    --接收服务器
    [16] = function ( np )
        local var_1_int = np:readInt( ) --0成功，1失败
        local var_2_int = np:readInt( ) --类型,1:生命,2:法力
        PacketDispatcher:dispather( 8, 16, var_1_int, var_2_int )--分发数据
    end,

    --凝元升星次数
    --接收服务器
    [21] = function ( np )
        local var_1_int = np:readInt( ) --凝元升星次数
        PacketDispatcher:dispather( 8, 21, var_1_int )--分发数据
    end,

    --下发背包自动开启
    --接收服务器
    [22] = function ( np )
        local var_1_int = np:readInt( ) --开启背包格子需要的在线总时间
        local var_2_int = np:readInt( ) --开启背包格子的剩余时间
        PacketDispatcher:dispather( 8, 22, var_1_int, var_2_int )--分发数据
    end,

    --下发通过元宝打开背包格子的信息
    --接收服务器
    [24] = function ( np )
        local var_1_int = np:readInt( ) --依靠在线时间累计打开背包格子的在线时间
        local var_2_int = np:readInt( ) --打开背包格子消耗的元宝数量
        local var_3_int = np:readInt( ) --开启背包格子数量
        local var_4_int = np:readInt( ) --获得的血量提升
        local var_5_int = np:readInt( ) --获得的法攻提升
        local var_6_int = np:readInt( ) --获得的物攻提升
        PacketDispatcher:dispather( 8, 24, var_1_int, var_2_int, var_3_int, var_4_int, var_5_int, var_6_int )--分发数据
    end,

    --返回通过元宝打开背包格子的结果
    --接收服务器
    [25] = function ( np )
        local var_1_int = np:readInt( ) --开启格子的数量
        local var_2_int = np:readInt( ) --开启格子的位置
        PacketDispatcher:dispather( 8, 25, var_1_int, var_2_int )--分发数据
    end,

    --下发通过在线时间累积打开背包格子的结果
    --接收服务器
    [23] = function ( np )
        local var_1_int = np:readInt( ) --开启格子的数量
        local var_2_int = np:readInt( ) --开启格子的位置
        PacketDispatcher:dispather( 8, 23, var_1_int, var_2_int )--分发数据
    end,

    --下发玩家的熔炼值
    --接收服务器
    [26] = function ( np )
        local var_1_unsigned_int = np:readUInt( ) --熔炼值
        PacketDispatcher:dispather( 8, 26, var_1_unsigned_int )--分发数据
    end,

    --返回熔炼结果
    --接收服务器
    [27] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --熔炼结果--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 8, 27, var_1_unsigned_char )--分发数据
    end,

    --通知客户端物品到期
    --接收服务器
    [14] = function ( np )
        local var_1_int64 = np:readInt64( ) --物品的guid
        local var_2_unsigned_char = np:readByte( ) --所在位置，0表示背包中，1表示身上装备，2表示仓库中（暂时默认是0）
        PacketDispatcher:dispather( 8, 14, var_1_int64, var_2_unsigned_char )--分发数据
    end,

    --特殊物品：使用神秘大礼结果
    --接收服务器
    [28] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --获得第几个序号的物品，0代表失败，大于0为正确的序号
        PacketDispatcher:dispather( 8, 28, var_1_unsigned_char )--分发数据
    end,

    --下发套装强化和镶嵌等级
    --接收服务器
    [32] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --系统id(1~9)
        local var_2_unsigned_short = np:readWord( ) --部位强化套装等级--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_unsigned_short = np:readWord( ) --部位镶嵌套装等级
        PacketDispatcher:dispather( 8, 32, var_1_unsigned_char, var_2_unsigned_short, var_3_unsigned_short )--分发数据
    end,


}
