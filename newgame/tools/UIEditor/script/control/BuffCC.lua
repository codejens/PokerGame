-- BuffCC.lua
-- created by fjh on 2013-3-13
-- buff系统


BuffCC = {}

--服务器下发 添加一个buff
-- s->c 4,1
function BuffCC:do_add_buff( pack )

	-- edited by aXing on 2013-4-12
	-- 修改buff数据结果读取顺序，把作用哪个实体的放在外部读取
	-- require "struct/BuffStruct"
	local handler	= pack:readInt64()
	local buff_data = BuffStruct(pack)
	BuffModel:add_time_by_type(buff_data.buff_type, buff_data.buff_group)
	-- 潜规则，78的buff不显示,92连斩buff不显示
	if ( buff_data.buff_type == 78 ) then
		return;
	end

	local entity = EntityManager:get_entity(handler)
	-- print(" BuffCC:do_add_buff::::entity.type === ",entity.type,"entity.name ==",entity.name);
	if entity then
		entity:add_buff(buff_data)
	end
	
end

-- 删除一个buff
function BuffCC:do_delete_buff( pack )
	local handler    = pack:readInt64()
	local buff_type  = pack:readByte()
	local buff_group = pack:readByte()
	
	-- 潜规则，78的buff不显示
	if ( buff_type == 78 ) then
		return;
	end

	if ( buff_type == 95 or buff_type == 96 or buff_type == 97 ) then
		-- 阵营战buff
		CampBattleModel:do_dele_camp_battle_buff( buff_type );
	end

--	print("[BuffCC:30] 删除一个buff buff_type,buff_group", buff_type,buff_group)
	local entity = EntityManager:get_entity(handler)
	if entity then
		entity:remove_buff( buff_type, buff_group )
		BuffModel:remove_time_by_type(buff_type)
	end
end

-- 删除一类buff
function BuffCC:do_delete_buff_type( pack )
	local handler    = pack:readInt64()
	local buff_type  = pack:readByte()

--	print("[BuffCC:39] 删除一类的buff buff_group=", buff_group)
	local entity = EntityManager:get_entity(handler)
	if entity then
		entity:remove_buff(buff_type)
		BuffModel:remove_time_by_type(buff_type)
	end
end

-- 初始化buff
function BuffCC:do_init_buff( pack )
	local player = EntityManager:get_player_avatar()
	local count = pack:readByte()
	for i=1,count do
		local buff = BuffStruct(pack)
		BuffModel:add_time_by_type(buff.buff_type, buff.buff_group)
		player:add_buff(buff)
	end
end