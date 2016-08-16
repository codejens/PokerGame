-- SlotPet.lua
-- created by hcl on 2013-1-15
-- 继承自SlotMove
-- 实现宠物的拖动事件注册

require "UI/component/SlotMove"
super_class.SlotPet(SlotMove)

function SlotPet:__init( width, height )
	self.enable_drag = true;
	self.if_not_through  = false        -- slot是否不可穿透
	-- local function on_drag_event(eventType,arg,msgid)
	-- 	if eventType == nil or arg == nil or msgid == nil then 
	-- 		return false;
	-- 	end
		
	-- 	if eventType == TOUCH_BEGAN then
			
	-- 		return false
	-- 	elseif eventType == DRAG_OUT then
	-- 		if self.enable_drag then
	-- 			require "utils/Utils"
	-- 			local temparg = Utils:Split(arg,":")
	-- 			local x = temparg[1]	--列数
	-- 			local y = temparg[2]	--行数
	-- 			if self.on_drag_out ~= nil and self.obj_data ~= nil then
	-- 				require "UI/component/NotificationCenter"
	-- 				NotificationCenter:registDragObject(self,tonumber(x),tonumber(y));
	-- 			    self.on_drag_out(self,eventType,arg,msgid);
	-- 		    end
	-- 		end
	-- 		return true

	-- 	elseif eventType == TOUCH_ENDED then
	-- 		----print("SlotMove TOUCH_ENDED");
	-- 		if self.on_drag_in ~= nil then
	-- 			require "UI/component/NotificationCenter"
	-- 			local dragObj = NotificationCenter:checkRegistDragObject();
	-- 			if dragObj ~= nil and dragObj ~= self then
	-- 				----print("SlotMove drag in event!");
	-- 				NotificationCenter:click_slotItem(self.win);
	-- 				self.on_drag_in(dragObj);

	-- 			end
	-- 		end
	-- 		return false;
	-- 	elseif eventType == TOUCH_MOVED then 			
	-- 		return true;
	-- 	elseif eventType == TOUCH_CLICK then
	-- 		if self.on_click_event ~= nil then
	-- 		    self.on_click_event(self)
	-- 	    end
	-- 		return false
	-- 	elseif eventType == TOUCH_DOUBLE_CLICK then
	-- 		if self.on_double_click_event ~= nil then
	-- 			self.on_double_click_event(self)
	-- 		end
	-- 		return true
	-- 	end
	-- end
	
	-- self.view:registerScriptHandler(on_drag_event);
end

