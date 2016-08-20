-- UserAchieve.lua
-- created by charles on 2012-12-31
-- 玩家成就数据结构

super_class.UserAchieve()

function UserAchieve:__init()
	self.hasDone = 0;
	self.hasGetAwards = 0;
	self.condProgress = {};
end