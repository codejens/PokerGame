
local WeatherLayer = 400
local WinHeight = nil
local WinWidth = nil
require 'scene/WeatherConfig'
super_class.Weather()

function Weather_setWinSize(w,h)
	WinHeight = h
	WinWidth  = w
end
function Weather : __init(root, info)
	self.currentWeather = {}
	self.root = root 
	self.info = info
	self.repositionTimer = timer()
end

function Weather : enter()
	for i, file in pairs(self.info.file) do
		self:load(file,self.info)
	end

	self.repositionTimer:stop()
	print('>>', self.repositionTimer.scheduler_id)
	print('>>',self.tick)
	self.repositionTimer:start(self.info.tick,bind(self.tick,self))
end

function Weather : leave()
	for k,v in pairs(self.currentWeather) do
		v:removeFromParentAndCleanup(true)
	end
	self.currentWeather = {}
	self.repositionTimer:stop()
end

function Weather : reset()
	for k,v in pairs(self.currentWeather) do
		v:resetSystem()
	end
end

super_class.Snow(Weather)

function Snow:__init(root, files)
	
end

function Snow:load(file, info)
	local p = CCParticleSystemQuadEx:particleWithFile(file)
	--相对模式
	p:setPositionType(1)
	--屏幕顶端
	p:setPosition(0,WinHeight / 2.0)
	p:setBoundRange(WinWidth)
	p:setPosVar(CCPointMake(WinWidth/2,0))

	self.root:addChild(p, WeatherLayer + #self.currentWeather)
	self.currentWeather[#self.currentWeather+1] = p
end

function Snow:tick(dt)
	local cam_pos 		= ZXGameScene:sharedScene():getCameraPositionInPixels()
	for k,v in pairs(self.currentWeather) do
		v:setSourcePosition(cam_pos)
	end
end


super_class.Lava(Weather)

function Lava:__init(root, files)
	
end

function Lava:load(file,info)
	local p = CCParticleSystemQuadEx:particleWithFile(file)
	--相对模式
	p:setPositionType(1)
	--屏幕顶端
	p:setPosition(0,-WinHeight / 2.0 + info.offset )
	p:setBoundRange(WinWidth)
	self.root:addChild(p, WeatherLayer + #self.currentWeather)
	self.currentWeather[#self.currentWeather+1] = p
end

function Lava:tick(dt)
	local cam_pos 		= ZXGameScene:sharedScene():getCameraPositionInPixels()
	local hw = WinWidth/2.0
	local offset =  math.random( -hw + self.info.offset, hw - self.info.offset )
	cam_pos.x = cam_pos.x + offset

	for k,v in pairs(self.currentWeather) do
		v:setSourcePosition(cam_pos)
	end
end

WeatherSystem = {}

function WeatherSystem : init(root)
	self.root = root
	self.curWeather = nil
	self.winSize = CCDirector:sharedDirector():getWinSize();

	WinHeight = self.winSize.height
	WinWidth = self.winSize.width
	self.enable = true
	
end

function WeatherSystem : enterScene(config)
	if self.enable and config.weather and  config.weather ~= '' then
		if self.curWeather ~= nil then
			self:leaveScene()
		end
		self.curWeather = WeatherConfig:create(self.root,config.weather)
		self.curWeather:enter()
		print(config.weather)
	else
		print('no weather')
	end
end


function WeatherSystem : reset()
	if self.curWeather then 
		self.curWeather:reset()
	end
end

function WeatherSystem : reset()
	if self.curWeather then 
		self.curWeather:reset()
	end
end

function WeatherSystem : leaveScene()
	if self.curWeather then 
		self.curWeather:leave()
	end
	self.curWeather = nil
end