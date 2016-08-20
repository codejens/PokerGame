-- DujieWin.lua
-- created by fangjiehua on 2013-2-1
-- 渡劫窗口
super_class.DujieWin(NormalStyleWindow)

local c3_blue	= "#c00c0ff";
local c3_green 	= "#c38ff33";

local temp_title_img = nil; -- 背景
local title_txt = nil;	--境界标题，会随着主角的境界提升而变化
local dujie_items = {};	--存放各个境界小关卡
local left_btn = nil;	--左侧按钮
local right_btn = nil;	--右侧按钮

local page_num = 1;		--页数，即一个境界一页，从练气起始


-- ui param
local align_x = 13	      -- panel边距
local cen_inter_h = 5     -- 中间分隔像素
local panel_h = 555       -- big_panel高度h
local panel_w = 880       -- big_panel宽度w
local panel_up_h = 452    -- 里面up_panel高度h
local panel_down_h = panel_h - panel_up_h - align_x*2- cen_inter_h -- 里面down_panel高度

-- ui item param
local item_w = 230
local item_h = 130
local i_align_x = 85
local i_inter_x = 20
local i_tnter_y =10

--关闭事件
local function close_fun( eventType, x, y )
	if eventType == TOUCH_CLICK then
		UIManager:hide_window("dujie_win");
	end
	return true;
end

-- 更新关卡信息
local function update_page_info( )
	local page_max = DujieModel:get_floor_max()/9
	if page_num > page_max then 
		page_num = page_max
	end
	-- print("----------page_num-----------",page_num)
	for i=0,8 do
		local item = dujie_items[i];
		local index = (i+1)+9*(page_num-1);
		local dujie_config = DjConfig:get_dj_config_by_index(index);
		dujie_config.index = index;

		local jingjie_index = DujieModel:get_current_jingjie_index();

		if jingjie_index == index then
			item:show_current_jingjie(dujie_config);
		else
			if index < jingjie_index then
				local dj_model = DujieModel:get_dujie_info();
				local yb_model = DujieModel:get_yb_info();

				dujie_config.star = dj_model[index];
				item:update(dujie_config)
				-- item:update_fetch_info(yb_model[index])
			else
				item.index = index
				item:update(nil);
				-- item:update_fetch_info(4)
			end
		end
	end
	-- local title = DujieModel:get_current_jingjie_title(page_num);
	-- print("--------page_num:", page_num)
	local title = DujieModel:get_cur_jingjie_title_txt( page_num )
	if title_img ~= nil then
		-- title_img:setTexture( title.img );
		-- title_img:setSize(title.w, title.h)
		-- title_txt:setText( LH_COLOR[1] .. title ) 
		-- (354, 44); (37, 22)
		if title_txt ~= nil then
			title_txt:removeFromParentAndCleanup(true)
		end
		title_txt = CCZXImage:imageWithFile( 356*0.5, (44)*0.5, -1, -1, title.img )
		title_txt:setAnchorPoint(0.5, 0.5)
		temp_title_img:addChild( title_txt )
	end
end

--更新按钮状态
local function update_btn_state(  )
	if page_num <= 1 then
		left_btn:setCurState(CLICK_STATE_DISABLE);
	else
		left_btn:setCurState(CLICK_STATE_UP);
	end
	if page_num >= 5 then
		right_btn:setCurState(CLICK_STATE_DISABLE);
	else
		right_btn:setCurState(CLICK_STATE_UP);
	end
end

--左侧按钮的事件
local function left_btn_event( eventType, x, y )
	if eventType == TOUCH_CLICK then
		if page_num > 1 then
			page_num = page_num-1;
			update_page_info();
			update_btn_state();
		end
	end
	return true;
end
--右侧按钮的事件
local function right_btn_event( eventType, x, y )
	if eventType == TOUCH_CLICK then
		if page_num < 5 then
			page_num = page_num+1;
			update_page_info();

			update_btn_state();
		end
	end
	return true;
end

--进入渡劫副本
local function enter_dujie_fuben( dujie_index )
	Instruction:handleUIComponentClick(instruct_comps.DUJIE_WIN_ITEM_BASE + dujie_index)
	-- flag 是否进去
	DujieModel:enter_dujie_fuben( dujie_index )

	-- 进入渡劫的同时关闭界面
	UIManager:destroy_window("dujie_win");
end

