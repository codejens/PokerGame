-- MountsXiLianPanel.lua 
-- createed by mwy @2012-5-2
-- refactored by guozhinan @2014-9-25
-- 坐骑洗炼页面

super_class.MountsXiLianPanel(  )

local pos_dict = {
	 {285, 140-80 },--生命
	 {125, 358-80 },--查克拉
	 {210, 391-80 },--攻击 
	 {290, 358-80 }, 
	 {340, 288-80 },
	 {335, 203-80 }, 
	 {77,  288-80 }, 
	 {205, 115-80  },
	 {132, 140-80 },
	 {80,  203-80 }
};

--"生命","查克拉","攻击","查克拉","精神防御","忍币","物理防御","忍币","暴击","银两"
local attri_dict = {
Lang.mounts.xilian_panel[1],
Lang.mounts.xilian_panel[2],
Lang.mounts.xilian_panel[3],
Lang.mounts.xilian_panel[4],
Lang.mounts.xilian_panel[5],
Lang.mounts.xilian_panel[6],
Lang.mounts.xilian_panel[7],
Lang.mounts.xilian_panel[8],
Lang.mounts.xilian_panel[9],
Lang.mounts.xilian_panel[10],
};

function MountsXiLianPanel:create_left_up_panel(x, y, width, height,texture_path)
	self.left_up_panel = CCBasePanel:panelWithFile( x, y, width, height,texture_path, 500, 500 )
	self.view:addChild(self.left_up_panel)

	-- 战斗力文字
	local power_title = CCZXImage:imageWithFile(20,height - 47,-1,-1,UILH_MOUNT.zhandouli)
    self.left_up_panel:addChild(power_title)
    -- 战斗力值
    local function get_num_ima( one_num )
        return string.format("ui/lh_other/number2_%d.png",one_num);
    end
    self.mounts_fight = ImageNumberEx:create("0",get_num_ima,16)
    self.mounts_fight.view:setPosition(CCPointMake(112,height - 32))
    self.left_up_panel:addChild( self.mounts_fight.view )

	--增加属性标题
	local left_down_title_panel = CCBasePanel:panelWithFile( 2, 182, 218, 34, UILH_NORMAL.title_bg4, 500, 500 )
	self.left_up_panel:addChild(left_down_title_panel)
	MUtils:create_zxfont(left_down_title_panel,Lang.mounts.info_panel[1],218/2,11,2,15);

	local x = 35
	local top_y = 140
	local row_space = 38
	local font_size = 17
	--生命
	local hp_lab = ZLabel:create( self.left_up_panel, Lang.mounts.user_attr.hp, x, top_y, font_size, ALIGN_LEFT )
	-- 生命增幅
	self.hp_exten_all = ZLabel:create( self.left_up_panel, "", x+100, top_y, font_size, ALIGN_LEFT )

	-- 攻击
	top_y = top_y - row_space;
	local at_lab = ZLabel:create( self.left_up_panel, Lang.mounts.user_attr.attack, x,  top_y, font_size, ALIGN_LEFT )
	-- 攻击增幅
	self.at_exten_all = ZLabel:create( self.left_up_panel, "", x+100, top_y, font_size, ALIGN_LEFT )

	-- 暴击
	top_y = top_y - row_space;
	local bj_lab = ZLabel:create( self.left_up_panel, Lang.mounts.user_attr.criticalStrikes, x, top_y, font_size, ALIGN_LEFT )
	-- 暴击增幅
	self.bj_exten_all = ZLabel:create( self.left_up_panel, "", x+100, top_y, font_size, ALIGN_LEFT )

	-- 物理防御
	top_y = top_y - row_space;
	local wd_lab = ZLabel:create( self.left_up_panel, Lang.mounts.user_attr.outDefence, x,  top_y, font_size, ALIGN_LEFT )
	-- 物理防御增幅
	self.wd_exten_all = ZLabel:create( self.left_up_panel, "", x+100, top_y, font_size, ALIGN_LEFT )

	-- 精神防御
	top_y = top_y - row_space;
	local md_lab = ZLabel:create( self.left_up_panel, Lang.mounts.user_attr.innerDefence, x, top_y, font_size, ALIGN_LEFT )
	-- 精神防御增幅
	self.md_exten_all = ZLabel:create( self.left_up_panel, "", x+100, top_y, font_size, ALIGN_LEFT )

	-- 移动速度
	top_y = top_y - row_space;
	local seep_lab = ZLabel:create( self.left_up_panel, Lang.mounts.user_attr.moveSpeed, x,  top_y, font_size, ALIGN_LEFT )
	-- 移动速度增幅
	self.seep_exten_all = ZLabel:create( self.left_up_panel, "", x+100, top_y, font_size, ALIGN_LEFT )

