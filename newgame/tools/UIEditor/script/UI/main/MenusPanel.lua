-- MenusPanel.lua
-- create by hcl on 2012-12-1
-- 功能菜单面板

super_class.MenusPanel(Window)

-- added by aXing on 2014-6-9
-- 定义主菜单按钮
MenusPanel.MENU_BAG         = 1         -- 背包按钮
MenusPanel.MENU_PET         = 2         -- 伙伴按钮
MenusPanel.MENU_FORGE       = 3         -- 炼器按钮 
MenusPanel.MENU_MOUNT       = 4         -- 坐骑按钮
MenusPanel.MENU_WING        = 5        -- 翅膀
MenusPanel.MENU_GUILD       = 6         -- 军团按钮
MenusPanel.MENU_MALL        = 7        -- 商城按钮
MenusPanel.MENU_FRIEND      = 8         -- 好友按钮
MenusPanel.MENU_SKILL       = 9        -- 技能

local _SYSTEM_ICON_PATH = {
		[MenusPanel.MENU_MALL]        = UILH_MAIN[1],            -- 商城
		[MenusPanel.MENU_FORGE]     = UILH_MAIN[2],            -- 炼器
		[MenusPanel.MENU_MOUNT]        = UILH_MAIN[3],            -- 坐骑
		[MenusPanel.MENU_SKILL]        = UILH_MAIN[4],            -- 技能
		[MenusPanel.MENU_BAG]     = UILH_MAIN[5],            -- 背包
		[MenusPanel.MENU_GUILD]        = UILH_MAIN[6],            -- 公会
		[MenusPanel.MENU_WING]     = UILH_MAIN[7],            -- 翅膀
		[MenusPanel.MENU_FRIEND]     = UILH_MAIN[8],            -- 好友
		[MenusPanel.MENU_PET]      = UILH_MAIN[9],            -- 伙伴
	}
local _SYSTEM_ICON_PATH_BG = {
		[MenusPanel.MENU_MALL]        = UILH_MAIN.light_bg1,            -- 商城
		[MenusPanel.MENU_FORGE]     = UILH_MAIN.light_bg2,            -- 炼器
		[MenusPanel.MENU_MOUNT]        = UILH_MAIN.light_bg3,            -- 坐骑
		[MenusPanel.MENU_SKILL]        = UILH_MAIN.light_bg4,            -- 技能
		[MenusPanel.MENU_BAG]     = UILH_MAIN.light_bg5,            -- 背包
		[MenusPanel.MENU_GUILD]        = UILH_MAIN.light_bg6,            -- 公会
		[MenusPanel.MENU_WING]     = UILH_MAIN.light_bg7,            -- 翅膀
		[MenusPanel.MENU_FRIEND]     = UILH_MAIN.light_bg8,            -- 好友
		[MenusPanel.MENU_PET]      = UILH_MAIN.light_bg9,            -- 伙伴
	}

local _MAX_MENU_BTN = 9

local anger_index = 1

local dialogParent = nil
-- 系统信息
local sys_dialog = nil
-- 聊天栏的ccdialog
-- local chat_dialog = nil;
-- 聊天栏的ccdialog_bg
local chat_dialog_bg = nil;
------
local chat_cur_timer = 0
local chat_timer_run_type = 0

local battery_icon = nil
local battery_state = 2

local signal_icon = nil
local signal_state = 0
local latency = 0
local maxNearbyNPCCount = 3
local TYCID =3--3-- 11 -- 天元城地图ID
local WEN_QUAN = 1077
local tsort = table.sort

local _refWidth =  UIScreenPos.relativeWidth
local _refHeight = UIScreenPos.relativeHeight

local _skillPanelPosX = _refWidth(1.0)
local _npcPanelPosX = _refWidth(1.0)
local _buttonBackWidth = _refWidth(1.0)
local _skillPanelWidth = _refWidth(1.0)


local MAX_NORMAL_SKILLS = 4
local SUPER_SKILL_0 = 5

local _dialogSize = { 300, 75 }
local _dialogShowY = {100,20}
local _dialogHideY = -140
local _dialogDelay = 10.0
local _dialogShowX = 0.45

--成就提示框
local achieve_win  = nil
local _achieveSize = {370,110} 

-- 按钮功能定义
local MENU_FUNCTION_MAP =
{
	-- [MenusPanel.MENU_AVATAR]    = function()  UIManager:toggle_window("user_equip_win") end,
	[MenusPanel.MENU_BAG]       = function()  
	UIManager:toggle_window("user_equip_win")
	UIManager:toggle_window("bag_win")     

	-- UIManager:show_window("day_chongzhi")

-- 副本结算测试数据  
--       local  fuben_result = {}
--                                              --测试数据
--     fuben_result.player_chest_index = 3
--     fuben_result.chests_num =  3
--     fuben_result.elapsed_time = 3 
--     fuben_result.chests = {}
    
--     local  test_chest = {}
--     test_chest.itemId = 18510
--     test_chest.count = 1

--     table.insert(fuben_result.chests,test_chest)

--      test_chest.itemId = 18730
--     test_chest.count = 1
--  table.insert(fuben_result.chests,test_chest)
--      test_chest.itemId = 28231
--      test_chest.count = 1
--  table.insert(fuben_result.chests,test_chest)


--     fuben_result.grade =  1 
--     fuben_result.fubenId  = 8 


--     fuben_result.items = {}
--     local test_item = {}
--     test_item.itemId = 28231
--     test_item.count = 1
--     table.insert( fuben_result.items,test_item)


--     fuben_result.real_grade = 0
--     fuben_result.real_grade_array={}

--     fuben_result.pingji_grade = 0
--     fuben_result.pingji_grade_array={}

--     fuben_result.drug_grade = 0
--     fuben_result.drug_grade_array={}
-- UniqueSkillFBResultWin:set_is_unique(false)
-- local win = UIManager:show_window("us_fb_result_win")
-- 	if win then
-- 		-- win:active(true,false)
-- 		-- for k,v in pairs(fuben_result) do
-- 		-- 	print(k,v)
-- 		-- end
--     	-- win:create_succss_panel(fuben_result)
--     	win:create_succss_panel2(fuben_result)
--     end 





									end,
	[MenusPanel.MENU_FRIEND]    = function()  
	UIManager:toggle_window("friend_win")
										local friend_win =  UIManager:find_visible_window("friend_win")
										if friend_win ~= nil then
											friend_win:open_friend_win()
										end
            
							    end,

	[MenusPanel.MENU_MOUNT]     = function()  UIManager:toggle_window("mounts_win_new") end,
	[MenusPanel.MENU_FORGE]     = function()  UIManager:toggle_window("forge_win") end,
	[MenusPanel.MENU_GUILD]     = function()  UIManager:toggle_window("guild_win") end,
	[MenusPanel.MENU_PET]       = function()  UIManager:toggle_window("pet_win") end,
	-- [MenusPanel.MENU_TRANSFORM] = function()  UIManager:toggle_window("transform_left") --[[变身]] end,
	-- [MenusPanel.MENU_GENIUS]    = function()  UIManager:toggle_window("elfin_left_win")--[[精灵 式神]]  end,
	-- [MenusPanel.MENU_DREAMLAND] = function()  DreamlandModel:set_dreamland_type(DreamlandModel.DREAMLAND_TYPE_XY)
	--                                     UIManager:toggle_window("dreamland_win"); end,
	[MenusPanel.MENU_MALL]      = function()  UIManager:toggle_window("mall_win") end,
	-- [MenusPanel.MENU_RENDOUTAI]      = function()  UIManager:toggle_window("doufatai_win") end,
	-- [MenusPanel.MENU_NINJAEXAM]      = function()  UIManager:toggle_window("dujie_win") end,
	-- [MenusPanel.MENU_RANKLIST]      = function()  UIManager:toggle_window("top_list_win") end,
	[MenusPanel.MENU_SKILL]     = function()  UIManager:toggle_window("user_skill_win") end,
	[MenusPanel.MENU_WING]      = function()    if WingModel:get_wing_item_data() then
													UIManager:toggle_window("wing_win");
													-- WingSysWin:show_other_wing(WingModel:get_wing_item_data());
												else 
													GlobalFunc:create_screen_notic( LangGameString[1450] ); -- [1450]="您现在还没有翅膀！"
												end
								end,
	-- [MenusPanel.MENU_TEAM]       = function()   print('暂未开放') end,
}

local SYS_TABLE = { 
					[MenusPanel.MENU_MOUNT]     = GameSysModel.MOUNT,
					[MenusPanel.MENU_FORGE]     = GameSysModel.ENHANCED,
					[MenusPanel.MENU_GUILD]     = GameSysModel.GUILD,
					[MenusPanel.MENU_PET]       = GameSysModel.PET,
					[MenusPanel.MENU_WING]      = GameSysModel.WING,
					-- [MenusPanel.MENU_TRANSFORM] = GameSysModel.TRANSFORM , --变身
					-- [MenusPanel.MENU_GENIUS]    = GameSysModel.GENIUS , --精灵(旧版法宝)
					-- [MenusPanel.MENU_DREAMLAND] = GameSysModel.LOTTERY,
					-- [MenusPanel.MENU_RENDOUTAI]      = GameSysModel.JJC,
					-- [MenusPanel.MENU_NINJAEXAM]      = GameSysModel.DJ,
					-- [MenusPanel.MENU_RANKLIST]      = GameSysModel.RANKLIST,
				}
					--[9] = GameSysModel.DJ };


local menu_width = 70;
local menu_height = 70
local menu_start_x = 100;
local menu_start_y = 16 + menu_height
local menu_btn_y = 0
local SKILL_SLOT_SIZE = { 60, 60 }
local ACTION_BTN_BG = UILH_MAIN.m_action_bg
local tab_anger_pos = { 117, 6 }
local SKILL_BG = UILH_MAIN.m_skill_bg
local _ry = UIScreenPos.designToRelativeHeight
local _rx = UIScreenPos.designToRelativeWidth
local ACTION_SLOT_RECT = {_skillPanelWidth - 75,340,70,70}
local tab_yp_pos = {_skillPanelWidth - 75, 270}
local tab_skill_id = {};
local _NEED_REFRESH_MAX_NUM = 5 -- 可攻击玩家列表最大数量
local near_entities = {}	-- 记录附近可攻击玩家列表
local is_need_refresh = true -- 是否需要刷新玩家列表
-- 技能面板坐标第一个是必杀，然后是4个技能
local tab_skill_pos = { _skillPanelWidth - 116, 0, 
						_skillPanelWidth - 203, 10,
						_skillPanelWidth - 198, 92,
						_skillPanelWidth - 147, 158,
						_skillPanelWidth - 71, 196,
						_skillPanelWidth - 71, 245 };

