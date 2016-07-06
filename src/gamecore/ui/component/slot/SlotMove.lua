-- SlotMove.lua
-- created by tjh on 2015-04-29
-- 继承自SlotBase
-- 实现格子的拖动事件注册
SlotMove = simple_class(SlotBase)

local _DRAG_READY_TIME =  0.2 -- 拖拽准备时间。 单位  秒

function SlotMove:__init(  )
	self._enable_drag = false        -- 是否支持拖拽
	self._move_pos    = cc.p(0,0)
	self._move_slot  = nil

    -- 只有拖拽情况下用这些
    self._one_event_begin  = false   -- 标记一次事件开始  
    self._drag_start       = false   -- 是否已经开始拖拽
	self._move_start       = false   -- 记录是否已经移动事件。
    self._drag_start_cb    = nil     -- 拖拽开始的回调函数
    self._drag_end_cb      = nil     -- 拖拽结束的回调函数
end

--- 创建完成，做些初始化工作
function SlotMove:viewCreateCompleted(  )
	SlotBase.viewCreateCompleted( self )   -- 创建完成后的初始化
end

---重写父类事件方法-------------
function SlotMove:begin_event( pos )
	if self._enable_drag then 
		self._one_event_begin = true
		self._move_start = false
        local drag_check_cb = callback:create(  )   -- 判断拖拽判断回调
		local function drag_check_func(  )
			if self._one_event_begin and not self._move_start then 
	            self:dragStart( pos )
			end
		end
		drag_check_cb:start( _DRAG_READY_TIME, drag_check_func )
	else
		SlotBase.begin_event( self, pos )
	end
end

function SlotMove:moved_event( pos )
	self._move_start = true
	self._move_pos = pos
	
	-- 如果已经拖拽起来，就移动拖拽的图标
	if self._drag_start then 
        self:drag_move( pos )
	end
end

function SlotMove:ended_event( pos )
    -- 如果进入拖拽状态，就不响应单击事件
    if not self._drag_start then 
        SlotBase.ended_event( self, pos )
    end
    self:remove_move_slot()
    self._move_start = false
    self._drag_start = false
    self._one_event_begin = false
end

function SlotMove:canceledevent(  )
	self:registEndDrag()
end
---------------------------------end

--- 设置 拖拽开始回调
function SlotMove:set_drag_start_cb( callback_func )
	self._drag_start_cb = callback_func
end

-- 设置拖拽结束回调
function SlotMove:set_drag_end_cb( callback_func )
	self._drag_end_cb = callback_func
end

--允许拖动
function SlotMove:set_drag_info( type,obj_data,win )
	self.type = type;
	self.win  = win;
	self.obj_data = obj_data;
	self._enable_drag = true
end

--注册拖动监听 记得删除时候要移除 types是一个需要监听的类型table 
function SlotMove:registDragEvent( types)
	self._enable_drag = true
	SlotDrugMode:registDragEvent( self,types )
end

--移除拖动监听
function SlotMove:removeDragEvent( types )
	SlotDrugMode:removeDragEvent( self,types )
end

-- 拖拽移动
function SlotMove:drag_move( move_pos )
	if self._move_slot then
		self._move_slot:setPosition( move_pos.x, move_pos.y)
	end
end

-- 拖动开始
function SlotMove:dragStart( move_pos )
	if self._enable_drag then
		if not self._move_slot then
			--创建移动icon
			self:create_move_icon()
		end
		self._drag_start = true
		self._move_slot:setPosition( move_pos.x, move_pos.y )

		-- 通知开始拖拽
		if self._drag_start_cb then 
		    self._drag_start_cb()
		end
	end
end

--注册结束拖动
function SlotMove:registEndDrag( )
	--通知拖动中心
	SlotDrugMode:endDrag( self._move_pos, "type", self )
	self:remove_move_slot()
	if self._drag_end_cb then 
	    self._drag_end_cb()
	end
end

function SlotMove:remove_move_slot(  )
	if self._move_slot then
	--移除
		self._move_slot:removeFromParent(true)
		self._move_slot = nil
		self._drag_start = false
	end
end

function SlotMove:create_move_icon(  )
	self._move_slot = SlotMove:create(  ) 
	self._move_slot:set_icon_texture( self._icon_texture )
	local ui_root = GUIManager:get_ui_root( )
	ui_root:addChild(self._move_slot.view,999)
end

--有物件拖进来的事件 返回一个slot信息参数 self.on_drag_in(slot)
function SlotMove:set_drag_in_event( fn )
	self.on_drag_in = fn;
end

--拖出的物件放到空地的事件 返回一个slot信息参数
function SlotMove:set_discard_item_callback( fn )
	self.discard_item_callback = fn;
end
