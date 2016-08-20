-- GuildModel.lua
-- created by lyl on 2012-12-27
-- 仙宗管理器
-- 主要处理仙宗信息相关的操作，

-- super_class.GuildModel()
GuildModel = {}

-- 私有变量
local _user_guild_info = nil    -- 角色的帮派信息 UserGuildInfo 结构
local _lave_times 
local _btn_status
local _fuben_diff 
local _person_times
local _guild_times
local _guild_info = {}          -- 仙宗列表.  一页一页地存储， 页号作为索引
-- local _guild_count = 0          -- 当前获取仙宗个
local _guild_page_curr = 1      -- 当前是第几页. 从 1 作为起始数字。  数以填1，作为第一次申请的页数
local _guild_page_total = 0     -- 总页数
local _rows_count_per_page = 6  -- 每页显示的行数

local _apply_guild_id_t = {}    -- 保存玩家申请的仙宗， 申请过一次，当次登录不可以再申请。
local _enter_goto_page_num = 0  -- 跳转输入框的数字

local _memb_infos = {}          -- 仙宗成员信息
local _memb_online_num = 0      -- 在线成员数量，根据这个来判断一个成员是否在线
local _memb_no_online_num = 0   -- 不 在线成员数量，根据这个来判断一个成员是否在线
local _memb_page_curr = 1       -- 成员页  当前页

local _apply_infos = {}         -- 申请加入仙宗玩家信息
local _apply_page_curr = 1      -- 申请加入仙宗  当前页

local _guild_tianyuan_range  = 0   -- 仙宗天元之战排名
local _guild_tianyuan_score  = {}  -- 仙宗天元之战得分
local _guild_tianyuan_list   = {}  -- 仙宗天元之战列表
local _tianyuan_curr_page    = 1   -- 天元之战排行当前页

local _init_altar_page = false
local _init_altar_page_info = false
local _guild_altar_event_info_max_num = 48
local _guild_altar_page_type = 0
local _guild_altar_egg_page_info = GuildAltarEggPageInfo() -----仙宗神兽蛋页信息
local _guild_altar_page_info = GuildAltarPageInfo()         -----仙宗神兽页信息
local _guild_altar_xian_guo_cur_find_num = 0
local _is_return_init = true
local _guild_alter_update_list = {}

local _action_infos                 = {}   -- 仙宗动态信息（列表）
local _action_tianyuan_infos        = {}   -- 仙宗动态-天元之战信息（列表）
local _personal_tianyuan_info       = {}   -- 本人的天元之战排名信息
local _action_all_curr_page         = 1    -- 全部仙宗动态信息   当前页
local _action_storage_curr_page     = 1    -- 仙踪仓库信息   当前页
local _action_tianyuan_curr_page    = 1    -- 天元之战信息    当前页
local _action_list_curr_type        = 0    -- 当前请求的动态类型

-- added by aXing on 2013-5-25
function GuildModel:fini( ... )
    _lave_times  = nil
    _fuben_diff = nil 
    _btn_status = nil
    _person_times= nil
    _guild_times = nil
    _user_guild_info        = nil
    _guild_info             = {}
    _guild_page_curr        = 1
    _guild_page_total       = 0
    _rows_count_per_page    = 6
    _apply_guild_id_t       = {} 
    _enter_goto_page_num    = 0 
    _memb_infos             = {}
    _memb_online_num        = 0
    _memb_no_online_num     = 0 
    _memb_page_curr         = 1 
    _apply_infos            = {} 
    _apply_page_curr        = 1
    _guild_tianyuan_range   = 0 
    _guild_tianyuan_score   = {} 
    _guild_tianyuan_list    = {}
    _tianyuan_curr_page     = 1 
    _init_altar_page = false
    _init_altar_page_info = false
    _guild_altar_egg_page_info = nil
    _guild_altar_page_info = nil
    _guild_altar_page_type = 0
    _guild_altar_egg_page_info = GuildAltarEggPageInfo()
    _guild_altar_page_info = GuildAltarPageInfo()
    _is_return_init = false
    _guild_alter_update_list = {}

    _action_infos               = {}   -- 仙宗动态信息（列表）
    _action_tianyuan_infos      = {}   -- 仙宗动态-天元之战信息（列表）
    _personal_tianyuan_info     = {}   -- 本人的天元之战排名信息
    _action_all_curr_page       = 1    -- 全部仙宗动态信息   当前页
    _action_storage_curr_page   = 1    -- 仙踪仓库信息   当前页
    _action_tianyuan_curr_page  = 1    -- 天元之战当前页
    _action_list_curr_type      = 0    -- 当前请求的动态类型
    if self.lave_timer then
        self.lave_timer:stop()
        self.lave_timer = nil
    end
    UIManager:destroy_window( "guild_win" )
end

function GuildModel:get_guild_alter_update_list()
    return _guild_alter_update_list
end

function GuildModel:clear_guild_alter_update_list()
    _guild_alter_update_list = nil
    _guild_alter_update_list = {}
end

function GuildModel:get_is_return_init()
    return _is_return_init
end

function GuildModel:set_is_return_init(result)
    _is_return_init = result
end

-- 私有方法

--================================================================
--  更新
--================================================================
-- 更新仙宗窗口
local function update_guild_win( update_type )
    require "UI/guild/GuildWin"
    GuildWin:update_guild_win( update_type )
end

-- 更新  创建  仙宗窗口
local function update_create_guild_win( update_type )
    require "UI/guild/GuildWin"
    GuildWin:update_guild_win( update_type )
end

-- 更新申请列表窗口
local function update_guild_apply_win( update_type )
    require "UI/guild/GuildApplyWin"
    GuildWin:update_guild_win( update_type )
end


-- 公有方法

--================================================================
--  数据操作
--================================================================
-- 设置角色帮派信息
function GuildModel:set_user_guild_info( user_guild_info )
    _user_guild_info = user_guild_info
    update_guild_win( "user_guild_info" )
end

-- 获取角色的帮派信息
function GuildModel:get_user_guild_info(  )
    return _user_guild_info
end

-- 初始化数据，申请第一页, 用于第一次创建的仙宗该列表信息的时候
function GuildModel:init_guild_info(  )
    require "control/GuildCC"
    GuildCC:request_guild_info_list( 1, _rows_count_per_page )
end

-- 设置仙宗信息. 参数： 获取到的仙宗信息（table，元素结构：GuildInfo），仙宗个数， 当前页，总页数
function GuildModel:add_guild_info( infos , count, curr_num, page_total)
    _guild_page_curr = curr_num + 1
    _guild_page_total = page_total
    _guild_info[ _guild_page_curr ] = infos        --  一页一页地存储， 页号作为索引
    -- _guild_count = _guild_count + count
    
    
    update_guild_win( "guild_list" )
    -- update_guild_win( "if_join_guild" )
    local win = UIManager:find_window( "guild_win" )  -- 关闭情况下也要更新
    if win ~= nil then
        win:update( "if_join_guild" )
    end
end

-- 获取仙宗信息: 信息表
function GuildModel:get_guild_info(  )
    return _guild_info
end

-- 获取仙宗信息的分页信息. 返回 当前页数字，总页数
function GuildModel:get_guild_info_page_info(  )
    return _guild_page_curr, _guild_page_total
end

-- 获取当前页信息
function GuildModel:get_curr_page_date()
    if _guild_info[ _guild_page_curr ] then
        return _guild_info[ _guild_page_curr ]
    else
        require "control/GuildCC"
        GuildCC:request_guild_info_list( _guild_page_curr, _rows_count_per_page )
        return {}
    end
end

-- 获取每页有多少行
function GuildModel:get_rows_count_per_page(  )
    return _rows_count_per_page
end

-- 获取 跳转输入框的数字
function GuildModel:get_enter_goto_page_num( )
    return _enter_goto_page_num
end

-- 清空所有页
function GuildModel:clear_all_page_date()
    _guild_info = {}
end

-- 获取玩家仙宗的最大数量
function GuildModel:get_user_guild_max_count(  )
    local guild_level = GuildModel:get_guild_level( )
    require "config/GuildConfig"
    local guild_level_info = GuildConfig:get_guild_level_info( guild_level )
    return guild_level_info.maxMember
end

-- 获取玩家仙宗下一级的最大数量
function GuildModel:get_user_guild_max_next_level(  )
    local guild_level = GuildModel:get_guild_level( )
    require "config/GuildConfig"
    local guild_level_info = GuildConfig:get_guild_level_info( guild_level + 1 )
    return guild_level_info.maxMember
end

-- 获取该等级仙宗最大数量
function GuildModel:get_guild_level_max_count( guild )
    require "config/GuildConfig"
    local guild_level_info = GuildConfig:get_guild_level_info( guild.level )
    return guild_level_info.maxMember
end

-- 获取玩家所属的仙宗等级。  （这个等级是聚仙等级）
function GuildModel:get_guild_level( )
    return GuildModel:get_guild_building_level( "biMain" )
end

