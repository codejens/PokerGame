----GuildAltarPagelua
----HJH
----2013-8-1
----
---仙宗神兽蛋
super_class.GuildAltarEggPage( Window )
local scroll_item_num = 3
--窗体大小
local window_width =880
local window_height = 520
function GuildAltarEggPage:create_left(container, x, y, width, height)
    
    local bgpanel  =  CCBasePanel:panelWithFile(x, y, width, height, UILH_COMMON.bottom_bg, 500, 500)
    container:addChild(bgpanel)
	--左上背景
	local bgPanel1 = CCBasePanel:panelWithFile(x, 138, width, 350, "", 500, 500)
	container:addChild(bgPanel1)

	--左下背景
	local bgPanel2 = CCBasePanel:panelWithFile(x, y, width, 130, "", 500, 500)
	container:addChild(bgPanel2)

    --军旗背景图
	local bg = CCZXImage:imageWithFile( 8, 9, 540,350 , "")
	local bg_left = CCZXImage:imageWithFile( 0, 0, -1, -1, UILH_GUILD.altar_bg )
	local bg_right = CCZXImage:imageWithFile( 268, 0, -1, -1, UILH_GUILD.altar_bg )
	bg_right:setFlipX(true)
	bg:addChild(bg_left,-1)
	bg:addChild(bg_right,-1)
	bgPanel1:addChild(bg)

    --星星
	local temp_page_info = GuildModel:get_guild_altar_egg_page_info()
    local gap = 55
	local temp_star_info = 
	{
	 { x = 25, y = 167, width = -1, height = -1, image =  UILH_OTHER.number2_1},
	 { x = 97, y = 167, width = -1, height = -1, image =  UILH_OTHER.number2_2 },
	 { x = 172, y = 167, width = -1, height = -1, image = UILH_OTHER.number2_3 },
	 { x = 244, y = 167, width = -1, height = -1, image = UILH_OTHER.number2_4 },
	 { x = 316, y = 167, width = -1, height = -1, image = UILH_OTHER.number2_5 },
	 { x = 390, y = 167, width = -1, height = -1, image = UILH_OTHER.number2_6},
	 { x = 465, y = 167, width = -1, height = -1, image = UILH_OTHER.number2_7 },

	}
	self.star_info = {}
	local star_index = temp_page_info.gem_index

	for i = 1, #temp_star_info do
		--星星/数字  背景
		local star_info_bg  =ZImage:create(self,UILH_NORMAL.skill_bg1,temp_star_info[i].x,temp_star_info[i].y,65,65,1)
		self.star_info[i] = ZImage:create( nil, temp_star_info[i].image, 22, 22, temp_star_info[i].width, temp_star_info[i].height )
		star_info_bg:addChild(self.star_info[i].view,100)
		if i < star_index then
			self.star_info[i].view:setCurState( CLICK_STATE_UP )
		else
			self.star_info[i].view:setCurState( CLICK_STATE_DISABLE )
		end
	end
    
    --进阶的进度背景
    local pro_left  =ZImage:create(self,UILH_NORMAL.progress_left,163,21,-1,-1,888)
    local pro_right  =ZImage:create(self,UILH_NORMAL.progress_left,500,21,-1,-1,888)
    pro_left.view:setScale(16/25)
    pro_right.view:setScale(16/25)
    pro_right.view:setFlipX(true)

    --数字后面的类似进度条背景
    self.pro_info = {}
    local temp_pro_info = {75,145,220,300,370,440}
    for i = 1,#temp_pro_info do 
        local pro_info_bg =ZImage:create(self,UILH_GUILD.pro_bg_down,temp_pro_info[i],184,-1,-1)
    	self.pro_info[i]=ZImage:create(nil,UILH_GUILD.pro_bg_up,0,4,-1,-1)
    	pro_info_bg:addChild(self.pro_info[i].view)
    	if i <star_index then
    		 self.pro_info[i].view:setIsVisible( true )
    	else
			self.pro_info[i].view:setIsVisible( false)
		end
    end
 

    --蛋 军旗
	self.egg = ZImage:create( nil, UILH_GUILD.pet_level_0 , 183, 81, -1, -1)
	bg:addChild(self.egg.view)

    --今日可祭旗次数
	self.today_num = ZLabel:create( nil, string.format( Lang.guild.guild_altar_info.today_touch_num, temp_page_info.touch_num ), 159, 324 )
	bg:addChild( self.today_num.view )

	-- self.my_today_num = ZLabel:create( nil, string.format( Lang.guild.guild_altar_info.my_today_touch_num, temp_page_info.my_touch_num ), 186, 222 )
	-- bg:addChild( self.my_today_num.view )


    --进度条
    self.process_bar = ZXProgress:createWithValueEx(0,200,340,16,UILH_NORMAL.progress_bg2,UILH_NORMAL.progress_bar,true);
	local max_process = GuildConfig:get_altar_gem_index_exp( star_index + 1 )
	self.process_bar:setProgressValue( temp_page_info.cur_process, max_process )
	self.process_bar:setPosition(CCPointMake(174,25));
	self:addChild(self.process_bar,999)


    


    --祭旗按钮  图片形式
	-- self.touch_btn = ZImageButton:create( nil, UILH_COMMON.btn4_nor, UIResourcePath.FileLocate.guild .. "touch.png", nil, 24, height - 302, 84, 38, nil, 600, 600 )
	-- bgPanel2:addChild(self.touch_btn.view)
	-- self.touch_btn:setTouchClickFun(GuildModel.guild_altar_touch_btn_fun)

	--文字形式
	 self.touch_btn = ZTextButton:create(bgPanel2,Lang.guild.guild_altar_info.junqi,UILH_COMMON.lh_button2, GuildModel.guild_altar_touch_btn_fun, 24, 41,-1,-1, 1)
	 self.touch_btn.view:addTexWithFile(CLICK_STATE_DOWN, UILH_COMMON.lh_button2_s)
	 self.touch_btn.view:addTexWithFile(CLICK_STATE_DISABLE, UILH_COMMON.lh_button2_disable)

	if temp_page_info.my_touch_num <= 0 then
		self.touch_btn.view:setCurState(CLICK_STATE_DISABLE)
	end

    --多行文本 所有军团成员....
	self.dialog_info = ZDialog:create(nil, nil, 160, 80, 350, 85 ,14)
	self.dialog_info.view:setAnchorPoint(0, 0.5)
	self.dialog_info:setText(LH_COLOR[2]..Lang.guild.guild_altar_info.touch_notic)
	bgPanel2:addChild( self.dialog_info.view )
