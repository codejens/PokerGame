-- Upgrade.lua
-- created by lyl on 2012-12-13
-- 炼器--升级面板

super_class.Upgrade(Window)

local _left_slotitem_item_source = nil   --左侧源item，保存起来，动态修改
local _left_slotitem_item_target = nil   --左侧目标item，保存起来，动态修改
local _left_slotitem_item_need = nil     --左侧需要升级道具item，保存起来，动态修改
local _left_slotitem_item_need2 = nil    --左侧需要升级道具item，保存起来，动态修改(神佑符)
local _left_is_use_bhf_view = nil        --是否使用神佑符控件
local _left_is_use_bhf          = false    --是否使用神佑符

local font_size = 16
local color_yellow = "#cffff00"

-- 材料序列号的集合。
local _mate_series_t = {}

--记录右侧装备区，是背包还是人物状态.默认是人物
local _r_up_equi_or_bag = "equipment"

local _item_num_need    = 0                 --需要物品的数量.  记录合成物品下面的数量显示
local _item_num_have    = 0                 --选中物品的数量
local _pay_for_synth    = 0                 --手续费

function Upgrade:__init(  )
    self.panel_t = {}                  --存储panel的表。用于改变panel内容
    self.label_t = {}                  --存储label的表。用于改变label显示的内容
    self.right_item_t = {}             --存储右侧上部分的所有item。用于清空处理
    self.r_up_scroll = nil
    self.r_down_scroll = nil

    -- 创建一个大底板
    -- local bg_panel = CCBasePanel:panelWithFile( 0, 0, 880, 490, UILH_COMMON.bg_03, 500, 500 )        
    -- self.view:addChild(bg_panel)

	-- 创建个区域的面板
    self.view:addChild( self:create_right_panel( 428, 10, 430, 488, UILH_COMMON.bottom_bg) )             --左侧
    self.view:addChild( self:create_left_panel( 10, 10, 420, 488, UILH_COMMON.bottom_bg) )       --右侧
end

--刷新所有panel，当强化结束，服务器通知物品发生改变，就被调用刷新
function Upgrade:flash_all_item( )
    self:syn_sele_item()
    self:flash_all_item_right()
end

-- 刷新人物装备。获取最新人物身上物品后会被调用
function Upgrade:flash_all_item_char(  )
    self:syn_sele_item()
    self:flash_all_item_right()
end

function Upgrade:syn_date(  )
    self:syn_sele_item()
    self:flash_all_item_right()
end
function Upgrade:update_select_equip_list(  )
    local select_equip_series = UserInfoModel:get_select_equip(  )
    ZXLog("----------------------select_equip_series:",select_equip_series)
    local slotitem = nil 
    for i,solt in ipairs(self.right_item_t) do
        ZXLog("----------------solt.item_series:",solt.item_series)
        if solt.item_series == select_equip_series then 
            slotitem = solt
            ZXLog("第几个道具----------------------i:",i)
            break
        end 
    end
    local user_item = UserInfoModel:get_equi_by_id( select_equip_series );
    self:set_left_item( "", user_item.item_id, 0, user_item.series)
    self:set_r_up_one_slot_disable( slotitem  )
    
end
function Upgrade:update( update_type )
    if update_type == "bag" or update_type == "bag_change" or update_type == "bag_add" or update_type == "bag_remove" then
        self:syn_sele_item()
        self:flash_all_item_right()
    elseif update_type == "equipment" then
        self:syn_sele_item()
        self:flash_all_item_right()
    elseif update_type == "all" then
        -- LuaEffectManager:stop_view_effect( 11008,self.view)
        -- LuaEffectManager:play_view_effect( 11008,165,280,self.view,true,10  );
        self:set_left_item( "", 0, nil, nil)    -- 每次打开都清空选中数据
        self:syn_date(  )
        self:set_default_item()
    elseif update_type == "select_a_equip" then 
        --更新左侧道具选择列表
        self:update_select_equip_list( )
    end 
end

-- 同步选中装备的最新属性(重新从人物或者背包model获取数据)
function Upgrade:syn_sele_item(  )
    -- local item_series = _left_slotitem_item_source.item_series
    -- require "model/ItemModel"
    -- local item = ItemModel:get_item_by_series( item_series )
    -- if item ~= nil then
    --     self:set_left_item( "", 999999999, nil, nil)
    -- end
    self:set_left_item( "", 0, nil, nil)
end

-- 显示操作结果的提示
function Upgrade:show_handle_result( result, result_msg )
    -- 值改变数量，服务器就不会发送（8,9）（物品发生改变）消息，就不会走上面flash_all_item流程。所以这里要刷新
    -- self:flash_all_item()
    -- self:request_bag_items_check()
    -- 请求更新装备的数据
    --获取装备列表
    ForgeWin:set_if_waiting_result( true )
    ForgeWin:set_if_waiting_reflash( true )
    UserEquipCC:request_get_equi()

    -- 测试用
    -- local show_cont = ""
    -- if result == 1 then
    --     show_cont = "成功!"
    -- else
    --     show_cont = result_msg or ""
    -- end
    -- local label_temp = UILabel:create_label_1(show_cont, CCSize(300,100), 150, 250, 20, CCTextAlignmentCenter, 255, 0, 0)
    -- self.label_t[ "result_label" ] = label_temp
    -- self.panel_t["left_panel"]:addChild( label_temp )
end

-- 返回每个panel，用于炼器主截面清除所有内容。切换界面的时候用
function  Upgrade:get_all_panel()
    return { self.panel_t["left_panel"], self.panel_t["right_panel"] }
end


