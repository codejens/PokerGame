-- GameSysModel.lua
-- create by hcl on 2013-1-10
-- 判断是否开启系统

GameSysModel = {}

-- 功能定义
GameSysModel.MOUNT 			= 0				-- 坐骑
GameSysModel.GEM 			= 1 			-- 法宝(用作精灵系统吧)
GameSysModel.GUILD 			= 2 			-- 帮派 仙踪
GameSysModel.ENHANCED		= 3 			-- 炼器
GameSysModel.LOTTERY 		= 4 			-- 梦境
GameSysModel.MONEY_TREE 	= 5 			-- 拜神
GameSysModel.UNIQUE_SKILL 	= 6 			-- 必杀技
GameSysModel.PRACTICE 		= 7 			-- 打坐
GameSysModel.ROOTS	 		= 8 			-- 灵根
GameSysModel.DJ 			= 9  			-- 渡劫
GameSysModel.PET 			= 13 			-- 宠物
GameSysModel.FIGHTSYS		= 14 			-- 竞技场
GameSysModel.GENIUS			= 15 			-- 式神
GameSysModel.TRANSFORM 		= 16 			-- 变身

-- 前32个编号给非根据等级开放（即需要服务端记录）的系统
GameSysModel.MOUNT_REFRESH	= 32 			-- 坐骑洗炼
GameSysModel.FIGHT_POWER	= 33 			-- 战斗力介绍
GameSysModel.SUMMON			= 34 			-- 召唤萱儿
GameSysModel.WING 			= 35 			-- 翅膀系统
GameSysModel.JJC 			= 36 			-- 竞技场
GameSysModel.FIRST_RECHARGE	= 37 			-- 首充礼包
GameSysModel.GET_WING 		= 38			-- 领取翅膀
GameSysModel.NEW_SERVER		= 39 			-- 开服活动
GameSysModel.DDZ 			= 40 			-- 欢乐斗
GameSysModel.JJC_AWARD		= 41 			-- 竞技场排名奖励
GameSysModel.TZFL			= 42 			-- 投资返利
GameSysModel.MARRY			= 43 			-- 结婚系统
GameSysModel.DongFu			= 44			-- 种植
GameSysModel.QianDao 		= 45			-- 签到
GameSysModel.PAO_HUAN 		= 46			-- 跑环
GameSysModel.MYXT			= 47			-- 密友系统
GameSysModel.ZhanBu			= 48			-- 占卜
GameSysModel.DAILY_ACTIVITY = 49			-- 每日必玩
GameSysModel.EXCHANGE		= 50			-- 兑换
GameSysModel.RANKLIST		= 51 			-- 排行榜
GameSysModel.MEIRENHOURSE   = 52 			-- 美人后宫
GameSysModel.MIJI		    = 53			-- 秘籍系统
GameSysModel.MEIRENCHOUKA	= 54			-- 美人抽卡

local sys_state_num = nil;

local is_first = true;
-- 系统开启等级
local SYS_OPEN_LV = { 
	[GameSysModel.FIGHT_POWER] 		= {16,	"提升战斗力"},
	[GameSysModel.SUMMON] 			= {25,	"召唤萱儿"},
	[GameSysModel.JJC] 				= {30,	"斗法台"},
	[GameSysModel.FIRST_RECHARGE] 	= {5,	"首充礼包"},
	[GameSysModel.GET_WING] 		= {1,	"领取翅膀"},
	[GameSysModel.NEW_SERVER] 		= {12,	"开服活动"},
	[GameSysModel.DDZ] 				= {33,	"欢乐斗"},
	[GameSysModel.JJC_AWARD] 		= {25,	"竞技场排名"},
	[GameSysModel.TZFL] 			= {25,	"投资返利"},
	[GameSysModel.MARRY] 			= {41,	"仙侣情缘"},
	[GameSysModel.QianDao ] 		= {1,	"签到"},
	[GameSysModel.PAO_HUAN] 		= {32,	"跑环"},
	[GameSysModel.MOUNT_REFRESH] 	= {45,	"坐骑洗炼"},
	[GameSysModel.DAILY_ACTIVITY]	= {18,	"每日必玩"},
	[GameSysModel.EXCHANGE]			= {21,	"兑换"},
	[GameSysModel.RANKLIST]			= {20,  "排行榜"},
	[GameSysModel.MEIRENHOURSE]		= {50,  "美人后宫"},
	[GameSysModel.MEIRENCHOUKA]		= {50,  "美人抽卡"},
}

-- added by aXing on 2013-5-25
function GameSysModel:fini( ... )
	sys_state_num = nil;
	is_first = true;
