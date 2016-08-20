-- MarriageXYTipView.lua 
-- createed by fangjiehua on 2013-8-24

super_class.MarriageXYTipView(Window)

-- 统一取空格间隔的长度
local function get_space_str_by_str_len( str_len )
	local space_str = "";
	if str_len <= 6 then	-- 俩个字符
		space_str = "        "
	elseif str_len < 12 and str_len > 6 then--三个字符
		space_str = "      "
	elseif str_len >= 12 then--四个字符
		space_str = "    "
	end
	return space_str;
end

-- 获取仙缘属性
function MarriageXYTipView:get_XY_attrs( is_next, level )
	if not is_next then
		if level == 0 then
			local xy_config = MarriageConfig:get_XY_attr_by_level( 1 );
			
			local str = LangGameString[1993] -- [1993]="需要#cfff000仙缘0重"
			for i,v in ipairs(xy_config) do
				local type = staticAttriTypeList[v.type]
				local space_str = get_space_str_by_str_len( string.len(type) );
				str = str.."#r#ca7a7a6"..type..space_str.."+"..v.value;
			end
			return str;
		else
			local xy_config = MarriageConfig:get_XY_attr_by_level( level );
			
			local str = LangGameString[1994]..level..LangGameString[1995]; -- [1994]="需要#cfff000仙缘" -- [1995]="重"
			for i,v in ipairs(xy_config) do
				
				local type = staticAttriTypeList[v.type]
				print("仙缘属性", type, v.type, v.value);
				local space_str = get_space_str_by_str_len( string.len(type) );
				str = str.."#r"..type..space_str.."+"..v.value;
			end
			return str;
		end
	else
		if level < 9 then
			level = level + 1;
		end

		local xy_config = MarriageConfig:get_XY_attr_by_level( level );
		local str = LangGameString[1994]..level..LangGameString[1995] -- [1994]="需要#cfff000仙缘" -- [1995]="重"
		for i,v in ipairs(xy_config) do
			local type = staticAttriTypeList[v.type]
			local space_str = get_space_str_by_str_len( string.len(type) );
			str = str.."#r"..type..space_str.."+"..v.value;
		end
		return str;

	end
end


function MarriageXYTipView:__init(  )
	
	-- 当前仙缘等级名称
	local level = 0;
	if self.data.level == 8 and self.data.count == 10 then
		level = 9;
	else
		level = self.data.level;
	end
	local name = MarriageConfig:get_XY_name_by_level( level );
	local xy_name_lab = UILabel:create_lable_2( "#c36ff33"..name..LangGameString[1996], 10, 260-35, 16, ALIGN_LEFT ); -- [1996]=" #cffffff(当前阶段)"
	self.view:addChild( xy_name_lab );

	--仙缘属性
	local xy_attrs_dialog = CCDialogEx:dialogWithFile(10, 260-40,260, 100, 10, "", TYPE_VERTICAL ,ADD_LIST_DIR_UP);
	xy_attrs_dialog:setAnchorPoint(0,1);
	xy_attrs_dialog:setFontSize(15);

	-- 当前等级的
	
	local attr_desc = self:get_XY_attrs( false, level );

	xy_attrs_dialog:setText( attr_desc );
	self.view:addChild(xy_attrs_dialog);

	-- 分割线
	local split_img = CCZXImage:imageWithFile(4, 260-130,210,3,UILH_COMMON.split_line);
	self.view:addChild(split_img);

	-- 下级仙缘等级名称
	local level = self.data.level;
	if self.data.level < 9 then
		level = level + 1;
	end
	local name = MarriageConfig:get_XY_name_by_level( level );
	local xy_name_lab = UILabel:create_lable_2( "#c00c0ff"..name..LangGameString[1997], 10, 260-35-119, 16, ALIGN_LEFT ); -- [1997]=" #cffffff(下一阶段)"
	self.view:addChild( xy_name_lab );

	--下级仙缘属性
	local xy_attrs_dialog = CCDialogEx:dialogWithFile(10, 260-40-119,260, 100, 10, "", TYPE_VERTICAL ,ADD_LIST_DIR_UP);
	xy_attrs_dialog:setAnchorPoint(0,1);
	xy_attrs_dialog:setFontSize(15);

	local attr_desc = self:get_XY_attrs( true, self.data.level );

	xy_attrs_dialog:setText(attr_desc);
	self.view:addChild(xy_attrs_dialog);

end

function MarriageXYTipView:create( data )
	self.data = data;
	local temp_info = { texture = "", x = 0, y = 0, width = 215, height = 260 }
	return MarriageXYTipView("XYTip", "", true, 215, 260);
end
