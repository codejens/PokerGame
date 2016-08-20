-- ElfinLevelRightPage.lua
-- created by yongrui.liang on 2014-8-25
-- 式神等级右页面

super_class.ElfinLevelRightPage()

local _autoBuyBtn = nil
local _selectedItem = 1

function ElfinLevelRightPage:__init( )
	-- 底板
    self.view = ZBasePanel.new(UIPIC_GRID_nine_grid_bg3, 393, 565).view
	local panel = self.view

	-- 上面板
    local upPanel = self:createUpPanel(393, 140)
    upPanel:setPosition(0, 414)
    panel:addChild(upPanel)

    -- 下面板
    local dwnPanel = self:createDwnPanel(393, 416)
    dwnPanel:setPosition(0, 0)
    panel:addChild(dwnPanel)
end

-- 创建上面板
function ElfinLevelRightPage:createUpPanel( width, height )
	local parent = ZBasePanel.new(nil, width, height).view
	local size = parent:getSize()

	local x, ox, y, oy = 20, 90, 104, 40
	-- 名称
    ZLabel:create(parent, "#cf1e7d4式神名称：", x, y, 17, 1, 1)
    self.elfinName = ZLabel:create(parent, "", x+ox, y, 17, 1, 1)
	-- 等级
    ZLabel:create(parent, "#cf1e7d4等    级：", x, y-oy, 17, 1, 1)
    self.elfinLevel = ZLabel:create(parent, "", x+ox, y-oy, 17, 1, 1)
	-- 经验
    ZLabel:create(parent, "#cf1e7d4经    验：", x, y-oy*2, 17, 1, 1)
    self.elfinExp = MUtils:create_progress_bar(x+ox, y-oy*2, 170, 16, "ui/common/di.png", "ui/common/progress_green.png", 100, {14}, {1,1,1,1}, true)
    self.elfinExp.set_max_value(100)
    self.elfinExp.set_current_value(0)
    parent:addChild(self.elfinExp.view)


	return parent
end

-- 更新上面板
function ElfinLevelRightPage:updateUpPanel( )
	local modelId = ElfinModel:getModelId()
	local modelName = ElfinConfig:getModelNameById(modelId)
	self.elfinName:setText(string.format("#cfff000%s", modelName))

	local level = ElfinModel:getElfinLevel()
	self.elfinLevel:setText(string.format("#cfff000%d", level))

	local maxExp = ElfinConfig:getLevelUpExp(level)
	local exp = ElfinModel:getElfinExp()
	self.elfinExp.set_max_value(maxExp or 0)
	self.elfinExp.set_current_value(exp or 0)
end

function ElfinLevelRightPage:playLvUpEffect( parent, x, y )
    LuaEffectManager:stop_view_effect(10015, parent)
    LuaEffectManager:play_view_effect(10015, x, y, parent, false, 10000):setPosition(CCPointMake(x, y))
end


-- 创建下面板
function ElfinLevelRightPage:createDwnPanel( width, height )
	local parent = ZBasePanel.new(nil, width, height).view
	local size = parent:getSize()

    local rowBg = ZImage:create(parent, "ui/common/ht_bg.png", 2, size.height-40, size.width-4, 39, 0, 0, 500, 500).view
    ZLabel:create(rowBg, "#cfff000使用式神丹增加式神经验", 10, 14, 16, 1, 1)
    ZLabel:create(rowBg, "#cf1e7d4（兑换、商城购买）", width, 14, 16, 3, 1)

    self.needItems = {}
    local needItemIds = ElfinConfig:getLevelUpNeedItems()
    -- 第一个材料
    self.needItems[1] = self:createNeedItemPanel(needItemIds[1], width-20, 86)
    self.needItems[1].view:setPosition(10, height-40-88)
    parent:addChild(self.needItems[1].view)
    -- 第二个材料
    self.needItems[2] = self:createNeedItemPanel(needItemIds[2], width-20, 86)
    self.needItems[2].view:setPosition(10, height-40-88*2)
    parent:addChild(self.needItems[2].view)
    -- 第三个材料
    self.needItems[3] = self:createNeedItemPanel(needItemIds[3], width-20, 86)
    self.needItems[3].view:setPosition(10, height-40-88*3)
    parent:addChild(self.needItems[3].view)

    -- 默认选择第一个
    self.needItems[1].doClick()

    -- 提升按钮
	self.upgradeBtn = ZButton.new("ui/common/dan.png", "ui/common/dan.png")
	self.upgradeBtn.view:addTexWithFile(CLICK_STATE_DISABLE, "ui/common/dan_d.png")
	self.upgradeBtn:setPosition(130, 25)
	parent:addChild(self.upgradeBtn.view)
	local upSkillFunc = function( )
		print('-- upgradeBtn clicked --')
		-- Instruction:handleUIComponentClick(instruct_comps.SHISHENGSHENGJI)
		ElfinModel:reqLevelUpElfin(_selectedItem, _autoBuyBtn.if_selected)
	end
	self.upgradeBtn:setTouchClickFun(upSkillFunc)
	local btnSize = self.upgradeBtn.view:getSize()
	local txtImg = ZImage:create(self.upgradeBtn.view, "ui/elfin/13.png", btnSize.width/2, btnSize.height/2, -1, -1)
	txtImg.view:setAnchorPoint(0.5, 0.5)
    
    -- 是否自动购买材料
    _autoBuyBtn = UIButton:create_switch_button(20, 30, 100, 44, 
        UIPIC_FORGE_031, 
        UIPIC_FORGE_032, 
        "", 50, 16, nil, nil, nil, nil, 
        autoBuyFunc )
    parent:addChild(_autoBuyBtn.view, 2);

    ZLabel:create(parent, "#cf1e7d4自动购", 65, 55, 16, 1, 1)
    ZLabel:create(parent, "#cf1e7d4买材料", 65, 35, 16, 1, 1)


	return parent
