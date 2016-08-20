-- filename: GuildCangKuItemModel.lua
-- author: created by liuguowang on 2014-3-25.
-- function: 仓库的数据，窗口控制类

GuildCangKuItemModel = {}

local _guildcangku_items 		= {}				-- 仓库的道具
local _guildcangku_items_count 	= 0					-- 仓库目前拥有道具的数量

-- added by aXing on 2013-5-25
function GuildCangKuItemModel:fini( ... )
    _guildcangku_items           = {}
    _guildcangku_items_count     = 0

    UIManager:destroy_window( "guild_cangku_win" )
end

--  设置仓库所有item数据
function GuildCangKuItemModel:set_items_date( items, count )
	if #items > 0 then
	    _guildcangku_items = items
	    _guildcangku_items_count = count
	end

    -- print("设置仓库所有item数据 ~~~~~~~~~~~~~~~ ", #items)
    -- require "utils/Utils"
    -- Utils:print_table_key_value( _guildcangku_items, nil )

    -- 排序
    GuildCangKuItemModel:item_arrange()

    GuildCangKuWin:update_cangku_win( "cangku" )
end

-- 获取所有仓库的item数据
function GuildCangKuItemModel:get_items_date(  )
	return _guildcangku_items, _guildcangku_items_count
end

-- 获取仓库中物品实际数量(不包括空的格子)
function GuildCangKuItemModel:get_item_count_without_null(  )
    local count = 0
    for i = 1, table.maxn( _guildcangku_items ) do
        if _guildcangku_items[i] ~= nil then
            count = count + 1
        end
    end
    return count
end

-- 增加道具
function GuildCangKuItemModel:add_item(item)
    -- print("仓库。。。。增加道具  ", item)
	if (item ~= nil) then
		-- 查看数组中的空的元素，就放进去。 如果都满了，放在后面一个（for 中的+1）
		for i=1, #_guildcangku_items + 1 do
			if (_guildcangku_items[i] == nil) then
				_guildcangku_items[i] = item;
				if (i > _guildcangku_items_count) then
					_guildcangku_items_count = _guildcangku_items_count + 1;
				end
				break;
			end
		end
        GuildCangKuWin:update_cangku_win( "cangku" )
	end
end

-- 获取仓库中一个道具
function GuildCangKuItemModel:get_item_by_series( series )
	for i = 0, #_guildcangku_items do
        if _guildcangku_items[i].series == item_series then
            return _guildcangku_items[i]
        end
	end
end

-- 根据位置获取仓库中一个道具
function GuildCangKuItemModel:get_item_by_position( position )
    return _guildcangku_items[position]
end

-- 根据item_id获取基础数据
function GuildCangKuItemModel:get_item_base_by_id( item_id )
    local item_base = ItemConfig:get_item_by_id( item_id )
    return item_base
end

-- 道具从仓库中删除
function GuildCangKuItemModel:remove_item_from_cangku( item_series )
    for key, item in pairs( _guildcangku_items ) do
        if item.series == item_series then
            _guildcangku_items[ key ] = nil
        end
    end

    GuildCangKuWin:update_cangku_win( "cangku" )
end

-- 改变仓库中一个物品的属性
function GuildCangKuItemModel:change_item_attr( item_series, attr_name, value )
	for i = 0, #_guildcangku_items do
        if _guildcangku_items[i] and _guildcangku_items[i].series == item_series then
            _guildcangku_items[i][attr_name] = value
        end
	end
    GuildCangKuWin:update_cangku_win( "cangku" )
end

-- 根据序列号来改变数据
function GuildCangKuItemModel:change_item_by_index( index_1, item_1, index_2, item_2 )
	if index_1 then
	    _guildcangku_items[ index_1 ] = item_1
	end
	if index_2 then
	    _guildcangku_items[ index_2 ] = item_2
	end

    GuildCangKuWin:update_cangku_win( "cangku" )
end

-- 背包排序
function GuildCangKuItemModel:item_arrange(  )
    -- 按照 item_id 来排序
    for i = 1, table.maxn( _guildcangku_items ) do
        for j = i, table.maxn( _guildcangku_items ) do
            -- 和当前循环的第一个比较，把大的挪到当前第一位
            if not GuildCangKuItemModel:compare_item_id( _guildcangku_items[i], _guildcangku_items[j] ) then
                local item_temp = _guildcangku_items[i]
                _guildcangku_items[i] = _guildcangku_items[j]
                _guildcangku_items[j] = item_temp
            end
        end
    end
    GuildCangKuWin:update_cangku_win( "cangku" )
end

-- 比较两个 item的 id， nil算小，  如果前面的大于等于后面的，返回true
function GuildCangKuItemModel:compare_item_id( item_1, item_2 )
    if item_1 and ( not item_2 ) then
        return true
    end
    if ( not item_1 ) and item_2 then
        return false
    end
    if item_1 and item_2 then
        if tonumber(item_1.item_id) >= tonumber( item_2.item_id ) then
            return true
        else
            return false
        end
    end
    return false
end

-- 检查背包是否已经满了
function GuildCangKuItemModel:check_bag_if_full()
    local max = GuildCangKuItemModel:get_cangku_max_grid_num()--最大容纳数量
    local item_count = GuildCangKuItemModel:get_item_count_without_null(  )--仓库目前物品数量
    -- print("max=",max)
    -- print("item_count=",item_count)
    if max <= item_count then
        return true
    else
        return false
    end
end


-- 获取仓库最大格子数
function GuildCangKuItemModel:get_cangku_max_grid_num(  )
    local guild_level = GuildModel:get_guild_building_level( "biMain" )
    -- print("guild_level=",guild_level)
    local max = 20 + guild_level * 10  --服务端  客户端 都控制下
    if max > 120 then
        max = 120
    end
    -- print("~~~~~~~~~~max=",max)
    return max 
end

-- 显示tips窗口
function GuildCangKuItemModel:show_cangku_tips( item_date )
    if item_date == nil then
        return 
    end

    local function get_out_callback()
        GuildCangKuItemModel:put_one_item_to_bag( item_date )
    end
    local function split_callback(  )
        -- GuildCangKuItemModel:split_depot_item( item_date )
    end
    -- 拆分判断  数量小于2的物品，不可以拆分  不显示拆分按钮
    local split_callback_temp = split_callback
    local split_but_name = LangModelString[25] -- [25]="拆分"
    -- if item_date.count < 2  then  --仙宗仓库是没有拆分的
        split_callback_temp = nil
        split_but_name = ""
    -- end
    TipsModel:show_tip( 200, 255, item_date, get_out_callback, split_callback_temp, false, LangModelString[26], split_but_name ) -- [26]="取出"
end

-- 取出到背包
function GuildCangKuItemModel:put_one_item_to_bag( item_date )
    if item_date then 
        if ItemModel:check_bag_if_full() then
            local notice_content = LangModelString[15] -- [15]="背包已经满了！"
            local confirmWin = ConfirmWin( "notice_confirm", nil, notice_content, nil, nil, 50, nil)
        else
            GuildModel:req_cangku_to_bag(item_date,item_date.series, 0 )
        end
    end
end

-- 仓库拆分  --仙踪仓库没有拆分
-- function GuildCangKuItemModel:split_depot_item( item_date )
--     if (not item_date) or (not item_date.series) then
--         print("date为空！！！")
--         return 
--     end

--     -- 先判断背包是否已经满了，如果已经满了就要提示
--     local player = EntityManager:get_player_avatar()
--     local item_count = GuildCangKuItemModel:get_item_count_without_null(  )
    
--     if player.storeVolumn <= item_count then
--         local notice_words = LangModelString[27] -- [27]="仓库已经满了，不能拆分！"
--         ConfirmWin( "notice_confirm", nil, notice_words, nil, nil, 50, nil)
--     else
--         print("拆分   ", item_date.count)
--         local function split_item_fun( num )
--             print("拆分  ~~~   ", item_date.series, num )
--             GuildCC:req_seperate_cangku_item( item_date.series, num )
--         end
--         if item_date.count > 1 and GuildModel:is_zongzhu() == true then
--             BuyKeyboardWin:show(item_date.item_id, split_item_fun, 13, item_date.count - 1 )
--         else
--             local notice_words = LangModelString[28] -- [28]="不能拆分！"
--             ConfirmWin( "notice_confirm", nil, notice_words, nil, nil, 50, nil)
--         end
--         -- require "control/ItemCC"
--         -- ItemCC:request_split_item( item_date.series, 1 )
--     end
-- end



-- 判断传入的 item_date 是否与 仓库中的对应位置的数据一样
function GuildCangKuItemModel:check_item_date_if_same( index, item_date )
    local ret_if_same = true
    local item_cangku = GuildCangKuItemModel:get_item_by_position( index )
    if item_date and item_cangku then
        -- print("判断是否一样。。。。。。。。。。。。。。。。。。。")
        -- print( item_date.item_id, item_date.strong, item_date.count, item_date.flag )
        -- print( item_cangku.item_id, item_cangku.strong, item_cangku.count, item_cangku.flag)
    end
    if item_date == nil and item_cangku == nil then
        ret_if_same = true
    elseif ( item_date == nil and item_cangku ~= nil ) then         
        ret_if_same = false
    elseif ( item_date ~= nil and item_cangku == nil ) then
        ret_if_same = false
    elseif item_date.item_id ~= item_cangku.item_id then          -- 道具id
        ret_if_same = false
    elseif item_date.strong ~= item_cangku.strong then            -- 强化等级
        ret_if_same = false
    elseif item_date.count ~= item_cangku.count then              -- 数量
        ret_if_same = false
    elseif item_date.flag ~= item_cangku.flag then                -- 是否绑定
        ret_if_same = false
    end
    return ret_if_same
end

-- 发送整理仓库的请求
function GuildCangKuItemModel:request_arrange_cangku(  )
    GuildCC:req_trim_cangku()
end

-- 请求仓库数据
function GuildCangKuItemModel:request_cangku_model(  )
    GuildCC:req_cangku_items()
end

-- 道具双击事件
function GuildCangKuItemModel:item_double_click( item_obj )
    local win = UIManager:find_visible_window("bag_win")
    if win then
        if item_obj.item_date and item_obj.item_date.series then
            if ItemModel:check_bag_if_full() then
                local notice_content = LangModelString[15] -- [15]="背包已经满了！"
                local confirmWin = ConfirmWin( "notice_confirm", nil, notice_content, nil, nil, 50, nil)
            else
                GuildModel:req_cangku_to_bag(item_obj.item_date,item_obj.item_date.series, 0 )
                -- function double_click_cangku_fun(select_num)
                --     print("select_num=",select_num)
                --     Guild34CC:req_can34gku_to_bag( item_obj.item_date.series, 0 ,select_num)
                -- end

                -- if item_obj.item_date.count > 1 and GuildModel:is_zongzhu() ==true then
                --     BuyKeyboardWin:show(item_obj.item_date.item_id,double_click_cangku_fun,13,item_obj.item_date.count)
                -- else -- if item_obj.item_date.count == 1 then
                --     double_click_cangku_fun(1)
                -- end

            end
        end
    end
end

-- 道具单机事件
function GuildCangKuItemModel:item_click( item_obj )
    -- 如果是 "单击可扩展" 五个字上单击，  弹出扩展提示
    -- if item_obj.not_open_word then
    --     CangKuCC:req_cost_for_expand_grid ()
    -- end
    if item_obj.item_date then
        GuildCangKuItemModel:show_cangku_tips( item_obj.item_date )
    end
end

-- 背包拖进仓库的处理
function GuildCangKuItemModel:item_drag_in_from_bag( source_item, item_obj )
    if source_item.obj_data then
        local source_series = source_item.obj_data.series  -- 拖拽的源物品的序列号
        if item_obj.item_date then
            GuildModel:req_bag_to_cangku(source_item.obj_data.quality, source_item.obj_data.series, item_obj.item_date.series )
        else
            if GuildCangKuItemModel:check_bag_if_full() then
                local notice_content = LangModelString[13] -- [13]="仓库已经满了！"
                local confirmWin = ConfirmWin( "notice_confirm", nil, notice_content, nil, nil, 450, nil)
            else
                GuildModel:req_bag_to_cangku( source_item.obj_data.quality,source_item.obj_data.series, 0 )
            end
        end
    end
end
