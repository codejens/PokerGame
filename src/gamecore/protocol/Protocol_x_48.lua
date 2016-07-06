    if ( protocol_func_map_server[48] == nil ) then
        protocol_func_map_server[48] = {}
    end



    --通天塔仓库数据
    --接收服务器
    protocol_func_map_server[48][1] = function ( np )
        local var_1_unsigned_short = np:readWord( ) --物品数量
        -- 物品信息,跟背包系统那些一样的
        local var_2_array = {}
        for i = 1, var_1_unsigned_short do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 48, 1, var_1_unsigned_short, var_2_array )--分发数据
    end

    --通天塔仓库添加道具
    --接收服务器
    protocol_func_map_server[48][3] = function ( np )
        -- 物品信息,跟背包系统那些一样的
        -- 数组长度约定，要自己手动填
        local array_length_const = 10
        local var_1_array = {}
        for i = 1, array_length_const do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_1_array, structObj )
        end
        PacketDispatcher:dispather( 48, 3, var_1_array )--分发数据
    end

    --下发玩家通关信息
    --接收服务器
    protocol_func_map_server[48][5] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --类型，0普通镇妖塔，1英雄镇妖塔
        local var_2_int = np:readInt( ) --玩家是层主的层数
        local var_3_int = np:readInt( ) --玩家通关最高层数
        -- 第一层到最高层最快通关秒数--s本参数存在特殊说明，请查阅协议编辑器
        local var_4_array = {}
        for i = 1, var_3_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_4_array, structObj )
        end
        PacketDispatcher:dispather( 48, 5, var_1_unsigned_char, var_2_int, var_3_int, var_4_array )--分发数据
    end

    --挑战成功
    --接收服务器
    protocol_func_map_server[48][9] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --类型：0:普通镇妖塔 1:英雄镇妖塔
        local var_2_char = np:readChar( ) --1：第一次通关；0之前已通关
        local var_3_int = np:readInt( ) --层主用时
        local var_4_int = np:readInt( ) --玩家用时
        local var_5_int = np:readInt( ) --当前层数
        local var_6_char = np:readChar( ) --0：不是层主；1：成为层主；2：已是层主
        local var_7_int = np:readInt( ) --层主的层数
        local var_8_int = np:readInt( ) --奖励数量
        -- 奖励物品的ID--s本参数存在特殊说明，请查阅协议编辑器
        local var_9_array = {}
        for i = 1, var_8_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_9_array, structObj )
        end
        PacketDispatcher:dispather( 48, 9, var_1_unsigned_char, var_2_char, var_3_int, var_4_int, var_5_int, var_6_char, var_7_int, var_8_int, var_9_array )--分发数据
    end

    --下发所有层主信息
    --接收服务器
    protocol_func_map_server[48][12] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --类型，0普通镇妖塔，1英雄镇妖塔
        local var_2_int = np:readInt( ) --层主数量
        -- 层主信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_array = {}
        for i = 1, var_2_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_3_array, structObj )
        end
        PacketDispatcher:dispather( 48, 12, var_1_unsigned_char, var_2_int, var_3_array )--分发数据
    end

