-- SetSystemModel.lua
-- created by lyl on 2013-3-15
-- 设置系统

-- super_class.SetSystemModel()
SetSystemModel = {}

-- ===========================================
-- 使用bool值控制的设置，用一个bit位来保存。存在一个int变量中(即一个int值可保存32个bool设置)
-- 有具体数值的值，用键值对来保存
-- 下面是定义各功能设置的  key值
-- ===========================================

--//设置的常量定义,与服务端保存的位一致
--// !!! 如果游戏在运营期，这里的index是不能乱改的，否则服务器数据读取顺序会错误
--// !!! NOTES: 默认值是0的，定义域为[ 0,31]
--// !!! NOTES: 默认值是1的，定义域为[32,63]

-- // 显示设置
-- /** 屏蔽其他玩家 **/
SetSystemModel.HIDE_OTHER_PLAYER		 = 0;
--/** 屏蔽怒气值收集效果 **/
SetSystemModel.HIDE_XP_COLLECT_EFFECT = 1;
--/** 隐藏自己所有的称号 **/
SetSystemModel.HIDE_MY_TITLE			 = 2;
--/** 始终显示怪物名字等级 **/
SetSystemModel.SHOW_MONSTER_NAME		 = 11;


-- // 声音设置
-- /** 全部静音 **/
SetSystemModel.MUSIC_TOGGLE			 = 3;

-- // 其他设置
-- /** 自动通过好友申请 **/
SetSystemModel.AUTO_ACCEPT_FRIEND	 = 4;
-- /** 拒绝他人加好友 **/
SetSystemModel.REJECT_ADDED_FRIEND	 = 5;
-- /** 拒绝他人向我切磋 **/
SetSystemModel.REJECT_CHALLENGED		 = 7;
-- /** 自动接受帮派邀请 **/
SetSystemModel.AUTO_ACCEPT_GUILD		 = 8;
-- /** 拒绝他人向我交易 **/
SetSystemModel.REJECT_BE_TRADED		 = 9;

-- // 其他不显示的设置
-- /** 是否接收双修 **/
SetSystemModel.ACCEPT_COUPLE_ZAZEN_INVITATION	= 10;

-- /** 屏蔽主屏信息弹出栏 **/
SetSystemModel.NOT_SHOW_MAIN_PANEL_INFOMATION   = 6;

-- // 挂机设置
-- /** 自动释放必杀技 **/
SetSystemModel.AUTO_SPELL_XP			 = 12;
-- /** 红药耗尽停止打怪 （生命补给或法力补给耗尽停止打怪） **/
SetSystemModel.STOP_AUTO_FIGHTING	 = 13;
-- /** 隐藏衣服时装 **/
SetSystemModel.HIDE_FASHION_DRESS	 = 14;
-- /** 自动使用复活石复活 （使用复活石原地复活） **/
SetSystemModel.AUTO_USE_STONE_RELIVE	 = 15;
-- /** 隐藏翅膀 **/
SetSystemModel.HIDE_WING				 = 16;
-- /** 隐藏武器时装 **/
SetSystemModel.HIDE_FASHION_WEAPON	 = 17;

-- /** 默认为0的设置项总数 **/
SetSystemModel.NEXT_CONFIG_0			 = 18;

-- 挂机设置 技能 第一个面板那
SetSystemModel.HOOK_SKILL_PANEL_1    = 19
-- 挂机设置 技能 第二个面板那
SetSystemModel.HOOK_SKILL_PANEL_2    = 20
-- 挂机设置 技能 第三个面板那
SetSystemModel.HOOK_SKILL_PANEL_3    = 21
-- 挂机设置 技能 第四个面板那
SetSystemModel.HOOK_SKILL_PANEL_4    = 22

--TODO 23可用

-- ***** 显示帧率 ******
SetSystemModel.show_fts                   = 24;
-- ***** 屏蔽同阵营玩家  *******             
SetSystemModel.HIDE_SAME_CAMP             = 25;

-- ***** 智能省电模式  *******             
SetSystemModel.POWER_SAVING               = 26;


