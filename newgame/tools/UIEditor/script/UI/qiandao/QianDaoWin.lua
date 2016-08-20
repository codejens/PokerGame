-- QianDaoWin.lua
-- created by hcl on 2013/5/21
-- 签到窗口

-- super_class.QianDaoWin(Window)

-- -- 左边距
-- local l_m = 19;
-- -- 下边距
-- local b_m = 39;

-- local title_str = LangGameString[1788]; -- [1788]="#cfff000每月都可免费领取千万经验和海量奖励"
-- local title_str2 = LangGameString[1789]; -- [1789]="#c35c3f7提示:活跃度达到50可以补签哦"

-- local qiandao_award_tips_t = {}

-- function QianDaoWin:show()
--     if ( GameSysModel:isSysEnabled( 45, true ) ) then
--         UIManager:show_window("qiandao_win");
--     end
-- end

-- function QianDaoWin:__init()
--     -- 创建通用的东西，背景图片，关闭按钮，标题
--     -- self:create_common_view();

--     local page_bg = CCBasePanel:panelWithFile(33, 20, 852, 532+50, UIPIC_GRID_nine_grid_bg3, 500, 500)
--     self.view:addChild(page_bg)

--     local date_panel = CCBasePanel:panelWithFile(10, 135+50, 572, 388, "", 500, 500)
--     page_bg:addChild(date_panel)

--     local gain_panel = CCBasePanel:panelWithFile(10, 10, 572, 122+50, "", 500, 500)
--     page_bg:addChild(gain_panel)

--     self.pet_panel = CCBasePanel:panelWithFile(587, 10, 250, 523, "", 500, 500)
--     page_bg:addChild(self.pet_panel)

--     -- 提示文字
--     MUtils:create_zxfont(date_panel, title_str, 98, 355, 1, 16);

--     -- 创建日历
--     self:create_calendar(date_panel);
--     -- 创建领取奖励面板
--     self:create_accept_award_panel(gain_panel)
--     -- 创建满签奖励面板
--     self:max_qd_award_panel(self.pet_panel)

--     qiandao_award_tips_t[1] = ZImage:create(self.view, string.format("%s%s",UIResourcePath.FileLocate.dailyActivity,"exclamation_mark.png"),46,     132+30,24,25,2)
--     qiandao_award_tips_t[2] = ZImage:create(self.view, string.format("%s%s",UIResourcePath.FileLocate.dailyActivity,"exclamation_mark.png"),46+90,  132+30,24,25,2)
--     qiandao_award_tips_t[3] = ZImage:create(self.view, string.format("%s%s",UIResourcePath.FileLocate.dailyActivity,"exclamation_mark.png"),46+90*2,132+30,24,25,2)
--     qiandao_award_tips_t[4] = ZImage:create(self.view, string.format("%s%s",UIResourcePath.FileLocate.dailyActivity,"exclamation_mark.png"),46+90*3,132+30,24,25,2)
--     qiandao_award_tips_t[5] = ZImage:create(self.view, string.format("%s%s",UIResourcePath.FileLocate.dailyActivity,"exclamation_mark.png"),46+90*4,132+30,24,25,2)
-- end

-- -- 创建日历
-- function QianDaoWin:create_calendar(parent)
--     local current_date_table = MUtils:get_current_date(  );
--     -- 取得当前月第一天是星期几
--     local weed = MUtils:find_day_weekend( current_date_table.year,current_date_table.month,1 );
--     -- 取得当月的天数
--     local current_month_days = MUtils:get_month_day_number( current_date_table.year,current_date_table.month)
--     -- 上个月的总天数
--     local last_month_days = 0;
--     -- 上一个月是哪一年
--     local last_month_in_year;
--     local last_month;
--     -- 下一个月是哪一年
--     local next_month_in_year;
--     local next_month;
--     -- 如果当前月是1月
--     if ( current_date_table.month == 1 ) then
--         last_month_days = MUtils:get_month_day_number( current_date_table.year-1,12)
--         -- 上一个月是去年
--         last_month_in_year = current_date_table.year-1;
--         last_month = 12;
--         next_month_in_year = current_date_table.year;
--         next_month = 2;
--     elseif (current_date_table.month == 12 ) then
--         last_month_days = MUtils:get_month_day_number( current_date_table.year,12)
--         -- 上一个月是今年
--         last_month_in_year = current_date_table.year;
--         last_month = 12;
--         -- 下一个月是明年
--         next_month_in_year = current_date_table.year + 1;
--         next_month = 1;
--     else
--         last_month_days = MUtils:get_month_day_number( current_date_table.year,current_date_table.month-1);
--         last_month_in_year = current_date_table.year;
--         last_month = current_date_table.month-1;
--         next_month_in_year = current_date_table.year;
--         next_month = current_date_table.month+1;
--     end

