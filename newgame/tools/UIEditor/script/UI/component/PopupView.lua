-- PopupView.lua
-- created by hcl on 2013/2/1
-- 点击控件外任何地方会消失的view

super_class.PopupView()

PopupView.TAG = 99999

function PopupView:__init()

  ------print('PopupView:__init',close_windows_name)
  local w = GameScreenConfig.ui_screen_width
  local h = GameScreenConfig.ui_screen_height

	self.view = CCBasePanel:panelWithFile(0,0,w,h,nil,0,0);
  safe_retain(self.view)

    local function panel_fun(eventType,x,y)
        if eventType == TOUCH_BEGAN then            
            return false;
        elseif eventType == TOUCH_ENDED then
            self:close()
           	return false;
        end
    end
  self.view:registerScriptHandler(panel_fun);
  self.view:setDefaultMessageReturn(true);
end

function PopupView:setClosingWindow(parent,close_windows_name, z)
  self.close_windows_name = close_windows_name
  self.view:removeFromParentAndCleanup(true)
  parent:addChild(self.view, z-1);
end

function PopupView:onWindowHide( name )
  if name == self.close_windows_name then
    self:close()
  end
end

function PopupView:close()
  if self.view:getParent() then
    self.view:removeFromParentAndCleanup(true)
  end
  if self.close_windows_name then
    UIManager:destroy_window(self.close_windows_name)
  end
  self.close_windows_name = nil
end

function PopupView:destroy()
  if self.view:getParent() then
    self.view:removeFromParentAndCleanup(true)
  end
  safe_release(self.view)
end