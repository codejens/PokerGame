-- QuestionActivityModel.lua
-- created by fjh on 2013-7-15
-- 答题活动

QuestionActivityModel = {};

local _question_model = nil;
local _question_activty_start = false; --答题活动开始了

local _commit_answer = 0; 		--之前提交过的答案
local _jion_times = 1;			--剩余参加答题活动的次数
local timer_lab = nil
function QuestionActivityModel:set_timer_lab( lab )
	timer_lab = lab
end

function  QuestionActivityModel:get_timer_lab( )
	if timer_lab then
		return timer_lab
	end
	return nil
end

function QuestionActivityModel:fini(  )
	_question_model = nil;
	_question_activty_start = false;
	_commit_answer = 0;
	_jion_times = 1;
end


function QuestionActivityModel:get_model(  )
	return _question_model;
end


function QuestionActivityModel:set_jion_times( times )
	_jion_times = times;
end

function QuestionActivityModel:get_jion_times( )
	return _jion_times;
end

function QuestionActivityModel:set_start_status( bool )
	_question_activty_start = bool;
end
function QuestionActivityModel:get_start_status(  )
	return _question_activty_start;
end
--------------------
-- 活动结束
function QuestionActivityModel:activity_over(  )
	UIManager:destroy_window( "question_win" );
	QuestionActivityModel:set_start_status( false );
end

-------------------网络协议
-- 请求答题面板所有的信息
function QuestionActivityModel:req_all_question_info(  )
	print("请求答题面板所有的信息")
	QuestionCC:req_all_question_info(  )
end
-- 下发答题面板所有的信息
function QuestionActivityModel:do_all_question_info( data )
	_question_model = data;

	local win = UIManager:find_visible_window("question_win");
	if win then
		print("下发答题面板所有的信息")
		win:update(data);
	end

end

-- 提交答案
function QuestionActivityModel:req_commit_answer( answer )
	_commit_answer = answer;
	QuestionCC:req_commit_answer( answer )
end

-- 使用协助功能
function QuestionActivityModel:req_use_assistant_system( index )
	-- index
	-- 1:勾选最多人选项
	-- 2:去除两个错误选项
	-- 3:勾选正确项

	QuestionCC:req_use_assistant_system( index )

end
-- 使用协助功能的回调
function QuestionActivityModel:do_use_assistant_system( data )
	-- type
	-- 1:勾选最多人选项
	-- 2:去除两个错误选项
	-- 3:勾选正确项
	local win = UIManager:find_visible_window("question_win");
	if win then
		if data.type == 1 then
			--
			win:selected_answer_btn(data.num_1);
		elseif data.type == 2 then
			win:remove_double_fail_answer( data.num_1, data.num_2 );
		elseif data.type == 3 then
			win:selected_answer_btn(data.num_1);
		end

	end
end

-- 答题过渡倒计时
function QuestionActivityModel:do_show_correct_answer( time, answer )
	print("答题过渡倒计时", time, answer);
	-- 过渡倒计时
	local time = time;
	--正确答案
	
	local win = UIManager:find_visible_window("question_win");
	if win then
		if answer == _commit_answer then
			--答对了

			win:set_transition_status( time, 0);
		else 
			--答错了
			win:set_transition_status( time, answer );
		end
	end
end

-- 告诉服务器离开答题活动
function QuestionActivityModel:req_leave_activity(  )
	--
	QuestionCC:req_leave_activity();

end