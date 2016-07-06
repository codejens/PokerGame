friendWinTips = {
	size={	950,		630,	},
	img_n="",
	name="win_root",
	child={
{	img_n="sui/common/tipsPanel.png",
	flip={	false,		false,	},
	parent="win_root",
	class="SPanel",
	is_nine=true,
	name="panel_1",
	pos={	"224",
	"179",
},
	zOrder=1,		child={
{	img_n="sui/common/little_win_title_bg.png",
	flip={	false,		false,	},
	parent="panel_1",
	class="SImage",
	is_nine=false,
	name="img_1",
	pos={	68,		291,	},
	zOrder=1,		child={
{	str="#c5f3406提示",
	name="label_1",
	parent="img_1",
	align=1,		class="SLabel",
	fontsize="22",
	pos={	144,		10.5,	},
},
},
	size={
"336",

"47",
},
},

{	str="#c5f3406当前已无钥匙领取",
	name="label_2",
	parent="panel_1",
	align="2",
	class="SLabel",
	fontsize="22",
	pos={	242,		171.5,	},
},

{	pos={	163,		65,	},
	img_n="sui/common/btn_1.png",
	name="btn_1",
	child={
{	str="#c5f3406确定",
	name="label_3",
	parent="btn_1",
	align="2",
	class="SLabel",
	fontsize="22",
	pos={	68,		18.5,	},
},
},
	parent="panel_1",
	class="SButton",
	zOrder=1,		size={
"144",

"60",
},
},
},
	size={
"476",

"332",
},
},
},
	parent="ui_root",
	class="SPanel",
	is_nine=true,
	pos={
5,	
5,	},

}