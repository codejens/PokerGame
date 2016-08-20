-- DailyWelfareRU.lua  
-- created by lyl on 2013-3-5
-- VIP返利 右上面板

super_class.DailyWelfareRU(Window)

function DailyWelfareRU:create( width, height)
    return DailyWelfareRU( "DailyWelfareRU", UILH_COMMON.bottom_bg , true, width, height)
end
function DailyWelfareRU:__init( window_name, texture_name )
    local panel = self.view
    local panel_size = panel:getSize()
    local bottom_gas = 20
    -- 标题
    local title_bg = CCZXImage:imageWithFile( 158,121, -1, -1, UILH_NORMAL.title_bg3, 500, 500 )
    -- local title_name =  UILabel:create_lable_2(Lang.benefit.welfare[21], 76, 9, font_size, ALIGN_LEFT ) 
    -- title_bg:addChild(title_name)
    local title_bg_size = title_bg:getSize()
    local title_name = CCZXImage:imageWithFile( 0, 0, -1, -1, UI_WELFARE.vip_fanli, 500, 500 )
    local title_name_size = title_name:getSize()
    title_name:setPosition(title_bg_size.width/2 - title_name_size.width/2,title_bg_size.height/2 - title_name_size.height/2)
    title_bg:addChild(title_name)

    panel:addChild(title_bg)
    
    --多行文本框
    self.explain = MUtils:create_ccdialogEx(panel, "", 30, 12, 600, 100, 1000, 14)
    -- local content = "你当前的VIP等级为X,".. -- [606]="#c66ff66VIP玩家享受VIP#cffff0010级#c66ff66服务的同时更可免",
    --                 "VIP玩家享受VIP#cffff0010级#c66ff66服务的同时更可免".. -- [607]="#c66ff66免费领取每日返回福利.#r #r"
    --                 "每日领取返回福利".. -- [608]="#c66ff661.每日领取#cffff0050忍币#r"
    --                 -- LangGameString[609].. -- [609]="#c66ff662.#cffff00免费#c66ff66无线速传#r"
    --                 -- LangGameString[610] -- [610]="#c66ff663.每日可完成的日常任务数#cffff00+10#r"
    -- self.explain:setText(content)
    
     -- local pos_y = 215
     -- local y_gas = 80
      -- local  text_img_1 = ZImage:create(panel,UILH_RIGHTTOP.second_row_2,68,pos_y - 2*y_gas,77,77)
      -- local  text_img_2 = ZImage:create(panel,UILH_AWARD.baoxiang,68,pos_y-y_gas+65,77,77)
      -- local  text_img_3 = ZImage:create(panel,UILH_RIGHTTOP.second_row_2,68,pos_y,77,77)

    -- 领取
    local function buy_but_callback()
        WelfareModel:get_vip_day_login_award(  )
    end

    --领取按钮
    self.get_but = UIButton:create_button_with_name( 432, 7, -1, -1, UILH_NORMAL.special_btn, UILH_NORMAL.special_btn, nil, "", buy_but_callback )
    self.get_but.view:addTexWithFile(CLICK_STATE_DISABLE, UILH_NORMAL.special_btn_d)
    panel:addChild( self.get_but.view )
    -- self.get_but_name_lable = UILabel:create_lable_2( "", 41, 14, 14, ALIGN_CENTER )
    -- self.get_but.view:addChild( self.get_but_name_lable )


    local get_but_size = self.get_but.view:getSize()
    self.get_but_txt = CCZXImage:imageWithFile( 0, 0, -1, -1, UI_WELFARE.lingqu )
    local get_but_txt_size = self.get_but_txt:getSize()
    self.get_but_txt:setPosition(get_but_size.width/2 - get_but_txt_size.width/2,get_but_size.height/2 - get_but_txt_size.height/2)
    self.get_but.view:addChild(self.get_but_txt)



    -- 成为仙尊
    -- local function vip_but_callback()
    --     ActivityModel:open_vipSys_win(  )
    -- end

    -- --成为VIP玩家
    -- self.vip_but = ZImageButton:create( panel,UIPIC_Secretary_030,UILH_COMMON.button4,vip_but_callback, 146, 22,150,-1 )  -- [611]="成为仙尊"
    -- self.vip_but = UIButton:create_button_with_name( 146, 22, 150, -1, UILH_COMMON.button4, UILH_COMMON.button4, nil, "", vip_but_callback )
    -- panel:addChild( self.vip_but.view )

    --[611]="成为VIP",
    -- self.vip_but_lable = UILabel:create_lable_2( LangGameString[611], 150/2, 22, 16,  ALIGN_CENTER )

    -- self.vip_but.view:addChild( self.vip_but_lable )

    -- self.vip_but.view:setIsVisible( false )


    self:update_explain(  )
    WelfareModel:query_if_had_get_vip_award(  )     -- 申请服务器下发是否已经领取
