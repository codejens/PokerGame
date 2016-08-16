-- GameStateManager.lua
-- created by aXing on 2012-11-14
-- 这是一个管理游戏状态的类
-- 用于定义以及处理各种游戏状态间的转换过程，包括构造以及析构
-- 注意一定不能随意地在GameStateManager.lua文件一开始随意添加require文件
require "model/IOSDispatcher"
require "utils/ConnectionChecker"

super_class.GameStateManager()

-- 玩家心跳计数，判断是否已经断开连接。每次收到服务器心跳包，把该值设置为0，当超过一定值，就发送确认协议
-- bi 打点时间
local _bi_record 			= 0

local STRING_BTN_QUIT = LangCommonString[81] -- [2]="退出"
local STRING_BTN_CLOSE = "关闭" 			
local STRING_BTN_LOGOUT = LangCommonString[10] -- [10]="确定"
local STRING_NO_NETWORK = { LangCommonString[11], LangCommonString[12] }  -- [11]="#c4d2308已经和服务器断开连接" -- [12]="#c4d2308请重新连接"
local STRING_CANCEL = LangCommonString[3] -- [3]="取消"
local STRING_LEAVE = { "#c4f2205您确定要返回登录界面吗?" }  -- [13]="#cfff5f0您需要返回到登录界面吗？" -- [14]="#cfff5f0点击确定" -- [15]="#c4d2308返回到登录界面"
local STRING_QUIT =  { LangCommonString[4] }  -- [4]="#cfff5f0您需要退出游戏吗" -- [5]="#cffc80e点击退出" -- [6]="#cfff5f0退出游戏"
local DialogDepth = 80000

local os_time = os.time
---- 私有函数

local _login_timer = nil

local _ZXGameQuit = ZXGameQuit
ZXGameQuit = function()
	MenusPanel:use_all_equip_tip( )
	_ZXGameQuit()
end

local function split(szFullString, szSeparator)  
    local nFindStartIndex = 1  
    local nSplitIndex = 1  
    local nSplitArray = {}  
    while true do  
       local nFindLastIndex = string.find(szFullString, szSeparator, nFindStartIndex)  
       if not nFindLastIndex then  
        nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, string.len(szFullString))  
        break  
       end  
       nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, nFindLastIndex - 1)  
       nFindStartIndex = nFindLastIndex + string.len(szSeparator)  
       nSplitIndex = nSplitIndex + 1  
    end  
    return nSplitArray  
end 


-- 发送手机信息
local function send_phone_info(  )
	if GetPlatform() == CC_PLATFORM_IOS then
		-- 获取设备信息
		local device_info = IOSDispatcher:get_device_info( )
		if device_info then
			local phone_mark = device_info["deviceVer"]             -- 手机名称
			local phone_version = device_info["iOSVer"]             -- 手机系统号
			local platform = BISystem:getDownloadFrom()				-- 平台
			local winSize = ZXgetWinSize()
			local width = winSize.width or 0
			local height = winSize.height or 0
			local resolution_ratio_str = width .. "*" .. height
			local udid = device_info["identifier"]
			local chanel_id = BISystem:getDownloadChannel()         --渠道id
			local client_version = CCVersionConfig:sharedVersionConfig():getStringForKey("current_version")
			
			
			MiscCC:request_send_phone_info( phone_mark, 
											phone_version,
											platform,
											resolution_ratio_str, 
											"UNKNOWN",
											"UNKNOWN",
											udid ,
											chanel_id,
											client_version )

		else
			MiscCC:request_send_phone_info( "", "", "", "", "","", "", "", "")
		end
	else
		local phone_state = GetPhoneState()
		local phone_info_t = split( phone_state,",")          -- 逗号分割，在java层定义的规约
		local phone_mark = phone_info_t[1] or ""              -- 手机名称
		local phone_version = phone_info_t[2] or ""           -- 手机系统号
		local platform = BISystem:getDownloadFrom()			  -- 平台
		local winSize = ZXgetWinSize()
		local width = winSize.width or 0
		local height = winSize.height or 0
		local resolution_ratio_str = width .. "*" .. height
		local udid = GetSerialNumber()		-- 如果可以获取手机序列号用作udid
		local chanel_id = BISystem:getDownloadChannel()                --渠道id
		local client_version = CCVersionConfig:sharedVersionConfig():getStringForKey("current_version")

		-- --print("!!!!!!!!!!!!!!!!!!!!!!!!!~~~~~~~=======@@@@@@@手机信息 ", phone_state, "&", phone_mark, "&", phone_version, "&", platform, resolution_ratio_str )

		--local network_state = NetManager.strISP .. "_" .. NetManager.strNetType
		----print(">>>>>>> network_state", network_state)
	    MiscCC:request_send_phone_info( phone_mark, 
	    								phone_version, 
	    								platform,--platform, 
	    								resolution_ratio_str,
	    								NetManager.strISP,
	    								NetManager.strNetType ,
	    								udid,
	    								chanel_id,-- chanel_id,
	    								client_version)
	end
	
