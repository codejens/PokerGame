-- ActionMove.lua
-- created by aXing on 2013-1-18
-- 主角移动行为类
-- 这个移动类包含的A*算法和直线修正算法
-- 它将派生出ActionAppoarch和ActionAppoarchStatic类

-- 普通移动

ActionMove = simple_class(ActionBase)
-- added by aXing on 2013-5-11
-- 添加debug line，方便测试

local _have_init = false
local _line_root = nil
local _color	 = cc.c3b(255, 0, 0)
local _is_debug	 = helpers.CCAppConfig:sharedAppConfig():getBoolForKey("debug")

--执行动作者的位置
local _player_x = 1
local _player_y = 1

local function _init_line_node(  )

	local root = scene.XLogicScene:sharedScene():getSceneNode()
	_line_root =  cc.DrawNode:create()
	root:addChild(_line_root)
	_have_init = true

end

local function _draw_path( entity, path )

	if entity ~= EntityManager:get_player_avatar() then
		return
	end

	if _line_root == nil then
		_init_line_node()
	end
	
	local sx,sy = entity:get_map_position()
	local tx = path[1]
	local ty = path[2]

	for i=1,#path,2 do
		tx = path[i]
		ty = path[i + 1]
    	_line_root:drawLine(SceneManager:map_pos_to_opgl_pos(sx,sy),
    		SceneManager:map_pos_to_opgl_pos(tx,ty),cc.c4f(1,1,1,1))
		sx = tx
		sy = ty
	end

end

----------------------------------------------

-- 普通移动将会存在3个参数
-- @tx 要到达的世界坐标的横坐标
-- @ty 要到达的世界坐标的纵坐标
-- @need_send_to_server 是否需要发送服务器协议 默认true
function ActionMove:__init( args )
	self.priority 	= ActionConfig.PRIORITY_ONE
	self.can_break	= true
	self.need_send_to_server =  args.need_send_to_server or true
	self.path_index	= 1
	self.path_num	= 0

	-- 执行移动动作的实体
	if ( args.entity ) then
		self.player = args.entity;
	end

	-- 用A*算法计算路径，派生类Approach会修改计算路径节点的算法
	-- 迫于无奈，由于计算路点的算法必须等到目标点
	print("begin---用A*算法计算路径，派生类Approach会修改计算路径节点的算法")
	self:_calculate_path_node(args.tx, args.ty)
	print("end---用A*算法计算路径，派生类Approach会修改计算路径节点的算法")

end

-- 用A*算法计算路径
function ActionMove:_calculate_path_node( tx, ty )

	local pScene	= scene.XGameScene:sharedScene()
	local x,y       = self.player:get_map_position()
	-- print("x, y=",x, y)
	self.path		= pScene:findPath(x, y, tx, ty)
	self.path_index	= 1
	if self.path == nil then
		-- 寻路失败
		self:stop_action()
		return 
	end

	-- added by aXing on 2013-5-11
	-- 添加debug line，方便测试
	_is_debug = true
	if _is_debug then
		-- _draw_path(self.player, self.path)
	end

	self.path_num	= #self.path
	if self.path_num > 0 then
		self.target_x 	= self.path[self.path_index]
		self.target_y 	= self.path[self.path_index + 1]

		-- 改变动作朝向
		--self.player:face_to(self.target_x, self.target_y)
	end
end

function ActionMove:do_action( recursive )

	if  self.target_x == nil and self.target_y == nil then
		self:stop_action()
		return
	end

	_player_x,_player_y = self.player:get_map_position()

	if _player_x >= self.target_x - 1 and _player_x <= self.target_x + 1 and 
		_player_y >= self.target_y - 1 and _player_y <= self.target_y + 1 then

		self.path_index = self.path_index + 2

		if self.path_index > self.path_num then
			self.need_send_to_server = false
			self:end_action()
		else
			self.target_x = self.path[self.path_index]
			self.target_y = self.path[self.path_index + 1]

			self.need_send_to_server = true
			-- 改变动作朝向
			--self.player:face_to(self.target_x, self.target_y)
			--还没去到最后一个点

		end
	else

	end

	-- 当寻到下一个路径的时候，就需要再移动一次
	self:_on_start()

	return ActionBase.do_action( self , true)
end


function ActionMove:_on_start(  )

	if self.need_send_to_server  then

        self.player:start_move(self.target_x,self.target_y)

		--  判断是人物移动还是宠物移动  -1 主角 -2主角宠物 1仙女
		local player_type = EntityConfig.ENTITY_TYPE[self.player.type]
		if  player_type ==  EntityConfig.PlayerAvatar  then
			local x,y = self.player:get_map_position()
			-- MoveSystemCC:req_start_move(x*4/3,y*4/3,self.target_x*4/3,self.target_y*4/3)
		-- elseif ( self.player.type == -2 or self.player.type == 1 ) then
		-- 	MoveCC:request_player_pet_start_move( self.player.handle, self.player.x, 
		-- 		self.player.y, self.target_x, self.target_y )
		end
		
		self.need_send_to_server = false	-- 一个动作只发一次包
	end

end

function ActionMove:_on_end(  )
	self.player:stopAction()
end

function ActionMove:_on_fail(  )
	-- on_fail 代表没有移动到目标地点，所以要取消玩家后面的动作
	self.player:clean_waiting_queue(  )

	ActionBase._on_fail(self)
end

