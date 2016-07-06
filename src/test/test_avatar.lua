module(...,package.seeall)
--test_avatar.lua

test_avatar = simple_class()
--动作config = {}
local _json = [[
    {
      "actions": {
          "0": {
              "restoreOriginalFrame" : false,
              "loop" : 3,
              "delay" : 0.25,
              "frames": { "start": 0, "end": 3 }
          },
          "1": {
              "restoreOriginalFrame" : false,
              "loop" : 3,
              "delay" : 0.25,
              "frames": { "start": 4, "end": 7 }
          },
          "2": {
              "restoreOriginalFrame" : false,
              "loop" : 3,
              "delay" : 0.25,
              "frames": { "start": 8, "end": 11 }
          },
          "3": {
              "restoreOriginalFrame" : false,
              "loop" : 3,
              "delay" : 0.25,
              "frames": { "start": 12, "end": 15 }
          },
          "4": {
              "restoreOriginalFrame" : false,
              "loop" : 3,
              "delay" : 0.25,
              "frames": { "start": 16, "end": 19 }
          },
          "5": {
              "restoreOriginalFrame" : false,
              "loop" : 3,
              "delay" : 0.07,
              "frames": { "start": 20, "end": 31 }
          },
          "6": {
              "restoreOriginalFrame" : false,
              "loop" : 3,
              "delay" : 0.07,
              "frames": { "start": 32, "end": 43 }
          },
          "7": {
              "restoreOriginalFrame" : false,
              "loop" : 3,
              "delay" : 0.07,
              "frames": { "start": 44, "end": 55 }
          },
          "8": {
              "restoreOriginalFrame" : false,
              "loop" : 3,
              "delay" : 0.07,
              "frames": { "start": 56, "end": 67 }
          } ,
          "9": {
              "restoreOriginalFrame" : false,
              "loop" : 3,
              "delay" : 0.07,
              "frames": { "start": 68, "end": 79 }
          }

      }
    }
    ]]

local _speed = 150
local frametime = 0
local movetime = 0
local needtime = 0

--临时测试
local payer = nil
function test_avatar.get_palyer(  )
	return payer
end
--临时测试
function test_avatar:__init( view )
	self.view = view
	self.m_x = 200
	self.m_y = 200
	self.target_x = 0
	self.target_y = 0
	self.move_id = -1
	self.is_move = false
	self.weapon = ccsext.XAnimateSprite:create()
    self.weapon:initWithActionJson('animations/weapon',_json)
  	self.weapon:playAction(4,true)
	self.weapon:setPosition(455,455)
	view:addChild(self.weapon)
	self.move_time = timer:create( )
	local function update( dt )
		self:update(dt)
	end
	self.move_time:start(0,update)

end



function test_avatar:update( dt )
	--print("^^^^^  ",dt)

	frametime = dt

	if movetime > 0 then
		self.m_x = self.m_x + (self.target_x-self.start_x)*(frametime/needtime)
		self.m_y = self.m_y + (self.target_y-self.start_y)*(frametime/needtime)
		movetime = movetime - frametime
		self:_move(self.m_x,self.m_y)
	else
		if self.is_move then
			self.is_move = false
			self.view:playAction( self.move_info.action_id,true)
			self.weapon:playAction(self.move_info.action_id,true) 
			self.move_id = -1
		end
	end

end

function test_avatar:_move( x,y )
	self.view:setPosition(x,y)
	--SceneCamera:lookAt(x,y)
end

function test_avatar.create( root )

	
	--view:initWithActionFile('animations/test',"animations/test/action.json",1,true)

    local view = ccsext.XAnimateSprite:create()
    view:initWithActionJson('animations/avatar',_json)
  	view:playAction(4,true)
	view:setPosition(0,0)
	root:addChild(view)

	payer = test_avatar(view)
	return payer


end

function test_avatar:playAction( id ,repeatforever)
	self.view:playAction( id ,repeatforever)
end

function test_avatar:stopActionByTag( tag )
	self.view:stopActionByTag(tag)
end
function test_avatar:stopMove( ... )
	movetime = 0
end

function test_avatar:move( x,y )
	
	--SceneCamera:lookAt(x,y,true)
	self.m_x,self.m_y = self.view:getPosition()
	self.is_move = true
	local info = self:face_to(x,y)
	self.move_info = info
	self.view:setFlippedX(info.isflip)
    self.weapon:setFlippedX(info.isflip)
	 if info.move_id ~= self.move_id then
	 	 self.move_id =  info.move_id
		 self.view:playAction(info.move_id,true)
		 self.weapon:playAction(info.move_id,true) 
	 end

	
	local m_pos = cc.p(self.m_x,self.m_y)
	local end_pos = cc.p(x,y)
	local distance = cc.pGetDistance(m_pos,end_pos)
	local time = distance/_speed
	movetime = time
	needtime = movetime
	self.distance = distance
	self.target_x = x
	self.target_y = y
	self.start_x = self.m_x
	self.start_y= self.m_y
	-- local function stopAction(  )
	-- 	self.view:playAction( info.action_id,true)
	-- 	self.weapon:playAction(info.action_id,true) 
	-- 	self.move_id = -1
	-- end
	-- local callfunc = cc.CallFunc:create(stopAction)
	-- local  pMove = cc.MoveTo:create(time, end_pos)
 --    local  pSequence = cc.Sequence:create(pMove,callfunc)
 --    pSequence:setTag(100)
	-- self.view:runAction(pSequence)
end

--上,上右，右，右下，下，下左，左，左上 0 1，2，3， 4，5,6,7 
local _dir ={
	{min=7.5,max=0.5,isflip=false,action_id=0,move_id=5},--最后一项特殊
	{min=0.5,max=1.5,isflip=false,action_id=1,move_id=6},
	{min=1.5,max=2.5,isflip=false,action_id=2,move_id=7},
	{min=2.5,max=3.5,isflip=false,action_id=3,move_id=8},
	{min=3.5,max=4.5,isflip=false,action_id=4,move_id=9},
	{min=4.5,max=5.5,isflip=true,action_id=3,move_id=8},
	{min=5.5,max=6.5,isflip=true,action_id=2,move_id=7},
	{min=6.5,max=7.5,isflip=true,action_id=1,move_id=6},

}
-- 改变面向
function test_avatar:face_to( target_x, target_y )
	local dx = math.floor(self.m_x - target_x)
	local dy = math.floor(self.m_y - target_y)
	if dx ~= 0 or dy ~= 0 then
		local new_angle = math.atan2(dy, dx)
		local angle 	= math.deg(new_angle + math.pi / 2)
		self.dir = (1 - angle / 360) * 8 % 8
	end
	--print(self.dir)
	for i=2,8 do
		if self.dir > _dir[i].min and self.dir <= _dir[i].max then
			return _dir[i]
		end
	end
	return _dir[1]
end