-- UserSkillWin.lua
-- created by lyl on 2012-12-3
-- 角色技能窗口

require "UI/component/Window"
super_class.UserSkillWin(NormalStyleWindow)

require "config/SkillConfig"
require "model/UserSkillModel"

-- 6个技能槽
local jn_label1 = nil
local jn_label2 = nil
local jn_label3 = nil
local jn_label4 = nil
local jn_label5 = nil
local jn_label6 = nil

local skill_id_for_test = nil

-- ui params
local win_w = 900
local win_h = 605
local align_x = 10
local align_y = 10
local radio_b_w = 101 -- 从ui获取的尺寸,radiobtn
local radio_b_h = 44
local panel_h_b = win_h-40
local panel_w = 900-align_x*2
local panel_h = panel_h_b-radio_b_h


--打印出技能model的数据。测试用
local function print_all_skile( )
    local skill_date = UserSkillModel:get_skill_list()
    for i,v in pairs(skill_date) do
        -- print("~~~~~~~~~~~~~~~~", i, v.id, v.level, v.secret_id ,v.cd ,v.exp ,v.dead_time ,v.ifStop)
    end
end

function UserSkillWin:__init( window_name, texture_name )

    --主背景
    -- local bgPanel = self.view 
    -- local panel = CCBasePanel:panelWithFile( align_x, align_y, panel_w, panel_h_b, UIPIC_SKILL.MAIN_BG_001, 500, 500);  --方形区域
    -- bgPanel:addChild( panel )

    -- 主要是分页面板，添加分页界面
    local bg = ZBasePanel.new(nil, panel_w, panel_h)
    bg:setPosition(align_x, align_y)
    self:addChild(bg)
    self.pageBg = bg

    -- 创建分页button -- 技能，心法，秘籍
    self.radio_btn_group = CCRadioButtonGroup:buttonGroupWithFile( 20, panel_h+align_y-8, radio_b_w*3, radio_b_h, "" )
    self:addChild(self.radio_btn_group)

    -- 技能
    self.jineng_button = CCRadioButton:radioButtonWithFile(0, 0, -1, -1, 
        UILH_COMMON.tab_gray)
    self.jineng_button:addTexWithFile( CLICK_STATE_DOWN,
        UILH_COMMON.tab_light)
    local jineng_txt = UILabel:create_lable_2( "技 能", radio_b_w/2, 10, font_size, ALIGN_CENTER)
    self.jineng_button:addChild(jineng_txt)
    self.radio_btn_group:addGroup(self.jineng_button)
    local function but_jineng_fun(eventType,x,y)
        if eventType ==  TOUCH_BEGAN then 
            return true
        elseif eventType == TOUCH_CLICK then
            self:change_page( UserSkillModel.JI_NENG )
            return true;
        elseif eventType == TOUCH_ENDED then
            return true;
        end
    end
    self.jineng_button:registerScriptHandler(but_jineng_fun)

    -- 秘籍
    self.miji_button = CCRadioButton:radioButtonWithFile( radio_b_w, 0, -1, -1, 
        UILH_COMMON.tab_gray)
    self.miji_button:addTexWithFile( CLICK_STATE_DOWN,
        UILH_COMMON.tab_light)

    local miji_txt = UILabel:create_lable_2( "秘 籍", radio_b_w/2, 10, font_size, ALIGN_CENTER)
    self.miji_button:addChild(miji_txt)
    self.radio_btn_group:addGroup(self.miji_button)
    local function but_miji_fun(eventType,x,y)
        if eventType ==  TOUCH_BEGAN then 
            --根据序列号来调用方法
            return true
        elseif eventType == TOUCH_CLICK then
            if not GameSysModel:isSysEnabled( GameSysModel.MIJI ,true) then
                self.radio_btn_group:selectItem( 0 )
                return
            end
            self:change_page( UserSkillModel.MI_JI )
            return true;
        elseif eventType == TOUCH_ENDED then
            return true;
        end
    end
    self.miji_button:registerScriptHandler(but_miji_fun)
    -- self.miji_button:setIsVisible(false)

    -- 心法
    self.xinfa_button = CCRadioButton:radioButtonWithFile( radio_b_w*2, 0, -1, -1, 
    	UILH_COMMON.tab_gray)
    self.xinfa_button:addTexWithFile( CLICK_STATE_DOWN,
        UILH_COMMON.tab_light)

    local xinfa_txt = UILabel:create_lable_2( "心 法", radio_b_w/2, 10, font_size, ALIGN_CENTER)
    self.xinfa_button:addChild(xinfa_txt)
    self.radio_btn_group:addGroup(self.xinfa_button)
    local function but_xinfa_fun(eventType,x,y)
        if eventType ==  TOUCH_BEGAN then 
            --根据序列号来调用方法
            return true
        elseif eventType == TOUCH_CLICK then
            self:change_page( UserSkillModel.XIN_FA )
            return true;
        elseif eventType == TOUCH_ENDED then
            return true;
        end
    end
    self.xinfa_button:registerScriptHandler(but_xinfa_fun)
    self.xinfa_button:setIsVisible(false)

    -- 记录每页，控制显示与隐藏
    self.page_list = {}

    self.skill_table  = {}       --存放创建的item。为了方便动态修改内容，找到item
