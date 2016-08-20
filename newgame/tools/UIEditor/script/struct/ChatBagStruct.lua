-------------------HJH
--------------------2013-6-27
super_class.ChatBagStruct()
--------------------
function ChatBagStruct:__init(series, item_id, inser_name)
	self.seeries = series
	self.item_id = item_id
	self.inser_name = inser_name
end
--------------------格式化成发送信息
function ChatBagStruct:format_send_info()

end
--------------------格式化成输入框信息
function ChatBagStruct:format_insert_info()

end
--------------------检查是否为同一物品
function ChatBagStruct:check_is_same(id)
	if self.user_item.series == id then
		return true
	else
		return false
	end
end