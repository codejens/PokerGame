-- ZYTChallengeResultsStruct.lua
-- create by tjh on 2014-5-23
-- 镇妖塔挑战成功结果

super_class.ZYTChallengeResultsStruct()


function ZYTChallengeResultsStruct:__init( pack )

	self.is_clearance = pack:readChar()    --是否通关 1：第一次通关；0之前已通关
	self.master_time  = pack:readInt()  --层主用时
	self.my_time      = pack:readInt()  --我的用时
	self.curr_floor   = pack:readInt()  --当前层数
	self.master_relation = pack:readChar()    --层主关系 0：不是层主；1：成为层主；2：已是层主
	self.floor_index      = pack:readInt()  --层主层数
	self.award_count  = pack:readInt()  --奖励个数
	self.award_table = {}
	for i=1,self.award_count  do
		self.award_table[i] = {}
		self.award_table[i].item_id = pack:readInt()  --物品ID
		self.award_table[i].item_count = pack:readInt()  --物品数量
		--print("-- 镇妖塔挑战成功结果",self.award_table[i].item_id,self.award_table[i].item_count)
	end
end