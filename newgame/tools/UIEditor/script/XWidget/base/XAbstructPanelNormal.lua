---------HJH
---------2014-5-6
---------X通用控件
---------
----------------------------------------------------------------------
----------------------------------------------------------------------
---------Notic:
---------抽象面板类，只提供方法

require "XWidget/base/XAbstructPanel"

super_class.XAbstructPanelNormal(XAbstructPanel)

---------
---------
function XAbstructPanelNormal:__init()
	self._scale_x = 1
	self._sclae_y = 1
end

---------
---------设置缩放
function XAbstructPanelNormal:setScale(arg)
	self._scale_x = arg
	self._sclae_y = arg
	self.view:setScale(arg)
end

---------
---------设置X缩放
function XAbstructPanelNormal:setScaleX(arg)
	self._scale_x = arg
	self.view:setScaleX(arg)
end

---------
---------设置Y缩放
function XAbstructPanelNormal:setScaleY(arg)
	self._sclae_y = arg
	self.view:setScaleY(arg)
end

---------
---------设置图片
function XAbstructPanelNormal:setTexture(image)
	self.view:setTexture(image)
	if image then
		local tSize = ZXResMgr:sharedManager():getTextureSize(image)
		self.view:setSize(tSize.width, tSize.height)
		self.view:setScaleX(self._scale_x)
		self.view:setScaleY(self._sclae_y)
	end
end

---------
---------
function XAbstructPanelNormal:setSize(width, height)
	
	self.view:setSize(width, height)
	local tScaleX = self.view:getSpriteScaleX()
	local tScaleY = self.view:getSpriteScaleY()

	if tScaleX > 0 then
		self._scale_x = tScaleX
	end

	if tScaleY > 0 then 
		self._sclae_y = tScaleY
	end

end