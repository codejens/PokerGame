-- WorldBossWin.lua
-- created by hwl 2015-4-1
-- 世界boss预警窗口

super_class.WorldBossWin(Window)

local _winShowY = {205, 125}

local btn_table = {};
local btn_text_table = {};

local animation_time = 0.8;
local d_width = 240 --每个panel的间隔
local _refWidth =  UIScreenPos.relativeWidth
local _refHeight = UIScreenPos.relativeHeight

local boss_name = Lang.wanfadating[15]
local panel_tab = {}
function WorldBossWin:calculate_pos(i)
	return _refWidth(1.0) - (i) * d_width
end
function WorldBossWin:show( boss_id, remain_time )
	-- 玩家在新手体验副本中时,不弹出提示按钮
	local curSceneId = SceneManager:get_cur_scene()
	if curSceneId == 27 then
		return
	end

	-- 创建通用购买面板
	local win = UIManager:show_window("world_boss_win");
	if ( win ) then
		win:create_panel( boss_id, remain_time );
	end
end

function WorldBossWin:move_panel( )
	for i, temp in ipairs(panel_tab) do
		local m_x = self:calculate_pos(#panel_tab - i + 1)
		local move_to = CCMoveTo:actionWithDuration( 0.5,CCPoint(m_x,0) );
		temp.view:runAction(move_to)
	end
end

function WorldBossWin:is_exist(boss_id)
	for i, v in ipairs(panel_tab) do
		if v.boss_id == boss_id then return true end
	end
	return false
end

function WorldBossWin:del_panel( boss_id )
	for i, temp in ipairs(panel_tab) do
		if temp.boss_id == boss_id then
			if temp.timer then
				temp.timer:cancel()
				temp.timer = nil
			end
			temp.view:removeFromParentAndCleanup(true)
			table.remove(panel_tab, i)
			self:move_panel()
			break
		end
	end
end
function WorldBossWin:__init()

	-- 副本配置数据
	local fuben_list_data = ActivityModel:get_world_boss_activity_info(  )
	self._fuben_list_data = fuben_list_data

	self.view:setDefaultMessageReturn(false)
	self.dissmiss_callback = callback:new()
end

function WorldBossWin:create_panel(boss_id, remain_time)
	if self:is_exist(boss_id) then return end
	local player = EntityManager:get_player_avatar()
	remain_time = remain_time or 180
	local boss_data = self._fuben_list_data[boss_id]
	if boss_data and player.level >= boss_data.level then
		local temp = {}
		-- local boss_data = self._fuben_list_data[boss_id]
		local panel = CCBasePanel:panelWithFile(_refWidth(1.0), 0, 240, 210, UILH_COMMON.bottom_bg, 500, 500)
		self.view:addChild(panel)
		panel:setDefaultMessageReturn(true)
		ZImage:create(panel, UILH_COMMON.normal_bg_v2, 0, 0, 240, 210, 0, 500, 500)
		local portrait_bg = ZImage:create(panel, UILH_NORMAL.item_bg3, 75, 115, 85, 85)
		local portrait = ZImage:create(panel, UILH_ACTIVITY.boss_path .. boss_id .. ".png", 81, 121, 72, 72)
		local details = MUtils:create_ccdialogEx(panel, string.format(Lang.boss[1], boss_name[boss_id]), 15, 92, 215, 40, 30, 15, ADD_LIST_DIR_DOWN)
		details:setAnchorPoint(0, 0.5)
		temp.view = panel
		temp.boss_id = boss_id
		panel_tab[#panel_tab + 1] = temp
		local function close_func( ... )
			self:del_panel(boss_id)
		end
		local exit_btn = ZButton:create(panel, UILH_COMMON.close_btn_z, close_func, 175, 145, 60, 60)
		local function goto_func()
			local fb_id = SceneManager:get_cur_fuben()
			if fb_id ~= 0 then
				return GlobalFunc:create_screen_notic(Lang.boss[2])
			end
			local item_data = self._fuben_list_data[boss_id]
			if not item_data then
				return 
			end
			ActivityModel:go_to_scene( item_data.sceneId, item_data.teleportX, item_data.teleportY, false )
			self:del_panel(boss_id)
			-- UIManager:hide_window("activity_Win")
		end
		local btn_goto = ZTextButton:create(panel, LH_COLOR[2] .. Lang.boss[3], UILH_COMMON.lh_button2, goto_func, 15, 11, -1, -1)
		local function tele_func()
			local fb_id = SceneManager:get_cur_fuben()
			if fb_id ~= 0 then
				return GlobalFunc:create_screen_notic(Lang.boss[2])
			end
			local item_data = self._fuben_list_data[boss_id]
			if not item_data then
				return 
			end
			ActivityModel:go_to_scene( item_data.sceneId, item_data.teleportX, item_data.teleportY, true )
			self:del_panel(boss_id)
		end
		local btn_tele = ZTextButton:create(panel, LH_COLOR[2] .. Lang.boss[4], UILH_COMMON.lh_button2, tele_func, 125, 11, -1, -1)
		self:move_panel( )
		local function del_func()
			self:del_panel(boss_id)
		end
		temp.timer = callback:new()
		temp.timer:start(remain_time, del_func)
	end
end

function WorldBossWin:destroy()
	Window.destroy(self);
	panel_tab = {}
end