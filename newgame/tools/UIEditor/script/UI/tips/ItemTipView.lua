-- ItemTipView.lua 
-- createed by fangjiehua on 2013-1-12
-- ItemTipView 面板
 
super_class.ItemTipView(TipsGridView)

local c3_white  = "#cffffff";
local c3_green 	= "#c38ff33";
local c3_yellow = "#cfff000";
local c3_pink	= "#cff66cc";
local c3_blue	= "#c00c0ff";
local c3_white_yellw = "#cfefed0";

local ATTRI_MEDICAMENTS = { 18320,18321,18322,18323,18324, 
							18330,18331,18332,18333,18334,
							18340,18341,18342,18343,18344,
							18350,18351,18352,18353,18354, };
local FONT_SIZE = UI_TOOLTIPS_FONT_SIZE

local TIP_WIDTH = UI_TOOLTIPS_ITEM_DIALOG_WIDTH
local TIP_HEIGHT_MIN = 64
function ItemTipView:__init( width, height, border, gapX, gapY )
	--item的静态数据
	local item_data = ItemConfig:get_item_by_id(self.model_data.item_id);--18402 18621 28213 19002 18301

	------------------------先排版buff或功能描述，计算出动态高度
	--是否绑定
	self.isbangding = false;
	if self.model_data.flag==1 then
		self.isbangding = true;
	end
	
	--静态数据
	--使用item需要的等级

	local text="";

	--如果是宠物技能书，要在等级之前加
	 
	if ItemConfig.ITEM_TYPE_PET_SKILL == item_data.type then
		text = c3_white..LangGameString[1975]; -- [1975]="类型:宠物技能书#r"
	end

    --美人后宫  卡牌   added by xiehande
	if 20 == item_data.type then
		local card = HeLuoConfig.getCardByItemID( item_data.id)
            if not card then
                return
            end
            local data = HeluoBooksModel:get_tips_attr_data( card.attrs[1])
            for i,texts in ipairs(data.contents) do
		        text = text .. texts[1] .. texts[2] .. "#r"
    		end
	end


	local cond = (item_data.conds)[1];
	if cond ~= nil then
		text = text..c3_white..LangGameString[1976]..c3_yellow..string.format("%d",cond.value).."      "; -- [1976]="需要等级:"
	end
	--是否显示双击使用标签，只有药品和功能道具才显示
	if ItemConfig.ITEM_TYPE_MEDICAMENTS == item_data["type"] or
		ItemConfig.ITEM_TYPE_PET_MEDICAMENTS == item_data["type"] or 
		ItemConfig.ITEM_TYPE_FAST_MEDICAMENT == item_data["type"] or 
		ItemConfig.ITEM_TYPE_FUNCTION_ITEM == item_data["type"] then

		text = text..c3_blue..LangGameString[1977]; -- [1977]="双击使用#r"
	end

	--是否是普通药品或者宠物普通药品
	print("self.model_data.item_id,item_data.type",self.model_data.item_id,item_data.type)
	if ItemConfig.ITEM_TYPE_FUNCTION_ITEM == item_data.type or ItemConfig.ITEM_TYPE_MEDICAMENTS == item_data.type or ItemConfig.ITEM_TYPE_PET_MEDICAMENTS == item_data.type then
		--判断是否有静态属性
		if #item_data["staitcAttrs"] ~= 0 then
			local drug_type,value,time,allValue = self:get_general_drug_effect(item_data);
			local type_name = staticAttriTypeList[drug_type];
			print("-------(drug_type,value,time,allValue,type_name)",drug_type,value,time,allValue,type_name)
			-- 在普通药品中有一批特殊的药品， 属性加成药剂，如：一级生命药剂，一级物防药剂等等。这些药品的效果描述格式需特殊处理
			if self:IS_ATTRI_MEDICAMENTS(self.model_data.item_id) then
				text = text..self:create_attri_drug_effect_text(self.isbangding,time,value,allValue,type_name);
			elseif self:IS_ATTRI_MEDICAMENTS( self.model_data.item_id ) then

			else
				text = text..(self:create_drug_effect_text(self.isbangding,time,value,allValue,type_name));
			end
			
		end
	--是否是装备升级材料
	elseif ItemConfig.ITEM_TYPE_EQUIP_UPGRADE == item_data.type then
		if self.isbangding == false then
			text = "";
		end
		text = text..c3_white..LangGameString[1978]; -- [1978]="类型:装备升级材料"

	--是否是宝石类
	elseif ItemConfig.ITEM_TYPE_GEM == item_data.type then
		-- local hole_staticAttris = ItemConfig:get_staitc_attrs_by_id(self.model_data.item_id);
		-- local attri = hole_staticAttris[1];
		 
		-- local _type = staticAttriTypeList[attri.type];
		-- local _value = attri.value;
		if self.isbangding == false then
			text = "";
		end
		-- local gem_color = ItemConfig:get_gem_color(self.model_data.item_id);
		-- text = text..c3_white_yellw..LangGameString[1979].. -- [1979]="镶嵌属性#r"
		-- 		gem_color.._type.."       +"..tostring(_value).."#r";
		text = text ..  ""

	--是否是速回药
	elseif ItemConfig.ITEM_TYPE_FAST_MEDICAMENT == item_data["type"] then
		local drug_type,value = self:get_quick_drug_effect(item_data);
		if value < 1 and value > 0 then
			text = text..c3_white..LangGameString[1980]..(value*100).."%"..staticAttriTypeList[drug_type].."#r"; -- [1980]="使用后立即恢复"
		else
			text = text..c3_white..LangGameString[1980]..tostring(value)..staticAttriTypeList[drug_type].."#r"; -- [1980]="使用后立即恢复"
		end
		
	end

	-- 14426  14427
	local dress_avatar_height = 0;
	--Shan Lu HY ignore 时装
	--[[
	if self.model_data.item_id == 14426 or self.model_data.item_id == 14427 then
		dress_avatar_height = 100
		-- local male_avatar = self:get_dress_animate_sprite( 90, 190, self.model_data.item_id,0);
		-- self.view:addChild(male_avatar);
		-- local woman_avatar = self:get_dress_animate_sprite( 190, 190, self.model_data.item_id,1);
		-- woman_avatar:setFlipY(true);
		-- self.view:addChild(woman_avatar);
		
		-- modify by hcl on 2014/1/2 --
		-- 只显示自己性别的服装
		local player = EntityManager:get_player_avatar();
		print("player.sex",player.sex)
		local avatar = self:get_dress_animate_sprite( 140, 210, self.model_data.item_id,player.sex);
		self.view:addChild(avatar);
		-- modify by hcl on 2014/1/2 --
	end
	]]--
	--是否已经绑定
	local bandText = ''
	if self.isbangding then
		--local bangding_lab = UILabel:create_lable_2( LangGameString[1981], 280-25, item_height-7, FONT_SIZE, ALIGN_RIGHT ) -- [1981]="#cff66cc已绑定"
		--self.view:addChild(bangding_lab);
		bandText=LangGameString[1981]
	end
	local item_info = text
	local item_desc = c3_white..item_data.desc;
	local icon_tex = ItemConfig:get_item_icon(self.model_data.item_id)
	local name_color = "#c"..ItemConfig:get_item_color(item_data.color+1);
	local item_name = string.format("%s%s",name_color,item_data["name"])
	local splitter_tex = UILH_COMMON.split_line

	--print('>>>>>>>>>>>',TipsGridView)
	self:addDialog(item_desc,FONT_SIZE)
	self:addStaticLine(splitter_tex,3)
	self:addDialog(item_info,FONT_SIZE)
	-- self:addSlot(72,icon_tex,true)
	self:addSlotItem(self.model_data.item_id, true)
	self:addText(item_name,FONT_SIZE,ALIGN_LEFT,true)
	self:addSpacer(UI_TOOLTIPS_SPACER,0)
	self:addText(bandText,FONT_SIZE,ALIGN_LEFT,true)
	self:autofitRow()
	self:finish()
