-- NPCStoreConfig.lua
-- created by lyl on 2013-2-1
-- NPC技能配置

-- super_class.NPCStoreConfig()

NPCStoreConfig = {}

-- 获取一个 1：装备   2： 丹药杂货   3：随身商店
function NPCStoreConfig:NPC_store_by_type( npc_type )
	require "../data/npcstore"
    if npcstore[npc_type] then
        return npcstore[npc_type]
    end
end