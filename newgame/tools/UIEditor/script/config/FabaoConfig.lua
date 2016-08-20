-- FabaoConfig.lua
-- created by fjh on 2013-5-21
--  法宝配置

FabaoConfig = {};

local  fabao_max_level = 50
local fabao_first_open = 10

function  FabaoConfig:get_fabao_first_open(  )
	return fabao_first_open
end

function  FabaoConfig:get_fabao_max_level(  )
	return fabao_max_level
end
-- 获取器魂配置
-- quality:	器魂品质
-- type:	器魂类型
-- level:	器魂等级
function FabaoConfig:get_xianhun( quality, type, level )
	require "../data/gem_config"
	local s_xianhun = gem_config.GemSoul[quality].types[type];

	local attri;
	local upexp;
	if quality < 3 then 
		attri = {};
		upexp = 0;
		if quality == 2 then
			upexp = 1600;
		end
	else
		attri = s_xianhun.level[level].attrs[1];
		if level < 10 then 
			upexp = s_xianhun.level[level+1].upExp;
		else 
			upexp = 0;
		end
	end

	-- name:器魂名字, baseExp = 基础灵力值, upExp = 升到下一级需要的灵力值， attrs=属性
	local f_xianhun = {name = s_xianhun.name, baseExp = s_xianhun.baseExp, upExp = upexp, attrs = attri};

	return f_xianhun;
end


-- 获取法宝信息配置
-- stage:	法宝的境界
-- level:	法宝等级
function FabaoConfig:get_fabao( stage, level )
	
	require "../data/gem_config"
	local stage = gem_config.States[stage];
	local fabao = {name = stage.gemName, baseAttrs = stage.level[level] };

	return fabao;

end

-- 根据法宝阶级获取法宝的名字
function FabaoConfig:get_fabao_name( stage )
	require "../data/gem_config"

	local stage = gem_config.States[stage];
	return stage.gemName;
end


-- 获取炼魂师的配置
-- lianhunshi_id:	炼魂师id
function FabaoConfig:get_lianhunshi( lianhunshi_id )

	require "../data/gem_config"
	local hunter = gem_config.Hunter[lianhunshi_id];
	return hunter;
	
end


-- 获取法宝的器魂介绍分页的器魂信息
function FabaoConfig:get_xianhun_intro_info(  )
	
	require "../data/gem_config"
	local intro_infos = {};

	intro_infos[1] = gem_config.GemSoul[2].types[1];

	local function fill_intro_infos( quality_ )

		local gem_soul = gem_config.GemSoul[quality_];

		for i=1,#gem_soul.types do
			local soul = gem_soul.types[i];
			
			local soul_dict = { upExp = soul.level[#soul.level].upExp, quality = quality_, type = i, name = soul.name, attrs = soul.level[#soul.level].attrs[1] }
			intro_infos[#intro_infos+1] = soul_dict;
			
		end
	end
	
	for i=1,4 do
		fill_intro_infos(7-i);
	end

	return intro_infos;
end

-- 获取器魂的颜色 
-- 
function FabaoConfig:get_xianhun_color_by_quality( quality )
	if quality == 1 then
		return "#cffffff";
	elseif quality == 2 then
		return "#cff0000";
	elseif quality == 3 then
		return "#c38ff33";
	elseif quality == 4 then
		return "#c00c0ff";
	elseif quality == 5 then
		return "#cff66cc";
	elseif quality == 6 then
		return "#cfff000";
	end
end


-- 获取器魂图片
function FabaoConfig:get_xianhun_icon( data )
	
	local texture_name; 
	if data.quality == 2 then
		texture_name = "icon/gem/00201.pd";
		--texture_name = "icon/gem/00201.png";
	else
		local num = data.quality * 100 + data.type;
		texture_name = "icon/gem/"..string.format("%05d",num)..".pd";
		--texture_name = "icon/gem/"..string.format("%05d",num)..".png";
	end

	return texture_name;

end

