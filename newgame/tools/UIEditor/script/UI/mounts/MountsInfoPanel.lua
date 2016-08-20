-- MountsInfoPanel.lua 
-- createed by mwy @2012-5-2
-- refactored by guozhinan @2014-9-23
-- 坐骑信息页面。包含进阶、升级和灵犀。

super_class.MountsInfoPanel(  )

--是否处于下阶形象
local isNextMount = false;

local _mounts_max_jieji = 6

-- 一键50次
local one_key_50 = nil; 

local font_size = 17;

function MountsInfoPanel:__init()
	self.view = CCBasePanel:panelWithFile( 5, 8, 890, 518, UILH_COMMON.normal_bg_v2, 500, 500 )

	self.current_mounts_avatar_id = -1

	-- 左边的背景
	local left_bg = CCBasePanel:panelWithFile( 13, 12, 223, 494, UILH_COMMON.bottom_bg, 500, 500 )
	self.view:addChild(left_bg)
	-- 中间的背景
	local middle_bg = CCBasePanel:panelWithFile( 235, 12, 414, 494, UILH_COMMON.bottom_bg, 500, 500 )
	self.view:addChild(middle_bg)	
	-- 右边的背景
	local right_bg = CCBasePanel:panelWithFile( 648, 12, 230, 494, UILH_COMMON.bottom_bg, 500, 500 )
	self.view:addChild(right_bg)

	-- 左上的人物战斗力和属性信息
	self:create_left_up_panel(15, 224, 220, 280, nil)

	-- 中间偏上的坐骑形象
	self:create_middle_up_panel(240, 180, 406, 325,nil)

	-- 中间偏下的坐骑形象
	self:create_middle_down_panel(240, 10, 406, 170,nil)

	-- 右上的升级升阶和坐骑属性
	self:create_right_up_panell(654, 5, 220, 498,nil)	

	-- 右下的灵犀提升区域
	self:create_right_down_panel(15, 12, 220, 205,nil)	
end

function MountsInfoPanel:create_left_up_panel(x, y, width, height,texture_path)
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
	local left_down_title_panel = CCBasePanel:panelWithFile( 0, 182, 218, 35, UILH_NORMAL.title_bg4, 500, 500 )
	self.left_up_panel:addChild(left_down_title_panel)
	MUtils:create_zxfont(left_down_title_panel,Lang.mounts.info_panel[1],218/2,11,2,15);

	local x = 35
	local top_y = 152
	local row_space = 28
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
	local seep_lab = ZLabel:create( self.left_up_panel,LH_COLOR[2]..Lang.mounts.user_attr.moveSpeed, x,  top_y, font_size, ALIGN_LEFT )
	-- 移动速度增幅
	self.seep_exten_all = ZLabel:create( self.left_up_panel, "", x+100, top_y, font_size, ALIGN_LEFT )

end

function MountsInfoPanel:create_middle_up_panel(x, y, width, height,texture_path)
	self.middle_up_panel = CCBasePanel:panelWithFile( x, y, width, height,texture_path, 500, 500 )
	self.view:addChild(self.middle_up_panel,100)

	-- 标题:坐骑形象
	local title_panel = CCBasePanel:panelWithFile( (width-356)/2, 279, 356, 49, UILH_NORMAL.title_bg3, 500, 500 )
	self.middle_up_panel:addChild(title_panel)
	-- MUtils:create_zxfont(title_panel,Lang.mounts.info_panel[3],width/2,11,2,15);
	local title_img = CCZXImage:imageWithFile(356/2,23,-1,-1,UILH_MOUNT.zuoqixingxiang);
	title_img:setAnchorPoint(0.5,0.5)
	title_panel:addChild(title_img)

	-- 2个背景
	local half_bg = CCZXImage:imageWithFile(-1, 3,203,289,UILH_MOUNT.xinxi_bg,0,0);
	half_bg:setFlipX(true)
	self.middle_up_panel:addChild(half_bg)
	half_bg = CCZXImage:imageWithFile(202, 3,203,289,UILH_MOUNT.xinxi_bg,0,0);
	self.middle_up_panel:addChild(half_bg)

	-- 四个角纹装饰
	local edge_pattern = CCZXImage:imageWithFile(1, 258,-1,-1,UILH_MOUNT.edge_pattern);
	self.middle_up_panel:addChild(edge_pattern)
	edge_pattern = CCZXImage:imageWithFile(1, 5,-1,-1,UILH_MOUNT.edge_pattern);
	edge_pattern:setFlipY(true)	
	self.middle_up_panel:addChild(edge_pattern)
	edge_pattern = CCZXImage:imageWithFile(363, 258,-1,-1,UILH_MOUNT.edge_pattern);
	edge_pattern:setFlipX(true)	
	self.middle_up_panel:addChild(edge_pattern)
	edge_pattern = CCZXImage:imageWithFile(363, 5,-1,-1,UILH_MOUNT.edge_pattern);
	edge_pattern:setFlipX(true)
	edge_pattern:setFlipY(true)
	self.middle_up_panel:addChild(edge_pattern)

	-- 坐骑名字
	self.mounts_name = UILabel:create_lable_2( "#cfff000"..Lang.mounts.default_mounts_name, width/2, height-63, 20, ALIGN_CENTER );
	self.middle_up_panel:addChild(self.mounts_name);

	--切换上下马的状态
	local function chengqi_event()
		MountsModel:ride_a_mount();	--修改model数据
		self:setMountsStatus(MountsModel:get_is_shangma())
		Instruction:handleUIComponentClick(instruct_comps.MOUNT_WIN_RIDE_BTN)
		return true
	end

	--乘骑按钮 
	self.chengqi_btn = ZButton:create( self.middle_up_panel, {UILH_ROLE.role_button1,UILH_ROLE.role_button1}, chengqi_event, (width - 79)/2, 5, 79, 80 )
	-- self.chengqi_btn:addImage(CLICK_STATE_DISABLE,UIPIC_COMMON_BUTTON_001_DISABLE)
	self.qi_title_status = CCZXImage:imageWithFile(20,28,-1,-1,UILH_MOUNT.chengqi)
	self.chengqi_btn:addChild(self.qi_title_status)

	--设置坐骑状态对于的按钮显示
	self:setMountsStatus(MountsModel:get_is_shangma())

	-- 炫耀按钮
	local function xuanyao_event()
		MountsModel:req_xuanyao_event()
		return true
	end
	self.xuanyao_btn = ZButton:create(self.middle_up_panel, {UILH_COMMON.lh_button2,UILH_COMMON.lh_button2_s}, xuanyao_event, 263, 13, 99, 53 )
	self.xuanyao_btn:addImage(CLICK_STATE_DISABLE,UILH_COMMON.lh_button2_disable)
	-- 炫耀文字
	MUtils:create_zxfont(self.xuanyao_btn,Lang.mounts.info_panel[5],99/2,19,2,18);	

	-- 化形按钮
	local function huaxing_event()
      	local model = MountsModel:get_mounts_info();
	  	if model ~= nil then
	  		local display_id = model.model_id
	  		if model.show_id ~= nil and model.show_id ~= 0 then
	  			display_id = model.show_id
	  		end
	  		if self.current_mounts_avatar_id ~= display_id then
	  			MountsModel:req_mount_huaxing(self.current_mounts_avatar_id)
	  		end
	    	self.huaxing_btn.view:setCurState(CLICK_STATE_DISABLE);
      	end
		return true
	end
	self.huaxing_btn = ZButton:create(self.middle_up_panel, {UILH_COMMON.lh_button2,UILH_COMMON.lh_button2_s}, huaxing_event, 41, 13, 99, 53);
	self.huaxing_btn:addImage(CLICK_STATE_DISABLE, UILH_COMMON.lh_button2_disable);
	-- 化形文字
	MUtils:create_zxfont(self.huaxing_btn,Lang.mounts.info_panel[4],99/2,19,2,18);		
