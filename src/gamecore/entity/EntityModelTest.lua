
-- -- model测试用 

-- EntityModelTest = simple_class()

-- --动作config = {}
-- local _json = [[
--     {
--       "actions": {
--           "0": {
--               "restoreOriginalFrame" : false,
--               "loop" : 3,
--               "delay" : 0.25,
--               "frames": { "start": 0, "end": 3 }
--           },
--           "1": {
--               "restoreOriginalFrame" : false,
--               "loop" : 3,
--               "delay" : 0.25,
--               "frames": { "start": 4, "end": 7 }
--           },
--           "2": {
--               "restoreOriginalFrame" : false,
--               "loop" : 3,
--               "delay" : 0.25,
--               "frames": { "start": 8, "end": 11 }
--           },
--           "3": {
--               "restoreOriginalFrame" : false,
--               "loop" : 3,
--               "delay" : 0.07,
--               "frames": { "start": 12, "end": 23 }
--           },
--           "4": {
--               "restoreOriginalFrame" : false,
--               "loop" : 3,
--               "delay" : 0.07,
--               "frames": { "start": 24, "end": 35 }
--           },
--           "5": {
--               "restoreOriginalFrame" : false,
--               "loop" : 3,
--               "delay" : 0.07,
--               "frames": { "start": 36, "end": 47 }
--           },
--             "6": {
--               "restoreOriginalFrame" : false,
--               "loop" : 1,
--               "delay" : 0.15,
--                "frames": [ 48,51,52,53,54,55]
--           },
--           "7": {
--               "restoreOriginalFrame" : false,
--               "loop" : 1,
--               "delay" : 0.15,
--          	  "frames": [ 49,56,57,58,59,60]
--           },
--           "8": {
--               "restoreOriginalFrame" : false,
--               "loop" : 1,
--               "delay" : 0.15,
--                "frames": [ 50,61,62,63,64,65]
--           }
--           ,
--           "9": {
--               "restoreOriginalFrame" : false,
--               "loop" : 1,
--               "delay" : 0.15,
--          	  "frames": [ 48,66,67,68,69,70]
--           },
--           "10": {
--               "restoreOriginalFrame" : false,
--               "loop" : 1,
--               "delay" : 0.15,
--                "frames": [ 49,71,72,73,74,75]
--           }
--           ,
--           "11": {
--               "restoreOriginalFrame" : false,
--               "loop" : 1,
--               "delay" : 0.15,
--                "frames": [ 50,76,77,78,79,80]
--           },
--            "12": {
--               "restoreOriginalFrame" : false,
--               "loop" : 3,
--               "delay" : 0.25,
--               "frames": { "start": 81, "end": 86 }
--           },
--           "13": {
--               "restoreOriginalFrame" : false,
--               "loop" : 3,
--               "delay" : 0.25,
--               "frames": { "start": 87, "end": 92 }
--           },
--           "14": {
--               "restoreOriginalFrame" : false,
--               "loop" : 3,
--               "delay" : 0.25,
--               "frames": { "start": 93, "end": 98 }
--           },
--           "15": {
--               "restoreOriginalFrame" : false,
--               "loop" : 3,
--               "delay" : 0.07,
--               "frames": { "start": 99, "end": 106 }
--           },
--           "16": {
--               "restoreOriginalFrame" : false,
--               "loop" : 3,
--               "delay" : 0.07,
--               "frames": { "start": 107, "end": 114 }
--           },
--           "17": {
--               "restoreOriginalFrame" : false,
--               "loop" : 3,
--               "delay" : 0.07,
--               "frames": { "start": 115, "end": 122 }
--           }
--       }
--     }
--     ]]

