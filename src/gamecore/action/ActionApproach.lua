-- ActionApproach.lua
-- created by aXing on 2013-1-22
-- 主角靠近行为类

local TIMER_XL = 0.5;

-- 靠近某个目标地点
ActionApproach = simple_class(ActionApproachStatic)

-- 靠近的计算方式是：以目标逻辑格子为中心的直径格子数量的矩形范围
-- 靠近范围必须是单数
-- 动态靠近的目标必须是同屏存在的实体
-- @target_handle 同屏存在的实体handler
function ActionApproach:__init( args )

	self.target_handle	= args.target_handle

	local target = EntityManager:get_entity(self.target_handle)
	self.target_entity = target
	
	-- if ( args.entity ) then
	-- 	self.player = args.entity;
	-- end
	-- 先计算第一次符合距离的目标点，然后发第一次服务器包
	self:_start_find_path()

	-- 每1秒判断一次怪物是否移动，如果移动了就重新寻路	
	local function findPath_function()
		
		if ( self.target_entity  ) then

			local t_tile_x,t_tile_y = self.target_entity:get_title_pos()

			-- 如果目标没有移动就不用重新寻路
			if ( self.target_model_x == t_tile_x and  self.target_model_y == t_tile_y ) then
				return;
			else
				self.target_model_x,self.target_model_y = self.target_entity:get_title_pos()
				-- 重新寻路
				self.path_index = 1;
				self:_start_find_path()

				-- 每次重新寻路后都要重新通知服务器寻路
				self.need_send_to_server = true;
			end
		end
	end
	if ( self.target_entity ) then
		self.xl_timer = timer:create(  );
		self.xl_timer:start(TIMER_XL,findPath_function);
	end
end


-- 计算最近符合要求的坐标
function ActionApproach:_calculate_nearest_position(  )

	-- 首先要计算出目标在哪个格子
	if self.target_entity == nil then
		return true
	end

	self.target_model_x,self.target_model_y = self.target_entity:get_title_pos()

	return ActionApproachStatic._calculate_nearest_position(self)
end

-- 只有当AOI范围内存在实体才会靠近
function ActionApproach:can_do(  )
	if EntityManager:get_entity(self.target_handle) then
		return true
	end     
	return false
end

function ActionApproach:_on_end(  )

	if ( self.xl_timer ) then
		self.xl_timer:stop();
		self.xl_timer = nil;
	end
end

function ActionApproach:_on_fail()

	if ( self.xl_timer ) then
		self.xl_timer:stop();
		self.xl_timer = nil;
	end
end