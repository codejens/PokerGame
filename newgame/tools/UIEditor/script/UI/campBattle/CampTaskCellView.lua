-- CampTaskCellView.lua
-- created by fjh on 2013-7-8
-- 阵营战任务cell

super_class.CampTaskCellView()

CampTaskCellView.TASK_TYPE_1 = 1;
CampTaskCellView.TASK_TYPE_2 = 2;
CampTaskCellView.TASK_TYPE_3 = 3;

function CampTaskCellView:__init( x,y, type)
	
	self.type = type;

	self.view = CCBasePanel:panelWithFile( x, y,348,120 , UIResourcePath.FileLocate.other.."mall_sell_bg.png",500,500)

	self.title = UILabel:create_lable_2( LangGameString[685], 20, 96, 16, ALIGN_LEFT ); -- [685]="战神"
	self.view:addChild(self.title);

	self.desc = MUtils:create_ccdialogEx(self.view, LangGameString[686], 10, 91, 332, 25, 2, 14); -- [686]="战场上就应该立功杀敌，拿你的兵器为了阵营的荣耀！"
	self.desc:setAnchorPoint(0,1);

	self.task = UILabel:create_lable_2( LangGameString[687], 10, 95-44-20, 14, ALIGN_LEFT ); -- [687]="任务:击杀非本阵营玩家3名"
	self.view:addChild(self.task);

	self.award = UILabel:create_lable_2( LangGameString[688], 10, 95-44-20-22, 14, ALIGN_LEFT ); -- [688]="经验:xxxxxxxx"
	self.view:addChild(self.award);

	local function get_award_func(  )
		
		CampBattleModel:req_complete_battle_task( self.type );

	end
	
	self.get_award_btn = TextButton:create(nil, 348-81-10-25, 10, -1, -1, LangGameString[549], UIResourcePath.FileLocate.common.."tishi_button.png"); -- [549]="领取"
	self.get_award_btn:setTouchClickFun(get_award_func);
	self.get_award_btn.view:setCurState(CLICK_STATE_DISABLE);
	self.view:addChild(self.get_award_btn.view);

end

function CampTaskCellView:update( level, status)
	print("任务等级",level, status)
	local title, desc, task, exp;
	if self.type == CampTaskCellView.TASK_TYPE_1 then
		desc = LangGameString[686]; -- [686]="战场上就应该立功杀敌，拿你的兵器为了阵营的荣耀！"
		if level == 1 then
			title = LangGameString[685]; -- [685]="战神"
			task = LangGameString[689]; -- [689]="任务: 击杀非本阵营玩家3名"
			exp = 30000;
		elseif level == 2 then
			title = LangGameString[690]; -- [690]="战神2"
			task = LangGameString[691]; -- [691]="任务: 击杀非本阵营玩家10名"
			exp = 60000;
		elseif level == 3 then
			title = LangGameString[692]; -- [692]="战神3"
			task = LangGameString[693]; -- [693]="任务: 击杀非本阵营玩家30名"
			exp = 100000;
		end
	elseif self.type == CampTaskCellView.TASK_TYPE_2 then
		desc = LangGameString[694]; -- [694]="阵营战中连斩可以极大增加我方士气，去吧。达成连斩鼓舞我方的士气吧！"
		if level == 1 then
			title = LangGameString[695]; -- [695]="连斩"
			task = LangGameString[696]; -- [696]="任务: 达成3连斩"
			exp = 60000;
		elseif level == 2 then
			title = LangGameString[697]; -- [697]="连斩2"
			task = LangGameString[698]; -- [698]="任务: 达成7连斩"
			exp = 100000;
		elseif level == 3 then
			title = LangGameString[699]; -- [699]="连斩3"
			task = LangGameString[700]; -- [700]="任务: 达成10连斩"
			exp = 200000;
		end
	elseif self.type == CampTaskCellView.TASK_TYPE_3 then
		desc = LangGameString[701]; -- [701]="战场上功勋是你实力的最好证明，去吧！获取更多的积分证明你的实力吧！"
		if level == 1 then
			title = LangGameString[702]; -- [702]="功勋"
			task = LangGameString[703]; -- [703]="任务: 累计获取100积分"
			exp = 30000;
		elseif level == 2 then
			title = LangGameString[704]; -- [704]="功勋2"
			task = LangGameString[705]; -- [705]="任务: 累计获取300积分"
			exp = 60000;
		elseif level == 3 then
			title = LangGameString[706]; -- [706]="功勋3"
			task = LangGameString[707]; -- [707]="任务: 累计获取500积分"
			exp = 100000;
		end
	end

	self.title:setText(title);
	self.desc:setText(desc);
	self.task:setText(task);
	self.award:setText(LangGameString[708]..exp); -- [708]="经验:"

	if status == 0 then
		self.get_award_btn.view:setCurState(CLICK_STATE_DISABLE);
	elseif status == 1 then
		self.get_award_btn.view:setCurState(CLICK_STATE_UP);
	elseif status == 2 then
		--是该任务已全部完成
		self.get_award_btn.view:setIsVisible(false);
	end

end
