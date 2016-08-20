-- OpenCardWin.lua 
-- created by liuguowang on 2014-4-23
-- 翻牌活动窗口
local HAD_OPEN = 0
local NO_OPEN = 1
local OPENING = 2
local CLOSEING = 3


super_class.OpenCardWin(NormalStyleWindow)

local _is_fixed_all = true; -- 修复全部元宝提示
local _is_fixed_one = true  -- 修复一个元宝提示
local _is_next_wall = true  -- 下一堵墙元宝提示

local m_camera_time = 1
local m_huanpai_time = 2

 require "../data/activity_config/opencard_config"

function OpenCardWin:destroy()
    if self.recharge_time_lab then 
        self.recharge_time_lab:destroy();
    end
end

function OpenCardWin:can_close_win()--是否让用户关掉窗口
    local flag = true
    for i=1,self.card_count do
        if self.card_btn[i].status == OPENING  or self.card_btn[i].status == CLOSEING then
            flag = false
        end  
    end
    if OpenCardModel:get_is_all_open() == true then
        flag = false
    end
    return flag
end

function OpenCardWin:__init(window_name, window_info)
    local panel_base = CCBasePanel:panelWithFile( 10, 10, 880, 550, UILH_COMMON.normal_bg_v2, 500, 500 )
    self.view:addChild( panel_base)
end

function OpenCardWin:onLoad()
    self:left_panel(self.view)
    self:right_panel(self.view)

    -- local function btn_close_fun(eventType,x,y)
    --     if eventType == TOUCH_CLICK then
    --         if self:can_close_win() == true then
    --             UIManager:hide_window("open_card_win");
    --         end
    --     end
    -- end

    -- self.exit_btn.view:registerScriptHandler(btn_close_fun)
end



function OpenCardWin:left_panel(bgPanel)
    -- self.children.leftPanel = ZBasePanel:create( bgPanel, UIResourcePath.FileLocate.common .. "nine_grid_bg3.png", 12, 10, 260, 380, 600, 600)
    -- ZImageImage:create( self.children.leftPanel,UIResourcePath.FileLocate.opencard .. "left_title.png",UIResourcePath.FileLocate.common .. "red_bg.png",0, 345 , 260, 30,500,500 )
    -- ZImageImage:create( self.children.leftPanel,UIResourcePath.FileLocate.opencard .. "left_sub_title.png",UIResourcePath.FileLocate.common .. "quan_bg.png",3, 317 , 254, 30,500,500 )

    --八个展示的
    for i=1,#_open_card_slot_id.show do --下面的
        local item_data = _open_card_slot_id.show[i]
        local function show_item_tip( )--道具显示
            ActivityModel:show_mall_tips( item_data.id )
        end
        local x
        if i >= 5 then
            x = 20+85*(i-5)
        else
            x = 20+85*(i-1)
        end
        local y = 380-85*math.floor(i/5)
        local get_item_solt= MUtils:create_slot_item(self.children.leftPanel, UILH_COMMON.slot_bg, x, y, 83, 83, nil, show_item_tip);
        get_item_solt:set_icon(item_data.id)
        get_item_solt:set_item_count(item_data.num)
    end
    --进度条
    --进度条底图条

    -- ZImage:create( self.children.leftPanel, UIResourcePath.FileLocate.common .. "m_task_panel.png", 5,127,248,32,nil, 600, 600)
    -- self.process_label = ZLabel:create(self.children.leftPanel,"",65,159)--"#c358fc1积分进度(%d/%d)",
    -- ZImage:create( self.children.leftPanel, UIResourcePath.FileLocate.sevenDayAward .. "process_bar.png", 10,133,238,20,nil, 600, 600)
    -----进度条
    -- self.process = ZProgress:create(self.children.leftPanel, 1, 1, 43,135, 170,16, false, "", nil)--ZXProgress:createWithValue( 1, 7, 395, 28 )
    --领取的礼包

    -- 积分进度条 左右添加箭头
    local arrow_left = CCBasePanel:panelWithFile(-15, -7, -1, -1, UILH_NORMAL.progress_left )
    arrow_left:setScale(0.8)
    self.children.process.view:addChild( arrow_left)
    local arrow_right = CCBasePanel:panelWithFile(267, -7, -1, -1, UILH_NORMAL.progress_left)
    arrow_right:setFlipX(true)
    arrow_right:setScale(0.8)
    self.children.process:addChild( arrow_right)

    self.get_item_libao_solt= MUtils:create_slot_item(self.children.leftPanel, UILH_COMMON.slot_bg, 150, 125, 83, 83,nil, nil);

    --礼包领取
    local function get_btn_fun( eventType)
        if eventType == TOUCH_CLICK then
            OpenCardCC:req_get_score_libao()
        end
    end
    -- self.get_libao_btn = ZTextButton:create(self.children.leftPanel,, UIResourcePath.FileLocate.common .. "button2_bg.png", get_btn_fun, 130, 64, 65, 30)
    self.children.get_libao_btn:addImage(CLICK_STATE_DISABLE, UILH_COMMON.btn4_dis)
    self.children.get_libao_btn:addImage(CLICK_STATE_UP, UILH_COMMON.btn4_nor)

    self.children.get_libao_btn.view:registerScriptHandler(get_btn_fun)
    self.children.get_libao_btn.view:setCurState(CLICK_STATE_DISABLE)

    -- ZLabel:create(self.children.leftPanel,Lang.opencard.left_label1,30,35)--"#c358fc1没翻开一张卡片获得#cfff0001积分",
    -- ZLabel:create(self.children.leftPanel,Lang.opencard.left_label2,30,10)--"#c358fc1累计到足够的积分即可领奖",
