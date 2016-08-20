-- DouFaTaiWin.lua
-- create by hcl on 2013-1-10
-- 斗法台界面

super_class.DouFaTaiWin(NormalStyleWindow)

-- 左边距
local l_m = 19;
-- 下边距
local b_m = 39;

local update_view_right_bottom = {};

local basePanel = nil;

-- 增加挑战次数是否不再提示
local show_tip = true;
-- 清除cd时间是否不再提示
local clear_cd_tip = true;
--增加挑战次数消耗金币
local fight_need_yuanbao = 0;

-- 获取奖励的剩余时间
local _get_reward_time = 0;
-- 挑战失败后再次挑战的cd
local fight_cd = 0;
-- 今天的剩余挑战次数
local _fight_num = 0;


local function clearGlobals()
	update_view_right_bottom = {};

	basePanel = nil;

	-- 增加挑战次数是否不再提示
	show_tip = true;
	-- 清除cd时间是否不再提示
	clear_cd_tip = true;
	--增加挑战次数消耗金币
	fight_need_yuanbao = 0;

	-- 获取奖励的剩余时间
	_get_reward_time = 0;
	-- 挑战失败后再次挑战的cd
	fight_cd = 0;
	-- 今天的剩余挑战次数
	_fight_num = 0;
end

function DouFaTaiWin:show()
	require "model/GameSysModel"
	-- 是否开启斗法台系统
	if ( GameSysModel:isSysEnabled(GameSysModel.JJC,true) ) then
		UIManager:show_window("doufatai_win");
	end
	
end

-- UIManager使用来创建
-- function DouFaTaiWin:create( texture_name )
-- 	--local view = PetWin("ui/common/bg02.png",20,30,760,424);
--     local view = DouFaTaiWin(nil,l_m,b_m,760,424);
-- 	return view;
-- end

function DouFaTaiWin:__init( )
	require "control/DouFaTaiCC"

	--DouFaTaiCC:req_top_info(4);
	-- 请求玩家战绩信息
	DouFaTaiCC:req_get_zj_info();

    -- 空面板
    basePanel = self.view;

    -- 创建大背景
    local bg = CCZXImage:imageWithFile(8,4,884,566,UILH_COMMON.normal_bg_v2,500,500)
    self.view:addChild(bg)
    -- 右上方背景
    local right_top_bg = CCZXImage:imageWithFile(330, 192, 543, 363,UILH_COMMON.bottom_bg,500,500)
    self.view:addChild(right_top_bg)
    -- 右下方背景
    local right_bottom_bg = CCZXImage:imageWithFile(330, 24, 365, 166,UILH_COMMON.bottom_bg,500,500)
    self.view:addChild(right_bottom_bg)

    -- 左上角控件
    self:create_left_top();
    self:create_right_bottom();
    self.timer = timer(); 

    -- 
    self:create_left_panel(13, 13, 326, 560,nil);
    self:create_right_middle_panel(330, 195, 540, 245,nil);
    self:create_right_bottom_panel(330, 19, 540, 170,nil)
end

