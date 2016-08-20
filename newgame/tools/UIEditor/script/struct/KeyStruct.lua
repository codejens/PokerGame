-- KeyStruct.lua
-- created by hcl on 2013-4-23
-- 快捷键

super_class.KeyStruct()

function KeyStruct:__init( pack )
	if ( pack ) then
		self.key_index = pack:readByte();		-- 快捷键编号
		self.key_type = pack:readByte();		-- 快捷键内容类型 1,技能2物品
		self.key_value = pack:readWord();		-- 内容
		--print("self.key_index,self.key_type,self.key_value",self.key_index,self.key_type,self.key_value)
	end
end