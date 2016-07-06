application = {}


-- 游戏自适应的屏幕像素值
GameScreenFactors = {
	-- 标准设计屏幕大小
	standard_width  = 960,
	standard_height = 640,
	-- 标准半屏
	standard_half_width  = 480,
	standard_half_height = 320,
	-- 适应屏幕，设置期望的镜头大小
	-- 这里取的是地图心魔幻境第一层
	-- lp todo  这里要根据什么定？
	min_scene_width  = 1136,			
	min_scene_height = 640,	

	ipad_width = 1024,
	ipad_height = 768,
	ipad_ret_width = 2048,
	ipad_ret_height = 1536,
	iphone5_width = 1136,	

	ui_width = 960,
	ui_height = 640,	
}

-- 游戏自适应用到的缩放比
GameScaleFactors = {
	-- 实际场景与UI缩放比
	viewPort_ui_x = 0, 
	viewPort_ui_y = 0,
	-- UI缩放比
	ui_x = 0,
	ui_y = 0,
	-- 场景缩放比
	viewPort_x = 0,
	viewPort_y = 0,
}

frameSize = cc.Director:getInstance():getOpenGLView():getFrameSize()

function ZXIsiPad()

	if GameScreenFactors.is_iPad == nil then
		if frameSize.width == GameScreenFactors.ipad_width or frameSize.width == GameScreenFactors.ipad_ret_width then
			GameScreenFactors.is_iPad = true
			return GameScreenFactors.is_iPad
		else
			return false
		end
	else
		return GameScreenFactors.is_iPad
	end

end
local function fix_screen( root )
	-- 适应所有屏幕 我fix_screen们所有的ui以960, 640为标准
	root:setAnchorPoint( 0, 0 )
	-- local winSize = cc.Director:getInstance():getWinSize();
	-- local winSize = cc.Director:getInstance():getOpenGLView():getFrameSize()
	local getVisibleSize = cc.Director:getInstance():getVisibleSize()
	
    print('winSize>>',winSize.height,winSize.width);
	-- print(">>>>>>>>>>>>>>frameSize",frameSize.width,frameSize.height)
	print(">>>>>>>>>>>>>>getVisibleSize",getVisibleSize.width,getVisibleSize.height)
	-- 适应屏幕，设置期望的镜头大小
	local min_scene_width  = GameScreenFactors.min_scene_width		-- 这里取的是地图心魔幻境第一层 lp todo 为什么是 心魔幻境?
	local min_scene_height = GameScreenFactors.min_scene_height

	local fix_viewport_width  = GameScreenFactors.standard_width		-- 标准分辨率
	local fix_viewport_height = GameScreenFactors.standard_height

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
	print("fix_viewport_width=",fix_viewport_width,fix_viewport_height)

	-- 然后需要考虑是否需要scale
	local scale_width  = winSize.width  / fix_viewport_width
	local scale_height = winSize.height / fix_viewport_height
	
	local scale = scale_height
	if scale_width > scale_height then
		scale = scale_width
	end
	print("scale=",scale)

	GameScaleFactors.viewPort_x = scale
	GameScaleFactors.viewPort_y = scale

	GameScaleFactors.viewPort_ui_x = fix_viewport_width  / GameScreenFactors.standard_width
	GameScaleFactors.viewPort_ui_y = fix_viewport_height / GameScreenFactors.standard_height

	if ZXIsiPad() then
		fix_viewport_width = fix_viewport_width - 150
		print("---------ZXIsiPad--------------",scale)
	end

	GameScreenFactors.viewPort_width = fix_viewport_width
	GameScreenFactors.viewPort_height = fix_viewport_height
	print("fix_viewport_width, fix_viewport_height, scale=",fix_viewport_width, fix_viewport_height, scale)
	root:setViewPortSize(fix_viewport_width, fix_viewport_height, scale)

	--界面缩放和计算
	----------------------------------------------------
	--计算缩放比
	local wFactor = winSize.width / GameScreenFactors.ui_width
	local hFactor = winSize.height / GameScreenFactors.ui_height

	GameScaleFactors.ui_scale_factor = math.min(wFactor,hFactor)
	---------------------------------------------------
	print("ui_scale_factor=",GameScaleFactors.ui_scale_factor)
	GameScreenFactors.ui_screen_width  = math.floor(winSize.width  / GameScaleFactors.ui_scale_factor)
	GameScreenFactors.ui_screen_height = math.floor(winSize.height / GameScaleFactors.ui_scale_factor)

	root:getUINode():setScale(GameScaleFactors.ui_scale_factor)
	

	GameScaleFactors.screen_to_ui_factorX = GameScreenFactors.ui_screen_width / winSize.width
	GameScaleFactors.screen_to_ui_factorY = GameScreenFactors.ui_screen_height / winSize.height
	print("GameScaleFactors.screen_to_ui_factorX=",GameScaleFactors.screen_to_ui_factorX,GameScaleFactors.screen_to_ui_factorY)
	print('Scene=',scale)
	print('scaleFactor',GameScaleFactors.ui_scale_factor)
	print('winSize', winSize.width, winSize.height)
	print('gameSize', GameScreenFactors.ui_screen_width, GameScreenFactors.ui_screen_height)

	GameScreenFactors.winSize_width = winSize.width
	GameScreenFactors.winSize_height = winSize.height

	-- cc.Director:getInstance():getOpenGLView():setFrameSize(winSize.width,winSize.height)
	-- print("cc.Director:getInstance():getWinSize()=",cc.Director:getInstance():getWinSize().width,cc.Director:getInstance():getWinSize().height)
	-- print("GameScreenFactors.viewPort_width,GameScreenFactors.viewPort_height=",GameScreenFactors.viewPort_width,GameScreenFactors.viewPort_height)
	-- print("GameScaleFactors.viewPort_ui_x,GameScaleFactors.viewPort_ui_y=",GameScaleFactors.viewPort_ui_x,GameScaleFactors.viewPort_ui_y)
