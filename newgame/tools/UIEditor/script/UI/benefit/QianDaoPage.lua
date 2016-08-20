-- QianDaoPage.lua
-- created by guozhinna on 2014/11/7
-- 签到分页，天降雄师改为分页了

super_class.QianDaoPage(Window)

local qiandao_award_tips_t = {}

--创建工厂方法
function QianDaoPage:create(  )
    return QianDaoPage( "QianDaoPage", UILH_COMMON.bottom_bg , true, 880, 520 )
end

function QianDaoPage:__init()

    -- 人为创建右背景
    local right_bg = CCZXImage:imageWithFile(260, 13, 610, 160, UILH_COMMON.bottom_bg,500,500);
    self.view:addChild(right_bg)

    local right_bg_top = CCZXImage:imageWithFile(260, 178, 610, 335, UILH_COMMON.bottom_bg,500,500);
    self.view:addChild(right_bg_top)

    local date_panel = CCBasePanel:panelWithFile(261, 119, 610, 388, "", 500, 500)
    self.view:addChild(date_panel)

    self.gain_panel = CCBasePanel:panelWithFile(261, 13, 610, 170, "", 500, 500)
    self.view:addChild(self.gain_panel)

    self.pet_panel = CCBasePanel:panelWithFile(7, 13, 250, 500, UILH_COMMON.bottom_bg, 500, 500)
    self.view:addChild(self.pet_panel)

    self.qd_day = QianDaoModel:get_qd_day_cfg()

    -- 提示文字
    MUtils:create_zxfont(date_panel, Lang.benefit.qiandao[4], 137, 363, 1, 16);

    -- 创建日历
    self:create_calendar(date_panel);
    -- 创建领取奖励面板
    self:create_accept_award_panel(self.gain_panel)
    -- 创建满签奖励面板
    self:max_qd_award_panel(self.pet_panel)

    qiandao_award_tips_t[1] = ZImage:create(self.view, UILH_BENEFIT.warning,340,     147,24,25,2)
    qiandao_award_tips_t[2] = ZImage:create(self.view, UILH_BENEFIT.warning,340+90,  147,24,25,2)
    qiandao_award_tips_t[3] = ZImage:create(self.view, UILH_BENEFIT.warning,340+90*2,147,24,25,2)
    qiandao_award_tips_t[4] = ZImage:create(self.view, UILH_BENEFIT.warning,340+90*3,147,24,25,2)
    qiandao_award_tips_t[5] = ZImage:create(self.view, UILH_BENEFIT.warning,340+90*4,147,24,25,2)

    self:active(true);
end

