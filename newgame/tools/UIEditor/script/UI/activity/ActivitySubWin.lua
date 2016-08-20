-- ActivitySubWin.lua  
-- created by fjh on 2013-3-5
-- 各种活动的展示窗口  
super_class.ActivitySubWin(NormalStyleWindow)


local act_dict = {
		--@brief:key值的id对应的是ActivityConfig里的id
		[1] = { bg=UIResourcePath.FileLocate.activity .. "xianlin_bg.png",title=UIResourcePath.FileLocate.activity .. "pantao_title.png"},	--蟠桃盛宴  （家族酒会）
		[2] = { bg=UIResourcePath.FileLocate.activity .. "xianlin_bg.png",title=UIResourcePath.FileLocate.activity .. "xianlin_title.png"},	--仙灵封印  （家族叛忍）
		[3] = { bg=UIResourcePath.FileLocate.activity .. "tianyuan_bg.pd",title=UIResourcePath.FileLocate.activity .. "tianyuan_title.png"},	--天元之战 （没有）
		[5] = { bg=UIResourcePath.FileLocate.activity .. "husong_bg.png",title=UIResourcePath.FileLocate.activity .. "husong_title.png"},	--欢乐护送  （护送公主）
		[6] = { bg=UIResourcePath.FileLocate.activity .. "xianyu_bg.png",title=UIResourcePath.FileLocate.activity .. "xianyu_title.png"},	--灵泉仙浴  （温泉）
		[7] = { bg=UIResourcePath.FileLocate.activity .. "baguadigong_bg.png",title=UIResourcePath.FileLocate.activity .. "baguadigong_title.png"},	--八卦地宫 
		[8] = { bg=UIResourcePath.FileLocate.activity .. "question_bg.pd",title=UIResourcePath.FileLocate.activity .. "question_title.png"},	--答题活动  （没有）		
		[9] = { bg=UIResourcePath.FileLocate.activity .. "zys_bg.pd",title=UIResourcePath.FileLocate.activity .. "zys_title.png"},	--自由赛  （没有）		
		[10] = { bg=UIResourcePath.FileLocate.activity .. "zbs_bg.pd",title=UIResourcePath.FileLocate.activity .. "zbs_title.png"},	--答题活动  （没有）		
};	
--活动按钮的配置
local btn_num = {
		[1] = 2,[2] = 2,[3] = 2,[5] = 2,[6] = 1,[7] = 1,[8]=1,[9]=1,[10]=1;
};
-- 活动的提示语配置([2] = "是否进入自由赛活动场景",[3] = "是否进入争霸赛活动场景")
local tip_text = { [9] = Lang.activity.activity_sub_win[2], [10] = Lang.activity.activity_sub_win[3]};
-- 是否是从活动界面打开的
local is_show_from_activityWin = false

function ActivitySubWin:set_is_show_from_activityWin( boo )
    is_show_from_activityWin = boo
end
-- local function close_fun( eventType,x,y )
-- 	--关闭事件
-- 	if eventType == TOUCH_CLICK then
-- 		UIManager:hide_window("activity_sub_win");
-- 	end
-- 	return true;
-- end

