-- -- ServerActivityConfig.lua
-- -- created by hcl on 2014-2-24
-- -- 系统活动配置

-- ServerActivityConfig = {}

-- ServerActivityConfig.ACT_TYPE_NULL			= 0;	--无活动
-- ServerActivityConfig.ACT_TYPE_STRONG_HERO 	= 11;	--强者之路
-- ServerActivityConfig.ACT_TYPE_POWER_PET 		= 12;	--至强伙伴
-- ServerActivityConfig.ACT_TYPE_POWER_FABAO 	= 13;	--至强法宝
-- ServerActivityConfig.ACT_TYPE_ZHONGQIU 	    = 15;	--中秋活动
-- ServerActivityConfig.ACT_TYPE_LUOPAN 	    = 16;	--罗盘活动
-- ServerActivityConfig.ACT_TYPE_GUOQING 	    = 18;	--国庆活动
-- ServerActivityConfig.ACT_TYPE_QIANGLILAIXI 	= 22;	--强力来袭活动
-- ServerActivityConfig.ACT_TYPE_SHENGDANKUANGHUAN = 23;--圣诞狂欢
-- ServerActivityConfig.ACT_TYPE_SHENGDANJINGXI = 24;	--圣诞惊喜
-- ServerActivityConfig.ACT_TYPE_HUANQINGYUANDAN = 25;	--欢庆元旦
-- ServerActivityConfig.ACT_TYPE_XIANLVQINGYUAN = 26;	--仙侣情缘活动
-- ServerActivityConfig.ACT_TYPE_XINNIANHUODONG = 27;	--新年活动
-- ServerActivityConfig.ACT_TYPE_YUANXIAOHUODONG = 28;	--元宵活动
-- ServerActivityConfig.ACT_TYPE_HEFUHUODONG = 29;		--合服活动
-- ServerActivityConfig.ACT_TYPE_MEIRIXIAOFEI = 30;	--每日消费
-- ServerActivityConfig.ACT_TYPE_QQBROWSER = 31;		--QQ浏览器活动
-- ServerActivityConfig.ACT_TYPE_QINGMING 	    = 33;	--清明活动

-- -- 当前可用的活动
-- ServerActivityConfig.CURR_USE_ACTIVITY_IDS = { 
-- 	-- [ServerActivityConfig.ACT_TYPE_QIANGLILAIXI] = true,		--强力来袭活动
-- 	-- [ServerActivityConfig.ACT_TYPE_SHENGDANKUANGHUAN] = true, --圣诞狂欢
-- 	-- [ServerActivityConfig.ACT_TYPE_SHENGDANJINGXI] = true,	--圣诞惊喜
-- 	-- [ServerActivityConfig.ACT_TYPE_HUANQINGYUANDAN] = true,	--欢庆元旦
-- 	-- [ServerActivityConfig.ACT_TYPE_XIANLVQINGYUAN] = true,	--仙侣情缘活动
-- 	-- [ServerActivityConfig.ACT_TYPE_XINNIANHUODONG] = true,	--新年活动
-- 	-- [ServerActivityConfig.ACT_TYPE_YUANXIAOHUODONG] = true,	--元宵活动
-- 	-- [ServerActivityConfig.ACT_TYPE_HEFUHUODONG] = true,		--合服活动
-- 	-- [ServerActivityConfig.ACT_TYPE_MEIRIXIAOFEI] = true,		--每日消费
-- 	-- [ServerActivityConfig.ACT_TYPE_QINGMING] = true,		--清明活动
-- }

-- function ServerActivityConfig:get_conf( activity_id )
-- 	--强力来袭活动
-- 	if activity_id == ServerActivityConfig.ACT_TYPE_QIANGLILAIXI then
-- 		require "../data/activity_config/newseraward_config"
-- 		return newseraward_config.qianglilaixiAward
-- 	--圣诞狂欢
-- 	elseif activity_id == ServerActivityConfig.ACT_TYPE_SHENGDANKUANGHUAN then
-- 		require "../data/activity_config/shengdanjie_config"
-- 		return shengdanjie_config
-- 	--欢庆元旦
-- 	elseif activity_id == ServerActivityConfig.ACT_TYPE_HUANQINGYUANDAN then
-- 		require "../data/activity_config/yuandanjie_config"
-- 		return yuandanjie_config
-- 	--仙侣情缘活动
-- 	elseif activity_id == ServerActivityConfig.ACT_TYPE_XIANLVQINGYUAN then
-- 		require "../data/activity_config/xianjieqiyuan_config"
-- 		return xianjieqiyuan_config
-- 	--新年活动
-- 	elseif activity_id == ServerActivityConfig.ACT_TYPE_XINNIANHUODONG then
-- 		require "../data/activity_config/xinnianactivity_config"
-- 		return xinnianactivity_config
-- 	--元宵活动
-- 	elseif activity_id == ServerActivityConfig.ACT_TYPE_YUANXIAOHUODONG then
-- 		require "../data/activity_config/qingrenyuanxiaoactivity_config"
-- 		return qryxactivity_conf
-- 	-- 合服活动
-- 	elseif activity_id == ServerActivityConfig.ACT_TYPE_HEFUHUODONG then
-- 		require "../data/activity_config/hefuhuodong_config"
-- 		return hefuhuodong_config
-- 	--每日消费
-- 	elseif activity_id == ServerActivityConfig.ACT_TYPE_MEIRIXIAOFEI then
-- 		require "../data/activity_config/newseraward_config"
-- 		return newseraward_config.meirixiaofeiAward
-- 	elseif activity_id == ServerActivityConfig.ACT_TYPE_QINGMING then
-- 		require "../data/activity_config/qingmingganen_config"
-- 		return qingmingganen_config
-- 	end
-- end


