-- DreamlandModel.lua
-- created by fjh on 2012-12-20
-- 梦境信息模型 动态数据

-- super_class.DreamlandModel()
DreamlandModel = {}

DreamlandModel.DREAMLAND_TYPE_XY = 1; 			--星蕴梦境
DreamlandModel.DREAMLAND_TYPE_YH = 2;			--月华梦境
DreamlandModel.DREAMLAND_TYPE_TBS = 3;			--淘宝树
DreamlandModel.DREAMLAND_TYPE_JBD = 4;			--聚宝袋
DreamlandModel.DREAMLAND_TYPE_RY = 5;			--日曜梦境

local _dreamland_item_table	 	= {};			--探宝的物品表
local _dreamland_zhenpin_table 	= {};			--珍品记录表
local _dreamland_cangku_table 	= {};			--仓库列表

local _dreamland_type = 1;						--默认的梦境类型是星蕴1,月华为2,
local _dreamland_tanbao_count = 0;				--探宝次数
local _dreamland_free_count = 0					--阿房废墟
-- added by aXing on 2013-5-25
function DreamlandModel:fini( ... )
	_dreamland_item_table	 	= {};			--探宝的物品表
	_dreamland_zhenpin_table 	= {};			--珍品记录表
	_dreamland_cangku_table 	= {};			--仓库列表
	_dreamland_type = 1;						--默认的梦境类型是星蕴1,月华为2
	_dreamland_tanbao_count = 0;				--探宝次数
end

