-- UserJiNengPage.lua 
-- createed by chj on 2014-7-22
-- 变身图鉴

super_class.UserJiNengPage(  )
require "config/SkillConfig"

--当前技能
_cur_skill = nil

-- 技能名称 &&  等级
local jn_name = nil
local jn_level = nil

--字体大小
local font_size_1 = 16

-- 6个技能槽
local jn_label1 = nil
local jn_label2 = nil
local jn_label3 = nil
local jn_label4 = nil
local jn_label5 = nil
local jn_label6 = nil

-- 升级需求 -- just_mark
local need_money_txt = LH_COLOR[2] .. Lang.skill_info.need_money_txt .. LH_COLOR[15]   --"#cffff00需要银两："
local need_exp_txt = LH_COLOR[2] .. Lang.skill_info.need_exp_txt .. LH_COLOR[15]  --"#cffff00需要经验："    
local need_lv_txt = LH_COLOR[2] .. Lang.skill_info.need_lv_txt .. LH_COLOR[15]  --"#cffff00需要等级："

-- 技能相关
local tab_skill_id = {};
local NORMAL_SKILLS_NUM = 4
local MAX_NORMAL_SKILLS = 5
local SKILL_BG = UILH_NORMAL.skill_bg1
local SKILL_SLOT_SIZE = { 60, 60 }
local SKILL_SLOT_WINTH = 65

-- 控件坐标
local win_w = 900
local win_h = 605
local align_x = 10
local panel_interval = 15
local radio_b_w = 101 -- 从ui获取的尺寸,radiobtn
local radio_b_h = 44
local panel_h_b = win_h-40
local panel_w = 900-align_x*2
local panel_h = panel_h_b-radio_b_h

local panel_up_height = 410
local panel_down_height = panel_h - panel_up_height-panel_interval
local panel_half_width = ( panel_w-panel_interval*2) / 2


function UserJiNengPage:__init( )
    self.items_dict = {}

    self.skill_table  = {}       --存放创建的item。为了方便动态修改内容，找到item

    -- 900 x 555 (800, 600) (100, 45)
    -- 底板
    self.view = ZBasePanel.new(UILH_COMMON.normal_bg_v2, panel_w, panel_h).view
    local panel = self.view

    --背景 ui
    -- ZBasePanel:create(panel, UIPIC_GRID_nine_grid_bg3, 0, 0, panel_width, panel_height, 500, 500)
    --ZBasePanel:create(panel, "", 10, 10, 680-20, 530-20, 500, 500) 


    ZBasePanel:create(panel, UILH_COMMON.bottom_bg, panel_interval, panel_down_height+15, panel_half_width, panel_up_height-10, 500, 500) 
    ZBasePanel:create(panel, UILH_COMMON.bottom_bg, panel_half_width+panel_interval, panel_down_height+15, panel_half_width, panel_up_height-10, 500, 500) 
    -- ZBasePanel:create(panel, UILH_COMMON.bottom_bg, panel_interval, panel_interval, panel_w-panel_interval*2, panel_down_height, 500, 500) 

    -- 添加技能面板
    self:create_jineng_panel( panel )

    -- 添加 底部部分 一键升级 按钮
    self:create_bottom_panel( panel )

    -- 添加底部4个技能位置
    self:create_skill_place( panel )
end

