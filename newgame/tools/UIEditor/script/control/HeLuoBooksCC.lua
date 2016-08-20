--- HeLuoBooksCC.lua
--created by ljd on 2014-12-03
--洛书系统协议处理

HeLuoBooksCC = {}

--c->s,164,1 获取洛书基本信息

function HeLuoBooksCC:req_base_heluo_info( )
    print("c->s 获取洛书基本信息:164,1")
    local pack = NetManager:get_socket():alloc( 164, 1 )
    NetManager:get_socket():SendToSrv(pack)
end

--s->c,164,1 返回洛书基本信息
function HeLuoBooksCC:do_base_heluo_info( pack )
    local info = {}

    local card_num = pack:readShort()
    print("s->c 返回洛书基本信息:164,1",card_num)
    for i=1, card_num do
        local id = pack:readShort()
        local cahr = pack:readChar()
        print("id,cahr",id,cahr)
        info[id] = cahr
    end

    HeluoBooksModel:set_cards_date( info)


end

--c->s,164,3 请求操作河图洛书指定卡牌
function HeLuoBooksCC:req_update_one_book( type, card_id, item_series )
    print("c->s,164,3 请求操作河图洛书指定卡牌", type, card_id, item_series)
    local pack = NetManager:get_socket():alloc( 164, 3 )
    pack:writeChar( type) -- 0=激活，1=升星
    pack:writeShort( card_id)
    if item_series then
        pack:writeInt64( item_series)
    end
    print("type",type)
    print("card_id",card_id)
    print("item_series",item_series)
    NetManager:get_socket():SendToSrv(pack)
end

--s->c,164,2 下发河图洛书指定卡牌信息
function HeLuoBooksCC:do_update_one_book_info( pack )
    print("s->c 164,2  下发河图洛书指定卡牌信息:")
    local id = pack:readShort()
    local cahr = pack:readChar()
print("--------id,", id, cahr)
    HeluoBooksModel:set_one_cards_date( id, cahr )
end

--c->s,164,4 请求分解卡牌
function HeLuoBooksCC:req_fenjie_books( num, item_id, series_t )

    print("================item_id: ", item_id)




    print("c->s,164,4 请求分解卡牌", num, item_id, #series_t,series_t[1])
    local pack = NetManager:get_socket():alloc( 164, 4 )
    pack:writeShort( 1)
    pack:writeShort( item_id )
    pack:writeShort( num )
    pack:writeShort( #series_t)
    for i,ser in ipairs(series_t) do --每个物品的GUID
        pack:writeInt64( ser)
    end
    NetManager:get_socket():SendToSrv(pack)
end

--c->s,164,5 请求兑换卡牌
function HeLuoBooksCC:req_duihuan_card( card_id, num )
    print("c->s,164,5 请求兑换卡牌",  card_id, num)
    local pack = NetManager:get_socket():alloc( 164, 5 )
    pack:writeShort( card_id )
    pack:writeChar( num )
    NetManager:get_socket():SendToSrv(pack)
end

--s->c,164,6 下发河图洛书经验
--和10,1同时返回
function HeLuoBooksCC:do_update_heluo_jingyan( pack )
    local num = pack:readInt()
    print("s->c 164,6  下发河图洛书经验:",num)
    HeluoBooksModel:set_jingyan_date( num )
end


--c->s,164,7 请求当天剩余的兑换卡牌张数
function HeLuoBooksCC:req_duihuan_count( )
    print("c->s,164,7 请求当天剩余的兑换卡牌张数")
    local pack = NetManager:get_socket():alloc( 164, 7 )
    NetManager:get_socket():SendToSrv(pack)
end

--s->c,164,7 下发当天剩余的兑换卡牌张数
function HeLuoBooksCC:do_duihuan_count( pack )
    local num = pack:readInt()
    print("s->c,164,7 下发当天剩余的兑换卡牌张数",num)
    
    HeluoBooksModel:set_duihuan_date( num )
end

--s->c,164,10 下发河图洛书仙券
--和10,1同时返回
function HeLuoBooksCC:do_update_meiren_po( pack )
    print("s->c,164,10 HeLuoBooksCC:do_update_meiren_po")
    local yu = pack:readInt()
    -- local hun = pack:readInt()
    -- local shen = pack:readInt()
        -- print("s->c 164,10  下发美人卡牌所需的玉魄 魂魄 神魄:",yu,hun,shen)
    -- local data = {yu,hun,shen}
    local data = {yu}
    print("--------yu:", yu)
    HeluoBooksModel:set_meiren_po_date( data )
end