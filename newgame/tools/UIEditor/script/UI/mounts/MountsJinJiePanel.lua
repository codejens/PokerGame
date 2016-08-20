-- MountsJinJiePanel.lua 
-- createed by mwy @2012-5-2
-- refactored by guozhinan @2014-9-25
-- 坐骑进阶页面,不再是window

super_class.MountsJinJiePanel(  )

--是否处于下阶形象
local isNextMount = true;

local _mounts_max_jieji = 6

local is_other_mounts = false;

local font_size = 17;

function MountsJinJiePanel:__init()
	self.view = CCBasePanel:panelWithFile( 5, 8, 890, 518, UILH_COMMON.normal_bg_v2, 500, 500 )

	-- 左上的坐骑形象
	self:create_left_up_panel(10, 187, 431, 320, UILH_COMMON.bottom_bg)

	-- 右上的资质
	self:create_right_up_panel(440, 187, 439, 320,UILH_COMMON.bottom_bg)		

	-- 底部的星星和升阶按钮等
	self:create_bottom_panel(10, 10, 869, 178, UILH_COMMON.bottom_bg)

	-- "等    阶:"
	-- local dengjie_lab = ZLabel:create( self.right_down_panel, "#c0edc09等    阶:", 14, 218, 17 )
	-- self.dangjie = ZLabel:create( self.right_down_panel, "1", 114, 217, 17 )


	-- 最后刷新数据
	self:update();
end

function MountsJinJiePanel:create_left_up_panel(x, y, width, height,texture_path)
	self.left_up_panel = CCBasePanel:panelWithFile( x, y, width, height,texture_path, 500, 500 )
	self.view:addChild(self.left_up_panel)

	-- 资质标题
	local title_panel = CCBasePanel:panelWithFile( (width-356)/2, 273, 356, 49, UILH_NORMAL.title_bg3, 500, 500 )
	self.left_up_panel:addChild(title_panel)
	-- self.next_mount_tip = MUtils:create_zxfont(title_panel,Lang.mounts.jinjie_panel[12],width/2,11,2,17);
	local title_img = CCZXImage:imageWithFile(356/2,23,-1,-1,UILH_MOUNT.xiayijiezuoqi);
	title_img:setAnchorPoint(0.5,0.5)
	title_panel:addChild(title_img)

	-- 四个角纹装饰
	local edge_pattern = CCZXImage:imageWithFile(5, 241,-1,-1,UILH_MOUNT.edge_pattern);
	self.left_up_panel:addChild(edge_pattern)
	edge_pattern = CCZXImage:imageWithFile(5, 12,-1,-1,UILH_MOUNT.edge_pattern);
	edge_pattern:setFlipY(true)	
	self.left_up_panel:addChild(edge_pattern)
	edge_pattern = CCZXImage:imageWithFile(383, 241,-1,-1,UILH_MOUNT.edge_pattern);
	edge_pattern:setFlipX(true)	
	self.left_up_panel:addChild(edge_pattern)
	edge_pattern = CCZXImage:imageWithFile(383, 12,-1,-1,UILH_MOUNT.edge_pattern);
	edge_pattern:setFlipX(true)
	edge_pattern:setFlipY(true)
	self.left_up_panel:addChild(edge_pattern)

	-- 坐骑底板
	local mount_base = CCZXImage:imageWithFile(width/2-160, 35,-1,-1,UILH_MOUNT.mount_base);
	self.left_up_panel:addChild(mount_base)	
	mount_base = CCZXImage:imageWithFile(width/2, 35,-1,-1,UILH_MOUNT.mount_base);
	mount_base:setFlipX(true)
	self.left_up_panel:addChild(mount_base)	

	-- 坐骑名字
	-- self.mounts_name = UILabel:create_lable_2( "#cfff000"..Lang.mounts.default_mounts_name, 145/2, 6, 20, ALIGN_CENTER );
	-- name_bg:addChild(self.mounts_name);
end

