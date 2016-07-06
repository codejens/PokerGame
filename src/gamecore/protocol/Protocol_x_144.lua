    if ( protocol_func_map_server[144] == nil ) then
        protocol_func_map_server[144] = {}
    end



    --发送消息列表
    --接收服务器
    protocol_func_map_server[144][1] = function ( np )
        local var_1_int = np:readInt( ) --消息条数
        -- 消息结构体列表--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 144, 1, var_1_int, var_2_array )--分发数据
    end

    --发送地主苦工系统数据
    --接收服务器
    protocol_func_map_server[144][2] = function ( np )
        local var_1_int = np:readInt( ) --系统开关状态--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_int = np:readInt( ) --系统开启等级下限
        local var_3_int = np:readInt( ) --身份状态--s本参数存在特殊说明，请查阅协议编辑器
        local var_4_int = np:readInt( ) --今天剩下抓捕或掠夺次数
        local var_5_int = np:readInt( ) --抓捕/掠夺次数上限
        local var_6_int = np:readInt( ) --今日剩下互动次数
        local var_7_int = np:readInt( ) --互动次数上限
        local var_8_int = np:readInt( ) --今天剩下反抗/求救次数
        local var_9_int = np:readInt( ) --反抗/求救次数上限
        local var_10_int = np:readInt( ) --今日已获得经验
        local var_11_int = np:readInt( ) --今天剩下解救次数
        local var_12_int = np:readInt( ) --解救次数上限
        local var_13_int = np:readInt( ) --下一次增加抓捕次数需要的元宝数--s本参数存在特殊说明，请查阅协议编辑器
        local var_14_int = np:readInt( ) --已发出的请求个数
        -- 已经发出的求救列表--s本参数存在特殊说明，请查阅协议编辑器
        local var_15_array = {}
        for i = 1, var_14_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_15_array, structObj )
        end
        -- 主人信息--s本参数存在特殊说明，请查阅协议编辑器
        -- protocol manual server 结构体
         local var_16_struct = nil
        --var_16_struct = struct( np )
        PacketDispatcher:dispather( 144, 2, var_1_int, var_2_int, var_3_int, var_4_int, var_5_int, var_6_int, var_7_int, var_8_int, var_9_int, var_10_int, var_11_int, var_12_int, var_13_int, var_14_int, var_15_array, var_16_struct )--分发数据
    end

    --发送手下败将列表
    --接收服务器
    protocol_func_map_server[144][3] = function ( np )
        local var_1_int = np:readInt( ) --败将个数
        -- 败将列表--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 144, 3, var_1_int, var_2_array )--分发数据
    end

    --发送夺仆之敌列表
    --接收服务器
    protocol_func_map_server[144][4] = function ( np )
        local var_1_int = np:readInt( ) --夺仆之敌个数
        -- 夺仆之敌列表--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 144, 4, var_1_int, var_2_array )--分发数据
    end

    --发送苦工列表
    --接收服务器
    protocol_func_map_server[144][5] = function ( np )
        local var_1_int = np:readInt( ) --苦工个数
        -- 苦工列表--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 144, 5, var_1_int, var_2_array )--分发数据
    end

    --发送我可解救的苦工列表
    --接收服务器
    protocol_func_map_server[144][6] = function ( np )
        local var_1_int = np:readInt( ) --求救信息个数
        -- 求救信息列表--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 144, 6, var_1_int, var_2_array )--分发数据
    end

    --发送可解救我的同帮派玩家列表
    --接收服务器
    protocol_func_map_server[144][17] = function ( np )
        local var_1_int = np:readInt( ) --列表长度
        -- 玩家列表--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 144, 17, var_1_int, var_2_array )--分发数据
    end

    --通知前端此玩家已经有主人
    --接收服务器
    protocol_func_map_server[144][19] = function ( np )
        local var_1_int = np:readInt( ) --消息ID--s本参数存在特殊说明，请查阅协议编辑器
        -- 对方的数据--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        -- 对方地主的数据--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_array = {}
        for i = 1, var_2_array do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_3_array, structObj )
        end
        PacketDispatcher:dispather( 144, 19, var_1_int, var_2_array, var_3_array )--分发数据
    end

