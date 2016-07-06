    if ( protocol_func_map_server[172] == nil ) then
        protocol_func_map_server[172] = {}
    end



    --双阵型_刷新积分排行榜
    --接收服务器
    protocol_func_map_server[172][4] = function ( np )
        local var_1_int = np:readInt( ) --数组长度
        -- 积分排行榜--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 172, 4, var_1_int, var_2_array )--分发数据
    end

    --双阵型_下发结果面板信息
    --接收服务器
    protocol_func_map_server[172][6] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --胜负标志：1表示胜利，0表示失败
        local var_2_int = np:readInt( ) --数组长度
        -- 面板信息数组--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_array = {}
        for i = 1, var_2_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_3_array, structObj )
        end
        local var_4_int = np:readInt( ) --玩家自己排名
        PacketDispatcher:dispather( 172, 6, var_1_unsigned_char, var_2_int, var_3_array, var_4_int )--分发数据
    end

    --下发帮战击杀排行榜
    --接收服务器
    protocol_func_map_server[172][10] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --排行榜人数
        -- 排行榜数据--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 172, 10, var_1_unsigned_char, var_2_array )--分发数据
    end

    --下发铜钱副本排行榜信息
    --接收服务器
    protocol_func_map_server[172][12] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --返回的第几页的信息
        local var_2_unsigned_char = np:readByte( ) --整个排行榜总共的信息数
        local var_3_unsigned_char = np:readByte( ) --返回的当前页的信息数
        local var_4_int = np:readInt( ) --请求者所在的排名
        -- 具体详细信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_5_array = {}
        for i = 1, var_4_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_5_array, structObj )
        end
        local var_6_int = np:readInt( ) --请求者的积分
        local var_7_int = np:readInt( ) --请求者的最大连击数
        PacketDispatcher:dispather( 172, 12, var_1_unsigned_char, var_2_unsigned_char, var_3_unsigned_char, var_4_int, var_5_array, var_6_int, var_7_int )--分发数据
    end

    --经验副本-下发宝箱领取信息
    --接收服务器
    protocol_func_map_server[172][21] = function ( np )
        local var_1_int = np:readInt( ) --数组长度--s本参数存在特殊说明，请查阅协议编辑器
        -- 宝箱信息数组--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 172, 21, var_1_int, var_2_array )--分发数据
    end

    --幽灵魔域-应答请求排行榜信息
    --接收服务器
    protocol_func_map_server[172][26] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --排行榜信息数量
        -- 排行榜信息-排名由前到后--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 172, 26, var_1_unsigned_char, var_2_array )--分发数据
    end

    --下发诸天战神排行榜统计
    --接收服务器
    protocol_func_map_server[172][29] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --排行榜类型，1总击杀排行榜，2连续击杀排行榜
        local var_2_unsigned_char = np:readByte( ) --排行榜人数
        -- 排行榜信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_array = {}
        for i = 1, var_2_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_3_array, structObj )
        end
        PacketDispatcher:dispather( 172, 29, var_1_unsigned_char, var_2_unsigned_char, var_3_array )--分发数据
    end

    --下发上届诸天战神排行榜信息
    --接收服务器
    protocol_func_map_server[172][31] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --第几阶段 1，2，3
        local var_2_unsigned_char = np:readByte( ) --排行榜类型
        local var_3_unsigned_char = np:readByte( ) --第几页
        local var_4_unsigned_char = np:readByte( ) --总共有几页
        local var_5_unsigned_char = np:readByte( ) --此页数量
        -- 排行榜信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_6_array = {}
        for i = 1, var_5_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_6_array, structObj )
        end
        local var_7_unsigned_char = np:readByte( ) --我的排名，0为未上榜
        local var_8_unsigned_char = np:readByte( ) --是否领取过此排行类型奖励
        PacketDispatcher:dispather( 172, 31, var_1_unsigned_char, var_2_unsigned_char, var_3_unsigned_char, var_4_unsigned_char, var_5_unsigned_char, var_6_array, var_7_unsigned_char, var_8_unsigned_char )--分发数据
    end

    --下发玩家的封印守护副本相关状态
    --接收服务器
    protocol_func_map_server[172][38] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --今日剩余可重置次数
        local var_2_unsigned_char = np:readByte( ) --今日可重置次数
        local var_3_unsigned_short = np:readWord( ) --当前已通关数
        local var_4_unsigned_short = np:readWord( ) --历史最大通关数
        local var_5_unsigned_char = np:readByte( ) --宝箱总数
        -- 各个宝箱的领取状态（宝箱序号从1开始）--s本参数存在特殊说明，请查阅协议编辑器
        local var_6_array = {}
        for i = 1, var_5_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_6_array, structObj )
        end
        PacketDispatcher:dispather( 172, 38, var_1_unsigned_char, var_2_unsigned_char, var_3_unsigned_short, var_4_unsigned_short, var_5_unsigned_char, var_6_array )--分发数据
    end

    --下发领地占领情况
    --接收服务器
    protocol_func_map_server[172][41] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --领地数量
        -- 占领信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 172, 41, var_1_unsigned_char, var_2_array )--分发数据
    end

    --下发大闹天宫副本情况
    --接收服务器
    protocol_func_map_server[172][46] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --可进入次数
        -- 副本情况--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 172, 46, var_1_unsigned_char, var_2_array )--分发数据
    end

    --下发屠龙副本信息
    --接收服务器
    protocol_func_map_server[172][47] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --副本个数
        -- 每个副本情况--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        local var_3_unsigned_char = np:readByte( ) --当前扫荡状态，0未扫荡，1扫荡中，2扫荡奖励可领取，3已扫荡
        local var_4_int = np:readInt( ) --扫荡剩余时间
        PacketDispatcher:dispather( 172, 47, var_1_unsigned_char, var_2_array, var_3_unsigned_char, var_4_int )--分发数据
    end

    --下发扫荡奖励
    --接收服务器
    protocol_func_map_server[172][49] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --副本个数
        -- 副本扫荡奖励信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 172, 49, var_1_unsigned_char, var_2_array )--分发数据
    end

    --下发真仙之路各层人数
    --接收服务器
    protocol_func_map_server[172][54] = function ( np )
        -- 20层每层人数，类型为short
        -- 数组长度约定，要自己手动填
        local array_length_const = 10
        local var_1_array = {}
        for i = 1, array_length_const do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_1_array, structObj )
        end
        local var_2_unsigned_char = np:readByte( ) --顶层宝箱数量
        PacketDispatcher:dispather( 172, 54, var_1_array, var_2_unsigned_char )--分发数据
    end

    --下发仙路战报
    --接收服务器
    protocol_func_map_server[172][56] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --总页数
        local var_2_unsigned_char = np:readByte( ) --第几页
        local var_3_unsigned_char = np:readByte( ) --此页数量
        -- 排名信息数组--s本参数存在特殊说明，请查阅协议编辑器
        local var_4_array = {}
        for i = 1, var_3_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_4_array, structObj )
        end
        local var_5_unsigned_char = np:readByte( ) --我的排名，0为不在排名内
        local var_6_unsigned_char = np:readByte( ) --是否可以领取奖励，1是0否
        local var_7_string = np:readString( ) --上次修罗真仙玩家名
        local var_8_int = np:readInt( ) --上次修罗真仙玩家ID
        PacketDispatcher:dispather( 172, 56, var_1_unsigned_char, var_2_unsigned_char, var_3_unsigned_char, var_4_array, var_5_unsigned_char, var_6_unsigned_char, var_7_string, var_8_int )--分发数据
    end

    --下发帮战击杀排行榜
    --接收服务器
    protocol_func_map_server[172][62] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --排行榜人数
        -- 排行榜数据--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 172, 62, var_1_unsigned_char, var_2_array )--分发数据
    end

    --下发夫妻副本排行榜信息
    --接收服务器
    protocol_func_map_server[172][73] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --第几页
        local var_2_unsigned_char = np:readByte( ) --总共多少页
        local var_3_unsigned_char = np:readByte( ) --此页数量
        -- 排行榜信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_4_array = {}
        for i = 1, var_3_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_4_array, structObj )
        end
        local var_5_int = np:readInt( ) --我的排名，0为未上榜
        PacketDispatcher:dispather( 172, 73, var_1_unsigned_char, var_2_unsigned_char, var_3_unsigned_char, var_4_array, var_5_int )--分发数据
    end

    --下发精英副本界面信息
    --接收服务器
    protocol_func_map_server[172][77] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --数组数量
        -- 副本信息数组--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 172, 77, var_1_unsigned_char, var_2_array )--分发数据
    end

    --精英副本通关
    --接收服务器
    protocol_func_map_server[172][79] = function ( np )
        local var_1_int = np:readInt( ) --副本id--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_unsigned_char = np:readByte( ) --副本难度--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_int = np:readInt( ) --获得弑神值
        local var_4_unsigned_char = np:readByte( ) --奖励数量
        -- 奖励数组--s本参数存在特殊说明，请查阅协议编辑器
        local var_5_array = {}
        for i = 1, var_4_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_5_array, structObj )
        end
        PacketDispatcher:dispather( 172, 79, var_1_int, var_2_unsigned_char, var_3_int, var_4_unsigned_char, var_5_array )--分发数据
    end

