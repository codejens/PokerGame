    if ( protocol_func_map_server[159] == nil ) then
        protocol_func_map_server[159] = {}
    end



    --下发玩家登陆奖励领取情况
    --接收服务器
    protocol_func_map_server[159][2] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --已登录天数
        local var_2_unsigned_char = np:readByte( ) --奖励个数
        -- 每个奖励的领取情况--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_array = {}
        for i = 1, var_2_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_3_array, structObj )
        end
        PacketDispatcher:dispather( 159, 2, var_1_unsigned_char, var_2_unsigned_char, var_3_array )--分发数据
    end

    --下发等级排行信息
    --接收服务器
    protocol_func_map_server[159][4] = function ( np )
        -- 前三名玩家信息--s本参数存在特殊说明，请查阅协议编辑器
        -- 数组长度约定，要自己手动填
        local array_length_const = 10
        local var_1_array = {}
        for i = 1, array_length_const do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_1_array, structObj )
        end
        local var_2_unsigned_char = np:readByte( ) --玩家当前排名，0为未上榜
        PacketDispatcher:dispather( 159, 4, var_1_array, var_2_unsigned_char )--分发数据
    end

    --下发战力排行信息
    --接收服务器
    protocol_func_map_server[159][5] = function ( np )
        -- 前三名信息--s本参数存在特殊说明，请查阅协议编辑器
        -- 数组长度约定，要自己手动填
        local array_length_const = 10
        local var_1_array = {}
        for i = 1, array_length_const do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_1_array, structObj )
        end
        local var_2_unsigned_char = np:readByte( ) --玩家当前排名，0为未上榜
        PacketDispatcher:dispather( 159, 5, var_1_array, var_2_unsigned_char )--分发数据
    end

    --下发龙破霸主活动奖励领取情况
    --接收服务器
    protocol_func_map_server[159][6] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --第几个活动
        local var_2_unsigned_char = np:readByte( ) --奖励个数
        -- 奖励领取情况，最后一个都是平民奖励--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_array = {}
        for i = 1, var_2_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_3_array, structObj )
        end
        PacketDispatcher:dispather( 159, 6, var_1_unsigned_char, var_2_unsigned_char, var_3_array )--分发数据
    end

    --下发排行榜数据
    --接收服务器
    protocol_func_map_server[159][8] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --第几个排行榜
        local var_2_unsigned_char = np:readByte( ) --排行榜长度
        -- 排行榜数据--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_array = {}
        for i = 1, var_2_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_3_array, structObj )
        end
        PacketDispatcher:dispather( 159, 8, var_1_unsigned_char, var_2_unsigned_char, var_3_array )--分发数据
    end

    --下发套装奖励领取情况
    --接收服务器
    protocol_func_map_server[159][9] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --奖励类型
        local var_2_unsigned_char = np:readByte( ) --奖励个数
        -- 奖励领取情况--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_array = {}
        for i = 1, var_2_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_3_array, structObj )
        end
        PacketDispatcher:dispather( 159, 9, var_1_unsigned_char, var_2_unsigned_char, var_3_array )--分发数据
    end

    --下发成就达人奖励领取情况
    --接收服务器
    protocol_func_map_server[159][11] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --第几个活动
        local var_2_unsigned_char = np:readByte( ) --奖励个数
        -- 奖励领取情况--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_array = {}
        for i = 1, var_2_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_3_array, structObj )
        end
        PacketDispatcher:dispather( 159, 11, var_1_unsigned_char, var_2_unsigned_char, var_3_array )--分发数据
    end

    --下发玩家帮派奖励领取情况
    --接收服务器
    protocol_func_map_server[159][13] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --几个奖励
        -- 奖励领取情况--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 159, 13, var_1_unsigned_char, var_2_array )--分发数据
    end

    --封测大礼_下发登陆好礼活动信息
    --接收服务器
    protocol_func_map_server[159][16] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --已登录天数
        local var_2_unsigned_char = np:readByte( ) --奖励个数
        -- 每个奖励的领取情况--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_array = {}
        for i = 1, var_2_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_3_array, structObj )
        end
        PacketDispatcher:dispather( 159, 16, var_1_unsigned_char, var_2_unsigned_char, var_3_array )--分发数据
    end

    --封测大礼_下发全民冲级活动信息
    --接收服务器
    protocol_func_map_server[159][17] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --几个奖励
        -- 奖励信息数组--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 159, 17, var_1_unsigned_char, var_2_array )--分发数据
    end

    --封测大礼_登录时下发欢乐转盘获得者名单
    --接收服务器
    protocol_func_map_server[159][19] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --个数
        -- 获得者信息数组--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 159, 19, var_1_unsigned_char, var_2_array )--分发数据
    end

    --封测大礼_登录时下发全民冲级获得者名单
    --接收服务器
    protocol_func_map_server[159][21] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --名单人数
        -- 名单信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 159, 21, var_1_unsigned_char, var_2_array )--分发数据
    end

    --封测大礼_下发活跃好礼活动信息
    --接收服务器
    protocol_func_map_server[159][24] = function ( np )
        local var_1_int = np:readInt( ) --今天总的活跃度
        local var_2_unsigned_char = np:readByte( ) --几个奖励
        -- 奖励信息数组--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_array = {}
        for i = 1, var_2_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_3_array, structObj )
        end
        PacketDispatcher:dispather( 159, 24, var_1_int, var_2_unsigned_char, var_3_array )--分发数据
    end

    --封测大礼_登录时下发活跃好礼获得者名单
    --接收服务器
    protocol_func_map_server[159][26] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --名单人数
        -- 名单信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 159, 26, var_1_unsigned_char, var_2_array )--分发数据
    end