end

function MountsInfoPanel:create_middle_down_panel(x, y, width, height,texture_path)
	self.middle_down_panel = CCBasePanel:panelWithFile( x, y, width, height, texture_path, 500, 500 )
	self.view:addChild(self.middle_down_panel,100)

	self.mount_icons_panel = {}
	self.mount_icons = {}
    local function create_Scroll_item( no_user, index )
        local list = List:create( nil, 0, 0, 336, 70, 5, 1)
        local get_panel = nil
        for i = 1, 5 do
            get_panel = self:create_get_panel( index * 5 + i )
            if get_panel ~= nil then
                list:addItem( get_panel )
            end
        end
        return list
    end
    -- 行数 =（坐骑最大阶级数）/ 5。5是每行显示的坐骑数量
    local scroll_max_row = math.ceil(_mounts_max_jieji / 5)
    self.huaxing_scroll = ScrollPage:create( nil, 36, height-70, 336, 70, scroll_max_row, TYPE_VERTICAL_EX, 1)
    self.huaxing_scroll:setScrollCreatFunction(create_Scroll_item)
    self.huaxing_scroll:refresh()
    self.middle_down_panel:addChild(self.huaxing_scroll.view);

    local function left_but_callback()
        local index = self.huaxing_scroll:getCurIndexPage()
        if index - 1 >= 0 then
            self.huaxing_scroll.view:setCurIndexPage(index - 1)
        end
    end
    self.left_but = UIButton:create_button_with_name( 5, 105, 22, 64, UILH_COMMON.arrow_normal, UILH_COMMON.arrow_normal, nil, "", left_but_callback )
    self.middle_down_panel:addChild( self.left_but.view )
    
    local function right_but_callback()
        local index = self.huaxing_scroll:getCurIndexPage()
        if index + 1 < scroll_max_row then
            self.huaxing_scroll.view:setCurIndexPage(index + 1)
        end
    end
    self.right_but = UIButton:create_button_with_name( 378, 105, 22, 64, UILH_COMMON.arrow_normal, UILH_COMMON.arrow_normal, nil, "", right_but_callback )
    self.right_but.view:setFlipX(true)
    -- self.right_but.view:addTexWithFile(CLICK_STATE_DISABLE, UIPIC_CangKuWin_0005 )
    self.middle_down_panel:addChild( self.right_but.view )

	-- 标题:特殊坐骑
	local title_panel = CCBasePanel:panelWithFile( 0, 68, width, 35, UILH_NORMAL.title_bg4, 500, 500 )
	self.middle_down_panel:addChild(title_panel,-1)
	MUtils:create_zxfont(title_panel,Lang.mounts.info_panel[9],width/2,11,2,15);

	self.mount_icons_panel_ex = {}
	self.mount_icons_ex = {}
	local mounts_all_config = MountsConfig:get_config()
	local mounts_ex_max_jieji = #mounts_all_config.stagesOther
    local function create_Scroll_item_ex( no_user, index )
        local list = List:create( nil, 0, 0, 336, 70, 5, 1)
        local get_panel = nil
        for i = 1, 5 do
        	if index * 5 + i <= mounts_ex_max_jieji then
	            get_panel = self:create_get_panel_ex( index * 5 + i )
	            if get_panel ~= nil then
	                list:addItem( get_panel )
	            end
	        end
        end
        return list
    end

    local scroll_max_row_ex = math.ceil(mounts_ex_max_jieji / 5)
    self.huaxing_scroll_ex = ScrollPage:create( nil, 36, 0, 336, 70, scroll_max_row_ex, TYPE_VERTICAL_EX, 1)
    self.huaxing_scroll_ex:setScrollCreatFunction(create_Scroll_item_ex)
    self.huaxing_scroll_ex:refresh()
    self.middle_down_panel:addChild(self.huaxing_scroll_ex.view);

    local function left_but_callback_ex()
        local index = self.huaxing_scroll_ex:getCurIndexPage()
        if index - 1 >= 0 then
            self.huaxing_scroll_ex.view:setCurIndexPage(index - 1)
        end
    end
    self.left_but_ex = UIButton:create_button_with_name( 5, 5, 22, 64, UILH_COMMON.arrow_normal, UILH_COMMON.arrow_normal, nil, "", left_but_callback_ex )
    self.middle_down_panel:addChild( self.left_but_ex.view )
    
    local function right_but_callback_ex()
        local index = self.huaxing_scroll_ex:getCurIndexPage()
        if index + 1 < scroll_max_row_ex then
            self.huaxing_scroll_ex.view:setCurIndexPage(index + 1)
        end
    end
    self.right_but_ex = UIButton:create_button_with_name( 378, 5, 22, 64, UILH_COMMON.arrow_normal, UILH_COMMON.arrow_normal, nil, "", right_but_callback_ex )
    self.right_but_ex.view:setFlipX(true)
    -- self.right_but.view:addTexWithFile(CLICK_STATE_DISABLE, UIPIC_CangKuWin_0005 )
    self.middle_down_panel:addChild( self.right_but_ex.view )
