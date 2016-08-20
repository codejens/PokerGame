-- PetTipView.lua 
-- createed by fangjiehua on 2013-1-23
-- PetTipView 面板
 
super_class.PetTipView(TipsGridView)

local c3_white  = "#cffffff";
local c3_green 	= "#c38ff33";
local c3_yellow = "#cfff000";
local c3_pink	= "#cff66cc";
local c3_blue	= "#c00c0ff";
local c3_gray	= "#ca7a7a6";
local c3_purple = "#cff66cc";

local FONT_SIZE = UI_TOOLTIPS_FONT_SIZE
local TIP_WIDTH = UI_TOOLTIPS_ITEM_DIALOG_WIDTH
local TIP_HEIGHT_MIN = 64

local function get_pet_cond_text( config )
	
	--需要等级
	local conds = config.conds;
	local need_level = 1;
	if #conds ~= 0 then
		local cond = conds[1];
		if cond.cond == 1 then
			--需要的等级
			need_level = cond.value;
		end
	end
	local text = c3_white..LangGameString[1961]..c3_yellow..tostring(need_level).."    "..c3_blue..LangGameString[2004]; -- [1961]="需要等级： " -- [2004]="双击使用"

	return text;
end

function PetTipView:__init( width, height, border, gapX, gapY )
	
	--宠物蛋的静态数据
	local item_config = ItemConfig:get_item_by_id(self.model_data.item_id);
	local file_name = "scene/monster/"..item_config.suitId;

	--宠物描述
	local desc_text = c3_white..item_config.desc;
	local splitter_tex = UILH_COMMON.split_line
	local cond_text = get_pet_cond_text(item_config);
	local icon_tex = PetConfig:get_pet_head_by_id(item_config.suitId)
	--是否绑定
	local bandText = "";
	if self.model_data.flag == 1 or true then
		bandText = LangGameString[1960]; -- [1960]="已绑定"
	end
	local pet_name_color = "#c"..ItemConfig:get_item_color(item_config.color+1);
	local pet_name = pet_name_color..item_config.name

	self:addDialog(desc_text,FONT_SIZE)
	self:addStaticLine(splitter_tex,3)
	self:addSpacer(0,8)
	self:addAnimation(file_name,UI_TOOLTIPS_PET_ANIM_WIDTH,
								UI_TOOLTIPS_PET_ANIM_HEIGHT,
								UI_TOOLTIPS_PET_ACTIONS)
	self:addStaticLine(splitter_tex,3)
	self:addDialog(cond_text,FONT_SIZE)
	-- self:addSlot(72,icon_tex,true)
	self:addSpacer(8,0)
	self:addSlotItem(self.model_data.item_id, true)
	self:addSpacer(3,0)
	self:addText(pet_name,FONT_SIZE,ALIGN_LEFT,true)
	self:addSpacer(UI_TOOLTIPS_SPACER,0)
	self:addText(bandText,FONT_SIZE,ALIGN_LEFT,true)
	self:autofitRow()
	self:finish()
end


function PetTipView:get_pet_animate_sprite(x,y, pet_id )
	
	local animation = ZXAnimation:createWithFileName("scene/monster/2")
    --local defAction = ZXAnimation:createAnimationAction(0,0,9,0.2)
    animation:replaceZXAnimationAction(0,0,9,0.2)
    animation:setDefaultAction(0)

	local pet_sprite = ZXAnimateSprite:createWithFileAndAnimation("",animation)
	local pet_sp_node = CCNode:node();
	pet_sp_node:addChild(pet_sprite);
	pet_sp_node:setPosition(x,y);
  	return pet_sp_node;

end

function PetTipView:create( model_data )
	
	self.model_data = model_data;
	--local temp_info = { texture = "", x = 0, y = 0, width = 280, height = 239 }
	return PetTipView(TIP_WIDTH,TIP_HEIGHT_MIN);

end
