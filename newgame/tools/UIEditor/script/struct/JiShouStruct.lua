----JiShouCC.lua
----HJH
----2013-7-25
----
-- 寄售个人物品
--------------------------------------
super_class.JiShouStruct()
--------------------------------------
function JiShouStruct:__init(pack)
	self.type = pack:readInt() 				--寄卖的是物品还是金钱，0 是物品，1是金钱，则根据不同值读下面两个不同的数
	if self.type == 1 then
		self.sell_money = pack:readInt()		--寄卖的金钱数量
		self.sell_money_type = pack:readInt()	--金钱类型
	else
		self.bag_item = UserItem(pack)			--和获取背包数据接口一样
	end
	self.reset_time = pack:readInt()		--剩余时间，单位是秒， 0表示已过期
	self.reset_time = self.reset_time + os.time()
	self.money_type = pack:readByte()		--钱的类型，1是银两，3是非绑定元宝
	self.price = pack:readInt()				--出卖的价钱
	self.handle = pack:readUInt()			--后面3个是扩展字段 
	-- print("self.type,self.reset_time, self.money_type,self.price,self.handle",self.type,self.reset_time, self.money_type,self.price,self.handle)
end
----寄售搜索物品
--------------------------------------
super_class.JiShouSerchStruct()
--------------------------------------
function JiShouSerchStruct:__init(pack)
	self.type = pack:readInt() 				--寄卖的是物品还是金钱，0 是物品，1是金钱，则根据不同值读下面两个不同的数
	print("self.type",self.type)
	if self.type == 1 then
		self.send_money = pack:readInt()		--寄卖的金钱数量
		self.send_money_type = pack:readInt()	--金钱类型
		print("self.send_money", self.send_money)
		print("self.send_money_type",self.send_moeny_type)
	else
		self.bag_item = UserItem(pack)			--和获取背包数据接口一样
		print("self.bag_item", self.bag_item.item_id)
	end
	self.reset_time = pack:readInt()		--剩余时间，单位是秒， 0表示已过期
	self.reset_time = self.reset_time + os.time()
	self.money_type = pack:readByte()		--钱的类型，1是银两，3是非绑定元宝
	self.price = pack:readInt()				--出卖的价钱
	self.handle = pack:readUInt()			--后面3个是扩展字段 	
	self.name = pack:readString()			--出售人名称
	print("--------------")
end

--------------------------------------
super_class.JiShouSerchPageInfo()
function JiShouSerchPageInfo:__init(id, id_range, is_continuous)
	self.info = {}
	self.init = false
	self.is_send = false
	self.refresh_time = 0
	self.max_num = 0
	self.max_page = 0
	self.last_serch_index = 0
	self.serch_id = id
	self.id_range = id_range
	self.is_continuous = is_continuous
end