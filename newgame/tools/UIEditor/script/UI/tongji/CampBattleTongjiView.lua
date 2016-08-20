-- CampBattleTongjiView.lua
-- created by fjh on 2013-2-25
-- 阵营战统计视图

super_class.CampBattleTongjiView(Window)
local c3_yellow = "#cffff00";

---------utils func
local function get_color_by_camp_id( camp_id )
	
	if camp_id == 1 then
		return "#cff1493";
	elseif  camp_id == 2 then
		return "#c0000ff";
	else
		return "#c00ff00";
	end

end

----------------------------------
--更新联盟状态
function CampBattleTongjiView:update_league_status( data )
	for i,v in ipairs(data) do
		
		local league = self.league_dict[i];
		print("联盟状态:",v,"count",self.league_dict[i]);
		if v == 1 then
			league:setText(c3_yellow..LangGameString[2068]) -- [2068]="(盟)"
		else
			league:setText("");
		end
	end
end

--更新面板数据
function CampBattleTongjiView:update(fbId, data )
	if fbId == 59 then
		--排名
		self.rank_value:setText(c3_yellow..tostring(data[5]));
		--积分
		self.scroe_value:setText(c3_yellow..tostring(data[6]));
		--击杀
		self.kill_value:setText(c3_yellow..tostring(data[7]));
		--连斩
		self.multiKill_value:setText(c3_yellow..tostring(data[9]));
		--助攻
		self.assists_value:setText(c3_yellow..tostring(data[8]));

		--逍遥
		self.xiaoyao_score:setText(tostring(data[2]));
		--星辰
		self.xingchen_score:setText(tostring(data[3]));
		--逸仙
		self.yixian_score:setText(tostring(data[4]));

		--排行榜
		
		local rank_data = data[10];
		for i=1,3 do
			local name = self.rank_dict[i][1];
			name:setText(rank_data[i][2]);
			local score = self.rank_dict[i][2];
			score:setText(rank_data[i][3]);
		end


	end
end

