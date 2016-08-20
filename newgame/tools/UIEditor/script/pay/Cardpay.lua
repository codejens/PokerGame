-- Cardpay.lua
-- created by aXing on 2013-6-15
-- 非银行卡支付

Cardpay = {}

Cardpay.CARD_JUNNET		= "JUNNET"		-- 骏网一卡通
Cardpay.CARD_SNDACARD	= "SNDACARD"	-- 盛大卡
Cardpay.CARD_SZX		= "SZX"			-- 神州行
Cardpay.CARD_ZHENGTU	= "ZHENGTU"		-- 征途卡
Cardpay.CARD_QQCARD		= "QQCARD"		-- Q币卡
Cardpay.CARD_UNICOM		= "UNICOM"		-- 联通卡
Cardpay.CARD_JIUYOU		= "JIUYOU"		-- 久游卡
Cardpay.CARD_YPCARD		= "YPCARD"		-- 易宝e卡通
Cardpay.CARD_NETEASE	= "NETEASE"		-- 网易卡
Cardpay.CARD_WANMEI		= "WANMEI"		-- 完美卡
Cardpay.CARD_SOHU		= "SOHU"		-- 搜狐卡
Cardpay.CARD_TELECOM	= "TELECOM"		-- 电信卡
Cardpay.CARD_ZONGYOU	= "ZONGYOU"		-- 纵游一卡通
Cardpay.CARD_TIANXIA	= "TIANXIA"		-- 天下一卡通
Cardpay.CARD_TIANHONG	= "TIANHONG"	-- 天宏一卡通

-- 发送非银行卡订单
-- @card_name	卡类型
-- @money		充值面额
-- @card_no 	卡号
-- @card_pwd	卡密
function Cardpay:pay( card_name, money, card_no, card_pwd )

	local login_info = RoleModel:get_login_info()
	local time_stamp = os.time()		-- 精确到秒
	-- login_info.user_name = "lyl003"
	-- login_info.server_id = 1
	-- local test_money = 1
	local platform	 = CCAppConfig:sharedAppConfig():getStringForKey('platform')
	-- 订单号
	local order = '&p2_Order=zx_yeepay_' .. platform .. '_' .. login_info.user_name .. "_" .. login_info.server_id .. "_" .. time_stamp

	-- 支付金额
	local amt = '&p3_Amt=' .. money

	-- 是否较验订单金额
	local verifyAmt	= '&p4_verifyAmt=true'

	-- 卡面额组
	local cardAmt = '&pa7_cardAmt=' .. money

	-- 卡号组
	local cardNo = '&pa8_cardNo=' .. card_no

	-- 卡密组
	local cardPwd = '&pa9_cardPwd=' .. card_pwd

	-- 支付通道
	local FrpId = '&pd_FrpId=' .. card_name

	local url = CCAppConfig:sharedAppConfig():getStringForKey('cardpay_url')
	local param = 'p0_Cmd=&p1_MerId=' .. order .. amt .. verifyAmt .. cardAmt .. cardNo .. cardPwd .. FrpId
	-- print("非银行卡url:", url, param)
	local function http_response( error, message )
		-- print("充值反馈:", error, message)
		if error == 0 then
			GlobalFunc:create_screen_notic(LangGameString[505]) -- [505]="充值申请提交完毕"
		end
	end
	local req = HttpRequest:new( url, param, http_response )
   	req:send()
end
