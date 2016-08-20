-- Synth.lua
-- created by lyl on 2012-12-13
-- 炼器--物品合成面板

super_class.Synth(Window)

local _left_slotitem_item_source = nil   --左侧合成前的item，保存起来，动态修改
local _left_slotitem_item_result = nil   --左侧合成后的item，保存起来，动态修改

-- 序列号的集合。批量合成使用
local _series_t = {}

local cur_selected_btn = 1

-- 可以购买的物品的id的集合
local _can_buy_item_id_t = { [18710] = true, [18711] = true, [18712] = true, [18713] = true,
                             [18720] = true, }

-- item 的type，表示装备的号码。用于某件物品是否是装备判断
local _equi_num_t = { [1] = true, [2] = true, [3] = true, [4] = true,
                      [5] = true, [6] = true, [7] = true, [8] = true,
                      [9] = true, [10] = true }


-- 记录右侧装备区，是背包还是人物状态.默认时人物
local _r_up_item_type = "gem"

local _r_up_equi_or_bag

local _had_show_explain = false             --标记为未显示  说明面板

local _item_num_need    = 0                 --需要物品的数量.  记录合成物品下面的数量显示
local _item_num_have    = 0                 --选中物品的数量
local _pay_for_synth    = 0                 --手续费

-- local color_yellow = "#cffff00"
-- local color_green = "#c00ff00"
local font_size = 16
local item_font_size = 16

-- ui data
local _panel_w = 900
local _panel_h = 500
local _panel_inter = 10
local _panel_half_w = 430
local _btn_w = 105  -- 主界面tab按钮
local _btn_h = 45
local _synth_btn_y =35
local synth_btn_w = 120
local synth_btn_h = 50
local s_btn_wucha = 10

local _tab_l_w = 92   -- 分页界面tab按钮，从btn图片ui获取 (button_2_n)
local _tab_l_h = 37

-- 材料面板高度
local _panel_res_h = 185

function Synth:__init(  )
    self.panel_t = {}                  --存储panel的表。用于改变panel内容
    self.label_t = {}                  --存储label的表。用于改变label显示的内容
    self.right_item_t = {}             --存储右侧上部分的所有item。用于清空处理
    self.r_up_scroll = nil
    self.r_down_scroll = nil
    self.r_up_but_t = {}               -- 按钮做成单选用,需要操作所有按钮，设置状态
    _left_slotitem_item_source = nil
    _left_slotitem_item_result = nil
    _series_t = {}
    self.r_up_all_item_t = {}

    self.view:addChild( self:create_left_btn_panel() )
    self.view:addChild( self:create_right_panel() )
    self.view:addChild( self:create_mid_panel() )
end


function Synth:create_right_panel(  )
    local panel = CCBasePanel:panelWithFile( 10, 10, 420, _panel_h-_tab_l_h - 12, UILH_COMMON.bottom_bg, 500, 500 )
    -- panel:setIsVisible( false )
    -- 创建item; 默认显示角色中的装备
    self:create_bag_slot( panel, "gem")
  
    self.panel_t["right_panel"] = panel              --存入table，用于动态修改
    return panel
end

function Synth:unselecte_all_item( ... )
    for k,show_item_panel in pairs(self.r_up_all_item_t) do
        show_item_panel.set_selected(false)
    end
end

function Synth:destroy()
    Window.destroy(self)
end

