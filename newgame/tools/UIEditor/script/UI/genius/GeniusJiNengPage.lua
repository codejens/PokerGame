-- GeniusJiNengPage.lua 
-- createed by mwy @2012-5-7
-- 精灵技能页面
super_class.GeniusJiNengPage(  )

-- 点选的技能图标
local _select_skill_index = 1
-- 当前翅膀技能等级的满级值
local SKILL_MAX_LV = 10;
local _show_skill_book_tip = false

function GeniusJiNengPage:__init(pos_x,pos_y )
	self.items_dict={}
	local pos_x = x or 0
    local pos_y = y or 0
	self.view = CCBasePanel:panelWithFile( pos_x, pos_y, 835, 465+60, nil, 500, 500 )

	-- 底板
	local panel = self.view
	-- 左上
	local _left_up_panel = CCBasePanel:panelWithFile( 11, 222-6-2+46, 390+20, 263, UI_MountsWinNew_004, 500, 500 )
	panel:addChild(_left_up_panel)
	self.avator_panel=_left_up_panel
	-- 左下
	local _left_down_panel = CCBasePanel:panelWithFile( 10, 13, 390+20, 200+40, UI_MountsWinNew_004, 500, 500 )
	panel:addChild(_left_down_panel)
	-- 右
	_right_panel = CCBasePanel:panelWithFile( 404+20, 13, 390+10,465+44, UI_MountsWinNew_004, 500, 500 )
	panel:addChild(_right_panel) 

	self:initUI(_left_up_panel,_left_down_panel,_right_panel)

	-- SlotEffectManager.play_effect_by_slot_item(self.items_dict[_select_skill_index]);
end

-- 加载UI
function GeniusJiNengPage:initUI( left_up_panel,left_down_panel,right_panel)
	self:init_left_up_view(left_up_panel)

	self:init_left_down_view(left_down_panel)

	self:init_right_view(right_panel)
	
