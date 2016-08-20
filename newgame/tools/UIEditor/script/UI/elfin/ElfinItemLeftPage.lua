-- ElfinItemLeftPage.lua
-- created by yongrui.liang on 2014-8-25
-- 式神装备左页面

super_class.ElfinItemLeftPage()

local modelX, modelY = 170, 200

function ElfinItemLeftPage:__init( )
	-- 底板
    self.view = ZBasePanel.new(UIPIC_GRID_nine_grid_bg3, 340, 565).view
	local panel = self.view

	-- 上面板
    local upPanel = self:createUpPanel(320+10, 395)
    upPanel:setPosition(5, 164)
    panel:addChild(upPanel)
    self.upPanel = upPanel

    -- 下面板
    local dwnPanel = self:createDwnPanel(324, 154)
    dwnPanel:setPosition(8, 8)
    panel:addChild(dwnPanel)
end

-- 创建上面板
function ElfinItemLeftPage:createUpPanel( width, height )
	local parent = ZBasePanel.new(nil, width, height).view

	ZBasePanel:create(parent, "ui/elfin/41.jpg", 3, 3, width-6, height-6, 0, 0)
	-- ZBasePanel:create(parent, "ui/geniues/genius_bg4.png", 50, 100, -1, -1, 500, 500)

	-- 4个角标
	local LTCorner = ZBasePanel:create(parent, "ui/geniues/genius_bg5.png", 1, height-43)
	LTCorner.view:setFlipX(true)
	LTCorner.view:setFlipY(false)
	local LBCorner = ZBasePanel:create(parent, "ui/geniues/genius_bg5.png", 1, 1)
	LBCorner.view:setFlipX(true)
	LBCorner.view:setFlipY(true)
	local RTCorner = ZBasePanel:create(parent, "ui/geniues/genius_bg5.png", width-43, height-43)
	RTCorner.view:setFlipX(false)
	RTCorner.view:setFlipY(false)
	local RBCorner = ZBasePanel:create(parent, "ui/geniues/genius_bg5.png", width-43, 1)
	RBCorner.view:setFlipX(false)
	RBCorner.view:setFlipY(true)

	-- 式神名字
	local titleBg = ZImage:create(parent, "ui/transform/new24.png", width/2, height-19, -1, -1, 0, 500, 500)
    titleBg.view:setAnchorPoint(0.5, 0.5)
	self.elfinName = ZLabel:create(parent, "", width/2, height-27, 17, 2, 1)

	-- 战斗力
	local fightBg = ZImage:create(parent, UI_MountsWinNew_018, width/2-5, height-48).view
	fightBg:setAnchorPoint(1.0, 0.5)
	self.fight = ZXLabelAtlas:createWithString("99999", UIResourcePath.FileLocate.normal .. "number")
	self.fight:setPosition(CCPointMake(width/2+5, height-45))
	self.fight:setAnchorPoint(CCPointMake(0, 0.5))
	parent:addChild(self.fight)

	-- 式神模型
	self.elfinModel = self:createElfinModel(modelX, modelY, "frame/gem/00001")
	parent:addChild(self.elfinModel)

	self.elfinItems	= {}
	self:createItems(parent)

	-- 升级技能按钮
	local upEquipBtn = ZButton.new("ui/common/dan.png", "ui/common/dan.png")
	upEquipBtn:setPosition(92, 10)
	parent:addChild(upEquipBtn.view)
	local upEquipFunc = function( )
		print('-- upEquipBtn clicked --')
		self:selectedItem()
		ElfinModel:setCurElfinItemPage( ElfinModel.LV_UP_ITEM_PAGE)
		ElfinModel:changeRightPage(ElfinModel.LV_UP_ITEM_PAGE)
	end
	upEquipBtn:setTouchClickFun(upEquipFunc)
	local btnSize = upEquipBtn.view:getSize()
	local txtImg = ZImage:create(upEquipBtn.view, "ui/elfin/42.png", btnSize.width/2, btnSize.height/2, -1, -1)
	txtImg.view:setAnchorPoint(0.5, 0.5)

	return parent
end

function ElfinItemLeftPage:selectedItem( )
	local selectedItem = ElfinModel:getClickElfinItem()
	if not selectedItem then
		-- 如果当前没有选中装备，默认选中第一个
		local equipItems = ElfinModel:getEquips()
		if equipItems then
			for k,v in pairs(equipItems) do
				if v and self.elfinItems[v.itemIndex] then
					ElfinModel:setClickElfinItem(self.elfinItems[v.itemIndex])
					SlotEffectManager.play_effect_by_slot_item(self.elfinItems[v.itemIndex].item)
					return
				else
					ElfinModel:setClickElfinItem(nil)
				end
			end
		else
			ElfinModel:setClickElfinItem(nil)
		end
	end
