-- GeniusLunHuiPage.lua 
-- createed by mwy @2012-5-7
-- 精灵轮回页面

super_class.GeniusLunHuiPage(  )

function GeniusLunHuiPage:__init(pos_x,pos_y )
	self.attr_t={}
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
end

-- 加载UI
function GeniusLunHuiPage:initUI( left_up_panel,left_down_panel,right_panel)
	self:init_left_up_view(left_up_panel)

	self:init_left_down_view(left_down_panel)

	self:init_right_view(right_panel)
	
end

-- 创建右底版显示内容
function GeniusLunHuiPage:init_right_view( right_panel)
	--增加属性标题
	local _left_down_title_panel = 	CCBasePanel:panelWithFile( 1, 436+40, 120, -1, UI_MountsWinNew_005, 500, 500 )
	right_panel:addChild(_left_down_title_panel)
	local name_title = CCZXImage:imageWithFile(27, 3,-1,-1,UI_GeniusWin_0039,500,500)
	_left_down_title_panel:addChild(name_title)

	local fontsize = 18
	local offset_y = 30

	-- 轮回
	local lh_lab = UILabel:create_lable_2( "轮    回:", 35,408+offset_y, fontsize, ALIGN_LEFT )
	right_panel:addChild(lh_lab)
	self.lh_text = UILabel:create_lable_2( "#cfe83002", 30+100,408+offset_y, fontsize, ALIGN_LEFT )
	right_panel:addChild(self.lh_text)

	-- 星级.
	local level_lab= UILabel:create_lable_2( "星    级:", 35,378+offset_y, fontsize, ALIGN_LEFT )
	right_panel:addChild(level_lab)

	-- 星星
	self.startLayer = CCLayerColor:layerWithColorWidthHeight(ccc4(0,0,0,0),254,360);
	self.startLayer:setPosition(CCPointMake(130,367+offset_y));
	right_panel:addChild(self.startLayer);
	self:drawStart(self.startLayer,0);

	-- 属性加成
	self.attribute = ZTextImage:create(right_panel,"#ce519cb属性加成:",UI_MountsWinNew_016,fontsize,124,330+offset_y-10,-1,-1)

	-- 需要声望
	local weiwang_lab= UILabel:create_lable_2( "需要声望:", 35,310, fontsize, ALIGN_LEFT )
	right_panel:addChild(weiwang_lab)
	self.weiwang_text= UILabel:create_lable_2( "#cfff000999", 30+100,310, fontsize, ALIGN_LEFT )
	right_panel:addChild(self.weiwang_text)
	-- 当前忍币
	local rb_lab= UILabel:create_lable_2( "需要忍币:", 35+180,310, fontsize, ALIGN_LEFT )
	right_panel:addChild(rb_lab)
	self.rb_lab_text= UILabel:create_lable_2( "#cfff000999", 30+180+100,310, fontsize, ALIGN_LEFT )
	right_panel:addChild(self.rb_lab_text)
	-- 当前声望
	local cur_lab= UILabel:create_lable_2( "当前声望:", 35,277, fontsize, ALIGN_LEFT )
	right_panel:addChild(cur_lab)
	self.cur_weiwang_text= UILabel:create_lable_2( "#cfff000999", 30+100,277, fontsize, ALIGN_LEFT )
	right_panel:addChild(self.cur_weiwang_text)

	local function help_btn_callback( ... )
        require "UI/common/HelpPanel"
		HelpPanel:show( 3, UI_GeniusWin_0049,Lang.genius.lunhui_sm)
    end
	--说明
	local help_btn = ZButton:create(right_panel, UI_GeniusWin_0048, help_btn_callback, 275, 262, -1, -1)

	-- 感悟按钮
    local function btn_up_fun(eventType,x,y)
        -- if eventType == TOUCH_CLICK then
        	SpriteModel:req_upgrade_lunhui_stage( )
        -- end
        return true
    end
 --    local btn1= MUtils:create_btn(right_panel,UIPIC_COMMOM_002,UI_GeniusWin_0020,btn_up_fun,140,210,120,40)
	-- MUtils:create_zxfont(btn1,"#cffffff感悟",120/2,14,2,16)

	self.btn1=ZTextButton:create(right_panel,"#cffffff感悟",UIPIC_COMMOM_002, btn_up_fun, 140,200,-1,-1, 1)


	fontsize = fontsize - 4
	---------------------第一页---------------------
	local pre_panel=  CCBasePanel:panelWithFile( 10, 10, -1, -1, UI_GeniusWin_0023, 500, 500 )
	right_panel:addChild(pre_panel)

	local p_x = 5
	local offset_x = 83
	local offset_Y = 20
	-- 升级
	-- local lunhui_lab = UILabel:create_lable_2( "轮     回:", p_x, 113+offset_Y, fontsize, ALIGN_LEFT )
	-- pre_panel:addChild(lunhui_lab)
	-- self.lunhui_text = UILabel:create_lable_2( "#cfff0000转", p_x+offset_x, 113+offset_Y, fontsize, ALIGN_LEFT )
	-- pre_panel:addChild(self.lunhui_text)
	local lunhui_lab = UILabel:create_lable_2( "#cfff000当前轮回",34, 113+offset_Y, 18, ALIGN_LEFT )
	pre_panel:addChild(lunhui_lab)
	-- 属性最高加成
	local attr_lab = UILabel:create_lable_2( "最高加成:", p_x, 83+offset_Y, fontsize, ALIGN_LEFT )
	pre_panel:addChild(attr_lab)
	self.attr_text = UILabel:create_lable_2( "#cfff0000", p_x+offset_x, 83+offset_Y, fontsize, ALIGN_LEFT )
	pre_panel:addChild(self.attr_text)
	-- 等阶
	local max_lab = UILabel:create_lable_2( "最高等阶:", p_x, 53+offset_Y, fontsize, ALIGN_LEFT )
	pre_panel:addChild(max_lab)
	self.max_text = UILabel:create_lable_2( "#cfff0000", p_x+offset_x, 53+offset_Y, fontsize, ALIGN_LEFT )
	pre_panel:addChild(self.max_text)
	-- 技能
	local count_lab = UILabel:create_lable_2( "技能数量:", p_x, 20+offset_Y, fontsize, ALIGN_LEFT )
	pre_panel:addChild(count_lab)
	self.count_text = UILabel:create_lable_2( "#cfff0000", p_x+offset_x, 20+offset_Y, fontsize, ALIGN_LEFT )
	pre_panel:addChild(self.count_text)

	---------------------第二页---------------------
	local next_panel =  CCBasePanel:panelWithFile( 236, 10, -1, -1, UI_GeniusWin_0023, 500, 500 )
	right_panel:addChild(next_panel)
	-- 升级
	-- local lunhui_lab2 = UILabel:create_lable_2( "轮   回 :", p_x,113+offset_Y, fontsize, ALIGN_LEFT )
	-- next_panel:addChild(lunhui_lab2)
	-- self.lunhui_text2 = UILabel:create_lable_2( "#cfff0000转", p_x+offset_x, 113+offset_Y, fontsize, ALIGN_LEFT )
	-- next_panel:addChild(self.lunhui_text2)
	local next_lab = UILabel:create_lable_2( "#cfff000下一轮回",34, 113+offset_Y, 18, ALIGN_LEFT )
	next_panel:addChild(next_lab)
	-- 属性
	local attr_lab2 = UILabel:create_lable_2( "最高加成:", p_x, 83+offset_Y, fontsize, ALIGN_LEFT )
	next_panel:addChild(attr_lab2)
	self.attr_text2 = UILabel:create_lable_2( "#cfff0000", p_x+offset_x, 83+offset_Y, fontsize, ALIGN_LEFT )
	next_panel:addChild(self.attr_text2)
	-- 等阶
	local max_lab2= UILabel:create_lable_2( "最高等阶:", p_x, 53+offset_Y, fontsize, ALIGN_LEFT )
	next_panel:addChild(max_lab2)
	self.max_text2 = UILabel:create_lable_2( "#cfff0000", p_x+offset_x, 53+offset_Y, fontsize, ALIGN_LEFT )
	next_panel:addChild(self.max_text2)
	-- 技能
	local count_lab2 = UILabel:create_lable_2( "技能数量:", p_x, 20+offset_Y, fontsize, ALIGN_LEFT )
	next_panel:addChild(count_lab2)
	self.count_text2 = UILabel:create_lable_2( "#cfff0000", p_x+offset_x, 20+offset_Y, fontsize, ALIGN_LEFT )
	next_panel:addChild(self.count_text2)

	-- 箭头
	MUtils:create_zximg(_right_panel,UI_GeniusWin_0026,164,80,-1,-1);  
	
