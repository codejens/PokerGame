-- DujieItemView.lua
-- created by fangjiehua on 2013-2-1
-- 渡劫窗口
super_class.DujieItemView(Window)
 
local c3_blue 	= "#c33a6ee";
local c3_yellow = "#cfff000";
local c3_red	= "#cff0000";
local c3_orange = "#cfe8300"

-- UI param
local item_w = 230
local item_h = 130

local function update_star_num(panel , num )
	panel:removeAllChildrenWithCleanup(true);
	for i=0,2 do
		local star_img = CCZXImage:imageWithFile( 28*i+20, 102, 22, 22,UILH_HUGUO.start);
		if i == 1 then
			star_img:setPosition( 28*i+20, 92 )
		end
		--star_img:addTexWithFile(CLICK_STATE_DISABLE, "ui/common/star_gray.png")
		panel:addChild(star_img);
		if i >= num then
			star_img:setCurState(CLICK_STATE_DISABLE);
		end
	end
end

function DujieItemView:__init(  )

	-- 判断可否进去标志位
	self._canEnter = false

	local function click_event( eventType,x,y )
		if self.enter_func ~= nil and self.index ~= nil then
			if self._canEnter then
				self.enter_func(self.index);
			else
				-- ScreenNoticWin:create_notic( Lang.huguo[14] );
				GlobalFunc:create_screen_notic( Lang.huguo[14] )
			end
		end
		return true;
	end
	-- 

	self.bg_panel = ZBasePanel:create( self, nil, 0, 0, item_w, item_h);
	ZButton:create( self.bg_panel, UILH_COMMON.bg_11, click_event, 0, 0,item_w,item_h, nil, 20, 20, 20, 20, 20, 20, 20, 20 )

	--锁住
	self.luck_img = CCZXImage:imageWithFile( 63, 70, 47, 53, UILH_HUGUO.lock );
	self.luck_img:setAnchorPoint(0.5,0.5);
	self.bg_panel:addChild(self.luck_img,9999);
	self.luck_img:setIsVisible(false);

	-- local function boss_click_event( eventType,x,y )
	-- 	return false
	-- end

	-- self.boss_panel = ZBasePanel:create(self, nil,10, 45, 100, 120);
	-- -- self:addChild(self.boss_panel.view)
	-- self.boss_panel.view:registerScriptHandler(boss_click_event);
    -- self:addChild(self.boss_img)

    -- 头像底框
    self.portait_bg = CCBasePanel:panelWithFile(15, 25, -1, -1, UILH_NORMAL.item_bg)
    self.bg_panel:addChild( self.portait_bg, 1 )
