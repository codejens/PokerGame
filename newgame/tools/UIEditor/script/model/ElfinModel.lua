-- ElfinModel.lua
-- created by yongrui.liang on 2014-8-26
-- 式神系统model

ElfinModel = {}

ElfinModel.ELFIN_INFO_PAGE = 0				-- 式神信息页面
ElfinModel.ELFIN_LEVEL_LEFT_PAGE = 1 		-- 式神等级左页面
ElfinModel.ELFIN_ITEM_LEFT_PAGE = 2 		-- 式神装备左页面
ElfinModel.ITEM_SMELT_LEFT_PAGE = 3 		-- 装备熔炼左页面
ElfinModel.ELFIN_LEVEL_RIGHT_PAGE = 4 		-- 式神等级右页面
ElfinModel.ELFIN_ITEM_RIGHT_PAGE = 5 		-- 式神装备右页面
ElfinModel.ITEMSMELT_RIGHT_PAGE = 6 		-- 装备熔炼右页面
ElfinModel.EXPLORE_PAGE = 7 				-- 探险页面
ElfinModel.EXPLORE_BAG_PAGE = 8 			-- 探险背包页面
ElfinModel.LV_UP_ITEM_PAGE = 9 				-- 升级装备页面
ElfinModel.EXPLORE_STORAGE_PAGE = 10 		-- 探险仓库页面

ElfinModel.CURRENT_RIGHT_PAGE = ElfinModel.ELFIN_LEVEL_RIGHT_PAGE 	-- 右边窗口当前显示页面
ElfinModel.CURRENT_LEFT_PAGE = ElfinModel.ELFIN_LEVEL_LEFT_PAGE 	-- 左边窗口当前显示页面
ElfinModel.CURRENT_ELFIN_ITEM_PAGE = ElfinModel.EXPLORE_PAGE 		-- 式神装备右页面当前显示的页面

local _EXPLORE_BAG_NUM = 80 		-- 探险背包容量
local _EXPLORE_STORAGE_NUM = 70 	-- 探险仓库容量

-- local _ELFIN_EQUIPMENT_MAX_LEVEL = 12

local _elfinData = nil 				-- 式神数据
local _otherElfinData = nil			-- 其他玩家式神数据
local _isOpenElfin = nil 			-- 是否开启式神
local _exploreBag = nil
local _exploreStorage = nil
local _callGoldBoxNum = 0
local _exploreType = 1
local _exploreDt = 0
local _exploreLevel = 1
local _extendExploreDtTimes = 0
local _smeltVal = 0

local _clickElfinItem = nil

local _exploreTimer = nil

-----------------------------------装备熔炼页------------------
--保存道具信息
local _current_right_equip = {}
local _left_equip_item = {} --存放左侧所有道具，可存在有空道具
local _one_equip_slot = nil --熔炼左侧标记的道具
local if_auto_sucess = false --标记筛选成功或者失败
local show_award = {}      --存放熔炼服务器下发的 奖励
---------------------------------

function ElfinModel:fini( )
	_elfinData = nil
	_otherElfinData = nil
	_isOpenElfin = nil
	_exploreBag = {nil}
	_exploreStorage = {nil}
	_callGoldBoxNum = 0
	_exploreType = 1
	_exploreDt = 0
	_exploreLevel = 1
	_extendExploreDtTimes = 0
	_smeltVal = 0
	ElfinModel.CURRENT_LEFT_PAGE = ElfinModel.ELFIN_LEVEL_LEFT_PAGE
	ElfinModel.CURRENT_RIGHT_PAGE = ElfinModel.ELFIN_LEVEL_RIGHT_PAGE
	ElfinModel.CURRENT_ELFIN_ITEM_PAGE = ElfinModel.EXPLORE_PAGE
	_clickElfinItem = nil
	if _exploreTimer then
		_exploreTimer:cancel()
	end
	_exploreTimer = nil

	_current_right_equip = {}
	_left_equip_item = {}
	_one_equip_slot = nil
	if_auto_sucess = false
	show_award = {}
end

-- 打开式神初始化变量
function ElfinModel:initElfinWinInfo( )
	ElfinModel.CURRENT_LEFT_PAGE = ElfinModel.ELFIN_LEVEL_LEFT_PAGE
	ElfinModel.CURRENT_RIGHT_PAGE = ElfinModel.ELFIN_LEVEL_RIGHT_PAGE
	ElfinModel.CURRENT_ELFIN_ITEM_PAGE = ElfinModel.EXPLORE_PAGE
	_clickElfinItem = nil

	_current_right_equip = {}
	_left_equip_item = {}
	_one_equip_slot = nil
	if_auto_sucess = false
	show_award = {}
end

-- 根据左页面跳转到相应的右页面
function ElfinModel:changeRightPage( pageIndex )
	local win = UIManager:find_visible_window("elfin_right_win")
	if not win then
		win = UIManager:show_window("elfin_right_win")
	end
	if win and win.update then
		win:update(pageIndex)
	end
end

function ElfinModel:changeLeftPage( pageIndex )
	local win = UIManager:find_visible_window("elfin_left_win")
	if not win then
		win = UIManager:show_window("elfin_left_win")
	end
	if win and win.update then
		win:update(pageIndex)
	end
end

function ElfinModel:updateLeftWin( updateType, param )
	local win = UIManager:find_visible_window("elfin_left_win")
	if win and win.update then
		win:update(updateType or "all", param)
	end
end

function ElfinModel:updateRightWin( updateType, param )
	local win = UIManager:find_visible_window("elfin_right_win")
	if win and win.update then
		win:update(updateType or "all", param)
	end
end

function ElfinModel:openElfinInfoWin( )
	ElfinModel:changeLeftPage(ElfinModel.ELFIN_INFO_PAGE)
