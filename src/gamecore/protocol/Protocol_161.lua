protocol_func_map_client[161] = {
    --返利大厅.每日首充大团购-客户端请求奖励信息
    --客户端发送
    [1] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 1 ) 
        NetManager:send_packet( np )
    end,

    --返利大厅.每日首充大团购-客户端领取奖励
    --客户端发送
    [2] = function ( 
                param_1_unsigned_char -- index，奖励索引，从1开始，1表示最低的奖励
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 2 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --返利大厅.vip团购大返利-客户端请求奖励信息
    --客户端发送
    [3] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 3 ) 
        NetManager:send_packet( np )
    end,

    --返利大厅.vip团购大返利-客户端领取奖励
    --客户端发送
    [4] = function ( 
                param_1_unsigned_char,  -- condition，从1开始。
                param_2_unsigned_char -- index
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" }, { param_name = param_2_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 4 ) 
        np:writeByte( param_1_unsigned_char )
        np:writeByte( param_2_unsigned_char )
        NetManager:send_packet( np )
    end,

    --返利大厅.vip等级大回馈-客户端请求奖励信息
    --客户端发送
    [5] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 5 ) 
        NetManager:send_packet( np )
    end,

    --返利大厅.vip等级大回馈-客户端领取奖励
    --客户端发送
    [6] = function ( 
                param_1_unsigned_char -- index，奖励索引从1开始，表示最低奖励
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 6 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --（废弃）土豪送礼.强化团购-客户端请求奖励信息
    --客户端发送
    [7] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 7 ) 
        NetManager:send_packet( np )
    end,

    --（废弃）土豪送礼.强化团购-客户端领取奖励
    --客户端发送
    [8] = function ( 
                param_1_unsigned_char,  -- condition，从1开始。
                param_2_unsigned_char -- index，具体某一项奖励
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" }, { param_name = param_2_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 8 ) 
        np:writeByte( param_1_unsigned_char )
        np:writeByte( param_2_unsigned_char )
        NetManager:send_packet( np )
    end,

    --返利大厅（循环）.强化进阶-客户端请求奖励信息
    --客户端发送
    [9] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 9 ) 
        NetManager:send_packet( np )
    end,

    --返利大厅（循环）.强化进阶-客户端领取奖励
    --客户端发送
    [10] = function ( 
                param_1_unsigned_char -- index，奖励索引，从1开始表示最低奖励
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 10 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --返利大厅.领取充值返利奖励
    --客户端发送
    [14] = function ( 
                param_1_unsigned_char -- 奖励序号（见配置）从1开始
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 14 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --返利大厅.请求充值返利奖励状态
    --客户端发送
    [15] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 15 ) 
        NetManager:send_packet( np )
    end,

    --返利大厅.请求充值返利奖励数量
    --客户端发送
    [16] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 16 ) 
        NetManager:send_packet( np )
    end,

    --返利大厅.领取全民冲级奖励
    --客户端发送
    [17] = function ( 
                param_1_unsigned_char -- 奖励序号（见配置）从1开始
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 17 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --返利大厅.请求全民冲级奖励状态
    --客户端发送
    [18] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 18 ) 
        NetManager:send_packet( np )
    end,

    --返利大厅.请求全民冲级奖励数量
    --客户端发送
    [19] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 19 ) 
        NetManager:send_packet( np )
    end,

    --返利大厅.请求战力排行信息
    --客户端发送
    [20] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 20 ) 
        NetManager:send_packet( np )
    end,

    --返利大厅.领取战力排行全民奖励
    --客户端发送
    [21] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 21 ) 
        NetManager:send_packet( np )
    end,

    --返利大厅.请求坐骑排行信息
    --客户端发送
    [22] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 22 ) 
        NetManager:send_packet( np )
    end,

    --返利大厅.领取坐骑排行全民奖励
    --客户端发送
    [23] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 23 ) 
        NetManager:send_packet( np )
    end,

    --返利大厅.请求宠物排行信息
    --客户端发送
    [24] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 24 ) 
        NetManager:send_packet( np )
    end,

    --返利大厅.领取宠物排行全民奖励
    --客户端发送
    [25] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 25 ) 
        NetManager:send_packet( np )
    end,

    --返利大厅.请求宝石排行信息
    --客户端发送
    [26] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 26 ) 
        NetManager:send_packet( np )
    end,

    --返利大厅.领取宝石排行全民奖励
    --客户端发送
    [27] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 27 ) 
        NetManager:send_packet( np )
    end,

    --返利大厅.请求法宝排行信息
    --客户端发送
    [28] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 28 ) 
        NetManager:send_packet( np )
    end,

    --返利大厅.领取法宝排行全民奖励
    --客户端发送
    [29] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 29 ) 
        NetManager:send_packet( np )
    end,

    --返利大厅.请求幻羽排行信息
    --客户端发送
    [30] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 30 ) 
        NetManager:send_packet( np )
    end,

    --返利大厅.领取幻羽排行全民奖励
    --客户端发送
    [31] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 31 ) 
        NetManager:send_packet( np )
    end,

    --返利大厅.请求新服超惠剩余数量
    --客户端发送
    [32] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 32 ) 
        NetManager:send_packet( np )
    end,

    --返利大厅.请求购买新服超惠物品
    --客户端发送
    [33] = function ( 
                param_1_unsigned_char -- 物品序号（见配置）从1开始
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 33 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --返利大厅.请求龙鳞大兑换剩余数量
    --客户端发送
    [34] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 34 ) 
        NetManager:send_packet( np )
    end,

    --返利大厅.请求龙鳞大兑换之兑换物品
    --客户端发送
    [35] = function ( 
                param_1_unsigned_char -- 序号（见配置）从1开始
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 35 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --返利大厅.请求宝石排行榜
    --客户端发送
    [36] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 36 ) 
        NetManager:send_packet( np )
    end,

    --返利大厅.请求强化排行信息
    --客户端发送
    [37] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 37 ) 
        NetManager:send_packet( np )
    end,

    --返利大厅.领取强化排行全民奖励
    --客户端发送
    [38] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 38 ) 
        NetManager:send_packet( np )
    end,

    --返利大厅.请求强化排行榜
    --客户端发送
    [39] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 39 ) 
        NetManager:send_packet( np )
    end,

    --问鼎龙破.客户端请求boss争霸信息
    --客户端发送
    [41] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 41 ) 
        NetManager:send_packet( np )
    end,

    --问鼎龙破.客户端请求boss争霸排行榜信息
    --客户端发送
    [42] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 42 ) 
        NetManager:send_packet( np )
    end,

    --问鼎龙破.客户端请求领取boss争霸全民礼包
    --客户端发送
    [43] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 43 ) 
        NetManager:send_packet( np )
    end,

    --问鼎龙破.客户端请求帮派争霸信息
    --客户端发送
    [44] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 44 ) 
        NetManager:send_packet( np )
    end,

    --问鼎龙破.客户端请求帮派争霸排行榜信息
    --客户端发送
    [45] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 45 ) 
        NetManager:send_packet( np )
    end,

    --问鼎龙破.客户端请求领取帮派争霸全民礼包
    --客户端发送
    [46] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 46 ) 
        NetManager:send_packet( np )
    end,

    --问鼎龙破.客户端请求双阵营信息
    --客户端发送
    [47] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 47 ) 
        NetManager:send_packet( np )
    end,

    --问鼎龙破.客户端请求双阵营排行榜信息
    --客户端发送
    [48] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 48 ) 
        NetManager:send_packet( np )
    end,

    --问鼎龙破.客户端请求领取双阵营全民礼包
    --客户端发送
    [49] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 49 ) 
        NetManager:send_packet( np )
    end,

    --问鼎龙破.客户端请求运镖争霸信息
    --客户端发送
    [50] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 50 ) 
        NetManager:send_packet( np )
    end,

    --问鼎龙破.客户端请求运镖争霸排行榜信息
    --客户端发送
    [51] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 51 ) 
        NetManager:send_packet( np )
    end,

    --问鼎龙破.客户端请求领取运镖争霸全民礼包
    --客户端发送
    [52] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 52 ) 
        NetManager:send_packet( np )
    end,

    --问鼎龙破.客户端请求劫镖争霸信息
    --客户端发送
    [53] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 53 ) 
        NetManager:send_packet( np )
    end,

    --问鼎龙破.客户端请求劫镖争霸排行版信息
    --客户端发送
    [54] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 54 ) 
        NetManager:send_packet( np )
    end,

    --问鼎龙破.客户端请求领取劫镖争霸全民礼包
    --客户端发送
    [55] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 55 ) 
        NetManager:send_packet( np )
    end,

    --问鼎龙破.客户端请求渡劫争霸信息
    --客户端发送
    [56] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 56 ) 
        NetManager:send_packet( np )
    end,

    --问鼎龙破.客户端请求渡劫争霸排行榜信息
    --客户端发送
    [57] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 57 ) 
        NetManager:send_packet( np )
    end,

    --问鼎龙破.客户端请求领取渡劫争霸全民礼包
    --客户端发送
    [58] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 58 ) 
        NetManager:send_packet( np )
    end,

    --问鼎龙破.客户端请求战神争霸信息
    --客户端发送
    [59] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 59 ) 
        NetManager:send_packet( np )
    end,

    --问鼎龙破.客户端请求战神争霸排行榜信息
    --客户端发送
    [60] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 60 ) 
        NetManager:send_packet( np )
    end,

    --开服宠物进阶-客户端请求界面信息
    --客户端发送
    [62] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 62 ) 
        NetManager:send_packet( np )
    end,

    --开服宠物进阶-客户端领取奖励
    --客户端发送
    [63] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 63 ) 
        NetManager:send_packet( np )
    end,

    --开服翅膀进阶-客户端请求界面信息
    --客户端发送
    [67] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 67 ) 
        NetManager:send_packet( np )
    end,

    --开服翅膀进阶-请求领取奖励
    --客户端发送
    [68] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 68 ) 
        NetManager:send_packet( np )
    end,

    --开服坐骑进阶-客户端请求界面信息
    --客户端发送
    [69] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 69 ) 
        NetManager:send_packet( np )
    end,

    --开服坐骑进阶-客户端领取奖励
    --客户端发送
    [70] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 70 ) 
        NetManager:send_packet( np )
    end,

    --返利大厅（循环）.请求坐骑进阶信息
    --客户端发送
    [75] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 75 ) 
        NetManager:send_packet( np )
    end,

    --返利大厅（循环）.请求领取坐骑进阶礼包
    --客户端发送
    [76] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 76 ) 
        NetManager:send_packet( np )
    end,

    --返利大厅（循环）.请求宠物进阶信息
    --客户端发送
    [77] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 77 ) 
        NetManager:send_packet( np )
    end,

    --返利大厅（循环）.请求领取宠物进阶礼包
    --客户端发送
    [78] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 78 ) 
        NetManager:send_packet( np )
    end,

    --返利大厅（循环）.请求翅膀进阶信息
    --客户端发送
    [79] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 79 ) 
        NetManager:send_packet( np )
    end,

    --返利大厅（循环）.请求领取翅膀进阶礼包
    --客户端发送
    [80] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 80 ) 
        NetManager:send_packet( np )
    end,

    --返利大厅（循环）.请求法宝进阶信息
    --客户端发送
    [81] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 81 ) 
        NetManager:send_packet( np )
    end,

    --返利大厅（循环）.请求领取法宝进阶礼包
    --客户端发送
    [82] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 82 ) 
        NetManager:send_packet( np )
    end,

    --（废弃）土豪活动-请求宝石等级信息
    --客户端发送
    [83] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 83 ) 
        NetManager:send_packet( np )
    end,

    --（废弃）土豪活动-请求领取宝石等级礼包
    --客户端发送
    [84] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 84 ) 
        NetManager:send_packet( np )
    end,

    --返利大厅.请求每日目标大赠送达成信息
    --客户端发送
    [90] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 90 ) 
        NetManager:send_packet( np )
    end,

    --返利大厅.请求领取每日目标大赠送达成了礼包
    --客户端发送
    [91] = function ( 
                param_1_unsigned_char,  -- 目标类型
                param_2_unsigned_int -- 目标值
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" }, { param_name = param_2_unsigned_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 91 ) 
        np:writeByte( param_1_unsigned_char )
        np:writeUInt( param_2_unsigned_int )
        NetManager:send_packet( np )
    end,

    --返利大厅（循环）.领取充值返利奖励
    --客户端发送
    [100] = function ( 
                param_1_unsigned_char -- 奖励序号（见配置）从1开始
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 100 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --返利大厅（循环）.请求充值返利奖励状态
    --客户端发送
    [101] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 101 ) 
        NetManager:send_packet( np )
    end,

    --返利大厅（循环）.请求充值返利奖励数量
    --客户端发送
    [102] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 102 ) 
        NetManager:send_packet( np )
    end,

    --返利大厅（循环）.请求新服超惠剩余数量
    --客户端发送
    [103] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 103 ) 
        NetManager:send_packet( np )
    end,

    --返利大厅（循环）.请求购买新服超惠物品
    --客户端发送
    [104] = function ( 
                param_1_unsigned_char -- 物品序号（见配置）从1开始
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 104 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --返利大厅（循环）.请求坐骑排行信息
    --客户端发送
    [105] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 105 ) 
        NetManager:send_packet( np )
    end,

    --返利大厅（循环）.领取坐骑排行全民奖励
    --客户端发送
    [106] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 106 ) 
        NetManager:send_packet( np )
    end,

    --返利大厅（循环）.请求宠物排行信息
    --客户端发送
    [107] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 107 ) 
        NetManager:send_packet( np )
    end,

    --返利大厅（循环）.领取宠物排行全民奖励
    --客户端发送
    [108] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 108 ) 
        NetManager:send_packet( np )
    end,

    --返利大厅（循环）.请求法宝排行信息
    --客户端发送
    [109] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 109 ) 
        NetManager:send_packet( np )
    end,

    --返利大厅（循环）.领取法宝排行全民奖励
    --客户端发送
    [110] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 110 ) 
        NetManager:send_packet( np )
    end,

    --返利大厅（循环）.请求幻羽排行信息
    --客户端发送
    [111] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 111 ) 
        NetManager:send_packet( np )
    end,

    --返利大厅（循环）.领取幻羽排行全民奖励
    --客户端发送
    [112] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 112 ) 
        NetManager:send_packet( np )
    end,

    --返利大厅（循环）.请求强化排行信息
    --客户端发送
    [113] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 113 ) 
        NetManager:send_packet( np )
    end,

    --返利大厅（循环）.领取强化排行全民奖励
    --客户端发送
    [114] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 114 ) 
        NetManager:send_packet( np )
    end,

    --返利大厅（循环）.请求强化排行榜
    --客户端发送
    [115] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 115 ) 
        NetManager:send_packet( np )
    end,

    --返利大厅.首冲团购（循环）-客户端请求奖励信息
    --客户端发送
    [116] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 116 ) 
        NetManager:send_packet( np )
    end,

    --返利大厅.首冲团购（循环）-客户端领取奖励
    --客户端发送
    [117] = function ( 
                param_1_unsigned_char -- index，奖励索引，从1开始，1表示最低的奖励
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 117 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --每日抽奖-请求抽奖信息
    --客户端发送
    [121] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 121 ) 
        NetManager:send_packet( np )
    end,

    --每日抽奖-请求抽奖
    --客户端发送
    [122] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 122 ) 
        NetManager:send_packet( np )
    end,

    --返利大厅.请求神兵排行信息
    --客户端发送
    [131] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 131 ) 
        NetManager:send_packet( np )
    end,

    --返利大厅.领取神兵排行全民奖励
    --客户端发送
    [132] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 132 ) 
        NetManager:send_packet( np )
    end,

    --返利大厅（循环）.请求神兵排行信息
    --客户端发送
    [133] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 133 ) 
        NetManager:send_packet( np )
    end,

    --返利大厅（循环）.领取神兵排行全民奖励
    --客户端发送
    [134] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 134 ) 
        NetManager:send_packet( np )
    end,

    --返利大厅（循环）.请求神兵进阶信息
    --客户端发送
    [135] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 135 ) 
        NetManager:send_packet( np )
    end,

    --返利大厅（循环）.请求领取神兵进阶礼包
    --客户端发送
    [136] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 136 ) 
        NetManager:send_packet( np )
    end,

    --问鼎龙破-客户端请求领地争霸信息
    --客户端发送
    [140] = function ( 
                param_1_unsigned_char -- 第几次
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 140 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --问鼎龙破-客户端请求领取领地争霸礼包
    --客户端发送
    [141] = function ( 
                param_1_unsigned_char -- 第几次
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 141 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --问鼎龙破-客户端请求领地争霸排行信息
    --客户端发送
    [142] = function ( 
                param_1_unsigned_char -- 第几次
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 142 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --请求在线奖励元宝信息
    --客户端发送
    [146] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 146 ) 
        NetManager:send_packet( np )
    end,

    --请求领取在想奖励元宝
    --客户端发送
    [147] = function ( 
                param_1_unsigned_char -- 1：领取物品奖励，2：点金
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 147 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --商城限时购买。获取当前限时购买数据
    --客户端发送
    [148] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 148 ) 
        NetManager:send_packet( np )
    end,

    --返利大厅.请求法阵排行信息
    --客户端发送
    [149] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 149 ) 
        NetManager:send_packet( np )
    end,

    --返利大厅.领取法阵排行全民奖励
    --客户端发送
    [150] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 150 ) 
        NetManager:send_packet( np )
    end,

    --返利大厅（循环）.请求法阵进阶信息
    --客户端发送
    [151] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 151 ) 
        NetManager:send_packet( np )
    end,

    --返利大厅（循环）.请求领取法阵进阶礼包
    --客户端发送
    [152] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 152 ) 
        NetManager:send_packet( np )
    end,

    --返利大厅.请求战灵排行信息
    --客户端发送
    [153] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 153 ) 
        NetManager:send_packet( np )
    end,

    --返利大厅.领取战灵排行全民奖励
    --客户端发送
    [154] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 154 ) 
        NetManager:send_packet( np )
    end,

    --返利大厅（循环）.请求战灵进阶信息
    --客户端发送
    [155] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 155 ) 
        NetManager:send_packet( np )
    end,

    --返利大厅（循环）.请求领取战灵进阶礼包
    --客户端发送
    [156] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 156 ) 
        NetManager:send_packet( np )
    end,

    --开服法阵进阶-客户端请求界面信息
    --客户端发送
    [157] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 157 ) 
        NetManager:send_packet( np )
    end,

    --开服法阵进阶-客户端领取奖励
    --客户端发送
    [158] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 158 ) 
        NetManager:send_packet( np )
    end,

    --开服神兵进阶-客户端请求界面信息
    --客户端发送
    [161] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 161 ) 
        NetManager:send_packet( np )
    end,

    --开服神兵进阶-客户端领取奖励
    --客户端发送
    [162] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 162 ) 
        NetManager:send_packet( np )
    end,

    --开服战灵进阶-客户端请求界面信息
    --客户端发送
    [165] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 165 ) 
        NetManager:send_packet( np )
    end,

    --开服战灵进阶-客户端领取奖励
    --客户端发送
    [166] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 166 ) 
        NetManager:send_packet( np )
    end,

    --返利大厅（循环）.请求领取仙盾进阶信息
    --客户端发送
    [169] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 169 ) 
        NetManager:send_packet( np )
    end,

    --返利大厅（循环）.请求领取仙盾进阶礼包
    --客户端发送
    [170] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 170 ) 
        NetManager:send_packet( np )
    end,

    --返利大厅（循环）.请求影迹进阶信息
    --客户端发送
    [171] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 171 ) 
        NetManager:send_packet( np )
    end,

    --返利大厅（循环）.请求领取影迹进阶礼包
    --客户端发送
    [172] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 172 ) 
        NetManager:send_packet( np )
    end,

    --开服影迹进阶-客户端请求界面信息
    --客户端发送
    [173] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 173 ) 
        NetManager:send_packet( np )
    end,

    --开服影迹进阶-客户端领取奖励
    --客户端发送
    [174] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 174 ) 
        NetManager:send_packet( np )
    end,

    --返利大厅.请求仙遁排行信息
    --客户端发送
    [177] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 177 ) 
        NetManager:send_packet( np )
    end,

    --返利大厅.领取仙遁排行全民奖励
    --客户端发送
    [178] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 178 ) 
        NetManager:send_packet( np )
    end,

    --返利大厅.请求影迹排行信息
    --客户端发送
    [179] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 179 ) 
        NetManager:send_packet( np )
    end,

    --返利大厅.领取影迹排行全民奖励
    --客户端发送
    [180] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 180 ) 
        NetManager:send_packet( np )
    end,

    --返利大厅.请求神户排行信息
    --客户端发送
    [181] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 181 ) 
        NetManager:send_packet( np )
    end,

    --返利大厅.领取神户排行全民奖励
    --客户端发送
    [182] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 182 ) 
        NetManager:send_packet( np )
    end,

    --返利大厅（循环）.请求神户进阶信息
    --客户端发送
    [183] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 183 ) 
        NetManager:send_packet( np )
    end,

    --返利大厅（循环）.请求领取神户进阶礼包
    --客户端发送
    [184] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 161, 184 ) 
        NetManager:send_packet( np )
    end,


}



