-- RefreshQuestConfig.lua
-- create by hcl on 2013-1-17
-- 刷星任务系统配置 

RefreshQuestConfig = {}

-- 取得刷星任务的奖励根据用户的等级
function RefreshQuestConfig:get_refresh_award_by_user_level( user_level ,refresh_type )
	require "../data/refresh_quests"
	local grades_table = refresh_quests[refresh_type].grades;
	local award_table = {};
	print( "#grades_table",#grades_table );
	for i=1,#grades_table do
		-- 从最后开始找起
		local grades_item = grades_table[#grades_table-i+1];
		-- 如果玩家等级满足任务的最小等级需求
		if ( user_level >= grades_item.miniLevel ) then
			local star_levels_table = grades_item.starLevels;
			for i=1,#star_levels_table do

				print("------------------i:",star_levels_table, i , star_levels_table[i][1], QuestConfig:get_quest_by_id( star_levels_table[i][1] ))
				local quest_info_awards_table = QuestConfig:get_quest_by_id( star_levels_table[i][1] ).awards;
				print("-----------------quest_info_awards_table:", quest_info_awards_table, #quest_info_awards_table)
				for i=1,#quest_info_awards_table do
					table.insert( award_table,quest_info_awards_table[i].count );  
				end
			end
			return award_table;
		end
	end
	return nil;
end 
