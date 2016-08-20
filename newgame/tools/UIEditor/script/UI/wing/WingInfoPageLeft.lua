-- WingInfoPageLeft.lua
-- created by yongrui.liang on 2014-8-18
-- 翅膀系统信息左页面

super_class.WingInfoPageLeft()

-- 查看他人翅膀需要隐藏的东西
local _NO_OTHER_SHOW = {}

local skillNumPerPage = 3

function WingInfoPageLeft:__init( )
	self.skillItemList = {}

	-- 底板
    self.view = ZBasePanel.new(UIPIC_GRID_nine_grid_bg3, 340, 565).view
	local panel = self.view

    local upPanel = self:createUpPanel(320+10, 395+10)
    upPanel:setPosition(5, 160-5)
    panel:addChild(upPanel)

    local dwnPanel = self:createDwnPanel(320+4, 140+4)
    dwnPanel:setPosition(8, 8)
    panel:addChild(dwnPanel)
end

function WingInfoPageLeft:createUpPanel( width, height )
	local parent = ZBasePanel.new(nil, width, height).view
	local size = parent:getSize()

	ZBasePanel:create(parent, "ui/geniues/genius_bg6.png", 3, 3, size.width-6, size.height-6, 0, 0)
	ZBasePanel:create(parent, "ui/geniues/genius_bg4.png", 50, 100, -1, -1, 500, 500)

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

	-- 化形按钮
	local changeLookBtn = ZButton.new("ui/wing/1.png", "ui/wing/1.png")
	changeLookBtn:setPosition(20, 12)
	parent:addChild(changeLookBtn.view)
	local changeLookFunc = function( )
		print('-- changeLookFunc clicked --')
		-- 转换右页面
	    WingModel:changeRightPage( WingModel.WING_SHAPE )
	end
	changeLookBtn:setTouchClickFun(changeLookFunc)
	local btnSize = changeLookBtn.view:getSize()
	local txtImg = ZImage:create(changeLookBtn.view, "ui/wing/3.png", btnSize.width/2, btnSize.height/2, -1, -1)
	txtImg.view:setAnchorPoint(0.5, 0.5)
	table.insert(_NO_OTHER_SHOW, changeLookBtn.view)

	-- 炫耀按钮
	local showBtn = ZButton.new("ui/wing/1.png", "ui/wing/1.png")
	showBtn:setPosition(size.width-70-20, 12)
	parent:addChild(showBtn.view)
	local showFunc = function( )
		print('-- showFunc clicked --')
		WingModel:send_wing_to_char( )
	end
	showBtn:setTouchClickFun(showFunc)
	local btnSize = showBtn.view:getSize()
	local txtImg = ZImage:create(showBtn.view, "ui/wing/2.png", btnSize.width/2, btnSize.height/2, -1, -1)
	txtImg.view:setAnchorPoint(0.5, 0.5)
	table.insert(_NO_OTHER_SHOW, showBtn.view)

	-- 升级技能按钮
	local upSkillBtn = ZButton.new("ui/common/dan.png", "ui/common/dan.png")
	upSkillBtn:setPosition(92, 60)
	parent:addChild(upSkillBtn.view)
	local upSkillFunc = function( )
		print('-- upSkillFunc clicked --')
		-- 转换右页面
		WingModel:setCurRightPage(WingModel.WING_SKILL)
	    WingModel:changeRightPage( WingModel.WING_SKILL )
	end
	upSkillBtn:setTouchClickFun(upSkillFunc)
	local btnSize = upSkillBtn.view:getSize()
	local txtImg = ZImage:create(upSkillBtn.view, "ui/wing/4.png", btnSize.width/2, btnSize.height/2, -1, -1)
	txtImg.view:setAnchorPoint(0.5, 0.5)
	table.insert(_NO_OTHER_SHOW, upSkillBtn.view)

	-- 人物模型
	self.playerModel = self:createPlayerModel(170, 175)
	parent:addChild(self.playerModel.avatar)

	return parent
end

-- 创建人物模型
function WingInfoPageLeft:createPlayerModel( x, y )
	-- 人物带翅膀的形象
    local playerModel = ShowAvatar:create_wing_panel_avatar( x, y )

    return playerModel
end

-- 更新上面板
function WingInfoPageLeft:updateUpPanel( )
	-- 更新人物模型
	self:updatePlayerModel()
end

-- 更新人物模型
function WingInfoPageLeft:updatePlayerModel( )
	local modelID = nil
	local isShowOther = WingModel:getIsShowOtherWing()
	if isShowOther then
		-- 判断是否是其他人的翅膀
		local otherWingData = WingModel:getOtherWingData()
		modelID = otherWingData.modelId
	else
		modelID = WingModel:get_curr_modelId()
	end
	self.playerModel:update_wing(modelID)
	self.playerModel:change_attri("body")
end

function WingInfoPageLeft:createDwnPanel( width, height )
	local parent = ZBasePanel.new(nil, width, height).view
	local size = parent:getSize()

	ZBasePanel:create(parent, "", 0, 0, size.width, size.height, 500, 500)

	local titleBg = ZImage:create(parent, "ui/transform/new24.png", size.width/2, size.height-21, -1, -1, 0, 500, 500)
    titleBg.view:setAnchorPoint(0.5, 0.5)

    local title = ZImage:create(parent, "ui/wing/5.png", size.width/2, size.height-24, -1, -1, 0, 500, 500)
    title.view:setAnchorPoint(0.5, 0.5)

    self.skillScroll = self:createSkillScrollView(parent)

	return parent
