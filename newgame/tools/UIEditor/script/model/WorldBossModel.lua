-- WorldBossModel.lua
-- created by lyl on 2012-2-23
-- 世界boss

-- super_class.WorldBossModel()
WorldBossModel = {}

local _world_boss_date = {}       -- 世界boss数据
local timer_tab = {}	--世界boss的计时器
-- added by aXIng on 2013-5-25
function WorldBossModel:fini( ... )
	_world_boss_date = {} 
	for i, v in pairs(timer_tab) do
		v:cancel()
	end
	timer_tab = {}
end

-- ================================
-- 数据操作
-- ================================
-- 设置世界boss数据
function WorldBossModel:set_world_boss_date( world_boss_date )
	_world_boss_date = world_boss_date

 --    for key, boss in pairs(_world_boss_date) do
 --    	local boss_id = boss.id
	--     if boss.status == 0 then
	--     	if not timer_tab[boss_id] then
	--     		if boss.remainTime > 180 then
	-- 	    		local timer = callback:new()
	-- 	    		timer:start( boss.remainTime - 180, function()
	-- 	    			WorldBossWin:show(boss_id, 180)
	-- 	    			timer_tab[boss_id]:cancel()
	-- 	    			timer_tab[boss_id] = nil
	-- 	    		end )
	-- 	    		timer_tab[boss_id] = timer
	-- 	    	else
	-- 	    		WorldBossWin:show(boss_id, boss.remainTime)
	-- 	    	end
	-- 	    end
	--     end
	-- end

	require "model/ActivityModel"
	ActivityModel:date_change_update( "boss" )
end

-- 获取boss信息
function WorldBossModel:get_boss_by_id( boss_id )
	for key, boss in pairs(_world_boss_date) do
        if boss.id == boss_id then
            return boss
        end
	end
	return nil
end

-- ================================
-- 与服务器通讯
-- ================================
-- 申请世界boss数据
function WorldBossModel:apply_world_boss_date(  )
	require "control/OthersCC"
	OthersCC:request_world_boss_date( )
end