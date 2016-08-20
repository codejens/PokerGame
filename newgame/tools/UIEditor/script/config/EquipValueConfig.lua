-- EquipValueConfig.lua
-- created by lyl on 2013-1-15
-- 装备值配置文件

-- super_class.EquipValueConfig()

EquipValueConfig = {}

-- 根据type获取 计算系数
function EquipValueConfig:get_calculate_factor( type )
	require "../data/equip_value"	
	for i = 1, #equip_value do
        if equip_value[i].attrId == type then
            return equip_value[i].unitVal
        end
	end
end
