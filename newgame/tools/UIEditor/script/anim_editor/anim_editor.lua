anim_editor = {}

eBodyPartBody = 0
eBodyPartWeapon = 1
eBodyPartWeaponEffct = 2
eBodyPartMount = 3
eBodyPartWing = 4
eBodyPartFabo = 5

ZX_ENTITY_MOUNT_NODE_SORT_Z			= 7		--// 坐骑节点
ZX_ENTITY_FABAO_MOVE_NODE_SORT_Z    = 8
ZX_ENTITY_WING_NODE_SORT_Z			= 9		--// 翅膀节点
ZX_ENTITY_BODY_NODE_SORT_Z			= 10			--// 身体节点
ZX_ENTITY_WEAPON_NODE_SORT_Z		= 11		--// 武器节点 
ZX_ENTITY_WEAPON_EFFECT_NODE_SORT_Z = 12--// 武器特效节点
ZX_ENTITY_FABAO_NODE_SORT_Z			= 13		--// 法宝节点

eFrameModifierPosX = 1
eFrameModifierPosY = 2
eFrameModifierZOrder = 3
eFrameModifierScaleX = 4
eFrameModifierScaleY = 5
eFrameModifierRot = 6

g_begin_index = 1
g_cur_max_count = 0

g_begin_index_win = 1
g_cur_max_count_win = 0

local frame_step = 0
--[[
		eBodyPartBody,
		eBodyPartWeapon,
		eBodyPartWeaponEffct,
		eBodyPartMount,
		eBodyPartWing,
		eBodyPartFabo,
]]

function createModifier(z)
	local wingModifier = {}
	z = z or 3
	wingModifier.f = 0
	wingModifier.m = { 0, 0, z, 1, 1, 0}
	return wingModifier
end