end

function ElfinItemLeftPage:createItems( parent )
	local itemPos = {{15, 270}, {250, 270}, {15, 190}, {250, 190}, {15, 110}, {250, 110}, {15, 30}, {250, 30}}
	for i,v in ipairs(itemPos) do
		self.elfinItems[i] = ElfinEquipItem()
		self.elfinItems[i].view:setPosition(v[1], v[2])
		parent:addChild(self.elfinItems[i].view)
	end
end

-- 创建式神模型
function ElfinItemLeftPage:createElfinModel( x, y, path )
	local action = UI_GENIUS_ACTION
    elfinModel = MUtils:create_animation(x, y, path, action)
    elfinModel:setScale(1.5)
    return elfinModel
end

-- 更新上面板
function ElfinItemLeftPage:updateUpPanel( )
	-- 更新战斗力
	self:updateFight()

	-- 更新式神名字
	self:updateElfinName()
	self:updateElfinModel()

	-- 更新装备框
	self:initItemSlot()
	self:updateOpenItemSlot()
	self:updateEquipItems()
end

-- 初始化装备框
function ElfinItemLeftPage:initItemSlot( )
	for i=1,#self.elfinItems do
		self.elfinItems[i]:initItem()
	end
end

-- 更新装备框开启个数
function ElfinItemLeftPage:updateOpenItemSlot( )
	local openSlotNum = ElfinModel:getOpenEquipNum()
	for i=1,openSlotNum do
		self.elfinItems[i]:setOpenStatus(true)
		self.elfinItems[i]:setIndex(i)
	end

	local openLvs = ElfinConfig:getEquipSlotOpenLevel()
	for i=openSlotNum+1,#self.elfinItems do
		local limitLv = openLvs[i]
		local limitStr = {"式神达到", string.format("%d级开启", limitLv)}
		self.elfinItems[i]:setOpenStatus(false, limitStr)
	end
end

function ElfinItemLeftPage:updateEquipItems( )
	local equipItems = ElfinModel:getEquips()
	for i,v in pairs(equipItems) do
		self.elfinItems[v.itemIndex]:setIndex(v.itemIndex)
		self.elfinItems[v.itemIndex]:setIcon(v.itemType)
		self.elfinItems[v.itemIndex]:setQuality(v.itemQlty)
		self.elfinItems[v.itemIndex]:setClickFun(function( )
			if v.itemCDKey and v.itemCDKey ~= 0 then
				ElfinModel:setClickElfinItem(self.elfinItems[v.itemIndex])
				local rightPage = ElfinModel:getCurRightPage()
				local itemPage = ElfinModel:getCurElfinItemPage()
				if rightPage == ElfinModel.ELFIN_ITEM_RIGHT_PAGE and itemPage == ElfinModel.LV_UP_ITEM_PAGE then
					ElfinModel:updateRightWin(ElfinModel.LV_UP_ITEM_PAGE)
				else
					TipsModel:show_fabao_xianhun(480, 480/2, v)
				end
			end
		end)
		self.elfinItems[v.itemIndex]:setDoubleClickFun(function( )
			if v.itemCDKey and v.itemCDKey ~= 0 then
				ElfinModel:reqDropEquipment(v)
			end
		end)
	end
end

function ElfinItemLeftPage:dropEquipment( index )
	if self.elfinItems[index] then
		self.elfinItems[index]:update(nil)
		self.elfinItems[index]:setClickFun(nil)
		self.elfinItems[index]:setDoubleClickFun(nil)
	end
end

function ElfinItemLeftPage:equipEquipment( index, item )
	if self.elfinItems[index] then
		self.elfinItems[index]:update(item)
		self.elfinItems[index]:setClickFun(function( )
			if item.itemCDKey and item.itemCDKey ~= 0 then
				ElfinModel:setClickElfinItem(self.elfinItems[index])
				local rightPage = ElfinModel:getCurRightPage()
				local itemPage = ElfinModel:getCurElfinItemPage()
				if rightPage == ElfinModel.ELFIN_ITEM_RIGHT_PAGE and itemPage == ElfinModel.LV_UP_ITEM_PAGE then
					ElfinModel:updateRightWin(ElfinModel.LV_UP_ITEM_PAGE)
				else
					TipsModel:show_fabao_xianhun(480, 480/2, item)
				end
			end
		end)
		self.elfinItems[index]:setDoubleClickFun(function( )
			if item.itemCDKey and item.itemCDKey ~= 0 then
				ElfinModel:reqDropEquipment(item)
			end
		end)
	end
