-- PetBattleScene.lua
-- created by aXing on 2013-7-5
-- 宠物战斗小游戏场景

super_class.PetBattleScene(Window)

function PetBattleScene:__init( window_name, texture_name, pos_x, pos_y, width, height )
	
end

function PetBattleScene:destory(  )
	self:clear()
	Window:destory(self)
end

function PetBattleScene:active( show )
	if not show then
		self:clear()
	end
end

function PetBattleScene:clear(  )
	if self.pet_A ~= nil then
		self.view:removeChild(self.pet_A)
		self.pet_A = nil
	end

	if self.pet_B ~= nil then
		self.view:removeChild(self.pet_B)
		self.pet_B = nil
	end
end

-- 飘字
local function text_flow( actor, text )
	if text == nil then
		return 
	end

	local file 	= Flow_Text_Prefix_Config[text]
	local sprite = CCSprite:spriteWithFile(file)

	sprite:setAnchorPoint(CCPointMake(0.5,0.5))
	sprite:setPosition(0,16)

	local delay = CCDelayTime:actionWithDuration(0.75)
	local sceleOut = CCScaleTo:actionWithDuration(0.25,0,0);
	local removeact = CCRemove:action();
	local array = CCArray:array();

	array:addObject(delay);
	array:addObject(sceleOut);
	array:addObject(removeact);

	local seq = CCSequence:actionsWithArray(array);
	local move = CCMoveBy:actionWithDuration(5,CCPointMake(0,280))
	local move_ease = CCEaseOut:actionWithAction(move,2.0)
	local spawn = CCSpawn:actionOneTwo(seq,move_ease)
	sprite:runAction(spawn)

	actor:getBillboardNode():addChild(sprite)
end

-- 做动作
local function do_action( pet_attack, pet_defence, action )
	local text = nil
	if action == PetBattleGame.PET_ACTION_ATTACK then
		action = ZX_ACTION_HIT
		text   = nil
	elseif action == PetBattleGame.PET_ACTION_CRITICAL then
		action = ZX_ACTION_HIT
		text   = "critical"
	elseif action == PetBattleGame.PET_ACTION_AOYI then
		action = ZX_ACTION_HIT
		text   = "criticalStrikes"
	elseif action == PetBattleGame.PET_ACTION_HIT then
		action = ZX_ACTION_STRUCK
		text   = "hit"
	elseif action == PetBattleGame.PET_ACTION_MISS then
		action = ZX_ACTION_IDLE
		text   = "dodge"
	end

	pet_attack:playAction(action, pet_attack.dir, false)
	text_flow(pet_attack, text)
end

-- 宠物准备
function PetBattleScene:show_pet(pet_a, pet_b)

	-- 创建A宠物
	local model_A = ZXEntityMgr:sharedManager():createModel(ZX_ENTITY_PET, pet_a.body, 3)
	self.pet_A = ZXEntityMgr:toPet(model_A)
	self.pet_A:setPosition(200, 140)
	self.pet_A:changeBody("scene/monster/".. pet_a.body)
	self.pet_A.dir = 3
	-- 创建阴影
	local shadow_A = CCSprite:spriteWithFile("nopack/shadow.png")
	self.pet_A:addChild(shadow_A, -1)

	self.view:addChild(self.pet_A, 100, 100)

	-- 创建B宠物
	local model_B = ZXEntityMgr:sharedManager():createModel(ZX_ENTITY_PET, pet_b.body, 6)
	self.pet_B = ZXEntityMgr:toPet(model_B)
	self.pet_B:setPosition(600, 140)
	self.pet_B:changeBody("scene/monster/".. pet_b.body)
	self.pet_B.dir = 6
	-- 创建阴影
	local shadow_B = CCSprite:spriteWithFile("nopack/shadow.png")
	self.pet_B:addChild(shadow_B, -1)

	self.view:addChild(self.pet_B, 100, 200)
end

-- 宠物做动作
function PetBattleScene:perform( action_a, action_b )

	if self.pet_A ~= nil then
		do_action(self.pet_A, self.pet_B, action_a)
	end

	if self.pet_B ~= nil then
		do_action(self.pet_B, self.pet_A, action_b)
	end
end

-- 评述
function PetBattleScene:comment( comment )
	-- body
end

--