
-- GeniusWin.lua 
-- createed by mwy@2014-5-2
-- 新坐骑系统窗口
 
super_class.GeniusWin(Window)

-- 数字与 类型名称 的映射
local _index_to_category_name = { [1] = "jinjie",[2] = "lunhui",[3] = "jineng",[4] = "info",  [5] = "zhuangbei" ,[6]="huaxing",[7]="other"}

-- 初始化函数
function GeniusWin:__init( window_name, texture_name )
	self.but_name_t = {}      -- 每个按钮的名称有两种状态，存储该名称图片，改变图片
    self.raido_btn_t = {}     -- 保存raido_btn

	local bgPanel = self.view
    local _p_x =  42
    local _p_y =  20

    --第二层底图容器，为了省内存这里不需要加载纹理，切页地图已经加载了底图纹理
    local _tagview_panel = CCBasePanel:panelWithFile(_p_x, _p_y, 835, 386+102+46, UIPIC_GRID_nine_grid_bg3,500, 500);  
    bgPanel:addChild( _tagview_panel )

    -- 侧面所有按钮
    local but_beg_x = 60         --按钮起始x坐标
    local but_beg_y = 550         --按钮起始y坐标
    local but_int_x = 117         --按钮x坐标间隔
    local but_int_hight=-1        --按钮高度
    local but_int_wildth=-1      --按钮宽度

    self.raido_btn_group = CCRadioButtonGroup:buttonGroupWithFile(but_beg_x ,but_beg_y ,  but_int_x * 6,60,nil)
    bgPanel:addChild(self.raido_btn_group,99)

    --式神进阶
    self:create_a_button(self.raido_btn_group, 1 + but_int_x * (1 - 1), 1, but_int_wildth, but_int_hight, 
       UI_GeniusWin_001,
       UI_GeniusWin_002,
       UI_GeniusWin_005,
       UI_GeniusWin_006,  1)

    --式神轮回
    self:create_a_button(self.raido_btn_group, 1 + but_int_x * (2 - 1), 1, but_int_wildth, but_int_hight, 
        UI_GeniusWin_001,
        UI_GeniusWin_002, 
        UI_GeniusWin_009, 
        UI_GeniusWin_0010,  2)

    --式神技能
    self:create_a_button(self.raido_btn_group, 1 + but_int_x * (3 - 1), 1, but_int_wildth, but_int_hight, 
       UI_GeniusWin_001,
       UI_GeniusWin_002,
       UI_GeniusWin_007,
       UI_GeniusWin_008,  3)

    --式神信息
    self:create_a_button(self.raido_btn_group, 1 + but_int_x * (4 - 1), 1, but_int_wildth, but_int_hight, 
       UI_GeniusWin_001,
       UI_GeniusWin_002,
       UI_GeniusWin_003, 
       UI_GeniusWin_004, 4)
  
    --式神装备
    --[[]]
    self:create_a_button(self.raido_btn_group, 1 + but_int_x * (5 - 1), 1, but_int_wildth, but_int_hight,
         UI_GeniusWin_001,
         UI_GeniusWin_002, 
         UI_GeniusWin_003, --xiehande 改 UI_GeniusWin_0011
         UI_GeniusWin_004,  5) --xiehande  改 UI_GeniusWin_0012

    --式神化形
    self:create_a_button(self.raido_btn_group, 1 + but_int_x * (6 - 1), 1, but_int_wildth, but_int_hight,
         UI_GeniusWin_001,
         UI_GeniusWin_002, 
         UI_GeniusWin_0036, 
         UI_GeniusWin_0037,  6)

    -- 查看别人式神
    self.raido_btn_group2 = CCRadioButtonGroup:buttonGroupWithFile(but_beg_x, but_beg_y, but_int_x ,44, nil)
    bgPanel:addChild(self.raido_btn_group2)
    self.raido_btn_group2:setIsVisible(false)

    self:create_a_button(self.raido_btn_group2, 1+ but_int_x * (1 - 1), 1, but_int_wildth, but_int_hight, 
        UI_GeniusWin_001, 
        UI_GeniusWin_002, 
        'ui/geniues/title_arrt.png',
        'ui/geniues/title_arrt.png', 7)

    -- 记录每个列表，控制显示与隐藏
    self.list_scroll_t = {}        

    -- 成长页
    self.info_panel =GeniusInfoPage()
    _tagview_panel:addChild( self.info_panel.view )
    table.insert( self.list_scroll_t, self.info_panel )

    -- 进阶页
    self.jinjie_panel =GeniusJinJiePage()
    _tagview_panel:addChild( self.jinjie_panel.view )
    table.insert( self.list_scroll_t, self.jinjie_panel )

    -- --技能页
    self.jineng_panel = GeniusJiNengPage()
    _tagview_panel:addChild( self.jineng_panel.view )
    table.insert( self.list_scroll_t, self.jineng_panel )

    -- --轮回页
    self.lunhui_panel = GeniusLunHuiPage()
    _tagview_panel:addChild( self.lunhui_panel.view )
    table.insert( self.list_scroll_t, self.lunhui_panel )

    -- --八门遁甲页
    self.zhuangbei_panel = GeniusZhuangBeiPage()
    _tagview_panel:addChild( self.zhuangbei_panel.view )
    table.insert( self.list_scroll_t, self.zhuangbei_panel )

    -- --化形页
    self.huanxing_panel = GeniusHuaXingPage()
    _tagview_panel:addChild( self.huanxing_panel.view )
    table.insert( self.list_scroll_t, self.huanxing_panel )

    -- --查看页
    self.other_panel=OtherGeniusInfoPage()
    _tagview_panel:addChild(self.other_panel.view)
    table.insert(self.list_scroll_t,self.other_panel)

    self.current_page = nil
    self.current_panel = nil
    -- 初始化进入进阶页面
    self:Choose_panel( "jinjie" )
