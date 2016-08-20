-- TransformRight.lua
-- created by yongrui.liang on 2014-7-22
-- 变身系统右页

super_class.TransformRight(Window)

-- 先写窗口的初始化方法
function TransformRight:__init( window_name, texture_name )
    self.page_list = {}
	-- 主要是创建控件
    local bgPanel = ZBasePanel.new(nil, 393, 565)
    bgPanel:setPosition(0, 0)
    self.view:addChild(bgPanel.view)

    self.tujian_actived_page = ZBasePanel.new(nil, 393, 565).view
    self.tujian_actived_page:setPosition(31, 20)
    self.view:addChild(self.tujian_actived_page)

    self.tujian_inactived_page = ZBasePanel.new(nil, 393, 565).view
    self.tujian_inactived_page:setPosition(31, 20)
    self.view:addChild(self.tujian_inactived_page)

    self.aoyi_page = ZBasePanel.new(nil, 393, 565).view
    self.aoyi_page:setPosition(31, 20)
    self.view:addChild(self.aoyi_page)

    self.aoyi_inactived_page = ZBasePanel.new(nil, 393, 565).view
    self.aoyi_inactived_page:setPosition(31, 20)
    self.view:addChild(self.aoyi_inactived_page)

    self:create_actived_transform_panel( self.tujian_actived_page )
    self:create_inactive_transform_panel( self.tujian_inactived_page )
    self:create_aoyi_panel( self.aoyi_page )
    self:create_inactive_upgrade_panel( self.aoyi_inactived_page )

    self.current_page = TransformModel.TRANSFORM
    self:change_page(TransformModel.TRANSFORM)
end

--切页
function TransformRight:change_page( page_index )
    -- if self.current_page == self.page_list[page_index] then
    --     return
    -- end

    for k,v in pairs(self.page_list) do
        v.view:setIsVisible(false)
    end

    self.tujian_actived_page:setIsVisible(false)
    self.tujian_inactived_page:setIsVisible(false)
    self.aoyi_page:setIsVisible(false)
    self.aoyi_inactived_page:setIsVisible(false)

    if page_index == TransformModel.TRANSFORM then
        self.tujian_actived_page:setIsVisible(true)
        if self.page_list[page_index] then
            self.page_list[page_index].view:setIsVisible(true)
        else
            self.page_list[page_index] = TransformBtnPage()
            self.tujian_actived_page:addChild(self.page_list[page_index].view)
        end
        self.current_page = self.page_list[page_index]

    elseif page_index == TransformModel.TUJIAN_INACTIVE then
        self.tujian_inactived_page:setIsVisible(true)
        if self.page_list[page_index] then
            self.page_list[page_index].view:setIsVisible(true)
        else
            self.page_list[page_index] = TuJianInactivePage()
            self.tujian_inactived_page:addChild(self.page_list[page_index].view)
        end
        self.current_page = self.page_list[page_index]

    elseif page_index == TransformModel.DEVELOP then
        self.tujian_actived_page:setIsVisible(true)
        if self.page_list[page_index] then
            self.page_list[page_index].view:setIsVisible(true)
        else
            self.page_list[page_index] = DevelopBtnPage()
            self.tujian_actived_page:addChild(self.page_list[page_index].view)
        end
        self.current_page = self.page_list[page_index]

    elseif page_index == TransformModel.TUJIAN_ATTR then
        self.tujian_actived_page:setIsVisible(true)
        if self.page_list[page_index] then
            self.page_list[page_index].view:setIsVisible(true)
        else
            self.page_list[page_index] = TuJianAttrBtnPage()
            self.tujian_actived_page:addChild(self.page_list[page_index].view)
        end
        self.current_page = self.page_list[page_index]

    elseif page_index == TransformModel.AOYI_UPGRADE then
        self.aoyi_page:setIsVisible(true)
        if self.page_list[page_index] then
            self.page_list[page_index].view:setIsVisible(true)
        else
            self.page_list[page_index] = UpgradeBtnPage()
            self.aoyi_page:addChild(self.page_list[page_index].view)
        end
        self.current_page = self.page_list[page_index]

    elseif page_index == TransformModel.AOYI_INACTIVE then
        self.aoyi_inactived_page:setIsVisible(true)
        if self.page_list[page_index] then
            self.page_list[page_index].view:setIsVisible(true)
        else
            self.page_list[page_index] = AoYiInactivePage()
            self.aoyi_inactived_page:addChild(self.page_list[page_index].view)
        end
        self.current_page = self.page_list[page_index]

    elseif page_index == TransformModel.AOYI_ATTR then
        self.aoyi_page:setIsVisible(true)
        if self.page_list[page_index] then
            self.page_list[page_index].view:setIsVisible(true)
        else
            self.page_list[page_index] = AoYiAttrBtnPage()
            self.aoyi_page:addChild(self.page_list[page_index].view)
        end
        self.current_page = self.page_list[page_index]
    end

    if self.current_page and self.current_page.update then
        self.current_page:update("all")
    end
