
-- MountsLingXiPanel.lua 
-- createed by mwy @2012-5-3
-- 新建灵犀页面,独立出坐骑灵犀功能


-- super_class.MountsLingXiPanel(  )

-- --是否处于下阶形象
-- local isNextMount = false;
-- -- 坐骑形象
-- local mounts_avatar = nil;
-- --战斗力文字图片
-- local fightValue_lab = nil;
-- -- 综合战斗力
-- local mounts_fight = nil;
-- -- 坐骑信息按钮
-- local mounts_info_tab = nil;
-- -- 坐骑进阶按钮
-- local mounts_jinjie_tab = nil;
-- -- 坐骑洗练按钮
-- local mounts_xilian_tab = nil;
-- -- 坐骑名字
-- local mounts_name = nil;
-- --下阶形象
-- local next_mount = nil;
-- --化形按钮
-- local huaxing_btn = nil;
-- --炫耀按钮
-- local xuanyao_btn = nil;
-- --乘骑按钮
-- local chengqi_btn = nil;
-- -- 生命增幅
-- local hp_exten = nil;
-- local hp_exten_add = nil;
-- -- 法术防御增幅
-- local md_exten = nil;
-- local md_exten_add = nil;
-- -- 暴击增幅
-- local bj_exten = nil;
-- local bj_exten_add = nil;
-- -- 攻击增幅
-- local at_exten = nil;
-- local at_exten_add = nil;
-- -- 物理防御增幅
-- local wd_exten = nil;
-- local wd_exten_add = nil;
-- -- 移动速度增幅
-- local seep_exten = nil;

-- -- 灵犀值
-- local lingxi_value = nil;
-- -- 提示灵犀的成功率
-- local lingxi_succ = nil;

-- local is_other_mounts = false;

-- -- 底板
-- local panel=nil

-- function MountsLingXiPanel:__init( pos_x,pos_y)
-- 	-- local mounts_model = MountsModel:get_mounts_info();

-- 	local pos_x = x or 0
--     local pos_y = y or 0
-- 	self.view = CCBasePanel:panelWithFile( pos_x, pos_y, 800+35, 386+147, UI_MountsWinNew_003, 500, 500 )

-- 	-- 底板
-- 	panel = self.view
-- 	-- 左上
-- 	local _left_up_panel = CCBasePanel:panelWithFile( 11, 222, 390, 300, UI_MountsWinNew_004, 500, 500 )
-- 	panel:addChild(_left_up_panel)
-- 	-- 左下
-- 	local _left_down_panel = CCBasePanel:panelWithFile( 10, 13, 390, 200+6, UI_MountsWinNew_004, 500, 500 )
-- 	panel:addChild(_left_down_panel)
-- 	-- 右
-- 	local _right_panel = CCBasePanel:panelWithFile( 404, 13, 390-4+35, 500+9, UI_MountsWinNew_004, 500, 500 )
-- 	panel:addChild(_right_panel)


-- 	-------------------------------------左面板----------------------------------

-- 	-- 坐骑背景
-- 	self._mount_bg = CCBasePanel:panelWithFile( 1,1,390-2, 300-2, UI_MountsWinNew_015, 500, 500 )
-- 	_left_up_panel:addChild(self._mount_bg)


-- 	--坐骑名底色
-- 	local name_bg = CCZXImage:imageWithFile(114, 265,145,-1,UI_MountsWinNew_016,500,500)
-- 	self._mount_bg:addChild(name_bg)

-- 	-- 坐骑名字 	
-- 	mounts_name = UILabel:create_lable_2( "#cfff000白虎", 67, 6, 20, ALIGN_CENTER );
-- 	name_bg:addChild(mounts_name);

-- 		--切换上下马的状态
-- 	local function chengqi_event(eventType,x,y)
-- 		if eventType == TOUCH_CLICK then
-- 			MountsModel:ride_a_mount();	--修改model数据
-- 			self:setMountsStatus(MountsModel:get_is_shangma())

-- 			-- local mounts_win = UIManager:find_window("mounts_win_new")
-- 			-- if mounts_win then
-- 			-- 	mounts_win:changeQiXiuState("lingxi",MountsModel:get_is_shangma())
-- 			-- end
-- 		end
-- 		return true
-- 	end