function Synth:create_mid_panel(  )
    local bg_panel = CCBasePanel:panelWithFile( 428, 10, 430, 488, UILH_COMMON.bottom_bg, 500, 500 )

    -- 添加右面板背景图( 火焰图)
    -- local bg_left = CCZXImage:imageWithFile( 3, 0, -1, -1, UILH_FORGE.bg); 
    -- bg_panel:addChild( bg_left )
    -- local bg_right = CCZXImage:imageWithFile( _panel_half_w-3, 0, -1, -1, UILH_FORGE.bg);
    -- bg_right:setScaleX( -1 ) 
    -- bg_panel:addChild( bg_right )

     --bg_panel:setIsVisible( false )
    self:create_mid_btm_panel(bg_panel)

    local panel = CCBasePanel:panelWithFile( 0, _panel_res_h, _panel_half_w, _panel_h-_panel_res_h, "", 500, 500 )
    bg_panel:addChild(panel)

    -- ------------------------------------------------
    -- 说明按钮
    local function help_btn_callback( ... )
        -- print("help_btn click")
        ForgeModel:show_help_panel( UILH_FORGE.snyth_notic, Lang.forge.synth_info )
    end
    local help_panel = ZBasePanel:create( panel, "", 280, 249, 115, 40 )
    help_panel:setTouchClickFun(help_btn_callback)

    local help_btn = ZButton:create(help_panel, UILH_NORMAL.wenhao, help_btn_callback, 0, 0, -1, -1)
    local help_btn_size = help_btn:getSize()
    local help_img = ZImage:create(help_btn, UILH_FORGE.snyth_img, 0, 0, -1, -1 )
    local help_img_size = help_img:getSize()
    help_img:setPosition( help_btn_size.width, ( help_btn_size.height - help_img_size.height ) / 2 )

    --local title_bg = CCZXImage:imageWithFile( 305, 260+5, -1, -1, UILH_FORGE.snyth_img )
    --panel:addChild( title_bg )
    -- 材料和 目标转化物的名称
    self.label_t["source_item_name"] = UILabel:create_lable_2("", 88+84*0.5, 240, font_size, ALIGN_CENTER)
    panel:addChild(self.label_t["source_item_name"])
    self.label_t["target_item_name"] = UILabel:create_lable_2("", _panel_half_w-88-84*0.5, 240, font_size, ALIGN_CENTER)
    panel:addChild(self.label_t["target_item_name"])

    --------------------------------------------------------------------------------------
    -- 两个框框中间那个向右的箭头
    local to_right_img = CCZXImage:imageWithFile((_panel_half_w-52)*0.5 - 5, 173, -1, -1, UILH_COMMON.right_arrows)
    panel:addChild(to_right_img)

    -- 第二个框框的背景
    local item_result_bg = CCZXImage:imageWithFile(_panel_half_w-88-84-11, 154-11, 98, 98, UILH_NORMAL.light_grid)
    panel:addChild(item_result_bg)

    -- 两个框框
    _left_slotitem_item_source = self:create_item( panel, nil, 88, 154, "source" )
    ZImage:create(_left_slotitem_item_source.icon_bg, UILH_FORGE.cl_img, 25, 34, -1, -1)

    _left_slotitem_item_result = self:create_item( panel, nil, _panel_half_w-88-84, 154, "result" )
    ZImage:create(_left_slotitem_item_result.icon_bg, UILH_FORGE.cl_img, 25, 34, -1, -1)

    -- 当前可获取的数量和需要数量，例如：1/4
    local label_temp = UILabel:create_label_1("", CCSize(100,40), 88+84*0.5, 145, font_size, CCTextAlignmentCenter, 255, 255, 0)
    self.label_t[ "num_label" ]  = label_temp            --存储起来，使用关键字获取并修改显示内容
    panel:addChild( label_temp )

    -- 手续费 title
    local label_temp = UILabel:create_lable_2( LH_COLOR[2] .. Lang.forge.synth[11], _panel_half_w*0.5-30, 170-50, font_size, ALIGN_RIGHT)
    panel:addChild( label_temp )

    -- -- 铜币图片
    -- local gold_png = CCZXImage:imageWithFile((410-32)*0.5, 74+40-30, 32, 32, UIPIC_FORGE_049)
    -- panel:addChild(gold_png)

    -- 手续费
    self.label_t[ "pay_label" ]  = UILabel:create_lable_2(LH_COLOR[2] .. "0" .. Lang.forge.synth[18], _panel_half_w*0.5-20, 170-50, font_size, ALIGN_LEFT)
    panel:addChild(self.label_t["pay_label"])

    --------------------------------------------------
    local synth_btn_font = 14

    -- 合成按钮 --------------------------------------------------------------------------------------
    local synth_btn = CCNGBtnMulTex:buttonWithFile( 30, _synth_btn_y, -1, -1, UILH_COMMON.btn4_nor )
    synth_btn:addTexWithFile(CLICK_STATE_DOWN, UILH_COMMON.btn4_nor)
    synth_btn:addTexWithFile(CLICK_STATE_DISABLE, UILH_COMMON.btn4_dis)
    local function synth_btn_callback(eventType,x,y)
        if eventType == TOUCH_CLICK then 
            if self:check_can_synth() then    -- 如果已有的材料不足合成一次，无效
                ForgeModel:one_item_synth( _series_t )
                return true
            else
                return true
            end
        end
        return true
    end
    synth_btn:registerScriptHandler(synth_btn_callback)                  --注册
    panel:addChild(synth_btn)
    --按钮显示的名称
    local label_synth_btn = UILabel:create_label_1(LH_COLOR[2] .. Lang.forge.synth[14], CCSize(-1,-1), 32 , 28, 16, CCTextAlignmentLeft, 255, 255, 255)
    synth_btn:addChild( label_synth_btn )   
    self.synth_btn = synth_btn
    synth_btn:setCurState( CLICK_STATE_DISABLE ) 

    -- 一键合成按钮----------------------------------
    local once_synth_btn_callback = function( ... )
        -- if self:check_can_synth() then
        UIManager:show_window( "synth_confirm_win", true )
        return true
    end
    local once_synth_btn = ZTextButton:create( panel, LH_COLOR[2] .. Lang.forge.synth[13], UILH_COMMON.btn4_nor, once_synth_btn_callback, (_panel_half_w-synth_btn_w)*0.5, _synth_btn_y, synth_btn_w, synth_btn_h)
    once_synth_btn:setFontSize(synth_btn_font)
    self.once_synth_btn = once_synth_btn

    -- 批量合成按钮----------------------------------
    -- local batch_synth_btn_callback = function( ... )
    --     if _left_slotitem_item_source.item_id and self:check_can_batch_synth() then
    --         ForgeModel:batch_synth( _series_t, _left_slotitem_item_source.item_id )
    --     end
    -- end   
    -- local batch_synth_btn = ZTextButton:create( panel, Lang.forge.synth[12], UILH_COMMON.lh_button_4_r, batch_synth_btn_callback, _panel_half_w-synth_btn_w-30, _synth_btn_y, synth_btn_w, synth_btn_h)
    -- batch_synth_btn:setFontSize(synth_btn_font)
    -- self.batch_synth_btn = batch_synth_btn

    --end
    local batch_synth_btn = CCNGBtnMulTex:buttonWithFile( _panel_half_w-synth_btn_w-30, _synth_btn_y, -1, -1, UILH_COMMON.lh_button_4_r )
    batch_synth_btn:addTexWithFile(CLICK_STATE_DOWN, UILH_COMMON.lh_button_4_r)
    batch_synth_btn:addTexWithFile(CLICK_STATE_DISABLE, UILH_COMMON.btn4_dis)
    local function batch_synth_btn_callback(eventType,x,y)
        if eventType == TOUCH_CLICK then 
            if _left_slotitem_item_source.item_id and self:check_can_batch_synth() then
                ForgeModel:batch_synth( _series_t, _left_slotitem_item_source.item_id )
            end
        end
        return true
    end
    batch_synth_btn:registerScriptHandler(batch_synth_btn_callback)                  --注册
    panel:addChild(batch_synth_btn)
    --按钮显示的名称
    local label_batch_synth_btn = UILabel:create_label_1(LH_COLOR[2] .. Lang.forge.synth[12], CCSize(-1,-1), 25 , 28, 16, CCTextAlignmentLeft, 255, 255, 255)
    batch_synth_btn:addChild( label_batch_synth_btn )   
    self.batch_synth_btn = batch_synth_btn
    batch_synth_btn:setCurState( CLICK_STATE_DISABLE ) 
    -----------------------end
    
    return bg_panel
end

function Synth:create_mid_btm_panel( parent )
    local _mid_btm_panel = CCBasePanel:panelWithFile( 7, 7, _panel_half_w-13, _panel_res_h-5, UILH_COMMON.bg_10, 500, 500 )
    parent:addChild(_mid_btm_panel)

    -- title
    -- local title_panel = CCBasePanel:panelWithFile( 0, 140, -1, -1, "" , 500, 500 )
    local title_w = 417
    local title_panel = CCBasePanel:panelWithFile( (_panel_half_w-13) / 2, _panel_res_h-5, -1, -1, UILH_NORMAL.title_bg3 )
    title_panel:setAnchorPoint(0.5,0.5)
    local titel_size = title_panel:getSize()
    _mid_btm_panel:addChild( title_panel )
    local title_label = UILabel:create_lable_2( LH_COLOR[1] .. Lang.forge.synth[19], titel_size.width*0.5, 15, 18, ALIGN_CENTER )
    title_panel:addChild( title_label )

    self:create_all_mate_slot( _mid_btm_panel )

    self.mid_btm_panel = _mid_btm_panel

end

function Synth:create_left_btn_panel(  )
    local bgPanel = CCBasePanel:panelWithFile( 0, 0, (_panel_w-_panel_inter*3)*0.5, _panel_h, "", 500, 500 )

    local btn_num = 3
    local btn_idx = 1
    local btn_int_x = 93          --按钮y坐标间隔
    local btn_beg_x = 20          --按钮起始x坐标
    local btn_beg_y = _panel_h-_tab_l_h-4        --按钮起始y坐标

    self.raido_btn_group = CCRadioButtonGroup:buttonGroupWithFile(btn_beg_x , btn_beg_y, btn_num*btn_int_x, _tab_l_h, nil)
    bgPanel:addChild(self.raido_btn_group)

    btn_idx = 1
    self:create_a_button(self.raido_btn_group, 1 + btn_int_x * (btn_idx-1),1, -1, -1, 
        UILH_COMMON.button_2_n,
        UILH_COMMON.button_2_s, 
        Lang.forge.synth[22],
        93, 26, btn_idx)

    btn_idx = btn_idx + 1
    self:create_a_button(self.raido_btn_group, 1 + btn_int_x * (btn_idx-1),1,  -1, -1, 
        UILH_COMMON.button_2_n,
        UILH_COMMON.button_2_s, 
        Lang.forge.synth[23],
        93, 26, btn_idx)
    btn_idx = btn_idx + 1
    self:create_a_button(self.raido_btn_group, 1 + btn_int_x * (btn_idx-1), 1, -1, -1, 
        UILH_COMMON.button_2_n,
        UILH_COMMON.button_2_s, 
        Lang.forge.synth[24],
        93, 26, btn_idx)

    return bgPanel
