-- BuyKeyboard.lua
-- created by lyl on 2012-12-25
-- 炼器--合成功能的购买面板

super_class.BuyKeyboard()

local _buy_num  = 0               -- 购买的数量 
local _pay_gold = 0               -- 需要支付的元宝
local _if_has_show  = false       -- 控制只显示一个 

-- 炼器的数字键盘，构造函数 .参数：构造键盘的类，用于回调批量操作方法！   加入的pannel， 坐标， 序列号：获取物品相关信息备用
function BuyKeyboard:__init( fath_object, fath_panel, fkb_x, fkb_y, item_id ,item_series)
    if _if_has_show then
        return 
    else
       _if_has_show = true
    end
    self.fath_object = fath_object
	self.fath_panel = fath_panel            -- 把父节点存储起来，取消的时候remove自己
    self.item_id     = item_id              -- 获取物品的价格等需要
	local panel = CCBasePanel:panelWithFile( fkb_x, fkb_y, 360, 200, UIResourcePath.FileLocate.common .. "bg01.png" )
    panel:setDefaultMessageReturn(true)
    self.label_t = {}                --用来存储label，动态修改

    local left_bg = CCZXImage:imageWithFile( 10, 8, 185, 174, UIPIC_GRID_nine_grid_bg3, 500, 500 )
    panel:addChild( left_bg )

    local right_bg = CCZXImage:imageWithFile( 197, 8, 145, 170, UIPIC_GRID_nine_grid_bg3, 500, 500 )
    panel:addChild( right_bg )


    -- 左上角物品的icon
    self:create_item_right( panel, item_id, 20 , 120, 57, 56 , item_series)
    
    --购买数量
    local label_bg = CCZXImage:imageWithFile( 68, 90, 100, 20, UIPIC_GRID_nine_grid_bg3 )
    panel:addChild( label_bg )

    --购买数量
    local label_temp = UILabel:create_label_1(LangGameString[985].._buy_num, CCSize(200,40), 115, 100, 12, CCTextAlignmentLeft, 63, 251, 53) -- [985]="购买数量: "
    self.label_t[ "buy_num" ]  = label_temp            --存储起来，使用关键字获取并修改显示内容
    panel:addChild( label_temp )

    -- 消耗元宝
    local label_temp = UILabel:create_label_1(LangGameString[986].._pay_gold, CCSize(200,40), 115, 80, 12, CCTextAlignmentLeft, 255, 255, 0) -- [986]="消耗元宝: "
    self.label_t[ "pay_gold" ]  = label_temp            --存储起来，使用关键字获取并修改显示内容
    panel:addChild( label_temp )


    -- 确定按钮  :对于不用在其他代码位置获取的按钮，直接使用数字命名，方便复制到其他位置使用
    local but_1 = CCNGBtnMulTex:buttonWithFile( 15, 15, 55, 25, UIResourcePath.FileLocate.common .. "button2_bg.png", 500, 500)
    but_1:addTexWithFile(CLICK_STATE_DOWN, UIResourcePath.FileLocate.common .. "button2_bg_d.png")
    -- but_1:addTexWithFile(CLICK_STATE_DISABLE, "ui/common/button2_bg.png")
    local function but_1_fun(eventType,x,y)
        if eventType == TOUCH_CLICK then 
            -- require "config/StoreConfig"
            -- StoreConfig:get_store_info_by_id( item_id )
            self:send_buy_item( )
            _if_has_show  = false
            self.fath_panel:removeChild(self.view, true)
            return true
        end
        return true
    end
    but_1:registerScriptHandler(but_1_fun)    --注册
    panel:addChild(but_1)
    --按钮显示的名称
    local label_but_1 = UILabel:create_label_1(LangGameString[793], CCSize(100,15), 58 ,  15, 15, CCTextAlignmentLeft, 255, 255, 0) -- [793]="确定"
    but_1:addChild( label_but_1 )  
    self.yes_but = but_1           


    -- 取消按钮  :对于不用在其他代码位置使用引用的按钮，直接使用数字命名，方便复制到其他位置使用
    local but_2 = CCNGBtnMulTex:buttonWithFile( 140, 15, 55, 25, UIResourcePath.FileLocate.common .. "button2_bg.png", 500, 500)
    but_2:addTexWithFile(CLICK_STATE_DOWN, UIResourcePath.FileLocate.common .. "button2_bg_d.png")
    --but_2:addTexWithFile(CLICK_STATE_DISABLE, "ui/common/button2_bg.png")
    local function but_2_fun(eventType,x,y)
        if eventType == TOUCH_CLICK then 
            _if_has_show  = false
            self.fath_panel:removeChild(self.view, true)
            return true
        end
        return true
    end
    but_2:registerScriptHandler(but_2_fun)    --注册
    panel:addChild(but_2)
    --按钮显示的名称
    local label_but_2 = UILabel:create_label_1(LangGameString[794], CCSize(100,15), 58 ,  15, 15, CCTextAlignmentLeft, 255, 255, 0) -- [794]="取消"
    but_2:addChild( label_but_2 )  


    _buy_num  = 1
    _pay_gold = self:get_pay_gold( self.item_id, 1 ) 
    self:flash_all_label()


    --创建数字键盘
    self:create_all_key_but( panel )

    self.view = panel
