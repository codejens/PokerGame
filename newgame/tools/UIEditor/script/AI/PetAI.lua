-- PetAI.lua
-- created by hcl on 2013-3-11
-- 宠物AI

super_class.PetAI()

local curr_pet_fight_type = 1;

-- 测试时间
local test_time = 0;

function PetAI:__init()
	self:start_ai();
	return self;
end

function PetAI:start_ai()
	--print(".............................PetAI:start_ai...........................")
	local function tick( dt )
		PetAI:think(dt)
	end
	self.think_timer = timer()
	self.think_timer:start(t_petai_,tick)

	if ( PetModel:get_current_pet_info() ) then 
		curr_pet_fight_type = PetModel:get_current_pet_info().tab_attr[7];
	end
	-- print( "curr_pet_fight_type =============================================",curr_pet_fight_type );
end

function PetAI:stop_ai()
	self.think_timer:stop()
end

function PetAI:think(dt)
	-- 更新宠物技能cd
	--PetAI:update_skill_cd( dt );
	test_time = test_time + dt;

	local player = EntityManager:get_player_avatar();


	local pet = EntityManager:get_player_pet();

	if ( pet.model == nil ) then
		return;
	end
	-- print( "curr_pet_fight_type =============================================",curr_pet_fight_type );
	-- 1 防御型，2攻击型,3跟随型
	if ( curr_pet_fight_type == 1 ) then
		if ( AIManager:get_state() == AIConfig.COMMAND_KILL_MONSTER or AIManager:get_state() == AIConfig.COMMAND_GUAJI
			or AIManager:get_state() ==  AIConfig.COMMAND_FUBEN_GUAJI or pet.target_id ~= nil  ) then
			--print("pet._current_action",pet._current_action);
			if ( pet._current_action == nil ) then
				CommandManager:pet_combat_skill( PetAI:get_can_use_skill() );
			end
		else
			PetAI:is_pet_near_player() 
		end
	elseif ( curr_pet_fight_type == 2 ) then
		if ( AIManager:get_state() == AIConfig.COMMAND_KILL_MONSTER or AIManager:get_state() == AIConfig.COMMAND_GUAJI
			or AIManager:get_state() ==  AIConfig.COMMAND_FUBEN_GUAJI or pet.target_id ~= nil or player:get_curaction()==nil and player.is_jqdh == false ) then
		--	print("宠物攻击技能。。。。。。。test_time = ",test_time);
			if ( pet._current_action == nil ) then
				CommandManager:pet_combat_skill( PetAI:get_can_use_skill() );
			end
		else
			PetAI:is_pet_near_player() 
		end
	elseif ( curr_pet_fight_type == 3 ) then
		PetAI:is_pet_near_player() ;
	end

end

function PetAI:set_fight_type( fight_type )
	curr_pet_fight_type = fight_type;
end

-- 判断宠物是否在玩家附近
function PetAI:is_pet_near_player(  )
	local player = EntityManager:get_player_avatar();
	local player_pet = EntityManager:get_player_pet();
	if ( player and player_pet ) then
		local player_tx,player_ty = SceneConfig:pos2grid( player.x, player.y );
		local player_pet_tx,player_pet_ty = SceneConfig:pos2grid( player_pet.x, player_pet.y );
		local dx = player_tx - player_pet_tx;
		local dy = player_ty - player_pet_ty;
		local distance = math.sqrt(dx * dx + dy * dy);
		--print("玩家与他宠物的距离为:",distance);
		if ( distance < 2 ) then
			return true;
		end
		local ex,ey = 0;
		if ( player._current_action == nil ) then
			local x = math.random(0,3);
			ex = math.random(1,2);
			if ( x == 1 ) then
				ex = math.random(1,3)  ;
			else
				ex = math.random(-3,-1);
			end
		
			ey = math.random(1,2);
			if ( ey == 1 ) then
				ey = math.random(1,3);
			else
				ey = math.random(-3,-1);
			end
		end 
		-- 宠物靠近玩家
--		print("宠物靠近玩家",player.x + ex * SceneConfig.LOGIC_TILE_WIDTH,player.y + ey * SceneConfig.LOGIC_TILE_HEIGHT)
		CommandManager:move( player.x + ex * SceneConfig.LOGIC_TILE_WIDTH, player.y + ey * SceneConfig.LOGIC_TILE_HEIGHT, true,nil,EntityManager:get_player_pet());
	else

	end
	return false;
end

-- 根据主角的坐标得到宠物要移动的坐标
function PetAI:get_pet_move_pos( player_move_pos_x,player_move_pos_y )
	
	local player_pet = EntityManager:get_player_pet();
	local tx = math.floor(( player_move_pos_x - player_pet.x )/SceneConfig.LOGIC_TILE_WIDTH);
	local ty = math.floor(( player_move_pos_y - player_pet.y )/SceneConfig.LOGIC_TILE_HEIGHT);
