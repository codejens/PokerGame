-- BuyKeyboardWin.lua
-- created by hcl on 2013/1/6
-- 通用的购买面板

-- =============================================================================
--**************       添加说明      *******************************************
-- 1、 get_pay_one 获取单价的方法
-- 2、 compute_max_num  会根据当前持有对应类型货币数，计算最大可购买数量
-- 3、 flash_all_label  左侧价格区域显示的提示信息
-- 4、 make_sure_but_callback   按确定按钮，发送购买消息
--*******************************************************************************
-- =============================================================================

require "UI/component/Window"
require "utils/MUtils"
super_class.BuyKeyboardWin(Window)

local _buy_num  = 1               -- 购买的数量 
local _pay_gold = 0               -- 需要支付的元宝
local label_t = {};               --用来存储label，动态修改
local _cb_fun = nil;

local panel = nil; 

local _if_first_enter = true       -- 是否第一次输入，（第一次的话，要把默认数字替换）

-- ==========================================================================
-- item_id:道具id,cb_fun:点击确定的回调,
-- do_type:1=商城购买，2=拆分,3=仙宗跳转,4=仙宗捐献,5=商店购买,6=购买声望道具, 7=购买仙宗商店的道具, 
--         8 ：当纯数字键盘使用，在 ex_params 第一个元素中传入显示的提示字符，要求四个字
--         9 : 神秘商店  : 附加参数应该是配置表的该道具的信息，包括限制价格等
--         10: 炼器合成
--         11: 仙宗神兽
--         13: 仙宗仓库转移到背包数量
--         14: 批量使用
--         15: 乾坤兑换
--         200:聚仙令兑换
-- item_max_num:物品允许的最大数量
-- ex_params  table类型，作为附加参数使用
-- ===========================================================================
function BuyKeyboardWin:show(item_id, cb_fun, do_type, item_max_num , ex_params, is_active_zero )
    print("BuyKeyboardWin:show(item_id, cb_fun, do_type, item_max_num , ex_params, is_active_zero )",item_id, cb_fun, do_type, item_max_num , ex_params, is_active_zero)
    _if_first_enter = true
    -- 创建通用购买面板
    local win = UIManager:show_window("buy_keyboard_win",true);
    --win:setPosition(170, 130)
    -- 点击确定按钮的回调
    _cb_fun = cb_fun;

    win.item_id = item_id;                               -- 物品id
    win.type = do_type or 1                              -- 购买窗口类型
    win.ex_params = ex_params or {}                      -- 附加参数  （特殊购买窗口使用）
    
    win.item_max_num = item_max_num or 99                 -- 最大数量
    win:compute_max_num( )

    win:create_item_right( item_id);                     -- 创建左上角物品的icon

    _buy_num  = 1
    if do_type == 10 or do_type == 14 then                                -- 炼器合成/批量使用，默认是最大数量
        _buy_num = win.item_max_num
    end

    win:flash_all_label();
    win:check_action_but_able()
    if is_active_zero == nil then
        win.is_active_zero = false
    else
        win.is_active_zero = is_active_zero
    end
end

-- 获取单价，根据itemid
function BuyKeyboardWin:get_pay_one( item_id )
    local ret = 0
    if self.type == 1 then
        local store_item = self:get_item_sell_info( item_id )
        if store_item then
            ret = store_item.price[1].price
            local play = EntityManager:get_player_avatar()
            -- ret = QQVipInterface:mall_price( play.QQVIP, ret )
            -- local qqvip_info = QQVIPName:get_user_qq_vip_info(play.QQVIP)
            -- print("run BuyKeyboardWin:get_pay_one qqvip_info.is_blue_vip,qqvip_info.is_super_blue_vip",qqvip_info.is_blue_vip,qqvip_info.is_super_blue_vip)
            -- if qqvip_info.is_blue_vip == 1 or qqvip_info.is_super_blue_vip == 1 then
            --     ret = math.floor( ret * 0.8 )
            -- end      
        end
    elseif self.type == 4 then      -- 仙宗贡献
        -- 仙宗捐献，没有单价单价无用
    elseif self.type == 5 then
        local item_base = ItemConfig:get_item_by_id( item_id )
        if item_base then
            ret = item_base.dealPrice * 3
        end
    elseif self.type == 6 then
        local price_name, price_value = ExchangeModel:get_item_need_money( item_id, self.ex_params[2] )
        ret = price_value
    elseif self.type == 7 then
        ret = GuildModel:get_guild_shop_price_by_id( item_id )
    elseif self.type == 9 then
        ret = self.ex_params[1].price[1].price
    elseif self.type == 10 then
        ret = ForgeModel:get_need_money_by_id( item_id )
    elseif self.type == 11 then
        ret = GuildModel:get_altar_price_rate()
    else
        -- require "config/StoreConfig"
        -- local store_item = StoreConfig:get_store_info_by_id( item_id )
        -- if store_item then
        --     ret = store_item.price[1].price
        -- end
    end
    return ret
