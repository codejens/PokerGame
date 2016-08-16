--SnoticePage.lua
--公告页

super_class.banhaoPage(BaseEditWin)

function banhaoPage:__init()
	local txt_color = "#c643f17"
	self.label_tips1:setText(txt_color .. Lang.banhao[1])
	self.label_tips2:setText(txt_color .. Lang.banhao[2])
	self.label_tips3:setText(txt_color .. Lang.banhao[3])
	self.label_tips4:setText(txt_color .. Lang.banhao[4])
	self.label_tips5:setText(txt_color .. Lang.banhao[5])
	self.label_tips6:setText(txt_color .. Lang.banhao[6])
end

--获取UI控件
function banhaoPage:save_widget()
	self.label_tips1	= self:get_widget_by_name("label_tips1")
	self.label_tips2	= self:get_widget_by_name("label_tips2")
	self.label_tips3	= self:get_widget_by_name("label_tips3")
	self.label_tips4	= self:get_widget_by_name("label_tips4")
	self.label_tips5	= self:get_widget_by_name("label_tips5")
	self.label_tips6	= self:get_widget_by_name("label_tips6")

	self.closeBtn = self:get_widget_by_name("btn_1")
end

--监听事件
function banhaoPage:registered_envetn_func()
	--关闭按钮
	self.closeBtn:set_click_func(bind(self.close_call_back, self))

end

--销毁
function banhaoPage:destroy()
	if self.view ~= nil then
		self.view:removeFromParentAndCleanup(true)
		self.view = nil
		BaseEditWin.destroy(self)
	end
end

--关闭回调
function banhaoPage:close_call_back()
	self.view:setIsVisible(false)
	if GameStateManager:get_state() == "login" then
		if RoleModel:get_lasttime_page_name() == "new_select_server_page" then --证明已经登录进去了
			--已经登录进去的话就不用做什么了
			RoleModel:change_login_page("new_select_server_page")
		else
			if CCAppConfig:sharedAppConfig():getStringForKey("platformInterface") == Platform_Type.NOPLATFORM then
				RoleModel:change_login_page("login")
			else
				RoleModel:change_login_page("login_platform") --只要是有平台的,不管登录没都显示平台登录页面,就一个按钮的页面
			end
		end
	else
		UIManager:destroy_window("gonggao_win")
	end
end

--是否显示
function banhaoPage:isVisible(bool)
	self.view:setIsVisible(bool)
end
