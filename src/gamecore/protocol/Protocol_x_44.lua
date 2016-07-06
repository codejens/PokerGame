    if ( protocol_func_map_server[44] == nil ) then
        protocol_func_map_server[44] = {}
    end



    --下发神器信息
    --接收服务器
    protocol_func_map_server[44][1] = function ( np )
        local var_1_int = np:readInt( ) --玩家ID
        local var_2_int = np:readInt( ) --神器战斗力
        local var_3_unsigned_char = np:readByte( ) --有几个神器数据
        -- 神器数据，结构如下
        local var_4_array = {}
        for i = 1, var_3_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_4_array, structObj )
        end
        local var_5_unsigned_char = np:readByte( ) --第几个神器
        local var_6_unsigned_char = np:readByte( ) --神器等级
        local var_7_int = np:readInt( ) --神器修炼值
        local var_8_unsigned_int = np:readUInt( ) --神器修炼值到期时间
        local var_9_unsigned_char = np:readByte( ) --神器转生值
        local var_10_unsigned_char = np:readByte( ) --神器当前星值
        local var_11_unsigned_char = np:readByte( ) --第一个神器技能等级
        local var_12_int = np:readInt( ) --第一个神器技能熟练度
        local var_13_unsigned_char = np:readByte( ) --第二个神器技能等级
        local var_14_int = np:readInt( ) --第二个神器技能熟练度
        PacketDispatcher:dispather( 44, 1, var_1_int, var_2_int, var_3_unsigned_char, var_4_array, var_5_unsigned_char, var_6_unsigned_char, var_7_int, var_8_unsigned_int, var_9_unsigned_char, var_10_unsigned_char, var_11_unsigned_char, var_12_int, var_13_unsigned_char, var_14_int )--分发数据
    end

    --下发觅灵信息
    --接收服务器
    protocol_func_map_server[44][4] = function ( np )
        local var_1_int = np:readInt( ) --玩家灵液数
        local var_2_unsigned_char = np:readByte( ) --今日剩余觅灵数
        local var_3_unsigned_char = np:readByte( ) --今日剩余免费引灵数
        local var_4_unsigned_char = np:readByte( ) --今日使用过的通天引灵次数
        local var_5_unsigned_char = np:readByte( ) --当前是否正在觅灵，1是0否
        -- 当前觅灵情况--s本参数存在特殊说明，请查阅协议编辑器
        local var_6_array = {}
        for i = 1, var_5_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_6_array, structObj )
        end
        PacketDispatcher:dispather( 44, 4, var_1_int, var_2_unsigned_char, var_3_unsigned_char, var_4_unsigned_char, var_5_unsigned_char, var_6_array )--分发数据
    end

    --玩家选择回忆结果
    --接收服务器
    protocol_func_map_server[44][9] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --获得经验的神器类型
        local var_2_unsigned_char = np:readByte( ) --获得经验的技能下标
        local var_3_unsigned_char = np:readByte( ) --所选择的经验下标
        -- 大小为6的int数组，表示编号为1-6的经验值
        local var_4_array = {}
        for i = 1, var_3_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_4_array, structObj )
        end
        local var_5_unsigned_char = np:readByte( ) --是否自动选择
        local var_6_unsigned_char = np:readByte( ) --是否完美回忆，1是0否
        PacketDispatcher:dispather( 44, 9, var_1_unsigned_char, var_2_unsigned_char, var_3_unsigned_char, var_4_array, var_5_unsigned_char, var_6_unsigned_char )--分发数据
    end

