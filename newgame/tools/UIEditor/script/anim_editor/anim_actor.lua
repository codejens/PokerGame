VK_LEFT     =     0x25
VK_UP       =     0x26
VK_RIGHT    =     0x27
VK_DOWN     =     0x28
VK_MENU     =     0x12
SELECT_RECT_TAG = -100

animActor = {}
local entityCreator = ZXEntityMgr:sharedManager()

function animActor:init()
	local root = ZXLogicScene:sharedScene()
	local ui_root = root:getUINode()
	local node = CCNode:node()
	local winSize = CCDirector:sharedDirector():getWinSize();

	node:setContentSize(CCSizeMake(winSize.width,winSize.height))
	node:setTag(255)
	ui_root:addChild(node)

	self.root = node
	self.bodyPartPath = {}
	self.mainActor = nil
	print(' animActor:init')
end

function animActor:createBody(bodypath)
	print("animActor:createBody ",bodypath)
	local winSize = CCDirector:sharedDirector():getWinSize();
	ZXLuaUtils:clearXSlotAnimationConfig();
	if self.model then
		self.model:removeFromParentAndCleanup(true)
	end
	
	local model =  entityCreator:createModel(0, 0, 4)
	model = ZXEntityMgr:toAvatar(model)
	self.model = model
	model:setActionStept(200)
	model:playAction(0,4,false)
	model:setPosition(CCPointMake(winSize.height * 0.5, winSize.height * 0.5 - 80))
	self.root:addChild(model,model:getPositionY());


	for k,v in pairs(bodypath) do
		print('>>>',k,v)
	end
	print('loading', bodypath.body)
	self.model:changeBody(bodypath.body)
	print('loading', bodypath.wing)
	self.model:putOnWing(bodypath.wing)
	print('loading', bodypath.weapon)
	--self.model:putOnWeapon(bodypath.weapon)
	print('loading', bodypath.effect)
	if bodypath.effect then
		self.model:putOnEffect(bodypath.effect)
	end
	
end

function animActor:playAction(action_id, dir)
	if self.model then
		-- print("animActor:playAction action_id,dir",action_id,dir)
		self.model:playAction(action_id,dir,false)
	end
end

local flag = true
function animActor:toggleWeaponEffect()
	if flag then
		if self.model then
			self.model:showWeaponEffect('frame/weapon_buff')
		end
	else
		if self.model then
			self.model:hideWeaponEffect()
		end
	end
	flag = not flag
end

local hlflag = true
function animActor:toggleWeaponHighlight()
	if self.model then
		local wp = self.model:getWeapon()
		if wp then
			wp:enableHighlight(hlflag)
		end
	end
	hlflag = not hlflag
end