end

function MountsXiLianPanel:create_middle_up_panel(x, y, width, height,texture_path)
	self.middle_up_panel = CCBasePanel:panelWithFile( x, y, width, height,texture_path, 500, 500 )
	self.view:addChild(self.middle_up_panel,100)

	-- 背景底盘
	local bg1 = CCZXImage:imageWithFile(49, 35, 158, 318, UILH_MOUNT.xilian_bg, 0, 0 )
	self.middle_up_panel:addChild(bg1)	
	local bg2 = CCZXImage:imageWithFile(207, 35, 158, 318, UILH_MOUNT.xilian_bg, 0, 0 )
	bg2:setFlipX(true)
	self.middle_up_panel:addChild(bg2)

	-- 龙图
	local bg_dragon = CCZXImage:imageWithFile(width/2, height/2, 174, 174, UILH_MOUNT.bg_dragon, 0, 0 )
	bg_dragon:setAnchorPoint(0.5,0.5)
	self.middle_up_panel:addChild(bg_dragon)

	-- 创建圆形背景
	local center_y = width/2
	local round_panel_config =
	{
		[1] = {img = UILH_MOUNT.btn_blue, x = width/2, y = 330, text = Lang.mounts.xilian_panel[3]},
		[2] = {img = UILH_MOUNT.btn_gray, x = width/2-82, y = 301, text = Lang.mounts.xilian_panel[2]},
		[3] = {img = UILH_MOUNT.btn_gray, x = width/2+82, y = 301, text = Lang.mounts.xilian_panel[2]},
		[4] = {img = UILH_MOUNT.btn_purple, x = width/2-130, y = 230, text = Lang.mounts.xilian_panel[7]},
		[5] = {img = UILH_MOUNT.btn_green, x = width/2+130, y = 230, text = Lang.mounts.xilian_panel[5]},
		[6] = {img = UILH_MOUNT.btn_gray, x = width/2-127, y = 144, text = Lang.mounts.xilian_panel[10]},
		[7] = {img = UILH_MOUNT.btn_gray, x = width/2+127, y = 144, text = Lang.mounts.xilian_panel[6]},
		[8] = {img = UILH_MOUNT.btn_yellow, x = width/2-76, y = 82, text = Lang.mounts.xilian_panel[9]},
		[9] = {img = UILH_MOUNT.button_red, x = width/2+76, y = 82, text = Lang.mounts.xilian_panel[1]},
		[10] = {img = UILH_MOUNT.btn_gray, x = width/2, y = 55, text = Lang.mounts.xilian_panel[8]},
	}
	for i=1,10 do
		local round_img = CCZXImage:imageWithFile(round_panel_config[i].x, round_panel_config[i].y, -1, -1, round_panel_config[i].img)
		round_img:setAnchorPoint(0.5,0.5)
		MUtils:create_zxfont(round_img, round_panel_config[i].text,83/2,40,2,16)
		self.middle_up_panel:addChild(round_img)
	end

	--属性lab
	local xiLianAward = MountsConfig:getXilianAward();
	-- local mounts_rate = MountsConfig:getRate();
	pos_dict[1][3]  = xiLianAward[1];
	pos_dict[2][3]  = xiLianAward[6];
	pos_dict[3][3]  = xiLianAward[2];
	pos_dict[4][3]  = xiLianAward[7];
	pos_dict[5][3]  = xiLianAward[3];
	pos_dict[6][3]  = xiLianAward[8];
	pos_dict[7][3]  = xiLianAward[4];
	pos_dict[8][3]  = xiLianAward[9];
	pos_dict[9][3]  = xiLianAward[5];
	pos_dict[10][3] = xiLianAward[10];
	for i=1,10 do
		if i%2 ~= 0 then
			-- i：1、3、5、7、9:分别对应rate数组的1、2、3、4、5
			-- local mod = math.ceil(i/2);
			-- local val = mounts_rate[mod] * pos_dict[i][3];
			-- local p1  = math.floor( val );-- 取整数部分
			-- local p2  = math.floor((val - p1)/0.1) * 0.1; -- 取小数部分第1位的值
			-- local p3  = p1 + p2; -- 合成
			local add_attri_lab = UILabel:create_lable_2( "+" .. pos_dict[1][3], pos_dict[i][1], pos_dict[i][2], 14, ALIGN_CENTER );
			self.middle_up_panel:addChild(add_attri_lab);
		else
			local add_attri_lab = UILabel:create_lable_2( "+"..pos_dict[i][3], pos_dict[i][1], pos_dict[i][2], 14, ALIGN_CENTER );
			self.middle_up_panel:addChild(add_attri_lab);
		end
	end
