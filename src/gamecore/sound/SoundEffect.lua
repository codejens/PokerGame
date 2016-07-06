--@desc
	--针对Cocos音效基于对象的封装	
	--@func play
		--注意一个文件（音源）可以有多个声音输出
		--比如一个铃声，多次调用play将会，发出多次声音而不是重头播放
	--@func stop
		--会停止所有同类的声音
	--@func setname
		--重置文件实际上是停止了当前的声音
		--原因是如果是循环播放的话
		--停掉就会出问题
		
	--@example
		--@usage 创建音效
		--local sndeff = SoundEffect:new("effect1.wav")
		
		--@usage 播放音效
		--sndeff:play()
		
		--@usage 停止所有（同文件名）音效
		--sndeff:stop()
		
		--@usage 去除加载当前声音
		--sndeff:unload()
		
		--@usage 重新指向音效文件,主要是支持重用，只是留接口感觉没用
		--sndeff:setfile("effect1.wav")
--声效
SoundEffect =
{
}

SoundEffect.effect_fjtx = SoundGlobals.SoundGamePath .. "00011.wav";		--防具脱下
SoundEffect.effect_fjzb = SoundGlobals.SoundGamePath .. "00014.wav";		--防具装备
SoundEffect.effect_commit = SoundGlobals.SoundGamePath .. "00017.wav";		--提交任务
SoundEffect.effect_finish = SoundGlobals.SoundGamePath .. "00018.wav";		--任务完成
SoundEffect.effect_sell = SoundGlobals.SoundGamePath .. "00038.wav";		--卖掉东西，获得钱币的声音，休息
SoundEffect.effect_lv_up = SoundGlobals.SoundGamePath .. "00043.wav";		--人物升级音效
SoundEffect.effect_wqtx = SoundGlobals.SoundGamePath .. "00052.wav";		--武器卸下声音
SoundEffect.effect_wqzb = SoundGlobals.SoundGamePath .. "00055.wav";		--武器装备声音
SoundEffect.effect_receive = SoundGlobals.SoundGamePath .. "00061.wav";		--接受任务
SoundEffect.effect_fbjf = SoundGlobals.SoundGamePath .. "00071.wav";		--副本通关计分的声音
SoundEffect.effect_fbtx = SoundGlobals.SoundGamePath .. "00072.wav";		--副本通关特效的声音
SoundEffect.effect_fbyz = SoundGlobals.SoundGamePath .. "00073.wav";		--副本通关印章的声音
SoundEffect.effect_fbkxz = SoundGlobals.SoundGamePath .. "00074.wav";		--副本通关开箱子的声音

--new 函数
function SoundEffect:new(file)
    local i = {}
    setmetatable(i, self)
    self.__index = self
    i:__init(file)
    return i
end

--初始化
--@param
	--file == 文件名
function SoundEffect:__init(file)
	self.handle = nil
	self.file = file
end

--播放
--@param
	--file == 文件名
	--loop == 循环
function SoundEffect:play(loop)
	self.handle = AudioManager:playEffect(self.file, loop)
end

--停止
function SoundEffect:stop()
	AudioManager:stopEffect(self.handle)
	self.handle = nil
end

--重置文件
function SoundEffect:setfile(file)
	self:stop()
	self.file = file
end

--去除加载
function SoundEffect:unload()
	AudioManager:unloadEffect(self.file)
	self.handle = nil
end