function MountsJinJiePanel:create_bottom_panel(x, y, width, height,texture_path)
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

 	--星星的底色
 	-- local start_bg = ZImage:create(self.bottom_panel,nil, 110, 50, 220, -1, nil, 500, 500)	
	--小品阶,星星层 
	local pingjie_full_ex =10    -- 虚拟数据
	self.startLayer = CCLayerColor:layerWithColorWidthHeight(ccc4(0,0,0,0),254,360);
	self.startLayer:setPosition(CCPointMake(110,height - 62));
	self.bottom_panel:addChild(self.startLayer);
	local xiaopingjin = Utils:getIntPart((0*10)/pingjie_full_ex);
	self:drawStart(self.startLayer,xiaopingjin);

    -- 进度条背景
    self.jinjie_progress_bg = CCZXImage:imageWithFile( 286, 94, 300, 23, UILH_NORMAL.progress_bg, 500, 500 )   
    self.bottom_panel:addChild( self.jinjie_progress_bg )
    -- 进度条图片
    local jiezhi = 0     -- 虚拟数据
	local jiehzi_var = jiezhi%(pingjie_full_ex/10);
    self.jinjie_progress = CCZXImage:imageWithFile( 297, 100, 277 * (jiehzi_var/(pingjie_full_ex/10)), 12, UILH_NORMAL.progress_bar, 500, 500 )
    self.bottom_panel:addChild(self.jinjie_progress)
    -- 经验数字
    MUtils:create_zxfont(self.jinjie_progress,jiehzi_var.." / "..pingjie_full_ex/10,277/2,0,2,16)

	--进阶值,[1] = "#cFFB401进 阶 值:",
	local jinjie_lab = ZLabel:create( self.bottom_panel, Lang.mounts.jinjie_panel[1], 190, 100, 17 );

    -- -- [1605]="#c00c0ff优先使用进阶符:#cfff0000"
	self.jinjiefu = MUtils:create_ccdialogEx(self.bottom_panel, Lang.mounts.jinjie_panel[2], 600, 100, 250, 17, 2, 16)	

    -- 三个提升按钮
    local begin_x = 170
    local begin_y = 30
    local column_space = 205
    -- 铜币按钮,[3] = "#cfff000铜币提升"
    local function btn_XB_fun(eventType,x,y)
        if eventType == TOUCH_CLICK then
        	Instruction:handleUIComponentClick(instruct_comps.MOUNT_WIN_XB_JINJIE_BTN)
        	MountsModel:req_mount_up_stage( 1 )
        end
        return true
    end
    local btn1= MUtils:create_btn(self.bottom_panel,UILH_COMMON.btn4_nor,UILH_COMMON.btn4_sel,btn_XB_fun,begin_x,begin_y,121,53)
    MUtils:create_zxfont(btn1,Lang.mounts.jinjie_panel[3],121/2,20,2,16)

    -- 元宝按钮,[4]="#cfff000元宝提升"
    local function btn_YB_fun(eventType,x,y)
        if eventType == TOUCH_CLICK then
        	Instruction:handleUIComponentClick(instruct_comps.MOUNT_WIN_YB_JINJIE_BTN)
   --      	local model = MountsModel:get_mounts_other_info();
   --      	if model == nil then
   --      		return true
   --      	end

			-- local SJ_times = tonumber(model.sj_left_times)
			-- local elapse_time = os.time() - model.sj_start_time
			-- local timeDiff = model.sj_next_cdtimes - elapse_time

			-- if( SJ_times > 0 ) then
			-- 	-- cd时间还没结束，可以使用元宝提升
			-- 	if timeDiff > 0 then
			-- 		MountsModel:req_mount_up_stage( 2 )
			-- 	else
			-- 		-- 免费3次
			-- 		MountsModel:req_mount_up_stage( 5 )
			-- 		-- 如果这个时候,有飘字“骑”,则删掉它,等到CD时间结束的时候,再判断条件是否满足
			-- 		MiniBtnWin:remove_btn_and_layout(tostring(9))
			-- 	end
			-- else
				-- 元宝洗炼
				MountsModel:req_mount_up_stage( 2 )
			-- end
        end
        return true
    end
    local btn2=MUtils:create_btn(self.bottom_panel,UILH_COMMON.btn4_nor,UILH_COMMON.btn4_sel,btn_YB_fun,begin_x + column_space,begin_y,121,53)
    self.ybtsLabel = MUtils:create_zxfont(btn2,Lang.mounts.jinjie_panel[4],121/2,20,2,16)

    -- 50次元宝按钮
    local function btn_50YB_fun(eventType,x,y)
        if eventType == TOUCH_CLICK then
        	if VIPModel:get_vip_info( ).level >= 6 then
		    	-- self:upgrade_50_yb()
		    	MountsModel:req_mount_up_stage( 4 )
		    else 
		    	-- [5]="对不起，VIP等级6级以上才开启次功能."
		    	GuildModel:show_notice_win(Lang.mounts.jinjie_panel[5])
		    end
        end
        return true
    end
    local one_key_50=MUtils:create_btn(self.bottom_panel,UILH_COMMON.btn4_nor,UILH_COMMON.btn4_sel,btn_50YB_fun,begin_x + column_space*2,begin_y,121,53)
    -- [6]="#cfff000提升50次"
    MUtils:create_zxfont(one_key_50,Lang.mounts.jinjie_panel[6],121/2,20,2,16)

    MUtils:create_zxfont(btn1,Lang.mounts.jinjie_panel[7],121/2,-20,2,16)	-- [7]="#cfff0001万铜币"
    MUtils:create_zxfont(btn2,Lang.mounts.jinjie_panel[8],121/2,-20,2,16)	-- [8]="#cfff00030元宝/绑元"
    MUtils:create_zxfont(one_key_50,Lang.mounts.jinjie_panel[9],121/2,-20,2,16)	-- [9]="#cfff0001500元宝/绑元"
