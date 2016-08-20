movieActorManager = {}

local entityCreator = ZXEntityMgr:sharedManager()

function movieActorManager:init()
	print('movieActorManager:init')
	self.actors = {}
	self.scene_actors = {}
	self.root = SceneManager.SceneEntityRoot
end

function movieActorManager:createActor(name,data,clonePlayer,isSceneActor)
	local outfit = nil
	if clonePlayer then
		local player = EntityManager:get_player_avatar()
		outfit = { path = player.body_path, eType = 0 }
	else
		outfit = movie_actors[name]
	end
	local model =  entityCreator:createModel(outfit.eType, 0, data.dir)
	model = ZXEntityMgr:toActor(model)
	local actor = movieActor(model)

	actor:changeBody(outfit.path)
	actor:playAction(ZX_ACTION_IDLE,data.dir)
	actor:relocate(data.pos[1],data.pos[2])
	self.root:addChild(model,model:getPositionY());
	if isSceneActor then
		print('movieActorManager:createActor [scene]',name,isSceneActor)
		self.scene_actors[name] = actor
	else
		print('movieActorManager:createActor [movie]',name,isSceneActor)
		self.actors[name] = actor
	end
	model:setupShadow()
end

function movieActorManager:getActor(name, _isEntity)
	if name == 'player' then
		return EntityManager:get_player_avatar()
	end
		
	if not _isEntity then
		local actor = self.actors[name]
		if not actor then
			actor = self.scene_actors[name]
			if not actor then
				xprint('movieActorManager:getActor failed',name)
			end
		end
		return actor
	else
		local actor = EntityManager:get_entity_by_name(name)
		if not actor then
			print('movieActorManager:getActor failed',name)
		end
		return actor
	end
	
end

function movieActorManager:killActor(name,style)
	local actor = self.actors[name]
	
	if actor then
		print('kill actor [movie]', name)
		actor:destory(style)
		self.actors[name] = nil
	else
		local actor = self.scene_actors[name]
		if actor then
			print('kill actor [scene]', name)
			actor:destory(style)
			self.scene_actors[name] = nil
		else
			print('could not kill actor', name)
		end
	end
end

function movieActorManager:stop()
	print('kill all actors')
	if self.actors then
		for k, actor in pairs(self.actors) do
			actor:destory()
		end
	end
	self.actors = {}
end

function movieActorManager:onSceneLeave()
	print('kill all scene_actors')
	if self.scene_actors then
		for k, actor in pairs(self.scene_actors) do
			actor:destory()
		end
	end
	self.scene_actors = {}
end