-- 获取仙宗建筑等级.  biMain :聚仙   biPT :蟠桃  biBoss :boss   biStore :百宝阁 biBeast 神兽祭坛
function GuildModel:get_guild_building_level( building_type )
    -- 等级4个字节，从低到高，分别代表4个建筑的等级
    local level = _user_guild_info.level

    -- print("GuildModel:get_guild_building_level level",level)

    require "utils/Utils"
    if building_type == "biMain" then
        -- print("===========biMain level: ", Utils:get_long_long_value_index_stept_info( level, 1, 8 ))
        return Utils:get_long_long_value_index_stept_info( level, 1, 8 )
    elseif building_type == "biPT" then
        -- print("===========biPT level: ", Utils:get_long_long_value_index_stept_info( level, 2, 8 ))
        return Utils:get_long_long_value_index_stept_info( level, 2, 8 )
    elseif building_type == "biBoss" then
        -- print("===========biBoss level: ", Utils:get_long_long_value_index_stept_info( level, 3, 8 ))
        return Utils:get_long_long_value_index_stept_info( level, 3, 8 )
    elseif building_type == "biStore" then
        -- print("===========biStore level: ", Utils:get_long_long_value_index_stept_info( level, 4, 8 ))
        return Utils:get_long_long_value_index_stept_info( level, 4, 8 )
    elseif building_type == "biBeast" then
        -- print("===========biBeast level: ", Utils:get_long_long_value_index_stept_info( level, 5, 8 ))
        return Utils:get_long_long_value_index_stept_info( level, 5, 8 )
    end
    return 1
end

-- 获取仙宗职位的名称
function GuildModel:get_guild_standing_name( position_index )
    local position_name = Lang.guild_info.position_name_t -- { "军士", "校官", "尉官", "副军团长", "军团长" }
    if position_name[ position_index ] then
        return position_name[ position_index + 1 ]
    end
    return position_name[ 1 ]
end

-- 获取仙宗福利数值.  参数：guild_level 玩家仙宗等级, guild_position_index 数字 仙宗职位index 
function GuildModel:get_guild_welfare( guild_level, guild_position_index )
    local key = { "member", "jy", "hufa", "secLeader", "leader" }  
    require "config/GuildConfig"
    local guild_level_info = GuildConfig:get_guild_level_info( guild_level )    -- 该等级，仙宗的信息
    return guild_level_info.money[1][ key[guild_position_index + 1] ]
end

-- 获取 领取福利需要的消耗仙币
function GuildModel:get_welfare_need_consume(  )
    require "config/GuildConfig"
    return GuildConfig:get_weal_contrib(  )
end

-- 玩家仙宗信息改变
function GuildModel:change_user_guild_info( attr_type, value )
    _user_guild_info[ attr_type ] = value
    update_guild_win( attr_type )
end

-- 设置仙宗成员信息
function GuildModel:set_memb_infos( memb_infos, memb_online_count, memb_no_online_count )
    _memb_infos = memb_infos
    -- for i,v in ipairs(_memb_infos) do
    --     _memb_infos[i].fightValue = GuildModel:get_member_fight_val(_memb_infos[i].ActorId)
    -- end
    _memb_online_num = memb_online_count
    _memb_no_online_num = memb_no_online_count
    update_guild_win( "guild_member_info" )
end

-- 获取仙宗成员信息
function GuildModel:get_memb_infos( )
    return _memb_infos, _memb_online_num, _memb_no_online_num
end

-- 获取仙宗成员总数
function GuildModel:get_memb_total_num(  )
    return _memb_online_num + _memb_no_online_num
end

-- 获取仙宗成员当前页
function GuildModel:get_memb_curr_page(  )
    return _memb_page_curr
end

-- 获取仙宗成员总页数
function GuildModel:get_memb_total_page(  )
    local member_total = GuildModel:get_memb_total_num()
    local page_total = member_total / _rows_count_per_page - member_total / _rows_count_per_page % 1
    if member_total % _rows_count_per_page > 0 then        -- 向上取整
        page_total = page_total + 1
    end
    return page_total
end

-- 设置申请加入仙宗玩家信息
function GuildModel:set_apply_infos( apply_infos )
    _apply_infos = apply_infos
    update_guild_apply_win( "apply_list" )
end

-- 获取申请加入仙宗玩家信息
function GuildModel:get_apply_infos( )
    return _apply_infos
end

-- 获取申请玩家当前页
function GuildModel:get_apply_curr_page(  )
    return _apply_page_curr
end

-- 获取申请玩家的页数
function GuildModel:get_apply_page_total(  )
    local apply_total = #_apply_infos
    local page_total = apply_total / _rows_count_per_page - apply_total / _rows_count_per_page % 1
    if apply_total % _rows_count_per_page > 0 then        -- 向上取整
        page_total = page_total + 1
    end
    return page_total
end

-- 根据 玩家id，删除申请 列表一个数据
function GuildModel:remove_one_apply_date( actorId )
    for i = 1, table.maxn( _apply_infos ) do
        if _apply_infos[i] and _apply_infos[i].actorId == actorId then
            table.remove( _apply_infos, i )
        end
    end
    update_guild_win( "apply_list" )
end

-- 获取升级需要的灵石数量  biMain :聚仙   biPT :蟠桃  biBoss :boss   biStore :百宝阁
function GuildModel:get_building_upgrade_need_stone( building_type )
    local guild_level = GuildModel:get_guild_building_level( building_type )
    require "config/GuildConfig"
    local guild_level_info = GuildConfig:get_guild_level_info( guild_level )
    local index_t = { biMain = 1, biPT = 2, biBoss = 3, biStore = 4, biBeast = 5 }
    return guild_level_info.stone[ index_t[ building_type ] ]
end

-- 获取蟠桃建筑等级，效果的描述   current   next
function GuildModel:get_pantao_effect( level_type )
    local effect_t = {
            Lang.guild.building[45], -- [199]="可以参加蟠桃盛宴活动"
            Lang.guild.building[46], -- [200]="蟠桃盛宴经验灵力增加10%"
            Lang.guild.building[47], -- [201]="蟠桃盛宴经验灵力增加20%"
            Lang.guild.building[48], -- [202]="蟠桃盛宴经验灵力增加30%"
            Lang.guild.building[49], -- [203]="蟠桃盛宴经验灵力增加40%"
            Lang.guild.building[50], -- [204]="蟠桃盛宴经验灵力增加50%"
            Lang.guild.building[51], -- [205]="蟠桃盛宴经验灵力增加60%"
            Lang.guild.building[52], -- [206]="蟠桃盛宴经验灵力增加70%"
            Lang.guild.building[53], -- [207]="蟠桃盛宴经验灵力增加80%"
            Lang.guild.building[54], -- [208]="蟠桃盛宴经验灵力增加100%"
         }
    local pantao_building_level = GuildModel:get_guild_building_level( "biPT" )
    if level_type == "current" then
        return effect_t[ pantao_building_level ]
    else
        local level_temp = ( pantao_building_level >= 10 and 10 or (pantao_building_level + 1) )
        return effect_t[ level_temp ]
    end
end

-- 获取仙灵建筑，效果描述   current   next
function GuildModel:get_xianling_effect( level_type )
    local effect_t = {
             Lang.guild.building[55], -- [209]="可召唤一阶军团领地BOSS"
             Lang.guild.building[56], -- [210]="可召唤二阶军团领地BOSS"
             Lang.guild.building[57], -- [211]="可召唤三阶军团领地BOSS"
             Lang.guild.building[58], -- [212]="可召唤四阶军团领地BOSS"
             Lang.guild.building[59], -- [213]="可召唤五阶军团领地BOSS"
             Lang.guild.building[60], -- [214]="可召唤六阶军团领地BOSS"
             Lang.guild.building[61], -- [215]="可召唤七阶军团领地BOSS"
             Lang.guild.building[62], -- [216]="可召唤八阶军团领地BOSS"
             Lang.guild.building[63], -- [217]="可召唤九阶军团领地BOSS"
             Lang.guild.building[64], -- [218]="可召唤十阶军团领地BOSS"
         }
    local xianling_building_level = GuildModel:get_guild_building_level( "biBoss" )
    if level_type == "current" then
        return effect_t[ xianling_building_level ]
    else
        local level_temp = ( xianling_building_level >= 10 and 10 or (xianling_building_level + 1) )
        return effect_t[ level_temp ]
    end
end

-- 获取百宝建筑，效果描述   current   next
function GuildModel:get_baibao_effect( level_type )
    local effect_t = {
             Lang.guild.building[65], 
             Lang.guild.building[66], 
             Lang.guild.building[67], 
             Lang.guild.building[68], 
             Lang.guild.building[69], 
             Lang.guild.building[70], 
             Lang.guild.building[71], 
             Lang.guild.building[72], 
             Lang.guild.building[73], 
             Lang.guild.building[74], 

          -- [219]="1级仙宗商店道具解封"
          -- [220]="2级仙宗商店道具解封"
          -- [221]="3级仙宗商店道具解封"
          -- [222]="4级仙宗商店道具解封"
          -- [223]="5级仙宗商店道具解封"
          -- [224]="6级仙宗商店道具解封"
          -- [225]="7级仙宗商店道具解封"
          -- [226]="8级仙宗商店道具解封"
          -- [227]="9级仙宗商店道具解封"
          -- [228]="10级仙宗商店道具解封"
         }
    local baibao_building_level = GuildModel:get_guild_building_level( "biStore" )
    if level_type == "current" then
        return effect_t[ baibao_building_level ]
    else
        local level_temp = ( baibao_building_level >= 10 and 10 or (baibao_building_level + 1) )
        return effect_t[ level_temp ]
    end
end

-- 获取神兽祭坛，效果描述   current   next
function GuildModel:get_jitan_effect( level_type )
    local stept = GuildConfig:get_ji_tan_level_stept()
    local effect_t = Lang.guild.building[43] -- [43]="可供养等级上限为%d的神兽"
    local level = GuildModel:get_guild_building_level( "biBeast" )
    if level_type == "current" then
        return string.format( effect_t, stept * level )
    else
        local level_temp = ( level >= 10 and 10 or (level + 1) )
        return string.format( effect_t, stept * level_temp )
    end
end


-- true 返回 蓝色，  false返回红色
function GuildModel:get_color_by_bool( check )
    local color_blue = "#c66FF66"
    local color_red  = "#cff0000"
    if check then
        return color_blue
    else
        return color_red
    end
