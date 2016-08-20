-- BagModel.lua
-- created by lyl on 2013-4-9
-- 背包系统

BagModel = {}

local _cur_active_window = nil
local _lock_item_dir_flag = false
-------------------------------
---HJH 2013-7-30 用于当前关联背包窗口
function BagModel:set_cur_active_window(win)
    _cur_active_window = win
end

function BagModel:disable_cur_active_window()
    _cur_active_window = nil
end
-- added by aXing on 2013-5-25
function BagModel:fini( ... )
    UIManager:destroy_window( "bag_win" )
end

-- 背包中的道具，双击事件  参数：背包窗口创建的一个 itemslot对象   
-- 如果仓库窗口正在打开，就把物品放到仓库。否则 双击，使用物品
function BagModel:item_double_click( item_obj )
    if item_obj.not_open_word then
        ItemCC:request_expend_bag_cost_list(  )
    end

    local win = UIManager:find_visible_window("cangku_win")--仓库
    local guild_win = UIManager:find_visible_window("guild_cangku_win")--仙踪仓库
    local buniess_win = UIManager:find_visible_window("buniess_win")
    local ji_shou_shang_jia_win = UIManager:find_visible_window("ji_shou_shang_jia_win")
    
    if buniess_win and _cur_active_window == buniess_win then
        if item_obj.item_date and item_obj.item_date.series and item_obj.item_date.flag ~= 1 then
            BuniessModel:auto_add_my_item_info(item_obj.item_date)
        end
    elseif ji_shou_shang_jia_win and _cur_active_window == ji_shou_shang_jia_win then
        if item_obj.item_date and item_obj.item_date.series then
            JiShouShangJiaModel:auto_add_my_item_info(item_obj.item_date)
        end
    elseif win then
        if item_obj.item_date and item_obj.item_date.series then
            if CangKuItemModel:check_bag_if_full() then
                local notice_content = Lang.bagInfo.full -- "仓库已经满了！"
                local confirmWin = ConfirmWin( "notice_confirm", nil, notice_content, nil, nil, 450, nil)
            else
                CangKuCC:req_bag_to_cangku( item_obj.item_date.series, 0 )
            end
        end
    elseif guild_win then --背包双击到仙宗仓库
        if item_obj.item_date and item_obj.item_date.series then
            if GuildCangKuItemModel:check_bag_if_full() then
                local notice_content =  Lang.bagInfo.full -- [13]="仓库已经满了！"
                local confirmWin = ConfirmWin( "notice_confirm", nil, notice_content, nil, nil, 450, nil)
            else
                -- print("item_obj.item_date.quality=",item_obj.item_date.quality)
                GuildModel:req_bag_to_cangku( item_obj.item_date.quality,item_obj.item_date.series, 0 )
            end
        end
    else
        local function swith_but_func( flag )
            _dont_open_gem_dialog = flag
        end
        local function confirm_fun(  )
            -- 如果是宠物粮，要判断宠物是否出战
            if not BagModel:check_can_use_pet_food( item_obj.item_date.item_id ) then 
                return
            end

            -- 批量使用回调函数
            local function batch_use_fun(num)        
                print("批量使用",num,"物品ID",item_obj.item_date.item_id)  
                if item_obj.item_date~=nil then
                    ItemCC:req_batch_use(item_obj.item_date.series, num)
                end
            end 
            --print("物品数量"..item_obj.item_date.count)
            local item_config = ItemConfig:get_item_by_id(item_obj.item_date.item_id);
            -- 批量使用弹出窗口        
            if item_config.flags.batchUse and item_obj.item_date.count > 1 then 
               BuyKeyboardWin:show(item_obj.item_date.item_id, batch_use_fun, 14, item_obj.item_date.count ) 
               return 
            end 

            local use_result, false_type = ItemModel:use_one_item( item_obj.item_date )
            if not use_result then
                ItemModel:show_use_item_result( false_type , "bag_win")
            end
        end
       
        if item_obj and item_obj.item_date and ItemModel:check_if_body_use_item( item_obj.item_date.item_id ) and item_obj.item_date.flag ~= 1 then
             
            local item_config = ItemConfig:get_item_by_id(item_obj.item_date.item_id);
            if item_config.type == ItemConfig.ITEM_TYPE_MARRIAGE_RING then
                -- 如果是婚戒
                MarriageModel:req_swallow_ring( item_obj.item_date );
            else
                local notice_words = Lang.bagInfo.model[1]-- [14]="装备后该物品将与您绑定，确定装备吗？"
                ConfirmWin( "select_confirm", nil, notice_words, confirm_fun, nil, 450, 130)
            end
        elseif item_obj and item_obj.item_date then
            local item_config = ItemConfig:get_item_by_id(item_obj.item_date.item_id);
            if item_config.type == ItemConfig.ITEM_TYPE_MARRIAGE_RING then
                -- 如果是婚戒
                MarriageModel:req_swallow_ring( item_obj.item_date );
            elseif item_config.type == ItemConfig.ITEM_TYPE_GEM and not _dont_open_gem_dialog then
                local notice_words = Lang.bagInfo.model[10]--LangGameString[2448] -- "是否使用精华化作炼器中的附灵材料"
                -- ConfirmWin( "select_confirm", nil, notice_words, confirm_fun, nil, 450, 130)
                ConfirmWin2:show( 5, 0, notice_words,  confirm_fun, swith_but_func, title_type )
            else 
                confirm_fun(  )
            end
        end
    end