function MenusPanel:__init(window_name)
	self.menu_btn_num = 0
	self.btn_table = {}
	self.btn_pos_table = {}
	self.col_btn_t = {}
	self.col_btn_pos_t = {}
	near_entities = {}
	-- 空面板
	self.view:setDefaultMessageReturn(false)

		--成就提示框倒计时
	MenusPanel.achieve_callback = callback:new()

	-- 隐藏菜单按钮
	-- self.hide_btn = ZButton:create(self.view,UIResourcePath.FileLocate.normal  .."m_menu_hide.png",panel_fun,0,75,-1,-1);
	-- 是否显示按钮栏
	self.is_show_menus = nil;
	 -- 切换菜单,技能栏
	local function hide_menus_fun(eventType,args,msgid)
		Analyze:parse_click_main_menu_info(132)
		self:show_or_hide_panel( not self.is_show_menus );
	end
	self.hide_btn = FlipButton(0,0,90,90,
								 UILH_MAIN.hide_r_bg,
								 hide_menus_fun)
	local hide_btn_bg = ZButton:create(nil, {UILH_MAIN.hide_r, UILH_MAIN.lion_eye}, nil, 0, 0, 90, 90, nil)
	self.view:addChild(self.hide_btn.view, 10)
	self.view:addChild(hide_btn_bg.view, 10)
	hide_btn_bg:setTouchBeganReturnValue(false)
	hide_btn_bg:setTouchMovedReturnValue(false)
	hide_btn_bg:setTouchEndedReturnValue(false)
	-- self.hide_btn = ZButton:create(self.view,"ui/main/menus/menu_type1.png",hide_menus_fun,10,6,62,62)

	-- 聊天按钮
	local s = self.view:getContentSize()

	self.btn_chat = ZButton:create(self.view,UILH_MAIN.m_chat,nil, _refWidth(_dialogShowX) + _dialogSize[1]/2 + 20,10,-1,-1);

	-- 两个信息栏parent
	dialogParent = CCBasePanel:panelWithFile(_refWidth(_dialogShowX), _ry(_dialogHideY), _dialogSize[1], _dialogSize[2], UILH_COMMON.bottom_bg, 500, 500)
	dialogParent:setAnchorPoint(0.5, 0)
	self.view:addChild(dialogParent)

	-- 系统信息
	sys_dialog = CCDialog:dialogWithFile(15, 5, _dialogSize[1]-30, _dialogSize[2]-18, 5,
		 "", TYPE_HORIZONTAL, ADD_LIST_DIR_DOWN,500,500)
	sys_dialog:setGapSize(1)
	sys_dialog:setFontSize(19)
	sys_dialog:setCurState(CLICK_STATE_DISABLE)
	dialogParent:addChild(sys_dialog)
	dialogParent:setIsVisible(false)

	-- 聊天信息
	-- chat_dialog = CCDialog:dialogWithFile(0, 0, _dialogSize[1], _dialogSize[2], 5,
	--      UIPIC_BottomPanel_006, TYPE_HORIZONTAL,ADD_LIST_DIR_DOWN,500,500)
	-- chat_dialog:setGapSize(2)
	-- chat_dialog:setCurState(CLICK_STATE_DISABLE)
	-- --chat_dialog:setScaleActionFactor(1.2)
	-- dialogParent:addChild(chat_dialog);

	-- self.bottom_panel=ZImage:create(self.view,UIPIC_BottomPanel_007,0,0,_buttonBackWidth,68,0,71,67,1,1,1,1,1,1);

	-- 底部菜单栏背景panel
	self.btn_bg_panel = CCBasePanel:panelWithFile( 0, 2, _buttonBackWidth, 420, "", 500, 500 );

	self.view:addChild(self.btn_bg_panel);

	local function mirror_fun()
		local win = UIManager:toggle_window("mirror_win")
		local avater_info = EntityManager:get_nearest_entities_by_num( _NEED_REFRESH_MAX_NUM )
		near_entities = avater_info
		if win then
			win:update(near_entities)
		end
	end
	self.mirror = ZButton:create(self.view, UILH_MAIN.big_mir, mirror_fun, 10, 105, 60, 55)
	-- 创建技能面板
	self:create_skill_panel();
	-- 创建npc面板
	-- self:create_npc_panel();

	self:on_band();

	self.nearByNPCTimer = timer()
	
	self.last_use = nil
	self.most_use_table = { {1,0}, {2,0}, {3,0}, {4,0}, {5,0}, 
							{6,0}, {7,0}, {8,0}, {9,0}, {10, 0}}

	--缓存action
	self.menu_show_actions = {}
	self.menu_hide_actions = {}
	self.menu_remain_actions = {}
	self.npc_panel_actions = {}
	self.skill_show_actions = {};
	self.skill_hide_actions = {};

	MenusPanel.dialog_callback = callback:new()


	UIManager:setMainUI(3,self.view)

	self._instruction_components = {}
end


function  MenusPanel:create_achieve_win_tag(  )
	--成就提示框 added by xiehande on 2014.12.23
    -- achieve_win = CCBasePanel:panelWithFile(281,160,_achieveSize[1],_achieveSize[2],UILH_ACHIEVE.achieve_info_bg, 500,600)
    -- self.view:addChild(achieve_win)
      local _ui_root =  ZXLogicScene:sharedScene():getUINode()
    achieve_win = MUtils:create_sprite(_ui_root,"nopack/white.png",_refWidth(0.5),140,999)
    local offset_x = -185
    local achieve_bg = CCBasePanel:panelWithFile(offset_x,0,_achieveSize[1],_achieveSize[2],UILH_ACHIEVE.achieve_info_bg, 500,600)
    achieve_win:addChild(achieve_bg)

    --完成成就
    local title_bg = ZImage:create(achieve_win,UILH_ACHIEVE.achieve_titile_bg,88+offset_x,70,-1,-1)
    ZImage:create(title_bg,UILH_ACHIEVE.achieve_title,57,6,-1,-1)
    --   local title_bg = MUtils:create_sprite(achieve_win,UILH_ACHIEVE.achieve_titile_bg,88,70)
    -- MUtils:create_sprite(title_bg,UILH_ACHIEVE.achieve_title,57,6)  


    self.achieve_name = CCDialog:dialogWithFile(100+offset_x, 18, 170, _dialogSize[2]-28, 3,
		 "", TYPE_VERTICAL ,ADD_LIST_DIR_UP,500,500)
    self.achieve_name:setGapSize(1)
	self.achieve_name:setFontSize( 20 )
	self.achieve_name:setCurState(CLICK_STATE_DISABLE)
	-- self.achieve_name:setText(LH_COLOR[1].."任意一个伙伴拥有4个中级的技能")

	achieve_win:addChild(self.achieve_name)
    
    --分割线
    local line = CCZXImage:imageWithFile( 270+offset_x, 13, -1,85 , UILH_COMMON.split_line_v )
    achieve_win:addChild(line) 

    local slot_bg =  ZImage:create(achieve_win,UILH_NORMAL.light_grid,8+offset_x,9,-1,-1); 


	require "UI/component/SlotBase"
    require "utils/UI/UILabel"
    self.slot = SlotBase(64, 64);
    slot_bg.view:addChild(self.slot.view)
    self.slot:set_icon_bg_texture(UILH_COMMON.slot_bg, -11, -11, 86, 85 )   -- 背框
    -- slot:set_icon_texture( string.format("icon/achieve/%05d.pd",  std_achieve.icon or 2) );
    self.slot:set_icon_texture( string.format("icon/achieve/%05d.pd",  72) );
    self.slot.icon:setScale(1.15)
    self.slot:setPosition(15, 15)

    local right_img = ZImage:create(achieve_win,UILH_ACHIEVE.achieve_get,274+offset_x,9,-1,-1);
    self.get_num  = UILabel:create_label_1("10", CCSize(100,20), 43 , 52, 14, CCTextAlignmentCenter)
    right_img:addChild(self.get_num)
   
    -- achieve_win:setIsVisible(false)
end


function MenusPanel:destroy()
	UIManager:removeMainUI(3)
	
	self:stopCheckNearByNPC();

	for k,v in pairs(self.menu_show_actions) do
		safe_release(v)
	end

	for k,v in pairs(self.menu_hide_actions) do
		safe_release(v)
	end

	for k,v in pairs(self.menu_remain_actions) do
		safe_release(v)
	end
	for k,v in pairs(self.npc_panel_actions) do
		safe_release(v)
	end
	for k,v in pairs(self.skill_show_actions) do
		safe_release(v)
	end    
	for k,v in pairs(self.skill_hide_actions) do
		safe_release(v)
	end

	for i=1,#self.tab_skill_slot do
		self.tab_skill_slot[i]:stop_cd_animation();
	end

	-- 聊天栏的ccdialog
	-- chat_dialog = nil;
	-- 聊天栏的ccdialog_bg
	chat_dialog_bg = nil;
	sys_dialog = nil
	dialogParent = nil
	------
	chat_cur_timer = 0
	chat_timer_run_type = 0

	anger_index = 1

	tab_skill_id = {};

	self.tab_skill_slot = {};
	battery_icon = nil
	self.isShowingChatPanel = false;

	self.menu_btn_num = 0
	self.btn_pos_table = {}
	self.btn_table = {}
	self.col_btn_t = {}
	self.col_btn_pos_t = {}
	self.menu_show_actions = {}
	self.menu_hide_actions = {}
	self.skill_show_actions = {}
	self.skill_hide_actions = {}
	self.npc_panel_actions = {}
	self.menu_remain_actions = {}
	near_entities = {}
	MenusPanel.dialog_callback:cancel()
	--销毁成就提示框倒计时
	MenusPanel.achieve_callback:cancel()
	if achieve_win then
		achieve_win:setIsVisible(false)
		achieve_win:removeFromParentAndCleanup(true)
		achieve_win = nil
	end
	if self.near_timer then
		self.near_timer:cancel()
		self.near_timer = nil
	end
	if self.mirror_timer then
		self.mirror_timer:cancel()
		self.mirror_timer = nil
	end
	Window.destroy(self)

	-- print('==========menus_panel destroy==========')

end

