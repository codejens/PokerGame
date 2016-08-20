-- WingUpGradePage.lua
-- created by chj on 2014-10.31
-- 翅膀升级分页

super_class.WingUpGradePage()

-- ui param
local win_w = 900
local win_h = 605
local align_x = 10
local aligh_x_2 = 10
local radio_b_w = 101 -- 从ui获取的尺寸,radiobtn
local radio_b_h = 45
local panel_w = 900-align_x*2
local panel_h = win_h-radio_b_h -35

--小面板参数
local panel_up_h 	= 360
local panel_l_w 	= 400
local panel_r_w 	= 455
local panel_bttm_h	= 140 
local panel_bttm_w  = panel_w-5-aligh_x_2*2

function WingUpGradePage:__init( )
	self.view = ZBasePanel.new( UILH_COMMON.normal_bg_v2, panel_w, panel_h ).view

	-- 创建3个面板
	self:create_left_panel()
	self:create_right_panle()
	self:create_bttm_panel()
end

-- 左上面板 ======================================
function WingUpGradePage:create_left_panel()
	self.panel_left = CCBasePanel:panelWithFile( aligh_x_2, panel_bttm_h+aligh_x_2+2, panel_l_w, panel_up_h, UILH_COMMON.bottom_bg, 500, 500)
	self.view:addChild( self.panel_left )

	-- 翅膀名称title (354, 44)
	self.nameTitle = CCBasePanel:panelWithFile( 21, panel_up_h-47, -1, -1, UILH_NORMAL.title_bg3, 500, 500)
    self.panel_left:addChild( self.nameTitle )
    self.name_lab = UILabel:create_lable_2( LH_COLOR[2] .. Lang.wing[31], 354*0.5, (44-16)*0.5, 16, ALIGN_CENTER )
    self.nameTitle:addChild( self.name_lab )

    -- 背景 195, 329
    -- local left_bg = CCZXImage:imageWithFile(6, 4, -1, -1, UILH_WING.cb_bg)
    -- self.panel_left:addChild( left_bg )
    -- local right_bg = CCZXImage:imageWithFile(195+5, 4, -1, -1, UILH_WING.cb_bg)
    -- right_bg:setFlipX(true)
    -- self.panel_left:addChild( right_bg )

   	-- 4个角标 ---------
	local LTCorner = ZBasePanel:create(self.panel_left, UILH_WING.lace, 10, panel_up_h-80)
	LTCorner.view:setFlipX(false)
	LTCorner.view:setFlipY(true)
	local LBCorner = ZBasePanel:create(self.panel_left, UILH_WING.lace, 10, 10)
	LBCorner.view:setFlipX(false)
	LBCorner.view:setFlipY(false)
	local RTCorner = ZBasePanel:create(self.panel_left, UILH_WING.lace, panel_l_w-55, panel_up_h-80)
	RTCorner.view:setFlipX(true)
	RTCorner.view:setFlipY(true)
	local RBCorner = ZBasePanel:create(self.panel_left, UILH_WING.lace, panel_l_w-55, 10)
	RBCorner.view:setFlipX(true)
	RBCorner.view:setFlipY(false)

	-- 战斗力title ---------------------------------------------
	self.fightTitle = CCZXImage:imageWithFile(115, panel_up_h-65, -1, -1, UILH_ROLE.text_zhandouli)
	self.panel_left:addChild( self.fightTitle )
	-- 战斗力value
	self.fightVal = ZXLabelAtlas:createWithString( "8888888", "ui/lh_other/number1_" )
    self.fightVal:setPosition(CCPointMake( 205, panel_up_h-62) )
    self.fightVal:setAnchorPoint( CCPointMake(0, 0) )
    self.panel_left:addChild( self.fightVal )

    -- 人物模型
    self.curPlayerModel = self:createPlayerModel( 200, 75 )
    self.panel_left:addChild(self.curPlayerModel.avatar)
end

-- 创建人物模型 middle
function WingUpGradePage:createPlayerModel( x, y )
    -- 翅膀名字
    -- local wingNameTxt = WingModel:get_wing_name()
    self.name_lab:setText(LH_COLOR[1] .. "翅膀名字")

    -- 人物带翅膀的形象
    require "entity/ShowAvatar"
    self.showAvatar = ShowAvatar:create_wing_panel_avatar( x, y )
    self.showAvatar.avatar:setActionStept(ZX_ACTION_STEPT)
    self.showAvatar.avatar:playAction(ZX_ACTION_IDLE, 4, true)
    return self.showAvatar
end


