-- DailyWelfareLU.lua  
-- created by lyl on 2013-3-5
-- 每日登陆奖励 左上面板 

super_class.DailyWelfareLU(Window)

local _page_max_index = 10
function DailyWelfareLU:create(width,height)
    return DailyWelfareLU( "DailyWelfareLU", UILH_COMMON.bottom_bg , true, width, height)
end

function DailyWelfareLU:__init( window_name, window_info )
    local bgPanel = self.view
    self.get_panel_t = {}            -- 存储所有获取面板.  key 为该面板对应的序列号（见create_get_panel方法）

    self.vip_get_panel_t = {}

	local panel = self.view

    self.item_scroll = nil           -- 奖励道具区域

    self.vip_item_scroll = nil       --vip用户奖励道具区域

    -- 标题 每日登陆奖励
    local title_bg = CCZXImage:imageWithFile( 158+13,266, -1, -1, UILH_NORMAL.title_bg3, 500, 500 )
    -- local title_name =  UILabel:create_lable_2(Lang.benefit.welfare[21], 76, 9, font_size, ALIGN_LEFT ) 
    local title_bg_size = title_bg:getSize()
    local title_name = CCZXImage:imageWithFile( 0, 0, -1, -1, UI_WELFARE.denglu_txt, 500, 500 )
    local title_name_size = title_name:getSize()
    title_name:setPosition(title_bg_size.width/2 - title_name_size.width/2,title_bg_size.height/2 - title_name_size.height/2)
    title_bg:addChild(title_name)
    panel:addChild(title_bg)

    
    --妹子
    ZImage:create(self.view,"nopack/girl.png",-365,-313,-1,-1)
    --普通玩家标题背景
    local text_bg_cmomon=  ZImageImage:create( bgPanel,UI_WELFARE.comon_man,UI_WELFARE.text_bg,71+18, 207 , 190, -1,500,500 )  

    --分割线
    -- ZImage:create(bgPanel, UI_WELFARE.split_line, 6, 230, 203,3)

    --普通玩家
    --奖励列表底板
    local  panel1 = CCBasePanel:panelWithFile(30-15, 57, 270+60, 120, "", 500, 500 )
    panel:addChild(panel1)


    --普通玩家向左
    local function left_but_callback()
        local index = self.item_scroll:getCurIndexPage()
        if index - 1 >= 0 then
            self.item_scroll.view:setCurIndexPage(index - 1)
        end
    end
    self.left_but = UIButton:create_button_with_name( 8, 10, -1, -1, UILH_COMMON.arrow_normal, UILH_COMMON.arrow_normal, nil, "", left_but_callback )
    panel1:addChild( self.left_but.view )
    

    --普通玩家向右
    local function right_but_callback()
        local index = self.item_scroll:getCurIndexPage()
        if index + 1 < _page_max_index then
            self.item_scroll.view:setCurIndexPage(index + 1)
        end
    end
    self.right_but = UIButton:create_button_with_name( 230+60, 10, -1, -1, UILH_COMMON.arrow_normal, UILH_COMMON.arrow_normal, nil, "", right_but_callback )
    self.right_but.view:setFlipX(true)
    panel1:addChild( self.right_but.view )


--底板2  vip
    --vip玩家 
        --vip玩家标题背景
    local text_bg_vip=  ZImageImage:create( bgPanel,UI_WELFARE.vip_man,UI_WELFARE.text_bg,414+5, 207 , 190, -1,500,500 )  
 

    local panel2 = CCBasePanel:panelWithFile(377-30, 57, 270+60, 120, "", 500, 500 )
    panel:addChild(panel2)

    --vip玩家向左
    local function vip_left_but_callback()
        local index = self.vip_item_scroll:getCurIndexPage()
        if index - 1 >= 0 then
            self.vip_item_scroll.view:setCurIndexPage(index - 1)
        end
    end
    self.vip_left_but = UIButton:create_button_with_name( 8, 10, -1, -1, UILH_COMMON.arrow_normal, UILH_COMMON.arrow_normal, nil, "", vip_left_but_callback )
    panel2:addChild( self.vip_left_but.view )
    
    --vip玩家向右
    local function vip_right_but_callback()
        local index = self.vip_item_scroll:getCurIndexPage()
        if index + 1 < _page_max_index then
            self.vip_item_scroll.view:setCurIndexPage(index + 1)
        end
    end
    self.vip_right_but = UIButton:create_button_with_name( 230+60, 10, -1, -1, UILH_COMMON.arrow_normal, UILH_COMMON.arrow_normal, nil, "", vip_right_but_callback )
    self.vip_right_but.view:setFlipX(true)
    panel2:addChild( self.vip_right_but.view )

    
    --请求普通玩家和ＶＩＰ玩家奖励列表
    WelfareModel:request_login_award_list(  )
