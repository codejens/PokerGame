-- ActionApproachStatic.lua
-- created by aXing on 2013-1-22
-- 主角靠近行为类

-- require "action/ActionMove"
-- require "action/ActionConfig"
-- require "config/SceneConfig"

-- 靠近某个目标地点
ActionApproachStatic = simple_class(ActionMove)

-- 靠近的计算方式是：判断当前是否有指定的entity
-- 靠近范围必须是单数
-- 同屏靠近将会存在三个参数
-- @tile_x 要靠近的逻辑格子横坐标
-- @tile_y 要靠近的逻辑格子纵坐标
-- @distance 靠近范围，以目标中心做矩形范围，参数为矩形边长
function ActionApproachStatic:__init( args )
	ActionMove.__init(self, nil)
	--self.name = "ActionApproachStatic"		--测试用;
	--xprint("ActionApproachStatic:__init()")
	self.class_name = "ActionApproachStatic";

	self.target_model_x	= args.tile_x or 0;
	self.target_model_y	= args.tile_y or 0;
	self.distance 		= args.distance
	self.need_send_to_server = true
	-- xprint("")
	self:_start_xl();

	if self.player and args.tile_x and args.tile_y then
		if ( self.player.type == -1 ) then
			local tx,ty =  SceneManager:tile_to_pixels( args.tile_x,  args.tile_y)
			self.player:onActionMove(tx,ty)
		end
	end
end

function ActionApproachStatic:error()

end

