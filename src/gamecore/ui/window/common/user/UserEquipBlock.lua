--UserEquipBlock.lua
--created by lyl on 2015-05-11
--人物窗口

UserEquipBlock = simple_class(GUIPanel)


function UserEquipBlock:__init( view )
	self.user_bg = cocosHelper.findWidgetByName( self.view, "I_Bg" )    -- 人物背景

	self:create_fighting_label()
	self:create_avatar()
end

-- 创建战斗力组件
function UserEquipBlock:create_fighting_label()
	self.fighting = FightingLabel:create()
    self.user_bg:addChild(self.fighting.view)
    self.fighting:setBgPosition(100,40)
end

-- 创建人物
function UserEquipBlock:create_avatar()
	self.avatar = ShowAvatar(200,180)
    self.view:addChild(self.avatar.view)
end

-- 更新
-- @param update_type 更新类型
-- @param data 更新的数据 
function UserEquipBlock:update( update_type, data )
	if update_type == "avatar" then 

    elseif update_type == "fighting" then
    	self.fighting:setString(data)
    else

	end
end

--- 变成激活（显示）情况调用
function UserEquipBlock:active(  )
    -- notifySystem:postNotify( NOTICE_V_BAG_ACTIVE )
end

-- 变成 非激活
function UserEquipBlock:unActive(  )
    
end