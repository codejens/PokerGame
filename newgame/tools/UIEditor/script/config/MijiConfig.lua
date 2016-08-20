-- MijiConfig.lua
-- created by tjh on 2014-6-3
-- 秘籍配置
--require "../data/miji_src_data"
MijiConfig = {}

--记录所有秘籍，分类
local skill_table = {}
local prefix = "../data/"
local data_name = "miji_src_data"
--重对应的索引 
local _cheng_index = {1,2,4,7,11,16,22,29,37}
--读取item表
local function load_miji_config( miji_id )
	--获取主index
	local index = math.floor(miji_id / 10)			-- 这个步长是根据拆分文件大小少于100kb来划分的，
													-- 如果需要改这个步长，则必须把打包文件也一齐修改了
	--检索读过没有
	local config = skill_table[index]
	--读取
	if not config then
		local config_index = data_name .. index
		local file = prefix .. config_index
		require(file)
		--从全局表检索
		config = _G[config_index]
		--记录
		skill_table[index] = config
	end
	return config[miji_id]
end


function MijiConfig:get_miji_by_skill_id( skill_id )
	require "../data/miji_config"
	return miji_config.skill_miji[skill_id].mijiId
end

--根据秘籍当前经验获取等级 及最大经验
function MijiConfig:get_miji_level( exp ,pz)
	require "../data/miji_config"
	local expdate =  miji_config.miji_exp[pz]
	for i=1,#expdate do
		if expdate[i] > exp then
			return i,expdate[i]
		end
	end
	return 99,expdate[98]
end

--根据秘籍ID取对应的技能ID
function MijiConfig:get_skill_id_by_miji_id( miji_id )
	require "../data/miji_config"
	local miji_date = miji_config.skill_miji
	for i=1,#miji_date do
		for j=1,#miji_date[i].mijiId  do
			if miji_date[i].mijiId[j] == miji_id then
				return miji_date[i].skillId
			end
		end
	end
end

--获取描述秘籍属性 
function MijiConfig:get_miji_dest_value_by_id( item_id,level,chong,ceng)
	--require "../data/miji_src_data"
	local mijiDate = load_miji_config( item_id )
	--miji_src_data[item_id]

	local attr_type = nil
	local attr_value = 1
	local value_table = {}
	local basics_attr_type = nil
	if mijiDate then
			local value = mijiDate.basics[level].attrs[1].value
			if value.rate and value.rate > 0 then
				table.insert( value_table,value.rate/100)
			else
				if mijiDate.basics[level].attrs[2] and mijiDate.basics[level].attrs[2].value then
					local value2 = mijiDate.basics[level].attrs[2].value
					if value2.value and value2.value > 0 then
						table.insert( value_table,value2.value/100)
					end
				end
			end
			local attr_id = mijiDate.basics[level].attrs[1].value.id 
			--print("--获取描述秘籍属性 ",attr_id)
			if attr_id then
				basics_attr_type = attr_id
			end
			table.insert( value_table,math.abs(value.value))
			local extras_all = mijiDate.extras
			if extras_all then --顶级秘籍
				local index = MijiConfig:get_index_by_chong_ceng( chong,ceng )
				--print("--顶级秘籍",chong,ceng,index)
				local extras = extras_all[index]
				 attr_type = extras.attrs[1].attrtype
				 attr_value = extras.attrs[1].attrvalue
				value_table = MijiConfig:get_diji_miji_value( extras,value_table )
			end
			return  value_table,attr_type,attr_value,basics_attr_type

	end
end


--计算索引
function MijiConfig:get_index_by_chong_ceng( chong,ceng )

	local index = _cheng_index[chong] + ceng
	return index
end
--分析顶级秘籍属性
function MijiConfig:get_diji_miji_value( extras,value_table )
	local xl_value = extras.attrs[1].attrvalue --修炼属性
	table.insert( value_table,math.abs(xl_value) )
	local actions =  extras.actions

	for i=1,#actions do
		local addtype =  actions[i].tp
		local value = 1
		if addtype == 2 then --buff

			if actions[i].prop   then
				local prop =  math.abs(actions[i].prop)
				if  prop < 1 then
					value = actions[i].prop *100
				elseif prop > 100 then
					value = prop/100
				end
				table.insert( value_table,value )
			end
			if  actions[i].revattrvalue then

				value = math.abs(actions[i].revattrvalue)
				if value < 1 then
					value= value*100 
				elseif value < 100 then
					value = value
				end
				table.insert( value_table,math.abs(value) )
			end
			if actions[i].attrvalue then
				value = math.abs(actions[i].attrvalue)
				if value < 1 then
					value= value*100 
				elseif value < 100 then
					value = value
				end
				table.insert( value_table,math.abs(value) )
			end
			if actions[i].interval then
				value = math.abs(actions[i].interval)
				table.insert( value_table,value )
			end
		elseif addtype == 3 then --time
			value = actions[i].value
			table.insert( value_table,math.abs(value) )
		elseif addtype == 4 or addtype == 9 then
			value = actions[i].rate/100
			table.insert( value_table,math.abs(value) )
		elseif addtype == 5 then
			value = actions[i].interval
			table.insert( value_table,math.abs(value) )
		elseif addtype == 6 then
			value = actions[i].attrvalue
			table.insert( value_table,math.abs(value) )
		end
	end
	return value_table
end

--获取秘籍战力
function MijiConfig:get_miji_fight( id,level)
		require "../data/miji_score_data"
		return miji_score_data[id].levelScore[level]
end
--获取橙色秘籍重加成战力
function MijiConfig:get_orange_miji_fight( id,xianlian_value)
		require "../data/miji_score_data"
		return miji_score_data[id].tupleScore[xianlian_value+1]
end

--根据秘籍品阶和等级获取需要的经验值
function MijiConfig:get_miji_exp( level ,pz)
	require "../data/miji_config"
	local expdate =  miji_config.miji_exp[pz]
	return expdate[level];
end