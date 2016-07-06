reward_tzbz_page = {
	img_n="",
	child={
{	img_n="sui/common/panel2.png",
	flip={	false,		false,	},
	parent="win_root",
	class="SPanel",
	is_nine=true,
	name="child_name",
	size={	"637",
	"525",
},
	isVisible=false,
	child={
{	img_n="nopack/reward/tjbz_title.png",
	flip={	false,		false,	},
	parent="child_name",
	class="SImage",
	is_nine=false,
	name="img_9",
	child={
{	str="活动规则：活动持续七天，进行十连抽可获得星宿礼包",
	name="label_desc_tjbz",
	parent="img_9",
	align=1,		class="SLabel",
	fontsize=16,		pos={	15,		29,	},
},

{	str="#cFFD400活动倒计时：",
	name="label_time_tjbz",
	parent="img_9",
	align=1,		class="SLabel",
	fontsize=16,		pos={	15,		8,	},
},
},
	pos={
5,	
360,	},
	zOrder=1,		size={
"628",

"163",
},
},

{	img_n="",
	parent="child_name",
	class="SScroll",
	is_nine=true,
	scroll_type=2,		pos={	"5",
	"5",
},
	zOrder=1,		name="scroll_3",
	size={	"628",
	"355",
},
},
},
	zOrder=1,		pos={
"0",

"0",
},
},
},
	class="SPanel",
	is_nine=true,
	name="win_root",
	size={
"670",

"525",
},
	parent="ui_root",
	zOrder=1,		pos={
"0",

"0",
},

}
