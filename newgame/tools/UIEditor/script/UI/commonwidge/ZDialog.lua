---------HJH
---------2012-2-15
---------
require "UI/commonwidge/base/ZAbstractNode"
----------------------------------------------------------------------
----------------------------------------------------------------------
---------
---------dialog
super_class.ZDialog(ZAbstractBasePanel)
---------
---------
local function DialogCreateFunction(self, width, height, x, y, addType, num)
	local tPosX = x
	local tPosY = y
	local tWidth = width 
	local tHeight = height
	local tAddType = addType 
	local tNum = num
	if x == nil then
		tPosX = 0
	end
	if y == nil then
		tPosY = 0
	end
	if width == nil then
		tWidth = 0
	end
	if height == nil then
		tHeight = 0
	end
	if addType == nil then
		tAddType = ADD_LIST_DIR_UP
	end
	if num == nil then
		tNum = 999999
	end
	---------
	self.view = CCDialogEx:dialogWithFile( tPosX, tPosY, tWidth, tHeight, tNum, "", TYPE_VERTICAL, tAddType )
end
---------
---------
function ZDialog:__init(fatherPanel)
	self.father_panel = fatherPanel
end
---------
---------
function ZDialog:create(fatherPanel, text, x, y, width, height, fontsize, num, z)
	local sprite = ZDialog(fatherPanel)
	DialogCreateFunction(sprite, width, height, x, y, nil, num)
	sprite:registerScriptFun()
	if fontsize ~= nil then
		sprite.view:setFontSize( fontsize )
	end
	if text ~= nil then
		sprite:setText(text)
	end
	if fatherPanel ~= nil then
		if fatherPanel.view ~= nil then
			if z ~= nil then 
				fatherPanel.view:addChild( sprite.view, z )
			else
				fatherPanel.view:addChild( sprite.view )
			end
		else
			if z ~= nil then
				fatherPanel:addChild( sprite.view, z )
			else
				fatherPanel:addChild( sprite.view )
			end
		end
	end
	return sprite
end
---------
---------
function ZDialog:setText(text)
	if self.view ~= nil then
		self.view:setText(text)
	end
end
---------
---------设置文本字体大小
function ZDialog:setFontSize(fontSize)
	if self.view ~= nil then
		self.view:setFontSize(fontSize)
	end
end
------------
------------
function ZDialog:setPosition(x, y)
	if self.view ~= nil then
		self.view:setPosition(x, y)
	end
end

-- 新创建的构造函数
function ZDialog.new( text, width, height, num, fontsize )
	local tWidth = width
	local tHeight = height
	local tNum = num or 999999
	local tText = text or ""
	local dialog = ZDialog()
	dialog.view = CCDialogEx:dialogWithFile( 0, 0, tWidth, tHeight, tNum, "", TYPE_VERTICAL, ADD_LIST_DIR_UP )
	dialog:setFontSize( fontsize or 16 )
	dialog:setText(text or "")
	return dialog
end
