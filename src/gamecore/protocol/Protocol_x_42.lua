    if ( protocol_func_map_server[42] == nil ) then
        protocol_func_map_server[42] = {}
    end



    --发送仓库物品列表
    --接收服务器
    protocol_func_map_server[42][1] = function ( np )
        local var_1_unsigned_short = np:readWord( ) --物品数量
        -- 物品信息，跟背包系统那些一样
        local var_2_array = {}
        for i = 1, var_1_unsigned_short do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 42, 1, var_1_unsigned_short, var_2_array )--分发数据
    end

    --添加物品到仓库
    --接收服务器
    protocol_func_map_server[42][3] = function ( np )
        -- 物品的结果
        -- 数组长度约定，要自己手动填
        local array_length_const = 10
        local var_1_array = {}
        for i = 1, array_length_const do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_1_array, structObj )
        end
        PacketDispatcher:dispather( 42, 3, var_1_array )--分发数据
    end

