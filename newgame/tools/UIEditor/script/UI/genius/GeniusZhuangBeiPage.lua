-- GeniusZhuangBeiPage.lua 
-- createed by mwy @2012-5-7
-- 精灵装备页面
super_class.GeniusZhuangBeiPage(  )

function GeniusZhuangBeiPage:__init(pos_x,pos_y )
	self.skill_dict={}
	local pos_x = pos_x or 0
    local pos_y = pos_y or 0
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
end
-- 加载UI
function GeniusZhuangBeiPage:initUI( left_up_panel,left_down_panel,right_panel)
	self:init_left_up_view(left_up_panel)
	self:init_right_view(right_panel)
	self:init_left_down_view(left_down_panel)
end

-- 创建右底版显示内容
function GeniusZhuangBeiPage:init_right_view( right_panel)
	--增加属性标题
	local _left_down_title_panel = CCBasePanel:panelWithFile( 1, 436+44, 120, -1, UI_MountsWinNew_005, 500, 500 )
	right_panel:addChild(_left_down_title_panel)
	local name_title = CCZXImage:imageWithFile(27, 0,-1,-1,UI_GeniusWin_0040,500,500)
	_left_down_title_panel:addChild(name_title)

	local __offset_y = 30

	-- slotitem
    local panel = CCBasePanel:panelWithFile( 170, 370+__offset_y, 62, 62, "" );
    right_panel:addChild(panel);
	local item = MUtils:create_one_slotItem(nil, 0, 0, 48, 48 );
    local function tip_func(  )
        -- TipsModel:show_shop_tip( 0, 0, _crystal_ids[0], TipsModel.LAYOUT_LEFT)
    end
    item:set_click_event(tip_func);
	panel:addChild(item.view);
    self.slotItem = item;
    self.selected_index=1
    --道具名
    local title_panel = CCBasePanel:panelWithFile( 170-25, 322+__offset_y, -1, -1, UI_GeniusWin_0024 );
    right_panel:addChild(title_panel)
    self.item_name = UILabel:create_lable_2( "#cfff000", 60,7, 17, ALIGN_CENTER );
	title_panel:addChild(self.item_name);

	---------------------第一页---------------------
	local pre_panel=  CCBasePanel:panelWithFile( 10, 150+__offset_y, -1, -1, UI_GeniusWin_0025, 500, 500 )
	right_panel:addChild(pre_panel)
	
	local titile_bg = MUtils:create_zximg(pre_panel,UI_GeniusWin_0024,22,120,-1,-1);
	local curr_attr_lab = UILabel:create_lable_2( "#cfff000当前属性", 16,8, 16, ALIGN_LEFT )
	titile_bg:addChild(curr_attr_lab)

	local p_x = 10
	local offset_x = 83
	local offset_y = -5
	local fontsize = 16
	-- 闪耀级别
	self.curr_level_text = UILabel:create_lable_2( "#c33a6ee ", p_x, 83+offset_y, fontsize, ALIGN_LEFT )
	pre_panel:addChild(self.curr_level_text)
	-- 追加伤害
	self.curr_attr_text = UILabel:create_lable_2( "#c33a6ee ", p_x, 43+offset_y, fontsize, ALIGN_LEFT )
	pre_panel:addChild(self.curr_attr_text)

	---------------------第二页---------------------
	local next_panel =  CCBasePanel:panelWithFile( 236, 150+__offset_y, -1, -1, UI_GeniusWin_0025, 500, 500 )
	right_panel:addChild(next_panel)
	local titile_bg = MUtils:create_zximg(next_panel,UI_GeniusWin_0024,22,120,-1,-1);
	local curr_attr_lab = UILabel:create_lable_2( "#cfff000下级属性", 16,8, 16, ALIGN_LEFT )
	titile_bg:addChild(curr_attr_lab)

	-- 升级
	self.next_level_text = UILabel:create_lable_2( "#c33a6ee ", p_x, 83+offset_y, fontsize, ALIGN_LEFT )
	next_panel:addChild(self.next_level_text)
	-- 追加伤害
	self.next_attr_text = UILabel:create_lable_2( "#c33a6ee ", p_x, 43+offset_y, fontsize, ALIGN_LEFT )
	next_panel:addChild(self.next_attr_text)

	-------------------------------------------------

	--闪耀值
    local shanyao_lab = UILabel:create_lable_2( "领 悟 值:", 60,105+__offset_y, 19, ALIGN_CENTER );
	right_panel:addChild(shanyao_lab);

	-- 进度条
	self.progress_bar = ZXProgress:createWithValueEx(100,100,270,17,UI_GeniusWin_0030,UI_GeniusWin_0031,true);
	self.progress_bar:setProgressValue(100,100);	
	self.progress_bar:setAnchorPoint(CCPointMake(0,0));
	self.progress_bar:setPosition(CCPointMake(110,105+__offset_y));
	right_panel:addChild(self.progress_bar)

	-- 箭头
	MUtils:create_zximg(_right_panel,UI_GeniusWin_0026,164,250,-1,-1);
	-- 

	__offset_y=__offset_y-15
	-- 忍币提升
    local function btn_xb_fun(eventType,x,y)
        if eventType == TOUCH_CLICK then
			SpriteModel:req_upgrade_equip_stage(self.selected_index,1)
        end
        return true
    end
    --xiehande   UI_GeniusWin_0020 ->UIPIC_COMMOM_002
    self.btn_rbts= MUtils:create_btn(right_panel,UIPIC_COMMOM_002,UIPIC_COMMOM_002,btn_xb_fun,6,30+__offset_y,-1,-1)
	MUtils:create_zxfont(self.btn_rbts,"忍币提升",126/2,20,2,18)
	--UI_GeniusWin_0050
	self.btn_rbts:addTexWithFile(CLICK_STATE_DISABLE,UIPIC_COMMOM_004)
	-- 一键提升
    local function btn_50xb_fun(eventType,x,y)
        if eventType == TOUCH_CLICK then
        	SpriteModel:req_upgrade_equip_stage(self.selected_index,2)
        end
        return true
    end

    self.btn_yjts= MUtils:create_btn(right_panel,UIPIC_COMMOM_002,UIPIC_COMMOM_002,btn_50xb_fun,136,30+__offset_y,-1,-1)
	MUtils:create_zxfont(self.btn_yjts,"一键提升",126/2,20,2,18)
	--UI_GeniusWin_0050
	self.btn_yjts:addTexWithFile(CLICK_STATE_DISABLE,UIPIC_COMMOM_004)

	-- 元宝提升
    local function btn_yb_fun(eventType,x,y)
        if eventType == TOUCH_CLICK then
        	SpriteModel:req_upgrade_equip_stage(self.selected_index,3)
        end
        return true
    end
    --xiehande   UI_GeniusWin_0020 ->UIPIC_COMMOM_002
    self.btn_ybts= MUtils:create_btn(right_panel,UIPIC_COMMOM_002,UIPIC_COMMOM_002,btn_yb_fun,266,30+__offset_y,-1,-1)
	MUtils:create_zxfont(self.btn_ybts,"元宝提升",126/2,20,2,18)
	--UI_GeniusWin_0050
	self.btn_ybts:addTexWithFile(CLICK_STATE_DISABLE,UIPIC_COMMOM_004)
	-- -- 今日完成值
	self.finish_text = UILabel:create_lable_2( "#cfff000今日:0/0", 330,80+__offset_y+5+5, 16, ALIGN_CENTER )
	right_panel:addChild(self.finish_text)

	self.XB_text = UILabel:create_lable_2( "#c0edc097000忍币", 70,10+__offset_y-5, 16, ALIGN_CENTER )
	right_panel:addChild(self.XB_text)

	self.XB10_text = UILabel:create_lable_2( "#c0edc09忍币提升20次", 200,10+__offset_y-5, 16, ALIGN_CENTER )
	right_panel:addChild(self.XB10_text)

	self.YB_text = UILabel:create_lable_2( "#c0edc090元宝/绑元", 335,10+__offset_y-5, 16, ALIGN_CENTER )
	right_panel:addChild(self.YB_text)

