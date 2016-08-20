-- UserEquipWin.lua
-- created by gzn on 2014-9-16
-- 角色装备窗口  user_equip_win

super_class.UserEquipWin(NormalStyleWindow)

require "UI/userAttrWin/UserEquipPanel"
require "model/UserInfoModel"
require "utils/UI/UILabel"
require "entity/EntityManager"

function UserEquipWin:__init( window_name, texture_name, is_grid, width, height )

    self.all_page_t = {}              -- 存储所有已经创建的页面
    --背景框
    local bgPanel = self.view  
    self.current_page_select_index = 1

    -- 一些属性
    self.current_panel = nil             -- 当前panel

    -- 默认打开装备界面
    self:change_page( 1 )

    self.view:setDefaultMessageReturn(true)
end

--切换功能窗口
function UserEquipWin:change_page( but_index )
    self.current_page_select_index = but_index
    -- self.raido_btn_group:selectItem( but_index - 1)

    --先清除当前界面
    if self.current_panel then
        self.current_panel.view:setIsVisible(false)     -- 最终要使用这个来隐藏
    end
    if but_index == 1 then
        if self.all_page_t[1] == nil then
            self.all_page_t[1] = UserEquipPanel( self.view )
        end
        self.current_panel = self.all_page_t[1]
        self.current_panel:update()
    end
    self.current_panel.view:setIsVisible(true)
end

-- 供外部调用，刷新所有数据
function UserEquipWin:update_win( update_type )
    require "UI/UIManager"
    local win = UIManager:find_visible_window("user_equip_win")
    if win then
        -- 把数据交给背包窗口显示
        win:update( update_type );   
    end
end

--刷新所有属性数据
function UserEquipWin:update( update_type )

    if update_type == "equipment" then
        
    -- elseif update_type == "qqvip" then
    --     self:update_qqvip()
    elseif update_type == "attribute" then

    elseif update_type == "body" then
        self:update_equip_panel_model( update_type )
    elseif update_type == "wing" then
        self:update_equip_panel_model( update_type )
    elseif update_type == "weapon" then
        self:update_equip_panel_model( update_type )
    elseif update_type == "remove_pj_effect" then
        self:update_equip_panel_model( update_type )
    elseif update_type == "update_pj_effect" then
        self:update_equip_panel_model( update_type )
    end

    if self.current_panel.update then
        print("UserEquipWin:update_win( update_type )",update_type)
        self.current_panel:update()
    end
end

-- 卸下装备回调，停止可能存在的向上箭头特效，并显示“+”图标
function UserEquipWin:update_equip_panel_effect_and_btn( item_type )
    -- if self.all_page_t[1] then
    --     self.all_page_t[1]:update_effect_and_btn( item_type )
    -- end
end

-- 更新装备面板 模型
function UserEquipWin:update_equip_panel_model( update_type )
    if self.all_page_t[1] then
        self.all_page_t[1]:update_model( update_type )
    end
end

-- 打开或者关闭是调用. 参数：是否激活
function UserEquipWin:active( if_active )
    if if_active then
        self:update()
    end

    if self.all_page_t[1] then
        self.all_page_t[1]:active( if_active )
    end
end

function UserEquipWin:destroy()
    Window.destroy(self)
    -- for key, page in pairs(self.all_page_t) do
    --     page:destroy()
    -- end
end