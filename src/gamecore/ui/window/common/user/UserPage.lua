--UserPage.lua
--created by lyl on 2015-05-11
--人物窗口

UserPage = simple_class(GUIStudioView)

local _LAYOUT_FILE = "layout/studio/common/user/stu_user_page.lua"     -- 本页的布局文件


function UserPage:__init( view )
	self.equip_block = nil        -- 装备块
	self.bag_block   = nil        -- 背包块
end

--初始化页
function UserPage:viewCreateCompleted() 
	local equipView = self:findLayoutViewByName( "equip_block" )
    self.equip_block = UserEquipBlock( equipView )  -- 让 UserEquipBlock 去管理这部分。

    local bag_view = self:findLayoutViewByName( "bag_block" )
    self.bag_block = UserBagBlock( bag_view )
end

-- 创建接口
function UserPage:create(  )
	return self:createWithLayout( _LAYOUT_FILE )
end

-- 更新
-- @param update_type 更新类型
-- @param data 更新的数据 
function UserPage:update( update_type, data )
	if update_type == "" then 
        
    else
    	self.equip_block:update( update_type, data )
    	self.bag_block:update( update_type, data )
	end
end

--- 变成激活（显示）情况调用
function UserPage:active(  )
	self.equip_block:active()
	self.bag_block:active()
end

-- 变成 非激活
function UserPage:unActive(  )
	self.equip_block:unActive()
	self.bag_block:unActive()
end