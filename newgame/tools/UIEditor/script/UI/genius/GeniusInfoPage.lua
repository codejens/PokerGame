-- GeniusInfoPage.lua 
-- createed by mwy @2012-5-7
-- 精灵信息页面

super_class.GeniusInfoPage(  )

local _crystal_ids = {18603,18604,18605};

function GeniusInfoPage:__init(x,y )

	self.attr_t={}                  --存放增加人物属性每一行lable
	self.crystal_dict={}            --三个slotitem
    self.crestal_select_index = 1;  --晶石选择索引
    self._is_switch_select=false	--是否选择单选按钮

	local pos_x = x or 0
    local pos_y = y or 0
	self.view = CCBasePanel:panelWithFile( pos_x, pos_y, 835,465+60, nil, 500, 500 )

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
	local _right_panel = CCBasePanel:panelWithFile( 404+20, 13, 390+10,465+44, UI_MountsWinNew_004, 500, 500 )
	panel:addChild(_right_panel)

	self:initUI(_left_up_panel,_left_down_panel,_right_panel)
 
end
-- 加载UI
function GeniusInfoPage:initUI( left_up_panel,left_down_panel,right_panel)
	self:init_left_up_view(left_up_panel)
	self:init_left_down_view(left_down_panel)
	self:init_right_view(right_panel)
end

function GeniusInfoPage:init_right_view( right_panel)
	--增加属性标题
	local _left_down_title_panel = CCBasePanel:panelWithFile( 1, 436+44, 120, -1, UI_MountsWinNew_005, 500, 500 )
	right_panel:addChild(_left_down_title_panel)
	local name_title = CCZXImage:imageWithFile(27, 3,-1,-1,UI_GeniusWin_0016,500,500)
	_left_down_title_panel:addChild(name_title)

	local offset_y = 30
    -- 等级
	local level_lab =  UILabel:create_lable_2( "等  级 :", 30, 400+offset_y, 19, ALIGN_LEFT )
	right_panel:addChild(level_lab)

	-- 等级值
	self.level =  UILabel:create_lable_2( "#cfff000111", 120, 400+offset_y, 19, ALIGN_LEFT )
	right_panel:addChild(self.level)

	-- 经验
	local exp_lab =  UILabel:create_lable_2( "经验值 :", 30, 360, 19, ALIGN_LEFT )
	right_panel:addChild(exp_lab)

	-- 进度条
	self.progress_bar = ZXProgress:createWithValueEx(80,100,245,19,UI_GeniusWin_0030,UI_GeniusWin_0031,true);
	self.progress_bar:setProgressValue(0,100);	
	self.progress_bar:setAnchorPoint(CCPointMake(0,0));
	self.progress_bar:setPosition(CCPointMake(120,360-2));
	right_panel:addChild(self.progress_bar)

	for i=1,3 do
        local panel = CCBasePanel:panelWithFile( 70+(i-1)*100, 240, 62, 62, "" );
        right_panel:addChild(panel);
    	local item = MUtils:create_one_slotItem( _crystal_ids[i], 0, 0, 48, 48 );
        local function tip_func(  )
            TipsModel:show_shop_tip( 0, 0, _crystal_ids[i], TipsModel.LAYOUT_LEFT)
            self:selected_crystal(i);
            -- SlotEffectManager.play_effect_by_slot_item( self.crystal_dict[i] )
        end
        item:set_click_event(tip_func);
    	panel:addChild(item.view);
        self.crystal_dict[i] = item;

    	-- SlotEffectManager.play_effect_by_slot_item( item )
	end

	-- 点选按钮
	local yb=SpriteConfig:get_sprite_level_up_item(1).ybCost
	self.switch_but= self:create_one_switch_but( 30, 160, 160+140, 33, UIResourcePath.FileLocate.common .. 
        "dg-1.png", UIResourcePath.FileLocate.common .. "dg-2.png", (string.format(LangGameString[953],yb)), 33+5, 16,"kSwitch")
    right_panel:addChild( self.switch_but.view )
    self._is_switch_select=false
    self:config_change(1)

     -- 提升按钮
    local function btn_up_fun(eventType,x,y)
    	Instruction:handleUIComponentClick(instruct_comps.ANY_BTN)
    	local index = self.crestal_select_index
    	local selected =  self._is_switch_select
    	-- local itemid = _crystal_ids[index]
    	SpriteModel:req_up_fabao_level( index, selected )
        return true
    end
    -- local btn1= MUtils:create_btn(right_panel,UIPIC_COMMOM_002,UI_GeniusWin_0020,btn_up_fun,140,70,120,40)
    -- MUtils:create_zxfont(btn1,"提  升",126/2,15,2,16)

    local btn1=ZTextButton:create(right_panel,"提  升",UIPIC_COMMOM_002, btn_up_fun, 140,70,-1,-1, 1)

     -- 选中框
    -- self.crystal_select_frame = MUtils:create_zximg(right_panel, "nopack/ani_corner2.png", 59.5+5,238-5, 76, 80, 500, 500);

