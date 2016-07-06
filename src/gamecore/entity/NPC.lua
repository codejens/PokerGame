-- NPC.lua
-- created by aXing on 2012-12-1
-- 游戏场景中NPC实体类

NPC = simple_class(Actor)

local frameloc = "scene/npc/"

function NPC:__init( handle )

end

-- 属性改变需要做的处理。  例如某个属性改变，向通知中心发送一个通知
function NPC:change_attr_event( attri_type, attri_value, attr_value_old  )
	Actor.change_attr_event(self,attri_type, attri_value, attr_value_old)

end

