-- RechargeGiftPage.lua  
-- created by lyl on 2013-3-8
-- 消费礼包页  

super_class.XiaoFeiLiBao(Window)


--local _gift_item_id_t = { 44410, 44411, 44412, 44413, 44414, 44415, 44416 }    -- 所有充值礼包的集合


function XiaoFeiLiBao:create(  )
    -- local temp_panel_info = { texture = "ui/common/nine_grid_bg.png", x = 18, y = 22, width = 710, height = 335 }
	return XiaoFeiLiBao( "XiaoFeiLiBao", "", false, 850, 490 )
end

function XiaoFeiLiBao:__init( window_name, window_info )
    self.award_list_t = {}                -- 记录所有奖励道具
    local panel = self.view

    panel:addChild( CCZXImage:imageWithFile( 1, 299, 710 - 2, 35, UIResourcePath.FileLocate.common .. "coner1.png", 500, 500 ) )              -- 分割线
    panel:addChild( CCZXImage:imageWithFile( 1, 206, 710 - 2, 35, UIResourcePath.FileLocate.common .. "coner1.png", 500, 500 ) )              -- 分割线
    panel:addChild( CCZXImage:imageWithFile( 1, 67, 710 - 2, 35,  UIResourcePath.FileLocate.common .. "coner1.png", 500, 500 ) )               -- 分割线

    -- 标题提示
    local word_temp = 20000
    self.title_notice_lable = UILabel:create_lable_2( LangGameString[641]..word_temp..LangGameString[642], 355, 311, 16, ALIGN_CENTER ) -- [641]="#c66ff66再消费#cffff00" -- [642]="元宝#c66ff66,就能领取#c66ff66礼包"
    panel:addChild( self.title_notice_lable )

    -- panel:addChild( CCZXImage:imageWithFile( 20, 290, 673, 17, "ui/common/common_progress_bg.png", 500, 500 ) )
    self.recharge_bar = MUtils:create_progress_bar( 20, 290, 673, 17, UIResourcePath.FileLocate.common .. "common_progress_bg.png", UIResourcePath.FileLocate.common .. "common_progress.png", 100000, { 14, nil } )
    panel:addChild( self.recharge_bar.view )
    local current_recharge = ActivityModel:get_chongzhilibao_money()--WelfareModel:get_current_rechange_value(  )
    self.recharge_bar.set_current_value( current_recharge )

    self.process_lab = Label:create( nil, 0, 0, "0/0", 16)
    local process_lab_size = self.process_lab.view:getSize()
    self.process_lab.view:setPosition( 20 + (673 - process_lab_size.width) / 2, 290 )
    panel:addChild( self.process_lab.view )
    -- 活动剩余时间
    self.activity_time_title_lable = UILabel:create_lable_2( LangGameString[634], 20, 245, 16, ALIGN_LEFT ) -- [634]="#c66ff66活动剩余时间："
    panel:addChild( self.activity_time_title_lable )
    self.remain_time_lable = TimerLabel:create_label( panel, 135, 245, 16, 60 * 60 * 24, "#cffff00" )

    self.recharge_activity_end_lable = UILabel:create_lable_2( LangGameString[635], 20, 245, 16, ALIGN_LEFT ) -- [635]="#cffff00活动已结束"
    panel:addChild( self.recharge_activity_end_lable )
    self.recharge_activity_end_lable:setIsVisible( false )

    -- 充值按钮
    local function recharge_but_callback()
        print("充值按钮")
        GlobalFunc:chong_zhi_enter_fun()
        --UIManager:show_window( "chong_zhi_win" )
        -- 测试
        -- WelfareModel:set_recharge_award_date( 3, 113, 60*60*3 )
    end
    self.recharge_but = UIButton:create_button_with_name( 570, 245, 123, 40, UIResourcePath.FileLocate.other .. "vip_btn_n.png", UIResourcePath.FileLocate.other .. "vip_btn_s.png", nil, "", recharge_but_callback )
    panel:addChild( self.recharge_but )

    -- 标题
    panel:addChild( CCZXImage:imageWithFile( 25, 72 , 107, 19, UIResourcePath.FileLocate.common .. "title_bg_01_s.png", 500, 500 ) )
    self.title_lable = UILabel:create_lable_2( LangGameString[636], 35, 72 + 6, 16, ALIGN_LEFT ) -- [636]="#cffff00奖励道具"
    panel:addChild( self.title_lable )
    panel:addChild( CCZXImage:imageWithFile( -5, 71, 710, 1, UIResourcePath.FileLocate.common .. "explain_bg.png" ) )            -- 分割线

    -- 创建所有礼包面板
    self:create_all_gift_panel(  )

    -- 创建价值图片
    self.gift_value_image = CCZXImage:imageWithFile( 300, 55 , 121, 53, UIResourcePath.FileLocate.newactivity .. "888xiaofei.png", 500, 500 )
    panel:addChild( self.gift_value_image )            -- 分割线

    -- 
    self.gift_value_money = CCZXImage:imageWithFile( 520, 55 , 115, 53, UIResourcePath.FileLocate.newactivity .. "388yuanbao.png", 500, 500 )
    panel:addChild( self.gift_value_money )
    self:update( "all" )
    -- 测试，
    -- WelfareModel:set_recharge_award_date( 6, 113, 60*60*3 )
