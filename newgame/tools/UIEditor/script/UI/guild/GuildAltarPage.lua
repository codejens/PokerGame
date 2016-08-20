----GuildAltarPagelua
----HJH
----2013-8-1
----
---仙宗神兽
super_class.GuildAltarPage(  )
local scroll_item_num = 3
----------------------------------------------
local pet_level_image_info = 
{ 
	{ width = 170, height = 270, image = UILH_GUILD.pet_level_0 }, 
	{ width = 170, height = 270, image = UILH_GUILD.pet_level_1 },
	{ width = 170, height = 270, image = UILH_GUILD.pet_level_2 },
	{ width = 170, height = 270, image = UILH_GUILD.pet_level_3 },
	{ width = 170, height = 270, image = UILH_GUILD.pet_level_4 },
	{ width = 170, height = 270, image = UILH_GUILD.pet_level_5 },
}

--窗体大小
local window_width =880
local window_height = 520
----------------------------------------------
local function create_left(self, x, y, width, height)

	--兽页面对象
	local temp_page_info = GuildModel:get_guild_altar_page_info()

    local bgpanel  = CCBasePanel:panelWithFile(10,15, width, height, UILH_COMMON.bottom_bg, 500, 500)
    self.view:addChild(bgpanel)


    --军旗背景图
	local bg = CCZXImage:imageWithFile( x, y, 540,350 , "")
	local bg_left = CCZXImage:imageWithFile( 0, 0, -1, -1, UILH_GUILD.altar_bg )
	local bg_right = CCZXImage:imageWithFile( 268, 0, -1, -1, UILH_GUILD.altar_bg )
	bg_right:setFlipX(true)
	bg:addChild(bg_left,-1)
	bg:addChild(bg_right,-1)
	self.view:addChild(bg)

    --军旗等级/兽等级
	local pet_image_index = GuildAltarPage:get_pet_image_index( temp_page_info.pet_level )

	--军旗/神兽图片
	self.pet_image = ZImage:create( nil, pet_level_image_info[pet_image_index].image ,
	 278, 187, pet_level_image_info[pet_image_index].width, pet_level_image_info[pet_image_index].height)
	self.pet_image.view:setAnchorPoint(0.5, 0)
	self.view:addChild(self.pet_image.view)

	---规则说明
	-- self.notic_btn = ZTextButton:create( nil, Lang.guild.guild_altar_info.notic_rule,nil, nil, 10, height - 24, -1, -1 )
	-- self:addChild( self.notic_btn.view )
	-- self.notic_btn:setTouchClickFun(GuildModel.guild_altar_rule_btn_fun)
	 local contribute_bg =  CCBasePanel:panelWithFile( 28, 436, 250, 40, "", 500, 500 )
    local function contribute_bg_fun( eventType, x, y )
        if eventType == TOUCH_CLICK then
            GuildModel:guild_altar_rule_btn_fun()
        end
        return true
    end
    contribute_bg:registerScriptHandler( contribute_bg_fun )
    self.view:addChild( contribute_bg )
    --问号
    local question_mark = CCZXImage:imageWithFile( 0, 0, -1, -1, UILH_NORMAL.wenhao )
    contribute_bg:addChild( question_mark ) 
    --问号后面文字
    local get_cont_help_word = CCZXImage:imageWithFile( 40, 9, -1, -1, UILH_GUILD.notic_btn)
    contribute_bg:addChild( get_cont_help_word ) 


	-------等级  战旗等级  神兽等级
	local flag_level_img= CCZXImage:imageWithFile( 370, height - 32, -1, -1, UILH_GUILD.flag_level )
    self.view:addChild( flag_level_img ) 
	self.level = ZLabel:create( nil,  LH_COLOR[13]..temp_page_info.pet_level, 475, 461 )
	self.view:addChild( self.level.view )


	-- ----------------------------------------------
	--神兽赐福
	-- self.shen_shou_luck = ZLabel:create( nil, Lang.guild.guild_altar_info.shen_shou_luck, 18, height - 172 + 80 )
	-- self:addChild(self.shen_shou_luck)
   --战旗buff
    local flag_level_img= CCZXImage:imageWithFile( 41, 344, -1, -1, UILH_GUILD.flag_buff )
    self.view:addChild( flag_level_img ) 

	---------恩赐图标  
	local slot_item_size = 54
	self.slot_item = SlotItem( slot_item_size, slot_item_size-2 )
	self.slot_item:set_icon_bg_texture( UILH_NORMAL.skill_bg_b, -21, -21, 96, 94 )
	self.slot_item:set_icon_texture( UILH_GUILD.luck )
	self.slot_item.view:setPosition( 53, 260)
	self.view:addChild( self.slot_item.view )

	---------文字显示效果
	self.notic_info = ZDialog:create( nil, nil, 21,190, 160, 71 )
	self.view:addChild( self.notic_info.view )

	----------可找回次数 按钮
	self.find_xian_guo_btn = ZTextButton:create( nil, LH_COLOR[2]..Lang.guild.guild_altar_info.find_back, UILH_COMMON.btn4_nor, nil, 34, 54, -1, -1 ) -- [1129]="找回"
	self.find_xian_guo_btn.view:addTexWithFile(CLICK_STATE_DISABLE, UILH_COMMON.btn4_dis)
	self.view:addChild(self.find_xian_guo_btn.view)
	-- self.find_xian_guo_btn.view:setIsVisible(false)
	self.find_xian_guo_btn:setTouchClickFun(GuildModel.guild_altar_find_xian_guo_num_btn_fun)
	
	-- -----------今天剩余次数
	self.today_num = ZLabel:create( nil, string.format( Lang.guild.guild_altar_info.today_xian_guo_num, temp_page_info.xian_guo_num ), 263, 37 )
	self.view:addChild(self.today_num.view )


	----------献果/歃血 详情
	self.xian_guo_info_btn = ZTextButton:create( nil, Lang.guild.guild_altar_info.xian_guo_info, nil, nil, 441, height - 326, -1, -1 )
	self.view:addChild( self.xian_guo_info_btn.view )
	local function xian_guo_info_btn_fun()
		if self.right_normal_page.view:getIsVisible() == true then
			self.right_normal_page.view:setIsVisible( false )
			self.right_info_page.view:setIsVisible( true )
		else
			self.right_normal_page.view:setIsVisible( true )
			self.right_info_page.view:setIsVisible( false )
		end
	end
	self.xian_guo_info_btn:setTouchClickFun( xian_guo_info_btn_fun )
    

    --进度条左右图片
    local progress_left= CCZXImage:imageWithFile( 178, 64, -1, -1, UILH_NORMAL.progress_left )
    self.view:addChild( progress_left ) 
    local progress_right = CCZXImage:imageWithFile(494,64,-1,-1,UILH_NORMAL.progress_left)
	progress_right:setFlipX(true)
    self.view:addChild(progress_right)

	-- ---------进度条  今日剩余次数
    self.process_bar = ZXProgress:createWithValueEx(0,100,310,25,UILH_GUILD.pro_bg_down,UILH_GUILD.pro_bg_up,true);
	self.process_bar:setProgressValue(0,100);	
	self.process_bar:setAnchorPoint(CCPointMake(0,0));
	self.process_bar:setPosition(CCPointMake(198,70));
	self.view:addChild(self.process_bar)


	-----------------------------------------------
