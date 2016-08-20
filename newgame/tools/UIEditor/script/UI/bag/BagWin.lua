-- BagWin.lua
-- created by HardGame on 2012-12-03
-- 背包窗口 bag_win

--super_class.BagWin(Window);
super_class.BagWin(NormalStyleWindow)

local _win_name = "bag_win"
local _max_page_index = 10           -- 最大显示页数
-- local _lock_item_dir_flag = false   -- 标记锁定物品是否变灰。 交易的时候要求锁定物品变灰。 

local _slot_bg_padding = {left=15, top=40, right=15, bottom=138+6+40} --单元格背景相对底板的间距

--整个页面的大小   目前规格是 435 605
--宽
local   panel_width = 435
    --高
local  panel_height = 605

--单元格背景面板尺寸 二层底板

local _slot_bg_size = CCSize(  
    panel_width - _slot_bg_padding.left - _slot_bg_padding.right, 
    panel_height - _slot_bg_padding.top - _slot_bg_padding.bottom) 


--物品框大小
local _slot_region_padding = {left=15, top=15, right=15, bottom=80} --单元格区域相对二层底板的间距 left top right bottom

local _slot_region_size = CCSize(   --单元格区域尺寸
    _slot_bg_size.width - _slot_region_padding.right - _slot_region_padding.left,
    _slot_bg_size.height - _slot_region_padding.top - _slot_region_padding.bottom)

local _slot_region_rect = CCRect(  --单元格区域相对底板的位置
    _slot_region_padding.left,  --left
    _slot_region_padding.bottom,  --bottom
    _slot_region_size.width,  --宽度
    _slot_region_size.height  --高度
    )


-- 仓库， 按钮相应事件回调函数
local function bag_win_cb_csjz(eventType, x, y)
    if (eventType == TOUCH_ENDED) then
        BagModel:open_cangku(  )
    end
    return true
end

-- 整理按钮回调
local function arrange_bag( eventType, x, y )
    if eventType == TOUCH_CLICK then
        -- 如果正在交易，就不能整理
        BagModel:request_arrange_bag(  )    -- 这里发送请求，服务器会返回不可以整理提示

        if not BagModel:get_lock_item_dir_flag() then 
            ItemModel:item_arrange(  )
        end
    end
    return true
end

-- 商点按钮的回调
local function shop_bt_callback( eventType, x, y  )
    if eventType == TOUCH_CLICK then
        BagModel:open_shop_win(  )
    end
    return true
end

-- 寄售的回调
local function bJiShouBg_callback( eventType, x, y )
    if eventType == TOUCH_CLICK then
       UIManager:show_window("ji_shou_win")
    end
    return true
end

