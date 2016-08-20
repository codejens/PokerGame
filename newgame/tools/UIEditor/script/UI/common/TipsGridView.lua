-- Shan Lu
-- 一个用于排序的控件
-- 可以支持行列排序
-- 一般add函数结尾的hori表示是否横向排列
-- 排列完毕后调用autofitRow换行以及，当前行所有控件y轴居中
-- 并提供一般方法添加控件

super_class.TipsGridView(AbstractBasePanel)

--
function TipsGridView:__init( width, height, borderX, borderY, gapX, gapY )
	self.width  = width 							--控件大小
	self.height = height
	self.view = CCBasePanel:panelWithFile( 0, 0, width, height, '')
	self.borderX = borderX or 3						--留空	
	self.borderY = borderY or 3
	self.gapX = gapX or 3							--控件间隔
	self.gapY = gapY or 5
	self.contentHeight = self.borderY				--内容高度					
	self.lineWidth = self.borderX					--当前行宽
	self._current_row = {}							--当前行
	self._current_rowHeight = 0						--当前高
	local function _event( )
		return true
	end
	self.view:registerScriptHandler(_event);
end

--添加文字Label
function TipsGridView:addText(text, font_size, font_align,hori)
	if text == '' then
		return
	end
	font_align = font_align or ALIGN_LEFT
	local component = CCZXLabel:labelWithText(self.lineWidth,self.contentHeight,
											  text,
											  font_size,
											  font_align);
	if hori then
		local cs = component:getSize()
		local w = cs.width
		local h = cs.height

		self.lineWidth = self.lineWidth + w + self.gapY
		self._current_row[#self._current_row+1] = component
		if h > self._current_rowHeight then
			self._current_rowHeight = h
		end
		component:setAnchorPoint(CCPointMake(0.0,0.5))
	else
		local cs = component:getSize()
		local w = cs.width
		local h = cs.height
		self.contentHeight = self.contentHeight + h + self.gapY
		self.lineWidth = self.borderX
	end

	self.view:addChild(component)
end

--添加文字Dialog
function TipsGridView:addDialog(text,font_size,hori)
	if text == '' then
		return
	end
	local _maxnum = 10
	local _height = 20
	local component = CCDialogEx:dialogWithFile(self.lineWidth,self.contentHeight,
											  	self.width - self.borderX, _height, 
											  	_maxnum, "", 
											  	TYPE_VERTICAL ,
											  	ADD_LIST_DIR_UP);
	component:setFontSize(font_size);
	component:setText(text);

	self:addComponent(component,hori)
end

--添加Image
function TipsGridView:addImage(image, width, height, hori)
	--print('>>>>>>>>>',self.contentHeight)
	local component = CCZXImage:imageWithFile( self.lineWidth,self.contentHeight,
											   width,height,
											   image)
	self:addComponent(component,hori)
end

--添加分割行，自动匹配宽度
function TipsGridView:addStaticLine(image, height, hori)
	self:addImage(image,self.width - self.borderX,height,hori)
end

--加入一个站位offset
function TipsGridView:addSpacer(x,y)
	self.lineWidth = self.lineWidth + x
	self.contentHeight = self.contentHeight + y
end

--添加一个控件
function TipsGridView:addComponent(component,hori)
	component:setPosition(self.lineWidth,self.contentHeight)
	if hori then
		local cs = component:getSize()
		local w = cs.width
		local h = cs.height

		self.lineWidth = self.lineWidth + w + self.gapY
		self._current_row[#self._current_row+1] = component
		if h > self._current_rowHeight then
			self._current_rowHeight = h
		end
		component:setAnchorPoint(0.0,0.5)
	else
		local cs = component:getSize()
		local w = cs.width
		local h = cs.height
		self.contentHeight = self.contentHeight + h + self.gapY
		self.lineWidth = self.borderX
	end
	self.view:addChild(component)
	return component
end

--增加一个美术文字
function TipsGridView:addImageNumber(number, ftype, width, height ,hori)
	local component = ImageNumber:create(number,ftype,width,height).view
	component:setPosition(self.lineWidth,self.contentHeight)
	if hori then
		local cs = component:getContentSize()
		local w = cs.width
		local h = cs.height

		self.lineWidth = self.lineWidth + w + self.gapY
		self._current_row[#self._current_row+1] = component
		if h > self._current_rowHeight then
			self._current_rowHeight = h
		end
		component:setAnchorPoint(CCPointMake(0.0,0.5))
	else
		local cs = component:getSize()
		local w = cs.width
		local h = cs.height
		self.contentHeight = self.contentHeight + h + self.gapY
		self.lineWidth = self.borderX
	end
	self.view:addChild(component)
end

--增加一个slot
function TipsGridView:addSlot(size, icon, hori)
	local slot = SlotBase(size,size,UIPIC_ITEMSLOT)
	slot:set_icon_texture(icon)
	local component = slot.view 
	component:setPosition(self.lineWidth,self.contentHeight)
	self:addComponent(component,hori)
	return component
end

function TipsGridView:addSlotItem( itemId, hori )
	local slot = SlotItem(64, 64)
	slot:set_icon_bg_texture( UIPIC_ITEMSLOT, -8.5, -8.5, 81, 81 )   -- 背框
	slot:set_icon (itemId)
	slot:set_color_frame( itemId, -2, -2, 68, 68 )    -- 边框颜色
	local component = slot.view 
	component:setPosition(self.lineWidth,self.contentHeight)
	self:addComponent(component,hori)
	return component
end

function TipsGridView:addAnimation(fileName,width,height,action)

	local component = MUtils:create_animation(self.lineWidth,self.contentHeight,
											  fileName,action, height * 0.5 )
	if hori then
		self.lineWidth = self.lineWidth + width + self.gapY
		self._current_row[#self._current_row+1] = component
		if h > self._current_rowHeight then
			self._current_rowHeight = h
		end
	else
		self.contentHeight = self.contentHeight + height + self.gapY
		self.lineWidth = self.borderX
	end
	component:setPositionX(width*0.5)
	self.view:addChild(component)
	return component
end

function TipsGridView:finish()
	self.view:setSize(self.width, self.borderY + self.contentHeight + self.borderY)
end

function TipsGridView:destroy()

end

function TipsGridView:autofitRow()
	local y = self._current_rowHeight * 0.5
	for k,v in ipairs(self._current_row) do
		v:setPositionY(v:getPositionY() + y)
	end
	self.contentHeight = self.contentHeight + self._current_rowHeight + self.gapY
	self.lineWidth = self.borderX

	self._current_row = {}
	self._current_rowHeight = 0
end