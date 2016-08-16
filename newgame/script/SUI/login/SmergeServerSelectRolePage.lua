-- SmergeServerSelectRolePage.lua
-- windows 创建范例 (基于ui编辑器的)

super_class.SmergeServerSelectRolePage(BaseEditWin)



function SmergeServerSelectRolePage:__init(  )
    self.role_list = SelectServerRoleModel:get_role_data_list()

    --Utils:print_table(self.role_list)
    self.scroll_1:update(#self.role_list)
end

-- 获取UI控件
function SmergeServerSelectRolePage:save_widget( )
	--定义好需要用到的控件
    self.scroll_1 = self:get_widget_by_name("scroll_1")
    self.sure_btn = self:get_widget_by_name("sure_btn")

end

-- 需求监听事件 则重写此方法 添加事件监听 父类自动调用
function SmergeServerSelectRolePage:registered_envetn_func(  )

    self.sure_btn:set_click_func(function () self:sure_btn_callback() end)

    local function scroll_callback(idx)
        return self:create_one_row(idx+1)        
    end

    self.scroll_1:set_touch_func(SCROLL_CREATE_ITEM, scroll_callback)
end

function SmergeServerSelectRolePage:sure_btn_callback()
    print (self.sel_index)

    if self.sel_index and self.role_list and self.role_list[self.sel_index] then    
        local AOI_size = ZXLogicScene:sharedScene():getViewPortSize()
        local tile_width_limit = AOI_size.width / SceneConfig.LOGIC_TILE_WIDTH
        local tile_height_limit= AOI_size.height / SceneConfig.LOGIC_TILE_HEIGHT

        local role = self.role_list[self.sel_index]
        local platform = RoleModel:get_platform()
        SelectRoleCC:request_enter_game( role.id, tile_width_limit, tile_height_limit, platform )
    else
        GlobalFunc:create_screen_notic("请选择角色")
    end
    
end

function SmergeServerSelectRolePage:create_one_row(index)
   -- local panel = SPanel:create("nopack/xszy/zezhao1.png", 450, 115)
    local panel = SPanel:create("", 450, 115)
    local touch_panel = SPanel:create("", 450, 115)
    panel:addChild(touch_panel, 10000)

    local role = self.role_list[index]

    --#c783c17
    local name = "#c783c17" .. role.name
    local job = "#c783c17" .. RoleModel:get_job_name_by_job(role.job)
    local job_id = role.job
    -- local job_id = index%3 +1
    -- job_id = job_id == 3 and 4 or job_id
    local level = "#c783c17等级 " .. role.level
    local f_value = "#c783c17战力 " .. role.fightValue

    local no_bg = SImage:create("nopack/login/hf_no_sel.png")
    no_bg:setAnchorPoint(0.5,0.5)
    no_bg:setPosition(220,45)
    panel:addChild(no_bg)

    local bg = SImage:create("nopack/login/hf_sel.png")
    bg:setAnchorPoint(0.5,0.5)
    bg:setPosition(210,50)
    panel:addChild(bg)

    local name_lb = SLabel:create(name,18)
    name_lb:setPosition(120,55)
    panel:addChild(name_lb)

    local job_lb = SLabel:create(job,18)
    job_lb:setPosition(120,20)
    panel:addChild(job_lb)

    local f_value_lb = SLabel:create(f_value,18)
    f_value_lb:setPosition(255,55)
    panel:addChild(f_value_lb)

    local level_lb = SLabel:create(level,18)
    level_lb:setPosition(255,20)
    panel:addChild(level_lb)

    local str = string.format("nopack/login/%d.png", job_id)
    local head = SImage:create(str)
    head:setPosition(0,0)
    if job_id == 1 then
        head:setScale(0.32)
    elseif job_id == 2 then
        head:setScale(0.34)
    elseif job_id == 3 then
        head:setScale(0.3)
    elseif job_id == 4 then
        head:setScale(0.35)
    end
    panel:addChild(head)


    bg:setIsVisible(false)
    local obj = {bg = bg, no_bg = no_bg, index = index}
    if self.sel_index and self.sel_index == index then
        obj.bg:setIsVisible(true)
        obj.no_bg:setIsVisible(false)
        self.sel_obj = obj
        self.sel_index = index
    end

    local function click_func()
        if self.sel_obj then
            self.sel_obj.bg:setIsVisible(false)
            self.sel_obj.no_bg:setIsVisible(true)
        end
        obj.bg:setIsVisible(true)
        obj.no_bg:setIsVisible(false)
        self.sel_obj = obj
        self.sel_index = index
    end
    touch_panel:set_click_func(click_func)

    local function delete_item_callback()
        if self.sel_obj and self.sel_obj.index == index then
            self.sel_obj = nil
        end
    end
    panel:set_touch_func(ITEM_DELETE,delete_item_callback)


    return panel
end

