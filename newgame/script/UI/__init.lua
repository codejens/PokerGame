-- InitUI.lua
-- created by aXing on 2013-3-26
-- 这里将会将全部的UI统一加载，以便掌握加载进度

__init_ui={}
--分批加载 加载界面动画才能动起来
--新加的也加个函数
__init_ui[1] = function ()
-- print("加载UI啊---------------------------")
-- require "UIResourcePath"
require "UI/UIMarco"
-- require 'UI/UIStyle'
-- print("加载UI啊---------------------------")
end

__init_ui[2] = function ()
require "UI/component/UIBackGroundWin"

-- 斩仙通用控件 add 2015-3-2
require "UI/UILoader"
--require "SUI/__init"  --细化加载 这里等下注意下卡不卡
end

__init_ui[3] = function ()
-- 通用控件
require "UI/commonwidge/base/ZAbstractNode"
require "UI/commonwidge/ZBasePanel"
-- require "UI/commonwidge/ZButton"
end

__init_ui[4] = function ()
-- require "UI/commonwidge/ZDialog"
-- require "UI/commonwidge/ZEditBox"
-- require "UI/commonwidge/ZImage"
-- require "UI/commonwidge/ZImageButton"
end

__init_ui[5] = function ()
-- require "UI/commonwidge/ZImageImage"
-- require "UI/commonwidge/ZLabel"
-- require "UI/commonwidge/ZRadioButtonGroup"
-- require "UI/commonwidge/ZScroll"
end

__init_ui[6] = function ()
-- require "UI/commonwidge/ZTextButton"
-- require "UI/commonwidge/ZTextImage"
-- require "UI/commonwidge/ZCCSprite"
-- require "UI/commonwidge/ZCheckBox"
end

__init_ui[7] = function ()
-- require "UI/commonwidge/ZList"
-- require "UI/commonwidge/ZListVertical"
-- require "UI/commonwidge/ZProgress"
end

__init_ui[8] = function ()
-- require "UI/commonwidge/ZSlotBase"
-- require "UI/commonwidge/ZSlotMove"
-- require "UI/commonwidge/ZSlotItem"
-- require "UI/commonwidge/ZSlotSkill"
end
-- require "UI/commonwidge/ZComBox"
-- added by aXing on 2014-5-13
-- 添加格子控件

__init_ui[9] = function ()
require "UI/component/AbstractBase"
-- require "UI/component/BasePanel"
require "UI/component/Window"
require "UI/component/NormalStyleWindow"
end

__init_ui[10] = function ()
-- require "UI/component/SHJStyleWindow"
require "UI/component/AlertWin"
-- require "UI/component/ArcRect"
-- require "UI/component/Button"
end

__init_ui[11] = function ()
-- require "UI/component/CheckBox"
-- require "UI/component/Dialog"
-- require "UI/component/DraggableWindow"
end

__init_ui[12] = function ()
require "UI/component/SlotBase"
require "UI/component/SlotEffectManager"
require "UI/component/SlotMove"
end

__init_ui[13] = function ()
require "UI/component/SlotItem"
-- require "UI/component/SlotPet"
require "UI/component/SlotSkill"
end

__init_ui[14] = function ()
require "UI/component/SlotPetSkill"
require "UI/component/SlotBag"
require "UI/component/DragItem"
end

__init_ui[15] = function ()
-- require "UI/component/DynamicMenu"
-- require "UI/component/EditBox"
-- require "UI/component/Image"
-- require "UI/component/ImageButton"
end

__init_ui[16] = function ()
-- require "UI/component/ImageImage"
-- require "UI/component/Label"
-- require "UI/component/LeftClickMenu"
-- require "UI/component/List"
end

__init_ui[17] = function ()
-- require "UI/component/ListVertical"
require "UI/component/NotificationCenter"
-- require "UI/component/PopupView"
-- require "UI/component/RadioButtonGroup"
-- require "UI/component/Scroll"
-- require "UI/component/ScrollPage"
end

__init_ui[18] = function ()
-- require "UI/component/TextButton"
-- require "UI/component/TextButtonEx"
-- require "UI/component/TextCheckBox"
-- require "UI/component/TextImage"
end

__init_ui[19] = function ()
-- require "UI/component/ToggleView"
-- require "UI/component/FlipButton"
-- require "UI/component/UIBackGroundWin"
require "UI/component/ImageNumber"
end

__init_ui[20] = function ()
-- require 'UI/component/TouchListVertical'
-- require 'UI/component/TouchListHorizontal'
end

__init_ui[21] = function ()
-- require "UI/common/ConfirmWin"
-- require "UI/common/ConfirmWin2"
-- require "UI/common/TimerLabel"
-- require "UI/common/ToolTipMgr"
end

__init_ui[22] = function ()
-- require "UI/common/EntityDialog"
-- require "UI/common/BuyKeyboardWin" 	--购买窗口
-- require "UI/common/UseItemDialog"	--使用物品的通用对话框
-- require "UI/common/DialogManager"	--获得更好装备的对话框
end