end

-- 获取系统的描述
local function get_str_by_sysid( sys_id )
	if ( sys_id == GameSysModel.MOUNT ) then
		return 17,LangModelString[159],LangModelString[160]; -- [159]="坐骑" -- [160]="坐骑在完成17级主线任务后开启"
	elseif ( sys_id == GameSysModel.GEM or sys_id == GameSysModel.GENIUS ) then
		return 20,Lang.lingqi[12],Lang.lingqi[13];
	elseif ( sys_id == GameSysModel.GUILD ) then
		return 25,LangModelString[32]; -- [32]="仙宗"
	elseif ( sys_id == GameSysModel.ENHANCED ) then
		return 24,LangModelString[163],LangModelString[164]; -- [163]="炼器系统" -- [164]="炼器在完成24级主线任务后开启"
	elseif ( sys_id == GameSysModel.LOTTERY ) then
		return 26,LangModelString[165]; -- [165]="梦境"
	elseif ( sys_id == GameSysModel.MONEY_TREE ) then
		return 22,LangModelString[166],LangModelString[167]; -- [166]="招财" -- [167]="招财进宝在完成22级主线任务后开启"
	elseif ( sys_id == GameSysModel.UNIQUE_SKILL ) then
		return 15,LangModelString[168]; -- [168]="必杀技"
	elseif ( sys_id == GameSysModel.PRACTICE ) then
		return 15,LangModelString[169]; -- [169]="打坐"
	elseif ( sys_id == GameSysModel.ROOTS ) then
		return 31,Lang.lenggen.common[1],Lang.lenggen.common[2]; -- [170]="奇经八脉" -- [171]="奇经八脉系统暂未开启"
	elseif ( sys_id == GameSysModel.DJ ) then
		return 23,LangModelString[172],LangModelString[173]; -- [172]="渡劫" -- [173]="渡劫在完成23级主线任务后开启"
	elseif ( sys_id == GameSysModel.PET ) then
		return 7,Lang.gamesystem[2]; -- [174]="宠物"
	elseif ( sys_id == GameSysModel.FIGHTSYS ) then
		return 30,Lang.gamesystem[1]; -- [175]="斗法台"
	end
	return 0,"";
end


function GameSysModel:update_state( _sys_state_num )
	sys_state_num = _sys_state_num;
	if ( is_first == false) then
		is_first = true;
	end
	if ( GameSysModel:isSysEnabled(GameSysModel.PRACTICE, false) ) then
		local player = EntityManager:get_player_avatar();
		player.is_enable_dazuo = true;
	end
	-- print("开启新系统:sys_state = " .. _sys_state_num);
end


