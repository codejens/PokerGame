-- HuanLeDouCC.lua
-- created by hcl on 2013-9-16
-- 欢乐斗系统 144

HuanLeDouCC = {}

-- 请求获取欢乐斗消息数据
function HuanLeDouCC:req_msg_info(  )
	ZXLog("HuanLeDouCC:req_msg_info(  )")
	local pack = NetManager:get_socket():alloc(144, 1)
	NetManager:get_socket():SendToSrv(pack)
end

-- 服务器下发欢乐斗消息数据
function HuanLeDouCC:do_msg_info( pack )
	ZXLog("HuanLeDouCC:do_msg_info( pack )")
	local msg_num = pack:readInt();
	local msg_table = {};
	for i=1,msg_num do
		msg_table[i] = HLDMsgStruct(pack);
	end
	local win = UIManager:find_visible_window("hld_hudongjilu")
	if ( win ) then
		win:update_scroll(msg_table);
	end
end

-- 请求欢乐斗数据
function HuanLeDouCC:req_hld_info()
	print("HuanLeDouCC:req_hld_info( pack )")
	local pack = NetManager:get_socket():alloc(144, 2)
	NetManager:get_socket():SendToSrv(pack)	
end

-- 服务器下发欢乐斗数据
function HuanLeDouCC:do_hld_info( pack )
	local hld_info_table = {};
	hld_info_table.is_sys_open 		= pack:readInt();		--系统开关状态
	hld_info_table.min_sys_open_lv 	= pack:readInt();		--系统开启等级下限
	hld_info_table.state	 		= pack:readInt();		--身份状态
	hld_info_table.catch_num 		= pack:readInt();		--今天剩下抓捕或掠夺次数
	hld_info_table.catch_max_num 	= pack:readInt();		--抓捕/掠夺次数上限
	hld_info_table.hudong_num 		= pack:readInt();		--今日剩下互动次数
	hld_info_table.hudong_max_num 	= pack:readInt();		--互动次数上限
	hld_info_table.help_num		 	= pack:readInt();		--今天剩下反抗/求救次数
	hld_info_table.help_max_num 	= pack:readInt();		--反抗/求救次数上限
	hld_info_table.get_exp		 	= pack:readInt();		--今日已获得经验
	hld_info_table.free_num		 	= pack:readInt();		--今日剩下解救次数
	hld_info_table.free_max_num 	= pack:readInt();		--解救次数上限
	hld_info_table.next_catch_need_money = pack:readInt();	--下一次增加抓捕次数需要的元宝数
	hld_info_table.send_req_num 	= pack:readInt();		--已发出的请求个数
	hld_info_table.req_tab = {};
	for i=1,hld_info_table.send_req_num do                 --已发出的求救列表
		-- TODO 一个整型列表
		hld_info_table.req_tab[i] = pack:readInt();
	end
	-- 主人信息 ,只有当本人为仙仆身份才有主人信息
	if ( hld_info_table.state == 4 ) then
		hld_info_table.master_info = HLDUserStruct(pack);
	end
	HuanLeDouModel:set_my_hld_info( hld_info_table );
	print("HuanLeDouCC:do_hld_info( pack )",hld_info_table.state)

	local win = UIManager:find_visible_window("hld_main_win")
	if ( win ) then
		win:update_my_info( hld_info_table );
	end
end

-- 取得手下败将的数据 3
function HuanLeDouCC:req_loser_list(  )
	local pack = NetManager:get_socket():alloc(144, 3)
	NetManager:get_socket():SendToSrv(pack)		
end

-- 服务器下发手下败将的数据 3
function HuanLeDouCC:do_loser_list(pack)
	local loser_table = {};
	local loser_num = pack:readInt();
	for i=1,loser_num do
		-- TODO loser_struct
		loser_table[i] = HLDUserStruct(pack);
	end
	local win = UIManager:find_visible_window("hld_zhuabuxianpu");
	if ( win ) then
		win:update_scroll( loser_table );
	end
end

-- 请求夺仆之敌列表 144,4
function HuanLeDouCC:req_duo_pu_list()
	local pack = NetManager:get_socket():alloc(144, 4)
	NetManager:get_socket():SendToSrv(pack)	
end

function HuanLeDouCC:do_duo_pu_list(pack)
	local duo_pu_table = {};
	local duo_pu_num = pack:readInt();
	for i=1,duo_pu_num do
		duo_pu_table[i] = HLDUserStruct(pack);
	end
	local win = UIManager:find_visible_window("hld_zhuabuxianpu");
	if ( win ) then
		win:update_scroll( duo_pu_table );
	end	
end

-- 请求苦工列表 144,5
function HuanLeDouCC:req_kugong_list()
	local pack = NetManager:get_socket():alloc(144,5)
	NetManager:get_socket():SendToSrv(pack)		
end

function HuanLeDouCC:do_kugong_list(pack)
	local kugong_table = {};
	local kugong_num = pack:readInt();
	for i=1,kugong_num do
		kugong_table[i] = HLDUserStruct(pack);
	end
	local win = UIManager:find_visible_window("hld_zhupuhudong");
	if ( win ) then
		win:update_scroll( kugong_table );
	end
	win = UIManager:find_visible_window("hld_yazhaxianpu");
	if ( win ) then
		win:update_scroll( kugong_table );
	end
