-- InitModel.lua
-- created by aXing on 2013-3-24
-- 这里将会将全部的model统一加载，以便掌握加载进度

require "UIResourcePath"
-- "model/ChatModel"
require "model/ChatModel/ChatChanelSelectModel"
require "model/ChatModel/ChatFaceModel"
require "model/ChatModel/ChatFlowerModel"
require "model/ChatModel/ChatInfoMode"
require "model/ChatModel/ChatModel"
require "model/ChatModel/ChatPrivateChatModel"
require "model/ChatModel/ChatThankModel"
require "model/ChatModel/ChatXZModel"

-- "model/FriendModel"
require "model/FriendModel/FriendAddModel"
require "model/FriendModel/FriendCelerbrateModel"
require "model/FriendModel/FriendFlowerThankModel"
require "model/FriendModel/FriendInfoModel"
require "model/FriendModel/FriendModel"
require "model/FriendModel/FriendPersonalSetModel"

-- "model/FubenModel"
require "model/FubenModel/FubenCenterModel"
require "model/FubenModel/FuBenModel"
require "model/FubenModel/FubenTongjiModel"

require "model/WingModel"
require "model/AchieveModel"
require "model/ActivityModel"
require "model/EntrustModel"
require "model/CampBattleModel"
require "model/CangKuItemModel"
require "model/DFTModel"
require "model/DreamlandModel"
require "model/DujieModel"
require "model/ExchangeModel"
require "model/ForgeModel"
require "model/GameSysModel"
require "model/GuildModel"
require "model/GuildCangKuItemModel"
require "model/Hyperlink"
require "model/ItemModel"
require "model/LeftClickMenuMgr"
require "model/MailModel"
require "model/MallModel"
require "model/MiniMapModel"
require "model/MountsModel"
require "model/MysticalShopModel"
require "model/PetModel"
require "model/RoleModel"
require "model/SetSystemModel"
require "model/ShopModel"
require "model/SXModel"
require "model/TaskModel"
require "model/TeamModel"
require "model/TipsModel"
require "model/TopListModel"
require "model/UserInfoModel"
require "model/UserSkillModel"
require "model/VIPModel"
require "model/WelfareModel"
require "model/WorldBossModel"
require "model/XianYuModel"
require "model/ZhaoCaiModel"
require "model/LlkGameModel"
require "model/PushBoxModel"
require "model/MiyouModel"
require "model/GoalModel"
require "model/BagModel"
require "model/KeyModel"
require "model/SCLBModel"
require "model/QianDaoModel"
require "model/FabaoModel"
require "model/BuniessModel"
require "model/TZFLModel"
require "model/LinggenModel"
require "model/ChongZhiModel"
require "model/SecretaryModel"
require "model/OpenSerModel"
require "model/PasswordModel"
require "model/ScreenNoticModel"
require "model/WholeModel"
require "model/BaguadigongModel"
require "model/QuestionActivityModel"
require "model/CaiQuanModel"
require "model/PaoHuanModel"

require "model/JiShouModel"
require "model/JiShouShangJiaModel"
require "model/SmallOperationModel"
require "model/XDHModel"

require "model/HuanLeDouModel"

require "model/MarriageModel"

require "model/PlantModel"
require "model/ClosedBateActivityModel"
require "model/QQVIPModel"
require "model/ZhanBuModel"

require "model/sevenDayAwardModel"
require "model/LoginLuckyDrawModel"
require "model/LoginAwardModel"
require "model/OnlineAwardModel"
require "model/QQBlueDiamonTimeAwardModel"
require "model/BigActivityModel"
require "model/SelectServerRoleModel"
require "model/LuopanModel"
require "model/TuangouModel"
-- require "model/WardrobeModel"

require "model/TransformModel"
require "model/SpriteModel"
require "model/RenZheJiJinModel"
require "model/BenefitModel"
require "model/TeamActivityMode"
require "model/NewerCampModel"

--团购
require "model/SuperGroupBuyModel"
require "model/TehuiModel"

require "model/ElfinModel"
require "model/BuffModel"

--神秘商店 晶旷
require "model/ShenMiShopModel"
require "model/JingkuangModel"

require "model/activity/LonelyDayModel"     	--情人节
require "model/activity/ValentineDayModel"     	--春节节
require "model/activity/LanternDayModel"     	--元宵节
require "model/activity/ValentineWhiteDayModel"     	--光棍节
require "model/activity/QingmingDayModel"     	--清明节
require "model/activity/VersionCelebrationModel"     	--版本庆典活动
require "model/activity/WomensDayModel"     	--妇女节
require "model/activity/SummerDayModel"     	--清凉一夏
require "model/activity/WorkDayModel"     	--劳动节
require "model/activity/DailyQuatoBuyModel"     	--每日限购活动
-- 密友摇奖活动
require "model/FriendsDrawModel"

require "model/activity/SendFlowerModel"     	--送花排行榜活动
require "model/activity/BAReceiveFlowerModel"   --大活动页面中子页面的收花排行榜活动

