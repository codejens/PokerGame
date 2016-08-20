-- OtherMountsInfoPanel.lua 
-- createed by mwy @2012-5-2
-- 新建进阶页面,合并了旧版坐骑信息和坐骑进阶窗口的内容，不再是window

super_class.OtherMountsInfoPanel(  )

--是否处于下阶形象
local isNextMount = false;
-- 坐骑形象
local mounts_avatar = nil;
--战斗力文字图片
local fightValue_lab = nil;
-- 综合战斗力
local mounts_fight = nil;
-- 坐骑信息按钮
local mounts_info_tab = nil;
-- 坐骑进阶按钮
local mounts_jinjie_tab = nil;
-- 坐骑洗练按钮
local mounts_xilian_tab = nil;
-- 坐骑名字
local mounts_name = nil;
--下阶形象
local next_mount = nil;
--化形按钮
local huaxing_btn = nil;
--炫耀按钮
local xuanyao_btn = nil;
--乘骑按钮
local chengqi_btn = nil;

-- 生命增幅
local hp_exten = nil;
-- 法术防御增幅
local md_exten = nil;
-- 暴击增幅
local bj_exten = nil;
-- 攻击增幅
local at_exten = nil;
-- 物理防御增幅
local wd_exten = nil;
-- 移动速度增幅
local seep_exten = nil;

local is_other_mounts = false;


-- 进阶进度条
local jinjie_progress = nil;
-- 星星
local startLayer = nil;
-- 进阶符
local jinjiefu = nil;
local _open_one_key_50 = false;
-- 资质
-- 生命
local zz_hp_att = nil;
local zz_hp_max_value = nil;
-- 攻击
local zz_at_att = nil;
local zz_att_max_value = nil;
-- 法术防御
local zz_md_att = nil;
local zz_md_max_value = nil;
-- 物理防御
local zz_wd_att = nil;
local zz_wd_max_value = nil;
-- 暴击
local zz_bj_att = nil;
local zz_bj_max_value = nil;

-- 一键50次
local one_key_50 = nil; 

local cd_time_lab = nil
-- 底板
local panel=nil

local _right_down_panel=nil

local qi_title_status=nil

