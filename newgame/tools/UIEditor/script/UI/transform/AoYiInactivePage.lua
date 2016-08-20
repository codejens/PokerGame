-- AoYiInactivePage.lua 
-- createed by yongrui.liang on 2014-7-22
-- 激活奥义页

super_class.AoYiInactivePage( )

local _ui_width = GameScreenConfig.ui_screen_width 
local _ui_height = GameScreenConfig.ui_screen_height

function AoYiInactivePage:__init( )
	-- 底板
    self.view = ZBasePanel.new(UIPIC_GRID_nine_grid_bg3, 340+53, 565).view
	local panel = self.view

	self:create_top_panel(panel)
	self:create_dwn_panel(panel)
	self:create_desc_panel(panel)
	self:create_attr_panel(panel)
	self:create_cost_panel(panel)
end

function AoYiInactivePage:create_top_panel( parent )
	self.aoyi_item = MUtils:create_one_slotItem( nil, 40, 485, 64, 64 )
    local function tip_func(  )
	    -- TipsModel:show_shop_tip( 250, 400, self.aoyi_item.need_id )
    end
    self.aoyi_item:set_click_event(tip_func)
 	self.aoyi_item:set_icon(nil)
 	self.aoyi_item:set_icon_dead_color()
    parent:addChild(self.aoyi_item.view)

    self.aoyi_name = ZLabel.new("心灵奥义")
    self.aoyi_name:setFontSize(18)
    self.aoyi_name:setPosition(120, 528)
    parent:addChild(self.aoyi_name.view)

    ZImage:create(parent, "ui/transform/new24.png", 110, 484, -1, -1, 0, 500, 500)

    self.active_need = ZLabel.new(string.format("%s%s%s", "#cffffff激活需要", "#c00ff00", "道具名字"))
    self.active_need:setFontSize(15)
    self.active_need:setPosition(135, 492)
    parent:addChild(self.active_need.view)
end

function AoYiInactivePage:update_top_panel( )
	local aoyi = TransformModel:get_current_selected_aoyi( )
    self.aoyi_item.need_id = TransformConfig:get_need_miji_id(aoyi)
	self.aoyi_item:set_icon(self.aoyi_item.need_id)

    local info = TransformConfig:get_miji_info_by_id( aoyi )
    if not info then
        info = {name = ""}
    end
    self.aoyi_name:setText(string.format("%s%s", "#cfff000", info.name or ""))

    local need_id = TransformConfig:get_need_miji_id(aoyi)
    local name = ItemConfig:get_item_name_by_item_id(need_id)
    self.active_need:setText(string.format("%s%s%s", "#cffffff激活需要", "#c00ff00", name))
end

function AoYiInactivePage:create_dwn_panel( parent )
    local size = parent:getSize()

	-- 激活
    local function btn_up_fun1( )
    	local auto_buy = self._is_switch_select
    	local id = TransformModel:get_current_selected_aoyi( )
        local need_id = TransformConfig:get_need_miji_id(id)
        local count = ItemModel:get_item_count_by_id(need_id)
        if count > 0 then
            ItemModel:use_item_by_item_id( need_id )
        else
            GlobalFunc:create_screen_notic( "缺少激活物品，不能激活奥义", 16, _ui_width/2, _ui_height/2, 2)
            return
        end
    end
    --xiehande 通用按钮  btn_hong.png ->button3
    self.active_btn = ZTextButton.new("ui/common/button3.png", nil, nil, "激  活")
    self.active_btn.view:setAnchorPoint(0.5, 0)
    self.active_btn.view:setPosition(size.width/2, 20)
    self.active_btn:setTouchClickFun(btn_up_fun1)
    parent:addChild(self.active_btn.view)
end

function AoYiInactivePage:create_desc_panel( parent )
	local panel = ZBasePanel.new("", 373, 102).view
    panel:setPosition(10, 372)
    parent:addChild(panel)

    local titleBg = ZImage.new("ui/common/wzd-1.png").view
    titleBg:setPosition(1, 70)
    panel:addChild(titleBg)

    local title = ZImage.new("ui/transform/new34.png").view
    title:setPosition(24, 2)
    titleBg:addChild(title)

    self.aoyi_desc = ZDialog:create( panel, "", 5, 68, 363, 60, 15 )
    self.aoyi_desc:setAnchorPoint(0, 1)
    self.aoyi_desc.view:setLineEmptySpace(2)
end

function AoYiInactivePage:update_desc_panel( )
    local aoyi = TransformModel:get_current_selected_aoyi( )

    local desc = TransformConfig:get_miji_effect(aoyi)
    self.aoyi_desc:setText(string.format("%s%s", "#c00ff00满级效果：#cffffff", desc or ""))
end