-- 	--乘骑按钮 
-- 	chengqi_btn = CCNGBtnMulTex:buttonWithFile(10,9,-1,-1,UI_MountsWinNew_023);
-- 	self._mount_bg:addChild(chengqi_btn);
-- 	qi_title_status = CCZXImage:imageWithFile(7,10,-1,-1,UI_MountsWinNew_021,500,500)

-- 	chengqi_btn:addChild(qi_title_status)

-- 	chengqi_btn:registerScriptHandler(chengqi_event);
-- 	--设置坐骑状态对于的按钮显示
-- 	self:setMountsStatus(MountsModel:get_is_shangma())


-- 	-- -- 化形按钮事件
-- 	-- local function huaxing_event(eventType, x, y)	
-- 	-- 	if eventType == TOUCH_CLICK then
-- 	-- 		UIManager:show_window("mounts_huaxing_win");
-- 	-- 		-- UIManager:hide_window("mounts_info_win");
-- 	-- 		-- UIManager:hide_window("mounts_jinjie_win");
-- 	-- 		-- UIManager:hide_window("mounts_xilian_win");
-- 	-- 	end
-- 	-- 	return true
-- 	-- end
-- 	-- -- 化形按钮
-- 	-- huaxing_btn = CCNGBtnMulTex:buttonWithFile(10,9,-1,-1,UIResourcePath.FileLocate.mount .. "button_mount_hua.png")
-- 	-- _mount_bg:addChild(huaxing_btn)
-- 	-- huaxing_btn:registerScriptHandler(huaxing_event)


-- 	-- 炫耀按钮事件
-- 	local function xuanyao_event(eventType, x, y)	
-- 		if eventType == TOUCH_CLICK then
-- 			MountsModel:req_xuanyao_event(  )
-- 		end
-- 		return true
-- 	end
-- 	-- 炫耀
-- 	xuanyao_btn = CCNGBtnMulTex:buttonWithFile(300+7+10,9,-1,-1,UI_MountsWinNew_023,20,13)
-- 	self._mount_bg:addChild(xuanyao_btn)
-- 	local qi_title_status = CCZXImage:imageWithFile(8,10,-1,-1,UI_MountsWinNew_024,500,500)
-- 	xuanyao_btn:addChild(qi_title_status)

-- 	xuanyao_btn:registerScriptHandler(xuanyao_event)

-- 	xuanyao_btn:registerScriptHandler(xuanyao_event)

-- 	-- 战斗力
-- 	local _power_bg = CCBasePanel:panelWithFile( 86-12,11,212+20+4, -1, UI_MountsWinNew_017, 500, 500 )
-- 	self._mount_bg:addChild(_power_bg,256)
-- 	-- 战斗力文字
-- 	local _power_title = CCZXImage:imageWithFile(42,17,-1,-1,UI_MountsWinNew_018)
--     _power_bg:addChild(_power_title)
--     -- 战斗力值
-- 	mounts_fight = ZXLabelAtlas:createWithString("99999",UIResourcePath.FileLocate.normal .. "number");
-- 	mounts_fight:setPosition(CCPointMake(107,17));
-- 	mounts_fight:setAnchorPoint(CCPointMake(0,0));
-- 	_power_bg:addChild(mounts_fight);


-- 	--增加属性标题
-- 	local _left_down_title_panel = CCBasePanel:panelWithFile( 1, 177, 150, -1, UI_MountsWinNew_005, 500, 500 )
-- 	_left_down_panel:addChild(_left_down_title_panel)
-- 	local name_title = CCZXImage:imageWithFile(27, 4,-1,-1,UI_MountsWinNew_019,500,500)
-- 	_left_down_title_panel:addChild(name_title)


-- 	for i=1,3 do
-- 		for j=1,2 do
-- 			local _attr_bg = CCBasePanel:panelWithFile( 93+(j-1)*190, 20+(i-1)*55, 100, -1, UI_MountsWinNew_006, 500, 500 )
-- 			_left_down_panel:addChild(_attr_bg)


-- 		end
-- 	end


-- 	-------------生命
-- 	local hp_lab = UILabel:create_lable_2( "#c0edc09生    命", 6, 135+2, 17, ALIGN_LEFT );
-- 	-- hp_lab:setAnchorPoint(CCPointMake(0,1));
-- 	_left_down_panel:addChild(hp_lab);

