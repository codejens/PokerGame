----QQVIPModel.lua
----HJH
----2013-8-8
----
QQVIPModel = {}
----------------------
local _reinit = false
local _vip_info = { get_fresh_award = 0, get_today_award = 0, get_blue_pet = 0, get_year_award = 0, get_level_award = {} }
local _vip_open_state = 0
----------------------
function QQVIPModel:fini( ... )
	_reinit = true
	--_vip_info = { get_fresh_award = 0, get_today_award = 0, get_blue_pet = 0, get_year_award = 0, get_level_award = {} }
end
----------------------
function QQVIPModel:get_reinit()
	return _reinit
end
----------------------
function QQVIPModel:set_vip_open_state(state)
	_vip_open_state = state
end
----------------------
function QQVIPModel:get_vip_open_state()
	return _vip_open_state
end
----------------------
function QQVIPModel:reinit_info()
	_reinit = false
	_vip_open_state = 0
	_vip_info = { get_fresh_award = 0, get_today_award = 0, get_blue_pet = 0, get_year_award = 0, get_level_award = {} }
end	
----------------------
function QQVIPModel:get_vip_info()
	return _vip_info
end
----------------------
-- function QQVIPModel:qq_blue_vip_btn_fun()
-- 	if Target_Platform ~= Platform_Type.UNKNOW then
-- 		local temp_url = QQVIPName:get_qq_blue_vip_url()
-- 		print("QQVIPModel:qq_blue_vip_btn_fun url=",temp_url)
-- 		phoneGotoURL(temp_url)	
-- 	end
-- end
----------------------
function QQVIPModel:get_btn_fun()
	local player = EntityManager:get_player_avatar()
	local temp_qqvip_info = QQVipInterface:get_qq_vip_platform_info(player.QQVIP)
	local temp_platform_info = QQVipInterface:QQVipInterface_Get_Platform_QQvip_Activity_PanelInfo_Function()
	if _vip_info.get_blue_pet == 0 and (temp_qqvip_info.is_vip == 1 or temp_qqvip_info.is_super_vip == 1)then
		OnlineAwardCC:client_get_blue_award(3, nil)
	else
		--old
		if temp_qqvip_info.is_vip == 0 or temp_qqvip_info.is_super_vip == 0 then
		local function recharge_fun()
			if QQVipInterface.QQVipInterface_Get_Platform_QQvip_Recharge_Url_Function ~= nil then
				local temp_url = QQVipInterface:QQVipInterface_Get_Platform_QQvip_Recharge_Url_Function()
				print("QQVipInterface:get_qq_vip_recharge_url url=",temp_url)
				phoneGotoURL(temp_url) 
			end
		end
		local notic_info = temp_platform_info.warning_info.vip_pet_get 
		NormalDialog:show( notic_info, recharge_fun, 3 )
		return	
		--new
		--if temp_qqvip_info.is_vip == 0 or temp_qqvip_info.is_super_vip == 0 or _vip_open_state == 0 then
			-- local function recharge_fun()
			-- 	local temp_url = QQVipInterface:QQVipInterface_Get_Platform_QQvip_Recharge_Url_Function()
			-- 	print("QQVipInterface:get_qq_vip_recharge_url url=",temp_url)
			-- 	phoneGotoURL(temp_url) 
			-- end
			-- local notic_info = temp_platform_info.warning_info.vip_pet_get 
			-- if _vip_open_state == 0 then
			-- 	notic_info = "亲！只有在游戏内开通或续费蓝钻的用户才可以领取宠物!!!"
			-- end
			-- NormalDialog:show( notic_info, recharge_fun, 3 )
			-- return
		else
			GlobalFunc:create_screen_notic(LangModelString[400]) -- [400]="礼包已领取"
		end
	end
end
----------------------
function QQVIPModel:item_get_btn_fun(index)
	local player = EntityManager:get_player_avatar()
	local info, temp_level = QQVipConfig:get_vip_blue_level_award(player.level)
	local temp_level_index = QQVIPModel:get_cur_level_award_index( temp_level / 10 )
	local temp_qqvip_info = QQVipInterface:get_qq_vip_platform_info(player.QQVIP)
	local temp_platform_info = QQVipInterface:QQVipInterface_Get_Platform_QQvip_Activity_PanelInfo_Function()
	if temp_qqvip_info.is_vip == 0 and temp_qqvip_info.is_super_vip == 0 then
		local function recharge_fun()
			if QQVipInterface.QQVipInterface_Get_Platform_QQvip_Recharge_Url_Function then
				local temp_url = QQVipInterface:QQVipInterface_Get_Platform_QQvip_Recharge_Url_Function()
				--print("QQVipInterface:get_qq_vip_recharge_url url=",temp_url)
				phoneGotoURL(temp_url) 
			end
		end
		NormalDialog:show( temp_platform_info.warning_info.vip_get, recharge_fun, 3 )
		return
	end
	if index == 1 and _vip_info.get_fresh_award == 0 then
		OnlineAwardCC:client_get_blue_award( 1, nil )
	elseif index == 2 and _vip_info.get_today_award == 0 then
		OnlineAwardCC:client_get_blue_award( 2, nil )
	elseif index == 3 and _vip_info.get_level_award[ temp_level_index ] == 0 then
		if player.level >= 10 then
			OnlineAwardCC:client_get_blue_award( 4, temp_level_index )
		else
			GlobalFunc:create_screen_notic(LangModelString[401]) -- [401]="等级不足"
		end
	elseif index == 4 and _vip_info.get_year_award == 0 then
		if temp_qqvip_info.is_year_vip == 1 then
			OnlineAwardCC:client_get_blue_award( 5, nil )
		else
			GlobalFunc:create_screen_notic( temp_platform_info.warning_info.vip_year_get )
		end
	end
end
----------------------
function QQVIPModel:update_qqvip_award_info(info, open_result)
	-- print("QQVIPModel:update_qqvip_award_info info", info)
	_vip_info.get_fresh_award = Utils:get_bit_by_position( info, 1 )
	_vip_info.get_today_award = Utils:get_bit_by_position( info, 2 )
	_vip_info.get_blue_pet = Utils:get_bit_by_position( info, 3 )
	_vip_info.get_year_award = Utils:get_bit_by_position( info, 4 )
	for i = 5, 20 do
		_vip_info.get_level_award[ i - 4 ] = Utils:get_bit_by_position( info, i )
	end
	-- print("_vip_info.get_fresh_award,_vip_info.get_today_award,_vip_info.get_blue_pet,_vip_info.get_year_award,_vip_info.get_level_award",_vip_info.get_fresh_award,_vip_info.get_today_award,_vip_info.get_blue_pet,_vip_info.get_year_award,_vip_info.get_level_award)
	local qqvip_win = UIManager:find_window("qqvip_win")
	if qqvip_win ~= nil then
		qqvip_win:update_award_win()
	end
end

----------------------
function QQVIPModel:get_cur_level_award_index(index)
	for i = 1, #_vip_info.get_level_award do
		if _vip_info.get_level_award[i] == 0 and i <= index then
			return i
		end
	end
	return index
end
