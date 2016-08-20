-- AoYiAttrBtnPage.lua 
-- createed by yongrui.liang on 2014-7-22
-- 变身按钮页

super_class.AoYiAttrBtnPage(  )

function AoYiAttrBtnPage:__init( )
	-- 底板
    self.view = ZBasePanel.new(UIPIC_GRID_nine_grid_bg3, 340, 565).view
	local panel = self.view

	self:create_top_panel(panel)
	self:create_dwn_panel(panel)
	self:create_mid_panel(panel)
end

function AoYiAttrBtnPage:create_top_panel( parent )
	self.aoyi_item = MUtils:create_one_slotItem( nil, 40, 485, 64, 64 )
    local function tip_func(  )
	    TipsModel:show_shop_tip( 250, 400, self.aoyi_item.need_id )
    end
    self.aoyi_item:set_click_event(tip_func)
 	self.aoyi_item:set_icon(nil)
 	self.aoyi_item:set_icon_dead_color()
    parent:addChild(self.aoyi_item.view)
end

function AoYiAttrBtnPage:update_top_panel( )
	local aoyi = TransformModel:get_current_selected_aoyi( )
    self.aoyi_item.need_id = TransformConfig:get_need_miji_id(aoyi)
	self.aoyi_item:set_icon(self.aoyi_item.need_id)
end

function AoYiAttrBtnPage:create_mid_panel( parent )
	local panel = ZBasePanel.new("", 320, 134).view
    panel:setPosition(10, 340)
    parent:addChild(panel)

    local titleBg = ZImage.new("ui/common/wzd-1.png").view
    titleBg:setPosition(1, 102)
    panel:addChild(titleBg)

    local title = ZImage.new("ui/transform/new32.png").view
    title:setPosition(24, 2)
    titleBg:addChild(title)

    self.cur_skill_desc = ZDialog:create( panel, "", 5, 60+40, 310, 40, 15 )
    self.cur_skill_desc:setAnchorPoint(0, 1)
    self.cur_skill_desc.view:setLineEmptySpace(2)

    self.next_skill_desc = ZDialog:create( panel, "", 5, 55, 310, 40, 15 )
    self.next_skill_desc:setAnchorPoint(0, 1)
    self.next_skill_desc.view:setLineEmptySpace(2)
end

function AoYiAttrBtnPage:update_mid_panel( )
	local aoyi = TransformModel:get_current_selected_aoyi( )

	local desc = TransformConfig:get_miji_skill_desc_by_id( aoyi )
	local lv = TransformModel:get_miji_level_by_id( aoyi )
	local cur_skill_val = TransformConfig:get_miji_defvalue( aoyi, lv)
	local next_skill_val = TransformConfig:get_miji_defvalue( aoyi, lv+1)

	desc = "%s" .. desc
	if cur_skill_val then
		self.cur_skill_desc:setText(string.format(desc, "#c00ff00本阶效果：#cffffff", cur_skill_val/100))
	else
		self.cur_skill_desc:setText("")
	end

	if next_skill_val then
		self.next_skill_desc:setText(string.format(desc, "#c00ff00下阶效果：#cffffff", next_skill_val/100))
	else
		self.next_skill_desc:setText("")
	end
end

function AoYiAttrBtnPage:create_dwn_panel( parent )
	local panel = ZBasePanel.new("", 320, 325).view
    panel:setPosition(10, 10)
    parent:addChild(panel)

    local titleBg = ZImage.new("ui/common/wzd-1.png").view
    titleBg:setPosition(1, 293)
    panel:addChild(titleBg)

    local title = ZImage.new("ui/transform/new33.png").view
    title:setPosition(24, 2)
    titleBg:addChild(title)

    local rowBg = ZImage:create(nil, "ui/common/ht_bg.png", 0, 252, 320, 39, 0, 500, 500).view
    panel:addChild(rowBg)

    local cur_lv_txt = ZLabel.new("#cfff000本阶")
    cur_lv_txt:setFontSize(16)
    cur_lv_txt:setPosition(130, 14)
    rowBg:addChild(cur_lv_txt.view)

    local next_lv_txt = ZLabel.new("#cfff000下阶")
    next_lv_txt:setFontSize(16)
    next_lv_txt:setPosition(240, 14)
    rowBg:addChild(next_lv_txt.view)

    -- 属性
    local attr_t = {
        "生    命：",
        "暴    击：",
        "物理防御：",
        "抗 暴 击：",
        "精神防御：",
        "命    中：",
        "闪    避：",
        "攻    击："
    }
    local font_size = 16
    local offset_y = 32
    local start_x = 15
    local start_x2 = 130
    local start_y = 232
    local start_x3 = 240
    -- 保存属性值label
    self.attr_val_t = {}
    self.next_attr_val_t = {}

    for i,v in ipairs(attr_t) do
        local attr_name = ZLabel.new(v)
        attr_name:setFontSize(font_size)
        attr_name:setPosition(start_x, start_y - offset_y*(i-1))
        panel:addChild(attr_name.view)

        local attr_val = ZLabel.new("#cfff000500000")
        attr_val:setFontSize(font_size)
        attr_val:setPosition(start_x2, start_y - offset_y*(i-1))
        panel:addChild(attr_val.view)
        self.attr_val_t[i] = attr_val

        local next_attr_val = ZLabel.new("#c00ff00+500000")
        next_attr_val:setFontSize(font_size)
        next_attr_val:setPosition(start_x3, start_y - offset_y*(i-1))
        panel:addChild(next_attr_val.view)
        self.next_attr_val_t[i] = next_attr_val

        ZImage:create(panel, "ui/common/jgt_line.png", 10, start_y - offset_y*(i-1)-7, 300, 2)
    end
end

function AoYiAttrBtnPage:update_dwn_panel( )
	-- 更新加成属性
	local miji_id = TransformModel:get_current_selected_aoyi( )
	local miji_level = TransformModel:get_miji_level_by_id( miji_id )
 	local attr_t = TransformConfig:get_miji_attrs( miji_id, miji_level)
 	local next_attr_t = TransformConfig:get_miji_attrs( miji_id, miji_level)
 	if not TransformModel:check_aoyi_max_level( miji_id ) then
 		next_attr_t = TransformConfig:get_miji_attrs( miji_id, miji_level+1)
 	end

 	local val_t = {
 		{attr_t.lift, next_attr_t.lift-attr_t.lift},
 		{attr_t.crit, next_attr_t.crit-attr_t.crit},
 		{attr_t.wdef, next_attr_t.wdef-attr_t.wdef},
 		{attr_t.rcrit, next_attr_t.rcrit-attr_t.rcrit},
 		{attr_t.mdef, next_attr_t.mdef-attr_t.mdef},
 		{attr_t.focus, next_attr_t.focus-attr_t.focus},
 		{attr_t.dodge, next_attr_t.dodge-attr_t.dodge},
 		{attr_t.attack, next_attr_t.attack-attr_t.attack},
 	}
 	for i,v in ipairs(self.attr_val_t) do
        self.attr_val_t[i]:setText(string.format("%s%d", "#cfff000", val_t[i][1] or 0))
        self.next_attr_val_t[i]:setText(string.format("%s%d", "#c00ff00+", val_t[i][2] or 0))
    end

end

function AoYiAttrBtnPage:update( update_type )
	if update_type == "all" then
		self:update_top_panel()
		self:update_mid_panel()
		self:update_dwn_panel()
	end
end


