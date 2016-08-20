-- NPCDialog.lua
-- create by hcl on 2013-1-23
-- 与NPC的对话框 



super_class.NPCDialog(Window)

require "UI/task/QuestAwardView"

local HeadPosition = { 150, 175 }


local _parse_face = Hyperlink.parse_face

--主线任务
local _MAIN_QUEST_PRORITY = 1
--其他任务，日常
local _OTHER_QUEST_PRORITY = 3
--功能
local _FUNC_PRORITY = 5
--任务进度
local _QUEST_INPROGRESS = 255

local qtMain = 0 --, //主线任务
local qtSub = 1 --,//支线任务
local qtFuben = 2 --,//副本任务
local qtDay = 3 --,//日常任务
local qtGuild = 4 --,//帮派任务
local qtChallenge = 5 --,//挑战任务
local qtRnd = 6 --,//奇遇任务
local qtRecommended = 7 --,//活动推介
local qtZyQuest = 8 --,  //阵营任务
local qtMaxQuestType --,//最大值

local _string_format = string.format
local _string_find   = string.find
local _fbFuncString = 'ShowFubenList'
local _create2Flow = effectCreator.create2Flow
local _scroll_item = {} -- 如果有,记录所有的多选项
-- 对话框内容
local content_info = { x = 42, y = 480, width = 350, height = 100, size = 20}
local content_ex_info = {x = 80, y = 345, width = 300, height = 50, size = 20}
--原有的功能
local _flag_string_map = 
{
	['ShowFubenList']     = 'ui/npc_dialog/flagFB.png',
	['talkWithNPC']       = 'ui/npc_dialog/flagTalk.png',
	['BaGua_Get_Award']   = 'ui/npc_dialog/flagReward.png',
}
--银两任务的奖励图标特殊处理
local awards_img = {[1]="nopack/task/zhenqi.png" ,[2] = "nopack/task/exp.png",[3]="nopack/task/guild_jl_1.png", [5] = "nopack/task/tongbi.png", [6] = "nopack/task/tongbi.png",[14]="nopack/task/guild_jl_2.png", [999] = "icon/money/1.pd"}
-- NPC的对话框有四种形态，1是选择任务2是接任务3是普通对话，4是仙宗
-- 根据服务器发过来的字符串生成npc对话框
function NPCDialog:show(sever_str,npc_handle)

	Instruction:handleUIComponentClick(instruct_comps.ANY_BTN)
	-- 不允许重复出现npc对话框
	if ( sever_str == nil or UIManager:find_visible_window("npc_dialog") ) then
		return;
	end

	if Instruction:get_is_instruct() then return end
	local win = UIManager:show_window("npc_dialog");
	if ( win ) then
		-- 首先停止玩家的所有动作
		-- local player = EntityManager:get_player_avatar(  );
		-- player:stop_all_action();

		self.talk_npc_handle = npc_handle;
		local npc_name = EntityManager:get_entity( npc_handle ).name;
		local npc_id = EntityManager:get_entity( npc_handle ).face;
		npc_name = Utils:parseNPCName(npc_name)
		win:update(1,{sever_str,npc_name,npc_id});
	end

	-- 新手待机指引代码，如果当前玩家在进行待机指引，就销毁掉待机指引的控件
	if ( PlayerAvatar:get_is_daiji_xszy() or XSZYManager:get_state() == XSZYConfig.VIP_ZY ) then
		MiniTaskPanel:get_miniTaskPanel():stop_xszy();
		PlayerAvatar:set_is_xszy_false()
	end
	   
end

local function _noblock_fun(eventType,x,y)
	return false
end

-- 部分任务用到的控件显隐
function NPCDialog:set_visible(visible)
	-- self.frame1.view:setIsVisible(visible)
	self.frame2.view:setIsVisible(visible)
	self.frame_bg.view:setIsVisible(visible)
	-- self.right_frame1.view:setIsVisible(visible)
	-- self.right_frame2.view:setIsVisible(visible)
	-- self.npc_name_txt:setIsVisible(visible)
	self.award.view:setIsVisible(visible)
	self.split_line.view:setIsVisible( false)
end

