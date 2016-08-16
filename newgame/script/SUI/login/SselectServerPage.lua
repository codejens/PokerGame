-- selectServerPage.lua
-- windows 创建范例 (基于ui编辑器的)

super_class.selectServerPage(BaseEditWin)

local slt_btn_fram_t = {}

-- ui 位置调整
local ui_upanel_h = 250 + 50 + 20   -- 上面左右面板高度
local ui_lpanel_w = 165     -- 上面左面板宽度
local ui_rpanel_w = 518     -- 上面有面板宽度

local _state_word = { [0] = LangGameString[1352], [1] = LangGameString[1353], [2] = LangGameString[1354], [3] = LangGameString[1355], [4] = LangGameString[1356],[5]=LangGameString[1357] }     -- 表示状态的字符串 -- [1352]="#cff0000未开服" -- [1353]="#cff0000火爆" -- [1354]="#cffc000推荐" -- [1355]="畅通" -- [1356]="#c101010维护" -- [1357]="新服"
local _state_word_image = { [0] = "ui2/login/weikaifu.png", [1] = "ui2/login/huobao.png", [2] = "ui2/login/tuijian.png", [3] = "ui2/login/changtong.png", [4] = "ui2/login/weihu.png" }

local _NEW_SERVER_STATE = 5

local _refWidth =  UIScreenPos.relativeWidth
local _refHeight = UIScreenPos.relativeHeight

local _screenWidth = _refWidth(1.0)
local _screenHeight = _refHeight(1.0)

local _rx = UIScreenPos.designToRelativeWidth
local _ry = UIScreenPos.designToRelativeHeight

-- 对外接口：事件处理、更新接口-----------
local  function btn_xx(eventType, x, y, self)
	-- body
end 

-- 参数可以根据需求定义，table或者多参 等等
-- @param date是个table 包括字段（需要说明 如下）
-- id 人物id
-- text 按钮名字
function selectServerPage:update_btn(date)
	--这里做更新操作 尽量再封装一次 保证前面代码比较少 方便别人调用
	--self:_update_btn()
end

function selectServerPage:destroy()
	local win = RoleModel:get_login_win()
	if win and win.select_server_page then
		win.select_server_page = nil
	end
	BaseEditWin.destroy(self)
end

function selectServerPage:update(update_type)
	if update_type == "show_connecting" then
		self:show_connecting(true)
	elseif update_type == "hide_connecting" then
		self:show_connecting(false)
	elseif update_type == "server_list" then
		self:update_server_list()
	elseif update_type == "all" then
		self:show_connecting(false)
	end
end

function selectServerPage:isVisible(if_show)
	self.view:setIsVisible(if_show)
end

-- RoleModel:get_server_info_list()  玩家登录过的服务器列表
-- RoleModel:get_server_list_by_page_index(index - 1) 点击其他页的服务器列表信息（即1 - 100）的
function selectServerPage:select_but_callback_func(index)
	if self.page_index and self.scroll_t[self.page_index] then
		self.scroll_t[self.page_index]:setIsVisible(false)
	end
	local scroll_date = RoleModel:get_server_list_by_page_index(index)
	--这里的scroll_date是一个table,里面装着每个服务器的信息
	--每个table的元素有server_id,player_name,job,state(3是流畅),port,sex,player_level,ip,login_time,server_name
	if self.scroll_t[index] == nil then
		local scroll_temp = self:create_list(scroll_date)
		self.select_server_bg:addChild(scroll_temp)
		self.scroll_t[index] = scroll_temp
	end
	self.scroll_t[index]:setIsVisible(true)
	self.page_index = index
end