end

-- 更新下面板
function WingInfoPageLeft:updateDwnPanel( )
	local dataList = WingConfig:getWingSkillIds()
	self.skillScroll:refresh(dataList)
end

-- 创建一个技能组件
function WingInfoPageLeft:createSkillItem( index )
	local SkillItem = ZBasePanel.new(nil, 70, 70)
	local item = MUtils:create_slot_item(SkillItem.view, UIPIC_ITEMSLOT, 3, 3, 72, 72, nil, nil)
	item.view:setScale(64/72)

	-- 供外部调用的更新技能组件函数
	SkillItem.update = function( index )
		local itemIcon = WingConfig:get_wing_skill_icon_by_id( index )
		item:set_icon_texture( itemIcon )
        item:set_select_effect_state(false)
        local selected = WingModel:getSelectedWingSkill()
        if selected == index then
        	-- 选中特效
        	SlotEffectManager.play_effect_by_slot_item(item):setPosition(CCPointMake(24, 24))
        elseif math.abs(selected-index) >= skillNumPerPage then
        	SlotEffectManager.stop_current_effect()
        end

        -- 更新是否开启状态
		local stage = 0
		local isShowOther = WingModel:getIsShowOtherWing()
		if isShowOther then
			-- 判断是否是其他人的翅膀
			local otherWingData = WingModel:getOtherWingData()
			stage = otherWingData.stage
		else
			stage = WingModel:get_curr_wing_stage()
		end
		local openSkill = WingModel:getOpenSkillByStage(stage)
		if openSkill[index] then
			item:set_icon_light_color()
		else 
			item:set_icon_dead_color()
		end

		-- 点击触发函数
		item:set_click_event( function( ... )
			WingModel:setSelectedWingSkill(index)
			SlotEffectManager.play_effect_by_slot_item(item):setPosition(CCPointMake(24, 24))

			local rightPage = WingModel:getCurRightPage()
			if rightPage == WingModel.WING_SKILL then
				-- 更新右窗口
				WingModel:changeRightPage(WingModel.WING_SKILL)
			else
				-- 显示Tips
				local wingData = nil
				local isShowOther = WingModel:getIsShowOtherWing()
				if isShowOther then
					wingData = WingModel:getOtherWingData()
				else
					wingData = WingModel:get_wing_item_data()
				end
				wingData.skills[index].level = wingData.skills_level[index]
				wingData.skills[index].skillId = index
				TipsModel:show_wing_skill_tip(480, 480/2, wingData.skills[index])
			end
        end )
	end

	return SkillItem
end

-- 创建一个滚动的技能栏
function WingInfoPageLeft:createSkillScrollView(parent)
	local size = parent:getSize()

	local createItem = function( index, newComp )
		if not newComp then
			print('-- create newComp --')
			newComp = self:createSkillItem(index)
			newComp.update(index)
		else
			print('-- update newComp --')
			newComp.update(index)
		end
		return newComp
	end
	
	local skillIDs = WingConfig:getWingSkillIds( )
	local skillScroll = TouchListHorizontal(56, 20, 210, 70, 70, 10)
	skillScroll:BuildList(70, 10, skillNumPerPage, skillIDs, createItem )
	parent:addChild(skillScroll.view)

    local function leftBtnFunc()
        print('-- leftBtn clicked --')
        local leftIndex = skillScroll:getLeftIndex()
        if leftIndex > 1 then
        	if leftIndex - 1 > 0 then
        		skillScroll:setIndex(leftIndex-1)
        	else
        		skillScroll:setIndex(1)
        	end
        else
        	GlobalFunc:create_screen_notic( "当前是第一页" )
        end
    end
    local leftBtn = ZButton:create(parent, "ui/common/an_zuo.png", leftBtnFunc , 0, 22, -1, -1)
    
    local function rightBtnFunc()
        print('-- rightBtn clicked --')
        local skillSum = #skillIDs
        local leftIndex = skillScroll:getLeftIndex()
        if leftIndex <= skillSum-skillNumPerPage then
			skillScroll:setIndex(leftIndex+1)
        else
        	GlobalFunc:create_screen_notic( "当前是最后一页" )
        end
    end
    local rightBtn = ZButton:create(parent, "ui/common/an_you.png",rightBtnFunc, size.width-45, 22, -1, -1 )

	return skillScroll
end

function WingInfoPageLeft:update( updateType )
	print('-- WingInfoPageLeft:update( updateType ) --', updateType)
	if updateType == "all" then
		self:updateUpPanel()
		self:updateDwnPanel()
	end
end

-- 如果是查看他人的翅膀，则隐藏一些东西
function WingInfoPageLeft:setIsShowOtherWing( showOther )
	for k,v in pairs(_NO_OTHER_SHOW) do
		if v then
			v:setIsVisible(not showOther)
		end
	end
end

function WingInfoPageLeft:destroy( )
	if self.skillScroll and self.skillScroll.destroy then
		self.skillScroll:destroy()
	end

	_NO_OTHER_SHOW = {}
end