-- GeniusJinJiePage.lua 
-- createed by mwy @2012-5-7
-- 精灵信息页面
super_class.GeniusJinJiePage(  )

function GeniusJinJiePage:__init(x,y )
	self.attr_t={}                  --存放增加人物属性每一行lable

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
	local _right_panel = CCBasePanel:panelWithFile( 404+20, 13, 390+10,465+44, UI_MountsWinNew_004, 500, 500 )
	panel:addChild(_right_panel)

	self:initUI(_left_up_panel,_left_down_panel,_right_panel)

end
-- 加载UI
function GeniusJinJiePage:initUI( left_up_panel,left_down_panel,right_panel)
	self:init_left_up_view(left_up_panel)

	self:init_left_down_view(left_down_panel)

	self:init_right_view(right_panel)

	self:update()
	
end

function GeniusJinJiePage:init_right_view( right_panel)
	--增加属性标题
	local _left_down_title_panel = CCBasePanel:panelWithFile( 1, 436+40, 120, -1, UI_MountsWinNew_005, 500, 500 )
	right_panel:addChild(_left_down_title_panel)
	local name_title = CCZXImage:imageWithFile(27, 3,-1,-1,UI_GeniusWin_0038,500,500)
	_left_down_title_panel:addChild(name_title)

	local offset_y = 30
    -- 等阶
	local level_lab =  UILabel:create_lable_2( "等  阶 :", 30, 400+offset_y, 19, ALIGN_LEFT )
	right_panel:addChild(level_lab)
	-- 等阶值
	self.level =  UILabel:create_lable_2( "#cfff000111", 120, 400+offset_y, 19, ALIGN_LEFT )
	right_panel:addChild(self.level)
	-- 星级
	local level_star =  UILabel:create_lable_2( "星  级 :", 30, 360+offset_y, 19, ALIGN_LEFT )
	right_panel:addChild(level_star)
 	-- local start_bg = ZImage:create(_right_down_panel,nil, 110, 50, 220, -1, nil, 500, 500)	
	self.startLayer = CCLayerColor:layerWithColorWidthHeight(ccc4(0,0,0,0),254,360);
	self.startLayer:setPosition(CCPointMake(120,360-10+offset_y));
	right_panel:addChild(self.startLayer);
	MUtils:drawStart(self.startLayer,0);

	-- 成功率
	local level_secces =  UILabel:create_lable_2("成功率 :", 30, 320+offset_y, 19, ALIGN_LEFT )--LangGameString[2202]
	right_panel:addChild(level_secces)
	self.level_secces_value =  UILabel:create_lable_2( "#cfff00011", 120, 320+offset_y, 19, ALIGN_LEFT )
	right_panel:addChild(self.level_secces_value)
	self.level_secces_value_add =  UILabel:create_lable_2( "#cfff000+25%(祝福加成)", 200, 320+offset_y, 19, ALIGN_LEFT )
	right_panel:addChild(self.level_secces_value_add)

	-- 经验
	local exp_lab =  UILabel:create_lable_2( "祝福值 :", 30, 360-80+offset_y, 19, ALIGN_LEFT )
	right_panel:addChild(exp_lab)

	--祝福值:进度条
	self.progress_bar = ZXProgress:createWithValueEx(80,100,245,19,UI_GeniusWin_0030,UI_GeniusWin_0031,true);
	self.progress_bar:setProgressValue(100,100);	
	self.progress_bar:setAnchorPoint(CCPointMake(0,0));
	self.progress_bar:setPosition(CCPointMake(120,360-80+offset_y));
	right_panel:addChild(self.progress_bar)

	--羽翼晶片
    local panel = CCBasePanel:panelWithFile( 170, 250-54+offset_y-20, 62, 62, "" );
    right_panel:addChild(panel);
	local item = MUtils:create_one_slotItem(nil, 0, 0, 64, 64 );
	item:set_icon_bg_texture(UIPIC_ITEMSLOT, -4, -4, 72, 72);
	self._crystal_count_text = UILabel:create_label_1("", CCSizeMake(30,20), 10+38, 7, 14, CCTextAlignmentRight, 255, 255, 255);
    item.view:addChild(self._crystal_count_text,9);
    -- function SlotBase:set_color_frame( item_id, po_x, po_y, width_para, height_para )
    -- 显示灵咒石的tip
	local function tip_func(  )
	    local item_id = SpriteModel:get_curr_stage_crystal_item_id();
	    TipsModel:show_shop_tip( 400, 240, item_id );
	end
    item:set_click_event(tip_func);
	panel:addChild(item.view);
    self.slotItem = item;

	-- 点选按钮
	local function switch_but_fun(  )
		self._is_switch_select = self.switch_but.if_selected
	end

	self.switch_but= MUtils:create_one_switch_but( 35, 170-30, 160+140, 33, UIResourcePath.FileLocate.common .. 
        "dg-1.png", UIResourcePath.FileLocate.common .. "dg-2.png","材料不足时用%d元宝/绑元代替", 33+5, 18,"kSwitch",switch_but_fun)

    right_panel:addChild( self.switch_but.view )
    self._is_switch_select=false

    --忍币消耗提示
    self.rbCost_lab=MUtils:create_zxfont(right_panel,"需要忍币:%d",130,110,1,16)

    -- 提升按钮
    local function btn_up_fun(eventType,x,y)
        -- if eventType == TOUCH_CLICK then
        	-- Instruction:handleUIComponentClick(instruct_comps.GENIUS_WIN_JINJIE_BTN)
        	local selected =  self._is_switch_select
        	-- local itemid =SpriteModel:get_curr_stage_crystal_item_id( )
        	SpriteModel:req_upgrade_stage(selected )

        -- end
        return true
    end
    -- local btn1= MUtils:create_btn(right_panel,UIPIC_COMMOM_002,UI_GeniusWin_0020,btn_up_fun,140,50,120,40)
    -- MUtils:create_zxfont(btn1,"提  升",126/2,15,2,16)

    local btn1=ZTextButton:create(right_panel,"提  升",UIPIC_COMMOM_002, btn_up_fun, 140,30,-1,-1)


