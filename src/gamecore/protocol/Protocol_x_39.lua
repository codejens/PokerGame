    if ( protocol_func_map_server[39] == nil ) then
        protocol_func_map_server[39] = {}
    end



    --发送竞技场对手信息
    --接收服务器
    protocol_func_map_server[39][1] = function ( np )
        local var_1_int = np:readInt( ) --对手玩家个数
        -- 对手信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 39, 1, var_1_int, var_2_array )--分发数据
    end

    --返回排行榜
    --接收服务器
    protocol_func_map_server[39][5] = function ( np )
        local var_1_int = np:readInt( ) --总共多少页
        local var_2_int = np:readInt( ) --第几页
        local var_3_int = np:readInt( ) --这页共有多少项
        -- 各排行榜项--s本参数存在特殊说明，请查阅协议编辑器
        local var_4_array = {}
        for i = 1, var_3_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_4_array, structObj )
        end
        PacketDispatcher:dispather( 39, 5, var_1_int, var_2_int, var_3_int, var_4_array )--分发数据
    end

    --发送玩家战绩记录
    --接收服务器
    protocol_func_map_server[39][6] = function ( np )
        local var_1_int = np:readInt( ) --记录条数
        -- 战绩记录--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 39, 6, var_1_int, var_2_array )--分发数据
    end

    --发送冠亚季军信息
    --接收服务器
    protocol_func_map_server[39][8] = function ( np )
        local var_1_int = np:readInt( ) --个数
        -- 冠亚季军信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 39, 8, var_1_int, var_2_array )--分发数据
    end

    --发送战报
    --接收服务器
    protocol_func_map_server[39][13] = function ( np )
        local var_1_string = np:readString( ) --自己名字
        local var_2_unsigned_int = np:readUInt( ) --自己等级
        local var_3_unsigned_int = np:readUInt( ) --自己头像
        local var_4_int = np:readInt( ) --自己模型id
        local var_5_int = np:readInt( ) --自己武器id
        local var_6_int = np:readInt( ) --自己宠物id
        local var_7_int = np:readInt( ) --自己血量
        local var_8_unsigned_char = np:readByte( ) --自己职业
        local var_9_unsigned_char = np:readByte( ) --自己性别
        local var_10_int = np:readInt( ) --自己翅膀
        local var_11_int = np:readInt( ) --自己法宝
        local var_12_int = np:readInt( ) --对方名字
        local var_13_unsigned_int = np:readUInt( ) --对方等级
        local var_14_unsigned_int = np:readUInt( ) --对方头像
        local var_15_int = np:readInt( ) --对方模型
        local var_16_int = np:readInt( ) --对方武器
        local var_17_int = np:readInt( ) --对方宠物
        local var_18_int = np:readInt( ) --对方血量
        local var_19_unsigned_char = np:readByte( ) --对方职业
        local var_20_unsigned_char = np:readByte( ) --对方性别
        local var_21_int = np:readInt( ) --对方翅膀
        local var_22_int = np:readInt( ) --对方法宝
        local var_23_unsigned_char = np:readByte( ) --开始倒计时
        local var_24_unsigned_short = np:readWord( ) --战斗倒计时
        local var_25_int = np:readInt( ) --每回合战斗时间
        local var_26_unsigned_short = np:readWord( ) --战斗回合数
        -- 回合战斗情况--s本参数存在特殊说明，请查阅协议编辑器
        local var_27_array = {}
        for i = 1, var_26_unsigned_short do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_27_array, structObj )
        end
        PacketDispatcher:dispather( 39, 13, var_1_string, var_2_unsigned_int, var_3_unsigned_int, var_4_int, var_5_int, var_6_int, var_7_int, var_8_unsigned_char, var_9_unsigned_char, var_10_int, var_11_int, var_12_int, var_13_unsigned_int, var_14_unsigned_int, var_15_int, var_16_int, var_17_int, var_18_int, var_19_unsigned_char, var_20_unsigned_char, var_21_int, var_22_int, var_23_unsigned_char, var_24_unsigned_short, var_25_int, var_26_unsigned_short, var_27_array )--分发数据
    end

    --服务端下发竞技兑换信息
    --接收服务器
    protocol_func_map_server[39][18] = function ( np )
        local var_1_int = np:readInt( ) --竞技积分兑换列表长度
        -- 竞技积分兑换列表--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 39, 18, var_1_int, var_2_array )--分发数据
    end

