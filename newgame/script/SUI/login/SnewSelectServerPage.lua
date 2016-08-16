-- newSelectServerPage.lua
-- 登录界面（选服）

super_class.newSelectServerPage(BaseEditWin)

local _refWidth = UIScreenPos.relativeWidth
local _refHeight = UIScreenPos.relativeHeight
local panelWidth = _refWidth(1.0)
local panelHeight = _refHeight(1.0)
local _target_server_data = nil

-----------------------初始化-----------------------

-- 构造
function newSelectServerPage:__init()

end

-- 获取UI控件
function newSelectServerPage:save_widget()
	--定义好需要用到的控件
	self.root = self:get_widget_by_name("root")

	-- 显示服务器名称的背景
	self.enter_bg = self:get_widget_by_name("img_1")

	-- 显示服务器索引
	self.server_index = self:get_widget_by_name("label_1")

	-- 服务器输入框
	self.serverFrame = self:get_widget_by_name("panel_1")
	self.serverFrame.view:setPositionX(panelWidth / 2 - self.serverFrame.view:getContentSize().width / 2)

	-- 登录游戏按钮
	self.login = self:get_widget_by_name("btn_1")
	self.login.view:setPositionX(panelWidth / 2 - self.login.view:getContentSize().width / 2)

	-- 注销按钮
	self.cancellation = self:get_widget_by_name("xf_zx")
	local size1 = self.cancellation.view:getContentSize()
	self.cancellation.view:setPosition(panelWidth - size1.width - 25, panelHeight - size1.height - 29)

	-- 选服页面的公告按钮
	self.notice = self:get_widget_by_name("xf_gg")
	self.notice.view:setPosition(panelWidth - size1.width - 25, panelHeight - size1.height*2 - 29)

	-- 选服页面的版号按钮
	self.banhao = self:get_widget_by_name("xf_bh")
	-- self.banhao.view:setPosition(panelWidth - size1.width - 25, panelHeight - size1.height*3 - 29)
	self.banhao.view:setPosition(0, self.banhao.view:getPositionY() - 20)


	self.winRoot = self:get_widget_by_name("win_root")
	self.winRoot.view:setSize(panelWidth, panelHeight)
	
	self.img_2 = self:get_widget_by_name("img_2")

	-- self.fcm_bg = self:get_widget_by_name("fcm_bg")
	-- self.fcm = self:get_widget_by_name("fcm_str")
	-- --适配处理
	-- self.fcm_bg:setSize(panelWidth,35)
	-- self.fcm:setPositionX(panelWidth/2)
	-- self.fcm:setAnchorPoint(0.5,0)
end

-- 需求监听事件 则重写此方法 添加事件监听 父类自动调用
function newSelectServerPage:registered_envetn_func()
	-- 选服按钮回调
	self.serverFrame:set_click_func(bind(self.select_all_server, self))

	-- 登录按钮回调
	self.login:set_click_func(bind(self.loginCallback, self))

	-- 选服页面的公告按钮
	self.notice:set_click_func(bind(self.noticeCallback, self))

	-- 注销按钮
	self.cancellation:set_click_func(bind(self.cancellationCB, self))

	-- 版号按钮
	self.banhao:set_click_func(bind(self.banhaoCallback, self))
end

--设置 要登录的目标服务器
function newSelectServerPage:set_target_server_data(data)
	_target_server_data = data
	local server_name_color = "#cf2c794"
	-- self.server_index:setText(server_name_color .. data.server_id .. "-" .. data.server_name)
	self.server_index:setText(server_name_color..data.server_name)
	local s = _target_server_data.state
	-- print("sssssssssssssssssssssssv=",s)
	s = tonumber(s)
	--local state = {[0]="未开","爆满","推荐","流畅","维护","新服"}
	if s == 0 or s == 4 then
		self.img_2:setTexture("sui/login/weihu.png")
	elseif s == 1 then
		self.img_2:setTexture("sui/login/hot.png")
	else
		self.img_2:setTexture("sui/login/tuijian.png")
	end

end

-----------------------方法-----------------------

-- 是否显示
function newSelectServerPage:isVisible(if_show)
	self.view:setIsVisible(if_show)
end

-- 更新
function newSelectServerPage:update(update_type)
	if update_type then
		return
	end
	local new_server_list = RoleModel:get_server_info_list()
	local target_server = new_server_list[1]
	_target_server_data = target_server
	if new_server_list ~= nil and #new_server_list > 0 then
		self:set_target_server_data(target_server)
		local server_index_size = self.server_index:getSize()
		RoleModel:set_log_server_id(tonumber(target_server.server_id))
		local s = target_server.state
		s = tonumber(s)
		if s == 0 or s == 4 then
			self.img_2:setTexture("sui/login/weihu.png")
		elseif s == 1 then
			self.img_2:setTexture("sui/login/hot.png")
		else
			self.img_2:setTexture("sui/login/tuijian.png")
		end
	end
end

-- 注销
function newSelectServerPage:destroy()
	BaseEditWin.destroy(self)
end

-----------------------回调-----------------------

-- 公告回调
function newSelectServerPage:noticeCallback()
	RoleModel:change_login_page( "notice" )
end

-- 取消回调
function newSelectServerPage:cancellationCB()
	if Target_Platform == Platform_Type.UNKNOW or Target_Platform == Platform_Type.NOPLATFORM then
		RoleModel:change_login_page("login")
	else
		PlatformInterface:logout()
		--PlatformInterface:doLogin()
		-- PlatformInterface:onEnterLoginState()
	end
end

-- 登录回调
function newSelectServerPage:loginCallback()
	local enter_btn_pushed = RoleModel:get_enter_btn_pushed()
	if enter_btn_pushed then return end

	require "UI/UI_Utilities"
	UI_Utilities.DestroyAdButton()
	UI_Utilities.DestroyFixButton()
	UI_Utilities.DestroyResourceButton()

	RoleModel:set_enter_btn_pushed(true)
	RoleModel:land_to_game_server(_target_server_data)
end

-- 选服回调
function newSelectServerPage:select_all_server(eventType, msg_id, args)
	self.view:setIsVisible(false)
	if BISystem.server_choice ~= nil then
		BISystem:server_choice()
	end
	RoleModel:change_login_page("select_server")
	RoleModel:update_role_win("server_list")
end

-- 版号回调
function newSelectServerPage:banhaoCallback()
	RoleModel:change_login_page( "banhao" )
end