end

-- 聚仙升级条件, 蟠桃 百宝 仙灵  灵石，依次判断的返回
function GuildModel:check_juxian_up_condition(  )
    local pantao_check = false
    local xianling_check = false
    local baibao_check = false
    local stone_check = false
    local shen_shou_check = false

    local juxian_level = GuildModel:get_guild_building_level( "biMain" ) 
    local pantao_level = GuildModel:get_guild_building_level( "biPT" )
    local xianling_level = GuildModel:get_guild_building_level( "biBoss" )
    local baibao_level = GuildModel:get_guild_building_level( "biStore" )
    local shen_shou_level = GuildModel:get_guild_building_level( "biBeast" )
    if juxian_level <= pantao_level then
        pantao_check = true
    end
    if juxian_level <= xianling_level then
        xianling_check = true
    end
    if juxian_level <= baibao_level then
        baibao_check = true
    end
    if juxian_level <= shen_shou_level then
        shen_shou_check = true
    end
    local need_stone = GuildModel:get_building_upgrade_need_stone( "biMain" )
    if need_stone <= _user_guild_info.stone_num then
        stone_check = true
    end
    print(juxian_level, pantao_level, xianling_level, baibao_level,shen_shou_check)
    print( pantao_check, xianling_check, baibao_check, stone_check,shen_shou_check)
    return pantao_check, xianling_check, baibao_check, stone_check,shen_shou_check
end

-- 根据聚仙升级条件，返回四个颜色
function GuildModel:get_junxian_up_cond_color(  )
    local pantao_check, xianling_check, baibao_check, stone_check, shen_shou_check = GuildModel:check_juxian_up_condition(  )
    local color_t = {}
    color_t[ 1 ] = GuildModel:get_color_by_bool( pantao_check )
    color_t[ 2 ] = GuildModel:get_color_by_bool( xianling_check )
    color_t[ 3 ] = GuildModel:get_color_by_bool( baibao_check )
    color_t[ 4 ] = GuildModel:get_color_by_bool( stone_check )
    color_t[ 5 ] = GuildModel:get_color_by_bool( shen_shou_check )
    return color_t
end

-- 蟠桃/仙灵/百宝阁  升级条件判断    biPT :蟠桃  biBoss :boss   biStore :百宝阁
function GuildModel:check_con_up_condition( con_type )
    local juxian_check = false
    local stone_check  = false

    local juxian_level = GuildModel:get_guild_building_level( "biMain" ) 
    local con_level = GuildModel:get_guild_building_level( con_type )
    if con_level < juxian_level then
        juxian_check = true
    end

    local need_stone = GuildModel:get_building_upgrade_need_stone( con_type )
    if need_stone <= _user_guild_info.stone_num then
        stone_check = true
    end
    return juxian_check, stone_check
end

-- 根据蟠桃升级条件，返回四个颜色
function GuildModel:get_con_up_cond_color( con_type )
    local juxian_check, stone_check = GuildModel:check_con_up_condition( con_type )
    local color_t = {}
    color_t[ 1 ] = GuildModel:get_color_by_bool( juxian_check )
    color_t[ 2 ] = GuildModel:get_color_by_bool( stone_check )
    return color_t
end

-- 设置玩家仙宗等级
function GuildModel:set_self_guild_level( level )
    _user_guild_info.level = level
    update_guild_win( "guild_level" )
end

-- 获取仙宗商店物品列表
function GuildModel:get_guild_item_list(  )
    require "config/GuildConfig"
    return GuildConfig:get_guild_store(  )
end

-- 根据id获取仙宗商店物品价格
function GuildModel:get_guild_shop_price_by_id( item_id )
    local item_list = GuildModel:get_guild_item_list(  )
    for key, value in pairs(item_list) do
        if value.itemid == item_id then
            return value.contrib
        end
    end
    return 0
end

-- 获取玩家仙宗贡献值
function GuildModel:get_user_guild_contribute(  )
    return _user_guild_info.contribution
end

-- 设置天元之战排名信息
function GuildModel:set_tianyuan_range_info( guild_range, guild_score, guild_range_list )
    _guild_tianyuan_range  = guild_range        -- 仙宗天元之战排名
    _guild_tianyuan_score  = guild_score        -- 仙宗天元之战得分
    _guild_tianyuan_list  = guild_range_list   -- 仙宗天元之战列表
    
    --xiehande 
    -- print("xiehande  GuildModel:set_tianyuan_range_info")
    -- print(_guild_tianyuan_range)
    --  print(_guild_tianyuan_score)
    --   print(_guild_tianyuan_list)

   
    update_guild_win( "tianyuan_list" )    
    update_guild_win( "self_tianyuan" )    
end

-- 获取天元之战信息
function GuildModel:get_tianyuan_infos( )
    return _guild_tianyuan_list
end

-- 获取本仙宗天元之战排名信息
function GuildModel:get_self_tianyuan_range_info(  )
    return _guild_tianyuan_range, _guild_tianyuan_score
end

-- 获取天元之战当前页
function GuildModel:get_tianyuan_curr_page(  )
    return _tianyuan_curr_page
end

-- 获取天元之战排行总页数
function GuildModel:get_tianyuan_total_page(  )
    local tianyuan_total = #_guild_tianyuan_list
    local page_total = math.ceil( tianyuan_total / _rows_count_per_page )
    return page_total
end

--================================================================
--  逻辑区域
--================================================================
-- 判断玩家是否已经加入仙宗
function GuildModel:check_if_join_guild( )
    local player = EntityManager:get_player_avatar()
    if player.guildId == 0 or player.guildId == nil then
        return false
    else
        return true
    end
end

-- 下一页
function GuildModel:guild_list_next_page( )
    if _guild_page_curr < _guild_page_total then
        _guild_page_curr = _guild_page_curr + 1
    end
    update_guild_win( "guild_list" )
end

-- 上一页
function GuildModel:guild_list_pre_page( )
    if _guild_page_curr > 1 then
        _guild_page_curr = _guild_page_curr - 1
    end
    update_guild_win( "guild_list" )
end

-- 首页
function GuildModel:guild_first_first_page(  )
    _guild_page_curr = 1
    update_guild_win( "guild_list" )
end

-- 尾页
function GuildModel:guild_last_first_page(  )
    _guild_page_curr = _guild_page_total
    update_guild_win( "guild_list" )
end

-- 跳转到页面
function GuildModel:guild_list_goto_page( )
    _guild_page_curr = _enter_goto_page_num
    update_guild_win( "guild_list" )
end

-- 判断该仙宗是否已经申请
function GuildModel:check_if_had_apply_guild( guild_id )
    if guild_id == nil then
        return false
    end
    for key, guild_id_temp in ipairs( _apply_guild_id_t ) do
        if guild_id_temp == guild_id then
            return true
        end
    end
    return false
end

-- 输入跳转 数字
function GuildModel:enter_num_go_to_page( )
    require "UI/common/BuyKeyboardWin"
    local function enter_num_call_back( num )
        _enter_goto_page_num = num
        update_guild_win( "goto_page_num" )
    end
    BuyKeyboardWin:show( nil, enter_num_call_back, 3, _guild_page_total )
end

-- 判断当前页是否有前名排行的仙宗,   依次次返回 是否存在的bool值（返回三个值）
function GuildModel:check_if_has_three_ranking(  )
    local curr_date = GuildModel:get_curr_page_date()
    local ranking_check = { false, false, false}      -- 依次表示是否存在第一 二 三
    for key, guild in ipairs( curr_date ) do
        if guild.ranking == 1 or guild.ranking == 2 or guild.ranking == 3 then
            ranking_check[ guild.ranking ] = true
        end
    end
    return unpack( ranking_check )
end

-- 显示创建窗口
function GuildModel:show_create_guild_win(  )
    UIManager:show_window( "create_guild_win" )
end

-- 创建仙宗窗口，条件判断
function GuildModel:check_create_guild_confitions( guild_name )
    local notice_words_t = { LangModelString[230], -- [230]="#cff0000名称不能为空！"
                             LangModelString[231], -- [231]="#cff0000名称中不能包含空格！"
                             LangModelString[232],  -- [232]="#cff0000仙币不足！"
                             LangModelString[233],  } -- [233]="#cff0000仙创建仙宗必须25级！"
    local player = EntityManager:get_player_avatar()
    if guild_name == nil or guild_name == "" then
        return false, notice_words_t[1]
    elseif string.find( guild_name, "%s" ) ~= nil then
        return false, notice_words_t[2]
    elseif player.bindYinliang < 250000 then
        --天降雄狮修改 xiehande  如果是铜币不足/银两不足/经验不足 做我要变强处理
         ConfirmWin2:show( nil, 13, Lang.screen_notic[11],  need_money_callback, nil, nil )
        return false, notice_words_t[3]
    elseif player.level < 25 then
        return false, notice_words_t[4]
    end
    return true
end

-- 显示帮派详细信息窗口
function GuildModel:show_guild_detail( guild )
    require "UI/guild/GuildWin"
    GuildWin:show_guild_detail( guild )
end

-- 关闭详细信息窗口
function GuildModel:hide_guild_detail( )
    require "UI/guild/GuildWin"
    GuildWin:hide_guild_detail( )
end

function GuildModel:hide_donate_win( ... )
    require "UI/guild/GuildWin"
    GuildWin:hide_donate_win()
end

-- 根据仙宗信息，判断仙宗是否已满
function GuildModel:check_guild_count_full( guild )
    local full_count = GuildModel:get_guild_level_max_count( guild )
    if full_count <= guild.memb_count then
        return true
    else
        return false
    end
