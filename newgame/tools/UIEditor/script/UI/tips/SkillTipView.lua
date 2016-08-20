-- SkillTipView.lua 
-- createed by fangjiehua on 2013-1-22
-- SkillTipView 面板
 
super_class.SkillTipView(Window)

local c3_white  = "#cffffff";
local c3_green 	= "#c38ff33";
local c3_yellow = "#cfff000";
local c3_pink	= "#cff66cc";
local c3_blue	= "#c00c0ff";
local c3_gray	= "#ca7a7a6";
local c3_purple = "#cff66cc";
local c3_rad	= "#cff0000";
--释放技能条件
local function get_skill_cond_text(level,skill_config )
	
	local skillType = nil;
	if skill_config.skillType == 2 or skill_config.skillType == 4 then
		--2、4为群体
		skillType = LangGameString[2005]; -- [2005]="群体"
	else
		--其他的视为单体
		skillType = LangGameString[2006]; -- [2006]="单体"
	end
	--释放需要的mp,距离
	local skill_mp ,skill_distance;
	
	local current_level_config = skill_config.skillSubLevel[level];
	local spell_conds = current_level_config.spellConds;
	for i,v in ipairs(spell_conds) do
		print("技能施法条件",i,v.cond,v.value);
		if v.cond == SkillConfig.SC_MP then
			--消耗MP
			skill_mp = v.value;
		elseif v.cond == SkillConfig.SC_MAX_TARGET_DIST then
			--施法距离
			skill_distance = (v.value + 1) * 0.5;
		end
	end
	--冷却时间
	local cool_time = current_level_config.cooldownTime/1000;

	local skill_cond_text;
	--如果为被动技能，则没有施法范围
	if skill_config.skillType ~= 1 then
		
		skill_cond_text = c3_white..LangGameString[2007]..c3_yellow..skillType.."#r".. -- [2007]="技能范围: "
							c3_white..LangGameString[2008]..c3_yellow..skill_mp.."#r"; -- [2008]="法力消耗: "
		
		--有些技能是没有施法距离的，所以不需要加上施法距离
		if skill_distance ~= nil then
			skill_cond_text = skill_cond_text..c3_white..LangGameString[2009]..c3_yellow..skill_distance.."#r"; -- [2009]="施法距离: "
		end

		skill_cond_text = skill_cond_text..c3_white..LangGameString[2010]..c3_yellow..cool_time.."s"; -- [2010]="冷却时间: "
	end
	
	return skill_cond_text;
end

local function get_up_level_cond(skill_id )
	-- body
 
	local level = UserSkillModel:get_up_con_by_skill_id(skill_id,"level");
	local money = UserSkillModel:get_up_con_by_skill_id(skill_id,"money");
	local exp = UserSkillModel:get_up_con_by_skill_id(skill_id,"exp");
	 
	local player = EntityManager:get_player_avatar();
	local player_exp = player.expH *(2^32) + player.expL;
	
	--如果需要的条件比人物具备的条件高，则标为红色
	local c1 = c3_yellow;
	if level > player.level then
		c1 = c3_rad;
	end
	local c2 = c3_yellow;
	if money > player.yinliang then
		c2 = c3_rad;
	end
	local c3 = c3_yellow;
	if exp > player_exp then
		c3 = c3_rad;
	end

	local text = c3_white..LangGameString[2011]..c1..tostring(level).."#r".. -- [2011]="需要角色等级： "
					c3_white..LangGameString[2012]..c2..tostring(money).."#r".. -- [2012]="需要银两： "
					c3_white..LangGameString[2013]..c3..tostring(exp); -- [2013]="需要经验： "
	return text;

end