__init_ui[23] = function ()
-- require "UI/common/JPTZDialog"		--极品三套装的对话框
require "UI/common/NormalDialog"	--只有一句文字的对话框
-- require "UI/common/PiPeiDialog"		--匹配对话框
end

__init_ui[24] = function ()
-- require "UI/common/YPDialog"		-- 带有不再提示选择的对话框
-- require "UI/common/VIPDialog"		-- VIP提示框
-- require "UI/common/InputDialog"		--宠物改名输入框
-- require "UI/common/SInputDialog"     -- 改名输入框2，伙伴(宠物)使用
-- require "UI/common/RenameDialog"		--角色改名对话框
end

__init_ui[25] = function ()
-- require "UI/common/HelpPanel"							-- 宠物界面的帮助
-- require "UI/common/ProcessBar"							-- 进度条
-- require "UI/common/VIP3Dialog"						-- VIP3体验卡对话框
-- require "UI/common/CountDownView"					--倒计时
end

__init_ui[26] = function ()
-- require "UI/common/MiniBtnWin"						-- 屏幕中间从左移动到右的按钮
-- require "UI/common/QuestTeleportDialog"					-- 快捷完成任务对话框
require "UI/common/SysMsgDialog"			--服务器下发的对话框
-- require "UI/common/CountDownButton"
end

__init_ui[27] = function ()
-- require "UI/common/HPBar"						-- 血条控件
-- require "UI/common/GetSkillDialog"				-- 取得技能书对话框
-- require "UI/common/DaZuoTip"					-- 打坐提示框
-- require "UI/common/TYZZDialog"					-- 天元之战说明
-- require "UI/common/SysTipDialog"			--系统开启界面
-- require "UI/common/NumView"					--数字控件
-- require "UI/common/EntityPortrait"    
-- require "UI/common/TipsGridView"           -- NPC半身像对象
end

__init_ui[28] = function ()
-- require "UI/bag/BagWin"		                -- 背包窗口
-- require "UI/cangku/CangKuWin"		        -- 仓库窗口

-- require "UI/shop/ShopWin"					-- 商店窗口
-- require "UI/mall/MallWin"					-- 商城系统窗口
end
-- require "UI/userSkillWin/SmallSkillWin"        --小型技能学习面板
-- require "UI/login/LoginWin"		            -- 登录框
-- require "UI/userSkillWin/UserSkillWin"      --角色技能框
-- require "UI/userSkillWin/UserJiNengPage"	--角色技能面板技能分页
-- require "UI/userSkillWin/SkillMijiPage"      --角色技能秘籍

-- require "UI/userAttrWin/UserAttrWin"        --角色属性框
-- require "UI/userAttrWin/UserEquipWin"    --角色装备面板
-- require "UI/userAttrWin/UserEquipPrompt"    --道具弹出提示
-- require "UI/userBuffWin/UserBuffWin"      --角色技能框

-- require "UI/otherAttr/OtherAttrWin"         --其他角色属性框
-- require "UI/otherAttr/OtherEquipWin"         --其他角色属性框
-- require "UI/set/SetSystemWin"               -- 设置系统窗口


__init_ui[29] = function ()
-- require "UI/chat/ChatWin"					--聊天
end
-- require "UI/exchange/ExchangeWin"			-- 兑换系统窗口
-- require "UI/mysticalshop/MysticalShopWin"	-- 神秘商店系统窗口

__init_ui[30] = function ()
-- require "UI/chat/ChatFaceWin"				--聊天表情
-- require "UI/chat/ChatContentScroll"					--聊天列表队列
end

__init_ui[31] = function ()
require "UI/ScreenNotic/ScreenNoticWin"		--主屏幕跑马灯
require "UI/ScreenNotic/CenterNoticWin"		--主屏公告
require "UI/ScreenNotic/ScreenRunNoticWin"
end
-- require "UI/friend/FriendWin"				--好友
-- require "UI/friend/FriendPersonalSet"		--好友设置
-- require "UI/friend/FriendAdd"				--好友添加窗口
-- require "UI/friend/FriendCelerbrateWin"		--好友祝贺窗口
-- require "UI/friend/FriendInfoWin"			--好友信息
-- require "UI/friend/FriendFlowerThankWin"	--好友鲜花
-- require "UI/friend/FriendCelebrateScroll"
-- require "UI/friend/OneKeyAddWin"			--雷达征友
-- require "UI/toplist/TopListWin"				--排行榜界面

__init_ui[32] = function ()
-- require "UI/guild/CreateGuildWin"           --创建仙宗窗口
-- require "UI/VIP/VipCardWin"					--vip体验卡
end
-- require "UI/sclb/Sclb"						--首冲礼包
-- require "UI/business/BusinessWin"			--交易
-- require "UI/TZFL/TZFLWin"					--投资
-- require "UI/chongzhi/ChongZhiWin"			--冲值
-- require "UI/qqvip/QQVIPWin"					--蓝钻礼包
-- require "UI/qqvip/BlueDiamondWin"			--蓝钻贵族活动界面
-- require "UI/forge/ForgeWin"                 --炼器
-- require "UI/guild/GuildWin"                 --仙宗
-- require "UI/guild/GuildCangKuWin"           --仙宗仓库