--弹出说明框
local function show_desc_frame( eventType,x,y)
	if eventType == TOUCH_CLICK then
		 
		-- local text = c3_blue..LangGameString[910]..c3_green..LangGameString[911].. -- [910]="渡劫总共9个境界：" -- [911]="练气、筑基、结丹、元婴、化神、炼虚、合体、大乘、飞升。"
		-- 				c3_blue..LangGameString[912]..c3_green..LangGameString[913]..c3_blue..LangGameString[914].. -- [912]="每个境界又分9个阶段，故称" -- [913]="“九九重劫”" -- [914]="。相传，成功渡过“九九重劫”，即可羽化成仙，与天地同寿。"
		-- 				c3_green..LangGameString[915]; -- [915]="成功渡劫将获得永久属性奖励和称号奖励！"

		local text = Lang.huguo[2] .. LH_COLOR[1] .. Lang.huguo[3] .. LH_COLOR[15] ..  Lang.huguo[4]
		HelpPanel:show(3, UILH_NORMAL.title_tips,text,16);
	end
	return true;
end


--初始化
function DujieWin:__init( window_name, texture_name, is_grid, width, height )
 	
	--底板
	local bg_panel = CCZXImage:imageWithFile(10, 15, panel_w, panel_h, UILH_COMMON.normal_bg_v2, 500,500);
	self:addChild(bg_panel);
	local bg_panel_size = bg_panel:getSize()
	-- 底色
	local bg_panel_up = CCZXImage:imageWithFile(align_x, panel_down_h, panel_w-align_x*2, panel_up_h, UILH_COMMON.bottom_bg, 500, 500);
	bg_panel:addChild( bg_panel_up )
	local bg_panel_down = CCZXImage:imageWithFile(align_x, align_x, panel_w-align_x*2, panel_down_h, "" )
	bg_panel:addChild( bg_panel_down )
	-- local bg_panel_up = ZImage:create(bg_panel, UIResourcePath.FileLocate.common .."quan_bg.png", 2, 2, 752, -1, 0, 500, 500)
 	-- 标题
	-- local dujie_title_sp = CCZXImage:imageWithFile(764/2-230/2,441-45,226,46,UIResourcePath.FileLocate.common .. "win_title1.png");
	-- self:addChild(dujie_title_sp);
	-- --主角境界的标题
	-- title

	-- 官衔等级
	-- local temp_title_img = ZImage:create( self.view, UILH_HUGUO.piaoqi, 425, 45, -1, -1 )
	temp_title_img = CCBasePanel:panelWithFile( 450, 537, -1, -1, UILH_NORMAL.title_bg3 )
	self.view:addChild( temp_title_img )
	temp_title_img:setAnchorPoint(0.5,0.5)
	title_img = temp_title_img
	-- local temp_title_txt = UILabel:create_lable_2( Lang.huguo[1][1], 356*0.5, 17, 16, ALIGN_CENTER ) -- [541]="#cffff00活跃目标"
	-- temp_title_img:addChild( temp_title_txt )
	-- title_txt = temp_title_txt
	title_txt = CCZXImage:imageWithFile( 356*0.5, 13, -1, -1, UILH_HUGUO.post_1 )
	title_txt:setAnchorPoint(0.5, 0)
	temp_title_img:addChild( title_txt )
	-- temp_title_img:setPosition( 425,  45 )
	-- title_img = CCZXImage:imageWithFile(764/2-56,441-45+5,102,42,UIResourcePath.FileLocate.duJie .. "dujie_lianqi.png");
	-- self.view:addChild(title_img);

	-- 关闭按钮
	-- local close_btn = CCNGBtnMulTex:buttonWithFile(0, 0, -1, -1, UIResourcePath.FileLocate.common .. "close_btn_n.png")
	-- local exit_btn_size = close_btn:getSize()
 --    local spr_bg_size = self:getSize()
 --    close_btn:setPosition( spr_bg_size.width - exit_btn_size.width, spr_bg_size.height - exit_btn_size.height )
 --  	close_btn:addTexWithFile(CLICK_STATE_DOWN,UIResourcePath.FileLocate.common .. "close_btn_s.png")
 --  	--注册关闭事件
	-- close_btn:registerScriptHandler(close_fun) 
 --    self:addChild(close_btn)
 
 	--9个副本按钮
    for i=0,8 do
    	if dujie_items[i] == nil then
    		local item = DujieItemView:create();
    		item.view:setPosition(i_align_x+(item_w+i_inter_x)*(i%3), 380-(item_h+i_tnter_y)*(math.floor(i/3)));
    		--设置进入副本的回调方法
    		item:set_enter_func(enter_dujie_fuben);
	    	self:addChild(item)
	    	dujie_items[i] = item;
    	end
    end
    --左右侧按钮
	left_btn = CCNGBtnMulTex:buttonWithFile(32, 292, -1, -1, UILH_COMMON.arrow_normal)
  	left_btn:addTexWithFile(CLICK_STATE_DOWN, UILH_COMMON.arrow_normal )
	left_btn:registerScriptHandler(left_btn_event);
    self:addChild(left_btn)

    right_btn = CCNGBtnMulTex:buttonWithFile(838, 292, -1, -1, UILH_COMMON.arrow_normal)
  	right_btn:addTexWithFile(CLICK_STATE_DOWN, UILH_COMMON.arrow_normal )
  	right_btn:setFlipX( true )
	right_btn:registerScriptHandler(right_btn_event);
    self:addChild(right_btn)

    
    --说明
   local desc_lab = CCZXLabel:labelWithTextS(CCPointMake(60,50), LH_COLOR[2].. Lang.huguo[5], 16,ALIGN_LEFT); -- [916]="渡劫成功将获得永久属性奖励和称号奖励！"
	self:addChild(desc_lab);


	local btn_ask = UIButton:create_button(680, 40, -1, -1, UILH_NORMAL.wenhao, UILH_NORMAL.wenhao, UILH_NORMAL.wenhao )
	btn_ask:registerScriptHandler( show_desc_frame )
	self:addChild( btn_ask )
	local btn = UIButton:create_button( 730, 50, -1, -1, UILH_HUGUO.instruct, UILH_HUGUO.instruct, UILH_HUGUO.instruct )
	btn:registerScriptHandler( show_desc_frame )
	self:addChild( btn )
 
	-- local btn = MUtils:creat_mutable_btn( 600,15,{x=0,y=0,w=28,h=28},UIResourcePath.FileLocate.normal .. "common_question_mark.png",
	-- 											{x=30,y=5,w=83,h=18},UI_DujieWin_007,show_desc_frame);
	-- self:addChild(btn);