-- ServerActivityConfig.lua
-- created by hcl on 2014-2-24
-- 系统活动配置

ServerActivityConfig = {}

ServerActivityConfig.ACT_TYPE_NULL			= 0;	--无活动
ServerActivityConfig.ACT_TYPE_STRONG_HERO 	= 11;	--强者之路
ServerActivityConfig.ACT_TYPE_POWER_PET 		= 12;	--至强伙伴
ServerActivityConfig.ACT_TYPE_POWER_FABAO 	= 13;	--至强法宝
ServerActivityConfig.ACT_TYPE_ZHONGQIU 	    = 15;	--中秋活动
ServerActivityConfig.ACT_TYPE_GUOQING 	    = 18;	--国庆活动
ServerActivityConfig.ACT_TYPE_SHENGDANKUANGHUAN = 23;--圣诞狂欢
ServerActivityConfig.ACT_TYPE_SHENGDANJINGXI = 24;	--圣诞惊喜
ServerActivityConfig.ACT_TYPE_HUANQINGYUANDAN = 25;	--欢庆元旦
ServerActivityConfig.ACT_TYPE_XIANLVQINGYUAN = 26;	--仙侣情缘活动
ServerActivityConfig.ACT_TYPE_XINNIANHUODONG = 27;	--新年活动
ServerActivityConfig.ACT_TYPE_YUANXIAOHUODONG = 29;	--元宵活动
ServerActivityConfig.ACT_TYPE_HEFUHUODONG   = 28;		--合服活动   --天将雄狮从29->28
ServerActivityConfig.ACT_TYPE_MEIRIXIAOFEI  = 24;	--每日消费       --天将雄狮修改id 30->24
ServerActivityConfig.ACT_TYPE_QQBROWSER     = 31;		--QQ浏览器活动
ServerActivityConfig.ACT_TYPE_WUYI   	    = 33;	--五一活动
ServerActivityConfig.ACT_TYPE_ZHUANPAN 	    = 38;	--每日惊喜活动 、转盘
-- ServerActivityConfig.ACT_TYPE_QQGUANJIA 	= 40;	--QQ管家
ServerActivityConfig.ACT_TYPE_LIUYI   	    = 42;	--六一活动
ServerActivityConfig.ACT_TYPE_XIAOFEIRETURN = 43    -- 消费返回

ServerActivityConfig.ACT_TYPE_LANGMAN 	    = 45;	--浪漫520
ServerActivityConfig.ACT_TYPE_JUBAODAI 	    = 46;	--聚宝袋
ServerActivityConfig.ACT_TYPE_LUOPAN 	    = 47;	--罗盘活动 
ServerActivityConfig.ACT_TYPE_XIAOFEI_RETURN1 = 48;	--累计消费返还 新服 
ServerActivityConfig.ACT_TYPE_XIAOFEI_RETURN2 = 49;	--累计消费返还 旧服 
ServerActivityConfig.ACT_TYPE_TTXS 			= 50;	--天天向上
ServerActivityConfig.ACT_TYPE_TEHUI_KUANGHUAN 	= 51;	--特惠狂欢1 --老服用
ServerActivityConfig.ACT_TYPE_QIANGLILAIXI 	= 52;	--强力来袭活动1
ServerActivityConfig.ACT_TYPE_YUANBAOFANLI 	= 53;	--元宝返利
ServerActivityConfig.ACT_TYPE_TAOBAO_SHENSHU	= 56;	--淘宝神树
ServerActivityConfig.ACT_TYPE_JUESHI_SHENGONG 	= 57;	--绝世神功活动
ServerActivityConfig.ACT_TYPE_LIUYIBA 	= 64;			--618活动
ServerActivityConfig.ACT_TYPE_FANGSHUJIA 	= 65;	--放暑假活动
ServerActivityConfig.ACT_TYPE_LIUERWU 	= 66;	--625活动
ServerActivityConfig.ACT_TYPE_QIANGLILAIXI2 	= 67;	--强力来袭活动2
ServerActivityConfig.ACT_TYPE_QIJIU	= 69;	--79活动
ServerActivityConfig.ACT_TYPE_QIYIQI = 71;	--717活动