-- require "UI/guildshopwin/GuildShopWin"      --仙宗商店窗口
-- require "UI/password/ModifyPasswordWin"     --修改密码窗口
-- require "UI/guild/GuildFubenLeft"                 --仙宗副本
-- require "UI/guild/GuildFubenRight"                 --仙宗副本
-- require "UI/guild/FamilyDonateWin" 			-- 家族捐献
-- require "UI/guild/FamilyNominateWin" 		-- 家族任命



-- require "UI/mounts/MountsWin"				--坐骑系统

-- require "UI/mounts/MountsWinNew"			--新坐骑系统
-- require "UI/mounts/MountsJinJieWin"			--坐骑进阶
-- require "UI/mounts/MountsInfoWin"			--坐骑信息
-- require "UI/mounts/MountsXiLianWin"			--坐骑洗练
-- require "UI/mounts/MountsHuaXingWin"		--坐骑化形

-- require "UI/mounts/MountsJinJiePanel"		--坐骑进阶
-- require "UI/mounts/MountsInfoPanel"			--坐骑信息
-- require "UI/mounts/MountsXiLianPanel"		--坐骑洗练
-- require "UI/mounts/MountsHuaXingPanel"		--坐骑化形
-- require "UI/mounts/MountsLingXiPanel"		--坐骑灵犀
-- require "UI/mounts/mountIconCell"			--坐骑灵犀
-- require "UI/mounts/OtherMounts"             --查看他人坐骑
-- require "UI/mounts/OtherMountsInfoNew"       --他人坐骑信息

-- require "UI/linggen/LingGenWin"				--灵根系统
-- require "UI/linggen/LingGen"				--灵根分页
-- require "UI/linggen/LGXiulianPage"			--真气修炼

-- require "UI/dreamland/DreamlandWin"			--梦境系统
-- require "UI/dreamland/NewDreamlandWin"			--梦境系统
-- require "UI/dreamland/DreamlandInfoWin"		--梦境信息
-- require "UI/dreamland/DreamlandCangkuWin"	--梦境仓库

-- require "UI/VIP/VipCellView"
-- require "UI/zhaocai/ZhaoCaiWin"				--招财进宝系统


-- require "UI/dujie/DujieWin"					--渡劫系统
-- require "UI/dujie/DujieResultWin"			--渡劫结果窗口
-- require "UI/dujie/DujieItemView"			--渡劫子页

-- require "UI/campBattle/CampBattleWin"		--阵营试炼窗口
-- require "UI/campBattle/BattlePage"			--阵营试炼子页
-- require "UI/campBattle/CampBattleResultWin"	--阵营战结果窗口
-- require "UI/campBattle/CampBattleTaskWin"	--阵营战的任务窗口
-- require "UI/campBattle/CampTaskCellView"	--阵营战任务cell

-- require "UI/activity/ActivitySubWin"		--活动子窗口
-- require "UI/activity/ActivityDialog"		--活动子窗口
-- require "UI/xianyu/XianYuWin"				--灵泉仙浴窗口，其实只有两个按钮

-- require "UI/tongji/FubenChestView"			--诛仙阵副本的宝箱
-- require "UI/tongji/CampBattleTongjiView"	--阵营战的统计界面
-- require "UI/tongji/FubenTongjiView"			--普通副本统计
-- require "UI/tongji/TianYuanTongjiView"		--天元战统计
-- require "UI/tongji/BaguadigongTongjiView"	--八卦地宫统计
-- require "UI/tongji/BaguadigongCellView"		--八卦地宫统计cell
-- require "UI/tongji/ZiYouSaiView"			-- 自由赛统计
-- require "UI/tongji/ZhengBaSaiView"			-- 争霸赛统计
__init_ui[33] = function ()
-- require "UI/buff/ShangJinBuffView"			--赏金副本的buff效果
-- require "UI/main/ComboAttackView"			--赏金副本外的连斩效果
end

__init_ui[34] = function ()
-- require "UI/achieve/AchieveWin";			-- 成就窗口
-- require "UI/main/UserPanel"					--用户头像面板
-- require "UI/main/ExpPanel"				--经验条
end

__init_ui[35] = function ()
-- require "UI/main/RightTopPanel"
-- require "UI/main/MenusPanel"				--下面的一栏按钮
end

__init_ui[36] = function ()
-- require "UI/main/TeamBtnsPanel"				-- 任务快捷栏队伍页的panel
-- require "UI/main/XDHTongjiActionPanel"				-- 仙道會点击统计面板后弹出的下注、扔鸡蛋等行为的操作面板
-- require "UI/main/MirrorNearWin"			--放大镜
end

