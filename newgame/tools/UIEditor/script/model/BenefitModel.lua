-- BenefitModel.lua
-- created by LittleWhite on 2014-7-24
-- 福利中心Model

BenefitModel = {}

-- 登陆信息
local _login_info = {}

-- 更新福利中心窗口
function BenefitModel:update_win( update_type )
	local win = UIManager:find_visible_window("benefit_win")
	if win then
		win:update( update_type )
	end 
end

-- 设置登陆信息
function BenefitModel:set_login_info(benefit_type,login_days,get_status_flags)
	--1:表示首月,2:表示其他
	_login_info.benefit_type = benefit_type
	--累计登陆奖励
	_login_info.login_days = login_days
	--按位算,1表示已领取,0未领取
	_login_info.get_status_flags = get_status_flags

end

-- 获取登陆信息
function BenefitModel:get_login_info()
	return _login_info
end

-- 获取登陆奖励类型
function BenefitModel:get_benefit_type()
	return _login_info.benefit_type
end

-- 获取登陆天数
function BenefitModel:get_login_days()
	return _login_info.login_days
end

-- 获取领取记录
function BenefitModel:get_status_flags()
	return _login_info.get_status_flags
end

-- 界面飞出福字用于跳链
function BenefitModel:show_benefit_miniBtn()
	local player_level = EntityManager:get_player_avatar().level
	   if player_level > 19 then
			 local is_already_exist,index = MiniBtnWin:is_already_exist( 20 );
			if not is_already_exist then
				local function temp_fun()
					local win = UIManager:show_window("benefit_win")
					if win~=nil then
						MiniBtnWin:set_aoto_remove_flag(false)
						win:change_page(1)
					end 
				end 
				MiniBtnWin:show(20, temp_fun, "")

			end
	end 
end

