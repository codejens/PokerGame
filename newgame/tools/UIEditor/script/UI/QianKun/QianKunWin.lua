-- QianKunWin.lua 
-- created by fangjiehua on 2013-1-10
-- 招财进宝系统窗口
 
super_class.QianKunWin(NormalStyleWindow)

local player_score = 0
local temp_panels = {}  --scroll里的每个panel合集
function QianKunWin:__init( window_name, texture_name, grid, width, height, title_text )
	
	require "../data/exchange_conf1"
	-- 配置信息
	self.exchange_base = exchange_conf1.exchangeItem
	ZImage:create(self.view, UILH_COMMON.normal_bg_v2, 10, 10, 880, 550, 0, 500, 500)
	ZImage:create(self.view, UILH_COMMON.bottom_bg, 27, 450, 845, 100, 0, 500, 500)

	-- 说明文字
	MUtils:create_ccdialogEx(self.view, LH_COLOR[13] .. Lang.qiankun[1], 40, 500, 820, 40, 100, 16)

	ZLabel:create(self.view, LH_COLOR[1] .. Lang.qiankun[2], 40, 480, 14)
	self.chongzhi_lab = ZLabel:create(self.view, "0", 120, 480, 14)
	ZLabel:create(self.view, LH_COLOR[1] .. Lang.qiankun[3], 240, 480, 14)
	self.xiaofei_lab = ZLabel:create(self.view, 0, 320, 480, 14)
	ZLabel:create(self.view, LH_COLOR[1] .. Lang.qiankun[4], 40, 460, 14)
	self.score_lab = ZLabel:create(self.view, "0", 120, 460, 14)
	ZLabel:create(self.view, LH_COLOR[6] .. Lang.dragontext[2], 240, 460, 14)
	-- 活动时间

	local _scroll_info = { x = 28, y = 18, width = 845, height = 440, maxnum = 1, stype = TYPE_HORIZONTAL }
	self.scroll = CCScrollDynamicArea:scrollWithFile( _scroll_info.x, _scroll_info.y, _scroll_info.width, _scroll_info.height, 1, "", _scroll_info.stype )
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
			local sub_panel = self:create_scroll_item(sub_panel);
			self.scroll:addItem(sub_panel);

			self.scroll:refresh();
			return false
		end
	end
	self.scroll:registerScriptHandler(scrollfun);
	self.scroll:refresh()
	QianKunModel:req_exchange_info( )
end

function QianKunWin:create_one_item(parent, x, y, width, height, item_data)
	local t_panel = { }
	t_panel.max_num = item_data.exchangecount
	local item_id = item_data.itemID
	local temp = CCBasePanel:panelWithFile(x, y, width, height, UILH_COMMON.bottom_bg,500,500);
	parent:addChild(temp)
	local title_bg = ZImage:create(temp, UILH_NORMAL.title_bg5, 5, height - 36, width-10, 30, 0, 500)
	local item_name = ItemConfig:get_item_name_by_item_id(item_id)
	ZLabel:create(title_bg.view, item_name, (width-10)/2, 10, 14,2)
	-- 单击物品孔
	local function item_click_fun( slot_item, event_type, args, msgid )
		-- 被点击的坐标点
		local position = Utils:Split(args,":");
		if slot_item.item_id then
			local item_type = ItemModel:get_item_type( slot_item.item_id )
			if item_type == ItemConfig.ITEM_TYPE_WING then
				TipsModel:show_wing_tip_by_item_id( position[1], position[2], slot_item.item_id )
			else
				TipsModel:show_shop_tip( position[1],position[2], slot_item.item_id )
			end
		end
	end
	local slot = MUtils:create_slot_item(temp, UILH_COMMON.slot_bg, 42, 95, 75, 75, item_id, item_click_fun)
	slot:set_color_frame(item_id, 0, 0, 60, 60)
	slot:set_item_count(item_data.count)
	ZLabel:create(temp, LH_COLOR[2] .. Lang.qiankun[5], 16, 73, 15)
	ZLabel:create(temp, tostring(item_data.point), 100, 72, 15)
	ZLabel:create(temp, LH_COLOR[2] .. Lang.qiankun[6], 16, 53, 15)
	t_panel.remain = ZLabel:create(temp, '0', 100, 52, 15)
	local function batch_use_fun(num)
		if player_score < num * item_data.point then
			return GlobalFunc:create_screen_notic(Lang.qiankun[8])
		end
		QianKunModel:req_qiankun_award(item_id, num)
	end
	local function exc_fun()
		local params = {[1] = item_data.point}
		BuyKeyboardWin:show(item_id,batch_use_fun,15,t_panel.max_num, params);
	end

	local exchange_btn = ZButton:create(temp, UILH_COMMON.button8, exc_fun, 45, 6, -1, -1)
	local exc_text = ZLabel:create(exchange_btn.view, Lang.qiankun[7], 39, 14, 16, 2)

	t_panel.view = temp
	return t_panel
end

function QianKunWin:create_scroll_item( row )
	local max_num = #self.exchange_base
	local row_num = math.ceil(max_num/5)
	local d_w = 170	--横间隔
	local d_h = 215 --竖间隔
	local panel_height = d_h * row_num
	local beg_x = 0
	local beg_y = panel_height - d_h
	local panel = CCBasePanel:panelWithFile(0,0,835,panel_height,nil,0,0);
	for i = 0, max_num - 1 do
		local item_data = self.exchange_base[i+1]
		local r_w = math.fmod(i,5)
		local r_h = math.floor(i/5)
		local item_x = beg_x + r_w*d_w
		local item_y = beg_y - d_h*r_h
		local z_panel = self:create_one_item(panel, item_x, item_y, d_w - 8, d_h - 8, item_data)
		temp_panels[i + 1] = z_panel
	end
	QianKunModel:req_qiankun_items()
	return panel
end

-- 更新剩余时间
function QianKunWin:update_remain_time(  )
    if self.time then 
        self.time:destroy();
        self.time = nil;
    end
    local the_time = SmallOperationModel:get_act_time( 22 ); 
    print("time=",the_time);
    local function finish_call(  )
        if self.time then
          self.time:setString(LH_COLOR[15].."0秒")
        end
    end
    self.time = TimerLabel:create_label( self.view, 360, 460, 14, the_time, LH_COLOR[15], finish_call, false,ALIGN_LEFT);

    if the_time == nil or the_time <= 0 then
        finish_call();
    end 
end

function QianKunWin:update(u_type, infos)
	if not infos then return end
	if u_type == "act_info" then
		self.chongzhi_lab:setText(LH_COLOR[1] .. tostring(infos.chongzhi))
		self.xiaofei_lab:setText(LH_COLOR[1] .. tostring(infos.xiaofei))
		self.score_lab:setText(LH_COLOR[1] .. tostring(infos.score))
		player_score = infos.score
		self:update_remain_time()
	elseif u_type == "items" then
		for i, v in ipairs(infos) do
			if temp_panels[i] and temp_panels[i].remain then
				temp_panels[i].remain:setText(LH_COLOR[1] .. tostring(v))
				temp_panels[i].max_num = v
			end
		end
	end
end

function QianKunWin:destroy()
	if self.time then 
        self.time:destroy();
        self.time = nil;
    end
end