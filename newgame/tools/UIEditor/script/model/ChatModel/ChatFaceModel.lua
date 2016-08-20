-------------------------HJH
-------------------------2013-1-16
-------------------------聊天表情MODE
-------------------------
-- super_class.ChatFaceModel()
ChatFaceModel = {}
local _face_type = 1
local _clear_and_refresh_item = true
local _clear_and_refresh_face = true
local _cur_active_win = nil
-- local _chat_info_head_target = "#"
-- local _chat_info_sprte_target = "~"
-- local _chat_info_data_target = ","
local _chat_face_file = "chat_face/"
-------------------------
local _chat_face_info = {
					2, 2, 2, 2, 2,
					2, 2, 2, 4, 6,
					2, 5, 2, 8, 5,
					2, 2, 2, 2, 2,
					2, 1, 2, 2, 4,
					2, 6, 2, 7, 2,
					2, 2, 2, 2, 2,
					2, 2, 4, 2, 5,
					2, 2, 4, 2, 2,
					2, 2, 2, 2, 4
				}
-------------------------设置当前激活面板
-- added by aXing on 2013-5-25
function ChatFaceModel:fini()
	-- TODO:: something
	_face_type = 1
	_cur_active_win = nil
	_clear_and_refresh_item = true
	_clear_and_refresh_face = true
end
-------------------------
function ChatFaceModel:get_need_clear_and_refresh()
	if  _face_type == 1 and _clear_and_refresh_face == true then
		return true
	end
	if _face_type == 2 and _clear_and_refresh_item == true  then
		return true
	end
	return false
end
-------------------------
function ChatFaceModel:get_need_clear_and_refresh_face()
	return _clear_and_refresh_face
end
-------------------------
function ChatFaceModel:set_need_clear_and_refresh_face(result)
	_clear_and_refresh_face = result
	local chat_face_win = UIManager:find_visible_window("chat_face_win")
	if chat_face_win ~= nil and _face_type == 1 and _clear_and_refresh_face == true then
		chat_face_win:clear_scroll()
		chat_face_win:refresh_scroll()
		_clear_and_refresh_face = false
	end
end
-------------------------
function ChatFaceModel:get_need_clear_and_refresh_item()
	return _clear_and_refresh_item
end
-------------------------
function ChatFaceModel:set_need_clear_and_refresh_item(result)
	_clear_and_refresh_item = result
	local chat_face_win = UIManager:find_visible_window("chat_face_win")
	if chat_face_win ~= nil and _face_type == 2 and _clear_and_refresh_item == true then
		chat_face_win:clear_scroll()
		chat_face_win:refresh_scroll()
		_clear_and_refresh_item = false
	end
end
-------------------------
function ChatFaceModel:set_cur_atcive_win(curwin)
	_cur_active_win = curwin
end
-------------------------表情隐藏函数
function ChatFaceModel:hide_face_fun(curpage)
	UIManager:hide_window("chat_face_win")
	if _cur_active_win == _cur_active_win then
		_cur_active_win = nil
	end
end
-------------------------表情退出函数
function ChatFaceModel:exit_btn_fun()
	local face_win = UIManager:find_window("chat_face_win")
	face_win:set_exit_btn_visible(false)
	UIManager:hide_window("chat_face_win")
end
-------------------------设置表情类型，表情或背包
function ChatFaceModel:set_chat_face_type(ttype)
	local temp_type = _face_type
	if temp_type ~= ttype then
		if ttype == 1 then
			_clear_and_refresh_face = true
		else
			_clear_and_refresh_item = true
		end
	end
	_face_type = ttype
end
-------------------------取得当前表情类型
function ChatFaceModel:get_chat_face_type()
	return _face_type
