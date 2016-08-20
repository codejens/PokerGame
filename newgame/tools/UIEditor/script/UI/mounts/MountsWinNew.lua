-- MountsWinNew.lua 
-- createed by mwy@2014-5-2
-- 新坐骑系统窗口
 
super_class.MountsWinNew(NormalStyleWindow)

-- 数字与 类型名称 的映射
local _index_to_category_name = { [1] = "info", [2] = "jinjie", [3] = "xilian", --[==[  [4] = "huaxing", [5] = "lingxi"  ]==] }

-- 初始化函数
function MountsWinNew:__init( window_name, texture_name )
    MountsModel:set_show_other_mounts( false )  -- 这个标志位已经废弃，显示其他人坐骑不再重用MountsWinNew窗口
	local bgPanel = self.view

    -- 侧面所有按钮
    local win_size = self.view:getSize();
    local but_beg_x  = 13            -- 按钮起始x坐标
    local but_beg_y  = win_size.height - 65 - 45            -- 按钮起始y坐标
    local but_int_x  = 107           -- 按钮x坐标间隔
    local btn_with   = 108 
    local btn_height = 45

    -- self.but_name_t = {}
    self.text_title = {Lang.mounts.common[10],Lang.mounts.common[11],Lang.mounts.common[12],}
    self.label_title = {}
    self.radio_btn_tab   = {}
    self.raido_btn_group = CCRadioButtonGroup:buttonGroupWithFile(but_beg_x ,but_beg_y , btn_with*5, btn_height,nil)
    bgPanel:addChild(self.raido_btn_group,100)
    
    -- 坐骑信息按钮
    self.radio_btn_tab[1] = self:create_a_button(self.raido_btn_group, 0 + but_int_x*0, 0, btn_with, btn_height, UILH_COMMON.tab_gray, UILH_COMMON.tab_light, UI_MountsWinNew_014,UI_MountsWinNew_044,1)

    -- 坐骑进阶按钮
    self.radio_btn_tab[2] = self:create_a_button(self.raido_btn_group, 0 + but_int_x*1, 0, btn_with, btn_height, UILH_COMMON.tab_gray, UILH_COMMON.tab_light, UI_MountsWinNew_011,UI_MountsWinNew_041,2)

    -- 坐骑洗练按钮(45级之后可见)
    self.radio_btn_tab[3] = self:create_a_button(self.raido_btn_group, 0 + but_int_x*2, 0, btn_with, btn_height, UILH_COMMON.tab_gray, UILH_COMMON.tab_light, UI_MountsWinNew_013,UI_MountsWinNew_043,3)
    self.radio_btn_tab[3]:setIsVisible( false );

     -- 记录每个列表，控制显示与隐藏
    self.list_scroll_t = {}   

    -- 坐骑信息页
    self.info_panel = MountsInfoPanel()
    self.view:addChild(self.info_panel.view)
    table.insert(self.list_scroll_t, self.info_panel)     

    -- 进阶页
    self.jinjie_panel =MountsJinJiePanel()
    self.view:addChild( self.jinjie_panel.view )
    table.insert( self.list_scroll_t, self.jinjie_panel )

    --洗炼页
    self.xilian_panel = MountsXiLianPanel()
    self.view:addChild( self.xilian_panel.view )
    table.insert( self.list_scroll_t, self.xilian_panel )

    -- --灵犀页
    -- self.lingxi_panel = MountsLingXiPanel()
    -- self.view:addChild( self.lingxi_panel.view )
    -- table.insert( self.list_scroll_t, self.lingxi_panel )

    -- -- 化形页
    -- self.huaxing_panel =MountsHuaXingPanel()
    -- self.view:addChild( self.huaxing_panel.view )
    -- table.insert( self.list_scroll_t, self.huaxing_panel )

    self.current_page = nil
    -- 初始化进入进阶页面
    --self:Choose_panel( "jinjie" )
    self:change_page(1)

    -- 关闭即销毁，为了预防“查看自己坐骑”和“查看别人坐骑”公用MountsWinNew界面会出现问题（目前没问题，仅是预防）
    -- 如果出现关闭、打开时的性能效率问题，可以考虑改回关闭时隐藏。note by guozhinan
    local function _close_btn_fun()
        Instruction:handleUIComponentClick(instruct_comps.CLOSE_BTN)
        -- 用于active只有在hide_window的时候调用，所以destroy_window时要手动调用一下
        MountsModel:set_show_other_mounts( false )
        -- UIManager:destroy_window("mounts_win_new")
        UIManager:hide_window("mounts_win_new")
    end
    self:setExitBtnFun(_close_btn_fun)
end