function MenusPanel:on_band()
	-- 隐藏按钮的函数
	-- self.hide_btn:setTouchClickFun(hide_menus_fun);
	-- 聊天按钮函数
	local function btn_chat_fun(eventType,x,y)
		--mod By Shan Lu  2013/12/02 开关聊天界面
		local win = UIManager:find_window("menus_panel")
		if win and win.is_show_menus then
			win:show_or_hide_panel(false)
		end
		ChatModel:toggleChatWin()
		--UIManager:show_window("chat_win")
		-- MenusPanel:set_chat_panel_visible(false)
	end
	self.btn_chat:setTouchClickFun(btn_chat_fun)
	-- 信息面板
	--[[
	local function message_function(eventType, arg, msgid, selfItem)
		if eventType == nil or arg == nil or msgid == nil or selfItem == nil then
			return
		end
		if eventType == TIMER then
			if chat_timer_run_type == 1 then
				MenusPanel:show_chat_panel_timer_function()
			elseif chat_timer_run_type == 2 then
				MenusPanel:hide_chat_panel_timer_function()
			end
		end
		return false
	end
	chat_dialog:registerScriptHandler( message_function )
	]]--
	 -- 怒气函数
	local function btn_anger_fun(eventType,x,y)

		Instruction:handleUIComponentClick(instruct_comps.ANGER_BTN)
		
		Analyze:parse_click_main_menu_info(32)
		local player = EntityManager:get_player_avatar();
		-- 如果怒气值满了
		if ZXLuaUtils:band(player.state, EntityConfig.ACTOR_STATE_DEATH) == 0 then
			local curSceneId = SceneManager:get_cur_scene()
			if curSceneId == 27 then
				self:updateAngerBar(player.anger or 0);
				self.anger_spr.view:setTextureRect(CCRectMake(0,48,48.0,0));
                -- 取消怒气值满的特效
                LuaEffectManager:stop_view_effect( 10011,self.anger_spr.view );
				CommandManager:use_bishaji();
                AIManager:set_state( AIConfig.COMMAND_IDLE );
				return
			end
			if ( player.anger == 100 ) then
				if ( ZXLuaUtils:band(player.state, EntityConfig.ACTOR_STATE_ZANZEN) == 0  ) then
					player.anger = 0;
					-- print("使用必杀技");
					self.anger_spr.view:setTextureRect(CCRectMake(0,48,48.0,0));
					-- 取消怒气值满的特效
					LuaEffectManager:stop_view_effect( 10011,self.anger_spr.view );
					self:showDragonSprite(false)
					CommandManager:use_bishaji();
					-- 如果当前是必杀技指引
					-- if ( XSZYManager:get_state() == XSZYConfig.BISHAJI_ZY ) then 
					--     XSZYManager:destroy_jt( XSZYConfig.OTHER_SELECT_TAG );

					--     -- 指向退出副本按钮
					--     XSZYManager:play_jt_and_kuang_animation_by_id( XSZYConfig.TUICHUFUBEN_BTN ,1,XSZYConfig.OTHER_SELECT_TAG );
					-- elseif XSZYManager:get_state() == XSZYConfig.XINSHOUFUBEN_ZY then
					--     XSZYManager:destroy_jt( XSZYConfig.OTHER_SELECT_TAG );
					--     JQDH:play_animation( 16 ) 
					-- elseif ( XSZYManager:get_state() == XSZYConfig.ZXJZ_ZY ) then
					--     XSZYManager:destroy_jt( XSZYConfig.OTHER_SELECT_TAG );
					-- end
				end
			else
				GlobalFunc:create_screen_notic( "怒气值不足，不能释放" ); -- [1449]="怒气值不足，不能释放"
			end
		else
			GlobalFunc:create_screen_notic("已死亡，不能释放")
		end
	end
	self.anger_btn:setTouchClickFun(btn_anger_fun);
	-- 动作按钮函数
	-- local function action_fun( eventType,arg,msg_id)
	--     -- if eventType == TOUCH_CLICK then
	--         -- MountsModel:req_xuanyao_event(  )
	--          Analyze:parse_click_main_menu_info(33)
	--           AIManager:toggle_guaji()
	--             ZXLog("==========ddd----2222")
	--     -- end
	--     return true

	  
	   
	--     -- 大于4的是任务
	--     --[[
	--     if ( self.old_action > 4 ) then
	--         local win = UIManager:find_visible_window("npc_dialog")
	--         if ( win ) then
	--             win:do_quest_btn_function(  )
	--         end
	--     else
	--     ]]--
	--        -- print("action_time1.....................",GameStateManager:get_total_milliseconds(  ))
	--     --[[
	--     local player = EntityManager:get_player_avatar();
	--     if ( player.target_id ) then
	--         local target = EntityManager:get_entity( player.target_id )
	--         if ( target ) then 
	--             AIManager:on_selected_entity( target ,true);
	--         end
	--     else
	--         AIManager:toggle_guaji()
	--     end
	--     ]]--
		
	--     --end
	-- end
	-- self.action_btn:setTouchClickFun(action_fun)
	--[[
	local function guaji_fun()
		Analyze:parse_click_main_menu_info(69)
		-- 挂机
		if ( XSZYManager:get_state() ~= XSZYConfig.NONE ) then
			XSZYManager:destroy_jt( XSZYConfig.OTHER_SELECT_TAG );
		end
		-- 停止打坐
		DaZuoWin:stop_dazuo();
		AIManager:toggle_guaji(  );
	end
	]]--
	--self.guaji_btn:setTouchClickFun(guaji_fun);
end

function MenusPanel:do_toggle_guaji( is_guaji )

	           

	local win = UIManager:find_visible_window("menus_panel")
	if win then 

--     if self.guaji_btn then
--     	self.guaji_btn.view:setIsVisible(true)
--     else

--     	 self.guaji_btn = ZBasePanel:create(win.skill_panel.view,"",ACTION_SLOT_RECT[1],ACTION_SLOT_RECT[2],
-- 		ACTION_SLOT_RECT[3],ACTION_SLOT_RECT[4])
-- 	        self.guaji_btn.view:setAnchorPoint(1,0)
-- win.skill_panel.view:addChild(self.guaji_btn.view)
-- self.guaji_btn.view:setIsVisible(true)
--     end


		if is_guaji then
			win:change_action_btn_state(false)
-- self.guaji_btn.view:setIsVisible(true)

			local ani_speed = 0.4;
	        
			-- win.guaji_ani_spr = LuaEffectManager:playAniWithArgs( self.guaji_btn.view,{"nopack/ani/guaji1.png","nopack/ani/guaji2.png"},0,0,ani_speed,7)

		else
		   win:change_action_btn_state(true)
-- self.guaji_btn.view:setIsVisible(false)
		   		local ani_speed = 0.4;

			-- 	if win.guaji_ani_spr then
			--    win.guaji_ani_spr:removeFromParentAndCleanup(true);
			--    win.guaji_ani_spr = nil;
			-- end

		end
	end
end

-- 初始化按钮有哪几个
local _INIT_MENU_BUTTONS = {
	MenusPanel.MENU_BAG,
	MenusPanel.MENU_FRIEND,
	MenusPanel.MENU_MALL,
	MenusPanel.MENU_SKILL,
}

local _COL_MENUT_BUTTONS = {
	[MenusPanel.MENU_FRIEND] = true,
	[MenusPanel.MENU_SKILL] = true,
	-- [MenusPanel.MENU_RANKLIST] = true,
}

-- 初始化按钮
-- 1 商城，2 炼器，3 坐骑 ，4 技能 ,5 背包,6 军团,7组队 ,8好友, 9伙伴
-- 按钮对应的系统id
-- 保存所有按钮
function MenusPanel:create_btns()
	local x = menu_start_x
	for i=1, _MAX_MENU_BTN do
		-- 为了排序需要，对 btn_table index进行初始化
		self.btn_table[i] = false
		-- 检查是否初始化
		local is_init = false
		for k,v in pairs(_INIT_MENU_BUTTONS) do
			 if i == v then
				is_init = true
				break
			end
		end
		-- 检查是否已开启
		local system_id = SYS_TABLE[i]
		local system_enable = system_id and GameSysModel:isSysEnabled(system_id, false)
		-- 创建
		if is_init or system_enable then
			self:create_btn( i, x )
		end 
	end
	self:sort_btns()
	self.btn_table[MenusPanel.MENU_MALL]:setIsVisible(true)
	-- 因为第一次进入游戏的时候，切换场景的协议调用在MenusPanel的创建之前
	-- 所以在MenuPanel创建完成后，再根据场景重新调整布局
	self.is_show_menus = true;
	MenusPanel:on_enter_scene();
end

-- 为现有的按钮排序
function MenusPanel:sort_btns(  )
	local i, j = 1, 1
	local x = menu_start_x
	local y = menu_start_y
	-- if self.menu_btn_num > 9 then
	--     menu_width = (_refWidth(1.0) - x)/self.menu_btn_num
	-- end

	for k, btn in pairs(self.btn_table) do
		if btn then
			btn:setPosition(x, menu_btn_y)
			self.btn_pos_table[k] = {}
			self.btn_pos_table[k].x = x
			self.btn_pos_table[k].y = menu_btn_y
			x = x + menu_width
			i = i + 1
		end
	end

	for k, btn in pairs(self.col_btn_t) do
		if btn then
			btn:setPosition(3, y)
			self.btn_pos_table[k] = {}
			self.btn_pos_table[k].x = 3
			self.btn_pos_table[k].y = y
			y = y + menu_height
			j = j + 1
		end
	end
end

-- 插入一个按钮
function MenusPanel:insert_btn( index )
	
	-- 如果这个按钮已经存在，直接返回
	if self.btn_table[ index ] then 
		return false;
	end

	-- local x = menu_start_x + (index - 1) * menu_width
	self:create_btn( index )
	self:sort_btns()

	-- 后面的按钮action都要重新设置self.btn_pos_table[i]里面的pos_x，然后删除action
	if not self.is_show_menus then
		self.btn_table[index]:setPosition(0,0);
		self.btn_table[index]:setIsVisible(false);
	end

	for i = index + 1 ,_MAX_MENU_BTN do
		if self.btn_table[ i ]  then
			local savedAction = self.menu_show_actions[i]
			if savedAction then
				safe_release(savedAction)
			end
			self.menu_show_actions[i] = nil
		end
	end
  
	return true
end

-- 创建一个按钮
function MenusPanel:create_btn( index )
	local path_bg = _SYSTEM_ICON_PATH_BG[index]
	local path = _SYSTEM_ICON_PATH[index]
	local function btn_func(eventType,x,y)
		if  eventType == TOUCH_CLICK then
			self:doMenuFunction(index);
		end
		return true
	end
	local btn_panel = CCBasePanel:panelWithFile(0, 0, 70, 70, "")
	self.btn_bg_panel:addChild(btn_panel)
	local beg_x, beg_y = -6, -5
	if index == MenusPanel.MENU_PET then
		beg_x, beg_y = -3, -6
	elseif index == MenusPanel.MENU_FRIEND then
		beg_x, beg_y = -7, -6
	elseif index == MenusPanel.MENU_WING then
		beg_x, beg_y = -4, -6
	end
	local btn_bg = ZImage:create(btn_panel, path_bg, beg_x, beg_y, 80, 80)
	local btn = MUtils:create_btn(btn_panel, path, path, btn_func, 0, 0, 70, 70);
	btn_panel:addChild(btn.view)
	if _COL_MENUT_BUTTONS[index] then
		self.col_btn_t[index] = btn_panel
	else
		self.btn_table[index] = btn_panel
		self.menu_btn_num = self.menu_btn_num + 1
	end
	self:sort_btns()

	self._instruction_components[instruct_comps.MENU_BUTTON_BASE + index] = { view = btn_panel }
end


function MenusPanel:doMenuFunction(index)
	Analyze:parse_click_main_menu_info(index)
	--Analyze:parse_click_menu_panel_info(index)

	-- 1 人物，2 背包，3好友 ，4 坐骑 , 5炼器,6家族, 7宠物 ,8变身, 9小精灵, 10 梦境, 11 商城, 15 技能
	local window_name = nil;
	if index ~= _MAX_MENU_BTN then
		local last_most = self.most_use
		
		for k, v in ipairs(self.most_use_table) do
			if v[1] == index then
				v[2] = v[2] + 1
				break
			end
		end

		tsort(self.most_use_table,function(a,b) return a[2] > b[2] end)

		self.most_use = self.most_use_table[1][1]
		self.last_use = index

		if self.last_use == self.most_use then
			if self.most_use_table[2][2] > 0 then
				self.most_use = self.most_use_table[2][1]
			end
		end
	end
	Instruction:handleUIComponentClick(instruct_comps.MENU_BUTTON_BASE + index)
	MENU_FUNCTION_MAP[index]()
	
end



-- 取得当前是否在运动中
function MenusPanel:get_is_running_action()
	local action_num = self.view:numberOfRunningActions();
	if ( action_num > 0 ) then
		return true;
	end
	return false;
end

function MenusPanel:set_chat_panel_text(text, is_sys)
	local is_hide = SetSystemModel:get_date_value_by_key( SetSystemModel.NOT_SHOW_MAIN_PANEL_INFOMATION )
	if not is_hide == true then

		MenusPanel:show_chat_panel()
		--local temp_info = ChatModel:format_chat_right_panel_info(text, is_sys)
		--print('>>', text)
		-- chat_dialog:setText(text);
	end
end

