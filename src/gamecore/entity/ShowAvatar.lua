-- ShowAvatar.lua
-- created by lyl on 2013-3-23
-- 面板显示用的实体

ShowAvatar = simple_class()

local _AsyncLoadOption = resourceHelper.getAsyncLoadOption
local _priority = ASYNC_PRIORITY.ANIMATION

-- tab_equip_info 装备信息
function ShowAvatar:__init( x,y)

   self.view = ccsext.LPRenderSlotHolder:create()
   self.view:setPosition(x,y)
   self:load_body()
end

function ShowAvatar:loadCallBack( ... )
    self.view:playAction(2,true)
end 

--加载挂件
function ShowAvatar:loadSlot(slotname, skin)
    local option = _AsyncLoadOption(skin,slotname,_priority,bind(ShowAvatar.loadCallBack,self))
    self.view:loadSlotAsync(slotname,option)
end

--加载身体
function ShowAvatar:loadBody(skinname,action)
    local option = _AsyncLoadOption(skinname,'body',_priority,bind(ShowAvatar.loadCallBack,self))
    local frameConfig =  skinname .. ".json"
    self.view:loadBodyAsync(action,
                             frameConfig,
                             option)
end

--子类按需求写 加载模型
function ShowAvatar:load_body( body_id )
    local json = EntityConfig:get_action_json( -1 )

    local body = self:get_body_path(body_id)
    self:loadBody(body,json)
    self:loadSlot('weapon','animations/weapon/001/001')

end

function ShowAvatar:get_body_path( body_id )
    local body = EntityConfig:get_body_path( -1, body_id )
    --todo 
    --根据职业性别获取具体路径 res
    local res = "001/002"
    body = body..res
    return body
end

-- 创建身体
function ShowAvatar:udpate_body( body ,tab_equip_info )

end

-- 创建翅膀
function ShowAvatar:update_wing( wing )

end

-- 创建武器
function ShowAvatar:update_weapon( weapon )
    -- 武器特效要脱下装备才会刷新，这里先脱下

end

-- 状态变更， 例如 真龙之魂显示特效
function ShowAvatar:update_zhenlong( if_zhenlong )
 
end

-- 创建人物面板 的avatar
function ShowAvatar:create_user_panel_avatar( x, y ,equip_info)

end

-- 创建翅膀界面 的avatar
function ShowAvatar:create_wing_panel_avatar( x, y )
    
end

-- 创建其他玩家信息面板的 avatar
function ShowAvatar:create_other_panel_avatar( x, y, player_obj )

end

-- 其他玩家avatar的更新，要传入一个entity
function ShowAvatar:other_player_change_attri( attri_type, player_obj )

end

-- 更新属性
function ShowAvatar:change_attri( attri_type ,tab_equip_info )


end

--更新整个Avatar
function ShowAvatar:update_all(  )

end

-- 显示品阶特效 
function ShowAvatar:show_pj_effect( tab_equip_info )


end
function ShowAvatar:remove_pj_effect( tab_equip_info )

end