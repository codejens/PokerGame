    if ( protocol_func_map_server[19] == nil ) then
        protocol_func_map_server[19] = {}
    end



    --新坐骑-下发玩家自己（或被查看玩家）的坐骑的信息
    --接收服务器
    protocol_func_map_server[19][1] = function ( np )
        local var_1_char = np:readChar( ) --是否已开启坐骑系统，1开启，0未开启，后面的字段就不用读了
        local var_2_int = np:readInt( ) --玩家id
        local var_3_int = np:readInt( ) --坐骑当前阶级
        local var_4_int = np:readInt( ) --评分
        local var_5_int = np:readInt( ) --当前的坐骑外观阶级--s本参数存在特殊说明，请查阅协议编辑器
        local var_6_unsigned_int = np:readUInt( ) --skillCount，玩家已经学习的技能个数
        -- 所有技能信息，共MAX_MOUNTSKILL_NUM，没有技能为0--s本参数存在特殊说明，请查阅协议编辑器
        local var_7_array = {}
        for i = 1, var_6_unsigned_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_7_array, structObj )
        end
        -- 坐骑的5个属性值--s本参数存在特殊说明，请查阅协议编辑器
        local var_8_array = {}
        for i = 1, 5 do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_8_array, structObj )
        end
        local var_9_int = np:readInt( ) --坐骑装备数量
        -- 装备数据,注意这是没有排序的,客户端根据物品的类型区分是头饰还是项链等--s本参数存在特殊说明，请查阅协议编辑器
        local var_10_array = {}
        for i = 1, var_9_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_10_array, structObj )
        end
        PacketDispatcher:dispather( 19, 1, var_1_char, var_2_int, var_3_int, var_4_int, var_5_int, var_6_unsigned_int, var_7_array, var_8_array, var_9_int, var_10_array )--分发数据
    end

    --（已经废弃）基础属性改变，产生这条消息可能：升级，资质改变,装备改变
    --接收服务器
    protocol_func_map_server[19][7] = function ( np )
        -- 5个基础属性值--s本参数存在特殊说明，请查阅协议编辑器
        -- protocol manual server 结构体
         local var_1_struct = nil
        --var_1_struct = struct( np )
        PacketDispatcher:dispather( 19, 7, var_1_struct )--分发数据
    end

    --（评分）改变
    --接收服务器
    protocol_func_map_server[19][3] = function ( np )
        local var_1_int = np:readInt( ) --当前评分
        -- 坐骑的5个int属性值--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 19, 3, var_1_int, var_2_array )--分发数据
    end

    --（已经废弃）下发培养的相关数据
    --接收服务器
    protocol_func_map_server[19][13] = function ( np )
        -- 培养属性的当前值
        -- 数组长度约定，要自己手动填
        local array_length_const = 10
        local var_1_array = {}
        for i = 1, array_length_const do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_1_array, structObj )
        end
        -- 上次培养结果--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_array do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        local var_3_int = np:readInt( ) --上次培养类型
        local var_4_int = np:readInt( ) --免费次数
        PacketDispatcher:dispather( 19, 13, var_1_array, var_2_array, var_3_int, var_4_int )--分发数据
    end

    --新坐骑-学习技能返回
    --接收服务器
    protocol_func_map_server[19][22] = function ( np )
        local var_1_unsigned_short = np:readWord( ) --技能数
        -- 技能信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_unsigned_short do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 19, 22, var_1_unsigned_short, var_2_array )--分发数据
    end

    --初始化-脚本发送的界面初始化信息
    --接收服务器
    protocol_func_map_server[19][24] = function ( np )
        local var_1_int = np:readInt( ) --XiandanNum，已经使用的仙丹数量（原加百分比属性灵丹）
        local var_2_unsigned_char = np:readByte( ) --count, 特殊坐骑的数量
        -- 特殊坐骑信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_array = {}
        for i = 1, var_2_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_3_array, structObj )
        end
        local var_4_int = np:readInt( ) --FixedLingdanNum，已经使用的灵丹数量（现加固定值属性灵丹）
        PacketDispatcher:dispather( 19, 24, var_1_int, var_2_unsigned_char, var_3_array, var_4_int )--分发数据
    end

    --预体验-坐骑信息
    --接收服务器
    protocol_func_map_server[19][28] = function ( np )
        local var_1_int = np:readInt( ) --stage，坐骑阶值
        local var_2_int = np:readInt( ) --modelId，坐骑模型
        local var_3_int = np:readInt( ) --score，坐骑评分
        local var_4_unsigned_char = np:readByte( ) --skillCount，技能数量
        -- skillInfo，技能信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_5_array = {}
        for i = 1, var_4_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_5_array, structObj )
        end
        PacketDispatcher:dispather( 19, 28, var_1_int, var_2_int, var_3_int, var_4_unsigned_char, var_5_array )--分发数据
    end

