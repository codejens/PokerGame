-- WingTipView.lua 
-- createed by fangjiehua on 2013-1-25
-- WingTipView 面板
 
super_class.WingTipView(Window)

local c3_white	= "#cffffff"
local c3_green 	= "#c38ff33";
local c3_yellow = "#cfff000";
local c3_pink	= "#cff66cc";
local c3_blue	= "#c00c0ff";
local c3_gray	= "#ca7a7a6";

local wing_level = 1;
local wing_jieji = 1;
local wing_star = 0;
local skills_level = {};

--通过位操作，抽取翅膀的动态数据
local function get_wing_data_by_utils( model_data )
		
	if model_data.is_hyperlink then
		wing_level = model_data.level;
		wing_jieji = model_data.stage;
		wing_star = model_data.star;
		skills_level[1] = model_data.skill1_level;
		skills_level[2] = model_data.skill2_level;
		skills_level[3] = model_data.skill3_level;
		skills_level[4] = model_data.skill4_level;
		skills_level[5] = model_data.skill5_level;
		skills_level[6] = model_data.skill6_level;
		skills_level[7] = model_data.skill7_level;
		skills_level[8] = model_data.skill8_level
		skills_level[9] = model_data.skill9_level
	else
		print("model_data",model_data.duration_max,model_data.holes[1],model_data.holes[2],model_data.holes[3])
		wing_level = ZXLuaUtils:high8Word(model_data.duration);	--翅膀等级
		wing_jieji = ZXLuaUtils:low8Word(model_data.duration);	--翅膀阶级
		wing_star = ZXLuaUtils:high8Word(model_data.duration_max);	--翅膀星级
		skills_level[1] = ZXLuaUtils:low8Word(model_data.duration_max);	--翅膀技能1
		skills_level[2] = ZXLuaUtils:high8Word(model_data.holes[1]);	--翅膀技能2
		skills_level[3] = ZXLuaUtils:low8Word(model_data.holes[1]);		--翅膀技能3
		skills_level[4] = ZXLuaUtils:high8Word(model_data.holes[2]);	--翅膀技能4
		skills_level[5] = ZXLuaUtils:low8Word(model_data.holes[2]);		--翅膀技能5
		skills_level[6] = model_data.smith_num;							--翅膀技能6
		skills_level[7] = model_data.smiths[3].type;					--翅膀技能7
		skills_level[8] = model_data.smiths[1].type
		skills_level[9] = model_data.smiths[2].type
	end

end

--拼接翅膀的基础信息
local function get_wing_info_text( model_data )

	local info_text = c3_white..LangGameString[2036]..c3_yellow..LangGameString[2037].. -- [2036]="类    型: " -- [2037]="翅膀#r"
						c3_white..LangGameString[2038]..c3_yellow..tostring(wing_level).."#r".. -- [2038]="等    级: "
						c3_white..LangGameString[2039]..c3_yellow..tostring(wing_jieji)..LangGameString[2040]..tostring(wing_star)..LangGameString[2041]; -- [2039]="品    阶: " -- [2040]="阶" -- [2041]="星"
	return info_text;

end

--拼接翅膀的属性信息
local function get_wing_attris_text( item_config )
 
	local attris = WingConfig:get_wing_attris_by_level(wing_level)
	local add_rate = WingConfig:get_addRate_by_jieji_star(wing_jieji,wing_star);
	

	local attris_text = c3_white..LangGameString[2042]..tostring(attris[1])..c3_yellow.."  +"..Utils:getIntPart(attris[1]*(add_rate/100)).."#r".. -- [2042]="攻    击: "
						c3_white..LangGameString[2043]..tostring(attris[2])..c3_yellow.."  +"..Utils:getIntPart(attris[2]*(add_rate/100)).."#r".. -- [2043]="物理防御: "
						c3_white..LangGameString[2044]..tostring(attris[3])..c3_yellow.."  +"..Utils:getIntPart(attris[3]*(add_rate/100)).."#r".. -- [2044]="法术防御: "
						c3_white..LangGameString[2045]..tostring(attris[4])..c3_yellow.."  +"..Utils:getIntPart(attris[4]*(add_rate/100)); -- [2045]="生    命: "
	return attris_text;

