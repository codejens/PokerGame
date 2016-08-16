local _refWidth =  UIScreenPos.relativeWidth
local _refHeight = UIScreenPos.relativeHeight
local panelWidth =  _refWidth(1.0)
local panelHeight = _refHeight(1.0)


ScreenMask = simple_class()

--[[
params
	mask 
]]

function ScreenMask:__init(params)
	local mask = SPanel:create( (params and params.mask) or "nopack/xszy/zezhao1.png",panelWidth,panelHeight, true)
	self.mask = mask
	local root = ZXLogicScene:sharedScene():getUINode()
	--先删除 再添加 以免重复
	root:removeChildByTag(UI_TAG_SCREENMASK,true)
	root:addChild(mask.view, Z_SCREENMASK, UI_TAG_SCREENMASK)
	mask:set_click_func(function() 
		-- print "touch:set_click_func >>>>"
	end)

	self.expand = {}
end

function ScreenMask:remove()
	local root = ZXLogicScene:sharedScene():getUINode()
	root:removeChildByTag(UI_TAG_SCREENMASK,true)
end

function ScreenMask:update(utype, data)
	if utype == "pipe_mode" then
		if data[1] == "time" then
			self.expand.update_time(data[2])
		elseif data[1] == "cancel" then
			self.expand.update_cancel_time(data[2])
		end

	end
end

-------------------------------------- 扩展 ----------------------------------------

function ScreenMask:create_pipe_mode(btn_callback)
	local bg = SPanel:create( "", 392*2, 247)
	bg:setAnchorPoint(0.5, 0.5)
	bg:setPosition(panelWidth/2, panelHeight/2)
	self.mask:addChild(bg.view, 100)

	--left
	local bg_left = CCBasePanel:panelWithFile( 0, 0, -1, -1, "sui/common/bg_pipei2.png")
	bg:addChild( bg_left)

	local bg_right = CCBasePanel:panelWithFile( 392, 0, -1, -1, "sui/common/bg_pipei2.png")
	bg_right:setFlipX(true)
	bg:addChild( bg_right)

	local lb = SLabel:create( "#cFCF7CD正在匹配中", 24, ALIGN_CENTER)
	lb:setPosition(392,170)
	bg:addChild(lb.view)

	local time_lb = SLabel:create( "#cFF8A4700:00", 24, ALIGN_CENTER)
	time_lb:setPosition(392,115)
	bg:addChild(time_lb.view)

	local btn = SButton:create( "sui/common/btn2_s.png", "sui/common/btn2_s.png", "sui/common/btn_dis.png" )
	--btn:set_state_img( CLICK_STATE_DISABLE, "sui/common/btn_dis.png" )
	btn:setPosition(392-70,35)
	bg:addChild(btn.view)
	btn.view:setCurState( CLICK_STATE_DISABLE )
	local function callback()
		self:remove()
		btn_callback()
	end
	btn:set_click_func(callback)

	-- local img = SImage:create("sui/btn_name/quxiao.png")
	-- img:setAnchorPoint(0.5, 0.5)
	-- img:setPosition(60, 30)
	-- btn:addChild(img.view)

	local cancel_time_lb = SLabel:create( "#cF8EEE2取消(3)", 24, ALIGN_CENTER)
	cancel_time_lb:setPosition( 137*0.5, 14)
	btn:addChild(cancel_time_lb.view)

	local function update_time(numb)
		local str = Utils:second_to_time_str( numb, true)
		time_lb:setText("#cFF8A47" .. str)
	end

	local function update_cancel_time(numb)
		if numb > 0 then
			cancel_time_lb:setText(string.format("#cF8EEE2取消(%d)", numb))
		else
			local tmp_size = btn:getSize()
			-- img:setPosition(tmp_size.width/2, tmp_size.height/2)
			-- cancel_time_lb:setIsVisible(false)
			cancel_time_lb:setText("#cF8EEE2取消")
			btn.view:setCurState( CLICK_STATE_UP)
		end
	end

	self.expand.update_time = update_time
	self.expand.update_cancel_time = update_cancel_time
end
