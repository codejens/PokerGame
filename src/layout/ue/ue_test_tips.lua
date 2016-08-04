ue_test_tips = {
	img_n="",
	parent="ui_root",
	class="SPanel",
	is_nine=true,
	name="win_root",
	zOrder=1,		child={
{	img_n="ui/common/text_box.png",
	flip={	false,		false,	},
	parent="win_root",
	class="SPanel",
	is_nine=true,
	name="panel_1",
	child={
{	img_n="ui/common/close.png",
	name="btn_1",
	pos={	382,		263,	},
	parent="panel_1",
	class="SButton",
	zOrder=1,		size={	"62",
	"62",
},
},

{	img_n="ui/common/text_box.png",
	parent="panel_1",
	class="SEditBox",
	maxnum=15,		fontsize=16,		zOrder=1,		pos={	171,		200,	},
	align=1,		name="editbox_1",
	size={	"100",
	"35",
},
},

{	img_n="ui/common/text_box.png",
	parent="panel_1",
	class="SEditBox",
	maxnum=15,		fontsize=16,		size={	"100",
	"35",
},
	name="editbox_2",
	align=1,		zOrder=1,		pos={	170,		132,	},
},

{	img_n="ui/login/btn_1.png",
	name="btn_2",
	pos={	54,		13,	},
	parent="panel_1",
	class="SButton",
	zOrder=1,		size={	"332",
	"83",
},
},
},
	zOrder=1,		pos={
"0",

"0",
},
	size={
"440",

"320",
},
},
},
	size={
"440",

"320",
},
	pos={
"299",

"185",
},

}