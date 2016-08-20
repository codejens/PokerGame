--- HJH
--- 2013-4-12
--- 重写目标界面
super_class.GoalLeftPage(Window)
------------------
------------------
function GoalLeftPage:__init(window_name, window_info, rightpage )
    self.title = ImageImage:create( nil, 0, 0, window_info.width , 35, UIResourcePath.FileLocate.achieveAndGoal .. "text_1.png", 
    																   UIPIC_WINDOWS_BG, 600, 600 )
    local title_size = self.title:getSize()
    self.title:setPosition( 10, window_info.height - title_size.height - 10 )
    local title_pos = self.title:getPosition()
	------------------
	self.scroll = CCScroll:scrollWithFile( 0, 10  , window_info.width, 180, 1, "",TYPE_HORIZONTAL )
	local function scrollfun( eventType, arg, msgid, selfItem )
		local temp_page = rightpage
		------------------
		if eventType == nil or arg == nil or msgid == nil or selfItem == nil then
			return
		end
		------------------
		if eventType == TOUCH_BEGAN then
			return true
		elseif eventType == TOUCH_MOVED then
			return true
		elseif eventType == TOUCH_ENDED then
			return true
		elseif eventType == SCROLL_CREATE_ITEM then
			local index = Utils:Split(arg, ":")[1]
			------------------
			local goal_win = UIManager:find_window("goal_win")
			local curpage = 0
			if goal_win ~= nil then
				curpage = goal_win:get_cur_page()
			end
			local groupId = index + 1 + 6 + curpage
			local achieve_group = GlobalConfig:get_achieve_group( groupId )
			local len = #achieve_group
			local temp_item_info = {}
			local sum_height = 0
			for i = 1, len do 
				------------------
				local achieveId = achieve_group[ i ]
				local std_achieve = AchieveConfig:get_achieve( achieveId )
				local achieve = AchieveModel:getUserAchieve( achieveId )
				local str
				local ttype 
				------------------ 
				if achieve.hasGetAwards > 0 then
					str = "#c00c0ff" .. std_achieve.name .. LangGameString[1108] -- [1108]="(已获取)"
					ttype = 0
				elseif achieve.hasDone > 0 then
					str = "#c38ff33" .. std_achieve.name .. LangGameString[1109] -- [1109]="(已完成)"
					ttype = 1
				else 
					str = "#cff66cc" .. std_achieve.name .. LangGameString[1110] -- [1110]="(未完成)"
					ttype = 2
				end
				------------------
				local label = Label:create( nil, 40, 10, str, 15 )
				local label_size = label:getSize()
				local line = Image:create( nil, 0, 5, width, 2, UIResourcePath.FileLocate.common .. "fenge_bg.png" )
				local line_size = line:getSize()
				local image = ZButton:create( nil, {UIResourcePath.FileLocate.common .. "half_circle.png", UIResourcePath.FileLocate.common .. "list_select.png"}, nil, 0, 0, width, label_size.height + line_size.height + 15, nil, 900, 900)
				local image_size = image:getSize()
				local temp_panel = ZBasePanel:create( nil, nil, 0, 0, image_size.width, image_size.height )
				temp_panel:addChild( label )
				temp_panel:addChild( line )
				temp_panel:addChild( image )
				temp_panel.view:setDataInfo( tostring(achieveId) )
				sum_height = sum_height + image_size.height
				GoalModel:add_page_info( {achieveId = achieveId, ttype = ttype } )
				------------------
				local function click_fun()
					local temp_index = i
					local temp_page = index + 1
					GoalModel:add_page_item_info( temp_page, temp_index )
					GoalLeftPage:create_award_item(achieveId, rightpage)
				end
				image:setTouchBeganFun( click_fun )
				temp_item_info[i] = temp_panel
			end
			------------------
			self.add_panel = RadioButton:create( nil, 0, 0, width, sum_height, 1)
			for i = 1 , #temp_item_info do
				self.add_panel:addItem( temp_item_info[i], 10 )
			end
			------------------
			local curselect = GoalModel:get_page_item_info(tonumber(index) + 1)
			local curid = achieve_group[ curselect ]
			GoalLeftPage:create_award_item(curid, rightpage)
			------------------
			self.scroll:addItem( self.add_panel.view )
			self.scroll:refresh()
		end
	end
	self.scroll:registerScriptHandler(scrollfun)
	self.scroll:refresh()
	------------------
	self:addChild( self.title.view )
	self:addChild( self.scroll )
	------------------
end
------------------
function GoalLeftPage:init_right_info( rightpage, noticinfo, item, click_info, get_fun )
	local page_info = GoalModel:get_page_info( click_info )
	local image
	local click_state
	if page_info.ttype == 0 then
		image = UIResourcePath.FileLocate.normal .. "text_4.png"
		click_state = CLICK_STATE_DISABLE
	elseif page_info.ttype == 1 then
		image = UIResourcePath.FileLocate.normal .. "get_award.png"
		click_state = CLICK_STATE_UP
	elseif page_info.ttype == 2 then
		image = UIResourcePath.FileLocate.normal .. "get_award.png"
		click_state = CLICK_STATE_DISABLE
	end
	rightpage:init_page_info( noticinfo, item, image, click_state, get_fun )
end
------------------
function GoalLeftPage:create_award_item(id, rightpage)
	local click_info = id
	local std_achieve = AchieveConfig:get_achieve( click_info )
	local award_item = {}
	for i , award in ipairs( std_achieve.awards ) do
		if award.type == 0 then
			award_item[i] = SlotItem(62, 62) 
			award_item[i]:set_icon_bg_texture( UIPIC_ITEMSLOT , 0, 0, 62, 62 )
			award_item[i]:set_icon_ex( award.id )
			award_item[i]:set_icon_size( 48, 48 )
			local function fun()
				if award.id then
					TipsModel:show_shop_tip( 400, 240, award.id )
				end
			end
			award_item[i]:set_click_event( fun )
		elseif award.type == 5 then
			award_item[i] = ZLabel:create( nil, LangGameString[1111] .. award.count, 0, 0 ) -- [1111]="仙币×"
		elseif award.type == 7 then
			award_item[i] = ZLabel:create( nil, LangGameString[1112] .. award.count, 0, 0 ) -- [1112]="礼券×"
		end
	end
	------------------
	local function get_fun()
		local id = click_info
		-- label:setText("#c00c0ff" .. std_achieve.name .. "(已获取)")
		-- GoalModel:change_page_info( {achieveId = id, ttype = 0} )
		-- GoalLeftPage:init_right_info( rightpage, nil, nil, click_info, nil )
		AchieveCC:get_award( id )
	end
	------------------
	GoalLeftPage:init_right_info( rightpage, std_achieve.desc, award_item, click_info, get_fun )
	return award_item
end