end

-- 选择显示的面板   equipment,  material 
function GeniusWin:Choose_panel( panel_type,info)
    for key, scroll_view in pairs(self.list_scroll_t) do
        scroll_view.view:setIsVisible( false )
    end

    if panel_type == "info" then
        self.info_panel.view:setIsVisible( true )
        self.info_panel:update(  ) 
        self.current_panel = self.info_panel
    elseif panel_type == "jinjie" then
        self.jinjie_panel.view:setIsVisible( true )
        self.jinjie_panel:update(  ) 
        self.current_panel = self.jinjie_panel
    elseif panel_type == "jineng" then 
        self.jineng_panel.view:setIsVisible( true )
        self.jineng_panel:update(  ) 
        self.current_panel = self.jineng_panel
    elseif panel_type == "lunhui" then 
        self.lunhui_panel.view:setIsVisible( true )   
        self.lunhui_panel:update(  ) 
        self.current_panel = self.lunhui_panel
    elseif panel_type == "zhuangbei" then 
        self.zhuangbei_panel.view:setIsVisible( true )  
        self.zhuangbei_panel:update(  )  
        self.current_panel = self.zhuangbei_panel
    elseif panel_type == "huaxing" then 
        self.huanxing_panel.view:setIsVisible( true ) 
        self.huanxing_panel:update(  )  
        self.current_panel = self.huanxing_panel
    elseif panel_type == "other" then
        self.other_panel.view:setIsVisible(true)
        self.current_page = "other"
        self.other_panel:update(info)
        self.current_panel = self.other_panel
    end
end

-- 激活时更新数据
function GeniusWin:active( show )
    if show then
        if not SpriteModel:is_show_other_sprite() then
            -- self.window_title:setTexture(UI_GeniusWin_0033) --式神
            self.raido_btn_group2:setIsVisible(false)
            self.raido_btn_group:setIsVisible(true)

            local but_int_x = 117         --按钮x坐标间隔
            local player_level = EntityManager:get_player_avatar().level
            if player_level<43 then
                self.raido_btn_t[4]:setIsVisible(false)
                self.raido_btn_t[5]:setIsVisible(false)  
                self.raido_btn_t[6]:setPosition(1 + but_int_x * (4 - 1),1)
            else
                self.raido_btn_t[4]:setIsVisible(true)
                self.raido_btn_t[5]:setIsVisible(true)  
                self.raido_btn_t[6]:setPosition(1 + but_int_x * (6 - 1),1) 
            end 
            self:Choose_panel("jinjie")
            self.current_panel:active()
        end
    else
        SpriteModel:set_show_other_sprite(false)
    end