end

-- 背包中道具的单击事件，参数：背包窗口创建的一个 itemslot对象   
function BagModel:item_slot_sclick( item_obj )
	-- 如果是 "单击可扩展" 五个字上单击，  弹出扩展提示
        if item_obj.not_open_word then
        ItemCC:request_expend_bag_cost_list(  )
        end

        if item_obj.item_date then
            -- print( "道具item id", item_obj.item_date.item_id );
            ItemModel:show_bag_tips( item_obj.item_date )
        end
end

-- 根据item_id获取基础数据
function BagModel:get_item_base_by_id( item_id )
	local item_base = ItemConfig:get_item_by_id( item_id )
	return item_base
end

-- 判断传入的 item_date 是否与 背包中的对应位置的数据一样
function BagModel:check_item_date_if_same( index, item_date )
	local ret_if_same = true
	local item_bag = ItemModel:get_item_by_position( index )
	-- if item_date and item_bag then
	-- 	print("判断是否一样。。。。。。。。。。。。。。。。。。。")
	-- 	print( item_date.item_id, item_date.strong, item_date.count, item_date.flag,item_date.series )
	-- 	print( item_bag.item_id, item_bag.strong, item_bag.count, item_bag.flag,item_bag.series)
 --    end
 --    print("item_date,item_bag",item_date,item_bag)
	if item_date == nil and item_bag == nil then
        ret_if_same = true
	elseif ( item_date == nil and item_bag ~= nil ) then         
    	ret_if_same = false
    elseif ( item_date ~= nil and item_bag == nil ) then
    	ret_if_same = false
    elseif item_date.item_id ~= item_bag.item_id then          -- 道具id
        ret_if_same = false
    elseif item_date.strong ~= item_bag.strong then            -- 强化等级
    	ret_if_same = false
    elseif item_date.count ~= item_bag.count then              -- 数量
    	ret_if_same = false
    elseif item_date.flag ~= item_bag.flag then                -- 是否绑定
    	ret_if_same = false
	end
    return ret_if_same
end

-- 获取背包最大格子数
function BagModel:get_bag_max_grid_num(  )
	local player = EntityManager:get_player_avatar()
	return player.bagVolumn
end

-- 背包窗口内的拖动处理
function BagModel:do_drag_in_bag_win( slotitem_source, slotitem_target )
	-- 如果是同一类物品（id一样），并且是否锁定也一样，就合并
    if slotitem_target.item_date and slotitem_target.item_date.item_id == slotitem_source.obj_data.item_id and slotitem_target.item_date.flag == slotitem_source.obj_data.flag then
        ItemCC:req_merge_item ( slotitem_target.item_date.series, slotitem_source.obj_data.series  )
    end
    -- slotitem_target.slot_index：本slot的index，  slotitem_source.obj_data： 拖进来的数据， slotitem_source.slot_index：源的index， slotitem_target.obj_data 本slot数据
    ItemModel:change_item_by_index( slotitem_target.index, slotitem_source.obj_data, slotitem_source.index, slotitem_target.item_date )
end