-- 	-- 生命增幅
-- 	-- local hp_s =  string.format("%d",mounts_model.att_hp);
-- 	hp_exten = UILabel:create_label_1("", CCSizeMake(87,20), 150,147, 17, CCTextAlignmentLeft, 255, 255, 255);
-- 	hp_exten:setAnchorPoint(CCPointMake(0,0));
-- 	_left_down_panel:addChild(hp_exten)

-- 	--灵犀开启之后才有加成
-- 	-- local add_var = self:calculate_attribute_add(mounts_model.att_hp,mounts_model.lingxi);
-- 	hp_exten_add = UILabel:create_label_1(string.format(""), CCSizeMake(46,20), 140+30,147, 17, CCTextAlignmentLeft, 56, 255, 51);
-- 	hp_exten_add:setAnchorPoint(CCPointMake(0,0));
-- 	_left_down_panel:addChild(hp_exten_add);
-- 	-- if mounts_model.level<50 then
-- 	-- 	print("灵犀开启之后才有加成")
-- 	-- end

-- 	-------------精神防御
-- 	local md_lab = UILabel:create_lable_2( "#c0edc09精神防御", 6,85, 17, ALIGN_LEFT );
-- 	-- md_lab:setAnchorPoint(CCPointMake(0,1));
-- 	_left_down_panel:addChild(md_lab);

-- 	-- 精神防御增幅
-- 	-- local md_s =  string.format("%d",mounts_model.att_md);
-- 	md_exten = UILabel:create_label_1("", CCSizeMake(87,20), 150, 58-20+54, 17, CCTextAlignmentLeft, 255, 255, 255);
-- 	md_exten:setAnchorPoint(CCPointMake(0,0));
-- 	_left_down_panel:addChild(md_exten)

-- 	--灵犀开启之后才有加成
-- 	-- local add_var = self:calculate_attribute_add(mounts_model.att_md,mounts_model.lingxi);
-- 	md_exten_add = UILabel:create_label_1(string.format(""), CCSizeMake(46,20), 140+30, 58-20+54, 17, CCTextAlignmentLeft, 56, 255, 51);
-- 	md_exten_add:setAnchorPoint(CCPointMake(0,0));
-- 	_left_down_panel:addChild(md_exten_add);
-- 	-- if mounts_model.level<50 then
-- 	-- 	md_exten_add:setIsVisible(false);
-- 	-- end

-- 	-------------暴击
-- 	local bj_lab = UILabel:create_lable_2( "#c0edc09暴    击", 6,27+2, 17, ALIGN_LEFT );
-- 	-- bj_lab:setAnchorPoint(CCPointMake(0,1));
-- 	_left_down_panel:addChild(bj_lab);
-- 	-- 底图

-- 	-- 暴击增幅
-- 	-- local bj_s =  string.format("%d",mounts_model.att_bj);
-- 	bj_exten = UILabel:create_label_1("", CCSizeMake(87,20), 150, 58-40+20, 17, CCTextAlignmentLeft, 255, 255, 255);
-- 	bj_exten:setAnchorPoint(CCPointMake(0,0));
-- 	_left_down_panel:addChild(bj_exten)

-- 	--灵犀开启之后才有加成
-- 	-- local add_var = self:calculate_attribute_add(mounts_model.att_bj,mounts_model.lingxi);
-- 	bj_exten_add = UILabel:create_label_1(string.format(""), CCSizeMake(46,20), 140+30, 58-40+20, 17, CCTextAlignmentLeft, 56, 255, 51);
-- 	bj_exten_add:setAnchorPoint(CCPointMake(0,0));
-- 	_left_down_panel:addChild(bj_exten_add);
-- 	-- if mounts_model.level<50 then
-- 	-- 	bj_exten_add:setIsVisible(false);
-- 	-- end

-- 	-------------攻击
-- 	local at_lab = UILabel:create_lable_2( "#c0edc09攻    击", 197,  135+2, 17, ALIGN_LEFT );
-- 	-- at_lab:setAnchorPoint(CCPointMake(0,1));
-- 	_left_down_panel:addChild(at_lab);
-- 	-- 攻击增幅
-- 	-- local at_s =  string.format("%d",mounts_model.att_attack);
-- 	at_exten = UILabel:create_label_1("", CCSizeMake(87,20), 335, 147, 17, CCTextAlignmentLeft, 255, 255, 255);
-- 	at_exten:setAnchorPoint(CCPointMake(0,0));
-- 	_left_down_panel:addChild(at_exten)

