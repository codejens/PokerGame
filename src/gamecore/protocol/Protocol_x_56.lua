    if ( protocol_func_map_server[56] == nil ) then
        protocol_func_map_server[56] = {}
    end



    --返回精炼的结果
    --接收服务器
    protocol_func_map_server[56][1] = function ( np )
        local var_1_char = np:readChar( ) --精炼是否成功的标识--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_unsigned_char = np:readByte( ) --是否在装备面板--s本参数存在特殊说明，请查阅协议编辑器
        -- 神魄信息--s本参数存在特殊说明，请查阅协议编辑器
        -- protocol manual server 结构体
         local var_3_struct = nil
        --var_3_struct = struct( np )
        PacketDispatcher:dispather( 56, 1, var_1_char, var_2_unsigned_char, var_3_struct )--分发数据
    end

    --烙神进阶结果
    --接收服务器
    protocol_func_map_server[56][2] = function ( np )
        local var_1_char = np:readChar( ) --进阶成功与否的标识--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_unsigned_char = np:readByte( ) --是否装备的标识--s本参数存在特殊说明，请查阅协议编辑器
        -- 神魄信息--s本参数存在特殊说明，请查阅协议编辑器
        -- protocol manual server 结构体
         local var_3_struct = nil
        --var_3_struct = struct( np )
        PacketDispatcher:dispather( 56, 2, var_1_char, var_2_unsigned_char, var_3_struct )--分发数据
    end

    --封灵升级结果返回
    --接收服务器
    protocol_func_map_server[56][3] = function ( np )
        local var_1_char = np:readChar( ) --升级成功与否的标识
        local var_2_unsigned_char = np:readByte( ) --是否装备的标识--s本参数存在特殊说明，请查阅协议编辑器
        -- 神魄信息--s本参数存在特殊说明，请查阅协议编辑器
        -- protocol manual server 结构体
         local var_3_struct = nil
        --var_3_struct = struct( np )
        PacketDispatcher:dispather( 56, 3, var_1_char, var_2_unsigned_char, var_3_struct )--分发数据
    end

    --发送玩家的神魄信息
    --接收服务器
    protocol_func_map_server[56][4] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --已经装备的神魄个数
        -- 神魄信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        local var_3_unsigned_char = np:readByte( ) --背包中神魄的个数
        -- 背包中神魄的信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_4_array = {}
        for i = 1, var_3_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_4_array, structObj )
        end
        PacketDispatcher:dispather( 56, 4, var_1_unsigned_char, var_2_array, var_3_unsigned_char, var_4_array )--分发数据
    end

    --兑换或者卸载背包添加一个新神魄
    --接收服务器
    protocol_func_map_server[56][5] = function ( np )
        -- 神魄信息--s本参数存在特殊说明，请查阅协议编辑器
        -- protocol manual server 结构体
         local var_1_struct = nil
        --var_1_struct = struct( np )
        PacketDispatcher:dispather( 56, 5, var_1_struct )--分发数据
    end

    --装备或移动后的神魄信息
    --接收服务器
    protocol_func_map_server[56][6] = function ( np )
        -- 如果装备成功那么返回神魄的信息(通过标识判断是装备还是移动)--s本参数存在特殊说明，请查阅协议编辑器
        -- protocol manual server 结构体
         local var_1_struct = nil
        --var_1_struct = struct( np )
        PacketDispatcher:dispather( 56, 6, var_1_struct )--分发数据
    end