end

-- 根据数量，获取总价格
function BuyKeyboardWin:get_pay_gold( item_id, num )
    local ret = 0
    ret = num * self:get_pay_one( item_id )
    return ret
end

-- 根据当前支付能力，计算出最多能支付的数量。并且选择传入的最大数量和计算出的数量中，比较小的
function BuyKeyboardWin:compute_max_num(  )
    local price = self:get_pay_one( self.item_id )             
    local max_num_can = 1000000000000000         -- 可以购买的最大数量
    
    if self.type == 1 then  -- 商城
        local item_mall_info = self:get_item_sell_info(  )
        local money_total = self:get_user_money_total_by_type( item_mall_info.price[1].type )             -- 根据货币类型获取当前持有数
        max_num_can = math.floor( money_total / price )
    elseif self.type == 4 then   -- 仙宗贡献   最大值是元宝数
        local player = EntityManager:get_player_avatar();
        max_num_can = player.yuanbao > player.bindYuanbao and player.yuanbao or player.bindYuanbao
    elseif self.type == 5 then
        local item_base = ItemConfig:get_item_by_id( self.item_id )
        if item_base then
            local own_money = BuyKeyboardWin:get_user_money_total_by_type( item_base.dealType )           -- 根据货币类型获取当前持有数
            max_num_can = math.floor( own_money / price )
        end
    elseif self.type == 6  then
        local item_exchange_info = RenownShopConfig:get_item_info_by_id( self.item_id, self.ex_params[2] )
        if item_exchange_info then
            local money_total = self:get_user_money_total_by_type( item_exchange_info.price[1].type )     -- 根据货币类型获取当前持有数
            max_num_can = math.floor( money_total / price )
        end
    elseif self.type == 7 then
        local own_money = GuildModel:get_user_guild_contribute(  )
        max_num_can = math.floor( own_money / price )
    elseif self.type == 9 then
        local own_money = self:get_user_money_total_by_type( self.ex_params[1].price[1].type )               -- 根据货币类型获取当前持有数
        max_num_can = math.floor( own_money / price )
    elseif self.type == 11 then
        max_num_can = GuildModel:get_guild_altar_page_info().find_xian_guo_num
    elseif self.type == 200 then 
        print("self.ex_params[1]",self.ex_params[1],self.ex_params[3])
        max_num_can = math.floor( self.ex_params[3] / self.ex_params[1] )
    else
        -- 其他都按照传入的最大值限制
        max_num_can = self.item_max_num or 1000000000000000
    end
    self.item_max_num = math.min( self.item_max_num, max_num_can )
end

-- function BuyKeyboardWin:create(texture_name)
--     --return BuyKeyboardWin("ui/common/bg01.png",152,114,529,269);
--     return BuyKeyboardWin(nil,{texture = nil,x = 152, y = 114,width = 529,height = 269});
-- end

