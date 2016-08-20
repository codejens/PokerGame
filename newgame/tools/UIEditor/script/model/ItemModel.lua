-- ItemModel.lua
-- created by aXing on 2012-11-30
-- 道具管理器
-- 主要处理游戏内道具相关的操作，如添加一个道具，删除一个道具，移动一个道具

-- super_class.ItemModel()
ItemModel = {}

local BAG_PAGE_COUNT	= 10 				-- 背包总页数
local BAG_PAGE_SIZE 	= 20				-- 背包每页容量
local BAG_GRID_COLUMN  	= 5					-- 背包网格的列数
local MAX_BAG_VOLUMN	= BAG_PAGE_SIZE * BAG_PAGE_COUNT -- 背包最大容量
local MAX_LOCK_ITEMS	= 4					-- 最大锁定物品数量，为了优化而定义，可以根据需要修改该值
local MAX_BODY_ITEMS 	= 16				-- 身上装备数量，为了优化，定为2的整数幂16，目前最多只有11件
-- local _has_open_count   = 0                -- 已开通的格子数

local _bag_items 		= {}				-- 背包的道具
local _num_bag_items 	= 0					-- !!!!!!!!背包数组的最大index！！！            错误》》》   背包目前拥有道具的数量
-- local _bag_item_count   = 0                 -- 不包括空格的道具数量
local _cool_group_cd    = {}                -- 冷却组，记录冷却组的冷却时间

local temp_item_info_table = {};            --用于保存从服务器取的道具数据;
 
function ItemModel:fini( ... )
    _bag_items = {}
    _num_bag_items  = 0
    _cool_group_cd    = {} 
    temp_item_info_table = {};
end

-- 私有函数
-- 更新背包窗口
local function update_bag_window( )
	-- 取得背包窗口指针
	local win = UIManager:find_visible_window("bag_win")
	
	if win then
		-- 把数据交给背包窗口显示
		win:update("bag");	
	end
end

-- 公有函数
-- 初始化背包数据
function ItemModel:init_bag()
	ItemCC:request_player_bag_items();
end

-- 获取背包中物品实际数量(不包括空的格子)
function ItemModel:get_item_count_without_null(  )
    local count = 0
    for i = 1, table.maxn( _bag_items ) do
        if _bag_items[i] ~= nil then
            count = count + 1
        end
    end
    return count
end


-- 获取背包的空格子数
function ItemModel:get_bag_space_gird_count(  )

    local player = EntityManager:get_player_avatar()
    local count = player.bagVolumn - ItemModel:get_item_count_without_null();
    -- print("计算背包空格子",player.bagVolumn ,ItemModel:get_item_count_without_null(),count);
    return count;
    
end

