super_class.RenzhejijinWin( Window )

function RenzhejijinWin:__init( window_name, texture_name, is_grid, width, height )
    self.btn_name_t = {}  --标签不同文字贴图集合

	self.get_btn_t = {}
	self.get_btn_t[RenZheJiJinConfig.n30DAY] = {}
	self.get_btn_t[RenZheJiJinConfig.n7DAY] = {}

	local beg_x, beg_y = 31, 19
	local bg_w, bg_h = 855, 530
	local offset = 10
	local bg1 = CCBasePanel:panelWithFile( beg_x, beg_y, bg_w, bg_h, UI_RZJJWin_001, 500, 500 );
	self:addChild( bg1 );

	local bg2 = CCBasePanel:panelWithFile( beg_x+offset, beg_y+offset, bg_w-offset*2, bg_h-offset*2, UI_RZJJWin_018, 500, 500 )
	self:addChild(bg2)

	-- 窗口标题
	local winTitleBg = CCZXImage:imageWithFile( 165, 525, -1, -1, UI_RZJJWin_015, 500, 500 );
	local winTitleImg= CCZXImage:imageWithFile( 356, 547, -1, -1, UI_RZJJWin_003, 500, 500 );
	self.view:addChild( winTitleBg, 1000 );
	self.view:addChild( winTitleImg, 1001 );

	-- 美女
	ZImage:create(self, UI_RZJJWin_025, 3, 29, -1, -1)

	-- 只能选择一种基金购买
	local label = ZLabel.new(LangGameString[2411])
	label.view:setAnchorPoint(CCPointMake(0.5, 0))
	label:setPosition(605, 450)
	self:addChild(label.view)

	label = ZLabel.new(LangGameString[2412])
	label.view:setAnchorPoint(CCPointMake(0.5, 0))
	label:setPosition(605, 428)
	self:addChild(label.view)

	local tipsImag = CCZXImage:imageWithFile( 294, 485, -1, -1, UI_RZJJWin_009 );
	self.view:addChild( tipsImag );

	local function click_fun()
		MiscCC:send_tzfl_buy( self.selected_page, 3 )
	end

	-- 购买按钮
	self.buy_btn     = ZButton:create( self, UI_RZJJWin_013, click_fun, 392+310, 470, -1, -1 );
	self.buy_btn_lab = CCZXImage:imageWithFile( 73+1, 24+5, -1, -1, UI_RZJJWin_004 );
	self.buy_btn_lab:setAnchorPoint( 0.5,0.5 );
	self.buy_btn:addChild( self.buy_btn_lab );
	self.buy_btn:addImage( CLICK_STATE_DISABLE, UI_RZJJWin_014 );
	self.buy_btn.view:setCurState( CLICK_STATE_UP );

	-- 标签
	local btn_beg_x = 315          --按钮起始x坐标
	local btn_beg_y = 420         --按钮起始y坐标
    local btn_offset = 117          --按钮x坐标间隔
    local btn_w = 110
    local btn_h = 60
    local btn_n = 2
    local btn_i = 1

    -- 第一页的按钮
    self.raido_btn_group = CCRadioButtonGroup:buttonGroupWithFile(btn_beg_x, btn_beg_y , btn_offset * btn_n, btn_h, nil)
    self:addChild(self.raido_btn_group)

    self:create_a_button(self.raido_btn_group, 1 + btn_offset * (btn_i - 1), 1, btn_w, btn_h, 
        UIPIC_FORGE_020,
        UIPIC_FORGE_021, 
        UI_RZJJWin_026,
        UI_RZJJWin_023,
        -1, -1, RenZheJiJinConfig.n30DAY)

    btn_i = btn_i + 1
    self:create_a_button(self.raido_btn_group, 1 + btn_offset * (btn_i - 1), 1, btn_w, btn_h, 
        UIPIC_FORGE_020,
        UIPIC_FORGE_021, 
        UI_RZJJWin_027,
        UI_RZJJWin_024,
        -1, -1, RenZheJiJinConfig.n7DAY)

	bg_w, bg_h = 568, 390
	beg_x, beg_y = 302, 35
	local bg3 = CCBasePanel:panelWithFile(beg_x, beg_y, bg_w, bg_h, UIPIC_BUYKEYBOARD_002, 500, 500)
	self:addChild(bg3)

	self.haohua_scroll = self:create_haohua_scroll(313, 50, 546, 360 )
	self:addChild(self.haohua_scroll)

	self.zhizuan_scroll = self:create_zhizuan_scroll(313, 50, 546, 360)
	self:addChild(self.zhizuan_scroll)

	self.selected_page = RenZheJiJinConfig.n30DAY
	local cost = RenZheJiJinConfig:get_cost_by_type( self.selected_page )
	local award = RenZheJiJinConfig:get_all_award( self.selected_page )
	self.buy_tips = {}
	self.buy_tips[1] = ZLabel.new(string.format(LangGameString[2419], cost))
	self.buy_tips[1].view:setAnchorPoint(CCPointMake(0.5, 0))
	self.buy_tips[1]:setPosition(775, 450)
	self:addChild(self.buy_tips[1].view)

	self.buy_tips[2] = ZLabel.new(string.format(LangGameString[2420], award))
	self.buy_tips[2].view:setAnchorPoint(CCPointMake(0.5, 0))
	self.buy_tips[2]:setPosition(775, 428)
	self:addChild(self.buy_tips[2].view)

	self:change_page(RenZheJiJinConfig.n30DAY)
