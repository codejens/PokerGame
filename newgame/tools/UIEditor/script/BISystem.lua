-- BISystem.lua
-- created by aXing on 2013-5-30
-- BI 打点系统

BISystem = {}

require "net/HttpRequest"
require 'platform/PlatformInfoForBISystem'
-- BI系统的服务器地址
local _log_server_address =  CommonConfig:getDefault("bi_server_url")
local _address_param =       CommonConfig:getDefault("bi_server_fix_param") 

BISystem.error_place_open_to_update = "open_app_to_update_check"
BISystem.error_place_login_to_server = "login_to_server_choice"
BISystem.error_place_server_to_actor = "server_choice_to_actor_choice"

-- 初始化BI系统，需要日志服务器地址
function BISystem:init( url, param , local_url)
	-- print('[try] BISystem:init',url,param,local_url)
	_log_server_address = url or _log_server_address
	_address_param = param or _address_param
	--本地的Bisystem
	BISystem.local_url = local_url
	BISystem:open_app()
	BISystem:log_phone_model()
end

-- BI系统的反馈
local function BI_log_response( err, message )
	-- body
	-- print('BI_Response err : [' .. err .. '] message : >' .. message .. '<')
end

-- 发送打点日志
function BISystem:send_log( url, param )
	
	-- ZXLog('[try] BISystem:send_log url',url)
	-- ZXLog('[try] BISystem:send_log param',param)
	--if GetPlatform() ~= CC_PLATFORM_WIN32 then
		HttpRequest:sendBI( url, param, BI_log_response, false )
	--end
end

-- 记录二次下载的百分比
function BISystem:log_loading( progress )
	local date = os.date("%Y-%m-%d")
	local time = os.date("%H:%M:%S")
	local download_from = BISystem:getDownloadChannel() or ""  -- 平台
	local param = _address_param .. 
				"&type=counter" ..
				-- 二次下载的时候还不知道用户名
				--"&userid=" .. GlobalData.SPLoginUser ..	
				"&counter=startup" ..
				-- 无法知道是否第一次进入游戏
				--"&kingdom="	.. (GlobalData.newbie ? "first" : "all") ..
				"&phylum=" .. progress .. 
				"&user_level=0" .. 
				"&extra=download_from:" ..  download_from .. 
				"&gameinfo_time=" .. date .. ' ' .. time
	BISystem:send_log( _log_server_address, param )
	BISystem:send_log( BISystem.local_url, param )
end

-- 记录引导任务
function BISystem:log_quest( id, type, progress, step )
	-- body
end

-- 记录流量统计
function BISystem:log_proto_analyze( proto_data )
	-- 屏蔽流量统计发送 2014/7/29 15:09
	if true then
		return
	end
	
	local player = EntityManager:get_player_avatar()

	if player == nil then
		return
	end

	local login_info = RoleModel:get_login_info()

	if login_info == nil then
		return
	end

	local date = os.date("%Y-%m-%d")
	local time = os.date("%H:%M:%S")
	local download_from = BISystem:getDownloadChannel() or ""  -- 平台

	for k,v in ipairs(proto_data) do
		if k > 10 then
			break
		end

		local param = _address_param ..
			"&type=counter" ..
			"&userid=" .. login_info.user_name ..
			"&counter=idc&kingdom=client" ..
			"&phylum=" .. "" ..
			"&value=" .. v.sys_id .. "," .. v.func_id .. "," .. v.total_size ..
			--"&phylum=" .. v.sys_id .. "," .. v.func_id .. "&value=" .. v.total_size ..
			"&user_level=" .. player.level .. 
			"&extra=download_from:" ..  download_from .. 
			"&gameinfo_time=" .. date .. ' ' .. time
		if login_info.server_id ~= nil then
			param = param .. "&serverid=" .. login_info.server_id
		end
		BISystem:send_log( _log_server_address, param)
		BISystem:send_log( BISystem.local_url, param )
	end
	
end