-- 公有函数
-- 设置背包数据
function ItemModel:set_bag_data( count, new_items )
    ZXLog("设置背包数据!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!", count, #new_items)
	if count == nil or count < 1 then
        --根据玩家背包中的装备数据和已装备的装备数据，判定是否有可穿戴的道具
        -- 天降雄师目前没有未装备时提示装备和已装备时提示升级的功能，所以暂时屏蔽 note by guozhinan
        -- ItemModel:if_have_equip_can_wear()
        return
	end
	_num_bag_items  = count
	_bag_items 		= new_items
	
    -- 排序
    ItemModel:item_arrange()

	update_bag_window()

    ForgeWin:forge_win_update( "bag" )

    SecretaryModel:update_win( "bag" )

    ChatModel:init_bag_info( _bag_items )

    --根据玩家背包中的装备数据和已装备的装备数据，判定是否有可穿戴的道具
    -- 天降雄师目前没有未装备时提示装备和已装备时提示升级的功能，所以暂时屏蔽 note by guozhinan
    -- ItemModel:if_have_equip_can_wear()
end

-- 公有函数
-- 获取背包数据
function ItemModel:get_bag_data()
	return _bag_items, _num_bag_items;
end

-- 根据背包中的位置来获取道具  
function ItemModel:get_item_by_position( position )
    return _bag_items[position]
end

-- 添加一个背包道具
function ItemModel:add_bag_item( new_item )
    -- print("!!!!!!ItemModel:add_bag_item添加一个背包道具!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!", MAX_BAG_VOLUMN, new_item, new_item.item_id)
    local has_open_count = BagModel:get_bag_max_grid_num(  )
    for i=1,MAX_BAG_VOLUMN do
        -- print("遍历，，，，，，，", i, MAX_BAG_VOLUMN, has_open_count, _num_bag_items )
		if _bag_items[i] == nil and i <= has_open_count then
			_bag_items[i] = new_item
            -- print("放入。。。。。。。。。。。。。。", has_open_count, _num_bag_items )
			if (i > _num_bag_items) then
				_num_bag_items = _num_bag_items + 1;
			end
			break;
		end
	end
	ChatModel:data_add_bag_item(new_item)
	update_bag_window()
	
    ForgeWin:forge_win_update( "bag_add" )

    SecretaryModel:update_win( "bag" )

    -- 如果是筋斗云，更新活动窗口
    if new_item.item_id == 18601 then
        ActivityModel:date_change_update("cloud_num")
    end

    local new_item_info = ItemConfig:get_item_by_id( new_item.item_id );
    -- 如果是更好的装备，并且这个装备是我能用的装备，要弹一个提示框 
    if ( ItemModel:check_item_if_be_equipment_with_wind( new_item_info.type ) and ItemModel:use_item_condition( new_item_info , new_item )) then
        local equi_info = UserInfoModel:get_equi_info();
        for i=1,#equi_info do

            local old_item_info = ItemConfig:get_item_by_id( equi_info[i].item_id );
            if ( old_item_info.type == new_item_info.type ) then
                local old_item_fight_value = ItemModel:calculate_equip_base_attack( equi_info[i].item_id );
                local new_item_fight_value = ItemModel:calculate_equip_base_attack( new_item.item_id );
                if ( new_item_fight_value > old_item_fight_value ) then
                    DialogManager:show( new_item , DialogManager.DIALOG_BETTER_ITEM )
                end 
                return;
            end
        end
        DialogManager:show( new_item, DialogManager.DIALOG_BETTER_ITEM );
    end

    -- 如果得到了金元宝
    if ( new_item.item_id >= 18212 and new_item.item_id <= 18218 and ItemModel:use_item_condition( new_item_info , new_item ) ) then
        DialogManager:show( new_item,DialogManager.DIALOG_JIN_YUANBAO );
    end

    ItemModel:pet_update_on_add_bag_item( new_item )

end
-- 当背包增加一个道具时宠物相关界面更新
function ItemModel:pet_update_on_add_bag_item( new_item )
    local item_info = ItemConfig:get_item_by_id( new_item.item_id )
    print("ItemModel:pet_update_on_add_bag_item",item_info.type)
    -- 当添加一个道具时，宠物相关的界面更新代码

    -- 89 代表是技能书
    if ( item_info.type == 89 ) then
        local win = UIManager:find_window("pet_win");
        if ( win ) then
            win:update_pet_skill_book(new_item.series,true);
        end
    -- 82 功能道具
    elseif item_info.type == ItemConfig.ITEM_TYPE_FUNCTION_ITEM then
        -- 更新悟性丹和悟性保护丹的数量
        if item_info.suitId == 6 then
            local win = UIManager:find_window("pet_win")
            if win then 
                win:update(31,{new_item.item_id})
            end
        end
        -- 更新成长丹和成长保护丹的数量
        if item_info.suitId == 7 then
            local win = UIManager:find_window("pet_win")
            if win then 
                win:update(32,{new_item.item_id})
            end     
        end
    else
        -- local win  = UIManager:find_visible_window("user_attr_win")
        -- ZXLog("-------逗比-------------win:",win)
        -- if win then 
        --     local item_type = UserInfoModel:get_current_select(  )
        --     if item_info.type == item_type then 
        --         UserInfoModel:get_a_equip_with_player( item_type )
        --     end 
        -- end 
    end

end

-- -- 请求删除一个背包道具
-- function ItemModel:del_bag_item( item_index )
-- 	ItemCC:request_remove_bag_item(_bag_items[item_index].series);
	
-- end

function ItemModel:do_del_bag_item( series )
    -- 新手指引的判断
    ItemModel:on_xszy( series );

    local item = ItemModel:get_item_by_series( series )
    if item.item_id == 18601 then
        MiniMapModel:update_teleport_btn(  );
    end

    for key, item in pairs( _bag_items ) do
        if item.series == series then
            _bag_items[ key ] = nil
        end
    end
    ChatModel:data_delete_bag_item( series )
	update_bag_window( )
    ForgeWin:forge_win_update( "bag_remove" )
    -- 主界面更新药品
    MenusPanel:on_delete_yp( item.item_id )

    -- -- 唤魂玉判断
    -- if ( item.item_id == PetConfig:get_hhy_item_id() ) then
    --     if ( UIManager:find_visible_window("suxing_win") ) then
    --         UIManager:destroy_window("suxing_win");
    --         UIManager:show_window("pet_win");
    --     end
    -- end
    self:pet_update_on_item_delete( item )

    -- 美人铸卡室
    local lingqi_win = UIManager:find_window("lingqi_win")
    if lingqi_win then
        lingqi_win:update_card_data( 6, "card_num")
    end
end

-- 新手指引的判断
function ItemModel:on_xszy( series )
    -- if ( XSZYManager:get_state() == XSZYConfig.BEI_BAO_ZY ) then
    --     local item_base = ItemModel:get_item_by_series( series );
    --     -- 判断删除的道具是否是10级成长礼包
    --     if ( item_base.item_id == 18203 ) then
    --         local bag_win = UIManager:find_visible_window( "bag_win");
    --         if ( bag_win ) then
    --             -- 删除之前的箭头
    --             XSZYManager:destroy_jt( XSZYConfig.OTHER_SELECT_TAG);
    --             -- 指向关闭按钮
    --             XSZYManager:play_jt_and_kuang_animation_by_id( XSZYConfig.BEI_BAO_ZY,2 ,XSZYConfig.OTHER_SELECT_TAG);
    --         end
    --     end
    -- end
end

function ItemModel:pet_update_on_item_delete( item )
    local item_info = ItemConfig:get_item_by_id( item.item_id )
    -- 82 功能道具
    if item_info.type == ItemConfig.ITEM_TYPE_FUNCTION_ITEM  then
        -- 更新悟性丹和悟性保护丹的数量
        if  item_info.suitId == 6 then
            local win = UIManager:find_window("pet_win")
            if win then 
                win:update(31,{item.item_id})
            end
        end
        -- 更新成长丹和成长保护丹的数量
        if  item_info.suitId == 7 then
            local win = UIManager:find_window("pet_win")
            if win then 
                win:update(32,{item.item_id})
            end     
        end
    end
    -- 唤魂玉判断
    if ( item.item_id == PetConfig:get_hhy_item_id() ) then
        if ( UIManager:find_visible_window("suxing_win") ) then
            UIManager:destroy_window("suxing_win");

            UIManager:show_window("pet_win");
            local win = UIManager:find_visible_window("pet_win")
            if win then
                win:change_pet_index(PetModel:get_cur_pet_index())
                win:goto_page(4)
            end
        end
    end   
end

-- function ItemModel:start_bag_win()
-- 	ItemCC:request_player_bag_items();
-- end

-- 根据 item_series 获取一个道具  by lyl 12.19
function ItemModel:get_item_by_series( series )
	for i, v in pairs(_bag_items) do
        if v.series == series then
            return v
        end
	end
	return nil
end

-- 根据 item_series 获取一个道具是背包里的第几个
function ItemModel:get_item_index_by_series( series )
	
    for i = 1,#_bag_items do
		local struct = _bag_items[i];
		if ( struct) then
			if struct.series == series then
				return i;
            	--return i,_bag_items[i];
       		end
		end
	end

	return nil;
end

-- 根据 item_id 获取一个道具是背包里的第几个
function ItemModel:get_item_index_by_item_id( item_id )
    for i, item in pairs(_bag_items) do
        if ( item) then
            if item.item_id == item_id then
                return i;
                --return i,_bag_items[i];
            end
        end
    end

    return nil;
end

-- 根据item_id 获取道具的数量 by fjh 2012-12-29
function ItemModel:get_item_count_by_id( item_id )
	local count = 0;
	for k,v in pairs(_bag_items) do
		if v.item_id == item_id then
			count = count + v.count;
		end
	end
	return count;
end

-- 根据物品序列号 series 获取道具数量
function ItemModel:get_item_count_by_series( series)
    local count = 0
    for k, v in pairs(_bag_items) do
        if v.series == series then
            count = v.count
        end
    end
    return count
end

-- 根据item_id 获取道具的信息 by hcl 2013-1-4
function ItemModel:get_item_info_by_id( item_id )
	for k,v in pairs(_bag_items) do
		if v.item_id == item_id then
			return v;
		end
	end
	return nil;
end

-- 根据item_id 获取所有唤魂玉的数据
function ItemModel:get_yhs_by_id( item_id )
	local tab = {};

	for k,v in pairs(_bag_items) do
		if v.item_id == item_id then
			local len = #tab;
			tab[len + 1] = v;
		end
	end
	return tab;
end

-- 修改背包中，一个物品的属性值  by lyl 12.19
function ItemModel:change_item_attr( series, attr_name, value )
    -- print("修改背包中，一个物品的属性值   ", series, attr_name, value)
	local item = ItemModel:get_item_by_series( series )
	if item then
        local old_value = item[ attr_name ] 
	    item[ attr_name ] = value
    else
        return 
	end

	update_bag_window()
	
	ForgeWin:forge_win_update( "bag_change" )

    -- 如果是筋斗云，更新活动窗口
    if item.item_id == 18601 then
        ActivityModel:date_change_update("cloud_num")
        MiniMapModel:update_teleport_btn(  );
    end
    self:pet_update_on_item_count_change( item );

    -- 是否是美人铸卡室分页分解item(卡牌道具)
    local lingqi_win = UIManager:find_window("lingqi_win")
    if lingqi_win then
        lingqi_win:update_card_data( 6, "card_num")
    end
end

-- 当物品数量变化时宠物界面的相关更新
function ItemModel:pet_update_on_item_count_change( item )
    print("ItemModel:pet_update_on_item_count_change( item )",item.item_id)
    local item_info = ItemConfig:get_item_by_id( item.item_id )
    -- local win = UIManager:find_visible_window("suxing_win")
    -- print("win",win);
    -- --潜规则 当一本技能书数量发生变化时
    -- if ( win ) then
    --     print("item_info.type",item_info.type);
    --     -- 89 代表是技能书
    --     if ( item_info.type == 89 ) then
    --         UIManager:destroy_window("suxing_win");
    --         PetWin:cb_wake_skill(item,1);
    --         UIManager:show_window("pet_win"); 
    --     end
    -- end    
    -- 82 功能道具
    if item_info.type == ItemConfig.ITEM_TYPE_FUNCTION_ITEM  then
        -- 更新悟性丹和悟性保护丹的数量
        if item_info.suitId == 6 then
            local win = UIManager:find_window("pet_win")
            if win then 
                win:update(31,{item.item_id})
            end
        end
        -- 更新成长丹和成长保护丹的数量
        if item_info.suitId == 7 then
            local win = UIManager:find_window("pet_win")
            if win then 
                win:update(32,{item.item_id})
            end        
        end
    end
end

-- 增加一个物品 by lyl 1.5
-- function ItemModel:add_one_item( item )
-- 	_bag_items[ #_bag_items + 1 ] = item
-- 	_num_bag_items = _num_bag_items + 1
-- end

-- 获取背包剩于空格数
function ItemModel:get_bag_left_grid()
	local player = EntityManager:get_player_avatar();
	return player.bagVolumn - _num_bag_items;
end

-- 使用一个物品
function ItemModel:use_a_item( item_series, ext_param )
	ItemCC:req_use_item (item_series, ext_param)
end

-- 使用一个物品成功
function ItemModel:use_item_success( item_id )

	ItemModel:item_begin_cool( item_id )
    BagWin:update_bag_win( "cd" )

    local win = UIManager:find_visible_window("menus_panel")
    if ( win ) then
        win:update_yp_view( item_id )
    end
    
    local item_data = ItemConfig:get_item_by_id(item_id)
    if ItemConfig.ITEM_TYPE_MEDICAMENTS == item_data.type then
        SoundManager:playUISound('medicine',false)
    end
     
end

-- 根据序列号来改变数据
function ItemModel:change_item_by_index( index_1, item_1, index_2, item_2 )
	if index_1 then
	    _bag_items[ index_1 ] = item_1
	end
	if index_2 then
	    _bag_items[ index_2 ] = item_2
	end

	update_bag_window()
end

-- 判断一件物品是否是装备
function ItemModel:check_item_if_be_equipment( item_type )
    local _equi_num_t = { [1] = true, [2] = true, [3] = true, [4] = true,
                      [5] = true, [6] = true, [7] = true, [8] = true,
                      [9] = true, [10] = true }
    if _equi_num_t[ item_type ] then
        return true
    else
        return false
    end
end

-- 判断一件物品(包括翅膀)是否是装备
function ItemModel:check_item_if_be_equipment_with_wind( item_type )
    local _equi_num_t = { [1] = true, [2] = true, [3] = true, [4] = true,
                      [5] = true, [6] = true, [7] = true, [8] = true,
                      [9] = true, [10] = true,[14] = true }
    if _equi_num_t[ item_type ] then
        return true
    else
        return false
    end
end

local _never_popup_tips = false
-- 使用物品
function ItemModel:use_one_item( item_date )
    if item_date == nil then
        return
    end
    -- 获取道具的基本数据
    require "config/ItemConfig"
    local item_base = ItemConfig:get_item_by_id( item_date.item_id )
    if item_base == nil then
        return false
    end

    --print("~~~~~~~ItemModel:use_one_item( item_date.item_id,item_base.type)",item_date.item_id,item_base.type)
    -- 判断物品类型，跳转到各界面
    -- TODO

    -- 装备，直接使用
    if ItemModel:check_item_if_be_equipment( item_base.type ) then
        return ItemModel:send_use_item( item_base, item_date )
    end

    local win = nil

    -- 坐骑进阶符残片 法宝晶石残片  羽翼晶石残片 羽翼技能卷残片 强化石碎片 跳到炼器合成界面的  其他
    local go_synth_id_t = { [48279] = true, [48280] = true, [48281] = true, [48282] = true,
                      [18622] = true, [18636] = true, [58274] = true }
    if go_synth_id_t[ item_date.item_id ] then
        -- 先判断该系统是否已经开启
        if not GameSysModel:isSysEnabled( GameSysModel.ENHANCED, true) then 
            return 
        end
        ForgeWin:goto_page( "synth_3" )
        return true
    end

    --如果是婚戒，则不作任何处理
    if item_base.type == ItemConfig.ITEM_TYPE_MARRIAGE_RING then
        GlobalFunc:create_screen_notic( LangModelString[326], 20, 250, 230 ); -- [326]="该道具在背包中无法直接使用"
        return true;
    end

    -- 如果是翅膀，且该翅膀的结束小于已经装备翅膀的结束，则询问是否转化为声望
    if item_base.type == ItemConfig.ITEM_TYPE_WING then
        
        local item_wing_jieji = ZXLuaUtils:low8Word(item_date.duration);  --翅膀阶级
        
        local wing_model = WingModel:get_wing_item_data();
        
        if wing_model ~= nil and item_wing_jieji < wing_model.stage then
            
            WingModel:req_wing_to_shengwang(item_date.series, item_wing_jieji);
          
            return true;
        end

    end

    -- 如果是宝石，就跳到炼器的镶嵌界面
    if item_base.type == ItemConfig.ITEM_TYPE_GEM and item_base.suitId >= 1 then
        -- 先判断该系统是否已经开启
        if not GameSysModel:isSysEnabled( GameSysModel.ENHANCED, true) then 
            return 
        end
        win = UIManager:show_window( "forge_win" )
        if win then
            win:goto_page( "set" )
        end
        return true
    end

    -- 如果是宝石碎片，就跳到炼器的合成界面
    if item_base.type == ItemConfig.ITEM_TYPE_GEM and item_base.suitId < 1 then
        -- 先判断该系统是否已经开启
        if not GameSysModel:isSysEnabled( GameSysModel.ENHANCED, true) then 
            return 
        end
        win = UIManager:show_window( "forge_win" )
        if win then
            win:goto_page( "synth_1" )
        end
        return true
    end

    -- 如果是强化道具，就到炼器的强化界面
    if item_base.type == ItemConfig.ITEM_TYPE_EQUIP_ENHANCE then
        -- 先判断该系统是否已经开启
        if not GameSysModel:isSysEnabled( GameSysModel.ENHANCED, true) then 
            return 
        end
        win = UIManager:show_window( "forge_win" )
        if win then
            win:goto_page( "strengthen" )
        end
        return true
    end

-- added by xiehande
    -- 如果是卡片道具，就到美人卡牌激活界面
    if item_base.type == 20 then
        -- 先判断该系统是否已经开启
        if not GameSysModel:isSysEnabled( GameSysModel.MEIRENHOURSE ,true) then 
            return 
        end
        require "UI/fabao/MeirenHouse"
        MeirenHouse:show( 1, item_date.item_id )
        return true
    end


    -- 灵犀丹 打开坐骑界面
    if 18602 == item_date.item_id then
        -- 先判断该系统是否已经开启
        if not GameSysModel:isSysEnabled( GameSysModel.MOUNT, true) then 
            return 
        end
        local win = UIManager:show_window("mounts_win_new")
        -- win:selected_info_tab();
        return true
    end

    -- 坐骑进阶符 打开坐骑进阶界面
    if 18612 == item_date.item_id then
        -- 先判断该系统是否已经开启
        if not GameSysModel:isSysEnabled( GameSysModel.MOUNT, true) then 
            return 
        end
        local win = UIManager:show_window("mounts_win_new")
        if win then
            win:change_page( 2 );
        end
        return true
    end

    -- 坐骑洗炼符 打开坐骑洗炼界面
    if 64700 == item_date.item_id then
        --先判坐骑是否45级开启这个界面
        if not GameSysModel:isSysEnabled( GameSysModel.MOUNT_REFRESH, true) then
            return
        end
        local win = UIManager:show_window("mounts_win_new")
        if win then
            win:change_page( 3 );
        end
        return true
    end

    -- 法宝晶石 打开法宝升级界面
    -- 改为式神升级界面
    if 18603 == item_date.item_id or 18604 == item_date.item_id or 18605 == item_date.item_id then
        if SpriteModel:get_sprite_info() then 
            UIManager:hide_window( "bag_win" )
            win = UIManager:show_window( "genius_win" )
            if win then 
                win:change_page( 1 )
            end
            return true
        else
            return false, "had_no_sprite"
        end
    end

    if 24400  == item_date.item_id then
        UIManager:show_window( "juxianling_win" )
    end

    -- 星蕴结晶 打开星蕴梦境界面对应页面
    if 18606 == item_date.item_id  then
        -- 先判断该系统是否已经开启
        if not GameSysModel:isSysEnabled(GameSysModel.LOTTERY) then 
            return 
        end
        local win = UIManager:show_window("new_dreamland_win")
        win:choose_xymj_tab( )
        return true
    end

     -- 月华结晶 打开月华梦境界面对应页面
    if 18607 == item_date.item_id then
        -- 先判断该系统是否已经开启
        if not GameSysModel:isSysEnabled(GameSysModel.LOTTERY) then 
            return 
        end
        local win = UIManager:show_window("new_dreamland_win")
        win:choose_yhmj_tab( )
        return true
    end

    -- 羽翼晶石 打开翅膀界面升级页
    -- 改为打开式神进阶
    local _wing_stoen_id_t = { [18627] = true, [18628] = true, [18629] = true, [18630] = true, [18631] = true, [18632] = true ,[18638]=true,[18639] = true }
    if _wing_stoen_id_t[ item_date.item_id ]  then
        if SpriteModel:get_sprite_info() then 
            UIManager:hide_window( "bag_win" )
            win = UIManager:show_window( "genius_win" )
            if win then 
                win:change_page( 1 )
            end
            return true
        else
            return false, "had_no_sprite"
        end
    end

    -- 羽翼技能券 打开翅膀界面和学习技能界面
    local _wing_skill_book_id_t = { [18633] = true, [18634] = true, [18635] = true  }
    if _wing_skill_book_id_t[ item_date.item_id ] then
        if SpriteModel:get_sprite_info() then 
            UIManager:hide_window( "bag_win" )
            win = UIManager:show_window( "genius_win" )
            if win then 
                win:change_page(3)
            end
            return true
        else
            return false, "had_no_sprite"
        end
    end

    -- 唤魂玉 唤魂玉界面
    if PetConfig:get_hhy_item_id() == item_date.item_id  then
        -- 先判断该系统是否已经开启
        if not GameSysModel:isSysEnabled(GameSysModel.PET) then 
            return 
        end
        
        UIManager:hide_window( "bag_win" )
        win = UIManager:show_window( "pet_win" )
        if win then
            win:do_tab_button_method(4)
        end
        return true
    end

    -- 大喇叭
    -- if item_base.type == ItemConfig.ITEM_TYPE_FUNCTION_ITEM and item_base.suitId == 2 then
    --     -- print( "大喇叭 打开千里传音界面" )
    --     return  true
    -- end

    -- 如果是悟性丹或者悟性保护，就到宠物悟性提升界面
    if item_base.type == ItemConfig.ITEM_TYPE_FUNCTION_ITEM and item_base.suitId == 6 then
        -- 先判断该系统是否已经开启
        if not GameSysModel:isSysEnabled( GameSysModel.PET ) then 
            return 
        end
        
        UIManager:hide_window( "bag_win" )
        win = UIManager:show_window( "pet_win" )
        if win then
            win:do_tab_button_method(2)
        end
        return  true
    end

    -- 如果是成长丹，就到宠物成长界面
    if item_base.type == ItemConfig.ITEM_TYPE_FUNCTION_ITEM and item_base.suitId == 7 then
        -- 先判断该系统是否已经开启
        if not GameSysModel:isSysEnabled( GameSysModel.PET ) then 
            return 
        end
        
        UIManager:hide_window( "bag_win" )
        win = UIManager:show_window( "pet_win" )
        if win then
            win:do_tab_button_method(3)
        end
        return  true
    end

    -- 如果是技能书，就到宠物技能学习界面。
    if item_base.type == ItemConfig.ITEM_TYPE_PET_SKILL then
        -- 先判断该系统是否已经开启
        if not GameSysModel:isSysEnabled(GameSysModel.PET) then 
            return 
        end
        
        UIManager:hide_window( "bag_win" )
        win = UIManager:show_window( "pet_win" )
        if win then
            win:do_tab_button_method(4)
        end
        return  true
    end

    --秘籍系统道具
    local _miji_jingyandan = {[29660]=true,[29661]=true,[39605]=true,[39606]=true,[39607]=true,[39608]=true,}
    if item_base.type == ItemConfig.ITEM_TYPE_SKILL_MIJI or 
        _miji_jingyandan[item_date.item_id] then
        SkillMiJiModel:open_miji_page(  )
        return 
    end

    -- 如果是兽魂封印，就到进入宠物技能刻印界面
    if item_base.type == ItemConfig.ITEM_TYPE_FUNCTION_ITEM and item_base.suitId == 8 then
        -- 先判断该系统是否已经开启
        if not GameSysModel:isSysEnabled( GameSysModel.PET ) then 
            return 
        end
        
        UIManager:hide_window( "bag_win" )
        win = UIManager:show_window( "pet_win" )
        if win then
            win:do_tab_button_method(5)
        end
        return  true
    end

    -- 如果是阴阳轮回珠，就弹出二次确认框
    if 14456 == item_date.item_id then
        
        local function confirm_func(  )
            local bag_space_count = ItemModel:get_bag_space_gird_count();
            if bag_space_count >= 1 then
                return ItemModel:send_use_item( item_base, item_date );
            else
                ConfirmWin2:show( 3, nil, LangModelString[327], nil, nil ); -- [327]="至少预留1个背包空间"
            end
        end

        local str = LangModelString[328]; -- [328]="是否确定使用阴阳轮回珠转换性别?#cff0000(使用成功性别不符的时装将强制脱下)"
        ConfirmWin2:show( 4, 1, str, confirm_func, nil );

        return true;

    end

    -- 如果是产生变身碎片的物品，多出来就提示转化为查克拉
    -- 产生变身碎片的物品列表
    local make_super_piece_item = {}
    if make_super_piece_item[item_date.item_id] and (not _never_popup_tips) then

        local confirm_func = function(  )
            return ItemModel:send_use_item( item_base, item_date )
        end

        local switch_fun = function( if_select )
            _never_popup_tips = if_select
        end

        local popup_tips = function(  )
            local content = "多出来的碎片将转化为查克拉"
            ConfirmWin2:show(5, nil, content, confirm_func, switch_fun, nil)
        end

        -- 物品产生的变身碎片对应的变身id
        local super_id = TransformConfig:get_super_id_by_piece( item_date.item_id )
        -- 如果已经拥有该变身
        if TransformModel:is_has_transformm(super_id) then
            -- 弹出提示转化为查克拉
            popup_tips()
        else  -- 如果还没拥有该变身
            -- 该变身需要的碎片数
            local need_piece = TransformConfig:get_piece_num_by_id( super_id )
            -- 已经拥有的碎片数
            local had_piece = TransformModel:get_transform_pieces( super_id )
            -- 该物品能产生的碎片数
            local make_piece = TransformConfig:get_piece_num_by_piece( item_date.item_id )
            -- 如果拥有的碎片数+产生的碎片数>需要的碎片数
            if had_piece + make_piece > need_piece then
                -- 弹出提示转化为查克拉
                popup_tips()
            end
        end
        return true
    end

    -- print("ItemModel:use_one_item",item_date.series)
    -- 如果是宝箱，就弹宝箱提示框
    require "../data/meirixiangouconf"
    local bx_id = meirixiangouconf.baibaoxiangid;
    if bx_id == item_date.item_id then
        OpenBoxDialog:show( item_date.series );
        return true;
    end
    local ys_id = meirixiangouconf.keyitemid;
    if ys_id == item_date.item_id then 
        GlobalFunc:create_screen_notic("该道具需要配合神秘百宝箱使用。");
        return true;
    end
    local smlb_id = meirixiangouconf.shenmilibaoid;
    if smlb_id == item_date.item_id then
        OpenBoxWin:show( 3,item_date.series )
        return true;
    end

    -- 如果是改名卡,谈改名窗口
    if 44965 == item_date.item_id then
        RenameDialog:show()
        return
    end

    -- 如果不需要提示或者跳转，就发送使用请求
    return ItemModel:send_use_item( item_base, item_date )
end

-- 发送使用物品
function ItemModel:send_use_item( item_base, item_date )
    local conditon_check, conditon_type = ItemModel:use_item_condition( item_base, item_date )
    if not conditon_check then
        return false, conditon_type
    elseif not ItemModel:check_cd( item_date.series ) then
        return false, "cd"
    elseif not ItemModel:player_buff( item_base, item_date ) then
        return false, "buff"
    elseif not ItemModel:check_pet_if_full( item_date.item_id ) then
        return false, "pet_full"
    else
        ItemModel:use_a_item( item_date.series, 0 )
        return true
    end
end

-- 人物buff， 对一些物品的使用限制. 如果返回false，会返回原因
function ItemModel:use_item_condition( item_base, item_player )
    if item_base == nil or item_player == nil then
        return false,nil
    end

    -- 如果条件为空，表示没有条件
    if #item_base.conds == 0 then
        return true
    end

    local player = EntityManager:get_player_avatar()
        
    for key, conditon in pairs(item_base.conds) do
        if conditon.cond == 1 then    -- 等级限制
            if player.level < conditon.value then
                return false, "level"
            end
        elseif conditon.cond == 2 then    -- 性别限制
            if conditon.value ~= 2 and player.sex ~= conditon.value then
                return false, "sex"
            end
        elseif conditon.cond == 3 then    -- 职业限制
            if conditon.value ~= 0 and player.job ~= conditon.value then
                return false, "job"
            end
        -- elseif conditon.cond == 4 then    -- 结婚限制
        --     -- todo
        --     -- if player.level < conditon.value then
        --     --     return false, "level"
        --     -- end
        --     return true
        -- elseif conditon.cond == 5 then    -- 骑术等级限制
        --     -- todo
        --     -- if player.level < conditon.value then
        --     --     return false, "level"
        --     -- end
        --     return true
        elseif conditon.cond == 6 then    -- 阵营的职位限制
            if player.campPost ~= conditon.value then
                return false, "campPost"
            end
        end
    end

    return true
end

-- 获取某件道具对应的职业
function ItemModel:get_item_need_job( item_id )
    local ret = 0
    require "config/ItemConfig"
    local item_base = ItemConfig:get_item_by_id( item_id )
    if item_base then
        for key, conditon in pairs(item_base.conds) do
            if conditon.cond == 3 then
                ret = conditon.value
            end
        end
    end
    return ret
end

-- 判断人物buff是否禁用物品
function ItemModel:player_buff( item_base, item_player )
    return true
end

-- 判断宠物栏是否已满
function ItemModel:check_pet_if_full( item_id )
    if ItemModel:check_item_if_egg( item_id ) then
        return PetModel:get_is_max_pet()
    else
        return true
    end
    
end

-- 根据不能使用的类型，显示提示框. win_name  根据不同窗口显示不同位置
function ItemModel:show_use_item_result( false_type , win_name)
    local confirm_word_t = { level = LangModelString[329] , -- [329]="玩家等级不够，不能使用"
                             sex = LangModelString[330] , -- [330]="玩家性别不符合使用的物品"
                             job = LangModelString[331] , -- [331]="玩家职业不符合使用的物品"
                             cd = LangModelString[332] , -- [332]="冷却中！"
                             pet_full = LangModelString[333], -- [333]="宠物栏已经满了，不能使用！"
                             had_no_wing = LangModelString[334], -- [334]="玩家还未开启翅膀, 不能使用"
                            }
    local notice_content = confirm_word_t[ false_type ]
    if Instruction:get_is_instruct(  ) then
        return
    end
    if notice_content then
        local pos_x_t = { bag_win = 450, cangku_win = 50 }   -- 根据不同窗口显示不同位置
        local confirm_x = pos_x_t[ win_name ] or 350
        local confirmWin = ConfirmWin( "notice_confirm", nil, notice_content, nil, nil, confirm_x, nil)
    end
end

-- 根据id，计算一件装备的基础战斗力
function ItemModel:calculate_equip_base_attack( item_id )
    local ret_atta_value = 0
    require "config/ItemConfig"
    local item_base = ItemConfig:get_item_by_id( item_id )
    if item_base == nil then
        return 0
    end
    -- 装备的基础战斗力
    require "config/EquipValueConfig"
    local attr_t = ItemConfig:get_staitc_attrs_by_id( item_id )  -- 装备的基础属性值 表
    for i = 1, #attr_t do
        if attr_t[i] and attr_t[i]["value"] and attr_t[i]["type"] then
            ret_atta_value = ret_atta_value + attr_t[i]["value"] * EquipValueConfig:get_calculate_factor( attr_t[i]["type"] )  
        end
    end

    return math.floor( ret_atta_value )
end

-- 计算一件装备的战斗力。  只计算背包的
function ItemModel:calculate_equip_attack_value( item_series )
    local ret_atta_value = 0
    local item_player = ItemModel:get_item_by_series( item_series )
    if item_player == nil then
        return 0
    end
    
    ret_atta_value = ItemModel:calculate_equip_attack_by_item_date( item_player )

    return ret_atta_value - ret_atta_value % 1
end

-- 根据装备动态数据，计算装备战斗力
function ItemModel:calculate_equip_attack_by_item_date( item_player )
    local ret_atta_value = 0

    if item_player == nil then 
        return  0
    end
    -- require "config/ItemConfig"
    local item_base = ItemConfig:get_item_by_id( item_player.item_id )
    if item_base == nil then
        return 0
    end

    local strong_level  = item_player.strong      -- 强化等级
    local quality_level = item_player.void_bytes_tab[1]     -- 品质等级   

    -- 装备的基础战斗力 
    local base_atta = ItemModel:get_equip_base_atta_value( item_player.item_id, quality_level ,true)
    ret_atta_value = base_atta + ret_atta_value

    -- 强化等级. 增加的战斗力 strongAttrs[strong_level + 1]
    local strong_atta =  ItemModel:get_equip_strong_atta_value( item_player.item_id, item_player.strong, quality_level ,true)
    
    ret_atta_value = strong_atta + ret_atta_value;

    -- 宝石增加的战斗力
    require "config/ComAttribute"
    local attr_t = nil
    for i = 1, #item_player.holes do
        if item_player.holes[i] and item_player.holes[i] ~= 0 then
            attr_t = ItemConfig:get_staitc_attrs_by_id( item_player.holes[i] )
            if attr_t and attr_t[1] and attr_t[1]["value"] then
                local rate = EquipValueConfig:get_calculate_factor( attr_t[1]["type"] );
                print("宝石数值",attr_t[1]["value"],rate)
                ret_atta_value = ret_atta_value + attr_t[1]["value"]*rate ; 
            end
        end
    end

    -- 装备洗练增加的战斗力
    if item_player.smith_num ~= nil and item_player.smith_num > 0 then
        for i,smith in ipairs(item_player.smiths) do
            -- print("洗练的属性", smith.type);
            if smith.type ~= nil and smith.type ~= 0 then
                local rate = EquipValueConfig:get_calculate_factor( smith.type );
                print("洗练数值", smith.value, rate);
                ret_atta_value = ret_atta_value + smith.value * rate;
            end
           
        end
    end

    return ret_atta_value
end

-- 装备基础战斗力的计算。 参数： itemid  品质
function ItemModel:get_equip_base_atta_value( item_id, quality ,is_fight_value)
    local ret_atta_value = 0
    local item_base = ItemConfig:get_item_by_id( item_id )
    if item_base == nil then
        return 0
    end

    require "config/EquipValueConfig"
    local attr_t = ItemConfig:get_staitc_attrs_by_id( item_id )  -- 装备的基础属性值 表
    for i = 1, #attr_t do
        local attr_atta_value = ItemModel:get_equip_base_single_attr_atta( item_id, quality, i ,is_fight_value)
        ret_atta_value = ret_atta_value + attr_atta_value
    end

    return ret_atta_value
end

-- 装备单个装备的基础战斗力计算  参数：单项属性配置：包括value 和type 值。参考std_item 中的 staitcAttrs 属性
-- 参数：id  品质  第几个     （这里提取出来，因为炼器可以使用）
function ItemModel:get_equip_base_single_attr_atta( item_id, quality, index ,is_fight_value)
    local atta_value = 0
    local item_base = ItemConfig:get_item_by_id( item_id )
    if item_base == nil then
        return 0
    end

    require "config/EquipValueConfig"
    local attr_t = ItemConfig:get_staitc_attrs_by_id( item_id )  -- 装备的基础属性值 表
    if attr_t[index] and attr_t[index]["value"] and attr_t[index]["type"] then
        local rate = 1; 
        if ( is_fight_value ) then
            
            rate = EquipValueConfig:get_calculate_factor( attr_t[index]["type"] )  

        end
        atta_value = atta_value + attr_t[index]["value"] * rate;
    end

    -- 装备品质
    local equip_quality = quality or 1
    local quality_att_value = 0;
    if equip_quality >= 2 then
        -- 品质是从1开始算起的，普通 = 1，依次递增
        -- 而品质的加成是从精良=2开始加成的,而配置是从精良=1开始，所以在去配置的时候要-1;
        local qual_data = item_base.qualityAttrs[equip_quality-1];
        if qual_data then
            quality_att_value = qual_data[index].value;
            local rate = 1; 
            if ( is_fight_value ) then
                rate = EquipValueConfig:get_calculate_factor( qual_data[index].type ) 
            end
            atta_value = atta_value + quality_att_value * rate
        end
    end
    atta_value = math.floor(atta_value);
    return atta_value    
end

-- 装备，强化战斗力的计算
function ItemModel:get_equip_strong_atta_value( item_id, strong_level, quality ,is_fight_value)
    local ret_atta_value = 0
    local item_base = ItemConfig:get_item_by_id( item_id )
    if item_base == nil then
        return 0
    end

    local strong_type = 0
    local strong_value = 0 
    local attr_t = item_base.strongAttrs[strong_level] or {};             -- 强化属性表
    local attr_t_len = attr_t and #attr_t or 0
    
    for i = 1, attr_t_len do

        local atta_value = ItemModel:get_equip_strong_single_attr_atta( item_id, strong_level, quality, i ,is_fight_value)
        ret_atta_value = ret_atta_value + atta_value
    end
    return ret_atta_value
end

-- 计算单个强化等级的战斗力  （这里提取出来，因为炼器可以使用）
-- 参数： id，  强化等级 ， 品质  属性的序列号
function ItemModel:get_equip_strong_single_attr_atta( item_id, strong_level, quality, index ,is_fight_value)
    
    local atta_value = 0
    local item_base = ItemConfig:get_item_by_id( item_id )
    if item_base == nil then
        return 0
    end
    
    local strong_type = 0
    local strong_value = 0 
    local attr_t = item_base.strongAttrs[strong_level] or {};             -- 强化属性表

  
    if ( attr_t[index] ) then
        strong_value = attr_t[index]["value"] 
        strong_type  = attr_t[index]["type"] 
    else
        strong_value = 0
        strong_type  = 0 
    end

    -- 装备品质 对强化的加成
    local equip_quality = quality or 1;
    if equip_quality >= 2 then
        local qual_data = item_base.qualityAttrs[equip_quality-1];
        if qual_data then
            local quality_att_value = qual_data[index].value;
            local quality_k = EquipEnhanceConfig:get_quality_addition_valua( strong_level ) or 0;
            strong_value = strong_value + quality_att_value*quality_k;
        end
        
    end
    local ratio =  1;
    if ( is_fight_value) then
        ratio = EquipValueConfig:get_calculate_factor( strong_type )
    end
    atta_value = math.floor(atta_value + strong_value * ratio)
    
    return atta_value
end


-- 计算一件装备战斗力，先在背包中找，再在人物身上找
function ItemModel:get_item_attack( item_series )
    local item_player = ItemModel:get_item_by_series( item_series )
    if item_player then
        return ItemModel:calculate_equip_attack_value( item_series )
    end

    item_player = UserInfoModel:get_equi_by_id( item_series )
    if item_player then
        return UserInfoModel:calculate_equip_attack_value( item_series )
    end
    return 0
end

-- 背包排序
function ItemModel:item_arrange(  )
    -- 按照 item_id 来排序
    for i = 1, table.maxn( _bag_items ) do
        for j = i, table.maxn( _bag_items ) do
            -- 和当前循环的第一个比较，把大的挪到当前第一位
            if not ItemModel:compare_item_id( _bag_items[i], _bag_items[j] ) then
                local item_temp = _bag_items[i]
                _bag_items[i] = _bag_items[j]
                _bag_items[j] = item_temp
            end
        end
    end
    update_bag_window()
end

-- 比较两个 item的 id， nil算小，  如果前面的大于后面的，返回true
function ItemModel:compare_item_id( item_1, item_2 )
    -- 先按物品种类判断排序，如果是同一种，再id排序
    -- todo

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
function ItemModel:check_bag_if_full()
    local player = EntityManager:get_player_avatar()
    local bag_item_count = ItemModel:get_item_count_without_null()
-- print("物品数量：：：：", player.bagVolumn, bag_item_count, player.bagVolumn <= bag_item_count )
    if player.bagVolumn <= bag_item_count then
        return true
    else
        return false
    end
end

-- 使用一个结构来更新物品
function ItemModel:change_item_by_struct( item_struct )
    if item_struct and item_struct.series then
        for key, item in pairs( _bag_items )  do
            if item.series == item_struct.series then
                _bag_items[ key ] = item_struct
                ForgeWin:forge_win_update( "bag_change" )
                return true
            end
        end
    end
    return false
end

-- 根据 物品序列号，使 冷却组重新冷却
function ItemModel:item_begin_cool( item_id )
    -- local item_player = ItemModel:get_item_by_series( item_series )
    if item_id then
        require "config/ItemConfig"
        local item_base = ItemConfig:get_item_by_id( item_id )
        local now_time = GameStateManager:get_total_milliseconds()         -- 当前时间 , 毫秒
        if item_base.colGroup then
            _cool_group_cd[ item_base.colGroup ] = now_time + item_base.dura
            BagWin:update_item_cd( item_base.colGroup )
        end

        -- *************  特殊cd处理  ************--
        -- 生命包使用，要把 生命仙露  开始 cd 
        -- if item_id == 19300 or item_id == 19301 then 
        --     _cool_group_cd[ 1 ] = now_time + 15000
        --     BagWin:update_item_cd( 1 )
        -- end
        -- -- 法力包  使用，灵液开始cd
        -- if item_id == 19200 or item_id == 19201 then 
        --     _cool_group_cd[ 2 ] = now_time + 15000
        --     BagWin:update_item_cd( 2 )
        -- end
    end
end

-- 判断道具是否属于冷却组
function ItemModel:check_item_belong_cd_group( item_id, colGroup )
    if item_id then
        local item_base = ItemConfig:get_item_by_id( item_id )
        if item_base and item_base.colGroup == colGroup then
            return true
        end
    end
    return false
end

-- 获取物品cd时间
function ItemModel:get_item_cd_time( item_id )
    local item_base = ItemConfig:get_item_by_id( item_id )
    if item_base then
        return item_base.dura
    end
    return 0
end

-- 获取当前cd剩余时间
function ItemModel:get_item_remain_cd( item_id )
    local item_base = ItemConfig:get_item_by_id( item_id )
    local now_time = GameStateManager:get_total_milliseconds()
    if item_base and item_base.colGroup then
        if _cool_group_cd[ item_base.colGroup ] and _cool_group_cd[ item_base.colGroup ] - now_time > 0  then
            return ( _cool_group_cd[ item_base.colGroup ] - now_time) / 1000
        end
    end
    return 0
end

-- 获取当前，道具剩余时间的百分比
function ItemModel:get_item_remain_cd_percent( item_id )
    local item_cd = ItemModel:get_item_cd_time( item_id )
    if item_cd > 0 then
        local remain_cd = ItemModel:get_item_remain_cd( item_id )
        return remain_cd * 1000 / item_cd
    end
    return 0
end

-- 18302 高级仙露 -- 18310 初级灵液 28212 1级宠物粮 28211 宠物玩具


-- 血瓶
local blood_bottle_item_ids = { 18303,18302,18301,18300 };
-- 获取背包里存在的血瓶item_series
function ItemModel:get_bag_exist_blood_bottle()
    for i=1,#blood_bottle_item_ids do
        local item_info = ItemModel:get_item_info_by_id( blood_bottle_item_ids[i])
        local item_base = ItemConfig:get_item_by_id( blood_bottle_item_ids[i] )
        -- 添加使用物品的条件判断
        local result = ItemModel:use_item_condition( item_base, item_info )
        if ( result ) then
            return item_info.series;
        end
    end
    return nil;
end

--蓝瓶
local magic_bottle_item_ids = { 18313,18312,18311,18310 };
 -- 获取背包里存在的蓝瓶item_series
function ItemModel:get_bag_exist_magic_bottle()
    for i=1,#magic_bottle_item_ids do
        local item_info = ItemModel:get_item_info_by_id( magic_bottle_item_ids[i])
        local item_base = ItemConfig:get_item_by_id( magic_bottle_item_ids[i] )
        local result = ItemModel:use_item_condition( item_base, item_info )
        -- 添加使用物品的条件判断
        if ( result ) then
            return item_info.series;
        end
    end
    return nil;
end

local pet_food_item_ids = { 19003,19002,19001,19000 };
 -- 获取背包里存在的宠物粮的series
function ItemModel:get_bag_exist_pet_food()
    for i=1,#pet_food_item_ids do
        local item_info = ItemModel:get_item_info_by_id( pet_food_item_ids[i])
        local item_base = ItemConfig:get_item_by_id( pet_food_item_ids[i] )
        local result = ItemModel:use_item_condition( item_base, item_info )
        -- 添加使用物品的条件判断
        if ( result ) then
            return item_info.series;
        end
    end
    return nil;
end

local pet_toy_item_ids = { 28211 };
 -- 获取背包里存在的宠物玩具
function ItemModel:get_bag_exist_pet_toy()
    for i=1,#pet_toy_item_ids do
        local item_info = ItemModel:get_item_info_by_id( pet_toy_item_ids[i])
        if ( item_info ) then
            return item_info.series;
        end
    end
    return nil;
end

-- 判断cd，是否可以使用物品. 可使用返回true
function ItemModel:check_cd( item_series )
    local item_player = ItemModel:get_item_by_series( item_series )
    if item_player then
        require "config/ItemConfig"
        local item_base = ItemConfig:get_item_by_id( item_player.item_id )
        local now_time = GameStateManager:get_total_milliseconds()         -- 当前时间 , 毫秒
        -- local now_tiem_second = GameStateManager:get_total_seconds(  )
        local cool_group_cd_time = _cool_group_cd[ item_base.colGroup ]
        if cool_group_cd_time == nil then        -- 没加入过冷却组，即没使用过
            return true
        end
        if cool_group_cd_time > now_time then    -- 未过冷却时间
            return false
        end
        
    end
    return true
end

-- 判断是否是宠物蛋
function ItemModel:check_item_if_egg( item_id )
    require "config/PetConfig"
    local egg_id_table = PetConfig:get_pet_egg_tabel( )
    for key, egg in pairs( egg_id_table ) do
        if egg.itemid == item_id then
            return true
        end
    end
    return false
end

-- 背包拆分
function ItemModel:split_bag_item( item_date )
    if (not item_date) or (not item_date.series) then
        -- print("date为空！！！")
        return 
    end
    -- 先判断背包是否已经满了，如果已经满了就要提示
    local player = EntityManager:get_player_avatar()
    local bag_item_count = ItemModel:get_item_count_without_null()
--    print("player.bagVolumn",player.bagVolumn)
    if player.bagVolumn <= bag_item_count then
        local notice_words = LangModelString[335] -- [335]="背包已经满了，不能拆分！"
        ConfirmWin( "notice_confirm", nil, notice_words, nil, nil, 450, nil)
    else
        local function split_item_fun( num )
            ItemCC:request_split_item( item_date.series, num )
        end
        if item_date.count > 1 then
            BuyKeyboardWin:show(item_date.item_id, split_item_fun, 2, item_date.count - 1 )
        end
    end
end

-- 显示tips
function ItemModel:show_bag_tips( item_date )

    if item_date == nil then
        return 
    end

    -- 使用 按钮回调函数
    local function use_callback()
        local function swith_but_func( flag )
            _dont_open_gem_dialog = flag
        end
        local function confirm_fun(  )
            if not BagModel:check_can_use_pet_food( item_date.item_id ) then 
                return
            end
            
            -- 批量使用回调函数
            local function batch_use_fun(num)        
                --print("批量使用",num,"物品ID",item_date.item_id)  
                if item_date~=nil then
                    ItemCC:req_batch_use(item_date.series, num)
                end
            end 
            --print("物品数量"..item_date.count)
            local item_config = ItemConfig:get_item_by_id(item_date.item_id);
            -- 批量使用弹出窗口        
            if item_config.flags.batchUse and item_date.count > 1 then 
               BuyKeyboardWin:show(item_date.item_id, batch_use_fun, 14, item_date.count ) 
               return 
            end 

            local use_result, false_type = ItemModel:use_one_item( item_date )
            if not use_result then
                ItemModel:show_use_item_result( false_type , "bag_win")
            end
        end
        -- 如果是非绑定物品，要提示
        local item_config = ItemConfig:get_item_by_id(item_date.item_id);
        if item_config.type == ItemConfig.ITEM_TYPE_MARRIAGE_RING then
            -- 如果是婚戒
            MarriageModel:req_swallow_ring( item_date );
            return
        -- elseif item_config.type == ItemConfig.ITEM_TYPE_GEM and not _dont_open_gem_dialog then
        --         local notice_words = LangGameString[2448] -- "是否使用精华化作炼器中的附灵材料"
        --         -- ConfirmWin( "select_confirm", nil, notice_words, confirm_fun, nil, 450, 130)
        --         ConfirmWin2:show( 5, 0, notice_words,  confirm_fun, swith_but_func, title_type )
        elseif ItemModel:check_if_body_use_item( item_date.item_id ) and item_date.flag ~= 1 then
            local notice_words = LangModelString[14] -- [14]="装备后该物品将与您绑定，确定装备吗？"
            ConfirmWin( "select_confirm", nil, notice_words, confirm_fun, nil, 450, 130)
        else
            confirm_fun(  )
        end
    end
    -- 拆分 按钮回调函数
    local function split_callback( )
        ItemModel:split_bag_item( item_date )
    end
    -- 存入 仓库按钮回调函数
    local function to_cangku_callback(  )
        ItemModel:put_one_item_to_cangku( item_date )
    end
    -- 存入 仙踪仓库按钮回调函数
    local function to_guild_cangku_callback(  )
        ItemModel:put_one_item_to_guild_cangku( item_date )
    end
    -- 出售 按钮回调函数
    local function sell_callback(  )
        ShopModel:request_sell_item( item_date )
    end
    -- TipsModel:show_tip( 600, 255, item_date, use_callback, split_callback, false )

    local cang_ku_win       = UIManager:find_visible_window("cangku_win")
    local guild_cang_ku_win = UIManager:find_visible_window("guild_cangku_win")
    local shop_win          = UIManager:find_visible_window("shop_win")
    local buniess_win       = UIManager:find_visible_window("buniess_win")

    -- 拆分判断  数量小于2的物品，不可以拆分  不显示拆分按钮
    local split_callback_temp = split_callback
    local split_but_name = LangModelString[25] -- [25]="拆分"
    if item_date.count < 2 then
        split_callback_temp = nil
        split_but_name = ""
    end

    -- 判断是不是药品, 如果是药品，需要显示 “放入快捷栏”
    local put_in_menu_func = nil
    local put_in_menu_word = nil
    local function put_in_menu(  )
        -- print("药品放入快捷栏")
        local win = UIManager:find_window("menus_panel")
        if ( win ) then
            Instruction:handleUIComponentClick(instruct_comps.PUT_YP_QUICK)
            local user_item = ItemModel:get_item_info_by_id( item_date.item_id )
            if ( user_item ) then
                win:add_supply( user_item, true )
            end
            -- win:add_supply( item_date,true )
        end
    end
    local item_type = ItemModel:get_item_type( item_date.item_id )
    if item_type == ItemConfig.ITEM_TYPE_MEDICAMENTS or item_type == ItemConfig.ITEM_TYPE_FAST_MEDICAMENT then 
        put_in_menu_func = put_in_menu
        put_in_menu_word = LangModelString[336] -- [336]="放入快捷栏"
    end


    -- 显示tips窗口
    if cang_ku_win then
        TipsModel:show_tip( 600, 255, item_date, to_cangku_callback, split_callback_temp, false, LangModelString[337], split_but_name, TipsModel.LAYOUT_LEFT, put_in_menu_func, put_in_menu_word) -- [337]="存入"
    elseif guild_cang_ku_win then
        TipsModel:show_tip( 600, 255, item_date, to_guild_cangku_callback, split_callback_temp, false, LangModelString[337], split_but_name, TipsModel.LAYOUT_LEFT, put_in_menu_func, put_in_menu_word) -- [337]="存入"
    -- elseif shop_win then
        -- 屏敝出售功能
        -- TipsModel:show_tip( 600, 255, item_date, sell_callback, split_callback_temp, false, LangModelString[338], split_but_name, TipsModel.LAYOUT_LEFT, put_in_menu_func, put_in_menu_word) -- [338]="出售"
    elseif buniess_win then 
        TipsModel:show_tip( 600, 255, item_date, nil, split_callback_temp, false, "", split_but_name, TipsModel.LAYOUT_LEFT, put_in_menu_func, put_in_menu_word)
    else
        if ItemModel:check_if_equip_by_id( item_date.item_id ) then
            TipsModel:show_tip( 600, 255, item_date, use_callback, split_callback_temp, false, LangModelString[6], split_but_name, TipsModel.LAYOUT_LEFT, put_in_menu_func, put_in_menu_word ) -- [6]="装备"
        else
            TipsModel:show_tip( 600, 255, item_date, use_callback, split_callback_temp, false, LangModelString[339], split_but_name, TipsModel.LAYOUT_LEFT, put_in_menu_func, put_in_menu_word ) -- [339]="使用"
        end
    end
end

-- 根据id检查物品是否是装备
function ItemModel:check_if_equip_by_id( item_id )
    local item_base = ItemConfig:get_item_by_id( item_id )
    if item_base then
        return ItemModel:check_item_if_be_equipment( item_base.type )
    else
        return false
    end
end

-- 根据id，检查物品是否是身上用的 包括装备和翅膀、服饰
function ItemModel:check_if_body_use_item( item_id )
    local _body_item_num_t = { [1] = true, [2] = true, [3] = true, [4] = true,
                      [5] = true, [6] = true, [7] = true, [8] = true,
                      [9] = true, [10] = true, [11] = true, [12] = true
                      , [13] = true, [14] = true, [15] = true , [16] = true, [17] = true}
    local item_base = ItemConfig:get_item_by_id( item_id )
    if item_base then
        return _body_item_num_t[ item_base.type ]
    else
        return false
    end
end

-- 获取道具 类型 type
function ItemModel:get_item_type( item_id )
    require "config/ItemConfig"
    local item_base = ItemConfig:get_item_by_id( item_id )
    if item_base then
       return item_base.type
   end
   return 0
end

-- 放一个物品到仓库
function ItemModel:put_one_item_to_cangku( item_date )
    if item_date then 
        if CangKuItemModel:check_bag_if_full() then
            local notice_content = LangModelString[13] -- [13]="仓库已经满了！"
            local confirmWin = ConfirmWin( "notice_confirm", nil, notice_content, nil, nil, 450, nil)
        else
            CangKuCC:req_bag_to_cangku( item_date.series, 0 )
        end 
    end
end

function ItemModel:put_one_item_to_guild_cangku( item_date )
    if item_date then 
        if GuildCangKuItemModel:check_bag_if_full() then
            local notice_content = LangModelString[13] -- [13]="仓库已经满了！"
            local confirmWin = ConfirmWin( "notice_confirm", nil, notice_content, nil, nil, 450, nil)
        else
            GuildModel:req_bag_to_cangku(item_date.quality, item_date.series, 0 )
        end 
    end
end
-- 判断是否存在道具
function ItemModel:check_if_exist_by_item_id( item_id )
    for key, item in pairs(_bag_items) do
        if item.item_id == item_id then
            return true
        end
    end
    return false
end

-- -- 获取物品品质颜色
function ItemModel:get_item_color( item_id )
    require "config/ItemConfig"
    local item_base = ItemConfig:get_item_by_id( item_id )
    if item_base == nil then
        require "config/StaticAttriType"
        return _static_quantity_color[1]
    else
        return _static_quantity_color[ item_base.color + 1 ]
    end
end

-- 获取某种物品的个数
function ItemModel:get_item_total_num_by_id( item_id )
    local ret_total_num = 0
    for key, item in pairs(_bag_items) do
        if item.item_id == item_id then
            ret_total_num = ret_total_num + item.count
        end
    end
    return ret_total_num
end

-- 直接根据id，寻找 第一个来使用
function ItemModel:use_item_by_item_id( item_id )
    for i = 1, #_bag_items do 
        if _bag_items[i] and _bag_items[i].item_id == item_id then
            return ItemModel:use_one_item( _bag_items[i] )
        end
    end
end

-- 根据 序列号列表， 计算总数
function ItemModel:add_total_by_series_t( series_t )
    local total_num = 0
    for key, series in pairs(series_t) do
        local item_date = ItemModel:get_item_by_series( series )
        if item_date then
            total_num = total_num + item_date.count
        end
    end
    return total_num
end

-- 获取道具名称 （包含颜色）
function ItemModel:get_item_name_with_color( item_id )
    local item_name = ""
    local item_base = ItemConfig:get_item_by_id( item_id )
    if item_base then
        local color = ItemModel:get_item_color( item_id )
        item_name = color .. item_base.name
    end
    return item_name
end

-- 根据序列号 获取道具，先在背包中寻找，如果没有，在人物身上寻找
function ItemModel:get_item_in_bag_or_body( item_series )
    local item_date = nil 
    item_date = ItemModel:get_item_by_series( item_series )
    if item_date == nil then
        item_date = UserInfoModel:get_equi_by_id( item_series )
    end
    return item_date
end

-- 根据序列号  判断道具是否是绑定道具  
function ItemModel:check_item_lock( series )
    local item_date = ItemModel:get_item_in_bag_or_body( series )
    if item_date and item_date.flag == 1 then
        return true
    end
    return false
end

-- 计算某个装备的宝石镶嵌数
function ItemModel:equip_gem_add_up( series )
    -- print("ItemModel:equip_gem_add_up~~~~~~!!!!")
    local total_gem = 0
    local item_date = ItemModel:get_item_in_bag_or_body( series )
    if item_date then 
        if item_date.holes[1] and item_date.holes[1] ~= 0 then
            total_gem = total_gem + 1
        end
        if item_date.holes[2] and item_date.holes[2] ~= 0 then
            total_gem = total_gem + 1
        end
        if item_date.holes[3] and item_date.holes[3] ~= 0 then
            total_gem = total_gem + 1
        end
    end
    return total_gem
end

function ItemModel:get_item_pj( item_base )
    if ( item_base.maxStage ) then
        if ( item_base.color == 3 ) then
            return 1;
        elseif ( item_base.color == 4 ) then 
            return 2;
        end
    end
    return 0;
end

-- 找到等级最高的戒指
function ItemModel:find_max_lv_ring_series(  )
    
    local min_ring = nil;
    for i,v in ipairs(_bag_items) do
        local item_base = ItemConfig:get_item_by_id( v.item_id );
        if item_base.type == ItemConfig.ITEM_TYPE_MARRIAGE_RING then
            --如果一开始就找到了比翼双飞戒指就直接返回，因为包裹里能存在的戒指最高级就是比翼双飞了。
            if v.item_id == 11102 then
                return v.series;
            else
                min_ring = v;    
            end
        end
    end
    if min_ring ~= nil then
        return min_ring.series;
    else
        return nil;
    end

end

-- 保存临时取的道具数据
function ItemModel:save_temp_item_info( item_id,item_info )
    temp_item_info_table[item_id] = item_info;
end

function ItemModel:get_temp_item_info( item_id )
    return temp_item_info_table[item_id];
end

function ItemModel:get_fashion_item_num(  ) --获取时装个数
    local fashion_num = 0
    for key, item in pairs( _bag_items ) do
        local item_base = ItemConfig:get_item_by_id( item.item_id )
        if item_base.type == ItemConfig.ITEM_TYPE_FASHION_DRESS then
            fashion_num = fashion_num + 1
        end
    end
    return fashion_num
end

function ItemModel:get_fashion_item_by_position( index)--获取背包里的第index个时装
    for key, item in pairs( _bag_items ) do
        local item_base = ItemConfig:get_item_by_id( item.item_id )
        if item_base.type == ItemConfig.ITEM_TYPE_FASHION_DRESS then
            index = index -1
            if index == 0 then
                return item
            end
        end
    end
    return nil
end

function ItemModel:open_box_show(item_series,_type )
    UIManager:destroy_window("openbox_win")
    OpenBoxWin:show(_type,item_series)
end

----根据玩家背包中的装备数据和已装备的装备数据，判定是否有可穿戴的道具
function ItemModel:if_have_equip_can_wear(  )
    local have_wear = {}
    local if_find_equip = false 
    --只有等级在30~45级的玩家才做提示
    local player = EntityManager:get_player_avatar()
    local player_level = player.level 
    if player_level >= 30 and player_level <= 45 then 
        local have_wear_equip = UserInfoModel:get_equi_info()
        --标志人物各部位是否已有装备
        local wear_body_equip = { [1] = false, [2] = false, [3] = false, [4] = false,
                      [5] = false, [6] = false, [7] = false, [8] = false,
                      [9] = false, [10] = false}
       
        for i,v in ipairs(have_wear_equip) do
            local item_base = ItemConfig:get_item_by_id( v.item_id )
            local equip_type = item_base.type
            if wear_body_equip[equip_type] ~= nil then 
                wear_body_equip[equip_type] = true 
                have_wear[i] = v.item_id 
            end 
        end
        --找下人物身上是否有位置没有穿带
        for i=1,10 do
           if  wear_body_equip[i] == false then 
                if_find_equip =true 
                local function cb_fun(  )
                    UIManager:toggle_window("user_equip_win")
                end
                MiniBtnWin:show( 23 , cb_fun  );
                break
            end 
        end
        if if_find_equip == false  then 
        --找已装备道具中的道具是否有可以升级的
              -- 获取人物信息(等级)
            require "config/EquipEnhanceConfig"
            local upgrade_t = EquipEnhanceConfig:get_upgrade_table( )
            for a,equip_id in ipairs(have_wear) do
                for i, v in ipairs(upgrade_t) do                    -- 遍历升级信息表，查询每个等级的itemid集合
                    if player_level >= v.checkLevel then                       -- 套装对人物有级数要求
                        for j,k in ipairs(v.items) do               -- 查询item_id集合，判断传入的id是否可以升级
                            if k == equip_id then                    -- 
                                local function cb_fun(  )
                                    UIManager:toggle_window("user_equip_win")
                                end
                                MiniBtnWin:show( 23 , cb_fun  );
                                break
                            end
                        end
                    end
                end
            end 
        end
    else 
        ZXLog("等级不在提升要求等级范围内")
    end
end

-- 检查背包是否有N个格子剩余
function ItemModel:check_bag_need_gezi(i)
    local player = EntityManager:get_player_avatar()
    local bag_item_count = ItemModel:get_item_count_without_null()
    print("player.bagVolumn=",player.bagVolumn)
    print("bag_item_count+ i=",bag_item_count+ i)
    if  bag_item_count + i > player.bagVolumn then
        return false --不足够
    else
        return true
    end
end



-- -- 获取背包物品series集合, 根据物品id(item_id)
function ItemModel:get_card_series_by_id( item_id)
    local bag_items, bag_item_count = ItemModel:get_bag_data()
    local series_list = {}
    for i,item in pairs(bag_items) do
        if item.item_id == item_id then
                    series_list[#series_list + 1] = item.series
        end
    end
    return series_list
end