--lxm
--2014-7-8
--协议号160
JingKuangCC = {}

-- 160,1 c->s 开矿
function JingKuangCC:req_kai_kuang(  )
	print(" 160,1 c->s  开矿");
	local pack = NetManager:get_socket():alloc(160,1);
	NetManager:get_socket():SendToSrv(pack);
end

--160,1 s->c 下发矿场品质
function JingKuangCC:do_send_kuang_info(pack)
print("160,1 s->c 下发矿场品质")
	local pin_zhi = pack:readChar()
	local jiacheng = pack:readInt()
	--local jiacheng = pack:readInt()
	print("下发矿场品质",pin_zhi)
	JingkuangModel:set_pin_zhi( pin_zhi)

	local win = UIManager:find_visible_window("jing_kuang_win")
    if win then
    	win:update_jing_kuang( 1)  
    end
end

-- 160,2 c->s 刷新品质
function JingKuangCC:req_shuaxin_pinzhi(  )
	print("160,2 c->s 刷新品质");
	local pack = NetManager:get_socket():alloc(160,2);
	NetManager:get_socket():SendToSrv(pack);
end


-- 160,3 c->s 创建矿场
function JingKuangCC:req_open_kuang(  )
	print("160,3 c->s 创建矿场 创建矿场");
	local pack = NetManager:get_socket():alloc(160,3);
	NetManager:get_socket():SendToSrv(pack);
end


-- 160,4 c->s 发布招募信息
function JingKuangCC:req_send_zhaomu_info(  )
	print("发布招募信息");
	local pack = NetManager:get_socket():alloc(160,4);
	NetManager:get_socket():SendToSrv(pack);
end

-- 160,5 c->s 召唤矿工镜像
function JingKuangCC:req_zhaohuan_miner(  )
	print("召唤矿工镜像");
	local pack = NetManager:get_socket():alloc(160,5);
	NetManager:get_socket():SendToSrv(pack);
end


-- 160,6 c->s 应聘矿工
function JingKuangCC:req_yingping_miner( kuang_id )
	print("应聘矿工");
	local pack = NetManager:get_socket():alloc(160,6);
	pack:writeInt(kuang_id)
	NetManager:get_socket():SendToSrv(pack);
end


-- 160,7 c->s 收获矿场
function JingKuangCC:req_shouhuo_kuang(  )
	print("收获矿场");
	local pack = NetManager:get_socket():alloc(160,7);
	NetManager:get_socket():SendToSrv(pack);
end

-- 160,8 s->c 下发矿工信息
function JingKuangCC:do_send_miner_info( pack )
	print("下发矿工信息");
end

-- 160,9 s->c 下发矿场列表
function JingKuangCC:do_send_kuangchang_list( pack )
print("160,9 s->c  下发矿场列表")
	local time = pack:readInt()
	print("倒计时时间",time)
	local num  = pack:readInt()
	print("下发矿场列表",num);
	local all_kuangchang_info = {}
	for i=1,num do

		local id = pack:readInt()
		local name = pack:readString()
		print("矿主",name);
		local count = pack:readChar()
		local max = pack:readChar()
		local pin_zhi = pack:readChar()
		print("品质",pin_zhi);
		local shou_yi = pack:readInt()
		local kuangchang_info = {kuangchang_id=id,kuangzhu_name=name,miner_count=count,max=max,pin_zhi=pin_zhi,shou_yi=shou_yi,kuang_time = time}
		table.insert( all_kuangchang_info, kuangchang_info )
	end

	JingkuangModel:set_all_kuangchang_info( all_kuangchang_info)

	local win = UIManager:find_visible_window("jing_kuang_win")
    if win then
    	win:update_jing_kuang( 3)  
    	-- win:set_xuankuang_status(   )	
    end
end

-- 160,9 c->s 请求矿场列表
function JingKuangCC:req_kuangchang_list(  )
	print("160,9 c->s  请求矿场列表");
	local pack = NetManager:get_socket():alloc(160,9);
	NetManager:get_socket():SendToSrv(pack);
end

-- 160,10 s->c 下发收矿信息
function JingKuangCC:do_send_shoukuang_info( pack )
	print("下发收矿信息");
end

-- 160,11 s->c 下发开矿信息
function JingKuangCC:do_send_kaikuang_info( pack )
print(" 160,11 s->c 下发开矿信息")
	local caikuang_count = pack:readInt()
	local shouyi = pack:readInt()
	local pin_zhi = pack:readInt()
	local shenfen = pack:readInt()
	local kuangzhu_id = pack:readInt()
	local kuangzhu_name = pack:readString()
	local pay_zhaohuan = pack:readInt()
	local num  = pack:readInt()
	local kaikuang_info = {wakua_count=caikuang_count,wakuang_pinzhi=pin_zhi,shen_fen=shenfen,kuangzhu_id=kuangzhu_id,kuangzhu_name=kuangzhu_name,pay_zhaohuan=pay_zhaohuan,miner_count=num} 

	local all_miner_info = {}
	print("下发开矿信息 身份",shenfen)
	for i=1,num do
		local miner_name  = pack:readString()
		local miner_id  = pack:readInt()
		local touxiang_id  = pack:readChar()
		print("下发开矿信息 名称",miner_name)
		print("下发开矿信息 头像ID",touxiang_id)
		local xingbie  = pack:readChar()
		local miner_info = {miner_name=miner_name,miner_id=miner_id,touxiang_id=touxiang_id,xingbie=xingbie}
		table.insert( all_miner_info, miner_info )
	end

	JingkuangModel:set_all_miner_info( all_miner_info)
	
	--JingkuangModel:set_pin_zhi( pin_zhi)
	JingkuangModel:set_kaikuang_info( kaikuang_info)

	print("下发开矿信息 品质",pin_zhi);
	print("矿主名称",kuangzhu_name);
	--local kuangzhu_id = pack:readInt()
	local win = UIManager:find_visible_window("jing_kuang_win")
    if win then
    	win:update_jing_kuang( 2)  
    	win:set_xuankuang_status( )
    end
	
end

-- 160,11 c->s 请求开矿信息
function JingKuangCC:req_kaikuang_info(  )
	print("160,11 c->s 请求开矿信息")
	print("请求开矿信息");
	local pack = NetManager:get_socket():alloc(160,11);
	NetManager:get_socket():SendToSrv(pack);
end

-- 160,13 c->s 取消协助采矿
function JingKuangCC:req_cancel_caikuang(  )
	print("取消协助采矿");
	local pack = NetManager:get_socket():alloc(160,13);
	NetManager:get_socket():SendToSrv(pack);
end

-- 160,14 c->s 请求是否可以协助挖矿
function JingKuangCC:req_xiezhu_wakuang( kuang_id )
	print("请求是否可以协助挖矿");
	local pack = NetManager:get_socket():alloc(160,14);
	pack:writeInt(kuang_id)
	NetManager:get_socket():SendToSrv(pack);
end

-- 160,14 s->c 返回是否可以协助挖矿
function JingKuangCC:do_xiezhu_wakuang( pack )
	print("返回是否可以协助挖矿");
end

-- 160,15 s->c  返回创建矿场结果
function JingKuangCC:do_open_result(pack)
	local result = pack:readInt()
	print("返回创建矿场结果",result)
	if result == 1 then
		local win = UIManager:find_visible_window("jing_kuang_win")
    	if win then
    		win:change_page( 1 )
    	end
	end
end


