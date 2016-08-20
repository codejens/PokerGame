-- 
-- filename: GuildCangKuWin.lua
-- created by HardGame on 2012-12-11
-- 仓库窗口


super_class.GuildCangKuWin(Window);

local _win_name = "guild_cangku_win"
local _max_page_index = 5          -- 最大显示页数



-- 整理按钮回调
local function arrange_cangku_item( eventType, x, y )
    if eventType == TOUCH_CLICK then
        GuildCangKuItemModel:item_arrange(  )
        GuildCangKuItemModel:request_arrange_cangku(  )
    end
    return true
end

-- 整理背包按钮回调
local function bag_cangku_item( eventType, x, y )
    if eventType == TOUCH_CLICK then 
        UIManager:show_window("bag_win")
        return true
    end
end

-- 创建一个按钮
-- x, y, w, h: 坐标
-- image_n: NormalState image
-- image_d: DownState image
-- image_m: MoveState image
function GuildCangKuWin:create_a_button(x, y, w, h, image_n, image_d, image_m)
    --按钮
    --用于设置按钮的各种状态

    local button = CCNGBtnMulTex:buttonWithFile(x, y, w, h, image_n);
    if (image_d ~= nil) then
        button:addTexWithFile(CLICK_STATE_DOWN, image_d);
    end
    if (image_m ~= nil) then
        button:addTexWithFile(CLICK_STATE_MOVE, image_m);
    end

    return button;
end

-- 创建背包窗口,(背景图名称)
function GuildCangKuWin:create_loadenter(panel)

    --底部颜色
    local cangku_ds = CCZXImage:imageWithFile( 30, 100, 390, 480, UIPIC_GRID_nine_grid_bg3, 500, 500)

    -- local cangku_ds = CCZXImage:imageWithFile(10,8,374,380,UIPIC_GRID_nine_grid_bg3,500,500)
    panel:addChild(cangku_ds)

    -- 页数指示
    -- 左翻页
    local function left_but_callback()
        self:change_to_pre_page()
    end
    self.left_but = UIButton:create_button_with_name( 55, 120, -1, -1, UIPIC_BagWin_0001, UIPIC_BagWin_0001, nil, "", left_but_callback )
    panel:addChild( self.left_but.view )
    self.left_but.set_double_click_func( left_but_callback )
    
    -- 右翻页
    local function right_but_callback()
        self:change_to_next_page()
    end
    self.right_but = UIButton:create_button_with_name( 360, 120, -1, -1, UIPIC_BagWin_0002, UIPIC_BagWin_0002, nil, "", right_but_callback )
    panel:addChild( self.right_but.view )
    self.right_but.set_double_click_func( right_but_callback )  -- 双击

    --圈圈的底色
    -- local  quan_ck_bg = CCZXImage:imageWithFile(15,78,360,-1,UIResourcePath.FileLocate.common .. "quan_bg.png",500,500)
    -- panel:addChild(quan_ck_bg)

    -- 圈圈
    local function circle_callback_func( page_index )
        if page_index then
            self:change_item_page_by_index( page_index )
        end
    end
    -- self.show_page_circle = MUtils:create_page_circle( 54, 80, _max_page_index, UIResourcePath.FileLocate.common .. "non_current_page_circle2.png", UIResourcePath.FileLocate.common .. "current_page_circle3.png", 25, 25, 50, circle_callback_func )
    -- panel:addChild( self.show_page_circle.view )  -- 双击

    self.show_page_circle = MUtils:create_page_circle( 114, 125, 5, 
        UIPIC_DREAMLAND_026,
        UIPIC_DREAMLAND_025, 
        46, 46, 46, circle_callback_func )
    panel:addChild(self.show_page_circle.view)

    function rule_explan_btn( )  --说明
        local guild_level = GuildModel:get_guild_building_level( "biMain" )
        local title_str = "#cfff000" .. guild_level .. "级家族仓库"
        local win = HelpPanel:show( 5, title_str,  Lang.guild.cangku.explain  )
        return true 
    end
    ZButton:create(self,UIResourcePath.FileLocate.normal .. "explain.png",rule_explan_btn, 80, 45,-1,-1)
    

    -- MUtils:create_common_btn(panel,"整理",arrange_cangku_item,165,28)
     --xiehande  通用按钮修改  --btn_lv2.png ->button2.png
    local btn=ZTextButton:create(panel,"整理",UIResourcePath.FileLocate.common .. "button2.png", arrange_cangku_item, 275, 30,140,-1, 1)

    -- MUtils:create_common_btn(panel,"背包",bag_cangku_item,300,15)

    self.lave_time_label = ZLabel:create(panel,"",132,76)--Lang.guild.cangku.lave_time

    return panel;
