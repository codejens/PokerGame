Intro = { particles = {} }

local _root = nil
local _scene_root = nil
local _scene_root_2 = nil
local _scene_root_3 = nil

local _background = nil
local _callbacks = {}
local _fire_particles = {}
local _boss = nil
local _front_fire = nil
local _thunder = nil
local _bossLighting = nil
local _boss_noise = nil
local _houses = nil
local _speed_line = nil

local _backgroundLayer = 0
local _thunderLayer = 1
local _houseLayer = 2
local _bossLayer = 3
local _boss_nosie_Layer = 4
local _front_fireLayer = 99
local _fireLayer = 100
local _eyeLayer = 10
local _role_layer = 101
local _speedLayer = 102
local _proLayer = 103
local _touchRoot = nil
local _finishCallback = nil
local _clicks = 2
require 'utils/binder'
------------------------
--
------------------------
_TimeLerp = simple_class()

function _TimeLerpTick(obj,dt)
	obj.t_pass = obj.t_pass + dt
	local t = obj.t_pass / obj.t_dur
	if t > 1.0 then
		obj.timer:stop()
		obj.cb(1.0)
		return
	end
	obj.cb(t)
end

function _TimeLerp:__init()
	self.timer = timer()
	self.cb = nil
	self.time_pass = 0
end

function _TimeLerp:start(tick, dur, cb)
	self.t_pass = 0
	self.t_dur = dur
	self.cb = cb
	self.timer:stop()
	self.timer:start(tick,bind(_TimeLerpTick,self))
end

function _TimeLerp:stop()
	self.timer:stop()
end

--0.25秒眼睛！
--0.5秒出现火焰
--1.0秒出现村庄和boss剪影
function _intro_boss(_delayBoss,_delayBoss2)
	local _eyecallback = callback:new()
	_eyecallback:start(_delayBoss,function()
		ZXLog('_intro_boss')
		local p1 = CCParticleSystemQuad:particleWithFile('ui2/intro/right_eye.plist')
		p1:setPosition(CCPointMake(582,335+55))
		_scene_root:addChild(p1,_eyeLayer)

		local p2 = CCParticleSystemQuad:particleWithFile('ui2/intro/left_eye.plist')
		p2:setPosition(CCPointMake(490,352+55))
		_scene_root:addChild(p2,_eyeLayer)
	end)

	local _bosscallback = callback:new()
	_bosscallback:start(_delayBoss2,function()
		--boss逐渐出现
		_boss:setIsVisible(true)
		_boss:setAnchorPoint(CCPointMake(0,0))
		_boss:setColor(ccc3(0,0,0))
		local t0 = CCTintBy:actionWithDuration( 0.5, 25,25,25 )
		_boss:runAction(t0)
		_boss:setPosition(CCPointMake(0,55))

		_boss:setOpacity(0)
		local fade_0 = CCFadeTo:actionWithDuration(2.0,255)
		local action = CCEaseOut:actionWithAction(fade_0,2);
		_boss:runAction(action)


	end)

	_callbacks[_bosscallback] = true
end

function _intro_fire(_delay,_delay2)
	local cb = callback:new()
	cb:start(_delay, function()
		_intro_front_fire()
	end)
	local cb = callback:new()
	cb:start(_delay2, function()
		local p1 = CCParticleSystemQuad:particleWithFile('ui2/intro/fire01.plist')
		_scene_root:addChild(p1,_fireLayer)

		local p0 = CCParticleSystemQuad:particleWithFile('ui2/intro/fire02.plist')
		_scene_root:addChild(p0,_fireLayer)

		local p0 = CCParticleSystemQuad:particleWithFile('ui2/intro/biggerFire.plist')
		_scene_root:addChild(p0,_fireLayer)
		_fire_particles[p0] = true
		_fire_particles[p1] = true
	end)

	_callbacks[cb] = true
end

local _create4Flow = effectCreator.create4Flow

function _intro_front_fire()
		ZXLog('_intro_front_fire')

		_front_fire:setIsVisible(true)
	    local t0 = CCTintBy:actionWithDuration( 0.7, -12,-32, 0 )
	    local t1 = CCTintBy:actionWithDuration( 0.7, 0, 32, -2 )
	    local t2 = CCTintBy:actionWithDuration( 0.7, 12, 0, 2 )
		local array = CCArray:array();
		array:addObject(t0)
		array:addObject(t1)
		array:addObject(t2)
		local seq = CCSequence:actionsWithArray(array);
		local rep = CCRepeatForever:actionWithAction(seq)
		
		local fade_0 = CCFadeTo:actionWithDuration(2.0,255)
		_front_fire:setOpacity(0)
		_front_fire:setAnchorPoint(CCPointMake(0,0))

		--[[
		_front_fire:setPosition(CCPointMake(0,-200))
		local array = CCArray:array();
		array:addObject(CCMoveBy:actionWithDuration(1.0,CCPointMake(0,0)))
		array:addObject()
		local seq = CCSequence:actionsWithArray(array);
		]]--

		local move = CCMoveBy:actionWithDuration(6.0,CCPointMake(-64,0))
		_front_fire:runAction(move)
		_front_fire:runAction(seq)
		_front_fire:runAction(fade_0)
		_front_fire:runAction(rep)


		local _f_move_callback = callback:new()
		_f_move_callback:start(2.0, function()

		    local t0 = CCScaleTo:actionWithDuration( 2, 1.01 )
		    local t1 = CCScaleTo:actionWithDuration( 2, 1.0 )
			local array = CCArray:array();
			array:addObject(t0)
			array:addObject(t1)
			local seq = CCSequence:actionsWithArray(array);
			local rep = CCRepeatForever:actionWithAction(seq)
		    _front_fire:runAction(rep)
	   	end)
	    _callbacks[_f_move_callback] = true