-- 左边的前三名形象
function DouFaTaiWin:create_left_panel(x, y, width, height,texture_path)
	self.left_panel = CCBasePanel:panelWithFile( x, y, width, height,texture_path)
	self.view:addChild(self.left_panel)	

	MUtils:create_zximg(self.left_panel,"nopack/BigImage/doufatai_bg.png",15,10,295,531,0,0)

	self.showAvatars = {}
	self.avatar_names = {}
	self.avatar_fight_values = {}
	local avatar_pos = {{165,373},{90,130},{240,80},}
	local rank_pos = {{47,425},{16,165},{162,96},}
	local bg_img = {UILH_NORMAL.bg_red,UILH_NORMAL.bg_green,UILH_NORMAL.bg_green}
	for i=1,3 do
		-- self.showAvatars[i] = ShowAvatar:create_user_panel_avatar( avatar_pos[i][1], avatar_pos[i][2],nil )
		-- self.showAvatars[i].avatar:setActionStept(ZX_ACTION_STEPT)
		-- self.showAvatars[i].avatar:playAction(ZX_ACTION_IDLE, 4, true)
		-- self.showAvatars[i].avatar:setScale( 1 )
		-- self.left_panel:addChild( self.showAvatars[i].avatar, 0 )
		-- -- 战斗力背景
		-- MUtils:create_zximg(self.showAvatars[i].avatar,bg_img[i],-100,-71,-1,-1)
		-- -- 排名图片
		MUtils:create_zximg(self.left_panel,UIResourcePath.FileLocate.lh_doufatai .. "rank" .. i .. ".png",rank_pos[i][1],rank_pos[i][2],-1,-1)
		-- -- 名字
		-- self.avatar_names[i] = CCZXLabel:labelWithText(0,-40,"", 18,ALIGN_CENTER);
		-- self.showAvatars[i].avatar:addChild(self.avatar_names[i])
		-- -- 战斗力图片和数字
		-- MUtils:create_zximg(self.showAvatars[i].avatar,UILH_DOUFATAI.zhanli,-70,-70,-1,-1)
	 --    local function get_num_ima( one_num )
	 --        return string.format("ui/lh_other/number1_%d.png",one_num);
	 --    end
	 --    self.avatar_fight_values[i] = ImageNumberEx:create(0,get_num_ima,12)
	 --    self.showAvatars[i].avatar:addChild( self.avatar_fight_values[i].view )
	 --    self.avatar_fight_values[i].view:setPosition(CCPointMake(-7,-59))		
	end
end

-- 右上，可挑战的对手
function DouFaTaiWin:create_right_middle_panel(x, y, width, height,texture_path)
	self.right_middle_panel = CCBasePanel:panelWithFile( x, y, width, height,texture_path)
	self.view:addChild(self.right_middle_panel)	

	self.challenger_panel = {} -- 面板
	self.challenger_fight = {}	-- 战斗力
	self.challenger_face_btn = {}	-- 头像按钮
	self.challenger_rank = {}	-- 排名
	self.challenger_name = {}	-- 名字
	self.challenger_level = {}	-- 等级
	for i=1,5 do
		self.challenger_panel[i] = CCBasePanel:panelWithFile(9+(i-1)*105,0,103,245, nil, 500,500)
		self.right_middle_panel:addChild(self.challenger_panel[i]);

		-- 分割线
		-- if i ~= 5 then
		-- 	MUtils:create_zximg(self.right_middle_panel,UILH_COMMON.split_line_v,115+(i-1)*105,6,3,178,0,0)
		-- end

		-- local size = self.challenger_panel[i]:getSize();
		-- local color_rect =  CCArcRect:arcRectWithColor(0, 0, size.width, size.height, 0xffffffff);
		-- self.challenger_panel[i]:addChild(color_rect);		

		local face_bg = MUtils:create_zximg(self.challenger_panel[i],UILH_NORMAL.skill_bg_b,5,245-95,-1,-1,0,0)

		local function func( eventType ,args,msg_id)
            if ( eventType == TOUCH_BEGAN ) then
                return true;
			elseif ( eventType == TOUCH_CLICK ) then
				-- 如果当前是在副本中或者护送状态下，则提示不能斗法台
				local player = EntityManager:get_player_avatar();
				if ( SceneManager:get_cur_fuben() > 0 or ZXLuaUtils:band(player.state, EntityConfig.ACTOR_STATE_PROTECTION) > 0 ) then
					GlobalFunc:create_screen_notic( LangGameString[870] ); -- [870]="副本、活动场景内无法打开斗法台"
				else
					local table = DFTModel:get_dft_info();
					local struct = table[i];
					if struct ~= nil then
						print( "斗法台挑战:对手id = ",struct.dft_id );
						DouFaTaiCC:req_start_pk( struct.dft_id );
						if ( fight_cd <= 0 and _fight_num > 0 ) then 
							-- 关闭界面
							UIManager:hide_window("doufatai_win");
							--开始pk，显示开始pk
							CountDownView:show( 3, 30 )
						elseif ( fight_cd > 0 ) then
							DouFaTaiWin:show_clear_cd_dialog();
						elseif ( _fight_num <=0 ) then
							DouFaTaiWin:show_add_fight_num_dialog();
						end
					end
				end
			end
			return true
		end
		-- 挑战按钮
        local btn_challenge = MUtils:create_btn(self.challenger_panel[i],UILH_COMMON.button4,UILH_COMMON.button4,func,13,5,-1,-1);
        MUtils:create_zxfont(btn_challenge, Lang.doufatai[31], 77/2, 12, 2, 16)   -- [31] = "#cd0cda2挑战",

		--对手名字
		local name_btn = MUtils:create_btn(self.challenger_panel[i], UILH_NORMAL.title_bg8, UILH_NORMAL.title_bg8, nil, 0, 123, 103, 25);
		self.challenger_name[i] = MUtils:create_zxfont(name_btn, "", 103/2+2, 5, 2, 16, 1)
		-- 排名
		MUtils:create_zxfont(self.challenger_panel[i],Lang.doufatai[32],10,75,1,15,999);
		--对手等级
		self.challenger_level[i] = MUtils:create_zxfont(self.challenger_panel[i],"",103/2,100,2,15,999);
		--对手战斗力
		self.challenger_fight[i] = MUtils:create_zxfont(self.challenger_panel[i],"",10,50,1,15,999);
	end
