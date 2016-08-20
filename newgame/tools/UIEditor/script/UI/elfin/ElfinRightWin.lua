-- ElfinRightWin.lua
-- created by yongrui.liang on 2014-8-26
-- 式神系统右窗口

super_class.ElfinRightWin(Window)

function ElfinRightWin:__init( )
	self.pageList = {}
end

function ElfinRightWin:changePage( pageIndex )
	print('-- ElfinRightWin:changePage( pageIndex ) --', pageIndex)
    for k,v in pairs(self.pageList) do
        v.view:setIsVisible(false)
    end

    if pageIndex == ElfinModel.ELFIN_LEVEL_RIGHT_PAGE then
    	-- 式神等级右页面
    	if self.pageList[pageIndex] then
            self.pageList[pageIndex].view:setIsVisible(true)
        else
	        local page = ElfinLevelRightPage()
	        page.view:setPosition(28, 20)
	        self.view:addChild(page.view)
	    	self.pageList[pageIndex] = page
	    end
    elseif pageIndex == ElfinModel.ELFIN_ITEM_RIGHT_PAGE then
    	-- 式神装备右页面
    	if self.pageList[pageIndex] then
            self.pageList[pageIndex].view:setIsVisible(true)
        else
	        local page = ElfinItemRightPage()
	        page.view:setPosition(28, 20)
	        self.view:addChild(page.view)
	    	self.pageList[pageIndex] = page
	    end
    elseif pageIndex == ElfinModel.ITEMSMELT_RIGHT_PAGE then
    	-- 装备熔炼右页面
    	if self.pageList[pageIndex] then
            self.pageList[pageIndex].view:setIsVisible(true)
        else
	    	local page = ItemSmeltRightPage()
	    	page.view:setPosition(28, 20)
	    	self.view:addChild(page.view)
	    	self.pageList[pageIndex] = page
	    end
    end

	self.currentPage = self.pageList[pageIndex]
    if self.currentPage and self.currentPage.update then
        self.currentPage:update("all")
    end

    ElfinModel:setCurRightPage(pageIndex)
end

function ElfinRightWin:update( updateType, param )
	print('-- ElfinRightWin:update --', updateType)
	if updateType == ElfinModel.ELFIN_LEVEL_LEFT_PAGE or updateType == ElfinModel.ELFIN_LEVEL_RIGHT_PAGE then
		self:changePage(ElfinModel.ELFIN_LEVEL_RIGHT_PAGE)
	elseif updateType == ElfinModel.ELFIN_ITEM_LEFT_PAGE or updateType == ElfinModel.ELFIN_ITEM_RIGHT_PAGE then
		self:changePage(ElfinModel.ELFIN_ITEM_RIGHT_PAGE)
	elseif updateType == ElfinModel.ITEM_SMELT_LEFT_PAGE or updateType == ElfinModel.ITEMSMELT_RIGHT_PAGE then
		self:changePage(ElfinModel.ITEMSMELT_RIGHT_PAGE)
	elseif updateType == ElfinModel.LV_UP_ITEM_PAGE then
		self:changePage(ElfinModel.ELFIN_ITEM_RIGHT_PAGE)
		self.currentPage:update(updateType, param)
	else
		if self.currentPage and self.currentPage.update then
			self.currentPage:update(updateType, param)
		end
	end
end

function ElfinRightWin:active( show )
	print("------------ElfinRightWin:active( show )-----", show)
	if show then
		self:changePage(ElfinModel.ELFIN_LEVEL_RIGHT_PAGE)
	end
	if self.currentPage and self.currentPage.active then
        self.currentPage:active(show)
    end
end

function ElfinRightWin:destroy( )
	for k,v in pairs(self.pageList) do
		if v and v.destroy then
			v:destroy()
		end
	end
	self.pageList = {}
	Window.destroy(self)
end