function OtherMountsInfoPanel:__init( pos_x,pos_y)

	-- local mounts_model = MountsModel:get_mounts_info()


	local pos_x = x or 0
    local pos_y = y or 0
	self.view = CCBasePanel:panelWithFile( pos_x, pos_y, 800+35, 386+147, UI_MountsWinNew_003, 500, 500 )

	-- 底板
	panel = self.view
	-- 左上
	local _left_up_panel = CCBasePanel:panelWithFile( 11, 222, 390, 300, UI_MountsWinNew_004, 500, 500 )
	panel:addChild(_left_up_panel)
	self.avator_panel=_left_up_panel
	-- 左下
	local _left_down_panel = CCBasePanel:panelWithFile( 10, 13, 390, 200+6, UI_MountsWinNew_004, 500, 500 )
	panel:addChild(_left_down_panel)
	-- 右上
	local _right_up_panel = CCBasePanel:panelWithFile( 404, 320-49, 390-4+35, 250, UI_MountsWinNew_004, 500, 500 )
	panel:addChild(_right_up_panel)
	-- 右下
	_right_down_panel = CCBasePanel:panelWithFile( 404, 13, 390-4+35, 255, UI_MountsWinNew_004, 500, 500 )
	panel:addChild(_right_down_panel)

	---------------------------------------左面板：坐骑属性--------------------------------------------


	-- 坐骑背景
	self._mount_bg = CCBasePanel:panelWithFile( 1,1,390-2, 300-2, UI_MountsWinNew_015, 500, 500 )
	_left_up_panel:addChild(self._mount_bg)


	--坐骑名底色
	local name_bg = CCZXImage:imageWithFile(114, 265,145,-1,UI_MountsWinNew_016,500,500)
	self._mount_bg:addChild(name_bg)

	-- 坐骑名字 	
	mounts_name = UILabel:create_lable_2( "#cfff000白虎", 67, 6, 20, ALIGN_CENTER );
	name_bg:addChild(mounts_name);


	--切换上下马的状态
	local function chengqi_event(eventType,x,y)
		if eventType == TOUCH_CLICK then
			MountsModel:ride_a_mount();	--修改model数据
			self:setMountsStatus(MountsModel:get_is_shangma())
			
			-- local mounts_win = UIManager:find_window("mounts_win_new")
			-- if mounts_win then
			-- 	mounts_win:changeQiXiuState("jinjie",MountsModel:get_is_shangma())
			-- end
		end
		return true
	end

	--乘骑按钮 
	-- chengqi_btn = CCNGBtnMulTex:buttonWithFile(10,9,-1,-1,UI_MountsWinNew_023);
	-- self._mount_bg:addChild(chengqi_btn);

	-- qi_title_status = CCZXImage:imageWithFile(7,10,-1,-1,UI_MountsWinNew_021,500,500)
	
	-- chengqi_btn:addChild(qi_title_status)

	-- chengqi_btn:registerScriptHandler(chengqi_event);
	--设置坐骑状态对于的按钮显示
	self:setMountsStatus(MountsModel:get_is_shangma())

	-- -- 化形按钮事件
	-- local function huaxing_event(eventType, x, y)	
	-- 	if eventType == TOUCH_CLICK then
	-- 		UIManager:show_window("mounts_huaxing_win");
	-- 	end
	-- 	return true
	-- end
	-- -- 化形按钮
	-- huaxing_btn = CCNGBtnMulTex:buttonWithFile(10,9,-1,-1,UIResourcePath.FileLocate.mount .. "button_mount_hua.png")
	-- _mount_bg:addChild(huaxing_btn)
	-- huaxing_btn:registerScriptHandler(huaxing_event)


	-- 炫耀按钮事件
	local function xuanyao_event(eventType, x, y)	
		if eventType == TOUCH_CLICK then
			MountsModel:req_xuanyao_event(  )
		end
		return true
	end

	-- 炫耀
	-- xuanyao_btn = CCNGBtnMulTex:buttonWithFile(300+7+10,9,-1,-1,UI_MountsWinNew_023,20,13)
	-- self._mount_bg:addChild(xuanyao_btn)

	-- local qi_title_status = CCZXImage:imageWithFile(8,10,-1,-1,UI_MountsWinNew_024,500,500)
	-- xuanyao_btn:addChild(qi_title_status)

	-- xuanyao_btn:registerScriptHandler(xuanyao_event)

	-- 战斗力
	local _power_bg = CCBasePanel:panelWithFile( 86-12,11,212+20+4, -1, UI_MountsWinNew_017, 500, 500 )
	self._mount_bg:addChild(_power_bg,256)
	-- 战斗力文字
	local _power_title = CCZXImage:imageWithFile(42,17,-1,-1,UI_MountsWinNew_018)
    _power_bg:addChild(_power_title)
    -- 战斗力值
	mounts_fight = ZXLabelAtlas:createWithString("99999",UIResourcePath.FileLocate.normal .. "number");
	mounts_fight:setPosition(CCPointMake(107,17));
	mounts_fight:setAnchorPoint(CCPointMake(0,0));
	_power_bg:addChild(mounts_fight);


	--增加属性标题
	local _left_down_title_panel = CCBasePanel:panelWithFile( 1, 177, 150, -1, UI_MountsWinNew_005, 500, 500 )
	_left_down_panel:addChild(_left_down_title_panel)
	local name_title = CCZXImage:imageWithFile(27, 4,-1,-1,UI_MountsWinNew_019,500,500)
	_left_down_title_panel:addChild(name_title)

	-- 字体背景2*3
	for i=1,3 do
		for j=1,2 do
			local _attr_bg = CCBasePanel:panelWithFile( 93+(j-1)*190, 20+(i-1)*55, 100, -1, UI_MountsWinNew_006, 500, 500 )
			_left_down_panel:addChild(_attr_bg)
		end
	end

	-------------生命
	local hp_lab = UILabel:create_lable_2( "#cffffff生    命", 6, 135+2, 17, ALIGN_LEFT );
	-- hp_lab:setAnchorPoint(CCPointMake(0,1));
	_left_down_panel:addChild(hp_lab);

	-- 生命增幅
	-- local hp_s =  string.format("%d",mounts_model.att_hp);
	hp_exten = UILabel:create_label_1("", CCSizeMake(87,20), 150,147, 17, CCTextAlignmentLeft, 255, 255, 255);
	hp_exten:setAnchorPoint(CCPointMake(0,0));
	_left_down_panel:addChild(hp_exten)


	-- 精神防御
	local md_lab = UILabel:create_lable_2( "#cffffff精神防御", 6,85, 17, ALIGN_LEFT );
	-- md_lab:setAnchorPoint(CCPointMake(0,1));
	_left_down_panel:addChild(md_lab);

	-- 精神防御增幅
	-- local md_s =  string.format("%d",mounts_model.att_md);
	md_exten = UILabel:create_label_1("", CCSizeMake(87,20), 150, 58-20+54, 17, CCTextAlignmentLeft, 255, 255, 255);
	md_exten:setAnchorPoint(CCPointMake(0,0));
	_left_down_panel:addChild(md_exten)


	-- 暴击
	local bj_lab = UILabel:create_lable_2( "#cffffff暴    击", 6,27+2, 17, ALIGN_LEFT );
	-- bj_lab:setAnchorPoint(CCPointMake(0,1));
	_left_down_panel:addChild(bj_lab);
	-- 底图

	-- 暴击增幅
	-- local bj_s =  string.format("%d",mounts_model.att_bj);
	bj_exten = UILabel:create_label_1("", CCSizeMake(87,20), 150, 58-40+20, 17, CCTextAlignmentLeft, 255, 255, 255);
	bj_exten:setAnchorPoint(CCPointMake(0,0));
	_left_down_panel:addChild(bj_exten)

	-- 攻击
	local at_lab = UILabel:create_lable_2( "#cffffff攻    击", 197,  135+2, 17, ALIGN_LEFT );
	-- at_lab:setAnchorPoint(CCPointMake(0,1));
	_left_down_panel:addChild(at_lab);
	-- 攻击增幅
	-- local at_s =  string.format("%d",mounts_model.att_attack);
	at_exten = UILabel:create_label_1("", CCSizeMake(87,20), 335, 147, 17, CCTextAlignmentLeft, 255, 255, 255);
	at_exten:setAnchorPoint(CCPointMake(0,0));
	_left_down_panel:addChild(at_exten)


	-- 物理防御
	local wd_lab = UILabel:create_lable_2( "#cffffff物理防御", 197,  85, 17, ALIGN_LEFT );
	-- wd_lab:setAnchorPoint(CCPointMake(0,1));
	_left_down_panel:addChild(wd_lab);

	-- 物理防御增幅
	-- local wd_s =  string.format("%d",mounts_model.att_wd);
	wd_exten = UILabel:create_label_1("", CCSizeMake(87,20), 335,  58-20+54, 17, CCTextAlignmentLeft, 255, 255, 255);
	wd_exten:setAnchorPoint(CCPointMake(0,0));
	_left_down_panel:addChild(wd_exten)


	local seep_lab = UILabel:create_lable_2( "#cffffff移动速度", 197,  27+2, 17, ALIGN_LEFT );
	-- seep_lab:setAnchorPoint(CCPointMake(0,1));
	_left_down_panel:addChild(seep_lab);

	-- 移动速度增幅
	-- local speed = mount_config["moveSpeed"];
	-- local speed_ex =  math.abs(900*900/(900+speed)-900);
	seep_exten = UILabel:create_label_1(string.format(""), CCSizeMake(87,20), 335, 58-40+20, 17, CCTextAlignmentLeft, 56, 255, 51);
	seep_exten:setAnchorPoint(CCPointMake(0,0));
	_left_down_panel:addChild(seep_exten)

	--------------------------------------------右上面板：资质属性--------------------------------------------
	-- 字体背景5个
	for i=1,5 do
		local _attr_bg = CCBasePanel:panelWithFile( 105, 15+(i-1)*36, 269, -1, UI_MountsWinNew_006, 500, 500 )
		_right_up_panel:addChild(_attr_bg)
	end

	-- 资质
	--增加属性标题
	local _right_up_title_panel = CCBasePanel:panelWithFile( 1, 220, 147, -1, UI_MountsWinNew_005, 500, 500 )
	_right_up_panel:addChild(_right_up_title_panel)
	local _name_title = CCZXImage:imageWithFile(27, 4,-1,-1,UI_MountsWinNew_039,500,500)
	_right_up_title_panel:addChild(_name_title)

	-- 当前属性
	local curr_attr = ZLabel:create( _right_up_panel, "#cfff000当前属性", 109, 196, 18 );

	-- 洗练上限值
	local xilian_limit = ZLabel:create( _right_up_panel, "#cfff000洗练上限值", 220, 196, 18 );

	-- [966]="生    命:"
	local hp_lab = ZLabel:create(_right_up_panel, LangGameString[966], 15, 167.5, 17, ALIGN_LEFT)
	-- 当前属性
	self.zz_hp_att = ZLabel:create(_right_up_panel," ", 150, 167, 17, ALIGN_CENTER)
	-- 上限值
	self.zz_hp_max_value = ZLabel:create( _right_up_panel, " ", 266, 167, 17, ALIGN_CENTER )

	-- [963]="攻    击:"
	local at_lab = ZLabel:create( _right_up_panel, LangGameString[963], 15, 131.5, 17, ALIGN_LEFT )
	-- 当前属性
	self.zz_at_att = ZLabel:create( _right_up_panel, " ", 150, 131, 17, ALIGN_CENTER )
	-- 上限值
	self.zz_att_max_value = ZLabel:create( _right_up_panel, " ", 266, 131, 17, ALIGN_CENTER )

	-- LangGameString[967]="精神防御"
	local md_lab = ZLabel:create( _right_up_panel, LangGameString[967], 15, 95.5, 17, ALIGN_LEFT )
	-- 当前属性
	self.zz_md_att = ZLabel:create( _right_up_panel, " ", 150, 95, 17, ALIGN_CENTER );
	-- 上限值
	self.zz_md_max_value = ZLabel:create( _right_up_panel, " ", 266, 95, 17, ALIGN_CENTER );

	-- [964]="物理防御:"
	local wd_lab = ZLabel:create( _right_up_panel, LangGameString[964], 15, 59.5, 17, ALIGN_LEFT );
	-- 当前属性
	self.zz_wd_att = ZLabel:create( _right_up_panel, " ", 150, 59, 17, ALIGN_CENTER );
	-- 上限值
	self.zz_wd_max_value = ZLabel:create(_right_up_panel," ", 266, 59, 17, ALIGN_CENTER );

	-- [1589]="暴    击:"
	local bj_lab = ZLabel:create( _right_up_panel, LangGameString[1589], 15, 23, 17, ALIGN_LEFT )
	-- 当前属性
	self.zz_bj_att = ZLabel:create( _right_up_panel, " ", 150, 23, 17, ALIGN_CENTER )
	-- 上限值
	self.zz_bj_max_value = ZLabel:create( _right_up_panel, " ", 266, 23, 17, ALIGN_CENTER )

	---------------------------------------右下面板资质------------------------------------------

	local pingjie_full_ex =10

	--增加属性标题
	local _right_down_title_panel = CCBasePanel:panelWithFile( 1, 220, 151, -1, UI_MountsWinNew_005, 500, 500 )
	_right_down_panel:addChild(_right_down_title_panel)
	local _name_title = CCZXImage:imageWithFile(27, 4,-1,-1, UI_MountsWinNew_036,500,500)
	_right_down_title_panel:addChild(_name_title)

	-- 品阶
	local pinjie_lab = ZLabel:create(nil,"等    阶:", 14, 191.5, 17, ALIGN_LEFT);
	_right_down_panel:addChild(pinjie_lab.view);
	self.pinjie_val = ZLabel:create(nil," ", 106, 191.5, 17, ALIGN_LEFT);
	_right_down_panel:addChild(self.pinjie_val.view);

	-- 星级
	local xingji_lab = ZLabel:create( nil, "星    级:", 14, 150.5, 17, ALIGN_LEFT );
	_right_down_panel:addChild(xingji_lab.view);

	-- 星星层 
	startLayer = CCLayerColor:layerWithColorWidthHeight(ccc4(0,0,0,0),254,360);
	startLayer:setPosition(CCPointMake(110,137));
	_right_down_panel:addChild(startLayer);
	local xiaopingjin = Utils:getIntPart((0*10)/pingjie_full_ex);
	self:drawStart(startLayer, xiaopingjin);

	-- 灵犀值
	local lingxi_lab = ZLabel:create( nil, "灵 犀 值:", 14, 109.5, 17, ALIGN_LEFT );
	_right_down_panel:addChild(lingxi_lab.view);
	self.lingxi_val = ZLabel:create( nil, LangGameString[1585], 106, 109.5, 17, ALIGN_LEFT );
	_right_down_panel:addChild(self.lingxi_val.view);

	local lingxi_tip = ZLabel:create(nil, "提示：灵犀丹在月华梦境里获得", 65, 31.5, 17, ALIGN_LEFT)
	_right_down_panel:addChild(lingxi_tip.view);

