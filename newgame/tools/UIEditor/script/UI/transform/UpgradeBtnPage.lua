-- UpgradeBtnPage.lua 
-- createed by yongrui.liang on 2014-7-22
-- 进阶按钮页

super_class.UpgradeBtnPage( )

function UpgradeBtnPage:__init( )
	-- 底板
    self.view = ZBasePanel.new(UIPIC_GRID_nine_grid_bg3, 340, 565).view
	local panel = self.view

	self:create_top_panel(panel)
	self:create_dwn_panel(panel)
	self:create_upgrade_panel(panel)
	self:create_cost_panel(panel)
	self:create_wish_panel(panel)
end

function UpgradeBtnPage:create_top_panel( parent )
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

    self.aoyi_level = ZLabel.new(string.format("%s%s%d%s%d", "#cffffff当前进阶数：", "#cfff000", 1, "/", 10))
    self.aoyi_level:setFontSize(15)
    self.aoyi_level:setPosition(135, 492)
    parent:addChild(self.aoyi_level.view)
end

function UpgradeBtnPage:update_top_panel( )
	local aoyi = TransformModel:get_current_selected_aoyi( )
    self.aoyi_item.need_id = TransformConfig:get_need_miji_id(aoyi)
	self.aoyi_item:set_icon(self.aoyi_item.need_id)

	local info = TransformConfig:get_miji_info_by_id( aoyi )
	if not info then
		info = {name = ""}
	end
	self.aoyi_name:setText(string.format("%s%s", "#cfff000", info.name))

	local lv = TransformModel:get_miji_level_by_id( aoyi )
	local mlv = TransformModel:get_aoyi_max_level( )
	self.aoyi_level:setText(string.format("%s%s%d%s%d", "#cffffff当前进阶数：", "#cfff000", lv, "/", mlv))
end

function UpgradeBtnPage:create_dwn_panel( parent )
	-- 进阶
    local function btn_up_fun1( )
    	local auto_buy = self._is_switch_select
    	local id = TransformModel:get_current_selected_aoyi( )
        TransformModel:set_auto_upgrade_skill( false )
        TransformModel:get_miji_level_by_id(id)
        TransformModel:set_current_miji_level( TransformModel:get_miji_level_by_id(id) )
        TransformModel:up_grade_miji( id, auto_buy )
    end
    --xiehande 通用按钮  btn_hong.png ->button3
    self.upgrade_btn = ZTextButton.new("ui/common/button3.png", nil, nil, "进  阶")
    --btn_hui2
    self.upgrade_btn.view:addTexWithFile(CLICK_STATE_DISABLE, "ui/common/button3_d.png")
    self.upgrade_btn.view:setPosition(184, 20)
    self.upgrade_btn:setTouchClickFun(btn_up_fun1)
    parent:addChild(self.upgrade_btn.view)

    -- 一键进阶
    local function btn_up_fun2( )
    	local auto_buy = self._is_switch_select
    	local id = TransformModel:get_current_selected_aoyi( )
        local _miji_info = TransformModel:get_miji_info_by_id(id)
        if _miji_info then
            local skill_level = _miji_info.level
	        TransformModel:set_auto_upgrade_skill( true )
	        TransformModel:set_current_miji_level( skill_level )
	        TransformModel:auto_upgrade( id, auto_buy )
	    end
    end
     --xiehande 通用按钮  btn_hong.png ->button3  btn_lv ->button3
    self.auto_upgrade_btn = ZTextButton.new("ui/common/button3.png", nil, nil, "一键进阶")
    --btn_hui2
    self.auto_upgrade_btn.view:addTexWithFile(CLICK_STATE_DISABLE, "ui/common/button3_d.png")
    self.auto_upgrade_btn.view:setPosition(32, 20)
    self.auto_upgrade_btn:setTouchClickFun(btn_up_fun2)
    parent:addChild(self.auto_upgrade_btn.view)
end