end

---=====================================================================================================------
local flag = false
-- 创建奖品列表  普通玩家 奖品列表
function DailyWelfareLU:create_award_list(  )
    -- xprint("正在更新   DailyWelfareLU:create_award_list(  )")
     local list = nil
    local function create_Scroll_item( no_user, index )

       list = List:create( nil, 0, 0, 180+60, 160, 3, 1)
        local get_panel = nil
        for i = 1, 3 do
            get_panel = self:create_get_panel( index * 3 + i )
            list:addItem( get_panel )
        end
        -- get_panel = self:create_get_panel( index+1)
        -- list:addItem( get_panel )
       
        return list
    end
    
    self.item_scroll = ScrollPage:create( nil, 75-18, 30, 180+70, 160, _page_max_index, TYPE_VERTICAL_EX, 1)
    --self.item_scroll:setScrollRunType(RUN_TYPE_PAGE)
    self.item_scroll:setScrollCreatFunction(create_Scroll_item)
    self.item_scroll:refresh()
    return self.item_scroll
end

-- 创建一个领取面板 普通玩家
function DailyWelfareLU:create_get_panel( index )
    -- 如果已经创建过，就不创建
    if self.get_panel_t[ index ] then
        return self.get_panel_t[ index ]
    end

    local award_info = WelfareModel:get_award_by_index( index )
    local item_id = award_info.item_id
    local get_panel = {}         -- 获取的对象
    get_panel.index = index      -- 获取面板的序列号
    get_panel.view = CCBasePanel:panelWithFile(0, 0, 90, 150, "", 500, 500 )
    local item_base = ItemConfig:get_item_by_id( item_id )
    if item_base == nil then
        return get_panel
    end
    
    --登录**天
    get_panel.day_lable = UILabel:create_lable_2( LH_COLOR[2]..Lang.benefit.welfare[31]..index..Lang.benefit.welfare[32], 46, 144, 14,  ALIGN_CENTER ) 
    get_panel.view:addChild( get_panel.day_lable )
    
    --道具的框
    get_panel.slot = SlotItem( 60, 60 )
    get_panel.slot:set_icon_bg_texture( UILH_COMMON.slot_bg,  -9,  -9, 60+18, 60+18 )   -- 背框
    get_panel.slot:setPosition( 16, 67 )
    get_panel.slot:set_icon( item_id )
    get_panel.view:addChild( get_panel.slot.view )
    get_panel.slot:set_gem_level( item_id ) 

    local function item_click_fun( ... )
        local a, b, arg = ...
        local position = Utils:Split(arg,":");
        local pos = get_panel.slot.view:getParent():convertToWorldSpace( CCPointMake( tonumber(position[1]),tonumber(position[2]) ) )

        ActivityModel:show_mall_tips( item_id,pos.x,pos.y )
    end
    get_panel.slot:set_click_event(item_click_fun)

    -- 领取按钮
    -- get_panel.get_but = CCNGBtnMulTex:buttonWithFile( 18, 0, 56, 28, "ui/common/button2_bg.png", 500, 500)
    -- get_panel.get_but:addTexWithFile( CLICK_STATE_DOWN, "ui/common/button2_bg.png" )
    local function but_1_fun( eventType, x, y )
        if eventType == TOUCH_CLICK then
            WelfareModel:request_get_award_by_index( index,1,false )
        end
        return true;
    end
    -- get_panel.get_but = UIButton:create_button_with_name2( get_panel.view, 19, 0, LangGameString[549], but_1_fun ) -- [549]="领取"
    -- get_panel.get_but,get_panel.get_but_lab = MUtils:create_common_btn( get_panel.view, "三个字", but_1_fun, 2, 0 ) -- [549]="领取"
    local btn = CCNGBtnMulTex:buttonWithFile( 7, 0, -1, -1,UILH_COMMON.button4,TYPE_MUL_TEX);
    btn:addTexWithFile(CLICK_STATE_DISABLE, UILH_COMMON.button4_dis)

    if ( but_1_fun ) then
        btn:registerScriptHandler(but_1_fun);
    end

    get_panel.view:addChild(btn,0);
    
    --领取文字
    -- local size = btn:getSize();
    -- local lab = MUtils:create_zxfont(btn,"三个字",size.width/2,size.height/2-7,2,20);
     local lab = UILabel:create_lable_2(Lang.benefit.welfare[8], 15, 14, 14, ALIGN_LEFT ) 
     local btn_size = btn:getSize()
     local lab_size = lab:getSize()
     lab:setPosition(btn_size.width/2- lab_size.width/2,btn_size.height/2-lab_size.height/2+3)

    get_panel.get_but,get_panel.get_but_lab = btn,lab;
    -- get_panel.get_but:registerScriptHandler( but_1_fun )                  --注册
    -- get_panel.view:addChild( get_panel.get_but )
    -- get_panel.get_but_lable = UILabel:create_lable_2( "领取", 25, 10, 14,  ALIGN_CENTER )
    get_panel.get_but:addChild( get_panel.get_but_lab )

    -- 根据当前状态，更新领取面板的显示
    get_panel.update_get_state = function(  )
        local state = WelfareModel:get_award_state_by_index( index )
        if state == 0 then                        -- 不可领取状态， 按钮显示 领取， 不可点击
            get_panel.get_but_lab:setString(LH_COLOR[2]..Lang.benefit.welfare[8] ) -- [549]="领取"

            get_panel.get_but:setCurState( CLICK_STATE_DISABLE )
        elseif state == 1 then                    -- 未领取状态， 按钮显示 领取， 可点击
            get_panel.get_but_lab:setString( LH_COLOR[2]..Lang.benefit.welfare[8]  ) -- [549]="领取"

            get_panel.get_but:setCurState( CLICK_STATE_UP )
        elseif state == 2 then                    -- 已领取状态， 按钮显示 已领取， 可点击
            get_panel.get_but_lab:setString(LH_COLOR[2]..Lang.benefit.welfare[22] ) -- [550]="已领取"
             get_panel.get_but_lab:setPosition(btn_size.width/2- lab_size.width/2-8,btn_size.height/2-lab_size.height/2+3)
            get_panel.get_but:setCurState( CLICK_STATE_DISABLE )
        end
    end

    get_panel.update_get_state(  ) 
    
    self.get_panel_t[ index ] = get_panel
    safe_retain(get_panel.view)           -- 不让它被释放，不重复创建
    return get_panel
