-- ElfinItemRightPage.lua
-- created by yongrui.liang on 2014-8-25
-- 升级装备右页面

super_class.ElfinItemRightPage()

function ElfinItemRightPage:__init( )
	self.pageList = {}
	-- 底板
    self.view = ZBasePanel.new(nil, 393, 565).view
	local parent = self.view

	-- 创建分页button
    local radioBtnGroup = CCRadioButtonGroup:buttonGroupWithFile( 338, 20, 58, 360, "" )
    parent:addChild(radioBtnGroup)
    self.radioBtnGroup = radioBtnGroup

    local enabledImg = UIResourcePath.FileLocate.common .. "xxk-1.png"
    local selectedImg = UIResourcePath.FileLocate.common .. "xxk-2.png"

	-- 探险按钮
    local exploreBtn = self:createRadioBtn( enabledImg, selectedImg, "ui/elfin/16.png", ElfinModel.EXPLORE_PAGE )
    exploreBtn:setPosition(0, 240)
    exploreBtn:setFlipX(true)
    radioBtnGroup:addGroup(exploreBtn)

    -- 探险背包按钮
    local exploreBagBtn = self:createRadioBtn( enabledImg, selectedImg, "ui/elfin/18.png", ElfinModel.EXPLORE_BAG_PAGE )
    exploreBagBtn:setPosition(0, 120)
    exploreBagBtn:setFlipX(true)
    radioBtnGroup:addGroup(exploreBagBtn)

    -- 升级装备按钮
    local lvUpBtn = self:createRadioBtn( enabledImg, selectedImg, "ui/elfin/20.png", ElfinModel.LV_UP_ITEM_PAGE )
    lvUpBtn:setPosition(0, 0)
    lvUpBtn:setFlipX(true)
    radioBtnGroup:addGroup(lvUpBtn)
end


function ElfinItemRightPage:createRadioBtn( enabledImg, selectedImg, txtImg, toPage )
	local wingBtn = CCRadioButton:radioButtonWithFile(0, 0, -1, -1, enabledImg)
    wingBtn:addTexWithFile( CLICK_STATE_DOWN, selectedImg)

    local btnImg = ZImage.new(txtImg).view
    btnImg:setPosition(15, 22)
    wingBtn:addChild(btnImg)

    local function btnFunc(eventType,x,y)
        if eventType ==  TOUCH_BEGAN then 
            return true
        elseif eventType == TOUCH_CLICK then
        	-- 转换页面
            ElfinModel:setCurElfinItemPage( toPage )

            local leftPage = ElfinModel:getCurLeftPage()
            if leftPage == ElfinModel.EXPLORE_STORAGE_PAGE and toPage ~= ElfinModel.EXPLORE_BAG_PAGE then
            	-- 如果当前左窗口是仓库页面，则跳转到正常的按钮页面
            	ElfinModel:changeLeftPage(ElfinModel.ELFIN_ITEM_LEFT_PAGE)
            end
            self:changePage( toPage )
            return true;
        elseif eventType == TOUCH_ENDED then
            return true;
        end
    end
    wingBtn:registerScriptHandler(btnFunc)

    return wingBtn
end

function ElfinItemRightPage:changePage( pageIndex )
	print('-- ElfinItemRightPage:changePage( pageIndex ) --', pageIndex)
    for k,v in pairs(self.pageList) do
        v.view:setIsVisible(false)
    end

    if pageIndex == ElfinModel.EXPLORE_PAGE then
    	-- 探险页面
    	if self.pageList[pageIndex] then
            self.pageList[pageIndex].view:setIsVisible(true)
        else
	        local page = Explore()
	        page.view:setPosition(0, 0)
	        self.view:addChild(page.view)
	        self.pageList[pageIndex] = page
	    end
        ElfinCC:req_explore_status()
    elseif pageIndex == ElfinModel.EXPLORE_BAG_PAGE then
    	-- 探险背包页面
    	if self.pageList[pageIndex] then
            self.pageList[pageIndex].view:setIsVisible(true)
        else
	        local page = ExploreBag()
	        page.view:setPosition(0, 0)
	        self.view:addChild(page.view)
	        self.pageList[pageIndex] = page
	    end
    elseif pageIndex == ElfinModel.LV_UP_ITEM_PAGE then
    	-- 升级装备页面
    	if self.pageList[pageIndex] then
            self.pageList[pageIndex].view:setIsVisible(true)
        else
	        local page = LvUpItem()
	        page.view:setPosition(0, 0)
	        self.view:addChild(page.view)
	        self.pageList[pageIndex] = page
	    end
        ElfinModel:updateLeftWin("selectedItem")
    end

	self.currentPage = self.pageList[pageIndex]
    if self.currentPage and self.currentPage.update then
        self.currentPage:update("all")
    end
end


function ElfinItemRightPage:update( updateType, param )
	print('-- ElfinItemRightPage:update( updateType ) --', updateType)
	if updateType == "all" then
		local curRightPage = ElfinModel:getCurElfinItemPage()
		self:changePage(curRightPage, param)
    elseif updateType == ElfinModel.LV_UP_ITEM_PAGE then
        self.radioBtnGroup:selectItem(2)
        self:changePage(updateType, param)
    else
        if self.currentPage and self.currentPage.update then
            self.currentPage:update(updateType, param)
        end
	end
end

function ElfinItemRightPage:active( show )
    if show then
    end
    if self.currentPage and self.currentPage.active then
        self.currentPage:active(show)
    end
end

function ElfinItemRightPage:destroy( )
	for k,v in pairs(self.pageList) do
		if v and v.destroy then
			v:destroy()
		end
	end
	self.pageList = {}
end