-- 记录手机型号
function BISystem:log_phone_model(  )
	local date = os.date("%Y-%m-%d")
	local time = os.date("%H:%M:%S")
	local download_from = BISystem:getDownloadChannel() or ""  -- 平台
	if GetPlatform() == CC_PL3M_IOS then
		require "model/IOSDispatcher"
		local device_info = IOSDispatcher:get_device_info( )
		if device_info then

			local param = _address_param ..
					"&type=counter" ..
					"&counter=cellphone" ..
					"&kingdom=" .. device_info["deviceVer"] ..
					"&phylum=" .. device_info["iOSVer"] .. 
					"&user_level=" .. 0 .. 
					"&extra=download_from:" ..  download_from .. 
					"&gameinfo_time=" .. date .. ' ' .. time
			BISystem:send_log( _log_server_address, param)
			BISystem:send_log( BISystem.local_url, param )
		end
	else
		local phone = GetPhoneState()
		if phone ~= "0" then
			-- 这里要验证，是否已经发送过手机型号
			local phone_model = CCUserDefault:sharedUserDefault():getStringForKey("phone_model")
			if phone_model ~= '' then
				return
			end

			CCUserDefault:sharedUserDefault():setStringForKey("phone_model", phone)
			local model, version = string.match(phone, "(%Z+)%,(%Z+)")
			local param = _address_param ..
					"&type=counter" ..
					"&counter=cellphone" ..
					"&kingdom=" .. model ..
					"&phylum=" .. version .. 
					"&user_level=" .. 0 .. 
					"&extra=download_from:" ..  download_from .. 
					"&gameinfo_time=" .. date .. ' ' .. time
			BISystem:send_log( _log_server_address, param)
			BISystem:send_log( BISystem.local_url, param )
		end
	end
end

-- 记录用户操作
-- @ joystick_times				玩家操作摇杆的次数
-- @ hit_scene_times			玩家点击地面操作的次数
-- @ click_mission_times 		玩家单击任务追踪面板的次数
-- @ double_click_mission_times 玩家双击任务追踪面板的次数
function BISystem:log_user_habits( joystick_times, hit_scene_times, click_mission_times, double_click_mission_times )

	local player = EntityManager:get_player_avatar()

	if player == nil then
		return
	end

	local login_info = RoleModel:get_login_info()

	if login_info == nil then
		return
	end

	local date = os.date("%Y-%m-%d")
	local time = os.date("%H:%M:%S")
	local download_from = BISystem:getDownloadChannel() or ""  -- 平台
	local param = _address_param ..
			"&type=counter" ..
			"&userid=" .. login_info.user_name ..
			"&counter=control_cnt" ..
			"&value=" .. joystick_times ..
			"&user_level=" .. player.level .. 
			"&gameinfo_time=" .. date .. ' ' .. time ..
			"&extra=hit:" .. hit_scene_times .. 
			",mission_hit:" .. click_mission_times ..
			",mission_hit2:" .. double_click_mission_times ..
			",download_from:" .. download_from

	if login_info.server_id ~= nil then
		param = param .. "&serverid=" .. login_info.server_id
	end

	BISystem:send_log(_log_server_address, param)
	BISystem:send_log( BISystem.local_url, param )
end

-- 记录用户商城的操作习惯
function BISystem:log_mall_habits( click_marks )

	local player = EntityManager:get_player_avatar()

	if player == nil then
		return
	end

	local login_info = RoleModel:get_login_info()

	if login_info == nil then
		return
	end

	local date = os.date("%Y-%m-%d")
	local time = os.date("%H:%M:%S")
	local download_from = BISystem:getDownloadChannel() or ""  -- 平台
	local param = _address_param ..
			"&type=counter" ..
			"&userid=" .. login_info.user_name ..
			"&counter=mall_cnt" ..
			"&user_level=" .. player.level ..
			"&gameinfo_time=" .. date .. ' ' .. time ..
			"&extra=download_from:" .. download_from .. ","

	if click_marks[1] ~= nil then
		param = param .. "hot:" .. click_marks[1] .. ","
	end

	if click_marks[2] ~= nil then
		param = param .. "common:" .. click_marks[2] .. ","
	end

	if click_marks[3] ~= nil then
		param = param .. "dress:" .. click_marks[3] .. ","
	end

	if click_marks[4] ~= nil then
		param = param .. "gem:" .. click_marks[4] .. ","
	end

	if click_marks[5] ~= nil then
		param = param .. "pet:" .. click_marks[5] .. ","
	end

	if click_marks[6] ~= nil then
		param = param .. "bindyb:" .. click_marks[6] .. ","
	end

	-- 删掉最后的一个逗号
	param = string.sub(param, 1, string.len(param) - 1)

	if login_info.server_id ~= nil then
		param = param .. "&serverid=" .. login_info.server_id
	end

	BISystem:send_log(_log_server_address, param)
	BISystem:send_log( BISystem.local_url, param )
end