--================================================================================================================================
--================================================================================================================================
--
--右侧
--
--================================================================================================================================
--================================================================================================================================
--创建右侧panel
function Upgrade:create_right_panel( pos_x, pos_y, width, height, texture_name )
    local panel = CCBasePanel:panelWithFile( pos_x, pos_y, width, height, texture_name, 500, 500 )    

    -- 升级区域的背景图
    -- self.bg_ima_01 = CCZXImage:imageWithFile( 2, 2, 314, 349, "鼎的图片路径，待添加" );                      -- 背景图片，鼎
    -- panel:addChild( self.bg_ima_01 )

    -- 两张slotitem的背景框图，斩仙是有的，暂不清楚天降雄师要不要，代码先不删除，注释掉
    -- self.bg_ima_02 = CCZXImage:imageWithFile( 30 - 17, 20, -1, -1, UIPIC_FORGE_ITEM_BG );       -- 框框，下同
    -- panel:addChild( self.bg_ima_02, 10 )
    -- self.bg_ima_03 = CCZXImage:imageWithFile( 230 - 7, 20, -1, -1, UIPIC_FORGE_ITEM_BG );  
    -- panel:addChild( self.bg_ima_03, 10 )

    -- local t_bg_l = ZImage:create( panel, UILH_FORGE.bg, 8, 0, -1, -1 )
    -- local t_bg_r = ZImage:create( panel, UILH_FORGE.bg, 8+213, 0, -1, -1 )
    -- t_bg_r.view:setFlipX(true)

    --左侧item。  初始化的时候，图标都是使用默认图标。传入nil
    _left_slotitem_item_source = self:create_item( panel, nil, 60, 340, 55, 55, "source" )          --原始item
    ZImage:create(_left_slotitem_item_source.icon_bg, UILH_FORGE.zb_img, 25, 34, -1, -1)

    _left_slotitem_item_target = self:create_item( panel, nil, 300, 340, 55, 55, "target" )         --结果item
    ZImage:create(_left_slotitem_item_target.icon_bg, UILH_FORGE.zb_img, 25, 34, -1, -1)

    _left_slotitem_item_need   = self:create_item( panel, nil, 120, 165, 55, 55, "item_need" )          --需要道具items
    ZImage:create(_left_slotitem_item_need.icon_bg, UILH_FORGE.cl_img, 25, 34, -1, -1)

    _left_slotitem_item_need2   = self:create_item( panel, nil, 250, 165, 55, 55, "item_need2" )          --需要道具items 
    ZImage:create(_left_slotitem_item_need2.icon_bg, UILH_FORGE.cl_img, 25, 34, -1, -1) 

    _left_slotitem_item_target_focus = ZImage:create( _left_slotitem_item_target, UILH_NORMAL.light_grid, -18, -18, 100, 100 )
    _left_slotitem_item_target_focus.view:setIsVisible(true)

    -- 神佑符id，写死
    _left_slotitem_item_need2:set_icon( 18760 );
    _left_slotitem_item_need2:set_color_frame(18760, -2, -2, 68, 68)
    local bg_ima_05 = CCZXImage:imageWithFile( -7, -7, 70, 70, UILH_COMMON.slot_bg );  
    _left_slotitem_item_need2.view:addChild( bg_ima_05, -1 )

    -- 两个框框中间那个向右的箭头
    local to_right_img = CCZXImage:imageWithFile(185, 350, -1, -1, UILH_COMMON.right_arrows)
    panel:addChild(to_right_img)

    --显示的一些文字
    -- 升级前装备名字
    local label_temp = UILabel:create_label_1("", CCSize(150,40), 95, 310, 16, CCTextAlignmentCenter, 255, 255, 0)
    self.label_t[ "atta_value_left" ]  = label_temp            --存储起来，使用关键字获取并修改显示内容
    panel:addChild( label_temp )

    -- 升级后装备名字
    local label_temp = UILabel:create_label_1("", CCSize(150,40), 335, 310, 16, CCTextAlignmentCenter, 255, 255, 0)
    self.label_t[ "atta_value_right" ]  = label_temp            --存储起来，使用关键字获取并修改显示内容
    panel:addChild( label_temp )

    -- 材料数量
    local label_temp = UILabel:create_label_1("", CCSize(150,40), 150, 145, 16, CCTextAlignmentCenter, 255, 255, 0)
    self.label_t[ "need_num" ]  = label_temp            --存储起来，使用关键字获取并修改显示内容
    panel:addChild( label_temp )
    _item_num_need = nil

    -- 神佑符数量
    local label_temp = UILabel:create_label_1("", CCSize(150,40), 280, 145, 16, CCTextAlignmentCenter, 255, 255, 0)
    self.label_t[ "sy_num" ]  = label_temp            --存储起来，使用关键字获取并修改显示内容
    panel:addChild( label_temp )   

    -- 升级费用
    local label_temp = UILabel:create_label_1("", CCSize(150,40), 215, 80, 16, CCTextAlignmentCenter, 255, 255, 0)
    self.label_t[ "need_money" ]  = label_temp            --存储起来，使用关键字获取并修改显示内容
    panel:addChild( label_temp )
    _pay_for_synth = 0

    self:flash_all_label( )

    -- 是否使用保护符
    local function use_shield_fun()
        _left_is_use_bhf = not _left_is_use_bhf;
    end
    _left_is_use_bhf_view = UIButton:create_switch_button2(141,93, 100, 25, UILH_COMMON.dg_sel_1,UILH_COMMON.dg_sel_2, Lang.forge.common[1], 50, 13, 16, nil, nil, nil, nil, use_shield_fun ) -- [1]="使用"
    panel:addChild(_left_is_use_bhf_view.view,2);    

    -- 升级按钮  :对于不用在其他代码位置获取的按钮，直接使用数字命名，方便复制到其他位置使用
    local but_1 = CCNGBtnMulTex:buttonWithFile( 170, 10, 99, 53, UILH_COMMON.lh_button2, 500, 500)
    but_1:addTexWithFile(CLICK_STATE_DOWN, UILH_COMMON.button2_sel)
    but_1:addTexWithFile(CLICK_STATE_DISABLE, UILH_COMMON.lh_button2_disable)
    local function but_1_fun(eventType,x,y)
        if eventType == TOUCH_CLICK then
           -- hcl on 2013/7/18
            -- 如果玩家当前需要使用神佑符
            if ( _left_slotitem_item_need2.view:getIsVisible() ) then
                if ( _left_is_use_bhf == false ) then
                    ConfirmWin2:show( 4, nil, LangGameString[1032],  Upgrade.send_request_upgrade ) -- [1032]="本次升级未使用神佑符，#c66ff66若升级，有可能会降低装备品质。#r#r#r#r#cffffff注:#c66ff66探寻梦境#cffffff可获得神佑符。"
                else
                    self:send_request_upgrade()
                end
            else
                self:send_request_upgrade()
            end 
            return true
        end
        return true
    end
    but_1:registerScriptHandler(but_1_fun)    --注册
    panel:addChild(but_1)
    --按钮显示的名称:升级
    MUtils:create_zxfont(but_1,Lang.forge.tab_five[1],30,19,CCTextAlignmentCenter,16);
    -- local name_image = CCZXImage:imageWithFile( 31, 16, 47, 23, UIPIC_FORGE_014 ); 
    -- but_1:addChild( name_image )
    -- but_1:setCurState( CLICK_STATE_DISABLE ) 
    self.upgrade_but = but_1

    -- 说明按钮
    local function help_btn_callback(eventType,x,y)
        --if eventType == TOUCH_CLICK then 
            ForgeModel:show_help_panel( UILH_FORGE.sj_notic, Lang.forge.upgrade_info )
            --return true
        --end
       -- return true
    end
    local help_panel = ZBasePanel:create( panel, "", 280 + 8, 245 + 189, 115, 40 )
    help_panel:setTouchClickFun(help_btn_callback)

    local help_btn = ZButton:create(help_panel, UILH_NORMAL.wenhao, help_btn_callback, 0, 0, -1, -1)
    local help_btn_size = help_btn:getSize()
    local help_img = ZImage:create(help_panel, UILH_FORGE.sj_img, 0, 0, -1, -1)  
    local help_img_size = help_img:getSize()
    help_img:setPosition( help_btn_size.width, ( help_btn_size.height - help_img_size.height ) / 2 )      
    -- local help_btn = MUtils:creat_mutable_btn( 305, 430, {x=0, y=0, w=38, h=38}, UILH_NORMAL.wenhao,{x=38, y=10, w=75, h=19},
    --  UILH_FORGE.sj_img, help_btn_callback )
    -- panel:addChild(help_btn)

    self:draw_mid_equip_attr(panel)

    self.panel_t["left_panel"] = panel        --存入table，用于动态修改
    return panel
