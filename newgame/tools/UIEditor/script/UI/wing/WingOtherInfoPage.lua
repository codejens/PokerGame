-- WingOtherInfoPage.lua
-- created by chj on 2014.11.14
-- 查看他人翅膀 信息

super_class.WingOtherInfoPage()

-- ui param
local win_w = 900
local win_h = 605
local align_x = 10
local aligh_x_2 = 15
local radio_b_w = 101 -- 从ui获取的尺寸,radiobtn
local radio_b_h = 45
local panel_w = 900-align_x*2
local panel_h = win_h-radio_b_h -40

-- 小面板 param
local panel_lt_h = panel_h-aligh_x_2*2
local panel_l_w = 423
local panel_m_w = 423

local wingNumPerPage = 4 -- 每页显示技能个数

-- local wing_index = { 1, 2, 3, 4, 5, 6, 7, 8 }
local wing_index = { 1, 2, 3, 4, 5, 6 }
local wing_path = { "icon/item/11400.pd", "icon/item/11401.pd", "icon/item/11402.pd" ,
            "icon/item/11403.pd", "icon/item/11404.pd", "icon/item/11405.pd", 
            "icon/item/11406.pd", "icon/item/11407.pd" }

-- 翅膀主界面窗口
function WingOtherInfoPage:__init()
    self.view = ZBasePanel.new( UILH_COMMON.normal_bg_v2, panel_w, panel_h).view

    -- 技能列表
    self.t_skill_item = {}
    WingModel:set_cur_show_stage( self:get_put_on_wing_id() )

    self.root_win = UIManager:find_visible_window("wing_win")
    -- 创建 3个面板
    self:create_left_panel()
    self:create_middle_panel()
    -- self:create_right_panel()
end

-- 获取当前穿戴翅膀
function WingOtherInfoPage:get_put_on_wing_id()
    local modelID = nil
    -- local isShowOther = WingModel:getIsShowOtherWing()
    -- if isShowOther then
    -- 判断是否是其他人的翅膀
        local otherWingData = WingModel:getOtherWingData()
        modelID = otherWingData.modelId
    -- else
    --     modelID = WingModel:get_curr_modelId()
    -- end
    return modelID
end

