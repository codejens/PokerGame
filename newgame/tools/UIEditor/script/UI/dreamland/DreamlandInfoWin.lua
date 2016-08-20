-- DreamlandInfoWin.lua
-- createed by fangjiehua on 2012-12-24
-- 梦境信息窗口

 
super_class.DreamlandInfoWin(NormalStyleWindow)

local _window_name="dreamland_info_win"
local _base_bg_size = CCSize(435, 605) --底板尺寸

--列表
local _listctrl_padding = {left=15, top=40, right=15, bottom=15} --列表相对底板的间距
local _listctrl_size = CCSize(  --列表的尺寸
	_base_bg_size.width-_listctrl_padding.left-_listctrl_padding.right,
	_base_bg_size.height-_listctrl_padding.top-_listctrl_padding.bottom
	)
local _listctrl_pos = CCPointMake(_listctrl_padding.left, _listctrl_padding.bottom) --列表的位置

--选项按钮
local _tab_region_padding = {left=10, top=0}
local _tab_btn_size = CCSize(101, 45) --tab按钮尺寸
local _tab_btn_pos = CCPointMake(_tab_region_padding.left, _listctrl_size.height-_tab_region_padding.top-_tab_btn_size.height)

--列表背景
local _list_bg_padding = {
	left=0, 
	top=_tab_region_padding.top+_tab_btn_size.height - 4,  --相对列表top的间距
	right=0, 
	bottom=0
	} --列表背景相对底板的间距
local _list_bg_size = CCSize(  --列表背景面板尺寸 二层底板
    _listctrl_size.width - _list_bg_padding.left - _list_bg_padding.right, 
    _listctrl_size.height - _list_bg_padding.top - _list_bg_padding.bottom) 
local _list_bg_pos = CCPoint(_list_bg_padding.left, _list_bg_padding.bottom) --列表背景面板底部位置 二层底板

local _list_header_padding = {left=5, top=5, right=5} --列表头top间距
local _list_header_size = CCSize(_list_bg_size.width-_list_header_padding.left-_list_header_padding.right, 32) --列表头尺寸
local _list_row_size = CCSize(380, 104) --列表行尺寸

local info_tab_zhenpin 	= nil;	--珍品记录
local info_tab_tanbao 	= nil;	--探宝状况

local zhenpin_bg 		= nil;	--珍品块
local tanbao_bg 		= nil;	--探宝块

local zhenpin_scroll 	= nil;	--珍品滑动列表
local tanbao_scroll 	= nil;	--珍品滑动列表

local font_size = 16

local _slot_size = CCSize(79, 79) --物品格尺寸
local _slot_padding = {left=40,	top=(_list_row_size.height-_slot_size.height)/2} --物品格间距


--local _scrollbar_size=CCSize()

local scroll_bg_padding = {left=7, top=1, right=7, bottom=7}
local scroll_bg_size = CCSize(
		_list_bg_size.width-scroll_bg_padding.left-scroll_bg_padding.right,
		_list_bg_size.height-_list_header_padding.top-_list_header_size.height-scroll_bg_padding.top-scroll_bg_padding.bottom)
local scroll_bg_pos = CCPointMake(scroll_bg_padding.left, scroll_bg_padding.bottom)

local scroll_bg_padding2 =  {left=7, top=7, right=7, bottom=7}
local scroll_bg_size2 = CCSize(
		_list_bg_size.width-scroll_bg_padding2.left-scroll_bg_padding2.right,
		_list_bg_size.height-scroll_bg_padding2.top-scroll_bg_padding2.bottom)
local scroll_bg_pos2 = CCPointMake(scroll_bg_padding2.left, scroll_bg_padding2.bottom)


local header_pos = CCPointMake(
		(_list_bg_size.width-_list_header_size.width)/2, 
		_list_bg_size.height-_list_header_padding.top-_list_header_size.height)
local _list_header_col1_horcenter = scroll_bg_padding.left + _slot_padding.left + _slot_size.width/2 --第二列的x坐标

--local _list_header_col2_padding = {right=100}
local _list_header_col2_horcenter = _list_bg_size.width - 121 --第二列的x坐标