function ActivitySubWin:__init( window_name, texture_name, is_grid, width, height,title_text )
	-- self.view:setSize(458, 610)

	-- 再用一层背景覆盖住父类的bg
	ZImage:create( self.view, UILH_COMMON.dialog_bg, 0, 0, width, height - 25, -1,500,500 )

	local bg = ZBasePanel.new( UILH_COMMON.bottom_bg, 400, 245)
	bg:setPosition(10, 10)
	self:addChild(bg)

	self.tip_label = ZLabel:create(self.view, "", 210, 220, 16, 2)

	-- 分割线
	local line = CCZXImage:imageWithFile( 25, 90, 400-25, 3, UILH_COMMON.split_line )
    self.view:addChild(line)

	-- bg = ZBasePanel.new("", 374, 506+20)
	-- bg:setPosition(30+12, 20+12)
	-- self:addChild(bg)

	-- local line = ZImage.new(UIResourcePath.FileLocate.common .. "jgt_line.png")
	-- line:setPosition(47, 266+20)
	-- line:setSize(364, 2)
	-- self:addChild(line)

	 --背景图
 --    self.bg_img = CCZXImage:imageWithFile(48,260+12+20,360+2,260, '');
	-- self:addChild(self.bg_img);

	-- ZImage:create(self.view, UIResourcePath.FileLocate.dailyActivity .. "alpha_bezel.png", 42, 290, 360+14, 57+4, 0, 0, 0, 0, 0, 0, 0, 0 ,0)
	--描述
	-- self.desc_lab = MUtils:create_ccdialogEx(self.view,"", 44, 274+20, 360, 25, 5, 16);
	-- self.desc_lab:setAnchorPoint(0,1);
	--活动奖励
	-- local lab_bg = CCZXImage:imageWithFile( 42,232+20, -1, -1,UIResourcePath.FileLocate.common .. "wzd-1.png",500,500);
	-- self:addChild(lab_bg);
	-- local battle_reward = CCZXImage:imageWithFile(24, 3, -1, -1,UIResourcePath.FileLocate.activity .. "2.png");
	-- lab_bg:addChild(battle_reward);

end

--绘制奖励项目区域
-- function ActivitySubWin:draw_star_panel( x,y,star_dict )

-- 	local panel = CCBasePanel:panelWithFile(x,y,300,120,"");
-- 	for i,info in ipairs(star_dict) do
-- 		local lab = UILabel:create_lable_2("#cfff000"..info.name, 15, 60*(i-1)+18, 16, ALIGN_LEFT );
-- 		panel:addChild(lab);

-- 		local bg = ZImage.new(UIResourcePath.FileLocate.activity .. "1.png");
-- 		bg:setPosition(56+20, 60*(i-1)+15)
-- 		panel:addChild(bg.view);

-- 		local star = MUtils:create_star_range( panel, 76+20, 60*(i-1)+18, 20, 20, info.num );
-- 		star.change_star_interval(2);
-- 	end
-- 	return panel;
-- end

--绘制按钮
function ActivitySubWin:create_btn_panel(x,y,func_1,func_2 )
	-- local panel = CCBasePanel:panelWithFile(x,y,320,50,"");
	local btn_1;
	local btn_2;
	if func_2 == nil then
		
		btn_1 = CCNGBtnMulTex:buttonWithFile(145, 25, -1, -1, UILH_COMMON.btn4_nor,500,500)
		btn_1:registerScriptHandler(func_1);
	    self:addChild(btn_1);
	    ZLabel:create(btn_1, Lang.common.confirm[0], 121/2, 20, 16, 2)
	 --    local btn_img = CCZXImage:imageWithFile(146/2,58/2,-1,-1,UIResourcePath.FileLocate.activity .. "lab_joinNow.png");
		-- btn_img:setAnchorPoint(0.5,0.5)
		-- btn_1:addChild(btn_img);

	else
		    --xiehande 通用按钮修改 btn_lan->button3
		btn_1 = CCNGBtnMulTex:buttonWithFile(194, 0, -1, -1, UIResourcePath.FileLocate.common .. "button3.png")
		btn_1:registerScriptHandler(func_1);
	    self:addChild(btn_1);
		MUtils:create_zxfont(btn_1, LangGameString[2379], 126/2, 20, 2, 18)  -- [2379] = "速传"

		btn_2 = CCNGBtnMulTex:buttonWithFile(0, 0, -1, -1, UIResourcePath.FileLocate.common .. "button3.png")
		btn_2:registerScriptHandler(func_2);
	    self:addChild(btn_2);
		MUtils:create_zxfont(btn_2, LangGameString[2380], 126/2, 20, 2, 18)  -- [2380] = "前往"
	end

	-- return panel;
