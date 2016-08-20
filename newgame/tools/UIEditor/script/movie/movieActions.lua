movieActorMove = simple_class()

function movieActorMove:__init(target,sx,sy,ex,ey)
	local pScene	= ZXGameScene:sharedScene():toPtr()
	self.target = target
	self.path = SceneManager.sceneFindPath(sx, sy, ex, ey)
	self.index = 1
	self:nextStep()
end

function movieActorMove:nextStep()
	local index = self.index
	local next_i = index + 1

	--print('@@',index,next_i)
	if next_i > #self.path then
		self.target:idle()
		self.target:onActionEnd()
		return false
	end

	local x = self.path[index]
	local y = self.path[next_i]
	
	self.target:startMove(x,y)
	self.index = self.index + 2
	return true
end

function movieActorMove:onMoveStop()
	return self:nextStep()
end

function movieActorMove:stop()
	self.path = {}
end