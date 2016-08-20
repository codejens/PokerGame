-- PetSkillTipView.lua 
-- createed by fangjiehua on 2013-1-23
-- PetSkillTipView 面板
 
super_class.PetSkillTipView(Window)

local c3_white  = "#cffffff";
local c3_green 	= "#c38ff33";
local c3_yellow = "#cfff000";
local c3_pink	= "#cff66cc";
local c3_blue	= "#c00c0ff";
local c3_gray	= "#ca7a7a6";
local c3_purple = "#cff66cc";
local c3_red	= "#cff0000";

function PetSkillTipView:__init( )
	--宠物技能的静态数据
	local skill_config = PetConfig:get_pet_skill_strs(self.model_data)

	--技能描述
	local skill_desc_text = c3_white..skill_config.skill_desc;
	local skill_desc = CCDialogEx:dialogWithFile(16, 248 ,UI_TOOLTIPS_RECT_WIDTH-30, 120, 10, "", TYPE_VERTICAL ,ADD_LIST_DIR_UP);
	skill_desc:setFontSize(16);
	skill_desc:setText(skill_desc_text);

	--动态高度
	local skill_height = skill_desc:getInfoSize().height;
	local contentHeight = 190+skill_height;
	self.view:setSize(UI_TOOLTIPS_RECT_WIDTH,contentHeight);
	-- self.view:setPosition(0,239-contentHeight-22);

	--技能icon
	local icon_bg = CCZXImage:imageWithFile(13,contentHeight-12,81,81,UILH_NORMAL.item_bg2);
	icon_bg:setAnchorPoint(0,1);
	self.view:addChild(icon_bg);
	 
	local icon = CCZXImage:imageWithFile(81/2,81/2,64,64,skill_config.icon_path);
	icon:setAnchorPoint(0.5,0.5);
	icon_bg:addChild(icon);

	--技能名字
	local pet_skill_name = CCZXLabel:labelWithText(96,contentHeight-60,c3_yellow..skill_config.skill_name,16,ALIGN_LEFT);
	self.view:addChild(pet_skill_name);

	--技能
	local keyin = LangGameString[2000]; -- [2000]="未刻印"
	if self.model_data.skill_keyin == 1 then
		keyin =  LangGameString[2001]; -- [2001]="刻印"
	end

	local skill_text = c3_white..skill_config.skill_type.."   "..c3_red..keyin.."#r"..
						c3_white..LangGameString[2002]..c3_yellow..skill_config.skill_range.."#r".. -- [2002]="施法距离：  "
						c3_white..LangGameString[2003]..c3_yellow..skill_config.skill_cd..c3_white..LangGameString[875]; -- [2003]="冷却时间：  " -- [875]="秒"
	local pet_skill = CCDialogEx:dialogWithFile(22, contentHeight-68-25,UI_TOOLTIPS_RECT_WIDTH-30, 60, 3, "", TYPE_VERTICAL ,ADD_LIST_DIR_UP);
	pet_skill:setAnchorPoint(0,1);
	pet_skill:setFontSize(16);
	pet_skill:setText(skill_text);
	self.view:addChild(pet_skill);
	
	--分割线
	local split_img = CCZXImage:imageWithFile(10,contentHeight-130-30,UI_TOOLTIPS_RECT_WIDTH-20,3,UILH_COMMON.split_line);
	self.view:addChild(split_img);
	
	
	--技能描述
	skill_desc:setPosition(22,contentHeight-242-15-28);
	self.view:addChild(skill_desc);

end	

function PetSkillTipView:create( model_data )
	
	self.model_data = model_data;
	local temp_info = { texture = "", x = 0, y = 5, width = 280, height = 239 }
	return PetSkillTipView("PetSkillTip", "", true, UI_TOOLTIPS_RECT_WIDTH, 239);

end