end

-- 判断是否可以领取福利
function GuildModel:check_if_can_welfare(  )
    if _user_guild_info.if_can_welfare ~= 0 then
        return true
    else
        return false
    end
end

-- 弹出提示框  false时弹出提示框。  msg 提示信息
function GuildModel:show_notice_win(  msg )
    -- print("GuildModel:show_notice_win msg",msg)
    ConfirmWin( "notice_confirm", nil, msg, nil, nil, 450, nil)
end

-- 打开商店 （要关闭仙宗窗口）
function GuildModel:show_guild_store(  )
    UIManager:hide_window( "guild_win" )
    UIManager:show_window( "guild_shop_win" )
end

-- 获取成员信息当前页信息：  所有成员数据， 起始位置， 结束位置
function GuildModel:get_mem_curr_page_date(  )
    GuildModel:check_memb_curr_page(  )
    local start_index = _rows_count_per_page * ( _memb_page_curr - 1 ) + 1
    local end_index   = _rows_count_per_page * _memb_page_curr
    local member_total = GuildModel:get_memb_total_num()
    if end_index > member_total then
        end_index = member_total
    end
    return _memb_infos, start_index, end_index
end

-- 当做踢出出操作时，有可能当前页已经大于最大页，这时要做纠正
function GuildModel:check_memb_curr_page(  )
    if _memb_page_curr > GuildModel:get_memb_total_page() then
        _memb_page_curr = GuildModel:get_memb_total_page()
    end
end

-- 成员信息  下一页
function GuildModel:member_next_page(  )
    local total_page = GuildModel:get_memb_total_page()
    if _memb_page_curr + 1 > total_page then
        return 
    else
        _memb_page_curr = _memb_page_curr + 1
        update_guild_win( "page" )
    end
end

-- 成员信息  上一页
function GuildModel:member_pre_page(  )
    local total_page = GuildModel:get_memb_total_page()
    if _memb_page_curr - 1 < 1 then
        return 
    else
        _memb_page_curr = _memb_page_curr - 1
        update_guild_win( "page" )
    end
end

-- 成员信息  首页
function GuildModel:member_first_page(  )
    _memb_page_curr = 1
    update_guild_win( "page" )
end

-- 成员信息  尾页
function GuildModel:member_last_page(  )
    local total_page = GuildModel:get_memb_total_page()
    _memb_page_curr = total_page
    update_guild_win( "page" )
end

-- 根据成员id，判断该成员是否在线
function GuildModel:check_member_if_online( ActorId )
    for i = 1, table.maxn( _memb_infos ) do
        if _memb_infos[i] and _memb_infos[i].ActorId == ActorId then
            if i <= _memb_online_num then            -- 在线人数排在前面，当大于在线人数，表示不在线
                return true
            else
                return false
            end
        end
    end
    return false
end

function GuildModel:get_member_fight_val( ActorId )
    local member = EntityManager:get_entity_by_id( ActorId )
    return member.fightValue
end

--弹出任命菜单 窗体  
function GuildModel:show_appoint_menu( memb_info )
    -- 帮主才可以任命
    if GuildModel:check_if_be_position( "wang" ) then
        local win = UIManager:find_visible_window("guild_win")
          if win then
                if win.all_page_t[2] then
                     win.all_page_t[2]:show_appoint_win({ memb_info })
                end
          end
    end
end


-- 弹出任命菜单
function GuildModel:show_nominate_menu( memb_info )
   -- require "UI/component/AlertWin"
     -- local panel = CCBasePanel:panelWithFile( 300, 300, 300, 300, "ui/common/common_tip_bg.png", 500, 500 )
     -- AlertWin:show_new_alert( panel )
   -- require "model/LeftClickMenuMgr"
    -- 帮主才可以任命
    if GuildModel:check_if_be_position( "wang" ) then
      --   LeftClickMenuMgr:show_left_menu( "guild_nominate_1", { memb_info })
        GuildWin:show_nominate_win({ memb_info })
    end
end

function GuildModel:hide_nominate_win( ... )
    GuildWin:hide_nominate_win()
end

-- 检查一个人是否是 某个职位  wang  deputy  hufa  elite   follower
function GuildModel:check_if_be_position( position )
    local positon_t = { wang = 4, deputy = 3, hufa = 2, elite = 1, follower = 0 }
    if _user_guild_info.standing == positon_t[ position ] then
        return true
    else
        return false
    end
end

-- 计算某个职位的人数  某个职位  wang  deputy  hufa  elite   follower
function GuildModel:calculate_posi_memb_num( position )
    local ret_num = 0
    local positon_t = { wang = 4, deputy = 3, hufa = 2, elite = 1, follower = 0 }
    for key, member in pairs( _memb_infos ) do
        if member.standing == positon_t[ position ] then
            ret_num = ret_num + 1
        end
    end
    return ret_num
end

-- 当做操作时，有可能当前页已经大于最大页，这时要做纠正
function GuildModel:check_apply_curr_page(  )
    if _apply_page_curr > GuildModel:get_apply_page_total() then
        _apply_page_curr = GuildModel:get_apply_page_total()
    end
    -- 第一次进入页面，没有数据，当前页会设置为0。申请数据后，当前页至少为1
    if _apply_page_curr == 0 and #_apply_infos > 0 then
        _apply_page_curr = 1
    end
end

-- 获取 申请 当前页信息： 返回 所有数据， 起始位置， 结束位置
function GuildModel:get_apply_curr_page_date(  )
    GuildModel:check_apply_curr_page(  )
    local start_index = _rows_count_per_page * ( _apply_page_curr - 1 ) + 1
    local end_index   = _rows_count_per_page * _apply_page_curr
    local apply_total = #_apply_infos
    if apply_total == 0 then       -- 如果没有数据
        start_index = 0
        end_index   = -1
    end
    if end_index > apply_total then
        end_index = apply_total
    end
    return _apply_infos, start_index, end_index
end

-- 首页
function GuildModel:apply_goto_first(  )
    _apply_page_curr = 1
    update_guild_win( "apply_page" )
end

function GuildModel:apply_goto_last(  )
    _apply_page_curr = GuildModel:get_apply_page_total()
    update_guild_win( "apply_page" )
end


-- 申请信息  下一页
function GuildModel:apply_next_page(  )
    local total_page = GuildModel:get_apply_page_total()
    if _apply_page_curr + 1 > total_page then
        return 
    else
        _apply_page_curr = _apply_page_curr + 1
        update_guild_win( "apply_page" )
    end
end

-- 申请信息  上一页
function GuildModel:apply_pre_page(  )
    local total_page = GuildModel:get_apply_page_total()
    if _apply_page_curr - 1 < 1 then
        return 
    else
        _apply_page_curr = _apply_page_curr - 1
        update_guild_win( "apply_page" )
    end
end

-- 传入成员信息，检查是否是玩家自己
function GuildModel:Check_if_be_self( memb_info )
    if memb_info == nil then
        return false
    end
    require "entity/EntityManager"
    local player = EntityManager:get_player_avatar()
    if player.id == memb_info.ActorId then
        return true
    else
        return false
    end
end

-- 到仙宗领地
function GuildModel:go_to_guild_manor(  )
    require "config/GuildConfig"
    local guild_scene_name, guild_npc_name = GuildConfig:get_guild_manor(  )

    require "config/GuildConfig"
    local guild_scene_name, guild_npc_name = GuildConfig:get_guild_questNPC(  )
    local function func_1(  )    -- 自动前往回调
        require "GlobalFunc"
        GlobalFunc:ask_npc_by_scene_name( guild_scene_name, guild_npc_name  )
        AlertWin:close_alert(  )
    end
    local function func_2(  )    -- 速传回调
        require "GlobalFunc"
        GlobalFunc:teleport_by_name( guild_scene_name, guild_npc_name )
        AlertWin:close_alert(  )
    end

    local notice_content = LH_COLOR[2]..Lang.guild[39] -- "找军团管理员做军团任务"
    -- GuildModel:create_go_to_panel( notice_content, func_1, func_2  )
    local confirmWin2_temp = ConfirmWin2:show( 6, nil, notice_content,  func_1, nil, nil )
    confirmWin2_temp:set_yes_but_func_2( func_2 )
end

-- 到仙宗人物npc
function GuildModel:go_to_guild_task_npc(  )
    require "config/GuildConfig"
    local guild_scene_name, guild_npc_name = GuildConfig:get_guild_questNPC(  )
    local function func_1(  )    -- 自动前往回调
        require "GlobalFunc"
        GlobalFunc:ask_npc_by_scene_name( guild_scene_name, guild_npc_name  )
        AlertWin:close_alert(  )
    end
    local function func_2(  )    -- 速传回调
        require "GlobalFunc"
        GlobalFunc:teleport_by_name( guild_scene_name, guild_npc_name )
        AlertWin:close_alert(  )
    end
    
    local notice_content = LH_COLOR[2]..Lang.guild[40] -- "请选择回军团驻扎地的方式"
    -- GuildModel:create_go_to_panel( notice_content, func_1, func_2  )
    local confirmWin2_temp = ConfirmWin2:show( 6, nil, notice_content,  func_1, nil, nil )
    confirmWin2_temp:set_yes_but_func_2( func_2 )
end