-- 
function BuyKeyboardWin:__init(window_name, texture_name, is_grid, width, height)
    _if_first_enter = true
    panel = self.view;
    panel:setDefaultMessageReturn(true);
    --self.fath_object = fath_object
	--self.fath_panel = fath_panel            -- 把父节点存储起来，取消的时候remove自己
    -- self.item_id     = item_id                -- 获取物品的价格等需要

    -- local spr_bg = CCZXImage:imageWithFile( -5, 0, 550, 285, UIResourcePath.FileLocate.common .. "bg01.png", 50, 50 );
    -- panel:addChild( spr_bg )

    --local left_bg = CCZXImage:imageWithFile( 20, 14, 190, 235, UIPIC_GRID_nine_grid_bg3, 500, 500 )
    --panel:addChild( left_bg )

    -- local board_bg = CCBasePanel:panelWithFile(0, 0, 530, 287, UIPIC_BUYKEYBOARD_001, 500, 500)
    -- self.view:addChild(board_bg)

    -- local bgPanel = CCBasePanel:panelWithFile(7, 8, 594, 310, UIPIC_BUYKEYBOARD_005, 500, 500)
    -- board_bg:addChild(bgPanel)
    local bgPanel = self.view
    local right_bg = CCBasePanel:panelWithFile( 322, 0, 210, 301, UILH_COMMON.bg_10, 500, 500 )
    bgPanel:addChild( right_bg )

    local left_bg = CCBasePanel:panelWithFile(0, 0, 324, 301, UILH_COMMON.dialog_bg, 500, 500)
    bgPanel:addChild(left_bg)
    local frame_bg = ZImage:create(left_bg, UILH_COMMON.bottom_bg, 15, 78, 295, 200, 0, 500, 500)
    local title_bg = ZImage:create(left_bg, UILH_NORMAL.title_bg4, 18, 241, 289, -1, 0, 500, 500)
    -- local line = ZImage:create(bgPanel, UILH_COMMON.split_line, 20, 80, 280, 2, 1, 500)
    -- 图标背景
    --label_t["icon_bg"]  = MUtils:create_sprite(panel,"ui/common/item_bg01.png",201-152,326-120);
    label_t["icon_bg"]  = MUtils:create_slot_item(left_bg, UILH_COMMON.slot_bg, 38, 123, 74, 74, nil);
    self.icon_name = MUtils:create_zxfont(left_bg, "", 170, 250, 2, 16)
    -- 物品单价
    label_t[ "pay_gold" ] = MUtils:create_zxfont(left_bg,"",20, 100, 1, 16)

    local guild_info = GuildModel:get_user_guild_info(  )
    self.guild_icon = GuildCommon:get_icon_by_index( guild_info.icon, 26, 108 ,-1,-1 )
    left_bg:addChild(self.guild_icon)

    --购买数量
    self.label_bg = CCBasePanel:panelWithFile( 200, 160, 95, 36, UILH_COMMON.bg_02, 500, 500)
    left_bg:addChild(self.label_bg )

    -- 购买文字
    label_t["buy_text"] = MUtils:create_zxfont(left_bg, Lang.shop[5], 163, 170, ALIGN_CENTER, 16) -- [5]="#c66ff66购买数量:"
    label_t["guild_text2"] = MUtils:create_zxfont(left_bg, "#cfff000"..Lang.normal[4], 283, 170, ALIGN_CENTER, 16) -- [5]="#c66ff66购买数量:"
    label_t["guild_text2"]:setIsVisible(false)

    --购买数量
    label_t[ "buy_num" ] = MUtils:create_zxfont(self.label_bg, _buy_num, 47, 9, 2, 16)
    --存储起来，使用关键字获取并修改显示内容
    -- 消耗元宝
    label_t[ "pay_gold" ] = MUtils:create_zxfont(left_bg,"",120, 130, 1, 16)
    -- 仙宗获得  仙宗贡献专用
    label_t[ "xianzonghuode" ] = MUtils:create_zxfont(left_bg,"", 120, 105, 1, 16)

    -- 确定按钮 
    -- local but_1 = CCNGBtnMulTex:buttonWithFile( 17, 25, 61, 29, UIResourcePath.FileLocate.common .. "button2_bg.png", 500, 500)
    -- but_1:addTexWithFile(CLICK_STATE_DOWN, UIResourcePath.FileLocate.common .. "button2_bg.png")
    -- but_1:addTexWithFile(CLICK_STATE_DISABLE, "ui/common/button2_bg.png")
    local function but_1_fun(eventType,x,y)
        if eventType == TOUCH_BEGAN then
            return true;
        elseif eventType == TOUCH_CLICK then 
            Instruction:handleUIComponentClick(instruct_comps.BUY_KEYBOARD_OK )
            UIManager:hide_window("buy_keyboard_win");
            self:make_sure_but_callback(  )
            return true
        end
        return true
    end
    self.yes_but = MUtils:create_btn( left_bg, 
        UILH_COMMON.lh_button2,
        UILH_COMMON.lh_button2,
        but_1_fun, 
        58, 15, -1, -1)
    self.yes_but:addTexWithFile(CLICK_STATE_DISABLE,UILH_COMMON.lh_button2_disable);
    local yes_btn_lab = UILabel:create_lable_2( Lang.common.confirm[0], 50, 20, 18, ALIGN_CENTER ) --确定
    self.yes_but:addChild(yes_btn_lab)

    -- 取消按钮  
    local function but_2_fun(eventType,x,y)
        if eventType == TOUCH_CLICK then 
            UIManager:hide_window("buy_keyboard_win");
            return true
        end
        return true
    end
    local cancel_btn = MUtils:create_btn( left_bg, 
        UILH_COMMON.button2_sel,
        UILH_COMMON.button2_sel,
        but_2_fun, 
        184, 15, -1, -1)
    local cancel_btn_lab = UILabel:create_lable_2( Lang.common.confirm[9], 50, 20, 18, ALIGN_CENTER ) --取消
    cancel_btn:addChild(cancel_btn_lab)

    --创建数字键盘
    self:create_all_key_but( right_bg )

    ---
    self.is_active_zero = false
end

-- local _dont_show_again = false
-- function BuyKeyboardWin:show_bindingYuanbao_tips(  )
--     local function confirm_func(  )
--         self:send_buy_item(  )
--     end
--     local function switch_fun( if_select )
--         _dont_show_again = if_select
--     end
--     local content = "礼券不足，使用元宝代替"
--     ConfirmWin2:show(5, nil, content, confirm_func, switch_fun, nil)
-- end

