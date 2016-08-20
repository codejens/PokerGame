-- EffectConfig
-- create by hcl on 2013/3/1
-- 特效config


require '../data/action_effects/action'
require '../data/action_effects/effects'
require "../data/map_effect_config"

effect_config_iFile = 1
effect_config_iSpeed = 2
effect_config_iFrames = 3
effect_config_iOffsetX = 4
effect_config_iOffsetY = 5

bishaji_config = {
	-- 刀客剑雨特效,请保证spawn_point[1]是最后完成的。因为是根据这个timer是否完成来保证不会重复释放必杀技，以免timer没有释放（其实理论上用了必杀技，怒气值为0，连续放必杀技的可能性几乎为0）
	sword_rain = {
		effect_number = 12,
		delay_skill_request = 1.5,	-- 延迟向服务器请求释放必杀技的时间
		spawn_point = {
			-- 往左移动需要x变小，往上移动需要y变小
			[1] = {scale = 1.8, x = -160, y = -205, is_flip = false, delay_duation = 1.2},
			[2] = {scale = 1, x = -400, y = -500, is_flip = false, delay_duation = 0.3},
			[3] = {scale = 1, x = -400, y = -600, is_flip = false, delay_duation = 0.3},	
			[4] = {scale = 1, x = -500, y = -270, is_flip = false, delay_duation = 0.3},	

			[5] = {scale = 1, x = -600, y = -600, is_flip = false, delay_duation = 0.5},	
			[6] = {scale = 1, x = -900, y = -700, is_flip = false, delay_duation = 0.5},

			[7] = {scale = 1, x = 30, y = -600, is_flip = false, delay_duation = 0.7},	
			[8] = {scale = 1, x = -650, y = -700, is_flip = false, delay_duation = 0.7},
			[9] = {scale = 1, x = -600, y = -700, is_flip = false, delay_duation = 0.7},

			[10] = {scale = 1, x = -800, y = -200, is_flip = false, delay_duation = 0.7},
			[11] = {scale = 1, x = -100, y = -400, is_flip = false, delay_duation = 0.7},
			[12] = {scale = 1, x = -500, y = -350, is_flip = false, delay_duation = 0.7},
		},
		fall_offset = {
		    -- y值变大往上移，x值变大往左移
			[1] = {x = 200, y = -200, fall_duation = 0.1},    
			[2] = {x = 600, y = -500, fall_duation = 0.1},
			[3] = {x = 500, y = -400, fall_duation = 0.1},
			[4] = {x = 300, y = -300, fall_duation = 0.1},

			[5] = {x = 700, y = -700, fall_duation = 0.1},
			[6] = {x = 500, y = -500, fall_duation = 0.1},

			[7] = {x = 400, y = -400, fall_duation = 0.1},
			[8] = {x = 600, y = -600, fall_duation = 0.1},
			[9] = {x = 400, y = -450, fall_duation = 0.1},
			[10] = {x = 450, y = -400, fall_duation = 0.1},

			[11] = {x = 500, y = -600, fall_duation = 0.1},
			[12] = {x = 600, y = -600, fall_duation = 0.1},
		},
	},
	-- 贤儒剑阵特效
	sword_formation = {
		effect_number = 10,
		spawn_point = {
			-- 往左移动需要x变小，往上移动需要y变小
			-- 贤儒剑阵没有使用timer，使用callback做的，所以没有进行预防重复放必杀技
			[1] = {scale = 1.35, x = 360, y = -350, delay_duation = 0},
			[2] = {scale = 1.35, x = -180, y = -100, delay_duation = 0},
			[3] = {scale = 1.35, x = 360, y = 150, delay_duation = 0},
			[4] = {scale = 1.35, x = 0, y = -350, delay_duation = 0.3},
			[5] = {scale = 1.35, x = -540, y = -100, delay_duation = 0.4},
			[6] = {scale = 1.35, x = 0, y = 150, delay_duation = 0.5},
			[7] = {scale = 1.35, x = -360, y = -350, delay_duation = 0.6},
			[8] = {scale = 1.35, x = 540, y = -100, delay_duation = 0.6},
			[9] = {scale = 1.35, x = -360, y = 150, delay_duation = 0.6},
			[10] = {scale = 1.35, x = 180, y = -100, delay_duation = 0.3},	
		},
	},
	-- 枪士枪阵特效
	spear_formation = {
		effect_number = 10,
		spawn_point = {
			-- 往左移动需要x变小，往上移动需要y变小
			-- 枪阵没有使用timer，使用callback做的，所以没有进行预防重复放必杀技
			[1] = {scale = 1.2, x = 360, y = -450, delay_duation = 0},
			[2] = {scale = 1.2, x = -180, y = -200, delay_duation = 0},
			[3] = {scale = 1.2, x = 360, y = 50, delay_duation = 0},
			[4] = {scale = 1.2, x = 0, y = -450, delay_duation = 0.3},
			[5] = {scale = 1.2, x = -540, y = -200, delay_duation = 0.4},
			[6] = {scale = 1.2, x = 0, y = 50, delay_duation = 0.5},
			[7] = {scale = 1.2, x = -360, y = -450, delay_duation = 0.6},
			[8] = {scale = 1.2, x = 540, y = -200, delay_duation = 0.6},
			[9] = {scale = 1.2, x = -360, y = 50, delay_duation = 0.6},
			[10] = {scale = 1.2, x = 180, y = -200, delay_duation = 0.3},	
		},
	},
	-- 弓手旋风特效
	archer_wind = {
		effect_number = 7,
		spawn_point = {
			-- 弓手旋风没有使用timer，使用callback做的，所以没有进行预防重复放必杀技
			-- action_duation=2.5如果要变大，还要改代码ActionCombatPowerAttack.lua中的动画持续时间，不然2.5秒后光有设定好的动作，但是旋风动画已经消失了
			[1] = {scale = 0.9, x = 400, y = 300, delay_duation = 0.2,
				action_duation = 2.5,radian_base = 0, radian_speed = 1.6, ARC_factor = 80,
				move_offset_x = -300, move_offset_y = 400
			},
			[2] = {scale = 0.7, x = 400, y = 0, delay_duation = 0.1,
				action_duation = 2.5,radian_base = 0, radian_speed = -1.6, ARC_factor = 100,
				move_offset_x = -700, move_offset_y = 0
			},
			[3] = {scale = 0.8, x = 0, y = 400, delay_duation = 0.1,
				action_duation = 2.5,radian_base = 0, radian_speed = -2, ARC_factor = 100,
				move_offset_x = 0, move_offset_y = 200
			},
			[4] = {scale = 0.8, x = -500, y = 0, delay_duation = 0.1,
				action_duation = 2.5,radian_base = 4, radian_speed = 1.6, ARC_factor = 130,
				move_offset_x = 200, move_offset_y = -300
			},

			[5] = {scale = 0.7, x = -500, y = 200, delay_duation = 0.1,
				action_duation = 2.5,radian_base = 1, radian_speed = -2, ARC_factor = 100,
				move_offset_x = -200, move_offset_y = 100
			},

			[6] = {scale = 1, x = -400, y = -200, delay_duation = 0.1,
				action_duation = 2.5,radian_base = 0, radian_speed = -2, ARC_factor = 90,
				move_offset_x = 0, move_offset_y = -300
			},

			[7] = {scale = 0.9, x = 0, y = -300, delay_duation = 0.1,
				action_duation = 2.5,radian_base = -1.5, radian_speed = -2, ARC_factor = 100,

			},		
		},
	},
}

 function effect_config:get_map_effect_data_by_id( scene_id )
 	 return map_effect_config[scene_id]
 end

 function effect_config:index_to_foot_effect_id(index)
 	return 8000 + index
 end

 function effect_config:id_to_effect_file_id(id)
 	local temp_info = { [21300] = 101, [21301] = 102, [21302] = 103, 
 						[21303] = 201, [21304] = 202, [21305] = 203,}
 	return temp_info[id]
 end