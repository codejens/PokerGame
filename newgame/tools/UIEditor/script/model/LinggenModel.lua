-- LinggenModel.lua
-- create by hcl on 2013-5-24
-- 管理灵根数据

-- super_class.LinggenModel()
LinggenModel = {}

local linggen_page = 0;
local linggen_lv = 0;

local lv_up_need_lq = 0;
local lv_up_need_yl = 0;

local is_first = true;

-- 灵气领取(普通)
LinggenModel.GET_LINGQI_NORMAL = 1;
-- 灵气领取(中级)
LinggenModel.GET_LINGQI_ZHONGJI= 2;
-- 灵气领取(高级)
LinggenModel.GET_LINGQI_GAOJI  = 3;

-- 当前灵气领取的状态值
local lingqi_state = 0;
-- 当前处于那个领取时间段
local lingqi_cur_stage = 0;
-- 下个领取时间段
local lingqi_next_stage = 1;

-- added by aXing on 2013-5-25
function LinggenModel:fini( ... )
	linggen_page = 0;
	linggen_lv = 0;

	lv_up_need_lq = 0;
	lv_up_need_yl = 0;

	lingqi_state      = 0;
	lingqi_cur_stage  = 0;
	lingqi_next_stage = 1;

	is_first = true;
	UIManager:destroy_window("linggen_win");
end

function LinggenModel:set_current_linggen_info( _linggen_page,_linggen_lv  )
	linggen_page = _linggen_page;
	linggen_lv = _linggen_lv;
	local win = UIManager:find_visible_window("linggen_win");
	if ( win ) then
		win:cb_do_get_linggen_info( linggen_page,linggen_lv );
	end
	if ( is_first ) then
		LinggenModel:can_lv_up()
		is_first = false;
	end
end

--刷新灵根积累值
function LinggenModel:set_accumulate_linggen_value(linggen_value)
	local win = UIManager:find_visible_window("linggen_win");
	if ( win ) then
		win:set_linggen_info(linggen_value);
	end
end


function LinggenModel:get_current_linggen_info()
	return linggen_page,linggen_lv;
end

function LinggenModel:can_lv_up()
	local linggen_point_index = linggen_page * 8 + linggen_lv
	-- print("linggen_point_index= ",linggen_point_index);
	if ( linggen_point_index > 0 and linggen_point_index < 96) then 
		local str,attri,value,expr,coin = RootConfig:get_info_by_level( linggen_point_index );
		local player = EntityManager:get_player_avatar();
		if ( player.lingQi > expr and player.yinliang > coin  ) then
			local function cb_fun()
				UIManager:show_window("linggen_win");
			end
			MiniBtnWin:show( 8 , cb_fun  )
		end
	end
end
-- 返回是否满足任意升级的条件
function LinggenModel:get_if_can_lv_up()
	local linggen_point_index = linggen_page * 8 + linggen_lv
	-- print("linggen_point_index= ",linggen_point_index);
	if ( linggen_point_index > 0 and linggen_point_index < 96) then 
		local str,attri,value,expr,coin = RootConfig:get_info_by_level( linggen_point_index );
		local player = EntityManager:get_player_avatar();
		if ( player.lingQi > expr and player.yinliang > coin  ) then
			return true
		end
	end
	return false
end

-- 获得当前处于那个领取时间段
function LinggenModel:getCurLingqiStage()
	return lingqi_cur_stage
end

-- 
function LinggenModel:getCurLingqiState()
	return lingqi_state
end

-- 
function LinggenModel:getNextLingqiStage()
	return lingqi_next_stage
end

-- 保存服务器端发送过来的灵气领取信息
function LinggenModel:setLingQiInfo(state, stage, next_stage)
	lingqi_state	  = state;
	lingqi_cur_stage  = stage;
	lingqi_next_stage = next_stage;

	-- local win = UIManager:find_visible_window("benefit_win")
	-- if win and win:isCurrentPanelChakela() then
	-- 	local panel = win:getPanelByType("chakela_benefit")
	-- 	if panel then
	-- 		panel:updateStageInfo()
	-- 	end
	-- end

	-- "领"字按钮(主界面飘字按钮),
	-- 按照策划新的需求,如果玩家当前等级小于20级,则不飘字按钮
	local player = EntityManager:get_player_avatar()
	if player.level < 20 then
		return
	end

	local miniWin  = UIManager:find_visible_window("mini_btn_win")
	local if_exist = false

	if miniWin then
		if_exist = MiniBtnWin:is_already_exist(22)
	end

	if lingqi_cur_stage ~= 0 then
		local cur_state = Utils:get_bit_by_position(state, stage)
		-- 当前可以领取,还未领取
		if cur_state == 0 then
