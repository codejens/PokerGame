-- ActiTestPageOne.lua  
-- created by chj on 2015.2.11
-- 活动面板测试窗口类 

super_class.ActiTestPageOne()


-- 增加一个create 方法
function ActiTestPageOne:create( panel, x, y, width, height, image)
	local page_acti = ActiTestPageOne( x, y, width, height, image)
	if panel then
		panel:addChild( page_acti.view)
	end
	return page_acti
end

-- 初始化
function ActiTestPageOne:__init( x, y, width, height, image)
	if image then
		self.view = CCBasePanel:panelWithFile( x,  y, width, height, image, 500, 500)
	else
		self.view = CCBasePanel:panelWithFile( x,  y, width, height, image)
	end
end

-- ==================================================
-- 更新分界线---------------------------------------
-- ==================================================

-- 显示(打开窗口触发)
function ActiTestPageOne:active( show )
end

-- 更新
function ActiTestPageOne:update( activity_id )
	
end

-- ==================================================
-- 销毁分界线---------------------------------------
-- ==================================================
-- 销毁
function ActiTestPageOne:destroy( )
    Window.destroy(self)
end