-- 创建日历
function QianDaoPage:create_calendar(parent)
    local current_date_table = MUtils:get_current_date(  );
    -- 取得当前月第一天是星期几
    local weed = MUtils:find_day_weekend( current_date_table.year,current_date_table.month,1 );
    -- 取得当月的天数
    local current_month_days = MUtils:get_month_day_number( current_date_table.year,current_date_table.month)
    -- 上个月的总天数
    local last_month_days = 0;
    -- 上一个月是哪一年
    local last_month_in_year;
    local last_month;
    -- 下一个月是哪一年
    local next_month_in_year;
    local next_month;
    -- 如果当前月是1月
    if ( current_date_table.month == 1 ) then
        last_month_days = MUtils:get_month_day_number( current_date_table.year-1,12)
        -- 上一个月是去年
        last_month_in_year = current_date_table.year-1;
        last_month = 12;
        next_month_in_year = current_date_table.year;
        next_month = 2;
    elseif (current_date_table.month == 12 ) then
        last_month_days = MUtils:get_month_day_number( current_date_table.year,12)
        -- 上一个月是今年
        last_month_in_year = current_date_table.year;
        last_month = 12;
        -- 下一个月是明年
        next_month_in_year = current_date_table.year + 1;
        next_month = 1;
    else
        last_month_days = MUtils:get_month_day_number( current_date_table.year,current_date_table.month-1);
        last_month_in_year = current_date_table.year;
        last_month = current_date_table.month-1;
        next_month_in_year = current_date_table.year;
        next_month = current_date_table.month+1;
    end

    -- 左上角的月份图片
    local month_bg = MUtils:create_zximg(parent, UILH_BENEFIT.month_bg, -2, 355, -1, -1);
    -- 当前月份数
    MUtils:create_zximg(month_bg, UIResourcePath.FileLocate.lh_benefit .. "month_"..current_date_table.month..".png", 10, 6, -1, -1);

    -- 创建星期几标题
    local weed_table = {
        LangGameString[1790],   -- [1790]="星期天"
        LangGameString[1791],   -- [1791]="星期一"
        LangGameString[1792],   -- [1792]="星期二"
        LangGameString[1793],   -- [1793]="星期三"
        LangGameString[1794],   -- [1794]="星期四"
        LangGameString[1795],   -- [1795]="星期五"
        LangGameString[1796]    -- [1796]="星期六"
    };
    for i=1,7 do
        MUtils:create_zxfont(parent, weed_table[i], 42+(i-1)*86, 327, 2, 16);
    end

    local day_panel = CCBasePanel:panelWithFile(0, 37, 600, 298, "", 500, 500)
    parent:addChild(day_panel)

    local qd_info = QianDaoModel:get_qd_info();
    local qd_day_table = qd_info.qd_day_table;
    -- 保存日历控件的每个子控件
    self.qd_day_view_table = {};
    -- 创建日历view
    for i=0,39 do
        -- 是否周末
        local is_zhoumo = false;
    
        local pos_x = 5 + (i%7) * 86;
        local pos_y = 295-50 - math.floor(i/7)*42
        -- 第一排当前月1号前的算上个月
        if ( i < weed and i < 7) then 
            QDDayView(day_panel, 
                pos_x, pos_y,
                false, false, 
                is_zhoumo,
                last_month_in_year, 
                last_month,
                last_month_days-weed +i+1,
                current_date_table.day);
        -- 大于当前月所有天数的算下个月
        elseif ( i >= weed + current_month_days ) then
            QDDayView(day_panel, 
                pos_x, pos_y,
                false, false,
                is_zhoumo,
                next_month_in_year,
                next_month,
                i - weed - current_month_days+1,
                current_date_table.day);
        else
            if ( i %7== 0 or i%7== 6) then
                is_zhoumo = true;
            end
            local is_qd = false;
            local day = i - weed +1;
            if ( qd_day_table[day] ) then
                is_qd = true;
            end
           -- print(day..":is_qd ===============",is_qd);
            self.qd_day_view_table[i] = QDDayView(day_panel, 
                pos_x,pos_y, 
                is_qd, true, 
                is_zhoumo,
                current_date_table.year, 
                current_date_table.month,
                day,
                current_date_table.day);
        end
    end

    local function qd_function(eventType,args,msg_id)
        if eventType == TOUCH_CLICK then
            -- 如果今天没有签到
            Instruction:handleUIComponentClick(instruct_comps.QIANDAO_WIN_BTN2)   
            Analyze:parse_click_main_menu_info(252)
            if ( qd_day_table[current_date_table.day] == nil and self.qd_spr) then
                MiscCC:req_qd();
                self.qd_spr:removeFromParentAndCleanup(true);
                self.qd_spr = nil;
                self.qd_btn:setCurState(CLICK_STATE_DISABLE)
                if self.yqd_spr then
                    self.yqd_spr:setIsVisible(true)
                end
            end
        end
        return true
    end
    -- 签到按钮
    self.qd_btn = MUtils:create_btn(parent,UILH_NORMAL.special_btn,UILH_NORMAL.special_btn,qd_function,438, 60, -1, -1);
    self.qd_btn:addTexWithFile(CLICK_STATE_DISABLE, UILH_NORMAL.special_btn_d)

    if ( qd_day_table[current_date_table.day] == nil ) then
        self.qd_spr = MUtils:create_sprite(self.qd_btn,UILH_BENEFIT.dianjiqiandao,81, 26.5);
        self.yqd_spr = MUtils:create_sprite(self.qd_btn,UILH_BENEFIT.yiqiandao, 81, 26.5);
        self.yqd_spr:setIsVisible(false)
        self.qd_btn:setCurState(CLICK_STATE_UP)
    else
        MUtils:create_sprite(self.qd_btn,UILH_BENEFIT.yiqiandao, 81, 26.5);
        self.qd_btn:setCurState(CLICK_STATE_DISABLE)
    end
