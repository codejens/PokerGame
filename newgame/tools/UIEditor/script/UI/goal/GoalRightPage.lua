----------
----------
super_class.GoalRightPage(Window)
----------
----------
function GoalRightPage:__init( window_name, window_info )
	------------------
	self.task_title = ImageImage:create( nil, 0, 0, window_info.width, 35, 
										 UIResourcePath.FileLocate.achieveAndGoal .. "text_2.png", 
										 UIPIC_WINDOWS_BG, 600, 600 )
	local task_title_size = self.task_title:getSize()
	self.task_title:setPosition( 0, window_info.height - task_title_size.height - 10 )
	local task_title_pos = self.task_title:getPosition()
	------------------
	self.notic_info = Dialog:create( nil, 0, 0, window_info.width - 40, 80, ADD_LIST_DIR_UP, 100 )
	local notic_info_size = self.notic_info:getSize()
	self.notic_info:setPosition( 25, task_title_pos.y - notic_info_size.height -10 )
	local notic_info_pos = self.notic_info:getPosition()
	self.notic_info.view:setFontSize(14)
	------------------
	self.reware_title = ImageImage:create( nil, 0, notic_info_pos.y , window_info.width, 35, UIResourcePath.FileLocate.achieveAndGoal .. "text_3.png", UIResourcePath.FileLocate.achieveAndGoal .. "title_bg_02.png", 600, 600 )
	local reware_title_size = self.reware_title:getSize()
	self.reware_title:setPosition( 0, notic_info_pos.y - reware_title_size.height )
	------------------
	self.reware_button = ImageButton:create( nil, 0, 0, 130, 50, UIResourcePath.FileLocate.common .. "button_red.png", UIResourcePath.FileLocate.normal .. "get_award.png" )
	local reware_button_size = self.reware_button:getSize()
	self.reware_button:setPosition( 200, 10 )
	------------------
	self.reware_info = BasePanel:create( nil, 25, 10, 165, 70 )
	------------------
	self:addChild( self.task_title.view )
	self:addChild( self.notic_info.view )
	self:addChild( self.reware_title.view )
	self:addChild( self.reware_button.view )
	self:addChild( self.reware_info.view )
end
----------
----------
function GoalRightPage:init_page_info( notic_info, reware_item, image, state , fun)
	------------------
	if self.notic_info ~= nil and notic_info ~= nil then
		self.notic_info:setText(notic_info)
	end
	------------------
	if self.reware_info ~= nil and reware_item ~= nil then
		self.reware_info.view:removeAllChildrenWithCleanup( true )
		------------------
		if type(reware_item) == 'table' then
			local temp_x = 0
			local temp_y = self.reware_info.view:getSize().height
			for i = 1, #reware_item do 
				local item_size = reware_item[i].view:getSize()
				self.reware_info.view:addChild( reware_item[i].view )
				reware_item[i].view:setPosition( temp_x, (temp_y - item_size.height) / 2 )
				temp_x = temp_x + item_size.width
			end
		else
			self.reware_info.view:addChild( reware_item.view )
			local item_size = reware_item.view:getSize()
			reware_item.view:setPosition( 0, (temp_y - item_size.height) / 2 )
		end
		------------------
	end
	----------------
	if self.reware_button ~= nil then
		self.reware_button.view:setCurState( state )
		self.reware_button.image.view:setCurState( state )
		self.reware_button.image.view:setTexture( image )
		if fun ~= nil then
			self.reware_button:setTouchClickFun( fun )
		end
	end
end