---------主界面下方入口图标打点
function BISystem:menu_panel_habits(click_marks)

	local date = os.date("%Y-%m-%d")
	local time = os.date("%H:%M:%S")
	for key, value in pairs(click_marks) do
		if value ~= nil then
			local player = EntityManager:get_player_avatar()

			if player == nil then
				return
			end

			local login_info = RoleModel:get_login_info()

			if login_info == nil then
				return
			end
			-- print("bi_print: key = ",key,Analyze.main_win_bi_info[key]);
			local download_from = BISystem:getDownloadChannel() or ""  -- 平台
			local param = _address_param ..
					"&type=counter" ..
					"&userid=" .. login_info.user_name ..
					"&counter=extrainffo_cnt" ..
					"&kingdom=" .. Analyze.main_win_bi_info[key].info ..
					"&value=" .. value .. 
					"&user_level=" .. player.level ..
					"&extra=download_from:" ..  download_from .. 
					"&gameinfo_time=" .. date .. ' ' .. time


			if login_info.server_id ~= nil then
				param = param .. "&serverid=" .. login_info.server_id
			end

			BISystem:send_log(_log_server_address, param)
			BISystem:send_log(BISystem.local_url, param)
		end
	end
end

---------功能菜单图标打点
function BISystem:menupanelt_panel_habits(click_marks)

	local date = os.date("%Y-%m-%d")
	local time = os.date("%H:%M:%S")
	local download_from = BISystem:getDownloadChannel() or ""  -- 平台
	for key, value in pairs(click_marks) do
		if value ~= nil then
			local player = EntityManager:get_player_avatar()

			if player == nil then
				return
			end

			local login_info = RoleModel:get_login_info()

			if login_info == nil then
				return
			end

			local param = _address_param ..
					"&type=counter" ..
					"&userid=" .. login_info.user_name ..
					"&counter=extrainffo_cnt" ..
					"&kingdom=" .. key ..
					"&value=" .. value ..
					"&user_level=" .. player.level .. 
					"&extra=download_from:" ..  download_from ..
					"&gameinfo_time=" .. date .. ' ' .. time

			if login_info.server_id ~= nil then
				param = param .. "&serverid=" .. login_info.server_id
			end

			BISystem:send_log(_log_server_address, param)
			BISystem:send_log( BISystem.local_url, param )
		end
	end
end


---------活动菜单弹出来的窗口
function BISystem:acitivity_panel_habits(click_marks)

	local date = os.date("%Y-%m-%d")
	local time = os.date("%H:%M:%S")
	local download_from = BISystem:getDownloadChannel() or ""  -- 平台
	for key, value in pairs(click_marks) do
		if value ~= nil then
			local player = EntityManager:get_player_avatar()

			if player == nil then
				return
			end

			local login_info = RoleModel:get_login_info()

			if login_info == nil then
				return
			end
			
			if not Analyze.activity_win_bi_info[key] or type(Analyze.activity_win_bi_info[key]) ~= "table" then
				return
			end
			
			local param = _address_param ..
					"&type=counter" ..
					"&userid=" .. login_info.user_name ..
					"&counter=extrainffo_cnt" ..
					"&kingdom=" .. Analyze.activity_win_bi_info[key].info .. 
					"&value=" .. value.times .. 
					"&user_level=" .. player.level .. 
					"&extra=download_from:" ..  download_from .. 
					"&gameinfo_time=" .. date .. ' ' .. time

			if login_info.server_id ~= nil then
				param = param .. "&serverid=" .. login_info.server_id
			end

			BISystem:send_log(_log_server_address, param)
			BISystem:send_log( BISystem.local_url, param )
		end
	end
end

