-- MailWin.lua  
-- created by lyl on 2013-3-12
-- 邮件系统  mail_win

super_class.MailWin(NormalStyleWindow)

require "model/MailModel"
require "UI/mail/WriteMailPage"
require "UI/mail/ReadMailPage"
require "UI/mail/ConnectGM"

function MailWin:__init( window_name, texture_name )
	self.all_page_t = {}              -- 存储所有已经创建的页面
	self.current_panel = nil          -- 当前的面板。用于记录 界面。在切换的时候做操作

    local bgPanel = self.view

    -- 侧面所有按钮
    local but_beg_x = 20          -- 按钮起始x坐标
    local but_beg_y = 520         -- 按钮起始y坐标
    local but_int_x = 120         -- 按钮x坐标间隔
    local but_width = 101
    local but_height = 48

    -- self.but_name_t = {}
    self.label_table = {}
    self.label_text_table = {Lang.mail[1],Lang.mail[2],}    -- 收信，写信
    self.raido_btn_group_item = CCRadioButtonGroup:buttonGroupWithFile(but_beg_x ,but_beg_y , but_width*2, but_height,nil)
    self.view:addChild( self.raido_btn_group_item )

    self:create_a_button(self.raido_btn_group_item, 1+but_width*(1-1), 1, but_width, but_height, UILH_COMMON.tab_gray,
     UILH_COMMON.tab_light, 1)

    self:create_a_button(self.raido_btn_group_item, 1+but_width*(2-1), 1, but_width, but_height, UILH_COMMON.tab_gray,
     UILH_COMMON.tab_light, 2)
    -- self:create_a_button(self.raido_btn_group_item, 1, 1 + but_int_y * (1 - 1), 47, 95, "ui/common/xxk-1.png", "ui/common/xxk-2.png", "ui/common/lianxiguanli.png", 17, 18, 23, 70, 3)
    self:change_page( 1 )
    -- self.but_name_t[1].change_to_selected()
    self.label_table[1]:setText(LH_COLOR[15]..self.label_text_table[1])
end

-- 标签选项
function MailWin:create_a_button( panel, pos_x, pos_y, size_w, size_h, image_n, image_s , index )
    local radio_button = CCRadioButton:radioButtonWithFile(pos_x, pos_y, size_w, size_h, image_n)
    radio_button:addTexWithFile(CLICK_STATE_DOWN,image_s)

    -- self.but_name_t[index] = MailWin:create_but_name( but_name_n, but_name_s, but_name_x, but_name_y )
    -- radio_button:addChild(self.but_name_t[index].view)
    self.label_table[index] = MUtils:create_zxfont(radio_button,LH_COLOR[2]..self.label_text_table[index],size_w/2,14,2,16);

    local function radio_button_callback(eventType,x,y)
        if eventType == TOUCH_BEGAN  then 
            -- 根据序列号来调用方法
            
            return true
        elseif eventType == TOUCH_CLICK then
            self:change_page( index )
            -- 
            -- for k,v in pairs( self.but_name_t ) do
            --     v.change_to_no_selected()
            -- end
            -- -- 切换当前被选中的RadioButton文字贴图至选中
            -- self.but_name_t[index].change_to_selected()
            -- 改变标题文字颜色
            for k = 1,#self.label_table do
                if k == index then
                    self.label_table[k]:setText(LH_COLOR[15]..self.label_text_table[k])
                else
                    self.label_table[k]:setText(LH_COLOR[2]..self.label_text_table[k])
                end
            end
            return true;
        elseif eventType == TOUCH_ENDED then
            return true;
        end
    end
    radio_button:registerScriptHandler(radio_button_callback)
    panel:addGroup(radio_button)

end

--切换功能窗口:  
function MailWin:change_page( but_index )
    self.raido_btn_group_item:selectItem( but_index - 1)
    
     -- 把当前显示的页隐藏
    if self.current_panel then
        self.current_panel.view:setIsVisible(false)
    end

    if but_index == 1 then
        if self.all_page_t[1] == nil then 
            self.all_page_t[1] =  ReadMailPage:create()
            self.all_page_t[1]:setPosition(8,5)
            self.view:addChild( self.all_page_t[1].view )
        end
        self.current_panel = self.all_page_t[1]
    elseif  but_index == 2 then
        if self.all_page_t[2] == nil then
            self.all_page_t[2] =  WriteMailPage:create(  )
            self.all_page_t[2]:setPosition(8,5)
            self.view:addChild( self.all_page_t[2].view )
        end
        self.current_panel = self.all_page_t[2]
    elseif  but_index == 3 then
        if self.all_page_t[3] == nil then
            self.all_page_t[3] =  ConnectGM:create()
            self.view:addChild( self.all_page_t[3].view )
        end
        self.current_panel = self.all_page_t[3]
    
    end
    if self.current_panel and self.current_panel.update then
        self.current_panel:update( "all" )
    end
    self.current_panel.view:setIsVisible(true)
end

-- 提供外部静态调用的更新窗口方法
function MailWin:update_win( update_type )
    require "UI/UIManager"
    local win = UIManager:find_visible_window("mail_win")
    if win then
        -- 把数据交给背包窗口显示
        win:update( update_type );   
    end
end

-- 更新数据
function MailWin:update( update_type )
    if update_type == "" then

    else
        self.current_panel:update( update_type )
    end
end

function MailWin:active( show )
    self.current_panel:update("all")
    if show == true then
        if MailModel:get_is_fini() then
            MailModel:reset_info()
        end
        if self.all_page_t[2] ~= nil then
            self.all_page_t[2]:clear_all()
        end
    else
        UIManager:hide_window( "mail_content_win" )
        -- 关闭左键弹出框
        AlertWin:close_alert(  ) 
    end
end

function MailWin:destroy()  
    for key, page in pairs(self.all_page_t) do
        page:destroy()
    end
    Window.destroy(self)
end

-- function MailWin:create_but_name( but_name_n, but_name_s, name_x, name_y )
--     -- 按钮名称贴图
--     local button_name = {}

--     local button_name_image = CCZXImage:imageWithFile( name_x, name_y, -1, -1, but_name_n )
    
--     button_name.view = button_name_image 
--     -- 按钮被选中时,调用函数切换贴图至but_name_s
--     button_name.change_to_selected = function ()
--         button_name_image:setTexture( but_name_s )
--     end

--     -- 按钮由被选中切换至未选中时,调用函数切换贴图至but_name_n
--     button_name.change_to_no_selected = function ()
--         button_name_image:setTexture( but_name_n )
--     end

--     return button_name
-- end



