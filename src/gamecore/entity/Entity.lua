-- Entity.lua
-- created by aXing on 2012-12-1
-- 游戏场景中实体基类
-- 它主要负责管理场景中的实体的位置信息，创建跟消亡等

Entity = simple_class()

function Entity:__init( handle )
	self.handle = handle 
	self.model = nil 
	self.type = nil

	self.root = ccsext.XEntityNode:create() --实体节点
	-- xprint("self.root=",self.root)
	self.model = self:init_model(  )  --实体模型
    self.root:addChild(self.model)

	local content_width = 80
	local content_height = 120
	self.root:setPosition(0,0)

	self.drawNode2 = cc.DrawNode:create()
	self.root:addChild(self.drawNode2)

	self.drawNode2:setPosition(-content_width/2, 0)
    local points = { cc.p(0,0), cc.p(0,content_height), cc.p(content_width,content_height),cc.p(content_width,0) }
    self.drawNode2:drawPolygon(points, table.getn(points), cc.c4f(1,0,0,0.2), 4, cc.c4f(0,0,1,0.2))
	self.drawNode2:setVisible(false)

	--点击事件测试代码 以后要换方式
	local function click_func( touch,event )
	    local position = touch:getLocation()
	    local x = position.x
	   	local y = position.y 
	   	local gl_position = cc.p(scene.XGameScene:sharedScene():screenToGLPosition(x,y))
	   	local mx,my = self.root:getPosition()
	   	local rect = cc.rect(mx-content_width/2,my,content_width,content_height)
	   	if cc.rectContainsPoint( rect, gl_position ) then
	   		print("选中了我。。。")
	   		
	   		local player = EntityManager:get_player_avatar()
	   		player:set_target_entity(self)
	   		return true
	   	end
	   	self.drawNode2:setVisible(false)
	end 
	self.root:setContentSize(content_width,content_height)
	-- cocosEventHelper.registerScriptHandler( self.root, click_func, cc.Handler.EVENT_TOUCH_BEGAN,true)
end

-- 初始化model   一般是在有数据之后才开始初始化。 而且不同entity初始化model会不一样。子类要重写。
function Entity:init_model(  )
	-- 子类重写
	 return ccsext.XAnimateSprite:create()
end

-- 实体析构
function Entity:destroy(  )
	self.root:removeFromParent(true)
end

-- 实体更改自己的属性
function Entity:change_entity_attri( attri_type, attri_value )
	local old_value 	= self[attri_type]
	self[attri_type]	= attri_value
	self:change_attr_event( attri_type, attri_value, old_value )
end

-- 属性改变需要做的处理。  例如某个属性改变，向通知中心发送一个通知
function Entity:change_attr_event( attri_type, attri_value, attr_value_old )
	-- ...  子类重写
	if attri_type == "x" then
		local x,y = self.root:getPosition()
		local p = SceneManager:map_pos_to_opgl_pos((attri_value/4)*3,y)
		print("x,y=",p.x,y)
		self.root:setPosition(p.x,y)

	elseif attri_type == "y" then
		local  x,y  = self.root:getPosition()
		local p = SceneManager:map_pos_to_opgl_pos(x,(attri_value/4)*3)
		x = 600
		p.y =p.y - 300
		print("x,y=",x,p.y)
		self.root:setPosition(x,p.y)
	elseif attri_type == "body" then
		self:load_body2(attri_value)
	end
end

--子类按需求写 加载模型
function Entity:load_body2( body_id )
	local json = EntityConfig:get_action_json( self.type )
	local body = EntityConfig:get_body_path( self.type, body_id )
	body = body .."001/001"--tostring(self.body)
	  --定义一个帧列表
    --  local _json = [[
    -- {
    --   "actions": {
    --       "255": {
    --           "restoreOriginalFrame" : false,
    --           "loop" : 4,
    --           "delay" : -1,
    --           "frames": [ [11,1.0,""],
    --                       [10,1.0,""],
    --                       [9,1.0,""],
    --                       [8,1.0,""],
    --                       [7,1.0,""],
    --                       [6,1.0,""],
    --                       [5,1.0,""],
    --                       [4,1.0,"12345"] ]
    --       }
    --   }
    -- }
    -- ]]
    -- sprite:initWithActionJson('animations/test',_json)
    -- print("body = ",body)
    -- print("json = ",json)
	self.model:initWithActionJson(body,json)
	self.model:playAction(0,true)
	-- self.model:playAction(1,true)
	-- self.model:playAction(2,true)
	-- self.model:playAction(3,true)
	-- self.model:playAction(4,true)
	-- self.model:playAction(5,true)
	self.model:setPosition(0,0)
end

--获取位置
function Entity:getPosition(  )
	return self.root:getPosition()
end

--获取地图坐标，显示是在opgl坐标
function Entity:get_map_position(  )
	local x,y = self.root:getPosition()
	local pos = SceneManager:opgl_pos_to_map_pos(x,y)
	return pos.x,pos.y
end

--获取titile位置
function Entity:get_title_pos(  )
	local x,y = self:get_map_position()
	return SceneManager:pixels_to_tile( x, y )
end

--测试被选中
function Entity:draw_selecte( select )
	self.drawNode2:setVisible(select)
end