---------------------------------------------------------
-- added by aXing on 2013-6-26
-- 新的BI需求
---------------------------------------------------------
-- 记录打开应用
function BISystem:open_app(  )
	-- print("火影BI打点步骤一检测---------->>>>>>>>> BISystem:open_app()")
	local user_id = CCUserDefault:sharedUserDefault():getStringForKey("user_id")
	if user_id == '' then
		----print("user default has not user id!")
		return
	end
	-- 打开应用的次数
	local times = CCUserDefault:sharedUserDefault():getIntegerForKey("open_app") or 0
	times = times + 1

	local download_from = BISystem:getDownloadFrom() or ""  -- 平台
	local chanel_id = BISystem:getDownloadChannel()	or ""	-- 渠道号
	-- local date, time = string.match(os.date(), "(%Z+) (%Z+)")
	local date = os.date("%Y-%m-%d")
	local time = os.date("%H:%M:%S")

	local available_memory  = math.floor(SystemInfo.getAvailableMemory() / 1024) -- 单位MB
	local threshold			= math.floor(SystemInfo.getThreshold() / 1024) 		 -- 单位MB

	local param = _address_param ..
			"&type=gameinfo" ..
			"&userid=" .. user_id ..
			"&gameinfo=open_app" ..
			"&kingdom=1" ..
			"&gameinfo_time=" .. date .. ' ' .. time ..
			-- "&gameinfo_time=" .. time ..
			"&value=" .. times ..
			"&platform=" .. download_from ..
			"&channel=" .. chanel_id ..
			"&extra=download_from:" .. download_from .. 
			",ava_memory:" .. available_memory ..
			",threshold:" .. threshold

	BISystem:send_log(_log_server_address, param)
	BISystem:send_log(BISystem.local_url, param)
	-- ZXLog("BI open_app memory used: " .. available_memory .. ", " .. threshold)
	
	CCUserDefault:sharedUserDefault():setIntegerForKey("open_app", times)
end

-- 记录热更版本检查
-- @phylum : start / ok / fail
function BISystem:update_check( phylum )
	-- print("火影BI打点步骤二检测---------->>>>>>>>> BISystem:open_app()",phylum)
	local user_id = CCUserDefault:sharedUserDefault():getStringForKey("user_id")
	if user_id == '' then
		----print("user default has not user id!")
		return
	end	

	local times = CCUserDefault:sharedUserDefault():getIntegerForKey("update_check_" .. phylum) or 0
	times = times + 1

	local download_from = BISystem:getDownloadFrom() or ""  -- 平台
	local chanel_id = BISystem:getDownloadChannel()	or ""	-- 渠道号
	-- local date, time = string.match(os.date(), "(%Z+) (%Z+)")
	local date = os.date("%Y-%m-%d")
	local time = os.date("%H:%M:%S")

	local param = _address_param ..
			"&type=gameinfo" ..
			"&userid=" .. user_id ..
			"&gameinfo=update_check" ..
			"&kingdom=2" .. 
			"&phylum=" .. phylum ..
			-- "&gameinfo_date=" .. date ..
			"&gameinfo_time=" .. date .. ' ' .. time ..
			"&value=" .. times ..
			"&platform=" .. download_from ..
			"&channel=" .. chanel_id ..
			"&extra=download_from:" .. download_from

	BISystem:send_log(_log_server_address, param)
	BISystem:send_log(BISystem.local_url, param)

	CCUserDefault:sharedUserDefault():setIntegerForKey("update_check_" .. phylum, times)
end

-- 记录进入登录页面
function BISystem:login_page(  )
	-- print("火影BI打点步骤三检测---------->>>>>>>>> BISystem:login_page()")
	local user_id = CCUserDefault:sharedUserDefault():getStringForKey("user_id")
	if user_id == '' then
		----print("user default has not user id!")
		return
	end	

	local times = CCUserDefault:sharedUserDefault():getIntegerForKey("login_page") or 0
	times = times + 1

	local download_from = BISystem:getDownloadFrom() or ""  -- 平台
	local chanel_id = BISystem:getDownloadChannel()	or ""	-- 渠道号
	-- local date, time = string.match(os.date(), "(%Z+) (%Z+)")
	local date = os.date("%Y-%m-%d")
	local time = os.date("%H:%M:%S")

	local param = _address_param ..
			"&type=gameinfo" ..
			"&userid=" .. user_id ..
			"&gameinfo=login_page" ..
			"&kingdom=3" .. 
			-- "&gameinfo_date=" .. date ..
			"&gameinfo_time=" .. date .. ' ' .. time ..
			"&value=" .. times ..
			"&platform=" .. download_from ..
			"&channel=" .. chanel_id ..
			"&extra=download_from:" .. download_from

	BISystem:send_log(_log_server_address, param)
	BISystem:send_log(BISystem.local_url, param)

	CCUserDefault:sharedUserDefault():setIntegerForKey("login_page", times)
end

