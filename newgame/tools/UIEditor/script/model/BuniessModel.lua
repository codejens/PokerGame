-----------------------------------------------
-----------------------------------------------
--------------HJH
--------------2013-5-21
BuniessModel = {}
local left_lock = false
local right_lock = false
local left_confirm = false
local right_confirm = false
--id and name
local buniess_max_num = 4
local max_item_num = 4
local buniess_info = {}
--
local my_item_info = {}
local other_item_info = {}
--
local my_item_area_add_index = 1
local my_item_area_delete_index = -1
--
local is_run_tips_in_lock_left = false
local is_run_tips_in_lock_right = false
-----------------------------------------------
-- added by aXing on 2013-5-25
function BuniessModel:fini( ... )
	left_lock = false
	right_lock = false
	left_confirm = false
	right_confirm = false

	buniess_info = {}
	my_item_info = {}
	other_item_info = {}

	my_item_area_add_index = 1
	my_item_area_delete_index = -1

	is_run_tips_in_lock_left = false
	is_run_tips_in_lock_right = false
end
-----------------------------------------------
function BuniessModel:set_is_run_tips_in_lock_left(result)
	is_run_tips_in_lock_left = result
end
-----------------------------------------------
-----------------------------------------------
function BuniessModel:set_is_run_tips_in_lock_right(result)
	is_run_tips_in_lock_right = result
end
-----------------------------------------------
-----------------------------------------------
function BuniessModel:data_add_my_item_info(info)
	if #my_item_info > max_item_num then
		return
	end
	table.insert( my_item_info, info ) 
	print("info.series",info.series)
end
-----------------------------------------------
-----------------------------------------------
function BuniessModel:data_find_my_item_info(id)
	for i = 1, #my_item_info do
		if my_item_info[i].item_id == id then
			print("my_item_info[i].series",my_item_info[i].series)
			return my_item_info[i]
		end
	end
	return nil
end
-----------------------------------------------
-----------------------------------------------
function BuniessModel:data_delete_my_item_info(id)
	for i = 1, #my_item_info do
		if my_item_info[i].item_id == id then
			table.remove( my_item_info, i )
			break
		end
	end
end
-----------------------------------------------
-----------------------------------------------
function BuniessModel:data_clear_my_item_info()
	my_item_info = nil
	my_item_info = {}
end
-----------------------------------------------
-----------------------------------------------
function BuniessModel:data_add_other_item_info(info)
	if #other_item_info > max_item_num then
		return 
	end
	table.insert( other_item_info, info )
end
-----------------------------------------------
-----------------------------------------------
function BuniessModel:data_find_other_item_info(id)
	for i = 1, #other_item_info do
		if other_item_info[i].item_id == id then
			return other_item_info[i]
		end
	end
	return nil
end
-----------------------------------------------
-----------------------------------------------
function BuniessModel:data_delete_other_item_info(id)
	for i = 1, #other_item_info do
		if other_item_info[i].item_id == id then
			table.remove( other_item_info, i )
			break
		end
	end
end
-----------------------------------------------
-----------------------------------------------
function BuniessModel:data_clear_other_item_info()
	other_item_info = nil 
	other_item_info = {}
end
-----------------------------------------------
-----------------------------------------------
function BuniessModel:update_my_item_area_add_index(index)
	my_item_area_add_index = index
end
-----------------------------------------------
-----------------------------------------------
function BuniessModel:update_my_item_area_delete_index(index)
	my_item_area_delete_index = index
end
-----------------------------------------------
-----------------------------------------------
function BuniessModel:data_add_buniess_info(tid, tname)
	if BuniessModel:data_find_buniess_info(tid) == nil and #buniess_info <= 0 then
		table.insert( buniess_info, {id = tid, name = tname} )
		return true
	else
		return false
	end
end
-----------------------------------------------
-----------------------------------------------
function BuniessModel:data_find_buniess_info(id)
	for i = 1, #buniess_info do
		if buniess_info[i].id == id then
			return buniess_info[i]
		end
	end
	return nil