function NPCDialog:__init(window_name, texture_name, is_grid, width, height)
	-- 需要指引的
	require '../data/event_config'
	self.fuben_xszy = event_fuben_xszy
	self.is_fbzy = false 	--是否存在副本入口指引
	_scroll_item = {}
	self.current_task_id = nil
	-- 背景图片
	-- ZCCSprite:create(self.view,"ui/npc_dialog/npc_d_bg.jpg",width/2,height/2)
	local dialog_bg = CCBasePanel:panelWithFile(0, 0, width, height, UILH_COMMON.style_bg, 500, 500)
	self.view:addChild( dialog_bg )
	local dialog_bg2 = CCBasePanel:panelWithFile(10, 10, width-20, height-35, UILH_TASK.frame_bg2, 500, 500)
	dialog_bg:addChild( dialog_bg2 )
	-- local bg = ZImage:create(self.view, UILH_TASK.frame_bg2, 45, 50, 365, 500)
	ZImage:create(self.view, UILH_COMMON.title_bg, 71, height - 40, -1, -1)
	local title = ZImage:create(self.view, UILH_TASK.title, width/2, height-35, -1, -1)
	title.view:setAnchorPoint(0.5, 0)
	-- local r_text = ZImage:create(self.view, UILH_TASK.text_lace, 261, height - 40, -1, -1)
	-- r_text.view:setFlipX(true)
	self.frame1 = ZImage:create(self.view, UILH_NORMAL.title_bg3, 35, 500, -1, -1)
	self.npc_name_txt = MUtils:create_zxfont(self.view, "", 213, 512, 2, 20)

	-- self.left_frame1 = ZImage:create(self.view, UILH_TASK.lace, 60, 510, -1, -1)
	-- self.right_frame1 = ZImage:create(self.view, UILH_TASK.lace, 275, 510, -1, -1)
	-- self.left_frame1.view:setFlipX(true)

	local function panel_function( eventType,args,msg_id)
		if ( eventType == TOUCH_BEGAN) then
			return true;

		elseif ( eventType == TOUCH_CLICK ) then
			if ( self.receive_btn:getIsVisible() ) then
				if ( self.sever_fun_str ) then
					UIManager:hide_window("npc_dialog");
					GameLogicCC:req_talk_to_npc( self.talk_npc_handle, self.sever_fun_str );
					-- print("panel_function(self.talk_npc_handle, self.sever_fun_str)",self.talk_npc_handle, self.sever_fun_str)
					self.talk_npc_handle = nil;
					self.sever_fun_str = nil;
					-- 0 接任务,1完成任务
					if ( self.state == 0 ) then
						-- 接任务音效
						SoundManager:playUISound( 'accept_task' , false )
						 self:create_a_skill_panel()
					elseif ( self.state == 1 ) then
						-- 提交任务音效
						SoundManager:playUISound( 'finish_task' , false )
					end 
				end
			end
			return true;
		end
		return true
	end
	self.view:registerScriptHandler(panel_function);

	-- 背景，标题，关闭按钮
	-- edited by aXing on 2014-4-22
	-- 不用默认的窗口抬头背景
	if self.window_title_bg ~= nil and self.window_title_bg.view ~= nil then
		self.window_title_bg.view:removeFromParentAndCleanup(true)
	end

	local btn_close_fun = function(  )
		UIManager:destroy_window( "npc_dialog" )
	end
	local close_btn = ZButton:create(self.view, UILH_COMMON.close_btn_z, btn_close_fun,0,0,60,60,999)
	local bg_size = self.view:getSize()
	local close_size = close_btn:getSize()
	close_btn:setPosition( bg_size.width - close_size.width , bg_size.height - close_size.height+15 )

	-- self.npc_name = MUtils:create_zxfont(self.view, "", content_info.x, content_info.y+5, 1, 20)
	-- 对话内容
	self.dialog_content = CCDialogEx:dialogWithFile(content_info.x, content_info.y, content_info.width, content_info.height, content_info.size, "" , TYPE_VERTICAL,ADD_LIST_DIR_UP);
	self.dialog_content:setAnchorPoint(0, 1)
	self.dialog_content:setFontSize(20);
	self.dialog_content:setLineEmptySpace(5)
	self.view:addChild(self.dialog_content);
	self.dialog_content:setText("");

	self.dialog_content_ex = CCDialogEx:dialogWithFile(content_ex_info.x, content_ex_info.y, content_ex_info.width, content_ex_info.height, content_ex_info.size, "" , TYPE_VERTICAL,ADD_LIST_DIR_UP);
	self.dialog_content_ex:setAnchorPoint(0, 1)
	self.dialog_content_ex:setFontSize(20);
	self.view:addChild(self.dialog_content_ex);
	self.dialog_content_ex:setText("");

	self.dialog_content:setCurState(CLICK_STATE_DISABLE)
	self.dialog_content_ex:setCurState(CLICK_STATE_DISABLE)
	-- 自述对话前的图标
	-- ZImage:create( self.view, UIResourcePath.FileLocate.task .. "task_talk.png", 270, 151, -1, -1)
	self.talk_icon = CCZXImage:imageWithFile(content_ex_info.x-45, content_ex_info.y - 34, -1, -1, UILH_TASK.arrow)
	self.view:addChild(self.talk_icon)

	self.frame_bg = ZImage:create(self.view, UILH_COMMON.bottom_bg, 32, 100, 360, 160, 0, 500, 500)
	self.frame2 = ZImage:create(self.view, UILH_NORMAL.title_bg3, 35, 235, -1, -1)
	self.award = ZImage:create(self.view, UILH_TASK.award, 177, 247, -1, -1)


	local function content_text_btn_fun( eventType,msg_id,arg )
		if eventType == TOUCH_BEGAN then
			return true;
		elseif ( eventType == TOUCH_CLICK ) then--76
			if ( self.text_btn_data ) then
				GlobalFunc:parse_str2( self.text_btn_data );
				btn_close_fun()
			end
			return true;
		end
		return true
	end
	self.award_tab = {};
	local x = 45;
	local y = 135;
	for i=0,3 do
		self.award_tab[i+1] = self:create_gold_exp(self.view, UILH_COMMON.slot_bg, x + i * 84, y);
	end
	-- 接受任务/完成任务 按钮
	local function btn_receive_fun(eventType,args,msg_id)
		if eventType == TOUCH_BEGAN then 
			return true;
		elseif( eventType == TOUCH_CLICK ) then
			Instruction:handleUIComponentClick(instruct_comps.MINI_TASK_BASE)
			self:do_quest_btn_function(  )
			return true;
		end
		return true
	end             
	self.receive_btn = MUtils:create_btn(self.view,
		UILH_NORMAL.special_btn,
		nil,
		btn_receive_fun, 139, 40, -1, -1, 10);
	-- self.btn_text = MUtils:create_zxfont( self.receive_btn, "接受任务", 60, 19, 2, 16 );
	-- self.btn_text = Mutils:
	-- self.receive_btn = MUtils:create_common_btn(self.view, "完成", btn_receive_fun, 555, 45)
	self.btn_text_spr1 = MUtils:create_sprite(self.receive_btn,UILH_TASK.accept,81,27);
	self.btn_text_spr2 = MUtils:create_sprite(self.receive_btn,UILH_TASK.finish,86,30);

	self.split_line = ZImage:create(self.view, UILH_TASK.line, 37, 257, width - 80, 3, 0, 500)
	self:create_scroll_view()
	self.delay0 = callback:new()
	self.delay1 = callback:new()
	self.delay2 = callback:new()

