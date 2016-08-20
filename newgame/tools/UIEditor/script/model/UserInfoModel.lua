-- UserInfoModel.lua
-- created by lyl on 2012-12-5
-- 角色信息管理器
-- 主要处理游戏内角色信息相关的操作，如设置角色信息，获取角色名称等

-- super_class.UserInfoModel()
UserInfoModel = {}

-- 私有变量
local _role_equi_info = {}         --角色已装备的装备信息，有多个装备.每个元素是一个UserItem结构
local result_one_equip ={} --存放经过背包筛选或者历练推荐 得到的道具
local if_come_where = 0 --推荐的道具是背包筛选还是历练推荐，1 为背包，2为后者
local current_select_type = 0 --当前选择部位的item_type值
local _upgrade_equip_info = { } -- 存放当前选择的可升级的道具信息，会有3个元素，分别为：升级后道具，现在道具，消耗材料
local _equip_num_tab = { } --存放道具数量
local _current_select_series = nil -- 升级道具时 存放当前选择的道具

-- 公有方法
-- added by aXing on 2013-5-25
function UserInfoModel:fini( ... )
    _role_equi_info = {}

    result_one_equip ={} --存放经过背包筛选或者历练推荐 得到的道具
    if_come_where = 0 --推荐的道具是背包筛选还是历练推荐，1 为背包，2为后者
    current_select_type = 0 --当前选择部位的item_type值
    _btn_time = 0
    _upgrade_equip_info = { } -- 存放当前选择的可升级的道具信息，会有3个元素，分别为：升级后道具，现在道具，消耗材料
    _equip_num_tab = { } --存放道具数量
    _current_select_series = nil -- 升级道具时 存放当前选择的道具

end


-- 更新角色面板
function UserInfoModel:update_user_attr_win( update_type )
    require "UI/userAttrWin/UserEquipWin"
    UserEquipWin:update_win( update_type )
end

-- 设置角色装备信息
function UserInfoModel:set_equi_info( userItems )
	_role_equi_info = userItems;

    require "UI/forge/ForgeWin"
    ForgeWin:forge_win_update( "equipment" )

    PlayerAvatar:update_zhenlong(  )
end

--获取角色所有装备信息
function UserInfoModel:get_equi_info()
	return _role_equi_info
end

-- 获取角色装备，并且把武器放在前面
function UserInfoModel:get_bag_equip_attack_head(  )
    local item_list = {}

    for i = 1, #_role_equi_info do
        if ItemModel:get_item_type( _role_equi_info[i].item_id ) == 1 and ItemModel:check_if_equip_by_id( _role_equi_info[i].item_id ) then
            table.insert( item_list, 1, _role_equi_info[i] )
        elseif ItemModel:check_if_equip_by_id( _role_equi_info[i].item_id ) then
            table.insert( item_list, _role_equi_info[i] )
        end
    end
    return item_list
end

--根据装备序列号，获取一个装备
function UserInfoModel:get_equi_by_id( equi_series )
	--遍历_role_equi_info，取出id对应的装备
	for i ,equipment in ipairs(_role_equi_info) do
        if equipment.series == equi_series then
            return equipment
        end
	end
	return nil
end
--根据装备道具id，获取一个装备
function UserInfoModel:get_a_equi( equi_id )
    --遍历_role_equi_info，取出id对应的装备
    for i ,equipment in ipairs(_role_equi_info) do
        if equipment.item_id == equi_id then
            return equipment
        end
    end
    return nil
end

--根据装备type类型，获取一个装备
function UserInfoModel:get_equip_by_type( equip_type )
    require "config/ItemConfig"
    for i ,equipment in ipairs(_role_equi_info) do
        local item_config = ItemConfig:get_item_by_id(equipment.item_id);
        if item_config.type == equip_type then
            return equipment;
        end
    end
    return nil;
end

