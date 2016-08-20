-- CampBattleWin.lua
-- created by fjh on 2013-2-26
-- 阵营战窗口
super_class.CampBattleWin(NormalStyleWindow)

local _battle_dict = {}		--战场
-- local _page_lab 	= nil		--页码lab
local _camp_num_lab = nil 		--战场lab
local _page_num 	= 1;		--总页数
local _current_page	= 1;		--当前页码

-- 是否是从活动界面打开的
local is_show_from_activityWin = false

function CampBattleWin:set_is_show_from_activityWin( boo )
    is_show_from_activityWin = boo
end

-- 关闭窗口事件
local function close_fun( eventType,x,y )
	--关闭事件
	if eventType == TOUCH_CLICK then
		 
		UIManager:hide_window("camp_win");
	end
	return true;
end

-- 绘制星星
-- local function draw_star( parent, x, y, num, color)
-- 	local img ;
-- 	if color == "yellow" then
-- 		img = UIResourcePath.FileLocate.normal .. "star_yellow.png";
-- 	elseif color == "blue" then
-- 		img = UIResourcePath.FileLocate.normal .. "star_blue.png";
-- 	end
-- 	for i=0,num-1 do
-- 		local star = CCZXImage:imageWithFile(x+i*16,y,16,16,img);
-- 		parent:addChild(star);
-- 	end
-- end