end

-- 创建所有礼包面板
function XiaoFeiLiBao:create_all_gift_panel(  )
    print("run XiaoFeiLiBao:create_all_gift_panel")
    self.gift_panel_t = {}                             -- 存储所有礼物面板
    local begin_x = 53 - 28
    local begin_y = 110
    local interval_x = 85 + 8
    local gift_panel_temp = nil
    local _gift_item_id_t = GlobalConfig:get_xiaofeilibao_item_id()
    for i = 1, #_gift_item_id_t do
        gift_panel_temp = self:create_one_gift_panel( i, begin_x + interval_x * ( i - 1 ), 110 )
        self.view:addChild( gift_panel_temp.view )
    end
    self:select_gift_panel( _gift_item_id_t[1] )
end

-- 创建一个礼包面板
function XiaoFeiLiBao:create_one_gift_panel( index, x, y )
    local one_gift = {}                -- 一个礼包对象
    local _gift_item_id_t = GlobalConfig:get_xiaofeilibao_item_id()
    local item_id = _gift_item_id_t[index]
    one_gift.item_id = item_id
    one_gift.level = index             -- 相当于礼包的等级
    one_gift.view = CCBasePanel:panelWithFile( x, y, 85 + 8, 123, UIResourcePath.FileLocate.common .. "nine_grid_bg.png", 500, 500 )
    print("XiaoFeiLiBao:create_one_gift_panel item_id",item_id)
    local item_base = ItemConfig:get_item_by_id( item_id )
    if item_base == nil then
        return one_gift
    end

    local bg_n = CCZXImage:imageWithFile( 0, 0, 130, 123, UIResourcePath.FileLocate.common .. "pet_c_b.png", 2, 800, 130, 800,  2, 800, 130, 800 )   -- 未选中状态的背景85 + 8
    one_gift.view:addChild( bg_n )

    local bg_s = CCZXImage:imageWithFile( 0, 0, 130, 123, UIResourcePath.FileLocate.common .. "pet_c_y.png", 2, 800, 130, 800,  2, 800, 130, 800  )   -- 选中状态的背景
    one_gift.view:addChild( bg_s )
    bg_s:setIsVisible(false)

    -- 注册面板方法
    local function but_1_fun(eventType,x,y)
        if eventType == TOUCH_CLICK then 
            self:select_gift_panel( item_id )
            return true
        end
        return true
    end
    one_gift.view:registerScriptHandler(but_1_fun)                  --注册

    -- 名称
    one_gift.view:addChild( UILabel:create_lable_2( "#cffff00"..item_base.name, 43 + 4, 95, 11, ALIGN_CENTER ) )

    -- 道具slot
    one_gift.slot = SlotItem( 44, 44 )
    one_gift.slot:set_icon_bg_texture( UIPIC_ITEMSLOT,  -6 ,  -6, 44+12, 44+12 )   -- 背框
    one_gift.slot:setPosition( 22 + 4, 45 )
    one_gift.slot:set_icon( item_id )
    one_gift.view:addChild( one_gift.slot.view )
    one_gift.slot:set_gem_level( item_id ) 
    local function item_click_fun ()
        self:select_gift_panel( item_id )
    end
    one_gift.slot:set_click_event(item_click_fun)

    -- 领取按钮
    -- one_gift.get_but = CCNGBtnMulTex:buttonWithFile( 17 + 4, 5, 56, 28, UIResourcePath.FileLocate.common .. "button2_bg.png", 500, 500)
    -- one_gift.get_but:addTexWithFile( CLICK_STATE_DOWN, UIResourcePath.FileLocate.common .. "button2_bg.png" )
    local function but_1_fun( eventType, x, y )
        -- if eventType == TOUCH_CLICK then 
            OnlineAwardCC:send_consume_item(index-1)
            --WelfareModel:get_recharge_award( index - 1 )
        -- end
        -- return true
    end
    one_gift.get_but = UIButton:create_button_with_name2( one_gift.view, 16, 10, LangGameString[549], but_1_fun ) -- [549]="领取"
    -- one_gift.get_but:registerScriptHandler( but_1_fun )                  --注册
    -- one_gift.view:addChild( one_gift.get_but )
    -- one_gift.get_but_lable = UILabel:create_lable_2( "领取", 25, 10, 14,  ALIGN_CENTER )
    -- one_gift.get_but:addChild( one_gift.get_but_lable )

    -- 提供方法
    -- 改变选中状态
    one_gift.change_select_state = function( if_selected )
        if if_selected then
            bg_n:setIsVisible(false)
            bg_s:setIsVisible(true)
        else
            bg_n:setIsVisible(true)
            bg_s:setIsVisible(false)
        end
    end

    -- 改变领取状态（按钮显示）
    -- 根据当前状态，更新领取面板的显示
    one_gift.update_get_state = function(  )
        local state = ActivityModel:get_chongzhilibao_index_state( index )
        local max_gift_index = ActivityModel:get_chongzhilibao_info().level    -- 最大可领取等级
        if max_gift_index <= index - 1 then                             -- 先判断是否是可以领取， 礼品是从0开始的，所以要减1
            -- one_gift.get_but_lable:setString("领取")
            one_gift.get_but:setCurState( CLICK_STATE_DISABLE )
            one_gift.get_but.set_but_name( LangGameString[549] ) -- [549]="领取"
        elseif state == 1 then                      
            -- one_gift.get_but_lable:setString("已领取")
            one_gift.get_but.set_but_name( LangGameString[550] ) -- [550]="已领取"
            one_gift.get_but:setCurState( CLICK_STATE_DISABLE )
        else
            -- one_gift.get_but_lable:setString("领取")
            one_gift.get_but.set_but_name( LangGameString[549] ) -- [549]="领取"
            one_gift.get_but:setCurState( CLICK_STATE_UP )
        end
    end

    self.gift_panel_t[ item_id ] = one_gift
    return one_gift
