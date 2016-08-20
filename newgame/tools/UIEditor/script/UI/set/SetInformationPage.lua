-- SetInformationPage.lua  
-- created by lyl on 2013-3-15
-- 信息设置

super_class.SetInformationPage(Window)


function SetInformationPage:create(  )
    -- local temp_panel_info = { texture = UIPIC_GRID_nine_grid_bg3, x = 40, y = 27, width = 840, height = 480 }
	return SetInformationPage( "SetInformationPage", UILH_COMMON.normal_bg_v2, true, 891, 524)
end

function SetInformationPage:__init( window_name, texture_name )
	local panel = self.view
	self.select_item_t = {}                    -- 所有选项控件集合

    -- 添加暗色背景
    local bg = CCBasePanel:panelWithFile( 12, 13, 865, 499, UILH_COMMON.bottom_bg, 500, 500 )
    panel:addChild( bg )

    -- 标题背景
    local title_bg = CCZXImage:imageWithFile( 8, 460 , 865-16, 35, UILH_NORMAL.title_bg4, 500, 500 ) 
    bg:addChild(title_bg)
    -- 标题文字：其他设置
    local title_text = MUtils:create_zxfont(title_bg,Lang.set_system_info.SetInformationPage[1],(875-10)/2,11,ALIGN_CENTER,16);    


    local content = LangGameString[1868] -- [1868]="#cffff00全部勾选"
    local function all_select_func()
        self:set_all_item(  )
    end

    self.all_select = UIButton:create_switch_button2( 55, 400, 160, 33, UILH_COMMON.dg_sel_1, UILH_COMMON.dg_sel_2, content, 40, 13, 15, nil, nil, nil, nil, all_select_func )
    panel:addChild( self.all_select.view )

    -- 创建所有选项
    local begin_x_1  = 150              -- 第一列x坐标
    local begin_x_2  = 510              -- 第二列x坐标
    local begin_y    = 325              -- 第一行y坐标
    local interval_y = 60               -- 行的y坐标间隔

    -- local content = "#cffff00坐骑消费提示"
    -- self.select_item_t[ SetSystemModel.COST_MOUNT ] = self:create_one_switch_but( begin_x_1, begin_y, 250, 20, "ui/pet/pet_toggle2_n.png", "ui/pet/pet_toggle2_s.png", content, 22, 14, SetSystemModel.COST_MOUNT )
    -- panel:addChild( self.select_item_t[ SetSystemModel.COST_MOUNT ].view )
    local content = Lang.set_system_info.SetInformationPage[2] -- [1869]="#cffff00道具不足时使用元宝复活提示"
    self.select_item_t[ SetSystemModel.COST_RELIVE ] = self:create_one_switch_but( begin_x_1, begin_y, 250, 33, UILH_COMMON.dg_sel_1, UILH_COMMON.dg_sel_2, content, 40, 15, SetSystemModel.COST_RELIVE )
    panel:addChild( self.select_item_t[ SetSystemModel.COST_RELIVE ].view )
    
    local content = Lang.set_system_info.SetInformationPage[3] -- [1870]="#cffff00快速完成任务提示"
    self.select_item_t[ SetSystemModel.COST_QUEST_QUICK_FINISH ] = self:create_one_switch_but( begin_x_2, begin_y, 250, 33, UILH_COMMON.dg_sel_1, UILH_COMMON.dg_sel_2, content, 40, 15, SetSystemModel.COST_QUEST_QUICK_FINISH )
    panel:addChild( self.select_item_t[ SetSystemModel.COST_QUEST_QUICK_FINISH ].view )
    

    begin_y = begin_y - interval_y
    local content = Lang.set_system_info.SetInformationPage[4] -- [1871]="#cffff00任务刷新星级提示"
    self.select_item_t[ SetSystemModel.COST_QUEST_REFRESH_STAR ] = self:create_one_switch_but( begin_x_1, begin_y, 250, 33, UILH_COMMON.dg_sel_1, UILH_COMMON.dg_sel_2, content, 40, 15, SetSystemModel.COST_QUEST_REFRESH_STAR )
    panel:addChild( self.select_item_t[ SetSystemModel.COST_QUEST_REFRESH_STAR ].view )
    
    local content = Lang.set_system_info.SetInformationPage[5] -- [1872]="#cffff00交易消费提示"
    self.select_item_t[ SetSystemModel.COST_TRADE ] = self:create_one_switch_but( begin_x_2, begin_y, 250, 33, UILH_COMMON.dg_sel_1, UILH_COMMON.dg_sel_2, content, 40, 15, SetSystemModel.COST_TRADE )
    panel:addChild( self.select_item_t[ SetSystemModel.COST_TRADE ].view )
    

    begin_y = begin_y - interval_y
    local content = Lang.set_system_info.SetInformationPage[6] -- [1873]="#cffff00装备强化使用保护符提示"
    self.select_item_t[ SetSystemModel.COST_EQUIP_STRENGHEN ] = self:create_one_switch_but( begin_x_1, begin_y, 250, 33, UILH_COMMON.dg_sel_1, UILH_COMMON.dg_sel_2, content, 40, 15, SetSystemModel.COST_EQUIP_STRENGHEN )
    panel:addChild( self.select_item_t[ SetSystemModel.COST_EQUIP_STRENGHEN ].view )
    
    local content = Lang.set_system_info.SetInformationPage[7] -- [1874]="#cffff00招财进宝提醒功能"
    self.select_item_t[ SetSystemModel.COST_MONEY_TREE ] = self:create_one_switch_but( begin_x_2, begin_y, 250, 33, UILH_COMMON.dg_sel_1, UILH_COMMON.dg_sel_2, content, 40, 15, SetSystemModel.COST_MONEY_TREE )
    panel:addChild( self.select_item_t[ SetSystemModel.COST_MONEY_TREE ].view )


    -- begin_y = begin_y - interval_y
    -- local content = "#cffff00快速完成任务提示"
    -- self.select_item_t[ SetSystemModel.COST_QUEST_QUICK_FINISH ] = self:create_one_switch_but( begin_x_1, begin_y, 250, 20, "ui/pet/pet_toggle2_n.png", "ui/pet/pet_toggle2_s.png", content, 22, 15, SetSystemModel.COST_QUEST_QUICK_FINISH )
    -- panel:addChild( self.select_item_t[ SetSystemModel.COST_QUEST_QUICK_FINISH ].view )

    begin_y = begin_y - interval_y
    local content = Lang.set_system_info.SetInformationPage[8] -- "#cffff00材料不足时,使用元宝升级法宝"
    self.select_item_t[ SetSystemModel.COST_UPGRADE_GEM ] = self:create_one_switch_but( begin_x_1, begin_y, 250, 33, UILH_COMMON.dg_sel_1, UILH_COMMON.dg_sel_2, content, 40, 15, SetSystemModel.COST_UPGRADE_GEM )
    panel:addChild( self.select_item_t[ SetSystemModel.COST_UPGRADE_GEM ].view )
    
    local content = Lang.set_system_info.SetInformationPage[9] -- "#cffff00消费元宝召唤阴阳提示"
    self.select_item_t[ SetSystemModel.COST_GEM_VIP_HUNT ] = self:create_one_switch_but( begin_x_2, begin_y, 250, 33, UILH_COMMON.dg_sel_1, UILH_COMMON.dg_sel_2, content, 40, 15, SetSystemModel.COST_GEM_VIP_HUNT )
    panel:addChild( self.select_item_t[ SetSystemModel.COST_GEM_VIP_HUNT ].view )

    begin_y = begin_y - interval_y
    local content = Lang.set_system_info.SetInformationPage[10] -- [1877]="#cffff00坐骑消费提示"
    self.select_item_t[ SetSystemModel.COST_MOUNT ] = self:create_one_switch_but( begin_x_1, begin_y, 250, 33, UILH_COMMON.dg_sel_1, UILH_COMMON.dg_sel_2, content, 40, 15, SetSystemModel.COST_MOUNT )
    panel:addChild( self.select_item_t[ SetSystemModel.COST_MOUNT ].view )

    self:update_all_but(  )