function UpgradeBtnPage:create_upgrade_panel( parent )
	local panel = ZBasePanel.new("", 320, 132).view
    panel:setPosition(10, 342)
    parent:addChild(panel)

    local titleBg = ZImage.new("ui/common/wzd-1.png").view
    titleBg:setPosition(1, 100)
    panel:addChild(titleBg)

    local title = ZImage.new("ui/transform/new31.png").view
    title:setPosition(24, 2)
    titleBg:addChild(title)

    self.cur_aoyi_item = MUtils:create_one_slotItem( nil, 50, 30, 64, 64 )
    local function tip_func(  )
	    -- TipsModel:show_shop_tip( 250, 400, self.cur_aoyi_item.need_id )
    end
    self.cur_aoyi_item:set_click_event(tip_func)
 	self.cur_aoyi_item:set_icon(nil)
 	self.cur_aoyi_item:set_icon_dead_color()
    panel:addChild(self.cur_aoyi_item.view)

    self.cur_aoyi_lv = ZLabel.new("一阶")
    self.cur_aoyi_lv.view:setAnchorPoint(CCPointMake(0.5, 0))
    self.cur_aoyi_lv:setFontSize(16)
    self.cur_aoyi_lv:setPosition(84, 8)
    panel:addChild(self.cur_aoyi_lv.view)

    self.next_lv_panel = ZBasePanel.new(nil, 320, 132).view
    self.next_lv_panel:setPosition(10, 342)
    parent:addChild(self.next_lv_panel)

    ZImage:create(self.next_lv_panel, "ui/lh_forge/force_jt.png", 126, 47, -1, -1, 0)

    self.next_aoyi_item = MUtils:create_one_slotItem( nil, 210, 30, 64, 64 )
    local function tip_func(  )
	    -- TipsModel:show_shop_tip( 250, 400, self.next_aoyi_item.need_id )
    end
    self.next_aoyi_item:set_click_event(tip_func)
 	self.next_aoyi_item:set_icon(nil)
 	self.next_aoyi_item:set_icon_dead_color()
    self.next_lv_panel:addChild(self.next_aoyi_item.view)

    self.next_aoyi_lv = ZLabel.new("二阶")
    self.next_aoyi_lv.view:setAnchorPoint(CCPointMake(0.5, 0))
    self.next_aoyi_lv:setFontSize(16)
    self.next_aoyi_lv:setPosition(244, 8)
    self.next_lv_panel:addChild(self.next_aoyi_lv.view)
end

function UpgradeBtnPage:update_upgrade_panel( )
	local aoyi = TransformModel:get_current_selected_aoyi( )

    self.cur_aoyi_item.need_id = TransformConfig:get_need_miji_id(aoyi)
	self.cur_aoyi_item:set_icon(self.cur_aoyi_item.need_id)

	self.next_aoyi_item.need_id = TransformConfig:get_need_miji_id(aoyi)
	self.next_aoyi_item:set_icon(self.cur_aoyi_item.need_id)

	local mlv = TransformModel:get_aoyi_max_level( )
	local lv = TransformModel:get_miji_level_by_id( aoyi )
	local lv_txt = {"一阶", "二阶", "三阶", "四阶", "五阶", "六阶", "七阶", "八阶", "九阶", "十阶"}
	self.cur_aoyi_lv:setText(lv_txt[lv])
	if lv < mlv then
		self.next_aoyi_lv:setText(lv_txt[lv+1])
        self.next_lv_panel:setIsVisible(true)
        self.cur_aoyi_item.view:setPosition(50, 30)
        self.cur_aoyi_lv:setPosition(84, 8)
	else
		self.cur_aoyi_lv:setText("满阶")
        self.next_lv_panel:setIsVisible(false)
        self.cur_aoyi_item.view:setPosition(125, 30)
        self.cur_aoyi_lv:setPosition(84+75, 8)
	end
end

