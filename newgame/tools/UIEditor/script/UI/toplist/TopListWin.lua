------------------------------
------------------------------
----HJH
----2013-2-27
----排行榜界面
------------------------------
super_class.TopListWin(NormalStyleWindow)
local _refresh_time = 10
local _cur_page_select = 1
local _cur_panel = nil
------------------------------
------------------------------
local function create_top_list_panel(self, width, height)
	------------------------------
	local _window_size 		= {width = 900, height = 635}
	--local _title_info 		= {width = 260, height = 44, image_bg = nil, image = UIPOS_TopListWin_006 }
    
    --第二层底板
	local panel = CCBasePanel:panelWithFile( 10, 15, 880, 513,UILH_COMMON.normal_bg_v2, 500, 500 )
	self:addChild(panel)

	-- 整个tabview(标题栏)的坐标
	local _radio_button_info = {x = 20, y = 520, width = 820, height = 45}

	--标题资源
	local _radio_item_info 	= {width = -1, height = -1, 
		image_bg = {UILH_COMMON.tab_gray, UILH_COMMON.tab_light}
		 }
		 
		--local _exit_info= {width = 62, height = 56, image = {UIPOS_TopListWin_009, UIPOS_TopListWin_009} 
	--}
	self._radio_item_info = _radio_item_info


	local _notic_label_info = {x = 136, y = 42, text = Lang.topList[1]} -- [2118]="#cdc58ae排行榜数据每30分钟刷新一次"

	--我的排行 按钮数据
	local _my_toplist_info = {x = 75, y = 55, width = -1, height = -1, text = Lang.topList[4],
	 image = {UILH_COMMON.lh_button_4_r, UILH_COMMON.lh_button_4_r} } -- [2119]="我的排名"

	-- 所有标签页只有一个左右地板
	-- 左面板背景
	local _left_bg_info = { x = 25, y =28, width = 220, height = 485, image = UILH_COMMON.bottom_bg}
	
	-- 右面板背景
	local _right_bg_info = { x = 248, y =28, width = 627, height = 485, image = UILH_COMMON.bottom_bg}

	-- 我的排行榜
	local _my_toplist_panel_info = { width = 425, height = 540, image =UIPOS_TopListWin_0018 }
	------------------------------
	require "UI/toplist/PersonalAbilityList"
	require "UI/toplist/WingList"
	require "UI/toplist/PetList"
	require "UI/toplist/FlowerList"
	require "UI/toplist/BattleList"
	require "UI/toplist/MyTopList"

	local temp_list_info = { texture = "", x = 35, y = 40, width = 890, height = 520}

	-- btn_size 101, 45
	------------------------------个人实力按钮  页面
	local personal_button = ZTextButton:create( nil, "", _radio_item_info.image_bg, nil, 0, 0, _radio_item_info.width, _radio_item_info.height)
	personal_button:setTouchClickFun(function () self:personal_button_click_fun() end)
	--personal_button:setTouchClickFun(TopListWin.personal_button_click_fun)
	ZLabel:create( personal_button, Lang.topList.title_info[1], 101*0.5, (45-16)*0.5-2, 16, ALIGN_CENTER )
	self.personal_list = PersonalAbilityList( "PersonalAbilityList", temp_list_info.texture,true,temp_list_info.width,temp_list_info.height)
	self.personal_list.view:setIsVisible(true)


	------------------------------灵气翅膀按钮
	local wing_button = ZTextButton:create( nil, "", _radio_item_info.image_bg, nil, 0, 0, _radio_item_info.width, _radio_item_info.height)
	--wing_button:setTouchClickFun(TopListWin.wing_button_click_fun)
	ZLabel:create( wing_button, Lang.topList.title_info[2], 101*0.5, (45-16)*0.5-2, 16, ALIGN_CENTER )
	wing_button:setTouchClickFun(function () self:wing_button_click_fun() end)
	self.wing_list = WingList( "WingList", temp_list_info.texture,true,temp_list_info.width,temp_list_info.height)
	self.wing_list.view:setIsVisible(true)


	------------------------------宠物坐骑按钮
	local pet_button = ZTextButton:create( nil, "", _radio_item_info.image_bg, nil, 0, 0, _radio_item_info.width, _radio_item_info.height)
	--pet_button:setTouchClickFun(TopListWin.pet_button_click_fun)
	ZLabel:create( pet_button, Lang.topList.title_info[3], 101*0.5, (45-16)*0.5-2, 16, ALIGN_CENTER )
	pet_button:setTouchClickFun(function () self:pet_button_click_fun() end)
	self.pet_list = PetList( "PetList", temp_list_info.texture,true,temp_list_info.width,temp_list_info.height )
	self.pet_list.view:setIsVisible(false)


	------------------------------鲜花魅力按钮
	local flower_button = ZTextButton:create( nil, "", _radio_item_info.image_bg, nil, 0, 0, _radio_item_info.width, _radio_item_info.height)
	--flower_button:setTouchClickFun(TopListWin.flower_button_click_fun)
	ZLabel:create( flower_button, Lang.topList.title_info[4], 101*0.5, (45-16)*0.5-2, 16, ALIGN_CENTER )
	flower_button:setTouchClickFun(function () self:flower_button_click_fun() end)
	self.flower_list = FlowerList( "FlowerList", temp_list_info.texture,true,temp_list_info.width,temp_list_info.height )
	self.flower_list.view:setIsVisible(false)


	------------------------------战场排行按钮
	local battle_button = ZTextButton:create( nil, "", _radio_item_info.image_bg, nil, 0, 0, _radio_item_info.width, _radio_item_info.height)
	ZLabel:create( battle_button, Lang.topList.title_info[5], 101*0.5, (45-16)*0.5-2, 16, ALIGN_CENTER )
	battle_button:setTouchClickFun(function () self:battle_button_click_fun() end)
	self.battle_list = BattleList( "BattleList", temp_list_info.texture,true,temp_list_info.width,temp_list_info.height )
	self.battle_list.view:setIsVisible(false)


	------------------------------tagview 标题栏-------------------------------
	self.radio_button = ZRadioButtonGroup:create( nil, _radio_button_info.x, _radio_button_info.y, _radio_button_info.width, _radio_button_info.height)
	self.radio_button:addItem( personal_button)
	self.radio_button:addItem( wing_button,1)
	self.radio_button:addItem( pet_button,1)
	self.radio_button:addItem( flower_button,1)
	self.radio_button:addItem( battle_button,1)
	self.radio_button:selectItem(0)
	self:change_btn_name(1)

	------------------------------退出按钮
	-- self.exit_button = ZButton:create( nil, _exit_info.image, nil, 0, 0, -1, -1)
	-- local exit_size = self.exit_button:getSize()
	-- self.exit_button:setPosition( width - exit_size.width, height - exit_size.height )
	-- self.exit_button:setTouchClickFun(TopListWin.exit_button_click_fun)


	------------------------------
	self.notic_label = ZLabel:create( nil, _notic_label_info.text, _notic_label_info.x, _notic_label_info.y, 16, ALIGN_CENTER )

	------------------------------我的排名按钮
	self.my_top_list_button = ZTextButton:create( nil, _my_toplist_info.text, _my_toplist_info.image, nil, _my_toplist_info.x, _my_toplist_info.y, _my_toplist_info.width, _my_toplist_info.height, nil, _window_size.width, _window_size.height)
	self.my_top_list_button:setTouchClickFun(TopListModel.my_top_list_click_fun)
	------------------------------
	self.left_bg = ZImage:create( nil, _left_bg_info.image, _left_bg_info.x, _left_bg_info.y, _left_bg_info.width, _left_bg_info.height, nil, _window_size.width, _window_size.width )

	self.right_bg = ZImage:create( nil, _right_bg_info.image, _right_bg_info.x, _right_bg_info.y, _right_bg_info.width, _right_bg_info.height, nil, _window_size.width, _window_size.width )

	-- 标题栏背景
	-- self.right_title_bg = CCBasePanel:panelWithFile(300-10, 460-6, 555 + 20,42,UIPOS_TopListWin_0017, 500, 500 )
	self.right_title_bg = CCBasePanel:panelWithFile(_right_bg_info.x+9, 474, _right_bg_info.width-19,-1,UILH_NORMAL.title_bg4, 500, 500 )

	------------------------------我的排行界面
	local _refWidth =  UIScreenPos.relativeWidth
	local _refHeight = UIScreenPos.relativeHeight
	local my_top_panel_info = { texture =  _my_toplist_panel_info.image, x = (_refWidth(1.0) - _my_toplist_panel_info.width) / 2, y = _refHeight(1.0) / 2, 
	width = _my_toplist_panel_info.width, height =  _my_toplist_panel_info.height}
	self.my_top_list = MyTopList("MyTopList", "",true, my_top_panel_info.width,my_top_panel_info.height )


	self.my_top_list.view:setIsVisible(false)
	self.my_top_list:setAnchorPoint(0.5,0.5)
	self.my_top_list:setPosition( width/2, height/2 )
	------------------------------
	---添加上方标题按钮
	self.view:addChild( self.radio_button.view )

	self.view:addChild( self.left_bg.view )
	self.view:addChild( self.right_bg.view )
	self.view:addChild( self.right_title_bg )
	self.view:addChild( self.personal_list.view )
	self.view:addChild( self.wing_list.view )
	self.view:addChild( self.pet_list.view )
	self.view:addChild( self.flower_list.view )
	self.view:addChild( self.battle_list.view )
	
	--self.view:addChild( self.exit_button.view )
	self.view:addChild( self.notic_label.view )
	self.view:addChild( self.my_top_list_button.view )
	self.view:addChild( self.my_top_list.view )
	TopListModel:my_top_list_click_fun()
