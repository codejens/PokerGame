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
require 'utils/Utils'
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

--进入游戏
local function introStep()
	require 'Intro'
	local root = ZXLogicScene:sharedScene()
	Intro:start(root,runMainCheckStep)

end

--检查数据
local function runMainScreenStep()
	checkApkVersion(introStep)
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
		ZXResMgr:sharedManager():initFontInfo("华文黑体", fontSize, 0, 0, 512, 512, 1, 6408, 0xffffff )
		ZXResMgr:sharedManager():initAndroidFontInfo(1.5, 0.0, -3.0, 3)
		ZXResMgr:sharedManager():initTextShadowInfo(0, 0, 1.2, 0xff000000)

	elseif pf == CC_PLATFORM_IOS then
		ZXResMgr:sharedManager():initFontInfo("华文黑体", fontSize, 0, 0, 512, 512, 1, 6408, 0xffffff )
		ZXResMgr:sharedManager():initTextShadowInfo(0, 0, 1.2, 0xff000000)
		if ZXIsiPad() then
			-- ipad 字体缩小
			ZXResMgr:sharedManager():initAndroidFontInfo(1.0, 0.0, -3.0, 0)
		else
			ZXResMgr:sharedManager():initAndroidFontInfo(1.5, 0.0, -3.0, 4)
		end

	elseif pf == CC_PLATFORM_ANDROID then
		ZXResMgr:sharedManager():initFontInfo("Droid Sans Fallback", fontSize, 0, 0, 512, 512, 1, 6408, 0xffffff )
		ZXResMgr:sharedManager():initAndroidFontInfo( 1.5, 0.0, -2.0, 6 )
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
		if CCDirector:sharedDirector():isRetinaDisplay() then
			if GameScaleFactors.ui_scale_factor >= 1.5 then
		   		_mid_resolution()
		   	else
		   		_mid_resolution()
			end
		else
			_mid_resolution()
		end

	elseif pf == CC_PLATFORM_ANDROID then 
		--屏幕大1.5倍不压缩纹理 960x640
		if GameScaleFactors.ui_scale_factor >= 1.5 then
			_mid_resolution()

		elseif GameScaleFactors.ui_scale_factor >= 1.0 then
			_mid_resolution()

		else
			_low_resolution()
		end
		CCZXLabel:enableGradient(true)
	else
		_mid_resolution()
		CCZXLabel:enableGradient(true)
	end
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


BODY_PART_NAME =
{
	[0] = '身体',
	[1] = '武器',
	[2] = '武器特效',
	[3] = '坐骑',
	[4] = '翅膀',
	[5] = '法宝',
}

ENEITY_PART_BODY    = 0
ENEITY_PART_WEAPON  = 1
ENEITY_PART_WEAPON_EFFECT  = 2
ENEITY_PART_MOUNT  = 3
ENEITY_PART_WING   = 4
ENEITY_PART_FABAO  = 5


local function main()
	-- avoid memory leak
	collectgarbage("setpause", 100)
	collectgarbage("setstepmul", 5000)

	local root = ZXLogicScene:sharedScene()
	--fix_screen(root)
	setCommonLanguage()
	_setupFont()
	_setupTextureCompress()
	CCDirector:sharedDirector():runWithScene(root)
	require_main()

	require 'ResourceManager'
	ResourceManager:loadAnimationEditor()
	
	require "UIResourcePath"
	require "UI/UIStyle"