-- 从仓库拖进来的物品处理
function BagModel:do_drag_in_from_cangku( source_item, item_obj )
    if source_item.obj_data then
        local source_series = source_item.obj_data.series  -- 拖拽的源物品的序列号
        if item_obj.item_date then
            CangKuCC:req_cangku_to_bag( source_item.obj_data.series, item_obj.item_date.series )
        else
            if ItemModel:check_bag_if_full() then
                local notice_content = Lang.bagInfo.model[13]--LangModelString[15] -- [15]="背包已经满了！"
                local confirmWin = ConfirmWin( "notice_confirm", nil, notice_content, nil, nil, 450, nil)
            else
                CangKuCC:req_cangku_to_bag( source_item.obj_data.series, 0 )
            end
        end
    end
end

-- 从仙踪仓库拖进来的物品处理
function BagModel:do_drag_in_from_guild_cangku( source_item, item_obj )
    if source_item.obj_data then
        local source_series = source_item.obj_data.series  -- 拖拽的源物品的序列号
        if item_obj.item_date then
            GuildModel:req_cangku_to_bag( source_item.obj_data, source_item.obj_data.series, item_obj.item_date.series )
        else
            if ItemModel:check_bag_if_full() then
                local notice_content = Lang.bagInfo.model[13]--LangModelString[15] -- [15]="背包已经满了！"
                local confirmWin = ConfirmWin( "notice_confirm", nil, notice_content, nil, nil, 450, nil)
            else
                GuildModel:req_cangku_to_bag( source_item.obj_data,source_item.obj_data.series, 0 )
            end
        end
    end
end
-- 从人物信息面板拖进来的物品处理
function BagModel:do_drag_in_from_userinfo( source_item )
    if source_item.obj_data then 
        if ItemModel:check_bag_if_full() then 
            GlobalFunc:create_screen_notic( Lang.bagInfo.model[13], 20, 250, 230 ) -- [15]="背包已经满了！"
        else
            UserInfoModel:request_unequip_by_id( source_item.obj_data.series )
        end
    end
end

-- 物品拖到可以丢弃的地方
function BagModel:drag_to_cast_item( item_obj )
    if item_obj.item_base and item_obj.item_date then
        local function send_delete_item(  )
            ItemCC:request_remove_bag_item( item_obj.item_date.series )
            -- 如果丢弃的物品类型的类型是技能书
            if ( item_obj.item_base.type == 89 ) then
                -- 不管有没有打开都要更新
                local win = UIManager:find_window("pet_win");
                if ( win ) then
                    win:update_pet_skill_book(item_obj.item_date.series);
                end
            end
        end
        local notice_words = Lang.bagInfo.model[14]..item_obj.item_base.name.. Lang.bagInfo.model[15] -- [16]="确定删除物品【" -- [17]="】吗？"
        ConfirmWin( "select_confirm", nil, notice_words, send_delete_item, nil, 450, nil)        
    end
end

-- 显示 扩展背包 提示
function BagModel:show_expand_bag_confirm_win( money_count, grid_count )
	-- 发送扩展格子的请求

	-- 显示扩展背包需要的金钱的提示窗口
	local count = grid_count or 0
	local money = money_count or 0

    local money_type = 3
    local param = {money_type}
    local expand_func = function( param )
        ItemCC:request_expend_bag(param[1])
    end

    local function send_expand_bag(  )
        MallModel:handle_auto_buy( money, expand_func, param )
    end

	local notice_words = Lang.bagInfo.kuozhang1..count..Lang.bagInfo.kuozhang2..money..Lang.bagInfo.kuozhang3 -- [18]="扩展" -- [19]="格背包,需要花费" -- [20]="元宝，是否继续？"
	ConfirmWin( "select_confirm", nil, notice_words, send_expand_bag, nil, 450, nil)
end