-- 	--灵犀开启之后才有加成
-- 	-- local add_var = self:calculate_attribute_add(mounts_model.att_attack,mounts_model.lingxi);
-- 	at_exten_add = UILabel:create_label_1(string.format(""), CCSizeMake(46,20), 305+23+30, 58, 17, CCTextAlignmentLeft, 56, 255, 51);
-- 	at_exten_add:setAnchorPoint(CCPointMake(0,0));
-- 	_left_down_panel:addChild(at_exten_add);
-- 	-- if mounts_model.level<50 then
-- 	-- 	at_exten_add:setIsVisible(false);
-- 	-- end

-- 	-------------物理防御
-- 	local wd_lab = UILabel:create_lable_2( "#c0edc09物理防御", 197,  85, 17, ALIGN_LEFT );
-- 	-- wd_lab:setAnchorPoint(CCPointMake(0,1));
-- 	_left_down_panel:addChild(wd_lab);

-- 	-- 物理防御增幅
-- 	-- local wd_s =  string.format("%d",mounts_model.att_wd);
-- 	wd_exten = UILabel:create_label_1("", CCSizeMake(87,20), 335,  58-20+54, 17, CCTextAlignmentLeft, 255, 255, 255);
-- 	wd_exten:setAnchorPoint(CCPointMake(0,0));
-- 	_left_down_panel:addChild(wd_exten)
-- 	--灵犀开启之后才有加成
-- 	-- local add_var = self:calculate_attribute_add(mounts_model.att_wd,mounts_model.lingxi);
-- 	wd_exten_add = UILabel:create_label_1(string.format(""), CCSizeMake(46,20), 305+20+30,58-20+54, 17, CCTextAlignmentLeft, 56, 255, 51);
-- 	wd_exten_add:setAnchorPoint(CCPointMake(0,0));
-- 	_left_down_panel:addChild(wd_exten_add)
-- 	-- if mounts_model.level<50 then
-- 	-- 	wd_exten_add:setIsVisible(false);
-- 	-- end

-- 	local seep_lab = UILabel:create_lable_2( "#c0edc09移动速度", 197,  27+2, 17, ALIGN_LEFT );
-- 	-- seep_lab:setAnchorPoint(CCPointMake(0,1));
-- 	_left_down_panel:addChild(seep_lab);

-- 	-- 移动速度增幅
-- 	-- local speed = mount_config["moveSpeed"];
-- 	-- local speed_ex =  math.abs(900*900/(900+speed)-900);
-- 	seep_exten = UILabel:create_label_1(string.format(""), CCSizeMake(87,20), 335, 58-40+20, 17, CCTextAlignmentLeft, 56, 255, 51);
-- 	seep_exten:setAnchorPoint(CCPointMake(0,0));
-- 	_left_down_panel:addChild(seep_exten)

-- 	-------------------------------------右面板----------------------------------

-- 	local _right_bg = CCBasePanel:panelWithFile( 1, 1,  384, 507, UI_MountsWinNew_004, 500, 500 )
-- 	_right_panel:addChild(_right_bg)	

-- 	self:hideLingxi(_right_panel)
-- 	self:showLingXi(_right_panel)

-- 	-- 更新数据
-- 	self:update();


-- end

-- function MountsLingXiPanel:hideLingxi( self_panel )
-- 	-- body

-- 	-- 灵犀值
-- 	local lingxi_bg = CCZXImage:imageWithFile(130+17.5,202,-1,-1,UI_MountsWinNew_025);
-- 	self_panel:addChild(lingxi_bg);

-- 	self.lingxi_lab1 = UILabel:create_label_1("+100%", CCSizeMake(209,20), 212+17.5, 210+5, 20, nil, 255, 240, 0);
-- 	self_panel:addChild(self.lingxi_lab1);

-- 	-- local lingxi_lab = UILabel:create_label_1(LangGameString[1591], CCSizeMake(209,20), 100-10, 84/2-10, 20, nil, 54, 166, 238); -- [1591]="坐骑达到50级后开启灵犀值功能"
-- 	-- self_panel:addChild(lingxi_lab);