end

function MountsJinJiePanel:create_right_up_panel(x, y, width, height,texture_path)
	self.right_up_panel = CCBasePanel:panelWithFile( x, y, width, height, texture_path, 500, 500 )
	self.view:addChild(self.right_up_panel,100)

	-- 资质标题
	local title_panel = CCBasePanel:panelWithFile( 6, height-39, width-12, 34, UILH_NORMAL.title_bg4, 500, 500 )
	self.right_up_panel:addChild(title_panel)
	MUtils:create_zxfont(title_panel,Lang.mounts.jinjie_panel[13],109-10,11,2,17);
	MUtils:create_zxfont(title_panel,Lang.mounts.jinjie_panel[14],327-10,11,2,17);

	-- 资质属性,一开始设置虚拟数据，之后刷新
	local currentPj = {"0","0","0","0","0"}
	local standard_x = 80;
	local next_x = 300;
	local top_y = 240;
	local row_space = 45;
	local attr_offset = 50
	local arrow_offset = 115
	local max_value_offset = 200
	local zizhi_font_size = 18	
	-- 生命
	local hp_lab = UILabel:create_label_1(Lang.mounts.user_attr.hp, CCSizeMake(80,20), standard_x, top_y+2 , zizhi_font_size, CCTextAlignmentLeft);
	hp_lab:setAnchorPoint(CCPointMake(0,0));
	self.right_up_panel:addChild(hp_lab);
	-- 基本资质
	self.hp_att = UILabel:create_lable_2(currentPj[1], standard_x + attr_offset, top_y-8, zizhi_font_size, ALIGN_LEFT );--UILabel:create_label_1(string.format("%d",currentPj[1]), CCSizeMake(37,20), 13+69+29-20, 96+2+11, 13, CCTextAlignmentRight, 255, 255, 255);
	self.hp_att:setAnchorPoint(CCPointMake(0,0));
	self.right_up_panel:addChild(self.hp_att);
	-- 箭头
	local arrow = CCZXImage:imageWithFile(standard_x+arrow_offset,top_y-16,-1,-1,UILH_COMMON.right_arrows);
	self.right_up_panel:addChild(arrow);
	-- 生命
	hp_lab = UILabel:create_label_1(Lang.mounts.user_attr.hp, CCSizeMake(80,20), next_x, top_y+2 , zizhi_font_size, CCTextAlignmentLeft);
	hp_lab:setAnchorPoint(CCPointMake(0,0));
	self.right_up_panel:addChild(hp_lab);
	-- 下一级资质
	self.hp_att_next = UILabel:create_lable_2(currentPj[1], next_x + attr_offset, top_y-8, zizhi_font_size, ALIGN_LEFT );--UILabel:create_label_1(string.format("%d",currentPj[1]), CCSizeMake(37,20), 13+69+29-20, 96+2+11, 13, CCTextAlignmentRight, 255, 255, 255);
	self.hp_att_next:setAnchorPoint(CCPointMake(0,0));
	self.right_up_panel:addChild(self.hp_att_next);

	-- 攻击
	top_y = top_y - row_space
	local at_lab = UILabel:create_label_1(Lang.mounts.user_attr.attack, CCSizeMake(80,20), standard_x, top_y+2 , zizhi_font_size, CCTextAlignmentLeft);
	at_lab:setAnchorPoint(CCPointMake(0,0));
	self.right_up_panel:addChild(at_lab);
	-- 基本资质
	self.at_att = UILabel:create_lable_2(currentPj[2], standard_x + attr_offset, top_y-7, zizhi_font_size, ALIGN_LEFT );
	self.at_att:setAnchorPoint(CCPointMake(0,0));
	self.right_up_panel:addChild(self.at_att);
	-- 箭头
	arrow = CCZXImage:imageWithFile(standard_x+arrow_offset,top_y-16,-1,-1,UILH_COMMON.right_arrows);
	self.right_up_panel:addChild(arrow);
	-- 攻击
	at_lab = UILabel:create_label_1(Lang.mounts.user_attr.attack, CCSizeMake(80,20), next_x, top_y+2 , zizhi_font_size, CCTextAlignmentLeft);
	at_lab:setAnchorPoint(CCPointMake(0,0));
	self.right_up_panel:addChild(at_lab);
	-- 基本资质
	self.at_att_next = UILabel:create_lable_2(currentPj[2], next_x + attr_offset, top_y-7, zizhi_font_size, ALIGN_LEFT );
	self.at_att_next:setAnchorPoint(CCPointMake(0,0));
	self.right_up_panel:addChild(self.at_att_next);	

	-- 法术防御
	top_y = top_y - row_space
	local md_lab = UILabel:create_label_1(Lang.mounts.user_attr.innerDefence, CCSizeMake(80,20), standard_x, top_y+2 , zizhi_font_size, CCTextAlignmentLeft);
	md_lab:setAnchorPoint(CCPointMake(0,0));
	self.right_up_panel:addChild(md_lab);
	-- 基本资质
	self.md_att = UILabel:create_lable_2(currentPj[3], standard_x + attr_offset, top_y-7, zizhi_font_size, ALIGN_LEFT );
	self.md_att:setAnchorPoint(CCPointMake(0,0));
	self.right_up_panel:addChild(self.md_att);
	-- 箭头
	arrow = CCZXImage:imageWithFile(standard_x+arrow_offset,top_y-16,-1,-1,UILH_COMMON.right_arrows);
	self.right_up_panel:addChild(arrow);
	-- 法术防御
	md_lab = UILabel:create_label_1(Lang.mounts.user_attr.innerDefence, CCSizeMake(80,20), next_x, top_y+2 , zizhi_font_size, CCTextAlignmentLeft);
	md_lab:setAnchorPoint(CCPointMake(0,0));
	self.right_up_panel:addChild(md_lab);
	-- 基本资质
	self.md_att_next = UILabel:create_lable_2(currentPj[3], next_x + attr_offset, top_y-7, zizhi_font_size, ALIGN_LEFT );
	self.md_att_next:setAnchorPoint(CCPointMake(0,0));
	self.right_up_panel:addChild(self.md_att_next);	

	-- 物理防御
	top_y = top_y - row_space
	local wd_lab = UILabel:create_label_1(Lang.mounts.user_attr.outDefence, CCSizeMake(80,20), standard_x, top_y+2 , zizhi_font_size, CCTextAlignmentLeft);
	wd_lab:setAnchorPoint(CCPointMake(0,0));
	self.right_up_panel:addChild(wd_lab);
	-- 基本资质
	self.wd_att = UILabel:create_lable_2(currentPj[4], standard_x + attr_offset, top_y-7, zizhi_font_size, ALIGN_LEFT );
	self.wd_att:setAnchorPoint(CCPointMake(0,0));
	self.right_up_panel:addChild(self.wd_att);
	-- 箭头
	arrow = CCZXImage:imageWithFile(standard_x+arrow_offset,top_y-16,-1,-1,UILH_COMMON.right_arrows);
	self.right_up_panel:addChild(arrow);
	-- 物理防御
	wd_lab = UILabel:create_label_1(Lang.mounts.user_attr.outDefence, CCSizeMake(80,20), next_x, top_y+2 , zizhi_font_size, CCTextAlignmentLeft);
	wd_lab:setAnchorPoint(CCPointMake(0,0));
	self.right_up_panel:addChild(wd_lab);
	-- 基本资质
	self.wd_att_next = UILabel:create_lable_2(currentPj[4], next_x + attr_offset, top_y-7, zizhi_font_size, ALIGN_LEFT );
	self.wd_att_next:setAnchorPoint(CCPointMake(0,0));
	self.right_up_panel:addChild(self.wd_att_next);	

	-- 暴击
	top_y = top_y - row_space
	local bj_lab = UILabel:create_label_1(Lang.mounts.user_attr.criticalStrikes, CCSizeMake(80,20), standard_x, top_y+2 , zizhi_font_size, CCTextAlignmentLeft);
	bj_lab:setAnchorPoint(CCPointMake(0,0));
	self.right_up_panel:addChild(bj_lab);
	-- 基本资质
	self.bj_att = UILabel:create_lable_2(currentPj[5], standard_x + attr_offset, top_y-7, zizhi_font_size, ALIGN_LEFT );
	self.bj_att:setAnchorPoint(CCPointMake(0,0));
	self.right_up_panel:addChild(self.bj_att);
	-- 箭头
	arrow = CCZXImage:imageWithFile(standard_x+arrow_offset,top_y-16,-1,-1,UILH_COMMON.right_arrows);
	self.right_up_panel:addChild(arrow);
	-- 暴击
	bj_lab = UILabel:create_label_1(Lang.mounts.user_attr.criticalStrikes, CCSizeMake(80,20), next_x, top_y+2 , zizhi_font_size, CCTextAlignmentLeft);
	bj_lab:setAnchorPoint(CCPointMake(0,0));
	self.right_up_panel:addChild(bj_lab);
	-- 基本资质
	self.bj_att_next = UILabel:create_lable_2(currentPj[5], next_x + attr_offset, top_y-7, zizhi_font_size, ALIGN_LEFT );
	self.bj_att_next:setAnchorPoint(CCPointMake(0,0));
	self.right_up_panel:addChild(self.bj_att_next);