function SkillTipView:__init( window_name, texture_name, is_grid, width, height )

	--技能的静态数据
	local skill_config = SkillConfig:get_skill_by_id(self.model_data.id);

	--技能效果
	local _level;
	if self.model_data.level == 0 then
		_level = 1;
	else
		_level = self.model_data.level;
	end
	local current_level_config = skill_config.skillSubLevel[_level];

	-- print('>>>>',skill_config.name)
	local desc = current_level_config.desc or ''
	local skill_desc_text = c3_white..desc;
	local skill_desc = CCDialogEx:dialogWithFile(18, 264-170, 250, 100, 10, "", TYPE_VERTICAL ,ADD_LIST_DIR_UP);
	skill_desc:setAnchorPoint(0,1);
	skill_desc:setFontSize(16);
	skill_desc:setText(skill_desc_text);
	local skill_desc_size = skill_desc:getInfoSize();
	
	--下级技能效果
	local next_skill_desc;
	local next_skill_desc_size;

	--等级不为0或者不为最高级，才能显示下一级技能效果
	if self.model_data.level ~= 0 and self.model_data.level ~= #skill_config.skillSubLevel then
		
		local next_level_config = skill_config.skillSubLevel[self.model_data.level+1];
		local skill_desc_text = c3_white..next_level_config.desc;
		next_skill_desc = CCDialogEx:dialogWithFile(18, 264-170-101, 250, 100, 10, "", TYPE_VERTICAL ,ADD_LIST_DIR_UP);
		next_skill_desc:setAnchorPoint(0,1);
		next_skill_desc:setFontSize(16);
		next_skill_desc:setText(skill_desc_text);
		next_skill_desc_size = next_skill_desc:getInfoSize();
	else
		next_skill_desc_size = CCSizeMake(0,0);
	end
	
	--释放技能条件
	local skill_cond;
	local skill_cond_size;
	local skill_cond_height;
	if skill_config.skillType ~= 1 then
		local skill_cond_text = get_skill_cond_text(_level,skill_config);
		skill_cond = CCDialogEx:dialogWithFile(23, 0,250, 100, 10, "", TYPE_VERTICAL ,ADD_LIST_DIR_UP);
		skill_cond:setAnchorPoint(0,1);
		skill_cond:setFontSize(16);
		skill_cond:setText(skill_cond_text);
		skill_cond_height = skill_cond:getInfoSize().height+10;
	else
		skill_cond_height = 0;
	end
	
	--175

	local contentHeight;
	--等级不为0或者不为最高级，才能显示下一级技能效果
	if self.model_data.level ~= 0 and self.model_data.level ~= #skill_config.skillSubLevel then
		contentHeight = 250+skill_desc_size.height+next_skill_desc_size.height+skill_cond_height;
	else
		contentHeight = 190+skill_desc_size.height;
	end

	--根据动态高度重新设置contentSize
	self.view:setSize(210,contentHeight);
	self.view:setPosition(0,264-contentHeight+25);

	--技能icon
	local icon = SkillConfig:get_skill_icon(self.model_data.id);
	local icon = CCZXImage:imageWithFile(30,contentHeight-10+5,65,65,icon);
	icon:setAnchorPoint(0,1);
	self.view:addChild(icon);

	-- local icon_fg = SkillConfig:get_skill_icon(self.model_data.id);
	-- local icon_fg = CCZXImage:imageWithFile(65/2,65/2,68,67,UIResourcePath.FileLocate.main .. "m_skill_bg.png");
	-- icon_fg:setAnchorPoint(0.5,0.5);
	-- icon:addChild(icon_fg);

	
	--技能名字，
	local skill_name_text =  c3_yellow..skill_config.name.."  ";
	if self.model_data.level == 0 then
		skill_name_text = skill_name_text..c3_purple..LangGameString[2014]; -- [2014]="未学习"
	else
		skill_name_text = skill_name_text..c3_purple.."Lv"..tostring(self.model_data.level);
	end
	local skill_name = CCDialogEx:dialogWithFile(110, contentHeight-65/2+2,150, 20, 10, "", TYPE_VERTICAL ,ADD_LIST_DIR_UP);
	skill_name:setAnchorPoint(0,1);
	skill_name:setFontSize(16);
	skill_name:setText(skill_name_text);
	self.view:addChild(skill_name);


	--释放技能条件,type为1,被动技能没有释放条件
	if skill_config.skillType ~= 1 then
		skill_cond:setPosition(23, contentHeight+30-97-15);
		self.view:addChild(skill_cond);
		---------------------------昏割线
		local split_img = CCZXImage:imageWithFile(4,contentHeight-83-skill_cond_height,280,2,UIResourcePath.FileLocate.common .. "fenge_bg.png");
		self.view:addChild(split_img);
	end

	--技能效果
	local skill_effect_lab = CCZXLabel:labelWithText(23,contentHeight-110-skill_cond_height,c3_yellow..LangGameString[2015],16,ALIGN_LEFT); -- [2015]="技能效果:"
	self.view:addChild(skill_effect_lab);

	--技能描述
	skill_desc:setPosition(23,contentHeight-skill_cond_height-104-15)
	self.view:addChild(skill_desc);

	--如果技能未学习时，等级为0或为最高级，不显示下一级效果
	if self.model_data.level ~= 0 and self.model_data.level ~= #skill_config.skillSubLevel then

		---------------------------昏割线
		local split_img = CCZXImage:imageWithFile(4,contentHeight-200-skill_desc_size.height-skill_cond_height+72,280,2,UIResourcePath.FileLocate.common .. "fenge_bg.png");
		self.view:addChild(split_img);

		--下级技能效果
		local next_skill_effect_lab = CCZXLabel:labelWithText(23,contentHeight-224-skill_desc_size.height-skill_cond_height+72,c3_yellow..LangGameString[2016],16,ALIGN_LEFT); -- [2016]="下一级效果:"
		self.view:addChild(next_skill_effect_lab);
	
		--一下级技能效果
		next_skill_desc:setPosition(23,contentHeight-104-109-skill_desc_size.height-skill_cond_height+72-15);
		self.view:addChild(next_skill_desc);

		---------------------------昏割线
		local split_img = CCZXImage:imageWithFile(4,contentHeight-236-skill_desc_size.height-next_skill_desc_size.height-skill_cond_height+72,280,2,UIResourcePath.FileLocate.common .. "fenge_bg.png");
		self.view:addChild(split_img);

		--升级需求
		local up_level_lab = CCZXLabel:labelWithText(23,contentHeight-261-skill_desc_size.height-next_skill_desc_size.height-skill_cond_height+72,c3_yellow..LangGameString[2017],16,ALIGN_LEFT); -- [2017]="升级需求:"
		self.view:addChild(up_level_lab);

		local need_text = get_up_level_cond(self.model_data.id);
		local up_level_need = CCDialogEx:dialogWithFile(23, contentHeight-110-140-18-skill_desc_size.height-next_skill_desc_size.height-skill_cond_height+72,200, 100, 10, "", TYPE_VERTICAL ,ADD_LIST_DIR_UP);
		up_level_need:setAnchorPoint(0,1);
		up_level_need:setFontSize(14);
		up_level_need:setText(need_text);
		self.view:addChild(up_level_need);

	end

end





function SkillTipView:create( model_data )
	
	self.model_data = model_data;
	--local temp_info = { texture = "", x = 0, y = 25, width = 210, height = 264 }
	--TipsWin('TipsWin', '', true, _screenWidth, _screenHeight)
	return SkillTipView("SkillTipView",'',true,315,354);

end
