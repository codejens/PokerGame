-- WingRightWin.lua
-- created by yongrui.liang on 2014-8-18
-- 翅膀系统右窗口

super_class.WingRightWin(NormalStyleWindow)

-- 查看他人翅膀需要隐藏的东西
local _NO_OTHER_SHOW = {}

function WingRightWin:__init( )
	self.pageList = {}

	local bg = ZBasePanel.new(nil, 393, 565).view
    bg:setPosition(0, 0)
    self.view:addChild(bg)
    self.pageBg = bg
end

function WingRightWin:changePage( pageIndex )
    for k,v in pairs(self.pageList) do
        v.view:setIsVisible(false)
    end

    if self.pageList[pageIndex] then
    	self.pageList[pageIndex].view:setIsVisible(true)
    else
    	local page = nil
	    if pageIndex == WingModel.MINE_WING_INFO then
	    	-- 信息页面
            page = WingInfoPageRight()
            page.view:setPosition(28, 20)
	    elseif pageIndex == WingModel.WING_LEVEL_UP then
	    	-- 升级页面
            page = WingLvUpPageRight()
            page.view:setPosition(28, 20)
        elseif pageIndex == WingModel.WING_UPGRADE then
        	-- 升阶页面
        	page = WingUpgradePageRight()
        	page.view:setPosition(28, 20)
        elseif pageIndex == WingModel.WING_SHAPE then
        	-- 化形页面
        	page = WingShapePage()
        	page.view:setPosition(28, 20)
        elseif pageIndex == WingModel.WING_SKILL then
        	-- 技能页面
        	page = WingSkillPage()
        	page.view:setPosition(28, 20)
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
    WingModel:setCurRightPage(pageIndex)
end

function WingRightWin:update( updateType )
	print('-- WingRightWin:update --', updateType)
	if updateType == WingModel.MINE_WING_INFO then
		self:changePage(WingModel.MINE_WING_INFO)
	elseif updateType == WingModel.WING_LEVEL_UP then
		self:changePage(WingModel.WING_LEVEL_UP)
	elseif updateType == WingModel.WING_UPGRADE then
		self:changePage(WingModel.WING_UPGRADE)
	elseif updateType == WingModel.WING_SHAPE then
		self:changePage(WingModel.WING_SHAPE)
	elseif updateType == WingModel.WING_SKILL then
		self:changePage(WingModel.WING_SKILL)
	else
		if self.currentPage and self.currentPage.update then
			self.currentPage:update(updateType)
		end
	end
end

-- 如果是查看他人的翅膀，则隐藏一些东西
function WingRightWin:setIsShowOtherWing( showOther )
	for k,v in pairs(_NO_OTHER_SHOW) do
		if v then
			v:setIsVisible(not showOther)
		end
	end
end

function WingRightWin:active( show )
	print('-- WingRightWin:active --', show)
	if show then
		local curLeftPage = WingModel:getCurLeftPage( )
		self:changePage(curLeftPage)

		local showOther = WingModel:getIsShowOtherWing()
		self:setIsShowOtherWing(showOther)
		if self.currentPage and self.currentPage.setIsShowOtherWing then
			self.currentPage:setIsShowOtherWing(showOther)
		end
	end
end

function WingRightWin:destroy( )
	_NO_OTHER_SHOW = {}
	for k,v in pairs(self.pageList) do
		if v and v.destroy then
			v:destroy()
		end
	end
	Window.destroy(self)
end