end

-- 绘制星星
function OtherMountsInfoPanel:drawStart(start_layer,start_count)
	-- 清楚所有星星
	start_layer:removeAllChildrenWithCleanup(true);
	for i=0,9 do
		local star = CCZXImage:imageWithFile(25*i,8,22,22,UIResourcePath.FileLocate.common .. "star_big.png");
		--star:addTexWithFile(CLICK_STATE_DISABLE, "ui/common/star_gray.png")
		star:setTag(i);
		startLayer:addChild(star);
		if i>(start_count-1) then 
			star:setCurState(CLICK_STATE_DISABLE);
		end
	end
end


-- 更新界面
function OtherMountsInfoPanel:update( model )
	if not model then
		return
	end

	--改变外观
	self:change_mounts_avatar(model.model_id);
	local mounts_config = MountsConfig:get_mount_data_by_id(model.jieji);
	local mounts_rate   = MountsConfig:getRate();

	self:change_mount_fight_value( model.fight )

	self:update_base_att(model);

	------------------------------更新坐骑资质---------------------------------


	-- 品阶的满经验
	local pingjie_full_ex = mounts_config["point"];
	-- 品阶里的星星颗数
	local xiaopingjin = Utils:getIntPart((model.jiezhi*10)/pingjie_full_ex);

	--更新品阶 [1581]="%d阶"
	self.pinjie_val:setText(string.format(LangGameString[1581], model.jieji));

	-- 更新星级
	self:drawStart(startLayer, xiaopingjin)

	-- 更新灵犀值
	self.lingxi_val:setText(model.lingxi .. "%")

    --更新资质
    -- +增幅资质
	local zizhi_base= mounts_config["base"];
	local currentPj = zizhi_base[xiaopingjin+1];

	local cur_hp = math.floor( model.zizhi_hp_exten * mounts_rate[1] );
	self.zz_hp_att:setText( tostring(cur_hp) );

	local cur_at = math.floor( model.zizhi_attack_exten * mounts_rate[2] );
	self.zz_at_att:setText( tostring(cur_at) );

	local cur_md = math.floor( model.zizhi_md_exten * mounts_rate[3] );
	self.zz_md_att:setText( tostring(cur_md) );

	local cur_wd = math.floor( model.zizhi_wd_exten * mounts_rate[4] );
	self.zz_wd_att:setText( tostring(cur_wd) );

	local cur_bj = math.floor( model.zizhi_bj_exten * mounts_rate[5] );
	self.zz_bj_att:setText( tostring(cur_bj) );

	-- 上限值
	local hp_max = math.floor( mounts_config.limit[1] * mounts_rate[1] );
	self.zz_hp_max_value:setText( "#ce519cb" .. hp_max );

	local at_max = math.floor( mounts_config.limit[2] * mounts_rate[2] );
	self.zz_att_max_value:setText( "#ce519cb" .. at_max );

	local md_max = math.floor( mounts_config.limit[3] * mounts_rate[3] );
	self.zz_md_max_value:setText( "#ce519cb" .. md_max );

	local wd_max = math.floor( mounts_config.limit[4] * mounts_rate[4] );
	self.zz_wd_max_value:setText( "#ce519cb" .. wd_max );

	local bj_max = math.floor( mounts_config.limit[5] * mounts_rate[5] );
	self.zz_bj_max_value:setText( "#ce519cb" .. bj_max );
