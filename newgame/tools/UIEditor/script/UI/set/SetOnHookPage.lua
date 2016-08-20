-- SetOnHookPage.lua
-- created by lyl on 2013-4-8
-- 挂机

super_class.SetOnHookPage(Window)

--local skill_index_title_t = { LangGameString[1878], LangGameString[1879], LangGameString[1880], LangGameString[1881] } -- [1878]="一、" -- [1879]="二、" -- [1880]="三、" -- [1881]="四、"

local _skill_id_change_out = nil        -- 技能面板交换数据，被拖出来的面板
local _skill_id_change_in  = nil        -- 技能面板交换数据，被拖进来的面板

local _skill_panel_index_to_key_t = {     -- skill key
    SetSystemModel.HOOK_CYCLE_SKILL1, 
    SetSystemModel.HOOK_CYCLE_SKILL2,
    SetSystemModel.HOOK_CYCLE_SKILL3,
    SetSystemModel.HOOK_CYCLE_SKILL4,
 }

local _skill_panel_switch_to_key_t = {    -- 技能面板的开关，key
    SetSystemModel.HOOK_SKILL_PANEL_1,
    SetSystemModel.HOOK_SKILL_PANEL_2,
    SetSystemModel.HOOK_SKILL_PANEL_3,
    SetSystemModel.HOOK_SKILL_PANEL_4,
}

function SetOnHookPage:create(  )
	return SetOnHookPage( "SetOnHookPage", UILH_COMMON.normal_bg_v2, true, 891, 524)
end

function SetOnHookPage:__init( window_name, texture_name )
	self.select_item_t = {}                    -- 所有选项控件集合  
	self.skill_panel_t = {}                    -- 技能面板（包括了标题和停止使用开关按钮）

    commonPath = UIResourcePath.FileLocate.common
    systemPath = UIResourcePath.FileLocate.systemSet

    local left_bg = CCBasePanel:panelWithFile( 12, 13, 425, 499, UILH_COMMON.bottom_bg ,500,500 )
    self.view:addChild( left_bg )    
    local right_bg = CCBasePanel:panelWithFile( 438, 13, 439, 499, UILH_COMMON.bottom_bg ,500,500 )
    self.view:addChild( right_bg )    

    self:create_left_up_panel(11, 330, 430, 170)
    self:create_left_down_panel(7, 16, 430, 310)
    self:create_right_up_panel(440, 368, 435, 140)
    self:create_right_down_panel(440, 6, 435, 350)
	
end

function SetOnHookPage:create_left_up_panel(x, y, width, height)
    -- 创建九宫格底板
    -- local panel = CCBasePanel:panelWithFile( x, y, width, height, UILH_COMMON.bg_grid ,500,500 )
    local panel = CCBasePanel:panelWithFile( x, y, width, height, nil,500,500 )
    self.view:addChild( panel )

    local begin_y = height-50
    local row_space = 55

    -- Lang.set_system_info.SetOnHookPage.left_up_tip1="#cffff00生命补给或法力补给耗尽停止打怪"
    local content = Lang.set_system_info.SetOnHookPage.left_up_tip1;
    self.select_item_t[ SetSystemModel.STOP_AUTO_FIGHTING ] = self:create_one_switch_but( 20, begin_y, 330, 33, UILH_COMMON.dg_sel_1, UILH_COMMON.dg_sel_2, content, 40, 12, 15, SetSystemModel.STOP_AUTO_FIGHTING )
    panel:addChild( self.select_item_t[ SetSystemModel.STOP_AUTO_FIGHTING ].view )

    -- Lang.set_system_info.SetOnHookPage.left_up_tip2="#cffff00使用复活石原地复活"
    local content = Lang.set_system_info.SetOnHookPage.left_up_tip2;
    self.select_item_t[ SetSystemModel.AUTO_USE_STONE_RELIVE ] = self:create_one_switch_but( 20, begin_y-row_space, 330, 33, UILH_COMMON.dg_sel_1, UILH_COMMON.dg_sel_2, content, 40, 12, 15, SetSystemModel.AUTO_USE_STONE_RELIVE )
    panel:addChild( self.select_item_t[ SetSystemModel.AUTO_USE_STONE_RELIVE ].view )

    -- Lang.set_system_info.SetOnHookPage.left_up_tip3="#cffff00自动拾取物品"
    local content = Lang.set_system_info.SetOnHookPage.left_up_tip3;
    self.select_item_t[ SetSystemModel.AUTO_PICK ] = self:create_one_switch_but( 20, begin_y-row_space*2, 330, 33, UILH_COMMON.dg_sel_1, UILH_COMMON.dg_sel_2, content, 40, 12, 15, SetSystemModel.AUTO_PICK )
    panel:addChild( self.select_item_t[ SetSystemModel.AUTO_PICK ].view )
