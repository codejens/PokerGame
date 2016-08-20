-- GeniusGetWin.lua 
-- createed by mwy@2014-5-25
-- 获取精灵窗口

super_class.GeniusGetWin(Window)

local vip_sprite_config={
	 baseAttrs = {   [1] = 110,   [2] = 20,   [3] = 20,   [4] = 20,},
	 name='残月幻影',
	 special_skill='#c0096ff特殊技能：生命上限+2%',
	 fight_value=1051,
}

function GeniusGetWin:__init( window_name, texture_name )

 	local bgPanel = self.view

 	local big_Panel = CCBasePanel:panelWithFile( 30, 20, 485, 587, UI_MountsWinNew_003, 500, 500 )
 	bgPanel:addChild(big_Panel)

 	local _left_panel = CCBasePanel:panelWithFile( 13, 15, 227, 555, UI_MountsWinNew_004, 500, 500 )
 	big_Panel:addChild(_left_panel)

 	local _right_panel = CCBasePanel:panelWithFile( 246,15, 227, 555, UI_MountsWinNew_004, 500, 500 )
	big_Panel:addChild(_right_panel)

	self:create_left_panel(_left_panel)
	self:create_right_panel(_right_panel)
	self:update_btn_status()
end


function GeniusGetWin:create_left_panel( panel )
	-- 式神背景
	self.fabao_panel = CCBasePanel:panelWithFile( 0,300,227, -1, UI_GeniusWin_0058, 500, 500 )
	panel:addChild(self.fabao_panel)

	-- 底图边角
	local corner_1 = MUtils:create_sprite(self.fabao_panel,UI_GeniusWin_0052,20,235)
	corner_1:setRotation(270)
	local corner_2 = MUtils:create_sprite(self.fabao_panel,UI_GeniusWin_0052,208,235)

	-- 式神形象
    local action = UI_GENIUS_ACTION;
    self.fabao_animate = MUtils:create_animation(65,190,"frame/gem/00001",action );
    self.fabao_panel:addChild(self.fabao_animate);

	-- --精灵名底色
	-- local name_bg = CCZXImage:imageWithFile(40,190,145,-1,UI_MountsWinNew_016,500,500)
	-- self.fabao_panel:addChild(name_bg)

	-- -- 精灵名字 	
	-- self.fabao_name = UILabel:create_lable_2( "#cfff000式神名称(永久)", 70, 6, 17, ALIGN_CENTER );
	-- name_bg:addChild(self.fabao_name);

	-- 人物模型
	local player = EntityManager:get_player_avatar()
    local equip_info = UserInfoModel:get_equi_info()
    self.showAvatar = ShowAvatar:create_user_panel_avatar( 120, 80,equip_info )
    self.showAvatar:update_zhenlong( UserInfoModel:check_if_equip_zhenlong(  ) )
    self.showAvatar.avatar:setScale( 1.2 )
    self.fabao_panel:addChild( self.showAvatar.avatar, 1 )

	-- 战斗力底图
	local _power_bg = CCBasePanel:panelWithFile( 10,-1,205, -1, UI_MountsWinNew_017, 500, 500 )
	self.fabao_panel:addChild(_power_bg)
	-- 战斗力文字
	local _power_title = CCZXImage:imageWithFile(40,17,-1,-1,UI_MountsWinNew_018)
    _power_bg:addChild(_power_title)
    -- 战斗力值
	self.fight_value = ZXLabelAtlas:createWithString("999",UIResourcePath.FileLocate.normal .. "number");
	self.fight_value:setPosition(CCPointMake(110,17));
	self.fight_value:setAnchorPoint(CCPointMake(0,0));
	_power_bg:addChild(self.fight_value)

	--式神属性标题
	local title_panel = CCBasePanel:panelWithFile( 1,270, 120, -1, UI_GeniusWin_0059, 500, 500 )
	panel:addChild(title_panel)
	local name_title = CCZXImage:imageWithFile(27, 3,-1,-1,UI_GeniusWin_0060,500,500)
	title_panel:addChild(name_title)

	----------------------------------------精灵属性------------------------------------------
	local interval_y = 45
	local begin_y = 100

	-- 生命
	local lift_lab = UILabel:create_lable_2( "#cfff000生    命:", 5, begin_y + 3 * interval_y, 18, ALIGN_LEFT );
	panel:addChild(lift_lab);

	local _attr_bg1 = CCBasePanel:panelWithFile( 100, begin_y + 3 * interval_y - 7, 120, -1, UI_MountsWinNew_006, 500, 500 )
	panel:addChild(_attr_bg1)

	self.lift_text= UILabel:create_lable_2( "888", 106, begin_y + 3 * interval_y - 1, 18, ALIGN_LEFT );
	panel:addChild(self.lift_text)

	-- 攻击
	local attack_lab = UILabel:create_lable_2( "#cfff000攻    击:", 5, begin_y + 2 * interval_y, 18, ALIGN_LEFT );
	panel:addChild(attack_lab);
	local _attr_bg2 = CCBasePanel:panelWithFile( 100, begin_y + 2 * interval_y - 7, 120, -1, UI_MountsWinNew_006, 500, 500 )
	panel:addChild(_attr_bg2)
	self.attack_text= UILabel:create_lable_2( "888", 106, begin_y + 2 * interval_y -1 , 18, ALIGN_LEFT );
	panel:addChild(self.attack_text)

	-- 物防
	local wdef_lab = UILabel:create_lable_2( "#cfff000物理防御:", 5, begin_y + 1 * interval_y, 18, ALIGN_LEFT );
	panel:addChild(wdef_lab);
	local _attr_bg3 = CCBasePanel:panelWithFile( 100, begin_y + 1 * interval_y - 7, 120, -1, UI_MountsWinNew_006, 500, 500 )
	panel:addChild(_attr_bg3)
	self.wdef_text= UILabel:create_lable_2( "888", 106, begin_y + 1 * interval_y - 1, 18, ALIGN_LEFT );
	panel:addChild(self.wdef_text)

	-- 精防
	local mdef_lab = UILabel:create_lable_2( "#cfff000精神防御:", 5, begin_y + 0 * interval_y, 18, ALIGN_LEFT );
	panel:addChild(mdef_lab);
	local _attr_bg4 = CCBasePanel:panelWithFile( 100, begin_y + 0 * interval_y - 7, 120, -1, UI_MountsWinNew_006, 500, 500 )
	panel:addChild(_attr_bg4)
	self.mdef_text= UILabel:create_lable_2( "888", 106, begin_y + 0 * interval_y - 1, 18, ALIGN_LEFT );
	panel:addChild(self.mdef_text)

	-- XX级领取按钮
    local function btn_up_fun(eventType,x,y)
        if eventType == TOUCH_CLICK then
        	-- Instruction:handleUIComponentClick(instruct_comps.GET_GENIUS_BTN)
        	local  function req_sprite()
	        	SpriteModel:req_fabao(0)
	        	if not GameSysModel:isSysEnabled( GameSysModel.GENIUS, false ) then
	    --     		UIManager:hide_window("genius_get_win")
	    --     		Instruction:open_new_sys( GameSysModel.GENIUS, false )
	    --     		-- 3.2s后显示式神系统窗口
					-- local cb = callback:new();
					-- local function func()
					-- 	-- UIManager:show_window( "genius_win" )
					-- 	Instruction:start(38)
					-- end
					-- cb:start(3.2,func);
					EventSystem.postEvent('openSystem',GameSysModel.GENIUS)
	        	end
        	end

        	local  sprite_info = SpriteModel:get_sprite_info()

        	--没有领过式神
			if not sprite_info then
				req_sprite()
				return true
	       	end

	       	local sprite_default = SpriteConfig:get_sprite_default_condition()
	       	local renown = SpriteConfig:get_renown_by_lunhui_level(sprite_default.rebirth)
       		--[2377]"您已有更高轮回的式神，领取获得的式神将会自动转换成%d声望"
       		local str_msg = string.format(LangGameString[2377],renown)
       		-- print("--------------str_msg3",str_msg)
       		NormalDialog:show(str_msg,req_sprite) 
        end

        return true
    end

    self.btn_get_free_genius= MUtils:create_btn(panel,UI_GeniusWin_0042,UI_GeniusWin_0042,btn_up_fun,40,10,-1,-1)
    MUtils:create_zxfont(self.btn_get_free_genius,"29级领取",20,20,1,22)
	self.btn_get_free_genius:addTexWithFile(CLICK_STATE_DISABLE, UI_GeniusWin_0043)

