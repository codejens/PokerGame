-- LoginAwardStruct.lua
-- created by lyl on 2013-3-5
-- 连续登录奖励数据结构

super_class.LoginAwardStruct()

function LoginAwardStruct:__init( pack )
	if pack ~= nil then
		self.award_type	   = pack:readInt()		     -- 奖励类型：0为物品，1为仙币，2为银两，3为绑定元宝，4为元宝
		self.item_id	   = pack:readInt()		     -- 物品id：奖励类型是物品时有用
		self.count   	   = pack:readInt()		     -- 数量：物品或金钱数量
	end
end