-- 选择显示的面板   equipment,  material 
function MountsWinNew:Choose_panel( panel_type, info )
    for key, scroll_view in pairs(self.list_scroll_t) do
        scroll_view.view:setIsVisible( false )
    end

    if panel_type == "jinjie" then
        self.jinjie_panel.view:setIsVisible( true )
        self.current_page = "jinjie"
        self.jinjie_panel:active(true)
    -- elseif panel_type == "huaxing" then
    --     self.huaxing_panel.view:setIsVisible( true )
    --     self.current_page = "huaxing"
    --     self.huaxing_panel:update(  ) 
    elseif panel_type == "xilian" then 
        self.xilian_panel.view:setIsVisible( true )
        self.current_page = "xilian"
        self.xilian_panel:update(  ) 
    -- elseif panel_type == "lingxi" then 
    --     self.lingxi_panel.view:setIsVisible( true )   
    --     self.current_page = "lingxi"
    --     self.lingxi_panel:update(  ) 
    elseif panel_type == "info" then
        self.info_panel.view:setIsVisible(true)
        self.current_page = "info"
        self.info_panel:active(true, info)
    end
end

-- 激活时更新数据
function MountsWinNew:active( show )
    if show then
        -- 获得玩家当前等级,判断灵犀标签页是否可见
        -- local player = EntityManager:get_player_avatar();
        -- if player then
        --     local level = player["level"];
        --     -- 控制洗练分页
        --     if level >= 45 then
        --         if not self.radio_btn_tab[3]:getIsVisible() then
        --             self.radio_btn_tab[3]:setIsVisible( true );
        --         end
        --     else
        --         if self.radio_btn_tab[3]:getIsVisible() then
        --             self.radio_btn_tab[3]:setIsVisible( false );
        --         end
        --     end
        --     -- 控制灵犀分页
        --     if level >= 50 then
        --         if not self.radio_btn_tab[4]:getIsVisible() then
        --             self.radio_btn_tab[4]:setIsVisible( true );
        --         end
        --     else
        --         if self.radio_btn_tab[4]:getIsVisible() then
        --             self.radio_btn_tab[4]:setIsVisible( false );
        --         end
        --     end
        -- end
        MountsModel:set_show_other_mounts( false )  -- 这个标志位已经废弃，显示其他人坐骑不再重用MountsWinNew窗口
        if not MountsModel:is_show_other_mounts() then
            -- self.window_title:setTexture(UIResourcePath.FileLocate.mount .. "mounts_title.png")
            -- self.raido_btn_group2:setIsVisible(false)
            -- self.raido_btn_group:setIsVisible(true)
            self.radio_btn_tab[2]:setIsVisible(true)
            self:change_page(1)
            -- self.jinjie_panel:pinjie_callback(false)

            local mounts_info = MountsModel:get_mounts_info()
            local soft_check_version = CCAppConfig:sharedAppConfig():getBoolForKey("is_check_version")
            -- print("soft_check_version",soft_check_version)
            -- print("type",type(soft_check_version))
            if mounts_info and mounts_info.level >= 45 and soft_check_version == false then
                self.radio_btn_tab[3]:setIsVisible(true);
            else
                self.radio_btn_tab[3]:setIsVisible(false);
            end
        end
    else
        MountsModel:set_show_other_mounts( false )
        if self.jinjie_panel then
            self.jinjie_panel:active(false)
        end
    end
end

--切页
function MountsWinNew:change_page( page_index )
     --
    -- for k,v in pairs( self.but_name_t ) do
    --     v.change_to_no_selected()
    -- end
    -- -- 切换当前被选中的RadioButton文字贴图至选中
    -- self.but_name_t[page_index].change_to_selected()

    for i,v in ipairs(self.label_title) do
        v:setText(LH_COLOR[2]..self.text_title[i])
    end
    self.label_title[page_index]:setText(LH_COLOR[15]..self.text_title[page_index])

	self:Choose_panel( _index_to_category_name[page_index] )
    self.raido_btn_group:selectItem(page_index-1)
end


-- 创建一个按钮:参数： 要加入的panel， 坐标和长宽，按钮两种状态背景图，显示文字图片，文字图片的长宽，序列号（用于触发事件判断调用的方法）
function MountsWinNew:create_a_button(panel, pos_x, pos_y, size_w, size_h, image_n, image_s ,but_name,but_name_s,index)
     local radio_button = CCRadioButton:radioButtonWithFile(pos_x, pos_y, size_w, size_h, image_n)
    radio_button:addTexWithFile(CLICK_STATE_DOWN,image_s)
    local function but_1_fun(eventType,x,y)
        if eventType == TOUCH_BEGAN then 
            --根据序列号来调用方法
            
            --print(but_index)
            return true
        elseif eventType == TOUCH_CLICK then
            -- 如果是查看其他人坐骑，则不允许刷新页面
            if MountsModel:is_show_other_mounts() == false then
                self:change_page( index )
            end
            return true;
        elseif eventType == TOUCH_ENDED then
            return true;
        end
    end
    radio_button:registerScriptHandler(but_1_fun)
    panel:addGroup(radio_button)

    --按钮显示的名称
    -- local word_x_temp = word_x+20 or 17
    -- local word_y_temp = word_y + 25 or 29 + 10+40
    -- print("  ::: ", word_x_temp, word_y_temp)
    -- local name_image = CCZXImage:imageWithFile( word_x_temp, word_y_temp, but_name_siz_w, but_name_siz_h, but_name ); 
    -- radio_button:addChild( name_image )
    -- self.but_name_t[index] = MountsWinNew:create_but_name( but_name, but_name_s, size_w/2, size_h/2 )
    -- radio_button:addChild(self.but_name_t[index].view)
    self.label_title[index] = MUtils:create_zxfont(radio_button,LH_COLOR[2]..self.text_title[index],size_w/2,12,2,17);
    return radio_button;
