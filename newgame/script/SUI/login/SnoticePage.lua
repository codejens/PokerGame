--SnoticePage.lua
--公告页

super_class.noticePage(BaseEditWin)

function noticePage:__init()
	self.left_notice_item = {}
	--选择的滚动条数
	self.select_num       = 0
	--旧选择的滚动条
	self.select_old       = nil
	--选择的滚动条index
	self.index            = 0
	self.content_str      = ""
	--数据
	self.date             = nil

	if g_notice_date then
		self:create_scroll(g_notice_date)
	end
end

--获取UI控件
function noticePage:save_widget()
	--左侧滚动条的父节点
	self.panel_bg   = self:get_widget_by_name("panel_1")
	--内容的背景
	self.content_bg = self:get_widget_by_name("content_bg")
	--公告内容
	self.content = STextArea:create(438, 250)
	self.content:setPosition(50,310)
	self.content_bg:addChild(self.content)
	self.close    = self:get_widget_by_name("closeItem")
	self.close:setIsVisible(false)
	self.closeBtn = self:get_widget_by_name("btn_1")
end

--监听事件
function noticePage:registered_envetn_func()
	--关闭按钮
	self.closeBtn:set_click_func(bind(self.close_call_back, self))

	--创建滚动控件
	self.left_scroll = SScroll:create(203, 355, "")
	self.left_scroll.view:setPosition(CCPointMake(1, 2))
	self.left_scroll:set_touch_func(SCROLL_CREATE_ITEM, bind(self.scroll_create, self))
	self.panel_bg:addChild(self.left_scroll)

	self.right_scroll = SScroll:create(513, 300, "")
	self.right_scroll.view:setPosition(CCPointMake(15, 30))
	self.right_scroll:set_touch_func(SCROLL_CREATE_ITEM, bind(self.create_notice_scroll, self))
	self.content_bg:addChild(self.right_scroll)
	self.right_scroll.view:setScrollLump("sui/common/huadongtiao.png", "sui/common/huadongtiaodi.png", 4, 1, 0)

	-- self:init_content()
end

--创建滚动列
function noticePage:create_scroll(date)
	self.date = date
	if self.left_scroll then
		self.left_scroll:update(#date)
	end
	self:show_info(0)
end

--销毁
function noticePage:destroy()
	if self.view ~= nil then
		self.view:removeFromParentAndCleanup(true)
		self.view = nil
		BaseEditWin.destroy(self)
	end
end

--关闭回调
function noticePage:close_call_back()
	self.view:setIsVisible(false)
	if GameStateManager:get_state() == "login" then
		if RoleModel:get_lasttime_page_name() == "new_select_server_page" then --证明已经登录进去了
			--已经登录进去的话就不用做什么了
			RoleModel:change_login_page("new_select_server_page")
		else
			if Target_Platform == Platform_Type.NOPLATFORM then
				RoleModel:change_login_page("login")
				-- RoleModel:log()
			else
				RoleModel:change_login_page("login_platform")
				-- PlatformInterface:onEnterLoginState() --这个是登录
			end
		end
	else
		UIManager:destroy_window("gonggao_win")
	end
end

--创建滚动条回调
function noticePage:scroll_create(index)
	local panel = SPanel:create("sui/login/bg1.png", 203, 74, true)

	local title_color = S_COLOR[5]
	if self.select_num == tonumber(index) then
		panel:setTexture("sui/login/bg2.png")
		self.select_old = panel
	end

	local info = self.date[index+1]

	--标题名
	local title_name = SLabel:create(title_color..info.title, 22)
	title_name:setAnchorPoint(0.5, 0.5)
	title_name.view:setPosition(panel:getSize().width/2, panel:getSize().height/2)
	panel:addChild(title_name)

	--是否新公告标识
	if info.is_new == "1" then
		local item = SImage:create("sui/login/NEWLab.png")
		item:setAnchorPoint(1, 0)
		item.view:setPosition(panel:getSize().width-5, 5)
		panel:addChild(item, 2)
	end

	local path = "sui/login/biaoqian"..info.type..".png"
	if tonumber(info.type) > 0 and tonumber(info.type)< 4  then
		local icon = SImage:create(path)
		icon:setAnchorPoint(0, 1)
		icon.view:setPosition(0, panel:getSize().height)
		panel:addChild(icon, 2)
	end

	panel:set_touch_func(TOUCH_ENDED, bind(self.scroll_panel_call_back, self, index, panel))
	panel:set_touch_func(ITEM_DELETE, bind(self.scroll_delete, self, index))

	return panel
end

--添加默认颜色
local function new_str(str)
	local str_data = Utils:Split(str, "#r")
	local new_strs = ''
	for k, v in ipairs(str_data) do
		new_strs = new_strs .. "#r#c643f17" .. v
	end
	return new_strs
end

--创建右边内容滚动条
function noticePage:create_notice_scroll(index)
	-- 公告内容
	self.content = STextArea:create(504, 18)
	self.content:setFontSize(18)
	self.content:setLineEmptySpace(10)
	-- 设置内容
	self.content:setText(new_str(self.content_str))
	local size = self.content.view:getSize()

	local panel = SPanel:create("", 508, size.height-10, true)
	self.content:setPosition(0, size.height)

	panel:addChild(self.content)

	return panel
end

--滚动条点击回调
function noticePage:scroll_panel_call_back(index, target)
	SoundManager:play_ui_effect(4, false)
	self.select_num = tonumber(index)
	if self.select_old then
		self.select_old:setTexture("sui/login/bg1.png")
	end
	target:setTexture("sui/login/bg2.png")
	self.select_old = target

	self:show_info(self.select_num)
end

--删除滚动条回调
function noticePage:scroll_delete(index)
	if self.select_num == tonumber(index) then
		self.select_old = nil
	end
end

--是否显示
function noticePage:isVisible(bool)
	self.view:setIsVisible(bool)
end

--显示界面信息
function noticePage:show_info(index)
	local info = self.date[index+1]
	self.content_str = info.content
	self.right_scroll:clear()
	self.right_scroll:setMaxNum(1)
	self.right_scroll:refresh()
end
