-- WorldBossStruct.lua
-- created by lyl on 2013-2-23
-- 世界boss数据结构


super_class.WorldBossStruct()

function WorldBossStruct:__init( pack )
	if pack ~= nil then
		self.id	           = pack:readInt()		     -- boss  id
		self.status	       = pack:readInt()		     -- 0未刷新出来或者已被打死， 1，已创建
		self.remainTime    = pack:readInt()		     -- 精英boss的剩余出现时间,世界boss直接读配置表
	end
end