end

function _intro_village(_delay)
	local _bg_callback = callback:new()
	_bg_callback:start(_delay, function()
		_background = CCSprite:spriteWithFile('ui2/intro/village.jpg')
		_background:setAnchorPoint(CCPointMake(0,0))
		--[[
		local fade_0 = CCFadeTo:actionWithDuration(1.5,200)
		local fade_1 = CCFadeTo:actionWithDuration(1.0,175)
		local array = CCArray:array();
		array:addObject(fade_0)
		array:addObject(fade_1)
		array:addObject(fade_2)
		
		local seq = CCSequence:actionsWithArray(array);
		]]--
		
		local fade_2 = CCFadeTo:actionWithDuration(3.0,255)
		_background:setOpacity(0)
		_background:runAction(fade_2)
		local move = CCMoveBy:actionWithDuration(20.0,CCPointMake(64,0))
		_houses = CCSprite:spriteWithFile('ui2/intro/houses.png')
		_houses:setPosition(CCPointMake(-64,0))
		_houses:setAnchorPoint(CCPointMake(0,0))
		_houses:runAction(move)
		local fade_0 = CCFadeTo:actionWithDuration(4.0,255)
		_houses:setOpacity(0)
		_houses:runAction(fade_0)
	    local t0 = CCTintBy:actionWithDuration( 1.0, 0,-255, -255 )
	    local t1 = CCTintBy:actionWithDuration( 1.0, 0, 255, 0 )
	    local t2 = CCTintBy:actionWithDuration( 1.0, 0, 0, 255 )
		local array = CCArray:array();
		array:addObject(t0)
		array:addObject(t1)
		array:addObject(t2)
		local seq = CCSequence:actionsWithArray(array);
		local rep = CCRepeatForever:actionWithAction(seq)
		_houses:runAction(rep)

		_scene_root:addChild(_background,_backgroundLayer)
		_scene_root:addChild(_houses,_houseLayer)

		ZXLog('end _intro_village')
	end)
	_callbacks[_bg_callback] = true

end

local function _intro_thunder(_delay)
	local _thunder_callback = callback:new()

	_thunder_callback:start(_delay, function()

		_thunder:setIsVisible(false)
		_thunder:setAnchorPoint(CCPointMake(0,0))
		_thunder:setPosition(CCPointMake(0,105))


		local array = CCArray:array();
		array:addObject(CCHide:action())
		array:addObject(CCDelayTime:actionWithDuration(0.05))
		array:addObject(CCShow:action())
		array:addObject(CCDelayTime:actionWithDuration(0.1))
		array:addObject(CCHide:action())
		array:addObject(CCDelayTime:actionWithDuration(0.1))
		array:addObject(CCShow:action())
		array:addObject(CCDelayTime:actionWithDuration(0.4))
		array:addObject(CCHide:action())
		array:addObject(CCDelayTime:actionWithDuration(0.8))
		local seq = CCSequence:actionsWithArray(array);
		local rep = CCRepeatForever:actionWithAction(seq)
		_thunder:runAction(rep)


		local array = CCArray:array();
		array:addObject(CCScaleTo:actionWithDuration(0.1,1.5))
		array:addObject(CCScaleTo:actionWithDuration(0.1,1.0))
		array:addObject(CCScaleTo:actionWithDuration(0.1,1.3))
		array:addObject(CCScaleTo:actionWithDuration(0.1,1.0))
		local seq = CCSequence:actionsWithArray(array);
		_thunder:runAction(seq)

		_boss:stopAllActions()
		_boss:setColor(ccc3(255,255,255))

		_bossLighting:setAnchorPoint(CCPointMake(0,0))
		_bossLighting:setIsVisible(false)
		local array = CCArray:array();
		array:addObject(CCHide:action())
		array:addObject(CCDelayTime:actionWithDuration(0.05))
		array:addObject(CCShow:action())
		array:addObject(CCDelayTime:actionWithDuration(0.1))
		array:addObject(CCHide:action())
		array:addObject(CCDelayTime:actionWithDuration(0.1))
		array:addObject(CCShow:action())
		array:addObject(CCDelayTime:actionWithDuration(0.4))
		array:addObject(CCHide:action())
		local seq = CCSequence:actionsWithArray(array);
		_bossLighting:runAction(seq)
		_bossLighting:setColor(ccc3(255,255,255))
		callback:new():start(0.4, function()
			local tt = _TimeLerp()
			tt:start(0,0.05, function(t)
				ZXLogicScene:sharedScene():zoom(1.0 - 0.4 * t)
				if t >= 1.0 then
					local tt = _TimeLerp()
					tt:start(0,0.4, function(t) 
						ZXLogicScene:sharedScene():zoom(0.60 + 0.2 * t)
					end)
				end
			end)
		end)

		local array = CCArray:array();
		array:addObject(CCMoveBy:actionWithDuration(0.05,CCPointMake(8,8)))
		array:addObject(CCMoveBy:actionWithDuration(0.05,CCPointMake(0,-8)))
		array:addObject(CCMoveBy:actionWithDuration(0.05,CCPointMake(-8,0)))
		array:addObject(CCMoveBy:actionWithDuration(0.05,CCPointMake(8,-8)))
		array:addObject(CCMoveBy:actionWithDuration(0.05,CCPointMake(-8,8)))
		local seq = CCSequence:actionsWithArray(array);
		_intro_root:runAction(seq)
	end)
	_callbacks[_thunder_callback] = true


