--- HeluoBooksModel.lua
 -- 河洛图书的数据处理类
 -- @module  heluoBooks
 -- @author  ljd
 -- @created 2014-11-28

-- require '../data/std_holyweapon'

HeluoBooksModel = {}

HeluoBooksModel.cards_date = {}                 --服务器下发的卡牌信息
HeluoBooksModel.meiren_po_data   = 0
HeluoBooksModel.duihuan    = 0
HeluoBooksModel.jingyan    = 0

HeluoBooksModel._curr_page_num = 1
HeluoBooksModel._curr_series_page = 1
HeluoBooksModel._curr_books_page = 1


-- 属性对战斗力的权重
local attr_weight =
{
    [17] = 0.2,  -- 生命
    [19] = 0.2,  -- 法力
    [21] = 1.0,--物理攻击
    [27] = 1.0,  -- 攻击
    [29] = 1.0,  -- 无视防御
    [31] = 1.0,  -- 法术攻击
    [23] = 1.0,  -- 物理防御
    [33] = 1.0,  -- 法术防御
    [41] = 1.5,  -- 伤害追加
    [39] = 1.5,  -- 命中
    [37] = 1.5,  -- 闪避
    [35] = 1.5,  -- 暴击
    [25] = 1.5,  -- 抗暴击
    [63] = 150,  -- 会心
    [51] = -1.5, -- 物理免伤
    [49] = -1.5, -- 法术免伤
}

-- 属性对战斗力的权重
local attr_name =
{
    [17] = "生命",      -- 生命
    [19] = "法力",      -- 法力
    [21] = "物理攻击",  -- 物理攻击
    [27] = "攻击",      -- 攻击
    [29] = "无视防御",  -- 无视防御
    [31] = "法术攻击",  -- 法术攻击
    [23] = "物理防御",  -- 物理防御
    [33] = "法术防御",  -- 法术防御
    [41] = "伤害追加",  -- 伤害追加
    [39] = "命中",      -- 命中
    [37] = "闪避",      -- 闪避
    [35] = "暴击",      -- 暴击
    [25] = "抗暴击",    -- 抗暴击
    [63] = "会心",      -- 会心
    [51] = "物理免伤",  -- 物理免伤
    [49] = "法术免伤",  -- 法术免伤
}



--析构
function HeluoBooksModel:fini(  )
    UIManager:destroy_window("lingqi_win")
    HeluoBooksModel.cards_date = {}                 --服务器下发的卡牌信息
    HeluoBooksModel.meiren_po_data   = {}
    HeluoBooksModel.duihuan    = 0
    HeluoBooksModel.jingyan    = 0

    HeluoBooksModel._curr_page_num = 1
    HeluoBooksModel._curr_series_page = 1
    HeluoBooksModel._curr_books_page = 1
end

function HeluoBooksModel.init_data()

end

function HeluoBooksModel.get_heluo_win()
    return UIManager:find_window( "lingqi_win" )
end

function HeluoBooksModel.update_books_list()
    local heluo_win = HeluoBooksModel.get_heluo_win()
    if not heluo_win then
        return
    end

end


--更新兑换次数
function HeluoBooksModel.update_duihuan_count(  )
    -- local heluo_win = HeluoBooksModel.get_heluo_win()
    local win = UIManager:find_window("meiren_exchange_win")
    if not win then
        return
    end
    win:update_duihuan_count( HeluoBooksModel.duihuan )
end

--设置主页面的卡牌信息
function HeluoBooksModel:set_main_curr_card_page( card_id )
    local series_path,books_path = HeLuoConfig.getCardSeries( card_id )

    --修正：需要卡牌在该系列的索引
    local books_series = HeLuoConfig.getBookSeriesTable()[series_path].subList
    local book_page = 1
    for i,v in ipairs( books_series) do
        if v == books_path then
            book_page = i
        end
    end

    HeluoBooksModel.has_card_item_data = true
    HeluoBooksModel._curr_page_num = 1
    HeluoBooksModel._curr_series_page = series_path
    HeluoBooksModel._curr_books_page  = book_page

    local card = HeLuoConfig.getCardConfigByIndex( series_path, book_page )
    local index = 1
    for i,v in ipairs(card) do
        if card_id == v then
            index = i
        end
    end
    HeluoBooksModel._curr_page_num = math.ceil(index/4)
    print("------------------",HeluoBooksModel._curr_page_num,HeluoBooksModel._curr_series_page,HeluoBooksModel._curr_books_page)
