--MainPanelChat.lua
--created by liubo on 2015-05-14
--主界面聊天模块
MainPanelChat = simple_class(GUIStudioView)

local _LAYOUT_FILE = "layout/studio/mainpanel/chat/stu_mainpanel_chat.lua"     -- 本页的布局文件


function MainPanelChat:__init( view )

end

--初始化页
function MainPanelChat:viewCreateCompleted() 
	self.view:setPosition(360,15)
end

-- 创建接口
function MainPanelChat:create(  )
	return self:createWithLayout( _LAYOUT_FILE )
end

-- 更新
-- @param update_type 更新类型
-- @param data 更新的数据 
function MainPanelChat:update( update_type, data )
	if update_type == "content" then 
        
    else

	end
end

--- 变成激活（显示）情况调用
function MainPanelChat:active(  )

end

-- 变成 非激活
function MainPanelChat:unActive(  )

end