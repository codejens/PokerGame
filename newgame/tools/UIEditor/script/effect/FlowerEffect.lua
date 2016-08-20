
FlowerEffect = {}

local _refWidth =  UIScreenPos.relativeWidth
local _refHeight = UIScreenPos.relativeHeight
local _offsetX = 200
local _offsetY = 70
local _offsetNum = 18
local _timer = nil
local _heartPos = {}
local _heartCnt = 1
local _heartIdx = 1
local _heartEffectId = 408
local _flowerEffectCnt = 1

local function _randomNum( a, b )
	return math.random(a, b)
end

local function _randomRate( )
	return _randomNum(0, 100)/100
end

local function _conTable( t1, t2 )
	for k,v in pairs(t2) do
		table.insert(t1, v)
	end
	return t1
end

local function _calPos( x1, x2, y1, y2 )
	local pos = {}
	for j=1, _offsetNum do
		local x = _randomNum(x1, x2)
		local y = _randomNum(y1, y2)
		table.insert(pos, {x=x, y=y})
	end
	return pos
end

local function _calTopPos( )
	local pos = {}
	local num = math.floor(_refWidth(1.0)/_offsetX) + 1
	for i=1,num do
		local tmpPos = _calPos((i-1)*_offsetX, i*_offsetX, _refHeight(1.0)-_offsetY, _refHeight(1.0))
		pos = _conTable(pos, tmpPos)
	end
	return pos
end

local function _calBtmPos( )
	local pos = {}
	local num = math.floor(_refWidth(1.0)/_offsetX) + 1
	for i=1,num do
		local tmpPos = _calPos((i-1)*_offsetX, i*_offsetX, 0, _offsetY)
		pos = _conTable(pos, tmpPos)
	end
	return pos
end

local function _calLeftPos( )
	local pos = {}
	local num = math.floor((_refHeight(1.0)-_offsetY*2)/_offsetX) + 1
	for i=1,num do
		local tmpPos = _calPos(0, _offsetY, (i-1)*_offsetX, (i)*_offsetX)
		pos = _conTable(pos, tmpPos)
	end
	return pos
end

local function _calRightPos( )
	local pos = {}
	local num = math.floor((_refHeight(1.0)-_offsetY*2)/_offsetX) + 1
	for i=1,num do
		local tmpPos = _calPos(_refWidth(1.0)-_offsetY, _refWidth(1.0), (i-1)*_offsetX, (i)*_offsetX)
		pos = _conTable(pos, tmpPos)
	end
	return pos
end

local function _calFlowerPos( )
	local pos = {}
	pos = _conTable(pos, _calTopPos())
	pos = _conTable(pos, _calRightPos())
	pos = _conTable(pos, _calBtmPos())
	pos = _conTable(pos, _calLeftPos())
	return pos
end

local function _calHeartPos( )
	local pos = {}
	table.insert(pos, {x=_refWidth(0.25), y=_refHeight(0.75)})
	table.insert(pos, {x=_refWidth(0.50), y=_refHeight(0.50)})
	table.insert(pos, {x=_refWidth(0.75), y=_refHeight(0.25)})
	table.insert(pos, {x=_refWidth(0.75), y=_refHeight(0.75)})
	table.insert(pos, {x=_refWidth(0.50), y=_refHeight(0.50)})
	table.insert(pos, {x=_refWidth(0.25), y=_refHeight(0.25)})
	table.insert(pos, {x=_refWidth(0.25), y=_refHeight(0.75)})
	table.insert(pos, {x=_refWidth(0.50), y=_refHeight(0.50)})
	return pos
end

function _flowerAction( )
	local dt = _randomNum(0, 2)
    local delay = CCDelayTime:actionWithDuration(dt or 0)

    local fadeIn = CCFadeIn:actionWithDuration(1.0)
    local fadeOut = CCFadeOut:actionWithDuration(2.0)
    local a3 = CCSequence:actionOneTwo(fadeIn, fadeOut)
    
    local s = _randomRate()
    local scale0 = CCScaleTo:actionWithDuration(0, s)
    local scale1 = CCScaleTo:actionWithDuration(2.0, 1.0)
    local a2 = CCSequence:actionOneTwo(scale0, scale1)

    local spawn = CCSpawn:actionOneTwo(a2, a3)
    local rep = CCRepeat:actionWithAction(spawn, _flowerEffectCnt)

    local arr = CCArray:array()
    arr:addObject(CCHide:action())
    arr:addObject(delay)
    arr:addObject(CCShow:action())
    arr:addObject(rep)
    arr:addObject(CCRemove:action())
    local seq = CCSequence:actionsWithArray(arr)

    return seq
end




local function _doHeartTick( )
	if _heartIdx > _heartCnt then
		_timer:stop()
		LuaEffectManager:stop_view_effect(_heartEffectId, FlowerEffect.root )
		_heartIdx = 1
		_flowerEffectCnt = 1
		_heartPos = {}
	else
		LuaEffectManager:play_view_effect(_heartEffectId, _heartPos[_heartIdx].x, _heartPos[_heartIdx].y, FlowerEffect.root, false)
		_heartIdx = _heartIdx + 1
	end
end

--初始化
function FlowerEffect:init(root)
	self.root = root
	_timer = timer()

	_heartPos = {}
	_heartCnt = 0
	_heartIdx = 1
	_heartEffectId = 408
end

--退出的时候记得清空
function FlowerEffect:scene_leave()
	_heartIdx = 1
	_flowerEffectCnt = 1
	_heartPos = {}
	if _timer then
		_timer:stop()
		_timer = nil
	end
	self:removeRoot()
end

function FlowerEffect:removeRoot()
	if self.flowerRoot then
		--删除引用
		self.flowerRoot:removeAllChildrenWithCleanup(true)
		self.flowerRoot:removeFromParentAndCleanup(true)
		self.flowerRoot = nil
	end
end

function FlowerEffect:onPause()
	_heartIdx = 1
	_flowerEffectCnt = 1
	_heartPos = {}
	if _timer then
		_timer:stop()
		_timer = nil
	end
	self:removeRoot()
end

function FlowerEffect:onResume()

end

function FlowerEffect:play(second)
	if second then
		_flowerEffectCnt = math.floor(second/3)
		for i=1,_flowerEffectCnt do
			_heartPos = _conTable(_heartPos, _calHeartPos())
		end
		_heartCnt = #_heartPos
	end

	if not self.flowerRoot then
		self.flowerRoot = CCSpriteBatchNode:batchNodeWithFile('ui/flower/00000.png')
		self.root:addChild(self.flowerRoot, Z_FLOWER)
	end

	local pos = _calFlowerPos()
	local num = #pos

	for i=1,num do
		local flower = CCSprite:spriteWithFile("ui/flower/00000.png")
		flower:setPosition(pos[i].x, pos[i].y)
		self.flowerRoot:addChild(flower)
		flower:runAction(_flowerAction())
	end

	if _timer ~= nil and _timer:isIdle() then
		_timer:start(3/9, _doHeartTick)
	end
end