end

-- 所有label 更新最新值
function BuyKeyboard:flash_all_label(  )
	self.label_t[ "buy_num" ]:setString(LangGameString[987] .. _buy_num) -- [987]="购买数量:  "
    self.label_t[ "pay_gold"]:setString(LangGameString[988] .. _pay_gold) -- [988]="消耗元宝:  "
end

-- 生成所有按钮
function BuyKeyboard:create_all_key_but( panel )
    local key_t = {"back", "0", "clear", "1", "2", "3", "4", "5", "6", "7", "8", "9"}

    -- 坐标计算数据
    local x_beg = 207        -- x轴起始坐标
    local y_beg = 137
    local x_int = 42        -- x轴方向间隔
    local y_int = 37

    for i, v in ipairs(key_t) do
        self:create_akey( panel, v, x_beg + x_int*  ((i - 1) % 3 ) , y_beg - y_int  * ((i - 1) / 3 - (i - 1) / 3 % 1 ) )
    end

end

-- 生成一个按键
function BuyKeyboard:create_akey( panel, key_name, x, y )
    local but_1 = CCNGBtnMulTex:buttonWithFile( x, y, 38, 33, UIResourcePath.FileLocate.normal .. "compute_bg.png", 500, 500)
    but_1:addTexWithFile(CLICK_STATE_DOWN, UIResourcePath.FileLocate.normal .. "compute_bg.png")
    --but_1:addTexWithFile(CLICK_STATE_DISABLE, "ui/forge/compute_bg.png")
    local function but_1_fun(eventType,x,y)
        if eventType == TOUCH_CLICK then 
            self:key_fun( key_name )
            return true
        end
        return true
    end
    but_1:registerScriptHandler(but_1_fun)    --注册

    --按钮显示的名称. clear和back特殊处理.
    if key_name == "back" then
        label_but_1 = CCZXImage:imageWithFile( 6, 6, 26, 19, UIResourcePath.FileLocate.normal .. "conpute_arrow.png", 500, 500)
        but_1:addChild( label_but_1 ) 
    elseif key_name == "clear" then
    	local label_but_1 = UILabel:create_label_1(key_name, CCSize(100,15), 55 ,  18, 15, CCTextAlignmentLeft, 255, 255, 0)
        but_1:addChild( label_but_1 ) 
    else   
    	local label_but_1 = UILabel:create_label_1(key_name, CCSize(100,15), 65 ,  18, 15, CCTextAlignmentLeft, 255, 255, 0)
        but_1:addChild( label_but_1 ) 
    end 
             
    
    panel:addChild( but_1 )
    return but_1
end

