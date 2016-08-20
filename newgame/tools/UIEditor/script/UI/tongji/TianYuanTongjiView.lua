-- TianYuanTongjiView.lua
-- created by fjh on 2013-3-8
-- 天元之战统计视图

super_class.TianYuanTongjiView(Window)

local c3_yellow = "#cffff00";

function TianYuanTongjiView:destroy(  )
	if self.boss_timer_lab then
		self.boss_timer_lab:stop_timer();
	end
	Window.destroy(self);
end

function TianYuanTongjiView:update( fbId, data )
	
	if self.xianzong_score_value == nil then 
		
		return;
	end
	
	--仙宗积分
	self.xianzong_score_value:setText(tostring(data[2]));
	--仙宗排名
	self.xianzong_rank_value:setText(tostring(data[1]));
	--个人积分
	self.person_score_value:setText(tostring(data[4]));
	--个人排名
	self.person_rank_value:setText(tostring(data[3]));

	--仙宗排行
	for i,item in ipairs(self.xianzong_rank_dict) do
		local rank_dict = data[6][i];
		local name="";
		local score="";
		if rank_dict ~= nil then
			name = rank_dict.name;
			score = rank_dict.score;
		end

		local name_lab = item[1];
		local score_lab = item[2];
		name_lab:setText(c3_yellow..name);
		score_lab:setText(c3_yellow..score);
	end

	--个人排行
	for i,item in ipairs(self.person_rank_dict) do
		local rank_dict = data[5][i];
		local name="";
		local score="";
		if rank_dict ~= nil then
			name = rank_dict.name;
			score = rank_dict.score;
		end

		local name_lab = item[1];
		local score_lab = item[2];
		name_lab:setText(c3_yellow..name);
		score_lab:setText(c3_yellow..score); 
	end

	-- data[7]为boss出现的倒计时，0为boss已经出现，
	if data[7] == 0 then
		self.move_boss_btn.view:setIsVisible(true);

		if self.boss_timer_lab then
			self.boss_timer_lab:setIsVisible(false);
		end
		print("boss的坐标",self.boss_x,self.boss_y);
		self.boss_x = data[8];
		self.boss_y = data[9];
	else
		self.move_boss_btn.view:setIsVisible(false);
		
		if self.boss_timer_lab == nil then
			local function end_call(  )
				self.move_boss_btn.view:setIsVisible(true);
				self.boss_timer_lab:setIsVisible(false);
			end
			self.boss_timer_lab = TimerLabel:create_label(self.view, 140, 317-11, 14, data[7], "#cffff00", end_call, false, ALIGN_LEFT);
		else
			self.boss_timer_lab:setIsVisible(true);
			self.boss_timer_lab:setText(data[7]);
		end
	end

end

local _y = 15;

