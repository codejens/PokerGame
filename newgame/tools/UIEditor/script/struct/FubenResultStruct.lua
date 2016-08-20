-- FuBenResultStruct.lua
-- created by Little White on 2014-8-27
-- 通用副本结算数据结构

super_class.FuBenResultStruct()

function FuBenResultStruct:__init( pack )
	if (pack) then
		self.grade = pack:readInt() 			-- 评级
		print("self.grade",self.grade)
		self.fubenId = pack:readInt() 			-- 副本Id
		print("self.fubenId",self.fubenId)
		self.elapsed_time = pack:readInt()  	-- 所用时间
		print("self.elapsed_time",self.elapsed_time)
		self.extra_param = pack:readInt()		-- 附加参数
		print("self.extra_param",self.extra_param)
		self.award_count = pack:readInt()		-- 奖励数量
		print("self.award_count",self.award_count)

		self.award_list = {}
		for i=1,self.award_count do
			self.award_list[i] = {}
			self.award_list[i].itemId = pack:readInt()		   	-- 道具id
			self.award_list[i].count = pack:readInt()			-- 道具数量
			self.award_list[i].binding = pack:readChar()		-- 绑定标志 0：不绑定，1：绑定
			print("i,self.award_list[i].itemId,self.award_list[i].count,self.award_list[i].binding",i,self.award_list[i].itemId,self.award_list[i].count,self.award_list[i].binding)
		end
	end 
end