end
-------------------------
function ChatFaceModel:scroll_create_fun(index)
	-------------------------
	require "UI/component/List"
	local face_win = UIManager:find_window("chat_face_win")
	local scrollInfo = face_win:get_scroll_info()
	local list_info = {vertical = 10, horizontal = 2}
	-------------------------
	local page = ZList:create( nil, 0, 0, scrollInfo.width, scrollInfo.height, list_info.vertical, list_info.horizontal)
	page.view:setAddType(TYPE_HORIZONTAL)
	local bagData,bagNum 
	if _face_type == 2 then 
		bagData = ChatModel:get_bag_info()
		bagNum = #bagData
		--bagData,bagNum = ItemModel:get_bag_data()
	end
	if _face_type == 1 then
		face_win.scroll.view:setMaxNum(3)
		if _clear_and_refresh_face then
			_clear_and_refresh_face = false
		end
	else
		if _clear_and_refresh_item then
			_clear_and_refresh_item = false
		end
		local tempNum = 1
		if bagNum > list_info.vertical * list_info.horizontal then
			tempNum = tempNum + bagNum / ( list_info.vertical * list_info.horizontal )
		end
		face_win.scroll.view:setMaxNum(tempNum)
	end
	--print("_face_type", _face_type)
	-------------------------
	for i = 1 , list_info.vertical * list_info.horizontal do
		local tempIndex = index * list_info.vertical * list_info.horizontal + i
		--print("_face_type,tempIndex,bagNum",_face_type,tempIndex,bagNum )
		local item = nil
		if _face_type == 1 then
			if tempIndex >= #_chat_face_info then
				break
			end
			item = ChatFaceModel:create_face_item( tempIndex , list_info)
		elseif tempIndex <= bagNum then
			--local temp_bag_data = ItemModel:get_item_by_series( bagData[i].series )
			item = ChatFaceModel:create_bag_item( tempIndex ,  bagData[tempIndex] )
		end
		if item ~= nil then
			page:addItem(item)
		end
	end
	return page
end
-------------------------表情项创建函数
function ChatFaceModel:create_face_item( index , list_info)
	require "UI/component/BasePanel"
	require "config/ChatConfig"
	local face_win = UIManager:find_window("chat_face_win")
	local scrollInfo = face_win:get_scroll_info()
	local file = string.format("%s%d",_chat_face_file, index)
	local basepanel = ZBasePanel:create( nil, nil, 0, 0, scrollInfo.width / list_info.vertical, scrollInfo.height / list_info.horizontal )--CCBasePanel:panelWithFile(0, 0, 0, 0, NULL)
	--local action = ZXAnimation:createAnimationAction(0, 0, _chat_face_info[index], 0.2)
	local icon = ZXAnimation:createWithFileName(file)
	icon:replaceZXAnimationAction(0, 0, _chat_face_info[index], 0.2)
	icon:setDefaultAction(0)
	local fistframe = string.format("%s%s", file, "/00000.png")
	local iconimage = ZXAnimateSprite:createWithFileAndAnimation("", icon)
	local iconsize = iconimage:getFirstFrameSize()
	iconimage:setAnchorPoint(CCPointMake(0,0))
	-- local spriteinfo = string.format("%d%s%d%s%d%s%s",
	-- 	ChatConfig.ChatSpriteType.TYPE_ANIMATE, ChatConfig.message_split_target.CHAT_INFO_HEAD_TARGET,
	--  	ChatConfig.ChatAdditionInfo.TYPE_FACE, ChatConfig.message_split_target.CHAT_INFO_HEAD_TARGET, 
	--  	index, ChatConfig.message_split_target.CHAT_INFO_HEAD_TARGET,
	--  	"")
	local tempnode = CCNode:node()
	--tempnode:setAnchorPoint(CCPointMake(0,0))
	-- tempnode:setPosition(CCPointMake( (scrollInfo.width / 10 - iconsize.width) / 2, (scrollInfo.height / 2 - iconsize.height) / 2 ) )
	--tempnode:setAnchorPointEx(0,0)
	tempnode:setPositionX( (scrollInfo.width / list_info.vertical - iconsize.width) / 2 )
	tempnode:setPositionY( (scrollInfo.height / list_info.horizontal - iconsize.height) / 2 )
	tempnode:addChild(iconimage)
	--basepanel.view:setDataInfo(spriteinfo)
	basepanel.view:addChild(tempnode)
	-----------
	local function face_click_fun()
		local id = index
		-- local info = spriteinfo
		-- require "model/Hyperlink"
		-- local tempinfo = Utils:Split(info, ChatConfig.message_split_target.CHAT_INFO_HEAD_TARGET)
		-- local file = Hyperlink.ChatFaceInfo[tonumber(tempinfo[3])]
		local chat_win = UIManager:find_visible_window("chat_win")
		local private_win = UIManager:find_visible_window("chat_private_win")
		local xz_win = UIManager:find_visible_window("chat_xz_win")
		if _cur_active_win ~= nil then
			_cur_active_win:set_insert_info( string.format( "%s%d%s", "<", id, ">" ) )
			--_cur_active_win:set_insert_info( string.format("##animate,%s#info%s ##",file.info,info ) )
		end
		UIManager:hide_window("chat_face_win")
		-- print("chat_win",chat_win)
		-- print("private_win",private_win)
		-- print("xz_win",xz_win)
		-- if private_win ~= nil then
		--  	private_win:set_insert_info( string.format("##animate,%s#info%s ##",file.info,info ) )
		--  	UIManager:hide_window("chat_face_win")
		-- elseif xz_win ~= nil then
		-- 	xz_win:set_insert_info( string.format("##animate,%s#info%s ##",file.info, info) )
		-- 	UIManager:hide_window("chat_face_win")
		-- elseif chat_win ~= nil then
		-- 	local insert = chat_win:get_insert_target()
		-- 	insert:inert_edit_box_info( string.format("##animate,%s#info%s ##",file.info,info) )
		-- end	
	end
	basepanel:setTouchClickFun(face_click_fun)
	return basepanel
