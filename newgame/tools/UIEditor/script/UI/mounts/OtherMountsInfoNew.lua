-- OtherMountsInfoNew.lua 
-- createed by xiehande @2014-11- 15
-- 坐骑信息页面。包含进阶、升级和灵犀。

super_class.OtherMountsInfoNew(  )

local font_size = 16;

function OtherMountsInfoNew:__init()
   self.view = CCBasePanel:panelWithFile( 8, 8, 884, 515, UILH_COMMON.normal_bg_v2, 500, 500 )
    local bg_panel = self.view
	self.current_mounts_avatar_id = -1
	self:create_left_panel(12, 12, 429, 490,bg_panel,UILH_COMMON.bottom_bg)
	self:create_right_panel(427+16, 12, 429, 490,bg_panel,UILH_COMMON.bottom_bg)

end


--左边
 function OtherMountsInfoNew:create_left_panel(x,y,width,height,panel,texture_img)
    self.left_bg = CCBasePanel:panelWithFile(x,y,width,height, texture_img, 500, 500 )
	panel:addChild(self.left_bg)

	--左上
	-- 四个角纹装饰
	local edge_pattern = CCZXImage:imageWithFile(6, 443,-1,-1,UILH_MOUNT.edge_pattern);
	self.left_bg:addChild(edge_pattern)
	edge_pattern = CCZXImage:imageWithFile(6, 207,-1,-1,UILH_MOUNT.edge_pattern);
	edge_pattern:setFlipY(true)	
	self.left_bg:addChild(edge_pattern)
	edge_pattern = CCZXImage:imageWithFile(383, 443,-1,-1,UILH_MOUNT.edge_pattern);
	edge_pattern:setFlipX(true)	
	self.left_bg:addChild(edge_pattern)
	edge_pattern = CCZXImage:imageWithFile(383, 207,-1,-1,UILH_MOUNT.edge_pattern);
	edge_pattern:setFlipX(true)
	edge_pattern:setFlipY(true)
	self.left_bg:addChild(edge_pattern)

    local title_bg = CCZXImage:imageWithFile( 43, 438, -1, -1, UILH_NORMAL.title_bg3 )
	-- 坐骑名字
	self.mounts_name = UILabel:create_lable_2( "#cfff000"..Lang.mounts.default_mounts_name, 176, 15, 20, ALIGN_CENTER );
	title_bg:addChild(self.mounts_name);
	self.left_bg:addChild(title_bg)

    
    -- 坐骑底板
	local mount_base = CCZXImage:imageWithFile(width/2-160, 245,-1,-1,UILH_MOUNT.mount_base);
	self.left_bg:addChild(mount_base)	
	mount_base = CCZXImage:imageWithFile(width/2, 245,-1,-1,UILH_MOUNT.mount_base);
	mount_base:setFlipX(true)
	self.left_bg:addChild(mount_base)	


	--左下
		-- 战斗力文字
	local power_title = CCZXImage:imageWithFile(140,420,-1,-1, UILH_ROLE.text_zhandouli)
    self.left_bg:addChild(power_title)
    -- 战斗力值
    local function get_num_ima( one_num )
        return string.format("ui/lh_other/number1_%d.png",one_num);
    end
    self.mounts_fight = ImageNumberEx:create("0",get_num_ima,16)
    self.mounts_fight.view:setPosition(CCPointMake(230,431))
    self.left_bg:addChild( self.mounts_fight.view )

	--增加属性标题
	local left_down_title_panel = CCBasePanel:panelWithFile( 0, 162, 429, 31, UILH_NORMAL.title_bg4, 500, 500 )
	self.left_bg:addChild(left_down_title_panel)
	MUtils:create_zxfont(left_down_title_panel,Lang.mounts.info_panel[1],429/2,11,2,15);

	local x = 35
	local top_y = 110
	local row_space = 35

	-- 攻击
	local at_lab = ZLabel:create( self.left_bg, Lang.mounts.user_attr.attack, x,  top_y, font_size, ALIGN_LEFT )
	-- 攻击增幅
	self.at_exten_all = ZLabel:create( self.left_bg, "", x+100, top_y, font_size, ALIGN_LEFT )


	--生命
	top_y = top_y - row_space;
	local hp_lab = ZLabel:create( self.left_bg, Lang.mounts.user_attr.hp, x, top_y, font_size, ALIGN_LEFT )
	-- 生命增幅
	self.hp_exten_all = ZLabel:create( self.left_bg, "", x+100, top_y, font_size, ALIGN_LEFT )

	-- 暴击
	top_y = top_y - row_space;
	local bj_lab = ZLabel:create( self.left_bg, Lang.mounts.user_attr.criticalStrikes, x, top_y, font_size, ALIGN_LEFT )
	-- 暴击增幅
	self.bj_exten_all = ZLabel:create( self.left_bg, "", x+100, top_y, font_size, ALIGN_LEFT )



	-- 物理防御
	top_y = 110;
	 x = 258
	local wd_lab = ZLabel:create( self.left_bg, Lang.mounts.user_attr.outDefence, x,  top_y, font_size, ALIGN_LEFT )
	-- 物理防御增幅
	self.wd_exten_all = ZLabel:create( self.left_bg, "", x+100, top_y, font_size, ALIGN_LEFT )

	-- 精神防御
	top_y = top_y - row_space;
	local md_lab = ZLabel:create( self.left_bg, Lang.mounts.user_attr.innerDefence, x, top_y, font_size, ALIGN_LEFT )
	-- 精神防御增幅
	self.md_exten_all = ZLabel:create( self.left_bg, "", x+100, top_y, font_size, ALIGN_LEFT )

	-- 移动速度
	top_y = top_y - row_space;
	local seep_lab = ZLabel:create(self.left_bg, LH_COLOR[6]..Lang.mounts.user_attr.moveSpeed, x,  top_y, font_size, ALIGN_LEFT )
	-- 移动速度增幅
	self.seep_exten_all = ZLabel:create( self.left_bg, "", x+100, top_y, font_size, ALIGN_LEFT )

 end

   --右边
 function OtherMountsInfoNew:create_right_panel(x,y,width,height,panel,texture_img)
    self.right_bg = CCBasePanel:panelWithFile( x,y,width,height, texture_img, 500, 500 )
	panel:addChild(self.right_bg)

	local standard_x = 75;
    local top_y = 450
    local top_y2 = 450 - 35

   --右上
	-- 等级
	local level_lab = UILabel:create_label_1(LH_COLOR[2]..Lang.mounts.dengji, CCSizeMake(100,27), standard_x, top_y, font_size, CCTextAlignmentLeft); -- [2085]="等     级:"
	self.right_bg:addChild(level_lab);

	-- 等级数值
	self.level = UILabel:create_label_1("999", CCSizeMake(50,20), standard_x+50, top_y, font_size, CCTextAlignmentLeft, 255, 255, 255);
	self.right_bg:addChild(self.level);

	-- 进度lab
	local pro_lab = UILabel:create_label_1(LH_COLOR[2]..Lang.mounts.jindu, CCSizeMake(100,27), 230, height - 42, font_size, CCTextAlignmentLeft); -- [2086]="进   度:"
	self.right_bg:addChild(pro_lab);

	-- 等级进度
	self.level_progress = ZXProgress:createWithValueEx(0,100,155,18,UILH_NORMAL.progress_bg2,UILH_NORMAL.progress_bar_yellow2);
	self.level_progress:setPosition(CCPointMake(260,height - 55));
	self.right_bg:addChild(self.level_progress);


	-- 品阶
	local pj_lab = UILabel:create_label_1(LH_COLOR[2]..Lang.mounts.pinjie, CCSizeMake(100,27), standard_x, top_y2, font_size, CCTextAlignmentLeft); -- [2085]="等     级:"
	self.right_bg:addChild(pj_lab);

	-- 品阶和星级数值
	self.pj_number_label = UILabel:create_label_1("0", CCSizeMake(50,20), standard_x+50, top_y2, font_size, CCTextAlignmentLeft, 255, 255, 255);
	self.right_bg:addChild(self.pj_number_label);

	-- 进度lab
	local pro_lab = UILabel:create_label_1(LH_COLOR[2]..Lang.mounts.jindu, CCSizeMake(100,27), 230, top_y2, font_size, CCTextAlignmentLeft); -- [2086]="进   度:"
	self.right_bg:addChild(pro_lab);

	-- 品阶进度条和进度条上的文字
	self.jinjie_progress = ZXProgress:createWithValueEx(0,100,155,18,UILH_NORMAL.progress_bg2,UILH_NORMAL.progress_bar_blue2);
	self.jinjie_progress:setPosition(CCPointMake(260,405));
    self.right_bg:addChild(self.jinjie_progress);




    --右中  坐骑资质
	-- 资质标题
	local title_panel = CCBasePanel:panelWithFile( 0, 333, 429, 31, UILH_NORMAL.title_bg4, 500, 500 )
	self.right_bg:addChild(title_panel)
	MUtils:create_zxfont(title_panel,Lang.mounts.info_panel[6],429/2,11,2,15);

	--资质属性
	local top_y = 310;
	local row_space = 32;
	local attr_offset = 70
	local exten = 115
	local zizhi_font_size = 17
	standard_x = 100-13
    
    	-- 攻击
	local at_lab = UILabel:create_label_1(Lang.mounts.user_attr.attack, CCSizeMake(100,27), standard_x, top_y , zizhi_font_size, CCTextAlignmentLeft); -- [1506]="攻    击:"
	self.right_bg:addChild(at_lab);
	-- 基本资质
	self.at_att = UILabel:create_label_1("", CCSizeMake(37,20), standard_x+attr_offset, top_y, zizhi_font_size, CCTextAlignmentRight, 255, 255, 255);
	self.right_bg:addChild(self.at_att);
	-- 增幅资质
	self.at_exten = UILabel:create_label_1("", CCSizeMake(50,20), standard_x+exten, top_y, zizhi_font_size, CCTextAlignmentLeft);
	self.right_bg:addChild(self.at_exten);

	top_y = top_y - row_space;
	-- 生命
	local hp_lab = UILabel:create_label_1(Lang.mounts.user_attr.hp, CCSizeMake(100,27), standard_x, top_y , zizhi_font_size, CCTextAlignmentLeft); -- [1509]="生    命:"
	self.right_bg:addChild(hp_lab);
	-- 基本资质
	self.hp_att = UILabel:create_label_1("", CCSizeMake(37,20), standard_x+attr_offset, top_y, zizhi_font_size, CCTextAlignmentRight, 255, 255, 255);
	self.right_bg:addChild(self.hp_att);
	-- 增幅资质
	self.hp_exten = UILabel:create_label_1("", CCSizeMake(50,20), standard_x+exten, top_y, zizhi_font_size, CCTextAlignmentLeft);
	self.right_bg:addChild(self.hp_exten);


	-- 暴击
	top_y = top_y - row_space;
	local bj_lab = UILabel:create_label_1(Lang.mounts.user_attr.criticalStrikes, CCSizeMake(100,27), standard_x, top_y , zizhi_font_size, CCTextAlignmentLeft); -- [2091]="暴    击:"
	self.right_bg:addChild(bj_lab);
	-- 基本资质
	self.bj_att = UILabel:create_label_1("", CCSizeMake(37,20), standard_x+attr_offset, top_y, zizhi_font_size, CCTextAlignmentRight, 255, 255, 255);
	self.right_bg:addChild(self.bj_att);
	-- 增幅资质
	self.bj_exten = UILabel:create_label_1("", CCSizeMake(50,20), standard_x+exten, top_y, zizhi_font_size, CCTextAlignmentLeft);
	self.right_bg:addChild(self.bj_exten);


	-- 物理防御
	top_y = 310;
	standard_x =280
	local wd_lab = UILabel:create_label_1(Lang.mounts.user_attr.outDefence, CCSizeMake(100,27), standard_x, top_y , zizhi_font_size, CCTextAlignmentLeft); -- [1507]="物理防御:"
	self.right_bg:addChild(wd_lab);
	-- 基本资质
	self.wd_att = UILabel:create_label_1("", CCSizeMake(37,20), standard_x+attr_offset, top_y, zizhi_font_size, CCTextAlignmentRight, 255, 255, 255);
	self.right_bg:addChild(self.wd_att);
	-- 增幅资质
	self.wd_exten = UILabel:create_label_1("", CCSizeMake(50,20), standard_x+exten, top_y, zizhi_font_size, CCTextAlignmentLeft);
	self.right_bg:addChild(self.wd_exten);


	-- 法术防御
	top_y = top_y - row_space;
	local md_lab = UILabel:create_label_1(Lang.mounts.user_attr.innerDefence, CCSizeMake(100,27), standard_x, top_y , zizhi_font_size, CCTextAlignmentLeft); -- [1510]="法术防御:"
	self.right_bg:addChild(md_lab);
	-- 基本资质
	self.md_att = UILabel:create_label_1("", CCSizeMake(37,20), standard_x+attr_offset, top_y, zizhi_font_size, CCTextAlignmentRight, 255, 255, 255);
	self.right_bg:addChild(self.md_att);
	-- 增幅资质
	self.md_exten = UILabel:create_label_1("", CCSizeMake(50,20), standard_x+exten, top_y, zizhi_font_size, CCTextAlignmentLeft);
	self.right_bg:addChild(self.md_exten);



    

    --右下  灵犀值
	self.lingxi_panel = CCBasePanel:panelWithFile( 0, 0, width, height,nil, 500, 500 )
	self.lingxi_panel:setIsVisible(false)
	self.right_bg:addChild(self.lingxi_panel)

	--标题：灵犀值
	local title_panel = CCBasePanel:panelWithFile( 0, 162, 429, 31, UILH_NORMAL.title_bg4, 500, 500 )
	self.right_bg:addChild(title_panel)
	MUtils:create_zxfont(title_panel,Lang.mounts.info_panel[2],429/2,11,2,15);

	-- 灵犀丹
	local function lingxi_tip(  )
		TipsModel:show_shop_tip(400,200,18602);
	end
	self.lingxi_icon = MUtils:create_slot_item2(self.lingxi_panel,UILH_COMMON.slot_bg,122,54,68,68,nil,lingxi_tip,7);
	self.lingxi_icon:set_icon_texture("icon/item/00306.pd");
	-- 灵犀丹名字
	local lingxi_name_label = UILabel:create_label_1(Lang.mounts.lingxi_drug, CCSizeMake(50,20), 255, 122, font_size, nil, 255, 240, 0); -- [2094]="灵犀丹"
	self.lingxi_panel:addChild(lingxi_name_label);	
	-- 灵犀丹获得提示
	local lingxi_tip = UILabel:create_label_1(Lang.mounts.lingxi_drug_get_tip, CCSizeMake(160,20), width/2, 13, 14, CCTextAlignmentCenter, 0, 192, 255); -- [2097]="提示:灵犀丹在梦境里获得"
	self.lingxi_panel:addChild(lingxi_tip);
	-- 灵犀值标题
	local lingxi_number_title = UILabel:create_label_1(Lang.mounts.user_attr.lingxi, CCSizeMake(60,20), 221, 88, font_size, nil); -- [2095]="灵犀值："
	self.lingxi_panel:addChild(lingxi_number_title);	
	-- 灵犀值
	self.lingxi_value = UILabel:create_label_1("00", CCSizeMake(60,20), 295, 88, font_size, nil, 255, 240, 0);
	self.lingxi_panel:addChild(self.lingxi_value);
	-- 成功率标题
	local lingxi_rate_title = UILabel:create_label_1(Lang.mounts.success_rate, CCSizeMake(90,20), 221, 54, font_size, nil); -- [2096]="成功率:"
	self.lingxi_panel:addChild(lingxi_rate_title);
	-- 成功率,固定60%
	local lingxi_succ = UILabel:create_label_1(LH_COLOR[15].."+60%", CCSizeMake(60,20), 298, 54, font_size, nil);
	self.lingxi_panel:addChild(lingxi_succ);

	self.hide_lingxi_tip1 = MUtils:create_zxfont(self.right_bg,Lang.mounts.info_panel[7],width/2,100,2,17);
	self.hide_lingxi_tip2 = MUtils:create_zxfont(self.right_bg,Lang.mounts.info_panel[8],width/2,70,2,17);

 end



