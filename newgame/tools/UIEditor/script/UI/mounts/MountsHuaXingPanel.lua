-- MountsJinJiePanel.lua 
-- createed by mwy @2012-5-2
-- 新建进阶页面,合并了旧版坐骑信息和坐骑进阶窗口的内容，不再是window


-- super_class.MountsHuaXingPanel(  )

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
-- -- local huaxing_btn = nil;

-- --乘骑按钮
-- local chengqi_btn = nil;

-- -- 生命增幅
-- local hp_exten = nil;
-- -- 法术防御增幅
-- local md_exten = nil;
-- -- 暴击增幅
-- local bj_exten = nil;
-- -- 攻击增幅
-- local at_exten = nil;
-- -- 物理防御增幅
-- local wd_exten = nil;
-- -- 移动速度增幅
-- local seep_exten = nil;
-- -- 底板
-- local panel=nil

-- local is_other_mounts = false;

-- function MountsHuaXingPanel:__init(pos_x,pos_y )
-- 	local pos_x = x or 0
--     local pos_y = y or 0
-- 	self.view = CCBasePanel:panelWithFile( pos_x, pos_y, 800+35, 386+147, UI_MountsWinNew_003, 500, 500 )

	
-- 	panel = self.view
-- 	-- 左面板
-- 	local _left_panel = CCBasePanel:panelWithFile( 11,13, 390+35, 510-2, UI_MountsWinNew_004, 500, 500 )
-- 	panel:addChild(_left_panel)
-- 	-- 右上面板
-- 	local _right_up_panel = CCBasePanel:panelWithFile( 404+35,  222,  390, 300-1, UI_MountsWinNew_004, 500, 500 )
-- 	panel:addChild(_right_up_panel)
-- 	self.avator_panel=_right_up_panel
-- 	-- 右下面板
-- 	local _right_down_panel = CCBasePanel:panelWithFile( 404+35, 13,390, 200+6, UI_MountsWinNew_004, 500, 500 )
-- 	panel:addChild(_right_down_panel)

-- 	-- 创建左面板内容
-- 	self:CreateLeftPanel(_left_panel)
-- 	-- 创建右面板内容
-- 	self:CreateRightPanel(_right_up_panel,_right_down_panel)

-- 	-- 最后刷新数据
-- 	self:update();
-- end

-- -- 创建左面板内容
-- function MountsHuaXingPanel:CreateLeftPanel(left_panel )
-- 	local mounts_model = MountsConfig:get_all_mounts_model(  )

-- 	self.equip_sell_scroll = self:create_scroll_area(mounts_model, 2, 2, 382+35, 496, 3, 7, "" )

-- 	left_panel:addChild( self.equip_sell_scroll )
-- end
-- -- 创建可拖动区域   参数：放入scroll的panel的集合, 坐标， 区域大小，列数，可见行数， 背景名称
-- function MountsHuaXingPanel:create_scroll_area( panel_table_para,pos_x, pos_y, size_w, size_h, colu_num, sight_num, bg_name)

