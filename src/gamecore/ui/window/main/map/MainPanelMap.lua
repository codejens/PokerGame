--MainPanelMap.lua
--created by liubo on 2015-05-14
--主界面操控杆模块

MainPanelMap = simple_class(GUIStudioView)

local _LAYOUT_FILE = "layout/studio/mainpanel/map/stu_mainpanel_map.lua"     -- 本页的布局文件

---对外接口---

--地图点击回调
local function map_cb_func()
    MainPanelCC:map_cb()
end
--------------

function MainPanelMap:__init( view )
	self:register_listener()
end

--初始化页
function MainPanelMap:viewCreateCompleted() 
	self.view:setPosition(849,520)
    self.map_name = self:findLayoutViewByName("T_Map_Name") --地图名字
    self.map_pos = self:findLayoutViewByName("T_Map_Pos") --地图坐标
end

-- 注册事件回调
function MainPanelMap:register_listener( ... )

   --地图监听
    local function cb_func( sender,eventType )
        if eventType == ccui.TouchEventType.ended then
            map_cb_func()
        end
    end 
    self:widgetTouchEventListener('B_Map',cb_func)
end

-- 创建接口
function MainPanelMap:create(  )
	return self:createWithLayout( _LAYOUT_FILE )
end

-- 更新地图名字
function MainPanelMap:update_map_name( data )
    if not data then
        return
    end
    self.map_name:setString(data.name)
end

-- 更新地图坐标
function MainPanelMap:update_map_pos( data )
    if not data then
        return
    end
    self.map_name:setString("(".. data.x .. "," .. data.y .. ")")
end

-- 更新
-- @param update_type 更新类型
-- @param data 更新的数据 
function MainPanelMap:update( update_type, data )
	if update_type == "name" then 
        self:update_map_name( data )
    elseif update_type == "pos" then
        self:update_map_pos( data )
    elseif update_type == "all" then
        self:update_map_name( data )
        self:update_map_pos( data )
	end
end

--- 变成激活（显示）情况调用
function MainPanelMap:active(  )

end

-- 变成 非激活
function MainPanelMap:unActive(  )

end