protocol_func_map_server[161] = {
    --（废弃）土豪送礼.图标控制协议
    --接收服务器
    [1] = function ( np )
        local var_1_int = np:readInt( ) --leftTime，活动剩余时间
        PacketDispatcher:dispather( 161, 1, var_1_int )--分发数据
    end,

    --返利大厅.总的活动状态协议
    --接收服务器
    [13] = function ( np )
        local var_1_int = np:readInt( ) --活动剩余时间，0活动结束
        local var_2_short = np:readShort( ) --合服结束后，返利大厅重新开始的第几天，小于等于0代表未合服或返利大厅，1代表重新开始第一天
        local var_3_unsigned_char = np:readByte( ) --使用第几套配置，1代表第一套。。。
        PacketDispatcher:dispather( 161, 13, var_1_int, var_2_short, var_3_unsigned_char )--分发数据
    end,

    --返利大厅.下发领取充值返利奖励结果
    --接收服务器
    [14] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --领取结果：0成功 1失败
        local var_2_unsigned_char = np:readByte( ) --奖励序号（见配置）从1开始
        local var_3_unsigned_short = np:readWord( ) --数量
        local var_4_unsigned_char = np:readByte( ) --奖励状态：0未达成 1可领取 2已领取
        PacketDispatcher:dispather( 161, 14, var_1_unsigned_char, var_2_unsigned_char, var_3_unsigned_short, var_4_unsigned_char )--分发数据
    end,

    --返利大厅.下发领取全民冲级奖励结果
    --接收服务器
    [17] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --领取结果：0成功 1失败
        local var_2_unsigned_char = np:readByte( ) --奖励序号（见配置）从1开始
        local var_3_unsigned_short = np:readWord( ) --剩余数量
        local var_4_unsigned_char = np:readByte( ) --奖励状态：0未达成 1可领取 2已领取
        PacketDispatcher:dispather( 161, 17, var_1_unsigned_char, var_2_unsigned_char, var_3_unsigned_short, var_4_unsigned_char )--分发数据
    end,

    --返利大厅.下发战力排行信息
    --接收服务器
    [20] = function ( np )
        local var_1_int = np:readInt( ) --第一名玩家：ID
        local var_2_string = np:readString( ) --第一名玩家：名字
        local var_3_unsigned_char = np:readByte( ) --第一名玩家：性别
        local var_4_unsigned_char = np:readByte( ) --第一名玩家：职业
        local var_5_unsigned_int = np:readUInt( ) --我当前的战力
        local var_6_unsigned_char = np:readByte( ) --我当前的名次，0表示未上榜
        PacketDispatcher:dispather( 161, 20, var_1_int, var_2_string, var_3_unsigned_char, var_4_unsigned_char, var_5_unsigned_int, var_6_unsigned_char )--分发数据
    end,

    --返利大厅.下发战力排行全民奖励状态
    --接收服务器
    [21] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --全民奖励状态：0未达成 1可领取 2已领取
        PacketDispatcher:dispather( 161, 21, var_1_unsigned_char )--分发数据
    end,

    --返利大厅.下发坐骑排行信息
    --接收服务器
    [22] = function ( np )
        local var_1_int = np:readInt( ) --第一名玩家：ID
        local var_2_string = np:readString( ) --第一名玩家：名字
        local var_3_unsigned_char = np:readByte( ) --第一名玩家：性别
        local var_4_unsigned_char = np:readByte( ) --第一名玩家：职业
        local var_5_unsigned_int = np:readUInt( ) --我当前的坐骑战力或阶数
        local var_6_unsigned_char = np:readByte( ) --我当前的名次，0表示未上榜
        PacketDispatcher:dispather( 161, 22, var_1_int, var_2_string, var_3_unsigned_char, var_4_unsigned_char, var_5_unsigned_int, var_6_unsigned_char )--分发数据
    end,

    --返利大厅.下发坐骑排行全民奖励状态
    --接收服务器
    [23] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --全民奖励状态：0未达成 1可领取 2已领取
        PacketDispatcher:dispather( 161, 23, var_1_unsigned_char )--分发数据
    end,

    --返利大厅.下发宠物排行信息
    --接收服务器
    [24] = function ( np )
        local var_1_int = np:readInt( ) --第一名玩家：ID
        local var_2_string = np:readString( ) --第一名玩家：名字
        local var_3_unsigned_char = np:readByte( ) --第一名玩家：性别
        local var_4_unsigned_char = np:readByte( ) --第一名玩家：职业
        local var_5_unsigned_int = np:readUInt( ) --我当前的宠物战力或阶数
        local var_6_unsigned_char = np:readByte( ) --我当前的名次，0表示未上榜
        PacketDispatcher:dispather( 161, 24, var_1_int, var_2_string, var_3_unsigned_char, var_4_unsigned_char, var_5_unsigned_int, var_6_unsigned_char )--分发数据
    end,

    --返利大厅.下发宠物排行全民奖励状态
    --接收服务器
    [25] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --全民奖励状态：0未达成 1可领取 2已领取
        PacketDispatcher:dispather( 161, 25, var_1_unsigned_char )--分发数据
    end,

    --返利大厅.下发宝石排行信息
    --接收服务器
    [26] = function ( np )
        local var_1_int = np:readInt( ) --第一名玩家：ID
        local var_2_string = np:readString( ) --第一名玩家：名字
        local var_3_unsigned_char = np:readByte( ) --第一名玩家：性别
        local var_4_unsigned_char = np:readByte( ) --第一名玩家：职业
        local var_5_unsigned_int = np:readUInt( ) --我当前的宝石等级
        local var_6_unsigned_char = np:readByte( ) --我当前的名次，0表示未上榜
        PacketDispatcher:dispather( 161, 26, var_1_int, var_2_string, var_3_unsigned_char, var_4_unsigned_char, var_5_unsigned_int, var_6_unsigned_char )--分发数据
    end,

    --返利大厅.下发宝石排行全民奖励状态
    --接收服务器
    [27] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --全民奖励状态：0未达成 1可领取 2已领取
        PacketDispatcher:dispather( 161, 27, var_1_unsigned_char )--分发数据
    end,

    --返利大厅.下发法宝排行信息
    --接收服务器
    [28] = function ( np )
        local var_1_int = np:readInt( ) --第一名玩家：ID
        local var_2_string = np:readString( ) --第一名玩家：名字
        local var_3_unsigned_char = np:readByte( ) --第一名玩家：性别
        local var_4_unsigned_char = np:readByte( ) --第一名玩家：职业
        local var_5_unsigned_int = np:readUInt( ) --我当前的法宝战力或阶数
        local var_6_unsigned_char = np:readByte( ) --我当前的名次，0表示未上榜
        PacketDispatcher:dispather( 161, 28, var_1_int, var_2_string, var_3_unsigned_char, var_4_unsigned_char, var_5_unsigned_int, var_6_unsigned_char )--分发数据
    end,

    --返利大厅.下发法宝排行全民奖励状态
    --接收服务器
    [29] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --全民奖励状态：0未达成 1可领取 2已领取
        PacketDispatcher:dispather( 161, 29, var_1_unsigned_char )--分发数据
    end,

    --返利大厅.下发幻羽排行信息
    --接收服务器
    [30] = function ( np )
        local var_1_int = np:readInt( ) --第一名玩家：ID
        local var_2_string = np:readString( ) --第一名玩家：名字
        local var_3_unsigned_char = np:readByte( ) --第一名玩家：性别
        local var_4_unsigned_char = np:readByte( ) --第一名玩家：职业
        local var_5_unsigned_int = np:readUInt( ) --我当前的幻羽战力或阶数
        local var_6_unsigned_char = np:readByte( ) --我当前的名次，0表示未上榜
        PacketDispatcher:dispather( 161, 30, var_1_int, var_2_string, var_3_unsigned_char, var_4_unsigned_char, var_5_unsigned_int, var_6_unsigned_char )--分发数据
    end,

    --返利大厅.下发幻羽排行全民奖励状态
    --接收服务器
    [31] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --全民奖励状态：0未达成 1可领取 2已领取
        PacketDispatcher:dispather( 161, 31, var_1_unsigned_char )--分发数据
    end,

    --返利大厅.下发购买新服超惠物品结果
    --接收服务器
    [33] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --购买结果：0成功 1失败
        local var_2_unsigned_char = np:readByte( ) --物品序号（见配置）从1开始
        local var_3_int = np:readInt( ) --剩余数量：-1表示无限
        PacketDispatcher:dispather( 161, 33, var_1_unsigned_char, var_2_unsigned_char, var_3_int )--分发数据
    end,

    --返利大厅.下发龙鳞大兑换之兑换结果
    --接收服务器
    [35] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --兑换结果：0成功 1失败
        local var_2_unsigned_char = np:readByte( ) --序号（见配置）从1开始
        local var_3_char = np:readChar( ) --剩余数量 -1表示无限
        PacketDispatcher:dispather( 161, 35, var_1_unsigned_char, var_2_unsigned_char, var_3_char )--分发数据
    end,

    --返利大厅.下发强化排行信息
    --接收服务器
    [37] = function ( np )
        local var_1_int = np:readInt( ) --第一名玩家：ID
        local var_2_string = np:readString( ) --第一名玩家：名字
        local var_3_unsigned_char = np:readByte( ) --第一名玩家：性别
        local var_4_unsigned_char = np:readByte( ) --第一名玩家：职业
        local var_5_unsigned_int = np:readUInt( ) --我当前的强化等级
        local var_6_unsigned_char = np:readByte( ) --我当前的名次，0表示未上榜
        PacketDispatcher:dispather( 161, 37, var_1_int, var_2_string, var_3_unsigned_char, var_4_unsigned_char, var_5_unsigned_int, var_6_unsigned_char )--分发数据
    end,

    --返利大厅.下发强化排行全民奖励状态
    --接收服务器
    [38] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --全民奖励状态：0未达成 1可领取 2已领取
        PacketDispatcher:dispather( 161, 38, var_1_unsigned_char )--分发数据
    end,

    --问鼎龙破.总活动控制协议
    --接收服务器
    [40] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --多少个活动时间
        local var_2_int = np:readInt( ) --总活动：活动剩余时间（单位秒），0表示活动结束
        local var_3_int = np:readInt( ) --boss争霸：活动剩余时间（单位秒），0表示活动结束
        local var_4_int = np:readInt( ) --城主活动：活动剩余时间（单位秒），0表示活动结束
        local var_5_int = np:readInt( ) --苍穹活动：活动剩余时间（单位秒），0表示活动结束
        local var_6_int = np:readInt( ) --战神活动：活动剩余时间（单位秒），0表示活动结束
        local var_7_int = np:readInt( ) --领地活动：活动剩余时间（单位秒），0表示活动结束
        PacketDispatcher:dispather( 161, 40, var_1_unsigned_char, var_2_int, var_3_int, var_4_int, var_5_int, var_6_int, var_7_int )--分发数据
    end,

    --问鼎龙破.下发boss争霸信息
    --接收服务器
    [41] = function ( np )
        local var_1_string = np:readString( ) --第一帮派名
        local var_2_string = np:readString( ) --第一帮派帮主名
        local var_3_string = np:readString( ) --我的帮派名
        local var_4_int = np:readInt( ) --我的帮派排名
        local var_5_int = np:readInt( ) --我的帮派积分
        local var_6_int = np:readInt( ) --我参加的次数
        local var_7_unsigned_char = np:readByte( ) --0表示不可领取，1表示可领取，2表示已领取
        PacketDispatcher:dispather( 161, 41, var_1_string, var_2_string, var_3_string, var_4_int, var_5_int, var_6_int, var_7_unsigned_char )--分发数据
    end,

    --问鼎龙破.下发帮派争霸信息
    --接收服务器
    [44] = function ( np )
        local var_1_string = np:readString( ) --第一帮派名
        local var_2_string = np:readString( ) --第一帮派帮主名
        local var_3_string = np:readString( ) --我的帮派名
        local var_4_int = np:readInt( ) --我的帮派排名
        local var_5_int = np:readInt( ) --我的帮派积分
        local var_6_int = np:readInt( ) --我参加的次数
        local var_7_unsigned_char = np:readByte( ) --0表示不可领取，1表示可领取，2表示已领取
        PacketDispatcher:dispather( 161, 44, var_1_string, var_2_string, var_3_string, var_4_int, var_5_int, var_6_int, var_7_unsigned_char )--分发数据
    end,

    --问鼎龙破.下发运镖争霸信息
    --接收服务器
    [50] = function ( np )
        PacketDispatcher:dispather( 161, 50 )--分发数据
    end,

    --问鼎龙破.下发运镖争霸排行榜信息
    --接收服务器
    [51] = function ( np )
        PacketDispatcher:dispather( 161, 51 )--分发数据
    end,

    --问鼎龙破.下发劫镖争霸信息
    --接收服务器
    [53] = function ( np )
        PacketDispatcher:dispather( 161, 53 )--分发数据
    end,

    --问鼎龙破.下发劫镖争霸排行版信息
    --接收服务器
    [54] = function ( np )
        PacketDispatcher:dispather( 161, 54 )--分发数据
    end,

    --问鼎龙破.下发渡劫争霸信息
    --接收服务器
    [56] = function ( np )
        PacketDispatcher:dispather( 161, 56 )--分发数据
    end,

    --问鼎龙破.下发渡劫争霸排行榜信息
    --接收服务器
    [57] = function ( np )
        PacketDispatcher:dispather( 161, 57 )--分发数据
    end,

    --问鼎龙破.客户端请求领取战神争霸全民礼包
    --接收服务器
    [61] = function ( np )
        PacketDispatcher:dispather( 161, 61 )--分发数据
    end,

    --问鼎龙破.下发战神争霸排行榜信息
    --接收服务器
    [60] = function ( np )
        PacketDispatcher:dispather( 161, 60 )--分发数据
    end,

    --开服宠物进阶-应答客户端请求界面信息
    --接收服务器
    [64] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --index--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_unsigned_char = np:readByte( ) --canGet，是否可以领奖，0:不可以，1:可以，2:已经领取
        PacketDispatcher:dispather( 161, 64, var_1_unsigned_char, var_2_unsigned_char )--分发数据
    end,

    --开服宠物进阶-活动剩余时间
    --接收服务器
    [65] = function ( np )
        local var_1_int = np:readInt( ) --leftTime，0:活动结束。
        PacketDispatcher:dispather( 161, 65, var_1_int )--分发数据
    end,

    --开服翅膀进阶-下发活动状态
    --接收服务器
    [67] = function ( np )
        local var_1_int = np:readInt( ) --活动剩余时间（单位秒），0表示活动结束
        PacketDispatcher:dispather( 161, 67, var_1_int )--分发数据
    end,

    --开服翅膀进阶-下发界面信息
    --接收服务器
    [68] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --返还礼包，0表示不可领取，1表示可领取，2表示已领取
        local var_2_int = np:readInt( ) --a-b使用总数量
        PacketDispatcher:dispather( 161, 68, var_1_unsigned_char, var_2_int )--分发数据
    end,

    --开服坐骑进阶-应答客户端请求界面信息
    --接收服务器
    [69] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --index--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_unsigned_char = np:readByte( ) --canGet，是否可以领奖，0:不可以，1:可以，2:已经领取
        PacketDispatcher:dispather( 161, 69, var_1_unsigned_char, var_2_unsigned_char )--分发数据
    end,

    --开服坐骑进阶-活动剩余时间
    --接收服务器
    [70] = function ( np )
        local var_1_int = np:readInt( ) --leftTime，0:活动结束。
        PacketDispatcher:dispather( 161, 70, var_1_int )--分发数据
    end,

    --（废弃）土豪活动-下发宝石等级信息
    --接收服务器
    [83] = function ( np )
        PacketDispatcher:dispather( 161, 83 )--分发数据
    end,

    --返利大厅（循环）.下发领取充值返利奖励结果
    --接收服务器
    [100] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --领取结果：0成功 1失败
        local var_2_unsigned_char = np:readByte( ) --奖励序号（见配置）从1开始
        local var_3_unsigned_short = np:readWord( ) --数量
        local var_4_unsigned_char = np:readByte( ) --奖励状态：0未达成 1可领取 2已领取
        PacketDispatcher:dispather( 161, 100, var_1_unsigned_char, var_2_unsigned_char, var_3_unsigned_short, var_4_unsigned_char )--分发数据
    end,

    --返利大厅（循环）.下发购买新服超惠物品结果
    --接收服务器
    [104] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --购买结果：0成功 1失败
        local var_2_unsigned_char = np:readByte( ) --物品序号（见配置）从1开始
        local var_3_int = np:readInt( ) --剩余数量：-1表示无限
        PacketDispatcher:dispather( 161, 104, var_1_unsigned_char, var_2_unsigned_char, var_3_int )--分发数据
    end,

    --返利大厅（循环）.下发坐骑排行信息
    --接收服务器
    [105] = function ( np )
        local var_1_int = np:readInt( ) --第一名玩家：ID
        local var_2_string = np:readString( ) --第一名玩家：名字
        local var_3_unsigned_char = np:readByte( ) --第一名玩家：性别
        local var_4_unsigned_char = np:readByte( ) --第一名玩家：职业
        local var_5_unsigned_int = np:readUInt( ) --我当前的坐骑战力或阶数
        local var_6_unsigned_char = np:readByte( ) --我当前的名次，0表示未上榜
        PacketDispatcher:dispather( 161, 105, var_1_int, var_2_string, var_3_unsigned_char, var_4_unsigned_char, var_5_unsigned_int, var_6_unsigned_char )--分发数据
    end,

    --返利大厅（循环）.下发坐骑排行全民奖励状态
    --接收服务器
    [106] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --全民奖励状态：0未达成 1可领取 2已领取
        PacketDispatcher:dispather( 161, 106, var_1_unsigned_char )--分发数据
    end,

    --返利大厅（循环）.下发宠物排行信息
    --接收服务器
    [107] = function ( np )
        local var_1_int = np:readInt( ) --第一名玩家：ID
        local var_2_string = np:readString( ) --第一名玩家：名字
        local var_3_unsigned_char = np:readByte( ) --第一名玩家：性别
        local var_4_unsigned_char = np:readByte( ) --第一名玩家：职业
        local var_5_unsigned_int = np:readUInt( ) --我当前的宠物战力或阶数
        local var_6_unsigned_char = np:readByte( ) --我当前的名次，0表示未上榜
        PacketDispatcher:dispather( 161, 107, var_1_int, var_2_string, var_3_unsigned_char, var_4_unsigned_char, var_5_unsigned_int, var_6_unsigned_char )--分发数据
    end,

    --返利大厅（循环）.下发宠物排行全民奖励状态
    --接收服务器
    [108] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --全民奖励状态：0未达成 1可领取 2已领取
        PacketDispatcher:dispather( 161, 108, var_1_unsigned_char )--分发数据
    end,

    --返利大厅（循环）.下发法宝排行信息
    --接收服务器
    [109] = function ( np )
        local var_1_int = np:readInt( ) --第一名玩家：ID
        local var_2_string = np:readString( ) --第一名玩家：名字
        local var_3_unsigned_char = np:readByte( ) --第一名玩家：性别
        local var_4_unsigned_char = np:readByte( ) --第一名玩家：职业
        local var_5_unsigned_int = np:readUInt( ) --我当前的法宝战力或阶数
        local var_6_unsigned_char = np:readByte( ) --我当前的名次，0表示未上榜
        PacketDispatcher:dispather( 161, 109, var_1_int, var_2_string, var_3_unsigned_char, var_4_unsigned_char, var_5_unsigned_int, var_6_unsigned_char )--分发数据
    end,

    --返利大厅（循环）.下发法宝排行全民奖励状态
    --接收服务器
    [110] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --全民奖励状态：0未达成 1可领取 2已领取
        PacketDispatcher:dispather( 161, 110, var_1_unsigned_char )--分发数据
    end,

    --返利大厅（循环）.下发幻羽排行信息
    --接收服务器
    [111] = function ( np )
        local var_1_int = np:readInt( ) --第一名玩家：ID
        local var_2_string = np:readString( ) --第一名玩家：名字
        local var_3_unsigned_char = np:readByte( ) --第一名玩家：性别
        local var_4_unsigned_char = np:readByte( ) --第一名玩家：职业
        local var_5_unsigned_int = np:readUInt( ) --我当前的幻羽战力或阶数
        local var_6_unsigned_char = np:readByte( ) --我当前的名次，0表示未上榜
        PacketDispatcher:dispather( 161, 111, var_1_int, var_2_string, var_3_unsigned_char, var_4_unsigned_char, var_5_unsigned_int, var_6_unsigned_char )--分发数据
    end,

    --返利大厅（循环）.下发幻羽排行全民奖励状态
    --接收服务器
    [112] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --全民奖励状态：0未达成 1可领取 2已领取
        PacketDispatcher:dispather( 161, 112, var_1_unsigned_char )--分发数据
    end,

    --返利大厅（循环）.下发强化排行信息
    --接收服务器
    [113] = function ( np )
        local var_1_int = np:readInt( ) --第一名玩家：ID
        local var_2_string = np:readString( ) --第一名玩家：名字
        local var_3_unsigned_char = np:readByte( ) --第一名玩家：性别
        local var_4_unsigned_char = np:readByte( ) --第一名玩家：职业
        local var_5_unsigned_int = np:readUInt( ) --我当前的强化等级
        local var_6_unsigned_char = np:readByte( ) --我当前的名次，0表示未上榜
        PacketDispatcher:dispather( 161, 113, var_1_int, var_2_string, var_3_unsigned_char, var_4_unsigned_char, var_5_unsigned_int, var_6_unsigned_char )--分发数据
    end,

    --返利大厅（循环）.下发强化排行全民奖励状态
    --接收服务器
    [114] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --全民奖励状态：0未达成 1可领取 2已领取
        PacketDispatcher:dispather( 161, 114, var_1_unsigned_char )--分发数据
    end,

    --每日抽奖-下发活动状态
    --接收服务器
    [120] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --0,不开启，1开启
        local var_2_unsigned_char = np:readByte( ) --1：配置1,2：配置2
        local var_3_unsigned_char = np:readByte( ) --1：非循环配置，2：循环配置
        local var_4_unsigned_char = np:readByte( ) --配置index，从1开始
        PacketDispatcher:dispather( 161, 120, var_1_unsigned_char, var_2_unsigned_char, var_3_unsigned_char, var_4_unsigned_char )--分发数据
    end,

    --每日抽奖-下发抽奖信息
    --接收服务器
    [121] = function ( np )
        local var_1_int = np:readInt( ) --今日充值元宝
        local var_2_int = np:readInt( ) --今日剩余次数
        PacketDispatcher:dispather( 161, 121, var_1_int, var_2_int )--分发数据
    end,

    --每日抽奖-更新抽奖记录
    --接收服务器
    [123] = function ( np )
        local var_1_string = np:readString( ) --玩家名字
        local var_2_int = np:readInt( ) --道具id
        PacketDispatcher:dispather( 161, 123, var_1_string, var_2_int )--分发数据
    end,

    --每日抽奖-下发抽到的物品index
    --接收服务器
    [124] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --抽到的物品index
        PacketDispatcher:dispather( 161, 124, var_1_unsigned_char )--分发数据
    end,

    --返利大厅.下发单个活动可领取奖励数量
    --接收服务器
    [130] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --活动的索引
        local var_2_unsigned_char = np:readByte( ) --数量
        PacketDispatcher:dispather( 161, 130, var_1_unsigned_char, var_2_unsigned_char )--分发数据
    end,

    --返利大厅.下发神兵排行信息
    --接收服务器
    [131] = function ( np )
        local var_1_int = np:readInt( ) --第一名玩家：ID
        local var_2_string = np:readString( ) --第一名玩家：名字
        local var_3_unsigned_char = np:readByte( ) --第一名玩家：性别
        local var_4_unsigned_char = np:readByte( ) --第一名玩家：职业
        local var_5_unsigned_int = np:readUInt( ) --我当前的神兵战力或阶数
        local var_6_unsigned_char = np:readByte( ) --我当前的名次，0表示未上榜
        PacketDispatcher:dispather( 161, 131, var_1_int, var_2_string, var_3_unsigned_char, var_4_unsigned_char, var_5_unsigned_int, var_6_unsigned_char )--分发数据
    end,

    --返利大厅.下发神兵排行全民奖励状态
    --接收服务器
    [132] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --全民奖励状态：0未达成 1可领取 2已领取
        PacketDispatcher:dispather( 161, 132, var_1_unsigned_char )--分发数据
    end,

    --返利大厅（循环）.下发神兵排行信息
    --接收服务器
    [133] = function ( np )
        local var_1_int = np:readInt( ) --第一名玩家：ID
        local var_2_string = np:readString( ) --第一名玩家：名字
        local var_3_unsigned_char = np:readByte( ) --第一名玩家：性别
        local var_4_unsigned_char = np:readByte( ) --第一名玩家：职业
        local var_5_unsigned_int = np:readUInt( ) --我当前的神兵战力或阶数
        local var_6_unsigned_char = np:readByte( ) --我当前的名次，0表示未上榜
        PacketDispatcher:dispather( 161, 133, var_1_int, var_2_string, var_3_unsigned_char, var_4_unsigned_char, var_5_unsigned_int, var_6_unsigned_char )--分发数据
    end,

    --返利大厅（循环）.下发神兵排行全民奖励状态
    --接收服务器
    [134] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --全民奖励状态：0未达成 1可领取 2已领取
        PacketDispatcher:dispather( 161, 134, var_1_unsigned_char )--分发数据
    end,

    --问鼎龙破-服务端返回领地争霸信息
    --接收服务器
    [140] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --第几次
        local var_2_int = np:readInt( ) --第一帮派帮主id
        local var_3_string = np:readString( ) --第一帮派名
        local var_4_string = np:readString( ) --第一帮派帮主名
        local var_5_int = np:readInt( ) --我的帮派占领领地个数
        local var_6_int = np:readInt( ) --我参加的次数
        local var_7_unsigned_char = np:readByte( ) --全民奖励状态，0不可领，1可领，2已领
        PacketDispatcher:dispather( 161, 140, var_1_unsigned_char, var_2_int, var_3_string, var_4_string, var_5_int, var_6_int, var_7_unsigned_char )--分发数据
    end,

    --在线奖励元宝活动状态
    --接收服务器
    [145] = function ( np )
        local var_1_int = np:readInt( ) --活动剩余时间（单位秒），0表示活动结束
        PacketDispatcher:dispather( 161, 145, var_1_int )--分发数据
    end,

    --下发在线奖励元宝信息
    --接收服务器
    [146] = function ( np )
        local var_1_int = np:readInt( ) --累积在线时间
        local var_2_int = np:readInt( ) --可领物品奖励次数
        local var_3_int = np:readInt( ) --已用物品奖励次数
        local var_4_int = np:readInt( ) --可点金次数
        local var_5_int = np:readInt( ) --已使用点金次数
        PacketDispatcher:dispather( 161, 146, var_1_int, var_2_int, var_3_int, var_4_int, var_5_int )--分发数据
    end,

    --商城限时购买。下发限时购买数据
    --接收服务器
    [148] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --奖励是否已发，0为未发，1已发
        local var_2_unsigned_char = np:readByte( ) --连续购买天数
        local var_3_unsigned_char = np:readByte( ) --当前是第几轮，0是第一轮，1是第二轮及以后
        PacketDispatcher:dispather( 161, 148, var_1_unsigned_char, var_2_unsigned_char, var_3_unsigned_char )--分发数据
    end,

    --返利大厅.下发法阵排行信息
    --接收服务器
    [149] = function ( np )
        local var_1_int = np:readInt( ) --第一名玩家：ID
        local var_2_string = np:readString( ) --第一名玩家：名字
        local var_3_unsigned_char = np:readByte( ) --第一名玩家：性别
        local var_4_unsigned_char = np:readByte( ) --第一名玩家：职业
        local var_5_unsigned_int = np:readUInt( ) --我当前的法阵战力或阶数
        local var_6_unsigned_char = np:readByte( ) --我当前的名次，0表示未上榜
        PacketDispatcher:dispather( 161, 149, var_1_int, var_2_string, var_3_unsigned_char, var_4_unsigned_char, var_5_unsigned_int, var_6_unsigned_char )--分发数据
    end,

    --返利大厅.下发法阵排行全民奖励状态
    --接收服务器
    [150] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --全民奖励状态：0未达成 1可领取 2已领取
        PacketDispatcher:dispather( 161, 150, var_1_unsigned_char )--分发数据
    end,

    --返利大厅.下发战灵排行信息
    --接收服务器
    [153] = function ( np )
        local var_1_int = np:readInt( ) --第一名玩家：ID
        local var_2_string = np:readString( ) --第一名玩家：名字
        local var_3_unsigned_char = np:readByte( ) --第一名玩家：性别
        local var_4_unsigned_char = np:readByte( ) --第一名玩家：职业
        local var_5_unsigned_int = np:readUInt( ) --我当前的战灵战力或阶数
        local var_6_unsigned_char = np:readByte( ) --我当前的名次，0表示未上榜
        PacketDispatcher:dispather( 161, 153, var_1_int, var_2_string, var_3_unsigned_char, var_4_unsigned_char, var_5_unsigned_int, var_6_unsigned_char )--分发数据
    end,

    --返利大厅.下发战灵排行全民奖励状态
    --接收服务器
    [154] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --全民奖励状态：0未达成 1可领取 2已领取
        PacketDispatcher:dispather( 161, 154, var_1_unsigned_char )--分发数据
    end,

    --开服法阵进阶-应答客户端请求界面信息
    --接收服务器
    [159] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --index--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_unsigned_char = np:readByte( ) --canGet，是否可以领奖，0:不可以，1:可以，2:已经领取
        PacketDispatcher:dispather( 161, 159, var_1_unsigned_char, var_2_unsigned_char )--分发数据
    end,

    --开服法阵进阶-活动剩余时间
    --接收服务器
    [160] = function ( np )
        local var_1_int = np:readInt( ) --leftTime，0:活动结束。
        PacketDispatcher:dispather( 161, 160, var_1_int )--分发数据
    end,

    --开服神兵进阶-应答客户端请求界面信息
    --接收服务器
    [163] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --index--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_unsigned_char = np:readByte( ) --canGet，是否可以领奖，0:不可以，1:可以，2:已经领取
        PacketDispatcher:dispather( 161, 163, var_1_unsigned_char, var_2_unsigned_char )--分发数据
    end,

    --开服神兵进阶-活动剩余时间
    --接收服务器
    [164] = function ( np )
        local var_1_int = np:readInt( ) --leftTime，0:活动结束。
        PacketDispatcher:dispather( 161, 164, var_1_int )--分发数据
    end,

    --开服战灵进阶-应答客户端请求界面信息
    --接收服务器
    [167] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --index--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_unsigned_char = np:readByte( ) --canGet，是否可以领奖，0:不可以，1:可以，2:已经领取
        PacketDispatcher:dispather( 161, 167, var_1_unsigned_char, var_2_unsigned_char )--分发数据
    end,

    --开服战灵进阶-活动剩余时间
    --接收服务器
    [168] = function ( np )
        local var_1_int = np:readInt( ) --leftTime，0:活动结束。
        PacketDispatcher:dispather( 161, 168, var_1_int )--分发数据
    end,

    --返利大厅（循环）.下发仙盾进阶信息
    --接收服务器
    [169] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --列表长度
        local var_2_unsigned_char = np:readByte( ) --礼包列表--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 161, 169, var_1_unsigned_char, var_2_unsigned_char )--分发数据
    end,

    --开服影迹进阶-应答客户端请求界面信息
    --接收服务器
    [175] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --index--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_unsigned_char = np:readByte( ) --canGet，是否可以领奖，0:不可以，1:可以，2:已经领取
        PacketDispatcher:dispather( 161, 175, var_1_unsigned_char, var_2_unsigned_char )--分发数据
    end,

    --开服影迹进阶-活动剩余时间
    --接收服务器
    [176] = function ( np )
        local var_1_int = np:readInt( ) --leftTime，0:活动结束。
        PacketDispatcher:dispather( 161, 176, var_1_int )--分发数据
    end,

    --返利大厅.下发仙遁排行信息
    --接收服务器
    [177] = function ( np )
        local var_1_int = np:readInt( ) --第一名玩家：ID
        local var_2_string = np:readString( ) --第一名玩家：名字
        local var_3_unsigned_char = np:readByte( ) --第一名玩家：性别
        local var_4_unsigned_char = np:readByte( ) --第一名玩家：职业
        local var_5_unsigned_int = np:readUInt( ) --我当前的仙遁战力或阶数
        local var_6_unsigned_char = np:readByte( ) --我当前的名次，0表示未上榜
        PacketDispatcher:dispather( 161, 177, var_1_int, var_2_string, var_3_unsigned_char, var_4_unsigned_char, var_5_unsigned_int, var_6_unsigned_char )--分发数据
    end,

    --返利大厅.下发仙遁排行全民奖励状态
    --接收服务器
    [178] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --全民奖励状态：0未达成 1可领取 2已领取
        PacketDispatcher:dispather( 161, 178, var_1_unsigned_char )--分发数据
    end,

    --返利大厅.下发影迹排行信息
    --接收服务器
    [179] = function ( np )
        local var_1_int = np:readInt( ) --第一名玩家：ID
        local var_2_string = np:readString( ) --第一名玩家：名字
        local var_3_unsigned_char = np:readByte( ) --第一名玩家：性别
        local var_4_unsigned_char = np:readByte( ) --第一名玩家：职业
        local var_5_unsigned_int = np:readUInt( ) --我当前的影迹战力或阶数
        local var_6_unsigned_char = np:readByte( ) --我当前的名次，0表示未上榜
        PacketDispatcher:dispather( 161, 179, var_1_int, var_2_string, var_3_unsigned_char, var_4_unsigned_char, var_5_unsigned_int, var_6_unsigned_char )--分发数据
    end,

    --返利大厅.下发影迹排行全民奖励状态
    --接收服务器
    [180] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --全民奖励状态：0未达成 1可领取 2已领取
        PacketDispatcher:dispather( 161, 180, var_1_unsigned_char )--分发数据
    end,

    --返利大厅.下发神户排行信息
    --接收服务器
    [181] = function ( np )
        local var_1_int = np:readInt( ) --第一名玩家：ID
        local var_2_string = np:readString( ) --第一名玩家：名字
        local var_3_unsigned_char = np:readByte( ) --第一名玩家：性别
        local var_4_unsigned_char = np:readByte( ) --第一名玩家：职业
        local var_5_unsigned_int = np:readUInt( ) --我当前的神户战力或阶数
        local var_6_unsigned_char = np:readByte( ) --我当前的名次，0表示未上榜
        PacketDispatcher:dispather( 161, 181, var_1_int, var_2_string, var_3_unsigned_char, var_4_unsigned_char, var_5_unsigned_int, var_6_unsigned_char )--分发数据
    end,

    --返利大厅.下发神户排行全民奖励状态
    --接收服务器
    [182] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --全民奖励状态：0未达成 1可领取 2已领取
        PacketDispatcher:dispather( 161, 182, var_1_unsigned_char )--分发数据
    end,


}
