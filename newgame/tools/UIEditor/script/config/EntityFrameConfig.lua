-- EntityFrameConfig
-- create by fjh on 2013-3-29
-- 序列帧的路径配置
require '../data/scene/entity_frame_config'
-- 获取人物路径
function EntityFrameConfig:get_human_path( body_id )
	print("人物body",body_id);

	local text = "frame/human"..EntityFrameConfig.HUMAN_PATH[body_id];
	return string.format(text,body_id); 
end

-- 获取武器路径
function EntityFrameConfig:get_weapon_path( weapon_id )
	print("===========================weapon_id = ",weapon_id);

	return string.format("frame/weapon"..EntityFrameConfig.WEAPON_PATH[weapon_id]); 
	-- return string.format("frame/weapon/01000"); 
end

-- 获取斗法台里宠物的序列帧路径
function EntityFrameConfig:get_doufatai_pet_path( pet_id )
	return string.format("scene/monster/%d",pet_id);
end

-- 获取仙浴里人物游泳姿态的路径
function EntityFrameConfig:get_xianyun_human_path( body_id )
	--   当body_id 大于 21000时，意味着这时角色穿着时装
	if (body_id >= 1000 and body_id < 1100) or (body_id >= 21000 and body_id < 21100) then
		-- 天雷男性
		return "frame/human/xianyu/01000";
	elseif (body_id >= 1100 and body_id < 2000) or (body_id >= 21100 and body_id < 22000) then
		-- 天雷女性
		return "frame/human/xianyu/01100";
	elseif (body_id >= 2000 and body_id < 2100) or (body_id >= 22000 and body_id < 22100) then
		-- 蜀山男性
		return "frame/human/xianyu/02000";
	elseif (body_id >= 2100 and body_id < 3000) or (body_id >= 22100 and body_id < 23000) then
		-- 蜀山女性
		return "frame/human/xianyu/02100";
	elseif body_id >= 3000 and body_id < 3100 or (body_id >= 23000 and body_id < 23100) then
		-- 圆月男性
		return "frame/human/xianyu/03000";
	elseif body_id >= 3100 and body_id < 4000 or (body_id >= 23100 and body_id < 24000) then
		-- 圆月女性
		return "frame/human/xianyu/03100";
	elseif body_id >= 4000 and body_id < 4100 or (body_id >= 24000 and body_id < 24100) then
		-- 云华男性
		return "frame/human/xianyu/04000";
	elseif body_id >= 4100 and body_id < 5000 or (body_id >= 24100 and body_id < 25000) then
		-- 云华女性
		return "frame/human/xianyu/04100";
	elseif 	body_id==10000 then
		return "frame/human/0/10000";
	end
end

-- 获取npc路径
function EntityFrameConfig:get_npc_path( npc_body_id )
	
	--local path = "scene/npc"..EntityFrameConfig.NPC_PATH[npc_id];
	
	return string.format('scene/npc/%d',npc_body_id); 
end

-- -- 获取翅膀资源路径
-- function EntityFrameConfig:get_wing_path( wing_id )
-- 	local wing_id = tonumber(wing_id);
-- 	if wing_id > 3 then
-- 		wing_id = 3;
-- 	end
-- 	local path = "frame/wing"..wing_id;
-- end

-- 根据职业获得60级装备的id
function EntityFrameConfig:get_60lv_body_id( job )
	local body_tab = { 1131,2031,3131,4031 }
	return body_tab[job];
end

-- 根据职业获得60级武器的id
function EntityFrameConfig:get_60lv_weapon_id( job )
	local body_tab = { 1977311,2043847,2110383,2176899 }
	return body_tab[job];
end