-- FamilyDonateWin.lua
-- created by liang.yongrui on 2014-5-10
-- 家族捐献

super_class.FamilyDonateWin(Window)

local color_yellow = LH_COLOR[2]
local font_size = 16

local _donate_func = nil
local _donate_num_edit = nil

function FamilyDonateWin:create( ... )
	return FamilyDonateWin("FamilyDonateWin", UILH_COMMON.bg_04, true, 440, 300 )
end

function FamilyDonateWin:show( donate_func )
	local win = UIManager:show_window("family_donate_win", true)
	_donate_func = donate_func
end

-- 关闭按钮
local function close_but_CB( )
    GuildModel:hide_donate_win()
end

function FamilyDonateWin:__init( win_name, texture, isgrid, width, height )
	-- local dialog_bg = CCBasePanel:panelWithFile(0, 0, 440, 300, UILH_COMMON.bg_04, 500, 500)
 --    self.view:addChild(dialog_bg)
    local dialog_bg = self.view
    -- local title = CCZXImage:imageWithFile(170, 294, 87, 17, UIPIC_FAMILY_054)
    -- dialog_bg:addChild(title)

    --背景框
    local bgPanel = CCBasePanel:panelWithFile( 440/2 - 410/2, 77, 410, 180, UIPIC_GRID_nine_grid_bg3, 500, 500 )
    dialog_bg:addChild( bgPanel)

    -- 关闭按钮
    local close_but = UIButton:create_button_with_name( 0, 0, -1, -1, UIPIC_COMMOM_008, UIPIC_COMMOM_008, nil, "", close_but_CB)
    local close_but_size = close_but.view:getSize()
    local self_size = self.view:getSize()
    close_but.view:setPosition( self_size.width - close_but_size.width-5, self_size.height -close_but_size.height+20)
    dialog_bg:addChild( close_but.view,999 )
    
    --捐献
    local donate_label = UILabel:create_lable_2( LH_COLOR[2]..Lang.guild[44], 84, 129, 16, ALIGN_LEFT )
    bgPanel:addChild(donate_label)

    _donate_num_edit = CCZXEditBox:editWithFile( 128, 122, 154, 31, UILH_COMMON.bg_grid1, 6, 16, EDITBOX_TYPE_NORMAL, 500, 500)
    bgPanel:addChild( _donate_num_edit )

    --元宝
    local unit_label = UILabel:create_lable_2( LH_COLOR[2]..Lang.normal[4], 283, 129, 16, ALIGN_LEFT )
    bgPanel:addChild(unit_label)
    
    local contirbutionRatio = GuildConfig:get_contirbutionRatio(  )                    -- 一元宝可得多少贡献
   
    -- local _buy_num = _donate_num_edit:getText()
    -- print(_buy_num)
    _buy_num = 1
    --你将获得多少贡献
    local gognxian_label = UILabel:create_lable_2(LH_COLOR[2]..Lang.shop[11].. tostring(_buy_num*contirbutionRatio).. Lang.shop[12], 130, 89, 16, ALIGN_LEFT )
    bgPanel:addChild(gognxian_label)

    --你将获得多少军团令牌
    local temp_rate = GuildConfig:get_yuanbao_lingshi_rate()
    local lingpai_label = UILabel:create_lable_2( LH_COLOR[2]..Lang.shop[13].. tostring(_buy_num*temp_rate) .. Lang.shop[14], 130, 52, 16, ALIGN_LEFT )
    bgPanel:addChild(lingpai_label)


    -- local line = CCZXImage:imageWithFile( 26, 100, 315, 2, UIPIC_DREAMLAND_028 )      -- 线
    -- bgPanel:addChild(line)

    local function donate_callback( ... )
    	local num = 0
    	if _donate_func then
         print(_donate_func)
    		_donate_func(num)
    	end
    end
    local donate_btn = ZTextButton:create(dialog_bg, LH_COLOR[2]..Lang.guild[43], UILH_COMMON.lh_button_4_r, donate_callback, 159, 19, -1, -1)
end

