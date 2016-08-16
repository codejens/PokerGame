--@desc
	--针对Cocos SimpleAudioEngine的脚本封装	
	--@example
		--@usage 预加载声音文件
		--AudioManager:preloadEffect("effect1.wav");
		--AudioManager:preloadEffect({ "effect1.wav", ... });
		
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

require "../data/client/ssound_effect"

local is_play_music = true;
local is_play_sound_effect = true;

local _last_play_list = {}

local ui_path = "sound/ui/"
local scene_path = "sound/scene/"
local skill_path = "sound/skill/"
local other = "sound/other/"
local movie_path = "sound/movie/"
local movie_scene_path = "sound/moviebg/"
local role_path = "sound/role/job"
local partner_path = "sound/partner/"
local chat_record_flag = false

--声音管理器
AudioManager = {
	BackgoundMusic = nil,
	LoadSoundEffects = {},
	LoadSoundHistory = {},
	SoundEffectCount = 0,
}


function AudioManager:dump()
	--print(self.SoundEffectCount)
end
--预加载
--@param
	--effectlist = 文件名
function AudioManager:preloadEffect(effectfile)
	if not self.LoadEffectFile then
		self.LoadEffectFile = {}
	end
	if not self.LoadEffectFile[effectfile] then
		AudioUtils.preloadEffect(effectfile)
		self.LoadEffectFile[effectfile] = true
	end
end

--预加载
--@param
	--effectlist = 文件列表
function AudioManager:preload(effectlist)
	for i, filename in ipairs(effectlist) do
		AudioUtils.preloadEffect(filename)
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
function AudioManager:playBackgroundMusic(file, loop)
	-- if true then return end
	if (is_play_music) then 
		file = file or self.BackgoundMusic
		local ret = AudioUtils.playBackgroundMusic(file, loop)
		if ret then
			self.BackgoundMusic = file
		else
			--print('error[2] AudioManager:playBackgroundMusic',file)
		end
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
	AudioUtils.stopBackgroundMusic(bReleaseData)
	self.BackgoundMusic = nil
end

--暂停背景音乐
function AudioManager:pauseBackgroundMusic()
	AudioUtils.pauseBackgroundMusic()
end

--背景音乐倒带
function AudioManager:rewindBackgroundMusic()
	AudioUtils.rewindBackgroundMusic()
end

--背景音乐是否处于播放中
function AudioManager:isBackgroundMusicPlaying()
	return AudioUtils.isBackgroundMusicPlaying()
end

--获取背景音量大小
--@return
	--volume 0.0 ~ 1.0
function AudioManager:getBackgroundMusicVolume()
	return AudioUtils.getBackgroundMusicVolume()
end

--设置背景音量大小
--@param
	--volume 0.0 ~ 1.0
function AudioManager:setBackgroundMusicVolume(volume)
	-- print("旧音量= "..AudioManager:getBackgroundMusicVolume().."设置背景音乐音量大小music_volumn = ",volume)
	AudioUtils.setBackgroundMusicVolume(volume)
	
	if (volume == 0) then 
		is_play_music = false
		-- 停止播放音乐
		if (AudioManager : isBackgroundMusicPlaying()) then
			AudioManager : stopBackgroundMusic(false)
		end
	else
		is_play_music = true
		-- 播放音乐
		if (AudioManager : isBackgroundMusicPlaying() == false) then
			return false
		end
	end
	return true
end

--设置音效大小
--@param
	--volume 0.0 ~ 1.0
