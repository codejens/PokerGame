---------HJH
---------2012-2-15
---------
require "UI/component/AbstractBase"
----------------------------------------------------------------------
----------------------------------------------------------------------
---------
---------dialog
super_class.Dialog(AbstractBasePanel)
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
		tNum = 1
	end
	---------
	self.view = CCDialogEx:dialogWithFile( tPosX, tPosY, tWidth, tHeight, tNum, "", TYPE_VERTICAL, tAddType )
end
---------
---------
function Dialog:__init(fatherPanel)
end
---------
---------
function Dialog:create(fatherPanel, x, y, width, height, addType, num)
	local sprite = Dialog(fatherPanel)
	DialogCreateFunction(sprite, width, height, x, y, addType, num)
	sprite:registerScriptFun()
	return sprite
end
---------
---------
function Dialog:setText(text)
	if self.view ~= nil then
		self.view:setText(text)
	end
end