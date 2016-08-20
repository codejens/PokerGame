-- ActiTemplateModel.lua
-- created by chj on 2015-2-11
-- 活动公共模板Mddel


ActiTemplateModel = {}

ActiTemplateModel.main_conf = nil
ActiTemplateModel.child_conf = nil

-- 创建各个分页的表对象
ActiTemplateModel.page_group = nil


function ActiTemplateModel:fini( ... )

end

-- 存入各个分页的表对象(UI)
function ActiTemplateModel:set_page_group( page_group )
    self.page_group = page_group
end

-- 获取各个分页的表对象(UI)
function ActiTemplateModel:get_page_group( )
    return self.page_group
end
-- 根据序列获取表对象
function ActiTemplateModel:get_page_group_index( index )
    if self.page_group  then
        return self.page_group[index]
    end
    return nil
end

-- 获取整个配置文件
function ActiTemplateModel:get_actitemplate_conf()
    return ActiTemplateConfig:get_actitemplate_conf()
end


-- 获取主数据 =======================================
function ActiTemplateModel:get_maindata_conf( )

    -- 子类是否有自己的配置文件
    if self.child_conf then
        if self.child_conf.main_conf then
            return self.child_conf.main_conf
        end
    end

    -- 默认主要元素配置
    if not main_conf then
        self.main_conf = ActiTemplateConfig:get_maindata_conf()
    end
    return self.main_conf
end

-- 获取配置文件到活动中的子活动数据
function ActiTemplateModel:get_childdata_conf( )
    if self.child_conf then
        if self.child_conf.include_acti then
            return self.child_conf.include_acti
        end
    end
    return nil
end

--- 获取各个面板控件数据 -------------------------------------------
---- 大背景
function ActiTemplateModel:get_panelbase_conf( )
    local main_conf = ActiTemplateModel:get_maindata_conf( )
    return main_conf.panel_base
end

---- 左面板
function ActiTemplateModel:get_panel_panelleft_conf()
    local main_conf = ActiTemplateModel:get_maindata_conf( )
    return main_conf.panel_left
end

-- scrollview
function ActiTemplateModel:get_scrollleft_conf( )
    local main_conf = ActiTemplateModel:get_maindata_conf( )
    return main_conf.scroll_left
end

-- scrollview 的 item(左面板)
function ActiTemplateModel:get_scrollitem_conf( )
    local main_conf = ActiTemplateModel:get_maindata_conf( )
    return main_conf.scroll_item
end

-- scrollview 选中框
function ActiTemplateModel:get_sld_frame_conf( )
    local main_conf = ActiTemplateModel:get_maindata_conf( )
    return main_conf.scroll_sld_frame
end
--------------------------------------------------------------------------

-- 获取包含活动的个数
function ActiTemplateModel:get_acti_include_num()
    local acti_inc = ActiTemplateModel:get_childdata_conf( )
    if acti_inc then
        return #acti_inc
    else
        return 0
    end
end

-- 获取第index个包含活动的数据
function ActiTemplateModel:get_acti_include_index( index )
    local acti_inc = ActiTemplateModel:get_childdata_conf( )
    if acti_inc then
        if acti_inc[index] then
            return acti_inc[index] 
        end
    end
    return nil
end

---- 右面板 --
function ActiTemplateModel:get_panel_panelright_conf()
    local main_conf = ActiTemplateModel:get_maindata_conf( )
    return main_conf.panel_right
end


-- =========================
-- 配置文件
-- =========================
-- not use
-- function ActiTemplateModel:get_activity_conf( conf_name )
--     return ActiTemplateConfig:get_activity_conf( conf_name)
-- end

-- 设置配置文件
function ActiTemplateModel:set_activity_child_conf( acti_conf )
    self.child_conf = acti_conf
end

-- 获取配置文件
function ActiTemplateModel:get_activity_child_conf( )
    return self.child_conf
end

-- show_window
function ActiTemplateModel:show_window( win_name, acti_conf )
    ActiTemplateModel:set_activity_child_conf( acti_conf)
    UIManager:show_window( win_name)
end