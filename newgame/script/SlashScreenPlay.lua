--SlashScreenPlay.lua
--启动播放

local next_func = nil

function Video_Play_Finish()
	scrpit_start( "http://xiulijiangshan.net/base/bi2",10)
	SlashScreenClose()
	if next_func then
		next_func()
		next_func = nil
	end
end

function SlashScreenPlay(cbfunc1)
	next_func         = cbfunc1

	local scene_root  = ZXLogicScene:sharedScene()
	local ui_root     = scene_root:getUINode()
	local slashscreen = CCBasePanel:panelWithFile(0, 0, GameScreenConfig.ui_screen_width, 
		                GameScreenConfig.ui_screen_height, "nopack/SlashScreen/bg.png", 500, 500)
	ui_root:addChild(slashscreen, 0xffffff+1, 666666)

	--logo路径
	local logo_path = "nopack/SlashScreen/logo1.png"
	local paltform = CCAppConfig:sharedAppConfig():getStringForKey("lh_channel")
	local is_65 = CCAppConfig:sharedAppConfig():getStringForKey("is_65")
	if paltform == "platform_u9" or paltform == "platform_iqiyi_ios" or paltform == "platform_u9_iospb" then
		logo_path = "nopack/SlashScreen/logo2.png"
	-- elseif paltform == "platform_65" then
	-- 	logo_path = "nopack/SlashScreen/logo3.png"
	end
	if is_65 == "true" then
		logo_path = "nopack/SlashScreen/logo3.png"
	end

	local logo = CCSprite:spriteWithFile(logo_path)
	logo:setAnchorPoint(CCPointMake(0.5,0.5))
	logo:setPosition(GameScreenConfig.ui_screen_width/2,GameScreenConfig.ui_screen_height/2)
	slashscreen:addChild(logo, 1, 123)

	--默认闪屏时间
	local slash_time  = 2.0
	if paltform == "platform_baidu" then
		slash_time = 6.0
	end
	local function callbackfun()
		scrpit_start( "http://xiulijiangshan.net/base/bi2",7)
		local cha_time   = 0
		local delay_time = slash_time-0.6
		local delay      = nil
		if cha_time < delay_time then
			delay        = CCDelayTime:actionWithDuration(delay_time-cha_time)
		end
		local fade_out  = CCFadeOut:actionWithDuration(0.5)
		local removeact = CCRemove:action()
		local array     = CCArray:array()
		if delay then
			array:addObject(delay)
		end
		array:addObject(fade_out)
		array:addObject(removeact)
		local seq = CCSequence:actionsWithArray(array)
		logo:runAction(seq)

		local function callbackfun1()
			scrpit_start( "http://xiulijiangshan.net/base/bi2",9)
			local slashscreen_callback1 = callback:new()
			slashscreen_callback1:start(0.50, function ()
				if GetPlatform() == CC_PLATFORM_IOS then
					local json = "{\"funcID\":\"save_video_finish_callback\"}"
					IOSBridgeDispatcherAsync(json, Video_Play_Finish)
					-- payVideo("font_video.mp4")
					--Video_Play_Finish()
				-- elseif GetPlatform() == CC_PLATFORM_ANDROID then
					-- payVideo("font_video.mp4")
					--Video_Play_Finish()
				else
					Video_Play_Finish()
				end
			end)
			local slashscreen_callback2 = callback:new()
			slashscreen_callback2:start(0.55, function ()
				SlashScreenClose()
			end)
		end
		local function callbackfun2()
			scrpit_start( "http://xiulijiangshan.net/base/bi2",8)
			slashscreen:removeChildByTag(123, true)
			local logo1 = CCSprite:spriteWithFile("nopack/SlashScreen/logo.png")
			logo1:setAnchorPoint(CCPointMake(0.5, 0.5))
			logo1:setPosition(GameScreenConfig.ui_screen_width/2,GameScreenConfig.ui_screen_height/2)
			slashscreen:addChild(logo1)
			callbackfun1()
		end
		local slashscreen_callback2 = callback:new()
		slashscreen_callback2:start(delay_time-cha_time+0.5, callbackfun2)
	end
	local slashscreen_callback = callback:new()
	slashscreen_callback:start(0.1, callbackfun)
end

function SlashScreenClose()
	local scene_root  = ZXLogicScene:sharedScene()
	local ui_root     = scene_root:getUINode()
	ui_root:removeChildByTag(666666, true)
end

AppMessages = {}
function AppMessages.OnAsyncMessage(id, msg)
	if id == 50000 then
		local ret = false
		require "json/json"
		local jtable = {}
		local s,e = pcall(function() jtable = json.decode(msg) end)
		local message_type = jtable["message_type"] or ""
		if message_type == "appGameMsg" then
			local func_type = jtable["funcType"] or ""
			if func_type == "video_finish" then
				Video_Play_Finish()
			end
		end
	end
end