end

-- 游戏更新状态
local function update_enter(  )
	
end

local function update_leave(  )
	
end
local _is_first_enter_login_view = true --这里主要解决ios平台登录的问题，安卓其实直接通知平台进入登录状态即可
-- 登录状态
local function login_enter(...)
	require "ForceUpdateMgr"
	require "UI/UI_Utilities"
	if ForceUpdateMgr:needUpdate() then
		ForceUpdateMgr:doUpdate()
		return
	else
		-- SystemInfo.showMemoryState()
		-- UI_Utilities.CreateFixButton()
		-- UI_Utilities.CreateResourceFixButton()
		-- UI_Utilities.CreateAdButton()
		RoleModel:show_login_win(GameStateManager:get_game_root())
		local is_back, not_login = ...
		if is_back then
			RoleModel:change_login_page("new_select_server_page")
			if Target_Platform == Platform_Type.NOPLATFORM then
				PlatformInterface:reNewServerList()
			else
				RoleModel:request_server_list_platform(true)
			end
		else
			if PlatformInterface.onEnterLoginState then
				if Target_Platform == Platform_Type.NOPLATFORM then
					RoleModel:change_login_page("login")
					local is_show_notice = UpdateManager:get_bool_show_notice()
					if is_show_notice == true then
						local login = RoleModel:get_login_win()
						if login then
							login:widgetVisible(false)
						end
						local c = callback:new()
						c:start(0.11, function()
							RoleModel:change_login_page("notice")
						end)
					end
				else
					RoleModel:change_login_page("login_platform")
				end
				if not_login == nil then
					PlatformInterface:onEnterLoginState()
				end
			end
		end
		--记录进入登录界面了
		if BISystem.login_page then
			BISystem:login_page()
		end
	end
	--10发送一次登录心跳
	local function login_tick()
		SelectRoleCC:second_tick()
	end
	if _login_timer then
		_login_timer:stop()
		_login_timer = nil
	end
	_login_timer = timer()
	_login_timer:start(10, login_tick)
end

local function login_leave()
	--销毁登录界面
	RoleModel:destroy_login_win()	
	UI_Utilities.DestroyFixButton()
	UI_Utilities.DestroyResourceButton()
	UI_Utilities.DestroyAdButton()
end

--游戏初始化模块
local function loading_enter()
	--打开主游戏初始化模块界面
	ResourceManager:init_game()
end

local function loading_leave()
	if SceneLoadingWin then
		SceneLoadingWin:destroy_instance()
	end
end

-- 选择角色
local function choose_enter()
	-- -- 尝试申请角色列表
	-- require "control/SelectRoleCC"
	-- SelectRoleCC:request_role_list()
end

local function choose_leave()
    -- UIManager:destroy_window("select_role")
end

