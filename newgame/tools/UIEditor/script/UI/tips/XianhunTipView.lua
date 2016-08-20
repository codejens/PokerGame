-- XianhunTipView.lua 
-- createed by fangjiehua on 2013-6-2
-- XianhunTipView 面板

super_class.XianhunTipView(Window)


function XianhunTipView:__init(  )
	
	-- icon
	local icon_bg = CCZXImage:imageWithFile(20,165,81,81,UIPIC_ITEMSLOT);
	icon_bg:setAnchorPoint(0,1);
	self.view:addChild(icon_bg);


	local icon = CCZXImage:imageWithFile(81/2,81/2,64,64,FabaoConfig:get_xianhun_icon( self.data ));
	icon:setAnchorPoint(0.5,0.5);
	icon_bg:addChild(icon);

	-- local itemSlot = ElfinEquipItem()
	-- itemSlot:setOpenStatus(true)
	-- itemSlot:setIndex(self.data.itemIndex)
	-- itemSlot:setIcon(self.data.itemType)
	-- itemSlot:setQuality(self.data.itemQlty)
	-- itemSlot.view:setPosition(20, 96)
	-- self.view:addChild(itemSlot.view)
    --式神的代码
	-- local isEquip = ElfinConfig:getEquipmentCanEquipByType(self.data.itemType)
	-- if isEquip then
	-- 	local color = ItemConfig:get_item_color(self.data.itemQlty)
	-- 	local name = ElfinConfig:getEquipNameByType(self.data.itemType)
	-- 	local level = self.data.itemLevel
	-- 	ZLabel:create(self.view, string.format("#c%s%s #ce519cb+%d", color, name, level), 100, 130, 18, ALIGN_LEFT)

	-- 	local smelt = ElfinConfig:getEquipSmeltByLevel(self.data.itemType, self.data.itemQlty, level)
	-- 	ZLabel:create(self.view, string.format("熔炼值：#cfff000%d", smelt), 100, 85, 16, ALIGN_LEFT)

	-- 	local attrName = ElfinConfig:getEquipAttrName(self.data.itemType)
	-- 	local attrVal = self.data.itemBaseVal
	-- 	local nexAttrVal = ElfinConfig:getEquipAttrVal(self.data.itemType, self.data.itemQlty, level)
	-- 	ZLabel:create(self.view, string.format("属性：#cfff000%s #ce519cb%d+%d", attrName, attrVal, nexAttrVal), 100, 50, 16, ALIGN_LEFT)
	-- else
	-- 	local color = ItemConfig:get_item_color(self.data.itemQlty)
	-- 	local name = ElfinConfig:getEquipNameByType(self.data.itemType)
	-- 	ZLabel:create(self.view, string.format("#c%s%s #ce519cb", color, name), 100, 130, 18, ALIGN_LEFT)

	-- 	local des = ElfinConfig:getEquipDesByType(self.data.itemType)
	-- 	local dialog = ZDialog:create(self.view, des, 100, 115, 260, 90, 16)
	-- 	dialog.view:setAnchorPoint(0, 1)
	-- end
    --法宝 灵器 代码
	local name_color = FabaoConfig:get_xianhun_color_by_quality( self.data.quality );
	local xianhun_config = FabaoConfig:get_xianhun( self.data.quality, self.data.type, self.data.level );

	local xianhun_name = UILabel:create_lable_2( name_color..xianhun_config.name, 110, 180-50, 16, ALIGN_LEFT );
	self.view:addChild( xianhun_name );

	local xianhun_lv = UILabel:create_lable_2( name_color..self.data.level..LangGameString[1136], 110, 180-77, 15, ALIGN_LEFT ); -- [1136]="级"
	self.view:addChild(xianhun_lv);

	local xianhun_exp = UILabel:create_lable_2(LangGameString[2050]..self.data.value.."/"..xianhun_config.upExp, 25, 60, 15, ALIGN_LEFT ); -- [2050]="仙魂灵力:  "
	self.view:addChild(xianhun_exp);

	local split_img = CCZXImage:imageWithFile(4, 43,280,2,UILH_COMMON.split_line);
	self.view:addChild(split_img);

	local attri_str;
	
	if self.data.quality == 1 then
		attri_str = LangGameString[2051]; -- [2051]="无属性"
	elseif self.data.quality == 2 then
		attri_str = LangGameString[2052]; -- [2052]="#cff0000蕴含大量灵力"
	else
		attri_str = name_color..staticAttriTypeList[xianhun_config.attrs.type].."  +"..math.abs(xianhun_config.attrs.value);
	end
	
	local xianhun_attri = UILabel:create_lable_2( attri_str, 25, 18, 15, ALIGN_LEFT );
	self.view:addChild(xianhun_attri);
	
end


function XianhunTipView:create( data )
	self.data = data;
	local temp_info = { texture = "", x = 0, y = 0, width = 280, height = 180 }
	return XianhunTipView("xianhunTip", "", true, UI_TOOLTIPS_RECT_WIDTH-50, 180);

end
