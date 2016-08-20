-- MonsterConfig.lua
-- create by hcl on 2013-1-18
-- 怪兽系统 config

-- super_class.MonsterConfig();

MonsterConfig = {}

function MonsterConfig:get_monster_by_id(entityid )
	require "../data/monster"
	return monster[entityid];
end