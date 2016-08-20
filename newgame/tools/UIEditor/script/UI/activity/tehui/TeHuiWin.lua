-- TeHuiWin.lua 
-- created by liuguowang on 2014-4-8
-- 特惠活动窗口
 

super_class.TeHuiWin(NormalStyleWindow)

-- ui param
local radio_b_w = 101 -- 从ui获取的尺寸,radiobtn
local radio_b_h = 45

local NUM = 5
local SCROLL_W,SCROLL_H = 350,198

local _get_btns = {}

local tab_index = 1--1：强化特惠   2：法宝特惠  3：装备特惠

local RIDIO_BTN_STR =  { UILH_MAINACTIVITY.tehui_title_1, UILH_MAINACTIVITY.tehui_title_2, UILH_MAINACTIVITY.tehui_title_3 } --宠物特惠
-- local RIDIO_BTN_STR2 = { UILH_COMMON.button8, UILH_COMMON.button8, UILH_COMMON.button8 } --秘籍特惠
-- local RIDIO_BTN_STR3 = { UILH_COMMON.button8, UILH_COMMON.button8, UILH_COMMON.button8 } --法宝特惠
local TE_HUI_TXT = {"特惠包内容","超级包内容","至尊包内容"}
function TeHuiWin:__init(window_name, window_info)

     TehuiModel:setActivityId(51)
     self.role_name = {}

     self.person_buy_times = {}
     self.server_buy_times = {}
     self.left_big_icon = {} --左侧的大图标  一共三个
     self.left_small_icon = {} --左下侧的大图标  一共三*三个

     self.libao_btn = {} --购买按钮
     self.old_price = {} -- 原价
     self.now_price = {} --现价

     self.small_icon_pos = {}
     for i=1,3 do
        self.small_icon_pos[i] = {}
        for j=1,3 do
            self.small_icon_pos[i][j] = {}
            self.small_icon_pos[i][j].x = 193*(i-1)+16+63*(j-1)
            self.small_icon_pos[i][j].y = 35
        end
     end
    


    self:left_panel(self.view)
    self:right_panel(self.view)
    self:createRadioButtonGroup(self.view)
    self:set_config_data(1)
end

function TeHuiWin:createRadioButtonGroup(basePanel)
    -- 添加分页按钮组
    self.radio_btn_t = {}
    -- 添加分页按钮组
    self.radio_btn_group = CCRadioButtonGroup:buttonGroupWithFile( 35, 528, radio_b_w * 3, radio_b_h, nil)
    basePanel:addChild(self.radio_btn_group)

    -- 添加分页按钮(3个)
    -- 51, 94, 98
    local btn_name_t = { "强化特惠", "装备特惠"}
    --暂时先屏蔽装备特惠
    for i=1, 1 do
        self:create_radio_btn( self.radio_btn_group, btn_name_t[i], i )
    end


    -- local group = ZRadioButtonGroup:create(basePanel, 31, 535, 300, 30);
    -- group:setGrap( 8 )
    -- local btn_str = nil
    -- if TehuiModel:getActivityId() == 51 then
    --     btn_str = RIDIO_BTN_STR3
    -- elseif TehuiModel:getActivityId() == 94 then
    --     btn_str = RIDIO_BTN_STR2
    -- elseif TehuiModel:getActivityId() == 98 then
    --     btn_str = RIDIO_BTN_STR
    -- end
    -- for i=1,3 do
    --     -- local layout = { posX = 0,posY =0,image = btn_str[i] }
    --     local btn = CCRadioButton:radioButtonWithFile(0, 0, -1, -1, UILH_COMMON.tab_gray)
    --     btn:addTexWithFile( CLICK_STATE_DOWN, UILH_COMMON.tab_light)
    --     local jineng_txt = UILabel:create_lable_2( "技 能", 101/2, 10, font_size, ALIGN_CENTER)
    --     btn:addChild(jineng_txt)
    --     group:addItem(btn)
    --     -- group:addItem(btn);
    --     local function btn_fun()
    --         self:do_btn_method( i )
    --         self:set_config_data( i )
    --     end
    --     btn:setTouchClickFun(btn_fun);
    -- end
end