end

function Upgrade:draw_mid_equip_attr( panel )
    local width = panel:getSize().width;
    _equip_attr_container_1 = CCBasePanel:panelWithFile(0, 20, width, 285, "")
    _equip_attr_container_2 = CCBasePanel:panelWithFile(0, 20, width, 285, "")
    panel:addChild(_equip_attr_container_1)
    panel:addChild(_equip_attr_container_2)

    -- 左右两边的物防、法防label
    local phy_def_label_l = UILabel:create_lable_2("", 85, 255, font_size, ALIGN_RIGHT)
    local phy_def_label_r = UILabel:create_lable_2("", 324, 255, font_size, ALIGN_RIGHT)
    local mag_def_label_l = UILabel:create_lable_2("", 85, 230, font_size, ALIGN_RIGHT)
    local mag_def_label_r = UILabel:create_lable_2("", 324, 230, font_size, ALIGN_RIGHT)
    _equip_attr_container_1:addChild(phy_def_label_l)
    _equip_attr_container_1:addChild(phy_def_label_r)
    _equip_attr_container_2:addChild(mag_def_label_l)
    _equip_attr_container_2:addChild(mag_def_label_r)
    self.label_t["equip_attr_name_1l"] = phy_def_label_l
    self.label_t["equip_attr_name_1r"] = phy_def_label_r
    self.label_t["equip_attr_name_2l"] = mag_def_label_l
    self.label_t["equip_attr_name_2r"] = mag_def_label_r

    -- 左右两边物防、法防数值底框
    local phy_def_bg_l = CCBasePanel:panelWithFile(98, 250, 80, 30, nil, 500, 500)
    local phy_def_bg_r = CCBasePanel:panelWithFile(332, 250, 80, 30, nil, 500, 500)
    local mag_def_bg_l = CCBasePanel:panelWithFile(98, 223, 80, 30, nil, 500, 500)
    local mag_def_bg_r = CCBasePanel:panelWithFile(332, 223, 80, 30, nil, 500, 500)
    _equip_attr_container_1:addChild(phy_def_bg_l)
    _equip_attr_container_1:addChild(phy_def_bg_r)
    _equip_attr_container_2:addChild(mag_def_bg_l)
    _equip_attr_container_2:addChild(mag_def_bg_r)
    _equip_attr_container_1:setIsVisible(false)
    _equip_attr_container_2:setIsVisible(false)

    -- 左右两边物防、法防数值
    local phy_def_val_l = UILabel:create_lable_2("", 5, 5, font_size)
    local phy_def_val_r = UILabel:create_lable_2("", 5, 5, font_size)
    local mag_def_val_l = UILabel:create_lable_2("", 5, 5, font_size)
    local mag_def_val_r = UILabel:create_lable_2("", 5, 5, font_size)
    phy_def_bg_l:addChild(phy_def_val_l)
    phy_def_bg_r:addChild(phy_def_val_r)
    mag_def_bg_l:addChild(mag_def_val_l)
    mag_def_bg_r:addChild(mag_def_val_r)
    self.label_t["equip_attr_val_1l"] = phy_def_val_l
    self.label_t["equip_attr_val_1r"] = phy_def_val_r
    self.label_t["equip_attr_val_2l"] = mag_def_val_l
    self.label_t["equip_attr_val_2r"] = mag_def_val_r

end

-- 显示选中的装备的属性
function Upgrade:show_equi_attr( item_date )
    if item_date == nil then
        _equip_attr_container_1:setIsVisible(false)
        _equip_attr_container_2:setIsVisible(false)
        return 
    end

    _equip_attr_container_1:setIsVisible(true)
    _equip_attr_container_2:setIsVisible(true)

    --基础属性
    require "config/ItemConfig"
    local attr_t = ItemConfig:get_staitc_attrs_by_id( item_date.item_id )  -- 装备的基础属性值 表
    -- 获取当前当即加强的属性
    -- local strong_curr_attr = ItemConfig:get_strong_attr_by_level( item_date.item_id, item_date.strong )
    -- 获取下一个强化等级加强的属性
    -- local strong_next_attr = 0
    -- if item_date.strong ~= nil then
    --     strong_next_attr = ItemConfig:get_strong_attr_by_level( item_date.item_id, item_date.strong )
    -- end

    local cur_user_item = UserInfoModel:get_equi_by_id( _left_slotitem_item_source.item_series )

    local user_item = UserInfoModel:get_equi_by_id( _left_slotitem_item_target.item_series )
            local _user_item = {};
            _user_item.series = "series";
            _user_item.item_id = _left_slotitem_item_target.item_id;
            _user_item.strong = user_item.strong;
            _user_item.flag = user_item.flag;
            _user_item.holes = { user_item.holes[1],user_item.holes[2],user_item.holes[3]}
            _user_item.void_bytes_tab = {user_item.void_bytes_tab[1]};
            _user_item.smith_num = user_item.smith_num;
            _user_item.smiths = { user_item.smiths[1],user_item.smiths[2],user_item.smiths[3] }
            user_item = nil;
            user_item = _user_item;
    
    -- 第一属性
    if attr_t[1] ~= nil then
        local str_temp = ""
        local attr_name = ForgeCommon:get_attr_name_by_type( attr_t[1]["type"] )                -- 属性名称
        -- local value = ItemModel:get_equip_base_single_attr_atta( item_date.item_id, item_date.void_bytes_tab[1], 1 )
        local curr_attr_value = ForgeModel:get_equipment_base_attri_text( cur_user_item, 1 )
        local next_attr_value = ForgeModel:get_equipment_base_attri_text( user_item, 1 )

        self.label_t["equip_attr_name_1l"]:setString("#cffffff" .. attr_name)
        self.label_t["equip_attr_val_1l"]:setString("#c00ff00+" .. curr_attr_value)

        -- if strong_next_attr ~= nil then
            self.label_t["equip_attr_name_1r"]:setString("#cffffff" .. attr_name)
            self.label_t["equip_attr_val_1r"]:setString("#c00ff00+" .. next_attr_value)
        -- end
    else 
        _equip_attr_container_1:setIsVisible(false)
    end

    if attr_t[2] ~= nil then
        local str_temp = ""
        local attr_name = ForgeCommon:get_attr_name_by_type( attr_t[2]["type"] )                -- 属性名称
        -- local value = ItemModel:get_equip_base_single_attr_atta( item_date.item_id, item_date.void_bytes_tab[1], 2 )
        local curr_attr2_value = ForgeModel:get_equipment_base_attri_text( cur_user_item, 2 )
        local next_attr2_value = ForgeModel:get_equipment_base_attri_text( user_item, 2 )

        self.label_t["equip_attr_name_2l"]:setString("#cffffff" .. attr_name)
        self.label_t["equip_attr_val_2l"]:setString("#c00ff00+" .. curr_attr2_value)

        -- if strong_next_attr ~= nil then
            self.label_t["equip_attr_name_2r"]:setString("#cffffff" .. attr_name)
            self.label_t["equip_attr_val_2r"]:setString("#c00ff00+" .. next_attr2_value)
        -- end
    else 
        _equip_attr_container_2:setIsVisible(false)
    end

    -- 成功率和消耗
    -- require "config/EquipEnhanceConfig"
    -- local succ_per = ForgeModel:get_strengthen_success_percent(  )
    -- self:update_zhan_bu_buff_info( succ_per )
