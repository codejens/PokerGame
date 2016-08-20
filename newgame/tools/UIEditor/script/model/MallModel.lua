-- MallModel.lua
-- created by lyl on 2012-2-17
-- 商城

-- super_class.MallModel()
MallModel = {}


local _limit_sell_item_list = {}     -- 限制的产品列表
local _limit_item_count     = 0      -- 特价剩余时间

local _mall_countdown_timer        = timer()    -- 计时器的id。 每次打开要先关闭

-- added by aXing on 2013-5-25
function MallModel:fini()
	_limit_sell_item_list = {} 
	_limit_item_count     = 0
	_mall_countdown_timer:stop()
end

-- ================================
-- 更新
-- ================================
-- 更新商城窗口
local function update_mall_win( update_type )
	require "UI/mall/MallWin"
	MallWin:update_mall_win( update_type )
end

-- ================================
-- 数据操作
-- ================================

-- 设置特价列表
function MallModel:set_limit_sell_item_list( limit_sell_list )
	_limit_sell_item_list = limit_sell_list
	update_mall_win( "limit" )
end

-- 修改特价道具数量
function MallModel:change_limit_sell_item_num( item_id, left_count, category_id )
	for key, sell_item in pairs(_limit_sell_item_list) do
        if sell_item.mall_item_id == item_id then
            sell_item.uCount = left_count
            update_mall_win( "limit" )
        end
	end
end

-- 获取特价列表
function MallModel:get_limit_sell_item_list(  )
	return _limit_sell_item_list
end

-- 获取某类出售道具id列表,  hot  common  individuality stone pet    binding_gold   huanqing
function MallModel:get_sell_list( category )
	require "config/StoreConfig"
	local item_list = StoreConfig:get_item_list_by_category( category )
	local item_id_t = {}
	for i = 1, #item_list do
        item_id_t[i] = item_list[i].item
	end
    return item_id_t
end

-- 获取玩家元宝
function MallModel:get_player_gold(  )
	local player = EntityManager:get_player_avatar()
	return player.yuanbao
end

-- 获取玩家绑定元宝（礼券）
function MallModel:get_player_binding_gold(  )
	local player = EntityManager:get_player_avatar()
	return player.bindYuanbao
end

-- 根据商城物品id 获取 道具id
function MallModel:get_item_id_by_mall_id( mall_item_id )
	require "config/StoreConfig"
	local item = StoreConfig:get_item_id_by_mall_id( mall_item_id )
	if item then
        return item.item
	end
	return nil
end

-- 设置特价剩余时间
function MallModel:set_limit_time( limit_time )
	_limit_item_count = limit_time
	update_mall_win( "limit_time" )

	-- 定时回调函数.  开始倒计时，并且显示
	local function time_callback( )
		_limit_item_count = _limit_item_count - 1
		update_mall_win( "limit_time" )
	end

	--
	_mall_countdown_timer:stop()
	_mall_countdown_timer:start(t_mmdl_, time_callback)
end

-- 获取剩余时间，二十四制式表示的字符串
function MallModel:get_limit_time_str(  )
	require "utils/Utils"
	return Utils:second_to_24time_str( _limit_item_count )
end

-- ================================
-- 逻辑相关
-- ================================
-- 弹出购买键盘  hot  common  individuality stone pet  binding_gold  hide  limit
function MallModel:show_buy_keyboard( item_id, category,singleBuyLimit )
	local function but_result_fun()
        print("商城购买成功")
	end
	local max_num = 99
	if singleBuyLimit ~= 0 then
        max_num = singleBuyLimit
	end
	if MallModel:check_gold_enough( item_id, category ) then
        BuyKeyboardWin:show( item_id, but_result_fun, 1, max_num, { mall_category = category } )
    else
    	local function confirm2_func()
            print("打开充值界面")
            GlobalFunc:chong_zhi_enter_fun()
            --UIManager:show_window( "chong_zhi_win" )
    	end
    	ConfirmWin2:show( 2, 2, "",  confirm2_func)
	end