end
-----------------------------------------------
-----------------------------------------------
function BuniessModel:data_remove_buniess_info(id)
	for i = 1 ,#buniess_info do
		if buniess_info[i].id == id then
			table.remove( buniess_info, i)
			break
		end
	end
end
-----------------------------------------------
-----------------------------------------------
function BuniessModel:exit_btn_function()
	BuniessCC:send_cancel_buniess()
	BagModel:set_all_item_enable()
	BagModel:hide_all_item_color_cover()
	BagModel:disable_cur_active_window()
	buniess_info = nil 
	buniess_info = {}
	local buniss_win = UIManager:find_visible_window("buniess_win")
	if buniss_win == nil then
		return
	end
	--my_item_area_add_index = 1
	buniss_win:clear_left_info()
	buniss_win:clear_right_info()
	UIManager:hide_window("buniess_win")
	left_lock = false
	right_lock = false
	left_confirm = false
	right_confirm = false
	UIManager:hide_window("buy_keyboard_win")
end
-----------------------------------------------
-----------------------------------------------
function BuniessModel:finish_buniess()
	BagModel:set_all_item_enable()
	BagModel:hide_all_item_color_cover()
	buniess_info = nil 
	buniess_info = {}
	local buniss_win = UIManager:find_visible_window("buniess_win")
	if buniss_win == nil then
		return
	end
	--my_item_area_add_index = 1
	buniss_win:clear_left_info()
	buniss_win:clear_right_info()
	UIManager:hide_window("buniess_win")
	left_lock = false
	right_lock = false
	left_confirm = false
	right_confirm = false
	UIManager:hide_window("buy_keyboard_win")
	-- BuniessModel:data_clear_my_item_info()
	-- BuniessModel:data_clear_other_item_info()
end
-----------------------------------------------
-----------------------------------------------
function BuniessModel:lock_left_buniss()
	local buniss_win = UIManager:find_visible_window("buniess_win")
	if buniss_win == nil then
		return 
	end
--	buniss_win.left_role_info.lock_buniss.view:setCurState(CLICK_STATE_DISABLE)
	--buniss_win.left_role_info.confirm.view:setCurState(CLICK_STATE_UP)
	buniss_win.left_role_info.arc.view:setIsVisible(true)
	buniss_win.left_role_info.arc:setColor(0x00000080)
	--buniss_win.left_role_info.arc:setDefaultMessageReturn(true)
	buniss_win.left_role_info.arc:setTouchBeganReturnValue(false)
	buniss_win.left_role_info.arc:setTouchMovedReturnValue(true)
	buniss_win.left_role_info.arc:setTouchEndedReturnValue(true)
	buniss_win.left_role_info.arc:setTouchEndedFun(BuniessModel.arc_rect_left_function)
	left_lock = true
end
-----------------------------------------------
-----------------------------------------------
function BuniessModel:lock_right_buniss()
	local buniss_win = UIManager:find_visible_window("buniess_win")
	if buniss_win == nil then
		return
	end
	buniss_win.lock_business_btn.view:setCurState(CLICK_STATE_DISABLE)
	--buniss_win.right_role_info.confirm.view:setCurState(CLICK_STATE_UP)
	buniss_win.right_role_info.arc.view:setIsVisible(true)
	buniss_win.right_role_info.arc:setColor(0x00000080)
	buniss_win.right_role_info.arc:setTouchBeganReturnValue(false)
	buniss_win.right_role_info.arc:setTouchMovedReturnValue(true)
	buniss_win.right_role_info.arc:setTouchEndedReturnValue(true)
	buniss_win.right_role_info.arc:setTouchEndedFun(BuniessModel.arc_rect_right_function)
	--buniss_win.right_role_info.arc:setDefaultMessageReturn(true)
	right_lock = true
end
-----------------------------------------------
-----------------------------------------------
function BuniessModel:confirm_left()
	local buniss_win = UIManager:find_visible_window("buniess_win")
	if buniss_win == nil then
		return
	end
	buniss_win.left_role_info.confirm.view:setCurState(CLICK_STATE_DISABLE)
	left_confirm = true
