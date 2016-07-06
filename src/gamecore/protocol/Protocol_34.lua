protocol_func_map_client[34] = {
    --初始化-获取界面初始化信息
    --客户端发送
    [1] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 34, 1 ) 
        NetManager:send_packet( np )
    end,

    --宠物战斗-宠物出战或回收
    --客户端发送
    [2] = function ( 
                param_1_int,  -- 宠物的ID
                param_2_int -- 0回收，1出战
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" }, { param_name = param_2_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 34, 2 ) 
        np:writeInt( param_1_int )
        np:writeInt( param_2_int )
        NetManager:send_packet( np )
    end,

    --删除宠物
    --客户端发送
    [3] = function ( 
                param_1_int -- 宠物的ID
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 34, 3 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --改变宠物的名字
    --客户端发送
    [4] = function ( 
                param_1_int,  -- 宠物的ID
                param_2_string -- 宠物的名字
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" }, { param_name = param_2_string, lua_type = "string" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 34, 4 ) 
        np:writeInt( param_1_int )
        np:writeString( param_2_string )
        NetManager:send_packet( np )
    end,

    --宠物战斗-修改宠物的战斗类型
    --客户端发送
    [5] = function ( 
                param_1_int,  -- 宠物id
                param_2_int -- 战斗类型--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" }, { param_name = param_2_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 34, 5 ) 
        np:writeInt( param_1_int )
        np:writeInt( param_2_int )
        NetManager:send_packet( np )
    end,

    --扩展宠物栏
    --客户端发送
    [6] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 34, 6 ) 
        NetManager:send_packet( np )
    end,

    --宠物血量-延寿，玩耍，喂食操作
    --客户端发送
    [8] = function ( 
                param_1_int,  -- 宠物id
                param_2_int -- 1：延寿，2：玩耍，3：喂食
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" }, { param_name = param_2_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 34, 8 ) 
        np:writeInt( param_1_int )
        np:writeInt( param_2_int )
        NetManager:send_packet( np )
    end,

    --宠物血量-使用宠物存储血量，类似背包里的协议16
    --客户端发送
    [9] = function ( 
                param_1_int -- 宠物id
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 34, 9 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --提悟
    --客户端发送
    [10] = function ( 
                param_1_int,  -- 宠物id
                param_2_int,  -- 是否使用保护符，0：不需要，1：需要
                param_3_int -- 是否自动购买材料，0：不需要，1：需要--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" }, { param_name = param_2_int, lua_type = "number" }, { param_name = param_3_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 34, 10 ) 
        np:writeInt( param_1_int )
        np:writeInt( param_2_int )
        np:writeInt( param_3_int )
        NetManager:send_packet( np )
    end,

    --提成长
    --客户端发送
    [11] = function ( 
                param_1_int,  -- 宠物id
                param_2_int,  -- 是否使用保护符，0：不需要，1：需要
                param_3_int -- 是否自动购买，0：不需要，1：需要
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" }, { param_name = param_2_int, lua_type = "number" }, { param_name = param_3_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 34, 11 ) 
        np:writeInt( param_1_int )
        np:writeInt( param_2_int )
        np:writeInt( param_3_int )
        NetManager:send_packet( np )
    end,

    --转换攻击类型（法术或物理），结果会作为属性下发
    --客户端发送
    [12] = function ( 
                param_1_int -- 宠物id
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 34, 12 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --融合
    --客户端发送
    [13] = function ( 
                param_1_int,  -- 主宠id
                param_2_int -- 副宠id
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" }, { param_name = param_2_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 34, 13 ) 
        np:writeInt( param_1_int )
        np:writeInt( param_2_int )
        NetManager:send_packet( np )
    end,

    --学习技能
    --客户端发送
    [14] = function ( 
                param_1_int,  -- 宠物id
                param_2_int64 -- 物品序列号，技能书
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" }, { param_name = param_2_int64, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 34, 14 ) 
        np:writeInt( param_1_int )
        np:writeInt64( param_2_int64 )
        NetManager:send_packet( np )
    end,

    --遗忘技能 --御龙不使用
    --客户端发送
    [15] = function ( 
                param_1_int,  -- 宠物id
                param_2_int -- 技能id
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" }, { param_name = param_2_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 34, 15 ) 
        np:writeInt( param_1_int )
        np:writeInt( param_2_int )
        NetManager:send_packet( np )
    end,

    --技能刻印
    --客户端发送
    [17] = function ( 
                param_1_int,  -- 宠物id
                param_2_int -- 技能id
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" }, { param_name = param_2_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 34, 17 ) 
        np:writeInt( param_1_int )
        np:writeInt( param_2_int )
        NetManager:send_packet( np )
    end,

    --技能从仓库移出
    --客户端发送
    [19] = function ( 
                param_1_int64,  -- 技能序列号
                param_2_int -- 宠物id,如果id为0表示移到空白处
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int64, lua_type = "number" }, { param_name = param_2_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 34, 19 ) 
        np:writeInt64( param_1_int64 )
        np:writeInt( param_2_int )
        NetManager:send_packet( np )
    end,

    --宠物技能-请求仓库技能列表
    --客户端发送
    [20] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 34, 20 ) 
        NetManager:send_packet( np )
    end,

    --刷新唤魂玉或获取唤魂玉的数据
    --客户端发送
    [21] = function ( 
                param_1_int64,  -- 物品序列号
                param_2_int,  -- 类型，1：单次刷，2：批量刷（9次），3获取数据，显示用
                param_3_int -- 消耗货币类型，1：元宝，2：绑定元宝，只有刷新才发这个字段
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int64, lua_type = "number" }, { param_name = param_2_int, lua_type = "number" }, { param_name = param_3_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 34, 21 ) 
        np:writeInt64( param_1_int64 )
        np:writeInt( param_2_int )
        np:writeInt( param_3_int )
        NetManager:send_packet( np )
    end,

    --苏醒技能
    --客户端发送
    [23] = function ( 
                param_1_int64,  -- 物品序列号
                param_2_int -- 顺序号，0表示单次刷新的那个格子，1-9表示批量刷新的
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int64, lua_type = "number" }, { param_name = param_2_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 34, 23 ) 
        np:writeInt64( param_1_int64 )
        np:writeInt( param_2_int )
        NetManager:send_packet( np )
    end,

    --出战的宠物选择一个实体作为目标，用于技能攻击
    --客户端发送
    [24] = function ( 
                param_1_int64 -- 实体handle
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int64, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 34, 24 ) 
        np:writeInt64( param_1_int64 )
        NetManager:send_packet( np )
    end,

    --使用技能
    --客户端发送
    [25] = function ( 
                param_1_unsigned_short,  -- 技能ID
                param_2_int64,  -- 目标的handle--c本参数存在特殊说明，请查阅协议编辑器
                param_3_unsigned_short,  -- 目标（或者鼠标的）x
                param_4_unsigned_short,  -- 目标（或者鼠标的）y
                param_5_unsigned_char -- 我的面向--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_short, lua_type = "number" }, { param_name = param_2_int64, lua_type = "number" }, { param_name = param_3_unsigned_short, lua_type = "number" }, { param_name = param_4_unsigned_short, lua_type = "number" }, { param_name = param_5_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 34, 25 ) 
        np:writeWord( param_1_unsigned_short )
        np:writeInt64( param_2_int64 )
        np:writeWord( param_3_unsigned_short )
        np:writeWord( param_4_unsigned_short )
        np:writeByte( param_5_unsigned_char )
        NetManager:send_packet( np )
    end,

    --使用肉搏攻击，结果会以25协议返回
    --客户端发送
    [26] = function ( 
                param_1_int64,  -- 目标的handle
                param_2_unsigned_char,  -- 动作的id
                param_3_unsigned_short -- 特效的id 
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int64, lua_type = "number" }, { param_name = param_2_unsigned_char, lua_type = "number" }, { param_name = param_3_unsigned_short, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 34, 26 ) 
        np:writeInt64( param_1_int64 )
        np:writeByte( param_2_unsigned_char )
        np:writeWord( param_3_unsigned_short )
        NetManager:send_packet( np )
    end,

    --获取其他玩家的宠物信息
    --客户端发送
    [28] = function ( 
                param_1_int64,  -- 怪物的handle
                param_2_int,  -- 玩家ID
                param_3_int -- 宠物自增ID
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int64, lua_type = "number" }, { param_name = param_2_int, lua_type = "number" }, { param_name = param_3_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 34, 28 ) 
        np:writeInt64( param_1_int64 )
        np:writeInt( param_2_int )
        np:writeInt( param_3_int )
        NetManager:send_packet( np )
    end,

    --获取宠物激活历史记录
    --客户端发送
    [30] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 34, 30 ) 
        NetManager:send_packet( np )
    end,

    --化形-宠物化形
    --客户端发送
    [31] = function ( 
                param_1_int -- 化形的宠物模型id
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 34, 31 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --通过玩家ID获取玩家宠物信息
    --客户端发送
    [32] = function ( 
                param_1_int -- 玩家ID
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 34, 32 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --穿上装备
    --客户端发送
    [33] = function ( 
                param_1_unsigned_int64 -- 装备的GUID
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_int64, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 34, 33 ) 
        np:writeUint64( param_1_unsigned_int64 )
        NetManager:send_packet( np )
    end,

    --脱下装备
    --客户端发送
    [34] = function ( 
                param_1_unsigned_int64 -- 装备的GUID
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_int64, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 34, 34 ) 
        np:writeUint64( param_1_unsigned_int64 )
        NetManager:send_packet( np )
    end,

    --宠物培养-进行宠物进阶
    --客户端发送
    [36] = function ( 
                param_1_unsigned_char -- 是否花元宝自动购买道具，0:不自动，1:自动
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 34, 36 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --宠物技能-转动
    --客户端发送
    [37] = function ( 
                param_1_unsigned_char,  -- autoBuy，0:不自动购买，1:自动购买
                param_2_unsigned_char -- needLevel，想要的技能等级--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" }, { param_name = param_2_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 34, 37 ) 
        np:writeByte( param_1_unsigned_char )
        np:writeByte( param_2_unsigned_char )
        NetManager:send_packet( np )
    end,

    --宠物技能-获取技能
    --客户端发送
    [38] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 34, 38 ) 
        NetManager:send_packet( np )
    end,

    --宠物融合-进行融合
    --客户端发送
    [39] = function ( 
                param_1_unsigned_char,  -- operType: 0:预览融合，1:进行融合
                param_2_int,  -- petId，主宠的petId
                param_3_int -- mixPet，融合宠物的petId
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" }, { param_name = param_2_int, lua_type = "number" }, { param_name = param_3_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 34, 39 ) 
        np:writeByte( param_1_unsigned_char )
        np:writeInt( param_2_int )
        np:writeInt( param_3_int )
        NetManager:send_packet( np )
    end,

    --宠物技能-技能从宠物到技能仓库
    --客户端发送
    [40] = function ( 
                param_1_int,  -- petId，宠物
                param_2_int64 -- skillGuid
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" }, { param_name = param_2_int64, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 34, 40 ) 
        np:writeInt( param_1_int )
        np:writeInt64( param_2_int64 )
        NetManager:send_packet( np )
    end,

    --宠物技能-技能从技能仓库到宠物
    --客户端发送
    [41] = function ( 
                param_1_int,  -- petId，若petId为0表示删除此技能
                param_2_int64 -- skillGuid
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" }, { param_name = param_2_int64, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 34, 41 ) 
        np:writeInt( param_1_int )
        np:writeInt64( param_2_int64 )
        NetManager:send_packet( np )
    end,

    --宠物技能-整理技能仓库
    --客户端发送
    [42] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 34, 42 ) 
        NetManager:send_packet( np )
    end,

    --宠物技能-交换宠物技能和仓库技能
    --客户端发送
    [43] = function ( 
                param_1_int,  -- petId
                param_2_int64,  -- skillGuid，宠物身上的技能guid
                param_3_int64 -- storageGuid，技能仓库技能guid
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" }, { param_name = param_2_int64, lua_type = "number" }, { param_name = param_3_int64, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 34, 43 ) 
        np:writeInt( param_1_int )
        np:writeInt64( param_2_int64 )
        np:writeInt64( param_3_int64 )
        NetManager:send_packet( np )
    end,

    --宠物进阶-预览下阶属性
    --客户端发送
    [44] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 34, 44 ) 
        NetManager:send_packet( np )
    end,

    --宠物三阶礼包-使用宠物三阶礼包
    --客户端发送
    [45] = function ( 
                param_1_int64 -- guid，礼包guid
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int64, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 34, 45 ) 
        np:writeInt64( param_1_int64 )
        NetManager:send_packet( np )
    end,


}



protocol_func_map_server[34] = {
    --宠物战斗-宠物出战或回收结果
    --接收服务器
    [2] = function ( np )
        local var_1_int = np:readInt( ) --宠物的ID
        local var_2_int = np:readInt( ) --0回收，1出战
        local var_3_int = np:readInt( ) --结果--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 34, 2, var_1_int, var_2_int, var_3_int )--分发数据
    end,

    --改变宠物的名字
    --接收服务器
    [4] = function ( np )
        local var_1_int = np:readInt( ) --宠物的ID
        local var_2_int = np:readInt( ) --0成功，1失败，如果失败，后面的名字不用读
        local var_3_string = np:readString( ) --宠物的新名字
        PacketDispatcher:dispather( 34, 4, var_1_int, var_2_int, var_3_string )--分发数据
    end,

    --删除宠物
    --接收服务器
    [3] = function ( np )
        local var_1_int = np:readInt( ) --宠物id
        PacketDispatcher:dispather( 34, 3, var_1_int )--分发数据
    end,

    --扩展宠物栏结果
    --接收服务器
    [6] = function ( np )
        local var_1_int = np:readInt( ) --0成功，1失败
        local var_2_int = np:readInt( ) --新的大小
        PacketDispatcher:dispather( 34, 6, var_1_int, var_2_int )--分发数据
    end,

    --宠物血量-应答使用宠物存储血量结果
    --接收服务器
    [9] = function ( np )
        local var_1_int = np:readInt( ) --宠物id
        local var_2_int = np:readInt( ) --0 成功，1失败--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 34, 9, var_1_int, var_2_int )--分发数据
    end,

    --融合是否成功
    --接收服务器
    [13] = function ( np )
        local var_1_int = np:readInt( ) --0成功，1失败
        PacketDispatcher:dispather( 34, 13, var_1_int )--分发数据
    end,

    --学习技能的结果,如果已经学了这个技能，这个就表示升级
    --接收服务器
    [14] = function ( np )
        local var_1_int = np:readInt( ) --宠物id
        local var_2_int = np:readInt( ) --技能id
        local var_3_int = np:readInt( ) --技能等级
        PacketDispatcher:dispather( 34, 14, var_1_int, var_2_int, var_3_int )--分发数据
    end,

    --遗忘技能 --御龙不使用
    --接收服务器
    [15] = function ( np )
        local var_1_int = np:readInt( ) --宠物id
        local var_2_int = np:readInt( ) --技能id
        PacketDispatcher:dispather( 34, 15, var_1_int, var_2_int )--分发数据
    end,

    --技能刻印
    --接收服务器
    [17] = function ( np )
        local var_1_int = np:readInt( ) --宠物id
        local var_2_int = np:readInt( ) --技能id
        PacketDispatcher:dispather( 34, 17, var_1_int, var_2_int )--分发数据
    end,

    --技能移到仓库的结果
    --接收服务器
    [18] = function ( np )
        local var_1_int = np:readInt( ) --宠物id
        local var_2_int = np:readInt( ) --技能id
        local var_3_int64 = np:readInt64( ) --移到仓库后的序列号
        PacketDispatcher:dispather( 34, 18, var_1_int, var_2_int, var_3_int64 )--分发数据
    end,

    --技能从仓库移出的结果
    --接收服务器
    [19] = function ( np )
        local var_1_int64 = np:readInt64( ) --序列号
        local var_2_int = np:readInt( ) --移到的宠物id，如果宠物id为0为删除技能
        PacketDispatcher:dispather( 34, 19, var_1_int64, var_2_int )--分发数据
    end,

    --苏醒技能结果
    --接收服务器
    [23] = function ( np )
        local var_1_int64 = np:readInt64( ) --物品序列号
        local var_2_int = np:readInt( ) --0成功，1失败
        PacketDispatcher:dispather( 34, 23, var_1_int64, var_2_int )--分发数据
    end,

    --宠物战斗-宠物死亡
    --接收服务器
    [16] = function ( np )
        local var_1_int = np:readInt( ) --宠物id
        PacketDispatcher:dispather( 34, 16, var_1_int )--分发数据
    end,

    --使用技能的结果
    --接收服务器
    [25] = function ( np )
        local var_1_int = np:readInt( ) --技能id，0表示肉搏
        local var_2_int = np:readInt( ) --0：成功，1失败
        local var_3_int = np:readInt( ) --cd时间，通常失败都是因为cd，所以这里直接下发cd时间
        PacketDispatcher:dispather( 34, 25, var_1_int, var_2_int, var_3_int )--分发数据
    end,

    --宠物强行回收，并有5秒的cd
    --接收服务器
    [27] = function ( np )
        local var_1_int = np:readInt( ) --宠物id
        PacketDispatcher:dispather( 34, 27, var_1_int )--分发数据
    end,

    --发送当前宠物ID
    --接收服务器
    [29] = function ( np )
        local var_1_int = np:readInt( ) --宠物自增ID
        PacketDispatcher:dispather( 34, 29, var_1_int )--分发数据
    end,

    --化形-化形结果 
    --接收服务器
    [31] = function ( np )
        local var_1_int = np:readInt( ) --化形后的模型id
        PacketDispatcher:dispather( 34, 31, var_1_int )--分发数据
    end,

    --穿上装备
    --接收服务器
    [33] = function ( np )
        local var_1_int = np:readInt( ) --宠物id
        local var_2_unsigned_int64 = np:readUint64( ) --装备的guid
        PacketDispatcher:dispather( 34, 33, var_1_int, var_2_unsigned_int64 )--分发数据
    end,

    --脱下装备
    --接收服务器
    [34] = function ( np )
        local var_1_unsigned_int64 = np:readUint64( ) --装备的guid
        PacketDispatcher:dispather( 34, 34, var_1_unsigned_int64 )--分发数据
    end,

    --宠物技能引导-下发限时技能倒计时
    --接收服务器
    [35] = function ( np )
        local var_1_int = np:readInt( ) --skillId, 限时技能Id
        local var_2_unsigned_int = np:readUInt( ) --leftTime, 剩余时间，单位为秒
        PacketDispatcher:dispather( 34, 35, var_1_int, var_2_unsigned_int )--分发数据
    end,

    --宠物培养-应答宠物进阶
    --接收服务器
    [36] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --result，进阶结果--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 34, 36, var_1_unsigned_char )--分发数据
    end,

    --宠物技能-应答转动
    --接收服务器
    [37] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --result，结果--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_short = np:readShort( ) --skillId，技能id，若为0表示未获得到。
        local var_3_unsigned_char = np:readByte( ) --skillLevel，技能等级，为0表示未获得技能
        local var_4_unsigned_char = np:readByte( ) --sameNum，相同的格子的数量--s本参数存在特殊说明，请查阅协议编辑器
        local var_5_int = np:readInt( ) --luckyValue，幸运值
        local var_6_int = np:readInt( ) --countDown，幸运值清空倒计时，0表示没有倒计时
        PacketDispatcher:dispather( 34, 37, var_1_unsigned_char, var_2_short, var_3_unsigned_char, var_4_unsigned_char, var_5_int, var_6_int )--分发数据
    end,

    --宠物技能-发送幸运值和倒计时信息
    --接收服务器
    [38] = function ( np )
        local var_1_int = np:readInt( ) --luckyValue，幸运值
        local var_2_int = np:readInt( ) --countDown，秒数为0时，表示没有倒计时
        PacketDispatcher:dispather( 34, 38, var_1_int, var_2_int )--分发数据
    end,

    --宠物融合-添加一个融合宠物
    --接收服务器
    [40] = function ( np )
        local var_1_int = np:readInt( ) --petId
        local var_2_int = np:readInt( ) --petType
        local var_3_int = np:readInt( ) --petLevel
        local var_4_unsigned_char = np:readByte( ) --skillCount，技能数量
        local var_5_int = np:readInt( ) --skillId
        local var_6_unsigned_char = np:readByte( ) --skillLevel
        PacketDispatcher:dispather( 34, 40, var_1_int, var_2_int, var_3_int, var_4_unsigned_char, var_5_int, var_6_unsigned_char )--分发数据
    end,

    --宠物融合-删除一个融合宠物
    --接收服务器
    [41] = function ( np )
        local var_1_int = np:readInt( ) --mixId，融合宠物petId
        PacketDispatcher:dispather( 34, 41, var_1_int )--分发数据
    end,

    --宠物技能-删除技能
    --接收服务器
    [43] = function ( np )
        local var_1_int = np:readInt( ) --petId，petId为0表示技能仓库
        local var_2_int64 = np:readInt64( ) --skillGuid，唯一标识技能
        PacketDispatcher:dispather( 34, 43, var_1_int, var_2_int64 )--分发数据
    end,

    --宠物技能-应答交换技能
    --接收服务器
    [44] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --result，0:成功，1:失败，若失败后面的字段则不发
        local var_2_int64 = np:readInt64( ) --成功交换后，宠物获取的skillGuid-原仓库技能
        local var_3_int64 = np:readInt64( ) --成功交换后，仓库添加的skillGuid-原宠物技能
        PacketDispatcher:dispather( 34, 44, var_1_unsigned_char, var_2_int64, var_3_int64 )--分发数据
    end,

    --宠物技能-应答获取技能
    --接收服务器
    [46] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --result: 1:获取成功，0:获取失败。
        PacketDispatcher:dispather( 34, 46, var_1_unsigned_char )--分发数据
    end,

    --丹药-已使用的丹药数量
    --接收服务器
    [48] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --ldType，1:仙丹，2:灵丹
        local var_2_int = np:readInt( ) --num，已使用的灵丹数量
        PacketDispatcher:dispather( 34, 48, var_1_unsigned_char, var_2_int )--分发数据
    end,

    --宠物进阶-返回进阶失败后增加的祝福值
    --接收服务器
    [49] = function ( np )
        local var_1_int = np:readInt( ) --addValue，普通进阶增加的祝福值
        local var_2_int = np:readInt( ) --vipAddValue，VIP额外增加的祝福值
        local var_3_int = np:readInt( ) --buffAddValue,buff额外增加的祝福值
        PacketDispatcher:dispather( 34, 49, var_1_int, var_2_int, var_3_int )--分发数据
    end,

    --附身-已使用的附身丹数量
    --接收服务器
    [50] = function ( np )
        local var_1_int = np:readInt( ) --attachNum，附身丹数量
        PacketDispatcher:dispather( 34, 50, var_1_int )--分发数据
    end,

    --预体验-时间控制协议
    --接收服务器
    [51] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --type，体验类型
        local var_2_int = np:readInt( ) --leftTime，剩余时间--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 34, 51, var_1_unsigned_char, var_2_int )--分发数据
    end,

    --化形-特殊形象改变
    --接收服务器
    [53] = function ( np )
        local var_1_int = np:readInt( ) --modelId，模型id
        local var_2_unsigned_char = np:readByte( ) --state，0:未激活，1:激活，2:已过期
        local var_3_int = np:readInt( ) --leftTime，剩余时间
        PacketDispatcher:dispather( 34, 53, var_1_int, var_2_unsigned_char, var_3_int )--分发数据
    end,


}