-- 通用控件
	require "UI/commonwidge/base/ZAbstractNode"
	require "UI/commonwidge/ZBasePanel"
	require "UI/commonwidge/ZButton"
	require "UI/commonwidge/ZDialog"
	require "UI/commonwidge/ZEditBox"
	require "UI/commonwidge/ZImage"
	require "UI/commonwidge/ZImageButton"
	require "UI/commonwidge/ZImageImage"
	require "UI/commonwidge/ZLabel"
	require "UI/commonwidge/ZRadioButtonGroup"
	require "UI/commonwidge/ZScroll"
	require "UI/commonwidge/ZTextButton"
	require "UI/commonwidge/ZTextImage"
	require "UI/commonwidge/ZCCSprite"
	require "UI/commonwidge/ZCheckBox"
	require "UI/commonwidge/ZList"
	require "UI/commonwidge/ZListVertical"
	require "UI/commonwidge/ZProgress"

	require 'anim_editor/anim_actor'
	require 'anim_editor/anim_editor'
	require 'anim_editor/anim_editor_prop'
	require 'anim_editor/anim_edit_body_slot'
	require 'anim_editor/anim_edit_slot'
	--require 'anim_editor/anim_edit_slot'
	require 'config/EntityActionConfig'

	anim_edit_body_slot:init()
	animActor:init()
	animEditProp:init()
	anim_editor:init()
	--anim_edit_wing_slot:init()

	local winSize = CCDirector:sharedDirector():getWinSize();
	local x = winSize.width * 0.5
	local y = winSize.height * 0.5

	local _body = CCAppConfig:sharedAppConfig():getStringForKey("default_body")
	local _wing = CCAppConfig:sharedAppConfig():getStringForKey("default_wing")
	local _weapon = CCAppConfig:sharedAppConfig():getStringForKey("default_weapon")
	local _effcet = CCAppConfig:sharedAppConfig():getStringForKey("default_effect")

	anim_editor:loadBodySlot(_body)
	anim_editor:loadSlot(_wing,'wing')
	anim_editor:loadSlot(_weapon,'weapon')
	if _effcet ~= '' then
		anim_editor:loadSlot(_effcet,'effect')
	end
	anim_edit_body_slot:select(1)
	--animActorManager:init()
	--local actor = animActorManager:createBody('main',x,y,1)

	--[[
	actor.model:putOnWing('frame/wing/1')
	callback:new():start(1.0, function ()
		local frames = actor.model:getFramsStepOfPart(0)
		anim_edit_body_slot:build(0,frames)
		local frames = actor.model:getFramsStepOfPart(4)
		anim_edit_body_slot:build(4,frames)
	end)

	
	animActorManager:changePart(ENEITY_PART_BODY,'frame/human/0/01000')
	]]--
	--animActorManager:changePart(ENEITY_PART_WING,'frame/wing/1')

---------------------------
    local _ui_root =  ZXLogicScene:sharedScene():getUINode()
    local _scene_root = ZXLogicScene:sharedScene():getSceneNode()
    local _entity_root = ZXLogicScene:sharedScene():getEntityNode()

	local _funcNil = function(...) return true end

	local last_x = nil
	local last_y = nil


	VK_LEFT     =     0x25
	VK_UP       =     0x26
	VK_RIGHT    =     0x27
	VK_DOWN     =     0x28
	VK_CONTROL  =     0x11
	VK_MENU     =     0x12
	VK_F1  		=     0x70
	VK_F2  		=     0x71

	local _uiTouch = function(e,x,y)
		--begin
		if e == 0 then
			last_x = x
			last_y = y
		--move
		elseif e == 1 then
			if not last_x then
				last_x = x
			end
			if not last_y then
				last_y = y
			end
			local dx = x - last_x
			local dy = y - last_y

			if GetKeyDown(VK_CONTROL) then
				anim_editor:move_slot(dx,dy)

			elseif GetKeyDown(VK_MENU) then
				anim_editor:rotate_slot(dx,dy)
			end
			--[[elseif GetKeyDown(string.byte('E')) then
				anim_editor:scale_slot(dx,dy)
			end
			]]--

			last_x = x
			last_y = y
		--end
		elseif e == 2 then
			last_x = x
			last_y = y
		end
		return true 
	end

    _ui_root:registerScriptTouchHandler(_uiTouch, false, 0, false)
    _scene_root:registerScriptTouchHandler(_funcNil, false, 0, false)
    _entity_root:registerScriptTouchHandler(_funcNil, false, 0, false)
---------------------------
end

xpcall(main, __G__TRACKBACK__)