end

-- 销毁窗体
function MountsWinNew:destroy()
    if self.jinjie_panel then
        self.jinjie_panel:destroy();
    end

    -- if self.huaxing_panel then
    --     self.huaxing_panel:destroy();
    -- end

    if self.xilian_panel then
        self.xilian_panel:destroy();
    end

    -- if self.lingxi_panel then
    --     self.lingxi_panel:destroy();
    -- end

    if self.info_panel then
        self.info_panel:destroy();
    end

    Window.destroy(self)
end

-- 获取子页面
function MountsWinNew:getPage( panel_type )
    if panel_type == "jinjie" then
        return self.jinjie_panel;
    -- elseif panel_type == "huaxing" then
    --     return self.huaxing_panel;
    elseif panel_type == "xilian" then 
        return self.xilian_panel;
    -- elseif panel_type == "lingxi" then  
    --     return self.lingxi_panel;
    elseif panel_type == "info" then
        return self.info_panel
    end
end

-- 切换坐骑上下状态，有3个子页面有设置坐骑状态的按钮，所以在此处做一个同步切换
-- panel_type表示引起状态发生改变的原始页面，即当前是在哪个页面点击了骑休按钮
-- function MountsWinNew:changeQiXiuState( panel_type, b )
--     if panel_type == "jinjie" then
--         self.lingxi_panel:setMountsStatus(b);
--     elseif panel_type == "huaxing" then
--         self.jinjie_panel:setMountsStatus(b);
--         self.lingxi_panel:setMountsStatus(b);
--     elseif panel_type == "lingxi" then
--         self.jinjie_panel:setMountsStatus(b);
--     end
-- end

-- 显示他人坐骑信息
function MountsWinNew:show_other_mounts( other_mount_info )
    -- self.window_title:setTexture(UIResourcePath.FileLocate.mount .. "mounts_view.png")
    
    --他人坐骑信息的展示要隐藏掉不该显示的按钮
    -- self.raido_btn_group2:setIsVisible(true)
    -- self.raido_btn_group:setIsVisible(false)
    self.radio_btn_tab[2]:setIsVisible(false)
    self.radio_btn_tab[3]:setIsVisible(false)

    self:Choose_panel("info", other_mount_info)
end

-- 设置"坐骑灵犀"标签可见性
function MountsWinNew:update_lingxi_visible( is_visible )
    is_visible = is_visible or false;
    -- if self.radio_btn_tab[4] then
    --     self.radio_btn_tab[4]:setIsVisible( is_visible );
    -- end
end

-- 设置"坐骑洗练"标签可见性
function MountsWinNew:update_xilian_visible( is_visible )
    is_visible = is_visible or false;
    -- if self.radio_btn_tab[3] then
    --     self.radio_btn_tab[3]:setIsVisible( is_visible );
    -- end
end

function MountsWinNew:create_but_name( but_name_n, but_name_s, name_x, name_y )
    -- 按钮名称贴图
    local button_name = {}

    local button_name_image = CCZXImage:imageWithFile( name_x, name_y, -1, -1, but_name_n )
    button_name_image:setAnchorPoint(0.5,0.5)
    button_name.view = button_name_image 
    -- 按钮被选中时,调用函数切换贴图至but_name_s
    button_name.change_to_selected = function ()
        button_name_image:setTexture( but_name_s )
    end

    -- 按钮由被选中切换至未选中时,调用函数切换贴图至but_name_n
    button_name.change_to_no_selected = function ()
        button_name_image:setTexture( but_name_n )
    end

    return button_name
end

function MountsWinNew:change_mount_fight_value(fight_value)
    if self.current_page == "jinjie" then
        self.jinjie_panel:change_mount_fight_value(fight_value)
    elseif self.current_page == "lingxi" then
        self.lingxi_panel:change_mount_fight_value(fight_value)
    elseif self.current_page == "info" then
        self.info_panel:change_mount_fight_value(fight_value)
    end
end

function MountsWinNew:clear_cd_callback()
    self.info_panel:clear_cd_callback()
end

function MountsWinNew:up_level_callback(mounts_model)
    local soft_check_version = CCAppConfig:sharedAppConfig():getBoolForKey("is_check_version")
    if mounts_model and mounts_model.level >= 45 and soft_check_version == false then
        self.radio_btn_tab[3]:setIsVisible(true);
    else
        self.radio_btn_tab[3]:setIsVisible(false);
    end
    
    self.info_panel:up_level_callback(mounts_model)   
end