super_class.SIntroducePanel(BaseEditWin)

local _refWidth =  UIScreenPos.relativeWidth
local _refHeight = UIScreenPos.relativeHeight


-- function SIntroducePanel:__init(view,layout)
-- 	STouchBase.__init(self,view,layout)
-- end

-- 构造
function SIntroducePanel:__init()
	self.scrollTab = {}
	self:initTextScroll()
	self.curJobIndex = 1


	local function cb(eventType)
		-- printc("ccccccbbbbbbb", 14)
		if eventType == TOUCH_BEGAN then
			return false
		elseif eventType == TOUCH_MOVED then
			return false
		elseif eventType == TOUCH_ENDED then
			self.view:setIsVisible(false)
			return false
		end
	end

	self.rootPanel.view:registerScriptHandler(cb)
end

function SIntroducePanel:initTextScroll()
	local tab = {[1] = {height = 100 + 100},
				 [2] = {height = 166 - 5},
				 [3] = {height = 81},}
	for k = 1, 3 do
		local scroll = CCScroll:scrollWithFile(90 + 5, 100, 330 + 20 + 60, tab[k].height, 1, "",TYPE_HORIZONTAL)
		local function scrollfun(eventType, args, msg_id)
	    	if eventType == nil or args == nil or msg_id == nil then
	    		return
	    	end
	    	if eventType == TOUCH_BEGAN then
	    		return true
	    	elseif eventType == TOUCH_MOVED then
	    		return true
	    	elseif eventType == TOUCH_ENDED then
	    		return true
	    	elseif eventType == SCROLL_CREATE_ITEM then
	    		local temparg = Utils:Split_old(args, ":")
	    		local x = temparg[1] -- 行
	    		local y = temparg[2] -- 列
	    		local index = x + 1
	    		print("index:",index)
	    		-- local row = CCBasePanel:panelWithFile(5,0, 340, 70, "sui/common/item_sld.png", 500, 500)
	    		-- local row = CCBasePanel:panelWithFile(5,0, 340, 70, "", 500, 500)
	    		local row = self:create_content_row(k)
	    		scroll:addItem(row)
		    	scroll:refresh()
	    		return false
	    	end
	    end

	    scroll:setGapSize(0)
	    scroll:registerScriptHandler(scrollfun)
	    scroll:refresh()
	    self:addChild(scroll, k)
	    self.scrollTab[k] = scroll
	end
end

function SIntroducePanel:create_content_row(index)
	-- local panel =  CCBasePanel:panelWithFile(5,0, 340, 70, "", 500, 500)

	-- local dialog = CCDialog:dialogWithFile( 0, 50,280, 500, 8,"sui/common/item_sld.png", TYPE_HORIZONTAL,ADD_LIST_DIR_UP)
	-- local dialog = CCDialog:dialogWithFile( 0, 0,305, 500, 8,"", TYPE_HORIZONTAL,ADD_LIST_DIR_UP)
	local dialog = CCDialogEx:dialogWithFile( 0, 0, 305 + 10 + 30 + 10 , 500, 50, nil, 1 ,ADD_LIST_DIR_UP)
	if self.curJobIndex == nil then
		self.curJobIndex = 1
	end

	-- if self.curJobIndex == 1 then
	-- 	-- dialog:setText("11111111111111阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿巴巴巴巴巴巴巴巴巴巴")
	-- 	dialog:setText(introduce_config[self.curJobIndex][1])
	-- elseif self.curJobIndex == 2 then
	-- 	-- dialog:setText("222222222222222阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿巴巴巴巴巴巴巴巴巴巴")
	-- 	dialog:setText(introduce_config[self.curJobIndex][2])
	-- else
	-- 	dialog:setText(introduce_config[self.curJobIndex][3])	
	-- 	-- dialog:setText("3333333333333333阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿阿巴巴巴巴巴巴巴巴巴巴")
	-- end

	-- printc("self.curJobIndex============", self.curJobIndex, index, 14)
	if index == 1 then
		dialog:setText(introduce_config[self.curJobIndex][1])
	elseif index == 2 then
		dialog:setText(introduce_config[self.curJobIndex][2])
	else
		dialog:setText(introduce_config[self.curJobIndex][3])
	end


	dialog:setFontSize(22)
	-- panel:addChild(dialog)

	local size = dialog:getSize()
	local size2 = dialog:getInfoSize()
	-- printc("size=========>>>", size.width, size.height, size2.width, size2.height, 14)
	dialog:setSize(size2.width, size2.height)

	-- return panel
	return dialog
end

function SIntroducePanel:addChild(node, index)
	local x, y = 0, 0
	if index == 1 then
		y = self.titleBg3.view:getPositionY()
	elseif index == 2 then
		y = self.titleBg2.view:getPositionY()
	else
		y = self.titleBg1.view:getPositionY()
	end
	-- node:setAnchorPoint(0, 1)

	local height = node:getSize().height
	node:setPositionY(y - 5 - height)
	self.bgPanel:addChild(node)
end

function SIntroducePanel:save_widget()
	
	self.titleBg1 = self:get_widget_by_name("img_4")

	self.titleBg2 = self:get_widget_by_name("img_3")

	self.titleBg3 = self:get_widget_by_name("img_2")

	self.bgPanel = self:get_widget_by_name("panel_1")
	self.bgPanel:setAnchorPoint(0.5, 0.5)
	self.bgPanel:setPosition(_refWidth(0.5), _refHeight(0.5))

	self.rootPanel = self:get_widget_by_name("win_root")
	self.rootPanel.view:setSize(_refWidth(1) + 500, _refHeight(1) + 500)

	-- self.uiroot = self:get_widget_by_name("ui_root")
	-- self.uiroot.view:setSize(_refWidth(1) + 500, _refHeight(1) + 500)
	
	local function  cb( eventType)
		if eventType == TOUCH_ENDED then
			return false
		end
	end


	self.blackBg = self:get_widget_by_name("panel_2")
	self.blackBg:setSize(_refWidth(1.1), _refHeight(1.1))
	self.blackBg:setPosition(-10, -10)
	self.blackBg.view:registerScriptHandler(cb)

end

-- 注销
function SIntroducePanel:destroy()
	BaseEditWin.destroy(self)
end

function SIntroducePanel:update(index)
	self.curJobIndex = index
    
    -- printc("self.curJobIndex==========", self.curJobIndex, 14)

	for k = 1, 3 do
		local scroll = self.scrollTab[k]
		if scroll then
			scroll:clear()
			scroll:setMaxNum(1)
			scroll:refresh()
		end
	end
end
 
function SIntroducePanel:action()

	local moveTo = CCMoveTo:actionWithDuration(0.3,CCPoint(_refWidth(0.5), _refHeight(0.5)))
	self.bgPanel.view:setPositionY(_refHeight(1.5))
	self.bgPanel:runAction(moveTo)
end