end

-- 请求我可以解救的苦工列表 144,6
function HuanLeDouCC:req_can_save_list()
	local pack = NetManager:get_socket():alloc(144,6)
	NetManager:get_socket():SendToSrv(pack)		
end

function HuanLeDouCC:do_can_save_list(pack)
	local can_save_table = {};
	local can_save_num = pack:readInt();
	for i=1,can_save_num do
		can_save_table[i] = HLDUserStruct(pack);
	end
	local win = UIManager:find_visible_window("hld_jiejiu");
	if ( win ) then
		win:update_scroll( can_save_table );
	end	
end

-- 抓捕/掠夺	is_qxld = 是否强行掠夺 144,7
function HuanLeDouCC:req_catch( target_id, is_qxld )
	local pack = NetManager:get_socket():alloc(144,7)
	pack:writeInt(target_id);
	pack:writeInt(is_qxld);
	NetManager:get_socket():SendToSrv(pack)	
end

-- 求救 144,8
function HuanLeDouCC:req_help( target_id )
	local pack = NetManager:get_socket():alloc(144,8)
	pack:writeInt(target_id);
	NetManager:get_socket():SendToSrv(pack)		
end

-- 赎身 144,9
function HuanLeDouCC:req_shushen(  )
	local pack = NetManager:get_socket():alloc(144,9)
	NetManager:get_socket():SendToSrv(pack)		
end

-- 反抗 144,10
function HuanLeDouCC:req_fankang()
	local pack = NetManager:get_socket():alloc(144,10);
	NetManager:get_socket():SendToSrv(pack);
end

-- 互动 144,11
function HuanLeDouCC:req_hudong( target_id,msg_type )
	local pack = NetManager:get_socket():alloc(144,11);
	pack:writeInt(target_id);
	pack:writeInt(msg_type);
	NetManager:get_socket():SendToSrv(pack);	
end

-- 提取经验 144,12
function HuanLeDouCC:req_get_exp( target_id )
	local pack = NetManager:get_socket():alloc(144,12);
	pack:writeInt(target_id);
	NetManager:get_socket():SendToSrv(pack);	
end

-- 压榨 144,13
function HuanLeDouCC:req_yazha( target_id )
	local pack = NetManager:get_socket():alloc(144,13);
	pack:writeInt(target_id);
	NetManager:get_socket():SendToSrv(pack);	
end

-- 抽干 144,14
function HuanLeDouCC:req_chougan( target_id )
	local pack = NetManager:get_socket():alloc(144,14);
	pack:writeInt(target_id);
	NetManager:get_socket():SendToSrv(pack);	
end

-- 解救苦工 144,15
function HuanLeDouCC:req_save_kugong( target_id )
	local pack = NetManager:get_socket():alloc(144,15);
	pack:writeInt(target_id);
	NetManager:get_socket():SendToSrv(pack);	
end

-- 释放苦工 144,16
function HuanLeDouCC:req_free_kugong( target_id )
	local pack = NetManager:get_socket():alloc(144,16);
	pack:writeInt(target_id);
	NetManager:get_socket():SendToSrv(pack);	
end

-- 获取可解救我的同帮派玩家列表 144,17
function HuanLeDouCC:req_get_my_guild_list(  )
	local pack = NetManager:get_socket():alloc(144,17);
	NetManager:get_socket():SendToSrv(pack);	
end

-- 发送可解救我的同帮派玩家列表 144,17
function HuanLeDouCC:do_get_my_guild_list( pack )
	local guild_table = {};
	local guild_num = pack:readInt();
	for i=1,guild_num do
		guild_table[i] = HLDUserStruct(pack);
	end
	local win = UIManager:find_visible_window("hld_qiujiu");
	if ( win ) then
		win:update_scroll( guild_table );
	end	
end

-- 增加抓捕次数 144,18
function HuanLeDouCC:req_add_catch_num()
	local pack = NetManager:get_socket():alloc(144,18);
	NetManager:get_socket():SendToSrv(pack);		
end

-- 通知前端此玩家已经有主人 144,19
function HuanLeDouCC:do_this_player_have_master( pack )
	local msg_id = pack:readInt();
	-- TODO 对方数据
	local other_info = HLDUserStruct(pack);
	-- TODO 对方地主数据
	local master_info = HLDUserStruct(pack);
	local function cb()
		HuanLeDouCC:req_catch( other_info.id, 1 )
	end
	local str = string.format("#cfff000%s#cffffff已经是#cfff000%s的仙仆，要得到#cfff000%s#cffffff，要先击败#cfff000%s",
						other_info.name,master_info.name,other_info.name,master_info.name);
	NormalDialog:show(str,cb);
end

-- 新消息通知 144,20
function HuanLeDouCC:do_new_msg( pack )
	local msg_id = pack:readInt();
	print("HuanLeDouCC:do_new_msg( pack )",msg_id);
	HuanLeDouModel:parse_msg_id( msg_id )
end