-- 确定按钮的回调
function BuyKeyboardWin:make_sure_but_callback(  )
    if _buy_num < 1 then return end
    if (self.type == 1  ) then
        -- local item_mall_info = self:get_item_sell_info( )
        -- if item_mall_info.price[1].type == 5 and _dont_show_again == false then
        --     local player = EntityManager:get_player_avatar()
        --     if player.bindYuanbao < item_mall_info.price[1].price then
        --         self:show_bindingYuanbao_tips()
        --     else
        --         self:send_buy_item()
        --     end
        -- else
            self:send_buy_item(  )
        -- end
    elseif (self.type ==2 or self.type == 3 or self.type == 4 or self.type == 8 or self.type == 10 or self.type == 11 or self.type == 13 or self.type == 14 or self.type == 15) then
        -- 回调
        if ( _cb_fun ) then
            _cb_fun(_buy_num);
        end
    elseif ( self.type == 5) then
        NPCTradeCC:req_buy_from_npc(self.item_id, _buy_num, 0)
    elseif ( self.type == 6) then
        -- 如果是荣誉道具的话，就调用购买荣誉道具的协议
        if self.ex_params[2] == "glory" then
            NPCTradeCC:req_buy_honor_item( self.item_id,_buy_num,0, 0,self.ex_params[1] )
        else
            NPCTradeCC:req_buy_exp_item(self.item_id, _buy_num, 0, 0, self.ex_params[1]);
        end
    elseif ( self.type == 7) then
        GuildCC:request_buy_good( self.item_id, _buy_num )
    elseif ( self.type == 9) then
        -- MiscCC:req_buy_mystical_item( self.ex_params[2] ,self.ex_params[1].id, _buy_num )
        self:send_buy_mystical_item()
    elseif ( self.type == 200) then
        NPCTradeCC:req_buy_jxl_item(self.item_id,_buy_num,0, 0,self.ex_params[4])
         if ( _cb_fun ) then
            _cb_fun()
        end
    end
end

function BuyKeyboardWin:cb_buy_mall_item()
-- 回调
    if ( _cb_fun ) then
        _cb_fun(_buy_num);
    end
end