function anim_editor:init()
	function _OnKeyEvent( key, down )
		--[[
		local mainActor = animActorManager.mainActor
		if mainActor then
			local c = mainActor.model:getFrameStepCount()
			local mainActor = animActorManager.mainActor

			if key == VK_LEFT and down then
				frame_step = frame_step - 1
				if frame_step < 0 then
					frame_step = 0
				end

				anim_editor:setFrameStep(frame_step)
				
			elseif key == VK_RIGHT and down then

				frame_step = frame_step + 1
				if frame_step >= c then
					frame_step = c -1
				end
				anim_editor:setFrameStep(frame_step)
			end
		end
		]]--
	end
	AppMessages.OnKeyEvent = _OnKeyEvent

	animEditProp.property['x'].keyBoardEnterFun = function(v) 
		anim_editor:setPosition(v,nil)
	end

	animEditProp.property['y'].keyBoardEnterFun = function(v) 
		anim_editor:setPosition(nil,v)
	end

	animEditProp.property['zOrder'].keyBoardEnterFun = function(v) 
		anim_editor:setZOrder(v)
	end

	animEditProp.property['scaleX'].keyBoardEnterFun = function(v) 
		anim_editor:setScale(v,nil)
	end

	animEditProp.property['scaleY'].keyBoardEnterFun = function(v) 
		anim_editor:setScale(nil,v)
	end

	animEditProp.property['rot'].keyBoardEnterFun = function(v) 
		anim_editor:setRotation(v)
	end

	animEditProp.property['path'].keyBoardEnterFun = function(e) 
		anim_editor:loadBodySlot(e)
	end

	animEditProp.property['slot_path'].keyBoardEnterFun = function(e) 
		anim_editor:loadSlot(e)
	end


	local t = os.clock()
	animEditProp.property['path'].touch_begin_fun = function(e) 
		if os.clock() - t < 0.5 then
			local path = ZXLuaUtils:fromClipboard()
			path = string.gsub(path,'\\','/')
			animEditProp.property['path'].view:setText(path)
		end
		t = os.clock()
	end
	
	local t = os.clock()
	animEditProp.property['slot_path'].touch_begin_fun = function(e) 
		if os.clock() - t < 0.5 then
			local path = ZXLuaUtils:fromClipboard()
			path = string.gsub(path,'\\','/')
			animEditProp.property['slot_path'].view:setText(path)
		end
		t = os.clock()
	end


	animEditProp.property['dir'].keyBoardEnterFun = function(e) 
		local action = animEditProp.property['action'].view:getText()
		animActor:playAction(tonumber(action), tonumber(e))
	end

	
	animEditProp.property['action'].keyBoardEnterFun = function(e) 
		local temp_dir = animEditProp.property['dir'].view:getText()
		animActor:playAction(tonumber(e), tonumber(temp_dir))
	end


	self.actor_running = false


	local root = ZXLogicScene:sharedScene()
	local ui_root = root:getUINode()
	self.root = ui_root

	local winSize = CCDirector:sharedDirector():getWinSize();
	self.slotPanel = CCNode:node()
	self.slotPanel:setPosition(winSize.width*0.5,winSize.height*0.5 - 80)
	self.root:addChild(self.slotPanel)

	-----------------------------------------
	self.body = CCSprite:spriteWithFile('')
	self.slotPanel:addChild(self.body,ZX_ENTITY_BODY_NODE_SORT_Z)

	self.wing = CCSprite:spriteWithFile('')
	self.slotPanel:addChild(self.wing,ZX_ENTITY_WING_NODE_SORT_Z)

	self.weapon = CCSprite:spriteWithFile('')
	self.slotPanel:addChild(self.weapon,ZX_ENTITY_WEAPON_NODE_SORT_Z)

	self.weapon_tail = CCSprite:spriteWithFile('')
	self.slotPanel:addChild(self.weapon_tail,ZX_ENTITY_WEAPON_NODE_SORT_Z)


	local t_panel = ZBasePanel:create(ui_root, "", 0, 0, winSize.width, winSize.height )
	t_panel:setDefaultReturnValue(false)
	t_panel:setTouchMovedReturnValue(false)

	local function left_btn_wing_fun()
		local last_index = g_begin_index_win
		g_begin_index_win  = g_begin_index_win - 1
		if g_begin_index_win < 1 then
			g_begin_index_win = 1
		end

		if last_index ~= g_begin_index_win then
			self.slots[self.visible_slot_name]:refresh_body_slot_pos(1)
			-- local temp_file = animEditProp.property['slot_path'].view:getText()
			-- anim_editor:loadSlot(temp_file)
		end
	end
	self._left_btn_win = ZTextButton:create( t_panel, '左翻', "nopack/ani_corner2.png", left_btn_wing_fun, 20, 420, 65, 30, 1)--“增 加”


	local function right_btn_wing_fun()
		local last_index = g_begin_index_win
		g_begin_index_win = g_begin_index_win + 1
		if g_begin_index_win > math.ceil(g_cur_max_count_win / 60) then
			g_begin_index_win = last_index
		end

		if last_index ~= g_begin_index_win then
			self.slots[self.visible_slot_name]:refresh_body_slot_pos(-1)
			-- local temp_file = animEditProp.property['slot_path'].view:getText()
			-- anim_editor:loadSlot(temp_file)
		end
	end
	self._right_bgn_win = ZTextButton:create( t_panel, "右翻", "nopack/ani_corner2.png", right_btn_wing_fun, 880, 420, 65, 30, 1)



	local function left_btn_role_fun()
		local last_index = g_begin_index
		g_begin_index  = g_begin_index - 1
		if g_begin_index < 1 then
			g_begin_index = 1
		end

		if last_index ~= g_begin_index then
			anim_edit_body_slot:refresh_body_slot_pos(1)
			-- local temp_file = animEditProp.property['path'].view:getText()
			-- anim_editor:loadBodySlot(temp_file)
		end
	end
	self._left_btn_role = ZTextButton:create( t_panel, '左翻', "nopack/ani_corner2.png", left_btn_role_fun, 20, 330, 65, 30, 1)--“增 加”


	local function right_btn_role_fun()
		local last_index = g_begin_index
		g_begin_index = g_begin_index + 1
		if g_begin_index > math.ceil(g_cur_max_count / 60) then
			g_begin_index = last_index
		end

		if last_index ~= g_begin_index then
			anim_edit_body_slot:refresh_body_slot_pos(-1)
			-- local temp_file = animEditProp.property['path'].view:getText()
			-- anim_editor:loadBodySlot(temp_file)
		end
	end
	self._right_bgn_role = ZTextButton:create( t_panel, "右翻", "nopack/ani_corner2.png", right_btn_role_fun, 880, 330, 65, 30, 1)

	self.pathname = 
	{
		body = '',
		wing = '',
		weapon = '',
		weapon_tail = ''
	}

	self.preview =
	{
		body = self.body,
		wing = self.wing,
		weapon = self.weapon,
		weapon_tail = self.weapon_tail
	}


	self.slots = {
		['wing']   = anim_edit_slot(self.wing,'wing'),
		['weapon'] = anim_edit_slot(self.weapon,'weapon'),
		['effect'] = anim_edit_slot(self.weapon_tail,'effect')
	}

	self.body_frameID = nil

	self:switchSlot('wing')