end

function SetOnHookPage:create_left_down_panel(x, y, width, height)
    -- 创建底板
    -- local panel = CCBasePanel:panelWithFile( x, y, width, height, UILH_COMMON.bg_grid, 500, 500 )
    local panel = CCBasePanel:panelWithFile( x, y, width, height, nil, 500, 500 )
    self.view:addChild( panel )

    -- 标题背景
    local title_bg = CCZXImage:imageWithFile( 5, height - 40 , width-10, 35, UILH_NORMAL.title_bg4, 500, 500 ) 
    panel:addChild(title_bg)
    -- 标题文字：自动补血和法力设置
    local title_text = MUtils:create_zxfont(title_bg,Lang.set_system_info.SetOnHookPage.left_down_title,(width-10)/2,11,ALIGN_CENTER,16);
    
    -- 三个滑动条
    local begin_x = 40
    local top_y = 184
    local row_space = 75

    -- 三个左右尖端
    local bar_bg = CCZXImage:imageWithFile( begin_x+9, top_y+7, 297, 23, UILH_NORMAL.progress_bg, 500, 500 )   
    panel:addChild( bar_bg ) 
    bar_bg = CCZXImage:imageWithFile( begin_x+9, top_y+7-row_space, 297, 23, UILH_NORMAL.progress_bg, 500, 500 )   
    panel:addChild( bar_bg ) 
    bar_bg = CCZXImage:imageWithFile( begin_x+9, top_y+7-row_space*2, 297, 23, UILH_NORMAL.progress_bg, 500, 500 )   
    panel:addChild( bar_bg ) 

    -- Lang.set_system_info.SetOnHookPage.left_down_tip1="#cffff00生命"
    -- panel:addChild( UILabel:create_lable_2( Lang.set_system_info.SetOnHookPage.left_down_tip1, 22, 193, 16, ALIGN_LEFT ) )
    local function user_HP_bar_callback( current_value )
        SetSystemModel:set_one_date( SetSystemModel.ASSIST_HP_ITEM, current_value )
        if current_value then
            current_value = math.ceil( current_value )
            self.HP_percentage_lable:setString( current_value.."%" )
        end
    end

    self.user_HP_value_bar = MUtils:create_value_move_bar2( begin_x, top_y, UILH_NORMAL.progress_bar_red, 275+40, 12, UILH_NORMAL.slider, 40, 39, 100, user_HP_bar_callback )
    panel:addChild( self.user_HP_value_bar.view )
    
    self.HP_percentage_lable = UILabel:create_lable_2( "10%", 355, 196, 16, ALIGN_LEFT )
    panel:addChild( self.HP_percentage_lable )

    -- 文字：生命
    MUtils:create_zximg(self.user_HP_value_bar.view,UILH_SYSTEM_SETTING.text_shengming,7,42,-1,-1)   

    -- Lang.set_system_info.SetOnHookPage.left_down_tip2="#cffff00法力"
    -- panel:addChild( UILabel:create_lable_2( Lang.set_system_info.SetOnHookPage.left_down_tip2, 22, 118, 16, ALIGN_LEFT ) )

    local function user_MP_bar_callback( current_value )
        SetSystemModel:set_one_date( SetSystemModel.ASSIST_MP_ITEM, current_value )
        if current_value then
            current_value = math.ceil( current_value )
            self.MP_percentage_lable:setString( current_value.."%" )
        end
    end

    self.user_MP_value_bar = MUtils:create_value_move_bar2( begin_x, top_y-row_space, UILH_NORMAL.progress_bar_blue, 275+40, 12, UILH_NORMAL.slider, 40, 39, 100, user_MP_bar_callback )
    panel:addChild( self.user_MP_value_bar.view )
    
    self.MP_percentage_lable = UILabel:create_lable_2( "10%", 355, 121, 16, ALIGN_LEFT )
    panel:addChild( self.MP_percentage_lable )

    -- 文字：法力
    MUtils:create_zximg(self.user_MP_value_bar.view,UILH_SYSTEM_SETTING.text_fali,7,42,-1,-1)   

    -- Lang.set_system_info.SetOnHookPage.left_down_tip3="#cffff00通灵兽生命"
    -- panel:addChild(UILabel:create_lable_2(Lang.set_system_info.SetOnHookPage.left_down_tip3, 22, 43, 16,ALIGN_LEFT ))

    local function pet_HP_bar_callback( current_value )
        SetSystemModel:set_one_date( SetSystemModel.ASSIST_HP_ITEM_PET, current_value )
        if current_value then
            current_value = math.ceil( current_value )
            self.pet_HP_percentage_lable:setString( current_value.."%" )
        end
    end

    self.pet_HP_value_bar = MUtils:create_value_move_bar2( begin_x, top_y-row_space*2, UILH_NORMAL.progress_bar_green, 275+40, 12, UILH_NORMAL.slider, 40, 39, 100, pet_HP_bar_callback )
    panel:addChild( self.pet_HP_value_bar.view )
    
    self.pet_HP_percentage_lable = UILabel:create_lable_2( "10%", 355, 46, 16, ALIGN_LEFT )
    panel:addChild( self.pet_HP_percentage_lable )

    -- 文字：宠物生命
    MUtils:create_zximg(self.pet_HP_value_bar.view,UILH_SYSTEM_SETTING.text_chongwushengming,7,42,-1,-1) 