-- // !!! NOTES: 默认值是1的，定义域为[32,63]
-- // 消费提示
-- /** 坐骑消费提醒 **/
SetSystemModel.COST_MOUNT			 = 32;
SetSystemModel.COST_MOUNT_XILIAN     = 42
-- /** 道具不足使用元宝复活 **/
SetSystemModel.COST_RELIVE			 = 33;
-- /** 材料不足使用元宝升级法宝 **/
SetSystemModel.COST_UPGRADE_GEM		 = 34;
-- /** 交易消费提示 **/
SetSystemModel.COST_TRADE			 = 35;
-- /** 任务刷星级提示 **/
SetSystemModel.COST_QUEST_REFRESH_STAR= 36;
-- /** 摇钱树消费提示（ 招财进宝提醒功能） **/
SetSystemModel.COST_MONEY_TREE		 = 37;
-- /** 任务是否立即完成 **/
SetSystemModel.COST_QUEST_QUICK_FINISH= 38;
-- /** 元宝猎魂提示（消费元宝召唤阴阳提示） **/
SetSystemModel.COST_GEM_VIP_HUNT		 = 39;
-- /** 元宝添加日常副本次数 **/
SetSystemModel.COST_ADD_FUBEN_COUNT	 = 40;
-- /** 任务刷星一键满星提示 **/
SetSystemModel.COST_QUEST_FULL_STAR	 = 48;
-- /** 竞技场清除cd时间提示 **/
SetSystemModel.COST_JJC_CLEAR_CD		 = 49;
-- /** 竞技场添加挑战次数提示 **/
SetSystemModel.COST_JJC_ADD_CHALLENGE = 50;
-- /** 斗地主添加抓捕次数提示 **/
SetSystemModel.COST_DDZ_ADD_ARREST	 = 51;
-- /** 斗地主压榨苦工 **/
SetSystemModel.COST_DDZ_OPPRESS		 = 52;
-- /** 斗地主榨干苦工 **/
SetSystemModel.COST_DDZ_SMOKE_DRY	 = 53;
-- /** 限制同屏显示玩家数量 **/
SetSystemModel.LIMIT_DISPLAY_PLAYER	 = 54;
-- /** 用解环石解环提示 **/
SetSystemModel.RUNRING_UNLOCK_PLAYER	 = 55;
-- /** 用元宝解环提示 **/
SetSystemModel.RUNRING_YUNBAO_PLAYER	 = 56;
-- /** 解环充值提示 **/
SetSystemModel.RUNRING_RECHARGE_PLAYER= 57;
-- /** 装备强化使用保护符提示 **/
SetSystemModel.COST_EQUIP_STRENGHEN	 = 58;


-- // 其他设置
-- /** 自动接受别人组队 **/
SetSystemModel.AUTO_JOINED_TEAM		 = 41;
		
-- // 挂机设置
-- /** 自动拾取白色装备 **/
SetSystemModel.AUTO_PICK        = 43;


-- 使用复活石
-- //		/** 自动使用复活石复活 **/
-- //		static public const AUTO_USE_STONE_RELIVE	  = 42;
-- /** 自动拾取白色装备 **/
-- SetSystemModel.AUTO_PICK_WHITE		 = 43;
-- -- /** 自动拾取绿色装备 **/
-- SetSystemModel.AUTO_PICK_GREEN		 = 44;
-- -- /** 自动拾取蓝色装备 **/
-- SetSystemModel.AUTO_PICK_BLUE		 = 45;
-- -- /** 自动拾取紫色装备 **/
-- SetSystemModel.AUTO_PICK_PURPLE		 = 46;
-- /** 自动释放技能 **/
-- //		static public const AUTO_SPELL_SKILL		 = 47;

-- /** 默认为1的设置项总数 **/
-- SetSystemModel.NEXT_CONFIG_1			 = 59;
		
-- /** 设置项总数，用于循环 目前是2个32位uint **/
-- SetSystemModel.MAX_CONFIG			 = 64;
		
-- SetSystemModel.FABAO_SWALLOW_XIANHUN = 65;

-- *******************  64 ~ 95 *********************
-- *****  显示天气特效 *******
SetSystemModel.show_weather_effect        = 64;

-- ***** 显示场景动画  *******
SetSystemModel.show_scene_animation       = 65;