-- 左面板 
function WingOtherInfoPage:create_left_panel()
    self.panel_left = CCBasePanel:panelWithFile( aligh_x_2, aligh_x_2, panel_l_w, panel_lt_h, UILH_COMMON.bottom_bg, 500, 500)
    self.view:addChild( self.panel_left )

    -- 战斗力title ---------------------------------------------
    self.fightTitle = CCZXImage:imageWithFile(panel_l_w*0.5-120, panel_lt_h-65, -1, -1, UILH_OTHER.wing_zhandouli)
    self.panel_left:addChild( self.fightTitle )
    -- 战斗力value
    self.fightVal = ZXLabelAtlas:createWithString( "99999", "ui/lh_other/number2_" )
    self.fightVal:setPosition(CCPointMake( panel_l_w*0.5+4, panel_lt_h-62) )
    self.fightVal:setAnchorPoint( CCPointMake(0, 0) )
    self.panel_left:addChild( self.fightVal )


    -- 分割线 
    local line = CCZXImage:imageWithFile( 10, 285, panel_l_w-20, 3, UILH_COMMON.split_line )
    self.panel_left:addChild( line )


    -- 左右等级
    local panel_lttl_h = 268
    local begin_attr_y = 30
    local begin_attr_x = 25
    local inter_attr_y = 55
    local begin_arrow_y = 18
    -- 当前等级面板 ----------------------------------
    local cur_panel = CCBasePanel:panelWithFile( 0, 0, panel_l_w*0.5, panel_lttl_h, "", 500, 500 )
    self.panel_left:addChild( cur_panel )

    -- 当前等级title 
    local cur_title = CCBasePanel:panelWithFile( 2, panel_lttl_h-37, panel_l_w*0.5, -1, UILH_NORMAL.title_bg4, 500, 500)
    cur_panel:addChild( cur_title )
    self.cur_lab = UILabel:create_lable_2( LH_COLOR[2] .. Lang.wing[32] .. "49", panel_l_w*0.5*0.5, 10, 16, ALIGN_CENTER )
    cur_title:addChild( self.cur_lab )
    -- 攻击
    local attr_lab = UILabel:create_lable_2( LH_COLOR[2] .. Lang.wing[5], begin_attr_x, begin_attr_y+inter_attr_y*3, 14, ALIGN_LEFT )
    cur_panel:addChild( attr_lab)
    self.attack = ZLabel:create(cur_panel, "44444444444", 105, begin_attr_y+inter_attr_y*3, 14, 1, 1)
    -- 外功防御
    local attr_lab = UILabel:create_lable_2( LH_COLOR[2] .. Lang.wing[6], begin_attr_x, begin_attr_y+inter_attr_y*2, 14, ALIGN_LEFT )
    cur_panel:addChild( attr_lab)
    self.phyDef = ZLabel:create(cur_panel, "8888888888", 105, begin_attr_y+inter_attr_y*2, 15, 1, 1)
    -- 内功防御
    local attr_lab = UILabel:create_lable_2( LH_COLOR[2] .. Lang.wing[7], begin_attr_x, begin_attr_y+inter_attr_y, 14, ALIGN_LEFT )
    cur_panel:addChild( attr_lab)
    self.magDef = ZLabel:create(cur_panel, "8888888888", 105, begin_attr_y+inter_attr_y, 14, 1, 1)
    -- 生命
    local attr_lab = UILabel:create_lable_2( LH_COLOR[2] .. Lang.wing[8], begin_attr_x, begin_attr_y, 14, ALIGN_LEFT )
    cur_panel:addChild( attr_lab)
    self.hp = ZLabel:create(cur_panel, "444444444", 105, begin_attr_y, 14, 1, 1)


    -- 下级等级面板-------------------------------
    local next_panel = CCBasePanel:panelWithFile( panel_l_w*0.5, 0, panel_l_w*0.5, 215, "", 500, 500 )
    self.panel_left:addChild( next_panel )

    -- 下级等级title
    local next_title = CCBasePanel:panelWithFile( 2, panel_lttl_h-37, panel_l_w*0.5, -1, UILH_NORMAL.title_bg4, 500, 500)
    next_panel:addChild( next_title )
    self.next_lab = UILabel:create_lable_2( LH_COLOR[2] .. Lang.wing[32] .. "50", panel_l_w*0.5*0.5, 10, 16, ALIGN_CENTER )
    next_title:addChild( self.next_lab)
    -- 攻击
    local attr_lab = UILabel:create_lable_2( LH_COLOR[2] .. Lang.wing[5], begin_attr_x, begin_attr_y+inter_attr_y*3, 14, ALIGN_LEFT )
    next_panel:addChild( attr_lab)
    self.next_attack = ZLabel:create(next_panel, "44444444444", 105, begin_attr_y+inter_attr_y*3, 14, 1, 1)
    -- 外功防御
    local attr_lab = UILabel:create_lable_2( LH_COLOR[2] .. Lang.wing[6], begin_attr_x, begin_attr_y+inter_attr_y*2, 14, ALIGN_LEFT )
    next_panel:addChild( attr_lab)
    self.next_phyDef = ZLabel:create(next_panel, "8888888888", 105, begin_attr_y+inter_attr_y*2, 15, 1, 1)
    -- 内功防御
    local attr_lab = UILabel:create_lable_2( LH_COLOR[2] .. Lang.wing[7], begin_attr_x, begin_attr_y+inter_attr_y, 14, ALIGN_LEFT )
    next_panel:addChild( attr_lab)
    self.next_magDef = ZLabel:create(next_panel, "8888888888", 105, begin_attr_y+inter_attr_y, 14, 1, 1)
    -- 生命
    local attr_lab = UILabel:create_lable_2( LH_COLOR[2] .. Lang.wing[8], begin_attr_x, begin_attr_y, 14, ALIGN_LEFT )
    next_panel:addChild( attr_lab)
    self.next_hp = ZLabel:create(next_panel, "444444444", 105, begin_attr_y, 14, 1, 1)

    -- 添加4个箭头  SIZE:46, 33
    local arrow1 = CCZXImage:imageWithFile( -23, begin_arrow_y+inter_attr_y*3, -1, -1, UILH_COMMON.right_arrows )
    next_panel:addChild(arrow1)
    local arrow2 = CCZXImage:imageWithFile( -23, begin_arrow_y+inter_attr_y*2, -1, -1, UILH_COMMON.right_arrows )
    next_panel:addChild(arrow2)
    local arrow3 = CCZXImage:imageWithFile( -23, begin_arrow_y+inter_attr_y, -1, -1, UILH_COMMON.right_arrows )
    next_panel:addChild(arrow3)
    local arrow4 = CCZXImage:imageWithFile( -23, begin_arrow_y, -1, -1, UILH_COMMON.right_arrows )
    next_panel:addChild(arrow4)


    -- -- 当前属性title ------------------------------------------
    -- self.attrTitle = CCBasePanel:panelWithFile( 0, 390, panel_l_w, -1, UILH_NORMAL.title_bg, 500, 500)
    -- self.panel_left:addChild( self.attrTitle )
    -- local attr_lab = UILabel:create_lable_2( LH_COLOR[2] .. Lang.wing[4], panel_l_w*0.5, 10, 16, ALIGN_CENTER )
    -- self.attrTitle:addChild( attr_lab)

    -- -- 攻击
    -- local attr_lab = UILabel:create_lable_2( LH_COLOR[2] .. Lang.wing[5], 20, 365, 14, ALIGN_LEFT )
    -- self.panel_left:addChild( attr_lab)
    -- self.attack = ZLabel:create(self.panel_left, "44444444444", 105, 365, 14, 1, 1)

    -- -- 外功防御
    -- local attr_lab = UILabel:create_lable_2( LH_COLOR[2] .. Lang.wing[6], 20, 335, 14, ALIGN_LEFT )
    -- self.panel_left:addChild( attr_lab)
    -- self.phyDef = ZLabel:create(self.panel_left, "8888888888", 105, 335, 15, 1, 1)

    -- -- 内功防御
    -- local attr_lab = UILabel:create_lable_2( LH_COLOR[2] .. Lang.wing[7], 20, 305, 14, ALIGN_LEFT )
    -- self.panel_left:addChild( attr_lab)
    -- self.magDef = ZLabel:create(self.panel_left, "8888888888", 105, 305, 14, 1, 1)

    -- -- 生命
    -- local attr_lab = UILabel:create_lable_2( LH_COLOR[2] .. Lang.wing[8], 20, 275, 14, ALIGN_LEFT )
    -- self.panel_left:addChild( attr_lab)
    -- self.hp = ZLabel:create(self.panel_left, "444444444", 105, 275, 14, 1, 1)

    -- -- 详情资料title ------------------------------------------
    -- self.infoTitle = CCBasePanel:panelWithFile( 0, 205, panel_l_w, -1, UILH_NORMAL.title_bg, 500, 500)
    -- self.panel_left:addChild( self.infoTitle )
    -- local info_lab = UILabel:create_lable_2( Lang.wing[9], panel_l_w*0.5, 10, 16, ALIGN_CENTER )
    -- self.infoTitle:addChild( info_lab )

    -- 名称
    local wing_name = UILabel:create_lable_2( LH_COLOR[2] .. Lang.wing[10], 45, 405, 14, ALIGN_LEFT )
    self.panel_left:addChild( wing_name)
    self.wing_name_v = ZLabel:create(self.panel_left, Lang.wing[11], 125, 405, 14, 1, 1)

    -- 翅膀等级
    local wing_level_title = UILabel:create_lable_2( LH_COLOR[2] .. Lang.wing[12], 45, 365, 14, ALIGN_LEFT )
    self.panel_left:addChild( wing_level_title )
    self.wing_level_v = ZLabel:create(self.panel_left, "10", 125, 365, 14, 1, 1)

    -- 翅膀品阶
    local wing_degree = UILabel:create_lable_2( LH_COLOR[2] .. Lang.wing[13], 45, 325, 14, ALIGN_LEFT )
    self.panel_left:addChild( wing_degree)
    self.wing_degree_v = ZLabel:create(self.panel_left, "十阶", 125, 325, 14, 1, 1)
    self.wing_start_v = ZLabel:create(self.panel_left, "4星", 165, 325, 14, 1, 1)

    -- -- 升级按钮 和 升阶按钮 ------------------------------------
    -- local function btn_grade_fun()
    --     self.root_win:change_page(2)
    -- end 
    -- self.btn_upGrade = ZTextButton:create(self.panel_left, LH_COLOR[2] .. Lang.wing[14], UILH_COMMON.button4, 
    --     btn_grade_fun, 145, 95, -1, -1)

    -- local function btn_degree_fun()
    --  self.root_win:change_page(3)
    -- end
    -- self.btn_upDegree = ZTextButton:create(self.panel_left, LH_COLOR[2] .. Lang.wing[15], UILH_COMMON.button4, 
    --     btn_degree_fun, 145, 20, -1, -1)

