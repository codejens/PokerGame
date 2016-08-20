-- UIBackGroundWin.lua 
-- createed by fangjiehua on 2013-1-14
-- UI层最底层的空地窗口
require "UI/component/Window"
super_class.UIBackGroundWin(Window)

function UIBackGroundWin:__init( textureName )
	
	local function touch_event( eventType,args,msgid )
		if eventType == TOUCH_BEGAN then		
			-- ----print("you click background began");	
			return false
		elseif eventType == TOUCH_CLICK then		
			return false
		elseif eventType == TOUCH_ENDED then
			-- ----print("you click background ended");	
			require "UI/component/NotificationCenter"
			local obj = NotificationCenter:checkRegistDragObject();
			if obj ~= nil then
				NotificationCenter:click_backGround();
				return false;
			end
			return false
		end

	end
	self.view:registerScriptHandler(touch_event);
end

function UIBackGroundWin:create( textureName )
	
	return UIBackGroundWin("backGroundWin", textureName );

end



