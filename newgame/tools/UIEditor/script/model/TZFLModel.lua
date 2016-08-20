-----------------------------------------------
-----------------------------------------------
---------HJH
---------2013-5-24
---------投資返利
TZFLModel = {}
-----------------------------------------------
local icon_button_info = { 2, 2, 2, 2, 2, 2, 2, 2, 2, 2 }
local is_buy = 0
local buy_icon_type = 0
local is_show_tzfl_icon = true
local _reinit = false
-----------------------------------------------
-- added by aXing on 2013-5-25
function TZFLModel:fini( ... )
	icon_button_info = { 2, 2, 2, 2, 2, 2, 2, 2, 2, 2 }
	is_buy = 0
	buy_icon_type = 0
end
-----------------------------------------------
-- function TZFLModel:reinit_info()
-- 	_reinit = false
-- 	icon_button_info = { 2, 2, 2, 2, 2, 2, 2, 2, 2, 2 }
-- 	is_buy = 0
-- 	buy_icon_type = 1
-- end
-----------------------------------------------
-- function TZFLModel:get_reinit()
-- 	return _reinit
-- end
-----------------------------------------------
function TZFLModel:check_can_get()
	for i = 1, #icon_button_info do
		if icon_button_info[i] == 0 then
			return true
		end
	end
	return false
end
-----------------------------------------------
function TZFLModel:data_update_index_icon_button_info(index,info)
	icon_button_info[index] = info
end
-----------------------------------------------
-----------------------------------------------
function TZFLModel:get_is_show_tzfl_icon()
	return is_show_tzfl_icon
end
-----------------------------------------------
-----------------------------------------------
function TZFLModel:open_win()
	--if is_buy == 1 then
		--tzfl_win.get_it_right_now.view:setIsVisible( false )
		TZFLModel:request_info()
	--else
		local tzfl_win = UIManager:show_window("tzfl_win")
		if tzfl_win == nil then
			return
		end	
		for i = 1 , #icon_button_info do
			if is_buy == 0 then
				tzfl_win.reward_item_info[i].button.view:setIsVisible(false)
			else 
				if icon_button_info[i] == 0 then
					--tzfl_win.reward_item_info[i].button:setText("可领取")
					tzfl_win.reward_item_info[i].button.view:addTexWithFile(CLICK_STATE_UP, UIResourcePath.FileLocate.tzfl .. "get_it_button.png")
					tzfl_win.reward_item_info[i].button.view:setCurState(CLICK_STATE_UP)
				elseif icon_button_info[i] == 1 then
					--tzfl_win.reward_item_info[i].button:setText("已领取")
					tzfl_win.reward_item_info[i].button.view:addTexWithFile(CLICK_STATE_DISABLE, UIResourcePath.FileLocate.tzfl .. "has_get_it_button.png")
					-- tzfl_win.reward_item_info[i].button.view:setCurState(CLICK_STATE_UP)
					tzfl_win.reward_item_info[i].button.view:setCurState(CLICK_STATE_DISABLE)
				elseif icon_button_info[i] == 2 then
					--tzfl_win.reward_item_info[i].button:setText("不可领")
					tzfl_win.reward_item_info[i].button.view:addTexWithFile(CLICK_STATE_UP, UIResourcePath.FileLocate.tzfl .. "get_it_button.png")
					-- tzfl_win.reward_item_info[i].button.view:setCurState(CLICK_STATE_UP)
					tzfl_win.reward_item_info[i].button.view:setCurState(CLICK_STATE_DISABLE)
				end
				print("icon_button_info[i]",icon_button_info[i])
				if icon_button_info[i] ~= nil then
					tzfl_win.reward_item_info[i].button.view:setIsVisible(true)
				else
					tzfl_win.reward_item_info[i].button.view:setIsVisible(false)
				end
			end
		end
		if is_buy == 0 then
			tzfl_win.get_it_right_now.view:setIsVisible( true )
		else
			tzfl_win.get_it_right_now.view:setIsVisible( false )
		end
	--end
end
-----------------------------------------------
-----------------------------------------------
function TZFLModel:exit_function()
	UIManager:hide_window("tzfl_win")
