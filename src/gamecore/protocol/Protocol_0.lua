protocol_func_map_client[0] = {
    --对应服务器下发的消息号22，用户点击某个按钮后，传这条信息到服务器
    --客户端发送
    [6] = function ( 
                param_1_unsigned_int64,  -- Npc的handle--c本参数存在特殊说明，请查阅协议编辑器
                param_2_unsigned_char,  -- 点击的按钮的索引--c本参数存在特殊说明，请查阅协议编辑器
                param_3_int -- 唯一的消息号
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_int64, lua_type = "number" }, { param_name = param_2_unsigned_char, lua_type = "number" }, { param_name = param_3_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 0, 6 ) 
        np:writeUint64( param_1_unsigned_int64 )
        np:writeByte( param_2_unsigned_char )
        np:writeInt( param_3_int )
        NetManager:send_packet( np )
    end,

    --登陆游戏
    --客户端发送
    [1] = function ( 
                param_1_unsigned_int,  -- accountID
                param_2_unsigned_int -- actorid
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_int, lua_type = "number" }, { param_name = param_2_unsigned_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 0, 1 ) 
        np:writeUInt( param_1_unsigned_int )
        np:writeUInt( param_2_unsigned_int )
        NetManager:send_packet( np )
    end,

    --心跳包
    --客户端发送
    [2] = function ( 
                param_1_unsigned_int -- 时钟
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 0, 2 ) 
        np:writeUInt( param_1_unsigned_int )
        NetManager:send_packet( np )
    end,

    --选择一个实体为目标
    --客户端发送
    [3] = function ( 
                param_1_int64 -- handle
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int64, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 0, 3 ) 
        np:writeInt64( param_1_int64 )
        NetManager:send_packet( np )
    end,

    --设置鼠标的位置(貌似没用到)
    --客户端发送
    [4] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 0, 4 ) 
        NetManager:send_packet( np )
    end,

    --与NPC对话
    --客户端发送
    [5] = function ( 
                param_1_int64,  -- NPC的handle--c本参数存在特殊说明，请查阅协议编辑器
                param_2_string -- 会话的内容
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int64, lua_type = "number" }, { param_name = param_2_string, lua_type = "string" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 0, 5 ) 
        np:writeInt64( param_1_int64 )
        np:writeString( param_2_string )
        NetManager:send_packet( np )
    end,

    --心跳包
    --客户端发送
    [7] = function ( 
                param_1_unsigned_int -- 发包时间
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 0, 7 ) 
        np:writeUInt( param_1_unsigned_int )
        NetManager:send_packet( np )
    end,

    --客户端打开了一个窗口，或点击某按钮，用于完成任务
    --客户端发送
    [12] = function ( 
                param_1_int -- 窗口id，不是所有都需要发到服务端，只有要完成任务的才用--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 0, 12 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,


}