local _list_panel = nil

local _list_row_size2 = CCSize(390, 50) --探宝状况 列表行尺寸

local _list_line_padding={left=5, right=5} --分割线的间距
local split_line_size = CCSize(_list_row_size.width-_list_line_padding.left-_list_line_padding.right, 3)
local split_line_pos = CCPointMake(_list_line_padding.left, 0)

local split_line_size2 = CCSize(_list_row_size2.width-_list_line_padding.left-_list_line_padding.right, split_line_size.height)

local _list_item_col1_pos = CCPointMake(_list_header_col1_horcenter, (_list_row_size.height-_slot_size.height)/2)
local _list_item_col2_pos = CCPointMake(_list_header_col2_horcenter, _list_row_size.height/2)

local _list_header_col1_pos = CCPointMake(_list_item_col1_pos.x+6, _list_header_size.height/2+2)
local _list_header_col2_pos = CCPointMake(_list_item_col2_pos.x+6, _list_header_size.height/2+2)


local _scrollbar={
	size = CCSize(12, scroll_bg_size.height), --尺寸
	slider={ --滑块
		size = CCSize(10, 10), --滑块尺寸
		--padding={left=2, top=2, right=2, bottom=2},
		--size=CCSize(_scrollbar.size.width-padding.left-padding.right,	22)
	},
	upbar={
		padding={left=0, top=0, right=0},
		size=CCSize(12, 12)
	},
	downbar={
		padding={left=0, right=0, bottom=0},
		size=CCSize(12, 12)
	},
}

--关闭按钮
local function info_close_fun( eventType,x,y )
	
	if eventType == TOUCH_BEGAN then
		return true
	elseif eventType == TOUCH_CLICK then
		 
		UIManager:hide_window("dreamland_info_win");
		 if UIManager:find_visible_window("dreamland_cangku_win") == false then
            UIManager:show_window("dreamland_cangku_win");
        end
		return true
	end
	return true
end

function DreamlandInfoWin:show_zhenpin_view( bool )
	if bool then
		--info_tab_zhenpin_lab:setTexture( UIPIC_DREAMLAND_017 );
		--info_tab_tanbao_lab:setTexture( UIPIC_DREAMLAND_032 );
		info_tab_zhenpin:setCurState(CLICK_STATE_DISABLE);
		info_tab_tanbao:setCurState(CLICK_STATE_UP);
	else
		--info_tab_tanbao_lab:setTexture( UIPIC_DREAMLAND_018 );
		--info_tab_zhenpin_lab:setTexture( UIPIC_DREAMLAND_031 );
		info_tab_zhenpin:setCurState(CLICK_STATE_UP);
		info_tab_tanbao:setCurState(CLICK_STATE_DISABLE);
	end
	zhenpin_bg:setIsVisible(bool);
	tanbao_bg:setIsVisible(not bool);
end

--珍品列表
local function zhenpin_tab_event( eventType,x,y)

	if eventType == TOUCH_BEGAN then
		return true
	elseif eventType == TOUCH_CLICK then
		DreamlandInfoWin:show_zhenpin_view(true);
		return true
	end
	return true
end
--探宝情况
local function tanbao_tab_event( eventType,x,y)

	if eventType == TOUCH_BEGAN then
		return true
	elseif eventType == TOUCH_CLICK then
		DreamlandInfoWin:show_zhenpin_view(false);
		return true
	end
	return true
end


--获取珍品记录的callback
function DreamlandInfoWin:zhenpin_jilu_callback(  )
 
	local zhenpin_model = DreamlandModel:get_zhenpin_table()
	local count = #zhenpin_model;
	if #zhenpin_model > 0 then
		zhenpin_scroll:clear();
		zhenpin_scroll:setMaxNum(count);
		zhenpin_scroll:refresh();
	end
end

function DreamlandInfoWin:active( show )
	-- body
	if show then
		self:show_zhenpin_view(true);

		DreamlandModel:req_zhenpin_jilu(  )
	else
		if UIManager:find_visible_window("dreamland_cangku_win") == false then
            UIManager:show_window("dreamland_cangku_win");
        end
	end
