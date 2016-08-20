anim_edit_slot = simple_class()
local SIZE = 64
local FRAME_TAG = 100
local function _createFrames(parent,x,y,w,h,texture,index)
	local panel = ZBasePanel:create(nil, texture, 0, 0, w, h, -1, -1, -1, -1, -1, -1)
	panel:setPosition(x,y)
	--panel.view:setIsVisible(false)
	panel.view:setColor(0)
	panel:setTouchClickFun(function()
		parent:setFrameStep(index)
		local frame = panel.sp:displayedFrame()
		parent.slot_display_sprite:setDisplayFrame(frame)
		--通过body的frameID，检索modifier,然后重新设置modifier
		local body_frame_id = anim_editor.body_frameID
		if body_frame_id then
			anim_editor:updateModifierFrameID(parent.slot_type_name,body_frame_id,panel.frameID)
		end
		if panel.modifier then
			--print('...................')
		end
		parent.current_slot = panel
	end)
	return panel
end

function anim_edit_slot:__init(slot_display_sprite, slot_type_name)
	self.root = root
	self.timelines = {}
	local root = ZXLogicScene:sharedScene()
	local ui_root = root:getUINode()
	local winSize = CCDirector:sharedDirector():getWinSize();
	local root_panel = ZBasePanel:create(ui_root, '', 0, 0, 970, 280, -1, -1, -1, -1, -1, -1)
	root_panel:setPosition(0,winSize.height - 280)
	self.root = root_panel

	local x = 8
	local y = 280 - 8 - SIZE
	local index = 1
	local tx = 8
	for i=1,4 do
		tx = x
		y = 280 - 8 - SIZE
		for j=1,15 * 4 do
			local panel =_createFrames( self, tx ,y, SIZE, SIZE,'nopack/white.png',index)
			panel:addChild(CCDebugRect:create(),-1)
			self.root:addChild(panel.view)
			tx = tx + SIZE
			self.timelines[#self.timelines+1] = panel
			if #self.timelines > 60 then
				panel.view:setIsVisible(false)
			end
			index = index + 1
			if j % 15 == 0 then
				tx = x
				y = y - SIZE
			end
		end
		x = x + SIZE * 15
		-- y = y - SIZE
	end

	self.current_slot = nil

	self.slot_display_sprite = slot_display_sprite
	self.slot_type_name = slot_type_name
end

function anim_edit_slot:build(framelist,modifier_list)
	g_begin_index_win = 1
	local timeline = self.timelines
	local count = 4 * 15 * 4
	for j=1, count do
		local panel = timeline[j]
		panel.view:setIsVisible(false)
		local sp = timeline[j].sp
		if sp then
			sp:removeFromParentAndCleanup(true)
		end
		local label = timeline[j].label
		if label then
			label:removeFromParentAndCleanup(true)
		end
		panel.label = nil
		panel.frameID = nil
		panel.sp = nil
	end
	if framelist then
		local c = framelist:count()
		g_cur_max_count_win = c
		local temp_count = c

		if temp_count > count then
			assert(false,'edit slot out of range')
			return
			-- temp_count = count
		end

		for i=1,temp_count do
			local panel = timeline[i]

			if i <= g_cur_max_count_win then

				local f = framelist:getObjectAtIndex( i - 1)
				local sp = CCSprite:spriteWithSpriteFrame(f)
				local sz = f:getRect().size
				
				panel.frameID = ZXLuaUtils:getResourceHandle(f)
				sp:setScale(0.5)
				sp:setPosition(32,0)
				panel.view:addChild(sp)
				panel.view:setIsVisible(true)
				panel.sp = sp

				local label = CCZXLabel:labelWithText(0,0,tostring(panel.frameID));
				panel.label = label
				panel.view:addChild(label)
				anim_editor:linkModifier(panel, modifier_list)
				if i >= g_begin_index and i < g_begin_index + 60 then
					panel.view:setIsVisible(true)
				else
					panel.view:setIsVisible(false)
				end
			else
				panel.view:setIsVisible(false)
			end

		end
	end
end

function anim_edit_slot:setFrameStep(index)
	local timeline = self.timelines
	local count = 4 * 15 * 4

	for i=1, count do
		local panel = timeline[i].view
		panel:setColor(0)
	end

	local panel = timeline[index].view
	panel:setColor(0xffff00)
end

function anim_edit_slot:selectByBody(modifier,refreshUI)

	local f = tonumber(modifier.f)

	local timeline = self.timelines
	local count = 4 * 15 * 4

	for i=1, count do
		local panel = timeline[i]
		panel.view:setColor(0)
	end

	for i=1, count do
		local panel = timeline[i]
		if panel.frameID == f then
			panel.view:setColor(0xffff00)
			local frame = panel.sp:displayedFrame()
			self.slot_display_sprite:setDisplayFrame(frame)
			anim_editor:applyModifier(self.slot_display_sprite,modifier)
			panel.modifier = modifier
			if refreshUI then
				animEditProp:refresh(modifier)
			end
			self.current_slot = panel
			break
		end
	end
end



function anim_edit_slot:move_dif(x,y)
	local lx,ly = self.slot_display_sprite:getPosition()
	lx = lx + x
	ly = ly + y 
	self:setPosition(lx,ly)
end

function anim_edit_slot:setPosition(lx,ly)
	--xprint("anim_edit_slot:setPosition")
	lx = tonumber(lx)
	ly = tonumber(ly)
	if lx then
		self.slot_display_sprite:setPositionX(lx)
	end
	if ly then
		self.slot_display_sprite:setPositionY(ly)
	end
	local panel = self.current_slot
	if panel then
		local modifier = nil
		if lx then
			modifier = anim_editor:updateModifier(self.slot_type_name,eFrameModifierPosX,lx)
		end
		if ly then
			modifier = anim_editor:updateModifier(self.slot_type_name,eFrameModifierPosY,ly)
		end
		if modifier then
			animEditProp:refresh(modifier)
		end
	end
end


function anim_edit_slot:rotate_dif(x,y)
	local lx = self.slot_display_sprite:getRotation()
	lx = lx + y
	self:setRotation(lx)
end

function anim_edit_slot:setRotation(r)
	r = tonumber(r)

	self.slot_display_sprite:setRotation(r)
	local panel = self.current_slot
	if panel then
		local modifier = anim_editor:updateModifier(self.slot_type_name,eFrameModifierRot,r)
		if modifier then
			animEditProp:refresh(modifier)
		end
	end
end

function anim_edit_slot:scale_dif(x,y)

	local lx = self.slot_display_sprite:getScaleX()
	local ly = self.slot_display_sprite:getScaleY()

	local winSize = CCDirector:sharedDirector():getWinSize();

	lx = lx + x / winSize.width
	ly = ly + y / winSize.height

	self:setScale(lx,ly)
end


function anim_edit_slot:setScale(lx,ly)
	lx = tonumber(lx)
	ly = tonumber(ly)
	if lx then
		self.slot_display_sprite:setScaleX(lx)
	end
	if ly then
		self.slot_display_sprite:setScaleY(ly)
	end
	local panel = self.current_slot
	if panel then
		local modifier = nil
		if lx then
			modifier = anim_editor:updateModifier(self.slot_type_name,eFrameModifierScaleX,lx)
		end
		if ly then
			modifier = anim_editor:updateModifier(self.slot_type_name,eFrameModifierScaleY,ly)
		end
		if modifier then
			animEditProp:refresh(modifier)
		end
	end
end

function anim_edit_slot:setZOrder(z)
	z = tonumber(z)

	local sprite = self.slot_display_sprite
	sprite:getParent():reorderChild(sprite,z)

	local panel = self.current_slot
	if panel then
		local modifier = anim_editor:updateModifier(self.slot_type_name,eFrameModifierZOrder,z)
		animEditProp:refresh(modifier)
	end
end

function anim_edit_slot:setIsVisible(flag)
	self.root.view:setIsVisible(flag)
end

function anim_edit_slot:refresh_body_slot_pos(dir)
	local stept = SIZE * 15 * dir
	for i = 1, #self.timelines do
		local temp_pos = self.timelines[i].view:getPositionS()
		self.timelines[i].view:setPosition(temp_pos.x + stept, temp_pos.y)
		if i >= g_begin_index_win and i <= g_begin_index_win * 60 then
			self.timelines[i].view:setIsVisible(true)
		else
			self.timelines[i].view:setIsVisible(false)
		end
	end
end