-- ***** 显示景特效  *******             
SetSystemModel.show_scene_effect          = 66;


-- ***** 网络延时检测 ******
SetSystemModel.net_delay_check            = 67;
-- ***** 副本优化设置  *******
SetSystemModel.FUBEN_OPTIMIZE              = 68;


-- // 以下是添加一下额外的设置宏定义
-- // ！！！先定义需要存入服务器的key的定义域
-- /** 需要存入服务器的key的定义域下限 **/
local SAVE_TO_SERVER_MIN	 = 998;
-- /** 需要存入服务器的key的定义域上限 **/
local SAVE_TO_SERVER_MAX 	 = 1010;
		
-- /** 第一个32位标志位系统设置 **/
local BITS_OPTION_1			 = 999;
-- /** 第二个32位标志位系统设置 **/
local BITS_OPTION_2			 = 998;
-- /** 第三个32位标志位系统设置 **/
local BITS_OPTION_3			 = 997;   -- 暂时用不到
-- /** 当前背景音乐声量 **/
SetSystemModel.MUSIC_VOLUME			 = 1000;
-- /** 当前动作音效声量 **/
SetSystemModel.EFFECT_VOLUME			 = 1001;
-- /** 生命低于设置值时自动使用药品 **/
SetSystemModel.ASSIST_HP_ITEM		 = 1002;
-- /** 内力低于设置值时自动使用药品 **/
SetSystemModel.ASSIST_MP_ITEM		 = 1003;
-- /** 挂机设置-循环使用技能1 **/
SetSystemModel.HOOK_CYCLE_SKILL1		 = 1004;
-- /** 挂机设置-循环使用技能2 **/
SetSystemModel.HOOK_CYCLE_SKILL2		 = 1005;
-- /** 挂机设置-循环使用技能3 **/
SetSystemModel.HOOK_CYCLE_SKILL3		 = 1006;
-- /** 挂机设置-循环使用技能4 **/
SetSystemModel.HOOK_CYCLE_SKILL4		 = 1007;
-- /** 挂机设置-循环使用技能5 **/
SetSystemModel.HOOK_CYCLE_SKILL5		 = 1008;
-- /** 宠物生命低于设置值时自动使用药品 **/
SetSystemModel.ASSIST_HP_ITEM_PET	 = 1009;
-- /** 宠物快乐度低于设置值时自动使用药品 **/
SetSystemModel.ASSIST_FUNNY_ITEM_PET	 = 1010;

-- 序列号到技能key的映射
SetSystemModel.skill_panel_index_to_key_t = {     -- skill key
    SetSystemModel.HOOK_CYCLE_SKILL1, 
    SetSystemModel.HOOK_CYCLE_SKILL2,
    SetSystemModel.HOOK_CYCLE_SKILL3,
    SetSystemModel.HOOK_CYCLE_SKILL4,
 }

 -- 技能key到对应是否开启的映射
 SetSystemModel.skill_key_to_switch_bool = {
    [SetSystemModel.HOOK_CYCLE_SKILL1] = SetSystemModel.HOOK_SKILL_PANEL_1,
    [SetSystemModel.HOOK_CYCLE_SKILL2] = SetSystemModel.HOOK_SKILL_PANEL_2,
    [SetSystemModel.HOOK_CYCLE_SKILL3] = SetSystemModel.HOOK_SKILL_PANEL_3,
    [SetSystemModel.HOOK_CYCLE_SKILL4] = SetSystemModel.HOOK_SKILL_PANEL_4,
}

-- /** 主界面的快捷药品id **/
SetSystemModel.MAIN_YP              =1011;

-- =======================================
-- 数据
-- =======================================
local _set_date    = {}              -- 所有设置数据
local _set_bool_date = {}            -- 布尔值的table  option_key 为 0 到 63 时.  注意：是从0开始的！