local firstEnterScene = true
-- 游戏场景
local function scene_enter()
	--停掉登录心跳
	_login_timer:stop()

	-- 以下的初始化顺序是根据节点生成次序定义的，不能修改
	-- 先渲染场景，然后渲染实体，最后渲染UI
	ConnectionChecker:init()

	-- if phone_showProgress then
	-- 	phone_showProgress(LangCommonString[16],LangCommonString[17],true,false) -- [16]="请稍候" -- [17]="初始化游戏"
	-- end

	local root = GameStateManager:get_game_root()

	--SceneLoadingWin:show_instance(nil,100,100)
	-- 初始化UI节点模块
	UIManager:init(root)				-- 初始化UI
	-- 初始化场景节点模块
	-- require "scene/SceneManager"
	SceneManager:init(root)				-- 初始化场景系统
	-- 初始化场景实体节点模块
	-- require "entity/EntityManager"
	EntityManager:init(root)			-- 初始化游戏实体
	
	-- 先显示loading界面，盖住地图
	--SceneLoadingWin:show_instance()

	-- 进入游戏场景才初始化AI
	-- require "AI/AIManager"
	AIManager:init()

	-- 开始游戏心跳
	GameStateManager:start_game_tick()

    --获取装备列表
	-- require "control/UserEquipCC"
    UserEquipCC:request_get_equi()

    -- 请求下发商城，限制产品列表
    --MallModel:request_time_limit_item(  ) -- 限制产品

    -- 获取玩家帮派信息
    -- require "control/GuildCC"
    GuildCC:request_self_guild_info()

    -- 活动界面相关数据
    -- ActivityModel:request_enter_fuben_times( )
    FubenExtCC:req_fuben_num()						-- 山海经添加，上面的遗弃(副本次数)
    
    ItemModel:init_bag()

    --成就系统数据请求
   	AchieveCC:request_achieve_info()

   	-- 请求设置系统
   	SetSystemModel:request_set_date()
   	
   	UserSkillCC:request_skill_list()
   	-- 初始化变身系统
   	-- 服务器在登录的时候自动下发，不需要主动申请 by yongrui.liang 14/6/16
   	-- TransformModel:init()

   	-- 请求当前生效通缉
	WantedCC:ReqCurAccWanted(  )

   	UIManager:setupMainUI()
--	require "control/UserSkillCC"
--	UserSkillCC:request_skill_list()

	--请求 无限飞行体验剩余时间
	VIPCC:req_taste_teleport_time( )

	--请求演武场商店数据
	DouFaTaiCC:req_renownshop_info()

	if PlatformInterface.getLoginRet then
		local openid = PlatformInterface:getLoginRet()
		if openid then
			local InstallChannel = PlatformInterface.InstallChannel
--TODO 要改协议！支持字符串类型的channel
			if tonumber(InstallChannel) then
				OnlineAwardCC:request_get_platform_award(tonumber(InstallChannel),openid)
			end
		end
	end
	
    send_phone_info(  )

    -- ResourceManager:EnterGameWorld()

    -- 获取登录天数信息
    -- OnlineAwardCC:req_login_benefit()
    
    MUtils.delay_phone_hideProgress(0.5)

	--通知平台已进入游戏场景
	if PlatformInterface.onEnterGameScene then
		PlatformInterface:onEnterGameScene(true)
	end
end 

local function scene_leave()
	--print("scene_leave")

	--使用新物品提示的所有装备
	--MenusPanel:use_all_equip_tip( )

	ConnectionChecker:fini()

	Cinema:fini()
	
	-- 析构BI系统
	EventSystem.quit()

	Analyze:fini()

	-- Instruction:scene_leave()
	-- 停止AI
	AIManager:fini( )
	
	--场景特效清空
	SceneEffectManager:quitScene()

	fini_http_request()

	-- 隐藏全部窗口
	UIManager:hide_all_window()

	-- 隐藏摇杆
	JoystickManager:set_visible(false)

	-- 清空实体
	EntityManager:remove_all_entity()
	-- 清空场景
	SceneManager:fini()
	-- 析构model
	fini_model()
	-- 内存清理
	ResourceManager:set_resource_dirty()
	-- 取消所有callback
	callback.scene_leave()
	-- 取消所有timer
	_timer.scene_leave()

	--通知平台已离开游戏场景
	if PlatformInterface.onEnterGameScene then
		PlatformInterface:onEnterGameScene(false)
	end
end 


---- 私有成员
local _current_state = nil		-- 当前的游戏状态

local GAME_STATE = {
	update  = {enter = update_enter, 	leave = update_leave},		-- 在线更新状态
	loading = {enter = loading_enter, 	leave = loading_leave},		-- 初始化游戏模块
	login 	= {enter = login_enter,  	leave = login_leave},		-- 登录状态
	choose 	= {enter = choose_enter,	leave = choose_leave},		-- 选择角色
	scene 	= {enter = scene_enter,  	leave = scene_leave},		-- 游戏场景
}

-- 整个游戏的根节点
local _game_root = nil			
-- 客户端生存周期，运行了多少秒
local _game_total_seconds = 0
-- 客户端生存周期，运行了多少毫秒
local _game_total_millisecond = 0


