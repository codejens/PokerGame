-- QianDaoModel.lua
-- create by hcl on 2013-5-21
-- 签到

super_class.QianDaoModel()

-- 每日签到的已签数据
local qd_info = {};
-- 每日签到的当月奖励领取情况
local qd_award_info = {};
local is_request_qian_dao = false
-- 保存带有补签标志的按钮
local buquan_btns = {}

-- added by aXing on 2013-5-25
function QianDaoModel:fini( ... )
	qd_info = {};
	qd_award_info = {};
	is_request_qian_dao = false
end

function QianDaoModel:set_request_qian_dao(result)
	is_request_qian_dao = result
end

function QianDaoModel:get_request_qian_dao()
	return is_request_qian_dao
end
	
-- 设置签到信息
function QianDaoModel:set_qd_info( _qd_info)
	qd_info = _qd_info;

	-- 通知小秘书
	SecretaryModel:update_win( "qiandao" )
	---HJH seven day award
	sevenDayAwardModel:qian_dao_award(qd_info.qd_days)





end

function QianDaoModel:get_qd_info()
	return qd_info;
end
-- 设置签到奖励
function QianDaoModel:set_qd_award_info( _qd_award_info)
	qd_award_info = _qd_award_info;
	if self:check_can_get_qd_award() then
		BenefitModel:show_benefit_miniBtn()
	end
end

function QianDaoModel:get_qd_award_info()
	return qd_award_info;
end

-- 今天是否已补签
function QianDaoModel:get_if_replenish_qd_doday( )
	if qd_info.had_replenish_qd == 0 then
		return false
	elseif qd_info.had_replenish_qd == 1 then 
		return true
	end
end
-- 取得当月是否需要补签
function QianDaoModel:get_is_need_bq2(  )
	local current_date_table = MUtils:get_current_date(  );
	if qd_info.qd_days and current_date_table.day and ( current_date_table.day > qd_info.qd_days) then
		return true
	end
	return  false
end

-- 取得当月是否需要补签
function QianDaoModel:get_is_need_bq()
	if qd_info.had_replenish_qd == 0 then
        return true
    else
    	return false
	end
	-- local current_date_table = MUtils:get_current_date(  );
	-- -- 如果已经过去的天数大于签到的天数
	-- if qd_info.qd_days and current_date_table.day and ( current_date_table.day > qd_info.qd_days) then
	-- 	return true;
	-- end
	-- return false;
end

-- 自动补签
function QianDaoModel:auto_bq()
	for i=1,31 do
		if ( qd_info.qd_day_table[i] == nil ) then
			MiscCC:req_bq( i );
			return;
		end
	end
end

-- 今日是否签到
function QianDaoModel:is_today_qd()

	local current_date_table = MUtils:get_current_date(  );
	if ( qd_info.qd_day_table and qd_info.qd_day_table[current_date_table.day] ) then
		return true;
	end
	return false;
end

function QianDaoModel:get_buquan_btns( )
	return buquan_btns
end

local qd_day = {2,5,10,17,26};
-- 签到奖励的累计日期设置
function QianDaoModel:get_qd_day_cfg(  )
    return qd_day
end

--检查是否有奖励未领取

function QianDaoModel:check_can_get_qd_award()
	-- print("=====QianDaoModel:check_can_get_qd_award()======")
	local count = 0 
	for index=1,#qd_day do
		if qd_award_info[index] and qd_award_info[index] == 0 then
			 local qd_days = self:get_qd_info().qd_days;
	        -- 如果没达到签到数字按钮变暗
	        if ( qd_days >= self:get_qd_day_cfg()[index] ) then
                count =count + 1
	        end
        end
	end

	if count >0 then
		-- print("存在未领")
		return true
	else
		-- print("没有可领")

		return false
	end
end