end

function SetOnHookPage:create_right_up_panel(x, y, width, height)
    -- body
    -- local panel = CCBasePanel:panelWithFile( x, y, width, height, UILH_COMMON.bg_grid,500, 500 )
    local panel = CCBasePanel:panelWithFile( x, y, width, height, nil,500, 500 )
    self.view:addChild( panel )

    -- 标题背景
    local title_bg = CCZXImage:imageWithFile( 5, height - 35 , width-10, 35, UILH_NORMAL.title_bg4, 500, 500 ) 
    panel:addChild(title_bg)
    -- 标题文字：#cffef00技能释放顺序说明
    local title_text = MUtils:create_zxfont(title_bg,Lang.set_system_info.SetOnHookPage.right_up_title,(width-10)/2,11,ALIGN_CENTER,16);

    -- Lang.set_system_info.SetOnHookPage.right_up_tip1="#cffff00拖动图标替换位置即可更换设置顺序"
    panel:addChild( UILabel:create_lable_2( Lang.set_system_info.SetOnHookPage.right_up_tip1,55,70,16, ALIGN_LEFT ) )
    
    -- Lang.set_system_info.SetOnHookPage.right_up_tip2="#cffff00勾选停止使用,则挂机时不使用该技能"
    panel:addChild( UILabel:create_lable_2( Lang.set_system_info.SetOnHookPage.right_up_tip2, 55, 30, 16, ALIGN_LEFT ) )
end

function SetOnHookPage:create_right_down_panel(x, y, width, height)
    -- body
    -- local panel = CCBasePanel:panelWithFile( x, y, width, height, UILH_COMMON.bg_grid,500, 500)
    local panel = CCBasePanel:panelWithFile( x, y, width, height, nil,500, 500)
    self.view:addChild( panel )

    -- 标题背景
    local title_bg = CCZXImage:imageWithFile( 5, height - 40 , width-10, 35, UILH_NORMAL.title_bg4, 500, 500 ) 
    panel:addChild(title_bg)
    -- 标题文字：#cffef00释放技能设置
    local title_text = MUtils:create_zxfont(title_bg,Lang.set_system_info.SetOnHookPage.right_down_title,(width-10)/2,11,ALIGN_CENTER,16);

    local x_ratio    -- x轴计算的系数
    local y_ratio    -- y轴计算的系数
    local skill_panel_w = 210
    local skill_panel_h = 147

    -- 获取已经学习的被动技能
    local skill_id_t = SetSystemModel:get_active_skill_had_learn()
    
    for i = 1, 4 do
        x_ratio = 1 - i % 2
        -- y轴计算的系数             
        y_ratio = 2 - math.ceil( i / 2 )
        self.skill_panel_t[i] = self:create_skill_panel( skill_panel_w * x_ratio+30, skill_panel_h * y_ratio+15, skill_panel_w, skill_panel_h, i, skill_id_t[i] )
        panel:addChild( self.skill_panel_t[i].view )
    end 
end

-- 创建一个选择控件
function SetOnHookPage:create_one_switch_but( x, y, w, h, image_n, image_s, words, words_x, words_y, fontsize, but_key )
    local function switch_button_func(  )
    	-- print("but_key::: ", but_key)
        self:config_change( but_key )
    end
    local switch_but = UIButton:create_switch_button2( x, y, w, h, image_n, image_s, words, words_x, words_y, fontsize, nil, nil, nil, nil, switch_button_func )
    switch_but.but_key = but_key
    return switch_but
end