end
-----------------------------------------------
-----------------------------------------------
function BuniessModel:confirm_right()
	local buniss_win = UIManager:find_visible_window("buniess_win")
	if buniss_win == nil then
		return
	end
	buniss_win.right_role_info.confirm.view:setCurState(CLICK_STATE_DISABLE)
	right_confirm = true
end
-----------------------------------------------
-----------------------------------------------
function BuniessModel:receive_buniess_request(tid, tname)
	if #buniess_info > buniess_max_num then
		return
	end
	---- check is auto reject other buniess
	print("SetSystemModel:get_date_value_by_key(SetSystemModel.REJECT_BE_TRADED)",SetSystemModel:get_date_value_by_key(SetSystemModel.REJECT_BE_TRADED))
	if SetSystemModel:get_date_value_by_key(SetSystemModel.REJECT_BE_TRADED) == true then
		BuniessCC:send_answer_confirm_buniess(tid,0)
		return
	end
	----- chack max buniess request num
	if BuniessModel:data_add_buniess_info(tid, tname) == true then
		print("tid,tname",tid,tname)
		local function openfunction()
			local info = {id = tid, name = tname}
			if #buniess_info > 0 then
				local function confirm()
					print("run confirm")
					BuniessCC:send_answer_confirm_buniess(info.id,1)
					--BuniessModel:data_remove_buniess_info(info.id)
				end
				local function cancle()
					print("run cancel")
					BuniessCC:send_answer_confirm_buniess(info.id,0)
					BuniessModel:data_remove_buniess_info(info.id)
				end
				NormalDialog:show( string.format(LangModelString[23],info.name), confirm, 1, cancle, false ) -- [23]="你是否愿意与#cfff000%s#cffffff进行交易？"
			end
		end
		MiniBtnWin:show(12, openfunction, "" )
	else
		if BuniessModel:data_find_buniess_info(tid) == nil then
			BuniessCC:send_answer_confirm_buniess(tid, 0)
		end
	end
end
-----------------------------------------------
-----------------------------------------------
function BuniessModel:yb_edit_finish_function()
	local buniess_win = UIManager:find_visible_window("buniess_win")
	if buniess_win == nil then
		return
	end
	local yb_num = buniess_win.right_role_info.yb_editbox.get_num()
	BuniessCC:send_change_money(yb_num, 3)
end
-----------------------------------------------
-----------------------------------------------
function BuniessModel:yl_edit_finish_function()
	local buniess_win = UIManager:find_visible_window("buniess_win")
	if buniess_win == nil then
		return
	end
	local yl_num = buniess_win.right_role_info.yl_editbox.get_num()
	BuniessCC:send_change_money(yl_num, 1)
end
-----------------------------------------------
-----------------------------------------------
function BuniessModel:lock_buniess_function()
	BuniessCC:send_lock_buniess()
end
-----------------------------------------------
-----------------------------------------------
function BuniessModel:right_confirm_function()
	local buniess_win = UIManager:find_visible_window("buniess_win")
	if buniess_win ~= nil then
		BuniessCC:send_confirm_buniess()
		if left_lock == true and right_lock == true then
			buniess_win.confirm_btn.view:setCurState(CLICK_STATE_DISABLE)
		end
	end
end
-----------------------------------------------
-----------------------------------------------
function BuniessModel:open_buniess_win(id, name, level)
	local buniess_win = UIManager:show_window("buniess_win")
	buniess_win:clear_left_info()
	buniess_win:clear_right_info()
	buniess_win:init_left_info("#cfff000" .. name)
	buniess_win:init_right_info("#cfff000" .. EntityManager:get_player_avatar().name)
	local player = EntityManager:get_player_avatar()
	buniess_win:set_right_max_enter_num(player.yuanbao, player.yinliang)
	local bag_win = UIManager:find_visible_window("bag_win")
	BagModel:set_lock_item_dir_flag( true )
	if bag_win == nil then
		UIManager:show_window("bag_win")
	else

	end
	BagModel:set_cur_active_window(buniess_win)
	-- BagModel:set_item_when_business()
	-- 锁定背包中绑定物品
	BagModel:set_lock_item_disable(  )
	-- 停止AI
	AIManager:set_AIManager_idle(  )
	EntityManager:get_player_avatar():stop_all_action(  )
	--my_item_area_add_index = 1
