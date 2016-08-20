-- MarriageHunYanPage.lua
-- create by fjh on 2013-8-14
-- 结婚系统的婚宴分页

super_class.MarriageHunYanPage()

function MarriageHunYanPage:__init( x, y, w, h )
	--355 390 
	self.view = CCBasePanel:panelWithFile( x, y, w, h,"");

	-- 普通婚宴
	local pt_img = MUtils:create_zximg( self.view, UIResourcePath.FileLocate.marriage.."putong.png", w/2-145/2, 315+15, 185, 52 );

	local desc = {LangGameString[1493],LangGameString[1494],LangGameString[1495],}; -- [1493]="#cfafed01、确定婚姻关系之后，只能举办一次;" -- [1494]="#cfafed02、举办成功，情侣双方获得5000亲密度;" -- [1495]="#cfafed03、婚宴举行30分钟;"
	for i=1,3 do
		local lab = UILabel:create_lable_2( desc[i], 40, 310-(i-1)*20, 14, ALIGN_LEFT );
		self.view:addChild(lab);
	end
	--举办按钮
	local pt_btn = TextButton:create( nil, 150, 260-27, 87, 34, LangGameString[1496], UIResourcePath.FileLocate.marriage.."button.png" ); -- [1496]="#cfafed0立即举办"
	self.view:addChild( pt_btn.view );
	local function putong_wedding_btn(  )
		local ring_model = UserInfoModel:get_equip_by_type( ItemConfig.ITEM_TYPE_MARRIAGE_RING );
		if ring_model then
			-- 普通婚礼只能立即举行
			local player = EntityManager:get_player_avatar();
			if player.bindYinliang < 98888 then
				-- GlobalFunc:create_screen_notic(LangGameString[1497]); -- [1497]="您的仙币不足，不能举办婚宴!"
			--天降雄狮修改 xiehande  如果是铜币不足/银两不足/经验不足 做我要变强处理
       	    ConfirmWin2:show( nil, 15, LangGameString[1497],  need_money_callback, nil, nil )
				return;
			else
				MarriageModel:req_make_wedding( 1, 0 )
			end
		else
			GlobalFunc:create_screen_notic(LangGameString[1498]); -- [1498]="您尚未结婚,赶快找对自己的心上人求婚吧"
		end
	end
	pt_btn:setTouchClickFun(putong_wedding_btn);

	local cost_lab = UILabel:create_lable_2( LangGameString[1499],150+90, 260-17, 14, ALIGN_LEFT); -- [1499]="#cfff00098888仙币"
	self.view:addChild(cost_lab);

	-- 分割线
    local split_img = CCZXImage:imageWithFile(20,260-32,334,2,UIResourcePath.FileLocate.marriage .. "line.png");
    self.view:addChild(split_img);

	-- 豪华婚宴
	local hh_img = MUtils:create_zximg( self.view, UIResourcePath.FileLocate.marriage.."haohua.png", w/2-145/2, 175, 185, 54 );
	local desc = {LangGameString[1500],LangGameString[1501],LangGameString[1502], -- [1500]="#cfafed01、男女双方每天各可举办一次;" -- [1501]="#cfafed02、举办成功后，双方会获得36000亲密度、" -- [1502]="#cfafed03次免费撒喜糖的机会;"
					LangGameString[1503],LangGameString[1504]}; -- [1503]="#cfafed03、可以选择立即或预约特定的时间举办;" -- [1504]="#cfafed04、婚宴举行30分钟;"
	for i=1,5 do
		local x = 40;
		if i==3 then
			x = 55;
		end
		local lab = UILabel:create_lable_2( desc[i], x, 155-(i-1)*20, 14, ALIGN_LEFT );
		self.view:addChild(lab);
	end

	--举办按钮
	local hh_btn_1 = TextButton:create( nil, 150-80, 65-27, 87, 34, LangGameString[1496], UIResourcePath.FileLocate.marriage.."button.png" ); -- [1496]="#cfafed0立即举办"
	self.view:addChild( hh_btn_1.view );
	local function haohua_wedding_btn_1(  )
		local ring_model = UserInfoModel:get_equip_by_type( ItemConfig.ITEM_TYPE_MARRIAGE_RING );
		if ring_model then
			-- 豪华婚礼，立即举行
			MarriageModel:req_make_wedding( 2, 0 )
			
		else
			GlobalFunc:create_screen_notic(LangGameString[1498]); -- [1498]="您尚未结婚,赶快找对自己的心上人求婚吧"
		end
	end
	hh_btn_1:setTouchClickFun(haohua_wedding_btn_1)
	--
	local cost_lab = UILabel:create_lable_2( LangGameString[1505], 80, 20, 14, ALIGN_LEFT); -- [1505]="#cfff000198元宝"
	self.view:addChild(cost_lab);

	--预约按钮
	local hh_btn_2 = TextButton:create( nil, 150+80, 65-27, 87, 34, LangGameString[1506], UIResourcePath.FileLocate.marriage.."button.png" ); -- [1506]="#cfafed0预约举办"
	self.view:addChild( hh_btn_2.view );

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
	hh_btn_2:setTouchClickFun(haohua_wedding_btn_2)
	
	local cost_lab = UILabel:create_lable_2( LangGameString[1505],240, 20, 14, ALIGN_LEFT); -- [1505]="#cfff000198元宝"
	self.view:addChild(cost_lab);

end