-- 创建 radio_btn
function TeHuiWin:create_radio_btn( radio_group, btn_name, btn_index )
    local radio_btn = CCRadioButton:radioButtonWithFile( 
        radio_b_w*(btn_index-1), 0, -1, -1, UILH_COMMON.tab_gray )
    radio_btn:addTexWithFile( CLICK_STATE_DOWN, UILH_COMMON.tab_light )
    local btn_txt = UILabel:create_lable_2( btn_name, radio_b_w/2, 10, font_size, ALIGN_CENTER)
    radio_btn:addChild( btn_txt )
    radio_group:addGroup( radio_btn )
    local function radio_btn_fun( eventType, x, y )
        if eventType ==  TOUCH_BEGAN then 
            return true
        elseif eventType == TOUCH_CLICK then
            self:do_btn_method( btn_index )
            self:set_config_data( btn_index )
            return true;
        elseif eventType == TOUCH_ENDED then
            return true;
        end
    end
    self.radio_btn_t[btn_index] = radio_btn
    radio_btn:registerScriptHandler( radio_btn_fun )
end

function TeHuiWin:do_btn_method( index )
    tab_index = index;
    self.libao_can_get_num = {}
    MiscCC:req_tehui_sub_info(tab_index) 
end


function TeHuiWin:left_panel(basePanel)--那3个
    self.leftPanel = ZBasePanel:create( basePanel, UILH_COMMON.normal_bg_v2, 10, 10, 880, 525, 600, 600)
    ZImageImage:create( self.leftPanel, UILH_COMMON.fenye_btn, UILH_COMMON.bottom_bg, 15, 13 , 570+16, 500,500,500 )
    -- ZImage:create(self.leftPanel, UILH_COMMON.split_line,15,320,500,1)--分割线
    

    --说明文字
    self.dialog_info = ZDialog:create(nil, nil, 47, 465, 550, 85 ,14)
    self.dialog_info.view:setAnchorPoint(0, 0.5)
    self.dialog_info:setText(LH_COLOR[2].."每购买一次至尊礼包，所有在活动中消费过的玩家都能领取一次至尊送礼")
    basePanel:addChild( self.dialog_info.view )


    --三个大图标
    local pos = {
    [1] = {x= 50+190*0 , y = 330 }, 
    [2] = {x= 50+190*1 , y = 330 }, 
    [3] = {x= 50+191*2 , y = 330 }, 
     }
    
    local txt_pos_x = 0
    local txt_pos_y = 0
    local flag = true
    local tehui_pos_x = 0
    local tehui_pos_y = 0
    local  flag2 = true
    local t_config = TehuiModel:getCurrentConfig()
    for i=1,3 do

        --三个特惠礼包底板
        local  panel_bg = CCBasePanel:panelWithFile(23+190*(i-1), 22, 189, 430, UILH_COMMON.bg_10 ,500,500) 
        self.leftPanel:addChild(panel_bg)
        
        --特惠名称
        local title_bg = ZImage:create(panel_bg, UILH_NORMAL.title_bg6,12,389,-1,-1)
        local title_img = ZImage:create(title_bg, RIDIO_BTN_STR[i],43,28,-1,-1)


        local function buy_fun(  )
            local data = t_config[tab_index][i]
            local avatar = EntityManager:get_player_avatar();
            local need_yuanbao = data.now_price
            if avatar.yuanbao < need_yuanbao then --元宝不足
                local function confirm2_func()
                    GlobalFunc:chong_zhi_enter_fun()
                end
                ConfirmWin2:show( 2, 2, "",  confirm2_func)
            else
                print("tab_index,i",tab_index,i)
                MiscCC:req_get_tehui_libao(tab_index,i,1)
            end
        end

        local data = t_config[tab_index][i]--至尊送礼
        -- ZLabel:create(self.leftPanel, "至尊礼包", pos[i].x+24+38, pos[i].y+75,nil, ALIGN_CENTER)--礼包名字
        -- ZImage:create(self.leftPanel, UILH_COMMON.slot_bg, pos[i].x+20, pos[i].y-3 ,80,80)--道具背景
        print("data.left_big_icon=",data.left_big_icon)

        local function left_big_click_fun()
            local data = t_config[tab_index][i]--至尊送礼
            ActivityModel:show_mall_tips( data.left_big_icon )
        end

        self.left_big_icon[i] = MUtils:create_slot_item(self.leftPanel, UILH_COMMON.slot_bg, pos[i].x+30,pos[i].y+8,80,80,data.left_big_icon,left_big_click_fun)---道具_tehui_slot_id[1][1]
       
        --可购买
        self.person_buy_times[i] = ZLabel:create(self.leftPanel,LH_COLOR[2].."可购买：",pos[i].x+67,pos[i].y-20,16,ALIGN_CENTER)    --可购买

        --购买按钮
        self.libao_btn[i] = ZImageButton:create(self.leftPanel, UILH_COMMON.lh_button_4_r, "", buy_fun,pos[i].x+10,pos[i].y-82,-1,-1)--购买按钮
        local buy_lab = UILabel:create_lable_2( LH_COLOR[2].."立即购买", 23, 20, 16, ALIGN_LEFT)
        self.libao_btn[i]:addChild(buy_lab)

        if flag then
            local  btn_size = self.libao_btn[i]:getSize()
            local txt_size = buy_lab:getSize()
            txt_pos_x = btn_size.width/2 - txt_size.width/2
            txt_pos_y = btn_size.height/2 - txt_size.height/2
            flag = false
        end

        buy_lab:setPosition(txt_pos_x,txt_pos_y+3)
   
        --原价
        self.old_price[i] = ZLabel:create(self.leftPanel,LH_COLOR[2].."原价：",pos[i].x+50+18,pos[i].y-100,14,ALIGN_CENTER)    --原价
        -- ZImage:create(self.old_price[i], UILH_COMMON.split_line_3, -1,5,90)--分割线
    
        --现价
        self.now_price[i] = ZLabel:create(self.leftPanel,LH_COLOR[2].."现价：",pos[i].x+48+20,pos[i].y-133,17,ALIGN_CENTER)    --现价
        
        --删除原价 横线
        ZImage:create(self.leftPanel, UILH_COMMON.split_line_3, pos[i].x+25,pos[i].y-96,90,2)--分割线

        -- ZImage:create(self.leftPanel, UILH_COMMON.split_line, pos[i].x,pos[i].y-106,140,1)--分割线

        self.server_buy_times[i] = ZLabel:create(self.leftPanel,LH_COLOR[2].."本服已购买：" ,pos[i].x+65,pos[i].y-165,14,ALIGN_CENTER)    --本服已购买

        --特惠包内容
        -- ZImageImage:create( self.leftPanel, UILH_NORMAL.title_bg4, "",-100+180*(i-1), 100 , 400, 35,500,500 )
    
        local tehui_bg = ZImage:create(self.leftPanel, UILH_NORMAL.title_bg4, pos[i].x-25,pos[i].y-220,180,35,500,500)
        local tehui_txt = UILabel:create_lable_2( LH_COLOR[1]..TE_HUI_TXT[i], 101/2, 10, font_size, ALIGN_LEFT)
        tehui_bg:addChild(tehui_txt)
        
        if flag2 then
            local tehui_bg_size = tehui_bg:getSize()
            local tehui_txt_size = tehui_txt:getSize()
            tehui_pos_x = tehui_bg_size.width/2 - tehui_txt_size.width/2
            tehui_pos_y = tehui_bg_size.height/2 - tehui_txt_size.height/2+3
        end

        tehui_txt:setPosition(tehui_pos_x,tehui_pos_y)

        self.left_small_icon[i] = {}
        for j=1,3 do
            -- print("data[j].id=",data[j].id)
            local function left_small_click_fun()
                local data = t_config[tab_index][i]--至尊送礼
                ActivityModel:show_mall_tips( data[j].id )
            end
            local id
            if data[j] == nil then
                id = 0
            else
                id = data[j].id
            end
            self.left_small_icon[i][j] = MUtils:create_slot_item2(self.leftPanel, UILH_COMMON.slot_bg,self.small_icon_pos[i][j].x, self.small_icon_pos[i][j].y,60,60, id ,left_small_click_fun)--t_config[1][1]
            self.left_small_icon[i][j]:set_color_frame(nil)
            
            -- if data[j] ~= nil then
            --     self.left_small_icon[i][j].view:setIsVisible(false)
            -- end
            -- print("self.left_small_icon[1][1]=",self.left_small_icon[1][1].id)
        end
    end