-- 创建背包窗口,(背景图名称)
function BagWin:create_loadenter(bag_panel)
    --获取屏幕左边信息定位登录框坐标
    local player = EntityManager:get_player_avatar();
    if (player == nil) then
        player = {};
        player.yuanbao = 0;
        player.bindYuanbao = 0;
        player.yinliang = 0;
        player.bindYinliang = 0;
    end
    
    --新风格背景
    local new_style = CCZXImage:imageWithFile(7,11,423,560,UILH_COMMON.normal_bg_v2, 500, 500)
    bag_panel:addChild(new_style)

    --页面上部底板
    -- local beibao_ds = CCZXImage:imageWithFile( _slot_bg_padding.left, _slot_bg_padding.bottom, _slot_bg_size.width, _slot_bg_size.height, UILH_COMMON.bg_grid, 500, 500)
    -- bag_panel:addChild(beibao_ds)
    
    --文字的底图背景
    local bottom_bg  = CCZXImage:imageWithFile( 12+5, 92, _slot_bg_size.width-5, 93, UILH_COMMON.bottom_bg,500,500)
    bag_panel:addChild(bottom_bg)


    -- 背包面板显示文本
    -- 显示 元宝
    if (player.yuanbao == nil) then
        player.yuanbao = 0;
    end

    local lab = UILabel:create_lable_2(
        LH_COLOR[2]..Lang.bagInfo.yuanbao, 100, 150, 16, ALIGN_RIGHT)
    bag_panel:addChild(lab)
    self.lab_yuanBao = UILabel:create_lable_2( "0", 100, 148, 16, ALIGN_LEFT )
    bag_panel:addChild(self.lab_yuanBao);


    --显示 仙币 --》铜币
    if (player.bindYinliang == nil) then
        player.bindYinliang = 0;
    end
    -- local xianBi_bg = CCZXImage:imageWithFile( 304, 87, 110, -1, UIResourcePath.FileLocate.common .. "wzk-2.png", 500, 500)
    -- bag_panel:addChild(xianBi_bg)
    lab = UILabel:create_lable_2(LH_COLOR[2]..Lang.bagInfo.xianbi, 307-10, 116, 16, ALIGN_RIGHT)
    bag_panel:addChild(lab)
    self.lab_xianBi = UILabel:create_lable_2("0", 307-10, 114, 16, ALIGN_LEFT )
    bag_panel:addChild(self.lab_xianBi);
    
        -- 分割线
    local line = CCZXImage:imageWithFile( 212, 97, 4, 80, UILH_COMMON.split_line_v )
    bag_panel:addChild(line)
    
    --显示 银两
    if (player.yinliang == nil) then
        player.yinliang = 0;
    end
    -- local silver_bg = CCZXImage:imageWithFile( 111, 87, 110, -1, UIResourcePath.FileLocate.common .. "wzk-2.png", 500, 500)
    -- bag_panel:addChild(silver_bg)
    lab = UILabel:create_lable_2(LH_COLOR[2]..Lang.bagInfo.yinliang, 100, 116, 16, ALIGN_RIGHT)
    bag_panel:addChild(lab)
    self.lab_silver = UILabel:create_lable_2( "0", 100, 114, 16, ALIGN_LEFT )
    bag_panel:addChild(self.lab_silver);


  --显示 绑定元宝  -->改礼劵
    if (player.bindYuanbao == nil) then
        player.bindYuanbao = 0;
    end
    -- local bYuanBao_bg = CCZXImage:imageWithFile( 304, 132, 110, -1, UIResourcePath.FileLocate.common .. "wzk-2.png", 500, 500)
    -- bag_panel:addChild(bYuanBao_bg)
    lab = UILabel:create_lable_2(LH_COLOR[2]..Lang.bagInfo.bindYuanbao, 307-10, 150, 16, ALIGN_RIGHT)
    bag_panel:addChild(lab)
    self.lab_bind = UILabel:create_lable_2( "0", 307-10, 148, 16, ALIGN_LEFT )
    bag_panel:addChild(self.lab_bind);



    -- 页数指示
    --向左
    local btn_y  = 187
    local function left_but_callback()
        self:change_to_pre_page()
    end
     self.left_but = UIButton:create_button_with_name( 51, btn_y, -1,-1, 
        UILH_COMMON.page, 
        UILH_COMMON.page, 
        UILH_COMMON.page_disable, ----禁用状态图片
        "", left_but_callback )
    bag_panel:addChild( self.left_but.view )
    self.left_but.set_double_click_func( left_but_callback )
    self.left_but.view:addTexWithFile(CLICK_STATE_DISABLE, UILH_COMMON.page_disable )

    
 --向右
    local function right_but_callback()
        self:change_to_next_page()
    end
    self.right_but = UIButton:create_button_with_name( 320, btn_y, -1, -1, 
        UILH_COMMON.page,
        UILH_COMMON.page, 
        UILH_COMMON.page_disable, ----禁用状态图片
        "", right_but_callback )
    self.right_but.view:setFlipX(true)
    bag_panel:addChild( self.right_but.view )
    self.right_but.set_double_click_func( right_but_callback )  -- 双击
    self.right_but.view:addTexWithFile(CLICK_STATE_DISABLE, UILH_COMMON.page_disable )

    --文字底图
     local  text_bg = ZImage:create(bag_panel,UILH_NORMAL.text_bg2,163,194,100,30,500,500)
    self.text_fy = MUtils:create_zxfont(text_bg,"#cD7A755"..self.current_page_index.."/10",100/2,35/2-10,2,16)

    local btn_panel= CCBasePanel:panelWithFile(14,4,400,60,"")

   bag_panel:addChild(btn_panel)
    local btn_pos = {x=4,y= 26}
    local gas_x = 10
    -- -- 仓库按钮背景
    self.btn_cangku = MUtils:create_btn(btn_panel,UILH_COMMON.lh_button2,UILH_COMMON.lh_button2_s,bag_win_cb_csjz,btn_pos.x,btn_pos.y,-1,-1);
    MUtils:create_zxfont(self.btn_cangku,LH_COLOR[2]..Lang.bagInfo.canku,50,20,2,16);


    -- 商店按钮背景
    self.btn_shop = MUtils:create_btn(btn_panel,UILH_COMMON.lh_button2,UILH_COMMON.lh_button2_s,shop_bt_callback,110-7,btn_pos.y,-1,-1);
    MUtils:create_zxfont(self.btn_shop,LH_COLOR[2]..Lang.bagInfo.shop,50,20,2,16);


    -- 整理按钮背景
    self.btn_zhengli = MUtils:create_btn(btn_panel,UILH_COMMON.lh_button2,UILH_COMMON.lh_button2_s,arrange_bag,210-7,btn_pos.y,-1,-1)
    MUtils:create_zxfont(self.btn_zhengli,LH_COLOR[2]..Lang.bagInfo.zhengli,50,20,2,16);


    -- 寄售按钮背景
    --已经注释了触发事件 
    self.btn_jishou = MUtils:create_btn(btn_panel,UILH_COMMON.lh_button2,UILH_COMMON.lh_button2_s,bJiShouBg_callback,310-7,btn_pos.y,-1,-1);
    -- self.btn_jishou:addTexWithFile(CLICK_STATE_DISABLE,UIPIC_COMMON_BUTTON_001_DISABLE)
    -- self.btn_jishou:setCurState(CLICK_STATE_DISABLE)
    MUtils:create_zxfont(self.btn_jishou,LH_COLOR[2]..Lang.bagInfo.jiShou,50,20,2,16);
   
    return bag_panel;