function MenusPanel:setDialogInfo( text, is_sys )
	local is_hide = SetSystemModel:get_date_value_by_key(SetSystemModel.NOT_SHOW_MAIN_PANEL_INFOMATION)
	if is_hide then
		return
	end

	local win = UIManager:find_visible_window("menus_panel")
	if not win then
		return
	end

	if is_sys then
		dialogParent:setIsVisible(true)
		win:showSysInfo()
		win:setSysInfoText(text)
	else
		-- win:setChatInfoText(text)
	end
end

-- 设置在主屏显示的聊天信息
function MenusPanel:setChatInfoText( text )
	-- chat_dialog:setText(text)
end

-- 设置在主屏显示的系统信息
function MenusPanel:setSysInfoText( text )
	sys_dialog:setText(text)
end

--设置成就提示
function MenusPanel:setAchieveInfo( achieve_id )
	local win = UIManager:find_visible_window("menus_panel")
	if not win then
		return
	end
	if achieve_win then
		achieve_win:setIsVisible(false)
		achieve_win = nil
	end
	win:create_achieve_win_tag()
	achieve_win:setIsVisible(true)
	win:showAchieveInfo()
	win:setAchieveInfoText(achieve_id)
end

--成就提示显示动画
function MenusPanel:showAchieveInfo(  )
    
    LuaEffectManager:stop_view_effect( 16,achieve_win )
	LuaEffectManager:play_view_effect( 16,_refWidth(0.5)-490,54,achieve_win ,false);

			    --播放成就音效
    SoundManager:playUISound('achieve',false)

	--停止所有动作
	-- achieve_win:stopAllActions()
    
    --淡入
	-- local fadeIn = CCFadeIn:actionWithDuration(3)
	-- achieve_win:runAction(fadeIn)
-- local fadeIn = CCScaleTo:actionWithDuration(0.5, 1, 1)
	-- local fade_out = CCFadeOut:actionWithDuration(3);
    -- local fade_in =  CCFadeIn:actionWithDuration(3);
	-- local array = CCArray:array();

	-- array:addObject(fade_out);
		-- array:addObject(fade_out);
	-- local seq = CCSequence:actionsWithArray(array);
	-- local action = CCRepeatForever:actionWithAction(seq);

	-- achieve_win:runAction(fadeIn)

	self.achieve_callback:cancel()
	self.achieve_callback:start(3, function( )
		-- local fadeOut = CCFadeOut:actionWithDuration(1.5)
		-- local fadeOut = CCScaleTo:actionWithDuration(0.5, 1, 0)
		-- achieve_win:runAction(fadeOut)

		achieve_win:setIsVisible(false)
		achieve_win:removeFromParentAndCleanup(true)
		achieve_win = nil
	end)
end


--设置文字
function MenusPanel:setAchieveInfoText(achieve_id)
   local std_achieve = AchieveConfig:get_achieve( achieve_id )
   self.achieve_name:setText("")
   self.achieve_name:setText(LH_COLOR[1]..std_achieve.name)
    -- std_achieve.icon
   self.slot:set_icon_texture( string.format("icon/achieve/%05d.pd",  std_achieve.icon or 2) );
   self.get_num:setString(std_achieve.conds[1].count)
    
end

-- 设置私聊按钮显示
function MenusPanel:set_chat_panel_visible(visible)
	local if_hide_chat_panel = SetSystemModel:get_date_value_by_key( SetSystemModel.NOT_SHOW_MAIN_PANEL_INFOMATION )
	if if_hide_chat_panel then        -- 如果设置了屏蔽主屏幕公告，任何时候都隐藏
		visible = false
	end
	--chat_dialog_bg:setIsVisible(visible);
	-- chat_dialog:setIsVisible(visible);
end




-------------------------副本相关
--销毁倒计时
function MenusPanel:destroy_fuben_countdown(  )
	if self.countdownPanel ~= nil then
		self.countdownPanel:setTimer(0);
		self.countdownPanel.view:removeFromParentAndCleanup(true);
		self.countdownPanel = nil;
	end
end

-- 副本里的倒计时
function MenusPanel:show_fuben_countdown( time )
	-- 每次开始倒计时先清除一下
	self:destroy_fuben_countdown();

	self.countdownPanel = BasePanel:create(nil, 920/2-132/2, 400, 132, 108);
	self:addChild(self.countdownPanel.view);
	
	local _time = 5;
	if ( time ) then
		_time = time;
	end
	
	local number_img = CCZXImage:imageWithFile(132/2-88/2,108/2-105/2,88,105,"");
	self.countdownPanel.view:addChild(number_img);

	local function timer_tick(  )
		if _time > 0 then
			number_img:setTexture(string.format(UIResourcePath.FileLocate.lh_fuben .. "countdown_%d.png",_time));
		elseif _time == 0 then
			number_img:removeFromParentAndCleanup(true);
			local began_img = CCZXImage:imageWithFile(0,0,132,108,UIResourcePath.FileLocate.lh_fuben .. "countdown_began.png");
			self.countdownPanel.view:addChild(began_img) 
		elseif _time < 0 then
			self:destroy_fuben_countdown();
		end
		_time = _time - 1;
	end

	self.countdownPanel:setTouchTimerFun(timer_tick);
	self.countdownPanel:setTimer(1);

end

-- 诛仙阵掉落宝箱
function MenusPanel:show_chest_in_fuben(  )
	--宝箱按钮
	local chest_btn = CCNGBtnMulTex:buttonWithFile(400,240, 82, 70, UILH_AWARD.baoxiang)
	-- chest_btn:addTexWithFile(CLICK_STATE_DOWN, UILH_FUBEN.chest_s)
	local function open_chest( eventType,x,y )
		if eventType == TOUCH_CLICK then
			FuBenModel:open_chest_in_fuben();
			chest_btn:removeFromParentAndCleanup(true);
		end
		return true;
	end
	chest_btn:registerScriptHandler(close_fun) 
	self:addChild(chest_btn)
end
-----------------副本相关end----------------------


function MenusPanel:show_chat_panel()
	--print("run MenusPanel:show_chat_panel")
	--chat_timer_run_type = 1
	--chat_dialog:setTimer(0.02)
	local win = UIManager:find_window("menus_panel")

	win.isShowingChatPanel = true;
	-- chat_dialog:stopAllActions()

	local res_y = 0;
	if win.is_show_menus then
		res_y = _dialogShowY[1]
	else
		res_y = _dialogShowY[2]
	end
	local p = CCPointMake(_refWidth(_dialogShowX),_ry(res_y))
	-- chat_dialog:runAction(CCMoveTo:actionWithDuration(0.5,p))
	win.dialog_callback:cancel()
	win.dialog_callback:start(_dialogDelay, 
	function()
		win.isShowingChatPanel = false;
		local p2 = CCPointMake(_refWidth(_dialogShowX),_ry(_dialogHideY))
		-- chat_dialog:runAction(CCMoveTo:actionWithDuration(0.5,p2))
	end)
end

function MenusPanel:rePosDialogPanel( )
	dialogParent:stopAllActions()

	local res_y = _dialogShowY[2]
	if self:get_is_show() then
		res_y = _dialogShowY[1]
	end

	local p = CCPointMake(_refWidth(_dialogShowX), (res_y))
	local move = CCMoveTo:actionWithDuration(0.3, p)
	dialogParent:runAction(move)
end

function MenusPanel:resPosBtnChat()
	-- self.btn_chat.view:stopAllActions()

	local res_y = _dialogShowY[2] + 10
	if self:get_is_show() then
		res_y = _dialogShowY[1] + 10
	end

	local p = CCPointMake(600, (res_y))
	local move = CCMoveTo:actionWithDuration(0.3, p)
	self.btn_chat.view:runAction(move)
end
function MenusPanel:showSysInfo( )
	self.isShowingChatPanel = true
	sys_dialog:stopAllActions()

	local fadeIn = CCScaleTo:actionWithDuration(0.5, 1, 1)
	sys_dialog:runAction(fadeIn)
	dialogParent:runAction(fadeIn)

	self.dialog_callback:cancel()
	self.dialog_callback:start(_dialogDelay, function( )
		self.isShowingChatPanel = false
		local fadeOut = CCScaleTo:actionWithDuration(0.5, 1, 0)
		sys_dialog:runAction(fadeOut)
		dialogParent:runAction(fadeOut)
	end)
end

