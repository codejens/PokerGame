
local function getAppConfig(key)
	local s = CCAppConfig:sharedAppConfig():getStringForKey(key);--'entry_url')
	if s == '' then
		s = nil
	end
	return s
end

CommonConfig = {
	contact = 
	{
		'#c00ffffhttp://zxsj.qq.com',
		LangCommonString[7], -- [7]='#cffA032客服QQ 2995192452'
		LangCommonString[8], -- [8]='#cffA032交流群 229209663'
		LangCommonString[9], -- [9]='#cffA032客服电话 0799-2191291'
	},
	default = {
		entry_url = ""  --getAppConfig('entry_url') .. getAppConfig('platform_id')
					  or 'http://phone1.app1000000129.twsapp.com/entrance.jsp', --http://phone1.app1000000129.twsapp.com/entrance.jsp

		version_url = getAppConfig('version_url')
					  or 'zx_update_package.xml',

		package_url = getAppConfig('package_url')
					  or 'http://app1000000129.imgcache.qzoneapp.com/app1000000129/ZhanXianAndroid/update/',

		bi_server_url = 'http://loginhy.hoolaigames.com:8010/LoggerApp/LoggerServ',
		
		bi_server_fix_param = 'src=3&key=fewqefedopb0necdedceyh',

		server_list  = getAppConfig('server_list') 
					  or '',

		--默认的default_server_list
		default_server_list = 'http://125.39.218.156/hy/noplatform/',

		cache_url	= getAppConfig('cache_url') 
					  or 'http://app1000000129.imgcache.qzoneapp.com/app1000000129/ZhanXianAndroid/download/'
	},
	home = 'http://zxsj.qq.com'
}

function CommonConfig:getDefault(key)
	return self.default[key]
end
