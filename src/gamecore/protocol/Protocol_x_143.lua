    if ( protocol_func_map_server[143] == nil ) then
        protocol_func_map_server[143] = {}
    end



    --发送消息列表
    --接收服务器
    protocol_func_map_server[143][1] = function ( np )
        local var_1_int = np:readInt( ) --消息条数
        -- 消息结构体列表--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 143, 1, var_1_int, var_2_array )--分发数据
    end

    --发送手下败将列表
    --接收服务器
    protocol_func_map_server[143][3] = function ( np )
        local var_1_int = np:readInt( ) --败将个数
        -- 败将列表--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 143, 3, var_1_int, var_2_array )--分发数据
    end

    --发送夺仆之敌列表
    --接收服务器
    protocol_func_map_server[143][4] = function ( np )
        local var_1_int = np:readInt( ) --夺仆之敌个数
        -- 夺仆之敌列表--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 143, 4, var_1_int, var_2_array )--分发数据
    end

    --发送苦工列表
    --接收服务器
    protocol_func_map_server[143][5] = function ( np )
        local var_1_int = np:readInt( ) --苦工个数
        -- 苦工列表--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 143, 5, var_1_int, var_2_array )--分发数据
    end

    --发送求救列表
    --接收服务器
    protocol_func_map_server[143][6] = function ( np )
        local var_1_int = np:readInt( ) --求救信息个数
        -- 求救信息列表--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 143, 6, var_1_int, var_2_array )--分发数据
    end