local _min_avatar_per_screen = 20
local _max_avatar_per_screen = 100
-- 初始化所有数据
local function init_all_date(  )
	-- 第一组 32个bool数据
	for i = 0, 31 do
        _set_bool_date[i] = false
    end
    -- 第二组 32个bool数据
	for i = 32, 63 do
        _set_bool_date[i] = true
    end
    -- 第三组 32个bool数据
    for i = 64, 95 do
        _set_bool_date[i] = true
    end

    -- 数值设置初始化
    _set_date[ SetSystemModel.MUSIC_VOLUME ]          = 25
    _set_date[ SetSystemModel.EFFECT_VOLUME ]         = 25
    _set_date[ SetSystemModel.ASSIST_HP_ITEM ]        = 60
    _set_date[ SetSystemModel.ASSIST_MP_ITEM ]        = 50
    _set_date[ SetSystemModel.HOOK_CYCLE_SKILL1 ]     = 0
    _set_date[ SetSystemModel.HOOK_CYCLE_SKILL2 ]     = 0
    _set_date[ SetSystemModel.HOOK_CYCLE_SKILL3 ]     = 0
    _set_date[ SetSystemModel.HOOK_CYCLE_SKILL4 ]     = 0
    _set_date[ SetSystemModel.HOOK_CYCLE_SKILL5 ]     = 0
    _set_date[ SetSystemModel.ASSIST_HP_ITEM_PET ]    = 60
    _set_date[ SetSystemModel.ASSIST_FUNNY_ITEM_PET ] = 50
end
init_all_date(  )   -- 第一次require就初始化数据

-- added by aXing on 2013-5-25
function SetSystemModel:fini( ... )
    init_all_date()
end

-- 根据数值，返回bool值。 0 表示false, 其他表示true
local function get_bool_by_bit_value( bit_value )
	if bit_value == 0 then
        return false
    else
    	return true
	end
end

-- 设置服务器发来的数据
function SetSystemModel:set_all_date( set_date )
    -- print("设置服务器发来的数据SetSystemModel set_all_date")
    for key, value in pairs(set_date) do
        -- print("设置服务器发来的数据,,,,,,   ", key, value)
        _set_date[ key ] = value
    end

	-- 设置 999 项的bool值
	local date_999 = _set_date[ BITS_OPTION_1 ] or 0
	for i = 0, 31 do
		local bit_value = Utils:get_bit_by_position( date_999, i + 1 )
		local bool_value = get_bool_by_bit_value( bit_value )
        _set_bool_date[ i ] = bool_value
	end
	-- 设置 998 项的bool值
	local date_998 = _set_date[ BITS_OPTION_2 ] or (2^32 - 1)
	for i = 0, 31 do
		local bit_value = Utils:get_bit_by_position( date_998, i + 1 )
		local bool_value = get_bool_by_bit_value( bit_value )
        _set_bool_date[ i + 32 ] = bool_value           -- 998 是从第32开始
	end 
    -- 设置 997 项的bool值
    local date_997 = _set_date[ BITS_OPTION_3 ] or (2^32 - 1)
    for i = 0, 31 do
        local bit_value = Utils:get_bit_by_position( date_997, i + 1 )
        local bool_value = get_bool_by_bit_value( bit_value )
        _set_bool_date[ i + 64 ] = bool_value           -- 997 是从第64开始
    end 

    -- SetSystemModel:init_skill_switch_by_date(  )        -- 技能开关特殊控制

    -- 更新设置界面
    SetSystemWin:update_win( "set_date" )
  
    SetSystemModel:init_config_to_system(  )
end

-- 技能设置，默认要勾选，但对应技能没有的时候，要设置为不勾选
-- function SetSystemModel:init_skill_switch_by_date(  )
--     for key, skill_key in pairs( SetSystemModel.skill_panel_index_to_key_t ) do 
--         local skill_id_temp = SetSystemModel:get_date_value_by_key( skill_key )
--         if skill_id_temp == nil or skill_id_temp == 0 then 
--             local switch_key = SetSystemModel.skill_key_to_switch_bool[ skill_key ]
--             SetSystemModel:set_one_date( switch_key, false )
--         end
--     end
-- end

