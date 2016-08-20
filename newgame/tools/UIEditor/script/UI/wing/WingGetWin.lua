-- WingGetWin.lua 
-- createed by yongrui.liang at 2014-8-22
-- 领取翅膀窗口

super_class.WingGetWin(NormalStyleWindow)

	local x = 10
	local y = 240
	local oy = 38
	local fsize = 16

function WingGetWin:__init( window_name, texture_name )
 	local bgPanel = CCBasePanel:panelWithFile( 30, 20, 485, 587, UI_MountsWinNew_003, 500, 500 )
 	self.view:addChild(bgPanel)

	local leftPanel = self:createLeftPanel(227, 555)
	leftPanel:setPosition(13, 15)
	bgPanel:addChild(leftPanel)

	local rightPanel = self:createRightPanel(227, 555)
	rightPanel:setPosition(246, 15)
	bgPanel:addChild(rightPanel)
end

function WingGetWin:createAvatarModelPanel( width, height )
	local parent = ZBasePanel.new(nil, width, height).view

	-- 背景
	ZBasePanel:create(parent, "ui/wing/20.jpg", 0, 0, width, height, 500, 500)
	-- 角标
	local cornerLT = MUtils:create_sprite(parent, UI_GeniusWin_0052, 20, height-20)
	cornerLT:setRotation(270)
	local cornerRT = MUtils:create_sprite(parent, UI_GeniusWin_0052, width-20, height-20)
	cornerRT:setRotation(0)

	-- 战斗力底图
	ZBasePanel:create(parent, UI_MountsWinNew_017, 10, 0, width-20, -1, 500, 500)
	-- 战斗力字
	ZImage:create(parent, UI_MountsWinNew_018, 50, 16, -1, -1)

	return parent
end

function WingGetWin:createAttrPanel( width, height )
	local parent = ZBasePanel.new(nil, width, height).view

	-- 背景
	ZBasePanel:create(parent, UI_MountsWinNew_004, 0, 0, width, height, 500, 500)
	-- 标题底图
	ZBasePanel:create(parent, UI_GeniusWin_0059, 1, height-32, 120, -1, 500, 500)
	-- 标题
	ZImage:create(parent, "ui/wing/21.png", 25, height-30, -1, -1)

	-- 属性名称
	ZLabel:create(parent, LangGameString[2146], x, y, fsize, 1, 1) 	-- "生    命："
    ZLabel:create(parent, LangGameString[2143], x, y-oy, fsize, 1, 1) 	-- "攻    击："
    ZLabel:create(parent, LangGameString[2144], x, y-oy*2, fsize, 1, 1) -- "物理防御："
    ZLabel:create(parent, LangGameString[2145], x, y-oy*3, fsize, 1, 1) -- "精神防御："

    return parent
end

function WingGetWin:createPlayerModel( x, y )
	-- 人物带翅膀的形象
    local playerModel = ShowAvatar:create_wing_panel_avatar( x, y )
    return playerModel
end