end

-- 设置格子的图标
-- 每个功能派生需要实现自己的icon id索引
function ActivitySubWin:set_bg_texture( icon_texture )
	-- if self.cur_icon_texture == icon_texture and icon_texture ~= '' then
	-- 	return
	-- end

	-- self.cur_icon_texture = icon_texture
	-- -- 如果icon为空的话要去掉color_frame
	-- if ( icon_texture == "") then
	-- 	self.bg_img:setTexture('')
	-- else
	-- 	safe_retain(self.bg_img)
	-- 	ResourceManager.ImageUnitTextureBackgroundLoad(icon_texture, self.set_bg_texture_load, self)
	-- end
end

--后台加载回调
-- function ActivitySubWin:set_bg_texture_load(icon_texture)
-- 	if self.cur_icon_texture == icon_texture then
-- 		self.bg_img:setTexture(icon_texture)
-- 	end
-- 	safe_release(self.bg_img)
-- end

-- 更新
function ActivitySubWin:update( activity_id )
	
	if activity_id == ActivityConfig.ACTIVITY_QUESTION then
		QuestionCC:req_did_jion_activity_count(  )
	end


	--标题
	-- if self.window_title then
	-- 	self.window_title:setTexture(act_dict[activity_id].title)
	-- else
	-- 	local spr_bg_size = self.view:getSize()
	-- 	self.window_title = ZImage:create( self.view, act_dict[activity_id].title , spr_bg_size.width/2,  spr_bg_size.height-29, -1,-1,999 );
	-- end

	--背景
	-- self:set_bg_texture(act_dict[activity_id].bg);

	--活动描述
	-- local str = ActivityModel:get_activity_introduce_by_id( activity_id );
	-- self.desc_lab:setText(str);
	-- local text_height = self.desc_lab:getInfoSize().height;
	-- self.desc_lab:setPosition(48, 274+20);


	--活动奖励
	-- local star_dict = ActivityModel:get_activity_star( activity_id );
	-- if self.reward_panel ~= nil then
	-- 	self.reward_panel:removeFromParentAndCleanup(true);
	-- end
	-- self.reward_panel = self:draw_star_panel( 42,116,star_dict );
	-- self:addChild(self.reward_panel);
	
	--该活动的配置
	-- local config = ActivityConfig:get_activity_info_by_id( activity_id );
	
	--按钮
	--寻路前往
	local function moveto( eventType,x,y )
		if eventType == TOUCH_CLICK then
			local player = EntityManager:get_player_avatar()
			if activity_id == ActivityConfig.ACTIVITY_HUANLEHUSONG and player.level < 26 then
				GlobalFunc:create_screen_notic(LangGameString[1463])	--护送公主
			elseif activity_id == ActivityConfig.ACTIVITY_SHOULINGFENGYIN and player.level< 25 then 
				GlobalFunc:create_screen_notic(LangGameString[1462])	--家族叛徒
			elseif activity_id == ActivityConfig.ACTIVITY_PANTAOSHENGYAN and player.level< 25 then 
				GlobalFunc:create_screen_notic(LangGameString[1462])	--家族酒会
			else
				ActivityModel:go_to_activity( config.location.sceneid, config.location.entityName, false );
			end
		end
		return true;
	end

	--速传
	local function goto( eventType,x,y )
		if eventType == TOUCH_CLICK then
			local player = EntityManager:get_player_avatar()
			if activity_id == ActivityConfig.ACTIVITY_HUANLEHUSONG and player.level < 26 then
				GlobalFunc:create_screen_notic(LangGameString[1463])
			elseif activity_id == ActivityConfig.ACTIVITY_SHOULINGFENGYIN and player.level< 25 then 
				GlobalFunc:create_screen_notic(LangGameString[1462])	--家族叛徒
			elseif activity_id == ActivityConfig.ACTIVITY_PANTAOSHENGYAN and player.level< 25 then 
				GlobalFunc:create_screen_notic(LangGameString[1462])
			else
				ActivityModel:go_to_activity( config.location.sceneid, config.location.entityName, true );
			end
		end
		return true;
	end

	--立即参加
	local function join_now( eventType,x,y )
		if eventType == TOUCH_CLICK then

			local cur_fb = SceneManager:get_cur_fuben();
			if cur_fb > 0 then
				GlobalFunc:create_screen_notic(LangGameString[2381]) -- [2381] = "副本内不能参加活动"
				return;
			end
			
			if activity_id == ActivityConfig.ACTIVITY_LINGQUANXIANYU then
				--灵泉仙浴
				if SceneManager:get_cur_scene() ~= 1077 then
					-- 场景id 1077为仙浴场景，在仙浴场景内不能立即参加入灵泉仙浴
					local player = EntityManager:get_player_avatar();
					-- 25级开放
					if player.level >= ActivityConfig.LEVEL_WENQUAN then
						XianYuModel:enter_xianyu_scene( );
					else
						GlobalFunc:create_screen_notic( LangGameString[551] ); -- [551]="人物等级需要达到25级"
					end
				end
			elseif activity_id == ActivityConfig.ACTIVITY_BAGUADIGONG then
				-- 八卦地宫活动
				local player = EntityManager:get_player_avatar();
				-- 38级开放
				if player.level >= ActivityConfig.LEVEL_BAGUADIGONG then
					BaguadigongModel:enter_digong_fuben();
				else
					GlobalFunc:create_screen_notic( LangGameString[552] ); -- [552]="人物等级需要达到38级"
				end
			elseif activity_id == ActivityConfig.ACTIVITY_QUESTION then
				-- 答题活动
				local player = EntityManager:get_player_avatar();
				if player.level >= 30 then
					local jion_times = QuestionActivityModel:get_jion_times( );
					if jion_times < 1 then
						GlobalFunc:create_screen_notic( LangGameString[553] ); -- [553]="此活动每日只能参加一次"
					else
					    if UIManager:find_visible_window("question_win") then
							QuestionActivityModel:req_all_question_info();
						else
							UIManager:show_window("question_win");
						end
					end
				else
					GlobalFunc:create_screen_notic( LangGameString[554] ); -- [554]="人物等级需要达到30级"
				end
				UIManager:hide_window("activity_sub_win")
			elseif activity_id == ActivityConfig.ACTIVITY_FREE_MATCH then
				-- 进入自由赛报名场景
				if SceneManager:get_cur_scene() == 18 then
					GlobalFunc:create_screen_notic(Lang.screen_notic[7]);	-- [40006]="您已經在自由賽報名場景了"
				else
					XianDaoHuiCC:req_enter_zys_scene()
				end
				UIManager:hide_window("activity_sub_win")
			elseif activity_id == ActivityConfig.ACTIVITY_DOMINATION_MATCH then
				-- 进入争霸赛副本
				if SceneManager:get_cur_fuben() == 72 then
					GlobalFunc:create_screen_notic(Lang.screen_notic[8]);	-- [40007]="您已經在爭霸賽場景了"
				else
					XianDaoHuiCC:req_enter_zbs_scene()
				end
				UIManager:hide_window("activity_sub_win")
			end

		end
		return true;
	end

	if self.btn_panel ~= nil then
		self.btn_panel:removeFromParentAndCleanup(true);
	end
	-- 是单个按钮还是两个按钮
	if btn_num[activity_id] == 1 then
		self:create_btn_panel(70,50,join_now)
	else
		self:create_btn_panel(70,50,goto,moveto)
	end
	
	if tip_text[activity_id] ~= nil then
		self.tip_label:setText(tip_text[activity_id])
	else
		self.tip_label:setText(Lang.activity.activity_sub_win[1]); -- "确定要进入吗？"
	end
	-- self:addChild(self.btn_panel);
end