end

--设置主页面的卡牌信息
function HeluoBooksModel:get_main_curr_card_page(  )
    if HeluoBooksModel.has_card_item_data then
        HeluoBooksModel.has_card_item_data = false
        return HeluoBooksModel._curr_page_num,HeluoBooksModel._curr_series_page,HeluoBooksModel._curr_books_page
    end
end

--更新
function HeluoBooksModel.update_meiren_po_count( )
    local win = UIManager:find_window("meiren_exchange_win")
    if win then
        win:update_meiren_po( HeluoBooksModel.meiren_po_data )
    end
    local lingqi_win = UIManager:find_window("lingqi_win")
    if lingqi_win then
        lingqi_win:update_card_data( 6, "daibi")
    end
end

--更新经验数
function HeluoBooksModel.update_jingyan_count( )
    local heluo_win = HeluoBooksModel.get_heluo_win()
    if not heluo_win then
        return
    end
    -- heluo_win:update_now_jingyan( 5, "jingyan")
    heluo_win:update_card_data( 6, "jingyan")
end

--计算现有卡牌战斗力
function HeluoBooksModel.count_heluo_fight_value( )
    local fight = 0
    if not HeluoBooksModel.cards_date then
        return
    end
    for id, star in pairs( HeluoBooksModel.cards_date) do
        local card =HeLuoConfig.getCardConfig( id )
        local attrs = card.attrs[star]

        --计算单张卡的战斗力
        for i,att in ipairs(attrs) do
            fight = fight + att.value * attr_weight[ att.type ]
        end
    end
    return fight
end