end

-- 给一个显示面板加购买按钮 (在显示材料的面板上增加“获得”按钮，点击后提示用户获得材料途径，目前应该是不需要了，note by guozhinan)
-- function Upgrade:add_buy_but_to_show_panel( slotitem_need)
--       --xiehande 通用按钮修改  UIPIC_FORGE_061 ->UIPIC_COMMOM_001
--     local but_1 = CCNGBtnMulTex:buttonWithFile( 260, 10, -1, -1, UIPIC_COMMOM_001, 500, 500)

--     local function but_1_fun(eventType,x,y)
--         if eventType == TOUCH_CLICK then 
--             Instruction:handleUIComponentClick(instruct_comps.ANY_BTN)
--             local win_type = 2
--             -- local equip_type = ForgeModel:get_equipment_type(_left_slotitem_item_need.item_id) -- 攻击或防御
--             -- local equip_levle = ForgeModel:get_equipment_level(_left_slotitem_item_need.item_id)
--             -- ForgeDialog:show(win_type, equip_type, equip_levle)
--             ForgeDialog:show(win_type, _left_slotitem_item_need.item_id)
--             return true
--         end
--         return true
--     end

--     local but_name  = "获得"
--     but_1:registerScriptHandler(but_1_fun)    --注册
    
--     --按钮显示的名称
--     local label_but_1 = UILabel:create_lable_2(but_name, 96/2, 22, font_size, ALIGN_CENTER)
--     but_1:addChild( label_but_1 ) 
--     return but_1
-- end

-- 创建一个item 包括slotitem和信息 
function Upgrade:create_item( panel, item_series, po_x , po_y, size_w, size_h , item_type)
    local slot_w, slot_h = 64, 64
    local slotItem = SlotItem(slot_w, slot_h)
    slotItem:set_icon_bg_texture( UILH_COMMON.slot_bg, -10, -10, 84, 84 )   -- 背框

    --获取item_id 。默认用一个不存在的id  0，可以去到默认图标
    local item_id = 0

    slotItem:setPosition( po_x , po_y )
    --设置回调单击函数
    local function f1()
        if "source" == item_type then
            self:set_r_up_one_slot_able( slotItem.item_series )
            self:set_left_item( "", 0, nil, nil)
            _item_num_need = nil
            _item_num_have = nil
            self:flash_all_label()
        elseif "target" == item_type then

        -- elseif "item_need" == item_type then
        --     ForgeModel:show_item_tips( slotItem.item_id )
        end
    end
    -- slotItem:set_double_click_event( f1 )

    local function f2( ... )
        local a, b, arg = ...
        local position = Utils:Split(arg,":");
        -- 将相对坐标转化成屏幕坐标(即OpenGL坐标 800x480)
        local pos = slotItem.view:getParent():convertToWorldSpace( CCPointMake(position[1],position[2]) );
        if ( item_type == "source" ) then
            local user_item = UserInfoModel:get_equi_by_id( slotItem.item_series )
            TipsModel:show_tip( pos.x, pos.y,user_item )
        elseif ( item_type == "target" ) then
            local user_item = UserInfoModel:get_equi_by_id( slotItem.item_series )
            if user_item then
                local _user_item = {};
                _user_item.series = "series";
                _user_item.item_id = slotItem.item_id;
                _user_item.strong = user_item.strong;
                _user_item.flag = user_item.flag;
                _user_item.holes = { user_item.holes[1],user_item.holes[2],user_item.holes[3]}
                _user_item.void_bytes_tab = {user_item.void_bytes_tab[1]};
                _user_item.smith_num = user_item.smith_num;
                _user_item.smiths = { user_item.smiths[1],user_item.smiths[2],user_item.smiths[3] }
                user_item = nil;
                user_item = _user_item;
                TipsModel:show_tip( pos.x, pos.y,_user_item )
            end
        else
            ForgeModel:show_item_tips( slotItem.item_id, pos.x, pos.y )
        end
        --ForgeModel:show_item_tips( slotItem.item_id, pos.x, pos.y )
    end
    slotItem:set_click_event( f2 )

    panel:addChild( slotItem.view )

    -- -- 加默认提示字
    -- local show_notice_word = ""
    -- if "source" == item_type then
    --     show_notice_word = UIResourcePath.FileLocate.role .. "text_zhuangbei.png"
    -- elseif "target" == item_type then
    --     show_notice_word = UIResourcePath.FileLocate.role .. "text_zhuangbei.png"
    -- else 
    --     show_notice_word = UIResourcePath.FileLocate.role .. "text_cailiao.png"
    -- end 
    -- -- slotItem.default_word = UILabel:create_label_1(show_notice_word, CCSize(100,15), 30, 30, 12, CCTextAlignmentCenter, 255, 255, 0)    
    -- slotItem.default_word = CCZXImage:imageWithFile( 0, 0, 55, 55, show_notice_word )
    -- slotItem.view:addChild( slotItem.default_word )           --因为lable要随slot共存亡，所以是添加到slot的view中

    --需要item存储一下选中的slot的数据。初始化设置为nil(起始可以不写，这里是为了有一种"定义了的"印象)
    slotItem.level       = nil
    slotItem.item_series = nil
    slotItem.item_id     = nil

    return slotItem
