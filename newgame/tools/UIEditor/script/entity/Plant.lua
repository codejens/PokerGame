-- Plant.lua
-- created by aXing on 2012-12-1
-- 游戏场景中的采集怪的实体类

require "entity/Actor"

Plant = simple_class(Actor)

local frameloc = "scene/monster/"

function Plant:__init( handle )
	Actor.__init(self,handle)
	self.type = "Plant"
end

-- 实体更改自己的属性
function Plant:change_entity_attri( attri_type, attri_value )
	local old_value 	= self[attri_type]
	Actor.change_entity_attri(self, attri_type, attri_value)
	self[attri_type]	= attri_value
	
	-- 以下是怪物属性变更的时候，触发的事件
	if attri_type == "model" then
		self.model = ZXEntityMgr:toPlant(attri_value)
		if self.model == nil then
			print("ERROR:: entity转换plant出错！")
			return
		end
		self:register_click_event()
	elseif attri_type == "body" then
		if self.model ~= nil then
			local current_scene_name = SceneManager:get_current_scene_name()
			-- edited by aXing on 2013-4-9
			-- 将采集怪改为单帧图片
			local path = frameloc .. attri_value -- .. "/00000.png"
			self.model:changePlant(path)
		end
	end
end