-- GameStateManager.lua
-- created by aXing on 2012-11-14
-- 这是一个管理游戏状态的类
-- 用于定义以及处理各种游戏状态间的转换过程，包括构造以及析构
require "model/IOSDispatcher"
require 'utils/ConnectionChecker'

super_class.GameStateManager()

-- 玩家心跳计数，判断是否已经断开连接。每次收到服务器心跳包，把该值设置为0，当超过一定值，就发送确认协议
-- bi 打点时间
local _bi_record 			= 0

local STRING_BTN_QUIT = LangCommonString[2] -- [2]='退出'
local STRING_BTN_CLOSE = "关闭" 			
local STRING_BTN_LOGOUT = LangCommonString[10] -- [10]='确定'
local STRING_NO_NETWORK = { LangCommonString[11], LangCommonString[12] }  -- [11]='#cffff00已经和服务器断开连接' -- [12]='#cffff00请重新连接'
local STRING_CANCEL = LangCommonString[3] -- [3]='取消'
local STRING_LEAVE = { LangCommonString[13], LangCommonString[14],LangCommonString[15] }  -- [13]='#cfff5f0您需要返回到登录界面吗？' -- [14]='#cfff5f0点击确定' -- [15]='#cffff00返回到登录界面'
local STRING_QUIT =  { LangCommonString[4], LangCommonString[5],LangCommonString[6] }  -- [4]='#cfff5f0您需要退出游戏吗' -- [5]='#cffc80e点击退出' -- [6]='#cfff5f0退出游戏'
local DialogDepth = 80000

local os_time = os.time
---- 私有函数

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
			local client_version = CCVersionConfig:sharedVersionConfig():getStringForKey('current_version');
			
			
			MiscCC:request_send_phone_info( phone_mark, 
											phone_version,
											chanel_id,-- platform, 
											resolution_ratio_str, 
											'UNKNOWN',
											'UNKNOWN',
											-- NetManager.strISP,
	    						            -- NetManager.strNetType ,
											udid ,
											platform,-- chanel_id,
											client_version )

		else
			MiscCC:request_send_phone_info( "", "", "", "", "","", "", "", "")
		end
	else
		local phone_state = GetPhoneState()
		local phone_info_t = split( phone_state,',')          -- 逗号分割，在java层定义的规约
		local phone_mark = phone_info_t[1] or ""              -- 手机名称
		local phone_version = phone_info_t[2] or ""           -- 手机系统号
		local platform = BISystem:getDownloadFrom()			  -- 平台
		local winSize = CCDirector:sharedDirector():getWinSize();
		local width = winSize.width or 0
		local height = winSize.height or 0
		local resolution_ratio_str = width .. "*" .. height
		local udid = GetSerialNumber()		-- 如果可以获取手机序列号用作udid
		local chanel_id = BISystem:getDownloadChannel()                --渠道id
		local client_version = CCVersionConfig:sharedVersionConfig():getStringForKey('current_version');

		-- print("!!!!!!!!!!!!!!!!!!!!!!!!!~~~~~~~=======@@@@@@@手机信息 ", phone_state, "&", phone_mark, "&", phone_version, "&", platform, resolution_ratio_str )

		--local network_state = NetManager.strISP .. '_' .. NetManager.strNetType
		--print('>>>>>>> network_state', network_state)
	    MiscCC:request_send_phone_info( phone_mark, 
	    								phone_version, 
	    								chanel_id,--platform, 
	    								resolution_ratio_str,
	    								NetManager.strISP,
	    								NetManager.strNetType ,
	    								udid,
	    								platform,-- chanel_id,
	    								client_version)
	end
	
end


--地图编辑

local function mapedite_enter(  )
	UIManager:show_window("mapedite_win")
end

local function mapedite_leave( ... )
	-- body
end

-- 游戏更新状态
local function update_enter(  )
	
end

local function update_leave(  )
	
