-- PetModel.lua
-- create by hcl on 2012-12-10
-- 宠物管理类
-- 用于管理玩家的所有宠物

--super_class.PetModel()
PetModel = {}

-- require "config/PetConfig"

-- 主界面宠物的id
local curr_pet_id = nil;
-- 主界面宠物的index
local curr_pet_index = 1
-- 主界面宠物是否出战 true代表出战，false代表休息
local curr_pet_is_fight = false;
-- 是否首次登录游戏
local is_first = true;
-- 记录宠物界面是否打开
local is_pet_win_open = false;

local curr_page_index = 1 -- 记录当前页面分页，从伙伴图鉴、技能秘籍重新打开宠物页面的时候用于定位


-- 主角玩家的宠物信息  tab里面都是单个宠物结构
local tab_pet_info = { max_num = 0, curr_num = 0,tab = nil};
local tab_pet_store = {};

-- added by aXing on 2013-5-25
function PetModel:fini( ... )
	curr_pet_id = nil;
	curr_pet_index = 1
	curr_pet_is_fight = false;
	is_first = true;
	is_pet_win_open = false;
	tab_pet_info = { max_num = 0, curr_num = 0,tab = nil};
	tab_pet_store = {};
	-- 清除宠物界面
	UIManager:destroy_window("pet_win");
end

function PetModel:init_data( _max_num, _curr_num, _tab )
	tab_pet_info.max_num = _max_num;
	tab_pet_info.curr_num = _curr_num;
	tab_pet_info.tab = _tab;
end

function PetModel:update_pet_num( new_num )
	tab_pet_info.max_num = new_num
end

function PetModel:get_pet_info()
	return tab_pet_info;
end
-- 记录宠物界面的打开状态
function PetModel:update_pet_win_state( is_open )
	is_pet_win_open = is_open;
end

function PetModel:get_pet_win_is_open()
	return is_pet_win_open;
end

function PetModel:get_current_pet_id()
	return curr_pet_id ;
end

-- curr_pet_index，curr_page_index在关闭petwin时没有重置为1，注意。
function PetModel:set_cur_pet_index( index )
	curr_pet_index = index
end

function PetModel:get_cur_pet_index( )
	return curr_pet_index
end

function PetModel:set_cur_page_index( index )
	curr_page_index = index
end

function PetModel:get_cur_page_index( )
	return curr_page_index
end

-- 设置当前出战宠物
function PetModel:set_current_pet_id(_curr_pet_id)
	if ( curr_pet_id ~= _curr_pet_id ) then
		curr_pet_id = _curr_pet_id;
		if ( curr_pet_id ~= 0 ) then 
			local win = UIManager:find_visible_window("user_panel");
			if ( win ) then
				win:update_pet(1);
			end
		else
			self:set_current_pet_is_fight( false );
		end
	end
end

-- 取得当前出战的宠物的名字
function PetModel:get_current_pet_name()
	if ( curr_pet_id ~=nil ) then
		local pet_struct = PetModel:get_pet_info_by_pet_id(curr_pet_id);
		if ( pet_struct ) then
			return PetModel:get_pet_info_by_pet_id(curr_pet_id).pet_name;
		end
	end
	return nil;
end

-- 设置当前宠物出战或休息
function PetModel:set_current_pet_is_fight(is_fight)
	curr_pet_is_fight = is_fight
	--
	local win = UIManager:find_window("user_panel");
	if ( win ) then
		win:update_pet_fight_state( is_fight )
	end
end

function PetModel:get_current_pet_is_fight()
	return curr_pet_is_fight;
end

function PetModel:set_is_first(_is_first)
	is_first = _is_first;
end

function PetModel:get_is_first()
	return is_first;
end

function PetModel:set_pet_skill_store(store)
	tab_pet_store = store;
end

function PetModel:get_pet_skill_store()
	return tab_pet_store;
end

-- 根据宠物id取得对应的struct
function PetModel:get_struct_by_id(pet_id) 
	local tab = tab_pet_info.tab;
	for i=1,#tab do
		local struct = tab[i];
		if (pet_id == struct.tab_attr[1]) then 
			return tab_pet_info.tab[i];
		end
	end
	return nil;
end

