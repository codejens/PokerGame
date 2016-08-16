--__init.lua

__init_sui={}
--分批加载 加载界面动画才能动起来
--新加的也加个函数
__init_sui[1] = function ()
require "SUI/UICreateByLayout"
require "SUI/base/BaseEditWin"
require "SUI/base/BaseEditPanel"
end


__init_sui[2] = function ()
require "SUI/base/BasePage"
-- require "SUI/UserEquipAndAttrWin/UserEquipAndAttrWin"
-- require "SUI/UserEquipAndAttrWin/OtherUserEquipAndAttrWin"
end

__init_sui[3] = function ()

require "SUI/game/GameWin"
require "SUI/game/GameModel"
require "SUI/game/GameCC"
require "SUI/game/GameConfig"
-- require "SUI/task/STaskWin"
-- require "SUI/rank/SRankWin"
-- require "SUI/juqing/SPlayWin"
end

__init_sui[4] = function ()
require "SUI/mainhall/MainHallWin"
require "SUI/mainhall/MainHallModel"
require "SUI/mainhall/MainHallCC"

-- require "SUI/juqing/SPlayContentWin"
-- require "SUI/juqing/SSweepWin"
-- require "SUI/contact/friendMiscPage/SGiveFlowerWin"
end

__init_sui[5] = function ()
require "SUI/roomlist/RoomListModel"
require "SUI/roomlist/RoomListWin"
require "SUI/roomlist/RoomListCC"
require "SUI/roomlist/RoomListConfig"
-- require "SUI/contact/friendMiscPage/SFriendCommonWin"
-- require "SUI/contact/friendMiscPage/SGetKeyWin"
-- require "SUI/contact/friendMiscPage/SGiveFlowerLogWin"
end

__init_sui[6] = function ()
-- require "SUI/contact/friendMiscPage/SQinMiDuWin"
-- require "SUI/contact/friendMiscPage/SFriendTipsWin"
-- require "SUI/contact/friendMiscPage/SGetFlowerTipsWin"
end

__init_sui[7] = function ()
-- require "SUI/contact/InviteFriendWin"
-- require "SUI/task/SChoseWin"
-- require "SUI/redPot/SRedPotWin"
end

__init_sui[8] = function ()
-- require "SUI/redPot/SRedPot"
-- require "SUI/redPot/SRedPotList"

-- require "SUI/friend/SFriendWin"
-- require "SUI/tips/cloth_gather_tip"
end

__init_sui[9] = function ()
-- require "SUI/tips/BagExpandTips"
-- require "SUI/userSkillWin/UserSkillWin"      --??¨¦????¨¹?¨°
-- require "SUI/shop/ShopWin"					-- ¨¦¨¬¦Ì¨º¡ä¡ã?¨²require "SUI/UserEquipAndAttrWin/UserEquipAndAttrWin"
-- require "SUI/fabao/FabaoWin"
-- require "SUI/fabao/SFabaoWin"
end

__init_sui[10] = function ()
-- require "SUI/fabao/SFabaoWin"
-- require "SUI/fabao/SFbAttrPage"      	-- ¨º?D?¡¤?¨°3(1)
-- require "SUI/fabao/SFbSkillPage"		-- ???¨¹¨º?D?(2)
-- require "SUI/fabao/SFbGetPage"			-- ¨¢¨¬¨¨?????(3)
end

__init_sui[11] = function ()
-- ??¡ã¨¦
-- require "SUI/partner/SPartnerWin"
-- require "SUI/partner/SPAttrPage"
-- require "SUI/partner/SPAddedPage"
-- require "SUI/partner/SPTujianPage"
end

__init_sui[12] = function ()
	-- require "SUI/partner/SPDivideWin"
	-- require "SUI/partner/SPFosterWin"
	-- require "SUI/partner/SPFusionWin"	
end

__init_sui[13] = function () 
	-- require "SUI/partner/SPNormalWin" 
	-- require "SUI/partner/SPNormalTwoWin"
	-- require "SUI/partner/SPNormalThreeWin"
	-- require "SUI/partner/SPSkillWin"
end

__init_sui[14] = function ()
--?y?¨¬
-- require "SUI/zhuzhao/ZZHeChengPage"
-- require "SUI/zhuzhao/ZZQiangHuaPage"
-- require "SUI/zhuzhao/ZZJinJiePage"
end

