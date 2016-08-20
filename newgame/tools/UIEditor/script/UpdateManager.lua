-- Update.lua
-- created by aXing on 2013-4-16
--热更管理器
-- 这个是用于更新资源和脚本的更新器
-- 它将会在整个游戏运行之前运行，并确认是否需要更新到最新的资源再进行游戏

require 'UI/update/PopupNotify'
require 'utils/binder'

--require 'CommonConfig'
UpdateManager = { NOPlatform_server_url = '' }

local __assetsmgr = AssetsManager:sharedManager()

local _root = nil                        -- 显示的根结点

local KEY_OF_VERSION				= "current_version"
local KEY_OF_DOWNLOADED_VERSION		= "downloaded-version-code"
local KEY_OF_DOWNLOADED_SIZE		= "downloaded-size"
local KEY_OF_ENGINE_CODE 			= "engine_code"
local KEY_OF_BASEPACK_FILE			= "package_file"
local KEY_OF_PATCH_VERSION			= 'patch_version'
-- Golbals
local downloadtime = nil
local downloadfile = nil
local downloadedstartOffset = nil

local isUpdateGUI = true
--控制是否接受更新
local isUpdateAccepted = false

local DialogDepth = 1024

local STRING_OK 	  = 	LangCommonString[81] -- [81]='确认'
local STRING_CONTINUE = 	LangCommonString[21] -- [21]='继续'
local STRING_RETRY    = 	LangCommonString[82] -- [82]='重试'
local STRING_CANCEL   = 	LangCommonString[3] -- [3]='取消'
local STRING_QUIT     = 	LangCommonString[2] -- [2]='退出'
local STRING_FIX      = 	LangCommonString[83] -- [83]='修复'
local STRING_HOME     =     LangCommonString[84] -- [84]='官网'
local STRING_DOWNLOAD =     LangCommonString[85] -- [85]='下载'
local STRING_UPDATE   =     LangCommonString[86] -- [86]='更新'


local STRING_NO_NETWORK1 = 	LangCommonString[87] -- [87]='#cffff00无法连接到网络或信号弱'
local STRING_NO_NETWORK2 =  LangCommonString[88] -- [88]='#cffff00请开启网络连接'

local STRING_NO_NETWORK = 	{ STRING_NO_NETWORK1, STRING_NO_NETWORK2 }

local STRING_NO_WIFI = 		{ LangCommonString[89], LangCommonString[90] } -- [89]='您现正使用#cffff003G#cffffff网络' -- [90]='建议使用#cffff00Wifi节省流量'
local STRING_CURL_ERROR = 	{ LangCommonString[91] } -- [91]='网络模块初始化失败'

local STRING_APK_NEED_UPDATE = { LangCommonString[92],  -- [92]='#cff6400强制更新#cffffc0提示'
							     LangCommonString[93],  -- [93]='#cffffc0APK必须更新内容,请更新到最新后进入游戏'
							     LangCommonString[94], -- [94]='#cffffc0新的版本更稳定,支持多玩法'
							     LangCommonString[95] } -- [95]='#cffffc0详细信息请访问官网了解'

local STRING_NEED_REBOOT = { LangCommonString[96],  -- [96]='#c00ff00版本还原成功！'
							 LangCommonString[97],  -- [97]='#cffff00点继续退出APP'
							 LangCommonString[98], -- [98]='#cffff00手动启动APP'
							 LangCommonString[99]} -- [99]='#cffff00更新到最新后继续游戏'

local STRING_UPDATE_NEED_REBOOT = { LangCommonString[100],  -- [100]='#c00ff00资源更新成功！'
							 		LangCommonString[101],  -- [101]='#cffff00为了获得最佳体验'
							 		LangCommonString[102], -- [102]='#cffff00需要重新启动APP'
							 		LangCommonString[103], -- [103]='#cffA016直接游戏不能保证资源完整'
							 		LangCommonString[104]} -- [104]='#c00ff00请退出后手动启动APP'

local STRING_APK_UPDATE = {   LangCommonString[105], -- [105]='#c00ff00推荐更新#cffffc0提示'
							  LangCommonString[106],  -- [106]='#cffffc0APK有可更新内容,推荐更新后进入游戏'
							  LangCommonString[107], -- [107]='#cffffc0新的APP将更稳定，支持更多的后续版本内容'
						  }

local STRING_START   = 	  LangCommonString[108] -- [108]='开始更新'
local STRING_CHECK_VER =  LangCommonString[109] -- [109]='检查版本更新中'
local STRING_MD5     =    LangCommonString[110] -- [110]='资源包校验'
local STRING_MD5_OK     = LangCommonString[111] -- [111]='资源包校验成功'
local STRING_CLEAN_BEGIN  = LangCommonString[112] -- [112]='正在缓存数据'
local STRING_MD5Error  = LangCommonString[113] -- [113]='#cffff00资源包校验失败...'
local STRING_GET_LOG  = LangCommonString[114] -- [114]='获取更新信息'
local STRING_GET_VERION_ERR = LangCommonString[115] -- [115]='#cffff00获取更新信息失败'

local STRING_NEED_UPDATE = LangCommonString[116] -- [116]='#cffff00有可更新资源内容'
local STRING_NEED_UPDATE_TEXT = LangCommonString[117] -- [117]='#cffff00轻敲【继续】更新'
local STRING_NEED_UPDATE_TEXT2 = LangCommonString[118] -- [118]='#c00ff00进入游戏'


local STRING_CHECK_MD5_ERR  = LangCommonString[119] -- [119]='#cffff00校验资源包失败'
local STRING_CHECK_MD5_ERR1 = LangCommonString[120] -- [120]='#cffff00下载过程中出现丢包'

local STRING_RETRY_TEXT1 	= LangCommonString[121] -- [121]='#c00ff00请切换到稳定网络环境'
local STRING_RETRY_TEXT2    = LangCommonString[122] -- [122]='#cffff00如果没有其他网络可用'
local STRING_RETRY_TEXT3    = LangCommonString[123] -- [123]='#c00ff00建议重试即可修复问题'

local STRING_CHECK_MD5_OPEN_ERR  = LangCommonString[124] -- [124]='#cffff00无法打开更新包'

local STRING_FAIL_CONNECT = LangCommonString[125] -- [125]='#cffff00无法连接'
local STRING_TIMEOUT = LangCommonString[126] -- [126]='#cffff00连接超时'
local STRING_COULDNT_RESOLVE_HOST = LangCommonString[127] -- [127]='#cffff00解析更新服务器失败'
local STRING_COULDNT_PARSE_UPDATE_XML = LangCommonString[128] -- [128]='#cffff00无法获取更新信息失败'
local STRING_NOVERSION0       = LangCommonString[129] -- [129]='#cffff00非法版本，建议一键还原'
local STRING_NOVERSION1       = LangCommonString[130] -- [130]='#cffff00或者到官网重新下载最新版本'
local STRING_LASTESTAPK_HIGHER0 = LangCommonString[131] -- [131]='#cffff00您的版本比服务器最新版本高'
local STRING_LASTESTAPK_HIGHER1 = LangCommonString[132] -- [132]='#cffff00建议一键还原'
local STRING_LASTESTAPK_HIGHER2 = LangCommonString[133] -- [133]='#cffff00请联系客服'

local STRING_UPDATE_NOFOUND0 = LangCommonString[134] -- [134]='#cffff00无法找到升级版本'
local STRING_UPDATE_NOFOUND1 = LangCommonString[135] -- [135]='#cffff00请下载最新版本'
local STRING_UPDATE_NOFOUND2 = LangCommonString[133] -- [133]='#cffff00请联系客服'

local STRING_ADVICE_RETRY    = LangCommonString[136] -- [136]='#cffff00建议重试'
local STRING_ADVICE_CHECKNET = LangCommonString[137] -- [137]='#cffff00如无法解决请检查网络'
local STRING_ADVICE_FIX		 = LangCommonString[132] -- [132]='#cffff00建议一键还原'

local STRING_LEVEL_COLOR = '#c00ff00'
local STRING_TEXT_COLOR = '#cffffff'

local STRING_DOWNLOAD_ERR 			   = LangCommonString[138] -- [138]='#cffff00下载异常'
local STRING_FILESYS_ERR			   = LangCommonString[139] -- [139]='#cffff00文件系统异常'
local STRING_CREATEDIR_ERR			   = LangCommonString[140] -- [140]='#cffff00无法创建文件夹'
local STRING_CREATEFILE_ERR			   = LangCommonString[141] -- [141]='#cffff00无法新建文件'
local STRING_DOWNLOAD_CURLE_RECV_ERROR = LangCommonString[142] -- [142]='#cffff00无法接收更新包数据'
local STRING_UNABLE_CLEAN			   = LangCommonString[143] -- [143]='#cffff00无法清除缓存数据'
local STRING_UNABLE_CLEAN_REASON1	   = LangCommonString[144] -- [144]='#c00ff00请检查SDCard是否被占用'
local STRING_UNABLE_CLEAN_REASON2	   = LangCommonString[145] -- [145]='#cff6400请关闭【USB数据存储】选项后重试'
local STRING_UNABLE_CLEAN_REASON3	   = LangCommonString[146] -- [146]='#c00ff00忽略直接游戏'
local STRING_UNABLE_CLEAN_REASON4	   = LangCommonString[147] -- [147]='#c00ff00请检查后重试'

local STRING_UNABLE_CLEAN_REASON5	   = LangCommonString[148] -- [148]='#cff6400或断开USB连接后重试'


