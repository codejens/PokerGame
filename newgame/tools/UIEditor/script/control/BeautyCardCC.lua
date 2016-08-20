-- BeautyCardCC.lua
-- created by chj on 2015-0--23
-- 美人抽卡


BeautyCardCC = {}

-- 请求抽卡信息 ---------------
function BeautyCardCC:req_beautycard_info()
	print( "c->s(166, 1) BeautyCardCC:req_beautycard_info")
	local pack = NetManager:get_socket():alloc(166, 1)
	NetManager:get_socket():SendToSrv(pack)
end

--服务器下发 抽卡信息
function BeautyCardCC:do_beautycard_info( pack )
	print( "s->c(166 1) BeautyCardCC:do_beautycard_info")
	local num_card = pack:readInt()
	print("num_card:", num_card)
	local time_t = {}
	for i=1, num_card do
		local c_type = pack:readInt() -- not use
		local c_num = pack:readInt()  -- not use
		time_t[i] = pack:readInt()
	end
	BeautyCardModel:set_main_info( num_card, time_t)
end


-- 请求抽卡信息
function BeautyCardCC:req_draw_card( index, num )
	print( "c->s(166, 2) BeautyCardCC:req_draw_card", index, num)
	local pack = NetManager:get_socket():alloc(166, 2)
	pack:writeInt(index)
	pack:writeInt(num)
	NetManager:get_socket():SendToSrv(pack)
end

function BeautyCardCC:do_draw_card_result( pack )
	print( "s->c(166, 2) BeautyCardCC:do_draw_card_result")
	local c_type = pack:readInt()
	local c_cost = pack:readInt()
	local num_item = pack:readInt()
	print("c_type:", c_type, c_cost, num_item)
	local items = {}
	for i=1, num_item do
		items[i] = {}
		items[i].item_id = pack:readInt()
		items[i].item_num = pack:readInt()
	end
	BeautyCardModel:set_result_info( c_type, c_cost, items) 
end

-- 获取黄金宝箱
function BeautyCardCC:do_gold_free_time( pack)
	print( "s->c(166, 3) BeautyCardCC:do_gold_free_time")
	local c_type = pack:readInt()
	local gf_time = pack:readInt()
	print("------gf_time", gf_time)
	BeautyCardModel:set_gf_time( gf_time)
end