-- 界面更新
function OtherMountsInfoNew:update( mounts_model )

	local is_show_other_mounts = MountsModel:is_show_other_mounts()

	-- 记录品阶
	self.jieji = mounts_model.jieji;

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
	self.hp_att:setString(LH_COLOR[15]..currentPj[1]);
	self.at_att:setString(LH_COLOR[15]..currentPj[2]);
	self.md_att:setString(LH_COLOR[15]..currentPj[3]);
	self.wd_att:setString(LH_COLOR[15]..currentPj[4]);
	self.bj_att:setString(LH_COLOR[15]..currentPj[5]);

	-- 更新洗练值
	local mounts_rate = MountsConfig:getRate();
	self.hp_exten:setString(LH_COLOR[4].."+"..mounts_model.zizhi_hp_exten);
	self.at_exten:setString(LH_COLOR[4].."+"..mounts_model.zizhi_attack_exten);
	self.md_exten:setString(LH_COLOR[4].."+"..mounts_model.zizhi_md_exten);
	self.wd_exten:setString(LH_COLOR[4].."+"..mounts_model.zizhi_wd_exten);
	self.bj_exten:setString(LH_COLOR[4].."+"..mounts_model.zizhi_bj_exten);

	-- 更新等级
	self.level:setString(string.format(LH_COLOR[11].."%d/70",mounts_model.level));

	--改变坐骑外观
	self:change_mounts_avatar(mounts_model.model_id);
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
			local lingxi_str = string.format(LH_COLOR[15].."+%d",mounts_model.lingxi).."%";
			self.lingxi_value:setString(lingxi_str);

			-- 如果灵犀满值了，就把提升按钮置灰
			if mounts_model.lingxi == 150 then
				self.lingxi_value:setString(Lang.mounts.lingxi_max); -- [2081]="+150%#c38ff33(满)"
				-- self.tishen_btn:setCurState(CLICK_STATE_DISABLE);
			end

		end
	else
		self.lingxi_panel:setIsVisible(false);
		self.hide_lingxi_tip1:setIsVisible(true);
		self.hide_lingxi_tip2:setIsVisible(true);
	end
