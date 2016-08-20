-- ElfinInfoPage.lua
-- created by yongrui.liang on 2014-8-29
-- 式神信息页面

super_class.ElfinInfoPage()

local modelX, modelY = 170, 200

function ElfinInfoPage:__init( )
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
function ElfinInfoPage:createUpPanel( width, height )
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
	self.elfinModel = self:createElfinModel(modelX, modelY)
	parent:addChild(self.elfinModel)

	self.elfinItems	= {}
	self:createItems(parent)

	return parent
end

function ElfinInfoPage:createItems( parent )
	local itemPos = {{15, 270}, {250, 270}, {15, 190}, {250, 190}, {15, 110}, {250, 110}, {15, 30}, {250, 30}}
	for i,v in ipairs(itemPos) do
		self.elfinItems[i] = ElfinEquipItem()
		self.elfinItems[i].view:setPosition(v[1], v[2])
		parent:addChild(self.elfinItems[i].view)
	end
end

-- 创建式神模型
function ElfinInfoPage:createElfinModel( x, y )
end

-- 更新上面板
function ElfinInfoPage:updateUpPanel( )
	-- 更新式神名字
	local modelId = ElfinModel:getOtherModelId()
	local name = ElfinConfig:getModelNameById(modelId)
	self.elfinName:setText(string.format("#cfff000%s", name))

	local fight = ElfinModel:getOtherElfinFight()
	self.fight:init(tostring(fight))

	self:updateElfinModel()

	-- 更新装备框
	for i=1,#self.elfinItems do
		self.elfinItems[i]:initItem()
	end
	local openSlotNum = ElfinModel:getOtherOpenEquipNum()
	for i=1,openSlotNum do
		self.elfinItems[i]:setOpenStatus(true)
	end

	local equipItems = ElfinModel:getOtherEquips()
	for i,v in ipairs(equipItems) do
		self.elfinItems[v.itemIndex]:setIndex(v.itemIndex)
		self.elfinItems[v.itemIndex]:setIcon(v.itemType)
		self.elfinItems[v.itemIndex]:setQuality(v.itemQlty)
		self.elfinItems[v.itemIndex]:setClickFun(function( )
			TipsModel:show_fabao_xianhun(480, 480/2, v)
		end)
	end
end

-- 更新式神模型
function ElfinInfoPage:updateElfinModel( )
	if self.elfinModel then
        self.elfinModel:removeFromParentAndCleanup(true);
    end
    local modelId = ElfinModel:getOtherModelId()
    local path = string.format("frame/gem/%05d", modelId)
    local action = UI_GENIUS_ACTION
    self.elfinModel = MUtils:create_animation( modelX, modelY, path, action )
    self.elfinModel:setScale(1.5)
    self.upPanel:addChild( self.elfinModel )
end

-- 创建下面板
function ElfinInfoPage:createDwnPanel( width, height )
	local parent = ZBasePanel.new(nil, width, height).view

	ZBasePanel:create(parent, "", 0, 0, width, height, 500, 500)

	-- 标题
	local titleBg = ZImage:create(parent, "ui/transform/new24.png", width/2, height-19, -1, -1, 0, 500, 500)
    titleBg.view:setAnchorPoint(0.5, 0.5)
    ZLabel:create(parent, "#cfff000增加人物属性", width/2, height-26, 16, 2)

    -- 属性
    local x, y, oy = 10, 100, 35

    -- "生    命："
    ZLabel:create(parent, LangGameString[2146], x, y, 15, 1, 1)
    self.hp = ZLabel:create(parent, "", x+80, y, 15, 1, 1)

    -- "攻    击："
    ZLabel:create(parent, LangGameString[2143], width/2+x, y, 15, 1, 1)
    self.attack = ZLabel:create(parent, "", width/2+x+80, y, 15, 1, 1)

    ZLabel:create(parent, LangGameString[2144], x, y-oy, 15, 1, 1) -- "物理防御："
    self.phyDef = ZLabel:create(parent, "", x+80, y-oy, 15, 1, 1)

    -- "精神防御："
    ZLabel:create(parent, LangGameString[2145], width/2+x, y-oy, 15, 1, 1)
    self.magDef = ZLabel:create(parent, "", width/2+x+80, y-oy, 15, 1, 1)

    -- "抗 暴 击："
    ZLabel:create(parent, "抗 暴 击：", x, y-oy*2, 15, 1, 1)
    self.criDef = ZLabel:create(parent, "", x+80, y-oy*2, 15, 1, 1)

	-- -- 展示按钮
	-- local showBtn = ZTextButton.new("ui/common/button2.png", nil, nil, "展示")
	-- showBtn:setPosition(width-105, 5)
	-- parent:addChild(showBtn.view)
	-- local showFunc = function( )
	-- 	print('-- showBtn clicked --')
	-- end
	-- showBtn:setTouchClickFun(showFunc)

	return parent
end

-- 更新下面板
function ElfinInfoPage:updateDwnPanel( )
	-- 更新属性
	local attrs = ElfinModel:getOtherAttrs()
	self.hp:setText(string.format("#cffffff%d#cfe8300", attrs[1]))
	self.attack:setText(string.format("#cffffff%d#cfe8300", attrs[2]))
	self.phyDef:setText(string.format("#cffffff%d#cfe8300", attrs[3]))
	self.magDef:setText(string.format("#cffffff%d#cfe8300", attrs[4]))
	self.criDef:setText(string.format("#cffffff%d#cfe8300", attrs[5]))
end

function ElfinInfoPage:update( updateType )
	print('-- ElfinInfoPage:update( updateType ) --', updateType)
	if updateType == "all" then
		self:updateUpPanel()
		self:updateDwnPanel()
	end
end

function ElfinInfoPage:destroy( )
	ElfinModel:setOtherElfinData(nil)
end