--     -- 左上角的月份图片
--     local month_bg = MUtils:create_zximg(parent, UIResourcePath.FileLocate.qianDao .. "qiandao(27).png", 0, 344, 102, 40);
--     -- 当前月份数
--     MUtils:create_zximg(month_bg, UIResourcePath.FileLocate.qianDao .. "num/"..current_date_table.month..".png", 10, 10, -1, -1);

--     --分割线
--     local line = CCZXImage:imageWithFile(10, 338, 550, 2, UIResourcePath.FileLocate.common .. "jgt_line.png");
--     parent:addChild(line)

--     -- 创建星期几标题
--     local weed_table = {
--         LangGameString[1790],   -- [1790]="星期天"
--         LangGameString[1791],   -- [1791]="星期一"
--         LangGameString[1792],   -- [1792]="星期二"
--         LangGameString[1793],   -- [1793]="星期三"
--         LangGameString[1794],   -- [1794]="星期四"
--         LangGameString[1795],   -- [1795]="星期五"
--         LangGameString[1796]    -- [1796]="星期六"
--     };
--     for i=1,7 do
--         MUtils:create_zxfont(parent, weed_table[i], 42+(i-1)*80, 312, 2, 18);
--     end

--     local day_panel = CCBasePanel:panelWithFile(0, 7, 572, 298, "", 500, 500)
--     parent:addChild(day_panel)

--     local qd_info = QianDaoModel:get_qd_info();
--     local qd_day_table = qd_info.qd_day_table;
--     -- 保存日历控件的每个子控件
--     self.qd_day_view_table = {};
--     -- 创建日历view
--     for i=0,39 do
--         -- 是否周末
--         local is_zhoumo = false;
    
--         local pos_x = 8 + (i%7) * 80;
--         local pos_y = 295-50 - math.floor(i/7)*49
--         -- 第一排当前月1号前的算上个月
--         if ( i < weed and i < 7) then 
--             QDDayView(day_panel, 
--                 pos_x, pos_y,
--                 false, false, 
--                 is_zhoumo,
--                 last_month_in_year, 
--                 last_month,
--                 last_month_days-weed +i+1,
--                 current_date_table.day);
--         -- 大于当前月所有天数的算下个月
--         elseif ( i >= weed + current_month_days ) then
--             QDDayView(day_panel, 
--                 pos_x, pos_y,
--                 false, false,
--                 is_zhoumo,
--                 next_month_in_year,
--                 next_month,
--                 i - weed - current_month_days+1,
--                 current_date_table.day);
--         else
--             if ( i %7== 0 or i%7== 6) then
--                 is_zhoumo = true;
--             end
--             local is_qd = false;
--             local day = i - weed +1;
--             if ( qd_day_table[day] ) then
--                 is_qd = true;
--             end
--            -- print(day..":is_qd ===============",is_qd);
--             self.qd_day_view_table[i] = QDDayView(day_panel, 
--                 pos_x,pos_y, 
--                 is_qd, true, 
--                 is_zhoumo,
--                 current_date_table.year, 
--                 current_date_table.month,
--                 day,
--                 current_date_table.day);
--         end
--     end

--     local function qd_function(eventType,args,msg_id)
--         if eventType == TOUCH_CLICK then
--             -- 如果今天没有签到
--             if ( qd_day_table[current_date_table.day] == nil and self.qd_spr) then 
--                 MiscCC:req_qd();
--                 self.qd_spr:removeFromParentAndCleanup(true);
--                 self.qd_spr = nil;
--                 MUtils:create_sprite(self.qd_btn,UIResourcePath.FileLocate.qianDao .. "qd2.png", 74, 24);
--                 self.qd_btn:setCurState(CLICK_STATE_DISABLE)
--             end
--         end
--         return true
--     end
--     -- 签到按钮
--     self.qd_btn = MUtils:create_btn(parent,
--         UIResourcePath.FileLocate.common .. "dan.png",
--         UIResourcePath.FileLocate.common .. "dan.png",
--         qd_function,
--         410, 6, 148, 48);
--     self.qd_btn:addTexWithFile(CLICK_STATE_DISABLE, UIResourcePath.FileLocate.common .. "dan_d.png")

