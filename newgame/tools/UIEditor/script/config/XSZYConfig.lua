-- XSZYConfig.lua
-- created by hcl on 2013-3-15
-- 新手指引配置

-- super_class.XSZYConfig()
XSZYConfig = {}

XSZYConfig.NONE			 = 0;		-- 没有指引
XSZYConfig.ZHUANG_BEI_ZY = 1;		-- 装备指引
XSZYConfig.CHONG_WU_ZY = 2;			-- 宠物指引
XSZYConfig.BEI_BAO_ZY = 3;			-- 背包指引
XSZYConfig.GUA_JI_ZY = 4;			-- 挂机指引
XSZYConfig.BISHAJI_ZY = 5;			-- 必杀技指引
XSZYConfig.ZUO_QI_ZY = 6;			-- 坐骑指引
XSZYConfig.SHANG_DIAN_ZY = 7;		-- 商店指引
XSZYConfig.ZUO_QI_JINJIE_ZY = 8;	-- 坐骑进阶指引
XSZYConfig.FUBEN_ZY = 9;			-- 历练副本指引
XSZYConfig.DUI_HUAN_ZY = 10;		-- 兑换指引
XSZYConfig.DU_JIE_ZY = 11;			-- 渡劫指引
XSZYConfig.DU_JIE_ZY2 = 12;			-- 渡劫指引2
XSZYConfig.LIAN_QI_ZY = 13;			-- 炼器指引
XSZYConfig.XIAN_ZONG_ZY = 14;		-- 仙宗指引
XSZYConfig.KUAI_JIE_RW_ZY = 15;		--快捷任务指引
XSZYConfig.VIP_ZY = 16;				--vip3指引
XSZYConfig.MENG_JING_ZY = 17;		--梦境指引
XSZYConfig.ZXJZ_ZY = 18;			--诛仙剑阵指引
XSZYConfig.CWD_ZY = 19;				--宠物岛指引
XSZYConfig.CWRH_ZY = 20;			--宠物融合指引
XSZYConfig.FENMODIAN = 21;			--封魔殿剧情
XSZYConfig.ZYCM_ZY = 22;			--斩妖除魔指引
XSZYConfig.QHZ_ZY = 23;				--千狐冢指引
XSZYConfig.LINGGEN_JQ = 24;			--灵根剧情动画
XSZYConfig.LINGGEN_ZY = 25;			--灵根指引
XSZYConfig.JINENG_ZY = 26;			--技能指引
XSZYConfig.ZHIXIAN_ZY = 31;			-- 支线任务指引
XSZYConfig.YANLUHUANJING_ZY = 32;	-- 炎炉幻境指引
XSZYConfig.NANZHAOWANG_ZY = 33;		-- 南诏王指引
XSZYConfig.HEILONGZHIHUN_ZY = 34;	-- 黑龙之魂指引
XSZYConfig.XINSHOUFUBEN_ZY = 35;	-- 新手副本指引
XSZYConfig.PAOHUAN_ZY = 36;			-- 跑环指引
XSZYConfig.HUOYUE_ZY = 37;			-- 活跃奖励指引

XSZYConfig.GUAJI_BTN = 27;			--挂机按钮
XSZYConfig.BISHAJI_BTN = 28;		--必杀技按钮
XSZYConfig.TUICHUFUBEN_BTN = 29;	--退出副本按钮
XSZYConfig.GONGNENGCAIDAN_BTN = 30;	--功能菜单按钮
XSZYConfig.HUODONG_BTN = 40;		--功能菜单按钮
XSZYConfig.DAILY_BTN = 41;			--日常按钮

XSZYConfig.NPCDIALOG_SELECT_TAG = 888	--npc对话框界面的闪烁选中框tag
XSZYConfig.BETTER_SELECT_TAG = 889		--更好的装备界面的闪烁选中框tag
XSZYConfig.JINYUANBAO_SELECT_TAG = 890	--金元宝界面的闪烁选中框tag
XSZYConfig.OTHER_SELECT_TAG = 891		--其他界面的闪烁选中框tag
XSZYConfig.QUICK_QUEST_PANEL_TAG = 892	--快捷任务栏的闪烁选中框tag

-- 获取id的配置
function XSZYConfig:get_config( id, step )
	require "../data/xszy"
	-- 暂时屏蔽新手指引
	if xszy[id] ~= nil then
		return xszy[id][step]
	end
	return xszy[id]
end