--require 'utils/tablehelper'

SceneEffectManager = {}

--@debug_begin
--local SceneEffectConfigFile = '../SceneEffectConfig'
--local SaveFileAs = 'SceneEffectConfig'
--local SaveDataFile = 'resource/data/SceneEffectData'
--@debug_end
local GameDataFile = '../data/SceneEffectData'

local TYPEPAR = 0
local TYPEANIM = 1

local SE_TYPE = 1
local SE_FILE = 2
local SE_X = 3
local SE_Y = 4
local SE_RADIUS = 5
local SE_SCALE_X = 6
local SE_SCALE_Y = 7
local SE_SCALE_ROT = 8

--初始化根节点
function SceneEffectManager : init(root)
	--WeatherSystem : init(root)
	self.currentSceneID = nil
	self.currentConfig = nil
	self.root = root	
	--编辑器
	--self:loadEditor()
	--读取游戏
	self:loadGame()
	self.effects = {}
	self.scene = ZXGameScene:sharedScene()

	
end

--开启动画
function SceneEffectManager : enableEffectAnimation(b,f)
	if f == nil then
		f = true
	end
	if self.scene then
		self.scene:enableEffectAnimation(b,f)
	end
end

--开启粒子
function SceneEffectManager : enableParticles(b,f)
	if f == nil then
		f = true
	end
	if self.scene then
		self.scene:enableParticles(b,f)
	end
end

function SceneEffectManager : enableWeather(b)
	-- print('enable weather',self.currentConfig,self.currentSceneID,b)
	WeatherSystem.enable = b
	if b and self.currentConfig then
		WeatherSystem : enterScene(self.currentConfig)
	else
		WeatherSystem : leaveScene()
	end

	
end

--读取配置
function SceneEffectManager : loadGame()
	require(GameDataFile)
	self.config = SceneEffectData
end

function SceneEffectManager : readSceneGame(config)

end

function SceneEffectManager : enterScene(id)
	
	local config = self.config[id]
	self.currentSceneID = id
	self.currentConfig = config
	if config then
		--天气系统
		WeatherSystem : enterScene(config)
	end
	print('~~SceneEffectManager:enterScene',id,config)
	--编辑器读取
	--self:readSceneEditor(config)
	
	--读取到引擎
	if self.currentConfig and self.currentConfig.effects then
		ZXMap_ReadEffect(self.currentConfig.effects)
	end
end

function SceneEffectManager : leaveScene()
	-- print('SceneEffectManager:leaveScene',self.currentSceneID)
	WeatherSystem : leaveScene()

	self.currentSceneID = nil
	self.currentConfig = nil
	self.effects = {}
end

function SceneEffectManager : changeScene(sceneName)
	self:leaveScene()
	--self.root:removeAllChildrenWithCleanup(true)
	self:enterScene(sceneName)
end


function SceneEffectManager : changeWeather(weather)
	WeatherSystem:leaveScene()
	WeatherSystem:enterScene({['weather'] = weather})
end

function SceneEffectManager : quitScene()
	self:leaveScene()
	self:enableEffectAnimation(false)
	self:enableParticles(false)
	self.scene = nil
end


--切到后端
function SceneEffectManager : onPause()
	if self.scene then
		self:enableWeather(false)
		self:enableEffectAnimation(false)
		self:enableParticles(false)
	end

end
--重新切回前端
function SceneEffectManager : onResume()
	if self.scene then
		SetSystemModel:set_show_weather_effect()
		SetSystemModel:set_show_scene_animation()
		SetSystemModel:set_show_scene_effect()
	end