end

function ElfinLevelRightPage:createNeedItemPanel( itemID, width, height )
	local parent = ZBasePanel.new("", width, height, 500, 500)

	-- 材料Item
	local needItem = MUtils:create_slot_item(parent.view, UIPIC_ITEMSLOT, 67, 7, 72, 72, itemID)
	local count = ItemModel:get_item_count_by_id(itemID)
	needItem:set_item_count(count)
	if count > 0 then
		needItem:set_icon_light_color()
	else
		needItem:set_icon_dead_color()
	end
	parent.itemId = itemID
	parent.item = needItem
	parent.updateItem = function( ID )
		parent.itemId = ID
		parent.item:set_icon(ID)
		parent.item:set_color_frame(ID, -2, -2, 68, 68)
		local count = ItemModel:get_item_count_by_id(ID)
		parent.item:set_item_count(count)
		if count > 0 then
			parent.item:set_icon_light_color()
		else
			parent.item:set_icon_dead_color()
		end
        parent.item:set_click_event( function( ... )
        	local a, b, arg = ...
            local click_pos = Utils:Split(arg, ":")
            local world_pos = parent.item.view:getParent():convertToWorldSpace( CCPointMake( tonumber(click_pos[1]),tonumber(click_pos[2]) ) )
            TipsModel:show_shop_tip( world_pos.x, world_pos.y, ID )
        end )
	end

	-- 材料名字
	local nameTxt = ItemConfig:get_item_name_by_item_id(itemID)
	local itemName = ZLabel:create(parent.view, nameTxt, 160, 35, 16, 1, 0)

	parent.name = itemName
	parent.updateName = function( ID )
		local nameTxt = ItemModel:get_item_name_with_color(ID)
		parent.name:setText(nameTxt)
	end

	-- 选择时的发光底图
	local selectedBg = ZImage:create(parent.view, "ui/transform/new28.png", -2, -2, width+4, height+4, 10, 500, 500).view
	selectedBg:setIsVisible(false)

	-- 设置选择状态
	parent.setSelected = function( state )
		selectedBg:setIsVisible(state)
	end

	-- 点击事件
	local clickFunc = function( )
		for i,v in ipairs(self.needItems) do
			v.setSelected(false)
		end
		parent.setSelected(true)
		_selectedItem = parent.itemId
	end
	parent:setTouchClickFun(clickFunc)
	parent.doClick = clickFunc

	return parent
end

-- 更新下面板
function ElfinLevelRightPage:updateDwnPanel( )
	local needItemIds = ElfinConfig:getLevelUpNeedItems()
	self.needItems[1].updateItem(needItemIds[1])
	self.needItems[2].updateItem(needItemIds[2])
	self.needItems[3].updateItem(needItemIds[3])
	self.needItems[1].updateName(needItemIds[1])
	self.needItems[2].updateName(needItemIds[2])
	self.needItems[3].updateName(needItemIds[3])
end

function ElfinLevelRightPage:update( updateType )
	print('-- ElfinLevelRightPage:update( updateType ) --', updateType)
	if updateType == "all" then
		self:updateUpPanel()
		self:updateDwnPanel()
	elseif updateType == "model" then
		self:updateUpPanel()
	elseif updateType == "booooom" then
        self:playLvUpEffect(self.view, 190, 446)
	end
end

function ElfinLevelRightPage:destroy( )
end