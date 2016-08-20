-- Alipay.lua
-- created by aXing on 2013-6-15
-- 支付宝支付渠道

Alipay = {}

-- 构造支付宝订单
local function get_alipay_order( money )
	-- 编号订单 (非空、64位字母、数字和下划线组成)
	-- (alipay/cards/credit)_account_serverid_unixtimestamp
	local login_info = RoleModel:get_login_info()
	local time_stamp = os.time()		-- 精确到秒
	-- login_info.user_name = "lyl003"
	-- login_info.server_id = 1
	local platform	 = CCAppConfig:sharedAppConfig():getStringForKey('platform')
	local out_trade_no = 'zx_alipay_' .. platform .. '_' .. login_info.user_name .. "_" .. login_info.server_id .. "_" .. time_stamp

	-- 商品名称
	local subject = LangGameString[503] -- [503]='xx'

	-- 商品具体描述
	local body = LangGameString[504] -- [504]='游戏元宝，在游戏内的一种货币，可以购买稀有道具。'

	-- 本次支付的总费用
	local total_fee = money

	local order = "out_trade_no=" .. out_trade_no .. "&subject=" .. subject .. "&body=" .. body .. "&total_fee=" .. total_fee
	-- print("alipay order is:" .. order)
	-- order = 'partner=2088701737703021&seller=huaihoolai@sina.cn&out_trade_no=alipay_mytest613_1_1371291011&subject=1234567890&body=abcdefghijklmnopqrstuvwxyz&total_fee=0.1&notify_url=http://119.254.95.50:81/AliSecurity/notify_url.php'
	return order
end

local function after_sign( err, message )
	if err == 0 then
		-- 签名成功
		print("支付宝验签回来的订单:", message)
		AlipayOrder(message)
	end
end


-- 支付宝支付
function Alipay:pay( money )
	local url 	= CCAppConfig:sharedAppConfig():getStringForKey('alipay_url')
	local order = get_alipay_order(money)
	local http_request = HttpRequest:new(url, order, after_sign)
	http_request:send()
end
