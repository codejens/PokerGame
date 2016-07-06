-- HttpResquest.lua
-- created by aXing on 2013-5-31
-- 封装引擎里面的HTTP申请
-- 该HTTP将会取用异步访问方式，等待时间3秒，(如果要修改等待时间，需要修改引擎)
-- 由于引擎里面的HTTP申请只限一条线程，所以如果同时有很多HTTP申请的话，则需要排序

HttpRequest = {}

-- http申请列表
local _request_list = {}
-- 当前申请的http url
local _current_request = nil

local _req_handle = 1

local Thread0 		= 0     --BI 线程 --其他通用线程

local MAX_THREAD 	= 8		--最多同时跑8个post线程

--请求方式
HttpRequest.TYPE_POST = "POST"
HttpRequest.TYPE_GET = "GET"

--请求成功返回码
local SucceedCode = 0
-- responseType 数据返回类型  暂时只实现返回json格式
-- cc.XMLHTTPREQUEST_RESPONSE_STRING = 0  -- 返回字符串类型
-- cc.XMLHTTPREQUEST_RESPONSE_ARRAY_BUFFER = 1 -- 返回字节数组类型
-- cc.XMLHTTPREQUEST_RESPONSE_BLOB   = 2 -- 返回二进制大对象类型
-- cc.XMLHTTPREQUEST_RESPONSE_DOCUMENT = 3 -- 返回文档对象类型
-- cc.XMLHTTPREQUEST_RESPONSE_JSON = 4 -- 返回JSON数据类型


-- 退出的时候要清空整个http申请列表
function fini_http_request( ... )
	--_request_list = {}
	--_current_request = nil
end

-- 构建一个http申请对象
function HttpRequest:new( ... )
	local i = {}
    setmetatable(i, self)
    self.__index = self
	i:__init( ... )
    return i
end

--构造函数，构造就立刻开始

--blocked = 是否有一个阻塞式的请求在等待返回，
function HttpRequest:__init( url, param, callback, blocked,type )

	self.url 		= url
	self.param		= param
	self.callback 	= callback
	self.type = type
	if not self.type or self.type == "" then
		self.type = HttpRequest.TYPE_POST 
	end

end

-- 用于检查是否还有http请求需要发送
local function _update_request()

	-- 访问回调
	local function _request_callback( error, message )

		if _current_request == nil then
	
			return
		end
	
		local c_req = _current_request
		_current_request = nil
		c_req.callback(error, message)
		_update_request()
	end

	if _current_request == nil and #_request_list ~= 0 then
		local req = table.remove(_request_list)
		_current_request = req
		--print('Http POST:url:', req.url)
		--print('Http POST:param', req.param)
	
	    local xhr = cc.XMLHttpRequest:new()
        xhr.responseType = cc.XMLHTTPREQUEST_RESPONSE_STRING
        local url = req.url.."?"..req.param
        xhr:open(req.type, url)

        local function onReadyStateChange()
        	local message = ""
        	local errorCode = ""
            if xhr.readyState == 4 and (xhr.status >= 200 and xhr.status < 207) then
                local statusString = "Http Status Code:"..xhr.statusText
                    local response   = xhr.response
                    message = response--json.decode(response,1)
                    errorCode = SucceedCode
                    print("headers are")
                  
            else
            	message = xhr.status
            	errorCode = xhr.readyState
                print("xhr.readyState is:", xhr.readyState, "xhr.status is: ",xhr.status)
            end
            _request_callback(errorCode,message)
        end

        xhr:registerScriptHandler(onReadyStateChange)
        xhr:send()

	end



end

-- 发送http请求，使用线程0，排队执行
function HttpRequest:send()
	table.insert(_request_list, self)
	_update_request()
end


function HttpRequest:busy()
	return _current_request ~= nil 
end

function HttpRequest:isWaitingBlockRequest()
	return _blocking_request ~= nil
end