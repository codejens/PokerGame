
PlatformApple_IOS_VERSION = "1.00.02"

local SlashScreenPlatformMap = 
{
	['MSDK']    = { 'nopack/platform_800_480.webp' },
	--['QQHall'] = { 'platform_800_480.pd', 'hoolai_800_480.pd' }
}

local PayVideo = 
{
	["Android"] = 1,
	["Ios"]		= 1,
}

local _cbfunc = nil

--清空资源，本来要加在LIONHEART里面，但要更新主文件，那暂时放在这里
function clearResourcePath_C( )
	--ZXLog('clearWriteablePath')
	require ('utils/MUtils')
	MUtils:toast_black('正在初始化',0xffffff,3)
	local p = CCFileUtils:getWriteablePath()
	print("clearResourcePath_C p:",p)
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
		__assetsmgr:removeWritablePathFile(p .. 'cache')
	end

	-- _workQueue[#_workQueue+1] = function()
	-- 	__assetsmgr:removeWritablePathFile(p .. 'frame')
	-- 	__assetsmgr:removeWritablePathFile(p .. 'icon')
	-- 	__assetsmgr:removeWritablePathFile(p .. 'map')
	-- end

	-- _workQueue[#_workQueue+1] = function()
	-- 	__assetsmgr:removeWritablePathFile(p .. 'nopack')
	-- 	__assetsmgr:removeWritablePathFile(p .. 'particle')
	-- end

	-- _workQueue[#_workQueue+1] = function()
	-- 	__assetsmgr:removeWritablePathFile(p .. 'scene')
	-- 	__assetsmgr:removeWritablePathFile(p .. 'ui')
	-- 	__assetsmgr:removeWritablePathFile(p .. 'ui2')
	-- end

	-- _workQueue[#_workQueue+1] = function()
	-- 	nextStage()
	-- end
end



function SlashScreen( root, cbfunc)
	local slashscreen_callback = callback:new()
	local delaytime = 1.25
	local screendelaytime = 2.0;

	local pic_array = nil
	local Platform = CCAppConfig:sharedAppConfig():getStringForKey('platformInterface')
	local show_video = CCUserDefault:sharedUserDefault():getIntegerForKey('is_show_video')

	if SlashScreenPlatformMap[Platform] then
		pic_array = SlashScreenPlatformMap[Platform]
	end
	local pf =  GetPlatform()

	local is_play_video = false

	local file_name = "font_video.mp4";
	-- if pf == CC_PLATFORM_ANDROID and PayVideo["Android"] == 1 and Platform ~= "ewanPlatform" and Platform ~= "HoolaiPlatform" then
	-- 	is_play_video = true
	-- elseif pf == CC_PLATFORM_IOS and PayVideo["Ios"] == 1 then
	-- 	file_name = "font_video"
	-- 	is_play_video = true
	-- end

	local function t_slashscreen_callback()
		if is_play_video == true and show_video == 0 then
			_cbfunc = cbfunc
			CCUserDefault:sharedUserDefault():setIntegerForKey('is_show_video', 1)
			payVideo(file_name)
		else
			cbfunc()
		end
	end

	if not pic_array then
		print("not pic_array")
		t_slashscreen_callback()
		return 
	end

	for i, slashscreenpath in ipairs(pic_array) do

		local slashscreen = CCSprite:spriteWithFile(slashscreenpath);
		slashscreen:reSize(GameScreenConfig.ui_screen_width,GameScreenConfig.ui_screen_height)
		local UIRoot = root:getUINode()
		local delay = CCDelayTime:actionWithDuration(screendelaytime + 0.5)
		local fade_out = CCFadeOut:actionWithDuration(0.5);
		--local move_ease_out = CCEaseIn:actionWithAction(fade_out,2.5);
		local removeact = CCRemove:action();
		local array = CCArray:array();
		array:addObject(delay)
		array:addObject(fade_out);
		array:addObject(removeact);
		local seq = CCSequence:actionsWithArray(array)
		slashscreen:setAnchorPoint(CCPointMake(0.0,0.0))
		slashscreen:runAction(seq)
		UIRoot:addChild(slashscreen,90000 - i)

		delaytime = delaytime + 1.5
		screendelaytime = screendelaytime + 2.5
	end
	slashscreen_callback:start(delaytime, t_slashscreen_callback )
end

function SlashScreen_after_path()
	if _cbfunc ~= nil then
		_cbfunc()
	end
end