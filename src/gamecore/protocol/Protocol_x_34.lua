    if ( protocol_func_map_server[34] == nil ) then
        protocol_func_map_server[34] = {}
    end



    --初始化-主动下发宠物的列表
    --接收服务器
    protocol_func_map_server[34][1] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --主宠数量
        -- 主宠信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        local var_3_unsigned_char = np:readByte( ) --融合宠最大数量
        local var_4_unsigned_char = np:readByte( ) --已有的融合宠数量
        -- 融合宠信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_5_array = {}
        for i = 1, var_4_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_5_array, structObj )
        end
        PacketDispatcher:dispather( 34, 1, var_1_unsigned_char, var_2_array, var_3_unsigned_char, var_4_unsigned_char, var_5_array )--分发数据
    end

    --宠物属性-发送宠物的属性
    --接收服务器
    protocol_func_map_server[34][5] = function ( np )
        local var_1_int = np:readInt( ) --宠物id
        local var_2_int = np:readInt( ) --变化的属性个数
        -- 属性数据--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_array = {}
        for i = 1, var_2_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_3_array, structObj )
        end
        PacketDispatcher:dispather( 34, 5, var_1_int, var_2_int, var_3_array )--分发数据
    end

    --增加一个主宠
    --接收服务器
    protocol_func_map_server[34][7] = function ( np )
        -- 一连串的int，每个值对应一个属性值，属性顺序见协议1
        -- 数组长度约定，要自己手动填
        local array_length_const = 10
        local var_1_array = {}
        for i = 1, array_length_const do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_1_array, structObj )
        end
        local var_2_string = np:readString( ) --宠物名字
        local var_3_int = np:readInt( ) --主动技能的数量
        -- 主动技能数据--s本参数存在特殊说明，请查阅协议编辑器
        local var_4_array = {}
        for i = 1, var_3_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_4_array, structObj )
        end
        local var_5_int = np:readInt( ) --固定技能的数量
        -- 固定技能数据
        local var_6_array = {}
        for i = 1, var_5_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_6_array, structObj )
        end
        local var_7_int = np:readInt( ) --宠物装备数
        -- 宠物装备--s本参数存在特殊说明，请查阅协议编辑器
        local var_8_array = {}
        for i = 1, var_7_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_8_array, structObj )
        end
        PacketDispatcher:dispather( 34, 7, var_1_array, var_2_string, var_3_int, var_4_array, var_5_int, var_6_array, var_7_int, var_8_array )--分发数据
    end

    --宠物技能-仓库技能列表
    --接收服务器
    protocol_func_map_server[34][20] = function ( np )
        local var_1_int = np:readInt( ) --技能的数量
        -- 数据--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 34, 20, var_1_int, var_2_array )--分发数据
    end

    --唤魂玉刷新结果
    --接收服务器
    protocol_func_map_server[34][21] = function ( np )
        local var_1_int64 = np:readInt64( ) --物品序列号
        local var_2_int = np:readInt( ) --刷的总次数（亮星星用的）
        local var_3_int = np:readInt( ) --格子的数量--s本参数存在特殊说明，请查阅协议编辑器
        -- 每个格子刷出来的技能书--s本参数存在特殊说明，请查阅协议编辑器
        local var_4_array = {}
        for i = 1, var_3_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_4_array, structObj )
        end
        PacketDispatcher:dispather( 34, 21, var_1_int64, var_2_int, var_3_int, var_4_array )--分发数据
    end

    --发送其他玩家的宠物信息
    --接收服务器
    protocol_func_map_server[34][28] = function ( np )
        -- 宠物信息，跟协议1一样的结构--s本参数存在特殊说明，请查阅协议编辑器
        -- protocol manual server 结构体
         local var_1_struct = nil
        --var_1_struct = struct( np )
        PacketDispatcher:dispather( 34, 28, var_1_struct )--分发数据
    end

    --下发宠物激活历史记录
    --接收服务器
    protocol_func_map_server[34][30] = function ( np )
        local var_1_char = np:readChar( ) --拓印是否成功--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_int = np:readInt( ) --数量
        -- 记录列表--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_array = {}
        for i = 1, var_2_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_3_array, structObj )
        end
        PacketDispatcher:dispather( 34, 30, var_1_char, var_2_int, var_3_array )--分发数据
    end

    --发送其他玩家的宠物信息(通过玩家ID获得)
    --接收服务器
    protocol_func_map_server[34][32] = function ( np )
        -- 宠物信息，跟协议1一样的结构
        -- protocol manual server 结构体
         local var_1_struct = nil
        --var_1_struct = struct( np )
        PacketDispatcher:dispather( 34, 32, var_1_struct )--分发数据
    end

    --宠物融合-应答宠物融合
    --接收服务器
    protocol_func_map_server[34][39] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --operType--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_int = np:readInt( ) --MixId，融合宠物Id
        local var_3_int = np:readInt( ) --level，融合后等级
        local var_4_int = np:readInt( ) --fightValue，战斗力
        -- --s本参数存在特殊说明，请查阅协议编辑器
        local var_5_array = {}
        for i = 1, var_4_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_5_array, structObj )
        end
        local var_6_unsigned_char = np:readByte( ) --count，技能数量
        -- 技能信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_7_array = {}
        for i = 1, var_6_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_7_array, structObj )
        end
        PacketDispatcher:dispather( 34, 39, var_1_unsigned_char, var_2_int, var_3_int, var_4_int, var_5_array, var_6_unsigned_char, var_7_array )--分发数据
    end

    --宠物技能-增加技能
    --接收服务器
    protocol_func_map_server[34][42] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --skillType，技能类型--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_unsigned_char = np:readByte( ) --pos，技能位置--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_int = np:readInt( ) --petId，petId为0表示技能仓库
        local var_4_unsigned_char = np:readByte( ) --skillCount，技能数量
        -- 技能信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_5_array = {}
        for i = 1, var_4_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_5_array, structObj )
        end
        PacketDispatcher:dispather( 34, 42, var_1_unsigned_char, var_2_unsigned_char, var_3_int, var_4_unsigned_char, var_5_array )--分发数据
    end

    --宠物进阶-返回下阶属性结果
    --接收服务器
    protocol_func_map_server[34][45] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --isFullStage，是否满阶，1:满阶，0:未满阶--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_int = np:readInt( ) --addValue，战力增量值
        -- 属性增量值--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_array = {}
        for i = 1, var_2_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_3_array, structObj )
        end
        PacketDispatcher:dispather( 34, 45, var_1_unsigned_char, var_2_int, var_3_array )--分发数据
    end

    --初始化-脚本发送的界面初始化信息
    --接收服务器
    protocol_func_map_server[34][47] = function ( np )
        local var_1_int = np:readInt( ) --LingdanNum，已经使用的仙丹数量--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_int = np:readInt( ) --FixedLingdanNum，已使用的灵丹数量--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_int = np:readInt( ) --attachNum，附身丹数量
        local var_4_unsigned_char = np:readByte( ) --count，特殊形象数量
        -- 特殊形象信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_5_array = {}
        for i = 1, var_4_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_5_array, structObj )
        end
        PacketDispatcher:dispather( 34, 47, var_1_int, var_2_int, var_3_int, var_4_unsigned_char, var_5_array )--分发数据
    end

    --预体验-宠物信息
    --接收服务器
    protocol_func_map_server[34][52] = function ( np )
        local var_1_int = np:readInt( ) --stage，预体验宠物阶值
        local var_2_unsigned_char = np:readByte( ) --skillCount，技能数量
        -- skillInfo，技能信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_array = {}
        for i = 1, var_2_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_3_array, structObj )
        end
        PacketDispatcher:dispather( 34, 52, var_1_int, var_2_unsigned_char, var_3_array )--分发数据
    end