-- 记录注册
function BISystem:register(  )
	local user_id = CCUserDefault:sharedUserDefault():getStringForKey("user_id")
	if user_id == '' then
		----print("user default has not user id!")
		return
	end	

	local times = CCUserDefault:sharedUserDefault():getIntegerForKey("register") or 0
	times = times + 1

	local download_from = BISystem:getDownloadChannel() or ""  -- 平台
	-- local date, time = string.match(os.date(), "(%Z+) (%Z+)")
	local date = os.date("%Y-%m-%d")
	local time = os.date("%H:%M:%S")

	local param = _address_param ..
			"&type=gameinfo" ..
			"&userid=" .. user_id ..
			"&gameinfo=register" ..
			"&kingdom=4" .. 
			"&gameinfo_date=" .. date ..
			"&gameinfo_time=" .. time ..
			"&value=" .. times ..
			"&extra=download_from:" .. download_from

	BISystem:send_log(_log_server_address, param)
	BISystem:send_log( BISystem.local_url, param )

	CCUserDefault:sharedUserDefault():setIntegerForKey("register", times)
end

-- 记录一键登录次数
function BISystem:fat_register(  )
	-- print("火影BI打点步骤四检测---------->>>>>>>>> BISystem:fat_register()")
	local user_id = CCUserDefault:sharedUserDefault():getStringForKey("user_id")
	if user_id == '' then
		--print("user default has not user id!")
		return
	end	

	local times = CCUserDefault:sharedUserDefault():getIntegerForKey("fat_register") or 0
	times = times + 1

	local download_from = BISystem:getDownloadFrom() or ""  -- 平台
	local chanel_id = BISystem:getDownloadChannel()	or ""	-- 渠道号
	-- local date, time = string.match(os.date(), "(%Z+) (%Z+)")
	local date = os.date("%Y-%m-%d")
	local time = os.date("%H:%M:%S")

	local param = _address_param ..
			"&type=gameinfo" ..
			"&userid=" .. user_id ..
			"&gameinfo=fat_register" ..
			"&kingdom=4" .. 
			-- "&gameinfo_date=" .. date ..
			"&gameinfo_time=" .. date .. ' ' .. time ..
			"&value=" .. times ..
			"&platform=" .. download_from ..
			"&channel=" .. chanel_id ..
			"&extra=download_from:" .. download_from

	BISystem:send_log(_log_server_address, param)
	BISystem:send_log(BISystem.local_url, param)

	CCUserDefault:sharedUserDefault():setIntegerForKey("fat_register", times)
end

-- 记录登录
function BISystem:login()
	-- print("火影BI打点步骤五检测---------->>>>>>>>> BISystem:login()",BISystem.local_url)
	local user_id = CCUserDefault:sharedUserDefault():getStringForKey("user_id")
	if user_id == '' then
		--print("user default has not user id!")
		return
	end	

	local times = CCUserDefault:sharedUserDefault():getIntegerForKey("login") or 0
	times = times + 1

	local download_from = BISystem:getDownloadFrom() or ""  -- 平台
	local chanel_id = BISystem:getDownloadChannel()	or ""	-- 渠道号
	-- local date, time = string.match(os.date(), "(%Z+) (%Z+)")
	local date = os.date("%Y-%m-%d")
	local time = os.date("%H:%M:%S")

	local param = _address_param ..
			"&type=gameinfo" ..
			"&userid=" .. user_id ..
			"&gameinfo=login" ..
			"&kingdom=5" .. 
			-- "&gameinfo_date=" .. date ..
			"&gameinfo_time=" .. date .. ' ' .. time ..
			"&value=" .. times ..
			"&platform=" .. download_from ..
			"&channel=" .. chanel_id ..
			"&extra=download_from:" .. download_from

	BISystem:send_log(_log_server_address, param)
	BISystem:send_log(BISystem.local_url, param)

	CCUserDefault:sharedUserDefault():setIntegerForKey("login", times)
end

-- 记录进入选服界面
function BISystem:server_choice(  )
	-- print("火影BI打点步骤六检测---------->>>>>>>>> BISystem:server_choice()",BISystem.local_url)
	local user_id = CCUserDefault:sharedUserDefault():getStringForKey("user_id")
	if user_id == '' then
		--print("user default has not user id!")
		return
	end	

	local times = CCUserDefault:sharedUserDefault():getIntegerForKey("server_choice") or 0
	times = times + 1

	local download_from = BISystem:getDownloadFrom() or ""  -- 平台
	local chanel_id = BISystem:getDownloadChannel()	or ""	-- 渠道号
	-- local date, time = string.match(os.date(), "(%Z+) (%Z+)")
	local date = os.date("%Y-%m-%d")
	local time = os.date("%H:%M:%S")

	local param = _address_param ..
			"&type=gameinfo" ..
			"&userid=" .. user_id ..
			"&gameinfo=server_choice" ..
			"&kingdom=6" .. 
			"&phylum=start" ..
			-- "&gameinfo_date=" .. date ..
			"&gameinfo_time=" .. date .. ' ' .. time ..
			"&value=" .. times ..
			"&platform=" .. download_from ..
			"&channel=" .. chanel_id ..
			"&extra=download_from:" .. download_from

	local login_info = RoleModel:get_login_info()
	if login_info and login_info.server_id ~= nil then
		param = param .. "&serverid=" .. login_info.server_id
	end

	BISystem:send_log(_log_server_address, param)
	BISystem:send_log(BISystem.local_url, param)

	CCUserDefault:sharedUserDefault():setIntegerForKey("server_choice", times)
