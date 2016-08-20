-- GuildFubenLeft.lua 
-- createed by liuguowang on 2014-3-25
-- 仙宗副本系统 左窗口
 
require "UI/guild/GuildFubenTab1"
require "UI/guild/GuildFubenTab2"

super_class.GuildFubenLeft(Window)

-- 初始化函数
function GuildFubenLeft:__init(  )
    self.all_page_t = {}              -- 存储所有已经创建的页面
    local bgPanel = self.view  
	    -- 侧面所有按钮
    -- self.but_t = {}               -- 存放所有按钮，设置按钮状态
    local but_beg_x = 2           --按钮起始x坐标
    local but_beg_y = 205         --按钮起始y坐标
    local but_int_y = 90          --按钮y坐标间隔

    self.raido_btn_group = CCRadioButtonGroup:buttonGroupWithFile(but_beg_x ,but_beg_y , 50, but_int_y * 3,nil)
    bgPanel:addChild(self.raido_btn_group)
    self:create_a_button(self.raido_btn_group, 8, 1 + but_int_y * (2 - 1), -1, -1, UIResourcePath.FileLocate.common .. "xxk-1.png",
     UIResourcePath.FileLocate.common .. "xxk-2.png", UIResourcePath.FileLocate.guild .. "text_tab1.png",-1, -1, 1)
    -- self:create_a_button(self.raido_btn_group, 8, 1 + but_int_y * (1 - 1), -1, -1, UIResourcePath.FileLocate.common .. "xxk-1.png",
    --  UIResourcePath.FileLocate.common .. "xxk-2.png", UIResourcePath.FileLocate.guild .. "text_tab2.png",-1, -1, 2)

    self:change_page( 1 )

    local function btn_close_fun()
        UIManager:hide_window("guild_fuben_left");
        UIManager:hide_window("guild_fuben_right");
        return true
    end
    self.exit_btn:setTouchClickFun(btn_close_fun)
end


-- 创建一个按钮:参数： 要加入的panel， 坐标和长宽，按钮两种状态背景图，显示文字图片，文字图片的长宽，序列号（用于触发事件判断调用的方法）
function GuildFubenLeft:create_a_button(panel, pos_x, pos_y, size_w, size_h, image_n, image_s ,but_name, but_name_siz_w, but_name_siz_h, but_index)
    local radio_button = CCRadioButton:radioButtonWithFile(pos_x, pos_y, size_w, size_h, image_n)
    radio_button:addTexWithFile(CLICK_STATE_DOWN,image_s)
    local function but_1_fun(eventType,x,y)
        if eventType ==  TOUCH_BEGAN then 
            --根据序列号来调用方法
           
            return true
        elseif eventType == TOUCH_CLICK then
            self:change_page( but_index )
            return true;
        elseif eventType == TOUCH_ENDED then
            
            return true;
        end
    end
    radio_button:registerScriptHandler(but_1_fun)
    panel:addGroup(radio_button)

    --按钮显示的名称
    local name_image = CCZXImage:imageWithFile( 35/2, 83/2, but_name_siz_w, but_name_siz_h, but_name ); 
    name_image:setAnchorPoint(0.5,0.5)
    radio_button:addChild( name_image )

end

--切换功能窗口:   1: 福地之战   2 幽冥魔域
function GuildFubenLeft:change_page( but_index )
	print("but_index=",but_index)
    self.raido_btn_group:selectItem( but_index - 1)

    --先清除当前界面
    if self.current_panel then
        self.current_panel.view:setIsVisible(false)     -- 最终要使用这个来隐藏
    end
    if but_index == 1 then
        if self.all_page_t[1] == nil then
            self.all_page_t[1] = GuildFubenTab1( self.view )
        end
        self.current_panel = self.all_page_t[1]

    elseif  but_index == 2 then
        if self.all_page_t[2] == nil then
            self.all_page_t[2] = GuildFubenTab2( self.view )
        end
        self.current_panel = self.all_page_t[2]

    end
    self.current_panel.view:setIsVisible(true)
end