end

local function _intro_boss_noise(_delay,_delay2)
	local _noise_callback = callback:new()
	_noise_callback:start(_delay, function()

		local array = CCArray:array()
		array:addObject(CCScaleTo:actionWithDuration(0.06,1.2))
		array:addObject(CCScaleTo:actionWithDuration(0.06,1.0))
		array:addObject(CCScaleTo:actionWithDuration(0.06,1.5))
		array:addObject(CCScaleTo:actionWithDuration(0.06,1.0))
		array:addObject(CCScaleTo:actionWithDuration(0.06,1.1))
		array:addObject(CCScaleTo:actionWithDuration(0.06,1.0))
		local seq = CCSequence:actionsWithArray(array)
		_intro_root:runAction(seq)

		local array = CCArray:array()
		array:addObject(CCMoveBy:actionWithDuration(0.06,CCPointMake(12,-24)))
		array:addObject(CCMoveBy:actionWithDuration(0.06,CCPointMake(0,32)))
		array:addObject(CCMoveBy:actionWithDuration(0.06,CCPointMake(-12,24)))
		array:addObject(CCMoveBy:actionWithDuration(0.06,CCPointMake(0,-32)))
		array:addObject(CCMoveBy:actionWithDuration(0.06,CCPointMake(-12,18)))
		array:addObject(CCMoveBy:actionWithDuration(0.06,CCPointMake(12,-18)))
		local seq = CCSequence:actionsWithArray(array)
		_intro_root:runAction(seq)


		_speed_line:setIsVisible(true)
		_speed_line:setAnchorPoint(CCPointMake(0.0,0.0))

		local array = CCArray:array();
		array:addObject(CCScaleTo:actionWithDuration(0.03,1.02))
		array:addObject(CCScaleTo:actionWithDuration(0.03,1.0))
		array:addObject(CCScaleTo:actionWithDuration(0.03,0.98))
		array:addObject(CCScaleTo:actionWithDuration(0.03,1.0))
		local seq = CCSequence:actionsWithArray(array);
		local rep = CCRepeatForever:actionWithAction(seq)
		_speed_line:runAction(rep)


	    local t0 = CCTintBy:actionWithDuration( 1.2, -50,-50, -50 )
	    local t1 = CCTintBy:actionWithDuration( 1.2, 50, 50, 50 )
		local array = CCArray:array();
		array:addObject(t0)
		array:addObject(t1)
		local seq = CCSequence:actionsWithArray(array);
		local rep = CCRepeatForever:actionWithAction(seq)
		_speed_line:runAction(rep)



	end)
	_callbacks[_noise_callback] = true

	local _noise_callback2 = callback:new()

	_noise_callback2:start(_delay2, function()
		_boss_noise = CCSprite:spriteWithFile('ui2/intro/boss_noise.png')
		_boss_noise:setAnchorPoint(CCPointMake(1.0,0.5))
		_boss_noise:setPosition(CCPointMake(480,380))
		_scene_root:addChild(_boss_noise,_boss_nosie_Layer)

		_boss_noise:setScale(0)
		local array = CCArray:array();
		array:addObject(CCScaleTo:actionWithDuration(0.06,2.5))
		array:addObject(CCScaleTo:actionWithDuration(0.06,1.0))
		array:addObject(CCScaleTo:actionWithDuration(0.06,1.5))
		array:addObject(CCScaleTo:actionWithDuration(0.06,1.0))
		array:addObject(CCMoveBy:actionWithDuration(0.5,CCPointMake(0,25)))
		array:addObject(CCFadeTo:actionWithDuration(1.0,0))
		local seq = CCSequence:actionsWithArray(array);
		_boss_noise:runAction(seq)

		--_boss:removeFromParentAndCleanup(true)
		_boss_blur:setIsVisible(true)

		_boss:setOpacity(255)
		local fade_0 = CCFadeTo:actionWithDuration(1.5,0)
		local action = CCEaseOut:actionWithAction(fade_0,2);
		_boss:runAction(action)

		local array = CCArray:array();
		array:addObject(CCScaleTo:actionWithDuration(2.0,0.98))
		array:addObject(CCScaleTo:actionWithDuration(2.0,1.02))
		local seq = CCSequence:actionsWithArray(array);
		local rep = CCRepeatForever:actionWithAction(seq)
		_boss_blur:runAction(rep)

	end)
	_callbacks[_noise_callback] = true