-- 右面板 =======================================================
function WingUpGradePage:create_right_panle()
	self.panel_right = CCBasePanel:panelWithFile( panel_l_w+aligh_x_2, panel_bttm_h+aligh_x_2+2, panel_r_w, panel_up_h, UILH_COMMON.bottom_bg, 500, 500)
	self.view:addChild( self.panel_right )

	local panel_lttl_h = 215
	local begin_attr_y = 30
	local begin_attr_x = 25
	local inter_attr_y = 40
	local begin_arrow_y = 18
	-- 当前等级面板 ----------------------------------
	local cur_panel = CCBasePanel:panelWithFile( 0, 150, panel_r_w*0.5, panel_lttl_h, "", 500, 500 )
	self.panel_right:addChild( cur_panel )

	-- 当前等级title 149,31
	local cur_title = CCBasePanel:panelWithFile( 2, panel_lttl_h-37, panel_r_w*0.5, -1, UILH_NORMAL.title_bg4, 500, 500)
    cur_panel:addChild( cur_title )
    self.cur_lab = UILabel:create_lable_2( LH_COLOR[2] .. Lang.wing[32] .. "49", panel_r_w*0.5*0.5, (31-16)*0.5, 16, ALIGN_CENTER )
    cur_title:addChild( self.cur_lab)
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
	local next_panel = CCBasePanel:panelWithFile( panel_r_w*0.5, 150, panel_r_w*0.5, 215, "", 500, 500 )
	self.panel_right:addChild( next_panel )

	-- 下级等级title
	local next_title = CCBasePanel:panelWithFile( 2, panel_lttl_h-37, panel_r_w*0.5, -1, UILH_NORMAL.title_bg4, 500, 500)
    next_panel:addChild( next_title )
    self.next_lab = UILabel:create_lable_2( LH_COLOR[2] .. Lang.wing[32] .. "50", panel_r_w*0.5*0.5, (31-16)*0.5, 16, ALIGN_CENTER )
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

    -- 分割线 
    local line = CCZXImage:imageWithFile( 10, 150, panel_r_w-20, 3, UILH_COMMON.split_line )
    self.panel_right:addChild( line )

    -- 羽翼晶石tips --------------------------------------------------------------
  	local function needItemTipsFunc(  )
  		local needItemId = WingModel:get_cur_level_crystal_item_id()
  		if needItemId then
	   		TipsModel:show_shop_tip( 400, 240, needItemId, TipsModel.LAYOUT_LEFT )
	   	end
	end
    -- 羽翼晶石 slotItem
	local needItemId = WingModel:get_cur_level_crystal_item_id()
	self.needItem = MUtils:create_slot_item(self.panel_right, UILH_COMMON.slot_bg, 40, 60, 83, 83, needItemId, needItemTipsFunc)
	-- 购买按钮 ---
    local buyBtnCallback = function( )
        self:update("addItem")
    end
    local function btn_buy_fun()
    	local itemID = WingModel:get_cur_level_crystal_item_id()
        BuyKeyboardWin:show(itemID, buyBtnCallback)
    end 
    self.btn_buy = ZTextButton:create(self.panel_right, LH_COLOR[2] .. Lang.wing[33], UILH_COMMON.button4, 
        btn_buy_fun, 42, 10, -1, -1)

    -- 翅膀最高等级z----------------
    self.most_level_lab = UILabel:create_lable_2( LH_COLOR[2] .. "本阶最高等级 xx", 220, 120, 14, ALIGN_LEFT )
    self.panel_right:addChild( self.most_level_lab )

    -- 祝福值
    self.wishValueTitle = UILabel:create_lable_2( LH_COLOR[2] .. Lang.wing[34], 160, 85, 14, ALIGN_LEFT )
    self.panel_right:addChild( self.wishValueTitle )
    -- 祝福值进度条
    self.process_bar = ZXProgress:createWithValueEx(1,10,215,17,UILH_NORMAL.progress_bg2,UILH_NORMAL.progress_bar_orange, true);
	self.process_bar:setPosition(CCPointMake(225,85));
	self.process_bar:setProgressValue( 1, 10 )
	self.panel_right:addChild(self.process_bar,1)

	-- 是否自动购买材料勾选按钮
    self.autoBuyBtn = UIButton:create_switch_button(165, 17, 150, 44, 
        UILH_COMMON.dg_sel_1, 
        UILH_COMMON.dg_sel_2, 
        "", 0, 16, nil, nil, nil, nil, 
        autoBuyFunc )
    self.panel_right:addChild(self.autoBuyBtn.view, 2);

    ZLabel:create(self.panel_right, LH_COLOR[2] .. Lang.wing[35], 212, 30, 14, 1, 1)

	return parent