function WingGetWin:createLeftPanel( width, height )
	local parent = ZBasePanel.new(nil, width, height).view

	local topBg = self:createAvatarModelPanel(width, 255)
	topBg:setPosition(0, 300)
	parent:addChild(topBg)

	-- 人物模型
	self.playerModel = self:createPlayerModel(120, 80)
	topBg:addChild(self.playerModel.avatar)

    -- 战斗力
    self.fightVal = ZXLabelAtlas:createWithString("50", UIResourcePath.FileLocate.normal .. "number")
	self.fightVal:setPosition(CCPointMake(120, 15))
	self.fightVal:setAnchorPoint(CCPointMake(0, 0))
	topBg:addChild(self.fightVal)

	local dwnBg = self:createAttrPanel(width, height - 255 - 5)
	dwnBg:setPosition(0, 0)
	parent:addChild(dwnBg)

	-- 左边领取按钮
	self.leftGetBtn = ZButton.new("ui/common/dan.png", "ui/common/dan.png")
	self.leftGetBtn.view:addTexWithFile(CLICK_STATE_DISABLE, "ui/common/dan_d.png")
	self.leftGetBtn:setPosition(40, 10)
	dwnBg:addChild(self.leftGetBtn.view)
	local upSkillFunc = function( )
		-- Instruction:handleUIComponentClick(instruct_comps.GET_GENIUS_BTN)
		print('-- leftGetBtn clicked --')
        local getWingFunc = function( )
			WingCC:req_get_wing(0)
		end
		getWingFunc()
		UIManager:destroy_window("wing_get_win")
	end
	self.leftGetBtn:setTouchClickFun(upSkillFunc)
	local btnSize = self.leftGetBtn.view:getSize()
	local txtImg = ZImage:create(self.leftGetBtn.view, "ui/wing/25.png", btnSize.width/2, btnSize.height/2, -1, -1)
	txtImg.view:setAnchorPoint(0.5, 0.5)

	-- 属性
    self.hp = ZLabel:create(dwnBg, "", x+90, y, 16, 1, 1)
    self.attack = ZLabel:create(dwnBg, "", x+90, y-oy, 16, 1, 1)
    self.phyDef = ZLabel:create(dwnBg, "", x+90, y-oy*2, 16, 1, 1)
    self.magDef = ZLabel:create(dwnBg, "", x+90, y-oy*3, 16, 1, 1)

	return parent
end

function WingGetWin:createRightPanel( width, height )
	local parent = ZBasePanel.new(nil, width, height).view

	local topBg = self:createAvatarModelPanel(width, 255)
	topBg:setPosition(0, 300)
	parent:addChild(topBg)

	-- 人物模型
	self.nexPlayerModel = self:createPlayerModel(120, 80)
	topBg:addChild(self.nexPlayerModel.avatar)

    -- 战斗力
    self.nexFightVal = ZXLabelAtlas:createWithString("800", UIResourcePath.FileLocate.normal .. "number")
	self.nexFightVal:setPosition(CCPointMake(120, 15))
	self.nexFightVal:setAnchorPoint(CCPointMake(0, 0))
	topBg:addChild(self.nexFightVal)

	ZImage:create(topBg, "ui/wing/24.png", 10, 50, -1, -1)

	local dwnBg = self:createAttrPanel(width, height - 255 - 5)
	dwnBg:setPosition(0, 0)
	parent:addChild(dwnBg)

	-- 右边充值按钮
	self.rechargeBtn = ZButton.new("ui/common/dan.png", "ui/common/dan.png")
	self.rechargeBtn.view:addTexWithFile(CLICK_STATE_DISABLE, "ui/common/dan_d.png")
	self.rechargeBtn:setPosition(40, 10)
	dwnBg:addChild(self.rechargeBtn.view, 10)
	local upSkillFunc = function( )
		print('-- rechargeBtn clicked --')
		GlobalFunc:chong_zhi_enter_fun()
	end
	self.rechargeBtn:setTouchClickFun(upSkillFunc)
	local btnSize = self.rechargeBtn.view:getSize()
	local txtImg = ZImage:create(self.rechargeBtn.view, "ui/wing/23.png", btnSize.width/2, btnSize.height/2, -1, -1)
	txtImg.view:setAnchorPoint(0.5, 0.5)
	txtImg.view:setScale(0.9)

	-- 属性
    self.nexHp = ZLabel:create(dwnBg, "", x+90, y, 16, 1, 1)
    self.nexAttack = ZLabel:create(dwnBg, "", x+90, y-oy, 16, 1, 1)
    self.nexPhyDef = ZLabel:create(dwnBg, "", x+90, y-oy*2, 16, 1, 1)
    self.nexMagDef = ZLabel:create(dwnBg, "", x+90, y-oy*3, 16, 1, 1)

    ZLabel:create(dwnBg, "#ce519cb特殊技能：", x, y-oy*4+10, 16, 1, 1)
    self.skillEffect = ZDialog:create( dwnBg, "技能效果：人物生命上限提升100%啊啊啊啊啊啊啊啊啊啊啊", x+90, y-oy*4+30, width-20-90, 40, 15 )
  	self.skillEffect:setAnchorPoint(0, 1)
  	self.skillEffect.view:setLineEmptySpace(2)

	-- 右边领取按钮
	self.rightGetBtn = ZButton.new("ui/common/dan.png", "ui/common/dan.png")
	self.rightGetBtn.view:addTexWithFile(CLICK_STATE_DISABLE, "ui/common/dan_d.png")
	self.rightGetBtn:setPosition(40, 10)
	self.rightGetBtn.view:setIsVisible(false)
	dwnBg:addChild(self.rightGetBtn.view, 10)
	local upSkillFunc = function( )
		print('-- rightGetBtn clicked --')
		local getWingFunc = function( )
			WingCC:req_get_wing(1)
		end
		getWingFunc()
		UIManager:destroy_window("wing_get_win")
	end
	self.rightGetBtn:setTouchClickFun(upSkillFunc)
	local btnSize = self.rightGetBtn.view:getSize()
	local txtImg = ZImage:create(self.rightGetBtn.view, "ui/wing/22.png", btnSize.width/2, btnSize.height/2, -1, -1)
	txtImg.view:setAnchorPoint(0.5, 0.5)

	return parent