end

-- 设置左侧，item的属性:类型 字符串（ 无用 ）,物品id(是基本属性，不是序列号，注意了)
function Upgrade:set_left_item( type, item_id, strong_level, item_series)

    -- target_item_id ：该id升级后的物品id； meta_item_id ：需要的材料id， mete_need_num ：需要的数量
    local target_item_id, meta_item_id, mete_need_num , need_money = self:get_up_info_by_id( item_id )
    -- local item = _left_slotitem_item_source                                   --左侧的源item
    _left_slotitem_item_source.item_series  = item_series                                           --记录序列号，发送请求的时候需要
    _left_slotitem_item_source.item_id = item_id                                                    --记录物品id，发送请求的时候需要
    _left_slotitem_item_source.strong_level = strong_level                                          -- 强化等级
    -- _left_slotitem_item_source:set_icon( item_id )                                                  --设置图标
    _left_slotitem_item_source:set_color_frame( item_id, -2, -2, 68, 68 )                                           -- 左装备颜色框
    _left_slotitem_item_target:set_color_frame( target_item_id, -2, -2, 68, 68 )             -- 右装备颜色框

    -- 设置升级后的物品。注意，可以升级的物品，id号为十位加1.例如：碧晶枪（1111） 升为20级套装，就为 1121
    -- local target_item_id = tonumber(item_id) + 10                             -- 最顶级的已经不能显示，所以放心地加10吧！
    -- 先判断 用该item_id是否能找到静态数据
    require "config/ItemConfig"
    local item_base = ItemConfig:get_item_by_id( item_id )
    -- 设置装备品质
    if ( item_id == 0) then
        _left_slotitem_item_target:set_item_quality(nil);
        _left_slotitem_item_source:set_item_quality(nil);
    else
        local user_item = UserInfoModel:get_equi_by_id( item_series );
        local pj = ItemModel:get_item_pj( item_base )
        _left_slotitem_item_target:set_item_quality(user_item.void_bytes_tab[1],pj);
        _left_slotitem_item_source:set_item_quality(user_item.void_bytes_tab[1],pj);
    end
    
    _left_slotitem_item_target:set_icon( target_item_id )
    _left_slotitem_item_target.item_id = target_item_id 
    _left_slotitem_item_target.item_series = item_series;

    -- 设置需要的材料
    require "config/ItemConfig"
    if item_series == nil then
        _left_slotitem_item_need:set_icon( 0 )
    else
        _left_slotitem_item_need:set_icon( meta_item_id )
    end
    _left_slotitem_item_need.item_id = meta_item_id


    if item_base then 
        _left_slotitem_item_source:set_icon( item_id )                                              --设置图标
        _left_slotitem_item_need:set_color_frame(item_id, -2, -2, 68, 68)
    else
        _left_slotitem_item_source:set_icon_texture( "" )                                           -- 如果找不到，就去掉背景图
        _left_slotitem_item_target:set_icon_texture( "" )  
        _left_slotitem_item_need:set_icon_texture( "" )  
        _left_slotitem_item_need:set_color_frame(nil);
    end

    -- 数量
    _item_num_need = mete_need_num      -- 需要的数量，已经配置好
    _item_num_have = self:get_mate_num( meta_item_id )                  -- 背包中拥有的辅助材料的数量
    _pay_for_synth = need_money;      -- 升级需要的钱
    self:flash_all_label()
    
    local item_base2 = ItemConfig:get_item_by_id( target_item_id )
    -- -- 战斗力label
    local atta_value_left = nil
    local atta_value_right = nil
    if item_series ~= nil then
        -- atta_value_left = _static_quantity_color[item_base.color].."[".._static_quantity_str[ user_item.quality ].."]";
        -- atta_value_right = _static_quantity_color[item_base.color].."[".._static_quantity_str[ user_item.quality+1 ].."]";
        atta_value_left = _static_quantity_color[item_base.color + 1];
        atta_value_right = _static_quantity_color[item_base2.color + 1];
    end
    if atta_value_left then
    --     print("====== atta_value_left, item_base.name: ", atta_value_left, item_base.name)
        self.label_t[ "atta_value_left" ]:setString( atta_value_left..item_base.name )
        self.label_t[ "atta_value_right" ]:setString( atta_value_right..item_base2.name )
    --     -- 是否显示第二个材料神佑符
    -- if item_series then
        local user_item = UserInfoModel:get_equi_by_id( item_series )
        if ( user_item.void_bytes_tab[1] > 1 ) then
            _left_slotitem_item_need2.view:setIsVisible(true);
            local syf_count = ItemModel:get_item_count_by_id( 18760 )
            if ( syf_count > 0 ) then
                _left_slotitem_item_need2:set_icon_light_color();
                _left_is_use_bhf_view.view:setIsVisible(true);
            else
                _left_slotitem_item_need2:set_icon_dead_color();
                _left_is_use_bhf_view.view:setIsVisible(false);
            end
            self.label_t[ "sy_num" ]:setString(syf_count.."/1");
        else
            _left_is_use_bhf_view.view:setIsVisible(false);
            _left_slotitem_item_need2.view:setIsVisible(false);
            self.label_t[ "sy_num" ]:setString("");
        end
    -- end
    else
        self.label_t[ "atta_value_left" ]:setString( "" )
        self.label_t[ "atta_value_right" ]:setString( "" )
        self.label_t[ "sy_num" ]:setString("");
        -- 隐藏第二个材料
        _left_is_use_bhf_view.view:setIsVisible(false);
        _left_slotitem_item_need2.view:setIsVisible(false);
    end

    -- 设置图标的强化等级
    if strong_level then
        _left_slotitem_item_source:set_strong_level( strong_level )
        _left_slotitem_item_target:set_strong_level( strong_level )
    else
        _left_slotitem_item_source:set_strong_level( 0 )
        _left_slotitem_item_target:set_strong_level( 0 )
    end
    self:set_slot_lock( item_series, _left_slotitem_item_source)
    self:set_slot_lock( item_series, _left_slotitem_item_target)
    -- 是否显示提示字
    if item_series then
    --     _left_slotitem_item_source.default_word:setIsVisible(false)
    -- else
    --     _left_slotitem_item_source.default_word:setIsVisible(true)
    end

    local item_date = ForgeModel:get_item_in_bag_or_body( item_series )
    self:show_equi_attr(item_date)

    self:check_action_but_able()

