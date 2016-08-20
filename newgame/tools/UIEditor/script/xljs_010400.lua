
-- for CCLuaEngine traceback
local _trace_print = print
function __G__TRACKBACK__(msg)
    _trace_print("----------------------------------------")
    _trace_print("LUA ERROR: " .. tostring(msg) .. "\n")
    _trace_print(debug.traceback())
    _trace_print("----------------------------------------")
end



require "zxDebugger"
require "super_class"
require 'simple_class'
require 'utils/callback'
require 'utils/timer'
require 'utils/extensions'
require 'SystemInfo'
require "UI/UIScreenPos"
local function require_main()
	--reload刷新id和处理
	AppMessages = nil

	-- 加载可以由phone_sendMessage 方式调用的java接口
	require 'JavaFunction'
	require 'JPush/__init'

	require 'AsyncMessage'
	require 'AppMessages'

	require 'json/json'
	require 'CommonConfig'

	require 'UpdateManager'

	-- require "XWidget/__init"

end

local test_time = os.clock()

DefaultNineGridSize = 600
----
FontPerAddNum = 0

-- 游戏自适应的屏幕像素值
GameScreenConfig = {

	-- 标准设计屏幕大小
	standard_width  = 960,
	standard_height = 640,  
	-- 标准半屏
	standard_half_width  = 480,
	standard_half_height = 320,
	-- 适应屏幕，设置期望的镜头大小
	-- 这里取的是地图心魔幻境第一层
	min_scene_width  = 1136,			
	min_scene_height = 640,	
		
	ipad_width = 1024,
	ipad_height = 768,
	ipad_ret_width = 2048,
	ipad_ret_height = 1536,
	iphone5_width = 1136,

	---------------------------------------------
	--屏幕大小用来做全屏和布局
	ui_screen_width = 960,
	ui_screen_height = 640,
	--界面的设计大小
	ui_design_width  = 960, --设计的UI / size
	ui_design_height = 640, --设计的UI / size

}

-- 游戏自适应用到的缩放比
GameScaleFactors = {
	-- 实际场景与UI缩放比
	viewPort_ui_x = 0, 
	viewPort_ui_y = 0,
	-- 场景缩放比
	viewPort_x = 0,
	viewPort_y = 0,

	--ui缩放比
	ui_scale_factor = 1.0,

	--
	screen_to_ui_factorX = 1.0,
	screen_to_ui_factorY = 1.0,
}

SoundGlobals = 
{
	SoundGamePath = 'sound/Game/',
	SoundSoundsPath = 'sound/Sounds/',
	SoundEffectPath = 'sound/Effect/',
}

function ZXgetWinSize(  )
	local winSize = CCDirector:sharedDirector():getWinSize();
	if CCDirector:sharedDirector():isRetinaDisplay() then
		winSize.width = winSize.width * 2
		winSize.height = winSize.height * 2
	end
	return winSize
end

function ZXIsiPhone5()
	if GameScreenConfig.is_iPhone5 == nil then
		if ZXgetWinSize().width == GameScreenConfig.iphone5_width then
			GameScreenConfig.is_iPhone5 = true
			return GameScreenConfig.is_iPhone5
		else
			return false
		end
	else
		return GameScreenConfig.is_iPhone5 
	end
end

function ZXIsiPad()

	if GameScreenConfig.is_iPad == nil then
		if ZXgetWinSize().width == GameScreenConfig.ipad_width or ZXgetWinSize().width == GameScreenConfig.ipad_ret_width then
			GameScreenConfig.is_iPad = true
			return GameScreenConfig.is_iPad
		else
			return false
		end
	else
		return GameScreenConfig.is_iPad
	end

end

function ZXgetScreenCenter(  )
	local winSize = ZXgetWinSize()
	if winSize.width <= GameScreenConfig.iphone5_width then
		-- iphone retina & ipad
		return winSize.width/2,winSize.height/2
	else
		-- ipad retina
		return 1024/2,768/2
	end
	return nil
end

function ZXgetScreenOffer(  )
	local winSize = ZXgetWinSize()
	if winSize.width == GameScreenConfig.ipad_ret_width then
		-- retina ipad 宽 需要除以2 
		-- return (winSize.width/2 -960 ) / 2 
		return 0
	else
		return (winSize.width - 960 ) / 2 
	end
	return 0
end