-- end

-- function MountsLingXiPanel:showLingXi( self_panel )

-- 	local function lingxi_tip(  )
-- 		TipsModel:show_shop_tip(400,200,18602);
-- 	end

-- 	-- 加一个托盘底板
-- 	local tmpPanel = CCZXImage:imageWithFile( 133+17.5,354, -1, -1, UI_MountsWinNew_037 );
-- 	self_panel:addChild( tmpPanel );
-- 	-- 灵犀丹
-- 	self.lingxi_icon = MUtils:create_slot_item(self_panel,UIPIC_ITEMSLOT,163+17.5,373,72,72,nil,lingxi_tip);
-- 	self.lingxi_icon:set_icon_texture("icon/item/00306.pd");
-- 	--lingxi_icon:set_icon_texture("icon/item/00306.png");

-- 	local lingxi_lab = UILabel:create_label_1(LangGameString[1592], CCSizeMake(50,20), 167+17.5, 466, 19, nil, 255, 240, 0); -- [1592]="灵犀丹"
-- 	lingxi_lab:setAnchorPoint(CCPointMake(0,0));
-- 	self_panel:addChild(lingxi_lab);
	
-- 	-- 灵犀值
-- 	--local lingxi_lab1 = UILabel:create_label_1(LangGameString[1593], CCSizeMake(60,20),  140, 46, 20, nil,  54, 166, 238); -- [1593]="灵犀值："
-- 	--lingxi_lab1:setAnchorPoint(CCPointMake(0,0));
-- 	--self_panel:addChild(lingxi_lab1);

-- 	--lingxi_value = UILabel:create_label_1("", CCSizeMake(60,20),235, 45, 19, CCTextAlignmentLeft, 255, 240, 0);
-- 	--lingxi_value:setAnchorPoint(CCPointMake(0,0));
-- 	--self_panel:addChild(lingxi_value);

-- 	-- 成功率
-- 	local lingxi_lab2 = UILabel:create_label_1(LangGameString[1594], CCSizeMake(90,20),128+17.5, 300, 18, nil,  54, 166, 238); -- [1594]="成功率:"
-- 	lingxi_lab2:setAnchorPoint(CCPointMake(0,0));
-- 	self_panel:addChild(lingxi_lab2);

-- 	-- 成功率值
-- 	lingxi_succ = UILabel:create_label_1("+60%", CCSizeMake(60,20), 209+17.5, 300, 18, nil, 255, 240, 0);
-- 	lingxi_succ:setAnchorPoint(CCPointMake(0,0));
-- 	self_panel:addChild(lingxi_succ);

-- 	-- LangGameString[1595] 灵犀丹可通过月华梦境获得
-- 	local lingxi_tip = CCZXLabel:labelWithText( 86+17.5, 321, LangGameString[1595], 16, ALIGN_LEFT )
-- 	self_panel:addChild(lingxi_tip);

-- 	-- 提升按钮
-- 	local function lxts_event()
-- 		--提升灵犀。在发请求之前应该查看身上是否有灵犀丹
-- 		MountsCC:request_up_lingxi()
-- 		return true
--  	end
-- 	self.tishen_btn = ZButton:create( self_panel, UI_MountsWinNew_010, lxts_event, 141+17.5, 61, -1, -1 )
-- 	self.tishen_btn:addImage( CLICK_STATE_DOWN, UI_MountsWinNew_010 );
-- 	self.tishen_btn:addImage( CLICK_STATE_DISABLE, UI_MountsWinNew_034 );
-- 	self.tishen_btn.view:setCurState( CLICK_STATE_UP );
-- 	local btn_size = self.tishen_btn.view:getSize();
-- 	self.tishen_lab = CCZXImage:imageWithFile( btn_size.width/2, btn_size.height/2, -1, -1, UI_MountsWinNew_032 )
-- 	self.tishen_lab:setAnchorPoint( 0.5, 0.5 )
-- 	self.tishen_btn:addChild( self.tishen_lab );
-- end

-- --提升灵犀的回调
-- function MountsLingXiPanel:lxts_callback(mounts_model)
	