function MenusPanel:create_skill_panel()
	self.tab_skill_slot = {};
	self.skill_panel = ZBasePanel:create(self.view,nil,_skillPanelPosX,0,_skillPanelWidth,420);
	self.skill_panel.view:setAnchorPoint(1,0)
	self.skill_panel.view:unregisterScriptHandler();
	for i=1,MAX_NORMAL_SKILLS do
		self.tab_skill_slot[i] = SlotSkill(SKILL_SLOT_SIZE[1], SKILL_SLOT_SIZE[2])
		self.tab_skill_slot[i]:setPosition( tab_skill_pos[i*2+1], tab_skill_pos[i*2+2] )
		local spr_bg = ZCCSprite:create(self.tab_skill_slot[i].view,UILH_MAIN.m_skill_bg,30,29,-1);
		--spr_bg.view:setTag(0)
		-- 技能的点击的触发事件
		local function slot_fun()
			--注册到新手指引系统 Shan Lu 
			-- Instruction:handleUIComponentClick(instruct_comps.SKILL_SLOTS_BASE + i)

			if ( tab_skill_id[i] ) then
				Analyze:parse_click_main_menu_info(31)
				local player = EntityManager:get_player_avatar();
				-- 如果玩家不在打坐状态
				if ( ZXLuaUtils:band(player.state, EntityConfig.ACTOR_STATE_ZANZEN) > 0 or  ZXLuaUtils:band(player.state, EntityConfig.ACTOR_STATE_COUPLE_ZANZEN) > 0) then
					GlobalFunc:create_screen_notic(LangGameString[1446]); -- [1446]="正在打坐中,无法释放技能"
				else
					local skill = UserSkillModel:get_a_skill_by_id( tab_skill_id[i] )
					if ( skill.cd == 0 ) then
						if ( player:check_is_enough_magic_use_skill( skill ) ) then
							local std_skill = SkillConfig:get_skill_by_id(skill.id)
							-- 群体技能不需要目标
							if std_skill.skillSpellType == SkillConfig.ST_TO_SELF then
							else
								local entity_id = EntityManager:get_can_attack_entity( player );
								if player.target_id then
									entity_id = player.target_id
								end
								if ( entity_id ) then
									local entity = EntityManager:get_entity( entity_id )
									if ( entity ) then
										player:set_target(entity);
									end
								end
							end
							CommandManager:combat_skill( skill , player );

							-- if XSZYManager:get_state() == XSZYConfig.XINSHOUFUBEN_ZY then
							--     XSZYManager:destroy_jt( XSZYConfig.OTHER_SELECT_TAG );
							-- end
						else
							GlobalFunc:create_screen_notic( LangGameString[1447] ); -- [1447]="蓝量不足!"
						end
					else
						GlobalFunc:create_screen_notic( LangGameString[1448] ); -- [1448]="技能cd中!"
					end
				end
			end
		end
		self.tab_skill_slot[i]:set_begin_event( slot_fun )

		---------------------
		--drag_obj.type类型:1=item，2=skill，3=pet
		---------------------
		local function drag_in( source_item )
			if (source_item.type == 2) then
				self.tab_skill_slot[i]:set_drag_info(1, "right_panel", source_item.obj_data);
				self.tab_skill_slot[i]:set_icon(source_item.obj_data.id);
				tab_skill_id[i] = source_item.obj_data.id;

				self:on_drag_in( self.tab_skill_slot[i],source_item.obj_data.id )

				-- 检查是否已经存在
				self:check_is_exist( source_item.obj_data.id ,i );
				-- 通知服务器保存这个快捷键
				KeySettingCC:req_set_a_key( i,source_item.obj_data.id,1 );
			end
			-- if ( XSZYManager:get_state() == XSZYConfig.JINENG_ZY ) then 
			--     XSZYManager:destroy_drag_out_animation()
			--     -- 指向关闭按钮 340 , 377, 62, 56
			--     XSZYManager:play_jt_and_kuang_animation_by_id( XSZYConfig.JINENG_ZY,2 , XSZYConfig.OTHER_SELECT_TAG );
			-- end
		end
		self.tab_skill_slot[i]:set_drag_in_event( drag_in )
		self.tab_skill_slot[i]:set_enable_drag_out(false);
		self.skill_panel:addChild(self.tab_skill_slot[i].view);
		self.tab_skill_slot[i].view:setIsVisible(false)
	end

	-- 药品按钮
	self.yp_slot_item = MUtils:create_slot_item(self.skill_panel,UILH_MAIN.m_yp_bg,
												tab_yp_pos[1],
												tab_yp_pos[2],
												70,69);
	-- self.yp_slot_item.view:setIsVisible(false)

	self.anger_dra = ZImage:create(self.skill_panel, UILH_MAIN.m_anger_dragon, _skillPanelWidth-53,70, -1, -1)
	self.anger_dra.view:setIsVisible(false)
	-- 创建必杀技按钮
		-- 怒气
	self.anger_btn = ZButton:create(self.skill_panel.view,UILH_MAIN.m_anger_bg,nil,
									 tab_skill_pos[1],tab_skill_pos[2],-1,-1);
	self.anger_spr = ZCCSprite:create(self.anger_btn,'nopack/m_anger.png',96.5,12);
	self.anger_spr.view:setAnchorPoint(CCPoint(0.5,0));
	self.anger_btn.view:setIsVisible(false);
	-- self.anger_btn.view:setAnchorPoint(1.0,0);
	self.anger_spr.view:setTag(0)
	self.anger_spr.view:setAnchorPoint(CCPoint(1.0,0.0));
	local anger_fg = ZImage:create(self.anger_btn.view, UILH_MAIN.m_anger_fg, 15, 12, -1,-1)

	--self.action_btn_table = {};
	-- 动作按钮                                                                                                         652,141
	-- 动作按钮函数
	local function guaji_action_fun( eventType,arg,msg_id)
		print('guaji_action_fun')
		Instruction:handleUIComponentClick(instruct_comps.GUIJI_BTN)
		-- if eventType == TOUCH_BEGAN then
			-- MountsModel:req_xuanyao_event(  )
		Analyze:parse_click_main_menu_info(33)
			AIManager:toggle_guaji()
		-- end
		
		return false
	end

	-- self.guaji_btn = ZBasePanel:create(self.view,"",_refWidth(1.0) - 45,170,68,67)
	-- self.guaji_btn:setAnchorPoint(1,0)

	self.action_btn = ZTextButton:create(self.skill_panel.view,  
		"",-- LangGameString[1617],
		ACTION_BTN_BG,-- UI_MountsWinNew_007, 
		guaji_action_fun, 
		ACTION_SLOT_RECT[1],ACTION_SLOT_RECT[2],
		ACTION_SLOT_RECT[3],ACTION_SLOT_RECT[4])

	-- self.action_btn = ZButton:create(self.view,ACTION_BTN_BG,
	--                                  nil,
	--                                  ACTION_SLOT_RECT[1],ACTION_SLOT_RECT[2],
	--                                  ACTION_SLOT_RECT[3],ACTION_SLOT_RECT[4])
	--[[
	for i=1,6 do
		self.action_btn_table[i] = ZCCSprite:create(self.action_btn.view,UIResourcePath.FileLocate.main .. "action/m_action_t"..i..".png",35,32.5)
		self.action_btn_table[i].view:setIsVisible(false);
	end
	]]--
	self:change_action_btn_state(true)

	-- self.anger_btn.view:setIsVisible(false)


	-- self.guaji_btn = ZBasePanel:create(self.view,"",_refWidth(1.0) - 45,170,68,67)
	-- self.guaji_btn:setAnchorPoint(1,0)
	-- self.guaji_img = ZImage:create(self.guaji_btn.view,ACTION_BTN_BG,0,0);

	-- self.skill_panel.view:setIsVisible(false);
	   -- print("MenusPanel:create_skill_panel()..........................................")
	-- self:show_or_hide_panel(false)
end


function MenusPanel:set_yp_and_xq_btn_visible( is_visible )
	-- self.action_btn.view:setIsVisible(is_visible);
	--self.yp_slot_item.view:setIsVisible(is_visible);
end

-- 当一个新技能拖动到技能快捷面板的时候，先检测该面板里是否已经有了这个技能，有的话就把它删掉
function MenusPanel:check_is_exist( skill_id ,index)
	-- 5是变身技能 
	if index == 5 then
		-- local i = index
		-- if tab_skill_id[i] then
		--     self.tab_skill_slot[i]:stop_cd_animation();
		--     self.tab_skill_slot[i]:set_icon(nil);
		--     self.tab_skill_slot[i].view:setIsVisible(false)
		--     tab_skill_id[i] = nil;
		--     -- 通知服务器删掉这个快捷键
		--     KeySettingCC:req_set_a_key( i,0,1 )
		-- end
		return
	end
	for i=1,MAX_NORMAL_SKILLS do
		if ( i~= index ) then 
			if ( tab_skill_id[i] and tab_skill_id[i] == skill_id ) then
				self.tab_skill_slot[i]:stop_cd_animation();
				self.tab_skill_slot[i]:set_icon(nil);
				self.tab_skill_slot[i].view:setIsVisible(false)
				tab_skill_id[i] = nil;
				-- 通知服务器删掉这个快捷键
				KeySettingCC:req_set_a_key( i,0,1 )
				return;
			end
		end
	end
end

-- 当一个新技能拖动到技能快捷面板的时候，先检测该面板里是否已经有了这个技能，有的话就把它删掉
-- 只设置显示
function MenusPanel:check_is_exist2( skill_id ,index)
	for i=1,MAX_NORMAL_SKILLS do
		if ( i~= index ) then 
			if ( tab_skill_id[i] and tab_skill_id[i] == skill_id ) then
				self.tab_skill_slot[i]:stop_cd_animation();
				self.tab_skill_slot[i]:set_icon(nil);
				--self.tab_skill_slot[i].view:setIsVisible(false)
				tab_skill_id[i] = nil;
				return;
			end
		end
	end
end

-- 设置指定索引的技能图标
function MenusPanel:set_btn_skill_by_index(index,skill_id)
	-- print("MenusPanel:set_btn_skill_by_index(index,skill_id)",index,skill_id)
	if ( index <= MAX_NORMAL_SKILLS ) then
		tab_skill_id[index] = skill_id;
		if not self:get_is_show() then
			self.tab_skill_slot[index].view:setIsVisible(true);
			local pos_x = tab_skill_pos[index*2+1] 
			local pos_y = tab_skill_pos[index*2+2]
			-- print("======index, pos_x, pos_y: ", index, pos_x, pos_y)
			self.tab_skill_slot[index]:setPosition(pos_x, pos_y)
		end
		self.tab_skill_slot[index]:set_icon( skill_id );

		local skill = UserSkillModel:get_a_skill_by_id( skill_id )
		if ( skill and skill.cd > 0 ) then
			local skill_id = skill.id;
			local cooldowntime = skill.cd/1000;
			local percentage = math.floor(cooldowntime/skill.max_cd*100);
			self:play_skill_cd_animation(skill.id,cooldowntime,percentage);
		end
		-- print("--aft--skill.cd", skill.cd)
	end
	self:check_is_exist2( skill_id, index )
end

-- 给指定索引的技能栏置空
function MenusPanel:set_btn_empty(index)
	if ( index <= MAX_NORMAL_SKILLS ) then
		self.tab_skill_slot[index]:set_icon( skill_id );
	end
end
-- 不在技能栏的技能列表 
local not_at_skill_panel_table = {};

-- 使用技能后播放技能cd动画 
function MenusPanel:play_skill_cd_animation( skill_id ,cooldowntime,percentage )
	for i=1,MAX_NORMAL_SKILLS do
		if ( tab_skill_id[i] and tab_skill_id[i] == skill_id ) then
			-- print("---------MenusPanel,技能需要优化:", skill_id, self.tab_skill_slot[i])
			-- add after tjxs by chj 修改后后面的
			local skill = UserSkillModel:get_a_skill_by_id( skill_id )
			local cd_time = nil
			local percentage_new = nil
			if self.tab_skill_slot[i]:is_cd() then
				cd_time = self.tab_skill_slot[i]:get_cd_remain_time()
				percentage_new = math.floor(cd_time/skill.max_cd*100);
			else
				-- cd_time = skill.max_cd-1
				percentage_new = 99
			end
			-- end tjxs
			self.tab_skill_slot[i]:play_skill_cd_animation( cooldowntime , skill_id, percentage_new)
			return;
		end
	end
	-- 如果没有在技能面板里面，则必须开启计时器，再cooldowntime秒后重置技能cd
	not_at_skill_panel_table[skill_id] = callback:new()
	local function cb()
		UserSkillModel:set_skill_cd_zero( skill_id );
		not_at_skill_panel_table[skill_id] = nil;
	end
	not_at_skill_panel_table[skill_id]:start( cooldowntime,cb)
end

-- 立即停止技能cd
function MenusPanel:clear_skill_cd( skill_id )
	-- 如果在技能面板里面，停止动画
	for i,v in pairs(tab_skill_id) do
		if ( tab_skill_id[i] == skill_id ) then
			self.tab_skill_slot[i]:stop_cd_animation();
			return;
		end
	end
	-- for i=1,#tab_skill_id do
	--     if ( tab_skill_id[i] == skill_id ) then
	--         self.tab_skill_slot[i]:stop_cd_animation();
	--         return;
	--     end
	-- end
	-- 如果没有在技能面板里面，直接停止计时器
	if ( not_at_skill_panel_table[skill_id] ) then
		not_at_skill_panel_table[skill_id]:cancel();
		not_at_skill_panel_table[skill_id] = nil;
	end
end

--更改技能cd
function MenusPanel:set_skill_cd( skill_id ,time)
    local skill = UserSkillModel:get_a_skill_by_id( skill_id )
    --if ( skill and skill.cd > 0 ) then
        local skill_id = skill.id;
        local cooldowntime = skill.cd;
        local percentage = math.floor(cooldowntime/skill.max_cd*100);
        self:play_skill_cd_animation_YJMT(skill.id,cooldowntime,percentage);
   -- end
end

-- 使用技能后播放技能cd动画 (一剑灭天版本，天将的被改了，不能直接用，只好搬一剑灭天的)
function MenusPanel:play_skill_cd_animation_YJMT( skill_id ,cooldowntime,percentage )
    for i=1,4 do
        if ( tab_skill_id[i] and tab_skill_id[i] == skill_id ) then
            self.tab_skill_slot[i]:play_skill_cd_animation( cooldowntime ,skill_id,percentage)
            return;
        end
    end
	-- 如果没有在技能面板里面，则必须开启计时器，再cooldowntime秒后重置技能cd
	not_at_skill_panel_table[skill_id] = callback:new()
	local function cb()
		UserSkillModel:set_skill_cd_zero( skill_id );
		not_at_skill_panel_table[skill_id] = nil;
	end
	not_at_skill_panel_table[skill_id]:start( cooldowntime,cb)