end

-- 记录玩家点击角色创建界面的开始按钮的用户数量
function BISystem:actor_choice(  )
	-- print("火影BI打点步骤七检测---------->>>>>>>>> BISystem:actor_choice()",BISystem.local_url)
	local user_id = CCUserDefault:sharedUserDefault():getStringForKey("user_id")
	if user_id == '' then
		--print("user default has not user id!")
		return
	end	

	local times = CCUserDefault:sharedUserDefault():getIntegerForKey("actor_choice") or 0
	times = times + 1

	local download_from = BISystem:getDownloadFrom() or ""  -- 平台
	local chanel_id = BISystem:getDownloadChannel()	or ""	-- 渠道号
	-- local date, time = string.match(os.date(), "(%Z+) (%Z+)")
	local date = os.date("%Y-%m-%d")
	local time = os.date("%H:%M:%S")

	local param = _address_param ..
			"&type=gameinfo" ..
			"&userid=" .. user_id ..
			"&gameinfo=actor_choice" ..
			"&kingdom=7" .. 
			"&phylum=start" ..
			-- "&gameinfo_date=" .. date ..
			"&gameinfo_time=" .. date .. ' ' .. time ..
			"&value=" .. times ..
			"&platform=" .. download_from ..
			"&channel=" .. chanel_id ..
			"&extra=download_from:" .. download_from

	local login_info = RoleModel:get_login_info()
	if login_info.server_id ~= nil then
		param = param .. "&serverid=" .. login_info.server_id
	end

	BISystem:send_log(_log_server_address, param)
	BISystem:send_log(BISystem.local_url, param)

	CCUserDefault:sharedUserDefault():setIntegerForKey("actor_choice", times)
end

-- 记录玩家请求进入游戏时，显示loading界面的情况
function BISystem:enter_game_scene(  )
	-- print("火影BI打点步骤七检测---------->>>>>>>>> BISystem:actor_choice()",BISystem.local_url)
	local user_id = CCUserDefault:sharedUserDefault():getStringForKey("user_id")
	if user_id == '' then
		--print("user default has not user id!")
		return
	end	

	local download_from = BISystem:getDownloadFrom() or ""  -- 平台
	local chanel_id = BISystem:getDownloadChannel()	or ""	-- 渠道号
	-- local date, time = string.match(os.date(), "(%Z+) (%Z+)")
	local date = os.date("%Y-%m-%d")
	local time = os.date("%H:%M:%S")

	local param = _address_param ..
			"&type=gameinfo" ..
			"&userid=" .. user_id ..
			"&gameinfo=enter_game_scene" ..
			"&kingdom=7" .. 
			"&phylum=start" ..
			-- "&gameinfo_date=" .. date ..
			"&gameinfo_time=" .. date .. ' ' .. time ..
			"&value=" .. 
			"&platform=" .. download_from ..
			"&channel=" .. chanel_id ..
			"&extra=download_from:" .. download_from

	local login_info = RoleModel:get_login_info()
	if login_info and login_info.server_id ~= nil then
		param = param .. "&serverid=" .. login_info.server_id
	end

	BISystem:send_log(_log_server_address, param)
	BISystem:send_log(BISystem.local_url, param)

end