end

local function _shadow_role_func( data)

	local _left_role = data.node
	local _filename = data.file
	local color = data.color
	if os.clock() - data.stime > 1.0 then
		data.timer:stop()
		return
	end

	local x,y = _left_role:getPosition()
	local s = _left_role:getScale()
	local _shadow_role = CCSprite:spriteWithFile(_filename)
	_shadow_role:setScale(s)
	_shadow_role:setPosition(CCPointMake(x,y))
	_shadow_role:setColor(ccc3(color[1],color[2],color[3]))
	_shadow_role:setOpacity(0)
	local array = CCArray:array();
	array:addObject(CCFadeTo:actionWithDuration(0.25,225))
	array:addObject(CCFadeTo:actionWithDuration(1.0,0))
	array:addObject(CCRemove:action())
	local seq = CCSequence:actionsWithArray(array);
	_shadow_role:runAction(seq)
	_scene_root:addChild(_shadow_role,_role_layer-1)
end

function _intro_role(_Time)
	local _role_callback0 = callback:new()
	local _role_callback1 = callback:new()
	local _role_callback2 = callback:new()
	--[[
		_boss = CCSprite:spriteWithFile('ui2/intro/boss.png')
		_boss:setAnchorPoint(CCPointMake(0,0))
		_scene_root:addChild(_boss,_bossLayer)
	ZXLogicScene:sharedScene():zoom(0.8)
	]]--
	_role_callback0:start(_Time+1.75, function()
		local _filename = 'ui2/intro/left_role.png'
		local _left_role = CCSprite:spriteWithFile(_filename)
		_left_role:setAnchorPoint(CCPointMake(0.5,0.5))
		_left_role:setPosition(CCPointMake(-300,100))	
		_left_role:setScale(1.5)
		local bezier1 = ccBezierConfig();
		bezier1.controlPoint_1 = CCPoint( -100,300 );
		bezier1.controlPoint_2 = CCPoint( 200,480);
		bezier1.endPosition = CCPoint(460,340);
		local bezierTo1 = CCBezierTo:actionWithDuration(2, bezier1 );
		local scaleTo   = CCScaleTo:actionWithDuration(2,0.25)
		_left_role:runAction(CCEaseOut:actionWithAction(bezierTo1,5))
		_left_role:runAction(CCEaseOut:actionWithAction(scaleTo,4))
		_scene_root:addChild(_left_role,_role_layer)

		local t = timer()
		local obj = 
		{
			node =_left_role, 
			file = _filename,
			color = { 128,0,255 },
			stime = os.clock(),
			timer = t
		}
		t:start(0.1, bind(_shadow_role_func,obj))


	end)

	_role_callback1:start(_Time+1.0, function()
		local _filename = 'ui2/intro/center_role.png'
		local _center_role = CCSprite:spriteWithFile(_filename)
		_center_role:setPosition(CCPointMake(180,-380))
		_center_role:setScale(1.5)
		local bezier1 = ccBezierConfig();
		bezier1.controlPoint_1 = CCPoint( 240,-140 );
		bezier1.controlPoint_2 = CCPoint( 480,340);
		bezier1.endPosition = CCPoint(520,280);
		local bezierTo1 = CCBezierTo:actionWithDuration(2, bezier1 );
		local scaleTo   = CCScaleTo:actionWithDuration(2,0.25)
		_center_role:runAction(CCEaseOut:actionWithAction(bezierTo1,5))
		_center_role:runAction(CCEaseOut:actionWithAction(scaleTo,4))


		_scene_root:addChild(_center_role,_role_layer)

		local t = timer()
		local obj = 
		{
			node =_center_role, 
			file = _filename,
			color = { 255,0,0 },
			stime = os.clock(),
			timer = t
		}
		t:start(0.4, bind(_shadow_role_func,obj))

		local tt = _TimeLerp()
			tt:start(0,2.0, function(t)
				ZXLogicScene:sharedScene():zoom(0.80 + 0.2 * t)
			end)
	end)

	_role_callback2:start(_Time+2.5, function()
		local _filename = 'ui2/intro/right_role.png'
		local _right_role = CCSprite:spriteWithFile(_filename)
		_right_role:setPosition(CCPointMake(1200,250))	
		_right_role:setScale(1.5)
		local bezier1 = ccBezierConfig();
		bezier1.controlPoint_1 = CCPoint( 1000,250 );
		bezier1.controlPoint_2 = CCPoint( 800,400);
		bezier1.endPosition = CCPoint(600,310);
		local bezierTo1 = CCBezierTo:actionWithDuration(2, bezier1 );
		local scaleTo   = CCScaleTo:actionWithDuration(2,0.25)
		_right_role:runAction(CCEaseOut:actionWithAction(bezierTo1,5))
		_right_role:runAction(CCEaseOut:actionWithAction(scaleTo,4))
		_scene_root:addChild(_right_role,_role_layer)

		local t = timer()
		local obj = 
		{
			node =_right_role, 
			file = _filename,
			color = { 0,0,255 },
			stime = os.clock(),
			timer = t
		}
		t:start(0.4, bind(_shadow_role_func,obj))
	end)



	_callbacks[_role_callback0] = true
	_callbacks[_role_callback1] = true
	_callbacks[_role_callback2] = true