end

function MountsXiLianPanel:create_right_up_panel(x, y, width, height,texture_path)
	self.right_up_panel = CCBasePanel:panelWithFile( x, y, width, height, texture_path, 500, 500 )
	self.view:addChild(self.right_up_panel,100)

	-- 资质标题
	local title_panel = CCBasePanel:panelWithFile( 6, 351, width-12, 34, UILH_NORMAL.title_bg4, 500, 500 )
	self.right_up_panel:addChild(title_panel)
	MUtils:create_zxfont(title_panel,Lang.mounts.info_panel[6],width/2,11,2,15);

	-- 资质属性,一开始设置虚拟数据，之后刷新
	local currentPj = {"0","0","0","0","0"}
	local standard_x = 55;
	local top_y = 320;
	local row_space = 63;
	local attr_offset = 88
	local exten_offset = 115
	local max_value_offset_x = 100
	local max_value_offset_y = -20;
	local zizhi_font_size = 16	
	-- 生命
	local hp_lab = UILabel:create_label_1(Lang.mounts.user_attr.hp, CCSizeMake(80,20), standard_x, top_y+2 , zizhi_font_size, CCTextAlignmentLeft);
	hp_lab:setAnchorPoint(CCPointMake(0,0));
	self.right_up_panel:addChild(hp_lab);
	-- 基本资质
	self.hp_att = UILabel:create_lable_2(currentPj[1], standard_x + attr_offset, top_y-8, zizhi_font_size, ALIGN_RIGHT );--UILabel:create_label_1(string.format("%d",currentPj[1]), CCSizeMake(37,20), 13+69+29-20, 96+2+11, 13, CCTextAlignmentRight, 255, 255, 255);
	self.hp_att:setAnchorPoint(CCPointMake(0,0));
	self.right_up_panel:addChild(self.hp_att);
	-- 增幅资质
	self.hp_exten = UILabel:create_label_1("0", CCSizeMake(50,20), standard_x + exten_offset, top_y, zizhi_font_size, CCTextAlignmentLeft, 255, 102 ,204);
	self.hp_exten:setAnchorPoint(CCPointMake(0,0));
	self.right_up_panel:addChild(self.hp_exten);
	-- 最大值
	self.hp_max_value = UILabel:create_label_1(Lang.mounts.jinjie_panel[11], CCSizeMake(120,20), standard_x + max_value_offset_x, top_y + max_value_offset_y, zizhi_font_size, CCTextAlignmentLeft);
	self.hp_max_value:setAnchorPoint(CCPointMake(0,0));
	self.right_up_panel:addChild(self.hp_max_value);

	-- 攻击
	top_y = top_y - row_space
	local at_lab = UILabel:create_label_1(Lang.mounts.user_attr.attack, CCSizeMake(80,20), standard_x, top_y+2 , zizhi_font_size, CCTextAlignmentLeft);
	at_lab:setAnchorPoint(CCPointMake(0,0));
	self.right_up_panel:addChild(at_lab);
	-- 基本资质
	self.at_att = UILabel:create_lable_2(currentPj[2], standard_x + attr_offset, top_y-7, zizhi_font_size, ALIGN_RIGHT );
	self.at_att:setAnchorPoint(CCPointMake(0,0));
	self.right_up_panel:addChild(self.at_att);
	-- 增幅资质
	self.at_exten = UILabel:create_label_1("0", CCSizeMake(50,20), standard_x + exten_offset, top_y, zizhi_font_size, CCTextAlignmentLeft, 255, 102 ,204);
	self.at_exten:setAnchorPoint(CCPointMake(0,0));
	self.right_up_panel:addChild(self.at_exten);
	-- 最大值
	self.att_max_value = UILabel:create_label_1(Lang.mounts.jinjie_panel[11], CCSizeMake(120,20), standard_x + max_value_offset_x, top_y + max_value_offset_y , zizhi_font_size, CCTextAlignmentLeft);
	self.att_max_value:setAnchorPoint(CCPointMake(0,0));
	self.right_up_panel:addChild(self.att_max_value);

	-- 法术防御
	top_y = top_y - row_space
	local md_lab = UILabel:create_label_1(Lang.mounts.user_attr.innerDefence, CCSizeMake(80,20), standard_x, top_y+2 , zizhi_font_size, CCTextAlignmentLeft);
	md_lab:setAnchorPoint(CCPointMake(0,0));
	self.right_up_panel:addChild(md_lab);
	-- 基本资质
	self.md_att = UILabel:create_lable_2(currentPj[3], standard_x + attr_offset, top_y-7, zizhi_font_size, ALIGN_RIGHT );
	self.md_att:setAnchorPoint(CCPointMake(0,0));
	self.right_up_panel:addChild(self.md_att);
	-- 增幅资质
	self.md_exten = UILabel:create_label_1("0", CCSizeMake(50,20), standard_x + exten_offset, top_y, zizhi_font_size, CCTextAlignmentLeft, 255, 102 ,204);
	self.md_exten:setAnchorPoint(CCPointMake(0,0));
	self.right_up_panel:addChild(self.md_exten);
	-- 最大值
	self.md_max_value = UILabel:create_label_1(Lang.mounts.jinjie_panel[11], CCSizeMake(120,20), standard_x + max_value_offset_x, top_y + max_value_offset_y , zizhi_font_size, CCTextAlignmentLeft);
	self.md_max_value:setAnchorPoint(CCPointMake(0,0));
	self.right_up_panel:addChild(self.md_max_value);

	-- 物理防御
	top_y = top_y - row_space
	local wd_lab = UILabel:create_label_1(Lang.mounts.user_attr.outDefence, CCSizeMake(80,20), standard_x, top_y+2 , zizhi_font_size, CCTextAlignmentLeft);
	wd_lab:setAnchorPoint(CCPointMake(0,0));
	self.right_up_panel:addChild(wd_lab);
	-- 基本资质
	self.wd_att = UILabel:create_lable_2(currentPj[4], standard_x + attr_offset, top_y-7, zizhi_font_size, ALIGN_RIGHT );
	self.wd_att:setAnchorPoint(CCPointMake(0,0));
	self.right_up_panel:addChild(self.wd_att);
	-- 增幅资质
	self.wd_exten = UILabel:create_label_1("0", CCSizeMake(50,20), standard_x + exten_offset, top_y, zizhi_font_size, CCTextAlignmentLeft, 255, 102 ,204);
	self.wd_exten:setAnchorPoint(CCPointMake(0,0));
	self.right_up_panel:addChild(self.wd_exten);
	-- 最大值
	self.wd_max_value = UILabel:create_label_1(Lang.mounts.jinjie_panel[11], CCSizeMake(120,20), standard_x + max_value_offset_x, top_y + max_value_offset_y , zizhi_font_size, CCTextAlignmentLeft);
	self.wd_max_value:setAnchorPoint(CCPointMake(0,0));
	self.right_up_panel:addChild(self.wd_max_value);

	-- 暴击
	top_y = top_y - row_space
	local bj_lab = UILabel:create_label_1(Lang.mounts.user_attr.criticalStrikes, CCSizeMake(80,20), standard_x, top_y+2 , zizhi_font_size, CCTextAlignmentLeft);
	bj_lab:setAnchorPoint(CCPointMake(0,0));
	self.right_up_panel:addChild(bj_lab);
	-- 基本资质
	self.bj_att = UILabel:create_lable_2(currentPj[5], standard_x + attr_offset, top_y-7, zizhi_font_size, ALIGN_RIGHT );
	self.bj_att:setAnchorPoint(CCPointMake(0,0));
	self.right_up_panel:addChild(self.bj_att);
	-- 增幅资质
	self.bj_exten = UILabel:create_label_1("0", CCSizeMake(50,20), standard_x + exten_offset, top_y, zizhi_font_size, CCTextAlignmentLeft, 255, 102 ,204);
	self.bj_exten:setAnchorPoint(CCPointMake(0,0));
	self.right_up_panel:addChild(self.bj_exten);
	--最大值
	self.bj_max_value = UILabel:create_label_1(Lang.mounts.jinjie_panel[11], CCSizeMake(120,20), standard_x + max_value_offset_x, top_y + max_value_offset_y , zizhi_font_size, CCTextAlignmentLeft);
	self.bj_max_value:setAnchorPoint(CCPointMake(0,0));
	self.right_up_panel:addChild(self.bj_max_value);	
