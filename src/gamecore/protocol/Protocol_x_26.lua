    if ( protocol_func_map_server[26] == nil ) then
        protocol_func_map_server[26] = {}
    end



    --下发玩家的信息
    --接收服务器
    protocol_func_map_server[26][1] = function ( np )
        local var_1_unsigned_int = np:readUInt( ) --玩家的actorid
        local var_2_unsigned_char = np:readByte( ) --职业
        local var_3_unsigned_char = np:readByte( ) --阵营id
        local var_4_unsigned_char = np:readByte( ) --等级
        local var_5_unsigned_char = np:readByte( ) --头像
        local var_6_int = np:readInt( ) --仙宗id--s本参数存在特殊说明，请查阅协议编辑器
        local var_7_int = np:readInt( ) --蓝黄钻信息
        local var_8_int = np:readInt( ) --神龙信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_9_int = np:readInt( ) --历史最高强化等级
        -- 装备列表信息--s本参数存在特殊说明，请查阅协议编辑器
        -- protocol manual server 结构体
         local var_10_struct = nil
        --var_10_struct = struct( np )
        -- 玩家显示属性--s本参数存在特殊说明，请查阅协议编辑器
        -- protocol manual server 结构体
         local var_11_struct = nil
        --var_11_struct = struct( np )
        local var_12_string = np:readString( ) --玩家名字
        local var_13_string = np:readString( ) --伴侣名字，若无则为空串
        local var_14_string = np:readString( ) --仙宗名字
        PacketDispatcher:dispather( 26, 1, var_1_unsigned_int, var_2_unsigned_char, var_3_unsigned_char, var_4_unsigned_char, var_5_unsigned_char, var_6_int, var_7_int, var_8_int, var_9_int, var_10_struct, var_11_struct, var_12_string, var_13_string, var_14_string )--分发数据
    end

    --下发排行榜的列表
    --接收服务器
    protocol_func_map_server[26][6] = function ( np )
        local var_1_unsigned_short = np:readWord( ) --排行榜的数量
        -- 排行榜的名称列表--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_unsigned_short do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 26, 6, var_1_unsigned_short, var_2_array )--分发数据
    end

    --下发具体某个排行榜的数据
    --接收服务器
    protocol_func_map_server[26][7] = function ( np )
        local var_1_string = np:readString( ) --排行榜的名称--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_int = np:readInt( ) --排行榜项的数量--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_unsigned_short = np:readWord( ) --标题的数量--s本参数存在特殊说明，请查阅协议编辑器
        -- 标题的名称--s本参数存在特殊说明，请查阅协议编辑器
        local var_4_array = {}
        for i = 1, var_3_unsigned_short do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_4_array, structObj )
        end
        -- 每项的数据--s本参数存在特殊说明，请查阅协议编辑器
        local var_5_array = {}
        for i = 1, var_4_array do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_5_array, structObj )
        end
        PacketDispatcher:dispather( 26, 7, var_1_string, var_2_int, var_3_unsigned_short, var_4_array, var_5_array )--分发数据
    end

    --下发区域属性buff数据
    --接收服务器
    protocol_func_map_server[26][10] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --buff的数量
        -- buff的内容--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 26, 10, var_1_unsigned_char, var_2_array )--分发数据
    end

    --更新计分项
    --接收服务器
    protocol_func_map_server[26][13] = function ( np )
        local var_1_int64 = np:readInt64( ) --计分器ID
        local var_2_unsigned_short = np:readWord( ) --数据包中计分项数量
        -- 计分项数据--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_array = {}
        for i = 1, var_2_unsigned_short do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_3_array, structObj )
        end
        PacketDispatcher:dispather( 26, 13, var_1_int64, var_2_unsigned_short, var_3_array )--分发数据
    end

    --下发玩家的剧情动画数据
    --接收服务器
    protocol_func_map_server[26][15] = function ( np )
        local var_1_int = np:readInt( ) --数量
        -- int序列--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 26, 15, var_1_int, var_2_array )--分发数据
    end

    --下发排行榜数据（数据库）
    --接收服务器
    protocol_func_map_server[26][21] = function ( np )
        local var_1_int = np:readInt( ) --排行榜id
        local var_2_int = np:readInt( ) --本次下发的个数
        local var_3_int = np:readInt( ) --当前第几页，从0开始
        local var_4_int = np:readInt( ) --一共多少页
        -- 排行榜的数据--s本参数存在特殊说明，请查阅协议编辑器
        local var_5_array = {}
        for i = 1, var_4_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_5_array, structObj )
        end
        PacketDispatcher:dispather( 26, 21, var_1_int, var_2_int, var_3_int, var_4_int, var_5_array )--分发数据
    end

    --返回排行榜某个玩家的详细信息（数据库）
    --接收服务器
    protocol_func_map_server[26][22] = function ( np )
        local var_1_int = np:readInt( ) --玩家id
        local var_2_int = np:readInt( ) --排行榜id
        local var_3_int = np:readInt( ) --titleId，称号Id
        local var_4_int = np:readInt( ) --是否有坐骑数据--s本参数存在特殊说明，请查阅协议编辑器
        -- 坐骑数据--s本参数存在特殊说明，请查阅协议编辑器
        local var_5_array = {}
        for i = 1, var_4_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_5_array, structObj )
        end
        local var_6_int = np:readInt( ) --个人装备数量
        -- 装备数据
        local var_7_array = {}
        for i = 1, var_6_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_7_array, structObj )
        end
        local var_8_int = np:readInt( ) --宠物-是否有宠物数据，没有的话后面宠物相关的数据不用读
        local var_9_int = np:readInt( ) --宠物-类型值
        local var_10_int = np:readInt( ) --宠物-宠物Id，petId
        local var_11_int = np:readInt( ) --宠物-等级
        -- 宠物-基本属性值--s本参数存在特殊说明，请查阅协议编辑器
        local var_12_array = {}
        for i = 1, var_11_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_12_array, structObj )
        end
        local var_13_short = np:readShort( ) --宠物-技能数量
        -- 宠物-技能数据--s本参数存在特殊说明，请查阅协议编辑器
        local var_14_array = {}
        for i = 1, var_13_short do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_14_array, structObj )
        end
        local var_15_short = np:readShort( ) --宠物-装备数量
        -- 宠物-装备数据--s本参数存在特殊说明，请查阅协议编辑器
        local var_16_array = {}
        for i = 1, var_15_short do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_16_array, structObj )
        end
        local var_17_int = np:readInt( ) --龙魂特效ID
        local var_18_int = np:readInt( ) --历史最高强化等级
        local var_19_int = np:readInt( ) --神兵模型
        local var_20_int = np:readInt( ) --法阵模型
        local var_21_int = np:readInt( ) --战灵模型
        local var_22_short = np:readShort( ) --翅膀技能-数量
        -- 翅膀技能-信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_23_array = {}
        for i = 1, var_22_short do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_23_array, structObj )
        end
        local var_24_int = np:readInt( ) --法宝—是否有数据--s本参数存在特殊说明，请查阅协议编辑器
        local var_25_short = np:readShort( ) --法宝-当前幻化法宝Id
        local var_26_short = np:readShort( ) --法宝-数量
        -- 法宝信息数据--s本参数存在特殊说明，请查阅协议编辑器
        local var_27_array = {}
        for i = 1, var_26_short do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_27_array, structObj )
        end
        -- 龙魂等级数组，每一个值类型为byte，0表示未开启
        local var_28_array = {}
        for i = 1, var_27_array do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_28_array, structObj )
        end
        local var_29_unsigned_char = np:readByte( ) --神兵阶值
        local var_30_unsigned_char = np:readByte( ) --神兵星值
        local var_31_unsigned_char = np:readByte( ) --神兵技能数
        -- 神兵技能数组--s本参数存在特殊说明，请查阅协议编辑器
        local var_32_array = {}
        for i = 1, var_31_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_32_array, structObj )
        end
        local var_33_unsigned_char = np:readByte( ) --法阵阶值
        local var_34_unsigned_char = np:readByte( ) --法阵技能数
        -- 法阵技能数组--s本参数存在特殊说明，请查阅协议编辑器
        local var_35_array = {}
        for i = 1, var_34_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_35_array, structObj )
        end
        local var_36_unsigned_char = np:readByte( ) --战灵阶值
        local var_37_unsigned_char = np:readByte( ) --战灵技能数
        -- 战灵技能数组--s本参数存在特殊说明，请查阅协议编辑器
        local var_38_array = {}
        for i = 1, var_37_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_38_array, structObj )
        end
        local var_39_unsigned_char = np:readByte( ) --影迹阶值
        local var_40_unsigned_char = np:readByte( ) --影迹技能数
        -- 影迹技能数组--s本参数存在特殊说明，请查阅协议编辑器
        local var_41_array = {}
        for i = 1, var_40_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_41_array, structObj )
        end
        local var_42_unsigned_char = np:readByte( ) --神护阶值
        local var_43_unsigned_char = np:readByte( ) --神护星级
        local var_44_unsigned_char = np:readByte( ) --神护技能数
        -- 神护技能数组--s本参数存在特殊说明，请查阅协议编辑器
        local var_45_array = {}
        for i = 1, var_44_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_45_array, structObj )
        end
        PacketDispatcher:dispather( 26, 22, var_1_int, var_2_int, var_3_int, var_4_int, var_5_array, var_6_int, var_7_array, var_8_int, var_9_int, var_10_int, var_11_int, var_12_array, var_13_short, var_14_array, var_15_short, var_16_array, var_17_int, var_18_int, var_19_int, var_20_int, var_21_int, var_22_short, var_23_array, var_24_int, var_25_short, var_26_short, var_27_array, var_28_array, var_29_unsigned_char, var_30_unsigned_char, var_31_unsigned_char, var_32_array, var_33_unsigned_char, var_34_unsigned_char, var_35_array, var_36_unsigned_char, var_37_unsigned_char, var_38_array, var_39_unsigned_char, var_40_unsigned_char, var_41_array, var_42_unsigned_char, var_43_unsigned_char, var_44_unsigned_char, var_45_array )--分发数据
    end

    --下发本人排行数据（数据库）
    --接收服务器
    protocol_func_map_server[26][23] = function ( np )
        local var_1_int = np:readInt( ) --排行榜的数量--s本参数存在特殊说明，请查阅协议编辑器
        -- 上榜的名次--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 26, 23, var_1_int, var_2_array )--分发数据
    end

    --统计数据
    --接收服务器
    protocol_func_map_server[26][26] = function ( np )
        local var_1_int = np:readInt( ) --副本id
        local var_2_unsigned_char = np:readByte( ) --活动id
        local var_3_unsigned_char = np:readByte( ) --统计数量
        -- 统计内容--s本参数存在特殊说明，请查阅协议编辑器
        local var_4_array = {}
        for i = 1, var_3_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_4_array, structObj )
        end
        PacketDispatcher:dispather( 26, 26, var_1_int, var_2_unsigned_char, var_3_unsigned_char, var_4_array )--分发数据
    end

    --下发今天进入各个副本的次数
    --接收服务器
    protocol_func_map_server[26][28] = function ( np )
        local var_1_int = np:readInt( ) --副本个数
        -- 各个副本的次数--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 26, 28, var_1_int, var_2_array )--分发数据
    end

    --下发活跃奖励信息
    --接收服务器
    protocol_func_map_server[26][29] = function ( np )
        local var_1_int = np:readInt( ) --活跃目标的个数
        -- 各个活跃目标的次数--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        local var_3_int = np:readInt( ) --奖励情况个数
        -- 奖励领取情况列表--s本参数存在特殊说明，请查阅协议编辑器
        local var_4_array = {}
        for i = 1, var_3_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_4_array, structObj )
        end
        local var_5_int = np:readInt( ) --今天总的活跃度
        PacketDispatcher:dispather( 26, 29, var_1_int, var_2_array, var_3_int, var_4_array, var_5_int )--分发数据
    end

    --活动时间的变化
    --接收服务器
    protocol_func_map_server[26][36] = function ( np )
        local var_1_int = np:readInt( ) --数量
        -- 数据--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 26, 36, var_1_int, var_2_array )--分发数据
    end

    --世界BOSS-应答世界boss相关的数据请求
    --接收服务器
    protocol_func_map_server[26][35] = function ( np )
        local var_1_int = np:readInt( ) --数量
        -- 数据--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 26, 35, var_1_int, var_2_array )--分发数据
    end

    --世界BOSS-应答boss击杀者请求
    --接收服务器
    protocol_func_map_server[26][37] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --id，配置中的id从1开始
        local var_2_unsigned_char = np:readByte( ) --count，击杀者数量
        -- 击杀者数组--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_array = {}
        for i = 1, var_2_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_3_array, structObj )
        end
        PacketDispatcher:dispather( 26, 37, var_1_unsigned_char, var_2_unsigned_char, var_3_array )--分发数据
    end

    --显示城主装备信息
    --接收服务器
    protocol_func_map_server[26][40] = function ( np )
        local var_1_int = np:readInt( ) --角色ID
        local var_2_int = np:readInt( ) --等级
        local var_3_int = np:readInt( ) --阵营
        local var_4_int = np:readInt( ) --职业
        local var_5_int = np:readInt( ) --性别
        local var_6_int = np:readInt( ) --战斗力
        local var_7_int = np:readInt( ) --黄蓝钻信息
        local var_8_int = np:readInt( ) --身体模型
        local var_9_int = np:readInt( ) --武器
        local var_10_int = np:readInt( ) --翅膀
        local var_11_int = np:readInt( ) --神龙信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_12_int = np:readInt( ) --装备数量
        -- 每个装备信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_13_array = {}
        for i = 1, var_12_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_13_array, structObj )
        end
        local var_14_string = np:readString( ) --角色名字
        local var_15_string = np:readString( ) --帮派名
        local var_16_int = np:readInt( ) --历史最高强化等级
        local var_17_bool = np:readChar( ) --是否打开界面
        PacketDispatcher:dispather( 26, 40, var_1_int, var_2_int, var_3_int, var_4_int, var_5_int, var_6_int, var_7_int, var_8_int, var_9_int, var_10_int, var_11_int, var_12_int, var_13_array, var_14_string, var_15_string, var_16_int, var_17_bool )--分发数据
    end

    --下发今日拜神的次数
    --接收服务器
    protocol_func_map_server[26][25] = function ( np )
        -- 普通财神次数，数组，三个数据，分别表示仙币，银两，经验，每个都是byte
        -- 数组长度约定，要自己手动填
        local array_length_const = 10
        local var_1_array = {}
        for i = 1, array_length_const do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_1_array, structObj )
        end
        local var_2_int = np:readInt( ) --qq免费次数
        PacketDispatcher:dispather( 26, 25, var_1_array, var_2_int )--分发数据
    end

    --副本统计-可用于下发道具信息
    --接收服务器
    protocol_func_map_server[26][49] = function ( np )
        local var_1_int = np:readInt( ) --副本id
        local var_2_unsigned_int = np:readUInt( ) --活动id
        local var_3_unsigned_char = np:readByte( ) --StatsType, 统计类型--s本参数存在特殊说明，请查阅协议编辑器
        local var_4_unsigned_int = np:readUInt( ) --count, 数量--s本参数存在特殊说明，请查阅协议编辑器
        -- 道具id，道具数量--s本参数存在特殊说明，请查阅协议编辑器
        local var_5_array = {}
        for i = 1, var_4_unsigned_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_5_array, structObj )
        end
        PacketDispatcher:dispather( 26, 49, var_1_int, var_2_unsigned_int, var_3_unsigned_char, var_4_unsigned_int, var_5_array )--分发数据
    end

    --副本通关奖励-玩家成功通关后的信息
    --接收服务器
    protocol_func_map_server[26][50] = function ( np )
        local var_1_unsigned_int = np:readUInt( ) --fbId，通关的副本Id
        local var_2_unsigned_char = np:readByte( ) --level，玩家的评分等级--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_unsigned_char = np:readByte( ) --是否通关 1通关成功 0通关失败
        local var_4_unsigned_char = np:readByte( ) --count，数组中元素数量
        -- 固定奖励信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_5_array = {}
        for i = 1, var_4_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_5_array, structObj )
        end
        local var_6_unsigned_char = np:readByte( ) --能否VIP抽奖，0:不可以，1:可以
        local var_7_unsigned_char = np:readByte( ) --通关指定级别能否抽奖，0:不可以，1:可以
        local var_8_unsigned_char = np:readByte( ) --leftTime: 此副本剩余次数
        PacketDispatcher:dispather( 26, 50, var_1_unsigned_int, var_2_unsigned_char, var_3_unsigned_char, var_4_unsigned_char, var_5_array, var_6_unsigned_char, var_7_unsigned_char, var_8_unsigned_char )--分发数据
    end

    --副本通关奖励-服务端返回抽奖的结果
    --接收服务器
    protocol_func_map_server[26][51] = function ( np )
        local var_1_unsigned_int = np:readUInt( ) --fbId，抽奖时的副本
        local var_2_unsigned_char = np:readByte( ) --type，抽奖类型
        local var_3_unsigned_char = np:readByte( ) --count，奖励的物品数量
        -- 奖励的道具信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_4_array = {}
        for i = 1, var_3_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_4_array, structObj )
        end
        local var_5_unsigned_char = np:readByte( ) --index，表示第几张牌
        PacketDispatcher:dispather( 26, 51, var_1_unsigned_int, var_2_unsigned_char, var_3_unsigned_char, var_4_array, var_5_unsigned_char )--分发数据
    end

    --服务端下发第一排行榜面板信息
    --接收服务器
    protocol_func_map_server[26][53] = function ( np )
        local var_1_int = np:readInt( ) --数组有多少个信息
        -- 第一排行数组--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 26, 53, var_1_int, var_2_array )--分发数据
    end

    --战力比拼-技能比拼
    --接收服务器
    protocol_func_map_server[26][63] = function ( np )
        local var_1_int = np:readInt( ) --玩家id
        local var_2_int = np:readInt( ) --技能总战力
        local var_3_int = np:readInt( ) --技能数量
        -- 技能数据--s本参数存在特殊说明，请查阅协议编辑器
        local var_4_array = {}
        for i = 1, var_3_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_4_array, structObj )
        end
        PacketDispatcher:dispather( 26, 63, var_1_int, var_2_int, var_3_int, var_4_array )--分发数据
    end

    --战力比拼-龙魂比拼
    --接收服务器
    protocol_func_map_server[26][64] = function ( np )
        local var_1_int = np:readInt( ) --玩家id
        local var_2_int = np:readInt( ) --龙魂个数
        -- 龙魂数据--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_array = {}
        for i = 1, var_2_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_3_array, structObj )
        end
        PacketDispatcher:dispather( 26, 64, var_1_int, var_2_int, var_3_array )--分发数据
    end

    --副本通关奖励-应答客户端请求
    --接收服务器
    protocol_func_map_server[26][65] = function ( np )
        local var_1_unsigned_int = np:readUInt( ) --count
        -- 标志位数组--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_unsigned_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 26, 65, var_1_unsigned_int, var_2_array )--分发数据
    end

    --战力比拼-神兵比拼
    --接收服务器
    protocol_func_map_server[26][68] = function ( np )
        local var_1_int = np:readInt( ) --玩家id
        local var_2_unsigned_char = np:readByte( ) --是否开启了神兵系统--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_int = np:readInt( ) --神兵模型id
        local var_4_unsigned_char = np:readByte( ) --阶数
        local var_5_unsigned_char = np:readByte( ) --星数
        local var_6_int = np:readInt( ) --基础战力
        local var_7_int = np:readInt( ) --灵丹战力
        local var_8_int = np:readInt( ) --仙丹战力
        local var_9_int = np:readInt( ) --技能战力
        local var_10_unsigned_char = np:readByte( ) --技能数量
        -- 技能数据--s本参数存在特殊说明，请查阅协议编辑器
        local var_11_array = {}
        for i = 1, var_10_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_11_array, structObj )
        end
        PacketDispatcher:dispather( 26, 68, var_1_int, var_2_unsigned_char, var_3_int, var_4_unsigned_char, var_5_unsigned_char, var_6_int, var_7_int, var_8_int, var_9_int, var_10_unsigned_char, var_11_array )--分发数据
    end

    --战力比拼-装备战力比拼
    --接收服务器
    protocol_func_map_server[26][69] = function ( np )
        local var_1_int = np:readInt( ) --玩家id
        local var_2_int = np:readInt( ) --系统id
        local var_3_unsigned_char = np:readByte( ) --装备数量
        -- 装备列表--s本参数存在特殊说明，请查阅协议编辑器
        local var_4_array = {}
        for i = 1, var_3_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_4_array, structObj )
        end
        PacketDispatcher:dispather( 26, 69, var_1_int, var_2_int, var_3_unsigned_char, var_4_array )--分发数据
    end

    --战力比拼-法阵比拼
    --接收服务器
    protocol_func_map_server[26][70] = function ( np )
        local var_1_int = np:readInt( ) --玩家id
        local var_2_unsigned_char = np:readByte( ) --是否开启了法阵系统--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_int = np:readInt( ) --法阵模型id
        local var_4_unsigned_char = np:readByte( ) --阶数
        local var_5_int = np:readInt( ) --基础战力
        local var_6_int = np:readInt( ) --灵丹战力
        local var_7_int = np:readInt( ) --仙丹战力
        local var_8_int = np:readInt( ) --技能战力
        local var_9_unsigned_char = np:readByte( ) --技能数量
        -- 技能数据--s本参数存在特殊说明，请查阅协议编辑器
        local var_10_array = {}
        for i = 1, var_9_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_10_array, structObj )
        end
        PacketDispatcher:dispather( 26, 70, var_1_int, var_2_unsigned_char, var_3_int, var_4_unsigned_char, var_5_int, var_6_int, var_7_int, var_8_int, var_9_unsigned_char, var_10_array )--分发数据
    end

    --战力比拼-战灵比拼
    --接收服务器
    protocol_func_map_server[26][71] = function ( np )
        local var_1_int = np:readInt( ) --玩家id
        local var_2_unsigned_char = np:readByte( ) --是否开启了战灵系统--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_int = np:readInt( ) --战灵模型id
        local var_4_unsigned_char = np:readByte( ) --阶数
        local var_5_int = np:readInt( ) --基础战力
        local var_6_int = np:readInt( ) --灵丹战力
        local var_7_int = np:readInt( ) --仙丹战力
        local var_8_int = np:readInt( ) --技能战力
        local var_9_unsigned_char = np:readByte( ) --技能数量
        -- 技能数据--s本参数存在特殊说明，请查阅协议编辑器
        local var_10_array = {}
        for i = 1, var_9_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_10_array, structObj )
        end
        PacketDispatcher:dispather( 26, 71, var_1_int, var_2_unsigned_char, var_3_int, var_4_unsigned_char, var_5_int, var_6_int, var_7_int, var_8_int, var_9_unsigned_char, var_10_array )--分发数据
    end

    --战力比拼-仙遁比拼
    --接收服务器
    protocol_func_map_server[26][72] = function ( np )
        local var_1_int = np:readInt( ) --玩家id
        local var_2_unsigned_char = np:readByte( ) --是否开启了仙遁系统--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_int = np:readInt( ) --仙遁模型id
        local var_4_unsigned_char = np:readByte( ) --阶数
        local var_5_int = np:readInt( ) --基础战力
        local var_6_int = np:readInt( ) --灵丹战力
        local var_7_int = np:readInt( ) --仙丹战力
        local var_8_int = np:readInt( ) --技能战力
        local var_9_unsigned_char = np:readByte( ) --技能数量
        -- 技能数据--s本参数存在特殊说明，请查阅协议编辑器
        local var_10_array = {}
        for i = 1, var_9_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_10_array, structObj )
        end
        PacketDispatcher:dispather( 26, 72, var_1_int, var_2_unsigned_char, var_3_int, var_4_unsigned_char, var_5_int, var_6_int, var_7_int, var_8_int, var_9_unsigned_char, var_10_array )--分发数据
    end

    --战力比拼-影迹比拼
    --接收服务器
    protocol_func_map_server[26][73] = function ( np )
        local var_1_int = np:readInt( ) --玩家id
        local var_2_unsigned_char = np:readByte( ) --是否开启了影迹系统--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_int = np:readInt( ) --影迹模型id
        local var_4_unsigned_char = np:readByte( ) --阶数
        local var_5_int = np:readInt( ) --基础战力
        local var_6_int = np:readInt( ) --灵丹战力
        local var_7_int = np:readInt( ) --仙丹战力
        local var_8_int = np:readInt( ) --技能战力
        local var_9_unsigned_char = np:readByte( ) --技能数量
        -- 技能数据--s本参数存在特殊说明，请查阅协议编辑器
        local var_10_array = {}
        for i = 1, var_9_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_10_array, structObj )
        end
        PacketDispatcher:dispather( 26, 73, var_1_int, var_2_unsigned_char, var_3_int, var_4_unsigned_char, var_5_int, var_6_int, var_7_int, var_8_int, var_9_unsigned_char, var_10_array )--分发数据
    end

    --战力比拼-神护比拼
    --接收服务器
    protocol_func_map_server[26][74] = function ( np )
        local var_1_int = np:readInt( ) --玩家id
        local var_2_unsigned_char = np:readByte( ) --是否开启了神护系统--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_int = np:readInt( ) --神护模型id
        local var_4_unsigned_char = np:readByte( ) --阶数
        local var_5_unsigned_char = np:readByte( ) --星级
        local var_6_int = np:readInt( ) --基础战力
        local var_7_int = np:readInt( ) --灵丹战力
        local var_8_int = np:readInt( ) --仙丹战力
        local var_9_int = np:readInt( ) --技能战力
        local var_10_unsigned_char = np:readByte( ) --技能数量
        -- 技能数据--s本参数存在特殊说明，请查阅协议编辑器
        local var_11_array = {}
        for i = 1, var_10_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_11_array, structObj )
        end
        PacketDispatcher:dispather( 26, 74, var_1_int, var_2_unsigned_char, var_3_int, var_4_unsigned_char, var_5_unsigned_char, var_6_int, var_7_int, var_8_int, var_9_int, var_10_unsigned_char, var_11_array )--分发数据
    end

