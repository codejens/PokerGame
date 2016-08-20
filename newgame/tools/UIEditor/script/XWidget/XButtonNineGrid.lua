---------HJH
---------2014-5-6
---------X通用控件
---------
----------------------------------------------------------------------
----------------------------------------------------------------------
---------Notic:
---------九宫格按钮类
require "XWidget/base/XAbstructPanelNormal"

super_class.XButtonNineGrid(XAbstructPanelNormal)

---------
---------
function XButtonNineGrid:__init(width, height, imageUp, imageDown, imageDisable)

	local tImageUp = imageUp or ""
	local tWidth = width
	local tHeight = height
	local tNgWidth = DefaultNineGridSize
	local tNgHeight = DefaultNineGridSize

	self.view = CCNGBtnMulTex:buttonWithFile( 0, 0, tWidth, tHeight, tImageUp, TYPE_MUL_TEX, tNgWidth, tNgHeight, 0, 0, 0, 0, 0, 0 )

	if imageDown and imageDown ~= "" then
		self.view:addTexWithFile(CLICK_STATE_DOWN, imageDown)
	end

	if imageDisable and imageDisable ~= "" then
		self.view:addTexWithFile(CLICK_STATE_DISABLE, imageDisable)
	end

	self:registerScriptFun()
end

---------
---------
function XButtonNineGrid:reSetImageInfo(imageUp, imageDown, imageDisable)
	if imageUp then
		self.view:addTexWithFile(CLICK_STATE_UP, imageUp)
	end

	if imageDown then
		self.view:addTexWithFile(CLICK_STATE_DOWN, imageDown)
	end

	if imageDisable then
		self.view:addTexWithFile(CLICK_STATE_DISABLE, imageDisable)
	end	
	local tState = self:getCurState()
	self:setCurState(tState)
end

---------
---------
function XButtonNineGrid:addTexWithFile(state, file)
	self.view:addTexWithFile(state, file)
	local tState = self.view:getCurState()
	self.view:setCurState(tState)
end
