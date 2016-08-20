-- SXModel.lua
-- create by hcl on 2013-2-16
-- 双修model,用于管理附近双修玩家的信息
--print("-----------------------require sxModel----------------------------")
-- super_class.SXModel()
SXModel = {}

local can_invite_shuangxiu_player_table = {};
local invite_shuangxiu_player_table = {};

-- added by aXing on 2013-5-25
function SXModel:fini( ... )
	can_invite_shuangxiu_player_table = {};
	invite_shuangxiu_player_table = {};
end

-- 设置附近能够双修的玩家的数据列表
function SXModel:set_can_invite_shuangxiu_player_table(table)
	can_invite_shuangxiu_player_table = table;
end

-- 取得附近能够双修的玩家的数据列表
function SXModel:get_can_invite_shuangxiu_player_table()
	return can_invite_shuangxiu_player_table ;
end

-- 删除一个邀请双修的玩家数据
function SXModel:remove_can_invite_shuangxiu_player_table( index )
	table.remove(can_invite_shuangxiu_player_table,index);
end

-- 取得所有邀请双修的玩家数据
function SXModel:get_invite_shuangxiu_player_table()
	return invite_shuangxiu_player_table;
end

-- 添加一个邀请双修的玩家数据
function SXModel:add_invite_shuangxiu_player_table( struct )
	-- 过滤掉重复的
	for i=1,#invite_shuangxiu_player_table do
		if ( struct.name == invite_shuangxiu_player_table[i].name ) then
			return;
		end
	end
	invite_shuangxiu_player_table[#invite_shuangxiu_player_table + 1] = struct ;
end

-- 删除一个邀请双修的玩家数据
function SXModel:remove_invite_shuangxiu_player_table( index )
	table.remove(invite_shuangxiu_player_table,index);
end