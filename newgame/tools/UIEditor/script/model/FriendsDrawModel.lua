-- ActivityModel.lua
-- created by chj 2015-1-31
-- 活动

-- super_class.ActivityModel()
FriendsDrawModel = {}

FriendsDrawModel.ACTIVITY_ID = 5

-- 数据对象
FriendsDrawModel.dataModel = {
	num_draw = 0,
	num_draw_free = 0,
	num_drawn = 0,
	num_send = 0, 
	num_gift = 0,
	num_time = 0,
	result_item_index = 0,
	result_item_id = 0;
}

--好友赠送次数记录
FriendsDrawModel.order_gift = {}

-- 倒计时，计算活动时间
FriendsDrawModel.timer_count = nil

-- added by aXing on 2013-5-25
function FriendsDrawModel:fini( ... )

end

-- ===============================================
-- 请求服务器(request)
-- ===============================================
-- 进入面板时请求
function FriendsDrawModel:req_main_info( )
	OnlineAwardCC:req_main_info()
end

-- 请求抽奖
function FriendsDrawModel:req_friend_draw( )
	OnlineAwardCC:req_friend_draw( )
end

-- 赠送密友抽奖次数
function FriendsDrawModel:req_send_draw_chance( friend_name )
	OnlineAwardCC:req_send_draw_chance( friend_name )
end

-- 礼包领取请求
function FriendsDrawModel:req_get_gift( )
	OnlineAwardCC:req_get_gift( )
end

-- ===============================================
-- 更新获取下发数据(do)
-- ===============================================

-- 获取活动开始时间和结束时间
-- 如果活动结束，返回提示，如果没结束，放回倒计时
function FriendsDrawModel:get_activity_time()
	-- local time_start, time_end = SmallOperationModel:get_start_end_time(FriendsDrawModel.ACTIVITY_ID)
	-- if time_start == 0 and time_end == 0 then
	-- 	return 0
	-- end

	-- local time_remain = time_end - os.time()
	-- if time_remain < 0 then
	-- 	time_remain = 0
	-- end
	return self.dataModel.num_time
end

-- 更新面板信息
function FriendsDrawModel:update_main_info( num_draw, num_draw_free, num_drawn, num_send, num_gift, num_time )
	self.dataModel.num_draw = num_draw
	self.dataModel.num_draw_free = num_draw_free
	self.dataModel.num_send = num_send
	self.dataModel.num_gift = num_gift
	self.dataModel.num_time = num_time
	if num_drawn == 0 then
		self.dataModel.num_drawn = num_drawn
	else
		self.dataModel.num_drawn = num_drawn - 1
	end
	local win = UIManager:find_visible_window("friends_draw_win")
	if win then
		win:update("main")
	end

	-- 如果self.dataModel.num_time > 0 ,创建一个倒计时
	FriendsDrawModel:create_timer_gofotit()
end

-- 更新密友赠送记录
function FriendsDrawModel:update_gift_order( order_gift )
	self.order_gift = order_gift
	local win = UIManager:find_visible_window("friends_draw_win")
	if win then
		win:update("order")
	end
end

-- 从服务器获取抽到的道具
function FriendsDrawModel:update_draw_result( item_id )
	local item_index = FriendsDrawModel:get_index_by_id( item_id )
	self.dataModel.result_item_index = item_index or 0
	print("-:", self.dataModel.result_item_index)
	self.dataModel.result_item_id = item_id
	local win = UIManager:find_visible_window("friends_draw_win")
	if win then
		win:update("draw")
	end 
end

-- ==========================================
-- 获取数据
-- ==========================================
-- 获取model 数据模型
function FriendsDrawModel:get_data_model()
	return self.dataModel
end

-- 获取model 好友赠送(给我)记录
function FriendsDrawModel:get_order_gift( )
	return self.order_gift
end

-- 获取活动剩余时间
function FriendsDrawModel:get_activity_time_remain()
	return self.dataModel.num_time
end

-- ===============================================
-- 配置
-- ===============================================
-- 获取界面道具配置文件
function FriendsDrawModel:get_item_conf( )
	return FriendsDrawConfig:get_item_conf( )
end

-- 获取礼包配置表
function FriendsDrawModel:get_gift_conf( )
	return FriendsDrawConfig:get_gift_conf( )
end

-- 根据物品id 获取index
function FriendsDrawModel:get_index_by_id( item_id )
	local item_conf = FriendsDrawConfig:get_item_conf( )
	for i=1, #item_conf do
		print(item_conf[i].itemid, item_id)
		if item_conf[i].itemid == item_id then
			return i
		end
	end
	return nil
end

function FriendsDrawModel:get_id_by_index( index )
	local item_conf = FriendsDrawConfig:get_item_conf( )
	return item_conf[index].itemid
end

-- 获取一个离第二天的倒计时

function FriendsDrawModel:get_time_away_tomorrow( )
    local cur_timestamp = os.time()
    local one_hour_timestamp = 24*60*60
    local temp_time = cur_timestamp + one_hour_timestamp * 1
    local temp_date = os.date("*t", temp_time)
    local time_tomorrow = os.time({year=temp_date.year, month=temp_date.month, day=temp_date.day, hour=0})

    return time_tomorrow - cur_timestamp
end

-- 工具方法
function FriendsDrawModel:create_timer_gofotit()
	if self.dataModel.num_time > 0 then
		FriendsDrawModel:timer_destroy( )

		self.timer_count = timer()
		local function timer_count_func( )
			self.dataModel.num_time =  self.dataModel.num_time - 1
			if self.dataModel.num_time == 0 then
				FriendsDrawModel:timer_destroy( )
			end
		end
		self.timer_count:start( 1, timer_count_func )
	end
end

function FriendsDrawModel:timer_destroy( )
	if self.timer_count then
		self.timer_count:stop()
		self.timer_count = nil
	end
end