end

-- 中间面板 =====================================
function WingOtherInfoPage:create_middle_panel()
    self.panel_middle = CCBasePanel:panelWithFile( panel_l_w+aligh_x_2, aligh_x_2, panel_m_w, panel_lt_h, UILH_COMMON.bottom_bg, 500, 500)
    self.view:addChild( self.panel_middle )

    -- 翅膀名字title -------------------------------------------
    self.nameTitle = CCBasePanel:panelWithFile( 20, 440, -1, -1, UILH_NORMAL.title_bg3, 500, 500)
    self.panel_middle:addChild( self.nameTitle )
    self.name_lab = UILabel:create_lable_2( LH_COLOR[1] .. Lang.wing[17], 356*0.5, 17, 16, ALIGN_CENTER )
    self.nameTitle:addChild( self.name_lab )

    -- 背景 195, 329
    -- local left_bg = CCZXImage:imageWithFile(4, 145, (panel_m_w-8)*0.5, -1, UILH_WING.cb_bg)
    -- self.panel_middle:addChild( left_bg )
    -- local right_bg = CCZXImage:imageWithFile(panel_m_w*0.5-1, 145, (panel_m_w-8)*0.5, -1, UILH_WING.cb_bg)
    -- right_bg:setFlipX(true)
    -- self.panel_middle:addChild( right_bg )

    -- 4个角标
    local LTCorner = ZBasePanel:create(self.panel_middle, UILH_WING.lace, 10, panel_lt_h-80)
    LTCorner.view:setFlipX(false)
    LTCorner.view:setFlipY(true)
    local LBCorner = ZBasePanel:create(self.panel_middle, UILH_WING.lace, 10, 150)
    LBCorner.view:setFlipX(false)
    LBCorner.view:setFlipY(false)
    local RTCorner = ZBasePanel:create(self.panel_middle, UILH_WING.lace, panel_m_w-55, panel_lt_h-80)
    RTCorner.view:setFlipX(true)
    RTCorner.view:setFlipY(true)
    local RBCorner = ZBasePanel:create(self.panel_middle, UILH_WING.lace, panel_m_w-55, 150)
    RBCorner.view:setFlipX(true)
    RBCorner.view:setFlipY(false)

    -- 人物模型
    -- self.curPlayerModel = self:createPlayerModel(panel_m_w*0.5, 220)
    -- self.panel_middle:addChild(self.curPlayerModel.avatar)

    -- 翅膀化形title --------------------------------------------
    self.formTitle = CCBasePanel:panelWithFile( 0, 110, panel_m_w, -1, UILH_NORMAL.title_bg4, 500, 500)
    self.panel_middle:addChild( self.formTitle )
    local form_lab = UILabel:create_lable_2( Lang.wing[20], panel_m_w*0.5, 10, 16, ALIGN_CENTER )
    self.formTitle:addChild( form_lab )

    self:create_wing_scroll( self.panel_middle )