end

function TransformRight:create_actived_transform_panel( parent )
    -- 创建分页button
    self.tujian_radio_btn_group = CCRadioButtonGroup:buttonGroupWithFile( 335, 20, 58, 360, "" )
    parent:addChild(self.tujian_radio_btn_group)

    -- 变身按钮
    self.transform_button = CCRadioButton:radioButtonWithFile(0, 240, -1, -1, 
        UIResourcePath.FileLocate.common .. "xxk-1.png")
    self.transform_button:addTexWithFile( CLICK_STATE_DOWN,
        UIResourcePath.FileLocate.common .. "xxk-2.png")
    self.transform_button:setFlipX(true)

    local normal_text = CCZXImage:imageWithFile( 14, 20, -1, -1, "ui/transform/new8.png" )
    self.transform_button:addChild(normal_text)
    self.tujian_radio_btn_group:addGroup(self.transform_button)
    local function but_1_fun(eventType,x,y)
        if eventType ==  TOUCH_BEGAN then 
            return true
        elseif eventType == TOUCH_CLICK then
            Instruction:handleUIComponentClick(instruct_comps.ANY_BTN)
            TransformModel:set_current_tujian_page( TransformModel.TRANSFORM )
            self:change_page( TransformModel.TRANSFORM )
            return true;
        elseif eventType == TOUCH_ENDED then
            return true;
        end
    end
    self.transform_button:registerScriptHandler(but_1_fun)

    -- 培养按钮
    self.develop_button = CCRadioButton:radioButtonWithFile(0, 120, -1, -1, UIResourcePath.FileLocate.common .. "xxk-1.png")
    self.develop_button:addTexWithFile( CLICK_STATE_DOWN,
        UIResourcePath.FileLocate.common .. "xxk-2.png")
    self.develop_button:setFlipX(true)

    local high_text = CCZXImage:imageWithFile( 14, 20, -1, -1, "ui/transform/new10.png" )
    self.develop_button:addChild(high_text)
    self.tujian_radio_btn_group:addGroup(self.develop_button)
    local function but_2_fun(eventType,x,y)
        if eventType ==  TOUCH_BEGAN then 
            return true
        elseif eventType == TOUCH_CLICK then
            Instruction:handleUIComponentClick(instruct_comps.ANY_BTN)
            TransformModel:set_current_tujian_page( TransformModel.DEVELOP )
            self:change_page( TransformModel.DEVELOP )
            return true;
        elseif eventType == TOUCH_ENDED then
            return true;
        end
    end
    self.develop_button:registerScriptHandler(but_2_fun)

    -- 属性按钮
    self.tujian_attr_button = CCRadioButton:radioButtonWithFile(0, 0, -1, -1, UIResourcePath.FileLocate.common .. "xxk-1.png")
    self.tujian_attr_button:addTexWithFile( CLICK_STATE_DOWN,
        UIResourcePath.FileLocate.common .. "xxk-2.png")
    self.tujian_attr_button:setFlipX(true)

    local high_text = CCZXImage:imageWithFile( 14, 20, -1, -1, "ui/transform/new12.png" )
    self.tujian_attr_button:addChild(high_text)
    self.tujian_radio_btn_group:addGroup(self.tujian_attr_button)
    local function but_3_fun(eventType,x,y)
        if eventType ==  TOUCH_BEGAN then 
            return true
        elseif eventType == TOUCH_CLICK then
            Instruction:handleUIComponentClick(instruct_comps.ANY_BTN)
            TransformModel:set_current_tujian_page( TransformModel.TUJIAN_ATTR )
            self:change_page( TransformModel.TUJIAN_ATTR )
            return true;
        elseif eventType == TOUCH_ENDED then
            return true;
        end
    end
    self.tujian_attr_button:registerScriptHandler(but_3_fun)
end

function TransformRight:create_inactive_transform_panel( parent )
    local bgPanel = ZBasePanel.new(UIPIC_GRID_nine_grid_bg3, 393, 565).view
    bgPanel:setPosition(0, 0)
    parent:addChild(bgPanel)
end