end


function DreamlandInfoWin:initPanel( self_panel )

	_list_panel = CCBasePanel:panelWithFile(_listctrl_pos.x, _listctrl_pos.y, _listctrl_size.width, _listctrl_size.height, "")
	self_panel:addChild(_list_panel)

	--珍品记录 96 ->110 42->45
	info_tab_zhenpin = CCNGBtnMulTex:buttonWithFile(
		_tab_btn_pos.x, _tab_btn_pos.y, _tab_btn_size.width, _tab_btn_size.height, UIPIC_DREAMLAND.tab_gray);
	_list_panel:addChild(info_tab_zhenpin)
	info_tab_zhenpin:addTexWithFile(CLICK_STATE_DISABLE, UIPIC_DREAMLAND.tab_light)
	info_tab_zhenpin:registerScriptHandler(zhenpin_tab_event)	
	
	-- 按钮文字  70 18  -> -1 -1
	--info_tab_zhenpin_lab = CCZXImage:imageWithFile(12, 12, -1, -1, UIPIC_DREAMLAND_031)	
	info_tab_zhenpin_lab = MUtils:create_zxfont(info_tab_zhenpin, Lang.dreamland_info.zhenpin_record.tab_text, _tab_btn_size.width/2, _tab_btn_size.height/2, ALIGN_CENTER, font_size)
    info_tab_zhenpin_lab:setAnchorPoint(CCPointMake(0, 0.5))

	--info_tab_zhenpin:addChild(info_tab_zhenpin_lab)
	


	--探宝情况
	info_tab_tanbao = CCNGBtnMulTex:buttonWithFile(
		_tab_btn_pos.x+_tab_btn_size.width, _tab_btn_pos.y, _tab_btn_size.width, _tab_btn_size.height, UIPIC_DREAMLAND.tab_gray);
	_list_panel:addChild(info_tab_tanbao)
	info_tab_tanbao:addTexWithFile(CLICK_STATE_DISABLE, UIPIC_DREAMLAND.tab_light);
	info_tab_tanbao:registerScriptHandler(tanbao_tab_event);
	
	-- 按钮文字
    --info_tab_tanbao_lab = CCZXImage:imageWithFile(12, 12, -1, -1, UIPIC_DREAMLAND_032)
	info_tab_tanbao_lab = MUtils:create_zxfont(info_tab_tanbao, Lang.dreamland_info.tanbao_state.tab_text, _tab_btn_size.width/2, _tab_btn_size.height/2, ALIGN_CENTER, font_size)
    info_tab_tanbao_lab:setAnchorPoint(CCPointMake(0, 0.5))
	--info_tab_tanbao:addChild(info_tab_tanbao_lab)

	--
	-- local radio_button = RadioButton:create( nil, 46, 506+35, 100 * 2, 42 )
	-- radio_button.view:addGroup( info_tab_zhenpin, false )
	-- radio_button.view:addGroup( info_tab_tanbao, false )
	-- self_panel:addChild( radio_button.view )

	--创建珍品列表
	DreamlandInfoWin:create_zhenpin(_list_panel);
	--创建探宝列表
	DreamlandInfoWin:create_tanbao(_list_panel);
end



