-- EntrustConfig.lua
-- created by lyl on 2013-5-17
-- 活动配置



EntrustConfig = {}


-- 获取某个副本配置    
function EntrustConfig:get_entrust_info_by_fuben_id( fuben_id )
	require "../data/entrustconf"
	return entrustconf[fuben_id]
end

-- 根据副本id和最大层数，计算总共需要耗费的时间
function EntrustConfig:calculate_total_time( fuben_id, max_tier )
	local total_time = 0
	local entrust_info = EntrustConfig:get_entrust_info_by_fuben_id( fuben_id )
    if entrust_info then
    -- print("EntrustConfig:calculate_total_time, fuben_id, max_tier", fuben_id, max_tier, entrust_info.floor)
        for i = 1, #entrust_info.floors do
            if i <= max_tier then
                -- print("EntrustConfig:calculate_total_time entrust_info.floors[i].time",entrust_info.floors[i].time)
                total_time = total_time + entrust_info.floors[i].time
            end
        end
    end
    return total_time
end

-- 根据副本id和最大层数，计算总共获取到的经验值
function EntrustConfig:calculate_total_exp( fuben_id, max_tier )
    local total_exp = 0
    local entrust_info = EntrustConfig:get_entrust_info_by_fuben_id( fuben_id )
    if entrust_info then
        for i = 1, #entrust_info.floors do
            if i <= max_tier then
                for key, awards_info in pairs(entrust_info.floors[i].awards) do
                    if awards_info.type == 1 then
                        total_exp = total_exp + awards_info.amount
                    end
                end
            end
        end
    end
    return total_exp
end

-- 根据id和最大层数，计算指定奖励的可获取总量     1: 经验  2：历练 3：仙币  4：银两
function EntrustConfig:calculate_total_award_by_type( fuben_id, max_tier, award_type )
    local total_award = 0
    local entrust_info = EntrustConfig:get_entrust_info_by_fuben_id( fuben_id )
    if entrust_info then
        for i = 1, #entrust_info.floors do
            if i <= max_tier then
                for key, awards_info in pairs(entrust_info.floors[i].awards) do
                    if awards_info.type == award_type then
                        total_award = total_award + awards_info.amount
                    end
                end
            end
        end
    end
    return total_award
end

-- 根据副本id和层数，获取该层信息
function EntrustConfig:get_tier_info_by_id( fuben_id, tier )
    local entrust_info = EntrustConfig:get_entrust_info_by_fuben_id( fuben_id )
    if entrust_info then
        if entrust_info.floors[tier] then
            return entrust_info.floors[tier]
        end
    end
    return nil
end

-- 根据副本id，获取奖励的类型  返回table
function EntrustConfig:get_award_type_by_fuben_id( fuben_id )
    local award_type_t = {}       -- 存储所有类型
    local check_exist_t = {}          -- 用来判断是否已经存在

    local entrust_info = EntrustConfig:get_entrust_info_by_fuben_id( fuben_id )    
    if entrust_info then
        for i = 1, #entrust_info.floors do
            for key, award in pairs( entrust_info.floors[i].awards ) do 
                if not check_exist_t[ award.type ] then
                    check_exist_t[ award.type ] = true
                    table.insert( award_type_t, award.type ) 
                end
            end
        end
    end
    return award_type_t
end