__init_sui[15] = function ()
-- require "SUI/zhuzhao/ZZXianQianPage"
-- require "SUI/zhuzhao/ZZShenZhuPage"
-- require "SUI/zhuzhao/ZZXiLianPage"
end

__init_sui[16] = function ()
-- require "SUI/zhuzhao/ZhuZhaoWin"
-- require "SUI/zhuzhao/ZhuZhaoWin"
end

__init_sui[17] = function ()
--¡Á???
-- require "SUI/smount/SMPeiYangPage"
-- require "SUI/smount/SMJinJiePage"
-- require "SUI/smount/SMSkillPage"
end

__init_sui[18] = function ()
-- require "SUI/smount/SMHuaXingPage"
-- require "SUI/smount/SMountWin"
-- require "SUI/smount/SMountWin"
end

__init_sui[19] = function ()
--3¨¢¡ã¨°
-- require "SUI/wing/SWingWin"
-- require "SUI/wing/SCBPeiYangPage"
-- require "SUI/wing/SCBJinJiePage"
-- require "SUI/wing/SCBHuaXingPage"
end


__init_sui[20] = function ()
--?¡ä??
--require "UI/resurrection/ResurrectionDialog"
-- ¨¦???
-- require "SUI/contact/SContactWin"
-- require "SUI/contact/SCTFriendPage"
-- require "SUI/contact/SCTTeamPage"
-- require "SUI/contact/SCTMailPage"
end

__init_sui[21] = function ()
-- ¨ª?¡¤¡§(???¡¥,?¡À¡À?,¨°¨¬¨ºT)¡ä¡ã?¨²
-- require "SUI/activity/SActivityWin"
-- require "SUI/activity/SActFBPage"
-- require "SUI/activity/SActHDPage"
-- require "SUI/activity/SMainActivityWin"
end

__init_sui[22] = function ()
-- require "SUI/activity/SLlhjPage"
-- require "SUI/activity/SActYSPage"
-- require "SUI/activity/SActTJPage"

-- require "SUI/activity/STongJiLingWin"  --¨ª¡§??¨¢?¦Ì¡¥3?¡ä¡ã
-- require "SUI/activity/hdpages/SZyzZhanJiWin"  --?¨®¨®a?? ???¡§¡ä¡ã?¨²
end

__init_sui[23] = function ()
-- D-¨°¨¦2a¨º?¡ä¡ã?¨²
-- require "SUI/test/SProtocalWin"
-- require "SUI/test/TestMusic"
-- require "SUI/test/SMovieClientWin"
end

__init_sui[24] = function ()
--?¡Â2?¦Ì£¤

-- require "SUI/main/SMainMenuWin"

--¡Á¨²??
-- require "SUI/guild/SGuildWin"                 --¡Á¨²??
-- require "SUI/guild/SGuildList"                 --¡Á¨²??
end

__init_sui[25] = function ()
--tips
-- require "SUI/tips/SEquirTips"
-- require "SUI/tips/SGeneralTips"
-- require "SUI/tips/SPropTips"
-- require "SUI/tips/SSkillTips"
-- require "SUI/CommonTips"
-- require "SUI/SNormalTips"
-- require "SUI/tips/SRewardDayTips"
end

__init_sui[26] = function ()
-- require "SUI/tips/SOther_mount_tips"
-- require "SUI/tips/SOther_wing_tips"     --¨º¡À¡Á¡ãtips
-- require "SUI/tips/SClothing_tips"
-- require "SUI/tips/SMonthCardTips"
-- require "SUI/tips/SFankuiTips"
-- require "SUI/tips/SYwcJlTips"
end

__init_sui[27] = function ()
-- require "SUI/tips/SPartnerTips"
-- require "SUI/tips/SFabaoTips"
-- require "SUI/tips/SMoneyTips"
-- require "SUI/tips/SItemBagTips"
-- require "SUI/tips/SSimpleTips"
-- require "SUI/tips/SSchuaTips"
-- require "SUI/tips/SNumberBox"
-- require "SUI/tips/TeamFuBenTips"
end

__init_sui[28] = function ()
-- require "SUI/vip/SVipWin"					-- vip
-- require "SUI/vip/SVipBaoXiangWin"					-- vip
-- require "action_edit/ActionEdit"
-- require "action_edit/EffectEdit"
end

__init_sui[29] = function ()
-- require "SUI/geocaching/SGeocachingWin"       --?¡ã¡À|????
-- require "SUI/geocaching/STreasurePreviewWin"  --¡À|2??¡è¨¤¨¤

