-- ForgeModel.lua
-- created by fjh on 2013-2-4
-- 炼器管理

-- super_class.ForgeModel()
--记录上一个操作，这是因为炼气有部分消息没有来源，比如增加宝石材料
ForgeModel = { _last_op = {} }

local _ui_width = GameScreenConfig.ui_screen_width 
local _ui_height = GameScreenConfig.ui_screen_height

function ForgeModel:get_wish_val_time( ... )
    local reset_time = EquipEnhanceConfig:get_wish_val_time()

    local cur_time = os.time()
    local sec_per_day = 86400
    local _year = os.date("%Y", os.time())
    local _month = os.date("%m", os.time())
    local _day = os.date("%d", os.time())
    local _hour = reset_time[1]
    local _min = reset_time[2]
    local _sec = reset_time[3]
    local next_time = os.time({year=_year, month=_month, day=_day, hour=_hour, min=_min, sec=_sec}) + sec_per_day
    return next_time - cur_time
end

-- ========================
-- 公共
-- ========================

local free_xilian_count = 0;
local _need_show_buy_fu 
-- added by aXing on 2013-5-25
function ForgeModel:fini( ... )
    -- body
end

-- 获取道具名称 （包含颜色）
function ForgeModel:get_item_name_with_color( item_id )
    return ItemModel:get_item_name_with_color( item_id )
end

-- 显示道具tips
function ForgeModel:show_item_tips( item_id, x, y )
    if item_id == nil or item_id == 0 then
        return
    end
    require "model/TipsModel"
    TipsModel:show_shop_tip( x, y, item_id )
end

-- 根据 道具序列号 显示道具
function ForgeModel:show_tips_by_series( item_series, x, y )
    local item_date = ForgeModel:get_item_in_bag_or_body( item_series )
    if item_date then 
        -- ForgeModel:show_item_tips( item_date.item_id, x, y )
        TipsModel:show_tip( x, y, item_date )
    else
        -- print("=== on tips ===")
    end
end

-- 获取道具数据
function ForgeModel:get_item_in_bag_or_body( item_series )
    return ItemModel:get_item_in_bag_or_body( item_series )
end

-- 根据id检查物品是否是装备
function ForgeModel:check_if_equip_by_id( item_id )
    return ItemModel:check_if_equip_by_id( item_id )
end

-- 判断一个道具是否是宝石
function ForgeModel:check_item_is_gem( item_id )
    --宝石的id集合，用来判断某件物品是否是宝石
    local _gem_num_t = { [18710] = true, [18711] = true, [18712] = true, [18713] = true,
                    [18714] = true, }
    if item_id and _gem_num_t[ item_id ] then 
        return true
    else
        return false
    end
end

-- 判断一个道具是否是保护符
function ForgeModel:check_item_is_prot( item_id )
    --保护符的id集合，用来判断某件物品是否是保护符
    local _prot_num_t = { [18720] = true, [18721] = true, [18722] = true, [18723] = true,}
    if item_id and _prot_num_t[ item_id ] then 
        return true
    else
        return false
    end
end

-- 判断一个道具是否是装备
function ForgeModel:check_if_equip_by_series( series )
    local check_ret = false
    local item_date = ItemModel:get_item_in_bag_or_body( series )
    if item_date and ItemModel:check_if_equip_by_id( item_date.item_id ) then
        check_ret = true
    end
    return check_ret
end

-- 获取背包数据，并按id排序
function ForgeModel:get_bag_date_range_by_id(  )
    local bag_date, bag_item_count = ItemModel:get_bag_data()
    local bag_date_clone = {}
    -- 去除空的
    for i = 1, bag_item_count do  
        if bag_date[i] then 
            table.insert( bag_date_clone, bag_date[i] )
        end
    end

    return bag_date_clone, bag_item_count
end

-- 获取宝石等级
-- function ForgeModel:get_gem_level( item_id )
--     local gem_level = 0
--     local item_base = ItemConfig:get_item_by_id( item_id )
--     -- print("item_base, ", tostring(item_base), tostring(item_base.type), tostring(item_base.suitId) )
--     if item_base ~= nil and item_base.type == 85 then
--         print("宝石；；；", item_base.suitId, item_base.type )
--         gem_level = item_base.suitId or 0
--     end

--     return gem_level
-- end

-- 显示物品炼制结果
function ForgeModel:show_handle_result( result , str, ret_type,item_series )
   print("-----------------------------------------------------result , str, ret_type,item_series",result , str, ret_type,item_series)
   -- xiehande  装备附灵的位置 中间一个，周围三个位置
   local gem_pos = {
       gem_atta   = {[1]=420,[2] = 411},
       gem_atta_zaicu   = {[1]=421,[2] = 411},

       gem_prot   = {[1]=338,[2] =274},
       gem_prot_zaicu   = {[1]=340,[2] =275},

       gem_life   = {[1] = 501,[2] = 272},
       gem_life_zaicu   = {[1] = 504,[2] = 273}
   }
    local gem_type = ForgeModel:get_gem_type();
        local  pro_x = 0
        local pro_y = 0

    local show_content = ""
    if result == 1 then
        SoundManager:playUISound('strength_ok',false)
        if ( ret_type ~= 7 and ret_type ~= 6) then
            -- 通知炼器界面 播放成功特效  xiehande 注释掉
            --[[
            local win = UIManager:find_visible_window("forge_win");
            if ( win ) then 
                win:play_success_effect()
            end
            --]]
        end
        local win = UIManager:find_visible_window("forge_win");
        if ( win ) then
            if ret_type == 1 then
                win:play_gem_insert()
            elseif ret_type == 2 then
                win:play_gem_remove()
            elseif ret_type == 3 then
                win:play_success_effect()
            end
        end
        if ret_type == 3 then
            ForgeModel:check_prot_confirm(  )
            ForgeWin:forge_win_update( "bag_change" )
        end
    else
        -- 没用保护符强化失败时，如果保护符切换了等级（比如+7升级失败，变成+6，需要的保护符由高级变成中级了），
        -- 这时候会一直没去用保护符。为修复此问题，需要重置_show_prot_confirm状态。   add by gzn
        if ret_type == 3 then
            ForgeModel:check_prot_confirm_after_strength_fail(  )
        end

        show_content = str or ""
        require "GlobalFunc"
        GlobalFunc:create_screen_notic( show_content, 16, _ui_width/2, _ui_height/2, 2 )
        SoundManager:playUISound('strength_fail',false)

        --xiehande  装备强化失败，且强化等级下降时播放特效
        if(ret_type ==3 ) then
        if ForgeModel:check_strengthen_item_need_prot() and _strengthen_prot_series == nil  then
        local win = UIManager:find_visible_window("forge_win");
            if ( win ) then 
                win:play_fail_effect()
            end
        end
       end
    end

    -- 根据不同类型，做相应更新操作
    if ret_type == 3 then          -- 强化
        ForgeModel:get_strengthen_item_meta(  )
    elseif result == 1 and ret_type == 1 then      -- 镶嵌
        ForgeModel:init_insert_gem(  )

    elseif ret_type == 2 then      -- 摘除
        ForgeModel:init_insert_gem(  )

    elseif ret_type == 4 then      -- 合成
        --xiehande  合成成功播放特效
        if(result ==1 ) then
        local win = UIManager:find_visible_window("forge_win");
            if ( win ) then 
                 win:play_synth_effect()
            end 
        end
    elseif ret_type == 5 then      -- 转移
        -- GlobalFunc:create_screen_notic( Lang.forge.tab_four.transfer_succeed, 16, _ui_width/2, _ui_height/2, 2 )
        if(result ==1 ) then
        local win = UIManager:find_visible_window("forge_win");
            if ( win ) then 
                 win:play_qhzy_success_effect()
            end 
        end
    elseif ret_type == 11  or ret_type==12 or ret_type==13 then     -- 升级/升阶/提品
        --xiehande 装备升级/升阶/提品成功后播放特效
        if(result ==1 ) then
            local win = UIManager:find_visible_window("forge_win");
            if ( win ) then 
                 win:play_upsuccess_effect()
            end
        end
    elseif ret_type == 7 then      -- 洗练
        local win = UIManager:find_visible_window("forge_win");
        if ( win ) then 
            win:update("xilian",{ item_series })
        end
    elseif ret_type == 6 then
        local win = UIManager:find_visible_window("forge_win");
        if ( win ) then 
            win:update("xilian2",{ item_series })
        end
    elseif ret_type == 8 then
        local win = UIManager:find_visible_window("zhizunxilian_win");
        if ( win ) then
            win:update("th",{item_series});
        end
    -- 免费洗练次数
    elseif ret_type == 10 then
        free_xilian_count = result
        -- print("更新免费洗练次数。。。。。",free_xilian_count)
        ForgeModel:set_free_xilian_count( free_xilian_count )
    end
    
