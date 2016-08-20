-- UserAttrWin.lua
-- created by lyl on 2012-12-4
-- 角色属性窗口  user_attr_win

super_class.UserAttrWin(NormalStyleWindow)

require "UI/userAttrWin/UserAttrPanel"
require "model/UserInfoModel"
require "utils/UI/UILabel"
require "entity/EntityManager"

function UserAttrWin:__init( window_name, texture_name, is_grid, width, height )

    -- xprint('UserAttrWin >>>>>>>>', window_name, texture_name, is_grid, width, height )
    self.all_page_t = {}              -- 存储所有已经创建的页面
    --背景框
    local bgPanel = self.view  
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
 --    local but_close = CCNGBtnMulTex:buttonWithFile( 340 , 377, -1, -1, UIResourcePath.FileLocate.common .. "close_btn_z.png")
 --    local exit_btn_size = but_close:getSize()
 --    local spr_bg_size = bgPanel:getSize()
 --    but_close:setPosition( spr_bg_size.width - exit_btn_size.width, spr_bg_size.height - exit_btn_size.height )
 --    but_close:addTexWithFile(CLICK_STATE_DOWN, UIResourcePath.FileLocate.common .. "close_btn_z.png")
	-- local function but_close_fun(eventType,x,y)
	-- 	if eventType == TOUCH_CLICK then
 --            -- require "UI/UIManager"
 --            UIManager:hide_window( "user_attr_win" )
	-- 		return true
	-- 	end
 --        return true
	-- end
 --    but_close:registerScriptHandler(but_close_fun)    --注册
 --    bgPanel:addChild(but_close, 10)



    -- 侧面所有按钮
    -- self.but_t = {}            -- 存放所有按钮，设置按钮状态
    -- local but_beg_x = 50          --按钮起始x坐标
    -- local but_beg_y = 510+60       --按钮起始y坐标
    -- local but_int_x = 100         --按钮y坐标间隔
    -- self.raido_btn_group = CCRadioButtonGroup:buttonGroupWithFile(but_beg_x ,but_beg_y , but_int_x * 5,48,"")
    -- bgPanel:addChild(self.raido_btn_group)
    -- self.raido_btn_group:setIsVisible(false)
    -- 创建5个标签页
    -- for i=1,5 do
    --     self:create_a_button(self.raido_btn_group,  1 + but_int_x * (i - 1),0, -1, -1,
    --     UIResourcePath.FileLocate.common .. "xxk-4.png",
    --     UIResourcePath.FileLocate.common .. "xxk-3.png",
    --     UIResourcePath.FileLocate.renwu .. string.format("title_jcxx-%d.png",i),80, 22, i)--title_jcxx-1
    -- end
    -- --底色
    -- local colour_bg = CCZXImage:imageWithFile(40,11,339,382,UIPIC_GRID_nine_grid_bg3,500,500)
    -- bgPanel:addChild(colour_bg)

    -- 默认打开装备界面
    self:change_page( 2 )

    --最上层的贴图
    -- local bgPanel_2 = CCZXImage:imageWithFile( 80, 388, -1, -1, UIResourcePath.FileLocate.common .. "title_bg_b.png");  --头部
    -- bgPanel:addChild( bgPanel_2, 10 )
    -- local bgPanel_3 = CCZXImage:imageWithFile( 145, 396, -1, -1, UIResourcePath.FileLocate.renwu .. "title_renwu.png");  --标题名称
    -- bgPanel:addChild( bgPanel_3, 10 )

    -- self.view = bgPanel
    self.view:setDefaultMessageReturn(true)
end

-- 创建一个按钮:参数： 要加入的panel， 坐标和长宽，按钮两种状态背景图，显示文字图片，文字图片的长宽，序列号（用于触发事件判断调用的方法）
-- function UserAttrWin:create_a_button(panel, pos_x, pos_y, size_w, size_h, image_n, image_s ,but_name, but_name_siz_w, but_name_siz_h, but_index)
--     local radio_button = CCRadioButton:radioButtonWithFile(pos_x, pos_y, size_w, size_h, image_n)
--     radio_button:addTexWithFile(CLICK_STATE_DOWN,image_s)
--     local function but_1_fun(eventType,x,y)
--         if eventType ==  TOUCH_BEGAN then 
--             --根据序列号来调用方法
--             return true
--         elseif eventType == TOUCH_CLICK then
--             self:change_page( but_index )

--             return true;
--         elseif eventType == TOUCH_ENDED then
            
--             return true;
--         end
--     end
--     radio_button:registerScriptHandler(but_1_fun)
--     panel:addGroup(radio_button)

--     --按钮显示的名称
--     local name_image = CCZXImage:imageWithFile( 48,18, but_name_siz_w, but_name_siz_h, but_name ); 
--     name_image:setAnchorPoint(0.5,0.5)
--     radio_button:addChild( name_image )
-- end