function AoYiInactivePage:create_attr_panel( parent )
	local panel = ZBasePanel.new("", 373, 152).view
    panel:setPosition(10, 218)
    parent:addChild(panel)

    local titleBg = ZImage.new("ui/common/wzd-1.png").view
    titleBg:setPosition(1, 120)
    panel:addChild(titleBg)

    local title = ZImage.new("ui/transform/new35.png").view
    title:setPosition(24, 2)
    titleBg:addChild(title)

    -- 属性
    local attr_t = {
        {"#c00ff00生    命：",
                "#c00ff00暴    击：",},
        {"#c00ff00物理防御：",
                "#c00ff00抗 暴 击：",},
        {"#c00ff00精神防御：",
                "#c00ff00命    中：",},
        {"#c00ff00闪    避：",
                "#c00ff00攻    击：",},
    }
    local font_size = 16
    local offset_y = 30
    local start_x, start_x2 = 15, 110
    local start_y = 100
    local start_x3, start_x4 = 200, 295
    -- 保存属性值label
    self.attr_val_t = {}

    for i,v in ipairs(attr_t) do
        local attr_name = ZLabel.new(v[1])
        attr_name:setFontSize(font_size)
        attr_name:setPosition(start_x, start_y - offset_y*(i-1))
        panel:addChild(attr_name.view)

        local attr_val = ZLabel.new("")
        attr_val:setFontSize(font_size)
        attr_val:setPosition(start_x2, start_y - offset_y*(i-1))
        panel:addChild(attr_val.view)
        self.attr_val_t[i*2-1] = attr_val
    end

    for i,v in ipairs(attr_t) do
        local attr_name = ZLabel.new(v[2])
        attr_name:setFontSize(font_size)
        attr_name:setPosition(start_x3, start_y - offset_y*(i-1))
        panel:addChild(attr_name.view)

        local attr_val = ZLabel.new("")
        attr_val:setFontSize(font_size)
        attr_val:setPosition(start_x4, start_y - offset_y*(i-1))
        panel:addChild(attr_val.view)
        self.attr_val_t[i*2] = attr_val
    end
end

function AoYiInactivePage:update_attr_panel( )
    local miji_id = TransformModel:get_current_selected_aoyi( )
    local miji_level = 10
    local attr_t = TransformConfig:get_miji_attrs( miji_id, miji_level)
    local val_t ={ attr_t.lift, attr_t.crit, attr_t.wdef, attr_t.rcrit, attr_t.mdef, attr_t.focus, attr_t.dodge, attr_t.attack}
    for i,v in ipairs(self.attr_val_t) do
        self.attr_val_t[i]:setText(string.format("%s%d", "", val_t[i] or 0))
    end
end

function AoYiInactivePage:create_cost_panel( parent )
	local panel = ZBasePanel.new("", 373, 122).view
    panel:setPosition(10, 94)
    parent:addChild(panel)

    local size = panel:getSize()

    local titleBg = ZImage.new("ui/common/wzd-1.png").view
    titleBg:setPosition(1, 90)
    panel:addChild(titleBg)

    local title = ZImage.new("ui/transform/new36.png").view
    title:setPosition(24, 2)
    titleBg:addChild(title)

    self.need_item = MUtils:create_one_slotItem( nil, 25, 14, 64, 64 )
    local function tip_func(  )
        TipsModel:show_shop_tip( 400, 240, self.need_item.item_id )
    end
    self.need_item:set_click_event(tip_func)
    panel:addChild(self.need_item.view)

    self.need_item_name = ZLabel.new("")
    self.need_item_name:setFontSize(16)
    self.need_item_name:setPosition(100, 38)
    panel:addChild(self.need_item_name.view)

    local function btn_up_fun1( )
        local aoyi = TransformModel:get_current_selected_aoyi( )
        local str = TransformConfig:get_miji_source(aoyi)
        ConfirmWin2:show( 3, 0, str, yes_but_func, swith_but_func, title_type )
    end
    --xiehande btn_lang2 ->button2
    local get_btn = ZTextButton.new("ui/common/button2.png", nil, nil, "获得")
    get_btn.view:setAnchorPoint(1, 0)
    get_btn.view:setPosition(size.width-25, 16)
    get_btn:setTouchClickFun(btn_up_fun1)
    panel:addChild(get_btn.view)
end

function AoYiInactivePage:update_cost_panel( )
    local aoyi = TransformModel:get_current_selected_aoyi( )
    self.need_item.item_id = TransformConfig:get_need_miji_id(aoyi)
    self.need_item:set_icon(self.need_item.item_id)

    local count = ItemModel:get_item_count_by_id(self.need_item.item_id)
    if count == 0 then
        self.need_item:set_icon_dead_color()
    else
        self.need_item:set_icon_light_color()
    end
    self.need_item:set_item_count(count)

    local name = ItemConfig:get_item_name_by_item_id(self.need_item.item_id)
    self.need_item_name:setText(name)
end

function AoYiInactivePage:update( update_type )
	if update_type == "all" then
		self:update_top_panel()
        self:update_desc_panel()
        self:update_attr_panel()
        self:update_cost_panel()
	end
end


