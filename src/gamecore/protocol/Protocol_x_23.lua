    if ( protocol_func_map_server[23] == nil ) then
        protocol_func_map_server[23] = {}
    end



    --下发仓库的物品列表
    --接收服务器
    protocol_func_map_server[23][1] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --物品的数量
        -- CUserItem--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 23, 1, var_1_unsigned_char, var_2_array )--分发数据
    end

    --添加物品
    --接收服务器
    protocol_func_map_server[23][2] = function ( np )
        -- CUserItem
        -- protocol manual server 结构体
         local var_1_struct = nil
        --var_1_struct = struct( np )
        PacketDispatcher:dispather( 23, 2, var_1_struct )--分发数据
    end