__init_ui[37] = function ()
-- require "UI/fight/FightValueWin"	--战斗力界面
-- require "UI/doufatai/DouFaTaiWin"	--斗法台界面
-- require "UI/doufatai/DouFaTaiResult"	--斗法台结果对话框
-- require "UI/doufatai/DouFaTaiRank"	-- 显示斗法台弹出的排行榜
-- require "UI/doufatai/DouFaTaiHistory"	-- 显示斗法台弹出的挑战历史窗口

-- require "UI/minimap/MiniMapWin"		--小地图
-- require "UI/minimap/CurrentMapPage"
-- require "UI/minimap/WorldMapPage"
-- require "UI/minimap/MicroMapView"	
end

__init_ui[38] = function ()

end

__init_ui[39] = function ()
-- require "UI/welcome/WelcomeWin"							--欢迎界面
require "UI/component/AlertWin"                         -- 提示框

--require "UI/resurrection/ResurrectionDialog"			-- 复活对话框
-- require "UI/component/PopupView"						-- 点击空白地区会关闭的控件
end

__init_ui[40] = function ()
require "UI/sceneLoading/SceneLoadingWin"			-- 场景加载界面

-- require "UI/whole/WholeWin"			                -- 显示在整个UI上层的内容

-- **************************************
-- require "model/WelfareModel"
end
-- require "UI/shuangxiu/XunRenShuangXiuWin"						-- 寻人打坐双修
-- require "UI/shuangxiu/YQSXWin"						-- 邀请打坐双修
-- require "UI/shuangxiu/DaZuoWin"						-- 正在打坐时的界面
-- require "UI/activity/ActivityWin"                   -- 活动窗口
-- require "UI/entrust/EntrustWin"                     -- 委托窗口
-- require "UI/mail/MailWin"				            -- 邮件窗口
-- require "UI/mail/MailContentWin"				    -- 邮件内容窗口

-- require "UI/petBattle/PetBattleScene"				-- 宠物战斗场景



-- require "UI/activity/FubenActivityPage"
-- require "UI/activity/FBChallengePage"
-- require "UI/activity/DailyActivityPage"
-- require "UI/activity/BossActivityPage"
-- require "UI/activity/ActivityAwardPage"

-- require "UI/activity/LoopTaskActivityCell"
-- require "UI/activity/loopTaskActivityPage"

-- --聚仙令
-- require "UI/juxianling/JuxianlingWin"
-- require "UI/juxianling/TeamFamPage"
-- require "UI/juxianling/ScoreExchangePage"
-- -- 组队系统
-- require "UI/activity/team/TeamWin"
-- require "UI/juxianling/CreateTeamDialog"
-- require "UI/juxianling/TeamFilterDialog"

-- require "UI/activity/TeamActivityPage"
-- require "UI/activity/FBSweepDialog"
-- require "UI/activity/FBExpDialog"
-- require "UI/activity/FBStorageWin"
-- require "UI/activity/FBChallengeWin"				-- 挑战副本窗口
-- require "UI/activity/UniqueSkillFBResultWin"

-- require "UI/activity/DailyWelfarePage"
-- require "UI/activity/RechargeGiftPage"
-- require "UI/activity/ActivityGiftPage"
-- require "UI/activity/XiaoFeiLiBao"
-- require "UI/activity/dailywelfare/DailyWelfareRU"
-- require "UI/activity/dailywelfare/DailyWelfareRD"
-- require "UI/activity/dailywelfare/DailyWelfareLU"
-- require "UI/activity/dailywelfare/DailyWelfareLD"

-- require "UI/activity/QQBrowserDialog"			--QQ浏览器安装有奖界面
-- require "UI/activity/QQWeiXinDialog"			--QQ微信安装有奖界面
-- require "UI/activity/XiaoFeiReturnWin"		    --消费返回界面
-- require "UI/activity/ShenMiShopWin"		    	--神秘商店
-- require "UI/activity/FriendsDrawWin"			-- 密友抽奖活动
-- require "UI/activity/FriendsDrawPage"			-- 密友摇奖页面

-- require "UI/jingkuang/JingKuangWin"		    --晶矿
-- require "UI/jingkuang/MyKuangPage"		    --晶矿
-- require "UI/jingkuang/XuanKuangPage"		    --晶矿

-- require "UI/entrust/enstrst_win_config"
-- require "UI/entrust/EntrustPage"


