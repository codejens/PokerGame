    if ( protocol_func_map_server[46] == nil ) then
        protocol_func_map_server[46] = {}
    end



    --发送我的战队信息
    --接收服务器
    protocol_func_map_server[46][1] = function ( np )
        local var_1_int = np:readInt( ) --战队ID--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_string = np:readString( ) --战队名称
        local var_3_int = np:readInt( ) --队长的玩家ID
        local var_4_int64 = np:readInt64( ) --战队积分
        local var_5_int = np:readInt( ) --战队战斗力
        local var_6_int = np:readInt( ) --本服排名
        local var_7_int = np:readInt( ) --跨服排名
        local var_8_int = np:readInt( ) --成员数
        -- 成员列表--s本参数存在特殊说明，请查阅协议编辑器
        local var_9_array = {}
        for i = 1, var_8_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_9_array, structObj )
        end
        PacketDispatcher:dispather( 46, 1, var_1_int, var_2_string, var_3_int, var_4_int64, var_5_int, var_6_int, var_7_int, var_8_int, var_9_array )--分发数据
    end

    --发送可邀请加入战队的玩家列表
    --接收服务器
    protocol_func_map_server[46][3] = function ( np )
        local var_1_int = np:readInt( ) --玩家数量
        -- 各个玩家信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 46, 3, var_1_int, var_2_array )--分发数据
    end

    --发送可加入的战队列表
    --接收服务器
    protocol_func_map_server[46][6] = function ( np )
        local var_1_int = np:readInt( ) --战队总数量
        local var_2_int = np:readInt( ) --这次发送从第几个开始(从0开始)
        local var_3_int = np:readInt( ) --这次共发送多少个战队
        -- 各个战队信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_4_array = {}
        for i = 1, var_3_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_4_array, structObj )
        end
        PacketDispatcher:dispather( 46, 6, var_1_int, var_2_int, var_3_int, var_4_array )--分发数据
    end

    --PK结束
    --接收服务器
    protocol_func_map_server[46][16] = function ( np )
        local var_1_int = np:readInt( ) --pk类型--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_int = np:readInt( ) --获得的跨服荣誉
        local var_3_string = np:readString( ) --胜利方来自的服务器
        local var_4_int = np:readInt( ) --胜利方玩家人数
        -- 胜利方玩家信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_5_array = {}
        for i = 1, var_4_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_5_array, structObj )
        end
        local var_6_string = np:readString( ) --失败方来自的服务器
        local var_7_int = np:readInt( ) --失败方玩家人数
        -- 失败方玩家信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_8_array = {}
        for i = 1, var_7_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_8_array, structObj )
        end
        PacketDispatcher:dispather( 46, 16, var_1_int, var_2_int, var_3_string, var_4_int, var_5_array, var_6_string, var_7_int, var_8_array )--分发数据
    end

    --发送战队排行
    --接收服务器
    protocol_func_map_server[46][17] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --是否本服战队--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_int = np:readInt( ) --总共多少页
        local var_3_int = np:readInt( ) --第几页--s本参数存在特殊说明，请查阅协议编辑器
        local var_4_int = np:readInt( ) --该页战队数量
        -- 各个战队信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_5_array = {}
        for i = 1, var_4_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_5_array, structObj )
        end
        PacketDispatcher:dispather( 46, 17, var_1_unsigned_char, var_2_int, var_3_int, var_4_int, var_5_array )--分发数据
    end

    --发送MVP排行榜
    --接收服务器
    protocol_func_map_server[46][18] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --是否本服排行--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_int = np:readInt( ) --总共多少页
        local var_3_int = np:readInt( ) --第几页--s本参数存在特殊说明，请查阅协议编辑器
        local var_4_int = np:readInt( ) --该页有多少项
        -- 每一项的信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_5_array = {}
        for i = 1, var_4_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_5_array, structObj )
        end
        PacketDispatcher:dispather( 46, 18, var_1_unsigned_char, var_2_int, var_3_int, var_4_int, var_5_array )--分发数据
    end

    --发送对手信息
    --接收服务器
    protocol_func_map_server[46][19] = function ( np )
        local var_1_int = np:readInt( ) --来自几服
        local var_2_int = np:readInt( ) --pk剩余时间（秒）
        local var_3_int = np:readInt( ) --对手数量
        -- 对手信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_4_array = {}
        for i = 1, var_3_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_4_array, structObj )
        end
        PacketDispatcher:dispather( 46, 19, var_1_int, var_2_int, var_3_int, var_4_array )--分发数据
    end

    --小组赛_小组赛当天赛程
    --接收服务器
    protocol_func_map_server[46][22] = function ( np )
        local var_1_string = np:readString( ) --我的战队名称
        local var_2_unsigned_char = np:readByte( ) --战斗场数
        -- 对战信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_array = {}
        for i = 1, var_2_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_3_array, structObj )
        end
        PacketDispatcher:dispather( 46, 22, var_1_string, var_2_unsigned_char, var_3_array )--分发数据
    end

    --小组赛_返回战队分组
    --接收服务器
    protocol_func_map_server[46][24] = function ( np )
        local var_1_char = np:readChar( ) --分组状况--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_unsigned_char = np:readByte( ) --分组数量
        -- --s本参数存在特殊说明，请查阅协议编辑器
        local var_3_array = {}
        for i = 1, var_2_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_3_array, structObj )
        end
        PacketDispatcher:dispather( 46, 24, var_1_char, var_2_unsigned_char, var_3_array )--分发数据
    end

    --小组赛_返回小组排行榜
    --接收服务器
    protocol_func_map_server[46][25] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --第几组
        local var_2_unsigned_char = np:readByte( ) --战队数量
        -- 排行信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_array = {}
        for i = 1, var_2_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_3_array, structObj )
        end
        PacketDispatcher:dispather( 46, 25, var_1_unsigned_char, var_2_unsigned_char, var_3_array )--分发数据
    end

    --争霸赛_返回对战信息
    --接收服务器
    protocol_func_map_server[46][32] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --1地榜，2天榜
        local var_2_char = np:readChar( ) --正在打第几轮--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_string = np:readString( ) --最强战队名称（空字符串为没有）
        local var_4_string = np:readString( ) --最强战队队长名称（空字符串为没有）
        local var_5_string = np:readString( ) --最强战队队员1（空字符串为没有）
        local var_6_string = np:readString( ) --最强战队队员2（空字符串为没有）
        local var_7_int = np:readInt( ) --16强开始时间，0为已结束
        local var_8_int = np:readInt( ) --8强开始时间，0为已结束
        local var_9_int = np:readInt( ) --4强开始时间，0为已结束
        local var_10_int = np:readInt( ) --决赛开始时间，0为已结束
        local var_11_unsigned_char = np:readByte( ) --参赛队伍数量
        -- 参赛队伍信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_12_array = {}
        for i = 1, var_11_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_12_array, structObj )
        end
        local var_13_unsigned_char = np:readByte( ) --比赛数量
        -- 比赛队伍id列表--s本参数存在特殊说明，请查阅协议编辑器
        local var_14_array = {}
        for i = 1, var_13_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_14_array, structObj )
        end
        PacketDispatcher:dispather( 46, 32, var_1_unsigned_char, var_2_char, var_3_string, var_4_string, var_5_string, var_6_string, var_7_int, var_8_int, var_9_int, var_10_int, var_11_unsigned_char, var_12_array, var_13_unsigned_char, var_14_array )--分发数据
    end

    --争霸赛_返回我的下注信息
    --接收服务器
    protocol_func_map_server[46][33] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --1地榜2天榜
        local var_2_unsigned_char = np:readByte( ) --数量
        -- 下注信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_array = {}
        for i = 1, var_2_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_3_array, structObj )
        end
        PacketDispatcher:dispather( 46, 33, var_1_unsigned_char, var_2_unsigned_char, var_3_array )--分发数据
    end

    --争霸赛_战队数据（身价鲜花鸡蛋）
    --接收服务器
    protocol_func_map_server[46][38] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --数据长度
        -- 数据--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 46, 38, var_1_unsigned_char, var_2_array )--分发数据
    end

    --争霸赛_身价更新
    --接收服务器
    protocol_func_map_server[46][47] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --1地榜2天榜
        local var_2_unsigned_char = np:readByte( ) --数据长度
        -- 身价信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_array = {}
        for i = 1, var_2_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_3_array, structObj )
        end
        PacketDispatcher:dispather( 46, 47, var_1_unsigned_char, var_2_unsigned_char, var_3_array )--分发数据
    end

    --发送本服所有战队
    --接收服务器
    protocol_func_map_server[46][48] = function ( np )
        local var_1_int = np:readInt( ) --总共多少页
        local var_2_int = np:readInt( ) --第几页--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_int = np:readInt( ) --该页总共多少个战队
        -- 各个战队信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_4_array = {}
        for i = 1, var_3_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_4_array, structObj )
        end
        PacketDispatcher:dispather( 46, 48, var_1_int, var_2_int, var_3_int, var_4_array )--分发数据
    end

    --发送战队信息
    --接收服务器
    protocol_func_map_server[46][49] = function ( np )
        local var_1_string = np:readString( ) --战队名称
        local var_2_int = np:readInt( ) --队伍成员数
        -- 队伍成员信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_array = {}
        for i = 1, var_2_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_3_array, structObj )
        end
        PacketDispatcher:dispather( 46, 49, var_1_string, var_2_int, var_3_array )--分发数据
    end

    --发送天榜前四名战队信息
    --接收服务器
    protocol_func_map_server[46][53] = function ( np )
        local var_1_int = np:readInt( ) --战队个数
        -- 各个战队信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 46, 53, var_1_int, var_2_array )--分发数据
    end

    --发送历届天榜金仙
    --接收服务器
    protocol_func_map_server[46][54] = function ( np )
        local var_1_int = np:readInt( ) --共多少届
        local var_2_int = np:readInt( ) --第几届--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_int = np:readInt( ) --共多少个战区
        -- 每个战区信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_4_array = {}
        for i = 1, var_3_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_4_array, structObj )
        end
        PacketDispatcher:dispather( 46, 54, var_1_int, var_2_int, var_3_int, var_4_array )--分发数据
    end