end

-- ================================================================================================
-- ================================================================================================
-- 强化 
-- ================================================================================================
-- ================================================================================================
local _strengthen_item_series = nil        -- 强化左侧选择的道具  序列号
local _strengthen_gem_series  = nil        -- 强化宝石  序列号
local _strengthen_prot_series = nil        -- 保护符   序列号

local _show_prot_confirm = true           -- 第一次不使用保护符合成时，会弹出确认框。选择确定后，不再弹出


-- 刷新整个界面数据 （ 通过调用  set_strengthen_item_series 来促发整个流程 ）
function ForgeModel:reset_strengthen_item_series(  )
    local item_date = ForgeModel:get_strengthen_item_date(  )
    if item_date and item_date.strong < 15 then        -- 判断道具是否还存在（可能已经在背包中删除）
        ForgeModel:set_strengthen_item_series( _strengthen_item_series )
    else
        ForgeModel:set_strengthen_item_series( nil )
        ForgeWin:forge_win_update( "strengthen_15" )
    end
end


function ForgeModel:set_strengthen_item_series( item_series )
    _strengthen_item_series = item_series
    ForgeWin:forge_win_update( "strengthen_item" )

    ForgeModel:get_strengthen_item_meta(  )
end

-- 获取选中的装备 数据
function ForgeModel:get_strengthen_item_date(  )
    local item_date = nil
    if _strengthen_item_series then
        item_date = ItemModel:get_item_in_bag_or_body( _strengthen_item_series )
    end
    return item_date
end

-- 设置强化石数据
function ForgeModel:set_strengthen_gem_series( item_series )
    _strengthen_gem_series = item_series
    -- ForgeWin:forge_win_update( "strengthen_gem" )
end

-- 获取强化石数据
function ForgeModel:get_strengthen_gem_date(  )
    local item_date = nil
    if _strengthen_gem_series then
        item_date = ItemModel:get_item_in_bag_or_body( _strengthen_gem_series )
    end
    return item_date
end

-- 设置保护符数据
function ForgeModel:set_strengthen_prot_series( item_series )
    _strengthen_prot_series = item_series
    -- ForgeWin:forge_win_update( "strengthen_prot" )
end
function ForgeModel:set_strengthen_prot_id( item_id )
    _strengthen_prot_id = item_id
end
function ForgeModel:set_strengthen_gem_id( item_id )
    _strengthen_gem_id = item_id
end

-- 获取保护符数据
function ForgeModel:get_strengthen_prot_date(  )
    local item_date = nil
    if _strengthen_prot_series then
        item_date = ItemModel:get_item_in_bag_or_body( _strengthen_prot_series )
    end
    return item_date
end

-- 获取选中装备对应的强化宝石和强化符, 并设置
function ForgeModel:get_strengthen_item_meta(  )
    local item_date = ItemModel:get_item_in_bag_or_body( _strengthen_item_series )

    if item_date then
        -- 强化石头
        local gem_item_id_need = EquipEnhanceConfig:get_gem_id_for_forge( item_date.strong )    -- 选择的装备强化等级要用的强化石id
        local gem_date = ItemModel:get_item_info_by_id( gem_item_id_need )                      -- 获取强化石
        if gem_date then--有强化石
            ForgeModel:set_strengthen_gem_series( gem_date.series )
            StrengthenL:change_gem_gray_icon(false)
        else
            ForgeModel:set_strengthen_gem_series( nil )
            StrengthenL:change_gem_gray_icon(true)
        end
        -- 保护符
        local prot_item_id_need = EquipEnhanceConfig:get_prot_id_for_forge( item_date.strong )
        local prot_date = ItemModel:get_item_info_by_id( prot_item_id_need )
        if prot_date then
            if ( not _show_prot_confirm ) and _strengthen_prot_series == nil then               -- 当前没选保护符，并且标记了不提示
                ForgeModel:set_strengthen_prot_series( nil )
            else
                ForgeModel:set_strengthen_prot_series( prot_date.series )
            end
        else
            ForgeModel:set_strengthen_prot_series( nil )
        end
    else
        ForgeModel:set_strengthen_gem_series( nil )
        ForgeModel:set_strengthen_prot_series( nil ) 
        StrengthenL:change_gem_gray_icon(true)
    end
end


-- 获取背包装备，并且把武器放在前面
function ForgeModel:get_bag_equip_attack_head(  )
	local bag_items, bag_item_count = ItemModel:get_bag_data()
    local item_list = {}

    for i = 1, #bag_items do
        if bag_items[i] and ItemModel:get_item_type( bag_items[i].item_id ) == 1 and ItemModel:check_if_equip_by_id( bag_items[i].item_id ) then
            table.insert( item_list, 1, bag_items[i] )
        elseif bag_items[i] and  ItemModel:check_if_equip_by_id( bag_items[i].item_id ) then
        	table.insert( item_list, bag_items[i] )
        end
    end
    return item_list
end

-- 获取强化成功率
function ForgeModel:get_strengthen_success_percent(  )
    local item_date = ForgeModel:get_strengthen_item_date()
    if item_date then
	    require "config/EquipEnhanceConfig"
	    local succ_per = EquipEnhanceConfig:get_forge_succ_per( item_date.strong )
	    -- todo 判断是否vip5  加3%
	    require "model/VIPModel"
	    local user_vip_info = VIPModel:get_vip_info( )
	    local vip_level = user_vip_info.level
	    if vip_level >= 5 and succ_per <= 97 then
            succ_per = succ_per + 3
	    end
	    return succ_per
	else
        return nil
	end
end

-- 获取强化消耗
function ForgeModel:get_strength_cost(  )
    local item_date = ForgeModel:get_strengthen_item_date()
    if item_date then
		require "config/EquipEnhanceConfig"
		local cost = EquipEnhanceConfig:get_forge_need_cost( item_date.strong )
		return cost
	else
        return nil
	end
end


-- 显示购买窗口
function ForgeModel:show_buy_win( item_id )
    -- 如果元宝不够，就打开充值界面
    -- local store_item = StoreConfig:get_store_info_by_id( item_id )
    -- local need_money = 0
    -- local player = EntityManager:get_player_avatar()
    -- if store_item then
    --     need_money = store_item.price[1].price
    -- end

    -- if player.yuanbao < need_money then 
    --     local function confirm2_func()
    --         -- print("打开充值界面")
    --         GlobalFunc:chong_zhi_enter_fun()
    --         --UIManager:show_window( "chong_zhi_win" )
    --     end
    --     ConfirmWin2:show( 2, 2, "",  confirm2_func)
    --     return 
    -- end


	local function but_result_fun()
        -- print("炼器购买成功")
	end
	BuyKeyboardWin:show( item_id, but_result_fun, 1, 99 )
end

-- 显示说明
function ForgeModel:show_help_panel( title_path, content )
	require "UI/common/HelpPanel"
	local t_help_win = HelpPanel:show( 3, title_path, content )
    t_help_win.exit_btn.view:setIsVisible(false)
end

-- -- 获取物品品质颜色
function ForgeModel:get_item_color( item_id )
	require "config/ItemConfig"
	local item_base = ItemConfig:get_item_by_id( item_id )
	if item_base == nil then
        require "config/StaticAttriType"
        return _static_quantity_color[1]
    else
        return _static_quantity_color[ item_base.color + 1 ]
	end
end

-- 判断是否是合成的宝石类型
function ForgeModel:check_if_syn_gem( item_id )
	local syn_gem_t = { [18623] = true, [18624] = true, [18625] = true, [18626] = true,}
	require "config/ItemConfig"
	local item_base = ItemConfig:get_item_by_id( item_id )
	if ( item_base and item_base.type == ItemConfig.ITEM_TYPE_GEM ) or syn_gem_t[ item_id ] then
        return true
	end
	return false
end

-- 判断是否是强化
function ForgeModel:check_if_syn_strength( item_id )
	local syn_strength_id_t = {[18622] = true }
	require "config/ItemConfig"
	local item_base = ItemConfig:get_item_by_id( item_id )
	if ( item_base and item_base.type == ItemConfig.ITEM_TYPE_EQUIP_ENHANCE ) or syn_strength_id_t[ item_id ] then
        return true
	end
	return false
end

-- 判断是否是翅膀
function ForgeModel:check_if_syn_wing( item_id )
    require "config/ItemConfig"
    return ItemConfig:is_wing(item_id)
end