end

-- 创建一个选择控件
function SetInformationPage:create_one_switch_but( x, y, w, h, image_n, image_s, words, words_x, fontsize, but_key )
    local function switch_button_func(  )
        self:check_all_select()            -- 点击每个按钮，都要检查是否全满，设置全选按钮的状态
        self:config_change( but_key )
    end
	local switch_but = UIButton:create_switch_button2( x, y, w, h, image_n, image_s, words, words_x, 13, fontsize, nil, nil, nil, nil, switch_button_func )
	switch_but.but_key = but_key
	return switch_but
end

-- 检查是否全满，设置全选按钮的状态
function SetInformationPage:check_all_select()
    local if_all_select = true
    for key, switch_but in pairs(self.select_item_t) do
        if not switch_but.if_selected then
            if_all_select = false
        end
    end
    if if_all_select then
        self.all_select.set_state( true )
    else
    	self.all_select.set_state( false )
    end
end

-- 全选设置
function SetInformationPage:set_all_item(  )
	local if_selected = self.all_select.if_selected
	for key, switch_but in pairs(self.select_item_t) do
        switch_but.set_state( if_selected, true )
	end
end

-- 选项发生改变
function SetInformationPage:config_change( but_key )
	local switch_but = self.select_item_t[ but_key ]
	local but_value  = switch_but.if_selected
	SetSystemModel:set_one_date( but_key, but_value )
end

-- 更新所有选择按钮
function SetInformationPage:update_all_but(  )
	for key, switch_but in pairs(self.select_item_t) do 
        local value = SetSystemModel:get_date_value_by_key( key )
        switch_but.set_state( value )
	end
	self:check_all_select()
end

-- 更新数据
function SetInformationPage:update( update_type )
    if update_type == "set_date" then
        self:update_all_but(  )
    elseif update_type == "all" then
        self:update_all_but();
    end
end