--
	-- boss形象
	self.boss_img = CCZXImage:imageWithFile(12, 12, -1, -1, UILH_HUGUO.boss1);
    self.boss_img:setIsVisible(false);
    self.portait_bg:addChild(self.boss_img)

	-- 炼器阶段底图
	self.jingjie_bg = CCZXImage:imageWithFile( 87, 78, 120, -1, "");
	self:addChild(self.jingjie_bg);
	self.jingjie_bg:setIsVisible(false);
	-- 炼器阶段
	self.jingjie = CCZXLabel:labelWithTextS(CCPointMake(60,16), LH_COLOR[1] .. "炼气一阶",16,ALIGN_CENTER); -- [902]="炼气一阶"
	self.jingjie_bg:addChild(self.jingjie);

	-- 已通过图标
	self.pass_img = CCZXImage:imageWithFile(-20, 50, -1, -1, UILH_HUGUO.passed);
	self:addChild(self.pass_img);
	self.pass_img:setIsVisible(false);

	-- 属性加成
	-- self.attri_type = CCZXLabel:labelWithTextS(CCPointMake(115-17,57+2),c3_blue.."攻击",14,ALIGN_LEFT);
	-- self:addChild(self.attri_type);
	-- self.attri_type:setIsVisible(false);

	-- --属性增幅
	-- self.attri_value =  CCZXLabel:labelWithTextS(CCPointMake(180,60),"+20",18,ALIGN_CENTER);
	-- self:addChild(self.attri_value);
	-- self.attri_value:setIsVisible(false);
	-- 属性加成
	self.attri_lab = CCDialogEx:dialogWithFile(110,70,140, 20, 10, "", TYPE_VERTICAL ,ADD_LIST_DIR_UP);
	self.attri_lab:setFontSize(14);
	self.attri_lab:setText(LangGameString[903]); -- [903]="攻击 +10"
	self:addChild(self.attri_lab);

	-- 需要人物等级
	self.need_level = CCZXLabel:labelWithTextS(CCPointMake(110,25),LH_COLOR[2] .. Lang.huguo[12], 14,ALIGN_LEFT); -- [904]="人物等级:1"
	self:addChild(self.need_level);
	self.need_level:setIsVisible(false);

	-- 星星
	self.star_panel = CCNode:node();
	self.star_panel:setPosition(0,0)
	self:addChild(self.star_panel);
	update_star_num(self.star_panel,3);
	self.star_panel:setIsVisible(false);

	-- 推荐战斗力
	self.suggest_fight = CCZXLabel:labelWithTextS(CCPointMake(110,50), LH_COLOR[2] .. Lang.huguo[13], 14,ALIGN_LEFT); -- [905]="推荐战斗力"
	self:addChild(self.suggest_fight);
	self.suggest_fight:setIsVisible(false);

	self.attack_value = UILabel:create_lable_2( "", 180, 50, 14, ALIGN_LEFT )
	self:addChild( self.attack_value )
	self.attack_value:setIsVisible( false );
	-- self.attack_value = ZXLabelAtlas:createWithString("1600",UIResourcePath.FileLocate.normal .. "number");
	-- self.attack_value:setPosition(CCPointMake(125,76));
	-- self:addChild(self.attack_value);
	-- self.attack_value:setIsVisible(false);

	-- 奖励绑元
	-- local function fetch_btn_fun(eventType,x,y)
	-- 	-- body
	-- 	if eventType == TOUCH_CLICK then 
 --           DujieModel:fetch_dujie_yb( self.index )
 --        end
 --        return true
	-- end

	-- self.fuck_bg = CCBasePanel:panelWithFile( 50, 40, 250, 32, "ui/dujie/lingqu_bg.png", 500, 500 )
	-- self:addChild(self.fuck_bg)
	-- self.fuck_bg:setIsVisible(false)
	-- 领取按钮
	-- self.fetch_btn = CCNGBtnMulTex:buttonWithFile( 140, 12, -1, -1, UILH_COMMON.button5_nor, 500, 500)
 --    self.fetch_btn:addTexWithFile(CLICK_STATE_DOWN, UILH_COMMON.button5_nor)
 --    -- xiehande btn_hui ->button2_d
 --    self.fetch_btn:addTexWithFile(CLICK_STATE_DISABLE, UILH_COMMON.button5_dis)
 --    self.fetch_btn:registerScriptHandler(fetch_btn_fun)
 --    self.fetch_btn:setCurState(CLICK_STATE_DISABLE)
 --    self.fetch_btn:setIsVisible(false)
 --    self:addChild(self.fetch_btn)

 --    -- 按钮显示的名称
 --    local name_image = UILabel:create_lable_2("领 取", 34, 11, font_size, ALIGN_CENTER)
 --    -- name_image.view:setAnchorPoint(0.5,0.5);
 --    self.fetch_btn:addChild( name_image )

 --    --奖励底板
	-- self.awardMoney_panel = CCBasePanel:panelWithFile( 20, 10, 120, 30, "" )
	-- self.fuck_bg:addChild(self.awardMoney_panel)
	-- local awardMoney_lab = UILabel:create_lable_2(c3_orange..LangGameString[2438], 0, 0, 15, ALIGN_LEFT ) --LangGameString[2438]普通奖励
	-- self.awardMoney_panel:addChild(awardMoney_lab)

	-- --绑定元宝图标
	-- MUtils:create_sprite(self.awardMoney_panel,UI_DujieWin_025,93,6)
	-- self.awardMoney_text = UILabel:create_lable_2(c3_orange.."×10", 102, 0, 15, ALIGN_LEFT )
	-- self.awardMoney_panel:addChild(self.awardMoney_text)
end

--重设置获取奖励按钮状态
function DujieItemView:update_fetch_info(status)
	
	-- char 能否领取元宝,0表示不能领取,1表示可以领取,2表示已领取
	if status==0 then
		-- self.awardMoney_panel:setIsVisible(true)
		-- self.fuck_bg:setIsVisible(true)
		self.fetch_btn:setIsVisible(true)
		self.fetch_btn:setCurState(CLICK_STATE_DISABLE)

	elseif status==1 then
		-- self.awardMoney_panel:setIsVisible(true)
		self.fetch_btn:setIsVisible(true)
		self.fuck_bg:setIsVisible(true)
		self.fetch_btn:setCurState(CLICK_STATE_UP)

	elseif status==2 then
		-- self.awardMoney_panel:setIsVisible(false)
		-- self.fuck_bg:setIsVisible(false)
		self.fetch_btn:setIsVisible(false)
		self.fetch_btn:setCurState(CLICK_STATE_DISABLE)
	elseif status==4 then
		-- self.awardMoney_panel:setIsVisible(false)
		-- self.fuck_bg:setIsVisible(false)
		self.fetch_btn:setIsVisible(false)
		self.fetch_btn:setCurState(CLICK_STATE_DISABLE)

	end