end

function RenzhejijinWin:change_page( jijin_type )
	 --将其他标签全部更改文字贴图
    for k,v in pairs(self.btn_name_t) do
       v.change_to_no_selected()
    end
    self.btn_name_t[jijin_type].change_to_selected()

	self.haohua_scroll:setIsVisible(false)
	self.zhizuan_scroll:setIsVisible(false)

	if jijin_type == RenZheJiJinConfig.n7DAY then
		self.zhizuan_scroll:setIsVisible(true)
		self.selected_page = RenZheJiJinConfig.n7DAY
	else
		self.haohua_scroll:setIsVisible(true)
		self.selected_page = RenZheJiJinConfig.n30DAY
	end

	self:set_text_label(self.selected_page)
	if not RenZheJiJinModel:get_jijin_can_buy( self.selected_page ) then
		self.buy_btn.view:setCurState( CLICK_STATE_DISABLE )
		self.buy_btn_lab:setTexture( UI_RZJJWin_005 )
	else
		self.buy_btn.view:setCurState( CLICK_STATE_UP )
		self.buy_btn_lab:setTexture( UI_RZJJWin_004 )
	end
end

-- 创建一个按钮:参数： 要加入的panel， 坐标和长宽，按钮两种状态背景图，显示文字图片，文字图片的长宽，序列号（用于触发事件判断调用的方法）
function RenzhejijinWin:create_a_button(panel, pos_x, pos_y, size_w, size_h, image_n, image_s ,but_name,but_name_s,but_name_siz_w, but_name_siz_h, jijin_type)
    local radio_button = CCRadioButton:radioButtonWithFile(pos_x, pos_y, size_w, size_h, image_n)
    radio_button:addTexWithFile(CLICK_STATE_DOWN,image_s)
	local function but_1_fun(eventType,x,y)
		if eventType == TOUCH_BEGAN  then             
			return true
        elseif eventType == TOUCH_CLICK then
            self:change_page(jijin_type)
            return true;
        elseif eventType == TOUCH_ENDED then
            return true;
		end
	end
    radio_button:registerScriptHandler(but_1_fun)    --注册
    panel:addGroup(radio_button)

    --按钮显示的名称
    --local name_image = CCZXImage:imageWithFile( size_w/2, size_h/2, but_name_siz_w, but_name_siz_h, but_name );  
   -- name_image:setAnchorPoint(0.5, 0.5)
     self.btn_name_t[jijin_type] = RenzhejijinWin:create_btn_name(but_name,but_name_s,size_w/2,size_h/2,but_name_siz_w,but_name_siz_h)

    radio_button:addChild( self.btn_name_t[jijin_type].view )
    return radio_button