-- 脱下一个装备
function UserInfoModel:get_off_one_equipment( equi_series )

    local item = UserInfoModel:get_equi_by_id( equi_series );
    local item_config = ItemConfig:get_item_by_id( item.item_id )
    if item_config.type == ItemConfig.ITEM_TYPE_WING then
        -- 该装备是翅膀
        WingModel:take_off_wing(); 
    end

    -- 删除model数据
	for i, equipment in ipairs(_role_equi_info) do
        if equipment.series == equi_series then
            _role_equi_info[i] = _role_equi_info[ #_role_equi_info ]
            SoundManager:playUISound('drop_item',false)
            _role_equi_info[ #_role_equi_info ] = nil
        end
	end
	
    -- 更新界面
    local win = UIManager:find_visible_window( "user_attr_win" )
    if win ~= nil then
        win:update()
    end
    win = UIManager:find_visible_window( "user_equip_win" )
    if win ~= nil then
        win:update()
    end
    PlayerAvatar:update_zhenlong(  )
    -- 更新品阶特效
    UserEquipWin:update_win( "remove_pj_effect" )
end

-- 穿上一件装备
function UserInfoModel:get_on_one_equipment( equi_series )
    require "model/ItemModel"
    local equipment =  ItemModel:get_item_by_series( equi_series )
    if equipment then
        _role_equi_info[ #_role_equi_info + 1 ]  = equipment
        SoundManager:playUISound( 'wear_item' , false )
    end

-- 判断穿上的是否是翅膀，是->刷新主界面面板
    local item = UserInfoModel:get_equi_by_id( equi_series );
    local item_config = ItemConfig:get_item_by_id( item.item_id )

    if item_config.type == ItemConfig.ITEM_TYPE_WING then
        -- 该装备是翅膀
        local win = UIManager:find_visible_window("menus_panel");
        if ( win ) then
            win:insert_btn(MenusPanel.MENU_WING);
            -- win:sort_btns()
        end
    end

    require "UI/UIManager"
    local win = UIManager:find_visible_window( "user_attr_win" )
    if win ~= nil then
        win:update()
    end
    win = UIManager:find_visible_window( "user_equip_win" )
    if win ~= nil then
        win:update()
        -- 更新品阶特效
        UserEquipWin:update_win( "update_pj_effect" )
    end
    PlayerAvatar:update_zhenlong(  )

    local equip_win = UIManager:find_visible_window("user_equip_prompt_win")
    if equip_win then 
        UIManager:destroy_window("user_equip_prompt_win")
    end 
end

--根据装备id，改变装备的一个属性
function UserInfoModel:change_a_equi_attr( equi_series, attr_name, value )
	local a_equipment = self:get_equi_by_id( equi_series )
    local old_value = nil
	if a_equipment and (#a_equipment ~= 0) then
        old_value = a_equipment[attr_name]
        a_equipment[attr_name] = value
	end
    --TODO

end

-- 删除一件装备
function UserInfoModel:remove_a_equipment( equi_series )
    for i, equipment in ipairs( _role_equi_info ) do
        if equipment.series == equi_series then
            -- 判断位置是不是在最后一个，如果不是，就把最后一个移过来（防止有的地方用ipairs遍历，遇到nil会停止遍历）
            if i ~= #_role_equi_info then
                _role_equi_info[i] = _role_equi_info[#_role_equi_info]
            end
            _role_equi_info[#_role_equi_info] = nil
        end
    end
end

-- 计算人物身上所有装备战斗力
function UserInfoModel:calculate_all_equip_attack()
    local ret_all_equi_attr = 0
    for i = 1, #_role_equi_info do
        ret_all_equi_attr = ret_all_equi_attr + UserInfoModel:calculate_equip_attack_value( _role_equi_info[i].series )
    end
    return ret_all_equi_attr
end

-- 计算一件装备的战斗力, 参数：序列号，
function UserInfoModel:calculate_equip_attack_value( item_series)
    local ret_atta_value = 0
    local item_player = UserInfoModel:get_equi_by_id( item_series )
    if item_player == nil then
        return 0
    end

    require "config/ItemConfig"
    local item_base = ItemConfig:get_item_by_id( item_player.item_id )
    if item_base == nil then
        return 0
    end

    local strong_level  = item_player.strong      -- 强化等级
    local quality_level = item_player.quality     -- 品质等级   

    -- 装备的基础战斗力
    require "config/EquipValueConfig"
    local attr_t = ItemConfig:get_staitc_attrs_by_id( item_player.item_id )  -- 装备的基础属性值 表
    for i = 1, #attr_t do
        if attr_t[i] and attr_t[i]["value"] and attr_t[i]["type"] then
            ret_atta_value = ret_atta_value + attr_t[i]["value"] * EquipValueConfig:get_calculate_factor( attr_t[i]["type"] )  
        end
    end

    -- 强化等级. 增加的战斗力 strongAttrs[strong_level + 1]
    local strong_type = 0
    local strong_value = 0 
    local attr_t = item_base.strongAttrs[strong_level] or {}             -- 强化属性表
    local attr_t_len = attr_t and #attr_t or 0
    for i = 1, attr_t_len do
        strong_value = attr_t[i]["value"] or 0
        strong_type  = attr_t[i]["type"] or 0
        ret_atta_value = ret_atta_value + strong_value * EquipValueConfig:get_calculate_factor( strong_type )
    end

    -- 宝石增加的战斗力   (必须是装备才加)
    require "config/ComAttribute"
    local attr_t = nil
    local equip_rate = 1                 -- 增加属性的计算系数
    for i = 1, #item_player.holes do
        if item_player.holes[i] and ItemModel:check_if_equip_by_id( item_base.id ) and item_player.holes[i] ~= 0 then
            attr_t = ItemConfig:get_staitc_attrs_by_id( item_player.holes[i] )
            if attr_t and attr_t[1] and attr_t[1]["value"] and attr_t[1]["type"] then
                strong_value = attr_t[1]["value"] or 0
                strong_type  = attr_t[1]["type"] or 0
                equip_rate = EquipValueConfig:get_calculate_factor( strong_type ) or 1
                ret_atta_value = ret_atta_value + attr_t[1]["value"]  * equip_rate
            end
        end
    end

    return ret_atta_value - ret_atta_value % 1
end

-- 使用一个物品的动态属性，来结算一个 item_id （静态数据），加上这些动态属性后的战斗力(炼器中，升级计算升级后战斗力用)
function UserInfoModel:calculate_equip_attack_by_item_id( item_series, item_id_ex)
    local ret_atta_value = 0
    local item_player = UserInfoModel:get_equi_by_id( item_series )
    if item_player == nil then
        return 0
    end
    
    require "config/ItemConfig"
    local item_base = ItemConfig:get_item_by_id( item_id_ex )
    if item_base == nil then
        return 0
    end

    local strong_level  = item_player.strong      -- 强化等级
    local quality_level = item_player.quality     -- 品质等级   

    -- 装备的基础战斗力
    require "config/EquipValueConfig"
    local attr_t = ItemConfig:get_staitc_attrs_by_id( item_id_ex )  -- 装备的基础属性值 表
    for i = 1, #attr_t do
        if attr_t[i] and attr_t[i]["value"] and attr_t[i]["type"] then
            ret_atta_value = ret_atta_value + attr_t[i]["value"] * EquipValueConfig:get_calculate_factor( attr_t[i]["type"] )  
        end
    end

    -- 强化等级. 增加的战斗力 strongAttrs[strong_level + 1]
    local strong_type = 0
    local strong_value = 0 
    local attr_t = item_base.strongAttrs[strong_level + 1]             -- 强化属性表
    -- print(item_base.name, " !!!! ", strong_level + 1)
    local attr_t_len = attr_t and #attr_t or 0
    for i = 1, attr_t_len do
        strong_value = attr_t[i]["value"] or 0
        strong_type  = attr_t[i]["type"] or 0
        -- print( "强化等级和类型", item_base.name, item_base.strongAttrs[strong_level + 1].type, strong_level )
        ret_atta_value = ret_atta_value + strong_value * EquipValueConfig:get_calculate_factor( strong_type )
    end

    -- 宝石增加的战斗力
    require "config/ComAttribute"
    local attr_t = nil
    for i = 1, #item_player.holes do
        if item_player.holes[i] and item_player.holes[i] ~= 0 then
            attr_t = ItemConfig:get_staitc_attrs_by_id( item_player.holes[i] )
            if attr_t and attr_t[1] and attr_t[1]["value"] then
                ret_atta_value = ret_atta_value + attr_t[1]["value"]  
            end
        end
    end

    return ret_atta_value - ret_atta_value % 1
end

-- 使用一个结构来更新装备
function UserInfoModel:change_equip_by_struct( item_struct )
    if item_struct and item_struct.series then
        for key, equipment in pairs( _role_equi_info )  do
            if equipment.series == item_struct.series then
                _role_equi_info[ key ] = item_struct
                require "UI/forge/ForgeWin"
                ForgeWin:forge_win_update( "equipment" )
                return true
            end
        end
    end
    return false
end

-- 计算会心数值  Math.round((value / 1.5 - 1) * 100)
function UserInfoModel:calculate_( num )
    require "utils/Utils"
    return Utils:math_round( (num / 1.5 - 1) * 100 )
end

-- 对大数进行单位显示 math.ceil(num)
function UserInfoModel:big_num_show( num )
    if num >= 10^8 and num < 10^12 then
        return math.ceil(num / ( 10 ^ 4) ) .. LangModelString[474] -- [474]="万"
    elseif num >= 10^12 and num < 10^16 then
        return math.ceil(num / ( 10 ^ 8) ) .. LangModelString[475] -- [475]="亿"
    elseif num >= 10^16 and num < 10^20 then
        return math.ceil(num / ( 10 ^ 12) ) .. LangModelString[476] -- [476]="兆"
    elseif num >= 10^20 then
        return math.ceil(num / ( 10 ^ 16) ) .. LangModelString[477] -- [477]="京"
    else
        return num
    end
end

-- 判断是否装备了某id的装备
function UserInfoModel:check_if_equip_by_id( item_id )
    for key, item in pairs(_role_equi_info) do
        if item.item_id == item_id then
            return true
        end
    end
    return false
end

-- 判断是否是装别，不包括翅膀、时装
function UserInfoModel:check_item_if_be_equipment( item_id )
    require "config/ItemConfig"
    local item_base = ItemConfig:get_item_by_id( item_id )
    if item_base == nil then
        return false
    end
    return ItemModel:check_item_if_be_equipment( item_base.type )
end

-- 显示tips
function UserInfoModel:show_equip_tips( equi_series ,item_type)
    local item_player = UserInfoModel:get_equi_by_id( equi_series )

    if item_player then
        -- 卸下回调函数
        local function unequip_callback_func(  )
            if ItemModel:check_bag_if_full() then 
                local notice_content = LangModelString[15] -- [15]="背包已经满了！"
                local confirmWin = ConfirmWin( "notice_confirm", nil, notice_content, nil, nil, 450, nil)
            end
            UserInfoModel:request_unequip_by_id( equi_series )
            if item_type ~= nil then 
                -- 停止可能存在的向上箭头特效，并显示“+”图标
                local win = UIManager:find_visible_window( "user_equip_win" )
                if win ~= nil then
                    win:update_equip_panel_effect_and_btn(item_type)
                end
            end 
        end
        --升级回调
        local function upgrade_equip(  )
            UserInfoModel:upgrade_a_equip( item_player )
        end
        --判定当前选择的道具是否可以升级，如可以则点出的tips有升级装备按钮
        local if_can_upgrade = UserInfoModel:if_can_upgrade(item_player.item_id)
        local  upgrade_fun = nil 
        local  upgrade_text = nil 
        if if_can_upgrade == true then
            upgrade_fun = upgrade_equip
            upgrade_text = "升级装备"
        end  
        TipsModel:show_tip( 260, 380, item_player, unequip_callback_func, upgrade_fun, true, LangModelString[478], upgrade_text, TipsModel.LAYOUT_RIGHT ) -- [478]="卸下"
    end
end

-- 卸下装备
function UserInfoModel:request_unequip_by_id( equi_series )
    -- require "control/UserEquipCC"
    local equip = UserInfoModel:get_equi_by_id(equi_series);
    local equip_model = ItemConfig:get_item_by_id( equip.item_id );
    if equip_model.type ~= ItemConfig.ITEM_TYPE_MARRIAGE_RING then
        UserEquipCC:request_unequip_by_id( equi_series )
    end
end


-- 获取宝石的等级
function UserInfoModel:get_one_gem_level( gem_id )
    if gem_id == nil then
        return 0
    end
    require "config/ItemConfig"
    local item_base = ItemConfig:get_item_by_id( gem_id )
    if item_base then
        return item_base.suitId
    end
    return 0
end
-- 获取一个装备，总的宝石等级
function UserInfoModel:get_equi_gem_level( equipment )
    local equi_gem_level_count = 0
    if equipment == nil then
        return equi_gem_level_count
    end
    if equipment.holes[1] ~= 0 then
        equi_gem_level_count = equi_gem_level_count + UserInfoModel:get_one_gem_level( equipment.holes[1] )
    end
    if equipment.holes[2] ~= 0 then
        equi_gem_level_count = equi_gem_level_count + UserInfoModel:get_one_gem_level( equipment.holes[2] )
    end
    if equipment.holes[3] ~= 0 then
        equi_gem_level_count = equi_gem_level_count + UserInfoModel:get_one_gem_level( equipment.holes[3] )
    end
    return equi_gem_level_count
end
-- 算出人物身上装备的宝石等级总和
function UserInfoModel:check_body_gem_all_level(  )
    
    local user_equi_date = UserInfoModel:get_equi_info()
    local gem_level_total = 0
    -- 统计所有宝石的等级
    for i, equipment in pairs(user_equi_date) do
        if UserInfoModel:check_item_if_be_equipment( equipment.item_id )  then
            gem_level_total = gem_level_total + UserInfoModel:get_equi_gem_level(equipment)
        end
    end

    return gem_level_total;
end

-- 算出人物身上装备的强化等级
function UserInfoModel:check_body_strong_all_level(  )
    
    -- 检查所有装备的强化等级是否大于这个level
    local function check_level( level )
        if #_role_equi_info ~= 0  then
            local _temp_equip_list = {};
            -- 将所有非装备的物品排除，如翅膀和时装
            for i,v in ipairs(_role_equi_info) do
                if UserInfoModel:check_item_if_be_equipment( v.item_id ) then
                    _temp_equip_list[#_temp_equip_list+1] = v;
                end
            end

            for i,equipment in ipairs(_temp_equip_list) do
                if equipment.strong < level then 
                    -- 小于给定的强化等级 以及这个装备是翅膀时返回false
                    print("有装备强化等级",equipment.strong,"小于",level,"   id",equipment.item_id,
                        ItemConfig:get_item_name_by_item_id(equipment.item_id));

                    return false;
                end
            end

            return true;
        end    
    end

    local level = 0;
    for i = 4, 15 do 
        if check_level(i) and #_role_equi_info >= 10 then

            level=i;
            print("强化",level);
        else
            break;
        end
    end
    
    return level;
end

-- 检查人物身上有多少装备达到了对应的强化等级
function UserInfoModel:get_equipment_count( strong_lv )
    
    if strong_lv == 0 then
        strong_lv = 4;
    end

    local count = 0;
    -- 将所有非装备的物品排除，如翅膀和时装
    -- local _temp_equip_list = {};
    for i,v in ipairs(_role_equi_info) do
        if UserInfoModel:check_item_if_be_equipment( v.item_id ) then
            -- _temp_equip_list[#_temp_equip_list+1] = v;
            if v.strong >= strong_lv then 
                count = count + 1
            end
        end
    end

    print("有多少装备达到了对应的强化等级:",count,strong_lv);
    return count;
end

-- 判断是否装备真龙之魂
function UserInfoModel:check_if_equip_zhenlong(  )
    local ret = false
    local equip_zhenlong = UserInfoModel:check_if_equip_by_id( 11500 )
    if equip_zhenlong then
        ret = true
    end
    return ret
end

-- 背包拖入物品
function UserInfoModel:drag_in_from_bag( source_item )
    if source_item.obj_data then
        if ItemModel:check_if_body_use_item( source_item.obj_data.item_id ) then 
            ItemModel:use_one_item( source_item.obj_data )
        end
    end
end
 --从背包中获取主角某个部位的穿戴道具
--若背包中没有找到适合的道具，给出推荐
function UserInfoModel:get_a_equip_with_player( item_type )
    current_select_type = item_type
    --查找已穿戴的道具列表 若有则返回
    local  equip_tab = UserInfoModel:get_equip_by_type( item_type )
    if equip_tab ~= nil then
        return 
    end 
    local bag_data,bag_data_num = ItemModel:get_bag_data()

    local appropriate_equip = { } --背包中筛选出来的道具列表
    if_come_where = 0
    if result_one_equip ~= nil then 
        result_one_equip = nil 
    end 
    local index = 1
    for i,v in pairs(bag_data) do
        local one_equip = v
        local item_base = ItemConfig:get_item_by_id( one_equip.item_id )
        if item_base.type == item_type then
            appropriate_equip[index] = one_equip
            index = index+1
        end  
    end

    if appropriate_equip[1] ~= nil then 
        --在找到的道具列表中找到一个最适合的道具推荐
        if index-1 == 1 then
            result_one_equip = appropriate_equip[1]
            if_come_where = 1
        else
            --多个道具符合推荐时 找一个最好的
            local player = EntityManager:get_player_avatar()
            local player_level = player.level
            local function sort_fun( tab1,tab2 )
                if tab1.quality>tab2.quality then 
                    return true
                elseif tab1.quality == tab2.quality then
                    --获取穿戴需要的最低等级 
                    local item_base1 = ItemConfig:get_item_by_id( tab1.item_id )
                    local item_base2 = ItemConfig:get_item_by_id( tab2.item_id )
                    local cond1 = (item_base1.conds)[1];
                    local cond2 = (item_base2.conds)[1];
                    if cond1 ~= nil and cond2 ~= nil  then
                        local level1 = cond1.value
                        local level2 = cond2.value
                        if player_level>=level1 and player_level>=level2 and level1>level2 then 
                            return true
                        else 
                            return false  
                        end 
                    else 
                        return false 
                    end 
                else 
                    return false 
                end 
            end
            table.sort( appropriate_equip, sort_fun )  
            result_one_equip = appropriate_equip[1]
            if_come_where = 1
        end 
    else
        --背包中没有可以装备的道具，推荐一个用历练值兑换
        local  exchange_equip_list = ExchangeModel:get_category_items( "equipment" )
        if exchange_equip_list ~= nil then 
            for i,equip_id in pairs(exchange_equip_list) do
                local item_base = ItemConfig:get_item_by_id( equip_id )
                if item_base.type == item_type then
                    result_one_equip = equip_id
                    if_come_where = 2
                    break
                end 
            end
        end 
    end 
    local win = UIManager:show_window("user_equip_prompt_win")
    if win then
        win:update("not_have_equip")
    end 
end
function UserInfoModel:get_recomme_equip(  )
    return result_one_equip
end
function UserInfoModel:get_equip_come_where(  )
    return if_come_where
end
function UserInfoModel:show_tips( x, y, item_id )
     TipsModel:show_shop_tip( x, y, item_id )
end
function UserInfoModel:get_current_select(  )
    return current_select_type
end
--传入道具id 判定是否可升级
function UserInfoModel:if_can_upgrade( item_id  )
    require "config/EquipEnhanceConfig"
    local upgrade_t = EquipEnhanceConfig:get_upgrade_table( )
    local player = EntityManager:get_player_avatar()
    local player_level = player.level
    for i, v in ipairs(upgrade_t) do                    -- 遍历升级信息表，查询每个等级的itemid集合
        if player_level >= v.checkLevel then                       -- 套装对人物有级数要求
            for j,k in ipairs(v.items) do               -- 查询item_id集合，判断传入的id是否可以升级
                if k == item_id then
                    --ZXLog("该道具可以升级")                    -- 
                   return true 
                end
            end
        end
    end
    return false  
end
--升级道具
function UserInfoModel:upgrade_a_equip( item_player )
     local target_item_id, meta_item_id, mete_need_num 
                        = UserInfoModel:get_up_info_by_id( item_player.item_id )
    if target_item_id ~= nil and meta_item_id ~=nil then 
        _upgrade_equip_info[1] =  target_item_id
        _upgrade_equip_info[2] =  item_player.item_id
        _upgrade_equip_info[3] =  meta_item_id
    end
    --获取 现有数量
    local item_player_num = ItemModel:get_item_count_by_id( item_player.item_id )
    local have_num = ItemModel:get_item_count_by_id( meta_item_id )

    _equip_num_tab = {{item_player.item_id,item_player_num},{meta_item_id,have_num,mete_need_num}}
    local win = UIManager:show_window("user_equip_prompt_win")
    if win then
        win:update("have_equip")
    end 
end
function UserInfoModel:get_upgrade_equip_info(  )
    return _upgrade_equip_info
end
function UserInfoModel:get_equip_num(  )
    return _equip_num_tab
end
-- 根据道具id，获取升级信息。 返回三个值：该id升级后的物品id， 需要的材料id， 需要的数量
function UserInfoModel:get_up_info_by_id( item_id )
    local ret_new_id = 0                               -- 生成后的物品id
    local ret_user_id = 0                              -- 使用材料的id
    local ret_use_count = 0                            -- 使用的数量
    local ret_use_money = 0;
     -- 获取人物信息(等级)
    local player = EntityManager:get_player_avatar()

    require "config/EquipEnhanceConfig"
    local upgrade_t = EquipEnhanceConfig:get_upgrade_table( )
    
    for i, v in ipairs(upgrade_t) do                    -- 遍历升级信息表，查询每个等级的itemid集合
        if player.level >= v.checkLevel then                       -- 套装对人物有级数要求
            for j,k in ipairs(v.items) do               -- 查询item_id集合，判断传入的id是否可以升级
                if k == item_id then                    -- 
                    ret_new_id = v.newItems[j]
                    ret_user_id = v.useItems[j]
                    ret_use_count = v.useCount[j]
                    break;
                end
            end
        end
    end
    return ret_new_id, ret_user_id, ret_use_count    
end
--如果是道具可是升级就 保留当前选择的道具 在升级道具界面使用
function UserInfoModel:set_now_upgrade_select_equip( select_series )
    _current_select_series = select_series
end
function UserInfoModel:get_select_equip(  )
     return _current_select_series
end