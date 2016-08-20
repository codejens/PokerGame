-- SetSystemWin.lua  
-- created by lyl on 2013-3-15
-- 设置系统  set_system_win

super_class.SetSystemWin(NormalStyleWindow)



function SetSystemWin:__init( window_name, window_info)-- texture_name )
	self.current_panel = nil          -- 当前的面板。用于记录 界面。在切换的时候做操作
	self.all_page_t = {}              -- 存储所有已经创建的页面

    local bgPanel = self.view
    -- self.but_name_t = {}
    --列表底色
--    local bg =  CCZXImage:imageWithFile( 30, 20, 857, 495, UI_SetSystemWin_001,500,500)
--    bgPanel:addChild(bg)

    -- local bgPanel_2 = CCZXImage:imageWithFile( 280 - 5, 388, -1, -1, UIResourcePath.FileLocate.common .. "win_title1.png");  --头部
    -- bgPanel:addChild( bgPanel_2 )
    -- local bgPanel_3 = CCZXImage:imageWithFile( 370 - 40, 398, -1, -1, UIResourcePath.FileLocate.systemSet .. "shezhi.png");        --标题名称
    -- bgPanel:addChild( bgPanel_3 )

    -- 顶部所有按钮([1] = "系统设置",[2] = "消息提示",[3] = "挂机设置",)
    self.text_title = {Lang.set_system_info.sub_title[1],Lang.set_system_info.sub_title[2],Lang.set_system_info.sub_title[3]}
    self.label_title = {}
    local win_size = self.view:getSize();
    local but_beg_x = 10          --按钮起始x坐标
    local but_beg_y = win_size.height - 105         --按钮起始y坐标
    local but_int_x = 107          --按钮x坐标间隔
    local but_int_hight = 45        --按钮高度
    local but_int_wildth = 108       --按钮宽度
    self.raido_btn_group = CCRadioButtonGroup:buttonGroupWithFile(but_beg_x ,but_beg_y , but_int_x * 3,44,nil)
    bgPanel:addChild( self.raido_btn_group )

    self:create_a_button(self.raido_btn_group, 1 + but_int_x * (1 - 1), 1, but_int_wildth, but_int_hight, UILH_COMMON.tab_gray, UILH_COMMON.tab_light, 1)

    self:create_a_button(self.raido_btn_group, 1 + but_int_x * (2 - 1), 1, but_int_wildth, but_int_hight, UILH_COMMON.tab_gray, UILH_COMMON.tab_light, 2)

    self:create_a_button(self.raido_btn_group, 1 + but_int_x * (3 - 1), 1, but_int_wildth, but_int_hight, UILH_COMMON.tab_gray, UILH_COMMON.tab_light, 3)
    
    self:change_page( 1 )
    -- self.but_name_t[1].change_to_selected()
---------------------------------------------------------------------------------------------------------


    
    -- 关闭按钮
    -- local function close_but_CB( )
	   --  require "UI/UIManager"
    --     UIManager:hide_window( "set_system_win" )
    -- end
    -- local close_but = UIButton:create_button_with_name( 340 + 389 -18, 377, -1, -1, UIResourcePath.FileLocate.common .. "close_btn_n.png", UIResourcePath.FileLocate.common .. "close_btn_s.png", nil, "", close_but_CB )
    -- local exit_btn_size = close_but:getSize()
    -- local spr_bg_size = bgPanel:getSize()
    -- close_but:setPosition( spr_bg_size.width - exit_btn_size.width, spr_bg_size.height - exit_btn_size.height )
    -- bgPanel:addChild( close_but )

    
end

