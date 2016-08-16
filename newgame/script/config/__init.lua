-- __init.lua
-- created by aXing on 2013-3-26
-- 包引用文件
__init_config={}
--分批加载 加载界面动画才能动起来
--新加的也加个函数
__init_config[1] = function ()
-- require "../data/client/new_sys_config"
-- require "config/AchieveConfig"
-- require "config/ActivityAwardConfig"
end

__init_config[2] = function ()
-- require "config/ActivityConfig"
-- require "config/MeirenConfig"
-- require "config/EntrustConfig"
-- require "config/AIConfig"
end

__init_config[3] = function ()
-- require "config/ChatConfig"
-- require "config/ComAttribute"
-- require "config/DjConfig"
-- require "config/EffectConfig"

end

__init_config[4] = function ()
-- require "config/EntityConfig"
-- require "config/EquipEnhanceConfig"
end

__init_config[5] = function ()
-- require "config/EquipValueConfig"
-- require "config/FriendConfig"
end

__init_config[6] = function ()
-- require "config/FubenConfig"
-- require "config/GameConfig"
end

__init_config[7] = function ()
-- require "config/GlobalConfig"
-- require "config/GuildConfig"
end

__init_config[8] = function ()
-- require "config/HyperlinkConfig"
-- require "config/ItemConfig"
end

__init_config[9] = function ()
-- require "config/LiuDaoShopConfig"
-- require "config/MonsterConfig"
end

__init_config[10] = function ()
-- require "config/MountsConfig"
-- require "config/NPCStoreConfig"
-- -- require "config/PushBoxConf"
-- require "config/PetConfig"
end

__init_config[11] = function ()
-- require "config/PetTalkConfig"
-- require "config/QuestConfig"
-- require "config/RefreshQuestConfig"
-- require "config/RenownShopConfig"
end

__init_config[12] = function ()
-- -- require "config/RootConfig"
-- require "config/SceneConfig"
-- require "config/SkillConfig"
end

__init_config[13] = function ()
-- require "config/StaticAttriType"
-- require "config/StoreConfig"
end

__init_config[14] = function ()
-- require "config/SuitConfig"
-- require "config/TongjiConfig"
end

__init_config[15] = function ()
-- require "config/TopListConfig"
-- require "config/VIPConfig"
end

__init_config[16] = function ()
-- require "config/WingConfig"
-- require "config/WorldBossConfig"
end

__init_config[17] = function ()
-- require "config/XSZYConfig"
-- require "config/DreamlandConfig"
-- require "config/SCLBConfig"
end

__init_config[18] = function ()
-- require "config/EntityFrameConfig"
-- require "config/QDConfig"
-- require "config/TZFLConfig"
end

__init_config[19] = function ()
-- require "config/FabaoConfig"
-- require "config/ChongZhiConfig"
-- require "config/OpenSerConfig"
-- require "config/BuffConfig"
end

__init_config[20] = function ()
-- require "config/ShareConfig"
-- require "config/ZhanBuConfig"
-- require "config/QQVipConfig"
-- require "config/OperationActivityConfig"
end
-- require "config/QuestionConfig"
-- require "config/PlantConfig"
-- require "config/MarriageConfig"

__init_config[21] = function ()
-- require "config/sevenDayAwardConfig"

-- require "config/LuopanConfig"
-- require "config/EntityActionConfig"
end

__init_config[22] = function ()
-- require "config/BenefitConfig"
-- require "config/TeamActivityConfig"
end
-- require "config/SpriteConfig"
-- require "config/InstructionConfig"
-- require "config/TransformConfig"
-- require "config/LingQiLingQuConfig"
-- require "config/RenZheJiJinConfig"
-- require "config/WeiXinActConfig"

__init_config[23] = function ()
-- require "config/NewerCampConfig"
-- require "config/FBChallengeConfig"
-- require "config/ElfinConfig"
-- require "config/SuperGroupBuyConfig"
end

__init_config[24] = function ()
-- require "config/BigActivityConfig"
-- require "config/ZhuZhaoConfig"  --铸造
-- require "config/TitlesConfig"   -- 称号系统配置表  by  FJH
end
-- require "config/FriendsDrawConfig"
-- require "config/ActiTemplateConfig"
-- require "config/DayChongZhiConfig"
-- require "config/SeriesChongZhiConfig"
-- require "config/MagicTreeConfig"
--require "config/MijiConfig"	-- 秘籍系统
-- require "config/HeLuoConfig"
-- require "config/ZhenYaoTaConfig" -- 秘籍塔系统
-- require "config/BeautyCardConfig"
-- require "config/ShenQiConfig"	--神器
-- require "config/RichManConfig"  --大富翁


__init_config[25] = function ()
-- require "config/PartnerConfig"	-- 伙伴配置 add by chj @2015-09-25
end

__init_config[26] = function ()
-- require "config/RewardConfig"
-- require "config/WantedConfig" -- 通缉板
end

__init_config[27] = function ()
-- require "config/ProtectQuestConfig" -- 护送任务
-- require "config/PreLevelTaskConfig" -- 等级任务的前置任务 By FJH
-- require "config/XuanYuanConfig"
end

__init_config[28] = function ()
-- require "../data/bianshen_conf"
-- require '../data/movie/movie_gather_config'
-- require "config/WuLiShiLianConfig"
end
-- require "../data/puzhuaconfig" -- 捕抓特殊玩法配置表
-- require "../data/taozhaiconfig"


__init_config[29] = function ()
-- require "../data/titles"
-- require "../data/vip"
end

__init_config[30] = function ()
-- require '../data/movie/npc_head_id_config'
-- require "../data/equip_value"
end

__init_config[31] = function ()
-- 剧情副本配置
-- require "../data/movieclient/movieclient_config"
-- require "../data/movieclient/movieclient_dialogs"
end

__init_config[32] = function ()
-- require "../data/xuanshuangrenwuconfig"
-- require "../data/huoyuedu_config" -- 活跃度配置表
-- require "../data/mount_pos_config" -- 坐骑位置配置表
end

__init_config[33] = function ()
-- require "config/OnlineAwardConfig"
-- require "config/SChiYingConfig" -- 赤影传说配置表  by  FJH
-- require "../data/activationconfig" -- 活跃度 活动奖励
end

__init_config[34] = function ()
-- require "../data/movie/quest_monster_dialog"
-- require "../data/moneycardconf"
-- require "../data/flower_effect_config"
end

__init_config[35] = function ()
-- require "config/WuJiangConfig"
-- require "config/introduce_config"
-- require "../data/gather_task_desc"
end

__init_config[36] = function ()
-- require "../data/client/monster_action_config"
-- require "../data/looptaskconfig"
-- require "config/wjdcConfig"
-- require "config/DoubleRewardConfig"
end