function HeluoBooksModel:get_total_book_attrs()
    local total_attrs = {}   --总属性
    for id, star in pairs( HeluoBooksModel.cards_date) do
        local card =HeLuoConfig.getCardConfig( id )
        local attrs = card.attrs[star]

        --计算单张卡的战斗力
        for i,attr in ipairs(attrs) do

            total_attrs[ attr.type ] = (total_attrs[ attr.type ] or 0) + attr.value
        end
    end

    --调整为属性表
    local attrs_tab = {}
        for k,v in pairs(total_attrs) do
            attrs_tab[#attrs_tab + 1] = {value = math.abs(v),     type = k,}
        end
    return attrs_tab
end

--计算卡牌战斗力 attrs:卡牌的attr属性
function HeluoBooksModel.get_card_fight_value( attrs )
    local fight = 0
    for i,att in ipairs(attrs) do
        fight = fight + att.value * attr_weight[ att.type ]
    end
    return fight
end

--更新洛书战斗力
function HeluoBooksModel.update_fight_value( )
    local heluo_win = HeluoBooksModel.get_heluo_win()
    if not heluo_win then
        return
    end
    local val = HeluoBooksModel.count_heluo_fight_value( )
    heluo_win:update_fight_value( val )
end


-- 获取背包卡牌series集合
function HeluoBooksModel:get_bag_card_list(  )
    local bag_items, bag_item_count = ItemModel:get_bag_data()
    local card_list = {}

    for i,item in ipairs(bag_items) do
        local item_base = ItemConfig:get_item_by_id( item.item_id ) --静态属性
        if item_base.type == 20 then
            card_list[#card_list + 1] = item.series
        end
    end
    return card_list
end

-- 获取背包以激活卡牌物品ID(series)集合
function HeluoBooksModel:get_jihuo_card_list(  )
    local bag_items, bag_item_count = ItemModel:get_bag_data()
    local card_list = {}

    for i,item in pairs(bag_items) do
        local item_base = ItemConfig:get_item_by_id( item.item_id ) --静态属性
        if item_base.type == 20 then
            local jihuo = HeluoBooksModel:get_card_star_by_item_id( item.item_id )
            if jihuo then
                card_list[#card_list + 1] = item.series
            end
        end
    end
    return card_list
end

-- -- 获取背包以激活卡牌物品series集合, 根据物品id(item_id)
function HeluoBooksModel:get_card_series_by_id( item_id)
    local bag_items, bag_item_count = ItemModel:get_bag_data()
    local card_list = {}
    for i,item in pairs(bag_items) do
        if item.item_id == item_id then
            local item_base = ItemConfig:get_item_by_id( item.item_id ) --静态属性
            if item_base.type == 20 then
                local jihuo = HeluoBooksModel:get_card_star_by_item_id( item.item_id )
                if jihuo then
                    card_list[#card_list + 1] = item.series
                end
            end
        end
    end
    return card_list
end

-- 设置卡牌信息
function HeluoBooksModel:set_cards_date( data )
    HeluoBooksModel.cards_date = data

    --更新战斗力
    HeluoBooksModel.update_fight_value( )
    
    --更新所有卡牌列表
    HeluoBooksModel:update_card_panel( 5 )
    HeluoBooksModel:update_card_panel( 6, "all" )
end

-- 设置一张卡牌信息
function HeluoBooksModel:set_one_cards_date( item_id, data )
    HeluoBooksModel.cards_date[item_id] = data

    HeluoBooksModel.update_fight_value( ) --更新战斗力
    -- HeluoBooksModel:update_card_panel( 2, {} )
    HeluoBooksModel:update_card_panel( 5 )
    HeluoBooksModel:update_card_panel( 6, "all")
end

-- 设置美人的玉魄 魂魄 神魄
function HeluoBooksModel:set_meiren_po_date( data )
    HeluoBooksModel.meiren_po_data = data
    print("-------data:", HeluoBooksModel.meiren_po_data.yu)
    
    HeluoBooksModel.update_meiren_po_count( )
end

-- 设置经验信息
function HeluoBooksModel:set_jingyan_date( data )
    HeluoBooksModel.jingyan = data or 0

    HeluoBooksModel.update_jingyan_count( )

    HeluoBooksModel:update_right_panel( 3, {})
end

-- 设置兑换次数信息
function HeluoBooksModel:set_duihuan_date( data )
    HeluoBooksModel.duihuan = data

    HeluoBooksModel.update_duihuan_count(  )
end

-- 获取卡片星级信息
function HeluoBooksModel:get_card_star_by_id( card_id )
    return HeluoBooksModel.cards_date[card_id]
end

-- 获取卡片星级信息使用物品信息
function HeluoBooksModel:get_card_star_by_item_id( item_id )
    local card = HeLuoConfig.getCardByItemID(item_id)
    if not card then
        return
    end
    return HeluoBooksModel.cards_date[card.id]
end

-- 更新卡片
function HeluoBooksModel:update_card_panel( page, card )
    local heluo_win = HeluoBooksModel.get_heluo_win()
    if not heluo_win then
        return
    end
    --更新所有卡片
    heluo_win:update_card_data( page, card )
end

-- 更新右边窗口
function HeluoBooksModel:update_right_panel( page, card )
    local heluo_win = HeluoBooksModel.get_heluo_win()
    if not heluo_win then
        return
    end
    heluo_win:update_card_data( page, card )
end

--生成tips属性表
function HeluoBooksModel:get_tips_attr_data( attrs)
    if not attrs then
        print("无属性表")
        return {}
    end
    local data = {}

    data.cols_width = { 100, 70, 70 }
    local contents = {}

    for i,attr in ipairs(attrs) do
        local texts = {}
        texts[1] = "#c33a6ee" .. attr_name[ attr.type]
        texts[2] = tostring( "+ " .. math.abs(attr.value) )

        contents[i] = texts
    end
    

    data.contents = contents
    data.row_height = 28
    return data
end

-- 获取套装Tips属性
function HeluoBooksModel:get_series_attrs( cardSubGroup )
    local series,name = HeLuoConfig.getCardSeriesAttrs( cardSubGroup )
    local jihuo_num = 0           --已经激活的数量
    local now_attr = #series.count--当前的属性阶层
    local nex_attr = #series.count--下一阶的属性阶层

        local tips_data = {}

    --算出以激活套装
    for i,card in ipairs(series.idList) do
        if HeluoBooksModel:get_card_star_by_id(card) then
            jihuo_num = jihuo_num +1
        end
    end

    --当前套装阶层
    for i,next_num in ipairs(series.count) do
        if next_num > jihuo_num then
            now_attr = i - 1
            break
        end
    end

    --生成当前套装属性文字
    local now_contents = {}
    if now_attr > 0 then
        for i,attr in ipairs(series.attrs[now_attr]) do
            now_contents[i] = "#c33a6ee" .. attr_name[ attr.type] .. tostring( "+ " .. math.abs(attr.value) )
        end
        tips_data.now_name = name .. "系列(" .. jihuo_num .. "/" .. series.count[now_attr] ..")" .. "【已激活】"
    else
        tips_data.now_name = ""
    end

    --下一阶套装阶层
    local nex_contents = {}
    if now_attr < #series.count then
        nex_attr = now_attr + 1
        for i,attr in ipairs(series.attrs[nex_attr]) do
            nex_contents[i] = "#c33a6ee" .. attr_name[ attr.type] .. tostring( "+ " .. math.abs(attr.value) )
        end
        tips_data.nex_name = name .. "系列(" .. jihuo_num .. "/" .. series.count[nex_attr] ..")"
    else
        nex_contents = nil
    end

    tips_data.nex_name = name .. "系列(" .. jihuo_num .. "/" .. series.count[nex_attr] ..")"
    tips_data.now_attr    = now_contents
    tips_data.nex_attr    = nex_contents

    return tips_data
end

-- 卡牌炫耀
-- card_id:卡牌的ID card_star:星级
function HeluoBooksModel:xuanyao_book_event( card_id, card_star )
    local card = HeLuoConfig.getCardConfig( card_id ) or {}
    local name = ItemModel:get_item_name_with_color( card.itemId) or ""
    local temp_info = string.format( "%s%d%s%d%s%s%s%s%s,%s,%s,%s,%s",
        ChatConfig.message_split_target.CHAT_INFO_SPLITE_TARGET,
        ChatConfig.ChatSpriteType.TYPE_TEXTBUTTON, ChatConfig.message_split_target.CHAT_INFO_HEAD_TARGET,
        ChatConfig.ChatAdditionInfo.TYPE_BOOK, ChatConfig.message_split_target.CHAT_INFO_HEAD_TARGET,
        name, ChatConfig.message_split_target.CHAT_INFO_HEAD_TARGET,
        Hyperlink:get_first_function_target(), Hyperlink:get_third_open_sys_win_target(),41,
        card_id, card_star,
        ChatConfig.message_split_target.CHAT_INFO_SPLITE_TARGET)
    print("temp_info",temp_info)

    ChatCC:send_chat(ChatModel:get_cur_chanel_select(), 0, temp_info)
end


-- 展示他人卡牌Tips
function HeluoBooksModel:show_other_meiren_tips( card_id, star_num )
    local card_id = tonumber(card_id)
    local star_num = tonumber(star_num)
    local card_data = HeLuoConfig.getCardConfig( card_id )

    local data = HeluoBooksModel:get_tips_attr_data( card_data.attrs[star_num])
    local attr = self:getCardAttrs(card_data)
    data.attr = attr
    data.card_data = card_data
    TipsModel:show_meiren_tip( 400, 240, data )
end



function HeluoBooksModel:getCardAttrs( card_data )

    if not card_data then
        return {}
    end

    local attrs = card_data.attrs

    local star = HeluoBooksModel.cards_date[card_data.id] or 1
    -- local star  = self.starNum or 1

    if star < 1 then star = 1 end

    return attrs[star]
end