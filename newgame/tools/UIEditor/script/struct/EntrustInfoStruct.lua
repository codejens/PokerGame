-- EntrustInfoStruct.lua
-- create by lyl on 2013-5-17
-- 副本委托数据结构

super_class.EntrustInfoStruct()

function EntrustInfoStruct:__init( pack )
	self.fuben_id      = pack:readInt()         -- 副本id
	self.max_tier      = pack:readInt()         -- 最后一次委托层数( 协议查看器注释有问题，应该是：最大委托层数 )
	self.entrust_times = pack:readInt()         -- 委托次数
	self.state         = pack:readByte()        -- 状态  0：未开始   1：开始了   2：完成未领取奖励
	self.repeat_online = pack:readByte()        -- 是否下线后再上线  0 一直在线  1下线后再上线
	self.remain_time   = pack:readUInt()        -- 剩余时间
	self.entrust_way   = pack:readByte()        -- 仙币委托还是元宝委托  0：仙币委托  1：元宝委托
	print( "EntrustInfoStruct", self.fuben_id, self.max_tier, self.entrust_times, self.state, self.repeat_online, self.remain_time, self.entrust_way )
end