end
-----------------------------------------------
-----------------------------------------------
function TZFLModel:update_item_button_info(info)

	is_buy = 1
	--------------
	---check num item get
	local num_get = 0
	for i = 1 , #info do
		if info[i] == 1 then
			num_get = num_get + 1
		end
		TZFLModel:data_update_index_icon_button_info(i, info[i])
	end
	--------------
	---update is show tzfl icon
	if num_get >= #info then
		is_show_tzfl_icon = false
	end
	print("是否显示 icon is_show_tzfl_icon",is_show_tzfl_icon)
	---
	local tzfl_win = UIManager:find_visible_window("tzfl_win")
	if tzfl_win == nil then
		return--tzfl_win = UIManager:show_window("tzfl_win")
	end
	if is_buy == 0 then
		tzfl_win.get_it_right_now.view:setIsVisible( true )
	else
		tzfl_win.get_it_right_now.view:setIsVisible( false )
	end
	for i = 1 , #info do
		if info[i] == 0 then
			tzfl_win.reward_item_info[i].button:setText(LH_COLOR[2]..Lang.benefit.welfare[8])
			-- tzfl_win.reward_item_info[i].button.view:addTexWithFile(CLICK_STATE_UP, UIResourcePath.FileLocate.tzfl .. "get_it_button.png")
			tzfl_win.reward_item_info[i].button.view:setCurState(CLICK_STATE_UP)
		elseif info[i] == 1 then
			tzfl_win.reward_item_info[i].button:setText(LH_COLOR[2]..Lang.benefit.welfare[22])
			-- tzfl_win.reward_item_info[i].button.view:addTexWithFile(CLICK_STATE_DISABLE, UIResourcePath.FileLocate.tzfl .. "has_get_it_button.png")
			-- tzfl_win.reward_item_info[i].button.view:setCurState(CLICK_STATE_UP)
			tzfl_win.reward_item_info[i].button.view:setCurState(CLICK_STATE_DISABLE)
		elseif info[i] == 2 then
			tzfl_win.reward_item_info[i].button:setText(LH_COLOR[2]..Lang.benefit.welfare[8])
			-- tzfl_win.reward_item_info[i].button.view:addTexWithFile(CLICK_STATE_UP, UIResourcePath.FileLocate.tzfl .. "get_it_button.png")
			-- tzfl_win.reward_item_info[i].button.view:setCurState(CLICK_STATE_UP)
			tzfl_win.reward_item_info[i].button.view:setCurState(CLICK_STATE_DISABLE)
		end
		if info[i] ~= nil then
			tzfl_win.reward_item_info[i].button.view:setIsVisible(true)
		else
			tzfl_win.reward_item_info[i].button.view:setIsVisible(false)
		end
	end
	if is_show_tzfl_icon == false then
		-- local win = UIManager:find_window("activity_menus_panel")
		local win = UIManager:find_window("right_top_panel")
		win:remove_btn(13)
		----hide window
		UIManager:hide_window("tzfl_win")
	end
	
	-- if ( is_show_tzfl_icon ) then 
	-- 	win:insert_btn(1);
	-- else
	-- 	win:remove_btn(1);
	-- end
end
-----------------------------------------------
-----------------------------------------------
function TZFLModel:request_info()
	MiscCC:send_tzfl_info()
end
-----------------------------------------------
-----------------------------------------------
function TZFLModel:request_buy()
	local player = EntityManager:get_player_avatar()
	local cur_yb = player.yuanbao
	if cur_yb >= 200 then
		MiscCC:send_tzfl_buy()
	else
		local function confirm2_func()
            GlobalFunc:chong_zhi_enter_fun()
            --UIManager:show_window( "chong_zhi_win" )
    	end
    	ConfirmWin2:show( 2, 2, "",  confirm2_func)
    end
end
-----------------------------------------------
-----------------------------------------------
function TZFLModel:update_win_info(icon_state, icon_type)
	is_buy = icon_type
	buy_icon_type = icon_state
	if is_buy == 1 then
		TZFLModel:request_info()
	end
	-- 通知主界面隐藏投资返利按钮
	-- if buy_icon_type == 0 then
	-- 	local win = UIManager:find_visible_window("right_top_panel")
	-- 	if win then
	-- 		win:set_yunyinhuodong_btn_visible( false )
	-- 	end
	-- else
	-- 	local win = UIManager:find_visible_window("right_top_panel")
	-- 	if win then
	-- 		win:set_operation_activity_btn( 2 )
	-- 	end		
	-- end
	local tzfl_win = UIManager:find_visible_window("tzfl_win")
	if tzfl_win == nil then
		return
	end
	if is_buy == 0 then
		tzfl_win.get_it_right_now.view:setIsVisible( true )
	else
		tzfl_win.get_it_right_now.view:setIsVisible( false )
	end
end

-----------------------------------------------------
-- 取得投资返利按钮的状态
-----------------------------------------------------
function TZFLModel:get_buy_icon_state()
	return buy_icon_type;
end


-----------------------------------------------
-----------------------------------------------
function TZFLModel:get_it_right_now_function()
	local tzfl_info = TZFLConfig:get_tzfl_info()
	NormalDialog:show( string.format(Lang.tzfl_info.buy_notic, tzfl_info.need_yuanbao), TZFLModel.request_buy, 1, nil )
end