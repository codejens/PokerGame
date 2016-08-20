--- OpenCardCC.lua
-- created by liuguowang on 2014-4-23


-- super_class.OpenCardCC()
OpenCardCC = {}


--周年翻牌_请求卡牌信息
--c->s,139,150
function OpenCardCC:req_card_info( )
	print("c->s,139,150 OpenCardCC:req_card_info")
	local pack = NetManager:get_socket():alloc(139, 150);
	NetManager:get_socket():SendToSrv(pack);
end

--周年翻牌_下发所有卡牌信息
--s->c ,139,150
function OpenCardCC:do_card_info( pack )
	print("s->c ,139,150")
	local lave_times = pack:readShort();--剩余翻牌次数(今日剩余)
	local free_times = pack:readShort();--免费翻牌次数
	local num_fixed  = pack:readShort(); --已修复次数
	local score_layer = pack:readShort(); -- 积分段
	local score      = pack:readInt();   --累积积分数
	local state_get  = pack:readInt();	-- 礼包领取状态
	local num_gift   = pack:readInt();	-- 已领取的积分礼包数
	-- local get_award_num = pack:readShort();--已领取奖品数
	-- local card_num = pack:readChar();--卡牌数
	-- print("lave_times=",lave_times)
	-- print("free_times=",free_times)
	-- print("num_fixed=", num_fixed)
	-- print("scroe_layer=",score_layer)
	-- print("score=",score)
	-- print("state_get=",state_get)
	-- print("num_gift=",num_gift)
	-- print("get_award_num=",get_award_num)
	-- print("card_num=",card_num)
	-- local item_data = {}
	-- for i=1,card_num do
	-- 	item_data[i] = {}
	-- 	item_data[i].pos = i
	-- 	item_data[i].id = pack:readInt()--物品id
	-- 	print("i=",i)
	-- 	print("item_data[i].id=",item_data[i].id)
	-- 	if item_data[i].id ~= -1 then
	-- 		item_data[i].num = pack:readInt()--物品num
	-- 		print("item_data[i].num=",item_data[i].num)
	-- 	else
	-- 		item_data[i].num = 0
	-- 	end
	-- end
	-- OpenCardModel:set_card_info(item_data)
	OpenCardModel:set_other_data(lave_times, free_times, num_fixed, score_layer, score, state_get, num_gift)

	--更新界面
	local win = UIManager:find_visible_window("open_card_win");
	if win then
		win:update("time")
		win:update("card_init")
		win:update("control")
	end
end


--------------------------------------------------------------



--周年翻牌_翻牌
--c->s,139,151
--1：代表一键修复, 0：一次只修复一块
function OpenCardCC:req_open_card( is_all)
	print("c->s,(139, 151) OpenCardCC:req_open_card")
	local pack = NetManager:get_socket():alloc(139, 151);
	print("is_all =",is_all)
	pack:writeChar(is_all)--翻牌位置	
	NetManager:get_socket():SendToSrv(pack);
end

--周年翻牌_翻牌结果
--s->c ,139,151
function OpenCardCC:do_open_card( pack )
	print("s->c ,(139,151) OpenCardCC:do_open_card")
	local lave_times = pack:readShort();--剩余翻牌次数
	local free_times = pack:readShort();--免费翻牌次数
	local num_fixed = pack:readShort();--免费翻牌次数
	local score     = pack:readInt();  --累积积分
	local state_get  = pack:readInt();	-- 礼包领取状态
	local num_gift   = pack:readInt();	-- 已领取的积分礼包数
	print("state_get=", lave_times)
	print("free_times=", free_times)
	print("num_fixed=", num_fixed)
	print("score=", score)
	print("state_get=", state_get)
	print("num_gift=", num_gift)
	-- local item = {}
	-- for i=1,card_num do
	-- 	item[i] = {}
	-- 	item[i].pos = pack:readChar()--位置
	-- 	item[i].id = pack:readInt()--物品id
	-- 	print("i=",i)
	-- 	print("item[i].id=",item[i].id)
	-- 	if item[i].id ~= -1 then
	-- 		item[i].num = pack:readInt()--物品num
	-- 		print("item[i].num=",item[i].num)
	-- 	else
	-- 		item[i].num = 0--物品num
	-- 	end
	-- 	OpenCardModel:set_one_card_info(item[i].pos,item[i].id,item[i].num)
	-- end

	-- OpenCardModel:set_other_data(lave_times,free_times,score)
	OpenCardModel:set_other_data(lave_times, free_times, num_fixed, nil, score, state_get, num_gift)

	--更新界面
	local win = UIManager:find_visible_window("open_card_win");
	if win then
		win:update("card")
		win:update("control")
	end
end


--------------------------------------------------------------


--周年翻牌_领取积分礼包
--c->s,139,152
function OpenCardCC:req_get_score_libao()
	print("c->s,(139,152) OpenCardCC:req_get_score_libao")
	local pack = NetManager:get_socket():alloc(139, 152);
	NetManager:get_socket():SendToSrv(pack);
end

--周年翻牌_领取积分礼包返回
--s->c ,139,130
-- function OpenCardCC:do_get_score_libao( pack )
-- 	print("s->c,139,130")
-- 	local get_award_num = pack:readShort();--已领取积分礼包数
-- 	print("get_award_num=",get_award_num)
-- 	OpenCardModel:set_other_data(nil,nil,nil,get_award_num)
-- 		--更新界面
-- 	local win = UIManager:find_visible_window("open_card_win");
-- 	if win then
-- 		win:update("control")
-- 	end
-- end


--------------------------------------------------------------


--周年翻牌_换牌
--c->s,139,153
--0立即换, 1免费换
function OpenCardCC:req_get_score(tag) --s->c返回128
	print("c->s,139,153")
	local pack = NetManager:get_socket():alloc(139, 153);
	pack:writeChar(tag)--换牌标识 --0立即换牌1免费换牌
	NetManager:get_socket():SendToSrv(pack);
end