function TianYuanTongjiView:__init( )
	
	if self.data == nil then
		return;
	end

	self.view:setTexture(UILH_COMMON.m_mini_task_bg);
 	
 	-- 暗夜天魔
 	local boss_lab = UILabel:create_lable_2(c3_yellow..Lang.tianyuan[1], 5, 321-_y, 14, ALIGN_LEFT); -- [2079]="暗夜天魔:"
	self.view:addChild(boss_lab);
	-- 寻路按钮
	self.move_boss_btn = TextButton:create(nil, 80+5+60, 312-10-_y, 96, 43, Lang.tianyuan[2], {UILH_COMMON.lh_button2,UILH_COMMON.lh_button2}); -- [2080]="寻路"
	self:addChild(self.move_boss_btn.view);
	self.boss_x = 0;
	self.boss_y = 0;
	local function move_func( )
		if self.boss_x ~= 0 or self.boss_y ~= 0 then
			print("boss的坐标",self.boss_x,self.boss_y);
			-- GlobalFunc:move_to_target_scene( SceneManager:get_cur_scene(), self.boss_x * 32, self.boss_y * 32);
			AIManager:auto_kill_monster_by_pos( self.boss_x,self.boss_y )
		end
	end
	self.move_boss_btn:setTouchClickFun(move_func);
	self.move_boss_btn.view:setIsVisible(false);

	--仙宗积分
	local xianzong_score_lab = UILabel:create_lable_2(c3_yellow..Lang.tianyuan[3], 5, 297-_y, 14, ALIGN_LEFT); -- [2081]="仙宗积分:"
	self.view:addChild(xianzong_score_lab);
	self.xianzong_score_value = UILabel:create_lable_2(tostring(self.data[2]), 80, 313-16-_y, 14, ALIGN_LEFT);
	self.view:addChild(self.xianzong_score_value);

	--仙宗排名
	local xianzong_rank_lab = UILabel:create_lable_2(c3_yellow..Lang.tianyuan[4], 5, 297-20-_y, 14, ALIGN_LEFT); -- [2082]="仙宗排名:"
	self.view:addChild(xianzong_rank_lab);
	self.xianzong_rank_value = UILabel:create_lable_2(tostring(self.data[1]), 80, 297-20-_y, 14, ALIGN_LEFT);
	self.view:addChild(self.xianzong_rank_value);

	--个人积分
	local person_score_lab = UILabel:create_lable_2(c3_yellow..Lang.tianyuan[5], 5, 297-20*2-_y, 14, ALIGN_LEFT); -- [2083]="个人积分:"
	self.view:addChild(person_score_lab);
	self.person_score_value = UILabel:create_lable_2(tostring(self.data[4]), 80, 297-20*2-_y, 14, ALIGN_LEFT);
	self.view:addChild(self.person_score_value);

	--个人排名
	local person_rank_lab = UILabel:create_lable_2(c3_yellow..Lang.tianyuan[6], 5, 297-20*3-_y, 14, ALIGN_LEFT); -- [2084]="个人排名:"
	self.view:addChild(person_rank_lab);
	self.person_rank_value = UILabel:create_lable_2(tostring(self.data[3]), 80, 297-20*3-_y, 14, ALIGN_LEFT);
	self.view:addChild(self.person_rank_value);

	--仙宗积分前3名
	local xianzong = UILabel:create_lable_2(Lang.tianyuan[7], 12, 297-20*4-_y, 14, ALIGN_LEFT); -- [2085]="仙宗积分前3名"
	self.view:addChild(xianzong);

	self.xianzong_rank_dict = {};
	for i=1,3 do
		local rank_dict = self.data[6][i];
		local name="";
		local score="";
		if rank_dict ~= nil then
			name = rank_dict.name;
			score = rank_dict.score;
		end

		local rank = UILabel:create_lable_2(tostring(i), 5, 297-20*(4+i)-_y, 14, ALIGN_LEFT);
		self.view:addChild(rank);
		local name = UILabel:create_lable_2(c3_yellow..name, 150/2-10, 297-20*(4+i)-_y, 14, ALIGN_CENTER);
		self.view:addChild(name);
		local score = UILabel:create_lable_2(c3_yellow..score, 150-20, 297-20*(4+i)-_y, 12, ALIGN_CENTER);
		self.view:addChild(score);
		self.xianzong_rank_dict[i]={name,score};
	end

	--个人积分前3名
	local person = UILabel:create_lable_2(Lang.tianyuan[8], 12, 297-20*8-_y, 14, ALIGN_LEFT); -- [2086]="个人积分前3名"
	self.view:addChild(person);

	self.person_rank_dict = {};	
	for i=1,3 do
		local rank_dict = self.data[5][i];
		local name="";
		local score="";
		if rank_dict ~= nil then

			name = rank_dict.name;
			score = rank_dict.score;
		end
		local rank = UILabel:create_lable_2(tostring(i), 5, 297-20*(8+i)-_y, 14, ALIGN_LEFT);
		self.view:addChild(rank);
		local name = UILabel:create_lable_2(c3_yellow..name, 150/2-10, 297-20*(8+i)-_y, 14, ALIGN_CENTER);
		self.view:addChild(name);
		local score = UILabel:create_lable_2(c3_yellow..score, 150-20, 297-20*(8+i)-_y, 12, ALIGN_CENTER);
		self.view:addChild(score);
		self.person_rank_dict[i]={name,score};

	end

	--提示
 
	local tip = MUtils:create_ccdialogEx(self.view,Lang.tianyuan[9],5,26-16-_y,160,60,10,14); -- [2087]="提示:协助仙宗人员击杀暗夜天魔将获得20点个人积分。"

end

function TianYuanTongjiView:create( data )
	
	self.data = data;
	return TianYuanTongjiView("TianYuanTongjiView","", true, 150, 330);

end