end
-- 创建右底版显示内容
function GeniusJiNengPage:init_right_view( right_panel)
	--增加属性标题
	local _left_down_title_panel = CCBasePanel:panelWithFile( 1, 436+40, 120, -1, UI_MountsWinNew_005, 500, 500 )
	right_panel:addChild(_left_down_title_panel)
	local name_title = CCZXImage:imageWithFile(27, 3,-1,-1, "ui/geniues/title_effect.png",500,500)
	_left_down_title_panel:addChild(name_title)

	local offset_y = 30
	--技能名称
	self.skill_name = UILabel:create_lable_2( "", 5, 420+offset_y, 20,ALIGN_LEFT );
	right_panel:addChild(self.skill_name)

	 --技能效果
  	-- local effect_str = "";
  	-- local temp_skill_dialog = ZDialog:create( right_panel, effect_str,25+8, 430, 330, 80, 16 )
  	-- temp_skill_dialog:setAnchorPoint(0, 1)
  	-- temp_skill_dialog.view:setLineEmptySpace(2)
  	-- self.skill_effect = temp_skill_dialog.view
  	-- 失身xx阶段开启
  	self.cur_skill_desc = ZDialog:create( right_panel, effect_str,20, 380+40+offset_y-10, 330+50-15, 40, 17 )
  	self.cur_skill_desc:setAnchorPoint(0, 1)
  	self.cur_skill_desc.view:setLineEmptySpace(2)
  	--下级效果
  	self.next_skill_desc = ZDialog:create( right_panel, effect_str,20, 330+40-10+offset_y-5, 330+50-15, 40, 17 )
  	self.next_skill_desc:setAnchorPoint(0, 1)
  	self.next_skill_desc.view:setLineEmptySpace(2)
  	--上级效果
  	self.lv10_skill_desc = ZDialog:create( right_panel, effect_str,20, 280+40-10+offset_y-10, 330+50-15, 40, 17 )
  	self.lv10_skill_desc:setAnchorPoint(0, 1)
  	self.lv10_skill_desc.view:setLineEmptySpace(2)

	--分割线
    local fengge_bg = CCZXImage:imageWithFile(2,270-10,396,2,UIPIC_UserSkillWin_00012)
    right_panel:addChild(fengge_bg)

    -- 祝福值
	local zhufu_lab  = UILabel:create_lable_2( "#cfff000熟 练 度:", 60, 240-10, 18, ALIGN_CENTER );
	right_panel:addChild(zhufu_lab)

	-- 进度条
	self.progress_bar = ZXProgress:createWithValueEx(100,200,270,17,UI_GeniusWin_0030,UI_GeniusWin_0031,true);
	self.progress_bar:setProgressValue(100,100);	
	self.progress_bar:setAnchorPoint(CCPointMake(0,0));
	self.progress_bar:setPosition(CCPointMake(110,238-10));
	right_panel:addChild(self.progress_bar)

	-- slotitem
    local panel = CCBasePanel:panelWithFile( 170, 150-5, 62, 62, "" );
    right_panel:addChild(panel);
    -- 技能书
    local function tip_func(  )
        if _show_skill_book_tip == false then
  			return
  		end
  		local level = SpriteModel:get_sprite_info().skills_level[_select_skill_index]
  		if level then
  			local item_id = SpriteModel:get_skill_book_id_by_skill_level(level)

  			TipsModel:show_shop_tip( 400, 240, item_id )
  		end	
    end
	self.skill_book = MUtils:create_one_slotItem(nil, 0, 0, 48, 48 )
    self.skill_book:set_click_event(tip_func);
	panel:addChild( self.skill_book.view);
	self.book_count_text = UILabel:create_label_1("", CCSizeMake(30,20), 10+38, 7, 14, CCTextAlignmentRight, 255, 255, 255);
    self.skill_book.view:addChild(self.book_count_text,9);

	-- 点选按钮
	self._is_switch_select=false
	local  function switch_but_callback()
		 self._is_switch_select = self.switch_but.if_selected
	end


	self.switch_but = MUtils:create_one_switch_but( 40, 100, 160+130, 33, UIResourcePath.FileLocate.common .. 
        "dg-1.png", UIResourcePath.FileLocate.common .. "dg-2.png", "技能卷不足时用%元宝/绑元代替", 33+5, 16,"kSwitch",switch_but_callback)
    right_panel:addChild( self.switch_but.view )

    --忍币消耗提示
	self.rbCost_lab=MUtils:create_zxfont(right_panel,"需要忍币:%d",140,74,1,16)

     -- 提升按钮
    local function btn_up_fun(eventType,x,y)
        if eventType == TOUCH_CLICK then
        	local selected =  self._is_switch_select
        	SpriteModel:req_upgrade_skill(_select_skill_index,selected);
        end
        return true
    end
     --xiehande   UI_GeniusWin_0020 ->UIPIC_COMMOM_002   UI_GeniusWin_0050 ->UIPIC_COMMOM_004
    self.btn_ts= MUtils:create_btn(right_panel,UIPIC_COMMOM_002,UIPIC_COMMOM_002,btn_up_fun,140,10,-1,-1)
    MUtils:create_zxfont(self.btn_ts,"提升等级",25,20,1,16)
	self.btn_ts:addTexWithFile(CLICK_STATE_DISABLE,UIPIC_COMMOM_004)
end

-- 创建左下底版显示内容
function GeniusJiNengPage:init_left_down_view( left_down_panel)
	--增加属性标题
	local _left_down_title_panel = CCBasePanel:panelWithFile( 1, 170+40, 120, -1, UI_MountsWinNew_005, 500, 500 )
	left_down_panel:addChild(_left_down_title_panel)
	local name_title = CCZXImage:imageWithFile(27, 3,-1,-1,UI_GeniusWin_0021,500,500)
	_left_down_title_panel:addChild(name_title)

	-- 技能item
	local index = 1
	for i=1,2 do
		for j=1,5 do
			if index==10 then
				return
			end
	        local panel = CCBasePanel:panelWithFile( 20+(j-1)*77, 120-(i-1)*84, 62, 62, "" );
	        left_down_panel:addChild(panel);

	    	local skill_item = MUtils:create_one_slotItem(nil, 0, 0, 48, 48 );

	    	skill_item:set_icon_texture(SpriteConfig:get_skill_icon_by_id(index));

	    	local _index=index
	        local function tip_func(  )
	            self:selected_skill_item(_index);
	            self:update_skill_progress(_index);
	        end

	        skill_item:set_click_event(tip_func);
	        skill_item:set_select_effect_state(false)
	    	panel:addChild(skill_item.view);
	    	
	        self.items_dict[_index] = skill_item;
	        index = index+1
        end
	end
	self:selected_skill_item(1);
	self:update_skill_progress(1);
