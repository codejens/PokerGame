-- WingUpDegreePage.lua
-- created by chj on 2014-10-31
-- 翅膀系统升阶翅膀分页

super_class.WingUpDegreePage()

-- ui param
local win_w = 900
local win_h = 605
local align_x = 10
local aligh_x_2 = 10
local radio_b_w = 101 -- 从ui获取的尺寸,radiobtn
local radio_b_h = 45
local panel_w = 900-align_x
local panel_h = win_h-radio_b_h -35

--小面板参数
local panel_up_h 	= 343
local panel_l_w 	= 434
local panel_r_w 	= 434
local panel_bttm_h	= 140 
local panel_bttm_w  = panel_w-aligh_x_2*2

function WingUpDegreePage:__init( )
	self.view = ZBasePanel.new( UILH_COMMON.normal_bg_v2, panel_w, panel_h ).view
    local panel = self.view

    -- 创建3个面板
	self:create_left_panel()
	self:create_right_panle()

	-- 添加一个箭头
	local arrow = CCZXImage:imageWithFile( panel_w*0.5-20, 310, -1, -1, UILH_COMMON.right_arrows )
    self.view:addChild(arrow, 1)

	self:create_bttm_panel()
end

-- 左上面板 =========================================
function WingUpDegreePage:create_left_panel()
	self.panel_left = CCBasePanel:panelWithFile( aligh_x_2, panel_bttm_h+aligh_x_2+2, panel_l_w, panel_up_h, UILH_COMMON.bottom_bg, 500, 500)
	self.view:addChild( self.panel_left )

	-- 当前翅膀title 356
	self.cur_title = CCBasePanel:panelWithFile( 33, panel_up_h-30, -1, -1, UILH_NORMAL.title_bg3, 500, 500)
    self.panel_left:addChild( self.cur_title )
    local cur_lab = UILabel:create_lable_2( LH_COLOR[1] .. Lang.wing[40], 356*0.5, (44-16)*0.5, 16, ALIGN_CENTER )
    self.cur_title:addChild( cur_lab )

    -- -- 背景 195, 329
    -- local left_bg = CCZXImage:imageWithFile(6, 4, 210, -1, UILH_WING.cb_bg)
    -- self.panel_left:addChild( left_bg )
    -- local right_bg = CCZXImage:imageWithFile(210+5, 4, 215, -1, UILH_WING.cb_bg)
    -- right_bg:setFlipX(true)
    -- self.panel_left:addChild( right_bg )

    -- 4个角标 ---------
	local LTCorner = ZBasePanel:create(self.panel_left, UILH_WING.lace, 10, panel_up_h-70)
	LTCorner.view:setFlipX(false)
	LTCorner.view:setFlipY(true)
	local LBCorner = ZBasePanel:create(self.panel_left, UILH_WING.lace, 10, 10)
	LBCorner.view:setFlipX(false)
	LBCorner.view:setFlipY(false)
	local RTCorner = ZBasePanel:create(self.panel_left, UILH_WING.lace, panel_l_w-55, panel_up_h-70)
	RTCorner.view:setFlipX(true)
	RTCorner.view:setFlipY(true)
	local RBCorner = ZBasePanel:create(self.panel_left, UILH_WING.lace, panel_l_w-55, 10)
	RBCorner.view:setFlipX(true)
	RBCorner.view:setFlipY(false)

	-- 战斗力title ---------------------------------------------
	self.fightTitle = CCZXImage:imageWithFile(125, panel_up_h-65, -1, -1, UILH_ROLE.text_zhandouli)
	self.panel_left:addChild( self.fightTitle )
	-- 战斗力value
	self.fightVal = ZXLabelAtlas:createWithString( "8888888", "ui/lh_other/number1_" )
    self.fightVal:setPosition(CCPointMake( 225, panel_up_h-62) )
    self.fightVal:setAnchorPoint( CCPointMake(0, 0) )
    self.panel_left:addChild( self.fightVal )

    -- 当前阶数
    -- 属性最高加成
	ZLabel:create(self.panel_left, LH_COLOR[2] .. "当", 140, 40, 14, 1, 2)
	self.attr_add_most = ZLabel:create(self.panel_left, "", 255, 40, 14, 1, 2)

   	-- 当前人物模型
	self.curPlayerModel = self:createPlayerModel(220, 75)
	self.panel_left:addChild(self.curPlayerModel.avatar)

	-- 翅膀阶星
    local wing_degree = UILabel:create_lable_2( LH_COLOR[2] .. Lang.wing[13], 127, 260, 14, ALIGN_LEFT )
    self.panel_left:addChild( wing_degree)
    self.wing_degree_v = ZLabel:create(self.panel_left, "十阶", 223, 260, 14, 1, 1)
    self.wing_start_v = ZLabel:create(self.panel_left, "4星", 262, 260, 14, 1, 1)

	-- 属性最高加成
	ZLabel:create(self.panel_left, LH_COLOR[2] .. Lang.wing[41], 140, 40, 14, 1, 2)
	self.attr_add_most = ZLabel:create(self.panel_left, "", 255, 40, 14, 1, 2)

	-- 翅膀最高等级
	ZLabel:create(self.panel_left, LH_COLOR[2] .. Lang.wing[42], 140, 15, 14, 1, 1)
	self.wing_level_most = ZLabel:create(self.panel_left, "60", 255, 15, 14, 1, 1)