end


function TeHuiWin:set_left_small_icon_pos(i,num)--排版
    -- print("%%%%%%%%%%%%%%%%%%%%i=",i)
    -- print("%%%%%%%%%%%%%%%%%%%%num=",num)
    local left_mid_x = ( self.small_icon_pos[i][1].x + self.small_icon_pos[i][2].x )/2
    local right_mid_x = ( self.small_icon_pos[i][2].x + self.small_icon_pos[i][3].x )/2
        
    if num == 1 then
        self.left_small_icon[i][1].view:runAction( CCMoveTo:actionWithDuration(0.2,CCPoint( self.small_icon_pos[i][2].x,self.small_icon_pos[i][2].y) ) )
    elseif num == 2 then
        self.left_small_icon[i][1].view:runAction( CCMoveTo:actionWithDuration(0.2,CCPoint( left_mid_x,self.small_icon_pos[i][1].y) ) )
        self.left_small_icon[i][2].view:runAction( CCMoveTo:actionWithDuration(0.2,CCPoint( right_mid_x,self.small_icon_pos[i][2].y) ) )
    elseif num == 3 then
        self.left_small_icon[i][1].view:runAction( CCMoveTo:actionWithDuration(0.2,CCPoint( self.small_icon_pos[i][1].x,self.small_icon_pos[i][1].y) ) )
        self.left_small_icon[i][2].view:runAction( CCMoveTo:actionWithDuration(0.2,CCPoint( self.small_icon_pos[i][2].x,self.small_icon_pos[i][2].y) ) )
        self.left_small_icon[i][3].view:runAction( CCMoveTo:actionWithDuration(0.2,CCPoint( self.small_icon_pos[i][3].x,self.small_icon_pos[i][3].y) ) )
    end