--天降雄狮情人节活动和春节活动
-- require "UI/activity/Common/LonelyDay/CLonelyDayWin"           				-- 光棍节活动
-- require "UI/activity/Common/ValentineDay/ValentineDayWin"           		-- 情人节活动
-- require "UI/activity/Common/ValentineWhiteDay/ValentineWhiteDayWin"         -- 白色情人节活动
-- require "UI/activity/Common/LanternDay/LanternDayWin"           			-- 元宵节活动
-- require "UI/activity/Common/ValentineDay/DailyQuotaBuyWin"                  -- 每日限购活动
-- require "UI/activity/Common/WomensDay/WomensDayWin"           				-- 妇女节活动
-- require "UI/activity/PobingActivityWin"                  					-- 破冰活动
-- require "UI/activity/Common/QingmingDay/QingmingDayWin"      				-- 清明节活动
-- require "UI/activity/Common/SummerDay/SummerDayWin"      					-- 清明节活动
-- require "UI/activity/Common/VersionCelebration/VersionCelebrationWin"      	-- 清明节活动
-- require "UI/activity/Common/WorkDay/WorkDayWin"      						-- 劳动节活动
 
-- 第二个模板活动
-- require "SUI/activity/template/childrenday/ChildrenDayWin" 					-- 儿童节(6.1)
-- require "UI/activity/common2/duanwu/DuanWuWin" 					-- 端午节

-- require "UI/exchange/ExchangeList"

-- require "UI/forge/Strengthen"
-- require "UI/forge/GemSet"
-- require "UI/forge/Synth"
-- require "UI/forge/Upgrade"
-- require "model/ForgeModel"


-- 宠物
-- require "UI/pet/PetWin"						--宠物
-- require "UI/pet/SuXingWin"					--宠物唤魂玉打开的苏醒界面
-- require "UI/pet/PetSkillTableWin"				-- 宠物技能图鉴
-- require "UI/pet/PetOpenEggWin"				--宠物开蛋
-- require "UI/pet/PetShowWin"					--宠物查看
-- require "UI/pet/PetInfoPage"
-- require "UI/pet/PetWuXingPage"
-- require "UI/pet/PetChengZhangPage"
-- require "UI/pet/PetSkillStudyPage"
-- require "UI/pet/PetSkillKeYinPage"
-- require "UI/pet/PetRongHePage"

-- require "UI/guild/GuildList"
-- require "UI/guild/GuildAltarEggPage"
-- require "UI/guild/GuildAltarPage"
-- require "UI/guild/GuildInfoPage"
-- require "UI/guild/GuildMember"
-- require "UI/guild/ApplyList"
-- require "UI/guild/GuildApplyWin"
-- require "UI/guild/GuildBuilding"
-- require "UI/guild/GuildTianyan"
-- require "UI/guild/GuildDetailPanel"
-- require "UI/guild/guild_info_page/GuildInfoPageLeft"
-- require "UI/guild/guild_info_page/GuildInfoPageRight"
-- require "UI/guild/tian_yuan_page/GuildTianyanLeft"
-- require "UI/guild/tian_yuan_page/GuildTianyanRight"
-- require "UI/guild/GuildAction"

-- require "UI/set/SetInformationPage"
-- require "UI/set/SetSystemPage"
-- require "UI/set/SetOnHookPage"

-- tips系统

-- require "UI/tips/DressTipView"
-- require "UI/tips/FootEffectTipView"
-- require "UI/tips/EquipTipView"
-- require "UI/tips/ItemTipView"
-- require "UI/tips/PetSkillTipView"
-- require "UI/tips/PetTipView"
-- require "UI/tips/SkillTipView"
-- require "UI/tips/StoneTipView"
-- require "UI/tips/ShenShouCifuTipView"
-- require "UI/tips/StrongTipView"
-- require "UI/tips/WingSkillTipView"
-- require "UI/tips/WingTipView"
-- require "UI/tips/MeirenTipView"
-- require "UI/fabao/MeiRenExchange"			-- 美人兑换窗口
-- require "UI/tips/TianyuanBuffTipView"
-- require "UI/tips/XianhunTipView"	

__init_ui[41] = function ()
-- require "UI/tips/TipsWin"					--Tips 
-- require "UI/tips/MoneyTipView"
end
-- require "UI/tips/MarriageHeartTipView"
-- require "UI/tips/MarriageXYTipView"
-- require "UI/tips/MarriageDetailTipView"
-- require "UI/tips/TransformTipView"
-- require "UI/tips/UserBuffTips"
-- require "UI/tips/SpecialMountTip"
-- require "UI/tips/SimpleTipView"
-- require "UI/tips/MiJiItemTipView"
-- require "UI/tips/MountsItemTipView"		
-- require "UI/tips/ShenQiSkillTipView" 		--神器

-- require "UI/fabao/FabaoWin"					--法宝系统主窗口
-- require "UI/fabao/LianhunWin"				--法宝系统炼魂窗口
-- require "UI/fabao/FabaoDetailWin"			--法宝系统详细信息窗口
-- require "UI/fabao/FabaoUplevelWin"			--法宝系统升级窗口
-- require "UI/fabao/XianhunIntroWin"			--法宝系统仙魂介绍窗口
-- require "UI/fabao/XianhunCell"				--仙魂cell集合类