end

function DujieWin:active( show )
	if show == true then
		DujieModel:request_dujie_info();

		-- local curr_index = DujieModel:get_current_jingjie_index( )
		-- local curr_page = math.ceil(curr_index/9)
		-- page_num = curr_page
		-- --当任务需要在开启界面时做特殊调整
		-- if TaskModel:if_task_accpet(1029) then 
		-- 	page_num = 1
		-- end
		-- ----------------------------------

		-- update_page_info()
		-- update_btn_state()
	else
		local help_win = UIManager:find_visible_window("help_panel")
		if help_win ~= nil then
			UIManager:hide_window("help_panel")
		end
		if TaskModel:if_task_accpet(1029) then 
			local target_str,content_str,tab_awards,is_finish,time = TaskModel:get_task_str_by_task_id(1029,1)
			if is_finish then 
				AIManager:do_quest(1029);
			end
		end
	end

	-- 新手指引代码
	--[[if ( XSZYManager:get_state() == XSZYConfig.DU_JIE_ZY  ) then
		if ( show ) then
			-- 指向渡劫一阶 94,305,47, 53,
			XSZYManager:play_jt_and_kuang_animation_by_id( XSZYConfig.DU_JIE_ZY,1, XSZYConfig.OTHER_SELECT_TAG );
		else
			XSZYManager:destroy_jt(XSZYConfig.OTHER_SELECT_TAG);
		end
	elseif ( XSZYManager:get_state() == XSZYConfig.DU_JIE_ZY2 ) then
		if ( show ) then
			-- 指向渡劫二阶 94,305,47, 53,
			XSZYManager:play_jt_and_kuang_animation_by_id( XSZYConfig.DU_JIE_ZY2 ,1, XSZYConfig.OTHER_SELECT_TAG );
		else
			XSZYManager:destroy_jt(XSZYConfig.OTHER_SELECT_TAG);
		end
	end--]]
end

function DujieWin:update( )
	local curr_index = DujieModel:get_current_jingjie_index( )
	local curr_page = math.ceil(curr_index/9)
	page_num = curr_page
	--当任务需要在开启界面时做特殊调整
	if TaskModel:if_task_accpet(1029) then 
		page_num = 1
	end
	----------------------------------

	update_page_info()
	update_btn_state()
	 -- update_page_info();
end

-- 销毁窗口下的子窗口
function DujieWin:destroy(  )

	for i=0,8 do
		local item = dujie_items[i];
		if item then 
			item:destroy();
			item = nil
			dujie_items[i] = nil
		end
	end
	
	Window.destroy(self);

end