-- 取得背包中技能书table
function PetModel:get_bag_skill_book()
	 -- 取得背包中的技能书
    local skill_book_lv = PetConfig:get_skill_book_lv();
    -- 第一个是item_struct,第二个是item_num，第三个是技能id，第四个是技能等级
    local tab = {};
    for i=1,4 do
        local struct = skill_book_lv[i];
        --print("struct.len = " .. #struct);
        local item_struct = nil;
        for j=1,#struct do
            item_struct = ItemModel:get_item_info_by_id(struct[j]);
            if ( item_struct ) then
                local sub_tab = {};
                sub_tab.struct = item_struct;
                sub_tab.skill_id = ItemConfig:get_skill_id_by_item_id(item_struct.item_id);
                sub_tab.skill_lv = i;
                local len = #tab;
                tab[len + 1] = sub_tab;
            end
        end
    end
    return tab;
end

-- 取得pet_id对应的宠物的数据
function PetModel:get_pet_info_by_pet_id ( pet_id )
	--print("pet_id",pet_id)
	local tab = tab_pet_info.tab;
	for i,v in ipairs(tab) do
		--print("pet_id",pet_id,v.tab_attr[1])
		if ( v.tab_attr[1] == pet_id ) then
			return v;
		end
	end
	return nil;
end
-- 根据索引删除宠物
function PetModel:delete_pet_info_by_index(index )
	local tab = tab_pet_info.tab;
	table.remove(tab,index);
	tab_pet_info.curr_num = tab_pet_info.curr_num - 1;
end

-- 根据pet_id删除宠物
function PetModel:delete_pet_info_by_pet_id( pet_id )
	for i=1,tab_pet_info.curr_num do
		if ( tab_pet_info.tab[i].tab_attr[1] == pet_id ) then
			table.remove(tab_pet_info.tab,i);
			tab_pet_info.curr_num = tab_pet_info.curr_num - 1;
			return;
		end
	end
end

-- 根据pet_id取得宠物索引
function PetModel:get_index_by_pet_id( pet_id )
	for i=1,tab_pet_info.curr_num do
		if ( tab_pet_info.tab[i].tab_attr[1] == pet_id ) then
			return i;
		end
	end
	return nil;
end

-- 宠物栏是否已满
function PetModel:get_is_max_pet()
	--print("tab_pet_info.curr_num=",tab_pet_info.curr_num,"tab_pet_info.max_num",tab_pet_info.max_num)
	if ( tab_pet_info.curr_num < tab_pet_info.max_num ) then
		return true;
	else
		return false;
	end
end

-- 取得当前出战宠物的数据
function PetModel:get_current_pet_info(  )
	-- print("curr_pet_id",curr_pet_id)
	if ( curr_pet_id  ) then
		return self:get_pet_info_by_pet_id( curr_pet_id );
	end
	return nil;
end

local curr_fight_pet_cd = 0;
-- 取得当前宠物的出战cd
function PetModel:get_current_fight_pet_cd(  )
	return curr_fight_pet_cd;
end

function PetModel:set_current_fight_pet_cd( cd )
	curr_fight_pet_cd = cd;
end

-- 取得当前出战宠物的技能数据
function PetModel:get_current_fight_pet_skill_info()
	local pet_info = PetModel:get_current_pet_info(  );
	if ( pet_info ) then
		return pet_info.tab_pet_skill_info,pet_info.normal_skill;
	end
	-- print("当前没有出战宠物");
	return nil;
end

local _dont_show_again = false
function PetModel:show_bindingYuanbao_tips( isUseShield, AutoBuy, up_handler )
    local function confirm_func(  )
        up_handler()
    end
    local function switch_fun( if_select )
        _dont_show_again = if_select
    end
    local content = "礼券不足，使用元宝代替"
    ConfirmWin2:show(5, nil, content, confirm_func, switch_fun, nil)
end

-- 礼券不足，是否消耗元宝购买
function PetModel:show_auto_buy_tips( auto_cailiao, auto_baohuzhu, item_id_1, item_id_2, up_handler )
	-- local p_s = PetWin:get_current_pet_info();
    -- if (p_s) then
    -- print("=========auto_cailiao, auto_baohuzhu, item_id_1, item_id_2=======", auto_cailiao, auto_baohuzhu, item_id_1, item_id_2)
    	local player = EntityManager:get_player_avatar()
    	local content = ""
    	if auto_cailiao == 1 then
        	-- item_id_1 = PetConfig:get_czd_item_id(p_s.curr_wx + 1);
        	local store_item_1 = StoreConfig:get_store_info_by_id(item_id_1)
        	if store_item_1 then
	        	local money_type = store_item_1.price[1].type
	        	-- print("=========money_type, player.bindYuanbao < store_item_1.price[1].price, _dont_show_again====", money_type, player.bindYuanbao < store_item_1.price[1].price, _dont_show_again)
	        	if money_type == 5 and player.bindYuanbao < store_item_1.price[1].price and _dont_show_again == false then
	            	PetModel:show_bindingYuanbao_tips( auto_baohuzhu, auto_cailiao, up_handler )
	            	return
	        	end
	        end
        end
        if auto_baohuzhu == 1 then
        	-- item_id_2 = PetConfig:get_czbhd_item_id(p_s.curr_wx + 1);
        	local store_item_2 = StoreConfig:get_store_info_by_id(item_id_2)
        	if store_item_2 then
	        	local money_type = store_item_2.price[1].type

	        	if money_type == 5 and player.bindYuanbao < store_item_2.price[1].price and _dont_show_again == false then
	            	PetModel:show_bindingYuanbao_tips( auto_baohuzhu, auto_cailiao, up_handler )
	            	return
	        	end
	        end
        end

        up_handler()
    -- end
end

-- 提升悟性
function PetModel:do_upgrade_wuxing( AutoBuy, isUseShield )
	-- local p_s = PetWin:get_current_pet_info();
	-- if not p_s then
	-- 	return
	-- end
	-- local item_id_1 = PetConfig:get_czd_item_id(p_s.curr_wx + 1);
	-- local item_id_2 = PetConfig:get_czbhd_item_id(p_s.curr_wx + 1);
	-- local upgrade_wuxing = function(  )
	-- 	PetCC:req_add_wu(p_s.tab_attr[1], isUseShield, AutoBuy)
	-- end
	-- PetModel:show_auto_buy_tips( AutoBuy, isUseShield, item_id_1, item_id_2, upgrade_wuxing )

	local p_s = PetWin:get_current_pet_info()
	if not p_s then
		return
	end

	local item_id = PetConfig:get_czd_item_id(p_s.curr_wx+1)
	local item_id_2 = PetConfig:get_czbhd_item_id(p_s.curr_wx + 1);
	local money_type = MallModel:get_only_use_yb() and 3 or 2
	local param = {p_s.tab_attr[1], isUseShield, AutoBuy, money_type}
	local upgrade_wuxing = function( param )
		PetCC:req_add_wu(param[1], param[2], param[3], param[4])
	end

	if isUseShield == 0 and AutoBuy == 1 then
		MallModel:handle_shopping_1( item_id, 1, upgrade_wuxing, param )
	elseif isUseShield == 1 and AutoBuy == 1 then
		MallModel:handle_shopping_2( item_id, 1, item_id_2, 1, upgrade_wuxing, param)
	else
		upgrade_wuxing(param)
	end
end

-- 提升成长
function PetModel:do_upgrade_chengzhang( AutoBuy, isUseShield )
	local p_s = PetWin:get_current_pet_info();
	if not p_s then
		return
	end
	local item_id = PetConfig:get_czd_item_id(p_s.curr_grow + 1);
	local item_id_2 = PetConfig:get_czbhd_item_id(p_s.curr_grow + 1);
	local money_type = MallModel:get_only_use_yb() and 3 or 2
	local param = {p_s.tab_attr[1], isUseShield, AutoBuy, money_type}
	local upgrade_chengzhang = function( param )
		PetCC:req_add_grow_up(param[1], param[2], param[3], param[4])
	end

	if isUseShield == 0 and AutoBuy == 1 then
		MallModel:handle_shopping_1( item_id, 1, upgrade_chengzhang, param )
	elseif isUseShield == 1 and AutoBuy == 1 then
		MallModel:handle_shopping_2( item_id, 1, item_id_2, 1, upgrade_chengzhang, param)
	else
		upgrade_chengzhang(param)
	end
end

