    if ( protocol_func_map_server[162] == nil ) then
        protocol_func_map_server[162] = {}
    end



    --返回河图洛书卡牌信息
    --接收服务器
    protocol_func_map_server[162][1] = function ( np )
        local var_1_short = np:readShort( ) --数量
        -- short:id,char:star--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_short do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 162, 1, var_1_short, var_2_array )--分发数据
    end

    --请求别人的河图洛书卡牌信息返回
    --接收服务器
    protocol_func_map_server[162][8] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --数量
        -- short:id,char:star
        local var_2_array = {}
        for i = 1, var_1_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 162, 8, var_1_unsigned_char, var_2_array )--分发数据
    end

