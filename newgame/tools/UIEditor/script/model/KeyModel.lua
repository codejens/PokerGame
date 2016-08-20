-- KeyModel.lua
-- created by hcl on 2013-4-23
-- 快捷键数据管理

KeyModel = {}

-- 保存KeyStruct的table
local key_struct_table = {};

-- added by aXIng on 2013-5-25
function KeyModel:fini( ... )
	key_struct_table = {};
end

function KeyModel:set_key_table( _keyStruct_table)
	key_struct_table = _keyStruct_table;
end

function KeyModel:get_key_table()
	return key_struct_table;
end