-- --灵器系统 （新法宝）
-- require "UI/fabao/LingqiWin"
-- require "UI/fabao/LingqiLeft"
-- require "UI/fabao/LingqiInfoPage"
-- require "UI/fabao/LingqiUpLevelWin"
-- require "UI/fabao/LingqiLianhunWin"
-- require "UI/fabao/QihunIntroWin"
-- require "UI/fabao/MeirenHouse"
-- require "UI/fabao/MakeCardPage"

-- require "UI/qiandao/QianDaoWin"
-- require "UI/qiandao/QDDayView"

-- require "UI/openServer/OpenServerActivityWin"	--开服活动窗口
-- require "UI/openServer/BigActivityWin"			--大型活动窗口
-- require "UI/openServer/OpSerActivityCell"		--活动cell
-- require "UI/openServer/OpSerActivityDetailCell"	--活动礼包详细cell

-- require "UI/secretary/secretary_win_config"  --小秘书
-- require "UI/secretary/secretaryrow/SecretaryRow"  
-- require "UI/secretary/secretaryrow/LoginSR"  
-- require "UI/secretary/secretaryrow/VipSR" 
-- require "UI/secretary/secretaryrow/QiandaoSR"  
-- require "UI/secretary/secretaryrow/ActivityPointSR"  
-- require "UI/secretary/secretaryrow/ExpSR" 
-- require "UI/secretary/secretaryrow/ZhaocaiSR"  
-- require "UI/secretary/secretaryrow/DoufataiSR"  
-- require "UI/secretary/secretaryrow/HuanleSR"  
-- require "UI/secretary/secretaryrow/FubenSR"  
-- require "UI/secretary/secretaryrow/ActivitySR"  
-- require "UI/secretary/secretaryrow/BossSR"  
-- require "UI/secretary/secretaryrow/ZhanyaoSR"  
-- require "UI/secretary/secretaryrow/YinliangSR"  
-- require "UI/secretary/secretaryrow/XianzongSR"  
-- require "UI/secretary/secretaryrow/SecretaryRowMgr"    
-- require "UI/secretary/SecretaryWin"          --小秘书
-- require "UI/secretary/TheHelperWin"          --小助手
-- require "UI/secretary/SecretaryPage"
-- require "UI/secretary/SecretaryNotice"
-- require "UI/secretary/CustomServicePage"


-- require "UI/miyou/MiyouWin"          --密友
-- require "UI/miyou/MiyouRow"			 --
-- require "UI/miyou/MiyouOLFriend"



-- require "UI/caiquan/CaiQuanWin"				--猜拳
-- require "UI/caiquan/CaiQuanCell"			--猜拳cell

-- require "UI/JiShou/JiShouWin"				--寄售界面
-- require "UI/JiShou/JiShouShangJiaWin"		--寄售上架
-- require "UI/gameoperation/SmallOperationActivityWin"	--小型运营活动
-- require "UI/gameoperation/SmallOperationActivityCell"	--小型运营活动奖励项
-- require "UI/xiandaohui/XianDaoHuiWin"		--仙道会
-- require "UI/xiandaohui/ResultDialog"		--比赛结束对话框
-- require "UI/xiandaohui/XiaZhuDialog"		--下注
-- require "UI/xiandaohui/ZBSJC"				--争霸赛进程
-- require "UI/xiandaohui/ZBSZB"				--争霸赛准备
-- require "UI/xiandaohui/ZBSActionWin"		--争霸赛动作窗口
-- require "UI/xiandaohui/XianDaoBaoHeWin"		--仙道宝盒


-- require "UI/plant/PlantWin"					--种植

-- require "UI/marriage/MarriageWin"			--结婚系统主窗口
-- require "UI/marriage/MarriageRightWin"		--结婚系统的右窗口
-- require "UI/marriage/MarriageQingyuanPage"	--情缘分页
-- require "UI/marriage/MarriageHunyanPage"	--婚宴分页
-- require "UI/marriage/MarriageYunchePage"	--云车分页
-- require "UI/marriage/MarriageUpRingPage"	--戒指升级分页
-- require "UI/marriage/MarriageHunyanInfoPage"--婚宴详细分页
-- require "UI/marriage/MarriageHunyanCell"	--婚宴详细列表的cell
-- require "UI/marriage/MarriageRecordPage"	--结婚记录分页
-- require "UI/marriage/MarriageRecordCell"	--结婚记录cell
-- require "UI/marriage/MarriageGetMarrWin"	--求婚窗口
-- require "UI/marriage/MarriageYuyueWin"		--预约窗口
-- require "UI/marriage/MarriagePlayWin"		--婚宴嬉戏功能

-- 新版结婚窗口
-- require "UI/marriage/MarriageWinNew"			--结婚系统主窗口
-- require "UI/marriage/MarriagePageQingMi"
-- require "UI/marriage/MarriagePageHunYan"
-- require "UI/marriage/MarriagePageHunChe"
-- require "UI/marriage/MarriageHunCheWin"