end

-- 当前左边窗口显示的页面
function ElfinModel:setCurLeftPage( page )
	ElfinModel.CURRENT_LEFT_PAGE = page
end

function ElfinModel:getCurLeftPage( )
	return ElfinModel.CURRENT_LEFT_PAGE
end

-- 右边窗口显示的页面
function ElfinModel:setCurRightPage( page )
	ElfinModel.CURRENT_RIGHT_PAGE = page
end

function ElfinModel:getCurRightPage( )
	return ElfinModel.CURRENT_RIGHT_PAGE
end

-- 当左边窗口显示的是式神装备页面时，右边窗口显示的页面
function ElfinModel:setCurElfinItemPage( page )
	ElfinModel.CURRENT_ELFIN_ITEM_PAGE = page
end

function ElfinModel:getCurElfinItemPage( )
	return ElfinModel.CURRENT_ELFIN_ITEM_PAGE
end

-- 保存当前式神装备左页面点击的装备
function ElfinModel:setClickElfinItem( item )
	_clickElfinItem = item
end

function ElfinModel:getClickElfinItem( )
	return _clickElfinItem
end





-- 探险背包容量
function ElfinModel:getExploreBagNum( )
	return _EXPLORE_BAG_NUM
end

-- 探险仓库容量
function ElfinModel:getExploreStorageNum( )
	return _EXPLORE_STORAGE_NUM
end

-- 式神数据
function ElfinModel:setElfinData( data )
	_elfinData = data
end

-- 获取式神数据
function ElfinModel:getElfinData( )
	return _elfinData
end

-- 其他玩家式神数据
function ElfinModel:setOtherElfinData( data )
	_otherElfinData = data
end

-- 获取其他玩家式神数据
function ElfinModel:getOtherElfinData( )
	return _otherElfinData
end

-- 设置式神是否已开启
function ElfinModel:setIsOpenElfin( isOpen )
	if isOpen or isOpen == 1 then
		_isOpenElfin = true
	else
		_isOpenElfin = false
	end
end

-- 获取式神是否已开启
function ElfinModel:getIsOpenElfin( )
	return _isOpenElfin
end

-- 设置探险背包数据
function ElfinModel:setExploreBag( data )
	_exploreBag = data
end

function ElfinModel:getExploreBag( )
	return _exploreBag
end

-- 设置探险仓库数据
function ElfinModel:setExploreStorage( data )
	_exploreStorage = data
end

function ElfinModel:getExploreStorage( )
	return _exploreStorage
end

-- 式神等级
function ElfinModel:getElfinLevel( )
	return _elfinData.level
end

function ElfinModel:getOtherElfinLevel( )
	return _otherElfinData.level
end

-- 式神经验
function ElfinModel:getElfinExp( )
	return _elfinData.exp
end

-- 式神战斗力
function ElfinModel:getElfinFight( )
	return _elfinData.fight
end

function ElfinModel:getOtherElfinFight( )
	return _otherElfinData.fight
end

-- 式神模型
function ElfinModel:getModelId( )
	return _elfinData.modelID
end

function ElfinModel:getOtherModelId( )
	return _otherElfinData.modelID
end

-- 五个属性
function ElfinModel:getAttrs( )
	return _elfinData.attr
end

function ElfinModel:getOtherAttrs( )
	return _otherElfinData.attr
end

-- 装备开启数量
function ElfinModel:getOpenEquipNum( )
	return _elfinData.openItemSlotNum
end

function ElfinModel:getOtherOpenEquipNum( )
	return _otherElfinData.openItemSlotNum
end

-- 装备列表
function ElfinModel:getEquips( )
	local itemList = {}
	for i,v in pairs(_elfinData.itemList) do
		if v.itemCDKey ~= 0 then
			itemList[i] = v
		end
	end
	return itemList
end

function ElfinModel:getOtherEquips( )
	local itemList = {}
	for i,v in pairs(_otherElfinData.itemList) do
		if v.itemCDKey ~= 0 then
			itemList[i] = v
		end
	end
	return itemList
end

function ElfinModel:getEquipItemByIndex( index )
	local equipItems = ElfinModel:getEquips()
	for i,v in pairs(equipItems) do
		if v.itemIndex == index then
			return v
		end
	end
	return nil
end

function ElfinModel:getEquipItemMaxLevel( typeId, qlty )
	-- return _ELFIN_EQUIPMENT_MAX_LEVEL
	typeId = typeId or 1
	qlty = qlty or 1
	local maxLv = ElfinConfig:getEquipMaxLevel(typeId, qlty)
	return maxLv
end

function ElfinModel:setGoldBoxNum( num )
	_callGoldBoxNum = num
end

function ElfinModel:getGoldBoxNum( )
	return _callGoldBoxNum
end



-----------------------------------

--初始化左侧列表数据
function ElfinModel:init_equip_data(  )
	--道具的 cdk是唯一的,if_sleect 标志是否在右侧面板中被选中
	for i=1,8 do
		local one_slot = {equip = {},if_select = false}
		_left_equip_item[i] = one_slot
	end
	ElfinModel:set_can_smelt_equip( )
end

function ElfinModel:get_equip_data(  )
	return _left_equip_item
end

function ElfinModel:copyBag( )
	local tmpBag = {}
	if _exploreBag then
		for k,v in pairs(_exploreBag) do
			if v then
				local item = {}
				item.itemIndex 		= v.itemIndex
				item.itemCDKey		= v.itemCDKey 		-- 装备序列号
				item.itemType		= v.itemType 		-- 装备类型
				item.itemQlty		= v.itemQlty 		-- 装备品质
				item.itemLevel		= v.itemLevel 		-- 装备等级
				item.itemSmelt		= v.itemSmelt		-- 装备熔炼值
				item.itemBaseVal	= v.itemBaseVal 	-- 装备基础属性值
				item.itemLevelVal	= v.itemLevelVal	-- 装备等级属性值
				item.itemNum 		= v.itemNum
				table.insert(tmpBag, item)
			end
		end
	end
	return tmpBag
