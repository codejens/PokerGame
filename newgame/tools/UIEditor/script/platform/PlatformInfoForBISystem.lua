--为BISystem做平台相关的打点
PlatformInfoForBISystem = {}

--获取平台
function PlatformInfoForBISystem:getDownloadFrom()
	local download_source = CCAppConfig:sharedAppConfig():getStringForKey('download_source') or ""
	--[[
	if download_from == "Tuyoo" then 
		require "config/Tuyou_client_id_map"
        download_from = CCAppConfig:sharedAppConfig():getStringForKey('download_from') or ""
        if download_from == nil or download_from == "" then 
        	local client_id = CCAppConfig:sharedAppConfig():getStringForKey('client_id') or ""
            download_from = Tuyou_client_id_map:get_download( client_id ) or ""
        end
	end
	]]--
	return download_source
end


--获取平台的子渠道
function PlatformInfoForBISystem:getDownloadChannel()
	local chanel = CCAppConfig:sharedAppConfig():getStringForKey('lh_channel') or ""
	return chanel
end