-- 判断是否是宠物
function ForgeModel:check_if_syn_pet( item_id )
    local pet_item = { [28220] = true, [28221] = true, [28222] = true, [28223] = true, [28224] = true, [28225] = true, [28226] = true, [28227] = true, [28228] = true, [28229] = true, [28230] = true, [28231] = true, [28232] = true, [28233] = true, [28234] = true, [28235] = true, [28236] = true, [28237] = true, [28238] = true, [28239] = true,}
    return pet_item[item_id] or false

    -- require "config/ItemConfig"
    -- local item_base = ItemConfig:get_item_by_id(item_id)
    -- if item_base and item_base.type == ItemConfig.ITEM_TYPE_PET then
    --     return true
    -- else
    --     return false
    -- end
end

-- 判断是否可以强化  选择了装备，并且选择了强化石的情况下才可以
function ForgeModel:check_equip_can_strengthen(  )
    if _strengthen_item_series  then -- and _strengthen_gem_series
        return true
    else
        return false
    end
end



function ForgeModel:check_gem_series_select(  )
    if _strengthen_gem_series  then -- and 
        return true
    else
        return false
    end
end

-- 检查某一个sereies是否和选中的一样，如果一样，在创建之后，就设置为不可按状态
function ForgeModel:check_is_strengthen_item( series )
    if series and _strengthen_item_series == series then
        return true
    end
    return false
end

-- 检查某一个sereies是否和选中材料的一样，如果一样，在创建之后，就设置为不可按状态
function ForgeModel:check_is_strengthen_mate( series )
    if series and ( _strengthen_gem_series == series or _strengthen_prot_series == series ) then
        return true
    end
    return false
end

-- 获取强化需要的宝石和保护符 的 id
function ForgeModel:get_strengthen_gem_prot_id(  )
    local item_date = ItemModel:get_item_in_bag_or_body( _strengthen_item_series )
    local gem_item_id_need  = nil
    local prot_item_id_need = nil

    if item_date then
        gem_item_id_need  = EquipEnhanceConfig:get_gem_id_for_forge( item_date.strong )
        prot_item_id_need = EquipEnhanceConfig:get_prot_id_for_forge( item_date.strong )
    -- print("item_date.strong=",item_date.strong)
    end
    -- print("gem_item_id_need=",gem_item_id_need)
    -- print("prot_item_id_need=",prot_item_id_need)
    return gem_item_id_need, prot_item_id_need
end

-- 道具id是不是需要的材料道具id
function ForgeModel:check_item_id_if_strength_mate( item_id  )
    local gem_item_id_need, prot_item_id_need = ForgeModel:get_strengthen_gem_prot_id(  )
    if item_id and (item_id == gem_item_id_need or item_id == prot_item_id_need ) then 
        return true
    else
        return false
    end
end

-- 获取材料的序列号列表, 返回列表，
function ForgeModel:get_strengthen_meterial(  )
    local mate_series_t = {}
    local gem_item_id_need, prot_item_id_need = ForgeModel:get_strengthen_gem_prot_id(  )
    local bag_items, bag_item_count = ItemModel:get_bag_data()

    for i = 1, bag_item_count do 
        if bag_items[i] and (bag_items[i].item_id == gem_item_id_need or bag_items[i].item_id == prot_item_id_need ) then 
            table.insert( mate_series_t, bag_items[i].series )
        end 
    end
    return mate_series_t
end

-- 判断是否有材料  返回 强化石和保护符的 判断
function ForgeModel:check_if_exist_mate(  )
    local gem_item_id_need, prot_item_id_need = ForgeModel:get_strengthen_gem_prot_id(  )
    local if_gem_exist = false          -- 是否存在强化石
    local if_prot_exist = false         -- 是否存在保护符

    local if_gem_exist = ItemModel:get_item_info_by_id( gem_item_id_need )  and true
    local if_prot_exist = ItemModel:get_item_info_by_id( prot_item_id_need ) and true
    return if_gem_exist, if_prot_exist           
end

-- 判断是否已经选择
function ForgeModel:had_selected_strengthen_item(  )
    if _strengthen_item_series then
        return true
    else
        return false
    end
end

-- 判断选中的道具是否需要保护符  （强化2级以上）
function ForgeModel:check_strengthen_item_need_prot(  )
    local if_need_prot = false
    local item_date = ItemModel:get_item_in_bag_or_body( _strengthen_item_series )
    if item_date and item_date.strong > 2 then
        if_need_prot = true
    end
    return if_need_prot
end

-- 判断是否需要 锁定提示
function ForgeModel:check_strengthen_exist_slot_item(  )
    local strengthen_item_date = ForgeModel:get_strengthen_item_date()
    local strengthen_gem_date  = ForgeModel:get_strengthen_gem_date()
    local strengthen_prot_date = ForgeModel:get_strengthen_prot_date()

    if (strengthen_item_date and strengthen_gem_date and strengthen_item_date.flag ~= 1 and strengthen_gem_date.flag == 1) or 
        (strengthen_item_date and strengthen_prot_date and strengthen_item_date.flag ~= 1 and strengthen_prot_date.flag == 1) then
        return true
    end 
    return false
end

-- 强化
function ForgeModel:do_strengthen( auto_stone_buy,auto_fu_buy )
    local function confirm_func(  )
        ForgeModel:send_request_forge( auto_stone_buy,auto_fu_buy )
    end
    local function prot_confirm_func(  )
        -- 保护符确定
        _show_prot_confirm = false
        confirm_func(  )
    end
    -- 未使用强化符提示
    if ForgeModel:check_strengthen_item_need_prot() and _strengthen_prot_series == nil and _show_prot_confirm and auto_fu_buy ==false then
        local notice_words = LangModelString[143] -- [143]="本次强化未使用保护符，若强化失败，强化等级下降，确认继续吗？"
        ConfirmWin2:show( 4, 1, notice_words, prot_confirm_func, nil )
        return
    end

    -- 如果是使用绑定材料来强化非绑定材料，就要弹出确定框
    if ForgeModel:check_strengthen_exist_slot_item(  ) then
        local notice_words = LangModelString[144] -- [144]="所使用的材料含有绑定材料，操作后装备将绑定"
        ConfirmWin2:show( 4, 1, notice_words, confirm_func, nil )
        return
    end

    -- if _show_is_auto_buy_win and (_strengthen_gem_series == nil or _strengthen_prot_series == nil) and ForgeModel:check_gem_series_select() == false and auto_stone_buy and auto_fu_buy then
    --     ForgeModel:show_is_auto_buy_win()
    -- else
        confirm_func(  )
    -- end
end

-- 判断是否再次显示保护符提示  每当升到另一个层次的时候，要重新有提示  (此方法只在服务器返回强化成功的时候调用)
function ForgeModel:check_prot_confirm(  )
    local item_date = ItemModel:get_item_in_bag_or_body( _strengthen_item_series )
    if item_date and (item_date.strong == 3 or item_date.strong == 6 or item_date.strong == 9 or item_date.strong == 12) then
        _show_prot_confirm = true
    end
end

-- 判断是否再次显示保护符提示  每当降到另一个层次的时候，要重新有提示  (此方法只在服务器返回强化失败的时候调用)
function ForgeModel:check_prot_confirm_after_strength_fail(  )
    local item_date = ItemModel:get_item_in_bag_or_body( _strengthen_item_series )
    if item_date and (item_date.strong == 2 or item_date.strong == 5 or item_date.strong == 8 or item_date.strong == 11) then
        _show_prot_confirm = true
    end
end


-- 显示自动购买确认窗口
function ForgeModel:show_is_auto_buy_win(  )
    local item_id, item_id_2 = ForgeModel:get_strengthen_gem_prot_id()
    local store_item = StoreConfig:get_store_info_by_id(item_id)
    local need_money = 0
    local content = ""
    local item_name = ""
    local money_name = "元宝"
    local other_tips = ""
    local money_type_1 = 3
    local money_type_2 = 3
    if _strengthen_gem_series == nil and store_item then
        need_money = store_item.price[1].price
        item_name = ForgeModel:get_item_name_with_color(item_id)
        money_type_1 = store_item.price[1].type
        money_name = _static_money_type[money_type_1]
        if MallModel:get_only_use_yb(  ) and money_type_1 == 5 then
            money_name = _static_money_type[3] 
        end
        content = "#cffffff将花费" .. need_money .. "#cffffff" .. money_name .. "#cffffff购买" .. item_name
    end
    local store_item_2 = StoreConfig:get_store_info_by_id(item_id_2)
    if store_item_2 then
        content = content .. "#cffffff和"
    end
    if _strengthen_prot_series == nil and store_item_2 then
        need_money = store_item_2.price[1].price
        item_name = ForgeModel:get_item_name_with_color(item_id_2)
        money_type_2 = store_item_2.price[1].type
        money_name = _static_money_type[money_type_2]
        if MallModel:get_only_use_yb(  ) and money_type_2 == 5 then
            money_name = _static_money_type[3] 
        end
        content = content .. need_money .. "#cffffff" .. money_name .. "#cffffff购买" .. item_name
    end

    if MallModel:get_only_use_yb(  ) == false and (money_type_1 == 5 or money_type_2 == 5) then
        other_tips = "#cffffff，礼券不足时，使用元宝代替"
    end

    content = content .. other_tips .. "#cffffff，您确定吗？"

    local function confirm_func(  )
        ForgeModel:send_request_forge( true, true )
    end
    local function switch_fun( if_select )
        ForgeModel:set_show_confirm_auto_buy( not if_select )
    end
    ConfirmWin2:show(5, nil, content, confirm_func, switch_fun, nil)