end

--去掉道具表中type为10 的道具
function ElfinModel:set_can_smelt_equip( )
	local all_smelt_equip = ElfinModel:copyBag() -- Utils:table_deepcopy(_exploreBag)  --全部式神道具的拷贝

	local smelt_equip_num = #all_smelt_equip
	if smelt_equip_num == 0 then 
		return 
	end 

	--删除道具列表中的itemType== 10 的道具
	for i = smelt_equip_num, 1, -1 do
		local one_smelt = all_smelt_equip[i]
		if one_smelt ~= nil then 
		    if one_smelt.itemType == 10 then
		        table.remove(all_smelt_equip, i)
		        smelt_equip_num = smelt_equip_num-1
		    end
		end 
	end
	local function sort_fun( tab1, tab2 )
		if tab1.itemQlty<tab2.itemQlty then 
			return true
		elseif tab1.itemQlty == tab2.itemQlty then 
			if tab1.itemSmelt < tab2.itemSmelt then 
				return true
			end 
		else 
			return false 
		end 
	end
	ElfinModel:sortTable( all_smelt_equip, sort_fun )

	for i=1,smelt_equip_num do
		local one_equip ={}
		one_equip.equip = all_smelt_equip[i]
		one_equip.if_select = false
		_current_right_equip[i] = one_equip
	end
end

function ElfinModel:get_right_equip( )
	return _current_right_equip
end

--自动筛选数据传递
function ElfinModel:auto_equip_data(  )
	--右侧道具中取前8个道具
	local all_equip = #_current_right_equip
	local auto_num =  #_left_equip_item
	for i=1,auto_num do
	 	if _left_equip_item[i].equip.itemCDKey == nil then
	 		for j=1,all_equip do
	 			if _current_right_equip[j].if_select == false then
	 				_current_right_equip[j].if_select = true 
	 				_left_equip_item[i] = Utils:table_deepcopy(_current_right_equip[j])
	 				if_auto_sucess = true
	 				break
	 			end
	 		end
	 	end
	end
end

--熔炼界面 自动筛选功能
function ElfinModel:auto_select( )
	ElfinModel:auto_equip_data()
	
	if if_auto_sucess == true then
		if_auto_sucess = false
		
		ElfinModel:updateLeftWin("selectSmeltItem")
		ElfinModel:updateRightWin("selectSmeltItem")
	else
		local if_full = ElfinModel:if_smelt_full(  )
		if if_full == true then 
			GlobalFunc:create_screen_notic( "筛选失败！您的熔炼槽已满！" );
		else 
			GlobalFunc:create_screen_notic( "筛选失败！您当前没有用于熔炼的道具" );
		end 
	end 
end

--熔炼中的数据刷新处理
function ElfinModel:update_smelt_page( item,updateType )
	--判定当前页是 熔炼页时，需做数据刷新处理
 	ElfinModel:update_a_equip_smelt( item, updateType )
 	ElfinModel:updateRightWin("refresh")
end

function ElfinModel:update_a_equip_smelt( item,updateType )
	if updateType == "removeItem" then 
		for i = #_current_right_equip, 1, -1 do
			local one_smelt = _current_right_equip[i]
			if one_smelt ~= nil then 
			    if _current_right_equip[i].equip.itemCDKey == item.itemCDKey then
			        table.remove(_current_right_equip, i)
			    end
			end 
		end
	elseif updateType == "addItem" then 
		local right_equip = #_current_right_equip
		local one_equip = { equip = Utils:table_deepcopy(item),if_select = false}
		_current_right_equip[right_equip+1] = one_equip
	end 
end

--熔炼请求
function ElfinModel:equip_smelt(  )
	local copy_eq = _left_equip_item
	--遍历找出标记为true的道具的 cdk值 用于熔炼
	local sign_equip = {} 
	local equip_num  = #copy_eq
	local index = 1
	if equip_num ~= 0 then 
		for i=1,equip_num do
			local one_equip = copy_eq[i]
			if one_equip.equip.itemCDKey ~= nil and one_equip.if_select == true  then 
				sign_equip[index] = one_equip.equip.itemCDKey
				index =index + 1
			end 
		end
	end 
	local itemCDKey_num  =  #sign_equip
	if itemCDKey_num == 0 then 
		GlobalFunc:create_screen_notic( "请先放入材料装备" );
	else 
		ElfinCC:req_smelt_equip( itemCDKey_num, sign_equip )
	end 
end

--服务器下发熔炼奖励后的处理
function  ElfinModel:analysis_smelt_award(equip_num,equip_smelt_award)
	--遍历找到熔炼增加的物品,增加到背包
	show_award = {}
	for i=1,equip_num do
		local one_equip_award = equip_smelt_award[i]
		show_award[i] = { }
		if one_equip_award.itemType ~= 0 then 
			--增加的道具
			ElfinModel:doAddBagItem( one_equip_award )
			show_award[i].if_new_equip = true 
			local name = ElfinConfig:getEquipNameByType(one_equip_award.itemType)
			show_award[i].new_equip_name = name
		else 
			--不是新加的道具
			show_award[i].if_new_equip = false

			show_award[i].smelt_value = one_equip_award.itemSmelt
		end
	end

	--更新熔炼界面
	ElfinModel:init_equip_data()
	ElfinModel:updateLeftWin("smeltItems")
 	-- ElfinModel:updateLeftWin("removeBagItem")
 	ElfinModel:updateRightWin("refresh")
 	-- ElfinModel:updateLeftWin("down_smelt_info")