end

function MenusPanel:on_drag_in( slot,skill_id )
	-- 先停止当前的cd动画
	slot:stop_cd_animation();
	-- local skill = UserSkillModel:get_a_skill_by_id( skill_id )
	-- if ( skill and skill.cd > 0 ) then
	--     local skill_id = skill.id;
	--     local cooldowntime = skill.cd/1000;
	--     local percentage = math.floor(cooldowntime/skill.max_cd*100);
	--     self:play_skill_cd_animation(skill.id,cooldowntime,percentage);
	--     print("self:play_skill_cd_animation(skill.id,cooldowntime,percentage);",percentage,skill.cd);
	-- end
end

local anger_spr_height = 81

-- 龙眼闪烁
function MenusPanel:showDragonSprite(flag)
	if self.spr then
		self.spr:stopAllActions()
		self.spr:removeFromParentAndCleanup(true)
		self.spr = nil
	end
	if flag then
		self.spr = MUtils:create_sprite(self.anger_dra, UILH_MAIN.m_red_eye, 3,49,0);
		self.spr:setAnchorPoint(CCPointMake(0,0));
		--创建一个闪烁的效果
		local fade_out = CCFadeOut:actionWithDuration(0.8);
		local fade_in = CCFadeIn:actionWithDuration(0.8);
		local seq_act = CCSequence:actionOneTwo( fade_out, fade_in);
		local forever_act = CCRepeatForever:actionWithAction(seq_act);
		self.spr:runAction( forever_act )
	end
end
-- 更新怒气值
function MenusPanel:updateAngerBar(anger_value)
	
	local result_height = anger_spr_height * anger_value/100;
--    print("  怒气值高度 ", result_height);
	if result_height < 0 then
		result_height = 0;
	end
	self.anger_spr.view:setTextureRect(CCRectMake(0,anger_spr_height-result_height,anger_spr_height,result_height));
	if ( anger_value == 100 ) then
		SoundManager:playUISound( 'anger_full' , false )
		local effect_node = self.anger_spr.view:getChildByTag(10011);
		if ( effect_node == nil ) then 
			-- 播放怒气值满的特效
			LuaEffectManager:play_view_effect( 10011,40,41,self.anger_spr.view ,true);
			self:showDragonSprite(true)
			-- 新手指引代码
			-- if ( XSZYManager:get_state() == XSZYConfig.ZXJZ_ZY ) then
			--     --可以放大招啦 652,135,67,68
			--     XSZYManager:play_jt_and_kuang_animation_by_id( XSZYConfig.BISHAJI_BTN,1 , XSZYConfig.OTHER_SELECT_TAG);
			-- end
			anger_index = FuBenModel:handle_first_fuben( anger_index or 1 )
			-- anger_index = anger_index + 1
		end
	else
		local effect_node = self.anger_spr.view:getChildByTag(10011);
		if ( effect_node ) then
			effect_node:removeFromParentAndCleanup(true);
		end
	end
	
end

function MenusPanel:active( show )
	-- 隐藏后再显示要重新播放动画
	if ( show ) then
		if ( self.anger_spr ) then
			local effect_node = self.anger_spr.view:getChildByTag(10011);
			if ( effect_node ) then
				effect_node:removeFromParentAndCleanup(true);
				-- 播放怒气值满的特效
				LuaEffectManager:play_view_effect( 10011,0,0,self.anger_spr.view ,true);
			end
		end
		--[[
		if ( self.action_btn_table ) then
			self:set_action_btn_state( 1 )
		end
		]]--
	else
		-- self:on_active( show )
	end
end
-- 设置动作按钮的显示状态
function MenusPanel:set_action_btn_state( state )
	--if ( self.old_action ) then
		--self.action_btn_table[self.old_action].view:setIsVisible(false);
	--end
	--self.action_btn_table[state].view:setIsVisible(true);
	--self.old_action = state;
end 

local super_skill = SkillConfig:get_super_skill()

function MenusPanel:get_skill_index_by_id( skill_id )
	if super_skill[skill_id] then
		return 5
	else
		for i=1,MAX_NORMAL_SKILLS do
			if ( tab_skill_id[i] ~= nil ) and tab_skill_id[i] == skill_id then 
				return i;
			end
		end
	end
	return nil
end

--查找技能面板的空闲位置
function MenusPanel:get_skill_idle_btn_pos( skill_id )
	print("MenusPanel:get_skill_idle_btn_pos skill_id",skill_id)
	if super_skill[skill_id] then
		local i = 5
		if ( tab_skill_id[i] == nil ) then 
			tab_skill_id[i] = skill_id
			local pos_x = tab_skill_pos[i*2+1] + 27 
			local pos_y = tab_skill_pos[i*2+2] + 27
			if ( MenusPanel:get_is_show() == false ) then
				pos_y = pos_y - 60;
			end
			return pos_x,pos_y,i;
		end
	end
	for i=1,MAX_NORMAL_SKILLS do
		-- print("tab_skill_id[i]",tab_skill_id[i],i,skill_id)
		if ( tab_skill_id[i] == nil or tab_skill_id[i] == skill_id ) then 
			tab_skill_id[i] = skill_id
			local pos_x = tab_skill_pos[i*2+1] + 27 
			local pos_y = tab_skill_pos[i*2+2] + 27
			if ( MenusPanel:get_is_show() == false ) then
				pos_y = pos_y - 60;
			end
			return pos_x,pos_y,i;
		end
	end
end

-- 药品栏添加药品
function MenusPanel:add_supply( user_item ,is_save)
	self.yp_user_item = user_item;
	if not self:get_is_show() then
		-- self.yp_slot_item.view:setIsVisible(true)
		local pos_x = tab_yp_pos[1]+3
		local pos_y = tab_yp_pos[2]
		self.yp_slot_item:setPosition(pos_x, pos_y)
	end
	self.yp_slot_item:set_icon(user_item.item_id)
	self.yp_slot_item:set_icon_bg_texture(UILH_MAIN.m_yp_bg, -3, -2, 70, 69)
	local texture = ItemConfig:get_item_icon(user_item.item_id)
	texture = MUtils.GetRoundName(texture)
	self.yp_slot_item:set_icon_texture(texture)
	self.yp_slot_item.view:setScale(0.95)

	local function eat_yp_function()
		-- 当前拖进来的药品id
		if ( self.yp_user_item ) then
			if ( user_item.count > 0 ) then
				ItemModel:use_a_item( self.yp_user_item.series,0);
			end
		end
	end
	self.yp_slot_item:set_click_event(eat_yp_function);
	self.yp_slot_item:set_color_frame(nil);
	self:update_yp_view(user_item.item_id);
	if ( is_save ) then
		-- 保存药品数据到服务器
		SetSystemModel:set_one_date( SetSystemModel.MAIN_YP, user_item.item_id )
	end
end

-- 使用一个药品后要通知主界面更新
function MenusPanel:update_yp_view( item_id )
	--print("-- 使用一个药品后要通知主界面更新MenusPanel:update_yp_view( item_id,self.yp_user_item)",item_id,self.yp_user_item)
	if ( self.yp_user_item ) then
		local item_base = ItemConfig:get_item_by_id( self.yp_user_item.item_id )
		if ( ItemModel:check_item_belong_cd_group( item_id, item_base.colGroup ) ) then
			local cooldowntime = ItemModel:get_item_remain_cd( self.yp_user_item.item_id );
			-- 如果主界面的药品使用成功
			if ( cooldowntime > 0 ) then
				self.yp_slot_item:play_cd_animation( cooldowntime , 1 , UILH_MAIN.skill_cd );
			end

			self.yp_slot_item:set_count(self.yp_user_item.count)

		end
	end
end

function MenusPanel:on_delete_yp( item_id )
	local win = UIManager:find_visible_window("menus_panel");
	if ( win ) then 
		if ( win.yp_user_item and win.yp_user_item.item_id == item_id ) then
			local count = ItemModel:get_item_count_by_id( item_id )
			if ( count == 0 ) then 
				win.yp_user_item = nil;
				win.yp_slot_item:set_icon_ex(nil)
				-- win.yp_slot_item.view:setIsVisible(false)
				win.yp_slot_item:setPosition(tab_yp_pos[1], tab_yp_pos[2])
				win.yp_slot_item:set_count(0)
			end
		end
	end
end


-- 关闭技能栏包括动作按钮和怒气
function MenusPanel:hide_skill_panel( visible )
	local win = UIManager:find_visible_window("menus_panel");
	if ( win and self.tab_skill_slot ) then
		for k,v in pairs(self.tab_skill_slot) do
			v.view:setIsVisible(visible);
		end
		-- for k,v in pairs(self.tab_skill_slot) do
		--     if not tab_skill_id[k] then
		--         v.view:setIsVisible(false)
		--     end
		-- end
	end
	-- if GameSysModel:isSysEnabled( GameSysModel.UNIQUE_SKILL, false ) and self.anger_btn then
	--     self.anger_btn.view:setIsVisible(visible);
	-- end
	-- --self.yp_slot_item.view:setIsVisible(visible);
	-- if self.action_btn then
	--     self.action_btn.view:setIsVisible(visible);
	-- end
	if self.skill_panel then
		self.skill_panel.view:setIsVisible(visible)
	end
	-- self:show_anger_btn_or_action_btn()
	-- if self:check_anger_btn_visible() then
	--     self.anger_btn.view:setIsVisible(true)
	-- else
	--     self.anger_btn.view:setIsVisible(false)
	-- end
end

function MenusPanel:setBatteryVisible(s)
	--if battery_icon then
	--    battery_icon.view:setIsVisible(s)
	--end
end
--设置电池状态
function MenusPanel:setBatteryState(state)
	--[[
	if not battery_icon then
		return
	end

	if battery_state == state then
		return
	end

	if state == 0 then
		battery_icon.view:setTexture(UIResourcePath.FileLocate.notes.."battery_low.png");

	elseif state == 1 then
		battery_icon.view:setTexture(UIResourcePath.FileLocate.notes.."battery_mid.png");
	elseif state == 2 then
		battery_icon.view:setTexture(UIResourcePath.FileLocate.notes.."battery_high.png");
	end
	]]--
	battery_state = state
end

-- 技能栏显示或隐藏技能按钮
function MenusPanel:show_or_hide_skill_panel( show_or_hide )
end


-- 显示或隐藏
-- isSceneChange 是否切换场景，切换场景的时候要强制播放动画，不管是不是同一种状态
function MenusPanel:show_or_hide_panel( isShow ,isSceneChange )
	-- print("isShow",isShow,self.is_show_menus)
	if ( isSceneChange or self.is_show_menus ~= isShow ) then 
		if self.mirror_timer then
			self.mirror_timer:cancel()
			self.mirror_timer = nil
		end
		if( isShow  ) then
			local j = 1
			for i = 1, _MAX_MENU_BTN do
				local ret = self:showActions(i,j)
				if ret then j = j+1 end
			end
			self:change_layout( 1 )
			self.hide_btn:rotate_frame(-1);
			self.mirror.view:setIsVisible(false)
		else
			if SceneManager:get_cur_scene() == TYCID then
				self:change_layout( 3 )
			elseif SceneManager:get_cur_scene() ~= WEN_QUAN then
				self:change_layout( 2 )   
			end
			
			for i = 1, _MAX_MENU_BTN do
				local btn = self.btn_table[i] or self.col_btn_t[i]
				if btn then
					self:menusHideActions(btn,i)
				end
			end
			self.hide_btn:rotate_frame(1);
			local function vis_fun( )
				if self.mirror then
					self.mirror.view:setIsVisible(true)
				end
			end
			self.mirror_timer = callback:new()
			self.mirror_timer:start(0.20,vis_fun)
		end
		self.is_show_menus = isShow
	end  
	--Shan Lu 2014-06-09 
	--菜单出来时，隐藏怒气按钮
	-- self.anger_btn.view:setIsVisible(not isShow);
	self:setActionBtnVisisble(not isShow);

	if self:check_anger_btn_visible() then
		-- self.anger_btn.view:setIsVisible(not isShow);
	else
		-- self.anger_btn.view:setIsVisible(false)
	end

	if SceneManager:get_cur_scene() == WEN_QUAN then
		self:hide_skill_panel(false)
	end

	self:menuVisibleRef(isShow)
	-- -- 重新设置聊天面板大小
	-- -- add by hcl on 2014/7/22 
	-- self:chatPanelReSize(isShow)
	-- MiniBtnWin:miniBtnWinRepos( isShow )
	-- -- 打开菜单时隐藏任务栏
	-- UserPanel:toggle_show_minitask( not isShow )
