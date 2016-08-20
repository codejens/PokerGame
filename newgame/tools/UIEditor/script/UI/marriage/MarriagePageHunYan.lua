-- MarriagePageHunYan.lua
-- create by guozhinan on 2015-2-3
-- 结婚系统的第二个分页

super_class.MarriagePageHunYan()

function MarriagePageHunYan:__init( x, y, w, h )
	self.view = CCBasePanel:panelWithFile( x, y, w, h,"");

	-- 普通婚宴
	local pt_img = MUtils:create_zximg( self.view, UILH_MARRIAGE.putonghunyan2, 114, 448, -1, -1 );

	local desc = {LangGameString[1493],LangGameString[1494],LangGameString[1495],}; -- [1493]="#cfafed01、确定婚姻关系之后，只能举办一次;" -- [1494]="#cfafed02、举办成功，情侣双方获得5000亲密度;" -- [1495]="#cfafed03、婚宴举行30分钟;"
	for i=1,3 do
		local lab = UILabel:create_lable_2( desc[i], 25, 425-(i-1)*25, 16, ALIGN_LEFT );
		self.view:addChild(lab);
	end
	--举办按钮
	local function putong_wedding_btn(  )
		local ring_model = UserInfoModel:get_equip_by_type( ItemConfig.ITEM_TYPE_MARRIAGE_RING );
		if ring_model then
			-- 普通婚礼只能立即举行
			local player = EntityManager:get_player_avatar();
			if player.bindYinliang < 98888 then
				-- GlobalFunc:create_screen_notic(LangGameString[1497]); -- [1497]="您的仙币不足，不能举办婚宴!"
			--天降雄狮修改 xiehande  如果是铜币不足/银两不足/经验不足 做我要变强处理
       	    ConfirmWin2:show( nil, 13, LangGameString[1497],  need_money_callback, nil, nil )
				return;
			else
				MarriageModel:req_make_wedding( 1, 0 )
			end
		else
			GlobalFunc:create_screen_notic(LangGameString[1498]); -- [1498]="您尚未结婚,赶快找对自己的心上人求婚吧"
		end
	end
	ZImageButton:create(self.view,UILH_MARRIAGE.btn1,UILH_MARRIAGE.lijijuban,putong_wedding_btn,150, 305);
	-- local pt_btn = TextButton:create( nil, 150, 260-27, 87, 34, LangGameString[1496], UIResourcePath.FileLocate.marriage.."button.png" ); -- [1496]="#cfafed0立即举办"
	-- self.view:addChild( pt_btn.view );
	-- pt_btn:setTouchClickFun(putong_wedding_btn);

	local cost_lab = UILabel:create_lable_2( LangGameString[1499],277, 327, 16, ALIGN_LEFT); -- [1499]="#cfff00098888仙币"
	self.view:addChild(cost_lab);

	-- 分割线
    local split_img = CCZXImage:imageWithFile(10,297,420,2,UILH_MARRIAGE.split_line_h);
    self.view:addChild(split_img);

	-- 豪华婚宴
	local hh_img = MUtils:create_zximg( self.view, UILH_MARRIAGE.haohuahunyan2, 114, 245, -1, -1 );
	local desc = {LangGameString[1500],LangGameString[1501],LangGameString[1502], -- [1500]="#cfafed01、男女双方每天各可举办一次;" -- [1501]="#cfafed02、举办成功后，双方会获得36000亲密度、" -- [1502]="#cfafed03次免费撒喜糖的机会;"
					LangGameString[1503],LangGameString[1504]}; -- [1503]="#cfafed03、可以选择立即或预约特定的时间举办;" -- [1504]="#cfafed04、婚宴举行30分钟;"
	for i=1,5 do
		local x = 25;
		if i==3 then
			x = 57;
		end
		local lab = UILabel:create_lable_2( desc[i], x, 217-(i-1)*25, 16, ALIGN_LEFT );
		self.view:addChild(lab);
	end

	--举办按钮
	local function haohua_wedding_btn_1(  )
		local ring_model = UserInfoModel:get_equip_by_type( ItemConfig.ITEM_TYPE_MARRIAGE_RING );
		if ring_model then
			-- 豪华婚礼，立即举行
			MarriageModel:req_make_wedding( 2, 0 )
			
		else
			GlobalFunc:create_screen_notic(LangGameString[1498]); -- [1498]="您尚未结婚,赶快找对自己的心上人求婚吧"
		end
	end
	ZImageButton:create(self.view,UILH_MARRIAGE.btn1,UILH_MARRIAGE.lijijuban,haohua_wedding_btn_1,70, 35);
	-- local hh_btn_1 = TextButton:create( nil, 150-80, 65-27, 87, 34, LangGameString[1496], UIResourcePath.FileLocate.marriage.."button.png" ); -- [1496]="#cfafed0立即举办"
	-- self.view:addChild( hh_btn_1.view );
	-- hh_btn_1:setTouchClickFun(haohua_wedding_btn_1)
	--
	local cost_lab = UILabel:create_lable_2( LangGameString[1505], 98, 15, 16, ALIGN_LEFT); -- [1505]="#cfff000198元宝"
	self.view:addChild(cost_lab);

	--预约按钮
	local function haohua_wedding_btn_2(  )
		-- 豪华婚礼，预约举行
		-- local ring_model = UserInfoModel:get_equip_by_type( ItemConfig.ITEM_TYPE_MARRIAGE_RING );
		-- if ring_model then
			-- 有婚戒意味着结婚了
			local win = UIManager:show_window("yuyue_wedding_win");
			win:init_yuyue_panel();
		-- else
		-- 	GlobalFunc:create_screen_notic("您尚未结婚,赶快找对自己的心上人求婚吧");
		-- end
	end
	ZImageButton:create(self.view,UILH_MARRIAGE.btn1,UILH_MARRIAGE.yuyuejuban,haohua_wedding_btn_2,250, 35);
	-- local hh_btn_2 = TextButton:create( nil, 150+80, 65-27, 87, 34, LangGameString[1506], UIResourcePath.FileLocate.marriage.."button.png" ); -- [1506]="#cfafed0预约举办"
	-- self.view:addChild( hh_btn_2.view );
	-- hh_btn_2:setTouchClickFun(haohua_wedding_btn_2)
	
	local cost_lab = UILabel:create_lable_2( LangGameString[1505],280, 15, 16, ALIGN_LEFT); -- [1505]="#cfff000198元宝"
	self.view:addChild(cost_lab);

	-- 分割线
	local line = CCZXImage:imageWithFile( 438, 10, 4, 480, UILH_MARRIAGE.split_line_v)
	self.view:addChild(line)

	-- 开始右半边
	self.tab_index = 1;
	-- tab 按钮
    self.radio_btn_dict = {};
  	self.raido_btn_group = CCRadioButtonGroup:buttonGroupWithFile(455, 442, 320, 50,nil);
    self.view:addChild(self.raido_btn_group);
    local img = {UILH_MARRIAGE.putonghunyan, UILH_MARRIAGE.haohuahunyan};
    for i=1,2 do
        local function btn_fun(eventType,x,y)
            if eventType == TOUCH_CLICK then
               self.tab_index = i;
               self:update_wedding_list();
            end
            return true;
        end
        local x = (i-1)*120;
        local y = 0;
        local btn = MUtils:create_radio_button(self.raido_btn_group,UILH_MARRIAGE.btn3_selected,UILH_MARRIAGE.btn3_normal,
        										btn_fun, x, y, 104, 41, false);

     	local lab = MUtils:create_zximg(btn,img[i],11,10,-1,-1);
        self.radio_btn_dict[i] = {button = btn, label = lab};
    end

    --  婚宴列表(由于切换分页时会在active请求婚宴列表，从而刷新列表。因此init时设置行数为0，不进行scroll刷新)
     -- scrollView
    self.hunyan_scroll = CCScroll:scrollWithFile( 446, 16, 403 , 420, 0, "", TYPE_HORIZONTAL, 600, 600 )
		-- local size = self.hunyan_scroll:getSize();
		-- local color_rect =  CCArcRect:arcRectWithColor(0, 0, size.width, size.height, 0xffffffff);
		-- self.hunyan_scroll:addChild(color_rect);		
    -- self.hunyan_scroll:setScrollLump( UILH_COMMON.up_progress, UILH_COMMON.down_progress, 8, 50, 72)
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
            
        	local wedding_list = MarriageModel:get_wedding_list( );
            -- print("婚礼列表长度", #wedding_list[self.tab_index]);
            if #wedding_list > 0 and #wedding_list[self.tab_index] > 0 then
    	        local cell = MarriageHunyanCell( 403, 72, wedding_list[self.tab_index][row]);
    	        self.hunyan_scroll:addItem(cell.view)
    	        self.hunyan_scroll:refresh()
            end
	        
        end
        return true
    end
    self.hunyan_scroll:registerScriptHandler(scrollfun)
    self.hunyan_scroll:refresh()
    self.view:addChild(self.hunyan_scroll);

    self.no_hunyan_img = MUtils:create_zximg( self.view, UILH_MARRIAGE.no_wedding, 540, 240, -1, -1 );
end

function MarriagePageHunYan:active(show)
	if show == true then
		-- 拉取婚宴列表
        MarriageModel:req_get_wedding_list()
	end
end

function MarriagePageHunYan:update_wedding_list(  )
    local wedding_list = MarriageModel:get_wedding_list( );
    print("更新婚礼列表", #wedding_list[self.tab_index]);
    if #wedding_list > 0 and #wedding_list[self.tab_index] > 0 then
    
        self.hunyan_scroll:setIsVisible(true);
        self.no_hunyan_img:setIsVisible(false);
        self.hunyan_scroll:clear();
        self.hunyan_scroll:setMaxNum(#wedding_list[self.tab_index]);    
        self.hunyan_scroll:refresh();

    else
        self.hunyan_scroll:setIsVisible(false);
        self.no_hunyan_img:setIsVisible(true);
    end
end

-- 选择分页
function MarriagePageHunYan:selected_tab( index )
    self.tab_index = index;
    self.raido_btn_group:selectItem(index-1);
    self:update_wedding_list();
end