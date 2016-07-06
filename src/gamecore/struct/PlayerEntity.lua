--PlayerEntity.lua
--create by tjh on 2015-5-4
--玩家实体属性
 PlayerEntity = simple_class()

function PlayerEntity:__init( pack )
	local attri_type  = nil;
	local attri_value = nil
	local value = nil
	local tab = EntityConfig.ACTOR_PROPERTY
	--print("长度",#tab)
	for i = 0, #tab do
		value = tab[i]
		attri_type  = value[1]
	 	attri_value = nil
		if value[2] == "int" then
			attri_value = pack:readInt()
		elseif value[2] == "uint" then
			attri_value = pack:readUInt()
		elseif value[2] == "float" then
			attri_value = pack:readFloat()
		end
		self[attri_type] = attri_value
		--print("^^^^^^^^^=",attri_type,attri_value)
	end	
end