end

-- 一键50次
-- function MountsJinJiePanel:upgrade_50_yb()
-- 	local function sure_fun()
-- 		MountsModel:req_mount_up_stage( 4 )
-- 	end
-- 	local str = "";
-- 	local jinjiefu_num = ItemModel:get_item_count_by_id( 18612 );
-- 	print("坐骑进阶符，",jinjiefu_num);
-- 	if jinjiefu_num >= 50 then
-- 		str = "是否消耗50个进阶符提升50次";
-- 	else
-- 		local count = 50 - jinjiefu_num;
-- 		local yb_cost = count * 30;
-- 		if yb_cost > EntityManager:get_player_avatar().yuanbao then
-- 			-- 如果需要的元宝大于拥有的元宝
-- 			local function confirm2_func()
-- 	            UIManager:show_window( "ios_win" )
-- 	    	end
-- 	    		ConfirmWin2:show( 2, 2, "",  confirm2_func)
-- 	    	return true;

--     	end
-- 		str = string.format("是否消耗%d个进阶符%d元宝提升50次",jinjiefu_num, yb_cost);
-- 	end
--     SetSystemModel:get_date_value_by_key_and_tip( SetSystemModel.COST_MOUNT ,sure_fun,str )	
-- end


-- 绘制星星
function MountsJinJiePanel:drawStart(start_layer,start_count)
	-- 清楚所有星星
	start_layer:removeAllChildrenWithCleanup(true);
	for i=0,9 do
		local star = CCZXImage:imageWithFile(65*i,8,51,48,UILH_NORMAL.star);
		-- star:addTexWithFile(CLICK_STATE_DISABLE, "ui/common/star_gray.png")
		star:setTag(i);
		self.startLayer:addChild(star);
		if i>(start_count-1) then 
			star:setCurState(CLICK_STATE_DISABLE);
		end
	end
