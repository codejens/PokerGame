-- OtherMounts.lua 
-- createed by mwy@2014-5-2
-- 新坐骑系统窗口
 
super_class.OtherMounts(NormalStyleWindow)

-- 数字与 类型名称 的映射
local _index_to_category_name = { [1] = "info"}

-- 初始化函数
function OtherMounts:__init( window_name, texture_name )
	local bgPanel = self.view

    -- 侧面所有按钮
    local win_size = self.view:getSize();
    local but_beg_x  = 13            -- 按钮起始x坐标
    local but_beg_y  = win_size.height - 65 - 45            -- 按钮起始y坐标
    local but_int_x  = 107           -- 按钮x坐标间隔
    local btn_with   = 108 
    local btn_height = 45

    -- self.but_name_t = {}
    self.text_title = {Lang.mounts.common[10]}
    self.label_title = {}
    self.radio_btn_tab   = {}
    self.raido_btn_group = CCRadioButtonGroup:buttonGroupWithFile(but_beg_x ,but_beg_y , btn_with*5, btn_height,nil)
    bgPanel:addChild(self.raido_btn_group,100)
    
    -- 坐骑信息按钮
    self.radio_btn_tab[1] = self:create_a_button(self.raido_btn_group, 0 + but_int_x*0, 0, btn_with, btn_height, UILH_COMMON.tab_gray, UILH_COMMON.tab_light, UI_OtherMounts_014,UI_OtherMounts_044,1)
     -- 记录每个列表，控制显示与隐藏
    self.list_scroll_t = {}   

    -- 坐骑信息页
    self.info_panel = OtherMountsInfoNew()
    self.view:addChild(self.info_panel.view)
    table.insert(self.list_scroll_t, self.info_panel)     

    self.current_page = nil

    self:change_page(1)
end


-- 选择显示的面板   equipment,  material 
function OtherMounts:Choose_panel( panel_type, info )
    -- for key, scroll_view in pairs(self.list_scroll_t) do
    --     scroll_view.view:setIsVisible( false )
    -- end
    if panel_type == "info" then
        self.info_panel.view:setIsVisible(true)
        self.current_page = "info"
        self.info_panel:active(true, info)
    end
end

-- 激活时更新数据
function OtherMounts:active( show)
    if show then
       self:change_page(1)
    end
end

--切页
function OtherMounts:change_page( page_index )
    for i,v in ipairs(self.label_title) do
        v:setText(LH_COLOR[2]..self.text_title[i])
    end
    self.label_title[page_index]:setText(LH_COLOR[15]..self.text_title[page_index])

	self:Choose_panel( _index_to_category_name[page_index] )
    self.raido_btn_group:selectItem(page_index-1)
end


-- 创建一个按钮:参数： 要加入的panel， 坐标和长宽，按钮两种状态背景图，显示文字图片，文字图片的长宽，序列号（用于触发事件判断调用的方法）
function OtherMounts:create_a_button(panel, pos_x, pos_y, size_w, size_h, image_n, image_s ,but_name,but_name_s,index)
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

    self.label_title[index] = MUtils:create_zxfont(radio_button,LH_COLOR[2]..self.text_title[index],size_w/2,14,2,17);
    return radio_button;
end

-- 销毁窗体
function OtherMounts:destroy()

    if self.info_panel then
        self.info_panel:destroy();
    end
    Window.destroy(self)
end

-- 获取子页面
function OtherMounts:getPage( panel_type )
    if panel_type == "info" then
        return self.info_panel
    end
end

-- 显示他人坐骑信息
function OtherMounts:show_other_mounts( other_mount_info )
    self:Choose_panel("info", other_mount_info)
end

function OtherMounts:change_mount_fight_value(fight_value)
    if self.current_page == "info" then
        self.info_panel:change_mount_fight_value(fight_value)
    end
end

function OtherMounts:clear_cd_callback()
    self.info_panel:clear_cd_callback()
end
