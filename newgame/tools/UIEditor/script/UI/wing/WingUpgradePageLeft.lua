-- WingUpgradePageLeft.lua
-- created by yongrui.liang on 2014-8-18
-- 翅膀系统升阶左页面

super_class.WingUpgradePageLeft()

function WingUpgradePageLeft:__init( )
	-- 底板
    self.view = ZBasePanel.new(UIPIC_GRID_nine_grid_bg3, 340, 565).view
	local panel = self.view

    -- ZBasePanel:create(panel, "", 10, 10, 320, 545, 500, 500)
    local modelPanel = self:createModelPanel(320+10, 545+10)
    modelPanel:setPosition(5, 5)
    panel:addChild(modelPanel)
end

function WingUpgradePageLeft:createModelBg( width, height )
	local parent = ZBasePanel.new(nil, width, height).view
	local size = parent:getSize()

	ZBasePanel:create(parent, "ui/geniues/genius_bg6.png", 3, 3, size.width-6, size.height-6, 0, 0)
	ZBasePanel:create(parent, "ui/geniues/genius_bg4.png", 50, 3, -1, -1, 500, 500)
	ZImage:create(parent, "ui/wing/14.png", 51, size.height-32, -1, -1, 0, 0)

	-- 4个角标
	local LTCorner = ZBasePanel:create(parent, "ui/geniues/genius_bg5.png", 1, size.height-43)
	LTCorner.view:setFlipX(true)
	LTCorner.view:setFlipY(false)
	local LBCorner = ZBasePanel:create(parent, "ui/geniues/genius_bg5.png", 1, 1)
	LBCorner.view:setFlipX(true)
	LBCorner.view:setFlipY(true)
	local RTCorner = ZBasePanel:create(parent, "ui/geniues/genius_bg5.png", size.width-43, size.height-43)
	RTCorner.view:setFlipX(false)
	RTCorner.view:setFlipY(false)
	local RBCorner = ZBasePanel:create(parent, "ui/geniues/genius_bg5.png", size.width-43, 1)
	RBCorner.view:setFlipX(false)
	RBCorner.view:setFlipY(true)

	return parent
end

function WingUpgradePageLeft:createModelPanel( width, height )
	local parent = ZBasePanel.new(nil, width, height).view

	local topModelBg = self:createModelBg(width, height/2)
	topModelBg:setPosition(0, height/2)
	parent:addChild(topModelBg)
	local topSize = topModelBg:getSize()

	local topTitle = ZImage.new("ui/wing/12.png").view
	topTitle:setAnchorPoint(0.5, 0)
	topTitle:setPosition(topSize.width/2, topSize.height-36)
	topModelBg:addChild(topTitle)

	local dwnModelBg = self:createModelBg(width, height/2)
	dwnModelBg:setPosition(0, 0)
	parent:addChild(dwnModelBg)
	local dwnSize = dwnModelBg:getSize()

	local dwnTitle = ZImage.new("ui/wing/13.png").view
	dwnTitle:setAnchorPoint(0.5, 0)
	dwnTitle:setPosition(dwnSize.width/2, dwnSize.height-36)
	dwnModelBg:addChild(dwnTitle)

	-- 当前人物模型
	self.curPlayerModel = self:createPlayerModel(170, 80)
	topModelBg:addChild(self.curPlayerModel.avatar)

	-- 下阶人物模型
	self.nexPlayerModel = self:createPlayerModel(170, 80)
	dwnModelBg:addChild(self.nexPlayerModel.avatar)

	return parent
end

-- 创建人物模型
function WingUpgradePageLeft:createPlayerModel( x, y )
	-- 人物带翅膀的形象
    local playerModel = ShowAvatar:create_wing_panel_avatar( x, y )

    return playerModel
end

-- 更新人物模型
function WingUpgradePageLeft:updatePlayerModel( )
	-- 更新当前阶模型
	local curStage = WingModel:get_curr_wing_stage()
	self.curPlayerModel:update_wing(curStage)
	self.curPlayerModel:change_attri("body")

	-- 更新下阶模型
	local nexStage = WingModel:get_wing_next_stage()
	self.nexPlayerModel:update_wing(nexStage)
	self.nexPlayerModel:change_attri("body")
end

function WingUpgradePageLeft:update( updateType )
	print('-- WingUpgradePageLeft:update( updateType ) --', updateType)
	if updateType == "all" then
		self:updatePlayerModel()
	end
end

function WingUpgradePageLeft:destroy( )
	
end