end

-- 更新签到状态
function QianDaoPage:update_qd_state(  )
    local qd_info = QianDaoModel:get_qd_info();
    local qd_day_table = qd_info.qd_day_table;
    local current_date_table = MUtils:get_current_date(  );
    -- 取得当前月第一天是星期几
    local weed = MUtils:find_day_weekend( current_date_table.year,current_date_table.month,1 );

    for i=0,39 do
        if ( self.qd_day_view_table[i] ) then
            local day = i - weed +1;
            if ( qd_day_table[day] ) then
                self.qd_day_view_table[i]:qd();
            end
        end
    end

    -- 更新签到天数
    local qd_info = QianDaoModel:get_qd_info();
    self.qd_count:setText(Lang.benefit.qiandao[10]..qd_info.qd_days); -- [1797]="#cfffff7本月签到:"
    -- 更新领宠剩余天数
    local left_days = qd_info.left_days;
    if ( left_days == 0 ) then
        -- 满签领宠按钮
        self:create_get_pet_btn( self.pet_panel,qd_info.is_accept_pet )
        if self.left_days_label then
            self.left_days_label:setIsVisible(false)
        end
    else
        local text_tip = string.format(Lang.benefit.qiandao[3],left_days)
        if self.left_days_label then
            self.left_days_label:setText(text_tip)
            self.left_days_label:setIsVisible(true)
        else
            self.left_days_label = MUtils:create_zxfont(self.pet_panel, text_tip, 15, 23, 1, 16);
        end
        if self.get_pet_btn then
            self.get_pet_btn:setIsVisible(false)
        end
    end
end

