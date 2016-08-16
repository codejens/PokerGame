-- NetManager.lua 
-- created by aXing on 2012-11-22
-- 网络管理器
-- 用于申请长连接，发送并接收数据包

-- super_class.NetManager()



SOCKETTYPE = {
	eCSOCKET  = 0,
	eTSOCKET  = 1
}

MNA_MOBILE_ISP = 
{
	E_MNA_MOBILE_UNKNOWN			= 0,
	E_MNA_MOBILE_TELCOM				= 1,
	E_MNA_MOBILE_UNICOM				= 2,
	E_MNA_MOBILE_CHINAMOBILE		= 4,
}

MNA_NETTYPE =
{
	NETWORK_TYPE_UNCONNECTED		=-1,
	E_MNA_NETTYPE_UNKNOWN			= 0,
	E_MNA_NETTYPE_WIFI				= 1,
	E_MNA_NETTYPE_2G				= 2,
	E_MNA_NETTYPE_3G				= 3,
	E_MNA_NETTYPE_4G				= 4,
}

MNA_ERRCODE = 
{
	E_MNA_ERR_NOT_INIT 				= -100,
	E_MNA_ERR_INIT_PATH_ERROR		= -99,	
	E_MNA_ERR_PARA_ERROR			= -98,	
	E_MNA_ERR_CONNECT_TIMEOUT		= -97,
	E_MNA_ERR_CREATE_SOCKET			= -96,
	E_MNA_ERR_CONNECT_ERROR			= -95,
	E_MNA_ERR_DNS_ERROR				= -94,	
};

NET_WORK_STATE =
{
	['WIFI'] =   	   MNA_NETTYPE.E_MNA_NETTYPE_WIFI,
	['1xRTT'] =  	   MNA_NETTYPE.E_MNA_NETTYPE_2G,
	['CDMA'] =   	   MNA_NETTYPE.E_MNA_NETTYPE_2G,
	['EDGE'] =   	   MNA_NETTYPE.E_MNA_NETTYPE_2G,
	['EVDO_0'] = 	   MNA_NETTYPE.E_MNA_NETTYPE_3G,
	['EVDO_A'] = 	   MNA_NETTYPE.E_MNA_NETTYPE_3G,
	['GPRS'] =   	   MNA_NETTYPE.E_MNA_NETTYPE_2G,
	['HSDPA'] =  	   MNA_NETTYPE.E_MNA_NETTYPE_3G,
	['HSPA'] =   	   MNA_NETTYPE.E_MNA_NETTYPE_3G,
	['HSUPA'] =  	   MNA_NETTYPE.E_MNA_NETTYPE_3G,
	['UMTS'] =   	   MNA_NETTYPE.E_MNA_NETTYPE_3G,
	['IDEN'] =   	   MNA_NETTYPE.E_MNA_NETTYPE_3G,
	['EHRPD'] =		   MNA_NETTYPE.E_MNA_NETTYPE_3G,
	['EVDO_B'] = 	   MNA_NETTYPE.E_MNA_NETTYPE_3G,
	['HSPAP']  = 	   MNA_NETTYPE.E_MNA_NETTYPE_3G,
	['LTE']	   =	   MNA_NETTYPE.E_MNA_NETTYPE_3G,
	['UNKNOWN']= 	   MNA_NETTYPE.E_MNA_NETTYPE_UNKNOWN,
	['CANNOT_DETECT']= MNA_NETTYPE.E_MNA_NETTYPE_UNKNOWN,
	['SIMULATOR']    = MNA_NETTYPE.E_MNA_NETTYPE_UNKNOWN,
};