end

function DouFaTaiWin:create_right_bottom_panel(x, y, width, height,texture_path)
	self.right_bottom_panel = CCBasePanel:panelWithFile( x, y, width, height,texture_path)
	self.view:addChild(self.right_bottom_panel)	

	-- 显示玩家排名
	self.rank_lab = ZLabel:create(self.right_bottom_panel, string.format(Lang.doufatai[10],0), 20, height-35, 16, ALIGN_LEFT, 9999)
	-- 显示玩家战斗力 [34] = "#cd0cda2我的战力:#cffffff%d",
	local player = EntityManager:get_player_avatar();
	if player and player.fightValue then
		ZLabel:create(self.right_bottom_panel, string.format(Lang.doufatai[34],player.fightValue), 20, height-70, 16, ALIGN_LEFT, 9999)
	end
	-- 显示当前排名奖励 [35] = "#cd0cda2当前奖励：#cffffff%d铜币，%d声望",
	self.award_lab = ZLabel:create(self.right_bottom_panel, string.format(Lang.doufatai[35],0,0), 20, height-105, 16, ALIGN_LEFT, 9999)

	-- 排行榜按钮
	local function btn_rank_fun(  )
		DouFaTaiRank:show(DFTModel:get_dft_top_info())
	end
	ZImageButton:create(self.right_bottom_panel,UILH_NORMAL.special_btn,UILH_DOUFATAI.zhizunbang,btn_rank_fun,375, 17);

	-- 挑战历史按钮
	local function btn_history_fun(  )
		DouFaTaiHistory:show(DFTModel:get_dft_ZJ_info())
	end
	ZImageButton:create(self.right_bottom_panel,UILH_NORMAL.special_btn,UILH_DOUFATAI.tiaozhanlishi,btn_history_fun,375, 94);

end

local left_top_title = {LangGameString[859],LangGameString[860],Lang.doufatai[14],LangGameString[862],Lang.doufatai[15]}; -- [859]="#cfff000我的排名:" -- [860]="#cfff000我的声望:" -- [861]="#cfff000出战宠物:" -- [862]="#cfff000当前的排名奖励:" -- [863]="#cfff000领取时间:"
-- 左上，我的信息
function DouFaTaiWin:create_left_top()
	--我的声望
	-- self.renown_value = MUtils:create_zxfont(basePanel,"",409-l_m,549-b_m+50,1,14);

	--出战宠物
	self.fight_pet = MUtils:create_zxfont(basePanel,"",350,50,1,16);

	--“当前的排名奖励”文字图片
	-- MUtils:create_zxfont(basePanel,left_top_title[4],385,550,1,16);
	local dqpmjl = CCZXImage:imageWithFile( 376, 523, -1, -1, UILH_DOUFATAI.dangqianpaimingjiangli);
	basePanel:addChild(dqpmjl)
	local tongbi = CCZXImage:imageWithFile( 585, 520, -1, -1, UILH_DOUFATAI.tongbi);
	basePanel:addChild(tongbi)
	local shengwang = CCZXImage:imageWithFile( 720, 520, -1, -1, UILH_DOUFATAI.shengwang);
	basePanel:addChild(shengwang)

	-- 排名奖励的数值
    local function get_num_ima( one_num )
        return string.format("ui/lh_other/number1_%d.png",one_num);
    end
	self.rewards_tip1 = ImageNumberEx:create(0,get_num_ima,12)
	basePanel:addChild(self.rewards_tip1.view)
	self.rewards_tip1.view:setPosition(CCPointMake(515,534))
	self.rewards_tip2 = ImageNumberEx:create(0,get_num_ima,12)
	basePanel:addChild(self.rewards_tip2.view)
	self.rewards_tip2.view:setPosition(CCPointMake(660,534))

	--领取时间
	MUtils:create_zxfont(basePanel,left_top_title[5],605,496,1,15);
	self.rewards_countdown = MUtils:create_zxfont(basePanel,"",740,496,1,15);
	self.rewards_countdown:setIsVisible(false);

	-- 分割线
	MUtils:create_zximg(basePanel,UILH_COMMON.split_line,338,482,525,3,0,0)

	self:update_lt();