-- 创建领取签到奖励面板
function QianDaoPage:create_accept_award_panel(parent)
    -- 导航栏
    local raido_btn_group = CCRadioButtonGroup:buttonGroupWithFile(5, 115, 90*5, 45, nil);
    parent:addChild(raido_btn_group);

    local btn_text = {
        Lang.benefit.qiandao[5], -- [1798]="签到2次"
        Lang.benefit.qiandao[6], -- [1799]="签到5次"
        Lang.benefit.qiandao[7], -- [1800]="签到10次"
        Lang.benefit.qiandao[8], -- [1801]="签到17次"
        Lang.benefit.qiandao[9]  -- [1802]="签到26次"
    };
    for i=1,5 do
        local function btn_fun(eventType,args,msg_id)
            if eventType == TOUCH_CLICK then
               self:update_award_item_panel( i );
                return true;
            elseif eventType == TOUCH_BEGAN then
                
                return true;
            elseif eventType == TOUCH_ENDED then
                return true;
            end
        end
        local x = 5+90*(i-1);
        local y = 0;
    
        local radio_btn = MUtils:create_radio_button(raido_btn_group,UILH_COMMON.button_2_n,UILH_COMMON.button_2_s,
            btn_fun, x, y, -1, -1, false);
        MUtils:create_zxfont(radio_btn, btn_text[i],46, 10, 2, 15);
        -- local btn_img = MUtils:create_zximg(radio_btn, btn_text[i], 42, 16, -1, -1)
        -- btn_img:setAnchorPoint(0.5, 0.5)
    end

    local panel = CCBasePanel:panelWithFile(5, 9, 597, 106, UILH_COMMON.bg_02, 500, 500)
    parent:addChild(panel)

    self.slot_item_table = {};
    -- 奖励道具面板
    for i=1,5 do
        self.slot_item_table[i] = MUtils:create_slot_item2(panel,UILH_COMMON.slot_bg,12 + (i-1)*85, 23,64, 64,nil,nil,9.5);
        -- self.slot_item_table[i].view:setScaleX(48/60);
        -- self.slot_item_table[i].view:setScaleY(48/60);
    end

    local function get_award_function( eventType,args,msg_id)
        MiscCC:req_accept_award( self.current_select_award_index );
        Instruction:handleUIComponentClick(instruct_comps.QIANDAO_WIN_BTN1)
        if ( self.current_select_award_index + 1 <= 5 ) then
            raido_btn_group:selectItem(self.current_select_award_index); 
            -- 自动切到下一个奖励面板
            self:update_award_item_panel( self.current_select_award_index + 1 )
        end
        -- 再把警告符号，也就是感叹号去掉
        if qiandao_award_tips_t[self.current_select_award_index] and qiandao_award_tips_t[self.current_select_award_index].view then
            qiandao_award_tips_t[self.current_select_award_index].view:setIsVisible(false)
        end
    end
    -- 领取按钮
    self.get_award_btn = ZImageButton:create(panel,UILH_NORMAL.special_btn,UILH_BENEFIT.lingqujiangli,
        get_award_function,431, 40);
    self.get_award_btn.view:addTexWithFile(CLICK_STATE_DISABLE, UILH_NORMAL.special_btn_d)
     
    -- 当月签到次数
    local qd_info = QianDaoModel:get_qd_info();
    self.qd_count = MUtils:create_zxfont(parent, Lang.benefit.qiandao[10].. qd_info.qd_days,450, 32, 1, 14); -- [1797]="#ffffff7本月签到:"

    self:update_award_item_panel( 1 );
end

-- 更新奖励道具面板
function QianDaoPage:update_award_item_panel( index )
    -- 记录当前选中的是哪个奖励面板
    self.current_select_award_index = index;
    local award_table = QDConfig:get_award_by_index( index ).items;
    local item_count = #award_table;
    for i=1,5 do
        if ( i <= item_count )then
            self.slot_item_table[i].view:setIsVisible(true);
            self.slot_item_table[i]:update( award_table[i].itemid ,award_table[i].amount,nil,-3,-3,70,70)
            if ( award_table[i].bind == 1 ) then 
                self.slot_item_table[i]:set_lock( true )
            else
                self.slot_item_table[i]:set_lock( false )
            end
        else
            self.slot_item_table[i].view:setIsVisible(false);
        end
    end

    -- 根据服务端的数据变化领取按钮
    local award_accept_state = QianDaoModel:get_qd_award_info()
    if ( award_accept_state[index] and award_accept_state[index] == 0 ) then
        -- 未领取
        self.get_award_btn:set_image_texture( UILH_BENEFIT.lingqujiangli )
        local qd_days = QianDaoModel:get_qd_info().qd_days;
        -- 如果没达到签到数字按钮变暗
        if ( qd_days >= self.qd_day[index] ) then
            self.get_award_btn.view:setCurState( CLICK_STATE_UP )
        else
            self.get_award_btn.view:setCurState( CLICK_STATE_DISABLE )
        end
    else
        self.get_award_btn:set_image_texture( UILH_BENEFIT.yilingqu )
        self.get_award_btn.view:setCurState( CLICK_STATE_DISABLE )

    end
end

-- 更新签到奖励的领取状态提示标签
function QianDaoPage:update_qiandao_award_tips( )
    -- print("打印签到奖励状态提示....................................................")
    local award_accept_state = QianDaoModel:get_qd_award_info()
    local qd_days = QianDaoModel:get_qd_info().qd_days
    for key,value in ipairs(award_accept_state) do
        if value == 0 then
            if qd_days >= self.qd_day[key] then 
                qiandao_award_tips_t[key].view:setIsVisible(true)
            else
                qiandao_award_tips_t[key].view:setIsVisible(false)
            end
        else
            qiandao_award_tips_t[key].view:setIsVisible(false)
        end
    end
