-- ElfinLeftWin.lua
-- created by yongrui.liang on 2014-8-26
-- 式神系统左窗口

super_class.ElfinLeftWin(Window)

function ElfinLeftWin:__init( )
    -- 记录每页，控制显示与隐藏
    self.pageList = {}

	local bgPanel = ZBasePanel.new(nil, 393, 565)
    bgPanel:setPosition(0, 0)
    self.view:addChild(bgPanel.view)

    -- 有3个分页按钮的panel
    self.normalPanel = self:createNomalPanel(393, 565)
    self.normalPanel:setPosition(26, 20)
    self.view:addChild(self.normalPanel)

    -- 探险仓库panel
    self.otherPanel = ZBasePanel.new(nil, 393, 565).view
    self.otherPanel:setPosition(26, 20)
    self.view:addChild(self.otherPanel)
    self.colseStorageBtn = self:createCloseStorageBtn()

    -- 式神信息panel
    self.infoPanel = self:createInfoPanel(393, 565)
    self.infoPanel:setPosition(26, 20)
    self.view:addChild(self.infoPanel)
end

function ElfinLeftWin:createCloseStorageBtn()
    local closeFun = function( )
        self.colseStorageBtn.view:setIsVisible(false)
        ElfinModel:changeLeftPage(ElfinModel.ELFIN_ITEM_LEFT_PAGE)
    end
    local colseStorageBtn = ZButton:create(self.view, "ui/common/close_btn_z.png", closeFun,0,0,60,60,999+1);
    local btnSize = colseStorageBtn:getSize()
    local size = self.view:getSize()
    colseStorageBtn:setPosition( size.width - btnSize.width - 6, size.height - btnSize.height - 1 )
    return colseStorageBtn
end

function ElfinLeftWin:createNomalPanel( width, height )
	local parent = ZBasePanel.new(nil, width, height).view

	-- 创建分页button
    local radioBtnGroup = CCRadioButtonGroup:buttonGroupWithFile( 0, 190, 58, 360, "" )
    parent:addChild(radioBtnGroup)
    self.normalRadioBtnGroup = radioBtnGroup

    local enabledImg = UIResourcePath.FileLocate.common .. "xxk-1.png"
    local selectedImg = UIResourcePath.FileLocate.common .. "xxk-2.png"

	-- 式神等级按钮
    local elfinLvBtn = self:createRadioBtn( enabledImg, selectedImg, "ui/elfin/1.png", ElfinModel.ELFIN_LEVEL_LEFT_PAGE )
    elfinLvBtn:setPosition(0, 240)
    radioBtnGroup:addGroup(elfinLvBtn)

    -- 式神装备按钮
    local elfinItemBtn = self:createRadioBtn( enabledImg, selectedImg, "ui/elfin/3.png", ElfinModel.ELFIN_ITEM_LEFT_PAGE )
    elfinItemBtn:setPosition(0, 120)
    radioBtnGroup:addGroup(elfinItemBtn)

    -- 装备熔炼按钮
    local itemSmeltBtn = self:createRadioBtn( enabledImg, selectedImg, "ui/elfin/5.png", ElfinModel.ITEM_SMELT_LEFT_PAGE )
    itemSmeltBtn:setPosition(0, 0)
    radioBtnGroup:addGroup(itemSmeltBtn)

    return parent
end

function ElfinLeftWin:createInfoPanel( width, height )
    local parent = ZBasePanel.new(nil, width, height).view

    -- 创建分页button
    local radioBtnGroup = CCRadioButtonGroup:buttonGroupWithFile( 0, 190, 58, 360, "" )
    parent:addChild(radioBtnGroup)

    local enabledImg = UIResourcePath.FileLocate.common .. "xxk-1.png"
    local selectedImg = UIResourcePath.FileLocate.common .. "xxk-2.png"

    -- 式神信息按钮
    local elfinInfoBtn = self:createRadioBtn( enabledImg, selectedImg, "ui/elfin/7.png", ElfinModel.ELFIN_INFO_PAGE )
    elfinInfoBtn:setPosition(0, 240)
    radioBtnGroup:addGroup(elfinInfoBtn)

    return parent
end

function ElfinLeftWin:createRadioBtn( enabledImg, selectedImg, txtImg, toPage )
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
            ElfinModel:setCurLeftPage( toPage )
            self:changePage( toPage )
            return true;
        elseif eventType == TOUCH_ENDED then
            return true;
        end
    end
    wingBtn:registerScriptHandler(btnFunc)

    return wingBtn
end

