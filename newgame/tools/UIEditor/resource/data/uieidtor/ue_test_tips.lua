ue_test_tips = {
	img_n="",
	child={
{	img_n="sui/common/panel11.png",
	flip={	false,		false,	},
	parent="win_root",
	class="SPanel",
	is_nine=true,
	name="panel_1",
	child={
{	img_n="sui/common/btn_1.png",
	name="btn_1",
	parent="panel_1",
	class="SButton",
	pos={	140,		39,	},
	size={	139,		57,	},
},

{	img_n="sui/common/input_frame.png",
	parent="panel_1",
	class="SEditBox",
	maxnum=15,		fontsize=16,		zOrder=1,		pos={	150,		212,	},
	align=1,		name="editbox_1",
	size={	"120",
	"35",
},
},

{	img_n="sui/common/input_frame.png",
	parent="panel_1",
	class="SEditBox",
	maxnum=15,		fontsize=16,		zOrder=1,		pos={	150,		132,	},
	align=1,		name="editbox_2",
	size={	"120",
	"35",
},
},

{	img_n="sui/common/btn_1.png",
	name="btn_2",
	parent="panel_1",
	class="SButton",
	pos={	339,		270,	},
	size={	139,		57,	},
},
},
	zOrder=1,		pos={
248,	
169,	},
	size={
"440",

"320",
},
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