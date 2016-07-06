--ItemTips.lua

ItemTips = {}

local _file = {
	bg_img = _PATHE_COMMON_BG_IMG, --背景
	tag =  AutoTips.TAG_DIRECTION_V,--方向 竖向

	{ 
	tag =  AutoTips.TAG_DIRECTION_H,
		{type=AutoTips.TYPE_IMG,value = "ui/audio_btn_press.png",target="icon"},
		{type=AutoTips.TYPE_LABEL,value = "道具名称",target="name",xOffset = 0,	yOffset = 0,},
	},

	{ 
	tag =  AutoTips.TAG_DIRECTION_H,
		{type=AutoTips.TYPE_LABEL,value = "使用等级：",size=20,target="level",yOffset = 0,},
		{type=AutoTips.TYPE_LABEL,value = "是否绑定",target="banding"},
	},

	{ 
	tag =  AutoTips.TAG_DIRECTION_V,
		{type=AutoTips.TYPE_TEXT,value = "物品说明奥斯卡飞机冻死了asddsflsld;;a副驾驶的路费",
		target="name"},

	},
	{ 
	tag =  AutoTips.TAG_DIRECTION_V,
		{type=AutoTips.TYPE_LABEL,value = "可否交易",target="jiaoyi"},
		{type=AutoTips.TYPE_LABEL,value = "可否出售",target="chushou"},
		{type=AutoTips.TYPE_LABEL,value = "可否绑定",target="band"},
	},

		--按钮配置 用数组
	btn = {
		{
			value = "使用", --按钮文字
			target="shiyong", --按钮target 回调使用
			normal_img = _PATH_COMMON_BTN_NORMAL, --正常图片 --没有这个字段使用默认资源
			press_img = _PATH_COMMON_BTN_PRESS,  --按下图片 --没有这个字段使用默认资源
			size=30, --按钮文字字体大小
			scale_x = 0.5,
			scale_y = 0.7,
		},
		{value = "存入",target="cunru",size=30,xOffset = -30,scale_x = 0.5,scale_y = 0.7,},
		--{value = "丢弃",target="duiqi",size=20,xOffset = 30,	yOffset = 0,},
	},

}

--根据不同需求 可以写多个创建方法，主要是数据组织
--创建道具tips函数
--id 道具ID
function ItemTips:create( id )
	local date = self:get_date_by_id( id )
	local item_tips =  AutoTips:create(date,_file)
 
	return item_tips
end

function ItemTips:get_date_by_id( id )
	local date = {}
	--根据配置获取数据
	--组织数据
	--date.cunru =  AutoTips._NO_CREATE_VALUE
	date.jiaoyi = AutoTips._NO_CREATE_VALUE
	date.banding = "已绑定"
	return date
end
