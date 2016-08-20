--登陆送元宝
--created by chj on 2015.1.15
--AwardWin
super_class.loginAwardPage()
----------------------
local _cur_panel = nil
local _refresh_time = 10
----------------------

--窗体大小
local window_width =880
local window_height = 520

----------------------
function loginAwardPage:__init(window_name, texture_name )
	-- 是否抽奖，0为不是，（1,2,3）
	self._draw_index = 0 
	self._can_get_award = nil

	-- 今天是第几天
	self._day_index = 0

	self.view = ZBasePanel.new("", window_width, window_height).view

	-------底图颜色
	local hole_bg = CCBasePanel:panelWithFile( 0, 0, window_width, window_height, UILH_COMMON.normal_bg_v2, 500, 500 )
	self.view:addChild( hole_bg )
	local panel_bg = CCBasePanel:panelWithFile( 13, 14, 853, window_height - 26, UILH_COMMON.bottom_bg, 500, 500 )
    hole_bg:addChild( panel_bg )

    -- == up =========================================
    -- 宝箱
    self.yb_img = CCBasePanel:panelWithFile( 200, 407, -1, -1, UILH_AWARD.la_yuanbao)
    self.view:addChild(self.yb_img)

    -- 大背景框
    self.panel_big = CCBasePanel:panelWithFile( 147, 85, 570, 320, UILH_AWARD.la_bg_1, 500, 500)
    self.view:addChild(self.panel_big)

    -- 时间title
    self.panel_title = CCBasePanel:panelWithFile(15, 255, 540, 50, UILH_AWARD.la_bg_2, 500, 500)
    self.panel_big:addChild(self.panel_title)

    -- 登陆送元宝，广告语
    self.guanggao_title = CCBasePanel:panelWithFile( 345, 455, -1, -1, UILH_AWARD.la_title_1)
    self.view:addChild(self.guanggao_title)
    self.guanggao_title_1 = CCBasePanel:panelWithFile( 395, 410, -1, -1, UILH_AWARD.la_title_2)
    self.view:addChild(self.guanggao_title_1)


    -- 活动时间
    ZLabel:create( self.panel_title, LH_COLOR[1] .. "每天有一次摇数字机会", 544*0.5, 20, 16, ALIGN_CENTER)
    -- ZLabel:create( self.panel_title, LH_COLOR[1] .. LoginLuckyDrawModel:get_open_time_str(), 180, 20, 16)

    -- 3个数字
    self.logic_num_t = {}
    self:create_logic_num()

    -- 创建3个按钮 & 按钮上的图片文字
    self.day_btn_t = {}
    self.day_btn_lab_t = {}
    self:create_day_btn()

    local function joy_btn_func( )
    	Instruction:handleUIComponentClick(instruct_comps.LOGIN_AWARD_GET)
    	local is_get, num_t = LoginLuckyDrawModel:get_data()
    	if is_get then
    		GlobalFunc:create_screen_notic( "活动已结束" )
    		return
    	end
    	if self._day_index > 0 and self._day_index < 4 then
	    	self._draw_index = self._day_index
			LoginLuckyDrawModel:req_lucky_draw(self._day_index)
		end
    end

    -- 摇杆按钮
    self.joy_btn = ZButton:create( self.view, UILH_AWARD.la_joy, bind(joy_btn_func, giftIndex),
					711, 220, -1, -1 )
	self.joy_btn:addImage(CLICK_STATE_DOWN, UILH_AWARD.la_joy)
	self.joy_btn:addImage(CLICK_STATE_UP, UILH_AWARD.la_joy)

    -- tip
    local panel_tip = CCBasePanel:panelWithFile( 160, 52, 540, 30, UILH_NORMAL.title_bg4 )
    self.view:addChild(panel_tip)
    ZLabel:create( panel_tip, LH_COLOR[1] .. "三天后可获取对应的数字奖励", 145, 7, 16)
    ZLabel:create( self.view, "当前累计天数1天，错过的天数将抽取数字为0", 245, 27, 16)
end

 -- 3个数字