end

function ElfinModel:get_award_list(  )
 	return show_award
 end 

--判定左侧熔炼槽是否已满
function ElfinModel:if_smelt_full(  )
	-- local equip_num = #_left_equip_item
	--  if _left_equip_item[equip_num].equip.itemCDKey == nil then 
	--  	return false
	--  end 
	--  return true 
	for k,v in pairs(_left_equip_item) do
		if not v.equip.if_select then
			return false
		end
	end
	return true
end

--装备熔炼--放入道具
function ElfinModel:set_equip_item_series( one_slot )
	_one_equip_slot = one_slot
	ElfinModel:show_equip_arrange()
	ElfinModel:updateRightSmeltItems()
	ElfinModel:updateLeftWin("selectSmeltItem")
	ElfinModel:updateRightWin("selectSmeltItem")
end

--左侧道具显示方式
function ElfinModel:show_equip_arrange( )
	local equip_num = #_left_equip_item
	if _one_equip_slot.if_select == true then
		for i=1,equip_num do
			if _left_equip_item[i].equip.itemCDKey == _one_equip_slot.equip.itemCDKey then 
				if _left_equip_item[i].if_select ~= _one_equip_slot.if_select then 
					_left_equip_item[i].if_select = _one_equip_slot.if_select 
					return
				end
			elseif _left_equip_item[i].equip.itemCDKey == nil  then 
				_left_equip_item[i] = Utils:table_deepcopy(_one_equip_slot)
				return
			end
		end
		return
	else
		for i=1,equip_num do
			if _left_equip_item[i].equip.itemCDKey == _one_equip_slot.equip.itemCDKey then 
				--构造一个  假的slot,当遍历到这个slot时 不显示，即达到修改的作用，同时标记位置
				local one_slot = {equip = { },if_select = false}
				_left_equip_item[i] = one_slot
				return 
			end   
		end
		return  
	end 
end

function ElfinModel:updateRightSmeltItems( )
	for k,v in pairs(_current_right_equip) do
		v.if_select = false
	end
	for k,v in pairs(_left_equip_item) do
		if v.if_select then
			for kk,vv in pairs(_current_right_equip) do
				if v.equip.itemCDKey == vv.equip.itemCDKey then
					vv.if_select = true
					break
				end
			end
		end		
	end
end

-----------------------------------------------
-- 更新式神某个数据变量
function ElfinModel:changeData( key, value )
	_elfinData[key] = value
end

-- 更新式神某个装备数据变量
function ElfinModel:changeEquipData( index, key, value )
	_elfinData.itemList[index][key] = value
end

function ElfinModel:changeEquipment( index, item )
	_elfinData.itemList[index] = item
end

-- 展示式神
function ElfinModel:showElfin( )
	local modelId = ElfinModel:getModelId()
	local playerId = EntityManager:get_player_avatar().id
	local playerName = EntityManager:get_player_avatar().name

	local showInfo = string.format( "%s%d%s%d%s%d%s%s%s,%s,%s,%s%s",
		ChatConfig.message_split_target.CHAT_INFO_SPLITE_TARGET,
		ChatConfig.ChatSpriteType.TYPE_TEXTBUTTON, 
		ChatConfig.message_split_target.CHAT_INFO_HEAD_TARGET,
		ChatConfig.ChatAdditionInfo.TYPE_SPRITE, 
		ChatConfig.message_split_target.CHAT_INFO_HEAD_TARGET,
		modelId, 
		ChatConfig.message_split_target.CHAT_INFO_HEAD_TARGET,
		Hyperlink:get_first_function_target(), 
		Hyperlink:get_third_open_sys_win_target(),
		--式神window id
		12,
		playerId, playerName,
		ChatConfig.message_split_target.CHAT_INFO_SPLITE_TARGET)
	local cur_select_chanel = ChatModel:get_cur_chanel_select()
    if cur_select_chanel == 100 then
        cur_select_chanel = 6
    end 
    ChatCC:send_chat(cur_select_chanel, 0, showInfo)
end

-- 请求升级式神
function ElfinModel:reqLevelUpElfin( itemId, autoBuyItem )
    local itemType = 1
    local needItemIds = ElfinConfig:getLevelUpNeedItems()
    for i,v in ipairs(needItemIds) do
    	if v == itemId then
    		itemType = i
    		break
    	end
    end

    if autoBuyItem then
    	autoBuyItem = 1
    else
    	autoBuyItem = 0
    end

	local moneyType = MallModel:get_only_use_yb() and 3 or 2
    local count = ItemModel:get_item_count_by_id( itemId )
    if count > 0 then	
	 	ElfinCC:req_level_up_elfin(itemType, autoBuyItem, moneyType)
	elseif autoBuyItem == 1 then
	 	local param = {itemType, autoBuyItem, moneyType}
	 	local lvUpfunc = function( param )
	 		ElfinCC:req_level_up_elfin(param[1], param[2], param[3])
	 	end
	 	MallModel:handle_shopping_1( itemId, 1, lvUpfunc, param )
	else
		ElfinCC:req_level_up_elfin(itemType, autoBuyItem, moneyType)
	end
end

-- 式神升级回调
function ElfinModel:doLevelUpElfin( level, exp, attr )
	ElfinModel:changeData("level", level)
	ElfinModel:changeData("exp", exp)
	ElfinModel:changeData("attr", attr)
	ElfinModel:updateLeftWin()
	ElfinModel:updateRightWin()
end