-- 	-- 更新灵犀值标签
-- 	self:updateLingXiValueLabel( mounts_model.lingxi )
	
-- 	-- 如果灵犀满值了，就把提升按钮置灰
-- 	if mounts_model.lingxi == 150 then
-- 		self.lingxi_lab1:setText(LangGameString[1579]); -- [1579]="+150%#c38ff33(满)"
-- 		self.tishen_btn:setCurState(CLICK_STATE_DISABLE);
-- 		self.tishen_lab:setTexture( UI_MountsWinNew_038 );
-- 	end

-- 	--查询是否有灵犀丹
--  	local count = ItemModel:get_item_count_by_id(18602);
--  	if count > 0 then
--  		self.lingxi_icon:set_icon_light_color();
--  	else
--  		self.lingxi_icon:set_icon_dead_color();
--  	end
--  	self.lingxi_icon:set_count(count)
 	
--  	self:update_base_att(mounts_model);
-- end

-- -- 更新界面
-- function MountsLingXiPanel:update(  )
-- 	local model = MountsModel:get_mounts_info();
	
-- 	if model then 
-- 		-- self:set_btns_visiable(is_other_mounts)
-- 		--改变外观
-- 		self:change_mounts_avatar(model.model_id);
		
-- 		self:change_mount_fight_value( model.fight )
-- 		-- self:update_base_exten_att(model)
-- 		self:update_base_att(model);
-- 		-- 更新灵犀值
-- 		self:updateLingXiValueLabel(model.lingxi)
-- 		-- 更新灵犀丹物品数量
-- 		local count = ItemModel:get_item_count_by_id( 18602 )
-- 		if count > 0 then
--  			self.lingxi_icon:set_icon_light_color();
--  		else
--  			self.lingxi_icon:set_icon_dead_color();
--  		end
--  		self.lingxi_icon:set_count(count)
-- 	end
	
-- end

-- -- 更新基础属性
-- function MountsLingXiPanel:update_base_att( mounts_model )
-- 	-- body
-- 	if not mounts_model then
-- 		return
-- 	end

-- 	--属性变成基础属性+灵犀加成
-- 	local hp_var = tonumber( mounts_model.att_hp )+ self:calculate_attribute_add(mounts_model.att_hp,mounts_model.lingxi);
-- 	local at_var = tonumber(mounts_model.att_attack)+self:calculate_attribute_add(mounts_model.att_attack,mounts_model.lingxi);
-- 	local md_var = tonumber(mounts_model.att_md)+self:calculate_attribute_add(mounts_model.att_md,mounts_model.lingxi);
-- 	local wd_var = tonumber( mounts_model.att_wd)+self:calculate_attribute_add(mounts_model.att_wd,mounts_model.lingxi); 
-- 	local bj_var = tonumber( mounts_model.att_bj)+self:calculate_attribute_add(mounts_model.att_bj,mounts_model.lingxi);
	
-- 	hp_exten:setString(string.format("%d",hp_var));
-- 	at_exten:setString(string.format("%d",at_var));
-- 	md_exten:setString(string.format("%d",md_var));
-- 	wd_exten:setString(string.format("%d",wd_var));
-- 	bj_exten:setString(string.format("%d",bj_var));

-- 	--速度加成要另外算
-- 	print("MountsWin:update_base_att",mounts_model.model_id);
-- 	local mount_config = MountsConfig:get_mount_data_by_id(mounts_model.model_id);
-- 	local speed = mount_config["moveSpeed"];
-- 	local speed_ex =  math.abs(900*900/(900+speed)-900);
-- 	seep_exten:setText(string.format("#ce0fcff+%d",speed_ex));

-- end
-- -- 根据是不是他人坐骑的标记来觉得要不要显示按钮、以及改变一些按钮的坐标
-- function MountsLingXiPanel:set_btns_visiable( is_other_mounts )
-- 	mounts_jinjie_tab:setIsVisible( not is_other_mounts );
-- 	mounts_xilian_tab:setIsVisible( not is_other_mounts );
-- 	huaxing_btn:setIsVisible( not is_other_mounts );
-- 	xuanyao_btn:setIsVisible( not is_other_mounts );
-- 	chengqi_btn:setIsVisible( not is_other_mounts );
-- 	if is_other_mounts then
-- 		mounts_info_tab:setPosition(44,312-22);
-- 		fightValue_lab:setPosition(44+65,7);