--切换功能窗口:   1:装备   2：信息  3:buff
-- -1:info 2:lingen 3:skill 4:exchange 5:buff
function UserAttrWin:change_page( but_index )
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
        -- 显示其他玩家数据
        if _if_show_other_player then
            self.current_panel:show_equip_by_equip_list( _other_equip_list, _other_player )
        else
            self.current_panel:update()
        end
    elseif  but_index == 2 then
        if self.all_page_t[2] == nil then
            self.all_page_t[2] = UserAttrPanel( self.view )
        end 
        self.current_panel = self.all_page_t[2]
        if _if_show_other_player then
            self.current_panel:flash( _other_player )
        else
            self.current_panel:update()
        end
    -- -- buff
    -- elseif but_index == 3 then
    --     if self.all_page_t[3] == nil then
    --         self.all_page_t[3] = UserSkillPanel( self.view )
    --     end
    --     self.current_panel = self.all_page_t[3]
    --     self.current_panel:update()
    -- elseif but_index == 4 then
    --     if self.all_page_t[4] == nil then
    --         self.all_page_t[4] = UserExchangePanel( self.view )
    --     end
    --     self.current_panel = self.all_page_t[4]
    --     self.current_panel:update()
    -- elseif but_index == 5 then
    --     if self.all_page_t[5] == nil then
    --         self.all_page_t[5] = UserBuffsPanel( self.view )
    --     end
    --     self.current_panel = self.all_page_t[5]
    --     self.current_panel:update()

    end
    self.current_panel.view:setIsVisible(true)
end

--
function UserAttrWin:create( texture_name )
    -- local bgPanel = UserAttrWin( 10, 46, 389, 429, texture_name );
	return UserAttrWin( texture_name, 10, 46, 389, 429);
end

-- 供外部调用，刷新所有数据
function UserAttrWin:update_win( update_type )
    require "UI/UIManager"
    local win = UIManager:find_visible_window("user_attr_win")
    if win then
        -- 把数据交给背包窗口显示
        win:update( update_type );   
    end
end

--刷新所有属性数据
function UserAttrWin:update( update_type )
    if _if_show_other_player then
        return 
    end

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
        print("UserAttrWin:update_win( update_type )",update_type)
        self.current_panel:update()
    end
end

-- 卸下装备回调，停止可能存在的向上箭头特效，并显示“+”图标
function UserAttrWin:update_equip_panel_effect_and_btn( item_type )
    -- if self.all_page_t[1] then
    --     self.all_page_t[1]:update_effect_and_btn( item_type )
    -- end
end

-- 更新装备面板 模型
-- 目前UserAttrWin仅有UserAttrPanel，UserEquipPanel交给UserEquipWin去显示了，所以不应该进入这里刷新 note by guozhinan
function UserAttrWin:update_equip_panel_model( update_type )
    -- if self.all_page_t[1] then
    --     self.all_page_t[1]:update_model( update_type )
    -- end
end

-- 显示全身强化或者镶嵌宝石全身等级面板. 参数：类型：star  sun
function UserAttrWin:show_body_level_panel( type )
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
function UserAttrWin:close_body_level_panel(  )
    if self.has_show_star_or_sun then
        self.view:removeChild( self.body_level_panel, true )
    end
    self.has_show_star_or_sun = false
end

-- 打开或者关闭是调用. 参数：是否激活
function UserAttrWin:active( if_active )
    if if_active then
        self:update()
        --没用到的变量删掉
        --_if_show_other_plaelseyer = false 
    end

    if self.all_page_t[1] then
        self.all_page_t[1]:active( if_active )
    end
end


-- 打开显示其他角色的面板, 参数：其他玩家角色的信息数据对象， 装备列表(UserItem结构)
function UserAttrWin:open_other_panel( player_obj, equip_list )
    _other_player = player_obj
    _other_equip_list = equip_list

    local win = UIManager:show_window( "user_attr_win" )
    _if_show_other_player = true
    win:change_page( 1 )

    for key, equipment in pairs(equip_list) do
        local str_temp = ""
        for k, v in pairs(equipment) do
            str_temp = str_temp.." ;  "..k.."  "..tostring(v)
        end
    end

end

function UserAttrWin:destroy()
    _if_show_other_plaelseyer = false 
    Window.destroy(self)
    -- for key, page in pairs(self.all_page_t) do
    --     page:destroy()
    -- end
end

-- buff面板添加一个buff
-- function UserAttrWin:add_buff( buff )
--     -- 暂未知道调用路径，先断言一下，等触发报错再重定向到正确页面去刷新
--     assert(false)
--     if ( self.all_page_t[3] ) then
--         self.all_page_t[3]:add_buff( buff );
--     end
-- end

-- buff面板删除一个buff
-- function UserAttrWin:remove_buff( buff_type ,buff_group)
--     -- 暂未知道调用路径，先断言一下，等触发报错再重定向到正确页面去刷新
--     assert(false)
--     if ( self.all_page_t[3] ) then
--         self.all_page_t[3]:remove_buff( buff_type,buff_group );
--     end
-- end

-- function UserAttrWin:update_qqvip()
--     if self.all_page_t[1] ~= nil then
--         self.all_page_t[1]:update_qqvip()
--     end
-- end