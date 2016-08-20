-- AIConfig.lua
-- created by hcl on 2013-1-25
-- AI配置

-- super_class.AIConfig()
AIConfig = {}

AIConfig.COMMAND_IDLE = 0;				-- 空闲
AIConfig.COMMAND_MOVE = 1;				-- 移动命令
AIConfig.COMMAND_ASK_NPC = 2;			-- 访问NPC
AIConfig.COMMAND_KILL_MONSTER = 3;		-- 杀怪
AIConfig.COMMAND_GATHER = 4;			-- 采集
AIConfig.COMMAND_GUAJI = 5;				-- 挂机
AIConfig.COMMAND_FUBEN_GUAJI = 6;		-- 副本挂机
AIConfig.COMMAND_ENTER_SCENE = 7;		-- 切换场景
AIConfig.COMMAND_DO_QUEST = 8;			-- 执行任务
AIConfig.COMMAND_DO_ZIDINGYI_QUEST = 9 	-- 自定义任务
AIConfig.COMMAND_ENTER_FUBEN = 10;		-- 切换副本
AIConfig.COMMAND_FOLLOW = 11;			-- 跟随其他玩家
AIConfig.COMMAND_AUTO_GATHER = 12;		-- 挂机采集
AIConfig.COMMAND_SCENE_TELEPORT = 13;	-- 同一地图寻路
AIConfig.COMMAND_ACTION_MOVE = 14;		-- 移动命令,增加支持跳跃传送
AIConfig.COMMAND_MOVE_TO_MONSTER = 15;	-- 点击八卦地宫统计面板，移动到地点后挂机的行为。策划要求屏幕显示自动寻路动画，所以增加配置。2015/1/7 gzn