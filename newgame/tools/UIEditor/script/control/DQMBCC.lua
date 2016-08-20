-- DQMBCC.lua
-- create by hcl on 2013-3-27
-- 短期目标系统
-- 145系统

DQMBCC = {}

-- 领取奖励
function DQMBCC:req_get_award( )
	local pack = NetManager:get_socket():alloc(145,2);
	NetManager:get_socket():SendToSrv(pack);
end

-- 服务器通知短期目标奖励状态 s-c 145,1
function DQMBCC:do_change_DQMB_state( pack )

	local state  	 = pack:readChar();		--状态
	if ( state == 0  ) then
		-- XSZYManager:destroy_dqmb_award()
	
	else
		local get_lv 	 = pack:readInt();		--可领取等级
		local award_num  = pack:readInt();		--奖励物品列表长度
		local award_table = {};
		for i=1,award_num do
			award_table[ (i-1)*2 + 1 ] = pack:readInt(); --物品ID
			award_table[ (i-1)*2 + 2 ] = pack:readInt(); --物品数量
		end
		-- 通知主界面显示
		-- XSZYManager:show_dqmb_award_item( award_table[1] , award_table[2] , get_lv,state );
	end

	--print("-------------服务器通知短期目标奖励状态--------------state = ",state);
end