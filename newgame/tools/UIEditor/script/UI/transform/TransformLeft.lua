-- TransformLeft.lua
-- created by yongrui.liang on 2014-7-22
-- 变身系统左页

super_class.TransformLeft(Window)


-- 先写窗口的初始化方法
function TransformLeft:__init( window_name, texture_name )
    -- 主要是创建控件
    local bg = ZBasePanel.new(nil, 340, 515+50)
    bg:setPosition(81, 70-50)
    self:addChild(bg)
    self.pageBg = bg

    -- 这里还可以对一些窗口类的成员变量初始化

    -- 创建分页button
    self.radio_btn_group = CCRadioButtonGroup:buttonGroupWithFile( 28, 210, 58, 360, "" )
    self:addChild(self.radio_btn_group)

    -- 图鉴
    self.normal_level_button = CCRadioButton:radioButtonWithFile(0, 240, -1, -1, 
        UIResourcePath.FileLocate.common .. "xxk-1.png")
    self.normal_level_button:addTexWithFile( CLICK_STATE_DOWN,
        UIResourcePath.FileLocate.common .. "xxk-2.png")

    local normal_text = CCZXImage:imageWithFile( 22, 22, -1, -1, "ui/transform/new3.png" )
    self.normal_level_button:addChild(normal_text)
    self.radio_btn_group:addGroup(self.normal_level_button)
    local function but_1_fun(eventType,x,y)
        if eventType ==  TOUCH_BEGAN then 
            return true
        elseif eventType == TOUCH_CLICK then
            TransformModel:set_current_left_page( TransformModel.TU_JIAN )
            self:change_page( TransformModel.TU_JIAN )
            return true;
        elseif eventType == TOUCH_ENDED then
            return true;
        end
    end
    self.normal_level_button:registerScriptHandler(but_1_fun)

    -- 奥义
    self.high_level_button = CCRadioButton:radioButtonWithFile(0, 120, -1, -1, UIResourcePath.FileLocate.common .. "xxk-1.png")
    self.high_level_button:addTexWithFile( CLICK_STATE_DOWN,
        UIResourcePath.FileLocate.common .. "xxk-2.png")

    local high_text = CCZXImage:imageWithFile( 22, 22, -1, -1, "ui/transform/new5.png" )
    self.high_level_button:addChild(high_text)
    self.radio_btn_group:addGroup(self.high_level_button)
    local function but_2_fun(eventType,x,y)
        if eventType ==  TOUCH_BEGAN then 
            --根据序列号来调用方法
            return true
        elseif eventType == TOUCH_CLICK then
            TransformModel:set_current_left_page( TransformModel.AO_YI )
            self:change_page( TransformModel.AO_YI )
            return true;
        elseif eventType == TOUCH_ENDED then
            return true;
        end
    end
    self.high_level_button:registerScriptHandler(but_2_fun)

    -- 记录每页，控制显示与隐藏
    self.page_list = {}

end

--切页
function TransformLeft:change_page( page_index )
    if self.page_list[page_index] == self.current_page then
        return
    end

    for k,v in pairs(self.page_list) do
        v.view:setIsVisible(false)
    end

    if page_index == TransformModel.TU_JIAN then
        if self.page_list[page_index] then
            self.TransformTuJian.view:setIsVisible( true )
        else
            self.TransformTuJian = TransformTuJian()
            self.TransformTuJian.view:setPosition(0, 50)
            self.pageBg:addChild(self.TransformTuJian.view)
            self.page_list[page_index] = self.TransformTuJian
        end
        self.current_page = self.page_list[page_index]
        TransformModel:change_right_win( TransformModel.TU_JIAN )

    elseif page_index == TransformModel.AO_YI then
        if self.page_list[page_index] then
            self.TransformAoYi.view:setIsVisible( true )
        else
            self.TransformAoYi = TransformAoYi()
            self.TransformAoYi.view:setPosition(0, 0)
            self.pageBg:addChild(self.TransformAoYi.view)
            self.page_list[page_index] = self.TransformAoYi
        end
        self.current_page = self.page_list[page_index]
        TransformModel:change_right_win( TransformModel.AO_YI )
    end

    if self.current_page and self.current_page.update then
        self.current_page:update("all")
    end
end

function TransformLeft:update( update_type )
    if self.current_page and self.current_page.update then
        self.current_page:update(update_type)
    end
end

function TransformLeft:active( show )
    if not show then
        local win = UIManager:find_visible_window("transform_right")
        if win then
            UIManager:hide_window("transform_right")
        end
        TransformModel:init_page( )
    else
        TransformModel:init_page( )
        self.current_page = TransformModel.TU_JIAN
        self:change_page(TransformModel.TU_JIAN)
    end
end

function TransformLeft:destroy( )
    --self:active(false)
    -- TransformModel:init_page( )
    Window.destroy(self)
end