function UserJiNengPage:create_jineng_panel( panel )

    -- 计算坐标的变量 ----------------------
    local item_size_w = 96
    local item_size_h = 94
    local item_left_x = panel_half_width*0.2+panel_interval
    local item_right_x = panel_half_width*0.6+panel_interval
    local item_basic_y = panel_down_height + panel_interval*2

    -- 左面板 背景图------------------------------------------------
    local bg_left = CCZXImage:imageWithFile( 19, 116, -1, -1, UILH_SKILL.btm_texture); 
    panel:addChild( bg_left )
    local bg_right = CCZXImage:imageWithFile( 439, 116, -1, -1, UILH_SKILL.btm_texture);
    bg_right:setScaleX( -1 ) 
    panel:addChild( bg_right )

    -- 左面板 加入技能item ------------------------------------------------------------
    self.job_skill_t = UserSkillModel:get_player_skills()        -- 角色的职业对应的所有技能表
    self.player_skill_date = UserSkillModel:get_skill_list()     -- 角色已学的技能列表

    require "UI/userSkillWin/SkillItem"
    local slot_panel_h = panel_up_height-20
    local skill_pos_t = {
        { item_left_x, slot_panel_h*0.7 + item_basic_y}, 
        { item_right_x, slot_panel_h*0.7 + item_basic_y },
        { item_right_x, slot_panel_h*0.37 + item_basic_y },
        { item_left_x, slot_panel_h*0.37 + item_basic_y },
        { item_left_x, slot_panel_h*0.02+ item_basic_y },
        { item_right_x, slot_panel_h*0.02 + item_basic_y },
    }

    local skill_date = self.player_skill_date     --获取技能列表
    local _isSkillEnable = SkillConfig.isSkillEnable
    -- 根据角色得到角色能学习的技能静态数据，最多八种技能，已学习的和未学习的技能显示不一样。这里还没有静态数据，暂时不弄
    local show_skill_count = 1          -- 中间有技能过滤掉了，计算坐标不能再用i，要分开来计数
    for i=1,6 do
        -- 手机版不用 1 ， 5 技能，配置文件还是原来的技能，在这里过滤
        if _isSkillEnable(i) then

            local item_x = skill_pos_t[i][1]
            local item_y = skill_pos_t[i][2]
          
            -- 还未学习的技能
            local skill_base = SkillConfig:get_skill_by_id( self.job_skill_t[i].id )  -- 技能的静态数据
            -- print("-------------:", i, self.job_skill_t[i].id)
            local skill_item = SkillItem(panel, item_x, item_y, item_size_w, item_size_h, skill_base )
            
            -- 记录窗口
            skill_item.skillWin = self

            self.skill_table[ #self.skill_table + 1 ] = skill_item             --把item存入table，为动态修改服务器同步的数据使用
            show_skill_count = show_skill_count + 1
        end
    end 

    -- 左面板 加入技能item 箭头 -----------------------------------------
    local arrows_pos = {
        { panel_half_width*0.47+10, item_basic_y + panel_up_height*0.7 +18},
        { item_right_x +48-16,   item_basic_y + panel_up_height*0.37 +80 },
        { panel_half_width*0.47+10, item_basic_y + panel_up_height*0.37 +25 },
        { item_left_x +48-16,    item_basic_y + panel_up_height*0.37 -55 },
        { panel_half_width*0.47+10, item_basic_y + panel_up_height*0.02 +32 },
    }
    for i=1, 5 do
        local img_arrows = nil
        if i == 2 or i == 4 then
            img_arrows = CCZXImage:imageWithFile( arrows_pos[i][1], arrows_pos[i][2], -1, -1, UILH_COMMON.down_arrows); 
        else
            img_arrows = CCZXImage:imageWithFile( arrows_pos[i][1], arrows_pos[i][2], -1, -1, UILH_COMMON.right_arrows);  
            if i == 3 then
                img_arrows:setFlipX(true)
            end
        end
        panel:addChild( img_arrows )
    end


    -- params -------------------------------------------------------
    local basic_x = panel_half_width + panel_interval*2 + 10
    local right_interval = 155
    local change_y = 33
    -- 技能名字 ------------------------------------------------------------
    jn_name = UILabel:create_lable_2( LH_COLOR[5] .. Lang.skill_info.skill_name, basic_x , panel_h -40, font_size_1,  ALIGN_LEFT) 
    panel:addChild( jn_name )   -- "技能名字: "

    jn_level = UILabel:create_lable_2( LH_COLOR[2] .. Lang.skill_info.skill_level, basic_x + right_interval , panel_h -40, font_size_1,  ALIGN_LEFT) 
    panel:addChild( jn_level )   -- "技能层数"

    -- 技能参数 ------------------------------------------------------------
    jn_label1 = UILabel:create_lable_2( LH_COLOR[2] .. Lang.skill_info.jn_label1, basic_x , panel_h -75, font_size_1,  ALIGN_LEFT )
    panel:addChild( jn_label1 )   -- ="#c0edc09技能范围:#cffffff "

    jn_label2 = UILabel:create_lable_2( LH_COLOR[2] .. Lang.skill_info.jn_label2, basic_x + right_interval , panel_h -75, font_size_1,  ALIGN_LEFT )
    panel:addChild( jn_label2 )  -- ="#c0edc09施法距离: #cffffff", 

    jn_label3 = UILabel:create_lable_2( LH_COLOR[2] .. Lang.skill_info.jn_label3, basic_x , panel_h -105, font_size_1,  ALIGN_LEFT )
    panel:addChild( jn_label3 )    --="#c0edc09耐力消耗: #cffffff", 

    jn_label4 = UILabel:create_lable_2( LH_COLOR[2] .. Lang.skill_info.jn_label4, basic_x + right_interval , panel_h -105, font_size_1,  ALIGN_LEFT)
    panel:addChild( jn_label4 )  -- ="#c0edc09冷却时间: #cffffff", 

    -- 技能由来 ------------------------------------------------------------
    -- self.skill_desc = CCDialogEx:dialogWithFile(basic_x, panel_h -120, panel_half_width-20, 80, 10, "", TYPE_VERTICAL ,ADD_LIST_DIR_UP);
    -- self.skill_desc:setAnchorPoint(0,1);
    -- self.skill_desc:setFontSize(font_size_1);
    -- self.skill_desc:setText( Lang.skill_info.skill_from );   --"技能由来" --预留
    -- self.skill_desc:setTag(0)
    -- panel:addChild(self.skill_desc)

    -- 技能描述 ------------------------------------------------------------
    self.skill_desc = CCDialogEx:dialogWithFile(basic_x, panel_h -113, panel_half_width-35, 80, 10, "", TYPE_VERTICAL ,ADD_LIST_DIR_UP);
    self.skill_desc:setAnchorPoint(0,1);
    self.skill_desc:setFontSize(font_size_1);
    self.skill_desc:setText( LH_COLOR[2] .. Lang.skill_info.skill_desc .. LH_COLOR[15] );  -- "#cffff00当前效果:#cffffff:"
    self.skill_desc:setTag(0)
    self.skill_desc:setLineEmptySpace (5)
    panel:addChild(self.skill_desc)

    -- 下一级技能描述 ------------------------------------------------------------
    self.skill_desc_next = CCDialogEx:dialogWithFile(basic_x, panel_h -195, panel_half_width-35, 25, 10, "", TYPE_VERTICAL ,ADD_LIST_DIR_UP);
    self.skill_desc_next:setAnchorPoint(0,1);
    self.skill_desc_next:setFontSize(font_size_1);
    self.skill_desc_next:setText( LH_COLOR[2] .. Lang.skill_info.skill_next_desc .. LH_COLOR[15]  );  -- "#cffff00下一级效果:#cffffff"
    self.skill_desc_next:setTag(0)
    self.skill_desc_next:setLineEmptySpace (5)
    panel:addChild(self.skill_desc_next)

    -- 添加title ------------------------------
    local title_w = 424
    local title_panel = CCBasePanel:panelWithFile( basic_x-13, panel_h -320, title_w, -1, UILH_NORMAL.title_bg4, 500, 500 )
    panel:addChild( title_panel )
    local title_label = UILabel:create_lable_2( LH_COLOR[1] .. Lang.skill_info.update_condition, title_w*0.5, 10, 18, ALIGN_CENTER )
    title_panel:addChild( title_label )

    -- 升级条件(需求)------------------------------------------------------------
    local need_exp = 0
    local need_money = 0
    local need_lv = 1
-- 升级条件标题
        -- UILabel:create_lable_2( LangGameString[541], title_x, title_y, 16, ALIGN_CENTER ) -- [541]="#cffff00活跃目标"
    -- self.need_title = UILabel:create_lable_2( Lang.skill_info.update_condition, basic_x, 155+30, font_size_1, ALIGN_LEFT)  --"升级需求"
    -- panel:addChild( self.need_title )
    -- 需要钱
    self.need_money = UILabel:create_lable_2( need_money_txt .. need_money, basic_x, 180, font_size_1, ALIGN_LEFT)
    panel:addChild( self.need_money )
    -- 需要等级 
    self.need_lv = UILabel:create_lable_2( need_lv_txt .. need_lv, basic_x, 152, font_size_1, ALIGN_LEFT)
    panel:addChild(self.need_lv)
    -- 需要经验
    self.need_exp = UILabel:create_lable_2( need_exp_txt .. need_exp, basic_x, 125, font_size_1, ALIGN_LEFT)
    panel:addChild( self.need_exp )

    -- 升级按钮 ------------------------------------------------------------------
    local upgra_btn = CCNGBtnMulTex:buttonWithFile(basic_x + 280, 125, -1, -1, UILH_COMMON.lh_button2, 500, 500)
    upgra_btn:addTexWithFile(CLICK_STATE_DOWN, UILH_COMMON.lh_button2_s)
    upgra_btn:addTexWithFile(CLICK_STATE_DISABLE, UILH_COMMON.lh_button2_disable)
    local count = 1
    local function upgra_btn_fun(eventType,x,y)
        if eventType == TOUCH_CLICK then
            -- print("userSkillWin-----------------study_or_upgrade_a_skill")
            UserSkillModel:study_or_upgrade_a_skill( _cur_skill.skill_id )
            Instruction:handleUIComponentClick(instruct_comps.USER_SKILL_LEARN)
            return true
        end
        return true
    end
    upgra_btn:registerScriptHandler(upgra_btn_fun)  --注册
    panel:addChild(upgra_btn)
    self.upgra_btn = upgra_btn
    -- self:check_a_key_to_upgrade_but()

    self.upgra_label = MUtils:create_zxfont( upgra_btn, LH_COLOR[2] .. Lang.skill_info.btn_level_up, 95/2, 21, 2, font_size_1 )  --
end


-- 添加底部控件 按钮
function UserJiNengPage:create_bottom_panel( panel )

    self.jineng_tip = CCDialogEx:dialogWithFile(15, 97, 165, 25, 10, "", TYPE_VERTICAL ,ADD_LIST_DIR_UP);
    self.jineng_tip:setAnchorPoint(0,1);
    self.jineng_tip:setFontSize(font_size_1);
    self.jineng_tip:setTag(0)
    self.jineng_tip:setLineEmptySpace (10)
    self.jineng_tip:setText( LH_COLOR[2] .. Lang.skill_info.bottom_tip_txt );  -- "#cffff00下一级效果:#cffffff"
    panel:addChild(self.jineng_tip)

    -- 一键升级 消耗
    local basic_need_x = 540
    local jineng_need_exp_all = UILabel:create_lable_2( LH_COLOR[2] .. Lang.skill_info.need_all_exp, basic_need_x, 67, font_size_1, ALIGN_LEFT )  --just_mark
    panel:addChild( jineng_need_exp_all )
    local upd_all_need_exp = self:get_upgr_need_exp()
    self.need_exp_all_value = UILabel:create_lable_2( LH_COLOR[15] .. upd_all_need_exp, basic_need_x+110, 67, font_size_1, ALIGN_LEFT )
    panel:addChild( self.need_exp_all_value )
    local jineng_need_money_all = UILabel:create_lable_2( LH_COLOR[2] .. Lang.skill_info.need_all_money, basic_need_x, 38, font_size_1, ALIGN_LEFT )
    panel:addChild( jineng_need_money_all )
    local upd_all_need_money = self:get_upgr_need_total_money()
    self.need_money_all_value = UILabel:create_lable_2( LH_COLOR[15] .. upd_all_need_money, basic_need_x+110, 38, font_size_1, ALIGN_LEFT )
    panel:addChild( self.need_money_all_value )

    ---------------------------------
    local but_upgrade = CCNGBtnMulTex:buttonWithFile(740, 30, -1, -1, UILH_COMMON.btn4_nor, 500, 500)
    but_upgrade:addTexWithFile(CLICK_STATE_DOWN, UILH_COMMON.lh_button2_s)
    --btn_hui2
    but_upgrade:addTexWithFile(CLICK_STATE_DISABLE, UILH_COMMON.lh_button2_disable)
    local count = 1
    local function but_upgrade_fun(eventType,x,y)
        if eventType == TOUCH_CLICK then
            UserSkillModel:do_a_key_to_upgrade(  )
            Instruction:handleUIComponentClick(instruct_comps.USER_SKILL_LEARNALL)
            return true
        end
        return true
    end
    but_upgrade:registerScriptHandler(but_upgrade_fun)  --注册
    panel:addChild(but_upgrade)
    self.but_upgrade = but_upgrade
    self:check_a_key_to_upgrade_but()

    MUtils:create_zxfont(but_upgrade, LH_COLOR[2] .. Lang.skill_info.update_once, 121/2, 21, 2, font_size_1)  --"一键升级"
end

-- 创建4个技能位置
function UserJiNengPage:create_skill_place( panel )
    self.tab_skill_slot = {};
    self.skill_panel = ZBasePanel:create( self, nil, 100, 0, 300, 100);
    -- self.skill_panel.view:setAnchorPoint( 1, 0 )
    self.skill_panel.view:unregisterScriptHandler();
    local skill_pos_t = UserSkillModel:get_skill_pos_t()
    for i=1,4 do
        local item_x = skill_pos_t[i][1]
        local item_y = skill_pos_t[i][2]

        self.tab_skill_slot[i] = SlotSkill(SKILL_SLOT_SIZE[1], SKILL_SLOT_SIZE[2])
        self.tab_skill_slot[i]:setPosition( item_x, item_y )
        --skill_item:setPosition( tab_skill_pos[i], tab_skill_pos[i] )
        local spr_bg = ZCCSprite:create(self.tab_skill_slot[i].view,SKILL_BG,30,29,-1);

        local function drag_in( source_item )
            if Instruction:get_is_instruct(  ) then
                Instruction:destroy_drag_out_animation()
            end
            local source_skill = UserSkillModel:get_a_skill_by_id( source_item.obj_data.id )
            -- print("--------------source_skill:", source_item.obj_data.id, source_skill.cd)
            if not self.tab_skill_slot[i]:get_icon_id() then
                if source_skill.cd == 0 then
                    self.tab_skill_slot[i]:set_drag_info(1, "user_skill_win", source_item.obj_data);
                    self.tab_skill_slot[i]:set_icon(source_item.obj_data.id);
                    tab_skill_id[i] = source_item.obj_data.id;
                    -- 检查是否已经存在
                    self:check_is_exist( source_item.obj_data.id ,i );
                    -- -- 通知服务器保存这个快捷键
                    KeySettingCC:req_set_a_key( i,source_item.obj_data.id,1 );
                else
                    GlobalFunc:create_screen_notic( "技能cd中不可拖动" ); 
                end
            else

                
                local here_skill = UserSkillModel:get_a_skill_by_id( self.tab_skill_slot[i]:get_icon_id() )
                -- local here_skill = UserSkillModel:get_a_skill_by_id(4)
                if source_skill.cd == 0 and here_skill.cd == 0 then
                    if (source_item.type == 2) then
                        -- 检查是否已经存在
                        self:check_is_exist( source_item.obj_data.id , i, self.tab_skill_slot[i]:get_icon_id() );
                        -- 设置快捷键
                        self.tab_skill_slot[i]:set_drag_info(1, "user_skill_win", source_item.obj_data);
                        self.tab_skill_slot[i]:set_icon(source_item.obj_data.id);
                        tab_skill_id[i] = source_item.obj_data.id;
                        
                        -- -- 通知服务器保存这个快捷键
                        KeySettingCC:req_set_a_key( i,source_item.obj_data.id,1 );
                    end
                else
                    GlobalFunc:create_screen_notic( "技能cd中不可拖动" ); -- [1448]="技能cd中!"
                end
            end
        end

        self.tab_skill_slot[i]:set_drag_in_event( drag_in )
        self.tab_skill_slot[i]:set_enable_drag_out(false);
        -- self.tab_skill_slot[i]:setCurState( CLICK_STATE_DISABLE ) 
        panel:addChild(self.tab_skill_slot[i].view);
        -- self.tab_skill_slot[i].view:setIsVisible(false)
    end 


end

-- 技能框item被点击 
function UserJiNengPage:ItemBeedClicked(item, skill_base )
    if skill_base == self.skill_table[2].skill_base then
        Instruction:handleUIComponentClick(instruct_comps.USER_SKILL_SELECT)
    end
    for k,v in pairs(self.skill_table) do
        v:set_selected(false)
    end

    -- 技能名字 ------------------------------------
    local skill_name = skill_base.name
    jn_name:setString( LH_COLOR[5] .. skill_name )

    item:set_selected(true)
    -- 设置当前技能 -- 升级按钮 ----------------------
    _cur_skill = item
    --获取额外信息
    local skill_info = UserSkillModel:get_a_skill_by_id( skill_base.id )
    local if_can_check, can_not_type = UserSkillModel:check_skill_if_can_upgrade( skill_base.id )
    local _level = 1
    if skill_info then
        _level = skill_info.level
        self.upgra_label:setString( Lang.skill_info.btn_level_up )                      -- "升  级"
        if if_can_check then                                    -- 可升级，隐藏提示lable，显示升级按钮
            self.upgra_btn:setCurState( CLICK_STATE_UP )
        elseif can_not_type == "skill_top" then                 -- 满级，隐藏按钮，显示提示lable
            self.upgra_btn:setCurState( CLICK_STATE_DISABLE )  
        else                                                    -- 不可升级，隐藏按钮，隐藏提示lable
            self.upgra_btn:setCurState( CLICK_STATE_DISABLE )  
        end
    else
        self.upgra_label:setString( Lang.skill_info.btn_learn )     -- "学  习"
        if if_can_check then                                    -- 可学习，隐藏提示lable，显示学习按钮
            self.upgra_btn:setCurState( CLICK_STATE_UP )
        else                                                   -- 不可学习，满级，隐藏按钮，显示提示lable
            -- self.upgra_label:setString("升  级")
            self.upgra_btn:setCurState( CLICK_STATE_DISABLE )
        end
    end  

    -- 技能等级 -------------------------------------just_mark
    jn_level:setString( LH_COLOR[2] .. Lang.skill_info.skill_level .. LH_COLOR[4] ..  _level .. Lang.skill_info.skill_full_lv )  -- 满级45

    --检索静态配置数据   -- just_remark -------------------------------------------------
    local current_level_config = skill_base.skillSubLevel[_level];
    --获取当前技能描述
    if current_level_config and current_level_config.desc then
        local skill_desc_text = current_level_config.desc;
        self.skill_desc:setText( LH_COLOR[2] .. Lang.skill_info.skill_desc .. LH_COLOR[15] ..  skill_desc_text);
    else
        self.skill_desc:setText( LH_COLOR[2] .. Lang.skill_info.skill_desc .. LH_COLOR[15] ..  Lang.skill_info.null_txt )
    end

    -- 获取 攻击范围类型 技能参数 ----------------------------------------------------------
    local skill_id = skill_base.id
    local skill_config = SkillConfig:get_skill_by_id(skill_id);
    local skillType = nil;
    if skill_config.skillType == 2 or skill_config.skillType == 4 then
        --2、4为群体
        skillType = Lang.skill_info.group_label; --="群体"
    else
        --其他的视为单体
        skillType = Lang.skill_info.single_label; -- ="单体"
    end
    jn_label1:setString( LH_COLOR[2] .. Lang.skill_info.jn_label1 .. LH_COLOR[15] .. skillType)         -- 单体 or 群体
        --释放需要的mp,距离
    local skill_mp = "0"
    local skill_distance = "0"

    local current_level_config = skill_config.skillSubLevel[_level];
    local spell_conds = current_level_config.spellConds;
    for i,v in ipairs(spell_conds) do
        -- print("技能施法条件",i,v.cond,v.value);
        if v.cond == SkillConfig.SC_MP then
            --消耗MP
            skill_mp = v.value;
        elseif v.cond == SkillConfig.SC_MAX_TARGET_DIST then
            --施法距离
            skill_distance = (v.value + 1) * 0.5;
        end
    end
    jn_label2:setString( LH_COLOR[2] .. Lang.skill_info.jn_label2 .. LH_COLOR[15] .. skill_distance)    -- 施法距离
    jn_label3:setString( LH_COLOR[2] .. Lang.skill_info.jn_label3 .. LH_COLOR[15] .. skill_mp)          -- 耐力消耗            
    local cool_time = current_level_config.cooldownTime/1000;
    jn_label4:setString( LH_COLOR[2] .. Lang.skill_info.jn_label4 .. LH_COLOR[15] .. cool_time ..  Lang.skill_info.second_txt) -- "#c0edc09冷却时间: #cffffff", "秒"

    -- 升级条件需求 ------------------------------------------------------------------------
    local money = self:get_need_money(item)
    local exp = self:get_need_exp(item)
    local lv = UserSkillModel:get_up_con_by_skill_id( skill_id, "level" )  -- 学习技能的低等级
    self.need_money:setString(need_money_txt .. money)
    self.need_exp:setString(need_exp_txt .. exp)
    self.need_lv:setString(need_lv_txt .. lv)

    -- 下一级效果 说明
    local next_level_config = skill_config.skillSubLevel[_level+1];
    if next_level_config and next_level_config.desc then
        local skill_desc_text = next_level_config.desc;
        self.skill_desc_next:setText( LH_COLOR[2] .. Lang.skill_info.skill_next_desc ..LH_COLOR[15] ..  skill_desc_text )
    else
        self.skill_desc_next:setText( LH_COLOR[2] .. Lang.skill_info.skill_next_desc ..LH_COLOR[15] ..  Lang.skill_info.null_txt )
    end
end

-- ===============================================
-- 更新
-- ===============================================
function UserJiNengPage:update_bottom_data()
    local upd_all_need_exp = self:get_upgr_need_exp()
    self.need_exp_all_value:setString( "" .. upd_all_need_exp )
    local upd_all_need_money = self:get_upgr_need_total_money()
    self.need_money_all_value:setString( "" .. upd_all_need_money )
end


-- 检查一键升级按钮是否有效: 当有任何一个技能可以升级或者学习，就生效。否则无效
function UserJiNengPage:check_a_key_to_upgrade_but(  )
    self:update_bottom_data()
    for i, skill in ipairs(self.skill_table) do
        if UserSkillModel:check_skill_if_can_upgrade( skill.skill_id ) then
            self.but_upgrade:setCurState( CLICK_STATE_UP )
            return 
        end
    end
    
    self.but_upgrade:setCurState( CLICK_STATE_DISABLE )
end

-- 更新技能窗口（供外部调用）
function UserJiNengPage:update_skill_win(  )
    self:update( "" )
end

function UserJiNengPage:update( update_type )
    self:syn_skill_date(  )
    self:check_a_key_to_upgrade_but()
    -- self:flash_exp_gold_need( )
    -- self:ItemBeedClicked(_cur_skill, _cur_skill.skill_base)
    self:init_bttm_skill()
    local curSceneId = SceneManager:get_cur_scene()
    if curSceneId == 27 then
        for i, item in ipairs(self.skill_table) do
            item:set_enable_drag_out(false)
        end
    end

    -- ===============================
    -- 添加技能初始化选中框，如果有学习的，
    -- 优先选择学习，无学习时，选择可升级的，如果都并没有，默认选择第一个
    -- ===============================
    local skill_index_selected = 1
    -- 是否有学习的技能
    local have_learn = false
    for i=1, #self.skill_table do
        local skill_info = UserSkillModel:get_a_skill_by_id( self.skill_table[i].skill_base.id )
        local if_can_check, can_not_type = UserSkillModel:check_skill_if_can_upgrade( self.skill_table[i].skill_base.id )
        if (if_can_check == true) and (not skill_info) then
            skill_index_selected = i
            have_learn = true
            break 
        end
    end

    if (not have_learn) then
        for i=1, #self.skill_table do
            local if_can_check, can_not_type = UserSkillModel:check_skill_if_can_upgrade( self.skill_table[i].skill_base.id )
            if (if_can_check == true) then
                skill_index_selected = i
                break 
            end
        end
    end
    -- 开窗默认选择第几个技能
    self:ItemBeedClicked(self.skill_table[skill_index_selected], self.skill_table[skill_index_selected].skill_base)
 end

 -- 重新同步技能数据
function UserJiNengPage:syn_skill_date(  )
    for i, slot_skill in ipairs(self.skill_table) do
        slot_skill:update()
    end
end


-- add
-- 获取技能升级需要的总银两
function UserJiNengPage:get_upgr_need_total_money(  )
    local money = 0
    for i, skill_slot in ipairs(self.skill_table) do
        money = money + skill_slot:get_upgr_need_money()
    end
    return money
end

function UserJiNengPage:get_need_money( skill_item )
    local money = 0
    if skill_item then
        money = skill_item:get_upgr_need_money()
    end
    return money
end

-- 获取技能升级需要的总经验
function UserJiNengPage:get_upgr_need_exp(  )
    local exp = 0
    for i, skill in ipairs(self.skill_table) do
        exp = exp + skill:get_upgr_need_exp()
    end
    return exp
end

function UserJiNengPage:get_need_exp( skill_item )
    local exp = 0
    if skill_item then
        exp = skill_item:get_upgr_need_exp()
    end
    return exp
end


-- 当一个新技能拖动到技能快捷面板的时候，先检测该面板里是否已经有了这个技能，有的话就把它删掉(替换)
function UserJiNengPage:check_is_exist( skill_id ,index, here_skill_id)
    for i=1, NORMAL_SKILLS_NUM do
        if ( i~= index ) then 
            if ( tab_skill_id[i] and tab_skill_id[i] == skill_id ) then

                -- self.tab_skill_slot[i]:stop_cd_animation();
                self.tab_skill_slot[i]:set_icon(nil);
                -- self.tab_skill_slot[i].view:setIsVisible(false)
                tab_skill_id[i] = nil;
                -- 通知服务器删掉这个快捷键
                if here_skill_id then   
                    KeySettingCC:req_set_a_key( i,here_skill_id,1 )
                else
                    KeySettingCC:req_set_a_key( i,0,1 )
                end
                return;
            end
        end
    end
end

-- 打开技能面板初始化4个技能
function UserJiNengPage:init_bttm_skill()
    local t_key_setting = KeyModel:get_key_table()
    for i=1, #t_key_setting do     -- 4个目前技能键
        -- 1技能2物品
        if ( t_key_setting[i].key_type == 1 and t_key_setting[i].key_value~= 0 ) then
            self:set_btn_skill_by_index(t_key_setting[i].key_index,t_key_setting[i].key_value);
        end
    end
end

-- 设置指定索引的技能图标
function UserJiNengPage:set_btn_skill_by_index(index,skill_id)
    -- print("MenusPanel:set_btn_skill_by_index(index,skill_id)",index,skill_id)
    if ( index <= MAX_NORMAL_SKILLS ) then
        tab_skill_id[index] = skill_id;
        self.tab_skill_slot[index]:set_icon( skill_id );
    end
end

function UserJiNengPage:destroy( )
    -- 处理特效
    -- UserSkillModel:clear_effect_bg( )
    UserSkillModel:clear_effect_and_callback()
end