ttslsd_dialog = {
	img_n="sui/common/tipsPanel.png",
	parent="ui_root",
	class="SPanel",
	is_nine=true,
	name="win_root",
	pos={	"0",
	"0",
},
	child={
{	img_n="sui/common/close.png",
	name="btn_close",
	size={	"62",
	"57",
},
	parent="win_root",
	class="SButton",
	zOrder=99,		pos={	469,		452,	},
},

{	str="#c9f4c08本次扫荡18~36重天",
	name="label_chongtian",
	parent="win_root",
	align=2,		class="SLabel",
	fontsize="22",
	pos={	282,		439.5,	},
},

{	img_n="sui/common/string_01.png",
	flip={	false,		false,	},
	parent="win_root",
	class="SPanel",
	is_nine=true,
	name="panel_2",
	pos={	37,		413,	},
	zOrder=1,		size={	"245",
	"10",
},
},

{	img_n="sui/common/string_01.png",
	flip={	true,		false,	},
	parent="win_root",
	class="SPanel",
	is_nine=true,
	name="copy_1",
	size={	"245",
	"10",
},
	zOrder=1,		pos={	287,		413,	},
},

{	img_n="sui/common/tongbi2.png",
	flip={	false,		false,	},
	parent="win_root",
	class="SPanel",
	is_nine=false,
	name="panel_3",
	pos={	109,		371,	},
	zOrder=1,		size={	"28",
	"27",
},
},

{	str="#c804b129999999",
	name="label_tongbi",
	parent="win_root",
	align=1,		class="SLabel",
	fontsize=16,		pos={	149,		372.5,	},
},

{	str="#c804b129999999",
	name="label_jingyan",
	align=1,		parent="win_root",
	class="SLabel",
	fontsize=16,		pos={	373,		372.5,	},
},

{	img_n="sui/fuben/fb_jingyan.png",
	flip={	false,		false,	},
	parent="win_root",
	class="SPanel",
	is_nine=false,
	name="panel_4",
	pos={	318,		371,	},
	zOrder=1,		size={	"44",
	"23",
},
},

{	img_n="sui/common/panel2.png",
	flip={	false,		false,	},
	parent="win_root",
	class="SPanel",
	is_nine=true,
	name="panel_6",
	pos={	33,		112,	},
	zOrder=1,		child={
{	img_n="",
	parent="panel_6",
	class="SScroll",
	is_nine=true,
	scroll_type=2,		pos={	2,		2,	},
	zOrder=1,		name="scroll_items",
	size={	"496",
	"240",
},
},
},
	size={
"500",

"245",
},
},

{	str="",
	img_n="sui/common/btn_1.png",
	parent="win_root",
	class="STextButton",
	zOrder=1,		fontsize="24",
	child={
{	img_n="sui/btn_name/queding.png",
	flip={	false,		false,	},
	parent="tbtn_sure",
	class="SImage",
	is_nine=false,
	name="img_1",
	zOrder=1,		pos={	47,		19,	},
	size={	"48",
	"24",
},
},
},
	pos={
201,	
33,	},
	name="tbtn_sure",
	align=1,		size={
"144",

"60",
},
},
},
	zOrder=1,		size={
"565",

"515",
},

}