end

-- 创建人物模型 middle
function WingOtherInfoPage:createPlayerModel( x, y, other_player )
    require "entity/ShowAvatar"
    local showAvatar = ShowAvatar:create_wing_panel_avatar( x, y, other_player )
    showAvatar.avatar:setActionStept(ZX_ACTION_STEPT)
    showAvatar.avatar:playAction(ZX_ACTION_IDLE, 4, true)
    return showAvatar
end

-- 创建下方翅膀滚动按钮item
function WingOtherInfoPage:create_wing_scroll( panel )

    -- 回调更新名字
    local createItem = function( index, newComp )
        if not newComp then
            newComp = self:createWingItem(index)
            newComp.update(index)
        else
            newComp.update(index)
        end
        return newComp
    end
    

    self.wingScroll = TouchListHorizontal(45, 20, 332, 83, 83, 10)
    self.wingScroll:BuildList(83, 50, wingNumPerPage, wing_index, createItem )
    panel:addChild(self.wingScroll.view)

    -- 左翻按钮
    local function left_btn_func()
        local leftIndex = self.wingScroll:getLeftIndex()
        if leftIndex > 1 then
            if leftIndex - 1 > 0 then
                self.wingScroll:setIndex(leftIndex-1)
            else
                self.wingScroll:setIndex(1)
            end
        else
            GlobalFunc:create_screen_notic( Lang.wing[21] )
        end
    end
    self.leftBtn = ZButton:create(panel, UILH_COMMON.arrow_normal, left_btn_func , 9, 15, -1, -1)  -- 34,95

    -- 右翻按钮
    local function right_btn_func()
        local wingNum = #wing_index
        local leftIndex = self.wingScroll:getLeftIndex()
        if leftIndex <= wingNum-wingNumPerPage then
            self.wingScroll:setIndex(leftIndex+1)
        else
            GlobalFunc:create_screen_notic( Lang.wing[22] )
        end
    end
    self.rightBtn = ZButton:create(panel, UILH_COMMON.arrow_normal, right_btn_func, 381, 15, -1, -1 ) -- 34,95
    self.rightBtn.view:setFlipX(true)
