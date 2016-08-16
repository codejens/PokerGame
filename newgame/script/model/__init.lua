-- InitModel.lua
-- 这里将会将全部的model统一加载，以便掌握加载进度
__init_model = {}

--分批加载 加载界面动画才能动起来
--新加的也加个函数
-- __init_model[1] = function ()
-- require "UIResourcePath"
-- require "model/ChatModel/ChatFaceModel"
-- require "model/ChatModel/ChatFlowerModel"
-- end

-- -- "model/ChatModel"
-- -- require "model/ChatModel/ChatChanelSelectModel"

-- __init_model[2] = function ()
-- require "model/ChatModel/ChatInfoMode"
-- require "model/ChatModel/ChatModel"
-- require "model/ChatModel/ChatPrivateChatModel"
-- end

-- __init_model[3] = function ()
-- require "model/ChatModel/ChatXZModel"

-- -- "model/FriendModel"
-- require "model/FriendModel/FriendAddModel"
-- end

-- __init_model[4] = function ()
-- require "model/FriendModel/FriendCelerbrateModel"
-- require "model/FriendModel/FriendFlowerThankModel"
-- require "model/FriendModel/FriendInfoModel"
-- end

-- __init_model[5] = function ()
-- require "model/FriendModel/FriendModel"
-- require "model/FriendModel/FriendPersonalSetModel"
-- end

-- __init_model[6] = function ()
-- -- "model/FubenModel"
-- require "model/FubenModel/FubenCenterModel"
-- require "model/FubenModel/FuBenModel"
-- require "model/FubenModel/FubenTongjiModel"
-- end
-- __init_model[7] = function ()
-- --漏掉写了。。补气来
-- end
-- __init_model[8] = function ()
-- require "model/WingModel"
-- require "model/AchieveModel"
-- require "model/ActivityModel"
-- end

-- __init_model[9] = function ()
-- -- require "model/EntrustModel"
-- require "model/CampBattleModel"
-- require "model/CangKuItemModel"
-- require "model/DFTModel"
-- end

-- __init_model[10] = function ()
-- require "model/GameSysModel"
-- require "model/GuildModel"
-- require "model/GuildCangKuItemModel"
-- end
-- -- require "model/DreamlandModel"
-- -- require "model/DujieModel"
-- -- require "model/ExchangeModel"
-- -- require "model/ForgeModel"

-- __init_model[11] = function ()
-- require "model/Hyperlink"
-- require "model/ItemModel"
-- require "model/LeftClickMenuMgr"
-- end

-- __init_model[12] = function ()
-- require "model/MailModel"
-- require "model/MallModel"
-- require "model/MiniMapModel"
-- end