end
local _is_first_enter_login_view = true --这里主要解决ios平台登录的问题，安卓其实直接通知平台进入登录状态即可
-- 登录状态
local function login_enter()
	require 'ForceUpdateMgr'
	if ForceUpdateMgr:needUpdate() then
		ForceUpdateMgr:doUpdate()
		return
	else
		SystemInfo.showMemoryState()
		UI_Utilities.CreateFixButton()
		UI_Utilities.CreateResourceFixButton()
		-- UI_Utilities.CreateAdButton()
		if PlatformInterface.onEnterLoginState then
			if _is_first_enter_login_view then
				-- 判断一下是不是更新后首次进入游戏，如果是的话，就先打开公告页面
				local tmp_state = UpdateManager:get_after_update_first();
				if tmp_state == nil or tmp_state == "" or tmp_state == "true" then
					-- 重置状态放在最后，避免玩家热更后点击继续游戏的时候看不到更新公告，状态位又被重置了

					-- 模仿各个Platform的onEnterLoginState方法先写这个
					RoleModel:show_login_win( GameStateManager:get_game_root() )
					-- 再切换到公告分页
					RoleModel:change_login_page( "notice_window" )
				else
					PlatformInterface:onEnterLoginState(_is_first_enter_login_view)
				end
				_is_first_enter_login_view=false
			else
				PlatformInterface:onEnterLoginState()
			end
			
		--[[--这段代码失效了，无平台和苹果官方平台都要求严格按照平台设计实现接口，不做无接口情况，这样安全点
		else
			
			local temp_name = CCUserDefault:sharedUserDefault():getStringForKey("user_name")
			--print("temp_name",temp_name,#temp_name,temp_name~=nil,temp_name~="")
			--RoleModel:send_name_and_pw( temp_name, '!OP@#5', false, true )
			-- 一进入游戏，首先启动登录界面，
			RoleModel:show_login_win( GameStateManager:get_game_root() )
			---old
			--RoleModel:change_login_page( "login" )
			---new
			if temp_name ~= nil and temp_name ~= "" then
				RoleModel:send_name_and_pw( temp_name, '!OP@#5', false, true )
				RoleModel:change_login_page("new_select_server_page")
			else
				RoleModel:change_login_page("login")
			end
			--]]
		end

		-- 记录进入登录界面了
		if BISystem.login_page then
			BISystem:login_page()
		end
	end
end

local function login_leave()
	-- UIManager:destroy_window("login")
	--销毁登录界面
	RoleModel:destroy_login_win();	
	UI_Utilities.DestroyFixButton()
	UI_Utilities.DestroyResourceButton()
	UI_Utilities.DestroyAdButton()
end

-- 游戏初始化模块
local function loading_enter(  )
	print("run loading_endter")
	-- 先打开主游戏初始化模块界面
	ResourceManager:init_game()
end

local function loading_leave(  )
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
	-- 以下的初始化顺序是根据节点生成次序定义的，不能修改
	-- 先渲染场景，然后渲染实体，最后渲染UI
	print("scene_enterscene_enter")
	ConnectionChecker:init()

	if phone_showProgress then
		phone_showProgress(LangCommonString[16],LangCommonString[17],true,false) -- [16]='请稍候' -- [17]='初始化游戏'
	end

	local root = GameStateManager:get_game_root()

    --每日福利，离线积累 相关申请
    -- WelfareModel:request_login_award_list(  )
	--WelfareModel:request_all_welfare_date(  )
	
	--xprint('a')
	-- 先显示loading界面，盖住地图
	--SceneLoadingWin:show_instance(nil,100,100)
	--QQVipInterface:init_qq_vip_interface()
	-- 初始化UI节点模块
		require "MapEdite/__init"
		require "UIEditor/__init"
	UIManager:init(root)				-- 初始化UI
	-- 初始化场景节点模块
	-- require "scene/SceneManager"
	-- SceneManager:init(root)				-- 初始化场景系统
	-- 初始化场景实体节点模块
	-- require "entity/EntityManager"
	-- EntityManager:init(root)			-- 初始化游戏实体
	
	-- 先显示loading界面，盖住地图
	--SceneLoadingWin:show_instance()

	-- 进入游戏场景才初始化AI
	-- require "AI/AIManager"
	-- AIManager:init()

	-- 开始游戏心跳
	--GameStateManager:start_game_tick()

    --获取装备列表
	-- require "control/UserEquipCC"
    --UserEquipCC:request_get_equi();

    -- 请求下发商城，限制产品列表
    --MallModel:request_time_limit_item(  ) -- 限制产品

    -- 获取玩家帮派信息
    -- require "control/GuildCC"
    --GuildCC:request_self_guild_info()

    -- 活动界面相关数据
    --ActivityModel:request_enter_fuben_times( )
    --ActivityModel:apply_activity_award_info(  )     -- 请求下发活跃活动信息
    
	
    -- require "model/ItemModel"
    --ItemModel:init_bag()

    -- require "control/AchieveCC"
   	--AchieveCC:request_achieve_info();

   	-- 请求设置系统
   	--SetSystemModel:request_set_date(  )

   	-- 初始化变身系统
   	-- 服务器在登录的时候自动下发，不需要主动申请 by yongrui.liang 14/6/16
   	-- TransformModel:init()

   --	UIManager:setupMainUI()
--	require "control/UserSkillCC"
--	UserSkillCC:request_skill_list()


-- 	if PlatformInterface.getLoginRet then
-- 		local openid = PlatformInterface:getLoginRet()
-- 		if openid then
-- 			local InstallChannel = PlatformInterface.InstallChannel
-- --TODO 要改协议！支持字符串类型的channel
-- 			if tonumber(InstallChannel) then
-- 				OnlineAwardCC:request_get_platform_award(tonumber(InstallChannel),openid)
-- 			end
-- 		end
-- 	end
	
	-- added by aXing on 2014-6-7
	-- 新的新手引导
	--Instruction:init()

    -- 显示在整个UI上层的内容
    -- UIManager:show_window( "whole_win" )
    -- UIManager:show_window("transform_dev_win")
    -- todo  向服务器发送手机版本号等信息
    --send_phone_info(  )

    ResourceManager:EnterGameWorld()

    -- 获取登陆天数信息
    -- OnlineAwardCC:req_login_benefit()
    
   -- MUtils.delay_phone_hideProgress(0.5)

	--通知平台已进入游戏场景
	-- if PlatformInterface.onEnterGameScene then
	-- 	PlatformInterface:onEnterGameScene(true)
	-- end
	--GameStateManager:set_state("mapedite")


	--UIManager:show_window("uiedit_win")
	UIEditWin:show_window(  )
end 

local function scene_leave()
	print("scene_leave")

	ConnectionChecker:fini()

	Cinema:fini()
	
	-- 析构BI系统
	EventSystem.quit()

	Analyze:fini()

	Instruction:scene_leave()
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
	mapedite ={enter = mapedite_enter,  leave = mapedite_leave},
}