-- require "SUI/systemset/SSystemSetWin"
-- require "SUI/systemset/PushSetPanel"
end

__init_sui[30] = function ()
-- ?¡À¡À??¨¢??????
-- require "SUI/fuben/SFBResultWin"		-- ?¡À¡À?¨ª¡§1?????(¡¤-??)
-- require "SUI/fuben/SFBResultTwoWin"		-- ?¡À¡À?¨ª¡§1?????(??¨®D¡¤-??)
-- require "SUI/fuben/SFBResultTwoWinDeuce"
-- require "SUI/fuben/SFBResultTwoWinFail2"	
end

__init_sui[31] = function ()
-- require "SUI/fuben/SFBResultTwoWinFail"	
-- require "SUI/fuben/SFBResultThreeWinFail"
-- require "SUI/fuben/SFBResultFailWin"	-- ?¡À¡À?¨º¡ì¡ã¨¹????
-- require "SUI/fuben/SFBRotaryWin"		-- ¡Áa?¨¬??1?
-- require "SUI/fuben/SFBEsCardSldWin"		-- ??¨ºT?¡§????1?
end

__init_sui[32] = function ()
-- require "SUI/fuben/SFBCenterInfoPanel"	-- ?¡À¡À??¨®?D??¨º?D??¡é??¡ã?
-- ¨ª¡§¨®???DD????(?¡¤¡¤¡§¨¬¡§¦Ì¨²¨°?¡ä?¨º1¨®?)
-- require "SUI/fuben/SNormalRankWin"		-- ?¡¤¡¤¡§¨¬¡§??DD¡ã?????
-- require "SUI/common/SRuleWin" 
-- require "SUI/fuben/SFBResultDftWin"	    -- ?¡¤¡¤¡§¨¬¡§?¨¢??????
-- require "SUI/fuben/SFBResultTtslWin"	-- ¨ª¡§¨¬¨¬¨º?¨¢??¨¢??????
end

__init_sui[33] = function ()
-- ?¡¤¡¤¡§¨¬¡§
-- require "SUI/fuben/doufatai/DftExploitDialog"	-- ?¡¤¡¤¡§¨¬¡§???¡§
-- require "SUI/fuben/doufatai/DftShopWin"			-- ?¡¤¡¤¡§¨¬¡§¨¦¨¬¦Ì¨º

-- ¡Á¨¦?¨®¨¬¨¬¨¬Y¨¦¨¬¦Ì¨º
-- require "SUI/fuben/SZdttShopWin"

-- ¨ª¡§¨¬¨¬¨º?¨¢?
-- require "SUI/fuben/ttsl/STtslSdDialog"			-- ¨ª¡§¨¬¨¬¨º?¨¢?¨¦¡§¦Ì¡ä????
end

__init_sui[34] = function ()
-- ¨¢e¨¢¡ì???3
-- require "SUI/fuben/llhj/SLlhjRuleWin"           -- ¨¢e¨¢¡ì???31??¨°??¡ã?

-- ui¡¤?¨°3?????¡ê¡ã?
-- require "SUI/base/ExamplePageWin"	-- ¡¤?¨°3?¡Â????
-- require "SUI/base/ExamplePage"
end

__init_sui[35] = function ()
-- require "SUI/guild/SGuildInfoPage"
-- require "SUI/guild/SGuildMemberPage"
-- require "SUI/guild/SGuildRankPage"
-- require "SUI/guild/SGuildAddListPage"
end

__init_sui[36] = function ()
-- require "SUI/guild/SGuildShopWin"
-- require "SUI/guild/SGuildTaskWin"
-- require "SUI/guild/SGuildShuxing"
-- require "SUI/guild/SGuildPaoshang"
end

__init_sui[37] = function ()
-- require "SUI/guild/SGuildRisingStarWin"
-- require "SUI/guild/SGuildPrayingWin"
-- require "SUI/guild/SGuildYuezhan"
-- require "SUI/guild/SGuildPrayingAward"
end

__init_sui[38] = function ()
-- ??¡À|?¨¨
-- require "SUI/jubaopen/SJubaopenWin"
-- -- ¡À???????
-- require "SUI/bianqiang/SBianqiangWin"

-- require "SUI/tips/SSkillTipsPage"
end

__init_sui[39] = function ()
--???¨¦?¡À¡À?
-- require "SUI/juqing/SStoryResultWin"	--???¨¦?¡À¡À??¨¢??????

