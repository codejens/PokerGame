-- MountsConfig.lua
-- created by fjh on 2013-3-27
-- 坐骑系统

-- super_class.MountsConfig()

MountsConfig = {}

function MountsConfig:get_config(  )
	require "../data/std_mount"
	return std_mount
end

function MountsConfig:get_stagesOther_config(  )
	require "../data/std_mount"
	return std_mount.stagesOther;
end

function MountsConfig:get_mount_data_by_id(modelId)
	require "../data/std_mount"
	-- body
	local stages = std_mount["stages"];
	local mount = stages[tonumber(modelId)] ;
	if mount == nil then
		print("There is not this mount: " .. modelId);
	end
	return mount;
end

--升级需要消耗的仙币
function MountsConfig:get_uplevel_cost_by_level( level )
	require "../data/std_mount"

	return std_mount.levelXb[level];
end

function MountsConfig:get_clear_cd_cost_by_level( level )
	require "../data/std_mount"
	
	-- 当前等级的cd时间(单位:分钟) 乘以 每分钟清除需要的元宝数
	return math.ceil( std_mount.levelCD[level] * std_mount.levelCost );
end

-- 坐骑的最高级
function MountsConfig:get_mount_max_level(  )
	require "../data/std_mount"

	return #std_mount.levelXb;
end

-- 获取所有类型的坐骑
function MountsConfig:get_all_mounts_model(  )
	require "../data/std_mount"
	local mount_models = {}
	for i=1, #std_mount.stages do
		local model_id =std_mount.stages[i].modelId

		mount_models[i]=MountsConfig:get_mount_data_by_id(model_id)
	end
	return mount_models
end

-- 获取仙币洗练需要消耗的仙币数
function MountsConfig:get_xianbixilian_price()
	require "../data/std_mount"
	return std_mount["xilianCoin"];
end

-- 获取元宝洗练需要消耗的元宝数
function MountsConfig:get_yuanbaoxilian_price()
	require "../data/std_mount"
	return std_mount["xilianYuanbao"];
end

-- 获取洗炼奖励
function MountsConfig:getXilianAward()
	require "../data/std_mount"
	return std_mount["xilianAward"]
end

-- 获取提升灵犀值的道具ID
function MountsConfig:getLingXiItemId()
	require "../data/std_mount"
	return std_mount["lingxiItem"]
end

-- 获取rate
function MountsConfig:getRate()
	require "../data/std_mount"
	return std_mount["rate"]
end

-- 下面是坐骑属性计算需要的参数，以后如果策划要求服务器改坐骑属性的计算法则，客户端需要同步去改这些参数，
-- 不然显示上和服务器是不一致的。为什么不写在配置表？因为策划懒呗。 note by guozhinan
function MountsConfig:getAttriBase(index)
	-- 属性常数
	local attriBase = {73,11,7,7,4}
	if index then
		return attriBase[index]
	else
		return attriBase
	end
end