--     if ( qd_day_table[current_date_table.day] == nil ) then 
--         self.qd_spr = MUtils:create_sprite(self.qd_btn,UIResourcePath.FileLocate.qianDao .. "qiandao(34).png",74, 24);
--         self.qd_btn:setCurState(CLICK_STATE_UP)
--     else
--         MUtils:create_sprite(self.qd_btn,UIResourcePath.FileLocate.qianDao .. "qd2.png", 74, 24);
--         self.qd_btn:setCurState(CLICK_STATE_DISABLE)
--     end
-- end

-- -- 更新签到状态
-- function QianDaoWin:update_qd_state(  )
--     local qd_info = QianDaoModel:get_qd_info();
--     local qd_day_table = qd_info.qd_day_table;
--     local current_date_table = MUtils:get_current_date(  );
--     -- 取得当前月第一天是星期几
--     local weed = MUtils:find_day_weekend( current_date_table.year,current_date_table.month,1 );

--     for i=0,39 do
--         if ( self.qd_day_view_table[i] ) then
--             local day = i - weed +1;
--             if ( qd_day_table[day] ) then
--                 self.qd_day_view_table[i]:qd();
--             end
--         end
--     end

--     -- 更新签到天数
--     local qd_info = QianDaoModel:get_qd_info();
--     self.qd_count:setText(LangGameString[1797]..qd_info.qd_days); -- [1797]="#cfffff7本月签到:"
--     -- 更新领宠剩余天数
--     local left_days = qd_info.left_days;
--     if ( left_days == 0 ) then
--         -- 满签领宠按钮
--         self:create_get_pet_btn( qd_info.is_accept_pet )
--         if ( self.max_qd_title ) then 
--             self.max_qd_title:removeFromParentAndCleanup(true);
--             self.max_qd_title = nil;
--         end
--     else
--         self:create_num_view(max_qd_title, left_days )
--     end
-- end

-- -- 创建领取签到奖励面板
-- function QianDaoWin:create_accept_award_panel(parent)
--     -- 导航栏
--     local raido_btn_group = CCRadioButtonGroup:buttonGroupWithFile(10, 85+30, 90*5, 45, nil);
--     parent:addChild(raido_btn_group);

--     local btn_text = {
--         UIResourcePath.FileLocate.qianDao .. "qiandao(37).png", -- [1798]="签到2次"
--         UIResourcePath.FileLocate.qianDao .. "qiandao(39).png", -- [1799]="签到5次"
--         UIResourcePath.FileLocate.qianDao .. "qiandao(41).png", -- [1800]="签到10次"
--         UIResourcePath.FileLocate.qianDao .. "qiandao(43).png", -- [1801]="签到17次"
--         UIResourcePath.FileLocate.qianDao .. "qiandao(45).png"  -- [1802]="签到26次"
--     };
--     for i=1,5 do
--         local function btn_fun(eventType,args,msg_id)
--             if eventType == TOUCH_CLICK then
--                self:update_award_item_panel( i );
--                 return true;
--             elseif eventType == TOUCH_BEGAN then
                
--                 return true;
--             elseif eventType == TOUCH_ENDED then
--                 return true;
--             end
--         end
--         local x = 90*(i-1);
--         local y = 0;
    
--         local radio_btn = MUtils:create_radio_button(raido_btn_group,
--             UIResourcePath.FileLocate.common .. "xxk-5.png",
--             UIResourcePath.FileLocate.common .. "xxk-6.png",
--             btn_fun, 
--             x, y, 86, 45, false);
--         local btn_img = MUtils:create_zximg(radio_btn, btn_text[i], 42, 16, -1, -1)
--         btn_img:setAnchorPoint(0.5, 0.5)
--     end

--     local panel = CCBasePanel:panelWithFile(0, 0, 572, 85+30, "", 500, 500)
--     parent:addChild(panel)