end

-- 底部面板 =======================================================
function WingUpGradePage:create_bttm_panel()
	self.panel_bttm = CCBasePanel:panelWithFile( aligh_x_2, aligh_x_2, panel_bttm_w, panel_bttm_h, UILH_COMMON.bottom_bg, 500, 500)
	self.view:addChild( self.panel_bttm )

        -- 4个角标 --------- 40,40
    local LTCorner = ZBasePanel:create(self.panel_bttm, UILH_PRIVATE.head_lace, 5, panel_bttm_h-45)
    LTCorner.view:setFlipX(true)
    LTCorner.view:setFlipY(false)
    local LBCorner = ZBasePanel:create(self.panel_bttm, UILH_PRIVATE.head_lace, 5, 5)
    LBCorner.view:setFlipX(true)
    LBCorner.view:setFlipY(true)
    local RTCorner = ZBasePanel:create(self.panel_bttm, UILH_PRIVATE.head_lace, panel_bttm_w-45, panel_bttm_h-45)
    RTCorner.view:setFlipX(false)
    RTCorner.view:setFlipY(false)
    local RBCorner = ZBasePanel:create(self.panel_bttm, UILH_PRIVATE.head_lace, panel_bttm_w-45, 5)
    RBCorner.view:setFlipX(false)
    RBCorner.view:setFlipY(true)

	-- 成功率 --------------------
	local scs_rate_lab = UILabel:create_lable_2( LH_COLOR[2] .. Lang.wing[36], 308, 100, 14, ALIGN_LEFT )
	self.panel_bttm:addChild( scs_rate_lab )
	self.scs_rate_value = ZLabel:create(self.panel_bttm, "100%", 373, 100, 14, 1, 1)

	-- 升级按钮 ----------------
	local function go_btn_fun()
        -- dosomething
        WingModel:req_up_wing_level(self.autoBuyBtn.if_selected)
    end
    self.go_btn = ZImageButton:create(self.panel_bttm, UILH_NORMAL.special_btn, 
                                        UILH_WING.up_grade, go_btn_fun, 353, 35, -1, -1, 1)
    self.go_btn.view:addTexWithFile(CLICK_STATE_DISABLE, UILH_NORMAL.special_btn_d )

    -- 需要铜币
    ZLabel:create(self.panel_bttm, LH_COLOR[2] .. Lang.wing[37], 373, 15, 14, 1, 1)
    self.need_bi_value = ZLabel:create(self.panel_bttm, "600", 453, 15, 14, 1, 1)
end

-- ========================================================================
-- 数据更新方法 ===========================================================
-- ========================================================================
-- 更新左面板数据
function WingUpGradePage:update_left_panel_data()
    -- 更新战斗力 --------------------------------------
    local isShowOther = WingModel:getIsShowOtherWing()
    if not isShowOther then
        local fight = WingModel:get_curr_wing_score()
        self.fightVal:init(tostring(fight))
    else
        local fight = WingModel:getOtherWingScore()
        self.fightVal:init(tostring(fight))
    end

    -- 更新当前阶模型
    local modelID = nil
    local isShowOther = WingModel:getIsShowOtherWing()
    if isShowOther then
        -- 判断是否是其他人的翅膀
        local otherWingData = WingModel:getOtherWingData()
        modelID = otherWingData.modelId
    else
        modelID = WingModel:get_curr_modelId()
    end
    self.curPlayerModel:update_wing(modelID)
    self.curPlayerModel:change_attri("body")

    -- 翅膀名字
    local wingNameTxt = WingConfig:get_wing_name( modelID )
    self.name_lab:setText(LH_COLOR[1].. wingNameTxt)
end

