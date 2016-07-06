
--Joystick.lua

Joystick = simple_class(GUIWindow)

-- 如果主角一直走的话，我们认为是最远距离是10000像素
local DISTANCE_MAX 			= 10000

--上次移动位置
local _last_x = 1
local _last_y = 1

--角度
local _new_angle = 1
local _old_angle = 1
local _curr_angle = 1

local _is_filse = 1

-- 角度变化的容忍值
local _angle_limit 		= math.pi / 30

function Joystick:__init( view )
	
	self.center_pos = cc.p(0,0)
	self.curr_pos = cc.p(0,0)
	self.radius = 10

	self.is_move = false

	self.bg = self:findWidgetByName('Button_2')
	self.center_img = self:findWidgetByName('Image_1')
	self:register_listener()

	local size = self.bg:getContentSize() 
	self.bg_center_pos =cc.p(size.width/2,size.height/2) 
end

function Joystick:init( center_pos,radius )
	self.center_pos = center_pos
	self.curr_pos = center_pos
	self.radius = radius
	self.view:setAnchorPoint(0.5, 0.5)
	self.view:setPosition(center_pos)
end

function Joystick:getInstance( )
	local joystick =  GUIManager:find_window("joystick")
	if not joystick then
		return  Joystick.new( cc.p(150,150),40 )
	end
	return joystick
end

function Joystick.new( center_pos,radius )
	local win = GUIManager:show_window("joystick")
	win:init(center_pos,radius)
	return win
end

-- function test_Joystick:update( dt )
	
-- end

function Joystick:register_listener(  )

	local function touch(sender,eventType)

        if eventType == ccui.TouchEventType.ended then
        	self.center_img:setPosition(self.bg_center_pos)--cc.p(0,0))
        	self:stop_player()
        elseif eventType == ccui.TouchEventType.began then
        	local tpos = sender:getTouchBeganPosition()
        	self:move_center_img(tpos)
        elseif eventType == ccui.TouchEventType.moved then
        	local tpos = sender:getTouchMovePosition()
        	self:move_center_img(tpos)

        else
        	self.center_img:setPosition(self.bg_center_pos)--cc.p(0,0))
        	self:stop_player()
        end
    end    
	self:addTouchEventListener('Button_2',touch)
end

function Joystick:move_center_img( tpos )
	_new_angle 	= math.atan2(tpos.y, tpos.x)
    _old_angle 	= math.atan2(_last_y, _last_x)
    _curr_angle = _new_angle - _old_angle
    local pos = cc.pSub(tpos ,self.center_pos) 

    --移动摇杆中心
    local distance = cc.pGetLength(pos)
    if distance > self.radius then
		local angle = math.atan2(pos.y,pos.x)
		local f_pos = cc.pForAngle(angle)
		local p= cc.pMul(f_pos,self.radius)
		p = cc.pAdd(p,self.bg_center_pos)
		self.center_img:setPosition(p.x,p.y)
	else
		self.center_img:setPosition(cc.pAdd(pos,self.bg_center_pos))
	end

	--人物移动
	if  (_curr_angle > _angle_limit or _curr_angle < -_angle_limit) then
		_last_x = tpos.x
		_last_y = tpos.y
		self:move_player(pos)
    end

end


function Joystick:move_player( pos )
	local target_pos = cc.pMul(pos,DISTANCE_MAX)
	local x,y = SceneManager:view_pos_to_world_pos(target_pos.x, target_pos.y )
	CommandManager:move( self.player,x,y )
end

function Joystick:stop_player(  )
	self.player:stopMove()
	self.player:stopAction()
end

function Joystick:set_player( player )
	self.player = player
end