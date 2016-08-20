animEditProp = {}

--fatherPanel, x, y, width, height, maxnum, fontSize, image, topLeftWidth, topLeftHeight, topRightWidth, topRightHeight, bottomLeftWidth, bottomLeftHeight, bottomRightWidth, bottomRightHeight
function createProperty(root, text, x, y, gap, width, height)
 	ZLabel:create( root, text, x, y)
 	local edit = ZEditBox:create(root, x + gap, y - 8, width, height, 255, 14, 'nopack/ani_corner.png', 500, 500, 500, 500, 500, 500, 500, 500)
 	return edit
end

function animEditProp:init()
	local winSize = CCDirector:sharedDirector():getWinSize();
	self.root = root
	local root = ZXLogicScene:sharedScene()
	local ui_root = root:getUINode()
	self.root = ui_root
	self.panel = ZBasePanel:create(ui_root, 
								  'nopack/bg_06.png', 
								  winSize.width, 0, 
								  320, winSize.height, 
								  500, 500, 500, 500, 500, 500)

	self.panel:setAnchorPoint(1,0)

	self.name = ZLabel:create( self.panel, '空间', 16, winSize.height - 32)

	self.property = {}

	local x = 16
	local y = winSize.height - 72
	self.property['x'] = createProperty(self.panel,'x', x, y, 64, 72, 24)
	x = x + 138
	self.property['y'] = createProperty(self.panel,'y', x, y, 64, 72, 24)
	y = y - 48
	--
	x = 16
	self.property['zOrder'] = createProperty(self.panel,'深度', x, y,64, 72, 24)
	x = x + 128
	y = y - 48

	--
	x = 16
	self.property['scaleX'] = createProperty(self.panel,'缩放x', x, y, 64, 72, 24)
	x = x + 138
	self.property['scaleY'] =createProperty(self.panel,'缩放y', x, y, 64, 72, 24)
	y = y - 48



	--
	x = 16
	self.property['rot'] = createProperty(self.panel,'旋转', x, y,64, 96, 24)
	x = x + 128
	y = y - 48


	--[[
	x = 16
	self.property['r'] = createProperty(self.panel,'r', x, y,19, 72, 24)
	x = x + 100
	self.property['g'] = createProperty(self.panel,'g', x, y,18, 72, 24)
	x = x + 100
	self.property['b'] = createProperty(self.panel,'b', x, y,18, 72, 24)
	y = y - 48

	--
	x = 16
	self.property['opacity'] = createProperty(self.panel,'透明度', x, y,64, 96, 24)
	x = x + 128
	y = y - 48
	]]--
	--
	x = 16
	self.property['frameID'] = createProperty(self.panel,'帧id', x, y,64, 96, 24)
	x = x + 128
	y = y - 32	


	x = 16
	name = ZLabel:create( self.panel, '切换当前配件', x, y)
	y = y - 32	
	---------------------------------------------------------------
	x = 16
	local test_times_btn = ZTextButton:create(self.panel, 
		'翅膀', "nopack/ani_corner2.png", 
		function() anim_editor:switchSlot('wing') end, x, y, 65, 30, 1)--“增 加”

	x = x + 72
	local test_times_btn = ZTextButton:create(self.panel, 
		'武器', "nopack/ani_corner2.png", 
		function() anim_editor:switchSlot('weapon') end, x, y, 65, 30, 1)--“增 加”

	x = x + 72
	local test_times_btn = ZTextButton:create(self.panel, 
		'特效', "nopack/ani_corner2.png", 
		function() anim_editor:switchSlot('effect') end, x, y, 65, 30, 1)--“增 加”
	-------------------------------------------------------------
	-------------------------------------------------------------
	x = 16
	y = y - 32	
	local test_times_btn = ZTextButton:create(self.panel, 
		'复制上一帧', "nopack/ani_corner2.png", 
		function() anim_editor:copyLastFrame() end, x, y, 128, 30, 1)--“增 加”
	-------------------------------------------------------------

	y = y - 32	
	name = ZLabel:create( self.panel, '通用', x, y)
	y = y - 32	

	--
	x = 16
	self.property['path'] = createProperty(self.panel,'身体路径', x, y,64, 220, 24)
	x = x + 128
	y = y - 48	
	--
	x = 16
	self.property['slot_path'] = createProperty(self.panel,'配件路径', x, y,64, 220, 24)

	y = y - 32	
	x = 16
	name = ZLabel:create( self.panel, '预览显示/隐藏配件', x, y)
	y = y - 32	
	---------------------------------------------------------------
	x = 16
	local test_times_btn = ZTextButton:create(self.panel, 
		'翅膀', "nopack/ani_corner2.png", 
		function() anim_editor:togglePreview('wing') end, x, y, 65, 30, 1)--“增 加”

	x = x + 72
	local test_times_btn = ZTextButton:create(self.panel, 
		'武器', "nopack/ani_corner2.png", 
		function() anim_editor:togglePreview('weapon') end, x, y, 65, 30, 1)--“增 加”

	x = x + 72
	local test_times_btn = ZTextButton:create(self.panel, 
		'特效', "nopack/ani_corner2.png", 
		function() anim_editor:togglePreview('weapon_tail') end, x, y, 65, 30, 1)--“增 加”



	x = 16
	y = y - 32	
	name = ZLabel:create( self.panel, '使用当前配置测试游戏实体', x, y)
	y = y - 32	
	--
	self.test_times_btn = ZTextButton:create(self.panel, 
		'测试', "nopack/ani_corner2.png", 
		function() anim_editor:test() end, x, y, 65, 30, 1)--“增 加”
	y = y - 20	
	x = 16
	
	self.property['dir'] = createProperty(self.panel,'方向', x, y,64, 220, 24)
	y = y - 30

	self.property['action'] = createProperty(self.panel,'动作', x, y,64, 220, 24)
	x = x + 128
	y = y - 48	

	x = 16
	local test_times_btn = ZTextButton:create(self.panel, 
		'武器特效', "nopack/ani_corner2.png", 
		function() animActor:toggleWeaponEffect() end, x, y, 128, 30, 1)--“增 加”

	x = x + 140
	local test_times_btn = ZTextButton:create(self.panel, 
		'武器高光', "nopack/ani_corner2.png", 
		function() animActor:toggleWeaponHighlight() end, x, y, 128, 30, 1)--“增 加”

	 ZButton:create(self.panel, "nopack/arrow.png", function()
	 	anim_editor:toggleRun()
	 end,0,0,64,48,999);

	 y = y - 48
	self.add_times_btn = ZTextButton:create(self.panel, 
		'保存', "nopack/ani_corner2.png", 
		function() anim_editor:save() end, x, y, 65, 30, 1)--“增 加”