-- 键盘按钮处理的函数
function BuyKeyboard:key_fun( key_name )
	if key_name == "back" then
        _buy_num = _buy_num / 10 - (_buy_num / 10) % 1         -- 注意减去小数部分
    elseif key_name == "clear" then
    	_buy_num = 0
    else 
        -- 先判断调用这个键盘的类是否存在获取最大值的函数，再调用。如果小于最大值，就可以生效，如果超过，就赋值为最大数
        if  (_buy_num * 10 + tonumber(key_name))  < 100 then
    	    _buy_num = _buy_num * 10 + tonumber(key_name)
        else
            _buy_num = 99
        end
        -- _buy_num = _buy_num * 10 + tonumber(key_name)
    end  

    -- 设置花费的金钱
    _pay_gold = self:get_pay_gold( self.item_id, _buy_num )
    self:flash_all_label()
    self:check_action_but_able()
end

-- 设置确定按钮是否可以有效
function BuyKeyboard:check_action_but_able(  )
    if _buy_num == 0 then
        self.yes_but:setCurState( CLICK_STATE_DISABLE )
    else
        self.yes_but:setCurState( CLICK_STATE_UP )
    end
end

-- 根据数量，获取总价格
function BuyKeyboard:get_pay_gold( item_id, num )
    local ret = 0
    ret = num * self:get_pay_one( item_id )
    return ret
end

-- 获取单价，根据itemid
function BuyKeyboard:get_pay_one( item_id )
    local ret = 0
    require "config/StoreConfig"
    local store_item = StoreConfig:get_store_info_by_id( item_id )
    if store_item then
        ret = store_item.price[1].price
    end
    return ret
end


--创建右侧物品栏的一个item 和 信息。
--参数：父panel、物品id（当使用默认图标时，使用nil）、坐标、大小、序列号：获取物品相关信息备用
function BuyKeyboard:create_item_right( panel, item_id, po_x , po_y, size_w, size_h ,item_series)
    local item = ItemConfig:get_item_by_id( item_id )     --获取item基本信息
    local slotItem = SlotItem(size_w, size_h)             --创建slotitem
    slotItem:set_icon_bg_texture( UIPIC_ITEMSLOT,  -6 ,  -6, size_w+12, size_h+12 )   -- 背框
    
    if item_id == nil then
        item_id = 0                               --设置一个不存在的值，会获取到默认图标
    end
    slotItem:set_icon( item_id )
    slotItem:setPosition( po_x , po_y )
    --设置回调单击函数
    local function f1()

    end
    slotItem:set_click_event( f1 )
    
    --显示信息:名称和数字
    local dimensions = CCSize(100,15)
    local label_temp = UILabel:create_label_1(item.name, dimensions, 115 ,  45, 13, CCTextAlignmentLeft, 255, 255, 0)
    slotItem.name_label  = label_temp              --存储起来，使用关键字获取并修改显示内容
    slotItem.view:addChild( label_temp )           --因为lable要随slot共存亡，所以是添加到slot的view中

    -- label_temp = UILabel:create_label_1(num, dimensions, 115, 20, 15, CCTextAlignmentLeft, 255, 255, 0)
    -- slotItem.num_label  = label_temp               --存储起来，使用关键字获取并修改显示内容
    -- slotItem.view:addChild( label_temp )           --因为lable要随slot共存亡，所以是添加到slot的view中

    panel:addChild( slotItem.view )
    
    return slotItem
end

-- 根据id获取商城物品表示
function BuyKeyboard:get_item_tag_by_id( item_id )
    local ret = nil
    require "config/StoreConfig"
    local store_item = StoreConfig:get_store_info_by_id( item_id )
    if store_item then
        ret = store_item.id
    end
    return ret
end

-- 发送购买的消息
function BuyKeyboard:send_buy_item( )
    local item_tag  =  self:get_item_tag_by_id( self.item_id )
    local buy_count = _buy_num
    local use_count = 0
    if item_tag == nil or buy_count == nil then
        return
    end
    -- 设置炼器窗口为等待结果状态
    ForgeWin:set_if_waiting_result( true )
    ForgeWin:set_if_waiting_reflash( true )

    MallCC:req_buy_mall_item(item_tag, buy_count, use_count)
end