end

function GeniusLunHuiPage:init_left_down_view( left_down_panel)
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

			local arrt_lab_add =  UILabel:create_lable_2( "#c0edc09升级:0", 175, 6, 19, ALIGN_CENTER )
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
function GeniusLunHuiPage:init_left_up_view( left_up_panel)
	-- 式神背景
	self.fabao_panel = CCBasePanel:panelWithFile( 1,1,390+20-2, 263-2,UI_GeniusWin_0013,500,500)
	left_up_panel:addChild(self.fabao_panel)

	-- 底图边角
	local corner_1 = MUtils:create_sprite(self.fabao_panel,UI_GeniusWin_0052,20,241)
	corner_1:setRotation(270)

	local corner_2 = MUtils:create_sprite(self.fabao_panel,UI_GeniusWin_0052,389,241)

	-- 式神底圈
	local bottom_circle_1 = CCZXImage:imageWithFile(-4, 27,-1,-1,UI_GeniusWin_0051,500,500)
	self.fabao_panel:addChild(bottom_circle_1)

	local bottom_circle_2 = CCZXImage:imageWithFile(181, 27,-1,-1,UI_GeniusWin_0051,500,500)
	self.fabao_panel:addChild(bottom_circle_2)

	-- 式神轮回title
	local current_lh = ZImageImage:create(self.fabao_panel, UI_GeniusWin_0055, UI_MountsWinNew_016, 63, 204, -1, -1, 500, 500)
	local next_lh = ZImageImage:create(self.fabao_panel, UI_GeniusWin_0056, UI_MountsWinNew_016, 249, 204, -1, -1, 500, 500)

	-- 箭头
	local arrow = CCZXImage:imageWithFile(175, 130,-1,-1,UI_GeniusWin_0054,500,500)
	self.fabao_panel:addChild(arrow)

	-- 式神形象
    local action = UI_GENIUS_ACTION;
    self.fabao_animate = MUtils:create_animation(-4+39,160-18,"frame/gem/00001",action );
    self.fabao_panel:addChild(self.fabao_animate);

    -- 下轮式神形
    self.next_animate = MUtils:create_animation(181+39,160-18,"frame/gem/00002",action );
    self.fabao_panel:addChild(self.next_animate);

	-- --坐骑名底色
	-- local name_bg = CCZXImage:imageWithFile(134, 228,145,-1,UI_MountsWinNew_016,500,500)
	-- self.fabao_panel:addChild(name_bg)

	-- -- 坐骑名字 	
	-- self.fabao_name = UILabel:create_lable_2( "#cfff000白虎", 70, 6, 20, ALIGN_CENTER );
	-- name_bg:addChild(self.fabao_name);

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

