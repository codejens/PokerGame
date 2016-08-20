---------HJH
---------2014-5-6
---------X通用控件
---------
----------------------------------------------------------------------
----------------------------------------------------------------------
---------Notic:
---------抽象面板类，只提供方法

require "XWidget/base/XAbstructPanel"

super_class.XAbstructPanelNineGrid(XAbstructPanel)

DefaultNineGridSize = 600

local _k_dis = 2

---------
---------
function XAbstructPanelNineGrid:__init()
end

---------
---------设置九宫格信息
function XAbstructPanelNineGrid:setConerSize(tx, ty)

	local tFileName = self.view:getFileName()
	local tSize = ZXResMgr:sharedManager():getTextureSize(tFileName)

	local tlx,tly,trx,try,blx,bly,brx,bry = DefaultNineGridSize

	if tx <= tSize.width / 2 - _k_dis then
		tlx = tx
		trx = tSize.width - tx - _k_dis
		blx = tx
		brx = tSize.width - tx - _k_dis
	end

	if ty <= tSize.width / 2 - _k_dis then
		tly = ty
		try = tSize.height - ty - _k_dis
		blx = ty
		brx = tSize.height - ty - _k_dis
	end

	self.view:setConerSize(tlx, tly, trx, try, blx, bly, brx, bry)
end
