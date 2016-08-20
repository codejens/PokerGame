-- DropItemCC.lua
-- created by aXing on 2013-2-25
-- 拾取子系统

-- super_class.DropItemCC()

DropItemCC  = {}

-- 拾取掉落物品
function DropItemCC:req_pick_up_drop_item( handle )
	local pack = NetManager:get_socket():alloc(15, 1)
	pack:writeUint64(handle)
	NetManager:get_socket():SendToSrv(pack)
end

-- 掉落物品出现
function DropItemCC:do_drop_item_appear( pack )
	local handler 		= pack:readUint64()			-- 实体handler
	local x 			= pack:readInt()			-- 实体世界坐标x
	local y 			= pack:readInt()			-- 实体世界坐标y
	local monster_id	= pack:readInt()			-- 怪物id，哪只怪物掉落的
	local killer_id		= pack:readInt()			-- 玩家id
	local team_id		= pack:readUInt()			-- 队伍id
	local item_id 		= pack:readInt()			-- 物品id
	local money_type	= pack:readInt()			-- 金钱类型，如果物品id不为0，这个字段没意义，不过客户端还是要读
	local count			= pack:readInt()			-- 物品或者金币数量
	local time			= pack:readInt()			-- 变成自由状态剩余的时间（单位秒），如果是0，表示已经是自由状态了

	local new_entity	= EntityManager:create_entity(handler, "DropItem")
	-- 通知引擎创建实体
	local model = ZXEntityMgr:sharedManager():createEntity(handler, ZX_ENTITY_DROP_ITEM, x, y, 0, 0, 0)
	new_entity:change_entity_attri("model", model)
	print("创建掉落物品", x, y)

	new_entity:change_entity_attri("x", x)
	new_entity:change_entity_attri("y", y)
	new_entity:change_entity_attri("monster_id", monster_id)
	new_entity:change_entity_attri("killer_id", killer_id)
	new_entity:change_entity_attri("team_id", team_id)
	new_entity:change_entity_attri("item_id", item_id)
	new_entity:change_entity_attri("money_type", money_type)
	new_entity:change_entity_attri("count", count)
	new_entity:change_entity_attri("time", time)
	new_entity:change_entity_attri("type",ZX_ENTITY_DROP_ITEM)

end

-- 掉落物品消失
function DropItemCC:do_drop_item_disappear( pack )
	local handler = pack:readUint64()			-- 实体handler
	EntityManager:destroy_entity(handler)
end