end
-- 点中了技能icon
function GeniusJiNengPage:selected_skill_item( skill_index )
	_select_skill_index=skill_index
	local spr = SlotEffectManager.play_effect_by_slot_item(self.items_dict[_select_skill_index]);
	spr:setPosition(CCPointMake(24, 24))
	--获取技能当前等级
	local skill_level =SpriteModel:get_skill_level(skill_index)

	-- ZXLog("----------------skill_level----------------",skill_level,skill_index)

	if skill_level~=0 then
		-- --技能名字
		self.skill_name:setText(SpriteModel:get_skill_name_by_index(skill_index)..'('..skill_level..'级)');
		--技能效果
		local cur, next, lv10 = self:get_skill_effect_desc( skill_index, skill_level);
		-- self.skill_effect:setText(text);

		self.cur_skill_desc:setText("#cfff000" .. cur)
		self.next_skill_desc:setText("#cfff000" .. next)
		self.lv10_skill_desc:setText("#cfff000" .. lv10)

		if skill_level >= 10 then
			self.rbCost_lab:setText("需要忍币: "..0)
			self.switch_but.view:setIsVisible(false)
			return
		end

		--更新忍币消耗
	    local  skill_up_info = SpriteConfig:get_spirits_skillLevelUp(skill_level)
	    self.rbCost_lab:setText("需要忍币: "..skill_up_info.xbCost)

	    --更新材料不足元宝消耗
	    local switch_but_lab=string.format("技能卷不足时用%d元宝/绑元代替",skill_up_info.ybCost)
	    self.switch_but.setString(switch_but_lab)

	    self.btn_ts:setCurState(CLICK_STATE_UP)
	else
		-- --技能名字
		self.skill_name:setText(SpriteModel:get_skill_name_by_index(skill_index)..'('..skill_level..'级)');

	 	local text = string.format(LangGameString[2178],skill_index+1); -- [2178]="#cfff000式神%d阶开启"
	 	self.cur_skill_desc:setText(text)

	 	local cur, next, lv10 = self:get_skill_effect_desc(skill_index, 0);
	 	self.next_skill_desc:setText("#ca7a7a6" .. next)
		self.lv10_skill_desc:setText("#cfff000" .. lv10)

	 	--更新忍币消耗
	    local  skill_up_info = SpriteConfig:get_spirits_skillLevelUp(1)
	    self.rbCost_lab:setText("需要忍币: "..skill_up_info.xbCost)

	    --更新材料不足元宝消耗
	    local switch_but_lab=string.format("技能卷不足时用%d元宝/绑元代替",skill_up_info.ybCost)
	    self.switch_but.setString(switch_but_lab)

	    self.btn_ts:setCurState(CLICK_STATE_DISABLE)
	end

	
end
function GeniusJiNengPage:get_skill_effect_desc( skill_index, skill_level  )
	local cur_skill_desc = ""
	local next_skill_desc = ""
	local lv10_skill_desc = ""

	-- [2179]="#r#c00ff00技能效果："  [2180]="#r#c00ff00下级效果："  [2181]="#r#c00ff0010级效果："
	local effect_name = {LangGameString[2179], LangGameString[2180], LangGameString[2181]}
	local skill_desc, effects, other_effects, sign = SpriteModel:get_effect_by_index(skill_index);

    cur_skill_desc = effect_name[1] .. skill_desc[1] .. effects[1] .. sign ..skill_desc[2] .. other_effects[1] .. skill_desc[3]
	next_skill_desc = effect_name[2] .. skill_desc[1] .. effects[2] .. sign ..skill_desc[2] .. other_effects[2] .. skill_desc[3]
	lv10_skill_desc = effect_name[3] .. skill_desc[1] .. effects[3] .. sign ..skill_desc[2] .. other_effects[3] .. skill_desc[3]

	if skill_level >= 10 then
		next_skill_desc = "已满级"
	end

    return cur_skill_desc, next_skill_desc, lv10_skill_desc;
