WG_ePlatform = 
{
	ePlatform_None 	 = 0,
    ePlatform_Weixin = 1,          
    ePlatform_QQ     = 2,
    ePlatform_WTLogin= 3,
    ePlatform_QQHall = 4
}

MSDK_TYPE = 
{
    ePlatform_None = 0,
    ePlatform_Weixin = 1,
    ePlatform_QQ = 2,
    ePlatform_Guest = 3,       --游客登录
    ePlatform_GameCenter = 4,  --苹果登录
    ePlatform_normal = 5,      --普通登录
}

WG_eChannel = 
{
    2002,        --应用宝的渠道
    2088         --qq大厅渠道
}

WG_eFlag = 
{
	eFlag_Succ              = 0,      
    eFlag_OK                = 1, 
    eFlag_Need_Login        = 100,      --需游戏登录平台 
    eFlag_QQ_NoAcessToken   = 1000,     --通过手Q登录失败 QQ&QZone login fail and can't get accesstoken
    eFlag_QQ_UserCancel     = 1001,     --手Q登录过程中用户取消 QQ&QZone user has cancelled login process (tencentDidNotLogin)
    eFlag_QQ_LoginFail      = 1002,     --手Q登录过程中其他失败情况 QQ&QZone login fail (tencentDidNotLogin)
    eFlag_QQ_NetworkErr     = 1003,     --手Q登录过程中网络错误 QQ&QZone networkErr
    eFlag_QQ_NotInstall     = 1004,     --用户没有安装手 QQ is not install
    eFlag_QQ_NotSupportApi  = 1005,     --用户的手Q版本太低不支持api调用 QQ don't support open api
    eFlag_QQ_AccessTokenExpired  = 1006,--// QQ Actoken失效, 需要重新登录


    eFlag_WX_NotInstall     = 2000,     --没有安装微信 Weixin is not installed
    eFlag_WX_NotSupportApi  = 2001,     --微信版本太低不支持API Weixin don't support api
    eFlag_WX_UserCancel     = 2002,     --微信登录过程中用户取消 Weixin user has cancelled
    eFlag_WX_UserDeny       = 2003,     --微信登录过程中用户禁止授权 Weixin User has deny
    eFlag_WX_LoginFail      = 2004,     -- 微信登录过程中其他失败情况 Weixin login fail
    eFlag_WX_RefreshTokenSucc = 2005,   -- Weixin 刷新票据成功
    eFlag_WX_RefreshTokenFail = 2006,   -- Weixin 刷新票据失败
 eFlag_WX_AccessTokenExpired = 2007,    -- Weixin AccessToken失效, 此时可以尝试用refreshToken去换票据
    eFlag_WX_RefreshTokenExpired = 2008,-- Weixin refresh token 过期, 需要重新授权
    eFlag_Error				= -1
}

WG_eShare =
{
	eShare_Succ = 0x0
}

WG_eTokenType =
{
    eToken_QQ_Access = 1,
    eToken_QQ_Pay    = 2,
    eToken_WX_Access = 3,       --只为兼容 目前不用
    eToken_WX_Code   = 4,
    eToken_WX_Refresh= 5,	
}

WG_ePermission = 
{
	eOPEN_NONE                              = 0,
    eOPEN_PERMISSION_GET_USER_INFO          = 0x2,
    eOPEN_PERMISSION_GET_SIMPLE_USER_INFO   = 0x4,
    eOPEN_PERMISSION_ADD_ALBUM              = 0x8, 
    eOPEN_PERMISSION_ADD_IDOL               = 0x10,
    eOPEN_PERMISSION_ADD_ONE_BLOG           = 0x20,
    eOPEN_PERMISSION_ADD_PIC_T              = 0x40,
    eOPEN_PERMISSION_ADD_SHARE              = 0x80,
    eOPEN_PERMISSION_ADD_TOPIC              = 0x100,
    eOPEN_PERMISSION_CHECK_PAGE_FANS        = 0x200,
    eOPEN_PERMISSION_DEL_IDOL               = 0x400,
    eOPEN_PERMISSION_DEL_T                  = 0x800,
    eOPEN_PERMISSION_GET_FANSLIST           = 0x1000,
    eOPEN_PERMISSION_GET_IDOLLIST           = 0x2000,
    eOPEN_PERMISSION_GET_INFO               = 0x4000,
    eOPEN_PERMISSION_GET_OTHER_INFO         = 0x8000,
    eOPEN_PERMISSION_GET_REPOST_LIST        = 0x10000,
    eOPEN_PERMISSION_LIST_ALBUM             = 0x20000,
    eOPEN_PERMISSION_UPLOAD_PIC             = 0x40000,
    eOPEN_PERMISSION_GET_VIP_INFO           = 0x80000,
    eOPEN_PERMISSION_GET_VIP_RICH_INFO          = 0x100000,
    eOPEN_PERMISSION_GET_INTIMATE_FRIENDS_WEIBO = 0x200000,
    eOPEN_PERMISSION_MATCH_NICK_TIPS_WEIBO      = 0x400000,
    eOPEN_PERMISSION_GET_APP_FRIENDS            = 0x800000,
    eOPEN_ALL                                   = 0xffffff,
} 

WG_WakeupRet =
{
	WXPLATID = 1, --微信拉起, 可能是游戏圈拉起或者会话界面拉起
	QQPLATID = 2, --手Q拉起, 可能是游戏圈拉起或者后台分享到会话界面的消息拉起
	WXPLATID = 3, --保留字段, 游戏不必关注
	WXPLATID = 4, --QQ游戏大厅拉起
}

--支付结果
WG_PayResult =
{
	PAYRESULT_ERROR = -1, --支付流程失败
	PAYRESULT_SUCC  =  0, --支付流程成功
	PAYRESULT_CANCEL = 2, --用户取消
}

--支付渠道
--//支付渠道，只有支付成功时才返回相应的支付渠道
WG_PayChannel =
{
	PAYCHANEL_UNKOWN       = -1,
	PAYCHANEL_ACCT         = 0, -- //个帐渠道
	PAYCHANEL_TENPAY_CFT   = 1, -- //财付通
	PAYCHANEL_TENPAY_BANK  = 2, -- //银行卡快捷支付
	PAYCHANEL_TENPAY_KJ    = 3,	
	PAYCHANEL_QQCARD       = 4, -- //Q卡渠道	
	PAYCHANEL_MCARD        = 5, -- //手机充值卡渠道	
	PAYCHANEL_MFARE        = 6, -- //话费渠道
	PAYCHANEL_YB           = 7, -- //元宝渠道	
	PAYCHANEL_WECHAT       = 8, -- //微信支付渠道

}

--支付状态
WG_PayState =
{
	PAYSTATE_PAYUNKOWN     = -1,
	PAYSTATE_PAYSUCC       = 0, --//支付成功
	PAYSTATE_PAYCANCEL     = 1, --//用户取消
	PAYSTATE_PAYERROR      = 2, --//支付出错
}

--发货状态
WG_ProvideState =
{
	PAYPROVIDESTATE_UNKOWN = -1, --//无法知道是否发货成功，如：财付通、手机充值卡渠道
	PAYPROVIDESTATE_SUCC   = 0, --//发货成功
}

WG_PayCallbackRet = 
{
    nPayNeedLoginError    = 0,
    nGetLoginRetError     = 1,
    nEncodeError          = 2,
    nJsonError            = 3,
}