end
------------------------------
-- function Window:__init( window_name, texture_name, is_grid, width, height )

function TopListWin:__init(window_name, texture_name,is_grid, width, height)

	create_top_list_panel( self, width, height )

	-- local function panel_function(eventType, arg, msgId, selfItem)
	-- 	if eventType == nil or arg == nil or msgId == nil or selfItem == nil then
	-- 		return
	-- 	end
	-- 	if eventType == TIMER then
	-- 		TopListModel:check_need_clear_all_top_list_info()
	-- 	end
	-- 	return true
	-- end
	-- self.view:setTimer(_refresh_time)
	-- self.view:registerScriptHandler(panel_function)
	_cur_panel = self
end
------------------------------
function TopListWin:reinit_all_scroll()
	self.personal_list.scroll.view:reinitScroll()
	self.wing_list.scroll.view:reinitScroll()
	self.pet_list.scroll.view:reinitScroll()
	self.flower_list.scroll.view:reinitScroll()
	self.battle_list.scroll.view:reinitScroll()
	local temp_scroll_info = { self.personal_list, self.wing_list, self.pet_list, self.flower_list, self.battle_list }
	temp_scroll_info[ _cur_page_select ]:reinit_scroll()
end
------------------------------清除指定滑动条信息
function TopListWin:clear_index_scroll(index)
	--print("run clear_index_scroll index",index)
	if index == TopListConfig.TopListType.Fight or index == TopListConfig.TopListType.Level or index == TopListConfig.TopListType.Lg or index == TopListConfig.TopListType.Achieve then
		--print("clear personal_list scroll")
		self.personal_list:clear_scroll()
	elseif index == TopListConfig.TopListType.Trump or index == TopListConfig.TopListType.Wing then
		-- print("clear wing_list scroll")
		self.wing_list:clear_scroll()
	elseif index == TopListConfig.TopListType.Pet or index == TopListConfig.TopListType.Mount then
		--print("clear pet_list scroll")
		self.pet_list:clear_scroll()
	elseif index == TopListConfig.TopListType.PerWeekCharm or index == TopListConfig.TopListType.Charm then
		--print("clear flower_list scroll")
		self.flower_list:clear_scroll()
	elseif index == TopListConfig.TopListType.FMSL then
		-- print("clear battle_list scroll")
		self.battle_list:clear_scroll()
	end