end	


function DujieItemView:update(config)
	if config ~= nil then
		--boss图片
		self.index = config.index;
		
		local num = self.index%9;
		if num == 0 then
			num = 9;
		end
		self.boss_img:setIsVisible(true);
		self.boss_img:setTexture(DujieModel:get_boss_img(num));
		-- self.boss_img:addTexWithFile(CLICK_STATE_UP,DujieModel:get_boss_img(num));
		--境界
		self.jingjie_bg:setIsVisible(true);
	 	self.jingjie:setText(LH_COLOR[1] .. config.name);
	 	--属性
	  
	 	self.attri_lab:setIsVisible(true);
	 	self.attri_lab:setText(c3_blue..staticAttriTypeList[config.propertyId]..c3_yellow.."+"..tostring(config.propertyValue))


	 	--评价，星星
	 	self.star_panel:setIsVisible(true);
	 	self.star_panel:setPosition(5,-80);
	 	update_star_num(self.star_panel,config.star);
	 	--通过
	 	self.pass_img:setIsVisible(true);

	 	--隐藏一些该隐藏的图标
	 	self.suggest_fight:setIsVisible(false);
	 	self.attack_value:setIsVisible(false);

		self.luck_img:setIsVisible(false);
		-- self.awardMoney_panel:setIsVisible(false)
		self._canEnter = true
	else
		self.luck_img:setIsVisible(true);
		self.jingjie_bg:setIsVisible(false);
		
		-- self.attri_type:setIsVisible(false);
		-- self.attri_value:setIsVisible(false);
		self.attri_lab:setIsVisible(false);
		self.star_panel:setIsVisible(false);
		self.pass_img:setIsVisible(false);
		self.suggest_fight:setIsVisible(false);
	 	self.attack_value:setIsVisible(false);
	 	self.boss_img:setIsVisible(false);
	 	-- self.awardMoney_panel:setIsVisible(false)
	 	-- 判断可否进去标志位
	 	self._canEnter = false
	end
	self.need_level:setIsVisible(false);
end
function DujieItemView:show_current_jingjie( config )

	self.index = config.index;
	--设置boss图片
	
	local num = self.index%9;
	if num == 0 then
		num = 9;
	end
	self.boss_img:setIsVisible(true);
	self.boss_img:setTexture(DujieModel:get_boss_img(num));
	-- self.boss_img:addTexWithFile(CLICK_STATE_UP,DujieModel:get_boss_img(num));
	--境界
	self.jingjie_bg:setIsVisible(true);
 	self.jingjie:setText( LH_COLOR[1] .. config.name);
 	--属性 
 	self.attri_lab:setIsVisible(true);
 	self.attri_lab:setText(c3_blue..staticAttriTypeList[config.propertyId]..c3_yellow.."+"..tostring(config.propertyValue))

 	-- 锁
 	self.luck_img:setIsVisible(false);

 	--推荐战斗力
 	self.suggest_fight:setIsVisible(true);
 	self.attack_value:setIsVisible(true);
 	self.attack_value:setString(tostring(config.attackPower));
 	--需要人物等级
 	self.need_level:setIsVisible(true);
 
 	local player = EntityManager:get_player_avatar();
 	local need_level_text;
 	if config.level > player.level then
 		need_level_text = LH_COLOR[7] .. Lang.huguo[12] .. tostring(config.level); -- [906]="人物等级:"
 	else
 		need_level_text = LH_COLOR[2] .. Lang.huguo[12] .. tostring(config.level); -- [906]="人物等级:"
 	end
 	self.need_level:setText(need_level_text);
 	--通过
 	self.pass_img:setIsVisible(false);
 	--评价，星星
 	self.star_panel:setIsVisible(false);
 	
 	-- 判断可否进去标志位
 	self._canEnter = true
 	-- local awardMoney = config.awardMoneyNum
 	-- self.awardMoney_text:setText(c3_orange.."×"..awardMoney)
 	-- self.awardMoney_panel:setIsVisible(true)

end
function DujieItemView:set_enter_func( fn )
	self.enter_func = fn;
end

function DujieItemView:create()
	return DujieItemView("dujieItem", nil, false, item_w,item_h);
end

function DujieItemView:destroy()
	Window.destroy(self)
	-- body
end