protocol_func_map_server[0] = {
    --给目标添加特效
    --接收服务器
    [19] = function ( np )
        local var_1_int64 = np:readInt64( ) --施法者的handle
        local var_2_int64 = np:readInt64( ) --目标实体的handle
        local var_3_unsigned_char = np:readByte( ) --特效类型
        local var_4_unsigned_short = np:readWord( ) --特效ID
        local var_5_int = np:readInt( ) --剩余时间(单位毫秒)--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 0, 19, var_1_int64, var_2_int64, var_3_unsigned_char, var_4_unsigned_short, var_5_int )--分发数据
    end,

    --要求客户端显示一个弹出对话框，对话框可包含多个按钮，用户点击某个按钮后将执行脚本函数
    --接收服务器
    [22] = function ( np )
        local var_1_unsigned_int64 = np:readUint64( ) --npc的handle，--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_string = np:readString( ) --标题文本--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_unsigned_char = np:readByte( ) --按钮的数量--s本参数存在特殊说明，请查阅协议编辑器
        local var_4_string = np:readString( ) --每个按钮的文本--s本参数存在特殊说明，请查阅协议编辑器
        local var_5_unsigned_int = np:readUInt( ) --对话框存在的时间--s本参数存在特殊说明，请查阅协议编辑器
        local var_6_int = np:readInt( ) --消息的唯一消息号
        local var_7_unsigned_char = np:readByte( ) --弹出的类型--s本参数存在特殊说明，请查阅协议编辑器
        local var_8_string = np:readString( ) --tip--s本参数存在特殊说明，请查阅协议编辑器
        local var_9_unsigned_short = np:readWord( ) --图标id
        local var_10_int = np:readInt( ) --超时后返回的按钮id，-1表示不返回
        local var_11_unsigned_char = np:readByte( ) --是否有关闭按钮--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 0, 22, var_1_unsigned_int64, var_2_string, var_3_unsigned_char, var_4_string, var_5_unsigned_int, var_6_int, var_7_unsigned_char, var_8_string, var_9_unsigned_short, var_10_int, var_11_unsigned_char )--分发数据
    end,

    --实体消失
    --接收服务器
    [5] = function ( np )
        local var_1_int64 = np:readInt64( ) --实体的handle 
        PacketDispatcher:dispather( 0, 5, var_1_int64 )--分发数据
    end,

    --停止玩家移动
    --接收服务器
    [8] = function ( np )
        local var_1_int64 = np:readInt64( ) --实体的handle
        local var_2_int = np:readInt( ) --停止的位置x--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_int = np:readInt( ) --位置y
        PacketDispatcher:dispather( 0, 8, var_1_int64, var_2_int, var_3_int )--分发数据
    end,

    --其他实体的移动
    --接收服务器
    [9] = function ( np )
        local var_1_int64 = np:readInt64( ) --实体的handle
        local var_2_int = np:readInt( ) --当前的x坐标
        local var_3_int = np:readInt( ) --y坐标
        local var_4_int = np:readInt( ) --移动的目标x坐标
        local var_5_int = np:readInt( ) --y
        PacketDispatcher:dispather( 0, 9, var_1_int64, var_2_int, var_3_int, var_4_int, var_5_int )--分发数据
    end,

    --心跳包
    --接收服务器
    [10] = function ( np )
        PacketDispatcher:dispather( 0, 10 )--分发数据
    end,

    --NPC对话
    --接收服务器
    [11] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --成功的标记
        local var_2_int64 = np:readInt64( ) --实体的句柄
        local var_3_string = np:readString( ) --对话内容
        PacketDispatcher:dispather( 0, 11, var_1_unsigned_char, var_2_int64, var_3_string )--分发数据
    end,

    --打开(或关闭）窗口
    --接收服务器
    [12] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --窗口的ID
        local var_2_unsigned_char = np:readByte( ) --关闭还是打开--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_string = np:readString( ) --打开窗口传递的参数--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 0, 12, var_1_unsigned_char, var_2_unsigned_char, var_3_string )--分发数据
    end,

    --进入场景
    --接收服务器
    [13] = function ( np )
        local var_1_unsigned_short = np:readWord( ) --副本id
        local var_2_unsigned_short = np:readWord( ) --场景的id
        local var_3_int = np:readInt( ) --x
        local var_4_int = np:readInt( ) --y
        local var_5_int = np:readInt( ) --是否继续寻路--s本参数存在特殊说明，请查阅协议编辑器
        local var_6_string = np:readString( ) --场景的名字
        local var_7_string = np:readString( ) --场景的地图名字
        local var_8_string = np:readString( ) --天元城城主的名字
        PacketDispatcher:dispather( 0, 13, var_1_unsigned_short, var_2_unsigned_short, var_3_int, var_4_int, var_5_int, var_6_string, var_7_string, var_8_string )--分发数据
    end,

    --实体掉血（原实体近距离传送）
    --接收服务器
    [14] = function ( np )
        local var_1_int64 = np:readInt64( ) --实体handle
        local var_2_int = np:readInt( ) --变化血量，负数表示减血，正数加血
        local var_3_unsigned_int64 = np:readUint64( ) --造成掉血的来源handle
        PacketDispatcher:dispather( 0, 14, var_1_int64, var_2_int, var_3_unsigned_int64 )--分发数据
    end,

    --玩家在原地停止移动
    --接收服务器
    [15] = function ( np )
        local var_1_int64 = np:readInt64( ) --实体handle
        PacketDispatcher:dispather( 0, 15, var_1_int64 )--分发数据
    end,

    --实体开始吟唱
    --接收服务器
    [16] = function ( np )
        local var_1_int64 = np:readInt64( ) --实体的句柄
        local var_2_unsigned_char = np:readByte( ) --方向
        local var_3_unsigned_int = np:readUInt( ) --剩余时间，单位毫秒
        local var_4_unsigned_int = np:readUInt( ) --吟唱特效id
        local var_5_unsigned_int = np:readUInt( ) --技能ID
        PacketDispatcher:dispather( 0, 16, var_1_int64, var_2_unsigned_char, var_3_unsigned_int, var_4_unsigned_int, var_5_unsigned_int )--分发数据
    end,

    --实体结束吟唱
    --接收服务器
    [17] = function ( np )
        local var_1_int64 = np:readInt64( ) --实体的局句柄
        PacketDispatcher:dispather( 0, 17, var_1_int64 )--分发数据
    end,

    --开始释放技能
    --接收服务器
    [18] = function ( np )
        local var_1_int64 = np:readInt64( ) --实体的句柄
        local var_2_unsigned_short = np:readWord( ) --技能的id
        local var_3_unsigned_char = np:readByte( ) --技能的等级
        local var_4_unsigned_char = np:readByte( ) --释放者技能的朝向
        PacketDispatcher:dispather( 0, 18, var_1_int64, var_2_unsigned_short, var_3_unsigned_char, var_4_unsigned_char )--分发数据
    end,

    --实体受击
    --接收服务器
    [20] = function ( np )
        local var_1_int64 = np:readInt64( ) --实体的句柄
        PacketDispatcher:dispather( 0, 20, var_1_int64 )--分发数据
    end,

    --实体瞬移
    --接收服务器
    [23] = function ( np )
        local var_1_unsigned_int64 = np:readUint64( ) --实体handle
        local var_2_unsigned_short = np:readWord( ) --源x，格子坐标（下同）
        local var_3_unsigned_short = np:readWord( ) --源y
        local var_4_unsigned_short = np:readWord( ) --目的地x
        local var_5_unsigned_short = np:readWord( ) --目的地y
        local var_6_unsigned_char = np:readByte( ) --方向
        local var_7_unsigned_char = np:readByte( ) --方式--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 0, 23, var_1_unsigned_int64, var_2_unsigned_short, var_3_unsigned_short, var_4_unsigned_short, var_5_unsigned_short, var_6_unsigned_char, var_7_unsigned_char )--分发数据
    end,

    --公共操作的结果
    --接收服务器
    [24] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --返回操作的结果
        local var_2_unsigned_char = np:readByte( ) --是否包含移动应答
        local var_3_unsigned_int = np:readUInt( ) --客户端心跳包时间
        local var_4_unsigned_int = np:readUInt( ) --网关延迟（毫秒）
        local var_5_unsigned_int = np:readUInt( ) --逻辑服务器延迟（毫秒）
        PacketDispatcher:dispather( 0, 24, var_1_unsigned_char, var_2_unsigned_char, var_3_unsigned_int, var_4_unsigned_int, var_5_unsigned_int )--分发数据
    end,

    --实体改变朝向
    --接收服务器
    [25] = function ( np )
        local var_1_int64 = np:readInt64( ) --实体的handle
        local var_2_unsigned_char = np:readByte( ) --方向
        PacketDispatcher:dispather( 0, 25, var_1_int64, var_2_unsigned_char )--分发数据
    end,

    --释放肉搏技能(普通攻击)
    --接收服务器
    [26] = function ( np )
        local var_1_int64 = np:readInt64( ) --释放者的句柄
        local var_2_unsigned_char = np:readByte( ) --动作编号
        local var_3_unsigned_char = np:readByte( ) --技能的方向
        local var_4_unsigned_short = np:readWord( ) --特效的id
        PacketDispatcher:dispather( 0, 26, var_1_int64, var_2_unsigned_char, var_3_unsigned_char, var_4_unsigned_short )--分发数据
    end,

    --实体瞬移到一个位置
    --接收服务器
    [27] = function ( np )
        local var_1_int64 = np:readInt64( ) --实体的句柄
        local var_2_int = np:readInt( ) --是否播放特效--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_int = np:readInt( ) --位置x，像素
        local var_4_int = np:readInt( ) --位置y
        local var_5_unsigned_char = np:readByte( ) --瞬移以后的朝向
        PacketDispatcher:dispather( 0, 27, var_1_int64, var_2_int, var_3_int, var_4_int, var_5_unsigned_char )--分发数据
    end,

    --实体被暴击
    --接收服务器
    [28] = function ( np )
        local var_1_int64 = np:readInt64( ) --被暴击者的handle
        local var_2_int64 = np:readInt64( ) --攻击者的handle
        local var_3_unsigned_int = np:readUInt( ) --被爆的血
        PacketDispatcher:dispather( 0, 28, var_1_int64, var_2_int64, var_3_unsigned_int )--分发数据
    end,

    --实体成功躲避一次攻击
    --接收服务器
    [29] = function ( np )
        local var_1_unsigned_int64 = np:readUint64( ) --闪避者handle
        PacketDispatcher:dispather( 0, 29, var_1_unsigned_int64 )--分发数据
    end,

    --广播怪物重用的消息
    --接收服务器
    [31] = function ( np )
        local var_1_unsigned_int64 = np:readUint64( ) --怪物的handle--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_unsigned_int = np:readUInt( ) --客户端展示怪物死亡的秒数--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 0, 31, var_1_unsigned_int64, var_2_unsigned_int )--分发数据
    end,

    --添加场景特效
    --接收服务器
    [32] = function ( np )
        local var_1_int64 = np:readInt64( ) --施法者的handle
        local var_2_unsigned_char = np:readByte( ) --特效的类型
        local var_3_unsigned_short = np:readWord( ) --特效的ID
        local var_4_int = np:readInt( ) --posX
        local var_5_int = np:readInt( ) --posY
        local var_6_unsigned_int = np:readUInt( ) --持续时间
        PacketDispatcher:dispather( 0, 32, var_1_int64, var_2_unsigned_char, var_3_unsigned_short, var_4_int, var_5_int, var_6_unsigned_int )--分发数据
    end,

    --提示npc身上是否有可接任务或者可完成任务
    --接收服务器
    [33] = function ( np )
        local var_1_unsigned_int64 = np:readUint64( ) --npc的handle
        local var_2_unsigned_char = np:readByte( ) --类型--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 0, 33, var_1_unsigned_int64, var_2_unsigned_char )--分发数据
    end,

    --主角丢弃目标
    --接收服务器
    [34] = function ( np )
        local var_1_int64 = np:readInt64( ) --当前服务器选中的实体handle--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 0, 34, var_1_int64 )--分发数据
    end,

    --实体死亡
    --接收服务器
    [35] = function ( np )
        local var_1_int64 = np:readInt64( ) --实体的handle
        local var_2_int64 = np:readInt64( ) --killer，对方的handle
        local var_3_int = np:readInt( ) --是否击飞--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 0, 35, var_1_int64, var_2_int64, var_3_int )--分发数据
    end,

    --玩家采集怪（取消）
    --接收服务器
    [36] = function ( np )
        local var_1_int64 = np:readInt64( ) --玩家实体句柄
        local var_2_unsigned_short = np:readWord( ) --玩家坐标X--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_unsigned_short = np:readWord( ) --玩家坐标Y--s本参数存在特殊说明，请查阅协议编辑器
        local var_4_char = np:readChar( ) --玩家的朝向
        PacketDispatcher:dispather( 0, 36, var_1_int64, var_2_unsigned_short, var_3_unsigned_short, var_4_char )--分发数据
    end,

    --玩家名称颜色变化
    --接收服务器
    [37] = function ( np )
        local var_1_int64 = np:readInt64( ) --名称颜色更新的角色句柄
        local var_2_unsigned_int = np:readUInt( ) --玩家名称颜色ARGB值
        PacketDispatcher:dispather( 0, 37, var_1_int64, var_2_unsigned_int )--分发数据
    end,

    --连斩CD改变
    --接收服务器
    [38] = function ( np )
        local var_1_unsigned_int = np:readUInt( ) --连斩CD时间，单位为ms
        PacketDispatcher:dispather( 0, 38, var_1_unsigned_int )--分发数据
    end,

    --删除特效
    --接收服务器
    [39] = function ( np )
        local var_1_unsigned_int64 = np:readUint64( ) --实体的handle
        local var_2_unsigned_char = np:readByte( ) --特效的类型
        local var_3_unsigned_short = np:readWord( ) --特效的ID
        PacketDispatcher:dispather( 0, 39, var_1_unsigned_int64, var_2_unsigned_char, var_3_unsigned_short )--分发数据
    end,

    --实体改变显示名字
    --接收服务器
    [40] = function ( np )
        local var_1_unsigned_int64 = np:readUint64( ) --玩家的句柄
        local var_2_string = np:readString( ) --玩家的显示名字
        PacketDispatcher:dispather( 0, 40, var_1_unsigned_int64, var_2_string )--分发数据
    end,

    --屏幕振荡
    --接收服务器
    [42] = function ( np )
        local var_1_unsigned_short = np:readWord( ) --振荡的尺度
        local var_2_unsigned_short = np:readWord( ) --持续时间(单位ms)
        PacketDispatcher:dispather( 0, 42, var_1_unsigned_short, var_2_unsigned_short )--分发数据
    end,

    --延长VIP有效时间
    --接收服务器
    [45] = function ( np )
        local var_1_int = np:readInt( ) --VIP类型--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_unsigned_int = np:readUInt( ) --vip过期时间（MiniDateTime格式）
        PacketDispatcher:dispather( 0, 45, var_1_int, var_2_unsigned_int )--分发数据
    end,

    --VIP过期
    --接收服务器
    [46] = function ( np )
        local var_1_int = np:readInt( ) --vip类型
        PacketDispatcher:dispather( 0, 46, var_1_int )--分发数据
    end,

    --VIP剩余时间提醒
    --接收服务器
    [47] = function ( np )
        local var_1_int = np:readInt( ) --vip类型--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_char = np:readChar( ) --提示方式--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_unsigned_int = np:readUInt( ) --VIP剩余时间(秒为单位)--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 0, 47, var_1_int, var_2_char, var_3_unsigned_int )--分发数据
    end,

    --实体改变攻击类型
    --接收服务器
    [48] = function ( np )
        local var_1_unsigned_int64 = np:readUint64( ) --实体的句柄
        local var_2_unsigned_char = np:readByte( ) --实体的攻击类型--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 0, 48, var_1_unsigned_int64, var_2_unsigned_char )--分发数据
    end,

    --心跳包应答
    --接收服务器
    [49] = function ( np )
        local var_1_unsigned_int = np:readUInt( ) --发包时间
        local var_2_unsigned_int = np:readUInt( ) --网关延时（ms为单位）
        local var_3_unsigned_int = np:readUInt( ) --逻辑服务器延时（ms为单位）
        PacketDispatcher:dispather( 0, 49, var_1_unsigned_int, var_2_unsigned_int, var_3_unsigned_int )--分发数据
    end,

    --发送充值信息
    --接收服务器
    [50] = function ( np )
        local var_1_int = np:readInt( ) --充值元宝数
        local var_2_int = np:readInt( ) --这次充值的元宝数--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 0, 50, var_1_int, var_2_int )--分发数据
    end,

    --播放光点特效
    --接收服务器
    [51] = function ( np )
        local var_1_int64 = np:readInt64( ) --特效中心实体句柄
        PacketDispatcher:dispather( 0, 51, var_1_int64 )--分发数据
    end,

    --重设主角的位置坐标
    --接收服务器
    [1] = function ( np )
        local var_1_int = np:readInt( ) --场景id
        local var_2_int = np:readInt( ) --x
        local var_3_int = np:readInt( ) --y
        PacketDispatcher:dispather( 0, 1, var_1_int, var_2_int, var_3_int )--分发数据
    end,

    --玩家增加或减少一个baby
    --接收服务器
    [44] = function ( np )
        local var_1_int64 = np:readInt64( ) --实体的handle
        PacketDispatcher:dispather( 0, 44, var_1_int64 )--分发数据
    end,

    --创建人物形象的怪物
    --接收服务器
    [52] = function ( np )
        local var_1_int = np:readInt( ) --怪物id
        local var_2_int64 = np:readInt64( ) --怪物句柄
        local var_3_int = np:readInt( ) --当前Ｘ坐标
        local var_4_int = np:readInt( ) --当前Ｙ坐标
        local var_5_int = np:readInt( ) --模型ＩＤ
        local var_6_unsigned_int = np:readUInt( ) --MAX_HP
        local var_7_unsigned_int = np:readUInt( ) --MAX_MP
        local var_8_unsigned_short = np:readWord( ) --移动速度
        local var_9_unsigned_char = np:readByte( ) --性别(0男，1女)
        local var_10_unsigned_char = np:readByte( ) --职业
        local var_11_unsigned_char = np:readByte( ) --等级
        local var_12_unsigned_char = np:readByte( ) --阵营
        local var_13_int = np:readInt( ) --武器外观
        local var_14_unsigned_short = np:readWord( ) --头像ID
        local var_15_int = np:readInt( ) --玩家翅膀和法宝属性--s本参数存在特殊说明，请查阅协议编辑器
        local var_16_string = np:readString( ) --玩家名称
        PacketDispatcher:dispather( 0, 52, var_1_int, var_2_int64, var_3_int, var_4_int, var_5_int, var_6_unsigned_int, var_7_unsigned_int, var_8_unsigned_short, var_9_unsigned_char, var_10_unsigned_char, var_11_unsigned_char, var_12_unsigned_char, var_13_int, var_14_unsigned_short, var_15_int, var_16_string )--分发数据
    end,

    --发送跨服的key
    --接收服务器
    [53] = function ( np )
        PacketDispatcher:dispather( 0, 53 )--分发数据
    end,

    --跨服_更新前端的主角数据
    --接收服务器
    [54] = function ( np )
        local var_1_unsigned_int64 = np:readUint64( ) --主角handle
        local var_2_unsigned_int = np:readUInt( ) --玩家状态
        local var_3_unsigned_int = np:readUInt( ) --血量
        local var_4_unsigned_int = np:readUInt( ) --法力
        PacketDispatcher:dispather( 0, 54, var_1_unsigned_int64, var_2_unsigned_int, var_3_unsigned_int, var_4_unsigned_int )--分发数据
    end,


}