end

-- 根据是否已经领取vip奖励，更新领取按钮
function DailyWelfareRU:update_get_but(  )
    local if_had_get_vip_award = WelfareModel:get_if_had_get_vip_award(  )
    if if_had_get_vip_award == 1 then
        -- self.get_but_name_lable:setText( LH_COLOR[2]..Lang.benefit.welfare[22]) -- [550]="已领取"
        self.get_but_txt:setTexture(UI_WELFARE.yilingqu)
        self.get_but.view:setCurState( CLICK_STATE_DISABLE )
    elseif if_had_get_vip_award == -1 then
        -- self.get_but_name_lable:setText( LH_COLOR[2]..Lang.benefit.welfare[8]) -- [549]="领取"
        self.get_but_txt:setTexture(UI_WELFARE.lingqu)
        self.get_but.view:setCurState( CLICK_STATE_DISABLE )
    elseif if_had_get_vip_award == 0 then
        -- self.get_but_name_lable:setText( LH_COLOR[2]..Lang.benefit.welfare[8] ) -- [549]="领取"
        self.get_but.view:setCurState( CLICK_STATE_UP )
    end
end

-- 更新奖励信息
function DailyWelfareRU:update_explain(  )
    local vip_level, vip_info, add_task = WelfareModel:get_back_award_explain(  )
    local content = ""

    if vip_level < 1 or vip_info == nil then
        content = Lang.benefit.welfare[24].. -- [612]="#c66ff66您还不是VIP玩家,不能领取奖励.成为VIP后,每日领取大量福利,包括:#r #r"
                  Lang.benefit.welfare[25].. -- [613]="#c66ff661.每日领取免费奖励#r"
                  Lang.benefit.welfare[26].. -- [614]="#c66ff662.每日免费速传#r"
                  Lang.benefit.welfare[27]   -- [615]="#c66ff663.VIP特权功能#r"
        self.get_but.view:setIsVisible( true )
        self.get_but.view:setCurState(CLICK_STATE_DISABLE)
        -- self.vip_but.view:setIsVisible( true )
    else
        local award_value = vip_info.loginAwards[1].value or 0                                                     -- 奖励元宝数
        local transfer = vip_info.quickTelport == -1 and LangGameString[616] or ( LangGameString[617]..vip_info.quickTelport .. LangGameString[618] )   -- 速传次数                                                     -- 奖励数量 -- [616]="免费无限" -- [617]="免费" -- [618]="次"
        content = Lang.benefit.welfare[28]..vip_level..Lang.benefit.welfare[29].. -- [619]="#c66ff66VIP玩家享受VIP#cffff00" -- [620]="级#c66ff66服务的同时更可免费领取每日返回福利.#r #r"
                    LangGameString[621]..award_value..LangGameString[622].. -- [621]="#c66ff661.每日领取#cffff00" -- [622]="忍币#r"
                    "#c66ff662.#cffff00"..transfer..LangGameString[623].. -- [623]="速传#r"
                    LangGameString[624]..add_task -- [624]="#c66ff663.每日可完成的日常任务数#cffff00+"
        self.get_but.view:setIsVisible( true )
        -- self.vip_but.view:setIsVisible( false )
    end
    
    self.explain:setText("")
    self.explain:setText(LH_COLOR[2]..content)
end


--重写destroy
function DailyWelfareRU:destroy( ... )
     Window.destroy(self)
end