end

function MountsInfoPanel:create_right_up_panell(x, y, width, height,texture_path)
	self.right_up_panel = CCBasePanel:panelWithFile( x, y, width, height, texture_path, 500, 500 )
	self.view:addChild(self.right_up_panel,100)

	local standard_x = 58;

	-- 等级
	local level_lab = UILabel:create_label_1(Lang.mounts.user_attr.level, CCSizeMake(100,27), standard_x, height - 17, font_size, CCTextAlignmentLeft); -- [2085]="等     级:"
	self.right_up_panel:addChild(level_lab);

	-- 等级数值
	self.level = UILabel:create_label_1("999", CCSizeMake(50,20), 90, height - 17, font_size, CCTextAlignmentLeft, 255, 255, 255);
	self.right_up_panel:addChild(self.level);

	-- 进度lab
	local pro_lab = UILabel:create_label_1(Lang.mounts.progress_tip, CCSizeMake(100,27), standard_x, height - 47, font_size, CCTextAlignmentLeft); -- [2086]="进   度:"
	self.right_up_panel:addChild(pro_lab);

	-- 等级进度
	self.level_progress = ZXProgress:createWithValueEx(0,100,155,18,UILH_NORMAL.progress_bg2,UILH_NORMAL.progress_bar_yellow2,false);
	self.level_progress:setPosition(CCPointMake(60,height - 58));
	self.right_up_panel:addChild(self.level_progress);

	--cd时间倒计时label
	local function up_level_cd_end( )
		print("坐骑升级，cd时间结束")
		self:clear_cd_callback();
	end
	self.cd_time_lab = TimerLabel:create_label(self.level_progress, 85/2-35, 4, 12, 0,nil ,up_level_cd_end ,false);
	
	-- 升级按钮
	local function level_up_event(eventType,x,y)
		if eventType == TOUCH_BEGAN then
			return true
		elseif eventType == TOUCH_CLICK then
			Instruction:handleUIComponentClick(instruct_comps.MOUNT_WIN_UPDATE1)
			Analyze:parse_click_main_menu_info(251)
			MountsModel:req_up_level( );
			return true
		end
	end
	self.uplevel_btn = CCTextButton:textButtonWithFile(width - 76,height - 115,77,40, Lang.mounts.uplevel_btn_tip, UILH_COMMON.button4,20,10); -- [941]="升级"
	self.uplevel_btn:addTexWithFile(CLICK_STATE_DOWN,UILH_COMMON.button4);
	self.uplevel_btn:addTexWithFile(CLICK_STATE_DISABLE,UILH_COMMON.button4_dis);
	self.right_up_panel:addChild(self.uplevel_btn);
	self.uplevel_btn:registerScriptHandler(level_up_event)

	--清除cd按钮
	local function celar_cd_event( eventType,x,y )
		if eventType == TOUCH_BEGAN then 
			return true
		elseif eventType == TOUCH_CLICK then 
			if MountsModel:get_mounts_info().uplevel_cdtime > 0 then
				--如果还有升级cd时间，那就是清除cd事件
				MountsModel:req_clear_cd_time( )
			end
			return true;
		end
		return true
	end
	self.clearCD_btn = CCNGBtnMulTex:buttonWithFile(width - 76,height - 115,77,40,UILH_COMMON.button4);
	self.clearCD_btn:addTexWithFile(CLICK_STATE_DOWN,UILH_COMMON.button4);
	self.clearCD_btn:addTexWithFile(CLICK_STATE_DISABLE,UILH_COMMON.button4_dis);
	self.right_up_panel:addChild(self.clearCD_btn);
	self.clearCD_btn:registerScriptHandler(celar_cd_event);
	-- 清除cd按钮的图片
	MUtils:create_zximg(self.clearCD_btn, UILH_MOUNT.arrow_double, 27, 15, -1, -1);

	-- 消费铜币数量
	self.cost_xb = MUtils:create_ccdialogEx( self.right_up_panel,"" ,30, height - 81,150,20,2,14);

	-- 分割线
	MUtils:create_zximg(self.right_up_panel,UILH_COMMON.split_line,1,380,width-4,3,0,0)	

	-- 品阶
	local pj_lab = UILabel:create_label_1(Lang.mounts.pinjie_tip, CCSizeMake(100,27), standard_x, height - 135, font_size, CCTextAlignmentLeft); -- [2085]="等     级:"
	self.right_up_panel:addChild(pj_lab);

	-- 品阶和星级数值
	self.pj_number_label = UILabel:create_label_1("0", CCSizeMake(50,20), 90, height - 135, font_size, CCTextAlignmentLeft, 255, 255, 255);
	self.right_up_panel:addChild(self.pj_number_label);

	-- 进度lab
	local pro_lab = UILabel:create_label_1(Lang.mounts.progress_tip, CCSizeMake(100,27), standard_x, height - 162, font_size, CCTextAlignmentLeft); -- [2086]="进   度:"
	self.right_up_panel:addChild(pro_lab);

	-- 品阶进度条和进度条上的文字
	self.jinjie_progress = ZXProgress:createWithValueEx(0,100,135,15,UILH_NORMAL.progress_bg2,UILH_NORMAL.progress_bar_blue2);
	self.jinjie_progress:setPosition(CCPointMake(60,height - 173));
	self.right_up_panel:addChild(self.jinjie_progress);

	-- 升阶按钮，跳转页面
	local function pinjie_up_event(eventType,x,y)
		if eventType == TOUCH_BEGAN then
			return true
		elseif eventType == TOUCH_CLICK then
			Instruction:handleUIComponentClick(instruct_comps.MOUNT_WIN_UPDATE2)
			local win = UIManager:find_visible_window("mounts_win_new")
			if win then
				win:change_page(2)
			end
			return true
		end
	end
	self.up_pj_btn = CCTextButton:textButtonWithFile(width - 76,278,77,40, Lang.mounts.up_pj_btn_tip, UILH_COMMON.button4,20,10); -- [941]="升级"
	self.up_pj_btn:addTexWithFile(CLICK_STATE_DOWN,UILH_COMMON.button4);
	self.up_pj_btn:addTexWithFile(CLICK_STATE_DISABLE,UILH_COMMON.button4_dis);
	self.right_up_panel:addChild(self.up_pj_btn);
	self.up_pj_btn:registerScriptHandler(pinjie_up_event)

	-- 资质标题
	local title_panel = CCBasePanel:panelWithFile( 0, 231, 218, 35, UILH_NORMAL.title_bg4, 500, 500 )
	self.right_up_panel:addChild(title_panel)
	MUtils:create_zxfont(title_panel,Lang.mounts.info_panel[6],218/2,11,2,15);

	--资质属性
	local top_y = 200;
	local row_space = 30;
	local attr_offset = 70
	local exten = 115
	local zizhi_font_size = 17
	standard_x = standard_x + 5
	-- 生命
	local hp_lab = UILabel:create_label_1(Lang.mounts.user_attr.hp, CCSizeMake(100,27), standard_x, top_y , zizhi_font_size, CCTextAlignmentLeft); -- [1509]="生    命:"
	self.right_up_panel:addChild(hp_lab);
	-- 基本资质
	self.hp_att = UILabel:create_label_1("", CCSizeMake(37,20), standard_x+attr_offset, top_y, zizhi_font_size, CCTextAlignmentRight, 255, 255, 255);
	self.right_up_panel:addChild(self.hp_att);
	-- 增幅资质
	self.hp_exten = UILabel:create_label_1("", CCSizeMake(50,20), standard_x+exten, top_y, zizhi_font_size, CCTextAlignmentLeft);
	self.right_up_panel:addChild(self.hp_exten);

	-- 攻击
	top_y = top_y - row_space;
	local at_lab = UILabel:create_label_1(Lang.mounts.user_attr.attack, CCSizeMake(100,27), standard_x, top_y , zizhi_font_size, CCTextAlignmentLeft); -- [1506]="攻    击:"
	self.right_up_panel:addChild(at_lab);
	-- 基本资质
	self.at_att = UILabel:create_label_1("", CCSizeMake(37,20), standard_x+attr_offset, top_y, zizhi_font_size, CCTextAlignmentRight, 255, 255, 255);
	self.right_up_panel:addChild(self.at_att);
	-- 增幅资质
	self.at_exten = UILabel:create_label_1("", CCSizeMake(50,20), standard_x+exten, top_y, zizhi_font_size, CCTextAlignmentLeft);
	self.right_up_panel:addChild(self.at_exten);

	-- 法术防御
	top_y = top_y - row_space;
	local md_lab = UILabel:create_label_1(Lang.mounts.user_attr.innerDefence, CCSizeMake(100,27), standard_x, top_y , zizhi_font_size, CCTextAlignmentLeft); -- [1510]="法术防御:"
	self.right_up_panel:addChild(md_lab);
	-- 基本资质
	self.md_att = UILabel:create_label_1("", CCSizeMake(37,20), standard_x+attr_offset, top_y, zizhi_font_size, CCTextAlignmentRight, 255, 255, 255);
	self.right_up_panel:addChild(self.md_att);
	-- 增幅资质
	self.md_exten = UILabel:create_label_1("", CCSizeMake(50,20), standard_x+exten, top_y, zizhi_font_size, CCTextAlignmentLeft);
	self.right_up_panel:addChild(self.md_exten);

	-- 物理防御
	top_y = top_y - row_space;
	local wd_lab = UILabel:create_label_1(Lang.mounts.user_attr.outDefence, CCSizeMake(100,27), standard_x, top_y , zizhi_font_size, CCTextAlignmentLeft); -- [1507]="物理防御:"
	self.right_up_panel:addChild(wd_lab);
	-- 基本资质
	self.wd_att = UILabel:create_label_1("", CCSizeMake(37,20), standard_x+attr_offset, top_y, zizhi_font_size, CCTextAlignmentRight, 255, 255, 255);
	self.right_up_panel:addChild(self.wd_att);
	-- 增幅资质
	self.wd_exten = UILabel:create_label_1("", CCSizeMake(50,20), standard_x+exten, top_y, zizhi_font_size, CCTextAlignmentLeft);
	self.right_up_panel:addChild(self.wd_exten);

	-- 暴击
	top_y = top_y - row_space;
	local bj_lab = UILabel:create_label_1(Lang.mounts.user_attr.criticalStrikes, CCSizeMake(100,27), standard_x, top_y , zizhi_font_size, CCTextAlignmentLeft); -- [2091]="暴    击:"
	self.right_up_panel:addChild(bj_lab);
	-- 基本资质
	self.bj_att = UILabel:create_label_1("", CCSizeMake(37,20), standard_x+attr_offset, top_y, zizhi_font_size, CCTextAlignmentRight, 255, 255, 255);
	self.right_up_panel:addChild(self.bj_att);
	-- 增幅资质
	self.bj_exten = UILabel:create_label_1("", CCSizeMake(50,20), standard_x+exten, top_y, zizhi_font_size, CCTextAlignmentLeft);
	self.right_up_panel:addChild(self.bj_exten);

	-- 洗练
	--洗练按钮事件
	local function xiliang_event(eventType,x,y)
		if eventType == TOUCH_BEGAN then
			return true
		elseif eventType == TOUCH_CLICK then
			local mounts_model = MountsModel:get_mounts_info();
			-- 坐骑开启洗练的等级由30级改为45级
			if mounts_model.level >= 45 then
				local win = UIManager:find_visible_window("mounts_win_new")
				if win then
					win:change_page(3)
				end
				-- local mountsWin = UIManager:get_win_obj("mounts_win");
				-- mountsWin:selelcted_tab_by_name("mounts_xilian_tab");
			else
				GlobalFunc:create_screen_notic(Lang.mounts.xilian_open_tip)	-- "需要坐骑等级45级才能开启洗练！"
			end
			return true
		end
	end
	self.xilian_btn = CCTextButton:textButtonWithFile(width - 76, 15, 77, 40, Lang.mounts.xilian_btn_tip, UILH_COMMON.button4,20,10); -- [2092]="洗炼"
	self.xilian_btn:addTexWithFile(CLICK_STATE_DOWN,UILH_COMMON.button4);
	self.xilian_btn:addTexWithFile(CLICK_STATE_DISABLE,UILH_COMMON.button4_dis)
	self.right_up_panel:addChild(self.xilian_btn);
	self.xilian_btn:registerScriptHandler(xiliang_event);
