--为BISystem做平台相关的打点
PlatformInfoForBISystem = {}

--获取平台
function PlatformInfoForBISystem:getDownloadFrom()
	local download_source = CCAppConfig:sharedAppConfig():getStringForKey('download_source') or ""
	if PlatformInterface and  PlatformInterface.getDownloadFrom then
		download_source = PlatformInterface:getDownloadFrom()
	end
	return download_source
end


--获取平台的子渠道
function PlatformInfoForBISystem:getDownloadChannel()
	local chanel = CCAppConfig:sharedAppConfig():getStringForKey('lh_channel') or ""
	if PlatformInterface and PlatformInterface.getDownloadChannel then
		chanel = PlatformInterface:getDownloadChannel()
	end
	return chanel
end