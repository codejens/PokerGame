-- MarriageConfig.lua
-- created by fjh on 2013-8-21
-- 结婚系统配置
MarriageConfig = {}

-- 获取升级戒指所需要的情意值
function MarriageConfig:get_need_qy_for_uplevel( ring_id, ring_level )
	
	require "../data/marryconfig"
	local index = ring_id - 11100;
	if ring_level == 0 then
		return 0;
	end
	return marryconfig.ringQY[index][ring_level];

end

-- 获取某个红心的等级属性
function MarriageConfig:get_little_heart_attr_by_level( heart_index, heart_level )
	require "../data/marryconfig"
	print("获取某个红心的等级属性",heart_index, heart_level );
	local hearts = marryconfig.marryXY[heart_level].root;
	local heart = hearts[heart_index];
	return heart;
end

-- 获取仙缘等级的属性加成
function MarriageConfig:get_XY_attr_by_level( XY_level )
	require "../data/marryconfig"
	
	local root = marryconfig.marryXY[XY_level].root;
	local xy_attr = root[10].attri1;
	return xy_attr;
end

-- 获取仙缘等级的名字
function MarriageConfig:get_XY_name_by_level( XY_level )
	local name_list = { LangGameString[107], LangGameString[108], LangGameString[109], LangGameString[110], LangGameString[111], LangGameString[112], LangGameString[113], LangGameString[114], LangGameString[115] }; -- [107]="亲密无间" -- [108]="心心相印" -- [109]="相敬如宾" -- [110]="相濡以沫" -- [111]="一心一意" -- [112]="不离不弃" -- [113]="刻骨铭心" -- [114]="一世情缘" -- [115]="三生相守"
	if XY_level == 0 then
		XY_level = 1;
	end
	return name_list[XY_level];
end