-- 初始化设置到具体场合
function SetSystemModel:init_config_to_system(  )
    -- 应用设置到具体场景
    -- SetSystemModel:set_hide_other_player(  )
    SetSystemModel:set_all_player_show(  )
    SetSystemModel:set_hide_title(  )                   -- 影藏玩家自己的称号
    SetSystemModel:set_bg_music_volume(  )
    SetSystemModel:set_effect_volume(  )
    SetSystemModel:set_scene_max_player(  )
    SetSystemModel:set_show_net_delay(  )
    SetSystemModel:set_show_fts(  )
    SetSystemModel:set_not_show_main_panel_info(  )     -- 屏蔽主屏幕公告
    SetSystemModel:set_powersaving(  )     -- 屏蔽主屏幕公告


    -- 初始化能使用的技能
    UserSkillModel:init_can_use_skill()

    -- 初始化主界面药品
    local win = UIManager:find_visible_window("menus_panel");
    if ( win ) then
        local item_id = SetSystemModel:get_date_value_by_key( SetSystemModel.MAIN_YP )
        if ( item_id ) then
            local user_item = ItemModel:get_item_info_by_id( item_id )
            if ( user_item ) then
                win:add_supply( user_item )
            end
        end
    end

    SetSystemModel:set_show_weather_effect(  )
    SetSystemModel:set_show_scene_animation(  )
    SetSystemModel:set_show_scene_effect(  )
    -- 玩家更新标题
    local player_avatar = EntityManager:get_player_avatar();
    if ( player_avatar )then
        player_avatar:is_pk_scene()
    end
end

-- 设置某一项的数据  并保存
function SetSystemModel:set_one_date( option_key, option_value )
    --print(" 设置某一项的数据 SetSystemModel:set_one_date", option_key, option_value)
	if option_key > -1 and option_key < 32 then         -- 小于32的设置key，存储在  key 为 999 的元素中, 为bool值
        _set_bool_date[ option_key ] = option_value
    elseif option_key > 31 and option_key < 63 then
    	_set_bool_date[ option_key ] = option_value
    elseif option_key > 63 and option_key < 96 then
        _set_bool_date[ option_key ] = option_value
    else
        _set_date[ option_key ] = option_value
	end

	-- 设置完，保存到服务器
	SetSystemModel:save_date_to_server(  )

    -- 应用到具体界面
    SetSystemModel:set_show_by_key_and_value( option_key, option_value )
end

-- 获取_set_date数据  根据_set_date的key(见上面定义的常量)来获取直接数据
function SetSystemModel:get_date_value_by_key( option_key )
	if option_key > -1 and option_key < 32 then
        return (_set_bool_date[ option_key] == nil) and false or _set_bool_date[ option_key]             -- 前32 ，默认为0 false
    elseif option_key > 31 and option_key < 64 then
        return (_set_bool_date[ option_key] == nil) and true or _set_bool_date[ option_key]            -- 32~63，默认为1 true
    elseif option_key > 63 and option_key < 96 then
        return (_set_bool_date[ option_key] == nil) and true or _set_bool_date[ option_key]            -- 32~63，默认为1 true
    else
        return (_set_date[ option_key ] == nil) and 0 or _set_date[ option_key ]
    end
end

-- 把bool值的数据转成int型数字， 参数：bool集合 的key
function SetSystemModel:bool_date_to_int( option_key )
	local int_value = 0
	local start_index = 0                                  -- 遍历的起始位置
	local end_index = 31                                   -- 遍历的结束位置
	if option_key == BITS_OPTION_1 then                    -- 第一个32位
        start_index = 0
        end_index = 31
    elseif option_key == BITS_OPTION_2 then                -- 第二个32位
        start_index = 32
        end_index = 63
    elseif option_key == BITS_OPTION_3 then                -- 第三个32位
        start_index = 64
        end_index = 95
	end
	for i = start_index, end_index do
        if _set_bool_date[i] then                      -- true用1代替
            int_value = int_value + 2 ^ (i - start_index)
        end
    end
    return int_value
end

-- 保存数据到服务器
function SetSystemModel:save_date_to_server(  )
    -- init_all_date(  )
	local date_999 = SetSystemModel:bool_date_to_int( BITS_OPTION_1 )
	local date_998 = SetSystemModel:bool_date_to_int( BITS_OPTION_2 )
    local date_997 = SetSystemModel:bool_date_to_int( BITS_OPTION_3 )

    _set_date[ BITS_OPTION_1 ] = date_999
    _set_date[ BITS_OPTION_2 ] = date_998
    _set_date[ BITS_OPTION_3 ] = date_997

    require "control/SetSystemCC"
    local count = 0
    for key, value in pairs(_set_date) do
        count = count + 1
    end
    
    SetSystemCC:request_save_set_date( count, _set_date )
