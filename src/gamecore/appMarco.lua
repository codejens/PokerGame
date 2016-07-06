AppDelegateEvents = 
{
	eApplicationRestart    = 0,			--游戏重启，暂时未处理
	eApplicationResetBegin = 1,			--游戏重置/退出开始，这里处理脚本的退出事件
	eApplicationResetEnd   = 2,			--游戏重置/退出结束，无需关心
	eApplicationExitBegin  = 3,			--游戏析构，无需关心
	eApplicationExitEnd    = 4,			--游戏析构，无需关心
	eApplicationStart 	   = 5,			--游戏启动，无需关心
	eApplicationDidEnterBackground  = 6,--游戏切到前台
	eApplicationWillEnterForeground =7, --游戏切到后台
	eApplicationMemoryWarning = 8       --内存报警
};

--动画帧事件监听枚举
XAnimateEvent = 
{
	eFrameStart = 0,
	eFrameEvent = 1,
	eFrameEnd   = 2
};

--socket 消息
SocketDelegateProtocolScript=
{
		eOnCommuSucc = 0,
		eOnRecv = 1,
		eOnSocketError = 2,
};

--异步加载优先度
ASYNC_PRIORITY =
{
	LOWEST = 0,
	TEXTUTRE = 126,
	TILE = 127,
	ANIMATION = 128,
	HIGHEST = 255,
};

DOWNLOAD_RET =
{
	eLOADWWW_OK = 0,
	eLOADWWW_Progress = 1,
	eLOADWWW_Error = 2
};


--默认已经使用的tag
DEFAULT_TAGS =
{
	eZeroTag = 0,
	eAnimateSpriteAnimateTag = 1,		--动画Tag
	eAnimateSpriteSpeedTag = 2,			--动画速度Tag
	eAnimateSpriteMoveTag = 3,			--移动Tag
	eLogicTagStart = 100,				--逻辑使用的Tag开始
};


--文件
FILE_FORMAT =
{
	FRAME_ANIMATION_SIZE = 1024 --输出的动画纹理固定大小
}

XActionNodeEvent = 
{
	eEntityMoveEnd = 0
}