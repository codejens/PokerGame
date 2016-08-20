-- UserSkillModel.lua
-- created by lyl on 2012-12-3
-- 角色技能管理器
-- 主要处理游戏内角色技能相关的操作，如设置并存储角色技能列表、获取技能

-- super_class.UserSkillModel()
UserSkillModel = {}

-- add by chj @2014.9.16 
--增加tab也的需求 -------------------
-- tab页标志
UserSkillModel.JI_NENG = 1  --技能
UserSkillModel.MI_JI = 2
UserSkillModel.XIN_FA = 3

local _current_page = UserSkillModel.JI_NENG

----------------------------------

-- require "control/UserSkillCC"

-- 私有变量
local _a_key_to_upgrade_flag = false      -- 标记当前是否是一键升级状态

-- 技能列表。每个元素为一个UserSkill结构
local _self_skill_list = {}

-- 去掉过滤技能剩下的技能
local _self_can_use_skill_lsit = {};

local _if_had_set_skill = false          -- 是否已经设置技能。


local _learn_skills = {}

local super_skill_t = SkillConfig:get_super_skill()


-- ====================================
-- 特效 
-- ====================================
-- start_pos
local skill_start_t = {
        {100, 399  },
        {270, 399  },
        {270, 270.3},
        {100, 270.3},
    }
-- end_pos
local skill_pos_t = {
        {180, 28},
        {270, 28},
        {360, 28},
        {450, 28},
    }

-- 特效遮挡框
local effect_bg = {}
-- 特效的回调
local effect= {}
local cb_t = {}

--技能使用timer
--[[
local _use_skill_timer = timer()

local _use_skill_list = {}

local _use_skill_common_cd = 0

local _max_common_cd = 0

local _lan_min = 0.0        --最小延迟
local _lan_max = 0.5        --最大延迟补偿

local _math_min = math.min
local _math_max = math.max
function _math_clamp(_min, _max, _value)
    return _math_min(_math_max(_min,_value),_max)
end

--每帧检查是否可以向服务器请求使用技能
local function _tickUseSkill(dt)
    --使用技能队列
    if #_use_skill_list > 0 then
        --技能公共CD
        if _use_skill_common_cd <= 0 then
            local skillObject = table.remove(_use_skill_list, 1)
            if skillObject then
                UserSkillCC:request_use_skill(skillObject[1], skillObject[2], skillObject[3], skillObject[4], skillObject[5])
                --公共CD MAX - 网络延时
                --local _lantency = WholeModel:get_net_delay() / 1000.0
                --local _net_dely = _math_clamp(_lan_min,_lan_max,_lantency)
                _use_skill_common_cd = 1.0 --- _net_dely
                --print('[delay use skill] _tickUseSkill', _net_dely, _lantency)
                return
            end
        end
    end
    --更新公共CD
    _use_skill_common_cd = _use_skill_common_cd - dt
end
]]--

-- 公有方法
-- added by aXIng on 2013-5-25
function UserSkillModel:fini( ... )
    -- print("UserSkillModel:fini.......................")
    _a_key_to_upgrade_flag = false
    _self_skill_list = {}
    _self_can_use_skill_lsit = {};
    _if_had_set_skill = false
    _learn_skills = {}

    
    --_use_skill_timer:stop()

    UIManager:destroy_window( "user_skill_win" )
end


