-- MarriageHeartTipView.lua 
-- createed by fangjiehua on 2013-8-24
-- 结婚系统情缘界面的红心tip

super_class.MarriageHeartTipView(Window)

-- 获取属性描述
function MarriageHeartTipView:get_attrs_desc( is_next, index, level )
	
	print("获取属性描述", is_next, index, level);

	if not is_next then	
		if level ==  0 then
			local heart_config = MarriageConfig:get_little_heart_attr_by_level( index, 1 );	
			return "#cfff000"..staticAttriTypeList[heart_config.attri.type]..LangGameString[1988]..staticAttriTypeList[heart_config.attri.type].."+0"; -- [1988]="0级#cffffff (当前阶段)#r#c36ff33效果:  #cffffff"
		
		else
			local heart_config = MarriageConfig:get_little_heart_attr_by_level( index, level );	
			return "#cfff000"..staticAttriTypeList[heart_config.attri.type]..level..LangGameString[1989]..staticAttriTypeList[heart_config.attri.type].."+"..math.abs(heart_config.attri.value); -- [1989]="级#cffffff (当前阶段)#r#c36ff33效果:  #cffffff"
		end
	else
		print("下级属性");
		if level < 9 then
			-- 不为满级
			level = level + 1;
		end
		local heart_config = MarriageConfig:get_little_heart_attr_by_level( index, level );	
		return "#cfff000"..staticAttriTypeList[heart_config.attri.type]..level..LangGameString[1990]..staticAttriTypeList[heart_config.attri.type].."+"..math.abs(heart_config.attri.value); -- [1990]="级#cffffff (下一阶段)#r#c36ff33效果:  #cffffff"

	end

end

function MarriageHeartTipView:__init(  )
	
	-- 当前属性
	-- print("当前属性",self.data.index, self.data.level )
	local curr_attr_desc = self:get_attrs_desc( false, self.data.index, self.data.level );

	-- 当前属性
	local curr_dialog = CCDialogEx:dialogWithFile( 20, 170-10, 250, 100, 10, "", TYPE_VERTICAL ,ADD_LIST_DIR_UP);
	curr_dialog:setAnchorPoint(0,1);
	curr_dialog:setFontSize(15);
	curr_dialog:setLineEmptySpace(6)
	curr_dialog:setText( curr_attr_desc );
	self.view:addChild(curr_dialog);

	-- 分割线
	local split_img = CCZXImage:imageWithFile(4,170-75,245,3,UILH_COMMON.split_line);
	self.view:addChild(split_img);

	-- 下级属性
	-- print("下级属性",self.data.index, self.data.level )
	local next_attr_desc = self:get_attrs_desc( true, self.data.index, self.data.level );

	local next_dialog = CCDialogEx:dialogWithFile( 20, 170-75, 250, 100, 10, "", TYPE_VERTICAL ,ADD_LIST_DIR_UP);
	next_dialog:setAnchorPoint(0,1);
	next_dialog:setFontSize(15);
	next_dialog:setLineEmptySpace(6)
	next_dialog:setText( next_attr_desc );
	self.view:addChild(next_dialog);
	
	-- 下级需要亲密度
	local str = "";
	if self.data.level < 9 then
		local level = self.data.level + 1;
		local heart_config = MarriageConfig:get_little_heart_attr_by_level( self.data.index, level );	
		str = "#c36ff33需要:  #cffffff亲密度"..heart_config.expr; -- [1991]="#c36ff33需要:  #cffffff亲密度"
	else
		str = LangGameString[1992]; -- [1992]="#c36ff33需要:  #cffffff亲密度0"
	end

	local need_qm_lab = UILabel:create_lable_2( str, 20, 170-150, 15, ALIGN_LEFT );
	self.view:addChild(need_qm_lab);

end

function MarriageHeartTipView:create( data )
	self.data = data;
	local temp_info = { texture = "", x = 0, y = 0, width = 245, height = 170 }
	return MarriageHeartTipView("HeartTip", "", true, 245, 170);

end