end

function TeHuiWin:set_config_data(tab)--设置config的data
    print("设置config的data")
    tab_index = tab
    local t_config = TehuiModel:getCurrentConfig()
    for i=1,3 do -- 
        local data = t_config[tab][i]
        self.left_big_icon[i]:set_icon(data.left_big_icon)--大图标
        self.old_price[i]:setText(LH_COLOR[2].."原价" .. data.old_price)--原价
        self.now_price[i]:setText(LH_COLOR[2].."现价" .. data.now_price)--现价
        local num = 0
        for j=1,3 do --下面那些 三个三个的展示小道具图标
            -- print("self.left_small_icon[1][1]=",self.left_small_icon[i][j])
            if self.left_small_icon[i][j] ~= nil then 
              -- print("j=",j)
            -- print("self.left_small_icon[i][j]=",self.left_small_icon[i][j])
                -- print("i=",i)
                -- print("j=",j)
                -- print("data[j].id=",data[j].id)
                if data[j] ~= nil then
                    self.left_small_icon[i][j]:set_icon(data[j].id)
                    self.left_small_icon[i][j]:set_item_count(data[j].num)
                    self.left_small_icon[i][j].view:setIsVisible(true)
                    num = j 
                else
                    self.left_small_icon[i][j].view:setIsVisible(false)
                end
            end
        end
        self:set_left_small_icon_pos(i,num)

    end
    local data = t_config[tab][4]--至尊送礼
    self.right_big_icon:set_icon(data.right_big_icon)

end