end
-----------右边窗口的方法       创建物品列表
local function create_right_normal_page( self, x, y, width, height )
  
	---------------------------------------------
	self.right_normal_page = ZBasePanel:create( nil, UILH_COMMON.bottom_bg, x, y, width, height, 600, 600 )
	self.view:addChild( self.right_normal_page.view )
	---------------------------------------------
	--self.panel_info = {}
	local xian_guo_exp = GuildConfig:get_xian_guo_exp()  --声望
	local xian_guo_renown = GuildConfig:get_xian_guo_renown() --经验
	local xian_guo_money = GuildConfig:get_xian_guo_money()  --消费仙币

	local temp_info = 
	{
	 
	 {
	   label_one = string.format( Lang.guild.guild_altar_info.xian_guo_page_right_label_one, xian_guo_renown[3] ),
	   label_two = string.format( Lang.guild.guild_altar_info.xian_guo_page_right_label_two, xian_guo_exp[3] ),
	   label_three = string.format( Lang.guild.guild_altar_info.xian_guo_page_right_label_three_yb, xian_guo_money[3] ),
	   -- name = Lang.guild.guild_altar_info.xian_guo3, -- [1132]="太初玄果"
	   name = GuildConfig:get_xian_guo_name(3),

	   image =UILH_GUILD.xian_guo_1,
	   ttype = 3
	 },
	 
	 {
	   label_one = string.format( Lang.guild.guild_altar_info.xian_guo_page_right_label_one, xian_guo_renown[2] ),
	   label_two = string.format( Lang.guild.guild_altar_info.xian_guo_page_right_label_two, xian_guo_exp[2] ),
	   label_three = string.format( Lang.guild.guild_altar_info.xian_guo_page_right_label_three_yb, xian_guo_money[2] ),
	   -- name = Lang.guild.guild_altar_info.xian_guo2, -- [1131]="幻月果"
	   name = GuildConfig:get_xian_guo_name(2),

	   image = UILH_GUILD.xian_guo_2,
	   ttype = 2
	 },

	 	 { 
	   label_one = string.format( Lang.guild.guild_altar_info.xian_guo_page_right_label_one, xian_guo_renown[1] ),
	   label_two = string.format( Lang.guild.guild_altar_info.xian_guo_page_right_label_two, xian_guo_exp[1] ),
	   label_three = string.format( Lang.guild.guild_altar_info.xian_guo_page_right_label_three_xb, xian_guo_money[1] ), 
	   -- name = Lang.guild.guild_altar_info.xian_guo1, -- [1130]="青霞果"
	   name = GuildConfig:get_xian_guo_name(1),
	   image = UILH_GUILD.xian_guo_3,
	   ttype = 1
	 },


	}
	self.btn_item = {}
	local temp_y = 160
    
	for i = 1, 3 do

	   local item_panel_bg = CCBasePanel:panelWithFile( 11, temp_y*(i-1)+10 , 284, 150, UILH_COMMON.bg_11, 500, 500 )
        self.right_normal_page:addChild(item_panel_bg)
		--------------------------------
		local slot_item = SlotItem( 64, 64 )
		slot_item:set_icon_texture( temp_info[i].image )
		slot_item.view:setPosition( 30, 35)
		slot_item:set_icon_bg_texture( UILH_COMMON.slot_bg, -8, -8, 80, 80 )
		item_panel_bg:addChild(slot_item.view)
		-------------------------------

		local label_one = ZLabel:create( nil, temp_info[i].label_one, 138,120, 14 )
		item_panel_bg:addChild(label_one.view)
		local label_two = ZLabel:create( nil, temp_info[i].label_two, 138, 100, 14 )
		item_panel_bg:addChild(label_two.view)
		local label_three = ZLabel:create( nil, temp_info[i].label_three, 138, 80, 14 )
		item_panel_bg:addChild(label_three.view)

        --果名
		local name_btn = ZTextImage:create( nil, LH_COLOR[13]..temp_info[i].name, "", 16, 7, 109, 110, 35, 600, 600 )
		--name_btn.view:setCurState(CLICK_STATE_DISABLE)
		item_panel_bg:addChild(name_btn.view)
        
        --垂直的分割线
        local split_line_v =  ZImage:create(item_panel_bg,UILH_COMMON.split_line_v,120,10,-1,temp_y-20)
 

		--献果按钮  图片文字
		-- local btn = ZImageButton:create( nil, UIResourcePath.FileLocate.common .. "button2.png", UIResourcePath.FileLocate.guild .. "xian_guo.png", nil, 168, 26, 81, 36, nil, 600, 600 )
		--程序文字

		local function btn_fun()
			local index = temp_info[i].ttype
			GuildModel:guild_altar_xian_guo_btn_fun(index)
		end
	    
        --歃血
		local btn= TextButton:create( nil, 146, 17, -1, -1, LH_COLOR[2]..Lang.guild.guild_altar_info.shaxue, UILH_COMMON.lh_button2 ) 
        btn.view:addTexWithFile(CLICK_STATE_DOWN,UILH_COMMON.lh_button2_s)
		item_panel_bg:addChild(btn.view)
		btn:setTouchClickFun(btn_fun)

		self.btn_item[i] = btn
		-- if i <= 2 then
		-- 	local line = ZImage:create( nil, UIResourcePath.FileLocate.common .. "fenge_bg.png", 0, temp_y - 111, width, 2)
		-- 	self.right_normal_page:addChild(line)
		-- end
		--temp_y = temp_y - 111
	end
