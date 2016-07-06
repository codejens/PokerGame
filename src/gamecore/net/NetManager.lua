-- NetManager.lua 
-- created by aXing on 2012-11-22
-- edit by liubo on 2015-04-24
-- 网络管理器
-- 用于申请长连接，发送并接收数据包

-- super_class.NetManager()
NetManager = {}

local _address 	=nil --CCUserDefault:sharedUserDefault():getStringForKey("server_address")	-- 先默认地址测试
local _port 	=nil-- CCUserDefault:sharedUserDefault():getIntegerForKey("server_port")		-- 先默认端口测试
local _socket 	= nil								-- socket
local _state	= nil								-- socket状态{1:"login", 2:"game"}
local _name 	= nil								-- 账号名
local _password = nil								-- 密码
local _aid 		= 0									-- 游戏账号id
local _key 		= nil								-- 游戏服务器认证key
local _server_id= nil --CCUserDefault:sharedUserDefault():getIntegerForKey("server_id") 		-- 服务器id
local _init = false
local _pack_series = 0                              -- 服务器用的包序列号。 重复发送的包会被服务器忽略

function NetManager:init(  )
	local ver = "1.00.00"
	local sdcardpath = cc.FileUtils:getInstance():getWritablePath()
	local socketType = helpers.CCAppConfig:sharedAppConfig():getIntegerForKey("socket_type")


	local ret = helpers.ClientSocketProxy:InitSocket(socketType,ver,sdcardpath);
	if ret == 0 then
		_init = true
	end
	return 0
end

function NetManager:get_socket(  )
	return _socket
end

-- 断开连接游戏服务器
function NetManager:disconnect(  )
	_socket:Close()
end

-- 获取协议包（NetPacket是单例的），用来发送协议
-- sysid 系统号
-- pid   子系统号
function NetManager:get_NetPacket(sysid,pid)
	_pack_series = _pack_series + 1         -- 序列号递增
    local netPacket = _socket:alloc()	
    netPacket:writeInt( _pack_series ) 
	netPacket:writeByte(sysid)
	netPacket:writeByte(pid)
	return netPacket
end

-- 发送数据包
function NetManager:send_packet(pack)
	_socket:SendToSrv(pack)
end

-- 当登陆服务器返回游戏服务器的验证key后，便断开登陆服务器连接，转而连接游戏服务器
local function connect_game_server( pack )
	local result = pack:readByte()
	if result == 0 then
		_aid = pack:readInt()						-- 账号id
		local ip = pack:readString()				-- 服务器ip
		local port = pack:readInt()					-- 服务器端口
		local last_ip = pack:readString()			-- 上次登陆的ip地址
		_key = pack:readString()					-- 验证key
		_socket:Close()								-- 断开登陆服务器

		--连接游戏服务器
		_socket:SetHost(ip, port)
		local ret = _socket:ConnectSrv()
		_state = 2 									-- 改为游戏socket状态
		return ret
	else
		local err_t = {
			"您的密码有误",--1.密码错误
			"您的帐号有误",--2.没有这个账号
			"您已经在线",--3.已经在线
			"服务器繁忙",--4.服务器忙
			"服务器没有开放",--5.服务器没有开放
			"会话服务器繁忙",--6.session服务器有问题，比如db没有连接好
			"您请求的服务器不存在",--7.不存在这个服务器
			"您的帐户已纳入防沉迷",--8.账户纳入防沉迷
			--"您的帐户已被冻结",--9.用户是否被关闭，0否，1被关闭
			--"请求超时",--10.临时生成的key超时
		}
		if err_t[result] then
			local err_str = err_t[result] ..  "，【错误码：" .. result .. "】"
			print("login fail!error=:"..result.." ".. err_str)
		else
			print("recv unexcept error code in login resp, err="..result)
		end
		_socket:Close()
	end
end

-- 游戏正式开始的标志
local function start_game( pack )
	local result = pack:readByte()
	if result == 0 then --实际上只会收到0的情况
		RoleCC:login_server_success(  )
	else
		print("游戏服务器验证失败",result)
	end
end