-- 请求装备升级
function ElfinModel:reqLevelUpEquip( )
	local selectedEquip = ElfinModel:getClickElfinItem()
	if not selectedEquip then
		return
	end
	
	local index = selectedEquip:getIndex()
	local item = ElfinModel:getEquipItemByIndex(index)
	local needSmelt = ElfinConfig:getEquipLvUpSmelt(item.itemType, item.itemQlty, item.itemLevel)
	local smelt = ElfinModel:getSmeltVal()
	if smelt < needSmelt then
		GlobalFunc:create_screen_notic("熔炼值不足")
		return
	end

	local player = EntityManager:get_player_avatar()
	local money = player.bindYinliang
	local needMoney = ElfinConfig:getEquipLvUpMoney(item.itemType, item.itemQlty, item.itemLevel)
	if money < needMoney then
		GlobalFunc:create_screen_notic("忍币不足")
		return
	end

	ElfinCC:req_level_up_equip(item.itemCDKey)
end

-- 装备升级回调
function ElfinModel:doLevelUpEquip( CDKey, level, smelt )
	for i,v in ipairs(_elfinData.itemList) do
		if v.itemCDKey == CDKey then
			ElfinModel:changeEquipData(v.itemIndex, "itemLevel", level)
			ElfinModel:changeEquipData(v.itemIndex, "itemSmelt", smelt)
			ElfinModel:updateRightWin(ElfinModel.LV_UP_ITEM_PAGE)
			ElfinModel:updateRightWin("LvUpEffect")
			return
		end
	end
end

-- 模型改变
function ElfinModel:doChangeModel( modelId )
	ElfinModel:changeData("modelID", modelId)
	ElfinModel:updateLeftWin("model")
	ElfinModel:updateRightWin("model")
end

-- 战斗力改变
function ElfinModel:doChangeFight( fight )
	ElfinModel:changeData("fight", fight)
	ElfinModel:updateLeftWin("fight")
	ElfinModel:updateRightWin("fight")
end

-- 召唤宝箱次数变更
function ElfinModel:doChangeCallBoxNum( num )
	ElfinModel:setGoldBoxNum(num)
	ElfinModel:updateRightWin("goldBoxNum")
end

-- 装备框开启
function ElfinModel:doChangeOpenEquipSlot( slotNum )
	ElfinModel:changeData("openItemSlotNum", slotNum)
	ElfinModel:updateLeftWin("openItemSlot")
end

-- 播放暴击特效
function ElfinModel:doBooooom( booooomType )
	ElfinModel:updateRightWin("booooom")
end

-- 查找背包物品
function ElfinModel:findBagItemByCDKey( CDKey )
	_exploreBag = _exploreBag and _exploreBag or {}
	for i,v in pairs(_exploreBag) do
		if v.itemCDKey == CDKey then
			return i
		end
	end
	return nil
end

-- 查找仓库物品
function ElfinModel:findStorageItemByCDKey( CDKey )
	_exploreStorage = _exploreStorage and _exploreStorage or {}
	for i,v in pairs(_exploreStorage) do
		if v.itemCDKey == CDKey then
			return i
		end
	end
	return nil
end

-- 判断是物品还是装备
function ElfinModel:checkIsEquip( typeId )
	return ElfinConfig:getEquipmentCanEquipByType(typeId)
end

-- 减少背包物品
function ElfinModel:removeBagItem( CDKey )
	local index = ElfinModel:findBagItemByCDKey(CDKey)
	if index then
		local item = _exploreBag[index]
		local isEquip = ElfinModel:checkIsEquip(item.itemType)
		if isEquip then
			-- 背包一个格子只能放一个装备，所以直接移除
			_exploreBag[index] = nil
			ElfinModel:update_smelt_page( item,"removeItem" )
			ElfinModel:updateRightWin("removeBagItem", {index, _exploreBag[index]})
		else
			-- 不是装备，减少数量
			local num = item.itemNum
			if num > 1 then
				_exploreBag[index].itemNum = num - 1
				ElfinModel:update_smelt_page( item,"removeItem" )
				ElfinModel:updateRightWin("bagItemCount", {index, _exploreBag[index]})
			else
				_exploreBag[index] = nil
				ElfinModel:update_smelt_page( item,"removeItem" )
				ElfinModel:updateRightWin("removeBagItem", {index, _exploreBag[index]})
			end
		end
	end
end

-- 减少仓库物品
function ElfinModel:removeStorageItem( CDKey )
	local index = ElfinModel:findStorageItemByCDKey(CDKey)
	if index then
		local item = _exploreStorage[index]
		-- _exploreStorage[index] = nil
		table.remove(_exploreStorage, index)
		ElfinModel:updateLeftWin("removeStorageItem", {index, _exploreStorage[index]})
		ElfinModel:updateRightWin("removeStorageItem", {index, _exploreStorage[index]})
		-- ElfinModel:addBagItem(item)
	end
end

-- 找到空的背包格子
function ElfinModel:findBagSlotEmpty( )
	_exploreBag = _exploreBag and _exploreBag or {}
	local bagNum = ElfinModel:getExploreBagNum()
	for i=1,bagNum do
		if not _exploreBag[i] then
			return i
		end
	end
	return bagNum + 1
end

-- 找到空的仓库格子
function ElfinModel:findStorageSlotEmpty( )
	_exploreStorage = _exploreStorage and _exploreStorage or {}
	if _exploreStorage then
		local bagNum = ElfinModel:getExploreStorageNum()
		for i=1,bagNum do
			if not _exploreStorage[i] then
				return i
			end
		end
		return bagNum + 1
	else
		return 1
	end
end

-- 判断背包是否满
function ElfinModel:checkBagFull( )
	local count = 0
	_exploreBag = _exploreBag and _exploreBag or {}
	for i,v in pairs(_exploreBag) do
		if v then
			count = count + 1
		end
	end
	if count < _EXPLORE_BAG_NUM then
		return false
	else
		return true
	end