-- 整个游戏的根节点
local _game_root = nil			
-- 客户端生存周期，运行了多少秒
local _game_total_seconds = 0;
-- 客户端生存周期，运行了多少毫秒
local _game_total_millisecond = 0;


---- 公有函数
-- 游戏初始化
function GameStateManager:init(root)
	reload('UI/UIScreenPos')
	reload('utils/MUtils')
	_game_root = root
end

-- 获取整个游戏的根节点
function GameStateManager:get_game_root(  )
	return _game_root
end


-- 切换不同的游戏状态
-- state 只能是 "login", "choose", "scene", ...
function GameStateManager:set_state(state)
--	print("run game state manager ",state)
	if GAME_STATE[state] == nil then
		print("GameStateManager has not this state:", state)
		return false
	end

	-- 如果存在上个状态，则需要调用上个状态的析构
	if _current_state ~= nil then
		GAME_STATE[_current_state].leave()
		_current_state = nil
	end
--	print("run state enter")
	_current_state = state
	 GAME_STATE[state].enter()

	require 'PowerCenter'
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
	
	_game_total_seconds = _game_total_seconds + ds;

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
	--print(ds)
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
	--print("服务器确认还在线的回调...", os.clock(), _online_flag)
	--收包的时候就重置过了
	--GameStateManager:reset_connect_check_count(  )