end

function WingGetWin:updateLeftPanel( )
	local level = 1
	local stage = 1
	local star = 0

	-- 更新模型
	self.playerModel:update_wing(stage)
	self.playerModel:change_attri("body")

	-- 更新属性
	local attr = WingConfig:get_wing_attris_by_level(level)
	local attrAdd = WingModel:getAttrAdd(level, stage, star)
	self.hp:setText(string.format("#cfe8300%d + %d", attr[4], attrAdd[4]))
	self.attack:setText(string.format("#cfe8300%d + %d", attr[1], attrAdd[1]))
	self.phyDef:setText(string.format("#cfe8300%d + %d", attr[2], attrAdd[2]))
	self.magDef:setText(string.format("#cfe8300%d + %d", attr[3], attrAdd[3]))
end

function WingGetWin:updateRightPanel( )
	local level = WingConfig:getYbWingLevel()
	local stage = WingConfig:getYbWingStage()
	local star = WingConfig:getYbWingStar()

	-- 更新模型
	self.nexPlayerModel:update_wing(stage)
	self.nexPlayerModel:change_attri("body")

	-- 更新属性
	local attr = WingConfig:get_wing_attris_by_level(level)
	local attrAdd = WingModel:getAttrAdd(level, stage, star)
	self.nexHp:setText(string.format("#ce519cb%d + %d", attr[4], attrAdd[4]))
	self.nexAttack:setText(string.format("#ce519cb%d + %d", attr[1], attrAdd[1]))
	self.nexPhyDef:setText(string.format("#ce519cb%d + %d", attr[2], attrAdd[2]))
	self.nexMagDef:setText(string.format("#ce519cb%d + %d", attr[3], attrAdd[3]))

	local skillEffectTxt = WingSkillPage:getSkillDesc(1, 1)
	self.skillEffect:setText(string.format("#ce519cb%s", skillEffectTxt))

	local vipInfo = VIPModel:get_vip_info()
 	if vipInfo.all_yuanbao_value >= 1 then
		self.rechargeBtn.view:setIsVisible(false)
		self.rightGetBtn.view:setIsVisible(true)
 	else
		self.rechargeBtn.view:setIsVisible(true)
		self.rightGetBtn.view:setIsVisible(false)
 	end

 	local gotFree, gotVip = WingModel:getGotWingStatus()
 	print('-------------------gotFree, gotVip: ', gotFree, gotVip)
 	if gotFree then
 		self.leftGetBtn.view:setCurState(CLICK_STATE_DISABLE)
 	else
 		self.leftGetBtn.view:setCurState(CLICK_STATE_UP)
 	end
 	if gotVip then
 		self.rightGetBtn.view:setCurState(CLICK_STATE_DISABLE)
 	else
 		self.rightGetBtn.view:setCurState(CLICK_STATE_UP)
 	end
end

--
function WingGetWin:update( )
	self:updateLeftPanel()
	self:updateRightPanel()
end

-- 激活时更新数据
function WingGetWin:active( show )
	if show then
		self:update()
	end
end

-- 销毁窗体
function WingGetWin:destroy()
    Window.destroy(self)
end
