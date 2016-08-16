-- HttpResquest.lua
-- created by aXing on 2013-5-31
-- 封装引擎里面的HTTP申请
-- 该HTTP将会取用异步访问方式，等待时间3秒，(如果要修改等待时间，需要修改引擎)
-- 由于引擎里面的HTTP申请只限一条线程，所以如果同时有很多HTTP申请的话，则需要排序

HttpGetRequest = {}

-- http申请列表
local _request_list = {}
-- 当前申请的http url
local _current_request = nil

local Thread0 = 0
local Thread1 = 1
local Thread2 = 2
local Thread3 = 3

local MAX_THREAD = 4
-- 退出的时候要清空整个http申请列表
function fini_http_get_request( ... )
	--_request_list = {}
	--_current_request = nil
end

-- 构建一个http申请对象
function HttpGetRequest:new( ... )

	local i = {}
    setmetatable(i, self)
    self.__index = self
	i:__init( ... )
    return i

end

--构造函数，构造就立刻开始
function HttpGetRequest:__init( url, param, callback )
	self.url 		= url
	self.param		= param
	self.callback 	= callback
end

-- 用于检查是否还有http请求需要发送
local function _update_request(  )

	-- 访问回调
	local function _request_callback( error, message )
		if _current_request == nil then
			-- print ("http request error!")
			return
		end

		_current_request.callback(error, message)
		_current_request = nil
		
		_update_request()
	end

	if _current_request == nil and #_request_list ~= 0 then
		local req = table.remove(_request_list)
		_current_request = req
		--print(req, req.url)
		RequestGetHttpAsync(req.url, _request_callback,Thread0)
		
	end
end

-- 发送http请求，使用线程0，排队执行
function HttpGetRequest:send(  )
	table.insert(_request_list, self)
	_update_request()
end


--使用线程1即时发送http请求
function HttpGetRequest:sendReq()
	--print('Http send[2] GET:url:', self.url)
	local e = RequestGetHttpAsync(self.url, self.callback ,Thread1)
	if e == 0 then
		--print('waiting for thread1 to finish')
	end
	return e
end