-- 		mounts_fight:setPosition(CCPointMake(40+127,7));
-- 	else
-- 		mounts_info_tab:setPosition(44,300);
-- 		fightValue_lab:setPosition(44+65,7)
-- 		mounts_fight:setPosition(CCPointMake(40+127,7))
-- 	end
-- end

-- -- 更新坐骑战斗力
-- function MountsLingXiPanel:change_mount_fight_value( fight_value )
-- 	if mounts_fight ~= nil then
-- 		mounts_fight:init(tostring(fight_value));
-- 	end
-- end

-- -- 修改坐骑形象
-- function MountsLingXiPanel:change_mounts_avatar(model_id)
	
-- 	if isNextMount then	
-- 		if MountsModel:get_mounts_info().jieji < 8 then
-- 			model_id = MountsModel:get_mounts_info().jieji+1;
-- 		else
-- 		 	model_id = MountsModel:get_mounts_info().jieji;
-- 		end
-- 	end

-- 	-- print("修改坐骑形象",model_id);

-- 	if mounts_avatar ~= nil then
-- 		-- mounts_avatar:removeFromParentAndCleanup(true)
-- 		self._mount_bg:removeChild(mounts_avatar,true);
-- 		mounts_avatar = nil
-- 	end
 
-- 	local mount_file = string.format("frame/mount/%d",model_id);
-- 	local action = {0,0,4,0.2};
	
-- 	local avatar_pos_y = 298/2 - 55;

-- 	mounts_avatar = MUtils:create_animation(389/2+10,avatar_pos_y,mount_file,action );
-- 	self._mount_bg:addChild(mounts_avatar,255)
	
-- 	local mount_config =  MountsConfig:get_mount_data_by_id(model_id);
-- 	mounts_name:setText(string.format("#cffff00%s",mount_config["name"]));

-- end


-- --显示下阶坐骑形象
-- function MountsLingXiPanel:showNextMount( bool )
-- 	isNextMount = bool;
-- 	next_mount:setIsVisible(bool);
-- 	mounts_name:setIsVisible(not bool);
-- 	fightValue_lab:setIsVisible(not bool);
-- 	mounts_fight:setIsVisible(not bool);
-- 	huaxing_btn:setIsVisible(not bool);
-- 	xuanyao_btn:setIsVisible(not bool);
-- 	chengqi_btn:setIsVisible(not bool);
	
-- 	if MountsModel:get_mounts_info() then
-- 		self:change_mounts_avatar(MountsModel:get_mounts_info().model_id);
-- 	end

-- end

-- --坐骑进阶的回调
-- function MountsLingXiPanel:jiejin_callback( current_jieji)
-- 	self:change_mounts_avatar(current_jieji);
-- end

-- --设置坐骑状态按钮显示
-- function MountsLingXiPanel:setMountsStatus( b )
-- 	if not b then
-- 		qi_title_status:setTexture(UI_MountsWinNew_022 )
-- 	else
-- 		qi_title_status:setTexture(UI_MountsWinNew_021 )
-- 	end
-- end

-- --计算基本属性的加成
-- function MountsLingXiPanel:calculate_attribute_add(base,percent)
-- 	return base*percent/100-base;
-- end

-- -- 更新灵犀值标签值
-- function MountsLingXiPanel:updateLingXiValueLabel( lingXiValue )
-- 	if lingXiValue == 150 then
-- 		self.lingxi_lab1:setText(LangGameString[1579]); -- [1579]="+150%#c38ff33(满)"
-- 		self.tishen_btn.view:setCurState(CLICK_STATE_DISABLE);
-- 		self.tishen_lab:setTexture( UI_MountsWinNew_038 )
-- 	else
-- 		local lingxi_str = string.format("+%d",lingXiValue).."%";
-- 		self.lingxi_lab1:setText(lingxi_str);
-- 	end
-- end

-- --xiehande
-- --播放灵犀特效
-- function MountsLingXiPanel:play_success_effect(  )
-- 	-- body
-- 	LuaEffectManager:play_view_effect( 10014,630,160,panel,false,999 )
-- end

-- function MountsLingXiPanel:destroy()
-- 	-- body
-- end