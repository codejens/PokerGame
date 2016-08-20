super_class.WeiXinActivityWin( Window )

function WeiXinActivityWin:__init( window_name, texture_name, is_grid, width, height )
	-- create title
	local win_title_bg = CCZXImage:imageWithFile( width/2, height-35, -1, -1, UI_WXActWin_009 );
	local titleImg = CCZXImage:imageWithFile( width/2, height - 3, -1, -1, UI_WXActWin_003 );
	win_title_bg:setAnchorPoint( 0.5, 0 );
	self.view:addChild( win_title_bg, 1000 );
	titleImg:setAnchorPoint( 0.5, 0 );
	self.view:addChild( titleImg, 1001 );

	-- create beautiful girl


	if Target_Platform == Platform_Type.Platform_91 or Target_Platform == Platform_Type.Platform_ap then
        local beauty = CCZXImage:imageWithFile( -103, 0, -1, -1, "nopack/body/11.png")
        self.view:addChild(beauty,999)
    else
        local beauty = CCZXImage:imageWithFile( -103, -24, -1, -1, UI_WXActWin_001 );
		self.view:addChild( beauty, 1000 );
    end

	-- create close button fatherPanel, image, fun, x, y, width, height, z
	local function on_exit_button_clicked()
		UIManager:hide_window( "wei_xin_win" );
	end
	self.exit_btn = ZButton:create( self.view, UI_WXActWin_002, on_exit_button_clicked, width-58, height-34, -1, -1, 1000 );

	-- create activity description info
	local tips1_img = CCZXImage:imageWithFile( 57, 320, -1, -1, UI_WXActWin_010 );
	self.view:addChild( tips1_img, 1000 )

	local tips2_img = CCZXImage:imageWithFile( 57, 133, -1, -1, UI_WXActWin_011 );
	self.view:addChild( tips2_img, 1000 )

	-- create button( get activation code )
	local function on_get_code_button_clicked()
		UIManager:show_window( "weixin_input_dialog" )
	end
	 --UI_WXActWin_007 ->UIPIC_COMMOM_002
	local get_code_btn = ZButton:create( self.view, UIPIC_COMMOM_002, on_get_code_button_clicked, 38, 62, 140, -1 );
	local get_code_btn_lab = CCZXLabel:labelWithText( 134/2+2, 22, "激活码领取", 15, ALIGN_CENTER)
	get_code_btn:addChild( get_code_btn_lab );

	-- create item slot
	local slot_bg = CCZXImage:imageWithFile( 149, 39, 448, -1, UI_WXActWin_006, 500, 500 )
	self.view:addChild( slot_bg );

	self.reward_tab = {};
	local function item_click_fun( slot_item, event_type, args, msgid )
		-- 被点击的坐标点
		local position = Utils:Split(args,":");
		if slot_item.item_id then
			TipsModel:show_shop_tip( position[1],position[2], slot_item.item_id )
		end
	end

	local slot_start_x;
	local slot_start_y = 55;
	for i=1,6 do
		local item_info = WeiXinActConfig:get_item_by_index( i );
		slot_start_x = 186 + (i-1)*64;
		local slot_item = SlotItem( 56, 56 );
		slot_item:set_icon_bg_texture( UI_WXActWin_005, -4, -4, 64, 64 );
    	slot_item:setPosition( slot_start_x, slot_start_y )
    	slot_item:set_click_event( item_click_fun )
    	self.reward_tab[i] = slot_item;
    	self.view:addChild( slot_item.view );
    	if item_info then
    		slot_item:set_icon( item_info.id );
    		slot_item:set_item_count( item_info.num );
    	end
	end
end

function WeiXinActivityWin:destroy()
	Window.destroy( self );
end

function WeiXinActivityWin:active( show )
	if show then
		for i=1,6 do
			if self.reward_tab[i] then
				self.reward_tab[i]:play_activity_effect();
			end
		end
	end
end