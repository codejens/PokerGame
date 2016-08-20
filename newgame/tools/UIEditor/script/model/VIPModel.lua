-- VIPModel.lua
-- created by fjh on 2012-12-29
-- vip模型 动态数据

-- super_class.VIPModel()
VIPModel = {}

local _vip_info = nil;

-- vip体验时间
local _expe_vip_time = 0;

--_vip_info 结构
--{
--self.level = pack:readInt();  				--vip等级
--self.all_yuanbao_value = pack:readInt();	--已经充值了的元宝
--self.current_yuanbao_value = pack:readInt();	--本次充值的元宝
--}

-- added by aXing on 2013-5-25
function VIPModel:fini( ... )
	_vip_info = nil;
	_expe_vip_time = 0;
end

local _first_load = true
-- 设置vipxinx
function VIPModel:set_vip_info( vip_info )
	_vip_info = vip_info;

	if _expe_vip_time > 0 and _vip_info.level < 3  then
		
	else
		-- 当vip_info发生变化时 要更新主界面的vip等级
		local win = UIManager:find_visible_window("user_panel");
		if ( win ) then
			win:update_vip_level( _vip_info.level );
		end

		-- 删除主屏幕上的仙尊3体验卡
		local win = UIManager:find_window("right_top_panel");
		if win then
			win:remove_btn( 2 ); 
		end

	end

	--同步推不给充值后打开美女助手，去掉了
	if Target_Platform ~= Platform_Type.Platform_tb and _first_load then
		_first_load=false
		ActivityModel:enter_game_open_activity_win(  )
	end

	-- 更新vip界面数据
	local vipWin = UIManager:find_visible_window("vipSys_win")
	if vipWin then
		vipWin:update()
	end
end

-- 获取vip信息
function VIPModel:get_vip_info( )
	return _vip_info;
end

-- 使用vip体验卡， time 为秒数
function VIPModel:set_expe_vip_time( time )

	_expe_vip_time = time;

	if _expe_vip_time > 0 then
		print("使用vip体验卡。剩余时间 ==",_expe_vip_time)
		local win = UIManager:find_window("right_top_panel");
		if win then
			win:show_vip_expe_btn(_expe_vip_time);
		end
		-- 当设置vip时间时，要改变玩家的vip等级
		local win = UIManager:find_visible_window("user_panel");
		if ( win ) then
			local vipInfo = VIPModel:get_vip_info()
			if vipInfo.level > 0 then
				win:update_vip_level(vipInfo.level)
			else
				win:update_vip_level( 3 )
			end
		end
		-- 更新VIP体验窗口的按钮状态
		local win = UIManager:find_visible_window("vip_card_win")
		if win then
			win:update_btn_state(false)
		end
	end

	
end

-- 获取vip体验时间
function VIPModel:get_expe_vip_time(  )
	return _expe_vip_time;
end

-- 体验卡结束的通知
function VIPModel:did_finish_expe_vip(  )
	-- 当设置vip时间时，要改变玩家的vip等级
	local win = UIManager:find_visible_window("user_panel");
	if ( win ) then
		win:update_vip_level( _vip_info.level )
	end
	_expe_vip_time = 0;
end

-- 取得玩家的vip等级大于3或使用vip体验卡
function VIPModel:is_vip_lv3()
	local vip_info = VIPModel:get_vip_info( ) ;
	if ( VIPModel:get_expe_vip_time(  ) > 0 or ( vip_info and vip_info.level >= 3 )) then
		return true;
	end
	return false;
end