end

function OpenCardWin:right_panel(bgPanel)
    -- self.children.rightPanel = ZBasePanel:create( bgPanel, UIResourcePath.FileLocate.common .. "nine_grid_bg3.png", 278, 10, 486, 380, 600, 600)
    -- ZImageImage:create( self.children.rightPanel,UIResourcePath.FileLocate.opencard .. "right_title.png",UIResourcePath.FileLocate.common .. "red_bg.png",25, 345 , 433, 30,500,500 )
    
    --疑问按钮
    local function question_btn_fun(eventType,x,y)
        if eventType == TOUCH_CLICK then
            HelpPanel:show( 3, UILH_NORMAL.title_tips, Lang.opencard.question )
        end
    end
    self.children.rule_btn.view:registerScriptHandler(question_btn_fun)
    -- ZButton:create(self.children.rightPanel,UIResourcePath.FileLocate.normal .. "common_question_mark.png",question_btn_fun,455,345)

    local wall_bg = CCBasePanel:panelWithFile( 25, 178, -1, -1, UILH_OPENCARD.wall_bg)
    self.children.rightPanel:addChild( wall_bg)
--几個格子，  --間距
    -- local baseX = 15
    local sizeX = { 64, 114, 163, 212, 261, 311, 360, 408 }
    local sizeY = { 192,192, 192, 192, 192, 192, 192, 192 }
    self.card_btn = {}
    self.item_solt = {}
    for i=1,4*2 do  
        self.card_btn[i] = {}

        local x = sizeX[i]
        local y = sizeY[i]
        -- self.card_btn[i].img = ZButton:create(self.children.rightPanel, UILH_COMMON.bg_07,open_card,x,y,-1,-1)
        self.card_btn[i].img = CCBasePanel:panelWithFile(x, y, -1, -1, UILH_OPENCARD.canvas_path .. i ..".png", 500, 500)
        self.card_btn[i].img:setIsVisible(false)
        self.children.rightPanel:addChild( self.card_btn[i].img)
        self.card_btn[i].img:setAnchorPoint(0.5,0)
        self.card_btn[i].status = NO_OPEN

        -- self.item_solt[i]= MUtils:create_slot_item(self.children.rightPanel, UILH_COMMON.bg_07,x-6,y+27,60,60,nil, nil);
        -- self.item_solt[i].view:setAnchorPoint(0.5,0)
        -- self.item_solt[i].view:setIsVisible(false)
    end

    -- 进度条
    self.label_fix = ZLabel:create(self.children.rightPanel, LH_COLOR[2] .. Lang.Opencard[1], 135, 165, 14, ALIGN_RIGHT)

    self.process_bar_fix = ZXProgress:createWithValueEx(1,10,280,17,UILH_NORMAL.progress_bg2,UILH_NORMAL.progress_bar_orange, true);
    self.process_bar_fix:setPosition(CCPointMake(145,163));
    self.process_bar_fix:setProgressValue( 1, 10 )
    self.children.rightPanel:addChild(self.process_bar_fix,1)

    self.label_fix = ZLabel:create(self.children.rightPanel, LH_COLOR[6] .. Lang.Opencard[2], 220, 138, 14, ALIGN_CENTER)

    -- 下一堵墙
    local function next_wall_func(eventType)
        if eventType == TOUCH_CLICK then
            local avatar = EntityManager:get_player_avatar();
            local need_yuanbao = OpenCardModel:get_nextwall_yuanbao()
            local function local_callback_function()
                if avatar.yuanbao < need_yuanbao then
                    -- GlobalFunc:create_screen_notic( "元宝不足" );
                    local function confirm2_func()
                        UIManager:show_window( "chong_zhi_win" )
                    end
                    ConfirmWin2:show( 2, 2, "",  confirm2_func)
                    return;
                end 
                OpenCardCC:req_get_score(0)
            end

            --确定按钮回调
            local function yes_but_back( ) 
                local_callback_function()
            end 
            --勾选按钮回调
            local function swith_but_back( is_show)
                _is_next_wall = not is_show
            end
            --如果显示提示框
            if _is_next_wall then 
                local content = LH_COLOR[2] .. Lang.Opencard[3] .. LH_COLOR[1] .. need_yuanbao.. LH_COLOR[2] .. Lang.Opencard[15] -- [1598]="是否花费" [453]="元宝" [1358]="立即完成"
                ConfirmWin2:show(5,nil,content,yes_but_back,swith_but_back)
            else
                local_callback_function()
            end 
        end
    end
    self.children.next_wall.view:registerScriptHandler(next_wall_func)

    -- 修复城墙
    local function fix_wall_func(eventType)
        if eventType == TOUCH_CLICK then

            -- 如果有免费次数，直接修复
            local free_time = OpenCardModel:get_num_freefixed( )
            if free_time > 0 then
                OpenCardCC:req_open_card( 0)
                return 
            end

            local num_fixed = OpenCardModel:get_num_fixed( )
            local num_wall = OpenCardModel:get_card_size()
            if num_fixed == num_wall or num_fixed > num_wall then
                GlobalFunc:create_screen_notic( Lang.Opencard[4])
            else
                local avatar = EntityManager:get_player_avatar();
                local need_yuanbao = OpenCardModel:get_fixed_one_yuanbao( )
                local function local_callback_function()
                    local num_free = OpenCardModel:get_num_freefixed( )
                    if num_free > 0 then
                        OpenCardCC:req_open_card( 0)
                        return 
                    end
                    print("---------", avatar.yuanbao , need_yuanbao )
                    if avatar.yuanbao < need_yuanbao then
                        -- GlobalFunc:create_screen_notic( "元宝不足" );
                        local function confirm2_func()
                            UIManager:show_window( "chong_zhi_win" )
                        end
                        ConfirmWin2:show( 2, 2, "",  confirm2_func)
                        return;
                    end 
                    OpenCardCC:req_open_card( 0)
                end

                --确定按钮回调
                local function yes_but_back( ) 
                    local_callback_function()
                end 
                --勾选按钮回调
                local function swith_but_back( is_show)
                    _is_fixed_one = not is_show
                end
                --如果显示提示框
                if _is_fixed_one then 
                    local content = LH_COLOR[2] .. Lang.Opencard[3] .. LH_COLOR[1] .. need_yuanbao.. LH_COLOR[2] .. Lang.Opencard[15] -- [1598]="是否花费" [453]="元宝" [1358]="立即完成"
                    ConfirmWin2:show(5,nil,content,yes_but_back,swith_but_back)
                else
                    local_callback_function()
                end 
            end
        end
    end
    self.children.fix_wall.view:registerScriptHandler(fix_wall_func)

    --一键翻牌
    local function yijian_opencard_fun(eventType)
        if eventType == TOUCH_CLICK then
            local num_fixed = OpenCardModel:get_num_fixed( )
            local num_wall = OpenCardModel:get_card_size()
            if num_fixed == num_wall or num_fixed > num_wall then
                GlobalFunc:create_screen_notic( Lang.Opencard[4])
            else
                -- local lave_times ,free_times ,score,get_award_num  = OpenCardModel:get_other_data()
                local lave_times, free_times, num_fixed, score_layer, score, state_get, num_gift = OpenCardModel:get_other_data()
                if num_gift >= #_open_card_slot_id.get_libao then
                    GlobalFunc:create_screen_notic(Lang.opencard.had_get_all_libao)
                    return true
                end
                local need_gezi = 8
                if ItemModel:check_bag_need_gezi(need_gezi) == false then
                    local str = string.format( Lang.Opencard[5], need_gezi)
                    print("str=",str)
                    NormalDialog:show(str,nil,2)
                    return true
                end
                local libao_data = _open_card_slot_id.get_libao[num_gift+1]

                if score < score_layer then
                    -- function sure_fun()
                    local avatar = EntityManager:get_player_avatar();
                    local need_yuanbao = OpenCardModel:get_yijian_yuanbao()

                    local function local_callback_function()
                        if avatar.yuanbao < need_yuanbao then
                            -- GlobalFunc:create_screen_notic( "元宝不足" );
                            local function confirm2_func()
                                UIManager:show_window( "chong_zhi_win" )
                            end
                            ConfirmWin2:show( 2, 2, "",  confirm2_func)
                            return;
                        end 
                        OpenCardModel:req_open_card(1)  -- 1代表一键翻牌
                    end

                    --确定按钮回调
                    local function yes_but_back( ) 
                        local_callback_function()
                    end 
                    --勾选按钮回调
                    local function swith_but_back( is_show)
                        _is_fixed_all = not is_show
                    end
                    --如果显示提示框
                    if _is_fixed_all then 
                        local content = LH_COLOR[2] .. Lang.Opencard[3] .. LH_COLOR[1] .. need_yuanbao.. LH_COLOR[2] .. Lang.Opencard[16] .. LH_COLOR[1] .. num_wall-num_fixed .. LH_COLOR[2].. Lang.Opencard[11] -- [1598]="是否花费" [453]="元宝" [1358]="立即完成"
                        ConfirmWin2:show(5,nil,content,yes_but_back,swith_but_back)
                    else
                        local_callback_function()
                    end 
                else
                    GlobalFunc:create_screen_notic(Lang.Opencard[6])
                end
            end
        end
    end
    -- self.all_fix_wall = ZImageButton:create( self.children.rightPanel,UIResourcePath.FileLocate.common .. "button2_red.png",UIResourcePath.FileLocate.opencard .. "yijianquanpai.png",yijian_opencard_fun,     245, 7 ,131,40,nil,600,600 ) 
    self.children.all_fix_wall.view:registerScriptHandler(yijian_opencard_fun)

    -- self.today_lave_time = ZLabel:create(self.children.rightPanel,"",90+155*0,54,14)--"#c358fc1今日剩余次数：#cfff000",
    -- self.need_yuanbao_lave_card  = ZLabel:create(self.children.rightPanel,"",90+155*1,54,14)--"#c358fc1使用#cfff000%s元宝#c358fc1翻开剩余仙章",