end	

function GeniusInfoPage:init_left_down_view( left_down_panel)
	--增加属性标题
	local _left_down_title_panel = CCBasePanel:panelWithFile( 1, 170+40, 120, -1, UI_MountsWinNew_005, 500, 500 )
	left_down_panel:addChild(_left_down_title_panel)
	local name_title = CCZXImage:imageWithFile(27, 3,-1,-1,UI_GeniusWin_0018,500,500)
	_left_down_title_panel:addChild(name_title)

	-- 基础属性和加成属性
	for i=1,4 do
			local _attr_bg = CCBasePanel:panelWithFile( 122, 20+(i-1)*50, 250+4, -1, UI_MountsWinNew_006, 500, 500 )
			left_down_panel:addChild(_attr_bg)

			local item_t = {}
			local arrt_lab =  UILabel:create_lable_2( "111", 5, 6, 19, ALIGN_LEFT )
			_attr_bg:addChild(arrt_lab)

			local arrt_lab_add =  UILabel:create_lable_2( "#c0edc09升级:0", 175, 6, 19, ALIGN_CENTER )
			_attr_bg:addChild(arrt_lab_add) 

			item_t.attr=arrt_lab           --属性基础值
			item_t.attr_add=arrt_lab_add   --属性升级值

			table.insert(self.attr_t,item_t)
	end
	local x = 30-3
	local y = 25
	local offset_y = 2
	--生命
	local hp_lab = UILabel:create_lable_2( "生    命", x, y*7+offset_y, 19, ALIGN_LEFT );
	left_down_panel:addChild(hp_lab);

	-- 攻击
	local at_lab = UILabel:create_lable_2( "攻    击", x,  y*5+offset_y, 19, ALIGN_LEFT );
	left_down_panel:addChild(at_lab);

	-- 幻术防御
	local md_lab = UILabel:create_lable_2( "物理防御", x,y*3+offset_y, 19, ALIGN_LEFT );
	left_down_panel:addChild(md_lab);

	-- 忍书防御
	local bj_lab = UILabel:create_lable_2( "精神防御", x,y+offset_y, 19, ALIGN_LEFT );
	left_down_panel:addChild(bj_lab);

end


-- 创建左上底版显示内容
function GeniusInfoPage:init_left_up_view( left_up_panel)
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
	
	-- 法宝形象
    local action = UI_GENIUS_ACTION;
    self.fabao_animate = MUtils:create_animation(201,142,"frame/gem/00001",action );
    self.fabao_panel:addChild(self.fabao_animate);

	--精灵名底色
	local name_bg = CCZXImage:imageWithFile(134, 228,145,-1,UI_MountsWinNew_016,500,500)
	self.fabao_panel:addChild(name_bg)

	-- 精灵名字 	
	self.fabao_name = UILabel:create_lable_2( "#cfff000白虎", 70, 6, 20, ALIGN_CENTER );
	name_bg:addChild(self.fabao_name);

	--切换化形标签页
	local function chengqi_event(eventType,x,y)
		if eventType == TOUCH_CLICK then
			local win = UIManager:find_visible_window( "genius_win" )
			if win then
				win.raido_btn_group:selectItem(5)
				win:Choose_panel( "huaxing" )
			end	
		end
		return true
	end

	--切换 
	self.chenge_btn = CCNGBtnMulTex:buttonWithFile(340,9,-1,-1,UI_MountsWinNew_023);
	self.fabao_panel:addChild(self.chenge_btn);
	self.qi_title_status = CCZXImage:imageWithFile(7,10,-1,-1,UI_GeniusWin_0035,500,500)
	self.chenge_btn:addChild(self.qi_title_status)
	self.chenge_btn:registerScriptHandler(chengqi_event);

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

	-- 战斗力底图
	local _power_bg = CCBasePanel:panelWithFile( 86-12,8,260, -1, UI_MountsWinNew_017, 500, 500 )
	self.fabao_panel:addChild(_power_bg)
	-- 战斗力文字
	local _power_title = CCZXImage:imageWithFile(60,17,-1,-1,UI_MountsWinNew_018)
    _power_bg:addChild(_power_title)
    -- 战斗力值
	self.fight_value = ZXLabelAtlas:createWithString("99999",UIResourcePath.FileLocate.normal .. "number");
	self.fight_value:setPosition(CCPointMake(130,17));
	self.fight_value:setAnchorPoint(CCPointMake(0,0));
	_power_bg:addChild(self.fight_value);

end