end

--初始化仓库窗口
function GuildCangKuWin:__init( window_name, window_info )
    self.item_page_t = {}             -- 存放页的表
    self.item_slot_t = {}             -- 存放所有已经创建的slot，key 对应背包位置. 这样就不用每次滑动都创建了。但要注意release
    self.current_page_index = 1       -- 当前页

    self.view = self:create_loadenter(self.view);  -- 初始化构建控件
    GuildCangKuItemModel:request_cangku_model(  )       -- 创建窗口时，要初始化仓库的数据

    self:change_item_page_by_index( 1 )


    if  GuildModel:is_zongzhu() == false then--是非宗主，更新下剩余取出数量
        GuildCC:req_lave_times()
        is_me_cangku_to_bag = false
    end
    -- 服务器有点bug，先实验用
    -- GuildCangKuItemModel:set_items_date( ItemModel:get_bag_data() )
end

-- 创建一页
local list_w = 308                 -- 单页的宽
local list_h = 277                 -- 单页的高
function GuildCangKuWin:create_one_item_page( page )
    local item_page = {}
    item_page.view = CCBasePanel:panelWithFile( 30, 190, 385, 374, "" )

    local start_x = 17
    local start_y = 302
    local slot_width = 64
    local slot_height = 64
    local gap = 9
    local now_x = start_x
    local now_y = start_y

    for i = 1, 5 do 
        for j = 1, 5 do 
            local index = (i - 1) * 5 + j + (page - 1) * 25
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
function GuildCangKuWin:change_to_pre_page(  )
    if self.current_page_index - 1 > 0 then
        self:change_item_page_by_index( self.current_page_index - 1 )
    end
end

-- 下一页
function GuildCangKuWin:change_to_next_page(  )
    if self.current_page_index < _max_page_index then
       self:change_item_page_by_index( self.current_page_index + 1 )
    end
end

-- 切换道具页，如果还没有，会创建
function GuildCangKuWin:change_item_page_by_index( page_index )
    -- 先影藏
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
    self.show_page_circle.change_page_index( self.current_page_index )

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

-- 物品列表滚动
-- function GuildCangKuWin:create_item_page_list(  )
--     -- 滑动区域
--     local list_w = 356                 -- 单页的宽
--     local list_h = 274                 -- 单页的高
--     local function create_Scroll_item( no_user, index )
--         -- local circle_index = self.item_scroll:getCurIndexPage()
--         -- self.show_page_circle.change_page_index( circle_index )
--         self.show_page_circle.change_page_index( index + 1 )

