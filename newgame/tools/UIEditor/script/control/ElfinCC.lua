-- ElfinCC.lua
-- create by yongrui.liang at 2014-8-29
-- 式神协议

ElfinCC = {}

-- 客户端 -> 服务器 (45, 1)
-- 查看他人式神
function ElfinCC:req_see_other_elfin( ID, name )
	local pack = NetManager:get_socket():alloc(45, 1)
	pack:writeInt(ID)
	pack:writeString(name)
	NetManager:get_socket():SendToSrv(pack)
end

-- 服务器 -> 客户端 (45, 1)
-- 下发其他人式神数据
function ElfinCC:do_elfin_data( pack )
	local isOpen = pack:readChar()	-- 是否开启
	local elfinData = ElfinStruct(pack)
	ElfinModel:setOtherElfinData(elfinData)
	ElfinModel:openElfinInfoWin()
end

-- 服务器 -> 客户端 (45, 20)
-- 下发式神数据
function ElfinCC:do_init_elfin_data( pack )
	local isOpen = pack:readChar()	-- 是否开启
	ElfinModel:setIsOpenElfin(isOpen)
	if isOpen == 1 then
		local elfinData = ElfinStruct(pack)
		ElfinModel:setElfinData(elfinData)
	end
end

-- 客户端 -> 服务器 (45, 2)
-- 请求背包/仓库数据(1探险背包; 2探险仓库) (45, 2)
function ElfinCC:req_bag_or_storage( reqType )
	local pack = NetManager:get_socket():alloc(45, 2)
	pack:writeChar(reqType)
	NetManager:get_socket():SendToSrv(pack)
end

-- 服务器 -> 客户端 (45, 2)
-- 下发背包/仓库数据(1探险背包; 2探险仓库) (45, 2)
function ElfinCC:do_bag_or_storage( pack )
	local doType = pack:readChar()
	local itemNum = pack:readInt()
	local itemList = {}
	for i=1,itemNum do
		itemList[i] = {}
		itemList[i].itemIndex 		= i
		itemList[i].itemCDKey 			= pack:readInt()
		itemList[i].itemType 		= pack:readInt()
		itemList[i].itemQlty		= pack:readInt()
		itemList[i].itemLevel		= pack:readInt()
		itemList[i].itemSmelt		= pack:readInt()
		itemList[i].itemBaseVal 	= pack:readInt()
		itemList[i].itemLevelVal	= pack:readInt()
		itemList[i].itemNum			= pack:readInt()
	end
	if doType == 1 then
		ElfinModel:setExploreBag(itemList)
		ElfinModel:init_equip_data()
	elseif doType == 2 then
		ElfinModel:setExploreStorage(itemList)
	end
end

-- 客户端 -> 服务器 (45, 3)
-- 从仓库取出物品(CDKey 物品序列号, 0表示全部)
function ElfinCC:req_get_out_from_storage( CDKey )
	local pack = NetManager:get_socket():alloc(45, 3)
	pack:writeInt(CDKey)
	NetManager:get_socket():SendToSrv(pack)
end

-- 服务器 -> 客户端 (45, 3)
-- 从仓库取出物品(CDKey 物品序列号, 0表示全部)
function ElfinCC:do_get_out_from_storage( pack )
	local CDKey = pack:readInt()
	ElfinModel:doGetOutStorage(CDKey)
end

-- 客户端 -> 服务器 (45, 4)
-- 式神升级(物品类型[1初级; 2中级; 3高级]; 是否自动购买材料[0否; 1是]; 元宝或礼券[2礼券; 3元宝])
function ElfinCC:req_level_up_elfin( itemType, autoBuyItem, moneyType )
	local pack = NetManager:get_socket():alloc(45, 4)
	pack:writeByte(itemType)
	pack:writeByte(autoBuyItem)
	pack:writeByte(moneyType)
	NetManager:get_socket():SendToSrv(pack)
end

