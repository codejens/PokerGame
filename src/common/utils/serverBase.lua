serverBase = simple_class()
local socket = require("socket")
local READ_PACKET_HEAD = 'H(%d+)H'
local WRITE_PACKET_HEAD = 'H%dH\n'

function serverBase:__init()

end

function serverBase:start(host,port)
	local host = host or "*"
	local port = port or 8080
	print("Binding to host '" ..host.. "' and port " ..port.. "...")
	local s = assert(socket.bind(host, port))
	local i, p   = s:getsockname()
	assert(i, p)
	s:settimeout(0.01)
	self._server = s
	self._clients = {}
	self._client_accept_timer = timer:create()
	self._client_accept_timer:start(0.5, function()
		local c = s:accept()
		if c then
			self._clients[c] = true
			c:settimeout(0.01)
			self:sendOne(c,'connect to cocos serverBase')
			print('[serverBase] client getpeername', c:getpeername())
		end
	end)

	self._clients_receive_timer = timer:create()
	self._clients_receive_timer:start(0.0, function()
		for client, dummy in pairs(self._clients) do
			local l, e = client:receive()
			if l then
				local size = string.match(l,READ_PACKET_HEAD)
	
				if size then
					l, e = client:receive(size)
				end

				if l then
					print('[serverBase] client receive',l)
					local s,e = pcall(function() loadstring(l)() end)
					if not s then
						print('[serverBase] client execute', e)
					end
				elseif e ~= 'timeout' then
					self._clients[client] = nil
					print('[serverBase] client error', e)
				end

			elseif e ~= 'timeout' then
				self._clients[client] = nil
				print('[serverBase] client recv error', e)
			end
		end
	end)
end

function serverBase:send(cmd)
	for client, dummy in pairs(self._clients) do
		if client then
			local ret = self:sendOne(client,msg)
			if not ret then
				self._clients[client] = nil
			end
		end
	end
end

function serverBase:sendOne(client, cmd )
	-- body
	local i,e = client:send(string.format(WRITE_PACKET_HEAD,string.len(cmd)))
	if i then
		client:send(cmd)
		print('serverBase:send',cmd)
		return true
	elseif e ~= 'timeout' then
		print('[serverBase] client send error', e)			
		return false	
	end
end