-- 创建  到仙宗领地选择按钮： 自动前往  速传
function GuildModel:create_go_to_panel( notice_content, func_1, func_2 )
    require "UI/common/ConfirmWin"
    local confirm_win = ConfirmWin( "select_confirm_2", nil, notice_content, nil, nil, nil, nil)
    --xiehande 通用按钮  btn_lan.png ->button3
    local but_1 = UIButton:create_button_with_name( 40, 30, 96, 43, UIResourcePath.FileLocate.common .. "button3.png", UIResourcePath.FileLocate.common .. "button3.png", nil, LangModelString[235], func_1 ) -- [235]="自动前往"
    confirm_win.view:addChild( but_1.view )

    local but_2 = UIButton:create_button_with_name( 180, 30, 96, 43, UIResourcePath.FileLocate.common .. "button3.png", UIResourcePath.FileLocate.common .. "button3.png", nil, LangModelString[236], func_2 ) -- [236]="速传"
    confirm_win.view:addChild( but_2.view )
end

-- 显示商店tips
function GuildModel:show_shop_tips( item_id )
    require "model/TipsModel"
    TipsModel:show_shop_tip( 200, 255, item_id,TipsModel.LAYOUT_RIGHT)
end

-- 根据百宝奇阁等级，获取仙宗商店“百宝奇阁“颜色
function GuildModel:get_shop_baibao_color_by_level( item_need_level )
    local biStore_level = GuildModel:get_guild_building_level( "biStore" )
    if biStore_level >= item_need_level then
        return "#c66ff66"
    end
    return "#cff0000"
end

-- 显示仙宗右键菜单  参数：一个仙宗成员结构
function GuildModel:show_guild_left_menu( member_info )
    local player = EntityManager:get_player_avatar()
    local if_online = GuildModel:check_member_if_online( member_info.ActorId )
    if player.id ~= member_info.ActorId and if_online then
        require "model/LeftClickMenuMgr"
        local tempdata = { roleId = member_info.ActorId, roleName = member_info.name, qqvip = member_info.qqvip, level = member_info.level, camp = player.camp, job = member_info.job, sex = member_info.sex }
        LeftClickMenuMgr:show_left_menu("chat_other_list_menu", tempdata)
    end
end

-- 获取天元之战当前页信息：  所有数据， 起始位置， 结束位置
function GuildModel:get_tianyuan_curr_page_date(  )
    GuildModel:check_tianyuan_curr_page(  )
    local start_index = _rows_count_per_page * ( _tianyuan_curr_page - 1 ) + 1
    local end_index   = _rows_count_per_page * _tianyuan_curr_page
    local tianyuan_total = #_guild_tianyuan_list
    if end_index > tianyuan_total then
        end_index = tianyuan_total
    end
    return _guild_tianyuan_list, start_index, end_index
end

-- 有可能当前页已经大于最大页，这时要做纠正
function GuildModel:check_tianyuan_curr_page(  )
    if _tianyuan_curr_page > GuildModel:get_tianyuan_total_page() then
        _tianyuan_curr_page = GuildModel:get_tianyuan_total_page()
    elseif GuildModel:get_tianyuan_total_page() > 0 and _tianyuan_curr_page < 1 then
        _tianyuan_curr_page = 1
    end
end

-- 获取当前页和总页数
function GuildModel:get_tianyuan_page_info(  )
    return _tianyuan_curr_page, GuildModel:get_tianyuan_total_page()
end

-- 天元之战排名， 首页
function GuildModel:tianyuan_first_page(  )
    _tianyuan_curr_page = 1
    update_guild_win( "tianyuan_list" )      
end

-- 天元之战排名， 末页
function GuildModel:tianyuan_last_page(  )
    _tianyuan_curr_page = GuildModel:get_tianyuan_total_page()
    update_guild_win( "tianyuan_list" )    
end

-- 天元之战排名， 上一页
function GuildModel:tianyuan_pre_page(  )
    local total_page = GuildModel:get_tianyuan_total_page()
    if _tianyuan_curr_page - 1 < 1 then
        return 
    else
        _tianyuan_curr_page = _tianyuan_curr_page - 1
        update_guild_win( "tianyuan_list" )   
    end 
end

-- 天元之战排名， 下一页
function GuildModel:tianyuan_next_page(  )
    local total_page = GuildModel:get_tianyuan_total_page()
    if _tianyuan_curr_page + 1 > total_page then
        return 
    else
        _tianyuan_curr_page = _tianyuan_curr_page + 1
        update_guild_win( "tianyuan_list" )
    end
end

-- 判断是否可以邀请加入仙宗
function GuildModel:check_ask_join_right(  )
    -- 检查一个人是否是 某个职位  wang  deputy  hufa  elite   follower
    if  GuildModel:check_if_be_position( "wang" ) or GuildModel:check_if_be_position( "deputy" ) or GuildModel:check_if_be_position( "hufa" ) then
        return true
    else
        return false
    end
end

-- 判断是否宗主和副宗主
function GuildModel:is_zongzhu(  )
    -- 检查一个人是否是 某个职位  wang  deputy  hufa  elite   follower
    if  GuildModel:check_if_be_position( "wang" ) or GuildModel:check_if_be_position( "deputy" ) then
        -- print("return true")
        return true
    else
        -- print("return false")
        return false
    end
end

--================================================================
--  与服务器的通讯
--================================================================
-- 获取一页的信息  参数：协议号, 发送协议的参数,  params 参数表,table类型
function GuildModel:ruquest_send_to_server( protocol_index, params_t )
    require "control/GuildCC"
    local func = {};
    func[3] = GuildCC.request_guild_info_list
    
    if func[ protocol_index ] == nil then
        return 
    end

    func[ protocol_index ]( nil, unpack( params_t ) )               -- nil表示静态调用中的self
end

-- 申请加入仙宗
function GuildModel:apply_to_join_guild( guild_id )
    require "control/GuildCC"
    GuildCC:request_apply_join_guild( guild_id )
    
end

-- 加入仙宗的结果，处理. 仙宗id，  是否成功申请（true false）
function GuildModel:apply_join_guild_result( guild_id, result )
    if result then
        table.insert( _apply_guild_id_t, guild_id )
        update_guild_win( "guild_list" )
        GlobalFunc:create_screen_notic( Lang.guild_info.join_notice_3 )
    else
        -- todo
    end
end

-- 取消申请加入仙宗
function GuildModel:cancel_to_join_guild(guild_id, player_id)
    require "control/GuildCC"
    GuildCC:request_cancel_join_guild( guild_id, player_id )

end
-- 取消申请加入仙宗的结果，处理. 仙宗id，  是否成功申请（true false）
function GuildModel:cancel_join_guild_result( guild_id, result )
    if result then
        for key, guild_id_temp in ipairs( _apply_guild_id_t ) do
            if guild_id_temp == guild_id then
                table.remove(_apply_guild_id_t, key)
                GlobalFunc:create_screen_notic( Lang.guild_info.join_notice_4 )
                break
            end
        end
        update_guild_win( "guild_list" )
    end
end

--申请加入仙宗的数量
function GuildModel:join_guild_num()
    return _apply_guild_id_t and #_apply_guild_id_t or 0
end

-- 创建仙宗
function GuildModel:create_guild( icon_index, guild_name )
    require "control/GuildCC"
    GuildCC:request_create_guild( icon_index, guild_name)
    
end

-- 服务器通知创建仙宗结果
function GuildModel:create_guild_result( guild_id )
    -- 主界面弹出提示字
    local function mini_but_func(  )
        local content = Lang.guild.create[3] -- [1]="请于24小时内将军团发展到10人以上，否则自动解散!"
        NormalDialog:show( content, nil, 2 )
    end 
    MiniBtnWin:show( 13 , mini_but_func ,nil )
    UIManager:hide_window( "create_guild_win" )
    local guild_win = UIManager:show_window( "guild_win" )
    -- print("GuildModel:create_guild_result guild_win",guild_win)
    if guild_win ~= nil then
        guild_win:change_page(1)
    end
end

-- 更新仙宗数据
function GuildModel:update_user_guild_date( date_type )
    if date_type == "guildId" then
        require "control/GuildCC"
        GuildCC:request_self_guild_info()
       
        local win = UIManager:find_window( "guild_win" )  -- 关闭情况下也要更新
        if win ~= nil then
            win:update( "guildId" )
        end
        -- update_guild_win( "guildId" )
    end
end

-- 请求玩家的仙宗数据
function GuildModel:request_user_guild_date(  )
    require "control/GuildCC"
    GuildCC:request_self_guild_info()
end

-- 服务器 更新帮派信息   1：仙宗首页   2：成员列表   3：申请列表   4：建筑   5：仙宗列表
function GuildModel:server_guild_info_change( content_type )
    if content_type == 1 then
        GuildModel:request_user_guild_date(  )
        --xiehande 捐献之后 还需要刷新成员列表的贡献数据
        GuildModel:request_member_info(  )
    elseif content_type == 2 then
        GuildModel:request_member_info(  )
    elseif content_type == 3 then
        -- GuildModel:request_action_list( _action_list_curr_type )
        GuildModel:request_apply_join_list(  )
    elseif content_type == 4 then
        GuildModel:request_user_guild_date(  )
    elseif content_type == 5 then
        -- 仙宗首页信息改变，就要删除每一页，重新申请
        GuildModel:clear_all_page_date()
        require "control/GuildCC"
        GuildCC:request_guild_info_list( _guild_page_curr, _rows_count_per_page )
    elseif content_type == 6 then
        -- 仙宗仓库整理信息改变，
        GuildCC:req_cangku_items()
    end
end

-- 申请获取福利
function GuildModel:send_get_welfare(  )
    -- 判断当前贡献值是否够领取福利
    local contribution_need = GuildModel:get_welfare_need_consume() or 0
    if _user_guild_info.contribution >= contribution_need then
        require "control/GuildCC"
        GuildCC:request_get_welfare()
        return true
    else
        -- 如果贡献不够，提示
        GuildModel:show_notice_win(  LangModelString[238] ) -- [238]="您的贡献值不够，不能领取福利!"
        return false
    end