-- 服务器 -> 客户端 (45, 4)
-- 式神升级(升级后等级, 升级后经验, 本次获得经验, 5个属性)
function ElfinCC:do_level_up_elfin( pack )
	local level = pack:readInt()
	local curExp = pack:readInt()
	local getExp = pack:readInt()
	local attr = {}
	for i=1,5 do
		attr[i] = pack:readInt()
	end
	ElfinModel:doLevelUpElfin(level, curExp, attr)
end

-- 客户端 -> 服务器 (45, 5)
-- 穿戴装备(装备序列号, 装备框位置[0表示自动选择])
function ElfinCC:req_wear_equipment( CDKey, itemPos )
	local pack = NetManager:get_socket():alloc(45, 5)
	pack:writeInt(CDKey)
	pack:writeInt(itemPos)
	NetManager:get_socket():SendToSrv(pack)
end

-- 服务器 -> 客户端 (45, 5)
-- 穿戴装备(装备序列号, 装备框位置)
function ElfinCC:do_wear_equipment( pack )
	local CDKey = pack:readInt()
	local itemPos = pack:readInt()
	ElfinModel:doEquip(CDKey, itemPos)
end

-- 客户端 -> 服务器 (45, 6)
-- 脱下装备( 装备框位置)
function ElfinCC:req_takeoff_equipment( itemPos )
	local pack = NetManager:get_socket():alloc(45, 6)
	-- pack:writeInt(CDKey)
	pack:writeInt(itemPos)
	NetManager:get_socket():SendToSrv(pack)
end

-- 服务器 -> 客户端 (45, 6)
-- 脱下装备(装备框位置)
function ElfinCC:do_takeoff_equipment( pack )
	-- local CDKey = pack:readInt()
	local itemPos = pack:readInt()
	ElfinModel:doDropEquipment(itemPos)
end

-- 客户端 -> 服务器 (45, 7)
-- 装备升级(装备序列号)
function ElfinCC:req_level_up_equip( CDKey )
	local pack = NetManager:get_socket():alloc(45, 7)
	pack:writeInt(CDKey)
	NetManager:get_socket():SendToSrv(pack)
end

-- 服务器 -> 客户端 (45, 7)
-- 装备升级(装备序列号, 装备等级, 装备熔炼值, 装备等级属性值)
function ElfinCC:do_level_up_equip( pack )
	local CDKey = pack:readInt()
	local level = pack:readInt()
	local smeltVal = pack:readInt()
	ElfinModel:doLevelUpEquip( CDKey, level, smeltVal )
end

-- 客户端 -> 服务器 (45, 8)
-- 熔炼装备(物品数量, 物品列表{物品序列号})
function ElfinCC:req_smelt_equip( itemNum, itemList )
	local pack = NetManager:get_socket():alloc(45, 8)
	pack:writeInt(itemNum)
	for i=1,itemNum do
		pack:writeInt(itemList[i])
	end
	NetManager:get_socket():SendToSrv(pack)
end

---- 服务器->客户端  (45, 8)
--服务器下发熔炼后的奖励信息
function ElfinCC:do_smelt_equip( pack )
	local equip_num = pack:readInt()
	local equip_smelt_award = {}
	for i=1,equip_num do
		equip_smelt_award[i] = {}
		equip_smelt_award[i].itemCDKey 			= pack:readInt()
		equip_smelt_award[i].itemType 		= pack:readInt()
		equip_smelt_award[i].itemQlty		= pack:readInt()
		equip_smelt_award[i].itemLevel		= pack:readInt()
		equip_smelt_award[i].itemSmelt		= pack:readInt()
		equip_smelt_award[i].itemBaseVal 	= pack:readInt()
		equip_smelt_award[i].itemLevelVal	= pack:readInt()
		equip_smelt_award[i].itemNum			= pack:readInt()
	end	
	ElfinModel:analysis_smelt_award(equip_num,equip_smelt_award)
