    if ( protocol_func_map_server[33] == nil ) then
        protocol_func_map_server[33] = {}
    end



    --下发法宝界面的仙魂信息
    --接收服务器
    protocol_func_map_server[33][1] = function ( np )
        local var_1_int = np:readInt( ) --开启的槽位的个数
        local var_2_int = np:readInt( ) --仙魂数量
        -- 仙魂列表--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_array = {}
        for i = 1, var_2_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_3_array, structObj )
        end
        PacketDispatcher:dispather( 33, 1, var_1_int, var_2_int, var_3_array )--分发数据
    end

    --下发玩家法宝信息
    --接收服务器
    protocol_func_map_server[33][2] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --出战中的法宝id
        local var_2_int = np:readInt( ) --出战中法宝的技能id
        local var_3_unsigned_char = np:readByte( ) --出战中法宝的技能等级
        local var_4_unsigned_char = np:readByte( ) --幻化中的法宝id
        -- 法宝数组--s本参数存在特殊说明，请查阅协议编辑器
        local var_5_array = {}
        for i = 1, var_4_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_5_array, structObj )
        end
        PacketDispatcher:dispather( 33, 2, var_1_unsigned_char, var_2_int, var_3_unsigned_char, var_4_unsigned_char, var_5_array )--分发数据
    end

    --下发猎魂界面的仙魂信息
    --接收服务器
    protocol_func_map_server[33][3] = function ( np )
        local var_1_int = np:readInt( ) --开启的槽位的个数
        local var_2_int = np:readInt( ) --仙魂数量
        -- 仙魂信息列表--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_array = {}
        for i = 1, var_2_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_3_array, structObj )
        end
        PacketDispatcher:dispather( 33, 3, var_1_int, var_2_int, var_3_array )--分发数据
    end

    --点亮新的炼魂师
    --接收服务器
    protocol_func_map_server[33][4] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --点亮的炼魂师的个数
        -- 点亮炼魂师的id列表--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 33, 4, var_1_unsigned_char, var_2_array )--分发数据
    end

    --删除仙魂
    --接收服务器
    protocol_func_map_server[33][7] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --目的界面--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_unsigned_char = np:readByte( ) --删除类型 1粹取 0非粹取
        local var_3_unsigned_char = np:readByte( ) --仙魂个数
        -- 仙魂列表--s本参数存在特殊说明，请查阅协议编辑器
        local var_4_array = {}
        for i = 1, var_3_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_4_array, structObj )
        end
        PacketDispatcher:dispather( 33, 7, var_1_unsigned_char, var_2_unsigned_char, var_3_unsigned_char, var_4_array )--分发数据
    end

    --发送其他玩家的法宝信息
    --接收服务器
    protocol_func_map_server[33][11] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --是否开启法宝系统 0否1是
        -- 法宝信息--s本参数存在特殊说明，请查阅协议编辑器
        -- protocol manual server 结构体
         local var_2_struct = nil
        --var_2_struct = struct( np )
        -- 法宝界面仙魂信息--s本参数存在特殊说明，请查阅协议编辑器
        -- protocol manual server 结构体
         local var_3_struct = nil
        --var_3_struct = struct( np )
        PacketDispatcher:dispather( 33, 11, var_1_unsigned_char, var_2_struct, var_3_struct )--分发数据
    end

    --服务端下发法宝技能信息
    --接收服务器
    protocol_func_map_server[33][22] = function ( np )
        local var_1_int = np:readInt( ) --法宝技能列表长度
        -- 法宝技能列表--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 33, 22, var_1_int, var_2_array )--分发数据
    end

    --下发仙魂套装信息
    --接收服务器
    protocol_func_map_server[33][23] = function ( np )
        local var_1_int = np:readInt( ) --仙魂套装信息列表长度
        -- --s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 33, 23, var_1_int, var_2_array )--分发数据
    end

    --下发装备信息
    --接收服务器
    protocol_func_map_server[33][29] = function ( np )
        local var_1_int = np:readInt( ) --actorid
        local var_2_int = np:readInt( ) --装备数量
        -- 装备信息数组，类型为标准UserItem结构
        local var_3_array = {}
        for i = 1, var_2_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_3_array, structObj )
        end
        PacketDispatcher:dispather( 33, 29, var_1_int, var_2_int, var_3_array )--分发数据
    end

