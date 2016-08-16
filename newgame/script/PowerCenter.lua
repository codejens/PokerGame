
PowerCenter = {}

local OperationIntervel = 10

function PowerCenter:init()
	self.fps = 60
	self.mode = nil
	self.avatar_mode = nil
	self.profile_callback = callback:new()
	self.last_profile = nil
	self.touchtime = 0
	self.touch_callback = callback:new()
	self.enable = false
	self.basefps = 60
end

function PowerCenter:set_enable(e)

	if not e then
		self:setFPS(self.basefps)
		MenusPanel:setBatteryVisible(false)
	else
		MenusPanel:setBatteryVisible(true)
	end
	self.enable = e
end

function PowerCenter:setMode(mode)
	
	if not self.enable then
		return 
	end

	if self.mode == mode then
		return
	end

	self.mode = mode

	if mode == 'checkupdate' then
		self:checkUpdateMode()

	elseif mode == 'download' then
		self:downloadMode()

	elseif mode == 'startLogin' then
		self:startLoginMode()

	elseif mode == 'login' then
		self:loginMode()

	elseif mode == 'scene' then
		self:gameMode()
	end
end

--获取更新阶段，30后台动画
function PowerCenter:checkUpdateMode()
	self:setFPS(60)
end

--下载解压阶段，8帧，动画关闭，显示节能模式
function PowerCenter:downloadMode()
	self:setFPS(8)
	UpdateWin:downloadMode()
end

--登录界面60帧
function PowerCenter:loginMode()
	self:setFPS(60)
end

--第一次进入登录界面60帧
function PowerCenter:startLoginMode()
	UpdateWin:startLoginMode()
	self:setFPS(60)
end

--游戏模式TODO，根据玩家保存设置，默认high
function PowerCenter:gameMode()
	self:mid()
end

function PowerCenter:set_avatar_mode(action_id)
end

function PowerCenter:low()
	self:setFPS(16)
end

function PowerCenter:mid()
	self:setFPS(30)
end

function PowerCenter:high()
	self:setFPS(60)
end

function PowerCenter:setFPS(fps)
	--print('PowerCenter:setFPS',fps)
	if self.fps == fps or not self.enable then
		return
	end
	setAnimationInterval(1.0 / fps)
	self.fps = fps
end

local LowestProfile = {} 
local LowProfile = {}
local MidProfile = {}
local HighProfile = {}
local HighestProfile = {}


function LowestProfile:set()
	PowerCenter:setFPS(24)
	MenusPanel:setBatteryState(0)
	--print('@LowestProfile')
end

function LowProfile:set()
	PowerCenter:setFPS(30)
	MenusPanel:setBatteryState(0)
	--print('@LowProfile')
end

function MidProfile:set()
	PowerCenter:setFPS(36)
	MenusPanel:setBatteryState(1)
	--print('@MidProfile')
end

function HighestProfile:set()
	PowerCenter:setFPS(60)
	MenusPanel:setBatteryState(2)
	--print('@HighestProfile')
end

function HighProfile:set()
	PowerCenter:setFPS(45)
	MenusPanel:setBatteryState(2)
	--print('@HighProfile')
end

local Profiles = 
{
	['lowest']	= LowestProfile,
	['low']		= LowProfile,
	['mid']		= MidProfile,
	['highest']	= HighestProfile,
	['high']    = HighProfile,
}

local SkipWindow = 
{
	dazuo_win = true
}

function PowerCenter:setPorfile(p, time)

	if not self.enable then
		return
	end

	if self.last_profile == p then
		return
	end

	if self.profile_callback:isIdle() then
		if self.profile == p then
			return
		end
	else
		self.profile_callback:cancel()
	end
	
	time = time or 1.0

	self.last_profile = p

	self.profile_callback:start(time, function() 
										Profiles[self.last_profile]:set() 
										self.last_profile = nil  
										self.profile = p
									  end)
end
--角色站立
function PowerCenter:OnAvatarStand()
	if  self.touchtime - os.clock() > 0 then
		return
	end	
	self:setPorfile('low')
end

--玩家做出操作
function PowerCenter:OnPlayerTakeAction()
	self:setPorfile('highest',0)
end

--角色打坐
function PowerCenter:OnAvatarDazuo()
	self:setPorfile('lowest')
end

--角色自动寻路中
function PowerCenter:OnAIMove()
	if  self.touchtime - os.clock() > 0 then
		return
	end	
	self:setPorfile('low')
end

--角色自动打怪
function PowerCenter:OnAIFight()
	if  self.touchtime - os.clock() > 0 then
		return
	end	
	self:setPorfile('mid')
end

--角色跟随
function PowerCenter:OnAIFollow()
	if  self.touchtime - os.clock() > 0 then
		return
	end	
	self:setPorfile('low')
end

function PowerCenter:OnTouchBegin()
	if self.fps < 40 then
		self:setPorfile('high',0.05)
		self.touchtime = os.clock() + OperationIntervel
		self.touch_callback:cancel()
		self.touch_callback:start(OperationIntervel + 1, function() self:CheckState() end )
	end
end

function PowerCenter:OnTouchEnd()
	if self.fps < 40 then
		self:setPorfile('high',0.05)
		self.touchtime = os.clock() + OperationIntervel
		self.touch_callback:cancel()
		self.touch_callback:start(OperationIntervel + 1, function() self:CheckState() end )
	end
end

function PowerCenter:CheckState()
	if not self.enable then
		return
	end

	local player = EntityManager:get_player_avatar()
	if player.isDazuo then
		PowerCenter:OnAvatarDazuo();
		return
	end


	local _current_command_state = AIManager:get_state()
	if ( _current_command_state == AIConfig.COMMAND_GUAJI or _current_command_state == AIConfig.COMMAND_FUBEN_GUAJI ) then
		-- 显示自动打怪中
		if PowerCenter then
			PowerCenter:OnAIFight()
		end
	elseif ( _current_command_state == AIConfig.COMMAND_FOLLOW ) then
		-- 显示自动跟随中
		if PowerCenter then
			PowerCenter:OnAIFollow()
		end

	elseif (  _current_command_state == AIConfig.COMMAND_DO_QUEST or _current_command_state == AIConfig.COMMAND_ASK_NPC or _current_command_state == AIConfig.COMMAND_ENTER_SCENE or _current_command_state == AIConfig.COMMAND_ENTER_FUBEN) then
		-- 显示自动寻路中
		if PowerCenter then
			PowerCenter:OnAIMove()
		end
	end

end