end

-- 更新人物基础属性
function OtherMountsInfoPanel:update_base_att( mounts_model )
	local mounts_config = MountsConfig:get_mount_data_by_id(mounts_model.jieji);

	--属性变成基础属性+灵犀加成
	local hp_var =tonumber( mounts_model.att_hp )
	-- + self:calculate_attribute_add(mounts_model.att_hp,mounts_model.lingxi);
	local at_var = tonumber(mounts_model.att_attack)
	-- +self:calculate_attribute_add(mounts_model.att_attack,mounts_model.lingxi);
	local md_var = tonumber(mounts_model.att_md)
	-- +self:calculate_attribute_add(mounts_model.att_md,mounts_model.lingxi);
	local wd_var =tonumber( mounts_model.att_wd)
	-- +self:calculate_attribute_add(mounts_model.att_wd,mounts_model.lingxi); 
	local bj_var =tonumber( mounts_model.att_bj)
	-- +self:calculate_attribute_add(mounts_model.att_bj,mounts_model.lingxi);

	hp_exten:setString(string.format("%d",hp_var));
	at_exten:setString(string.format("%d",at_var));
	md_exten:setString(string.format("%d",md_var));
	wd_exten:setString(string.format("%d",wd_var));
	bj_exten:setString(string.format("%d",bj_var));

	--速度加成要另外算
	print("MountsWin:update_base_att",mounts_model.model_id);
	local mount_config = MountsConfig:get_mount_data_by_id(mounts_model.model_id);
	local speed = mount_config["moveSpeed"];
	local speed_ex =  math.abs(900*900/(900+speed)-900);
	seep_exten:setText(string.format("#ce0fcff+%d",speed_ex));

