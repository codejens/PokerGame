-------------------------HJH
-------------------------2013-1-16
-------------------------聊天信息栏MODE
-- require "config/ChatConfig"
---------------
-- super_class.ChatInfoMode()
ChatInfoMode = {}
-------------------------
local _chat_win_panel = nil
-------------------------
-- added by aXing on 2013-5-25
function ChatInfoMode:fini( ... )
	_chat_win_panel = nil
end
-------------------------
function ChatInfoMode:set_chat_win_panel(panel)
	_chat_win_panel = panel
end
-------------------------格式化聊天框频道信息
function ChatInfoMode:format_chat_chanel_info(chanelId)
	local returnInfo = {chanelIndex = 0 ,chanelName = ""}
	if chanelId == ChatConfig.Chat_chanel.CHANNEL_SECRE then
		returnInfo.chanelIndex = nil
	elseif chanelId == ChatConfig.Chat_chanel.CHANNEL_HEARSAY then
		returnInfo.chanelIndex = nil
	elseif chanelId == ChatConfig.Chat_chanel.CHANNEL_SPEAKER then
		returnInfo.chanelIndex = nil
	elseif chanelId == ChatConfig.Chat_chanel.CHANNEL_GUILD then
		returnInfo.chanelIndex = 4
		returnInfo.chanelName = Lang.chat.chanel_name[7] -- [7]="#cb4f000【仙宗】"
	elseif chanelId == ChatConfig.Chat_chanel.CHANNEL_TEAM then
		returnInfo.chanelIndex = 5
		returnInfo.chanelName = Lang.chat.chanel_name[8] -- [8]="#cfe9ccb【队伍】"
	elseif chanelId == ChatConfig.Chat_chanel.CHANNEL_GROUP then
		returnInfo.chanelIndex = nil
	elseif chanelId == ChatConfig.Chat_chanel.CHANNEL_MAP then
		returnInfo.chanelIndex = 6
		returnInfo.chanelName = Lang.chat.chanel_name[9] -- [9]="#cfefefe【附近】"
	elseif chanelId == ChatConfig.Chat_chanel.CHANNEL_WORLD then
		returnInfo.chanelIndex = 2
		returnInfo.chanelName = Lang.chat.chanel_name[10] -- [10]="#c2eebdb【世界】"
	elseif chanelId == ChatConfig.Chat_chanel.CHANNEL_SCHOOL then
		returnInfo.chanelIndex = 3
		returnInfo.chanelName = Lang.chat.chanel_name[11] -- [11]="#cb4f000【阵营】"
	elseif chanelId == ChatConfig.Chat_chanel.CHANNEL_SYSTEM then
		returnInfo.chanelIndex = 2
		returnInfo.chanelName = Lang.chat.chanel_name[12] -- [12]="#cff0000【系统】"
	elseif chanelId == ChatConfig.Chat_chanel.CHANNEL_SOS then
		returnInfo.chanelIndex = nil
	end
	return returnInfo
end
-------------------------格式化聊天框阵营信息
function ChatInfoMode:format_chat_camp_info(campId)
	-----
	local returnInfo = {campName = "", color = ""}
	if campId == GameConfig.CAMP_XIAOYAO then
		returnInfo.color = "#cff1493"
		returnInfo.campName = Lang.camp_info[1] -- [1]="#cff1493[逍遥]"
	elseif campId == GameConfig.CAMP_XINGCHEN then
		returnInfo.color = "#c0000ff"
		returnInfo.campName = Lang.camp_info[2] -- [2]="#c0000ff[星辰]"
	elseif campId == GameConfig.CAMP_YIXIAN then
		returnInfo.color = "#c00ff00"
		returnInfo.campName = Lang.camp_info[3] -- [3]="#c00ff00[逸仙]"
	end
	return returnInfo
end
-------------------------格式化聊天框性别信息
function ChatInfoMode:format_chat_sex_info(setxType)
	if setxType == GameConfig.SEX_MALE then
		return Lang.sex_info[1] -- [44]="#c00c0ff♂"
	else
		return Lang.sex_info[2] -- [45]="#cff00ff♀"
	end	
end
-------------------------格式化聊天框VIP信息
function ChatInfoMode:format_chat_vip_info(vipType)
	if vipType == 1 then
		return "VIP "
	end
end
-------------------------格式化聊天名字信息
function ChatInfoMode:format_chat_name_info(msgInfo, color, type, name, id, sex, vip, campId, job, level, iconId, yeallowDiamon)
	local info = string.format("##textbutton,%s%s#info,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s##:%s",color, name, type, name, id, sex, vip,
								campId, job, level, iconId, yeallowDiamon, msgInfo)
	return info
end
-------------------------聊天内容按钮方法
function ChatInfoMode:run_chat_info(targetItem, x, y)
	local tempinfo = targetItem:getDataInfo()
	-- print("tempinfo",tempinfo)
	local info = Utils:Split(tempinfo,",")
	if info ~= nil then
		local tarType = tonumber(info[2])
		if tarType == ChatConfig.ChatAdditionInfo.TYPE_PLAYER_NAME then
			_chat_win_panel:setIndexPanelVisible(ChatConfig.WinType.TYPE_CHAT_NAME_SELECT, true)
			_chat_win_panel:initNameSelectInfo(info)
		elseif tarType == ChatConfig.ChatAdditionInfo.TYPE_ITEM then 
			local item = UserItem()
			item.series 		= tonumber(info[3])				-- 物品唯一的一个序列号
			item.item_id		= tonumber(info[4])				-- 标准物品id
			item.quality		= tonumber(info[5])				-- 物品品质等级
			item.strong			= tonumber(info[6])				-- 物品强化等级
			item.duration		= tonumber(info[7])				-- 物品耐久度
			item.duration_max	= tonumber(info[8])				-- 物品耐久度最大值
			item.count			= tonumber(info[9])				-- 此物品的数量，默认为1，当多个物品堆叠在一起的时候此值表示此类物品的数量
			item.flag			= tonumber(info[10])			-- 物品标志，使用比特位标志物品的标志，例如绑定否
			item.holes[1]		= tonumber(info[11])			-- 宝石孔
			item.holes[2]		= tonumber(info[12])
			item.holes[3]		= tonumber(info[13])			
			item.deadline		= tonumber(info[14])			-- 道具使用时间
			local void_byte 	= tonumber(info[15])	
			item.smith_num		= tonumber(info[16])			-- 物品的洗炼属性开启个数
			item.smiths[1]		= tonumber(info[17])
			item.smiths[2]		= tonumber(info[18])
			item.smiths[3]		= tonumber(info[19])
			TipsWin:showTip(300, 200, item, nil, nil, false)
		end
	end
end
-------------------------
