-- DujieResultWin.lua
-- created by fangjiehua on 2013-2-1
-- 渡劫结果窗口  
super_class.DujieResultWin(Window)

--求相对屏幕大小的函数
local win_w = GameScreenConfig.ui_screen_width
local win_h = GameScreenConfig.ui_screen_height

local timer_cb = nil
local timer_ = nil

function DujieResultWin:__init(  )
	AIManager:set_AIManager_idle(  )

	-- 灰暗背景
    -- self.bg_img = ZImage:create( self.view, UILH_FUBEN.result_bg, -150, -50, GameScreenConfig.ui_screen_width+200,GameScreenConfig.ui_screen_height+100,0, 500, 500)
    self.bg_img = ZImage:create( self.view, UILH_FUBEN.result_bg, -100, -100, win_w+200, win_h+200)
    self.bg_img.view:setOpacity(0)

    -- 面板元素基础层
    self.base_bg = CCBasePanel:panelWithFile( win_w*0.5, win_h*0.5, win_w, win_h, "")
    self.base_bg:setAnchorPoint(0.5,0.5)
    self.view:addChild(self.base_bg)

    -- 左边面板
	self.lelf_panel = ZBasePanel:create(self.view,"",-40, 0, 500, 640);
	-- 右边评分动画(旋转动画图)
    self.grade_bg = MUtils:create_zximg(self.lelf_panel, UILH_FUBEN.bttm_layer, 260, 340,-1,-1, 500, 500)
    self.grade_bg:setAnchorPoint(0.5,0.5)
    -- self.grade_bg:setIsVisible(false)
    self.two_layer = MUtils:create_zximg(self.grade_bg, UILH_FUBEN.two_layer, 214*0.5, 218*0.5,-1,-1, 500, 500)
    self.two_layer:setAnchorPoint(0.5,0.5)
    self.two_layer:setIsVisible(false)
    self.one_layer = MUtils:create_zximg(self.grade_bg, UILH_FUBEN.one_layer, 214*0.5, 218*0.5, -1, -1, 500, 500)
    self.one_layer:setAnchorPoint(0.5,0.5)
    self.one_layer:setIsVisible(false)
	-- self.lelf_panel.view:setIsVisible(false);

	-- 人物背景(像魔法阵的东西@_@|||")
	-- self.body_bg = CCBasePanel:panelWithFile( 0, 0, -1, -1, UILH_HUGUO.rs_bg )
	-- self.lelf_panel.view:addChild( self.body_bg )

	-- 人物
	local player = EntityManager:get_player_avatar();
	local job = player.job;
	local sex = player.sex
	local role_x, role_y = 300, 300
	if job == 1 then
		role_x, role_y = 125, 300
	end
	self.body_img = ZCCSprite:create(self.lelf_panel.view, "nopack/body/"..job..sex..".png", role_x, role_y);

	-- 右边的面板
	self.right_panel = ZBasePanel:create(self.view,"",415, 0, 500, 640);
	self.right_panel.view:setIsVisible(false);
	
	-- 奖励 + 线
	MUtils:create_zximg(self.right_panel, UILH_HUGUO.renwu_title, 85, 290,-1,-1, 500, 500);
	MUtils:create_zximg( self.right_panel, UILH_FUBEN.line, 185, 310, 300, -1)

	-- 称号
	-- MUtils:create_zximg(self.right_panel,UI_DujieWin_018,125,280,-1,-1,500,500);
	-- 奖励
	-- MUtils:create_zximg(self.right_panel,UI_DujieWin_019,125,230,-1,-1,500,500);
	-- 称号
	ZLabel:create(self.right_panel,LH_COLOR[13] .. Lang.huguo[6], 155, 240, 20, 1)	
	-- self.tilte_lab = ZLabel:create(self.right_panel, "", 240, 175, 16, 1)
	self.title_img = CCBasePanel:panelWithFile(235, 240, 150, 50, "")	
	-- self.title_img:setScale(1.3)
	self.right_panel:addChild( self.title_img )

	-- 属性
	ZLabel:create(self.right_panel,LH_COLOR[13] .. Lang.huguo[7], 155, 190, 20, 1)	
	self.attr_lab = ZLabel:create(self.right_panel, "", 235, 190, 20, 1)	
	-- 首通
	-- MUtils:create_zximg(self.right_panel,UI_DujieWin_026,125,180,-1,-1,500,500)

	--元宝奖励隐藏
	-- self.yb_image= MUtils:create_zximg(self.right_panel,UI_DujieWin_025,219,173,-1,-1,500,500)
	-- self.awardMoney_text = UILabel:create_lable_2(c3_orange.."×10", 250, 182, 20, ALIGN_LEFT )
	-- self.right_panel:addChild(self.awardMoney_text)

	-- 创建星星
	-- for i=1,3 do
	-- 	ZCCSprite:create(self.right_panel,UI_DujieWin_015,150+(i-1)*90,400)
	-- end
end

function DujieResultWin:do_action( is_success ,star_num )
	-- print("do_action() 1")
	-- 第一步 背景图片慢慢显示 九宫格不能使用action(主面板)
	self.bg_img.view:runAction(CCFadeOut:actionWithDuration(1));
	local _timer = timer();
	local opacity = 0;
	local function timer_fun()
		opacity = opacity + 100;
		self.bg_img.view:setOpacity(opacity);
		if opacity == 500 then
			_timer:stop()
		end
	end
	_timer:start(0.1,timer_fun)

	-- 1.5步
	local t0 = CCScaleTo:actionWithDuration( 0.1, 2.5 )
    local t1 = CCScaleTo:actionWithDuration( 0.1, 2.6 )
    local t2 = CCScaleTo:actionWithDuration( 0.1, 0.5 )
    local t3 = CCScaleTo:actionWithDuration( 0.1, 1.1 ) 
    local t4 = CCScaleTo:actionWithDuration( 0.1, 1.0 ) 
	local array_1 = CCArray:array()
    array_1:addObject(CCDelayTime:actionWithDuration(0.5))
    array_1:addObject(CCShow:action())
    array_1:addObject(t0)
    array_1:addObject(t1)
    array_1:addObject(t2)
    array_1:addObject(t3)
    array_1:addObject(t4)
    local seq_1 = CCSequence:actionsWithArray(array_1)
    self.two_layer:runAction(seq_1)

    local array_2 = CCArray:array()
    array_2:addObject(CCDelayTime:actionWithDuration(0.7))
    array_2:addObject(CCShow:action())
    array_2:addObject(t0)
    array_2:addObject(t1)
    array_2:addObject(t2)
    array_2:addObject(t3)
    array_2:addObject(t4)
    local seq_2 = CCSequence:actionsWithArray(array_2)
    self.one_layer:runAction(seq_2)


	local a_array_2 = CCArray:array()
    local action2 = CCRepeatForever:actionWithAction(CCRotateBy:actionWithDuration(1.5,80))
    self.two_layer:runAction(action2)
    local a_array_3 = CCArray:array()
    local action3 = CCRepeatForever:actionWithAction(CCRotateBy:actionWithDuration(1.5,-80))
    self.one_layer:runAction(action3)


	-- 第二步(右面板)
	local array = CCArray:array();
	local action1 = CCDelayTime:actionWithDuration(0.3);
	local action2 = CCMoveBy:actionWithDuration(0.5,CCPoint(550,0));
	local action3 = CCMoveBy:actionWithDuration(0.1,CCPoint(-19,0));
	local action4 = CCRepeatForever:actionWithAction(CCRotateBy:actionWithDuration(10,360));
	array:addObject(action1)
	array:addObject(action2)
	array:addObject(action3)
	-- array:addObject(action4)
	-- self.round.view:runAction(CCSequence:actionsWithArray(array));
	-- self.round.view:runAction(action4);
	-- 第三步(右面板)
	local array = CCArray:array();
	array:addObject(CCDelayTime:actionWithDuration(1));
	array:addObject(CCShow:action());
	self.right_panel.view:runAction(CCSequence:actionsWithArray(array))

	-- 第四步(主面板)
	self.body_img.view:setOpacity(0)
	local array = CCArray:array();
	array:addObject(CCDelayTime:actionWithDuration(1.5));
	array:addObject(CCFadeIn:actionWithDuration(2));
	self.body_img.view:runAction(CCSequence:actionsWithArray(array))	
	-- 第五步 砸星星(右面板) 第六部
	local start_y = 430
	for i=1,star_num do
		if i == 2 then
			start_y = 400
		else
			start_y = 430
		end
		local spr_star = ZCCSprite:create( self.right_panel, UILH_HUGUO.rs_start, 165+(i-1)*110, start_y)
		spr_star.view:setScale(10);
		spr_star.view:setOpacity(50);
		spr_star.view:setIsVisible(false);
		local array = CCArray:array();
		array:addObject(CCDelayTime:actionWithDuration(1.8+(i-1)*0.3 ));
		array:addObject(CCShow:action());
		local array2 = CCArray:array();
		array2:addObject(CCScaleTo:actionWithDuration(0.2,1))
		array2:addObject(CCFadeIn:actionWithDuration(0.2))
		local action = CCSpawn:actionsWithArray(array2)
		array:addObject(action);
		array:addObject(CCScaleTo:actionWithDuration(0.05,0.7));
		array:addObject(CCScaleTo:actionWithDuration(0.05, 0.8));
		spr_star.view:runAction(CCSequence:actionsWithArray(array))
	end
	-- 第六步 渡劫成功或失败(右面板)-》第五部
	local path = "";
	if is_success then
		path = UILH_HUGUO.rs_scf
	else
		path = UI_DujieWin_022
	end
	local res_t = ZCCSprite:create(self.right_panel,path,280,530);
	res_t.view:setScale(10);
	res_t.view:setOpacity(50);
	res_t.view:setIsVisible(false);	
	local array = CCArray:array();
	array:addObject(CCDelayTime:actionWithDuration( 1.3 ));
	array:addObject(CCShow:action());
	local array2 = CCArray:array();
	array2:addObject(CCScaleTo:actionWithDuration(0.2,1))
	array2:addObject(CCFadeIn:actionWithDuration(0.2))
	local action = CCSpawn:actionsWithArray(array2)
	array:addObject(action);
	res_t.view:runAction(CCSequence:actionsWithArray(array))
	--出特效
	-- local cb = callback:new();
	-- local function cb_fun()
	-- 	local ef1 = LuaEffectManager:play_view_effect( 16,620,220,self.view,false )
	-- 	if ef1 then
	-- 		ef1:setPosition(166,30)
	-- 	end
	-- 	local ef2 = LuaEffectManager:play_view_effect( 16,620,170,self.view,false )
	-- 	if ef2 then
	-- 		ef2:setPosition(166,30)
	-- 	end
	-- end
	-- cb:start(3.5,cb_fun);

	-- 第七步 显示按钮
	local array = CCArray:array();
	array:addObject(CCDelayTime:actionWithDuration( 3.5 ));
	array:addObject(CCShow:action())
	local action = CCSequence:actionsWithArray(array);
	self.btn1.view:runAction(action);	
	
	if self.btn2 then
		local array = CCArray:array();
		array:addObject(CCDelayTime:actionWithDuration( 3.1 ));
		array:addObject(CCShow:action())
		local action = CCSequence:actionsWithArray(array);
		self.btn2.view:runAction(action);
		self.btn3.view:runAction(action)
	end

	-- 倒计时
	self.lb_mao = ZLabel:create( self.right_panel, '秒', 270, 53, 20 ) -- 秒
	self.time_label = ZLabel:create( self.right_panel, '5', 250, 53, 20 )
	self.time_label.view:setIsVisible(false)
	self.lb_mao.view:setIsVisible(false)
	local index = 5
	timer_cb = callback:new()
	function cb_func()
		self.time_label.view:setIsVisible(true)
		self.lb_mao.view:setIsVisible(true)
		timer_ = timer()
		function timer_func( )
			index = index -1
			self.time_label:setText( index )
			if index == 0 or index < 0 then
				if timer_ then
					timer_:stop()
					timer_ = nil
				end
			end
		end
		timer_:start(1, timer_func)
	end
	timer_cb:start(14, cb_func)
	
end

-- 渡劫成功的确定按钮
local function dujie_succss_btn( eventType  )

	if timer_cb then
		timer_cb:cancel()
		timer_cb = nil
	end

	if timer_ then
		timer_:stop()
		timer_ = nil
	end

	DujieModel:exit_dujie()
	UIManager:destroy_window("dujie_result_win");

	if Instruction:isInstructionPlayed(7)  then
		Instruction:setInstructionPlayed(7, nil)
	elseif Instruction:isInstructionPlayed(16) then
		Instruction:setInstructionPlayed(16, nil)
	elseif Instruction:isInstructionPlayed(20) then
		Instruction:setInstructionPlayed(20, nil)
	else
		UIManager:show_window("dujie_win");
	end
end

--退出渡劫
local function close_win( eventType,x,y ) 
	DujieModel:exit_dujie()
	UIManager:destroy_window("dujie_result_win");
end

--再次渡劫
local function dujie_again( eventType,x,y )
	DujieModel:dujie_again();
	UIManager:destroy_window("dujie_result_win");
end

local function get_chenghao_img_size( index )
	local size_table = {[1]={width=121,height=23},[2]={width=115,height=33},[3]={width=119,height=36},[4]={width=128,height=38},[5]={width=137,height=36}};
	 
	local num = Utils:getIntPart((index-1)/9)+1;
	return size_table[num];
end


local function draw_star(panel,num )
  
	for i=0,2 do
		local star_img = CCZXImage:imageWithFile( 90+28*i, 5, 16, 16,UIResourcePath.FileLocate.normal .. "star_yellow.png");
		--star_img:addTexWithFile(CLICK_STATE_DISABLE, "ui/common/star_gray.png")
		panel:addChild(star_img);
		if i >= num then
			star_img:setCurState(CLICK_STATE_DISABLE);
		end
	end
end

--创建渡劫成功界面
function DujieResultWin:create_succss_panel( star,jingjie,frist)

	-- if jingjie > 0 then
	-- 	local img_str = string.format(UIResourcePath.FileLocate.title .. "%05d.png",jingjie);
	-- 	local size = get_chenghao_img_size(jingjie);
	-- 	ZImage:create(self.right_panel,img_str,219,280);
	-- end
	-- 称号
	print("======star,jingjie,frist:", star,jingjie,frist )
	-- print("=======DujieModel:get_cur_jingjie_title_txt(jingjie):", DujieModel:get_cur_jingjie_title_txt(jingjie))

	-- self.tilte_lab:setText( LH_COLOR[2] .. DujieModel:get_cur_jingjie_title_txt(jingjie) )

	if frist ~= 0 then
		self.title_img:addChild( DujieModel:get_current_jingjie_title(jingjie) )
		self.title_img:setIsVisible(false)
		local array_title = CCArray:array();
		local t0 = CCScaleTo:actionWithDuration( 0.03, 3.5 )
	    local t1 = CCScaleTo:actionWithDuration( 0.1, 10 )
	    local t2 = CCScaleTo:actionWithDuration( 0.1, 1.0 )
	    local t3 = CCScaleTo:actionWithDuration( 0.1, 1.6 ) 
	    local t4 = CCScaleTo:actionWithDuration( 0.1, 1.5 ) 
	    array_title:addObject(CCDelayTime:actionWithDuration(3))
	    array_title:addObject(t0)
	    array_title:addObject(CCShow:action())
	    array_title:addObject(t1)
	    array_title:addObject(t2)
	    array_title:addObject(t3)
	    array_title:addObject(t4)
	    local seq_title = CCSequence:actionsWithArray(array_title)
	    self.title_img:runAction( seq_title )
	else
		ZLabel:create(self.title_img, "无", 0, 0, 20, 1)	
	end
	-- 奖励
	local attri_type,attri_value = DujieModel:get_attri_reward_by_index( jingjie );
	self.attr_lab:setText( LH_COLOR[2] .. attri_type.."+"..tostring(attri_value))


	-- local dujie_config = DjConfig:get_dj_config_by_index(jingjie);
	-- self.awardMoney_text:setText(c3_orange.."×"..dujie_config.awardMoneyNum)

	--是否出现分享按钮
	local show_share_btn = false;
	local off_x = 84;
	frist = 1;
	if frist == 1  then
		-- 第一次渡过每一个关卡才会有分享按钮出现
		show_share_btn = true;
		off_x = 0
	end

	self.btn1 = ZImageButton:create(self.view,UILH_NORMAL.special_btn2,
	 	UILH_HUGUO.jiangli,dujie_succss_btn,575, 90);
	self.btn1.view:setIsVisible(false);
	if show_share_btn then
		local function share_func( eventType )
			-- if eventType == TOUCH_CLICK then
				DujieModel:share_dujie_achievement( jingjie )
			-- end
			-- return true;
		end
	end

	self._callback= callback:new()
    local function timer_fun()
        dujie_succss_btn()
        -- self._timer:stop()
        -- self._timer = nil
    end
    self._callback:start(20,timer_fun)
	--元宝奖励隐藏
	-- self.awardMoney_text:setIsVisible(true)
	-- self.yb_image:setIsVisible(true)

	-- 注册背景事件，点击背景同点击确定是一样的效果
	-- local function click_func( eventType )
	-- 	print("============343")
	-- 	if eventType == TOUCH_CLICK then
	-- 		print("===========345")
	-- 		dujie_succss_btn()
	-- 	end
	-- 	return true;
	-- end
	-- self.right_panel.view:registerScriptHandler(click_func)

	-- 执行action
	self:do_action( true ,star );
end


--创建渡劫失败界面
function DujieResultWin:create_fail_panel(  )

	self.lelf_panel.view:setIsVisible( false )

	-- 失败小窗口
	self.fail_win = CCBasePanel:panelWithFile( 260, 190, 405, 260, UILH_COMMON.style_bg, 500, 500)
	self.view:addChild(self.fail_win)

	--title
	self.fail_title = CCBasePanel:panelWithFile( 44, 217, -1, -1, UILH_COMMON.title_bg )
	self.fail_win:addChild( self.fail_title )
	local title_img = CCZXImage:imageWithFile( 87, 18, -1, -1, UILH_HUGUO.task_failed )
	self.fail_title:addChild( title_img )

	-- 内容面板
	self.cont_panel = CCBasePanel:panelWithFile( 20, 18, 365, 205, UILH_COMMON.bottom_bg, 500, 500)
	self.fail_win:addChild(self.cont_panel)

	local up_lab = UILabel:create_lable_2( LH_COLOR[2] .. Lang.huguo[8], 116, 144, 16, ALIGN_LEFT )
	self.cont_panel:addChild( up_lab )
	local down_lab = UILabel:create_lable_2( LH_COLOR[2] .. Lang.huguo[9], 116, 113, 16, ALIGN_LEFT )
	self.cont_panel:addChild( down_lab )

	-- 分割线
	local line = CCZXImage:imageWithFile( 20, 80, 340, 3, UILH_COMMON.split_line )     
    self.cont_panel:addChild(line)

	-- 退出按钮
	-- self.btn1 = ZImageButton:create(self.view,UI_DujieWin_023,
	--  	UI_DujieWin_023,close_win,102, 22);
	-- self.btn1.view:setIsVisible(false);

	self.btn3 = ZTextButton:create(self.cont_panel,  
        Lang.huguo[10],
        UILH_COMMON.btn4_nor, 
        close_win, 
        204, 15, -1, -1)
	-- self.btn3.view:setIsVisible(false);


	-- 再来一次
	-- self.btn2 = ZImageButton:create(self.view,UI_DujieWin_024,
	-- 	UI_DujieWin_024,dujie_again,226,22);
	-- self.btn2.view:setIsVisible(false);

	self.btn2 = ZTextButton:create(self.cont_panel,  
        Lang.huguo[11],
        UILH_COMMON.btn4_nor, 
        dujie_again, 
        42, 15, -1, -1)
	-- self.btn2.view:setIsVisible(false);
	--元宝奖励隐藏
	-- self.awardMoney_text:setIsVisible(false)
	-- self.yb_image:setIsVisible(false)

	-- 注册背景事件，点击背景同点击退出按钮是一样的效果
	-- local function click_func( eventType )
	-- 	if eventType == TOUCH_CLICK then
	-- 		close_win()
	-- 	end
	-- 	return true;
	-- end
	-- self.right_panel.view:registerScriptHandler(click_func)

	-- 执行action
	-- self:do_action( false ,0 );
end

function DujieResultWin:destroy()
	if self._callback then
		self._callback:cancel()
		self._callback = nil
	end
	if self._timer then
		self._timer:stop()
    	self._timer = nil
    end
    if timer_ then
    	timer_:stop()
    	timer_ = nil
    end
    if timer_cb then
    	timer_cb:cancel()
    	timer_cb = nil
    end
	Window.destroy(self)
end