function AudioManager:setEffectsVolume(volume)
	AudioUtils.setEffectsVolume(volume)
	if (volume == 0) then 
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
function AudioManager:playEffect(filePath, loop)
	if is_play_sound_effect then 
		--如果声音ID多于30个，删除一个
		if #self.LoadSoundHistory > 30 then
			local removehandle = table.remove(self.LoadSoundHistory,1)
			self.LoadSoundEffects[removehandle] = nil
			AudioUtils.stopEffect(removehandle)
		end
		local nSoundID = AudioUtils.playEffect(filePath,loop)
		if nSoundID ~= 0 then
			if not self.LoadSoundEffects[nSoundID] then
				self.LoadSoundEffects[nSoundID] = filePath
				self.LoadSoundHistory[#self.LoadSoundHistory+1] = nSoundID
			end
			return nSoundID
		else
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
		self.LoadSoundEffects[nSoundId] = nil
		AudioUtils.stopEffect(nSoundId)
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
	AudioUtils.unloadEffect(filePath)
	self.LoadEffectFile[filePath] = nil
end

SoundManager = {}

--淡入淡出背景音乐保存时间对象 方便销毁
SoundManager.s_bgTime  = nil

function  SoundManager:set_s_bgTime(time)
	AudioManager.s_bgTime = time
end

function  SoundManager:get_s_bgTime()
	return AudioManager.s_bgTime 
end

------------------------------------------------------
--逻辑使用
function SoundManager:reloadConfig()
	reload("../data/client/ssound_effect")
end

-- function SoundManager:playEffectSound(id, loop)
-- 	local strSound = sound_effect[id]
-- 	if not strSound then
-- 		return nil
-- 	end
-- 	return AudioManager:playEffect(strSound, loop)
-- end

-- function SoundManager:playActionSound(id, loop)
-- 	local strSound = action_sounds[id]
-- 	if not strSound then
-- 		return nil
-- 	end
-- 	return AudioManager:playEffect(strSound, loop)
-- end

function SoundManager:playUISound(id, loop)
	-- local function play_callback()
	-- 	local strSound = ui_sounds[id]
	-- 	if not strSound then
	-- 		return nil
	-- 	end
	-- 	return AudioManager:playEffect(strSound, loop)
	-- end
	-- _last_play_list.uisound_callback = play_callback
	-- return play_callback()
end

function SoundManager:playMusic(id, loop)
	-- local function play_callback()
	-- 	local strSound = music_config[id]
	-- 	if strSound then
	-- 		AudioManager:playBackgroundMusic(strSound , loop)
	-- 	end
	-- end
	-- play_callback()
	-- _last_play_list.backgroundmusic = play_callback
end

function SoundManager:get_last_play_list()
	return _last_play_list
end

function SoundManager:pauseBackgroundMusic()
	AudioManager : pauseBackgroundMusic()
end

function SoundManager:setBackgroundMusicVolume(v)
	local ret = AudioManager:setBackgroundMusicVolume(v)
	if not ret then
		local scene_id = SceneManager:get_cur_scene()
		SoundManager:playeSceneMusic(scene_id, true)
	end
end
   
function SoundManager:setEffectsVolume(v)
	AudioManager:setEffectsVolume(v)
end

function SoundManager:stopBackgroundMusic(bReleaseData)
	AudioManager:stopBackgroundMusic(bReleaseData);
end

function SoundManager:playBackgroundMusic(file, loop)
	AudioManager:playBackgroundMusic(file , loop)
end

function SoundManager:playeSceneMusic(id, loop)
	local music = ssound_effect.scene[id]
	if music then
	-- 	SoundManager:playBackgroundMusic(scene_music.default, loop);
	-- else
		-- SoundManager:playBackgroundMusic(string.format("%s%s.mp3",scene_path,music), loop);
	end
end


--淡入淡出播放剧情场景音乐
function SoundManager:playeMoviebgMusic(id, loop)
	 local music_volumn = SetSystemModel:get_date_value_by_key(SetSystemModel.MUSIC_VOLUME)
	local music = ssound_effect.moviebg[id]
	if music then
		-- SoundManager:playBackgroundMusic(string.format("%s%s.mp3",movie_scene_path,music), loop);
		SoundManager:setBackgroundMusicVolume(music_volumn / 100)
		-- local time = timer()
		-- SoundManager:set_s_bgTime(time)
		-- local  count = 0
		-- local function monsterTick()
			-- count = count +1
			-- if count  >= music_volumn then
				-- time:stop()
				-- time = nil
			-- else
				 -- SoundManager:setBackgroundMusicVolume(count / 100)
			-- end
	    -- end
	    -- time:start(0.1,monsterTick)
	end
end

--播放ui音效
function SoundManager:play_ui_effect(id, loop)
	local strSound = ssound_effect.ui[id]
	if strSound then
		-- return AudioManager:playEffect(string.format("%s%s.mp3",ui_path,strSound), loop)
	end
end

--播放角色音效
function SoundManager:play_role_effect(job, id, loop)
	local strSound = ssound_effect.role[job]
	if strSound then
		local mp3 = strSound[id]
		-- return AudioManager:playEffect(string.format("%s%d/%s.mp3",role_path,job,mp3), loop)
	end
end

local partner_sound_ID_tab = {}
local partner_delay_call = {}
--播放伙伴音效
function SoundManager:play_partner_effect(id, loop)
	--播放剧情是屏蔽伙伴语音
	if SMovieClientModel:get_isMove() then
		return nil,0
	end
	local strSound = ssound_effect.partner[id]
	if strSound then
		if type(strSound) == "table" then
			local delay = 0
			partner_delay_call[id] = {}
			partner_sound_ID_tab[id] = {}
			for i=1,#strSound do
				local sound = strSound[i]
				if sound then
					local function call_back(  )
						partner_delay_call[id][i] = nil	
						-- partner_sound_ID_tab[id][i] = AudioManager:playEffect(string.format("%s%s.mp3",partner_path,sound.path),loop),0
					end
					partner_delay_call[id][i] = callback:new();
					partner_delay_call[id][i]:start(sound.delay,call_back);
					delay = delay+sound.delay
				end	
			end
			return nil,delay
		else
			-- partner_sound_ID_tab[id] = AudioManager:playEffect(string.format("%s%s.mp3",partner_path,strSound),loop)
			return partner_sound_ID_tab[id],0
		end
	end
	return nil,0
end

--关闭伙伴音效
function SoundManager:close_partner_effect(id)
	if partner_delay_call[id] then
		for k,v in pairs(partner_delay_call[id]) do
			v:cancel()
		end
		partner_delay_call[id] = nil
	end
	if partner_sound_ID_tab[id] and type(partner_sound_ID_tab[id]) == "table" then
		for k,v in pairs(partner_sound_ID_tab[id]) do
			AudioManager:stopEffect(v)
		end
		partner_sound_ID_tab[id] = nil
	elseif partner_sound_ID_tab[id] then
		AudioManager:stopEffect(partner_sound_ID_tab[id])
		partner_sound_ID_tab[id] = nil
	end
end

--播放skill音效
function SoundManager:play_skill_effect(id, loop, handle)
	--屏蔽其他玩家的音效
	if handle ~=EntityManager:get_player_avatar_handle() then
		return
	end

	if  chat_record_flag then
		return
	end 
	
	local strSound = ssound_effect.skill[id]
	if strSound then
		-- return AudioManager:playEffect(string.format("%s%s.mp3",skill_path,strSound), loop or false)
	end
end

--播放剧情声音
function SoundManager:play_movie_effect(id, loop, job,pathName)
	local strSound = 0
	local path = ""
	if job then --说明是主角
       strSound = ssound_effect.movie[job][id]
	end

-- 	local ui_path = "sound/ui/"
-- local scene_path = "sound/scene/"
-- local skill_path = "sound/skill/"
-- local other = "sound/other/"
-- local movie_path = "sound/movie/"
-- local movie_scene_path = "sound/moviebg/"
-- local role_path = "sound/role/job"
-- local partner_path = "sound/partner/"

	if pathName then
		if pathName =="ui" then
			strSound = ssound_effect.ui[id]
			path = ui_path
		elseif pathName =="scene" then
			strSound = ssound_effect.scene[id]
			path = scene_path
		elseif pathName =="skill" then
			strSound =  ssound_effect.skill[id]
			path = skill_path	
		elseif pathName =="moviebg" then
			strSound = ssound_effect.moviebg[id]
			path = movie_scene_path
		elseif pathName =='partner' then
			 strSound = ssound_effect.partner[id]
			 path = partner_path
		end
	end
	if strSound then
	   -- print("语音文件地址",string.format("%s%s.mp3",path,strSound))
	   -- return	AudioManager:playEffect(string.format("%s%s.mp3",path,strSound), loop or false)
	else
		print("地址不对?path strSound",path,strSound)
	end
end

--主角音效对应表
local role_vocie_arr = {
---------------风刀--------------------
	[1] = { --jobid 职业ID  
        [1] = {  --类型  选人/胜利
            [1] = 101,
            [2] = 102,
         },
        [2] = { --类型  普攻/释放技能
            [1] = 103,
            [2] = 104,
            [3] = 105,
            [4] = 106,
        },
        [3] = { --类型  XP 技能
           [1] = 107,
        }
    },

---------------霜剑--------------------

    [2] = { --jobid 职业ID
        [1] = {  --类型  选人/胜利
            [1] = 108,
            [2] = 109,
         },
        [2] = { --类型  普攻/释放技能
            [1] = 110,
            [2] = 111,
            [3] = 112,
            [4] = 113,
        },
        [3] = { --类型  XP 技能
           [1] = 114,
        }
    },

---------------灵狐--------------------

    [3] = { --jobid 职业ID
        [1] = {  --类型  选人/胜利
            [1] = 115,
            [2] = 116,
         },
        [2] = { --类型  普攻/释放技能
            [1] = 117,
            [2] = 118,
            [3] = 119,
            [4] = 120,
        },
        [3] = { --类型  XP 技能
           [1] = 121,
        }
    },

---------------瑶姬--------------------

    [4] = { --jobid 职业ID
        [1] = {  --类型  选人/胜利
            [1] = 122,
            [2] = 123,
         },
        [2] = { --类型  普攻/释放技能
            [1] = 124,
            [2] = 125,
            [3] = 126,
            [4] = 127,
        },
        [3] = { --类型  XP 技能
           [1] = 128,
        }
    },
}

--job主角职业  type语音类型
function SoundManager:play_role_vocie_effect(job, type, id, loop, zyx, handle)
	local  play = false
	if not zyx then
		play = true
	else
		local value = math.random(1,10)
		if value <= zyx then
			play = true
	    else
	    	play = false
	    end
	end

	--屏蔽其他玩家的音效
	if handle then
		if handle ~=EntityManager:get_player_avatar_handle() then
			return
		end
	end
	if play then
		local voiceid = role_vocie_arr[job][type][id]
		if voiceid then
			return SoundManager:play_partner_effect(voiceid,loop)
		end
	end
end


--播放other音效
function SoundManager:play_other_effect(id, loop)
	-- local strSound = ssound_effect.ui[id]
	-- if strSound then
	-- 	AudioManager:playEffect(string.format("%s%s.mp3",ui_path,strSound), loop)
	-- end
end

function SoundManager:chat_record_effct()
	-- xprint("设置赢连")
	if SetSystemModel:get_date_value_by_key(SetSystemModel.MUSIC_VOLUME) ~= 0 then
			SoundManager:setBackgroundMusicVolume(0.01)
	end
	chat_record_flag = true
end

function SoundManager:chat_back_effct()
	-- xprint("还原音量")
	SetSystemModel:set_bg_music_volume()
	chat_record_flag = false
end