end

--拼接翅膀的技能信息
local function get_wing_skill_text( )
 
	local skills = WingConfig:get_wing_skills();
	local text = "";
	for i=1,7 do
		local name = skills[i].name;
		local level = skills_level[i];
		if level ~= 0 then
			text = text..c3_white..name..c3_yellow..LangGameString[2046]..tostring(level).."#r"; -- [2046]="   等级"
		else
			text = text..c3_gray..name..LangGameString[2047]..tostring(i+1)..LangGameString[2048]; -- [2047]="   翅膀" -- [2048]="阶开启#r"
		end
	end

	return text;
end

--计算翅膀的战斗力
local function get_wing_fight_value( )
	 
	local attris = WingConfig:get_wing_attris_by_level(wing_level)
	local add_rate = WingConfig:get_addRate_by_jieji_star(wing_jieji,wing_star);
	local fight_value = 0;
	
	--叠加上基础属性和附加属性
	local k 	= (1+add_rate/100);
	local attck = 	(attris[1]*k);
	local wl_def = 	attris[2]*k;
	local fs_def = 	attris[3]*k;
	local hp =		attris[4]*k;
	
	 
	fight_value = attck*EquipValueConfig:get_calculate_factor(21)+
					wl_def*EquipValueConfig:get_calculate_factor(23)+
					fs_def*EquipValueConfig:get_calculate_factor(33)+
					hp*EquipValueConfig:get_calculate_factor(17);	--生命值乘以一个零点几的比率值

	-- print("计算翅膀战斗力",attck, EquipValueConfig:get_calculate_factor(21),wl_def, EquipValueConfig:get_calculate_factor(23),fs_def, EquipValueConfig:get_calculate_factor(33),hp, EquipValueConfig:get_calculate_factor(17) ,fight_value);

	--叠加技能增幅
	local has_skills = WingConfig:getOpenSkillByStage(wing_jieji) -- WingConfig:get_wing_skill_by_jieji(wing_jieji);
	for i,skillId in ipairs(has_skills) do
		
		if skills_level[skillId] and skills_level[skillId] ~= 0 then
			local skill = WingConfig:get_index_wing_skills(skillId)
			local skillType = skill.type
			local addRate = skill.addRate[skills_level[skillId]]
			local add_fight = 0
			if skillType == 0 then
				if skillId == 3 then
					add_fight = add_fight + EquipValueConfig:get_calculate_factor(24) * addRate
					add_fight = add_fight + EquipValueConfig:get_calculate_factor(34) * addRate
				elseif skillId == 8 then
					print('----------skills_level[skillId]: ', skills_level[skillId])
					add_fight = add_fight + WingConfig:get8thSkillAddFightPower(skills_level[skillId])
				elseif skillId == 9 then
					add_fight = add_fight + WingConfig:get9thSkillAddFightPower(skills_level[skillId])
				end
			else
				add_fight = EquipValueConfig:get_calculate_factor(skillType) * addRate
			end
			
			fight_value = fight_value + add_fight;
			-- print("翅膀技能增幅,",i,skill,EquipValueConfig:get_calculate_factor(skill.type), skill.addRate[skills_level[i]], add_fight);
		end
	end
	-- print("翅膀最终战斗力",fight_value);

	return math.floor(fight_value);
	
end

