local _chk_interval = 30
local _req_timer_interval = 1
local _req_callback_timeout = 10
local os_time = os.time

ConnectionChecker = {}

function ConnectionChecker:init()
	self._last_chk_time = 0
	self._online_flag = true
	self:cleanup()
	self._request_online_timer = timer() 
	self._timeout_callback = callback:new()
end

function ConnectionChecker:fini()
	self._last_chk_time = 0
	self._online_flag = true
	self:cleanup()
end

function ConnectionChecker:tick()
	--每隔一段时间检查一遍是否在线
    if (os_time() - self._last_chk_time ) > _chk_interval and self._online_flag then
    	print('ConnectionChecker:tick()')
    	self:request_check_online()
        self._last_chk_time = os_time()
    end
end

function ConnectionChecker:cleanup()
	--print("ConnectionChecker:cleanup", os_time())
	if self._request_online_timer then
		self._request_online_timer:stop()
	end
	if self._timeout_callback then
		self._timeout_callback:cancel()
	end
end

function ConnectionChecker:request_check_online()
	local state = GameStateManager:get_state()
	if state == 'scene' then
		print("ConnectionChecker:request_check_online 发送协议检查连接... 1", os_time())
		self._online_flag = false                       
	    MiscCC:request_check_self_online()
	    
	    self:cleanup()
	    -- 1秒钟后，如果还没有收到服务器恢复,尝试重发协议
	    local function retry_func(  )
	        
	    	if not self._online_flag then
	    		print("ConnectionChecker:request_check_online 【try】", os_time(), self._online_flag)
	            MiscCC:request_check_self_online()
	    	else
	    		print("ConnectionChecker:request_check_online 【ok 0】", os_time(), self._online_flag)
	    		self:cleanup()
	    	end
	    end
	    self._request_online_timer:start( _req_timer_interval, retry_func )  

	    --10秒后判断是否重服务器断开连接
	    
	    local function timeout_func(  )
	        self:cleanup()
	    	if not self._online_flag then
	    		--断开连接了
	    		 print("ConnectionChecker:request_check_online 【timeout】", os_time(), self._online_flag)
	            AppMessages:close_connect_message()
	    	else
	    		 print("ConnectionChecker:request_check_online 【ok 1】", os_time(), self._online_flag)
	    	end
	    end
	    self._timeout_callback:start(_req_callback_timeout,timeout_func)   
	end
end

function ConnectionChecker:setIsOnline()
	--if not self._online_flag then
		--print('ConnectionChecker:setIsOnline',flag)
	if not self._online_flag then
		print('ConnectionChecker:setIsOnline 【ok】')
		self:cleanup()
	end
	self._online_flag = true
	self._last_chk_time = os_time()
	
	--end
end

