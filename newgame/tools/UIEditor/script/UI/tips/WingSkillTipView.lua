-- WingSkillTipView.lua 
-- createed by fangjiehua on 2013-1-29
-- WingSkillTipView 面板
 
super_class.WingSkillTipView(Window)

local c3_white  = "#cffffff";
local c3_green 	= "#c38ff33";
local c3_yellow = "#cfff000";
local c3_pink	= "#cff66cc";
local c3_blue	= "#c00c0ff";
local c3_gray	= "#ca7a7a6";
local c3_purple = "#cff66cc";
local c3_red	= "#cff0000";


local function get_skill_desc_text( isNext, skill_id,level,model_data )
	
	local text = "";
	local skill_level = level;
	if skill_level > 0 then
		if isNext == true then
			text =  c3_white..LangGameString[2027]; -- [2027]="下一等级:  "
			if skill_level < 10 then 
				-- 如果等级不满10级，则显示下一级
				skill_level = skill_level + 1;
			end
		elseif isNext == false then
			text =  c3_white..LangGameString[2028]; -- [2028]="技能等级:  "
		end
		
		text = text..c3_yellow..tostring(skill_level).."#r"..c3_white..LangGameString[2029].."#r"; -- [2029]="技能效果:  "
		
		local skill_config = (WingConfig:get_wing_skills())[skill_id];
		
		-- if skill_id == 1 or skill_id == 6 or skill_id == 7 then
		-- 	local add_rate = tostring((skill_config.addRate[skill_level])*100).."%";
		-- 	text = text..c3_white..skill_config.des..add_rate;
		-- 	if skill_config.des1 then
		-- 		text = text..skill_config.des1;
		-- 	end
		-- elseif skill_id == 3 then
		-- 	local add_rate = tostring(skill_config.addRate[skill_level]).."%";
		-- 	text = text..c3_white..skill_config.des..add_rate;
		-- 	if skill_config.des1 then
		-- 		text = text..skill_config.des1;
		-- 	end
		-- else
		-- 	print("skill_id=",skill_id)
		-- 	print("skill_level=",skill_level)
		-- 	print("skill_config.addRate[skill_level]=",skill_config.addRate[skill_level])
		-- 	local add_rate = tostring((skill_config.addRate[skill_level])/100).."%";

		-- 	text = text..c3_white..skill_config.des..add_rate;
		-- 	if skill_config.des1 then
		-- 		text = text..skill_config.des1;
		-- 	end
		-- end

		local cur, nex = WingSkillPage:getSkillDesc(skill_id, skill_level)
		if isNext then
			text = text .. nex
		else
			text = text .. cur
		end

	else
		text = c3_yellow..LangGameString[406]..tostring(skill_id+1)..LangGameString[2030]; -- [406]="翅膀" -- [2030]="阶开启"
	end
	return text;

end

function WingSkillTipView:__init(  )
	-- local skill_id;
	-- if self.model_data.name == LangGameString[2031] then -- [2031]="太虚真元"
	-- 	skill_id = 1;
	-- elseif self.model_data.name == LangGameString[2032] then -- [2032]="鉴月无缺"
	-- 	skill_id = 2;
	-- elseif self.model_data.name == LangGameString[2033] then -- [2033]="禁神领域"
	-- 	skill_id = 3;
	-- elseif self.model_data.name == LangGameString[2034] then -- [2034]="炼血补天"
	-- 	skill_id = 4;
	-- elseif self.model_data.name == LangGameString[2035] then -- [2035]="弑天之力"
	-- 	skill_id = 5;
	-- elseif self.model_data.name == "御灵镜幻" then 
	-- 	skill_id = 6;
	-- elseif self.model_data.name == "真武玄盾" then 
	-- 	skill_id = 7;
	-- end
	local skill_id = self.model_data.skillId

	--技能描述
	local desc_text = get_skill_desc_text(false,skill_id,self.model_data.level,self.model_data);
	local skill_desc = CCDialogEx:dialogWithFile(10, 239-85,UI_TOOLTIPS_RECT_WIDTH - 30, 100, 10, "", 1 ,ADD_LIST_DIR_UP);
	skill_desc:setFontSize(16);
	skill_desc:setText(desc_text);

	--动态高度
	local skill_desc_height = skill_desc:getInfoSize().height;

	--下级技能描述
	local next_desc_height;
	local next_skill_desc;
	if self.model_data.level < 10 and self.model_data.level ~= 0 then
		local desc_text = get_skill_desc_text(true,skill_id,self.model_data.level,self.model_data);
		next_skill_desc = CCDialogEx:dialogWithFile(10, 239-skill_desc_height-81,UI_TOOLTIPS_RECT_WIDTH - 30, 100, 10, "", 1 ,ADD_LIST_DIR_UP);
		next_skill_desc:setFontSize(16);
		next_skill_desc:setText(desc_text);
		--动态高度
		next_desc_height = next_skill_desc:getInfoSize().height;
	else
	 	next_desc_height = 0;
	end

	--根据动态高度重新设置contentSize
	local contentHeight = 120+skill_desc_height+next_desc_height;
	self.view:setSize(UI_TOOLTIPS_RECT_WIDTH,contentHeight);
	
	--技能icon
	local icon_bg = CCZXImage:imageWithFile(15,contentHeight-10,81,81,UILH_NORMAL.item_bg2);
	icon_bg:setAnchorPoint(0,1);
	self.view:addChild(icon_bg);
	 
	local icon = CCZXImage:imageWithFile(81/2,81/2,64,64,WingConfig:get_wing_skill_icon_by_id(skill_id));
	icon:setAnchorPoint(0.5,0.5);
	icon_bg:addChild(icon);

	--技能名字
	local pet_name = CCZXLabel:labelWithText(105,contentHeight-52,self.model_data.name,16,ALIGN_LEFT);
	self.view:addChild(pet_name);

	
	--技能描述
	skill_desc:setPosition(18,contentHeight-145-15-15-15);
	self.view:addChild(skill_desc);
	

	if self.model_data.level < 10 and self.model_data.level ~= 0 then 
		---------------------------昏割线
		local split_img = CCZXImage:imageWithFile(10,contentHeight-skill_desc_height-71-15-15,UI_TOOLTIPS_RECT_WIDTH - 30,3,UILH_COMMON.split_line);
		self.view:addChild(split_img);
		
		--下级技能描述
		next_skill_desc:setPosition(18,contentHeight-skill_desc_height-164-15-15-10);
		self.view:addChild(next_skill_desc);
	end

end

function WingSkillTipView:create( model_data )
	self.model_data = model_data;
	local texture_info = { texture = "", x = 0, y = 25, width = 280, height = 270 }
	return WingSkillTipView("WingSkillTipView", "", true, UI_TOOLTIPS_RECT_WIDTH, 270);

end
