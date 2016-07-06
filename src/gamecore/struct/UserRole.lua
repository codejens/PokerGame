-- UserRole.lua
-- created by aXing on 2012-11-30
-- 角色模型数据结构

UserRole=simple_class()

function UserRole:__init( pack )
	if pack ~= nil then
		self.id		= pack:readInt()				-- 角色id
		self.name	= pack:readString()				-- 名字
		self.icon	= pack:readByte()				-- 头像index
		self.sex	= pack:readByte()				-- 性别
		self.level	= pack:readByte()				-- 等级
		self.job	= pack:readByte()				-- 职业
		self.camp	= pack:readByte()				-- 阵营
	end
end