-- 创建一个按钮:参数： 要加入的panel， 坐标和长宽，按钮两种状态背景图，显示文字图片，文字图片的长宽，序列号（用于触发事件判断调用的方法）
function SetSystemWin:create_a_button(panel, pos_x, pos_y, size_w, size_h, image_n, image_s, but_index)
    local radio_button = CCRadioButton:radioButtonWithFile(pos_x, pos_y, size_w, size_h, image_n)
    radio_button:addTexWithFile(CLICK_STATE_DOWN,image_s)
    --按钮显示的名称
    self.label_title[but_index] = MUtils:create_zxfont(radio_button,LH_COLOR[2]..self.text_title[but_index],size_w/2,12,2,17);
    -- self.but_name_t[but_index] = SetSystemWin:create_but_name( but_name_n, but_name_s )
    -- radio_button:addChild( self.but_name_t[but_index].view)
    local function but_1_fun(eventType,x,y)
        if eventType ==  TOUCH_BEGAN then 

            return true
        elseif eventType == TOUCH_CLICK then
            --根据序列号来调用方法
            self:change_page( but_index )
            -- for k,v in pairs( self.but_name_t ) do
            --     v.change_to_no_selected()
            -- end
            -- -- 切换当前被选中的RadioButton文字贴图至选中
            -- self.but_name_t[but_index].change_to_selected()
            return true;
        elseif eventType == TOUCH_ENDED then
            return true;
        end
    end
    radio_button:registerScriptHandler(but_1_fun)    --注册
    panel:addGroup(radio_button)
end

-- function SetSystemWin:create_but_name( but_name_n, but_name_s )
--     local but_name = {}
--     local but_name_label = CCZXImage:imageWithFile( 108/2 - 86/2, 12, -1, -1, but_name_n )
--     but_name.view = but_name_label

--     but_name.change_to_selected = function (  )
--         but_name_label:setTexture( but_name_s )
--     end
--     but_name.change_to_no_selected = function (  )
--         but_name_label:setTexture( but_name_n )
--     end
--     return but_name
-- end

--切换功能窗口:   1:系统设置   2：消息设置  3:挂机设置
function SetSystemWin:change_page( but_index )
    -- 把当前显示的页隐藏
    if self.current_panel then
        self.current_panel.view:setIsVisible(false)
    end

    for i,v in ipairs(self.label_title) do
        v:setText(LH_COLOR[2]..self.text_title[i])
    end
    self.label_title[but_index]:setText(LH_COLOR[15]..self.text_title[but_index])

    if but_index == 1 then
        if self.all_page_t[1] == nil then 
            self.all_page_t[1] =  SetSystemPage:create()
            self.view:addChild( self.all_page_t[1].view )
            self.all_page_t[1]:setPosition(5,10)
        end
        self.current_panel = self.all_page_t[1]
    elseif  but_index == 2 then
        if self.all_page_t[2] == nil then
            self.all_page_t[2] =  SetInformationPage:create()
            self.view:addChild( self.all_page_t[2].view )
            self.all_page_t[2]:setPosition(5,10)
        end
        self.current_panel = self.all_page_t[2]
    elseif  but_index == 3 then
        if self.all_page_t[3] == nil then
            self.all_page_t[3] =  SetOnHookPage:create()
            self.view:addChild( self.all_page_t[3].view )
            self.all_page_t[3]:setPosition(5,10)
        end
        self.current_panel = self.all_page_t[3]
    end
    
    if self.current_panel and self.current_panel.update then
        self.current_panel:update( "all" )
    end
    self.current_panel.view:setIsVisible(true)
end



-- 提供外部静态调用的更新窗口方法
function SetSystemWin:update_win( update_type )
    require "UI/UIManager"
    local win = UIManager:find_window("set_system_win")
    if win then
        -- 把数据交给背包窗口显示
        win:update( update_type );   
    end
end

-- 更新数据
function SetSystemWin:update( update_type )
    if update_type == "set_date" then
        self.current_panel:update( "set_date" )
    else
        if self.current_panel.update then
            self.current_panel:update( update_type )
        end
    end
end

function SetSystemWin:active( active )
    -- SetSystemModel:request_set_date(  )  -- 测试
    if active then 
        self.current_panel:update("all")
    end
end

function SetSystemWin:destroy()
    Window.destroy(self)
    for key, page in pairs(self.all_page_t) do
        page:destroy()
    end
end