function GeniusLunHuiPage:update( )
	-- body
	self:update_sprite_info(  )
end

local _old_star_level = -1--升级后价格特效
-- 更新式神信息
function GeniusLunHuiPage:update_sprite_info(  )
	local sprite_info = SpriteModel:get_sprite_info( ) 
    if sprite_info then
        -- 更新式神属性
        local spriteName = SpriteModel:get_spritename()
        -- self.fabao_name:setText(spriteName);
        self.mounts_fight:init(tostring(sprite_info.fight_value))

        -- 获取精灵当前级别再升一级加成的属性
        local attr_t = SpriteConfig:get_lunhui_attr_add(sprite_info.level,sprite_info.stage_level,sprite_info.star_level,sprite_info.lunhui_level,sprite_info.lunhui_star_level)
        --更新四个基本属性
        -- 生命
		self.attr_t[4].attr:setText(tostring(sprite_info.attr_life))
		-- 攻击
		self.attr_t[3].attr:setText(tostring(sprite_info.attr_attack))
		-- 物防
		self.attr_t[2].attr:setText(tostring(sprite_info.attr_wDefense))
		-- 魔防
		self.attr_t[1].attr:setText(tostring(sprite_info.attr_mDefense))
		----------------------------更新装备数据---------------------------
		-- 轮回等级
		local lunhui_curr_level = SpriteModel:get_curr_lunhui_stage()
		--轮回属性加成
		local lunhui_curr_attr_add= SpriteModel:get_curr_attr_add_limit()
		--轮回属性最高加成
		local lunhui_curr_attr_max_add = SpriteModel:get_curr_attr_max_add_limit()

		self.attribute:setText("#ce519cb属性加成:"..lunhui_curr_attr_add.."%")
		-- 闪耀
		-- local lunhui_curr_maxshanyao= SpriteModel:get_curr_stage_max_shanyao_level()
		-- 装备数量
		-- local lunhui_curr_quip_count= SpriteModel:get_curr_equip_count()
		--最高等阶
		local lunhui_curr_maxstage = SpriteModel:get_curr_max_stage_level()
		--技能数量
		local lunhui_curr_skillcount = SpriteModel:get_curr_stage_skillcount()

		-----------------------------更新阶级属性----------------------------
		-- self.lunhui_text:setText(lunhui_curr_level)
		-- 属性最高加成
		self.attr_text:setText("#cfff000"..lunhui_curr_attr_max_add.."%")
		-- 最高等阶
		self.max_text:setText("#cfff000"..lunhui_curr_maxstage.."阶")
		-- 技能数量
		self.count_text:setText("#cfff000"..lunhui_curr_skillcount)

		local lunhui_next_level = SpriteModel:get_next_lunhui_stage()
		local lunhui_next_attr_add= SpriteModel:get_next_attr_add_limit()
		-- local lunhui_next_quip_count= SpriteModel:get_next_equip_count()
		-- local lunhui_next_maxshanyao= SpriteModel:get_next_stage_max_shanyao_level()
		local lunhui_next_maxstage = SpriteModel:get_next_max_stage_level()
		local lunhui_next_skillcount = SpriteModel:get_next_stage_skillcount()

		-- self.lunhui_text2:setText(lunhui_next_level)
		self.attr_text2:setText("#cfff000"..lunhui_next_attr_add.."%")
		self.max_text2 :setText("#cfff000"..lunhui_next_maxstage.."阶")
		self.count_text2:setText("#cfff000"..lunhui_next_skillcount)

		---------------更新升星、声望、升阶需要仙币-------------------------
		--轮回
		self.lh_text:setText("#cfe8300"..lunhui_curr_level.."转")
		-- 需要声望
		self.weiwang_text:setText("#cfff000"..SpriteModel:need_renown_upgrade_star())
		-- 当前声望
		-- print("`````````````````SpriteModel:get_user_renown()",SpriteModel:get_user_renown())
		self.cur_weiwang_text:setText(SpriteModel:get_user_renown( ))
		-- 当前忍币
		self.rb_lab_text:setText(SpriteModel:need_xb_upgrade_star( ))
		-- 升星星

		local star_count = SpriteModel:get_curr_lunhui_star()

		if _old_star_level~=-1 and _old_star_level~=star_count then
	    	local spr = LuaEffectManager:play_view_effect( 16, 550, 250,self.view, false);
			spr:setPosition(CCPointMake(660, 430))
	    end 
	    _old_star_level=star_count

         self:drawStart(self.startLayer,star_count);

        -- 更新法宝模型
        -- print("sprite_info.model_id",sprite_info.model_id)
	    self:update_current_sprite_avatar( sprite_info.lunhui_level)

		if lunhui_curr_level >= 10 and star_count >= 9 then
			self.attr_t[4].attr_add:setIsVisible(false)
			self.attr_t[3].attr_add:setIsVisible(false)
			self.attr_t[2].attr_add:setIsVisible(false)
			self.attr_t[1].attr_add:setIsVisible(false)
		else
			self.attr_t[4].attr_add:setText('#c0edc09升星:+'..tostring(attr_t.life_add))
			self.attr_t[3].attr_add:setText('#c0edc09升星:+'..tostring(attr_t.attack_add))
			self.attr_t[2].attr_add:setText('#c0edc09升星:+'..tostring(attr_t.w_defence_add))
			self.attr_t[1].attr_add:setText('#c0edc09升星:+'..tostring(attr_t.m_defence_add))
		end
    end
