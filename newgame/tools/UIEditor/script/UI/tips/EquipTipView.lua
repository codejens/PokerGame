-- EquipTipView.lua 
-- createed by fangjiehua on 2013-1-12
-- EquipTipView 面板
 
super_class.EquipTipView(TipsGridView)

local c3_red  	= "#cff0000"
local c3_white = "#cffffff";
local c3_green 	= "#c38ff33";
local c3_yellow = "#cfff000";
local c3_pink	= "#cff66cc";
local c3_blue	= "#c00c0ff";
local c3_gray	= "#ca7a7a6";


local TIP_WIDTH = UI_TOOLTIPS_EQUIP_DIALOG_WIDTH
local TIP_HEIGHT_MIN = 64

-- 统一取空格间隔的长度
local function get_space_str_by_str_len( str_len )
	local space_str = "";
	if str_len <= 6 then	-- 俩个字符
		space_str = "        "
	elseif str_len < 12 and str_len > 6 then--三个字符
		space_str = "    "
	elseif str_len >= 12 then--四个字符
		space_str = "    "
	end
	return space_str;
end

local function get_equipment_base_info_text( equip_data ,model_data )
	--装备基本信息，名字，类型，职业，需要等级
	--名字
	local equip_name = equip_data.name;
	local _type = equip_data.type;
	--类型
	local equip_type = "";
	if _type >= 1 and _type <=11 then
		-- require "config/StaticAttriType"
		equip_type = equipmentTypeList[_type];
	end
	--需要等级
	local conds = equip_data.conds;
	local need_level = 1;
	local equip_job = jobTypeList[0];

	for k,v in pairs(conds) do
		if v.cond == 1 then
			--需要的等级
			need_level = v.value;
		elseif v.cond == 3 then
			--什么职业的装备
			equip_job = jobTypeList[v.value];
		end
	end

	 
	--装备的颜色
	local color = "#c"..GlobalConfig:get_item_color(equip_data["color"]+1)
	local quality_str = ItemConfig:get_equip_quality_name_by_quality( model_data.void_bytes_tab[1]  );
	
	--装备基础信息文本
	local equip_name_text;

	if equip_data.type == ItemConfig.ITEM_TYPE_MARRIAGE_RING then

		local ring_level = model_data.strong;
		print("");
		if ring_level == 0 then
			ring_level = LangGameString[1964] -- [1964]="(未激活)"
		else 
			ring_level = "("..ring_level..LangGameString[438]; -- [438]="级)"
		end	
		
		equip_name_text = color..equip_name..ring_level;
	else
	 	-- equip_name_text = color..quality_str..equip_name..c3_pink;
	 	equip_name_text = color..equip_name..c3_pink;
	end

	--如果有强化才显示颜色
	if model_data.strong ~= 0 and equip_data.type ~= ItemConfig.ITEM_TYPE_MARRIAGE_RING then
		
		equip_name_text = equip_name_text.."+"..tostring(model_data.strong);

	end
	local equip_info_text = c3_white..LangGameString[1965]..c3_yellow..equip_type.."#r".. -- [1965]="类    型:  "
						c3_white..LangGameString[1966]..c3_yellow..equip_job.."#r".. -- [1966]="职    业:  "
						c3_white..LangGameString[1967]..c3_yellow..need_level.."#r"; -- [1967]="需要等级:  "
	return equip_name_text,equip_info_text;

end

-- 绘制星星
local function draw_start_panel(x,y,strong_value)
	
	local star_panel = CCBasePanel:panelWithFile(x,y,320,16,"");
	
	if strong_value <=15 then
		for i=0,14 do

			local star = CCZXImage:imageWithFile(0,0,16,16,"");
			--star:addTexWithFile(CLICK_STATE_DISABLE, "ui/common/star_gray.png")
			star_panel:addChild(star);
			--star:setAnchorPoint(0.5,0.5);
			--设置颜色
			if i>=0 and i <3 then
				star:setTexture(UIResourcePath.FileLocate.lh_normal .. "star_green.png");
			elseif i>=3 and i<6 then
				star:setTexture(UIResourcePath.FileLocate.lh_normal .. "star_blue.png");
			elseif i>=6 and i<9 then
				star:setTexture(UIResourcePath.FileLocate.lh_normal .. "star_purple.png");
			elseif i>=9 and i<12 then
				star:setTexture(UIResourcePath.FileLocate.lh_normal .. "star_yellow.png");
			elseif i>=12 and i<15 then
				star:setTexture(UIResourcePath.FileLocate.lh_normal .. "star_red.png");
			end
			--设置位置的偏移
			-- if i<10 then
				star:setPosition(16*i,0);
			-- else
			-- 	star:setPosition(16*(i-10),8);
			-- end
		
			if i>(strong_value-1) then 
				star:setCurState(CLICK_STATE_DISABLE);
			end

		end
	end
	
	return star_panel;