end

-- 通知背包已满
function ElfinModel:handleBagFunll( str )
	GlobalFunc:create_screen_notic(str or "探险背包已满")
end

-- 判断仓库是否满
function ElfinModel:checkStorageFull( )
	local count = ElfinModel:getStorageItemNum()
	if count < _EXPLORE_STORAGE_NUM then
		return false
	else
		return true
	end
end

function ElfinModel:checkStorageEmpty( )
	local count = ElfinModel:getStorageItemNum()
	if count == 0 then
		return true
	else
		return false
	end
end

function ElfinModel:getBagItemNum( )
	local count = 0
	_exploreBag = _exploreBag and _exploreBag or {}
	for i,v in pairs(_exploreBag) do
		if v then
			count = count + 1
		end
	end
	return count
end

function ElfinModel:getStorageItemNum( )
	local count = 0
	_exploreStorage = _exploreStorage and _exploreStorage or {}
	for i,v in pairs(_exploreStorage) do
		if v then
			count = count + 1
		end
	end
	return count
end

function ElfinModel:getStorageRemainNum( )
	local count = ElfinModel:getStorageItemNum()
	return _EXPLORE_STORAGE_NUM - count
end

-- 只往背包添加一个物品
function ElfinModel:addBagItem( item )
	if not ElfinModel:checkBagFull() then
		local index = ElfinModel:findBagSlotEmpty()
		_exploreBag[index] = item
		_exploreBag[index].itemIndex = index

		ElfinModel:update_smelt_page( item,"addItem" )	

		ElfinModel:updateRightWin("addBagItem", {index, _exploreBag[index]})
	end
end

-- 只往仓库添加一个物品
function ElfinModel:addStorageItem( item )
	if not ElfinModel:checkStorageFull() then
		local index = ElfinModel:findStorageSlotEmpty()
		_exploreStorage[index] = item
		_exploreStorage[index].itemIndex = index

		ElfinModel:updateLeftWin("addStorageItem", {index, _exploreStorage[index]})
	end
end

-- 往背包物品添加数量
function ElfinModel:addBagItemCount( index )
	if _exploreBag[index] then
		_exploreBag[index].itemNum = _exploreBag[index].itemNum + 1
		ElfinModel:update_smelt_page( item,"addItem" )
		ElfinModel:updateRightWin("bagItemCount", {index, _exploreBag[index]})
		--ElfinModel:updateLeftSmeltPage()
	end
end

-- 往仓库物品添加数量
function ElfinModel:addStorageItemCount( index )
	if _exploreStorage[index] then
		_exploreStorage[index].itemNum = _exploreStorage[index].itemNum + 1
		ElfinModel:updateLeftWin("storageItemCount", {index, _exploreStorage[index]})
	end
end

-- 查找背包物品
function ElfinModel:findBagItemByType( itemType )
	for i,v in pairs(_exploreBag) do
		if v.itemType == itemType then
			return i
		end
	end
	return nil
end

-- 查找仓库物品
function ElfinModel:findStorageItemByType( itemType )
	for i,v in pairs(_exploreStorage) do
		if v.itemType == itemType then
			return i
		end
	end
	return nil
end

-- 添加背包物品或增加数量
function ElfinModel:doAddBagItem( item )
	if item then
		local isEquip = ElfinModel:checkIsEquip(item.itemType)
		if isEquip then
			ElfinModel:addBagItem(item)
		else
			local index = ElfinModel:findBagItemByType(item.itemType)
			if index then
				ElfinModel:addBagItemCount(index)
			else
				ElfinModel:addBagItem(item)
			end
		end
	end
end

-- 添加仓库物品或增加数量
function ElfinModel:doAddStorageItem( item )
	if item then
		local isEquip = ElfinModel:checkIsEquip(item.itemType)
		if isEquip then
			ElfinModel:addStorageItem(item)
		else
			-- local index = ElfinModel:findStorageItemByType(item.itemType)
			-- if index then
			-- 	ElfinModel:addStorageItemCount(index)
			-- else
				ElfinModel:addStorageItem(item)
			-- end
		end
	end
end

function ElfinModel:setExtendExploreDtTimes( times )
	_extendExploreDtTimes = times
end

-- 增加探险时长
function ElfinModel:reqExtendExploreDt( exploreType )
	local money = ElfinConfig:getExpendExploreTimeCost(_extendExploreDtTimes+1)

	local confirmFun = function( )
		local moneyType = MallModel:get_only_use_yb() and 3 or 2
		local param = {exploreType, moneyType}
		local extendFun = function( param )
			ElfinCC:req_extend_explore_duration(param[1], param[2])
		end
		MallModel:handle_auto_buy(money, extendFun, param)
	end
	local times = _extendExploreDtTimes
	local dt = ElfinConfig:getAddExploreTimeOnce()
	local dtStr = Utils:formatTime(dt, true)
	local content = string.format("增加%s探险时间需要%d元宝/绑元#r今日已增加次数：%d", dtStr, money, times)
	ConfirmWin2:show(4, 0, content, confirmFun)
end

-- 请求穿装备
function ElfinModel:reqEquip( item )
	ElfinCC:req_wear_equipment(item.itemCDKey, 0)
end

-- 请求打开青铜宝箱
function ElfinModel:reqOpenBronzeBox( )
	local needItem = ElfinConfig:getBronzeKeyItemId()
	local count = ItemModel:get_item_count_by_id(needItem)
	local itemName = ItemConfig:get_item_name_by_item_id(needItem)
	if count > 0 then
		-- 如果背包拥有青铜秘匙，则可以打开青铜宝箱
		local openFun = function( )
			ElfinCC:req_open_bronze_box()
		end
		local content = string.format("打开青铜宝箱需要%d把%s", 1, itemName)
		ConfirmWin2:show(4, 0, content, openFun)
	else
		local mallFun = function( )
			UIManager:show_window("mall_win")
		end
		local content = string.format("您没有%s，是否前往商城购买", itemName)
		ConfirmWin2:show(4, 0, content, mallFun)
	end
