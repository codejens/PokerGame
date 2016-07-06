    if ( protocol_func_map_server[142] == nil ) then
        protocol_func_map_server[142] = {}
    end



    --下发20个梦境物品,对应消息号1，除非到整点刷新，服务器会主动下发
    --接收服务器
    protocol_func_map_server[142][1] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --梦境类型--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_unsigned_char = np:readByte( ) --数量
        -- 物品列表--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_array = {}
        for i = 1, var_2_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_3_array, structObj )
        end
        PacketDispatcher:dispather( 142, 1, var_1_unsigned_char, var_2_unsigned_char, var_3_array )--分发数据
    end

    --获取仓库列表
    --接收服务器
    protocol_func_map_server[142][4] = function ( np )
        local var_1_unsigned_short = np:readWord( ) --物品数量
        -- 物品信息,跟背包系统那些一样的--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_unsigned_short do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 142, 4, var_1_unsigned_short, var_2_array )--分发数据
    end

    --下发盗梦日志
    --接收服务器
    protocol_func_map_server[142][6] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --类型，1：本人，2：全服
        local var_2_unsigned_char = np:readByte( ) --增加还是初始化--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_unsigned_short = np:readWord( ) --数量--s本参数存在特殊说明，请查阅协议编辑器
        -- 内容--s本参数存在特殊说明，请查阅协议编辑器
        local var_4_array = {}
        for i = 1, var_3_unsigned_short do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_4_array, structObj )
        end
        PacketDispatcher:dispather( 142, 6, var_1_unsigned_char, var_2_unsigned_char, var_3_unsigned_short, var_4_array )--分发数据
    end

    --下发相关配置的信息
    --接收服务器
    protocol_func_map_server[142][8] = function ( np )
        -- 每个盗梦需要的元宝，共3个int值--s本参数存在特殊说明，请查阅协议编辑器
        -- 数组长度约定，要自己手动填
        local array_length_const = 10
        local var_1_array = {}
        for i = 1, array_length_const do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_1_array, structObj )
        end
        -- 每个梦阶需要的点数--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_array do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 142, 8, var_1_array, var_2_array )--分发数据
    end