end
--@debug_begin
--[[
function SceneEffectManager : setConfig(key, value)
	if self.currentConfig == nil then
		self.currentConfig = {}
		self.currentConfig[key] = value
		self.config[self.currentSceneID] = self.currentConfig
	else
		self.currentConfig[key] = value
	end
end


function SceneEffectManager : setEffectConfig(key, value)
	if self.currentConfig == nil then
		self.currentConfig = { effects = {} }
		self.currentConfig.effects[key] = value
		self.config[self.currentSceneID] = self.currentConfig
	else
		if not self.currentConfig.effects then
			self.currentConfig.effects = {}
		end

		self.currentConfig.effects[key] = value
	end
end

function SceneEffectManager : getEffect(id)
	return self.effects[id]
end



function SceneEffectManager : addEffects(id, info)
	self.effects[id] = info
end

function SceneEffectManager : removeEffect(id)
	self.effects[id].effect:removeFromParentAndCleanup(true)
	self.effects[id] = nil
end



function SceneEffectManager:createAnimation(info)
	--初始化动画
	local spriteParent = CCNode:node()
	local anim = ZXAnimation:createWithFileName(info.file)
	anim:createZXAnimationAction(-1.0)

	local animSprite = ZXAnimateSprite:createWithFileAndAnimation("", anim)

	--animSprite:registerScriptHandler(print)

	spriteParent:addChild(animSprite,info.gl_pos.y * 100)
	spriteParent:setPosition(info.gl_pos.x,info.gl_pos.y)
	spriteParent:setScaleX(info.scaleX)
	spriteParent:setScaleY(info.scaleY)
	spriteParent:setRotation(info.rot)
	
	
	self.root:addChild(spriteParent)
	
	SceneEffectManager:addEffects(  info.tag, 
									{ 
									  ['info'] = info, 
								      ['effect'] = spriteParent 
								  	})

	print('SceneEffectManager:createAnimation',info.file,info.gl_pos.x,info.gl_pos.y)
end

function SceneEffectManager:createParticle(info)

	local p = CCParticleSystemQuadEx:particleWithFile(info.file)
	local winSize = CCDirector:sharedDirector():getWinSize();

	p:setPositionType(1)
	p:setPosition(info.gl_pos.x,info.gl_pos.y)
	p:setBoundRange(winSize.width)
	p:setScaleX(info.scaleX)
	p:setScaleY(info.scaleY)
	p:setRotation(info.rot)
	
	
	self.root:addChild(p, info.gl_pos.y * 100)

	self:addEffects(info.tag, 
					{ 
						['info'] = info, 
						['effect'] = p 
					})

	print('SceneEffectManager:createParticle',info.file,info.gl_pos.x,info.gl_pos.y)
end


--读取配置
function SceneEffectManager : loadEditor()
	require(SceneEffectConfigFile)
	self.config = SceneEffectConfig
end

--重新载入配置
function SceneEffectManager : reload()
	if self.config then
		for k,v in pairs(self.config) do
			print(k,v)
		end
	end

	reloadfile(SceneEffectConfigFile)
	
	self.config = SceneEffectConfig

	for k,v in pairs(self.config) do
		print(k,v)
	end
end

--
function SceneEffectManager : readSceneEditor(config, all)
	--全部读取
	if config and config.effects then
		for k, info in pairs(config.effects) do
			if info.type == 'par' then
				self:createParticle(info)
			else
				self:createAnimation(info)
			end
		end
	end
end


function SceneEffectManager : save()

	local s = table_serialize(self.config)
	--print('SceneEffectManager:save',s)
	local f = io.open(SaveFileAs .. '.lua','w+')
	f:write('SceneEffectConfig = ' .. s)
	f:close()
	
	local datafile = {}
	for mapid, mapinfo in pairs(self.config) do
		local mapdata = {}
		if mapinfo.weather then
			mapdata.weather = mapinfo.weather
		end

		if mapinfo.effects then
			mapdata.effects = {}
			for effectid,effectinfo in pairs(mapinfo.effects) do
				local eData = {}
				if effectinfo.type == 'par' then
					eData[SE_TYPE] = TYPEPAR
				elseif effectinfo.type == 'anim' then
					eData[SE_TYPE] = TYPEANIM
				end
				
				eData[SE_FILE] = effectinfo.file
				eData[SE_X] = effectinfo.map_pos.x
				eData[SE_Y] = effectinfo.map_pos.y
				eData[SE_RADIUS] = effectinfo.radius
				eData[SE_SCALE_X] = effectinfo.scaleX
				eData[SE_SCALE_Y] = effectinfo.scaleY
				eData[SE_SCALE_ROT] = effectinfo.rot			
				
				mapdata.effects[#mapdata.effects+1] = eData
				
			end
		end
		datafile[mapid] = mapdata
	end

	local s = table_serialize(datafile)
	local f = io.open(SaveDataFile .. '.lua','w+')
	f:write('SceneEffectData = ' .. s)
	f:close()
	
	
end
]]--
--@debug_end