local function fix_screen( root )
	-- 适应所有屏幕 我们所有的ui以800,480为标准
	root:setAnchorPoint(CCPointMake(0,0));
	local winSize = ZXgetWinSize();
    -- print('winSize>>',winSize.height,winSize.width);

	-- 适应屏幕，设置期望的镜头大小
	local min_scene_width  = GameScreenConfig.min_scene_width		-- 这里取的是地图心魔幻境第一层
	local min_scene_height = GameScreenConfig.min_scene_height

	local fix_viewport_width  = GameScreenConfig.standard_width		-- 标准分辨率
	local fix_viewport_height = GameScreenConfig.standard_height

	-- 先考虑是否需要扩大视野
	if winSize.width > fix_viewport_width or winSize.height > fix_viewport_height then
		if winSize.width > min_scene_width then
			fix_viewport_width = min_scene_width
		else
			fix_viewport_width = winSize.width
		end
		
		if winSize.height > min_scene_height then
			fix_viewport_height = min_scene_height
		else
			fix_viewport_height = winSize.height
		end
	end

	-- 然后需要考虑是否需要scale
	local scale_width  = winSize.width  / fix_viewport_width
	local scale_height = winSize.height / fix_viewport_height
	
	local scale = scale_height
	if scale_width > scale_height then
		scale = scale_width
	end


	GameScaleFactors.viewPort_x = scale
	GameScaleFactors.viewPort_y = scale

	GameScaleFactors.viewPort_ui_x = fix_viewport_width  / GameScreenConfig.standard_width
	GameScaleFactors.viewPort_ui_y = fix_viewport_height / GameScreenConfig.standard_height
 	

	if ZXIsiPhone5() or ZXgetWinSize().width == GameScreenConfig.standard_width then
		--fix_viewport_width = ZXgetWinSize().width * 0.85
		--fix_viewport_height = ZXgetWinSize().height * 0.85
		--scale = 1.2--GameScaleFactors.ui_y
		--ZXLog("---------ZXIsiPhone5--------------")
	elseif ZXIsiPad() then
		-- scale = scale - 0.04
		-- print("ipad 版本的 缩放", scale)
		fix_viewport_width = fix_viewport_width - 150
		--ZXLog("---------ZXIsiPad--------------",scale)
	end


	GameScreenConfig.viewPort_width = fix_viewport_width 
	GameScreenConfig.viewPort_height = fix_viewport_height

	root:setViewPortSize(fix_viewport_width, fix_viewport_height, scale)

	--界面缩放和计算
	----------------------------------------------------
	--计算缩放比
	local wFactor = winSize.width / GameScreenConfig.ui_design_width
	local hFactor = winSize.height / GameScreenConfig.ui_design_height

	GameScaleFactors.ui_scale_factor = math.min(wFactor,hFactor)
	---------------------------------------------------
	GameScreenConfig.ui_screen_width  = math.floor(winSize.width  / GameScaleFactors.ui_scale_factor)
	GameScreenConfig.ui_screen_height = math.floor(winSize.height / GameScaleFactors.ui_scale_factor)

	root:getUINode():setScale(GameScaleFactors.ui_scale_factor)


	GameScaleFactors.screen_to_ui_factorX = GameScreenConfig.ui_screen_width / winSize.width
	GameScaleFactors.screen_to_ui_factorY = GameScreenConfig.ui_screen_height / winSize.height
	ZXLog('Scene Scale')
	ZXLog('scaleFactor',GameScaleFactors.ui_scale_factor)
	ZXLog('winSize', winSize.width, winSize.height)
	ZXLog('gameSize', GameScreenConfig.ui_screen_width, GameScreenConfig.ui_screen_height)

	GameScreenConfig.winSize_width = winSize.width
	GameScreenConfig.winSize_height = winSize.height
end


ClientLanguage = ''

function setCommonLanguage()
	ClientLanguage = CCAppConfig:sharedAppConfig():getStringForKey("language")
	if ClientLanguage == '' then
		ClientLanguage = 'CN'
	end

	if ClientLanguage == "CN" then
		require "../data/language/CN/LangCommonString"
	elseif ClientLanguage == "TW" then
		require "../data/language/TW/LangCommonString"
	elseif ClientLanguage == "EN" then
		require "../data/language/EN/LangCommonString"
	end

end

function setGameLanguage()
	if ClientLanguage == "CN" then
		require "../data/language/CN/Lang"
		require "../data/language/CN/LangGameString"
		require "../data/language/CN/LangModelString"

	elseif ClientLanguage == "TW" then
		require "../data/language/TW/Lang"
		require "../data/language/TW/LangGameString"
		require "../data/language/TW/LangModelString"

	elseif ClientLanguage == "EN" then
		require "../data/language/EN/Lang"
		require "../data/language/EN/LangGameString"
		require "../data/language/EN/LangModelString"
	end
