-- StaticEntity.lua
-- created by aXing on 2012-12-1
-- 游戏场景中的静态实体
-- 主要是一些游戏静态场景特效(如火炬，传送门)

require "entity/Entity"

StaticEntity = simple_class(Entity)

function StaticEntity:__init( handle )
	Entity.__init(self,handle)
	print('StaticEntity:__init()',handle,self.handle)
end

function StaticEntity:change_entity_attri( attri_type, attri_value )
	local old_value 	= self[attri_type]
	Entity.change_entity_attri(self, attri_type, attri_value)
	self[attri_type]	= attri_value
	
	-- 以下是怪物属性变更的时候，触发的事件
	if attri_type == "model" then
		self.model = ZXEntityMgr:toStaticEntity(attri_value)
		if self.model == nil then
			print("ERROR:: entity转换StaticEntity出错！")
			return
		end

	elseif attri_type == "body" then
		self._body_id = attri_value
		EntityManager.setNPCBody(self)
	end
end

function StaticEntity:setBody()
	if self.model then
		self.body_path = string.format('frame/monster/%d',self._body_id)
		self.model:changeBody(self.body_path)
	end
end