end
------------------------------刷新指定滑动栏
function TopListWin:refresh_index_scroll(index)
	--print("run refresh_index_scroll index",index)
	if index == TopListConfig.TopListType.Fight or index == TopListConfig.TopListType.Level or index == TopListConfig.TopListType.Lg or index == TopListConfig.TopListType.Achieve then
		--print("refresh personal_list scroll")
		self.personal_list:refresh_scroll()
	elseif index == TopListConfig.TopListType.Trump or index == TopListConfig.TopListType.Wing then
		--print("refresh wing_list scroll")
		self.wing_list:refresh_scroll()
	elseif index == TopListConfig.TopListType.Pet or index == TopListConfig.TopListType.Mount then
		--print("refresh pet_list scroll")
		self.pet_list:refresh_scroll()
	elseif index == TopListConfig.TopListType.PerWeekCharm or index == TopListConfig.TopListType.Charm then
		self.flower_list:refresh_scroll()
	elseif index == TopListConfig.TopListType.FMSL then
		self.battle_list:refresh_scroll()
	end
end

-----刷新指定排行榜
function TopListWin:refresh_panel(index)
	--print("TopListWin:refresh_panel(index)",index)
	if index == TopListConfig.TopListType.Fight then
		self.personal_list:personal_battle_button_click_fun()
	elseif index == TopListConfig.TopListType.Trump then
		self.wing_list:wing_trump_button_click_fun()
	elseif index == TopListConfig.TopListType.Pet then
		self.pet_list:pet_pet_button_click_fun()
	elseif index == TopListConfig.TopListType.PerWeekCharm then
		self.flower_list:flower_per_week_charm_button_click_fun()
	elseif index == TopListConfig.TopListType.FMSL then
		self.battle_list:battlelist_fmsl_button_click_fun()
	end
