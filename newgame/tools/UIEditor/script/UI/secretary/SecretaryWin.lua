-- SecretaryWin.lua  
-- created by lyl on 2013-5-28
-- 小秘书主窗口  secretary_Win


super_class.SecretaryWin(NormalStyleWindow)


function SecretaryWin:__init( window_name, texture_name )
    self.all_page_t = {}              -- 存储所有已经创建的页面
	self.current_panel = nil          -- 当前的面板。用于记录 界面。在切换的时候做操作
    -- self.btn_name_t ={}
	local bgPanel = self.view

    -- local bgPanel_2 = CCZXImage:imageWithFile( 280, 388, -1, -1, UIResourcePath.FileLocate.common .. "win_title1.png");  --头部
    -- bgPanel:addChild( bgPanel_2 )
    -- local bgPanel_3 = CCZXImage:imageWithFile( 344 - 10, 400, -1, -1, UIResourcePath.FileLocate.secretary .. "youxizhushou.png");        --标题名称
    -- bgPanel:addChild( bgPanel_3 )
    -- local bgPanel_4 = CCZXImage:imageWithFile( 550, 15, -1, -1, UIPIC_Secretary_001);        --美女
    -- bgPanel:addChild( bgPanel_4, 999 )       -- 必须比页的层级高

    local but_beg_x = 40          --按钮起始x坐标
    local but_beg_y = 520       --按钮起始y坐标
    local but_int_x = 101        --按钮y坐标间隔
    -- 顶部所有按钮
    -- local but_beg_x = 24          --按钮起始x坐标
    -- local but_beg_y = 348 + 8     --按钮起始y坐标
    -- local but_int_x = 90          --按钮x坐标间隔

    self.radio_buts = CCRadioButtonGroup:buttonGroupWithFile(but_beg_x ,but_beg_y , but_int_x * 4,42,nil)
    bgPanel:addChild( self.radio_buts )
    self:create_a_button(self.radio_buts, 1 + but_int_x * (1 - 1), 1, -1, -1, UILH_COMMON.tab_gray, UILH_COMMON.tab_light, Lang.secretary[1], 1)
    
    -- self:create_a_button(self.radio_buts, 1 + but_int_x * (2 - 1), 1, but_int_width, but_int_hight, UIPIC_Secretary_002,UIPIC_Secretary_003,UIPIC_Secretary_015,7, 8, 2)
    -- self:create_a_button(self.radio_buts, 1 + but_int_x * (3 - 1), 1, but_int_width, but_int_hight, UIPIC_Secretary_002,UIPIC_Secretary_003,UIPIC_Secretary_017,7, 8, 3)
    self:create_a_button(self.radio_buts, 1 + but_int_x * (2 - 1), 1, -1, -1, UILH_COMMON.tab_gray, UILH_COMMON.tab_light, Lang.secretary[2], 2)
    -- self:create_a_button(self.radio_buts, 1 + but_int_x * (3 - 1), 1, 94, 37, UIResourcePath.FileLocate.common .. "common_tab_n.png",
    --  UIResourcePath.FileLocate.common .. "common_tab_s.png", UIResourcePath.FileLocate.secretary .. "kefuxinxi.png",7, 8, 3)
    -- self.btn_name_t[1].change_to_selected()
    self:change_page( 1 )

    -- -- 关闭按钮
    -- local function close_but_CB( )
    --     UIManager:destroy_window( "secretary_Win" )
    -- end
    -- local close_but = UIButton:create_button_with_name( 340 + 389 -18, 377, -1, -1, UIResourcePath.FileLocate.common .. "close_btn_n.png", UIResourcePath.FileLocate.common .. "close_btn_s.png", nil, "", close_but_CB )
    -- local exit_btn_size = close_but:getSize()
    -- local spr_bg_size = bgPanel:getSize()
    -- close_but:setPosition( spr_bg_size.width - exit_btn_size.width, spr_bg_size.height - exit_btn_size.height )
    -- bgPanel:addChild( close_but )

end

-- 创建一个按钮:参数： 要加入的panel， 坐标和长宽，按钮两种状态背景图，显示文字图片，文字图片的长宽，序列号（用于触发事件判断调用的方法）
function SecretaryWin:create_a_button( panel, pos_x, pos_y, size_w, size_h, image_n, image_s ,but_name, index )
    local radio_button = CCRadioButton:radioButtonWithFile(pos_x, pos_y, size_w, size_h, image_n)
    radio_button:addTexWithFile(CLICK_STATE_DOWN,image_s)
    local lab = ZLabel:create(radio_button, but_name, 51, 12, 16, 2)
	local function but_1_fun(eventType,x,y)
        if eventType == TOUCH_BEGAN then 
            --根据序列号来调用方法
            return true
        elseif eventType == TOUCH_CLICK then
                    --将其他标签全部更改文字贴图
            -- for k,v in pairs(self.btn_name_t) do
            --    v.change_to_no_selected()
            -- end
            -- self.btn_name_t[but_index].change_to_selected()
            self:change_page( index )
            return true;
        elseif eventType == TOUCH_ENDED then
            return true;
        end
	end
    radio_button:registerScriptHandler(but_1_fun)    --注册
    panel:addGroup(radio_button)

    --获取按钮的宽高
    -- local t_radioSize = radio_button:getSize()
    -- local t_width = t_radioSize.width
    -- local t_height = t_radioSize.height
    --按钮显示的名称
    --local name_image = CCZXImage:imageWithFile( t_width/2, t_height/2, -1, -1, but_name );
  --  name_image:setAnchorPoint(0.5,0.5)
      -- self.btn_name_t[but_index] = SecretaryWin:create_btn_name(but_name,but_name_s,110/2,60/2,-1,-1)

    -- radio_button:addChild( self.btn_name_t[but_index].view )