-- 选择晶片
function GeniusInfoPage:selected_crystal( i )
    local yb,x ;
    i = i or self.crestal_select_index
    if i==1 then
        yb = SpriteConfig:get_sprite_level_up_item(1).ybCost
        x = 59.5+5;
    elseif i == 2 then
        yb = SpriteConfig:get_sprite_level_up_item(2).ybCost
        x = 59.5+100+5;
    elseif i == 3 then
        yb = SpriteConfig:get_sprite_level_up_item(3).ybCost
        x = 59.5+200+5;
    end
    -- -- self.use_yb.setString(string.format(LangGameString[953],yb)); -- [953]="材料不足时，使用%d元宝代替"
    self.switch_but.setString(string.format(LangGameString[953],yb));
    -- -- 移动
    -- local move_to = CCMoveTo:actionWithDuration(0.3, CCPointMake(x,238-2));
    -- local act_easa = CCEaseExponentialOut:actionWithAction(move_to);
    -- self.crystal_select_frame:runAction(act_easa);
    self.crestal_select_index = i or 1;
	local spr = SlotEffectManager.play_effect_by_slot_item( self.crystal_dict[self.crestal_select_index] )
	spr:setPosition(CCPointMake(24, 24))
end

-- 创建一个选择控件
function GeniusInfoPage:create_one_switch_but( x, y, w, h, image_n, image_s, words, words_x, fontsize, but_key )
    local function switch_button_func(  )
        self:config_change( but_key )
    end
    local switch_but = UIButton:create_switch_button( x, y, w, h, image_n, image_s, words, words_x, fontsize, nil, nil, nil, nil, switch_button_func )
    switch_but.but_key = but_key
    return switch_but
end

-- 选项发生改变
function GeniusInfoPage:config_change( but_key )
    self._is_switch_select = self.switch_but.if_selected
end

function GeniusInfoPage:update( )
	-- body
	self:update_sprite_info(  )

end

-- 更新精灵信息
function GeniusInfoPage:update_sprite_info(  )
	 local sprite_info = SpriteModel:get_sprite_info( ) 
    if sprite_info then
        -- 更新精灵属性
        local spriteName = SpriteModel:get_spritename()
        local level_config = SpriteConfig:get_spirits_level(sprite_info.level);

        self.fabao_name:setText(spriteName);
        self.level:setText("#cfe8300"..sprite_info.level )
        self.fight_value:init(tostring(sprite_info.fight_value))
        
        self.progress_bar:setProgressValue( sprite_info.exp ,level_config.upExp );

        -- 获取精灵当前级别再升一级加成的属性
        local attr_t = SpriteConfig:get_spirits_attr_add(sprite_info.level,sprite_info.lunhui_level,sprite_info.lunhui_star_level)

        -- 四个基本属性
        -- 生命
		self.attr_t[4].attr:setText(tostring(sprite_info.attr_life))
		self.attr_t[4].attr_add:setText('#c0edc09升级:+'..tostring(attr_t.life_add))
		-- 攻击
		self.attr_t[3].attr:setText(tostring(sprite_info.attr_attack))
		self.attr_t[3].attr_add:setText('#c0edc09升级:+'..tostring(attr_t.attack_add))
		-- 物防
		self.attr_t[2].attr:setText(tostring(sprite_info.attr_wDefense))
		self.attr_t[2].attr_add:setText('#c0edc09升级:+'..tostring(attr_t.w_defence_add))
		-- 魔防
		self.attr_t[1].attr:setText(tostring(sprite_info.attr_mDefense))
		self.attr_t[1].attr_add:setText('#c0edc09升级:+'..tostring(attr_t.m_defence_add))

		-- print("更新晶石数量............................",num)
	    for i,item in ipairs(self.crystal_dict) do
	        local num = ItemModel:get_item_count_by_id( _crystal_ids[i] );
	        item:set_item_count(num);
	        if num == 0 then
	            item:set_icon_dead_color();
	        else
	            item:set_icon_light_color();
	        end
	    end
	    -- 更新法宝模型
	    self:update_current_sprite_avatar( sprite_info.model_id  )
	    self:selected_crystal(self.crestal_select_index)

	    -- 100级
	    if sprite_info.level >= 100 then
	    	for i,v in ipairs(self.attr_t) do
    			v.attr_add:setIsVisible(false)
    		end
    	end
    end
end
-- 更新当前法宝形象
function GeniusInfoPage:update_current_sprite_avatar( model_id )
    if self.fabao_animate then
        self.fabao_animate:removeFromParentAndCleanup(true);
    end
    local frame_str = string.format("frame/gem/%05d",model_id);
    local action = UI_GENIUS_ACTION;
    self.fabao_animate = MUtils:create_animation( 162+39,160-18,frame_str,action );
    self.fabao_panel:addChild( self.fabao_animate );
end

-- 升级成功更新ui
function GeniusInfoPage:update_level_info(got_exp,level,current_exp  )
	self.level:setString(level)
	local totle_xp = SpriteConfig:get_sprite_up_level_exp(level).upExp
	self.progress_bar:setProgressValue(current_exp,totle_xp);
	self:update_sprite_info()
end
-- 升级成功协议回调系修改4个基本属性
function GeniusInfoPage:update_stage_info_change()
	self:update_sprite_info()
end

--xiehande
--式神成长特效
function GeniusInfoPage:play_exp_success_effect(  )
	-- body
	LuaEffectManager:play_view_effect( 10015,660,390,self.view,false,999 )
end