-- 暂时没有灵气领取面板，以后做了再补上 note by gzn

			-- "领"字按钮已存在,不需要再创建一个出来
			-- if if_exist then
			-- 	return
			-- else
			-- 	local function click_callback()
			-- 		local benefitWin = UIManager:show_window("benefit_win")
			-- 		if not benefitWin:isCurrentPanelChakela() then
			-- 			benefitWin:change_page(4)
			-- 		end
			-- 	end
			-- 	MiniBtnWin:show(22, click_callback)
			-- end
		end
	else
		-- 当前时间段不在可领取区间,去掉主界面的"领"字按钮
		if if_exist then
			miniWin:remove_btn_and_layout("22")
		end
	end
end

-- 检测当前是否可以弹出"领"字提示按钮
function LinggenModel:check_lingqi_minibtn()
	if lingqi_cur_stage ~= 0 then
		local cur_state = Utils:get_bit_by_position(lingqi_state, lingqi_cur_stage)
		if cur_state == 0 then
			if MiniBtnWin:is_already_exist(22) then
				return
			end

-- 暂时没有灵气领取面板，以后做了再补上 note by gzn
			-- local function click_callback()
			-- 	local benefitWin = UIManager:show_window("benefit_win")
			-- 	if not benefitWin:isCurrentPanelChakela() then
			-- 		benefitWin:change_page(4)
			-- 	end
			-- end
			-- MiniBtnWin:show(22, click_callback)
		end
	end
end

-- ============================================
-- 真气修炼分页
-- ============================================
-- local lilian_value = nil
local xl_btn_state = false
local counter_full = 0
local counter_sp   = 0
local is_speed_up  = false

-- 真气修炼数据
function LinggenModel:req_zhenqi_data( )
	LingGenCC:req_zhenqi_data()
end

-- 真气修炼分页-潜心修炼
function LinggenModel:req_qx_xiulian( )
	LingGenCC:req_qx_xiulian()
end

-- 真气修炼分页-转化真气
function LinggenModel:req_change_zhenqi( )
	LingGenCC:req_change_zhenqi()
end

function LinggenModel:update_zhenqi_data( full_dc, speed_up_dc )
	if speed_up_dc ~= 0 then
		is_speed_up = true
	else
		is_speed_up = false
	end

	if speed_up_dc == 0 and full_dc ~= 0 then
		xl_btn_state = true
	else
		xl_btn_state = false
	end
	counter_full = full_dc
	counter_sp = speed_up_dc
	
	local win = UIManager:find_visible_window("linggen_win")
	if win then
		win:update("zhen_qi")
	end
end

function LinggenModel:get_zhenqi_data( )
	return xl_btn_state, counter_full, counter_sp, is_speed_up
end

function LinggenModel:get_item_config()
	require "../data/client/linggen_config" --灵根配置
	return award_linggen
end

-- 显示小按钮
function LinggenModel:show_mini_btn( popup_bubble )
	local function mini_but_func( )
		local win = UIManager:show_window("linggen_win")
		if win then
			win:change_page(2)
			win:play_xiulian_btn_effect(popup_bubble)
		end
	end
	if popup_bubble == 1 then
		MiniBtnWin:show( 26 , mini_but_func ,nil )	
	else
		MiniBtnWin:show( 25 , mini_but_func ,nil )	
	end
end

-- 获取真气凝聚的要求(?%)
function LinggenModel:get_xiulian_percent( )
	require "../data/root_config"
	local percent_xiulian = {}
	local num_percent = #root_config.PercentCost
	for i=1, num_percent do
		percent_xiulian[num_percent] = root_config.PercentCost[i][1]
		num_percent = num_percent - 1
	end
	return percent_xiulian
end

-- 获取哪一阶层转化获得的真气值
function LinggenModel:get_xiulian_zhenqi()
	require "../data/root_config"
	local zhenqi_xiulian = {}
	local num_zhenqi = #root_config.PercentCost
	for i=1, num_zhenqi do
		zhenqi_xiulian[num_zhenqi] = root_config.PercentCost[i][3]
		num_zhenqi = num_zhenqi - 1
	end
	return zhenqi_xiulian
end

-- 获取哪一阶层转化真气需要真气
function LinggenModel:get_cost_tongbi( index )
	require "../data/root_config"
	local cost_tongbi = {}
	local num_tongbi = #root_config.PercentCost
	for i=1, num_tongbi do
		cost_tongbi[num_tongbi] = root_config.PercentCost[i][2]
		num_tongbi = num_tongbi - 1
	end
	return cost_tongbi[index]
end

-- 转化真气结构
function LinggenModel:play_result_change( result )
	if result == 1 then
		local win = UIManager:find_visible_window("linggen_win")
		win:play_change_success_effect()
	else
		GlobalFunc:create_screen_notic("真气转化失败")
	end
end

-- 潜心修炼结果
function LinggenModel:play_result_qianxin( result )
	if result == 1 then
		local win = UIManager:find_visible_window("linggen_win")
		win:player_qx_progress_effect()
	else
		GlobalFunc:create_screen_notic("潜心修炼失败")
	end
end