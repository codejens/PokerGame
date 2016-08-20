--HeLuoConfig.lua
--created by ljd on 2014-12-03
--河图洛书窗口配置

HeLuoConfig = {}

--获取洛书系列
function HeLuoConfig.getBookSeriesTable( )
    require "../data/collectcard"
    local books_series = collectcard.cardGroup or {}
    return books_series
end

--获取洛书某个系列表
function HeLuoConfig.getCardSubGroup( index )
    require "../data/collectcard"
    local books_series = collectcard.cardSubGroup[index] or {}
    local book = books_series.subList
    return book
end

--获取洛书某个系列卡牌
function HeLuoConfig.getCardSeriesGroup( index )
    require "../data/collectcard"
    local book = collectcard.cardSeriesGroup[index ] or {}
    local card = book.subList
    return card
end

--获取洛书某张卡牌的信息
-- card_id 卡牌ID
function HeLuoConfig.getCardConfig( card_id )
    require "../data/collectcard"
    local card = collectcard.cardConfig[card_id ] or {}
    return card
end

--获取洛书某张卡牌的兑换信息
-- index 兑换配置表中的索引
function HeLuoConfig.getDuihuanConfig( index )
    require "../data/collectcard"
    local card = collectcard.exchangeConfig[index ] or {}
    return card
end

--获取洛书某张卡牌的信息
-- series 系列索引, books 子类索引,card
function HeLuoConfig.getCardConfigByIndex( series, books)
    require "../data/collectcard"
    local books_series = HeLuoConfig.getBookSeriesTable()[series].subList
    local book = HeLuoConfig.getCardSubGroup( books_series[books])
    local card_conf = HeLuoConfig.getCardSeriesGroup( book[1])
    return card_conf
end

--获取某个物品的分解索引
function HeLuoConfig.getDecomposeIDByItemID( card_id)
    require "../data/collectcard"
    local cardConfig = collectcard.decomposeConfig or {}
    for i,card in ipairs(cardConfig) do
        if card.type == card_id then
            return i
        end
    end
end

--获取某张卡牌 BY 物品ID
function HeLuoConfig.getCardByItemID( item_id)
    require "../data/collectcard"
    local cardConfig = collectcard.cardConfig or {}
    for i,card in ipairs(cardConfig) do
        if card.itemId == item_id then
            return card
        end
    end
end

--获取某个卡牌的分解经验
function HeLuoConfig.getCardFenJieValue( card_id )
    require "../data/collectcard"
    local fenjie_conf = collectcard.decomposeConfig or {}
    local fenjie_val  = 0
    for i,card in ipairs(fenjie_conf) do
        if card.type == card_id then
            fenjie_val = card.value
        end
    end

    return fenjie_val
end

--获取某个卡牌的兑换需要值
function HeLuoConfig.getCardDuiHuanValue( card_id )
    require "../data/collectcard"
    local duihuan_conf = collectcard.exchangeConfig or {}
    local duihuan_val  = 999999
    for i,card in ipairs(duihuan_conf) do
        if card.type == card_id then
            duihuan_val = card.value
        end
    end

    return duihuan_val
end


--获取某个兑换组
function HeLuoConfig.getCardDuiHuanGroup(  )
    require "../data/collectcard"
    local duihuan_Group = collectcard.exchangeGroup
    return duihuan_Group
end

--获取某个兑换组的所有卡牌ID信息
function HeLuoConfig.getCardDuiHuanCardByGroup( index )
    require "../data/collectcard"
    local duihuan_Group = collectcard.exchangeGroup[index] or {}
    local card_table = {}
    for i=1,#duihuan_Group do
        local cards = HeLuoConfig.getCardSeriesGroup( duihuan_Group[i] )
        for ind=1,#cards do
            card_table[#card_table + 1] = cards[ind]
        end
        
    end
    return card_table
end

--获取某个品阶对应的需要的VIP
function HeLuoConfig.getVipLevel( quality )
    require "../data/collectcard"
    local vip_level = collectcard.exchangeVIPLevelArr[quality+1] or 999
    return vip_level
end

--获取卡片的资源路径根据卡片ID
function HeLuoConfig.getCardResPath( card_id )
    local series_path,books_path = HeLuoConfig.getCardSeries( card_id )
    return string.format("ui/heluoCard/%d/%d/",series_path,books_path)
end

--获取卡片的系列根据卡片ID
function HeLuoConfig.getCardSeries( card_id )
    require "../data/collectcard"
    local card_group = 0
    local books_path = 0
    local series_path = 0

    local Group = collectcard.cardSeriesGroup
    for i,cardList in ipairs(Group) do
        for index,cardID in ipairs(cardList.subList) do
            if cardID == card_id then
                card_group = i
            end
        end
    end

    local SubGroup = collectcard.cardSubGroup
    for i,cardList in ipairs(SubGroup) do
        for index,cardID in ipairs(cardList.subList) do
            if cardID == card_group then
                books_path = i
            end
        end
    end

    local cardGroup = collectcard.cardGroup
    for i,cardList in ipairs(cardGroup) do
        for index,cardID in ipairs(cardList.subList) do
            if cardID == books_path then
                series_path = i
            end
        end
    end

    return series_path,books_path
end

--获取配置的属性表和名字
function HeLuoConfig.getCardSeriesAttrs( cardSubGroup )
    require "../data/collectcard"
    local series = collectcard.seriesConfig[cardSubGroup]
    local name   = collectcard.cardSeriesGroup[cardSubGroup]
    return series, name.typeName
end

--获取配置的属性表和名字
function HeLuoConfig.getcardSubGroupId( index )
    require "../data/collectcard"
    local series = collectcard.cardSubGroup[index]
    return series.id
end

-- add by chj tjxs @2015-4-29
-- 根据卡牌id获取 开牌对应的材料物品id
function HeLuoConfig:get_itemid_by_cardindex( card_index )
    require "../data/collectcard"
    local card = collectcard.cardConfig[card_index ] or {}
    return card.itemId
end