end

-- 根据id，选中某个礼包面板
function XiaoFeiLiBao:select_gift_panel( item_id )
    for key, one_gift in pairs(self.gift_panel_t) do
        if one_gift.item_id == item_id then
            one_gift.change_select_state( true )
        else
            one_gift.change_select_state( false )
        end
    end
    self:create_award_list( item_id )      -- 创建所有奖励道具

    local item_base = ItemConfig:get_item_by_id( item_id )
    if item_base then
        self.title_lable:setString( "#cffff00"..item_base.name )
    else
        self.title_lable:setString( LangGameString[637] ) -- [637]="#cffff00道具奖励"
    end

    self:change_gift_value_image( self.gift_panel_t[ item_id ].level )
end

-- 更新价格图片
function XiaoFeiLiBao:change_gift_value_image( index )
    if not self.gift_value_image then              -- 根据顺序，第一次还没有创建这个，不更新
        return 
    end
    local image_name = "ui/newactivity/%dyuanbao.png"
    local image_money = "ui/newactivity/%dxiaofei.png"
    -- local image_name = {
    --  "ui/newactivity/388yuanbao.png", "ui/newactivity/788yuanbao.png",
    --  "ui/newactivity/2288yuanbao.png", "ui/newactivity/3888yuanbao.png",
    --  "ui/newactivity/5888yuanbao.png", "ui/newactivity/16888yuanbao.png",
    --  "ui/newactivity/28888yuanbao.png" 
    -- }
    --local image_name = ActivityModel:get_current_gift_value_image( index )
    self.view:removeChild( self.gift_value_money, true )
    self.gift_value_money =  CCZXImage:imageWithFile( 300, 55 , 121, 53, string.format(image_money,GlobalConfig:get_xiaofeilibao_money(index) ), 500, 500 )    
    self.view:addChild( self.gift_value_money )

    self.view:removeChild( self.gift_value_image, true )
    self.gift_value_image = CCZXImage:imageWithFile( 520, 55, 115, 53, string.format(image_name,GlobalConfig:get_xiaofeilibao_value(index) ), 500, 500 )    
    self.view:addChild( self.gift_value_image )
end

-- 根据选中的礼包id，创建所有奖励道具
function XiaoFeiLiBao:create_award_list( item_id )
    -- 先删除所有slot
    for key, slot in pairs(self.award_list_t) do
        self.view:removeChild( slot.view, true )
    end

    -- 获取礼包序列号
    local gift_index = 1
    local _gift_item_id_t = GlobalConfig:get_xiaofeilibao_item_id()
    for i = 1, #_gift_item_id_t do
        if item_id == _gift_item_id_t[i] then
            gift_index = i
            break
        end
    end
    local item_list = GlobalConfig:get_xiaofeilibao_items(gift_index)--WelfareModel:get_recharge_award_items( gift_index )  -- 获取道具

    -- 创建所有道具slot
    local begin_x = 25
    local begin_y = 12
    local interval_x = 68
    for i = 1, #item_list do
        local slot = self:create_one_item_slot( item_list[i].id, item_list[i].count, begin_x + (i - 1) * interval_x, begin_y )
        self.view:addChild( slot.view )
        table.insert( self.award_list_t, slot )
    end
