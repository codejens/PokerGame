-- ActiTestWin.lua  
-- created by chj on 2015.2.11
-- 活动面板测试窗口类 

-- 分页
require "UI/activity/template/ActiTestPageOne"

super_class.ActiTestWin(ActiTemplateWin)

-- 初始化
function ActiTestWin:__init(  )

	-- 大活动包含的分页类
	local page_class_group = {
		[1] = ActiTestPageOne,
		[2] = ActiTestPageOne,
		[3] = ActiTestPageOne,
		[4] = ActiTestPageOne,
		[5] = ActiTestPageOne,
		[6] = ActiTestPageOne,
		[7] = ActiTestPageOne,
	}
	-- local page_class_group = {
	-- 	{x=1},
	-- 	{x=1},
	-- 	{x=1},
	-- 	{x=1},
	-- 	{x=1},
	-- 	{x=1},
	-- }

	ActiTemplateModel:set_page_group( page_class_group)

end

-- ==================================================
-- 更新分界线---------------------------------------
-- ==================================================

-- 显示(打开窗口触发)
function ActiTestWin:active( show )
	-- self.super:active( show )
	-- 应该调用父表的active 方法，暂时这样写
	self:select_page(1, self.panel_right)
end

-- 更新
function ActiTestWin:update( activity_id )
	
end

-- ==================================================
-- 销毁分界线---------------------------------------
-- ==================================================
-- 销毁
function ActiTestWin:destroy( )
    Window.destroy(self)
end