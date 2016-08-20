-- FubenConfig.lua
-- created by lyl on 2013-2-21
-- 副本配置

-- super_class.FubenConfig()

FubenConfig = {}

-- 根据副本的id，获取副本的配置信息
function FubenConfig:get_fuben_info_by_id( fuben_id )
	require "../data/std_fuben"
	return std_fuben[fuben_id]
end

function FubenConfig:get_vip_detail_by_level( level )
	require "../data/vipconfig"
	return vipconfig[level]	
end

function FubenConfig:get_fuben_by_name(name)
	if self.fbdict == nil  then
		require "../data/std_fuben"
		self.fbdict = {}
		for i,v in ipairs(std_fuben) do
			self.fbdict[v.fbname] = v
		end
	end
	return self.fbdict[name]
end

function FubenConfig:get_subfubenlist_by_fatherid(fatherId)
	-- print("FubenConfig:get_subfubenlist_by_fatherid(fatherid)",fatherid)
	require "../data/fuben_count_config"
	if fuben_count_config[fatherId-1]~=nil then
		return fuben_count_config[fatherId-1]
	end	
end

function FubenConfig:get_cost_by_fubenId(fubenId)
	require "../data/fuben_addCountMoney"
	return fuben_addCountMoney[fubenId] 
end

function FubenConfig:get_cost_by_listId(listId)
	require "../data/fuben_addCountMoney"
	return fuben_addCountMoney[listId] 
end

function FubenConfig:get_baguadigong_config( )
	require "../data/baguadigong_config"
	return baguadigong
end

function FubenConfig:get_baguadigong_npc_name( )
	require "../data/baguadigong_config"
	return baguadigong.map_npc_name
end

function FubenConfig:get_baguadigong_boss_tile( )
	require "../data/baguadigong_config"
	return baguadigong.boss.tile_x, baguadigong.boss.tile_y
end

-- 获取副本通关固定奖励
function FubenConfig:get_fix_award_by_fubenId(fubenId)
	require "../data/fubenconfig"
	for i=1,#fubenconfig do
		if fubenconfig[i].fbid == fubenId then
			return fubenconfig[i].reward
		end 
	end
end

-- 获取副本通关评级奖励
function FubenConfig:get_grade_award_by_fubenId(fubenId,grade)
	require "../data/fubenconfig"
	for i=1,#fubenconfig do
		if fubenconfig[i].fbid == fubenId then
			local mod = fubenconfig[i].gradelist[grade].mod
			local count = fubenconfig[i].gradereward[1].count
			local ret_award = {}
			ret_award.count = mod * count
			ret_award.type = fubenconfig[i].gradereward[1].type
			return ret_award
		end 
	end
end