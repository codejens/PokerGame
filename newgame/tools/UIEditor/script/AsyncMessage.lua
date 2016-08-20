CURLcode = {

  UpdateRoadMapEntryNoFound = -4,    --找不到升级路径
  LocalLastestVer = -3,              --本地版本比更新服务器版本还高
  NoVersion = -2,                    --重复升级路径
  XmlParseLogFail = -1,              --log无法解析
  CURLE_OK = 0,
  CURLE_UNSUPPORTED_PROTOCOL = 1,    --/* 1 */
  CURLE_FAILED_INIT = 2,             --/* 2 */
  CURLE_URL_MALFORMAT = 3,           --/* 3 */
  CURLE_OBSOLETE4 = 4,               --/* 4 - NOT USED */
  CURLE_COULDNT_RESOLVE_PROXY = 5,   --/* 5 */
  CURLE_COULDNT_RESOLVE_HOST = 6,    --/* 6 */
  CURLE_COULDNT_CONNECT = 7,         --/* 7 */
  CURLE_FTP_WEIRD_SERVER_REPLY = 8,  --/* 8 */
  CURLE_REMOTE_ACCESS_DENIED = 9,    --/* 9 a service was denied by the server
                                 --   due to lack of access - when login fails
                                 --   this is not returned. */
  CURLE_OBSOLETE10 = 10,              --/* 10 - NOT USED */
  CURLE_FTP_WEIRD_PASS_REPLY = 11,    --/* 11 */
  CURLE_OBSOLETE12 = 12,              --/* 12 - NOT USED */
  CURLE_FTP_WEIRD_PASV_REPLY = 13,    --/* 13 */
  CURLE_FTP_WEIRD_227_FORMAT = 14,    --/* 14 */
  CURLE_FTP_CANT_GET_HOST = 15,       --/* 15 */
  CURLE_OBSOLETE16 = 16,              --/* 16 - NOT USED */
  CURLE_FTP_COULDNT_SET_TYPE = 17,    --/* 17 */
  CURLE_PARTIAL_FILE = 18,            --/* 18 */
  CURLE_FTP_COULDNT_RETR_FILE = 19,   --/* 19 */
  CURLE_OBSOLETE20 = 20,              --/* 20 - NOT USED */
  CURLE_QUOTE_ERROR = 21,             --/* 21 - quote command failure */
  CURLE_HTTP_RETURNED_ERROR = 22,     --/* 22 */
  CURLE_WRITE_ERROR = 23,             --/* 23 */
  CURLE_OBSOLETE24 = 24,              --/* 24 - NOT USED */
  CURLE_UPLOAD_FAILED = 25,           --/* 25 - failed upload "command" */
  CURLE_READ_ERROR = 26,              --/* 26 - couldn't open/read from file */
  CURLE_OUT_OF_MEMORY = 27,           --/* 27 */
  --/* Note: CURLE_OUT_OF_MEMORY may sometimes indicate a conversion error
  --         instead of a memory allocation error if CURL_DOES_CONVERSIONS
  --         is defined
  --*/
  CURLE_OPERATION_TIMEDOUT = 28,      --/* 28 - the timeout time was reached */
  CURLE_OBSOLETE29 = 29,              --/* 29 - NOT USED */
  CURLE_FTP_PORT_FAILED = 30,         --/* 30 - FTP PORT operation failed */
  CURLE_FTP_COULDNT_USE_REST = 31,    --/* 31 - the REST command failed */
  CURLE_OBSOLETE32 = 32,              --/* 32 - NOT USED */
  CURLE_RANGE_ERROR = 33,             --/* 33 - RANGE "command" didn't work */
  CURLE_HTTP_POST_ERROR = 34,         --/* 34 */
  CURLE_SSL_CONNECT_ERROR = 35,       --/* 35 - wrong when connecting with SSL */
  CURLE_BAD_DOWNLOAD_RESUME = 36,     --/* 36 - couldn't resume download */
  CURLE_FILE_COULDNT_READ_FILE = 37,  --/* 37 */
  CURLE_LDAP_CANNOT_BIND = 38,        --/* 38 */
  CURLE_LDAP_SEARCH_FAILED = 39,      --/* 39 */
  CURLE_OBSOLETE40 = 40,              --/* 40 - NOT USED */
  CURLE_FUNCTION_NOT_FOUND = 41,      --/* 41 */
  CURLE_ABORTED_BY_CALLBACK = 42,     --/* 42 */
  CURLE_BAD_FUNCTION_ARGUMENT = 43,   --/* 43 */
  CURLE_OBSOLETE44 = 44,              --/* 44 - NOT USED */
  CURLE_INTERFACE_FAILED = 45,        --/* 45 - CURLOPT_INTERFACE failed */
  CURLE_OBSOLETE46 = 46,              --/* 46 - NOT USED */
  CURLE_TOO_MANY_REDIRECTS = 47,     --/* 47 - catch endless re-direct loops */
  CURLE_UNKNOWN_TELNET_OPTION = 48,   --/* 48 - User specified an unknown option */
  CURLE_TELNET_OPTION_SYNTAX = 49,   --/* 49 - Malformed telnet option */
  CURLE_OBSOLETE50 = 50,              --/* 50 - NOT USED */
  CURLE_PEER_FAILED_VERIFICATION = 51, --/* 51 - peer's certificate or fingerprint
                                  --   wasn't verified fine */
  CURLE_GOT_NOTHING = 52,             --/* 52 - when this is a specific error */
  CURLE_SSL_ENGINE_NOTFOUND = 53,     --/* 53 - SSL crypto engine not found */
  CURLE_SSL_ENGINE_SETFAILED = 54,    --/* 54 - can not set SSL crypto engine as
                                 --   default */
  CURLE_SEND_ERROR = 55,              --/* 55 - failed sending network data */
  CURLE_RECV_ERROR = 56,              --/* 56 - failure in receiving network data */
  CURLE_OBSOLETE57 = 57,              --/* 57 - NOT IN USE */
  CURLE_SSL_CERTPROBLEM = 58,         --/* 58 - problem with the local certificate */
  CURLE_SSL_CIPHER = 59,              --/* 59 - couldn't use specified cipher */
  CURLE_SSL_CACERT = 60,              --/* 60 - problem with the CA cert (path?) */
  CURLE_BAD_CONTENT_ENCODING = 61,    --/* 61 - Unrecognized transfer encoding */
  CURLE_LDAP_INVALID_URL = 62,        --/* 62 - Invalid LDAP URL */
  CURLE_FILESIZE_EXCEEDED = 64,       --/* 63 - Maximum file size exceeded */
  CURLE_USE_SSL_FAILED = 64,          --/* 64 - Requested FTP SSL level failed */
  CURLE_SEND_FAIL_REWIND = 65,        --/* 65 - Sending the data requires a rewind
                                 --   that failed */
  CURLE_SSL_ENGINE_INITFAILED = 66,   --/* 66 - failed to initialise ENGINE */
  CURLE_LOGIN_DENIED = 67,            --/* 67 - user, password or similar was not
                                 --   accepted and we failed to login */
  CURLE_TFTP_NOTFOUND = 68,           --/* 68 - file not found on server */
  CURLE_TFTP_PERM = 69,               --/* 69 - permission problem on server */
  CURLE_REMOTE_DISK_FULL = 70,        --/* 70 - out of disk space on server */
  CURLE_TFTP_ILLEGAL = 71,            --/* 71 - Illegal TFTP operation */
  CURLE_TFTP_UNKNOWNID = 72,          --/* 72 - Unknown transfer ID */
  CURLE_REMOTE_FILE_EXISTS = 73,      --/* 73 - File already exists */
  CURLE_TFTP_NOSUCHUSER = 74,         --/* 74 - No such user */
  CURLE_CONV_FAILED = 75,             --/* 75 - conversion failed */
  CURLE_CONV_REQD = 76,               --/* 76 - caller must register conversion
                                 --   callbacks using curl_easy_setopt options
                                 --   CURLOPT_CONV_FROM_NETWORK_FUNCTION,
                                 --   CURLOPT_CONV_TO_NETWORK_FUNCTION, and
                                 --   CURLOPT_CONV_FROM_UTF8_FUNCTION */
  CURLE_SSL_CACERT_BADFILE = 77,      --/* 77 - could not load CACERT file, missing
                                 --   or wrong format */
  CURLE_REMOTE_FILE_NOT_FOUND = 78,   --/* 78 - remote file not found */
  CURLE_SSH = 79,                     --/* 79 - error from the SSH layer, somewhat
                                 --   generic so the error message will be of
                                 --   interest when this has happened */

  CURLE_SSL_SHUTDOWN_FAILED = 80,     --/* 80 - Failed to shut down the SSL
                                 --   connection */
  CURLE_AGAIN = 81,                   --/* 81 - socket is not ready for send/recv,
                                 --   wait till it's ready and try again (Added
                                 --   in 7.18.2) */
  CURLE_SSL_CRL_BADFILE = 82,         --/* 82 - could not load CRL file, missing or
                                 --   wrong format (Added in 7.19.0) */
  CURLE_SSL_ISSUER_ERROR = 83,        --/* 83 - Issuer check failed.  (Added in
                                 --   7.19.0) */
  CURLE_FTP_PRET_FAILED = 84,         --/* 84 - a PRET command failed */
  CURLE_RTSP_CSEQ_ERROR = 85,         --/* 85 - mismatch of RTSP CSeq numbers */
  CURLE_RTSP_SESSION_ERROR = 86,      --/* 86 - mismatch of RTSP Session Identifiers */
  CURLE_FTP_BAD_FILE_LIST = 87,       --/* 87 - unable to parse FTP file list */
  CURLE_CHUNK_FAILED = 88,            --/* 88 - chunk callback reported error */

  CURL_LAST = 89 					 --/* never use! */
};