end

--切页
function UserSkillWin:change_page( page_index )
    if self.page_list[page_index] == self.current_page then
        return
    end

    UserSkillModel:set_current_page( page_index )
    for k,v in pairs(self.page_list) do
        v.view:setIsVisible(false)
    end

    if page_index == UserSkillModel.JI_NENG then
        if self.page_list[page_index] then
            self.SkillJiNeng.view:setIsVisible( true )
        else
            self.SkillJiNeng = UserJiNengPage()
            self.SkillJiNeng.view:setPosition(0, 0)
            self.pageBg:addChild(self.SkillJiNeng.view)
            self.page_list[page_index] = self.SkillJiNeng
        end
        self.current_page = self.page_list[page_index]
        --TransformModel:change_right_win( UserSkillModel.JI_NENG )

    elseif page_index == UserSkillModel.MI_JI then
        if self.page_list[page_index] then
            self.SkillMiJi.view:setIsVisible( true )
        else
            self.SkillMiJi = SkillMijiPage()
            self.SkillMiJi.view:setPosition(0, 0)
            self.pageBg:addChild(self.SkillMiJi.view)
            self.page_list[page_index] = self.SkillMiJi

            -- 创建页面后，先设置默认的技能id
            local job_skill_t = UserSkillModel:get_player_skills()   
            SkillMiJiModel:miji_click_cb_func( job_skill_t[1].id )
            -- 最后再申请秘籍信息
            SkillMiJiCC:req_miji_info(  )
        end
        self.current_page = self.page_list[page_index]

    elseif page_index == UserSkillModel.XIN_FA then
        -- if self.page_list[page_index] then
        --     self.SkillXinFa.view:setIsVisible( true )
        -- else
        --     self.SkillXinFa = UserJiNengPage()
        --     self.SkillXinFa.view:setPosition(0, 0)
        --     self.pageBg:addChild(self.SkillXinFa.view)
        --     self.page_list[page_index] = self.SkillXinFa
        -- end
        self.current_page = self.page_list[page_index]
        --TransformModel:change_right_win( TransformModel.AO_YI )
    end

    if self.current_page and self.current_page.update then
        self.current_page:update("all")
    end
end

--
function UserSkillWin:create( texture_name )
	return UserSkillWin( texture_name, 10, 46, 389, 429);
end

-- 显示升级结果
function UserSkillWin:show_result( result, msg )
    -- self.result_lable = UILabel:create_label_1( "升级", CCSize(100,20), 50, 56, 12,  CCTextAlignmentLeft, 255, 255, 0)