__init_model[#__init_model+1] = function ()
-- require "model/MountsModel"
-- -- require "model/MysticalShopModel"
-- -- require "model/PetModel"
require "model/RoleModel"
-- require "model/SetSystemModel"
end

-- __init_model[14] = function ()
-- require "model/ShopModel"
-- -- require "model/SXModel"
-- require "model/TaskModel"
-- -- require "model/TeamModel"
-- require "model/TipsModel"
-- end

-- __init_model[15] = function ()
-- require "model/TopListModel"
-- require "model/UserInfoModel"
-- require "model/UserSkillModel"
-- end

-- __init_model[16] = function ()
-- require "model/VIPModel"
-- require "model/WelfareModel"
-- require "model/WorldBossModel"
-- end

-- __init_model[17] = function ()
-- require "model/XianYuModel"
-- require "model/ZhaoCaiModel"
-- require "model/LlkGameModel"
-- end

-- __init_model[18] = function ()
-- -- require "model/PushBoxModel"
-- -- require "model/MiyouModel"
-- require "model/BagModel"
-- require "model/KeyModel"
-- require "model/SCLBModel"
-- end

-- __init_model[19] = function ()
-- require "model/QianDaoModel"
-- require "model/FabaoModel"
-- end

-- __init_model[20] = function ()
-- require "model/LinggenModel"
-- require "model/ChongZhiModel"
-- end
-- -- require "model/BuniessModel"
-- -- require "model/TZFLModel"

-- -- require "model/SecretaryModel"
-- -- require "model/OpenSerModel"
-- __init_model[21] = function ()
-- require "model/PasswordModel"
-- require "model/ScreenNoticModel"
-- require "model/WholeModel"
-- end

-- __init_model[22] = function ()
-- require "model/BaguadigongModel"
-- require "model/SmallOperationModel"
-- require "model/ClosedBateActivityModel"
-- require "model/PaoHuanModel"
-- end

-- -- require "model/QuestionActivityModel"
-- -- require "model/CaiQuanModel"


-- -- require "model/JiShouModel"
-- -- require "model/JiShouShangJiaModel"

-- -- require "model/XDHModel"

-- -- require "model/HuanLeDouModel"

-- -- require "model/MarriageModel"

-- -- require "model/PlantModel"

-- -- require "model/QQVIPModel"
-- -- require "model/ZhanBuModel"
-- __init_model[23] = function ()
-- require "model/LoginLuckyDrawModel"
-- require "model/LoginAwardModel"
-- require "model/OnlineAwardModel"
-- end
-- -- require "model/sevenDayAwardModel"

-- __init_model[24] = function ()
-- -- require "model/QQBlueDiamonTimeAwardModel"
-- -- require "model/BigActivityModel"
-- require "model/SelectServerRoleModel"
-- -- require "model/LuopanModel"
-- -- require "model/TuangouModel"
-- -- require "model/WardrobeModel"
-- require "model/FashionModel"
-- end

-- __init_model[25] = function ()
-- -- require "model/BenefitModel"
-- -- require "model/TeamActivityMode"
-- require "model/NewerCampModel"

-- --团购
-- require "model/SuperGroupBuyModel"
-- end
-- -- require "model/TransformModel"
-- -- require "model/SpriteModel"
-- -- require "model/RenZheJiJinModel"

-- -- require "model/TehuiModel"
-- __init_model[26] = function ()
-- require "model/BuffModel"
-- require "model/activity/BAReceiveFlowerModel"   --大活动页面中子页面的收花排行榜活动
-- end
-- -- require "model/ElfinModel"


-- --神秘商店 晶旷
-- -- require "model/ShenMiShopModel"
-- -- require "model/JingkuangModel"

-- -- require "model/activity/LonelyDayModel"     		-- 情人节
-- -- require "model/activity/ValentineDayModel"     		-- 春节节
-- -- require "model/activity/LanternDayModel"     		-- 元宵节
-- -- require "model/activity/ValentineWhiteDayModel"     -- 光棍节
-- -- require "model/activity/QingmingDayModel"     		-- 清明节
-- -- require "model/activity/VersionCelebrationModel"    -- 版本庆典活动
-- -- require "model/activity/WomensDayModel"     		-- 妇女节
-- -- require "model/activity/SummerDayModel"     		-- 清凉一夏
-- -- require "model/activity/WorkDayModel"     			-- 劳动节
-- -- require "model/activity/DailyQuatoBuyModel"     	-- 每日限购活动
-- -- require "SUI/activity/template/childrenday/ChildrenDayModel"			-- 儿童节
-- -- require "model/activity/DuanWuModel"			-- 端午节
-- -- 密友摇奖活动
-- -- require "model/FriendsDrawModel"

-- -- require "model/activity/SendFlowerModel"     	--送花排行榜活动


-- -- require "model/activity/ActiTemplateModel"		-- 大活动公共模板

-- -- require "model/OpenCardModel" 	-- 我要翻牌
-- -- require "model/DayChongZhiModel" -- 每日充值
-- -- require "model/DayChongZhiMultiModel" -- 每日充值(多档次)
-- -- require "model/SeriesChongZhiModel" --连续充值

-- -- 昆仑神树
-- -- require "model/MagicTreeModel"
-- -- require "model/SkillMiJiModel"	-- 秘籍系统
-- -- require "model/ZhenYaoTaModel"	-- 秘籍塔
-- -- require "model/HeluoBooksModel"
-- -- require "model/BeautyCardModel"

-- -- 乾坤兑换
-- -- require "model/QianKunModel"

-- -- -- 大富翁
-- -- require "model/RichManModel"

-- -- require "model/ShenQiModel"		-- 神器
-- __init_model[27] = function ()
-- require "model/ZhuZhaoModel"	-- 铸造
-- require "model/SPartnerModel"	-- 伙伴(山海经)
-- require "model/SContactModel"	-- 社交(山海经)
-- end

-- __init_model[28] = function ()
-- require "model/SActivityModel"	
-- -- 活动(山海经)
-- require "model/SFuBenModel"		-- 副本(山海经)
-- require "model/STeamModel"		-- 组队(山海经)
-- end

-- __init_model[29] = function ()
-- require "model/TitleModel"      -- 称号系统的model    By  FJH
-- require "model/SChiYingModel/SChiYingModel" 	-- 赤影传说系统的model By FJH
-- end


-- -- require "model/SFriendModel/SFriendModel"		-- 好友的model  By FJH

-- -- require "model/UserEquipAndAttrModel/UserEquipAndAttrModel"
-- __init_model[30] = function ()
-- --武将
-- require "model/WuJiangModel"

-- require "model/STipsModel"
-- require "model/SMainMenuModel"
-- require "model/SSkillResult/SSkillResultModel"
-- end

-- __init_model[31] = function ()
-- require "model/SSkillResult/SSkillQueueModel"
-- require "model/SSkillResult/SBreakSkill"

-- --寻宝
-- require "model/SGeocachingModel"
-- end

-- __init_model[32] = function ()
-- -- 斗法台model
-- require "model/SDoufataiModel"

-- --检查红点
-- require "model/CheckRedDotModel"

-- --变强
-- require "model/BianqiangModel"
-- end

-- __init_model[33] = function ()
-- -- 抢红包
-- require "model/RedPotModel"

-- -- 副本npc对话
-- require "model/SFBNpcModel"
-- end

-- __init_model[34] = function ()
-- --求助好友
-- require "model/SReqFriendHelpModel"
-- -- 通缉板
-- require "model/WantedModel"
-- end

-- __init_model[35] = function ()
-- require "model/PkModel"	
-- -- 琴棋书画
-- require "model/QinqishuhuaModel"
-- require "model/YouwuzhanchangModel"
-- --战队系统
-- require "model/ClansModel"
-- end

-- __init_model[36] = function ()
-- --单人天梯
-- require "model/DrttModel"

-- -- 组队天梯
-- require "model/SZdttModel"

-- require "model/SBingJianModel"

-- require "model/RewardWzglModel"
-- end

-- __init_model[37] = function ()
-- --长歌行剧情逻辑
-- require "model/SMovieClientModel"
-- require "movieclient/MovieClient"
-- end

local function model_init()
-- 		-- ZXLog('model_init Begin')
		reload('model/GameUrl_global')
		reload("model/RoleModel")
-- 		-- ZXLog('model_init End')
-- 		CheckRedDotModel:init()
end

__init_model[#__init_model+1] = function ()
	model_init();
end

-- -- 谁与争锋 抢答题系统
-- __init_model[39] = function ()
-- 	require "model/SyzfModel"
-- 	require "model/ZhuZhaoCheckModel"
-- 	require "model/SMainActivityModel"
-- 	require "model/WJDCModel"
-- end

-- __init_model[40] = function ()
-- 	-- 专题活动用的model
-- 	require "model/SpecialModel"
-- 	require "model/KeyBoardModel"
-- end

-- -- 退出游戏的时候 析构model
-- -- 每个模块都需要写析构函数，如果没有析构函数统一都会报错
-- -- 每个人都必须保证自己的model是完美析构的，
-- -- 尤其是timer callback等时间变量
-- function fini_model()
-- 	ClansModel:fini()
-- 	CheckRedDotModel:fini()
-- 	-- ChatChanelSelectModel:fini()
-- 	SSkillResultModel:fini()
-- 	SSkillQueueModel:fini()
-- 	ChatFaceModel:fini()
-- 	ChatFlowerModel:fini()
-- 	ChatInfoMode:fini()
-- 	-- ChatModel:fini()
-- 	ChatPrivateChatModel:fini()
-- 	ChatXZModel:fini()

-- 	FriendAddModel:fini()
-- 	FriendCelerbrateModel:fini()
-- 	FriendFlowerThankModel:fini()
-- 	FriendInfoModel:fini()
-- 	FriendModel:fini()
-- 	FriendPersonalSetModel:fini()

-- 	FubenCenterModel:fini()
-- 	FuBenModel:fini()
-- 	FubenTongjiModel:fini()

-- 	WingModel:fini()
-- 	AchieveModel:fini()
-- 	ActivityModel:fini()
-- 	CampBattleModel:fini()
-- 	CangKuItemModel:fini()
-- 	GuildCangKuItemModel:fini()
-- 	DFTModel:fini()
-- 	-- DreamlandModel:fini()
-- 	-- DujieModel:fini()
-- 	-- ExchangeModel:fini()
-- 	-- ForgeModel:fini()
-- 	GameSysModel:fini()
-- 	GuildModel:fini()
-- 	Hyperlink:fini()
-- 	ItemModel:fini()
-- 	LeftClickMenuMgr:fini()
-- 	MailModel:fini()
-- 	MallModel:fini()
-- 	MiniMapModel:fini()
-- 	MountsModel:fini()
-- 	-- MysticalShopModel:fini()
-- 	-- PetModel:fini()
-- 	RoleModel:fini()
-- 	SetSystemModel:fini()
-- 	ShopModel:fini()
-- 	-- SXModel:fini()
-- 	TaskModel:fini()
-- 	TipsModel:fini()
-- 	TopListModel:fini()
-- 	UserInfoModel:fini()
-- 	UserSkillModel:fini()
-- 	VIPModel:fini()
-- 	WelfareModel:fini()
-- 	WorldBossModel:fini()
-- 	-- XianYuModel:fini()
-- 	ZhaoCaiModel:fini()
-- 	BagModel:fini()
-- 	KeyModel:fini()
-- 	SCLBModel:fini()
-- 	QianDaoModel:fini()
-- 	FabaoModel:fini()
-- 	-- BuniessModel:fini()
-- 	-- TZFLModel:fini()
-- 	LinggenModel:fini()
-- 	ChongZhiModel:fini()
-- 	-- SecretaryModel:fini()
-- 	-- OpenSerModel:fini()
-- 	PasswordModel:fini()
-- 	ScreenNoticModel:fini()
-- 	CenterNoticModel:fini()
-- 	ScreenNoticRunModel:fini()
-- 	WholeModel:fini()

-- 	BaguadigongModel:fini();
-- 	-- QuestionActivityModel:fini();
-- 	-- CaiQuanModel:fini();
-- 	-- PaoHuanModel:fini();
-- 	SmallOperationModel:fini();

-- 	-- MarriageModel:fini();
	
-- 	-- JiShouShangJiaModel:fini()
-- 	-- JiShouModel:fini();
-- 	-- PlantModel:fini()
-- 	-- ZhanBuModel:fini()
-- 	ClosedBateActivityModel:fini()
-- 	-- QQVIPModel:fini()
-- 	-- sevenDayAwardModel:fini()
-- 	-- QQBlueDiamonTimeAwardModel:fini()
-- 	LoginAwardModel:fini(  )
-- 	-- TransformModel:fini(  )
-- 	-- SpriteModel:fini(  )
-- 	-- RenZheJiJinModel:fini()
-- 	NewerCampModel:fini()

-- 	-- ElfinModel:fini()
-- 	BuffModel:fini()
-- 	-- XDHModel:fini()
-- 	-- ShenMiShopModel:fini()
-- 	-- JingkuangModel:fini()
-- 	-- SendFlowerModel:fini()
-- 	BAReceiveFlowerModel:fini()

-- 	-- LonelyDayModel:finish()
-- 	-- ValentineDayModel:finish()
-- 	-- LanternDayModel:finish()
-- 	-- ValentineWhiteDayModel:finish()
-- 	-- QingmingDayModel:finish()
-- 	-- VersionCelebrationModel:finish()
-- 	-- WomensDayModel:finish()
-- 	-- SummerDayModel:finish()
-- 	-- WorkDayModel:finish()
-- 	-- DailyQuatoBuyModel:fini()

-- 	-- OpenCardModel:fini()
-- 	-- DayChongZhiModel:fini()
-- 	-- DayChongZhiMultiModel:fini()
-- 	-- SeriesChongZhiModel:fini()

-- 	-- MagicTreeModel:fini()
-- 	-- ZhenYaoTaModel:fini()
-- 	-- SkillMiJiModel:fini()
-- 	-- HeluoBooksModel:fini()

-- 	-- BeautyCardModel:fini()
-- 	-- ShenQiModel:fini()
-- 	-- RichManModel:fini()
-- 	WuJiangModel:fini()


-- 	TitleModel:fini() -- 重置称号系统model模块

-- 	SPartnerModel:fini()
-- 	SContactModel:fini()
-- 	SActivityModel:fini()
-- 	SFuBenModel:fini()
-- 	STeamModel:fini()
-- 	SGeocachingModel:fini()

-- 	SDoufataiModel:fini()
-- 	BianqiangModel:fini()

-- 	RedPotModel:fini()
-- 	SFBNpcModel:fini()
-- 	SReqFriendHelpModel:fini()	
-- 	WantedModel:fini()
-- 	PkModel:fini()
-- 	QinqishuhuaModel:fini()
-- 	FashionModel:fini()

-- 	DrttModel:fini( )
-- 	SGPublic:fini()
-- 	YouwuzhanchangModel:fini()
-- 	SChiYingModel:fini()

-- 	SZdttModel:fini()
-- 	SChiYingModel:fini()
-- 	SMovieClientModel:fini()
-- 	SyzfModel:fini()
-- 	RewardWzglModel:fini()

-- 	ZhuZhaoCheckModel:fini()
-- 	ZhuZhaoModel:fini(true)
-- 	BigActivityModel:fini()
-- 	SGeneralTips:fini()
-- 	SMainActivityModel:fini()
-- 	WJDCModel:fini()
-- 	SpecialModel:fini()
-- 	KeyBoardModel:fini()
-- 	ScreenRunNoticWin:fini()
-- end