end
-- ------------------------------取得当前页下当前选取项
-- function TopListWin:get_index_scroll_page_num(index)
-- 	if index == TopListConfig.TopListType.Fight or index == TopListConfig.TopListType.Level or index == TopListConfig.TopListType.Lg or index == TopListConfig.TopListType.Achieve then
-- 		return self.personal_list.scroll:getCurPageNum()
-- 	elseif index == TopListConfig.TopListType.Trump or index == TopListConfig.TopListType.Wing then
-- 		return self.wing_list.scroll:getCurPageNum()
-- 	elseif index == TopListConfig.TopListType.Pet or index == TopListConfig.TopListType.Mount then
-- 		return self.pet_list.scroll:getCurPageNum()
-- 	elseif index == TopListConfig.TopListType.PerWeekCharm or index == TopListConfig.TopListType.Charm then
-- 		return self.flower_list.scroll:getCurPageNum()
-- 	elseif index == TopListConfig.TopListType.FMSL then
-- 		return self.battle_list.scroll:getCurPageNum()
-- 	end
-- end
------------------------------设置指定页滑动最大数量
function TopListWin:set_index_scroll_max_num(index, num)
	-- print("TopListWin:set_index_scroll_max_num index, num",index, num)
	if index == TopListConfig.TopListType.Fight or index == TopListConfig.TopListType.Level or index == TopListConfig.TopListType.Lg or index == TopListConfig.TopListType.Achieve then
		return self.personal_list:set_max_num(num)
	elseif index == TopListConfig.TopListType.Trump or index == TopListConfig.TopListType.Wing then
		return self.wing_list:set_max_num(num)
	elseif index == TopListConfig.TopListType.Pet or index == TopListConfig.TopListType.Mount then
		return self.pet_list:set_max_num(num)
	elseif index == TopListConfig.TopListType.PerWeekCharm or index == TopListConfig.TopListType.Charm then
		return self.flower_list:set_max_num(num)
	elseif index == TopListConfig.TopListType.FMSL then
		return self.battle_list:set_max_num(num)
	end
end
------------------------------
function TopListWin:destroy()
	Window.destroy(self)
	if self.personal_list ~= nil then
		self.personal_list:destroy()
	end
	if self.wing_list ~= nil then
		self.wing_list:destroy()
	end
	if self.pet_list ~= nil then
		self.pet_list:destroy()
	end
	if self.flower_list ~= nil then
		self.flower_list:destroy()
	end
	if self.battle_list ~= nil then
		self.battle_list:destroy()
	end
	if self.my_top_list ~= nil then
		self.my_top_list:destroy()
	end
end
------------------------------
function TopListWin:active(show)
	if show then
		-- print("run active")
		if TopListModel:get_init() == true then
			TopListModel:reinit_top_list_info()
		end
		-- self.view:setTimer(0)
		-- self.view:setTimer(_refresh_time)
		_cur_page_select=1
		-- self.radio_button:selectItem(_cur_page_select-1)

		local temp_list = { self.personal_list, self.wing_list, self.pet_list, self.flower_list, self.battle_list }
	
		self:set_index_show( _cur_page_select )
		--激活窗口默认在第一页
		temp_list[ _cur_page_select ]:personal_battle_button_click_fun()
		-- temp_list[ _cur_page_select ]:refresh_panel()
	-- else
	-- 	self.view:setTimer(0)
	end
end

