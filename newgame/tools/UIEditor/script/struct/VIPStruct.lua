-- VIPStruct.lua
-- created by fjh on 2012-12-29
-- vip的信息结构
super_class.VIPStruct()

function VIPStruct:__init( pack )
	
	self.level = pack:readInt();  				--vip等级
	self.all_yuanbao_value = pack:readInt();	--已经充值了的元宝
	self.current_yuanbao_value = pack:readInt();	--本次充值的元宝

end