end

function MountsInfoPanel:create_right_down_panel(x, y, width, height,texture_path)
	self.right_down_panel = CCBasePanel:panelWithFile( x, y, width, height,texture_path, 500, 500 )
	self.view:addChild(self.right_down_panel)

	self.hide_lingxi_tip1 = MUtils:create_zxfont(self.right_down_panel,Lang.mounts.info_panel[7],width/2,100,2,17);
	self.hide_lingxi_tip2 = MUtils:create_zxfont(self.right_down_panel,Lang.mounts.info_panel[8],width/2,70,2,17);

	-- 便于整体隐藏
	self.lingxi_panel = CCBasePanel:panelWithFile( 0, 0, width, height,nil, 500, 500 )
	self.lingxi_panel:setIsVisible(false)
	self.right_down_panel:addChild(self.lingxi_panel)

	--标题：灵犀值
	local title_panel = CCBasePanel:panelWithFile( 0, height - 43, 218, 35, UILH_NORMAL.title_bg4, 500, 500 )
	self.right_down_panel:addChild(title_panel)
	MUtils:create_zxfont(title_panel,Lang.mounts.info_panel[2],218/2,11,2,15);

	-- 灵犀丹
	self.lingxi_icon = MUtils:create_slot_item2(self.lingxi_panel,UILH_COMMON.slot_bg,25,height - 130,68,68,nil,nil,7);
	local function lingxi_tip( ... )
		local a, b, args = ...
   	    local click_pos = Utils:Split(args, ":")
	    local world_pos = self.lingxi_icon.view:getParent():convertToWorldSpace( CCPointMake( tonumber(click_pos[1]),tonumber(click_pos[2]) ) )
		TipsModel:show_shop_tip(world_pos.x, world_pos.y, 18602);
	end
	self.lingxi_icon:set_click_event(lingxi_tip)
	self.lingxi_icon:set_icon_texture("icon/item/00306.pd");
	-- 灵犀丹名字
	local lingxi_name_label = UILabel:create_label_1(Lang.mounts.lingxi_drug, CCSizeMake(50,20), 123, height - 76, font_size, nil, 255, 240, 0); -- [2094]="灵犀丹"
	self.lingxi_panel:addChild(lingxi_name_label);	
	-- 灵犀丹获得提示
	local lingxi_tip = UILabel:create_label_1(Lang.mounts.lingxi_drug_get_tip, CCSizeMake(160,20), width/2, 13, 14, CCTextAlignmentCenter, 0, 192, 255); -- [2097]="提示:灵犀丹在梦境里获得"
	self.lingxi_panel:addChild(lingxi_tip);
	-- 灵犀值标题
	local lingxi_number_title = UILabel:create_label_1(Lang.mounts.user_attr.lingxi, CCSizeMake(60,20), 55, 53, font_size-3, nil); -- [2095]="灵犀值："
	self.lingxi_panel:addChild(lingxi_number_title);	
	-- 灵犀值
	self.lingxi_value = UILabel:create_label_1("00", CCSizeMake(60,20), 110, 53, font_size-3, nil, 255, 240, 0);
	self.lingxi_panel:addChild(self.lingxi_value);
	-- 成功率标题
	local lingxi_rate_title = UILabel:create_label_1(Lang.mounts.success_rate, CCSizeMake(90,20), 55, 33, font_size-3, nil); -- [2096]="成功率:"
	self.lingxi_panel:addChild(lingxi_rate_title);
	-- 成功率,固定60%
	local lingxi_succ = UILabel:create_label_1(LH_COLOR[3].."+60%", CCSizeMake(60,20), 110, 33, font_size-3, nil);
	self.lingxi_panel:addChild(lingxi_succ);

	-- 提升按钮
	local function lxts_event(eventType,x,y )
	 	if eventType == TOUCH_BEGAN then
			return true
		elseif eventType == TOUCH_CLICK then
			--提升灵犀。在发请求之前应该查看身上是否有灵犀丹
			MountsCC:request_up_lingxi()
			return true
		end
	 end 
	self.tishen_btn = CCNGBtnMulTex:buttonWithFile(112,74,77,40,UILH_COMMON.button4);
	self.tishen_btn:addTexWithFile(CLICK_STATE_DOWN,UILH_COMMON.button4);
	self.tishen_btn:addTexWithFile(CLICK_STATE_DISABLE,UILH_COMMON.button4_dis); 
	self.lingxi_panel:addChild(self.tishen_btn);
	self.tishen_btn:registerScriptHandler(lxts_event);
	--按钮文字
	local lx_btn_lab = CCZXLabel:labelWithTextS( CCPointMake(77/2,13),Lang.mounts.tishen_btn_tip,16,ALIGN_CENTER); -- [1499]="提升"
	self.tishen_btn:addChild(lx_btn_lab);
