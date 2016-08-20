-- OtherAttrWin.lua
-- created by lyl on 2012-12-4
-- 角色属性窗口  other_attr_win

require "UI/component/DraggableWindow"
super_class.OtherAttrWin(NormalStyleWindow)

require "UI/otherAttr/OtherEquipPanel"
require "UI/otherAttr/OtherAttrPanel"
require "utils/UI/UILabel"
require "entity/EntityManager"

local _if_show_other_player = false      -- 标记是否正在显示其他角色的
local _other_player         = nil        -- 显示其他角色信息时，其他角色的对象
local _other_equip_list     = {}         -- 其他角色的装备列表

--
function OtherAttrWin:__init( window_name, texture_name,is_grid,width,height)
    self.all_page_t = {}              -- 存储所有已经创建的页面
    -- self.radio_but_t = {}             -- 存储单个选择标签
    --背景框
    local bgPanel = self.view  
    self.current_page_select_index = 1
    -- 点击任何地方，都要关闭： 全身强化详细属性面板
    -- local function f1(eventType,x,y)
    --     if eventType == TOUCH_BEGAN then
    --         self:close_body_level_panel()
    --         return true
    --     end
    -- end
    -- bgPanel:registerScriptHandler(f1)    --注册

    -- 一些属性
    self.current_panel = nil             -- 当前panel

    --关闭按钮
 --    local but_close = CCNGBtnMulTex:buttonWithFile( 340 , 377, -1, -1, UIResourcePath.FileLocate.common .. "close_btn_n.png")
 --    local exit_btn_size = but_close:getSize()
 --    local spr_bg_size = bgPanel:getSize()
 --    but_close:setPosition( spr_bg_size.width - exit_btn_size.width, spr_bg_size.height - exit_btn_size.height )
 --    but_close:addTexWithFile(CLICK_STATE_DOWN, UIResourcePath.FileLocate.common .. "close_btn_s.png")
	-- local function but_close_fun(eventType,x,y)
	-- 	if eventType == TOUCH_CLICK then
 --            require "UI/UIManager"
 --            UIManager:hide_window( "other_attr_win" )
	-- 		return true
	-- 	end
 --        return true
	-- end
 --    but_close:registerScriptHandler(but_close_fun)    --注册
 --    bgPanel:addChild(but_close, 10)

    -- 侧面所有按钮
    -- self.but_t = {}            -- 存放所有按钮，设置按钮状态
    -- local but_beg_x = 2           --按钮起始x坐标
    -- local but_beg_y = 190         --按钮起始y坐标
    -- local but_int_y = 95          --按钮y坐标间隔

    -- self.raido_btn_group = CCRadioButtonGroup:buttonGroupWithFile(but_beg_x ,but_beg_y , 50, but_int_y * 2,nil)
    -- bgPanel:addChild(self.raido_btn_group,999)
    -- --取消原先分页
    -- self.raido_btn_group:setIsVisible(false)
    -- self:create_a_button(self.raido_btn_group, 8, 1 + but_int_y * (2 - 1), 35, 83, UIResourcePath.FileLocate.common .. "xxk-1.png",
    --  UIResourcePath.FileLocate.common .. "xxk-2.png", UIResourcePath.FileLocate.shop .. "zhuangbei.png",-1, -1, 1)
    -- self:create_a_button(self.raido_btn_group, 8, 1 + but_int_y * (1 - 1), 35, 83, UIResourcePath.FileLocate.common .. "xxk-1.png",
    --  UIResourcePath.FileLocate.common .. "xxk-2.png", UIResourcePath.FileLocate.shop .. "zhuangbei.png",-1, -1, 2)
    -- 默认打开装备界面
    self:change_page( 2 )

    --最上层的贴图
    -- local bgPanel_2 = CCZXImage:imageWithFile( 80, 388, -1, -1, UIResourcePath.FileLocate.common .. "win_title1.png");  --头部
    -- bgPanel:addChild( bgPanel_2, 10 )
    -- local bgPanel_3 = CCZXImage:imageWithFile( 135, 401, -1, -1, UIResourcePath.FileLocate.role .. "title_renwu.png");  --标题名称
    -- bgPanel:addChild( bgPanel_3, 10 )

    -- self.view = bgPanel
    self.view:setDefaultMessageReturn(true)
end

-- 创建一个按钮:参数： 要加入的panel， 坐标和长宽，按钮两种状态背景图，显示文字图片，文字图片的长宽，序列号（用于触发事件判断调用的方法）
-- function OtherAttrWin:create_a_button(panel, pos_x, pos_y, size_w, size_h, image_n, image_s ,but_name, but_name_siz_w, but_name_siz_h, but_index)
--     local radio_button = CCRadioButton:radioButtonWithFile(pos_x, pos_y, size_w, size_h, image_n)
--     radio_button:addTexWithFile(CLICK_STATE_DOWN,image_s)
--     local function but_1_fun(eventType,x,y)
--         if eventType == TOUCH_CLICK then 
--             --根据序列号来调用方法
--             self:change_page( but_index )
--             return true
--         elseif eventType == TOUCH_BEGAN then
--             return true;
--         elseif eventType == TOUCH_ENDED then
--             return true;
--         end
--     end
--     radio_button:registerScriptHandler(but_1_fun)
--     panel:addGroup(radio_button)