--     --坐骑动画配置  = {}
-- local _riding_action_config = [[
--     {
--       "actions": {
--           "0": {
--               "restoreOriginalFrame" : false,
--               "loop" : 3,
--               "delay" : 0.25,
--               "frames": { "start": 0, "end": 5 }
--           },
--           "1": {
--               "restoreOriginalFrame" : false,
--               "loop" : 3,
--               "delay" : 0.25,
--               "frames": { "start": 6, "end": 11 }
--           },
--           "2": {
--               "restoreOriginalFrame" : false,
--               "loop" : 3,
--               "delay" : 0.25,
--               "frames": { "start": 12, "end": 17 }
--           },
--           "3": {
--               "restoreOriginalFrame" : false,
--               "loop" : 3,
--               "delay" : 0.07,
--               "frames": { "start": 18, "end": 25 }
--           },
--           "4": {
--               "restoreOriginalFrame" : false,
--               "loop" : 3,
--               "delay" : 0.07,
--               "frames": { "start": 26, "end": 33 }
--           },
--           "5": {
--               "restoreOriginalFrame" : false,
--               "loop" : 3,
--               "delay" : 0.07,
--               "frames": { "start": 34, "end": 41 }
--           }
--       }
--     }
--     ]]


--     --攻击动画配置  = {}
-- local _atta_action_config = [[
--     {
--       "actions": {
--           "0": {
--               "restoreOriginalFrame" : false,
--               "loop" : 1,
--               "delay" : 0.15,
--                "frames": [ 0,3,4,5,6,7]
--           },
--           "1": {
--               "restoreOriginalFrame" : false,
--               "loop" : 1,
--               "delay" : 0.15,
--          	  "frames": [ 1,8,9,10,11,12]
--           },
--           "2": {
--               "restoreOriginalFrame" : false,
--               "loop" : 1,
--               "delay" : 0.15,
--                "frames": [ 2,13,14,15,16,17]
--           }
--           ,
--           "3": {
--               "restoreOriginalFrame" : false,
--               "loop" : 1,
--               "delay" : 0.15,
--          	  "frames": [ 0,18,19,20,21,22]
--           },
--           "4": {
--               "restoreOriginalFrame" : false,
--               "loop" : 1,
--               "delay" : 0.15,
--                "frames": [ 1,23,24,25,26,27]
--           }
--           ,
--           "5": {
--               "restoreOriginalFrame" : false,
--               "loop" : 1,
--               "delay" : 0.15,
--                "frames": [ 2,28,29,30,31,32]
--           }
--       }
--     }
--     ]]

--     --攻击动画配置  = {}
-- local _skill_1_action_config = [[
--     {
--       "actions": {
--           "0": {
--               "restoreOriginalFrame" : false,
--               "loop" : 0,
--               "delay" : 0.1,
--               "frames": { "start": 0, "end": 19 }
--           }
--       }
--   }
--     ]]



-- local _FACE_COUNT = 6        -- 朝向数

-- local _speed = 200
-- local _frametime = 0
-- local _movetime = 0
-- local _needtime = 0

-- local _is_riding = false

-- function EntityModelTest:setWebPositionX(x)
-- 	self.web_x = x
-- end
-- function EntityModelTest:setWebPositionX(y)
-- 	self.web_y = y
-- end

-- function EntityModelTest:show_name( name )
-- 	if not self.name then
-- 		self.name = GUILabel.create(name,FONT_SIZE_NORMAL)
-- 	end
-- 	self.name:setString(name)
-- 	self.name:setPosition(0,100)
-- 	self.model_root:addChild(self.name.view)
-- end

-- function EntityModelTest:__init( handle )
-- 	self.model_root = ccsext.XAnimateSprite:create()
-- 	self.model_root:setPosition(0,0)
--     self.body = nil    -- 身体
--     self.weapon = nil  -- 武器

--     self.riding_body = nil -- 坐骑身体不一样

--     --页游坐标调试页游服务器
--     self.web_x = 0
--     self.web_y = 0
--     --end

--     self.m_x = 200
-- 	self.m_y = 200
-- 	self.target_x = 0
-- 	self.target_y = 0
-- 	self.move_id = -1
-- 	self.is_move = false

-- 	self.move_listener_func = nil     -- 移动监听。当位置移动的时候回调。

	