end

-- 更新式神模型
function ElfinItemLeftPage:updateElfinModel( )
	if self.elfinModel then
        self.elfinModel:removeFromParentAndCleanup(true);
    end
    local modelId = ElfinModel:getModelId()
    local path = string.format("frame/gem/%05d", modelId)
    self.elfinModel = self:createElfinModel(modelX, modelY, path)
    self.upPanel:addChild( self.elfinModel )
end

-- 更新式神名字
function ElfinItemLeftPage:updateElfinName( )
	local modelId = ElfinModel:getModelId()
	local name = ElfinConfig:getModelNameById(modelId)
	self.elfinName:setText(string.format("#cfff000%s", name))
end

function ElfinItemLeftPage:updateFight( )
	local fight = ElfinModel:getElfinFight()
	self.fight:init(tostring(fight))
end

-- 创建下面板
function ElfinItemLeftPage:createDwnPanel( width, height )
	local parent = ZBasePanel.new(nil, width, height).view

	ZBasePanel:create(parent, "", 0, 0, width, height, 500, 500)

	-- 标题
	local titleBg = ZImage:create(parent, "ui/transform/new24.png", width/2, height-19, -1, -1, 0, 500, 500)
    titleBg.view:setAnchorPoint(0.5, 0.5)
    ZLabel:create(parent, "#cfff000增加人物属性", width/2, height-26, 16, 2)

    -- 属性
    local x, y, oy = 10, 100, 35

    -- "#cf1e7d4生    命："
    ZLabel:create(parent, "#cf1e7d4生    命：", x, y, 15, 1, 1)
    self.hp = ZLabel:create(parent, "", x+80, y, 15, 1, 1)

    -- "#cf1e7d4攻    击："
    ZLabel:create(parent, "#cf1e7d4攻    击：", width/2+x, y, 15, 1, 1)
    self.attack = ZLabel:create(parent, "", width/2+x+80, y, 15, 1, 1)

    ZLabel:create(parent, "#cf1e7d4物理防御：", x, y-oy, 15, 1, 1) -- "#cf1e7d4物理防御："
    self.phyDef = ZLabel:create(parent, "", x+80, y-oy, 15, 1, 1)

    -- "#cf1e7d4精神防御："
    ZLabel:create(parent, "#cf1e7d4精神防御：", width/2+x, y-oy, 15, 1, 1)
    self.magDef = ZLabel:create(parent, "", width/2+x+80, y-oy, 15, 1, 1)

    -- "#cf1e7d4抗 暴 击："
    ZLabel:create(parent, "#cf1e7d4抗 暴 击：", x, y-oy*2, 15, 1, 1)
    self.criDef = ZLabel:create(parent, "", x+80, y-oy*2, 15, 1, 1)

	-- 展示按钮
	local showBtn = ZTextButton.new("ui/common/button2.png", nil, nil, "展示")
	showBtn:setPosition(width-105, 5)
	parent:addChild(showBtn.view)
	local showFunc = function( )
		print('-- showFunc clicked --')
		ElfinModel:showElfin()
	end
	showBtn:setTouchClickFun(showFunc)

	return parent
end

-- 更新下面板
function ElfinItemLeftPage:updateDwnPanel( )
	-- 更新属性
	local attrs = ElfinModel:getAttrs()
	self.hp:setText(string.format("#cffffff%d#cfe8300", attrs[1]))
	self.attack:setText(string.format("#cffffff%d#cfe8300", attrs[2]))
	self.phyDef:setText(string.format("#cffffff%d#cfe8300", attrs[3]))
	self.magDef:setText(string.format("#cffffff%d#cfe8300", attrs[4]))
	self.criDef:setText(string.format("#cffffff%d#cfe8300", attrs[5]))
end

function ElfinItemLeftPage:update( updateType, param )
	print('-- ElfinItemLeftPage:update( updateType ) --', updateType)
	if updateType == "all" then
		self:updateUpPanel()
		self:updateDwnPanel()
	elseif updateType == "fight" then
		-- 更新战斗力
		self:updateFight()
	elseif updateType == "model" then
		-- 更新式神
		self:updateElfinName()
		self:updateElfinModel()
	elseif updateType == "openItemSlot" then
		self:updateOpenItemSlot()
	elseif updateType == "selectedItem" then
		self:selectedItem()
	elseif updateType == "changeEquipment" then
		self:equipEquipment(param[1], param[2])
	elseif updateType == "dropEquipment" then
		self:dropEquipment(param[1])
	end
end

function ElfinItemLeftPage:destroy( )
end