end

--xiehande
function  RenzhejijinWin:create_btn_name( btn_name_n,btn_name_s,name_x,name_y,btn_name_size_w,btn_name_size_h )
    -- 按钮名称贴图集合
    local  button_name = {}
    local  button_name_image = CCZXImage:imageWithFile(name_x,name_y,btn_name_size_w,btn_name_size_h,btn_name_n)
    button_name_image:setAnchorPoint(0.5,0.5)
    button_name.view = button_name_image
    --按钮被选中，调用函数切换贴图至btn_name_s
    button_name.change_to_selected = function ( )
        button_name_image:setTexture(btn_name_s)
    end

    --按钮变为未选时  切换贴图到btn_name_n
    button_name.change_to_no_selected = function ( )
        button_name_image:setTexture(btn_name_n)
    end

    return button_name

end

function RenzhejijinWin:create_one_day_panel( jijin_type, day_index, x, y, w, h )
	local day_text = LangGameString[2413]
	local money = 0
	local money_name = LangGameString[2415]
	if day_index == 1 then
		day_text = LangGameString[2413]
		money = RenZheJiJinConfig:get_cost_by_type( jijin_type )
		money = string.format(LangGameString[2415], money)
	else
		day_text = string.format(LangGameString[2414], day_index-1)
		money = RenZheJiJinConfig:get_award( jijin_type, day_index)
		money = string.format(LangGameString[2416], money)
	end

	local panel = ZBasePanel.new( "", w, h )
	panel:setPosition(x, y)

	local label = ZLabel.new(day_text)
	label:setFontSize(18)
	label:setPosition(50, 22)
	panel:addChild(label.view)

	label = ZLabel.new(money)
	label:setFontSize(18)
	label:setPosition(204, 22)
	panel:addChild(label.view)

	local click_fun = function(  )
		MiscCC:send_tzfl_get_reward(day_index)
	end
	--xiehande   UIPIC_ACTIVITY_023 ->UIPIC_COMMOM_002  UIPIC_ACTIVITY_024 ->UIPIC_COMMOM_004
	local btn = ZButton.new( UIPIC_COMMOM_002, UIPIC_COMMOM_002, UIPIC_COMMOM_004 )
	btn:setPosition(385, 8-4)
	btn:setTouchClickFun( click_fun )
	panel:addChild(btn)

	local btn_txt = ZLabel.new(LangGameString[2417])
	btn_txt:setFontSize(16)
	btn_txt.view:setAnchorPoint(CCPointMake(0.5, 0))
	btn_txt:setPosition(126/2, 15+5)
	btn.view:addChild(btn_txt.view)

	self.get_btn_t[jijin_type][day_index] = {}
	self.get_btn_t[jijin_type][day_index].btn = btn
	self.get_btn_t[jijin_type][day_index].btn_txt = btn_txt

	local line = ZBasePanel.new(UI_RZJJWin_019, w, 3)
	line:setPosition(0, 0)
	panel:addChild(line.view)

	return panel
end

function RenzhejijinWin:create_scroll( item, x, y, w, h )
	local _scroll_info = { x = x, y = y, width = w, height = h, maxnum = 1, image = nil, 
		stype = TYPE_HORIZONTAL 
	}
	local scroll = CCScroll:scrollWithFile( _scroll_info.x, _scroll_info.y, 
		_scroll_info.width, _scroll_info.height, 
		_scroll_info.maxnum, _scroll_info.image, 
		_scroll_info.stype, 500, 500 )

	local function scrollfun(eventType, arg, msgid)
		if eventType == nil or arg == nil or msgid == nil then
			return false
		end
		if eventType == SCROLL_CREATE_ITEM then
			scroll:addItem(item)
			scroll:refresh()
		end
		return true
	end
	scroll:registerScriptHandler(scrollfun)
	scroll:refresh()

	return scroll
end