end

-- 申请获取福利的返回
function GuildModel:get_welfare_result( result, msg )
    if result == 0 then
        GuildModel:show_notice_win(  msg )
        GuildModel:request_user_guild_date(  )

    end
end

-- 修改仙宗公告
function GuildModel:modify_guild_notice( content )
    require "control/GuildCC"
    GuildCC:request_flash_notice( 0 , content )
end

-- 脱离帮派
function GuildModel:request_leave_guild(  )
    local function confirm_fun(  )
        require "control/GuildCC"
        GuildCC:request_leave_guild()
    end
    require "UI/common/ConfirmWin"
    local notice_content = LH_COLOR[2]..Lang.guild[38] -- "确定退出军团吗？"
    ConfirmWin2:show( 4, nil, notice_content,  confirm_fun, nil, nil )
end

-- 捐献
function GuildModel:contribute_to_guild(  )

    local function enter_num_call_back( num )
        local money_type = 3
        local price = num
        local param = {num, money_type}
        local donate_func = function( param )
            require "control/GuildCC"
            GuildCC:request_donate( param[1], param[2] )
        end
        MallModel:handle_auto_buy( price, donate_func, param )
    end

    -- 如果元宝不够，就弹出充值界面
    -- local player = EntityManager:get_player_avatar()
    -- if player.yuanbao < 1 then 
    --     local function confirm2_func()
    --         -- print("打开充值界面")
    --         GlobalFunc:chong_zhi_enter_fun()
    --         --UIManager:show_window( "chong_zhi_win" )
    --     end
    --     ConfirmWin2:show( 2, 2, "",  confirm2_func)
    --     return 
    -- end

    --通过数字键盘捐献--------------------------------------------
    require "UI/common/BuyKeyboardWin"

    BuyKeyboardWin:show( nil, enter_num_call_back, 4, 999 )
    --------------------------------------------------------------

    --通过页面
   -- FamilyDonateWin:show(enter_num_call_back, 999)
    --GuildWin:show_donate_win()
end

-- 请求服务器发送仙宗成员信息
function GuildModel:request_member_info(  )
    -- require "control/GuildCC"
    print('GuildModel:request_member_info')
    GuildCC:request_guild_memb_list()
end

-- 踢出成员 通过ID踢出，不需要显示名字
function GuildModel:shot_off_member( player_id )
    local function confirm_fun(  )
        require "control/GuildCC"
        GuildCC:request_fire_member( player_id )
    end
    require "UI/common/ConfirmWin"
    local notice_words = Lang.guild[41] -- [240]="\n\n\n#cffff00确定踢出吗？"
    ConfirmWin( "select_confirm", nil, notice_words, confirm_fun, nil, 450, nil)
end

--踢出成员2  显示确定踢出某某某吗
function GuildModel:shot_off_member2( player )
    local function confirm_fun(  )
        require "control/GuildCC"
        GuildCC:request_fire_member( player.ActorId )
    end
    require "UI/common/ConfirmWin"
    local notice_words = Lang.guild[41]..player.name..Lang.guild[42] -- [240]="\n\n\n#cffff00确定踢出吗？"
    ConfirmWin( "select_confirm", nil, notice_words, confirm_fun, nil, 450, nil)
end

-- 发送 任命一个角色  请求
function GuildModel:send_nominate_member( player_id, position )
-- print("发送 任命一个角色  请求~~~~~~~~~~~~~~", player_id, position)
    require "UI/common/ConfirmWin"
    local function confirm_fun(  )
        require "control/GuildCC"
        GuildCC:request_up_down_grade( player_id, position )
    end
    -- 如果是任命为宗主，弹出提示框
    if position == 4 then
        -- print("确定禅让宗主吗？")
        local notice_words =Lang.guild[46] -- [241]="确定禅让宗主吗？"
        ConfirmWin( "select_confirm", nil, notice_words, confirm_fun, nil, 260, nil)
        return
    end

    local  deputy_num = GuildModel:calculate_posi_memb_num( "deputy" )  -- 获取 副宗主的个数
    local  hufa_num = GuildModel:calculate_posi_memb_num( "hufa" )
    local  elite = GuildModel:calculate_posi_memb_num( "elite" )

    if position == 3 and deputy_num >= 1 then
        GuildModel:show_notice_win( Lang.guild.list[32]) -- [242]="副宗主只能有1个"
        return 
    end
    if position == 2 and deputy_num >= 4 then
        GuildModel:show_notice_win( Lang.guild.list[33]) -- [243]="护法只能有4个"
        return 
    end
    if position == 1 and deputy_num >= 10 then
        GuildModel:show_notice_win( Lang.guild.list[34]) -- [244]="精英只能有10个"
        return 
    end
    confirm_fun( )
end

-- 请求服务器发送申请列表
function GuildModel:request_apply_join_list(  )
    require "control/GuildCC"
    GuildCC:request_apply_join_list()
end

-- 回应申请加入仙宗. resp_result: 数字  0 拒绝  1 接受 。  申请的玩家id 
function GuildModel:response_apply_join( resp_result, player_id )
    -- 不管是同意还是拒绝，都要先删除该条数据
    GuildModel:remove_one_apply_date( player_id )
    -- 如果是接受，要判断是否满员
    if GuildModel:check_guild_count_full( _user_guild_info ) then
        GuildModel:show_notice_win( Lang.guild.list[35] ) -- [245]="成员已满！"
        return 
    end
    require "control/GuildCC"
    GuildCC:request_apply_join_result( resp_result, player_id)
end

-- 发送建筑升级  juxian  pantao  xianling  baibao
function GuildModel:request_upgrade_building( building )
    local building_type = { juxian = 0,  pantao = 1,  xianling = 2,  baibao = 3, jitan = 4 } 
    if building_type[ building ] == nil then
        return 
    end
    require "control/GuildCC"
    GuildCC:request_upgr_guild( building_type[ building ] )
end

-- 邀请加入仙宗
function GuildModel:ask_other_join_guild( player_id, player_name )
    require "control/GuildCC"
    GuildCC:request_ask_join_guild( player_id, player_name)
end

-- 购买物品
function GuildModel:buy_guild_shop_item( item_id, item_need_level )
    local biStore_level = GuildModel:get_guild_building_level( "biStore" )
    if biStore_level < item_need_level then
        GuildModel:show_notice_win( Lang.guild.building[44]) -- [246]="百宝奇阁等级不够!"
        return 
    end
    require "UI/common/BuyKeyboardWin"
    BuyKeyboardWin:show( item_id, nil, 7, 99 )
end

-- 请求天元之战数据
function GuildModel:req_tianyuan_battle_tongji(  )
    require "control/MiscCC"
    MiscCC:request_tianyuan_range(  )
end

-- 被邀请加入仙宗
function GuildModel:asked_join_guild( guild_id, guild_name, asker_name  )
   -- print("被邀请加入仙宗..................")
    local confirmWin = nil
    local function accept_func(  )      -- 同意回调
       -- print("同意回调", guild_id)
        GuildCC:request_if_accept_join( 1, guild_id )
        if confirmWin then
            confirmWin:close_win(  )
        end
    end
    local function refuse_func(  )      -- 拒绝
       -- print("拒绝", guild_id)
        GuildCC:request_if_accept_join( 0, guild_id )
        if confirmWin then
            confirmWin:close_win(  )
        end
    end

    -- 如果设置系统设置了自动同意，就同意
    local if_auto_accept = SetSystemModel:get_date_value_by_key( SetSystemModel.AUTO_ACCEPT_GUILD )
    if if_auto_accept then
        accept_func()
        return
    end

    local guild_name_temp = guild_name or ""
    local asker_name_temp = asker_name or ""
    local notice_words = "["..asker_name_temp..Lang.guild[47]..guild_name_temp.."]" -- [247]="]邀请你加入["
    -- confirmWin = ConfirmWin( "select_confirm_2", nil, notice_words, nil, nil, 260, 160)
    -- confirmWin:no_close_click_anywhere(  )
    confirmWin = ConfirmWin2:show( 8, nil, notice_words, accept_func, nil, 3)
    confirmWin:set_yes_but_func_2( refuse_func )

    -- 同意按钮
    -- local accept_but = UIButton:create_button_with_name( 30 , 30, 73, 35, UIResourcePath.FileLocate.common .. "btn_lan.png", UIResourcePath.FileLocate.common .. "btn_lan.png", nil, LangModelString[149], accept_func ) -- [149]="接受"
    -- confirmWin.view:addChild( accept_but )

    -- -- 拒绝按钮
    -- local refuse_but = UIButton:create_button_with_name( 167 , 30, 73, 35,UIResourcePath.FileLocate.common .. "btn_lan.png", UIResourcePath.FileLocate.common .. "btn_lan.png", nil, LangModelString[248], refuse_func ) -- [248]="拒绝"
    -- confirmWin.view:addChild( refuse_but )
end

------------------------------------------------------------------------------
function GuildModel:get_altar_price_rate()
    return GuildConfig:get_altar_find_xian_guo_money()
end
------------------
function GuildModel:set_guild_altar_egg_page_last_altar_info_refresh_time(result)
    _guild_altar_egg_page_info.last_altar_info_refresh_time = result
end
------------------
function GuildModel:set_guild_altar_page_last_altar_info_refresh_time(result)
    _guild_altar_page_info.last_altar_info_refresh_time = result
end
------------------
function GuildModel:set_guild_altar_egg_page_last_scroll_refresh_time(result)
    _guild_altar_egg_page_info.last_scroll_refresh_time = result
