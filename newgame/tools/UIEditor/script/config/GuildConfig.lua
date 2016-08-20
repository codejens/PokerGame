-- GuildConfig.lua
-- created by lyl on 2012-12-10
-- 仙宗配置

-- super_class.GuildConfig()

GuildConfig = {}

-- 获取仙宗某个等级的静态配置。 参数：guild_level  数字：等级
function GuildConfig:get_guild_level_info( guild_level )
	if guild_level == nil then
        guild_level = 1 
	end
	require "../data/guild"
	local if_find = false                  -- 是否找到该等级的信息
	local guild_level_info = nil           -- 返回的仙宗等级信息
	for key, info in pairs( guild.guildLevel ) do
        if info.level == guild_level then
            if_find = true
            guild_level_info = info
            break
        end
	end
	-- 大于20级的，默认返回20级
	if not if_find then
        guild_level_info = guild.guildLevel[10]
	end
	return guild_level_info
end

-- 获取领取福利需要的消耗
function GuildConfig:get_weal_contrib(  )
	require "../data/guild"
	return guild.weal_contrib
end

-- 获取仙宗领地  场景名称  npc名称
function GuildConfig:get_guild_manor(  )
	require "../data/guild"
	return guild.manor.sceneName, guild.manor.entityName
end

-- 获取仙宗人物npc  场景名称 npc名称
function GuildConfig:get_guild_questNPC(  )
	require "../data/guild"
	return guild.questNPC.sceneName, guild.questNPC.entityName
end

-- 获取仙宗商店列表
function GuildConfig:get_guild_store(  )
	require "../data/guild"
	return guild.store
end

-- 获取聚仙1元宝可得到的仙宗贡献
function GuildConfig:get_contirbutionRatio(  )
	return guild.contirbutionRatio
end

--取得灵珠经验
function GuildConfig:get_altar_gem_index_exp(index)
	require "../data/guild"
	return guild.upEggExp[index]
end

--取得抚摸次数
function GuildConfig:get_altar_touch_max_num()
	require "../data/guild"
	return guild.totalTouch
end

function GuildConfig:get_altar_change_page_info()
	require "../data/guild"
	return { max_index = #guild.upEggExp, max_exp = guild.upEggExp[#guild.upEggExp] }
end

function GuildConfig:get_pet_index_info(index)
	require "../data/guild"
	return guild.ssLevels[index]
end

function GuildConfig:get_ji_tan_level_stept()
	require "../data/guild"
	return guild.ssLevelLimit
end

function GuildConfig:get_max_xian_guo_num()
	require "../data/guild"
	return guild.totalXianGuo
end

function GuildConfig:get_altar_find_xian_guo_money()
	require "../data/guild"
	return guild.xianGuoBackMoney
end

function GuildConfig:get_xian_guo_exp()
	require "../data/guild"
	return guild.xianGuoExp
end

function GuildConfig:get_xian_guo_renown()
	require "../data/guild"
	return guild.xianGuoRenown
end

function GuildConfig:get_xian_guo_money()
	require "../data/guild"
	return guild.xianGuoMoney
end

function GuildConfig:get_xian_guo_money_type()
	require "../data/guild"
	return guild.xianGuoMoneyType
end

function GuildConfig:get_yuanbao_lingshi_rate()
	require "../data/guild"
	return guild.stoneRatio
end

function  GuildConfig:get_xian_guo_name( index )
	require "../data/guild"
	return guild.animalFoodName[index]
end