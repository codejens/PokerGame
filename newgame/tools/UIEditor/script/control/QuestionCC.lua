-- QuestionCC.lua
-- created by fjh on 2013-7-15
-- 答题系统

QuestionCC = {};

-- c->s 141,1
-- 请求答题面板所有数据
function QuestionCC:req_all_question_info(  )
	local pack = NetManager:get_socket():alloc(141, 1)
	NetManager:get_socket():SendToSrv(pack)
end

-- s->c 141,1
function QuestionCC:do_all_question_info( pack )
	
	local question_id = pack:readInt();		--题目id
	local time = pack:readInt();				--答题剩余时间
	local question_count = pack:readByte();	--剩余题目数量

	-- 协助系统
	local assistant_1_count = pack:readInt(); --协助系统1:自动勾选最多人项
	local assistant_2_count = pack:readInt(); --2:系统去除两个错误答案
	local assistant_3_count = pack:readInt(); --3:系统自动勾选正确答案
	--排行榜
	local rank_count = pack:readByte();
	local rank_dict = {};
	for i=1,rank_count do
		
		local name_ = pack:readString();		--玩家名字

		local score_ = pack:readInt();			--玩家积分
		rank_dict[i] = { name = name_, score = score_ };

	end
	

	local self_score = pack:readInt();				--我的积分
	local self_rank = pack:readByte();				--我的排名
	local answer_correct_count = pack:readByte();	--答对题目数
	local answer_fail_count = pack:readByte();  		--答错题目数
	local self_answer = pack:readChar();				--如果这道题已经做出了回答，这下发这个答案，并锁定不允许玩家再答
	
	local data = {id = question_id, time=time, count = question_count, ass_1 = assistant_1_count,
					ass_2 = assistant_2_count, ass_3 = assistant_3_count, rank = rank_dict, score = self_score,
					self_rank = self_rank, correct_count = answer_correct_count, fail_count = answer_fail_count,
					self_answer = self_answer};


	QuestionActivityModel:do_all_question_info( data )

end

-- c->s 141,2
-- 提交答案
function QuestionCC:req_commit_answer( answer )
	print("提交答案", answer);
	local pack = NetManager:get_socket():alloc(141, 2)
	pack:writeChar(answer);
	NetManager:get_socket():SendToSrv(pack)
end

-- s->c 141,2 
function QuestionCC:do_commit_answer( pack )
	
end

-- c->s 141,3
-- 使用协助系统
function QuestionCC:req_use_assistant_system( index )
	-- print("使用协助系统",index);
	local pack = NetManager:get_socket():alloc(141, 3)
	pack:writeChar(index);
	NetManager:get_socket():SendToSrv(pack)

end

-- s->c 141,3
function QuestionCC:do_use_assistant_system( pack )
	
	local type = pack:readChar();
	local num_1 = pack:readInt();
	local num_2 = pack:readInt();
	
	print("协助功能生效",type,num_1,num_2);

	local type = type;
	local num_1 = num_1;
	local num_2 = num_2;
	local data = {type = type,num_1 = num_1, num_2 = num_2};
	QuestionActivityModel:do_use_assistant_system( data )

end

-- s->c 141,4 
-- 服务器下发正确答案
function QuestionCC:do_show_correct_answer( pack )
	
	local time = pack:readInt();
	local correct_answer = pack:readInt();

	QuestionActivityModel:do_show_correct_answer( time, correct_answer )

end

-- c->s 141,4
-- 客户端告诉服务器离开答题活动
function QuestionCC:req_leave_activity(  )

	local pack = NetManager:get_socket():alloc(141, 4)
	NetManager:get_socket():SendToSrv(pack)

end

-- c->s 141,5 
-- 询问服务器参加活动的次数
function QuestionCC:req_did_jion_activity_count(  )
	local pack = NetManager:get_socket():alloc(141, 5)
	NetManager:get_socket():SendToSrv(pack)
end

-- s->c, 141,5
-- 询问服务器参加活动的次数 返回
function QuestionCC:do_did_jion_activity_count( pack )


	local count = pack:readInt();
	print("询问服务器参加活动的次数 ",count);
	QuestionActivityModel:set_jion_times( count )
end