function BISystem:enter_welcome_win(  )
	local user_id = CCUserDefault:sharedUserDefault():getStringForKey("user_id")
	if user_id == '' then
		--print("user default has not user id!")
		return
	end	

	local download_from = BISystem:getDownloadFrom() or ""  -- 平台
	local chanel_id = BISystem:getDownloadChannel()	or ""	-- 渠道号
	-- local date, time = string.match(os.date(), "(%Z+) (%Z+)")
	local date = os.date("%Y-%m-%d")
	local time = os.date("%H:%M:%S")

	local param = _address_param ..
			"&type=gameinfo" ..
			"&userid=" .. user_id ..
			"&gameinfo=enter_welcome_win" ..
			"&kingdom=7" .. 
			"&phylum=start" ..
			-- "&gameinfo_date=" .. date ..
			"&gameinfo_time=" .. date .. ' ' .. time ..
			"&value=" .. 
			"&platform=" .. download_from ..
			"&channel=" .. chanel_id ..
			"&extra=download_from:" .. download_from

	local login_info = RoleModel:get_login_info()
	if login_info and login_info.server_id ~= nil then
		param = param .. "&serverid=" .. login_info.server_id
	end

	BISystem:send_log(_log_server_address, param)
	BISystem:send_log(BISystem.local_url, param)

end

function BISystem:click_welcome_win(  )
	local user_id = CCUserDefault:sharedUserDefault():getStringForKey("user_id")
	if user_id == '' then
		--print("user default has not user id!")
		return
	end	

	local download_from = BISystem:getDownloadFrom() or ""  -- 平台
	local chanel_id = BISystem:getDownloadChannel()	or ""	-- 渠道号
	-- local date, time = string.match(os.date(), "(%Z+) (%Z+)")
	local date = os.date("%Y-%m-%d")
	local time = os.date("%H:%M:%S")

	local param = _address_param ..
			"&type=gameinfo" ..
			"&userid=" .. user_id ..
			"&gameinfo=click_welcome_win" ..
			"&kingdom=7" .. 
			"&phylum=start" ..
			-- "&gameinfo_date=" .. date ..
			"&gameinfo_time=" .. date .. ' ' .. time ..
			"&value=" .. 
			"&platform=" .. download_from ..
			"&channel=" .. chanel_id ..
			"&extra=download_from:" .. download_from

	local login_info = RoleModel:get_login_info()
	if login_info and login_info.server_id ~= nil then
		param = param .. "&serverid=" .. login_info.server_id
	end

	BISystem:send_log(_log_server_address, param)
	BISystem:send_log(BISystem.local_url, param)

end

-- 出错记录
function BISystem:error_bi( error_place, error_type, account_id )
	local user_id = CCUserDefault:sharedUserDefault():getStringForKey("user_id")
	if user_id == nil then
		print("user default has not user id!")
		user_id = _default_user_id
	end	

	local download_from = BISystem:getDownloadChannel(  ) or ""  -- 平台
	-- local date, time = string.match(os.date(), "(%Z+) (%Z+)")
	local date = os.date("%Y-%m-%d")
	local time = os.date("%H:%M:%S")

	local account_id_temp = ""
	if account_id then 
        account_id_temp = ",account_id:" .. account_id
	end

	local param = _address_param ..
			"&type=gameinfo" ..
			"&userid=" .. user_id ..
			"&gameinfo=loading_fail" ..
			"&kingdom=" .. error_place ..
			"&phylum=" .. error_type ..
			"&gameinfo_date=" .. date ..
			"&gameinfo_time=" .. time ..
			"&extra=download_from:" .. download_from .. account_id_temp

	BISystem:send_log(_log_server_address, param)
	BISystem:send_log( BISystem.local_url, param )
end

function BISystem:create_role(ntype)
	-- print("火影BI打点步骤七检测---------->>>>>>>>> BISystem:actor_choice()",BISystem.local_url)
	local user_id = CCUserDefault:sharedUserDefault():getStringForKey("user_id")
	if user_id == '' then
		--print("user default has not user id!")
		return
	end	

	local times = CCUserDefault:sharedUserDefault():getIntegerForKey("actor_choice") or 0
	times = times + 1

	local download_from = BISystem:getDownloadFrom() or ""  -- 平台
	local chanel_id = BISystem:getDownloadChannel()	or ""	-- 渠道号
	-- local date, time = string.match(os.date(), "(%Z+) (%Z+)")
	local date = os.date("%Y-%m-%d")
	local time = os.date("%H:%M:%S")

	local param = _address_param ..
			"&type=gameinfo" ..
			"&userid=" .. user_id ..
			"&gameinfo=create_role" ..
			"&kingdom=7" .. 
			"&phylum=" .. ntype ..
			-- "&gameinfo_date=" .. date ..
			"&gameinfo_time=" .. date .. ' ' .. time ..
			"&value=" .. times ..
			"&platform=" .. download_from ..
			"&channel=" .. chanel_id ..
			"&extra=download_from:" .. download_from

	local login_info = RoleModel:get_login_info()
	if login_info.server_id ~= nil then
		param = param .. "&serverid=" .. login_info.server_id
	end

	BISystem:send_log(_log_server_address, param)
	BISystem:send_log(BISystem.local_url, param)

