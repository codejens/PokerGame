
-- model测试用 

MonsterModelTest = simple_class()

--动作config = {}
local _json = [[
    {
      "actions": {
          "0": {
              "restoreOriginalFrame" : false,
              "loop" : 3,
              "delay" : 0.75,
              "frames": { "start": 0, "end": 2 }
          },
          "1": {
              "restoreOriginalFrame" : false,
              "loop" : 3,
              "delay" : 0.75,
              "frames": { "start": 3, "end": 5 }
          },
          "2": {
              "restoreOriginalFrame" : false,
              "loop" : 3,
              "delay" : 0.75,
              "frames": { "start": 6, "end": 8 }
          },
          "3": {
              "restoreOriginalFrame" : false,
              "loop" : 3,
              "delay" : 0.07,
              "frames": { "start": 9, "end": 12 }
          },
          "4": {
              "restoreOriginalFrame" : false,
              "loop" : 3,
              "delay" : 0.07,
              "frames": { "start": 13, "end": 16 }
          },
          "5": {
              "restoreOriginalFrame" : false,
              "loop" : 3,
              "delay" : 0.07,
              "frames": { "start": 17, "end": 20 }
          }
          ,
          "6": {
              "restoreOriginalFrame" : false,
              "loop" : 3,
              "delay" : 0.07,
              "frames": { "start": 21, "end": 24 }
          },
          "7": {
              "restoreOriginalFrame" : false,
              "loop" : 3,
              "delay" : 0.07,
              "frames": { "start": 25, "end": 28 }
          },
          "8": {
              "restoreOriginalFrame" : false,
              "loop" : 3,
              "delay" : 0.07,
              "frames": { "start": 29, "end": 32 }
          }
      }
    }
    ]]



local _FACE_COUNT = 6        -- 朝向数

local _speed = 200
local _frametime = 0
local _movetime = 0
local _needtime = 0


function MonsterModelTest:__init( handle )
	self.model_root = cc.Node:create()
	self.model_root:setPosition(0,0)
    self.body = nil    -- 身体

   --页游坐标调试页游服务器
    self.web_x = 0
    self.web_y = 0
    --end

    self.m_x = 200
	self.m_y = 200
	self.target_x = 0
	self.target_y = 0
	self.move_id = -1
	self.is_move = false

    self:createBody()


    self.move_time = timer:create( )
	local function update_move( dt )
		self:update_move(dt)
	end
	self.move_time:start(0,update_move)

end

-- 创建模型
function MonsterModelTest:createBody(  )
	self.body = ccsext.XAnimateSprite:create()
	self.body:initWithActionJson('animations/monster/G003',_json)
	self.body:playAction(0,true)
	self.body:setPosition(0,0)
	self.model_root:addChild( self.body )


end

function MonsterModelTest:show_name( name )
	if not self.name then
		self.name = GUIText:create(name,FONT_SIZE_NORMAL)
	end
	self.name:setString(name)
	self.name:setPosition(0,100)
	self.model_root:addChild(self.name.view)
end


function MonsterModelTest:update_move( dt )
	_frametime = dt

	if _movetime > 0 then
		self.m_x = self.m_x + (self.target_x-self.start_x)*(_frametime/_needtime)
		self.m_y = self.m_y + (self.target_y-self.start_y)*(_frametime/_needtime)
		_movetime = _movetime - _frametime
		self:_move(self.m_x,self.m_y)
	else
		if self.is_move then
			self.is_move = false
			self.body:playAction( self.move_info.action_id,true)
			self.move_id = -1
		end
	end

end

function MonsterModelTest:_move( x,y )
	self.model_root:setPosition(x,y)

end


function MonsterModelTest:stopMove( ... )
	_movetime = 0
end

function MonsterModelTest:move( x,y )
	--y = -y
	self.m_x,self.m_y = self.model_root:getPosition()
	self.is_move = true
	local info = self:face_to(x,y)
	self.move_info = info

	self.model_root:setFlippedX(info.isflip)
	self.body:setFlippedX(info.isflip)
    
    
	if info.move_id ~= self.move_id then
	 	 self.move_id =  info.move_id
		 self.body:playAction(info.move_id,true)
	end

	local m_pos = cc.p(self.m_x,self.m_y)
	local end_pos = cc.p(x,y)
	local distance = cc.pGetDistance(m_pos,end_pos)
	local time = distance/_speed
	_movetime = time
	_needtime = _movetime
	self.distance = distance
	self.target_x = x
	self.target_y = y
	self.start_x = self.m_x
	self.start_y= self.m_y
end

--上右，右，右下，下左，左，左上   1，2，3， 4，5,6, 
local _dir ={
	{  isflip=false, action_id=0, move_id=3,act_id=6 },    --  方向1
	{  isflip=false, action_id=1, move_id=4,act_id=7 },
	{  isflip=false, action_id=2, move_id=5,act_id=8 },
	{  isflip=true,  action_id=2, move_id=5,act_id=8 },
	{  isflip=true,  action_id=1, move_id=4,act_id=7 },
	{  isflip=true,  action_id=0, move_id=3,act_id=6 }

}
-- 改变面向
function MonsterModelTest:face_to( target_x, target_y )
	local dx = math.floor(self.m_x - target_x)
	local dy = math.floor(self.m_y - target_y)
	if dx ~= 0 or dy ~= 0 then
		local new_angle = math.atan2(dy, dx)
		local angle 	= math.deg(new_angle + math.pi / 2)
		self.dir = math.ceil( (1 - angle / 360) * _FACE_COUNT % _FACE_COUNT ) 
	end
	return _dir[self.dir]
end

function MonsterModelTest:getPosition()
	local x,y = self.model_root:getPosition()
	return x,y
end

function MonsterModelTest:setPosition( x,y )
	self.model_root:setPosition(x,y)
end