function TeHuiWin:right_panel(basePanel)--至尊送礼
    --右边第一层背景
    self.rightPanel = ZBasePanel:create( basePanel, UILH_COMMON.bottom_bg, 598+16, 23, 260, 500, 600, 600)

    --右边第二层背景
    local  panel_bg = CCBasePanel:panelWithFile(10, 8, 240, 420, UILH_COMMON.bg_10 ,500,500) 
    self.rightPanel:addChild(panel_bg)

    --至尊送礼标题
    local title_bg = ZImage:create(self.rightPanel, UILH_MAINACTIVITY.tehui_tiltle_bg,-5,452)
    local title_lab = UILabel:create_lable_2(LH_COLOR[2].."至尊送礼", 101/2, 10, font_size, ALIGN_LEFT)
    title_bg:addChild(title_lab)
    title_lab:setPosition(title_bg:getSize().width/2- title_lab:getSize().width/2,title_bg:getSize().height/2- title_lab:getSize().height/2 )
   

    self.can_get_vip_num = ZLabel:create(self.rightPanel,"",51,406)    --

    --道具框
    local t_config = TehuiModel:getCurrentConfig()
    local data = t_config[tab_index][4]--至尊送礼
    -- print("data.right_big_icon=",data.right_big_icon)

    local function right_big_click_fun()
        local data = t_config[tab_index][4]--至尊送礼
        ActivityModel:show_mall_tips( data.right_big_icon )
    end
    self.right_big_icon = MUtils:create_slot_item(self.rightPanel, UILH_COMMON.slot_bg,92,325,80,80,data.right_big_icon,right_big_click_fun)---道具


    --疑问按钮
    local function question_btn_fun(eventType,x,y)
        HelpPanel:show( 3,UILH_NORMAL.title_tips, "请在活动期间领取礼包，否则活动结束后无法领取！" )
    end
    ZButton:create(self.rightPanel, UILH_NORMAL.wenhao,question_btn_fun,191,345)


    --立即领取按钮
    local function get_zhizun_fun(  )
        MiscCC:req_get_tehui_zhizun_libao(tab_index)
    end
    self.get_btn = ZImageButton:create(self.rightPanel, UILH_NORMAL.special_btn, UI_WELFARE.lingqu, get_zhizun_fun,51,272)--领取按钮
    self.get_btn.view:addTexWithFile(CLICK_STATE_DISABLE,UILH_NORMAL.special_btn_d )

    --购买玩家标题
    local wanjia_title = ZImage:create(self.rightPanel, UILH_NORMAL.title_bg4, 0,235,250,35,nil,600,600)--今日购买人物的那个小框 
    local wanjia_lab = UILabel:create_lable_2(LH_COLOR[1].."今日购买至尊礼包的玩家", 27, 10, font_size, ALIGN_LEFT)
    wanjia_title:addChild(wanjia_lab)
    wanjia_lab:setPosition(wanjia_title:getSize().width/2- wanjia_lab:getSize().width/2,wanjia_title:getSize().height/2- wanjia_lab:getSize().height/2 +3)

    --6个玩家名字
    -- for i=1,4 do
    --     local x = 13+(i-1)%2 * 90
    --     local y = math.floor((i-1)/2) *38

    --     ZImage:create(self.rightPanel, UILH_COMMON.fenye_btn,5+x,51-y)--今日购买人物的那个小框    
    --     self.role_name[i] = ZLabel:create(self.rightPanel,"",x+10+30,59-y,nil,ALIGN_CENTER)    --原价
    -- end
    -- self:create_scroll_panel(basePanel)

end