end

function GuildAltarEggPage:create_right(container, x, y, width, height)
    


    --右边的底板
	local right_panel = CCBasePanel:panelWithFile( x, y, width, height, UILH_COMMON.bottom_bg, 500, 500 )
	container:addChild(right_panel)

    --表头
	local title_bg_1 = CCZXImage:imageWithFile( 2, height - 37, width-4, 31, UILH_NORMAL.title_bg4 )    
    right_panel:addChild( title_bg_1 )

    local time = UILabel:create_label_1(Lang.guild.guild_altar_info.time, CCSize(100,20), 45, 17, 16, CCTextAlignmentCenter, 255, 255, 255) -- [1184]="排名"
    title_bg_1:addChild( time )

    local event = UILabel:create_label_1(Lang.guild.guild_altar_info.event, CCSize(100,20), 198, 17, 16, CCTextAlignmentCenter, 255, 255, 255) -- [1184]="排名"
    title_bg_1:addChild( event )

    local scrollbar_up = ZImage:create(right_panel,UIPIC_DREAMLAND.scrollbar_up,282,440,-1,-1)
	self.scroll = ZScroll:create( nil, nil, 4, 15, width-20, height - 63, 1, TYPE_HORIZONTAL )
	right_panel:addChild(self.scroll.view)
	self.scroll:setScrollLump( 11, 10, 10 )
	self.scroll:setScrollCreatFunction( GuildAltarEggPage.scroll_item_fun )
	self.scroll:setFinishScrollFunction( GuildAltarEggPage.finish_scroll_fun )
	local scrollbar_down = ZImage:create(right_panel,UIPIC_DREAMLAND.scrollbar_down,283,6,-1,-1)

end
---------创建面板
function GuildAltarEggPage:__init(window_name, window_info)
	--整块页面底板
	local panel = self.view
	local bgPanel1 = CCBasePanel:panelWithFile(0, 0, window_width, window_height, UILH_COMMON.normal_bg_v2, 500, 500)
    panel:addChild(bgPanel1)
    --左边版面
	self:create_left(panel, 10, 15, 554, 490 )
	--右边版面
	self:create_right(panel, 563, 15, 298, 490 )
end
----------------------------------------------
function GuildAltarEggPage:create()
	return GuildAltarEggPage( "GuildAltarEggPage", "", false, 850, 490 )
end
----------------------------------------------
function GuildAltarEggPage:set_scroll_max_num(num)
	if self.scroll ~= nil then
		self.scroll.view:setMaxNum( num )
	end