end

function WingOtherInfoPage:createWingItem( index )
    local WingItem = ZBasePanel.new(nil, 80, 80)
    local item = MUtils:create_slot_item(WingItem.view, UILH_COMMON.slot_bg, 3, 3, 81, 81, nil, nil)

    WingItem.update = function( index )
        if item.lock then
            item.lock:removeFromParentAndCleanup(true)
            item.lock = nil
        end

        local itemIcon = wing_path[index]
        item:set_icon_texture( itemIcon )
        item:set_select_effect_state(false)

        if index == 7 or index == 8 then
            item.lock = CCBasePanel:panelWithFile( -8, -8, -1, -1, UILH_NORMAL.lock)
            item.view:addChild(item.lock, 3)
        end
        -- 选中特效
        -- local isShowOther = WingModel:getIsShowOtherWing()
        -- if not isShowOther then
        --     local selected = WingModel:get_cur_show_stage()
        --     if selected == index then
        --         SlotEffectManager.play_effect_by_slot_item(item):setPosition(CCPointMake(24, 24))
        --     elseif math.abs(selected-index) >= wingNumPerPage then
        --         SlotEffectManager.stop_current_effect()
        --     end
        -- end
            -- item 点击触发函数
        item:set_click_event( function( ... )
            
            -- local isShowOther = WingModel:getIsShowOtherWing()
            -- if not isShowOther then
            --     -- SlotEffectManager.play_effect_by_slot_item(item):setPosition(CCPointMake(24, 24))

            --     -- 翅膀名字
            --     local wingNameTxt = WingConfig:get_wing_name(index)
            --     self.name_lab:setText(LH_COLOR[1].. wingNameTxt)

            --     -- 设置选中翅膀
            --     WingModel:set_cur_show_stage(index)
            --     self.curPlayerModel:update_wing(index)
            --     self.curPlayerModel:change_attri("body")
            --     -- self:update_middle_panel_data()
            -- end
        end )
    end

    return WingItem
end

