-- MarriageDetailTipView.lua 
-- created by fangjiehua on 2013-8-24

super_class.MarriageDetailTipView(Window)

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

-- 获取所有红心属性
function MarriageDetailTipView:get_all_heart_attrs(  )
	local text = "";
	for i=1,10 do
		-- 每个红心的等级
		local level = self.data.level;
		if i <= self.data.count then
			level = level + 1;
		end
		local type,value ;
		if level ==  0 then
			local heart_config = MarriageConfig:get_little_heart_attr_by_level( i, 1 );	
			type = staticAttriTypeList[heart_config.attri.type];
			value = 0;
		else
			local heart_config = MarriageConfig:get_little_heart_attr_by_level( i, level );	
			type = staticAttriTypeList[heart_config.attri.type];
			value = heart_config.attri.value;
		end
		print("MarriageDetailTipView:get_all_heart_attrs",type,string.len(type))
		local space_str = get_space_str_by_str_len( string.len(type) );

		text = text.."#c00c0ff"..type..space_str.."#cfff000+"..math.abs(value).."#r";
	end
	return text;
end

-- 获取仙缘等级属性
function MarriageDetailTipView:get_xy_level_attrs(  )

	if self.data.level == 0 then
		local xy_config = MarriageConfig:get_XY_attr_by_level( 1 );
		
		local str = ""
		for i,v in ipairs(xy_config) do
			local type = staticAttriTypeList[v.type]
			local space_str = get_space_str_by_str_len( string.len(type) );
			str = str.."#c00c0ff"..type..space_str.."#cfff000+0#r";
		end
		return str;
	else
		local level = self.data.level;
		if self.data.level == 8 and self.data.count then
			level = 9;
		end
		local xy_config = MarriageConfig:get_XY_attr_by_level( level );
		
		local str = "";
		for i,v in ipairs(xy_config) do
			local type = staticAttriTypeList[v.type]
			local space_str = get_space_str_by_str_len( string.len(type) );
			str = str.."#c00c0ff"..type..space_str.."#cfff000+"..v.value.."#r";
		end
		return str;
	end

end

function MarriageDetailTipView:__init(  )
	
	-- local bg = MUtils:create_zximg(self.view, UIResourcePath.FileLocate.marriage.."tip_bg.png",0, 0, 190, 350);

	-- local img_1 = MUtils:create_zximg(self.view, UIResourcePath.FileLocate.marriage.."lab_img_2.png",10,390-40-7,88,24);
	MUtils:create_zxfont(self.view,Lang.marriage[11],210/2,327,2,18);

	--每个红心加成属性的总成
	local attrs_dialog = CCDialogEx:dialogWithFile(7, 320,250, 100, 10, "", TYPE_VERTICAL ,ADD_LIST_DIR_UP);
	attrs_dialog:setAnchorPoint(0,1);
	attrs_dialog:setFontSize(14);

	local all_attrs_desc = self:get_all_heart_attrs();

	attrs_dialog:setText(all_attrs_desc);
	self.view:addChild(attrs_dialog);

	-- 分割线
	local split_img = CCZXImage:imageWithFile(5, 115,195,2,UILH_MARRIAGE.split_line_h);
	self.view:addChild(split_img);

	-- local img_2 = MUtils:create_zximg(self.view, UIResourcePath.FileLocate.marriage.."lab_img_1.png",20+10,390-269-7-20,129,24);
	MUtils:create_zxfont(self.view,Lang.marriage[12],210/2,86,2,18);

	local xy_attrs_dialog = CCDialogEx:dialogWithFile(7, 75,250, 100, 10, "", TYPE_VERTICAL ,ADD_LIST_DIR_UP);
	xy_attrs_dialog:setAnchorPoint(0,1);
	xy_attrs_dialog:setFontSize(14);
	local all_attrs_desc = self:get_xy_level_attrs();
	xy_attrs_dialog:setText(all_attrs_desc);
	self.view:addChild(xy_attrs_dialog);
	
end

function MarriageDetailTipView:create( data )
	
	self.data = data;
	local temp_info = { texture = "", x = 0, y = 0, width = 230, height = 390 }
	return MarriageDetailTipView("XYDetailTip", "", true, 210, 350);

end