-----------------------------------------------------------------------------
-- @author create by lyl 2015.5/11
-- GUIStudioView.lua
-- 使用studio导出的文件创建的view
-----------------------------------------------------------------------------

--!class GUIStudioView
GUIStudioView = simple_class(GUIPanel)

--- 构造函数
-- @param view cpp控件对象
-- @see members
function GUIStudioView:__init( view )
	self.studio_layout = nil         -- 保存布局table，用来获取子控件
end

--- 加载完成 加载完后调用，子类可以重写，做加完完成后的初始化。
-- function GUIStudioView:viewDidLoad(  )
	
-- end

-- 创建完成
function GUIStudioView:viewCreateCompleted()
    
end

--- 使用studio导出的lua文件
-- @param layout_file studio导出来的lua布局文件
-- @see members
function GUIStudioView:createWithLayout( layout_file )
	local layout = cocosUIHelper.creatUI_lua( layout_file )
	local view = layout[ "root" ]
	local gui_view = self( view )
	if gui_view then
		gui_view.studio_layout = layout
		-- gui_view:viewDidLoad(  )
		gui_view:viewCreateCompleted()
		return gui_view
	else
		return nil
	end
end

-- 使用名字获取子视图
-- @param name  视图名字
function GUIStudioView:findLayoutViewByName( name )
	return self.studio_layout[ name ]
end

-- 注册事件监听。 注意，只有widget才能注册监听
-- @param name  视图名字
-- @param func  回调函数
function GUIStudioView:widgetTouchEventListener( name, func )
	local comp = cocosHelper.findWidgetByName(self.view,name)
	if comp then 
        comp:setTouchEnabled(true)
	    comp:addTouchEventListener(func)
	end
end