end

-- 如果是元宝消耗商品， 判断玩家身上元宝是否足够，如果不够，就弹出充值提示
function MallModel:check_gold_enough( item_id, category )
	if item_id == nil or category == nil then
        return true
	end
	local player = EntityManager:get_player_avatar()
	local item_mall_info = StoreConfig:get_sell_info_by_cate_id( item_id, category )        -- 该物品的商城信息
	-- if item_mall_info.price and item_mall_info.price[1] and item_mall_info.price[1].type ~= 3 then
 --        return true
	-- end
	local item_price = item_mall_info.price[1].price
	-- item_price = QQVipInterface:mall_price(player.QQVIP, item_price)
	--local vip_info = QQVIPName:get_user_qq_vip_info(player.QQVIP)
	-- local vip_info = QQVipInterface:get_qq_vip_platform_info(player.QQVIP)
	-- if vip_info.is_vip == 1 or vip_info.is_super_vip == 1 then
	-- 	item_price = math.floor( item_price * 0.8 )
	-- end
	if type( item_mall_info.price[1].price ) == "number" and item_mall_info.price[1].type == 3 and item_price > player.yuanbao then
        return false
	end
    return true
end

-- 其他系统通知改变数据
function MallModel:date_change_udpate( attr_name )
	local attr_to_type = { yuanbao = "yuanbao", bindYuanbao = "bindYuanbao" }
	if attr_to_type[ attr_name ] then
	    update_mall_win( attr_to_type[ attr_name ] )
	end
end

-- 显示商城tips
function MallModel:show_mall_tips( item_id, x, y)
    TipsModel:show_shop_tip( x, y, item_id )
end

-- 获取颜色
function MallModel:get_item_color( item_id )
    require "model/ItemModel"
    return ItemModel:get_item_color( item_id )
end

-- ================================
-- 与服务器通讯
-- ================================

-- 申请热销商品
function MallModel:request_hot_sell_items(  )
	require "control/MallCC"
	MallCC:req_mall_sales_chart()
end

-- 申请限制产品
function MallModel:request_time_limit_item(  )
	require "control/MallCC"
	MallCC:req_bargain_list()
end

-- ================================
-- ================================
-- 极品套装处理

_can_get_present = false
_had_get_present = false

-- 保存极品套装状态
function MallModel:set_taozhuang_info( flag1, flag2 )
	_can_get_present = flag1
	_had_get_present = flag2
end

-- 获取极品套装状态
function MallModel:get_taozhuang_info(  )
	return _can_get_present, _had_get_present
end

-- 更新极品套装状态
function MallModel:update_taozhuang_info( flag1, flag2 )
	MallModel:set_taozhuang_info(flag1, flag2)
	MallModel:handle_taozhuang()
end

-- 玩家20级时才显示极品套装图标
function MallModel:handle_taozhuang(  )
	local player = EntityManager:get_player_avatar()
	local win = UIManager:find_window("right_top_panel")
	if player.level >= 20 then
		local can_get, had_get = MallModel:get_taozhuang_info()
		-- if not had_get then
		-- 	if win then
		-- 		win:insert_btn(11)
		-- 	end
		-- else
		-- 	if win then
		-- 		win:remove_btn(11)
		-- 	end
		-- end
		local jptzWin = UIManager:find_visible_window("jptz_dialog")
		if jptzWin then
			jptzWin:update( can_get, had_get )
		end
	end
end
-- -----------------------------------------------
-- ===============================================

-- 礼券优化

local _only_use_yuanbao = true
local _dont_ask_me_again = false
-- 
-- 如果商品可用元宝和礼券购买时，设置优先使用元宝还是礼券
-- @param flag true:只使用元宝购买，false:先使用礼券，礼券不足时再使用元宝
function MallModel:set_only_use_yb( flag )
	_only_use_yuanbao = flag
end