end

-- 右下 增加挑战次数，战斗信息
function  DouFaTaiWin:create_right_bottom()
	-- 计时器
	self.fight_cd_label = MUtils:create_zxfont(basePanel,"",755,455,1,16);
	self.fight_cd_label:setIsVisible(false);
	local function btn_clear_cd_fun(eventType,args,msg_id)
		if (eventType == TOUCH_CLICK) then
			DouFaTaiWin:show_clear_cd_dialog()
		end
		return true
	end
	-- 快进，消除等待时间 [11] = "#c33a6ee挑战倒计时:",
	local fate_test =ZLabel:create(basePanel, Lang.doufatai[11], 650,455, 16,1)	

	self.clear_cd_btn = MUtils:create_btn(basePanel,UILH_NORMAL.btn_clear_cd,UILH_NORMAL.btn_clear_cd,btn_clear_cd_fun,828,441,-1,-1);
	self.clear_cd_btn:setIsVisible(true);
	-- 今天还可以挑战次数
	update_view_right_bottom[6] = MUtils:create_zxfont(basePanel,Lang.doufatai[12],365,455,1,16); -- [868]="#c66ff66今天还可以挑战#cfff000100#c66ff66次"
	local function btn_fight_fun(eventType,args,msg_id)
		if (eventType == TOUCH_CLICK) then
			DouFaTaiWin:show_add_fight_num_dialog( )
		end
		return true
	end
	-- 增加次数按钮
	MUtils:create_btn(basePanel,UILH_SKILL.add_mark,UILH_SKILL.add_mark,btn_fight_fun,560,441,-1,-1);
end



function  DouFaTaiWin:update(type,tab_arg)
	-- 更新左上
	if ( type == 1 ) then
		self:update_lt();
	-- 更新右上
	elseif ( type == 2 ) then
		self:update_rt();
	-- 更新左下
	elseif ( type == 3 ) then
		self:update_lb();
	-- 更新右下
	elseif ( type == 4 ) then
		self:update_rb();
	-- 刷新挑战次数
	elseif ( type == 5 ) then
		self:update_fight_num(tab_arg[1],tab_arg[2]);
	-- 更新cd时间
	elseif ( type == 6) then
		self:update_cd_time(tab_arg[1]);
	end
	self.rank_lab:setText( string.format(Lang.doufatai[10],DFTModel:get_reward_info()[1]) )
