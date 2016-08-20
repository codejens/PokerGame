-- DreamItemStruct.lua
-- created by fjh on 2012-12-20
-- 梦境物品的信息结构

super_class.DreamItemStruct()

function DreamItemStruct:__init( pack)
	-- 物品id
	self.id = pack:readInt();
	-- 物品数量
	self.count = pack:readInt();

end