-- require "../data/server_name_config"
function selectServerPage:create_one_row2(pos_x, pos_y, width, height, texture_name, index, server_date)

	local panel = CCBasePanel:panelWithFile(pos_x, pos_y, width, height, "", 500, 500)
	local num_row = 2
	local row_space = 10
	local btn_ser_h = height - 100
	-- local btn_ser_w = (width -((num_row - 1) * 10)) / num_row
	local btn_ser_w = (width - 120) / 2

	-- 创建右边服务器的按钮
	for i = 1, num_row do
		local date = server_date[(index - 1) * num_row + i]
		if date then
			local spanel = SButton:quick_create(nil, (i-1)*260 - 1, 5 - 3, 245 + 3, 57,"sui/login/bg1_1.png")
			local x = (i-1)*251 + 4
			spanel:setPosition(x,0)
			panel:addChild(spanel.view)

			local function click_func()
				RoleModel:set_server_state(tonumber(date.state))
				RoleModel:change_login_page("new_select_server_page")
				local win = RoleModel:get_new_select_server_page()
				RoleModel:set_log_server_id(date.server_id)
				if win then
					win:set_target_server_data(date)
				end
				self:show_connecting(true)
				self.cur_server = spanel
				self:destroy()
			end
			spanel:set_click_func(click_func)

			local server_state = tonumber(date.state)
			local server_id = date.server_id
			local server_name = date.server_name
			server_id = selectServerPage:get_server_index(server_name)
			if server_id == nil then
				server_id = date.server_id
			end
			MUtils:create_zxfont(spanel, S_COLOR[3]..server_name, 70, 17, 1, 20)
			local state = {[0]="未开","爆满","推荐","流畅","维护","新服"}
			if state[server_state] == "推荐" or state[server_state] == "流畅" or state[server_state] == "新服" then
				MUtils:create_zximg3(spanel,"sui/login/tuijian.png",37,14,28)
				MUtils:create_zximg3(spanel,"sui/login/tj.png",1,17,29)
			elseif state[server_state] == "爆满" then
				MUtils:create_zximg3(spanel,"sui/login/hot.png",37,14,28)
				MUtils:create_zximg3(spanel,"sui/login/bm.png",1,17,29)
			else
				MUtils:create_zximg3(spanel,"sui/login/weihu.png",37,14,28)
				MUtils:create_zximg3(spanel,"sui/login/wh.png",1,17,29)
			end
			if date.job and date.job ~= "" and date.player_level and date.player_level ~= "" then
				local function head_click_callback()
					return false
				end
				local head_deep_bg = CCBasePanel:panelWithFile(219, 22, -1, -1, "sui/mainUI/roleGraphLayer.png", 0, 0)
				head_deep_bg:setAnchorPoint(0.5, 0.5)
				spanel.view:addChild(head_deep_bg, 100)
				head_deep_bg:setScale(0.5)
				head_deep_bg:registerScriptHandler(head_click_callback)
				local head_bg = SPanel:quick_create(0, 0, -1, -1, "sui/mainUI/roleFrame2.png", false, head_deep_bg)
				head_bg.view:registerScriptHandler(head_click_callback)
				local path = string.format("sui/mainUI/role_img%d.png", date.job)
				local head = ZImage:create(head_deep_bg, path, 78, 9, -1, -1)
				head:setAnchorPoint(1, 0)
				local levelBg = SPanel:quick_create(0, 0, -1, -1, "sui/mainUI/roleFrame.png", false, head_deep_bg)
				ZLabel:create(levelBg, tostring("#c824e23"..date.player_level), 20, 5, 20, 2)
				levelBg.view:registerScriptHandler(head_click_callback)
			end
		end
	end
	return panel
end

-- 获取服务器的索引
function selectServerPage:get_server_index(arg)
    local temp_index = 1
    local last_index = 1
    local begin_index = nil
    while temp_index <= string.len(arg) do
        local target_info = string.sub(arg, temp_index, temp_index)
        local temp = CCTextAnalyze:getUTF8LenEx(target_info)
        if temp < 3 then
            if begin_index == nil then
                begin_index = temp_index
            end
            last_index = temp_index + temp
        end
        temp_index = temp_index + temp
    end
    local index = nil
    if begin_index ~= nil then
        index = string.sub(arg, begin_index, last_index - 1)
    end
    return tonumber(index)
end

