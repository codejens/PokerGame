ue_game_win = {
	img_n="",
	child={
{	img_n="",
	flip={	false,		false,	},
	parent="win_root",
	class="SPanel",
	is_nine=false,
	name="panel_1",
	zOrder = 1,
	size={	"960",
	"640",
},
	zOrder=1,		child={
{	img_n="nopack/game_bg.png",
	flip={	false,		false,	},
	parent="panel_1",
	class="SPanel",
	is_nine=false,
	name="panel_2",
	pos={	"0",
	"75",
},
	zOrder=1,		size={	"960",
	"490",
},
},

{	str="返回",
	img_n="sui/common/btn_1.png",
	name="btn_back",
	parent="panel_1",
	class="SButton",
	pos={	12,		581,	},
	size={	139,		57,	},
},
},
	pos={
"0",

"0",
},
},
},
	class="SPanel",
	is_nine=true,
	name="win_root",
	size={
"960",

"640",
},
	parent="ui_root",
	zOrder=1,		pos={
"0",

"0",
},

}