NET_ISP =
{
	[''] 				= MNA_MOBILE_ISP.E_MNA_MOBILE_UNKNOWN,
	
	['China Unicom']	= MNA_MOBILE_ISP.E_MNA_MOBILE_UNICOM,
	[LangGameString[475]]		= MNA_MOBILE_ISP.E_MNA_MOBILE_UNICOM, -- [475]='中国联通'

	['China Telcom']	= MNA_MOBILE_ISP.E_MNA_MOBILE_TELCOM,
	['ctnet']			= MNA_MOBILE_ISP.E_MNA_MOBILE_TELCOM,
	[LangGameString[476]]		= MNA_MOBILE_ISP.E_MNA_MOBILE_TELCOM, -- [476]='中国电信'

	['China Mobile']	= MNA_MOBILE_ISP.E_MNA_MOBILE_CHINAMOBILE,
	[LangGameString[477]]		= MNA_MOBILE_ISP.E_MNA_MOBILE_CHINAMOBILE, -- [477]='中国移动'

}

NET_STATE_STR =
{
	[MNA_NETTYPE.E_MNA_NETTYPE_UNKNOWN] = LangGameString[478], -- [478]='未知'
	[MNA_NETTYPE.E_MNA_NETTYPE_WIFI]    = 'WIFI',
	[MNA_NETTYPE.E_MNA_NETTYPE_2G] 		= '2G',
	[MNA_NETTYPE.E_MNA_NETTYPE_3G] 		= '3G',
	[MNA_NETTYPE.E_MNA_NETTYPE_4G] 		= '4G'
}

NET_ISP_STR = 
{
	[MNA_MOBILE_ISP.E_MNA_MOBILE_UNKNOWN] 		= LangGameString[478], -- [478]='未知'
	[MNA_MOBILE_ISP.E_MNA_MOBILE_UNICOM]    	= LangGameString[475], -- [475]='中国联通'
	[MNA_MOBILE_ISP.E_MNA_MOBILE_TELCOM] 		= LangGameString[476], -- [476]='中国电信'
	[MNA_MOBILE_ISP.E_MNA_MOBILE_CHINAMOBILE] 	= LangGameString[477] -- [477]='中国移动'
}


NET_STATE_REPORT_STR =
{
	[MNA_NETTYPE.E_MNA_NETTYPE_UNKNOWN] = 'UNKNOWN',
	[MNA_NETTYPE.E_MNA_NETTYPE_WIFI]    = 'WIFI',
	[MNA_NETTYPE.E_MNA_NETTYPE_2G] 		= '2G',
	[MNA_NETTYPE.E_MNA_NETTYPE_3G] 		= '3G',
	[MNA_NETTYPE.E_MNA_NETTYPE_4G] 		= '4G'
}

NET_ISP_REPORT_STR = 
{
	[MNA_MOBILE_ISP.E_MNA_MOBILE_UNKNOWN] 		= 'UNKNOWN',
	[MNA_MOBILE_ISP.E_MNA_MOBILE_UNICOM]    	= 'UNICOM',
	[MNA_MOBILE_ISP.E_MNA_MOBILE_TELCOM] 		= 'TELCOM',
	[MNA_MOBILE_ISP.E_MNA_MOBILE_CHINAMOBILE] 	= 'CHINAMOBILE'
}



local DialogDepth = 1024

local STRING_OK 	  = 	LangGameString[479] -- [479]='确认'
local STRING_CONTINUE = 	LangGameString[480] -- [480]='继续'
local STRING_RETRY    = 	LangGameString[481] -- [481]='重试'
local STRING_CANCEL   = 	LangGameString[482] -- [482]='取消'
local STRING_QUIT     = 	LangGameString[483] -- [483]='退出'
local STRING_FIX      = 	LangGameString[484] -- [484]='修复'
local STRING_SOCKETINT= { LangGameString[485],  -- [485]='#c4d2308无法初始化网络模块'
						  LangGameString[486],  -- [486]='#c4d2308请尝试重启游戏'
						  LangGameString[487]} -- [487]='#c4d2308如无法解决请重新安装游戏'

local STRING_NO_NETWORK1 = 	LangGameString[488] -- [488]='#c4d2308无法连接到网络或信号弱'
local STRING_NO_NETWORK2 =  LangGameString[489] -- [489]='#c4d2308请开启网络连接'

local STRING_NO_NETWORK = 	{ STRING_NO_NETWORK1, STRING_NO_NETWORK2 }

