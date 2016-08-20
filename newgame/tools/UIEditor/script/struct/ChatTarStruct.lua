-------------------HJH
--------------------2013-6-27
--------------------
super_class.ChatTarCountStruct()
--------------------
function ChatTarCountStruct:__init(item_id)
	self.item_id = item_id
	self.count = 1
	self.count_index = 0
end
--------------------
super_class.ChatTarStruct()
--------------------
function ChatTarStruct:__init(series, item_id, name, index, tar_type)
	self.series = series
	self.item_id = item_id
	self.name = name
	self.index = index
	--self.show_name = show_name
	self.tar_type = tar_type
end
--------------------格式化成发送信息
function ChatTarStruct:format_send_info()
	local spriteInfo
	if self.tar_type == ChatConfig.ChatTarType.TYPE_ITEM then
		local bagData = ItemModel:get_item_by_series( self.series )
		spriteInfo = string.format("%d%s%d%s%d%s%s%s,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d",
								ChatConfig.ChatSpriteType.TYPE_TEXTBUTTON, ChatConfig.message_split_target.CHAT_INFO_HEAD_TARGET, 
								ChatConfig.ChatAdditionInfo.TYPE_ITEM, ChatConfig.message_split_target.CHAT_INFO_HEAD_TARGET,
								bagData.item_id, ChatConfig.message_split_target.CHAT_INFO_HEAD_TARGET, 
								Hyperlink:get_first_view_target(), Hyperlink:get_second_item_target(),
								bagData.series, bagData.item_id, bagData.quality, bagData.strong, bagData.duration,
								bagData.duration_max, bagData.count, bagData.flag, bagData.holes[1], bagData.holes[2],
								bagData.holes[3], bagData.deadline, bagData.void_bytes_tab[1], bagData.void_bytes_tab[2],
								bagData.void_bytes_tab[3], bagData.void_bytes_tab[4], bagData.void_bytes_tab[5], bagData.void_bytes_tab[6],
								bagData.void_bytes_tab[7], bagData.void_bytes_tab[8], bagData.smith_num, bagData.smiths[1].type, 
								bagData.smiths[1].value, bagData.smiths[2].type,bagData.smiths[2].value, bagData.smiths[3].type, bagData.smiths[3].value)
	elseif self.tar_type == ChatConfig.ChatTarType.TYPE_FACE then
		spriteInfo = string.format("%d%s%d%s%d%s%s",
								ChatConfig.ChatSpriteType.TYPE_ANIMATE, ChatConfig.message_split_target.CHAT_INFO_HEAD_TARGET,
							 	ChatConfig.ChatAdditionInfo.TYPE_FACE, ChatConfig.message_split_target.CHAT_INFO_HEAD_TARGET, 
							 	self.series, ChatConfig.message_split_target.CHAT_INFO_HEAD_TARGET,
							 	"")
	end
	return spriteInfo
end
--------------------
function ChatTarStruct:get_user_item_info()
	if self.tar_type == ChatConfig.ChatTarType.TYPE_ITEM then
		return ItemModel:get_item_by_series( self.series )
	end	
	return nil
end
--------------------
function ChatTarStruct:format_insert_info()
	if self.tar_type == ChatConfig.ChatTarType.TYPE_ITEM then
		return string.format( "[%s]", self.name )
	elseif self.tar_type == ChatConfig.ChatTarType.TYPE_FACE then
		return self.name
	end
end
--------------------格式化成输入框信息
function ChatTarStruct:format_show_info()
	if self.tar_type == ChatConfig.ChatTarType.TYPE_ITEM then
		local bagData = ItemModel:get_item_by_series( self.series )
		local itemColor = ItemConfig:get_item_color( bagData.quality + 1)
		local temp_index = ""
		if self.index >= 1 then
			temp_index = tostring( self.index )
		end
		return string.format( "[#c%s%s%s#cffffff]", itemColor, self.name, temp_index )
	else
		return self.name
	end
end
--------------------检查是否为同一物品
function ChatTarStruct:check_is_same_by_id( id )
	if self.user_item.series == id then
		return true
	else
		return false
	end
end
--------------------
function ChatTarStruct:chat_is_same_by_name( name )
	local temp_index = ""
	if self.index >= 1 then
		temp_index = tostring( self.index )
	end
	local temp_name = self.name .. temp_index
	if temp_name == name then
		return true
	else
		return false
	end
end
--------------------
super_class.ChatPrivateStruct()
--------------------
function ChatPrivateStruct:__init(id, name, qqvip, camp, level, sex, job)
	self.id = id
	self.name = name
	self.qqvip = qqvip
	self.camp = camp
	self.level = level
	self.sex = sex
	self.job = job
	self.chat_info = {}
	self.new_message_num = 0
end	