end

--获取装备的基础属性以及强化属性
local function get_equipment_base_attri_text( equip_data,model_data )
	-- 基础属性
	local staticAttris = equip_data.staitcAttrs;
	-- 强化属性
	local strongAttris = equip_data.strongAttrs;
	-- 品质属性
	local qualityAttris = equip_data.qualityAttrs;

	local text = c3_yellow..LangGameString[1968] -- [1968]="基础属性#r"

	local strongAttri = {};
	if model_data.strong ~= 0 and model_data.strong ~= nil then
		strongAttri = strongAttris[model_data.strong];
	end
	
	-- 装备品质
	local equip_quality = model_data.void_bytes_tab[1];

	for i,v in ipairs(staticAttris) do

		local quality_att_value = 0;
		if equip_quality >= 2 then
			-- 品质是从1开始算起的，普通 = 1，依次递增
			-- 而品质的加成是从精良=2开始加成的,而配置是从精良=1开始，所以在去配置的时候要-1;
			local qual_data = equip_data.qualityAttrs[equip_quality-1];
			if qual_data then
				quality_att_value = qual_data[i].value;
			end
		end
		local _type = staticAttriTypeList[v.type];
		-- 基础属性数值
		local _value = v.value;
		local type_len = string.len(_type);
		local space_str = get_space_str_by_str_len(type_len);
		text = text..c3_white.._type..space_str.."+"..( _value + quality_att_value );

		if #strongAttri ~= 0 and equip_data.type ~= ItemConfig.ITEM_TYPE_MARRIAGE_RING then
			-- 非婚戒的强化加成
			local strong_table = strongAttri[i];
			-- 强化数值的品质加成率
			local quality_k = EquipEnhanceConfig:get_quality_addition_valua( model_data.strong )
			text = text..c3_red.."+"..math.floor(strong_table.value+quality_att_value*quality_k);
		end

		if equip_data.type == ItemConfig.ITEM_TYPE_MARRIAGE_RING and  #strongAttri ~= 0 then
			--如果是婚戒的加成，数值是不需要乘以一个系数值
			local strong_table = strongAttri[i];
			if strong_table.value ~= 0 then
				text = text..c3_green.."+"..math.floor(strong_table.value);
			end
		end


		text = text.."#r";
	end

	--洗练属性
	if model_data.smith_num ~= nil and model_data.smith_num > 0 then
		text = text..c3_yellow..LangGameString[1969]; -- [1969]="洗练属性#r"
		for i=1,model_data.smith_num do
			local type_str = staticAttriTypeList[model_data.smiths[i].type];
			local type_len = string.len(type_str);
			
			local space_str = get_space_str_by_str_len(type_len);

			local color = EquipEnhanceConfig:get_attr_color( model_data.smiths[i].type ,model_data.smiths[i].value );
			local max = EquipEnhanceConfig:get_xl_max_value( model_data.smiths[i].type );
			local xilian_value = math.abs(model_data.smiths[i].value);

			if xilian_value == max then
				text = text ..color.. type_str .. space_str .. "+" .. xilian_value .. LangGameString[1970]; -- [1970]="(满)#r"
			else
				text = text ..color.. type_str .. space_str .. "+" .. xilian_value .. "#r";
			end
		end
	end

	return text;
end