end
-- 更新左上
function  DouFaTaiWin:update_lt()
	local table = DFTModel:get_reward_info();
	if (#table > 0) then
		-- print("time = " .. table[5]);
		-- print("os.time = " .. os.time());
		-- 1970年到2010年的毫秒数 1262275200000;
		-- local result_time = table[5] + 1262275200  - os.time() - math.floor(os.clock());
		local result_time = table[5];
		_get_reward_time = result_time;
		print("剩余领取时间",_get_reward_time)
		--我的声望
		self.rewards_tip1:set_number(table[3]);
		self.rewards_tip2:set_number(table[4])
		if self.award_lab ~= nil then
			self.award_lab:setText(string.format(Lang.doufatai[35],table[3],table[4]))
		end
		result_time = self:get_time_by_second(result_time);
		self.rewards_countdown:setText(result_time);
		self.rewards_countdown:setIsVisible(true);
	end

	local player = EntityManager:get_player_avatar();
 --    local sw = player.renown;
	-- self.renown_value:setText(left_top_title[2].."#cffffff"..sw);
	local pet_name = PetModel:get_current_pet_name();
	if ( pet_name == nil ) then
		pet_name = LangGameString[532]; -- [532]="无"
	end
	self.fight_pet:setText(left_top_title[3].."#cffffff "..pet_name);
end

-- 更新右上(脸)
function  DouFaTaiWin:update_rt()
	local table = DFTModel:get_dft_info();

	if ( #table > 0 ) then
		for i=1,5 do
			local struct = table[i];
			if (self.challenger_face_btn[i]) then 
				self.challenger_face_btn[i]:removeFromParentAndCleanup(true);
			end
			if ( struct ) then
				local head_path = string.format("ui/lh_normal/head/head%d%d.png",struct.job,struct.sex);
				--排名的数值图片
				local function func( eventType,args,msg_id)
					if eventType == TOUCH_BEGAN then
						return true; 
					elseif eventType == TOUCH_CLICK then
						local tempdata = { roleId = struct.dft_id, roleName = struct.name, qqvip = struct.qqVip , level = struct.lv, camp = struct.clan, job = struct.job, sex = struct.sex }
			            --提示
			            LeftClickMenuMgr:show_left_menu("chat_other_list_menu", tempdata)
					end
				end
				self.challenger_face_btn[i] = MUtils:create_btn(self.challenger_panel[i],
															 head_path,head_path,func,
															 53,162,68,68);
				self.challenger_face_btn[i]:setAnchorPoint(0.5,0.0)
				if self.challenger_rank[i] then
					self.challenger_rank[i]:removeFromParentAndCleanup(true);
					self.challenger_rank[i] = nil;
				end
				--排名图标背景图
				-- update_view_right_top[40+i]=MUtils:create_zximg(self.challenger_panel[i],UIPIC_doufatai_013,66,135,39,39,500,500)
				--排名图标
				self.challenger_rank[i] = MUtils:create_num_img( struct.top,55,73,self.challenger_panel[i],3 )
				-- self.challenger_rank[i]:setAnchorPoint(CCPointMake(0.5,0.0))
				--对手名字
				self.challenger_name[i]:setText(LH_COLOR[1] .. struct.name);
				--对手等级
				self.challenger_level[i]:setText(LH_COLOR[2].. "LV:" .. LH_COLOR[1]..struct.lv);
				-- 对手战斗力
				self.challenger_fight[i]:setText(LH_COLOR[2]..Lang.doufatai[33]..LH_COLOR[1]..struct.fight_value)
			end
		end
	end
	
end

-- 更新左下
function DouFaTaiWin:update_lb()

	-- 现在排行榜不在DouFaTaiWin显示，改为在DouFaTaiRank显示，所以刷新DouFaTaiRank
    local win = UIManager:find_visible_window("doufatai_rank")
    if win then
        win:update(DFTModel:get_dft_top_info())
    end

	self.top_tab = DFTModel:get_dft_top_info();
	local tab_len = #self.top_tab;

	-- 更新榜单人物模型
	self:update_avatar(self.top_tab);
end

-- 刷新模型和模型相关的控件
function DouFaTaiWin:update_avatar( top_info_table )
	local length = #top_info_table;
	local avatar_pos = {{165,373},{90,130},{240,80},}
	local rank_pos = {{47,425},{16,165},{162,96},}
	local bg_img = {UILH_NORMAL.bg_red,UILH_NORMAL.bg_green,UILH_NORMAL.bg_green}
	for i=1,3 do

		if i < length and top_info_table[i].body and top_info_table[i].weapon then
					print("top_info_table[i].body",top_info_table[i].body)
			-- print("top_info_table[i].body",top_info_table[i].body)
			-- print("top_info_table[i].weapon",top_info_table[i].weapon)			
			-- self.showAvatars[i].avatar:setIsVisible(true)
			player_obj = {}
			-- print("top_info_table[i].body",top_info_table[i].body)
			-- if top_info_table[i].body == 2100 then
			-- 	top_info_table[i].body = 10003
			-- end
			player_obj.body = top_info_table[i].body;
			player_obj.weapon = top_info_table[i].weapon;
			player_obj.wing = top_info_table[i].wing;

			if self.showAvatars[i] then
				return;
				-- 发现removeFromParentAndCleanup不能释放avatar，销毁窗口才行，所以不再手动释放avatar，只创建一次。
				-- （因为斗法台窗口现在关闭即销毁，如果再次打开才能刷新模型的话，不会有太大影响,所以进行此修改）
				-- self.showAvatars[i].avatar:removeFromParentAndCleanup(true);
				-- self.showAvatars[i] = {}
			end

			self.showAvatars[i] = ShowAvatar:create_user_panel_avatar( avatar_pos[i][1], avatar_pos[i][2],nil,player_obj)
			self.showAvatars[i].avatar:setActionStept(ZX_ACTION_STEPT)
			self.showAvatars[i].avatar:playAction(ZX_ACTION_IDLE, 4, true)
			-- self.showAvatars[i].avatar:setScale( 1 )
			self.left_panel:addChild( self.showAvatars[i].avatar, 0 )

			-- 战斗力背景
			MUtils:create_zximg(self.showAvatars[i].avatar,bg_img[i],-100,-71,-1,-1)
			-- 名字
			self.avatar_names[i] = CCZXLabel:labelWithText(0,-40,"", 18,ALIGN_CENTER);
			self.showAvatars[i].avatar:addChild(self.avatar_names[i])
			-- 战斗力图片和数字
			MUtils:create_zximg(self.showAvatars[i].avatar,UILH_DOUFATAI.zhanli,-70,-70,-1,-1)
		    local function get_num_ima( one_num )
		        return string.format("ui/lh_other/number1_%d.png",one_num);
		    end
		    self.avatar_fight_values[i] = ImageNumberEx:create(0,get_num_ima,12)
		    self.showAvatars[i].avatar:addChild( self.avatar_fight_values[i].view )
		    self.avatar_fight_values[i].view:setPosition(CCPointMake(-7,-59))		

			self.avatar_names[i]:setText(top_info_table[i].name)
			self.avatar_fight_values[i]:set_number(top_info_table[i].fight_value)

		 --    self.showAvatars[i]:other_player_change_attri( "body", player_obj, true)
		 --    self.showAvatars[i]:other_player_change_attri( "wing", player_obj )
		 --    self.showAvatars[i]:other_player_change_attri( "weapon", player_obj )
		 --    self.showAvatars[i].avatar:setActionStept(ZX_ACTION_STEPT)
			-- self.showAvatars[i].avatar:playAction(ZX_ACTION_IDLE, 4, true)
		    -- 刷新名称
		    -- self.avatar_names[i]:setText(top_info_table[i].name)
		    -- 刷新战斗力
		    -- self.avatar_fight_values[i]:set_number(top_info_table[i].fight_value)
		else
		    -- self.showAvatars[i].avatar:setIsVisible(false)
		    -- self.avatar_names[i]:setText("")
		end	
	end
end

-- 更新右下
function DouFaTaiWin:update_rb()

	-- 现在挑战历史不在DouFaTaiWin显示，改为在DouFaTaiHistory显示，所以刷新DouFaTaiHistory
	self.tab_zj = DFTModel:get_dft_ZJ_info();
    local win = UIManager:find_visible_window("doufatai_history")
    if win then
        win:update(self.tab_zj)
    end

	-- local len = #self.tab_zj;
	-- len = math.min(len,10);
	-- -- -- 挑战记录
	-- -- for i=1,len do
	-- -- 	local zj_struct = self.tab_zj[i];
	-- -- 	if self.history_text_btn[i] ~= nil then
	-- -- 		self.history_text_btn[i]:setText( zj_struct.str );
	-- -- 	end
	-- -- end
	-- if ( self.history_scroll ) then
	-- 	self.history_scroll:clear();
	-- 	self.history_scroll:setMaxNum(len);
	-- 	self.history_scroll:refresh();	
	-- end
end


-- 更新挑战次数
function DouFaTaiWin:update_fight_num(fight_num,money_need)
	fight_need_yuanbao = money_need;
	_fight_num = fight_num;
	if ( update_view_right_bottom[6] ) then
		update_view_right_bottom[6]:setText(Lang.doufatai[12].." ".._fight_num..Lang.doufatai[13]); -- [872]="#c66ff66今天还可以挑战#cfff000" -- [601]="#c66ff66次"
	end
end

-- 更新cd时间
function DouFaTaiWin:update_cd_time(time)
	if ( time > 0 ) then 
		fight_cd = time;
		self.fight_cd_label:setIsVisible(true);
		self.clear_cd_btn:setIsVisible(true);
	else
		fight_cd = time;
		self.fight_cd_label:setIsVisible(false);
		self.clear_cd_btn:setIsVisible(false);
	end
end

function DouFaTaiWin:get_time_by_second(second_num)
	--print("second_num = " .. second_num);
	local second = second_num%60;
	--print("second = " .. second);
	local min = math.floor(second_num/60);
	--print("min = " .. min);
	local hour = math.floor(min/60);
	--print("hour = " .. hour);
	--print("day = " .. day);
	min = min%60;
	--hour = hour%24;
	--print("day = " .. day .. "hour = " .. hour .. "min = " .. min .. "second = " .. second);
	local time_str = "";
	if ( hour > 0 ) then 
		time_str = time_str .. hour..LangGameString[873]; -- [873]="时"
	end
	time_str = time_str .. min..LangGameString[874]; -- [874]="分"
	time_str = time_str .. second..LangGameString[875]; -- [875]="秒"
	return time_str;
end

-- 被添加或移除到显示节点上面的事件
function DouFaTaiWin:active( show )
	if ( show ) then
		-- 请求斗法台对手信息
		DouFaTaiCC:req_get_info();

		self:update_rb();

		if self.timer then
			self.timer:stop()
		end
		local function dismiss( dt )
			self:update_time();
	    end
	    self.timer:start(1,dismiss);
	    -- 清除排名榜信息
	    DFTModel:set_dft_top_info( {} )
	    -- 请求排行榜信息
		DouFaTaiCC:req_top_info(1);
		DouFaTaiCC:req_top_info(2);
		DouFaTaiCC:req_top_info(3);
		-- 更新左下的排行榜
		self:update_lb()
		-- for i=1,3 do
		-- 	self.showAvatars[i].avatar:playAction( ZX_ACTION_IDLE, 10, true )     -- 播放角色模型待机动画
		-- end
	else
		self.timer:stop();
		Instruction:continue_next()
		-- for i=1,3 do
		-- 	self.showAvatars[i].avatar:resetShowAvatar();
		-- end
	end
end

function DouFaTaiWin:update_time()
	-- 更新左上角的时间
	if ( self.rewards_countdown:getIsVisible() and  _get_reward_time > 0 ) then 
		_get_reward_time = _get_reward_time - 1;
		local result_time = self:get_time_by_second(_get_reward_time);
		self.rewards_countdown:setText(result_time);
	end
	-- 更新挑战失败后的cd时间update_view_right_bottom
	if ( self.fight_cd_label:getIsVisible() and fight_cd > 0 ) then
		fight_cd = fight_cd - 1;
		if ( fight_cd > 0 ) then
			local result_time = self:get_time_by_second( fight_cd );
			self.fight_cd_label:setText(result_time);
		else
			self.fight_cd_label:setIsVisible(false);
			self.clear_cd_btn:setIsVisible(false);
		end
	end
-- end 
end

-- 显示清除cd对话框
function DouFaTaiWin:show_clear_cd_dialog()
	local yuanbao = 2;
	if ( fight_cd < 150 ) then
		yuanbao = 1;
	end
	if ( PlayerAvatar:check_is_enough_money( 4 ,yuanbao) ) then 
		if ( clear_cd_tip ) then 
			local function clear_cd_fun( _clear_cd_tip )
				DouFaTaiCC:req_clear_cd();
			end
			local function swith_but_func ( _clear_cd_tip )
				clear_cd_tip = not _clear_cd_tip
			end
			-- 30级以上消耗元宝2,30级以下消耗元宝1

			--NormalDialog2:show("#c66ff66是否消费#cfff000"..yuanbao.."元宝#c66ff66消除等待时间",clear_cd_fun,true);
			ConfirmWin2:show( 5, nil, Lang.doufatai[25]..yuanbao..Lang.doufatai[26],  clear_cd_fun, swith_but_func ) -- [876]="#c66ff66是否消费#cfff000" -- [877]="元宝#c66ff66消除等待时间"
		else
			DouFaTaiCC:req_clear_cd();
		end
	end
	-- local money_type = MallModel:get_only_use_yb() and 3 or 2
	-- local param = {money_type}
	-- local clear_func = function( param )
	-- 	DouFaTaiCC:req_clear_cd(param[1])
	-- end
	-- if clear_cd_tip then
	-- 	local function clear_cd_fun( _clear_cd_tip )
	-- 		MallModel:handle_auto_buy(yuanbao, clear_func, param)
	-- 	end
	-- 	local function swith_but_func ( _clear_cd_tip )
	-- 		clear_cd_tip = not _clear_cd_tip
	-- 	end
	-- 	-- 30级以上消耗元宝2,30级以下消耗元宝1

	-- 	ConfirmWin2:show( 5, nil, LangGameString[876]..yuanbao..LangGameString[877],  clear_cd_fun, swith_but_func ) -- [876]="#c66ff66是否消费#cfff000" -- [877]="元宝#c66ff66消除等待时间"
	-- else
	-- 	-- clear_func(param)
	-- 	MallModel:handle_auto_buy(yuanbao, clear_func, param)
	-- end
end

-- 显示增加次数的对话框
function DouFaTaiWin:show_add_fight_num_dialog( )
	-- local money_type = MallModel:get_only_use_yb(  ) and 3 or 2
	-- local param = {money_type}
	-- local zhaocai_func = function( param )
	-- 	DouFaTaiCC:req_add_fight_num(param[1])
	-- end

	-- if ( show_tip ) then
	-- 	local function fun( _show_tip )
	-- 		MallModel:handle_auto_buy( fight_need_yuanbao, zhaocai_func, param )
	-- 	end
	-- 	local function swith_but_func ( _show_tip )
	-- 		show_tip = not _show_tip;
	-- 	end
	-- 	ConfirmWin2:show( 5, nil, LangGameString[878] ..fight_need_yuanbao..LangGameString[879],  fun, swith_but_func ) -- [878]="#c66ff66消耗#cfff000" -- [879]="元宝#c66ff66增加挑战次数"
	-- else
	-- 	MallModel:handle_auto_buy( fight_need_yuanbao, zhaocai_func, param )
	-- end

	if ( PlayerAvatar:check_is_enough_money( 4 ,fight_need_yuanbao) ) then 
		if ( show_tip ) then
			local function fun( _show_tip )
				DouFaTaiCC:req_add_fight_num();
			end
			local function swith_but_func ( _show_tip )
				show_tip = not _show_tip;
			end
			--NormalDialog2:show("#c66ff66消耗#cfff000" ..fight_need_yuanbao.."元宝#c66ff66增加挑战次数",fun,true);
			ConfirmWin2:show( 5, nil, Lang.doufatai[25] ..fight_need_yuanbao..Lang.doufatai[27],  fun, swith_but_func ) -- [878]="#c66ff66消耗#cfff000" -- [879]="元宝#c66ff66增加挑战次数"
		else
			DouFaTaiCC:req_add_fight_num();
		end
	end
end
-- 获取当前的cd时间 fight_cd不为0代表有cd
function DouFaTaiWin:get_cd_time()
	return fight_cd
end

function DouFaTaiWin:destroy()
	Instruction:continue_next()
	clearGlobals()
	self.timer:stop()
	UIManager:destroy_window("doufatai_rank");	-- 关闭斗法台时，排行榜也一起关掉
    Window.destroy(self)
end
