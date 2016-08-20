-- 成长之路配置
-- idx用于新手指引
grow_config = {
	--挑战
	{
		[1]  = { name="dujie",		openType=1,   value=9, idx = 1, },		--护国榜
		[2]  = { name="doufatai",	openType=0,   value=0, idx = 2, },		--演武场
		[3]	 = { name="paohuan",	openType=2,   value=31, idx = 3, },		--跑环
		[4]  = { name="zhenyaota",	openType=2,   value=54, idx = 4, },		--秘籍塔
		[5]  = { name="juxianling",	openType=2,   value=45, idx = 5, },		--秘籍塔
		[6]  = { name="qishu",	openType=2,   value=55, idx = 6, },		--秘籍塔
	},
	--成长
	{
		[1]  = { name="linggen",	openType=1,   value=8, idx = 1, },		--灵根
		[2]  = { name="duihuan",	openType=2,   value=0, idx = 2, },		--兑换
		[3] = { name="zhaocai",     openType=0,   value=0, idx = 3, },		--招财
		[4]  = { name="fabao",      openType=2,   value=43, idx = 4, }, 	--法宝
		[5] = { name="marriage",  	openType=2,   value=41, idx = 5, },	-- 结婚系统
		-- 下个版本开启
		--[6] = { name="meirenchouka",openType=2,   value=50, idx = 6, }, -- 美人抽卡
	},
	--荣耀
	{
		[1] = { name="bangdan",     openType=0,   value=0, idx = 1, },		--榜单
		[2] = { name="chengjiu",    openType=2,   value=27, idx = 2, }, 	--成就
		[3] = { name="xiandaohui",  openType=2,   value=1, idx = 3,},		--仙道會
	},
}

-- name:	图标的资源名
-- openType:决定系统开放的类型，0=默认开放，1=根据系统号开放，2=按等级开放
-- value:	条件值，openType=0时无意义，openType=1时表示对应系统号，openType=2时表示开放所需等级