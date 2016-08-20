-- ActionMove.lua
-- created by aXing on 2013-1-18
-- 主角移动行为类
-- 这个移动类包含的A*算法和直线修正算法
-- 它将派生出ActionAppoarch和ActionAppoarchStatic类

-- require "action/ActionBase"
-- require "action/ActionConfig"

-- 普通移动
--super_class.ActionMove(ActionBase)
ActionMove = simple_class(ActionBase)
-- added by aXing on 2013-5-11
-- 添加debug line，方便测试

local _have_init = false
local _line_root = nil
local _color	 = ccc3(255, 0, 0)
local _is_debug	 = CCAppConfig:sharedAppConfig():getBoolForKey("debug")

local function _init_line_node(  )

	local root = GameStateManager:get_game_root()
	_line_root = CCDebugLine:node()
	root:getSceneRoot():addChild(_line_root, 65535)
	_have_init = true
end

local function _draw_path( entity, path )

	if entity ~= EntityManager:get_player_avatar() then
		return
	end

	if _line_root == nil then
		_init_line_node()
	end
	
	local sx = entity.x
	local sy = entity.y
	local tx = path[1]
	local ty = path[2]

	for i=1,#path,2 do
		tx = path[i]
		ty = path[i + 1]
		local sp = CCPointMake(sx, sy)
		local tp = CCPointMake(tx, ty)
		ZXGameScene:sharedScene():mapPosToGLPos(sp)
		ZXGameScene:sharedScene():mapPosToGLPos(tp)
		_line_root:setLine(i, sp, tp, _color)
		sx = tx
		sy = ty
	end

	_line_root:draw()
end

----------------------------------------------

-- 普通移动将会存在3个参数
-- @tx 要到达的世界坐标的横坐标
-- @ty 要到达的世界坐标的纵坐标
-- @need_send_to_server 是否需要发送服务器协议
function ActionMove:__init( args )
	ActionBase.__init(self)
	self.class_name = "ActionMove";
	self.priority 	= ActionConfig.PRIORITY_ONE
	self.can_break	= true
	self.is_need_duration 	= false
	self.path_index	= 1
	self.path_num	= 0
	do_not_ride = false
	if args then
		self.need_send_to_server = args.need_send_to_server	
		-- 执行移动动作的实体
		if ( args.entity ) then
			self.player = args.entity;
		end

		-- 用A*算法计算路径，派生类Approach会修改计算路径节点的算法
		-- 迫于无奈，由于计算路点的算法必须等到目标点
		self:_calculate_path_node(args.tx, args.ty)
		do_not_ride = args.do_not_ride or false
	end

	if self.player then
		--是玩家，摇杆输入不要上马
		if ( self.player.type == -1 ) and not do_not_ride then
			self.player:onActionMove(self.target_x,self.target_y)
		end
	end
end

-- 用A*算法计算路径
function ActionMove:_calculate_path_node( tx, ty )
	-- 调用引擎的寻路算法，获取路点
--	xprint('ActionMove:_calculate_path_node', tx,ty)

	-- 如果目标坐标等于当前目标。。直接结束action
	-- print("tx,ty,self.player.model.m_x,self.player.model.m_y",tx,ty,self.player.model.m_x,self.player.model.m_y)
	-- if ( tx == self.player.model.m_x and ty == self.player.model.m_y ) then
	-- 	self:end_action();
	-- 	return;
	-- end

	--local pScene	= ZXGameScene:sharedScene():toPtr()
	if self.player.model == nil then
		return false
	end

	self.path		= SceneManager.sceneFindPath(self.player.model.m_x, self.player.model.m_y, 
											     tx, ty)
	self.path_index	= 1

	if self.path == nil then
		-- 寻路失败
		--print('寻路失败---------------------')
		--self.player:stop_all_action()
		self.state	= ActionConfig.ACTION_FAIL
		return false
	end

	-- added by aXing on 2013-5-11
	-- 添加debug line，方便测试
	if _is_debug then
		_draw_path(self.player, self.path)
	end

	self.path_num	= #self.path