end


-- 更新界面
function MountsJinJiePanel:update(  )
	local model = MountsModel:get_mounts_info();
	if not model then
		return
	end
	-- self:set_btns_visiable(is_other_mounts)
	--改变外观
	self:change_mounts_avatar(model.model_id);
	local mounts_config = MountsConfig:get_mount_data_by_id(model.jieji);

	self:change_mount_fight_value( model.fight )

	-- self:update_base_att(model);

	-- if self.dangjie then
	-- 	self.dangjie:setText( tostring(model.jieji) );
	-- end

	------------------------------更新坐骑资质---------------------------------

	local num = ItemModel:get_item_count_by_id( 18612 );
    self.jinjiefu:setText(Lang.mounts.jinjie_panel[2]..num); -- [1596]="#c00c0ff优先使用进阶符:#cfff000"

	-- 品阶的满经验
	local pingjie_full_ex = mounts_config["point"];
	-- 品阶里的星星颗数
	local xiaopingjin = Utils:getIntPart((model.jiezhi*10)/pingjie_full_ex);

	--更新品阶
	-- pinjie:setString(string.format(LangGameString[1581],model.jieji)); -- [1581]="%d阶"
	--更新进度条
	self.bottom_panel:removeChild(self.jinjie_progress, true)
	local jiehzi_var = model.jiezhi%(pingjie_full_ex/10);
    self.jinjie_progress = CCZXImage:imageWithFile( 297, 100, 277 * (jiehzi_var/(pingjie_full_ex/10)), 12, UILH_NORMAL.progress_bar, 500, 500 )
    self.bottom_panel:addChild( self.jinjie_progress )
    -- 进度条数字
    MUtils:create_zxfont(self.jinjie_progress,jiehzi_var.." / "..pingjie_full_ex/10,277/2,0,2,16)
	-- 更新星星数量
	self:drawStart(self.startLayer,xiaopingjin);

 	--刷新资质
	local zizhi_base= mounts_config["base"];
	local currentPj = zizhi_base[xiaopingjin+1];
	local mounts_rate = MountsConfig:getRate();
	local attri_base = MountsConfig:getAttriBase();
	-- 基础资质
	local attr_value = {}
	for i=1,5 do
		attr_value[i] = ((model.jieji-1)*10+xiaopingjin) * currentPj[i] * mounts_rate[i] + attri_base[i] 
	end
	self.hp_att:setText(LH_COLOR[2]..math.floor(attr_value[1]));
	self.at_att:setText(LH_COLOR[2]..math.floor(attr_value[2]));
	self.md_att:setText(LH_COLOR[2]..math.floor(attr_value[3]));
	self.wd_att:setText(LH_COLOR[2]..math.floor(attr_value[4]));
	self.bj_att:setText(LH_COLOR[2]..math.floor(attr_value[5]));
	-- 下一级资质
	local nextPj;
	if xiaopingjin < 9 then
		nextPj = zizhi_base[xiaopingjin+2];
	elseif xiaopingjin == 9 then
		-- 取下一阶的第1星级
		local next_stage = MountsConfig:get_mount_data_by_id( model.jieji + 1 );
		if next_stage then
			nextPj = next_stage["base"][1];
		end
	end
	-- 在7阶的开始就提示已满
	if nextPj and model.jieji ~= _mounts_max_jieji then
		local next_jieji = model.jieji
		local next_xiaopingjin = xiaopingjin + 1
		local attr_value = {}
		for i=1,5 do
			attr_value[i] = ((next_jieji-1)*10+next_xiaopingjin) * nextPj[i] * mounts_rate[i] + attri_base[i] 
		end		
		self.hp_att_next:setText(LH_COLOR[2]..math.floor(attr_value[1]));
		self.at_att_next:setText(LH_COLOR[2]..math.floor(attr_value[2]));
		self.md_att_next:setText(LH_COLOR[2]..math.floor(attr_value[3]));
		self.wd_att_next:setText(LH_COLOR[2]..math.floor(attr_value[4]));
		self.bj_att_next:setText(LH_COLOR[2]..math.floor(attr_value[5]));
	else
		-- #cd0cda2已满阶,后续将开放更高阶坐骑
		self.hp_att_next:setText(Lang.mounts.jinjie_panel[15]);
		self.at_att_next:setText(Lang.mounts.jinjie_panel[15]);
		self.md_att_next:setText(Lang.mounts.jinjie_panel[15]);
		self.wd_att_next:setText(Lang.mounts.jinjie_panel[15]);
		self.bj_att_next:setText(Lang.mounts.jinjie_panel[15]);
	end	
