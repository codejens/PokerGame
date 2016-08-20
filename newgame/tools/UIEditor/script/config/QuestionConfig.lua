-- QuestionConfig.lua
-- created by fjh on 2013-7-19
-- 答题活动配置

QuestionConfig = {}

-- function QuestionConfig:get_question_config_by_id( question_id )
-- 	require "../data/question_DB"

-- 	return question_DB[question_id];

-- end

function QuestionConfig:get_question_config_by_id( question_id )
	
	require "../data/question"
	local question = question_db[tostring(question_id)];
	return question;
end