    if ( protocol_func_map_server[7] == nil ) then
        protocol_func_map_server[7] = {}
    end



    --下发装备列表
    --接收服务器
    protocol_func_map_server[7][3] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --装备的数量
        -- 装备的列表--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 7, 3, var_1_unsigned_char, var_2_array )--分发数据
    end

    --下发其他玩家的装备
    --接收服务器
    protocol_func_map_server[7][5] = function ( np )
        local var_1_string = np:readString( ) --玩家的名字
        local var_2_unsigned_char = np:readByte( ) --玩家的职业
        local var_3_unsigned_char = np:readByte( ) --玩家的等级
        local var_4_unsigned_char = np:readByte( ) --玩家的性别
        local var_5_unsigned_int = np:readUInt( ) --玩家的modelID
        local var_6_unsigned_int = np:readUInt( ) --玩家的武器外观
        local var_7_unsigned_int = np:readUInt( ) --玩家的坐骑外观
        local var_8_int = np:readInt( ) --vip标志--s本参数存在特殊说明，请查阅协议编辑器
        local var_9_unsigned_char = np:readByte( ) --装备的数量
        -- 装备的列表--s本参数存在特殊说明，请查阅协议编辑器
        local var_10_array = {}
        for i = 1, var_9_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_10_array, structObj )
        end
        local var_11_bool = np:readChar( ) --是否当前装备宝物
        -- 如果装备有宝物，这里保存宝物的数据。内容和宝物子系统数据一样
        -- protocol manual server 结构体
         local var_12_struct = nil
        --var_12_struct = struct( np )
        local var_13_unsigned_int = np:readUInt( ) --内功攻击
        local var_14_unsigned_int = np:readUInt( ) --外功攻击
        local var_15_unsigned_int = np:readUInt( ) --内功防御
        local var_16_unsigned_int = np:readUInt( ) --外功防御
        local var_17_unsigned_int = np:readUInt( ) --命中值
        local var_18_unsigned_int = np:readUInt( ) --闪避值
        local var_19_unsigned_int = np:readUInt( ) --暴击值
        local var_20_unsigned_int = np:readUInt( ) --当前的HP
        local var_21_unsigned_int = np:readUInt( ) --最大的HP
        local var_22_unsigned_int = np:readUInt( ) --当前的MP
        local var_23_unsigned_int = np:readUInt( ) --最大的MP
        local var_24_unsigned_int = np:readUInt( ) --装备的总分
        local var_25_unsigned_int = np:readUInt( ) --阵营贡献
        local var_26_unsigned_int = np:readUInt( ) --战魂值
        local var_27_unsigned_int = np:readUInt( ) --PK值
        local var_28_unsigned_int = np:readUInt( ) --魅力值
        PacketDispatcher:dispather( 7, 5, var_1_string, var_2_unsigned_char, var_3_unsigned_char, var_4_unsigned_char, var_5_unsigned_int, var_6_unsigned_int, var_7_unsigned_int, var_8_int, var_9_unsigned_char, var_10_array, var_11_bool, var_12_struct, var_13_unsigned_int, var_14_unsigned_int, var_15_unsigned_int, var_16_unsigned_int, var_17_unsigned_int, var_18_unsigned_int, var_19_unsigned_int, var_20_unsigned_int, var_21_unsigned_int, var_22_unsigned_int, var_23_unsigned_int, var_24_unsigned_int, var_25_unsigned_int, var_26_unsigned_int, var_27_unsigned_int, var_28_unsigned_int )--分发数据
    end