end

--升级成功的回调
function MountsInfoPanel:up_level_callback(mounts_model)
	
	self.level:setString(string.format(LH_COLOR[11].."%d/70",mounts_model.level));
	LuaEffectManager:stop_view_effect(11039, self.uplevel_btn)

	if mounts_model.level == MountsConfig:get_mount_max_level() then
		-- 如果到了最高级，则把cd按钮disabled掉
		self.uplevel_btn:setCurState(CLICK_STATE_DISABLE);
		self.cd_time_lab:setString(Lang.mounts.max_level); -- [2078]="最高级"
	else
		--始倒计时,隐藏升级按钮
		self.uplevel_btn:setIsVisible(false);
		self.clearCD_btn:setIsVisible(true);
		self.cd_time_lab:setText(mounts_model.uplevel_cdtime);
	end

	if mounts_model.level >= 50 then
		self.lingxi_panel:setIsVisible(true);
		self.hide_lingxi_tip1:setIsVisible(false);
		self.hide_lingxi_tip2:setIsVisible(false);
	else
		self.lingxi_panel:setIsVisible(false);
		self.hide_lingxi_tip1:setIsVisible(true);
		self.hide_lingxi_tip2:setIsVisible(true);
	end
	
	-- 更新灵犀值
	if self.lingxi_value then 
		if mounts_model.lingxi == nil or mounts_model.lingxi == 0 then
			mounts_model.lingxi = 100;
		end
		local lingxi_str = string.format(LH_COLOR[3].."+%d",mounts_model.lingxi).."%";
		self.lingxi_value:setString(lingxi_str);

		-- 如果灵犀满值了，就把提升按钮置灰
		if mounts_model.lingxi == 150 then
			self.lingxi_value:setString(Lang.mounts.lingxi_max); -- [2081]="+150%#c38ff33(满)"
			self.tishen_btn:setCurState(CLICK_STATE_DISABLE);
		end
	end
	
	--清除cd需要的元宝
	local str = Lang.mounts.cost_3_tip..MountsConfig:get_clear_cd_cost_by_level(mounts_model.level); -- [2079]="#c00c0ff消耗元宝: #cfff000"
	self.cost_xb:setText(str);

	-- 现在将坐骑洗练由30级改为45级开启
	-- if xilian_btn:getCurState() == CLICK_STATE_DISABLE and mounts_model.level >= 45 then
	-- 	xilian_btn:setCurState(CLICK_STATE_UP);
	-- end

	-- if mounts_model.level >=50 then
	-- 	jinjie_bg4:setIsVisible(true);
	-- 	jinjie_bg3:setIsVisible(false);
	-- end
	-- 播放提升成功的特效
    LuaEffectManager:play_view_effect( 10014,443,390,self.view,false,100 )