function TransformRight:create_inactive_upgrade_panel( parent )
    local bgPanel = ZBasePanel.new(UIPIC_GRID_nine_grid_bg3, 393, 565).view
    bgPanel:setPosition(0, 0)
    parent:addChild(bgPanel)
end

function TransformRight:create_aoyi_panel( parent )
    -- 创建分页button
    self.aoyi_radio_btn_group = CCRadioButtonGroup:buttonGroupWithFile( 335, 20, 58, 240, "" )
    parent:addChild(self.aoyi_radio_btn_group)

    -- 进阶按钮
    self.upgrade_button = CCRadioButton:radioButtonWithFile(0, 120, -1, -1, 
        UIResourcePath.FileLocate.common .. "xxk-1.png")
    self.upgrade_button:addTexWithFile( CLICK_STATE_DOWN,
        UIResourcePath.FileLocate.common .. "xxk-2.png")
    self.upgrade_button:setFlipX(true)

    local normal_text = CCZXImage:imageWithFile( 14, 20, -1, -1, "ui/transform/new20.png" )
    self.upgrade_button:addChild(normal_text)
    self.aoyi_radio_btn_group:addGroup(self.upgrade_button)
    local function but_1_fun(eventType,x,y)
        if eventType ==  TOUCH_BEGAN then 
            return true
        elseif eventType == TOUCH_CLICK then
            Instruction:handleUIComponentClick(instruct_comps.ANY_BTN)
            TransformModel:set_current_aoyi_page( TransformModel.AOYI_UPGRADE )
            self:change_page( TransformModel.AOYI_UPGRADE )
            return true;
        elseif eventType == TOUCH_ENDED then
            return true;
        end
    end
    self.upgrade_button:registerScriptHandler(but_1_fun)

    -- 属性按钮
    self.aoyi_attr_button = CCRadioButton:radioButtonWithFile(0, 0, -1, -1, 
        UIResourcePath.FileLocate.common .. "xxk-1.png")
    self.aoyi_attr_button:addTexWithFile( CLICK_STATE_DOWN,
        UIResourcePath.FileLocate.common .. "xxk-2.png")
    self.aoyi_attr_button:setFlipX(true)

    local normal_text = CCZXImage:imageWithFile( 14, 20, -1, -1, "ui/transform/new12.png" )
    self.aoyi_attr_button:addChild(normal_text)
    self.aoyi_radio_btn_group:addGroup(self.aoyi_attr_button)
    local function but_2_fun(eventType,x,y)
        if eventType ==  TOUCH_BEGAN then 
            return true
        elseif eventType == TOUCH_CLICK then
            Instruction:handleUIComponentClick(instruct_comps.ANY_BTN)
            TransformModel:set_current_aoyi_page( TransformModel.AOYI_ATTR )
            self:change_page( TransformModel.AOYI_ATTR )
            return true;
        elseif eventType == TOUCH_ENDED then
            return true;
        end
    end
    self.aoyi_attr_button:registerScriptHandler(but_2_fun)
end

function TransformRight:change_to_tujian_page( )
    local ninja_id = TransformModel:get_current_selected_ninja( )
    local had_ninja = TransformModel:is_has_transformm(ninja_id)
    local level = TransformModel:get_transform_level_by_id( ninja_id ) 
    local actived = TransformModel:is_transform_active( ninja_id, level)
    if had_ninja and actived then
        local page = TransformModel:get_current_tujian_page( )
        self:change_page(page)
    else
        self:change_page(TransformModel.TUJIAN_INACTIVE)
    end
end

function TransformRight:change_to_aoyi_page( )
    local aoyi_id = TransformModel:get_current_selected_aoyi( )
    local actived = TransformModel:check_aoyi_actived( aoyi_id )
    if actived then
        local page = TransformModel:get_current_aoyi_page( )
        self:change_page(page)
    else
        self:change_page(TransformModel.AOYI_INACTIVE)
    end
end

function TransformRight:update( update_type )
    if update_type == "all" then
        local left_page = TransformModel:get_current_left_page( )
        if left_page == TransformModel.TU_JIAN then
            self:change_to_tujian_page()
        elseif left_page == TransformModel.AO_YI then
            self:change_to_aoyi_page()
        end
    elseif update_type == TransformModel.TU_JIAN then
        self:change_to_tujian_page()
    elseif update_type == TransformModel.AO_YI then
        self:change_to_aoyi_page()
    end
end

--xiehande变身 培养成功/进阶成功 特效
function TransformRight:play_trans_effect()
    -- body
    LuaEffectManager:play_view_effect(10014,0,360,self.view,false,5 );
end


function TransformRight:destroy( )
    Window.destroy(self)
end