end

function GameStateManager:do_lost_connect()
	if MiscCC then
 		MiscCC:send_quit_server()
 	end
 	self:set_state("login")
 	self.modalPop = nil
end

function GameStateManager:lost_connect()
	if self:get_state() ~= 'scene' then
		return false
	end

	local function do_lost_connect()
		GameStateManager:do_lost_connect()
	end


	local _root = SceneManager.UIRoot

	if not PlatformInterface.logoutable then
		if _root and not self.modalPop then
			self.modalPop = PopupNotify( _root,
									    DialogDepth, 
										PlatformInterface.disconnect_msg,
										STRING_BTN_CLOSE,STRING_BTN_QUIT,
										POPUP_YES_NO,
										function(state)
											if state then  
												return false
											else
												ZXGameQuit()
											end
										end,
										POPUPSIZE_EXIT_DIALOG)
		end
	else
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
	end

	return true
end

function GameStateManager:back_to_login()
	if self:get_state() ~= 'scene' then
		return false
	end
	local _root = SceneManager.UIRoot

	local function do_back_to_login()
		ZXLog("返回登录中。。。。。。。。。。。。。。。。。。。。。。。。。。")
		MiscCC:send_quit_server()
		self:set_state("login")
		-- 取消
		--create by jiangjinhong  通知平台退出平台s
		if GetPlatform() == CC_PLATFORM_IOS then
			IOSDispatcher:IAP_remove_observer( )
		elseif GetPlatform() == CC_PLATFORM_ANDROID then
			-- ForceUpdateMgr:do_android_update()
		elseif GetPlatform() == CC_PLATFORM_WIN32 then	
			-- ForceUpdateMgr:do_win32_update()
		end

		-- IOSDispatcher:IAP_remove_observer( )
		--注销登录
		--PlatformInterface:show_logout()
	end
print("PlatformInterface.logoutable",PlatformInterface.logoutable)
	if not PlatformInterface.logoutable then
		print("run if")
		if _root and not self.modalPop then

			local content = PlatformInterface.logout_content or STRING_LEAVE

			self.modalPop = PopupNotify( _root,
									DialogDepth, content,
									STRING_BTN_LOGOUT,STRING_CANCEL,POPUP_YES_NO,
									function(state)
										if state then  
											ZXGameQuit()
										end
										self.modalPop = nil
									 end,
									 POPUPSIZE_EXIT_DIALOG)
		end
	else
		print("run else")
		if _root and not self.modalPop then

			local content = PlatformInterface.logout_content or STRING_LEAVE

			self.modalPop = PopupNotify( _root,
									DialogDepth, content,
									STRING_BTN_LOGOUT,STRING_CANCEL,POPUP_YES_NO,
									function(state)
										if state then  
											if PlatformInterface.logout then
												PlatformInterface:logout(do_back_to_login)
											else
												do_back_to_login()
											end
										end
										self.modalPop = nil
									 end,
									 POPUPSIZE_EXIT_DIALOG)
		end
	end
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
--	local freeMem = collectgarbage('count');
--	print("GC Count : " .. freeMem/1024 .. " MB");
end

function GameStateManager:testCinema(id)
--	reload('../movie/movie_actors')
	reload('../movie/movie_dialogs')
	reload('../movie/movie_scenes')
	reload('../movie/movie_config')
	
	reload('movie/events')
	reload('movie/movieActor')
	reload('movie/movieEvent')
	reload('movie/cinema')

	Cinema:stop()
	Cinema:init()
	Cinema:play('act1', function() print('the end') end)
end