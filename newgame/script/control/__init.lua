-- InitCC.lua
-- created by aXing on 2013-3-24
-- 这里将会将全部的CC统一加载，以便掌握加载进度
__init_control = {}

--分批加载 加载界面动画才能动起来
--新加的也加个函数
-- __init_control[1] = function ()
-- require "control/AchieveCC"				-- 成就系统
-- require "control/BuffCC"				-- Buff系统
-- require "control/CangKuCC"				-- 仓库系统
-- end

-- __init_control[2] = function ()
-- require "control/ChatCC"				-- 聊天系统
-- require "control/DouFaTaiCC"			-- 演武场系统
-- -- require "control/DreamlandCC"			-- 梦境系统
-- require "control/DropItemCC"			-- 拾取物品系统
-- end

-- __init_control[3] = function ()
-- require "control/FriendCC"				-- 好友系统
-- require "control/FubenCC"				-- 副本系统
-- require "control/GameLogicCC"			-- 主游戏逻辑
-- end

-- __init_control[4] = function ()
-- require "control/GuildCC"				-- 公会逻辑
-- require "control/ItemCC"				-- 道具逻辑
-- require "control/LingGenCC"				-- 灵根系统
-- end

-- __init_control[5] = function ()
-- require "control/MailCC"				-- 邮件系统
-- require "control/MallCC"				-- 商城系统
-- require "control/MiscCC"				-- Misc系统
-- end

-- __init_control[6] = function ()
-- require "control/MountsCC"				-- 坐骑系统
-- require "control/MoveCC"				-- 移动系统
-- require "control/NPCTradeCC"			-- npc商店
-- end

-- __init_control[7] = function ()
-- require "control/OnlineAwardCC"			-- 在线奖励系统
-- require "control/OthersCC"				-- 杂七杂八系统
-- -- require "control/PetCC"					-- 宠物系统
-- end

__init_control[#__init_control+1] = function ()
-- require "control/PKCC"					-- pk系统
require "control/SelectRoleCC"			-- 选择角色系统
-- require "control/SetSystemCC"			-- 系统设置
end

-- __init_control[9] = function ()
-- -- require "control/ShuangXiuCC"			-- 双修系统
-- require "control/TaskCC"				-- 任务系统
-- require "control/TeamCC"				-- 组队系统
-- end

-- __init_control[10] = function ()
-- require "control/UserEquipCC"			-- 装备系统
-- require "control/UserSkillCC"			-- 技能系统
-- require "control/VIPCC"					-- vip系统
-- end

-- __init_control[11] = function ()
-- require "control/WingCC"				-- 翅膀系统
-- -- require "control/DQMBCC"				-- 短期目标系统
-- require "control/KeySettingCC"			-- 快捷键系统
-- -- require "control/EntrustCC"			    -- 委托系统
-- require "control/FabaoCC"				-- 法宝系统
-- end

-- __init_control[12] = function ()
-- -- require "control/BuniessCC"				-- 交易
-- -- require "control/QuestionCC"			-- 答题系统
-- -- require "control/PaoHuanCC"				-- 跑环=======
-- -- require "control/CaiQuanCC"				-- 猜拳
-- -- require "control/JiShouCC"				--寄售
-- -- require "control/XianDaoHuiCC"			--仙道会
-- -- require "control/PlantCC"				--洞府
-- -- require "control/MarriageCC"			--结婚系统
-- -- require "control/MiyouCC"			    --密友系统
-- require "control/ClosedBateActivityCC"	--封测活动
-- require "control/ClosedBateActivityCC"	--封测活动
-- -- require "control/QingrenjieCC"			--情人节活动
-- -- require "control/HuanLeDouCC"			--欢乐斗系统
-- require "control/OtherActivitiesCC"			--欢乐斗系统
-- -- require "control/WardrobeCC"			--衣柜系统
-- require "control/FashionCC"			--衣柜系统
-- end

-- __init_control[13] = function ()
-- -- require "control/TransformCC"			-- 变身系统
-- -- require "control/SpriteCC"				-- 精灵系统
-- require "control/TeamActivityCC"        -- 组队副本
-- require "control/NewerCampCC"			-- 新手体验副本
-- require "control/NewerCampServerCC"
-- require "control/DummyControlCC"
-- end

-- __init_control[14] = function ()
-- require "control/PartnerCC"				-- 伙伴
-- require "control/ProtocalCC"			-- 协议编辑器
-- require "control/SActivityCC"			-- 山海经活动
-- end
-- -- require "control/ElfinCC"
-- -- require "control/JingKuangCC"			--晶矿
-- -- require "control/OpenCardCC"   			-- 修复城墙(我要翻牌)
-- -- require "control/SkillMiJiCC" 			--技能秘籍
-- -- require "control/MagicTreeCC" 			-- 昆仑神树
-- -- require "control/HeLuoBooksCC"          --洛书
-- -- require "control/ZhenYaoTaCC"			--镇妖塔
-- -- require "control/BeautyCardCC"          
-- -- require "control/ShenQiCC"          	-- 神器


-- __init_control[15] = function ()
-- require "control/ChiYingCC"				-- 赤影传说

-- require "control/WantedCC"				-- 通缉

-- require "control/SGeocachingCC" 		-- 寻宝
-- end
-- -- require "control/SLuaFubenCC"			-- Lua副本系统（shj添加）


-- __init_control[16] = function ()
-- require "control/FubenExtCC" 			-- Lua副本系统（shj添加）

-- require "control/SpecialTaskCC"			-- 特殊玩法协议

-- require "control/RedPotCC"				-- 抢红包协议
-- end

-- __init_control[17] = function ()
-- require "control/QinqishuhuaCC"			-- 琴棋书画协议

-- require "control/DrttCC"				-- 单人天梯协议
-- require "control/ClansCC" 				-- 战队系统
-- end

-- __init_control[18] = function ()
-- require "control/BingJianCC"			-- 并肩作战协议
-- end

-- __init_control[19] = function ()
-- require "control/WuJiangCC"			--武将协议
-- require "control/PaoHuanCC"
-- end