end
function GeniusZhuangBeiPage:init_left_down_view( left_down_panel)
	--增加属性标题
	local _left_down_title_panel = CCBasePanel:panelWithFile( 1, 170+40, 120, -1, UI_MountsWinNew_005, 500, 500 )
	left_down_panel:addChild(_left_down_title_panel)
	local name_title = CCZXImage:imageWithFile(27, 0,-1,-1,UI_GeniusWin_0017,500,500)
	_left_down_title_panel:addChild(name_title)

	--装备item
	local index = 1
	for i=1,2 do
		for j=1,4 do
	        local panel = CCBasePanel:panelWithFile( 45+(j-1)*80, 116-(i-1)*90, 62, 62, "" );
	        left_down_panel:addChild(panel);

	    	local equip_item = MUtils:create_one_slotItem(nil, 0, 0, 48, 48 );
	    	equip_item:set_icon_texture(SpriteConfig:get_equip_icon_by_id(index))

	    	local _index=index
	    	-- self:set_item_icon_text(equip_item,_index)
	        local function tip_func(  )
	            self:selecte_item(_index);
	            -- self:update_exp_progress(_index)
	        end
	        equip_item:set_click_event(tip_func);
	        equip_item:set_select_effect_state(false)
	    	panel:addChild(equip_item.view);

	        self.skill_dict[_index] = equip_item;
	        index = index+1
		end
	end
	self:selecte_item(1);
