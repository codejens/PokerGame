--CSuperTuanGouWin.lua
--内容：团购界面
--作者：chj
--时间：2015.1.16

local radio_b_w = 101 -- 从ui获取的尺寸,radiobtn
local radio_b_h = 45

local panel_page_w = 412
local panel_page_h = 515


--创建团购积分窗口类
super_class.SuperTuanGouWin(NormalStyleWindow)

-- 初始化创建
function SuperTuanGouWin:__init()
	-- 存放分页和记录当前页
	self.radio_btn_t = {}
	self.page_t = {}
	self.cur_page = nil

	-- 创建分页按钮
	self.radio_btn_group = CCRadioButtonGroup:buttonGroupWithFile( 30, 518, radio_b_w * 3, radio_b_h, nil)
	self.view:addChild(self.radio_btn_group)

	-- 添加分页按钮(3个)
	local btn_name_t = { Lang.SuperGBuy[1], Lang.SuperGBuy[2], Lang.SuperGBuy[2] }
	for i=1, 3 do
		self:create_radio_btn( self.radio_btn_group, btn_name_t[i], i )
	end

	-- 添加分页panel,放置tab页
	self.panel_page = CCBasePanel:panelWithFile(10, 10, panel_page_w, panel_page_h, UILH_COMMON.normal_bg_v2, 500, 500 )
	self.view:addChild( self.panel_page )
end

-- 创建 radio_btn
function SuperTuanGouWin:create_radio_btn( radio_group, btn_name, btn_index )
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

    -- 获取开服时间
    SuperGroupBuyModel:set_remain_time( )
end


-- 切换tab页
function SuperTuanGouWin:change_page( page_index )
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
			tab_page = GroupBuyPage()
		elseif page_index == 2 then
			tab_page = CountPointsPage()
		elseif page_index == 3 then
			tab_page = BuyIntroPage()
		end

		tab_page.view:setPosition(0, 0)
		self.panel_page:addChild( tab_page.view )
		self.page_t[page_index] = tab_page
	end
	self.cur_page = self.page_t[page_index]
	self.radio_btn_group:selectItem(page_index-1)

	-- 更新分页数据
	-- self.page_t[page_index]:update("all")
	self.page_t[page_index]:update("all")
end

-- 获取当前分页
function SuperTuanGouWin:get_cur_page()
	return self.cur_page
end

-- 获取第几个分页
function SuperTuanGouWin:get_page_by_index( index )
	return self.page_t[index]
end

-- ======================================
-- 更新界面
-- ======================================
function SuperTuanGouWin:update( status )
	-- body
end

function SuperTuanGouWin:active(status)
	self:change_page(1)
	-- --打开窗口
	-- if status then
	-- 	SuperGroupBuyModel:openCountPointWin()
	-- --关闭窗口
	-- else
	-- 	SuperGroupBuyModel:closeActivityWin()
	-- end
end

function SuperTuanGouWin:destroy()
	-- 清除开服时间
	SuperGroupBuyModel:clear_remain_time()
	
	for k, v in pairs(self.page_t) do
		v:destroy()
	end
	Window.destroy(self)
end