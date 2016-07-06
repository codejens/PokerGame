-- Avatar.lua
-- created by aXing on 2012-12-1
-- 游戏场景中玩家的实体
-- 主要实现了玩家的属性，如装备，翅膀，法宝等

-- require "entity/Actor"
-- require "config/EntityConfig"

Avatar = simple_class(Actor)

local _AsyncLoadOption = resourceHelper.getAsyncLoadOption
local _priority = ASYNC_PRIORITY.ANIMATION



function Avatar:__init( handle )
	-- Actor.__init(self,handle)
	self.model_body = self.model--:getBody()


end

-- 实体析构
function Avatar:destroy(  )
	Actor.destroy(self)
end

-- function Avatar:init_model(  )
	-- 子类重写
	-- return ccsext.LPRenderSlotHolder:create()
-- end


--根据动作ID构建动作
function Avatar:_prepareAction( action_id,loop )
	return self.model_body:prepareAction(action_id,loop or false)
end

--执行动作
function Avatar:_runAction( action )
	return self.model_body:runAction(action)
end

--加载挂件回调
function Avatar:onPartLoad(res, slotname, skinname)
	print("加载挂件回调",res, slotname, skinname)
	if res == 0 then
		--self.model:playAction(0,true)
		self.model:playAction(1,true)
	else
		--TODO FAILED reload
	end
end

--加载挂件
function Avatar:loadSlot(slotname, skin)
    local option = _AsyncLoadOption(skin,slotname,_priority,bind(Avatar.onPartLoad,self))
    self.model:loadSlotAsync(slotname,option)
end

--加载身体
function Avatar:loadBody(skinname,action)
	local option = _AsyncLoadOption(skinname,'body',_priority,bind(Avatar.onPartLoad,self))
	local frameConfig =  skinname .. ".json"
	self.model:loadBodyAsync(action,
							 frameConfig,
							 option)
end

-- 复活
function Avatar:relive(  )
	-- lp todo
	
end

-- 上坐骑
function Avatar:get_on_riding(  )
	-- if self.model then 
 --        self.model:get_on_riding(  )
	-- end
end

-- 下坐骑
function Avatar:get_off_riding(  )
	-- if self.model then 
 --        self.model:get_off_riding(  )
	-- end
end



-- 设置根据角色当前属性的默认形象
-- 如果身体外形索引为0则应按照职业和性别设置默认的形象
-- 外观资源包编号规则：类型 + 职业 + 性别 + 等级 + 种类，共5位
-- 类型：0-衣服，2-时装，1用于武器
-- 职业和性别：0表示通用，否则表示对应的编号
-- 等级：int(角色真实等级 / 20)
-- 种类：如果最高位为0，则表示是否套装，0-散件，1-套装；如果最高位为2，则表示时装的编号
function Avatar:update_default_body( attri_value )
    -- lp todo
	
end

-- 属性改变需要做的处理。  例如某个属性改变，向通知中心发送一个通知
function Avatar:change_attr_event( attri_type, attri_value, attr_value_old  )
	Actor.change_attr_event(self,attri_type, attri_value, attr_value_old)
	if attri_type == "weapon" then
		-- self:loadSlot('weapon','animations/weapon/001/001')
	end
	
end

--子类按需求写 加载模型
function Avatar:load_body( body_id )
	local json = EntityConfig:get_action_json( self.type )

	local body = self:get_body_path(body_id)
	self:loadBody(body,json)
	--self:loadSlot('weapon','animations/weapon/001/001')

end

function Avatar:get_body_path( body_id )
	local body = EntityConfig:get_body_path( self.type, body_id )
	--todo 
	--根据职业性别获取具体路径 res
	local res = "002/001"
	body = body..res
	return body
end