end

---=====================================================================================================------

--创建VIP奖励列表
function DailyWelfareLU:create_vip_award_list(  )

    local function create_Scroll_item_vip( no_user, index )
        local list = List:create( nil, 0, 0, 180+60, 160, 3, 1)
        local get_panel = nil

        for i = 1, 3 do
             get_panel = self:create_vip_get_panel( index*3+i)
            list:addItem( get_panel )
        end

            
        return list
    end

    self.vip_item_scroll = ScrollPage:create( nil, 422-30, 30, 180+60, 160, _page_max_index, TYPE_VERTICAL_EX, 1)
    --self.item_scroll:setScrollRunType(RUN_TYPE_PAGE)
    self.vip_item_scroll:setScrollCreatFunction(create_Scroll_item_vip)
    self.vip_item_scroll:refresh()
    return self.vip_item_scroll
end


-- 创建一个领取面板 普通玩家
function DailyWelfareLU:create_vip_get_panel( index )
    -- 如果已经创建过，就不创建
    if self.vip_get_panel_t[ index ] then
        return self.vip_get_panel_t[ index ]
    end
    
    --获取VIP的奖励列表
    local award_info = WelfareModel:get_vip_award_by_index( index )
    local item_id = award_info.item_id
    local get_panel = {}         -- 获取的对象
    get_panel.index = index      -- 获取面板的序列号
    get_panel.view = CCBasePanel:panelWithFile(0, 0, 90, 150, "", 500, 500 )
    local item_base = ItemConfig:get_item_by_id( item_id )
    if item_base == nil then
        return get_panel
    end
    
    --登录**天
    get_panel.day_lable = UILabel:create_lable_2( LH_COLOR[2]..Lang.benefit.welfare[31]..index..Lang.benefit.welfare[32], 46, 144, 14,  ALIGN_CENTER ) 
    get_panel.view:addChild( get_panel.day_lable )
    
    --道具的框
    get_panel.slot = SlotItem( 60, 60 )
    get_panel.slot:set_icon_bg_texture( UILH_COMMON.slot_bg,  -9,  -9, 60+18, 60+18 )   -- 背框
    get_panel.slot:setPosition( 16, 67 )
    get_panel.slot:set_icon( item_id )
    get_panel.view:addChild( get_panel.slot.view )
    get_panel.slot:set_gem_level( item_id ) 

    local function item_click_fun (...)
        local a, b, arg = ...
        local position = Utils:Split(arg,":");
        local pos = get_panel.slot.view:getParent():convertToWorldSpace( CCPointMake( tonumber(position[1]),tonumber(position[2]) ) )

        ActivityModel:show_mall_tips( item_id,pos.x,pos.y )
    end
    get_panel.slot:set_click_event(item_click_fun)

    -- 领取按钮
    -- get_panel.get_but = CCNGBtnMulTex:buttonWithFile( 18, 0, 56, 28, "ui/common/button2_bg.png", 500, 500)
    -- get_panel.get_but:addTexWithFile( CLICK_STATE_DOWN, "ui/common/button2_bg.png" )
    local function but_1_fun( eventType, x, y )
        if eventType == TOUCH_CLICK then
            WelfareModel:request_get_award_by_index( index,2,false )
        end
        return true;
    end
    -- get_panel.get_but = UIButton:create_button_with_name2( get_panel.view, 19, 0, LangGameString[549], but_1_fun ) -- [549]="领取"
    -- get_panel.get_but,get_panel.get_but_lab = MUtils:create_common_btn( get_panel.view, "三个字", but_1_fun, 2, 0 ) -- [549]="领取"
    local btn = CCNGBtnMulTex:buttonWithFile( 7, 0, -1, -1,UILH_COMMON.button4,TYPE_MUL_TEX);
    btn:addTexWithFile(CLICK_STATE_DISABLE, UILH_COMMON.button4_dis)


    if ( but_1_fun ) then
        btn:registerScriptHandler(but_1_fun);
    end

    get_panel.view:addChild(btn,0);
    
    --领取文字
    -- local size = btn:getSize();
    -- local lab = MUtils:create_zxfont(btn,"三个字",size.width/2,size.height/2-7,2,20);
     local lab = UILabel:create_lable_2(Lang.benefit.welfare[8], 41, 14, 14, ALIGN_LEFT  ) 
     
          local btn_size = btn:getSize()
     local lab_size = lab:getSize()
     lab:setPosition(btn_size.width/2- lab_size.width/2,btn_size.height/2-lab_size.height/2+3)

    get_panel.get_but,get_panel.get_but_lab = btn,lab;
    -- get_panel.get_but:registerScriptHandler( but_1_fun )                  --注册
    -- get_panel.view:addChild( get_panel.get_but )
    -- get_panel.get_but_lable = UILabel:create_lable_2( "领取", 25, 10, 14,  ALIGN_CENTER )
    get_panel.get_but:addChild( get_panel.get_but_lab )

    -- 根据当前状态，更新领取面板的显示
    get_panel.update_get_state = function(  )
        local state = WelfareModel:get_vip_award_state_by_index( index )
        if state == 0 then                        -- 不可领取状态， 按钮显示 领取， 不可点击
            -- get_panel.get_but_lab:setText(LH_COLOR[2]..Lang.benefit.welfare[8] ) -- [549]="领取"
            get_panel.get_but_lab:setString(LH_COLOR[2]..Lang.benefit.welfare[8] ) -- [549]="领取"

            get_panel.get_but:setCurState( CLICK_STATE_DISABLE )
        elseif state == 1 then                    -- 未领取状态， 按钮显示 领取， 可点击
            -- get_panel.get_but_lab:setText( LH_COLOR[2]..Lang.benefit.welfare[8]  ) -- [549]="领取"
            get_panel.get_but_lab:setString( LH_COLOR[2]..Lang.benefit.welfare[8]  ) -- [549]="领取"

            get_panel.get_but:setCurState( CLICK_STATE_UP )
        elseif state == 2 then                    -- 已领取状态， 按钮显示 已领取， 可点击
            -- get_panel.get_but_lab:setText(LH_COLOR[2]..Lang.benefit.welfare[22] ) -- [550]="已领取"
            get_panel.get_but_lab:setString(LH_COLOR[2]..Lang.benefit.welfare[22] ) -- [550]="已领取"
            get_panel.get_but_lab:setPosition(btn_size.width/2-lab_size.width/2-8,btn_size.height/2-lab_size.height/2+3)
            get_panel.get_but:setCurState( CLICK_STATE_DISABLE )
        end
    end

    get_panel.update_get_state(  ) 
    
    self.vip_get_panel_t[ index ] = get_panel
    safe_retain(get_panel.view)           -- 不让它被释放，不重复创建
    return get_panel