-- require "SUI/firstrecharge/FirstRecharge"
-- require "SUI/recharge/RechargeWin"
-- require "SUI/recharge/RechargePage"
end


__init_sui[40] = function ()
-- require "SUI/resurrection/ResurrectionDialog"     --?¡ä??????
-- require "SUI/resurrection/SReqFriendHelpWin"
-- require "SUI/reward/RewardActivityYY"
-- require "SUI/recharge/RewardMrczPage"
-- require "SUI/reward/SpecialActivityWin"
-- require "SUI/reward/ChouBinWin"
end

__init_sui[41] = function ()
-- require "SUI/reward/RewardWin"
-- require "SUI/reward/RewardDayPage"
-- require "SUI/reward/RewardLoginPage"
-- require "SUI/reward/RewardOnlinePage"
-- require "SUI/reward/RewardSevenPage"
-- require "SUI/reward/OpenServiceActivity"

end

__init_sui[42] = function ()
-- require "SUI/reward/RewardHlsbtPage"
-- require "SUI/recharge/RewardMrljczPage"
-- require "SUI/reward/RewardXxxPage"
-- require "SUI/reward/RewardCzjjPage"
-- require "SUI/reward/RewardMrqdPage"
-- require "SUI/reward/RewardWzglPage"
end

__init_sui[43] = function ()
-- require "SUI/reward/RewardLevelingPage"
-- require "SUI/reward/RewardFriendPage"
-- require "SUI/reward/RewardSjylPage"
-- require "SUI/reward/RewardYzbwPage"
-- require "SUI/reward/RewardVIPZXPage"
-- require "SUI/reward/RewardXYZPPage"
end

__init_sui[44] = function ()
-- require "SUI/reward/RewardLbdhPage"
-- require "SUI/recharge/RewardLxczPage"
-- require "SUI/reward/RewardTJPage"
-- require "SUI/recharge/RewardTJBZPage"
-- require "SUI/recharge/RewardRebatePage"

-- require "SUI/fighttype/SFightTypeWin"			--???¡¤?¡ê¨º?
end

__init_sui[45] = function ()
-- require "SUI/reward/RewardLxdlPage"
-- require "SUI/reward/Reward_preview_tip"
-- require "SUI/reward/RewardLxjyPage"
-- require "SUI/qinqishuhua/SQinqishuhuaWin"
-- require "SUI/qinqishuhua/SQqshEnterPage"
-- require "SUI/clans/ClansCreateWin"
end

__init_sui[46] = function ()
-- require "SUI/clans/ClansListWin"
-- require "SUI/clans/ClansWin"
-- require "SUI/clans/ClansInviteWin"
end

__init_sui[47] = function ()
-- require "UI/component/HollowMask"
-- require "UI/component/ScreenMask"
-- require "UI/component/DanTiao"
-- require "UI/component/DuiWu"
end

__init_sui[48] = function ()
-- require "SUI/commonMonsterHpBar" -- ÆÕÍ¨¹ÖÑªÌõ
-- require "SUI/eliteMonsterHpBar"  -- ¾«Ó¢¹ÖÑªÌõ	
-- require "SUI/tips/SFnOpenTips"
end

__init_sui[49] = function ()
-- require "SUI/recharge/RewardMonthCardPage"
-- require "SUI/recharge/RewardDbczPage"
-- require "SUI/recharge/RewardXslcPage"
-- require "SUI/reward/RewardZllbPage"
-- require "SUI/reward/RewardZllb2Page"
-- require "SUI/reward/RewardXydbPage"
end

__init_sui[50] = function ()
--武将系统
-- require "SUI/wujiang/WJTuJianPage"
-- require "SUI/wujiang/WJSkillPage"
-- require "SUI/wujiang/WuJiangWin"
-- require "SUI/wujiang/WJUpLevelTips"
-- require "SUI/wujiang/WJInfoTips"
-- require "SUI/wujiang/WJTuJianTips"
-- require "SUI/wujiang/WJYuLanTips"
end

__init_sui[51] = function ()
	-- 答题系统
	-- require "SUI/dailyQuestion/dailyQuestionWin"
	-- require "SUI/reward/RewardSyzfPage"
	-- require "SUI/reward/RewardSyzfPaneld"
	-- require "SUI/reward/RewardSyzfPanelu"
	-- require "UI/main/RewardAnswerWin"
	-- require "SUI/reward/WzglGuizeWin"
	-- require "SUI/wjdc/SwjdcWin"
