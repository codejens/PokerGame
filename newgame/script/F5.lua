-- F5.lua
-- f5刷新

function reload_script()
    --========================================================================

    -- 社交
    -- reloadScript("SUI/contact/InviteFriendWin")
    -- reloadScript("SUI/contact/SContactWin")
    -- reloadScript("SUI/contact/SCTFriendPage")
    -- reloadScript("SUI/contact/SCTMailPage")
    -- reloadScript("SUI/contact/SCTTeamPage")

    -- reloadScript("SUI/contact/friendMiscPage/SGetKeyWin")

    -- reloadScript("SUI/tips/SGeneralTips")

    -- reloadScript("../resource/data/uieditor/contact_win")

    -- UIManager:init_out()
    -- UIManager:destroy_window("contact_win")
    -- UIManager:show_window("contact_win")

    --========================================================================

    -- 新功能开启
    -- reloadScript("../resource/data/uieditor/fn_open_tips")

    -- UIManager:init_out()
    -- UIManager:destroy_window("fn_open_tips")
    -- UIManager:show_window("fn_open_tips")

    --==========================================================================

    -- 副本
    -- reloadScript("SUI/juqing/chapterContentPage")
    -- reloadScript("SUI/juqing/SPlayContentWin")
    -- reloadScript("SUI/juqing/SPlayPage")
    -- reloadScript("SUI/juqing/SPlayWin")
    -- reloadScript("SUI/juqing/SStarGraphPage")
    -- reloadScript("SUI/juqing/SStoryResultWin")
    -- reloadScript("SUI/juqing/SSweepWin")
    -- reloadScript("../resource/data/uieditor/chiYing_win")

    -- UIManager:init_out()
    -- UIManager:destroy_window("chiYing_win")
    -- UIManager:show_window("chiYing_win")

    --=============================================================================

    -- 玩法
    -- reloadScript("SUI/activity/SActFBPage")
    -- reloadScript("SUI/activity/SActHDPage")
    -- reloadScript("SUI/activity/SActivityWin")
    -- reloadScript("SUI/activity/SActTJPage")
    -- reloadScript("SUI/activity/SActYSPage")
    -- reloadScript("SUI/activity/STongJiLingWin")

    -- reloadScript("SUI/fuben/SNormalRankWin")
    -- reloadScript("../resource/data/uieditor/activity_win")

    -- -- 天梯赛
    -- -- reloadScript("SUI/activity/hdpages/SDrttPage")
    -- -- reloadScript("UI/component/HollowMask")
    -- -- reloadScript("../resource/data/uieditor/danrentianti_panel")

    -- -- reloadScript("SUI/fuben/SNormalRankWin")

    -- UIManager:init_out()
    -- UIManager:destroy_window("sactivity_win")
    -- UIManager:show_window("sactivity_win")

    -- -- local root = ZXLogicScene:sharedScene():getUINode()
    -- --先删除 再添加 以免重复
    -- -- root:removeChildByTag(UI_TAG_TUXIAN,true)

    --=============================================================================

    -- 琴棋书画
    -- reloadScript("SUI/qinqishuhua/SQinqishuhuaWin")
    -- reloadScript("SUI/qinqishuhua/SQqshContentPage")
    -- reloadScript("SUI/qinqishuhua/SQqshEnterPage")
    -- reloadScript("../resource/data/uieditor/qinqishuhua_win")
    -- reloadScript("../resource/data/uieditor/qqsh_content_win")

    -- reloadScript("SUI/tips/SMoneyTips")

    -- UIManager:init_out()
    -- UIManager:destroy_window("qinqishuhua_win")
    -- UIManager:show_window("qinqishuhua_win")

    --=============================================================================

    -- 复活 求助好友
    -- reloadScript("SUI/resurrection/SReqFriendHelpWin")
    -- reloadScript("../resource/data/uieditor/request_friend_help_win")

    -- UIManager:init_out()
    -- UIManager:destroy_window("request_friend_help_win")
    -- UIManager:show_window("request_friend_help_win")

    --=============================================================================

    -- 充值
    -- reloadScript("SUI/recharge/RechargeWin")
    -- reloadScript("SUI/recharge/RechargePage")
    -- reloadScript("SUI/firstrecharge/FirstRecharge")
    -- reload "../resource/data/chong_zhi_config"
    -- reloadScript("../resource/data/uieditor/recharge_win")

    -- UIManager:init_out()
    -- UIManager:destroy_window("pay_win")
    -- VIPModel:show_chongzhi_win()

    --=============================================================================

    -- 角色
    -- reloadScript("SWidget/FightWidget")
    -- reloadScript("UI/component/ImageNumber")

    -- reloadScript("SUI/UserEquipAndAttrWin/SUserEquipAndAttrPage")
    -- reloadScript("SUI/UserEquipAndAttrWin/SUserFashionPage")
    -- reloadScript("SUI/UserEquipAndAttrWin/SUserTitlePage")
    -- reloadScript("SUI/UserEquipAndAttrWin/UserEquipAndAttrWin")
    -- reloadScript("SUI/UserEquipAndAttrWin/OtherUserEquipAndAttrWin")

    -- reloadScript("../resource/data/uieditor/user_equip_and_attr_win")
    -- reloadScript("../resource/data/uieditor/other_user_equip_and_attr_win")

    -- UIManager:init_out()
    -- UIManager:destroy_window("user_equip_and_attr_win")
    -- UIManager:show_window("user_equip_and_attr_win")
    -- UIManager:destroy_window("other_user_equip_and_attr_win")
    -- UIManager:show_window("other_user_equip_and_attr_win")

    --=============================================================================

    -- 其它人
    -- reloadScript("SUI/UserEquipAndAttrWin/OtherUserEquipAndAttrWin")
    -- reloadScript("../resource/data/uieditor/other_user_equip_and_attr_win")
    -- UIManager:init_out()
    -- UIManager:destroy_window("other_user_equip_and_attr_win")
    -- UIManager:show_window("other_user_equip_and_attr_win")

    --=============================================================================

    -- 在线豪礼
    -- reloadScript("SUI/reward/RewardOnlinePage")
    -- reloadScript("SUI/reward/RewardWin")
    -- reloadScript("../resource/data/uieditor/reward_online_page")

    -- UIManager:init_out()
    -- UIManager:destroy_window("reward_win")
    -- UIManager:show_window("reward_win")

    --=============================================================================

    -- 活跃度
    -- reloadScript("SUI/task/STaskWin")
    -- reloadScript("SUI/task/SDailyPage")
    -- reloadScript("SUI/task/page/SZhouLiWin")
    -- reloadScript("SUI/task/page/SHuoYueJiang")
    -- reloadScript("SUI/task/page/SHuoYueWanFa")
    -- reloadScript("../resource/data/uieditor/task_win")
    -- reloadScript("../resource/data/uieditor/zhou_li_win")
    -- reloadScript("../resource/data/uieditor/huoyue_jiang_tips")
    -- reloadScript("../resource/data/uieditor/huoyue_wanfa_tips")

    -- -- reload "../resource/data/activationconfig"
    -- -- reload "../resource/data/huoyuedu_config"

    -- reloadScript("SUI/tips/SMoneyTips")

    -- UIManager:init_out()
    -- UIManager:destroy_window("task_win")
    -- UIManager:show_window("task_win")

    --=============================================================================
    
    -- 结算界面

    --成功翻牌（单）
    -- reloadScript("SUI/fuben/SFBResultWin")
    -- reloadScript("../resource/data/uieditor/fbresult_win")
    -- UIManager:init_out()
    -- UIManager:destroy_window("fbresult_win")
    -- UIManager:show_window("fbresult_win")
    --成功物品（多）
    -- reloadScript("SUI/fuben/SFBResultTwoWin")
    -- reloadScript("../resource/data/uieditor/fbresult2_win")
    -- UIManager:init_out()
    -- UIManager:destroy_window("fbresult2_win")
    -- UIManager:show_window("fbresult2_win")
    --平局
    -- reloadScript("SUI/fuben/SFBResultTwoWinDeuce")
    -- reloadScript("../resource/data/uieditor/fbresult2_win_deuce")
    -- UIManager:init_out()
    -- UIManager:destroy_window("fbresult2_win_deuce")
    -- UIManager:show_window("fbresult2_win_deuce")
    --失败（多）
    -- reloadScript("SUI/fuben/SFBResultTwoWinFail")
    -- reloadScript("../resource/data/uieditor/fbresult2_win_fail")
    -- UIManager:init_out()
    -- UIManager:destroy_window("fbresult2_win_fail")
    -- UIManager:show_window("fbresult2_win_fail")
    --失败（单）
    -- reloadScript("SUI/fuben/SFBResultFailWin")
    -- reloadScript("../resource/data/uieditor/fbresult_fail_win")
    -- UIManager:init_out()
    -- UIManager:destroy_window("fbresult_fail_win")
    -- UIManager:show_window("fbresult_fail_win")

    --=============================================================================

    -- vip
    -- reloadScript("SUI/vip/SVipWin")
    -- reloadScript("../resource/data/uieditor/vip_win")

    -- UIManager:init_out()
    -- UIManager:destroy_window("vip_win")
    -- UIManager:show_window("vip_win")

    --=============================================================================

    -- 武将
    -- reloadScript("SUI/wujiang/WuJiangWin")
    -- reloadScript("SUI/wujiang/WJTuJianPage")
    -- reloadScript("SUI/wujiang/WJSkillPage")
    -- reloadScript("SUI/wujiang/WJUpLevelTips")
    -- reloadScript("../resource/data/uieditor/wujiang_win")

    -- UIManager:init_out()
    -- UIManager:destroy_window("wujiang_win")
    -- UIManager:show_window("wujiang_win")

    --=============================================================================

    -- 翻牌
    -- reloadScript("SUI/fuben/SFBEsCardSldWin")
    -- reloadScript("../resource/data/uieditor/fbes_cardsld_win")

    -- UIManager:init_out()
    -- UIManager:destroy_window("fbes_cardsld_win")
    -- UIManager:show_window("fbes_cardsld_win")

    --=============================================================================

    -- 铸造
    -- reloadScript("model/ZhuZhaoModel")

    -- reloadScript("SUI/zhuzhao/ZhuZhaoWin")
    -- reloadScript("SUI/zhuzhao/ZZHeChengPage")
    -- reloadScript("SUI/zhuzhao/ZZJinJiePage")
    -- reloadScript("SUI/zhuzhao/ZZQiangHuaPage")
    -- reloadScript("SUI/zhuzhao/ZZShenZhuPage")
    -- reloadScript("SUI/zhuzhao/ZZXianQianPage")
    -- reloadScript("SUI/zhuzhao/ZZXiLianPage")

    -- -- reloadScript("SUI/wujiang/WJTuJianPage")
    -- -- reloadScript("SUI/wujiang/WJSkillPage")

    -- reloadScript("../resource/data/uieditor/zhuzhao_win")

    -- UIManager:init_out()
    -- UIManager:destroy_window("zhuzhao_win")
    -- UIManager:show_window("zhuzhao_win")

    --=============================================================================

    -- 聊天
    -- reloadScript("UI/chat/ChatContentScroll")
    -- reloadScript("UI/chat/ChatFaceWin")
    -- reloadScript("UI/chat/ChatInfo")
    -- reloadScript("UI/chat/ChatInput")
    -- reloadScript("UI/chat/ChatWin")

    -- UIManager:init_out()
    -- UIManager:destroy_window("chat_win")
    -- UIManager:show_window("chat_win")

    --=============================================================================

    -- 活动
    -- reloadScript("SUI/reward/RewardActivityYY")

    -- reloadScript("../resource/data/newweekactivity")

    -- --单笔充值
    -- -- reloadScript("SUI/recharge/RewardDbczPage")
    -- -- reloadScript("../resource/data/uieditor/reward_dbcz_page")

    -- --离线经验
    -- reloadScript("SUI/reward/RewardLxjyPage")
    -- reloadScript("../resource/data/uieditor/reward_lxjy_page")

    -- UIManager:init_out()
    -- UIManager:destroy_window("activity_yy_win")
    -- UIManager:show_window("activity_yy_win")

    --=============================================================================

    -- 伙伴
    -- reloadScript("SUI/partner/SPartnerWin")
    -- reloadScript("SUI/partner/SPAttrPage")
    -- reloadScript("../resource/data/uieditor/partner_win")

    -- UIManager:init_out()
    -- UIManager:destroy_window("spartner_win")
    -- UIManager:show_window("spartner_win")

    --=============================================================================

    -- 坐骑
    -- reloadScript("SUI/smount/SMountWin")
    -- reloadScript("SUI/smount/SMHuaXingPage")
    -- reloadScript("../resource/data/uieditor/mount_win")

    -- UIManager:init_out()
    -- UIManager:destroy_window("mount_win")
    -- UIManager:show_window("mount_win")

    --=============================================================================

    -- 商店
    -- reloadScript("SUI/shop/ShopWin")
    -- reloadScript("SUI/shop/ShopItemList")
    -- reloadScript("../resource/data/uieditor/shop_win")

    -- UIManager:init_out()
    -- UIManager:destroy_window("shop_win")
    -- UIManager:show_window("shop_win")

    --=============================================================================

    -- 展示

    -- 坐骑
    -- reloadScript("SUI/tips/SOther_mount_tips")
    -- reloadScript("../resource/data/uieditor/other_mount_tip")

    -- UIManager:init_out()
    -- UIManager:destroy_window("other_mount_tip")
    -- UIManager:show_window("other_mount_tip")

    -- 伙伴
    -- reloadScript("SUI/tips/SPartnerTips")
    -- reloadScript("../resource/data/uieditor/partner_tips")

    -- UIManager:init_out()
    -- UIManager:destroy_window("partner_tips_win")
    -- UIManager:show_window("partner_tips_win")

    -- 武器
    -- reloadScript("SUI/tips/SEquirTips")
    -- reloadScript("../resource/data/uieditor/zhuanbei_tips")

    -- UIManager:init_out()
    -- UIManager:destroy_window("equir_tips_win")
    -- UIManager:show_window("equir_tips_win")

    --=============================================================================

    -- 包裹提示
    -- reloadScript("SUI/tips/SItemBagTips")
    -- reloadScript("model/STipsModel")
    -- reloadScript("../resource/data/uieditor/item_bag_tips")

    -- UIManager:init_out()
    -- UIManager:destroy_window("item_bag_tips_win")
    -- UIManager:show_window("item_bag_tips_win")

    --=============================================================================

    -- 红包
    -- reloadScript("SUI/redPot/SHaveGetRedPotPage")
    -- reloadScript("SUI/redPot/SHaveSendRedPotPage")
    -- reloadScript("SUI/redPot/SRedPot")
    -- reloadScript("SUI/redPot/SRedPotList")
    -- reloadScript("SUI/redPot/SRedPotWin")
    -- reloadScript("SUI/redPot/SSendRedPotPage")
    -- reloadScript("../resource/data/uieditor/get_red_pot_win")

    -- UIManager:init_out()
    -- UIManager:destroy_window("get_red_pot_win")
    -- UIManager:show_window("get_red_pot_win")

    --=============================================================================
    reloadScript("SUI/tips/SClothing_tips")
    reloadScript("../resource/data/uieditor/clothing_tip")
    UIManager:init_out()
    UIManager:destroy_window("clothing_tip")
    UIManager:show_window("clothing_tip")
end