CURLcodeString = {}
for k,v in pairs(CURLcode) do 
	CURLcodeString[v] = k
end

AsyncMessageID = 
{
	eMsgNoMessage			   =0,				-- 没有消息
	eMsgCheckInternet          =1,				-- 检查是否联网
	eMsgCheck3GorWifi          =2,				-- 检查是否连上3g网络或者wifi
	eMsgCheckSDCard            =3,				-- 检查是否装备了sd卡
	eMsgCheckVersionStart      =4,				-- 检查资源版本

	eMsgUpdateStart            =5,				-- 更新开始
	eMsgUpdateEnd              =6,				-- 更新结束	

	eMsgDownloadStart          =7,				-- 下载开始
	eMsgDownloadProgress       =8,			-- 下载进度
	eMsgDownloadEnd            =9,				-- 下载结束
	eMsgDownloadError          =10,				-- 下载错误

	eMsgUncompressStart        =11,			-- 解压开始
	eMsgUncompressProgress     =12,			-- 解压进度
	eMsgUncompressEnd          =13,				-- 解压结束
	eMsgUncompressOpenError    =14,		-- 解压错误
	eMsgUncompressReadError    =15,		-- 解压错误

	eMsgDownloadLogStart       =16,			-- 下载日志开始
	eMsgDownloadLogEnd         =17,				-- 下载日志结束
	eMsgDownloadLogError       =18,			-- 下载日志错误

	eMsgMD5Start          	   =19,					-- MD5开始
	eMsgMD5Progress            =20,				-- MD5进度	暂无
	eMsgMD5Value               =21,					-- MD5值
	eMsgMD5Error               =22,					-- MD5错误
	eMsgMD5End                 =23,						-- MD5操作结果

	eMsgCheckVersionError      =24,			-- 检查Version错误
	eMsgGetRemoteSizeError	   =25,
  eMsgCheckVersionEnd        =26,
  eMsgCleanWritableBegin     =27,     -- 开始清理文件夹
  eMsgCleanWritableEnd       =28,     -- 结束清理文件夹
	eMsgUpdateMax              =29,

  eMsgHttpResult             =30,     -- http请求结果
  eMsgHttpError              =31,     -- http请求错误


  eMsgMSDKOnLoginNotify      = 81000, --// login
  eMsgMSDKOnShareNotify      = 81001, --// share
  eMsgMSDKOnWakeupNotify     = 81002, --// wakeup
  eMsgMSDKPayNeedLogin       = 81080, --// MSDK支付需要登录才能进入游戏
  eMsgMSDKPayCallback        = 81081, --// MSDK支付回调，具体看回来的数据，JSon格式

  eMsgSocketInitError        = 18000,
  eMsgSocketError            = 18001,
  eMsgPhoneMessge            = 50000,
  --文件加载出错消息码
  eMsgInternalResourceNoFound  = 60000,  --// 游戏内部错误, 脚本找不到
  eMsgInternalScriptFailed   = 60001,  --// 游戏内部错误, 脚本无法解析
};