end

function MountsInfoPanel:create_get_panel( index )
	if index > _mounts_max_jieji then
		return
	end

	-- 这个是必要的，create_get_panel这个方法会在滑动时被多次调用（由于回收机制）。但我们这里不需要自动回收
	if self.mount_icons_panel[index] ~= nil then
		return self.mount_icons_panel[index]
	end

	local get_panel = {}
	local function mount_icon_call_back()
		local is_show_other_mounts = MountsModel:is_show_other_mounts();
		if index <= self.jieji and is_show_other_mounts == false then
			self:change_mounts_avatar(index)
		end
	end
	get_panel.view = CCBasePanel:panelWithFile(0, 0, 62, 62, "", 500, 500 )
	local mount_icon = mountIconCell(index, 0, 5, 62, 62, mount_icon_call_back)
	if self.jieji ~= nil then
		if index <= self.jieji then
			mount_icon:set_lock(false)
		else
			mount_icon:set_lock(true)
		end
	end
	if self.current_mounts_avatar_id == index then
		mount_icon:set_selected(true);
	end
	self.mount_icons[index] = mount_icon
	get_panel.view:addChild(mount_icon.view);
	self.mount_icons_panel[index] = get_panel
	get_panel.view:retain()

	return get_panel
end

function MountsInfoPanel:create_get_panel_ex( index )
	-- 这个是必要的，create_get_panel这个方法会在滑动时被多次调用（由于回收机制）。但我们这里不需要自动回收
	if self.mount_icons_panel_ex[index] ~= nil then
		return self.mount_icons_panel_ex[index]
	end

	local get_panel = {}
	local function mount_icon_call_back()
		local is_show_other_mounts = MountsModel:is_show_other_mounts();
		local stagesOther_config = MountsConfig:get_stagesOther_config()
		local mounts_ex_max_jieji = #stagesOther_config
		if index <= mounts_ex_max_jieji and is_show_other_mounts == false then
			self:change_mounts_avatar(index+100)
		end
	end
	get_panel.view = CCBasePanel:panelWithFile(0, 0, 62, 62, "", 500, 500 )
	local mount_icon = mountIconCell(index+100, 0, 5, 62, 62, mount_icon_call_back)
	mount_icon:set_lock(false)

	if self.spc_mounts and #self.spc_mounts > 0 then
		local count = #self.spc_mounts;
		for i=1,count do
			if self.spc_mounts[i].id == index + 100 then
				mount_icon:set_lock(true);
				break;
			end
		end
	end

	if self.special_mount_show_id ~= nil and self.current_mounts_avatar_id == self.special_mount_show_id then
		mount_icon:set_selected(true);
	end
	self.mount_icons_ex[index] = mount_icon
	get_panel.view:addChild(mount_icon.view);
	self.mount_icons_panel_ex[index] = get_panel
	get_panel.view:retain()

	return get_panel
end

--升级&清除cd 按钮事件
--清除cd成功的回调
function MountsInfoPanel:clear_cd_callback()
	local mount = MountsModel:get_mounts_info();
	mount.uplevel_cdtime = 0;
	MountsModel:set_mounts_info(mount);
	--把进度条填满
	self.level_progress:setProgressValue(0,100);
	--隐藏
	self.uplevel_btn:setIsVisible(true);
	LuaEffectManager:stop_view_effect(11039, self.uplevel_btn)
	LuaEffectManager:play_view_effect(11039, 39, 22, self.uplevel_btn, true)
	self.clearCD_btn:setIsVisible(false);
	self.cd_time_lab:setString(Lang.mounts.can_level_up); -- [2076]="可升级"
	local str = Lang.mounts.cost_0_tip..MountsConfig:get_uplevel_cost_by_level(MountsModel:get_mounts_info().level); -- [2077]="#c00c0ff消耗仙币: #cfff000 "
	self.cost_xb:setText(str);
end