end

--初始化
function BagWin:__init( window_name, texture_name, is_grid, width, height)

    panel_width = width
    panel_height = height 

    -- _lock_item_dir_flag = false;
    self.item_page_t = {}             -- 存放页的表
    self.item_slot_t = {}             -- 存放所有已经创建的slot，key 对应背包位置. 这样就不用每次滑动都创建了。但要注意release
    self.current_page_index = 1       -- 当前页
    self:create_loadenter(self.view); -- 背包面板
    self:change_item_page_by_index( 1 )
end

-- 参数：页号： 从1开始
function BagWin:create_one_item_page( page )
    local item_page = {}
    --背包
    item_page.view = CCBasePanel:panelWithFile( 24, 260, _slot_region_size.width, _slot_region_size.height, "" )

    local slot_width = 70
    local slot_height = 70

     local start_x = 0
    local start_y = _slot_region_size.height - slot_height
    local gap = 10
    local now_x = start_x
    local now_y = start_y
    
    for i = 1, 4 do 
        for j = 1, 5 do 
            local index = (i - 1) * 5 + j + (page - 1) * 20
            local item_slot = self:create_item_slot( now_x, now_y, slot_width, slot_height, index )
            item_page.view:addChild( item_slot.view )
            now_x = now_x + slot_width + gap
        end
        now_x = start_x
        now_y = now_y - slot_height - gap
    end
    return item_page
end

-- 上一页
function BagWin:change_to_pre_page(  )
    if self.current_page_index - 1 > 0 then
        self:change_item_page_by_index( self.current_page_index - 1 )
    end
end

-- 下一页
function BagWin:change_to_next_page(  )
    if self.current_page_index < _max_page_index then
       self:change_item_page_by_index( self.current_page_index + 1 )
    end
end