end
-- 根据是不是他人坐骑的标记来觉得要不要显示按钮、以及改变一些按钮的坐标
function OtherMountsInfoPanel:set_btns_visiable( is_other_mounts )
	mounts_jinjie_tab:setIsVisible( not is_other_mounts );
	mounts_xilian_tab:setIsVisible( not is_other_mounts );
	huaxing_btn:setIsVisible( not is_other_mounts );
	xuanyao_btn:setIsVisible( not is_other_mounts );
	chengqi_btn:setIsVisible( not is_other_mounts );
	if is_other_mounts then
		mounts_info_tab:setPosition(44,312-22);
		fightValue_lab:setPosition(44+65,7);

		mounts_fight:setPosition(CCPointMake(40+127,7));
	else
		mounts_info_tab:setPosition(44,300);
		fightValue_lab:setPosition(44+65,7)
		mounts_fight:setPosition(CCPointMake(40+127,7))
	end
end

-- 更新坐骑战斗力
function OtherMountsInfoPanel:change_mount_fight_value( fight_value )
	if mounts_fight ~= nil then
		mounts_fight:init(tostring(fight_value));
	end
end

-- 修改坐骑形象
function OtherMountsInfoPanel:change_mounts_avatar(model_id)
	
	if isNextMount then	
		if MountsModel:get_mounts_info().jieji < 8 then
			model_id = MountsModel:get_mounts_info().jieji+1;
		else
		 	model_id = MountsModel:get_mounts_info().jieji;
		end
	end

	-- print("修改坐骑形象",model_id);

	if self.mounts_avatar ~= nil then
		self.mounts_avatar:removeFromParentAndCleanup(true)
		self.mounts_avatar = nil
		--parent:removeChild(mounts_avatar,true);
	end
 
	local mount_file = string.format("frame/mount/%d",model_id);
	local action = {0,0,4,0.2};
	
	local avatar_pos_y = 298/2 - 55;

	self.mounts_avatar = MUtils:create_animation(389/2+10,avatar_pos_y,mount_file,action );
	self._mount_bg:addChild(self.mounts_avatar,255)
	
	local mount_config =  MountsConfig:get_mount_data_by_id(model_id);
	mounts_name:setText(string.format("#cffff00%s",mount_config["name"]));

