    if ( protocol_func_map_server[41] == nil ) then
        protocol_func_map_server[41] = {}
    end



    --返回玩家邮件列表
    --接收服务器
    protocol_func_map_server[41][1] = function ( np )
        local var_1_int = np:readInt( ) --邮件的个数
        -- 邮件的详细信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 41, 1, var_1_int, var_2_array )--分发数据
    end

