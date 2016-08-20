-- 新手体验副本
NewerCampModel = {}

-- 玩家在新手副本中的当前进度
local curr_progress = 1
local is_show = true
local is_cancel = true 	--是否可以跳过动画
local function resume_player_hp(player)
	if player.hp < player.maxHp then
		local pack = NetManager:get_socket():alloc(0,7)
		-- attr count
		pack:writeByte(1)
		-- attr id
		pack:writeByte(7)
		-- attr value
		pack:writeUInt(player.maxHp)
		NetManager.SendToClient(pack)
	end
end

local function last_movie_callback()
	-- 向服务器请求离开新手体验副本
	NewerCampCC:request_exit_newercamp()
end

--使用必杀技
local function usePowerSkill()
	AIManager:set_state(AIConfig.COMMAND_IDLE)
	local win = UIManager:find_window("menus_panel");
    if ( win ) then
        win:updateAngerBar(100);
    end
	--播放完电影后的回调
    local function movie_back()
    	local timer2 = callback:new()
    	local function show()
    		NewerCampModel:create_font_label()
    	end
        timer2:start(0.8,show)
	end
    local function cb()
    	if ( win ) then
	        win:updateAngerBar(0);
	    end
    	-- 控制电影延迟显示
    	local timer1 = callback:new()
    	local function call_movie()
    		Cinema:stop()
			Cinema:init()
	        Cinema:play('act26', movie_back, true)
    	end
    	timer1:start(2.5,call_movie)
    end
    Instruction:start(27, cb, 999)
end

function NewerCampModel:run_label_func(node, delay)
    local t0 = CCScaleTo:actionWithDuration( 0.2, 1.0 )
    local array_1 = CCArray:array()
    array_1:addObject(CCDelayTime:actionWithDuration(delay))
    array_1:addObject(CCShow:action())
    array_1:addObject(t0)
    local seq_1 = CCSequence:actionsWithArray(array_1)
    node:runAction( seq_1 )
end

--最后一个字特殊处理
function NewerCampModel:run_label_last(last_lab, node, delay)
	local t0 = CCScaleTo:actionWithDuration( 0.1, 2.5 )
    local t1 = CCScaleTo:actionWithDuration( 0.1, 2.6 )
    local t2 = CCScaleTo:actionWithDuration( 0.1, 0.5 )
    local t3 = CCScaleTo:actionWithDuration( 0.1, 1.1 ) 
    local t4 = CCScaleTo:actionWithDuration( 0.1, 1.0 )
    local array_1 = CCArray:array()
    array_1:addObject(CCDelayTime:actionWithDuration(delay))
    array_1:addObject(CCShow:action())
    array_1:addObject(t0)
    array_1:addObject(t1)
    array_1:addObject(t2)
    array_1:addObject(t3)
    array_1:addObject(t4)
    local seq_2 = CCSequence:actionsWithArray(array_1)
    node:runAction( seq_2 )

	local t0 = CCScaleTo:actionWithDuration( 0.2, 1.0 )
    local array_1 = CCArray:array()
    array_1:addObject(CCDelayTime:actionWithDuration(delay+0.3))
    array_1:addObject(CCShow:action())
    array_1:addObject(t0)
    array_1:addObject(CCHide:action())
    local seq_1 = CCSequence:actionsWithArray(array_1)
    last_lab:runAction( seq_1 )
end

function NewerCampModel:before_exit_fuben()
	-- 新手副本通关,即将被传出
	local win = UIManager:find_visible_window("menus_panel")
	if win then
		win:ClearSkillPanel()
	end
	if self.DummyControl then
		self.DummyControl:destroy()
	end

	-- 清除玩家的可用技能,等待从服务器获取真正的技能列表来初始化它
	-- UserSkillModel:clear_can_use_skill_list()

	-- 去掉玩家身上的翅膀和法宝、恢复满血状态
	local player = EntityManager:get_player_avatar()
	if player then
		-- player:update_wing_and_fabao(0)
		-- player:hide_fabao()
		resume_player_hp(player)
	end
