super_class.ProgressImg()

function ProgressImg:__init(file)
	local s = CCSprite:spriteWithFile(file);
    s:setPosition(CCPoint(100,100))
    local rot_act = CCRotateBy:actionWithDuration(10, 1800);
    local rep = CCRepeatForever:actionWithAction(rot_act)
    s:runAction(rep)
    self.timer = timer()
    self.view = s
end

function ProgressImg:destory()
	-- body
	self.timer:stop()
	self.view = nil
end