--     self:createBody()
--     self:createWeapon()
--     self:createskill()


--     self.move_time = timer:create( )
-- 	local function update_move( dt )
-- 		self:update_move(dt)
-- 	end
-- 	self.move_time:start(0,update_move)

-- end


-- -- 创建技能
-- function EntityModelTest:createskill(  )

-- 	self.skill = {}
		
-- 		local path = string.format('animations/skill/sj_skill/skill_bs')
-- 		for i=1,10 do
-- 			self.skill[i] = ccsext.XAnimateSprite:create()
-- 			self.skill[i]:initWithActionJson(path,_skill_1_action_config)
-- 			self.skill[i]:setPosition(-300+((i-1)%5)*150,math.ceil(i/5)*300-500)
-- 			self.model_root:addChild( self.skill[i] )
			
-- 		end
-- 		self.skill[1]:setBlendFunc(cc.blendFunc(gl.ONE, gl.DST_ALPHA))
-- 		self.skill[2]:setBlendFunc(cc.blendFunc(gl.ONE_MINUS_SRC_COLOR, gl.DST_ALPHA))
-- 		self.skill[3]:setBlendFunc(cc.blendFunc(gl.SRC_COLOR, gl.DST_ALPHA))
-- 		self.skill[4]:setBlendFunc(cc.blendFunc(gl.SRC_COLOR, gl.DST_ALPHA))
-- 		self.skill[5]:setBlendFunc(cc.blendFunc(gl.SRC_ALPHA, gl.DST_ALPHA))

-- 		self.skill[6]:setBlendFunc(cc.blendFunc(gl.ONE, gl.ONE_MINUS_SRC_ALPHA))
-- 		self.skill[7]:setBlendFunc(cc.blendFunc(gl.ONE_MINUS_SRC_COLOR, gl.ONE_MINUS_SRC_ALPHA))
-- 		self.skill[8]:setBlendFunc(cc.blendFunc(gl.ONE_MINUS_DST_COLOR, gl.ONE_MINUS_SRC_ALPHA))
-- 		self.skill[9]:setBlendFunc(cc.blendFunc(gl.ONE_MINUS_SRC_COLOR, gl.ONE_MINUS_SRC_ALPHA))
-- 		self.skill[10]:setBlendFunc(cc.blendFunc(gl.ONE_MINUS_SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA))
-- -- 		_G.GL_ZERO                           = gl.ZERO
-- -- _G.GL_ONE                            = gl.ONE
-- -- _G.GL_SRC_COLOR                      = gl.SRC_COLOR
-- -- _G.GL_ONE_MINUS_SRC_COLOR            = gl.ONE_MINUS_SRC_COLOR
-- -- _G.GL_SRC_ALPHA                      = gl.SRC_ALPHA
-- -- _G.GL_ONE_MINUS_SRC_ALPHA            = gl.ONE_MINUS_SRC_ALPHA
-- -- _G.GL_DST_ALPHA                      = gl.DST_ALPHA
-- -- _G.GL_ONE_MINUS_DST_ALPHA            = gl.ONE_MINUS_DST_ALPHA
-- -- _G.GL_DST_COLOR                      = gl.DST_COLOR
-- -- _G.GL_ONE_MINUS_DST_COLOR            = gl.ONE_MINUS_DST_COLOR

-- end


-- -- 创建模型
-- function EntityModelTest:createBody(  )
-- 	self.body = ccsext.XAnimateSprite:create()
-- 	self.body:initWithActionJson('animations/avatar/move',_json,4,true)
-- 	self.body:setPosition(0,0)
-- 	self.model_root:addChild( self.body )
-- end

-- -- 创建兵器
-- function EntityModelTest:createWeapon(  )
-- 	self.weapon = ccsext.XAnimateSprite:create()
--     self.weapon:initWithActionJson('animations/weapon/move',_json,4,true)
-- 	-- self.weapon:setPosition(455,455)
-- 	self.model_root:addChild( self.weapon )
-- end

