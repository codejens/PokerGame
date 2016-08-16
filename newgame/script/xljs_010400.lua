local _trace_print = printc
function __G__TRACKBACK__(msg)
    _trace_print("----------------------------------------", 4)
    _trace_print("LUA ERROR: " .. tostring(msg) .. "\n", 4)
    _trace_print(debug.traceback(), 4)
    _trace_print("----------------------------------------", 4)
end

--清空文件夹
function clearWriteablePath(nextStage)
	local write_path  = CCFileUtils:getWriteablePath()
	local __assetsmgr = AssetsManager:sharedManager()
	__assetsmgr:removeWritablePathFile(write_path.."binary")
	__assetsmgr:removeWritablePathFile(write_path.."chat_face")
	__assetsmgr:removeWritablePathFile(write_path.."data")
	__assetsmgr:removeWritablePathFile(write_path.."frame")
	__assetsmgr:removeWritablePathFile(write_path.."icon")
	__assetsmgr:removeWritablePathFile(write_path.."map")
	__assetsmgr:removeWritablePathFile(write_path.."nopack")
	__assetsmgr:removeWritablePathFile(write_path.."particle")
	__assetsmgr:removeWritablePathFile(write_path.."scene")
	__assetsmgr:removeWritablePathFile(write_path.."sui")
	__assetsmgr:removeWritablePathFile(write_path.."ui")
	__assetsmgr:removeWritablePathFile(write_path.."ui2")
	__assetsmgr:removeWritablePathFile(write_path.."sound")
	__assetsmgr:removeWritablePathFile(write_path.."script")
	if nextStage then
		nextStage()
	end
end

require "net/HttpRequest"