-- 界面更新
function MountsInfoPanel:update( mounts_model )

	local is_show_other_mounts = MountsModel:is_show_other_mounts()

	-- 记录品阶
	self.jieji = mounts_model.jieji;
	self.special_mount_show_id = mounts_model.show_id
	self.spc_mounts = mounts_model.spc_mounts
	for i=1,_mounts_max_jieji do
		if self.mount_icons[i] ~= nil then
			if i <= self.jieji and is_show_other_mounts == false then
				self.mount_icons[i]:set_lock(false)
			else
				self.mount_icons[i]:set_lock(true)
			end
		end
	end

	local stagesOther_config = MountsConfig:get_stagesOther_config();
	local stagesOther_count = #stagesOther_config
	for i=1,stagesOther_count do
		if self.mount_icons_ex[i] ~= nil then
			self.mount_icons_ex[i]:set_lock(true)
			if is_show_other_mounts == false and mounts_model.spc_mounts ~= nil and #mounts_model.spc_mounts > 0 then
				local spc_mounts_count = #mounts_model.spc_mounts
				for t=1,spc_mounts_count do
					if mounts_model.spc_mounts[t].id - 100 == i then
						self.mount_icons_ex[i]:set_lock(false)
						break
					end
				end
			end
		end
	end

	-- 更新品阶和星级
	local mounts_config = MountsConfig:get_mount_data_by_id(mounts_model.jieji);

	-- 品阶的满经验
	local pingjie_full_ex = mounts_config["point"];
	local star_count = Utils:getIntPart((mounts_model.jiezhi*10)/pingjie_full_ex);
	self.pj_number_label:setString(LH_COLOR[4]..mounts_model.jieji..Lang.mounts.jie..star_count..Lang.mounts.xing)
	-- 更新进度条
	local jiehzi_var = mounts_model.jiezhi%(pingjie_full_ex/10);
	self.jinjie_progress:setProgressValue(jiehzi_var,pingjie_full_ex/10);
	
	--更新资质
	local zizhi_base= mounts_config["base"];
	local currentPj = zizhi_base[star_count+1];
	self.hp_att:setString(LH_COLOR[2]..currentPj[1]);
	self.at_att:setString(LH_COLOR[2]..currentPj[2]);
	self.md_att:setString(LH_COLOR[2]..currentPj[3]);
	self.wd_att:setString(LH_COLOR[2]..currentPj[4]);
	self.bj_att:setString(LH_COLOR[2]..currentPj[5]);

	-- 更新洗练值
	local mounts_rate = MountsConfig:getRate();
	self.hp_exten:setString(LH_COLOR[4].."+"..mounts_model.zizhi_hp_exten);
	self.at_exten:setString(LH_COLOR[4].."+"..mounts_model.zizhi_attack_exten);
	self.md_exten:setString(LH_COLOR[4].."+"..mounts_model.zizhi_md_exten);
	self.wd_exten:setString(LH_COLOR[4].."+"..mounts_model.zizhi_wd_exten);
	self.bj_exten:setString(LH_COLOR[4].."+"..mounts_model.zizhi_bj_exten);

	-- cd时间
	print("mounts_model.uplevel_cdtime",mounts_model.uplevel_cdtime)

	if mounts_model.uplevel_cdtime == 0 then 
		-- print("可以升级");
		LuaEffectManager:stop_view_effect(11039, self.uplevel_btn)
		if mounts_model.level == MountsConfig:get_mount_max_level() then
			self.cd_time_lab:setString(Lang.mounts.max_level); -- [2078]="最高级"
			self.uplevel_btn:setCurState(CLICK_STATE_DISABLE);
			
		else 
			self.cd_time_lab:setString(Lang.mounts.can_level_up); -- [2076]="可升级"
			LuaEffectManager:play_view_effect(11039, 39, 22, self.uplevel_btn, true)
			-- LuaEffectManager:play_view_effect( 9,333,333,self.view,false )
		end
		
		-- 升级需要的仙币
		local str = Lang.mounts.cost_0_tip..MountsConfig:get_uplevel_cost_by_level(mounts_model.level); -- [2082]="#c00c0ff消耗仙币: #cfff000"
		self.cost_xb:setText(str);
		self.uplevel_btn:setIsVisible(true)
		self.clearCD_btn:setIsVisible(false);
	else 
		local cd_time = mounts_model.cd_endTime - GameStateManager:get_total_seconds();
		if cd_time > 0 then
			self.cd_time_lab:setText(cd_time);
		else 
			self.cd_time_lab:setText(0);
		end
		-- 清楚cd需要的元宝
		local str = Lang.mounts.cost_3_tip..MountsConfig:get_clear_cd_cost_by_level(mounts_model.level); -- [2079]="#c00c0ff消耗元宝: #cfff000"
		self.cost_xb:setText(str);

		self.uplevel_btn:setIsVisible(false);
		LuaEffectManager:stop_view_effect(11039, self.uplevel_btn)
		self.clearCD_btn:setIsVisible(true);
	end
	-- 更新等级
	self.level:setString(string.format(LH_COLOR[11].."%d/70",mounts_model.level));

	-- 坐骑开启洗练的等级由30级改为45级
	-- if mounts_model.level >= 45 then
	-- 	xilian_btn:setCurState(CLICK_STATE_UP);
	-- else
	-- 	xilian_btn:setCurState(CLICK_STATE_DISABLE);
	-- end

	--改变坐骑外观
	local display_id = mounts_model.model_id
	if mounts_model.show_id ~= nil and mounts_model.show_id ~= 0 then
		display_id = mounts_model.show_id
	end
	self:change_mounts_avatar(display_id);
	-- 改变坐骑战斗力
	self:change_mount_fight_value( mounts_model.fight )
	-- 更新坐骑给人物附加的基础属性
	self:update_base_att(mounts_model);

	if is_show_other_mounts == false then
		if self.lingxi_icon ~= nil then
		 	--查询是否有灵犀丹
		 	local count = ItemModel:get_item_count_by_id(18602);
		 	if count > 0 then
		 		self.lingxi_icon:set_icon_light_color();
		 	else
		 		self.lingxi_icon:set_icon_dead_color();
		 	end
		 	self.lingxi_icon:set_count(count)
		end
	else
		self.lingxi_icon:set_icon_dead_color();
		self.lingxi_icon:set_count(0)
	end

	--更新灵犀值
	if mounts_model.level >= 50 then
		self.lingxi_panel:setIsVisible(true);
		self.hide_lingxi_tip1:setIsVisible(false);
		self.hide_lingxi_tip2:setIsVisible(false);

		if self.lingxi_value then 
			if mounts_model.lingxi == nil or mounts_model.lingxi == 0 then
				mounts_model.lingxi = 100;
			end
			local lingxi_str = string.format(LH_COLOR[3].."+%d",mounts_model.lingxi).."%";
			self.lingxi_value:setString(lingxi_str);

			-- 如果灵犀满值了，就把提升按钮置灰
			if mounts_model.lingxi == 150 then
				self.lingxi_value:setString(Lang.mounts.lingxi_max); -- [2081]="+150%#c38ff33(满)"
				self.tishen_btn:setCurState(CLICK_STATE_DISABLE);
			end
		else 

		end
	else
		self.lingxi_panel:setIsVisible(false);
		self.hide_lingxi_tip1:setIsVisible(true);
		self.hide_lingxi_tip2:setIsVisible(true);
	end
end

--提升灵犀的回调
function MountsInfoPanel:lxts_callback(mounts_model)
	local lingxi_str = string.format("+%d",mounts_model.lingxi).."%";
	self.lingxi_value:setString(lingxi_str);
	-- 如果灵犀满值了，就把提升按钮置灰
	if mounts_model.lingxi == 150 then
		self.lingxi_value:setString(Lang.mounts.lingxi_max); -- [2081]="+150%#c38ff33(满)"
		self.tishen_btn:setCurState(CLICK_STATE_DISABLE);
	end

	--查询是否有灵犀丹
 	local count = ItemModel:get_item_count_by_id(18602);
 	if count > 0 then
 		self.lingxi_icon:set_icon_light_color();
 	else
 		self.lingxi_icon:set_icon_dead_color();
 	end
 	self.lingxi_icon:set_count(count)
end

--播放灵犀特效
function MountsInfoPanel:play_lingxi_success_effect(  )
	LuaEffectManager:play_view_effect( 10014,200,220,self.view,false,999 )
end