function UpgradeBtnPage:create_cost_panel( parent )
	local panel = ZBasePanel.new("", 320, 132).view
    panel:setPosition(10, 202)
    parent:addChild(panel)

    local titleBg = ZImage.new("ui/common/wzd-1.png").view
    titleBg:setPosition(1, 100)
    panel:addChild(titleBg)

    local title = ZImage.new("ui/transform/new26.png").view
    title:setPosition(24, 2)
    titleBg:addChild(title)

    self.need_item = MUtils:create_one_slotItem( nil, 15, 20, 64, 64 )
    local function tip_func(  )
	    TipsModel:show_shop_tip( 400, 240, self.need_item.item_id )
    end
    self.need_item:set_click_event(tip_func)
    panel:addChild(self.need_item.view)

    self.needitem_name = ZLabel.new("")
    self.needitem_name:setFontSize(16)
    self.needitem_name:setPosition(105, 68)
    panel:addChild(self.needitem_name.view)

    local function switch_button_func(  )
        self._is_switch_select = not self._is_switch_select
    end
    self.switch_btn = UIButton:create_switch_button( 95, 20, 180, 40, "ui/common/dg-1.png", "ui/common/dg-2.png", "材料不足时自动购买", 43, 16, nil, nil, nil, nil, switch_button_func )
    panel:addChild( self.switch_btn.view )
end

function UpgradeBtnPage:update_cost_panel( )
    local aoyi = TransformModel:get_current_selected_aoyi( )

    local item_id = TransformConfig:get_curr_stage_crystal_item_id(  )
    self.need_item:set_icon(item_id)
    self.need_item.item_id = item_id

	local count = TransformModel:get_yuli_crystal_count()
    -- 如果背包中相应阶晶石数为0，则置灰晶石图片
    if count == 0 then
        self.need_item:set_icon_dead_color()
    else
        self.need_item:set_icon_light_color()
    end
    self.need_item:set_item_count(count)

    local item_name = ItemConfig:get_item_name_by_item_id(item_id)
    local lv = TransformModel:get_miji_level_by_id( aoyi )
    local need_num = TransformConfig:get_upgrade_item_num_by_level( lv )
    self.needitem_name:setText(string.format("%s%s%s%d", "#ce519cb", item_name, " #cffffffx", need_num))

    if need_num == 0 then
        self.upgrade_btn:setCurState(CLICK_STATE_DISABLE)
        self.auto_upgrade_btn:setCurState(CLICK_STATE_DISABLE)
    else
        self.upgrade_btn:setCurState(CLICK_STATE_UP)
        self.auto_upgrade_btn:setCurState(CLICK_STATE_UP)
    end
end

function UpgradeBtnPage:create_wish_panel( parent )
	local panel = ZBasePanel.new("", 320, 100).view
    panel:setPosition(10, 94)
    parent:addChild(panel)

    local titleBg = ZImage.new("ui/common/wzd-1.png").view
    titleBg:setPosition(1, 68)
    panel:addChild(titleBg)

    local title = ZImage.new("ui/transform/new27.png").view
    title:setPosition(24, 2)
    titleBg:addChild(title)

    self.progress = MUtils:create_progress_bar(320/2, 40, 230, 16, "ui/common/di.png", "ui/common/progress_green.png", 100, {14}, {1,1,1,1}, true)
    self.progress.view:setAnchorPoint(0.5, 0)
    self.progress.set_max_value(100)
    self.progress.set_current_value(0)
    panel:addChild(self.progress.view)

    local progress_desc = ZLabel.new("祝福值越高成功率越高")
    progress_desc.view:setAnchorPoint(CCPointMake(0.5, 0))
    progress_desc:setFontSize(16)
    progress_desc:setPosition(320/2, 15)
    panel:addChild(progress_desc.view)
end

function UpgradeBtnPage:update_wish_panel( )
	local aoyi = TransformModel:get_current_selected_aoyi( )
	local miji_info = TransformModel:get_miji_info_by_id( aoyi )
 	local miji_level = miji_info.level

	local current_zhufu = miji_info.Zhufu
 	local max_zhifu = TransformConfig:get_max_zhufu_by_level(miji_level)
 	self.progress.set_max_value(max_zhifu)
    self.progress.set_current_value(current_zhufu)
end

function UpgradeBtnPage:update( update_type )
	if update_type == "all" then
		self:update_top_panel()
		self:update_upgrade_panel()
		self:update_cost_panel()
		self:update_wish_panel()
	end
end


