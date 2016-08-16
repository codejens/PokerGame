-- SlotMove.lua
-- created by aXing on 2012-12-10
-- 继承自SlotBase
-- 实现格子的拖动事件注册
require "UI/component/SlotBase"
super_class.SlotMove(SlotBase)

function SlotMove:__init( width, height )

	self.enable_drag = true;
	self.if_not_through  = true        -- slot是否不可穿透
	self.drag_finish = false

	local function on_drag_event(eventType,arg,msgid,selfItem)
		
		if eventType == nil or arg == nil or msgid == nil or selfItem == nil then 
			return false;
		end

		if eventType == TOUCH_BEGAN then
			self.drag_finish = false
			return self.if_not_through

		elseif eventType == DRAG_BEGIN then
			--开始拖拽

			if self.obj_data ~= nil and self.enable_drag then
				----print("拖拽 DRAG_BEGIN");
				local temparg = Utils:Split(arg,":")
				local x = temparg[1]	--列数
				local y = temparg[2]	--行数

				NotificationCenter:registDragObject(self,tonumber(x),tonumber(y));
				
			end
			return true;

		elseif eventType == DRAG_OUT then				
			if self.on_drag_out ~= nil and self.enable_drag then
				----print("拖拽 DRAG_OUT");
			    self.on_drag_out(self);
		    end
			return self.if_not_through

		elseif eventType == TOUCH_ENDED then
			if self.on_drag_in ~= nil then
				local dragObj = NotificationCenter:checkRegistDragObject();
				if dragObj ~= nil and dragObj ~= self then
					----print("SlotMove drag in event!");
					NotificationCenter:click_slotItem(self.win);
					self.on_drag_in(dragObj);
					self.drag_finish = true
				end
			end
			return self.if_not_through;

		elseif eventType == TOUCH_MOVED then 			
			return self.if_not_through;

		elseif eventType == TOUCH_CLICK then
			if self.on_click_event ~= nil and self.drag_finish == false then
			    self.on_click_event(self,eventType, arg, msgid)

			    if ( self.select_effect_state ) then 
				    SlotEffectManager.play_effect_by_slot_item( self );
				end
		    end
		    
			return self.if_not_through

		elseif eventType == TOUCH_DOUBLE_CLICK then
			if self.on_double_click_event ~= nil  then
				self.on_double_click_event(self)
			end
			return self.if_not_through
			
		elseif eventType == ITEM_DELETE then           
            if self.on_delete_view_event ~= nil then
				self.on_delete_view_event(self)
			end
		end
	end
	
	self.view:registerScriptHandler(on_drag_event);

end

function SlotMove:set_drag_info( type,win,obj_data )
	self.type = type;
	self.win  = win;
	self.obj_data = obj_data;
end

--拖出事件
function SlotMove:set_drag_out_event( fn )
	self.on_drag_out = fn;
end
--有物件拖进来的事件
function SlotMove:set_drag_in_event( fn )
	self.on_drag_in = fn;
end
--拖出去的物件放到目标格子的事件
function SlotMove:set_drag_in_callback( fn )
	self.dragIn_callback = fn;
end
--拖出的物件放到非法区域的事件
function SlotMove:set_drag_invalid_callback( fn )
	self.dragInvalid_callback = fn;
end
--拖出的物件放到空地的事件
function SlotMove:set_discard_item_callback( fn )
	self.discard_item_callback = fn;
end

function SlotMove:set_enable_drag_out( bool )
	self.enable_drag = bool;
end

-- 设置slot是否可以穿透
function SlotMove:set_if_not_through( bool_value )
	self.if_not_through = bool_value
end

-- 拖拽开始事件
function SlotMove:set_begin_drag_event( fn )
	self.begin_drag_event = fn;
end