end





function OpenCardWin:active(active)
    if active == true then
        OpenCardCC:req_card_info()

        local flag = OpenCardModel:get_is_all_open()
        -- if flag == true then
        --     for i=1,self.card_count do
        --         self.card_btn[i].img.view:setCurState(CLICK_STATE_UP)
        --         OpenCardCC:req_get_score(1)
        --         self.card_btn[i].status = NO_OPEN
        --         self.item_solt[i].view:setIsVisible(false)
        --     end
        -- end
    end
end

function OpenCardWin:CameraStop(item_data,i)--动画播放完
    function show_item_tip(eventType)
        if eventType == TOUCH_CLICK then
            ActivityModel:show_mall_tips( item_data[i].id )
            return true
        end
    end

    self.item_solt[i].view:setIsVisible(true)
    self.item_solt[i].view:registerScriptHandler(show_item_tip)
    self.item_solt[i]:set_icon(item_data[i].id)
    self.item_solt[i]:set_item_count(item_data[i].num)

end

function OpenCardWin:update(Type)
--本次活动总倒计时
    if Type == "time" then
        if self.recharge_time_lab then 
            self.recharge_time_lab:destroy();
            self.recharge_time_lab = nil;
        end
        local time = SmallOperationModel:get_act_time( 39 ); --翻牌 活动id=39
        -- print("time=",time);
        local function finish_call(  )
            if self.recharge_time_lab then
              self.recharge_time_lab:setString("0秒")
            end
        end
        -- 充值奖励的倒计时
        self.tip = ZLabel:create(self.children.rightPanel, LH_COLOR[6] .. Lang.Opencard[7], 130, 450, 14, ALIGN_LEFT, 1)
        self.recharge_time_lab = TimerLabel:create_label( self.children.rightPanel, 230, 450 ,14, time, LH_COLOR[6] .. "", finish_call, false, ALIGN_LEFT)  -- lyl ms

        if time == nil or time <= 0 then
            finish_call();
        end 
    elseif Type == "card" or Type == "card_init"  then

    elseif Type == "control" then --更新控件
        --"#c358fc1今日剩余次数：#cfff000",
        local lave_times, free_times, num_fixed, score_layer, score, state_get, num_gift = OpenCardModel:get_other_data()
        -- print("-----------------chj:", lave_times, free_times, num_fixed, score_layer, score, state_get, num_gift )

        -- 进度条
        if num_fixed > 8 then
            num_fixed = 8
        end
        self.process_bar_fix:setProgressValue( num_fixed, 8 )
        self.label_fix:setText( LH_COLOR[6] .. Lang.Opencard[8] .. LH_COLOR[1] .. num_fixed .. "/8" .. LH_COLOR[6] .. Lang.Opencard[9])

        --根据修城次数更新城墙
        for i=1, #self.card_btn do
            self.card_btn[i].img:setIsVisible(false)
        end
        for i=1, num_fixed do
            self.card_btn[i].img:setIsVisible(true)
        end

        -- 今日剩余次数
        self.children.today_lave_time:setText( LH_COLOR[6] .. Lang.Opencard[11] .. LH_COLOR[1] .. lave_times .. LH_COLOR[6] .. Lang.Opencard[11])
        -- 今日免费次数
        if free_times > 0 then
            self.children.today_free_time:setText( LH_COLOR[6] .. Lang.Opencard[12] .. LH_COLOR[1] .. free_times .. LH_COLOR[6] .. Lang.Opencard[11])
        else
            local cost_fixed = OpenCardModel:get_fixed_one_yuanbao( )
            self.children.today_free_time:setText( LH_COLOR[6] .. Lang.Opencard[13] .. LH_COLOR[1] .. cost_fixed .. LH_COLOR[6] .. Lang.Opencard[14])
        end

        ------------------------------------------------------------
        --领取礼包道具图标
        local libao_data = _open_card_slot_id.get_libao[num_gift+1]
        ---如果get_award_num=#_open_card_slot_id.get_libao 返回值为 libao_data =nil

        local function show_item_tip( eventType )--礼包道具显示
            if eventType == TOUCH_CLICK then
                -- local lave_times ,free_times ,score,num_gift  = OpenCardModel:get_other_data()
                local lave_times, free_times, num_fixed, score_layer, score, state_get, num_gift = OpenCardModel:get_other_data()

                if libao_data ~= nil and num_gift < #_open_card_slot_id.get_libao then
                    ActivityModel:show_mall_tips( libao_data.id )
                end
                return true
            end
        end
        if libao_data ~= nil and num_gift < #_open_card_slot_id.get_libao  then --
            self.get_item_libao_solt:set_icon(libao_data.id)
            self.get_item_libao_solt:set_item_count(libao_data.num)
            self.get_item_libao_solt.view:registerScriptHandler(show_item_tip)
        else--全部领取完了  libao_data = nil
            self.get_item_libao_solt:set_icon_ex(nil)
            self.get_item_libao_solt:set_item_count(1)
        end
        --领取礼包按钮
        -- if libao_data ~= nil and score >= libao_data.point  then
        if state_get ~= 0 then
            self.children.get_libao_btn.view:setCurState(CLICK_STATE_UP)
        else
            self.children.get_libao_btn.view:setCurState(CLICK_STATE_DISABLE)
        end
        ------------------------------------------------------------
        --更新进度条
        if libao_data ~= nil and num_gift < #_open_card_slot_id.get_libao then 
            -- self.children.process:setProgressValue(score,libao_data.point)
            self.children.process:setProgressValue(score,score_layer)
            local str = string.format( LH_COLOR[1] .. Lang.opencard.left_label3,score, score_layer)
            self.children.process_label:setText(str)
        else--全部礼包领取完
            libao_data = _open_card_slot_id.get_libao[num_gift]
            self.children.process:setProgressValue(score,libao_data.point)
            local str = string.format( LH_COLOR[5] .. Lang.opencard.left_label3,score,libao_data.point)
            self.children.process_label:setText(str)
        end
        ------------------------------------------------------------
        --换牌按钮
        self.card_count = OpenCardModel:get_card_size()
        local open_count = OpenCardModel:get_open_count()
        -- if open_count > 0 and open_count < self.card_count then
        --     self.huanpai_btn.view:setCurState(CLICK_STATE_UP)
        -- else
        --     self.huanpai_btn.view:setCurState(CLICK_STATE_DISABLE)
        -- end
        --一键翻牌按钮
        if open_count < self.card_count then
            self.children.all_fix_wall.view:setCurState(CLICK_STATE_UP)
        else
            self.children.all_fix_wall.view:setCurState(CLICK_STATE_DISABLE)
        end

        if lave_times == 0 or num_gift == #_open_card_slot_id.get_libao then --如果剩余翻牌次数 或 全部领完
            self.children.all_fix_wall.view:setCurState(CLICK_STATE_DISABLE)
            -- self.huanpai_btn.view:setCurState(CLICK_STATE_DISABLE)
        end

        --一键翻牌按钮在其他地方刷新    check_need_open_card

    end