-- function EntityModelTest:atta( id )
-- 	self:stopMove()
-- 	self:get_off_riding()
-- 	self.body:setVisible(false)
-- 	self.weapon:setVisible( false )
-- 	if not self.atta_body then
--         self.atta_body = ccsext.XAnimateSprite:create()
-- 		self.atta_body:initWithActionJson('animations/avatar/atta',_atta_action_config,id,true)
-- 		self.model_root:addChild( self.atta_body )  
-- 	else
-- 		--local id = math.random(0,2)
-- 		self.atta_body:playAction(id,true)
-- 	end
-- 	if not self.atta_weapon then
--        self.atta_weapon = ccsext.XAnimateSprite:create()
-- 		self.atta_weapon:initWithActionJson('animations/weapon/attack',_atta_action_config,id,true)
-- 		self.model_root:addChild( self.atta_weapon )  
-- 	else
-- 		self.atta_weapon:playAction(id,true)
-- 	end

-- 	if self.atta_body then
-- 		self.atta_body:setVisible(true)
-- 		self.atta_weapon:setVisible(true)
-- 		self.body:setVisible(false)
-- 		self.weapon:setVisible(false)
-- 	end

-- 	for i=1,10 do
-- 		self.skill[i]:playAction(0,false)
-- 	end
	

-- end
-- -- 上坐骑
-- function EntityModelTest:get_on_riding( ... )
-- 	print("上坐骑")
-- 	_is_riding = true
-- 	self.body:setVisible(false)
-- 	self.weapon:setVisible( false )
-- 	if self.atta_body then
-- 		self.atta_body:setVisible(false)

-- 	end
-- 	if	self.atta_weapon then
-- 		self.atta_weapon:setVisible(false)
-- 	end
-- 	-- 如果还没创建就创建
-- 	if self.riding == nil then 
--         self.riding = ccsext.XAnimateSprite:create()
-- 		self.riding:initWithActionJson('animations/riding',_riding_action_config,4,true)
-- 		self.model_root:addChild( self.riding )  
-- 	end
-- 	if self.riding_body == nil then 
--         self.riding_body = ccsext.XAnimateSprite:create()
-- 		self.riding_body:initWithActionJson('animations/avatar/ride',_riding_action_config,4,true)
-- 		self.model_root:addChild( self.riding_body )  
-- 	end

-- 	self.riding_body:setVisible( true )
-- 	self.riding:setVisible( true )
-- end



-- -- 下坐骑
-- function EntityModelTest:get_off_riding(  )
-- 	_is_riding = false
-- 	self.body:setVisible( true )
-- 	self.weapon:setVisible( true )
-- 	self.riding_body:setVisible( false )
-- 	self.riding:setVisible( false )
-- end


-- -- 注册移动监听
-- function EntityModelTest:register_move_listener( listener_func )
-- 	self.move_listener_func = listener_func
-- end


-- function EntityModelTest:update_move( dt )
-- 	_frametime = dt

-- 	if _movetime > 0 then
-- 		self.m_x = self.m_x + (self.target_x-self.start_x)*(_frametime/_needtime)
-- 		self.m_y = self.m_y + (self.target_y-self.start_y)*(_frametime/_needtime)
-- 		_movetime = _movetime - _frametime
-- 		self:_move(self.m_x,self.m_y)
-- 	else
-- 		if self.is_move then
-- 			self.is_move = false
-- 			if not _is_riding then
-- 				self.body:playAction( self.move_info.action_id,true)
-- 				self.weapon:playAction(self.move_info.action_id,true) 
-- 			elseif self.riding_body and self.riding then 
--                 self.riding_body:playAction(self.move_info.action_id,true) 
--                 self.riding:playAction( self.move_info.action_id,true )
-- 			end
-- 			MoveSystemCC:req_stop_move(self.m_x*1.41994,self.m_y*1.3427,1)
-- 			self.move_id = -1
-- 		end
-- 	end

-- end