--	print("PetAI:get_pet_move_pos:tx,ty = ",tx,ty,"player_pet_x = ",player_pet.x);
	-- 如果玩家移动的距离不超过宠物3格
	local distance = math.sqrt(dx * dx + dy * dy);
	if ( distance < 4 ) then
		return nil,nil;
	end
	-- -- 如果玩家要移动的y坐标大于宠物现在的y坐标三格
	-- local move_pos_y ,move_pos_x= nil;
	-- if ( math.abs(ty) >= 3 ) then
	-- 	move_pos_y = player_move_pos_y + (ty - 3) * SceneConfig.LOGIC_TILE_HEIGHT;
	-- 	if (  (ty - 3) >= 3 ) then
	-- 		move_pos_x = player_pet.x;
	-- 	else
	-- 		if ( tx > 0 ) then
	-- 			move_pos_x = player_move_pos_x - ( 3-(ty-3) ) * SceneConfig.LOGIC_TILE_WIDTH ;
	-- 		else
	-- 			move_pos_x = player_move_pos_x + ( 3-(ty-3) ) * SceneConfig.LOGIC_TILE_WIDTH ;
	-- 		end
			
	-- 	end
	-- else
	-- 	move_pos_y = player_pet.y;
	-- 	if ( tx > 0 ) then
	-- 		move_pos_x = player_move_pos_x - 3 * SceneConfig.LOGIC_TILE_WIDTH ;
	-- 	else
	-- 		move_pos_x = player_move_pos_x + 3 * SceneConfig.LOGIC_TILE_WIDTH ;
	-- 	end
	-- end

	
	
	return move_pos_x,move_pos_y;
end

-- 取得宠物当前可用的技能,首先计算所有主动技能的概率，和cd
function PetAI:get_can_use_skill(  )

	
	-- 取得当前出战宠物技能数据表
	local pet_skill_tab = PetModel:get_current_fight_pet_skill_info()
	-- 设置随即种子
	local x = math.random(0,100);
	--print("随机数-------------------------x = ",x);
	for i=1,#pet_skill_tab do

		-- 宠物技能不是被动和没有进入cd
		if ( pet_skill_tab[i].is_beidong == false and pet_skill_tab[i].skill_cd == 0 ) then
			-- 取得施放几率
			local rate = PetConfig:get_pet_skill_rate( pet_skill_tab[i].skill_id ,pet_skill_tab[i].skill_lv);
			--print("取得施放几率----------------------rate = ",rate);
			-- 计算概率，如果返回true则施放这个技能
			if ( PetAI:calculate_rate( rate ) ) then
				-- 开始计算技能cd
				--pet_skill_tab[i].skill_cd = pet_skill_tab[i].skill_max_cd;
				--print("返回技能id---------------------- = ",pet_skill_tab[i].skill_id);
				return pet_skill_tab[i].skill_id;
			end
		end
	end
	-- 如果没找到就返回肉搏技能
	return 78;
end

-- 计算概率
function PetAI:calculate_rate( rate )
	

	-- 得到随即数
	local x = math.random(1,100);
	--print("随机数-------------------------x = ",x);
	if ( rate * 100 > x ) then
		return true;
	end
	return false;
end

-- -- 更新宠物技能cd
-- function PetAI:update_skill_cd( dt )
-- 	-- 取得当前出战宠物技能数据表
-- 	local pet_skill_tab,normal_skill = PetModel:get_current_fight_pet_skill_info();
-- 	for i=1,#pet_skill_tab do
-- 		print("i = ",i,"pet_skill_tab[i].skill_cd,dt",pet_skill_tab[i].skill_cd,dt);
-- 		if ( pet_skill_tab[i].skill_cd > 0 ) then
-- 			pet_skill_tab[i].skill_cd = math.max( 0,pet_skill_tab[i].skill_cd - dt );
-- 			--print("更新宠物技能cd,",pet_skill_tab[i].skill_cd)
-- 		end
-- 	end
-- 	if ( normal_skill.skill_cd > 0 ) then
-- 		normal_skill.skill_cd = math.max( 0,normal_skill.skill_cd - dt );
-- 	end
-- end

-- 当主角或主角宠物被攻击时
function PetAI:on_player_avatar_be_attacked( attacker_handle ,be_attacked_handle)

	local pet = EntityManager:get_player_pet();
	if ( pet ) then
		if ( pet.target_id == nil ) then
			pet.target_id = attacker_handle;
		end
	end


end