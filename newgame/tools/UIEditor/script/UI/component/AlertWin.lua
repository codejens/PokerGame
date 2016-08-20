-- AlertWin.lua
-- created by lyl on 2012-1-25
-- 提示窗口


super_class.AlertWin( Window )

local _if_close_anywhere = true

function AlertWin:__init( )
    self.if_close_anywhere = true
	self:register(  )
end

-- 注册方法
function AlertWin:register(  )
    local function f1(eventType,x,y)
        if eventType == TOUCH_BEGAN then
            if _if_close_anywhere then
                AlertWin:close_alert(  )
            end
            Instruction:handleUIComponentClick(instruct_comps.CLOSE_BTN)
            return true
        elseif eventType == TOUCH_CLICK then
            return false
        elseif eventType == TOUCH_ENDED then
            -- UIManager:hide_window( "alert_win" )
            -- AlertWin:close_alert(  )
            return false
        end
    end
    self.view:registerScriptHandler(f1)
end

-- 显示一个alert，直接静态调用. 参数：panel 要显示的内容panel。 
-- 注意：panel上点击，也会使面板小时。 如果需要不消失，传入面板的 TOUCH_ENDED 返回true
function AlertWin:show_new_alert( panel )
    -- 某些情况下，alert中的点击事件，打开另一个alert。这时候会打开后在关闭，导致不显示。所以每次show都在下一帧
    safe_retain(panel)   -- 下一帧会释放掉，
    local callback_temp = callback:new()
    local function callback_func ()
        AlertWin.child_panel = panel
        local win = UIManager:show_window( "alert_win" )
        if win and panel then
            win.view:removeAllChildrenWithCleanup(true)
            win:addChild( panel )
        end
        safe_release(panel)     -- 下一帧会加入，要减去前面手动加的引用
    end
    callback_temp:start( 0, callback_func )
end

-- 关闭显示
function AlertWin:close_alert(  )
    _if_close_anywhere = true
    require "UI/UIManager"
    local win = UIManager:find_visible_window( "alert_win" )
    if win and AlertWin.child_panel then
        win.view:removeChild( AlertWin.child_panel, true )
    end
    if win then 
        win.view:unregisterScriptHandler()
        UIManager:hide_window( "alert_win" )
    end  
end

-- 设置不会点击任何地方关闭
function AlertWin:if_close_click_anywhere( if_close )
    _if_close_anywhere = if_close
end

-- 激活后重新注册
function AlertWin:active( if_active )
    if if_active then
        self:register(  )
    end
end