end
__init_sui[52] = function ()
	-- require "SUI/task/page/SZhouLiWin"
	-- require "SUI/task/page/SHuoYueJiang"
	-- require "SUI/task/page/SHuoYueWanFa"
	-- require "SUI/recharge/RewardFlhdPage"
	-- require "SUI/recharge/RewardMrflPage"
	-- require "SUI/reward/RewardZxbxPage"
end
__init_sui[53] = function ()
	-- 世族BOSS
	-- require "SUI/guild/SGuildBossWin"
	-- require "SUI/recharge/RewardRljxhPage"
	-- require "SUI/recharge/RewardLjxhPage"
	-- require "SUI/openservice/OpenServiceDLFL"
	-- require "SUI/openservice/OpenServiceBJFL"
	-- require "SUI/openservice/OpenServiceCZFL"
	-- require "SUI/openservice/OpenServiceZBTS"

	-- require "SUI/openservice/OpenServiceHBSJ"
	-- require "SUI/openservice/OpenServiceWJSJ"
	-- require "SUI/openservice/OpenServiceBSXQ"
	-- require "SUI/openservice/OpenServiceZBXL"
	-- require "SUI/openservice/OpenServiceZLTS"
	-- require "SUI/openservice/OpenServiceTJBZ"
	-- require "SUI/openservice/OpenServiceJBP"
	-- require "SUI/openservice/OpenServiceYWC"
	-- require "SUI/openservice/OpenServiceMGZY"
	-- require "SUI/openservice/OpenServiceWLSL"
	-- require "SUI/openservice/OpenServiceSZJX"
	-- require "SUI/openservice/OpenServiceZQTS"
end
__init_sui[54] = function ()
	--限时销售
	-- require "SUI/reward/RewardXsxsPage"
	-- require "SUI/reward/RewardXlgmPage"
	-- require "SUI/reward/RewardMrxgPage"
	-- require "SUI/reward/RewardYyqgPage"
	-- require "SUI/reward/RewardSbfhPage"
	-- require "SUI/reward/RewardJlsbPage"
	-- require "SUI/recharge/RewardZfhbPage"
end

__init_sui[55] = function ()
	--限时销售
	-- require "SUI/reward/RewardSllPage"
	-- require "SUI/reward/SllPageWin"
	-- require "SUI/reward/RewardYzbw2Page"
	-- require "SUI/zhuanti/ZtGjqczPage"
	-- require "SUI/zhuanti/ZtJzydqyPage"
	-- require "SUI/zhuanti/page/ZtJzydqyTips"
end

__init_sui[56] = function ()
	-- require "SUI/zhuanti/ZtQqswmPage"
	-- require "SUI/zhuanti/ZtDhxyzqPage"
	-- require "SUI/vip/SVipUpTips"	--svip相关
	-- require "SUI/recharge/RewardScsmjPage"
	-- require "SUI/zhuanti/ZtFjsfPage"
	-- require "SUI/zhuanti/ZtYllhlPage"
end

__init_sui[57] = function ()
	-- require "SUI/zhuanti/ZtZqwzPage"
	-- require "SUI/zhuanti/ZtDqjmPage"
	-- require "SUI/zhuanti/ZtDhjmPage"
	-- require "SUI/zhuanti/ZtZjdhPage"
	-- require "SUI/zhuanti/ZtXbzxcbyPage"
	-- require "SUI/zhuanti/ZtShowAwardWin"
end

__init_sui[58] = function ()
	-- require "SUI/dengluhaoli/SMainDengluhaoliWin"
	-- require "SUI/dengluhaoli/SMeirihaoli_tips"
	-- require "SUI/dengluhaoli/SLeijidenglu_tip"
	-- require "SUI/zhuanti/ZtXlqyPage"
	-- require "SUI/reward/RewardMrxsczPage"
end

__init_sui[59] = function ()
	-- require "SUI/qixi/QixiActivityWin"
	-- require "SUI/qixi/QixiDuiHuanPage"
	-- require "SUI/qixi/QixiLxdlPage"
	-- require "SUI/qixi/QixiRljczPage"
	-- require "SUI/qixi/QixiTitlePage"
	-- require "SUI/qixi/QixiCshuaPage"
	-- require "SUI/qixi/Sqixi_schua_Rewards"
	-- require "SUI/qixi/QixiBossPage"
end