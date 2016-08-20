-- TransformAoYi.lua 
-- createed by yongrui.liang on 2014-7-22
-- 变身图鉴

super_class.TransformAoYi(  )

local not_active = 1         --未激活
local is_transformming = 2   --变身
local recover_transform = 3  --还原变身
local not_has_transform = 4  --未激活变身
local _select_index = 1

function TransformAoYi:__init( )
	self.items_dict={}

	-- 底板
    self.view = ZBasePanel.new(UIPIC_GRID_nine_grid_bg3, 340, 515+50).view
	local panel = self.view

    ZBasePanel:create(panel, "", 10, 10, 340-20, 515+50-20, 500, 500)

	self:create_aoyi_panel(panel)
end

function TransformAoYi:create_aoyi_panel( parent )
    local data_para = TransformConfig:get_all_miji( )
    local scroll = self:create_scroll_area(data_para, 10, 10, 320, 545, 1, 6, nil)
    parent:addChild(scroll)

    self:select_on_aoyi(data_para[1].id)
end

-- 创建可拖动区域   参数：放入scroll的panel的集合, 坐标， 区域大小，列数，可见行数， 背景名称
function TransformAoYi:create_scroll_area( data_t, pos_x, pos_y, size_w, size_h, col_num, row_num, bg_name)
    local row_num = math.ceil( #data_t / col_num )
    local _scroll_info = { x = pos_x, y = pos_y, width = size_w, height = size_h, max_num = 1, image = bg_name, stype = TYPE_HORIZONTAL }
    local scroll = CCScroll:scrollWithFile( _scroll_info.x, _scroll_info.y, _scroll_info.width, _scroll_info.height, _scroll_info.max_num, _scroll_info.image, _scroll_info.stype, 600, 600 )

    local bg = CCBasePanel:panelWithFile(0, 0, size_w, 100*row_num, nil)
    for i,v in ipairs(data_t) do
        local data = v
        if data then
            local skill_panel = self:create_one_skill(data, 0, 100*(row_num-i), size_w, 100)
            bg:addChild( skill_panel.view )
        end
    end

    local function scrollfun(eventType, args, msg_id)
        if eventType == nil or args == nil or msg_id == nil then 
            return
        end
        if eventType == TOUCH_BEGAN then
            return true
        elseif eventType == TOUCH_MOVED then
            return true
        elseif eventType == TOUCH_ENDED then
            return true
        elseif eventType == SCROLL_CREATE_ITEM then
            local temparg = Utils:Split(args,":")
            local x = temparg[1]              -- 行
            local y = temparg[2]              -- 列
            local index = x * col_num
            scroll:addItem(bg)
            scroll:refresh()
            return false
        end
    end
    scroll:registerScriptHandler(scrollfun)
    scroll:refresh()
    return scroll
end

function TransformAoYi:create_one_skill( data, x, y, w, h )
    local function icon_click_callback( )
        self:select_on_aoyi(data.id)
    end
    local cell = TransformIconCell(x, y, w, h,"非银针奥义", 0, icon_click_callback)
    cell:set_icon(data.jihuoitem)
    cell:set_item_text(data.name or "")
    self.items_dict[data.id] = cell
    return cell
end

function TransformAoYi:select_on_aoyi( id )
    for k,v in pairs(self.items_dict) do
        v:set_selected(false)
    end
    self.items_dict[id]:set_selected(true)

    TransformModel:set_current_selected_aoyi( id )
    TransformModel:update_right_win( )
end

function TransformAoYi:update_aoyi_item( )
    local mlv = TransformModel:get_aoyi_max_level( )
    for k,v in pairs(self.items_dict) do
        if TransformModel:check_aoyi_actived( k ) then
            v.item:set_icon_light_color()
            local lv = TransformModel:get_miji_level_by_id( k )
            v:set_level_text(string.format("%s%s%d%s%d", "#cffffff当前进阶数：", "#c00ff00", lv, "/", mlv))
        else
            v.item:set_icon_dead_color()
            local need_id = TransformConfig:get_need_miji_id(k)
            local name = ItemConfig:get_item_name_by_item_id(need_id)
            v:set_level_text(string.format("%s%s%s", "#cffffff激活需要", "#c00ff00", name or ""))
        end
    end
end

function TransformAoYi:update( update_type )
    if update_type == "all" then
        self:update_aoyi_item()
    end
end