end

-- 打开青铜宝箱回调
function ElfinModel:doOpenBronzeBox( item )
	ElfinModel:doAddBagItem(item)
	ElfinModel:updateRightWin("openBronzeBox", {item})
end

-- 双击使用背包物品
function ElfinModel:useBagItemByDbClick( item )
	local isEquip = ElfinModel:checkIsEquip(item.itemType)
	if isEquip then
		ElfinModel:reqEquip(item)
	else
		if item.itemType == 10 then
			-- 如果是青铜宝箱
			local isBagFull = ElfinModel:checkBagFull()
			if not isBagFull then
				-- 背包未满，打开宝箱
				ElfinModel:reqOpenBronzeBox()
			else
				ElfinModel:handleBagFunll()
			end
		end
	end
end

-- 双击取出仓库物品
function ElfinModel:getOutStorageItemByDbClick( item )
	local isBagFull = ElfinModel:checkBagFull()
	if not isBagFull then
		ElfinCC:req_get_out_from_storage(item.itemCDKey)
	else
		ElfinModel:handleBagFunll()
	end
end

-- 取出所有仓库物品
function ElfinModel:getOutAllStorageItem( )
	local isBagFull = ElfinModel:checkBagFull()
	if not isBagFull then
		ElfinCC:req_get_out_from_storage(0)
	else
		ElfinModel:handleBagFunll()
	end
end

-- 穿装备回调
function ElfinModel:doEquip( CDKey, equipIndex )
	local index = ElfinModel:findBagItemByCDKey(CDKey)
	if index then
		local item = _exploreBag[index]
		ElfinModel:removeBagItem(item.itemCDKey)

		local equips = ElfinModel:getEquips()
		if equips[equipIndex] then
			ElfinModel:doAddBagItem(equips[equipIndex])
		end
		
		item.itemIndex = equipIndex
		ElfinModel:changeEquipment(equipIndex, item)
		ElfinModel:updateLeftWin("changeEquipment", {equipIndex, item})
	end
end

-- 召唤黄金宝箱
function ElfinModel:reqCallGoldBox( )
	local callTimes = ElfinModel:getGoldBoxNum()
	local maxTimes = ElfinConfig:getGoldBoxMaxOpenTimes()
	if callTimes < maxTimes then
		local isBagFull = ElfinModel:checkBagFull()
		if not isBagFull then
			local moneyType = MallModel:get_only_use_yb() and 3 or 2
			local money = ElfinConfig:getGoldBoxOpenCost()
			local param = {moneyType}
			local callFun = function( param )
				ElfinCC:req_call_gold_box(param[1])
			end
			MallModel:handle_auto_buy(money, callFun, param)
		else
			ElfinModel:handleBagFunll()
		end
	else
		GlobalFunc:create_screen_notic("今天召唤次数达到上限")
	end
end

-- 召唤黄金宝箱回调
function ElfinModel:doCallGoldBox( item )
	ElfinModel:doAddBagItem(item)
	ElfinModel:updateRightWin("openGoldBox", {item})
end

-- 请求脱下装备
function ElfinModel:reqDropEquipment( item )
	local isBagFull = ElfinModel:checkBagFull()
	if not isBagFull then
		ElfinCC:req_takeoff_equipment(item.itemIndex)
	else
		ElfinModel:handleBagFunll()
	end
end

-- 脱下装备回调
function ElfinModel:doDropEquipment( index )
	local equips = ElfinModel:getEquips()
	local item = equips[index]
	-- 如果当前选中了该装备，要先取消选中
	local selectedEquip = ElfinModel:getClickElfinItem()
	if selectedEquip then
		local idx = selectedEquip:getIndex()
		local selectedItem = ElfinModel:getEquipItemByIndex(idx)
		if selectedItem.itemCDKey == item.itemCDKey then
			ElfinModel:setClickElfinItem(nil)
		end
	end

	ElfinModel:doAddBagItem(item)

	ElfinModel:changeEquipment(index, nil)
	ElfinModel:updateLeftWin("dropEquipment", {index})
	ElfinModel:updateRightWin("dropEquipment", {index})
end

function ElfinModel:setExploreType( exploreType )
	_exploreType = exploreType
end

function ElfinModel:getExploreType( )
	return _exploreType
end

-- 请求探险
function ElfinModel:reqExplore( exploreType )
	local exploreName = {"普通探险", "精英探险", "英雄探险", "炼狱探险"}
	local curExplore = ElfinModel:getExploreType()
	if curExplore ~= 0 then
		local isStorageEmpty = ElfinModel:checkStorageEmpty()
		if isStorageEmpty then
			if curExplore ~= exploreType then
				local content = string.format("您正在进行#cfff000%s#cffffff，确定要切换为#cfff000%s#cffffff吗？（探险历时将会重新计算）", exploreName[curExplore], exploreName[exploreType])
				local exploreFun = function( )
					ElfinCC:req_explore(exploreType)
				end
				ConfirmWin2:show(4, 0, content, exploreFun)
			end
		else
			GlobalFunc:create_screen_notic(string.format("请先提取%s探险奖励", exploreName[curExplore]))
		end
	else
		ElfinCC:req_explore(exploreType)
	end
end

-- 查看探险状态回调
function ElfinModel:doExploreStatus( exploreType, duration )
	ElfinModel:setExploreType(exploreType)
	ElfinModel:updateRightWin("timer", {exploreType, duration})
	ElfinModel:showGetExploreAwardMiniBtn(exploreType, duration)