-- 所有label 更新最新值.  更新数量和总花费
function BuyKeyboardWin:flash_all_label(  )
    require "config/StaticAttriType"
    _buy_num = math.min(_buy_num, self.item_max_num)        -- 输入的数字不能大于最大数量限制
	print('flash_all_label self.type:' .. self.type)
    print(type(self.type))
    if ( self.type == 1 ) then
        local item_mall_info = self:get_item_sell_info( )
        local price_name = _static_money_type[ item_mall_info.price[1].type ] or ""  -- 金钱类型名称
        local price = self:get_pay_one()
        label_t[ "buy_text" ]:setText(Lang.shop[5]) -- [5]="#cfff000购买数量   "
        print('_buy_num price:' , _buy_num, price)
        label_t[ "buy_num" ]:setText(_buy_num)
        label_t[ "pay_gold"]:setText(Lang.shop[6]..price_name.."：" .. tostring(_buy_num*price)) -- [6]="#cffffff消耗"
        -- local money = BuyKeyboardWin:get_user_money_total_by_type( item_mall_info.price[1].type );
        label_t[ "xianzonghuode" ]:setText( "" ); -- [7]="总需"
    elseif ( self.type == 2 )then
        label_t[ "buy_text" ]:setText(Lang.shop[8])
        label_t[ "buy_num" ]:setText(_buy_num) -- [8]="#c66ff66拆分数量:  "
        label_t[ "pay_gold"]:setText("" );
        label_t[ "xianzonghuode" ]:setText("" );
    elseif ( self.type == 3 )then
        label_t[ "buy_text" ]:setText(Lang.shop[9])
        label_t[ "buy_num" ]:setText(_buy_num) -- [9]="#c66ff66跳转页数:  "
        label_t[ "pay_gold"]:setText("" );
        label_t[ "xianzonghuode" ]:setText("" );
    elseif ( self.type == 4 )then
        --军团捐献 特殊一点
        label_t["guild_text2"]:setIsVisible(true)
        label_t[ "buy_text" ]:setText(Lang.shop[10])
        label_t[ "buy_text" ]:setPosition(143, 170)  
        label_t[ "buy_num" ]:setText(_buy_num); -- [10]="#c66ff66捐献元宝:  "
        label_t[ "buy_num" ]:setPosition(38, 9)
        self.label_bg:setPosition(161, 160)
        local contirbutionRatio = GuildConfig:get_contirbutionRatio(  )                    -- 一元宝可得多少贡献
        label_t[ "pay_gold"]:setText(Lang.shop[11].. tostring(_buy_num*contirbutionRatio).. Lang.shop[12]); -- [11]="你将获得" -- [12]="仙宗贡献"
        label_t[ "pay_gold"]:setPosition(95, 130)
        local temp_rate = GuildConfig:get_yuanbao_lingshi_rate()
        label_t[ "xianzonghuode" ]:setText(Lang.shop[13].. tostring(_buy_num*temp_rate) .. Lang.shop[14]); -- [13]="仙宗获得" -- [14]="仙宗灵石"
        label_t[ "xianzonghuode" ]:setPosition(95, 105)
    elseif ( self.type == 5 )then
        local item_struct = ItemConfig:get_item_by_id( self.item_id );
        local price_name = _static_money_type[ item_struct.dealType ] or ""
        label_t[ "buy_text" ]:setText(Lang.shop[5])
        label_t[ "buy_num" ]:setText(_buy_num) -- [5]="#cfff000购买数量   "
        label_t[ "pay_gold"]:setText(Lang.shop[6]..price_name..":" .. item_struct.dealPrice * 3 * _buy_num) -- [6]="#cffffff消耗"
        local money = BuyKeyboardWin:get_user_money_total_by_type( item_struct.dealType );
        label_t[ "xianzonghuode" ]:setText("" ); -- [15]="#cfff000拥有"
    elseif ( self.type == 6 or self.type == 12 ) then
        local price_name, price_value,money_type = ExchangeModel:get_item_need_money( self.item_id, self.ex_params[2] )
        label_t[ "buy_text" ]:setText(Lang.shop[5])
        label_t[ "buy_num" ]:setText(_buy_num) -- [5]="#cfff000购买数量   "
        label_t[ "pay_gold"]:setText(Lang.shop[6]..price_name..":" .. price_value * _buy_num) -- [6]="#cffffff消耗"
        local money = BuyKeyboardWin:get_user_money_total_by_type( money_type );
        label_t[ "xianzonghuode" ]:setText(""); -- [15]="#cfff000拥有"
    elseif ( self.type == 7 ) then
        local price_value = self:get_pay_one( self.item_id )
        label_t[ "buy_text" ]:setText(Lang.shop[5])
        label_t[ "buy_num" ]:setText(_buy_num) -- [5]="#cfff000购买数量   "
        label_t[ "pay_gold"]:setText(Lang.shop[16]..":" .. price_value * _buy_num) -- [16]="#cffffff消耗贡献"
        label_t[ "xianzonghuode" ]:setText("" );
    elseif ( self.type == 8 ) then
        label_t[ "buy_text" ]:setText("#c66ff66"..self.ex_params[1])
        label_t[ "buy_num" ]:setText(_buy_num)
        label_t[ "pay_gold"]:setText("" );
        label_t[ "xianzonghuode" ]:setText("" );
    elseif ( self.type == 9 ) then
        local price_name = _static_money_type[ self.ex_params[1].price[1].type ] or ""
        label_t[ "buy_text" ]:setText(Lang.shop[5])
        label_t[ "buy_num" ]:setText(_buy_num) -- [5]="#cfff000购买数量   "
        label_t[ "pay_gold"]:setText(Lang.shop[6]..price_name..":" .. self.ex_params[1].price[1].price * _buy_num) -- [6]="#cffffff消耗"
        -- local money = BuyKeyboardWin:get_user_money_total_by_type( self.ex_params[1].price[1].type );
        label_t[ "xianzonghuode" ]:setText( "" ); -- [7]="#cfff000拥有"
    elseif ( self.type == 10 ) then
        label_t[ "buy_text" ]:setText(Lang.shop[17])
        label_t[ "buy_num" ]:setText(_buy_num) -- [17]="#c66ff66合成数量:  "
        label_t[ "pay_gold"]:setText(Lang.shop[18] .. self:get_pay_one( self.item_id ) * _buy_num) -- [18]="#cffffff消耗仙币:  "
        local money = BuyKeyboardWin:get_user_money_total_by_type(0);
        label_t[ "xianzonghuode" ]:setText( "" )
    elseif ( self.type == 11 ) then
        label_t[ "buy_text" ]:setText("#c66ff66"..self.ex_params[1])
        label_t[ "buy_num" ]:setText(_buy_num)
        label_t[ "pay_gold"]:setText("" );
        label_t[ "xianzonghuode" ]:setText("" );        
    elseif ( self.type == 13 ) then
        -- print("#c66ff66取出数量")
        label_t[ "buy_text" ]:setText(Lang.shop[20])
        label_t[ "buy_num" ]:setText(_buy_num); -- [20]="#c66ff66取出数量:  "
        label_t[ "pay_gold"]:setText("" );
        label_t[ "xianzonghuode" ]:setText("" );  
    elseif ( self.type == 14 ) then
        label_t[ "buy_text" ]:setText(Lang.shop[21]) -- [21] = "使用数量："
        label_t[ "buy_num" ]:setText(_buy_num)
        label_t[ "pay_gold" ]:setText("")
        label_t[ "xianzonghuode" ]:setText(Lang.shop[22] .. self.item_max_num) -- [238322= "拥有数量："
    elseif ( self.type == 15 ) then
        label_t[ "buy_text" ]:setText(Lang.shop[5]) -- [21] = "购买数量"
        label_t[ "buy_num" ]:setText(_buy_num)
        print('self.ex_params[1]:', self.ex_params[1])
        label_t[ "pay_gold" ]:setText(Lang.shop[29] .. self.ex_params[1]* _buy_num)
        -- label_t[ "xianzonghuode" ]:setText(Lang.shop[29] .. self.item_max_num* _buy_num) -- = "消耗积分："
    elseif   ( self.type == 200 ) then    --组队副本
        local data  = self.ex_params or {}
        local price = data[1]
        local money_type = data[2]
        local hava = data[3]

        label_t[ "buy_num" ]:setText(_buy_num)
        label_t[ "pay_gold"]:setText(Lang.shop[6]..money_type..":" .. price * _buy_num)
        label_t[ "xianzonghuode" ]:setText(Lang.shop[15]..money_type..":"..hava ); 
    end
end

-- 生成所有按钮
function BuyKeyboardWin:create_all_key_but( panel )
    local key_t = {"back", "0", "clear", "1", "2", "3", "4", "5", "6", "7", "8", "9"}

    -- 坐标计算数据
    local x_beg = 6        -- x轴起始坐标
    local y_beg = 230
    local x_int = 67        -- x轴方向间隔
    local y_int = 75

    for i, v in ipairs(key_t) do
        self:create_akey( panel, v, x_beg + x_int*  ((i - 1) % 3 ) , y_beg - y_int  * ((i - 1) / 3 - (i - 1) / 3 % 1 ) )
    end
end

-- 生成一个按键
function BuyKeyboardWin:create_akey( panel, key_name, x, y )
    local key_path = UIResourcePath.FileLocate.lh_other
    if key_name == "back" then
        key_path = key_path .. "delete.png"
        -- key_path = UIPIC_BUYKEYBOARD_002
    elseif key_name == "clear" then
        key_path = key_path .. "clear.png"
        -- key_path = UIPIC_BUYKEYBOARD_002
    else
        key_path = key_path .. key_name ..".png";
        -- key_path = UIPIC_BUYKEYBOARD_002
    end 
    local key_path_bg = UILH_OTHER.num_bg
    -- local key_path_bg_2 = UIPIC_BUYKEYBOARD_003

    local but_1 = CCNGBtnMulTex:buttonWithFile( x, y, 63, 63, key_path_bg, 500, 500)
    -- but_1:addTexWithFile(CLICK_STATE_DOWN, key_path_2)
    --but_1:addTexWithFile(CLICK_STATE_DISABLE, "ui/forge/compute_bg.png")

    local num = ZImage:create(but_1, key_path, 50, 25, -1, -1)
    num:setAnchorPoint(0.5, 0.5)
    num:setPosition(60/2, 60/2)


    --local but_1 = ZButton:create(nil,  UIResourcePath.FileLocate.buykey .. "number"..".png", nil, x, y, 79, 65)  
    local function but_1_fun(eventType,x,y)
        if eventType == TOUCH_BEGAN then
            return true;
        elseif eventType == TOUCH_CLICK  then 
            self:key_fun( key_name )
            return true
        end
        return true
    end
    but_1:registerScriptHandler(but_1_fun)    --注册

    -- local num_label = UILabel:create_lable_2( key_name, 50, 20, 16, ALIGN_CENTER )
    -- but_1:addChild(num_label)

    -- --按钮显示的名称. clear和back特殊处理.
    -- local label_but_1 = nil
    -- if key_name == "back" then
    --     label_but_1 = CCZXImage:imageWithFile( 23.5, 14.5, 26, 19, UIResourcePath.FileLocate.normal .. "conpute_arrow.png", 500, 500)
    --     but_1:addChild( label_but_1 ) 
    -- elseif key_name == "clear" then
    -- 	local label_but_1 = UILabel:create_label_1(key_name, CCSize(100,30), 37.5 ,  24, 20, CCTextAlignmentCenter, 255, 255, 0)
    --     but_1:addChild( label_but_1 ) 
    -- else   
    -- 	local label_but_1 = UILabel:create_label_1(key_name, CCSize(100,30), 37.5  ,  24, 20, CCTextAlignmentCenter, 255, 255, 0)
    --     but_1:addChild( label_but_1 ) 
    -- end 
             
    panel:addChild( but_1 )
    return but_1
end

-- 键盘按钮处理的函数
function BuyKeyboardWin:key_fun( key_name )
    --------------------------------
    -- 潜规则 唤魂玉只能买一个 所以键盘无效
    if ( self.item_id ==  28245) then
        return;
    end
    ---------------------------------

	if key_name == "back" then
        _buy_num = _buy_num / 10 - ( _buy_num / 10 ) % 1         -- 注意减去小数部分
    elseif key_name == "clear" then
    	_buy_num = 0
    else 
        -- 如果是第一次输入，就先清掉数字
        if _if_first_enter then 
            _buy_num = 0
            _if_first_enter = false
        end
        -- 如果小于最大值，就可以生效，如果超过，就赋值为最大数
        if  (_buy_num * 10 + tonumber(key_name))  < self.item_max_num+1 then
    	    _buy_num = _buy_num * 10 + tonumber(key_name)
        else
            _buy_num = self.item_max_num
        end
    end  

    -- 设置花费的金钱
    _pay_gold = self:get_pay_gold( self.item_id, _buy_num )
    self:flash_all_label()
    self:check_action_but_able()
end

-- 设置确定按钮是否可以有效
function BuyKeyboardWin:check_action_but_able(  )
    if _buy_num == 0 and self.is_active_zero == false then
        self.yes_but:setCurState( CLICK_STATE_DISABLE )
    else
        self.yes_but:setCurState( CLICK_STATE_UP )
    end
end

--创建右侧物品栏的一个item 和 信息。
--参数：父panel、物品id（当使用默认图标时，使用nil）、坐标、大小、序列号：获取物品相关信息备用
function BuyKeyboardWin:create_item_right( item_id )

    print("BuyKeyboardWin:create_item_right( item_id,self.type )",item_id,self.type)
    if ( self.type == 4 or self.type == 11 ) then
        label_t["icon_bg"].view:setIsVisible(false);
        if ( self.icon_name ) then
            self.icon_name:setText("");
        end
        label_t["icon_bg"]:set_icon_texture("");

        local guild_info = GuildModel:get_user_guild_info(  )
        local icon_path = GuildCommon:get_icon_path_by_index(guild_info.icon)
        if self.guild_icon then
            self.guild_icon:setTexture(icon_path)
            self.guild_icon:setIsVisible(true)
        end
        return;
    elseif self.type == 3 then
        label_t["icon_bg"].view:setIsVisible(false);
        if self.guild_icon then
            self.guild_icon:setIsVisible(false)
        end
        if ( self.icon_name ) then
            self.icon_name:setText("");
        end
    elseif self.type==8 then
        label_t["icon_bg"].view:setIsVisible(false);
        if ( self.icon_name ) then
            self.icon_name:setText("");
        end
        label_t["icon_bg"]:set_icon_texture("");

        if self.guild_icon then
            self.guild_icon:setIsVisible(false)
        end
        return;
    else
        label_t["icon_bg"].view:setIsVisible(true);
        if self.guild_icon then
            self.guild_icon:setIsVisible(false)
        end
    end
   
   if item_id == nil then
        return
    end
    require "config/ItemConfig"
    local item = ItemConfig:get_item_by_id( item_id )     --获取item基本信息
    if item == nil then
        return
    end
    local path = ItemConfig:get_item_icon( item_id );
    label_t["icon_bg"]:set_icon_texture(path);
    label_t["icon_bg"]:set_color_frame(item_id, -2, -2, 68, 68);
    --设置回调单击函数
    local function f1()
        TipsModel:show_shop_tip( 400, 240, item_id );
    end
    label_t["icon_bg"]:set_click_event( f1 )

    local color_str = _static_quantity_color[ item.color + 1 ]
    if ( self.icon_name ) then
        self.icon_name:setText( color_str .. item.name);
    else 
        -- self.icon_name = MUtils:create_zxfont(panel, color_str ..item.name, 74, 200);
    end
end

-- 根据id获取商城物品唯一id
function BuyKeyboardWin:get_item_tag_by_id(  )
    local ret = 0
    require "config/StoreConfig"
    local store_item = self:get_item_sell_info( )
    if store_item then
        ret = store_item.id
    end
    return ret
end

-- 发送购买的消息
function BuyKeyboardWin:send_buy_item( )
    require "control/MallCC"
    local item_tag  =  self:get_item_tag_by_id(  )

    local buy_count = _buy_num
    local use_count = 0
    if item_tag == nil or buy_count == nil or buy_count == 0 then
        return
    end
    local item = self:get_mall_item_sell_info()
    local money_type = item.price[1].type
    if item.price[1].type == 5 then
        money_type = MallModel:get_only_use_yb() and 3 or 2
        local price = item.price[1].price * buy_count
        local param = {item_tag, buy_count, use_count, money_type}
        local buy_func = function( param )
            MallCC:req_buy_mall_item(param[1], param[2], param[3], param[4])
        end
        MallModel:handle_auto_buy( price, buy_func, param )
    else
        MallCC:req_buy_mall_item(item_tag, buy_count, use_count, money_type);
    end
end

-- 发送购买神秘商店物品
function BuyKeyboardWin:send_buy_mystical_item(  )
    local price = self.ex_params[1].price[1].price * _buy_num
    local money_type = self.ex_params[1].price[1].type
    if money_type == 5 then
        money_type = MallModel:get_only_use_yb() and 3 or 2
        local param = {self.ex_params[2] ,self.ex_params[1].id, _buy_num, money_type}
        local buy_func = function( param )
            MiscCC:req_buy_mystical_item(param[1], param[2], param[3], param[4])
        end
        MallModel:handle_auto_buy( price, buy_func, param )
    else
        MiscCC:req_buy_mystical_item( self.ex_params[2] ,self.ex_params[1].id, _buy_num, money_type )
    end
end

-- 购买并使用道具
function BuyKeyboardWin:send_buy_item_and_use( item_id , cb ,price)
    -- print("==send_buy_item_and_use==item_id: ", item_id)
    local item_tag  =  StoreConfig:get_item_tag_by_id( item_id )
    _cb_fun = cb;
    require "control/MallCC"
    local item = StoreConfig:get_store_info_by_id( item_id );
    local money_type = item.price[1].type
    -- if item.price[1].type == 5 then
    --     money_type = MallModel:get_only_use_yb() and 3 or 2
    -- end
    -- MallCC:req_buy_mall_item(item_tag, 1, 0, money_type);
    -- -- 如果钱不够就弹个跑马灯
    -- PlayerAvatar:check_is_enough_money( 4,price )

    if item.price[1].type == 5 then
        money_type = MallModel:get_only_use_yb() and 3 or 2
        local price = item.price[1].price * 1
        local param = {item_tag, 1, 0, money_type}
        local buy_func = function( param )
            MallCC:req_buy_mall_item(param[1], param[2], param[3], param[4])
        end
        MallModel:handle_auto_buy( price, buy_func, param )
    else
        MallCC:req_buy_mall_item(item_tag, 1, 0, money_type);
    end
end



-- =================================
-- 特殊功能的函数
-- =================================
-- 获取商城中的出售信息  注意必须用本类的对象来调用 
function BuyKeyboardWin:get_mall_item_sell_info(  )
    require "config/StoreConfig"
    local store_item = nil
    if ( self.ex_params and self.ex_params.mall_category ) then       -- 商城中，不同分类中相同的物品，有不同的属性，要传入分类信息来获取
        store_item = StoreConfig:get_sell_info_by_cate_id( self.item_id, self.ex_params.mall_category ); 
    else
        -- print("====get_mall_item_sell_info====item_id: ", self.item_id)
        store_item = StoreConfig:get_store_info_by_id( self.item_id );
    end
    return store_item
end

-- 根据价格类型获取实际拥有金钱数量 0 仙币 1 银两 2 礼券 3 元宝 4 历练（声望) 7 荣誉  101 仙宗贡献值
function BuyKeyboardWin:get_user_money_total_by_type( money_type )
    local player = EntityManager:get_player_avatar()
    if money_type == 0 then
        return player.bindYinliang
    elseif  money_type == 1 then
        return player.yinliang
    elseif  money_type == 2 then
        return player.bindYuanbao
    elseif  money_type == 3 then
        return player.yuanbao
    elseif  money_type == 4 then
        return player.lilian
    elseif money_type == 5 then
        return player.bindYuanbao + player.yuanbao
    elseif money_type == 7 then 
        return player.honor
    elseif  money_type == 101 then
        return 0
    end
