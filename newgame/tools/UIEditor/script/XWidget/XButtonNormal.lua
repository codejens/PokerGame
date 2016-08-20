---------HJH
---------2014-5-6
---------X通用控件
---------
----------------------------------------------------------------------
----------------------------------------------------------------------
---------Notic:
---------普通按钮类
require "XWidget/base/XAbstructPanelNormal"

super_class.XButtonNormal(XAbstructPanelNormal)

---------
---------
function XButtonNormal:__init(imageUp, imageDown, imageDisable)

	local tImageUp = imageUp or ""
	local tWidth = DefaultNodeSize
	local tHeight = DefaultNodeSize

	if imageUp then
		local tempSize = ZXResMgr:sharedManager():getTextureSize(imageUp)
		tWidth = tempSize.width
		tHeight = tempSize.height
	end

	self.view = CCNGBtnMulTex:buttonWithFile( 0, 0, tWidth, tHeight, tImageUp, TYPE_MUL_TEX, 0, 0, 0, 0, 0, 0 )

	if imageDown and imageDown ~= "" then
		self.view:addTexWithFile(CLICK_STATE_DOWN, imageDown)
	end

	if imageDisable and imageDisable ~= "" then
		self.view:addTexWithFile(CLICK_STATE_DISABLE, imageDisable)
	end

	self._scale_x = 1
	self._sclae_y = 1
	self:registerScriptFun()
end

---------
---------
function XButtonNormal:addTexWithFile(state, file)
	self.view:addTexWithFile(state, file)
	if state == CLICK_STATE_UP and file and file ~= "" then
		local tempSize = ZXResMgr:sharedManager():getTextureSize(file)
		self.view:setSize(tempSize.width, tempSize.height)
		self.view:setScaleX(self._scale_x)
		self.view:setScaleY(self._sclae_y)
	end
	local tState = self.view:getCurButtonState()
	self.view:setCurState(tState)
end

