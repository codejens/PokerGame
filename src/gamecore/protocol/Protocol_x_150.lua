    if ( protocol_func_map_server[150] == nil ) then
        protocol_func_map_server[150] = {}
    end



    --下发新年活动信息
    --接收服务器
    protocol_func_map_server[150][1] = function ( np )
        local var_1_int = np:readInt( ) --数组长度
        -- 新年活动时间--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        local var_3_int = np:readInt( ) --控制图标闪烁--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 150, 1, var_1_int, var_2_array, var_3_int )--分发数据
    end

    --获取新年活动连续登陆奖励
    --接收服务器
    protocol_func_map_server[150][3] = function ( np )
        local var_1_int = np:readInt( ) --领取个数
        -- 领取状态--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        local var_3_int = np:readInt( ) --已经连续登陆天数
        PacketDispatcher:dispather( 150, 3, var_1_int, var_2_array, var_3_int )--分发数据
    end

    --拜年活动信息
    --接收服务器
    protocol_func_map_server[150][9] = function ( np )
        local var_1_int = np:readInt( ) --数组长度
        -- 拜年活动--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        local var_3_int = np:readInt( ) --控制图标闪烁--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 150, 9, var_1_int, var_2_array, var_3_int )--分发数据
    end