end


--显示下阶坐骑形象
function OtherMountsInfoPanel:showNextMount( bool )
	isNextMount = bool;
	next_mount:setIsVisible(bool);
	mounts_name:setIsVisible(not bool);
	fightValue_lab:setIsVisible(not bool);
	mounts_fight:setIsVisible(not bool);
	huaxing_btn:setIsVisible(not bool);
	xuanyao_btn:setIsVisible(not bool);
	chengqi_btn:setIsVisible(not bool);
	
	if MountsModel:get_mounts_info() then
		self:change_mounts_avatar(MountsModel:get_mounts_info().model_id);
	end
end

--坐骑进阶的回调
function OtherMountsInfoPanel:jiejin_callback( current_jieji)
	self:change_mounts_avatar(current_jieji);
end

--计算基本属性的加成
function OtherMountsInfoPanel:calculate_attribute_add(base,percent)
	
	return base*percent/100-base;
end

--设置坐骑状态按钮显示
function OtherMountsInfoPanel:setMountsStatus( b )
	if not b then
		-- chengqi_btn:addTexWithFile(CLICK_STATE_UP,UI_MountsWinNew_023);
		-- chengqi_btn:setCurState(CLICK_STATE_UP)
		-- qi_title_status:setTexture(UI_MountsWinNew_022)
	else
		-- chengqi_btn:addTexWithFile(CLICK_STATE_UP,UI_MountsWinNew_023);
		-- chengqi_btn:setCurState(CLICK_STATE_UP)
		-- qi_title_status:setTexture(UI_MountsWinNew_021)
	end
end