end

-- 创建一个道具slot
function XiaoFeiLiBao:create_one_item_slot( item_id, count, x, y )
    local slot = SlotItem( 44, 44 )
    slot:set_icon_bg_texture( UIPIC_ITEMSLOT,  -6 ,  -6, 44+12, 44+12 )   -- 背框
    slot:setPosition( x, y )
    slot:set_icon( item_id )
    slot:set_gem_level( item_id )
    slot:set_item_count( count )
    local function item_click_fun ()
        ActivityModel:show_mall_tips( item_id )
    end
    slot:set_click_event(item_click_fun)
    return slot
end

-- 更新剩余时间
function XiaoFeiLiBao:update_remain_time(  )
    if self.remain_time_lable then 
        self.remain_time_lable:destroy()
        self.remain_time_lable = nil;
    end
    -- self.view:removeChild( self.remain_time_lable.panel.view, true )
    local remain_time = ActivityModel:get_chongzhilibao_info().time - os.time() 
    if remain_time > 0 then                      -- 活动未结束
        self.remain_time_lable = TimerLabel:create_label( self.view, 135, 245, 16, remain_time, "#cffff00" )
        self.recharge_activity_end_lable:setIsVisible( false )
        self.recharge_but:setIsVisible( true )
        self.activity_time_title_lable:setIsVisible( true )
    else                                         -- 活动结束
        --self.remain_time_lable = TimerLabel:create_label( self.view, 135, 245, 16, remain_time, "#cffff00" )
        self.recharge_activity_end_lable:setIsVisible( true )
        self.recharge_but:setIsVisible( false )
        self.activity_time_title_lable:setIsVisible( false )
        self.title_notice_lable:setIsVisible( false )
    end
end

-- 更新获取面板信息
function XiaoFeiLiBao:update_get_panel(  )
    for key, gift_panel in pairs(self.gift_panel_t) do
        gift_panel.update_get_state()
    end
end

-- 更新充值数据条
function XiaoFeiLiBao:update_recharge_bar(  )
    -- local max_value = ActivityModel:get_next_level_recharge(  )                 -- 下一等级需要的充值
    -- local current_recharge = ActivityModel:get_chongzhilibao_money()--WelfareModel:get_current_rechange_value(  )        -- 当前充值数
    local chongzhiinfo = ActivityModel:get_chongzhilibao_info()
    local max_value = ActivityModel:get_chongzhilibao_cur_level_max_money(chongzhiinfo.level + 1)
    print("----------------max_value,chongzhiinfo.money",max_value,chongzhiinfo.money,chongzhiinfo.level)
    self.recharge_bar.set_max_value( max_value )
    self.recharge_bar.set_current_value( chongzhiinfo.money )
    local difference = max_value - chongzhiinfo.money
    local _gift_item_id_t = GlobalConfig:get_xiaofeilibao_item_id()
    local temp_index = tonumber(chongzhiinfo.level) + 1
    if temp_index > #_gift_item_id_t then
        temp_index = #_gift_item_id_t
    end
    local next_level_name = ItemConfig:get_item_by_id( _gift_item_id_t[temp_index] ).name
    local show_notice = ""
    if difference < 0 then
        show_notice =  LangGameString[643]  -- [643]="#c66ff66可以领取全部礼包，请尽快领取"
    else
    -- if max_value == 1 then
    --     show_notice =  "#c66ff66再消费#cffff001元宝#c66ff66，您就能领取#cffff00首充#c66ff66礼包"
    -- elseif difference > 0 then
        show_notice =  LangGameString[641]..difference..LangGameString[639]..next_level_name..LangGameString[644]  -- [641]="#c66ff66再消费#cffff00" -- [639]="元宝#c66ff66,就能领取#cffff00" -- [644]="#c66ff66礼包"
    end
    self.title_notice_lable:setString( show_notice )
    self.process_lab.view:setText(string.format("%s/%s",chongzhiinfo.money,max_value))
    local process_lab_size = self.process_lab.view:getSize()
    self.process_lab.view:setPosition( 20 + (673 - process_lab_size.width) / 2, 290 )
end

-- 更新数据 
function XiaoFeiLiBao:update( update_type )
    
    if update_type == "recharge_award" then
        self:update_remain_time(  )
        self:update_get_panel(  )
        self:update_recharge_bar(  )
    elseif update_type == "all" then
        self:update_remain_time(  )
        self:update_get_panel(  )
        self:update_recharge_bar(  )
    end

end

-- 销毁
function XiaoFeiLiBao:destroy(  )
    if self.remain_time_lable then
        self.remain_time_lable:destroy()
    end
    Window.destroy(self)
end
