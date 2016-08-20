-- wingotherWin.lua 
-- createed by chj at 2014.10.30
-- 翅膀查看他人界面(天将雄狮版本)

super_class.WingOtherWin(NormalStyleWindow)

-- ui param
local win_w = 900
local win_h = 605

local radio_b_w = 101 -- 从ui获取的尺寸,radiobtn
local radio_b_h = 45

local align_x = 10
local panel_page_w = win_w-align_x*2
local panel_page_h = win_h-radio_b_h-40

-- 初始化
function WingOtherWin:__init( window_name, texture_name )

	-- 存放分页和记录当前页
	self.radio_btn_t = {}
	self.page_t = {}
	self.cur_page = nil

	-- 添加分页按钮组
	-- 添加分页按钮(1个)
	local btn_name_t = { Lang.wing[1] }
	self.radio_btn_group = CCRadioButtonGroup:buttonGroupWithFile( 30, 523, radio_b_w* #btn_name_t, radio_b_h, nil)
	self.view:addChild(self.radio_btn_group)

	-- radiobtn
	self:create_radio_btn( self.radio_btn_group, btn_name_t[1], 1 )

	-- 添加分页panel,放置tab页
	self.panel_page = CCBasePanel:panelWithFile(align_x, align_x, panel_page_w, panel_page_h, "" )
	self.view:addChild( self.panel_page )
end

-- 创建 radio_btn
function WingOtherWin:create_radio_btn( radio_group, btn_name, btn_index )
	local radio_btn = CCRadioButton:radioButtonWithFile( 
		radio_b_w*(btn_index-1), 0, -1, -1, UILH_COMMON.tab_gray )
    radio_btn:addTexWithFile( CLICK_STATE_DOWN, UILH_COMMON.tab_light )
    local btn_txt = UILabel:create_lable_2( btn_name, radio_b_w/2, 10, font_size, ALIGN_CENTER)
    radio_btn:addChild( btn_txt )
    radio_group:addGroup( radio_btn )
    local function radio_btn_fun( eventType, x, y )
        if eventType ==  TOUCH_BEGAN then 
            return true
        elseif eventType == TOUCH_CLICK then
            self:change_page( btn_index )
            return true;
        elseif eventType == TOUCH_ENDED then
            return true;
        end
    end
    self.radio_btn_t[btn_index] = radio_btn
    radio_btn:registerScriptHandler( radio_btn_fun )
end

-- 切换tab页
function WingOtherWin:change_page( page_index )

	-- 如果是当前页，则返回
	if self.cur_page ~=nil and self.page_t[page_index] == self.cur_page then
		return
	end
	-- 隐藏tab页
	for k, v in pairs(self.page_t) do
		v.view:setIsVisible( false )
	end
	
	if self.page_t[page_index] then
		self.page_t[page_index].view:setIsVisible( true )
	else
		local tab_page = nil
		-- 1.翅膀信息, 2.翅膀升级, 3.翅膀升阶
		if page_index == 1 then
			tab_page = WingOtherInfoPage()
		end

		tab_page.view:setPosition(0, 0)
		self.panel_page:addChild( tab_page.view )
		self.page_t[page_index] = tab_page
	end
	self.cur_page = self.page_t[page_index]
	self.radio_btn_group:selectItem(page_index-1)

	-- 更新分页数据
	self.page_t[page_index]:update("all")
end

-- 更新界面
function WingOtherWin:update( updateType )
	if updateType == "all" then
		self:change_page( 1 )
	end
end

-- 激活时更新数据
function WingOtherWin:active( show )
	if show then
		self:update("all")
	end
end

-- 销毁窗体
function WingOtherWin:destroy()
	for i=1, #self.page_t do
		if self.page_t[i] then
			self.page_t[i]:destroy()
		end
	end
	WingModel:setIsShowOtherWing(false)
    Window.destroy(self)
end