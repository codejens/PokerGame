    if ( protocol_func_map_server[171] == nil ) then
        protocol_func_map_server[171] = {}
    end



    --下发翻牌活动的数据
    --接收服务器
    protocol_func_map_server[171][2] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --今天剩余的翻牌次数
        local var_2_unsigned_char = np:readByte( ) --翻牌活动当前的操作状态--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_unsigned_char = np:readByte( ) --牌信息的数组长度大小（在这里恒为7）
        -- 牌信息数组--s本参数存在特殊说明，请查阅协议编辑器
        local var_4_array = {}
        for i = 1, var_3_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_4_array, structObj )
        end
        PacketDispatcher:dispather( 171, 2, var_1_unsigned_char, var_2_unsigned_char, var_3_unsigned_char, var_4_array )--分发数据
    end

    --下发百服超值返还信息
    --接收服务器
    protocol_func_map_server[171][10] = function ( np )
        local var_1_int = np:readInt( ) --usedyuanbao--s本参数存在特殊说明，请查阅协议编辑器
        -- giftarray--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 171, 10, var_1_int, var_2_array )--分发数据
    end

    --下发全服消费返利玩家全服消费礼包信息
    --接收服务器
    protocol_func_map_server[171][14] = function ( np )
        -- 玩家全服消费礼包列表信息--s本参数存在特殊说明，请查阅协议编辑器
        -- 数组长度约定，要自己手动填
        local array_length_const = 10
        local var_1_array = {}
        for i = 1, array_length_const do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_1_array, structObj )
        end
        PacketDispatcher:dispather( 171, 14, var_1_array )--分发数据
    end

    --下发玩家个人神秘商店信息
    --接收服务器
    protocol_func_map_server[171][16] = function ( np )
        local var_1_int = np:readInt( ) --今日剩余免费次数
        local var_2_int = np:readInt( ) --当前幸运值
        local var_3_int = np:readInt( ) --幸运值清空倒计时
        local var_4_int = np:readInt( ) --祝福值
        local var_5_int = np:readInt( ) --物品列表数组长度
        -- 物品列表--s本参数存在特殊说明，请查阅协议编辑器
        local var_6_array = {}
        for i = 1, var_5_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_6_array, structObj )
        end
        PacketDispatcher:dispather( 171, 16, var_1_int, var_2_int, var_3_int, var_4_int, var_5_int, var_6_array )--分发数据
    end

    --下发初始化幸运玩家列表
    --接收服务器
    protocol_func_map_server[171][17] = function ( np )
        local var_1_int = np:readInt( ) --幸运玩家列表长度
        -- 幸运玩家列表--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 171, 17, var_1_int, var_2_array )--分发数据
    end

    --下发全服消费返利个人消费信息
    --接收服务器
    protocol_func_map_server[171][12] = function ( np )
        local var_1_int = np:readInt( ) --全服个人消费最高的元宝
        local var_2_int = np:readInt( ) --全服个人消费可领取最大礼包
        -- 消费最高的玩家信息--s本参数存在特殊说明，请查阅协议编辑器
        -- protocol manual server 结构体
         local var_3_struct = nil
        --var_3_struct = struct( np )
        PacketDispatcher:dispather( 171, 12, var_1_int, var_2_int, var_3_struct )--分发数据
    end

    --下发全服消费返利玩家个人消费礼包信息
    --接收服务器
    protocol_func_map_server[171][15] = function ( np )
        -- 玩家个人消费礼包列表信息--s本参数存在特殊说明，请查阅协议编辑器
        -- 数组长度约定，要自己手动填
        local array_length_const = 10
        local var_1_array = {}
        for i = 1, array_length_const do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_1_array, structObj )
        end
        PacketDispatcher:dispather( 171, 15, var_1_array )--分发数据
    end

    --下发全服充值返利个人充值信息
    --接收服务器
    protocol_func_map_server[171][22] = function ( np )
        local var_1_int = np:readInt( ) --全服个人充值最高元宝
        local var_2_int = np:readInt( ) --全服个人充值可领取最大礼包
        -- 充值最高玩家信息--s本参数存在特殊说明，请查阅协议编辑器
        -- protocol manual server 结构体
         local var_3_struct = nil
        --var_3_struct = struct( np )
        PacketDispatcher:dispather( 171, 22, var_1_int, var_2_int, var_3_struct )--分发数据
    end

    --下发全服消费返利玩家全服充值礼包信息
    --接收服务器
    protocol_func_map_server[171][24] = function ( np )
        local var_1_int = np:readInt( ) --礼包数组长度
        -- 玩家全服充值礼包信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 171, 24, var_1_int, var_2_array )--分发数据
    end

    --下发全服充值返利玩家个人充值礼包信息
    --接收服务器
    protocol_func_map_server[171][25] = function ( np )
        local var_1_int = np:readInt( ) --礼包数组长度
        -- 玩家个人充值礼包信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 171, 25, var_1_int, var_2_array )--分发数据
    end

    --下发充值排行榜信息
    --接收服务器
    protocol_func_map_server[171][26] = function ( np )
        local var_1_int = np:readInt( ) --排行榜列表长度
        -- 排行榜信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 171, 26, var_1_int, var_2_array )--分发数据
    end

    --下发玩家年货购买情况
    --接收服务器
    protocol_func_map_server[171][28] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --年货数量
        -- 年货数组--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 171, 28, var_1_unsigned_char, var_2_array )--分发数据
    end

    --下发捕鱼活动数据
    --接收服务器
    protocol_func_map_server[171][32] = function ( np )
        local var_1_char = np:readChar( ) --当天剩余抽奖次数
        local var_2_char = np:readChar( ) --剩余的鱼的数目
        -- 剩余的鱼的种类--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_array = {}
        for i = 1, var_2_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_3_array, structObj )
        end
        PacketDispatcher:dispather( 171, 32, var_1_char, var_2_char, var_3_array )--分发数据
    end

    --神马都有.下发充值礼包信息
    --接收服务器
    protocol_func_map_server[171][44] = function ( np )
        local var_1_int = np:readInt( ) --已充值元宝
        local var_2_int = np:readInt( ) --礼包列表长度
        -- 礼包列表信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_array = {}
        for i = 1, var_2_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_3_array, structObj )
        end
        PacketDispatcher:dispather( 171, 44, var_1_int, var_2_int, var_3_array )--分发数据
    end

    --神马都有.下发马上有钱礼包信息
    --接收服务器
    protocol_func_map_server[171][46] = function ( np )
        local var_1_int = np:readInt( ) --礼包列表长度
        -- 礼包列表--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 171, 46, var_1_int, var_2_array )--分发数据
    end

    --极限名人堂-下发击杀BOSS和帮派战排行信息
    --接收服务器
    protocol_func_map_server[171][56] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --第几天，从1开始
        local var_2_unsigned_char = np:readByte( ) --count, 数组中元素的个数
        -- 排行榜数组信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_array = {}
        for i = 1, var_2_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_3_array, structObj )
        end
        PacketDispatcher:dispather( 171, 56, var_1_unsigned_char, var_2_unsigned_char, var_3_array )--分发数据
    end

    --活动大厅-下发帮派战信息
    --接收服务器
    protocol_func_map_server[171][58] = function ( np )
        local var_1_unsigned_int = np:readUInt( ) --城主占领时间，单位秒
        local var_2_string = np:readString( ) --城主帮派名称
        local var_3_string = np:readString( ) --城主名称
        local var_4_unsigned_int = np:readUInt( ) --城主模型Id
        local var_5_unsigned_int = np:readUInt( ) --城主龙魂特效ID
        local var_6_unsigned_char = np:readByte( ) --isOpen，帮派战是否正在进行，1:进行，0:未进行
        local var_7_unsigned_char = np:readByte( ) --count, 护城将军的数量
        -- 护城将军信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_8_array = {}
        for i = 1, var_7_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_8_array, structObj )
        end
        PacketDispatcher:dispather( 171, 58, var_1_unsigned_int, var_2_string, var_3_string, var_4_unsigned_int, var_5_unsigned_int, var_6_unsigned_char, var_7_unsigned_char, var_8_array )--分发数据
    end

    --趣味答题_下发题目
    --接收服务器
    protocol_func_map_server[171][60] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --第几个题目
        local var_2_string = np:readString( ) --题目内容
        local var_3_unsigned_char = np:readByte( ) --答案的个数
        -- 答案数组--s本参数存在特殊说明，请查阅协议编辑器
        local var_4_array = {}
        for i = 1, var_3_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_4_array, structObj )
        end
        local var_5_unsigned_int = np:readUInt( ) --剩余读题时间（秒）
        PacketDispatcher:dispather( 171, 60, var_1_unsigned_char, var_2_string, var_3_unsigned_char, var_4_array, var_5_unsigned_int )--分发数据
    end

    --渡劫_弹出一键扫荡奖励领取倒计时窗口
    --接收服务器
    protocol_func_map_server[171][72] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --必定得到的奖励的数组长度
        -- 必定得到的奖励的数组--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        local var_3_unsigned_char = np:readByte( ) --概率得到的奖励的数组长度
        -- 概率得到的奖励的数组--s本参数存在特殊说明，请查阅协议编辑器
        local var_4_array = {}
        for i = 1, var_3_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_4_array, structObj )
        end
        PacketDispatcher:dispather( 171, 72, var_1_unsigned_char, var_2_array, var_3_unsigned_char, var_4_array )--分发数据
    end

    --全民富翁-应答客户端请求
    --接收服务器
    protocol_func_map_server[171][73] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --count
        -- 幸运奖，一到五等奖品剩余数量--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        local var_3_unsigned_char = np:readByte( ) --count
        -- 玩家获得礼包信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_4_array = {}
        for i = 1, var_3_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_4_array, structObj )
        end
        PacketDispatcher:dispather( 171, 73, var_1_unsigned_char, var_2_array, var_3_unsigned_char, var_4_array )--分发数据
    end

    --全民富翁-下发特等奖玩家信息
    --接收服务器
    protocol_func_map_server[171][76] = function ( np )
        local var_1_int = np:readInt( ) --actorId
        local var_2_string = np:readString( ) --actorName
        local var_3_unsigned_char = np:readByte( ) --骰子的个数
        -- 骰子的各个值--s本参数存在特殊说明，请查阅协议编辑器
        local var_4_array = {}
        for i = 1, var_3_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_4_array, structObj )
        end
        PacketDispatcher:dispather( 171, 76, var_1_int, var_2_string, var_3_unsigned_char, var_4_array )--分发数据
    end

    --全民富翁-应答客户端摇骰子
    --接收服务器
    protocol_func_map_server[171][80] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --count，骰子的数量
        -- 每个骰子的值--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 171, 80, var_1_unsigned_char, var_2_array )--分发数据
    end

    --我要变强-下发消息提示
    --接收服务器
    protocol_func_map_server[171][82] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --type，前端和后端商量此字段意义--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_char = np:readChar( ) --count，参数数组的个数--s本参数存在特殊说明，请查阅协议编辑器
        -- int值数组，表示不同的参数
        local var_3_array = {}
        for i = 1, var_2_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_3_array, structObj )
        end
        PacketDispatcher:dispather( 171, 82, var_1_unsigned_char, var_2_char, var_3_array )--分发数据
    end

    --下发世界boss伤害奖励信息
    --接收服务器
    protocol_func_map_server[171][87] = function ( np )
        local var_1_unsigned_int = np:readUInt( ) --累计伤害值
        local var_2_unsigned_char = np:readByte( ) --奖励个数
        -- 奖励领取情况，每一个类型是byte，0表示未领取，1表示已领取
        local var_3_array = {}
        for i = 1, var_2_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_3_array, structObj )
        end
        PacketDispatcher:dispather( 171, 87, var_1_unsigned_int, var_2_unsigned_char, var_3_array )--分发数据
    end

    --下发神兵限时优惠数据
    --接收服务器
    protocol_func_map_server[171][120] = function ( np )
        local var_1_int = np:readInt( ) --已充值数
        -- 奖励领取情况，数组每个值为byte类型，1为已领取，0为未领取
        local var_2_array = {}
        for i = 1, var_1_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 171, 120, var_1_int, var_2_array )--分发数据
    end

    --下发神兵累积充值数据
    --接收服务器
    protocol_func_map_server[171][131] = function ( np )
        local var_1_int = np:readInt( ) --已充值数
        -- 奖励领取情况，数组每个值为byte类型，1为已领取，0为未领取
        local var_2_array = {}
        for i = 1, var_1_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 171, 131, var_1_int, var_2_array )--分发数据
    end

    --资源找回-下发各资源数据
    --接收服务器
    protocol_func_map_server[171][132] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --num，数组长度
        -- 元素信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 171, 132, var_1_unsigned_char, var_2_array )--分发数据
    end

    --资源找回-应答客户端找回
    --接收服务器
    protocol_func_map_server[171][133] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --count，数组长度
        -- 数组信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 171, 133, var_1_unsigned_char, var_2_array )--分发数据
    end

    --膜拜城主-下发活动界面数据
    --接收服务器
    protocol_func_map_server[171][134] = function ( np )
        local var_1_char = np:readChar( ) --是否在活动期间--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_int = np:readInt( ) --每隔多少秒获得一次区域属性经验
        local var_3_int64 = np:readInt64( ) --每次能获得多少区域属性经验
        local var_4_int = np:readInt( ) --当前刷新品质
        local var_5_int = np:readInt( ) --当日剩余膜拜次数
        local var_6_int = np:readInt( ) --当日免费刷新次数
        local var_7_int = np:readInt( ) --当日剩余刷新次数
        local var_8_int = np:readInt( ) --城主被膜拜次数
        local var_9_int = np:readInt( ) --城主被鄙视次数
        local var_10_char = np:readChar( ) --数组长度
        -- 经验刷星数据--s本参数存在特殊说明，请查阅协议编辑器
        local var_11_array = {}
        for i = 1, var_10_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_11_array, structObj )
        end
        PacketDispatcher:dispather( 171, 134, var_1_char, var_2_int, var_3_int64, var_4_int, var_5_int, var_6_int, var_7_int, var_8_int, var_9_int, var_10_char, var_11_array )--分发数据
    end

    --下发全服抽奖活动全服信息
    --接收服务器
    protocol_func_map_server[171][141] = function ( np )
        local var_1_int = np:readInt( ) --当前奖池奖金数量
        local var_2_unsigned_char = np:readByte( ) --幸运儿数量
        -- 幸运儿信息数组--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_array = {}
        for i = 1, var_2_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_3_array, structObj )
        end
        PacketDispatcher:dispather( 171, 141, var_1_int, var_2_unsigned_char, var_3_array )--分发数据
    end

    --静态场景副本统计-发送统计，见函数MiscFunc.SendOneCaleValue
    --接收服务器
    protocol_func_map_server[171][143] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --id--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_unsigned_char = np:readByte( ) --count，统计项
        -- 统计项信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_array = {}
        for i = 1, var_2_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_3_array, structObj )
        end
        PacketDispatcher:dispather( 171, 143, var_1_unsigned_char, var_2_unsigned_char, var_3_array )--分发数据
    end

    --世界Boss-下发排名统计
    --接收服务器
    protocol_func_map_server[171][149] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --count，数量
        -- 排名信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 171, 149, var_1_unsigned_char, var_2_array )--分发数据
    end

    --下发彩蛋信息
    --接收服务器
    protocol_func_map_server[171][153] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --彩蛋个数
        -- --s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 171, 153, var_1_unsigned_char, var_2_array )--分发数据
    end

    --神秘商店信息
    --接收服务器
    protocol_func_map_server[171][154] = function ( np )
        local var_1_int = np:readInt( ) --活动剩余时间
        local var_2_int = np:readInt( ) --下次刷新时间
        local var_3_int = np:readInt( ) --剩余刷新次数
        local var_4_int = np:readInt( ) --物品个数
        -- 物品信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_5_array = {}
        for i = 1, var_4_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_5_array, structObj )
        end
        PacketDispatcher:dispather( 171, 154, var_1_int, var_2_int, var_3_int, var_4_int, var_5_array )--分发数据
    end

    --神秘商店公告
    --接收服务器
    protocol_func_map_server[171][157] = function ( np )
        local var_1_int = np:readInt( ) --个数
        -- 公告数组--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 171, 157, var_1_int, var_2_array )--分发数据
    end

    --每日登录奖励状态
    --接收服务器
    protocol_func_map_server[171][159] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --连续登录天数
        local var_2_unsigned_char = np:readByte( ) --状态长度
        -- byte: 0未领取 1：已领取--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_array = {}
        for i = 1, var_2_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_3_array, structObj )
        end
        PacketDispatcher:dispather( 171, 159, var_1_unsigned_char, var_2_unsigned_char, var_3_array )--分发数据
    end

    --活跃好礼奖励状态
    --接收服务器
    protocol_func_map_server[171][161] = function ( np )
        local var_1_int = np:readInt( ) --累积的活跃度
        local var_2_int = np:readInt( ) --奖励个数
        -- byte:奖励状态 0 不可领 1 可领 2 已经领取--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_array = {}
        for i = 1, var_2_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_3_array, structObj )
        end
        PacketDispatcher:dispather( 171, 161, var_1_int, var_2_int, var_3_array )--分发数据
    end

    --限购玩家数据
    --接收服务器
    protocol_func_map_server[171][165] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --用第几天的配置
        local var_2_unsigned_char = np:readByte( ) --可买数组长度
        -- byte:可买个数--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_array = {}
        for i = 1, var_2_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_3_array, structObj )
        end
        PacketDispatcher:dispather( 171, 165, var_1_unsigned_char, var_2_unsigned_char, var_3_array )--分发数据
    end

    --捕鱼达人鱼的信息
    --接收服务器
    protocol_func_map_server[171][168] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --错误码 0 成功 1 失败
        local var_2_short = np:readShort( ) --剩余刷新次数
        local var_3_unsigned_int = np:readUInt( ) --换鱼倒计时
        local var_4_unsigned_int = np:readUInt( ) --活动截止时间
        local var_5_unsigned_short = np:readWord( ) --鱼的条数
        -- 鱼的类型数组--s本参数存在特殊说明，请查阅协议编辑器
        local var_6_array = {}
        for i = 1, var_5_unsigned_short do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_6_array, structObj )
        end
        PacketDispatcher:dispather( 171, 168, var_1_unsigned_char, var_2_short, var_3_unsigned_int, var_4_unsigned_int, var_5_unsigned_short, var_6_array )--分发数据
    end

    --活动大厅
    --接收服务器
    protocol_func_map_server[171][171] = function ( np )
        local var_1_int = np:readInt( ) --数组长度
        -- --s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 171, 171, var_1_int, var_2_array )--分发数据
    end

    --活动大厅可领奖励个数
    --接收服务器
    protocol_func_map_server[171][172] = function ( np )
        local var_1_int = np:readInt( ) --可领奖励个数
        local var_2_int = np:readInt( ) --长度
        -- byte--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_array = {}
        for i = 1, var_2_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_3_array, structObj )
        end
        PacketDispatcher:dispather( 171, 172, var_1_int, var_2_int, var_3_array )--分发数据
    end

    --每天可多次使用的物品的信息
    --接收服务器
    protocol_func_map_server[171][173] = function ( np )
        local var_1_int = np:readInt( ) --数组长度
        -- guid 次数--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 171, 173, var_1_int, var_2_array )--分发数据
    end

    --安全卫士奖励状态
    --接收服务器
    protocol_func_map_server[171][176] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --长度
        -- 状态数组 byte 0:没有领取 1：已领取
        local var_2_array = {}
        for i = 1, var_1_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 171, 176, var_1_unsigned_char, var_2_array )--分发数据
    end

    --全服抽奖活动信息
    --接收服务器
    protocol_func_map_server[171][188] = function ( np )
        local var_1_int = np:readInt( ) --奖池元宝
        local var_2_unsigned_char = np:readByte( ) --个数
        -- --s本参数存在特殊说明，请查阅协议编辑器
        local var_3_array = {}
        for i = 1, var_2_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_3_array, structObj )
        end
        PacketDispatcher:dispather( 171, 188, var_1_int, var_2_unsigned_char, var_3_array )--分发数据
    end

    --下发幸运翻牌活动数据
    --接收服务器
    protocol_func_map_server[171][179] = function ( np )
        local var_1_int = np:readInt( ) --玩家翻牌次数
        local var_2_unsigned_char = np:readByte( ) --牌的数量
        -- 根据牌的顺序下发牌对应的物品id和状态--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_array = {}
        for i = 1, var_2_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_3_array, structObj )
        end
        PacketDispatcher:dispather( 171, 179, var_1_int, var_2_unsigned_char, var_3_array )--分发数据
    end

    --下发幸运翻牌活动幸运排行榜
    --接收服务器
    protocol_func_map_server[171][180] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --排行榜玩家个数
        -- 排行榜玩家信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 171, 180, var_1_unsigned_char, var_2_array )--分发数据
    end

    --下发挂机有礼活动数据
    --接收服务器
    protocol_func_map_server[171][184] = function ( np )
        local var_1_int = np:readInt( ) --杀怪数量
        local var_2_unsigned_char = np:readByte( ) --礼包个数，即数组长度
        -- 每个礼包的领取状态，用byte描述--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_array = {}
        for i = 1, var_2_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_3_array, structObj )
        end
        PacketDispatcher:dispather( 171, 184, var_1_int, var_2_unsigned_char, var_3_array )--分发数据
    end

    --下发挑战副本活动数据
    --接收服务器
    protocol_func_map_server[171][185] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --数组长度
        -- 挑战副本次数和礼包领取状态--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 171, 185, var_1_unsigned_char, var_2_array )--分发数据
    end

    --投资计划活动玩家信息
    --接收服务器
    protocol_func_map_server[171][186] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --投资个数，数组长度
        -- --s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 171, 186, var_1_unsigned_char, var_2_array )--分发数据
    end

    --下发幸运翻牌洗牌数据
    --接收服务器
    protocol_func_map_server[171][187] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --数组长度
        -- 下发洗牌数据--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 171, 187, var_1_unsigned_char, var_2_array )--分发数据
    end

    --下发每日礼包跟消费情况
    --接收服务器
    protocol_func_map_server[171][192] = function ( np )
        -- 活动30天内每一天的礼包领取状态以及充元宝数--s本参数存在特殊说明，请查阅协议编辑器
        -- 数组长度约定，要自己手动填
        local array_length_const = 10
        local var_1_array = {}
        for i = 1, array_length_const do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_1_array, structObj )
        end
        PacketDispatcher:dispather( 171, 192, var_1_array )--分发数据
    end

    --下发九字真言玩家活动信息
    --接收服务器
    protocol_func_map_server[171][198] = function ( np )
        -- 81个格子信息，类型为byte，1为字，-1为空格子，0为未翻开
        -- 数组长度约定，要自己手动填
        local array_length_const = 10
        local var_1_array = {}
        for i = 1, array_length_const do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_1_array, structObj )
        end
        local var_2_unsigned_char = np:readByte( ) --客户端图标显示值--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_unsigned_char = np:readByte( ) --玩家今天已经手动刷新的次数
        local var_4_int = np:readInt( ) --距离下次自动刷新的时间间隔，单位秒
        PacketDispatcher:dispather( 171, 198, var_1_array, var_2_unsigned_char, var_3_unsigned_char, var_4_int )--分发数据
    end

    --下发星语心愿活动数据
    --接收服务器
    protocol_func_map_server[171][203] = function ( np )
        local var_1_int = np:readInt( ) --玩家星星数量
        local var_2_unsigned_char = np:readByte( ) --数组长度（礼包个数）
        -- unsigned char礼包领取状态--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_array = {}
        for i = 1, var_2_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_3_array, structObj )
        end
        PacketDispatcher:dispather( 171, 203, var_1_int, var_2_unsigned_char, var_3_array )--分发数据
    end

    --下发玩家的全民采购信息
    --接收服务器
    protocol_func_map_server[171][206] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --一共有多少个礼包，表示下面的array数组长度
        -- 每个礼包的购买信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 171, 206, var_1_unsigned_char, var_2_array )--分发数据
    end

    --下发幸运转盘动数据
    --接收服务器
    protocol_func_map_server[171][208] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --玩家可以抽奖次数
        local var_2_int = np:readInt( ) --消费元宝数量
        local var_3_unsigned_char = np:readByte( ) --转盘格子个数
        -- 对应格子的物品数量和id--s本参数存在特殊说明，请查阅协议编辑器
        local var_4_array = {}
        for i = 1, var_3_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_4_array, structObj )
        end
        PacketDispatcher:dispather( 171, 208, var_1_unsigned_char, var_2_int, var_3_unsigned_char, var_4_array )--分发数据
    end

    --活动大厅-下发连服城主战信息
    --接收服务器
    protocol_func_map_server[171][215] = function ( np )
        local var_1_unsigned_int = np:readUInt( ) --城主占领时间，单位秒
        local var_2_string = np:readString( ) --城主帮派名称
        local var_3_string = np:readString( ) --城主名称
        local var_4_unsigned_int = np:readUInt( ) --城主模型Id
        local var_5_unsigned_int = np:readUInt( ) --城主龙魂特效ID
        local var_6_unsigned_char = np:readByte( ) --isOpen，帮派战是否正在进行，1:进行，0:未进行
        local var_7_unsigned_char = np:readByte( ) --count, 护城将军的数量
        -- 护城将军信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_8_array = {}
        for i = 1, var_7_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_8_array, structObj )
        end
        PacketDispatcher:dispather( 171, 215, var_1_unsigned_int, var_2_string, var_3_string, var_4_unsigned_int, var_5_unsigned_int, var_6_unsigned_char, var_7_unsigned_char, var_8_array )--分发数据
    end

    --下发至尊特惠活动数据
    --接收服务器
    protocol_func_map_server[171][217] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --再购买n个礼包可以领取至尊
        local var_2_unsigned_char = np:readByte( ) --可领取的至尊的个数
        local var_3_unsigned_char = np:readByte( ) --礼包的个数
        -- 3个礼包的可领取状态（byte），0可购买，1表示已购买
        local var_4_array = {}
        for i = 1, var_3_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_4_array, structObj )
        end
        PacketDispatcher:dispather( 171, 217, var_1_unsigned_char, var_2_unsigned_char, var_3_unsigned_char, var_4_array )--分发数据
    end

    --下发至尊返利玩家信息
    --接收服务器
    protocol_func_map_server[171][219] = function ( np )
        local var_1_int = np:readInt( ) --累计充值元宝
        local var_2_int = np:readInt( ) --可领返利元宝
        local var_3_int = np:readInt( ) --礼包列表长度
        -- 礼包列表--s本参数存在特殊说明，请查阅协议编辑器
        local var_4_array = {}
        for i = 1, var_3_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_4_array, structObj )
        end
        PacketDispatcher:dispather( 171, 219, var_1_int, var_2_int, var_3_int, var_4_array )--分发数据
    end

    --下发玩家每日返利活动数据
    --接收服务器
    protocol_func_map_server[171][221] = function ( np )
        local var_1_int = np:readInt( ) --玩家当天充值元宝总数
        local var_2_unsigned_char = np:readByte( ) --领奖状态的个数
        -- 领奖状态--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_array = {}
        for i = 1, var_2_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_3_array, structObj )
        end
        PacketDispatcher:dispather( 171, 221, var_1_int, var_2_unsigned_char, var_3_array )--分发数据
    end

    --新版全服消费返回
    --接收服务器
    protocol_func_map_server[171][226] = function ( np )
        local var_1_int = np:readInt( ) --活动剩余时间
        local var_2_unsigned_char = np:readByte( ) --配置类型1,2
        local var_3_int = np:readInt( ) --全服消费
        local var_4_int = np:readInt( ) --个人消费
        -- 领奖状态0:条件不够,1条件够了,但没领取,2已经领取
        local var_5_array = {}
        for i = 1, var_4_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_5_array, structObj )
        end
        PacketDispatcher:dispather( 171, 226, var_1_int, var_2_unsigned_char, var_3_int, var_4_int, var_5_array )--分发数据
    end

    --下发活动在线奖励礼包信息
    --接收服务器
    protocol_func_map_server[171][229] = function ( np )
        local var_1_int = np:readInt( ) --礼包列表长度
        -- 礼包列表--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 171, 229, var_1_int, var_2_array )--分发数据
    end

    --下发连服充值排行的排行数据
    --接收服务器
    protocol_func_map_server[171][231] = function ( np )
        local var_1_int = np:readInt( ) --我的总充值元宝数
        local var_2_unsigned_char = np:readByte( ) --我的排名 0是未上榜
        local var_3_unsigned_char = np:readByte( ) --排行榜个数
        -- 排行数组--s本参数存在特殊说明，请查阅协议编辑器
        local var_4_array = {}
        for i = 1, var_3_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_4_array, structObj )
        end
        PacketDispatcher:dispather( 171, 231, var_1_int, var_2_unsigned_char, var_3_unsigned_char, var_4_array )--分发数据
    end

    --下发连服充值排行的全民数据
    --接收服务器
    protocol_func_map_server[171][232] = function ( np )
        local var_1_int = np:readInt( ) --总的充值数
        local var_2_int = np:readInt( ) --我的今日充值元宝数
        local var_3_unsigned_char = np:readByte( ) --全民奖励个数
        -- 全民奖励数组--s本参数存在特殊说明，请查阅协议编辑器
        local var_4_array = {}
        for i = 1, var_3_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_4_array, structObj )
        end
        PacketDispatcher:dispather( 171, 232, var_1_int, var_2_int, var_3_unsigned_char, var_4_array )--分发数据
    end

    --下发众志成城活动数据
    --接收服务器
    protocol_func_map_server[171][234] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --数组长度
        -- 冷却时间,int
        local var_2_array = {}
        for i = 1, var_1_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        local var_3_unsigned_char = np:readByte( ) --礼包个数
        -- 礼包领取情况,0～2表示,byte--s本参数存在特殊说明，请查阅协议编辑器
        local var_4_array = {}
        for i = 1, var_3_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_4_array, structObj )
        end
        PacketDispatcher:dispather( 171, 234, var_1_unsigned_char, var_2_array, var_3_unsigned_char, var_4_array )--分发数据
    end

    --限时抢购2,下发当天购买信息
    --接收服务器
    protocol_func_map_server[171][238] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --活动的第几天，从1开始
        -- 剩余购买次数--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 171, 238, var_1_unsigned_char, var_2_array )--分发数据
    end

    --下发单笔充值返利奖励信息
    --接收服务器
    protocol_func_map_server[171][239] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --一共有多少档奖励
        -- 每档奖励可以领取的元宝数--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 171, 239, var_1_unsigned_char, var_2_array )--分发数据
    end

    --下发周年鲜花榜
    --接收服务器
    protocol_func_map_server[171][245] = function ( np )
        local var_1_int = np:readInt( ) --数组长度
        -- guildname,name,flower,icon,sex(string,string,int,int,int)
        local var_2_array = {}
        for i = 1, var_1_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 171, 245, var_1_int, var_2_array )--分发数据
    end

    --下发消费回馈（有重复礼包）信息
    --接收服务器
    protocol_func_map_server[171][246] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --是否可以领取重复礼包
        local var_2_unsigned_char = np:readByte( ) --新老服配置，1表示老服，2表示新服
        local var_3_unsigned_char = np:readByte( ) --是否可以领取重复礼包，0表示不能领，1表示可以领
        local var_4_int = np:readInt( ) --累积消费元宝
        local var_5_unsigned_char = np:readByte( ) --最大可以领取什么级别的礼包
        local var_6_unsigned_char = np:readByte( ) --礼包数量
        -- 礼包领取情况数组
        local var_7_array = {}
        for i = 1, var_6_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_7_array, structObj )
        end
        local var_8_int = np:readInt( ) --剩余时间
        PacketDispatcher:dispather( 171, 246, var_1_unsigned_char, var_2_unsigned_char, var_3_unsigned_char, var_4_int, var_5_unsigned_char, var_6_unsigned_char, var_7_array, var_8_int )--分发数据
    end

    --下发玩家鉴宝信息
    --接收服务器
    protocol_func_map_server[171][96] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --按钮标记为，1为鉴宝，2为领取奖励
        local var_2_unsigned_char = np:readByte( ) --宝物相同等级--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_int = np:readInt( ) --当前可领取奖励的配置id
        local var_4_unsigned_char = np:readByte( ) --第几次换牌
        local var_5_int = np:readInt( ) --卡牌id列表长度
        -- 卡牌id列表--s本参数存在特殊说明，请查阅协议编辑器
        local var_6_array = {}
        for i = 1, var_5_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_6_array, structObj )
        end
        PacketDispatcher:dispather( 171, 96, var_1_unsigned_char, var_2_unsigned_char, var_3_int, var_4_unsigned_char, var_5_int, var_6_array )--分发数据
    end

    --下发消费礼包信息（22号活动）
    --接收服务器
    protocol_func_map_server[171][248] = function ( np )
        local var_1_int = np:readInt( ) --已消费元宝
        local var_2_int = np:readInt( ) --礼包列表长度
        -- 礼包列表信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_array = {}
        for i = 1, var_2_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_3_array, structObj )
        end
        PacketDispatcher:dispather( 171, 248, var_1_int, var_2_int, var_3_array )--分发数据
    end

