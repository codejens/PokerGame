friendCommonWin = {
	pos={	5,		5,	},
	img_n="",
	name="win_root",
	parent="ui_root",
	child={
{	img_n="sui/common/tipsPanel.png",
	flip={	false,		false,	},
	parent="win_root",
	class="SPanel",
	is_nine=true,
	name="panel_1",
	size={	"500",
	"320",
},
	child={
{	img_n="sui/common/little_win_title_bg.png",
	flip={	false,		false,	},
	parent="panel_1",
	class="SImage",
	is_nine=false,
	name="img_1",
	pos={	87,		276,	},
	zOrder=1,		child={
{	img_n="sui/btn_name/tianjiahaoyou.png",
	flip={	false,		false,	},
	parent="img_1",
	class="SImage",
	is_nine=false,
	name="titleLabel",
	size={	"96",
	"25",
},
	zOrder=1,		pos={	120,		11,	},
},
},
	size={
"336",

"47",
},
},

{	img_n="sui/common/close.png",
	name="closeBtn",
	pos={	424,		260,	},
	parent="panel_1",
	class="SButton",
	zOrder=1,		size={	"62",
	"57",
},
},

{	img_n="sui/common/panel2.png",
	flip={	false,		false,	},
	parent="panel_1",
	class="SPanel",
	is_nine=true,
	name="panel_2",
	pos={	34,		93,	},
	zOrder=1,		child={
{	img_n="sui/common/panel5.png",
	parent="panel_2",
	class="SEditBox",
	maxnum=15,		fontsize=16,		pos={	23,		62,	},
	zOrder=1,		align=1,		name="editbox_1",
	size={	"386",
	"41",
},
},
},
	size={
"433",

"165",
},
},

{	pos={	185,		29,	},
	img_n="sui/common/btn_1.png",
	name="btn",
	child={
{	img_n="sui/btn_name/tianjiahaoyou2.png",
	flip={	false,		false,	},
	parent="btn",
	class="SImage",
	is_nine=false,
	name="btnLabel",
	size={	"81",
	"20",
},
	zOrder=1,		pos={	30,		17,	},
},
},
	parent="panel_1",
	class="SButton",
	zOrder=1,		size={
"139",

"53",
},
},
},
	zOrder=1,		pos={
"185",

"170",
},
},
},
	class="SPanel",
	is_nine=true,
	size={
950,	
630,	},

}