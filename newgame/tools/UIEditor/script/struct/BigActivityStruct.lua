-- BigActivityStruct.lua
-- create by lyl on 2013-10-26
-- 任务的数据结构

super_class.BigActivityStruct{}

-- activity_child_id  说明
-- 1.登陆活动
-- 2.充值活动,多礼包
-- 3.消费活动,多礼包
-- 4.每日充值,单礼包
-- 5.每日消费,单礼包
-- 7.充值活动,重复单礼包
-- 8.消费活动,重复单礼包
-- 9.每日充值,多礼包
-- 10.每日消费,多礼包



-- 子活动  对应的第 二 个参数说明
-- 1.登陆活动    可领取的奖励(按位)
-- 2.充值活动,多礼包     可领取的奖励(按位)
-- 3.消费活动,多礼包     可领取的奖励(按位)
-- 4.每日充值,单礼包     可领取的数量
-- 5.每日消费,单礼包     可领取的数量
-- 7.充值活动,单礼包     可领取的数量
-- 8.消费活动,单礼包     可领取的数量
-- 9.每日充值,多礼包     礼包种类数量
-- 10.每日消费,多礼包    礼包种类数量
local not_array_activity_id = { [1] = true, [2] = true, [3] = true, [4] = true, [5] = true, [6] = true, [7]=true ,[8]=true}     -- 第二个参数 不表示数量的 活动 id

-- 第 三 个参数说明：  如果第二个参数是数量， 第三个参数就是array
-- 1.登陆活动          int         已领取的奖励(按位),1表示已领取
-- 2.充值活动,多礼包   int         已领取的奖励(按位),1表示已领取
-- 3.消费活动,多礼包   int         已领取的奖励(按位),1表示已领取
-- 4.每日充值,单礼包   int         充值数量
-- 5.每日消费,单礼包   int         消费数量
-- 7.充值活动,单礼包   int         充值数量
-- 8.消费活动,单礼包   int         消费数量
-- 9.每日充值,多礼包   多个int     礼包数量列表
-- 10.每日消费,多礼包  多个int     礼包数量列表



function BigActivityStruct:__init( pack )
	self.activity_child_id = pack:readInt()                   -- 活动子id
    self.can_get_record = pack:readInt()                      -- 可领取记录  如果第三个数据时数组，这个就表示个数
    print("self.can_get_record,self.activity_child_id",self.can_get_record,self.activity_child_id)
    if not_array_activity_id[ self.activity_child_id ] then   -- 如果第三个数据不是数组
        self.had_get_record = pack:readInt()                  -- 已领取记录
        print("self.had_get_record",self.had_get_record)
    else
        local int_array = {}
        for i = 1, self.can_get_record do 
            local int_data = pack:readInt()
            table.insert( int_array, int_data )
        end
        self.had_get_record = int_array                       -- 根据具体协议表示
    end
	
	self.arg      = pack:readInt()                       -- 附加参数
	print("self.can_get_record = %s,self.had_get_record = %s,self.arg = %s",self.can_get_record,self.had_get_record, self.arg)

end