end
-------------------------背包项创建函数
function ChatFaceModel:create_bag_item(index, bagData)
	--local bagData,bagNum = ItemModel:get_bag_data()
	--local tempindex = tempx * vertical * horizontal
	require "UI/component/BasePanel"
	local face_win = UIManager:find_window("chat_face_win")
	local scrollInfo = face_win:get_scroll_info()
	local basepanel = ZBasePanel:create(nil, nil, 0, 0, scrollInfo.width, scrollInfo.height)--CCBasePanel:panelWithFile(0, 0, 0, 0, NULL)
	local file = ItemConfig:get_item_icon(bagData.item_id)
	local btn = CCZXImage:imageWithFile(0, 0, 60, 60, file)
	local btnSize = btn:getSize()
	local item_info =  ItemModel:get_item_by_series( bagData.series )
	print( string.format("cur item %s",ItemConfig:get_item_name_by_item_id( bagData.item_id ) ) )
	local qualityGrid = CCZXImage:imageWithFile(0, 0, 62, 62, ChatFaceModel:item_quality_grid(item_info.quality))
	local qualityGridSize = qualityGrid:getSize()
	qualityGrid:setDefaultMessageReturn(false)
	btn:setDefaultMessageReturn(false)
	-- local spriteInfo = string.format("%d%s%d%s%d%s%s%s,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d",
	-- 	ChatConfig.ChatSpriteType.TYPE_TEXTBUTTON, ChatConfig.message_split_target.CHAT_INFO_HEAD_TARGET, 
	-- 	ChatConfig.ChatAdditionInfo.TYPE_ITEM, ChatConfig.message_split_target.CHAT_INFO_HEAD_TARGET,
	-- 	bagData.item_id, ChatConfig.message_split_target.CHAT_INFO_HEAD_TARGET, 
	-- 	Hyperlink:get_first_view_target(), Hyperlink:get_second_item_target(),
	-- 	bagData.series, bagData.item_id, bagData.quality, bagData.strong, bagData.duration,
	-- 	bagData.duration_max, bagData.count, bagData.flag, bagData.holes[1], bagData.holes[2],
	-- 	bagData.holes[3], bagData.deadline, 0, 0, bagData.smith_num, bagData.smiths[1].type, 
	-- 	bagData.smiths[1].value, bagData.smiths[2].type,bagData.smiths[2].value, bagData.smiths[3].type, bagData.smiths[3].value)
	--basepanel.view:setDataInfo(spriteInfo)
	btn:setPosition( (scrollInfo.width / 10 - btnSize.width) / 2, (scrollInfo.height / 2 - btnSize.height) / 2 )
	basepanel.view:addChild(btn)
	qualityGrid:setPosition( (scrollInfo.width / 10 - qualityGridSize.width) / 2, (scrollInfo.height / 2 - qualityGridSize.height) / 2 )
	basepanel.view:addChild(qualityGrid)
	-----------
	local function item_click_fun()
		local id = bagData.series
		--local info = spriteInfo
		--print("spriteInfo",spriteInfo)
		-- local tempInfo = Utils:Split(info,"#")
		-- local itemInfo = Utils:Split(tempInfo[4], ",")
		-- local item = UserItem()
		-- item.series 		= tonumber(itemInfo[2])				-- 物品唯一的一个序列号
		-- item.item_id		= tonumber(itemInfo[3])				-- 标准物品id
		-- item.quality		= tonumber(itemInfo[4])				-- 物品品质等级
		-- item.strong			= tonumber(itemInfo[5])				-- 物品强化等级
		-- item.duration		= tonumber(itemInfo[6])				-- 物品耐久度
		-- item.duration_max	= tonumber(itemInfo[7])				-- 物品耐久度最大值
		-- item.count			= tonumber(itemInfo[8])				-- 此物品的数量，默认为1，当多个物品堆叠在一起的时候此值表示此类物品的数量
		-- item.flag			= tonumber(itemInfo[9])				-- 物品标志，使用比特位标志物品的标志，例如绑定否
		-- item.holes[1]		= tonumber(itemInfo[10])				-- 宝石孔
		-- item.holes[2]		= tonumber(itemInfo[11])
		-- item.holes[3]		= tonumber(itemInfo[12])			
		-- item.deadline		= tonumber(itemInfo[13])			-- 道具使用时间
		-- local void_byte 	= tonumber(itemInfo[14])	
		-- item.smith_num		= tonumber(itemInfo[15])			-- 物品的洗炼属性开启个数
		-- item.smiths[1]		= tonumber(itemInfo[16])
		-- item.smiths[2]		= tonumber(itemInfo[17])
		-- item.smiths[3]		= tonumber(itemInfo[18])
		-- TipsWin:showTip(300, 200, item, nil, nil, false)
		print("run chat_face_model id",id)
		local item_info = ChatModel:data_find_bag_item_info_by_id( id )
		if item_info ~= nil then
			local item = item_info:get_user_item_info()
			local temp_pos = basepanel.view:getPositionS()
			local show_pos = basepanel.view:getParent():convertToWorldSpace( CCPointMake(temp_pos.x, temp_pos.y ))
			TipsModel:show_tip( show_pos.x,show_pos.y,item)
		end

	end
	-----------
	local function item_double_click_fun()
		local id = bagData.series
		--local info = spriteInfo
		local chat_win = UIManager:find_visible_window("chat_win")
		if chat_win ~= nil then
			local item_info = ChatModel:data_find_bag_item_info_by_id( id )
			local temp_info = item_info:format_show_info()
			chat_win:get_insert_target():inert_edit_box_info( temp_info )
			-- local itemheadinfo = Utils:Split(info, ChatConfig.message_split_target.CHAT_INFO_HEAD_TARGET)
			-- local itemname = ItemConfig:get_item_name_by_item_id(tonumber(itemheadinfo[3]))
			-- local iteminfo = Utils:Split(itemheadinfo[4],ChatConfig.message_split_target.CHAT_INFO_DATA_TARGET)
			-- local itemColor = ItemConfig:get_item_color(tonumber(iteminfo[4]) + 1)
			--chat_win:get_insert_target():inert_edit_box_info( string.format("##textbutton,[#c%s%s#cffffff]#info%s##",itemColor,itemname,info) )
			-- local private_win = UIManager:find_visible_window("chat_private_win")
			-- if private_win ~= nil then
			-- 	UIManager:hide_window("chat_face_win")
			-- end
		end
		UIManager:hide_window("chat_face_win")
	end
	--basepanel:setMessageIndex(starMsg + tempindex + i)
	--facelist:addItem(basepanel)
	basepanel:setTouchClickFun(item_click_fun)
	basepanel:setTouchDoubleClickFun(item_double_click_fun)
	basepanel.view:setEnableDoubleClick(true)
	return basepanel
	--return facelist
end
-------------------------给与道具品质返回对应品质格
function ChatFaceModel:item_quality_grid(quality)
	local file = {
	UIResourcePath.FileLocate.lh_normal .. "item_frame_1.png",
	UIResourcePath.FileLocate.lh_normal .. "item_frame_2.png",
	UIResourcePath.FileLocate.lh_normal .. "item_frame_3.png",
	UIResourcePath.FileLocate.lh_normal .. "item_frame_4.png",
	UIResourcePath.FileLocate.lh_normal .. "item_frame_5.png",
	UIResourcePath.FileLocate.lh_normal .. "item_frame_6.png"}
	return file[quality + 1]
end