--获取宝石镶嵌
local function get_equipment_holes_attri_text( x,y,model_data )
	local holes_panel = CCBasePanel:panelWithFile(x,y,280,165,"");
	--holes_panel:setAnchorPoint(0,1);
	--镶嵌属性
	local holes_attri_lab = CCZXLabel:labelWithText(0,140,c3_yellow..LangGameString[1971],UI_TOOLTIPS_EQUIP_FONT_SIZE,ALIGN_LEFT); -- [1971]="镶嵌属性"
	holes_panel:addChild(holes_attri_lab);

	local gem_icon_t = {
		[27] = UIResourcePath.FileLocate.lh_normal .. "holes_1.png",
		[23] = UIResourcePath.FileLocate.lh_normal .. "holes_2.png",
		[33] = UIResourcePath.FileLocate.lh_normal .. "holes_3.png",
		[17] = UIResourcePath.FileLocate.lh_normal .. "holes_4.png",
	}

	for i=1,3 do
		local v = model_data.holes[i];

		-- --宝石图标
		-- local img_str = UIResourcePath.FileLocate.normal .. "holes_0.png";
		-- local icon_bg = CCZXImage:imageWithFile(10,135-(i-1)*42,35,35,img_str);
		-- icon_bg:setAnchorPoint(0,1);
		-- holes_panel:addChild(icon_bg);

		if v ~= 0 then
			-- local icon = CCZXImage:imageWithFile(35/2,35/2,22,22,ItemConfig:get_item_icon(v));
			-- icon:setAnchorPoint(0.5,0.5);
			-- icon_bg:addChild(icon);
			--宝石名字
			local hole_name = ItemConfig:get_item_name_by_item_id(v);
			--宝石静态属性
			local hole_staticAttris = ItemConfig:get_staitc_attrs_by_id(v);
			local attri = hole_staticAttris[1];

			--宝石图标
			local icon_path = gem_icon_t[attri.type]
			local icon = CCZXImage:imageWithFile(10,135-(i-1)*42,35,35, icon_path);
			icon:setAnchorPoint(0,1);
			holes_panel:addChild(icon);

			--属性类型
			local _type = staticAttriTypeList[attri.type];
			--属性数值
			local _value = attri.value;
			local color = ItemConfig:get_gem_color(v);
			local text = color..hole_name.."#r"..color.._type.." +"..tostring(_value);
			local holes_dialog = CCDialogEx:dialogWithFile( 55, 229-(i-1)*42-77-15,
															UI_TOOLTIPS_EQUIP_DIALOG_WIDTH, 80, 
															10, "", TYPE_VERTICAL ,ADD_LIST_DIR_UP);
			holes_dialog:setAnchorPoint(0,1);
			holes_dialog:setFontSize(UI_TOOLTIPS_EQUIP_FONT_SIZE);
			holes_dialog:setText(text);
			holes_panel:addChild(holes_dialog);
		else		
			--宝石图标
			local icon_path = UIResourcePath.FileLocate.lh_normal .. "holes_0.png"
			local icon = CCZXImage:imageWithFile(10,135-(i-1)*42,35,35, icon_path);
			icon:setAnchorPoint(0,1);
			holes_panel:addChild(icon);
			
			local text_lab = CCZXLabel:labelWithText(57,108-(i-1)*42,
													 c3_white..LangGameString[1972],
													 UI_TOOLTIPS_EQUIP_FONT_SIZE,
													 ALIGN_LEFT); -- [1972]="尚未镶嵌宝石"
			-- text_lab:setAnchorPoint(CCPointMake(0,1));
			holes_panel:addChild(text_lab);
		end
	end
	
	return holes_panel;
end