end	


-- 显示羽翼晶石图片及状态
function GeniusJinJiePage:show_yuli_crystal_img()
	-- 从背包获取当前阶级晶片的数量
    local count = SpriteModel:get_yuli_crystal_count()
	-- WingModel:get_curr_crystal_texture();
    local item_id = SpriteModel:get_curr_stage_crystal_item_id()
    -- print("===itemid: ", item_id)
    self.slotItem:set_icon(item_id)
    -- self.slotItem:set_color_frame(item_id,-2,-2,68,68);

    self.slotItem:set_icon_dead_color()
    -- 如果背包中相应阶晶石数为0，则置灰晶石图片
    if count <= 0 then
        self.slotItem:set_icon_dead_color();
        self._crystal_count_text:setText("");
    else
        self.slotItem:set_icon_light_color();
        self._crystal_count_text:setText("" .. tostring(count));
    end
end

function GeniusJinJiePage:init_left_down_view( left_down_panel)
	--增加属性标题
	local _left_down_title_panel = CCBasePanel:panelWithFile( 1, 170+40, 120, -1, UI_MountsWinNew_005, 500, 500 )
	left_down_panel:addChild(_left_down_title_panel)
	local name_title = CCZXImage:imageWithFile(27, 3,-1,-1,UI_GeniusWin_0018,500,500)
	_left_down_title_panel:addChild(name_title)

	-- 字体背景
	for i=1,4 do
			local _attr_bg = CCBasePanel:panelWithFile( 122, 20+(i-1)*50, 254, -1, UI_MountsWinNew_006, 500, 500 )
			left_down_panel:addChild(_attr_bg)

			local item_t = {}
			local arrt_lab =  UILabel:create_lable_2( "111", 5, 6, 19, ALIGN_LEFT )
			_attr_bg:addChild(arrt_lab)

			local arrt_lab_add =  UILabel:create_lable_2( "#c0edc09升级:00", 175,6, 19, ALIGN_CENTER )
			_attr_bg:addChild(arrt_lab_add)

			item_t.attr=arrt_lab        --属性基础值
			item_t.attr_add=arrt_lab_add--属性升级值

			table.insert(self.attr_t,item_t)
	end
	local x = 30-3
	local y = 25
	local offset_y = 2
	--生命
	local hp_lab = UILabel:create_lable_2( "生    命", x, y*7+offset_y, 19, ALIGN_LEFT );
	left_down_panel:addChild(hp_lab);

	-- 攻击
	local at_lab = UILabel:create_lable_2( "攻    击", x, y*5+offset_y, 19, ALIGN_LEFT );
	left_down_panel:addChild(at_lab);

	-- 幻术防御
	local md_lab = UILabel:create_lable_2( "物理防御", x,y*3+offset_y, 19, ALIGN_LEFT );
	left_down_panel:addChild(md_lab);

	-- 忍书防御
	local bj_lab = UILabel:create_lable_2( "精神防御", x,y+offset_y, 19, ALIGN_LEFT );
	left_down_panel:addChild(bj_lab);

