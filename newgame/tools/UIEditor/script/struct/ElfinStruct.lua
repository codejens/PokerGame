-- ElfinStruct.lua
-- create by yongrui.liang at 2014-8-29
-- 式神数据结构

super_class.ElfinStruct()

function ElfinStruct:__init( pack )
	self.fight				= pack:readInt()	-- 战力
	self.modelID			= pack:readInt()	-- 模型
	self.level				= pack:readInt()	-- 等级
	self.exp				= pack:readInt()	-- 经验

	self.attr = {}
	for i=1,5 do
		self.attr[i]		= pack:readInt()	-- 五个属性
	end

	self.openItemSlotNum		= pack:readInt()	-- 装备框开启数量
	-- self.itemNum 			= pack:readInt()	-- 装备数量
	self.itemList = {}							-- 装备列表
	for i=1,self.openItemSlotNum do
		self.itemList[i] = {}
		self.itemList[i].itemIndex		= i 				-- 装备框位置
		self.itemList[i].itemCDKey		= pack:readInt()	-- 装备序列号
		self.itemList[i].itemType		= pack:readInt()	-- 装备类型
		self.itemList[i].itemQlty		= pack:readInt()	-- 装备品质
		self.itemList[i].itemLevel		= pack:readInt()	-- 装备等级
		self.itemList[i].itemSmelt		= pack:readInt()	-- 装备熔炼值
		self.itemList[i].itemBaseVal	= pack:readInt()	-- 装备基础属性值
		self.itemList[i].itemLevelVal	= pack:readInt()	-- 装备等级属性值
		self.itemList[i].itemNum 		= pack:readInt()
	end
end