end 

--获取速回药的buff数据
function ItemTipView:get_quick_drug_effect( data )
	if data ~= nil then
		local staticAtrris = data["staitcAttrs"];
		local staticAtrri = staticAtrris[1];
		local _type 	= staticAtrri["type"];		--恢复效果类型
		local _value 	= staticAtrri["value"];		--一次性的恢复值
		return _type,_value;
	end
end
--获取普通药品的buff数据
function ItemTipView:get_general_drug_effect( data )
	if data ~= nil then
		local staticAtrris = data["staitcAttrs"];
		local staticAtrri = staticAtrris[1];
		local _type 	= staticAtrri["type"];		--恢复效果类型
		local _value 	= staticAtrri["value"];		--每一次的恢复值
		staticAtrri 	= staticAtrris[2];
		local _count 	= staticAtrri and staticAtrri["value"] or 1;	--恢复几次(参与计算恢复总值)
		staticAtrri 	= staticAtrris[3];
		local _time 	= staticAtrri and staticAtrri["value"] or 1;		--每几秒恢复一次
		local _allValue = _value*_count;				--恢复总值

		return _type,_value,_time,_allValue;
	end
end

-- 创建普通药品的效果描述格式
function ItemTipView:create_drug_effect_text(isbangding,second,times_value,all_value ,effect_type)
	if isbangding then
		return c3_white..LangGameString[1982]..c3_yellow..tostring(second)..LangGameString[875]..c3_white..LangGameString[1983]..c3_yellow..tostring(times_value)..LangGameString[1546]..c3_white..tostring(effect_type)..LangGameString[1984]..c3_yellow..tostring(all_value)..LangGameString[1546]..c3_white..tostring(effect_type).."#r"; -- [1982]="每" -- [875]="秒" -- [1983]="恢复" -- [1546]="点" -- [1984]=".#r共计恢复" -- [1546]="点"
	else
		return c3_white..LangGameString[1982]..c3_yellow..tostring(second)..LangGameString[875]..c3_white..LangGameString[1983]..c3_yellow..tostring(times_value)..LangGameString[1546]..c3_white..tostring(effect_type)..LangGameString[1984]..c3_yellow..tostring(all_value)..LangGameString[1546]..c3_white..tostring(effect_type).."#r"; -- [1982]="每" -- [875]="秒" -- [1983]="恢复" -- [1546]="点" -- [1984]=".#r共计恢复" -- [1546]="点"
	end
	
