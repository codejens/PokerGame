-- LngGenCC.lua
-- create by hcl on 2012-12-10
-- 灵根系统 29

-- super_class.LingGenCC()

LingGenCC = {}

-- 1：获取灵根的信息
function LingGenCC:req_get_linggen_info()
	local pack = NetManager:get_socket():alloc(29, 1);
	NetManager:get_socket():SendToSrv(pack);
end

-- 1:获取灵根信息响应
function LingGenCC:do_get_linggen_info(pack)
	-- print("LingGenCC:do_get_linggen_info(pack)..........................................")
	local info = pack:readInt();
	local low = ZXLuaUtils:lowByte(info);
	local high = ZXLuaUtils:highByte(info);
	LinggenModel:set_current_linggen_info( high-1,low  )

	--刷新灵根积累属性值
	local linggenValue = {}
	linggenValue.innerAttack=pack:readInt()
	linggenValue.innerDefence=pack:readInt()
	linggenValue.hp=pack:readInt()
	linggenValue.criticalStrikes=pack:readInt()
	linggenValue.outDefence=pack:readInt()
	linggenValue.defCriticalStrikes=pack:readInt()
	linggenValue.hit=pack:readInt()
	linggenValue.dodge=pack:readInt()

	LinggenModel:set_accumulate_linggen_value(linggenValue)

	-- print("LingGenCC:do_get_linggen_info(pack)",linggenValue.innerAttack,linggenValue.innerDefence,linggenValue.hp,linggenValue.criticalStrikes)
	-- local win = UIManager:find_window("linggen_win");
	-- if ( win ) then
	-- 	win:cb_do_get_linggen_info(high - 1,low );
	-- end
end


-- 2:灵根升级 成功的话会回调do_get_linggen_info
function LingGenCC:req_level_up()
	local pack = NetManager:get_socket():alloc(29,2);
	NetManager:get_socket():SendToSrv(pack);
	--print("LingGenCC:req_level_up");
end


-- 3:查看其它玩家的灵根信息
function LingGenCC:req_get_other_linggen_info(other_id,other_name)

end

-- 3:查看其它玩家的灵根信息响应
function LingGenCC:do_get_other_linggen_info(pack)

end

-- c->s 29,4 查询当天领取状态
function LingGenCC:request_lingqu_info()
	local pack = NetManager:get_socket():alloc(29,4)
	NetManager:get_socket():SendToSrv(pack)
end

-- s->c 29,4 服务器下发当前累计灵气信息
function LingGenCC:do_get_lingqi_info(pack)
	-- 当前领取状态
	local state = pack:readChar()
	-- 当前所在领取时间段
	local stage = pack:readChar()
	-- 下次领取所在的时间段
	local nextStage = pack:readChar()

	LinggenModel:setLingQiInfo(state, stage, nextStage)
end

-- s->c 29,5 领取灵气
function LingGenCC:do_get_lingqi_reward(pack)
	-- 领取的类型、获得查克拉、龙地丹加成、VIP加成
	local reward_type	= pack:readChar()
	local total_chakela	= pack:readInt()
	local longdidan_add = pack:readInt()
	local vip_add		= pack:readInt()

	-- 播放成功领取特效
	local benefitWin = UIManager:find_visible_window("benefit_win")
	if benefitWin then
		-- 暂时没有灵气领取面板，以后做了再补上 note by gzn
		-- benefitWin:play_chakela_success_effect(407)
	end
end

-- c->s 29,5 请求领取灵气
function LingGenCC:request_lingqi_reward( curStage, award_type )
	local pack = NetManager:get_socket():alloc(29,5);
	-- 领取所在时间段
	pack:writeChar( curStage )
	-- 领取类型
	pack:writeChar( award_type )
	NetManager:get_socket():SendToSrv(pack)
end

-- s-->c 29,6 灵气领取通知
function LingGenCC:do_notify_lingqi_lingqu(pack)
	--
end

function LingGenCC:init_linggen_cc()
	local func = {};
	func[1] = LingGenCC.do_get_linggen_info;
	func[3] = LingGenCC.do_get_other_linggen_info;
	func[4] = LingGenCC.do_get_lingqi_info;
	func[5] = LingGenCC.do_get_lingqi_reward;
	func[6] = LingGenCC.do_notify_lingqi_lingqu;

	return func;
end

-- ============================================
-- 真气修炼分页
-- ============================================
-- 真气修炼数据
function LingGenCC:req_zhenqi_data( )
	print("c->s(161,1) LingGenCC:req_zhenqi_data")
	local pack = NetManager:get_socket():alloc(161,1);
	NetManager:get_socket():SendToSrv(pack)
end

-- 返回真气修炼
function LingGenCC:do_zhenqixiulian_data( pack )
	print("s->c(161,1) LingGenCC:do_zhenqixiulian_data")
	local full_remain_time = pack:readInt()
	local spup_remain_time   = pack:readInt()
	print("--------full_remain_time:", full_remain_time, spup_remain_time)
	LinggenModel:update_zhenqi_data( full_remain_time, spup_remain_time )
end

-- 真气修炼分页-潜心修炼
function LingGenCC:req_qx_xiulian( )
	print("c->s(161,2) LingGenCC:req_qx_xiulian")
	local pack = NetManager:get_socket():alloc(161,2);
	NetManager:get_socket():SendToSrv(pack)
end

-- 潜心修炼结果 1 成功, 0 不成功
function LingGenCC:do_qianxin_result( pack )
	print("s->c(161, 2) LingGenCC:do_qianxin_result")
	local result = pack:readChar()
	LinggenModel:play_result_qianxin( result )
end

-- 真气修炼分页-转化真气
function LingGenCC:req_change_zhenqi()
	print("c->s(161,3) LingGenCC:req_change_zhenqi")
	local pack = NetManager:get_socket():alloc(161, 3)
	NetManager:get_socket():SendToSrv(pack)
end

-- 真气转化结果 1 成功, 0 不成功
function LingGenCC:do_change_result( pack )
	print("s->c(161,3) LingGenCC:do_change_result")
	local result = pack:readChar()
	LinggenModel:play_result_change( result )
end

-- 1: "转" 2:"修"
-- 真气修炼，在主界面弹出小图标
function LingGenCC:do_popup_bubble( pack )
	print("s->c(161,4) LingGenCC:do_popup_bubble")
	local popup_bubble   = pack:readInt()
	LinggenModel:show_mini_btn( popup_bubble )
end