module(...,package.seeall)
--test_Joystick.lua

test_Joystick = simple_class(GUIWindow)

-- 如果主角一直走的话，我们认为是最远距离是10000像素
local DISTANCE_MAX 			= 10000

function test_Joystick:__init( view )
	
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

function test_Joystick:init( center_pos,radius )
	self.center_pos = center_pos
	self.curr_pos = center_pos
	self.radius = radius
	self.view:setAnchorPoint(0.5, 0.5)
	self.view:setPosition(center_pos)
end

function test_Joystick:getInstance( ... )
	local joystick =  GUIManager:find_window("joystick")
	if not joystick then
		return  test_Joystick.new( cc.p(150,150),35 )
	end
	return joystick
end

function test_Joystick.new( center_pos,radius )
	local win = GUIManager:show_window("joystick")
	win:init(center_pos,radius)
	return win
end

-- function test_Joystick:update( dt )
	
-- end

function test_Joystick:register_listener(  )

	local function touch(sender,eventType)

        if eventType == ccui.TouchEventType.ended then
        	self.center_img:setPosition(self.bg_center_pos)--cc.p(0,0))
        	self:stop_player()
        elseif eventType == ccui.TouchEventType.began then
        	local tpos = sender:getTouchBeganPosition()
        	self:move_center_img(tpos)
        		print(tpos.x,tpos.y)
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

function test_Joystick:move_center_img( tpos )
    local pos = cc.pSub(tpos ,self.center_pos) 
	pos.x = math.max(pos.x,-self.radius)
	pos.x = math.min(pos.x,self.radius)
	pos.y = math.max(pos.y,-self.radius)
	pos.y = math.min(pos.y,self.radius)
	self.center_img:setPosition(cc.pAdd(pos,self.bg_center_pos))
	self:move_player(pos)
end


function test_Joystick:move_player( pos )
	local target_pos = cc.pMul(pos,DISTANCE_MAX)
	self.player:move(target_pos.x,target_pos.y)
end

function test_Joystick:stop_player(  )
	self.player:stopMove()
end

function test_Joystick:set_player( player )
	self.player = player
end