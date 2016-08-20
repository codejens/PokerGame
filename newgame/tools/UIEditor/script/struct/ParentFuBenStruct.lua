-- ParentFuBenStruct.lua
-- created by Little White on 2014-7-7
-- 大副本数据结构

super_class.ParentFuBenStruct()

function ParentFuBenStruct:__init( pack )

	self.count	= pack:readChar()		-- 子副本数量
	self.fubenId_list={}				-- 子副本id列表

	for i=1,self.count do
		self.fubenId_list[i]= pack:readInt()   -- 子副本id
		print("i,self.fubenId_list[i]:",i,self.fubenId_list[i])
	end

	self.progress = pack:readInt()		-- 副本当前进度
	print("self.progress",self.progress)

	self.available_progress = pack:readInt()      -- 副本最高进度
	print("self.available_progress",self.available_progress)

	self.fbListId = pack:readInt()		-- 副本List id
	print("self.fbListId",self.fbListId)

	self.fuben_type = pack:readChar()    -- 副本类型

	print("self.fuben_type",self.fuben_type)  -- 1:计子副本次数,2:计父副本次数,

	self.sub_count = pack:readChar()     -- 子副本数量

	print("self.sub_count",self.sub_count)

	self.sub_list = {}						-- 子副本
	for i=1,self.sub_count do
		self.sub_list[i] = {}
		self.sub_list[i].remainCount = pack:readShort()     -- 剩余次数
		self.sub_list[i].totalCount = pack:readShort()	 -- 总次数
		print("i,self.sub_list[i].remainCount,self.sub_list[i].totalCount:",i,self.sub_list[i].remainCount,self.sub_list[i].totalCount)
	end

	self.status_flags = pack:readChar()  --按位域，第一位表示副本操作，1表示不可操作,第二位表示增加副本次数，1表示不能增加副本次数         

	self.fuben_flag = Utils:get_bit_by_position(self.status_flags,1)
	self.add_fuben_flag = Utils:get_bit_by_position(self.status_flags,2)

	print("self.fuben_flag,self.add_fuben_flag",self.fuben_flag,self.add_fuben_flag)

	self.sweep_flag = pack:readChar()  --0：不在扫荡,1：正在扫荡中,2：可领取扫荡奖励
	print("self.sweep_flag",self.sweep_flag)

	self.sweep_remain_time = pack:readInt()   -- 扫荡剩余时间

	print("self.sweep_remain_time",self.sweep_remain_time)

	self.award_count = pack:readChar()        -- 奖励条数
	print("self.award_count",self.award_count)
	self.award_list = {}
	for i=1,self.award_count do
		self.award_list[i] = {}
		self.award_list[i].award_type = pack:readChar()		-- char :类型  0：表示银两 1：表示忍币 2：表示礼券 3：表示元宝 4: 表示历练值 5: 表示经验
		self.award_list[i].award_value = pack:readInt()		-- int :奖励数值
		print("i,self.award_list[i].award_type,self.award_list[i].award_value",i,self.award_list[i].award_type,self.award_list[i].award_value)
	end

end