function TeHuiWin:create_scroll_panel(basePanel ,data )

    --创建或者刷新下拉框
    if (self.wanjia_scroll) then 
        self.wanjia_scroll:clear() --存在需要清空数据
        -- self.wanjia_scroll:setMaxNum(#self.xianhuns)
        self.wanjia_scroll:setMaxNum(#data)
        self.wanjia_scroll:refresh()
    else
       self.wanjia_scroll = CCScroll:scrollWithFile(8,12,240,220,#data,nil,TYPE_HORIZONTAL,500,500);    
       --设滚动条
       self.wanjia_scroll:setScrollLump(UILH_COMMON.up_progress, UILH_COMMON.down_progress, 11, 30, 600 )
       self.wanjia_scroll:setScrollLumpPos( 200+28)
       local arrow_up = CCZXImage:imageWithFile(228 , 209, 11, -1 , UILH_COMMON.scrollbar_up, 500, 500)
       local arrow_down = CCZXImage:imageWithFile(228, 0, 11, -1, UILH_COMMON.scrollbar_down, 500 , 500)
       self.wanjia_scroll:addChild(arrow_up,1)
       self.wanjia_scroll:addChild(arrow_down,1)
       basePanel:addChild(self.wanjia_scroll);
  
        --下拉事件
        local function scrollfun(eventType, args, msg_id)

            if eventType == nil or args == nil or msg_id == nil then 
                 return
            end
        
                local temparg = Utils:Split(args,":")
                local row = temparg[1] +1             -- 行  
            if eventType == nil or args == nil or msg_id == nil then 
                return
            end

            if eventType == TOUCH_BEGAN then
                return true
            elseif eventType == TOUCH_MOVED then
                return true
            elseif eventType == TOUCH_ENDED then
                return true
            elseif eventType == SCROLL_CREATE_ITEM then
                local struct = data[row];
                if struct then
                      -- 每行的背景panel
                    local panel = CCBasePanel:panelWithFile(0,300 - row * 40,270,40,nil,0,0);
                    
                    MUtils:create_zxfont(panel,LH_COLOR[2]..data[row].role_name,117,13,2,16);
                 -- 分割线
                    local line = CCZXImage:imageWithFile( 12, -3, 210, 3, UILH_COMMON.split_line )
                    panel:addChild(line)

                    self.wanjia_scroll:addItem(panel);
                    self.wanjia_scroll:refresh();
                    return false
                end
            end
        end
            self.wanjia_scroll:registerScriptHandler(scrollfun);
            self.wanjia_scroll:refresh();

    end
end

function TeHuiWin:active(active)
    if active == true then
        self:do_btn_method( tab_index )
    end
end

function TeHuiWin:destroy()
    if self.recharge_time_lab then 
        self.recharge_time_lab:destroy()
    end
    Window.destroy(self)
end

function TeHuiWin:update(Type)
    -- print("^^^^^^^^^^^^^^^^^^^^Type=",Type)
    if Type == "control" then
        local index,libao_num,libao_data = TehuiModel:get_libao_data() -- 三个礼包购买
        for i=1,libao_num do
            local num =  1 - libao_data[i].person_buy_times 
            local can_buy_text = string.format( "可买", num )
            self.libao_can_get_num[i] = num
            -- print("can_buy_text=",can_buy_text)
            self.person_buy_times[i]:setText(LH_COLOR[2]..can_buy_text)
            print("已买",libao_data[i].server_buy_times)
            self.server_buy_times[i]:setText( LH_COLOR[2].."本服已购买：" .. libao_data[i].server_buy_times)
        end

        local can_get_times,person_num,zhizun_data = TehuiModel:get_zhizun_data() --至尊送礼
        self.libao_can_get_num[4] = can_get_times
        self.can_get_vip_num:setText(string.format(LH_COLOR[2].."当前可领取数量：%d",can_get_times))

        local pos_index = 1
        print("person_num=",person_num)
        for i=person_num,person_num - 3,-1 do --  2 1 0 -1
            print("~~~~~~~~~~~i=",i)
            -- print("~~~~~~~~~~~zhizun_data[i].role_name=",zhizun_data[i].role_name)

            if i >= 1 then
                -- self.role_name[pos_index]:setText(zhizun_data[i].role_name)
            else
                -- self.role_name[pos_index]:setText("")
            end
            pos_index = pos_index + 1
        end

        self:create_scroll_panel(self.rightPanel,zhizun_data)
        --本小时剩余分钟
        -- local free_time,act_sec,act_times = ZiZiZhuJiModel:get_act_data()
--         self:update_minuter_time(act_sec)
        
--         --上一次获得者名字
--         local pre_exist,pre_name = ZiZiZhuJiModel:get_pre_luck_info()
--         if pre_exist ~= 0 then
--             self.pre_time_geter_num:setText("#cfff000" .. pre_name)
--         else
--             self.pre_time_geter_num:setText("无")
--         end
    elseif Type == "btn" then
        -- if which_c_s == 1 then -- 136的
        -- elseif which_c_s == 2 then -- 137的
            for i=1,3 do
                if self.libao_can_get_num[i] == 0 then
                    self.libao_btn[i].view:setCurState(CLICK_STATE_DISABLE)
                else
                    self.libao_btn[i].view:setCurState(CLICK_STATE_UP)
                end
            end
        -- elseif which_c_s == 3 then -- 138的
            if self.libao_can_get_num[4] == 0 then
                self.get_btn.view:setCurState(CLICK_STATE_DISABLE)
            else
                self.get_btn.view:setCurState(CLICK_STATE_UP)
            end
        -- end 
    elseif Type == "time" then

        --本次活动总倒计时
        if self.recharge_time_lab then 
            self.recharge_time_lab:destroy();
            self.recharge_time_lab = nil;
        end
        local t_activityId = TehuiModel:getActivityId()

        local time = SmallOperationModel:get_act_time( t_activityId )
        print("时间",time)

        local function finish_call(  )
            if self.recharge_time_lab then
              self.recharge_time_lab:setString("0秒")
            end
        end
        -- 充值奖励的倒计时
        self.recharge_time_lab = TimerLabel:create_label( self.rightPanel, 8,436 , 13, time, LH_COLOR[1].."活动倒计时：", finish_call, false,ALIGN_LEFT);  -- lyl ms

        if time == nil or time <= 0 then
            finish_call();
        end  
    end


end

--     end
-- end

