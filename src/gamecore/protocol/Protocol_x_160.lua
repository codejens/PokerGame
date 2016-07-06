    if ( protocol_func_map_server[160] == nil ) then
        protocol_func_map_server[160] = {}
    end



    --发送6强争霸小组信息
    --接收服务器
    protocol_func_map_server[160][1] = function ( np )
        local var_1_int = np:readInt( ) --我所在的小组--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_int = np:readInt( ) --分组数
        -- 分组信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_array = {}
        for i = 1, var_2_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_3_array, structObj )
        end
        PacketDispatcher:dispather( 160, 1, var_1_int, var_2_int, var_3_array )--分发数据
    end

    --发送6强争霸小组详情
    --接收服务器
    protocol_func_map_server[160][2] = function ( np )
        local var_1_int = np:readInt( ) --第几个小组--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_int = np:readInt( ) --仙宗个数
        -- 仙宗信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_array = {}
        for i = 1, var_2_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_3_array, structObj )
        end
        PacketDispatcher:dispather( 160, 2, var_1_int, var_2_int, var_3_array )--分发数据
    end

    --发送怪物输出最高仙宗
    --接收服务器
    protocol_func_map_server[160][4] = function ( np )
        local var_1_int = np:readInt( ) --怪物数量
        -- 怪物信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 160, 4, var_1_int, var_2_array )--分发数据
    end

    --仙宗积分信息统计面板(废弃，改用20)
    --接收服务器
    protocol_func_map_server[160][5] = function ( np )
        local var_1_int = np:readInt( ) --仙宗个数
        -- 积分信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 160, 5, var_1_int, var_2_array )--分发数据
    end

    --发送6强仙宗信息
    --接收服务器
    protocol_func_map_server[160][6] = function ( np )
        local var_1_int = np:readInt( ) --仙宗数量
        -- 仙宗信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 160, 6, var_1_int, var_2_array )--分发数据
    end

    --下发无主城资格赛排行
    --接收服务器
    protocol_func_map_server[160][9] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --资格赛id
        local var_2_unsigned_char = np:readByte( ) --该资格赛是否已开始
        local var_3_unsigned_short = np:readWord( ) --本帮派排名
        local var_4_unsigned_int = np:readUInt( ) --耗时
        local var_5_unsigned_char = np:readByte( ) --击杀boss数
        local var_6_unsigned_int = np:readUInt( ) --排行榜数据总条数
        local var_7_unsigned_short = np:readWord( ) --当前页的数据条数
        -- 资格赛排行榜数据--s本参数存在特殊说明，请查阅协议编辑器
        local var_8_array = {}
        for i = 1, var_7_unsigned_short do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_8_array, structObj )
        end
        PacketDispatcher:dispather( 160, 9, var_1_unsigned_char, var_2_unsigned_char, var_3_unsigned_short, var_4_unsigned_int, var_5_unsigned_char, var_6_unsigned_int, var_7_unsigned_short, var_8_array )--分发数据
    end

    --发送6强争霸赛和城主争霸赛副本初始信息
    --接收服务器
    protocol_func_map_server[160][3] = function ( np )
        local var_1_int = np:readInt( ) --比赛剩余时间(秒)
        local var_2_int = np:readInt( ) --仙宗数量
        -- 仙宗信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_array = {}
        for i = 1, var_2_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_3_array, structObj )
        end
        PacketDispatcher:dispather( 160, 3, var_1_int, var_2_int, var_3_array )--分发数据
    end

    --发送仙城相关信息
    --接收服务器
    protocol_func_map_server[160][11] = function ( np )
        local var_1_int = np:readInt( ) --仙城数量
        -- 各个仙城的信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 160, 11, var_1_int, var_2_array )--分发数据
    end

    --发送仙城记事记录
    --接收服务器
    protocol_func_map_server[160][12] = function ( np )
        local var_1_int = np:readInt( ) --第几个仙城
        local var_2_int = np:readInt( ) --记录条数
        -- 记录详细信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_array = {}
        for i = 1, var_2_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_3_array, structObj )
        end
        PacketDispatcher:dispather( 160, 12, var_1_int, var_2_int, var_3_array )--分发数据
    end

    --仙城城主变更
    --接收服务器
    protocol_func_map_server[160][13] = function ( np )
        local var_1_int = np:readInt( ) --仙城数量
        -- 城主信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 160, 13, var_1_int, var_2_array )--分发数据
    end

    --下发竞拍攻坚资格信息
    --接收服务器
    protocol_func_map_server[160][16] = function ( np )
        local var_1_char = np:readChar( ) --灵脉ID--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_char = np:readChar( ) --本周攻坚赛的次数
        -- --s本参数存在特殊说明，请查阅协议编辑器
        local var_3_array = {}
        for i = 1, var_2_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_3_array, structObj )
        end
        PacketDispatcher:dispather( 160, 16, var_1_char, var_2_char, var_3_array )--分发数据
    end

    --返回本仙宗的成员出价排行信息（需客户端自己排序）
    --接收服务器
    protocol_func_map_server[160][19] = function ( np )
        local var_1_char = np:readChar( ) --已出价的成员数量
        -- --s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 160, 19, var_1_char, var_2_array )--分发数据
    end

    --攻坚赛统计面板信息
    --接收服务器
    protocol_func_map_server[160][20] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --统计面板标志flag--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_unsigned_int = np:readUInt( ) --剩余时间
        -- 统计信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_array = {}
        for i = 1, var_2_unsigned_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_3_array, structObj )
        end
        PacketDispatcher:dispather( 160, 20, var_1_unsigned_char, var_2_unsigned_int, var_3_array )--分发数据
    end

    --下发金仙之力出战人员
    --接收服务器
    protocol_func_map_server[160][22] = function ( np )
        local var_1_int = np:readInt( ) --上宗ID
        local var_2_int = np:readInt( ) --出战人数
        -- 出战人员--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_array = {}
        for i = 1, var_2_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_3_array, structObj )
        end
        local var_4_int = np:readInt( ) --可设为出战人数--s本参数存在特殊说明，请查阅协议编辑器
        -- 可出战的人员--s本参数存在特殊说明，请查阅协议编辑器
        local var_5_array = {}
        for i = 1, var_4_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_5_array, structObj )
        end
        PacketDispatcher:dispather( 160, 22, var_1_int, var_2_int, var_3_array, var_4_int, var_5_array )--分发数据
    end

    --下发所有灵脉的竞拍得主信息
    --接收服务器
    protocol_func_map_server[160][23] = function ( np )
        local var_1_char = np:readChar( ) --数组长度
        -- --s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 160, 23, var_1_char, var_2_array )--分发数据
    end

    --圣皇仙城争夺_下发赛程信息
    --接收服务器
    protocol_func_map_server[160][27] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --当前比赛轮次
        -- 比赛赛程--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 160, 27, var_1_unsigned_char, var_2_array )--分发数据
    end

    --下发申请加入同盟列表
    --接收服务器
    protocol_func_map_server[160][30] = function ( np )
        local var_1_int = np:readInt( ) --同盟仙宗ID--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_short = np:readShort( ) --数组长度
        -- --s本参数存在特殊说明，请查阅协议编辑器
        local var_3_array = {}
        for i = 1, var_2_short do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_3_array, structObj )
        end
        PacketDispatcher:dispather( 160, 30, var_1_int, var_2_short, var_3_array )--分发数据
    end

    --下发同盟列表
    --接收服务器
    protocol_func_map_server[160][33] = function ( np )
        local var_1_char = np:readChar( ) --数组长度
        -- --s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 160, 33, var_1_char, var_2_array )--分发数据
    end

    --返回指定灵脉的竞拍得主信息
    --接收服务器
    protocol_func_map_server[160][34] = function ( np )
        local var_1_char = np:readChar( ) --数组长度
        -- （分别为1，3，5的挑战者得主）--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 160, 34, var_1_char, var_2_array )--分发数据
    end

    --返回指定灵脉的同盟信息
    --接收服务器
    protocol_func_map_server[160][35] = function ( np )
        local var_1_char = np:readChar( ) --灵脉ID
        local var_2_int = np:readInt( ) --城主同盟仙宗ID
        local var_3_string = np:readString( ) --城主同盟仙宗名称
        local var_4_string = np:readString( ) --城主同盟仙宗宗主名称
        local var_5_string = np:readString( ) --城主同盟仙宗所在服务器名称
        local var_6_char = np:readChar( ) --数组长度
        -- （分别为1，3，5的挑战者得主）--s本参数存在特殊说明，请查阅协议编辑器
        local var_7_array = {}
        for i = 1, var_6_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_7_array, structObj )
        end
        PacketDispatcher:dispather( 160, 35, var_1_char, var_2_int, var_3_string, var_4_string, var_5_string, var_6_char, var_7_array )--分发数据
    end

    --发送六强争霸和城主争夺每个塔的归属仙宗名
    --接收服务器
    protocol_func_map_server[160][39] = function ( np )
        local var_1_int = np:readInt( ) --塔的数量
        -- 归属仙宗名--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 160, 39, var_1_int, var_2_array )--分发数据
    end

    --返回本仙宗申请了的同盟
    --接收服务器
    protocol_func_map_server[160][41] = function ( np )
        local var_1_char = np:readChar( ) --数组长度
        -- --s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 160, 41, var_1_char, var_2_array )--分发数据
    end

    --下发同盟申请仙宗的成员列表
    --接收服务器
    protocol_func_map_server[160][44] = function ( np )
        local var_1_int = np:readInt( ) --仙宗ID
        local var_2_short = np:readShort( ) --成员数量
        -- --s本参数存在特殊说明，请查阅协议编辑器
        local var_3_array = {}
        for i = 1, var_2_short do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_3_array, structObj )
        end
        PacketDispatcher:dispather( 160, 44, var_1_int, var_2_short, var_3_array )--分发数据
    end

    --发送士气排行榜
    --接收服务器
    protocol_func_map_server[160][47] = function ( np )
        local var_1_int = np:readInt( ) --攻方排行榜项数量
        -- 攻方排行榜项--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        local var_3_int = np:readInt( ) --守方排行榜项数量
        -- 守方排行榜项--s本参数存在特殊说明，请查阅协议编辑器
        local var_4_array = {}
        for i = 1, var_3_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_4_array, structObj )
        end
        PacketDispatcher:dispather( 160, 47, var_1_int, var_2_array, var_3_int, var_4_array )--分发数据
    end