end
function NewerCampModel:exit_fuben()
	NewerCampModel:before_exit_fuben()
    local win = UIManager:find_window("right_top_panel");
	if ( win ) then
    	win:set_fuben_exit_ben_visible(true);
		Instruction:start(28, last_movie_callback, 999)
	else
		last_movie_callback()
    end
end

--震动
local function camera_shake()
    local player = EntityManager:get_player_avatar();
	local root = ZXLogicScene:sharedScene()
	local x = math.random(-4,4);
    local y = 0;
    local z = 0;
    local timer = timer();
    local index = 0;
    local function cb()
        z = math.random(1,2);
        if ( z == 2 ) then 
            x = math.random(-10,10);
            y = math.random(-10,10);
            root:moveCameraMap(player.x + x, player.y + y);
        end
        index = index + 1;
        if ( index == 60 ) then 
            timer:stop();
        end
    end
    timer:start(0.001,cb)
end

function NewerCampModel:create_font_label()
	local lab_pos = { {815, 530}, {815, 455}, {730, 450}, {730, 375}, {730, 300}, {730, 225}, {730, 150}, {645, 365}, {645, 290}, {645, 215}, {570, 124}, }
	local font_img = UILH_XSFB or {}
	local font_label = {}
	local ui_node = ZXLogicScene:sharedScene():getUINode();
	local label_panel = CCArcRect:arcRectWithColor(0,0,GameScreenConfig.ui_screen_width,GameScreenConfig.ui_screen_height, 0x00000055);
	ui_node:addChild(label_panel,99998);
	local click = false
	local function panel_fun(eventType,x,y)
        if  eventType == TOUCH_BEGAN then
            return true
        elseif eventType == TOUCH_CLICK then
        	return true
        end
        return true
    end
    label_panel:registerScriptHandler(panel_fun);
	for i, v in ipairs(font_img) do
		local grade_bg = MUtils:create_sprite(ui_node,font_img[i], lab_pos[i][1], lab_pos[i][2], 99999)
		grade_bg:setScale(1.8)
		-- grade_bg:setAnchorPoint(0.5,0.5)
		grade_bg:setIsVisible(false)
		font_label[#font_label+1] = grade_bg
	end
	local delay = 0.1
	local lab_num = #font_label
	for idx, lab in ipairs(font_label) do
		if idx == lab_num then break end
		self:run_label_func(lab, delay + 0.12*idx)
	end
	-- 最后一个字特殊处理
	local last_lab = MUtils:create_sprite(ui_node,font_img[lab_num], lab_pos[lab_num][1], lab_pos[lab_num][2], 99998)
	font_label[#font_label+1] = last_lab
	last_lab:setIsVisible(false)
	last_lab:setScale(5)
	last_lab:setOpacity(100)
	self:run_label_last(last_lab, font_label[lab_num], delay + 0.12*lab_num)

	--屏幕震动
	local call = callback:new()
	call:start(0.2 + 0.12*lab_num, camera_shake)

	local cb = callback:new()
	local function dismiss()
		for i, v in ipairs(font_label or {}) do
    		v:removeFromParentAndCleanup(true)
    	end
    	label_panel:removeFromParentAndCleanup(true)
    	local movie_id = NewerCampConfig:get_movie_id_by_progress(curr_progress-2)
		if movie_id then
			Cinema:stop()
			Cinema:init()
			Cinema:play(movie_id, NewerCampModel.exit_fuben, true)
		else
			NewerCampModel:exit_fuben()
		end
	end
	cb:start(4.1, dismiss)
end

function NewerCampModel:init()
	-- 清空愤怒值
	local win = UIManager:find_window("menus_panel");
    if ( win ) then
    	win:check_anger_btn_show()
        win:updateAngerBar(0);
    end
	-- 初始化怪物
	self:init_monster_by_progress()
	-- 初始化任务
	-- self:init_quest_by_progress()
	-- 初始化技能
	-- self:init_skill_by_progress()
	AIManager:toggle_guaji()
	-- 初始化宠物
	-- self:init_pet_list()
	-- 初始化翅膀、式神、宠物相关信息
	-- self:init_wing_pet_fabao()
end

function NewerCampModel:fini()
	curr_progress = 1
	if self.DummyControl then
		self.DummyControl:destroy()
	end
end

function NewerCampModel:get_curr_progress()
	return curr_progress
end

-- 设置新手副本的当前进度
function NewerCampModel:set_get_curr_progress(progress)
	curr_progress = progress
end

local function firstMovieFinishCallback()
	NewerCampModel:init()
	local player = EntityManager:get_player_avatar()
	if player then
		player:setIsVisible(true, 256)
		-- 恢复默认优先级
		player:setOperationPriority(0)
	end
end

function NewerCampModel:check_first_movie()
	-- 玩家当前坐标与出生点坐标的偏差
	local player        = EntityManager:get_player_avatar()
	local posX, posY    = player.model.m_x, player.model.m_y
	local bornPos       = NewerCampConfig:get_born_position()
	local tile_x,tile_y = SceneManager:pixels_to_tile( posX, posY )

	-- 开场动画只播放一次,第二次进入的时候,不在播放
	if tile_x ~= bornPos.x then
		self:init()
		return
	else
		is_show = false
		local old_prior = 0
		local function finish_callback()
			NewerCampModel:init()
			player:setIsVisible(true, 256)
			player:setOperationPriority(old_prior)
			NewerCampModel:move_by_progress()
		end

		local movie_id = NewerCampConfig:get_movie_id_by_progress(0)
		if movie_id then
			-- 隐藏主角
			-- old_prior = player:setIsVisible(false, 255)
			Cinema:stop()
			Cinema:init()
			Cinema:play(movie_id, finish_callback, true)
		else
			finish_callback()
		end
	end
end

function NewerCampModel:move_by_progress()
	local curSceneId = SceneManager:get_cur_scene()
	-- local postions = NewerCampConfig:get_move_pos_by_id(curSceneId)
	if curr_progress == 2 and curSceneId == 27 then
		-- if postions and postions[curr_progress] then
		-- 	local cb = callback:new()
		-- 	cb:start(1,usePowerSkill)
		-- else
			usePowerSkill()
		-- end
	end
end
-- 初始化数据
function NewerCampModel:init_by_progress(progress,posX,posY)
	curr_progress = progress
	if curr_progress >= 3 then
		NewerCampCC:request_exit_newercamp()
		return
	end
	-- 设置随机种子
	math.randomseed(os.time())

	-- 检查当前的场景ID
	local curSceneId = SceneManager:get_cur_scene()
	if curSceneId == 27 then
		if progress == 1 then
			self:check_first_movie()
		elseif progress == 2 then
			self:init()
			usePowerSkill()
		else

		end
	end
end

-- 初始化宠物列表数据
function NewerCampModel:init_pet_list()
	PetCC:req_get_pet_list()
end

-- 进度发生改变的时候,需要更新数据
function NewerCampModel:update_by_progress()
	self:update_monster_after_clearance()
	-- self:update_quest_after_clearance()
end

-- 服务器下发进度后,初始化怪物配置
function NewerCampModel:init_monster_by_progress()
	local monster_conf = NewerCampConfig:get_progress_config(curr_progress)
	if monster_conf then
		local lbX,lbY,rtX,rtY
		lbX = monster_conf.x - monster_conf.radius
		lbY = monster_conf.y - monster_conf.radius
		rtX = monster_conf.x + monster_conf.radius
		rtY = monster_conf.y + monster_conf.radius
		-- 设置控制系统
		if self.DummyControl then
			self.DummyControl:destroy()
			self.DummyControl = nil
		end

		self.DummyControl = DummyControlCC(lbX, lbY, rtX, rtY, curr_progress)
	end
end

function NewerCampModel:init_quest_by_progress()
	TaskCC:req_task_list_from_dummy_server()
end

function NewerCampModel:init_skill_by_progress()
	UserSkillCC:request_skill_list_from_dummy_server()
end

function NewerCampModel:init_wing_pet_fabao()
	-- 判断玩家当前在新手副本中,到达的关卡等级
	local attri_value = NewerCampConfig:get_shishen_wing_value()
	local player = EntityManager:get_player_avatar()
	if player then
		-- 带上法宝
		local fabao_id = ZXLuaUtils:highByte(attri_value)
		player:update_fabao(fabao_id)

		-- 带上宠物
		if curr_progress >= 2 then
			self:AddPetToScene()
		end

		-- 带上翅膀
		if curr_progress == 3 then
			local wing_id = ZXLuaUtils:lowByte(attri_value)
			if wing_id ~= 0 then
				player:update_wing(wing_id)
			else
				player:take_off_wing()
			end
		end
	end
end

-- 玩家完成某一关之后,清理上一关的怪物,刷新关卡的怪物出来
function NewerCampModel:update_monster_after_clearance()
	local monster_conf = NewerCampConfig:get_progress_config(curr_progress)
	if monster_conf then
		local lbX,lbY,rtX,rtY
		lbX = monster_conf.x - monster_conf.radius
		lbY = monster_conf.y - monster_conf.radius
		rtX = monster_conf.x + monster_conf.radius
		rtY = monster_conf.y + monster_conf.radius

		-- 设置控制系统
		if not self.DummyControl then
			self.DummyControl = DummyControlCC(lbX, lbY, rtX, rtY, curr_progress)
		else
			-- 设定怪物新的活动范围
			self.DummyControl:SetupMonsterActiveArea(lbX, lbY, rtX, rtY)
			-- 如果上一关的怪物没有清理干净,则清除所有剩余怪物
			self.DummyControl:ClearMonster()
			-- 刷新关卡里面的怪物出来
			self.DummyControl:SetupMonsterLogic(curr_progress)
			if curr_progress == 2 then
				self.DummyControl:SetupMonsterLogic(curr_progress+1)
			end
		end
	end
end

function NewerCampModel:update_quest_after_clearance()
	TaskCC:req_task_list_from_dummy_server()
end

function NewerCampModel:GetDummyControlObj()
	return self.DummyControl
end

-- 打到第二关获得宠物
-- 打到第3关获取翅膀
local function other_movie_callback()
	-- 更新任务、怪物
	NewerCampModel:update_by_progress()

	NewerCampModel:move_by_progress()
	-- if curr_progress == 2 then
	-- 	NewerCampModel:AddPetToScene()
	-- elseif curr_progress == 3 then
	-- 	local attri_value = NewerCampConfig:get_shishen_wing_value()
	-- 	local wing_id     = ZXLuaUtils:lowByte(attri_value)
	-- 	local player      = EntityManager:get_player_avatar()
	
	-- 	if player then
	-- 		if wing_id ~= 0 then
	-- 			player:update_wing(wing_id)
	-- 		else
	-- 			player:take_off_wing()
	-- 		end
	-- 	end
	-- end
end

function NewerCampModel:ReportProgress()
	local progress = curr_progress + 1
	if progress == 3 then progress = 4 end
	NewerCampCC:report_new_progress(progress)
	curr_progress = progress

	-- 获取在播放动画前是否需要移动到某一个点
	local curSceneId = SceneManager:get_cur_scene()
	local postions = NewerCampConfig:get_move_pos_by_id(curSceneId)
	-- local dur = 0
	-- if postions and postions[curr_progress - 1] then
	-- 	local pos = postions[curr_progress - 1]
	-- 	dur = pos.dur
	-- 	local player = EntityManager:get_player_avatar();
	-- 	CommandManager:move( pos.x, pos.y, true ,nil,player);
	-- end

	-- local timer = callback:new()
	print('progress:', progress)
	-- 更新其他数据
	if progress < 3 then
		-- 播放动画
		local movie_id = NewerCampConfig:get_movie_id_by_progress(progress-1)
		if movie_id then
			Cinema:stop()
			Cinema:init()
			Cinema:play(movie_id, other_movie_callback, true)
		else
			other_movie_callback()
		end
	-- 第一个剧情副本这一步放在播放文字之后
	else
		-- 销毁宠物实体
		-- NewerCampModel:RemovePetFromScene()

		-- -- 清除UserPanel中的宠物头像
		-- local win = UIManager:find_visible_window("user_panel")
		-- if win then
		-- 	win:delete_pet()
		-- end

		-- 播放最后一个动画
		-- local timer = callback:new()
		-- local function cb()
		-- 	local movie_id = NewerCampConfig:get_movie_id_by_progress(progress-1)
		-- 	if movie_id then
		-- 		Cinema:stop()
		-- 		Cinema:init()
		-- 		Cinema:play(movie_id, last_movie_callback, true)
		-- 	else
		-- 		last_movie_callback()
		-- 	end
		-- end
		-- timer:start(2, cb)
	end
end

-- 根据当前的进度,获取玩家正在做的任务id
function NewerCampModel:GetCurrentQuest()
	local monster_conf = NewerCampConfig:get_progress_config(curr_progress)
	if monster_conf then
		return monster_conf.quest_id
	end
end

function NewerCampModel:CreatePetEntity()
	local pet_info = NewerCampConfig:get_pet_entity_by_index(1)
	local player   = EntityManager:get_player_avatar()
	if not pet_info or not player then
		return
	end

	local pos_x,pos_y = player.model.m_x - 10, player.model.m_y - 10
	-- local pos_x, pos_y = pet_info.x, pet_info.y

	local pet_name = pet_info.name
	if type(pet_name) ~= "string" or not player.name then
		return
	end
	pet_name = pet_name .. "\\" .. player.name
	local entity_id = pet_info.entity_id

	local handle  = 1000;
	local is_exist_entity = EntityManager:get_entity(handle)
	if is_exist_entity then
		return
	end

	local pack = NetManager:get_socket():alloc(0, 2)
	pack:writeString(pet_name)
	-- 怪物id
	pack:writeInt(entity_id)
	-- handle
	pack:writeInt64(handle)
	-- 类型
	pack:writeInt(4)
	-- 坐标x
	pack:writeInt(pos_x)
	-- 坐标y
	pack:writeInt(pos_y)
	-- move_x
	pack:writeInt(pet_info.move_x)
	-- move_y
	pack:writeInt(pet_info.move_y)
	-- model id
	pack:writeInt(pet_info.model_id)
	-- dir
	pack:writeByte(pet_info.dir)
	-- 等级
	pack:writeByte(pet_info.level)
	-- HP
	pack:writeUInt(pet_info.hp)
	-- Max HP
	pack:writeUInt(pet_info.maxHp)
	-- move speed
	pack:writeWord(pet_info.moveSpeed)
	-- attack speed
	pack:writeWord(pet_info.attackSpeed)
	-- state
	pack:writeUInt(pet_info.state)
	-- monster name corlor
	pack:writeUInt(pet_info.name_color)
	-- monster attack type and title
	pack:writeByte(pet_info.wing)
	-- npc功能id
	pack:writeInt(pet_info.func)
	-- pet title
	pack:writeInt(pet_info.pet_title)
	-- title
	pack:writeInt(pet_info.title)
	-- master handle
	pack:writeUint64(player.handle)
	-- effect count
	pack:writeByte(0)

	-- 发送到客户端
	NetManager.SendToClient(pack)
end

function NewerCampModel:PetFight(do_type)
	local pack = NetManager:get_socket():alloc()
	-- 回收宠物
	if do_type == 0 then
		pack:writeInt(0)
	else
		pack:writeInt(7074)
	end
	pack:writeInt(do_type)
	pack:writeInt(0)
	pack:setPosition(0)
	PetCC:do_fight(pack)
end

-- 向场景中添加宠物
function NewerCampModel:AddPetToScene()
	-- 第一步：创建实体
	NewerCampModel:CreatePetEntity()
	-- 第二步：do_fight 设置宠物的状态为战斗状态
	NewerCampModel:PetFight(1)
end

function NewerCampModel:RemovePetFromScene()
	local pet = EntityManager:get_player_pet()
	if pet then
		-- 回收宠物
		self:PetFight(0)
		-- 清空宠物列表
		self:ClearPetList()
		-- 销毁宠物实体
		EntityManager:destroy_entity(pet.handle)
	end
end

function NewerCampModel:ClearPetList()
	local pack = NetManager:get_socket():alloc()
	local is_client = true
	-- 宠物栏的大小
	local pet_max_num = 0
	-- 宠物的数量
	local pet_curr_num = 0
	
	pack:writeInt(pet_max_num)
	pack:writeInt(pet_curr_num)

	-- pack复位
	pack:setPosition(0)

	PetCC:do_get_pet_list(pack, is_client)
end

function NewerCampModel:can_cancel()

end