--     --按钮显示的名称
--     local name_image = CCZXImage:imageWithFile( 35/2, 83/2, but_name_siz_w, but_name_siz_h, but_name ); 
--     name_image:setAnchorPoint(0.5,0.5)
--     radio_button:addChild( name_image )

--     --local name_image = CCZXImage:imageWithFile( 4, 14, but_name_siz_w, but_name_siz_h, but_name ); 
--     --radio_button:addChild( name_image )
    
--     self.radio_but_t[but_index] = radio_button
-- end

--切换功能窗口:   1:装备   2：信息
function OtherAttrWin:change_page( but_index )
    self.current_page_select_index=but_index
    -- self.raido_btn_group:selectItem( but_index - 1)

    --先清除当前界面
    if self.current_panel then
        self.current_panel.view:setIsVisible(false)     -- 隐藏
    end
    if but_index == 1 then
        if self.all_page_t[1] == nil then
            self.all_page_t[1] = OtherEquipPanel( self.view )
        end
        self.current_panel = self.all_page_t[1]
        -- 显示其他玩家数据
        if _if_show_other_player then
            self.current_panel:show_equip_by_equip_list( _other_equip_list, _other_player )
        else
            self.current_panel:update()
        end
    elseif  but_index == 2 then
        if self.all_page_t[2] == nil then
            self.all_page_t[2] = OtherAttrPanel( self.view )
        end
        self.current_panel = self.all_page_t[2]
        if _if_show_other_player then
            self.current_panel:flash( _other_player )
        else
            self.current_panel:update()
        end
    end
    self.current_panel.view:setIsVisible(true)
end

function OtherAttrWin:create( texture_name )
	return UserAttrWin( texture_name, 10, 46, 389, 429);
end

-- 供外部调用，刷新所有数据
function OtherAttrWin:update_win( update_type )
    require "UI/UIManager"
    local win = UIManager:find_visible_window("other_attr_win")
    if win then
        -- 把数据交给背包窗口显示
        win:update( update_type );   
    end
end

--刷新所有属性数据
function OtherAttrWin:update( update_type )
    if _if_show_other_player then
        return 
    end

    if update_type == "equipment" then
        
    elseif update_type == "attribute" then

    end

    if self.current_panel.update then
        self.current_panel:update()
    end
end


-- 显示全身强化或者镶嵌宝石全身等级面板. 参数：类型：star  sun
function OtherAttrWin:show_body_level_panel( type )
    if self.has_show_star_or_sun then
        return
    end
    if type == "star" then
        self.body_level_panel = CCZXImage:imageWithFile( 30, 70, 210, 260, UIPIC_GRID_nine_grid_bg3, 500, 500)

    else
        self.body_level_panel = CCZXImage:imageWithFile( 30, 20, 210, 260, UIPIC_GRID_nine_grid_bg3, 500, 500) 

    end
    self.view:addChild( self.body_level_panel )
    self.has_show_star_or_sun = true
end

-- 关闭全身属性面板
function OtherAttrWin:close_body_level_panel(  )
    if self.has_show_star_or_sun then
        self.view:removeChild( self.body_level_panel, true )
    end
    self.has_show_star_or_sun = false
end

-- 打开或者关闭是调用. 参数：是否激活
function OtherAttrWin:active( if_active )
    if if_active then
        self:update()
    else
        _if_show_other_player = false
    end

    if self.all_page_t[1] then
        self.all_page_t[1]:active( if_active )
    end
end


-- 打开显示其他角色的面板, 参数：其他玩家角色的信息数据对象， 装备列表(UserItem结构), if_tianyuan: 是否是天元城之主
function OtherAttrWin:open_other_panel( player_obj, equip_list, if_tianyuan )
    print("OtherAttrWin:open_other_panel!!!~~", player_obj.name)
    if player_obj.name == nil then
        return
    end

    _other_player = player_obj
    _other_equip_list = equip_list

    local win = UIManager:show_window( "other_attr_win" )
    _if_show_other_player = true
    win:change_page( 2 )

    -- if if_tianyuan then 
        -- win.radio_but_t[2]:setIsVisible( false )
    -- else
        -- win.radio_but_t[2]:setIsVisible( true )
    -- end

    -- print("装备==============================================")
    -- require "utils/Utils"
    -- Utils:print_table_key_value( equip_list, nil )
    -- print("属性==============================================")
    -- Utils:print_table_key_value( player_obj, nil )

end

function OtherAttrWin:get_other_player_equip_list()
    return _other_equip_list;
end

function OtherAttrWin:destroy()
    _if_show_other_player = false
    Window.destroy(self)
    -- for key, page in pairs(self.all_page_t) do
    --     page:destroy()
    -- end
end