end

-- 创建人物模型 left
function WingUpDegreePage:createPlayerModel( x, y )
	-- 人物带翅膀的形象
    require "entity/ShowAvatar"
    local showAvatar = ShowAvatar:create_wing_panel_avatar( x, y )
    showAvatar.avatar:setActionStept(ZX_ACTION_STEPT)
    showAvatar.avatar:playAction(ZX_ACTION_IDLE, 4, true)
    return showAvatar
end


-- 右上面板 ===============================================================
function WingUpDegreePage:create_right_panle()
	self.panel_right = CCBasePanel:panelWithFile( panel_l_w+aligh_x_2+2, panel_bttm_h+aligh_x_2+2, panel_r_w, panel_up_h, UILH_COMMON.bottom_bg, 500, 500)
	self.view:addChild( self.panel_right )

	-- 下阶翅膀title 356
	self.next_title = CCBasePanel:panelWithFile( 33, panel_up_h-30, -1, -1, UILH_NORMAL.title_bg3, 500, 500)
    self.panel_right:addChild( self.next_title )
    local next_lab = UILabel:create_lable_2( LH_COLOR[1] .. Lang.wing[43], 356*0.5, (44-16)*0.5, 16, ALIGN_CENTER )
    self.next_title:addChild( next_lab )

    -- 背景 195, 329
    -- local left_bg = CCZXImage:imageWithFile(6, 4, 210, -1, UILH_WING.cb_bg)
    -- self.panel_right:addChild( left_bg )
    -- local right_bg = CCZXImage:imageWithFile(210+5, 4, 215, -1, UILH_WING.cb_bg)
    -- right_bg:setFlipX(true)
    -- self.panel_right:addChild( right_bg )

    -- 4个角标 ---------
	local LTCorner = ZBasePanel:create(self.panel_right, UILH_WING.lace, 10, panel_up_h-70)
	LTCorner.view:setFlipX(false)
	LTCorner.view:setFlipY(true)
	local LBCorner = ZBasePanel:create(self.panel_right, UILH_WING.lace, 10, 10)
	LBCorner.view:setFlipX(false)
	LBCorner.view:setFlipY(false)
	local RTCorner = ZBasePanel:create(self.panel_right, UILH_WING.lace, panel_l_w-55, panel_up_h-70)
	RTCorner.view:setFlipX(true)
	RTCorner.view:setFlipY(true)
	local RBCorner = ZBasePanel:create(self.panel_right, UILH_WING.lace, panel_l_w-55, 10)
	RBCorner.view:setFlipX(true)
	RBCorner.view:setFlipY(false)

	-- 下阶人物模型
	self.nexPlayerModel = self:createPlayerModel(220, 75)
	self.panel_right:addChild(self.nexPlayerModel.avatar)

	-- 属性最高加成
	ZLabel:create(self.panel_right, LH_COLOR[2] .. Lang.wing[41], 140, 40, 14, 1, 2)
	self.next_attr_add_most = ZLabel:create(self.panel_right, "100%", 255, 40, 14, 1, 2)

	-- 翅膀最高等级
	ZLabel:create(self.panel_right, LH_COLOR[2] .. Lang.wing[42], 140, 10, 14, 1, 2)
	self.next_wing_level_most = ZLabel:create(self.panel_right, "60", 255, 10, 14, 1, 2)