end

-- 客户端 -> 服务器 (45, 9)
-- 打开青铜宝箱
function ElfinCC:req_open_bronze_box( )
	local pack = NetManager:get_socket():alloc(45, 9)
	NetManager:get_socket():SendToSrv(pack)
end

-- 服务器 -> 客户端 (45, 9)
-- 打开青铜宝箱
function ElfinCC:do_open_bronze_box( pack )
	local item = {}
	item.itemCDKey		= pack:readInt()
	item.itemType		= pack:readInt()
	item.itemQlty		= pack:readInt()
	item.itemLevel		= pack:readInt()
	item.itemSmelt		= pack:readInt()
	item.itemBaseVal 	= pack:readInt()
	item.itemLevelVal	= pack:readInt()
	item.itemNum 		= pack:readInt()
	ElfinModel:doOpenBronzeBox(item)
end

-- 客户端 -> 服务器 (45, 10)
-- 召唤黄金宝箱
function ElfinCC:req_call_gold_box( moneyType )
	local pack = NetManager:get_socket():alloc(45, 10)
	pack:writeByte(moneyType)
	NetManager:get_socket():SendToSrv(pack)
end

-- 服务器 -> 客户端 (45, 10)
-- 召唤黄金宝箱
function ElfinCC:do_call_gold_box( pack )
	local item = {}
	item.itemCDKey		= pack:readInt()
	item.itemType		= pack:readInt()
	item.itemQlty		= pack:readInt()
	item.itemLevel		= pack:readInt()
	item.itemSmelt		= pack:readInt()
	item.itemBaseVal 	= pack:readInt()
	item.itemLevelVal	= pack:readInt()
	item.itemNum 		= pack:readInt()
	ElfinModel:doCallGoldBox(item)
end

-- 客户端 -> 服务器 (45, 11)
-- 开始探险(探险类型)
function ElfinCC:req_explore( exploreType )
	local pack = NetManager:get_socket():alloc(45, 11)
	pack:writeByte(exploreType)
	NetManager:get_socket():SendToSrv(pack)
end

-- -- 服务器 -> 客户端 (45, 11)
-- -- 开始探险(探险类型)
-- function ElfinCC:do_explore( pack )
-- 	local exploreType = pack:readByte()
-- 	local exploreDt = pack:readInt()
-- end

-- 客户端 -> 服务器 (45, 14)
-- 领取探险奖励
function ElfinCC:req_get_explore_award( )
	local pack = NetManager:get_socket():alloc(45, 14)
	NetManager:get_socket():SendToSrv(pack)
end

-- 服务器 -> 客户端 (45, 14)
-- 领取探险奖励
function ElfinCC:do_get_explore_award( pack )
	local duration = pack:readInt()
	local smelt = pack:readInt()
	local itemNum = pack:readInt()
	local itemList = {}
	for i=1,itemNum do
		itemList[i] = {}
		itemList[i].itemIndex 		= i
		itemList[i].itemCDKey 		= pack:readInt()
		itemList[i].itemType 		= pack:readInt()
		itemList[i].itemQlty		= pack:readInt()
		itemList[i].itemLevel		= pack:readInt()
		itemList[i].itemSmelt		= pack:readInt()
		itemList[i].itemBaseVal 	= pack:readInt()
		itemList[i].itemLevelVal	= pack:readInt()
		itemList[i].itemNum			= pack:readInt()
	end
	ElfinModel:doGetExploreAward(duration, smelt, itemList)
end

-- 客户端 -> 服务器 (45, 12)
-- 增加探险时长(探险类型[1-4], 元宝或礼券)
function ElfinCC:req_extend_explore_duration( exploreType, moneyType )
	local pack = NetManager:get_socket():alloc(45, 12)
	pack:writeByte(exploreType)
	pack:writeByte(moneyType)
	NetManager:get_socket():SendToSrv(pack)
end