function DreamlandInfoWin:create_zhenpin( self_panel )
	-- 九宫格底图
	--local zhenpin_bg_size = CCSize(_list_bg_size.width, _list_bg_size.height)
	zhenpin_bg = CCBasePanel:panelWithFile(_list_bg_pos.x, _list_bg_pos.y, _list_bg_size.width, _list_bg_size.height, UILH_COMMON.normal_bg_v2, 500, 500)
	self_panel:addChild(zhenpin_bg)
	

	--标题底色
	
	local list_header = CCBasePanel:panelWithFile(
		header_pos.x,header_pos.y-5,_list_header_size.width,_list_header_size.height, UILH_NORMAL.title_bg4,500,500);
	zhenpin_bg:addChild(list_header)
	--list_header:setIsVisible(false)

	local zhenpin_lab_pos = CCPointMake(_list_header_col1_pos.x, _list_header_col1_pos.y - font_size/2)
	local zhenpin_lab = CCZXLabel:labelWithTextS(zhenpin_lab_pos,Lang.dreamland_info.zhenpin_record.zhenpin, font_size, ALIGN_CENTER); -- [881]="#cfff000珍品"
	--zhenpin_lab:setAnchorPoint(CCPointMake(0.5, 0.5))
	list_header:addChild(zhenpin_lab)
	local xianyou_lab_pos = CCPointMake(_list_header_col2_pos.x, _list_header_col2_pos.y - font_size/2)
	local xianyou_lab = CCZXLabel:labelWithTextS(xianyou_lab_pos, Lang.dreamland_info.zhenpin_record.xingyunrenzhe, font_size, ALIGN_CENTER); -- [882]="#cfff000幸运仙友"
	--xianyou_lab:setAnchorPoint(CCPointMake(0.5, 0.5))
	list_header:addChild(xianyou_lab)

	
	
	local scroll_bg = CCBasePanel:panelWithFile(scroll_bg_pos.x,scroll_bg_pos.y,
		scroll_bg_size.width, scroll_bg_size.height, UIPIC_DREAMLAND.bottom_bg, 500, 500)
	zhenpin_bg:addChild(scroll_bg)


	local _scroll_info = { 
		x = 0, 
		y = _scrollbar.downbar.size.height, 
		width = scroll_bg_size.width-_scrollbar.size.width, 
		height = scroll_bg_size.height-_scrollbar.upbar.size.height-_scrollbar.downbar.size.height, 
		maxnum = 0, 
		nil, 
		stype = TYPE_HORIZONTAL 
	}
	zhenpin_scroll = CCScroll:scrollWithFile( 
		_scroll_info.x, 
		_scroll_info.y, 
		_scroll_info.width, 
		_scroll_info.height, 
		_scroll_info.maxnum, 
		_scroll_info.image, 
		_scroll_info.stype, 
		500, 500 )
	zhenpin_scroll:setScrollLump(UIPIC_DREAMLAND.scrollbar_move, UIPIC_DREAMLAND.scrollbar_bg, _scrollbar.size.width, _scrollbar.size.height, _scrollbar.slider.size.height)

	local scrollbar_uparrow_pos = CCPointMake(scroll_bg_size.width-_scrollbar.upbar.padding.right, _scrollbar.size.height-_scrollbar.upbar.padding.top)
	local scrollbar_uparrow=ZImage:create(
		scroll_bg, UIPIC_DREAMLAND.scrollbar_up, 
		scrollbar_uparrow_pos.x, scrollbar_uparrow_pos.y, _scrollbar.upbar.size.width, _scrollbar.upbar.size.height)
	scrollbar_uparrow:setAnchorPoint(1, 1)

	local scrollbar_downarrow_pos = CCPointMake(scroll_bg_size.width-_scrollbar.downbar.padding.right, 0+_scrollbar.downbar.padding.bottom)
	local scrollbar_downarrow=ZImage:create(
		scroll_bg, UIPIC_DREAMLAND.scrollbar_down, 
		scrollbar_downarrow_pos.x, scrollbar_downarrow_pos.y, _scrollbar.downbar.size.width, _scrollbar.downbar.size.height)
	scrollbar_downarrow:setAnchorPoint(1, 0)

	local slot_width = _slot_size.width
    local slot_height = _slot_size.height

	local function scrollfun(eventType, arg, msgid)
		if eventType == nil or arg == nil or msgid == nil then
			return false
		end

		local temparg = Utils:Split(arg,":")
		local row = temparg[1]	--列数
		-- local ver = temparg[2]	--行数
		if row == nil then 
			return false;
		end
		--间距大小
		if eventType == SCROLL_CREATE_ITEM then
			local row_panel = CCBasePanel:panelWithFile(0, 0, _list_row_size.width, _list_row_size.height, nil)
			zhenpin_scroll:addItem(row_panel)

			local zhenpin_table_model = DreamlandModel:get_zhenpin_table();
			
			local zhenpin_item_model = zhenpin_table_model[row+1];
			
			--珍品点击的事件
			local function zhenpin_item_event( )
				TipsModel:show_shop_tip( 400,240, zhenpin_item_model.item_id,TipsModel.LAYOUT_LEFT );
			end



			local slot_item = MUtils:create_slot_item2(row_panel,
				UIPIC_DREAMLAND.slot_item,
				_list_item_col1_pos.x,
				_list_item_col1_pos.y,
				_slot_size.width, 
				_slot_size.height,
				zhenpin_item_model.item_id,
				zhenpin_item_event,
				0 --外框扩展偏移
				)
			slot_item.view:setAnchorPoint(0.5, 0)

			--仙友名字
			local name_str = string.format("#cffffff%s", tostring(zhenpin_item_model.user_name));

		  	local xianyou_name = TextButton:create(nil, _list_item_col2_pos.x, _list_item_col2_pos.y, 100, 20, name_str);
		  	xianyou_name:setFontSize(font_size)
		  	xianyou_name.view:setAnchorPoint(0.5, 0.5)
		  	row_panel:addChild(xianyou_name.view);

		  	local user_data = {
			  	roleId = zhenpin_item_model.user_id,
			  	roleName = zhenpin_item_model.user_name, 
			  	level = zhenpin_item_model.user_level, 
			  	camp = zhenpin_item_model.user_camp,
			  	job = zhenpin_item_model.user_job,
			  	sex = zhenpin_item_model.user_sex, 
			  	qqvip = zhenpin_item_model.qqVip
			};
		  	
		  	local function show_left_click_menu(  )
		  		if EntityManager:get_player_avatar().id ~= user_data.roleId then
		  			LeftClickMenuMgr:show_left_menu( "chat_other_list_menu" ,user_data);
		  		end
		  	end
		  	xianyou_name:setTouchClickFun(show_left_click_menu);

		  	--珍品列表分割线
		  	
		  	local split_line = ZImage:create(row_panel, UIPIC_DREAMLAND.split_line, split_line_pos.x, split_line_pos.y, split_line_size.width, split_line_size.height)
			
			zhenpin_scroll:refresh()
			
		end
		return true
	end
	zhenpin_scroll:registerScriptHandler(scrollfun)
	zhenpin_scroll:refresh()
	scroll_bg:addChild(zhenpin_scroll);
	