end
----------------------------------------------
local function create_right_info_page( self, x, y, width, height )
	---------------------------------------------
	self.right_info_page = ZBasePanel:create( nil, UILH_COMMON.bottom_bg, x, y, width, height, 600, 600 )
	self.view:addChild(self.right_info_page.view)
	---------------------------------------------
	--表头
	local title_bg_1 = CCZXImage:imageWithFile( 2, height - 37, width-4, 31, UILH_NORMAL.title_bg4)    
    self.right_info_page:addChild( title_bg_1 )

    local time = UILabel:create_label_1(Lang.guild.guild_altar_info.time, CCSize(100,20), 45, 15, 16, CCTextAlignmentCenter, 255, 255, 255) 
    title_bg_1:addChild( time )
    local event = UILabel:create_label_1(Lang.guild.guild_altar_info.event, CCSize(100,20), 198, 15, 16, CCTextAlignmentCenter, 255, 255, 255) 
    title_bg_1:addChild( event )

    local scrollbar_up = ZImage:create(self.right_info_page,UIPIC_DREAMLAND.scrollbar_up,283,443,-1,-1)
	self.scroll = ZScroll:create( nil, nil, 4, 17, width - 20, height - 63, 1, TYPE_HORIZONTAL )
	self.scroll:setScrollCreatFunction( GuildAltarPage.scroll_item_fun )
	self.scroll:setFinishScrollFunction( GuildAltarPage.finish_scroll_fun )
	self.scroll:setScrollLump( 11, 10, 10 )
	local scrollbar_down = ZImage:create(self.right_info_page,UIPIC_DREAMLAND.scrollbar_down,283,7,-1,-1)
	self.right_info_page:addChild(self.scroll)
	self.right_info_page.view:setIsVisible( false )