--         local list = List:create( nil, 8, 8, list_w , list_h, 5, 4 )
--         local item_panel = nil
--         local item_panel_x = 0
--         local item_panel_y = 0
--         local item_slot = nil
--         for i = 1, 5 * 4 do 
--             item_panel_x = ( (i - 1) % 5) * 62
--             item_panel_y = 4 - math.ceil( i / 5 ) * 62
--             item_slot = self:create_item_slot( 10, 10, 48, 48, index * 20 + i )
--             -- list 根据排列数量，计算好了每个格子大小，所以为了调坐标，这里要建个该大小的pannel
--             local item_bg = CCBasePanel:panelWithFile( 0, 0, list_w / 5, list_h / 4, "" );
--             item_bg:addChild( item_slot.view )
--             local obj = {}              -- list只显示  ***.view
--             obj.view = item_bg
--             list:addItem( obj )
--         end
--         return list
--     end
--     self.item_scroll = Scroll:create( nil, 10.5, 95, list_w, list_h, 5, TYPE_VERTICAL_EX, 1)
--     self.item_scroll:setScrollRunType(RUN_TYPE_PAGE)
--     self.item_scroll:setScrollCreatFunction(create_Scroll_item)
--     self.item_scroll:refresh()

--     return self.item_scroll
-- end

-- 创建道具显示对象
-- item_id: 物品ID
-- x, y, w, h: 坐标及尺寸大小
function GuildCangKuWin:create_item_slot (x, y, width, height, index)
   -- 如果已经创建过，就不再创建
    if self.item_slot_t[ index ] then
        return self.item_slot_t[ index ]
    end

    -- 基本的显示
    local item_obj = SlotBag(width, height);
    item_obj.index = index
    item_obj:set_icon_bg_texture( UIPIC_ITEMSLOT, -4, -4, 72, 72 )   -- 背框
    item_obj:setPosition (x, y);
    item_obj:set_icon_texture("");
    item_obj:set_select_effect_state( true )
    item_obj.grid_had_open = true                        -- 标记该格子是否已经开启

    -- 位置超出最大格子数的情况
    local max_grid_num = GuildCangKuItemModel:get_cangku_max_grid_num(  )
    if index > max_grid_num then
        self:set_slot_not_open( item_obj, index - max_grid_num )  -- 设置未开启状态
    end

    -- 背包该位置有数据才显示
    local item_date = GuildCangKuItemModel:get_item_by_position( index )
    if item_date then
        item_obj.item_date = Utils:table_clone( item_date )
        item_obj.item_base  = GuildCangKuItemModel:get_item_base_by_id( item_date.item_id )             -- 基础数据

        -- slot 具体道具的显示
        item_obj:set_drag_info( 1, _win_name, item_obj.item_date) -- 设置拖动传入的信息
        item_obj:set_icon (item_date.item_id);
        item_obj:set_lock( item_date.flag == 1 )         -- 是否绑定(锁)
        item_obj:set_color_frame( item_date.item_id, -2, -2, 68, 68 )     -- 边框颜色
        item_obj:set_item_count( item_date.count )       -- 数量
        item_obj:set_strong_level( item_date.strong )    -- 强化等级
        item_obj:set_gem_level( item_date.item_id )      -- 宝石的等级
    end

    -- 道具双击事件回调
    local function item_double_clicked ()
        GuildCangKuItemModel:item_double_click( item_obj )
    end
    -- 单击回调函数
    local function item_click_fun ()
        GuildCangKuItemModel:item_click( item_obj )
    end
    local function drag_out( self_item )
        -- item_obj:set_icon_texture("");
    end
    local function drag_in( source_item )
        -- print("仓库~~~~~~~~~drag_in~~~~~", source_item.win, source_item, source_item.obj_data.item_id )
        local source_win = source_item.win      -- 源窗口的名称
        -- 在本窗口内拖动， 就直接在dragin方法中给处理。直接改变两个slot的显示
        if source_win == _win_name then
            local slotitem_source = self:get_slot_by_series( source_item.obj_data.series )   
            -- 如果是窗口内拖动，就交换位置. 源必须有物品，否则就不会有任何交换
            if slotitem_source and item_obj.grid_had_open then
                -- 如果是同一类物品（id一样），并且是否锁定也一样，就合并
                if item_obj.item_date and item_obj.item_date.item_id == source_item.obj_data.item_id and item_obj.item_date.flag == source_item.obj_data.flag then
                    GuildCangkuCC:req_merge_items( item_obj.item_date.series, source_item.obj_data.series  )
                end
                -- item_obj.slot_index：本slot的index，  source_item.obj_data： 拖进来的数据， slotitem_source.slot_index：源的index， item_obj.obj_data 本slot数据
                GuildCangKuItemModel:change_item_by_index( item_obj.index, source_item.obj_data, slotitem_source.index, item_obj.item_date )
            end
        -- 背包窗口拖进来的
        elseif source_win == "bag_win" then
            GuildCangKuItemModel:item_drag_in_from_bag( source_item, item_obj )
        end
    end
    local function drag_callback( target_win )
        -- 成功拖到其他地方，把这个slot置空.  
        if target_win ~= _win_name then
            -- GuildCangKuWin:init_one_slotItem( item_obj )
        end
    end
    local function drag_invalid_callback(drag_object )
        -- drag_object:set_icon_texture(ItemConfig:get_item_icon(drag_object.obj_data.item_id));
    end 
    local function discard_item_callback( drag_object )
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
function GuildCangKuWin:set_one_slotItem_by_item_date( slotitem, item_date, slot_index )
    -- print("print先保留，测试背包开启的刷新平率使用：：：根据一个item model数据来设置slot")
    if item_date == nil then
        self:init_one_slotItem( slotitem )
        return 
    end
    slotitem.item_date = Utils:table_clone( item_date )
    --require "config/ItemConfig" 
    local item_base = ItemConfig:get_item_by_id( item_date.item_id )
    if item_base ~= nil then
        slotitem.item_base = item_base
    end
    slotitem.slot_index = slot_index                 -- 序列号，用来找到格子和数据的对应关系
    slotitem:set_drag_info( 1, _win_name, item_date) -- 设置拖动传入的信息
    slotitem:set_icon (item_date.item_id);
    slotitem:set_lock( item_date.flag == 1 )         -- 是否绑定(锁)
    slotitem:set_color_frame( item_date.item_id, -2, -2, 68, 68 )    -- 边框颜色
    slotitem:set_item_count( item_date.count )       -- 数量
    slotitem:set_strong_level( item_date.strong )    -- 强化等级
    slotitem:set_gem_level( item_date.item_id )      -- 宝石的等级
    slotitem.grid_had_open = true
    slotitem:set_select_effect_state( true )
