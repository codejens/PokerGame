wujiang_yulan = {
	img_n="",
	child={
{	img_n="sui/wujiang/yulan_bg.png",
	flip={	false,		false,	},
	parent="win_root",
	class="SPanel",
	is_nine=true,
	name="mainPanel",
	size={	"756",
	"459",
},
	child={
{	img_n="nopack/BigImage/skill_yulan_bg.png",
	flip={	false,		false,	},
	parent="mainPanel",
	class="SPanel",
	is_nine=true,
	name="map_img",
	child={
{	img_n="sui/chat/chat_close.png",
	name="close_btn",
	pos={	677,		384,	},
	parent="map_img",
	class="SButton",
	zOrder=1,		size={	"44",
	"44",
},
},
},
	zOrder=1,		pos={
20,	
18,	},
	size={
"716",

"423",
},
},

{	img_n="sui/wujiang/wj_yulan_title.png",
	flip={	false,		false,	},
	parent="mainPanel",
	class="SImage",
	is_nine=false,
	name="img_12",
	zOrder=2,		pos={	199,		411,	},
	size={	"346",
	"42",
},
},

{	img_n="sui/wujiang/yl_title_bg.png",
	flip={	false,		false,	},
	parent="mainPanel",
	class="SImage",
	is_nine=true,
	name="img_13",
	child={
{	str="#cf3e8d1小提示：集齐武将卡牌即可解锁武将技能哦~",
	name="label_11",
	parent="img_13",
	align=1,		class="SLabel",
	fontsize=16,		pos={	195,		3,	},
},
},
	zOrder=2,		pos={
19,	
18,	},
	size={
"716",

"24",
},
},
},
	zOrder=1,		pos={
106,	
116,	},
},
},
	class="SPanel",
	is_nine=true,
	name="win_root",
	pos={
"0",

"0",
},
	zOrder=1,		parent="ui_root",
	size={
"960",

"640",
},

}
