-- FamilyNominateWin.lua
-- created by liang.yongrui on 2014-5-12
-- 家族任命

super_class.FamilyNominateWin(Window)

local color_yellow = "#cffff00"
local font_size = 16

local _mem_info = nil
local _mem_name = "他（她）"

function FamilyNominateWin:create( mem_info )
	return FamilyNominateWin("FamilyNominateWin", "", false, 416, 331, mem_info )
end

-- 关闭按钮
local function close_but_CB( )
    GuildModel:hide_nominate_win()
end

local function ok_btn_func( ... )
    if _mem_info == nil then
        return
    end
    if _wang_btn and _wang_btn.if_selected then
        LeftClickMenuMgr:nomi_wang(_mem_info)
    elseif _deputy_btn and _deputy_btn.if_selected then
        LeftClickMenuMgr:nomi_deputy(_mem_info)
    elseif _elder_btn and _elder_btn.if_selected then
        LeftClickMenuMgr:nomi_hufa(_mem_info)
    elseif _elite_btn and _elite_btn.if_selected then
        LeftClickMenuMgr:nomi_elite(_mem_info)
    elseif _memb_btn and _memb_btn.if_selected then
        LeftClickMenuMgr:nomi_follower(_mem_info)
    end
    GuildModel:hide_nominate_win()
end

function FamilyNominateWin:__init( win_name, texture, isgrid, width, height, mem_info )
    _mem_info = mem_info
    _mem_name = mem_info[1].name or _mem_name

	local dialog_bg = CCBasePanel:panelWithFile(0, 0, width, height, UIPIC_FAMILY_014, 500, 500)
    self.view:addChild(dialog_bg)

    local title = CCZXImage:imageWithFile(170, 294, 87, 17, UIPIC_FAMILY_055)
    dialog_bg:addChild(title)

    --背景框
    local bgPanel = CCBasePanel:panelWithFile( 20, 26, 380, 244, UIPIC_FAMILY_015, 500, 500 )
    dialog_bg:addChild( bgPanel )

    -- 关闭按钮
    local close_but = UIButton:create_button_with_name( 369, 288, -1, -1, UIPIC_FAMILY_039, UIPIC_FAMILY_039, nil, "", close_but_CB )
    dialog_bg:addChild( close_but.view )

    local panel = CCBasePanel:panelWithFile(12, 58, 356, 175, UIPIC_FAMILY_011, 500, 500)
    bgPanel:addChild(panel)

    self:draw_select_panel(panel)
--xiehande   UIPIC_FAMILY_058 ->UIPIC_COMMOM_002
    local ok_btn = ZTextButton:create(bgPanel, "确  定", UIPIC_COMMOM_002, ok_btn_func, 125, 10, 126, 43)
end

function FamilyNominateWin:draw_select_panel( parent )
    local label = UILabel:create_lable_2( "你要任命#cffff00" .. _mem_name .. "#cffffff为：", 10, 150, font_size, ALIGN_LEFT )
    parent:addChild(label)
    self.name_label = label

    local switch_wang_func = function(  )
        if _deputy_btn and _deputy_btn.if_selected then
            _deputy_btn.set_state(false)
        end
        if _elder_btn and _elder_btn.if_selected then
            _elder_btn.set_state(false)
        end
        if _elite_btn and _elite_btn.if_selected then
            _elite_btn.set_state(false)
        end
        if _memb_btn and _memb_btn.if_selected then
            _memb_btn.set_state(false)
        end
    end

    local switch_deputy_func = function(  )
        if _wang_btn and _wang_btn.if_selected then
            _wang_btn.set_state(false)
        end
        if _elder_btn and _elder_btn.if_selected then
            _elder_btn.set_state(false)
        end
        if _elite_btn and _elite_btn.if_selected then
            _elite_btn.set_state(false)
        end
        if _memb_btn and _memb_btn.if_selected then
            _memb_btn.set_state(false)
        end
    end

    local switch_elder_func = function(  )
        if _wang_btn and _wang_btn.if_selected then
            _wang_btn.set_state(false)
        end
        if _deputy_btn and _deputy_btn.if_selected then
            _deputy_btn.set_state(false)
        end
        if _elite_btn and _elite_btn.if_selected then
            _elite_btn.set_state(false)
        end
        if _memb_btn and _memb_btn.if_selected then
            _memb_btn.set_state(false)
        end
    end

    local switch_elite_func = function(  )
        if _wang_btn and _wang_btn.if_selected then
            _wang_btn.set_state(false)
        end
        if _deputy_btn and _deputy_btn.if_selected then
            _deputy_btn.set_state(false)
        end
        if _elder_btn and _elder_btn.if_selected then
            _elder_btn.set_state(false)
        end
        if _memb_btn and _memb_btn.if_selected then
            _memb_btn.set_state(false)
        end
    end

    local switch_memb_func = function(  )
        if _wang_btn and _wang_btn.if_selected then
            _wang_btn.set_state(false)
        end
        if _deputy_btn and _deputy_btn.if_selected then
            _deputy_btn.set_state(false)
        end
        if _elder_btn and _elder_btn.if_selected then
            _elder_btn.set_state(false)
        end
        if _elite_btn and _elite_btn.if_selected then
            _elite_btn.set_state(false)
        end
    end

    local btn_1 = UIButton:create_switch_button(22, 90, 110, 33, 
        UIPIC_FORGE_031, 
        UIPIC_FORGE_032, 
        color_yellow .. "族长(让位)", 
        36, font_size, 
        nil, nil, nil, nil, 
        switch_wang_func )
    parent:addChild(btn_1.view)
    _wang_btn = btn_1

    local btn_2 = UIButton:create_switch_button(238, 90, 110, 33, 
        UIPIC_FORGE_031, 
        UIPIC_FORGE_032, 
        color_yellow .. "副族长", 
        36, font_size, 
        nil, nil, nil, nil, 
        switch_deputy_func )
    parent:addChild(btn_2.view)
    _deputy_btn = btn_2

    local btn_3 = UIButton:create_switch_button(22, 30, 110, 33, 
        UIPIC_FORGE_031, 
        UIPIC_FORGE_032, 
        color_yellow .. "长老", 
        36, font_size, 
        nil, nil, nil, nil, 
        switch_elder_func )
    parent:addChild(btn_3.view)
    _elder_btn = btn_3

    local btn_4 = UIButton:create_switch_button(140, 30, 110, 33, 
        UIPIC_FORGE_031, 
        UIPIC_FORGE_032, 
        color_yellow .. "精英", 
        36, font_size, 
        nil, nil, nil, nil, 
        switch_elite_func )
    parent:addChild(btn_4.view)
    _elite_btn = btn_4

    local btn_5 = UIButton:create_switch_button(238, 30, 110, 33, 
        UIPIC_FORGE_031, 
        UIPIC_FORGE_032, 
        color_yellow .. "成员", 
        36, font_size, 
        nil, nil, nil, nil, 
        switch_memb_func )
    parent:addChild(btn_5.view)
    _memb_btn = btn_5
end

function FamilyNominateWin:set_mem_info( mem_info )
    _mem_info = mem_info
    _mem_name = mem_info[1].name or _mem_name
    self.name_label:setString("你要任命#cffff00" .. _mem_name .. "#cffffff为：")
end