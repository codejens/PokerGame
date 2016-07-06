    if ( protocol_func_map_server[139] == nil ) then
        protocol_func_map_server[139] = {}
    end



    --发送副本奖励包裹到客户端显示
    --接收服务器
    protocol_func_map_server[139][1] = function ( np )
        local var_1_unsigned_int = np:readUInt( ) --通关的副本ID
        local var_2_unsigned_char = np:readByte( ) --装备物品数量
        -- 物品信息--s本参数存在特殊说明，请查阅协议编辑器
        -- protocol manual server 结构体
         local var_3_struct = nil
        --var_3_struct = struct( np )
        local var_4_unsigned_char = np:readByte( ) --其他奖励的数量
        -- 其他奖励--s本参数存在特殊说明，请查阅协议编辑器
        local var_5_array = {}
        for i = 1, var_4_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_5_array, structObj )
        end
        PacketDispatcher:dispather( 139, 1, var_1_unsigned_int, var_2_unsigned_char, var_3_struct, var_4_unsigned_char, var_5_array )--分发数据
    end

    --客户端点击BOSS按钮
    --接收服务器
    protocol_func_map_server[139][10] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --BOSS的数量
        local var_2_unsigned_char = np:readByte( ) --是否弹出提示--s本参数存在特殊说明，请查阅协议编辑器
        -- BOSS的结构--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_array = {}
        for i = 1, var_2_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_3_array, structObj )
        end
        PacketDispatcher:dispather( 139, 10, var_1_unsigned_char, var_2_unsigned_char, var_3_array )--分发数据
    end

    --广播玩家领取了奖励的消息
    --接收服务器
    protocol_func_map_server[139][17] = function ( np )
        local var_1_int = np:readInt( ) --玩家id--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_unsigned_char = np:readByte( ) --箱子的索引--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_unsigned_char = np:readByte( ) --箱子类型，0:银，1：金
        local var_4_string = np:readString( ) --玩家名称
        local var_5_unsigned_char = np:readByte( ) --物品的数量
        -- 物品的信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_6_array = {}
        for i = 1, var_5_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_6_array, structObj )
        end
        local var_7_unsigned_char = np:readByte( ) --非物品奖励的数量
        -- 非物品奖励的信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_8_array = {}
        for i = 1, var_7_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_8_array, structObj )
        end
        PacketDispatcher:dispather( 139, 17, var_1_int, var_2_unsigned_char, var_3_unsigned_char, var_4_string, var_5_unsigned_char, var_6_array, var_7_unsigned_char, var_8_array )--分发数据
    end

    --发送通关评价窗口的信息
    --接收服务器
    protocol_func_map_server[139][16] = function ( np )
        local var_1_int = np:readInt( ) --副本id
        local var_2_string = np:readString( ) --副本名称
        local var_3_unsigned_char = np:readByte( ) --副本评级
        local var_4_int = np:readInt( ) --副本通关分
        local var_5_unsigned_char = np:readByte( ) --玩家的个数--s本参数存在特殊说明，请查阅协议编辑器
        -- 每个玩家的经验--s本参数存在特殊说明，请查阅协议编辑器
        local var_6_array = {}
        for i = 1, var_5_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_6_array, structObj )
        end
        local var_7_unsigned_char = np:readByte( ) --击杀boss的玩家个数
        -- 击杀boss的玩家名称--s本参数存在特殊说明，请查阅协议编辑器
        local var_8_array = {}
        for i = 1, var_7_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_8_array, structObj )
        end
        local var_9_unsigned_char = np:readByte( ) --活跃玩家数量--s本参数存在特殊说明，请查阅协议编辑器
        -- 最活跃玩家的排名,数量就是玩家的个数字段--s本参数存在特殊说明，请查阅协议编辑器
        local var_10_array = {}
        for i = 1, var_9_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_10_array, structObj )
        end
        PacketDispatcher:dispather( 139, 16, var_1_int, var_2_string, var_3_unsigned_char, var_4_int, var_5_unsigned_char, var_6_array, var_7_unsigned_char, var_8_array, var_9_unsigned_char, var_10_array )--分发数据
    end

    --幸运挖宝开启宝箱弹出界面
    --接收服务器
    protocol_func_map_server[139][20] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --物品的数量
        -- 物品的信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 139, 20, var_1_unsigned_char, var_2_array )--分发数据
    end

    --服务端返回阵营活动列表信息
    --接收服务器
    protocol_func_map_server[139][24] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --阵营活动个数
        -- 活动信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 139, 24, var_1_unsigned_char, var_2_array )--分发数据
    end

    --服务端请求打开老虎机界面
    --接收服务器
    protocol_func_map_server[139][26] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --窗口ID--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_unsigned_char = np:readByte( ) --老虎机数字变换时间(秒)
        local var_3_string = np:readString( ) --界面显示标题名称
        local var_4_string = np:readString( ) --领奖按钮显示名称
        local var_5_unsigned_char = np:readByte( ) --随机数字个数
        -- 随机数字--s本参数存在特殊说明，请查阅协议编辑器
        local var_6_array = {}
        for i = 1, var_5_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_6_array, structObj )
        end
        PacketDispatcher:dispather( 139, 26, var_1_unsigned_char, var_2_unsigned_char, var_3_string, var_4_string, var_5_unsigned_char, var_6_array )--分发数据
    end

    --下发天元之战统计数据
    --接收服务器
    protocol_func_map_server[139][35] = function ( np )
        local var_1_int = np:readInt( ) --仙宗排名
        local var_2_int = np:readInt( ) --仙宗积分
        local var_3_int = np:readInt( ) --个人排名
        local var_4_int = np:readInt( ) --个人积分
        local var_5_int = np:readInt( ) --个人排名的数量
        -- 个人排名的项目--s本参数存在特殊说明，请查阅协议编辑器
        local var_6_array = {}
        for i = 1, var_5_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_6_array, structObj )
        end
        local var_7_int = np:readInt( ) --帮派排名数量
        -- 帮派排名的项目--s本参数存在特殊说明，请查阅协议编辑器
        local var_8_array = {}
        for i = 1, var_7_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_8_array, structObj )
        end
        PacketDispatcher:dispather( 139, 35, var_1_int, var_2_int, var_3_int, var_4_int, var_5_int, var_6_array, var_7_int, var_8_array )--分发数据
    end

    --下发本帮派天元之战统计数据
    --接收服务器
    protocol_func_map_server[139][36] = function ( np )
        local var_1_int = np:readInt( ) --仙宗排名
        local var_2_int = np:readInt( ) --仙宗积分
        local var_3_int = np:readInt( ) --个人排名
        local var_4_int = np:readInt( ) --个人积分
        local var_5_int = np:readInt( ) --帮派排名的数量
        -- 各帮派--s本参数存在特殊说明，请查阅协议编辑器
        local var_6_array = {}
        for i = 1, var_5_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_6_array, structObj )
        end
        PacketDispatcher:dispather( 139, 36, var_1_int, var_2_int, var_3_int, var_4_int, var_5_int, var_6_array )--分发数据
    end

    --渡劫_下发渡劫副本信息
    --接收服务器
    protocol_func_map_server[139][41] = function ( np )
        local var_1_unsigned_int = np:readUInt( ) --是第几章
        local var_2_unsigned_int = np:readUInt( ) --破章第一人的ID， 如果没有人破破章，则时间为0
        local var_3_string = np:readString( ) --破章第一人的名字
        local var_4_unsigned_int = np:readUInt( ) --破章第一人耗费的时间，单位秒
        local var_5_unsigned_int = np:readUInt( ) --破章第一人奖励是否领取
        local var_6_unsigned_int = np:readUInt( ) --玩家是否破章， 0表示没有， 1表示已经破章
        local var_7_unsigned_int = np:readUInt( ) --玩家目前在该章的历史最高评价
        local var_8_unsigned_int = np:readUInt( ) --该章节一共有多少层
        -- 每一层的破关状态， 0表示没有破关，1表示已经破关--s本参数存在特殊说明，请查阅协议编辑器
        local var_9_array = {}
        for i = 1, var_8_unsigned_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_9_array, structObj )
        end
        -- 每一层的可扫荡状态，0表示不可扫荡，1表示可以扫荡--s本参数存在特殊说明，请查阅协议编辑器
        local var_10_array = {}
        for i = 1, var_9_array do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_10_array, structObj )
        end
        local var_11_unsigned_int = np:readUInt( ) --一键通关奖励数组长度
        -- 一键通关的奖励--s本参数存在特殊说明，请查阅协议编辑器
        local var_12_array = {}
        for i = 1, var_11_unsigned_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_12_array, structObj )
        end
        PacketDispatcher:dispather( 139, 41, var_1_unsigned_int, var_2_unsigned_int, var_3_string, var_4_unsigned_int, var_5_unsigned_int, var_6_unsigned_int, var_7_unsigned_int, var_8_unsigned_int, var_9_array, var_10_array, var_11_unsigned_int, var_12_array )--分发数据
    end

    --更新刷星任务可接状态
    --接收服务器
    protocol_func_map_server[139][44] = function ( np )
        local var_1_int = np:readInt( ) --可接刷星任务个数
        -- 各个可接刷星任务信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 139, 44, var_1_int, var_2_array )--分发数据
    end

    --下发宝箱掉落
    --接收服务器
    protocol_func_map_server[139][47] = function ( np )
        local var_1_int = np:readInt( ) --宝箱的物品数量
        -- 物品配置--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 139, 47, var_1_int, var_2_array )--分发数据
    end

    --发送阵营战战场信息
    --接收服务器
    protocol_func_map_server[139][50] = function ( np )
        local var_1_int = np:readInt( ) --战场个数
        -- 每个战场信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 139, 50, var_1_int, var_2_array )--分发数据
    end

    --发送阵营战排行榜信息
    --接收服务器
    protocol_func_map_server[139][52] = function ( np )
        local var_1_int = np:readInt( ) --自己排名
        local var_2_int = np:readInt( ) --总共多少页
        local var_3_int = np:readInt( ) --第几页
        local var_4_int = np:readInt( ) --排行榜项个数
        -- 各排行榜项信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_5_array = {}
        for i = 1, var_4_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_5_array, structObj )
        end
        PacketDispatcher:dispather( 139, 52, var_1_int, var_2_int, var_3_int, var_4_int, var_5_array )--分发数据
    end

    --发送排行榜统计信息
    --接收服务器
    protocol_func_map_server[139][54] = function ( np )
        local var_1_int = np:readInt( ) --战场id
        local var_2_int = np:readInt( ) --逍遥阵营积分
        local var_3_int = np:readInt( ) --星辰阵营积分
        local var_4_int = np:readInt( ) --逸仙阵营积分
        local var_5_int = np:readInt( ) --我的排名
        local var_6_int = np:readInt( ) --我的积分
        local var_7_int = np:readInt( ) --我的击杀
        local var_8_int = np:readInt( ) --我的助攻
        local var_9_int = np:readInt( ) --我的连斩
        -- 排名前三积分信息，共3个--s本参数存在特殊说明，请查阅协议编辑器
        local var_10_array = {}
        for i = 1, var_9_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_10_array, structObj )
        end
        PacketDispatcher:dispather( 139, 54, var_1_int, var_2_int, var_3_int, var_4_int, var_5_int, var_6_int, var_7_int, var_8_int, var_9_int, var_10_array )--分发数据
    end

    --双击使用某个物品后，服务端返回消耗这个物品后可以获得的新的物品的列表
    --接收服务器
    protocol_func_map_server[139][63] = function ( np )
        local var_1_int64 = np:readInt64( ) --物品序列号
        local var_2_int = np:readInt( ) --物品数量
        -- 物品列表--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_array = {}
        for i = 1, var_2_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_3_array, structObj )
        end
        PacketDispatcher:dispather( 139, 63, var_1_int64, var_2_int, var_3_array )--分发数据
    end

    --播放获取物品特效
    --接收服务器
    protocol_func_map_server[139][67] = function ( np )
        local var_1_int = np:readInt( ) --物品来源--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_int = np:readInt( ) --物品个数
        -- 各个物品信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_array = {}
        for i = 1, var_2_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_3_array, structObj )
        end
        PacketDispatcher:dispather( 139, 67, var_1_int, var_2_int, var_3_array )--分发数据
    end

    --下发经验找回系统数据
    --接收服务器
    protocol_func_map_server[139][70] = function ( np )
        local var_1_int = np:readInt( ) --可找回的副本个数
        -- 找回副本信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 139, 70, var_1_int, var_2_array )--分发数据
    end

    --八卦地宫的活动统计
    --接收服务器
    protocol_func_map_server[139][72] = function ( np )
        local var_1_int = np:readInt( ) --目标个数
        -- 目标--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 139, 72, var_1_int, var_2_array )--分发数据
    end

    --下发双旦活动信息
    --接收服务器
    protocol_func_map_server[139][78] = function ( np )
        local var_1_int = np:readInt( ) --数组长度
        -- 双旦活动时间--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        local var_3_char = np:readChar( ) --控制图标状态--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 139, 78, var_1_int, var_2_array, var_3_char )--分发数据
    end

    --发送连续登陆奖励
    --接收服务器
    protocol_func_map_server[139][80] = function ( np )
        local var_1_int = np:readInt( ) --奖励个数
        -- 奖励状态--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        local var_3_int = np:readInt( ) --已经连续登陆的天数
        PacketDispatcher:dispather( 139, 80, var_1_int, var_2_array, var_3_int )--分发数据
    end

    --发送限时商店活动信息
    --接收服务器
    protocol_func_map_server[139][85] = function ( np )
        local var_1_int = np:readInt( ) --活动剩余时间（秒）
        local var_2_int = np:readInt( ) --下次刷新时间
        local var_3_int = np:readInt( ) --剩余刷新次数
        local var_4_int = np:readInt( ) --物品数量
        -- 各个物品信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_5_array = {}
        for i = 1, var_4_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_5_array, structObj )
        end
        PacketDispatcher:dispather( 139, 85, var_1_int, var_2_int, var_3_int, var_4_int, var_5_array )--分发数据
    end

    --下发商城公告
    --接收服务器
    protocol_func_map_server[139][90] = function ( np )
        local var_1_int = np:readInt( ) --公告数
        -- 一组公告字符串
        local var_2_array = {}
        for i = 1, var_1_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 139, 90, var_1_int, var_2_array )--分发数据
    end

    --下发每日签到的已签数据
    --接收服务器
    protocol_func_map_server[139][97] = function ( np )
        local var_1_char = np:readChar( ) --签到的天数
        -- 内容--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        local var_3_short = np:readShort( ) --剩余天数--s本参数存在特殊说明，请查阅协议编辑器
        local var_4_short = np:readShort( ) --需要签到的总天数--s本参数存在特殊说明，请查阅协议编辑器
        local var_5_char = np:readChar( ) --签到送宠物是否已领--s本参数存在特殊说明，请查阅协议编辑器
        local var_6_char = np:readChar( ) --活跃值补签状态--s本参数存在特殊说明，请查阅协议编辑器
        local var_7_unsigned_char = np:readByte( ) --vip今日剩余补签次数，目前vip3及以上才可以有
        local var_8_int = np:readInt( ) --玩家创建时间
        PacketDispatcher:dispather( 139, 97, var_1_char, var_2_array, var_3_short, var_4_short, var_5_char, var_6_char, var_7_unsigned_char, var_8_int )--分发数据
    end

    --下发每日签到当月的奖励领取情况
    --接收服务器
    protocol_func_map_server[139][98] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --使用第几套配置， 从1开始
        local var_2_char = np:readChar( ) --奖励数量
        -- 内容--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_array = {}
        for i = 1, var_2_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_3_array, structObj )
        end
        PacketDispatcher:dispather( 139, 98, var_1_unsigned_char, var_2_char, var_3_array )--分发数据
    end

    --下发投资基金系统信息
    --接收服务器
    protocol_func_map_server[139][112] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --下发玩家购买的哪种投资计划--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_short = np:readShort( ) --奖励项数量
        -- 奖励项内容--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_array = {}
        for i = 1, var_2_short do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_3_array, structObj )
        end
        local var_4_int = np:readInt( ) --基金购买的第几天
        PacketDispatcher:dispather( 139, 112, var_1_unsigned_char, var_2_short, var_3_array, var_4_int )--分发数据
    end

    --衣柜_幻化信息
    --接收服务器
    protocol_func_map_server[139][118] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --激活星数
        local var_2_unsigned_char = np:readByte( ) --幻化形象的数量
        -- 当前玩家已经幻化的形象，类型为int--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_array = {}
        for i = 1, var_2_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_3_array, structObj )
        end
        local var_4_unsigned_char = np:readByte( ) --时装数量
        -- 时装信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_5_array = {}
        for i = 1, var_4_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_5_array, structObj )
        end
        PacketDispatcher:dispather( 139, 118, var_1_unsigned_char, var_2_unsigned_char, var_3_array, var_4_unsigned_char, var_5_array )--分发数据
    end

    --衣柜_战甲信息
    --接收服务器
    protocol_func_map_server[139][119] = function ( np )
        local var_1_unsigned_short = np:readWord( ) --附加属性个数
        -- 附加属性--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_unsigned_short do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        local var_3_unsigned_char = np:readByte( ) --时装槽圈数
        -- 时装圈信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_4_array = {}
        for i = 1, var_3_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_4_array, structObj )
        end
        PacketDispatcher:dispather( 139, 119, var_1_unsigned_short, var_2_array, var_3_unsigned_char, var_4_array )--分发数据
    end

    --衣柜_战甲放入返回
    --接收服务器
    protocol_func_map_server[139][121] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --当前放入是那圈
        local var_2_unsigned_char = np:readByte( ) --附加属性个数
        -- 附加属性值--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_array = {}
        for i = 1, var_2_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_3_array, structObj )
        end
        local var_4_unsigned_char = np:readByte( ) --当前放入的是那圈
        local var_5_unsigned_char = np:readByte( ) --当前放入的是那槽
        -- 当前放入的时装信息--s本参数存在特殊说明，请查阅协议编辑器
        -- protocol manual server 结构体
         local var_6_struct = nil
        --var_6_struct = struct( np )
        PacketDispatcher:dispather( 139, 121, var_1_unsigned_char, var_2_unsigned_char, var_3_array, var_4_unsigned_char, var_5_unsigned_char, var_6_struct )--分发数据
    end

    --衣柜_战甲卸下返回
    --接收服务器
    protocol_func_map_server[139][122] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --附加属性个数
        -- 附加属性值--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        local var_3_unsigned_char = np:readByte( ) --哪圈
        local var_4_unsigned_char = np:readByte( ) --哪槽
        PacketDispatcher:dispather( 139, 122, var_1_unsigned_char, var_2_array, var_3_unsigned_char, var_4_unsigned_char )--分发数据
    end

    --（废弃）鱼乐无穷_返回鱼信息
    --接收服务器
    protocol_func_map_server[139][124] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --错误码--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_unsigned_short = np:readWord( ) --剩余刷新次数
        local var_3_unsigned_int = np:readUInt( ) --换鱼倒记时间time_chang_fish
        local var_4_unsigned_int = np:readUInt( ) --活动截止倒计时间time_ret_deadline
        local var_5_unsigned_short = np:readWord( ) --鱼的条数--s本参数存在特殊说明，请查阅协议编辑器
        -- 所有鱼的类型--s本参数存在特殊说明，请查阅协议编辑器
        local var_6_array = {}
        for i = 1, var_5_unsigned_short do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_6_array, structObj )
        end
        PacketDispatcher:dispather( 139, 124, var_1_unsigned_char, var_2_unsigned_short, var_3_unsigned_int, var_4_unsigned_int, var_5_unsigned_short, var_6_array )--分发数据
    end

    --（废弃）下发题目
    --接收服务器
    protocol_func_map_server[139][179] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --第几个题目
        local var_2_string = np:readString( ) --题目内容
        -- 四个string，四个答案
        local var_3_array = {}
        for i = 1, var_2_string do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_3_array, structObj )
        end
        local var_4_int = np:readInt( ) --剩余读题时间
        PacketDispatcher:dispather( 139, 179, var_1_unsigned_char, var_2_string, var_3_array, var_4_int )--分发数据
    end

    --（废弃）下发道具剩余次数
    --接收服务器
    protocol_func_map_server[139][183] = function ( np )
        -- 三个int值的数组，分别表示双倍文采，答案排错，一击命中的剩余次数
        -- 数组长度约定，要自己手动填
        local array_length_const = 10
        local var_1_array = {}
        for i = 1, array_length_const do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_1_array, structObj )
        end
        PacketDispatcher:dispather( 139, 183, var_1_array )--分发数据
    end

    --（废弃）下发欢乐答题奖励
    --接收服务器
    protocol_func_map_server[139][185] = function ( np )
        local var_1_int = np:readInt( ) --奖励个数
        -- 一组奖励信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 139, 185, var_1_int, var_2_array )--分发数据
    end

    --（废弃）广播欢乐答题排名情况
    --接收服务器
    protocol_func_map_server[139][186] = function ( np )
        local var_1_int = np:readInt( ) --排名人数
        -- 玩家信息数组，大小为前面的int--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 139, 186, var_1_int, var_2_array )--分发数据
    end

    --下发全部战场信息
    --接收服务器
    protocol_func_map_server[139][172] = function ( np )
        local var_1_int = np:readInt( ) --战场个数
        -- 战场信息数组--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 139, 172, var_1_int, var_2_array )--分发数据
    end

    --药水购买情况
    --接收服务器
    protocol_func_map_server[139][173] = function ( np )
        local var_1_int = np:readInt( ) --药水数量
        -- byte数组，1是购买过，0是非购买过
        local var_2_array = {}
        for i = 1, var_1_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 139, 173, var_1_int, var_2_array )--分发数据
    end

    --广播名人堂数据
    --接收服务器
    protocol_func_map_server[139][196] = function ( np )
        local var_1_int = np:readInt( ) --称号总数目
        -- 每个称号信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 139, 196, var_1_int, var_2_array )--分发数据
    end

    --下发玩家名人堂数据
    --接收服务器
    protocol_func_map_server[139][199] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --玩家当前使用称号ID数
        -- 玩家当前使用的称号ID，每个都为int
        local var_2_array = {}
        for i = 1, var_1_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 139, 199, var_1_unsigned_char, var_2_array )--分发数据
    end

    --下发第二周活动数据
    --接收服务器
    protocol_func_map_server[139][203] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --连续登陆天数
        local var_2_int = np:readInt( ) --今日充值数
        -- 日常活动次数，每个都是byte
        local var_3_array = {}
        for i = 1, var_2_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_3_array, structObj )
        end
        -- 各项礼包领取情况，每个都是个byte，1表示已领取，0表示未领取--s本参数存在特殊说明，请查阅协议编辑器
        local var_4_array = {}
        for i = 1, var_3_array do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_4_array, structObj )
        end
        PacketDispatcher:dispather( 139, 203, var_1_unsigned_char, var_2_int, var_3_array, var_4_array )--分发数据
    end

    --广播极限名人堂数据
    --接收服务器
    protocol_func_map_server[139][205] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --称号总数
        -- 称号数据--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 139, 205, var_1_unsigned_char, var_2_array )--分发数据
    end

    --极限名人堂奖励领取情况
    --接收服务器
    protocol_func_map_server[139][206] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --数组长度
        -- 每个称号的奖励情况--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 139, 206, var_1_unsigned_char, var_2_array )--分发数据
    end

    --广播新极限名人堂数据
    --接收服务器
    protocol_func_map_server[139][213] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --目标总数
        -- 目标数据--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 139, 213, var_1_unsigned_char, var_2_array )--分发数据
    end

    --新极限名人堂奖励领取情况
    --接收服务器
    protocol_func_map_server[139][214] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --数组长度
        -- 每个目标的奖励情况--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        local var_3_unsigned_char = np:readByte( ) --特殊奖励数量
        -- 特殊奖励领取情况--s本参数存在特殊说明，请查阅协议编辑器
        local var_4_array = {}
        for i = 1, var_3_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_4_array, structObj )
        end
        PacketDispatcher:dispather( 139, 214, var_1_unsigned_char, var_2_array, var_3_unsigned_char, var_4_array )--分发数据
    end

    --发送玩家活动数据
    --接收服务器
    protocol_func_map_server[139][216] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --连续登陆天数
        local var_2_int = np:readInt( ) --每天元宝消费数量
        -- 礼包领取状态，1表示已经领取
        local var_3_array = {}
        for i = 1, var_2_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_3_array, structObj )
        end
        PacketDispatcher:dispather( 139, 216, var_1_unsigned_char, var_2_int, var_3_array )--分发数据
    end

    --服务端下发玩家的时装放置位置开启信息
    --接收服务器
    protocol_func_map_server[139][223] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --总的页数
        -- 每一页的开启信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 139, 223, var_1_unsigned_char, var_2_array )--分发数据
    end

    --热血护镖-下发排行榜信息
    --接收服务器
    protocol_func_map_server[139][225] = function ( np )
        local var_1_int = np:readInt( ) --排行榜类型--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_int = np:readInt( ) --总共多少页信息
        -- 具体的数据项内容--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_array = {}
        for i = 1, var_2_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_3_array, structObj )
        end
        PacketDispatcher:dispather( 139, 225, var_1_int, var_2_int, var_3_array )--分发数据
    end

    --服务端下发所有星辰变属性
    --接收服务器
    protocol_func_map_server[139][226] = function ( np )
        local var_1_unsigned_short = np:readWord( ) --附加属性个数
        -- 附加属性值--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_unsigned_short do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 139, 226, var_1_unsigned_short, var_2_array )--分发数据
    end

    --下发彩蛋信息
    --接收服务器
    protocol_func_map_server[139][233] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --彩蛋个数
        -- 彩蛋信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 139, 233, var_1_unsigned_char, var_2_array )--分发数据
    end

    --下发纸牌信息
    --接收服务器
    protocol_func_map_server[139][241] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --标识当前是处于什么活动状态--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_int = np:readInt( ) --表示牌的数量
        -- 下发牌的状态--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_array = {}
        for i = 1, var_2_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_3_array, structObj )
        end
        PacketDispatcher:dispather( 139, 241, var_1_unsigned_char, var_2_int, var_3_array )--分发数据
    end

    --副本额外奖励-打开和关闭提示图标
    --接收服务器
    protocol_func_map_server[139][245] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --command, 打开还是关闭图标--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_unsigned_char = np:readByte( ) --count, 玩家在此副本中未领取的奖品数
        local var_3_unsigned_char = np:readByte( ) --floor, 玩家当前进入的副本第几层
        local var_4_unsigned_char = np:readByte( ) --ArrayCount, 奖励的数组的个数
        -- Array, 奖励的数组--s本参数存在特殊说明，请查阅协议编辑器
        local var_5_array = {}
        for i = 1, var_4_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_5_array, structObj )
        end
        PacketDispatcher:dispather( 139, 245, var_1_unsigned_char, var_2_unsigned_char, var_3_unsigned_char, var_4_unsigned_char, var_5_array )--分发数据
    end

    --新美女理财-下发投资基金系统信息
    --接收服务器
    protocol_func_map_server[139][253] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --下发玩家购买的哪种投资计划--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_short = np:readShort( ) --奖励项数量
        -- 奖励项内容--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_array = {}
        for i = 1, var_2_short do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_3_array, structObj )
        end
        local var_4_int = np:readInt( ) --基金购买的第几天
        PacketDispatcher:dispather( 139, 253, var_1_unsigned_char, var_2_short, var_3_array, var_4_int )--分发数据
    end

    --渡劫_下发非首次通关倒计时
    --接收服务器
    protocol_func_map_server[139][131] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --首通标示：1首通 0日常
        local var_2_unsigned_char = np:readByte( ) --是否让“挑战下关”按钮正常显示标识--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_int = np:readInt( ) --数组长度
        -- 概率掉落奖励数组--s本参数存在特殊说明，请查阅协议编辑器
        local var_4_array = {}
        for i = 1, var_3_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_4_array, structObj )
        end
        PacketDispatcher:dispather( 139, 131, var_1_unsigned_char, var_2_unsigned_char, var_3_int, var_4_array )--分发数据
    end

    --轮盘副本_画本结束广播副本记录
    --接收服务器
    protocol_func_map_server[139][136] = function ( np )
        local var_1_char = np:readChar( ) --回合数量
        -- --s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 139, 136, var_1_char, var_2_array )--分发数据
    end