end

function animEditProp:setName(name)
	self.name:setText(name)
end

function animEditProp:setProperty(which,value)
	if value then
		self.property[which]:setText(value)
	end
end


function animEditProp:disable()
	self.property['x']:setText('不可设置')
	self.property['y']:setText('不可设置')
	self.property['zOrder']:setText('不可设置')

	self.property['rot']:setText('不可设置')

	self.property['scaleX']:setText('不可设置')
	self.property['scaleY']:setText('不可设置')

	self.property['frameID']:setText('不可设置')
	
	--self.property['r']:setText('不可设置')
	--self.property['g']:setText('不可设置')
	--self.property['b']:setText('不可设置')

	--self.property['opacity']:setText('不可设置')
end

function animEditProp:refresh(fm, bodyPartID)

	self.bodyPartID = bodyPartID

	self.property['x']:setText(fm.m[eFrameModifierPosX])
	self.property['y']:setText(fm.m[eFrameModifierPosY])
	self.property['zOrder']:setText(fm.m[eFrameModifierZOrder])

	self.property['rot']:setText(fm.m[eFrameModifierRot])

	self.property['scaleX']:setText(fm.m[eFrameModifierScaleX])
	self.property['scaleY']:setText(fm.m[eFrameModifierScaleY])

	self.property['frameID']:setText(fm.f)

	self.property['dir']:setText("0")

end