end


-- 创建左上底版显示内容
function GeniusJiNengPage:init_left_up_view( left_up_panel)
	-- 式神背景
	self.fabao_panel = CCBasePanel:panelWithFile( 1,1,390+20-2, 263-2, UI_GeniusWin_0013, 500, 500 )
	left_up_panel:addChild(self.fabao_panel)

	-- 底图边角
	local corner_1 = MUtils:create_sprite(self.fabao_panel,UI_GeniusWin_0052,20,241)
	corner_1:setRotation(270)

	local corner_2 = MUtils:create_sprite(self.fabao_panel,UI_GeniusWin_0052,389,241)

	-- 式神底圈
	local bottom_circle= CCZXImage:imageWithFile(74, 27,-1,-1,UI_GeniusWin_0051,500,500)
	self.fabao_panel:addChild(bottom_circle)

	-- 式神形象
    local action = UI_GENIUS_ACTION;
    self.fabao_animate = MUtils:create_animation(162+39,160-18,"frame/gem/00001",action );
    self.fabao_panel:addChild(self.fabao_animate);

	--精灵名底色
	local name_bg = CCZXImage:imageWithFile(134, 228,145,-1,UI_MountsWinNew_016,500,500)
	self.fabao_panel:addChild(name_bg)

	-- 精灵名字 	
	self.fabao_name = UILabel:create_lable_2( "#cfff000白虎", 70, 6, 20, ALIGN_CENTER );
	name_bg:addChild(self.fabao_name);

	--切换上下马的状态
	local function chengqi_event(eventType,x,y)
		if eventType == TOUCH_CLICK then
			-- MountsModel:ride_a_mount();	--修改model数据
			-- self:setMountsStatus(MountsModel:get_is_shangma())
			local win = UIManager:find_visible_window( "genius_win" )
			if win then
				win.raido_btn_group:selectItem(5)
				win:Choose_panel( "huaxing" )
			end	
		end
		return true
	end

	--切换 
	self.chengqi_btn = CCNGBtnMulTex:buttonWithFile(340,9,-1,-1,UI_MountsWinNew_023);
	self.fabao_panel:addChild(self.chengqi_btn);

	self.qi_title_status = CCZXImage:imageWithFile(7,10,-1,-1,UI_GeniusWin_0035,500,500)
	
	self.chengqi_btn:addChild(self.qi_title_status)

	self.chengqi_btn:registerScriptHandler(chengqi_event);

	-- 炫耀按钮事件
	local function xuanyao_event(eventType, x, y)	
		if eventType == TOUCH_CLICK then
			SpriteModel:req_xuanyao_event()
		end
		return true
	end

	-- 炫耀
	self.xuanyao_btn = CCNGBtnMulTex:buttonWithFile(14,9,-1,-1,UI_MountsWinNew_023,20,13)
	self.fabao_panel:addChild(self.xuanyao_btn)

	local qi_title_status = CCZXImage:imageWithFile(8,10,-1,-1,UI_MountsWinNew_024,500,500)
	self.xuanyao_btn:addChild(qi_title_status)

	self.xuanyao_btn:registerScriptHandler(xuanyao_event)

	-- 战斗力
	local _power_bg = CCBasePanel:panelWithFile( 86-12,8,260, -1, UI_MountsWinNew_017, 500, 500 )
	self.fabao_panel:addChild(_power_bg)
	-- 战斗力文字
	local _power_title = CCZXImage:imageWithFile(60,17,-1,-1,UI_MountsWinNew_018)
    _power_bg:addChild(_power_title)
    -- 战斗力值
	self.mounts_fight = ZXLabelAtlas:createWithString("99999",UIResourcePath.FileLocate.normal .. "number");
	self.mounts_fight:setPosition(CCPointMake(130,17));
	self.mounts_fight:setAnchorPoint(CCPointMake(0,0));
	_power_bg:addChild(self.mounts_fight);


end

function GeniusJiNengPage:update( )
	-- body
	self:update_sprite_info(  )