require "model/activity/ActiTemplateModel"		-- 大活动公共模板

require "model/OpenCardModel" 	-- 我要翻牌
require "model/DayChongZhiModel" -- 每日充值
require "model/DayChongZhiMultiModel" -- 每日充值(多档次)
require "model/SeriesChongZhiModel" --连续充值

-- 昆仑神树
require "model/MagicTreeModel"
require "model/SkillMiJiModel"	-- 秘籍系统
require "model/ZhenYaoTaModel"	-- 秘籍塔
require "model/HeluoBooksModel"
require "model/BeautyCardModel"

-- 乾坤兑换
require "model/QianKunModel"

local function model_init()
	ZXLog('model_init Begin')
	reload('model/GameUrl_global')
	reload("model/RoleModel")
	ZXLog('model_init End')
end

model_init();


-- 退出游戏的时候 析构model
-- 每个模块都需要写析构函数，如果没有析构函数统一都会报错
-- 每个人都必须保证自己的model是完美析构的，
-- 尤其是timer callback等时间变量
function fini_model()

	ChatChanelSelectModel:fini()
	ChatFaceModel:fini()
	ChatFlowerModel:fini()
	ChatInfoMode:fini()
	ChatModel:fini()
	ChatPrivateChatModel:fini()
	ChatThankModel:fini()
	ChatXZModel:fini()

	FriendAddModel:fini()
	FriendCelerbrateModel:fini()
	FriendFlowerThankModel:fini()
	FriendInfoModel:fini()
	FriendModel:fini()
	FriendPersonalSetModel:fini()

	FubenCenterModel:fini()
	FuBenModel:fini()
	FubenTongjiModel:fini()

	WingModel:fini()
	AchieveModel:fini()
	ActivityModel:fini()
	CampBattleModel:fini()
	CangKuItemModel:fini()
	GuildCangKuItemModel:fini()
	DFTModel:fini()
	DreamlandModel:fini()
	DujieModel:fini()
	ExchangeModel:fini()
	ForgeModel:fini()
	GameSysModel:fini()
	GuildModel:fini()
	Hyperlink:fini()
	ItemModel:fini()
	LeftClickMenuMgr:fini()
	MailModel:fini()
	MallModel:fini()
	MiniMapModel:fini()
	MountsModel:fini()
	MysticalShopModel:fini()
	PetModel:fini()
	RoleModel:fini()
	SetSystemModel:fini()
	ShopModel:fini()
	SXModel:fini()
	TaskModel:fini()
	TeamModel:fini()
	TipsModel:fini()
	TopListModel:fini()
	UserInfoModel:fini()
	UserSkillModel:fini()
	VIPModel:fini()
	WelfareModel:fini()
	WorldBossModel:fini()
	XianYuModel:fini()
	ZhaoCaiModel:fini()
	--GoalModel:fini()
	BagModel:fini()
	KeyModel:fini()
	SCLBModel:fini()
	QianDaoModel:fini()
	FabaoModel:fini()
	BuniessModel:fini()
	TZFLModel:fini()
	LinggenModel:fini()
	ChongZhiModel:fini()
	SecretaryModel:fini()
	OpenSerModel:fini()
	PasswordModel:fini()
	ScreenNoticModel:fini()
	CenterNoticModel:fini()
	ScreenNoticRunModel:fini()
	WholeModel:fini()

	BaguadigongModel:fini();
	QuestionActivityModel:fini();
	CaiQuanModel:fini();
	PaoHuanModel:fini();
	SmallOperationModel:fini();

	MarriageModel:fini();
	
	JiShouShangJiaModel:fini()
	JiShouModel:fini();
	PlantModel:fini()
	ZhanBuModel:fini()
	ClosedBateActivityModel:fini()
	QQVIPModel:fini()
	sevenDayAwardModel:fini()
	QQBlueDiamonTimeAwardModel:fini()
	LoginAwardModel:fini(  )
	TransformModel:fini(  )
	SpriteModel:fini(  )
	RenZheJiJinModel:fini()
	TeamActivityMode:fini()
	NewerCampModel:fini()

	ElfinModel:fini()
	BuffModel:fini()
	XDHModel:fini()
	ShenMiShopModel:fini()
	JingkuangModel:fini()
	SendFlowerModel:fini()
	BAReceiveFlowerModel:fini()

	LonelyDayModel:finish()
	ValentineDayModel:finish()
	LanternDayModel:finish()
	ValentineWhiteDayModel:finish()
	QingmingDayModel:finish()
	VersionCelebrationModel:finish()
	WomensDayModel:finish()
	SummerDayModel:finish()
	WorkDayModel:finish()
	DailyQuatoBuyModel:fini()

	OpenCardModel:fini()
	DayChongZhiModel:fini()
	DayChongZhiMultiModel:fini()
	SeriesChongZhiModel:fini()

	MagicTreeModel:fini()
	ZhenYaoTaModel:fini()
	SkillMiJiModel:fini()
	HeluoBooksModel:fini()

	BeautyCardModel:fini()
end