-- 角色选择卡
-- require "UI/login/SelectCard"
-- require "UI/login/LQCardM"					-- 烈枪·男
-- require "UI/login/LQCardF"					-- 烈枪·女
-- require "UI/login/YJCardM"					-- 逸剑·男
-- require "UI/login/YJCardF"					-- 逸剑·女
-- require "UI/login/YLCardM"					-- 妖轮·男
-- require "UI/login/YLCardF"					-- 妖轮·女
-- require "UI/login/YZCardM"					-- 月仗·男
-- require "UI/login/YZCardF"					-- 月仗·女

-- require "UI/zhanbu/ZhanBuWin"				--占卜
-- 欢乐斗
-- require "UI/huanledou/HLDMainWin"			--欢乐斗主界面
-- require "UI/huanledou/HLDZhuaBuXianPu"		--欢乐斗抓捕仙仆界面
-- require "UI/huanledou/HLDJieJiu"			--欢乐斗解救界面
-- require "UI/huanledou/HLDHuDongJiLu"		--欢乐斗互动记录
-- require "UI/huanledou/HLDYaZhaXianPu"		--欢乐斗压榨仙仆
-- require "UI/huanledou/HLDZhuPuHuDong"		--欢乐斗主仆互动
-- require "UI/huanledou/HLDZhuPuHuDongAction"	--欢乐斗主仆互动动作
-- require "UI/huanledou/HLDQiuJiu"			--欢乐斗求救界面

-- require "UI/kefu/KeFuWin"					--客服界面
-- require "UI/kajituijian/KaJiTuiJianWin"		--卡级推荐
-- require "UI/loginAward/LoginAwardWin"		--登录福利
-- require "UI/luckGuest/LuckGuestWin"			--幸运猜猜
-- require "UI/openbox/OpenBoxWin"				--开箱子
-- require "UI/openbox/OpenBoxDialog"			--开箱子提示框

-- require "UI/luopan/luo_pan_win_config"
-- require "UI/luopan/LuoPanPage"                           -- 罗盘区域
-- require "UI/luopan/LuoPanWin"				--罗盘界面

-- require "UI/codegift/CodeGiftWin"           -- 活动礼包

-- require "UI/tuangou/TuangouWin"				-- 团购
-- require "UI/llk/LlkGameWin"				-- 连连看小游戏
-- require "UI/pushBox/PushBoxWin"			-- 推箱子小游戏

-- 活动
-- require "UI/operateActivity/ServerActivityConfig"
-- require "UI/operateActivity/BigActivityWin"
-- require "UI/operateActivity/OpenServerActivityWin"
-- require "UI/operateActivity/OpSerActivityCell"
-- require "UI/operateActivity/OpSerActivityDetailCell"
-- require "UI/operateActivity/SmallOperationActivityCell"
-- require "UI/operateActivity/SmallOperationActivityWin"

-- require "UI/sevenDayAward/sevenDayAward"

-- require "UI/sevenDayAward/AwardWin"  --领奖系统  包含在线奖励和七日狂欢
-- require "UI/sevenDayAward/sevenDayAwardNew"  --领奖系统  包含在线奖励和七日狂欢
-- require "UI/sevenDayAward/onlineAwardPage"   -- 在线领取奖励页面
-- require "UI/sevenDayAward/loginAwardPage"


--小游戏 神魔之塔山寨
-- require "UI/shenMo/SMGameWin"
--衣柜系统
-- require "UI/wardrobe/WardrobeWin"
--
-- require "UI/jubaobag/JubaoBagWin"
-- require "UI/jubaobag/rankPage"
-- require "UI/jubaobag/jubaofightPage"

-- 变身系统
-- require "UI/transform/NinjaHead"
-- require "UI/transform/TransformWin"
-- require "UI/transform/TransformDevelopWin"
-- require "UI/transform/TransformStageWin"
-- require "UI/transform/TransformCardPage"
-- require "UI/transform/TransformSkillPage"
-- require "UI/transform/TransformIconCell"
-- require "UI/transform/NinjiaIconHead"

__init_ui[42] = function ()
-- require "UI/baguadigong/BaguadigongWin"		--八卦地宫 modify by chj @20160303
-- require "UI/component/NoticDialog"
-- require "UI/transform/TransformAvatarTitile"
end
-- require "UI/transform/TransformLeft"
-- require "UI/transform/TransformRight"
-- require "UI/transform/TransformTuJian"
-- require "UI/transform/TransformAoYi"
-- require "UI/transform/TransformBtnPage"
-- require "UI/transform/TuJianInactivePage"
-- require "UI/transform/DevelopBtnPage"
-- require "UI/transform/TuJianAttrBtnPage"
-- require "UI/transform/UpgradeBtnPage"
-- require "UI/transform/AoYiAttrBtnPage"
-- require "UI/transform/AoYiInactivePage"

