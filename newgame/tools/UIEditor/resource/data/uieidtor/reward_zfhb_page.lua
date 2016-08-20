reward_zfhb_page = {
	pos={	5,		5,	},
	img_n="",
	name="win_root",
	child={
{	img_n="sui/common/panel12.png",
	flip={	false,		false,	},
	parent="win_root",
	class="SPanel",
	is_nine=true,
	name="panel_1",
	size={	"600",
	"509",
},
	child={
{	img_n="nopack/reward/hongbao.png",
	flip={	false,		false,	},
	parent="panel_1",
	class="SPanel",
	is_nine=true,
	name="panel_2",
	child={
{	parent="panel_2",
	img_n="sui/common/btn_2.png",
	name="btn_1",
	size={	"157",
	"57",
},
	child={
{	str="发红包",
	name="label_2",
	align="2",
	parent="btn_1",
	class="SLabel",
	fontsize="22",
	pos={	79,		16,	},
},
},
	class="SButton",
	zOrder=1,		pos={
407,	
34,	},
},

{	str="",
	name="label_1",
	parent="panel_2",
	align=1,		class="SLabel",
	fontsize=16,		pos={	56,		44,	},
},

{	str="小提示：元宝通过邮件发送哦~",
	name="label_3",
	parent="panel_2",
	align=1,		class="SLabel",
	fontsize=16,		pos={	8,		4,	},
},
},
	zOrder=1,		pos={
"12",

"11",
},
	size={
"577",

"487",
},
},
},
	zOrder=1,		pos={
"-5",

"-5",
},
},
},
	parent="ui_root",
	class="SPanel",
	is_nine=true,
	size={
637,	
525,	},

}