end

function GeniusGetWin:create_right_panel( panel )
	-- 式神背景
	self.fabao_panel = CCBasePanel:panelWithFile( 0,300,227, -1, UI_GeniusWin_0058, 500, 500 )
	panel:addChild(self.fabao_panel)

	-- 底图边角
	local corner_1 = MUtils:create_sprite(self.fabao_panel,UI_GeniusWin_0052,20,235)
	corner_1:setRotation(270)
	local corner_2 = MUtils:create_sprite(self.fabao_panel,UI_GeniusWin_0052,208,235)

	-- 式神形象
    local action = UI_GENIUS_ACTION;
    self.fabao_animate = MUtils:create_animation(65,190,"frame/gem/00002",action );
    self.fabao_panel:addChild(self.fabao_animate);

	-- --精灵名底色
	-- local name_bg = CCZXImage:imageWithFile(40,190,145,-1,UI_MountsWinNew_016,500,500)
	-- self.fabao_panel:addChild(name_bg)

	-- -- 精灵名字 	
	-- self.fabao_name_ = UILabel:create_lable_2( "#cfff000式神名称(永久)", 70, 6, 17, ALIGN_CENTER );
	-- name_bg:addChild(self.fabao_name_)

	-- 人物模型
	local player = EntityManager:get_player_avatar()
    local equip_info = UserInfoModel:get_equi_info()
    self.showAvatar = ShowAvatar:create_user_panel_avatar( 120, 80,equip_info )
    self.showAvatar:update_zhenlong( UserInfoModel:check_if_equip_zhenlong(  ) )
    self.showAvatar.avatar:setScale( 1.2 )
    self.fabao_panel:addChild( self.showAvatar.avatar)

	local recharge_pic = CCBasePanel:panelWithFile( 10,49,-1, -1, UI_GeniusWin_0041, 500, 500 )
	self.fabao_panel:addChild(recharge_pic)

	-- 战斗力底图
	local _power_bg = CCBasePanel:panelWithFile( 10,-1,205, -1, UI_MountsWinNew_017, 500, 500 )
	self.fabao_panel:addChild(_power_bg)
	-- 战斗力文字
	local _power_title = CCZXImage:imageWithFile(40,17,-1,-1,UI_MountsWinNew_018)
    _power_bg:addChild(_power_title)
    -- 战斗力值
	self.fight_value_ = ZXLabelAtlas:createWithString("999",UIResourcePath.FileLocate.normal .. "number");
	self.fight_value_:setPosition(CCPointMake(110,17));
	self.fight_value_:setAnchorPoint(CCPointMake(0,0));
	_power_bg:addChild(self.fight_value_);

	--极品
	-- local img_jp = CCZXImage:imageWithFile(-4,138,-1,-1,UI_GeniusWin_0057,500,500)
	-- self.fabao_panel:addChild(img_jp)

    --式神属性标题
	local title_panel = CCBasePanel:panelWithFile( 1,270, 120, -1, UI_GeniusWin_0059, 500, 500 )
	panel:addChild(title_panel)
	local name_title = CCZXImage:imageWithFile(27, 3,-1,-1,UI_GeniusWin_0060,500,500)
	title_panel:addChild(name_title)

	----------------------------------------精灵属性------------------------------------------
	local interval_y = 45
	local begin_y = 100

	-- 生命
	local lift_lab = UILabel:create_lable_2( "#cfff000生    命:", 5, begin_y + 3 * interval_y, 18, ALIGN_LEFT );
	panel:addChild(lift_lab);

	local _attr_bg1 = CCBasePanel:panelWithFile( 100, begin_y + 3 * interval_y - 7, 120, -1, UI_MountsWinNew_006, 500, 500 )
	panel:addChild(_attr_bg1)

	self.lift_text_= UILabel:create_lable_2( "888", 106, begin_y + 3 * interval_y - 1, 18, ALIGN_LEFT );
	panel:addChild(self.lift_text_)

	-- 攻击
	local attack_lab = UILabel:create_lable_2( "#cfff000攻    击:", 5, begin_y + 2 * interval_y, 18, ALIGN_LEFT );
	panel:addChild(attack_lab);
	local _attr_bg2 = CCBasePanel:panelWithFile( 100, begin_y + 2 * interval_y - 7, 120, -1, UI_MountsWinNew_006, 500, 500 )
	panel:addChild(_attr_bg2)
	self.attack_text_= UILabel:create_lable_2( "888", 106, begin_y + 2 * interval_y - 1, 18, ALIGN_LEFT );
	panel:addChild(self.attack_text_)

	-- 物理防御
	local wdef_lab = UILabel:create_lable_2( "#cfff000物理防御:", 5, begin_y + 1 * interval_y, 18, ALIGN_LEFT );
	panel:addChild(wdef_lab);
	local _attr_bg3 = CCBasePanel:panelWithFile( 100, begin_y + 1 * interval_y - 7, 120, -1, UI_MountsWinNew_006, 500, 500 )
	panel:addChild(_attr_bg3)
	self.wdef_text_= UILabel:create_lable_2( "888", 106, begin_y + 1 * interval_y -1 , 18, ALIGN_LEFT );
	panel:addChild(self.wdef_text_)

	-- 精神防御
	local mdef_lab = UILabel:create_lable_2( "#cfff000精神防御:", 5, begin_y + 0 * interval_y, 18, ALIGN_LEFT );
	panel:addChild(mdef_lab);
	local _attr_bg4 = CCBasePanel:panelWithFile( 100, begin_y + 0 * interval_y -7, 120, -1, UI_MountsWinNew_006, 500, 500 )
	panel:addChild(_attr_bg4)
	self.mdef_text_= UILabel:create_lable_2( "888", 106, begin_y + 0 * interval_y -1 , 18, ALIGN_LEFT );
	panel:addChild(self.mdef_text_)

	-- 特许技能
	self.add_skill_text= UILabel:create_lable_2( "#c0096ff特殊技能：生命上限+2%", 20, 72, 14, ALIGN_LEFT );
	panel:addChild(self.add_skill_text)

	-- 快速充值按钮
    local function btn_recharge_fun(eventType,x,y)
        GlobalFunc:chong_zhi_enter_fun()
        return true
    end
    --UI_GeniusWin_0044 ->UIPIC_COMMOM_005
    local btn_recharge= ZImageButton:create(panel,UIPIC_COMMOM_005,UI_GeniusWin_0045,btn_recharge_fun,6,6,-1,-1)

	local function btn_get_genius_fun(eventType,x,y)

		local  sprite_info = SpriteModel:get_sprite_info()

		local function req_sprite()
			SpriteModel:req_fabao(1)
	 		if not GameSysModel:isSysEnabled( GameSysModel.GENIUS, false ) then
	   --  		UIManager:hide_window("genius_get_win")
	   --      	Instruction:open_new_sys( GameSysModel.GENIUS, false )
	   --      	local cb = callback:new();
				-- local function func()
				-- 	-- UIManager:show_window( "genius_win" )
				-- 	Instruction:start(38)
				-- end
				-- cb:start(3.2,func);
				EventSystem.postEvent('openSystem',GameSysModel.GENIUS)
	        end
		end 

		--没有领过式神
		if not sprite_info then
			req_sprite()
			return true
       	end
       
       local sprite_vip = SpriteConfig:get_sprite_vip_condition()
	   --已有式神大于1转
       if sprite_info.lunhui_level>1 then
       		local renown = SpriteConfig:get_renown_by_lunhui_level(sprite_vip.rebirth)
       		--[2377]"您已有更高轮回的式神，领取获得的式神将会自动转换成%d声望"
       		local str_msg = string.format(LangGameString[2377],renown)
       		-- print("--------------str_msg1",str_msg)
       		NormalDialog:show(str_msg,req_sprite) 
       --已有式神1转
       else
       		local renown = SpriteConfig:get_renown_by_lunhui_level(sprite_info.lunhui_level)
       		--[2378]="领取后，您的式神将会晋升为2转2阶，同时获得%d声望奖励，您确定要领取吗？",
       		-- print("-----------LangGameString[2378]",LangGameString[2378])
       		local str_msg = string.format(LangGameString[2378],renown)
       		-- print("------------str_msg2",str_msg)
       		NormalDialog:show(str_msg,req_sprite)
       end
       return true
    end

 	self.btn_get_genius= ZImageButton:create(panel,UI_GeniusWin_0042,UI_GeniusWin_0046,btn_get_genius_fun,44,9,-1,-1)
 	self.btn_get_genius.view:addTexWithFile(CLICK_STATE_DISABLE, UI_GeniusWin_0043)

 	local vip_get_condition= SpriteConfig:get_sprite_vip_condition()
 	local ybcost = vip_get_condition.ybCost
 	local vip_info = VIPModel:get_vip_info()

 	--领取条件
 	if vip_info.all_yuanbao_value >= ybcost then
 		 btn_recharge.view:setIsVisible(false)
 		 self.btn_get_genius.view:setIsVisible(true)
 	else
 		 btn_recharge.view:setIsVisible(true)
 		 self.btn_get_genius.view:setIsVisible(false)
 	end