end

function GeniusZhuangBeiPage:selecte_item(index)
	self.selected_index = index
	local spr = SlotEffectManager.play_effect_by_slot_item(self.skill_dict[self.selected_index]);
	spr:setPosition(CCPointMake(24, 24))

	local equip_level = SpriteModel:get_equip_level(index)
	
	-- 按钮元宝显示
    self.XB_text:setText('#c0edc09'..SpriteModel:get_xb_upda_stage()..'忍币')
	self.YB_text:setText('#c0edc09'..SpriteModel:get_yb_up_stage_const()..'元宝/绑元')

	-- 进度条
	self:update_exp_progress(index)

	-- 提升次数
	local curr_times,max_times=SpriteModel:get_equip_upstage_times()
	self.finish_text:setText('今日:'..curr_times..'/'..max_times)

	if equip_level ~= 0 then 	
		-- 领悟等级
		local icon_level = SpriteModel:get_curr_equip_shanyao_stage( index)

		self.item_name:setText(self:get_item_icon_text(index)..'+'..icon_level)
		-- 改变图标显示
		self.slotItem:set_icon_texture(SpriteConfig:get_equip_icon_by_id( index ))

		-- 当前属性
		local current_shanyao_lelvel = SpriteModel:get_curr_equip_shanyao_stage( index)
		local curr_attr_add = SpriteModel:get_shanyao_attr_add( index,current_shanyao_lelvel)

		self.curr_level_text:setText('领悟级别:'.."#cfff000"..current_shanyao_lelvel)

		self.curr_attr_text:setText(curr_attr_add.type_add.."#cfff000"..curr_attr_add.attr_add)

		-- 下级属性
		local next_shanyao_lelvel =SpriteModel:get_next_equip_shanyao_next_stage( index)
		local next_attr_add = SpriteModel:get_shanyao_attr_add( index,next_shanyao_lelvel)
		self.next_level_text:setText('领悟级别:'.."#cfff000"..next_shanyao_lelvel)
		self.next_attr_text :setText(next_attr_add.type_add.."#cfff000"..next_attr_add.attr_add)

		self.btn_ybts:setCurState(CLICK_STATE_UP)
		self.btn_yjts:setCurState(CLICK_STATE_UP)
		self.btn_rbts:setCurState(CLICK_STATE_UP)

	else
		-- 领悟等级
		local icon_level = 1
		local str_name = string.format("#cfff000式神成长%d级开启",spirits_equip.levelLimit[index])

		self.item_name:setText(str_name)
		-- 改变图标显示
		self.slotItem:set_icon_texture('')
		self.slotItem:set_icon_text(self:get_item_icon_text(index))
		-- 当前属性
		local current_shanyao_lelvel = 1
		local curr_attr_add = SpriteModel:get_shanyao_attr_add( index,current_shanyao_lelvel)

		self.curr_level_text:setText('领悟级别:'.."#cfff000"..current_shanyao_lelvel)

		self.curr_attr_text:setText(curr_attr_add.type_add.."#cfff000"..curr_attr_add.attr_add)

		-- 下级属性
		local next_shanyao_lelvel = 2
		local next_attr_add = SpriteModel:get_shanyao_attr_add( index,current_shanyao_lelvel+1)
		self.next_level_text:setText('领悟级别:'.."#cfff000"..next_shanyao_lelvel)
		self.next_attr_text :setText(next_attr_add.type_add.."#cfff000"..next_attr_add.attr_add)

		self.btn_ybts:setCurState(CLICK_STATE_DISABLE)
		self.btn_yjts:setCurState(CLICK_STATE_DISABLE)
		self.btn_rbts:setCurState(CLICK_STATE_DISABLE)
	end
	
	-- self:update_sprite_info(false )