end

function MountsXiLianPanel:create_bottom_panel(x, y, width, height,texture_path)
	self.bottom_panel = CCBasePanel:panelWithFile( x, y, width, height,texture_path, 500, 500 )
	self.view:addChild(self.bottom_panel,100)	

	-- 四个花纹装饰
	local edge_pattern = CCZXImage:imageWithFile(6, height-48,-1,-1,UILH_PRIVATE.head_lace);
	edge_pattern:setFlipX(true)	
	self.bottom_panel:addChild(edge_pattern)
	edge_pattern = CCZXImage:imageWithFile(6, 8,-1,-1,UILH_PRIVATE.head_lace);
	edge_pattern:setFlipX(true)
	edge_pattern:setFlipY(true)
	self.bottom_panel:addChild(edge_pattern)
	edge_pattern = CCZXImage:imageWithFile(width-48, height-48,-1,-1,UILH_PRIVATE.head_lace);
	self.bottom_panel:addChild(edge_pattern)
	edge_pattern = CCZXImage:imageWithFile(width-48, 8,-1,-1,UILH_PRIVATE.head_lace);
	edge_pattern:setFlipY(true)	
	self.bottom_panel:addChild(edge_pattern)	

	-- 三个洗练按钮
    local begin_x = 170
    local begin_y = 30
    local column_space = 205
	-- 铜币洗炼
	local function btn_XB_fun(eventType,x,y)
		if eventType == TOUCH_CLICK then
			-- 铜币洗炼
			MountsModel:req_mount_xilian( 1 )
		end
		return true
	end
	self.xb_xilian_btn= MUtils:create_btn(self.bottom_panel,UILH_COMMON.btn4_nor,UILH_COMMON.btn4_sel,btn_XB_fun,begin_x,begin_y,121,53)
	MUtils:create_zxfont(self.xb_xilian_btn, Lang.mounts.xilian_panel[14],121/2,15+5,2,16)

	-- 元宝洗炼
	local function btn_YB_fun(eventType,x,y)
		if eventType == TOUCH_CLICK then
			MountsModel:req_mount_xilian( 2 ) -- 元宝洗炼
		end
		return true
	end
	self.yb_20_xilian_btn=MUtils:create_btn(self.bottom_panel,UILH_COMMON.btn4_nor,UILH_COMMON.btn4_sel,btn_YB_fun,begin_x + column_space,begin_y,121,53)
	self.ybxl_label = MUtils:create_zxfont( self.yb_20_xilian_btn,Lang.mounts.xilian_panel[15],121/2,15+5,2,16)

	-- 元宝洗炼
	local function btn_5wYB_fun(eventType,x,y)
		if eventType == TOUCH_CLICK then
			MountsModel:req_mount_xilian( 3 )
		end
		return true
	end
	self.yb_5W_xilian_btn=MUtils:create_btn(self.bottom_panel,UILH_COMMON.btn4_nor,UILH_COMMON.btn4_sel,btn_5wYB_fun,begin_x + column_space*2,begin_y,121,53)
	MUtils:create_zxfont( self.yb_5W_xilian_btn,Lang.mounts.xilian_panel[11],121/2,15+5,2,16)

	local xianbixilian_price = MountsConfig:get_xianbixilian_price();
	local yuanbaoxilian_price= MountsConfig:get_yuanbaoxilian_price();
	MUtils:create_zxfont(self.xb_xilian_btn,Lang.mounts.xilian_panel[16].."#cfff000" .. xianbixilian_price,121/2,-20,2,15)	-- [2]=铜币
	-- Lang.mounts.xilian_panel[12] = "#cfff000(双倍效果)"
	MUtils:create_zxfont(self.yb_20_xilian_btn,Lang.mounts.xilian_panel[17].."#cfff000" .. yuanbaoxilian_price,121/2,-20,2,15)
	MUtils:create_zxfont(self.yb_5W_xilian_btn,Lang.mounts.xilian_panel[17].."#cfff000" .. yuanbaoxilian_price*10,121/2,-20,2,15)

	MUtils:create_zxfont(self.bottom_panel,Lang.mounts.xilian_panel[18],width/2,89,2,15)