--返回的数据包
--参数：数据包|系统id|函数id|大小
function NetManager.on_pack_recv( p, sysid, pid, size )
	--print("返回包============", p, sysid, pid, size )
	-- 每次接到服务器心跳，说明连接还在，就重置连接检查
	--GameStateManager:reset_connect_check_count(  )
	
	--local pack 	= helpers.NetPacket:ToNP(p) -- 由于pack里面本身就有数据，不是自己申请，所以不能进行写操作，只能进行读操作
	--local len = pack:getAvaliableBufLen()
	local pack = p
	local len = pack:getPacketSize()

	if sysid == 1 and pid == 0 then --(1, 0) 登陆服务器验证结果，带有游戏服务器的登陆key
		connect_game_server(pack)				
		return
	elseif sysid == 255 and pid == 1 then -- (255, 1) 游戏服务器验证结果，收到这个包之后，游戏正式开始
		start_game(pack)						
		return
	--else
		--KuaFuModel:set_is_kuafu_ing( false ) --收到协议表示跨服成功 NetManager.on_connect_success并不代表跨服成功
	end

	require "gamecore.net.PacketDispatcher"
	--下面是正常的解包过程
	PacketDispatcher:do_game_logic(sysid, pid, pack, size)
end

--socket连接的回调
--参数：返回码|数据包|系统id|函数id|大小
function NetManager.on_connect_success(  code,p, sysid, pid, size )
	-- print("socket连接的回调：",code,p, sysid, pid, size)
	if code == SocketDelegateProtocolScript.eOnCommuSucc then --连接成功
		if _state == 1 then --连接登录服务器成功
			--发协议(1)验证账号
			local np = _socket:alloc()
			np:writeInt( _pack_series )
			np:writeWord( 1 )
			np:writeString(_name)
			np:writeString(_password)
			np:writeInt(_server_id)
			_socket:SendToSrv(np)
		elseif _state == 2 then --连接游戏服务器成功
			--发协议(255,1)验证账号
			local np = NetManager:get_NetPacket(255,1)
			np:writeInt(_aid)
			np:writeString(_key)
			_socket:SendToSrv(np)
		end
	elseif code == SocketDelegateProtocolScript.eOnRecv then --返回包
		NetManager.on_pack_recv( p, sysid, pid, size )
	elseif code == SocketDelegateProtocolScript.eOnSocketError then --连接错误
		--socket连接失败
		print("socket连接失败")
	end
end

--连接游戏的登录服务器
--参数：账号|密码|服务器ip|服务器id|端口
function NetManager:connect( name, password, server_ip, server_id, port )
	if not _init then
		NetManager:init( )
	end

	--获得socket
	_socket = helpers.ClientSocketProxy:GetNetInstance()
	print("_socket=",_socket)
	--设置连接结果回调
	local XLambdaLua_cb =  luaFunToCFunc.convert( NetManager.on_connect_success )
	_socket:setCallback( XLambdaLua_cb )

	if _socket:connected() then
		print("当前已处于连接状态")
		return
	end
	
	_name	 	= name
	_password	= password
	_state		= 1
	_address    = server_ip --or CCUserDefault:sharedUserDefault():getStringForKey("server_address")
	_server_id  = server_id --or CCUserDefault:sharedUserDefault():getIntegerForKey("server_id")
	_port       = port --or 9001
	print("连接数据:",_name,",",_password,",",_address,",",_server_id,",",_port)
	
	--发送登陆服务器的ip和端口
	_socket:SetHost(_address, _port)

	--连接服务器
	local ret = _socket:ConnectSrv()

	return ret
end

--跨服连接
function NetManager:connect_kuafu(server_ip ,port)
	_socket	= helpers.ClientSocketProxy:GetNetInstance()			-- 获得socket
	if _socket:connected() then
		print("当前已处于连接状态")
		return
	end
	_socket:SetHost(server_ip, port)
	local ret = _socket:ConnectSrv()
	-- if ret == -1 then
	-- 	print("socke链接失败")
	-- 	GameStateManager:set_state("login")
	-- 	MUtils:toast("跨服失败,请重新登录",2048,5)
	-- end
	--RoleModel:land_server_result( ret )
end