end

function _intro_pro(_delay,_delay2)
	--_timer.stop_all()

	local _role_pro0 = callback:new()
		_role_pro0:start(_delay, function()
		local _role0 = CCSprite:spriteWithFile('ui2/intro/pro0.png')
		local _role1 = CCSprite:spriteWithFile('ui2/intro/pro1.png')
		local _role2 = CCSprite:spriteWithFile('ui2/intro/pro2.png')

		_role0:setPosition(CCPointMake(-800,0))
		_role1:setPosition(CCPointMake(470,2000))
		_role2:setPosition(CCPointMake(2000,0))
		

		_role0:setAnchorPoint(CCPointMake(0,0))
		_role1:setAnchorPoint(CCPointMake(0.5,0.0))
		_role2:setAnchorPoint(CCPointMake(1,0))
		
		_scene_root_2:addChild(_role0,_proLayer)
		_scene_root_2:addChild(_role1,_proLayer)
		_scene_root_2:addChild(_role2,_proLayer)


		local array = CCArray:array();
		array:addObject(CCDelayTime:actionWithDuration(0.0))
		--array:addObject(CCMoveTo:actionWithDuration(0.2,CCPointMake(0,0)))
		array:addObject(CCMoveTo:actionWithDuration(0.2,CCPointMake(48,0)))
		array:addObject(CCMoveTo:actionWithDuration(0.2,CCPointMake(-24,0)))
		array:addObject(CCMoveTo:actionWithDuration(0.2,CCPointMake(12,0)))
		array:addObject(CCMoveTo:actionWithDuration(0.2,CCPointMake(0,0)))
		local seq = CCSequence:actionsWithArray(array);
		_role0:runAction(seq)

		local array = CCArray:array();
		array:addObject(CCDelayTime:actionWithDuration(1.0))
		--array:addObject(CCMoveTo:actionWithDuration(0.2,CCPointMake(470,0)))
		array:addObject(CCMoveTo:actionWithDuration(0.2,CCPointMake(470,-48)))
		array:addObject(CCMoveTo:actionWithDuration(0.2,CCPointMake(470,24)))
		array:addObject(CCMoveTo:actionWithDuration(0.2,CCPointMake(470,-8)))
		array:addObject(CCMoveTo:actionWithDuration(0.2,CCPointMake(470,0)))
		local seq = CCSequence:actionsWithArray(array);
		_role1:runAction(seq)

		local array = CCArray:array();
		array:addObject(CCDelayTime:actionWithDuration(0.4))
		array:addObject(CCMoveTo:actionWithDuration(0.2,CCPointMake(900,0)))
		array:addObject(CCMoveTo:actionWithDuration(0.2,CCPointMake(990,0)))
		array:addObject(CCMoveTo:actionWithDuration(0.2,CCPointMake(940,0)))
		array:addObject(CCMoveTo:actionWithDuration(0.2,CCPointMake(960,0)))
		local seq = CCSequence:actionsWithArray(array);
		_role2:runAction(seq)

		local b = ccBlendFunc()
		b.src = 1
		b.dst = 1
		local _sp = CCSprite:spriteWithFile('ui2/intro/pro0.png')
		_sp:setAnchorPoint(CCPointMake(0,0))
		_sp:setBlendFunc(b)
		_role0:addChild(_sp)
		local array = CCArray:array();
		array:addObject(CCDelayTime:actionWithDuration(0.8))
		array:addObject(CCFadeOut:actionWithDuration(0.25))
		local seq = CCSequence:actionsWithArray(array);
		_sp:runAction(seq)

		local b = ccBlendFunc()
		b.src = 1
		b.dst = 1
		local _sp = CCSprite:spriteWithFile('ui2/intro/pro1.png')
		_sp:setAnchorPoint(CCPointMake(0,0))
		_sp:setBlendFunc(b)
		_role1:addChild(_sp)
		local array = CCArray:array();
		array:addObject(CCDelayTime:actionWithDuration(1.4))
		array:addObject(CCFadeOut:actionWithDuration(0.25))
		local seq = CCSequence:actionsWithArray(array);
		_sp:runAction(seq)

		local b = ccBlendFunc()
		b.src = 1
		b.dst = 1
		local _sp = CCSprite:spriteWithFile('ui2/intro/pro2.png')
		_sp:setAnchorPoint(CCPointMake(0,0))
		_sp:setBlendFunc(b)
		_role2:addChild(_sp)
		local array = CCArray:array();
		array:addObject(CCDelayTime:actionWithDuration(1.0))
		array:addObject(CCFadeOut:actionWithDuration(0.25))
		local seq = CCSequence:actionsWithArray(array);
		_sp:runAction(seq)

		local array = CCArray:array();
		array:addObject(CCDelayTime:actionWithDuration(1.2))
		array:addObject(CCMoveBy:actionWithDuration(0.1, CCPointMake(0,32)))
		array:addObject(CCMoveBy:actionWithDuration(0.1, CCPointMake(0,-32)))
		array:addObject(CCMoveBy:actionWithDuration(0.1, CCPointMake(0,8)))
		array:addObject(CCMoveBy:actionWithDuration(0.1, CCPointMake(0,-8)))
		local seq = CCSequence:actionsWithArray(array);

		_scene_root_2:runAction(seq)
	end)
	_callbacks[_role_pro0] = true

	local _next_scene_callback = callback:new()
	_next_scene_callback:start(_delay2,function()
		_scene_root:removeFromParentAndCleanup(true)
	end)