end

-- add by yongrui.liang 2014/8/15
-- 自动打怪按钮显示与隐藏
function MenusPanel:setActionBtnVisisble( visible )
	-- if visible then
	--     local array = CCArray:array()
	--     local delay = CCDelayTime:actionWithDuration(0.15)
	--     local show = CCShow:action()
	--     array:addObject(delay)
	--     array:addObject(show)
	--     self.action_btn.view:runAction(CCSequence:actionsWithArray(array))
	-- else
	--     self.action_btn.view:setIsVisible(false)
	-- end
end

-- add by yongrui.liang 2014/8/15
-- 菜单栏隐藏与显示时的其他动作
function MenusPanel:menuVisibleRef( visible )
	-- 打开菜单时隐藏摇杆
	JoystickManager:set_visible(not visible)
	-- self.mirror.view:setIsVisible(not visible)
	-- 重新设置聊天面板大小
	-- self:chatPanelReSize(visible)
	self:rePosDialogPanel(visible)
	-- self:resPosBtnChat()
	-- 重设通知按钮位置
	MiniBtnWin:miniBtnWinRepos( visible )
	-- 重设婚宴嬉闹按钮位置
	MarriagePlayWin:menuChangeVisible( visible )
	-- 重设仙道會动作按钮位置
	ZBSActionWin:menuChangeVisible( visible )
	-- -- 打开菜单时隐藏任务栏
	-- UserPanel:toggle_show_minitask( not visible )
end

-- add by yongrui.liang 2014/8/15
-- 药品快捷栏动作
function MenusPanel:setYpVisible( visible )
	-- if visible then
	--     if self.yp_user_item then
	--         self.yp_slot_item.view:stopAllActions()
	--         local array = CCArray:array()
	--         local delay = CCDelayTime:actionWithDuration(0.5)
	--         local show = CCShow:action()
	--         array:addObject(delay)
	--         array:addObject(show)
	--         local seq = CCSequence:actionsWithArray(array)
	--         self.yp_slot_item.view:runAction(seq)
	--     end
	-- else
	--     self.yp_slot_item.view:setIsVisible(false)
	-- end
end

function MenusPanel:get_is_show()
	-- print("is_show_menus ",tostring(is_show_menus));
	return self.is_show_menus;
end