ServerActivityConfig.ACT_TYPE_QISANLING = 72;	--730活动
ServerActivityConfig.ACT_TYPE_LANGMAN_QIXI = 73;	--浪漫七夕活动
ServerActivityConfig.ACT_TYPE_QIERSI = 75;	--724活动
ServerActivityConfig.ACT_TYPE_HEFU_KUANGHUAN = 76;	--合服狂欢活动

-- 当前可用的活动
ServerActivityConfig.CURR_USE_ACTIVITY_IDS = { 
	[ServerActivityConfig.ACT_TYPE_QIANGLILAIXI] = true,		--强力来袭活动
	[ServerActivityConfig.ACT_TYPE_QIANGLILAIXI2] = true,		--强力来袭活动
	[ServerActivityConfig.ACT_TYPE_SHENGDANKUANGHUAN] = true, --圣诞狂欢
	[ServerActivityConfig.ACT_TYPE_SHENGDANJINGXI] = true,	--圣诞惊喜
	[ServerActivityConfig.ACT_TYPE_HUANQINGYUANDAN] = true,	--欢庆元旦
	[ServerActivityConfig.ACT_TYPE_XIANLVQINGYUAN] = true,	--仙侣情缘活动
	[ServerActivityConfig.ACT_TYPE_XINNIANHUODONG] = true,	--新年活动
	[ServerActivityConfig.ACT_TYPE_YUANXIAOHUODONG] = true,	--元宵活动
	[ServerActivityConfig.ACT_TYPE_HEFUHUODONG] = true,		--合服活动
	[ServerActivityConfig.ACT_TYPE_MEIRIXIAOFEI] = true,	--每日消费
	[ServerActivityConfig.ACT_TYPE_XIAOFEI_RETURN1] = true,		--浪漫520清明活动
	[ServerActivityConfig.ACT_TYPE_XIAOFEI_RETURN2] = true,		--浪漫520清明活动
	[ServerActivityConfig.ACT_TYPE_LANGMAN] = true,		--浪漫520清明活动
	[ServerActivityConfig.ACT_TYPE_JUBAODAI] = true,		--聚宝活动
	[ServerActivityConfig.ACT_TYPE_WUYI] = true,	    	--五一活动
	[ServerActivityConfig.ACT_TYPE_ZHUANPAN] = true,		--每日惊喜活动 、转盘
	[ServerActivityConfig.ACT_TYPE_LIUYI] = true,	    	--六一活动
	[ServerActivityConfig.ACT_TYPE_TTXS] = true,	   	--每日消费活动
	[ServerActivityConfig.ACT_TYPE_JUESHI_SHENGONG] = true,	   	--绝世神功活动
	[ServerActivityConfig.ACT_TYPE_TAOBAO_SHENSHU] = true,	   	--淘宝神树
	[ServerActivityConfig.ACT_TYPE_FANGSHUJIA] = true,	   	--放暑假活动
	[ServerActivityConfig.ACT_TYPE_LIUYIBA] = true,	   			--618活动
	-- [ServerActivityConfig.ACT_TYPE_YUANBAOFANLI] = true,	   	--元宝返利
	[ServerActivityConfig.ACT_TYPE_LIUERWU] = true,	   			--625活动
	[ServerActivityConfig.ACT_TYPE_QIJIU] = true,	   			--79活动
	[ServerActivityConfig.ACT_TYPE_QIYIQI] = true,	   			--717活动
	[ServerActivityConfig.ACT_TYPE_QISANLING] = true,	   		--730活动
	[ServerActivityConfig.ACT_TYPE_LANGMAN_QIXI] = true,	   		--浪漫七夕活动
	[ServerActivityConfig.ACT_TYPE_QIERSI] = true,	   			--724活动
	[ServerActivityConfig.ACT_TYPE_HEFU_KUANGHUAN] = true,	   			--合服狂欢活动
}



