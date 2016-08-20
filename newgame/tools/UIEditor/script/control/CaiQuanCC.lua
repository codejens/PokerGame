-- CaiQuanCC.lua
-- created by fjh on 2013-7-27
-- 猜拳系统

CaiQuanCC = {};


-- 拉去自己的猜拳信息
-- c->s 139,94
function CaiQuanCC:req_self_info(  )
	local pack = NetManager:get_socket():alloc( 139, 94 );
	NetManager:get_socket():SendToSrv(pack)
end
-- s->c 139,94
function CaiQuanCC:do_self_info( pack )
	
	local name = pack:readString();
	local job = pack:readInt();
	local camp = pack:readInt();		--玩家阵营
	local sex = pack:readInt();
	local money = pack:readInt()		--银两
	local win_count = pack:readInt() 	--胜利数
	local all_count = pack:readInt()	--总猜拳数
	local mutable_win = pack:readInt()	--连胜数

	local data = {name = name, camp = camp, sex = sex, money = money, win_count = win_count, all_count = all_count, mutable_win = mutable_win};

	CaiQuanModel:do_self_info( data );

end

-- 服务器正在匹配中
-- s->c 139,95
function CaiQuanCC:do_system_matching( pack )
	
	CaiQuanModel:do_system_match_ing(  )
end

-- 取消匹配
-- c->s 139,96
function CaiQuanCC:req_cancel_match(  )
	local pack = NetManager:get_socket():alloc( 139, 96 );
	NetManager:get_socket():SendToSrv(pack)
end

-- 匹配后对手的信息
-- s->c 139,97
function CaiQuanCC:do_get_match_info( pack )

	local name = pack:readString();
	local job = pack:readInt();
	local camp = pack:readInt();		--玩家阵营
	local sex = pack:readInt();
	local money = pack:readInt()		--银两
	local win_count = pack:readInt() 	--胜利数
	local all_count = pack:readInt()	--总猜拳数
	local mutable_win = pack:readInt()	--连胜数

	local data = {name = name, camp = camp, sex = sex, money = money, win_count = win_count, all_count = all_count, mutable_win = mutable_win,job=job};

	CaiQuanModel:do_get_match_info( data );

end

-- 开始猜拳
-- c->s 139,98
function CaiQuanCC:req_take_caiquan( index )
	local pack = NetManager:get_socket():alloc( 139, 98 );
	pack:writeInt(index);
	NetManager:get_socket():SendToSrv(pack)
end

-- 猜拳结果
-- s->c 139,98
function CaiQuanCC:do_take_caiquan( pack )
	local self_selected = pack:readInt();

	local matcher_selected = pack:readInt();
	-- 1 胜利 ，0 平局，-1 失败
	local result = pack:readInt();

	local data = { self_sele = self_selected, matcher_sele = matcher_selected, result = result };

	print("猜拳 --------------- 猜拳结果", result);
	CaiQuanModel:do_take_caiquan( data );
end

