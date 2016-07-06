    if ( protocol_func_map_server[255] == nil ) then
        protocol_func_map_server[255] = {}
    end



    --查询角色列表
    --接收服务器
    protocol_func_map_server[255][4] = function ( np )
        local var_1_int = np:readInt( ) --账户id
        local var_2_char = np:readChar( ) --如果是负数，表示是错误码，否则表示角色的数量
        -- 角色的数据--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_array = {}
        if var_2_char < 0 then
            print("查询角色列表出错",var_2_char)
        end
        for i = 1, var_2_char do 
            -- protocol manual server 数组
            local structObj = UserRole( np )
            table.insert( var_3_array, structObj )
        end
        local var_4_unsigned_char = np:readByte( ) --默认选中哪个角色
        local var_5_unsigned_char = np:readByte( ) --最少人选的职业
        local var_6_unsigned_short = np:readWord( ) --可选的阵营列表
        PacketDispatcher:dispather( 255, 4, var_1_int, var_2_char, var_3_array, var_4_unsigned_char, var_5_unsigned_char, var_6_unsigned_short )--分发数据
    end