end

--切页
function GeniusWin:change_page( page_index )
	self:Choose_panel( _index_to_category_name[page_index] )
    self.raido_btn_group:selectItem(page_index-1)
end

-- 创建按钮的名称（需要控制两种状态）
function GeniusWin:create_but_name( but_name_n, but_name_s )
    local but_name = {}
	local but_name_bg = CCZXImage:imageWithFile(  14-2, 8+5+6, -1, -1, but_name_n )

    but_name.view = but_name_bg
    
    but_name.change_to_selected = function (  )
        but_name_bg:setTexture( but_name_s )
    end
    but_name.change_to_no_selected = function (  )
        but_name_bg:setTexture( but_name_n )
    end

    return but_name
end



-- 创建一个按钮:参数： 要加入的panel， 坐标和长宽，按钮两种状态背景图，显示文字图片，文字图片的长宽，序列号（用于触发事件判断调用的方法）
function GeniusWin:create_a_button(panel, pos_x, pos_y, size_w, size_h, image_n, image_s, but_name_n, but_name_s, but_index)
    local radio_button = CCRadioButton:radioButtonWithFile(pos_x, pos_y, size_w, size_h, image_n)

    radio_button:addTexWithFile(CLICK_STATE_DOWN,image_s)

    --按钮显示的名称
    -- print("GeniusWin:create_a_button(but_index)",but_index)
    self.but_name_t[but_index] = GeniusWin:create_but_name( but_name_n, but_name_s )

    radio_button:addChild( self.but_name_t[but_index].view)

	local function but_1_fun(eventType,x,y)
        if eventType ==  TOUCH_BEGAN then 
            return true
        elseif eventType == TOUCH_CLICK then
            -- Instruction:handleUIComponentClick(instruct_comps.GENIUS_WIN_PAGE_BASE + but_index)
            self:change_page( but_index )
            return true;
        elseif eventType == TOUCH_ENDED then
            return true;
        end
	end
    radio_button:registerScriptHandler(but_1_fun)    --注册
    panel:addGroup(radio_button)

    self.raido_btn_t[but_index] = radio_button
end

-- 播放暴击特效
-- effect_type 1,初级晶石暴击 2,中级晶石暴击 3,高级晶石暴击
function GeniusWin:play_cri_animation( effect_type )
     LuaEffectManager:play_view_effect( 10015,260,240,self.view,false,5 );
end


-- 销毁窗体
function GeniusWin:destroy()
    -- if self.info_panel then
    --     self.info_panel:destroy()
    -- end

    -- if self.jinjie_panel then
    --     self.jinjie_panel:destroy();
    -- end

    -- if self.jineng_panel then
    --     self.jineng_panel:destroy()
    -- end

    -- if self.lunhui_panel then
    --     self.lunhui_panel:destroy()
    -- end

    -- if self.zhuangbei_panel then
    --     self.zhuangbei_panel:destroy()
    -- end

    -- if self.huaxing_panel then
    --     self.huaxing_panel:destroy();
    -- end

    -- if self.other_panel then
    --     self.other_panel:destroy();
    -- end
    Window.destroy(self)
end

-- 显示他人式神信息
function GeniusWin:show_other_sprite( other_sprite_info )
    -- self.window_title:setTexture(UI_GeniusWin_0029)     --查看式神
    
    --他人式神信息的展示要隐藏掉不该显示的按钮
    self.raido_btn_group2:setIsVisible(true)
    self.raido_btn_group:setIsVisible(false)

    self:Choose_panel("other", other_sprite_info)
end

function GeniusWin:update( update_type, data )
    if update_type == "model" then
        self.current_panel:update_sprite_info(data)
    elseif update_type == "fight_value" then
        self.current_panel:update_sprite_info(data)
    end
end

--化形成功特效   xiehande 需要更改为4
function GeniusWin:play_huaxing_effect()
    -- body
    LuaEffectManager:play_view_effect(403,660,430,self.view,false,5 );
end

