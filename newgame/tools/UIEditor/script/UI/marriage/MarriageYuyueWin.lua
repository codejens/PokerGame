-- MarriageYuyueWin.lua
-- create by fjh 2013-8-26
-- 婚宴预约窗口
-- 引导获得求婚戒指窗口
super_class.MarriageYuyueWin(Window)

function MarriageYuyueWin:__init(  )

	-- 注册面板事件
	local function bg_event( eventType,x,y )
		if eventType == TOUCH_CLICK then
			UIManager:destroy_window("yuyue_wedding_win");
		end
		return true;
	end 
	self.view:registerScriptHandler(bg_event)
	
end

-- 设置下拉栏的可见状态
function MarriageYuyueWin:set_scroll_visible( bool )
	self.scroll_visible = bool;
	if self.time_scroll then
		self.time_scroll:setIsVisible(self.scroll_visible);
	end
end

-- 设置当前选中的时间点
function MarriageYuyueWin:set_selected_time_point( time )
	
	self.time_point = time;

	self:set_scroll_visible( not self.scroll_visible );
	
	if self.time_btn then
		self.time_btn:setText( time..LangGameString[1546] ); -- [1546]="点"
	end
end

-- 预约面板
function MarriageYuyueWin:init_yuyue_panel( )
	local view_size = self.view:getSize()
	local bg = CCBasePanel:panelWithFile( view_size.width/2-243/2, view_size.height/2-166/2, 243, 166, UILH_MARRIAGE.tip_bg,500,500);
	self:addChild(bg);
	local function bg_event( eventType,x,y )
		if eventType == TOUCH_CLICK then
			if self.scroll_visible == true then
				-- self:set_scroll_visible( not self.scroll_visible );
			end
		end
		return true;	
	end 
	bg:registerScriptHandler(bg_event)

	-- 预约
	local lab = UILabel:create_lable_2(LangGameString[1547],15,110,16,ALIGN_LEFT); -- [1547]="预约时间选择"
	bg:addChild(lab);

	local function btn_ok_fun( eventType,x,y )
		-- if eventType == TOUCH_CLICK then
			if self.time_point and self.time_point > 0 then
				MarriageModel:req_make_wedding( 2, self.time_point );
				UIManager:destroy_window("yuyue_wedding_win");
			end
		-- end
		-- return true;
	end
	ZImageButton:create(bg,UILH_MARRIAGE.btn1,UILH_MARRIAGE.yuyuejuban,btn_ok_fun,(243-123)/2, 10);
	-- self.sure_btn = MUtils:create_btn(bg, UILH_COMMON.button_2_n, UILH_COMMON.button_2_s,btn_ok_fun,243/2-81/2,25,-1,-1);
 --    MUtils:create_sprite(self.sure_btn,UILH_NORMAL.title_tips,55,20.5)

    -- 已选中的时间点(按钮)

	
    local img = CCBasePanel:panelWithFile( 35+125-23, 110-6, 74, 30, UILH_COMMON.bg_02,500,500 );
	bg:addChild(img);

	 
    self.time_btn = TextButton:create( nil, 1, 6, 65, 30, LangGameString[1546], ""); -- [1546]="点"
    self.time_btn:setFontSize(18)
    img:addChild(self.time_btn.view);

    local function selectd_time(  )
   		self:set_scroll_visible( not self.scroll_visible );
    end
    self.time_btn:setTouchClickFun(selectd_time);

 	local function selectd_time_ex( eventType )
 		if eventType == TOUCH_CLICK then
 			self:set_scroll_visible( not self.scroll_visible );	
 		end
 		return true;
 	end   
    local img1 = MUtils:create_btn(img, UILH_MAIL.list_button, UILH_MAIL.list_button,selectd_time_ex,45, 0, 30, 30);
   

    -- 获取可预约时间点
    self.time_list = MarriageModel:get_yuyue_time_list(  );
    --默认选择第一个预约时间点
    self:set_selected_time_point( self.time_list[1] );
  
    --时间点列表
    self.time_scroll = CCScroll:scrollWithFile( 35+125-14-9, -5+20, 65+9 , 90, #self.time_list, "", TYPE_HORIZONTAL, 600, 600 )
 
    local function scrollfun(eventType, arg, msgid)
        
        if eventType == nil or arg == nil or msgid == nil then
            return false
        end
        local temparg = Utils:Split(arg,":")
        local row = tonumber(temparg[1])+1  --行数
        if row == nil then 
            return false;
        end
    	if eventType == SCROLL_CREATE_ITEM then
            
            local time_btn = TextButton:create( nil, 3, 0, 65, 30, self.time_list[row]..LangGameString[1546], UILH_COMMON.bg_02, 500,500); -- [1546]="点"
		    time_btn:setFontSize(16);

		    local function selected_time_point(  )
		    	--	
		    	self:set_selected_time_point(self.time_list[row]);

		    end
		    time_btn:setTouchClickFun(selected_time_point);

		    self.time_scroll:addItem(time_btn.view);
			self.time_scroll:refresh();
        	
        end
        return true

    end
    
    self.time_scroll:registerScriptHandler(scrollfun)
    self.time_scroll:refresh()
    bg:addChild(self.time_scroll);

   	--默认隐藏预约列表
    self.scroll_visible = false;
    self.time_scroll:setIsVisible(false);
end


-- 引导获得戒指界面
function MarriageYuyueWin:init_ring_panel(  )
	local view_size = self.view:getSize()
	local bg = CCBasePanel:panelWithFile( view_size.width/2-410/2, view_size.height/2-305/2, 410, 305, UILH_COMMON.dialog_bg,500, 500);
	self:addChild(bg);

	local bottom_bg = CCBasePanel:panelWithFile( 10, 10, 410-20, 305-35, UILH_COMMON.bottom_bg,500, 500);
	bg:addChild(bottom_bg);

	local row_bg1 = CCBasePanel:panelWithFile( 30, 130, 410-60, 110, UILH_COMMON.bg_normal,500, 500);
	bg:addChild(row_bg1);
	local row_bg2 = CCBasePanel:panelWithFile( 30, 20, 410-60, 110, UILH_COMMON.bg_normal,500, 500);
	bg:addChild(row_bg2);

	local function bg_event( eventType,x,y )
		if eventType == TOUCH_CLICK then
			
		end
		return true;	
	end 
	bg:registerScriptHandler(bg_event)

	-- 关闭按钮
	local function close_win( eventType,x,y )
		if eventType == TOUCH_CLICK then
			UIManager:destroy_window("yuyue_wedding_win");
		end
		return true;
	end
	local close_btn = MUtils:create_btn( bg, UILH_COMMON.close_btn_z,UILH_COMMON.close_btn_z,
										close_win,410-56,305-56,60,60 );

    local lab = UILabel:create_lable_2( LangGameString[1548], 410/2, 249, 16, ALIGN_CENTER ); -- [1548]="您背包没有求婚戒指"
    bg:addChild(lab);
    -- 深海之恋戒指
	local shenhai_ring = MUtils:create_one_slotItem( 11101, 90, 152, 64, 64 );
	shenhai_ring:set_color_frame(nil);
	bg:addChild(shenhai_ring.view);

	local function show_shenhai_ring_tip(obj, eventType, arg,msgid)
        local click_pos = Utils:Split(arg, ":")
        local world_pos = shenhai_ring.view:getParent():convertToWorldSpace( CCPointMake( tonumber(click_pos[1]),tonumber(click_pos[2]) ) )

		TipsModel:show_marriage_ring( 11101, 0, nil, world_pos.x,world_pos.y);
	end
	shenhai_ring:set_click_event( show_shenhai_ring_tip );

	-- 前往深海之恋
	local shenhai_btn_1 = TextButton:create( nil, 208, 191, 87, 34, Lang.marriage[1],nil ); -- [1549]="#cfff000#u1前往深海之恋#u0"
	bg:addChild( shenhai_btn_1.view );
	local function move_shenhai(  )
		-- 63 87
		GlobalFunc:ask_npc( 3, Lang.marriage[4]  ); -- [1550]="深海之恋"
		UIManager:destroy_window("yuyue_wedding_win");
	end 
	shenhai_btn_1:setTouchClickFun(move_shenhai)

	-- 速传深海之恋
	local shenhai_btn_2 = TextButton:create( nil, 208, 166, 87, 34, Lang.marriage[2],nil ); -- [1551]="#cfff000#u1速传深海之恋#u0"
	bg:addChild( shenhai_btn_2.view );

	local function teleport_shenhai(  )
		-- 63 87
		GlobalFunc:teleport( 3, Lang.marriage[4] ); -- [1550]="深海之恋"
		UIManager:destroy_window("yuyue_wedding_win");
	end 
	shenhai_btn_2:setTouchClickFun(teleport_shenhai)

	 -- 比翼双飞戒指
	local biyi_ring = MUtils:create_one_slotItem( 11102, 90, 42, 64, 64 );
	
	biyi_ring:set_color_frame(nil);
	bg:addChild(biyi_ring.view);

	local function show_shenhai_ring_tip(obj, eventType, arg,msgid)
        local click_pos = Utils:Split(arg, ":")
        local world_pos = biyi_ring.view:getParent():convertToWorldSpace( CCPointMake( tonumber(click_pos[1]),tonumber(click_pos[2]) ) )

		TipsModel:show_marriage_ring( 11102, 0, nil, world_pos.x,world_pos.y);

	end
	biyi_ring:set_click_event( show_shenhai_ring_tip );

	-- 点击购买比翼双飞
	local function buy_ring(  )
		local win = UIManager:show_window("mall_win");
		win:change_page(6);
		UIManager:destroy_window("yuyue_wedding_win");
	end
	ZImageButton:create(bg,UILH_NORMAL.special_btn,UILH_MARRIAGE.dianjigoumai,buy_ring,190, 47);
	-- local biyi_btn = TextButton:create( nil, 151, 70, 87, 34, Lang.marriage[3],nil ); -- [1552]="#cfff000#u1点击购买#u0"
	-- bg:addChild( biyi_btn.view );
	-- biyi_btn:setTouchClickFun(buy_ring);

end