end


local btn_name = {"gem","strengthen", "other"} -- "pet",
-- 创建一个按钮:参数： 要加入的panel， 坐标和长宽，按钮两种状态背景图，显示文字图片，文字图片的长宽，序列号（用于触发事件判断调用的方法）
function Synth:create_a_button(panel, pos_x, pos_y, size_w, size_h, image_n, image_s ,but_name, but_name_siz_w, but_name_siz_h, but_index)
    local radio_button = CCRadioButton:radioButtonWithFile(pos_x, pos_y, size_w, size_h, image_n)
    radio_button:addTexWithFile(CLICK_STATE_DOWN,image_s)
    local function but_1_fun(eventType,x,y)
        if eventType == TOUCH_BEGAN  then 
            return true
        elseif eventType == TOUCH_CLICK then
            cur_selected_btn = but_index
            _r_up_item_type = btn_name[but_index];
            self:clear_forge_panel_item()
            self:flash_all_item_right( _r_up_item_type )
            -- self.r_up_scroll:autoAdjustItemPos(true)
            return true;
        elseif eventType == TOUCH_ENDED then
            return true;
        end
    end
    radio_button:registerScriptHandler(but_1_fun)    --注册
    panel:addGroup(radio_button)

    --按钮显示的名称
    -- local name_image = CCZXImage:imageWithFile( 10,  10, but_name_siz_w, but_name_siz_h, but_name );  
    local tab_name = UILabel:create_lable_2(but_name, 92/2, 10, font_size, ALIGN_CENTER)
    radio_button:addChild( tab_name )
    return radio_button
end

-- 初始化数据
function Synth:syn_date(  )
    self:syn_sele_item()
    self:flash_all_item_right(_r_up_item_type)
    self:check_action_but_able(  )
end

function Synth:update( update_type )
    -- print("Synth:update( update_type )",update_type)
    if update_type == "bag" or update_type == "bag_change" or update_type == "bag_add" or update_type == "bag_remove" then
        -- self:set_left_item( nil, 0, nil, nil)
        self:syn_date(  )
    elseif update_type == "all" then
        self:set_left_item( nil, 0, nil, nil)      -- 每次打开都清空选中物品
        self:syn_date(  )
    end 
end