-- -- 服务器 -> 客户端 (45, 13)
-- -- 增加探险时长(探险类型[1-4], 探险时长)
-- function ElfinCC:do_extend_explore_duration( pack )
-- 	local exploreType = pack:readByte()
-- 	local exploreDt = pack:readInt()
-- end

-- 客户端 -> 服务器 (45, 13)
-- 查询探险状态
function ElfinCC:req_explore_status( )
	local pack = NetManager:get_socket():alloc(45, 13)
	NetManager:get_socket():SendToSrv(pack)
end

-- 服务器 -> 客户端 (45, 13)
-- 返回探险状态 (探险类型, 探险时长[秒])
function ElfinCC:do_explore_status( pack )
	local exploreType = pack:readByte()
	local exploreDt = pack:readInt()
	ElfinModel:doExploreStatus(exploreType, exploreDt)
end

-- 服务器 -> 客户端 (45, 15)
-- 开启探险关卡
function ElfinCC:do_open_explore_level( pack )
	local exploreNum = pack:readChar()
	ElfinModel:doOpenExploreLevl(exploreNum)
end

-- 服务器 -> 客户端 (45, 16)
-- 熔炼值通知
function ElfinCC:do_smelt_val( pack )
	local smelt = pack:readInt()
	ElfinModel:setSmeltVal(smelt)
end

-- 服务器 -> 客户端 (45, 21)
-- 删除一个物品(1探险背包; 2探险仓库)
function ElfinCC:do_remove_item( pack )
	local bagOrStorage = pack:readChar()
	local CDKey = pack:readInt()
	if bagOrStorage == 1 then
		ElfinModel:removeBagItem(CDKey)
	else
		ElfinModel:removeStorageItem(CDKey)
	end
end

-- 服务器 -> 客户端 (45, 22)
-- 增加一个物品(1探险背包; 2探险仓库)
function ElfinCC:do_add_item( pack )
	local bagOrStorage = pack:readChar()
	local item = {}
	item.itemCDKey		= pack:readInt()
	item.itemType		= pack:readInt()
	item.itemQlty		= pack:readInt()
	item.itemLevel		= pack:readInt()
	item.itemSmelt		= pack:readInt()
	item.itemBaseVal 	= pack:readInt()
	item.itemLevelVal	= pack:readInt()
	item.itemNum 		= pack:readInt()
	if bagOrStorage == 1 then
		ElfinModel:doAddBagItem(item)
	else
		ElfinModel:doAddStorageItem(item)
	end
end

-- 服务器 -> 客户端 (45, 23)
-- 模型改变
function ElfinCC:do_change_model( pack )
	local modelID = pack:readInt()
	ElfinModel:doChangeModel(modelID)
end

-- 服务器 -> 客户端 (45, 24)
-- 战力改变
function ElfinCC:do_change_fight( pack )
	local fight = pack:readInt()
	ElfinModel:doChangeFight(fight)
end

-- 服务器 -> 客户端 (45, 25)
-- 召唤宝箱次数变更
function ElfinCC:do_change_call_box_num( pack )
	local num = pack:readInt()
	ElfinModel:doChangeCallBoxNum(num)

end

-- 服务器 -> 客户端 (45, 26)
-- 增加探险时长次数变更
function ElfinCC:do_change_extend_explore_dt_num( pack )
	local num = pack:readInt()
	ElfinModel:setExtendExploreDtTimes(num)
end

-- 服务器 -> 客户端 (45, 27)
-- 装备框开启通知
function ElfinCC:do_open_equip_slot( pack )
	local equipSlot = pack:readInt()
	ElfinModel:doChangeOpenEquipSlot(equipSlot)
end

-- 服务器 -> 客户端 (45, 28)
-- 暴击(0暴击; 1小暴击; 2中暴击; 3大暴击)
function ElfinCC:do_booooom( pack )
	local booooomType = pack:readByte()
	ElfinModel:doBooooom(booooomType)
end