end

---=====================================================================================================------



-- 更新奖品列表
function DailyWelfareLU:update_award_list(  )
    -- xprint("调用更新   DailyWelfareLU:update_award_list(  )")
    -- local item_list = WelfareModel:get_login_award_list(  )
    -- self.view:removeChild( self.item_scroll.view, true )
    -- print("~~!!!!~DailyWelfareLU:update_award_list~~!!!", self.item_scroll)
    if self.item_scroll == nil then
        self.item_scroll = self:create_award_list(  )
        self.view:addChild( self.item_scroll.view )
          self.item_scroll:refresh()
          -- self.item_scroll:setMaxNum(30)
        
    else
          self.item_scroll:refresh()
    end

    --引擎的滑动控件存在问题  如果瞬间滑动非常快，会发现崩溃。 建议，30天 3个一页来显示 不然奔溃意料之中 by　xiehande
    self.item_scroll:setCurIndexPage((WelfareModel:get_continuity_login_days()-1)/3)
    
    --vip滚动
     if self.vip_item_scroll == nil then
        self.vip_item_scroll = self:create_vip_award_list(  )
        self.view:addChild( self.vip_item_scroll.view )
          self.vip_item_scroll:refresh()

    else
          self.vip_item_scroll:refresh()

    end

    --引擎的滑动控件存在问题  如果瞬间滑动非常快，会发现崩溃。 建议，30天 3个一页来显示,只有10页 不然奔溃意料之中 by　xiehande
    self.vip_item_scroll:setCurIndexPage((WelfareModel:get_continuity_login_days()-1)/3)

end

-- 更新奖品的领取状态
function DailyWelfareLU:update_get_award_state(  )
    for key, get_panel in pairs(self.get_panel_t) do
         get_panel.update_get_state()
    end

    for key, get_panel in pairs(self.vip_get_panel_t) do
         get_panel.update_get_state()
    end

end

-- 摧毁窗口，被UIManager调用
function DailyWelfareLU:destroy(  )
    Window.destroy(self)
    for key, get_panel in pairs(self.get_panel_t) do
        safe_release(get_panel.view)
    end

      for key, get_panel in pairs(self.vip_get_panel_t) do
        safe_release(get_panel.view)
    end

end

