-- StrongTipView.lua 
-- createed by fangjiehua on 2013-3-27

super_class.StrongTipView(Window)


-- 获取 加成属性文本
local function get_strong_attri_by_strong_value(is_next, strong_value, equip_num, job, forward_lv_equip_num)
 	
	local min_lv = EquipEnhanceConfig:get_strongLevels_min_level();
	--加成是否被激活
	print("加成属性文本", is_next, strong_value, min_lv,job,equip_num);
	local attri_active = true;
	if is_next then
		attri_active = false;
		if strong_value < min_lv or forward_lv_equip_num < 10 then
			strong_value = 5;
		else

			strong_value = strong_value+1;	
		end
		
	else

		if strong_value < min_lv or equip_num < 10 then
			attri_active = false; 
			strong_value = min_lv;
		end
		
	end
	
	local attri = EquipEnhanceConfig:get_strongLevels_by_level(strong_value, job);
	local text = LangGameString[2021]..strong_value.."  ("..equip_num.."/10)#r"; -- [2021]="#cffcc00全身强化+"
	 
	local color = "#c38ff33";
	if not attri_active or is_next then
		--如果加成没有被激活，那么颜色为灰色
		color = "#ca7a7a6";
	end

	print("装备属性", #attri, attri)
	for k,v in pairs(attri) do
		local type = staticAttriTypeList[k];
		text = text..color..type.." +"..v.."#r";
	end

	return text,attri_active;
	
end

function StrongTipView:__init(  )
	
	local strong_lv, equip_num, job;
	if self.data == nil then
		strong_lv = UserInfoModel:check_body_strong_all_level();
		equip_num = UserInfoModel:get_equipment_count(strong_lv);
		job = EntityManager:get_player_avatar().job;
	else 
		strong_lv = self.data[1];
		equip_num = self.data[2];
		job = self.data[3];
		
	end

	local contentHeight = 320+20;
	if strong_lv >= EquipEnhanceConfig:get_strongLevels_max_level() then 
		contentHeight = 190+20;
	end
	self.view:setSize(210,contentHeight);

	local attri_lab = CCDialogEx:dialogWithFile(20, contentHeight-18,250, 100, 10, "", TYPE_VERTICAL ,ADD_LIST_DIR_UP);
	attri_lab:setAnchorPoint(0,1);
	attri_lab:setFontSize(16);
	
	local text, curr_is_active = get_strong_attri_by_strong_value(false, strong_lv, equip_num, job);
	

	attri_lab:setText(text);
	self.view:addChild(attri_lab);

	--下一级
	
	local next_lab_height = 0;
	local next_equip_num = 0;
	if strong_lv < EquipEnhanceConfig:get_strongLevels_max_level() then
		-- local equip_num;
		if strong_lv == 0 or not curr_is_active then
			next_equip_num = UserInfoModel:get_equipment_count(5);
		else 
			next_equip_num = UserInfoModel:get_equipment_count(strong_lv+1);
			
		end

		local lab = UILabel:create_lable_2( LangGameString[2019], 20, contentHeight-140-12, 16, ALIGN_LEFT ); -- [2019]="#c00c0ff下一级:"
		self:addChild(lab);
		local next_attri_lab = CCDialogEx:dialogWithFile(20, contentHeight-144-12,250, 100, 10, "", TYPE_VERTICAL ,ADD_LIST_DIR_UP);
		next_attri_lab:setAnchorPoint(0,1);
		next_attri_lab:setFontSize(16);
		local text = get_strong_attri_by_strong_value(true, strong_lv, next_equip_num, job, equip_num);
		next_attri_lab:setText(text);
		self.view:addChild(next_attri_lab);

		next_lab_height = 137;
	end

	-- 分割线
	local split_img = CCZXImage:imageWithFile(10,contentHeight-139-next_lab_height,UI_TOOLTIPS_RECT_WIDTH-30,3,UILH_COMMON.split_line);
	self.view:addChild(split_img);
	--描述
	local desc = CCDialogEx:dialogWithFile(20, contentHeight-143-next_lab_height,UI_TOOLTIPS_RECT_WIDTH-50, 100, 10, "", TYPE_VERTICAL ,ADD_LIST_DIR_UP);
	desc:setAnchorPoint(0,1);
	desc:setFontSize(16);
	desc:setText(LangGameString[2022]); -- [2022]="#c9be2d9可在炼器的强化界面使用相应的强化石对装备进行强化。"
	self.view:addChild(desc);

end


function StrongTipView:create( data )

	self.data = data;
	local temp_info = { texture = "", x = 0, y = 0, width = 210, height = 320 }
	return StrongTipView("strongTip", "", true, 210,320);

end
