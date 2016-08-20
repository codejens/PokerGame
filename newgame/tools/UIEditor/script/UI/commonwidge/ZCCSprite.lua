---------hcl
---------2013-11-7
---------
require "UI/commonwidge/base/ZAbstractNode"
----------------------------------------------------------------------
----------------------------------------------------------------------
---------
---------ZCCSprite 封装cocos2d-x的CCSprite
super_class.ZCCSprite(ZAbstractNode)
---------
---------
local function SpriteCreateFunction(self, img, x, y)
	local tPosX = x
	local tPosY = y
	if x == nil then
		tPosX = 0
	end
	if y == nil then
		tPosY = 0
	end
	---------
	self.view = CCSprite:spriteWithFile(img);
    self.view:setPosition(x, y);
end
---------
---------
function ZCCSprite:__init(fatherPanel)
	self.father_panel = fatherPanel
end
---------
---------
function ZCCSprite:create( fatherPanel,img , x, y, z )
	local sprite = ZCCSprite(fatherPanel)
	SpriteCreateFunction(sprite,img, x, y)
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

function ZCCSprite:setTexture( path )
	self.view:replaceTexture(path);
end