function ElfinLeftWin:changePage( pageIndex )
	print('-- ElfinLeftWin:changePage( pageIndex ) --', pageIndex)
    for k,v in pairs(self.pageList) do
        v.view:setIsVisible(false)
    end
    self.normalPanel:setIsVisible(false)
    self.otherPanel:setIsVisible(false)
    self.infoPanel:setIsVisible(false)
    self.colseStorageBtn.view:setIsVisible(false)

    if pageIndex == ElfinModel.ELFIN_LEVEL_LEFT_PAGE then
    	-- 式神等级页面
    	self.normalPanel:setIsVisible(true)
    	if self.pageList[pageIndex] then
            self.pageList[pageIndex].view:setIsVisible(true)
        else
	        local page = ElfinLevelLeftPage()
	        page.view:setPosition(56, 0)
	        self.normalPanel:addChild(page.view)
	        self.pageList[pageIndex] = page
	    end
	    -- 转换右页面
	    ElfinModel:changeRightPage( pageIndex )
    elseif pageIndex == ElfinModel.ELFIN_ITEM_LEFT_PAGE then
    	-- 式神装备页面
        self.normalPanel:setIsVisible(true)
    	if self.pageList[pageIndex] then
            self.pageList[pageIndex].view:setIsVisible(true)
        else
	        local page = ElfinItemLeftPage()
	        page.view:setPosition(56, 0)
	        self.normalPanel:addChild(page.view)
	        self.pageList[pageIndex] = page
	    end
	    -- 转换右页面
	    ElfinModel:changeRightPage( pageIndex )
    elseif pageIndex == ElfinModel.ITEM_SMELT_LEFT_PAGE then
    	-- 装备熔炼页面
    	self.normalPanel:setIsVisible(true)
    	if self.pageList[pageIndex] then
            self.pageList[pageIndex].view:setIsVisible(true)
        else
	        local page = ItemSmeltLeftPage()
	        page.view:setPosition(56, 0)
	        self.normalPanel:addChild(page.view)
	        self.pageList[pageIndex] = page
	    end
	    -- 转换右页面
	    --ElfinModel:changeRightPage( pageIndex )
	elseif pageIndex == ElfinModel.EXPLORE_STORAGE_PAGE then
		-- 探险仓库
		self.otherPanel:setIsVisible(true)
        self.colseStorageBtn.view:setIsVisible(true)
		if self.pageList[pageIndex] then
			self.pageList[pageIndex].view:setIsVisible(true)
		else
			local page = ExploreStorage()
			page.view:setPosition(0, 0)
			self.otherPanel:addChild(page.view)
			self.pageList[pageIndex] = page
		end
		-- 本来就是右页面点进来的，所以不用转换右页面
    elseif pageIndex == ElfinModel.ELFIN_INFO_PAGE then
        -- 式神信息页面
        self.infoPanel:setIsVisible(true)
        if self.pageList[pageIndex] then
            self.pageList[pageIndex].view:setIsVisible(true)
        else
            local page = ElfinInfoPage()
            page.view:setPosition(56, 0)
            self.infoPanel:addChild(page.view)
            self.pageList[pageIndex] = page
        end
        -- 只有左页面，所以不用转换右页面
    end

	self.currentPage = self.pageList[pageIndex]
    if self.currentPage and self.currentPage.update then
        self.currentPage:update("all")
    end
end

function ElfinLeftWin:update( updateType, param )
    print("--- ElfinLeftWin:update: ", updateType)
	if updateType == ElfinModel.EXPLORE_STORAGE_PAGE then
		self:changePage(updateType)
	elseif updateType == ElfinModel.ELFIN_ITEM_LEFT_PAGE then
        self.normalRadioBtnGroup:selectItem(1)
		self:changePage(updateType)
	elseif updateType == ElfinModel.ITEM_SMELT_LEFT_PAGE then
        self.normalRadioBtnGroup:selectItem(2)
		self:changePage(updateType)
	elseif updateType == ElfinModel.ELFIN_LEVEL_LEFT_PAGE then
        self.normalRadioBtnGroup:selectItem(0)
		self:changePage(updateType)
    elseif updateType == ElfinModel.ELFIN_INFO_PAGE then
        self:changePage(updateType)
	else
		if self.currentPage and self.currentPage.update then
			self.currentPage:update(updateType, param)
		end
	end
end

function ElfinLeftWin:active( show )
	if show then
		ElfinModel:initElfinWinInfo()

        if not ElfinModel:getOtherElfinData() then
    		self.currentPage = ElfinModel.ELFIN_LEVEL_LEFT_PAGE
    		self:changePage(ElfinModel.ELFIN_LEVEL_LEFT_PAGE)
        end
	end
end

function ElfinLeftWin:destroy( )
	for k,v in pairs(self.pageList) do
		if v and v.destroy then
			v:destroy()
		end
	end
	self.pageList = {}
    ElfinModel:setOtherElfinData(nil)
    UIManager:destroy_window("elfin_right_win")
	Window.destroy(self)
end
