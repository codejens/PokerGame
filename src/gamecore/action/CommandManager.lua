-- CommandManager.lua
-- created by aXing on 2013-1-18
-- 主角指令集管理器

CommandManager = simple_class()

-- 普通移动
--entity 移动实体
--tx,ty目标位置
--cb_func 动作完成后回调
function CommandManager:move( entity,tx, ty, cb_func )
	if not entity then
		return
	end
	--lp todo
	-- 如果玩家当前状态是禁止移动或眩晕状态，直接返回

	local queue = {}
	local action = ActionMove{tx = tx, ty = ty,entity = entity}
	table.insert(queue, action)
	if cb_func ~= nil then
		table.insert(queue, ActionCallBack(cb_func));
	end
	entity:add_action_queue(queue)

end

-- 主角使用技能攻击
function CommandManager:combat_skill( skill )

	--如果没有技能，自动释放技能
	if not skill then
		--lp todo 获取可用技能
		skill = {
		id = 1,
		cd = 0,
	}
	end

	local player = EntityManager:get_player_avatar();
	-- 如果挂了，就不能放技能了
	if player:is_dead() then
		return
	end

	-- 只要技能没有cd，就可以释放
	if skill.cd ~= 0 then
		print("技能在冷却中,cd = ",skill.cd);
		return
	end

	-- 当获取技能最大释放距离
	local distance = 10--SkillConfig:get_spell_distance(skill.id, skill.level)[1];
	-- 有些技能范围是偶数
	if ( distance % 2  == 0 ) then
		distance = distance + 1;
	end

	-- 构建动作序列
	local queue  	= {}
	local approach  = ActionApproach{target_handle = player.target_id , distance = distance}
	local spell 	= ActionSpell(skill.id, player.target_id ,player)
	
	table.insert(queue, approach)
	table.insert(queue, spell)
	player:add_action_queue(queue)
	
end

-- 直接访问npc
function CommandManager:ask_npc(tile_x,tile_y,npc_name)
	local queue  	= {}
	local approach_static  = ActionApproachStatic{tile_x = tile_x, tile_y = tile_y, distance = 5}
	-- 访问action
	local aciont_ask = ActionAsk(npc_name);
	table.insert(queue, approach_static)
	table.insert(queue, aciont_ask)
	EntityManager:get_player_avatar():add_action_queue(queue)
end

-- 使用必杀技
function CommandManager:use_bishaji()

end

function CommandManager:gather(  target_name,tile_x,tile_y,gatherTime,gatherCount)

end

-- 采集
function CommandManager:quest_gather( target_scene_id,target_name ,target_id ,gatherTime,gatherCount)

end


-- 普通杀怪。点击怪物后会自动去打怪
function CommandManager:kill_monster( tile_x,tile_y )


end

-- 任务杀怪。点击怪物后会自动去打怪
function CommandManager:quest_kill_monster( target_scene_id,target_name ,target_id)

end


-- 移动到目标然后挂机打怪 tile_x,格子坐标
function CommandManager:auto_kill_monster( tile_x,tile_y )

end