-- function EntityModelTest:_move( x,y )
-- 	self.model_root:setPosition(x,y)
-- 	if self.move_listener_func then 
--         self.move_listener_func( x, y )
-- 	end
-- 	-- SceneCamera:lookAt(x,y)
-- end


-- function EntityModelTest:stopMove( ... )
-- 	_movetime = 0
-- end

-- function EntityModelTest:move( x,y,mx,my )
-- 	--y = -y
-- 	if self.atta_body then
-- 		self.atta_body:setVisible(false)
-- 		self.atta_weapon:setVisible(false)
-- 		self.body:setVisible(not _is_riding)
-- 		self.weapon:setVisible(not _is_riding)
-- 	end

-- 		local player_info = DefaultSystemModel:get_player_info(  )
-- 		self.m_x,self.m_y = self.model_root:getPosition()
-- 	print(self.m_x,self.m_y,player_info.attribute.x,player_info.attribute.y)


-- 	MoveSystemCC:req_start_move(player_info.attribute.x,player_info.attribute.y,mx*4/3,my*4/3)
-- 	--MoveCC:request_start_move(self.m_x,self.m_y,x*1.41994,y*1.3427)
-- 	self.is_move = true
-- 	local info = self:face_to(x,y)
-- 	self.move_info = info

-- 	self.model_root:setFlippedX(info.isflip)
-- 	self.body:setFlippedX(info.isflip)
--     self.weapon:setFlippedX(info.isflip)

--     if self.riding_body and self.riding then 
-- 	    self.riding_body:setFlippedX(info.isflip)
-- 	    self.riding:setFlippedX(info.isflip)
--     end

-- 	if info.move_id ~= self.move_id then
-- 	 	 self.move_id =  info.move_id
-- 	 	 if not _is_riding then
-- 		 	self.body:playAction(info.move_id,true)
-- 		 	self.weapon:playAction(info.move_id,true) 
-- 		 else
-- 		 	if self.riding_body and self.riding then 
-- 	        self.riding_body:playAction(info.move_id,true) 
-- 		    self.riding:playAction( info.move_id,true )
-- 			end
-- 		 end
-- 	end



	
-- 	local m_pos = cc.p(self.m_x,self.m_y)
-- 	local end_pos = cc.p(x,y)
-- 	local distance = cc.pGetDistance(m_pos,end_pos)
-- 	local time = distance/_speed
-- 	_movetime = time
-- 	_needtime = _movetime
-- 	self.distance = distance
-- 	self.target_x = x
-- 	self.target_y = y
-- 	self.start_x = self.m_x
-- 	self.start_y= self.m_y
-- end

-- --上右，右，右下，下左，左，左上   1，2，3， 4，5,6, 
-- _dir ={
-- 	{  isflip=false, action_id=0, move_id=3 },    --  方向1
-- 	{  isflip=false, action_id=1, move_id=4 },
-- 	{  isflip=false, action_id=2, move_id=5 },
-- 	{  isflip=true,  action_id=2, move_id=5 },
-- 	{  isflip=true,  action_id=1, move_id=4 },
-- 	{  isflip=true,  action_id=0, move_id=3 }

-- }
-- -- 改变面向
-- function EntityModelTest:face_to( target_x, target_y )
-- 	local dx = math.floor(self.m_x - target_x)
-- 	local dy = math.floor(self.m_y - target_y)
-- 	if dx ~= 0 or dy ~= 0 then
-- 		local new_angle = math.atan2(dy, dx)
-- 		local angle 	= math.deg(new_angle + math.pi / 2)
-- 		self.dir = math.ceil( (1 - angle / 360) * _FACE_COUNT % _FACE_COUNT ) 
-- 	end
-- 	return _dir[self.dir] or _dir[1]
-- end

-- function EntityModelTest:getPosition()
-- 	local x,y = self.model_root:getPosition()
-- 	return x,y
-- end

-- function EntityModelTest:setPosition( x,y )

-- 	self.model_root:setPosition(x,y)
-- end