end

-- 更新按钮状态
function QianDaoPage:update_award_accept_btn_state()
    local index = self.current_select_award_index;
    -- 根据服务端的数据变化领取按钮
    local award_accept_state = QianDaoModel:get_qd_award_info()
    if ( award_accept_state[index] and award_accept_state[index] == 0 ) then
        -- 未领取
        self.get_award_btn:set_image_texture( UILH_BENEFIT.lingqujiangli )
        local qd_days = QianDaoModel:get_qd_info().qd_days;
        -- 如果没达到签到数字按钮变暗
        if ( qd_days >= self.qd_day[index] ) then
            self.get_award_btn.view:setCurState( CLICK_STATE_UP )
        else
            self.get_award_btn.view:setCurState( CLICK_STATE_DISABLE )
        end
    else
        self.get_award_btn.view:setCurState( CLICK_STATE_DISABLE )
        self.get_award_btn:set_image_texture( UILH_BENEFIT.yilingqu )
    end
    self:update_qiandao_award_tips()
end

-- 创建满月奖励面板
function QianDaoPage:max_qd_award_panel(parent)

    -- 宠物背景
    local pet_bg = CCZXImage:imageWithFile(5, 259, -1, -1, "nopack/BigImage/pet_bg1.png")
    parent:addChild(pet_bg)
    self.pet_bg = pet_bg
    -- 宠物背景上的花纹
    local pet_bg_pattern = CCZXImage:imageWithFile(120, 215, -1, -1, UILH_BENEFIT.pattern1)
    pet_bg_pattern:setAnchorPoint(0.5,0.5)
    pet_bg:addChild(pet_bg_pattern)
    -- 花纹上的宣传语
    MUtils:create_zxfont(pet_bg_pattern, Lang.benefit.qiandao[1], 90, 10, 2, 15);

    -- 下
    local info_panel_height = 210
    local info_panel = CCBasePanel:panelWithFile(5, 46, 234, info_panel_height, nil)
    parent:addChild(info_panel)

    -- 分割线
    local line = CCZXImage:imageWithFile( 8, 200, 227, 3, UILH_COMMON.split_line )
    info_panel:addChild(line)

    -- 奖励宠物信息
    local month = MUtils:get_current_date().month;
    local award_pet_info = QDConfig:get_pet_award_by_month( month );
    -- 宠物名字
    self.pet_name = MUtils:create_zxfont(info_panel, award_pet_info.pet_name, 117, info_panel_height-38, 2, 18);

    -- 最高资质
    self.pet_zz = MUtils:create_zxfont(info_panel, award_pet_info.zz, 20, 143, 1, 16);
    -- 文字：携带技能
    MUtils:create_zxfont(info_panel, Lang.benefit.qiandao[2], 20, 95, 1, 16);

    -- 技能图标
    self.skill_icon = MUtils:create_pet_slot_skill2(info_panel,UILH_NORMAL.item_bg2,130, 60,64, 64,
        award_pet_info.skill_id,award_pet_info.skill_level);

    local skill_struct = PetSkillStruct( nil, award_pet_info.skill_id,award_pet_info.skill_level, 0)

    local function f1( ... )
        local a, b, arg = ...
        local click_pos = Utils:Split(arg, ":")
        print(click_pos[1],click_pos[2])
        local world_pos = self.skill_icon.view:getParent():convertToWorldSpace( CCPointMake( tonumber(click_pos[1]),tonumber(click_pos[2]) ) )
        TipsModel:show_pet_skill_tip( world_pos.x, world_pos.y,skill_struct );
    end
    self.skill_icon:set_click_event( f1 )

    -- 分割线
    local line = CCZXImage:imageWithFile( 8, 12, 227, 3, UILH_COMMON.split_line )
    info_panel:addChild(line)

    local left_days = QianDaoModel:get_qd_info().left_days;
    if ( left_days ~= 0 ) then
        -- 满签到领宠提示
        -- 再签   次可领靓宠哦
        local text_tip = string.format(Lang.benefit.qiandao[3],left_days)
        self.left_days_label = MUtils:create_zxfont(parent, text_tip, 15, 23, 1, 16);
        -- self:create_num_view(self.max_qd_title, left_days )
    else
        -- 满签领宠按钮
        self:create_get_pet_btn( parent,QianDaoModel:get_qd_info().is_accept_pet )
    end

