main_menu = {
	img_n="",
	parent="ui_root",
	class="SPanel",
	zOrder=1,		name="win_root",
	pos={	55,		100,	},
	child={
{	img_n="nopack/BigImage/main_menuBg.png",
	flip={	false,		false,	},
	parent="win_root",
	class="SPanel",
	is_nine=false,
	name="panel_1",
	pos={	-47.5,		-30,	},
	zOrder=1,		child={
{	img_n="",
	flip={	false,		false,	},
	parent="panel_1",
	class="SPanel",
	is_nine=true,
	name="right_panel",
	size={	"100",
	"350",
},
	child={},
	zOrder=2,		pos={
753,	
71,	},
},

{	img_n="",
	parent="panel_1",
	class="SScroll",
	is_nine=true,
	scroll_type=2,		size={	"500",
	"300",
},
	name="scroll",
	zOrder=2,		child={},
	pos={
"222.5",

"97.5",
},
},

{	img_n="",
	flip={	false,		false,	},
	parent="panel_1",
	class="SPanel",
	is_nine=true,
	name="left_panel",
	pos={	97,		71,	},
	zOrder=2,		child={},
	size={
"100",

"350",
},
},

{	img_n="sui/common/close.png",
	name="btn_close",
	pos={	843.5,		421.5,	},
	parent="panel_1",
	class="SButton",
	zOrder=1,		size={	"66",
	"75",
},
},
},
	size={
"945",

"495",
},
},
},
	is_nine=true,
	size={
"850",

"445",
},

}
