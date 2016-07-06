protocol_func_map_client[5] = {
    --获取技能列表
    --客户端发送
    [1] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 5, 1 ) 
        NetManager:send_packet( np )
    end,

    --使用技能
    --客户端发送
    [2] = function ( 
                param_1_unsigned_short,  -- 技能ID
                param_2_int64,  -- 目标的handle--c本参数存在特殊说明，请查阅协议编辑器
                param_3_unsigned_short,  -- 目标（或者鼠标的）x
                param_4_unsigned_short,  -- 目标（或者鼠标的）y
                param_5_unsigned_char -- 我的面向--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_short, lua_type = "number" }, { param_name = param_2_int64, lua_type = "number" }, { param_name = param_3_unsigned_short, lua_type = "number" }, { param_name = param_4_unsigned_short, lua_type = "number" }, { param_name = param_5_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 5, 2 ) 
        np:writeWord( param_1_unsigned_short )
        np:writeInt64( param_2_int64 )
        np:writeWord( param_3_unsigned_short )
        np:writeWord( param_4_unsigned_short )
        np:writeByte( param_5_unsigned_char )
        NetManager:send_packet( np )
    end,

    --升级技能
    --客户端发送
    [3] = function ( 
                param_1_unsigned_short,  -- 技能ID
                param_2_unsigned_char -- 使用武学全书的数量
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_short, lua_type = "number" }, { param_name = param_2_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 5, 3 ) 
        np:writeWord( param_1_unsigned_short )
        np:writeByte( param_2_unsigned_char )
        NetManager:send_packet( np )
    end,

    --同步CD
    --客户端发送
    [4] = function ( 
                param_1_unsigned_short -- 技能的ID
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_short, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 5, 4 ) 
        np:writeWord( param_1_unsigned_short )
        NetManager:send_packet( np )
    end,

    --设置默认技能
    --客户端发送
    [5] = function ( 
                param_1_unsigned_short -- 技能的ID
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_short, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 5, 5 ) 
        np:writeWord( param_1_unsigned_short )
        NetManager:send_packet( np )
    end,

    --使用肉搏攻击
    --客户端发送
    [6] = function ( 
                param_1_int64,  -- 目标的handle
                param_2_unsigned_char,  -- 动作的id
                param_3_unsigned_short -- 特效的id 
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int64, lua_type = "number" }, { param_name = param_2_unsigned_char, lua_type = "number" }, { param_name = param_3_unsigned_short, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 5, 6 ) 
        np:writeInt64( param_1_int64 )
        np:writeByte( param_2_unsigned_char )
        np:writeWord( param_3_unsigned_short )
        NetManager:send_packet( np )
    end,

    --开始吟唱技能
    --客户端发送
    [7] = function ( 
                param_1_unsigned_short,  -- 技能ID
                param_2_unsigned_int64,  -- 技能使用目标HANDLE
                param_3_short,  -- 技能施放位置X
                param_4_short,  -- 技能施放位置Y
                param_5_unsigned_char -- 我的面向--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_short, lua_type = "number" }, { param_name = param_2_unsigned_int64, lua_type = "number" }, { param_name = param_3_short, lua_type = "number" }, { param_name = param_4_short, lua_type = "number" }, { param_name = param_5_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 5, 7 ) 
        np:writeWord( param_1_unsigned_short )
        np:writeUint64( param_2_unsigned_int64 )
        np:writeShort( param_3_short )
        np:writeShort( param_4_short )
        np:writeByte( param_5_unsigned_char )
        NetManager:send_packet( np )
    end,

    --删除技能的秘籍效果
    --客户端发送
    [9] = function ( 
                param_1_unsigned_short -- 技能的ID
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_short, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 5, 9 ) 
        np:writeWord( param_1_unsigned_short )
        NetManager:send_packet( np )
    end,

    --玩家学习技能秘籍
    --客户端发送
    [11] = function ( 
                param_1_unsigned_short,  -- 技能的ID
                param_2_unsigned_short -- 秘籍的ID
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_short, lua_type = "number" }, { param_name = param_2_unsigned_short, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 5, 11 ) 
        np:writeWord( param_1_unsigned_short )
        np:writeWord( param_2_unsigned_short )
        NetManager:send_packet( np )
    end,

    --启用/停止一个技能(主要是江湖绝学)
    --客户端发送
    [10] = function ( 
                param_1_unsigned_short,  -- 技能的ID
                param_2_unsigned_char -- 启用标记--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_short, lua_type = "number" }, { param_name = param_2_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 5, 10 ) 
        np:writeWord( param_1_unsigned_short )
        np:writeByte( param_2_unsigned_char )
        NetManager:send_packet( np )
    end,

    --请求秘籍列表
    --客户端发送
    [15] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 5, 15 ) 
        NetManager:send_packet( np )
    end,

    --附带秘籍
    --客户端发送
    [16] = function ( 
                param_1_int64 -- guid--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int64, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 5, 16 ) 
        np:writeInt64( param_1_int64 )
        NetManager:send_packet( np )
    end,

    --卸载秘籍
    --客户端发送
    [17] = function ( 
                param_1_unsigned_int -- 技能id
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 5, 17 ) 
        np:writeUInt( param_1_unsigned_int )
        NetManager:send_packet( np )
    end,

    --秘籍升级
    --客户端发送
    [18] = function ( 
                param_1_int64,  -- 待升级秘籍guild
                param_2_unsigned_char,  -- 材料个数
                param_3_array -- 材料guid和数量--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int64, lua_type = "number" }, { param_name = param_2_unsigned_char, lua_type = "number" }, { param_name = param_3_array, lua_type = "table" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 5, 18 ) 
        np:writeInt64( param_1_int64 )
        np:writeByte( param_2_unsigned_char )
        for i = 1, param_2_unsigned_char do 
            -- protocol manual client 数组
            -- 材料guid和数量--c本参数存在特殊说明，请查阅协议编辑器
            local structObj = param_3_array[i]
            structObj:write_pack( np )
        end
        NetManager:send_packet( np )
    end,

    --秘籍合成
    --客户端发送
    [19] = function ( 
                param_1_unsigned_char,  -- 合成材料个数
                param_2_array -- 合成材料guid,第一个guid为主合成物
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" }, { param_name = param_2_array, lua_type = "table" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 5, 19 ) 
        np:writeByte( param_1_unsigned_char )
        for i = 1, param_1_unsigned_char do 
            -- protocol manual client 数组
            -- 合成材料guid,第一个guid为主合成物
            local structObj = param_2_array[i]
            structObj:write_pack( np )
        end
        NetManager:send_packet( np )
    end,

    --查看其它玩家秘籍信息
    --客户端发送
    [20] = function ( 
                param_1_int,  -- 玩家id
                param_2_string -- 玩家名字
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" }, { param_name = param_2_string, lua_type = "string" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 5, 20 ) 
        np:writeInt( param_1_int )
        np:writeString( param_2_string )
        NetManager:send_packet( np )
    end,

    --战力比拼-查看玩家技能战斗力信息
    --客户端发送
    [23] = function ( 
                param_1_int -- 玩家id
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 5, 23 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,


}



protocol_func_map_server[5] = {
    --学习技能的结果
    --接收服务器
    [2] = function ( np )
        local var_1_unsigned_short = np:readWord( ) --技能ID
        local var_2_unsigned_char = np:readByte( ) --技能新等级
        PacketDispatcher:dispather( 5, 2, var_1_unsigned_short, var_2_unsigned_char )--分发数据
    end,

    --玩家成功学习技能秘籍
    --接收服务器
    [3] = function ( np )
        local var_1_unsigned_short = np:readWord( ) --技能的ID
        local var_2_unsigned_short = np:readWord( ) --秘籍的物品的ID
        local var_3_unsigned_int = np:readUInt( ) --秘籍的过期时间,MiniTime格式
        PacketDispatcher:dispather( 5, 3, var_1_unsigned_short, var_2_unsigned_short, var_3_unsigned_int )--分发数据
    end,

    --技能的经验发生改变
    --接收服务器
    [4] = function ( np )
        local var_1_unsigned_short = np:readWord( ) --技能的ID
        local var_2_int = np:readInt( ) --技能的经验
        PacketDispatcher:dispather( 5, 4, var_1_unsigned_short, var_2_int )--分发数据
    end,

    --下发技能CD
    --接收服务器
    [5] = function ( np )
        local var_1_unsigned_short = np:readWord( ) --技能的ID
        local var_2_int = np:readInt( ) --剩余的cd时间,单位毫秒
        PacketDispatcher:dispather( 5, 5, var_1_unsigned_short, var_2_int )--分发数据
    end,

    --被其他玩家攻击掉血
    --接收服务器
    [6] = function ( np )
        local var_1_unsigned_int64 = np:readUint64( ) --攻击自己的玩家的handle
        local var_2_int64 = np:readInt64( ) --被攻击的实体的handle，可能是玩家自己，也可能是宠物
        PacketDispatcher:dispather( 5, 6, var_1_unsigned_int64, var_2_int64 )--分发数据
    end,

    --自己给目标造成了伤害
    --接收服务器
    [7] = function ( np )
        local var_1_unsigned_int64 = np:readUint64( ) --目标的handle
        local var_2_int = np:readInt( ) --伤害的数值
        PacketDispatcher:dispather( 5, 7, var_1_unsigned_int64, var_2_int )--分发数据
    end,

    --被攻击的目标吸收了伤害
    --接收服务器
    [8] = function ( np )
        local var_1_unsigned_int64 = np:readUint64( ) --目标的handle
        local var_2_int = np:readInt( ) --吸收的数值
        PacketDispatcher:dispather( 5, 8, var_1_unsigned_int64, var_2_int )--分发数据
    end,

    --删除技能的秘籍效果
    --接收服务器
    [10] = function ( np )
        local var_1_unsigned_short = np:readWord( ) --技能的ID
        PacketDispatcher:dispather( 5, 10, var_1_unsigned_short )--分发数据
    end,

    --服务器下发停用/启用技能
    --接收服务器
    [9] = function ( np )
        local var_1_unsigned_short = np:readWord( ) --技能的ID
        local var_2_unsigned_char = np:readByte( ) --启用标记(1表示启用，0表示停用)
        PacketDispatcher:dispather( 5, 9, var_1_unsigned_short, var_2_unsigned_char )--分发数据
    end,

    --遗忘一个技能
    --接收服务器
    [11] = function ( np )
        local var_1_unsigned_short = np:readWord( ) --技能的ID
        PacketDispatcher:dispather( 5, 11, var_1_unsigned_short )--分发数据
    end,

    --设置技能的cd时间
    --接收服务器
    [12] = function ( np )
        local var_1_unsigned_short = np:readWord( ) --技能的ID
        local var_2_unsigned_char = np:readByte( ) --技能的等级
        local var_3_int = np:readInt( ) --技能的cd时间，单位ms
        PacketDispatcher:dispather( 5, 12, var_1_unsigned_short, var_2_unsigned_char, var_3_int )--分发数据
    end,

    --设置技能的吟唱时间
    --接收服务器
    [13] = function ( np )
        local var_1_unsigned_short = np:readWord( ) --技能的ID
        local var_2_unsigned_char = np:readByte( ) --技能的等级
        local var_3_int = np:readInt( ) --技能的吟唱时间，单位毫秒
        PacketDispatcher:dispather( 5, 13, var_1_unsigned_short, var_2_unsigned_char, var_3_int )--分发数据
    end,

    --宠物使用技能
    --接收服务器
    [14] = function ( np )
        local var_1_int = np:readInt( ) --id，非技能id--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_int = np:readInt( ) --参数--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 5, 14, var_1_int, var_2_int )--分发数据
    end,

    --附带秘籍结果返回
    --接收服务器
    [16] = function ( np )
        local var_1_int64 = np:readInt64( ) --附带秘籍guid
        local var_2_unsigned_char = np:readByte( ) --返回结果--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_int = np:readInt( ) --战力，若附带失败则没有此项
        PacketDispatcher:dispather( 5, 16, var_1_int64, var_2_unsigned_char, var_3_int )--分发数据
    end,

    --卸载秘籍结果
    --接收服务器
    [17] = function ( np )
        local var_1_unsigned_short = np:readWord( ) --技能id
        local var_2_unsigned_char = np:readByte( ) --结果--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_int = np:readInt( ) --战力，卸载失败则无此项
        PacketDispatcher:dispather( 5, 17, var_1_unsigned_short, var_2_unsigned_char, var_3_int )--分发数据
    end,

    --秘籍升级结果
    --接收服务器
    [18] = function ( np )
        local var_1_int64 = np:readInt64( ) --秘籍guid
        local var_2_unsigned_char = np:readByte( ) --升级结果--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_int = np:readInt( ) --战力，升级失败，则无此项
        PacketDispatcher:dispather( 5, 18, var_1_int64, var_2_unsigned_char, var_3_int )--分发数据
    end,

    --秘籍合成结果
    --接收服务器
    [19] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --合成结果，合成失败则无后面数据--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_int64 = np:readInt64( ) --合成后的guid--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 5, 19, var_1_unsigned_char, var_2_int64 )--分发数据
    end,


}