end

-- 底部面板
function WingUpDegreePage:create_bttm_panel()
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

	-- 当前属性加成 ------------------
	ZLabel:create(self.panel_bttm, LH_COLOR[2] .. Lang.wing[47], 195, 100, 14, 1, 1)
	self.cur_attr_add = ZLabel:create(self.panel_bttm, "100%", 310, 100, 14, 1, 1)

	-- 十颗星 
	self.panel_star = CCBasePanel:panelWithFile(15, 40, 570, 60, UILH_COMMON.bg_03, 500, 500 )
	self.panel_bttm:addChild( self.panel_star )
	MUtils:drawStart2(self.panel_star, 5)

	-- 升阶按钮 ----------------------
	local function degree_btn_fun()
		WingModel:req_upgrade_stage()
    end
    self.go_btn = ZImageButton:create(self.panel_bttm, UILH_NORMAL.special_btn, 
                                        UILH_WING.up_degree, degree_btn_fun, 655, 40, -1, -1, 1)

    self.go_btn.view:addTexWithFile(CLICK_STATE_DISABLE, UILH_NORMAL.special_btn_d )

    -- 我有声望 
    ZLabel:create( self.panel_bttm, LH_COLOR[2] .. Lang.wing[44], 670, 100, 14, 1, 1 )
    self.reput_own = ZLabel:create( self.panel_bttm, "100", 750, 100, 14, 1, 1 )

    -- 需要的声望
    ZLabel:create( self.panel_bttm, LH_COLOR[2] .. Lang.wing[45], 575, 15, 14, 1, 1 )
    self.reput_need = ZLabel:create( self.panel_bttm, "100", 655, 15, 14, 1, 1 )

    -- 需要铜币
    ZLabel:create( self.panel_bttm, LH_COLOR[2] .. Lang.wing[46], 730, 15, 14, 1, 1 )
    self.bi_need = ZLabel:create( self.panel_bttm, "200", 810, 15, 14, 1, 1 )

end

-- ========================================================================
-- 数据更新方法 ===========================================================
-- ========================================================================
-- 更新左面板数据 ---------------------------------
function WingUpDegreePage:update_left_panel_data()

    -- 更新战斗力 --------------------------------------
    local isShowOther = WingModel:getIsShowOtherWing()
    if not isShowOther then
        local fight = WingModel:get_curr_wing_score()
        self.fightVal:init(tostring(fight))
    else
        local fight = WingModel:getOtherWingScore()
    end

    -- 更新当前阶模型
	local curStage = WingModel:get_curr_wing_stage()
	self.curPlayerModel:update_wing(curStage)
	self.curPlayerModel:change_attri("body")

	-- 翅膀阶星
	local wingStageTxt = WingModel:get_curr_wing_stage()
    self.wing_degree_v:setText(string.format( LH_COLOR[15] .. "%s" .. Lang.wing[26], self:to_word(wingStageTxt)) )  -- #c0edc09%s阶
    local wingStarTxt = WingModel:get_curr_wing_star()
    self.wing_start_v:setText(string.format( LH_COLOR[15] .. "%d" .. Lang.wing[27], wingStarTxt))

    -- 属性最高加成
    local maxAddAttrTxt = WingModel:get_curr_attr_add_limit()
    self.attr_add_most:setText(string.format( LH_COLOR[15] .. "%d%%", maxAddAttrTxt))

    -- 翅膀最高等级
    local maxLevelTxt = WingModel:get_curr_stage_max_level()
    self.wing_level_most:setText(string.format( LH_COLOR[15] .. "%d", maxLevelTxt))
