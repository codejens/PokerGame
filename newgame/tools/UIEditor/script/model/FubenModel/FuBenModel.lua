-- FuBenModel.lua
-- create by hcl on 2013-2-19
-- 副本数据类

-- super_class.FuBenModel()
FuBenModel = {}

local _fuben_info_table = {};
-- 赏金副本的金钱
local _shangjin_money = 0;

-- 保存当前list_id
local _current_list_id = 0

--第一次打历练副本相关
local effect_tag = 10000
local effect_id = 11049		--火焰燃烧
local effect_id2 = 11048	--爆炸
local grid_pos = { {38,3},{35,5},{42,5}, {46,6}, {29,12}, {31,15}, {42,20}, {36,12}, {46,12},
			{44,21}, {35,22}, {30,19}, {30,26}, {23,24}, {18,24}, {22,11}, {21,18}, {14,18},
			{9,24}, {3,15}, {8,10},
		}
local _fuben_map_effect = {}	--记录副本地图特效的表
local cb_fire	--每一步创建火焰的定时器
local think		--总体创建爆炸+火焰特效定时器
-- added by aXing on 2013-5-25
function FuBenModel:fini( ... )
	_fuben_info_table = {};
	_shangjin_money = 0;
	if think then
		think:stop()
		think = nil
	end
end

function FuBenModel:set_current_list_id(current_list_id)
	_current_list_id = current_list_id
end

function FuBenModel:get_current_list_id()
	return _current_list_id
end

-- 根据list_id,拿到配置表，按钮列表的index
function FuBenModel:get_btn_index_by_list_id(list_id)
	for i=1,#fuben_challenge_config do
		if fuben_challenge_config[i].list_id == list_id then
			return i
		end 
	end
end

-- 存储今天能进副本的信息
function FuBenModel:set_fuben_info_table(fuben_info_table)
	_fuben_info_table = fuben_info_table
	require "model/ActivityModel"
	ActivityModel:enter_fuben_time_change(  )

	EntityManager:update_all_fb_npc()
end

function FuBenModel:get_fuben_info_table()
	return _fuben_info_table;
end

