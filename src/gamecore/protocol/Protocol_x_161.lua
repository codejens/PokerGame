    if ( protocol_func_map_server[161] == nil ) then
        protocol_func_map_server[161] = {}
    end



    --返利大厅.每日首充大团购-应答客户端请求
    --接收服务器
    protocol_func_map_server[161][2] = function ( np )
        local var_1_int = np:readInt( ) --num，首冲的玩家数量
        local var_2_unsigned_char = np:readByte( ) --count，数组成员个数
        -- 领奖状态，奖励顺序由低到高--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_array = {}
        for i = 1, var_2_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_3_array, structObj )
        end
        PacketDispatcher:dispather( 161, 2, var_1_int, var_2_unsigned_char, var_3_array )--分发数据
    end

    --返利大厅.vip团购大返利-应答客户端请求
    --接收服务器
    protocol_func_map_server[161][3] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --count，数组数量
        -- 达成人数--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        -- 玩家奖励状态信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_array = {}
        for i = 1, var_2_array do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_3_array, structObj )
        end
        PacketDispatcher:dispather( 161, 3, var_1_unsigned_char, var_2_array, var_3_array )--分发数据
    end

    --返利大厅.vip等级大回馈-应答客户端请求
    --接收服务器
    protocol_func_map_server[161][4] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --count，数组元素个数
        -- 各奖励状态，奖励级别从前到后--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 161, 4, var_1_unsigned_char, var_2_array )--分发数据
    end

    --（废弃）土豪送礼.强化团购-应答客户端请求
    --接收服务器
    protocol_func_map_server[161][5] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --conditionCount，条件数量
        -- 达成人数数组--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        -- 玩家奖励状态信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_array = {}
        for i = 1, var_2_array do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_3_array, structObj )
        end
        PacketDispatcher:dispather( 161, 5, var_1_unsigned_char, var_2_array, var_3_array )--分发数据
    end

    --返利大厅（循环）.强化进阶-应答客户端请求
    --接收服务器
    protocol_func_map_server[161][9] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --count，数组成员数量
        -- 奖励信息，奖励从低到高
        local var_2_array = {}
        for i = 1, var_1_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 161, 9, var_1_unsigned_char, var_2_array )--分发数据
    end

    --返利大厅.下发可领取奖励数量
    --接收服务器
    protocol_func_map_server[161][12] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --数组长度
        -- 数组--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        local var_3_unsigned_char = np:readByte( ) --总的数量
        PacketDispatcher:dispather( 161, 12, var_1_unsigned_char, var_2_array, var_3_unsigned_char )--分发数据
    end

    --返利大厅.下发充值返利奖励状态
    --接收服务器
    protocol_func_map_server[161][15] = function ( np )
        local var_1_unsigned_int = np:readUInt( ) --累计充值数/当天累计充值
        local var_2_unsigned_char = np:readByte( ) --数组长度
        -- 各等级奖励状态--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_array = {}
        for i = 1, var_2_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_3_array, structObj )
        end
        PacketDispatcher:dispather( 161, 15, var_1_unsigned_int, var_2_unsigned_char, var_3_array )--分发数据
    end

    --返利大厅.下发充值返利奖励数量
    --接收服务器
    protocol_func_map_server[161][16] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --数组长度
        -- 各等级数量--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 161, 16, var_1_unsigned_char, var_2_array )--分发数据
    end

    --返利大厅.下发全民冲级奖励状态
    --接收服务器
    protocol_func_map_server[161][18] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --数组长度
        -- 各等级奖励状态--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 161, 18, var_1_unsigned_char, var_2_array )--分发数据
    end

    --返利大厅.下发全民冲级奖励数量
    --接收服务器
    protocol_func_map_server[161][19] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --数组长度
        -- 各等级数量--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 161, 19, var_1_unsigned_char, var_2_array )--分发数据
    end

    --返利大厅.下发新服超惠剩余数量
    --接收服务器
    protocol_func_map_server[161][32] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --数组长度
        -- 各物品的剩余数量--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 161, 32, var_1_unsigned_char, var_2_array )--分发数据
    end

    --返利大厅.下发龙鳞大兑换剩余数量
    --接收服务器
    protocol_func_map_server[161][34] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --数组长度
        -- 剩余数量--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 161, 34, var_1_unsigned_char, var_2_array )--分发数据
    end

    --返利大厅.下发宝石排行榜
    --接收服务器
    protocol_func_map_server[161][36] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --排行榜的长度
        -- 排行榜--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 161, 36, var_1_unsigned_char, var_2_array )--分发数据
    end

    --返利大厅.下发强化排行榜
    --接收服务器
    protocol_func_map_server[161][39] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --排行榜的长度
        -- 排行榜--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 161, 39, var_1_unsigned_char, var_2_array )--分发数据
    end

    --问鼎龙破.下发boss争霸排行榜信息
    --接收服务器
    protocol_func_map_server[161][42] = function ( np )
        local var_1_int = np:readInt( ) --排行列表长度
        -- 排行列表--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 161, 42, var_1_int, var_2_array )--分发数据
    end

    --问鼎龙破.下发帮派争霸排行榜信息
    --接收服务器
    protocol_func_map_server[161][45] = function ( np )
        local var_1_int = np:readInt( ) --排行榜列表长度
        -- 排行榜列表--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 161, 45, var_1_int, var_2_array )--分发数据
    end

    --问鼎龙破.下发双阵营信息
    --接收服务器
    protocol_func_map_server[161][47] = function ( np )
        local var_1_int = np:readInt( ) --前几名列表长度
        -- 前几名列表--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        local var_3_int = np:readInt( ) --我的排名
        local var_4_int = np:readInt( ) --我的积分
        local var_5_unsigned_char = np:readByte( ) --全民礼包，0表示不可领取，1表示可领取，2表示已领取
        PacketDispatcher:dispather( 161, 47, var_1_int, var_2_array, var_3_int, var_4_int, var_5_unsigned_char )--分发数据
    end

    --问鼎龙破.下发双阵营排行榜信息
    --接收服务器
    protocol_func_map_server[161][48] = function ( np )
        local var_1_int = np:readInt( ) --排行榜列表长度
        -- 排行榜列表--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 161, 48, var_1_int, var_2_array )--分发数据
    end

    --问鼎龙破.下发战神争霸信息
    --接收服务器
    protocol_func_map_server[161][59] = function ( np )
        local var_1_int = np:readInt( ) --前几名列表长度
        -- 前几名列表--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        local var_3_int = np:readInt( ) --我的排名
        local var_4_int = np:readInt( ) --我的积分
        local var_5_int = np:readInt( ) --平均排名
        local var_6_unsigned_char = np:readByte( ) --全民礼包，0表示不可领取，1表示可领取，2表示已领取
        PacketDispatcher:dispather( 161, 59, var_1_int, var_2_array, var_3_int, var_4_int, var_5_int, var_6_unsigned_char )--分发数据
    end

    --返利大厅（循环）.下发坐骑进阶信息
    --接收服务器
    protocol_func_map_server[161][75] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --列表长度
        -- 礼包列表--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 161, 75, var_1_unsigned_char, var_2_array )--分发数据
    end

    --返利大厅（循环）.下发宠物进阶信息
    --接收服务器
    protocol_func_map_server[161][77] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --列表长度
        -- 礼包列表--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 161, 77, var_1_unsigned_char, var_2_array )--分发数据
    end

    --返利大厅（循环）.下发翅膀进阶信息
    --接收服务器
    protocol_func_map_server[161][79] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --列表长度
        -- 礼包列表--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 161, 79, var_1_unsigned_char, var_2_array )--分发数据
    end

    --返利大厅（循环）.下发法宝进阶信息
    --接收服务器
    protocol_func_map_server[161][81] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --列表长度
        -- 礼包列表--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 161, 81, var_1_unsigned_char, var_2_array )--分发数据
    end

    --返利大厅.下发每日目标大赠送达成信息
    --接收服务器
    protocol_func_map_server[161][90] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --数组长度
        -- 数组--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 161, 90, var_1_unsigned_char, var_2_array )--分发数据
    end

    --返利大厅.下发神秘大奖信息
    --接收服务器
    protocol_func_map_server[161][91] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --数组数量。
        -- --s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 161, 91, var_1_unsigned_char, var_2_array )--分发数据
    end

    --返利大厅（循环）.下发充值返利奖励状态
    --接收服务器
    protocol_func_map_server[161][101] = function ( np )
        local var_1_unsigned_int = np:readUInt( ) --累计充值数/当天累计充值
        local var_2_unsigned_char = np:readByte( ) --数组长度
        -- 各等级奖励状态--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_array = {}
        for i = 1, var_2_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_3_array, structObj )
        end
        PacketDispatcher:dispather( 161, 101, var_1_unsigned_int, var_2_unsigned_char, var_3_array )--分发数据
    end

    --返利大厅（循环）.下发充值返利奖励数量
    --接收服务器
    protocol_func_map_server[161][102] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --数组长度
        -- 各等级数量--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 161, 102, var_1_unsigned_char, var_2_array )--分发数据
    end

    --返利大厅（循环）.下发新服超惠剩余数量
    --接收服务器
    protocol_func_map_server[161][103] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --数组长度
        -- 各物品的剩余数量--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 161, 103, var_1_unsigned_char, var_2_array )--分发数据
    end

    --返利大厅（循环）.下发强化排行榜
    --接收服务器
    protocol_func_map_server[161][115] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --排行榜的长度
        -- 排行榜--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 161, 115, var_1_unsigned_char, var_2_array )--分发数据
    end

    --返利大厅.首冲团购（循环）-应答客户端请求
    --接收服务器
    protocol_func_map_server[161][117] = function ( np )
        local var_1_int = np:readInt( ) --num，首冲的玩家数量
        local var_2_unsigned_char = np:readByte( ) --count，数组成员个数
        -- 领奖状态，奖励顺序由低到高--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_array = {}
        for i = 1, var_2_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_3_array, structObj )
        end
        PacketDispatcher:dispather( 161, 117, var_1_int, var_2_unsigned_char, var_3_array )--分发数据
    end

    --每日抽奖-下发抽奖记录
    --接收服务器
    protocol_func_map_server[161][122] = function ( np )
        local var_1_int = np:readInt( ) --抽奖记录列表长度
        -- 抽奖记录列表--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 161, 122, var_1_int, var_2_array )--分发数据
    end

    --返利大厅（循环）.下发神兵进阶信息
    --接收服务器
    protocol_func_map_server[161][135] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --列表长度
        -- 礼包列表--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 161, 135, var_1_unsigned_char, var_2_array )--分发数据
    end

    --问鼎龙破-服务端返回领地争霸排行信息
    --接收服务器
    protocol_func_map_server[161][141] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --第几次
        local var_2_int = np:readInt( ) --排行榜长度
        -- 排行榜--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_array = {}
        for i = 1, var_2_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_3_array, structObj )
        end
        PacketDispatcher:dispather( 161, 141, var_1_unsigned_char, var_2_int, var_3_array )--分发数据
    end

    --返利大厅（循环）.下发法阵进阶信息
    --接收服务器
    protocol_func_map_server[161][151] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --列表长度
        -- 礼包列表--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 161, 151, var_1_unsigned_char, var_2_array )--分发数据
    end

    --返利大厅（循环）.下发战灵进阶信息
    --接收服务器
    protocol_func_map_server[161][155] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --列表长度
        -- 礼包列表--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 161, 155, var_1_unsigned_char, var_2_array )--分发数据
    end

    --返利大厅（循环）.下发影迹进阶信息
    --接收服务器
    protocol_func_map_server[161][171] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --列表长度
        -- 礼包列表--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 161, 171, var_1_unsigned_char, var_2_array )--分发数据
    end

    --返利大厅（循环）.下发神户进阶信息
    --接收服务器
    protocol_func_map_server[161][183] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --列表长度
        -- 礼包列表--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 161, 183, var_1_unsigned_char, var_2_array )--分发数据
    end

