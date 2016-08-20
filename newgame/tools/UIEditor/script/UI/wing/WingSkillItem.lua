-- WingSkillItem.lua 
-- createed by chj at 2014.10.30
-- 翅膀界面(天将雄狮版本)

super_class.WingSkillItem()

-- ui param

-- 创建一个WingSkillItem
function WingSkillItem:create_item( panel, x, y, w, h, index)
	local item = WingSkillItem( 0, 0, w, h, index)
	item.view:setPosition(x, y)
	panel:addChild( item.view )
	return item
end

-- 初始化
function WingSkillItem:__init( x, y, w, h, index )
	-- local big_bg = CCBasePanel:panelWithFile( x, y, w, h, UILH_NORMAL.skill_bg1)
	-- panel:addChild( big_bg)
	-- self.view = ZBasePanel.new(nil, w, h)
	self.skill_index = index
	self.view = CCBasePanel:panelWithFile( x, y, -1, -1, UILH_NORMAL.skill_bg1 )
	self.item = MUtils:create_slot_item(self.view, "", 7, 7, 89, 90, nil, nil)	
	self.item.view:setScale(0.8)
	local itemIcon = WingConfig:get_wing_skill_icon_by_id( index )
	self.item:set_icon_texture( itemIcon )
    self.item:set_select_effect_state(false)

    -- 点击触发函数
    self.item :set_click_event( function()

    end)
end

-- 设置技能未开启(锁住状态)
function WingSkillItem:set_lock()
	self.view:setTexture( UILH_NORMAL.skill_lock )
	self.item.view:setIsVisible(false)
end

-- 设置技能开启
function WingSkillItem:set_open()
	self.view:setTexture( UILH_NORMAL.skill_lock )
	self.item.view:setIsVisible(true)
end

--
function WingSkillItem:update()

end

-- 销毁窗体
function WingSkillItem:destroy()
end