function ActionApproachStatic:_start_xl()
	
	self.path_index = 1;
	-- 先计算第一次符合距离的目标点，然后发第一次服务器包

	local ret = self:_calculate_nearest_position()

	if not ret then
		--print("ActionApproachStatic:__init1.5")
		--print("ActionApproachStatic,self.target_x, self.target_y",self.target_x, self.target_y)
		self:_calculate_path_node(self.target_x, self.target_y)
	end

	--end
	if ( self.path and #self.path > 1 ) then 
		-- 播放要移动到的目的地的特效
		LuaEffectManager:stop_map_effect( 21 )
		local point = CCPoint(self.path[#self.path-1],self.path[#self.path]);
		ZXGameScene:sharedScene():mapPosToGLPos(point)
		-- 播放移动目标的特效
		LuaEffectManager:play_map_effect( 21,point.x,point.y,true,10000 )
	end
end

-- 计算最近符合要求的坐标
-- 如果已经符合靠近要求，则返回true
function ActionApproachStatic:_calculate_nearest_position(  )
	--print("ActionApproachStatic:_calculate_nearest_position(  )")
	-- 首先要计算出目标在哪个格子
	--local target = EntityManager:get_entity(self.target_id)
	--local target_tile_x	= target.model.m_x / SceneConfig.LOGIC_TILE_WIDTH
	--local target_tile_y = target.model.m_y / SceneConfig.LOGIC_TILE_HEIGHT

	-- local player_tile_x = self.player.x / SceneConfig.LOGIC_TILE_WIDTH
	-- local player_tile_y = self.player.y / SceneConfig.LOGIC_TILE_HEIGHT
	-- print("_calculate_nearest_position,self.target_model_x",self.target_model_x);
	local player_tile_x, player_tile_y = SceneManager:pixels_to_tile(self.player.x, self.player.y)


	-- 优先判断，如果在最佳范围，则可以直接跳出
	local dx = self.distance[1] 			
	local dy = self.distance[2] 			

	-- edited by aXing on 判断是否可以靠近改为椭圆
	-- 去掉 by hwl
	-- if  math.abs(self.target_model_x - player_tile_x) <= dx and
	-- 	math.abs(self.target_model_y - player_tile_y) <= dy then
	-- 	self.target_tile_x = player_tile_x
	-- 	self.target_tile_y = player_tile_y
	-- 	self.target_x = self.player.x
	-- 	self.target_y = self.player.y
	-- 	self:end_action()
	-- 	return true
	-- end

	-- for j=-dx,dx do
	-- 	for i=-dx,dx do
	-- 		if player_tile_x == self.target_model_x + i and 
	-- 		   player_tile_y == self.target_model_y + j then
	-- 			self.target_tile_x 	= player_tile_x
	-- 			self.target_tile_y 	= player_tile_y
	-- 			self.target_x = self.player.x;
	-- 			self.target_y = self.player.y;
	-- 			--print("不需要移动，目标已在攻击范围内",i,j)
	-- 			-- 不需要移动，所以直接停止动作
	-- 			self:end_action( )
	-- 			return true
	-- 		end
	-- 	end
	-- end

--	print("需要移动.....................................")
	--print("player_tile_x, player_tile_y,self.target_model_x,self.target_model_y"
	--,player_tile_x, player_tile_y,self.target_model_x,self.target_model_y);

	-- 然后计算哪个格子是最靠近主角的
	--local min_distance = 65530
	local min_distance = 999999
	for j=-dy,dy do
		for i=-dx,dx do
			local cal_tile_x = self.target_model_x + i
			local cal_tile_y = self.target_model_y + j
			--print("cal_tile_x,player_tile_x",cal_tile_x,player_tile_x)
			local distance 	= math.pow(cal_tile_x - player_tile_x, 2) + math.pow(cal_tile_y - player_tile_y, 2)
			--print("distance=",distance)
			if distance < min_distance then
				-- 判断格子是否合法
				if ( SceneManager:can_move(cal_tile_x,cal_tile_y) ) then
					self.target_tile_x	= cal_tile_x 
					self.target_tile_y 	= cal_tile_y 
					self.target_x, self.target_y = SceneManager:tile_to_pixels(cal_tile_x, cal_tile_y)
					min_distance  		= distance
				end
			end
		end
	end
	return false
end

function ActionApproachStatic:do_action(  )
	--print("ActionApproachStatic:do_action(  )",self.state);
	local current_tile_x = math.floor(self.player.x / SceneConfig.LOGIC_TILE_WIDTH);
	local current_tile_y = math.floor(self.player.y / SceneConfig.LOGIC_TILE_HEIGHT);
	-- print("ActionApproachStatic:do_action(  ):current_tile_x,self.target_tile_x",current_tile_x,self.target_tile_x)
	if current_tile_x == self.target_tile_x and current_tile_y == self.target_tile_y then
		--print("ActionApproachStatic:end_action 1");
		self:end_action()
	end

	return ActionMove.do_action(self)
end

-- 只有当AOI范围内存在实体才会靠近
function ActionApproachStatic:can_do(  )
	-- if EntityManager:get_entity(self.target_id) then
	-- 	return true
	-- end     
	-- return false
	return true;
end

-- function ActionApproachStatic:end_action(  )
-- 	--print("ActionApproachStatic:end_action 2");
-- 	ActionApproachStatic._on_end(self)
-- 	--print("ActionApproachStatic:end_action 3");
-- 	ActionMove.end_action(self)
-- 	--print("ActionApproachStatic:end_action 4");
-- end

-- 每一帧都靠近目标
-- function ActionApproachStatic:_on_start(  )
-- 	if self.need_send_to_server then
-- 		-- TODO:: 以后优化，如果站在同一个tile上面，就不用发移动cc了
-- 		local target_x = (self.target_tile_x + 0.5) * SceneConfig.LOGIC_TILE_WIDTH
-- 		local target_y = (self.target_tile_y + 0.5) * SceneConfig.LOGIC_TILE_HEIGHT
-- 		self.player.model:startMove(self.player.dir, self.player.x, self.player.y, target_x, target_y)
-- 		MoveCC:request_start_move(self.player.x, self.player.y, target_x, target_y)
-- 		self.need_send_to_server = false	-- 一个动作只发一次包
-- 	end
-- end

function ActionApproachStatic:_on_end(  )
	-- print("ActionApproachStatic:_on_end() 5")
	-- 到达目的地后删除特效
	LuaEffectManager:stop_map_effect( 21 )
	--MoveCC:request_stop_move(self.player.x, self.player.y, self.player.dir)

end

function ActionApproachStatic:_on_fail()
	-- print("ActionApproachStatic:_on_fail()")
	-- 到达目的地后删除特效
	LuaEffectManager:stop_map_effect( 21 )
	--MoveCC:request_stop_move(self.player.x, self.player.y, self.player.dir)

end