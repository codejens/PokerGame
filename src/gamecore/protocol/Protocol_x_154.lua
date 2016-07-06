    if ( protocol_func_map_server[154] == nil ) then
        protocol_func_map_server[154] = {}
    end



    --发送副本招募信息
    --接收服务器
    protocol_func_map_server[154][1] = function ( np )
        local var_1_int = np:readInt( ) --第几个副本--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_int = np:readInt( ) --总页数
        local var_3_int = np:readInt( ) --第几页
        local var_4_int = np:readInt( ) --该页有多少个队伍
        -- 队伍信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_5_array = {}
        for i = 1, var_4_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_5_array, structObj )
        end
        PacketDispatcher:dispather( 154, 1, var_1_int, var_2_int, var_3_int, var_4_int, var_5_array )--分发数据
    end

    --每次有新成员加入的时候都广播一次所有队员的信息
    --接收服务器
    protocol_func_map_server[154][10] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --成员个数
        local var_2_unsigned_char = np:readByte( ) --副本个数
        -- 成员信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_array = {}
        for i = 1, var_2_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_3_array, structObj )
        end
        PacketDispatcher:dispather( 154, 10, var_1_unsigned_char, var_2_unsigned_char, var_3_array )--分发数据
    end

    --新组队-返回玩家.创建副本.或.加入队伍.的结果
    --接收服务器
    protocol_func_map_server[154][15] = function ( np )
        local var_1_int = np:readInt( ) --fbId
        local var_2_unsigned_int = np:readUInt( ) --teamHdl，0:失败，否则是队伍句柄，改句柄用来唯一标识队伍
        local var_3_int = np:readInt( ) --minFightValue，最低战力要求
        local var_4_unsigned_char = np:readByte( ) --autoStart，是否满员且所有玩家都准备后自动开始--s本参数存在特殊说明，请查阅协议编辑器
        local var_5_unsigned_int = np:readUInt( ) --队伍成员人数
        -- 队员信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_6_array = {}
        for i = 1, var_5_unsigned_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_6_array, structObj )
        end
        PacketDispatcher:dispather( 154, 15, var_1_int, var_2_unsigned_int, var_3_int, var_4_unsigned_char, var_5_unsigned_int, var_6_array )--分发数据
    end

    --新组队-服务端返回队伍信息
    --接收服务器
    protocol_func_map_server[154][17] = function ( np )
        local var_1_int = np:readInt( ) --fbId，副本Id
        local var_2_unsigned_int = np:readUInt( ) --count，队伍数量
        -- 队伍信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_array = {}
        for i = 1, var_2_unsigned_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_3_array, structObj )
        end
        PacketDispatcher:dispather( 154, 17, var_1_int, var_2_unsigned_int, var_3_array )--分发数据
    end

    --副本-队伍伤害广播
    --接收服务器
    protocol_func_map_server[154][25] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --数组长度
        -- 伤害统计信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 154, 25, var_1_unsigned_char, var_2_array )--分发数据
    end

    --副本-队伍连击广播
    --接收服务器
    protocol_func_map_server[154][26] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --数组长度
        -- 连击统计信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 154, 26, var_1_unsigned_char, var_2_array )--分发数据
    end