end


function application:init()
	require 'gamecore.state.game_state_manager'
	require 'gamecore.appConfig'
	require "gamecore.resourse_path_config"
	require "gamecore.notice_marco"
	require "gamecore.update_marco"

    -- 随机函数只需要一次 seed
    math.randomseed(os.time())

	cocosEventHelper.listenAppEvents(application.onAppEvent)
	cocosHelper.listenKeyboardEvent( cc.Handler.EVENT_KEYBOARD_RELEASED, application.onKeyboardEvent )
	self:init_ui()
end

function application:init_ui(  )
	 -- 拉伸适应屏幕
	 print("init_ui>>>>>>>>cc.Director:getInstance():getWinSize()=",cc.Director:getInstance():getWinSize().width,cc.Director:getInstance():getWinSize().height)

	cc.Director:getInstance():getOpenGLView():setDesignResolutionSize(winSize.width,winSize.height, cc.ResolutionPolicy.EXACT_FIT)
print("cc.Director:getInstance():getWinSize()=",cc.Director:getInstance():getWinSize().width,cc.Director:getInstance():getWinSize().height)
	
	-- 这里会创建一个游戏最上层的渲染根节点，所有的游戏需要渲染的节点都是从这个节点下添加的。
	-- 根节点必须由ZXLogicScene创建，因为这个场景自身包含了3个节点，sceneNode,entityNode,UINode
	-- 由引擎本身去控制这三层父节点的行为
	local root = scene.XLogicScene:sharedScene()
	fix_screen(root)
	cc.Director:getInstance():runWithScene(root)
	print("cc.Director:getInstance():getWinSize()=",cc.Director:getInstance():getWinSize().width,cc.Director:getInstance():getWinSize().height)
	
end

function application:run()
	-- avoid memory leak  
	collectgarbage("setpause", 100)   
	collectgarbage("setstepmul", 5000)  

	-- lp todo 设置版本

	-- lp todo 设置生成唯一id并保存

	self:init()
	gameStateManager:init()
	gameStateManager:setState(initialState)
end


function application.onAppEvent(event, code, msg)
	gameStateManager:onAppEvent(event,code,msg)
end

function application.onKeyboardEvent( event, code, msg )
	print( event, code, msg )
	if event == 47 then    -- f1
        reload( 'test.RefreshForTest' )
	end
end