local _address 	= CCUserDefault:sharedUserDefault():getStringForKey("server_address")	-- 先默认地址测试
local _port 	= CCUserDefault:sharedUserDefault():getIntegerForKey("server_port")		-- 先默认端口测试
local _socket 	= nil								-- socket
local _state	= nil								-- socket状态{1:"login", 2:"game"}
local _name 	= nil								-- 账号名
local _password = nil								-- 密码
local _aid 		= 0									-- 游戏账号id
local _key 		= nil								-- 游戏服务器认证key
local _server_id= CCUserDefault:sharedUserDefault():getIntegerForKey("server_id") 		-- 服务器id
local _init     = false

local _try_to_reconnect = false;	-- 记录每次的connent行为是不是属于重连接，如果是重连接的话，需要给被fini的rolemodel重新填充数据（从NetManager拿userid和serverid）。gzn add 2015/1/6

local _isWifi   = nil
local _net_type = -1

NetManager = {}

function NetManager:get_socket(  )
	return _socket
end

function NetManager:init()
	local ver = phone_getSDKReleaseVersion()
	local sdcardpath = CCFileUtils:getWriteablePath()
	local socketType = CCAppConfig:sharedAppConfig():getIntegerForKey("socket_type")

	-- ZXLog('ClientSocketProxy:InitSocket',socketType, ver, sdcardpath)

	local ret = ClientSocketProxy:InitSocket(socketType,ver,sdcardpath);
	if ret == 0 then
		_init = true
	end
	-- ZXLog('ClientSocketProxy:InitSocket ret',ret)
	self._isReconnecting = false

	return 0
end