end

function anim_editor:setFrameStep(frame_id)

	self.frame_step = frame_step

	anim_edit_body_slot:setFrameStep(frame_id)
	--[[
	animActorManager:setAnimationStep(frame_step)
	

	local index = timeline_id - 1
	local which = BODY_PART_NAME[index]
	if index == 0 then
		 animEditProp:disable()
	else
		local mainActor = animActorManager.mainActor
		local frameModifier = ZXLuaUtils:getHFrameModifierOfAvatarPart(mainActor.model,index)
		animEditProp:refresh(frameModifier,index)
	end
	animEditProp:setName(which)
	local pathname = animActorManager.bodyPartPath[index]
	]]--
end

function anim_editor:toggleRun()
	if self.actor_running then
		anim_edit_body_slot:stopAnimation()
		self.actor_running = false
	else
		anim_edit_body_slot:startAnimation()
		self.actor_running = true
	end
end

function anim_editor:playActor()
	self.actor_running = true
end

function anim_editor:stopActor()
	self.actor_running = false
	animActorManager:setAnimationStep(self.frame_step)
end

function anim_editor:setProperty(key,value)
	if not self.actor_running then
		animEditProp:setProperty(key,pathname)
	end
end

function anim_editor:applyModifier(sprite, modifier)
	if modifier.m then
		local m = modifier.m
		sprite:setPosition(m[1],m[2])
		sprite:getParent():reorderChild(sprite,m[3])
		sprite:setScaleX(m[4])
		sprite:setScaleY(m[5])
		sprite:setRotation(m[6])
	end
end

function anim_editor:getModifier()
	return self.modifiers
end

function anim_editor:updateModifierFrameID(slot_name, body_ID, slot_ID)
	-- body
	print('updateModifierFrameID',slot_name,body_ID,slot_ID)
	body_ID = tostring(body_ID)
	----------------------------------------
	local slot = self.modifiers[slot_name]
	local modifier = slot[body_ID]
	if modifier == nil then
		modifier = createModifier()
		slot[body_ID] = modifier
	end
	----------------------------------------
	modifier.f = tonumber(slot_ID)
end

function anim_editor:updateModifier(slot_name, modifier_ID, value)
	-- body
	print('updateModifier',slot_name,modifier_ID,value)
	body_ID = tostring(self.body_frameID)
	if body_ID == nil then
		require 'utils/MUtils'
		MUtils:toast_black('#cff0000 error body_ID == nil',2048,3,true)
		return
	end
	----------------------------------------
	local slot = self.modifiers[slot_name]
	local modifier = slot[body_ID]
	if modifier == nil then
		modifier = createModifier()
		slot[body_ID] = modifier
	end
	----------------------------------------
	modifier.m[modifier_ID] = tonumber(value)
	return modifier
end


function anim_editor:save()
	require 'json/json'
	require 'json/jsonutils'
	local f = io.open(self.main_json,'w+')
	local content = json.encode(self.modifiers)
	f:write(content)
	f:close()
end


function anim_editor:linkModifier(panel,modifier_list)
	for k, v in pairs(modifier_list) do
		if panel.frameID == v.f then
			panel.modifier = v
			break
		end
	end
end

function anim_editor:move_slot(x,y)
	-- body
	self.active_slot:move_dif(x,y)
end

function anim_editor:rotate_slot(x,y)
	-- body
	self.active_slot:rotate_dif(x,y)
end

function anim_editor:scale_slot(x,y)
	-- body
	self.active_slot:scale_dif(x,y)
end

function anim_editor:setPosition(x,y)
	-- body
	self.active_slot:setPosition(x,y)
end

function anim_editor:setScale(x,y)
	-- body
	self.active_slot:setScale(x,y)
end

function anim_editor:setRotation(x,y)
	-- body
	self.active_slot:setRotation(x,y)
end


function anim_editor:setZOrder(x,y)
	-- body
	self.active_slot:setZOrder(x,y)
end

function anim_editor:onBodySelected(frameID)
	for k, v in pairs(self.slots) do
		--------------------------------------------
		local m = anim_editor:getModifier()[k]
		local wingModifier = m[frameID]
		if wingModifier == nil then
			wingModifier = createModifier()
			m[frameID] = wingModifier
		end
		m[frameID] = wingModifier
		
		local refreshUI = false
		if v == self.active_slot then
			refreshUI = true
		end
		print('refresh >>>',k,refreshUI)
		v:selectByBody(wingModifier,refreshUI)
		--------------------------------------------
	end
	self.body_frameID = frameID
