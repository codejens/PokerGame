    if ( protocol_func_map_server[10] == nil ) then
        protocol_func_map_server[10] = {}
    end



    --下发帮派成员列表
    --接收服务器
    protocol_func_map_server[10][2] = function ( np )
        local var_1_int = np:readInt( ) --在线成员数量
        local var_2_int = np:readInt( ) --不在线成员数量
        -- 成员信息，根据上面的数量来判断是否在线和不在线--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_array = {}
        for i = 1, var_2_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_3_array, structObj )
        end
        PacketDispatcher:dispather( 10, 2, var_1_int, var_2_int, var_3_array )--分发数据
    end

    --下发帮派信息列表
    --接收服务器
    protocol_func_map_server[10][3] = function ( np )
        local var_1_int = np:readInt( ) --本次下发的个数
        local var_2_int = np:readInt( ) --当前第几页，从0开始
        local var_3_int = np:readInt( ) --一共多少页
        -- 数据内容--s本参数存在特殊说明，请查阅协议编辑器
        local var_4_array = {}
        for i = 1, var_3_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_4_array, structObj )
        end
        PacketDispatcher:dispather( 10, 3, var_1_int, var_2_int, var_3_int, var_4_array )--分发数据
    end

    --显示申请加入帮派的消息列表
    --接收服务器
    protocol_func_map_server[10][11] = function ( np )
        local var_1_int = np:readInt( ) --个数
        -- 数据--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 10, 11, var_1_int, var_2_array )--分发数据
    end

    --下发仙宗仓库物品列表
    --接收服务器
    protocol_func_map_server[10][27] = function ( np )
        local var_1_int = np:readInt( ) --物品数量
        -- 物品列表--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 10, 27, var_1_int, var_2_array )--分发数据
    end

    --仙宗仓库增加一个物品
    --接收服务器
    protocol_func_map_server[10][28] = function ( np )
        -- useritem
        -- protocol manual server 结构体
         local var_1_struct = nil
        --var_1_struct = struct( np )
        PacketDispatcher:dispather( 10, 28, var_1_struct )--分发数据
    end

    --发送献果，抚摸事件日志
    --接收服务器
    protocol_func_map_server[10][35] = function ( np )
        local var_1_int = np:readInt( ) --日志数量
        -- 每条日志信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 10, 35, var_1_int, var_2_array )--分发数据
    end

    --发送仙宗事件记录
    --接收服务器
    protocol_func_map_server[10][41] = function ( np )
        local var_1_int = np:readInt( ) --事件数量
        -- 每条仙宗事件记录--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 10, 41, var_1_int, var_2_array )--分发数据
    end

    --下发帮派技能数据
    --接收服务器
    protocol_func_map_server[10][48] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --技能个数
        -- 帮派技能数组--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 10, 48, var_1_unsigned_char, var_2_array )--分发数据
    end

    --下发申请帮派仓库物品的消息列表
    --接收服务器
    protocol_func_map_server[10][52] = function ( np )
        local var_1_int = np:readInt( ) --消息数量
        -- 数组--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 10, 52, var_1_int, var_2_array )--分发数据
    end

    --下发仓库物品状态
    --接收服务器
    protocol_func_map_server[10][54] = function ( np )
        local var_1_int = np:readInt( ) --数组数量
        -- 物品状态数组--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 10, 54, var_1_int, var_2_array )--分发数据
    end

    --夺宝_下发宝箱信息
    --接收服务器
    protocol_func_map_server[10][55] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --宝箱类型数量
        -- 宝箱类型数据--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        local var_3_unsigned_int = np:readUInt( ) --宝箱数量
        -- 宝箱信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_4_array = {}
        for i = 1, var_3_unsigned_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_4_array, structObj )
        end
        PacketDispatcher:dispather( 10, 55, var_1_unsigned_char, var_2_array, var_3_unsigned_int, var_4_array )--分发数据
    end