end

function GeniusZhuangBeiPage:set_item_icon_text(item,index)
	local text = nil
	if index==1 then
		text='开门'
	elseif index==2 then
		text='休门'
	elseif index==3 then
		text='生门'
	elseif index==4 then
		text='伤门'
	elseif index==5 then
		text='杜门'
	elseif index==6 then
		text='景门'
	elseif index==7 then
		text='死门'
	elseif index==8 then
		text='惊门'
	end
	item:set_icon_text(text)
end

function GeniusZhuangBeiPage:get_item_icon_text(index)
	local text = nil
	if index==1 then
		text='开门'
	elseif index==2 then
		text='休门'
	elseif index==3 then
		text='生门'
	elseif index==4 then
		text='伤门'
	elseif index==5 then
		text='杜门'
	elseif index==6 then
		text='景门'
	elseif index==7 then
		text='死门'
	elseif index==8 then
		text='惊门'
	end
	return text
end

-- 创建左上底版显示内容
function GeniusZhuangBeiPage:init_left_up_view( left_up_panel)
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

	--式神名底色
	local name_bg = CCZXImage:imageWithFile(134, 228,145,-1,UI_MountsWinNew_016,500,500)
	self.fabao_panel:addChild(name_bg)

	--式神名字 	
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

	--乘骑按钮 
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

function GeniusZhuangBeiPage:update( )
	-- body
	self:update_sprite_info(true )
end

-- 更新法宝信息
function GeniusZhuangBeiPage:update_sprite_info( is_first_load )
	local sprite_info = SpriteModel:get_sprite_info( ) 
    if sprite_info then
        -- 更新精灵属性
        local spriteName = SpriteModel:get_spritename()

        self.fabao_name:setText(spriteName);
        self.mounts_fight:init(tostring(sprite_info.fight_value))

        -- 更新装备个数icon
        local open_equip_count = SpriteModel:get_equip_count( )
        -- if open_equip_count>0 then
	        -- for i=1,open_equip_count do
	        -- 	local item = self.skill_dict[i]
	        -- 	local icon = SpriteConfig:get_equip_icon_by_id( i )
	        -- 	-- item:set_icon_texture(icon)
	        -- end
	    for i,v in ipairs(self.skill_dict) do
        	if i>open_equip_count then
        		v:set_icon_dead_color();
        	else
        		v:set_icon_light_color();
        	end	
        end
	        -- 更新闪耀数值
	        -- 第一次更新显示第一个技能的数据
        if is_first_load then
        	self:selecte_item(1)
        end
	    -- 进度条
		-- end 
		-- 更新法宝模型
	    self:update_current_sprite_avatar( sprite_info.model_id  )
	    self:selecte_item(self.selected_index)
    end
end

-- 更新进度条
function GeniusZhuangBeiPage:update_exp_progress( equip_index )
	-- print("GeniusZhuangBeiPage:update_exp_progress( equip_index )",equip_index)
	if SpriteModel:get_sprite_info().equips[equip_index] then
		local curr_exp = SpriteModel:get_sprite_info().equips[equip_index].exp;
		local curr_shanyao_level = SpriteModel:get_curr_equip_shanyao_stage(equip_index)
		local max_exp =  SpriteModel:get_max_shanyao_value_by_shanyao_level(curr_shanyao_level)
		self.progress_bar:setProgressValue(curr_exp, max_exp);
	else
		self.progress_bar:setProgressValue(0,0)
	end
end

-- 更新当前法宝形象
function GeniusZhuangBeiPage:update_current_sprite_avatar( jingjie )
    if self.fabao_animate then
        self.fabao_animate:removeFromParentAndCleanup(true);
    end

    local frame_str = string.format("frame/gem/%05d",jingjie);
    local action = UI_GENIUS_ACTION;
    self.fabao_animate = MUtils:create_animation( 162+39,160-18,frame_str,action );
    self.fabao_panel:addChild( self.fabao_animate );
end

--xiehande
--播放 八门遁甲 提升特效
function GeniusZhuangBeiPage:play_zhuangbei_success_effect(  )
	-- body
	LuaEffectManager:play_view_effect(16,630,380,self.view,false,999 )
end