end

-- 设置一个slotitem为空
function GuildCangKuWin:init_one_slotItem( slotitem )
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


function GuildCangKuWin:set_slot_open( slotitem)
    if slotitem.grid_had_open == false then
        self:init_one_slotItem( slotitem )
        slotitem.grid_had_open = true                        -- 标记该格子是否已经开启
    end 
end
-- 设置一个slotitem为未开启,  未开启格子前五个，要显示几个字: 点击可扩展
function GuildCangKuWin:set_slot_not_open( slotitem, count)
    if slotitem == nil then
        return 
    end
    -- print("设置一个slotitem为未开启,  未开启格子前五个，要显示几个字: 点击可扩展")
    self:init_one_slotItem( slotitem )
    -- slotitem:set_icon_texture(UIPIC_ITEMSLOT_DISABLE)

    if slotitem.bag_lock_pic == nil then
        slotitem.bag_lock_pic = CCZXImage:imageWithFile( -4, -4, -1, -1, UIPIC_ITEMSLOT_DISABLE)
        slotitem.view:addChild( slotitem.bag_lock_pic, 4 )
    end

    slotitem.grid_had_open = false                        -- 标记该格子是否已经开启
    slotitem:set_select_effect_state( false )

    -- -- 文字
    -- local word_image_t = {  UIResourcePath.FileLocate.bagAndCangKu .. "dian.png", 
    --                         UIResourcePath.FileLocate.bagAndCangKu .. "ji.png", 
    --                         UIResourcePath.FileLocate.bagAndCangKu .. "ke.png", 
    --                         UIResourcePath.FileLocate.bagAndCangKu .. "kuo.png",
    --                         UIResourcePath.FileLocate.bagAndCangKu .. "zhan.png", }
    -- if count <= 5 and count >= 1 then
    --     if slotitem.not_open_word == nil then
    --         slotitem.not_open_word = CCZXImage:imageWithFile( 6, 6, -1, -1, word_image_t[count] )
    --         slotitem.view:addChild( slotitem.not_open_word, 5 )
    --     end
    -- end