end

function MountsXiLianPanel:__init()
	self.view = CCBasePanel:panelWithFile( 5, 8, 890, 518, UILH_COMMON.normal_bg_v2, 500, 500 )

	-- 左边的背景
	local left_bg = CCBasePanel:panelWithFile( 10, 120, 224, 390, UILH_COMMON.bottom_bg, 500, 500 )
	self.view:addChild(left_bg)

	-- 左上的人物战斗力和属性信息
	self:create_left_up_panel(11, 224, 233, 280, nil)

	-- 中间上方的洗练主体区域
	self:create_middle_up_panel(233, 120, 419, 390,UILH_COMMON.bottom_bg)

	-- 右上的资质
	self:create_right_up_panel(650, 120, 230, 390,UILH_COMMON.bottom_bg)		

	-- 下方洗练按钮
	self:create_bottom_panel(10, 8, 870, 113, UILH_COMMON.bottom_bg)	

	self:update()
end

-- 播放洗练特效
function MountsXiLianPanel:show_attri_add_effect( index, value )
	-- 特效生成器
	local effectManager = ZXEffectManager:sharedZXEffectManager();

	local p_x = pos_dict[index][1]
	local p_y=  pos_dict[index][2]+15

	-- 如果资质是:生命、攻击、物防、精防、暴击之一,则需要进行数值折算
	-- if index and index % 2 ~= 0 then
	-- 	local mounts_rate = MountsConfig:getRate();
	-- 	local mod = math.ceil( index/2 );
	-- 	value     = mounts_rate[mod] * value;
	-- 	local p1  = math.floor( value );-- 取整数部分
	-- 	local p2  = math.floor((value - p1)/0.1) * 0.1; -- 取小数部分第1位的值
	-- 	value     = p1 + p2; -- 合成
	-- end

	effectManager:run_mount_xilian_action("frame/effect/jm/46","frame/effect/jm/47",self.middle_up_panel, 430/2, 500/2,p_x, p_y,0.5);

	if value == 0 then
		-- [13] = "资质已达上限"
		GlobalFunc:create_screen_notic( attri_dict[index]..Lang.mounts.xilian_panel[13], 14, 
									    pos_dict[index][1]+275, 
									    pos_dict[index][2] ,
									    5 );
	else
		GlobalFunc:create_screen_notic( attri_dict[index].."+"..value, 14, 
									    pos_dict[index][1]+275, 
									    pos_dict[index][2],
									    5 );
	end