-- 	local mount_index = 1
--     local row_num = math.ceil( #panel_table_para / colu_num )
--     if row_num < 3 then
--         row_num = 3
--     end

--     local scroll = CCScroll:scrollWithFile( pos_x, pos_y, size_w, size_h, row_num, bg_name, TYPE_HORIZONTAL, 600, 600 )

--     --scroll:setScrollLump( UIResourcePath.FileLocate.common .. "up_progress.png", UIResourcePath.FileLocate.common .. "down_progress.png", 4, 20, size_h / row_num )
--     -- print("@@@@@@@@@@@@@@@@@@@@@size_h / row_num=",size_h / row_num)
--     --scroll:setEnableCut(true)
--     local had_add_t = {}
--     local function scrollfun(eventType, args, msg_id)
--         if eventType == nil or args == nil or msg_id == nil then 
--             return
--         end
--         if eventType == TOUCH_BEGAN then
--             return true
--         elseif eventType == TOUCH_MOVED then
--             return true
--         elseif eventType == TOUCH_ENDED then
--             return true
--         elseif eventType == SCROLL_CREATE_ITEM then

--             local temparg = Utils:Split(args,":")
--             local x = temparg[1]              -- 行
--             local y = temparg[2]              -- 列

--             local index = x * colu_num--y * colu_num + x + 1

--             local bg = CCBasePanel:panelWithFile(0, 0, size_w, 120, nil)

--             for i = 1, colu_num do
            	

--             	local mounts_model= panel_table_para[mount_index]

--             	if mounts_model then
-- 	            	 mount_index=mount_index+1
-- 		            local sell_panel = MountsHuaXingPanel:create_one_scroll_sell_panel( mounts_model,16+ ( size_w / colu_num -10) * ( i - 1), 0, size_w / colu_num, size_h / row_num )
-- 	                bg:addChild( sell_panel )
--             	end
--             end

--             scroll:addItem(bg)
--             scroll:refresh()
--             return false
--         end
--     end
--     scroll:registerScriptHandler(scrollfun)
--     scroll:refresh()

--     return scroll
-- end

-- -- 创建一个 scroll 中的  出售panel
-- function MountsHuaXingPanel:create_one_scroll_sell_panel( panel_table_para ,x, y, w, h )
-- 	-- print("-----------mounts_model----------------",panel_table_para.name,panel_table_para.modelId)

--     local sell_panel_bg = CCBasePanel:panelWithFile( x, y , w, h , nil )
--     if panel_table_para == nil then
--         return sell_panel_bg
--     end
    
--     local _mountIconCell = mountIconCell(panel_table_para.modelId, 5, 5 )
--     sell_panel_bg:addChild( _mountIconCell.view )
    
--     return sell_panel_bg
-- end


-- -- 创建右面板内容
-- function MountsHuaXingPanel:CreateRightPanel(right_up_panel, right_down_panel )
-- 	-- body
-- 	local _right_up_panel= right_up_panel
-- 	local _right_down_panel = right_down_panel

-- 	-- 坐骑背景
-- 	self._mount_bg = CCBasePanel:panelWithFile( 1,1,390-2, 300-2, UI_MountsWinNew_015, 500, 500 )
-- 	_right_up_panel:addChild(self._mount_bg)

-- 	--坐骑名底色
-- 	local name_bg = CCZXImage:imageWithFile(114, 265,145,-1,UI_MountsWinNew_016,500,500)
-- 	self._mount_bg:addChild(name_bg)

-- 	-- 坐骑名字 	
-- 	mounts_name = UILabel:create_lable_2( "#cfff000白虎", 67, 6, 20, ALIGN_CENTER );
-- 	name_bg:addChild(mounts_name);

-- 	-- 化形按钮事件
-- 	local function huaxing_event()
-- 		if self.cur_model_id then
-- 			MountsModel:req_mount_huaxing( self.cur_model_id )			
-- 		end
--       local model = MountsModel:get_mounts_info();
-- 	  if model ~= nil then
-- 	    self.huaxing_btn.view:setCurState(CLICK_STATE_DISABLE);
-- 		self.tihuan_lab:setTexture(UI_MountsWinNew_035);
--       end
-- 		return true
-- 	end

-- 	local mount_info = MountsModel:get_mounts_info();
-- 	-- 化形按钮
-- 	self.huaxing_btn = ZButton:create(nil,UI_MountsWinNew_010,huaxing_event, 121, 10, -1, -1);
-- 	self.huaxing_btn:addImage( CLICK_STATE_DOWN, UI_MountsWinNew_010 );
-- 	self.huaxing_btn:addImage( CLICK_STATE_DISABLE, UI_MountsWinNew_034 );
-- 	self._mount_bg:addChild(self.huaxing_btn.view,256);

-- 	self.tihuan_lab = CCZXImage:imageWithFile(10, 14,-1,-1,UI_MountsWinNew_026,500,500);
-- 	self.huaxing_btn:addChild(self.tihuan_lab)

-- 	if not mount_info then
-- 		self.huaxing_btn.view:setCurState(CLICK_STATE_DISABLE);
-- 		self.tihuan_lab:setTexture(UI_MountsWinNew_035)
-- 	end

-- 	--切换上下马的状态
-- 	-- local function chengqi_event()
-- 	-- 	MountsModel:ride_a_mount();
-- 	-- 	self:setMountsStatus(MountsModel:get_is_shangma())
-- 	-- 	return true
-- 	-- end
-- 	-- -- 骑、休按钮
-- 	-- local qixing_btn = ZButton:create(nil,UI_MountsWinNew_023,chengqi_event,40,10,-1,-1);
-- 	-- self._mount_bg:addChild(qixing_btn.view,256);
-- 	-- self.qixing_btn_lab = CCZXImage:imageWithFile(7,10,-1,-1,UI_MountsWinNew_021,500,500)
-- 	-- qixing_btn:addChild(self.qixing_btn_lab)
-- 	-- self:setMountsStatus( MountsModel:get_is_shangma() )

-- 	-- local function xuanyao_event()	
-- 	-- 	MountsModel:req_xuanyao_event()
-- 	-- 	return true
-- 	-- end
-- 	-- -- 炫耀按钮
-- 	-- local xuanyao_btn = ZButton:create(nil,UI_MountsWinNew_023,xuanyao_event,295,10,-1,-1);
-- 	-- self._mount_bg:addChild(xuanyao_btn.view,256);
-- 	-- local xuanyao_btn_lab = CCZXImage:imageWithFile(7,10,-1,-1,UI_MountsWinNew_024,500,500)
-- 	-- xuanyao_btn:addChild(xuanyao_btn_lab)


-- 	--增加属性标题
-- 	local _left_down_title_panel = CCBasePanel:panelWithFile( 1, 177, 150, -1, UI_MountsWinNew_005, 500, 500 )
-- 	_right_down_panel:addChild(_left_down_title_panel)
-- 	local name_title = CCZXImage:imageWithFile(27, 4,-1,-1,UI_MountsWinNew_019,500,500)
-- 	_left_down_title_panel:addChild(name_title)

-- 	-- 字体背景2*3
-- 	for i=1,3 do
-- 		for j=1,2 do
-- 			local _attr_bg = CCBasePanel:panelWithFile( 93+(j-1)*190, 20+(i-1)*55, 100, -1, UI_MountsWinNew_006, 500, 500 )
-- 			_right_down_panel:addChild(_attr_bg)
-- 		end
-- 	end

-- 	-------------生命
-- 	local hp_lab = UILabel:create_lable_2( "#c0edc09生    命", 6, 135+2, 17, ALIGN_LEFT );
-- 	-- hp_lab:setAnchorPoint(CCPointMake(0,1));
-- 	_right_down_panel:addChild(hp_lab);

-- 	-- 生命增幅
-- 	-- local hp_s =  string.format("%d",mounts_model.att_hp);
-- 	hp_exten = UILabel:create_label_1("", CCSizeMake(87,20), 150,147, 17, CCTextAlignmentLeft, 255, 255, 255);
-- 	hp_exten:setAnchorPoint(CCPointMake(0,0));
-- 	_right_down_panel:addChild(hp_exten)


-- 	-- 精神防御
-- 	local md_lab = UILabel:create_lable_2( "#c0edc09精神防御", 6,85, 17, ALIGN_LEFT );
-- 	-- md_lab:setAnchorPoint(CCPointMake(0,1));
-- 	_right_down_panel:addChild(md_lab);

-- 	-- 精神防御增幅
-- 	-- local md_s =  string.format("%d",mounts_model.att_md);
-- 	md_exten = UILabel:create_label_1("", CCSizeMake(87,20), 150, 58-20+54, 17, CCTextAlignmentLeft, 255, 255, 255);
-- 	md_exten:setAnchorPoint(CCPointMake(0,0));
-- 	_right_down_panel:addChild(md_exten)

-- 	-- 暴击
-- 	local bj_lab = UILabel:create_lable_2( "#c0edc09暴    击", 6,27+2, 17, ALIGN_LEFT );
-- 	-- bj_lab:setAnchorPoint(CCPointMake(0,1));
-- 	_right_down_panel:addChild(bj_lab);
-- 	-- 底图

-- 	-- 暴击增幅
-- 	-- local bj_s =  string.format("%d",mounts_model.att_bj);
-- 	bj_exten = UILabel:create_label_1("", CCSizeMake(87,20), 150, 58-40+20, 17, CCTextAlignmentLeft, 255, 255, 255);
-- 	bj_exten:setAnchorPoint(CCPointMake(0,0));
-- 	_right_down_panel:addChild(bj_exten)


-- 	-- 攻击
-- 	local at_lab = UILabel:create_lable_2( "#c0edc09攻    击", 197,  135+2, 17, ALIGN_LEFT );
-- 	-- at_lab:setAnchorPoint(CCPointMake(0,1));
-- 	_right_down_panel:addChild(at_lab);
-- 	-- 攻击增幅
-- 	-- local at_s =  string.format("%d",mounts_model.att_attack);
-- 	at_exten = UILabel:create_label_1("", CCSizeMake(87,20), 335, 147, 17, CCTextAlignmentLeft, 255, 255, 255);
-- 	at_exten:setAnchorPoint(CCPointMake(0,0));
-- 	_right_down_panel:addChild(at_exten)


-- 	-- 物理防御
-- 	local wd_lab = UILabel:create_lable_2( "#c0edc09物理防御", 197,  85, 17, ALIGN_LEFT );
-- 	-- wd_lab:setAnchorPoint(CCPointMake(0,1));
-- 	_right_down_panel:addChild(wd_lab);

-- 	-- 物理防御增幅
-- 	-- local wd_s =  string.format("%d",mounts_model.att_wd);
-- 	wd_exten = UILabel:create_label_1("", CCSizeMake(87,20), 335,  58-20+54, 17, CCTextAlignmentLeft, 255, 255, 255);
-- 	wd_exten:setAnchorPoint(CCPointMake(0,0));
-- 	_right_down_panel:addChild(wd_exten)


-- 	local seep_lab = UILabel:create_lable_2( "#c0edc09移动速度", 197,  27+2, 17, ALIGN_LEFT );
-- 	-- seep_lab:setAnchorPoint(CCPointMake(0,1));
-- 	_right_down_panel:addChild(seep_lab);

-- 	-- 移动速度增幅
-- 	-- local speed = mount_config["moveSpeed"];
-- 	-- local speed_ex =  math.abs(900*900/(900+speed)-900);
-- 	seep_exten = UILabel:create_label_1(string.format(""), CCSizeMake(87,20), 335, 58-40+20, 17, CCTextAlignmentLeft, 56, 255, 51);
-- 	seep_exten:setAnchorPoint(CCPointMake(0,0));
-- 	_right_down_panel:addChild(seep_exten)
-- end

-- -- 更新界面
-- function MountsHuaXingPanel:update(  )
-- 	local model = MountsModel:get_mounts_info();
-- 	if model and self._mount_bg then 
-- 		--改变外观
-- 		self:change_mounts_avatar(model.model_id);
		
-- 		local mounts_config = MountsConfig:get_mount_data_by_id(model.jieji);

-- 		self:update_base_att(model);
-- 	end

-- end

-- -- 更新基础属性
-- function MountsHuaXingPanel:update_base_att( mounts_model )
-- 	-- body

-- 	--属性变成基础属性+灵犀加成

-- 	local hp_var =mounts_model.att_hp + self:calculate_attribute_add(mounts_model.att_hp,mounts_model.lingxi);
-- 	local at_var = mounts_model.att_attack+self:calculate_attribute_add(mounts_model.att_attack,mounts_model.lingxi);
-- 	local md_var = mounts_model.att_md+self:calculate_attribute_add(mounts_model.att_md,mounts_model.lingxi);
-- 	local wd_var = mounts_model.att_wd+self:calculate_attribute_add(mounts_model.att_wd,mounts_model.lingxi); 
-- 	local bj_var = mounts_model.att_bj+self:calculate_attribute_add(mounts_model.att_bj,mounts_model.lingxi);

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


-- -- 修改坐骑形象
-- function MountsHuaXingPanel:change_mounts_avatar(model_id)
-- 	local mounts_info = MountsModel:get_mounts_info();
-- 	if not mounts_info then
-- 		self.huaxing_btn.view:setCurState(CLICK_STATE_DISABLE);
-- 		self.tihuan_lab:setTexture(UI_MountsWinNew_035)
-- 	else

-- 		local curLev = mounts_info.jieji;
--         --xiehande
-- 		if model_id > curLev or mounts_info.model_id==model_id then
-- 			self.huaxing_btn.view:setCurState(CLICK_STATE_DISABLE);
-- 			self.tihuan_lab:setTexture(UI_MountsWinNew_035);
-- 		else
-- 			self.huaxing_btn.view:setCurState(CLICK_STATE_UP);
-- 			self.tihuan_lab:setTexture(UI_MountsWinNew_026);
-- 		end
-- 	end

-- 	if self.mounts_avatar ~= nil then
-- 		self.mounts_avatar:removeFromParentAndCleanup(true)
-- 		self.mounts_avatar = nil
-- 		--parent:removeChild(mounts_avatar,true);
-- 	end

-- 	local mount_file = string.format("frame/mount/%d",model_id);	

-- 	local action = {0,0,4,0.2};
	
-- 	local avatar_pos_y = 298/2-55;

-- 	self.mounts_avatar = MUtils:create_animation(388/2,avatar_pos_y,mount_file,action );
-- 	self.mounts_avatar:setAnchorPoint(0.5,0.5)
-- 	-- 设置当前的化形模型ID
-- 	self.cur_model_id = model_id;

-- 	self._mount_bg:addChild(self.mounts_avatar,255)

-- 	local mount_config =  MountsConfig:get_mount_data_by_id(model_id);

-- 	mounts_name:setText(string.format("#cffff00%s",mount_config["name"]));

-- end



-- --计算基本属性的加成
-- function MountsHuaXingPanel:calculate_attribute_add(base,percent)
	
-- 	return base*percent/100-base;
-- end

-- function MountsHuaXingPanel:setMountsStatus( b )
-- 	-- if( b ) then
-- 	-- 	self.qixing_btn_lab:setTexture( UI_MountsWinNew_021 )
-- 	-- else
-- 	-- 	self.qixing_btn_lab:setTexture( UI_MountsWinNew_022 )
-- 	-- end
-- end

-- function MountsHuaXingPanel:play_success_effect(  )
-- 	-- body
-- 	LuaEffectManager:play_view_effect( 403,630,360,panel,false,999 )
-- end

-- function MountsHuaXingPanel:destroy()
-- 	-- body
-- end