-- 选项发生改变
function SetOnHookPage:config_change( but_key )
    local switch_but = self.select_item_t[ but_key ]
    local but_value  = switch_but.if_selected
    SetSystemModel:set_one_date( but_key, but_value )
end

-- 创建一个技能控制面板
function SetOnHookPage:create_skill_panel( x, y, w, h, index, skill_id )
	local skill_panel = {}
	skill_panel.skill_id = skill_id
	skill_panel.view = CCBasePanel:panelWithFile( x, y, w, h, "", 500, 500 )


--modified by zyz,old code
    -- local index_title = skill_index_title_t[ index ]
    -- skill_panel.view:addChild( UILabel:create_lable_2( "#cffff00"..index_title, 10, 80, 14, ALIGN_LEFT ) )        
--new code
           
    skill_panel.view:addChild( CCZXImage:imageWithFile( 5,120, -1, -1, 
                                                        UIResourcePath.FileLocate.lh_other .. "cn_number1_"..index .. ".png" ,
                                                        500,500) ) 


    local skill_slot = SlotSkill(72, 72)
    
    local po_x = 50
    local po_y = 55

    local bgPanel_2 = CCZXImage:imageWithFile( po_x - 12, po_y - 11, 96, 94, UILH_NORMAL.skill_bg_b);  --技能icon区域的背景
    skill_panel.view:addChild( bgPanel_2 )
    
    skill_slot:setPosition( po_x, po_y )
    skill_panel.view:addChild( skill_slot.view )
    -- 设置拖拽处理
    self:set_skill_drag_info( skill_slot, { id = skill_id } )

    -- Lang.set_system_info.SetOnHookPage.right_down_tip1="#cffff00停止使用"
    local content = Lang.set_system_info.SetOnHookPage.right_down_tip1
    local function switch_button_func( if_selected )
        local option_key = _skill_panel_switch_to_key_t[index]          -- 获取保存的key
        SetSystemModel:set_one_date( option_key, if_selected )          -- 保存
    end
    local switch_but = UIButton:create_switch_button2( 30, 0, 85, 33, UILH_COMMON.dg_sel_1, UILH_COMMON.dg_sel_2, content, 40, 13, 15, nil, nil, nil, nil, switch_button_func )
    skill_panel.view:addChild( switch_but.view )

    -- print("技能.....", skill_id)
    if skill_id then
    	skill_slot:set_icon( skill_id )
    end

    -- 外部调用的方法
    -- 更新技能图标
    skill_panel.update_skill_panel = function( skill_id )
        skill_panel.skill_id = skill_id
        if skill_id and skill_id ~= 0 then
            skill_slot:set_icon( skill_id )
            self:set_skill_drag_info( skill_slot, { id = skill_id } )
        else
            -- 设置为空
            skill_slot:set_icon_texture("")
            self:set_skill_drag_info( skill_slot, { id = 0 } )
        end
    end  

    -- 更新开关
    skill_panel.update_switch = function( if_selected )
        switch_but.set_state( if_selected )
    end
    
    
    return skill_panel
end

-- 设置 技能 的拖动支持
function SetOnHookPage:set_skill_drag_info( slot_skill, skill)
    -- print("!!!  SkillItem:set_skill_drag_info !!! ",skill_player)
    if not skill or not skill.id or skill.id == 0 then
        return
    end
    
    slot_skill:set_drag_info( 2, "set_system_win", skill)
    local function drag_out( self_item )
        -- print(" 技能 ， 拖动 drag_out  ",skill.id)
    end
    local function drag_in( source_item )
        self:change_skill_panel( source_item.obj_data.id, skill.id, true )
    end
    local function drag_callback( target_win )
        -- print("技能 ， 拖入成功！",skill.id)
    end
    local function drag_invalid_callback(drag_object )
        -- print("背包 ， 拖入非法区域！",skill.id)
        -- drag_object:set_icon_texture(ItemConfig:get_item_icon(drag_object.obj_data.item_id));
    end 
    local function discard_item_callback( drag_object )
        -- print("背包 ， 拖入空地！",skill.id)
    end
    slot_skill:set_drag_out_event( drag_out )
    slot_skill:set_drag_in_event( drag_in )
    slot_skill:set_drag_in_callback( drag_callback )
    slot_skill:set_drag_invalid_callback(drag_invalid_callback);
    slot_skill:set_discard_item_callback(discard_item_callback);
end