--	print("self.path_num,",self.path_num)
	if self.path_num > 0 then
		self.target_x 	= self.path[self.path_index]
		self.target_y 	= self.path[self.path_index + 1]
		-- print(" ActionMove:_calculate_path_node( tx, ty ),self.target_x ",self.target_x,self.target_y)
		-- 改变动作朝向
		self:face_to(self.target_x, self.target_y)
	end
	return true
end

function ActionMove:do_action( recursive )
	--print("ActionMove................do_action")
	self.IdleOnStopMove = true
	if  self.target_x == nil and self.target_y == nil then
		self:stop_action()
		return ActionConfig.ACTION_END
	end

	if self.player.x >= self.target_x - 1 and self.player.x <= self.target_x + 1 and 
		self.player.y >= self.target_y - 1 and self.player.y <= self.target_y + 1 then

		self.path_index = self.path_index + 2

		if self.path_index > self.path_num then
			self:end_action()
		else
			self.target_x = self.path[self.path_index]
			self.target_y = self.path[self.path_index + 1]
		 	--print("下一个移动地点", self.player.x, self.player.y, self.target_x, self.target_y)
			self.need_send_to_server = true
			-- 改变动作朝向
			self:face_to(self.target_x, self.target_y)
			--self.player.model:setIdleOnStopMove(false)
			--还没去到最后一个点
			--判断StopMove是否自动重置Idle
			if self.path_index + 1 ~= self.path_num then
				self.IdleOnStopMove = false
			end
		end
	else
		--是否第一次进来，如果是，检查时候有下一个路径目标，如果有是否已经是最后一个点
		--判断StopMove是否自动重置Idle
		if not recursive then
			if self.path and self.path_index + 1 ~= self.path_num then
				self.IdleOnStopMove = false
			end
		end 
	end

	-- 当寻到下一个路径的时候，就需要再移动一次
	self:_on_start()

	return ActionBase.do_action( self , true)
end

function ActionMove:_on_start(  )
	-- print("self.need_send_to_server",self.need_send_to_server,self.player.model);
	if self.need_send_to_server and self.player.model ~= nil then
		-- print("ActionMove:_on_start(  )",self.target_x, self.target_y)
		self.player:startMove(self.target_x, self.target_y, self.IdleOnStopMove)
		--  判断是人物移动还是宠物移动  -1 主角 -2主角宠物 1仙女
		if ( self.player.type ==  -1 ) then
			MoveCC:request_start_move(self.player.x, self.player.y, self.target_x, self.target_y)
		elseif ( self.player.type == -2 or self.player.type == 1 ) then
			MoveCC:request_player_pet_start_move( self.player.handle, self.player.x, self.player.y, self.target_x, self.target_y )
		end
		
		--print("self.player.x, self.player.y, self.target_x, self.target_y",self.player.x, self.player.y, self.target_x, self.target_y)
		self.need_send_to_server = false	-- 一个动作只发一次包
	end

end

function ActionMove:_on_end(  )
	-- 由于每一帧都会修改路径，所以动作结束每一帧都会调用，所以这里不需要告诉服务器停止协议
	-- MoveCC:request_stop_move(self.player.x, self.player.y, self.player.dir)
	-- 到达目的地后删除特效
	LuaEffectManager:stop_map_effect( 21 )
	-- print(" ActionMove:_on_end(  )")
end

function ActionMove:_on_fail(  )
	-- on_fail 代表没有移动到目标地点，所以要取消玩家后面的动作
	self.player:clean_waiting_queue(  )
	--print("!!!!!!!!!!ActionMove:_on_fail")
	ActionBase._on_fail(self)
	-- 到达目的地后删除特效
	LuaEffectManager:stop_map_effect( 21 )
	
end