-- 同步选中装备的最新属性(重新从人物或者背包model获取数据)
function Synth:syn_sele_item(  )
    -- 设置当前用的数量 （根据序列号列表来计算,虽然在设置左侧item属性时会计算，但是这里，因为合成后数量减少了，所以要重新按序列号列表来加）
    local num_temp = 0
    local series_temp = {}          -- 合成后可能会有物品已经不存在，重新设置一个序列号表，把没有的去掉
    for i, v in ipairs(_series_t) do 
        local item = ItemModel:get_item_by_series( v )
        if item ~= nil then
            num_temp = num_temp + item.count
            series_temp[ #series_temp + 1 ] = v
        end
    end
    _series_t = series_temp
    if num_temp == 0 then
        self:set_left_item(nil, 0, nil, nil )
        _item_num_need = nil
    end
    _item_num_have = num_temp
    self:flash_all_label_by_name()
end


-- 选择两个item可以叠加数量。如果两个都不足，合成成功，但是服务器没有发送相关消息。这里暂时自己判断，如果有数量不足的，就请求获取背包列表
function Synth:request_bag_items_check(  )
    local num_temp = 0
    local check_temp = false
    for i, v in ipairs(_series_t) do 
        item = ItemModel:get_item_by_series( v )
        if item ~= nil and item.count < _item_num_need then
            check_temp = true
        end
    end
    if check_temp then
        ItemCC:request_player_bag_items(  )
    end
end

-- 返回每个panel，用于炼器主截面清除所有内容。切换界面的时候用
function  Synth:get_all_panel()
    return { self.panel_t["left_panel"], self.panel_t["right_panel"], self.panel_t["right_mate_panel"] }
end


-- 刷新所有label，根据新值，从新设置label的内容
function Synth:flash_all_label_by_name( )
    if _item_num_need ~= nil then               --如果需要的数字为空，则不显示   
        -- 如果材料不够，则显示红色
        local color_hex = nil
        if _item_num_have < _item_num_need then
            -- UILabel:setAttrColor(self.label_t[ "num_label" ], 255, 0, 0)
            color_hex = "#c"..Utils:hex_to_dec(255)..Utils:hex_to_dec(0)..Utils:hex_to_dec(0)
        else
            -- UILabel:setAttrColor(self.label_t[ "num_label" ], 255, 255, 0)
            color_hex = "#c"..Utils:hex_to_dec(255)..Utils:hex_to_dec(255)..Utils:hex_to_dec(0)
        end 
        self.label_t[ "num_label" ]:setString( color_hex.._item_num_have .. "/" .. _item_num_need ) 
        -- self.label_t["num_tips"]:setString("每" .. _item_num_need .. "个低级材料合成1个高级材料")
    else
        self.label_t[ "num_label" ]:setString( "" )
        -- self.label_t["num_tips"]:setString("")
    end

    --如果需要的费用设置为nil，则不显示(注意：因为需要的费用可能为0，所以要用nil判断)
    if _pay_for_synth ~= nil then
        self.label_t[ "pay_label" ]:setString(LH_COLOR[2] .. _pay_for_synth .. Lang.forge.synth[18])
    else
        self.label_t[ "pay_label" ]:setString( LH_COLOR[2] .. "0" .. Lang.forge.synth[18] )
    end

    if _source_item_id then
        local source_item_name = ForgeModel:get_item_name_with_color( _source_item_id )    --获取item名称
        self.label_t["source_item_name"]:setString( COLOR.y .. source_item_name )
    else
        self.label_t["source_item_name"]:setString("")
    end

    if _target_item_id then
        local target_item_name = ForgeModel:get_item_name_with_color( _target_item_id )    --获取item名称
        self.label_t["target_item_name"]:setString( COLOR.y .. target_item_name )
    else
        self.label_t["target_item_name"]:setString("")
    end
end

function Synth:clear_forge_panel_item(  )
    --清空左侧所有item( 源物品清空后，会自动清空结果物品)
    -- self:set_r_up_one_slot_able( slotItem.item_series )
    self:set_left_item( nil, 0, nil, nil)
    _item_num_need    = nil      -- 设置这几个值为nil，刷新label就会把lable置为空
    _item_num_have    = nil
    _pay_for_synth    = nil
    _source_item_id = nil
    _target_item_id = nil
    self:flash_all_label_by_name( )
end

-- 创建一个item 包括slotitem和信息 
function Synth:create_item( panel, item_series, po_x , po_y, type)
    local slot_w, slot_h = 80, 80
    local slotItem = SlotItem(slot_w, slot_h)
    slotItem:set_icon_bg_texture( UILH_COMMON.slot_bg, -4, -4, 84, 84 )   -- 背框

    --获取item_id 。默认用一个不存在的id  0，可以去到默认图标
    local item_id = 0

    -- slotItem:set_icon( item_id )

    slotItem:setPosition( po_x , po_y )
    --设置回调单击函数
    local function f1()
        if "source" == type then
            --清空左侧所有item( 源物品清空后，会自动清空结果物品)
            self:set_r_up_one_slot_able( slotItem.item_series )
            self:set_left_item( nil, 0, nil, nil)
            _item_num_need    = nil      -- 设置这几个值为nil，刷新label就会把lable置为空
            _item_num_have    = nil
            _pay_for_synth    = nil
            self:flash_all_label_by_name( )
            -- 去掉选中框
            self:unselecte_all_item()
        elseif "result" == type then
            
        end
    end
    slotItem:set_double_click_event( f1 )

    local function f2( ... )
        local a, b, arg = ...
        local position = Utils:Split(arg,":");
            -- 将相对坐标转化成屏幕坐标(即OpenGL坐标 800x480)
            -- print("没有转的坐标：：：", position[1],position[2])
        local pos = slotItem.view:getParent():convertToWorldSpace( CCPointMake(position[1],position[2]) );
        ForgeModel:show_item_tips( slotItem.item_id, pos.x,pos.y  )
    end
    slotItem:set_click_event( f2 )

    panel:addChild( slotItem.view )

    -- 加默认提示字
    -- slotItem.default_word = UILabel:create_label_1("材料", CCSize(100,15), 30, 30, 12, CCTextAlignmentCenter, 255, 255, 0)    
    -- slotItem.default_word = CCZXImage:imageWithFile( 0, 0, 55, 55, UIResourcePath.FileLocate.role .. "text_cailiao.png" )
    -- slotItem.view:addChild( slotItem.default_word )           --因为lable要随slot共存亡，所以是添加到slot的view中

    --需要item存储一下选中的slot的数据。初始化设置为nil(起始可以不写，这里是为了有一种"定义了的"印象)
    slotItem.level       = nil
    slotItem.item_series = nil
    slotItem.item_id     = nil

    return slotItem
end

-- 设置左侧，item的属性:类型 字符串(类型),物品id(是基本属性，不是序列号，注意了)， 强化等级, 物品序列号
function Synth:set_left_item( type, item_id, num, item_series)
    -- 设置数量和花费
    _item_num_need = ForgeModel:get_need_num_by_id( item_id )
    local check_temp1 = false                    -- 判断序列号是否在选中的序列号列表中存在，如果不存在并且itemid相等，就叠加数量
    local idx = 1
    for i, v in ipairs(_series_t) do
        if v == item_series then
            check_temp1 = true
            idx = i
        end
    end
    -- 如果 和已选物品是同一类型，并且没有被选择过(根据序列号列表)，就加数量.
    -- (如果没有设置过，source为nil，这时item_id为nil， 两者会相等，进入语句，出错)
    if item_series and item_id == _left_slotitem_item_source.item_id then
        if check_temp1 then
            table.remove( _series_t, idx )
            _item_num_have = _item_num_have - num
            self:flash_all_label_by_name()
            return
        else 
            _series_t[#_series_t + 1] = item_series
            _item_num_have = _item_num_have + num
        end
    else
        _series_t = {}                                                       -- 新种类物品，清空table
        _series_t[#_series_t + 1] = item_series 
        _item_num_have = num
    end

    _source_item_id = item_id
    _pay_for_synth = ForgeModel:get_need_money_by_id( item_id )
    _left_slotitem_item_source:set_gem_level( tonumber(item_id) )
    _left_slotitem_item_source:set_color_frame( item_id, -2, -2, 80, 80 ) 


    _left_slotitem_item_source.item_series  = item_series    --记录序列号，发送请求的时候需要
    _left_slotitem_item_source.item_id = item_id      --记录物品id，发送请求的时候需要
    -- _left_slotitem_item_source:set_icon( item_id )      

    local target_item_id = self:get_mix_result_item_id( item_id ) or 0
    _target_item_id = target_item_id
     
    --设置图标
    _left_slotitem_item_result:set_icon( target_item_id )  --结果item设置合成后的icon, 或者设置为空
    _left_slotitem_item_result.item_id = target_item_id
    _left_slotitem_item_result:set_gem_level( tonumber(target_item_id) )         -- 宝石的等级显示
    _left_slotitem_item_result:set_color_frame( target_item_id, -2, -2, 80, 80 )

    -- 先判断 用该item_id是否能找到静态数据
    local item_base = ItemConfig:get_item_by_id( item_id )
    if item_base then 
        _left_slotitem_item_source:set_icon( item_id )                                              --设置图标
    else
        _left_slotitem_item_source:set_icon_texture( "" )                                           -- 如果找不到，就去掉背景图
        _left_slotitem_item_result:set_icon_texture( "" )
    end
    
    self:set_slot_lock( item_series, _left_slotitem_item_source)

    self:check_action_but_able(  )
    self:flash_all_label_by_name()

end


-- 获取最大合成数.(在批量合成弹出的键盘中，会调用)
function Synth:get_max_synth_num(  )
    return  _item_num_have / _item_num_need  - (_item_num_have / _item_num_need % 1)
end
-- 根据批量合成的数量，返回总共花费( 在键盘中也会调用 )
function Synth:get_total_pay_by_num( num )
    return num * _pay_for_synth
end


-- 删除说明
function Synth:remove_explain_panel(  )
    if _had_show_explain == false then
        return 
    end
    self.panel_t["left_panel"]:removeChild( self.explain_bg, true )
    self.panel_t["left_panel"]:removeChild( self.explain_title_bg, true )
    self.panel_t["left_panel"]:removeChild( self.explain_title_name, true )
    self.panel_t["left_panel"]:removeChild( self.explain_label, true )
    self.panel_t["left_panel"]:removeChild( self.explain_tail_line, true )
    _had_show_explain = false
end

-- 设置强化按钮是否可以有效
function Synth:check_action_but_able(  )
    -- print(" -----------------------check_action_but_able: ")
    -- 如果没选择装备或者 没有选中镶嵌的宝石（注：不包括本来就镶嵌的宝石，按钮就无效）
    if _item_num_need == nil or _item_num_have < _item_num_need then  
        self.synth_btn:setCurState( CLICK_STATE_DISABLE ) 
    else
        self.synth_btn:setCurState( CLICK_STATE_UP )
    end

    if  _item_num_need == nil or  _item_num_have  < _item_num_need * 2 then
        self.batch_synth_btn:setCurState( CLICK_STATE_DISABLE ) 
    else
        self.batch_synth_btn:setCurState( CLICK_STATE_UP )
    end
end

function Synth:check_can_synth( ... )
    if _item_num_need == nil or _item_num_have < _item_num_need then
        local show_content = Lang.forge.synth[15]
        GlobalFunc:create_screen_notic( show_content, nil, 450, 130 )
        return false
    else
        return true
    end
end

function Synth:check_can_batch_synth( ... )
    if _item_num_need == nil or _item_num_have < _item_num_need * 2 then
        local show_content = Lang.forge.synth[15]
        GlobalFunc:create_screen_notic(show_content, nil, 450, 130)
        return false
    else
        return true
    end
end

local _RIDIO_BTN_GROUP_Y = {308,144}


-- 设置按钮状态（实现单选），参数：位置标记，按钮序列号
function Synth:but_select_one( place, index )
    local but_table = {}
    if place == "right_up" then
        but_table = self.r_up_but_t
    end
    for i, v in ipairs( but_table ) do
        v:setCurState( CLICK_STATE_DOWN )
    end
    if but_table[ index ] then
        but_table[ index ]:setCurState( CLICK_STATE_UP )
    else
        -- print("error!!! !!! !!! Synth:but_select_one !!! !!! !!!  "..tostring(but_table[ index ]))
    end
end


--创建背包中的可升级物品slotitem:参数：要加入的面板， 物品的类型（宝石 gem ，强化 strengthen ，其他 other ）
-- 左面板下面的scrollView
function Synth:create_bag_slot( panel, item_type )
    local bag_items, bag_item_count = ForgeModel:get_bag_date_range_by_id() --背包中物品的集合和数量
    local item_bag = nil                                          --背包中存储的item数据，注意和基本item数据区分
    local place_index = 1                                      --这里物品不是每个都显示的，要判断（类型，和是否合适装备使用），所以位置要分开计数
    local item_base = nil                                      --基础item数据，用来回去改物品的公共属性

    require "config/ItemConfig"
    local slotItem_t = {}
    self.slot_par = {}
    local scroll = nil
    -- item 图标的位置
    local slot_item_x = 18
    local slot_item_y = 22

    --遍历背包中的所有装备，创建出item显示出来
    for i = 1, bag_item_count do
        item_bag = bag_items[i]
        if item_bag then
            item_base = ItemConfig:get_item_by_id( item_bag.item_id )
        end
        -- 根据类型显示物品种类.      85 宝石  87 强化 
        if item_bag and self:check_if_can_synth( item_bag.item_id ) then
            if  "gem" == item_type then
                if ( item_base and ForgeModel:check_if_syn_gem( item_base.id ) ) then            --创建类型
                    -- self:create_item_right( panel, item_bag.item_id, slot_beg_x + slot_int_x*  ((place_index - 1) % 4 ) , slot_beg_y - slot_int_y  * ((place_index - 1) / 4 - (place_index - 1)/4%1 ) , 40, 40, item_bag.count, item_bag.series)
                    -- place_index = place_index + 1
                    self.slot_par[ #self.slot_par + 1] = { item_bag.item_id, slot_item_x, slot_item_y , 55, 55, item_bag.count, item_bag.series }
                end
            elseif "strengthen" == item_type then
                if item_base and  ForgeModel:check_if_syn_strength( item_base.id ) then  
                    self.slot_par[ #self.slot_par + 1] = { item_bag.item_id, slot_item_x, slot_item_y , 55, 55, item_bag.count, item_bag.series }
                end
            -- elseif "wing" == item_type then
            --     if item_base and ForgeModel:check_if_syn_wing(item_base.id) then
            --         self.slot_par[#self.slot_par + 1] = {item_bag.item_id, 15, 15, 55, 55, item_bag.count, item_bag.series}
            --     end
            -- elseif "pet" == item_type then
            --     if item_base and ForgeModel:check_if_syn_pet(item_base.id) then
            --         self.slot_par[#self.slot_par + 1] = {item_bag.item_id, slot_item_x, slot_item_y, 55, 55, item_bag.count, item_bag.series}
            --     end
            elseif "other" == item_type then
                if ( item_base and (not ForgeModel:check_if_syn_strength( item_base.id )) 
                        and (not ForgeModel:check_if_syn_gem( item_base.id ) ) ) then  
                    self.slot_par[ #self.slot_par + 1] = { item_bag.item_id, slot_item_x, slot_item_y , 55, 55, item_bag.count, item_bag.series }
                end
            else
                -- print("====== no : " .. item_type .. " ========")
            end
        end
    end

    -- 获取self.slot_par, 创建不同的srollView(左面板部分)
    scroll = self:create_scroll_area( self.slot_par, 7, 18, _panel_half_w-30, _panel_h-_tab_l_h-45, 1, 4, nil )
    -- print("----------------scroll:", scroll)
    panel:addChild( scroll )
    self.r_up_scroll = scroll
    self.r_up_items_para = self.slot_par               -- 这里要记录所有item的参数。因为scroll，要显示才创建slotitem，create方法中记录的slotitem不全

    -- 添加滚动条上下箭头材
    local scroll_up = CCZXImage:imageWithFile(_panel_half_w-25, _panel_h-_tab_l_h-27, -1, -1, UILH_COMMON.scrollbar_up)
    panel:addChild(scroll_up)
    local scroll_down = CCZXImage:imageWithFile(_panel_half_w-25, 8, -1, -1, UILH_COMMON.scrollbar_down)
    panel:addChild(scroll_down)
end

-- 创建可拖动区域   参数：放入scroll的panel的集合, 坐标， 区域大小，列数， 背景名称
function Synth:create_scroll_area( panel_table_para ,pos_x, pos_y, size_w, size_h, colu_num, sight_num, bg_name)
    local row_num = #panel_table_para / colu_num
    local _scroll_info = { 
        x = pos_x,  
        y = pos_y, 
        width = size_w, 
        height = size_h, 
        maxnum = 1, 
        image = bg_name, 
        stype = TYPE_HORIZONTAL 
    }
    local scroll = CCScroll:scrollWithFile( _scroll_info.x, 
        _scroll_info.y, 
        _scroll_info.width, 
        _scroll_info.height, 
        _scroll_info.maxnum,
        _scroll_info.image, 
        _scroll_info.stype )

    scroll:setScrollLump(UILH_COMMON.up_progress, UILH_COMMON.down_progress, 10, 20, 42)
    scroll:setScrollLumpPos(_scroll_info.width - 3)
    local row_h = 97
    local row_w = 190
    local line_num = 2
    local _in_panel_y = math.ceil(row_num/2)
    local item = CCBasePanel:panelWithFile(0, 0, row_w, _in_panel_y*row_h, "")
    local item_x = nil
    local item_y = nil
    local space_x = 5
    -- compute
    for i = 1, row_num do
        item_y, item_x = math.modf(i/2)
        if item_x == 0 then
            item_x = 2
            item_y = item_y - 1
        else
            item_x = 1
        end
        local bg_vertical = CCBasePanel:panelWithFile( 0+(item_x-1)* row_w + space_x * item_x, 
            _in_panel_y*row_h - (item_y+1)*row_h, row_w, row_h, "", 500, 500)
        local bg = self:create_item_show_panel( panel_table_para[i], 0, 0, row_w, row_h, item_type )
        if bg ~= nil then
            bg_vertical:addChild(bg.show_item_panel_bg)
            item:addChild(bg_vertical)
        end
    end

    local function scrollfun(eventType, args, msg_id)
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
            local temparg = Utils:Split(args,":")
            local x = temparg[1]              -- 行
            local index = x * colu_num 
            local row_h = 94
            local row_w = 226
            local bg_vertical = CCBasePanel:panelWithFile( 0, 6, row_w, row_h, "", 500, 500)
            local colu_with = 190
            local indent_x= 0   --缩进
            local space_x = 0   --列距
            scroll:addItem(item)
            scroll:refresh()

            return false
        end
    end
    scroll:registerScriptHandler(scrollfun)
    scroll:refresh()

    return scroll
end

-- 创建一个道具显示面板(左面板)
local row_index_count = 1         -- 存储入self.row_t 的序号，用来防止多次创建，key重复，造成scroll销毁，通知从self.row_t删除。而新建的也被删了。
function Synth:create_item_show_panel( panel_date, x, y, w, h )
    if panel_date == nil then
        return nil
    end

    local show_item_panel = {}

    -- 有购买按钮的中级强化石
    if panel_date == -1 then
        -- show_item_panel.show_item_panel_bg = self:create_sell_item_panel( 18711, x, y, w, h )
        -- return show_item_panel
        return 
    end
    -- 有购买按钮的中级强化符
    if panel_date == -2 then
        -- show_item_panel.show_item_panel_bg = self:create_sell_item_panel( 18720, x, y, w, h )
        -- return show_item_panel
        return 
    end

    local show_item_panel = {}
    local show_item_panel_bg = CCBasePanel:panelWithFile( x, y , w, h, UILH_COMMON.bg_10, 500, 500 )
    -- local itemBg = CCZXImage:imageWithFile(x+10, y+10, 70, 70, UIResourcePath.FileLocate.forge .. "lq_back_3.png")
    -- show_item_panel:addChild(itemBg)
    show_item_panel.show_item_panel_bg = show_item_panel_bg

    local t = panel_date 
    local slotItem = self:create_item_right( t[1],t[2],t[3],t[4],t[5],t[6],t[7],t[8] )
    slotItem.view:setPosition(10,22)
    local selected_bg = CCBasePanel:panelWithFile(0, 0, w, h, UILH_COMMON.slot_focus, 500, 500)
    show_item_panel_bg:addChild(selected_bg, 100)

    show_item_panel.selected_bg = selected_bg
    selected_bg:setIsVisible(false)

    show_item_panel.set_selected = function( show_flash )
        selected_bg:setIsVisible(show_flash)
    end
    show_item_panel.get_selected = function( ... )
        return show_item_panel.selected_bg:getIsVisible()
    end

    -- self:check_create_slot_if_sele( slotItem )

    if slotItem then
        --设置回调单击函数
        local function f1()
            --设置左侧强化前的item
            self:set_left_item( nil, slotItem.item_id, slotItem.num, slotItem.item_series)
            self:set_r_up_one_slot_disable( slotItem  )
        end
        local function f2( ... )
            local visible = show_item_panel.get_selected()
            if not visible then
                self:unselecte_all_item()
                show_item_panel.set_selected(true)
                f1()
            else
                -- self:set_left_item( nil, nil, 0, nil )                           
                -- show_item_panel.set_selected(false)
            end
        end
        local function f3( eventType )
            if eventType == TOUCH_CLICK then
                f2()
            -- if eventType == TOUCH_DOUBLE_CLICK then
            --     f2()
            end
        end
        slotItem:set_click_event(f2)
        show_item_panel_bg:registerScriptHandler(f3)
        self.r_up_all_item_t[slotItem.item_series] = show_item_panel

        show_item_panel_bg:addChild(slotItem.view)
    end

    return show_item_panel
end

-- 当时强化类型的时候，下面的购买panel
function Synth:create_buy_mate_panel(  )
     local show_item_id_t = {}   --显示的物品购买的id
     show_item_id_t[#show_item_id_t+1] = 18711
    show_item_id_t[ #show_item_id_t + 1 ] = 18720

    local panel = CCBasePanel:panelWithFile(2, 0, 226, 476, "", 500, 500)
    local size_w, size_h = 226, 92
    for i=1,#show_item_id_t do
        local bg = self:create_sell_item_panel( show_item_id_t[i], 0, 376-(i-1)*100, size_w, size_h )
        panel:addChild(bg)
    end

    self.panel_t["right_mate_panel"] = panel
    return panel
end


-- 创建材料-- 强化界面购买材料面板 
function Synth:create_all_mate_slot( panel )
    local show_item_id_t = {}   --显示的物品购买的id
    show_item_id_t[ #show_item_id_t + 1 ] = 18720
    for i, items_para_t in ipairs(self.r_up_items_para) do
        local check_temp = false                                  -- id是否已经在show_item_id_t存在

        -- 不取重复的元素
        for j, item_id_temp in ipairs(show_item_id_t) do
            if item_id_temp == items_para_t[1] then               -- items_para_t 第一个元素是item_id，具体参考创建的地方
                check_temp = true
            end
        end
        -- 如果id不在 ，并且是可以购买的物品 show_item_id_t 中存在，就加入 show_item_id_t
        if (not check_temp) and _can_buy_item_id_t[ items_para_t[1] ] then
            show_item_id_t[ #show_item_id_t + 1 ] = items_para_t[1]
        end
    end
    -- 根据获取到的要显示购买按钮的物品，生成scroll
    -- local row_num = #show_item_id_t / 2 - #show_item_id_t / 2 % 1 + 1
    -- print("-------show_item_id_t:", show_item_id_t, #show_item_id_t)
    local row_num = math.ceil( #show_item_id_t / 2 )
    -- local scroll = CCScroll:scrollWithFile(0, 0, 370, 140, 2, 2, row_num, nil, TYPE_VERTICAL, 500,500)
    -- scroll:setEnableCut(true)
    local _scroll_info = { x = 3, y = 3, width = _panel_half_w-30, height = _panel_res_h-45, maxnum = row_num, image = nil, stype = TYPE_HORIZONTAL }
    local scroll = CCScroll:scrollWithFile( _scroll_info.x, _scroll_info.y, _scroll_info.width, _scroll_info.height, _scroll_info.maxnum, _scroll_info.image, _scroll_info.stype )
    -- scroll:setScrollLump(UIResourcePath.FileLocate.common .. "common_progress.png", UIResourcePath.FileLocate.common .. "input_frame_bg.png", 10, 40, 125 / 2)
    scroll:setScrollLump(UILH_COMMON.up_progress, UILH_COMMON.down_progress, 10, 20, 42)
    -- scroll:setScrollLump( UI_ShopWin_007, UI_ShopWin_006, 4, 40, 125 / 2)
    local had_add_t = {}
    local function scrollfun(eventType, args, msg_id)
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
            local temparg = Utils:Split(args,":")
            local x = temparg[1]              -- 行
            local colu_num = 2
            local index = x * colu_num 
            local size_w = _panel_half_w-30
            local size_h = 75
            local bg_vertical = CCBasePanel:panelWithFile( 0, 0, size_w, size_h, "")
            local colu_with = (_panel_half_w-30)*0.5
            local indent_x= 5   --缩进
            local space_x = 2   --列距
            for i = 1, colu_num do
                local bg = self:create_sell_item_panel( show_item_id_t[index + i], (i - 1) * (colu_with+space_x)+indent_x, 0, colu_with, size_h )
                bg_vertical:addChild(bg)
                -- 分割线 white_line.png
                local line = CCZXImage:imageWithFile( 5, 0, colu_with*2-10, 3, UILH_COMMON.split_line)     
                bg_vertical:addChild(line)
            end


            scroll:addItem(bg_vertical)
            scroll:refresh()
            return false
        end
    end
    scroll:registerScriptHandler(scrollfun)
    scroll:refresh()
    
    self.r_down_scroll = scroll
    panel:addChild( scroll )

        -- 添加滚动条上下箭头
    self.scroll_up = CCZXImage:imageWithFile(_panel_half_w-27, _panel_res_h-50, -1, -1, UILH_COMMON.scrollbar_up)
    panel:addChild(self.scroll_up, 10)
    self.scroll_down = CCZXImage:imageWithFile(_panel_half_w-27, 4, -1, -1, UILH_COMMON.scrollbar_down)
    panel:addChild(self.scroll_down, 10)
end

--创建右侧物品栏的一个item 和 信息。因为和左侧物品处理方式不一样，要分开写一个方法。
--参数：父panel、物品id（当使用默认图标时，使用nil）、坐标、大小、num表示等级或者数量
local row_index_count = 1         -- 存储入self.row_t 的序号，用来防止多次创建，key重复，造成scroll销毁，通知从self.row_t删除。而新建的也被删了。
function Synth:create_item_right( item_id, po_x , po_y, size_w, size_h , num, item_series)
    require "config/ItemConfig"
    --获取item基本信息
    local item = ItemConfig:get_item_by_id( item_id )     

    local slot_w, slot_h = 55, 55
    local slotItem = SlotItem(slot_w, slot_h)             
    slotItem:set_icon_bg_texture( UIPIC_ITEMSLOT, -8, -8, 72, 72 )   -- 背框
    
    if item_id == nil then
        item_id = 0                               --设置一个不存在的值，会获取到默认图标
    end
    slotItem:set_icon( item_id )
    self:set_slot_lock( item_series, slotItem)
    slotItem:set_color_frame( item_id, -2, -2, 59, 59 ) 
    slotItem:setPosition( po_x , po_y )
    slotItem.item_id = item_id
    slotItem.item_series = item_series
    slotItem.num = num
    
    --显示信息:名称和数字
    local dimensions = CCSize(100,15)
    local label_temp = UILabel:create_lable_2(item.name, 62, 35, item_font_size, ALIGN_LEFT)
    slotItem.name_label  = label_temp              --存储起来，使用关键字获取并修改显示内容
    slotItem.view:addChild( label_temp )           --因为lable要随slot共存亡，所以是添加到slot的view中
    require "UI/forge/ForgeCommon"
    ForgeCommon:set_label_color_by_type( item.color, label_temp )

    label_temp = UILabel:create_lable_2(LH_COLOR[1]..Lang.forge.synth[16]..num, 62, 5, item_font_size, ALIGN_LEFT) -- [659]="数量:"
    slotItem.num_label  = label_temp               --存储起来，使用关键字获取并修改显示内容
    slotItem.view:addChild( label_temp )           --因为lable要随slot共存亡，所以是添加到slot的view中

    -- 如果是宝石，要显示宝石的等级
    slotItem:set_gem_level( item_id )                       -- 宝石的等级显示

    -- 当滑动区域，item消失，就会销毁view。  这里在这个事件发生时，把本slotitem从 slot集合中清除
    local function delete_callback()
        self.right_item_t[ slotItem.row_t_index ]   = nil
    end
    slotItem:set_delete_event( delete_callback )

    row_index_count = row_index_count + 1          -- 每创建一个，计数加1
    slotItem.row_t_index = row_index_count         -- 存入表中的key

    self.right_item_t[ slotItem.row_t_index ] = slotItem
    
    return slotItem
end

-- 检查某一个sereies是否和选中的一样，如果一样，在创建之后，就设置为不可按状态
function Synth:check_create_slot_if_sele( slotItem )
    -- 必须先设置其他为有效装备
    local check_exist = false                    -- 是否在选中叠加的series中存在
    for i, v in ipairs(_series_t) do
        if v == slotItem.item_series then
            check_exist = true
        end
    end
    if check_exist then
        self:set_r_up_one_slot_disable( slotItem )
    end
end

-- 根据itemid，判断一个物品是否可以合成, 如果可以合成，返回key
function Synth:check_if_can_synth( item_id )
    require "config/EquipEnhanceConfig"
    local mix_item_t = EquipEnhanceConfig:get_can_mix_item_id()
    if item_id == 11700 then
        return false;
    end
    for key, v in ipairs( mix_item_t ) do
        if v == item_id then
            return true, key
        end
    end
    return false
end

-- 获取合成后的物品
function Synth:get_mix_result_item_id( item_id )
    require "config/EquipEnhanceConfig"
    local mix_result_item_t = EquipEnhanceConfig:get_mix_result_item_id()
    local if_can_synth, key = self:check_if_can_synth( item_id )
    if if_can_synth then
        return mix_result_item_t[ key ]
    end
    return nil
end

-- 创建一个出售道具显示面板 sell panel
function Synth:create_sell_item_panel( item_id, x, y, w, h )
    local bg = CCBasePanel:panelWithFile( x, y , w, h , "", 500, 500 )
    if item_id == nil then
        bg = CCBasePanel:panelWithFile( x, y , w, h , "", 500, 500 )
        return bg
    end

    local slotItem = self:create_one_mate_slot( item_id, 12, 12 )
    bg:addChild(slotItem.view)

    local function f2( ... )
        local a, b, arg = ...
        local position = Utils:Split(arg,":");
            -- 将相对坐标转化成屏幕坐标(即OpenGL坐标 800x480)
        local pos = slotItem.view:getParent():convertToWorldSpace( CCPointMake(position[1],position[2]) );
        ForgeModel:show_item_tips( item_id, pos.x, pos.y )
    end
    slotItem:set_click_event( f2 )

    -- 购买按钮
    local but_1 = CCNGBtnMulTex:buttonWithFile( 100, 12, 60, 30, UILH_COMMON.button4, 500, 500)
    but_1:addTexWithFile(CLICK_STATE_DOWN, UILH_COMMON.button4)
    local function but_1_fun(eventType,x,y)
        if eventType == TOUCH_CLICK then 
            ForgeModel:show_buy_win( item_id )
            return true
        end
        return true
    end
    but_1:registerScriptHandler(but_1_fun)    --注册
    local label_but_1 = UILabel:create_lable_2(LH_COLOR[2] .. Lang.forge.synth[17], 60/2, 10, font_size, ALIGN_CENTER) -- [1016]="购买"
    but_1:addChild( label_but_1 )
    bg:addChild(but_1)

    return bg
end

-- 创建一个材料item_slot（因为不显示数量，显示要求比较简单，就不和前面的公用了，省得加太多判断代码乱）
function Synth:create_one_mate_slot( item_id, po_x , po_y )
    local slot_w, slot_h = 58, 58
    local slotItem = SlotItem(slot_w, slot_h)
    slotItem:set_icon_bg_texture(UIPIC_ITEMSLOT, -4, -4, 60, 60)   -- 背框
    slotItem:set_icon( item_id )
    slotItem:set_color_frame( item_id, -2, -2, 59, 59 ) 
    slotItem:setPosition( po_x , po_y )

    require "config/ItemConfig"
    local item_name = ForgeModel:get_item_name_with_color( item_id )    --获取item名称
    local label_temp = UILabel:create_lable_2( item_name, 80, 40, item_font_size, ALIGN_LEFT )
    slotItem.view:addChild( label_temp )  --因为lable要随slot共存亡，所以是添加到slot的view中
    return slotItem
end

--刷新右侧所有item.  参数：物品的类型（宝石 gem，强化 strengthen，其他 other ）
local btn_offset_x = 20
function Synth:flash_all_item_right( item_type )
    -- print(item_type)
    self:remove_all_item_right(  )

    if item_type == "gem" then
        self:create_bag_slot( self.panel_t["right_panel"] , "gem")
        -- flash_all_item_right
        self.once_synth_btn.view:setIsVisible( true )
        self.synth_btn:setPosition( 30, _synth_btn_y )
        self.batch_synth_btn:setPosition( _panel_half_w-synth_btn_w-30, _synth_btn_y )
        -- self.synth_btn = synth_btn
        -- self.batch_synth_btn = batch_synth_btn
        self.r_down_scroll:setIsVisible(false)
        self.scroll_up:setIsVisible(false)
        self.scroll_down:setIsVisible(false)
    elseif item_type == "strengthen" then 
        self:create_bag_slot( self.panel_t["right_panel"] , "strengthen")
        self.once_synth_btn.view:setIsVisible( false )
        self.synth_btn:setPosition( 30+btn_offset_x, _synth_btn_y )
        self.batch_synth_btn:setPosition( _panel_half_w-synth_btn_w-30-btn_offset_x, _synth_btn_y )
        self.r_down_scroll:setIsVisible(true)
        self.scroll_up:setIsVisible(true)
        self.scroll_down:setIsVisible(true)
    elseif item_type == "other" then 
        self:create_bag_slot( self.panel_t["right_panel"] , "other")
        self.once_synth_btn.view:setIsVisible( false )
        self.synth_btn:setPosition( 30+btn_offset_x, _synth_btn_y )
        self.batch_synth_btn:setPosition( _panel_half_w-synth_btn_w-30-btn_offset_x, _synth_btn_y )
        self.r_down_scroll:setIsVisible(false)
        self.scroll_up:setIsVisible(false)
        self.scroll_down:setIsVisible(false)
    end 
end

--清空右侧面板所有item
function Synth:remove_all_item_right( )
    local panel  = self.panel_t["right_panel"]           --默认上面的装备面板
    local item_table = self.right_item_t                 --上面所有item的table

    for key, slotitem in pairs(item_table) do
        panel:removeChild( slotitem.view, true )
    end
    if self.panel_t["right_mate_panel"] then 
        -- self.panel_t["right_mate_panel"].view:setIsVisible(false)
        panel:removeChild(self.panel_t["right_mate_panel"], true)
        self.panel_t["right_mate_panel"] = nil
    end
    self.right_item_t = {}                       -- 清空以后，表也要清空
    for key, show_item_panel in pairs(self.r_up_all_item_t) do 
        panel:removeChild(show_item_panel.show_item_panel_bg, true)
    end
    self.r_up_all_item_t = {}
    if self.r_up_scroll then
        panel:removeChild( self.r_up_scroll, true)     
        self.r_up_scroll = nil  
    end
end

-- 设置指定slot为无效效状态
function Synth:set_r_up_one_slot_disable( slotItem  )
    -- 必须先设置其他为有效装备
    for i, slot in pairs(self.right_item_t) do 
        local check_exist = false                    -- 是否在选中叠加的series中存在
        for i, v in ipairs(_series_t) do
            if v == slot.item_series then
                check_exist = true
            end
        end
        if not check_exist then                          -- 如果不是选择过的，就设置为可选择状态
            slot:set_slot_enable()
            if self.r_up_all_item_t[slot.item_series] then
                self.r_up_all_item_t[slot.item_series].set_selected(false)
            end
        else
            if self.r_up_all_item_t[slot.item_series] then
                self.r_up_all_item_t[slot.item_series].set_selected(true)
            end
        end
    end
    slotItem:set_slot_disable( )
end

-- 设置材料栏某个item可以点击
function Synth:set_r_up_one_slot_able(  )
    for i, slot in pairs(self.right_item_t) do 
        for i, series in ipairs(_series_t) do
            if series == slot.item_series then
                slot:set_slot_enable()
            end
        end
    end
end

-- 设置锁
function Synth:set_slot_lock( item_series, slotItem )
    if item_series == nil and slotItem then
        slotItem:set_lock(false)
        return
    end
    if _r_up_equi_or_bag == "equipment" then
        local item = UserInfoModel:get_equi_by_id( item_series )
        if item then
            slotItem:set_lock(item.flag == 1)
        end
    else
        local item = ItemModel:get_item_by_series( item_series )
        if item then
            slotItem:set_lock(item.flag == 1)
        end
    end
end

-- 测试tips
function Synth:show_tool_tips_left(  type )
    local extend_date = {}
    if "source" == type then
        ToolTipMgr( "item", _left_slotitem_item_source.item_id, extend_date)
    elseif "result" == type then
        ToolTipMgr( "item", _left_slotitem_item_result.item_id, extend_date)
    end
    
end

function Synth:show_tool_tips_rihgt(  item_id )
    local extend_date = {}
    ToolTipMgr( "item", item_id,extend_date)
end

function Synth:active(show)
    if show then
        self.raido_btn_group:selectItem(cur_selected_btn-1)
    end
end

-- 转至宝石类型
function Synth:change_to_gem()
    _r_up_item_type = "gem"
    -- self:but_select_one( "right_up", 1 )            -- 单选，设置当前按钮为按下状态，其他按钮非按下
    self.raido_btn_group:selectItem(0)
    self:flash_all_item_right( "gem" )
    -- self:change_right_up_panel( "gem" )             -- 重新布局界面
end

-- 转至强化类型
function Synth:change_to_strength()

    _r_up_item_type = "strengthen"
    -- self:but_select_one( "right_up", 2 )             -- 单选，设置当前按钮为按下状态，其他按钮非按下
    self.raido_btn_group:selectItem(1)
    self:flash_all_item_right( "strengthen" )
    -- self:change_right_up_panel( "strengthen" )       -- 重新布局界面 
end

-- 转至其他
function Synth:change_to_other( )
    _r_up_item_type = "other"
    -- self:but_select_one( "right_up", 3 )            -- 单选，设置当前按钮为按下状态，其他按钮非按下
    self.raido_btn_group:selectItem(2)
    self:flash_all_item_right( "other" )
    -- self:change_right_up_panel( "other" )           -- 重新布局界面
end