-- 更新人物基础属性
function MountsInfoPanel:update_base_att( mounts_model )
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

-- 更新坐骑战斗力
function MountsInfoPanel:change_mount_fight_value( fight_value )
	if self.mounts_fight ~= nil then
		self.mounts_fight:set_number(fight_value);
	end
end

-- 修改坐骑形象
function MountsInfoPanel:change_mounts_avatar(model_id)

	-- if isNextMount then	
	-- 	if MountsModel:get_mounts_info().jieji < 8 then
	-- 		model_id = MountsModel:get_mounts_info().jieji+1;
	-- 	else
	-- 	 	model_id = MountsModel:get_mounts_info().jieji;
	-- 	end
	-- end

	local is_show_other_mounts = MountsModel:is_show_other_mounts()

	-- 更新化形按钮状态
	local model = MountsModel:get_mounts_info();
	if model ~= nil then
		local display_id = model.model_id
		if model.show_id ~= nil and model.show_id ~= 0 then
			display_id = model.show_id
		end
		if model_id ~= display_id and is_show_other_mounts == false then
			self.huaxing_btn.view:setCurState(CLICK_STATE_UP);
		else
			self.huaxing_btn.view:setCurState(CLICK_STATE_DISABLE);
		end
	end

	-- 如果已经是当前坐骑了，不必刷新
	if self.current_mounts_avatar_id == model_id then
		return;
	end

	if self.mounts_avatar ~= nil then
		self.mounts_avatar:removeFromParentAndCleanup(true)
		self.mounts_avatar = nil
		--parent:removeChild(mounts_avatar,true);
	end
 
 	local old_id = self.current_mounts_avatar_id
 	self.current_mounts_avatar_id = model_id;
	local mount_file = string.format("frame/mount/%d",model_id);
	local action = {0,4,4,0.2};
	
	local avatar_pos_y = 100;

	self.mounts_avatar = MUtils:create_animation(185,avatar_pos_y,mount_file,action );
	self.middle_up_panel:addChild(self.mounts_avatar,255)
	
	local mount_config =  MountsConfig:get_mount_data_by_id(model_id);
	if model_id <= #MountsConfig:get_config().stages then
		self.mounts_name:setText(string.format("#cffff00%s",mount_config["name"]));
	else
		for i=1,#MountsConfig:get_config().stagesOther  do
			if MountsConfig:get_config().stagesOther[i].modelId == model_id then
				local cfg = MountsConfig:get_config().stagesOther[i]
					self.mounts_name:setText(string.format("#cffff00%s",cfg["name"]));
				break
			end
		end
	end

	-- 刷新选中框(有可能还未创建)
	if old_id >= 0 then
		if self.mount_icons[old_id] then
			self.mount_icons[old_id]:set_selected(false);
		elseif self.mount_icons_ex[old_id-100] then
			self.mount_icons_ex[old_id-100]:set_selected(false);
		end
	end
	-- 有可能还未创建
	if self.mount_icons[self.current_mounts_avatar_id] then
		self.mount_icons[self.current_mounts_avatar_id]:set_selected(true);
	elseif self.mount_icons_ex[self.current_mounts_avatar_id-100] then
		self.mount_icons_ex[self.current_mounts_avatar_id-100]:set_selected(true);
	end
end

--设置坐骑状态按钮显示
function MountsInfoPanel:setMountsStatus( b )
	if not b then
		self.qi_title_status:setTexture(UILH_MOUNT.chengqi)
	else
		self.qi_title_status:setTexture(UILH_MOUNT.chengqi)
	end
end

function MountsInfoPanel:destroy()
 	for i=1,#self.mount_icons_panel do
 		if self.mount_icons_panel[i] ~= nil then
 			self.mount_icons_panel[i].view:release();
 			self.mount_icons_panel[i] = nil;
 		end
 	end
 	self.mount_icons = {}
 	self.mount_icons_panel = {}

 	for i=1,#self.mount_icons_panel_ex do
 		if self.mount_icons_panel_ex[i] ~= nil then
 			self.mount_icons_panel_ex[i].view:release();
 			self.mount_icons_panel_ex[i] = nil;
 		end
 	end
 	self.mount_icons_ex = {}
 	self.mount_icons_panel_ex = {}

	if self.cd_time_lab then
		self.cd_time_lab:destroy();
		self.cd_time_lab = nil;
	end
end

function MountsInfoPanel:active(show, other_model)
	if show then
		-- 打开前先删除一次性的特效
		LuaEffectManager:stop_view_effect( 403,self.view );
		LuaEffectManager:stop_view_effect( 10014,self.view );

		-- info页面，不仅可能为“玩家坐骑信息”分页，也可能重用为“查看其他人的坐骑信息”的分页
		local mounts_model;
		if other_model ~= nil and MountsModel:is_show_other_mounts() then
			mounts_model = other_model
			self:show_other_mounts(true)
		else
			mounts_model = MountsModel:get_mounts_info();
			self:show_other_mounts(false)
		end

		if mounts_model then 
			self:update(mounts_model);
		end
	else

	end
end

function MountsInfoPanel:play_success_effect(  )
	LuaEffectManager:play_view_effect( 403,450,400,self.view,false,999 )
end

function MountsInfoPanel:show_other_mounts(is_show_other_mounts)
	if is_show_other_mounts then
		self.huaxing_btn:setCurState(CLICK_STATE_DISABLE);
		self.xuanyao_btn:setCurState(CLICK_STATE_DISABLE);
		self.chengqi_btn.view:setIsVisible(false);
		self.uplevel_btn:setCurState(CLICK_STATE_DISABLE);
		self.up_pj_btn:setCurState(CLICK_STATE_DISABLE);
		self.xilian_btn:setCurState(CLICK_STATE_DISABLE);
		self.tishen_btn:setCurState(CLICK_STATE_DISABLE);
		self.clearCD_btn:setCurState(CLICK_STATE_DISABLE);
	else
		self.huaxing_btn:setCurState(CLICK_STATE_UP);
		self.xuanyao_btn:setCurState(CLICK_STATE_UP);
		self.chengqi_btn.view:setIsVisible(true);
		self.uplevel_btn:setCurState(CLICK_STATE_UP);
		self.up_pj_btn:setCurState(CLICK_STATE_UP);
		self.xilian_btn:setCurState(CLICK_STATE_UP);
		self.tishen_btn:setCurState(CLICK_STATE_UP);
		self.clearCD_btn:setCurState(CLICK_STATE_UP);
	end
end