local STRING_AUTOFIX_DIALOG0	   = LangCommonString[149] -- [149]='#c00ff00一键修复'
local STRING_AUTOFIX_DIALOG1	   = LangCommonString[150] -- [150]='#cffff00修复资源错误'
local STRING_AUTOFIX_DIALOG2	   = LangCommonString[151] -- [151]='#cffff00还原到原始版本'
local STRING_AUTOFIX_DIALOG3	   = LangCommonString[152] -- [152]='#cffff00还原后,将关闭游戏'
local STRING_AUTOFIX_DIALOG4	   = LangCommonString[153] -- [153]='#cffff00重新进入即可修复问题'

--文件加载出错的提示内容
local STRING_FILEERR_DIALOG0	   = '#c643f17文件加载错误了'
local STRING_FILEERR_DIALOG1	   = '#c643f17检查到文件缺失错误'
local STRING_FILEERR_DIALOG2	   = '#c643f17建议一键还原到原始版本'
local STRING_FILEERR_DIALOG3	   = '#c643f17还原后,请关闭游戏'
local STRING_FILEERR_DIALOG4	   = '#c643f17重新进入即可修复问题'
local STRING_RESTORE      		   = '还原'	

local STRING_LOG_STATIC = 	LangCommonString[154] -- [154]='本次更新内容:'
local _VersionLabel 	=   LangCommonString[155] -- [155]="当前资源版本:"
local _NextVersionLabel =   LangCommonString[156] -- [156]="升级到资源版本:"
local _VersionServerLabel = LangCommonString[157] -- [157]='最新资源版本:'


local STRING_CHECK_ERROR = 	{ LangCommonString[158], LangCommonString[159] } -- [158]='#cffff00无法与服务器建立连接' -- [159]='#cffff00请检查网络'
local STRING_CHECK_ERROR2 = { LangCommonString[160], LangCommonString[133] } -- [160]='#cffff00无法解析网络数据' -- [133]='#cffff00请联系客服'
local STRING_CHECK_ERROR3 = { LangCommonString[161], LangCommonString[162], LangCommonString[163] } -- [161]='#cffff00游戏未开放' -- [162]='#cffff00更多精彩请访问官网' -- [163]='#cffff00敬请期待'
local STRING_CHECK_ERROR4 = { LangCommonString[164], LangCommonString[133] } -- [164]='#cffff00无法读取配置' -- [133]='#cffff00请联系客服'
local isNetwork = false
local is3G = false
local isWifi = false
local cleanError = 0                            --删除临时目录时是否有错误

local _updateAutoRetryCount = 0     			--更新过程中失败自动恢复的次数，不提示玩家的情况下
local _updateAutoRetryMax = 9

local _md5AutoRetryCount = 0     			--校验中失败自动恢复的次数，不提示玩家的情况下
local _md5AutoRetryMax = 2

local _downloadAutoRetryCount = 0     		--下载过程中失败自动恢复的次数，不提示玩家的情况下
local _downloadAutoRetryMax = 2

local _update_needRestart = false