---- 公有函数
-- 游戏初始化
function GameStateManager:init(root)
	reload "UI/UIScreenPos"
	reload "utils/MUtils"
	_game_root = root
	luaPerformance:start()
end

-- 获取整个游戏的根节点
function GameStateManager:get_game_root(  )
	return _game_root
end

--切换不同的游戏状态
--state 只能是 "login", "choose", "scene", ...
function GameStateManager:set_state(state, ...)
	if GAME_STATE[state] == nil then
		return false
	end
	--如果存在上个状态，则需要调用上个状态的析构
	if _current_state ~= nil then
		GAME_STATE[_current_state].leave()
		_current_state = nil
	end
	_current_state = state
	GAME_STATE[state].enter(...)
	require "PowerCenter"
	if PowerCenter and PowerCenter.setMode then
		PowerCenter:setMode(state)
	end
	return true
end

-- 获取当前游戏状态
function GameStateManager:get_state()
	return _current_state
end


-- 开始游戏心跳
function GameStateManager:start_game_tick(  )

	if self.gameticktimer ~= nil then
		self.gameticktimer:stop()
	end

	-- 注册游戏每帧的心跳
	-- 游戏每帧心跳
	local function tick( dt )
		_game_total_millisecond = _game_total_millisecond + dt
		-- 检查是否需要gc
		ResourceManager:garbage_collection()
		local ds = _game_total_millisecond - _game_total_seconds
		if ds >= 1 then
			GameStateManager:second_tick(ds)

		end
		print_sys_info(dt)
		--下载器检测
		DownloaderLua:tryDownloadTick( dt )
	end
	self.gameticktimer = timer()
	self.gameticktimer:start_global(t_gsm_,tick)
end

-- 停止游戏心跳
function GameStateManager:stop_game_tick(  )
	if self.gameticktimer ~= nil then
		self.gameticktimer:stop()
		self.gameticktimer = nil
	end
end

-- 获取客户端一开始到现在已经过去了多少秒
function GameStateManager:get_total_seconds(  )
	return _game_total_seconds
end

function GameStateManager:set_total_seconds_zero( )
	_game_total_seconds = 0
	_game_total_millisecond = 0
end

-- 获取客户端一开始到现在已经过去了多少毫秒
function GameStateManager:get_total_milliseconds(  )
	return _game_total_millisecond * 1000
end

-- 游戏每秒心跳
function GameStateManager:second_tick( ds )
	
	_game_total_seconds = _game_total_seconds + ds

	-- 这里以后只会用于逻辑计数上面的心跳
	-- 每个界面上面的特效应有每个界面负责tick，并处理界面关闭时把tick关掉
	GameStateManager:connect_check( ds )

	-- added by aXing on 2013-6-3
	-- 添加网络流量的BI打点，10分钟一次
	_bi_record = _bi_record + ds
	if _bi_record > 600 then
		require "analyze/Analyze"
		Analyze:BI_proto()
		_bi_record = 0
	end

end

-- 连接检查
function GameStateManager:connect_check( ds )
	-- 连接检查计数
	----print(ds)
	ConnectionChecker:tick()
end

-- 收到任何一个包
-- 重置连接检查计数
-- 重置在线flag
-- 重置弹框timer
function GameStateManager:reset_connect_check_count(  )
	ConnectionChecker:setIsOnline()
end

-- 发送协议检查连接
-- 从后台切换回前台后立刻检查是否在线
-- AppGameMessages:OnEnterForeground(...)
-- 每隔一段时间检查是否在线
-- GameStateManager:connect_check( ds )
function GameStateManager:request_check_online()
	ConnectionChecker:request_check_online()
end

-- 服务器确认还在线的回调
function GameStateManager:server_confirm_online(  )
	----print("服务器确认还在线的回调...", os.clock(), _online_flag)
	--收包的时候就重置过了
	GameStateManager:reset_connect_check_count(  )
end

function GameStateManager:do_lost_connect()
 	-- self:set_state("login")
 	if WorldBossModel then
 		WorldBossModel:set_check_flag(false)
	end
	if MenusPanel then
		MenusPanel:use_all_equip_tip()
	end
	if AudioManager then
		AudioManager:stopBackgroundMusic(true)
	end
	if MiscCC then
 		MiscCC:send_quit_server()
 	end
 	self:set_state("login")
	if GetPlatform() == CC_PLATFORM_IOS then
		if IOSDispatcher then
			IOSDispatcher:IAP_remove_observer()
		end
	elseif GetPlatform() == CC_PLATFORM_ANDROID then
	elseif GetPlatform() == CC_PLATFORM_WIN32 then	
	end
 	self.modalPop = nil
