-- menus_config = {
-- 	[1]  = { name="duihuan",      index=1,   sysType=1,   openType=2,   value=21, },		--兑换		--1
-- 	[2]  = { name="linggen",      index=2,   sysType=1,   openType=1,   value=8, },		--灵根
-- 	[3]  = { name="chibang",      index=3,   sysType=1,   openType=1,   value=35, },		--翅膀系统
-- 	[4]  = { name="fabao",        index=4,   sysType=1,   openType=2,   value=43, }, 		--法宝
-- 	[5]  = { name="qiandao",      index=5,   sysType=1,   openType=2,   value=20, },		--签到
-- 	[6]  = { name="dujie",        index=6,   sysType=1,   openType=1,   value=9, }, 		--渡劫
-- 	[7]  = { name="doufatai",     index=7,   sysType=1,   openType=2,   value=30, },		--演武场
-- 	[8]  = { name="xiandaohui",   index=8,   sysType=1,   openType=2,   value=40, },		--仙道会
-- 	[9]  = { name="xianlv",       index=9,   sysType=1,   openType=2,   value=41, },		--仙侣情缘
-- 	[10] = { name="zhaocai",      index=10,  sysType=1,   openType=2,   value=22, },		--招财
-- 	[11] = { name="chengjiu",     index=11,  sysType=1,   openType=2,   value=27, }, 		--成就
-- 	[12] = { name="meinvzhushou", index=12,  sysType=1,   openType=0,   value=0, },		--美女助手
-- 	[13] = { name="bangdan",      index=13,  sysType=1,   openType=0,   value=0, },		--榜单
-- 	[14] = { name="jishou",       index=14,  sysType=1,   openType=0,   value=0, },		--寄售
-- 	[15] = { name="renwu",        index=15,  sysType=1,   openType=0,   value=0, },		--任务
-- 	[16] = { name="youjian",      index=16,  sysType=1,   openType=0,   value=0, },		--邮件
-- 	[17] = { name="shezhi",       index=17,  sysType=1,   openType=0,   value=0, },		--设置
-- 	[18] = { name="kefu",         index=18,  sysType=1,   openType=0,   value=0, },		--客服
-- 	[19] = { name="huanledou",    index=19,  sysType=1,   openType=2,   value=33, },		--欢乐斗
-- }
-- 去掉某个系统注析掉然后把序号改成顺序即可
menus_config = {
	[1] = { name="renwu",        index=15,  sysType=1,   openType=0,   value=0, },		--任务
	[2] = { name="jishou",       index=14,  sysType=1,   openType=0,   value=0, },		--寄售
	[3] = { name="youjian",      index=9,  sysType=1,   openType=0,   value=0, },		--邮件
	[4] = { name="shezhi",       index=17,  sysType=1,   openType=0,   value=0, },		--设置
	[5] = { name="meinvzhushou", index=21,  sysType=1,   openType=0,   value=0, },		--美女助手
	[6] = { name="zudui", index=23, sysType=1, openType=2, value=1,},	-- 组队系统
	[7] = { name="thehelper", index=24, sysType=1, openType=0, value=0,},	-- 组队系统
	[8] = { name="kefu",         index=18,  sysType=1,   openType=0,   value=0, },		--客服

}

-- sysType：分类，1=系统，2=功能(取消分类)
-- name:	图标的资源名
-- openType:决定系统开放的类型，0=默认开放，1=根据系统号开放，2=按等级开放
-- value:	条件值，openType=0时无意义，openType=1时表示对应系统号，openType=2时表示开放所需等级