end

--打包的时候会将信息插进来
local function version()
end

--清空文件夹
function clearWriteablePath( nextStage )
	--ZXLog('clearWriteablePath')
	require ('utils/MUtils')
	MUtils:toast_black('正在初始化',0xffffff,3)
	local p = CCFileUtils:getWriteablePath()
	local _workQueueTimer = timer()
	local _workQueue = {}
	local __assetsmgr = AssetsManager:sharedManager()

	local function doTick( dt )
		-- body
		if #_workQueue == 0 then
			_workQueueTimer:stop()
		else
			local _job = table.remove(_workQueue, 1)
			_job()
		end
	end
	--一个删除目录内容、
	_workQueueTimer:start(0,doTick)

	_workQueue[#_workQueue+1] = function()
		__assetsmgr:removeWritablePathFile(p .. 'binary')
		__assetsmgr:removeWritablePathFile(p .. 'chat_face')
		__assetsmgr:removeWritablePathFile(p .. 'data')
	end

	_workQueue[#_workQueue+1] = function()
		__assetsmgr:removeWritablePathFile(p .. 'frame')
		__assetsmgr:removeWritablePathFile(p .. 'icon')
		__assetsmgr:removeWritablePathFile(p .. 'map')
	end

	_workQueue[#_workQueue+1] = function()
		__assetsmgr:removeWritablePathFile(p .. 'nopack')
		__assetsmgr:removeWritablePathFile(p .. 'particle')
	end

	_workQueue[#_workQueue+1] = function()
		__assetsmgr:removeWritablePathFile(p .. 'scene')
		__assetsmgr:removeWritablePathFile(p .. 'ui')
		__assetsmgr:removeWritablePathFile(p .. 'ui2')
	end

	_workQueue[#_workQueue+1] = function()
		nextStage()
	end
end

--操作SDCard，如果APK版本较高，删除SDCard内容
local function checkApkVersion(nextStage)
	local apk_version     = CCAppConfig:sharedAppConfig():getStringForKey("current_version")
	local current_version = CCVersionConfig:sharedVersionConfig():getStringForKey('current_version')

	local patch_version = CCVersionConfig:sharedVersionConfig():getStringForKey('patch_version')
	local apk_patch_version = CCAppConfig:sharedAppConfig():getStringForKey("patch_version")

	local fixStorage = CCAppConfig:sharedAppConfig():getBoolForKey("fixStorage")

	-- 增加对标签tag和别名alias的读取
	local tag = CCAppConfig:sharedAppConfig():getStringForKey("tag");
	local alias = CCAppConfig:sharedAppConfig():getStringForKey("alias");

	ZXLog('FixStorage Flag', fixStorage)
	ZXLog('tag', tag, 'alias', alias)

	--如果version.xml比apk默认ver小, 且notFixStorage Flag Set
	ZXLog(apk_version, current_version, apk_version >= current_version)
	ZXLog(apk_patch_version, patch_version, apk_patch_version >= patch_version)

	if  apk_version >= current_version then
		CCVersionConfig:sharedVersionConfig():setStringForKey('current_version',apk_version)
		CCVersionConfig:sharedVersionConfig():setStringForKey('downloaded-version-code',apk_version)
		CCVersionConfig:sharedVersionConfig():flush()
		--清空目录，设置APK只读标记
		if fixStorage then
			clearWriteablePath(nextStage)
		else
			nextStage()
		end
	else
		nextStage()
	end
end


function SaveUserID()
-- added by aXing on 2013-6-26
	-- 记录手机的唯一标示
	local user_id = CCUserDefault:sharedUserDefault():getStringForKey("user_id")
	-- modify by mwy on 2014-6-12
	--增加ios平台udid或者udfa的获取
	if user_id == nil or user_id == "" then
		if GetPlatform() == CC_PLATFORM_IOS then
			require 'model/IOSDispatcher'
			local device_info = IOSDispatcher:get_device_info( )
			if device_info then
				user_id = device_info["identifier"]
			end
		else
		--GetPlatform() == CC_PLATFORM_ANDROID then
			--是否是最新的命名方式，如果不是，就重定义
			local index = string.find( user_id, "_LH" )
			if index == nil then
				user_id = ""
			end
			if GetSerialNumber ~= nil then
				user_id = GetSerialNumber()		-- 如果可以获取手机序列号
				user_id = os.time() .. "_" .. user_id ..  "_LH"
			end
			if user_id == 'unknown' then
				user_id = ""
			end
			if user_id == nil or user_id == "0" or user_id == "" then
				local phone = GetPhoneState()
				local model = "0"
				local version = "0"
				if phone ~= "0" then
					model, version = string.match(phone, "(%Z+)%,(%Z+)")
				end
				user_id = os.time() .. "_" .. model
				user_id = string.gsub(user_id,'%s','_')
				user_id = user_id .. "_LH"
			end	
		end	
	end
	CCUserDefault:sharedUserDefault():setStringForKey("user_id", user_id)
	CCUserDefault:sharedUserDefault():flush()
end



local function runMainCheckStep( ... )
	-- body
	local root = ZXLogicScene:sharedScene()
	
	require_main()
    -- 这里初始化资源管理器  加载字体
	version()
	SaveUserID()

	-- local root = ZXLogicScene:sharedScene()
	
	-- 是游戏开始文件，必须用这个命名，是底层写死的

	-- 这里会创建一个游戏最上层的渲染根节点，所有的游戏需要渲染的节点都是从这个节点下添加的。
	-- 根节点必须由ZXLogicScene创建，因为这个场景自身包含了3个节点，sceneNode,entityNode,UINode
	-- 由引擎本身去控制这三层父节点的行为

	-- fix_screen(root)root

	-- 连接调试台
	print('Version 1.2.0 build 2013/05/21')
	-- seed只需要一次！
	math.randomseed(os.time())
	-- zhanxian.lua 

	print('isTablet:',phone_isTablet())
    --Droid Sans Fallback
	local dbg_host = CCAppConfig:sharedAppConfig():getStringForKey("dbg_host")
	local dbg_port = CCAppConfig:sharedAppConfig():getStringForKey("dbg_port")
	print("dbg_host, dbg_port",dbg_host, dbg_port)
	if dbg_host ~= '' and dbg_port ~= '' then
		ZXLuaUtils:SetRemoteDebuggerAddress(dbg_host,tonumber(dbg_port))
		ZXLuaUtils:ConnectRemoteDebugger()
	end

	--print('>>>>>>', CCFileUtils:getWriteablePath())
	--print(">>>",phone_getInstallPath())
--@debug_begin
	if CCUserDefault:sharedUserDefault():getBoolForKey("test") then
		require "Test"
		Test:test(root)
	else
--@debug_end

		--PlatformInterface.initPlatform()

		--QQ大厅拉起消息缓存通知到平台

        -- 更新界面
		require "UI/update/UpdateWin"
		UpdateWin:init( root:getUINode() )
		
		require 'PowerCenter'
		if PowerCenter then
			PowerCenter:init()
		end

	    --require "Update"

	    UpdateManager:set_root(root)

--@debug_begin
--@debug_end
		-- added by aXing on 2013-5-30
		-- 添加BI打点服务器初始化
		local function doStartGame()
			require 'BISystem'
			--BISystem的第一次打点在updatemanager到entrance.jsp拉取url之后 
			UpdateManager:CheckServerState(function ()
				-- body
				no_update = CCAppConfig:sharedAppConfig():getBoolForKey("no_update")
				--no_update = false
				if not no_update then
					UpdateManager:start()
				else
					UpdateManager.no_update = true
					UpdateManager:finish()
				end
			end)
		end

		local function startGame()
			--先去检查APK版本号是否合法，如果不合法，删除目录内容
			-- zhanxian.lua 
			-- 是游戏开始文件，必须用这个命名，是底层写死的
			-- 看一下是否需要检查更新
			--if PlatformInterface.onStartPackage then
			--   PlatformInterface:onStartPackage(doStartGame)
			--else
			require 'BISystem'
			UpdateManager:finish()
				--doStartGame()
			--end
		end
		startGame()
		--end
--@debug_begin
	end
--@debug_end
end

--进入游戏
local function introStep()
	require 'Intro'
	local root = ZXLogicScene:sharedScene()
	Intro:start(root,runMainCheckStep)

end

--检查数据
local function runMainScreenStep()
	require "sound/AudioManager"
	ZXResMgr:setTextureColorCompress(GameScreenConfig.textureColorCompress)
	checkApkVersion(runMainCheckStep)
	-- checkApkVersion(introStep)
end

--[[
#define CC_PLATFORM_IOS                1
#define CC_PLATFORM_ANDROID            2
]]--
local function _setupFont()

	local fontScale = GameScaleFactors.ui_scale_factor
    if fontScale < 1.0 then
    	fontScale = 1.0
    end
	local fontSize = math.min(22 * fontScale, 28)

	local pf =  GetPlatform()
	if pf == CC_PLATFORM_WIN32 then
		ZXResMgr:sharedManager():initFontInfo("方正粗圆简体", fontSize, 0, 0, 512, 512, 1, 6408, 0xffffff)
		ZXResMgr:sharedManager():initAndroidFontInfo(1.5, 0.0, -3.0, 3)
		ZXResMgr:sharedManager():initTextShadowInfo(0, 0, 1.2, 0xff000000)
	elseif pf == CC_PLATFORM_IOS then
		ZXResMgr:sharedManager():initFontInfo("Microsoft YaHei", fontSize, 0, 0, 512, 512, 1, 6408, 0xffffff)
		ZXResMgr:sharedManager():initTextShadowInfo(0, 0, 1.2, 0xff000000)
		if ZXIsiPad() then
			--ipad字体缩小
			ZXResMgr:sharedManager():initAndroidFontInfo(1.5, 0, 0, 4)
		else
			ZXResMgr:sharedManager():initAndroidFontInfo(1.5, 0, 0, 4)
		end
	elseif pf == CC_PLATFORM_ANDROID then
		ZXResMgr:sharedManager():initFontInfo("FZY4JW.TTF", fontSize, 0, 0, 512, 512, 1, 6408, 0xffffff)
		ZXResMgr:sharedManager():initAndroidFontInfo(1.5, 0.0, 0.0, 6)
		ZXResMgr:sharedManager():initTextShadowInfo(0, 0, 1.2, 0xff000000)
	end
end

local function _high_resolution()
	ZXResMgr:setTextureColorCompress(false)
	ZXGameScene:setCompressTileTexture(false)

	GameScreenConfig.textureColorCompress = false
	ZXLog('ColorCompress =  false, CompressTileTexture = false')
	-- MUtils:toast('超高清质量',0xffffff,3,true)
end

local function _mid_resolution()
	ZXResMgr:setTextureColorCompress(true)
	ZXGameScene:setCompressTileTexture(false)

	GameScreenConfig.textureColorCompress = true
	ZXLog('ColorCompress =  true, CompressTileTexture = false')
	-- MUtils:toast('高清质量',0xffffff,3,true)
end

local function _low_resolution()
	ZXResMgr:setTextureColorCompress(true)
	ZXGameScene:setCompressTileTexture(true)

	GameScreenConfig.textureColorCompress = false
	ZXLog('ColorCompress =  true, CompressTileTexture = true')
	-- MUtils:toast('标清质量',0xffffff,3,true)
end

local function _setupTextureCompress()
	require ('utils/MUtils')
	local pf =  GetPlatform()
	if pf == CC_PLATFORM_IOS then
		--retina且屏幕大1.5倍不压缩纹理 960x640
		_high_resolution()
		-- if CCDirector:sharedDirector():isRetinaDisplay() then
		-- 	if GameScaleFactors.ui_scale_factor >= 1.5 then
		--    		_mid_resolution()
		--    	else
		--    		_mid_resolution()
		-- 	end
		-- else
		-- 	_mid_resolution()
		-- end

	elseif pf == CC_PLATFORM_ANDROID then 
		--屏幕大1.5倍不压缩纹理 960x640
		_high_resolution()
		-- if GameScaleFactors.ui_scale_factor >= 1.5 then
		-- 	_mid_resolution()

		-- elseif GameScaleFactors.ui_scale_factor >= 1.0 then
		-- 	_mid_resolution()

		-- else
		-- 	_low_resolution()
		-- end
		CCZXLabel:enableGradient(true)
	else
		_high_resolution()
		CCZXLabel:enableGradient(true)
	end
end

local function main()
	-- avoid memory leak
	collectgarbage("setpause", 100)
	collectgarbage("setstepmul", 5000)

	local root = ZXLogicScene:sharedScene()
	fix_screen(root)
	-- CCDirector:sharedDirector():runWithScene(root)
	setCommonLanguage()
	_setupFont()
	_setupTextureCompress()
	CCDirector:sharedDirector():runWithScene(root)


	require 'SlashScreenPlay'
	if GetPlatform() == CC_PLATFORM_IOS then
		local json = "{\"funcID\":\"save_video_finish_callback\"}"
		local function video_finish_callback()
			runMainScreenStep()
		end
		IOSBridgeDispatcherAsync( json, video_finish_callback )
		SlashScreen(root,runMainScreenStep)
	else
		SlashScreen(root,runMainScreenStep)
	end



end

------------------------------------------------------- 
-- 其他平台可以忽略，这个是为QQ大厅做的
-- dummy for pr game messages
local QQWakeMessage = nil
local eMsgMSDKOnWakeupNotify = 81002
AppMessages = {}
function AppMessages.OnQuit(...)
end

function AppMessages.OnEnterBackground(...)
end

function AppMessages.OnEnterForeground(...)
end

function AppMessages.OnKeyEvent(...)
end

function AppMessages.OnKeyEvent(...)
end

function AppMessages.OnBackClick(...)
end

function AppMessages.OnMenuClick(...)
end

function AppMessages.OnDestory(...)
end

function AppMessages.OnAsyncMessage( id, msg )
	--QQ拉起特殊需求
	if id == eMsgMSDKOnWakeupNotify then
		pushQQWakeMessages(msg)
		-- print('QQWakeMessage[0]',QQWakeMessage)
	else
		require 'json/json'
		local s,e = pcall(function() jtable = json.decode(msg) end)
		print("s,e",s,e)
		if s then
			local message_type = jtable[ "message_type" ] or ""
			print("message_type",message_type)
			if message_type == "appGameMsg" then
				local func_type = jtable[ "funcType" ] or ""
				print("func_type",func_type)
				if func_type == "video_finish" then -- 登录、切换成功的处理
					require 'SlashScreenPlay'
					SlashScreen_after_path()
				end			
			end
		end
	end
end

function postQQWakeMessages()
	if QQWakeMessage then
		if PlatformInterface:OnAsyncMessage(eMsgMSDKOnWakeupNotify,QQWakeMessage) then
			QQWakeMessage = nil
			return true
		end
	end
	return false
end

function pushQQWakeMessages(msg)
	QQWakeMessage = msg
end
---------------------------------------------------------

function testInstruction(id0)
	-- require 'instruction/Instruction'
	reload("../data/instructions_config")
	reload("config/InstructionConfig")
	reload("instruction/Instruction")
	if Instruction then
		 Instruction:fini()
	end
	Instruction:init(true)
	Instruction:start(id0,function() print('finish test') end)
end

function testCinema(id)
	if Cinema then
		Cinema:stop()
	end
	id = id or 'act1'
	
	local scene_actors = nil
	if movieActorManager then
		scene_actors = movieActorManager.scene_actors 
	end

--	reload('../data/movie/movie_actors')
	reload('../data/movie/movie_dialogs')
	reload('../data/movie/movie_scenes')
	reload('../data/movie/movie_config')
	
	reload('movie/movieUtils')
	reload('movie/movieDialog')
	reload('movie/movieActions')
	reload('movie/movieActors')
	reload('movie/movieActorManager')
	reload('movie/movieEvent')
	reload('movie/cinema')
	
	Cinema:init()
	if scene_actors then
		movieActorManager.scene_actors = scene_actors
	end
	Cinema:play(id, function() print('the end') end)
end

function testCinema2(id)
	Cinema:play(id, function() print('the end') end)
end

function testEffect(id, effect_type, time)
	time = time or 0
	local player = EntityManager:get_player_avatar()
	local ani_table = effect_config[id];
	EffectBuilder:playEntityEffect( effect_type, ani_table, time, player, player,id)
end

function test2()
	local _root =  ZXLogicScene:sharedScene():getUINode()
	LuaEffectManager:openSysEffect(_root,GameScreenConfig.ui_screen_width*0.5,
										 GameScreenConfig.ui_screen_height * 0.6 ,
										 480,0,
										480,'nopack/m_anger.png',99999)
end
--profiler.start('p.out')
--profiler.stop()
xpcall(main, __G__TRACKBACK__)

function testSocket()
	local _socket = ClientSocketProxy:GetNetInstance()
	local np = _socket:alloc()			-- 自己申请的pack，可以进行写操作
	np:writeByte(255)
	np:writeByte(100)
	np:writeInt(9999)						-- 默认一服
	np:writeString('hello')
	np:setPosition(0)

	local pack 	= NetPacket:ToNP(np)	
	print(pack:readByte())
	print(pack:readByte())
	print(pack:readInt())
	print(pack:readString())
end