function bi_Split(str, split_char)
    local sub_str_tab = {}
    while (true) do
        local pos1,pos2 = string.find(str, split_char)
        if (not pos1) then
            sub_str_tab[#sub_str_tab + 1] = str
            break
        end
        local sub_str = string.sub(str, 1, pos1 - 1)
        sub_str_tab[#sub_str_tab + 1] = sub_str
        if pos2 then
            str = string.sub(str,pos2+1,#str)
        else
            str = string.sub(str, pos1 + 1, #str)
        end
    end
    return sub_str_tab
end  

--脚本启动打点
function scrpit_start( url,stype )
	print("GetPlatform",GetPlatform,CC_PLATFORM_ANDROID)
	if GetPlatform() ~= CC_PLATFORM_ANDROID then
		return
	end
	local udid = ""
	local _uid = ""
	local _role_id =  ""
	local _role_name =  ""
	local _type = stype
	local sdcardpath = CCFileUtils:getWriteablePath()
	local str = bi_Split(sdcardpath,"/")
	str = str[#str-1]
	str = string.gsub(str,"_storage","")
	local platform = str
	local idfa = ""
	local server_id =  ""

	if GetPlatform() == CC_PLATFORM_IOS then
		udid = "ios"
	else
		udid = GetSerialNumber()		-- 如果可以获取手机序列号用作udid
	end

	local sign = md5(udid.._uid.._role_id.._role_name.."fT5WLJaQogMADikDaExMccUXazo0hpqo")

	local param = string.format("udid=%s&uid=%s&role_id=%s&role_name=%s&type=%s&sign=%s&platform=%s&idfa=%s&server_id=%s",
		udid,_uid,_role_id,_role_name,_type,sign,platform,idfa,server_id)

	local function bi_func( ... )
		-- body
	end
	

	if GetPlatform() == CC_PLATFORM_ANDROID then
		HttpRequest:sendBI(url, param, bi_func)
	end
end


--操作SDCard，如果APK版本较高，删除SDCard内容
local function checkApkVersion()
	scrpit_start( "http://xiulijiangshan.net/base/bi2",19)
	local apk_version     = CCAppConfig:sharedAppConfig():getStringForKey("current_version")
	local current_version = CCVersionConfig:sharedVersionConfig():getStringForKey("current_version")
	local fixStorage      = CCAppConfig:sharedAppConfig():getBoolForKey("fixStorage")
	if apk_version >= current_version then
		--清空文件夹
		if fixStorage then
			clearWriteablePath()
		end
		CCVersionConfig:sharedVersionConfig():setStringForKey("current_version", apk_version)
		CCVersionConfig:sharedVersionConfig():setStringForKey("downloaded-version-code", apk_version)
		CCVersionConfig:sharedVersionConfig():flush()
	end
	scrpit_start( "http://xiulijiangshan.net/base/bi2",20)
end

checkApkVersion()

require "zxDebugger"
require "super_class"
require "simple_class"
require "utils/callback"
require "utils/timer"
require "utils/extensions"
require "SystemInfo"
require "UI/UIScreenPos"
require "luaPerformance"

--游戏自适应的屏幕像素值
GameScreenConfig = {
	--标准设计屏幕大小
	standard_width       = 960,
	standard_height      = 640,  
	--标准半屏
	standard_half_width  = 480,
	standard_half_height = 320,
	--适应屏幕，期望的镜头大小
	min_scene_width      = 1136,			
	min_scene_height     = 640,
	--ipad信息
	ipad_width           = 1024,
	ipad_height          = 768,
	ipad_ret_width       = 2048,
	ipad_ret_height      = 1536,
	--iphone5宽
	iphone5_width        = 1136,
	--屏幕大小用来做全屏和布局
	ui_screen_width      = 960,
	ui_screen_height     = 640,
	--界面的设计大小(设计的UIsize)
	ui_design_width      = 960,
	ui_design_height     = 640,
}

--游戏自适应用到的缩放比
GameScaleFactors = {
	--实际场景与UI缩放比
	viewPort_ui_x        = 0, 
	viewPort_ui_y        = 0,
	--场景缩放比
	viewPort_x           = 0,
	viewPort_y           = 0,
	--ui缩放比
	ui_scale_factor      = 1.0,

	screen_to_ui_factorX = 1.0,
	screen_to_ui_factorY = 1.0,
}

function ZXgetWinSize()
	local winSize = CCDirector:sharedDirector():getWinSize()
	if CCDirector:sharedDirector():isRetinaDisplay() then
		winSize.width = winSize.width*2
		winSize.height = winSize.height*2
	end
	return winSize
end

function ZXIsiPhone5()
	if GameScreenConfig.is_iPhone5 == nil then
		if ZXgetWinSize().width == GameScreenConfig.iphone5_width then
			GameScreenConfig.is_iPhone5 = true
		else
			GameScreenConfig.is_iPhone5 = false
		end
		return GameScreenConfig.is_iPhone5
	else
		return GameScreenConfig.is_iPhone5 
	end
end

function ZXIsiPad()
	if GameScreenConfig.is_iPad == nil then
		if ZXgetWinSize().width == GameScreenConfig.ipad_width or ZXgetWinSize().width == GameScreenConfig.ipad_ret_width then
			GameScreenConfig.is_iPad = true
		else
			GameScreenConfig.is_iPad = false
		end
		return GameScreenConfig.is_iPad
	else
		return GameScreenConfig.is_iPad
	end
end

local function fix_screen(root)
	root:setAnchorPoint(CCPointMake(0, 0))
	local winSize = ZXgetWinSize()
	--适应屏幕，设置期望的镜头大小
	local min_scene_width     = GameScreenConfig.min_scene_width
	local min_scene_height    = GameScreenConfig.min_scene_height
	local fix_viewport_width  = GameScreenConfig.standard_width
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
	--然后需要考虑是否需要scale
	local scale_width  = winSize.width/fix_viewport_width
	local scale_height = winSize.height/fix_viewport_height
	local scale        = scale_height
	if scale_width > scale_height then
		scale = scale_width
	end

	GameScaleFactors.viewPort_x = scale
	GameScaleFactors.viewPort_y = scale
	GameScaleFactors.viewPort_ui_x = fix_viewport_width/GameScreenConfig.standard_width
	GameScaleFactors.viewPort_ui_y = fix_viewport_height/GameScreenConfig.standard_height
 	
	if ZXIsiPhone5() or ZXgetWinSize().width == GameScreenConfig.standard_width then
	elseif ZXIsiPad() then
		fix_viewport_width = fix_viewport_width - 150
	end

	GameScreenConfig.viewPort_width  = fix_viewport_width
	GameScreenConfig.viewPort_height = fix_viewport_height

	root:setViewPortSize(fix_viewport_width, fix_viewport_height, scale)

	--界面缩放
	local wFactor = winSize.width/GameScreenConfig.ui_design_width
	local hFactor = winSize.height/GameScreenConfig.ui_design_height
	GameScaleFactors.ui_scale_factor  = math.min(wFactor, hFactor)
	GameScreenConfig.ui_screen_width  = math.floor(winSize.width/GameScaleFactors.ui_scale_factor)
	GameScreenConfig.ui_screen_height = math.floor(winSize.height/GameScaleFactors.ui_scale_factor)
	root:getUINode():setScale(GameScaleFactors.ui_scale_factor)
	
	GameScaleFactors.screen_to_ui_factorX = GameScreenConfig.ui_screen_width/winSize.width
	GameScaleFactors.screen_to_ui_factorY = GameScreenConfig.ui_screen_height/winSize.height
	GameScreenConfig.winSize_width        = winSize.width
	GameScreenConfig.winSize_height       = winSize.height
end

ClientLanguage = ""

function setCommonLanguage()
	ClientLanguage = CCAppConfig:sharedAppConfig():getStringForKey("language")
	if ClientLanguage == "" then
		ClientLanguage = "CN"
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
		require "../data/language/CN/SClientLang"
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

--设置字体
local function _setupFont()
	CCZXLabel:enableGradient(false)
	local fontScale = GameScaleFactors.ui_scale_factor
    if fontScale < 1.0 then
    	fontScale = 1.0
    end
	local fontSize = math.min(22*fontScale, 28)
	local pf =  GetPlatform()
	if pf == CC_PLATFORM_WIN32 then
		ZXResMgr:sharedManager():initFontInfo("方正粗圆简体", fontSize, 0, 0, 512, 512, 1, 6408, 0xffffff)
		ZXResMgr:sharedManager():initAndroidFontInfo(1.5, 0.0, -3.0, 3)
		ZXResMgr:sharedManager():initTextShadowInfo(0, 0, 1.2, 0xff000000)
	elseif pf == CC_PLATFORM_IOS then
		ZXResMgr:sharedManager():initFontInfo("Microsoft YaHei", fontSize, 0, 0, 512, 512, 1, 6408, 0xffffff)
		ZXResMgr:sharedManager():initTextShadowInfo(0, 0, 1.2, 0xff000000)
		if ZXIsiPad() then
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

--超清
local function _high_resolution()
	ZXResMgr:setTextureColorCompress(true)
	print("setTextureColorCompress=------------")
	ZXGameScene:setCompressTileTexture(false)
	GameScreenConfig.textureColorCompress = false
end

--高清
local function _mid_resolution()
	-- ZXResMgr:setTextureColorCompress(true)
	ZXGameScene:setCompressTileTexture(false)
	GameScreenConfig.textureColorCompress = true
end

--标清
local function _low_resolution()
	-- ZXResMgr:setTextureColorCompress(true)
	ZXGameScene:setCompressTileTexture(true)
	GameScreenConfig.textureColorCompress = false
end

--设置纹理压缩
local function _setupTextureCompress()
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
		--CCZXLabel:enableGradient(true)
	else
		_high_resolution()
		--CCZXLabel:enableGradient(true)
	end
end

function setIsShowMemoryUsage(bool)
	ZXLuaUtils:setIsShowMemoryUsage(bool)
end

local function require_main()
	require "JPush/__init"
	require "AsyncMessage"
	require "AppMessages"
	require "json/json"
	require "CommonConfig"
	require "UpdateManager"
end

--保存UserID
function SaveUserID()
	local user_id = CCUserDefault:sharedUserDefault():getStringForKey("user_id")
	if user_id == nil or user_id == "" then
		if GetPlatform() == CC_PLATFORM_IOS then
			require "model/IOSDispatcher"
			local device_info = IOSDispatcher:get_device_info()
			if device_info then
				user_id = device_info["identifier"]
			end
		else
			local index = string.find(user_id, "_LH")
			if index == nil then
				user_id = ""
			end
			if GetSerialNumber ~= nil then
				user_id = GetSerialNumber()		--获取手机序列号
				user_id = os.time().."_"..user_id.."_LH"
			end
			if user_id == "unknown" then
				user_id = ""
			end
			if user_id == nil or user_id == "0" or user_id == "" then
				local phone   = GetPhoneState()
				local model   = "0"
				local version = "0"
				if phone ~= "0" then
					model,version = string.match(phone, "(%Z+)%,(%Z+)")
				end
				user_id = os.time().."_"..model
				user_id = string.gsub(user_id, "%s", "_")
				user_id = user_id.."_LH"
			end
		end
	end
	CCUserDefault:sharedUserDefault():setStringForKey("user_id", user_id)
	CCUserDefault:sharedUserDefault():flush()
end

local function runMainCheckStep()
	require_main()
	SaveUserID()
	math.randomseed(os.time())
--@debug_begin
	local dbg_host = CCAppConfig:sharedAppConfig():getStringForKey("dbg_host")
	local dbg_port = CCAppConfig:sharedAppConfig():getStringForKey("dbg_port")
	if dbg_host ~= "" and dbg_port ~= "" then
		ZXLuaUtils:SetRemoteDebuggerAddress(dbg_host, tonumber(dbg_port))
		ZXLuaUtils:ConnectRemoteDebugger()
	end
--@debug_end
	--电量中心
	require "PowerCenter"
	if PowerCenter then
		PowerCenter:init()
	end
	--更新管理
	local root = ZXLogicScene:sharedScene()
    UpdateManager:set_root(root)
    --更新界面
	require "UI/update/UpdateWin"
	UpdateWin:init(root:getUINode())
end

--开始游戏
local function doStartGame()
	scrpit_start( "http://xiulijiangshan.net/base/bi2",11)
	require "BISystem"
	UpdateManager:CheckServerState(function ()
		if GetPlatform() == CC_PLATFORM_IOS then
			local url = UpdateManager.ad_callback_url
			if url ~= nil and url ~= "" then
				local function ad_callback(error_code, message)
					print("发送广告IDFA", error_code, message)
				end
				local device_info = IOSDispatcher:get_device_info()
			    if not device_info then
			    	return
				end
				local param = "idfa="..device_info["identifier"]
				local http_request = HttpRequest:new(url, param, ad_callback)
				http_request:send()
			end
		end
		local platform    = CCAppConfig:sharedAppConfig():getStringForKey("platformInterface")
		local no_update   = CCAppConfig:sharedAppConfig():getBoolForKey("no_update")
		local need_update = false
		if platform == "noplatform" then
			if no_update == false then
				need_update = true
			end
		else
			if UpdateManager.is_open_update == "0" then
				need_update = true
			end
		end
		if need_update then
			UpdateManager:start()
		else
			UpdateManager.no_update = true
			UpdateManager:finish()
		end
	end)
end


local function main()
	collectgarbage("setpause", 100)
	collectgarbage("setstepmul", 5000)

	scrpit_start( "http://xiulijiangshan.net/base/bi2",6)

	local root = ZXLogicScene:sharedScene()
	fix_screen(root)
	setCommonLanguage()
	_setupFont()
	_setupTextureCompress()
	CCDirector:sharedDirector():runWithScene(root)
	setIsShowMemoryUsage(ZXLuaUtils:isDesignPath())

	require "SlashScreenPlay"
	SlashScreenPlay(doStartGame)
	runMainCheckStep()

end

xpcall(main, __G__TRACKBACK__)