-- 更新右面板数据
function WingUpGradePage:update_right_panel_data()
    -- 更新左小面板(当前) 等级
    local curLv = WingModel:get_curr_wing_level()
    local maxLv = WingConfig:get_wing_max_level()
    self.cur_lab:setText( "等级" .. curLv)
    -- 更新当前属性( 攻击，外防，内防，生命 ) ---
    local curAttr = WingModel:get_curr_attr()
    local curAddAttr = WingModel:get_curr_attr_append() 
    self.attack:setText( string.format("%d" .. LH_COLOR[6] .. "+%d", curAttr[1], curAddAttr[1]) )
    self.phyDef:setText( string.format("%d" .. LH_COLOR[6] .. "+%d", curAttr[2], curAddAttr[2]) )
    self.magDef:setText( string.format("%d" .. LH_COLOR[6] .. "+%d", curAttr[3], curAddAttr[3]) )
    self.hp:setText( string.format("%d" .. LH_COLOR[6] .. "+%d", curAttr[4], curAddAttr[4]) )

    if not WingModel:is_max_wing_level() then
        local nextLv = (curLv>=maxLv) and maxLv or (curLv+1)
        self.next_lab:setText( "等级" .. nextLv )
        -- 更新下级属性( 攻击，外防，内防，生命 ) ---
        local nexAttr = WingModel:get_next_attr()
        local nexAddAttr = WingModel:get_next_attr_append()
        self.next_attack:setText( string.format("%d" .. LH_COLOR[6] .. "+%d", nexAttr[1], nexAddAttr[1]) )
        self.next_phyDef:setText( string.format("%d" .. LH_COLOR[6] .. "+%d", nexAttr[2], nexAddAttr[2]) )
        self.next_magDef:setText( string.format("%d" .. LH_COLOR[6] .. "+%d", nexAttr[3], nexAddAttr[3]) )
        self.next_hp:setText( string.format("%d" .. LH_COLOR[6] .. "+%d", nexAttr[4], nexAddAttr[4]) )
    else
        local curLv = WingModel:get_curr_wing_level()
        self.next_lab:setText( "等级" .. curLv )
        -- 更新下级属性( 攻击，外防，内防，生命 ) ---
        local curAttr = WingModel:get_curr_attr()
        local curAddAttr = WingModel:get_curr_attr_append() 
        self.next_attack:setText( string.format("%d" .. LH_COLOR[6] .. "+%d", curAttr[1], curAddAttr[1]) )
        self.next_phyDef:setText( string.format("%d" .. LH_COLOR[6] .. "+%d", curAttr[2], curAddAttr[2]) )
        self.next_magDef:setText( string.format("%d" .. LH_COLOR[6] .. "+%d", curAttr[3], curAddAttr[3]) )
        self.next_hp:setText( string.format("%d" .. LH_COLOR[6] .. "+%d", curAttr[4], curAddAttr[4]) )
    end

    -- 更新材料item 数据 -------------------------------------------------------------------------
    local count = WingModel:get_yuli_crystal_count()
    local needItemId = WingModel:get_cur_level_crystal_item_id()
    self.needItem:set_icon(needItemId)
    self.needItem:set_item_count(count)
    if count > 0 then
        self.needItem:set_icon_light_color()
    else
        self.needItem:set_icon_dead_color()
    end

    -- 最高等级 ----
    -- local maxLv = WingConfig:get_wing_max_level()
    local maxLevelTxt = WingModel:get_curr_stage_max_level()
    self.most_level_lab:setText( string.format( LH_COLOR[2] .. Lang.wing[38] .. LH_COLOR[15] .. "  %d", maxLevelTxt) )
    -- 更新祝福值 ---
    local wishVal = WingModel:get_curr_level_wishes()
    local maxWish = 10
    self.process_bar:setProgressValue( wishVal, maxWish )
end

-- 更新底部元素面板数据
function WingUpGradePage:update_bttm_panel_data()
    -- 更新成功率
    local sucRate = WingModel:get_curr_level_success_rate()
    local addRate = WingConfig:get_zhufu_add_rate( WingModel:get_curr_level_wishes() )
    self.scs_rate_value:setText( string.format("%d%%" .. LH_COLOR[6] .. " +%d%%" .. Lang.wing[39], sucRate, addRate) )

end

-- 升级特效
function WingUpGradePage:playLvUpEffect( parent, x, y )
    LuaEffectManager:stop_view_effect(10014, parent)
    LuaEffectManager:play_view_effect(10014, x, y, parent, false, 10000):setPosition(CCPointMake(x, y))
end


-- 置底，更新
function WingUpGradePage:update( updateType )
    if updateType == "all" then
        self:update_left_panel_data()
        self:update_right_panel_data()
        self:update_bttm_panel_data()
        if WingModel:is_max_wing_level() then
            self.go_btn.view:setCurState(CLICK_STATE_DISABLE)
        end
    elseif updateType == "fight" then
        self:update_left_panel_data()
    elseif updateType == "up_lv_effect" then
        self:playLvUpEffect(self.view, 430, 110)
    elseif updateType == "addItem" then
        local count = WingModel:get_yuli_crystal_count()
        self.needItem:set_item_count(count)
        if count > 0 then
            self.needItem:set_icon_light_color()
        else
            self.needItem:set_icon_dead_color()
        end
    end
end

function WingUpGradePage:destroy( )

end