-- sys_id:系统id    is_show_dialog:系统未开启是否要弹提示框
function GameSysModel:isSysEnabled( sys_id, is_show_dialog )

	if is_show_dialog == nil then
		is_show_dialog 	= true
	end
	
	local user_lv 	= nil
	local level 	= nil
    local sys_str 	= nil
    -- 自定义提示字符串
    local zdj_str 	= nil
    --判断
    local player = EntityManager:get_player_avatar()

    if ( player ) then 
    	user_lv = player.level;
    end
    
    if ( sys_id >= 0 ) and ( sys_id < 32 ) and (sys_state_num ~= nil) then
       -- print("")
    	local result = ZXLuaUtils:isSysEnabled(sys_state_num, sys_id);	
    	-- print(" ZXLuaUtils:isSysEnabled(sys_state_num, sys_id,result)",sys_state_num,sys_id,result)

		if (result) then
			return true;
		else 
			if( is_show_dialog ) then 
				level,sys_str,zdj_str = get_str_by_sysid( sys_id );
			else
				return false;
			end
		end
    end

	--坐骑洗炼 45级开启
	if ( sys_id == GameSysModel.MOUNT_REFRESH ) then
		local mounts_info = MountsModel:get_mounts_info()
		if ( mounts_info ) then
			if ( mounts_info.level >= SYS_OPEN_LV[GameSysModel.MOUNT_REFRESH][1] ) then
				return true;
			else
				if (is_show_dialog) then
					NormalDialog:show(LangModelString[176]); -- [176]="#c66ff66需要坐骑等级45级后才能开启洗练"
				end
				return false;
			end
        else
		  	if (is_show_dialog) then
				NormalDialog:show(LangModelString[177]); -- [177]="#c66ff66坐骑系统在人物17级后开启"
			end
        	return false;
        end

	--战斗力 15级开启
	elseif ( sys_id == GameSysModel.FIGHT_POWER ) then
		if (user_lv >= 15) then
			return true;
		end
		level = 15;
		sys_str = LangModelString[178]; -- [178]="提升战斗力"

	--召唤萱儿25级开启
	elseif ( sys_id == GameSysModel.SUMMON ) then
		if (user_lv >= 25) then
			return true;
		end
		level = 25;
		sys_str = LangModelString[179]; -- [179]="召唤萱儿"

	--翅膀系统要翅膀等级大于0
	elseif ( sys_id == GameSysModel.WING ) then
		local data = WingModel:get_wing_item_data();
		if ( data ) then
			return true;
        else
		    if (is_show_dialog) then
				NormalDialog:show(Lang.gamesys[3]); -- [180]="#c66ff66未穿戴翅膀"
			end
        	return false;
        end
  		
  -- 		if (user_lv >= 11) then
		-- 	return true;
		-- end

        return false;

	--竞技场系统25级开启
	elseif ( sys_id == GameSysModel.JJC ) then
		if (user_lv >= 30) then
			return true;
		end
		level = 30;
		sys_str = Lang.doufatai[30]; -- [175]="斗法台"
	--首充礼包5级开放
	elseif ( sys_id == GameSysModel.FIRST_RECHARGE ) then
		if (user_lv >= 5) then
			return true;
		end
		level = 5;
		sys_str = LangModelString[181]; -- [181]="首充礼包"
	--领取翅膀3级开放
	elseif ( sys_id == GameSysModel.GET_WING ) then
		if (user_lv >= 1) then
			return true;
		end
		level = 1;
		sys_str = LangModelString[182]; -- [182]="领取翅膀"
	--开服活动12级开放（tjxs 1级）
	elseif ( sys_id == GameSysModel.NEW_SERVER ) then
		if (user_lv >= 1) then
			return true;
		end
		level = 1;
		sys_str = LangModelString[183]; -- [183]="开服活动"
	--欢乐斗33级开放
	elseif ( sys_id == GameSysModel.DDZ ) then
		if (user_lv >= 33) then
			return true;
		end
		level = 33;
		sys_str = LangModelString[184]; -- [184]="欢乐斗"
	--竞技场排名奖励25级开启
	elseif ( sys_id == GameSysModel.JJC_AWARD ) then
		if (user_lv >= 25) then
			return true;
		end
		level = 25;
		sys_str = LangModelString[185]; -- [185]="竞技场排名"
	elseif (sys_id == GameSysModel.TZFL) then
		if (user_lv >= 1 ) then
			return true
		end
		level = 1
		sys_str = LangModelString[186] -- [186]="投资返利"
	elseif (sys_id == GameSysModel.MYXT) then
		if (user_lv >= 30 ) then
			return true
		end
		level = 30
		sys_str = LangModelString[187] -- [187]="密友系统"
	elseif (sys_id == GameSysModel.MARRY) then

		if (user_lv >= 41 ) then
			return true
		end
		level = 41
		sys_str = LangModelString[188] -- [188]="仙侣情缘"

	elseif (sys_id == GameSysModel.DongFu) then
		local min_level = PlantConfig:get_show_min_level()
		if (user_lv >= min_level ) then
			return true
		end
		level = min_level
		sys_str = LangModelString[189] -- [189]="洞府"
	elseif (sys_id == GameSysModel.ZhanBu ) then
		local min_level = ZhanBuConfig:get_open_limit_level()
		if user_lv >= min_level then
			return true
		end
		level = min_level
		sys_str = LangModelString[190] -- [190]="占卜"
	elseif (sys_id == GameSysModel.MIJI ) then 
		if (user_lv >= 54 ) then
			return true
		end
		level = 54
		sys_str = Lang.Miji[1]	-- [1] = "秘籍"
	else
		-- print("SYS_OPEN_LV[sys_id][1]",sys_id,SYS_OPEN_LV[sys_id])
		if SYS_OPEN_LV[sys_id] then
			if user_lv >= SYS_OPEN_LV[sys_id][1] then
				return true;
			end
			level = SYS_OPEN_LV[sys_id][1];
			sys_str = SYS_OPEN_LV[sys_id][2];
		end
	end

	if (is_show_dialog) then
		if ( zdj_str ) then
			NormalDialog:show(zdj_str,nil,2);
		else
			NormalDialog:show(sys_str..LangModelString[192]..level..LangModelString[193],nil,2); -- [192]="在人物" -- [193]="级后开启"
		end
	end
	return false;
end

function GameSysModel:get_sys_lv( sys_id )
	return SYS_OPEN_LV[sys_id][1];
end