end

-- 洗练事件的回调
function MountsXiLianPanel:xianlin_event_callback( xilian_result )
	
	local mounts_model = MountsModel:get_mounts_info();
	if not mounts_model then
		return
	end

	local mounts_config = MountsConfig:get_mount_data_by_id(mounts_model.jieji);

	for k,v in pairs( xilian_result ) do
		local index ;
		if k == 1 then
			index = 1;
			if mounts_model.zizhi_hp_exten >= mounts_config.limit[1] then
				v = 0;
			end
		elseif k == 2 then
			index = 3;
			if mounts_model.zizhi_attack_exten >= mounts_config.limit[2] then
				v = 0;
			end
		elseif k == 3 then
			index = 5;
			if mounts_model.zizhi_md_exten >= mounts_config.limit[3] then
				v = 0;
			end
		elseif k == 4 then
			index = 7;
			if mounts_model.zizhi_wd_exten >= mounts_config.limit[4] then
				v = 0;
			end
		elseif k == 5 then
			index = 9;
			if mounts_model.zizhi_bj_exten >= mounts_config.limit[5] then
				v = 0;
			end
		elseif k == 6 then
			index = 2;
		elseif k == 7 then
			index = 4;
		elseif k == 8 then
			index = 6;
		elseif k == 9 then
			index = 8;
		elseif k == 10 then
			index = 10;
		-- elseif k == 11 then
		-- 	--当天剩余免费洗练次数
		-- 	mounts_model.xl_left_times=v
		-- elseif k == 12 then
		-- 	--下次免费洗练CD时间
		-- 	mounts_model.xl_next_cdtimes=v
		-- 	mounts_model.xl_start_time  =os.time()

		-- 	-- mounts_model.xl_next_cdtimes_endtime = os.clock()+mounts_model.xl_next_cdtimes;	--cd的终止时间
        print("MountXiLianWin,坐骑洗炼",k,v);
		end 

		if(v~=0) and (index) then
			self:show_attri_add_effect( index, v );  
			self:update(  )
		end	

	end
	-- 播放洗练特效
	-- 