-- 切换道具页，如果还没有，会创建
function BagWin:change_item_page_by_index( page_index )
    -- 先隐藏
    for key, one_page in pairs(self.item_page_t) do
        one_page.view:setIsVisible( false )
    end

    -- 创建
    if self.item_page_t[page_index] == nil then
        self.item_page_t[page_index] = self:create_one_item_page(page_index)
        self.view:addChild( self.item_page_t[page_index].view )
    end
    
    -- 显示
    if self.item_page_t[page_index] then
        self.item_page_t[page_index].view:setIsVisible( true )
    end

    self.current_page_index = page_index

    self.text_fy:setString(LH_COLOR[13]..self.current_page_index.."/10")

   -- self.show_page_circle.change_page_index( self.current_page_index )

    -- 如果已经到了上一页，或者最后一页，就变暗
     if page_index == 1 then 
        self.left_but.view:setCurState( CLICK_STATE_DISABLE )        
        self.right_but.view:setCurState( CLICK_STATE_UP )     
    elseif page_index == _max_page_index then  
        self.left_but.view:setCurState( CLICK_STATE_UP )          
        self.right_but.view:setCurState( CLICK_STATE_DISABLE )         
    else
        self.left_but.view:setCurState( CLICK_STATE_UP )        
        self.right_but.view:setCurState( CLICK_STATE_UP )     
    end
end

-- 创建道具slot，注：这里只创建空的，更新的时候，直接在上面修改
-- x, y, w, h: 坐标及尺寸大小
function BagWin:create_item_slot(x, y, width, height, index)

    -- 基本的显示
    local item_obj = SlotBag(width, height);
    item_obj.view:setEnableDoubleClick(true)
    item_obj.index = index
    item_obj:set_icon_bg_texture( UILH_COMMON.slot_bg, -6, -6, 82, 82 )   -- 背框
    item_obj:setPosition (x, y);
    item_obj:set_icon_texture("");
    item_obj:set_select_effect_state( true )
    item_obj.grid_had_open = true                        -- 标记该格子是否已经开启

    -- 位置超出最大格子数的情况
    local max_grid_num = BagModel:get_bag_max_grid_num(  )
    if index > max_grid_num then
        self:set_slot_not_open( item_obj, index - max_grid_num )  -- 设置未开启状态
    end

    -- 背包该位置有数据才显示
    local item_date = ItemModel:get_item_by_position( index )
    if item_date then
        item_obj.item_date = Utils:table_clone( item_date )
        item_obj.item_base  = BagModel:get_item_base_by_id( item_date.item_id )             -- 基础数据

        -- slot 具体道具的显示
        item_obj:set_drag_info( 1, _win_name, item_obj.item_date) -- 设置拖动传入的信息
        item_obj:set_icon (item_date.item_id);
        item_obj:set_lock( item_date.flag == 1 )         -- 是否绑定(锁)
        item_obj:set_color_frame( item_date.item_id, 0, 1, 70, 69 )    -- 边框颜色
        item_obj:set_item_count( item_date.count )       -- 数量
        -- 背包中的秘籍道具，不显示强化等级 add by gzn
        if item_obj.item_base ~= nil and item_obj.item_base.type == ItemConfig.ITEM_TYPE_SKILL_MIJI then
            
        else
            item_obj:set_strong_level( item_date.strong )    -- 强化等级
        end
        -- item_obj:set_strong_level( item_date.strong )    -- 强化等级

        item_obj:set_gem_level( item_date.item_id )      -- 宝石的等级

        if BagModel:get_lock_item_dir_flag() and item_date.flag == 1 then
            item_obj:set_slot_disable(  )
        end
    end
    