end


-- 绘制星星
function GeniusLunHuiPage:drawStart(start_layer,start_count)
	-- 清楚所有星星
	start_layer:removeAllChildrenWithCleanup(true);
	for i=0,9 do
		local star = CCZXImage:imageWithFile(25*i,8,22,22,UIResourcePath.FileLocate.common .. "star_big.png");
		--star:addTexWithFile(CLICK_STATE_DISABLE, "ui/common/star_gray.png")
		star:setTag(i);
		self.startLayer:addChild(star);
		if i>(start_count-1) then 
			star:setCurState(CLICK_STATE_DISABLE);
		end
	end
end

-- 更新当前法宝形象
function GeniusLunHuiPage:update_current_sprite_avatar(lunhui_level )
    if self.fabao_animate then
        self.fabao_animate:removeFromParentAndCleanup(true);
    end

    if self.next_animate then
    	self.next_animate:removeFromParentAndCleanup(true);
    end 

    local curr_model_id = SpriteModel:get_sprite_modle_id(lunhui_level)
    local frame_str = string.format("frame/gem/%05d",curr_model_id);
    local action = UI_GENIUS_ACTION;
    self.fabao_animate = MUtils:create_animation( -4+120,160-18,frame_str,action );
    self.fabao_panel:addChild( self.fabao_animate );

    local sprite_info = SpriteModel:get_sprite_info( ) 
    local max_model_Id = SpriteConfig:get_max_model_id()
    local next_model_id = curr_model_id+1
    local max_lunhui = SpriteConfig:get_max_lunhui()

    if next_model_id > max_model_Id or sprite_info.lunhui_level>= max_lunhui then
    	next_model_id = max_model_Id
    end 

    frame_str = string.format("frame/gem/%05d",next_model_id);
    self.next_animate = MUtils:create_animation( 181+120,160-18,frame_str,action );
    self.fabao_panel:addChild( self.next_animate );

end