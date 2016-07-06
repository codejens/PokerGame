--MainPanelJoystick.lua
--created by liubo on 2015-05-26
--主界面摇杆模块

MainPanelJoystick = simple_class(GUIStudioView)

local _LAYOUT_FILE = "layout/studio/mainpanel/joystick/stu_mainpanel_joystick.lua"     -- 本页的布局文件
local _POS_X, _POS_Y = 150, 100 -- 摇杆的位置

--上次移动位置
local _last_x = 1
local _last_y = 1

-- 角度变化的容忍值
local _angle_limit = math.pi / 30

---对外接口---

--------------

--创建
function MainPanelJoystick:create(  )
	return self:createWithLayout( _LAYOUT_FILE )
end

--构造方法
function MainPanelJoystick:__init( view )
	self:register_listener()
end

--初始化页
function MainPanelJoystick:viewCreateCompleted()
	self.bg = self:findLayoutViewByName('Button_2')
	self.center_img = self:findLayoutViewByName('Image_1')
	local center_img_pos_x = self.center_img:getPositionX()
	local center_img_pos_y = self.center_img:getPositionY()

	local bg_size = self.bg:getContentSize()
	local center_img_size = self.center_img:getContentSize()

	self.bg_center_pos = cc.p(bg_size.width / 2, bg_size.height / 2)
	self.radius = (bg_size.width - center_img_size.width) / 2 + 5
	self.center_pos = cc.p(_POS_X + center_img_pos_x, _POS_Y + center_img_pos_y)
	self.view:setPosition(_POS_X, _POS_Y)
end

--移动摇杆
function MainPanelJoystick:move_center_img(tpos)
	local _new_angle = math.atan2(tpos.y, tpos.x)
    local _old_angle = math.atan2(_last_y, _last_x)
    local _curr_angle = _new_angle - _old_angle
    local pos = cc.pSub(tpos, self.center_pos) --计算两点间的差分

    --移动摇杆中心
    local distance = cc.pGetLength(pos) --坐标点到原点的距离
    if distance > self.radius then
		local angle = math.atan2(pos.y, pos.x)
		local f_pos = cc.pForAngle(angle)
		local p = cc.pMul(f_pos, self.radius)
		p = cc.pAdd(p, self.bg_center_pos)
		self.center_img:setPosition(p.x, p.y)
	else
		self.center_img:setPosition(cc.pAdd(pos, self.bg_center_pos))
	end
	if  (_curr_angle > _angle_limit or _curr_angle < -_angle_limit) then
		_last_x = tpos.x
		_last_y = tpos.y
		MainPanelCC:move_joystick(pos)
    end
end

-- 注册事件回调
function MainPanelJoystick:register_listener( ... )
	local function touch(sender,eventType)
        if eventType == ccui.TouchEventType.ended then
        	self.center_img:setPosition(self.bg_center_pos)
        	MainPanelCC:stop_joystick()
        elseif eventType == ccui.TouchEventType.began then
        	local tpos = sender:getTouchBeganPosition()
        	self:move_center_img(tpos)
        elseif eventType == ccui.TouchEventType.moved then
        	local tpos = sender:getTouchMovePosition()
        	self:move_center_img(tpos)
        else
        	self.center_img:setPosition(self.bg_center_pos)
        	MainPanelCC:stop_joystick()
        end
    end    
	self:widgetTouchEventListener('Button_2',touch)
end

-- 更新
-- @param update_type 更新类型
-- @param data 更新的数据 
function MainPanelJoystick:update( update_type, data )
	if update_type == "" then

	end
end

---激活
function MainPanelJoystick:active(  )

end

--非激活
function MainPanelJoystick:unActive(  )

end