---[[  -- 各种事件*********************************************
    -- 道具双击事件回调
    local function item_double_clicked ()
        -- print("点击物品的序列号：：：", item_obj.item_date.series)
        BagModel:item_double_click( item_obj )
    end

    -- 单击 点击可拓展 回调函数
    local function item_click_fun ()
        -- print("点击物品的序列号：：：", item_obj.item_date.series)
        BagModel:item_slot_sclick( item_obj )
    end

    -- 拖动slot的回调函数
    local function drag_out( self_item )
        -- print("拖动slot的回调函数   drag_out~!!!!")
    end

    -- 物品拖进来
    local function drag_in( source_item )
        -- print("拖动slot的回调函数  drag_in!!!! ", source_item.win, source_item.obj_data)
        local source_win = source_item.win         -- 源窗口的名称
        -- 在本窗口内拖动， 就直接在dragin方法中给处理。直接改变两个slot的显示(如果是同一类物品，就发送刚合并请求)
        if source_win == _win_name then 

            if source_item.obj_data then
                local slotitem_source = self:get_slot_by_series( source_item.obj_data.series )   
                if slotitem_source and item_obj.grid_had_open then                                     -- 如果是窗口内拖动，就交换位置. 源必须有物品，否则就不会有任何交换
                    BagModel:do_drag_in_bag_win( source_item, item_obj )
                end
            end 
        elseif source_win == "cangku_win" then                          -- 仓库窗口拖进来的
            BagModel:do_drag_in_from_cangku( source_item, item_obj )
        elseif source_win == "guild_cangku_win" then                          -- 仙踪仓库窗口拖进来的
            BagModel:do_drag_in_from_guild_cangku( source_item, item_obj)
        elseif source_win == "user_attr_win" then
            BagModel:do_drag_in_from_userinfo( source_item )
        elseif source_win == "user_equip_win" then
            BagModel:do_drag_in_from_userinfo( source_item )
        end
    end

    local function drag_callback( target_win )  
        -- print("成功拖到其他地方")
    end

    local function drag_invalid_callback(drag_object )
        -- print("成功拖到非法地方")
        if drag_object.obj_data ~= nil and drag_object.obj_data.item_id ~= nil then
            drag_object:set_icon_texture(ItemConfig:get_item_icon(drag_object.obj_data.item_id));
        end
    end 

    local function discard_item_callback( drag_object )
        -- print("成功拖到可丢弃地方")
        BagModel:drag_to_cast_item( item_obj )
    end

    item_obj:set_double_click_event(item_double_clicked);
    item_obj:set_click_event(item_click_fun)
    item_obj:set_drag_out_event(drag_out)
    item_obj:set_drag_in_event(drag_in)
    item_obj:set_drag_in_callback(drag_callback)
    item_obj:set_drag_invalid_callback(drag_invalid_callback);
    item_obj:set_discard_item_callback(discard_item_callback);

    -- scroll 在看不到的时候，会把slot的view销毁。这里 引用加1 ，不让销毁。但要记得要在窗口destroy的时候，release
    safe_retain(item_obj.view)
    self.item_slot_t[ index ] = item_obj
    return item_obj;
end

-- 根据一个item model数据来设置slot
function BagWin:set_one_slotItem_by_item_date( slotitem, item_date, slot_index )
    -- print("print先保留，测试背包开启的刷新平率使用：：：根据一个item model数据来设置slot")
    if item_date == nil then
        self:init_one_slotItem( slotitem )
        return 
    end

    SlotEffectManager.stop_current_effect()
    slotitem.item_date = Utils:table_clone( item_date )
    require "config/ItemConfig" 
    local item_base = ItemConfig:get_item_by_id( item_date.item_id )
    if item_base ~= nil then
        slotitem.item_base = item_base
    end
    slotitem.slot_index = slot_index                 -- 序列号，用来找到格子和数据的对应关系
    slotitem:set_drag_info( 1, _win_name, item_date) -- 设置拖动传入的信息
    slotitem:set_icon (item_date.item_id);
    slotitem:set_lock( item_date.flag == 1 )         -- 是否绑定(锁)
    slotitem:set_color_frame( item_date.item_id, 0, 1, 70, 69 )    -- 边框颜色
    slotitem:set_item_count( item_date.count )       -- 数量
    -- 背包中的秘籍道具，不显示强化等级 add by gzn
    if item_base ~= nil and item_base.type == ItemConfig.ITEM_TYPE_SKILL_MIJI then

    else
        slotitem:set_strong_level( item_date.strong )    -- 强化等级
    end

    slotitem:set_gem_level( item_date.item_id )      -- 宝石的等级
    slotitem.grid_had_open = true
    slotitem:set_select_effect_state( true )
end

-- 设置一个slotitem为空
function BagWin:init_one_slotItem( slotitem )
    slotitem.item_date = nil
    slotitem.item_base = nil

    slotitem:set_drag_info( 1, _win_name, nil)
    slotitem:set_icon_texture("");
    slotitem:set_lock( false )
    slotitem:set_color_frame( nil )
    slotitem:set_item_count( 0 )
    slotitem:set_strong_level( 0 ) 
    slotitem:set_gem_level( nil )
    slotitem.grid_had_open = true
    slotitem:hide_cover_color()
    slotitem:set_select_effect_state( false )

    if slotitem.bag_lock_pic then
        -- slotitem.bag_lock_pic:removeFromParentAndCleanup(true)
        slotitem.view:removeChild( slotitem.bag_lock_pic, true )
        slotitem.bag_lock_pic = nil
    end

    if slotitem.not_open_word then
        slotitem.view:removeChild( slotitem.not_open_word, true )
        slotitem.not_open_word = nil          -- 必须设置为nil，单击是否弹出扩展提示，根据这个来
    end
end

-- 设置一个slotitem为未开启,  未开启格子前五个，要显示几个字: 点击可扩展
function BagWin:set_slot_not_open( slotitem, count)
    -- print("设置一个slotitem为未开启,  未开启格子前五个，要显示几个字: 点击可扩展")
    if slotitem == nil then
        return 
    end

    self:init_one_slotItem( slotitem )
    -- slotitem:set_icon_texture(UIResourcePath.FileLocate.normal .. "item_bg22.png")
    -- edited by aXing on 2014-4-19
    -- icon有缩放，所以不能用以前的set_icon_texture的方法
     if slotitem.bag_lock_pic == nil then
        slotitem.bag_lock_pic = CCZXImage:imageWithFile( -4, -4, 78, 78, UILH_BAG_AND_CANGKU.wkq)
        slotitem.view:addChild( slotitem.bag_lock_pic, 4 )
    end

    slotitem.grid_had_open = false                        -- 标记该格子是否已经开启
    slotitem:set_select_effect_state( false )
    -- 文字
    local word_image_t = {UILH_BAG_AND_CANGKU.dian,UILH_BAG_AND_CANGKU.ji,UILH_BAG_AND_CANGKU.ke,UILH_BAG_AND_CANGKU.kuo,UILH_BAG_AND_CANGKU.zhan} 
                            
    if count <= 5 and count >= 1 then
        if slotitem.not_open_word == nil then
            slotitem.not_open_word = CCZXImage:imageWithFile( 6, 6, -1, -1, word_image_t[count] )
            slotitem.view:addChild( slotitem.not_open_word, 5 )
        end
    end
end

-- 所有所有锁定物品变灰, 并且不可拖拽      静态调用
function BagWin:set_lock_item_die(  )
    -- _lock_item_dir_flag = true
    BagModel:set_lock_item_dir_flag( true )
    for key, item_slot in pairs( self.item_slot_t ) do
        if item_slot.item_date and item_slot.item_date.flag == 1 then
            item_slot:set_slot_disable(  )
        end
    end
end

-- 所有物品变亮    
function BagWin:set_all_item_light(  )
    -- _lock_item_dir_flag = false
    BagModel:set_lock_item_dir_flag( false )
    for key, item_slot in pairs( self.item_slot_t ) do
        item_slot:set_slot_enable(  )
    end
end

-- 根据道具序列号设置指定物品 加颜色遮挡  
function BagWin:set_item_color_cover( series, rbga_value )
    local item_slot = self:get_slot_by_series( series )
    item_slot:show_cover_color( rbga_value )
end

-- 指定道具去掉颜色遮挡    
function BagWin:hide_item_color_cover( series )
    local item_slot = self:get_slot_by_series( series )
    if item_slot == nil then
        return
    end
    item_slot:hide_cover_color( )
end

-- 所有道具去掉颜色遮挡    
function BagWin:hide_all_color_cover(  )
    for key, item_slot in pairs( self.item_slot_t ) do
        item_slot:hide_cover_color(  )
    end
end

-- 根据 series 找到一个当前显示的slot
function BagWin:get_slot_by_series( series )
    for key, item_slot in pairs(self.item_slot_t) do
        if item_slot.item_date and item_slot.item_date.series == series then
            return item_slot
        end
    end
end

-- 设置指定cd组的效果 静态调用
function BagWin:update_item_cd( colGroup )
    local win = UIManager:find_window("bag_win")
    if win then
        for key, slotitem in pairs( win.item_slot_t ) do
            if slotitem.item_base and 
                ItemModel:check_item_belong_cd_group( slotitem.item_base.id, colGroup ) then
                local cd_time = ItemModel:get_item_cd_time( slotitem.item_base.id ) or 0
                cd_time = cd_time / 1000
                slotitem:play_cd_animation( cd_time  )
            end
        end
    end
end

-- 更新所有道具cd时间  (从新设置效果：当窗口关闭，效果会停止，所以要重新设置)
function BagWin:update_all_item_cd(  )
    for key, slotitem in pairs( self.item_slot_t ) do
        if slotitem.item_base then
            slotitem:stop_cd_animation(  )
            local cd_time = ItemModel:get_item_remain_cd( slotitem.item_base.id ) or 0
            local cd_percent = ItemModel:get_item_remain_cd_percent( slotitem.item_base.id )
            if cd_percent > 0 then
                slotitem:play_cd_animation( cd_time, cd_percent  )
            end
        end
    end
end


-- 提供外部静态调用的更新窗口方法
function BagWin:update_bag_win( update_type )
    local win = UIManager:find_visible_window("bag_win")
    if win then
        -- 把数据交给背包窗口显示
        win:update( update_type );   
    end
end

-- 更新数据
function BagWin:update( update_type )
    if update_type == "bag" then
        self:update_bag()      -- 注意这个 要放在重新显示数据的前面。
        self:update_all_item_cd(  )
    elseif update_type == "player" then 
        self:syn_player_date()
        self:update_all_item_cd(  )
    elseif update_type == "bagVolumn" then
        self:update_bag()
    elseif update_type == "all" then
        self:syn_player_date()      -- 注意这个 要放在重新显示数据的前面。
        self:update_bag()
        self:update_all_item_cd(  )
    elseif update_type == "cd" then
        self:update_all_item_cd(  )
    else
        self:syn_player_date()      -- 注意这个 要放在重新显示数据的前面。
        self:update_bag()
        self:update_all_item_cd(  )
    end
end

-- 同步和背包不一样道具的显示
function BagWin:update_bag()
    -- print("同步和背包不一样道具的显示BagWin:update_bag!!!!!!!!!!!!!!!!!!!")
    local max_grid_num = BagModel:get_bag_max_grid_num(  )
    for i = 1, max_grid_num do
        local item_slot = self.item_slot_t[i]
        if item_slot then
            if not BagModel:check_item_date_if_same( i, item_slot.item_date ) then    -- 判断界面显示数据是否和背包显示数据一样
                
                local item_date = ItemModel:get_item_by_position( i )
                self:set_one_slotItem_by_item_date( item_slot, item_date, i ) 
            end

            if item_slot.not_open_word then
                item_slot.view:removeChild( item_slot.not_open_word, true )
                item_slot.not_open_word = nil                                       -- 必须设置为nil，单击是否弹出扩展提示，根据这个来
                item_slot.grid_had_open = true
                if item_slot.item_date == nil then                                  -- 开通格子的情况，本来会有一个 禁用 图标，这里要去掉
                    item_slot:set_icon_texture("")
                end
            end

            if item_slot.bag_lock_pic then
                item_slot.view:removeChild(item_slot.bag_lock_pic, true)
                item_slot.bag_lock_pic = nil
                item_slot.grid_had_open = true
                if item_slot.item_date == nil then
                    item_slot:set_icon_texture("")
                end
            end
        end
    end

    -- 检查是否是“点击可扩展”的位置，如果不是就要去掉，是就加上
    for i = max_grid_num + 1, max_grid_num + 5 do
        local slot = self.item_slot_t[i]
        self:set_slot_not_open( slot, i - max_grid_num )      -- 设置未开锁状态    
    end

end

-- 同步人物数据: 包括金钱  最大格子数
function BagWin:syn_player_date(  )
    local player = EntityManager:get_player_avatar();
    self.lab_yuanBao:setString(  player.yuanbao ) -- [649]="#c00c0ff元  宝: #cd5c241%d"
    self.lab_bind:setString(  player.bindYuanbao ) -- [650]="#c00c0ff礼  券: #cffffff%d"
    self.lab_silver:setString( player.yinliang ) -- [651]="#c00c0ff银  两: #cffffff%d"
    self.lab_xianBi:setString(  player.bindYinliang) -- [652]="#c00c0ff仙  币: #cffffff%d"
end

-- 背包翻页，  静态调用
function BagWin:change_page( page_index )
    local win = UIManager:find_visible_window( _win_name )
    if win then
        if page_index < 6 and page_index > 0 then
            win:change_item_page_by_index( page_index )
        end
    end
end

function BagWin:active( show )
    -- 询问是否需要新手指引
    if ( show ) then
        
        --打包背包自动整理
        -- BagModel:request_arrange_bag(  )    -- 这里发送请求，服务器会返回不可以整理提示
        -- if not BagModel:get_lock_item_dir_flag() then 
        --     ItemModel:item_arrange(  )
        -- end


        self:update("all")
        SlotEffectManager.stop_current_effect()

        -- -- 如果当前在进行背包指引
        -- if ( XSZYManager:get_state() == XSZYConfig.BEI_BAO_ZY) then
        --     -- 先关闭锁定屏幕
        --     -- XSZYManager:unlock_screen(  );
        --     -- 取得10级成长礼包在第几格
        --     local x,y = MUtils:cal_bag_win_item_position( 18203 );
        --     -- 指向10级新手成长礼包
        --     if ( x and y ) then
        --         XSZYManager:play_jt_and_kuang_animation_by_id(XSZYConfig.BEI_BAO_ZY,1,XSZYConfig.OTHER_SELECT_TAG, x, y)
        --     end
        -- elseif ( XSZYManager:get_state() == XSZYConfig.CWRH_ZY) then
        --     local x,y = MUtils:cal_bag_win_item_position( 28292 );
        --     if ( x and y ) then
        --         if ( x and y ) then
        --             --XSZYManager:play_jt_and_kuang_animation( x,y,7 ,3,57,57 ,XSZYConfig.OTHER_SELECT_TAG )
        --             local function cb()
        --                 local item_info = ItemModel:get_item_info_by_id( 28292 )
        --                 ItemModel:use_a_item( item_info.series,0 )
        --             end
        --             XSZYManager:lock_screen( x,y,57,57 ,cb,3,7,true)
        --         end
        --     end
        -- end
    else
        LuaEffectManager:stop_view_effect(402,self.view)
        local buniess_win = UIManager:find_visible_window("buniess_win")
        BagModel:disable_cur_active_window()
        local ji_shou_shang_jia_win = UIManager:find_visible_window("ji_shou_shang_jia_win")
        -- print("run bag active buniess_win",buniess_win)
        if buniess_win ~= nil then
            BuniessModel:exit_btn_function()
            self:setZhenLiState(CLICK_STATE_UP)
        elseif ji_shou_shang_jia_win ~= nil then
            JiShouShangJiaModel:exit_window()
            self:setZhenLiState(CLICK_STATE_UP)
       --[[ elseif ( XSZYManager:get_state() == XSZYConfig.BEI_BAO_ZY) then
            AIManager:do_quest(TaskModel:get_zhuxian_quest());
            XSZYManager:destroy(XSZYConfig.OTHER_SELECT_TAG);
            -- 隐藏菜单栏
            local win = UIManager:find_window("menus_panel");
            win:show_or_hide_panel(false);--]]
        end
    end
end

function BagWin:destroy()
    Window.destroy(self)
    -- 所有slot值创建一次，使用retain来保留，这里要全部释放
    for key, slot in pairs( self.item_slot_t ) do
        safe_release(slot.view)
    end

    local buniess_win = UIManager:find_visible_window("buniess_win")
    BagModel:disable_cur_active_window()
    local ji_shou_shang_jia_win = UIManager:find_visible_window("ji_shou_shang_jia_win")
    if buniess_win ~= nil then
        BuniessModel:exit_btn_function()
    elseif ji_shou_shang_jia_win then
        JiShouShangJiaModel:exit_window()
    end
end

function BagWin:setZhenLiState(state)
    if self.btn_zhengli ~= nil then
        -- self.btn_zhengli:setCurState(state)
    end
end

-- 更新背包的道具
function BagWin:update_bag_item( user_item )
    local max_grid_num = BagModel:get_bag_max_grid_num(  )
    for i = 1, max_grid_num do
        local item_slot = self.item_slot_t[i]
        if item_slot then
            if item_slot.item_date and item_slot.item_date.series == user_item.series then    -- 判断界面显示数据是否和背包显示数据一样
                self:set_one_slotItem_by_item_date( item_slot, user_item, i )
                return; 
            end
        end
    end
end

--xiehande
--宠物领养特效
function BagWin:play_success_effect(  )
    -- body
    LuaEffectManager:play_view_effect(402,0,360,self.view,false,999 )
end