end
------------------
function GuildModel:set_guild_altar_page_last_scroll_refresh_time(result)
    _guild_altar_page_info.last_scroll_refresh_time = result
end
------------------
function GuildModel:set_guild_altar_egg_page_is_request(result)
    _guild_altar_egg_page_info.is_request_altar_info = result
end
------------------
function GuildModel:set_guild_altar_page_is_request(result)
    _guild_altar_page_info.is_request_altar_info = result
end
------------------
function GuildModel:get_guild_altar_page_type()
    return _guild_altar_page_type
end
------------------
function GuildModel:set_guild_altar_page_type(result)
    _guild_altar_page_type = result
end
------------------
function GuildModel:get_guild_altar_page_init_info()
    return _init_altar_page
end
------------------
function GuildModel:set_guild_altar_page_init_info(result)
    _init_altar_page = result
end
------------------
function GuildModel:get_guild_altar_egg_page_info()
    return _guild_altar_egg_page_info
end
------------------
function GuildModel:get_guild_altar_page_info()
    return _guild_altar_page_info
end
------------------
function GuildModel:pop_font_altar_info(info)
    table.remove( info, 1 )
end
------------------
function GuildModel:pop_back_altar_info(info)
    table.remove( info )
end
------------------
function GuildModel:clear_altar_info(info)
    info = nil
    info = {}
end

function GuildModel:get_pet_level() -- here_here
    return _guild_altar_page_info.pet_level
end
------------------  
function GuildModel:update_guild_altar_info(gem_index, gem_exp, pet_level, pet_exp, touch_num, xian_guo_num)
    local change_page = false
    if _guild_altar_page_info.pet_level == 0 and pet_level >= 1 then
        change_page = true
    end
    _guild_altar_egg_page_info.gem_index = gem_index
    _guild_altar_egg_page_info.cur_process = gem_exp
    _guild_altar_egg_page_info.touch_num = touch_num

    if touch_num >= GuildConfig:get_altar_touch_max_num() then
        _guild_altar_egg_page_info.my_touch_num = 0
    end
    --_guild_altar_egg_page_info.pet_level = pet_level
    _guild_altar_page_info.pet_level = pet_level
    _guild_altar_page_info.pet_exp = pet_exp
    -- _guild_altar_page_info.xian_guo_num = xian_guo_num
    -- print("_guild_altar_page_info.xian_guo_num",xian_guo_num)
    --_guild_altar_page_info.xian_guo_num = xian_guo_num
    local guild_win = UIManager:find_visible_window("guild_win")
    if guild_win ~= nil then
      --  local config_info = GuildConfig:get_altar_change_page_info()
        if change_page then
            guild_win:page_altar_page_change()
        end
        guild_win:update("update_all")
    end

    -------如果有仙宗图标，添加仙宗图标到 人物属性窗口里显示
    -- if _guild_altar_page_info.pet_level > 0 then 
    --     local window = UIManager:find_window("user_attr_win");
    --     if window ~= nil then
    --         window.all_page_t[1]:add_xz_icon()
    --     end
    -- end

    GuildCC:client_send_get_xian_guo_info()