end


-- 根据 series 找到一个当前显示的slot
function GuildCangKuWin:get_slot_by_series( series )
    -- for i = 1, #self.item_slot_t do
    --     if self.item_slot_t[i].item_date and self.item_slot_t[i].item_date.series == series then
    --         return self.item_slot_t[i]
    --     end
    -- end
    for key, item_slot in pairs(self.item_slot_t) do
        if item_slot.item_date and item_slot.item_date.series == series then
            return item_slot
        end
    end
end

function GuildCangKuWin:active( if_show )
    if if_show then
        self:update()
        -- SlotEffectManager.stop_current_effect()
    end
end

-- 更新仓库窗口，数据变更时，提供给其他地方使用
function GuildCangKuWin:update_cangku_win( update_type )
    local win = UIManager:find_visible_window(_win_name)
    if win then
        win:update( update_type ); 
    end
end

-- 更新数据, 参数：类型:  cangku   player  
function GuildCangKuWin:update( update_type,param )
    if update_type == "cangku" then         -- 仓库数据更新
        self:update_cangku()
    elseif update_type == "player" then     -- 玩家数据更新
        self:update_cangku()
    elseif update_type == "control" then     --更新控件
        self:update_control(param)
    else                                    -- 全部更新
        self:update_cangku()
    end
end

function GuildCangKuWin:update_control(times)--更新控件
    if GuildModel:is_zongzhu() == false then --普通成员才显示
        if self.lave_time_label then
            if times then
                self.lave_time_label:setText(Lang.guild.cangku.lave_time ..times )
                self.lave_time_label.view:setIsVisible(true)
            end
        end
    else  --宗主和副宗主 不显示
        if self.lave_time_label then
            self.lave_time_label.view:setIsVisible(false)
        end
    end
end

-- 仓库数据变动引起的更新
function GuildCangKuWin:update_cangku(  )
    local item_slot = nil          -- 临时变量
    local item_date = nil          -- 临时变量
    local max_grid_num = GuildCangKuItemModel:get_cangku_max_grid_num(  )
    for i = 1, max_grid_num do
        item_slot = self.item_slot_t[i]
        if item_slot then
            self:set_slot_open(item_slot) --刷新未开启的

            if not GuildCangKuItemModel:check_item_date_if_same( i, item_slot.item_date ) then    -- 判断界面显示数据是否和最新数据一样
                item_date = GuildCangKuItemModel:get_item_by_position( i )
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


-- 发送扩展格子的请求
local function send_expand_cangku(  )
    GuildCangkuCC:req_expand_grid_count ()
end

-- 显示扩展背包需要的金钱的提示窗口
function GuildCangKuWin:show_expand_bag_confirm_win( money_count, grid_count )
    local count = grid_count or 0
    local money = money_count or 0
    local notice_words = LangGameString[709]..count..LangGameString[710]..money..LangGameString[711] -- [709]="扩展" -- [710]="格仓库,需要花费" -- [711]="元宝，是否继续？"
    ConfirmWin( "select_confirm", nil, notice_words, send_expand_cangku, nil, 50, nil)
end

function GuildCangKuWin:destroy()
    Window.destroy(self)
    -- 所有slot值创建一次，使用retain来保留，这里要全部释放
    for key, slot in pairs( self.item_slot_t ) do
        safe_release(slot.view)
    end
end