-- 精灵系统
-- require "UI/genius/GeniusWin"
-- require "UI/genius/GeniusGetWin"
-- require "UI/genius/GeniusInfoPage"
-- require "UI/genius/GeniusJinJiePage"
-- require "UI/genius/GeniusJiNengPage"
-- require "UI/genius/GeniusLunHuiPage"
-- require "UI/genius/GeniusZhuangBeiPage"
-- require "UI/genius/GeniusHuaXingPage"
-- require "UI/genius/GeniusIconCell"
-- require "UI/genius/OtherGeniusInfoPage"

-- require "UI/elfin/ElfinLeftWin"
-- require "UI/elfin/ElfinRightWin"
-- require "UI/elfin/ElfinLevelLeftPage"
-- require "UI/elfin/ElfinItemLeftPage"
-- require "UI/elfin/ItemSmeltLeftPage"
-- require "UI/elfin/ElfinLevelRightPage"
-- require "UI/elfin/ElfinItemRightPage"
-- require "UI/elfin/Explore"
-- require "UI/elfin/ExploreBag"
-- require "UI/elfin/LvUpItem"
-- require "UI/elfin/ItemSmeltRightPage"
-- require "UI/elfin/ExploreStorage"
-- require "UI/elfin/ElfinInfoPage"
-- require "UI/elfin/ElfinEquipItem"

--福利中心
-- require "UI/benefit/OffLinePage"
-- require "UI/benefit/BenefitWin"
-- require "UI/benefit/BenefitLoginPage"
-- require "UI/benefit/BenefitActivePage"
-- require "UI/benefit/BenefitEXPPage"
-- require "UI/benefit/BenefitLoginCell"
-- require "UI/benefit/BenefitChakelaPage"
-- require "UI/benefit/QianDaoPage"

-- 团购
-- require "UI/activity/superGroupBuy/SuperTuanGouWin"
-- require "UI/activity/superGroupBuy/GroupBuyPage"
-- require "UI/activity/superGroupBuy/CountPointsPage"
-- require "UI/activity/superGroupBuy/BuyIntroPage"

-- 至尊特惠活动
-- require "UI/activity/tehui/TeHuiWin"

-- require "UI/activity/SendFlowerWin"   --送花排行榜活动活动
-- require "UI/activity/FlowerRankListWin"   --送花收花子活动弹出的排行榜小面板

-- 大活动模板(Test) 
-- require "UI/activity/template/ActiTemplateWin" 
-- require "UI/activity/template/ActiTestWin" 		-- 大活动测试窗口
-- require "UI/activity/template/ActiTestPageOne" 	-- 测试分页

-- 九宫神藏
-- require "UI/jiugong/JiuGongLeftWin"
-- require "UI/jiugong/JiuGongRightWin"


__init_ui[43] = function ()
-- 我要翻牌
-- require "UI/activity/OpenCardWin"
-- 每日充值 & 每日充值 多档次
-- require "UI/activity/DayChongZhiWin"
-- require "UI/activity/DayChongZhiMultiWin"
-- 连续充值
-- require "UI/activity/SeriesChongZhiWin"
end
-- 昆仑神树 & 昆仑神树仓库
-- require "UI/magictree/MagicTreeWin"
-- require "UI/magictree/MagicTreeCangkuWin"

-- 神龙密塔
-- require "UI/tower/DragonTower"

--镇妖塔系统
-- require "UI/ZhenYaoTa/ZhenYaoTaWin"
-- require "UI/ZhenYaoTa/ZYTLookWin"
-- require "UI/ZhenYaoTa/ZYTResultFail"
-- require "UI/ZhenYaoTa/ZYTResultSuccess"


-- 美人抽卡
-- require "UI/beauty/BeautyCardWin"
-- require "UI/beauty/BeautyCardResultWin"

-- 乾坤兑换
-- require "UI/QianKun/QianKunWin"

-- 淘宝树展示界面(单独活动)
-- require "UI/activity/TaoBaoWin"

-- 大富翁
-- require "UI/richman/RichManAcitivityWin"

-- require "UI/operateActivity/RenzhejijinWin"
-- require "UI/operateActivity/WeiXinActivityWin"
-- require "UI/main/TransformPreviewWin"
-- require "UI/operateActivity/WeiXinInputDialog"

__init_ui[44] = function ()
-- require 'UI/UI_Utilities'

--世界boss预警窗口
-- require "UI/worldBoss/WorldBossWin"

-- 主界面小任务面板上的其他面板view(如副本统计)
-- require "SUI/tongji/ActTargetView"  -- 模板
end

__init_ui[45] = function ()
-- require "SUI/tongji/LlhjMiniView"   -- 箴机奇图
-- require "SUI/tongji/XuanYuanView" 	-- 逐鹿中原
-- require "SUI/tongji/ZyzMiniView" 	-- 阵营战
-- require "SUI/tongji/YwzcMiniView"	-- 尤乌战场
-- require "SUI/tongji/JuqingMiniView"	-- 剧情副本
end

__init_ui[46] = function ()
-- 最后require UIManager
-- ★这句一定要放最后
require "UI/UIManager"
end