end

-- 数值转化为中文
function WingUpDegreePage:to_word( num )
    local word_t = Lang.wing[28]
    return word_t[num]
end

-- 更行右面板数据 ----------------------------------
function WingUpDegreePage:update_right_panel_data()
	if WingModel:is_max_stage() then
		-- 更新当前阶模型
		local curStage = WingModel:get_curr_wing_stage()
		self.nexPlayerModel:update_wing(curStage)
		self.nexPlayerModel:change_attri("body")

	    -- 属性最高加成
	    local maxAddAttrTxt = WingModel:get_curr_attr_add_limit()
	    self.next_attr_add_most:setText(string.format( LH_COLOR[15] .. "%d%%", maxAddAttrTxt))

	    -- 翅膀最高等级
	    local maxLevelTxt = WingModel:get_curr_stage_max_level()
	    self.next_wing_level_most:setText(string.format( LH_COLOR[15] .. "%d", maxLevelTxt))
	else
		-- 更新下阶模型
		local nexStage = WingModel:get_wing_next_stage()
		print("----------nexStage", nexStage)
		self.nexPlayerModel:update_wing(nexStage)
		self.nexPlayerModel:change_attri("body")

		-- 下阶属性最高加成
	    local nexMaxAddAttrTxt = WingModel:get_next_attr_add_limit()
	    self.next_attr_add_most:setText(string.format( LH_COLOR[15] .. "%d%%", nexMaxAddAttrTxt))

	    -- 翅膀最高等级
	    local nexMaxLevelTxt = WingModel:get_next_stage_max_level()
	    self.next_wing_level_most:setText(string.format( LH_COLOR[15] .. "%d", nexMaxLevelTxt))
	end
end

-- 更新翅膀模型 ----------
function WingUpDegreePage:updatePlayerModel( )
end

-- 更新底部面板数据
function WingUpDegreePage:update_bttm_panel_data()
	-- 当前属性加成
	local addTxt = WingModel:get_curr_attr_add()
	self.cur_attr_add:setText( string.format("%d%%", addTxt) )

	-- 星
	local starNum = WingModel:get_curr_wing_star()
	MUtils:drawStart2(self.panel_star, starNum)


	-- 更新声望 我的声望
	local shengWangTxt = WingModel:get_user_renown()
	self.reput_own:setText( shengWangTxt )

	-- 更新需要声望
	local needShengWangTxt = WingModel:need_renown_upgrade_star()
	self.reput_need:setText(needShengWangTxt)

	-- 更新需要的铜币
	local needMoney = WingModel:need_xb_upgrade_star()
	self.bi_need:setText( needMoney )
end

-- 置底处理
function WingUpDegreePage:update( updateType )
	if updateType == "all" then
        self:update_left_panel_data()
        self:update_right_panel_data()
        self:update_bttm_panel_data()
        if WingModel:is_max_stage_star() then
    		self.go_btn.view:setCurState(CLICK_STATE_DISABLE)
        end
    elseif updateType == "fight" then
    	self:update_left_panel_data()
    elseif updateType == "wing_renown" then
    	-- 更新声望 我的声望
		local shengWangTxt = WingModel:get_user_renown()
		self.reput_own:setText( shengWangTxt )
    end
end

function WingUpDegreePage:destroy( )

end