-- 连接游戏服务器
function NetManager:connect( name, password, server_ip, server_id, port , reconnecting )
	--是否重连中
	self._isReconnecting = reconnecting

	self.connect_params = { name, password, server_ip, server_id, port }

	-- ZXLog('connecting to server')
	if _init == false then
		local errcode = NetManager:init() 
		if errcode ~= 0 then
			local msg = {}
			for i,v in ipairs(STRING_SOCKETINT) do
				msg[#msg+1] = v
			end
			msg[#msg+1] = '[' .. tostring(errcode) .. ']'

			local _root =  ZXLogicScene:sharedScene():getUINode()
			PopupNotify( _root,
				 DialogDepth, msg,
				 STRING_QUIT,nil,
				 POPUP_OK,
				 function() ZXGameQuit() end)

			MUtils:lockScreen(false,2048)
			return
		end
	end

	local nNetType = SystemInfo.getNetworkType()--NET_WORK_STATE[netTypeRet] or MNA_NETTYPE.E_MNA_NETTYPE_UNKNOWN
	
	if nNetType == MNA_NETTYPE.NETWORK_TYPE_UNCONNECTED then
		if AssetsManager:gotNetwork() then
			local _root =  ZXLogicScene:sharedScene():getUINode()
			PopupNotify(_root,
						DialogDepth, STRING_NO_NETWORK ,
			 			STRING_RETRY,STRING_QUIT,POPUP_YES_NO,
						function(state)
						  	if state then
						  		NetManager:connect( name, password, server_ip, server_id, port )
						  	else
						  		ZXGameQuit()
						  	end
						end)

			MUtils:lockScreen(false,2048)
			return
		end
			
	end

--	print ("NetManager:connect   " .. name .. "   " .. password, server_ip, server_id, port );
	-- 这里获得了账号名和密码
	_socket		= ClientSocketProxy:GetNetInstance()			-- 获得socket
	if _socket:connected() then
		NetManager:disconnect()
	end
	_name	 	= name 									-- 账号
	_password	= password 								-- 密码
	_state		= 1										-- 改为登录socket状态
	_address    = server_ip or CCUserDefault:sharedUserDefault():getStringForKey("server_address")
	_server_id  = server_id or CCUserDefault:sharedUserDefault():getIntegerForKey("server_id")
	_port       = port or 9001
	-- 第一步先连接到登录服务器
	-- 发送登录服务器的address和port
	--print( "_socket:SetParams", _socket:connected() )

	local nISP 	   = SystemInfo.getSP() --MNA_MOBILE_ISP.E_MNA_MOBILE_UNKNOWN
	local nTimeout = 30
	local bSendTGW = true

	--local NetworkOperator = phone_getNetworkOperator() or 0
	--local NetworkOperatorName = phone_getNetworkOperatorName() or 'SIMULATOR'
	--_socket:SetOSVersion("")

	--bSendTGW = false
	

	-- --print('------------------------------------------')
	-- --print('nNetType',nNetType)
	-- --print('nISP',nISP)
	-- --print('netTypeRet',netTypeRet)
	-- --print('NetworkOperator',NetworkOperator)
	-- --print('NetworkOperatorName',NetworkOperatorName)
	-- --print('------------------------------------------')
	if GetPlatform() == CC_PLATFORM_ANDROID then
		local sNET = NET_STATE_STR[nNetType] or 'UNKNOWN'
		local sISP = NET_ISP_STR[nISP] or 'UNKNOWN'
		local tipsmsg = string.format(LangGameString[490],sNET,sISP) -- [490]='检测到网络状态[%s],网络供应商[%s]'

		MUtils:toast_black(tipsmsg ,500000,3,true)
	end

	self.strNetType   = NET_STATE_REPORT_STR[nNetType] or 'UNKNOWN'
	self.strISP 	  = NET_ISP_REPORT_STR[nISP] or 'UNKNOWN'
	
	if nNetType == 4 then
		nNetType = 3
	end
	_socket:SetParams(nNetType,nISP,nTimeout,bSendTGW)

	_socket:SetHost(_address, _port)
	--显示安卓进度条
	-- if phone_showProgress then
	-- 	phone_showProgress(LangGameString[491],LangGameString[492],true,false) -- [491]='请稍候' -- [492]='努力连接服务器中'
	-- end

	local socketConnectTime = os.clock()
	
	local ret = _socket:ConnectSrv()
	--print( "_socket:ConnectSrv", _address,_port, _socket:connected(), ret)
	if not reconnecting then
		RoleModel:land_server_result( ret )
	end
	--如果连接时间超过一秒，直接关闭安卓进度条
	if phone_hideProgress then
		local show = 1.0
		if os.clock() - socketConnectTime > 1.0 then
			phone_hideProgress()
		else
			MUtils.delay_phone_hideProgress(1.0)
		end
	end
	return ret
end

-- 断开连接游戏服务器
function NetManager:disconnect(  )
	-- ZXLog('disconnect from server')
	_socket:Close()
end

-- 当登录服务器返回游戏服务器的验证key后，便断开登录服务器连接，转而连接游戏服务器
local function connect_game_server( pack )
	local result = pack:readByte()

	if result == 0 then
		_aid 	= pack:readInt()					-- 账号id
		local ip = pack:readString()				-- 服务器ip
		local port = pack:readInt()					-- 服务器端口
		local last_ip = pack:readString()			-- 上次登录的ip地址
		_key 	= pack:readString()					-- 验证key
		_socket:Close()								-- 断开登录服务器

		-- 连接游戏服务器
		_socket:SetHost(ip, port)
		local ret = _socket:ConnectSrv()
		_state = 2 									-- 改为游戏socket状态
		return ret
	else
		local err_t = {
			LangGameString[493], -- [493]="操作成功1"
			LangGameString[494], -- [494]="密码错误"
			LangGameString[495], -- [495]="账号无法登录，请及时联系GM"
			LangGameString[496], -- [496]="已经在线"
			LangGameString[497], -- [497]="服务器忙"
			LangGameString[498], -- [498]="服务器没有开放 "
			LangGameString[499], -- [499]="session服务器有问题，比如db没有连接好"
			LangGameString[500], -- [500]="不存在这个服务器"
			LangGameString[501], -- [501]="账户纳入防沉迷"
		}
		local err_str = err_t[result + 1]
		if err_str ~= nil then
			--print("login fail!error=:"..result.." ".. err_str)
		else
			err_str = "recv unexcept error code in login resp, err="..tostring(result)
			--print(err_str)
			
		end
		RoleModel:show_notice( err_str )
		_socket:Close()
		NetManager:do_lost_connect()
	end
end 

-- 游戏正式开始的标志
local net_reconnect_callback = callback:new()
local function start_game( pack )
	local result = pack:readByte()
	--print('run start_game', result)
	-- 0、成功  1、密码错误 2、没有这个账号  3、已经在线。须一秒后重新登录  4、服务器忙  
	-- 5、session服务器有问题  6、不存在这个服务器  7、账户纳入防沉迷
	if result == 0 then
		
		--登录服务器成功，返给RoleModel处理逻辑
		require "model/RoleModel"
		RoleModel:did_login_success(  )

	elseif result == 3 then
        -- 如果已经在线，一秒后重新发送登录信息
        local function time_callback( )
        	-- CCScheduler:sharedScheduler():unscheduleScriptEntry(  )
        	
        	-- NetManager:disconnect( )
        	----HJH 2014-2-27 modify begin
        	---old
        	NetManager:reconnectSocket()
        	---new
        	-- NetManager:disconnect()
        	-- RoleModel:show_notice( "您的账号已经登录或者没有正常退出。请重试!" )
        	---HJH 2014-2-27 modify end
		    -- NetManager:connect( _name, _password, _address, _server_id )

	    end
	    net_reconnect_callback:start(2, time_callback)
        return 
	else
		local err_t = {
			Lang.net_massage[1], -- [502]="操作成功"
			Lang.net_massage[2], -- [494]="密码错误"
			Lang.net_massage[3], -- [495]="账号无法登录，请及时联系GM"
			Lang.net_massage[4], -- [496]="已经在线"
			Lang.net_massage[5], -- [497]="服务器忙"
			Lang.net_massage[6], -- [498]="服务器没有开放 "
			Lang.net_massage[7], -- [499]="session服务器有问题，比如db没有连接好"
			Lang.net_massage[8], -- [500]="不存在这个服务器"
			Lang.net_massage[9], -- [501]="账户纳入防沉迷"
			-- 按成进要求，补充两种错误情况描述 add by gzn
			Lang.net_massage[10],-- [10] = "该用户帐号已经被关闭，详情请联系GM",
			Lang.net_massage[11],-- [11] = "生成的临时会话key超时",
		}
		local err_str = err_t[result + 1]
		if err_str ~= nil then
			--print("login fail!error=:"..result.." ".. err_str)
		else
			err_str = "recv unexcept error code in login resp, err="..tostring(result)
		end
		RoleModel:show_notice( err_str )
		_socket:Close()
		MUtils:lockScreen(false,2048)
		NetManager:do_lost_connect()
	end
end 

-- socket连接成功后的调用
function NetManager.on_connect_success( cs )
	local client_socket = ClientSocketProxy:ToCS(cs)
	local np = client_socket:alloc()			-- 自己申请的pack，可以进行写操作
	local cur_ver = CCVersionConfig:sharedVersionConfig():getStringForKey("current_version")
	-- --print("NetManager.on_connect_success cur_ver=",cur_ver)
	np:writeByte(255)
	np:writeByte(1)
	np:writeInt(_server_id)						-- 默认一服
	np:writeString(_name)
	np:writeString(_password)
	-- np:writeString(cur_ver)
	client_socket:SendToSrv(np)					-- 用账号和密码申请游戏服务器的验证号

	-- 可以访问clientsocket的函数了
	-- 当收到连接成功的信息后，如果是连接登录服务器，则发送客户端登录的协议
	-- if _state == 1 then
		
	-- elseif _state == 2 then
	-- 	-- local np = client_socket:alloc()
	-- 	-- np:writeByte(255)
	-- 	-- np:writeByte(1)
	-- 	-- np:writeInt(_aid)
	-- 	-- np:writeString(_key)
	-- 	-- client_socket:SendToSrv(np)					-- 用验证号登录游戏服务器
	-- end
end


-- 网络层传来数据包
-- 第一个参数是package， 第二个参数是system id， 第三个参数是function id，第四个参数是这个包的大小
function NetManager.on_pack_recv( p, sysid, pid, size )
	
	local s = ZXLuaUtils:GetTickCounts()
	-- 每次接到服务器心跳，说明连接还在，就重置连接检查
	GameStateManager:reset_connect_check_count(  )
	
	local pack 	= NetPacket:ToNP(p)				-- 由于pack里面本身就有数据，不是自己申请，所以不能进行写操作，只能进行读操作
--	local len = pack:getAvaliableBufLen()
	-- --print("game net package", sysid, pid, pack)

	if sysid == 1 and pid == 0 then
		connect_game_server(pack)				-- (1, 0) 认为是登录服务器的返回包，带有游戏服务器的登录key
		return
	elseif sysid == 255 and pid == 1 then
		start_game(pack)						-- (255, 1) 收到这个包之后，游戏正式开始
		return
	end

	require "net/PacketDispatcher"

	-- --print("接包。。。。。。。。。。。begin", p, sysid, pid, size ,pack)


	-- 下面是正常的解包过程
	PacketDispatcher:do_game_logic(sysid, pid, pack, size)
	----print("接包。。。。。。。。。。。finish", p, sysid, pid, size )
	local e = ZXLuaUtils:GetTickCounts()
	luaPerformance:add_performance(string.format("%d->%d解包消耗时间",sysid,pid),e-s)
end

function NetManager:reconnectSocket()
	NetManager:disconnect()
	_try_to_reconnect = true
	local p = self.connect_params
	local ret = NetManager:connect(p[1],p[2],p[3],p[4],p[5],true)
	if ret == 0 then
		MUtils:toast('重新连接服务器中',0xffffff,8)
	else
		_try_to_reconnect = false
		MUtils:toast('返回登录界面',0xffffff,8)
		self:do_lost_connect()
	end
end

function NetManager:do_lost_connect()
	-- body
	if GameStateManager:get_state() == 'scene' then
		GameStateManager:do_lost_connect()
	end
end

-- 客户端模拟服务器功能
function NetManager.SendToDummyServer( pack )
	-- pack = NetPacket:ToNP(pack)
	pack:setPosition(0)
	local sysid = pack:readByte()
	local pid   = pack:readByte()
	NetManager.on_dummy_pack_recv( pack, sysid, pid )
end

function NetManager.SendToClient(pack)
	-- pack = NetPacket:ToNP(pack)
	pack:setPosition(0)
	local sysid = pack:readByte()
	local pid   = pack:readByte()
	NetManager.on_pack_recv(pack, sysid, pid)
end

-- 模拟出一个假服务器,来接受数据包
function NetManager.on_dummy_pack_recv( pack, sysid, pid )
	require "net/SerPacketDispatcher"
	SerPacketDispatcher:do_game_logic(sysid, pid, pack)
end

function NetManager:get_try_to_reconnect_state()
	return _try_to_reconnect;
end

function NetManager:set_try_to_reconnect_state(state)
	_try_to_reconnect = state
end

function NetManager:get_connect_user_name()
	if self.connect_params == nil then
		return nil;
	end
	return self.connect_params[1];
end

function NetManager:get_connect_server_id()
	if self.connect_params == nil then
		return nil;
	end
	return self.connect_params[4];
end

--网络连接发生变化
function NetManager:net_type_change(net_type)
	_net_type = net_type
	_isWifi = false
	if tonumber(net_type) == MNA_NETTYPE.E_MNA_NETTYPE_WIFI then
		_isWifi = true
	end
	if UIManager then
		local win = UIManager:find_visible_window("menus_panel")
	    if win then
	    	win:update_net_type(_net_type)
	    end
	end
end

function NetManager:get_is_wifi()
	if _isWifi == nil then
		local net_type = phone_tx_getNetworkType()
		self:net_type_change(net_type)
	end
	return _isWifi
end
