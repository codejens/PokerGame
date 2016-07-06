    if ( protocol_func_map_server[138] == nil ) then
        protocol_func_map_server[138] = {}
    end



    --通知客户端一次在线奖励
    --接收服务器
    protocol_func_map_server[138][1] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --将领取第几次奖励
        local var_2_unsigned_int = np:readUInt( ) --到下次奖励的剩余时间--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_int = np:readInt( ) --剩余领奖次数
        local var_4_int = np:readInt( ) --奖励个数
        -- 各个奖励信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_5_array = {}
        for i = 1, var_4_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_5_array, structObj )
        end
        PacketDispatcher:dispather( 138, 1, var_1_unsigned_char, var_2_unsigned_int, var_3_int, var_4_int, var_5_array )--分发数据
    end

    --返回连续登陆领奖列表
    --接收服务器
    protocol_func_map_server[138][6] = function ( np )
        local var_1_int = np:readInt( ) --连续领奖物品数目
        -- 连续领奖物品--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        local var_3_int = np:readInt( ) --vip连续领奖物品数目
        -- vip连续领奖物品--s本参数存在特殊说明，请查阅协议编辑器
        local var_4_array = {}
        for i = 1, var_3_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_4_array, structObj )
        end
        PacketDispatcher:dispather( 138, 6, var_1_int, var_2_array, var_3_int, var_4_array )--分发数据
    end

    --连续登陆显示当前物品
    --接收服务器
    protocol_func_map_server[138][12] = function ( np )
        local var_1_int = np:readInt( ) --你已连续登陆多少天
        local var_2_int = np:readInt( ) --普通玩家领奖状态个数
        -- 普通玩家领奖状态--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_array = {}
        for i = 1, var_2_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_3_array, structObj )
        end
        local var_4_int = np:readInt( ) --VIP玩家领奖状态个数
        -- VIP玩家领奖状态--s本参数存在特殊说明，请查阅协议编辑器
        local var_5_array = {}
        for i = 1, var_4_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_5_array, structObj )
        end
        PacketDispatcher:dispather( 138, 12, var_1_int, var_2_int, var_3_array, var_4_int, var_5_array )--分发数据
    end

    --下发排行榜活动的数据
    --接收服务器
    protocol_func_map_server[138][19] = function ( np )
        local var_1_int = np:readInt( ) --是否有奖励可以领取--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_int = np:readInt( ) --排行榜id
        -- 数据，固定10项数据--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_array = {}
        for i = 1, var_2_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_3_array, structObj )
        end
        PacketDispatcher:dispather( 138, 19, var_1_int, var_2_int, var_3_array )--分发数据
    end

    --领取万圣节奖励返回结果（同领取在线奖励结果）
    --接收服务器
    protocol_func_map_server[138][34] = function ( np )
        local var_1_int = np:readInt( ) --奖励个数
        -- 各个奖励信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 138, 34, var_1_int, var_2_array )--分发数据
    end

    --发送密友系统奖励列表
    --接收服务器
    protocol_func_map_server[138][38] = function ( np )
        local var_1_int = np:readInt( ) --连续登陆天数
        local var_2_int = np:readInt( ) --赠送信息个数
        -- 各个赠送信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_array = {}
        for i = 1, var_2_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_3_array, structObj )
        end
        local var_4_int = np:readInt( ) --领取信息个数
        -- 各个领取信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_5_array = {}
        for i = 1, var_4_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_5_array, structObj )
        end
        PacketDispatcher:dispather( 138, 38, var_1_int, var_2_int, var_3_array, var_4_int, var_5_array )--分发数据
    end

    --发送大厅连续登陆信息
    --接收服务器
    protocol_func_map_server[138][44] = function ( np )
        local var_1_int = np:readInt( ) --连续登陆多少天
        local var_2_int = np:readInt( ) --奖励领取状态信息个数
        -- 各个奖励领取状态信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_array = {}
        for i = 1, var_2_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_3_array, structObj )
        end
        PacketDispatcher:dispather( 138, 44, var_1_int, var_2_int, var_3_array )--分发数据
    end

    --发送邀请好友和分享信息
    --接收服务器
    protocol_func_map_server[138][48] = function ( np )
        local var_1_int = np:readInt( ) --抽奖次数
        local var_2_int = np:readInt( ) --邀请好友状态信息数量
        -- 邀请好友信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_array = {}
        for i = 1, var_2_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_3_array, structObj )
        end
        local var_4_int = np:readInt( ) --分享信息数量
        -- 分享状态信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_5_array = {}
        for i = 1, var_4_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_5_array, structObj )
        end
        PacketDispatcher:dispather( 138, 48, var_1_int, var_2_int, var_3_array, var_4_int, var_5_array )--分发数据
    end

    --获取圣诞活动奖励情况
    --接收服务器
    protocol_func_map_server[138][54] = function ( np )
        local var_1_int = np:readInt( ) --剩余感恩币的数量
        local var_2_int = np:readInt( ) --充值或续费的次数
        local var_3_int = np:readInt( ) --奖励个数
        -- --s本参数存在特殊说明，请查阅协议编辑器
        local var_4_array = {}
        for i = 1, var_3_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_4_array, structObj )
        end
        PacketDispatcher:dispather( 138, 54, var_1_int, var_2_int, var_3_int, var_4_array )--分发数据
    end

    --打开宝盒抽奖界面（已废）
    --接收服务器
    protocol_func_map_server[138][62] = function ( np )
        local var_1_int64 = np:readInt64( ) --宝盒物品的GUID
        -- 10个物品ID--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_int64 do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        local var_3_int = np:readInt( ) --抽中的物品ID
        PacketDispatcher:dispather( 138, 62, var_1_int64, var_2_array, var_3_int )--分发数据
    end

    --发送3366连续登陆信息
    --接收服务器
    protocol_func_map_server[138][65] = function ( np )
        local var_1_int = np:readInt( ) --连续登陆多少天
        local var_2_int = np:readInt( ) --奖励领取状态信息个数
        -- 各个奖励领取状态信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_array = {}
        for i = 1, var_2_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_3_array, structObj )
        end
        PacketDispatcher:dispather( 138, 65, var_1_int, var_2_int, var_3_array )--分发数据
    end

    --获取感恩节奖励情况
    --接收服务器
    protocol_func_map_server[138][71] = function ( np )
        local var_1_int = np:readInt( ) --充值或续费的次数
        local var_2_int = np:readInt( ) --奖励个数
        -- --s本参数存在特殊说明，请查阅协议编辑器
        local var_3_array = {}
        for i = 1, var_2_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_3_array, structObj )
        end
        PacketDispatcher:dispather( 138, 71, var_1_int, var_2_int, var_3_array )--分发数据
    end

    --七日成王礼包购买情况
    --接收服务器
    protocol_func_map_server[138][93] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --当前是活动第几天，超过7天且免费礼包已兑换的话关闭页图标
        -- 礼包A的购买情况--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        -- 礼包B的购买情况，同上
        local var_3_array = {}
        for i = 1, var_2_array do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_3_array, structObj )
        end
        PacketDispatcher:dispather( 138, 93, var_1_unsigned_char, var_2_array, var_3_array )--分发数据
    end

    --下发七天连续登陆奖励信息
    --接收服务器
    protocol_func_map_server[138][94] = function ( np )
        -- 数据，固定7项数据，int型--s本参数存在特殊说明，请查阅协议编辑器
        -- 数组长度约定，要自己手动填
        local array_length_const = 10
        local var_1_array = {}
        for i = 1, array_length_const do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_1_array, structObj )
        end
        PacketDispatcher:dispather( 138, 94, var_1_array )--分发数据
    end

    --下发新充值礼包领取信息
    --接收服务器
    protocol_func_map_server[138][97] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --是否可以领取重复礼包
        local var_2_unsigned_char = np:readByte( ) --新老服配置，1表示老服， 2表示新服
        local var_3_unsigned_char = np:readByte( ) --是否可以领取重复礼包，0表示不能领，1表示可以领取
        local var_4_int = np:readInt( ) --累计充值元宝数
        local var_5_unsigned_char = np:readByte( ) --最大可以领取什么级别的礼包
        local var_6_unsigned_char = np:readByte( ) --礼包数量
        -- 礼包领取情况数组--s本参数存在特殊说明，请查阅协议编辑器
        local var_7_array = {}
        for i = 1, var_6_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_7_array, structObj )
        end
        local var_8_int = np:readInt( ) --剩余时间
        PacketDispatcher:dispather( 138, 97, var_1_unsigned_char, var_2_unsigned_char, var_3_unsigned_char, var_4_int, var_5_unsigned_char, var_6_unsigned_char, var_7_array, var_8_int )--分发数据
    end

    --下发玩家某一好礼活动奖励领取情况
    --接收服务器
    protocol_func_map_server[138][100] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --活动类型，1-6
        local var_2_unsigned_char = np:readByte( ) --奖励个数
        -- 奖励领取情况数组--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_array = {}
        for i = 1, var_2_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_3_array, structObj )
        end
        PacketDispatcher:dispather( 138, 100, var_1_unsigned_char, var_2_unsigned_char, var_3_array )--分发数据
    end

    --每日优惠-当天奖励领取情况
    --接收服务器
    protocol_func_map_server[138][103] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --开服第几天
        local var_2_int = np:readInt( ) --当天活动剩余时间
        local var_3_unsigned_char = np:readByte( ) --奖励个数
        -- 奖励领取情况--s本参数存在特殊说明，请查阅协议编辑器
        local var_4_array = {}
        for i = 1, var_3_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_4_array, structObj )
        end
        PacketDispatcher:dispather( 138, 103, var_1_unsigned_char, var_2_int, var_3_unsigned_char, var_4_array )--分发数据
    end

    --累积登录：下发累积登录奖励信息
    --接收服务器
    protocol_func_map_server[138][108] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --活动期间的累积登录天数
        -- 奖励的领取状态, 1表示已经领取，0表示未领取--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 138, 108, var_1_unsigned_char, var_2_array )--分发数据
    end

    --新年花恋：发送奖励信息
    --接收服务器
    protocol_func_map_server[138][110] = function ( np )
        -- 奖励状态，0表示不能领取，1表示可以领取，2已经领取--s本参数存在特殊说明，请查阅协议编辑器
        -- 数组长度约定，要自己手动填
        local array_length_const = 10
        local var_1_array = {}
        for i = 1, array_length_const do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_1_array, structObj )
        end
        PacketDispatcher:dispather( 138, 110, var_1_array )--分发数据
    end

    --下发充值返利活动奖励信息
    --接收服务器
    protocol_func_map_server[138][111] = function ( np )
        local var_1_int = np:readInt( ) --累积充值元宝数
        local var_2_unsigned_char = np:readByte( ) --最大可领取什么级别的礼包
        local var_3_unsigned_char = np:readByte( ) --礼包档次数量
        -- 每个档次礼包的领取状态--s本参数存在特殊说明，请查阅协议编辑器
        local var_4_array = {}
        for i = 1, var_3_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_4_array, structObj )
        end
        local var_5_int = np:readInt( ) --活动剩余时间
        PacketDispatcher:dispather( 138, 111, var_1_int, var_2_unsigned_char, var_3_unsigned_char, var_4_array, var_5_int )--分发数据
    end

    --（废弃）下发合服首冲奖励状态
    --接收服务器
    protocol_func_map_server[138][113] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --玩家是否进行了合服首充，1表示进行了首充，其他表示没有
        local var_2_unsigned_char = np:readByte( ) --活动的第几天， 编号从1开始
        local var_3_unsigned_char = np:readByte( ) --奖励的个数
        -- 奖励的领取状态--s本参数存在特殊说明，请查阅协议编辑器
        local var_4_array = {}
        for i = 1, var_3_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_4_array, structObj )
        end
        PacketDispatcher:dispather( 138, 113, var_1_unsigned_char, var_2_unsigned_char, var_3_unsigned_char, var_4_array )--分发数据
    end

    --（废弃）下发合服活动提升好礼活动奖励信息
    --接收服务器
    protocol_func_map_server[138][115] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --活动类型， 编号为1 - 7--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_unsigned_char = np:readByte( ) --某种类型奖励的个数
        -- 奖励的状态--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_array = {}
        for i = 1, var_2_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_3_array, structObj )
        end
        PacketDispatcher:dispather( 138, 115, var_1_unsigned_char, var_2_unsigned_char, var_3_array )--分发数据
    end

    --下发秘籍累积充值活动信息
    --接收服务器
    protocol_func_map_server[138][147] = function ( np )
        local var_1_int = np:readInt( ) --当前充值数
        local var_2_char = np:readChar( ) --奖励项数量
        -- --s本参数存在特殊说明，请查阅协议编辑器
        local var_3_array = {}
        for i = 1, var_2_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_3_array, structObj )
        end
        local var_4_int = np:readInt( ) --活动剩余时间--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 138, 147, var_1_int, var_2_char, var_3_array, var_4_int )--分发数据
    end

    --下发元宵节累积登录奖励状态
    --接收服务器
    protocol_func_map_server[138][156] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --累积登录的天数
        -- 奖励的状态--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 138, 156, var_1_unsigned_char, var_2_array )--分发数据
    end

    --下发元宵节每周魅力排行榜
    --接收服务器
    protocol_func_map_server[138][157] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --奖励个数
        -- 排行榜信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 138, 157, var_1_unsigned_char, var_2_array )--分发数据
    end

    --下发当天购买信息
    --接收服务器
    protocol_func_map_server[138][158] = function ( np )
        -- 剩余购买次数--s本参数存在特殊说明，请查阅协议编辑器
        -- 数组长度约定，要自己手动填
        local array_length_const = 10
        local var_1_array = {}
        for i = 1, array_length_const do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_1_array, structObj )
        end
        PacketDispatcher:dispather( 138, 158, var_1_array )--分发数据
    end

    --下发消费元宝开启礼包消息
    --接收服务器
    protocol_func_map_server[138][160] = function ( np )
        local var_1_unsigned_int = np:readUInt( ) --礼包ID
        local var_2_unsigned_int = np:readUInt( ) --开启礼包的价格
        local var_3_unsigned_int = np:readUInt( ) --数组的长度,礼包里面有多少种物品
        -- 礼包物品信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_4_array = {}
        for i = 1, var_3_unsigned_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_4_array, structObj )
        end
        PacketDispatcher:dispather( 138, 160, var_1_unsigned_int, var_2_unsigned_int, var_3_unsigned_int, var_4_array )--分发数据
    end

    --龙破新版在线奖励-下发在线奖励信息
    --接收服务器
    protocol_func_map_server[138][161] = function ( np )
        local var_1_int = np:readInt( ) --今日累积在线时间
        local var_2_unsigned_int = np:readUInt( ) --礼包列表长度
        -- 礼包列表--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_array = {}
        for i = 1, var_2_unsigned_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_3_array, structObj )
        end
        local var_4_int = np:readInt( ) --总在线时长
        PacketDispatcher:dispather( 138, 161, var_1_int, var_2_unsigned_int, var_3_array, var_4_int )--分发数据
    end

    --服务端下发冲级礼包信息
    --接收服务器
    protocol_func_map_server[138][166] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --是否消失，0消失，1不消失
        local var_2_int = np:readInt( ) --冲级礼包列表长度
        -- 冲级礼包列表--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_array = {}
        for i = 1, var_2_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_3_array, structObj )
        end
        PacketDispatcher:dispather( 138, 166, var_1_unsigned_char, var_2_int, var_3_array )--分发数据
    end

    --服务端下发兑换礼包信息
    --接收服务器
    protocol_func_map_server[138][169] = function ( np )
        local var_1_int = np:readInt( ) --礼包列表长度
        -- 礼包列表--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 138, 169, var_1_int, var_2_array )--分发数据
    end

    --龙破新版在线奖励-下发抽取结果
    --接收服务器
    protocol_func_map_server[138][162] = function ( np )
        local var_1_int = np:readInt( ) --数组长度
        -- 抽取数组长度--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 138, 162, var_1_int, var_2_array )--分发数据
    end