--
function update_battle_page( current_camp, camp_num)
	print("update_battle_page( current_page, camp_num)",current_camp, camp_num)
	_camp_num_lab:setText( string.format("战场(%d/%d)",current_camp,camp_num) );
	local battle_info = CampBattleModel:get_battle_info();
	if battle_info == nil then
		return ;
	end
	_battle_id = current_camp
	for i,v in ipairs(battle_info[current_camp]) do
		local lab = _battle_dict[i];
		lab:setText(string.format("(%d/80)",v));
	end

	-- for i,battle_page in ipairs(_battle_dict) do
	-- 	local num = i+2*(current_camp-1);
	-- 	--如果战场数是单数，则第二页不需要显示
	-- 	-- print("num,#battle_info",num,#battle_info)
	-- 	if i == 2 and num > #battle_info then
	-- 		battle_page:setIsVisible(false);
	-- 		break;
	-- 	end
	-- 	--@campcreate
	-- 	battle_page:setIsVisible(true);
	-- 	print("battle_page:set_num(num)",num)
	-- 	battle_page:set_num(num);				--设置战场id
	-- 	battle_page:update(battle_info[num]);	--更新战场数据
	-- end
end 

--左翻按钮事件
function left_btn_event( eventType,x,y )
	
	if eventType == TOUCH_CLICK then
		--如果当前页码大于1
		if _current_page > 1 then
			_current_page = _current_page-1;
			update_battle_page(_current_page,_page_num);
		end 
	end
	return true;
end
--右翻按钮事件
function right_btn_event( eventType,x,y )
	
	if eventType == TOUCH_CLICK then
		--如果当前页码小于总页数
		if _current_page < _page_num then
			_current_page = _current_page+1;
			update_battle_page(_current_page,_page_num);
		end
	end
	return true;
end


-- 销毁
function CampBattleWin:destroy( )
	Window.destroy(self);
	-- for i,v in ipairs(_battle_dict) do
	-- 	v:destroy(); 	
	-- end
end

-- 初始化
function CampBattleWin:__init(window_name,window_info  )
	-- 关闭按钮
    -- local function close_but_CB( )
    --     self:close()
    --     if is_show_from_activityWin == true then
	   --      UIManager:show_window("activity_Win")
	   --      is_show_from_activityWin = false
	   --  end
    -- end
	-- self.exit_btn:setTouchClickFun(close_but_CB)

-- add after tjxs
	_battle_id = 1;

 	-- ZImage:create(self.view,UIPIC_GRID_nine_grid_bg3,7,8,374,380,0,500,500);
 	local bg = ZBasePanel.new( UILH_COMMON.bg_grid, 400, 370)
	bg:setPosition(10, 10)
	self:addChild(bg)

	-- bg = ZBasePanel.new("", 374, 506+20)
	-- bg:setPosition(30+12, 20+12)
	-- self:addChild(bg)

    --底图
    local camp_bg = CCZXImage:imageWithFile(23, 157,374,211, "nopack/MiniMap/zyz.jpg" );
	self:addChild(camp_bg);

	--战场页
	
	-- for i=1,2 do
	-- 	local battle_page = BattlePage:create();
	-- 	battle_page:setPosition(50+(i-1)*178, 320+20)
	-- 	battle_page:set_num(i);
	-- 	self:addChild(battle_page.view);
	-- 	_battle_dict[i] = battle_page;
		
	-- 	battle_page:setIsVisible(false);
		
	-- end

	--翻页按钮
	local left_btn = CCNGBtnMulTex:buttonWithFile(29, 100, -1, -1, UILH_COMMON.page)
  	-- left_btn:addTexWithFile(CLICK_STATE_DOWN,"ui/common/right_arrow_s.png")
  	-- left_btn:setFlipX(true);
	left_btn:registerScriptHandler(left_btn_event);
    self:addChild(left_btn)

    local right_btn = CCNGBtnMulTex:buttonWithFile(335, 100, -1, -1, UILH_COMMON.page)
  	-- right_btn:addTexWithFile(CLICK_STATE_DOWN,UIResourcePath.FileLocate.common .. "right_arrow_s.png")
	right_btn:registerScriptHandler(right_btn_event);
	right_btn:setFlipX(true)
    self:addChild(right_btn)
    --页码
    _camp_num_lab = UILabel:create_lable_2("战场(1/1)", 213, 135, 16, ALIGN_CENTER);
	self:addChild(_camp_num_lab);

	--分割线
	-- local line = CCZXImage:imageWithFile(0,184-10,409,4,UIResourcePath.FileLocate.common .. "camp_line.png");
	-- self:addChild(line);
	local line_up = ZImage.new( UILH_COMMON.split_line )
	line_up:setPosition(30, 152)
	line_up:setSize(364, 3)
	self:addChild(line_up)

	-- 显示战场阵营数量
	self.three_camp = CCBasePanel:panelWithFile( 88, 90, 247, 41,nil);
	self:addChild(self.three_camp)

	_battle_dict = {};
	local shenwu_camp = UILabel:create_lable_2(Lang.camp_info[1], 21, 26, 14, ALIGN_LEFT);
	self.three_camp:addChild(shenwu_camp);
	local shenwu_count = UILabel:create_lable_2("(0/80)", 14, 7, 14, ALIGN_LEFT);
	self.three_camp:addChild(shenwu_count);
	_battle_dict[1] = shenwu_count;

	local tianji_camp = UILabel:create_lable_2(Lang.camp_info[2], 108, 26, 14, ALIGN_LEFT);
	self.three_camp:addChild(tianji_camp);
	local tianji_count = UILabel:create_lable_2("(0/80)", 98, 7, 14, ALIGN_LEFT);
	self.three_camp:addChild(tianji_count);
	_battle_dict[2] = tianji_count;

	local hongru_camp = UILabel:create_lable_2(Lang.camp_info[3], 188, 26, 14, ALIGN_LEFT);
	self.three_camp:addChild(hongru_camp);
	local hongru_count = UILabel:create_lable_2("(0/80)", 180, 7, 14, ALIGN_LEFT);
	self.three_camp:addChild(hongru_count);
	_battle_dict[3] = hongru_count;

	local line = ZImage.new( UILH_COMMON.split_line )
	line:setPosition(30, 85)
	line:setSize(364, 3)
	self:addChild(line)

	-- 活动说明
	-- local shuoming = ZImageImage:create(self.view,"ui/camp/camp_shuoming.png",UIResourcePath.FileLocate.common .. "quan_bg.png",389/2,157,368,-1,500,500)
	-- shuoming.view:setAnchorPoint(0.5,0.5)
	-- local lab_bg = CCZXImage:imageWithFile( 42,232+10, -1, -1,UIResourcePath.FileLocate.common .. "wzd-1.png",500,500);
	-- self:addChild(lab_bg);
	-- local battle_reward = CCZXImage:imageWithFile(24, 3, -1, -1,UIResourcePath.FileLocate.activity .. "2.png");
	-- lab_bg:addChild(battle_reward);

	--游戏规则
	-- local lab_bg = CCZXImage:imageWithFile(20,140+10,344,20,UIResourcePath.FileLocate.common .. "quan_bg.png",500,500);
	-- self:addChild(lab_bg);
	-- local game_role = CCZXImage:imageWithFile(107/2-74/2,19/2-16/2,74,16,UIResourcePath.FileLocate.camp .. "camp_lab2.png");
	-- lab_bg:addChild(game_role);
	
	-- --规则说明
	-- ZLabel:create(self.view,"#c35C3F7规则说明:",45, 140, 16,1);
	-- local role_desc = MUtils:create_ccdialogEx(self.view,LangGameString[681], 130, 118,280,40,3, 16); -- [681]="通过个人积分的#cff1493排名#cffffff,可以在阵营战结束后,领取丰厚的#cff1493阵营奖励."
	
	-- 战场时间
	-- local lab_bg = CCZXImage:imageWithFile(20,140-58+10,344,20,UIResourcePath.FileLocate.common .. "quan_bg.png",500,500);
	-- self:addChild(lab_bg);
	-- local battle_time = CCZXImage:imageWithFile(107/2-74/2,19/2-16/2,74,16,UIResourcePath.FileLocate.camp .. "camp_lab3.png");
	-- lab_bg:addChild(battle_time);
					ZLabel:create(self.view,"战场时间:", 105, 200, 16, 1);
					local time_desc = UILabel:create_lable_2(LangGameString[682], 105, 173, 16, ALIGN_LEFT); -- [682]="#c00ff00每周一、三、五晚上20:10~20:40"
					self:addChild(time_desc);

	--活动奖励
	-- local lab_bg = CCZXImage:imageWithFile(20,140-58-45+10,344,20,UIResourcePath.FileLocate.common .. "quan_bg.png",500,500);
	-- self:addChild(lab_bg);
	-- local battle_reward = CCZXImage:imageWithFile(107/2-74/2,19/2-16/2,74,16,UIResourcePath.FileLocate.camp .. "camp_lab1.png");
	-- lab_bg:addChild(battle_reward);
	--经验
	-- ZLabel:create(self.view,"#c35C3F7活动奖励:", 45, 200+10, 16, 1);
	-- local exp = UILabel:create_lable_2(LangGameString[683], 130, 200+10, 16, ALIGN_LEFT); -- [683]="#cff1493经验"
	-- self:addChild(exp);
	-- -- draw_star( self.view, 130+40, 200+10, 5, "yellow");
	-- local money = UILabel:create_lable_2(LangGameString[684], 130, 175, 16, ALIGN_LEFT); -- [684]="#cffff00仙币"
	-- self:addChild(money);
	-- draw_star( self.view, 130+40, 175, 3, "blue");


	local function req_enter_battle()
		CampBattleModel:req_enter_battle( _battle_id )
	end 

	--进入按钮
	local function enter_func()
		
		local cur_fb = SceneManager:get_cur_fuben();
		if cur_fb > 0 then
			GlobalFunc:create_screen_notic(LangGameString[2381]) -- [2381] = "副本内不能参加活动"
			return;
		end


		if _battle_id then
			local battle_info = CampBattleModel:get_battle_info( )
			-- for i=1,battle_info.battle_count do
			-- 	if i~= self.battle_id then
			-- 		local flag = Utils:get_bit_by_position(battle_info.enter_flag,i)
			-- 		if flag == 1 then
			-- 			has_enter = true
			-- 		end 
			-- 	end 	
			-- end 
			if battle_info.enter_flag ~=0 and battle_info.enter_flag ~= _battle_id then
				--进入过其他战场
				--LangGameString[2460]="进入别的战场会导致之前的战场积分清0。#r你确定进入新的战场么？"
				NormalDialog:show(LangGameString[2460], req_enter_battle, 1 )
			else
				req_enter_battle()
			end 

		end
	end
	self._right_bgn_role = ZTextButton:create( self, "进入战场", UILH_COMMON.btn4_nor, enter_func, 150, 26, -1, -1, 1)

end

function CampBattleWin:active( show )
	print("请求战场信息")
	--请求战场信息
	CampBattleModel:req_battle_info( );	
end

function CampBattleWin:update( data )
	print("---------data:", data)
	if #data > 0 then 
		-- _page_num = math.floor((#data-1)/2+1);
		_page_num = data.battle_count
		_current_page = 1;

		update_battle_page( _current_page, _page_num);
	end
end

