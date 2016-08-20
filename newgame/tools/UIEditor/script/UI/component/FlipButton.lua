super_class.FlipButton()

-- 创建sprite
local function create_sprite(parent,filepath,pos_x,pos_y)

    local spr = CCSprite:spriteWithFile(filepath);
    spr:setPosition(CCPoint(pos_x,pos_y));
    spr:setAnchorPoint(CCPointMake(0.5,0.5))
    parent:addChild(spr);
    return spr;
end

function FlipButton:__init(pos_x,pos_y,width,height,image,fun)
	self.view = CCBasePanel:panelWithFile(pos_x, pos_y, width, height, '',-1,-1)
	self.callback = fun
	self.img = create_sprite(self.view,image,width*0.5,height*0.5)
	self:registerScriptFun()
end

function FlipButton:registerScriptFun()
	if self.view ~= nil then
		local function basePanelMessageFun(eventType, args, msgid, selfItem)
			-------
			if eventType == nil or args == nil or msgid == nil or selfItem == nil then
				return 
			end
			-------
			if eventType == TOUCH_BEGAN then
				return true

			elseif eventType == TOUCH_MOVED then
				return true

			elseif eventType == TOUCH_ENDED then
				return true

			elseif eventType == TOUCH_CLICK then
				self.img:setFlipX(not self.img:isFlipX())
				self.callback()
				return true

			elseif eventType == TOUCH_DOUBLE_CLICK then
				return true

			elseif eventType == TIMER then
				return true
			end
		end
		-------
		self.view:registerScriptHandler(basePanelMessageFun)
	end
end

function FlipButton:show_frame(i)
	if i == 1 then
		self.img:setFlipX(false)
	else
		self.img:setFlipX(true)
	end
end

function FlipButton:rotate_frame( i )
	local rotation_act = CCRotateTo:actionWithDuration(0.25, 90 * i)
	self.img:runAction( rotation_act )
end