function RenzhejijinWin:create_haohua_panel( x, y )
	local haohua_conf = RenZheJiJinConfig:get_fanhuan_by_type( RenZheJiJinConfig.n30DAY )
	local num = #haohua_conf
	local width = 546

	local panel = ZBasePanel.new("", width, (num)*58)
	panel:setPosition(x, y)

	for i=1,num do
		local item = self:create_one_day_panel( RenZheJiJinConfig.n30DAY, i, 0, (num)*58-(i)*58, width, 58 )
		panel:addChild(item.view)
	end

	return panel
end

function RenzhejijinWin:create_haohua_scroll( x, y, w, h )
	local panel = self:create_haohua_panel(0, 0)
	local scroll = self:create_scroll(panel.view, x, y, w, h)
	return scroll
end

function RenzhejijinWin:create_zhizuan_panel( x, y )
	local zhizuan_conf = RenZheJiJinConfig:get_fanhuan_by_type( RenZheJiJinConfig.n7DAY )
	local num = #zhizuan_conf
	local width = 546

	local panel = ZBasePanel.new("", width, (num)*58)
	panel:setPosition(x, y)

	for i=1,num do
		local item = self:create_one_day_panel( RenZheJiJinConfig.n7DAY, i, 0, (num)*58-(i)*58, width, 58 )
		panel:addChild(item.view)
	end

	return panel
end

function RenzhejijinWin:create_zhizuan_scroll( x, y, w, h )
	local panel = self:create_zhizuan_panel(0, 0)
	local scroll = self:create_scroll(panel.view, x, y, w, h)
	return scroll
end

function RenzhejijinWin:destroy()
	Window.destroy( self );
end

function RenzhejijinWin:init_btn_state(  )
	for k,v in pairs(self.get_btn_t) do
		for i,btn_t in pairs(v) do
			btn_t.btn:setCurState(CLICK_STATE_DISABLE)
			btn_t.btn_txt:setText(LangGameString[2417])
		end
	end

	-- self.buy_btn.view:setCurState( CLICK_STATE_UP )
	-- self.buy_btn_lab:setTexture( UI_RZJJWin_004 )

	return
end

function RenzhejijinWin:set_btn_state( jijin_type )
	if jijin_type == RenZheJiJinConfig.NONE_JIJIN then
		self:init_btn_state()
		return
	else
		local btn_t = self.get_btn_t[jijin_type]

		for k,v in pairs(btn_t) do
			local state = RenZheJiJinModel:get_jijin_reward_by_day(k)
			if state == 0 then
				v.btn:setCurState(CLICK_STATE_UP)
				v.btn_txt:setText(LangGameString[2417])
			elseif state == 1 then
				v.btn:setCurState(CLICK_STATE_DISABLE)
				v.btn_txt:setText(LangGameString[2418])
			else
				v.btn:setCurState(CLICK_STATE_DISABLE)
				v.btn_txt:setText(LangGameString[2417])
			end
		end
	end
end

function RenzhejijinWin:set_text_label( jijin_type )
	local cost = RenZheJiJinConfig:get_cost_by_type( jijin_type )
	local award = RenZheJiJinConfig:get_all_award( jijin_type )
	self.buy_tips[1]:setText(string.format(LangGameString[2419], cost))
	self.buy_tips[2]:setText(string.format(LangGameString[2420], award))
end

-- 刷新忍者基金信息
function RenzhejijinWin:update()
	local jijin_type  = RenZheJiJinModel:get_jijin_kind();
	self:init_btn_state()
	self:set_btn_state(jijin_type)
	if not RenZheJiJinModel:get_jijin_can_buy( self.selected_page ) then
		self.buy_btn.view:setCurState( CLICK_STATE_DISABLE )
		self.buy_btn_lab:setTexture( UI_RZJJWin_005 )
	else
		self.buy_btn.view:setCurState( CLICK_STATE_UP )
		self.buy_btn_lab:setTexture( UI_RZJJWin_004 )
	end
end

-- 窗口显示、隐藏时的调用
function RenzhejijinWin:active( show )
	if show then
		MiscCC:send_tzfl_info();
		-- self:update();
	end
end