--     self.slot_item_table = {};
--     -- 奖励道具面板
--     for i=1,5 do
--         self.slot_item_table[i] = MUtils:create_slot_item(panel,
--             UIPIC_ITEMSLOT,
--             12 + (i-1)*72, 27,
--             64, 64);
--         -- self.slot_item_table[i].view:setScaleX(48/60);
--         -- self.slot_item_table[i].view:setScaleY(48/60);
--     end

--     local function get_award_function( eventType,args,msg_id)
--         MiscCC:req_accept_award( self.current_select_award_index );
--         if ( self.current_select_award_index + 1 <= 5 ) then
--             raido_btn_group:selectItem(self.current_select_award_index); 
--             -- 自动切到下一个奖励面板
--             self:update_award_item_panel( self.current_select_award_index + 1 )
--         end
--     end
--     -- 领取按钮
--     self.get_award_btn = ZImageButton:create(panel, { 
--         UIResourcePath.FileLocate.common .. "dan.png",
--         UIResourcePath.FileLocate.common .. "dan.png" },
--         UIResourcePath.FileLocate.qianDao.."qiandao(35).png",
--         get_award_function,
--         410, 28);
--     self.get_award_btn.view:addTexWithFile(CLICK_STATE_DISABLE, UIResourcePath.FileLocate.common .. "dan_d.png")
     
--     -- 当月签到次数
--     local qd_info = QianDaoModel:get_qd_info();
--     self.qd_count = MUtils:create_zxfont(parent, 
--         LangGameString[1797].. qd_info.qd_days,
--         460, 92+30, 1, 16); -- [1797]="#ffffff7本月签到:"

--     self:update_award_item_panel( 1 );
-- end

-- -- 更新奖励道具面板
-- function QianDaoWin:update_award_item_panel( index )
--     -- 记录当前选中的是哪个奖励面板
--     self.current_select_award_index = index;
--     local award_table = QDConfig:get_award_by_index( index ).items;
--     local item_count = #award_table;
--     for i=1,5 do
--         if ( i <= item_count )then
--             self.slot_item_table[i].view:setIsVisible(true);
--             self.slot_item_table[i]:update( award_table[i].itemid ,award_table[i].amount)
--             if ( award_table[i].bind == 1 ) then 
--                 self.slot_item_table[i]:set_lock( true )
--             else
--                 self.slot_item_table[i]:set_lock( false )
--             end
--         else
--             self.slot_item_table[i].view:setIsVisible(false);
--         end
--     end

--     -- 根据服务端的数据变化领取按钮
--     local award_accept_state = QianDaoModel:get_qd_award_info()
--     if ( award_accept_state[index] and award_accept_state[index] == 0 ) then
--         -- 未领取
--         self.get_award_btn:set_image_texture( UIResourcePath.FileLocate.qianDao.."qiandao(35).png" )
--         local qd_days = QianDaoModel:get_qd_info().qd_days;
--         -- 如果没达到签到数字按钮变暗
--         if ( qd_days >= qd_day[index] ) then
--             self.get_award_btn.view:setCurState( CLICK_STATE_UP )
--         else
--             self.get_award_btn.view:setCurState( CLICK_STATE_DISABLE )
--         end
--     else
--         self.get_award_btn:set_image_texture( UIResourcePath.FileLocate.normal.."text_4.png" )
--         self.get_award_btn.view:setCurState( CLICK_STATE_DISABLE )

--     end
-- end

-- -- 更新签到奖励的领取状态提示标签
-- function QianDaoWin:update_qiandao_award_tips( )
--     -- print("打印签到奖励状态提示....................................................")
--     local award_accept_state = QianDaoModel:get_qd_award_info()
--     local qd_days = QianDaoModel:get_qd_info().qd_days
--     for key,value in ipairs(award_accept_state) do
--         if value == 0 then
--             if qd_days >= qd_day[key] then 
--                 qiandao_award_tips_t[key].view:setIsVisible(true)
--             else
--                 qiandao_award_tips_t[key].view:setIsVisible(false)
--             end
--         else
--             qiandao_award_tips_t[key].view:setIsVisible(false)
--         end
--     end
-- end

