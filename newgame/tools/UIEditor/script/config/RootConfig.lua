-- RootConfig.lua
-- create by hcl on 2012-12-26
-- 灵根系统 config

-- super_class.RootConfig();
RootConfig = {}

function RootConfig:get_info_by_level(level)
	require "../data/roots"
	local page = math.floor(level/8) + 1;
	local page_level = level % 8 + 1;
	local tab = roots[page].root[page_level];
	-- 返回第一个是灵根名称，第二个是消耗灵气，第三个是消耗金钱
	return roots[page].name .."·"..tab.name,self:get_str_by_num(tab.attri.type),tab.attri.value,tab.expr,tab.coin;
end

function RootConfig:get_page_attr( page_index )
	require "../data/roots"
	-- print("RootConfig:get_page_attr( page_index )",page_index)
	return roots[page_index].root
end

function RootConfig:get_str_by_num(type)
	if(type == 27) then
		return LangGameString[2365]; -- [25]="攻击"
	elseif(type == 33) then
		return LangGameString[2366]; -- [338]="精神防御"
	elseif(type == 17) then
		return LangGameString[2367]; -- [23]="生命"
	elseif(type == 35) then
		return LangGameString[2368]; -- [34]="暴击"
	elseif(type == 23) then
		return LangGameString[2369]; -- [339]="物理防御"
	elseif(type == 25) then
		return LangGameString[2370]; -- [27]="抗暴击"
	elseif(type == 39) then
		return LangGameString[2371]; -- [36]="命中"
	elseif(type == 37) then
		return LangGameString[2372]; -- [35]="闪避"
	end
end

function RootConfig:get_lg_info_by_index(page_index, level_index)
	require "../data/roots"
	print("page_index, level_index",page_index, level_index)
	if level_index == 0 then
		page_index = page_index - 1
		if page_index == 0 then
			page_index = 1
			level_index = 1
		else
			level_index = #roots[page_index].root
		end
		print("page_index, level_index",page_index, level_index)
	end
	local info = roots[page_index].root[level_index]
	return roots[page_index].name .. "." .. info.name
end
