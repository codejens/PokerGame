-- MirrorNearWin.lua
-- 放大镜弹出选项

super_class.MirrorNearWin(Window)

local _scroll_info = {}
function MirrorNearWin:scroll_create_fun(index)
    if #_scroll_info == 0 then return end
    local panel_height = 70*#_scroll_info - 3
	local base_panel = ZBasePanel:create( nil, nil, 0, 0, 240, panel_height )
    for i, item in ipairs(_scroll_info) do
        local entity = item.avatar
        local temp = ZBasePanel:create(nil, nil, 0, panel_height-70*i, 240, panel_height)
        -- 头像背景
        local head_bg = ZImage:create(temp, UILH_MAIN.mirror_head, 10, 5, -1, -1)
        -- 头像
        local head_path = UIResourcePath.FileLocate.lh_normal .. "head/head"..entity.job..entity.sex..".png"
        local head = ZImage:create(head_bg, head_path, 5, 5, 49, 49)
        -- 阵营和玩家姓名
    	local campname = Lang.camp_name_ex[tonumber(entity.camp)]
    	local name = campname .. entity.name
    	-- local job = entity.job and Lang.friend.infowin[7] .. Lang.job_info[tonumber(entity.job)] or ""
    	local level = LH_COLOR[2] .. Lang.friend.infowin[6] .. entity.level
    	local lab1 = ZLabel:create(temp, name, 80, 41, 16)
    	local lab2 = ZLabel:create(temp, level, 80, 13, 16)
        if item.is_enemy then
            ZImage:create(temp, UILH_MAIN.mirror_enemy, 175, 5, -1, -1)
        end
        local line = ZImage:create(temp, UILH_COMMON.split_line, 12, 0, 216, 2, nil, 500)
        local function item_click_fun()
            local player = EntityManager:get_player_avatar();
            --设置目标
            player:set_target(entity)
            -- 施放技能
            local skill = AIManager:get_can_use_skill();
            --print("释放技能。。。。。skill",skill)
            if ( skill ) then
                CommandManager:combat_skill( skill ,player );
                -- UIManager:destroy_window("mirror_win");
            end
        end
        temp:setTouchClickFun(item_click_fun)
        base_panel:addChild(temp)
    end

	return base_panel
end

function MirrorNearWin:__init(window_name)
	local panel = CCBasePanel:panelWithFile( 1, 0, 260, 390, UILH_COMMON.dialog_bg, 500, 500 )
    self.view:addChild(panel)
    local title_bg = ZImage:create(panel, UILH_NORMAL.title_bg4, 1, 351, 257, -1, 0, 500, 500)
    local title = ZImage:create(panel, UILH_MAIN.mirror_title, 80, 356, -1, -1)
    local scroll_bg = ZImage:create(panel, UILH_COMMON.bottom_bg, 14, 15, 233, 338, nil, 500, 500)
	self.scroll = ZScroll:create(nil, nil, 14, 18, 233, 330, 1, TYPE_HORIZONTAL)
	self.scroll:setScrollCreatFunction( self.scroll_create_fun )
    local function exit_fun()
        UIManager:destroy_window("mirror_win");
    end

    local exit_btn = ZButton:create(self.view, UILH_COMMON.close_btn_z, exit_fun, 0, 0, 60, 60)
    local window_size = self.view:getSize()
    exit_btn.view:setPosition(window_size.width - 70, window_size.height - 70)
    panel:addChild( self.scroll.view )
    -- self.view:registerScriptHandler(hideTipWin)
end

function MirrorNearWin:update(info)
    _scroll_info = info
    self.scroll:clear()
    self.scroll:refresh()
end
function MirrorNearWin:destroy(  )
    Window.destroy(self)
    _scroll_info = {}
end