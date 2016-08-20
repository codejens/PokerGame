anim_edit_body_slot = {}
local SIZE = 64
local FRAME_TAG = 100

local function _createFrames(parent,x,y,w,h,texture,index)
	local panel = ZBasePanel:create(nil, texture, 0, 0, w, h, -1, -1, -1, -1, -1, -1)
	panel:setPosition(x,y)
	panel.view:setIsVisible(false)
	panel.view:setColor(0)
	panel.set_frame = function()
		anim_editor:setFrameStep(index)
		local frame = panel.sp:displayedFrame()
		anim_editor.body:setDisplayFrame(frame)

		local pKey = tostring(panel.frameID)
		anim_editor:onBodySelected(pKey)
	end
	panel:setTouchClickFun(panel.set_frame)
	return panel
end

function anim_edit_body_slot:init(root)
	self.root = root
	self.timelines = {}
	local root = ZXLogicScene:sharedScene()
	local ui_root = root:getUINode()
	self.root = ui_root

	local x = 8
	local y = 24
	local index = 1
	local tx = 8
	for i=1,4 do
		tx = x
		y = 24
		for j=1,15 * 4 do
			local panel =_createFrames( self, tx ,y, SIZE, SIZE,'nopack/white.png',index)
			panel:addChild(CCDebugRect:create(),-1)
			self.root:addChild(panel.view)
			tx = tx + SIZE
			self.timelines[#self.timelines+1] = panel
			index = index + 1
			if j % 15 == 0 then
				tx = x
				y = y + SIZE
			end
		end
		x = x + SIZE * 15
		-- y = y + SIZE
		
	end

	self.actor = CCSprite:spriteWithFile('')
	root:addChild(self.actor)
	local winSize = CCDirector:sharedDirector():getWinSize();
	local x = winSize.width * 0.5
	local y = winSize.height * 0.5 - 100
	self.actor:setPosition(x,y)

	self.animation_timer = timer()
end

function anim_edit_body_slot:build(framelist, modifier_list)
	self.animation_timer:stop()
	local timeline = self.timelines
	g_begin_index = 1
	local count = 4 * 15 * 4
	for j=1, count do
		timeline[j].view:setIsVisible(false)
		local sp = timeline[j].sp
		if sp then
			sp:removeFromParentAndCleanup(true)
		end
		local label = timeline[j].label
		if label then
			label:removeFromParentAndCleanup(true)
		end
		timeline[j].sp = nil
		timeline[j].label = nil
		if j >= g_begin_index and j <= g_begin_index * 60 then
			timeline[j].view:setIsVisible(true)
		else
			timeline[j].view:setIsVisible(false)
		end
	end
	local animarray = {}

	if framelist then
		local c = framelist:count()
		g_cur_max_count = c
		local temp_count = c

		if temp_count > count then
			assert(false,'body slot out of range')
			return
		end

		print("anim_edit_body_slot:build c,temp_count",c,temp_count)
		for i=1,temp_count do
			local panel = timeline[i]
			--print("g_begin_index,count",g_begin_index,count)
			if i <= g_cur_max_count then
				local f = framelist:getObjectAtIndex( i - 1)

				local sp = CCSprite:spriteWithSpriteFrame(f)
				local sz = f:getRect().size
				panel.frameID = ZXLuaUtils:getResourceHandle(f)
				local label = CCZXLabel:labelWithText(0,0,tostring(panel.frameID));

				sp:setScale(0.5)
				sp:setPosition(32,0)
				panel.view:addChild(sp)
				panel.view:addChild(label)
				panel.view:setIsVisible(true)
				panel.sp = sp
				panel.label = label
				animarray[i] = panel
				if i >= g_begin_index_win and i < g_begin_index_win + 60 then
					panel.view:setIsVisible(true)
				else
					panel.view:setIsVisible(false)
				end
			else
				panel.view:setIsVisible(false)
			end
		end

		local tick_i = 1 
		local frame_i = 1
		-- if tick_i == 0 then
		-- 	tick_i = 1
		-- end
		-- if frame_i == 0 then
		-- 	frame_i = 1
		-- end
		-- local temp_cur_index = 1
		self.animator_func = function()
			print("tick_i,c",tick_i,c)
			if tick_i >= c then
				tick_i = 1
				g_begin_index = 1
				anim_edit_body_slot:reinit_body_slot_pos()
				-- g_begin_index = 0
				-- temp_cur_index = 1
				-- local temp_file = animEditProp.property['path'].view:getText()
				-- anim_editor:loadBodySlot(temp_file)
				-- anim_edit_body_slot:startAnimation()

			end

			animarray[tick_i].set_frame()
			--animarray[tick_i].set_frame()
			--phone_saveScreenshot(tostring(frame_i) .. '.jpg',0)
			tick_i = tick_i + 1
			frame_i = frame_i + 1
			-- temp_cur_index = temp_cur_index + 1
			if tick_i % 60 == 0 then
				-- temp_cur_index = 1
				g_begin_index = g_begin_index + 1
				anim_edit_body_slot:refresh_body_slot_pos(-1)
				-- local temp_file = animEditProp.property['path'].view:getText()
				-- anim_editor:loadBodySlot(temp_file)
				-- anim_edit_body_slot:startAnimation()
			end
		end
		--self.animation_timer:start(0.1, )
	end

	--local t = timer()
end

function anim_edit_body_slot:select(index)
	local timeline = self.timelines
	local panel = timeline[index]
	panel.set_frame()
end

function anim_edit_body_slot:setFrameStep(index)
	local timeline = self.timelines
	local count = 4 * 15 * 4

	for i=1, count do
		local panel = timeline[i].view
		panel:setColor(0)
	end

	local panel = timeline[index].view
	panel:setColor(0xffff00)
end

function anim_edit_body_slot:startAnimation()
	self.animation_timer:stop()
	self.animation_timer:start(0.1,self.animator_func)
end

function anim_edit_body_slot:stopAnimation()
	self.animation_timer:stop()
end

function anim_edit_body_slot:refresh_body_slot_pos(dir)
	local stept = SIZE * 15 * dir
	for i = 1, #self.timelines do
		local temp_pos = self.timelines[i].view:getPositionS()
		self.timelines[i].view:setPosition(temp_pos.x + stept, temp_pos.y)
		if i >= g_begin_index and i <= g_begin_index * 60  then
			self.timelines[i].view:setIsVisible(true)
		else
			self.timelines[i].view:setIsVisible(false)
		end
	end
end

function anim_edit_body_slot:reinit_body_slot_pos()
	local temp_pos = self.timelines[1].view:getPositionS()
	local stept = 8 - temp_pos.x
	for i = 1, #self.timelines do
		local temp_pos = self.timelines[i].view:getPositionS()
		self.timelines[i].view:setPosition(temp_pos.x + stept, temp_pos.y)
		if i >= g_begin_index and i <= g_begin_index * 60  then
			self.timelines[i].view:setIsVisible(true)
		else
			self.timelines[i].view:setIsVisible(false)
		end
	end
end