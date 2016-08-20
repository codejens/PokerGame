-- PayWin.lua
-- create by hcl on 2013-9-25
-- 支付窗口

super_class.PayWin(NormalStyleWindow)

function PayWin:__init( )
	self.pay_config_info = {}
	require "../data/chong_zhi_config"
	-- self.pay_config_info = ChongZhiConf.oppo
	self.pay_config_info = PlatformInterface:getPayInfo()
	local t_bg = ZImage:create( self.view, UILH_COMMON.normal_bg_v2, 8, 5, 885, 570, nil, 600, 600 )
	local maxnum = math.ceil((#self.pay_config_info)/4);
	local _scroll_info = { x = 210, y = 35, width = 640, height =400, maxnum = maxnum, stype = TYPE_HORIZONTAL }
	ZImage:create( self.view, UILH_COMMON.bottom_bg, _scroll_info.x - 5, _scroll_info.y - 5, _scroll_info.width + 10, _scroll_info.height + 10, nil, 600, 600 )
	-- 了解仙尊按钮
	local function btn_fun(eventType,x,y)
		UIManager:show_window("vipSys_win");
	end

	ZTextButton:create( self.view, Lang.pay[1], UILH_COMMON.btn4_nor, btn_fun, 735, 482, -1, -1)

	ZImage:create(self.view, UILH_PAY.text_bg, 340, 495, -1, -1)
	local vip_bg = ZImage:create(self.view, UI_VIP.vip_bg, 600, 480, -1, -1)
	ZImage:create(vip_bg.view, UI_VIP.vip_small, 0, 17, -1, -1)
	local function get_num_ima( one_num )
        return UI_VIP.vip_s[one_num+1]
    end
    self.vip_lv = ImageNumberEx:create(0, get_num_ima, 11, 24)
    self.vip_lv.view:setAnchorPoint(CCPointMake(0.5, 0))
	self.vip_lv.view:setPosition(48, 29)
	vip_bg.view:addChild(self.vip_lv.view)
	-- 进度条
	self.recharge_bar = MUtils:create_progress_bar( 280, 460, 441, 23, UILH_NORMAL.progress_bg, UI_VIP.progress_fr, 0, {16,nil}, {11,11,5,6}, true )
	self.view:addChild( self.recharge_bar.view, 6 )

	-- local _scroll_info = { x = 210, y = 115, width = 640, height =300, maxnum = maxnum, stype = TYPE_HORIZONTAL }
	self.scroll = CCScrollDynamicArea:scrollWithFile( _scroll_info.x, _scroll_info.y, _scroll_info.width, _scroll_info.height, _scroll_info.maxnum, "", _scroll_info.stype )
	self.view:addChild(self.scroll);

	local function scrollfun(eventType, args, msg_id)
		if eventType == nil or args == nil or msg_id == nil then 
			return
		end
		if eventType == TOUCH_BEGAN then
			return true
		elseif eventType == TOUCH_MOVED then
			return true
		elseif eventType == TOUCH_ENDED then
			return true
		elseif eventType == SCROLL_CREATE_ITEM then

			local temparg = Utils:Split(args,":")
			local row = temparg[1] +1             -- 行
			print('row:',row)
			local sub_panel = CCBasePanel:panelWithFile(0,350 - row*350,640,300,nil,0,0);
			self.scroll:addItem(sub_panel);
			self:create_scroll_item(row,sub_panel);

			self.scroll:refresh();
			return false
		end
	end
	self.scroll:registerScriptHandler(scrollfun);
	self.scroll:refresh()
    self.scroll:setScrollLump(UILH_COMMON.up_progress, UILH_COMMON.down_progress, 6, 15, 640)

	-- MUtils:create_zxfont(self.view,"#cfff000成为VIP可以享受更多优惠，详情点击《了解VIP》",324,60,1,16,6);
end

function PayWin:create_a_item(index, x, y, width, height)
	local panel = CCBasePanel:panelWithFile(x, y, width, height, nil)
	local pay_num = self.pay_config_info[index]
	local bg_up     = ZImage:create(nil, UILH_PAY.up_line, width/2, height, -1, -1)
	bg_up:setAnchorPoint( 0.5, 1 )
	local bg_down   = ZImage:create(nil, UILH_PAY.down_line, width/2, 90, -1, -1)
	bg_down:setAnchorPoint( 0.5, 0 )
	local yb_bg     = ZImage:create(nil, UILH_PAY.yb_bg[pay_num], width/2, 203, -1, -1)
	yb_bg:setAnchorPoint(0.5, 0.5)
	local yb_text   = ZImage:create(nil, UILH_PAY.yb_t, width*0.5, 120, -1, -1)
	yb_text:setAnchorPoint(0, 0.5)

	-- 更改，数字与元宝分开
	self.yb_num = ZXLabelAtlas:createWithString( pay_num, "ui/lh_other/number2_" )
    self.yb_num:setPosition(CCPointMake( width/2+9, 120) )
    self.yb_num:setAnchorPoint( CCPointMake(1, 0.5) )
    

	local function btn_fun()
		Analyze:parse_click_main_menu_info(210+index)
        local info = { item_id = pay_num, item_index = index }
        PlatformInterface:payUICallback(info)
	end
	local buy_btn = ZTextButton:create(nil, Lang.pay[2], UILH_COMMON.lh_button_4_r, btn_fun, width/2, 0, 100, -1)
	buy_btn.view:setAnchorPoint(0.5, 0)
	panel:addChild(bg_up.view)
	panel:addChild(bg_down.view)
	panel:addChild(yb_bg.view)
	panel:addChild( self.yb_num )
	panel:addChild(yb_text.view)
	panel:addChild(buy_btn.view)

	return panel
end

function PayWin:create_scroll_item(row, sub_panel)
	for i = 1, 4 do
		local index = (row - 1)*4 + i
		if index > #self.pay_config_info then return end
		local x = 0
		local int_w = 160
		local item = self:create_a_item(index, x + int_w *(i-1), 0, int_w, 300)
		sub_panel:addChild(item)
	end
end

function PayWin:setDisable(state)
	xprint("PayWin:setDisable")
	-- for k,btn in ipairs(self.buttons) do
	-- 	if not state then
	-- 		btn:setCurState(CLICK_STATE_UP)
	-- 	else
	-- 		btn:setCurState(CLICK_STATE_DISABLE)
	-- 	end
	-- end
end
function PayWin:setCallback( buy_callback )
	self.buy_callback  = buy_callback
end

function PayWin:active( show )
	if ( show ) then
		local vip_info = VIPModel:get_vip_info( );
		self.vip_lv:set_number(vip_info.level)

	-- 	-- 更新仙尊进度
		local next_lv_yuanbao = VIPConfig:get_vip_level_yuanbao( vip_info.level + 1 ) or 200000;
		self.recharge_bar.set_max_value( next_lv_yuanbao )
		self.recharge_bar.set_current_value( vip_info.all_yuanbao_value  )
		-- print("vip_info.all_yuanbao_value,vip_info.current_yuanbao_value",vip_info.all_yuanbao_value,vip_info.current_yuanbao_value)
	end
end