end
-----------------------------------------------
-----------------------------------------------
function BuniessModel:change_my_money(yl,yb)
	local buniess_win = UIManager:find_visible_window("buniess_win")
	if buniess_win == nil then
		return
	end
	buniess_win.right_role_info.yl_editbox.set_num_not_do_cb(yl)
	buniess_win.right_role_info.yb_editbox.set_num_not_do_cb(yb)
end
-----------------------------------------------
-----------------------------------------------
function BuniessModel:change_other_money(num, style)
	local buniess_win = UIManager:find_visible_window("buniess_win")
	if buniess_win == nil then
		return
	end
	if style == 1 then
		buniess_win.left_role_info.yl_editbox.set_num_not_do_cb(num)
	elseif style == 3 then
		buniess_win.left_role_info.yb_editbox.set_num_not_do_cb(num)
	end
end
-----------------------------------------------
-----------------------------------------------
function BuniessModel:lock_buniess(my, other)
	if my > 0 then
		BuniessModel:lock_right_buniss()
		right_lock = true
	else
		right_lock = false
	end
	if other > 0 then
		BuniessModel:lock_left_buniss()
		left_lock = true
	else
		left_lock = false
	end
	if my > 0 and other > 0 then
		local buniess_win = UIManager:find_visible_window("buniess_win")
		if buniess_win ~= nil then
			buniess_win.confirm_btn.view:setCurState(CLICK_STATE_UP)
		return
	end
	end
end
-----------------------------------------------
-----------------------------------------------
function BuniessModel:update_myself_item_info(is_add, id, result)
	local buniess_win = UIManager:find_visible_window("buniess_win")
	if buniess_win == nil then
		return
	end
	if is_add == 0 and result == 1 then
		buniess_win:clear_right_item_area_info(id)
		--BuniessModel:data_delete_my_item_info(id)
	end
	if result == 0 then
		buniess_win:clear_right_item_area_info(id)
		BagModel:hide_item_color_cover(id)
		--BuniessModel:data_delete_my_item_info(id)
	end
	if is_add == 1 and result == 1 then
		BagModel:set_item_color_cover(id)
	end
end
-----------------------------------------------
-----------------------------------------------
function BuniessModel:update_other_item_info(result, item_info)
	local buniess_win = UIManager:find_visible_window("buniess_win")
	if buniess_win == nil then
		return
	end
	if result == 1 then
		print("run if")
		buniess_win:add_left_item_area_info(item_info, item_info.count)
		--BuniessModel:data_add_other_item_info(item_info)
	else
		print("run else item_info.item_id",item_info.item_id,item_info.series)
		buniess_win:clear_left_item_area_info(item_info.series)
		--BuniessModel:data_delete_other_item_info(item_info.item_id)
	end
end
-----------------------------------------------
-----------------------------------------------
function BuniessModel:auto_add_my_item_info(info)
	local buniess_win = UIManager:find_visible_window("buniess_win")
	if buniess_win == nil then
		return
	end
	if buniess_win:add_right_item_area_info(info, info.count) then
		BuniessCC:send_change_item(info.series, 1)
		--BuniessModel:data_add_my_item_info(info)
	end
end
-----------------------------------------------
-----------------------------------------------
function BuniessModel:arc_rect_left_function()
	if is_run_tips_in_lock_left == false then
		NormalDialog:show(LangModelString[24],nil,1) -- [24]="交易已鎖定"
	end
	is_run_tips_in_lock_left = false
end
-----------------------------------------------
-----------------------------------------------
function BuniessModel:arc_rect_right_function()
	if is_run_tips_in_lock_right == false then
		NormalDialog:show(LangModelString[24],nil,1) -- [24]="交易已鎖定"
	end
	is_run_tips_in_lock_right = false
end

function BuniessModel:get_right_lock_state()
	return right_lock
end