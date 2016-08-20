-- iOSChongZhiModel.lua
-- created by fangjiehua on 2013-10-10
-- ios IAP model
-- 处理游戏内购

iOSChongZhiModel = {}

iOSChongZhiModel.IOS_IAP_purchse_Call = nil;

local _is_click_purchase_btn = false

function iOSChongZhiModel:fini(  )

end

local _httpReconnectCount = 0    --当前重连了几次
local _httpReconnectMax = 2      --最大重连数
local _httpAutoReconnectCallbackTime_t = { 5, 3 }
local _httpAutoReconnectCallback = callback:new()
local _httpLastRequest = nil

--清空与设置
function setupHttpAutoReconnect(url, param, callback)
	if url == nil then
		_httpLastRequest = nil
		_httpAutoReconnectCallback:cancel()
	else
		_httpLastRequest = { url, param, callback }
	end
	_httpReconnectCount = 0
	_httpReconnectMax = 2
end
function doHttpAutoReconnect()
	local autoReconnect = _httpReconnectCount < _httpReconnectMax and _httpLastRequest
	
	if autoReconnect then
		_httpReconnectCount = _httpReconnectCount + 1
		local _httpAutoReconnectCallbackTime = _httpAutoReconnectCallbackTime_t[ _httpReconnectCount ] or 1
		_httpAutoReconnectCallback:cancel()
		_httpAutoReconnectCallback:start(_httpAutoReconnectCallbackTime,
			function(...)
				-- print('retry', _httpReconnectCount, _httpLastRequest[1], _httpLastRequest[2])
				local http_request = HttpRequest:new( _httpLastRequest[1], 
													  _httpLastRequest[2], 
													  _httpLastRequest[3])
				http_request:send()
			end)

        -- 设置解锁屏幕
        _lockScreenHandle = _lockScreenHandle + 1

		local h = 'ios_iap' .. tostring(_lockScreenHandle)
		MUtils:lockScreen(true,2048,'验证购买订单中，请稍后',5.0,h)

		local c = callback:new()
		c:start(5 + _httpAutoReconnectCallbackTime,  
			    function(...) 
					if MUtils:getLockHandle() == h then
						MUtils:lockScreen(false,2048,'验证失败，请重试',2) 
					end
				end )
		return true

	else
		setupHttpAutoReconnect()
	end

	return false
end


function iOSChongZhiModel:addObserver( error, json )
		
		-- require "utils/MUtils"		
		-- MUtils:toast_black('iOSChongZhiModel:addObserver',0xffffff,3)

		require "utils/Utils"
		local json_table = Utils:json2table( json )
		local state_code = json_table["error"];
		
		if state_code == 1 or state_code == 2 then

			GlobalFunc:create_screen_notic( "#cfff000未到账的元宝补发成功！请查收", 30, 960/2,480/2 )
			--[[
			-- 订单号，ps:现在已经取消掉orderid字段的意义 by 2013.12.14
			local orderId = state_code
			-- 用户id
			local uid = -1 
			local serid = -1
			
			-- 从苹果获得到的订单号
			local IAP_receipt = json_table["receipt"]

			local IAP_receipt_urlencode = Utils:urlencode(IAP_receipt)

			-- 向入口验证订单的地址
			-- reload("GameUrl")
			local url = "http://appStore.jl.shediao.com/ms/apple/pay.jsp"
			-- post数据段
			local param = "orderId="..orderId.."&payFee=0".."&uid="..uid.."&serverid="..serid.."&transactionReceipt="..IAP_receipt_urlencode

			-- 生成一个http请求
			require "net/HttpRequest"
			local function IOS_IAP_Verification_receipt( )
				-- body
			end 
			local http_request = HttpRequest:new( url, param, IOS_IAP_Verification_receipt )
			-- 发送请求
			http_request:send()

			IOSDispatcher:IAP_finish_transcation( )
			]]
		else
			-- 失败的消息
			print("IAP监听返回失败消息")
		end

end


function iOSChongZhiModel:purchase_product( product_index )
	-- 点击购买按钮
	_is_click_purchase_btn = true

	local productID 
	local fee 
	if product_index == 60 then
		-- productID = "jlProduct1"
		productID = "com.hoolai.tjxs.60"
		fee = 6
	elseif product_index == 300 then
		-- productID = "jlProduct2"
		productID = "com.hoolai.tjxs.300"
		fee = 30
	elseif product_index == 980 then
		-- productID = "jlProduct3"
		productID = "com.hoolai.tjxs.980"
		fee = 98
	elseif product_index == 1680 then
		-- productID = "jlProduct7"  
		productID = "com.hoolai.tjxs.1680"
		fee = 168
	elseif product_index == 3280 then
		productID = "com.hoolai.tjxs.3280"
		fee = 328
	elseif product_index == 6480 then
		productID = "com.hoolai.tjxs.6480"
		fee = 648
	end

	local function purchase_callback( error, json )
		
		local json_table = Utils:json2table( json )
		local state_code = json_table["error"];
		print("苹果返回购买元宝的状态",state_code)

		-- 状态1为付款中，状态2为已付款
		if state_code == 1 or state_code == 2 then
			GlobalFunc:create_screen_notic( "#cfff000购买成功", 30, 960/2,480/2 )
			-- 这个记录一个是否充值过的值，这个值可用于判断当前设备是否发生过充值。
			CCUserDefault:sharedUserDefault():setStringForKey('did_recharge',"1");
			
		else
			-- 购买失败
			GlobalFunc:create_screen_notic( "#cfff000购买失败,请稍后再试", 27, 960/2,480/2)

		end
		
	end

	ZXLog('-----------productID------------',productID)

	IOSDispatcher:IAP_purchase_product( productID, purchase_callback )

	GlobalFunc:create_screen_notic( "#cfff000正在购买,请稍候", 30, 960/2,480/2 )

end