end

-- 创建左上底版显示内容
function GeniusJinJiePage:init_left_up_view( left_up_panel)
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

	-- 式神名字 	
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
	self.fight_value = ZXLabelAtlas:createWithString("99999",UIResourcePath.FileLocate.normal .. "number");
	self.fight_value:setPosition(CCPointMake(130,17));
	self.fight_value:setAnchorPoint(CCPointMake(0,0));
	_power_bg:addChild(self.fight_value);

end

function GeniusJinJiePage:update( )
	-- body
	self:update_sprite_info(  )
end

function GeniusJinJiePage:active( show )
	if show then
		self:update()
	end
end

local _old_star_level = -1--升级后价格特效
-- 更新精灵信息
function GeniusJinJiePage:update_sprite_info(  )

	local sprite_info = SpriteModel:get_sprite_info( ) 
    if sprite_info then
		-- 更新法宝模型
	    self:update_current_sprite_avatar( sprite_info.model_id  )

        -- 更新精灵属性
        local spriteName = SpriteModel:get_spritename()

        self.fabao_name:setText(spriteName);
        self.level:setText("#cfe8300"..sprite_info.stage_level )
        self.fight_value:init(tostring(sprite_info.fight_value))

        -- 更新成功率
        local secce_values =SpriteModel:get_curr_stage_success_rate().."%"
        -- 祝福加成
        local secce_values_add = SpriteModel:get_curr_bless_ratio()

        self.level_secces_value:setText("#cfff000"..secce_values)
	    self.level_secces_value_add:setText("#ce519cb+"..secce_values_add.."%(祝福加成)")

	    if _old_star_level~=-1 and _old_star_level~=sprite_info.star_level then
	    	--进阶特效
	    	local spr = LuaEffectManager:play_view_effect( 16, 550, 250,self.view, false);
			spr:setPosition(CCPointMake(640, 410))

	    end 
	    _old_star_level=sprite_info.star_level
        --更新升星进度
         MUtils:drawStart(self.startLayer,sprite_info.star_level);

        -- 更新升阶进度
        -- print("self.progress_bar:setProgressValue( SpriteModel:get_curr_bless() ,10 );",SpriteModel:get_curr_bless())
        self.progress_bar:setProgressValue( SpriteModel:get_curr_bless() ,10 );

        -- 更新晶片个数
        self:show_yuli_crystal_img();

        --更新忍币消耗
        local  upItem_info = SpriteConfig:get_UpItemInfo_by_stage(sprite_info.stage_level)
        self.rbCost_lab:setText("需要忍币: "..upItem_info.xbCost)
        --更新材料不足元宝消耗
        local switch_but_lab=string.format("材料不足时用%d元宝/绑元代替",upItem_info.ybCost)
        self.switch_but.setString(switch_but_lab)
        --更新四个基本属性
        -- 生命
		self.attr_t[4].attr:setText(tostring(sprite_info.attr_life))
		-- 攻击
		self.attr_t[3].attr:setText(tostring(sprite_info.attr_attack))
		-- 物防
		self.attr_t[2].attr:setText(tostring(sprite_info.attr_wDefense))
		-- 魔防
		self.attr_t[1].attr:setText(tostring(sprite_info.attr_mDefense))
		-- 满阶后隐藏
    	if sprite_info.stage_level >= 10 and sprite_info.star_level >= 9 then
    		for i,v in ipairs(self.attr_t) do
    			v.attr_add:setIsVisible(false)
    		end
    		self.rbCost_lab:setText("需要忍币: "..0)
    		return
    	end
        -- 获取精灵当前级别再升一级加成的属性
      	-- local _sprite_info= SpriteModel:get_sprite_info()
        local attr_t = SpriteConfig:get_stage_attr_add(sprite_info.stage_level,sprite_info.star_level,sprite_info.lunhui_level,sprite_info.lunhui_star_level)
		self.attr_t[4].attr_add:setText('#c0edc09升星:+'..tostring(attr_t.life_add))
		self.attr_t[3].attr_add:setText('#c0edc09升星:+'..tostring(attr_t.attack_add))
		self.attr_t[2].attr_add:setText('#c0edc09升星:+'..tostring(attr_t.w_defence_add))
		self.attr_t[1].attr_add:setText('#c0edc09升星:+'..tostring(attr_t.m_defence_add))
    end