end

-- 根据一个序列号获取一个item的战力,参数：第一个是序列号，用于获取动态数据。
-- 注意，第二个参数看上去多余，实际上因为要计算下一级的战斗力，并且动态数据（例如宝石）是一样的，只是item_id不同。所以特别要传一个item_id
function Upgrade:get_atta_value_by_series( item_series , item_id)
    return UserInfoModel:calculate_equip_attack_by_item_id( item_series, item_id )
end

-- 根据道具id，获取升级信息。 返回三个值：该id升级后的物品id， 需要的材料id， 需要的数量
function Upgrade:get_up_info_by_id( item_id )
    local ret_new_id = 0                               -- 生成后的物品id
    local ret_user_id = 0                              -- 使用材料的id
    local ret_use_count = 0                            -- 使用的数量
    local ret_use_money = 0;
     -- 获取人物信息(等级)
    local player = EntityManager:get_player_avatar()

    require "config/EquipEnhanceConfig"
    local upgrade_t = EquipEnhanceConfig:get_upgrade_table( )
    
    for i, v in ipairs(upgrade_t) do                    -- 遍历升级信息表，查询每个等级的itemid集合
        if player.level >= v.checkLevel then                       -- 套装对人物有级数要求
            for j,k in ipairs(v.items) do               -- 查询item_id集合，判断传入的id是否可以升级
                if k == item_id then                    -- 
                    ret_new_id = v.newItems[j]
                    ret_user_id = v.useItems[j]
                    ret_use_count = v.useCount[j]
                    ret_use_money = v.money;
                    break;
                end
            end
        end
    end
    return ret_new_id, ret_user_id, ret_use_count ,ret_use_money       
end