end

-- 更新界面
function MountsXiLianPanel:update(  )
	local model = MountsModel:get_mounts_info();
	if model then 
		-- 改变坐骑战斗力
		self:change_mount_fight_value( model.fight )
		-- 更新坐骑增加的所有基础属性
		self:update_base_att(model);

		local mounts_config = MountsConfig:get_mount_data_by_id(model.jieji);
		local mounts_rate = MountsConfig:getRate();

		-- 品阶的满经验
		local pingjie_full_ex = mounts_config["point"];
		-- 品阶里的星星颗数
		local xiaopingjin = Utils:getIntPart((model.jiezhi*10)/pingjie_full_ex);

	 	--刷新资质
		local zizhi_base= mounts_config["base"];
		local currentPj = zizhi_base[xiaopingjin+1];
		local mounts_rate = MountsConfig:getRate();
		-- 基础资质
		self.hp_att:setText("#cd0cda2"..math.floor(currentPj[1]));
		self.at_att:setText("#cd0cda2"..math.floor(currentPj[2]));
		self.md_att:setText("#cd0cda2"..math.floor(currentPj[3]));
		self.wd_att:setText("#cd0cda2"..math.floor(currentPj[4]));
		self.bj_att:setText("#cd0cda2"..math.floor(currentPj[5]));
		-- 最大资质 Lang.mounts.jinjie_panel[11] = "#cff66cc(最大值 "
		self.hp_max_value:setString(Lang.mounts.jinjie_panel[11]..math.floor(mounts_config.limit[1])..")");
		self.att_max_value:setString(Lang.mounts.jinjie_panel[11]..math.floor(mounts_config.limit[2])..")");
		self.md_max_value:setString(Lang.mounts.jinjie_panel[11]..math.floor(mounts_config.limit[3])..")");
		self.wd_max_value:setString(Lang.mounts.jinjie_panel[11]..math.floor(mounts_config.limit[4])..")");
		self.bj_max_value:setString(Lang.mounts.jinjie_panel[11]..math.floor(mounts_config.limit[5])..")");	
		-- 更新洗练值
		self:update_xilian_attri()
	end

