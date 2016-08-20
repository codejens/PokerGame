-- DFTModel.lua
-- create by hcl on 2013-1-14
-- 斗法台类
-- 用于斗法台的所有数据

-- super_class.DFTModel()
DFTModel = {}

-- require "config/PetConfig"
-- 竞技场对手信息
local tab_dft_info = {};
-- 竞技场排行信息
local tab_dft_top_info = {};
-- 竞技场战绩信息
local tab_dft_zj_info = {};
-- 竞技场奖励信息
local tab_reward_info = {};
-- 剩余挑战次数
local tz_count = 0;

-- added by aXing on 2013-5-25
function DFTModel:fini( ... )
	tab_dft_info = {};
	tab_dft_top_info = {};
	tab_dft_zj_info = {};
	tab_reward_info = {};
end

function DFTModel:set_dft_info( _tab )
	tab_dft_info = _tab;
end

function DFTModel:get_dft_info(  )
	return tab_dft_info;
end
-- 取得斗法台排行榜信息
function DFTModel:get_dft_top_info(  )
	return tab_dft_top_info;
end

function DFTModel:set_dft_top_info( _tab_dft_top_info )
	tab_dft_top_info = _tab_dft_top_info;
end

function DFTModel:get_dft_ZJ_info(  )
	return tab_dft_zj_info;
end

function DFTModel:set_dft_ZJ_info( _tab_dft_zj_info )
	tab_dft_zj_info = _tab_dft_zj_info;
end

function DFTModel:add_dft_ZJ_info( item_zj )
	table.remove(tab_dft_zj_info,1);
	tab_dft_zj_info[4] = item_zj;
end

function DFTModel:get_reward_info(  )
	return tab_reward_info;
end

function DFTModel:set_reward_info( _tab_reward_info )
	tab_reward_info = _tab_reward_info;
end

-- 设置剩余挑战次数
function DFTModel:set_dft_tz_count( count )
	tz_count = count

	-- 通知小秘书
	SecretaryModel:update_win( "doufatai_remain" )

print("--tz_count:", tz_count)
	local win = UIManager:find_visible_window("right_top_panel")
	if win then 
		--成长之路，添加角标
		if tz_count > 0 then
			win:set_btntip_active_first(3)
		else
			win:remove_btntip_first(3)
		end	
	end
	local mgWin = UIManager:find_visible_window("menus_grow")
	if mgWin then
		mgWin:add_num_tip("doufatai", tz_count)
	end
end

function DFTModel:get_dft_tz_count( )
	return tz_count;
end