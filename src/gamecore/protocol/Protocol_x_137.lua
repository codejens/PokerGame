    if ( protocol_func_map_server[137] == nil ) then
        protocol_func_map_server[137] = {}
    end



    --下发技压群雄奖励领取信息
    --接收服务器
    protocol_func_map_server[137][1] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --奖励个数
        -- 奖励可领取情况--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 137, 1, var_1_unsigned_char, var_2_array )--分发数据
    end

    --下发技压群雄技能点亮情况
    --接收服务器
    protocol_func_map_server[137][2] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --技能类型，1宠物技能，2坐骑技能，3翅膀技能
        local var_2_unsigned_char = np:readByte( ) --页数
        -- 每页技能图标数据--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_array = {}
        for i = 1, var_2_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_3_array, structObj )
        end
        PacketDispatcher:dispather( 137, 2, var_1_unsigned_char, var_2_unsigned_char, var_3_array )--分发数据
    end