-- -- 更新按钮状态
-- function QianDaoWin:update_award_accept_btn_state()
--     local index = self.current_select_award_index;
--     -- 根据服务端的数据变化领取按钮
--     local award_accept_state = QianDaoModel:get_qd_award_info()
--     if ( award_accept_state[index] and award_accept_state[index] == 0 ) then
--         -- 未领取
--         self.get_award_btn:set_image_texture( UIResourcePath.FileLocate.qianDao.."qiandao(35).png" )
--         local qd_days = QianDaoModel:get_qd_info().qd_days;
--         -- 如果没达到签到数字按钮变暗
--         if ( qd_days >= qd_day[index] ) then
--             self.get_award_btn.view:setCurState( CLICK_STATE_UP )
--         else
--             self.get_award_btn.view:setCurState( CLICK_STATE_DISABLE )
--         end
--     else
--         self.get_award_btn.view:setCurState( CLICK_STATE_DISABLE )
--         self.get_award_btn:set_image_texture( UIResourcePath.FileLocate.normal.."text_4.png" )
--     end
--     self:update_qiandao_award_tips()
-- end

-- -- 创建满月奖励面板
-- function QianDaoWin:max_qd_award_panel(parent)
--     -- 上
--     local up_panel = CCBasePanel:panelWithFile(0, 224+30, 255, 290, "", 500, 500)
--     parent:addChild(up_panel)

--     -- 宠物背景
--     local pet_bg = CCZXImage:imageWithFile(1, 38, 251, 250, UIResourcePath.FileLocate.qianDao .. "qiandao(24).jpg")
--     up_panel:addChild(pet_bg)
--     self.pet_bg = pet_bg

--     -- 当月满签送靓宠
--     local desc_bg = CCZXImage:imageWithFile(1, 1, 253, 56, UIResourcePath.FileLocate.qianDao .. "qiandao(26).png", 500, 500)
--     up_panel:addChild(desc_bg)

--     local desc_txt = CCZXImage:imageWithFile(54, 6, 146, 24, UIResourcePath.FileLocate.qianDao .. "qiandao(46).png")
--     desc_bg:addChild(desc_txt)

--     -- 奖励宠物信息
--     local month = MUtils:get_current_date().month;
--     local award_pet_info = QDConfig:get_pet_award_by_month( month );

--     -- 宠物名字背景
--     local pet_name_bg = CCZXImage:imageWithFile(127, 266, 117, 30, UIResourcePath.FileLocate.common .. "shit_bg.png")
--     pet_name_bg:setAnchorPoint(0.5, 0.5)
--     up_panel:addChild(pet_name_bg)

--     self.pet_name = MUtils:create_zxfont(pet_name_bg, award_pet_info.pet_name, 60, 6, 2, 18);

--     -- 下
--     local dwn_panel = CCBasePanel:panelWithFile(0, 0, 255, 218+30, "", 500, 500)
--     parent:addChild(dwn_panel)

--     -- 最高资质
--     self.pet_zz = MUtils:create_zxfont(dwn_panel, award_pet_info.zz, 255/2, 184+30, 2, 18);

--     local tf_bg = MUtils:create_zximg(dwn_panel, UIResourcePath.FileLocate.qianDao .. "qiandao(25).png", 130, 150+20, -1, -1)
--     tf_bg:setAnchorPoint(0.5, 0.5)
--     -- 宠物天赋技能
--     local pet_tf = MUtils:create_zximg(tf_bg, UIResourcePath.FileLocate.qianDao .. "qiandao(24).png", 88, 17, -1, -1)
--     pet_tf:setAnchorPoint(0.5, 0.5)

--     -- 技能图标
--     self.skill_icon = MUtils:create_pet_slot_skill(dwn_panel,
--         UIPIC_ITEMSLOT,
--         100, 58+10,
--         64, 64,
--         award_pet_info.skill_id,
--         award_pet_info.skill_level);

--     local skill_struct = PetSkillStruct( nil, award_pet_info.skill_id,award_pet_info.skill_level, 0)

--     local function f1( ... )
--         local a, b, arg = ...
--         local click_pos = Utils:Split(arg, ":")
--         print(click_pos[1],click_pos[2])
--         local world_pos = self.skill_icon.view:getParent():convertToWorldSpace( CCPointMake( tonumber(click_pos[1]),tonumber(click_pos[2]) ) )
--         TipsModel:show_pet_skill_tip( world_pos.x, world_pos.y,skill_struct );
--     end
--     self.skill_icon:set_click_event( f1 )

