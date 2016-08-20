-- TuJianAttrBtnPage.lua 
-- createed by yongrui.liang on 2014-7-22
-- 图鉴属性按钮页

super_class.TuJianAttrBtnPage(  )

function TuJianAttrBtnPage:__init( )
	-- 底板
    self.view = ZBasePanel.new(UIPIC_GRID_nine_grid_bg3, 340, 565).view
	local panel = self.view

	local up_panel = ZBasePanel.new("", 320, 182).view
    up_panel:setPosition(10, 373)
    panel:addChild(up_panel)
    self.up_panel = up_panel

    local dwn_panel = ZBasePanel.new("", 320, 358).view
    dwn_panel:setPosition(10, 10)
    panel:addChild(dwn_panel)

    self:create_up_panel(up_panel)
    self:create_dwn_panel(dwn_panel)
end

function TuJianAttrBtnPage:create_up_panel( parent )
    local size = parent:getSize()

    local titleBg = ZImage.new("ui/common/wzd-1.png").view
    titleBg:setPosition(1, 151)
    parent:addChild(titleBg)

    local title = ZImage.new("ui/transform/new14.png").view
    title:setPosition(24, 2)
    titleBg:addChild(title)

    self.ninja_desc = ZDialog:create( parent, "", 5, 148, 312, 95, 16 )
  	self.ninja_desc:setAnchorPoint(0, 1)
  	self.ninja_desc.view:setLineEmptySpace(2)

  	self.ninja_motto = ZDialog:create( parent, "", 5, 10, 312, 60, 18 )
  	self.ninja_motto:setAnchorPoint(0, 0)
  	self.ninja_motto.view:setLineEmptySpace(5)
end

function TuJianAttrBtnPage:create_dwn_panel( parent )
    local size = parent:getSize()

    local titleBg = ZImage.new("ui/common/wzd-1.png").view
    titleBg:setPosition(1, 326)
    parent:addChild(titleBg)

    local title = ZImage.new("ui/transform/new15.png").view
    title:setPosition(24, 2)
    titleBg:addChild(title)
    -- 属性
    local attr_t = {
        "#c0096ff【精】#cFFFFFF生    命：",
        "#c0096ff【印】#cFFFFFF暴    击：",
        "#c0096ff【忍】#cFFFFFF物理防御：",
        "#c0096ff【体】#cFFFFFF抗 暴 击：",
        "#c0096ff【幻】#cFFFFFF精神防御：",
        "#c0096ff【贤】#cFFFFFF命    中：",
        "#c0096ff【速】#cFFFFFF#cFFFFFF闪    避：",
        "#c0096ff【力】#cFFFFFF攻    击："
    }
    local font_size = 16
    local offset_y = 35
    local start_x = 3
    local start_x2 = 150
    local start_y = 300

    -- 保存属性值label
    self.attr_val_t = {}

    for i,v in ipairs(attr_t) do
        local attr_name = ZLabel.new(v)
        attr_name:setFontSize(font_size)
        attr_name:setPosition(start_x, start_y - offset_y*(i-1))
        parent:addChild(attr_name.view)

        local attr_val = ZLabel.new("#c00ff00500000")
        attr_val:setFontSize(font_size)
        attr_val:setPosition(start_x2, start_y - offset_y*(i-1))
        parent:addChild(attr_val.view)
        self.attr_val_t[i] = attr_val

        ZImage:create(parent, "ui/common/jgt_line.png", 10, start_y - offset_y*(i-1)-7, size.width-20, 2)
    end

    ZLabel:create(parent, "*属性可以通过培养提升", 20, 10, 19, 1, 0)
end

function TuJianAttrBtnPage:update_up_panel( )
    local model_id = TransformModel:get_current_selected_ninja( )
    if not model_id then
        return
    end

    local ninja_desc = TransformConfig:get_ninja_desc_by_id( model_id )
    self.ninja_desc:setText(ninja_desc)

    local ninja_motto = TransformConfig:get_motto_by_id( model_id )
    self.ninja_motto:setText(string.format("%s%s%s", "#cfff000\"", ninja_motto, "\""))
end

function TuJianAttrBtnPage:update_dwn_panel( )
    local model_id = TransformModel:get_current_selected_ninja( )
    if not model_id then
        return
    end
    print("==========TuJianAttrBtnPage:update_dwn_panel: ", model_id)
    local stage = TransformModel:get_transform_stage_by_id(model_id)
    local curr_stage_info = TransformConfig:get_dev_info_by_stage( stage )
    local next_stage_info = TransformConfig:get_dev_info_by_stage( stage+1 )
    local stage_lv = TransformModel:get_transform_stage_level_by_id(model_id)
    for i=1,stage_lv do
        self.attr_val_t[i]:setText("#c00ff00+" .. (next_stage_info and next_stage_info[i].value or curr_stage_info[i].value))
    end
    for i=stage_lv+1,#self.attr_val_t do
        self.attr_val_t[i]:setText("#c00ff00+" .. (curr_stage_info and curr_stage_info[i].value or "0"))
    end
end

function TuJianAttrBtnPage:update(  )
	self:update_up_panel()
	self:update_dwn_panel()
end


