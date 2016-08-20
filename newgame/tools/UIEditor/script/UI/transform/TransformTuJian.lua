-- TransformTuJian.lua 
-- createed by yongrui.liang on 2014-7-22
-- 变身图鉴

super_class.TransformTuJian(  )

local not_active = 1         --未激活
local is_transformming = 2   --变身
local recover_transform = 3  --还原变身
local not_has_transform = 4  --未激活变身

function TransformTuJian:__init( )
	self.items_dict = {}

	-- 底板
    self.view = ZBasePanel.new(UIPIC_GRID_nine_grid_bg3, 340, 515).view
	local panel = self.view

    ZBasePanel:create(panel, "", 10, 10, 340-20, 515-20, 500, 500)

	self:create_tujian_panel(panel)
end

-- 创建左底版显示内容
function TransformTuJian:create_tujian_panel( panel)

	local ninja_models = TransformConfig:get_all_ninja_models(  )
	local scroll = self:create_scroll_area(ninja_models, 10, 10, 340-20, 515-20, 1, 7, "" )
	panel:addChild( scroll )

    -- 总评分
    local fight_bg = ZImage:create(panel, "ui/common/zdldk-1.png", 0, -53, 340, -1, 0, 500, 500).view
    ZImage:create(fight_bg, "ui/transform/new7.png", 44, 12, -1, -1, 0)

    self.fight_val = ZXLabelAtlas:createWithString("99999", "ui/normal/number")
    self.fight_val:setPosition(CCPointMake(184, 14))
    self.fight_val:setAnchorPoint(CCPointMake(0, 0))
    fight_bg:addChild(self.fight_val)

    self:select_one_ninja(1)
end

-- 创建可拖动区域   参数：放入scroll的panel的集合, 坐标， 区域大小，列数，可见行数， 背景名称
function TransformTuJian:create_scroll_area( data_t, pos_x, pos_y, size_w, size_h, col_num, row_num, bg_name)
	local trans_index = 1
    local row_num = math.ceil( #data_t / col_num )
    local _scroll_info = { x = pos_x, y = pos_y, width = size_w, height = size_h, max_num = 1, image = bg_name, stype = TYPE_HORIZONTAL }
    local scroll = CCScroll:scrollWithFile( _scroll_info.x, _scroll_info.y, _scroll_info.width, _scroll_info.height, _scroll_info.max_num, _scroll_info.image, _scroll_info.stype, 600, 600 )

    local bg = CCBasePanel:panelWithFile(0, 0, size_w, 120*row_num, nil)
    local i = 1
    for k,v in pairs(data_t) do
        local data = v
        if data then
            local ninja_panel = self:create_one_ninja_panel(data, 0, 120*(row_num-i), size_w, 120)
            bg:addChild( ninja_panel )
            i = i + 1
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
            scroll:addItem(bg)
            scroll:refresh()
            return false
        end
    end
    scroll:registerScriptHandler(scrollfun)
    scroll:refresh()
    return scroll
end

-- 创建一个 scroll 中的 panel
function TransformTuJian:create_one_ninja_panel( data, x, y, w, h  )
    local sell_panel_bg = CCBasePanel:panelWithFile( x, y , w, h , nil )
    if data == nil then
        return sell_panel_bg
    end

    -- 匹配
    local function match_btn_click( )
        self:select_one_ninja(data.id)
    end
    local callback = match_btn_click
    local icon_cell = NinjiaIconHead(data, 0, 0, w, h, callback )
    sell_panel_bg:addChild( icon_cell.view )
    self.items_dict[data.id] = icon_cell
    return sell_panel_bg
end

function TransformTuJian:select_one_ninja( id )
    for k,v in pairs(self.items_dict) do
        v:set_selected(false)
    end
    self.items_dict[id]:set_selected(true)

    TransformModel:set_current_selected_ninja( id )
    TransformModel:update_right_win( )
end

function TransformTuJian:update( update_type )
    if update_type == "all" then
     	self:update_ninjia_card()
        self:update_point()
    end
 end

-- 更新忍者卡列表
function TransformTuJian:update_ninjia_card(  )
	local _transforms = TransformModel:get_transform_data( ).transforms
    for k,v in pairs(self.items_dict) do
        local icon_cell = self.items_dict[k]
        icon_cell:set_enable(false)
        local getway_str = TransformConfig:get_getway_by_id(k)
        icon_cell:set_get_way(string.format("%s%s", "#c929292", getway_str))
    end
    --
    for k,v in pairs(_transforms) do
		local icon_cell = self.items_dict[_transforms[k].id]
        if TransformModel:is_has_transformm(_transforms[k].id) then
            icon_cell:set_enable(true)
            local fight_val = TransformModel:get_point_by_id(_transforms[k].id)
            icon_cell:set_fight_val(string.format("%s%d", "#cfff000+", fight_val))
        end
	end
end

function TransformTuJian:update_point()
    local point = TransformModel:get_total_point(  )
    self.fight_val:init(tostring(point))
end