-- layout_type 1:菜单2:技能3:npc
function MenusPanel:change_layout( layout_type )
	-- print("MenusPanel:change_layout( layout_type )",layout_type)
	if layout_type == 1 then
		-- self:NPCPanelActions( 2 )

		-- 技能栏动画
		local actions_num = #self.tab_skill_slot+1;

		for i=1,actions_num-1 do
			if i == 1 then
				-- self:skillPanelHideActions(self.anger_btn.view,i,actions_num)
			else
				self:skillPanelHideActions(self.tab_skill_slot[i-1].view,i,actions_num)
			end
		end
		self.tab_skill_slot[#self.tab_skill_slot].view:setIsVisible(false);

		self:setYpVisible(false)

	elseif layout_type == 3 then 
		-- self:NPCPanelActions( 1 )
		self.skill_panel.view:setIsVisible(false);

		self:setYpVisible(false)

	elseif layout_type == 2 then
		-- self:NPCPanelActions( 2 ) 
		self.skill_panel.view:setIsVisible(true);

		self:setYpVisible(true)

		-- 技能栏动画
		local actions_num = #self.tab_skill_slot+1;
		for i=1,actions_num-1 do
			if i == 1 then
				if self.anger_btn and self:check_anger_btn_visible() then 
					-- self:skillPanelShowActions(self.anger_btn.view,i,actions_num)
				end
			else
				--if tab_skill_id[i-1] then
					self:skillPanelShowActions(self.tab_skill_slot[i-1].view,i,actions_num)
				--end
			end
		end
		self.tab_skill_slot[#self.tab_skill_slot].view:setIsVisible(true);
	end
end

-- 创建Npc面板
function MenusPanel:create_npc_panel()
	self.npc_panel = ZBasePanel:create(self.view,nil,_npcPanelPosX,0,280,120);
	self.npc_panel.view:setAnchorPoint(1,0)
	self.npc_panel.view:unregisterScriptHandler();
	self.npc_view_tab = {};
	self.npc_tab = {};
	self.npc_num = 0;
	for i=1, maxNearbyNPCCount do
		local function btn_fun()
			if self.npc_tab[i] then
				-- GlobalFunc:ask_npc( 11,self.npc_tab[i].npc_name  )
				AIManager:set_AIManager_idle(  )
				local entity = EntityManager:get_entity(self.npc_tab[i].npc_handle)
				CommandManager:ask_target_npc(entity.model.m_x,entity.model.m_y,entity.name)

			end
		end--82 - math.floor((i-1)/3)*82
		self.npc_view_tab[i] = ZButton:create(self.npc_panel,"",btn_fun,(i-1)*90,6,75,75);
		ZCCSprite:create(self.npc_view_tab[i].view,UILH_MAIN.user_head_bg,35,35,-1)
		self.npc_view_tab[i].view:setIsVisible(false);

	end
	-- npc提示
	-- ZImage:create(self.npc_panel,UILH_MAIN.npc_tip,90,90)

	self.npc_panel.view:setIsVisible(false);
end

function MenusPanel:create_npc_name_spr( view,face ,npc_name)
	--print("face = ",face,npc_name);
	if view.name_spr then
		view.name_spr.view:removeFromParentAndCleanup(true);
		view.name_spr = nil;
	end
	if face < 1000 then 
		view.name_spr = ZCCSprite:create(view.view,"ui/TYCNPCName/n"..face..".png",37.5,8);
	else
		view.name_spr = ZCCSprite:create(view.view,"ui/TYCNPCName/n50.png",37.5,8);
	end
	if view.fun_img then
		view.fun_img.view:removeFromParentAndCleanup(true);
		view.fun_img = nil;
	end
	local npc = SceneConfig:get_npc_data(SceneManager:get_cur_scene(), npc_name)
	if npc then 
		local funcid = npc.funcid;
		if funcid ~= nil and funcid ~= 7 then
			view.fun_img = ZCCSprite:create(view.view,"ui/npctitle/m_"..funcid..".png",15,50);
		end
	end    
end

function MenusPanel:on_enter_scene()
	-- print("MenusPanel:on_enter_scene()..........................................")
	local win = UIManager:find_visible_window("menus_panel")
	local isTYC = false --SceneManager:get_cur_scene() == TYCID
	if win and win.is_show_menus ~= nil then
		-- print("----------MenusPanel:on_enter_scene()",win.is_show_menus)
		-- if win.is_show_menus == false then 
		--     if isTYC then
		--         win:change_layout( 3 ) 
		--         win:show_or_hide_panel(true) 
		--     elseif SceneManager:get_cur_scene() ~= WEN_QUAN then
		--         win:change_layout( 2 )
		--         win:show_or_hide_panel(false)         
		--     end
		-- else
		--     if isTYC then
		--         win:change_layout( 3 )
		--     else 
		--         win:show_or_hide_panel(false) 
		--     end
		-- end
		win:show_or_hide_panel(isTYC,true) 



		if isTYC then
			-- win:startCheckNearByNPC()
			win:change_action_btn_state(false)
		elseif win.anger_btn then
			-- win:stopCheckNearByNPC() 
			-- 根据场景判断是显示选取按钮还是怒气按钮
			-- win:show_anger_btn_or_action_btn(  )
			if win:check_anger_btn_visible() then
				win.anger_dra.view:setIsVisible(true)
				win.anger_btn.view:setIsVisible(true)
			else
				win.anger_dra.view:setIsVisible(false)
				win.anger_btn.view:setIsVisible(false)
			end
		end

		if SceneManager:get_cur_scene() == WEN_QUAN then
			win:hide_skill_panel(false)
		end
	end
end

--开始检查附近NPCtimer
function MenusPanel:startCheckNearByNPC()
	-- self.nearByNPCTimer:stop()
	-- self.nearByNPCTimer:start(1,bind(MenusPanel.updateNearByNPC,self))
end

--停止检查附近NPCtimer
function MenusPanel:stopCheckNearByNPC()
	-- print(" MenusPanel:stopCheckNearByNPC()")
	-- self.nearByNPCTimer:stop()
end

--根据距离检查附近NPC
function MenusPanel:updateNearByNPC()
	require "../data/npc"
	local npctable = EntityManager:sort_entities_by_distance(EntityConfig.TYPE_NPC)
	local c = 0
	local _nMax = maxNearbyNPCCount + 1

	self.npc_num = 0
	--只取出附近3个
	for i,npc in ipairs(npctable) do
		if i > maxNearbyNPCCount then
			break
		end
		self.npc_num = self.npc_num + 1
		local tab_npc_info = npc_config[npc.face];
		local head_path = string.format( "icon/npc/%s",tab_npc_info[1] );
		c = _nMax - i;
		self.npc_view_tab[c]:setImage(head_path);
		self.npc_view_tab[c].view:setIsVisible(true);
		self.npc_tab[c] = {npc_name = npc.name,npc_handle = npc.handle}; 
		self:create_npc_name_spr( self.npc_view_tab[c],npc.face,npc.name )
	end
	--隐藏其他的
	for i=self.npc_num + 1, maxNearbyNPCCount do
		local invisible = _nMax - i
		self.npc_view_tab[invisible]:setImage(nil);
		self.npc_view_tab[invisible].view:setIsVisible(false);
	end
end

--显示进场动画
function MenusPanel:showActions(i, j)
	local btn = self.btn_table[i]
	if not btn then
		btn = self.col_btn_t[i]
		if not btn then
			return false
		end
	end
	local _action = self.menu_show_actions[i]
	if not _action then
		local x = self.btn_pos_table[i].x
		local y = self.btn_pos_table[i].y
		if self.col_btn_t[i] then
			_action = CCMoveTo:actionWithDuration(0.25, CCPoint(3, y))
		else
			_action = CCMoveTo:actionWithDuration(0.25, CCPoint(x, 3))
		end
		-- local movex = CCMoveTo:actionWithDuration(0.25, CCPoint(x, 6))
		-- local movey = CCMoveTo:actionWithDuration(0.15,CCPoint(x, y));
		-- local array = CCArray:array()
		-- array:addObject(movex)
		-- array:addObject(movey)
		-- _action = CCSequence:actionsWithArray(array)
		safe_retain(_action)
		self.menu_show_actions[i] = _action
	end

	btn:setIsVisible(true)
	btn:stopAllActions()
	btn:runAction(_action)
	return true
end

--显示剩余动画
function MenusPanel:showRemain(btn,i)
	local _action = self.menu_remain_actions[i]
	if not _action then
		local x     = self.btn_pos_table[i].x
		_action = CCMoveTo:actionWithDuration(0.25,CCPoint(x,3));
		safe_retain(_action)
		self.menu_remain_actions[i] = _action
		--print('***Create MenusPanel:showRemain',btn,i)
	end
	btn:stopAllActions()
	btn:runAction(_action)
end

--显示退场动画
function MenusPanel:menusHideActions(btn,i)
	-- print("MenusPanel:menusHideActions(btn,i)",btn,i)
	local _action = self.menu_hide_actions[i]
	if not _action then
		local x = self.btn_pos_table[i].x
		local y = self.btn_pos_table[i].y

		-- if self.col_btn_t[i] then
		--     _action = CCMoveTo:actionWithDuration(0.25, CCPoint(6, 6))
		-- else
		-- if self.col_btn_t[i] then
		--     c = CCMoveTo:actionWithDuration(0.25, CCPoint(14, 6))
		-- else
			c = CCMoveTo:actionWithDuration(0.25, CCPoint(3, 3))
		-- end
		-- local c = CCMoveTo:actionWithDuration(0.25, CCPoint(6, 6))
		-- end
		-- local x = self.btn_pos_table[i].x
		local array = CCArray:array();
		-- local c   = CCMoveTo:actionWithDuration(0.15,CCPoint(x, 6));
		-- local movex = CCMoveTo:actionWithDuration(0.25, CCPoint(x, -70))
		array:addObject(c)
		-- array:addObject(movex)
		array:addObject(CCHide:action());
		_action = CCSequence:actionsWithArray(array)
		safe_retain(_action)
		self.menu_hide_actions[i] = _action
	end
	btn:stopAllActions()
	btn:runAction(_action)
end

-- NPC面板显示隐藏动画 
function MenusPanel:NPCPanelActions( is_show )
	local _action = self.npc_panel_actions[is_show]
	if not _action then
		local npc_panel_x = _npcPanelPosX;
		local point = nil;
		if is_show == 1 then
			point = CCPoint(npc_panel_x,0)
		elseif is_show == 2 then
			point = CCPoint(npc_panel_x + 300,0);
		end
		local c = CCMoveTo:actionWithDuration(0.25,point)
		if is_show == 1 then
			_action = c;
		elseif is_show == 2 then
			local array = CCArray:array();
			array:addObject(c)
			array:addObject(CCHide:action());
			_action = CCSequence:actionsWithArray(array)
		end
		safe_retain(_action)
		self.npc_panel_actions[is_show] = _action
	end
	if ( is_show == 1 ) then
		self.npc_panel.view:setIsVisible(true);
	end
	self.npc_panel.view:stopAllActions()
	self.npc_panel.view:runAction(_action)

end

-- 技能面板隐藏动画
function MenusPanel:skillPanelHideActions( btn,index,btn_nums )
	-- print("btn,index,btn_nums",btn,index,btn_nums)
	local all_action_time = 0.4;
	if not btn then
		return
	end
	local _action = self.skill_hide_actions[index]
	if not _action then
		local array = CCArray:array();
		-- array:addObject(CCDelayTime:actionWithDuration(0.35));
		for i=index+1,btn_nums do
			local x = tab_skill_pos[(i-1)*2+1]
			local y = tab_skill_pos[(i-1)*2+2]
			local time = all_action_time/btn_nums;
			local _a = CCMoveTo:actionWithDuration(time,CCPoint(x,y));
			array:addObject(_a);
		end
		array:addObject(CCHide:action());
		_action = CCSequence:actionsWithArray(array)
		safe_retain(_action)
		self.skill_hide_actions[index] = _action;
	end
	btn:stopAllActions()
	btn:runAction(_action)    
end

-- 技能面板显示动画
function MenusPanel:skillPanelShowActions( btn,index,btn_nums )
	-- print("skillPanelShowActions ,index,btn_nums",index,btn_nums)
	local all_action_time = 0.4;
	if not btn then
		return
	end
	local _action = self.skill_show_actions[index]
	if not _action then
		local array = CCArray:array();
		array:addObject(CCDelayTime:actionWithDuration(0.15));
		array:addObject(CCShow:action());
		local actions_num = btn_nums-index;
		for i=1,actions_num do
			local a = btn_nums - i ; 
			local x = tab_skill_pos[(a-1)*2+1]
			local y = tab_skill_pos[(a-1)*2+2]
			local time = all_action_time/btn_nums;
			local _a = CCMoveTo:actionWithDuration(time,CCPoint(x,y));
			array:addObject(_a);
			-- print("array:addObject",i,a,x,y,time)
		end
		_action = CCSequence:actionsWithArray(array)
		safe_retain(_action)
		self.skill_show_actions[index] = _action;
	end
	-- btn:setIsVisible(true)
	btn:stopAllActions()
	btn:runAction(_action)    
end

require "../data/ui_config"
local HIDE_ANGER_BTN_SCENE_IDS = ui_config.hide_anger_btn_scene_ids
function MenusPanel:check_anger_btn_show()
	local isTYC = SceneManager:get_cur_scene() == TYCID
	if isTYC == false then
		if GameSysModel:isSysEnabled( GameSysModel.UNIQUE_SKILL,false  ) then
			self.anger_dra.view:setIsVisible(true)
			self.anger_btn.view:setIsVisible(true);
		end
	end
end

function MenusPanel:check_anger_btn_visible( )
	if GameSysModel:isSysEnabled(GameSysModel.UNIQUE_SKILL, false) then
		local cur_scene = SceneManager:get_cur_scene()
		for i,v in ipairs(HIDE_ANGER_BTN_SCENE_IDS) do
			if cur_scene == v then
				return false
			end
		end
		return true
	end
	return false
end

function MenusPanel:on_active( show  )

end

-- 阵营战，天元之战，幻仙境，神农渊，斗法台
-- local SHOW_ACTION_BTN_FUBEN_IDS = { 59 }
-- local SHOW_ACTION_BTN_SCENE_IDS = {14,15,16}

-- by yongrui.liang 14.6.11
-- 诛仙阵
local SHOW_ACTION_BTN_FUBEN_IDS = {11}
local SHOW_ACTION_BTN_SCENE_IDS = {}

function MenusPanel:show_anger_btn_or_action_btn(  )
  
	local is_show_action_btn = false;
	local cur_scene = SceneManager:get_cur_scene();
	local cur_fuben = SceneManager:get_cur_fuben();

	for i,v in ipairs(SHOW_ACTION_BTN_FUBEN_IDS) do
		if cur_fuben == v then
			is_show_action_btn = true;
			break;
		end
	end

	if is_show_action_btn == false then
		for i,v in ipairs(SHOW_ACTION_BTN_SCENE_IDS) do
			if cur_scene == v then
				is_show_action_btn = true;
				break;
			end
		end
	end

	for i,v in ipairs(HIDE_ANGER_BTN_SCENE_IDS) do
		if cur_scene == v then
			is_show_action_btn = false
			break
		end
	end

	--[[
	if is_show_action_btn then
		self.action_btn.view:setIsVisible(true)
		self.anger_btn.view:setIsVisible(false);
	else
		self.action_btn.view:setIsVisible(false);
		self.anger_btn.view:setIsVisible(true); 
	end 
	]]--

	-- -- by yongrui.liang 14.6.11
	-- self.anger_btn.view:setIsVisible(is_show_action_btn)

	if self:check_anger_btn_visible() then
		self.anger_dra.view(is_show_action_btn)
		self.anger_btn.view:setIsVisible(is_show_action_btn);
	end
end

function MenusPanel:getChatDialog()
	return chat_dialog
end
-- 聊天面板重新设置大小
function MenusPanel:chatPanelReSize( is_menus_show )
	if self.isShowingChatPanel then 
		if is_menus_show then
			-- chat_dialog_bg:setSize( _dialogSize[1] + 4, _dialogSize[2] + 4 )                               
			-- chat_dialog:setSize( _dialogSize[1] , _dialogSize[2] )  
			local p = CCPointMake(_refWidth(_dialogShowX),_dialogShowY[1])
			-- chat_dialog:runAction(CCMoveTo:actionWithDuration(0.3,p))   
		else
			-- chat_dialog_bg:setSize( _dialogSize[1] + 4, _dialogSize[2] + 4 + 100)                                
			-- chat_dialog:setSize( _dialogSize[1] , _dialogSize[3])    
			local p = CCPointMake(_refWidth(_dialogShowX),_dialogShowY[2])
			-- chat_dialog:runAction(CCMoveTo:actionWithDuration(0.3,p))    
		end
	end
end

function MenusPanel:find_component(id)
	return self._instruction_components[id]
end

-- 根据玩家是否在副本中,作出一些UI上的调整
-- @param : inOrOut为true时,表示玩家正在新手副本场景中,否则表示玩家刚出新手副本场景
function MenusPanel:update_ui_by_newer_camp(inOrOut)
	if inOrOut then
		-- 隐藏菜单折叠按钮
		self.hide_btn.view:setIsVisible(false)
		-- 隐藏菜单窗口底部面板
		-- self.bottom_panel.view:setIsVisible(false)
		-- 隐藏聊天按钮
		self.btn_chat.view:setIsVisible(false)
		-- 隐藏菜单栏按钮的背景面板
		self.btn_bg_panel:setIsVisible(false)
		-- 折叠底部菜单栏
		self:show_or_hide_panel(false)
		-- 隐藏必杀技按钮
		-- self.anger_btn.view:setIsVisible(false)
		-- 隐藏聊天背景
		if dialogParent then
			dialogParent:setIsVisible(false)
		end

		--隐藏成就提示框
		-- if achieve_win then
		-- 	achieve_win:setIsVisible(false)
		-- end
	else
		-- 显示菜单折叠按钮
		self.hide_btn.view:setIsVisible(true)
		-- 显示菜单窗口底部面板
		-- self.bottom_panel.view:setIsVisible(true)
		-- 显示聊天按钮
		self.btn_chat.view:setIsVisible(true)
		-- 显示菜单栏按钮的背景面板
		self.btn_bg_panel:setIsVisible(true)
		-- 显示聊天背景
		-- if dialogParent then
		--     dialogParent:setIsVisible(true)
		-- end
	end
end

-- 当玩家从新手体验副本中出来的时候,清除技能槽
function MenusPanel:ClearSkillPanel()
	for i=1,MAX_NORMAL_SKILLS do
		if self.tab_skill_slot[i] then
			self.tab_skill_slot[i]:set_icon(nil)
			self.tab_skill_slot[i].view:setIsVisible(false)
		end
		tab_skill_id[i] = nil
	end
end


--xiehande 变身特效
function MenusPanel:play_tran_effect(pro_x,pro_y)
	-- 陈晔删除特效文件了，预防万一，把代码注释
	-- LuaEffectManager:play_view_effect(405, pro_x,pro_y,self.view,false,99)
end

function MenusPanel:change_action_btn_state(is_visible)
	self.action_btn.view:setIsVisible(is_visible);
	if is_visible == true then
		LuaEffectManager:stop_view_effect( 11042,self.view );
	else
		local sprite = LuaEffectManager:play_view_effect( 11042,_refWidth(1.0)-40,375,self.view,true);
		sprite:setScale(70/77);
	end
end