end

function NPCDialog:create_gold_exp(parent, bg, x, y)
	local slot_item = MUtils:create_slot_item( parent, bg, x, y, 83, 83, nil);
	slot_item:set_icon_bg_texture( bg, -9, -9, 83, 83 )   -- 背框
	function slot_item:set_icon_and_num(type, arg1, arg2, arg3)
		if type == 1 then
			local icon = awards_img[arg2] or ""
			-- slot_item:set_icon_bg_texture( bg, -18, -18, 100, 100 )   -- 背框
			slot_item:set_icon_texture(icon);
			slot_item:set_item_count(arg1)
			-- slot_item.view:setScale(0.73)
			-- slot_item.view:setPosition(x+18, y+18)
		else
			slot_item:set_icon_texture(arg1);
			-- slot_item:set_icon_bg_texture( bg, -5, -5, 73, 73 )   -- 背框
			-- slot_item.view:setScale(1.0)
			slot_item:set_item_count(arg2);
			slot_item:set_color_frame( arg3, 0, 0, 64, 64);
			local function f1()
				TipsModel:show_shop_tip( 450, 323, arg3,TipsModel.LAYOUT_LEFT );
			end
			slot_item:set_click_event( f1 )
		end
	end

	return slot_item
end

-- 暂时不弹技能学习窗口 需要更改界面后再打开 by hwl
function NPCDialog:create_a_skill_panel(  )
	   --create by jiangjinhong 
	--提交任务后判定下是否需要
	-- if self.current_task_id ~= nil then
	-- 	local player = EntityManager:get_player_avatar()
	-- 	local player_job = player.job
	-- 	local can_learn_skill = QuestConfig:get_can_learn_jineng( self.current_task_id,player_job )
	-- 	self.current_task_id = nil
	-- 	if can_learn_skill.skill_id ~= nil then 
	-- 		require "model/UserSkillModel"
	-- 		local skill_info = UserSkillModel:get_a_skill_by_id( can_learn_skill.skill_id )
	-- 		--skill_info ==nil 技能还没有学习过，此时应学习
	-- 		if skill_info == nil then 
	-- 			--暂停玩家动作，拉起小型技能学习面板
	-- 			AIManager:pause()
	-- 			require "UI/UIManager"
	-- 			local win = UIManager:show_window("small_jineng_win")
	-- 			win:update(can_learn_skill)
	-- 		end 
	-- 	end 
	-- end
end

function NPCDialog:do_quest_btn_function(  )
	if ( self.sever_fun_str ) then
		UIManager:hide_window("npc_dialog");
		GameLogicCC:req_talk_to_npc( self.talk_npc_handle, self.sever_fun_str );
		-- print("NPCDialog:do_quest_btn_function( self.talk_npc_handle, self.sever_fun_str  )",self.talk_npc_handle, self.sever_fun_str )
		self.talk_npc_handle = nil;
		self.sever_fun_str = nil;
		-- 0 接任务,1完成任务
		if ( self.state == 0 ) then
		-- 接任务音效
			-- SoundManager:playUISound( 'effect_receive' , false )
			SoundManager:playUISound( 'accept_task' , false )
			self:create_a_skill_panel()
		elseif ( self.state == 1 ) then
			-- 提交任务音效
			-- SoundManager:playUISound( 'effect_commit' , false )
			SoundManager:playUISound( 'finish_task' , false )

		end
	end 
end

function NPCDialog:update(_type,tab_arg)
   if ( _type == 1 ) then
		self:update_all(tab_arg);
   end
end

