-- ActionConfig.lua
-- created by aXing on 2013-1-17
-- 定义主角行为动作的一些宏

-- super_class.ActionConfig()
ActionConfig = {}

-- 优先级别定义
ActionConfig.PRIORITY_NONE 	= 0			-- 没有优先级
ActionConfig.PRIORITY_ONE 	= 1 		-- 优先级别一
ActionConfig.PRIORITY_TWO	= 2 		-- 优先级别二
ActionConfig.PRIORITY_THREE	= 3 		-- 优先级别三

ActionConfig.ACTION_READY	= 0 		-- 动作准备
ActionConfig.ACTION_DOING	= 1 		-- 动作进行
ActionConfig.ACTION_FAIL	= 2 		-- 动作失败
ActionConfig.ACTION_END		= 3 		-- 动作完成