function FuBenModel:add_fuben_info_in_table( fuben_struct )
	-- 如果已经有这个数据则更新
	for i=1,#_fuben_info_table do
		if ( _fuben_info_table[i].list_id == fuben_struct.list_id ) then
			_fuben_info_table[i] = fuben_struct
			require "model/ActivityModel"
	        ActivityModel:enter_fuben_time_change()
			EntityManager:update_fb_npc(fuben_struct.fuben_id)
			return
		end
	end
	-- 没有则添加这个数据到最后
	_fuben_info_table[#_fuben_info_table + 1] = fuben_struct
	
	require "model/ActivityModel"
	-- ActivityModel:enter_fuben_time_change(  )
	local win = UIManager:find_visible_window("activity_dialog")
	if win then 
		win:update_fuben_times()
	end
	local rightTopWin = UIManager:find_window("right_top_panel")
	if rightTopWin then
		rightTopWin:update_activity_remain_tips()
	end

	-- 聚仙令副本次数刷新
	local win2 = UIManager:find_visible_window("juxianling_win")
	if win2 then 
		if win2:get_page_by_index(1) then
			win2:get_page_by_index(1):update("fuben_times")
		end
	end

	-- 忍者学园项目组的activity_Win第四个分页才是聚仙令，这应该是旧代码，注释掉。  note by gzn
	--更新副本组队面板
	-- local team_win = UIManager:find_visible_window("activity_Win" )
	-- if team_win then 
	-- 	if team_win.current_panel == team_win.all_page_t[4] then 
	-- 		ZXLog("更新副本组队面板-------------------")
	-- 		TeamActivityPage:change_right_panel( )
	-- 	end 
	-- end 
end

-- 根据list_id,获取大副本的剩余次数
function FuBenModel:get_fuben_remain_count_by_listId(list_id)
	for key, fuben in pairs(_fuben_info_table) do
        if fuben.list_id == list_id then
            return fuben.remain_count
        end
	end
	return 0
end

-- 根据副本id，获取当天进入副本次数和用户用元宝增加的次数
function FuBenModel:get_enter_fuben_count( fuben_id )
	for key, fuben in pairs(_fuben_info_table) do
        if fuben.fuben_id == fuben_id then
            return fuben.count, fuben.vip_add
        end
	end
	return 0, 0
end

-- 根据副本id，获取当天剩余副本次数和总次数
function FuBenModel:get_fuben_remain_total_count( fuben_id )
	for key, fuben in pairs(_fuben_info_table) do
        if fuben.fuben_id == fuben_id then
            return fuben.count, fuben.vip_add
        end
	end
	return 0, 0
end

--根据父副本id,获取其子副本次数
function FuBenModel:get_parent_fuben_count(list_id)
	require "config/FubenConfig"
	-- print("list_id",list_id)
	local sublist = FubenConfig:get_subfubenlist_by_fatherid(list_id)
	local total_count = 0
	local total_vip_add = 0
	for i=1,#sublist do
		local count,vip_add = FuBenModel:get_enter_fuben_count( sublist[i] )
		-- print("FuBenModel:get_enter_fuben_count( list_id,sublist[i],count,vip_add)",list_id,sublist[i],count,vip_add)
		total_count = total_count + count
		total_vip_add = total_vip_add + vip_add
	end
	-- print(total_count,total_vip_add)
	return total_count,total_vip_add
end

--根据父副本id,获取其子副本最大次数
function  FuBenModel:get_parent_fuben_max_count(list_id)
	require "config/FubenConfig"
	local sublist = FubenConfig:get_subfubenlist_by_fatherid(list_id)
	local total_max_count = 0
	for i=1,#sublist do
		local max_count = FuBenModel:get_enter_fuben_max_count(sublist[i])
		total_max_count = total_max_count + max_count
	end
	return total_max_count
end

-- 根据副本id， 获取该副本默认最大次数
function FuBenModel:get_enter_fuben_max_count( fuben_id )
	require "config/FubenConfig"
	local fuben_info = FubenConfig:get_fuben_info_by_id( fuben_id )
	if fuben_info then
        return fuben_info.daycount
    else
    	return 0
	end
end


-- 诛仙阵副本掉落宝箱
function FuBenModel:do_drop_chest( item )
	require "UI/UIManager"
	UIManager:show_window("fuben_chest_win");

end
-- 打开宝箱
function FuBenModel:open_chest_in_fuben( )
	require "control/MiscCC"
	MiscCC:req_open_chest_in_fuben(  )
	
end

function FuBenModel:set_shangjin_money( base_money, all_money)
	-- 连击赏金的基础值为 10 ，由 策划 陈均能 约定写死在前端。
	-- 这里是因为 服务器下发赏金数据慢了一步，所以需要追加一次赏金基础值
	_shangjin_money = all_money - base_money + 10;

end
function FuBenModel:clear_shangjin_money( )
	_shangjin_money = 0;
end
function FuBenModel:get_shangjin_money( )
	return _shangjin_money;
end

function FuBenModel:set_first_fuben( fuben_id )
	_first_fuben = fuben_id
	EventSystem.setParam('firstFubenInfo', { ['fuben_id'] = fuben_id })
end

function FuBenModel:get_first_fuben(  )
	return _first_fuben
end

-- 第一次进入 副本的指引
function FuBenModel:handle_first_fuben( bisha_index )
	local cur_fuben = SceneManager:get_cur_fuben()
	local first_fuben = FuBenModel:get_first_fuben()
	if first_fuben and first_fuben ~= 0 and cur_fuben == first_fuben then
		-- 指引挂机
		local instruct_id = InstructionConfig:get_first_fuben_instruct( first_fuben )
		if instruct_id then
			Instruction:start( instruct_id, nil )
			-- FuBenModel:set_first_fuben( nil )
			Instruction:setInstructionPlayed(first_fuben, true)
		end

		-- 指引必杀
		local bisha_instruct = InstructionConfig:get_bisha_instruct( first_fuben )
		if bisha_instruct then
			local instruct_count = bisha_instruct.instruct_count
			if bisha_index and bisha_index <= instruct_count then
				instruct_id = bisha_instruct.instruct_id
				Instruction:start( instruct_id, AIManager.set_guaji )
				Instruction:setInstructionPlayed(first_fuben, true)
				bisha_index = bisha_index + 1
			end
		elseif first_fuben ~= 4 then
			-- 历练副本在播放退出指引后才取消
			FuBenModel:set_first_fuben( nil )
		end
	end
	return bisha_index
end

function FuBenModel:play_fire_effect()
	think = timer()
	local eff_num = 1
	local function create_fire()
		if eff_num > #grid_pos then
			think:stop()
			think = nil
			return
		end
		local tag_no = eff_num
		local player = EntityManager:get_player_avatar()
		local ccp = CCPoint(grid_pos[eff_num][1]*32, grid_pos[eff_num][2]*32);
		ZXGameScene:sharedScene():mapPosToGLPos(ccp)
		LuaEffectManager:play_map_effect( effect_id2,ccp.x,ccp.y,false,10000,2,0 )
		local function fire()
			local ef = LuaEffectManager:play_map_effect( effect_id,ccp.x,ccp.y,true,10000,0,effect_tag + tag_no )

		end
		cb_fire = callback:new()
		cb_fire:start(0.2, fire)
		eff_num = eff_num + 1
	end
	think:start(0.21, create_fire)
end

function FuBenModel:stop_fire_effect()
	if think then
		think:stop()
		think = nil
	end
	if cb_fire then
		cb_fire:cancel()
		cb_fire = nil
	end
	local ui_node = ZXLogicScene:sharedScene():getSceneNode();
	for i = 1, #grid_pos  do
		local effect_node = ui_node:getChildByTag(effect_tag + i)
		if ( effect_node ) then
			effect_node:removeFromParentAndCleanup(true);
		end
	end
end
--获取每日活动全部副本id
function FuBenModel:get_all_fuben_id()
	require "../data/fuben_count_config"
	local fuben_list = {}
	for i=1,#fuben_count_config+1 do
		local sublist = FubenConfig:get_subfubenlist_by_fatherid(i)
		-- print("#fuben_count_config,i",#fuben_count_config,i)
		for j=1,#sublist do
			table.insert(fuben_list,sublist[j])
		end
	end
	-- for k=1,#fuben_list do
	-- 	print("fuben_list,k,fuben_list[k]",k,fuben_list[k])
	-- end
	return fuben_list
end