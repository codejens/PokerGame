-- DragItem.lua
-- created by fjh on 2013-1-6

super_class.DragItem(SlotBase)

function DragItem:__init( width, height )
	self._nextFrameChecker = callback:new()
	local function drag_move_event( eventType,arg,msgid )
		if eventType == nil or arg == nil or msgid == nil then
			return false;
		end
		-- ----print("DragItem drag_move_event eventType",eventType)
		if eventType == TOUCH_BEGAN then
			return true
		elseif eventType == TOUCH_MOVED then
 
			local temparg = Utils:Split(arg,":")
			local x = temparg[1]	--x坐标
			local y = temparg[2]	--y坐标
			self.view:setPosition(tonumber(x),tonumber(y));
			return true
		elseif eventType == TOUCH_ENDED then 
			----print("DragItem : TOUCH_ENDED");
		  	--下一帧检查,点击到哪了
		  	self._nextFrameChecker:start(0,
			  	function()
					--检查拖到哪去了
					NotificationCenter:check_hit_where();
					--销毁托管对象
					NotificationCenter:destoryDragObject();
			  	end)
			return false
		end
	end 
	if self.view == nil then
	end
	self.view:registerScriptHandler(drag_move_event);

end