end

-- 更新技能窗口（供外部调用）
function UserSkillWin:update_skill_win(  )
    require "UI/UIManager"
    UIManager:find_visible_window( "user_skill_win" )
    local win = UIManager:find_visible_window( "user_skill_win" )
    if win ~= nil then
        win:update( "" )
        win:update_page( )
    end
end

function UserSkillWin:update_page(  )
    if UserSkillModel:get_current_page() == UserSkillModel.JI_NENG then
        self.SkillJiNeng:update_skill_win()
    end
end

-- 更新数据： 参数：更新的类型
function UserSkillWin:update( update_type )
    self:syn_skill_date(  )
end

function UserSkillWin:get_page(page_index)
    if page_index == UserSkillModel.MI_JI then
        return self.SkillMiJi;
    end
end

-- 重新同步技能数据
function UserSkillWin:syn_skill_date(  )
    for i, slot_skill in ipairs(self.skill_table) do
        slot_skill:update()
    end
end

function UserSkillWin:active( show )

    -- -- 新手指引代码
    -- if ( show ) then
    --     if ( XSZYManager:get_state() == XSZYConfig.JINENG_ZY ) then 
    --         -- 解除锁定屏幕
    --         -- XSZYManager:unlock_screen(  )
    --         -- 指向一键升级按钮 20 , 22, 120, 40
    --         XSZYManager:play_jt_and_kuang_animation_by_id( XSZYConfig.JINENG_ZY,1 , XSZYConfig.OTHER_SELECT_TAG );
    --     end
    --      -- 主界面技能栏显示
    --     local win = UIManager:find_visible_window("menus_panel");
    --     if ( win ) then
    --         win:show_or_hide_skill_panel(true);
    --     end
    -- else
    --     -- 主界面技能栏隐藏
    --     local win = UIManager:find_visible_window("menus_panel");
    --     if ( win ) then
    --         win:show_or_hide_skill_panel(false);
    --     end
    --     if ( XSZYManager:get_state() == XSZYConfig.JINENG_ZY ) then 
    --         -- 继续做任务
    --         AIManager:do_quest(XSZYManager:get_data(),1);
    --         XSZYManager:destroy( XSZYConfig.OTHER_SELECT_TAG );
    --         XSZYManager:destroy_drag_out_animation()
    --         -- 菜单栏隐藏
    --         local win = UIManager:find_window("menus_panel");
    --         win:show_or_hide_panel(false);
    --     end
    -- end

    if show == false then
        Instruction:continue_next()
    else
        self:update("")
        self:on_win_active( show );
        self.current_page = {}
        self:change_page( UserSkillModel.JI_NENG )
    end
    -- UserSkillModel:init_skill_key()
end

-- modify by hcl on 2013/11/20
-- 当技能栏打开时，自动切换为技能栏，关闭时自动切换为菜单栏
function UserSkillWin:on_win_active( show )
    if show then 
        local win = UIManager:find_visible_window( "menus_panel" )
        if win then
            win:show_or_hide_panel( not show )
        end
    end
end

function UserSkillWin:destroy()
    if Instruction:get_is_instruct(  ) then
        Instruction:destroy_drag_out_animation()
    end
    Instruction:continue_next()

    -- 窗口关闭前，先重置model层数据
    SkillMiJiModel:is_closing_window()

    -- 分页destroy
    for i=1, #self.page_list do
        if self.page_list[i] then
            self.page_list[i]:destroy()
        end
    end

    Window.destroy(self)
end

function UserSkillWin:set_btn_skill_by_index(index,skill_id)
    self.SkillJiNeng:set_btn_skill_by_index(index,skill_id)
end

-- 外部请求切换分页
function UserSkillWin:selected_tab_button(page_index)
    self.radio_btn_group:selectItem(page_index-1)
    self:change_page(page_index)
end