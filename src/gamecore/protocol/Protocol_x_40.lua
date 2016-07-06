    if ( protocol_func_map_server[40] == nil ) then
        protocol_func_map_server[40] = {}
    end



    --查看自己或其他人的翅膀信息
    --接收服务器
    protocol_func_map_server[40][1] = function ( np )
        local var_1_char = np:readChar( ) --是否已开启系统，1开启，0未开启，后面的字段就不用读了
        local var_2_int = np:readInt( ) --玩家id
        local var_3_int = np:readInt( ) --翅膀等级
        local var_4_int = np:readInt( ) --翅膀几阶
        local var_5_int = np:readInt( ) --祝福值清空倒计时，单位秒
        local var_6_int = np:readInt( ) --评分
        local var_7_int = np:readInt( ) --使用的是几阶的模型
        local var_8_int = np:readInt( ) --祝福值
        local var_9_int = np:readInt( ) --幻羽仙丹剩余使用次数
        local var_10_int = np:readInt( ) --增幅（万分，1000表示10%）
        local var_11_int = np:readInt( ) --灵丹可使用总次数
        local var_12_int = np:readInt( ) --灵丹已使用次数
        -- 8个属性值，是基础值加上进阶属性值--s本参数存在特殊说明，请查阅协议编辑器
        -- protocol manual server 结构体
         local var_13_struct = nil
        --var_13_struct = struct( np )
        local var_14_unsigned_char = np:readByte( ) --固定技能列表长度
        -- 固定技能列表
        local var_15_array = {}
        for i = 1, var_14_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_15_array, structObj )
        end
        local var_16_unsigned_char = np:readByte( ) --翅膀已经装备的技能信息
        -- 技能信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_17_array = {}
        for i = 1, var_16_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_17_array, structObj )
        end
        local var_18_unsigned_char = np:readByte( ) --翅膀装备数量
        -- 翅膀装备，每一个是通用UserItem结构
        local var_19_array = {}
        for i = 1, var_18_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_19_array, structObj )
        end
        PacketDispatcher:dispather( 40, 1, var_1_char, var_2_int, var_3_int, var_4_int, var_5_int, var_6_int, var_7_int, var_8_int, var_9_int, var_10_int, var_11_int, var_12_int, var_13_struct, var_14_unsigned_char, var_15_array, var_16_unsigned_char, var_17_array, var_18_unsigned_char, var_19_array )--分发数据
    end

    --属性改变
    --接收服务器
    protocol_func_map_server[40][5] = function ( np )
        -- 4个基础属性--s本参数存在特殊说明，请查阅协议编辑器
        -- protocol manual server 结构体
         local var_1_struct = nil
        --var_1_struct = struct( np )
        PacketDispatcher:dispather( 40, 5, var_1_struct )--分发数据
    end

    --技能等级改变
    --接收服务器
    protocol_func_map_server[40][7] = function ( np )
        -- 5个技能等级--s本参数存在特殊说明，请查阅协议编辑器
        -- protocol manual server 结构体
         local var_1_struct = nil
        --var_1_struct = struct( np )
        PacketDispatcher:dispather( 40, 7, var_1_struct )--分发数据
    end

    --服务端下发翅膀战力比拼信息
    --接收服务器
    protocol_func_map_server[40][17] = function ( np )
        local var_1_char = np:readChar( ) --是否已开启翅膀系统，1开启，0未开启，后面的字段就不用读了
        local var_2_int = np:readInt( ) --基础战斗力
        local var_3_int = np:readInt( ) --灵丹战斗力
        local var_4_int = np:readInt( ) --仙丹战斗力
        local var_5_int = np:readInt( ) --技能总战力
        local var_6_int = np:readInt( ) --玩家id
        local var_7_int = np:readInt( ) --翅膀几阶
        local var_8_int = np:readInt( ) --评分
        local var_9_int = np:readInt( ) --使用的是几阶的模型
        local var_10_int = np:readInt( ) --幻羽仙丹剩余使用次数
        local var_11_int = np:readInt( ) --增幅（万分，1000表示10%）
        local var_12_int = np:readInt( ) --灵丹可使用总次数
        local var_13_int = np:readInt( ) --灵丹已使用次数
        -- 5个属性值，是基础值加上进阶属性值--s本参数存在特殊说明，请查阅协议编辑器
        -- protocol manual server 结构体
         local var_14_struct = nil
        --var_14_struct = struct( np )
        local var_15_unsigned_char = np:readByte( ) --固定技能列表长度
        -- 固定技能列表--s本参数存在特殊说明，请查阅协议编辑器
        local var_16_array = {}
        for i = 1, var_15_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_16_array, structObj )
        end
        local var_17_unsigned_char = np:readByte( ) --翅膀已经装备的技能信息
        -- 技能信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_18_array = {}
        for i = 1, var_17_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_18_array, structObj )
        end
        PacketDispatcher:dispather( 40, 17, var_1_char, var_2_int, var_3_int, var_4_int, var_5_int, var_6_int, var_7_int, var_8_int, var_9_int, var_10_int, var_11_int, var_12_int, var_13_int, var_14_struct, var_15_unsigned_char, var_16_array, var_17_unsigned_char, var_18_array )--分发数据
    end

    --下发固定技能信息
    --接收服务器
    protocol_func_map_server[40][22] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --固定技能列表长度
        -- 固定技能列表--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 40, 22, var_1_unsigned_char, var_2_array )--分发数据
    end

    --下发翅膀模型信息
    --接收服务器
    protocol_func_map_server[40][23] = function ( np )
        local var_1_int = np:readInt( ) --翅膀模型数量
        -- 翅膀模型id数组--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 40, 23, var_1_int, var_2_array )--分发数据
    end

    --初始化-脚本发送界面初始化信息
    --接收服务器
    protocol_func_map_server[40][25] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --count, 特殊翅膀的数量
        -- 特殊翅膀信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 40, 25, var_1_unsigned_char, var_2_array )--分发数据
    end

