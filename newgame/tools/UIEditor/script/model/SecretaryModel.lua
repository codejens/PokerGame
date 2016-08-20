-- SecretaryModel.lua
-- created by lyl on 2012-5-28
-- 小秘书系统

SecretaryModel = {}

local _huanle_count = 0         -- 欢乐护送剩余次数
local _zhanyao_count = 0        -- 斩妖除魔剩余次数
local _yinliang_count = 0       -- 银两任务剩余次数
local _xianzong_count = 0       -- 仙宗人物剩余次数

function SecretaryModel:fini(  )
    
end

-- 更新小秘书窗口
function SecretaryModel:update_win( update_type )
	SecretaryWin:update_win( update_type )
end

-- 请求连续登录奖励
function SecretaryModel:request_login_award_list(  )
	WelfareModel:request_login_award_list(  )
end

-- 请求斗法台数据
function SecretaryModel:request_doufatai_date(  )
	DouFaTaiCC:req_get_info()      -- 请求斗法台数据
end

-- 跳到美女助手界面   
function SecretaryModel:open_activity_page( page_index )
	-- ActivityWin:win_change_page( page_index )
	SecretaryWin:win_change_page(page_index)
end

-- 跳到每日必玩界面
function SecretaryModel:open_dailywillplay_page( page_index )
	ActivityWin:win_change_page( page_index )
end

--  请求 欢乐护送  斩妖除魔 银两 仙宗任务 次数
function SecretaryModel:request_HZYX_count(  )
	MiscCC:request_HZYX_count(  )
end

-- 设置 欢乐护送  斩妖除魔 银两 仙宗任务 次数
function SecretaryModel:set_HZYX_count( huanle_count, zhanyao_count, yinliang_count, xianzong_count )
	_huanle_count = huanle_count
	_zhanyao_count = zhanyao_count
	_yinliang_count = yinliang_count
	_xianzong_count = xianzong_count

	SecretaryModel:update_win( "HZYX_count" )
end

-- 获取欢乐护送剩余次数
function SecretaryModel:get_huanle_count(  )
	return _huanle_count
end

-- 获取斩妖除魔剩余次数
function SecretaryModel:get_zhanyao_count(  )
	return _zhanyao_count
end

-- 获取银两任务剩余次数
function SecretaryModel:get_yinliang_count(  )
	return _yinliang_count
end

-- 获取仙宗任务剩余次数
function SecretaryModel:get_xianzong_count(  )
	-- print("_xianzong_count )", _xianzong_count)
	return _xianzong_count
end

function SecretaryModel:set_zycm_count( zhanyao_count )
	_zhanyao_count = zhanyao_count
end