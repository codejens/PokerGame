--MainPanelTask.lua
--created by liubo on 2015-05-14
--主界面任务模块

MainPanelTask = simple_class(GUIStudioView)

local _LAYOUT_FILE = "layout/studio/mainpanel/task/stu_mainpanel_task.lua"     -- 本页的布局文件


function MainPanelTask:__init( view )

end

--初始化页
function MainPanelTask:viewCreateCompleted() 
	self.view:setPosition(0,290)
	self.task_list = self:findLayoutViewByName("LV_Task") --任务栏列表
end

-- 创建接口
function MainPanelTask:create(  )
	return self:createWithLayout( _LAYOUT_FILE )
end

--设置任务栏内容
function MainPanelTask:update_task_list(data)
    self.task_list:removeAllItems()
    local bg_img,title_label,content_label
    for i,v in ipairs(data) do
        print("i:",i,v.title,v.content)
        bg_img = GUIImg:create("res/ui/main/blank.png")
        title_label = GUIText:create()
        title_label:setString(v.title)
        title_label:setFontSize(20)
        title_label.view:setPosition(100, 30)
        content_label = GUIText:create()
        content_label:setString(v.content)
        content_label.view:setPosition(100, 5)
        content_label:setFontSize(18)
        bg_img.view:addChild(title_label.view)
        bg_img.view:addChild(content_label.view)

        local function touchfunc( sender,eventType )
            if eventType == ccui.TouchEventType.ended then
                task_cb_func(v)
            end
        end 
        bg_img:addTouchEventListener(touchfunc)
        self.task_list:insertCustomItem(bg_img.view,i-1)
    end
end

-- 更新
-- @param update_type 更新类型
-- @param data 更新的数据 
function MainPanelTask:update( update_type, data )
	if update_type == "list" then 
        self:update_task_list(data)
    else

	end
end

--- 变成激活（显示）情况调用
function MainPanelTask:active(  )

end

-- 变成 非激活
function MainPanelTask:unActive(  )

end