end

-- 请求设置数据
function SetSystemModel:request_set_date(  )
    require "control/SetSystemCC"
	SetSystemCC:request_set_date(  )
end

-- 获取已经学习的主动技能的id
function SetSystemModel:get_active_skill_had_learn(  )
    local skill_id_t = {}
    local skill_dates = UserSkillModel:get_active_skill_had_learn_date(  )
    for i = 1, #skill_dates do
        table.insert( skill_id_t, skill_dates[i].id )
    end
    return skill_id_t
end

-- 判断一个技能id是否已经设置, 如果没有设置，返回一个空的技能设置key
function SetSystemModel:check_skill_id_had_set( skill_id )
    local if_had_set = false   -- 是否已经设置
    local option_key = nil
    -- by yongrui.liang 14.6.13
    local had_set_op_key = nil  -- 已经设置的key（不知用option_key会不会影响其它的地方，所以新增一个）
    -- 遍历，判断技能在几个设置中是否已经存在
    for i = 1, #SetSystemModel.skill_panel_index_to_key_t do
        local set_skill_id = SetSystemModel:get_date_value_by_key( SetSystemModel.skill_panel_index_to_key_t[i] )
        if set_skill_id == skill_id then
            if_had_set = true
            had_set_op_key = SetSystemModel.skill_panel_index_to_key_t[i]
            break
        end
    end
    -- 找出 “空位” 的 key
    if not if_had_set then
        for j = 1, #SetSystemModel.skill_panel_index_to_key_t do
            local set_skill_id = SetSystemModel:get_date_value_by_key( SetSystemModel.skill_panel_index_to_key_t[j] )
            if set_skill_id == 0 or set_skill_id == nil then
                option_key = SetSystemModel.skill_panel_index_to_key_t[j]
                break
            end
        end
    end
    return if_had_set, option_key, had_set_op_key
end

-- ==================================================
-- 使设置生效
-- ==================================================
-- 屏蔽其他玩家
function SetSystemModel:set_hide_other_player(  )
    local if_hide = SetSystemModel:get_date_value_by_key( SetSystemModel.HIDE_OTHER_PLAYER )
    if if_hide then
        EntityManager:hide_all_player_and_pet(  )
    else
        EntityManager:show_all_player_and_pet(  )
    end
end

-- 玩家显示控制
function SetSystemModel:set_all_player_show(  )
    EntityManager:set_hide_all_player(  )
end

-- 显示怪物名称
function SetSystemModel:set_show_monster_name(  )
    local if_show = SetSystemModel:get_date_value_by_key( SetSystemModel.SHOW_MONSTER_NAME )
    EntityManager:show_monster_name( if_show )
end

-- 是否显示自己头上的称号
function SetSystemModel:set_hide_title(  )
    local if_hide = SetSystemModel:get_date_value_by_key( SetSystemModel.HIDE_MY_TITLE )
    local player = EntityManager:get_player_avatar()
    player:set_if_show_title( not if_hide )
end

-- 设置屏蔽  屏蔽主屏信息弹出栏 
function SetSystemModel:set_not_show_main_panel_info(  )
    local if_hide_chat_panel = SetSystemModel:get_date_value_by_key( SetSystemModel.NOT_SHOW_MAIN_PANEL_INFOMATION )
    local visible = not if_hide_chat_panel
    MenusPanel:set_chat_panel_visible( visible )
end

-- 设置 显示天气系统
function SetSystemModel:set_show_weather_effect(option,forceUpdate)
    local if_show = SetSystemModel:get_date_value_by_key( SetSystemModel.show_weather_effect )
    SceneEffectManager : enableWeather( if_show ,forceUpdate)
end

