    if ( protocol_func_map_server[148] == nil ) then
        protocol_func_map_server[148] = {}
    end



    --婚礼-新增预约婚礼
    --接收服务器
    protocol_func_map_server[148][3] = function ( np )
        local var_1_int = np:readInt( ) --返回的数量
        -- 婚礼的数据，即后面的字段
        local var_2_array = {}
        for i = 1, var_1_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        local var_3_int = np:readInt( ) --婚礼的唯一id，用户选参加婚礼时要发这个id
        local var_4_int = np:readInt( ) --婚礼时间--s本参数存在特殊说明，请查阅协议编辑器
        local var_5_int = np:readInt( ) --1：普通，2：豪华
        local var_6_int = np:readInt( ) --结婚人角色id1
        local var_7_unsigned_char = np:readByte( ) --性别
        local var_8_unsigned_char = np:readByte( ) --职业
        local var_9_unsigned_char = np:readByte( ) --阵营id
        local var_10_unsigned_char = np:readByte( ) --等级
        local var_11_int = np:readInt( ) --结婚人角色id2
        local var_12_unsigned_char = np:readByte( ) --性别
        local var_13_unsigned_char = np:readByte( ) --职业
        local var_14_unsigned_char = np:readByte( ) --阵营id
        local var_15_unsigned_char = np:readByte( ) --等级
        local var_16_string = np:readString( ) --结婚人角色名字1
        local var_17_string = np:readString( ) --结婚人角色名字2
        PacketDispatcher:dispather( 148, 3, var_1_int, var_2_array, var_3_int, var_4_int, var_5_int, var_6_int, var_7_unsigned_char, var_8_unsigned_char, var_9_unsigned_char, var_10_unsigned_char, var_11_int, var_12_unsigned_char, var_13_unsigned_char, var_14_unsigned_char, var_15_unsigned_char, var_16_string, var_17_string )--分发数据
    end

    --应答获取仙侣记录
    --接收服务器
    protocol_func_map_server[148][4] = function ( np )
        local var_1_int = np:readInt( ) --本次下发的数量
        local var_2_int = np:readInt( ) --当前第几页--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_int = np:readInt( ) --一共多少页
        -- 每项的数据--s本参数存在特殊说明，请查阅协议编辑器
        local var_4_array = {}
        for i = 1, var_3_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_4_array, structObj )
        end
        PacketDispatcher:dispather( 148, 4, var_1_int, var_2_int, var_3_int, var_4_array )--分发数据
    end

    --新增仙侣记录
    --接收服务器
    protocol_func_map_server[148][14] = function ( np )
        -- --s本参数存在特殊说明，请查阅协议编辑器
        -- 数组长度约定，要自己手动填
        local array_length_const = 10
        local var_1_array = {}
        for i = 1, array_length_const do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_1_array, structObj )
        end
        PacketDispatcher:dispather( 148, 14, var_1_array )--分发数据
    end