end

-- 更新当前法宝形象
function GeniusJinJiePage:update_current_sprite_avatar(model_id)
    if self.fabao_animate then
        self.fabao_animate:removeFromParentAndCleanup(true);
    end
    local frame_str = string.format("frame/gem/%05d",model_id);
    local action = UI_GENIUS_ACTION;
    self.fabao_animate = MUtils:create_animation( 162+39,160-18,frame_str,action );
    self.fabao_panel:addChild( self.fabao_animate );
    
end

--查看他人法宝
function GeniusJinJiePage:show_other_fabao( other_fabao )
    --  UIManager:hide_window("fabao_win");

    -- _is_other_fabao = true;
    -- _other_fabao_data = other_fabao;

    -- local win = UIManager:show_window("fabao_win");
    -- win:update_fabao_info();
    -- win:update_xianhun_loop();

    -- local fabao_info = FabaoModel:fabao_info_format( _other_fabao_data )
    -- win:update_current_fabao_avatar( fabao_info.jingjie )
end
-- 更新法宝形象预览
function GeniusJinJiePage:update_fabao_preview( index )
    -- 更新法宝形象
    if self.fabao_preview_animate then
        
        self.fabao_preview_animate:removeFromParentAndCleanup(true);

    end
    local frame_str = string.format("frame/gem/%05d",index);
    local action = UI_GENIUS_ACTION;
    self.fabao_preview_animate = MUtils:create_animation( 162+44,160-67-10,frame_str,action );
    self.fabao_panel:addChild( self.fabao_preview_animate );

    -- 更新法宝名字预览
    if self.fabao_name then
        
        local lv_1 = (index-1)*10 + 1;
        local lv_2 = index * 10;
        local name = string.format(LangGameString[969],lv_1,lv_2,fabao_name_list[index]); -- [969]="%d-%d级:%s"
        self.fabao_name:setText(name);
        
    end
end
-- 更新法宝属性
function GeniusJinJiePage:update_fabao_attr(  )
	for i,v in ipairs(self.attr_t) do
		print(i,v)

		v.attr:setString("1213131")
		v.attr_add:setString("121232132")

	end
end

-- 升级成功协议回调系修改4个基本属性
function GeniusJinJiePage:update_stage_info_change()
	self:update_sprite_info()
end


