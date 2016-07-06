-----------------------------------------------------------------------------
-- SlotBase.lua
-- 基础slot只用于显示图片和右下角的数量label
-- 实现点击事件和双击事件的注册
-- @author lyl on 2015-5-6
-----------------------------------------------------------------------------

--!class SlotBase
SlotBase = simple_class(GUITouchBase)



SlotBase.DEFAULT_WIDTH  = 72    -- 默认宽度
SlotBase.DEFAULT_HEIGHT = 72   -- 默认高度

local _ICON_COVER_LAYER_NUM  = 11     -- icon 层级
local _COLOR_COVER_LAYER_NUM = 999   -- 色板遮挡的层级

function SlotBase:__init( view )
    self._icon = nil            -- 道具icon 图
    self._color_cover = nil     -- 色板遮挡 层级为 999（ 要在最上层）
    self._tag 	= 0;           -- 标记
    self._icon_texture = nil    -- 记录icon的texture
end

--- 创建完成，做些初始化工作
function SlotBase:viewCreateCompleted(  )
	-- 设置大小。 所有slot用默认大小。 要设置大小则进行缩放， 让子视图也随着缩放
	self:setContentSize( SlotBase.DEFAULT_WIDTH, SlotBase.DEFAULT_HEIGHT )    
	
	-- icon      
    self._icon = GUIImg:create()       
    self:addChild( self._icon, _ICON_COVER_LAYER_NUM )
    self._icon:setPosition( SlotBase.DEFAULT_WIDTH / 2, SlotBase.DEFAULT_HEIGHT / 2 )

    self:register_listener()
end

--- 创建格子
function SlotBase:create(  )
	local slot = self( ccui.Widget:create() )
	if slot then 
		slot:viewCreateCompleted()
        return slot
    else
    	return nil
	end
end

-- 把格子置空
function SlotBase:set_empty(  )
	self._icon:loadTexture( "" )
	self._icon:setVisible( false )
end

-- 注册事件监听
function SlotBase:register_listener()
	-- 注册点击事件
	local function on_click_event( sender,eventType )
	  if eventType == ccui.TouchEventType.began then
	  		local pos = sender:getTouchBeganPosition()
	  		self:begin_event( pos )
	  elseif eventType == ccui.TouchEventType.ended then
	  		local pos = sender:getTouchEndPosition()
	  		self:ended_event( pos )
	  elseif eventType == ccui.TouchEventType.moved then
	  		local move_pos = sender:getTouchMovePosition()
	  		self:moved_event( move_pos )
	  elseif eventType == ccui.TouchEventType.canceled then
	  		self:canceledevent()
	  end

	end
	self:addTouchEventListener(on_click_event)
end

--------事件处理 子类按需求重写
function SlotBase:begin_event( pos )
	if self.on_begin_event ~= nil then
		self.on_begin_event(self )
	end
end

function SlotBase:moved_event( pos )

end

function SlotBase:ended_event( pos )
	if self.on_click_event ~= nil then
	    self.on_click_event(self )
    end
end

function SlotBase:canceledevent(  )
	-- body
end
----------------------------end

--设置单击回调函数
function SlotBase:set_click_event( fn )
	self.on_click_event = fn
end

--设置单击回调函数
function SlotBase:set_begin_event( fn )
	self.on_begin_event = fn
end





-- 设置格子的图标
function SlotBase:set_icon_texture( icon_texture )
	icon_texture = icon_texture or ""
	self._icon:loadTexture(icon_texture)
	self._icon_texture = icon_texture
end

function SlotBase:set_tag( tag)
	self._tag = tag;
end
function SlotBase:get_tag(  )
	return self._tag;
end

-- 缩放到目标大小
-- @param w 目标宽度
-- @param h 目标高度
function SlotBase:scale_to_size( w, h )
	local scale_w = w / SlotBase.DEFAULT_WIDTH
	local scale_h = h / SlotBase.DEFAULT_HEIGHT
	self:setScale( scale_w, scale_h )
end


-- 设置无效
function SlotBase:set_slot_disable(  )
	-- lp todo
end

-- 设置生效
function SlotBase:set_slot_enable(  )
	-- lp todo
end

-- 设置icon 变暗色
function SlotBase:set_icon_dead_color(  )
	-- lp todo
end

-- 设置icon变成亮色
function SlotBase:set_icon_light_color(  )
	-- lp todo
end

-- -- 设置覆盖的色板
-- function SlotBase:show_cover_color( rbga_value )
-- 	local rbga = rbga_value or 0xffffff00
-- 	if self.color_cover == nil then
--          self.color_cover = CCArcRect:arcRectWithColor( 0, 0, self.width, self.height, 0xffffff00  )
--          self.view:addChild( self.color_cover, 999 )
-- 	end
-- 	-- self.color_cover:setIsVisible( true )
-- 	self.color_cover:setColor( rbga )
-- 	self.color_cover:setDefaultMessageReturn( true )
-- end

-- -- 隐藏覆盖的色板
-- function SlotBase:hide_cover_color(  )
-- 	if self.color_cover then
-- 		-- self.color_cover:setIsVisible( false )
-- 		self.color_cover:setColor( 0xffffff00 )
--         self.color_cover:setDefaultMessageReturn( false )
-- 	end
-- end