end

-- 第一次进入loading界面前的打点
function BISystem:enter_init_game()
	-- print("火影BI打点步骤一检测---------->>>>>>>>> BISystem:open_app()")
	local user_id = CCUserDefault:sharedUserDefault():getStringForKey("user_id")
	if user_id == '' then
		----print("user default has not user id!")
		return
	end

	local download_from = BISystem:getDownloadFrom() or ""  -- 平台
	local chanel_id = BISystem:getDownloadChannel()	or ""	-- 渠道号
	-- local date, time = string.match(os.date(), "(%Z+) (%Z+)")
	local date = os.date("%Y-%m-%d")
	local time = os.date("%H:%M:%S")
	local param = _address_param ..
			"&type=gameinfo" ..
			"&userid=" .. user_id ..
			"&gameinfo=enter_init_game" ..
			"&kingdom=1" ..
			"&gameinfo_time=" .. date .. ' ' .. time ..
			-- "&gameinfo_time=" .. time ..
			"&value=" .. 
			"&platform=" .. download_from ..
			"&channel=" .. chanel_id ..
			"&extra="

	BISystem:send_log(_log_server_address, param)
	BISystem:send_log(BISystem.local_url, param)

end

-- 创建角色时点击昵称骰子产生随机名字
function BISystem:click_role_name_dice()
	-- print("火影BI打点步骤一检测---------->>>>>>>>> BISystem:click_role_name_dice()")
	local user_id = CCUserDefault:sharedUserDefault():getStringForKey("user_id")
	if user_id == '' then
		----print("user default has not user id!")
		return
	end

	local download_from = BISystem:getDownloadFrom() or ""  -- 平台
	local chanel_id = BISystem:getDownloadChannel()	or ""	-- 渠道号
	-- local date, time = string.match(os.date(), "(%Z+) (%Z+)")
	local date = os.date("%Y-%m-%d")
	local time = os.date("%H:%M:%S")
	local param = _address_param ..
			"&type=gameinfo" ..
			"&userid=" .. user_id ..
			"&gameinfo=role_name_dice" ..
			"&kingdom=1" ..
			"&gameinfo_time=" .. date .. ' ' .. time ..
			-- "&gameinfo_time=" .. time ..
			"&value=" .. 
			"&platform=" .. download_from ..
			"&channel=" .. chanel_id ..
			"&extra="

	BISystem:send_log(_log_server_address, param)
	BISystem:send_log(BISystem.local_url, param)

end


function BISystem:enterGame(ntype)
	-- print("火影BI打点步骤七检测---------->>>>>>>>> BISystem:actor_choice()",BISystem.local_url)
	local user_id = CCUserDefault:sharedUserDefault():getStringForKey("user_id")
	if user_id == '' then
		--print("user default has not user id!")
		return
	end	

	local times = CCUserDefault:sharedUserDefault():getIntegerForKey("actor_choice") or 0
	times = times + 1

	local download_from = BISystem:getDownloadFrom() or ""  -- 平台
	local chanel_id = BISystem:getDownloadChannel()	or ""	-- 渠道号
	-- local date, time = string.match(os.date(), "(%Z+) (%Z+)")
	local date = os.date("%Y-%m-%d")
	local time = os.date("%H:%M:%S")

	local param = _address_param ..
			"&type=gameinfo" ..
			"&userid=" .. user_id ..
			"&gameinfo=enter_game" ..
			"&kingdom=7" .. 
			"&phylum=" .. ntype ..
			-- "&gameinfo_date=" .. date ..
			"&gameinfo_time=" .. date .. ' ' .. time ..
			"&value=" .. times ..
			"&platform=" .. download_from ..
			"&channel=" .. chanel_id ..
			"&extra=download_from:" .. download_from

	local login_info = RoleModel:get_login_info()
	if login_info.server_id ~= nil then
		param = param .. "&serverid=" .. login_info.server_id
	end

	BISystem:send_log(_log_server_address, param)
	BISystem:send_log(BISystem.local_url, param)
end

-- 获取Bi download_from 字段
function BISystem:getDownloadFrom(  )
	return PlatformInfoForBISystem:getDownloadFrom()
end

-- 获取平台 分渠道 字段
function BISystem:getDownloadChannel(  )
	return PlatformInfoForBISystem:getDownloadChannel()
end