end

-- 更新坐骑战斗力
function MountsXiLianPanel:change_mount_fight_value( fight_value )
	if self.mounts_fight ~= nil then
		self.mounts_fight:set_number(fight_value)
	end
end

-- 更新人物基础属性
function MountsXiLianPanel:update_base_att( mounts_model )
	if not mounts_model then
		return
	end
	local mounts_config = MountsConfig:get_mount_data_by_id(mounts_model.jieji);

	--属性变成基础属性+灵犀加成
	local hp_var =tonumber( mounts_model.att_hp )
	--+ self:calculate_attribute_add(mounts_model.att_hp,mounts_model.lingxi);
	local at_var = tonumber(mounts_model.att_attack)
	--+self:calculate_attribute_add(mounts_model.att_attack,mounts_model.lingxi);
	local md_var = tonumber(mounts_model.att_md)
	--+self:calculate_attribute_add(mounts_model.att_md,mounts_model.lingxi);
	local wd_var =tonumber( mounts_model.att_wd)
	--+self:calculate_attribute_add(mounts_model.att_wd,mounts_model.lingxi); 
	local bj_var =tonumber( mounts_model.att_bj)
	--+self:calculate_attribute_add(mounts_model.att_bj,mounts_model.lingxi);

	self.hp_exten_all:setText(string.format(LH_COLOR[2].."%d",hp_var));
	self.at_exten_all:setText(string.format(LH_COLOR[2].."%d",at_var));
	self.md_exten_all:setText(string.format(LH_COLOR[2].."%d",md_var));
	self.wd_exten_all:setText(string.format(LH_COLOR[2].."%d",wd_var));
	self.bj_exten_all:setText(string.format(LH_COLOR[2].."%d",bj_var));

	--速度加成要另外算
	local speed = mounts_config["moveSpeed"];
	local speed_ex =  math.abs(900*900/(900+speed)-900);
	self.seep_exten_all:setText(string.format(LH_COLOR[2].."+%d",speed_ex));
end

-- 更新洗练属性
function MountsXiLianPanel:update_xilian_attri(  )

    local mounts_model = MountsModel:get_mounts_info();
    if mounts_model then
		local mounts_config = MountsConfig:get_mount_data_by_id(mounts_model.jieji);
		local mounts_rate = MountsConfig:getRate();
		-- 更新洗练值
		self.hp_exten:setString(LH_COLOR[4].."+"..mounts_model.zizhi_hp_exten);
		self.at_exten:setString(LH_COLOR[4].."+"..mounts_model.zizhi_attack_exten);
		self.md_exten:setString(LH_COLOR[4].."+"..mounts_model.zizhi_md_exten);
		self.wd_exten:setString(LH_COLOR[4].."+"..mounts_model.zizhi_wd_exten);
		self.bj_exten:setString(LH_COLOR[4].."+"..mounts_model.zizhi_bj_exten);
	end
end

function MountsXiLianPanel:destroy()

end