end

function GeniusGetWin:update_btn_status()

	print("<<<<<<<<<<<<<<<<GeniusGetWin:update_btn_status()")
	local is_free_get,is_vip_get = SpriteModel:get_get_sprite_status()

	local player_level = EntityManager:get_player_avatar().level

	if player_level<29 or is_free_get==1 then
		self.btn_get_free_genius:setCurState(CLICK_STATE_DISABLE);
	else
		self.btn_get_free_genius:setCurState(CLICK_STATE_UP);
	end

	if is_vip_get==1 then 
		self.btn_get_genius:setCurState(CLICK_STATE_DISABLE);
	else
		self.btn_get_genius:setCurState(CLICK_STATE_UP);
	end
end

--
function GeniusGetWin:update(  )

	local sprite_default =SpriteConfig:get_sprite_default_condition()
	print("GeniusGetWin:update(sprite_default.level,sprite_default.rebirth)",sprite_default.level,sprite_default.rebirth)
	local level_default = SpriteConfig:get_spirits_level(sprite_default.level)
	local rebirth_default = SpriteConfig:get_sprite_data_by_rebirthLv(sprite_default.rebirth)

	-- self.fabao_name:setString("#cfff000"..rebirth_default.name)
	self.lift_text:setText(level_default.baseAttrs[1])
	self.attack_text:setText(level_default.baseAttrs[2]) 
	self.wdef_text:setText(level_default.baseAttrs[3]) 
	self.mdef_text:setText(level_default.baseAttrs[4])
	self.fight_value:init(90)

	local sprite_vip = SpriteConfig:get_sprite_vip_condition()

	local rebirth_vip = SpriteConfig:get_sprite_data_by_rebirthLv(sprite_vip.rebirth)
	local stage_vip = SpriteConfig:get_spirits_stages(sprite_vip.stage, 1);
	
	-- print("vip_sprite_info",vip_sprite_info,vip_sprite_info.attr_life,vip_sprite_info.attr_attack,vip_sprite_info.attr_wDefense,vip_sprite_info.attr_mDefense,vip_sprite_info.fight_value)
	-- self.fabao_name_:setText("#cfff000"..rebirth_vip.name)
	self.lift_text_:setText(stage_vip.baseAttrs[1])
	self.attack_text_:setText(stage_vip.baseAttrs[2]) 
	self.wdef_text_:setText(stage_vip.baseAttrs[3]) 
	self.mdef_text_:setText(stage_vip.baseAttrs[4])
	self.add_skill_text:setText(vip_sprite_config.special_skill)
	self.fight_value_:init(vip_sprite_config.fight_value)
end

-- 激活时更新数据
function GeniusGetWin:active( show )
	self:update()
end

-- 销毁窗体
function GeniusGetWin:destroy()
    Window.destroy(self)
end