end
----------------------------------------------
function GuildAltarPage:__init(window_name, texture_name, pos_x, pos_y, width, height)
     --左边版面
	-- create_left(self,18, 146,554, 490)
	--  --右边版面
	-- create_right_info_page(self, 563, 15, 298, 490)
	-- create_right_normal_page(self, 563, 15, 305, 490 )

     self.view = CCBasePanel:panelWithFile(0, 0, window_width, window_height, UILH_COMMON.normal_bg_v2, 500, 500)
		create_left(self,18, 146,554, 490)
	 --右边版面
	create_right_info_page(self, 563, 15, 298, 490)
	create_right_normal_page(self, 563, 15, 305, 490 )
end
----------------------------------------------
function GuildAltarPage:create()
	return GuildAltarPage( "GuildAltarPage",   UILH_COMMON.normal_bg_v2, true, window_width, window_height )
end
----------------------------------------------
function GuildAltarPage:update_scroll_fun()
	local info = GuildModel:get_guild_altar_page_info()
	self.scroll:clear()
	self.scroll:setMaxNum( #info.altar_info )
	self.scroll:refresh()
end
----------------------------------------------
function GuildAltarPage:finish_scroll_fun()
	local page_info = GuildModel:get_guild_altar_page_info()
	if os.time() - page_info.last_altar_info_refresh_time < page_info.max_altar_info_refresh_rate then
		GuildModel:set_guild_altar_page_last_altar_info_refresh_time( os.time() )
	end
end
----------------------------------------------
function GuildAltarPage:scroll_item_fun( index )
	local page_info = GuildModel:get_guild_altar_page_info()
	local info = page_info.altar_info
	if info[index + 1] == nil then
		self.view:setMaxNum( #info )
		return
	end
	local time_info = Utils:format_time_to_data( info[index + 1].time, "-" )
	local touch_info = string.format(Lang.guild.guild_altar_info.xian_guo_notic, time_info.."  ",info[index + 1].name, info[index + 1].other_one, info[index + 1].other_two )
	local dialog = ZDialog:create( nil, nil, 0, 0, 278, 305 / scroll_item_num )
	dialog:setText(touch_info)
	local line = ZImage:create( nil, UILH_COMMON.split_line , 0, 10, 290, 3 )
	dialog.view:addChild( line.view )
	return dialog
end
--------------------------------------------
function GuildAltarPage:getIncText( buff_type, value)
    if ( buff_type == 15 or buff_type == 16 or buff_type == 21 or buff_type == 22 or buff_type == 31 or buff_type == 32 or buff_type == 27 or buff_type == 28) then
        if ( value < 0 ) then
            return Lang.role_info.user_buff_panel.min -- [1133]="减少"
        else
            return Lang.role_info.user_buff_panel.add -- [1134]="添加"
        end
    else
        if ( value < 0 ) then
            return Lang.role_info.user_buff_panel.min -- [1133]="减少"
        else
            return Lang.role_info.user_buff_panel.add -- [628]="增加"
        end
    end
end
--------------------------------------------
function GuildAltarPage:get_pet_image_index(level)
	if level >= 1 and level < 11 then
		return 1
	elseif level >= 11 and level < 21 then
		return 2
	elseif level >= 21 and level < 31 then
		return 3
	elseif level >= 31 and level < 41 then
		return 4 
	elseif level >= 41 and level < 51 then
		return 5
	end
	return 5
end
--------------------------------------------
function GuildAltarPage:update_xian_guo_select_button(result)
	if self.btn_item ~= nil then
		for i = 1, #self.btn_item do
			self.btn_item[i].view:setCurState(result)
		end
	end
end
--------------------------------------------
function GuildAltarPage:get_desc( buff_type, value )
    --print("---------------------------buff_type---------------------",buff_type,value);
    local buff_str = BuffConfig:get_buff_desc_by_buff_id( buff_type )
    value = math.abs(value)
    --print(buff_str);
    require "UI/userAttrWin/UserBuffPanel"
    local inc_str = UserBuffPanel:getIncText( buff_type, value)
    buff_str = string.gsub( buff_str,"#inc#",inc_str );
    --print(buff_str);
    buff_str = string.gsub( buff_str,"<BR>"," " );
    --print(buff_str);
    -- 小于1的数字都变成百分比形式
    if ( value < 1 ) then
        value = math.floor( value * 100 ) .. "%%";
    end
    buff_str = string.gsub( buff_str,"#value#",value );
    --print(buff_str);
    return buff_str;
end

--------------------------------------------
function GuildAltarPage:update(info)
	-----------------------------
	local page_info = GuildModel:get_guild_altar_page_info()
	if page_info == nil then
		return
	end
	local pet_level_info = GuildConfig:get_pet_index_info( page_info.pet_level )

	if info == "update_all" or info == "all" then
		self.process_bar:setProgressValue( page_info.pet_exp, pet_level_info.upExp )
		self.today_num.view:setText( string.format( Lang.guild.guild_altar_info.today_xian_guo_num, page_info.xian_guo_num ) )
		local temp_info = ""
		for i = 1, #pet_level_info.attrs do

			-- print("测试buff")
			-- print(pet_level_info.attrs[i].type)
			-- print(pet_level_info.attrs[i].value)

			local temp_buf_info = self:get_desc( pet_level_info.attrs[i].type, pet_level_info.attrs[i].value )
			temp_info = string.format( "%s#r%s", LH_COLOR[5]..temp_info, LH_COLOR[5]..temp_buf_info )
		end
		self.notic_info.view:setText( LH_COLOR[5]..temp_info )
		self.level.view:setText( LH_COLOR[13]..page_info.pet_level)
		local pet_image_index = GuildAltarPage:get_pet_image_index( page_info.pet_level )
		self.pet_image.view:setTexture( pet_level_image_info[pet_image_index].image )
		self.pet_image:setSize( pet_level_image_info[pet_image_index].width, pet_level_image_info[pet_image_index].height )
		if page_info.find_xian_guo_num > 0 then
			self.find_xian_guo_btn.view:setIsVisible(true)
			self.find_xian_guo_btn.view:setCurState(CLICK_STATE_UP)
			self.find_xian_guo_btn.view:setText( string.format( Lang.guild.guild_altar_info.find_xian_guo_num, page_info.find_xian_guo_num ) )
		else
			-- self.find_xian_guo_btn.view:setIsVisible(false)
			self.find_xian_guo_btn.view:setCurState(CLICK_STATE_DISABLE)
		end
		if page_info.xian_guo_num > 0 then
			self:update_xian_guo_select_button(CLICK_STATE_UP)
		else
			self:update_xian_guo_select_button(CLICK_STATE_DISABLE)
		end
		self:update_scroll_fun()
	elseif info == "update_find_xian_guo_num" then
		if page_info.find_xian_guo_num > 0 then
			self.find_xian_guo_btn.view:setIsVisible(true)
			self.find_xian_guo_btn.view:setCurState(CLICK_STATE_UP)
			self.find_xian_guo_btn.view:setText( string.format( Lang.guild.guild_altar_info.find_xian_guo_num, page_info.find_xian_guo_num ) )
		else
			-- self.find_xian_guo_btn.view:setIsVisible(false)
			self.find_xian_guo_btn.view:setCurState(CLICK_STATE_DISABLE)
		end
	elseif info == "update_process" then
		self.process_bar:setProgressValue( page_info.pet_exp, pet_level_info.upExp )
	elseif info == "update_xian_guo_num" then
		self.today_num.view:setText( string.format( Lang.guild.guild_altar_info.today_xian_guo_num, page_info.xian_guo_num ) )
		if page_info.xian_guo_num > 0 then
			self:update_xian_guo_select_button(CLICK_STATE_UP)
		else
			self:update_xian_guo_select_button(CLICK_STATE_DISABLE)
		end
	elseif info == "update_dialog" then
		local temp_info = ""
		for i = 1, #pet_level_info.attrs do
			local temp_buf_info = self:get_desc( pet_level_info.attrs[i].type, pet_level_info.attrs[i].value )
			temp_info = string.format( "%s#r%s", LH_COLOR[5]..temp_info, LH_COLOR[5]..temp_buf_info )
		end
		self.notic_info.view:setText( LH_COLOR[5]..temp_info )
	elseif info == "update_slot" then

	elseif info == "update_level" then
		self.level.view:setText(page_info.pet_level )
		local pet_image_index = GuildAltarPage:get_pet_image_index( page_info.pet_level )
		self.pet_image.view:setTexture( pet_level_image_info[pet_image_index].image )
		self.pet_image:setSize( pet_level_image_info[pet_image_index].width, pet_level_image_info[pet_image_index].height )
	elseif info == "update_scroll" then
		self:update_scroll_fun()
	end
end



function GuildAltarPage:destroy(  )
   Window:destroy(self)
end