end

-- 更新技能信息
function GeniusJiNengPage:update_sprite_info( _is_reload)
	local sprite_info =SpriteModel:get_sprite_info()
    if sprite_info then

        -- 更新精灵属性
        local spriteName = SpriteModel:get_spritename()

        self.fabao_name:setText(spriteName);
        self.mounts_fight:init(tostring(sprite_info.fight_value))

        local count = SpriteModel:get_skill_count()

        print("GeniusJiNengPage:update_sprite_info(skill_count)",count)
        for i,v in ipairs(self.items_dict) do
        	if i>count then
        		v:set_icon_dead_color();
        	else
        		v:set_icon_light_color();
        	end	
        end
        -- 更新进度条
		self:update_skill_progress(_select_skill_index);
		-- 更新技能说明
		self:selected_skill_item(_select_skill_index)
	
		-- 更新模型
		self:update_current_sprite_avatar( sprite_info.model_id  )
    end
end

-- 更新进度条
function GeniusJiNengPage:update_skill_progress( skill_index )

	local skill_level = (SpriteModel:get_sprite_info()).skills_level[skill_index];
	if skill_level then
		if skill_level >= 10 then 
		-- 满级后
		self.progress_bar:setProgressValue( 0, 0);
		-- self.need_money:setText(LangGameString[2177]); -- [2177]="#c00c0ff需要仙币:#cfff0000"
		else 
			local exps = SpriteModel:get_exp_values(skill_index);
			-- print( "----------更新技能熟练度--------------", exps[1], exps[2] );
			self.progress_bar:setProgressValue( exps[1], exps[2]);
			--需要的仙币  
			-- self.need_money:setText(LangGameString[2182]..WingModel:get_xb_value_by_skill_index(skill_index)); -- [2182]="#c00c0ff需要仙币:#cfff000"
		end

		if skill_level >= 7 then
			self.switch_but.set_state(false, true)
			self.switch_but.view:setIsVisible(false)
		else
			self.switch_but.view:setIsVisible(true)
		end
	end
	--更新羽翼卷轴
	self:update_skill_book(skill_index);
end


--更新羽翼技能卷轴
function GeniusJiNengPage:update_skill_book( skill_index )

	local skill_level = (SpriteModel:get_sprite_info()).skills_level[skill_index];
	if not skill_level then
		return
	end

	if skill_level == 0  or skill_level >= SKILL_MAX_LV then
		-- 如果技能等级为0，则不显示卷轴图标
		self.skill_book:set_icon_texture("");
		self.skill_book:set_item_count( 0 );
		self.book_count_text:setText("")
		_show_skill_book_tip = false
	else
		_show_skill_book_tip = true
		self.skill_book:set_icon_texture("icon/item/"..WingModel:get_skill_book_icon_id_by_skill_level(skill_level)..".pd");
		--self.skill_book:set_icon_texture("icon/item/"..WingModel:get_skill_book_icon_id_by_skill_level(skill_level)..".png");
		-- 羽翼卷轴的数量
		local count = SpriteModel:get_skill_book_count( skill_index )
		-- print("===count: ", count)
		if count == 0 then
			self.skill_book:set_icon_dead_color( );
			self.skill_book:set_item_count( 0 );
			self.book_count_text:setText("0")
		else 
			self.skill_book:set_item_count( count );
			self.book_count_text:setText("")
		end
	end
	self.icon_id = SpriteModel:get_skill_book_icon_id_by_skill_level(skill_level)
end
-- 更新当前式神形象
function GeniusJiNengPage:update_current_sprite_avatar( jingjie )
    if self.fabao_animate then
        self.fabao_animate:removeFromParentAndCleanup(true);
    end
    local frame_str = string.format("frame/gem/%05d",jingjie);
    local action = UI_GENIUS_ACTION;
    self.fabao_animate = MUtils:create_animation( 162+39,160-18,frame_str,action );
    self.fabao_panel:addChild( self.fabao_animate );
end

--xiehande
--播放 式神技能 特效
function GeniusJiNengPage:play_jineng_success_effect(  )
	-- body
	LuaEffectManager:play_view_effect(10015,660,260,self.view,false,999 )
end