function MallModel:get_only_use_yb(  )
	return _only_use_yuanbao
end

-- 不再提示
function MallModel:set_dont_ask_me_again( flag )
	_dont_ask_me_again = flag
end

function MallModel:get_dont_ask_me_again(  )
	return _dont_ask_me_again
end

function MallModel:handle_auto_buy( price, do_something, param )
	local player = EntityManager:get_player_avatar()

	local function not_enough_yuanbao()
	    GlobalFunc:chong_zhi_enter_fun()
	end
	local function not_enough_bindYuanbao(  )
		if player.yuanbao < price then
			ConfirmWin2:show( 2, 2, "", not_enough_yuanbao)
			return
		end
	    if do_something then
	    	param[#param] = 3
			do_something(param)
		end
	end
	local function switch_fun( if_select )
	    MallModel:set_dont_ask_me_again( if_select )
	end
	local content = LangGameString[2376]

	if MallModel:get_only_use_yb() then
		if player.yuanbao < price then
	    	ConfirmWin2:show( 2, 2, "", not_enough_yuanbao)
	    	return
	    end
	    if do_something then
	    	do_something(param)
	    	return
	    end
	    return
	else
		-- 优先使用礼券，礼券不足时，提示使用元宝代替
		if player.bindYuanbao < price then
			if MallModel:get_dont_ask_me_again() == false then
	    		ConfirmWin2:show(5, nil, content, not_enough_bindYuanbao, switch_fun, nil)
	    	else
	   --  		if do_something then
	   --  			param[#param] = 3
				-- 	do_something(param)
				-- 	return
				-- end
				not_enough_bindYuanbao()
			end
		else
			if do_something then
				do_something(param)
				return
			end
		end
	end
end

function MallModel:checkExistItemInShop( itemID )
	local store_item = StoreConfig:get_store_info_by_id(item_id)
	return store_item and true or false
end

function MallModel:handle_shopping_1( item_id, item_count, do_something, param )
	-- if not item_id then
	-- 	return
	-- end

	local store_item = StoreConfig:get_store_info_by_id(item_id)
	if not store_item then
		return
	end
	-- if not store_item then
	-- 	if do_something then
	-- 		do_something(param)
	-- 	end
	-- 	return
	-- end

	-- if store_item.price[1].type ~= 5 then
	-- 	if do_something then
	-- 		do_something(param)
	-- 	end
	-- 	return
	-- end

	local price = store_item.price[1].price * item_count

	MallModel:handle_auto_buy( price, do_something, param )
end

function MallModel:handle_shopping_2( item_id_1, item_count_1, item_id_2, item_count_2, do_something, param )
	local store_item_1 = StoreConfig:get_store_info_by_id(item_id_1)
	local store_item_2 = StoreConfig:get_store_info_by_id(item_id_2)

	local price_1 = store_item_1.price[1].price * item_count_1
	local price_2 = store_item_2.price[1].price * item_count_2

	MallModel:handle_auto_buy(price_1+price_2, do_something, param)
end

-- 点击购买极品装备按钮
function MallModel:buy_jipinzhuangbei( item_id, category )
	item_id  = item_id or 18711;
	category = category or "hot";

	local player = EntityManager:get_player_avatar()
	local item_mall_info = StoreConfig:get_sell_info_by_cate_id( item_id, category )

	local item_price = item_mall_info.price[1].price;
	local price_type = item_mall_info.price[1].type;
	local item_tag   = item_mall_info.id;
	if type(item_price) == "number" and item_price > player.yuanbao then
        -- 玩家身上元宝不够,前往立即充值界面
        local function confirm2_func()
            print("打开充值界面")
            GlobalFunc:chong_zhi_enter_fun()
            UIManager:hide_window( "jptz_dialog" )
    	end
    	ConfirmWin2:show( 2, 2, "",  confirm2_func)
    else
    	-- 请求购买中级强化石
    	MallCC:req_buy_mall_item(item_tag, 1, 0, 3);
	end
end