end

-- 取出仓库物品回调
function ElfinModel:doGetOutStorage( CDKey )
	if CDKey == 0 then
		local storageItems = {}
		for k,v in pairs(_exploreStorage) do
			table.insert(storageItems, v.itemCDKey)
		end
		for i,v in ipairs(storageItems) do
			local index = ElfinModel:findStorageItemByCDKey(v)
			local item = _exploreStorage[index]
			ElfinModel:doAddBagItem(item)
			-- ElfinModel:removeStorageItem(v)
		end
		_exploreStorage = {}
		ElfinModel:updateLeftWin("removeAllStorageItems")
	else
		local index = ElfinModel:findStorageItemByCDKey(CDKey)
		local item = _exploreStorage[index]
		ElfinModel:doAddBagItem(item)
		ElfinModel:removeStorageItem(CDKey)
	end
end

function ElfinModel:setExploreLevel( exploreLevel )
	_exploreLevel = exploreLevel
end

function ElfinModel:getExploreLevel( )
	return _exploreLevel
end

-- 探险级别开启回调
function ElfinModel:doOpenExploreLevl( exploreLevel )
	ElfinModel:setExploreLevel(exploreLevel)
	ElfinModel:updateRightWin("openExploreLevel", {exploreLevel})
end

-- 领取探险奖励回调
function ElfinModel:doGetExploreAward( duration, smelt, itemList )
	ElfinModel:updateLeftWin("getExploreAward", {duration, smelt})
	for i,v in ipairs(itemList) do
		ElfinModel:doAddStorageItem(v)
	end
end

-- 背包中相同类型基础属性最高的装备
function ElfinModel:getHighestItemByType( typeId )
	local higher = nil
	local higherVal = 0
	if _exploreBag then
		for i,v in pairs(_exploreBag) do
			if v.itemType == typeId then
				if v.itemBaseVal > higherVal then
					higher = v
					higherVal = v.itemBaseVal
				end
			end
		end
	else
		_exploreBag = {}
	end
	return higher
end

function ElfinModel:getHighestItems( )
	local items = {}
	if _exploreBag then
		local allType = ElfinConfig:getEquipItemsType()
		for i,v in ipairs(allType) do
			local item = ElfinModel:getHighestItemByType(v)
			table.insert(items, item)
		end
	end
	return items
end

function ElfinModel:getEquipmentByType( typeId )
	local equips = ElfinModel:getEquips()
	for k,v in pairs(equips) do
		if v.itemType == typeId then
			return v
		end
	end
	return nil
end

function ElfinModel:checkItemHigherThanEquipment( item )
	local items = ElfinModel:getHighestItems()
	for i,v in ipairs(items) do
		if item.itemCDKey == v.itemCDKey then
			local equipment = ElfinModel:getEquipmentByType(item.itemType)
			if equipment then
				if item.itemBaseVal > equipment.itemBaseVal then
					return true
				else
					return false
				end
			else
				return true
			end
		end
	end
	return false
end

-- 设置熔炼值
function ElfinModel:setSmeltVal( smelt )
	_smeltVal = smelt
end

function ElfinModel:getSmeltVal( )
	return _smeltVal
end

function ElfinModel:rerangeBag( )
	if _exploreBag then
		local tmpBag = ElfinModel:copyBag()
		ElfinModel:sortTable(tmpBag, function(u, v)
			return u.itemQlty > v.itemQlty
		end)
		for i,v in ipairs(tmpBag) do
			v.itemIndex = i
		end
		_exploreBag = tmpBag
		ElfinModel:updateRightWin("rerangeBag")
	else
		_exploreBag = {}
	end
end

function ElfinModel:sortTable( table, comps )
	if comps then
		local function selectionSort(array)
	        local len = #array
	        local temp = nil
	        for i = 1, len-1 do
	            local max = array[i];
	            for j = i + 1, len do
	                if comps(array[j], max) then
	                    temp = max;
	                    max = array[j];
	                    array[j] = temp;
	                end
	            end
	            array[i] = max;
	        end
	        return array;
	    end
	    table = selectionSort(table)
	end
	return table
end

function ElfinModel:checkExploreStorageFull( exploreType, duration )
	if exploreType > 0 then
		if ElfinModel:checkStorageFull() then
			return true
		else
			local remainNum = ElfinModel:getStorageRemainNum()
			local awardTime = ElfinConfig:getEquipAwardTime(exploreType)
			local awardNum = math.floor(duration/awardTime)
			return awardNum >= remainNum
		end
	end
	return false
end

function ElfinModel:showGetExploreAwardMiniBtn( exploreType, duration )
	if exploreType > 0 then
		local btnFun = function( )
			local win = UIManager:show_window("elfin_left_win")
			if win then
				ElfinModel:changeLeftPage(ElfinModel.ELFIN_ITEM_LEFT_PAGE)
				ElfinModel:updateLeftWin("getAward")
			end
		end
		if ElfinModel:checkExploreStorageFull(exploreType, duration) then
			MiniBtnWin:show(24, btnFun)
		else
			local remainNum = ElfinModel:getStorageRemainNum()
			local awardTime = ElfinConfig:getEquipAwardTime(exploreType)
			local awardNum = (duration/awardTime)
			local availableNum = remainNum - awardNum
			if availableNum > 0 then
				local remainDt = availableNum * awardTime
				if not _exploreTimer then
					_exploreTimer = callback:new()
				else
					_exploreTimer:cancel()
				end
				_exploreTimer:start(remainDt, function( )
					MiniBtnWin:show(24, btnFun)
				end)
			else
				MiniBtnWin:show(24, btnFun)
			end
		end
	end
end
