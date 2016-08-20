-- StoneTipView.lua 
-- createed by fangjiehua on 2013-3-27

super_class.StoneTipView(Window)

-- 获取 加成属性文本
local function get_stone_attri_by_stone_value(is_next, stone_value, job)
 
	local min_lv = EquipEnhanceConfig:get_stoneLevels_min_level();
	
	local is_active = true;
	local color = "#c38ff33";
	local stone_value_ = stone_value;
	if stone_value < min_lv then
		is_active = false;
		color = "#ca7a7a6";
		if is_next then
			stone_value_ = 120;
		else
			stone_value_ = 100;
		end 
	end 

	if is_active and is_next then 
		stone_value_ = stone_value_ + 20;
	end

	if is_next then
		-- 如果是下一级的属性则全为灰色
		color = "#ca7a7a6";
	end


	local base_level, effectName, attris = EquipEnhanceConfig:get_stoneLevels_by_level( stone_value_, job )
	
	local text = LangGameString[2018]..stone_value.."/"..base_level..")#r"; -- [2018]="#cffcc00全身宝石级别("
	 
	for k,v in pairs(attris) do
		print("宝石加成的属性",k,v)
		local type = staticAttriTypeList[k];
		local value = tonumber(v) * 100;
		text = text..color..type.." +"..value.."%#r";
	end

	text = text..effectName;

	return text;
end

function StoneTipView:__init(  )
	
	local job, stone_level;
 	if self.data == nil then
		job = EntityManager:get_player_avatar().job;
		 
		stone_level = UserInfoModel:check_body_gem_all_level()
	else
		stone_level = self.data[1];
		job = self.data[2];
		
	end
    local text = get_stone_attri_by_stone_value(false, stone_level, job);

    local contentHeight = 20+320;
	if stone_level >= EquipEnhanceConfig:get_stoneLevels_max_level() then 
		contentHeight = 190+20;
	end
	self.view:setSize(280,contentHeight);

  	local attri_lab = CCDialogEx:dialogWithFile(20, contentHeight-17,250, 100, 10, "", TYPE_VERTICAL ,ADD_LIST_DIR_UP);
	attri_lab:setAnchorPoint(0,1);
	attri_lab:setFontSize(16);
	attri_lab:setText(text);
	self.view:addChild(attri_lab); 

	-- 下一级
 
	local next_lab_height = 0;
	if stone_level < EquipEnhanceConfig:get_stoneLevels_max_level() then 
		 
		local lab = UILabel:create_lable_2( LangGameString[2019], 20, contentHeight-150, 16, ALIGN_LEFT ); -- [2019]="#c00c0ff下一级:"
		self:addChild(lab);

		text = get_stone_attri_by_stone_value(true, stone_level, job);

		local next_attri_lab = CCDialogEx:dialogWithFile(20, contentHeight-154,250, 100, 10, "", TYPE_VERTICAL ,ADD_LIST_DIR_UP);
		next_attri_lab:setAnchorPoint(0,1);
		next_attri_lab:setFontSize(16);
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
	desc:setText(LangGameString[2020]); -- [2020]="#c9be2d9可在炼器的镶嵌界面选取相应的宝石对装备进行镶嵌。"
	self.view:addChild(desc);

end

function StoneTipView:create( data )
	self.data = data;
	local temp_info = { texture ="", x = 0, y = 0, width = 280, height = 320 }
	return StoneTipView("stoneTip", "", true, 280, 320);

end
