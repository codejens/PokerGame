    if ( protocol_func_map_server[0] == nil ) then
        protocol_func_map_server[0] = {}
    end



    --非玩家实体的出现
    --接收服务器
    protocol_func_map_server[0][2] = function ( np )
        -- local var_1_string = np:readString( ) --实体的名字
        -- local var_2_int = np:readInt( ) --实体id，通常怪物才有
        -- local var_3_int64 = np:readInt64( ) --实体的句柄
        -- local var_4_int = np:readInt( ) --实体的类型
        -- local var_5_int = np:readInt( ) --实体的坐标x
        -- local var_6_int = np:readInt( ) --实体的坐标y
        -- local var_7_int = np:readInt( ) --实体的modelID
        -- local var_8_unsigned_char = np:readByte( ) --dir
        -- local var_9_unsigned_char = np:readByte( ) --是否跑动中--s本参数存在特殊说明，请查阅协议编辑器
        -- local var_10_int = np:readInt( ) --移动的目的点x坐标
        -- local var_11_int = np:readInt( ) --移动的目的点y坐标
        -- local var_12_unsigned_char = np:readByte( ) --等级(以下只有怪物,NPC才有)
        -- local var_13_unsigned_int = np:readUInt( ) --HP
        -- local var_14_unsigned_int = np:readUInt( ) --MP
        -- local var_15_unsigned_int = np:readUInt( ) --MAX_HP
        -- local var_16_unsigned_int = np:readUInt( ) --MAX_MP
        -- local var_17_unsigned_short = np:readWord( ) --移动速度(1格多少毫秒)
        -- local var_18_unsigned_short = np:readWord( ) --攻击速度
        -- local var_19_unsigned_int = np:readUInt( ) --生物状态
        -- local var_20_unsigned_int = np:readUInt( ) --怪物名称颜色（ARGB格式）
        -- local var_21_unsigned_char = np:readByte( ) --怪物攻击类型和怪物头衔(以下的数据npc没有)--s本参数存在特殊说明，请查阅协议编辑器
        -- local var_22_int = np:readInt( ) --npc功能id
        -- local var_23_int = np:readInt( ) --宠物的称号，低2位是等阶称号，高2位是兽阶称号，如果不是宠物，则为0
        -- local var_24_int = np:readInt( ) --低2位是阵营id，高2位宠物排行榜称号ID
        -- local var_25_int = np:readInt( ) --宠物称号ID
        -- local var_26_unsigned_char = np:readByte( ) --是否为新创建 1是 0不是
        -- local var_27_unsigned_char = np:readByte( ) --出现形式--s本参数存在特殊说明，请查阅协议编辑器
        -- local var_28_short = np:readShort( ) --保留字段
        -- local var_29_unsigned_int64 = np:readUint64( ) --主人的handle(只有宠物有，其他没有)
        -- local var_30_unsigned_char = np:readByte( ) --buff的数量
        -- -- buff的数据--s本参数存在特殊说明，请查阅协议编辑器
        -- local var_31_array = {}
        -- for i = 1, var_30_unsigned_char do 
        --     -- protocol manual server 数组
        --     local structObj = BuffStruct( np )
        --     table.insert( var_31_array, structObj )
        -- end
        -- local var_32_unsigned_char = np:readByte( ) --特效的数量
        -- -- 特效的数据--s本参数存在特殊说明，请查阅协议编辑器
        -- local var_33_array = {}
        -- for i = 1, var_32_unsigned_char do 
        --     -- protocol manual server 数组
        --     local structObj = {}
        --     structObj.effect_type   = pack:readByte()
        --     structObj.effect_id     = pack:readWord()
        --     structObj.duration      = pack:readUInt()           -- 毫秒
        --     table.insert( var_33_array, structObj )
        -- end
        local date = OtherEntity(np)
        PacketDispatcher:dispather( 0, 2, date )--分发数据
    end

    --创建主角
    --接收服务器
    protocol_func_map_server[0][3] = function ( np )
        local var_1_int64 = np:readInt64( ) --主角的handle
        print("-创建主角-创建主角-创建主角",type(var_1_int64))
        local var_2_unsigned_short = np:readWord( ) --数据的长度
        -- 实体的属性集
        -- protocol manual server 结构体
         local var_3_struct = nil
        var_3_struct = PlayerEntity( np )
        local var_4_string = np:readString( ) --角色显示的名字
        local var_5_int = np:readInt( ) --玩家是不是天元之战胜利帮派的--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 0, 3, var_1_int64, var_2_unsigned_short, var_3_struct, var_4_string, var_5_int )--分发数据
    end

    --其他玩家出现
    --接收服务器
    protocol_func_map_server[0][4] = function ( np )
        local var_1_int = np:readInt( ) --玩家id
        local var_2_int64 = np:readInt64( ) --实体的handle
        local var_3_unsigned_char = np:readByte( ) --是否是传送过来的
        local var_4_int = np:readInt( ) --当前X坐标
        local var_5_int = np:readInt( ) --Y坐标
        local var_6_int = np:readInt( ) --移动的目的点x
        local var_7_int = np:readInt( ) --移动的目的点y
        local var_8_int = np:readInt( ) --模型ID
        local var_9_unsigned_int = np:readUInt( ) --HP
        local var_10_int = np:readInt( ) --MP
        local var_11_unsigned_int = np:readUInt( ) --MAX_HP
        local var_12_unsigned_int = np:readUInt( ) --MAX_MP
        local var_13_unsigned_short = np:readWord( ) --移动速度
        local var_14_unsigned_char = np:readByte( ) --性别(0男，1女)
        local var_15_unsigned_char = np:readByte( ) --职业
        local var_16_unsigned_char = np:readByte( ) --等级
        local var_17_int = np:readInt( ) --武器外观
        local var_18_int = np:readInt( ) --坐骑外观
        local var_19_int = np:readInt( ) --翅膀特效
        local var_20_int = np:readInt( ) --社会关系
        local var_21_unsigned_short = np:readWord( ) --头像ID
        local var_22_unsigned_short = np:readWord( ) --攻击速度
        local var_23_unsigned_char = np:readByte( ) --dir
        local var_24_unsigned_int = np:readUInt( ) --玩家的状态
        local var_25_unsigned_char = np:readByte( ) --称号ID
        local var_26_unsigned_char = np:readByte( ) --玩家的阵营ID
        local var_27_int = np:readInt( ) --阵营职位Id
        local var_28_int = np:readInt( ) --低2位vip标记，高2位是pk模式--s本参数存在特殊说明，请查阅协议编辑器
        local var_29_int = np:readInt( ) --队伍id
        local var_30_int = np:readInt( ) --蓝黄钻信息
        local var_31_int = np:readInt( ) --玩家的打坐的特效
        local var_32_int = np:readInt( ) --头饰特效
        local var_33_int = np:readInt( ) --全身强化特效ID（高16位）
        local var_34_int = np:readInt( ) --活动中的临时阵营
        local var_35_int = np:readInt( ) --法阵的模型ID
        local var_36_int = np:readInt( ) --战灵的模型id
        local var_37_int = np:readInt( ) --仙盾的模型id
        local var_38_int = np:readInt( ) --影迹的模型id
        local var_39_unsigned_char = np:readByte( ) --出现形式--s本参数存在特殊说明，请查阅协议编辑器
        local var_40_unsigned_int = np:readUInt( ) --进入视野玩家名称颜色ARGB值
        local var_41_string = np:readString( ) --实体的名字
        local var_42_unsigned_char = np:readByte( ) --buff的数量
        -- Buff列表--s本参数存在特殊说明，请查阅协议编辑器
        local var_43_array = {}
        for i = 1, var_42_unsigned_char do 
            -- protocol manual server 数组
            local structObj = BuffStruct( np )
            table.insert( var_43_array, structObj )
        end
        local var_44_unsigned_char = np:readByte( ) --玩家特效的数量
        -- 特效的数据--s本参数存在特殊说明，请查阅协议编辑器
        local var_45_array = {}
        for i = 1, var_44_unsigned_char do 
            -- protocol manual server 数组
            local structObj = {}
            structObj[1] = np:readByte( )
            structObj[2] = np:readWord( )
            structObj[3] = np:readUInt( )
            table.insert( var_45_array, structObj )
        end
        -- 玩家称号数据--s本参数存在特殊说明，请查阅协议编辑器
        local var_46_array = {}
        for i = 1, 32 do 
            -- protocol manual server 数组
            local structObj = np:readByte( )
            table.insert( var_46_array, structObj )
        end
        -- 玩家称号是否显示--s本参数存在特殊说明，请查阅协议编辑器
        local var_47_array = {}
        for i = 1, 32 do 
            -- protocol manual server 数组
            local structObj = np:readByte( )
            table.insert( var_46_array, structObj )
        end
        local var_48_int = np:readInt( ) --玩家是否属于天元之城帮派--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 0, 4, var_1_int, var_2_int64, var_3_unsigned_char, var_4_int, var_5_int, var_6_int, var_7_int, var_8_int, var_9_unsigned_int, var_10_int, var_11_unsigned_int, var_12_unsigned_int, var_13_unsigned_short, var_14_unsigned_char, var_15_unsigned_char, var_16_unsigned_char, var_17_int, var_18_int, var_19_int, var_20_int, var_21_unsigned_short, var_22_unsigned_short, var_23_unsigned_char, var_24_unsigned_int, var_25_unsigned_char, var_26_unsigned_char, var_27_int, var_28_int, var_29_int, var_30_int, var_31_int, var_32_int, var_33_int, var_34_int, var_35_int, var_36_int, var_37_int, var_38_int, var_39_unsigned_char, var_40_unsigned_int, var_41_string, var_42_unsigned_char, var_43_array, var_44_unsigned_char, var_45_array, var_46_array, var_47_array, var_48_int )--分发数据
    end

    --实体的属性改变
    --接收服务器
    protocol_func_map_server[0][6] = function ( np )
        local var_1_int64 = np:readInt64( ) --实体的句柄
        local var_2_unsigned_char = np:readByte( ) --发送的属性的个数
        -- 数据--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_array = {}
        for i = 1, var_2_unsigned_char do 
            -- protocol manual server 数组
            local attri_id      = np:readByte()
            local value         = EntityConfig.ACTOR_PROPERTY[attri_id] or "int"
            local attri_value
            if value[2] == "int" then
                attri_value = np:readInt()
            elseif value[2] == "uint" then
                attri_value = np:readUInt()
            elseif value[2] == "float" then
                attri_value = np:readFloat()
            end
            local structObj = {value[1],attri_value}
            table.insert( var_3_array, structObj )
        end
        PacketDispatcher:dispather( 0, 6, var_1_int64, var_2_unsigned_char, var_3_array )--分发数据
    end

    --主角的属性发生改变
    --接收服务器
    protocol_func_map_server[0][7] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --属性的个数
        -- 属性列表--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_unsigned_char do 
            -- protocol manual server 数组
            local attri_id      = np:readByte()
            local value         = EntityConfig.ACTOR_PROPERTY[attri_id] or "int"
            local attri_value
            if value[2] == "int" then
                attri_value = np:readInt()
            elseif value[2] == "uint" then
                attri_value = np:readUInt()
            elseif value[2] == "float" then
                attri_value = np:readFloat()
            end
            local structObj = {value[1],attri_value}
            table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 0, 7, var_1_unsigned_char, var_2_array )--分发数据
    end

    --下发区域属性信息
    --接收服务器
    protocol_func_map_server[0][41] = function ( np )
        local var_1_string = np:readString( ) --区域名称
        local var_2_unsigned_char = np:readByte( ) --下发表示区域属性的int的个数--s本参数存在特殊说明，请查阅协议编辑器
        -- 属性列表--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_array = {}
        for i = 1, var_2_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_3_array, structObj )
        end
        PacketDispatcher:dispather( 0, 41, var_1_string, var_2_unsigned_char, var_3_array )--分发数据
    end

    --下属属性改变
    --接收服务器
    protocol_func_map_server[0][43] = function ( np )
        local var_1_int64 = np:readInt64( ) --下属句柄
        local var_2_unsigned_char = np:readByte( ) --属性数量
        -- 更新属性列表--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_array = {}
        for i = 1, var_2_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_3_array, structObj )
        end
        PacketDispatcher:dispather( 0, 43, var_1_int64, var_2_unsigned_char, var_3_array )--分发数据
    end

