-- QianKunModel.lua
-- created by hwl on 2015-4-27
-- QianKunModel 动态数据

QianKunModel = {}

--对应充值额度,消费额度,活动积分
activity_info = {chongzhi = 0, xiaofei = 0, score = 0}

items_num_t = {}	-- 各物品剩余兑换数量
function QianKunModel:fini( ... )
	activity_info = {chongzhi = 0, xiaofei = 0, score = 0}

	items_num_t = {}	-- 各物品剩余兑换数量
end

-- 请求兑换物品
function QianKunModel:req_qiankun_award( item_id, num )
	OnlineAwardCC:req_qiankun_award(item_id, num)
end

-- 请求活动数据
function QianKunModel:req_exchange_info( )
	OnlineAwardCC:req_qiankun_info()
end

-- 请求物品兑换信息
function QianKunModel:req_qiankun_items( )
	OnlineAwardCC:req_qiankun_items()
end

function QianKunModel:set_act_info(chongzhi, xiaofei, score)
	activity_info.chongzhi = chongzhi or 0
	activity_info.xiaofei = xiaofei or 0
	activity_info.score = score or 0
	local win = UIManager:find_visible_window("qian_kun_win")
	if win then
		win:update("act_info", activity_info)
	end
end

function QianKunModel:get_act_info( ... )
	return activity_info
end

function QianKunModel:set_items( tab )
	items_num_t = tab
	local win = UIManager:find_visible_window("qian_kun_win")
	if win then
		win:update("items", tab)
	end
end

function QianKunModel:get_items(  )
	return items_num_t
end