local function get_equipment_suit_info(is_person_equip,suit_id)

	local text = c3_yellow..LangGameString[1973]; -- [1973]="套装属性"
	
	local suit = SuitConfig:get_suit_equip_info(suit_id);
	 
	local equips = Utils:table_deepcopy( suit["items"]);
 
	local suit_equip_name_text = "";

	--是否来自人物身上装备的tips
	if is_person_equip == true then
		 
		local suit_equip_list = {};

		local equip_info = UserInfoModel:get_equi_info();
		for i,v in ipairs(equip_info) do
			--遍历人物身上的装备，
			local equip_data = ItemConfig:get_item_by_id(v.item_id);

			--找到和该套装id一致的套装装备
			if equip_data.suitId == suit_id then
				
				--那这个装备和套装里的装备进行匹配
				for i,suit_item_id in ipairs(equips) do
					print("该套装装备id",suit_item_id,"已经装备id",v.item_id);
					if suit_item_id == v.item_id then
						-- print("套装；",);
						
						suit_equip_list[#suit_equip_list+1] = equip_data;
						table.remove(equips,i);
					end
				end
			end
		end
		--拼接处拥有该套装的装备
		text = text.."("..tostring(#suit_equip_list).."/5)"

		--拼接处套装里的所有装备名字
		for i,v in ipairs(suit_equip_list) do
			suit_equip_name_text = suit_equip_name_text..c3_pink..v.name.."  ";
		end
		for i,v in ipairs(equips) do

			local equip_data = ItemConfig:get_item_by_id(v);
			suit_equip_name_text = suit_equip_name_text..c3_gray..equip_data.name.."  ";
			print("没有装备的",v,equip_data.name);
		end
		suit_equip_name_text = suit_equip_name_text.."#r"

		--套装附带来的属性
		 
		local has_equip_count = #suit_equip_list-1;
		
		for i,v in ipairs(suit.attrs) do
			local _type = staticAttriTypeList[v.type];
			local color = c3_pink;

			if i>has_equip_count then
				color = c3_gray;
			end
			suit_equip_name_text = suit_equip_name_text..color.."("..tostring(v.need)..") ".._type.." +"..tostring(v.value).."#r";

		end

	else --不是人物身上装备的tip
		text = text.."(0/5)"

		--套装各个装备的名字
		for i,v in ipairs(suit.items) do
			local equip_data = ItemConfig:get_item_by_id(v);
			suit_equip_name_text = suit_equip_name_text..c3_gray..equip_data.name.."  ";
		end
		suit_equip_name_text = suit_equip_name_text.."#r";

		--套装附带的属性
		 
		for i,v in ipairs(suit.attrs) do
			local _type = staticAttriTypeList[v.type];
			suit_equip_name_text = suit_equip_name_text..c3_gray.."("..tostring(v.need)..") ".._type.." +"..tostring(v.value).."#r";

		end
	end

	return text, suit_equip_name_text;
end

function EquipTipView:__init( width, height, border, gapX, gapY )
	local equip_data = ItemConfig:get_item_by_id(self.model_data.item_id);
	local splitter_tex = UILH_COMMON.split_line

	--先排版基础属性，因为这个长度是不定长的
	--基础属性，staticAttri + 强化属性
	local attri_text = get_equipment_base_attri_text(equip_data,self.model_data);

	local FONT_SIZE = UI_TOOLTIPS_EQUIP_FONT_SIZE

	self:addDialog(equip_data.desc,FONT_SIZE)
	self:addStaticLine(splitter_tex,3)

	--套装
	if equip_data.suitId ~= 0 then 
		local suitTitle, suitInfo = get_equipment_suit_info(self.is_person_equip,equip_data.suitId)
		self:addDialog(suitInfo,FONT_SIZE)
		self:addText(suitTitle,FONT_SIZE)
		self:addStaticLine(splitter_tex,3)
	end

	--镶嵌
	if  equip_data.color > 1 and equip_data.type ~= ItemConfig.ITEM_TYPE_MARRIAGE_RING then
		local holes_panel = get_equipment_holes_attri_text(0,0,self.model_data);
		self:addComponent(holes_panel)
		self:addStaticLine(splitter_tex,3)
	end

	self:addDialog(attri_text,FONT_SIZE)

	-------------强化等级,星星
	if equip_data.type == ItemConfig.ITEM_TYPE_MARRIAGE_RING then
		-- 如果是结婚戒指的话，则不显示强化星星
		local lover_str="";
		print("self.model_data.other_marry_ring,self.model_data.strong",self.model_data.other_marry_ring,self.model_data.strong)
		if self.model_data.other_marry_ring == nil and self.model_data.strong > 0 then
			-- 如果戒指已经被激活
			local data = MarriageModel:get_marriage_data()
			lover_str = "#cff66cc"..data.lover_name..LangGameString[1974]; -- [1974]="的仙侣"
		end
		self:addText(lover_str,FONT_SIZE)
	else
		local star_panel = draw_start_panel(0,0,self.model_data.strong);
		self:addComponent(star_panel)
	end

	-------------战斗力
	-- self:addSpacer(-28,0)
	self:addImage(UILH_ROLE.text_zhandouli,-1,-1,true)

	--战斗力数字
	local fight_value = 0;
	if self.model_data.series == nil then 
		fight_value = ItemModel:calculate_equip_base_attack(self.model_data.item_id);
	else
		-- 根据model去计算战斗力
		fight_value = ItemModel:calculate_equip_attack_by_item_date( self.model_data );
	end

	if fight_value == nil then
		fight_value = 0;
	end
	fight_value =  math.floor(fight_value); 
	self:addSpacer(10,14)
	self:addImageNumber(tostring(fight_value), FLOW_COLOR_TYPE_RED,20,24,true)
	self:autofitRow()

	local equip_name,base_info = get_equipment_base_info_text(equip_data,self.model_data);

	self:addDialog(base_info,FONT_SIZE)

	--------------icon图标
	-- local slot = self:addSlot(72,ItemConfig:get_item_icon(self.model_data.item_id))
	self:addSpacer(8,0)
	local slot = self:addSlotItem(self.model_data.item_id)
	--self:addSpacer(0,-72)
	
	--------------是否绑定
	local isbangding = LangGameString[1959]; -- [1959]="未绑定"
	if self.model_data.flag==1 then
		isbangding = LangGameString[1960]; -- [1960]="已绑定"
	end
	isbangding = c3_yellow..isbangding
	local bangding = CCZXLabel:labelWithText(100,2,isbangding,16,ALIGN_LEFT);
	slot:addChild(bangding);

	-------------装备的基础信息
	-- 品质称号
	local color = "#c"..GlobalConfig:get_item_color(equip_data["color"]+1)
	local quality_str = ItemConfig:get_equip_quality_name_by_quality( self.model_data.void_bytes_tab[1]  );
	local equip_buff = CCZXLabel:labelWithText(100,27,color..quality_str,16,ALIGN_LEFT);
	slot:addChild(equip_buff);

	
	local equip_name,base_info = get_equipment_base_info_text(equip_data,self.model_data);
	--装备名字
	local name_text = CCDialogEx:dialogWithFile( 100, 72,
									             UI_TOOLTIPS_EQUIP_DIALOG_WIDTH, 100, 10, "", TYPE_VERTICAL ,ADD_LIST_DIR_UP);
	name_text:setAnchorPoint(0,1);
	name_text:setFontSize(UI_TOOLTIPS_EQUIP_FONT_SIZE)
	name_text:setText(equip_name);
	slot:addChild(name_text);

	if equip_data.type == ItemConfig.ITEM_TYPE_MARRIAGE_RING then
		-- 如果是戒指就不显示品质称号
		equip_buff:setIsVisible(false);
	end

	self:finish()

end

function EquipTipView:create(is_person_equip,model_data)
	
	self.model_data = model_data;
	self.is_person_equip = is_person_equip;
	local temp_info = { texture = "", x = 0, y = -50, width = 210, height = 270 }
	local tipView = EquipTipView(TIP_WIDTH,TIP_HEIGHT_MIN)
	return tipView;

end



--初始化Tips
--[[
function EquipTipView:__init2( width, height, border, gapX, gapY )
	--装备的config数据
 
	local equip_data = ItemConfig:get_item_by_id(self.model_data.item_id);

	--先排版基础属性，因为这个长度是不定长的
	--基础属性，staticAttri + 强化属性
	local attri_text = get_equipment_base_attri_text(equip_data,self.model_data);
	local item_static_attri = CCDialogEx:dialogWithFile(9, 81,
														UI_TOOLTIPS_EQUIP_DIALOG_WIDTH, 250, 
														10, "", TYPE_VERTICAL ,ADD_LIST_DIR_UP);
	item_static_attri:setAnchorPoint(0,1);
	item_static_attri:setFontSize(UI_TOOLTIPS_EQUIP_FONT_SIZE);
	item_static_attri:setText(attri_text);

	local static_att_size_h = item_static_attri:getInfoSize().height

	-- 装备描述
	local equip_desc_dialog = CCDialogEx:dialogWithFile(15, 0,
														UI_TOOLTIPS_EQUIP_DIALOG_WIDTH, 50, 
														10, "", TYPE_VERTICAL ,ADD_LIST_DIR_UP);
	equip_desc_dialog:setAnchorPoint(0,1);
	equip_desc_dialog:setFontSize(UI_TOOLTIPS_EQUIP_FONT_SIZE);
	local text = c3_white..equip_data.desc;
	equip_desc_dialog:setText(text);

	local desc_size_h = equip_desc_dialog:getInfoSize().height;

	local contentHeight = UI_TOOLTIPS_EQUIP_TOP_HEIGHT+static_att_size_h+desc_size_h+12;
	
	local suit_panel,dialog_h;
	if equip_data.suitId ~= 0 then 
		---- 如果有套装属性，加上套装属性的高度
		suit_panel, dialog_h = get_equipment_suit_attri(0,0,self.is_person_equip,equip_data.suitId);
		contentHeight = contentHeight+40+dialog_h;
	end

	--品质大于1，为绿色以上的装备才有宝石镶嵌
	if equip_data.color > 1 and equip_data.type ~= ItemConfig.ITEM_TYPE_MARRIAGE_RING then
		contentHeight = contentHeight+154;
	end

	--根据计算好的高度重新设置self.view的size
	self.view:setSize(210,contentHeight);
	self.view:setPosition(0,270-530);

	--------------icon图标
	local icon_bg = CCZXImage:imageWithFile(20,contentHeight-6+2,72,72,UIPIC_ITEMSLOT);
	icon_bg:setAnchorPoint(0,1);
	self.view:addChild(icon_bg);
	
	local icon = CCZXImage:imageWithFile(72/2,72/2,64,64,ItemConfig:get_item_icon(self.model_data.item_id));--self.model_data.item_id));
	icon:setAnchorPoint(0.5,0.5);
	icon_bg:addChild(icon);

	--------------是否绑定
	local isbangding = LangGameString[1959]; -- [1959]="未绑定"
	if self.model_data.flag==1 then
		isbangding = LangGameString[1960]; -- [1960]="已绑定"
	end
	isbangding = c3_yellow..isbangding
	local bangding = CCZXLabel:labelWithTextS(CCPointMake(100, contentHeight-68),isbangding,16,ALIGN_LEFT);
	self.view:addChild(bangding);

	-------------装备的基础信息

	-- 品质称号
	local color = "#c"..GlobalConfig:get_item_color(equip_data["color"]+1)
	local quality_str = ItemConfig:get_equip_quality_name_by_quality( self.model_data.void_bytes_tab[1]  );
	local equip_buff = CCZXLabel:labelWithTextS(CCPointMake(100, contentHeight-22),color..quality_str,16,ALIGN_LEFT);
	self.view:addChild(equip_buff);

	local equip_name,base_info = get_equipment_base_info_text(equip_data,self.model_data);
	--装备名字
	local name_text = CCDialogEx:dialogWithFile( 100, contentHeight-24,
									             UI_TOOLTIPS_EQUIP_DIALOG_WIDTH, 100, 10, "", TYPE_VERTICAL ,ADD_LIST_DIR_UP);
	name_text:setAnchorPoint(0,1);
	name_text:setFontSize(UI_TOOLTIPS_EQUIP_FONT_SIZE)
	name_text:setText(equip_name);
	self.view:addChild(name_text);

	if equip_data.type == ItemConfig.ITEM_TYPE_MARRIAGE_RING then
		-- 如果是戒指就不显示品质称号
		equip_buff:setIsVisible(false);
		bangding:setPosition(90, contentHeight-63+9)
		name_text:setPosition(90, contentHeight-24+9)
	end

	--装备信息
	local info_text = CCDialogEx:dialogWithFile( 90-65, contentHeight-82,
												 UI_TOOLTIPS_EQUIP_DIALOG_WIDTH, 100, 10, "", TYPE_VERTICAL ,ADD_LIST_DIR_UP);
	info_text:setAnchorPoint(0,1);
	info_text:setFontSize(UI_TOOLTIPS_EQUIP_FONT_SIZE);
	info_text:setText(base_info);
	self.view:addChild(info_text);
	
	-------------战斗力
	
	local fight_bg = CCZXImage:imageWithFile(210/2,contentHeight-UI_TOOLTIPS_EQUIP_FIGHT_BG_VALUE,200,31,nil,5,15);--ui/common/ng_gradient2.png
	fight_bg:setAnchorPoint(0.5,1);
	self.view:addChild(fight_bg);
	
	--战斗力文字图片
	local fight_icon = CCZXImage:imageWithFile(200/2-30,31/2,154,56,UIResourcePath.FileLocate.normal .. "common_tip_fight.png");
	fight_icon:setAnchorPoint(0.5,0.5);
	fight_bg:addChild(fight_icon);

	--战斗力数字
	local fight_value = 0;
	if self.model_data.series == nil then 
		fight_value = ItemModel:calculate_equip_base_attack(self.model_data.item_id);
	else
		-- 根据model去计算战斗力
		fight_value = ItemModel:calculate_equip_attack_by_item_date( self.model_data );
	end

	if fight_value == nil then
		fight_value = 0;
	end
	fight_value =  math.floor(fight_value); 
	
	local fight_lab = ZXLabelAtlas:createWithString(tostring(fight_value),UIResourcePath.FileLocate.normal .. "num");
	fight_lab:setPosition(CCPointMake(108+44+7,25/2+2));
	fight_lab:setAnchorPoint(CCPointMake(0.5,0.5))
	fight_bg:addChild(fight_lab);

	-------------强化等级,星星
	if equip_data.type == ItemConfig.ITEM_TYPE_MARRIAGE_RING then
		-- 如果是结婚戒指的话，则不显示强化星星
		local lover_str="";
		print("self.model_data.other_marry_ring,self.model_data.strong",self.model_data.other_marry_ring,self.model_data.strong)
		if self.model_data.other_marry_ring == nil and self.model_data.strong > 0 then
			-- 如果戒指已经被激活
			local data = MarriageModel:get_marriage_data()
			lover_str = "#cff66cc"..data.lover_name..LangGameString[1974]; -- [1974]="的仙侣"
		end
		local ring_string = UILabel:create_lable_2( lover_str, 28,contentHeight-193-12, UI_TOOLTIPS_EQUIP_FONT_SIZE, ALIGN_LEFT );
		self.view:addChild(ring_string);
	else
		local star_panel = draw_start_panel(28,contentHeight-UI_TOOLTIPS_EQUIP_STAR,self.model_data.strong);
		star_panel:setAnchorPoint(0,1);
		self.view:addChild(star_panel);
	end
	

	---------------------------昏割线
	local split_img = CCZXImage:imageWithFile(10,contentHeight-UI_TOOLTIPS_EQUIP_LOWER_LINE,UI_TOOLTIPS_EQUIP_GEM_LINE,3,UILH_COMMON.split_line);
	self.view:addChild(split_img);
	
	-------------加入基础属性
	item_static_attri:setPosition(20,contentHeight-UI_TOOLTIPS_EQUIP_LOWER_BASE);
	self.view:addChild(item_static_attri);

	-------------------------昏割线
	local split_img = CCZXImage:imageWithFile(10,contentHeight-static_att_size_h-UI_TOOLTIPS_EQUIP_LOWER_LINE2,UI_TOOLTIPS_EQUIP_GEM_LINE,3,UILH_COMMON.split_line);
	self.view:addChild(split_img);

	--------------宝石镶嵌属性
	local gem_panel_height = 0;
	if  equip_data.color > 1 and equip_data.type ~= ItemConfig.ITEM_TYPE_MARRIAGE_RING then
		local holes_panel = get_equipment_holes_attri_text(20,contentHeight-static_att_size_h-UI_TOOLTIPS_EQUIP_GEM,self.model_data);
		self.view:addChild(holes_panel);
		gem_panel_height = 154;

		-------------------------昏割线
		local split_img = CCZXImage:imageWithFile(10,contentHeight-static_att_size_h-UI_TOOLTIPS_EQUIP_GEM_LINE,UI_TOOLTIPS_EQUIP_GEM_LINE,3,UILH_COMMON.split_line);
		self.view:addChild(split_img);
	end

	--套装属性
	local suit_panel_height = 0;
	if equip_data.suitId ~= 0 then
		--142
		--有的装备没有套装属性，所以如果suitId为0，则不加套装属性
		-- local suit_panel, dialog_h = get_equipment_suit_attri(20,contentHeight-static_att_size_h-350-15-50,self.is_person_equip,equip_data.suitId);
		suit_panel:setPosition(20,contentHeight-static_att_size_h-UI_TOOLTIPS_EQUIP_SUIT);
		self.view:addChild(suit_panel);
		suit_panel_height = dialog_h + 40;
		-------------------------昏割线
		local split_img = CCZXImage:imageWithFile(10,contentHeight-static_att_size_h-suit_panel_height-UI_TOOLTIPS_EQUIP_SUIT_LINE,UI_TOOLTIPS_EQUIP_GEM_LINE,3,UILH_COMMON.split_line);
		self.view:addChild(split_img);
	end

	--装备描述
	equip_desc_dialog:setPosition(20, contentHeight-static_att_size_h-suit_panel_height-gem_panel_height-UI_TOOLTIPS_EQUIP_DESC);
	self.view:addChild(equip_desc_dialog);

end


---套装属性
local function get_equipment_suit_attri(x,y,is_person_equip,suit_id)

	local suit_panel = CCBasePanel:panelWithFile(x,y,200,140,"");
	suit_panel:setAnchorPoint(0,1);
	local text = c3_yellow..LangGameString[1973]; -- [1973]="套装属性"
	
	 
	local suit = SuitConfig:get_suit_equip_info(suit_id);
	 
	local equips = Utils:table_deepcopy( suit["items"]);
 
	local suit_equip_name_text = "";

	--是否来自人物身上装备的tips
	if is_person_equip == true then
		 
		local suit_equip_list = {};

		local equip_info = UserInfoModel:get_equi_info();
		for i,v in ipairs(equip_info) do
			--遍历人物身上的装备，
			local equip_data = ItemConfig:get_item_by_id(v.item_id);

			--找到和该套装id一致的套装装备
			if equip_data.suitId == suit_id then
				
				--那这个装备和套装里的装备进行匹配
				for i,suit_item_id in ipairs(equips) do
					print("该套装装备id",suit_item_id,"已经装备id",v.item_id);
					if suit_item_id == v.item_id then
						-- print("套装；",);
						
						suit_equip_list[#suit_equip_list+1] = equip_data;
						table.remove(equips,i);
					end
				end
			end
		end
		--拼接处拥有该套装的装备
		text = text.."("..tostring(#suit_equip_list).."/5)"

		--拼接处套装里的所有装备名字
		for i,v in ipairs(suit_equip_list) do
			suit_equip_name_text = suit_equip_name_text..c3_pink..v.name.."  ";
		end
		for i,v in ipairs(equips) do

			local equip_data = ItemConfig:get_item_by_id(v);
			suit_equip_name_text = suit_equip_name_text..c3_gray..equip_data.name.."  ";
			print("没有装备的",v,equip_data.name);
		end
		suit_equip_name_text = suit_equip_name_text.."#r"

		--套装附带来的属性
		 
		local has_equip_count = #suit_equip_list-1;
		
		for i,v in ipairs(suit.attrs) do
			local _type = staticAttriTypeList[v.type];
			local color = c3_pink;

			if i>has_equip_count then
				color = c3_gray;
			end
			suit_equip_name_text = suit_equip_name_text..color.."("..tostring(v.need)..") ".._type.." +"..tostring(v.value).."#r";

		end

	else --不是人物身上装备的tip
		text = text.."(0/5)"

		--套装各个装备的名字
		for i,v in ipairs(suit.items) do
			local equip_data = ItemConfig:get_item_by_id(v);
			suit_equip_name_text = suit_equip_name_text..c3_gray..equip_data.name.."  ";
		end
		suit_equip_name_text = suit_equip_name_text.."#r";

		--套装附带的属性
		 
		for i,v in ipairs(suit.attrs) do
			local _type = staticAttriTypeList[v.type];
			suit_equip_name_text = suit_equip_name_text..c3_gray.."("..tostring(v.need)..") ".._type.." +"..tostring(v.value).."#r";

		end
	end
	--套装属性(x/5) lab
	local suit_count = CCZXLabel:labelWithText(0,140+15,text,UI_TOOLTIPS_EQUIP_FONT_SIZE,ALIGN_LEFT);
	-- suit_count:setAnchorPoint(CCPointMake(0,1));
	suit_panel:addChild(suit_count);

	--套装属性数值
	local suit_dialog = CCDialogEx:dialogWithFile(0, 150,	
											      UI_TOOLTIPS_EQUIP_DIALOG_WIDTH, 250, 
											      10, "", TYPE_VERTICAL ,ADD_LIST_DIR_UP);
	suit_dialog:setAnchorPoint(0,1);
	suit_dialog:setFontSize(UI_TOOLTIPS_EQUIP_FONT_SIZE);
	suit_dialog:setText(suit_equip_name_text);
	suit_panel:addChild(suit_dialog);

	return suit_panel, suit_dialog:getInfoSize().height;
end
]]--