---------------------------------------------
--插入一个探宝物品
function DreamlandModel:add_item( item  )
	_dreamland_item_table[#_dreamland_item_table+1] = item;
end
--获取探宝物品表
function DreamlandModel:get_item_table( )
	-- body
	return _dreamland_item_table;
end
--设置探宝物品表
function DreamlandModel:set_item_table( table )
	DreamlandModel:clear_item_table();
	_dreamland_item_table = table;
end
--获取探宝物品表的大小
function DreamlandModel:get_item_table_size( )
	return #_dreamland_item_table;
end
--清空探宝物品表
function DreamlandModel:clear_item_table( )
	-- body
	if #_dreamland_item_table ~= 0 then
		for k in pairs(_dreamland_item_table) do
			_dreamland_item_table[k] = nil;
		end
	end
end
-- 进行排序。相同id的物品进行合并，数量叠加
function DreamlandModel:table_sort( old_table )
	-- body
	local new_table = {};
	for i=1,#old_table do
		
		local i_item = old_table[i];
		--遍历旧表中的节点，把相同id的物品数量进行累加
		for j=i+1,#old_table do
			local j_item = old_table[j];
			if i_item.id == j_item.id then
				i_item.count = i_item.count+1;
			end
		end
		-- 判断当前这个节点在新表中是否重复(新表中是不应该出现重复项的)
		local is_repeat = false;
		for k,v in pairs(new_table) do
			if v.id == i_item.id then
				is_repeat = true;
			end
		end
		--如果不重复就插入到新表中去
		if is_repeat == false then
			new_table[#new_table+1] = i_item;
		end

	end
	return new_table;
end

--- 获得当前梦境对应的结晶
function DreamlandModel:get_current_crystal(  )

	if _dreamland_type == DreamlandModel.DREAMLAND_TYPE_XY then
		return 18606;
	elseif _dreamland_type == DreamlandModel.DREAMLAND_TYPE_YH then
		return 18607;
	elseif _dreamland_type == DreamlandModel.DREAMLAND_TYPE_TBS then
		return 44488;
	elseif _dreamland_type == DreamlandModel.DREAMLAND_TYPE_JBD then
		return 44488;
	end
end

--------------------------------------------

--插入一个珍品记录
function DreamlandModel:add_zhenpin( key, value )
	_dreamland_zhenpin_table[key] = value;
end
--获取一个珍品列表
function DreamlandModel:get_zhenpin_table( )
	return _dreamland_zhenpin_table;
end
-- 清空珍品列表
function DreamlandModel:clear_zhenpin_table( )
	if #_dreamland_zhenpin_table ~= 0 then
		for k in pairs(_dreamland_zhenpin_table) do
			_dreamland_zhenpin_table[k] = nil;
		end
	end
end

--------------------------------------------
--往仓库列表插入一个物品
function DreamlandModel:add_cangku_item( key, value )
	_dreamland_cangku_table[key] = value;
end
-- 往仓库列表末尾加一个物品
function DreamlandModel:add_cangku_item_end( item )
	_dreamland_cangku_table[#_dreamland_cangku_table+1] = item;
end
-- 删除仓库某个物品
function DreamlandModel:remove_cangku_item_by_GUID( guid )
	-- body
	for i,v in ipairs(_dreamland_cangku_table) do
		if v.series == guid then
			table.remove(_dreamland_cangku_table,i);
		end
	end
end

function DreamlandModel:get_item_in_cangku_by_index( index )
	if #_dreamland_cangku_table ~= 0 then
		return _dreamland_cangku_table[index];
	end
end

--获取仓库列表
function DreamlandModel:get_cangku_table( )
	-- body
	return _dreamland_cangku_table;
end
--清空仓库列表
function DreamlandModel:clear_cangku_table( )
	-- if #_dreamland_cangku_table ~= 0 then
	-- 	for i=1,#_dreamland_cangku_table do
	-- 		table.remove(_dreamland_cangku_table);
	-- 	end
	-- end
	_dreamland_cangku_table = {}
end

function DreamlandModel:move_item_to_package( item_guid )
	local count = 1
	if item_guid == 0 then --0:代表着要取出所有的物品
		count = #DreamlandModel:get_cangku_table();
	end

	--背包的空格数量，这里应该去调背包的model数据
	local package_count = ItemModel:get_bag_space_gird_count(  ); 
	if package_count >= count then
		DreamlandCC:request_moveItem_to_package(item_guid)
	else
		GlobalFunc:create_screen_notic( "背包空间不足" )
	end
end

--------------------------------------------
--设置梦境类型
function DreamlandModel:set_dreamland_type( type )
	_dreamland_type = type;
end
--获取梦境类型
function DreamlandModel:get_dreamland_type( )
	-- body
	return _dreamland_type;
end
--------------------------------------------
--设置探宝次数
function DreamlandModel:set_tanbao_count( count )
	_dreamland_tanbao_count = count;
end
--获取探宝次数
function DreamlandModel:get_tanbao_count( )
	-- body
	return _dreamland_tanbao_count;
end


----------------------网络请求

-- 免费次数
function DreamlandModel:req_free_count()
    print("请求免费次数")
	DreamlandCC:req_free_count()
end

function DreamlandModel:do_get_count( count )
	print("更新免费次数")
	local win = UIManager:find_visible_window("new_dreamland_win")
	if win then
		win:change_free_tips(count)
	end
	_dreamland_free_count = count
end
-- 探宝请求
function DreamlandModel:req_tao_bao( tan_bao_count )

	--探宝需要的元宝
	local need_yuanbao = 10;
	local option_id = 1;
	if tan_bao_count == 1 then
		need_yuanbao = 10;
		option_id = 1;
	elseif tan_bao_count == 10 then
		need_yuanbao = 90;
		option_id = 2;
	elseif tan_bao_count == 50 then
		need_yuanbao = 450;
		option_id = 3;
	end

	--主角的元宝数
	local avatar = EntityManager:get_player_avatar();

	local yuanbao = avatar.yuanbao;
	--主角的梦境结晶数
	local crystal_id = DreamlandModel:get_current_crystal()
	local crystal_count = ItemModel:get_item_count_by_id( crystal_id );
	
	MallModel:set_only_use_yb(true)
	local money_type = MallModel:get_only_use_yb(  ) and 3 or 2

	if _dreamland_type == DreamlandModel.DREAMLAND_TYPE_TBS then
		-- 如果是淘宝树探宝的话，走另外的协议
		-- if yuanbao >= need_yuanbao or crystal_count > 0 then
		-- 	DreamlandModel:set_tanbao_count(tan_bao_count);
		-- 	DreamlandCC:req_taobao_tree_tan_bao(1, option_id,money_type);
		-- else
		-- 	--元宝不足，弹出警告框
		-- 	GlobalFunc:create_screen_notic( LangModelString[62] ) -- [62]="亲，您的元宝不足！"
		-- end

		local price = need_yuanbao
		local param = {tan_bao_count, 1, option_id, money_type}
		local tanbao_func = function( param )
			DreamlandModel:set_tanbao_count(param[1]);
			DreamlandCC:req_taobao_tree_tan_bao(param[2], param[3], param[4]);
			GlobalFunc:create_screen_notic(Lang.dreamland.get_awards)
		end

		if option_id == 1 and crystal_count > 0 then
			DreamlandModel:set_tanbao_count(tan_bao_count);
			DreamlandCC:req_taobao_tree_tan_bao(1, option_id, money_type);
			GlobalFunc:create_screen_notic(Lang.dreamland.get_awards)
		else
			MallModel:handle_auto_buy( price, tanbao_func, param )
		end

	elseif _dreamland_type == DreamlandModel.DREAMLAND_TYPE_YH or _dreamland_type == DreamlandModel.DREAMLAND_TYPE_XY then-- 1星蕴梦境  2月华
		-- --dreamland_type:星蕴梦境为1，月华为2，而元宝的花费刚好是2倍
		-- if yuanbao >= need_yuanbao * _dreamland_type or crystal_count > 0 then
		-- 	DreamlandModel:set_tanbao_count(tan_bao_count);
		-- 	DreamlandCC:request_tanbao(DreamlandModel:get_dreamland_type(),option_id);
		-- else
		-- 	--元宝不足，弹出警告框
		-- 	GlobalFunc:create_screen_notic( LangModelString[62] ) -- [62]="亲，您的元宝不足！"
		-- end
		
		local price = need_yuanbao * _dreamland_type
		local param = {tan_bao_count, DreamlandModel:get_dreamland_type(), option_id, money_type}
		local tanbao_func = function( param )
			DreamlandModel:set_tanbao_count(param[1]);
			DreamlandCC:request_tanbao(param[2], param[3], param[4]);
			-- 重新获取免费次数
			DreamlandModel:req_free_count()
			GlobalFunc:create_screen_notic(Lang.dreamland.get_awards)
		end

		if option_id == 1 and ( _dreamland_type == DreamlandModel.DREAMLAND_TYPE_XY and _dreamland_free_count > 0 or crystal_count > 0)then
			DreamlandModel:set_tanbao_count(tan_bao_count);
			DreamlandCC:request_tanbao(DreamlandModel:get_dreamland_type(), option_id, money_type);
			-- 重新获取免费次数
			DreamlandModel:req_free_count()
			GlobalFunc:create_screen_notic(Lang.dreamland.get_awards)
		else
			MallModel:handle_auto_buy( price, tanbao_func, param )
		end

	elseif _dreamland_type == DreamlandModel.DREAMLAND_TYPE_JBD then
		-- --dreamland_type:聚宝袋		
		-- if yuanbao >= need_yuanbao  or crystal_count > 0 then
		-- 	DreamlandModel:set_tanbao_count(tan_bao_count);
		-- 	DreamlandCC:req_taobao_tree_tan_bao(3,option_id);
		-- else
		-- 	--元宝不足，弹出警告框
		-- 	GlobalFunc:create_screen_notic( LangModelString[62] ) -- [62]="亲，您的元宝不足！"
		-- end

		local price = need_yuanbao
		local param = {tan_bao_count, 3, option_id, money_type}
		local tanbao_func = function( param )
			DreamlandModel:set_tanbao_count(param[1]);
			DreamlandCC:req_taobao_tree_tan_bao(param[2], param[3], param[4]);
		end

		if option_id == 1 and crystal_count > 0 then
			DreamlandModel:set_tanbao_count(tan_bao_count);
			DreamlandCC:req_taobao_tree_tan_bao(3, option_id, money_type);
		else
			MallModel:handle_auto_buy( price, tanbao_func, param )
		end

	end
end

--获取珍品列表请求
function DreamlandModel:req_zhenpin_jilu(  )
	DreamlandModel:clear_zhenpin_table();
	if _dreamland_type == DreamlandModel.DREAMLAND_TYPE_TBS then
		--如果是淘宝树，另外处理
		DreamlandCC:req_taobao_tree_zhenpin()
	else
		DreamlandCC:request_zhenpin_jilu();
	end

end 

function DreamlandModel:update_bindYb( )
	local win = UIManager:find_visible_window("new_dreamland_win")
	if win then
		win:update_bindYuanbao()
	end
end

--更新元宝
function DreamlandModel:update_yuanbao( )
	local win = UIManager:find_visible_window("new_dreamland_win")
	if win then
		win:update_yuanbao()
	end
end