local function get_logic_num_func( one_num )
	return string.format("ui/lh_award/num_%d.png",one_num);
end
function loginAwardPage:create_logic_num( )
	require "UI/sevenDayAward/RollImageNum"
	local num_bg = CCBasePanel:panelWithFile( 160, 160, 540, 180, "" )
	self.view:addChild( num_bg )
	for i=1, 3 do
		self.logic_num_t[i] = RollImageNum:create(num_bg, i, UILH_AWARD.big_num_path .. "%d.png", 178*(i-1)+5, 0, 175, 175 )
	end
end

function loginAwardPage:create_day_btn()
	local panel_btn = CCBasePanel:panelWithFile( 160, 100, 540, 60, "" )
	self.view:addChild( panel_btn )
	for i=1, 3 do
		local function day_btn_func()
			if self._can_get_award then
				LoginLuckyDrawModel:req_get_award()
			else
				-- self._draw_index = i
				-- LoginLuckyDrawModel:req_lucky_draw(i)
				GlobalFunc:create_screen_notic("拉动右边摇杆,摇出幸运数")
			end
		end

		self.day_btn_t[i] = ZTextButton:create( t_panel, "", UILH_NORMAL.special_btn, day_btn_func, 178*(i-1)+10, 0, -1, -1, 1)
		self.day_btn_t[i].view:addTexWithFile(CLICK_STATE_DISABLE, UILH_NORMAL.special_btn_d)
		self.day_btn_lab_t[i] = ZImage:create(self.day_btn_t[i].view, UILH_AWARD.la_lbl_path .. i .. ".png", 162*0.5-30, 53*0.5-12, -1, -1)
		panel_btn:addChild(self.day_btn_t[i].view)
	end
end

-- ==================================
--         更新方法
-- ==================================
function loginAwardPage:update_data()
	self._day_index = 0
	local is_get, num_t = LoginLuckyDrawModel:get_data()
	if is_get then
		for i=1, 3 do
			self.day_btn_t[i].view:setCurState(CLICK_STATE_DISABLE)
			self.day_btn_lab_t[i].view:setTexture(UILH_BENEFIT.lingqujiangli)
			self.logic_num_t[i]:set_num_direct(num_t[i])
		end
	else
		self._can_get_award = true
		for i=1,3 do
			if num_t[i] > -1 and num_t[i] < 10 then
				self.day_btn_t[i].view:setCurState(CLICK_STATE_DISABLE)
				if self._draw_index == i then
					self.logic_num_t[i]:set_num_roll(num_t[i], 3)
				else
					self.logic_num_t[i]:set_num_direct(num_t[i], 3)
				end
			else
				self._can_get_award = false

				if self._day_index == 0 then
					self._day_index = i
				end
				-- self.logic_num_t[i]:set_num_roll(0, 3)
				self.logic_num_t[i]:set_num_direct(0);
			end
		end
		if self._can_get_award then
			for i=1, 3  do
				self.day_btn_t[i].view:setCurState(CLICK_STATE_UP)
				self.day_btn_lab_t[i].view:setTexture(UILH_BENEFIT.lingqujiangli)
			end
		end
	end

	-- 设置按钮状态
	if self._day_index > 0 and self._day_index < 4 then
		for k,v in pairs(self.day_btn_t) do
			v.view:setCurState(CLICK_STATE_DISABLE)
		end
		self.day_btn_t[self._day_index].view:setCurState(CLICK_STATE_UP)
	end

	self._draw_index = 0
end

-- update
function loginAwardPage:update( update_type )
	if update_type == "all" then
        -- self:update_fun(1)
        LoginLuckyDrawModel:req_login_award_data()
    elseif update_type == "update_data" then
    	self:update_data()
	end
end

----------------------
function loginAwardPage:active(show)
	if show == true then

	else

	end
end
----------------------
function loginAwardPage:destroy()
	for k,v in pairs(self.logic_num_t) do
		v:destroy()
		v = nil
	end
	self._draw_index = 0
	self._can_get_award = false
end