end

-- 创建满签领宠按钮
function QianDaoPage:create_get_pet_btn(parent,is_accept_pet )
    if ( self.get_pet_btn == nil ) then
        local function get_pet_function(eventType,args,msg_id)
            if eventType == TOUCH_CLICK then
                self.get_pet_btn:setCurState(CLICK_STATE_DISABLE)
                MiscCC:req_accept_qd_pet( )
            end
            return true
        end
        if parent == nil  then
            parent = self.pet_panel
        end 
        self.get_pet_btn = MUtils:create_btn(parent,UILH_NORMAL.special_btn,UILH_NORMAL.special_btn,get_pet_function, 44, 4, -1, -1);
        self.get_pet_btn:addTexWithFile(CLICK_STATE_DISABLE, UILH_NORMAL.special_btn_d)
        local btn_txt = MUtils:create_zximg(self.get_pet_btn, UILH_BENEFIT.lingqujiangli, 81, 27, -1, -1);
        btn_txt:setAnchorPoint(0.5, 0.5)
    end
    self.get_pet_btn:setIsVisible(true)
    if ( is_accept_pet == 1 ) then
        self.get_pet_btn:setCurState(CLICK_STATE_DISABLE);
    else
        self.get_pet_btn:setCurState(CLICK_STATE_UP);
    end
end

-- function QianDaoPage:create_num_view(parent, num )
--     if ( num > 31 ) then
--         return;
--     end
--     if parent then
--         self.left_days_label = MUtils:create_zxfont(parent, "", 48, 4, 1, 16)
--         self.left_days_label:setText("#cffff00" .. num )
--     end
-- end

-- 创建宠物和魔法阵
function QianDaoPage:create_pet( parent, pet_id, pos_x, pos_y )
    local pet_file = string.format("scene/monster/%d",pet_id);
    local action = {0,0,9,0.2};
    print("pet_file",pet_file)
    self.pet_spr = MUtils:create_animation(pos_x,pos_y,pet_file,action )
    parent:addChild( self.pet_spr );
    return self.pet_spr;
end

---更新补签标签
function QianDaoPage:update_buqian_tips( )
    local today_point = ActivityModel:get_today_point() -- 活跃度是否>50
    local if_buqian_today = QianDaoModel:get_if_replenish_qd_doday()
    --能否补签
    local if_can_bq = false
    if (today_point>=50) and (if_buqian_today==false) and (QianDaoModel:get_is_need_bq2()==true) then 
        if_can_bq = true
    end

    local btns_t = QianDaoModel:get_buquan_btns()
    for key,value in ipairs(btns_t) do
        value:set_buqian( if_can_bq )
    end
end

function QianDaoPage:active( show )
    if ( show ) then
        -- 更新宠物
        if ( self.pet_spr ) then
            self.pet_spr:removeFromParentAndCleanup(true);
        end
        local month = MUtils:get_current_date().month;
        local award_pet_info = QDConfig:get_pet_award_by_month( month );
        self.pet_spr = self:create_pet( self.pet_bg, award_pet_info.pet_id, 126, 50 )
        self.pet_spr:setAnchorPoint(0.5, 0.5)
        self:update_qiandao_award_tips()
        self:update_buqian_tips()
    end
end

function QianDaoPage:update()
    self:active(true)
end