-- 交换两个技能  参数：第一个技能的id， 第二个技能的id, 设置完后是否保存（有设置是从model同步的，就不用再保存一次了）
function SetOnHookPage:change_skill_panel( skill_id_out, skill_id_in, if_save )
	if skill_id_out == nil or skill_id_in == nil then
        return 
	end
	_skill_id_change_out = skill_id_out
	_skill_id_change_out  = skill_id_in

    -- 遍历所有面板，更新
    for i = 1, #self.skill_panel_t do
    	-- 更新 拖出 的面板    上面是按序号遍历的，所以不会导致多次读取同一个面板,设置技能值
        -- print("遍历所有面板，更新。。。。。。。。。。。", skill_id_out, skill_id_in, self.skill_panel_t[i].skill_id )
        if self.skill_panel_t[i].skill_id == skill_id_out then
            self.skill_panel_t[i].update_skill_panel( skill_id_in )               -- 把源 skill 设置成终点 skill
            if if_save then
                SetOnHookPage:save_skill_panel( i, skill_id_in )
            end
        -- 更新 拖入 的面板
        elseif self.skill_panel_t[i].skill_id == skill_id_in then
        	self.skill_panel_t[i].update_skill_panel( skill_id_out )              -- 把终点skill设置成源skill
            SetOnHookPage:save_skill_panel( i, skill_id_out )
            if if_save then
                SetOnHookPage:save_skill_panel( i, skill_id_out )
            end
        end
    end
end

-- 保存技能的数据
function SetOnHookPage:save_skill_panel( panel_index, skill_id )
    local option_key = _skill_panel_index_to_key_t[ panel_index ]
    SetSystemModel:set_one_date( option_key, skill_id )
end

-- 更新所有选择按钮
function SetOnHookPage:update_all_but(  )
    for key, switch_but in pairs(self.select_item_t) do 
        local value = SetSystemModel:get_date_value_by_key( key )
        switch_but.set_state( value )
    end
end

-- 更新滑动条
function SetOnHookPage:update_move_bar(  )
    -- 人物生命 
    local user_HP_value = SetSystemModel:get_date_value_by_key( SetSystemModel.ASSIST_HP_ITEM )
    -- print("人物生命。。。。。", user_HP_value)
    self.user_HP_value_bar.set_current_value( user_HP_value )
    user_HP_value = math.ceil( user_HP_value )
    self.HP_percentage_lable:setString( user_HP_value.."%" )
    -- print("SetOnHookPage:update_move_bar ...  ", user_HP_value )

    -- 人物法力
    local user_MP_value = SetSystemModel:get_date_value_by_key( SetSystemModel.ASSIST_MP_ITEM )
    self.user_MP_value_bar.set_current_value( user_MP_value )
    user_MP_value = math.ceil( user_MP_value )
    self.MP_percentage_lable:setString( user_MP_value.."%" )

    -- 宠物生命
    local pet_HP_value = SetSystemModel:get_date_value_by_key( SetSystemModel.ASSIST_HP_ITEM_PET )
    self.pet_HP_value_bar.set_current_value( pet_HP_value )
    pet_HP_value = math.ceil( pet_HP_value )
    self.pet_HP_percentage_lable:setString( pet_HP_value.."%" )
end

-- 更新技能面板
function SetOnHookPage:update_all_skill_panel(  )
    local option_key 
    local value
    local skill_id
    for i = 1, #_skill_panel_index_to_key_t do
        -- 技能图标刷新
        option_key = _skill_panel_index_to_key_t[i]
        skill_id = SetSystemModel:get_date_value_by_key( option_key )
        if skill_id ~= 0 and skill_id ~= nil then
            local panel_skill_id = self.skill_panel_t[i].skill_id
            -- print("~~~~~~!!!SetOnHookPage:update_all_skill_panel!!!~~~~~~", i, skill_id, panel_skill_id )
            -- 与当前的面板不一样，和另一个一样的面板交换
            if panel_skill_id ~= skill_id then
                -- self:change_skill_panel( panel_skill_id, skill_id, false )
                self.skill_panel_t[i].update_skill_panel( skill_id ) 
            end
        end

        -- 开关刷新
        option_key = _skill_panel_switch_to_key_t[i]
        value =  SetSystemModel:get_date_value_by_key( option_key )
        self.skill_panel_t[i].update_switch( value )
    end
end

-- 更新数据
function SetOnHookPage:update( update_type )
    if update_type == "set_date" then
        self:update_all_but(  )
        self:update_move_bar(  )
        self:update_all_skill_panel(  )
    elseif update_type == "set_skill_id" then
        self:update_all_skill_panel(  )
    elseif update_type == "all" then
        self:update_all_but(  )
        self:update_move_bar(  )
        self:update_all_skill_panel(  )
        UserSkillModel:init_can_use_skill()
    else
        -- self.current_panel:update( update_type )
    end
end