end

function OpenCardWin:is_all_had_open()
    local flag = true
    print("self.card_count=",self.card_count)
    for i=1,self.card_count do
        print("self.card_btn[i].status=",self.card_btn[i].status)
        if self.card_btn[i].status ~= HAD_OPEN then
            return false
        end
    end
    return flag
end

function OpenCardWin:get_is_last_close(index) --判断是否是最后一个旋转回来
    local flag = true
    for i=1,self.card_count do
        if i ~= index then
            if self.card_btn[i].status ~= NO_OPEN then --如果还有没有返回来的
                flag = false
            end
        end
    end
    return flag
end

function OpenCardWin:get_all_card_stop() --判断是否所有牌都是在静止
    local flag = true
    for i=1,self.card_count do
        if self.card_btn[i].status == CLOSEING or self.card_btn[i].status == OPENING then --如果还有没有返回来的
            flag = false
        end
    end
    return flag
end

function OpenCardWin:sure_huanpai_fun(tag) -- tag=0 收费翻牌   tag = 1 免费翻牌 
            -- if lave_times > 0 then 
    for i=1,self.card_count do
                   
        if self.card_btn[i].status == HAD_OPEN then
            self.card_btn[i].status = CLOSEING
            --参数分别为旋转的时间，起始半径，半径差，起始z角，旋转z角差，起始x角，旋转x角差，用法如下
            if self.children.not_play_animation:getCheck() == false then
                local jiaodu = (i-1)%4+1  --CCOrbitCamera
                self.card_btn[i].img.view:runAction(CCOrbitCamera:actionWithDuration(m_camera_time/2, 1, 0, 0,90+jiaodu*7,0, 0))
                            
                local function cb()
                            -- 立起来以后变状态
                    self.card_btn[i].img.view:setCurState(CLICK_STATE_UP)
                    self.card_btn[i].img.view:runAction(CCOrbitCamera:actionWithDuration(m_camera_time/2, 1, 0,90+jiaodu*7,90-jiaodu*7,0, 0))
                    local function cb2()
                        self.card_btn[i].status = NO_OPEN
                        if self:get_is_last_close() == true then
                            print(" huan pai fun tag = " ,tag)
                            OpenCardCC:req_get_score(tag)
                        end
                    end

                    local _cb2 = callback:new();
                    _cb2:start( m_camera_time/2,cb2 )
                end
                local _cb = callback:new();
                _cb:start( m_camera_time/2,cb )
            else
                self.card_btn[i].status = NO_OPEN
                self.card_btn[i].img.view:setCurState(CLICK_STATE_UP)
                if self:get_is_last_close() == true then
                    print(" huan pai fun tag = " ,tag)
                    OpenCardCC:req_get_score(tag)
                end
            end
                        -- self.card_btn[i].img.view:setCurState(CLICK_STATE_DISABLE)
            self.item_solt[i].view:setIsVisible(true)
        end
    end
end

--检查是否需要自动免费翻牌
function OpenCardWin:check_need_open_card()

    local lave_times, free_times, num_fixed, score_layer, score, state_get, num_gift = OpenCardModel:get_other_data()
    -- local lave_times ,free_times ,score,get_award_num  = OpenCardModel:get_other_data()

    local flag = self:is_all_had_open()
    print("~~flag=",flag)
    if flag == true then
        local function huanpai_fun( )
            self:sure_huanpai_fun(1)
        end
        local _cb = callback:new();
        _cb:start( m_huanpai_time,huanpai_fun)
        -- self.all_fix_wall.view:setCurState(CLICK_STATE_DISABLE)
    end
end