end

function _intro_face_to_face(_delay)
	_timer.stop_all()
	local _intro_face_to_face_callback = callback:new()
	_intro_face_to_face_callback:start(_delay, function()

		local _sp = CCSprite:spriteWithFile('ui2/intro/speed_line2.png')
		local uvAnimation = CCUVAnimation:actionWithDuration(10,-120.0,0);
		_sp:setAnchorPoint(CCPointMake(0.5,0.5))
		_sp:runAction(uvAnimation)
		_root:addChild(_sp,100)
		_sp:setPosition(CCPointMake(480,320))
		_sp:setScale(1.875)
		_sp:setOpacity(0)
		local array = CCArray:array();
		array:addObject(CCFadeIn:actionWithDuration(0.1))
		array:addObject(CCFadeOut:actionWithDuration(0.5))
		local seq = CCSequence:actionsWithArray(array);
		_sp:runAction(seq)

		_scene_root_2:runAction(CCMoveBy:actionWithDuration(0.25,CCPointMake(-960,0)))

		local _sp = CCSprite:spriteWithFile('ui2/intro/boss_face.png')
		_scene_root_3:addChild(_sp)
		_sp:setAnchorPoint(CCPointMake(0,0))
		_sp:setPosition(CCPointMake(-32,0))
		local array = CCArray:array();
		array:addObject(CCMoveBy:actionWithDuration(1.0,CCPointMake(0,8)))
		array:addObject(CCMoveBy:actionWithDuration(1.0,CCPointMake(32,0)))
		array:addObject(CCMoveBy:actionWithDuration(1.0,CCPointMake(0,-8)))
		array:addObject(CCMoveBy:actionWithDuration(1.0,CCPointMake(-32,0)))
		local seq = CCSequence:actionsWithArray(array);
		local rep = CCRepeatForever:actionWithAction(seq)
		_sp:runAction(rep)
		local p1 = CCParticleSystemQuad:particleWithFile('ui2/intro/left_eye.plist')
		p1:setScale(3.5)
		p1:setPosition(CCPointMake(130,310))
		_sp:addChild(p1)


		local _sp = CCSprite:spriteWithFile('ui2/intro/pro_face0.png')
		_scene_root_3:addChild(_sp)
		_sp:setAnchorPoint(CCPointMake(1.0,1.0))
		_sp:setPosition(CCPointMake(960,640))
		local array = CCArray:array();
		array:addObject(CCDelayTime:actionWithDuration(0.1))
		array:addObject(CCMoveBy:actionWithDuration(2.0,CCPointMake(48,20)))
		array:addObject(CCMoveBy:actionWithDuration(1.0,CCPointMake(-48,-20)))
		local seq = CCSequence:actionsWithArray(array);
		local rep = CCRepeatForever:actionWithAction(seq)
		_sp:runAction(rep)



		local _sp = CCSprite:spriteWithFile('ui2/intro/pro_face1.png')
		_scene_root_3:addChild(_sp)
		_sp:setAnchorPoint(CCPointMake(1.0,0.5))
		_sp:setPosition(CCPointMake(960,340))
		local array = CCArray:array();

		array:addObject(CCMoveBy:actionWithDuration(2.0,CCPointMake(48,0)))
		array:addObject(CCMoveBy:actionWithDuration(1.0,CCPointMake(-48,0)))
		local seq = CCSequence:actionsWithArray(array);
		local rep = CCRepeatForever:actionWithAction(seq)
		_sp:runAction(rep)

		local _sp = CCSprite:spriteWithFile('ui2/intro/pro_face2.png')
		_scene_root_3:addChild(_sp)
		_sp:setAnchorPoint(CCPointMake(1.0,0.0))
		_sp:setPosition(CCPointMake(960,0))
		local array = CCArray:array();
		array:addObject(CCDelayTime:actionWithDuration(0.2))
		array:addObject(CCMoveBy:actionWithDuration(2.0,CCPointMake(48,-20)))
		array:addObject(CCMoveBy:actionWithDuration(1.0,CCPointMake(-48,20)))
		local seq = CCSequence:actionsWithArray(array);
		local rep = CCRepeatForever:actionWithAction(seq)
		_sp:runAction(rep)

		_scene_root_3:runAction(CCMoveTo:actionWithDuration(0.25,CCPointMake(0,0)))
		local _sp = CCSprite:spriteWithFile('ui2/intro/tube.png')
		_scene_root_3:addChild(_sp,-1)
		_sp:setPosition(CCPointMake(480,320))
		_sp:setScale(2.0)
		local uvAnimation = CCUVAnimation:actionWithDuration(10,20.0,0);
		_sp:runAction(uvAnimation)

		local _sp = CCSprite:spriteWithFile('ui2/intro/face_thunder.webp')
		_sp:setPosition(CCPointMake(480,320))
		
		local array = CCArray:array();
		array:addObject(CCScaleTo:actionWithDuration(0.03,1.02))
		array:addObject(CCScaleTo:actionWithDuration(0.03,0.97))
		array:addObject(CCScaleTo:actionWithDuration(0.03,1.05))
		array:addObject(CCScaleTo:actionWithDuration(0.03,0.98))
		local seq = CCSequence:actionsWithArray(array);
		local rep = CCRepeatForever:actionWithAction(seq)
		_sp:runAction(rep)
		_scene_root_3:addChild(_sp,1)

		local cb = callback:new()
		cb:start(2.5,function()
			_sp:stopAllActions()
			_sp:runAction(CCScaleTo:actionWithDuration(0.5,40.0))
		end)
	end)
