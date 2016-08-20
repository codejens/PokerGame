-- WingLeftWin.lua
-- created by yongrui.liang on 2014-8-18
-- 翅膀系统左窗口

super_class.WingLeftWin(NormalStyleWindow)

-- 查看他人翅膀需要隐藏的东西
local _NO_OTHER_SHOW = {}

function WingLeftWin:__init( )
	local bg = ZBasePanel.new(nil, 340, 565).view
    bg:setPosition(79, 20)
    self.view:addChild(bg)
    self.pageBg = bg

    -- 创建分页button
    local radioBtnGroup = CCRadioButtonGroup:buttonGroupWithFile( 26, 210, 58, 360, "" )
    self:addChild(radioBtnGroup)
    self.radioBtnGroup = radioBtnGroup

    local enabledImg = UIResourcePath.FileLocate.common .. "xxk-1.png"
    local selectedImg = UIResourcePath.FileLocate.common .. "xxk-2.png"

    -- 翅膀信息按钮
    local wingInfoBtn = self:createRadioBtn( enabledImg, selectedImg, "ui/wing/9.png", WingModel.MINE_WING_INFO )
    wingInfoBtn:setPosition(0, 240)
    radioBtnGroup:addGroup(wingInfoBtn)

    -- 翅膀升级按钮
    local wingLvUpBtn = self:createRadioBtn( enabledImg, selectedImg, "ui/wing/10.png", WingModel.WING_LEVEL_UP )
    wingLvUpBtn:setPosition(0, 120)
    radioBtnGroup:addGroup(wingLvUpBtn)
    table.insert(_NO_OTHER_SHOW, wingLvUpBtn)

    -- 翅膀升阶按钮
    local wingUpgradeBtn = self:createRadioBtn( enabledImg, selectedImg, "ui/wing/11.png", WingModel.WING_UPGRADE )
    wingUpgradeBtn:setPosition(0, 0)
    radioBtnGroup:addGroup(wingUpgradeBtn)
    table.insert(_NO_OTHER_SHOW, wingUpgradeBtn)

    -- 记录每页，控制显示与隐藏
    self.pageList = {}
end

function WingLeftWin:createRadioBtn( enabledImg, selectedImg, txtImg, toPage )
	local wingBtn = CCRadioButton:radioButtonWithFile(0, 0, -1, -1, enabledImg)
    wingBtn:addTexWithFile( CLICK_STATE_DOWN, selectedImg)

    local btnImg = ZImage.new(txtImg).view
    btnImg:setPosition(22, 22)
    wingBtn:addChild(btnImg)

    local function btnFunc(eventType,x,y)
        if eventType ==  TOUCH_BEGAN then 
            return true
        elseif eventType == TOUCH_CLICK then
        	-- 转换页面
            WingModel:setCurLeftPage( toPage )
            self:changePage( toPage )
            return true;
        elseif eventType == TOUCH_ENDED then
            return true;
        end
    end
    wingBtn:registerScriptHandler(btnFunc)

    return wingBtn
end

function WingLeftWin:changePage( pageIndex )
	print('-- WingLeftWin:changePage( pageIndex ) --', pageIndex)
	-- if self.pageList[pageIndex] == self.currentPage then
 --        return
 --    end

    for k,v in pairs(self.pageList) do
        v.view:setIsVisible(false)
    end

    if self.pageList[pageIndex] then
    	self.pageList[pageIndex].view:setIsVisible(true)
    else
    	local page = nil
	    if pageIndex == WingModel.MINE_WING_INFO then
	    	-- 信息页面
            page = WingInfoPageLeft()
            page.view:setPosition(0, 0)
	    elseif pageIndex == WingModel.WING_LEVEL_UP then
	    	-- 升级页面
            page = WingLvUpPageLeft()
            page.view:setPosition(0, 0)
        elseif pageIndex == WingModel.WING_UPGRADE then
        	-- 升阶页面
        	page = WingUpgradePageLeft()
        	page.view:setPosition(0, 0)
	    end

	    if page then
            self.pageBg:addChild(page.view)
	    	self.pageList[pageIndex] = page
	    end
	end

	self.currentPage = self.pageList[pageIndex]

    if self.currentPage and self.currentPage.update then
        self.currentPage:update("all")
    end

    -- 转换右页面
    WingModel:changeRightPage( pageIndex )
end

-- 如果是查看他人的翅膀，则隐藏一些东西
function WingLeftWin:setIsShowOtherWing( showOther )
	for k,v in pairs(_NO_OTHER_SHOW) do
		if v then
			v:setIsVisible(not showOther)
		end
	end
end

function WingLeftWin:update( updateType )
	print('-- WingLeftWin:update --', updateType)
	if updateType == WingModel.MINE_WING_INFO or updateType == WingModel.OTHER_WING_INFO then
		self:changePage(WingModel.MINE_WING_INFO)
		self.radioBtnGroup:selectItem(0)
	elseif updateType == WingModel.WING_LEVEL_UP then
		self:changePage(WingModel.WING_LEVEL_UP)
		self.radioBtnGroup:selectItem(1)
	elseif updateType == WingModel.WING_UPGRADE then
		self:changePage(WingModel.WING_UPGRADE)
		self.radioBtnGroup:selectItem(2)
	else
		if self.currentPage and self.currentPage.update then
			self.currentPage:update(updateType)
		end
	end
end

function WingLeftWin:active( show )
	print('-- WingLeftWin:active --', show)
	if show then
		WingModel:initWingWinInfo( )
		self.currentPage = WingModel.MINE_WING_INFO
		self:changePage(WingModel.MINE_WING_INFO)

		-- WingModel:setIsShowOtherWing(true)  -- 测试用
		local showOther = WingModel:getIsShowOtherWing()
		self:setIsShowOtherWing(showOther)
		if self.currentPage and self.currentPage.setIsShowOtherWing then
			self.currentPage:setIsShowOtherWing(showOther)
		end
	else
		WingModel:setIsShowOtherWing(false)
	end
end

function WingLeftWin:destroy( )
    UIManager:destroy_window("wing_right_win")
	_NO_OTHER_SHOW = {}
	for k,v in pairs(self.pageList) do
		if v and v.destroy then
			v:destroy()
		end
	end
	WingModel:setIsShowOtherWing(false)
	Window.destroy(self)
end