end

-- 获取商品出售信息
function BuyKeyboardWin:get_item_sell_info( )
    if self.type == 1 then
        return self:get_mall_item_sell_info(  )
    elseif self.type == 6 then
        
    end
end

function BuyKeyboardWin:destroy()
    Window.destroy(self)
    --[[旧版新手指引去掉
    if ( XSZYManager:get_state() == XSZYConfig.SHANG_DIAN_ZY ) then
        -- 关掉商店
        UIManager:hide_window("shop_win");
    elseif (  XSZYManager:get_state() == XSZYConfig.DUI_HUAN_ZY ) then
        -- 关掉商店
        UIManager:hide_window("exchange_win");
    end--]]
end

function BuyKeyboardWin:active( show ) 
    
    -- 如果是新手指引 商店指引任务中....
    --[[旧版新手指引去掉
    if ( XSZYManager:get_state() == XSZYConfig.SHANG_DIAN_ZY ) then
        if ( show ) then
            XSZYManager:destroy_jt(XSZYConfig.OTHER_SELECT_TAG);
            -- 指向购买按钮
            -- XSZYManager:play_jt_and_kuang_animation( 152, 132 ,"" ,3,60, 28 ,XSZYConfig.OTHER_SELECT_TAG); 
            XSZYManager:play_jt_and_kuang_animation_by_id(XSZYConfig.SHANG_DIAN_ZY,2, XSZYConfig.OTHER_SELECT_TAG);
        else
            -- 关掉商店
            UIManager:hide_window("shop_win");
        end
    elseif (  XSZYManager:get_state() == XSZYConfig.DUI_HUAN_ZY ) then
        if ( show ) then
            -- XSZYManager:unlock_screen(  );
            -- 指向购买按钮
            -- XSZYManager:play_jt_and_kuang_animation( 152, 132 ,"" ,3,60, 28 ,XSZYConfig.OTHER_SELECT_TAG); 
            XSZYManager:play_jt_and_kuang_animation_by_id(XSZYConfig.DUI_HUAN_ZY, 3,XSZYConfig.OTHER_SELECT_TAG);
        else
            -- 关掉商店
            UIManager:hide_window("exchange_win");
        end
            
    end--]]
end