end

function anim_editor:loadBodySlot(path)
	print("run anim_editor:loadBodySlot path",path)
	self.main_json = 'resource/' .. path .. '.json'
	require 'json/json'
	require 'json/jsonutils'

	local framelist = ZXSpriteFrameCache:sharedCache():getSpriteFrames(path);
	if framelist then
		self.pathname.body = path
		anim_edit_body_slot:build(framelist)
	end

	local f = io.open(self.main_json,'r')
	if not f then
		if framelist then
			local c = framelist:count()
			print("anim_editor:loadBodySlot c",c)
			self.modifiers = {}
			local wing = {}
			local weapon = {}
			local effect = {}
			for i=1,c do
				local f = framelist:getObjectAtIndex(i-1)
				local frameID = ZXLuaUtils:getResourceHandle(f)
				wing[frameID] = createModifier(ZX_ENTITY_WING_NODE_SORT_Z)
				weapon[frameID] = createModifier(ZX_ENTITY_WEAPON_NODE_SORT_Z)
				effect[frameID] = createModifier(ZX_ENTITY_WEAPON_EFFECT_NODE_SORT_Z)
			end
			self.modifiers['wing'] = wing
			self.modifiers['weapon'] = weapon
			self.modifiers['effect'] = effect
			anim_editor:save()
		end
	else
		local jdata = f:read('*a')
		self.modifiers = json2table(jdata)
		f:close()
		if framelist then
			local c = framelist:count()
			if self.modifiers['effect'] == nil then
				local weapon_tail = {}
				for i=1,c do
					local f = framelist:getObjectAtIndex(i-1)
					local frameID = ZXLuaUtils:getResourceHandle(f)
					weapon_tail[frameID] = createModifier(ZX_ENTITY_WEAPON_EFFECT_NODE_SORT_Z)
				end
				self.modifiers['effect'] = weapon_tail
			end
		end
	end
	anim_edit_body_slot:select(1)
end




function anim_editor:test()
	animActor:createBody(self.pathname)
end


function anim_editor:switchSlot(key)
	for k,v in pairs(self.slots) do
		v:setIsVisible(false)
	end
	self.slots[key]:setIsVisible(true)
	self.visible_slot_name = key
	self.active_slot = self.slots[key]
end

function anim_editor:loadSlot(path, name)

	local name = name or self.visible_slot_name
	local wingModifier = self.modifiers[name]
	local framelist = ZXSpriteFrameCache:sharedCache():getSpriteFrames(path);
	if framelist then
		self.slots[name]:build(framelist,wingModifier)
		self.pathname[name] = path
	end
end

function anim_editor:togglePreview(slot_name)
	local flag = self.preview[slot_name]:getIsVisible()
	self.preview[slot_name]:setIsVisible(not flag)
end


function anim_editor:copyFrames(slot_name, body_ID, slot_ID, dst_body_ID)
	-- body
	print('updateModifierFrameID',slot_name,body_ID,slot_ID)
	body_ID = tostring(body_ID)
	----------------------------------------
	local slot = self.modifiers[slot_name]
	local modifier = slot[body_ID]
	if modifier == nil then
		modifier = createModifier()
		slot[body_ID] = modifier
	end
	----------------------------------------
	slot[dst_body_ID] = Utils:table_deepcopy(modifier)

	--modifier.f = tonumber(slot_ID)
end

function anim_editor:copyLastFrame()
	--[[
	local body_frame_id = anim_editor.body_frameID
	print('updateModifierFrameID',slot_name,body_ID,slot_ID)
	body_ID = tostring(body_ID)
	----------------------------------------
	local slot = self.modifiers[slot_name]
	local modifier = slot[body_ID]
	if modifier == nil then
		modifier = createModifier()
		slot[body_ID] = modifier
	end
	----------------------------------------
	modifier.f = tonumber(slot_ID)
	]]--
	local body_frame_id = anim_editor.body_frameID
	local active_slot = self.active_slot
	local select_frame = active_slot.current_slot

	if body_frame_id then
		anim_editor:copyFrames(active_slot.slot_type_name,
							   body_frame_id - 1,
							   select_frame.frameID,
							   body_frame_id)
		
		anim_editor:onBodySelected(body_frame_id)
	end
end