AsyncMessageIDString = {}
for k,v in pairs(AsyncMessageID) do 
	AsyncMessageIDString[v] = k
end


AssetManagerError = 
{

	eCodeUpdateOK					= 0,				--无需更新, 更新完成
	eCodeNeedUpdate					= 1,				--需要更新,不会返回到脚本
	eCodeCurlInitError          	= 2,				--Curl初始化失败
	eCodeURLError               	= 3,				--更新url错误
	eCodeUpdateLogError				= 4,				--更新日志错误
	eCodeFailCreateDirectoryError	= 5,				--无法创建文件夹
	eCodeFailCreateFileError		= 6,				--无法创建文件
	eCodeFailDownloadError			= 7,				--下载错误
	eCodeOpenFileForMD5Error		= 8,				--无法打开文件
	eCodeMD5NotMatchError			= 9,				-- MD5码不匹配
	
	eCodeOpenZipFileError			= 10,				-- 打开zip失败
	eCodeOpenZipFileInfoError       = 11,				-- 打开Zip信息失败
	eCodeOpenZipCreateDirError      = 12,				-- Zip创建目录失败
	eCodeUnZipOpenError				= 13,				-- 解压打开失败
	eCodeUnZipWriteError			= 14,				-- 解压写失败
	eCodeUnZipReadError 			= 15,				-- 解压读失败
	eCodeUnZipReadNextError         = 16,				-- 读取下一Zip失败
	eCodeCheckVersionInitError      = 17,				-- Curl初始化失败
	eCodeCheckVersionError          = 18,				-- 检查版本失败，详细见 eMsgCheckVersionError
	eCodeGetRemoteSizeError			= 19,
	eCodeDownloadedZipFileSizeError = 20
}