end

-- 创建属性加成药品的效果描述格式
function ItemTipView:create_attri_drug_effect_text( isbangding,second,times_value,all_value ,effect_type )
	return c3_white..LangGameString[1985]..c3_yellow..all_value..c3_white..LangGameString[1546]..effect_type..LangGameString[1986]..c3_yellow..(tonumber(second)/60)..c3_white..LangGameString[1987]; -- [1985]="使用后增加" -- [1546]="点" -- [1986]=",持续" -- [1987]="分钟#r"
end

-- 判断是否是属性加成药品.
function ItemTipView:IS_ATTRI_MEDICAMENTS( item_id )
	print("判断是否是属性加成药品", item_id);
	for i,v in ipairs(ATTRI_MEDICAMENTS) do
		if v == item_id then
			return true;
		end
	end
	return false;
end

-- 获取仙侣情缘礼包和雪月情缘礼包avatar动画形象
function ItemTipView:get_dress_animate_sprite(x, y, item_id, sex )
	
	local player = EntityManager:get_player_avatar();
	
	local suit_id;
	if item_id == 14426 then
		suit_id = 7;
	elseif item_id == 14427 then
		suit_id = 9;
	end
	
	local dress_id = tonumber(string.format("2%d%d0%d",player.job,sex,suit_id));
	
	if dress_id ~= 0 then
		
		local path = EntityFrameConfig:get_human_path( dress_id );
		ZXLog('-----------ItemTipView:get_dress_animate_sprite-----------------')
		local action = {0,0,4,0.2};
		return MUtils:create_animation(x,y,path,action );
	end
end

function ItemTipView:create( model_data )

	self.model_data = model_data;
	--local temp_info = { texture = "", x = 0, y = 25, width = 280, height = 239 }
	return ItemTipView(TIP_WIDTH,TIP_HEIGHT_MIN);--31

end
