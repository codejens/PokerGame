    if ( protocol_func_map_server[17] == nil ) then
        protocol_func_map_server[17] = {}
    end



    --下发邀请双修
    --接收服务器
    protocol_func_map_server[17][2] = function ( np )
        -- 邀请人的基本信息--s本参数存在特殊说明，请查阅协议编辑器
        -- protocol manual server 结构体
         local var_1_struct = nil
        --var_1_struct = struct( np )
        PacketDispatcher:dispather( 17, 2, var_1_struct )--分发数据
    end

    --返回可以邀请的玩家列表
    --接收服务器
    protocol_func_map_server[17][4] = function ( np )
        local var_1_unsigned_short = np:readWord( ) --数量
        -- 玩家信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_unsigned_short do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 17, 4, var_1_unsigned_short, var_2_array )--分发数据
    end

