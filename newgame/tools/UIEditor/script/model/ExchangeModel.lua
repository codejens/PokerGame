-- ExchangeModel.lua
-- created by lyl on 2012-2-19
-- 兑换

-- super_class.ExchangeModel()
ExchangeModel = {}

ExchangeModel.category_to_group_id = { equipment = 1,  material = 2, glory = 3 }

-- added by aXing on 2013-5-25
function ExchangeModel:fini( ... )
    UIManager:destroy_window( "exchange_win" )
end

-- 更新兑换窗口
local function update_exchangeWin_win( update_type )
    ExchangeWin:update_win( update_type )
end

-- ================================
-- 数据操作
-- ================================

-- 获取玩家历练
function ExchangeModel:get_player_lilian(  )
	local player = EntityManager:get_player_avatar()
	return player.lilian
end

-- 获取玩家荣誉值
function ExchangeModel:get_player_honor(  )
    local player = EntityManager:get_player_avatar()
    return player.honor
end

-- 获取某类道具的兑换信息列表   equipment,  material  glory
function ExchangeModel:get_category_items( category )
	require "config/RenownShopConfig"
	local item_list = RenownShopConfig:get_category_item( category )
	local item_id_t = {}
	for i = 1, #item_list do
		if ExchangeModel:check_item_with_job( item_list[i].itemID ) then
            table.insert( item_id_t, item_list[i].itemID )
        end
	end
    return item_id_t
end

-- 获取该道具需要的等级
function ExchangeModel:get_item_need_level( item_id, category )
	local item_exchange_info = RenownShopConfig:get_item_info_by_id( item_id, category )
    if item_exchange_info then
        return item_exchange_info.buyLevel
    end
    return 0
end

-- 获取该道具需要的 货币类型和价格. 返回： 类型值  价格
function ExchangeModel:get_item_need_money( item_id, category )
	local item_exchange_info = RenownShopConfig:get_item_info_by_id( item_id, category )
    if item_exchange_info then
    	require "config/StaticAttriType"
    	local price_name = _static_money_type[ item_exchange_info.price[1].type ] or ""
        return price_name, item_exchange_info.price[1].price,item_exchange_info.price[1].type
    end
    return "", 0
end

-- 显示商城tips
function ExchangeModel:show_mall_tips( item_id ,x,y)
    TipsModel:show_shop_tip( x, y, item_id )
end

-- ================================
-- 逻辑相关
-- ================================

-- 判断装备是否符合玩家职业 
function ExchangeModel:check_item_with_job( item_id )
	local job_need = ItemModel:get_item_need_job( item_id )
	local player = EntityManager:get_player_avatar()
	if player.job == job_need or job_need == 0 then
        return true
    else
    	return false
	end
end

-- 显示获取说明
function ExchangeModel:chow_get_explain(  )
	local explain_content = Lang.exchange.explain
                            -- .."#c66FF66荣誉值获取方式#r#c66FF661.通过1v1自由赛获得积分排名，根据排名获得荣誉值。#r#c66FF662.通过参加1v1争霸赛，获得荣誉值"
    local help_win = UIManager:find_visible_window("help_panel")
    if help_win ~= nil then
        UIManager:hide_window("help_panel")
        HelpPanel:show( 3, UIPIC_COMMON_TIPS, explain_content )
    else
       HelpPanel:show( 3, UIPIC_COMMON_TIPS, explain_content )
    end 
end

-- 打开购买面板   参数：道具id， 道具兑换需要的等级   需要历练
function ExchangeModel:show_buy_keyboard( item_id, level, need, category )
    local if_be_equipment = ItemModel:check_if_body_use_item( item_id )     -- 是否是装备
    -- 判断等级是否已经达到
    local player = EntityManager:get_player_avatar()
    if player.level < level then
        local notice_content = Lang.exchange.model[6]-- [135]="您的等级低于该道具的兑换等级，无法兑换"
        local confirmWin = ConfirmWin( "notice_confirm", nil, notice_content, nil, nil, 250, nil)
        return
    end

    -- 判断历练是否已经达到
    if category == "glory"  then
        if player.honor < need then 
            local notice_content = Lang.exchange.model[4]
            local confirmWin = ConfirmWin( "notice_confirm", nil, notice_content, nil, nil, 250, nil)
            return
        end
    else
        if player.lilian < need then 
            local notice_content = Lang.exchange.model[5]
            local confirmWin = ConfirmWin( "notice_confirm", nil, notice_content, nil, nil, 250, nil)
            return
        end
    end

    -- 打开购买窗口的函数
    local function confirm_fun(  )
        require "config/RenownShopConfig"
        local group_id = RenownShopConfig:get_groud_id_by_item_id( item_id )
        if ExchangeModel.category_to_group_id[ category ] then 
            group_id = ExchangeModel.category_to_group_id[ category ]
        end
        local max_num = 99
        local _type = 6;
        if if_be_equipment then
            max_num = 1
        end
        BuyKeyboardWin:show( item_id, nil, _type, max_num, {group_id, category} )
    end

    -- 如果已经拥有该装备，提示
    if ExchangeModel:chek_if_has_item( item_id ) and if_be_equipment then
        local notice_words = Lang.exchange.model[3] -- [138]="您已拥有该装备，确定再兑换一件吗？"
        ConfirmWin( "select_confirm", nil, notice_words, confirm_fun, nil, 250, 130)
    else
        confirm_fun(  )    
    end
end

-- 判断玩家是否已经达到道具等级
function ExchangeModel:check_level( item_id, category )
    local player = EntityManager:get_player_avatar()
    local level_need = ExchangeModel:get_item_need_level( item_id, category )
    if player.level >= level_need then
        return true
    else
        return false
    end
end

-- 判断是否已经有该道具
function ExchangeModel:chek_if_has_item( item_id )
    if ItemModel:check_if_exist_by_item_id( item_id ) 
        or UserInfoModel:check_if_equip_by_id( item_id ) then
        return true
    end
    return false
end

-- 根据

-- 其他系统通知改变数据
function ExchangeModel:date_change_udpate( attr_name )
    local attr_to_type = { lilian = "lilian",honor = "honor"}
    if attr_to_type[ attr_name ] then
        update_exchangeWin_win( attr_to_type[ attr_name ] )
    end
end

-- 获取颜色
function ExchangeModel:get_item_color( item_id )
    return ItemModel:get_item_color( item_id )
end
