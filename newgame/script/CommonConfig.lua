
local function getAppConfig(key)
	local s = CCAppConfig:sharedAppConfig():getStringForKey(key)
	if s == "" then
		s = nil
	end
	return s
end

CommonConfig = {
	contact = 
	{
		"#c00ffffhttp://zxsj.qq.com",
		LangCommonString[7],
		LangCommonString[8],
		LangCommonString[9],
	},
	default = {
		entry_url     = getAppConfig("entry_url"),
		version_url   = getAppConfig("version_url") or "zx_update_package.xml",
		package_url   = getAppConfig("package_url") or "http://app1000000129.imgcache.qzoneapp.com/app1000000129/ZhanXianAndroid/update/",
		bi_server_url = "",
		bi_server_fix_param = "src=3&key=fewqefedopb0necdedceyh",
		server_list         = getAppConfig("server_list") or "",
		default_server_list = "http://125.39.218.156/hy/noplatform/",
		cache_url	        = getAppConfig("develop_cache_url"),
	},
	home = "http://zxsj.qq.com"
}

function CommonConfig:getDefault(key)
	return self.default[key]
end
