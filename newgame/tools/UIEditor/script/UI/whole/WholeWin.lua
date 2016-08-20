-- WholeWin.lua
-- created by lyl on 2012-6-18
-- 管理 显示在整个UI上层的内容 例如帧率  whole_win

super_class.WholeWin(Window)

function WholeWin:__init( window_name, texture_name )
    -- 网络延时显示
    -- local test_temp = UpdateManager.NOPlatform_server_url
    -- print("==============================================================")
    -- print(test_temp)
    -- print("==============================================================")
    self.net_delay_lable = UILabel:create_lable_2( "100ms", 10, 10, 16, ALIGN_LEFT )
    self.view:addChild( self.net_delay_lable, 1000 )

    self.view:setDefaultMessageReturn(false)          -- 设置穿透，不影响其他ui的事件消息

    WholeModel:begin_check_daley(  )    -- 开始
end


-- 更新网络延时
function WholeWin:update_delay(  )
    local net_delay = WholeModel:get_net_delay(  )
    local net_delay_str = LangGameString[2134]..tostring( net_delay ).."ms" -- [2134]="网络延时:"
    self.net_delay_lable:setString( net_delay_str )
end

-- 网络延时的显示
function WholeWin:if_show_net_delay( if_show )
    if if_show then 
        self.net_delay_lable:setIsVisible( true )
    else
    	self.net_delay_lable:setIsVisible( false )
    end
end

-- 更新函数  外部静态调用
function WholeWin:update_win( update_type )
    local win = UIManager:find_visible_window( "whole_win" )
    if win ~= nil then
        win:update( update_type )
    end
end

-- 更新
function WholeWin:update( update_type )
    if update_type == "delay" then 
        self:update_delay(  )
    elseif update_type == "open_delay" then
        self:if_show_net_delay( true )
    elseif update_type == "close_delay" then 
    	self:if_show_net_delay( false )
    end
end

function WholeWin:destroy()
    Window.destroy(self)
end

function WholeWin:active( if_show )
	-- print("!!!!!@@@@@@@@@@@@@@@@@@@!!!!#############", if_show)
    if if_show then 
        -- print("开始显示")
        WholeModel:begin_check_daley(  )
    end
end