end

function OtherMountsInfoNew:active(show, other_model)
	if show then
		if other_model ~= nil and  MountsModel:is_show_other_mounts()  then 
			self:update(other_model);
		end
	end
end


-- 修改坐骑形象
function OtherMountsInfoNew:change_mounts_avatar(model_id)

	-- 更新化形按钮状态
	-- 如果已经是当前坐骑了，不必刷新
	if self.current_mounts_avatar_id == model_id then
		return;
	end

	if self.mounts_avatar ~= nil then
		self.mounts_avatar:removeFromParentAndCleanup(true)
		self.mounts_avatar = nil
	end
 
 	local old_id = self.current_mounts_avatar_id
 	self.current_mounts_avatar_id = model_id;
	local mount_file = string.format("frame/mount/%d",model_id);
	-- local mount_file = string.format("frame/mount/%d",1);

	local action = {0,4,4,0.2};
	
	local avatar_pos_y = 280;

	self.mounts_avatar = MUtils:create_animation(190,avatar_pos_y,mount_file,action );
	self.left_bg:addChild(self.mounts_avatar,255)
	
	local mount_config =  MountsConfig:get_mount_data_by_id(model_id);
	self.mounts_name:setText(string.format("#cffff00%s",mount_config["name"]));

end



-- 更新坐骑战斗力
function OtherMountsInfoNew:change_mount_fight_value( fight_value )
	if self.mounts_fight ~= nil then
		self.mounts_fight:set_number(fight_value);
	end
end



-- 更新人物基础属性
function OtherMountsInfoNew:update_base_att( mounts_model )
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

	self.hp_exten_all:setText(string.format(LH_COLOR[15].."%d",hp_var));
	self.at_exten_all:setText(string.format(LH_COLOR[15].."%d",at_var));
	self.md_exten_all:setText(string.format(LH_COLOR[15].."%d",md_var));
	self.wd_exten_all:setText(string.format(LH_COLOR[15].."%d",wd_var));
	self.bj_exten_all:setText(string.format(LH_COLOR[15].."%d",bj_var));

	--速度加成要另外算
	local speed = mounts_config["moveSpeed"];
	local speed_ex =  math.abs(900*900/(900+speed)-900);
	self.seep_exten_all:setText(string.format(LH_COLOR[6].."+%d",speed_ex));
end


function OtherMountsInfoNew:destroy()

end
