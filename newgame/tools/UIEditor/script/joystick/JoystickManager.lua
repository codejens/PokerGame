-- JoystickManager.lua
-- created by aXing on 2012-11-16
-- 管理游戏内唯一摇杆的类
-- 获取摇杆方向，移动属性等...

-- super_class.JoystickManager()
JoystickManager = {}

local _joystick_root 		= nil			-- 根节点
local _joystick 			= nil			-- 摇杆控件
local _joystick_bg			= nil
local _joystick_rock		= nil
local _visible				= false			-- 是否显示，控制帧函数
local _joystick_z_order	    = 0				-- ui控件深度

local _is_moving 			= false			-- 看角色是否在移动

local CAMERA_WIDTH_LIMIT	= 100			-- 超出左右100像素，则移动镜头
local CAMERA_HEIGHT_LIMIT	= 60			-- 超出上下60像素，则移动镜头

-- 如果主角一直走的话，我们认为是最远距离是10000像素
local DISTANCE_MAX 			= 10000
-- 记录目前主角的移动方向，如果只有些许偏差，则不告诉服务器
local _now_direction 		= {x = 0, y = 0}
-- 角度变化的容忍值
local _direction_limit 		= math.pi / 30

local _d2rWidth = UIScreenPos.designToRelativeWidth
local _d2rHeight = UIScreenPos.designToRelativeHeight

-- 创建摇杆
local function create_joystick()
	local center	= CCPointMake(_d2rWidth(155), _d2rHeight(125))
	local radius	= 50
	local js 		= CCSprite:spriteWithFile("ui/lh_joystick/joystick.png")--"ui/main/joystick.png")
	local bg 		= CCSprite:spriteWithFile("ui/lh_joystick/joystickBg.png") --"ui/main/joystickBG.png")	
	-- local bg_glow 	= CCSprite:spriteWithFile(UILH_MAIN.joystickBg) --"ui/main/joystickBG.png")	
	local joystick 	= CCJoystick:joystickWithCenter(center, radius, js, bg)

	-- bg_glow:setPosition(CCPointMake(80,80.5))
	-- bg:addChild(bg_glow)

	-- local b = ccBlendFunc()
	-- b.src = 1
	-- b.dst = 1
	-- bg_glow:setBlendFunc(b)

	return joystick, bg, js
end

-- 初始化摇杆
function JoystickManager:init( root, z_order )

	if _joystick_root ~= nil then
		print("joystick manager has been initialized!")
		return
	end

	_joystick_root = root
	-- root:addChild(_joystick_root, z_order)
	_joystick_z_order = z_order
end

-- 获取摇杆控件
function JoystickManager:get_joystick(  )
	return _joystick
end

--显示摇杆
function JoystickManager:set_visible( visible )
	
	if _visible == visible then
		return
	end

	if _joystick == nil then
		_joystick, _joystick_bg, _joystick_rock = create_joystick()
		_joystick_root:addChild(_joystick, _joystick_z_order)
	end

	_joystick:setIsVisible(visible)
	-- if visible then
		-- _joystick_root:addChild(_joystick, _joystick_z_order)
		-- _joystick:active()
	-- else
		-- _joystick:inactive()
		-- _joystick_root:removeChild(_joystick, false)
	-- end

	_visible = visible
	if not visible then
		self:stopTimer()
	else
		self:startTimer()
	end
end


function JoystickManager:startTimer()
	if self.joysticktimer then
		self.joysticktimer:stop()
	end

	local joystick = _joystick
	local joysticktimer = timer()

	-- check direction at every frame
    local function tick( dt )

    	if not _visible then
    		return
    	end

        local direction = joystick:getDirection()
        local player_avatar = EntityManager:get_player_avatar()

        if direction.x == 0 and direction.y == 0 then
        	if _is_moving then

        		-- added by aXing on 2013-6-4
        		-- 添加BI打点，操作摇杆的次数
        		Analyze:parse_jostick()

        		CommandManager:move(player_avatar.x, player_avatar.y, true,nil,player_avatar)
        		_is_moving	 	= false
        		_now_direction	= {x = 0, y = 0}

        	end
        	_joystick_rock:setOpacity(100)
        	_joystick_bg:setOpacity(50)
        	-- _joystick_bg_glow:setIsVisible(false)
        	return
        end
        _joystick_rock:setOpacity(255)
        _joystick_bg:setOpacity(255)
        -- _joystick_bg_glow:setIsVisible(true)
        -- 第一次摇摇杆
        if _is_moving == false then
        	-- 当前玩家没有动作的话，则要判断它是不是在双修
			if ( player_avatar._current_action == nil) then
				if ( DaZuoWin:scene_on_click() ) then
					-- 重置AIManager
					AIManager:set_AIManager_idle(  )
				end
			end
        end

        _is_moving = true

		-- 这里是控制人物移动的
		-- 步速(像素/秒) = 格子宽度 / 人物移动速度
		-- 主角自身是需要自己根据移动方向改变朝向的
		local new_angle 	= math.atan2(direction.y, direction.x)
		local angle 		= math.deg(new_angle + math.pi / 2)

		player_avatar.dir   = (1 - angle / 360) * 8 % 8



		-- 这里认为主角跑无限远
		local final_x 		= player_avatar.model.m_x + direction.x * DISTANCE_MAX
		local final_y 		= player_avatar.model.m_y - direction.y * DISTANCE_MAX

		local need_update 	= false
		if _now_direction.x == 0 and _now_direction.y == 0 then
			-- 如果从没有摇杆到开始摇杆，则认为一定需要更新
			need_update		= true
			_now_direction 	= direction
		else
			-- 我们认为如果角度只有些许偏差，则不告诉服务器
			local old_angle 	= math.atan2(_now_direction.y, _now_direction.x)
			local dAngle 		= new_angle - old_angle
			
			-- 如果移动角度在容忍的范围内，则不会向服务器更新
			if dAngle > _direction_limit or dAngle < -_direction_limit then
				need_update 	= true
				_now_direction 	= direction
				-- _joystick_bg:setRotation(angle)
				
			end
		end

		CommandManager:move(final_x, final_y, need_update,nil,player_avatar, true)

		PowerCenter:OnPlayerTakeAction()
    end

    joysticktimer:start(t_jstk_, tick)

    self.joysticktimer = joysticktimer
end

function JoystickManager:stopTimer()
	self.joysticktimer:stop()
	self.joysticktimer = nil
end