end

function GameStateManager:lost_connect()

	--如果这个时候在剧情中 要停掉剧情
	if SMovieClientModel:get_isMove(  ) then
		SMovieClientModel:end_movie(  )
		SMovieClientModel:set_isMove( false )
	end
	if self:get_state() ~= "scene" then
		return false
	end

	local function do_lost_connect()
		GameStateManager:do_lost_connect()
	end


	local _root = SceneManager.UIRoot

	-- if not PlatformInterface.logoutable then -- logoutable 这个字段没用 去掉判断
	-- 	if _root and not self.modalPop then
	-- 		self.modalPop = PopupNotify( _root,
	-- 								    DialogDepth, 
	-- 									PlatformInterface.disconnect_msg,
	-- 									STRING_BTN_CLOSE,STRING_BTN_QUIT,
	-- 									POPUP_YES_NO,
	-- 									function(state)
	-- 										if state then  
	-- 											return false
	-- 										else
	-- 											ZXGameQuit()
	-- 										end
	-- 									end,
	-- 									POPUPSIZE_EXIT_DIALOG)
	-- 	end
	-- else
		if _root and not self.modalPop then
			--[[
			self.modalPop = PopupNotify( _root,
									    DialogDepth, 
										STRING_NO_NETWORK,
										STRING_BTN_CLOSE,STRING_BTN_QUIT,
										POPUP_YES_NO,
										function(state)  
											if state then  
												return false
											else
												if PlatformInterface.lost_connect then
													PlatformInterface:lost_connect(do_lost_connect)
												else
													do_lost_connect()
												end
											end
										end,
										POPUPSIZE_EXIT_DIALOG)
]]--
			UI_Utilities.showReconnectDialog(true)
		end
	-- end

	return true
end

function GameStateManager:back_to_login()
	if self:get_state() ~= "scene" then
		return false
	end
	local _root = SceneManager.UIRoot
	local function do_back_to_login()
		WorldBossModel:set_check_flag(false)
		MenusPanel:use_all_equip_tip()
		AudioManager:stopBackgroundMusic(true)
		MiscCC:send_quit_server()
		self:set_state("login", true)
		if GetPlatform() == CC_PLATFORM_IOS then
			IOSDispatcher:IAP_remove_observer()
		elseif GetPlatform() == CC_PLATFORM_ANDROID then
		elseif GetPlatform() == CC_PLATFORM_WIN32 then	
		end
	end
	-- if not PlatformInterface.logoutable then    -- logoutable 这个字段没用 去掉判断
	-- 	if _root and not self.modalPop then
	-- 		local content = PlatformInterface.logout_content or STRING_LEAVE
	-- 		self.modalPop = PopupNotify(_root, DialogDepth, content, STRING_BTN_LOGOUT, STRING_CANCEL, POPUP_YES_NO,
	-- 								function(state)
	-- 									if state then  
	-- 										ZXGameQuit()
	-- 									end
	-- 									self.modalPop = nil
	-- 								end, POPUPSIZE_EXIT_DIALOG)
	-- 	end
	-- else
		if _root and not self.modalPop then
			local content = PlatformInterface.logout_content or STRING_LEAVE
			self.modalPop = PopupNotify(_root, DialogDepth, content, STRING_BTN_LOGOUT, STRING_CANCEL, POPUP_YES_NO,
									function(state)
										if state then
											do_back_to_login()
										end
										self.modalPop = nil
									end, POPUPSIZE_EXIT_DIALOG)
		end
	-- end
	self.modalPop:setIsVisible(true)
	return true
end

function GameStateManager:quit()
	
end

function GameStateManager:OnBackClick()
--@debug_begin
	phone_showStatus()
--@debug_end
	SystemInfo.showMemoryState()
	--强制清理内存
	ResourceManager:garbage_collection(true)
--	dump_texture()
--	local freeMem = collectgarbage("count")
--	--print("GC Count : " .. freeMem/1024 .. " MB")
end