-- 获取需要的升级辅助材料的数量
function Upgrade:get_mate_num( item_id )
    local count_ret = 0
    _mate_series_t = {}
    local bag_items, bag_item_count = ItemModel:get_bag_data() --背包中物品的集合和数量
    local item_bag = nil                                       --背包中存储的item数据，注意和基本item数据区分

    --遍历背包中的所有装备，创建出item显示出来
    for i = 1, bag_item_count do
        item_bag = bag_items[i]
        -- 判断是否是要计数的 item_id
        if item_bag and item_bag.item_id == item_id then
            _mate_series_t[ #_mate_series_t + 1] = item_bag.series
            count_ret = count_ret + item_bag.count
        end
    end
    return count_ret
end

-- 刷新所有label，根据新值，从新设置label的内容
function Upgrade:flash_all_label( )
    if _item_num_need ~= nil and _item_num_need ~= 0 then               --如果需要的数字为空或者0，则不显示
        local color_hex = nil
        -- 如果材料不够，则显示红色
        if _item_num_have < _item_num_need then
            -- UILabel:setAttrColor(self.label_t[ "need_num" ], 255, 0, 0)
            color_hex = LH_COLOR[7]
        else
            -- UILabel:setAttrColor(self.label_t[ "need_num" ], 255, 255, 0)
            color_hex = LH_COLOR[2]
        end   
        self.label_t[ "need_num" ]:setString( color_hex.._item_num_have .. "/" .. _item_num_need ) 
        self.label_t[ "need_money" ]:setString(Lang.forge.common[2]..color_yellow.._pay_for_synth.."#cffffff"..Lang.normal[1]);
    else
        self.label_t[ "need_num" ]:setString( "" );
        self.label_t[ "need_money" ]:setString(Lang.forge.common[2]..color_yellow .. "0#cffffff"..Lang.normal[1]);     
    end    
end

-- 设置转移按钮是否可以有效
function Upgrade:check_action_but_able(  )
    -- print("======= _item_num_need, _item_num_have: ", _item_num_need, _item_num_have)
    if _item_num_need == nil or _item_num_need == 0 or _item_num_have < _item_num_need then 
        self.upgrade_but:setCurState( CLICK_STATE_DISABLE )
    else
        self.upgrade_but:setCurState( CLICK_STATE_UP )
    end
end

function Upgrade:check_can_upgrade( ... )
    if _item_num_need == nil or _item_num_need == 0 or _item_num_have < _item_num_need then 
        local show_content = Lang.forge.common[3]
        GlobalFunc:create_screen_notic( show_content, nil, 250, 130 )
        return false
    end
    return true
end

-- 发送装备升级的消息
function Upgrade:send_request_upgrade(  )

    if _left_slotitem_item_source.item_series == nil then
        local show_content = LangModelString[145] -- [145]="请先选择装备"
        GlobalFunc:create_screen_notic( show_content, nil, 250, 130 )
        return
    end

    if _item_num_need == nil or _item_num_need == 0 or _item_num_have < _item_num_need then 
        local show_content = Lang.forge.common[3]
        GlobalFunc:create_screen_notic( show_content, nil, 250, 130 )
        return
    end

    ForgeWin:set_if_waiting_result( true )
    ForgeWin:set_if_waiting_reflash( true )
    -- 如果辅助材料不足，就不发送
    if _item_num_have < _item_num_need then 
        return 
    end

    --local item_count = 1 + #_mate_series_t                                    -- 物品个数  选中装备加材料的道具数
    local item_count = 1;
    local id_items   = { _left_slotitem_item_source.item_series}              -- 物品的序列号
    -- for i, v in ipairs(_mate_series_t) do
    --     id_items[#id_items + 1] = v
    --     print("send_request_upgrade..................."..v)
    -- end
    local htype      = 11                                                     -- 操作类型
    local param_count = 1
    local param_arr  = {  }                                    
    local param = 0;
    if ( _left_is_use_bhf  ) then
        param = 1;
    end
    table.insert(param_arr,param);
   -- print("item_count..............................",item_count)
    ItemCC:req_handle_item (item_count, id_items, htype, param_count, param_arr)

end


--================================================================================================================================
--================================================================================================================================
--
--左侧
--
--================================================================================================================================
--================================================================================================================================
---创建左侧panel
function Upgrade:create_left_panel( pos_x, pos_y, width, height, texture_name )

    local panel = CCBasePanel:panelWithFile( pos_x, pos_y, width, height, texture_name, 500, 500 )

    self:create_bag_slot( panel )

    self.panel_t["right_panel"] = panel                   --存入table，用于动态修改
    return panel
end

--创建右侧物品栏的一个item 和 信息。因为和左侧物品处理方式不一样，要分开写一个方法。
--参数：父panel、物品id（当使用默认图标时，使用nil）、坐标、大小、num表示等级或者数量
local row_index_count = 1         -- 存储入self.row_t 的序号，用来防止多次创建，key重复，造成scroll销毁，通知从self.row_t删除。而新建的也被删了。
function Upgrade:create_item_right( item_id, po_x , po_y, size_w, size_h , num, item_series)
    require "config/ItemConfig"
    local item = ItemConfig:get_item_by_id( item_id )     --获取item基本信息
    local slot_w, slot_h = 64, 64
    local slotItem = SlotItem(slot_w, slot_h)
    slotItem.view:setScale( 54 / 64 )
    slotItem:set_icon_bg_texture( UIPIC_ITEMSLOT, -9.5, -9.5, 83, 83)   -- 背框
    
    if item_id == nil then
        item_id = 0                               --设置一个不存在的值，会获取到默认图标
    end
    slotItem:set_icon( item_id )
    self:set_slot_lock( item_series, slotItem)
    slotItem.item_series = item_series
    slotItem:set_color_frame( item_id, -2, -2, 68, 68 )
    slotItem:setPosition( po_x , po_y )
    -- 设置图标的强化等级
    if num then
        slotItem:set_strong_level( num )
    else
        slotItem:set_strong_level( 0 )
    end
    --设置回调单击函数
    local function f1()
        ZXLog("--------------item_id, num, item_series:",item_id, num, item_series)
        self:set_left_item( "", item_id, num, item_series)
        self:set_r_up_one_slot_disable( slotItem  )
    end
    slotItem.f1 = f1
    slotItem:set_click_event(f1)
    -- slotItem:set_double_click_event( f1 )

    -- local function f2( arg )
    --     local position = Utils:Split(arg,":");
    --         -- 将相对坐标转化成屏幕坐标(即OpenGL坐标 800x480)
    --     local pos = slotItem.view:convertToWorldSpace( CCPointMake(position[1],position[2]) );
    --    -- ForgeModel:show_item_tips( item_id, pos.x, pos.y )
    --     local user_item = UserInfoModel:get_equi_by_id( slotItem.item_series )
    --     TipsModel:show_tip( pos.x, pos.y,user_item )
    -- end
    -- slotItem:set_click_event( f2 )
    
    --显示信息:名称和数字
    local dimensions = CCSize(100,15)
    local label_temp = UILabel:create_lable_2(item.name, 75, 45, font_size+2, ALIGH_LEFT)
    slotItem.name_label  = label_temp              --存储起来，使用关键字获取并修改显示内容
    slotItem.view:addChild( label_temp )           --因为lable要随slot共存亡，所以是添加到slot的view中
    require "UI/forge/ForgeCommon"
    ForgeCommon:set_label_color_by_type( item.color, label_temp )

    -- local atta_num = self:get_atta_value_by_series( item_series , item_id)                              --战斗力
    local item_date = ForgeModel:get_item_in_bag_or_body( item_series ) or {}
    local strong = item_date.strong or 0
    label_temp = UILabel:create_lable_2(LangGameString[1031]..strong, 75, 8, font_size+2, ALIGH_LEFT) -- [1031]="强化 +"
    slotItem.num_label  = label_temp               --存储起来，使用关键字获取并修改显示内容
    slotItem.view:addChild( label_temp )           --因为lable要随slot共存亡，所以是添加到slot的view中

    -- panel:addChild( slotItem.view )

    -- 当滑动区域，item消失，就会销毁view。  这里在这个事件发生时，把本slotitem从 slot集合中清除
    local function delete_callback()
        self.right_item_t[ slotItem.row_t_index ]   = nil
    end
    slotItem:set_delete_event( delete_callback )

    slotItem.row_t_index = row_index_count         -- 存入表中的key
    row_index_count = row_index_count + 1          -- 每创建一个，计数加1

    self.right_item_t[ slotItem.row_t_index ] = slotItem

    -- 设置装备品质
    local user_item = UserInfoModel:get_equi_by_id( item_series );
    local item_base = ItemConfig:get_item_by_id( user_item.item_id )
    local pj = ItemModel:get_item_pj( item_base )
    slotItem:set_item_quality(user_item.void_bytes_tab[1],pj);
    
    return slotItem
end


--创建背包中的可升级物品slotitem:参数：要加入的面板， 物品的类型（宝贝，翅膀等 ）
function Upgrade:create_bag_slot( panel )
    --坐标计算
    local slot_beg_x = 20         --起始x坐标
    local slot_beg_y = 255        --起始x坐标
    local slot_int_x = 100        --横坐标间隔
    local slot_int_y = 45         --纵坐标间隔
    
    --遍历玩家装备
    require "config/ItemConfig"
    local user_equi_info = UserInfoModel:get_equi_info()        --所有装备信息
    local equip = nil
    local place_index = 1                                      --这里物品不是每个都显示的，所以位置要分开计数
    -- local item_base = nil                                      --基础item数据，用来获取物品的公共属性
    local check_table = {}                                     -- 判断是否可以升级的table

    local slot_par = {}

    for i , v in ipairs(user_equi_info) do
        equip = v

        -- 获取装备的基础信息
        -- 判断该id是否可以升级
        if self:check_item_can_upgr(equip.item_id) then
            -- self:create_item_right( panel, equip.item_id, slot_beg_x + slot_int_x*  ((place_index - 1) % 4 ) , slot_beg_y - slot_int_y  * ((place_index - 1) / 4 - (place_index - 1)/4%1 ) , 40, 40, equip.strong, equip.series)
            -- place_index = place_index + 1
            -- 数据为slotitem的x，y
            slot_par[ #slot_par + 1] = { equip.item_id, 15, 20 , 55, 55, equip.strong, equip.series }
        end
    end

    local scroll = self:create_scroll_area( slot_par, 5, 18, 400, 452, 2, 4, nil)
    local arrow_up = CCZXImage:imageWithFile(405 , 465, 10, -1 , UILH_COMMON.scrollbar_up, 500, 500)
    local arrow_down = CCZXImage:imageWithFile(405, 8, 10, -1, UILH_COMMON.scrollbar_down, 500 , 500)
    panel:addChild( scroll )
    panel:addChild(arrow_up)
    panel:addChild(arrow_down)
    self.r_down_scroll = scroll
    self.slot_par = slot_par
    row_index_count = 1
end

-- 默认选中第一个
function Upgrade:set_default_item(  )
    -- 默认选中第一个
    local slot_par = self.slot_par
    if not slot_par then
        return
    end
    if #slot_par > 0 then
        local item_panel = self.right_item_t[1]
        for k,v in pairs(self.right_item_t) do
            item_panel = v
            if item_panel then
                item_panel.f1()
                return
            end
        end
    end
end

-- 创建可拖动区域   参数：放入scroll的panel的集合, 坐标， 区域大小，列数， 背景名称
function Upgrade:create_scroll_area( panel_table_para ,pos_x, pos_y, size_w, size_h, colu_num, sight_num, bg_name)
    local row_num = math.ceil(#panel_table_para / colu_num)
    local _scroll_info = { x = pos_x, y = pos_y, width = size_w, height = size_h, maxnum = 1, image = bg_name, stype = TYPE_HORIZONTAL }
    local scroll = CCScroll:scrollWithFile( _scroll_info.x, _scroll_info.y, _scroll_info.width, _scroll_info.height, _scroll_info.maxnum, _scroll_info.image, _scroll_info.stype )
    scroll:setScrollLump(UILH_COMMON.up_progress, UILH_COMMON.down_progress, 10, 30, 480 )
    scroll:setScrollLumpPos(_scroll_info.width)

    local row_h = 93
    local row_w = 190
    local scroll_panel = CCBasePanel:panelWithFile( 0, 0, size_w, row_h*row_num, "", 500, 500)

    local item_x = 0; 
    local item_y = 0;
    local item_space_column = 5
    local space_x = 5
    for i,v in ipairs(panel_table_para) do
        item_x = 0; 
        item_y = row_h*row_num-row_h*math.ceil(i/2)

        if i%2 == 0 then
            item_x = row_w + item_space_column * 2;
        else
            item_x = item_space_column
        end
        local bg = self:create_item_show_panel( panel_table_para[i], 0, 0, row_w, row_h )
        local item = CCBasePanel:panelWithFile(item_x, item_y, row_w, row_h + 5, "")
        if bg then
            item:addChild(bg.view)
        end
        scroll_panel:addChild(item)
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
            -- local temparg = Utils:Split(args,":")
            -- local x = temparg[1]              -- 行
            -- local index = x * colu_num 
            -- local row_h = 94
            -- local row_w = 226
            -- local bg_vertical = CCBasePanel:panelWithFile( 0, 6, row_w, row_h, "", 500, 500)
            -- local bg = self:create_item_show_panel( panel_table_para[index + 1], 0, 0, row_w, row_h )
            -- if bg then
            --     bg_vertical:addChild(bg.view)
            -- end
            -- local item = CCBasePanel:panelWithFile(0, 0, row_w, row_h + 6, "")
            -- item:addChild(bg_vertical)
            -- scroll:addItem(item)
            scroll:addItem(scroll_panel)
            scroll:refresh()
            return true
        end
    end
    scroll:registerScriptHandler(scrollfun)
    scroll:refresh()

    return scroll
end

-- 创建一个道具显示面板
function Upgrade:create_item_show_panel( panel_date, x, y, w, h )
    local t = panel_date                -- 历史原因，使用t
    if panel_date == nil then
        return nil
    end
    local item_show_panel = {}
    local item_show_panel_bg = CCBasePanel:panelWithFile( x, y , w, h, UILH_COMMON.bg_10, 500, 500 )
    item_show_panel.view = item_show_panel_bg

    local slotItem = self:create_item_right( t[1],t[2],t[3],t[4],t[5],t[6],t[7],t[8] )
    if slotItem then
        item_show_panel.view:addChild(slotItem.view)
    end

    local selected_bg = CCBasePanel:panelWithFile(0, 0, w, h, UILH_COMMON.slot_focus, 500, 500)
    item_show_panel.view:addChild(selected_bg)
    selected_bg:setIsVisible(false)

    item_show_panel.set_selected = function( show_flash )
        selected_bg:setIsVisible(show_flash)
    end

    function click_bg_fun( eventType )
        if eventType == TOUCH_CLICK then
            slotItem.f1()
        end
    end
    item_show_panel.view:registerScriptHandler(click_bg_fun)

    slotItem.bg = item_show_panel

    return item_show_panel
end

-- 检查某一个sereies是否和选中的一样，如果一样，在创建之后，就设置为不可按状态
function Upgrade:check_create_slot_if_sele( slotItem )
    if slotItem.item_series == _left_slotitem_item_source.item_series then
        self:set_r_up_one_slot_disable( slotItem )
    end
end



-- 判断一个装备是否可以升级
function Upgrade:check_item_can_upgr( item_id )
    -- 获取人物信息(等级)
    local player = EntityManager:get_player_avatar()

    require "config/EquipEnhanceConfig"
    local upgrade_t = EquipEnhanceConfig:get_upgrade_table( )
    for i, v in ipairs(upgrade_t) do                    -- 遍历升级信息表，查询每个等级的itemid集合
        if player.level >= v.checkLevel and v.checkLevel <= 60 then                       -- 套装对人物有级数要求
            for j,k in ipairs(v.items) do               -- 查询item_id集合，判断传入的id是否可以升级
                if k == item_id then                    -- 
                    return true
                end
            end
        end
    end

    return false
end

--刷新右侧所有item. 
function Upgrade:flash_all_item_right( )
    self:remove_all_item_right( )
    self:create_bag_slot( self.panel_t["right_panel"] )
end

--清空右侧面板所有item
function Upgrade:remove_all_item_right( )
    local panel  = self.panel_t["right_panel"]           --默认上面的装备面板
    local item_table = self.right_item_t                 --上面所有item的table

    panel:removeChild(self.r_down_scroll, true)  
    for key, slotitem in pairs(item_table) do
        panel:removeChild( slotitem.view, true )
    end
    self.right_item_t = {}                                      -- 清空以后，表也要清空
end

-- -- 设置制定slot为无效效状态
function Upgrade:set_r_up_one_slot_disable( slotItem  )
    -- 必须先设置其他为有效装备
    for i, slot in pairs(self.right_item_t) do 
        -- slot:set_slot_enable()
        slot.bg.set_selected(false)
    end
    -- slotItem:set_slot_disable( )
    slotItem.bg.set_selected(true)
end

-- 设置材料栏某个item可以点击
function Upgrade:set_r_up_one_slot_able( item_series )
    for i, slot in pairs(self.right_item_t) do 
        if slot.item_series == item_series then
            slot:set_slot_enable()
        end
    end
end

-- 设置锁
function Upgrade:set_slot_lock( item_series, slotItem )
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
function Upgrade:show_tool_tips_left(  type )
    local extend_date = {}
    if "source" == type then
        ToolTipMgr( "item", _left_slotitem_item_source.item_id, extend_date)
    elseif "target" == type then
        ToolTipMgr( "item", _left_slotitem_item_target.item_id, extend_date)
    else
        ToolTipMgr( "item", _left_slotitem_item_need.item_id, extend_date)
    end
    
end

function Upgrade:show_tool_tips_rihgt(  item_id )
    local extend_date = {}
    ToolTipMgr( "item", item_id,extend_date)
end

function Upgrade:active()

end