end


function _intro_logo( _delay )
	local cb = callback:new()
	cb:start(_delay,function()

		-- local is_ckeck_version = CCAppConfig:sharedAppConfig():getBoolForKey("is_check_version")
		local logo = CCSprite:spriteWithFile('nopack/login_logo.png')
		local is_test_version = CCAppConfig:sharedAppConfig():getBoolForKey("is_test_version")
    	if is_test_version then
	    	logo = CCSprite:spriteWithFile('nopack/login_logo_test.png')
		end
	    logo:setPosition(CCPointMake(480,1024))
	    --logo:setScale(0)

		local array = CCArray:array();
		--array:addObject(CCEaseIn:actionWithAction(CCScaleTo:actionWithDuration(0.5, 1.5),2))
		array:addObject(CCMoveTo:actionWithDuration(0.25,CCPointMake(480,200)))
		array:addObject(CCMoveTo:actionWithDuration(0.25,CCPointMake(480,340)))
		array:addObject(CCMoveTo:actionWithDuration(0.15,CCPointMake(480,300)))
		array:addObject(CCMoveTo:actionWithDuration(0.15,CCPointMake(480,320)))
		local seq = CCSequence:actionsWithArray(array);
	    logo:runAction(seq)
	    --logo:runAction(CCEaseIn:actionWithAction(CCRotateBy:actionWithDuration(1, 720),2))


		logo:setColor(ccc3(0,0,0))

		local t0 = CCTintBy:actionWithDuration( 0.25, 255,255,255 )
		local array = CCArray:array();
		array:addObject(CCDelayTime:actionWithDuration(1.0))
		array:addObject(t0)
		local seq = CCSequence:actionsWithArray(array);	
		logo:runAction(seq)

		--logo:runAction(seq
		_root:addChild(logo,1000)
		--[[
		local b = ccBlendFunc()
		b.src = 1
		b.dst = 1
	    local _sp = CCSprite:spriteWithFile('nopack/login_logo.png')
		_sp:setAnchorPoint(CCPointMake(0,0))
		_sp:setBlendFunc(b)
		_sp:setColor(ccc3(100,100,100))
		local array = CCArray:array();
		array:addObject(CCDelayTime:actionWithDuration(1.3))
		array:addObject(CCFadeTo:actionWithDuration(1.0,0))
		local seq = CCSequence:actionsWithArray(array);
		_sp:runAction(seq)
		logo:addChild(_sp)
		]]--
	end)
end

function _intro_finish( _delay )
	local cb = callback:new()
	cb:start(_delay,function()
		Intro:finish()
	end)
end

function _createUI(GameUIRoot)
	_touchRoot = CCBasePanel:panelWithFile( 0,0,
											GameScreenConfig.ui_screen_width, 
										    GameScreenConfig.ui_screen_height,'')

	local function basePanelMessageFun(eventType, args, msgid, selfItem)
		if eventType == TOUCH_BEGAN then
			_clicks = _clicks - 1
			if _clicks < 1 then
				Intro:finish()
			end
		end
		return true
	end
	_touchRoot:registerScriptHandler(basePanelMessageFun)
	local _skipText = CCSprite:spriteWithFile('ui2/intro/skipText.png')

	local fade_0 = CCFadeTo:actionWithDuration(2.0,0)
	local fade_1 = CCFadeTo:actionWithDuration(2.0,255)
	local array = CCArray:array();
	array:addObject(fade_0)
	array:addObject(fade_1)
	local seq = CCSequence:actionsWithArray(array);
	local rep = CCRepeatForever:actionWithAction(seq)
	_skipText:runAction(rep)
	_skipText:setPosition(CCPointMake(GameScreenConfig.ui_screen_width,GameScreenConfig.ui_screen_height))
	_skipText:setAnchorPoint(CCPointMake(1,1))
	local ui_root = GameUIRoot:getUINode()
	_touchRoot:addChild(_skipText)
	ui_root:addChild(_touchRoot)
end

function Intro:start(GameUIRoot, finishCallback)
	-- body

	--end
	require "sound/AudioManager"
	SoundManager:playMusic( 'intro' , true)

	ZXLog('Intro:start')
	ZXResMgr:setTextureColorCompress(false)
	self.finishCallback = finishCallback 
	self.finishCalled = false
	self.safe_callback = callback:new()
	self.safe_callback:start(30,function()
		Intro:finish()
	end)

	local _width  = GameScreenConfig.ui_design_width
	local _height = GameScreenConfig.ui_design_height
	
	_root = CCNode:node()

	_root:setPosition(CCPointMake(GameScreenConfig.winSize_width*0.5,
								  GameScreenConfig.winSize_height*0.5))
	_root:setAnchorPoint(CCPointMake(0.5,0.5))

	_root:setContentSize(CCSizeMake(_width,
									_height))

	_root:setScaleX(GameScreenConfig.winSize_width/_width)
	_root:setScaleY(GameScreenConfig.winSize_height/_height)
	
	_intro_root = CCNode:node()
	_root:addChild(_intro_root)
	GameUIRoot:addChild(_root)
	ZXLog('GameScreenConfig.winSize', GameScreenConfig.winSize_width, GameScreenConfig.winSize_height)
	ZXLog('GameScreenConfig.winSize_width/_width',GameScreenConfig.winSize_width/_width)
	ZXLog('GameScreenConfig.winSize_height/_height',GameScreenConfig.winSize_height/_height)
	
	_scene_root = CCNode:node()
	_scene_root_2 = CCNode:node()
	_scene_root_3 = CCNode:node()
	_scene_root_3:setPosition(CCPointMake(960,0))

	_intro_root:addChild(_scene_root)
	_intro_root:addChild(_scene_root_2)
	_intro_root:addChild(_scene_root_3)

	--_root:addChild(CCDebugRect:create())

	_boss = CCSprite:spriteWithFile('ui2/intro/boss.webp')
	_boss:setIsVisible(false)
	_scene_root:addChild(_boss,_bossLayer)

	_bossLighting = CCSprite:spriteWithFile('ui2/intro/boss_lighting.webp')
	_bossLighting:setIsVisible(false)
	_boss:addChild(_bossLighting)

	_boss_blur = CCSprite:spriteWithFile('ui2/intro/boss_blur.webp')
	_boss_blur:setPosition(CCPointMake(480,292))
	_boss_blur:setIsVisible(false)
	_boss:addChild(_boss_blur,-1)

	_thunder = CCSprite:spriteWithFile('ui2/intro/thunder.webp')
	_thunder:setIsVisible(false)
	_scene_root:addChild(_thunder,_thunderLayer)

	_speed_line = CCSprite:spriteWithFile('ui2/intro/speed_line.webp')
	_speed_line:setIsVisible(false)
	_scene_root:addChild(_speed_line,_speedLayer)

	_front_fire = CCSprite:spriteWithFile('ui2/intro/fire.webp')
	_front_fire:setIsVisible(false)
	_scene_root:addChild(_front_fire,_front_fireLayer)

	local intro = CCUserDefault:sharedUserDefault():getBoolForKey("intro")
	if intro then
		_createUI(GameUIRoot)
	else
		CCUserDefault:sharedUserDefault():setBoolForKey("intro",true)
		CCUserDefault:sharedUserDefault():flush()
	end
	
	ZXLog('Intro:init')
	_intro_fire(0.5,1.5)
	_intro_village(2.5)
	_intro_boss(6.0,8.5)
	_intro_thunder(10.5)
	_intro_role(10.5)
	_intro_boss_noise(11,11.5)
	_intro_pro(14,16)
	_intro_face_to_face(16)
	_intro_logo(19.5)
	_intro_finish(22)
end

function Intro:finish()
	if _root then
		_root:removeFromParentAndCleanup(true)
		_root = nil
		callback.cancel_all()
		_timer.stop_all()
	end

	if _touchRoot then
		_touchRoot:removeFromParentAndCleanup(true)
	end
	
	if not self.finishCalled then
		ZXLog("collect actions");
		phone_removeUnusedActions();
		ZXLog("collect frames");
		ZXSpriteFrameCache:sharedCache():removeUnusedFrames();
		ZXLog("collect texture");
		CCTextureCache:sharedTextureCache():removeUnusedTextures()
		ZXLog("collect script");
		collectgarbage("collect")
		self.finishCallback()
		ZXResMgr:setTextureColorCompress(GameScreenConfig.textureColorCompress)
		self.finishCalled = true
	end
	ZXLogicScene:sharedScene():zoom(1.0)
	SoundManager : pauseBackgroundMusic()
end