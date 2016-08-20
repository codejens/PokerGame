wfactivityconfig = {
	-- 活动名称，开启等级（下面序号必须是连续的，ipairs）
	--除了武力试炼外，其它活动openlv 都要填 29
	[1] = { key_v = 1, act_name = "演武场", openlv = fn_config[21].level, txt_nor = "sui/wanfa/xdh_nor.png", txt_sld = "sui/wanfa/xdh_sld.png" },
	[2] = { key_v = 2, act_name = "武力试炼", openlv = fn_config[20].level, txt_nor = "sui/wanfa/ttsl_nor.png", txt_sld = "sui/wanfa/ttsl_sld.png" },
	[3] = { key_v = 3, act_name = "箴机奇图", openlv = fn_config[22].level, txt_nor = "sui/wanfa/llhj_nor.png", txt_sld = "sui/wanfa/llhj_sld.png" },
	[4] = { key_v = 4, act_name = "逐鹿中原", openlv = fn_config[27].level, txt_nor = "sui/wanfa/xyzz_nor.png", txt_sld = "sui/wanfa/xyzz_sld.png" },
	[5] = { key_v = 5, act_name = "大乱斗", openlv = fn_config[23].level, txt_nor = "sui/wanfa/ywzc_nor.png", txt_sld = "sui/wanfa/ywzc_sld.png" },
	[6] = { key_v = 6, act_name = "阵营战", openlv = fn_config[26].level, txt_nor = "sui/wanfa/zyz_nor.png", txt_sld = "sui/wanfa/zyz_sld.png" },
	[7] = { key_v = 7, act_name = "天梯赛", openlv = fn_config[24].level, txt_nor = "sui/wanfa/drtt_nor.png", txt_sld = "sui/wanfa/drtt_sld.png" },
	[8] = { key_v = 8, act_name = "战队赛", openlv = fn_config[25].level, txt_nor = "sui/wanfa/zdtt_nor.png", txt_sld = "sui/wanfa/zdtt_sld.png" },
	[9] = { key_v = 9, act_name = "每日剧情", openlv = fn_config[60].level, txt_nor = "sui/wanfa/zdtt_nor.png", txt_sld = "sui/wanfa/zdtt_sld.png" },
}


npc_tabel = 
{ 
	-- 这个名字需要跟 normal_talk_dialog 配置的对应
	fbnpc_name = {
		"箴机奇图",
		"逐鹿中原",
		"大乱斗",
		"阵营战",
	},

	-- 这个名字跟服务器下发的名字对应
	ser_fbnpc_name = {
		"箴机奇图|校尉",
		"逐鹿中原|校尉",
		"大乱斗|校尉",
		"阵营战|校尉"
	},

	fbto_npcname = {
		[8] = "箴机奇图|校尉",
		[13] = "逐鹿中原|校尉",
		[11] = "阵营战|校尉",
		[14] = "大乱斗|校尉",
	},

	-- 为了不要再多出表，这配置写在npc_table,虽然位置极其不合理
	-- index是部分副本id
	fbresult_win = {
		[1] = "fbresult2_win",
		juqing = "fbresult_win",
	},
}

-- 副本配置在 dailyfubenconfig.lua文件里面 
wffubenconfig = {
	-- FBID要跟 ../data/dailyfubenconfig 对应
	[1] = { FBID = 1, txt_nor  = "sui/wanfa/kles_nor.png", txt_sld = "sui/wanfa/kles_sld.png", openlv = fn_config[28].level, name = "天机奇缘"},  -- 天机奇缘
	[2] = { FBID = 2, txt_nor  = "sui/wanfa/sjhg_nor.png", txt_sld = "sui/wanfa/sjhg_sld.png", openlv = fn_config[29].level, name = "神驹猎狩"},  -- 神驹猎狩
	[3] = { FBID = 3, txt_nor  = "sui/wanfa/xymj_nor.png", txt_sld = "sui/wanfa/xymj_sld.png", openlv = fn_config[31].level, name = "云台将录"},  -- 云台将录
	[4] = { FBID = 4, txt_nor  = "sui/wanfa/shxn_nor.png", txt_sld = "sui/wanfa/shxn_sld.png", openlv = fn_config[32].level, name = "守卫昆阳"},  -- 守卫昆阳
	[5] = { FBID = 5, txt_nor  = "sui/wanfa/wjmz_nor.png", txt_sld = "sui/wanfa/wjmz_sld.png", openlv = fn_config[30].level, name = "无尽秘藏"},  -- 无尽秘藏
	[6] = { FBID = 15, txt_nor = "sui/wanfa/wjmz_nor.png", txt_sld = "sui/wanfa/wjmz_sld.png", openlv = fn_config[52].level, name = "剑试云台"},  -- 剑试云台
	[7] = { FBID = 16, txt_nor = "sui/wanfa/wjmz_nor.png", txt_sld = "sui/wanfa/wjmz_sld.png", openlv = fn_config[53].level, name = "龙脉珍宝"},  -- 龙脉珍宝
	[8] = { FBID = 17, txt_nor = "sui/wanfa/wjmz_nor.png", txt_sld = "sui/wanfa/wjmz_sld.png", openlv = fn_config[55].level, name = "血战豫州"},  -- 血战豫州
	[9] = { FBID = 18, txt_nor = "sui/wanfa/wjmz_nor.png", txt_sld = "sui/wanfa/wjmz_sld.png", openlv = fn_config[54].level, name = "烽火长安"},  -- 烽火长安
	-- [6] = { txt_nor = "sui/wanfa/xdh_nor.png", txt_sld = "sui/wanfa/xdh_sld.png"},
}