-- 打开仓库
function BagModel:open_cangku(  )
    local vip_info = VIPModel:get_vip_info()
    local expe_vip_time = VIPModel:get_expe_vip_time(  )
    if (vip_info and vip_info.level > 0 ) or expe_vip_time > 0 then
        local cangku_win_show = UIManager:find_visible_window( "cangku_win" )
        if cangku_win_show then
            UIManager:hide_window( "cangku_win" )
        else
            UIManager:show_window( "cangku_win" )
        end
    else
        -- local notice_content = "您目前不是VIP玩家"
        -- ConfirmWin( "notice_confirm", nil, notice_content, nil, nil, 450, nil)
        --立即前往
        local function liji_goto_func(  )
            --to do 立即前往
            --ActivityModel:open_vipSys_win(  )
           GlobalFunc:ask_npc_by_scene_name( Lang.bagInfo.model[17], Lang.bagInfo.model[16] )
        end
        --立即传送
        local function liji_transfer_func( )
        --GlobalFunc:teleport( 11,"仓库管理员") 
        GlobalFunc:teleport_by_name(  Lang.bagInfo.model[17], Lang.bagInfo.model[16])
        end
        local confirm_word =Lang.bagInfo.vipcangku   
      --  ConfirmWin2:show( 3, 3, confirm_word, confirm_func )
        ConfirmWin2:show( 6, nil, confirm_word, liji_goto_func )
        ConfirmWin2:set_yes_but_func_2( liji_transfer_func )
        -- local function btn_fun1()
        --     GlobalFunc:ask_npc( 11,Lang.bagInfo.model[11])            
        -- end
        -- local function btn_fun2()
        --     GlobalFunc:teleport( 11,Lang.bagInfo.model[11] )
        -- end
        -- local dialog = ConfirmWin2:show( 6, nil, "找到仓库管理员#r#cfff000VIP玩家可以使用远程仓库功能",  btn_fun1 )
        -- dialog:set_yes_but_func_2( btn_fun2 );

    end
end

-- 整理背包
function BagModel:request_arrange_bag(  )
    ItemCC:req_settle_bag()
end

-- 打开商店
function BagModel:open_shop_win(  )
    local shop_win_show = UIManager:find_visible_window( "shop_win" )
    if shop_win_show then
        -- print("关闭商店", shop_win_show)
        UIManager:hide_window( "shop_win" )
    else
        -- print("打开商店", shop_win_show)
        ShopModel:open_shop_win( "bag" )
        ShopWin:change_page( "drug" )
    end
end

-- 关闭背包窗口
function BagModel:close_bag_win(  )
    UIManager:hide_window("bag_win");
end

-- 所有锁定物品变灰, 并且不可拖拽    
function BagModel:set_lock_item_disable(  )
    local win = UIManager:find_visible_window("bag_win")
    if win == nil then
        return
    end
    win:set_lock_item_die(  )
    win:setZhenLiState(CLICK_STATE_DISABLE)
end

-- 所有锁定物品设置成亮色
function BagModel:set_all_item_enable(  )
    local win = UIManager:find_window("bag_win")
    if win == nil then
        return
    end
    win:set_all_item_light(  )
    win:setZhenLiState(CLICK_STATE_UP)
end

-- 设置背包窗口，指定道具 色板遮挡
function BagModel:set_item_color_cover( item_series )
    local win = UIManager:find_visible_window("bag_win")
    if win == nil then
        return
    end
    win:set_item_color_cover( item_series, 0xff000050 )
end

-- 去掉指定道具 色板遮挡
function BagModel:hide_item_color_cover( item_series )
    local win = UIManager:find_visible_window("bag_win")
    if win == nil then
        return
    end
    win:hide_item_color_cover( item_series )
end

-- 所有道具去掉颜色遮挡
function BagModel:hide_all_item_color_cover(  )
    local win = UIManager:find_window("bag_win")
    if win == nil then
        return
    end
    win:hide_all_color_cover(  )
end

-- 宠物粮使用的时候，判断是否宠物出战，如果未出战，背包是不能使用宠物粮的
function BagModel:check_can_use_pet_food( item_id )
    -- 如果是宠物粮，要判断宠物是否出战
    if item_id == 19000 or item_id == 19001 
        or item_id == 19002 or item_id == 19003 or item_id == 19101 then 
        --print( item_id, "item_id ", PetModel:get_current_pet_is_fight())
        if not PetModel:get_current_pet_is_fight() then
            local show_content = Lang.bagInfo.model[12]--LangModelString[22] -- [22]="没有出战宠物无法使用此物品"
            GlobalFunc:create_screen_notic( show_content, 20, 250, 230 )
            return false
        end
    end
    return true
end

function BagModel:set_item_when_business()
    -- 锁定物品可以移动、整理背包按钮处于不可使用状态
    local win = UIManager:find_visible_window("bag_win")
    if win == nil then
        return
    end
    win:setZhenLiState(CLICK_STATE_DISABLE)
end

-- add after tjxs
function BagModel:set_lock_item_dir_flag( flag )
    _lock_item_dir_flag = flag
end

function BagModel:get_lock_item_dir_flag()
    return _lock_item_dir_flag
end