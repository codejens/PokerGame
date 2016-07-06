    if ( protocol_func_map_server[50] == nil ) then
        protocol_func_map_server[50] = {}
    end



    --神兵信息
    --接收服务器
    protocol_func_map_server[50][1] = function ( np )
        local var_1_string = np:readString( ) --玩家名字
        local var_2_char = np:readChar( ) --错误码--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_unsigned_char = np:readByte( ) --阶数
        local var_4_unsigned_char = np:readByte( ) --星数
        local var_5_int = np:readInt( ) --灵丹数
        local var_6_int = np:readInt( ) --仙丹数
        local var_7_unsigned_char = np:readByte( ) --化型的阶数
        local var_8_int = np:readInt( ) --祝福值
        local var_9_unsigned_char = np:readByte( ) --最大技能格数
        -- 技能--s本参数存在特殊说明，请查阅协议编辑器
        local var_10_array = {}
        for i = 1, var_9_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_10_array, structObj )
        end
        local var_11_int = np:readInt( ) --祝福值剩余时间
        PacketDispatcher:dispather( 50, 1, var_1_string, var_2_char, var_3_unsigned_char, var_4_unsigned_char, var_5_int, var_6_int, var_7_unsigned_char, var_8_int, var_9_unsigned_char, var_10_array, var_11_int )--分发数据
    end

    --学习技能返回
    --接收服务器
    protocol_func_map_server[50][5] = function ( np )
        local var_1_unsigned_short = np:readWord( ) --技能数
        -- 技能信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_unsigned_short do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 50, 5, var_1_unsigned_short, var_2_array )--分发数据
    end

    --开启信息
    --接收服务器
    protocol_func_map_server[50][9] = function ( np )
        local var_1_char = np:readChar( ) --是否已激活--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_char = np:readChar( ) --条件个数
        -- 条件是否已达到--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_array = {}
        for i = 1, var_2_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_3_array, structObj )
        end
        PacketDispatcher:dispather( 50, 9, var_1_char, var_2_char, var_3_array )--分发数据
    end

    --神兵信息
    --接收服务器
    protocol_func_map_server[50][10] = function ( np )
        -- 内容同协议1
        -- protocol manual server 结构体
         local var_1_struct = nil
        --var_1_struct = struct( np )
        PacketDispatcher:dispather( 50, 10, var_1_struct )--分发数据
    end

    --登陆时下发装备信息
    --接收服务器
    protocol_func_map_server[50][14] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --装备数量
        -- 装备信息数组，类型为标准UserItem结构
        local var_2_array = {}
        for i = 1, var_1_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 50, 14, var_1_unsigned_char, var_2_array )--分发数据
    end