end
------------------
function GuildModel:update_guild_altar_notic_info(info)
    local addcont = nil
    -- print("GuildModel:update_guild_altar_notic_info info[1].event_type", info[1].event_type)
    _guild_altar_egg_page_info.altar_info = nil
    _guild_altar_egg_page_info.altar_info = {}
    _guild_altar_page_info.altar_info = nil
    _guild_altar_page_info.altar_info = {}
    for i = 1, #info do
        if info[i].event_type == 0 then
            if #_guild_altar_egg_page_info.altar_info >= _guild_altar_event_info_max_num then
                table.remove( _guild_altar_egg_page_info.altar_info, 1 )
            end
            table.insert( _guild_altar_egg_page_info.altar_info, info[i] )
        else
            if #_guild_altar_page_info.altar_info >= _guild_altar_event_info_max_num then
                table.remove( _guild_altar_page_info.altar_info, 1 )
            end
            table.insert( _guild_altar_page_info.altar_info, info[i] )
        end
    end
    -- print("GuildModel:update_guild_altar_notic_info #_guild_altar_page_info.altar_info", #_guild_altar_page_info.altar_info )
    -- print("GuildModel:update_guild_altar_notic_info #_guild_altar_egg_page_info.altar_info ", #_guild_altar_egg_page_info.altar_info )
    GuildModel:sort_guild_altar_info()
    ------------
    local guild_win = UIManager:find_visible_window("guild_win")
    if guild_win ~= nil then
        guild_win:update("update_scroll")
    end
end
------------------
function GuildModel:update_altar_num_info(xian_guo_num, find_xian_guo_num, touch_num)
    _guild_altar_egg_page_info.my_touch_num = touch_num
    _guild_altar_page_info.xian_guo_num = xian_guo_num
    _guild_altar_page_info.find_xian_guo_num = find_xian_guo_num
    local guild_win = UIManager:find_visible_window("guild_win")
    if guild_win ~= nil then
        guild_win:update("update_touch_num")
        guild_win:update("update_touch_btn")
        guild_win:update("update_xian_guo_num")
        guild_win:update("update_find_xian_guo_num")
    end
    GuildCC:client_send_get_xian_guo_info()
end
------------------
function GuildModel:open_guild_altar()
    if _init_altar_page_info == false then
        GuildCC:client_send_guild_altar_info()
        if _guild_altar_page_type == 1 then
            GuildCC:client_send_touch()
        end
        _init_altar_page_info = true
    end
end
------------------
function GuildModel:guild_altar_rule_btn_fun()
    --NoticDialog:show( Lang.guild.guild_altar_info.page_notic )
    GuildModel:show_notice_win( Lang.guild.guild_altar_info.page_notic )
end
------------------
function GuildModel:guild_altar_xian_guo_info_btn_fun()

end
------------------
function GuildModel:guild_altar_touch_btn_fun()
    if _guild_altar_egg_page_info.my_touch_num <= 0 then
        GuildCC:client_send_touch()
   end
end
------------------
function GuildModel:guild_altar_xian_guo_btn_fun(index)
    if _guild_altar_page_info.xian_guo_num > 0 then
        GuildCC:client_send_xian_guo(index)
    end
end
------------------
function GuildModel:guild_altar_find_xian_guo_num_btn_fun()
    if _guild_altar_page_info.find_xian_guo_num > 0 then
        local function buy_fun()
            GuildCC:client_send_find_touch_num( _guild_altar_xian_guo_cur_find_num )
            _guild_altar_xian_guo_cur_find_num = 0
        end
        local function cancle_fun()
            _guild_altar_xian_guo_cur_find_num = 0
        end
        local function ok_fun(num)
            _guild_altar_xian_guo_cur_find_num = num
            local price = GuildConfig:get_altar_find_xian_guo_money()
            NormalDialog:show( string.format( Lang.guild.guild_altar_info.find_xian_guo_notic_info, num * price, num ), buy_fun, 1, cancle_fun ) 
        end
        BuyKeyboardWin:show(nil, ok_fun, 11, 99, {Lang.guild[48]}, true ) -- [249]="输入数字"
        
    end
end
------------------
function GuildModel:sort_guild_altar_info()
    local function sort_fun( a, b )
        if a.time > b.time then
            return true
        else
            return false
        end
    end
    table.sort( _guild_altar_egg_page_info.altar_info, sort_fun )
    table.sort( _guild_altar_page_info.altar_info, sort_fun )
end
------------------
function GuildModel:update_qq_vip_info()
    local guild_win = UIManager:find_window("guild_win")
    if guild_win ~= nil then
        guild_win:update_guild_self_qqvip_info()
    end
end
------------------
function GuildModel:check_text_our_of_range_error(info)
    local guild_win = UIManager:find_window("guild_win")
    guild_win.all_page_t[1].left_panel.guild_name_edit:setText(info)
end


function GuildModel:req_bag_to_cangku (quality,item_series, target_series)
    function sure_fun( )
        GuildCC:req_bag_to_cangku(item_series, target_series)
    end
    if quality >= 3 and GuildModel:is_zongzhu() == false then --紫色 黄色
        NormalDialog:show(Lang.guild.cangku.item_tishi,sure_fun,1)
    else
        sure_fun()
    end
end


function GuildModel:req_cangku_to_bag(item_date,item_series, target_series)
    function sure_fun(select_num)
        GuildCC:req_cangku_to_bag(item_series, target_series,select_num)
    end
    if item_date.count > 1 and GuildModel:is_zongzhu() ==true then
        BuyKeyboardWin:show(item_date.item_id,sure_fun,13,item_date.count)
    else -- if item_obj.item_date.count == 1 then
        sure_fun(1)
    end
end

------------------------------------------------------------------------
-- 仙宗动态相关
-- 设置仙宗动态信息
function GuildModel:set_action_infos( action_infos )
    _action_infos = action_infos
    update_guild_win( "action_list" )
end

function GuildModel:add_action_info( action_info )
    local count = #_action_infos
    _action_infos[count + 1] = action_info
    update_guild_win( "action_list" )
end

function GuildModel:set_action_tianyuan_infos( action_infos )
    _action_tianyuan_infos = action_infos
    update_guild_win( "action_list" )
end

function GuildModel:add_action_tianyuan_info( action_info )
    local count = #_action_tianyuan_infos
    _action_tianyuan_infos[count + 1] = action_info
    update_guild_win( "action_list" )
end

function GuildModel:set_personal_tianyuan_info( info )
    _personal_tianyuan_info = info
    update_guild_win( "action_list" )
end

function GuildModel:get_personal_tianyuan_info( )
    return _personal_tianyuan_info
end

-- 请求服务器发送动态列表
function GuildModel:request_action_list( req_type )
    require "control/GuildCC"
    _action_list_curr_type = req_type
    -- print( "get guild even info, type = ", req_type )
    if req_type == 0 or req_type == 1 then
        GuildCC:client_send_guild_event_info( req_type )
    elseif req_type == 2 then
        GuildCC:req_tianyuan_rank_info()
        -- print("request tianyuan list")
    end
end

function GuildModel:request_personal_tianyuan_rank()
    GuildCC:req_personal_tianyuan_rank_info()
end

-- 当做操作时，有可能当前页已经大于最大页，这时要做纠正
function GuildModel:check_action_curr_page( req_type )
    local total = GuildModel:get_action_page_total( req_type )
    -- print ( "req_type = ", req_type, " total page = ", total )
    if req_type == 0 then
        if _action_all_curr_page >  total then
            _action_all_curr_page = total
        end
        -- 第一次进入页面，没有数据，当前页会设置为0。申请数据后，当前页至少为1
        if _action_all_curr_page == 0 and #_action_infos > 0 then
            _action_all_curr_page = 1
        end
    elseif req_type == 1 then
        if _action_storage_curr_page >  total then
            _action_storage_curr_page = total
        end
        -- 第一次进入页面，没有数据，当前页会设置为0。申请数据后，当前页至少为1
        if _action_storage_curr_page == 0 and #_action_infos > 0 then
            _action_storage_curr_page = 1
        end
    elseif req_type == 2 then
        if _action_tianyuan_curr_page >  total then
            _action_tianyuan_curr_page = total
        end
        -- 第一次进入页面，没有数据，当前页会设置为0。申请数据后，当前页至少为1
        if _action_tianyuan_curr_page == 0 and #_action_tianyuan_infos > 0 then
            _action_tianyuan_curr_page = 1
        end
    end
end

-- 获取 申请 当前页信息： 返回 所有数据， 起始位置， 结束位置
function GuildModel:get_action_curr_page_data( req_type )
    local _infos = {}
    GuildModel:check_action_curr_page( req_type )
    if req_type ~= _action_list_curr_type then
        return _infos, 0, -1
    end

    local _rows_count = _rows_count_per_page
    local _page_curr = 1
    if req_type == 0 then
        _infos = _action_infos
        _page_curr = _action_all_curr_page
    elseif req_type == 1 then
        _infos = _action_infos
        _page_curr = _action_storage_curr_page
    elseif req_type == 2 then
        _infos = _action_tianyuan_infos
        _page_curr = _action_tianyuan_curr_page
        _rows_count = _rows_count - 1
    end

    table.sort(_infos, function(a, b) return a.time > b.time end)

    -- print( "current page = ", _page_curr )

    local start_index = _rows_count * ( _page_curr - 1 ) + 1
    local end_index   = _rows_count * _page_curr
    local action_total = #_infos
    if action_total == 0 then       -- 如果没有数据
        start_index = 0
        end_index   = -1
    end
    if end_index > action_total then
        end_index = action_total
    end
    return _infos, start_index, end_index
end

-- 转到指定类型的当前页
function GuildModel:action_goto_curr( req_type )
    _action_list_curr_type = req_type
    update_guild_win("action_page")
end

-- 仙宗动态首页
function GuildModel:action_goto_first()
    req_type = _action_list_curr_type
    if req_type == 0 then
        _action_all_curr_page = 1
    elseif req_type == 1 then
        _action_storage_curr_page = 1
    elseif req_type == 2 then
        _action_tianyuan_curr_page = 1
    end

    update_guild_win( "action_page" )
end

-- 仙宗动态末页
function GuildModel:action_goto_last()
    local req_type = _action_list_curr_type
    if req_type == 0 then
        _action_all_curr_page = GuildModel:get_action_page_total( req_type )
    elseif req_type == 1 then
        _action_storage_curr_page = GuildModel:get_action_page_total( req_type )
    elseif req_type == 2 then
        _action_tianyuan_curr_page = GuildModel:get_action_page_total( req_type )
    end

    update_guild_win("action_page")
end


-- 仙宗动态  下一页
function GuildModel:action_next_page()
    local req_type = _action_list_curr_type
    local total_page = GuildModel:get_action_page_total( req_type )
    local _page_curr = 1
    if req_type == 0 then
        _page_curr = _action_all_curr_page
    elseif req_type == 1 then
        _page_curr = _action_storage_curr_page
    elseif req_type == 2 then
        _page_curr = _action_tianyuan_curr_page
    end

    -- print( "action next page :", _page_curr + 1 )
    if _page_curr + 1 > total_page then
        return 
    else
        if req_type == 0 then 
            _action_all_curr_page = _action_all_curr_page + 1
        elseif req_type == 1 then
            _action_storage_curr_page = _action_storage_curr_page + 1
        elseif req_type == 2 then
            _action_tianyuan_curr_page = _action_tianyuan_curr_page + 1
        end

        update_guild_win( "action_page" )
    end
end

-- 仙宗动态  上一页
function GuildModel:action_pre_page()
    local req_type = _action_list_curr_type
    local total_page = GuildModel:get_action_page_total( req_type )
    local _page_curr = 1
    if req_type == 0 then
        _page_curr = _action_all_curr_page
    elseif req_type == 1 then
        _page_curr = _action_storage_curr_page
    elseif req_type == 2 then
        _page_curr = _action_tianyuan_curr_page
    end

    if _page_curr - 1 < 1 then
        return 
    else
        if req_type == 0 then 
            _action_all_curr_page = _action_all_curr_page - 1
        elseif req_type == 1 then
            _action_storage_curr_page = _action_storage_curr_page - 1
        elseif req_type == 2 then
            _action_tianyuan_curr_page = _action_tianyuan_curr_page - 1    
        end

        update_guild_win( "action_page" )
    end
end

-- 获取仙宗动态信息
function GuildModel:get_action_infos( )
    return _action_infos, _action_list_curr_type
end

-- 获取仙宗动态-天元之战信息
function GuildModel:get_action_tianyuan_infos( )
    return _action_tianyuan_infos, _action_list_curr_type
end

-- 获取申请玩家当前页
function GuildModel:get_action_curr_page()
    local req_type = _action_list_curr_type
    if req_type == 0 then
        return _action_all_curr_page, _action_list_curr_type
    elseif req_type == 1 then
        return _action_storage_curr_page, _action_list_curr_type
    elseif req_type == 2 then
        return _action_tianyuan_curr_page, _action_list_curr_type
    end
end

-- 获取仙宗动态信息的页数
function GuildModel:get_action_page_total()
    local action_total = #_action_infos
    local _rows_count = _rows_count_per_page
    if _action_list_curr_type == 2 then
        action_total = #_action_tianyuan_infos
        _rows_count = _rows_count - 1
    end

    local page_total = action_total / _rows_count - action_total / _rows_count % 1
    if action_total % _rows_count > 0 then        -- 向上取整
        page_total = page_total + 1
    end
    return page_total
end

-- 获取仙宗动态信息的当前类型
function GuildModel:get_action_curr_type()
    return _action_list_curr_type
end

function GuildModel:show_apply_list_win()
    UIManager:show_window( "guild_apply_win", false )
    GuildModel:request_apply_join_list()
end


----------------------------------------------

function GuildModel:get_fuben_diff()
    -- print("_fuben_diff=",_fuben_diff)
    return _fuben_diff
end

function GuildModel:set_fuben_diff(diff)
    _fuben_diff  = diff
end


function GuildModel:get_fuben_times()
    return _person_times,_guild_times
end

function GuildModel:set_fuben_times(guild_times,person_times)
    _guild_times = guild_times
    _person_times = person_times
end


-------

function GuildModel:get_fuben_lave_times()--获得仙宗副本剩余时间  用于倒计时
    return _lave_times
end

function GuildModel:set_fuben_lave_times(lave_times)
    -- print("lave_times=",lave_times)
    if lave_times == nil then
        lave_times = 3600 
    end
    _lave_times = lave_times
    ------------------------
   
    self.lave_timer = timer()
    function lave_time_tatal( )
        if _lave_times ~= nil then
            _lave_times = _lave_times - 1
            if 3600- _lave_times > 60 then
                self.lave_timer:stop()
            end  
        end
    end
    self.lave_timer:start(1,lave_time_tatal)
end


function GuildModel:get_fuben_btn_status()--获得仙宗副本剩余时间  用于倒计时
    -- print("_btn_status=",_btn_status)
    return _btn_status
end

function GuildModel:set_fuben_btn_status(btn_status)--获得仙宗副本剩余时间  用于倒计时
    -- print("btn_status=",btn_status)
    _btn_status = btn_status

    local win = UIManager:find_window("guild_fuben_right")
    if win then
        win:update("btn")--刷新按钮
    end
end

function GuildModel:pop_notice()

    local function btn_fun1()
        GlobalFunc:ask_npc( 11,"仙宗管理员"  ) 
        UIManager:hide_window("guild_fuben_left");
        UIManager:hide_window("guild_fuben_right");
    end
    local function btn_fun2()
        GlobalFunc:teleport( 11,"仙宗管理员" )
        UIManager:hide_window("guild_fuben_left");
        UIManager:hide_window("guild_fuben_right");
    end
    local dialog = ConfirmWin2:show( 6, nil, Lang.guild.fuben.come_back_guild,  btn_fun1 )
    dialog:set_yes_but_func_2( btn_fun2 );
end


function GuildModel:show_help_panel( title_path, content )
    require "UI/common/HelpPanel"
    local t_help_win = HelpPanel:show( 3, title_path, content )
    t_help_win.exit_btn.view:setIsVisible(false)
end