end

--探宝的回调
function DreamlandInfoWin:tanbao_callback( item_table )
	-- print("DreamlandInfoWin:tanbao_callback-",#item_table);
	local count = #item_table;
	if count > 0 then
		self:show_zhenpin_view(false);
		tanbao_scroll:clear();
		tanbao_scroll:setMaxNum(count);
		tanbao_scroll:refresh();

		-- 刷新珍品记录
		DreamlandModel:req_zhenpin_jilu(  )
	end
	
end

--探宝情况模块
function DreamlandInfoWin:create_tanbao(self_panel )
	-- 九宫格底图
	tanbao_bg = CCBasePanel:panelWithFile(_list_bg_pos.x, _list_bg_pos.y, _list_bg_size.width, _list_bg_size.height,UILH_COMMON.normal_bg_v2,500,500);
	self_panel:addChild(tanbao_bg);

	local scroll_bg = CCBasePanel:panelWithFile(scroll_bg_pos2.x+5,scroll_bg_pos2.y+5,
		scroll_bg_size2.width-15, scroll_bg_size2.height-10,UILH_COMMON.bg_10,500,500);
	tanbao_bg:addChild(scroll_bg)
	
	--探宝滑动列表
	--tanbao_scroll = CCScroll:scrollWithFile(0, 10, 339, 290, 8, 1, 0, NULL, TYPE_VERTICAL);
	--tanbao_scroll:setEnableCut(true)
	local _scroll_info = { 
		x = 0, 
		y = 5, 
		width = scroll_bg_size2.width-10, 
		height = scroll_bg_size2.height-20, 
		maxnum = 0, 
		image = "", 
		stype = TYPE_HORIZONTAL 
	}
	tanbao_scroll = CCScroll:scrollWithFile( 
		_scroll_info.x, 
		_scroll_info.y, 
		_scroll_info.width-13, 
		_scroll_info.height, 
		_scroll_info.maxnum, 
		"",
		 _scroll_info.stype )

	tanbao_scroll:setScrollLump(UIPIC_DREAMLAND.scrollbar_move, UIPIC_DREAMLAND.scrollbar_bg, _scrollbar.size.width, _scrollbar.size.height, _scrollbar.slider.size.height)

	-- local scrollbar_uparrow_pos = CCPointMake(scroll_bg_size.width-_scrollbar.upbar.padding.right, _scrollbar.size.height-_scrollbar.upbar.padding.top)
	local scrollbar_uparrow=ZImage:create(
		scroll_bg, UIPIC_DREAMLAND.scrollbar_up, 
		_scroll_info.width-1, _scroll_info.height+10, _scrollbar.upbar.size.width, _scrollbar.upbar.size.height, 1)
	scrollbar_uparrow:setAnchorPoint(1, 1)

	-- local scrollbar_downarrow_pos = CCPointMake(scroll_bg_size.width-_scrollbar.downbar.padding.right, 0+_scrollbar.downbar.padding.bottom)
	local scrollbar_downarrow=ZImage:create(
		scroll_bg, UIPIC_DREAMLAND.scrollbar_down, 
		_scroll_info.width-1, 0, _scrollbar.downbar.size.width, _scrollbar.downbar.size.height, 1)
	scrollbar_downarrow:setAnchorPoint(1, 0)

	local function scrollfun(eventType, arg, msgid)
		if eventType == nil or arg == nil or msgid == nil then
			return false
		end

		local temparg = Utils:Split(arg,":")
		local row = temparg[1]	--列数
		
		if row == nil then 
			return false;
		end

		if eventType == TOUCH_BEGAN then
			return true
		elseif eventType == TOUCH_MOVED then
			return true
		elseif eventType == TOUCH_ENDED then
			return true
		elseif eventType == SCROLL_CREATE_ITEM then
			local basepanel = CCBasePanel:panelWithFile(0, 0, _list_row_size2.width, _list_row_size2.height, nil, 500, 500)
		  
			local item_table = DreamlandModel:get_item_table();

			if #item_table > 0 then
				--动态model数据
				local item = item_table[row+1];
				 
				--查询item的静态配置
				local item_config = ItemConfig:get_item_by_id(item.id);
				
				--item名字
				local color = "#c"..ItemConfig:get_item_color(item_config.color+1);
				local item_str = string.format(color..LangGameString[883], tostring(item_config.name)); -- [883]="【%s】"
				--item名字lab
				local item_lab = CCZXLabel:labelWithTextS(CCPointMake(5, (_list_row_size2.height-font_size)/2), item_str, font_size, ALIGN_LEFT);
			  	basepanel:addChild(item_lab);

			  	--item数量
				local count_str = string.format("#cffffffx%d", item.count);
				local count_lab = CCZXLabel:labelWithTextS(CCPointMake(226+30,(_list_row_size2.height-font_size)/2),count_str, font_size, ALIGN_CENTER);
			  	basepanel:addChild(count_lab);

			  	--探宝分割线
			  	local split_line2 = ZImage:create(basepanel, UIPIC_DREAMLAND.split_line, split_line_pos.x, split_line_pos.y, split_line_size2.width, split_line_size2.height)
			end
			tanbao_scroll:addItem(basepanel)
			tanbao_scroll:refresh()
			return true
		end
	end
	tanbao_scroll:registerScriptHandler(scrollfun)
	tanbao_scroll:refresh()
	scroll_bg:addChild(tanbao_scroll);
end

function DreamlandInfoWin:__init(texture_name )
	-- body
	self:initPanel(self.view);
end

-- -- 创建函数
-- function DreamlandInfoWin:create(texture_name)
	
-- 	return DreamlandInfoWin(texture_name,404,50,389,429);
-- end

function DreamlandInfoWin:getwinname()
	return _window_name
end