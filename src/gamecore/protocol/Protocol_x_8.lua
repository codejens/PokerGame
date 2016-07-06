    if ( protocol_func_map_server[8] == nil ) then
        protocol_func_map_server[8] = {}
    end



    --添加物品
    --接收服务器
    protocol_func_map_server[8][2] = function ( np )
        -- UserItem--s本参数存在特殊说明，请查阅协议编辑器
        -- 数组长度约定，要自己手动填
        local array_length_const = 10
        local var_1_array = {}
        for i = 1, array_length_const do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_1_array, structObj )
        end
        PacketDispatcher:dispather( 8, 2, var_1_array )--分发数据
    end

    --初始化玩家的背包物品
    --接收服务器
    protocol_func_map_server[8][4] = function ( np )
        local var_1_unsigned_short = np:readWord( ) --物品的数量
        -- UserItem--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_unsigned_short do 
            -- protocol manual server 数组
            local structObj = UserItem( np )
            structObj:updateSmith( np )
            table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 8, 4, var_1_unsigned_short, var_2_array )--分发数据
    end

    --下发物品的配置
    --接收服务器
    protocol_func_map_server[8][7] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --参数的个数--s本参数存在特殊说明，请查阅协议编辑器
        -- 整形的参数列表--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        local var_3_unsigned_char = np:readByte( ) --获取参数的ID--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 8, 7, var_1_unsigned_char, var_2_array, var_3_unsigned_char )--分发数据
    end

    --物品的数据发生改变了
    --接收服务器
    protocol_func_map_server[8][9] = function ( np )
        -- 数据信息--s本参数存在特殊说明，请查阅协议编辑器
        -- protocol manual server 结构体
         local var_1_struct = nil
        --var_1_struct = struct( np )
        PacketDispatcher:dispather( 8, 9, var_1_struct )--分发数据
    end

    --下发本人可以领取的活动背包的物品列表,只在登陆的时候发
    --接收服务器
    protocol_func_map_server[8][11] = function ( np )
        local var_1_unsigned_short = np:readWord( ) --物品的数量
        local var_2_unsigned_char = np:readByte( ) --BYTE:绑定类型，1：账户绑定，2角色绑定--s本参数存在特殊说明，请查阅协议编辑器
        -- 物品内容--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_array = {}
        for i = 1, var_2_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_3_array, structObj )
        end
        PacketDispatcher:dispather( 8, 11, var_1_unsigned_short, var_2_unsigned_char, var_3_array )--分发数据
    end

    --下发批量洗炼结果
    --接收服务器
    protocol_func_map_server[8][15] = function ( np )
        local var_1_int64 = np:readInt64( ) --装备的GUID
        -- 批量洗炼属性列表--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_int64 do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 8, 15, var_1_int64, var_2_array )--分发数据
    end

    --使用礼包返回奖励信息
    --接收服务器
    protocol_func_map_server[8][17] = function ( np )
        local var_1_int = np:readInt( ) --奖励个数（只发物品类和金钱类的）
        -- 各个奖励的信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 8, 17, var_1_int, var_2_array )--分发数据
    end

    --下发单次洗炼结果
    --接收服务器
    protocol_func_map_server[8][18] = function ( np )
        local var_1_int64 = np:readInt64( ) --装备的GUID
        local var_2_int = np:readInt( ) --激活属性数
        -- 洗炼结果--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_array = {}
        for i = 1, var_2_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_3_array, structObj )
        end
        local var_4_int = np:readInt( ) --洗炼战斗力
        PacketDispatcher:dispather( 8, 18, var_1_int64, var_2_int, var_3_array, var_4_int )--分发数据
    end

    --部位处理的结果
    --接收服务器
    protocol_func_map_server[8][29] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --系统id--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_unsigned_char = np:readByte( ) --部位序号1~4--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_unsigned_char = np:readByte( ) --处理类型--s本参数存在特殊说明，请查阅协议编辑器
        local var_4_unsigned_char = np:readByte( ) --处理的结果--s本参数存在特殊说明，请查阅协议编辑器
        local var_5_string = np:readString( ) --处理结果提示消息
        local var_6_unsigned_char = np:readByte( ) --强化等级
        local var_7_unsigned_short = np:readWord( ) --当前的祝福值
        -- 每个孔的宝石情况（8个）--s本参数存在特殊说明，请查阅协议编辑器
        local var_8_array = {}
        for i = 1, var_7_unsigned_short do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_8_array, structObj )
        end
        PacketDispatcher:dispather( 8, 29, var_1_unsigned_char, var_2_unsigned_char, var_3_unsigned_char, var_4_unsigned_char, var_5_string, var_6_unsigned_char, var_7_unsigned_short, var_8_array )--分发数据
    end

    --登陆时下发所有部位信息
    --接收服务器
    protocol_func_map_server[8][31] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --数组长度
        -- 详细信息（没开启的系统不会下发该系统的数据）--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 8, 31, var_1_unsigned_char, var_2_array )--分发数据
    end

