--@desc
	--针对Cocos SimpleAudioEngine的脚本封装	
	--@example
		--@usage 预加载声音文件
		--AudioManager:preloadEffect("effect1.wav");
		--AudioManager:preloadEffect( { "effect1.wav", ... } );
		
		--@usage 指定文件,比如说进入场景时就指定好音乐
		--AudioManager:setBackgoundMusic("background.mp3")
		
		--@usage 直接指定文件，同时loop == true （循环）
		--AudioManager:playBackgroundMusic("background.mp3", true);
		
		--@usage 播放原先指定好的背景音乐，同时loop == false（不循环）
		--AudioManager:playBackgroundMusic();
		
		--@usage 播放原先指定好的背景音乐，同时loop == true （循环）
		--AudioManager:playBackgroundMusic(nil, true);
		
	--@etc
		--其他接口详细见下
--
--如果想使用基于对象的音效可以使用SoundEffect
--详细见SoundEffect.lua
require 'sound/SoundEffect'
		
local sndmgr = SimpleAudioEngine:sharedEngine()

local is_play_music = true;
local is_play_sound_effect = true;

--声音管理器
AudioManager = 
{
	BackgoundMusic = nil,
	LoadSoundEffects = {},
	LoadSoundHistory = {},
	SoundEffectCount = 0,
}

function AudioManager:dump()
	print(self.SoundEffectCount)
end
--预加载
--@param
	--effectlist = 文件名
function AudioManager:preloadEffect( effectfile )
	if not self.LoadEffectFile[effectfile] then
		sndmgr:preloadEffect(effectfile)
		self.LoadEffectFile[effectfile] = true
	end
end

--预加载
--@param
	--effectlist = 文件列表
function AudioManager:preload( effectlist )
	for i, filename in ipairs(effectlist) do
		sndmgr:preloadEffect(filename)
	end
end

--从那个zip文件作为根路径
--@param
	--file = Zip文件名
function AudioManager:setResource(file)
	SimpleAudioEngine:setResource(file)
end

--播放背景音乐
--@param
	--file = 文件名
	--loop = 是否循环
function AudioManager:playBackgroundMusic(file , loop)
	if ( is_play_music ) then 
		file = file or self.BackgoundMusic
		sndmgr:playBackgroundMusic(file, loop)
		self.BackgoundMusic = file
		local volume = SetSystemModel:get_date_value_by_key( SetSystemModel.MUSIC_VOLUME ) / 100
		sndmgr:setBackgroundMusicVolume(volume)
	end
end

--设置背景音乐文件名，不会播放，只是指定文件
--@param
	--file = 文件
function AudioManager:setBackgoundMusic(file)
	self.BackgoundMusic = file
end

--停放背景音乐
--@param
	--bReleaseData = 是否释放内存
function AudioManager:stopBackgroundMusic(bReleaseData)
	sndmgr:stopBackgroundMusic(bReleaseData)
	self.BackgoundMusic = nil
end

--暂停背景音乐
function AudioManager:pauseBackgroundMusic()
	sndmgr:pauseBackgroundMusic()
end

--背景音乐倒带
function AudioManager:rewindBackgroundMusic()
	sndmgr:rewindBackgroundMusic()
end

--背景音乐是否处于播放中
function AudioManager:isBackgroundMusicPlaying()
	return sndmgr:isBackgroundMusicPlaying()
end

--获取背景音量大小
--@return
	--volume 0.0 ~ 1.0
function AudioManager:getBackgroundMusicVolume()
	return sndmgr:getBackgroundMusicVolume()
end

--设置背景音量大小
--@param
	--volume 0.0 ~ 1.0
function AudioManager:setBackgroundMusicVolume(volume)
	print("旧音量= "..sndmgr:getBackgroundMusicVolume().."设置背景音乐音量大小music_volumn = ",volume)
	sndmgr:setBackgroundMusicVolume(volume)
	--[[
	if ( volume == 0 ) then 
		is_play_music = false
		-- 停止播放音乐
		if ( AudioManager : isBackgroundMusicPlaying() ) then
			AudioManager : stopBackgroundMusic(false)
		end
	else
		is_play_music = true
		-- 播放音乐
		if ( AudioManager : isBackgroundMusicPlaying() == false) then
			local music_file_name = SceneConfig:get_music_by_scene_id( SceneManager:get_cur_scene() );
			if ( music_file_name ) then 
				AudioManager : playBackgroundMusic(SoundGlobals.SoundSoundsPath..music_file_name , true);
			end
		end
	end
	--]]
end

--设置音效大小
--@param
	--volume 0.0 ~ 1.0
function AudioManager:setEffectsVolume(volume)
	sndmgr:setEffectsVolume(volume)
	if ( volume == 0 ) then 
		is_play_sound_effect = false
	else
		is_play_sound_effect = true
	end
end

--播放音效
--注意一个文件（音源）可以有多个声音输出
--比如一个铃声，多次调用play将会发出多次声音而不是重头播放
--@param
	--filePath = 文件名
	--loop = 是否循环
--@return
	--soundid = int
function AudioManager:playEffect( filePath , loop )

	
	if ( is_play_sound_effect ) then 
		--如果声音ID多于30个，删除一个
		if #self.LoadSoundHistory > 30 then
			local removehandle = table.remove(self.LoadSoundHistory,1)
			self.LoadSoundEffects[removehandle] = nil
			sndmgr:stopEffect(removehandle)

			print('AudioManager:remove buffer id = ', removehandle)
		end

		local nSoundID = sndmgr:playEffect(filePath,loop)
		print('AudioManager:playEffect count = ', #self.LoadSoundHistory)
		print('AudioManager:playEffect id = ', nSoundID)

		if nSoundID then
			self.LoadSoundEffects[nSoundID] = filePath
			self.LoadSoundHistory[#self.LoadSoundHistory+1] = nSoundID
			return nSoundID
		else
--@debug_begin
			error(filePath)
--@debug_end
			return nil
		end
	end
end

--停止音效
--会停止所有同名音效
--@param
	--nSoundId == int
function AudioManager:stopEffect(nSoundId, r)
	if nSoundId then
		print('AudioManager:stopEffect id = ', nSoundId)
		self.LoadSoundEffects[nSoundId] = nil
		sndmgr:stopEffect(nSoundId)
		for i,v in ipairs(self.LoadSoundHistory) do
			if v == nSoundId then
				table.remove(self.LoadSoundHistory,i)
				break
			end
		end
	end
end

--去除加载,影响所有同名音效
--@param
	--filePath
function AudioManager:unloadEffect(filePath)
	sndmgr:unloadEffect(filePath)
	self.LoadEffectFile[filePath] = nil
end