function WingTipView:__init(  )
	
	--翅膀的静态数据 
	local item_config = ItemConfig:get_item_by_id(self.model_data.item_id);
	
	--翅膀的动态数据
	get_wing_data_by_utils(self.model_data);

	--------------icon图标
	local icon_bg = CCZXImage:imageWithFile(15,549,81,81,UILH_NORMAL.item_bg2);
	icon_bg:setAnchorPoint(0,1);
	self.view:addChild(icon_bg);
	
	local icon = CCZXImage:imageWithFile(81/2,81/2,64,64,ItemConfig:get_item_icon(self.model_data.item_id));--self.model_data.item_id));
	icon:setAnchorPoint(0.5,0.5);
	icon_bg:addChild(icon);

	--------------是否绑定
	local isbangding = LangGameString[1960]; -- [1960]="已绑定"
	-- if self.model_data.flag==1 then
	-- 	isbangding = "已绑定";
	-- end
	isbangding = c3_yellow..isbangding;
	local bangding = CCZXLabel:labelWithTextS(CCPointMake(280-30,506),isbangding,16,ALIGN_RIGHT);
	self.view:addChild(bangding);

	--翅膀名字
	local wing_name = CCZXLabel:labelWithText(96,506,c3_pink..item_config.name,16,ALIGN_LEFT);
	self.view:addChild(wing_name);

	--翅膀的基础信息
	local info_text = get_wing_info_text(self.model_data);
	local wing_info = CCDialogEx:dialogWithFile(20, 470, 220, 100, 10, "", TYPE_VERTICAL ,ADD_LIST_DIR_UP);
	wing_info:setAnchorPoint(0,1);
	wing_info:setFontSize(16);
	wing_info:setText(info_text);
	self.view:addChild(wing_info);

	--翅膀的战斗力
	
	local fight_bg = CCZXImage:imageWithFile(210/2,402,200,31,nil,5,15);
	fight_bg:setAnchorPoint(0.5,1);
	self.view:addChild(fight_bg);
	
	--战斗力文字图片
	local fight_icon = CCZXImage:imageWithFile(53,31/2,77,22,UILH_ROLE.text_zhandouli);
	fight_icon:setAnchorPoint(0.5,0.5);
	fight_bg:addChild(fight_icon);

	--战斗力数字
	local fight_value = get_wing_fight_value();
	local fight_lab = ZXLabelAtlas:createWithString(tostring(fight_value),"ui/fonteffect/r");
	fight_lab:setPosition(CCPointMake(108+44,14));
	fight_lab:setAnchorPoint(CCPointMake(0.5,0.5))
	-- fight_lab:setScale(0.8);
	fight_bg:addChild(fight_lab);

	---------------------------昏割线
	local split_img = CCZXImage:imageWithFile(10,365,260,3,UILH_COMMON.split_line);
	self.view:addChild(split_img);

	--翅膀的属性
	local attris_text = get_wing_attris_text(item_config);
	local wing_attri = CCDialogEx:dialogWithFile(20, 360,250, 100, 10, "", TYPE_VERTICAL ,ADD_LIST_DIR_UP);
	wing_attri:setAnchorPoint(0,1);
	wing_attri:setFontSize(16);
	wing_attri:setText(attris_text);
	self.view:addChild(wing_attri);

	---------------------------昏割线
	local split_img = CCZXImage:imageWithFile(10,253,260,3,UILH_COMMON.split_line);
	self.view:addChild(split_img);

	--翅膀技能
	local wing_skill_lab = CCZXLabel:labelWithText(20,227,c3_yellow..LangGameString[2049],16,ALIGN_LEFT); -- [2049]="翅膀技能:"
	self.view:addChild(wing_skill_lab);

	local skill_text = get_wing_skill_text();
	local wing_skill = CCDialogEx:dialogWithFile(20, 225,250, 100, 10, "", TYPE_VERTICAL ,ADD_LIST_DIR_UP);
	wing_skill:setAnchorPoint(0,1);
	wing_skill:setFontSize(16);
	wing_skill:setText(skill_text);
	self.view:addChild(wing_skill);

	---------------------------昏割线
	local split_img = CCZXImage:imageWithFile(10,64,260,3,UILH_COMMON.split_line);
	self.view:addChild(split_img);

	--翅膀描述
	local desc_text = c3_white..item_config.desc;
	local wing_desc = CCDialogEx:dialogWithFile(20, 60,235, 100, 10, "", TYPE_VERTICAL ,ADD_LIST_DIR_UP);
	wing_desc:setAnchorPoint(0,1);
	wing_desc:setFontSize(16);
	wing_desc:setText(desc_text);
	self.view:addChild(wing_desc);

end

function WingTipView:create( model_data )
	
	self.model_data = model_data;
	local temp_info = { texture = "", x = 0, y = 0, width = 280, height = 560 }
	local wingView = WingTipView("WingTipView", "", true, 326, 560)
	return wingView;

end