PhoneMessage = 
{
  ['k_id']       = 'zxID',
  ----------------------------
  --
  ----------------------------
  ['initSDK']  = 'initSDK',
}

AssetManagerErrorString = {}
for k,v in pairs(AssetManagerError) do 
	AssetManagerErrorString[v] = k
end



-- CURLE_UNSUPPORTED_PROTOCOL (1) – 您传送给 libcurl 的网址使用了此 libcurl 不支持的协议。 可能是您没有使用的编译时选项造成了这种情况（可能是协议字符串拼写有误，或没有指定协议 libcurl 代码）。 
-- CURLE_FAILED_INIT (2) – 非常早期的初始化代码失败。 可能是内部错误或问题。 
-- CURLE_URL_MALFORMAT (3) – 网址格式不正确。 
-- CURLE_COULDNT_RESOLVE_PROXY (5) – 无法解析代理服务器。 指定的代理服务器主机无法解析。 
-- CURLE_COULDNT_RESOLVE_HOST (6) – 无法解析主机。 指定的远程主机无法解析。 
-- CURLE_COULDNT_CONNECT (7) – 无法通过 connect() 连接至主机或代理服务器。 
-- CURLE_FTP_WEIRD_SERVER_REPLY (8) – 在连接到 FTP 服务器后，libcurl 需要收到特定的回复。 此错误代码表示收到了不正常或不正确的回复。 指定的远程服务器可能不是正确的 FTP 服务器。 
-- CURLE_REMOTE_ACCESS_DENIED (9) – 我们无法访问网址中指定的资源。 对于 FTP，如果尝试更改为远程目录，就会发生这种情况。 
-- CURLE_FTP_WEIRD_PASS_REPLY (11) – 在将 FTP 密码发送到服务器后，libcurl 需要收到正确的回复。 此错误代码表示返回的是意外的代码。 
-- CURLE_FTP_WEIRD_PASV_REPLY (13) – libcurl 无法从服务器端收到有用的结果，作为对 PASV 或 EPSV 命令的响应。 服务器有问题。 
-- CURLE_FTP_WEIRD_227_FORMAT (14) – FTP 服务器返回 227 行作为对 PASV 命令的响应。 如果 libcurl 无法解析此行，就会返回此代码。 
-- CURLE_FTP_CANT_GET_HOST (15) – 在查找用于新连接的主机时出现内部错误。 
-- CURLE_FTP_COULDNT_SET_TYPE (17) – 在尝试将传输模式设置为二进制或 ascii 时发生错误。 
-- CURLE_PARTIAL_FILE (18) – 文件传输尺寸小于或大于预期。 当服务器先报告了一个预期的传输尺寸，然后所传送的数据与先前指定尺寸不相符时，就会发生此错误。 
-- CURLE_FTP_COULDNT_RETR_FILE (19) – ‘RETR’ 命令收到了不正常的回复，或完成的传输尺寸为零字节。 
-- CURLE_QUOTE_ERROR (21) – 在向远程服务器发送自定义 “QUOTE” 命令时，其中一个命令返回的错误代码为 400 或更大的数字（对于 FTP），或以其他方式表明命令无法成功完成。 
-- CURLE_HTTP_RETURNED_ERROR (22) – 如果 CURLOPT_FAILONERROR 设置为 TRUE，且 HTTP 服务器返回 >= 400 的错误代码，就会返回此代码。 （此错误代码以前又称为 CURLE_HTTP_NOT_FOUND。） 
-- CURLE_WRITE_ERROR (23) – 在向本地文件写入所收到的数据时发生错误，或由写入回调 (write callback) 向 libcurl 返回了一个错误。 
-- CURLE_UPLOAD_FAILED (25) – 无法开始上传。 对于 FTP，服务器通常会拒绝执行 STOR 命令。 错误缓冲区通常会提供服务器对此问题的说明。 （此错误代码以前又称为 CURLE_FTP_COULDNT_STOR_FILE。） 
-- CURLE_READ_ERROR (26) – 读取本地文件时遇到问题，或由读取回调 (read callback) 返回了一个错误。 
-- CURLE_OUT_OF_MEMORY (27) – 内存分配请求失败。 此错误比较严重，若发生此错误，则表明出现了非常严重的问题。 
-- CURLE_OPERATION_TIMEDOUT (28) – 操作超时。 已达到根据相应情况指定的超时时间。 请注意： 自 Urchin 6.6.0.2 开始，超时时间可以自行更改。 要指定远程日志下载超时，请打开 urchin.conf 文件，取消以下行的注释标记： 
-- #DownloadTimeout: 30 
-- CURLE_FTP_PORT_FAILED (30) – FTP PORT 命令返回错误。 在没有为 libcurl 指定适当的地址使用时，最有可能发生此问题。 请参阅 CURLOPT_FTPPORT。 
-- CURLE_FTP_COULDNT_USE_REST (31) – FTP REST 命令返回错误。 如果服务器正常，则应当不会发生这种情况。 
-- CURLE_RANGE_ERROR (33) – 服务器不支持或不接受范围请求。 
-- CURLE_HTTP_POST_ERROR (34) – 此问题比较少见，主要由内部混乱引发。 
-- CURLE_SSL_CONNECT_ERROR (35) – 同时使用 SSL/TLS 时可能会发生此错误。 您可以访问错误缓冲区查看相应信息，其中会对此问题进行更详细的介绍。 可能是证书（文件格式、路径、许可）、密码及其他因素导致了此问题。 
-- CURLE_FTP_BAD_DOWNLOAD_RESUME (36) – 尝试恢复超过文件大小限制的 FTP 连接。 
-- CURLE_FILE_COULDNT_READ_FILE (37) – 无法打开 FILE:// 路径下的文件。 原因很可能是文件路径无法识别现有文件。 建议您检查文件的访问权限。 
-- CURLE_LDAP_CANNOT_BIND (38) – LDAP 无法绑定。LDAP 绑定操作失败。 
-- CURLE_LDAP_SEARCH_FAILED (39) – LDAP 搜索无法进行。 
-- CURLE_FUNCTION_NOT_FOUND (41) – 找不到函数。 找不到必要的 zlib 函数。 
-- CURLE_ABORTED_BY_CALLBACK (42) – 由回调中止。 回调向 libcurl 返回了 “abort”。 
-- CURLE_BAD_FUNCTION_ARGUMENT (43) – 内部错误。 使用了不正确的参数调用函数。 
-- CURLE_INTERFACE_FAILED (45) – 界面错误。 指定的外部界面无法使用。 请通过 CURLOPT_INTERFACE 设置要使用哪个界面来处理外部连接的来源 IP 地址。 （此错误代码以前又称为 CURLE_HTTP_PORT_FAILED。） 
-- CURLE_TOO_MANY_REDIRECTS (47) – 重定向过多。 进行重定向时，libcurl 达到了网页点击上限。 请使用 CURLOPT_MAXREDIRS 设置上限。 
-- CURLE_UNKNOWN_TELNET_OPTION (48) – 无法识别以 CURLOPT_TELNETOPTIONS 设置的选项。 请参阅相关文档。 
-- CURLE_TELNET_OPTION_SYNTAX (49) – telnet 选项字符串的格式不正确。 
-- CURLE_PEER_FAILED_VERIFICATION (51) – 远程服务器的 SSL 证书或 SSH md5 指纹不正确。 
-- CURLE_GOT_NOTHING (52) – 服务器未返回任何数据，在相应情况下，未返回任何数据就属于出现错误。 
-- CURLE_SSL_ENGINE_NOTFOUND (53) – 找不到指定的加密引擎。 
-- CURLE_SSL_ENGINE_SETFAILED (54) – 无法将选定的 SSL 加密引擎设为默认选项。 
-- CURLE_SEND_ERROR (55) – 无法发送网络数据。 
-- CURLE_RECV_ERROR (56) – 接收网络数据失败。 
-- CURLE_SSL_CERTPROBLEM (58) – 本地客户端证书有问题 
-- CURLE_SSL_CIPHER (59) – 无法使用指定的密钥 
-- CURLE_SSL_CACERT (60) – 无法使用已知的 CA 证书验证对等证书 
-- CURLE_BAD_CONTENT_ENCODING (61) – 无法识别传输编码 
-- CURLE_LDAP_INVALID_URL (62) – LDAP 网址无效 
-- CURLE_FILESIZE_EXCEEDED (63) – 超过了文件大小上限 
-- CURLE_USE_SSL_FAILED (64) – 请求的 FTP SSL 级别失败 
-- CURLE_SEND_FAIL_REWIND (65) – 进行发送操作时，curl 必须回转数据以便重新传输，但回转操作未能成功 
-- CURLE_SSL_ENGINE_INITFAILED (66) – SSL 引擎初始化失败 
-- CURLE_LOGIN_DENIED (67) – 远程服务器拒绝 curl 登录（7.13.1 新增功能） 
-- CURLE_TFTP_NOTFOUND (68) – 在 TFTP 服务器上找不到文件 
-- CURLE_TFTP_PERM (69) – 在 TFTP 服务器上遇到权限问题 
-- CURLE_REMOTE_DISK_FULL (70) – 服务器磁盘空间不足 
-- CURLE_TFTP_ILLEGAL (71) – TFTP 操作非法 
-- CURLE_TFTP_UNKNOWNID (72) – TFTP 传输 ID 未知 
-- CURLE_REMOTE_FILE_EXISTS (73) – 文件已存在，无法覆盖 
-- CURLE_TFTP_NOSUCHUSER (74) – 运行正常的 TFTP 服务器不会返回此错误 
-- CURLE_CONV_FAILED (75) – 字符转换失败 
-- CURLE_CONV_REQD (76) – 调用方必须注册转换回调 
-- CURLE_SSL_CACERT_BADFILE (77) – 读取 SSL CA 证书时遇到问题（可能是路径错误或访问权限问题） 
-- CURLE_REMOTE_FILE_NOT_FOUND (78) – 网址中引用的资源不存在 
-- CURLE_SSH (79) – SSH 会话中发生无法识别的错误 
-- CURLE_SSL_SHUTDOWN_FAILED (80) – 无法终止 SSL 连接 