function ServerActivityConfig:get_conf( activity_id )
	--强力来袭活动
	if activity_id == ServerActivityConfig.ACT_TYPE_QIANGLILAIXI then
		require "../data/activity_config/newseraward_config"
		return newseraward_config.qianglilaixiAward
	elseif activity_id == ServerActivityConfig.ACT_TYPE_QIANGLILAIXI2 then
		require "../data/activity_config/qianglilaixi2"
		print("qianglilaixiAward2[1][2].id=",qianglilaixiAward2[1][2].id)
		return qianglilaixiAward2
	--圣诞狂欢
	elseif activity_id == ServerActivityConfig.ACT_TYPE_SHENGDANKUANGHUAN then
		require "../data/activity_config/shengdanjie_config"
		return shengdanjie_config
	--欢庆元旦
	elseif activity_id == ServerActivityConfig.ACT_TYPE_HUANQINGYUANDAN then
		require "../data/activity_config/yuandanjie_config"
		return yuandanjie_config
	--仙侣情缘活动
	elseif activity_id == ServerActivityConfig.ACT_TYPE_XIANLVQINGYUAN then
		require "../data/activity_config/xianjieqiyuan_config"
		return xianjieqiyuan_config
	--新年活动
	elseif activity_id == ServerActivityConfig.ACT_TYPE_XINNIANHUODONG then
		require "../data/activity_config/xinnianactivity_config"
		return xinnianactivity_config
	--元宵活动
	elseif activity_id == ServerActivityConfig.ACT_TYPE_YUANXIAOHUODONG then
		require "../data/activity_config/qingrenyuanxiaoactivity_config"
		return qryxactivity_conf
	-- 合服活动
	elseif activity_id == ServerActivityConfig.ACT_TYPE_HEFUHUODONG then
		require "../data/activity_config/hefuhuodong_config"
		return hefuhuodong_config
	--每日消费
	elseif activity_id == ServerActivityConfig.ACT_TYPE_MEIRIXIAOFEI then
		require "../data/activity_config/newseraward_config"
		return newseraward_config.meirixiaofeiAward
	elseif activity_id == ServerActivityConfig.ACT_TYPE_XIAOFEI_RETURN1 then
		require "../data/activity_config/xiaofei_return_config1"
		return xiaofei_return_config1
	elseif activity_id == ServerActivityConfig.ACT_TYPE_XIAOFEI_RETURN2 then
		require "../data/activity_config/xiaofei_return_config2"
		return xiaofei_return_config2
	elseif activity_id == ServerActivityConfig.ACT_TYPE_WUYI then
		require "../data/activity_config/wuyi_config"
		return wuyi_config
	elseif activity_id == ServerActivityConfig.ACT_TYPE_LIUYI then
		require "../data/activity_config/liuyi_config"
		return liuyi_config
	elseif activity_id == ServerActivityConfig.ACT_TYPE_LANGMAN then
		require "../data/activity_config/langman_config"
		return langman_config
	elseif activity_id == ServerActivityConfig.ACT_TYPE_TTXS then
		require "../data/activity_config/ttxs_config"
		return ttxs_config
	elseif activity_id == ServerActivityConfig.ACT_TYPE_JUESHI_SHENGONG then
		require "../data/activity_config/jueshishengong_config"
		return jueshishengong_config
	elseif activity_id == ServerActivityConfig.ACT_TYPE_YUANBAOFANLI then
		require "../data/activity_config/yuanbaofanli_config"
		return yuanbaofanli_config
	elseif activity_id == ServerActivityConfig.ACT_TYPE_TAOBAO_SHENSHU then
		require "../data/activity_config/taobao_shenshu_config"
		return taobao_shenshu_config
	elseif activity_id == ServerActivityConfig.ACT_TYPE_FANGSHUJIA then
		require "../data/activity_config/fangshujia_config"
		return fangshujia_config
	elseif activity_id == ServerActivityConfig.ACT_TYPE_LIUYIBA then
		require "../data/activity_config/liuyiba_config"
		return liuyiba_config
	elseif activity_id == ServerActivityConfig.ACT_TYPE_LIUERWU then
		require "../data/activity_config/liuerwu_config"
		return liuerwu_config
	elseif activity_id == ServerActivityConfig.ACT_TYPE_QIJIU then
		require "../data/activity_config/qijiu_config"
		return qijiu_config
	elseif activity_id == ServerActivityConfig.ACT_TYPE_QIYIQI then
		require "../data/activity_config/qiyiqi_config"
		return qiyiqi_config
	elseif activity_id == ServerActivityConfig.ACT_TYPE_QISANLING then
		require "../data/activity_config/qisanling_config"
		return qisanling_config
	elseif activity_id == ServerActivityConfig.ACT_TYPE_LANGMAN_QIXI then
		require "../data/activity_config/langmanqixi_config"
		return langmanqixi_config
	elseif activity_id == ServerActivityConfig.ACT_TYPE_QIERSI then
		require "../data/activity_config/qiersi_config"
		return qiersi_config
	elseif activity_id == ServerActivityConfig.ACT_TYPE_HEFU_KUANGHUAN then
		require "../data/activity_config/hefukuanghuan/hefukuanghuan_config"
		return hefukuanghuan_config
	end
end

