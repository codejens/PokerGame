-- ShenShouCifuTipView.lua 
-- createed by liuguowang on 2014-2-14

super_class.ShenShouCifuTipView(Window)


function get_desc( buff_type, value )
    --print("---------------------------buff_type---------------------",buff_type,value);
    local buff_str = BuffConfig:get_buff_desc_by_buff_id( buff_type )
    value = math.abs(value)
    --print(buff_str);
    local inc_str = UserBuffPanel:getIncText( buff_type, value)
    buff_str = string.gsub( buff_str,"#inc#",inc_str );
    --print(buff_str); 
    buff_str = string.gsub( buff_str,"<BR>"," " );
    --print(buff_str);
    -- 小于1的数字都变成百分比形式
    if ( value < 1 ) then
        value = math.floor( value * 100 ) .. "%%";
    end
    buff_str = string.gsub( buff_str,"#value#",value );
    --print(buff_str);
    return buff_str;
end

-- 获取 加成属性文本
local function get_shenshou_attri_by_shenshou_value( shenshou_level)
 
	-- local min_lv = EquipEnhanceConfig:get_shenshouLevels_min_level();
	
	-- local is_active = true;
	-- local color = "#c38ff33";
	-- local shenshou_value_ = shenshou_level;
	-- if shenshou_level < min_lv then
	-- 	is_active = false;
	-- 	color = "#ca7a7a6";
	-- 	if is_next then
	-- 		shenshou_value_ = 120;
	-- 	else
	-- 		shenshou_value_ = 100;
	-- 	end 
	-- end 

	-- if is_active and is_next then 
	-- 	shenshou_value_ = shenshou_value_ + 20;
	-- end

	-- if is_next then
	-- 	-- 如果是下一级的属性则全为灰色
	-- 	color = "#ca7a7a6";
	-- end


	-- local base_level, effectName, attris = EquipEnhanceConfig:get_shenshouLevels_by_level( shenshou_value_, job )
	
	local pet_level_info = GuildConfig:get_pet_index_info( shenshou_level )
	local text = Lang.guild.guild_altar_info.shen_shou_luck .. "(" .. shenshou_level ..")" .."#r"; 

		-- local temp_info = ""
	for i = 1, #pet_level_info.attrs do
		local temp_buf_info = get_desc( pet_level_info.attrs[i].type, pet_level_info.attrs[i].value )
		text = string.format( "%s#r%s", text, temp_buf_info )
	end
	-- self.notic_info.view:setText( text )
	-- for k,v in pairs(attris) do
	-- 	print("宝石加成的属性",k,v)
	-- 	local type = staticAttriTypeList[k];
	-- 	local value = tonumber(v) * 100;
	-- 	text = text..color..type.." +"..value.."%#r";
	-- end

	-- text = text..effectName;

	return text;
end


function ShenShouCifuTipView:__init(  )
	
	local job, shenshou_level;
 	if self.data == nil then  --自己的
		-- job = EntityManager:get_player_avatar().job;
		shenshou_level = GuildModel:get_guild_altar_page_info().pet_level

		-- shenshou_level = UserInfoModel:check_body_gem_all_level()
	else  --他人的
		shenshou_level = self.data[1];
		-- job = self.data[2];
		
	end
    local text = get_shenshou_attri_by_shenshou_value( shenshou_level);

    local contentHeight = 210-45;

	self.view:setSize(280,contentHeight);

  	local attri_lab = CCDialogEx:dialogWithFile(20, contentHeight-17,250, 100, 10, "", TYPE_VERTICAL ,ADD_LIST_DIR_UP);
	attri_lab:setAnchorPoint(0,1);
	attri_lab:setFontSize(16);
	attri_lab:setText(text);
	self.view:addChild(attri_lab); 
	
	--没写下一级

	-- 分割线
	local split_img = CCZXImage:imageWithFile(4,contentHeight-139+45,280,2,UIResourcePath.FileLocate.common .. "fenge_bg.png");
	self.view:addChild(split_img);

	--描述
	local desc = CCDialogEx:dialogWithFile(20, contentHeight-143+45,250, 100, 10, "", TYPE_VERTICAL ,ADD_LIST_DIR_UP);
	desc:setAnchorPoint(0,1);
	desc:setFontSize(16);
	desc:setText(LangGameString[2314]); -- [2314]="可通过献果提升神兽等级，神兽等级越高，神兽赐福效果越好。",
	self.view:addChild(desc);

end

function ShenShouCifuTipView:create( data )
	self.data = data;
	local temp_info = { texture ="", x = 0, y = 0, width = 280, height = 320 }
	return ShenShouCifuTipView("shenshouTip", "", true, 280, 320);

end
