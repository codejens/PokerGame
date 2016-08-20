-- QingrenjieCC.lua
-- created by charles on 2014-1-14
-- 情人节系统 151

QingrenjieCC = {}

-- s->c 151,1 发送情人节活动图标状态
function QingrenjieCC:do_qingrenjie_icon_state( pack )
	local activity_type = pack:readChar();
	local state = pack:readInt();
end
-- c->s 151,2 获取送花奖励信息
function QingrenjieCC:req_award_state()
	print("QingrenjieCC:req_award_state()")
	local pack = NetManager:get_socket():alloc(151, 2)
	NetManager:get_socket():SendToSrv(pack)
end 

-- s->c 151,2 发送送花奖励信息
function QingrenjieCC:do_qingrenjie_icon_state( pack )
	local time = pack:readInt();			--活动剩余时间
	local state_1 = pack:readByte();		--9朵玫瑰的领取状态
	local state_2 = pack:readByte();		--99朵玫瑰的领取状态
	local state_3 = pack:readByte();		--999朵玫瑰的领取状态
	BigActivityModel:set_activity_data( ServerActivityConfig.ACT_TYPE_YUANXIAOHUODONG, {state_1,state_2,state_3} )
end

-- c->s 151,3 领取送花奖励(成功后会重新发送2)
function QingrenjieCC:req_flower_award( index )
	local pack = NetManager:get_socket():alloc(151, 3)
	pack:writeInt(index);
	NetManager:get_socket():SendToSrv(pack)	
end

function QingrenjieCC:init_qingrenjie_cc()
	local func = {};
	func[1] = QingrenjieCC.do_qingrenjie_icon_state;
	func[2] = QingrenjieCC.do_qingrenjie_icon_state;
	return func;
end