function CampBattleTongjiView:__init(  )
	
	if self.data == nil then
		return;
	end
 		
 	-- self.view:setTexture(UILH_COMMON.bg_06);

 	--军令状按钮
 	-- local btn = TextButton:create(nil, 5, 215-25, 65, 25, LangGameString[2069], UIResourcePath.FileLocate.common .. "button2.png"); -- [2069]="军令状"
  --   local function open_camp_task_win(  )
  --       UIManager:show_window("camp_task_win");
  --   end
  --   btn:setTouchClickFun(open_camp_task_win);
  --   self.view:addChild(btn.view);

    local y = 0;
    local font_size = 16
    local start_lab_x = 5
    local start_value_x = 50
    local interval_x = 70
    local interval_y =22
    local window_height=280

	--排名
	local rank_lab = UILabel:create_lable_2(c3_yellow..LangGameString[2070], start_lab_x + interval_x*0, window_height-interval_y*1 +y, font_size, ALIGN_LEFT); -- [2070]="排名: "
	self.view:addChild(rank_lab);
	self.rank_value = UILabel:create_lable_2(c3_yellow..tostring(self.data[5]), start_value_x+ interval_x*0, window_height-interval_y*1+y, font_size, ALIGN_LEFT);
	self.view:addChild(self.rank_value);
	--积分
	local score_lab = UILabel:create_lable_2(c3_yellow..LangGameString[2071], start_lab_x + interval_x*1, window_height-interval_y*1+y, font_size, ALIGN_LEFT); -- [2071]="积分: "
	self.view:addChild(score_lab);
	self.scroe_value = UILabel:create_lable_2(c3_yellow..tostring(self.data[6]), start_value_x+ interval_x*1, window_height-interval_y*1+y, font_size, ALIGN_LEFT);
	self.view:addChild(self.scroe_value);
	--击杀
	local kill_lab = UILabel:create_lable_2(c3_yellow..LangGameString[2072], start_lab_x + interval_x*0, window_height-interval_y*2 +y, font_size, ALIGN_LEFT); -- [2072]="击杀: "
	self.view:addChild(kill_lab);
	self.kill_value = UILabel:create_lable_2(c3_yellow..tostring(self.data[7]), start_value_x+ interval_x*0, window_height-interval_y*2 +y, font_size, ALIGN_LEFT);
	self.view:addChild(self.kill_value);
	--连斩
	local multiKill_lab = UILabel:create_lable_2(c3_yellow..LangGameString[2073], start_lab_x + interval_x*1,window_height-interval_y*2 +y, font_size, ALIGN_LEFT); -- [2073]="连杀: "
	self.view:addChild(multiKill_lab);
	self.multiKill_value = UILabel:create_lable_2(c3_yellow..tostring(self.data[8]),start_value_x+ interval_x*1, window_height-interval_y*2 +y, font_size, ALIGN_LEFT);
	self.view:addChild(self.multiKill_value);
	--助攻
	local assists_lab = UILabel:create_lable_2(c3_yellow..LangGameString[2074], start_lab_x + interval_x*0, window_height-interval_y*3 +y, font_size, ALIGN_LEFT); -- [2074]="助攻: "
	self.view:addChild(assists_lab);
	self.assists_value = UILabel:create_lable_2(c3_yellow..tostring(self.data[9]), start_value_x+ interval_x*0, window_height-interval_y*3 +y, font_size, ALIGN_LEFT);
	self.view:addChild(self.assists_value);

	--3个阵营
	--require "language/CN/Lang"
	--联盟信息
	self.league_dict = {};
	--逍遥
	local xiaoyao_camp = UILabel:create_lable_2(Lang.camp_info[1]..LangGameString[2075], 5, window_height-interval_y*4+y, font_size, ALIGN_LEFT); -- [2075]="#cffffff积分: "
	self.view:addChild(xiaoyao_camp);
	
	self.xiaoyao_score = UILabel:create_lable_2(tostring(self.data[2]), 126, window_height-interval_y*4+y, font_size, ALIGN_LEFT);
	self.view:addChild(self.xiaoyao_score);
	
	local xiaoyao_league = UILabel:create_lable_2(c3_yellow..LangGameString[2068],165,window_height-interval_y*4+y, font_size, ALIGN_LEFT); -- [2068]="(盟)"
	self.view:addChild(xiaoyao_league);
	self.league_dict[1] = xiaoyao_league;
	--星辰
	local xingchen_camp = UILabel:create_lable_2(Lang.camp_info[2]..LangGameString[2075], 5, window_height-interval_y*5+y, font_size, ALIGN_LEFT); -- [2075]="#cffffff积分: "
	self.view:addChild(xingchen_camp);
	
	self.xingchen_score = UILabel:create_lable_2(tostring(self.data[3]), 126, window_height-interval_y*5+y,font_size, ALIGN_LEFT);
	self.view:addChild(self.xingchen_score);
	
	local xingchen_league = UILabel:create_lable_2(c3_yellow..LangGameString[2068], 165,window_height-interval_y*5+y, font_size, ALIGN_LEFT); -- [2068]="(盟)"
	self.view:addChild(xingchen_league);
	self.league_dict[2] = xingchen_league;
	--逸仙
	local yixian_camp = UILabel:create_lable_2(Lang.camp_info[3]..LangGameString[2075], 5, window_height-interval_y*6+y, font_size, ALIGN_LEFT); -- [2075]="#cffffff积分: "
	self.view:addChild(yixian_camp);
	
	self.yixian_score = UILabel:create_lable_2(tostring(self.data[4]), 126, window_height-interval_y*6+y, font_size, ALIGN_LEFT);
	self.view:addChild(self.yixian_score);
	
	local yixian_league = UILabel:create_lable_2(c3_yellow..LangGameString[2068], 165, window_height-interval_y*6+y, font_size, ALIGN_LEFT); -- [2068]="(盟)"
	self.view:addChild(yixian_league);
	self.league_dict[3] = yixian_league;
	
	--排行榜
	local title_lab = UILabel:create_lable_2(LangGameString[2076], 20, window_height-interval_y*7+y, font_size, ALIGN_LEFT); -- [2076]="个人积分前三名"
	self.view:addChild(title_lab);
	local title_lab_1 = UILabel:create_lable_2(LangGameString[2077], 0, window_height-interval_y*8+y, font_size, ALIGN_LEFT);
	 -- [2077]="排名   名字    积分"
	self.view:addChild(title_lab_1);

	self.rank_dict = {};
	local rank_data = self.data[10];
	for i=1,3 do
		local rank = UILabel:create_lable_2(tostring(i), 14, window_height-interval_y*(8+i)+y, font_size, ALIGN_LEFT);
		self.view:addChild(rank);
		local name = UILabel:create_lable_2(get_color_by_camp_id(rank_data[i][1])..tostring(rank_data[i][2]), 85, window_height-interval_y*(8+i)+y,font_size, ALIGN_CENTER);
		self.view:addChild(name);
		local score = UILabel:create_lable_2(tostring(rank_data[i][3]), 158, window_height-interval_y*(8+i)+y, font_size, ALIGN_CENTER);
		self.view:addChild(score);
		self.rank_dict[i]={name,score};

	end
 
	local league_data = FubenTongjiModel:get_league_data();
	if league_data ~= nil then
		self:update_league_status( league_data );
	end
end


function CampBattleTongjiView:create( data  )
	self.data = data;
	self.content_height = 280
	return CampBattleTongjiView("CampBattleTongjiView","", true, 150, 280);
end
