-----ChatConfig
-----HJH
-----2012-12-3
-----聊天

-- super_class.ChatConfig();
ChatConfig = {}
----聊天栏
ChatConfig.Chat_chanel = {
CHANNEL_SECRE 				= 0,					---私聊
CHANNEL_HEARSAY 			= 1, 					---传闻
CHANNEL_SPEAKER 			= 2,					---喇叭
CHANNEL_GUILD				= 3,					---帮派
CHANNEL_TEAM 				= 4,					---队伍
CHANNEL_GROUP 				= 5,					---团队
CHANNEL_MAP 				= 6,					---地图
CHANNEL_WORLD 				= 7,					---世界
CHANNEL_SCHOOL 				= 8,					---阵营
CHANNEL_SYSTEM				= 9,					---系统
CHANNEL_SOS 				= 10,					---求救
CHANNEL_ALL 				= 100,					---全部
}


----系统提示的子类型
ChatConfig.Chat_system_tip = {
SYSTEM_TIP_PANEL			= 0,					---右下角提示面板
SYSTEM_SCENE_CENTER			= 1,					---屏幕中央
SYSTEM_MSGBOX				= 2,					---弹出框
SYSTEM_BROADCAST			= 3,					---公告栏
SYSTEM_WARNING				= 4,					---屏幕中央
SYSTEM_WARM_TIP				= 5,					---温馨提示面板
SYSTEM_GM_MESSAGE			= 6,					---GM信息
SYSTEM_GM_CHAT				= 7,					---聊天栏系统
}


-----聊天的称号,指导,Vip之类
ChatConfig.Chat_title = {
TITLE_GUIDE = 1,					---指导员
TITLE_VIP = 2,						---VIP
CHIEF = 4,							---武林盟主
}

-----
ChatConfig.ChatAdditionInfo = {
TYPE_NONE					= 0,
TYPE_FACE					= 1,
TYPE_ITEM					= 2,
TYPE_PLAYER_NAME			= 3,
TYPE_POSITION				= 4,
TYPE_MOUNT					= 5,
TYPE_WING					= 6,
TYPE_FABAO					= 7,
TYPE_PET 					= 8,
TYPE_SPRITE					= 9,
TYPE_BOOK 					= 10,
}

-----
ChatConfig.ChatSpriteType = {
	TYPE_LABLE				= 0,
	TYPE_BUTTON				= 1,
	TYPE_TEXTBUTTON			= 2,
	TYPE_ANIMATE			= 4,
}

-----
ChatConfig.WinType = {
	TYPE_CHAT_INFO			= 1,
	TYPE_CHAT_INSERT		= 2,
	TYPE_CHAT_FACE			= 3,
	TYPE_CHAT_NAME_SELECT	= 4,
	TYPE_CHAT_CHANEL_SELECT = 5,
	TYPE_CHAT_SEND_FLOWER	= 6,
	TYPE_CHAT_PRIVATE_CHAT 	= 7,
}
----
ChatConfig.ChatFaceType = {
	TYPE_FACE 				= 0,
	TYPE_BAG				= 1,
}
----
ChatConfig.ChatTarType = {
	TYPE_FACE 				= 0,
	TYPE_ITEM				= 1,
}
----
ChatConfig.message_split_target = {
	CHAT_INFO_HEAD_TARGET = ";",
	CHAT_INFO_SPLITE_TARGET = "~",
	CHAT_INFO_DATA_TARGET = ",",
	CHAT_INFO_PRIVAT_TARGET = "@",
}
----
ChatConfig.PrivateChatType = {
	TYPE_AUTO_CHAT_INFO = 1,
	TYPE_NORMAL_CHAT_INFO = 2,
	TYPE_THANK_CHAT_INFO = 3,
}