-- 设置 显示场景动画
function SetSystemModel:set_show_scene_animation(option,forceUpdate)
    local if_show = SetSystemModel:get_date_value_by_key( SetSystemModel.show_scene_animation ) 
    SceneEffectManager : enableEffectAnimation( if_show, forceUpdate )
end

-- 设置 显示场景特效
function SetSystemModel:set_show_scene_effect(option,forceUpdate)
    local if_show = SetSystemModel:get_date_value_by_key( SetSystemModel.show_scene_effect ) 
    SceneEffectManager : enableParticles( if_show, forceUpdate )
end


-- 设置背景音乐音量大小
function SetSystemModel:set_bg_music_volume(  )
    local music_volumn = SetSystemModel:get_date_value_by_key( SetSystemModel.MUSIC_VOLUME )
    SoundManager:setBackgroundMusicVolume( music_volumn / 100 )
end

-- 设置音效音量大小
function SetSystemModel:set_effect_volume(  )
    local effect_volume = SetSystemModel:get_date_value_by_key( SetSystemModel.EFFECT_VOLUME )
    SoundManager:setEffectsVolume( effect_volume / 100 )
end

-- 设置 同屏人数上限
function SetSystemModel:set_scene_max_player(  )
    -- print("SetSystemModel:set_scene_max_player")
    local if_limit_player = SetSystemModel:get_date_value_by_key( SetSystemModel.LIMIT_DISPLAY_PLAYER )
    if if_limit_player then
        MiscCC:req_limit_display_player( _min_avatar_per_screen )
    else
        MiscCC:req_limit_display_player( _max_avatar_per_screen )
    end
end

-- 设置技能id
function SetSystemModel:set_hook_cycle_skill( option_key )
    local index = option_key - SetSystemModel.HOOK_CYCLE_SKILL1 + 1;
    local value = SetSystemModel:get_date_value_by_key( option_key );
     -- print("SetSystemModel:set_hook_cycle_skill( option_key ) ",option_key,value,"index = ",index);
    if ( index > 0 and index < 5 and value ) then 
        UserSkillModel:set_can_use_skill( index , value );
    end

    SetSystemWin:update_win( "set_skill_id" )
end

-- 设置技能是否使用
function SetSystemModel:set_hook_cycle_is_open( option_key ) 
    local index = option_key - SetSystemModel.HOOK_SKILL_PANEL_1 + 1;
    local value = SetSystemModel:get_date_value_by_key( option_key );
    -- print("SetSystemModel:set_hook_cycle_is_open( option_key ) ",option_key,value,"index = ",index);
    if ( index > 0 and index < 5 ) then
        UserSkillModel:set_can_use_skill_enable( index , value );
    end
end

-- 网络延时
function SetSystemModel:set_show_net_delay(  )
    local if_show = SetSystemModel:get_date_value_by_key( SetSystemModel.net_delay_check )
    if if_show then
        WholeModel:begin_check_daley(  )
    else
        WholeModel:stop_net_delay_check(  )
    end
end

-- 游戏帧率显示
function SetSystemModel:set_show_fts(  )
    local if_show = SetSystemModel:get_date_value_by_key( SetSystemModel.show_fts )
    if if_show then 
        CCDirector:sharedDirector():setDisplayFPS( true )
    else 
        CCDirector:sharedDirector():setDisplayFPS( false )
    end
end

--开启智能省电
function SetSystemModel:set_powersaving(  )
    local if_show = SetSystemModel:get_date_value_by_key( SetSystemModel.POWER_SAVING )
    if if_show then 
        PowerCenter:set_enable(true)
    else 
        PowerCenter:set_enable(false)
    end
end

--副本优化
function SetSystemModel:set_fuben_optimize(  )
    -- 如果当前场景是需要优化的副本,则需要屏蔽掉 
    -- 翅膀，角色脚底光环，宠物脚底光环，法宝，玩家称号，宝宝称号，攻击数值，
    local player = EntityManager:get_player_avatar();
    if player then
        EntityManager:set_fuben_optimize( SetSystemModel:is_fuben_optimize() ) 
    end
end

function SetSystemModel:is_fuben_optimize()
    if SetSystemModel:get_date_value_by_key( SetSystemModel.FUBEN_OPTIMIZE ) and SceneManager:get_is_pk_scene() then
        return true;
    end
    return false;