end

-- 更新人物基础属性
-- function MountsJinJiePanel:update_base_att( mounts_model )
-- 	if not mounts_model then
-- 		return
-- 	end
-- 	local mounts_config = MountsConfig:get_mount_data_by_id(mounts_model.jieji);

-- 	--属性变成基础属性+灵犀加成

-- 	local hp_var =tonumber( mounts_model.att_hp )
-- 	--+ self:calculate_attribute_add(mounts_model.att_hp,mounts_model.lingxi);
-- 	local at_var = tonumber(mounts_model.att_attack)
-- 	--+self:calculate_attribute_add(mounts_model.att_attack,mounts_model.lingxi);
-- 	local md_var = tonumber(mounts_model.att_md)
-- 	--+self:calculate_attribute_add(mounts_model.att_md,mounts_model.lingxi);
-- 	local wd_var =tonumber( mounts_model.att_wd)
-- 	--+self:calculate_attribute_add(mounts_model.att_wd,mounts_model.lingxi); 
-- 	local bj_var =tonumber( mounts_model.att_bj)
-- 	--+self:calculate_attribute_add(mounts_model.att_bj,mounts_model.lingxi);

-- 	self.hp_exten_all:setText(string.format("%d",hp_var));
-- 	self.at_exten_all:setText(string.format("%d",at_var));
-- 	self.md_exten_all:setText(string.format("%d",md_var));
-- 	self.wd_exten_all:setText(string.format("%d",wd_var));
-- 	self.bj_exten_all:setText(string.format("%d",bj_var));

