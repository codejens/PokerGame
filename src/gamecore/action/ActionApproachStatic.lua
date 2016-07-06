-- ActionApproachStatic.lua
-- created by aXing on 2013-1-22
-- 主角靠近行为类

-- 靠近某个目标地点

ActionApproachStatic = simple_class(ActionMove)


-- 靠近的计算方式是：判断当前是否有指定的entity
-- 靠近范围必须是单数
-- 同屏靠近将会存在三个参数
-- @tile_x 要靠近的逻辑格子横坐标
-- @tile_y 要靠近的逻辑格子纵坐标
-- @distance 靠近范围，以目标中心做矩形范围，参数为矩形边长
function ActionApproachStatic:__init( args )

	self.target_model_x	= args.tile_x or 0;
	self.target_model_y	= args.tile_y or 0;
	self.distance 		= args.distance
	self.need_send_to_server = true

	-- 开始寻路
	self:_start_find_path();
end

function ActionApproachStatic:_start_find_path()

	self.path_index = 1;
	-- 先计算第一次符合距离的目标点，然后发第一次服务器包
	local ret = self:_calculate_nearest_position()
	if not ret then
		self:_calculate_path_node(self.target_x, self.target_y)
	end

end

-- 计算最近符合要求的坐标
-- 如果已经符合靠近要求，则返回true
function ActionApproachStatic:_calculate_nearest_position(  )


	local player_tile_x, player_tile_y = self.player:get_title_pos()
	local player_x,player_y = self.player:get_map_position()
	-- 优先判断，如果在最佳范围，则可以直接跳出
	local dx = (self.distance - 1) / 2 			-- 靠近范围必须是单数

	-- 然后计算哪个格子是最靠近主角的
	local min_distance = 999999
	for j=-dx,dx do
		for i=-dx,dx do

			local cal_tile_x = self.target_model_x + i
			local cal_tile_y = self.target_model_y + j

			local distance 	= math.pow(cal_tile_x - player_tile_x, 2) + math.pow(cal_tile_y - player_tile_y, 2)
			--如果已经在攻击范围内 自己返回
			if distance == 0 then
				self.target_tile_x 	= player_tile_x
				self.target_tile_y 	= player_tile_y
				self.target_x = player_x
				self.target_y = player_y
				-- 不需要移动，所以直接停止动作
				self:end_action( )
				return true
			end

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

	local player_tile_x, player_tile_y = self.player:get_title_pos()
	
	if player_tile_x == self.target_tile_x and player_tile_y == self.target_tile_y then

		self:end_action()
	end

	return ActionMove.do_action(self)
end

-- 只有当AOI范围内存在实体才会靠近
function ActionApproachStatic:can_do(  )

	return true;
end