--     -- 创建宠物和魔法阵
--     -- self.pet_spr = MUtils:create_pet_and_mfz( self.view,608,643,215 )

--     local left_days = QianDaoModel:get_qd_info().left_days;
--     if ( left_days ~= 0 ) then
--         -- 满签到领宠提示
--         -- 再签   次可领靓宠哦
--         local desc_bg = CCZXImage:imageWithFile(1, 1, 253, 56, UIResourcePath.FileLocate.qianDao .. "qiandao(26).png", 500, 500)
--         dwn_panel:addChild(desc_bg)
--         self.max_qd_title = CCZXImage:imageWithFile(12, 7, -1, -1, UIResourcePath.FileLocate.qianDao .. "qiandao(47).png")
--         desc_bg:addChild(self.max_qd_title)

--         self:create_num_view(self.max_qd_title, left_days )
--     else
--         -- 满签领宠按钮
--         self:create_get_pet_btn( parent,QianDaoModel:get_qd_info().is_accept_pet )
--     end
-- end

-- -- 创建满签领宠按钮
-- function QianDaoWin:create_get_pet_btn(parent,is_accept_pet )
--     if ( self.get_pet_btn == nil ) then
--         local function get_pet_function(eventType,args,msg_id)
--             if eventType == TOUCH_CLICK then
--                MiscCC:req_accept_qd_pet( )
--             end
--             return true
--         end
--         if parent == nil  then
--             parent = self.pet_panel
--         end 
--         self.get_pet_btn = MUtils:create_btn(parent,
--             UIResourcePath.FileLocate.common .. "dan.png",
--             UIResourcePath.FileLocate.common .. "dan.png",
--             get_pet_function, 
--             60, 2, 147, 47);
--         self.get_pet_btn:addTexWithFile(CLICK_STATE_DISABLE, UIResourcePath.FileLocate.common .. "dan_d.png")
--         local btn_txt = MUtils:create_zximg(self.get_pet_btn, UIResourcePath.FileLocate.qianDao .. "qiandao(35).png", 73, 23, 109, 28);
--         btn_txt:setAnchorPoint(0.5, 0.5)
--     end
--     if ( is_accept_pet == 1 ) then
--         self.get_pet_btn:setCurState(CLICK_STATE_DISABLE);
--     end
-- end

-- function QianDaoWin:create_num_view(parent, num )
--     if ( num > 31 ) then
--         return;
--     end
--     if parent then
--         self.left_days_label = MUtils:create_zxfont(parent, "", 48, 4, 1, 16)
--         self.left_days_label:setText("#cffff00" .. num )
--     end
-- end

-- function QianDaoWin:active( show )
--     if ( show ) then
--         -- 更新宠物
--         if ( self.pet_spr ) then
--             self.pet_spr:removeFromParentAndCleanup(true);
--         end
--         local month = MUtils:get_current_date().month;
--         local award_pet_info = QDConfig:get_pet_award_by_month( month );
--         -- print("award_pet_info.pet_id",award_pet_info.pet_id);
--         self.pet_spr = self:create_pet( self.pet_bg, award_pet_info.pet_id, 126, 100-30 )
--         self.pet_spr:setAnchorPoint(0.5, 0.5)
--         self:update_qiandao_award_tips()
--         self:update_buqian_tips()
--     end
-- end

-- -- 创建宠物和魔法阵
-- function QianDaoWin:create_pet( parent, pet_id, pos_x, pos_y )
--     local pet_file = string.format("scene/monster/%d",pet_id);
--     local action = {0,0,9,0.2};
--     self.pet_spr = MUtils:create_animation(pos_x,pos_y,pet_file,action )
--     parent:addChild( self.pet_spr );
--     return self.pet_spr;
-- end

-- ---更新补签标签
-- function QianDaoWin:update_buqian_tips( )
--     local today_point = ActivityModel:get_today_point() -- 活跃度是否>50
--     local if_buqian_today = QianDaoModel:get_if_replenish_qd_doday()
--     --能否补签
--     local if_can_bq = false
--     if (today_point>=50) and (if_buqian_today==false) and (QianDaoModel:get_is_need_bq2()==true) then 
--         if_can_bq = true
--     end

--     local btns_t = QianDaoModel:get_buquan_btns()
--     for key,value in ipairs(btns_t) do
--         value:set_buqian( if_can_bq )
--     end
-- end