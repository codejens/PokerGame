-- ZhenYaoTaModel.lua
-- created by tjh on 2014-5-23
-- 镇妖塔model

ZhenYaoTaModel = {}
--一层有多少个
local _ONE_FLOOR_NUM = 10

--保存我的镇妖塔信息
local _my_zyt_info = nil

--挑战结果
local _my_challenge_result = {}

--层主信息
local _floor_master_master = {}

--查看窗口类型
ZhenYaoTaModel.CLOSE_TYPE = 1   --关闭
ZhenYaoTaModel.CHALLENGE_TYPE = 2 --挑战

function ZhenYaoTaModel:fini(  )
	_my_zyt_info = nil
	_my_challenge_result = {}
end

function ZhenYaoTaModel:show_window(  )
	UIManager:show_window("zhenyaota_win")
	--if not _my_zyt_info then
		ZhenYaoTaModel:req_player_clearance_info( )
		ZhenYaoTaModel:req_floor_master(  )
	--end
end
--切换层按钮回调
function ZhenYaoTaModel:change_floor_cb_func( index )
	local win = UIManager:find_window("zhenyaota_win")
	if win and _my_zyt_info ~= nil then 
		if index == 0 then
			index =  1
		end
		local statr_num =( index - 1 ) *_ONE_FLOOR_NUM
		local active_count = _my_zyt_info.max_floor - statr_num + 1
		--local floor = math.ceil((_my_zyt_info.max_floor+1)/10)
		win:update_curr_challenge_page_state( statr_num,active_count,index)
	end
end

--查看回调
function ZhenYaoTaModel:look_info_cb_func( index ,type)
	local win = UIManager:show_window( "zhenyaota_look_win")
	if win then 
		local name = ZhenYaoTaModel:get_floor_master_by_index( index )
		local str = ZhenYaoTaConfig:get_boss_gonglue( index )
		local award = ZhenYaoTaConfig:get_award_by_index( index )
		local avatar = EntityManager:get_player_avatar()
		local job_id = avatar.job
		local award_table = {}
		for i=1,#award do
			if not award[i].vocation or award[i].vocation == job_id then --职业过滤
				table.insert( award_table, award[i] )
			end
		end
		
		win:update_win(index,name,str,type,award_table)
	end
end

--申请个人通关信息
function ZhenYaoTaModel:req_player_clearance_info( )
	ZhenYaoTaCC:req_player_clearance_info(  )
end

--设置个人通关信息
function ZhenYaoTaModel:set_player_clearance_info( date )
	_my_zyt_info = date
	local index = math.ceil((_my_zyt_info.max_floor+1)/10)
	-- 限制最多打开第5大层，避免玩家打到50层后显示出第6大层
	if index > 5 then
		index = 5
	end
	ZhenYaoTaModel:change_floor_cb_func( index )
	local win = UIManager:find_window("zhenyaota_win")
	if win then
		win:update_my_info(_my_zyt_info.my_floor,index)
	end
end

--进入副本
function ZhenYaoTaModel:req_enter_fuben( index )
	--print("index",index)
	ZhenYaoTaCC:req_enter_fuben( index )
end

--进入下一关
function ZhenYaoTaModel:req_next_fuben(  )
	 ZhenYaoTaCC:req_next_fuben(  )
end

--重新挑战
function ZhenYaoTaModel:req_again_challenge(  )
	 ZhenYaoTaCC:req_again_challenge(  )
end

--设置挑战成功结果
function ZhenYaoTaModel:set_challenge_result( date )
	_my_challenge_result = date
	local win  = UIManager:show_window("zyt_result_success_win")
	if win then 
		win:update_win( date )
	end
end

--挑战失败
function ZhenYaoTaModel:challenge_fail(  )
	UIManager:show_window("zyt_result_fail_win")
end

--层主改变
function ZhenYaoTaModel:floor_master_change( index,name )
	-- local win = local win = UIManager:find_window("zhenyaota_win")
	-- if win  then 
	-- 	win:update_one_row( index,name,time )
	-- end
	ZhenYaoTaModel:req_floor_master(  )
end

--申请所以层主信息
function ZhenYaoTaModel:req_floor_master(  )
	ZhenYaoTaCC:req_floor_master(  )
end

--设置所有层主信息
function ZhenYaoTaModel:set_floor_master( date )
	_floor_master_master = date

	-- 刷新页面的数据
	local win = UIManager:find_visible_window("zhenyaota_win")
	if win then
		win:update_current_floor_data()
	end

	-- 没有显示各层层主信息的小分页了，所以这段也不需要了
 --    local win = UIManager:find_window("zhenyaota_win")
	-- if win  then 
	-- 	for i=1,#date do
	-- 		local time_str = ""
	-- 		if date[i].user_id ~= 0 then
	-- 		  time_str = string.format(Lang.zhenyaota[2],math.floor(date[i].time/60),date[i].time%60)	-- [2] = "%d分%d秒",
	-- 		  win:update_one_row( i,date[i].name,time_str)
	-- 		else
	-- 		  win:update_one_row( i,"",time_str )
	-- 		end
	-- 	end
	-- end
end

--获取某层层主名字
function ZhenYaoTaModel:get_floor_master_by_index( index )
	-- 对于连续获得关主的玩家，前面的关卡服务器会下发空的关主名字和不为空的通关时间。这个时候关主名字应该显示“暂无”
	if _floor_master_master[index] and _floor_master_master[index].name ~= "" then
		return _floor_master_master[index].name
	end
	return Lang.zhenyaota[1];	-- [1] = "暂无",
end

--获取某层的层主用时
function ZhenYaoTaModel:get_floor_time_by_index( index )
	-- 对于连续获得关主的玩家，前面的关卡服务器会下发空的关主名字和不为空的通关时间。这个时候此关通关时间应该显示“暂无”
	if _floor_master_master[index] and _floor_master_master[index].time ~= nil and _floor_master_master[index].name ~= "" then
		local tmp_time = _floor_master_master[index].time
		local time_str = string.format(Lang.zhenyaota[2],math.floor(tmp_time/60),tmp_time%60)	-- [2] = "%d分%d秒",
		return time_str
	end
	return Lang.zhenyaota[1];	-- [1] = "暂无",
end