-- 右面板scrollview的item
function WingOtherInfoPage:create_item_panel( panel, x, y, w, h, index )

    -- 初始化 t_skill_item 表格
    self.t_skill_item[index] =  self.t_skill_item[index] or {}

    -- 翅膀数据
    local skills = WingConfig:get_wing_skills()

    -- 技能图标
    local skillItem = WingSkillItem:create_item( panel, x, y, 96, 94, index)
    skillItem:set_lock()
    self.t_skill_item[index].item = skillItem
    -- 点击触发函数
    skillItem.item:set_click_event( function( ... )
        -- 显示Tips
        local wingData = nil
        -- local isShowOther = WingModel:getIsShowOtherWing()
        -- if isShowOther then
            wingData = WingModel:getOtherWingData()
        -- else
        --     wingData = WingModel:get_wing_item_data()
        -- end
        wingData.skills[index].level = wingData.skills_level[index]
        wingData.skills[index].skillId = index
        TipsModel:show_wing_skill_tip(490, 480/2, wingData.skills[index])
    end )


    local level = skills[index].level
    local skills = WingConfig:get_wing_skills()

    local skill_name = UILabel:create_lable_2( skills[index].name, 90, 53, 16, ALIGN_LEFT )
    panel:addChild( skill_name )
    self.t_skill_item[index].name = skill_name

    local skill_desc = UILabel:create_lable_2( Lang.wing[25], 90, 20, 16, ALIGN_LEFT )
    panel:addChild( skill_desc )
    self.t_skill_item[index].desc = skill_desc

end

-- ========================================================================
-- 数据更新方法 ===========================================================
-- ========================================================================
function WingOtherInfoPage:update_left_panel_data()
    local curAttr = nil
    local curAddAttr = nil
    local wingNameTxt = nil
    local wingLevelTxt = nil
    local wingStageTxt = nil
    local wingStarTxt = nil
    -- 更新战斗力 --------------------------------------
    curAttr = WingModel:getOtherWingCurAttr()
    curAddAttr = WingModel:getOtherWingCurAttrAppend()
    -- 战斗力
    local fight = WingModel:getOtherWingScore()
    self.fightVal:init(tostring(fight))
    -- 名字
    wingNameTxt = WingModel:getOtherWingName()
    wingLevelTxt =WingModel:getOtherWingLevel()
    wingStageTxt = WingModel:getOtherWingStage()
    wingStarTxt = WingModel:getOtherWingStar()

    -- -- 更新属性 --------------------------------------
    -- self.attack:setText(string.format( LH_COLOR[15] .. "%d+" .. LH_COLOR[6] .. "%d", curAttr[1], curAddAttr[1]))
    -- self.phyDef:setText(string.format( LH_COLOR[15] .. "%d+" .. LH_COLOR[6] .. "%d", curAttr[2], curAddAttr[2]))
    -- self.magDef:setText(string.format( LH_COLOR[15] .. "%d+" .. LH_COLOR[6] .. "%d", curAttr[3], curAddAttr[3]))
    -- self.hp:setText(string.format( LH_COLOR[15] .. "%d+" .. LH_COLOR[6] .. "%d", curAttr[4], curAddAttr[4]))

    -- 翅膀详细资料
    self.wing_name_v:setText(string.format( LH_COLOR[15] .. "%s", wingNameTxt))
    self.wing_level_v:setText(string.format( LH_COLOR[15] .. "%d", wingLevelTxt))
    self.wing_degree_v:setText(string.format( LH_COLOR[15] .. "%s" .. Lang.wing[26], self:to_word(wingStageTxt)) )  -- #c0edc09%s阶
    self.wing_start_v:setText(string.format( LH_COLOR[15] .. "%d" .. Lang.wing[27], wingStarTxt))

    -- 更新左小面板(当前) 等级
    local curLv = WingModel:getOtherWingLevel()
    -- local maxLv = WingConfig:get_wing_max_level()
    local maxLv = 90 -- 修改
    print("--------curLv, maxLv:", curLv, maxLv)
    self.cur_lab:setText( "等级" .. curLv)
    -- 更新当前属性( 攻击，外防，内防，生命 ) ---
    local curAttr = WingModel:getOtherWingCurAttr()
    local curAddAttr = WingModel:getOtherWingCurAttrAppend()
    self.attack:setText( string.format("%d" .. LH_COLOR[6] .. "+%d", curAttr[1], curAddAttr[1]) )
    self.phyDef:setText( string.format("%d" .. LH_COLOR[6] .. "+%d", curAttr[2], curAddAttr[2]) )
    self.magDef:setText( string.format("%d" .. LH_COLOR[6] .. "+%d", curAttr[3], curAddAttr[3]) )
    self.hp:setText( string.format("%d" .. LH_COLOR[6] .. "+%d", curAttr[4], curAddAttr[4]) )

    if not (curLv==maxLv) then
        local nextLv = (curLv>=maxLv) and maxLv or (curLv+1)
        self.next_lab:setText( "等级" .. nextLv )
        -- 更新下级属性( 攻击，外防，内防，生命 ) ---
        local nexAttr = WingModel:getOtherWingNexAttr()
        local nexAddAttr = WingModel:getOtherWingNexAttrAppend()
        self.next_attack:setText( string.format("%d" .. LH_COLOR[6] .. "+%d", nexAttr[1], nexAddAttr[1]) )
        self.next_phyDef:setText( string.format("%d" .. LH_COLOR[6] .. "+%d", nexAttr[2], nexAddAttr[2]) )
        self.next_magDef:setText( string.format("%d" .. LH_COLOR[6] .. "+%d", nexAttr[3], nexAddAttr[3]) )
        self.next_hp:setText( string.format("%d" .. LH_COLOR[6] .. "+%d", nexAttr[4], nexAddAttr[4]) )
    else
        local curLv = WingModel:getOtherWingLevel()
        self.next_lab:setText( "等级" .. curLv )
        -- 更新下级属性( 攻击，外防，内防，生命 ) ---
        local curAttr = WingModel:get_curr_attr()
        local curAddAttr = WingModel:get_curr_attr_append() 
        self.next_attack:setText( string.format("%d" .. LH_COLOR[6] .. "+%d", curAttr[1], curAddAttr[1]) )
        self.next_phyDef:setText( string.format("%d" .. LH_COLOR[6] .. "+%d", curAttr[2], curAddAttr[2]) )
        self.next_magDef:setText( string.format("%d" .. LH_COLOR[6] .. "+%d", curAttr[3], curAddAttr[3]) )
        self.next_hp:setText( string.format("%d" .. LH_COLOR[6] .. "+%d", curAttr[4], curAddAttr[4]) )
    end