end

--xiehande
-- function  SecretaryWin:create_btn_name( btn_name_n,btn_name_s,name_x,name_y,btn_name_size_w,btn_name_size_h )
--     -- 按钮名称贴图集合
--     local  button_name = {}
--     local  button_name_image = CCZXImage:imageWithFile(name_x,name_y,btn_name_size_w,btn_name_size_h,btn_name_n)
--     button_name_image:setAnchorPoint(0.5,0.5)
--     button_name.view = button_name_image
--     --按钮被选中，调用函数切换贴图至btn_name_s
--     button_name.change_to_selected = function ( )
--         button_name_image:setTexture(btn_name_s)
--     end

--     --按钮变为未选时  切换贴图到btn_name_n
--     button_name.change_to_no_selected = function ( )
--         button_name_image:setTexture(btn_name_n)
--     end

--     return button_name

-- end

--切换功能窗口:   
function SecretaryWin:change_page( but_index )
    -- 动态调整坐标    测试用**********
    -- reload("UI/secretary/secretary_win_config")
    -- if self.current_panel then
    --     self.current_panel.view:setIsVisible(false)
    -- end
    -- for key, page in pairs(self.all_page_t) do
    --     page:destroy()
    -- end 
    -- self.all_page_t = {}
    -- self.current_panel = nil


    -- ================================
     
    self.radio_buts:selectItem( but_index - 1)
     -- 把当前显示的页隐藏
    if self.current_panel then
        self.current_panel.view:setIsVisible(false)
    end
    --游戏秘书--
    if but_index == 1 then
        if self.all_page_t[1] == nil then
            self.all_page_t[1] =  SecretaryPage:create()
            self.view:addChild( self.all_page_t[1].view )
            self.all_page_t[1]:setPosition(15,10)
        end
        self.current_panel = self.all_page_t[1]
    --每日福利--
    -- elseif  but_index == 2 then
    --     if self.all_page_t[2] == nil then
    --         self.all_page_t[2] =  DailyWelfarePage:create()
    --         self.view:addChild( self.all_page_t[2].view )
    --         self.all_page_t[2]:setPosition(30,20)
    --     end
    --     self.current_panel = self.all_page_t[2]
    -- --活跃奖励--
    -- elseif  but_index == 3 then
    --     if self.all_page_t[3] == nil then
    --         self.all_page_t[3] =  ActivityAwardPage:create()
    --         self.view:addChild( self.all_page_t[3].view )
    --         self.all_page_t[3]:setPosition(30,20)
    --     end
    --     self.current_panel = self.all_page_t[3]
    --版本公告--
    elseif  but_index == 2 then
        if self.all_page_t[4] == nil then
            self.all_page_t[4] =  SecretaryNotice:create(  )
            self.view:addChild( self.all_page_t[4].view )
            self.all_page_t[4]:setPosition(15,10)
        end
        self.current_panel = self.all_page_t[4]
    -- elseif  but_index == 5 then
    --     if self.all_page_t[5] == nil then
    --         self.all_page_t[5] =  CustomServicePage:create(  )
    --         self.view:addChild( self.all_page_t[5].view )
    --         self.all_page_t[5]:setPosition(30,20)
    --     end
    --     self.current_panel = self.all_page_t[5]
    end

    if self.current_panel and self.current_panel.update then
        self.current_panel:update( "all" )
    end

    self.current_panel.view:setIsVisible(true)
end

-- 更新窗口。 静态调用
function SecretaryWin:update_win( update_type )
    local win = UIManager:find_visible_window("secretary_Win")
    if win then
        win:update( update_type )
    end
end

-- 更新数据
function SecretaryWin:update( update_type )
    if update_type == "all" then
        self.current_panel:update( update_type )
    else
        self.current_panel:update( update_type )
    end
end

function SecretaryWin:active( show )
    if show then
        self.current_panel:update( "all" )
    end
end

function SecretaryWin:destroy()
    Window.destroy(self)
    if self.all_page_t ~= nil and type(self.all_page_t) == "table" then
        for key, page in pairs(self.all_page_t) do
            page:destroy()
        end 
    end
end

-- 外部静态调用，切换页
function SecretaryWin:win_change_page( index )
    local win = UIManager:find_visible_window( "secretary_Win" )
    if win then
        win:change_page( index )
    end
end