end
----------------------------------------------
function GuildAltarEggPage:update_scroll_fun()
	local info = GuildModel:get_guild_altar_egg_page_info()
	-- if #info.altar_info < scroll_item_num and info.is_request_altar_info == false then
	-- 	GuildCC:client_send_get_xian_guo_info()	
	-- 	GuildModel:set_guild_altar_egg_page_is_request(true)
	-- end
	self.scroll:clear()
	self.scroll:setMaxNum( #info.altar_info )
	self.scroll:refresh()
end
----------------------------------------------
function GuildAltarEggPage:finish_scroll_fun()
	local page_info = GuildModel:get_guild_altar_egg_page_info()
	if os.time() - page_info.last_altar_info_refresh_time < page_info.max_altar_info_refresh_rate then
		GuildModel:set_guild_altar_egg_page_last_altar_info_refresh_time( os.time() )
	end	
end
----------------------------------------------
function GuildAltarEggPage:scroll_item_fun( index )
	-- print("GuildAltarEggPage:scroll_item_fun index",index)
	local page_info = GuildModel:get_guild_altar_egg_page_info()
	local info = page_info.altar_info
	if info[index + 1] == nil then
		self.view:setMaxNum( #info )
		return
	end
	local time_info = Utils:format_time_to_data( info[index + 1].time, "-")
	local touch_info = string.format(Lang.guild.guild_altar_info.touch_event_notic, time_info.."  ",info[index + 1].name, info[index + 1].other_one, info[index + 1].other_two )
	local dialog = ZDialog:create( nil, nil, 0, 0, 278, 305 / scroll_item_num )
	dialog:setText(touch_info)
	local line = ZImage:create( nil, UILH_COMMON.split_line , 0, 10, 290, 2 )
	dialog.view:addChild( line.view )
	return dialog
end
----------------------------------------------
function GuildAltarEggPage:update_star_index_state(index)
	if self.star_info == nil then
		return
	end
	-- print("run GuildAltarEggPage:update_star_index_state index",index)
	for i = 1, #self.star_info do
		if i <= index then
			self.star_info[i].view:setCurState(CLICK_STATE_UP)
		else
			self.star_info[i].view:setCurState(CLICK_STATE_DISABLE)
		end
	end
	--检查假进度条
		for i = 1, #self.pro_info do
		if i < index then
			self.pro_info[i].view:setIsVisible(true)
		else
			self.pro_info[i].view:setIsVisible(false)
		end
	end
end
----------------------------------------------
function GuildAltarEggPage:update(info)
	local page_info = GuildModel:get_guild_altar_egg_page_info()
	print("page_info.gem_index ", page_info.gem_index, info )
	if info == "update_pet_exp" then
		local max_process = GuildConfig:get_altar_gem_index_exp( page_info.gem_index + 1 )
		self.process_bar:setProgressValue( page_info.cur_process, max_process )	
	elseif info == "update_touch_num" then
		self.today_num.view:setText( string.format( Lang.guild.guild_altar_info.today_touch_num, page_info.touch_num ) )
	elseif info == "update_gem_index" then
		local temp_index = GuildModel:get_guild_altar_egg_page_info().gem_index
		self:update_star_index_state( temp_index )
	elseif info == "update_touch_btn" then
		if page_info.my_touch_num >= 1 or page_info.touch_num <= 0 then
			self.touch_btn:setCurState(CLICK_STATE_DISABLE)
		else
			self.touch_btn:setCurState(CLICK_STATE_UP)
		end
	elseif info == "update_scroll" then
		self:update_scroll_fun()
	elseif info == "update_all" or info == "all" then
		print("gem_index,cur_process,touch_num",page_info.gem_index, page_info.cur_process,page_info.touch_num,string.format( Lang.guild.guild_altar_info.today_touch_num, page_info.touch_num ) )
		local temp_index = GuildModel:get_guild_altar_egg_page_info().gem_index
		self:update_star_index_state( temp_index )
		self.today_num.view:setText( string.format( Lang.guild.guild_altar_info.today_touch_num, page_info.touch_num ) )
		local max_process = GuildConfig:get_altar_gem_index_exp( page_info.gem_index + 1 )
		self.process_bar:setProgressValue( page_info.cur_process, max_process )
		if page_info.my_touch_num >= 1 or page_info.touch_num <= 0 then
			self.touch_btn:setCurState(CLICK_STATE_DISABLE)
		else
			self.touch_btn:setCurState(CLICK_STATE_UP)
		end
		self:update_scroll_fun()
	end
end


function GuildAltarEggPage:destroy(  )
   Window:destroy(self)
end
