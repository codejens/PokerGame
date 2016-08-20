-- ElfinLevelLeftPage.lua
-- created by yongrui.liang on 2014-8-25
-- 式神等级左页面

super_class.ElfinLevelLeftPage()

-- 当前显示的模型
local _curShowModel = 1
local modelX, modelY = 170, 200

function ElfinLevelLeftPage:__init( )
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

    -- 当前模型
    _curShowModel = ElfinModel:getModelId()
end

-- 创建上面板
function ElfinLevelLeftPage:createUpPanel( width, height )
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

	-- 式神等级范围
	self.elfinModelLevel = ZLabel:create(parent, "", width/2, 25, 16, 2)

	-- 左按钮
	local function leftBtnFunc()
        print('-- leftBtn clicked --')
        if _curShowModel > 1 then
        	_curShowModel = _curShowModel - 1
        	self:updateElfinModel(_curShowModel)
        	self:updateElfinName(_curShowModel)
        	self:updateElfinLevel(_curShowModel)
        else
        	GlobalFunc:create_screen_notic( "当前是第一页" )
        end
    end
    local leftBtn = ZButton:create(parent, "ui/common/an_zuo.png", leftBtnFunc , 5, 160, -1, -1)
    
    -- 右按钮
    local function rightBtnFunc()
        print('-- rightBtn clicked --')
        local maxModel = ElfinConfig:getElfinModelNum()
        if _curShowModel < maxModel then
        	_curShowModel = _curShowModel + 1
			self:updateElfinModel(_curShowModel)
			self:updateElfinName(_curShowModel)
			self:updateElfinLevel(_curShowModel)
        else
        	GlobalFunc:create_screen_notic( "当前是最后一页" )
        end
    end
    local rightBtn = ZButton:create(parent, "ui/common/an_you.png",rightBtnFunc, width-50, 160, -1, -1 )

	return parent
end

-- 创建式神模型
function ElfinLevelLeftPage:createElfinModel( x, y, path )
	local action = UI_GENIUS_ACTION
    elfinModel = MUtils:create_animation(x, y, path, action)
    elfinModel:setScale(1.5)
    return elfinModel
end

-- 更新上面板
function ElfinLevelLeftPage:updateUpPanel( )
	-- 更新战斗力
	self:updateFight()
	-- 更新式神名字
	self:updateElfinName()
	-- 更新模型
	self:updateElfinModel()
	-- 师尊模型等级范围
	self:updateElfinLevel()
end

function ElfinLevelLeftPage:updateElfinLevel( modelId )
	modelId = modelId or ElfinModel:getModelId()
	local minLevel = ElfinConfig:getModelMinLevelById(modelId)
	local maxLevel = ElfinConfig:getModelMaxLevelById(modelId)
	self.elfinModelLevel:setText(string.format("%d~%d级形态", minLevel, maxLevel))
end

function ElfinLevelLeftPage:updateFight( )
	local fight = ElfinModel:getElfinFight()
	self.fight:init(tostring(fight))
end

-- 更新式神模型
function ElfinLevelLeftPage:updateElfinModel( modelId )
	if self.elfinModel then
        self.elfinModel:removeFromParentAndCleanup(true);
    end
    modelId = modelId or ElfinModel:getModelId()
    local path = string.format("frame/gem/%05d", modelId)
    self.elfinModel = self:createElfinModel(modelX, modelY, path)
    self.upPanel:addChild( self.elfinModel )
end

-- 更新式神名字
function ElfinLevelLeftPage:updateElfinName( modelId )
	modelId = modelId or ElfinModel:getModelId()
	local name = ElfinConfig:getModelNameById(modelId)
	self.elfinName:setText(string.format("#cfff000%s", name))
end

-- 创建下面板
function ElfinLevelLeftPage:createDwnPanel( width, height )
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
		print('-- showBtn clicked --')
		ElfinModel:showElfin()
	end
	showBtn:setTouchClickFun(showFunc)

	return parent
end

-- 更新下面板
function ElfinLevelLeftPage:updateDwnPanel( )
	-- 更新属性
	local attrs = ElfinModel:getAttrs()
	self.hp:setText(string.format("#cffffff%d#cfe8300", attrs[1]))
	self.attack:setText(string.format("#cffffff%d#cfe8300", attrs[2]))
	self.phyDef:setText(string.format("#cffffff%d#cfe8300", attrs[3]))
	self.magDef:setText(string.format("#cffffff%d#cfe8300", attrs[4]))
	self.criDef:setText(string.format("#cffffff%d#cfe8300", attrs[5]))
end

function ElfinLevelLeftPage:update( updateType )
	print('-- ElfinLevelLeftPage:update( updateType ) --', updateType)
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
		self:updateElfinLevel()
	end
end

function ElfinLevelLeftPage:destroy( )
	_curShowModel = 1
end