end

-- 根据key和数值设置到具体显示
local _option_key_to_func_t = {
    [SetSystemModel.HIDE_OTHER_PLAYER]       = SetSystemModel.set_all_player_show,      -- 屏蔽其他玩家
    [SetSystemModel.HIDE_SAME_CAMP]          = SetSystemModel.set_all_player_show,      -- 同阵营显示控制
    [SetSystemModel.SHOW_MONSTER_NAME]       = SetSystemModel.set_show_monster_name,    -- 是否显示怪物名
    [SetSystemModel.HIDE_MY_TITLE]           = SetSystemModel.set_hide_title,           -- 隐藏称号
    [SetSystemModel.show_weather_effect]     = SetSystemModel.set_show_weather_effect,  -- 显示天气系统
    [SetSystemModel.show_scene_animation]    = SetSystemModel.set_show_scene_animation, -- 显示场景动画
    [SetSystemModel.show_scene_effect]       = SetSystemModel.set_show_scene_effect,    -- 显示场景特效
    [SetSystemModel.net_delay_check]         = SetSystemModel.set_show_net_delay,       -- 显示网络延时
    [SetSystemModel.show_fts]                = SetSystemModel.set_show_fts,             -- 显示帧率
    [SetSystemModel.MUSIC_VOLUME]            = SetSystemModel.set_bg_music_volume,      -- 音乐音量大小
    [SetSystemModel.EFFECT_VOLUME]           = SetSystemModel.set_effect_volume,        -- 音效音量
    [SetSystemModel.LIMIT_DISPLAY_PLAYER]    = SetSystemModel.set_scene_max_player,     -- 音效音量
    [SetSystemModel.HOOK_CYCLE_SKILL1]       = SetSystemModel.set_hook_cycle_skill,     -- 设置技能
    [SetSystemModel.HOOK_CYCLE_SKILL2]       = SetSystemModel.set_hook_cycle_skill,
    [SetSystemModel.HOOK_CYCLE_SKILL3]       = SetSystemModel.set_hook_cycle_skill,
    [SetSystemModel.HOOK_CYCLE_SKILL4]       = SetSystemModel.set_hook_cycle_skill,
    [SetSystemModel.HOOK_SKILL_PANEL_1]        = SetSystemModel.set_hook_cycle_is_open,   -- 设置技能开关
    [SetSystemModel.HOOK_SKILL_PANEL_2]        = SetSystemModel.set_hook_cycle_is_open,
    [SetSystemModel.HOOK_SKILL_PANEL_3]        = SetSystemModel.set_hook_cycle_is_open,
    [SetSystemModel.HOOK_SKILL_PANEL_4]        = SetSystemModel.set_hook_cycle_is_open,
    [SetSystemModel.NOT_SHOW_MAIN_PANEL_INFOMATION] = SetSystemModel.set_not_show_main_panel_info, -- 主屏公告
    [SetSystemModel.POWER_SAVING]                   = SetSystemModel.set_powersaving, -- 主屏公告
    [SetSystemModel.FUBEN_OPTIMIZE]          = SetSystemModel.set_fuben_optimize,            --副本优化

}
function SetSystemModel:set_show_by_key_and_value( option_key, option_value )
    -- print("SetSystemModel:set_show_by_key_and_value", option_key, option_value, _option_key_to_func_t[option_key] )
    if _option_key_to_func_t[option_key] then
        _option_key_to_func_t[option_key]( SetSystemModel,option_key )      -- 
    end
end

-- 判断某一个选项是否打开，如果打开就显示提示框
function SetSystemModel:get_date_value_by_key_and_tip( key ,cb_fun,str )
    local flag = SetSystemModel:get_date_value_by_key( key )
    print("SetSystemModel:get_date_value_by_key_and_tip( key ,cb_fun,str,flag)",key,cb_fun,str,flag)
    -- 如果为true就弹提示框
    if ( flag ) then
        local function fun( is_show_next )
            SetSystemModel:set_one_date( key, not is_show_next);
        end 
        ConfirmWin2:show( 5, nil, str,  cb_fun, fun )
    else
        cb_fun();
    end
end