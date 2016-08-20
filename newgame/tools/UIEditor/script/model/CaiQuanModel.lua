-- CaiQuanModel.lua
-- created by fjh on 2013-7-27
-- 猜拳系统

CaiQuanModel = {}

CaiQuanModel.GAME_STATE_WAITE 		= 0;
CaiQuanModel.GAME_STATE_MATCHING 	= 1;
CaiQuanModel.GAME_STATE_PLAYING 	= 2;
CaiQuanModel.GAME_STATE_RESULT 		= 3;	

local _self_info = nil;
local _game_state = CaiQuanModel.GAME_STATE_WAITE;

function CaiQuanModel:fini(  )
	_self_info = nil;	
	_game_state = CaiQuanModel.GAME_STATE_WAITE;
end


function CaiQuanModel:get_self_info(  )
	return _self_info;
end
function CaiQuanModel:set_game_state( state )
	_game_state = state;
end
function CaiQuanModel:get_game_state(  )
	return _game_state;
end

---------------------------网络协议

-- 拉去自己的信息
function CaiQuanModel:req_self_info( )
	CaiQuanCC:req_self_info(  )
end
function CaiQuanModel:do_self_info( data )
	for k,v in pairs(data) do
		print("猜拳 --------------- 自己的信息",k,v)
	end

	_self_info = data;

	if _game_state == CaiQuanModel.GAME_STATE_PLAYING then
		-- 正在出拳阶段的时候，只更新自己信息
		local win = UIManager:find_visible_window("caiquan_win");
		if win then
			win:update_self_info(  )
		end
	else
		_game_state = CaiQuanModel.GAME_STATE_WAITE;

		local win = UIManager:find_visible_window("caiquan_win");
		if win then
			win:enter_waite_for_match(  )
		end

	end

end

function CaiQuanModel:req_match_event(  )
	GameLogicCC:req_talk_to_npc( 0, "OnMoraSignUp" );
end

-- 系统匹配中
function CaiQuanModel:do_system_match_ing(  )
	print("猜拳 --------------- 匹配中");
	_game_state = CaiQuanModel.GAME_STATE_MATCHING;

	local win = UIManager:find_visible_window("caiquan_win");
	
	if win then
		win:enter_match_ing_status(  )
	end

end

-- 取消匹配
function CaiQuanModel:req_cancel_match(  )
	CaiQuanCC:req_cancel_match(  )
	print("猜拳 --------------- 取消匹配");
	_game_state = CaiQuanModel.GAME_STATE_WAITE;
	
	local win = UIManager:find_visible_window("caiquan_win");
	if win then
		win:enter_waite_for_match(  )
	end
	
end

-- 获取到对手信息
function CaiQuanModel:do_get_match_info( data )
	for k,v in pairs(data) do
		print("猜拳 --------------- 对手信息",k,v)
	end
	_game_state = CaiQuanModel.GAME_STATE_PLAYING;

	local win = UIManager:find_visible_window("caiquan_win");
	if win then
		
		win:enter_match_succesed( data )

	end
	
	CaiQuanModel:req_self_info();

end



-- 开始猜拳
function CaiQuanModel:req_take_caiquan( index )
	CaiQuanCC:req_take_caiquan( index )
	print("猜拳 --------------- 开始猜拳",index);
end

-- 猜拳结果
function CaiQuanModel:do_take_caiquan( data )
	for k,v in pairs(data) do
		print("猜拳 --------------- 猜拳结果",k,v)
	end
	_game_state = CaiQuanModel.GAME_STATE_RESULT;

	local win = UIManager:find_visible_window("caiquan_win");
	if win then
		win:enter_show_result_status( data )
	end
	
end