end

-- 数值转化为中文
function WingOtherInfoPage:to_word( num )
    local word_t = Lang.wing[28]
    return word_t[num]
end

-- 更新中间面板 ============================================
function WingOtherInfoPage:update_middle_panel_data()
    -- 更新人物模型
    local otherWingData = WingModel:getOtherWingData()
    local modelID = otherWingData.modelId

    local other_player = {}
    other_player.body = WingModel:get_other_player_info();
    other_player.wing = modelID

    -- 人物模型
    self.curPlayerModel = self:createPlayerModel(panel_m_w*0.5, 220, other_player)
    self.panel_middle:addChild(self.curPlayerModel.avatar)


    -- self.btn_flaunt.view:setIsVisible(false)
    -- self.btn_show.view:setIsVisible(false)


    -- local body = WingModel:get_other_player_info();
    -- self.curPlayerModel:udpate_body(body);
    -- self.curshowStage = modelID
    -- self.curPlayerModel:update_wing(modelID)
    -- self.curPlayerModel:change_attri("body")

    -- 翅膀名字
    local wingNameTxt = WingConfig:get_wing_name( modelID )
    self.name_lab:setText(LH_COLOR[1].. wingNameTxt)
end

-- 界面更新
function WingOtherInfoPage:update( updateType )
    if updateType == "all" then
        self:update_left_panel_data()
        self:update_middle_panel_data()
        -- self:update_right_panel_data()
    end
end

function WingOtherInfoPage:destroy( )

    if self.wingScroll then
        self.wingScroll:destroy()
        self.wingScroll = nil
    end
end

----------------------------------