end
_show_is_auto_buy_win = true
function ForgeModel:set_show_confirm_auto_buy( flag )
    _show_is_auto_buy_win = flag
end

-- 向服务器发送强化信息
function ForgeModel:send_request_forge( auto_stone_buy,auto_fu_buy )
    -- print("==========ForgeModel:send_request_forge")
    local id_items = {}
    -- print("强化石_strengthen_gem_series=",_strengthen_gem_series)

    -- 天将雄师项目组，强制使用保护符
    ForgeModel:force_set_strengthen_prot_series()

    --判断装备个数   。 
    if _strengthen_item_series == nil then
        return                                         -- 如果装备和宝石都没有，就不能发送。
    elseif  _strengthen_gem_series == nil and auto_stone_buy == false then
        return 
    elseif  _strengthen_prot_series == nil and auto_fu_buy ==false then        --装备和宝石都有，保护符没有的情况       
        table.insert( id_items, _strengthen_item_series )
        if _strengthen_gem_series ~= nil then
            table.insert( id_items, _strengthen_gem_series )
        else
            table.insert( id_items, 0 )
        end
        -- print("fuck 1111111")
    else                                               --装备和宝石 保护符都有
        table.insert( id_items, _strengthen_item_series )
        if _strengthen_gem_series ~= nil then
            table.insert( id_items, _strengthen_gem_series )
        else
            table.insert( id_items,  0 )
        end
        if _strengthen_prot_series ~= nil then
            table.insert( id_items, _strengthen_prot_series )
        else            
            table.insert( id_items,  0 )
        end
        -- print("_strengthen_item_series=",_strengthen_item_series)
        -- print("_strengthen_gem_series=",_strengthen_gem_series)
        -- print("_strengthen_prot_series=",_strengthen_prot_series)

    end
    
    -- for key,teleport in pairs(id_items) do
    --     print("teleport=",teleport)
    -- end


    local htype = 3
    local param_count = 3                             --装备强化不用发送
    local param_arr = {};
    local param1 = 0;
    local param2 = 0;
    -- print("auto_buy=",auto_buy)
    if  auto_stone_buy   then
        param1 = 1;
    end
    if  auto_fu_buy   then
        param2 = 1;
    end
    -- print("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^param1=",param1)
    -- print("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^param2=",param2)
    local money_type = MallModel:get_only_use_yb() and 3 or 2
    local price = 0
    local gem_item_id_need, prot_item_id_need = ForgeModel:get_strengthen_gem_prot_id(  )

    if auto_stone_buy then
        local store_item = StoreConfig:get_store_info_by_id(gem_item_id_need)
        price = price + store_item.price[1].price
    end

    if auto_fu_buy and ForgeModel:check_strengthen_item_need_prot(  ) and prot_item_id_need and prot_item_id_need ~= 0 then
        local store_item = StoreConfig:get_store_info_by_id(prot_item_id_need)
        price = price + store_item.price[1].price
    end

    table.insert(param_arr,param1);
    table.insert(param_arr,param2);
    table.insert(param_arr, money_type)

    local param = {#id_items, id_items, htype, param_count, param_arr, money_type}
    local strengthen_fun = function( param )
        param[5][#param[5]] = param[6]
        ItemCC:req_handle_item(param[1], param[2], param[3], param[4], param[5])
    end

    if auto_stone_buy then
        MallModel:handle_auto_buy( price, strengthen_fun, param )
    else
        ItemCC:req_handle_item( #id_items, id_items, htype, param_count, param_arr )
    end

    -- require "control/ItemCC"
    -- ItemCC:req_handle_item( #id_items, id_items, htype, param_count, param_arr )
end

function ForgeModel:send_request_get_wish_val(  )
    if (_strengthen_item_series) then
        -- print("===== get wish val ====")
        ItemCC:req_handle_item(1, {_strengthen_item_series}, 15, 1, {1})
    end
end

_wish_val = 0
-- 祝福值
function ForgeModel:set_wish_val( val )
    -- print("==== 祝福值：" .. val .. " =====")
    _wish_val = val
    ForgeWin:forge_win_update("wish_val")
end

function ForgeModel:get_wish_val( ... )
    return _wish_val
end

function ForgeModel:get_max_wish_val( streng_level )
    return EquipEnhanceConfig:get_max_wish_val(streng_level)
end

-- ================================================================================================
-- ================================================================================================
-- 镶嵌
-- ================================================================================================
-- ================================================================================================
local _insert_item_series = nil            -- 选中镶嵌的装备 序列号
local _insert_atta_series = nil            -- 攻击宝石 序列号
local _insert_prot_series = nil            -- 防御宝石 序列号
local _insert_life_series = nil            -- 生命宝石 序列号

local _select_gem_type = nil
local _gem_meta_t = nil

function ForgeModel:set_select_gem( gem_type )
    _select_gem_type = gem_type
    if gem_type then
        ForgeWin:forge_win_update("select_" .. gem_type)
    end
end

function ForgeModel:get_select_gem(  )
    return _select_gem_type
end

-- 设置选中的装备 序列号
function ForgeModel:set_insert_item_series( insert_item_series )
    _insert_item_series = insert_item_series
    ForgeWin:forge_win_update( "insert_item_series" )
    ForgeModel:init_insert_gem(  )
end

-- 获取选中的装备数据 
function ForgeModel:get_insert_item_date(  )
    local item_date = nil
    if _insert_item_series then
        item_date = ItemModel:get_item_in_bag_or_body( _insert_item_series )
    end
    return item_date    
end

-- 初始化 宝石 （每次摘除或者镶嵌之后，都要把三个选中的设置成nil）
function ForgeModel:init_insert_gem(server_resp)
    _insert_atta_series = nil
    _insert_prot_series = nil
    _insert_life_series = nil
    _gem_type = nil
    _gem_level = nil
    ForgeWin:forge_win_update( "insert_atta_series" )
    ForgeWin:forge_win_update( "insert_prot_series" )
    ForgeWin:forge_win_update( "insert_life_series" )
end

function ForgeModel:remove_inser_gem(server_resp)
    ForgeWin:forge_win_update("remove_inser_gem",server_resp)
end

function ForgeModel:update_inser_gem(server_resp)
    local item_id = ForgeModel:get_insert_item_gem( _gem_type )
    local gem_item = ItemConfig:get_item_by_id(item_id)
    if gem_item then
        _gem_level = gem_item.suitId
    else
        _gem_level = 0
    end
    ForgeWin:forge_win_update( "insert_atta_series", server_resp)
    ForgeWin:forge_win_update( "insert_prot_series", server_resp)
    ForgeWin:forge_win_update( "insert_life_series", server_resp)
    ForgeWin:forge_win_update("update_meta_preview")
end

-- 获取选中装备的宝石  atta  prot  life
function ForgeModel:get_insert_item_gem( gem_type )
    local item_date = ForgeModel:get_insert_item_date(  )
    local gem_item_id = nil
    if item_date then
        if gem_type == "atta" or gem_type == 1 then
            gem_item_id = item_date.holes[1]
        elseif gem_type == "prot" or gem_type == 2 or gem_type == 3 then
            gem_item_id = item_date.holes[2]
        elseif gem_type == "life" or gem_type == 4 then
            gem_item_id = item_date.holes[3]
        end
    end
    return gem_item_id
end

function ForgeModel:get_item_gem( series, gem_type )
    local item_date = ItemModel:get_item_in_bag_or_body( series )
    local gem_item_id = nil
    if item_date then
        if gem_type == "atta" or gem_type == 1 then
            gem_item_id = item_date.holes[1]
        elseif gem_type == "prot" or gem_type == 2 or gem_type == 3 then
            gem_item_id = item_date.holes[2]
        elseif gem_type == "life" or gem_type == 4 then
            gem_item_id = item_date.holes[3]
        end
    end
    return gem_item_id
end

-- 设置选择的攻击宝石 
function ForgeModel:set_insert_atta_series( insert_atta_series )
    if ForgeModel:get_insert_item_gem( "atta" ) == nil and _insert_item_series or 
        ForgeModel:get_insert_item_gem( "atta" ) == 0 then       -- 如果已经有镶嵌同类宝石，是不可以选择的
        _insert_atta_series = (insert_atta_series ~= 0) and insert_atta_series or nil
        ForgeWin:forge_win_update( "insert_atta_series" )
    -- elseif insert_atta_series then
    --     GlobalFunc:create_screen_notic( Lang.forge.gem_set[9])
    end
end

-- 获取攻击宝石 数据
function ForgeModel:get_insert_atta_date(  )
    local item_date = nil
    if _insert_atta_series then
        item_date = ItemModel:get_item_in_bag_or_body( _insert_atta_series )
    end
    return item_date   
end

-- 设置选择的防御宝石 
function ForgeModel:set_insert_prot_series( insert_prot_series )
    if ForgeModel:get_insert_item_gem( "prot" ) == nil and _insert_item_series or 
       ForgeModel:get_insert_item_gem( "prot" ) == 0 then       -- 如果已经有镶嵌同类宝石，是不可以选择的
        _insert_prot_series = (insert_prot_series ~= 0) and insert_prot_series or nil
        ForgeWin:forge_win_update( "insert_prot_series" )
    -- else
    --     GlobalFunc:create_screen_notic( Lang.forge.gem_set[9])
    end
end

-- 获取防御宝石 数据
function ForgeModel:get_insert_prot_date(  )
    local item_date = nil
    if _insert_prot_series then
        item_date = ItemModel:get_item_in_bag_or_body( _insert_prot_series )
    end
    return item_date   
end

-- 设置生命宝石  数据
function ForgeModel:set_insert_life_series( insert_life_series )
    if ForgeModel:get_insert_item_gem( "life" ) == nil and _insert_item_series or 
       ForgeModel:get_insert_item_gem( "life" ) == 0 then       -- 如果已经有镶嵌同类宝石，是不可以选择的
        _insert_life_series = (insert_life_series ~= 0) and insert_life_series or nil
        --print('set_insert_life_series _insert_life_series:' .. _insert_life_series)
        ForgeWin:forge_win_update( "insert_life_series" )
    -- else
    --     GlobalFunc:create_screen_notic( Lang.forge.gem_set[9])
    end
end

-- 获取生命宝石id
function ForgeModel:get_insert_life_date(  )
    local item_date = nil
    if _insert_life_series then
        item_date = ItemModel:get_item_in_bag_or_body( _insert_life_series )
    end
    return item_date 
end

-- 判断某个id，是否是装备镶嵌了的道具
-- function ForgeModel:check_item_id_inserted( item_id )
--     local check_ret = false
--     local item_date = ForgeModel:get_insert_item_date(  )
--     if item_date and item_id then
--         for key, id in paris( item_date.holes ) do 
--             if id == item_id then
--                 check_ret = true
--                 break
--             end
--         end
--     end
--     return check_ret
-- end

-- 获取宝石的加成属性 名称和值
function ForgeModel:get_gem_add_attribute( item_id )
    local attr_name = nil
    local attr_value = nil
    if item_id == nil then
        return attr_name, attr_value
    end
    local attr_t = ItemConfig:get_staitc_attrs_by_id( item_id )
    if attr_t[1] then
        require "config/ComAttribute"
        if attrNameforForge[ attr_t[1]["type"] + 1 ] then
            attr_name = attrNameforForge[ attr_t[1]["type"] + 1 ]
        end
        if attr_t[1]["value"] then
            attr_value = attr_t[1]["value"]
        end
    end
    return attr_name, attr_value
end

-- 右侧选中某个道具
function ForgeModel:insert_select_item( series )
    -- ForgeModel:set_select_gem(nil)
    local item_date = ItemModel:get_item_in_bag_or_body( series )
    if item_date then
        if ItemModel:check_if_equip_by_id( item_date.item_id ) then
            ForgeModel:set_insert_item_series( series )
        elseif _insert_item_series == nil then                       -- 没有选择装备情况下选择宝石
            local show_content = LangModelString[145] -- [145]="请先选择装备"
            GlobalFunc:create_screen_notic( show_content, 16, _ui_width/2, _ui_height/2, 2 )
        elseif ItemConfig:is_attack_gem( item_date.item_id ) then        -- 攻击
            ForgeModel:set_insert_atta_series( item_date.series )
        elseif ItemConfig:is_prot_gem( item_date.item_id ) then      -- 防御
            ForgeModel:set_insert_prot_series( item_date.series )
        elseif ItemConfig:is_life_gem( item_date.item_id ) then      -- 生命
            ForgeModel:set_insert_life_series( item_date.series )
        end
    end
end

-- 判断当前是否可以镶嵌  有选择的宝石的时候
function ForgeModel:check_insert_enable(  )
    local insert_enable = false
    if _insert_item_series and
        ( _insert_atta_series or _insert_prot_series or _insert_life_series ) then
        insert_enable = true
    end

    if _insert_item_series  then
        insert_enable = true
    else
        -- local show_content = "请选择装备和宝石"
        -- GlobalFunc:create_screen_notic(show_content, nil, 250, 130)
    end

    -- print("==== insert enable: " .. tostring(insert_enable) .. "=====")
    return insert_enable
end

function ForgeModel:check_selected_gem(  )
    if _gem_type then
        return true
    else
        return false
    end
end

-- 判断选择的宝石是否包含锁定道具
function ForgeModel:check_insert_gem_contain_lock(  )
    if not ItemModel:check_item_lock( _insert_item_series ) and 
        (  ItemModel:check_item_lock( _insert_atta_series ) or 
           ItemModel:check_item_lock( _insert_prot_series ) or 
           ItemModel:check_item_lock( _insert_life_series )  ) then
        return true
    end
    return false
end

-- 计算某个装备的宝石镶嵌数
function ForgeModel:equip_gem_add_up( series )
    return ItemModel:equip_gem_add_up( series )
end

-- 判断某个道具是否已经被选中
function ForgeModel:check_insert_item_selected( series )
    if series and (  ( _insert_item_series == series ) or 
                     ( _insert_atta_series == series ) or 
                     ( _insert_prot_series == series ) or 
                     ( _insert_life_series == series )  ) then
        return true
    end
    return false
end        

-- 镶嵌按钮按下
function ForgeModel:do_insert_gem(  )
    -- local function confirm_func(  )
        local item_count = 1                               -- 物品个数
        local id_items = {}                                -- 物品的序列号
        local param_arr = {}                               -- 参数：孔的位置
        local htype = 1 
        
        if ForgeModel:check_insert_enable(  ) then
            table.insert( id_items, _insert_item_series )
            if _insert_atta_series then
                item_count = item_count + 1
                table.insert( id_items, _insert_atta_series )
                table.insert( param_arr, 1 )
            end
            if _insert_prot_series then
                item_count = item_count + 1
                table.insert( id_items, _insert_prot_series )
                table.insert( param_arr, 2 )
            end
            if _insert_life_series then
                item_count = item_count + 1
                table.insert( id_items, _insert_life_series )
                table.insert( param_arr, 3 )
            end 
            -- print("======== gem_type: " .. _gem_type .. "======")
            -- table.insert(param_arr, _gem_type)
            -- if 1 == _gem_type then
            --     table.insert(param_arr, 1)
            -- elseif 2 == _gem_type or 3 == _gem_type then
            --     table.insert(param_arr, 2)
            -- elseif 4 == _gem_type then
            --     table.insert(param_arr, 3)
            -- end
            local param_count = item_count - 1                 -- 物品数量除去被镶嵌宝石的物品。所以减1
            ForgeModel:send_set_gem(item_count, id_items, htype, param_count, param_arr)
        end
    -- end
    -- 绑定提示
    -- if _insert_item_series and  ForgeModel:check_insert_gem_contain_lock(  )  then
    --     local notice_words = LangModelString[146] -- [146]="所镶嵌宝石含有绑定宝石，操作后装备将绑定"
    --     ConfirmWin2:show( 4, 1, notice_words, confirm_func, nil )
    --     return
    -- elseif _insert_item_series then
    --     confirm_func(  )
    -- end    
end

function ForgeModel:check_had_gem_meta_in_bag( )
    local put_meta_t = ForgeModel:get_put_gem_meta_t( )
    if not put_meta_t then
        return false
    end

    local meta_sum = 0
    for k,v in pairs(put_meta_t) do
        meta_sum = meta_sum + v
    end
    return meta_sum > 0
end

function ForgeModel:check_gem_meta_enough( )
    local gemtype = ForgeModel:get_gem_type()
    local level = ForgeModel:get_gem_level()
    local meta_cost = ForgeModel:get_gem_meta_cost(gemtype, level+1)
    if _gem_meta_t[gemtype] < meta_cost then
        GlobalFunc:create_screen_notic( LangGameString[2439], 16, _ui_width/2, _ui_height/2, 2 ) -- "精华材料不足"
        return false
    end
    return true
end

-- 发送镶嵌消息
function ForgeModel:send_set_gem( item_count, id_items, htype, param_count, param_arr )
    local player = EntityManager:get_player_avatar()
    -- local gemtype = ForgeModel:get_gem_type()
    -- local level = ForgeModel:get_gem_level()
    -- local meta_cost = ForgeModel:get_gem_meta_cost(gemtype, level)
    local need_money = 2000 * param_count
    if player.bindYinliang < need_money then
        GlobalFunc:create_screen_notic( LangModelString[147], 16, _ui_width/2, _ui_height/2, 2 ) -- [147]="忍币不足"
    -- elseif _gem_meta_t[gemtype] < meta_cost then
    --     GlobalFunc:create_screen_notic( "宝石材料不足", nil, 180, 130 ) -- [147]="材料不足"
    else
        -- print("==== send gem set message ====")
        ItemCC:req_handle_item (item_count, id_items, htype, param_count, param_arr) 
    end
end

-- 摘除按钮调用   atta  prot  life
function ForgeModel:do_remove_gem( gem_type )
    print("xiehande 拆除")
    print(gem_type)
    local gem_place = nil
    if gem_type == "atta" then
        gem_place = 1
    elseif gem_type == "prot" then
        gem_place = 2
    elseif gem_type == "life" then
        gem_place = 3
    elseif gem_type == 2 or gem_type == 3 then
        gem_place = 2
    elseif gem_type == 4 then
        gem_place = 3
    elseif gem_type == 1 then
        gem_place = 1
    else
        gem_place = gem_type
    end
    ForgeModel:send_request_remove_gem(  _insert_item_series, gem_place )
end

-- 摘除宝石
function ForgeModel:send_request_remove_gem(  item_series, gem_place )
    if item_series == nil then
        return 
    end
    local item_count = 1                                              -- 物品个数
    local id_items = { item_series }                                  -- 装备的序列号
    local htype = 2                                                   --操作类型
    local param_count = 1
    local param_arr = { gem_place }                                   -- 参数：孔的位置

    local player = EntityManager:get_player_avatar()
    local need_money = 2000 
    if player.bindYinliang < need_money then
    	-- GlobalFunc:create_screen_notic( LangModelString[147], 16, _ui_width/2, _ui_height/2, 2 ) -- [147]="仙币不足"
        --天降雄狮修改 xiehande  如果是铜币不足/银两不足/经验不足 做我要变强处理
        ConfirmWin2:show( nil, 15, Lang.screen_notic[11],  need_money_callback, nil, nil )
    	return false
    else
        ItemCC:req_handle_item (item_count, id_items, htype, param_count, param_arr)
        return true
    end
end

function ForgeModel:req_gem_meta( ... )
    print("---------- meta ---------------")
    ItemCC:req_gem_meta()
end

function ForgeModel:set_gem_meta( gem_meta_t )
    _gem_meta_t = gem_meta_t
    --print("---------- meta ---------------")
    -- for k,v in pairs(_gem_meta_t) do
    --     print(k,v)
    -- end
end

function ForgeModel:get_gem_meta(  )
    return _gem_meta_t
end

function ForgeModel:get_1_level_gem( item_type )
    require "config/EquipEnhanceConfig"
    require "config/ItemConfig"
    if "atta" == item_type then
        local id = EquipEnhanceConfig:get_1_level_atta_gem_id()
        local item = ItemConfig:get_item_by_id(id)
        return item
    elseif "prot" == item_type then
        local id = EquipEnhanceConfig:get_1_level_prot_gem_id()
        local item = ItemConfig:get_item_by_id(id[1])
        local item2 = ItemConfig:get_item_by_id(id[2])
        return item, item2
    elseif "life" == item_type then
        local id = EquipEnhanceConfig:get_1_level_life_gem_id()
        local item = ItemConfig:get_item_by_id(id)
        return item
    else
        return nil
    end
end

function ForgeModel:get_gem_meta_cost( type, level )
    require "config/EquipEnhanceConfig"
    return EquipEnhanceConfig:get_gem_meta_cost(type, level) or 0
end

function ForgeModel:get_gem_money_cost( ... )
    require "config/EquipEnhanceConfig"
    return EquipEnhanceConfig:get_gem_money_cost()
end

function ForgeModel:get_cost_meta_name( type )
    if 1 == type then
        return "攻击材料"
    elseif 2 == type then
        return "物防材料"
    elseif 3 == type then
        return "法防材料"
    elseif 4 == type then
        return "生命材料"
    else
        return ""
    end
end

_gem_type = nil
_gem_level = nil

function ForgeModel:set_gem_type(type)
    -- print("=========gem_type: ", type)
    _gem_type = type
end
function ForgeModel:get_gem_type()
    return _gem_type
end
function ForgeModel:set_gem_level(level)
    _gem_level = level
end
function ForgeModel:get_gem_level()
    return _gem_level
end

function ForgeModel:req_get_gem_meta(  )
    MiscCC:req_get_gem_meta()
end

function ForgeModel:do_get_gem_meta( meta_t )
    _put_gem_meta_t = meta_t

    if ForgeModel:get_update_type() == "forge_dialog" then
        ForgeDialog:update(5)
    end
end

function ForgeModel:get_put_gem_meta_t(  )
    return _put_gem_meta_t
end

_update_type = nil
function ForgeModel:set_update_type( _type )
    _update_type = _type
end

function ForgeModel:get_update_type( )
    return _update_type
end


-- ================================================================================================
-- ================================================================================================
-- 合成
-- ================================================================================================
-- ================================================================================================
-- 批量合成
function ForgeModel:batch_synth( series_t, item_id )
	local max_num = ForgeModel:calculate_synth_max_num( series_t, item_id ) or 0
	local function but_result_fun( num )
        ForgeModel:request_batch_synth( series_t, num )
	end
	-- 判断是否锁定材料和未所动给材料混合
	local function check_lock_cb(  )
		BuyKeyboardWin:show( item_id, but_result_fun, 10, max_num )
	end
	ForgeModel:check_synth_lock_mate( series_t, check_lock_cb )
end

-- 合成一个物品  界面调用
function ForgeModel:one_item_synth( series_t )
    local function check_lock_mate_cb(  )
        ForgeModel:request_batch_synth( series_t, 1 )
    end
    ForgeModel:check_synth_lock_mate( series_t, check_lock_mate_cb )
end


-- 根据物品id，获取该物品合成需要的数量
function ForgeModel:get_need_money_by_id( item_id )
    if item_id == nil then
        return 0
    end
    require "config/EquipEnhanceConfig"
    local mix_item_t = EquipEnhanceConfig:get_can_mix_item_id()             -- 可合成的物品，用来确定数量表的序列号 
    local synth_need_money_t = EquipEnhanceConfig:get_mix_need_money(  )      -- 合成需要的数量表
    for i, v in ipairs(mix_item_t) do
        if v == item_id then
            return synth_need_money_t[ i ]
        end
    end
    return 0
end

-- 根据物品id，获取该物品合成需要的数量   注意：在没有的时候要返回nil，这时用来判断的条件，不能改
function ForgeModel:get_need_num_by_id( item_id )
    if item_id == nil then
        return nil   
    end
    require "config/EquipEnhanceConfig"
    local mix_item_t = EquipEnhanceConfig:get_can_mix_item_id()             -- 可合成的物品，用来确定数量表的序列号 
    local synth_need_num_t = EquipEnhanceConfig:get_mix_need_num(  )        -- 合成需要的数量表
    for i, v in ipairs(mix_item_t) do
        if v == item_id then
            return synth_need_num_t[ i ]
        end
    end
    return nil
end

-- 检查是否包含绑定材料。并且提示会合成几个绑定材料: 参数：所有选中材料的序列号，回调函数 
function ForgeModel:check_synth_lock_mate( series_t, fun )
    local if_has_lock = false                       -- 是否包含绑定材料
    local lock_count = 0                            -- 绑定材料的数量
    local if_has_no_lock = false                    -- 是否存在不绑定的材料
    for i, series in ipairs( series_t ) do 
        local item = ItemModel:get_item_by_series( series )
        if item and item.flag == 1 then
            if_has_lock = true
            lock_count = lock_count + item.count
        elseif item then
            if_has_no_lock = true
        end
    end
    if if_has_lock and if_has_no_lock then           -- 如果包含，要先提示
        local notice_words = LangModelString[148] -- [148]="合成的材料中包涵绑定材料， 合成后将是绑定材料"
        ConfirmWin( "select_confirm", nil, notice_words, fun, nil, 80, 190)
        return 
    else                                             -- 不包含，就直接回调
    	fun()
    end
    
end

-- 计算合成的总量
function ForgeModel:calculate_synth_max_num( series_t, item_id )
	local item_total = ItemModel:add_total_by_series_t( series_t )
    local synth_need_num = ForgeModel:get_need_num_by_id( item_id )

    return math.floor( item_total / synth_need_num )
end

-- 批量合成消息
function ForgeModel:request_batch_synth( series_t, num )
    local item_count = #series_t                                        -- 物品个数
    local id_items = series_t                                           -- 物品的序列号
    local htype = 4                                                      -- 操作类型
    local param_count = 1
    local param_arr = { num }                                    
    ItemCC:req_handle_item (item_count, id_items, htype, param_count, param_arr)
end

-- 取得免费洗练次数
function ForgeModel:get_free_xilian_count()
    return free_xilian_count;
end

function ForgeModel:set_free_xilian_count( _free_xilian_count )
    free_xilian_count = _free_xilian_count;
end

-- -- 获取装备需要等级
-- function ForgeModel:get_equipment_level( item_id )
--     if item_id == 18800 or item_id == "18800" or item_id == 18810 or item_id == "18810" then  -- 天劫石 / 星幻玉
--         return 40
--     elseif item_id == 18801 or item_id == "18801" or item_id == 18811 or item_id == "18811" then  -- 补天石 / 轮回玉
--         return 60
--     end
--     return nil
-- end

-- -- 装备类型  1：攻击装备  2：防御装备  3：普通装备  4：真装备
-- function ForgeModel:get_equipment_type( item_id )
--     if item_id == 18800 or item_id == "18800" or item_id == 18801 or item_id == "18801" then  -- 天劫石 / 补天石
--         return 1
--     elseif item_id == 18810 or item_id == "18810" or item_id == 18811 or item_id == "18811" then  -- 星幻玉 / 轮回玉
--         return 2
--     elseif item_id == 18750 or item_id == "18750" then  -- 紫薇极玉
--         return 3
--     elseif item_id == 18830 or item_id == "18830" then  -- 龙纹赤金
--         return 4
--     end
--     return nil
-- end

--获取装备的基础属性以及强化属性值加成
function ForgeModel:get_equipment_base_attri_text( model_data, attr_type )
    local equip_data = ItemConfig:get_item_by_id(model_data.item_id);
    -- 基础属性
    local staticAttris = equip_data.staitcAttrs;
    -- 强化属性
    local strongAttris = equip_data.strongAttrs;
    -- 品质属性
    local qualityAttris = equip_data.qualityAttrs;

    -- local text = c3_yellow..LangGameString[1968] -- [1968]="基础属性#r"
    local attr_value = 0

    local strongAttri = {};
    if model_data.strong ~= 0 and model_data.strong ~= nil then
        strongAttri = strongAttris[model_data.strong];
    end
    
    -- 装备品质
    local equip_quality = model_data.void_bytes_tab[1];

    -- for i,v in ipairs(staticAttris) do
    local v = staticAttris[attr_type]

        local quality_att_value = 0;
        if equip_quality >= 2 then
            -- 品质是从1开始算起的，普通 = 1，依次递增
            -- 而品质的加成是从精良=2开始加成的,而配置是从精良=1开始，所以在去配置的时候要-1;
            local qual_data = equip_data.qualityAttrs[equip_quality-1];
            if qual_data then
                quality_att_value = qual_data[attr_type].value;
            end
        end
        local _type = staticAttriTypeList[v.type];
        -- 基础属性数值
        local _value = v.value;
        local type_len = string.len(_type);
        -- local space_str = get_space_str_by_str_len(type_len);
        -- text = text..c3_white.._type..space_str.."+"..( _value + quality_att_value );
        attr_value = attr_value + _value + quality_att_value

        if #strongAttri ~= 0 and equip_data.type ~= ItemConfig.ITEM_TYPE_MARRIAGE_RING then
            -- 非婚戒的强化加成
            local strong_table = strongAttri[attr_type];
            -- 强化数值的品质加成率
            local quality_k = EquipEnhanceConfig:get_quality_addition_valua( model_data.strong )
            -- text = text..c3_red.."+"..math.floor(strong_table.value+quality_att_value*quality_k);
            attr_value = attr_value + math.floor(strong_table.value+quality_att_value*quality_k);
        end

        if equip_data.type == ItemConfig.ITEM_TYPE_MARRIAGE_RING and  #strongAttri ~= 0 then
            --如果是婚戒的加成，数值是不需要乘以一个系数值
            local strong_table = strongAttri[attr_type];
            if strong_table.value ~= 0 then
                -- text = text..c3_green.."+"..math.floor(strong_table.value);
                attr_value = attr_value + math.floor(strong_table.value);
            end
        end


        -- text = text.."#r";
    -- end

    -- --洗练属性
    -- if model_data.smith_num ~= nil and model_data.smith_num > 0 then
    --     text = text..c3_yellow..LangGameString[1969]; -- [1969]="洗练属性#r"
    --     for i=1,model_data.smith_num do
    --         local type_str = staticAttriTypeList[model_data.smiths[i].type];
    --         local type_len = string.len(type_str);
            
    --         local space_str = get_space_str_by_str_len(type_len);

    --         local color = EquipEnhanceConfig:get_attr_color( model_data.smiths[i].type ,model_data.smiths[i].value );
    --         local max = EquipEnhanceConfig:get_xl_max_value( model_data.smiths[i].type );
    --         local xilian_value = math.abs(model_data.smiths[i].value);

    --         if xilian_value == max then
    --             text = text ..color.. type_str .. space_str .. "+" .. xilian_value .. LangGameString[1970]; -- [1970]="(满)#r"
    --         else
    --             text = text ..color.. type_str .. space_str .. "+" .. xilian_value .. "#r";
    --         end
    --     end
    -- end

    -- return text;
    return attr_value
end

--记录上一个操作，这是因为炼气有部分消息没有来源，比如增加宝石材料
function ForgeModel:set_last_op(op)
    ForgeModel._last_op[op] = true
end

function ForgeModel:get_last_op(op)
    local ret = ForgeModel._last_op[op]
    ForgeModel._last_op[op] = nil
    return ret
end

-- add tjxs -----------------

-- 计算一键合成的消耗与产出
----宝石道具id
local all_stone_id  = {
        -- 碎片   1级                                             9级   10级   
    [1] = {18623,18510,18511,18512,18513,18514,18515,18516,18517,18518,18519,},--攻击
    [2] = {18624,18520,18521,18522,18523,18524,18525,18526,18527,18528,18529,},--物防
    [3] = {18625,18530,18531,18532,18533,18534,18535,18536,18537,18538,18539,},--法防
    [4] = {18626,18540,18541,18542,18543,18544,18545,18546,18547,18548,18549,},--生命
}
----可合成的道具数量集合
local mix_item      = {
                      --1级                                                                           --9级     --10级
    [1] = {[18623]=0,[18510]=0,[18511]=0,[18512]=0,[18513]=0,[18514]=0,[18515]=0,[18516]=0,[18517]=0,[18518]=0,[18519]=0,},
    [2] = {[18624]=0,[18520]=0,[18521]=0,[18522]=0,[18523]=0,[18524]=0,[18525]=0,[18526]=0,[18527]=0,[18528]=0,[18529]=0,},
    [3] = {[18625]=0,[18530]=0,[18531]=0,[18532]=0,[18533]=0,[18534]=0,[18535]=0,[18536]=0,[18537]=0,[18538]=0,[18539]=0,},
    [4] = {[18626]=0,[18540]=0,[18541]=0,[18542]=0,[18543]=0,[18544]=0,[18545]=0,[18546]=0,[18547]=0,[18548]=0,[18549]=0,},
}
----合成需要的仙币
local mix_money     = {
    [1] = {[18623]=500,[18510]=511,[18511]=512,[18512]=513,[18513]=514,[18514]=515,[18515]=516,[18516]=517,[18517]=955,[18518]=519,},
    [2] = {[18624]=500,[18520]=521,[18521]=522,[18522]=523,[18523]=524,[18524]=525,[18525]=526,[18526]=527,[18527]=528,[18528]=529,},
    [3] = {[18625]=500,[18530]=531,[18531]=532,[18532]=533,[18533]=534,[18534]=535,[18535]=536,[18536]=537,[18537]=538,[18538]=539,},
    [4] = {[18626]=500,[18540]=541,[18541]=542,[18542]=543,[18543]=544,[18544]=545,[18545]=546,[18546]=547,[18547]=548,[18548]=549,},
}
----合成需要的数量
local mix_need      = {
    [1] = {[18623]=6,[18510]=4,[18511]=4,[18512]=4,[18513]=4,[18514]=4,[18515]=4,[18516]=4,[18517]=4,[18518]=4,},
    [2] = {[18624]=6,[18520]=4,[18521]=4,[18522]=4,[18523]=4,[18524]=4,[18525]=4,[18526]=4,[18527]=4,[18528]=4,},
    [3] = {[18625]=6,[18530]=4,[18531]=4,[18532]=4,[18533]=4,[18534]=4,[18535]=4,[18536]=4,[18537]=4,[18538]=4,},
    [4] = {[18626]=6,[18540]=4,[18541]=4,[18542]=4,[18543]=4,[18544]=4,[18545]=4,[18546]=4,[18547]=4,[18548]=4,},
}

----复制返回一个新的数组
local function copy_tabel( arr )
    local arr2 = {}
    for k,v in pairs(arr) do 
        if v then
            arr2[k] = v
        end
    end
   return arr2
end
--计算合成单种所需钱和产出结果,lv有效值为2~10,type有效值为1-4
function ForgeModel:get_easy_synth_result_by_type(lv,type)
    local for_max = lv   --如果合成目标等级为2，则需要判断1级宝石是否够数量,1级宝石在队列中的序号为2

    local all_stone_id_t    = copy_tabel(all_stone_id[type])
    local mix_item_t        = copy_tabel(mix_item[type])
    local mix_money_t       = copy_tabel(mix_money[type])
    local mix_need_t        = copy_tabel(mix_need[type])

    local bag_data,len      = ItemModel:get_bag_data()

    local cost              = 0                     --消耗仙币
    local output_id         = all_stone_id_t[lv+1]    --产出目标的id（以为1级宝石所在队列的序号为2）
    local output_count      = 0                     --产出道具的最终数量

    for k,v in pairs(bag_data) do                   --遍历背包，将符合所限条件的宝石数量记录,不论绑定
        if mix_item_t[v.item_id] then
            mix_item_t[v.item_id] = mix_item_t[v.item_id] + v.count
        end
    end
    for i=1,for_max do
        if mix_item_t[all_stone_id_t[i]] >= mix_need_t[all_stone_id_t[i]] then
            local temp_output = math.floor(mix_item_t[all_stone_id_t[i]]/mix_need_t[all_stone_id_t[i]]) --本次合成可产出的数量
            cost = cost + temp_output * mix_money_t[all_stone_id_t[i]]
            mix_item_t[all_stone_id_t[i]] = mix_item_t[all_stone_id_t[i]] - temp_output*mix_need_t[all_stone_id_t[i]]
            mix_item_t[all_stone_id_t[i+1]] = mix_item_t[all_stone_id_t[i+1]] + temp_output
            if i == for_max then
                output_count = temp_output          -- 最后一次合成的产出数量既是所求
            end
        end
    end
    return output_id, output_count, cost
end

--当type==0时,调用以上方法4次;lv有效值为2~10,type有效值为0-4
function ForgeModel:get_easy_synth_result(lv,type)
    local str                                               -- 提示框的显示文本
    local str_cfg1 = Lang.forge.synth[7]
    local str_cfg2 = Lang.forge.synth[8]
    local str_cfg3 = Lang.forge.synth[9]
    local str_cfg4 = Lang.forge.synth[10]
    --请求合成
    local function fun1()
        print("请求合成", lv,type )
        MiscCC:req_easy_synth( lv,type )
    end
    --仙币或者材料不足
    local function fun2()
        print("仙币或者材料不足")
    end
    local enter_fun = fun2 
    local player_data = EntityManager:get_player_avatar()
    if type == 0 then 
        local output_id1,output_count1,cost1 = ForgeModel:get_easy_synth_result_by_type(lv,1)
        local output_id2,output_count2,cost2 = ForgeModel:get_easy_synth_result_by_type(lv,2)
        local output_id3,output_count3,cost3 = ForgeModel:get_easy_synth_result_by_type(lv,3)
        local output_id4,output_count4,cost4 = ForgeModel:get_easy_synth_result_by_type(lv,4)
        local item_name1 = ItemModel:get_item_name_with_color( output_id1 )
        local item_name2 = ItemModel:get_item_name_with_color( output_id2 )
        local item_name3 = ItemModel:get_item_name_with_color( output_id3 )
        local item_name4 = ItemModel:get_item_name_with_color( output_id4 )
        cost = cost1 + cost2 + cost3 + cost4
        if cost > player_data.bindYinliang then
            str = str_cfg4
        elseif output_count1<=0 and output_count2<=0 and output_count3<=0 and output_count4<=0 then
            str = str_cfg3
        else
            str  = string.format(str_cfg2,item_name1,output_count1,item_name2,output_count2,item_name3,output_count3,item_name4,output_count4,cost)
            enter_fun = fun1
        end
    else
        --   目标产出道具  产出量   手续费
        local output_id,output_count,cost = ForgeModel:get_easy_synth_result_by_type(lv,type)
        local item_name = ItemModel:get_item_name_with_color( output_id )
        if cost > player_data.bindYinliang then
            str = str_cfg4
        elseif output_count<=0 then
            str = str_cfg3
        else
            str = string.format(str_cfg1,item_name,output_count,cost)
            enter_fun = fun1
        end
    end
    NormalDialog:show(str,enter_fun)
end

-- after tjxs
--装备增强系统配置
-- OneKeyMixConf = 
-- {
--     {
--         type = 1,   --一键合成攻击宝石
--         moneyType = 0,
--         before = {18623,18510,18511,18512,18513,18514,18515,18516,18517,18518,},    --合成前的宝石Id，每列对应
--         after = {18510,18511,18512,18513,18514,18515,18516,18517,18518,18519,},     --合成后的宝石Id，每列对应
--         money = {500,511,512,513,514,515,516,517,518,519,},
--         count = {6,4,4,4,4,4,4,4,4,4,},
--     },
--     {
--         type = 2,   --一键合成物防宝石
--         moneyType = 0,
--         before = {18624,18520,18521,18522,18523,18524,18525,18526,18527,18528,},        --合成前的宝石Id，每列对应
--         after = {18520,18521,18522,18523,18524,18525,18526,18527,18528,18529,},     --合成后的宝石Id，每列对应
--         money = {500,521,522,523,524,525,526,527,528,529,},
--         count = {6,4,4,4,4,4,4,4,4,4,},
--     },
--     {
--         type = 3,   --一键合成法防宝石
--         moneyType = 0,
--         before = {18625,18530,18531,18532,18533,18534,18535,18536,18537,18538,},    --合成前的宝石Id，每列对应
--         after = {18530,18531,18532,18533,18534,18535,18536,18537,18538,18539,},     --合成后的宝石Id，每列对应
--         money = {500,531,532,533,534,535,536,537,538,539,},
--         count = {6,4,4,4,4,4,4,4,4,4,},
--     },
--     {
--         type = 4,   --一键合成生命宝石
--         moneyType = 0,
--         before = {18626,18540,18541,18542,18543,18544,18545,18546,18547,18548,},    --合成前的宝石Id，每列对应
--         after = {18540,18541,18542,18543,18544,18545,18546,18547,18548,18549,},     --合成后的宝石Id，每列对应
--         money = {500,541,542,543,544,545,546,547,548,549,},
--         count = {6,4,4,4,4,4,4,4,4,4,},
--     },
-- }

function ForgeModel:onekeyMixDetail( type )
    local rt_detail = {}
    require "../data/OneKeyMixConf"
    local okmd_temp = OneKeyMixConf[type]
    local res_num_have = nil        -- 背包里有的材料数量
    local res_num_all = nil          -- 宝石合成的材料数量(包括背包里有的和之前合成的)
    local res_num_need = nil        -- 合成需要是材料数量
    local res_num_can = 0         -- 可以合成的宝石数量
    for i=1, #OneKeyMixConf[1].before do
        res_num_have = ItemModel:get_item_count_by_id( okmd_temp.before[i] ) or 0  -- 背包里现有的合成原料的数量
        res_num_all = res_num_have + res_num_can 

        res_num_need = okmd_temp.count[i]
        res_num_can = math.floor(res_num_all/res_num_need)
        rt_detail[i] = res_num_can
    end
    return rt_detail
end

-- 强制设置保护符使用。天将雄师项目组的保护符是强制使用的，每次强化时调用此函数，让玩家必定使用保护符  add by gzn
function ForgeModel:force_set_strengthen_prot_series()
    if _strengthen_item_series == nil then
        return;
    end
    if _strengthen_prot_series ~= nil then
        return;
    end

    local item_date = ItemModel:get_item_in_bag_or_body( _strengthen_item_series )
    if item_date then
        local prot_item_id_need = EquipEnhanceConfig:get_prot_id_for_forge( item_date.strong )
        local prot_date = ItemModel:get_item_info_by_id( prot_item_id_need )
        if prot_date then
            ForgeModel:set_strengthen_prot_series( prot_date.series )
        end
    end
end