-- 	--速度加成要另外算
-- 	local speed = mounts_config["moveSpeed"];
-- 	local speed_ex =  math.abs(900*900/(900+speed)-900);
-- 	self.seep_exten_all:setText(string.format("#ce0fcff+%d",speed_ex));
-- end

-- 更新坐骑战斗力
function MountsJinJiePanel:change_mount_fight_value( fight_value )
	if self.mounts_fight ~= nil then
		self.mounts_fight:init(tostring(fight_value));
	end
end

-- 修改坐骑形象
function MountsJinJiePanel:change_mounts_avatar(model_id)
	
	if isNextMount then	
		if MountsModel:get_mounts_info().jieji < _mounts_max_jieji then
			-- self.next_mount_tip:setText(Lang.mounts.jinjie_panel[12])
			model_id = MountsModel:get_mounts_info().jieji+1;
		else
			-- self.next_mount_tip:setText(Lang.mounts.jinjie_panel[16])
		 	model_id = MountsModel:get_mounts_info().jieji;
		end
	end

	if self.mounts_avatar ~= nil then
		self.mounts_avatar:removeFromParentAndCleanup(true)
		self.mounts_avatar = nil
		--parent:removeChild(mounts_avatar,true);
	end
 
	local mount_file = string.format("frame/mount/%d",model_id);
	local action = {0,4,4,0.2};
	
	local avatar_pos_y = 50;

	self.mounts_avatar = MUtils:create_animation(389/2+10,avatar_pos_y,mount_file,action );
	self.left_up_panel:addChild(self.mounts_avatar,255)
	
	-- local mount_config =  MountsConfig:get_mount_data_by_id(model_id);
	-- self.mounts_name:setText(string.format("#cffff00%s",mount_config["name"]));

end

--计算基本属性的加成
function MountsJinJiePanel:calculate_attribute_add(base,percent)
	
	return base*percent/100-base;
end

function MountsJinJiePanel:destroy()

end

-- 升阶的回调
local _old_pingjia = -1
function MountsJinJiePanel:jinjie_tisheng_callback( mounts_model )

	-- 绘制星星
	-- local xiaopingjin = Utils:getIntPart((mounts_model.jiezhi*10)/point);
	-- if _old_pingjia~=-1 and _old_pingjia~=xiaopingjin then
	-- 	local spr = LuaEffectManager:play_view_effect( 16, 550, 250,self.view, false);
	-- 	spr:setPosition(CCPointMake(640, 210))
	-- end
	-- _old_pingjia=xiaopingjin
	-- self:drawStart(self.startLayer,xiaopingjin);

	self:update()
end

function MountsJinJiePanel:active(show)
	-- 由win调用，目前没有传入false的情况
	if not show then
		-- local mounts_other_model = MountsModel:get_mounts_other_info();
		-- local model = MountsModel:get_mounts_info();
		-- if not mounts_other_model or not model then
		-- 	return
		-- end

		-- local elapse_time = os.time() - mounts_other_model.sj_start_time
		-- local remain_time = mounts_other_model.sj_next_cdtimes - elapse_time
		-- if remain_time < 0 then
		-- 	remain_time = 0
		-- end
		-- if mounts_other_model.sj_left_times > 0 and model.jieji < 7 and remain_time == 0 then
		-- 	local exist = MiniBtnWin:is_already_exist(9)

		-- 	-- 如果已经存在,则不添加,否则添加“骑”字到其中
		-- 	if not exist then
		-- 		local function mini_but_func(  )
  --   				UIManager:show_window( "mounts_win_new" )
  --   			end 
		-- 		MiniBtnWin:show( 9, mini_but_func )
		-- 	end
		-- end
	else
		self:update();
	end
end