-- 设置技能列表
function UserSkillModel:set_skill_list( skill_list )
    -- print(">>>>>>skills: ", #skill_list)
    --[[
    for k,v in pairs(skill_list) do
        for kk,vv in pairs(v) do
            print(kk,vv)
        end
    end
    --]]--
    --_use_skill_timer:stop()
    --_use_skill_timer:start(0,_tickUseSkill)
    --_use_skill_list = {}

    _self_skill_list = skill_list;
    UserSkillModel:init_simple_attack(  )
    _if_had_set_skill = true
    UserSkillModel:show_skill_minibut(  )
    
    -- 当玩家在新手体验副本中的时候,所谓的技能都是假的,所以不用同步到设置系统
    local curSceneId = SceneManager:get_cur_scene()
    if curSceneId == 27 then
		_self_can_use_skill_lsit = {}
        for i=1, #_self_skill_list do
            _self_can_use_skill_lsit[i] = _self_skill_list[i]
        end
        _self_can_use_skill_lsit[0] = _self_skill_list[0]
    else
        -- 修复历史bug：系统设置不能正常保存，总是会被还原为默认设置 note by guozhinan
        -- UserSkillModel:syn_skill_list_to_setsystem()
    end
end


-- 获取技能列表
function UserSkillModel:get_skill_list()
    return _self_skill_list;
end

-- 根据技能id，获取技能
function UserSkillModel:get_a_skill_by_id( skill_id )
    -- if super_skill_t[skill_id] then
    --     return _self_skill_list[5]
    -- end
    --遍历_role_equi_info
    for i = 0, #_self_skill_list do
        if _self_skill_list[i] and _self_skill_list[i].id == skill_id then
            -- print(">>>>>>>> get a skill: ", skill_id)
            return _self_skill_list[i];
        end
    end
    return nil;
end

-- 改变指定技能的属性
function UserSkillModel:change_skill_attr( skill_id, attr_name, value )
   
    local a_skill = self:get_a_skill_by_id( skill_id);
    if a_skill then
        a_skill[attr_name] = value
        require "UI/userSkillWin/UserSkillWin"
        UserSkillWin:update_skill_win()
    else
        -- print("has no the skill!")
    end
end

-- 变身技能
function UserSkillModel:handle_super_skill( super_id )

    --是否正在变身状态
    if super_id ~= 0 then
        local skill_id = TransformConfig:get_ninja_skill_by_id(super_id)
        local skill = UserSkillModel:create_a_skill_by_id_level( skill_id, 1 )
        _self_skill_list[ #_self_skill_list+1 ] = skill
        -- UserSkillModel:syn_super_skill_to_setsystem( skill_id )
        -- _learn_skills[skill_id] = true

        local win = UIManager:find_visible_window("menus_panel")
        if win then
            win:check_is_exist(skill_id, 5)
            KeySettingCC:req_set_a_key( 5, 0, 1 );

            local pos_x,pos_y,btn_index = win:get_skill_idle_btn_pos( skill_id );
            -- if btn_index then
                local img_path = SkillConfig:get_skill_icon( skill_id )
                win:set_btn_skill_by_index(5, skill_id)
                KeySettingCC:req_set_a_key( 5, skill_id, 1 ); 
                --xiehande 添加变身技能特效
                if ((not win:get_is_show())) then
                win:play_tran_effect(pos_x+3,pos_y+3);
                end
            -- end
        end
    else
        -- _self_skill_list[ 5 ] = nil
        -- UserSkillModel:syn_super_skill_to_setsystem( nil )
        local win = UIManager:find_visible_window("menus_panel")
        if win then
            win:check_is_exist(skill_id, 5)
            KeySettingCC:req_set_a_key( 5, 0, 1 );
        end 
        
    end
    
end

-- 新学习（增加）或者升级 一个技能成功
function UserSkillModel:study_or_upgrade_skill_success( skill_id, new_level )
    local skill = UserSkillModel:get_a_skill_by_id( skill_id )
    if skill then         
        UserSkillModel:change_skill_attr(skill_id, "level", new_level)
    else
        local skill = UserSkillModel:create_a_skill_by_id_level( skill_id, new_level )
        _self_skill_list[ #_self_skill_list + 1 ] = skill
        -- 通知技能更新.  如果已经学习，就是走 修改属性流程，那里会更新窗口数据
        require "UI/userSkillWin/UserSkillWin"
        -- UserSkillModel:syn_skill_list_to_setsystem(  )
        -- 不是被动技能才放到技能设置里
        if not SkillConfig:isPassiveSkillById( skill_id ) then
            UserSkillModel:syn_new_skill_to_setsystem( skill_id )
        end

        -- modify by hcl on 2013/11/22 暂时屏蔽掉飘技能的动画
        -- -- 除了普通攻击和前
        -- 除了普通攻击以外 技能1，2，3，4可以在界面点击
        skill_index = #_self_skill_list
        if SkillConfig.isSkillCanbeClick(skill_id) then
            -- 播放飘技能到技能栏的动画
            -- print('>>>>>skill_index>>>>>>skill_id>>>>', skill_index, skill_id)
            _learn_skills[skill_id] = true
            -- local jineng_win = UIManager:find_visible_window("small_jineng_win")
          
            -- if jineng_win then 
            --      --create by jiangjinhong 通过弹出框学习的技能（每个职业的第2,3,4个技能）
            --     --需要技能学习特效和飘道具特效
            --     local menus_win = UIManager:find_visible_window("menus_panel")
            --     if menus_win then
            --         local pos_x,pos_y,btn_index = menus_win:get_skill_idle_btn_pos( skill_id );
            --         local function cb_fun()
            --             ZXLog("local function cb_fun()")
            --             menus_win:set_btn_skill_by_index(btn_index,skill_id)
            --             KeySettingCC:req_set_a_key( btn_index,skill_id,1 );
            --             UIManager:destroy_window("small_jineng_win")
            --             local task_table,num = TaskModel:get_yijie_tasks_list();
            --             local temp_result = AIManager:do_quest( task_table[1] ,1,true);
            --             if temp_result == false then
            --                 Analyze:parse_click_main_menu_info(135)
            --             end

            --         end 
            --         UIManager:hide_window( "small_jineng_win" )
            --         Instruction:play_new_jineng_effect( skill_id, pos_x, pos_y, cb_fun)
            --         menus_win:show_or_hide_panel( false )
            --     end 
            -- else 
            
            local win = UIManager:find_visible_window("menus_panel")
            if win then
                local pos_x,pos_y,btn_index = win:get_skill_idle_btn_pos( skill_id );
                if btn_index then
                    -- print("====skill_index: ", btn_index)
                    local img_path = SkillConfig:get_skill_icon( skill_id )
                    win:set_btn_skill_by_index(btn_index,skill_id)
                    KeySettingCC:req_set_a_key( btn_index,skill_id,1 ); 
                end
            end 

            -- 播放技能飘的特效
            local user_win = UIManager:find_visible_window("user_skill_win")
            if user_win then
                local ks_num = 1
                local keySet_table = KeyModel:get_key_table()
                for i=1, 4 do
                    if not keySet_table[i] then
                        ks_num = i
                        break
                    end
                end
                -- Instruction:play_new_jineng_effect( skill_id, pos_x, pos_y, cb_fun)
                effect_bg[skill_id] =  ZBasePanel:create(user_win, UILH_NORMAL.skill_bg1, skill_pos_t[ks_num][1]-5, skill_pos_t[ks_num][2]-5, -1, -1 )
                local function cb_fun()
                    effect_bg[skill_id].view:removeFromParentAndCleanup(true)
                    effect_bg[skill_id] = nil
                end 

                local texture = SkillConfig:get_skill_icon( skill_id )  
                -- 返回特效和回调
                effect[skill_id], cb_t[skill_id] = LuaEffectManager:play_jineng_effect( user_win, skill_start_t[ks_num][1]+120*0.5, skill_start_t[ks_num][2]+120*0.5,
                                        skill_pos_t[ks_num][1]+80*0.5, skill_pos_t[ks_num][2]+80*0.5, texture, 99999, cb_fun)
            end


                UserSkillWin:update_skill_win()
                -- local function cb_fun()
                --     MenusPanel:set_btn_skill_by_index(btn_index,skill_id)
                --     KeySettingCC:req_set_a_key( btn_index,skill_id,1 );
                -- end
                -- LuaEffectManager:play_fly_animation( img_path ,400,240,pos_x,pos_y,cb_fun)
            -- end
        else
            local win = UIManager:find_visible_window("menus_panel")
            if win then
                local pos_x,pos_y,btn_index = win:get_skill_idle_btn_pos( skill_id );
                if btn_index then
                    -- print("====skill_index: ", btn_index)
                    local img_path = SkillConfig:get_skill_icon( skill_id )
                    win:set_btn_skill_by_index(btn_index,skill_id)
                    KeySettingCC:req_set_a_key( btn_index,skill_id,1 ); 
                end
            end 
            UserSkillWin:update_skill_win()
        end 
    end

    -- 如果正在一键升级状态，就继续调用一件升级按钮
    if _a_key_to_upgrade_flag then
        -- print("继续一键升级")
        UserSkillModel:do_a_key_to_upgrade()
    end

end

-- 使用id 和等级创建一个技能数据结构
function UserSkillModel:create_a_skill_by_id_level( skill_id, level )
    -- 如果没有学过就创建新的
    require "struct/UserSkill"
    local skill = UserSkill()
    skill.id         = skill_id
    skill.level      = level
    skill.secret_id  = 0
    skill.exp        = 0
    skill.dead_time  = 0
    skill.ifStop     = 0
    skill.cd        = 0                 -- 技能的当前CD或者经验 
    local static_info = SkillConfig:get_skill_by_id( skill.id )
    local cooldownTime = static_info.skillSubLevel[ skill.level ].cooldownTime;
    if ( cooldownTime ) then
        skill.max_cd  = cooldownTime/1000
    else  
        skill.max_cd = 0;
    end
    
    require "config/SkillConfig"
    local skill_base = SkillConfig:get_skill_by_id( skill_id ) 
    skill.cd         = skill_base and skill_base.commonCd or 0
    return skill
end

-- 判断一个技能是否可以学习 或者 升级
function UserSkillModel:check_skill_if_can_upgrade( skill_id )
    local can_not_up_type = ""          -- 不可升级的原因. "level"  "money"  "exp"  "skill_top"
    require "entity/EntityManager"
    local player = EntityManager:get_player_avatar() 

    -- 判断是否顶级
    if UserSkillModel:get_skill_if_top( skill_id ) then
        return false, "skill_top"
    end

    -- 判断等级
    local skill_min_level = UserSkillModel:get_up_con_by_skill_id( skill_id, "level" )   -- 技能需要的人物最低等级
    -- print("判断等级:::", player.level, skill_min_level, skill_id)
    if player.level >= skill_min_level then     -- 如果任务等级大于技能需要的最低等级
        -- 判断经验
        local exp_need = UserSkillModel:get_up_con_by_skill_id( skill_id, "exp" )
        -- print("判断经验:::", player.expH *(2^32) + player.expL, exp_need)
        if ( player.expH *(2^32) + player.expL ) >= exp_need then
            -- 判断金钱
            local money_need = UserSkillModel:get_up_con_by_skill_id( skill_id, "money" )
            -- print("判断金钱:::", player.yinliang, money_need)
            if player.yinliang >= money_need then
                return true, ""
            else
                can_not_up_type = "money"
            end
        else
            can_not_up_type = "exp"
        end
    else
        can_not_up_type = "level"
    end
    return false, can_not_up_type
end

-- 显示新技能提示
function UserSkillModel:show_skill_minibut(  )
    local function mini_but_func(  )
        UIManager:show_window( "user_skill_win" )
    end 

    -- 第一次创建人物，改变属性的时候，也会调用这个方法。 这时还没有job属性，所以要先判断
    local player = EntityManager:get_player_avatar()
    if player.job == nil or player.expL == nil or player.expH == nil or 
        player.level == nil or player.yinliang == nil or player.level < 8 then
        return
    end

    if _if_had_set_skill and UserSkillModel:check_if_had_new_skill() then      -- 如果有新技能可以学习，就显示提示
        MiniBtnWin:show( 6 , mini_but_func ,nil )
    end
end

-- 检测是否有新技能可以学习
function UserSkillModel:check_if_had_new_skill(  )
    local user_skill_t = UserSkillModel:get_player_skills( )
    for i = 1, #user_skill_t do
        local skill_player = UserSkillModel:get_a_skill_by_id( user_skill_t[i].id )
        if skill_player == nil then
            local if_can_check, can_not_type = UserSkillModel:check_skill_if_can_upgrade( user_skill_t[i].id )
            -- print("检测是否有新技能可以学习::::", if_can_check, can_not_type, user_skill_t[i].id )
            if if_can_check then
                return true
            end
        end
    end
    return false
end


-- 根据技能id，判断是否到达顶级
function UserSkillModel:get_skill_if_top( skill_id )
    local skill_player = UserSkillModel:get_a_skill_by_id( skill_id )
    if skill_player == nil then
        return false
    end
    require "config/SkillConfig"

    local skill_base = SkillConfig:get_skill_by_id( skill_id )
    -- print(" ~~~   !!!   ~~~ ", tostring( skill_base) )
    -- print(" ~~~   !!!   ~~~ ", tostring( skill_base.skillSubLevel[skill_player.level + 1]) )
    -- print(" ~~~   !!!   ~~~ ", tostring( skill_base.skillSubLevel[skill_player.level + 1].trainConds) )
    if skill_base == nil or skill_base.skillSubLevel[skill_player.level + 1] == nil 
        or skill_base.skillSubLevel[skill_player.level + 1].trainConds == nil  then
        return true
    end
    return false
end

-- 根据技能id， 获取技能升级(当获取不到动态技能信息时， 就是 学习 ) 需要的经验 ,等级等信息 ( 根据 con_type 参数)
-- con_type :  level  money  exp 
function UserSkillModel:get_up_con_by_skill_id( skill_id, con_type )
    local con_type_value = 1
    if con_type == "level" or con_type == 1 then
        con_type_value = 1
    elseif con_type == "money" or con_type == 2 then
        con_type_value = 2
    elseif con_type == "exp" or con_type == 4 then
        con_type_value = 4
    else
        return 0
    end

    local con_need = 0
    local skill_level = 1      -- 技能等级. 后面如果没有获取到技能，说明没有学习，获取1级的条件

    local skill_player = UserSkillModel:get_a_skill_by_id( skill_id )
    if skill_player ~= nil then
        -- print( "  UserSkillModel:get_up_con_by_skill_id   skill_level = skill_player.level + 1   skill_player.level   ", tostring(skill_player.level)  )
        skill_level = skill_player.level + 1
    end

    require "config/SkillConfig"
    local skill_base = SkillConfig:get_skill_by_id( skill_id )
    if skill_base == nil or skill_base.skillSubLevel[skill_level] == nil 
        or skill_base.skillSubLevel[skill_level].trainConds == nil  then
        -- print(" 错误！！！ 找不到这个技能的升级条件信息!!!    skill_id" .. tostring(skill_id))
        return 0                 -- 找不到技能
    end
    for i, trainCond in ipairs( skill_base.skillSubLevel[skill_level].trainConds ) do
        if trainCond.cond == con_type_value then
            con_need = trainCond.value
        end
    end
    return con_need
end

-- 根据技能id，获取技能的某个属性
function UserSkillModel:get_skill_attr_by_id( skill_id, attr_name )
    require "config/SkillConfig"
    local skill_base = SkillConfig:get_skill_by_id( skill_id )
    local skill_player = UserSkillModel:get_a_skill_by_id( skill_id )
    if skill_base == nil then
        return 0
    end

    local skill_level = 1      -- 技能等级. 后面如果没有获取到技能，说明没有学习，获取1级的条件
    if skill_player ~= nil then
        skill_level = skill_player.level
    end

    local ret = ""
    if attr_name == "desc" then
        if skill_base.skillSubLevel and skill_base.skillSubLevel[skill_level] and skill_base.skillSubLevel[skill_level].desc then
            ret =  skill_base.skillSubLevel[skill_level].desc
        else
            -- print("!!! 注意 ！！！  ".. skill_base.name .. "获取技能描述有问题！！！！！！！！")
        end
    end
    
    return ret
end

-- 获取角色的职业技能表
function UserSkillModel:get_player_skills( )
    local player = EntityManager:get_player_avatar()
    local skill_t = SkillConfig:get_skills_by_job( player.job )
    return skill_t
end

--  获取玩家主动技能列表      排除第1 第 5个技能
function UserSkillModel:get_active_skill(  )
    local ret_skills_t = {}
    local player_skills = UserSkillModel:get_player_skills()
    local _isPassiveSkill = SkillConfig.isPassiveSkill
    for i = 1, #player_skills do
        local _skill = player_skills[i]
        if not _isPassiveSkill(_skill.skillType) then
            table.insert( ret_skills_t, _skill )
        end
    end
    return ret_skills_t
end

-- 获取玩家已经学习了的主动技能 基础数据    排除第2 第 5个技能
function UserSkillModel:get_active_skill_had_learn(  )
    local skill_t = UserSkillModel:get_active_skill()
    local ret_skills_t = {}
    for i = 1, #skill_t do
        local skill = UserSkillModel:get_a_skill_by_id( skill_t[i].id )
        if skill then
            table.insert( ret_skills_t, skill_t[i] )
        end
    end
    return ret_skills_t
end

-- 获取玩家已经学习的主动技能，动态数据    排除第2 第 5个技能
function UserSkillModel:get_active_skill_had_learn_date(  )
    local skill_t = UserSkillModel:get_active_skill()
    local ret_skills_t = {}
    for i = 1, #skill_t do
        local skill = UserSkillModel:get_a_skill_by_id( skill_t[i].id )
        if skill then
            table.insert( ret_skills_t, skill )
        end
    end
    return ret_skills_t
end

-- 发送消息
-- 学习 / 升级 一个技能
function UserSkillModel:study_or_upgrade_a_skill( skill_id )
    UserSkillCC:request_upgrade_skill( skill_id, nil )
end

-- 一键升级功能  升级使用银两最少的技能。知道没有银两 . 
function UserSkillModel:do_a_key_to_upgrade(  )
    _a_key_to_upgrade_flag = true
    -- 获取职业对应的技能
    require "entity/EntityManager"
    local player = EntityManager:get_player_avatar()
    local skill_t = SkillConfig:get_skills_by_job( player.job )
    
    -- 检查技能是否可以升级。
    local min_need_money = 9999999999999 -- 记录花费最少银两
    local min_need_skill_id = nil        -- 记录花费最少银两的技能id.  同时可以用来判断是否有技能可以升级
    local money_temp = 0                 -- 临时存储银两
    for i = 1, 6 do
        if UserSkillModel:check_skill_if_can_upgrade( skill_t[i].id )  then
            money_temp = UserSkillModel:get_up_con_by_skill_id( skill_t[i].id, "money" )
            -- print(skill_t[i].id , "消耗的金钱  ", money_temp)
            if min_need_money > money_temp then
                min_need_money = money_temp
                min_need_skill_id = skill_t[i].id
            end
            -- print("=====do_a_key_to_upgrade  1=====")
        end
    end
    if min_need_skill_id then
        -- print("=====do_a_key_to_upgrade  2=====")
        -- print(" 计算出最小金钱  ", min_need_skill_id, min_need_money, SkillConfig:get_skill_by_id(min_need_skill_id).name )
        UserSkillModel:study_or_upgrade_a_skill( min_need_skill_id )
    else
        _a_key_to_upgrade_flag = false     -- 如果没有可升级的技能，就停止一键升级状态
        -- print("=====do_a_key_to_upgrade  3=====")
    end
end

-- 显示技能tips
function UserSkillModel:show_skill_tips( skill_id )
    local skill_player = UserSkillModel:get_a_skill_by_id( skill_id )
    local skill_param  = skill_player
    local function skill_callback()
        UserSkillModel:study_or_upgrade_a_skill( skill_id )
    end
    require "model/TipsModel"
    if skill_player == nil then
        skill_param = { id = skill_id, level = 0 }
        if UserSkillModel:check_skill_if_can_upgrade( skill_id ) then
            TipsModel:show_user_skill_tip(  195, 285, skill_param, skill_callback, Lang.skill_info.learn )
        else
            -- todo
            TipsModel:show_user_skill_tip(  195, 285, skill_param, nil, "" )
        end
    else
        if UserSkillModel:check_skill_if_can_upgrade( skill_id ) then
            TipsModel:show_user_skill_tip(  195, 285, skill_param, skill_callback, Lang.skill_info.level_up )
        else
            -- todo
            TipsModel:show_user_skill_tip(  195, 285, skill_param, nil, "" )
        end
    end
end

-- 

-- 私有方法
function UserSkillModel:update_skill_cd( dt )
    for i=0,#_self_skill_list do
        if ( _self_skill_list[i].cd > 0 ) then
            _self_skill_list[i].cd = math.max( _self_skill_list[i].cd - dt,0);
        end
    end
end

-- 使用技能后设置技能cd
function UserSkillModel:set_skill_cd( skill_id )

    local skill = UserSkillModel:get_a_skill_by_id( skill_id );
    skill.cd = skill.max_cd;
    -- 通知主界面播放技能cd动画
    local win = UIManager:find_visible_window( "menus_panel" );
    if ( win ) then
        win:play_skill_cd_animation( skill.id ,skill.max_cd ,99)
    end
end
-- 技能冷却完成
function UserSkillModel:set_skill_cd_zero( skill_id ,is_need_clear)
    -- print("UserSkillModel:set_skill_cd_zero( skill_id ,is_need_clear)")
    for i=0,#_self_skill_list do
        if ( _self_skill_list[i].id == skill_id ) then
            _self_skill_list[i].cd = 0;
            -- 如果是中途强制cd置0就需要清除cd动画
            if ( is_need_clear ) then
                local win = UIManager:find_visible_window( "menus_panel" );
                if ( win ) then
                    win:clear_skill_cd( skill_id  );
                end
            end
            return;
        end
    end
end

-- 技能CD发生变化
function UserSkillModel:set_skill_cd_time( skill_id,time )
    for i=0,#_self_skill_list do
        if ( _self_skill_list[i].id == skill_id ) then
            _self_skill_list[i].cd = time/1000;--_self_skill_list[i].max_cd-time/1000;
            -- 如果是中途强制cd置0就需要清除cd动画
            if ( time and time > 0 ) then
                local win = UIManager:find_visible_window( "menus_panel" );
                if ( win ) then
                    win:set_skill_cd( skill_id ,time );
                end
            end
            return;
        end
    end
end

-- 初始化普通攻击
function UserSkillModel:init_simple_attack( )
    local player = EntityManager:get_player_avatar()
    local simple_attack_id = player.simple_attack_id;
    local simple_attack_speed = player.attackSpeed

    local skillInfo = SkillConfig:get_skill_by_id(simple_attack_id)
    local simple_level = 1
    local skill_entity  = skillInfo.skillSubLevel[simple_level]  

    -- print('>>>>>普通攻击攻速初始化了',simple_attack_speed / 1000)
    --print('init_simple_attack >>>>>>>>>>>>>>>>>>', skill_entity.cooldownTime)
    _self_skill_list[0] = { id = simple_attack_id, level = simple_level, cd = 0, max_cd = simple_attack_speed / 1000  };
    -- 必杀技
    _self_skill_list[-1] = { id = EntityManager:get_player_avatar().bsj_id, level = 1, cd = 0, max_cd = 0  };

    _max_common_cd = simple_attack_speed / 1000.0
end

function UserSkillModel:set_simple_attack_with_attackSpeed(_cd)
    --if _self_skill_list[0] then
        -- print('>>>>>普通攻击攻速改变了',_cd)
    --    _self_skill_list[0].max_cd = _cd
    --end
    local player = EntityManager:get_player_avatar()
    local simple_attack_speed = player.attackSpeed
    _max_common_cd = simple_attack_speed / 1000.0
end
-- 玩家第一次登录游戏时做的操作，首先在快捷栏放入玩家的第一个技能，然后设置快捷键
function UserSkillModel:do_first_enter_game()
    -- local player = EntityManager:get_player_avatar();
    -- local first_skill_id = 0;
    
    -- -- "天雷", "蜀山", "圆月", "云华"
    -- if ( player.job == 1 ) then
    --     first_skill_id = 1;
    -- elseif ( player.job == 2 ) then
    --     first_skill_id = 9;
    -- elseif ( player.job == 3 ) then
    --     first_skill_id = 17;
    -- elseif ( player.job == 4 ) then
    --     first_skill_id = 25;
    -- end
    -- KeySettingCC:req_set_a_key( 1,first_skill_id,1 )
    -- local win = UIManager:find_visible_window("menus_panel");
    -- win:set_btn_skill_by_index( 1 ,first_skill_id);
end

-- 玩家登录时取得系统设置里面的技能过滤表
function UserSkillModel:init_can_use_skill()
    -- 玩家在新手体验副本(假副本)中时,不从设置系统中,读取可用技能(挂机状态下使用)
    local curSceneId = SceneManager:get_cur_scene()
    if curSceneId == 27 then
        -- 设置普通攻击到可用技能列表
        _self_can_use_skill_lsit[0] = _self_skill_list[0]
        return
    end
    for i=0,4 do
        local is_close_skill = SetSystemModel:get_date_value_by_key( SetSystemModel.HOOK_SKILL_PANEL_1 + i );
      --  print("is_close_skill = ",is_close_skill)
        if ( is_close_skill )then
            _self_can_use_skill_lsit[1 +i] = nil; 
        else 
            local is_use_skill_id = SetSystemModel:get_date_value_by_key( SetSystemModel.HOOK_CYCLE_SKILL1 + i );
            local skill_struct = UserSkillModel:get_a_skill_by_id( is_use_skill_id )
            _self_can_use_skill_lsit[1 +i] = skill_struct;
            
        end
    end
    -- 保存第一个技能和普通攻击
    _self_can_use_skill_lsit[0] = _self_skill_list[0];
end

-- 技能改变时更新can_use_skill_list
function UserSkillModel:set_can_use_skill( index,skill_id )
     local skill_struct = UserSkillModel:get_a_skill_by_id( skill_id );
    _self_can_use_skill_lsit[ index] = skill_struct;
end

-- 技能开关时更新can_use_skill_list
function UserSkillModel:set_can_use_skill_enable(index ,is_close_skill )
    if ( is_close_skill ) then
        _self_can_use_skill_lsit[ index] = nil;
    else
        local is_use_skill_id = SetSystemModel:get_date_value_by_key( SetSystemModel.HOOK_CYCLE_SKILL1 + index - 1 );
        local skill_struct = UserSkillModel:get_a_skill_by_id( is_use_skill_id )
        _self_can_use_skill_lsit[ index] = skill_struct;
    end
end

-- 取得玩家能使用的技能列表
function UserSkillModel:get_can_use_skill_list()
    --[[
    for k,v in pairs(_self_can_use_skill_lsit) do
        print(k,v.name)
    end
    ]]--
    return _self_can_use_skill_lsit;
end

-- 同步技能列表到设置系统
function UserSkillModel:syn_skill_list_to_setsystem(  )
    local active_skill_list = UserSkillModel:get_active_skill_had_learn(  )
    for i = 1, #active_skill_list do
        local if_had_set, option_key = SetSystemModel:check_skill_id_had_set( active_skill_list[i].id )
        -- print("./////============", if_had_set, option_key, active_skill_list[i].id )
        if not if_had_set and option_key then
            SetSystemModel:set_one_date( option_key, active_skill_list[i].id )
        end
    end
end

-- 同步变身技能到设置系统
function UserSkillModel:syn_super_skill_to_setsystem( skill_id )
    if skill_id then
        for k,v in pairs(super_skill_t) do
            local if_had_set, option_key, had_set_op_key = SetSystemModel:check_skill_id_had_set( k )
            if if_had_set then
                if k ~= skill_id then
                    -- print("=========615")
                    SetSystemModel:set_one_date( had_set_op_key, skill_id )
                    return
                else
                    return
                end
            end
        end
        local if_had_set, option_key = SetSystemModel:check_skill_id_had_set( skill_id )
        -- print("=========624: ", if_had_set, option_key)
        if not if_had_set and option_key then
            SetSystemModel:set_one_date( option_key, skill_id )
        end
    else
        for k,v in pairs(super_skill_t) do
            local if_had_set, option_key, had_set_op_key = SetSystemModel:check_skill_id_had_set( k )
            if if_had_set and option_key then
                -- print("=========630")
                SetSystemModel:set_one_date( option_key, nil )
                return
            end
        end
    end
end

-- 新增一个技能，同步到设置系统
function UserSkillModel:syn_new_skill_to_setsystem( skill_id )
    -- 辅助技能id
    local assist_skill_t = { [5] = true, [6] = true, [15] = true, [16] = true, [23] = true, [24] = true, [31] = true, [32] = true }
    local if_had_set, option_key = SetSystemModel:check_skill_id_had_set( skill_id )
    if not if_had_set and option_key then
        SetSystemModel:set_one_date( option_key, skill_id )
        -- 第一次设置的时候，辅助技能默认设置为不启用
        local skill_switch_key = SetSystemModel.skill_key_to_switch_bool[ option_key ]
        if assist_skill_t[ skill_id ] then        
            SetSystemModel:set_one_date( skill_switch_key, true )
        else
            SetSystemModel:set_one_date( skill_switch_key, false )
        end
    end
end

function UserSkillModel:get_skill_infos( skill_base, level )
    -- body
    local id = skill_base.id
    local cd = skill_base.skillSubLevel[level]        -- 技能每个等级的配置
    local dst  = SkillConfig:get_spell_distance(id,level)
    return dst, cd
end

function UserSkillModel:init_skill_key()
    --先设置默认
    ---[[
    for i = 1, #_self_skill_list do
        local skill = _self_skill_list[i]
        local skill_id = skill.id
        -- if SkillConfig.isSkillCanbeClick(skill_id) then
        if not SkillConfig:isPassiveSkillById(skill_id) then
            local win = UIManager:find_visible_window("menus_panel")
            if win then
                local pos_x,pos_y,btn_index = win:get_skill_idle_btn_pos( skill_id );
                if btn_index then
                    local img_path = SkillConfig:get_skill_icon( skill_id )
                    -- win:set_btn_skill_by_index(btn_index,skill_id)
                    -- KeySettingCC:req_set_a_key( btn_index,skill_id,1 ); 
                end
            end 
        end
    end
    -- ]]--
    local curSceneId = SceneManager:get_cur_scene()
    -- if curSceneId == 27 then
    --     NewerCampServerCC:req_get_key_from_dummy()
    -- else
        KeySettingCC:req_get_key_setting()
    -- end
end

--技能使用封装
function UserSkillModel:use_skill_request( id, target_handle, target_x, target_y, forward )
    
    UserSkillCC:request_use_skill(id, target_handle, target_x, target_y, forward)
end

function UserSkillModel:add_target_effect(skill_id, target_handle)
    -- 根据技能id读取配置文件
    local effect = NewerCampConfig:get_effect_by_skill_id(skill_id)
    if effect then
        local pack = NetManager:get_socket():alloc(0, 19)
        local handle = EntityManager:get_player_avatar_handle()
        pack:writeInt64(handle)
        pack:writeInt64(target_handle)
        -- effect_type
        pack:writeByte(effect.type)
        -- effect_id
        pack:writeWord(effect.id)
        -- time
        pack:writeInt(effect.keepTime)
        -- send to client
        NetManager.SendToClient(pack)
    end
end

-- 客户端模拟服务器进行技能伤害计算
function UserSkillModel:use_skill_request_to_dummy_server( skill_id, target_handle )
    local entity = EntityManager:get_entity(target_handle)
    local dummy  = NewerCampModel:GetDummyControlObj()
    local process= NewerCampModel:get_curr_progress()
    -- 怪物掉血、添加主角释放技能的特效
    if entity and dummy then
        dummy:processMonsterDamage(entity, 0, skill_id, process)
        -- UserSkillModel:add_target_effect(skill_id, target_handle)
    end
end

function UserSkillModel:clear_can_use_skill_list()
    _self_can_use_skill_lsit = {}
end

-- add by chj @2014.9.16 
--增加tab也的需求
function UserSkillModel:set_current_page( page )
    _current_page = page
end

function UserSkillModel:get_current_page( )
    return _current_page
end

-- 底部4个技能位置
function UserSkillModel:get_skill_pos_t( )
    return skill_pos_t
end

-- 底部4个技能框的挡住框
function UserSkillModel:get_effect_bg( )
    return effect_bg
end

function UserSkillModel:clear_effect_bg( )
    for k,v in pairs(effect_bg) do
        if v then
            v.view:removeFromParentAndCleanup(true)
            v = nil
        end
    end
end

function UserSkillModel:get_effect_and_callball( )
    return effect, cb_t
end

function UserSkillModel:clear_effect_and_callback( )
    -- if effect then
    --     effect:removeFromParentAndCleanup(true)
    --     effect = nil
    -- end

    if cb_t then
        for cb_k, cb_v in pairs(cb_t) do
            if cb_v then
                for k, v  in pairs(cb_v) do
                    if v then
                        v:cancel()
                        v = nil
                    end
                end
            end
        end
    end
end