local function getparams(s)
	local t = {}
	while true do
		local i = string.find(s,';')
		if i == nil then
			t[#t+1] = string.sub(s,0,string.len(s))
			break;
		end
		t[#t+1] = string.sub(s,0,i-1)
		s =string.sub(s,i+1,string.len(s))
	end
	return t
end

-- common funcs
local function updateLog(id,message)
	local code = tonumber(message)
	if code then
		--ZXLog('>>> ' .. AsyncMessageIDString[id] .. ':[' .. code ..  ']')
	else
		--ZXLog('>>> ' .. AsyncMessageIDString[id] .. ':\"' .. message ..  '\"')
	end
end

local function getDownloadTime()
	time  = os.clock()
	if downloadtime == nil then
		downloadtime = time
		return 0
	end

	local dt = ( time - downloadtime )
	return dt
end

--万普的版本号需要在显示上加1
local function addVersion( ver )
    if ver then
        local new_ver = ver
        local sub1 = string.sub(ver, 1, 5)
        local sub2 = string.sub(ver, 6, -1)
        sub2 = sub2 + 1
        new_ver = sub1 .. sub2
        return new_ver
    end
end

--使用之前下载的升级路径数据进行升级操作
function UpdateManager:setNextUpdate()
	local recordedVersion = CCVersionConfig:sharedVersionConfig():getStringForKey(KEY_OF_VERSION);
	local nextUpdate = self.UpdateRoadMap[recordedVersion]
	local _currentVersionFilename = ''
	local _version = ''
	local _lastestVersion = ''

	--找到下一个升级路径
	if nextUpdate then
		_currentVersionFilename = nextUpdate[2]
		_version = nextUpdate[1]
		_lastestVersion = _lastestUpdateVersion;
		--找不到升级路径
	else
		UpdateManager:OnAsyncMessage(AsyncMessageID.eMsgCheckVersionError,CURLcode.UpdateRoadMapEntryNoFound)
		UpdateManager:OnAsyncMessage(AsyncMessageID.eMsgCheckVersionEnd,AssetManagerError.eCodeCheckVersionError)
		return
	end

	--设置升级参数
	__assetsmgr:setNeedfullupdate(false)
	__assetsmgr:setCurrentVersionFilename(_currentVersionFilename)
	__assetsmgr:setUpdatingVersion(_version)
	--self.lastestVersion  = _lastestUpdateVersion--__assetsmgr:lastestVersion()
	self.updatingVersion = _version
	--跳转到升级分支
	UpdateManager:OnAsyncMessage(AsyncMessageID.eMsgCheckVersionEnd,AssetManagerError.eCodeNeedUpdate)
end

--解析升级路径
function UpdateManager:parseUpdateXml(msg)

	local recordedVersion = ''          --当前版本号
	local _lastestUpdateVersion = ''    --最新版本号
	local _lastestFullVersion = ''      --最新APK版本号
	local _lastestFullPackageName =''   --最新APK文件名
	local _version = ''                 --下一级升级版本号
	local _currentVersionFilename = ''  --下一级升级版本文件名
	local _needfullupdate = false       --是否需要全更新，预留
	local _needUpdateAPK = false        --是否需要更新APK
	local _lastestVersion = ''			--临时变量，最新版本号有可能是APK的版本号也有可能是更新包版本号
	local _engineVersionCode = ''
	local _engineRecommandCode = ''
	local _apk_version = ''
	--调用解析函数
	local xmltable = {}
	local s,e = pcall(function()
		xmltable = Utils:collect(msg)
		xmltable = xmltable[1]
	end)

	--解析出来的xml处理
	if s and type(xmltable) == 'table' then

		for k ,v in ipairs(xmltable) do
			--找出最新更新包版本号
			if v.label == 'lastestUpdate' then
				_lastestUpdateVersion = v.xarg.ver
			--找出最新的APK版本号
			elseif v.label == 'apk' then
				_lastestFullVersion = v.xarg.ver
				_lastestFullPackageName = v[1]
			--找出更新列表，生成升级路径图
			elseif v.label == 'update' then
				local src  = v.xarg.src
				local dest = v.xarg.ver
				local ret  = v[1]
				self.UpdateRoadMap[src] = { dest, ret }

			elseif v.label == 'engine' then
				_engineVersionCode 	= v.xarg.code or ''
				_engineRecommandCode = v.xarg.recommand or ''

				for kk,vv in pairs(v.xarg) do
					--print(kk,vv)
				end

			elseif v.label == 'patch' then
				self.patch = { file = v[1] or '', id = tonumber(v.xarg.id) } 
				--print('patch', v[1],v.xarg.id)
			end
		end

		--获取当前版本号
		recordedVersion = CCVersionConfig:sharedVersionConfig():getStringForKey(KEY_OF_VERSION);
		_apk_version = CCAppConfig:sharedAppConfig():getStringForKey(KEY_OF_VERSION)
		

		--需要下载全包, APK版本比更新包高，或没有本地版本
		--print('>>>>>>>>>>>>>', _lastestUpdateVersion, recordedVersion)
		if(_lastestUpdateVersion < _lastestFullVersion ) then
			_version = _lastestFullVersion;
			_currentVersionFilename = _lastestFullPackageName;

			--这里懒了，就这样咯，判断了两次
			if(_lastestUpdateVersion < _lastestFullVersion) then
				_lastestVersion = _lastestFullVersion;
			else
				_lastestVersion = _lastestUpdateVersion;
			end
		else
			--无需升级
			
			if(recordedVersion == _lastestUpdateVersion) or 
			  ((recordedVersion == _apk_version) and recordedVersion > _lastestUpdateVersion ) then
				_lastestVersion = _lastestUpdateVersion;
				_version =_lastestVersion;

			--找出升级路径
			elseif(recordedVersion < _lastestUpdateVersion) then
				local nextUpdate = self.UpdateRoadMap[recordedVersion]
				if nextUpdate then
					_currentVersionFilename = nextUpdate[2]
					_version = nextUpdate[1]
					_lastestVersion = _lastestUpdateVersion;
				--找不到升级路径
				else
					--print('recordedVersion',recordedVersion)
					--print('_lastestUpdateVersion',_lastestUpdateVersion)

					UpdateManager:OnAsyncMessage(AsyncMessageID.eMsgCheckVersionError,CURLcode.UpdateRoadMapEntryNoFound)
					UpdateManager:OnAsyncMessage(AsyncMessageID.eMsgCheckVersionEnd,AssetManagerError.eCodeCheckVersionError)
					return
				end

			--本地版本比服务还高，未处理
			else

				self.LocalLastestVerMsg = { string.format(LangCommonString[165], recordedVersion), -- [165]="客户端:%s"
											string.format(LangCommonString[166], _lastestUpdateVersion) } -- [166]="服务器:%s"

				--print('recordedVersion',recordedVersion)
				--print('_lastestUpdateVersion',_lastestUpdateVersion)
				UpdateManager:OnAsyncMessage(AsyncMessageID.eMsgCheckVersionError,CURLcode.LocalLastestVer)
				UpdateManager:OnAsyncMessage(AsyncMessageID.eMsgCheckVersionEnd,AssetManagerError.eCodeCheckVersionError)
				return
			end
		end
	--XML解析错误的分支
	else
		UpdateManager:OnAsyncMessage(AsyncMessageID.eMsgCheckVersionError,CURLcode.XmlParseLogFail)
		UpdateManager:OnAsyncMessage(AsyncMessageID.eMsgCheckVersionEnd,AssetManagerError.eCodeCheckVersionError)
		return
	end

	local engine_code = CCAppConfig:sharedAppConfig():getStringForKey(KEY_OF_ENGINE_CODE)

	--print('_lastestUpdateVersion',_lastestUpdateVersion)
	--print('_lastestFullVersion',_lastestFullVersion)
	--print('recordedVersion',recordedVersion)
	--print('_currentVersionFilename',_currentVersionFilename)
	--print('_version',_version)
	--print('_lastestVersion',_lastestVersion)
	--print('_engineRecommandCode',_engineRecommandCode)
	--print('_engineVersionCode',_engineVersionCode)
	--print('engine_code',engine_code)

	

	if engine_code == '' then
		engine_code = 0
	else
		engine_code = tonumber(engine_code)
	end

	if _engineVersionCode == '' then
		_engineVersionCode = 0
	else
		_engineVersionCode = tonumber(_engineVersionCode)
	end

	if _engineRecommandCode == '' then
		_engineRecommandCode = 0
	else
		_engineRecommandCode = tonumber(_engineRecommandCode)
	end

	if _engineVersionCode > engine_code or 
	   (_lastestUpdateVersion < _lastestFullVersion and recordedVersion < _lastestFullVersion) then
	    UpdateManager:checkNeedUpdateEngine()
		return
	end

	self:checkAPKRecommandUpdate(engine_code < _engineRecommandCode,

	function()
		--如果最高版本是全包版本，且当前版本小于全包版本
		--全包版本意思是，只有引擎和更新管理，其他内容需下载，暂时没用
		if( recordedVersion == "0.0.0") then
			_needfullupdate = true;
			self.needfullupdate = true
		--如果APK版本高于最新版本和本地版本
		else
			local ver = CCAppConfig:sharedAppConfig():getStringForKey(KEY_OF_VERSION)
			if ver == "0.0.0" then
				local b = CCVersionConfig:sharedVersionConfig():getStringForKey(KEY_OF_BASEPACK_FILE)
				if not __assetsmgr:setPackagePath(b) then
					local _verconfig = CCVersionConfig:sharedVersionConfig()
					local apk_version = CCAppConfig:sharedAppConfig():getStringForKey(KEY_OF_VERSION)

					_verconfig:setStringForKey(KEY_OF_VERSION,apk_version)
					_verconfig:setStringForKey(KEY_OF_DOWNLOADED_VERSION,apk_version)
					_verconfig:setStringForKey(KEY_OF_BASEPACK_FILE,'')

					CCVersionConfig:sharedVersionConfig():flush()
					local p = PopupNotify( _root:getUINode(),
									 	   DialogDepth, {LangCommonString[167],b,LangCommonString[168]}, -- [167]='无法找到基础包' -- [168]='需要重新更新'
									 	   STRING_OK,nil,POPUP_OK,
									 	   function(state)
												self:parseUpdateXml(msg)
									 	   		return
									 	   end,POPUPSIZE_512)
					return
				end
			end
		end

		--如果已经是最新版本则无需处理直接进入游戏
		if recordedVersion == _version or 
		   ((recordedVersion == _apk_version) and recordedVersion > _lastestUpdateVersion ) then
			UpdateManager:OnAsyncMessage(AsyncMessageID.eMsgCheckVersionEnd,AssetManagerError.eCodeUpdateOK)
			return
		end

		--设置更新器需要的参数
		__assetsmgr:setNeedfullupdate(_needfullupdate)
		__assetsmgr:setCurrentVersionFilename(_currentVersionFilename)
		__assetsmgr:setUpdatingVersion(_version)

		--记录本地参数用作显示
		self.lastestVersion  = _lastestVersion--__assetsmgr:lastestVersion()
		self.updatingVersion = _version
		
		--通知更新管理器可以开始下载了
		UpdateManager:OnAsyncMessage(AsyncMessageID.eMsgCheckVersionEnd,AssetManagerError.eCodeNeedUpdate)
	end)
end

-- 增加一对setter和getter方法，用来标记玩家是不是更新后首次进入游戏（是的话就显示更新公告）  add by gzn
function UpdateManager:set_after_update_first(new_state)
	local current_state = CCUserDefault:sharedUserDefault():getStringForKey("after_update_first")
	if current_state == nil or current_state ~= new_state then
		CCUserDefault:sharedUserDefault():setStringForKey("after_update_first",new_state)
		-- 立即写入
		CCUserDefault:sharedUserDefault():flush()
	end
end

function UpdateManager:get_after_update_first()
	local current_state = CCUserDefault:sharedUserDefault():getStringForKey("after_update_first")
	return current_state;
end

function UpdateManager:checkVerionWithScript()

	require('net/HttpGetRequest')
	require('utils/Utils')
	self.needUpdateAPK = false
	self.UpdateRoadMap = {}

	----print('AssetManagerError',AssetManagerError.eCodeCheckVersionError)
	local function getUpdateXml(strerr, msg)
		--print(strerr,msg)
		local err = tonumber(strerr)
		--如果CURL有错误报错
		if err ~= CURLcode.CURLE_OK then
			strerr = tostring(err)
			UpdateManager:OnAsyncMessage(AsyncMessageID.eMsgCheckVersionError,strerr)
			UpdateManager:OnAsyncMessage(AsyncMessageID.eMsgCheckVersionEnd,AssetManagerError.eCodeCheckVersionError)
		else
			--否则跳进更新分支
			UpdateManager:parseUpdateXml(msg)
		end

	end
	--print(self.version_url)
	local http_request = HttpGetRequest:new(self.version_url,'',getUpdateXml)
	UpdateManager:OnAsyncMessage(AsyncMessageID.eMsgCheckVersionStart,'')
	http_request:send()
	return true
end

function UpdateManager:checkNeedUpdateEngine()
	if true then
		local contact_lines = CommonConfig.contact
		local info = {}

		for i in ipairs(STRING_APK_NEED_UPDATE) do
			info[#info+1] = STRING_APK_NEED_UPDATE[i]
		end

		for i in ipairs(contact_lines) do
			info[#info+1] = contact_lines[i]
		end
		--[[
		if PlatformInterface.apkUpdate then
			PlatformInterface:apkUpdate(_root, __assetsmgr, contact)
			return true
		else
			if Target_Platform == Platform_Type.QQHall then
				local p = PopupNotify( _root:getUINode(),
										 DialogDepth, info,
										 STRING_HOME, STRING_QUIT,
										 POPUP_YES_NO,
										 function(state) 
										 	if state then
										 		phoneGotoURL(PlatformInterface.home_url)	
										 		return true
										 	else
										 		ZXGameQuit() 
										 	end
										 end)
			else
				local p = PopupNotify3Btn( _root:getUINode(),
							 	   		DialogDepth, info,
							 	   		STRING_UPDATE,STRING_QUIT,STRING_HOME,
							 	   		function(iState)
							 	   			
							 	   			if iState == 0 then 
							 	   				ZXGameQuit() 
							 	   			elseif iState == 1 then
							 	   				--STRING_DOWNLOAD
							 	   				phoneGotoURL(PlatformInterface.download_url)
							 	   			else
							 	   				--STRING_HOME
							 	   				phoneGotoURL(PlatformInterface.home_url)
							 	   			end
							 	   			end)
			end
			return true
		end
		]]
	end
	return false
end

function testDD()
	PopupNotify( _root:getUINode(),
				 DialogDepth, STRING_APK_NEED_UPDATE,
				 STRING_QUIT,nil,
				 POPUP_OK,
				 function() ZXGameQuit() end,
				 POPUPSIZE_NORMAL)
end

local function do_checkVersion()
	if not UpdateManager:checkVerionWithScript() then
			PopupNotify( _root:getUINode(),
						 DialogDepth, STRING_APK_NEED_UPDATE,
						 STRING_QUIT,nil,
						 POPUP_OK,
						 function() ZXGameQuit() end)
		return
	end
end

local function lines(str)
	  local t = {}
	  local function helper(line) table.insert(t, line) return "" end
	  helper((str:gsub("(.-)\r?\n?,", helper)))
	  return t
end

local function do_update()
	--TODO
	--	   1.3.0 要处理
	--PopupNotify(_root:getUINode(),1024, { "中中中欧水开了哈#cff0000[3200]", '中中中欧水开了哈看的很快', '中中中欧水开了哈看的很快','中中中欧水开了哈看的很快' } ,"继续","取消",POPUP_YES_NO,function() return true end)
	isUpdateAccepted = true

	-- 记录游戏刚进行过更新。在游戏更新过程中，如果是连续更新多个版本，
	-- 会多次进入此路径，不过对这个状态位设置来说没有影响。  add by gzn
	UpdateManager:set_after_update_first("true")

	local downloadtime = nil
	local downloadfile = nil
	local downloadedstartOffset = nil

	if not __assetsmgr:update() then
		PopupNotify( _root:getUINode(),
					 DialogDepth, STRING_CURL_ERROR,
					 STRING_QUIT,nil,
					 POPUP_OK,
					 function() ZXGameQuit() end )
	end

end

-- _checkNetwork
--
-- 

function UpdateManager:checkNetwork_only( doCallback )
	isNetwork = AssetsManager:gotNetwork()
	is3G = AssetsManager:got3GConnected()
	isWifi = AssetsManager:gotWiFiConnected()
	--ZXLog('checkNetwork_only: ',isNetwork, is3G,isWifi,doCallback)
	local function handleIs3G(state)
		if state then
			self._use_3G = true
			doCallback()
		else
			--TODO
			ZXGameQuit()
		end
	end

	local function handleIsNetwork(state)
		if state then
			self:checkNetwork_only(doCallback)
		else
			ZXGameQuit()
		end
	end

	if not isNetwork then
		PopupNotify( _root:getUINode(),
					 DialogDepth, STRING_NO_NETWORK ,
					 			  STRING_RETRY,STRING_QUIT,POPUP_YES_NO,
					 			  handleIsNetwork)
		return
	end

	-- if is3G and not self._use_3G and not isWifi then
	-- 	PopupNotify( _root:getUINode(),
	-- 				 DialogDepth, STRING_NO_WIFI ,
	-- 				 			  STRING_CONTINUE,STRING_QUIT,POPUP_YES_NO,
	-- 				 			  handleIs3G)
	-- 	return
	-- end

	if not isWifi and not is3G then
		PopupNotify( _root:getUINode(),
					 DialogDepth, STRING_NO_NETWORK ,
					 			  STRING_RETRY,STRING_QUIT,POPUP_YES_NO,
					 			  handleIsNetwork)
		return
	end
	
	doCallback()
end

function UpdateManager:_checkNetwork()
	isNetwork = AssetsManager:gotNetwork()
	is3G = AssetsManager:got3GConnected()
	isWifi = AssetsManager:gotWiFiConnected()
	--ZXLog('CheckNetwork: ',isNetwork, is3G,isWifi)
	local function handleIs3G(state)
		if state then
			self._use_3G = true
			self:_check_version()
		else
			--TODO
			ZXGameQuit()
			--self:_checkNetwork()
		end
	end

	local function handleIsNetwork(state)
		if state then
			self:_checkNetwork()
		else
			ZXGameQuit()
		end
	end

	if not isNetwork then
		PopupNotify( _root:getUINode(),
					 DialogDepth, STRING_NO_NETWORK ,
					 			  STRING_RETRY,STRING_QUIT,POPUP_YES_NO,
					 			  handleIsNetwork)
		return
	end

	-- if is3G and not self._use_3G and not isWifi then
	-- 	PopupNotify( _root:getUINode(),
	-- 				 DialogDepth, STRING_NO_WIFI ,
	-- 				 			  STRING_CONTINUE,STRING_QUIT,POPUP_YES_NO,
	-- 				 			  handleIs3G)
	-- 	return
	-- end

	if not isWifi and not is3G then
		PopupNotify( _root:getUINode(),
					 DialogDepth, STRING_NO_NETWORK ,
					 			  STRING_RETRY,STRING_QUIT,POPUP_YES_NO,
					 			  handleIsNetwork)
		return
	end

	self:_check_version()
end


-- 设置显示的根结点
function UpdateManager:set_root( root )
	_root = root
end

function UpdateManager:delay_start()

	local ver = CCVersionConfig:sharedVersionConfig():getStringForKey(KEY_OF_VERSION)
	if ver == '' then
		ver = '0.0.0'
	end

	-- 记录检查版本了
	if BISystem.update_check then
		BISystem:update_check("start")
	end
	--当前版本

	self.needUpdateAPK = false
	self.needfullupdate = false
	self.UpdateRoadMap = {}

	self.thisVersion = ver
	local platform_t = CCAppConfig:sharedAppConfig():getStringForKey('platformInterface') or "unknow"
	if platform_t == "wanpuPlatform" then
		local wp_ver = addVersion(ver)
		UpdateWin:show_version_info(_VersionLabel .. STRING_LEVEL_COLOR .. wp_ver)	
	else
		UpdateWin:show_version_info(_VersionLabel .. STRING_LEVEL_COLOR .. ver)	
	end


	self.autoRetry_callback = callback:new()

	self:check_version()

	self.finish_callback = nil

	_update_needRestart = false
	local _funcNil = function(...) return false end

    local _ui_root =  ZXLogicScene:sharedScene():getUINode()
    local _scene_root = ZXLogicScene:sharedScene():getSceneNode()
    local _entity_root = ZXLogicScene:sharedScene():getEntityNode()
    _ui_root:registerScriptTouchHandler(_funcNil, false, 0, false)
    _scene_root:registerScriptTouchHandler(_funcNil, false, 0, false)
    _entity_root:registerScriptTouchHandler(_funcNil, false, 0, false)
end

function UpdateManager:start()
	--if PlatformInterface.onStartUpdate then
	--	PlatformInterface:onStartUpdate(function() self:delay_start() end)
	--else
		self:delay_start()
	--end
end


-- 游戏运行之前需要检测版本号
function UpdateManager:check_version()
	if self.callback == nil then
		self.callback = callback:new()
	else
		self.callback:cancel()
	end
	self.callback:start(0.25,bind(self._checkNetwork,self))
end

local setPathOnce = true
function UpdateManager:_check_version()
	if setPathOnce then
		local version_url = CommonConfig:getDefault('version_url')
		--如果从入口获取不到更新地址，使用默认的更新地址
		if not self.package_url then
			self.package_url = CommonConfig:getDefault('package_url')
		else
			self.package_url = self.package_url .. "/update" .. CCAppConfig:sharedAppConfig():getStringForKey('target_platform_folder')
		end
		--根据AppConfig指定更新目录，测试用
		local pack_url = CCAppConfig:sharedAppConfig():getStringForKey('develop_package_url')
		if pack_url ~= '' then
			self.package_url = pack_url
		end
		-- local pack_url = PlatformInterface:get_cache_url()
		--指定下载地址的分目录，每次强制更新都不一样，更好地分类
		local sub_path = CCAppConfig:sharedAppConfig():getStringForKey('package_sub_path')

		self.package_url = self.package_url .. sub_path
		self.version_url = self.package_url .. version_url
		
		ZXLog("version_url", self.version_url)
		ZXLog("package_url", self.package_url)

		__assetsmgr:setPackageUrl(self.package_url)
		setPathOnce = false
	end
	-- 第四步进行更新程序
	--ZXLog("start update")

	local ver = CCVersionConfig:sharedVersionConfig():getStringForKey(KEY_OF_VERSION)
	if ver == '' then
		ver = '0.0.0'
	end
	--当前版本
	self.thisVersion = ver
	local platform_t = CCAppConfig:sharedAppConfig():getStringForKey('platformInterface') or "unknow"
	if platform_t == "wanpuPlatform" then
		local wp_ver = addVersion(ver)
		UpdateWin:show_version_info(_VersionLabel .. STRING_LEVEL_COLOR .. wp_ver)	
	else
		UpdateWin:show_version_info(_VersionLabel .. STRING_LEVEL_COLOR .. ver)	
	end
	-- UpdateWin:show_version_info(_VersionLabel .. STRING_LEVEL_COLOR .. ver)

	--最新版本
	self.lastestVersion  = nil 
	--当前升级中的版本
	self.updatingVersion = nil
	--错误码
	self.extraErrorCode = 0
	self.curErrorCode = 0

	do_checkVersion()
end
-- 游戏更新后进入正式游戏
function UpdateManager:finish()
	local s,e = pcall(function()
		local _verconfig = CCVersionConfig:sharedVersionConfig()
		if self.patch and self.patch.file ~= '' and self.patch.id then
			--print('patch param',self.patch.file, self.patch.id)
			--每次启动都会patch
			--local bPatched = true
			--if bPatched then
				UpdateManager.OnAsyncMessage = 
					function(self,id, message)
						local s1,e1 = pcall(function()
								--print('hotfix',id,message)
								if id == AsyncMessageID.eMsgUpdateEnd then

									_verconfig:setStringForKey(KEY_OF_VERSION,self.thisVersion)
									_verconfig:setStringForKey(KEY_OF_DOWNLOADED_VERSION,self.thisVersion)
									_verconfig:flush()

									--print('done hotfix', self.patch.id, self.thisVersion)
									UpdateManager:finish_after_patch()
								end
						end)
						if not s1 then
							--print(e)
							UpdateManager:finish_after_patch()
						end
					end
				--降低版本号
				_verconfig:setStringForKey(KEY_OF_VERSION,'0')
				_verconfig:setStringForKey(KEY_OF_DOWNLOADED_VERSION,'0')
				--启动下载器
				__assetsmgr:setNeedfullupdate(false)
				__assetsmgr:setCurrentVersionFilename(self.patch.file)
				__assetsmgr:setUpdatingVersion(self.thisVersion)
				local ret = __assetsmgr:update()
				if ret then
					--print('start hot fix')
					MUtils:toast_black('正在初始化',2048,5)
					return
				end
			--end
		end
		--print('no hot fix')
		UpdateManager:finish_after_patch()
	end)
	if not s then
		error(e)
		UpdateManager:finish_after_patch()
	end
end
function UpdateManager:finish_after_patch()
	--if PlatformInterface.onStartGame then
	--	PlatformInterface:onStartGame(function() UpdateManager:__reallyfinish() end)
	--else
		UpdateManager:__reallyfinish()
	--end
end

function UpdateManager:__reallyfinish()
	-- 从这里开始是主游戏
	--清除curl
--@debug_begin
--@debug_end
	__assetsmgr:cleanup()

	-- 记录打点
	if BISystem.update_check then
		BISystem:update_check("ok")
	end
	--@debug_begin
	--检查全局变量
	require 'strict'
	--@debug_end

	require 'zxDebugger'
	require 'TimerConfig'
	require "utils/LuaEx"
	require "utils/binder"
	require "utils/Utils"
	require 'AppGameMessages'
	require "ResourceManager"

	-- 获取平台信息
	require "platform/__init"
	PlatformInterface.initPlatform()

	print('self.server_url', self.server_url)
--@debug_begin
--@debug_end

	SoundManager:reloadConfig()

	ResourceManager:init()

	-- 初始化游戏状态管理器
	-- 理论上游戏状态管理器是需要一开始就进行初始化的
	-- 因为管理器需要管理整个游戏生命周期，
	-- 而由于require的引用机制，所以我们需要在不同的游戏状态的阶段
	-- 载入或卸载某些模块，并在不同的状态入口和出口处管理
	-- ★注意一定不能随意地在GameStateManager.lua文件一开始随意添加require文件
	require "GameStateManager"
	GameStateManager:init(_root)

	-- -- 这里初始化语言包
	setGameLanguage()

	UpdateWin:clear_win_but_bg()
	-- 一进入游戏，则进入主加载界面
	GameStateManager:set_state("loading")

	PowerCenter.setMode('startLogin')
-- print("PlatformInterface.get_cache_url",PlatformInterface.get_cache_url)
	local cache_url = PlatformInterface:get_cache_url()
	print("cache_url",cache_url)
	-- local test_url = CCAppConfig:sharedAppConfig():getStringForKey('test_cache_url')
	-- if test_url ~= '' then
	-- 	self.cache_url = test_url
	-- end
	-- local cache_url = self.cache_url or CommonConfig:getDefault('cache_url')

	require 'Downloader'
	Downloader:init(cache_url)

	UpdateWin:destroy()
end

function UpdateManager:OnAsyncMessage( id, message )
	----print('>>>>>>>>>>',id,message)

	--消息范围

	if id > AsyncMessageID.eMsgUpdateMax then
		return false
	end

	if self.no_update then
		return true
	end

	--ZXLog(id == AsyncMessageID.eMsgCheckVersionError)
	local code = tonumber(message)

	--必定会进入这消息,完成Download，因为要处理大量错误所以放在前面
	if id == AsyncMessageID.eMsgUpdateStart then
		--ZXLog('#----------------------Update Start----------------------#')
		UpdateWin:setUpdateCountText(STRING_START)

	--中途错误代码
	elseif id == AsyncMessageID.eMsgCheckVersionError or 
		   id == AsyncMessageID.eMsgDownloadError or
		   id == AsyncMessageID.eMsgDownloadLogError or
		   id == AsyncMessageID.eMsgCheckVersionError or
		   id == AsyncMessageID.eMsgGetRemoteSizeError then
		self.curErrorCode = code

		BISystem:error_bi( BISystem.error_place_open_to_update, code )

	elseif 
	       id == AsyncMessageID.eMsgUncompressOpenError or
	       id == AsyncMessageID.eMsgUncompressReadError or
	       id == AsyncMessageID.eMsgMD5Error then
	   self.extraErrorCode = code

	   BISystem:error_bi( BISystem.error_place_open_to_update, code )

	elseif id == AsyncMessageID.eMsgCheckVersionStart then
		UpdateWin:setUpdateCountText(STRING_CHECK_VER,true)
		if PowerCenter and PowerCenter.setMode then
    		PowerCenter.setMode('checkupdate')
    	end

	elseif id == AsyncMessageID.eMsgCheckVersionEnd then


		if code == AssetManagerError.eCodeUpdateOK then
			if cleanError ~= 0 then
				msglist = { STRING_UNABLE_CLEAN, 
						    STRING_UNABLE_CLEAN_REASON1,
						    STRING_UNABLE_CLEAN_REASON2,
						    STRING_UNABLE_CLEAN_REASON5,
						    STRING_UNABLE_CLEAN_REASON4 }
				PopupNotify( _root:getUINode(),
						 	 DialogDepth, msglist,
						 	 STRING_CONTINUE,nil,
						 	 POPUP_OK,
						 	 function() self:delay_finish() end )
			else
				self:delay_finish()
			end

		elseif code == AssetManagerError.eCodeNeedUpdate then
			--如果从确认更新的话
			--self.lastestVersion =  --__assetsmgr:lastestVersion()
			--self.updatingVersion = --__assetsmgr:updatingVersion()

			if not isUpdateAccepted then
				msglist = { STRING_NEED_UPDATE, STRING_NEED_UPDATE_TEXT,STRING_NEED_UPDATE_TEXT2 }

				PopupNotify( _root:getUINode(),
						 	 DialogDepth, msglist,
						 	 STRING_CONTINUE,nil,
						 	 POPUP_OK,
						 	 do_update )
			else
				do_update()
			end


		elseif code == AssetManagerError.eCodeCheckVersionError then
			--self.curErrorCode = CURLcode.NoVersion

			BISystem:error_bi( BISystem.error_place_open_to_update, code )

			msglist = { STRING_GET_VERION_ERR, '#cffff00错误码:[' .. tostring(self.curErrorCode) .. ']' }
			local autoRetry = _updateAutoRetryCount <= _updateAutoRetryMax
			--autoRetry = false
			local autofix = false
			local quit = false
			--无法连接
			if self.curErrorCode == CURLcode.CURLE_COULDNT_CONNECT then
				msglist = { STRING_GET_VERION_ERR, 
							STRING_FAIL_CONNECT,
							STRING_NO_NETWORK1,
							STRING_NO_NETWORK2 }

			--操作超时
			elseif self.curErrorCode == CURLcode.CURLE_OPERATION_TIMEDOUT then
				msglist = { STRING_GET_VERION_ERR, 
							STRING_TIMEOUT,
							STRING_RETRY_TEXT1,
							STRING_RETRY_TEXT2,
							STRING_RETRY_TEXT3 }

			--无法连接到HOST
			elseif self.curErrorCode == CURLcode.CURLE_COULDNT_RESOLVE_HOST then
				msglist = { STRING_GET_VERION_ERR, 
							STRING_COULDNT_RESOLVE_HOST,
							STRING_RETRY_TEXT1,
							STRING_RETRY_TEXT2,
							STRING_RETRY_TEXT3 }
			--版本xml解析失败
			elseif self.curErrorCode == CURLcode.XmlParseLogFail then
				msglist = { STRING_GET_VERION_ERR, STRING_COULDNT_PARSE_UPDATE_XML, 
						    STRING_ADVICE_RETRY,   STRING_ADVICE_CHECKNET }

			--本地版本不对，或者找不到升级版本，建议自动修复
			elseif self.curErrorCode == CURLcode.NoVersion then
				msglist = { STRING_GET_VERION_ERR, 
							STRING_NOVERSION0, 
							STRING_NOVERSION1 }
				autofix = true

			--本地版本比服务器版本更高
			elseif self.curErrorCode == CURLcode.LocalLastestVer then
				msglist = { STRING_GET_VERION_ERR, 
							STRING_LASTESTAPK_HIGHER0, 
							STRING_LASTESTAPK_HIGHER1,
							STRING_LASTESTAPK_HIGHER2,
							self.LocalLastestVerMsg[1],
							self.LocalLastestVerMsg[2] }
				autofix = true

			elseif self.curErrorCode == CURLcode.UpdateRoadMapEntryNoFound then
				msglist = { STRING_GET_VERION_ERR, 
							STRING_UPDATE_NOFOUND0, 
							STRING_UPDATE_NOFOUND1,
							STRING_UPDATE_NOFOUND2 }
				quit = true
			end

			if quit then
				--只能退出了
				PopupNotify( _root:getUINode(),
							 DialogDepth, msglist,
							 STRING_QUIT,nil,
							 POPUP_OK,
							 function() ZXGameQuit() end)

			elseif autofix == true then
				PopupNotify( _root:getUINode(),
							 DialogDepth, msglist,
							 STRING_FIX,STRING_QUIT,POPUP_YES_NO,
							 bind(self.Autofix,self) )

			elseif not autoRetry then
				_updateAutoRetryCount = 1
				PopupNotify( _root:getUINode(),
							 DialogDepth, msglist,
							 STRING_RETRY,STRING_QUIT,POPUP_YES_NO,
							 bind(self.RetryHandle,self) )
			else
				--ZXLog('auto retry',_updateAutoRetryCount)
				_updateAutoRetryCount = _updateAutoRetryCount + 1
				-- 0.5 秒以后自动重试
				self.autoRetry_callback:cancel()
				self.autoRetry_callback:start(0.5,bind(self.Retry,self))
			end
		end

		--do_update()


	elseif id == AsyncMessageID.eMsgDownloadLogStart then
		local platform_t = CCAppConfig:sharedAppConfig():getStringForKey('platformInterface') or "unknow"
		if platform_t == "wanpuPlatform" then
			local wp_cur_ver = addVersion(self.thisVersion)
			local wp_update_ver = addVersion(self.updatingVersion)
			local wp_last_ver = addVersion(self.lastestVersion)
			UpdateWin:show_version_info(_VersionLabel .. STRING_LEVEL_COLOR .. wp_cur_ver .. 
										STRING_LEVEL_COLOR .. ' --> ' .. 
										_NextVersionLabel .. STRING_LEVEL_COLOR .. wp_update_ver)
			UpdateWin:show_server_version_info(_VersionServerLabel ..  STRING_LEVEL_COLOR .. wp_last_ver)
		else
			UpdateWin:show_version_info(_VersionLabel .. STRING_LEVEL_COLOR .. self.thisVersion .. 
										STRING_LEVEL_COLOR .. ' --> ' .. 
										_NextVersionLabel .. STRING_LEVEL_COLOR .. self.updatingVersion)
			UpdateWin:show_server_version_info(_VersionServerLabel ..  STRING_LEVEL_COLOR .. self.lastestVersion)
		end

		UpdateWin:setUpdateCountText(STRING_GET_LOG)

	elseif id == AsyncMessageID.eMsgDownloadLogEnd then

		local msg = string.match(message,'<note><%!%[CDATA%[(%Z+)%]%]></note>')
		local reboot = string.match(message,"<needReboot>(%Z+)</needReboot>")
		local param = getparams(msg)
		local log = param[1] or ''
		local needRestart = param[2] or false
		--print(message, reboot)
		if reboot == 'True' then
			_update_needRestart = true
		elseif reboot == 'Force' then
			_update_needRestart = 'Force'
		end
		UpdateWin:show_update_log( STRING_LOG_STATIC, log )
	

	elseif id == AsyncMessageID.eMsgUpdateEnd then
		--不能打开文件做MD5校验，这种情况是版本号有记录，但是Zip文件不见了
		--没有问题
		--[[
		code = AssetManagerError.eCodeOpenZipFileError
		message = AssetManagerError.eCodeOpenZipFileError
		self.curErrorCode = CURLcode.CURLE_RECV_ERROR
		local _verconfig = CCVersionConfig:sharedVersionConfig()
		local apk_version = CCAppConfig:sharedAppConfig():getStringForKey("current_version")
		_verconfig:setStringForKey('current_version',apk_version)
		_verconfig:setStringForKey('downloaded-version-code',apk_version)
		CCVersionConfig:sharedVersionConfig():flush()
		]]--

		if code == AssetManagerError.eCodeUpdateOK then
			self.thisVersion = CCVersionConfig:sharedVersionConfig():getStringForKey(KEY_OF_VERSION)
			local platform_t = CCAppConfig:sharedAppConfig():getStringForKey('platformInterface') or "unknow"
			if platform_t == "wanpuPlatform" then
				local wp_ver = addVersion(self.thisVersion)
				UpdateWin:show_version_info(_VersionLabel .. STRING_LEVEL_COLOR .. wp_ver)	
			else
				UpdateWin:show_version_info(_VersionLabel .. STRING_LEVEL_COLOR .. self.thisVersion)
			end

			----ZXLog(self.lastestVersion, self.thisVersion)

			if self.lastestVersion == nil then
				assert(false)
			end

			if self.lastestVersion == self.thisVersion then
				----ZXLog(self.lastestVersion, self.thisVersion)
				self:delay_finish()
			else
				self:setNextUpdate()
			end
			--退出。。这个测试用
--@debug_begin
--@debug_end

		else
			--其他错误
			BISystem:error_bi( BISystem.error_place_open_to_update, code )

			self:HandleUpdateEndError(id, message)
		end

		--ZXLog('#----------------------Update End----------------------#')
	--开始下载
	elseif id == AsyncMessageID.eMsgDownloadStart then
		if PowerCenter and PowerCenter.setMode then
    		PowerCenter.setMode('download')
    	end
		--
		downloadfile = message

		-- added BI 打点
		self._bi_download_0  = false
		self._bi_download_25 = false
		self._bi_download_50 = false
		self._bi_download_75 = false

	--下载
	elseif id == AsyncMessageID.eMsgDownloadProgress then

		--下载经过时间
		local speed
		local dt = getDownloadTime()
		--模式匹配
		local n, c, m = string.match(message,'(%Z+):(%Z+):(%Z+)')
		--换算成k
		c = tonumber(c) / 1024.0
		m = tonumber(m) / 1024.0
		n = tonumber(n) / 1024.0

		if downloadedstartOffset == nil then
			downloadedstartOffset = c
		end
		--目前下载进度
		local downdelta = n

		--计算速度
		if dt == 0 then
			speed = 0
		else
			speed = (downdelta / dt)
		end

		local s = string.format('pass time = %d this = %d dowload = %d/%d(%f) speed = %d kbyte',dt,downdelta,c,m,c/m,speed)
		----ZXLog(s)

		-- added by aXing on 2013-6-3
		-- 添加BI打点
		require "BISystem"
		local percent = c/m
		if not self._bi_download_0 then
			BISystem:log_loading(0)
			self._bi_download_0  = true
		elseif not self._bi_download_25 and percent >= 0.25 and percent < 0.5 then
			BISystem:log_loading(25)
			self._bi_download_25 = true
		elseif not self._bi_download_50 and percent >= 0.5 and percent < 0.75 then
			BISystem:log_loading(50)
			self._bi_download_50 = true
		elseif not self._bi_download_75 and percent >= 0.75 and percent < 1 then
			BISystem:log_loading(75)
			self._bi_download_75 = true
		end

		if isUpdateGUI then
			UpdateWin:downloading(math.floor(c),math.floor(m),string.format('%.1f',speed))
		end

	elseif id == AsyncMessageID.eMsgDownloadEnd then
		UpdateWin:download_end()
	
	--解压开始
	elseif id == AsyncMessageID.eMsgUncompressStart then
		-- added BI 打点
		BISystem:log_loading(100)

	elseif id == AsyncMessageID.eMsgUncompressProgress then

		--下载经过时间
		local dt = getDownloadTime()
		--模式匹配
		local c, m = string.match(message,'(%Z+):(%Z+)')
		c = tonumber(c)
		m = tonumber(m)
		--解压进度
		local s = string.format('pass time = %d decompress %f',dt,c/m)
		----ZXLog(s)
		UpdateWin:uncompress(c,m)

	elseif id == AsyncMessageID.eMsgUncompressEnd then
		UpdateWin:uncompress(100,100)


	elseif id == AsyncMessageID.eMsgMD5Start then
		UpdateWin:setUpdateCountText(STRING_MD5)
	
	--MD5
	elseif id == AsyncMessageID.eMsgMD5Value then
		--记录MD5，debug用，release可删除
--@debug_begin
--@debug_end
		UpdateWin:setUpdateCountText(STRING_MD5_OK)

	elseif id == AsyncMessageID.eMsgCleanWritableBegin then
		UpdateWin:setUpdateCountText(STRING_CLEAN_BEGIN)

	elseif id == AsyncMessageID.eMsgCleanWritableEnd then
		if code ~= 0 then
			--TODO
			cleanError = code
		end
		--UpdateWin:setUpdateCountText(STRING_MD5_OK)
	else

	end
	
	if id ~= AsyncMessageID.eMsgUncompressProgress and 
	   id ~= AsyncMessageID.eMsgDownloadProgress then
	updateLog(id, message)
	end

	return true
end

function UpdateManager:delay_finish()
	local function endOfUpdate()
		UpdateWin:update_end()

		local function do_finish()
			if self.finish_callback == nil then
				self.finish_callback = callback:new()
			else
				self.finish_callback:cancel()
			end
			self.finish_callback:start(0.25,bind(self.finish,self))
		end

		if _update_needRestart == true then
			_update_needRestart = false
			PopupNotify( _root:getUINode(),
				 DialogDepth, STRING_UPDATE_NEED_REBOOT,
				 STRING_QUIT, nil,
				 POPUP_OK,
				 function(state) 
					-- if state then	
						ZXGameQuit() 
					-- else
					-- 	do_finish()
					-- end
				 end)
		elseif _update_needRestart == 'Force' then
			_update_needRestart = false
			PopupNotify( _root:getUINode(),
				 DialogDepth, STRING_UPDATE_NEED_REBOOT,
				 STRING_QUIT, nil,
				 POPUP_OK,
				 function(...) 
					ZXGameQuit() 
				 end)
		else
			do_finish()
		end
	end
	
	if self.needfullupdate then
		UpdateManager:extractSound(endOfUpdate)
	else
		endOfUpdate()
	end
	
end

function UpdateManager:toMessageList(id,message)
	local msglist = {'',''}
	local code = tonumber(message)
	local id = tonumber(id)
	if code then
		msglist[1] = tostring(AsyncMessageIDString[id])
		msglist[2] = tostring(AssetManagerErrorString[code])
		msglist[3] = tostring(self.extraErrorCode)
		msglist[4] = tostring(self.curErrorCode)
	else
		msglist[1] = tostring(AsyncMessageIDString[id])
		msglist[2] = tostring(message)
		msglist[3] = tostring(self.extraErrorCode)
		msglist[4] = tostring(self.curErrorCode)
	end

	return msglist
end


function UpdateManager:Retry(state)
	self.autoRetry_callback:cancel()
	self:check_version()
end

function UpdateManager:RetryHandle(state)
	self.autoRetry_callback:cancel()
	if state then
		self:check_version()
	else
		ZXGameQuit()
	end
end


function UpdateManager:AutofixDialog()

	local msglist = { STRING_AUTOFIX_DIALOG0, 
				      STRING_AUTOFIX_DIALOG1,
				      STRING_AUTOFIX_DIALOG2,
				      STRING_AUTOFIX_DIALOG3,
				      STRING_AUTOFIX_DIALOG4 }

	PopupNotify( _root:getUINode(),
				 DialogDepth, msglist,
				 STRING_FIX,STRING_CANCEL,POPUP_YES_NO,
				 function(s)
				 	if s then
				 		self:Autofix(true, true)
				 	end
				 end)
end

--增加一个dialog来提示玩家文件加载出错
function UpdateManager:FileErrorDialog()
	-- if UpdateManager.fileErrDialog == nil then
	-- 	local msglist = {
	-- 		STRING_FILEERR_DIALOG0, 
	-- 		STRING_FILEERR_DIALOG1,
	-- 		STRING_FILEERR_DIALOG2,
	-- 		STRING_FILEERR_DIALOG3,
	-- 		STRING_FILEERR_DIALOG4
	-- 	}

	-- 	UpdateManager.fileErrDialog = PopupNotify(
	-- 		_root:getUINode(), DialogDepth, msglist, STRING_RESTORE,STRING_CANCEL,POPUP_YES_NO,
	-- 		function(s)
	-- 			if s then
	-- 				self:Autofix(true, true)
	-- 			end
	-- 		end
	-- 	)
	-- end
end

local _workQueueTimer = timer()
local _workQueue = {}

local function doTick( dt )
	-- body
	if #_workQueue == 0 then
		_workQueueTimer:stop()
	else
		local _job = table.remove(_workQueue, 1)
		_job()
	end
end

--一键修复，删除版本字段，清空sdcard目录
function UpdateManager:Autofix(state, quit)
	if state then
		local _verconfig = CCVersionConfig:sharedVersionConfig()
		local apk_version = CCAppConfig:sharedAppConfig():getStringForKey(KEY_OF_VERSION)
		_verconfig:setStringForKey(KEY_OF_VERSION,apk_version)
		_verconfig:setStringForKey(KEY_OF_DOWNLOADED_VERSION,apk_version)
		if CCVersionConfig:sharedVersionConfig():flush() > 0 then
			MUtils:toast_black(LangCommonString[170],0xffffff,3) -- [170]='正在执行修复'
			local c = callback:new()
			c:start(0.5, function()
				clearWriteablePath(
				function()
					if not quit then
						self:check_version()
					else
						PopupNotify( _root:getUINode(),
									 DialogDepth, STRING_NEED_REBOOT,
									 STRING_QUIT,nil,
									 POPUP_OK,
									 function() ZXGameQuit() end)
					end
				end)
			end)
		else
			local msglist = { STRING_UNABLE_CLEAN, 
						      STRING_UNABLE_CLEAN_REASON1,
						      STRING_UNABLE_CLEAN_REASON2,
						      STRING_UNABLE_CLEAN_REASON5,
						      STRING_UNABLE_CLEAN_REASON3 }

				PopupNotify( _root:getUINode(),
						 	 DialogDepth, msglist,
						 	 STRING_RETRY,STRING_QUIT,
						 	 POPUP_YES_NO,
						 	 bind(self.Autofix,self) )
		end
	else
		ZXGameQuit()
	end
end

---------------------------
---HJH
---2015-4-13
--一键修复资源
function UpdateManager:AutofixResource()

	MUtils:toast_black(LangCommonString[170],0xffffff,3) -- [170]='正在执行修复'
	local c = callback:new()
	c:start(0.5, function() clearResourcePath_C() end )
end

function UpdateManager:HandleUpdateEndError(id, msg)
	code = tonumber(msg)
	
	-- 添加bi打点
	local log = "fail_" .. code .. "_" .. self.extraErrorCode .. "_" .. self.curErrorCode
	if BISystem.update_check then
		BISystem:update_check(log)
	end
	local msglist = {}
	--已有的文件大小错误
	--已有的文件MD5错误
	--已有的文件MD5不能获取
	--建议重试，重新下载
	if code == AssetManagerError.eCodeDownloadedZipFileSizeError or
	   code == AssetManagerError.eCodeMD5NotMatchError then
		--CCVersionConfig:sharedVersionConfig():setStringForKey(KEY_OF_DOWNLOADED_VERSION, '');
		UpdateWin:setUpdateCountText(STRING_MD5Error)

		local autoRetry = _md5AutoRetryCount <= _md5AutoRetryMax
		if not autoRetry then
			msglist = { STRING_CHECK_MD5_ERR, 
						STRING_CHECK_MD5_ERR1,
					    STRING_RETRY_TEXT1,
					    STRING_RETRY_TEXT2,
					    STRING_RETRY_TEXT3 }

			PopupNotify( _root:getUINode(),
					 	 DialogDepth, msglist,
					 	 STRING_RETRY,STRING_QUIT,POPUP_YES_NO,
					 	 bind(self.RetryHandle,self) )
		else
			--ZXLog('MD5 retry',_md5AutoRetryCount)
			_md5AutoRetryCount = _md5AutoRetryCount + 1
			-- 0.5 秒以后自动重试
			self.autoRetry_callback:cancel()
			self.autoRetry_callback:start(0.5,bind(self.Retry,self))
		end

	elseif code ==  AssetManagerError.eCodeOpenFileForMD5Error then
		--CCVersionConfig:sharedVersionConfig():setStringForKey(KEY_OF_DOWNLOADED_VERSION, '');
		UpdateWin:setUpdateCountText(STRING_MD5Error)

		msglist = { STRING_CHECK_MD5_OPEN_ERR, 
					STRING_UNABLE_CLEAN_REASON1,
				    STRING_UNABLE_CLEAN_REASON2,
				    STRING_UNABLE_CLEAN_REASON5,
				    STRING_UNABLE_CLEAN_REASON4 }

		PopupNotify( _root:getUINode(),
				 	 DialogDepth, msglist,
				 	 STRING_RETRY,STRING_QUIT,POPUP_YES_NO,
				 	 bind(self.RetryHandle,self) )

	--建议重试，检查网络
	--elseif code == AssetManagerError.eCodeCheckVersionError then

	--建议重试，检查网络
	elseif code == AssetManagerError.eCodeFailDownloadError then
		msglist = { STRING_DOWNLOAD_ERR, LangCommonString[169] .. tostring(msg) .. ']' } -- [169]='#cffff00错误码:['


		local autoRetry = _downloadAutoRetryCount <= _downloadAutoRetryMax

		if self.curErrorCode == CURLcode.CURLE_COULDNT_CONNECT then
			msglist = { STRING_DOWNLOAD_ERR, 
						STRING_FAIL_CONNECT,
						STRING_NO_NETWORK1,
						STRING_NO_NETWORK2 }
			autoRetry = false

		elseif self.curErrorCode == CURLcode.CURLE_OPERATION_TIMEDOUT then
			msglist = { STRING_DOWNLOAD_ERR, 
						STRING_TIMEOUT,
						STRING_RETRY_TEXT1,
					    STRING_RETRY_TEXT2,
						STRING_RETRY_TEXT3}
			autoRetry = false

		elseif self.curErrorCode == CURLcode.CURLE_RECV_ERROR then
			msglist = { STRING_DOWNLOAD_ERR, 
						STRING_DOWNLOAD_CURLE_RECV_ERROR,
						STRING_RETRY_TEXT1,
						STRING_RETRY_TEXT2,
						STRING_RETRY_TEXT3 }
		end

		if not autoRetry then
			PopupNotify( _root:getUINode(),
					 	 DialogDepth, msglist,
					 	 STRING_RETRY,STRING_QUIT,POPUP_YES_NO,
					 	 bind(self.RetryHandle,self) )
		else
			--ZXLog('download retry',_downloadAutoRetryCount)
			_downloadAutoRetryCount = _downloadAutoRetryCount + 1
			-- 0.5 秒以后自动重试
			self.autoRetry_callback:cancel()
			self.autoRetry_callback:start(0.5,bind(self.Retry,self))
		end


	--处理意见，清空存储空间，检查是否被占用
	elseif code == AssetManagerError.eCodeFailCreateDirectoryError then
		msglist = { STRING_FILESYS_ERR, 
					STRING_CREATEDIR_ERR,
					STRING_UNABLE_CLEAN_REASON1,
					STRING_UNABLE_CLEAN_REASON2,
					STRING_UNABLE_CLEAN_REASON5
					}

		PopupNotify( _root:getUINode(),
				 	 DialogDepth, msglist,
				 	 STRING_RETRY,STRING_QUIT,POPUP_YES_NO,
				 	 bind(self.RetryHandle,self) )

	--处理意见，清空存储空间，检查是否被占用
	elseif code == AssetManagerError.eCodeFailCreateFileError then
		msglist = { STRING_FILESYS_ERR, 
					STRING_CREATEFILE_ERR,
					STRING_UNABLE_CLEAN_REASON1,
					STRING_UNABLE_CLEAN_REASON2,
					STRING_UNABLE_CLEAN_REASON5
					}

		PopupNotify( _root:getUINode(),
				 	 DialogDepth, msglist,
				 	 STRING_RETRY,STRING_QUIT,POPUP_YES_NO,
				 	 bind(self.RetryHandle,self) )

	--处理意见，清空存储空间，检查是否被占用
	elseif code == AssetManagerError.eCodeOpenZipFileError or 
		   code == AssetManagerError.eCodeOpenZipFileInfoError or 
		   code == AssetManagerError.eCodeOpenZipCreateDirError or 
		   code == AssetManagerError.eCodeUnZipOpenError or 
		   code == AssetManagerError.eCodeUnZipWriteError or 
		   code == AssetManagerError.eCodeUnZipReadError or 
		   code == AssetManagerError.eCodeUnZipReadNextError then

		msglist = { STRING_FILESYS_ERR, 
					STRING_CREATEFILE_ERR,
					STRING_UNABLE_CLEAN_REASON1,
					STRING_UNABLE_CLEAN_REASON2,
					STRING_UNABLE_CLEAN_REASON5,
					string.format('[%d]',code) }

		PopupNotify( _root:getUINode(),
				 	 DialogDepth, msglist,
				 	 STRING_RETRY,STRING_QUIT,POPUP_YES_NO,
				 	 bind(self.RetryHandle,self) )


	else
		PopupNotify( _root:getUINode(),
				 	 DialogDepth, self:toMessageList(id,msg) ,
				 	 STRING_RETRY,STRING_QUIT,POPUP_YES_NO,
				 	 bind(self.RetryHandle,self) )
	end

	self.extraErrorCode = 0
	self.curErrorCode = 0
end


function UpdateManager:CheckServerState(cbfunc)
	require ('net/HttpRequest')
	require ('net/HttpGetRequest')
	require ('utils/MUtils')
	require ('CommonConfig')
	self:checkNetwork_only(function()
		self.CheckServerStateRetry = 3
		self.ServerState = CommonConfig:getDefault('entry_url')
		
		if self.ServerState == nil or self.ServerState == ''  then
			cbfunc()
		else
			UpdateManager:_CheckServerState(cbfunc,true)
		end
	end)
end

function UpdateManager:_CheckServerState(cbfunc, notice)
	self.CheckServerStateResponsed = false
	if notice then
		MUtils:toast_black(LangCommonString[171],2048,5) -- [171]='正在通信'
	end
	self.iserror = false
	self.enteringGame = false
	local post_param = "id=" .. CCAppConfig:sharedAppConfig():getStringForKey('entrance_id')
	local http_request = HttpRequest:new( self.ServerState, post_param, 
		function(code,content)
				self.CheckServerTimeOutCallback:cancel()
				if self.enteringGame then 
					return
				end
				self.CheckServerStateResponsed = true
				print("code,content",code,content)
				if code == 0 then 
					--print(code,content)
					require 'json/json'
					local jtable = {}
					local s,e = pcall(function()
						jtable = json.decode(content)
					end)
					print("s,e",s,e)
					if s then
						local canEnter = CCAppConfig:sharedAppConfig():getBoolForKey("canEnter")
						--是否打开admob广告
						local is_open_admob = jtable['isopenadmob']
						self._is_open_admob = is_open_admob
						require 'model/IOSDispatcher'
						self._ios_check_version = nil
						local pf =  GetPlatform()
						if pf == CC_PLATFORM_IOS then
							print("run _ios_check_version")
							self._ios_check_version = jtable['check_version']
							print("self._ios_check_version",self._ios_check_version)
						end
						local _t_version = ""
						if pf == CC_PLATFORM_IOS then
						-- if PlatformInterface.get_ios_version then
							_t_version = PlatformApple_IOS_VERSION
							-- _t_version = PlatformInterface:get_ios_version()
						end
						print("is_open_admob,_t_version,self._ios_check_version",is_open_admob,_t_version,self._ios_check_version,_t_version == self._ios_check_version)
						if is_open_admob== "true" or _t_version == self._ios_check_version then
							IOSDispatcher:show_admob_banner( )
						end
						--是否打开推送服务
						local is_open_push = jtable['isOpenPushService']
						local post_url = jtable['url']
						if is_open_push=='true' and GetPlatform() == CC_PLATFORM_IOS then
							IOSDispatcher:open_push_service(post_url )
						end
						--bi打点一次
						self.bi_url       = jtable['biUrl']
						self.bi_param     = jtable['biParam']
						self.bi_local_url = jtable['biLocal']
						BISystem:init(self.bi_url, self.bi_param, self.bi_local_url)

						--是否可进入游戏
						print("canEnter",jtable['canEnter'])
						if jtable['canEnter'] == 'true' or canEnter then
							-- print("server_list_url]",jtable['server_list_url'])
							-- print("login_url",jtable['login_url'])
							self.announcement = jtable['announcement']

							self.version_url = jtable['updatelist']
							self.package_url = jtable['update']
							self.server_url  = jtable['url']
							self.cache_url   = jtable['cache_url']
							-- self.cache_url   = "http://res.tjxs.m.37.com"
							self.customer_service_url = jtable['customer_service_url']
							self.servlist_url = jtable['server_list_url']
							self.login_url	 = jtable['login_url']
							
							self.registe_url	 			= jtable['register_url']
							self.server_list_url			= jtable['reg_server_list_url']
							self.idfa_server_list_url		= jtable['idfa_server_list_url']
							self.gameCenter_server_list_url	= jtable['gameCenter_server_list_url']
							self.apple_pay_callback	 		= jtable['iap_pay_url']

							--该参数只有在应用宝包的支付会用到,为"hoolai"时调用hoolai支付,如果不是,则调用腾讯自带支付
							self.msdk_pay_type	= jtable['a1']	

							self.blue_diamond_url   = jtable['blue_diamond_url']
							self.yellow_diamond_url = jtable['yellow_diamond_url']
							self.magic_diamond_url  = jtable['magic_diamond_url']
							self.green_diamond_url 	= jtable['green_diamond_url']	
							self.qq_member_url      = jtable['qq_member_url']				
							self.enteringGame = true
							cbfunc()
						elseif jtable['canEnter'] == 'false' then
							if jtable['reason'] then
								local msg = jtable['reason']
								local d = PopupNotify( _root:getUINode(),
											 DialogDepth, {},
											 STRING_QUIT,nil,
											 POPUP_OK,
											 function() ZXGameQuit() end)

								local textctrl = CCDialogEx:dialogWithFile( 36, 210, 245, 75, 50, nil, 1 ,ADD_LIST_DIR_UP)
        						textctrl:setText( msg )
        						textctrl:setAnchorPoint(0,1);
        						d:addChild(textctrl)
								return
							else
								PopupNotify( _root:getUINode(),
											 DialogDepth, STRING_CHECK_ERROR3,
											 STRING_QUIT,nil,
											 POPUP_OK,
											 function() ZXGameQuit() end)
								return
							end
						else
							PopupNotify( _root:getUINode(),
										 DialogDepth, STRING_CHECK_ERROR2,
										 STRING_QUIT,nil,
										 POPUP_OK,
										 function() ZXGameQuit() end)
							return
						end
					else
						self.iserror = true
					end
				else
					self.iserror = true
				end

				if self.iserror then

					if self.CheckServerStateRetry > 0 then
						local c = callback:new()
						c:start(0.5, function()
							UpdateManager:_CheckServerState(cbfunc)
							self.CheckServerStateRetry = self.CheckServerStateRetry - 1
						end)
					else
						MUtils:toast_black(LangCommonString[172],602048,5) -- [172]='使用默认参数[1]'
						self.enteringGame = true
						cbfunc()
						BISystem:error_bi( BISystem.error_place_open_to_update, code )
						--[[
						PopupNotify( _root:getUINode(),
									 DialogDepth, STRING_CHECK_ERROR,
									 STRING_QUIT,nil,
									 POPUP_OK,
									 function() ZXGameQuit() end)
						]]--
					end
				end
		end)

	if self.CheckServerTimeOutCallback == nil then
		self.CheckServerTimeOutCallback = callback:new()
	end

	self.CheckServerTimeOutCallback:cancel()
	self.CheckServerTimeOutCallback:start(20.0, 
	function(...)
		if self.CheckServerStateResponsed == false then
			MUtils:toast_black(LangCommonString[173],602048,5) -- [173]='使用默认参数[2]'
			self.enteringGame = true
			cbfunc()
			--PopupNotify( _root:getUINode(),
			--			 DialogDepth, STRING_NO_NETWORK,
			--			 STRING_QUIT,nil,
			--			 POPUP_OK,
			--			 function() ZXGameQuit() end)
		end
	end) 

	http_request:send()
end

--分享接口, info为table，必须有key
--info = {
--    ['title']
--    ['desc']
--    ['targetUrl']
--	  ['imgUrl']	
--}

--通过callback删除SDcard内的目录
--nextStage = 完成callback
function UpdateManager:fixStorage(nextStage)
	require ('utils/MUtils')
	MUtils:toast_black(LangCommonString[174],0xffffff,3) -- [174]='正在初始化'
	clearWriteablePath(nextStage)
end


function UpdateManager:checkAPKRecommandUpdate(state, __callback)
	if not state then
		__callback()
		return
	end

	local contact_lines = CommonConfig.contact
	local info = {}

	for i in ipairs(STRING_APK_UPDATE) do
		info[#info+1] = STRING_APK_UPDATE[i]
	end

	for i in ipairs(contact_lines) do
		info[#info+1] = contact_lines[i]
	end
--[[
	if PlatformInterface.apkUpdate then
		PlatformInterface:apkUpdate(_root, __assetsmgr, contact)
		return
	else
		local p = PopupNotify( _root:getUINode(),
						 	   DialogDepth, info,
						 	   STRING_UPDATE,STRING_CANCEL,POPUP_YES_NO,
						 	   function(state) 
						 	   		if state then
						 	   			phoneGotoURL(PlatformInterface.download_url)
						 	   			return true
						 	   		else
						 	   			__callback()
						 	   		end
						 	   	end,
						 	   POPUPSIZE_512)
		return
	end
]]--
end

--解压步骤Begin
local SoundsToUnzip = 
{
}

local _unZipworkQueueTimer = timer()
local _unZipworkQueue = {}

local function dounZipTick( dt )
	-- body
	if #_unZipworkQueue == 0 then
		_unZipworkQueueTimer:stop()
	else
		local _job = table.remove(_unZipworkQueue, 1)
		_job()
	end
end

function UpdateManager:extractSound(nextStage)
	local s = __assetsmgr:getStoragePath()
	__assetsmgr:createDirectory(s..'sound')
	__assetsmgr:createDirectory(s..'sound/Effect')
	__assetsmgr:createDirectory(s..'sound/Game')
	__assetsmgr:createDirectory(s..'sound/Sounds')
	local maxCount = #SoundsToUnzip
	for i, v in ipairs(SoundsToUnzip) do
		_unZipworkQueue[#_unZipworkQueue+1] = function() 
		__assetsmgr:extractAssetToSDCard(v) 
		UpdateWin:uncompress(i,maxCount)
		end
	end
	_unZipworkQueue[#_unZipworkQueue+1] = nextStage
	if _unZipworkQueueTimer:isIdle() then 
		_unZipworkQueueTimer:start(0,dounZipTick)
	end
end
--解压End