-- NPC的对话框有四种形态，0接任务1完成任务2是普通对话3是选择任务
function NPCDialog:update_all(tab_arg)
	local sever_str = tab_arg[1];
	local quest_name = nil;
	local task_id = nil;
	local content,dataSet,state = NPCDialog:parse_sever_str(sever_str);
	self.function_tab = dataSet;

	if self.dialog_content_ex ~= nil then
		self.dialog_content_ex:setIsVisible(false)
		self.talk_icon:setIsVisible(false)
		-- self.split_line:setIsVisible(false)
	end
	-- print("content,table,state",content,table,state)
	-- 没有content代表是普通任务,有content代表是副本任务
	if ( content == nil ) then
		quest_name = dataSet[1];
		state = tonumber(dataSet[2]);
		content = dataSet[3];
		self.sever_fun_str = dataSet[4];
		task_id = tonumber(Utils:Split(self.sever_fun_str, ",")[2]); 
		self.current_task_id =task_id

		print("self.current_task_id",self.current_task_id)
        
        --为了适应NPC对话打开几个分层副本的分页页面  只能在这里添加判断
  --       local fuben_id_task = {198,}
		-- for i=1,#fuben_id_task do
		-- 	if fuben_id_task[i] == self.current_task_id then

		-- 	end
		-- end
	   -- print("quest_name,state,content,self.sever_fun_str,task_id",quest_name,state,content,self.sever_fun_str,task_id)
		-- self.dialog_expend:setIsVisible(false);
		-- self.split_line2:setIsVisible(false)
		self.function_tab = nil
	else
		--
		local text_btn_table = Utils:Split(content, "&");

		--NPC功能是通过来区分的
		if ( #text_btn_table > 2 ) then
			content = text_btn_table[1];
			local _stringFunc = text_btn_table[3]

			local clientCallback = 
			{ 
				--显示信息
				[1] = { name = text_btn_table[2], p = _FUNC_PRORITY },
				--回调的函数，字符串表示
				[2] = _stringFunc,
				--预先绑定好的回调函数，点击使用
				bindFunc = function()
					GlobalFunc:parse_str2(_stringFunc)
					UIManager:hide_window("npc_dialog");
				end 
			}
			self.function_tab[#self.function_tab+1] = clientCallback
		else

		end
	end

	self.pointers[1]:setIsVisible(false)
	self.pointers[2]:setIsVisible(false)

	-- 状态3代表有多个任务选项 
	if ( state == 3  ) then

		local function cmp(a,b)
			return a[1].p < b[1].p
		end
		table.sort(self.function_tab,cmp)
		local _doubleOptions = {} 
		local n = #self.function_tab

		for i=1,n,2 do
			_doubleOptions[#_doubleOptions+1] = { self.function_tab[i], self.function_tab[i+1] }
		end
		self.function_tab = _doubleOptions

		-- if #self.function_tab > 2 then
		-- 	self.pointers[1]:setIsVisible(true)
		-- 	self.pointers[2]:setIsVisible(true)      
		-- end

		self.receive_btn:setIsVisible(false);

		self:set_visible(false)
		-- 奖励
		for i=1,4 do
			self.award_tab[ i ].view:setIsVisible(false);
		end
		
		if ( state == 3 ) then
			self.scroll:setIsVisible(true);
			self.scroll:reinitScroll();
			-- print("NPCDialog:update_all #table",#table)
			self.scroll:setMaxNum(#self.function_tab);
			self.scroll:refresh();
		else
			self.scroll:setIsVisible(false);
			self.scroll:reinitScroll();
		end
		-- 状态0代表有任务可接 状态1代表任务可完成 状态2代表任务进行中
	elseif ( state == 0 or state == 1 or state == 2) then
		-- 对话下调
		-- self.dialog_content:setPosition(content_info.x, content_info.y);

		-- 该显示的显示，该隐藏的隐藏
		-- self.quest_name_bg.view:setIsVisible(true)
		-- self.task_bg:setIsVisible(true);
		-- self.award_bg:setIsVisible(true)
		-- self.award_name_bg.view:setIsVisible(true)
		-- self.award_title:setIsVisible(true);
		self.receive_btn:setIsVisible(true);
		-- self.split_line:setIsVisible(true)

		local win = UIManager:find_visible_window("menus_panel");
		if ( state == 0) then
			self.receive_btn:setTexture(UILH_NORMAL.special_btn)
			self.receive_btn:setSize(162, 53)
			self.receive_btn:setPosition(CCPoint(139, 40))
			-- self.btn_text:setText("接受任务");
			-- 设置主界面动作按钮为接受任务
			if ( win ) then
				win:set_action_btn_state(5)
			end
			self.btn_text_spr1:setIsVisible(true)
			self.btn_text_spr2:setIsVisible(false)
		elseif ( state == 1 ) then
			self.receive_btn:setTexture(UILH_NORMAL.special_btn_g)
			self.receive_btn:setSize(170, 59)
			self.receive_btn:setPosition(CCPoint(136, 37))
			-- self.btn_text:setText("完成任务");
			-- 设置主界面动作按钮为完成任务
			if ( win ) then
				win:set_action_btn_state(6)
			end
			self.btn_text_spr1:setIsVisible(false)
			self.btn_text_spr2:setIsVisible(true)
		elseif ( state == 2 ) then
			self.receive_btn:setIsVisible(false);
			-- self.split_line:setIsVisible(false)
		end
		for i=1,4 do
			self.award_tab[ i ].view:setIsVisible(true);
		end
		self:set_visible(true)
		-- self.lace1.view:setIsVisible(true)
		-- self.lace2.view:setIsVisible(true)
		self.scroll:setIsVisible(false);
		self.scroll:clear();
	end

	-- 设置NPC名字
	self.str_npc_name = tab_arg[2];
	self.npc_name_txt:setString(LH_COLOR[1] .. self.str_npc_name)

	local npc_id = tab_arg[3];
	-- 更新NPC头像
	require "../data/npc"
	local tab_npc_info = npc_dialog_config[npc_id];
	--
	-- if ( self.npc_head == nil ) then
	--     -- npc头像
	--     self.npc_head = EntityPortrait()
	--     self.view:addChild(self.npc_head.view)
	-- end


	local npc_head_index = npc_id;
	if ( tab_npc_info[2] ) then
		npc_head_index = tab_npc_info[2];
	end

	--local npc_head_str  = _string_format("ui/npc/npc_%s",tab_npc_info[1]); --'ui/npc/npc_01000.png'
	-- local npc_name_head = _string_format("ui/npc/name_%d.png",npc_head_index); --'ui/npc/name_50.png' --
	self:setPortrait(npc_id)

	-- 设置任务名
	-- if ( quest_name ) then
	--     self.delay0:cancel()
	--     self.delay0:start(0.1, function()
	--         self.quest_name:setText("#cfff000" .. quest_name);
	--     end)
	-- end

	local pat1 = '<!&player>'
	local pat2 = '<!&mapname>'
	local player = EntityManager:get_player_avatar()
	-- 设置任务内容
	self.dialog_content:setText("");
	if ( content ) then
		self.delay1:cancel()
		self.delay1:start(0.2, function()
			content = LH_COLOR[15] .. content
			content = _parse_face(content)
			-- 转化玩家名字
			content = string.gsub(content, pat1, player.name)
			-- 转化地图名称
			local scene_id = SceneManager:get_cur_scene()
			local scene = SceneConfig:get_scene_by_id(scene_id)
			content = string.gsub(content, pat2, scene.scencename)
			self.dialog_content:enableGradient(false)
			self.dialog_content:setText(content);
		end)
	end

	-- 设置扩展对话
	if task_id ~= nil then
		
		local quest_config = QuestConfig:get_quest_by_id(task_id)

		if quest_config ~= nil and quest_config.MyMsTalks ~= nil then
			local talks = nil
			if state == 0 then                  -- 任务可接
				talks = quest_config.MyMsTalks[1]
			elseif state == 1 then              -- 任务已完成
				talks = quest_config.MyMsTalks[3]
			elseif state == 2 then              -- 任务进行中
				talks = quest_config.MyMsTalks[2]
			end

			if talks ~= nil and talks ~= "" then
				self.dialog_content_ex:setIsVisible(true)
				-- self.split_line:setIsVisible(true)
				self.talk_icon:setIsVisible(true)
				talks =  LH_COLOR[2] .. talks
				talks = _parse_face(talks,LH_COLOR[2])
				self.delay2:cancel()
				self.delay2:start(0.3, function()
					self.dialog_content_ex:enableGradient(false)
					self.dialog_content_ex:setText(talks)
				end)
			end
		end
	end

	-- self.award_bg:setIsVisible(false)
	-- 设置奖励
	local item_index = 0;
	local text_index = 0
	if ( task_id  ) then 
		local tab_awards = TaskModel:get_awards( task_id );
		local task_info = TaskModel:get_info_by_task_id(task_id)
		local awards_info ={}
		for i, v in ipairs(tab_awards) do
			if i > 4 then break end
			if v.show_type == 0 then
				table.insert(awards_info, 1, v)
			else
				table.insert(awards_info, v)
			end
		end
		-- 设置任务名称
		-- self.npc_name_txt:setString(LH_COLOR[1] .. task_info.name)
		-- print("奖励道具数量 = ",#tab_awards);
		for i=1,#awards_info do
			if i > 4 then break end
			local table = awards_info[i];
			-- print("table.show_type",table.show_type);
			-- 道具
			if ( table.show_type == 0) then
				-- self.award_bg:setIsVisible(true) -- 只要有slotItem的奖励，就显示奖励背景
				self.award_tab[i]:set_icon_and_num( table.show_type, table.icon_path,table.icon_count ,table.item_id);
				-- -- 装备名
				-- self.award_tab[3+item_index]:set_item_name(table.icon_name);
			elseif ( table.show_type == 1) then
				local award_type = table.type
				print("task_info.name:", task_info.name)
				if task_info.name == "银两任务" then
					-- 银两任务图标特殊处理
					award_type = 999 
				end
				self.award_tab[i]:set_icon_and_num( table.show_type, table.icon_count ,award_type);
			end
			item_index = item_index + 1
		end
	end
	
	for i=item_index + 1,4 do
		-- self.left_frame2.view:setIsVisible(false)
		-- self.award.view:setIsVisible(false)
		-- self.right_frame2.view:setIsVisible(false)
		-- self.bottom.view:setIsVisible(false)
		self.award_tab[ i ].view:setIsVisible(false);
	end

	-- 保存state
	self.state = state;

	if ( state ~= 2 and self.state ~= 0) then 
		self:on_xszy( task_id ,self.str_npc_name ,self.state)
	end
	self:on_fbzy(self.str_npc_name)
end

--返回
--     字符串，NPC文字内容
--     table   功能列表
--     { 
--         where 列表的每个item [1] = 显示内容 [2] = 回调字符串
--        { [1] = { name = xxx, p = xxx}, [2] = { stringFunc } },
--        { [1] = { name = xxx, p = xxx}, [2] = { stringFunc } },
--      }
--    返回nil or 3 状态3代表有多个任务选项 
function NPCDialog:parse_sever_str(sever_str)
	-- 普通任务对话框
	print("NPCDialog:parse_sever_str(sever_str)",sever_str)
	local tab_data = Utils:Split(sever_str, "|"); 
	if ( #tab_data > 1 ) then
		return nil,tab_data;
	end

	-- 副本或日常任务对话框
	local content,tab_choose = "",{};
	-- 首先分割"\"
	local str_table  = Utils:Split(sever_str, "\\");
	content = str_table[1];
	if ( str_table[2] == nil or str_table[2] == '' ) then
		return content,tab_choose,3;
	end

   -- print("content = ",content);
	for i=2,#str_table do
		local str = str_table[i];
		-- 如果为空就直接返回
		if ( str ~= "" ) then
			--找出回调函数所在
			local temp_table = Utils:Split(str, "/");
			local optionAttr = temp_table[1]
			local optionFunc = temp_table[2]
			--local extra = temp_table[3]
			--八卦地宫的领取
			if ( #temp_table >=3 ) then
				optionAttr = optionAttr.."/"..optionFunc;
				optionFunc = temp_table[3];
			end
			--解析params
			local dict = {}
			if optionAttr then
				local params = Utils:Split(optionAttr, ",");
				if #params == 1 then
					dict.name = params[1]
					dict.p = _FUNC_PRORITY
				else
					for i, v in ipairs(params) do
						local key,value = string.match(v,"(%Z+):(%Z+)")
						if key then
							dict[key] = value
						end
					end
					if dict.type == qtMain then
						dict.p = _MAIN_QUEST_PRORITY --主线优先度， 主线未接
					else
						dict.p = _OTHER_QUEST_PRORITY --支线未接，3
					end
					if dict.state == 1 then
						dict.p = dict.p - 1 --主线已完成 = 0 ，支线已完成 = 2
					elseif dict.state == 2 then --进行中
						dict.p = _QUEST_INPROGRESS
					end
				end
				temp_table[1] = dict
			end
			if optionFunc then
				-- 去掉@字符
				temp_table[2] = string.gsub(optionFunc,"@","");
			end
			tab_choose[#tab_choose+1] = temp_table
		end
	end
	--[[
	local params = Utils:Split(content, ",");
	local dict = {}
	for i, v in ipairs(params) do
		local key,value = string.match(v,"(%Z+):(%Z+)")
		if key then
			dict[key] = value
		end
	end

	for k,v in pairs(params) do
		print('>>>>>>>>>>',k,v)
	end

	for k,v in pairs(dict) do
		print('>>>>>>>>>>',k,v)
	end
	]]--
	return content,tab_choose,3;
end

-- 判断消失的Npc是不是当前对话框的npc，如果是，则要隐藏掉Npc对话框
function NPCDialog:on_npc_dismiss( npc_handle )
	if ( npc_handle ==  self.talk_npc_handle ) then
		UIManager:hide_window("npc_dialog");
	end 
end

function NPCDialog:on_xszy( task_id ,npc_name ,state )

	if ( task_id and QuestConfig:get_is_need_xszy( task_id ) ) then
		-- print("需要新手指引");
		local effect_id = 11036;
		if ( state == 1 ) then
			effect_id = 11035;
		end
		self.is_xszy = true;
		if task_id == 1 or task_id == 31 or task_id == 61 then
			Instruction:set_state(XSZYConfig.ZHUANG_BEI_ZY)
		end
		Instruction:play_jt_animation(649, 60, 120, 53, 2, 6, "nopack/ani_xszy.png", "nopack/xszy/5.png")
		LuaEffectManager:play_view_effect(effect_id, 220, 66, self.view, true, 9999)
		-- XSZYManager:play_jt_and_kuang_animation( 595,120,img_id ,3,127,41 ,XSZYConfig.NPCDIALOG_SELECT_TAG);
	-- else
	-- 	--print( "XSZYManager:get_state()",XSZYManager:get_state() );
	-- 	if ( ( XSZYManager:get_state() == XSZYConfig.FUBEN_ZY and npc_name == "历练副本" ) or 
	-- 		 ( XSZYManager:get_state() == XSZYConfig.ZXJZ_ZY and npc_name == "诛仙阵") or 
	-- 		 ( XSZYManager:get_state() == XSZYConfig.CWD_ZY and npc_name == "宠物岛") or
	-- 		 XSZYManager:get_state() == XSZYConfig.ZHIXIAN_ZY ) then
	-- 		--20,480-270-b_m - i*30
	-- 		-- XSZYManager:play_jt_and_kuang_animation( 23,175,"" ,1,208,24 ,XSZYConfig.NPCDIALOG_SELECT_TAG);
	-- 		XSZYManager:play_jt_and_kuang_animation_by_id(XSZYConfig.FUBEN_ZY,1,XSZYConfig.NPCDIALOG_SELECT_TAG);
	-- 		self.is_xszy = true;
	-- 	else
	-- 		self.is_xszy = false;
	-- 	end
	end

	--print("task_id = ",task_id,"self.is_xszy == ", tostring(self.is_xszy));

end

--副本指引
function NPCDialog:on_fbzy(npc_name)
	local cur_quest, quest_type = TaskModel:get_zhuxian_quest()
	if not cur_quest or quest_type ~= TYPE_YIJIE then return end
	--根据配置表,只有在任务未完成才弹指引
	local quest_info = TaskModel:get_info_by_task_id( cur_quest );
	local tab_target = quest_info.target;
	if #tab_target == 0 then return end
	-- 判断任务是否已完成
	local curr_process_value = TaskModel:get_process_value(cur_quest );
	if ( curr_process_value == nil ) then
        curr_process_value = 0;
    end
    if curr_process_value >= tab_target[1].count then return end
	-- 非已接主线任务不弹指引
	for i, tab in ipairs(self.fuben_xszy) do
		if tab.npc_name == npc_name and cur_quest == tab.quest_id then
			self.is_fbzy = true
			Instruction:play_jt_animation(560, 205, 330, 40, 2, 6, "nopack/ani_xszy.png", "nopack/xszy/5.png")
			LuaEffectManager:play_view_effect(11037, 189, 209, self.view, true)
			-- Instruction:lock_screen1(560, 245, 330, 40, false, 6, true, false)
			break
		end
	end
end

function NPCDialog:active( show )
	-- print("NPCDialog:active( show )",show)
	if ( show == false ) then
		if ( self.is_xszy ) then
			local effect_id = 11036;
			if ( self.state == 1 ) then
				effect_id = 11035;
			end
			LuaEffectManager:stop_view_effect(effect_id, self.view)
			Instruction:clear_jt_animation()
		end
		if (self.is_fbzy) then
			Instruction:clear_jt_animation()
			LuaEffectManager:stop_view_effect(11037, self.view)
			-- Instruction:unlock_screen()
		end
		-- 清除
		self.sever_str = nil;
		local win = UIManager:find_visible_window("menus_panel")
		if ( win ) then
			win:set_action_btn_state(1);
		end
		self:setPortrait(-1)
		self.delay0:cancel()
		self.delay1:cancel()
		self.delay2:cancel()
	end
end

function NPCDialog:get_current_talking_npc_name()
	local win = UIManager:find_window("npc_dialog");
	if ( win ) then
		return win.str_npc_name;
	end
	return "";
end

-- 播放文字动画
function NPCDialog:play_text_animation( str )
	self.dialog_content:setText( "" );
	if ( self.text_play_timer ) then
		self.text_play_timer:stop();
		self.text_play_timer = nil;
	end

	self.text_play_timer = timer();
	local text_index = 0;
	local old_index = 0;
	local str_len = string.len(str);
	local function text_cb()
		-- 如果读完所有字符串，结束文字动画
		if ( text_index >= str_len ) then
			self.text_play_timer:stop();
			self.text_play_timer = nil;
			return;
		end
		old_index = text_index + 1;
		-- 判断下一个字符是否为#
		local curr_str = string.sub(str,text_index+1,text_index+1);
		if ( curr_str == "#") then
			text_index = text_index + 8;
			local temp_str = string.sub( str, text_index+1, text_index + 2)
			local world_num = ZXTexAn:getUTF8Len( temp_str )
			text_index = text_index + world_num
		elseif ( curr_str == " " ) then
			text_index = text_index + 1;
			local flag = true;
			while( flag ) do
				if ( string.sub(str,text_index+1,text_index+1) ~= " " ) then
					flag = false
				else
					text_index = text_index + 1;
				end
			end
		else
			local sumnum =  ZXTexAn:getUTF8Len(curr_str)
			text_index = text_index + sumnum;
		end
		local result_str = string.sub(str,old_index,text_index)
		self.dialog_content:insertText(result_str);  
	end
	self.text_play_timer:start(0.05,text_cb);
end

function NPCDialog:setPortrait(npc_id)
	-- self.npc_head:setPortrait(npc_id,true)
end

function NPCDialog:onNameLoad(img)
	if self.name_str == img then
		local offset = texOffset[img]
		--print('onNameLoad',img, offset[1],offset[2])
		-- self.npc_name:replaceTexture(img)
	end
end


-- 创建任务条的滚动条
function NPCDialog:create_scroll_view()
	  -- 创建滚动条
	local _scroll_info = { x = 50, y = 50, width = 345, height = 180, maxnum = 0, stype = TYPE_HORIZONTAL }
	self.scroll = CCScrollDynamicArea:scrollWithFile( _scroll_info.x, _scroll_info.y, _scroll_info.width, _scroll_info.height, _scroll_info.maxnum, "", 600, 600 )
	self.view:addChild(self.scroll);
   
	local  scroll_pic_1 = MUtils:create_sprite(self.view, UILH_FORGE.force_jt,262+434,48)
	scroll_pic_1:setScale(0.5)
	scroll_pic_1:setRotation(90)

	local  scroll_pic_2 = MUtils:create_sprite(self.view, UILH_FORGE.force_jt,262+434,140)
	scroll_pic_2:setScale(0.5)
	scroll_pic_2:setRotation(270)

	self.pointers = { scroll_pic_1 , scroll_pic_2 }

	scroll_pic_1:runAction(_create2Flow(1.5,CCPointMake(0,12),1.5,CCPointMake(0,-12)))
	scroll_pic_2:runAction(_create2Flow(1.5,CCPointMake(0,-12),1.5,CCPointMake(0,12)))

	local function scrollfun(eventType, args, msg_id)
		if eventType == nil or args == nil or msg_id == nil then 
			return
		end
		if eventType == TOUCH_BEGAN then
			return true
		elseif eventType == TOUCH_MOVED then
			return true
		elseif eventType == TOUCH_ENDED then
			return true
		elseif eventType == SCROLL_CREATE_ITEM then

			local temparg = Utils:Split(args,":")
			local row = temparg[1] +1             -- 行
			-- print("row = " .. row);

			-- 每行的背景panel
			--local panel = CCBasePanel:panelWithFile(0,185-(row-1)*55,420,55,nil,0,0);
			local data =self.function_tab[row]
			local item = self:_resetItem(data,nil)
			self.scroll:addItem(item.view);
			--self:create_scroll_item( panel , row );
			self.scroll:refresh()
			return false
		end
	end
	self.scroll:registerScriptHandler(scrollfun);
	self.scroll:refresh()
end

function NPCDialog:create_scroll_item(parent, index )
	
	-- 选择任务
	local function text_btn_fun(eventType,args,msg_id)
		if ( eventType == TOUCH_CLICK ) then
			if ( self.function_tab ) then
				local sever_fun_str = self.function_tab[index][2];
				UIManager:hide_window("npc_dialog");
				GameLogicCC:req_talk_to_npc( self.talk_npc_handle, sever_fun_str );
				-- print("NPCDialog:create_scroll_item(self.talk_npc_handle, sever_fun_str )",self.talk_npc_handle, sever_fun_str )
				self.talk_npc_handle = nil;
				self.sever_fun_str = nil;                
				self.function_tab = nil;
			end
		end
		return true
	end
	-- print("NPCDialog:create_scroll_item info:", "#u1"..self.function_tab[index][1].."#u0")
	local text_btn = MUtils:create_text_btn(parent,"#u1"..self.function_tab[index][1].."#u0",0,0 ,500,55,text_btn_fun);
	text_btn:setFontSize(18);
end

function NPCDialog:destroy()
	if ( self.is_xszy ) then
		-- local effect_id = 418;
		-- if ( self.state == 1 ) then
		-- 	effect_id = 419;
		-- end
		-- LuaEffectManager:stop_view_effect(effect_id, self.view)
		Instruction:clear_jt_animation()
	end
	if (self.is_fbzy) then
		Instruction:clear_jt_animation()
		-- Instruction:unlock_screen()
	end
	-- 清除
	self.sever_str = nil;
	local win = UIManager:find_visible_window("menus_panel")
	if ( win ) then
		win:set_action_btn_state(1);
	end
	_scroll_item = {}
	--self:setPortrait(-1)
	self.delay0:cancel()
	self.delay1:cancel()
	self.delay2:cancel()  
	-- if self.npc_head then
	--     self.npc_head:destroy(); 
	-- end
	--self.scroll:destroy()
	Window.destroy(self);
end

function NPCDialog:_resetItem(data,comp)
	local _clickFunc = function(sever_fun_str)
		UIManager:hide_window("npc_dialog");
		GameLogicCC:req_talk_to_npc( self.talk_npc_handle, sever_fun_str );
		self.talk_npc_handle = nil;
		self.sever_fun_str = nil;                
		self.function_tab = nil;
	end

	if comp == nil then
		comp = { view = CCBasePanel:panelWithFile( 0, 4, 380, 100, nil) }
		comp.items = {}
		local x = -20
		local beg_y = 100
		for i, v in ipairs(data) do
			beg_y = beg_y - 50
			local info = data[i]
			local params = info[1]
			local content = ''
			-- 暂时去掉火影的旗子 by hwl
			-- local flagTexture = 'ui/npc_dialog/flagFunc.png'
			local count = params.num or '0'
			local prefix_id = tonumber(params.type) or -1
			local prefix = Lang.NPC_DIALOG_PREFIX[prefix_id]
			if count == '0' then
				count = ''
			else
				count = _string_format('剩余次数%s次',count)
			end
			content = prefix .. params.name .. '#r' .. count
			-- if params.state then
			--     flagTexture = _string_format('ui/npc_dialog/flagQ%s.png',params.state)
			-- end

			--print('$$',content)
			local sever_fun_str = info[2];
			--如果没有绑定过功能，绑定功能一般是任务之类的
			if not info.bindFunc then
				info.bindFunc = bind(_clickFunc,sever_fun_str)
			end

			local temp = ZBasePanel:create(comp.view, "", x, beg_y, 351, 41, 0, 500, 500)
			temp.temp_select = ZImage:create(temp, UILH_TASK.select, 0, 0, 351, 41)
			temp.temp_select.view:setOpacity(200)
			temp.temp_select.view:setIsVisible(false)
			local talk_icon = ZImage:create(temp.view, UILH_TASK.talk, 20, 6, -1, -1)
			local text = MUtils:create_ccdialogEx(temp.view,"", 63, 20, 300, 22, 30, 15);
			text:enableGradient(false)
			content = LH_COLOR[5] .. content
			text:setText(content)
			text:setAnchorPoint(0, 0.5)
			-- 创建一个空panel负责处理选中事件
			local front = CCBasePanel:panelWithFile(0, 0, 330, 50, nil, 500, 500)
			local function temp_event( eventType,arg,msgid )
				if eventType == nil or arg == nil or msgid == nil then 
		            return false;
		        end
		        if eventType == TOUCH_BEGAN then
		        	for i, item in ipairs(_scroll_item or {}) do
		        		item.temp_select.view:setIsVisible(false)
		        	end
		        	temp.temp_select.view:setIsVisible(true)
		        	return true
		        elseif eventType == TOUCH_CLICK then
		        	info.bindFunc()
		        	return true
		        elseif eventType == TOUCH_ENDED then
		        	temp.temp_select.view:setIsVisible(false)
		        	return true
		        elseif eventType == TOUCH_MOVED then
		        	temp.temp_select.view:setIsVisible(false)
		        	return true
		        end
		        return true
			end
			front:registerScriptHandler(temp_event)
			temp.view:addChild(front)
			-- temp:setTouchClickFun(info.bindFunc)
			-- local item = ZButton:create( comp.view, UILH_COMMON.btn4_nor, nil, x, 0, -1, -1)
			-- local flag = CCSprite:spriteWithFile(flagTexture)
			-- -- item.text = MUtils:create_ccdialogEx(temp,content,62,7,85,48,64,18);
			-- item.text:setAnchorPoint(0.5, 0.5)
			-- item.text:setCurState(CLICK_STATE_DISABLE)
			-- item:setTouchClickFun(info.bindFunc)
			temp.sever_fun_str = sever_fun_str
			comp.items[i] = temp
			_scroll_item[#_scroll_item + 1] = temp
			-- flag:setPosition(CCPointMake(24,30))
			-- item.view:addChild(flag)
			-- x = x + 186
		end
	end
	return comp
end