--xiehande  点击按钮切换字体贴图
function TopListWin:change_btn_name( index )
	-- body
	for i,v in ipairs(self.radio_button.item_group) do
		if(i==index) then
          self.radio_button:getIndexItem(i-1).view:setTexture(UILH_COMMON.tab_light)
		else
          self.radio_button:getIndexItem(i-1).view:setTexture(UILH_COMMON.tab_gray)
		end
	end
end
--------------------------------------------------------
---------------个人实力按钮
function TopListWin:personal_button_click_fun()
	-- local top_list_win = UIManager:find_window("top_list_win")
	-- if top_list_win ~= nil then
	if _cur_page_select ~= 1 then
		_cur_page_select = 1
		_cur_panel:set_index_show(1)
		--xiehande 切换标签文字
		self:change_btn_name(1)
		-- _cur_panel:clear_index_scroll(TopListConfig.TopListType.Fight)
		-- _cur_panel:refresh_index_scroll(TopListConfig.TopListType.Fight)
		_cur_panel:refresh_panel(TopListConfig.TopListType.Fight)
	end
end
---------------灵器翅膀按钮
function TopListWin:wing_button_click_fun()
	-- local top_list_win = UIManager:find_window("top_list_win")
	-- if top_list_win ~= nil then
	-- print("TopListWin:wing_button_click_fun()")
	if _cur_page_select ~= 2 then
		_cur_page_select = 2
		_cur_panel:set_index_show(2)
		self:change_btn_name(2)
				-- _cur_panel:clear_index_scroll(TopListConfig.TopListType.Trump)
				-- _cur_panel:refresh_index_scroll(TopListConfig.TopListType.Trump)
				_cur_panel:refresh_panel(TopListConfig.TopListType.Trump)
	end
end
---------------宠物坐骑按钮
function TopListWin:pet_button_click_fun()
	-- local top_list_win = UIManager:find_window("top_list_win")
	-- if top_list_win ~= nil then
	if _cur_page_select ~= 3 then
		_cur_page_select = 3
		_cur_panel:set_index_show(3)
		self:change_btn_name(3)
		-- _cur_panel:clear_index_scroll(TopListConfig.TopListType.Pet)
		-- _cur_panel:refresh_index_scroll(TopListConfig.TopListType.Pet)
		_cur_panel:refresh_panel(TopListConfig.TopListType.Pet)
	end
end
---------------鲜花魅力按钮
function TopListWin:flower_button_click_fun()
	-- local top_list_win = UIManager:find_window("top_list_win")
	-- if top_list_win ~= nil then
	if _cur_page_select ~= 4 then
		_cur_page_select = 4
		_cur_panel:set_index_show(4)
		self:change_btn_name(4)
		-- _cur_panel:clear_index_scroll(TopListConfig.TopListType.Charm)
		-- _cur_panel:refresh_index_scroll(TopListConfig.TopListType.Charm)
		_cur_panel:refresh_panel(TopListConfig.TopListType.PerWeekCharm)
	end
end
---------------战场排行按钮
function TopListWin:battle_button_click_fun()
	--local top_list_win = UIManager:find_window("top_list_win")
	--if top_list_win ~= nil then
	if _cur_page_select ~= 5 then
		_cur_page_select = 5
		_cur_panel:set_index_show(5)
		self:change_btn_name(5)
		-- _cur_panel:clear_index_scroll(TopListConfig.TopListType.FMSL)
		-- _cur_panel:refresh_index_scroll(TopListConfig.TopListType.FMSL)
		_cur_panel:refresh_panel(TopListConfig.TopListType.FMSL)
	end
end
---------------排行榜退出按钮
-- function TopListWin:exit_button_click_fun()
-- 	UIManager:hide_window("top_list_win")
-- end
------------------------------设置指定页显隐
function TopListWin:set_index_show( index )
	local temp_list = { self.personal_list, self.wing_list, self.pet_list, self.flower_list, self.battle_list }
	for i = 1 , #temp_list do
		if i == index then
			temp_list[i].view:setIsVisible( true )
		else
			temp_list[i].view:setIsVisible( false )
		end
	end
end
-- 刷新指定排行榜的玩家个人名次
-----刷新指定排行榜
function TopListWin:reinit_info(info)
	-- self.personal_list:reinit_info()
	-- self.wing_list:reinit_info()
	-- self.pet_list:reinit_info()
	-- self.flower_list:reinit_info()
	-- self.battle_list:reinit_info()
end