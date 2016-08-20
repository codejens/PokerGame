-- WingShapePage.lua
-- created by yongrui.liang on 2014-8-19
-- 翅膀化形页面

super_class.WingShapePage()

function WingShapePage:__init( )
	-- 底板
    self.view = ZBasePanel.new(UIPIC_GRID_nine_grid_bg3, 393, 565).view
	local panel = self.view

    local upPanel = self:createUpPanel(373, 392)
    upPanel:setPosition(10, 158)
    panel:addChild(upPanel)

    local dwnPanel = self:createDwnPanel(373+10, 158)
    dwnPanel:setPosition(5, 0)
    panel:addChild(dwnPanel)

    self.curShowStage = WingModel:get_curr_wing_stage()
end

function WingShapePage:createUpPanel( width, height )
	local parent = ZBasePanel.new(nil, width, height).view
	local size = parent:getSize()

	ZBasePanel:create(parent, "ui/geniues/genius_bg6.png", 3, 3, size.width-6, size.height-6, 0, 0)
	ZBasePanel:create(parent, "ui/geniues/genius_bg4.png", 66, 88, -1, -1, 500, 500)
	ZImage:create(parent, "ui/wing/14.png", 72, size.height-34, -1, -1, 0, 0)

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

	self.wingName = ZLabel:create(parent, "", size.width/2, size.height-27, 17, 2, 1)

	self.playerModel = self:createPlayerModel(200-16, 200-36)
	parent:addChild(self.playerModel.avatar)

	local function leftBtnFunc()
        print('-- leftBtn clicked --')
        if self.curShowStage > 1 then
			self.curShowStage = self.curShowStage - 1
        	self:updatePlayerModel(self.curShowStage)
        	self:updateWingName(self.curShowStage)
        	self:updateDwnPanel()
        else
        	GlobalFunc:create_screen_notic( "当前是第一页" )
        end
    end
    local leftBtn = ZButton:create(parent, "ui/common/an_zuo.png", leftBtnFunc , 5, 160, -1, -1)
    
    local function rightBtnFunc()
        print('-- rightBtn clicked --')
        local maxStage = WingModel:get_max_win_stage()
        if self.curShowStage < maxStage then
			self.curShowStage = self.curShowStage + 1
			self:updatePlayerModel(self.curShowStage)
			self:updateWingName(self.curShowStage)
			self:updateDwnPanel()
        else
        	GlobalFunc:create_screen_notic( "当前是最后一页" )
        end
    end
    local rightBtn = ZButton:create(parent, "ui/common/an_you.png",rightBtnFunc, size.width-50, 160, -1, -1 )

	return parent
end

-- 创建人物模型
function WingShapePage:createPlayerModel( x, y )
	-- 人物带翅膀的形象
    local playerModel = ShowAvatar:create_wing_panel_avatar( x, y )

    return playerModel
end

-- 更新人物模型
function WingShapePage:updatePlayerModel( stage )
	self.playerModel:update_wing(stage)
	self.playerModel:change_attri("body")
end

-- 更新翅膀名字
function WingShapePage:updateWingName( stage )
	-- 更新翅膀名字
	local wingNameTxt = WingModel:get_wing_info_with_stage(stage)
	self.wingName:setText(string.format("#cfff000%s", wingNameTxt))
end

function WingShapePage:playChangeShapeEffect( parent, x, y )
    LuaEffectManager:stop_view_effect(403, parent)
    LuaEffectManager:play_view_effect(403, x, y, parent, false, 10000):setPosition(CCPointMake(x, y))
end

function WingShapePage:createDwnPanel( width, height )
	local parent = ZBasePanel.new(nil, width, height).view
	local size = parent:getSize()

	local rowBg = ZImage:create(nil, "ui/common/ht_bg.png", 0, 3, size.width, 39, 0, 500, 500).view
    parent:addChild(rowBg)
    ZLabel:create(rowBg, LangGameString[2148], size.width/2, 14, 17, 2, 1) -- "更改不同的外观，不会影响属性"

    -- 更改外观按钮
	self.changeShapeBtn = ZButton.new("ui/common/dan.png", "ui/common/dan.png")
	self.changeShapeBtn.view:addTexWithFile(CLICK_STATE_DISABLE, "ui/common/dan_d.png")
	self.changeShapeBtn:setPosition(122, 72)
	parent:addChild(self.changeShapeBtn.view)
	local changeShapeFunc = function( )
		print('-- changeShapeBtn clicked --')
		WingModel:req_hua_xing( self.curShowStage )
	end
	self.changeShapeBtn:setTouchClickFun(changeShapeFunc)
	local btnSize = self.changeShapeBtn.view:getSize()
	local txtImg = ZImage:create(self.changeShapeBtn.view, "ui/wing/19.png", btnSize.width/2, btnSize.height/2, -1, -1)
	txtImg.view:setAnchorPoint(0.5, 0.5)

	return parent
end

-- 更新下面板
function WingShapePage:updateDwnPanel( )
	local stage = WingModel:get_curr_wing_stage()
	local curModelId = WingModel:get_curr_modelId()
	if self.curShowStage > stage or curModelId == self.curShowStage then
		self.changeShapeBtn.view:setCurState(CLICK_STATE_DISABLE)
	else
		self.changeShapeBtn.view:setCurState(CLICK_STATE_UP)
	end
end

function WingShapePage:update( updateType )
	print('-- WingShapePage:update( updateType ) --', updateType)
	if updateType == "all" then
		self:updatePlayerModel(self.curShowStage)
		self:updateWingName(self.curShowStage)
		self:updateDwnPanel()
	elseif updateType == "changeShapeEffect" then
		self:playChangeShapeEffect(self.view, 190+15, 200)
		self:updateDwnPanel()
	end
end

function WingShapePage:destroy( )
	if self.shapeScroll and self.shapeScroll.destroy then
		self.shapeScroll:destroy()
	end
end