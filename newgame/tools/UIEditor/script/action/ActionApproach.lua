-- ActionApproach.lua
-- created by aXing on 2013-1-22
-- 主角靠近行为类

-- require "action/ActionApproachStatic"
-- require "action/ActionConfig"
-- require "config/SceneConfig"

local TIMER_XL = 0.5;

-- 靠近某个目标地点
--super_class.ActionApproach(ActionApproachStatic)
ActionApproach = simple_class(ActionApproachStatic)

-- 靠近的计算方式是：以目标逻辑格子为中心的直径格子数量的矩形范围
-- 靠近范围必须是单数
-- 动态靠近的目标必须是同屏存在的实体
-- @target_id 同屏存在的实体handler
-- @distance 靠近范围，以目标中心做矩形范围，参数为矩形边长
function ActionApproach:__init( args )
	ActionApproachStatic.__init(self,args)
	self.class_name = "ActionApproach";
	-- print("------------------------------ActionApproach:__init")
	self.target_id	= args.target_id
	--self.distance 	= args.distance
	self.target_entity = args.target_entity;
	
	if ( args.entity ) then
		self.player = args.entity;
	end
	-- 先计算第一次符合距离的目标点，然后发第一次服务器包
	local ret = self:_calculate_nearest_position()
	if not ret then
		self:_calculate_path_node(self.target_x, self.target_y)
	end

	-- 每1秒判断一次怪物是否移动，如果移动了就重新寻路	
	local function xl_function()
		-- 如果目标没有移动就不用重新寻路
		if ( self.target_entity and self.target_entity.model ) then
			local t_tile_x = math.floor( self.target_entity.model.m_x/SceneConfig.LOGIC_TILE_WIDTH );
			local t_tile_y = math.floor( self.target_entity.model.m_y/SceneConfig.LOGIC_TILE_HEIGHT );
			-- print("self.target_model_x,self.target_entity.model.m_x",self.target_model_x,self.target_entity.model.m_x,t_tile_x,t_tile_y);
			if ( self.target_model_x == t_tile_x and  self.target_model_y == t_tile_y ) then
				return;
			else
				
				self.target_model_x =  math.floor(self.target_entity.model.m_x/SceneConfig.LOGIC_TILE_WIDTH );
				self.target_model_y =  math.floor(self.target_entity.model.m_y/SceneConfig.LOGIC_TILE_HEIGHT );
				-- print("重新寻路......",self.target_model_x,self.target_model_y);
				-- 重新寻路
				self:_start_xl();
				-- 每次重新寻路后都要重新通知服务器寻路
				self.need_send_to_server = true;
			end
		end
	end
	if ( self.target_entity ) then
		self.xl_timer = timer(  );
		self.xl_timer:start(TIMER_XL,xl_function);
	end
	--[[
	if self.player and args.tile_x and args.tile_y then
		if ( self.player.type == -1 ) then
			self.player:onActionMove(self.target_model_x,self.target_model_y)
		end
	end
	]]--
end

function ActionApproach:_start_xl()
	self.path_index = 1;
	-- 先计算第一次符合距离的目标点，然后发第一次服务器包

	local ret = self:_calculate_nearest_position()
	if not ret then
		self:_calculate_path_node(self.target_x, self.target_y)
	end

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
function ActionApproach:_calculate_nearest_position(  )
	--print("ActionApproach:_calculate_nearest_position(  )")
	-- 首先要计算出目标在哪个格子
	local target = EntityManager:get_entity(self.target_id)
	if target == nil then
		-- 如果不存在目标，则结束动作
		return true
	end

	self.target_model_x = math.floor(target.model.m_x / SceneConfig.LOGIC_TILE_WIDTH)
	self.target_model_y	= math.floor(target.model.m_y / SceneConfig.LOGIC_TILE_HEIGHT)

	return ActionApproachStatic._calculate_nearest_position(self)
end

-- function ActionApproach:do_action(  )

-- 	local current_tile_x = math.floor(self.player.x / SceneConfig.LOGIC_TILE_WIDTH)
-- 	local current_tile_y = math.floor(self.player.y / SceneConfig.LOGIC_TILE_HEIGHT)
	
-- 	if current_tile_x == self.target_tile_x and current_tile_y == self.target_tile_y then
-- 		-- 当到达预定区域，再次判断是否够距离了，重新计算一次
-- 		-- if self:_calculate_nearest_position() then
-- 			self:end_action()
-- 		-- end
-- 	end

-- 	return ActionBase.do_action(self)
-- end

-- 只有当AOI范围内存在实体才会靠近
function ActionApproach:can_do(  )
	if EntityManager:get_entity(self.target_id) then
		return true
	end     
	return false
end

-- function ActionApproach:_on_end(  )
-- 	--print("ActionApproach:_on_end(  )")
-- 	-- MoveCC:request_stop_move(self.player.x, self.player.y, self.player.dir)
-- end

function ActionApproach:_on_end(  )
	-- print("ActionApproach:_on_end(  )")
	-- 到达目的地后删除特效
	LuaEffectManager:stop_map_effect( 21 )
	--MoveCC:request_stop_move(self.player.x, self.player.y, self.player.dir)

	if ( self.xl_timer ) then
		self.xl_timer:stop();
		self.xl_timer = nil;
		-- print("timer停止")
	end
end

function ActionApproach:_on_fail()
	-- print("ActionApproach:_on_fail()")
	-- 到达目的地后删除特效
	LuaEffectManager:stop_map_effect( 21 )
	--MoveCC:request_stop_move(self.player.x, self.player.y, self.player.dir)

	if ( self.xl_timer ) then
		self.xl_timer:stop();
		self.xl_timer = nil;
		-- print("timer停止")
	end
end