function selectServerPage:create_scroll_area(panel_table_para, pos_x, pos_y, size_w, size_h, colu_num, sight_num, bg_name)
	local row_num = math.ceil(#panel_table_para/colu_num)
	local scroll = CCScroll:scrollWithFile(pos_x, pos_y, size_w, size_h, row_num, "",TYPE_HORIZONTAL,500,500)
	-- 这个是滚动条左侧显示上下限的控件
	-- scroll:setScrollLump("ui/lh_common/up_progress.png","ui/lh_common/down_progress.png", 10, 20, 42)
    -- scroll:setScrollLumpPos(585)

    local had_add_t = {}
    local function scrollfun(eventType, args, msg_id)
    	if eventType == nil or args == nil or msg_id == nil then
    		return
    	end

    	if eventType == TOUCH_BEGAN then
    		return true
    	elseif eventType == TOUCH_MOVED then
    		if 1 then
    			return false
    		end
    		return true
    	elseif eventType == TOUCH_ENDED then
    		return true
    	elseif eventType == SCROLL_CREATE_ITEM then
    		local temparg = Utils:Split_old(args, ":")
    		local x = temparg[1]
    		local y = temparg[2]
    		local index = x + 1
    		local row = self:create_one_row2(0 + 10, 3 - 3, size_w, 60 - 5, "sui/login/bg1_1.png", index, panel_table_para)
    		scroll:addItem(row)
    		scroll:refresh()
    		return false
    	end
    end
    scroll:registerScriptHandler(scrollfun)
    scroll:refresh()
    return scroll
end

-- 切换列表
function selectServerPage:create_list(list_date)
	-- local server_list_scroll = self:create_scroll_area(list_date, ui_lpanel_w + 18,13, ui_rpanel_w - 10, ui_upanel_h - 20, 3, 5, "")
	--数据倒序一次
	local date = {}
	local index = 1
	for i=#list_date,1,-1 do
		date[index] = list_date[i]
		index = index + 1
	end
	-- local server_list_scroll = self:create_scroll_area(date, 5, 8, 
	-- 	ui_rpanel_w - 10, ui_upanel_h - 20, 2, 5, "sui/login/bg1.png")

	-- 策划要求不能做成滑动， 这里虽然命名为scroll，但其实只是一个panel,只是不改动太多 By FJH
	-- 读取配置婊，创建每一个服务器的按钮
	local server_list_scroll = CCBasePanel:panelWithFile(5, 8, ui_rpanel_w - 10, ui_upanel_h - 17, nil)
	local index = 0
	for k, v in pairs(date) do
		index = index + 1
		local server_btn = self:create_one_row2(0 , 3 - 3, ui_rpanel_w, 60 - 5, "sui/login/bg1_1.png", index, date)
		server_btn:setPositionY(ui_upanel_h - 20 - 59 * index + 5)
		server_list_scroll:addChild(server_btn)		
	end
	return server_list_scroll
end

-- 这个是用于当服务器数量大于101时创建新的左列服务器按钮，暂时没用
function selectServerPage:create_more_server_page(scroll_date)

end


function selectServerPage:update_server_list()
	-- if RoleModel:check_if_had_save_server_info() then
	-- 	self:select_but_callback_func(1)
	-- else
	-- 	self:select_but_callback_func(2)
	-- end

end

function selectServerPage:create_server_list()
	-- -- 推荐服务器的回调，当前后端还没有弄数据，先以我的服务器的回调弄
	-- local function recommondSer_callback()
	-- 	-- 隐藏掉之前的
	-- 	for i = 1, #slt_btn_fram_t do
	-- 		slt_btn_fram_t[i]:setIsVisible(false)
	-- 	end
	-- 	self:select_but_callback_func(2)
	-- end
	-- --  推荐服务器
	-- self.recommondServer = self:get_widget_by_name("recommondServer")
	-- self.recommondServer:set_click_func(recommondSer_callback)


	-- 我的服务器的回调函数
	-- local function mySer_callback()
	-- 	for i = 1, #slt_btn_fram_t do
	-- 		slt_btn_fram_t[i]:setIsVisible(false)
	-- 	end
	-- 	self:select_but_callback_func(1)
	-- end
	-- -- 我的服务器
	-- self.myServer = self:get_widget_by_name("myServer")
	-- self.myServer:set_click_func(mySer_callback)

	-- -- 1 - 100的服务器的回调函数
	-- local function oneToHundred_callback()

	-- end

	-- -- 1 - 100服务器
	-- self.oneToHundred = self:get_widget_by_name("oneToHundred")
	-- self.oneToHundred:registerScriptHandler(oneToHundred_callback)
end

function selectServerPage:create_a_button2(panel, pos_x, pos_y, size_w, size_h, image_texture, but_name, but_index)
	local num_page = RoleModel:get_server_total_page()
	local ser_num_page = RoleModel:get_server_num_per_page()

	for i = 1, num_page do
		self:create_a_button2()
	end
end

-- 该函数貌似是用来显示链接动画，也就是传说中的转菊花~~~
function selectServerPage:show_connecting(if_show)

end

------------------------------------------

function selectServerPage:__init()
	self.page_index  = nil          -- 记录当前页
	self.row_t       = {}		    -- 存储每一行的对象， 用来修改每行数据 	
	self.current_select_row_id = nil  --当前选中的行的id
	self.col_widthes = {95, 135, 135, 20, 75} -- 列宽，用于计算下一列坐标
	self.page_to_row = {}        -- 保存每页的所有行，页号为key，每个元素为table
	self.scroll_t = {}           -- 滚动列表保存  key为页号

	self:create_server_list()

	self.cur_menu_index = 0
	self.total_page     = RoleModel:get_server_total_page()
	self.scroll_menu:update(self.total_page)

	self:select_but_callback_func(self.total_page)

	self.cur_server = nil
end

-- 获取UI控件
function selectServerPage:save_widget()
	-- 左边滚动条背景
	self.scroll_menu = self:get_widget_by_name("scroll_menu")

	-- 右边列表的背景图
    self.select_server_bg = self:get_widget_by_name("server_list_bg")

    --历史服务
    self.history_panel= self:get_widget_by_name("history_panel")
    local date = RoleModel:get_server_info_list()
    local history = self:create_one_row2(5, 16, ui_rpanel_w, 60, "", 1, date)
    self.history_panel:addChild(history)

    self.bigPanel = self:get_widget_by_name("select_server_bg")
end

-- 创建左边滚动条
function selectServerPage:create_server_menu(index)
	local count = self.total_page
	local bg = SPanel:create("sui/common/unselected_panel.png",194,68,true)
	if tonumber(index) == self.cur_menu_index then
		bg:setTexture("sui/common/selected_panel.png")
		self.cur_menu = bg
	end
	local num = (count - index)*10
	local str = string.format("#c854c0f%d-%d服",num-9,num)
	local label = SLabel:create(str,22,ALIGN_CENTER)
	label:setPosition(98,19)
	bg:addChild(label)

	local function click_func()
		if self.cur_menu == bg then
			return
		end
		if self.cur_menu then
		   self.cur_menu:setTexture("sui/common/unselected_panel.png")
		end
		bg:setTexture("sui/common/selected_panel.png")
		self.cur_menu       = bg
		self.cur_menu_index = tonumber(index)
		self:select_but_callback_func(count-index)
	end
	bg:set_touch_func(TOUCH_ENDED, click_func)

	local function remove_func()
		if self.cur_menu == bg then
			self.cur_menu = nil
		end
	end
	bg:set_touch_func(ITEM_DELETE, remove_func)
	return bg
end

-- 需求监听事件 则重写此方法 添加事件监听 父类自动调用
function selectServerPage:registered_envetn_func()
	local function backItemCallback()
		RoleModel:change_login_page("new_select_server_page")
		self:destroy()
	end
	-- 返回登录的按钮
	self.backItem = self:get_widget_by_name("close_btn")
	self.backItem:set_click_func(backItemCallback)

	-- 确定按钮
	local function create_menu(index)
		return self:create_server_menu(index)
	end
	self.scroll_menu:set_touch_func(SCROLL_CREATE_ITEM, create_menu)
	self.scroll_menu.view:setGapSize(0)
end