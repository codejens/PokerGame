 -- TipsWin.lua 
-- createed by fangjiehua on 2013-1-11
-- tips窗口

super_class.TipsWin(Window)

local tip_position = {x=0,y=0};
local tip_type = 0;	----------type类型: 1-装备；2-消耗品；
--tipWin的子窗口，显示具体的内容
local _content_view = nil;
-- 非人物戴着的装备tip有点特殊，多了一个比较tip，这些 继承自window的view都要保持一份，在大窗口destory的时候要通知小窗口销毁
local _equip_compare_view = nil;

local tip_colGroup = 0;		--冷却组，实际作用是用来识别宠物蛋因，因为页游版本的历史原导致。
local tip_canUse = false;	--是否可使用
local tip_canSplit = false;	--是否可拆分
local tip_use_func = nil;	--左下角按钮
local left_btn_name = nil;	--左下角按钮名称
local tip_split_func = nil; --右下角按钮
local right_btn_name = nil;	--右下角按钮名称
local tip_quick_func = nil;	--放入快捷栏
local center_btn_name = nil;	--中间按钮名字
local person_equip_tip = false;	--人物身上的装备
local tip_data = nil;

local TIP_RECT_WIDTH = UI_TOOLTIPS_RECT_WIDTH --define @UIMarco.lua
local TIP_RECT_HEIGHT = UI_TOOLTIPS_RECT_HEIGHT
local TIP_RECT_NO_BUTTON_HEIGHT = UI_TOOLTIPS_RECT_NO_BUTTON_HEIGHT
--销毁当前的窗口
local function hideTipWin(eventType,x,y )
		if eventType == TOUCH_BEGAN then
			UIManager:destroy_window("tips_win");
		end
		return false;
	end

--
local function add_to_scroll(x,width,height, view )

	local tip_scroll = CCScroll:scrollWithFile(x, 45, width, height, 1,"");
	
	local function scrollfun(eventType, arg, msgid)
		if eventType == nil or arg == nil or msgid == nil then
			return false
		end
		local temparg = Utils:Split(arg,":")
		local ver = temparg[1]	--列数
		local row = temparg[2]	--行数
		if row == nil or ver == nil then 
			return false;
		end

		if eventType == TOUCH_BEGAN then
			return true
		elseif eventType == TOUCH_MOVED then
			return true
		elseif eventType == TOUCH_ENDED then
			return true
		elseif eventType == SCROLL_CREATE_ITEM then
			--local basepanel = CCBasePanel:panelWithFile(0, 0, 0, 0, nil)
			
			tip_scroll:addItem(view); --height = 466
			print("scroll:",view:getSize().height);
			tip_scroll:refresh()
			return true
		end
	end
	tip_scroll:registerScriptHandler(scrollfun)
	tip_scroll:refresh()
	
	return tip_scroll;
end

local function getTipsHeight()
	local buttonHeight = UI_TOOLTIPS_ITEM_BUTTON_HEIGHT
	local skill_height = TIP_RECT_HEIGHT;
	local offset = UI_TOOLTIPS_BORDER
	local offsetBG = offset * 2

	return skill_height+ offsetBG + buttonHeight
end


function TipsWin:setupScroll(_content_view, _reSize,scroll_width )
	scroll_width = scroll_width or TIP_RECT_WIDTH
	local skill_height = TIP_RECT_HEIGHT;
	local contentSize = _content_view.view:getSize();
	local scroll = add_to_scroll(0, scroll_width, skill_height, _content_view.view);
	
	local offset = UI_TOOLTIPS_BORDER
	local offsetBG = offset * 2
	local buttonHeight = UI_TOOLTIPS_ITEM_BUTTON_HEIGHT
	
	if tip_use_func == nil and tip_split_func == nil then
		buttonHeight = 0
	end
	if _reSize then
		self.tip_bg:setSize(contentSize.width + offsetBG,
							skill_height+ offsetBG + buttonHeight);
	end
	scroll:setPosition(offset,offset + buttonHeight);
	self.tip_bg:addChild( scroll );

end
--绘制tip
function TipsWin:drawTipWin( self_panel )
	
	self.tip_bg = CCBasePanel:panelWithFile( tip_position.x,tip_position.y, TIP_RECT_WIDTH,350, UILH_COMMON.bottom_bg, 500, 500);
	self.tip_bg:setAnchorPoint(0.5,0.5);
	self_panel:addChild(self.tip_bg);
	local colGroup = 0
	-- 重新获取一次tip_flag。变身印记由showTip进来将tip_flag改为0，之后showPetSkillTip这些进来的没改tip_flag，导致一直进入变身印记tip。note by guozhinan
	if tip_data and tip_data.item_id then
		local item_config = ItemConfig:get_item_by_id(tip_data.item_id);
		if item_config and item_config.item then
			tip_flag = item_config.item
		else
			tip_flag = -1
		end
	else
		tip_flag = -1
	end
	--装备的type id 是从1到10	
	print("TipsWin:drawTipWin(tip_type,colGroup,tip_colGroup,tip_flag)",tip_type,colGroup,tip_colGroup,tip_flag)
	if tip_type >= 1 and tip_type <=11 and colGroup ~= 9 then 
		--非人物身上的装备tip需要显示对比
		if person_equip_tip == false then
			--print("对比装备",tip_bg:getPositionS().x,tip_bg:getPositionS().y);
			self.tip_bg:setPosition(333,323);
			--获取人物身上同一装备类型的装备model
			local equipped_data = UserInfoModel:get_equip_by_type(tip_type);

			if equipped_data ~= nil then
				-- 更改self.tip_bg
				self.tip_bg:setSize(TIP_RECT_WIDTH*2, 350);
				self.tip_bg:setPosition(492,323);
				
				--已装备的底板
				local _tipHeight = getTipsHeight()
				local other_tip = CCBasePanel:panelWithFile(0,0, TIP_RECT_WIDTH,_tipHeight, 
															UILH_COMMON.bg_09, 500, 500);
				self.tip_bg:addChild(other_tip);
				local curr_tip = CCBasePanel:panelWithFile(TIP_RECT_WIDTH,0, TIP_RECT_WIDTH,_tipHeight, 
														   UILH_COMMON.bg_09, 500, 500);
				self.tip_bg:addChild(curr_tip);
				--人物身上的装备tip
				_equip_compare_view = EquipTipView:create(true,equipped_data);

			end
			--点击中的装备tip
			_content_view = EquipTipView:create(person_equip_tip,tip_data);
			
			--哪个tip的高度最高，则大面板的高度用哪个
			local height = _content_view.view:getSize().height;
			if equipped_data ~= nil then
				height = math.max(_content_view.view:getSize().height,_equip_compare_view.view:getSize().height);
			end


			--如果已装备不为空
			if equipped_data ~= nil then
				--创建一个盛放2个tip的面板，
				local big_panel = CCBasePanel:panelWithFile( 0,0,TIP_RECT_WIDTH*2,height,"");
				_content_view.view:setPosition(0,height-_content_view.view:getSize().height);
				big_panel:addChild(_content_view.view);
				big_panel:setTag(10000)

				_equip_compare_view.view:setPosition(TIP_RECT_WIDTH,height - _equip_compare_view.view:getSize().height);
				big_panel:addChild(_equip_compare_view.view);
				-- 已装备的标记
				MUtils:create_zximg(_equip_compare_view.view,UIResourcePath.FileLocate.lh_normal .. "commom_equip_flag.png",165,_equip_compare_view.view:getSize().height-130,95,79);
				big_panel:setCurState(CLICK_STATE_DISABLE)
				self:setupScroll({view=big_panel},true, TIP_RECT_WIDTH*2)
				self.tip_bg:setTexture("");		
			else
				self:setupScroll(_content_view,true, TIP_RECT_WIDTH)
			end

		else
			_content_view = EquipTipView:create(person_equip_tip, tip_data);
			_content_view.view:setCurState(CLICK_STATE_DISABLE)
			self:setupScroll(_content_view,true)
			--[[
			_content_view.view:setPosition(offset,offset + buttonHeight);
			self.tip_bg:setSize(contentSize.width + offsetBG,
								contentSize.height+ offsetBG + buttonHeight);
			self.tip_bg:addChild(_content_view.view);
			]]--
			--[[
			local skill_height = TIP_RECT_HEIGHT;
			local skill_y = 55;
			if tip_use_func == nil then
				skill_height = TIP_RECT_NO_BUTTON_HEIGHT;
				skill_y = 17;
			end
			print("tips:skill_height",skill_height)
			local scroll = add_to_scroll(0, TIP_RECT_WIDTH, skill_height, _content_view.view);
			scroll:setPosition(0,skill_y);
			self.tip_bg:addChild( scroll );
			]]--
		end

	--衣服时装，武器时装
	elseif tip_type == ItemConfig.ITEM_TYPE_FASHION_DRESS or tip_type == ItemConfig.ITEM_TYPE_WEAPON_SHOW then		
		_content_view = DressTipView:create(tip_data);
		_content_view.view:setCurState(CLICK_STATE_DISABLE)
		
		local skill_height = TIP_RECT_HEIGHT;
		local skill_y = 65;
		if tip_use_func == nil then
			skill_height = TIP_RECT_NO_BUTTON_HEIGHT;
			skill_y = 17;
		end
		local scroll = add_to_scroll(0, TIP_RECT_WIDTH, skill_height, _content_view.view);
		scroll:setPosition(0,skill_y);
		self.tip_bg:setSize(TIP_RECT_WIDTH, TIP_RECT_HEIGHT+UI_TOOLTIPS_BORDER*2+UI_TOOLTIPS_ITEM_BUTTON_HEIGHT)
		self.tip_bg:addChild(scroll);
	elseif tip_type == ItemConfig.ITEM_TYPE_ZUJI then
		_content_view = FootEffectTipView:create(tip_data);
		_content_view.view:setCurState(CLICK_STATE_DISABLE)
		
		local skill_height = TIP_RECT_HEIGHT;
		local skill_y = 65;
		if tip_use_func == nil then
			skill_height = TIP_RECT_NO_BUTTON_HEIGHT;
			skill_y = 17;
		end
		local scroll = add_to_scroll(0, TIP_RECT_HEIGHT, skill_height, _content_view.view);
		scroll:setPosition(0,skill_y);
		self.tip_bg:addChild(scroll);		
	--宠物蛋
	elseif tip_colGroup == 9 then --宠物tip
		_content_view = PetTipView:create(tip_data);
		_content_view.view:setCurState(CLICK_STATE_DISABLE)
		self:setupScroll(_content_view,true)
	--变身印记
	elseif tip_flag == 0 then
		_content_view = TransformTipView:create(tip_data);
		_content_view.view:setCurState(CLICK_STATE_DISABLE)
		self:setupScroll(_content_view,true)
	--翅膀
	elseif tip_type == ItemConfig.ITEM_TYPE_WING then
		
		_content_view = WingTipView:create(tip_data);
		_content_view.view:setCurState(CLICK_STATE_DISABLE)
		-- local skill_height = TIP_RECT_HEIGHT;
		-- local skill_y = 55;
		-- if tip_use_func == nil then
		-- 	skill_height = TIP_RECT_NO_BUTTON_HEIGHT;
		-- 	skill_y = 17;
		-- end
		-- local scroll = add_to_scroll(0,TIP_RECT_HEIGHT,skill_height, _content_view.view);
		-- scroll:setPosition(0,skill_y);
		-- self.tip_bg:addChild(scroll);
		self:setupScroll(_content_view, true)
	--人物技能
	elseif tip_type == ItemConfig.PERSON_SKILL_TIP then
		_content_view = SkillTipView:create(tip_data);
		_content_view.view:setCurState(CLICK_STATE_DISABLE)
		local skill_height = TIP_RECT_HEIGHT;
		local skill_y = 65;
		if tip_use_func == nil then
			skill_height = TIP_RECT_NO_BUTTON_HEIGHT;
			skill_y = 17;
		end
		local scroll = add_to_scroll(0,TIP_RECT_HEIGHT,skill_height,_content_view.view);
		scroll:setPosition(0,skill_y);
		self.tip_bg:addChild(scroll);
	--宠物技能
	elseif tip_type == ItemConfig.PET_SKILL_TIP then
		_content_view = PetSkillTipView:create(tip_data);
		local contentSize = _content_view.view:getSize();
		self.tip_bg:setSize(TIP_RECT_WIDTH,contentSize.height);
		self.tip_bg:addChild(_content_view.view);

	--翅膀技能tip
	elseif tip_type == ItemConfig.WING_SKILL_TIP then
	
		_content_view = WingSkillTipView:create(tip_data);
		local contentSize = _content_view.view:getSize();
		self.tip_bg:setSize(TIP_RECT_WIDTH,contentSize.height);
		self.tip_bg:addChild(_content_view.view);
	--美人卡牌
	elseif tip_type == ItemConfig.MEIREN_TIP then
	
		_content_view = MeirenTipView:create(tip_data);
		local contentSize = _content_view.view:getSize()
	    local pos_y = 14;
		local scroll = add_to_scroll(6, 300-10, 510, _content_view.view);
		scroll:setPosition(0,pos_y);
		self.tip_bg:setSize(300, 530)
		self.tip_bg:addChild(scroll);

    elseif tip_type == ItemConfig.STONE_LEVELS_TIP then 
    	--全身宝石等级tip
    	
    	_content_view = StoneTipView:create(tip_data);
    	local contentSize = _content_view.view:getSize();
    	self.tip_bg:setSize(TIP_RECT_WIDTH,contentSize.height);
    	self.tip_bg:addChild(_content_view.view);

    elseif tip_type == ItemConfig.STRONG_LEVELS_TIP then
    	--全身强化等级tip
    	_content_view = StrongTipView:create(tip_data);
    	local contentSize = _content_view.view:getSize();
    	self.tip_bg:setSize(TIP_RECT_WIDTH, contentSize.height);
    	self.tip_bg:addChild(_content_view.view);
    elseif tip_type == ItemConfig.SHENSHOU_CIFU_TIP then
    	--神兽赐福tip
    	_content_view = ShenShouCifuTipView:create(tip_data);
    	local contentSize = _content_view.view:getSize();
    	self.tip_bg:setSize(TIP_RECT_WIDTH, contentSize.height);
    	self.tip_bg:addChild(_content_view.view);

    elseif tip_type == ItemConfig.ITEM_TYPE_BADGE then
    	-- 阵营徽记类别 ，现在只有 天元之主的真龙之魂一个物品
    	_content_view = TianyuanBuffTipView:create(tip_data);
		_content_view.view:setCurState(CLICK_STATE_DISABLE)
		-- local  = 260;
		local skill_y = 65;
		if tip_use_func == nil then
			skill_height = UI_TOOLTIPS_RECT_HEIGHT;
			skill_y = 17;
		end
		local scroll = add_to_scroll(0,TIP_RECT_HEIGHT,skill_height,_content_view.view);
		scroll:setPosition(0,skill_y);
		self.tip_bg:addChild(scroll);
	elseif tip_type == ItemConfig.GEM_GOUL_TIP then
		-- 法宝器魂的tip

		_content_view = XianhunTipView:create( tip_data );
    	local contentSize = _content_view.view:getSize();
    	self.tip_bg:setSize(TIP_RECT_WIDTH-50, contentSize.height);
    	self.tip_bg:addChild(_content_view.view);

    elseif tip_type == ItemConfig.MONEY_TIP then
    	-- 货币tip
    	_content_view = MoneyTipView:create(tip_data);
    	local contentSize = _content_view.view:getSize();
    	self.tip_bg:setSize(contentSize.width, contentSize.height)
    	self.tip_bg:addChild(_content_view.view);
    elseif tip_type == ItemConfig.HEART_TIP then
    	-- 结婚系统红心tip
    	_content_view = MarriageHeartTipView:create(tip_data);
    	local contentSize = _content_view.view:getSize();
    	self.tip_bg:setSize(contentSize.width, contentSize.height)
    	-- 由于tip_bg以中心点为锚点，而且是按照宽度为350去设置tip位置，保证tip在左侧窗口的边缘
    	-- 而此类型的tip窗口宽度不为350，所以在此重设一下位置，保证tip_bg在左侧窗口的边缘
    	-- self.tip_bg:setPosition(tip_position.x-(350/2-contentSize.width/2),tip_position.y)
    	self.tip_bg:addChild(_content_view.view);

    elseif tip_type ==  ItemConfig.MARRY_XY_TIP	then

    	-- 结婚系统仙缘等级tip
    	_content_view = MarriageXYTipView:create(tip_data);
    	local contentSize = _content_view.view:getSize();
    	self.tip_bg:setSize(contentSize.width, contentSize.height)
    	-- 由于tip_bg以中心点为锚点，而且是按照宽度为350去设置tip位置，保证tip在左侧窗口的边缘
    	-- 而此类型的tip窗口宽度不为350，所以在此重设一下位置，保证tip_bg在左侧窗口的边缘
    	-- self.tip_bg:setPosition(tip_position.x-(350/2-contentSize.width/2),tip_position.y)
    	self.tip_bg:addChild(_content_view.view);
    	
    elseif tip_type == ItemConfig.MARRY_DETAIL_TIP then
    	-- 结婚系统仙缘详细信息tip
    	_content_view = MarriageDetailTipView:create(tip_data);
    	local contentSize = _content_view.view:getSize();
    	self.tip_bg:setSize(contentSize.width, contentSize.height)
    	self.tip_bg:setTexture(UILH_MARRIAGE.tip_bg);
    	self.tip_bg:addChild(_content_view.view);
    elseif tip_type == ItemConfig.SPECIAL_MOUNT_TIP then
		_content_view = SpecialMountTip:create( tip_data )
		local contentSize = _content_view.view:getSize();
    	self.tip_bg:setSize(contentSize.width, contentSize.height)
    	self.tip_bg:addChild(_content_view.view);
    elseif tip_type == ItemConfig.SIMPLE_TIP then
		_content_view = SimpleTipView:create( tip_data )
		local contentSize = _content_view.view:getSize();
    	self.tip_bg:setSize(contentSize.width, contentSize.height)
    	self.tip_bg:addChild(_content_view.view);
    elseif tip_type == ItemConfig.ITEM_TYPE_SKILL_MIJI then
    	--技能秘籍书
    	_content_view = MiJiItemTipView:create(tip_data);
    	local contentSize = _content_view.view:getSize();
    	self.tip_bg:setSize(contentSize.width, contentSize.height)
    	self.tip_bg:addChild(_content_view.view);
	elseif tip_type == ItemConfig.ITEM_TYPE_SPECIAL_RIDE then
		_content_view = MountsItemTipView:create(tip_data);
		_content_view.view:setCurState(CLICK_STATE_DISABLE)

		local skill_height = TIP_RECT_NO_BUTTON_HEIGHT-70;
		local skill_y = 65;
		if tip_use_func == nil then
			skill_height = TIP_RECT_NO_BUTTON_HEIGHT-20;
			skill_y = 17;
		end

		local scroll = add_to_scroll(0, TIP_RECT_WIDTH, skill_height, _content_view.view);
		scroll:setPosition(0,skill_y);
		self.tip_bg:addChild(scroll);
	else

		--其他所有都使用ItemTipView来显示
		_content_view = ItemTipView:create(tip_data);
		local contentSize = _content_view.view:getSize();

		local offset = UI_TOOLTIPS_BORDER
		local offsetBG = offset * 2
		local buttonHeight = UI_TOOLTIPS_ITEM_BUTTON_HEIGHT
		
		if tip_use_func == nil and tip_split_func == nil then
			buttonHeight = 0
		end

		_content_view.view:setPosition(offset,offset + buttonHeight);
		self.tip_bg:setSize(contentSize.width + offsetBG,
							contentSize.height+ offsetBG + buttonHeight);

		self.tip_bg:addChild(_content_view.view);
	end

	local btn_y = 9
	if tip_use_func ~=nil then
		--使用按钮
		local function use_event()
			if tip_use_func ~= nil then
				Instruction:handleUIComponentClick(instruct_comps.ANY_BTN)
				tip_use_func();
				hideTipWin(TOUCH_BEGAN);
			end
		end
	
		if left_btn_name == nil then
			left_btn_name = LangGameString[834]; -- [834]="使用"
		end

		local used_btn = TextButton:create(nil, 5, btn_y, -1, -1, left_btn_name,{UILH_COMMON.lh_button2,UILH_COMMON.lh_button2_s});

		self.tip_bg:addChild(used_btn.view);
		used_btn:setTouchClickFun(use_event);
	end
	

	-- local used_btn= MUtils:create_btn(self.tip_bg,UIPIC_TipsWin_001,UIPIC_TipsWin_001,nil,15,12,-1,-1);
 --    MUtils:create_zxfont(used_btn,left_name,26,14,1,18);
	
	local is_long_btn = false  -- 记录tips面板的右按钮是不是四个字按钮，然后去设置中间按钮的位置
	if tip_split_func ~= nil and right_btn_name ~= "升级装备" then
		--拆分按钮
		local function split_event( )
			if tip_split_func ~= nil then
				tip_split_func();
				hideTipWin(TOUCH_BEGAN);
			end
		end
		if right_btn_name == nil or right_btn_name == LangGameString[833] then
			right_btn_name = LangGameString[833]; -- [833]="拆分"
			self.split_btn = TextButton:create(nil, 246, btn_y, -1, -1,right_btn_name,{UILH_COMMON.lh_button2,UILH_COMMON.lh_button2_s});
		else
			is_long_btn = true
			self.split_btn = TextButton:create(nil, 224, btn_y, -1, -1,right_btn_name,{UILH_COMMON.btn4_nor,UILH_COMMON.btn4_sel});
		end

		if right_btn_name == "升级装备" then 
			self.effect = LuaEffectManager:play_view_effect(418,61,28,self.split_btn.view,true,99,1)
		end 
		self.tip_bg:addChild(self.split_btn.view);
		self.split_btn:setTouchClickFun(split_event);
	end

	if tip_quick_func ~= nil then

		--放入快捷栏按钮
		local function quick_event(  )
			-- print("放入快捷栏按钮, tip_quick_func",tip_quick_func);
			if tip_quick_func ~= nil then
				tip_quick_func();
				hideTipWin(TOUCH_BEGAN);
			end

		end 
		if center_btn_name == nil then
			center_btn_name = LangGameString[2026]; -- [2026]="放入快捷栏"
		end

		local quick_btn_y = 115
		if is_long_btn then
			quick_btn_y = 103
		end

		local quick_btn = TextButton:create(nil, quick_btn_y, btn_y, -1, -1, center_btn_name,{UILH_COMMON.btn4_nor,UILH_COMMON.btn4_sel});
		-- quick_btn:setCurState(CLICK_STATE_DISABLE)
		-- quick_btn.view:setIsVisible(false)

		self.tip_bg:addChild(quick_btn.view);
		quick_btn:setTouchClickFun(quick_event);
	end
end


function TipsWin:destroy(  )
	if self.effect and self.split_btn then 
		LuaEffectManager:stop_view_effect( 417,self.split_btn.view )
	end 
	Window.destroy(self);

	self.fader:stop()

	if _content_view then 
		_content_view:destroy();
	end

	if _equip_compare_view then
		_equip_compare_view:destroy();
	end
	tip_colGroup = 0;
	tip_canUse = false;
	tip_canSplit = false;
	tip_use_func = nil;
	left_btn_name = nil;
	tip_split_func = nil;
	right_btn_name = nil;
	tip_quick_func = nil;
	center_btn_name = nil;
	person_equip_tip = false;
	tip_data = nil;

end

local _screenWidth  = GameScreenConfig.ui_screen_width
local _screenHeight = GameScreenConfig.ui_screen_height

function TipsWin:__init( window_name, texture_name, is_grid, width, height )
	--xprint('..............................')
	self.view:setOpacity(0)
	self.fader = TimeLerp()
	self.fader:start(0.05,0.25,function(t) 
		self.view:setOpacity(125*t)
	end)

	self:drawTipWin(self.view);

	self.view:registerScriptHandler(hideTipWin);
end

function TipsWin:create( texture_name )
	--local temp_info = { texture = "", x = 0, y = 0, width = 800, height = 480 }
	return TipsWin('TipsWin', 'nopack/black.png', false, _screenWidth, _screenHeight);
end

-------------显示tip
-------------------
--type类型: 1-装备；2-消耗品；
-------------------
local function create_tip( x,y,data,use_func,split_func, quick_func, fromPersonWin, left_name, right_name, center_name )
	--xprint("create_tip")
	tip_position.x = x;
	tip_position.y = y;

	tip_data = data;
	tip_use_func = use_func;
	tip_split_func = split_func;
	tip_quick_func = quick_func;

	person_equip_tip = fromPersonWin;
	left_btn_name = left_name;
	right_btn_name = right_name;
	center_btn_name = center_name;
	
	local win = UIManager:show_window("tips_win");	
	-- 添加了一个统一的出现动画
	win.tip_bg:setScale(0.5);
	local scale_act_1 = CCScaleTo:actionWithDuration( 0.1, 1.05);
	local scale_act_2 = CCScaleTo:actionWithDuration( 0.05, 1.0);
	local seq_act = CCSequence:actionOneTwo(scale_act_1, scale_act_2);
	win.tip_bg:runAction(seq_act);
	return win;
end

--一般的tip调用方法
function TipsWin:showTip( x,y,data,use_func,split_func, quick_func,fromPersonWin,left_name,right_name,center_name)
	
	print("data.item_id",data.item_id,use_func)
	local item_config = ItemConfig:get_item_by_id(data.item_id);
    tip_type = item_config.type;
	tip_colGroup = item_config.colGroup;
	tip_flag = item_config.item
    local win = create_tip(x,y,data,use_func,split_func,quick_func,fromPersonWin,left_name,right_name, center_name);
    return win;
end

--人物技能的tip调用方法
function TipsWin:showUserSkillTip( x,y,data,use_func,left_name)
	
	tip_type = ItemConfig.PERSON_SKILL_TIP;
	create_tip(x,y,data,use_func,nil,nil,false,left_name,nil);

end

--宠物技能
function TipsWin:showPetSkillTip( x,y,data)
	
	tip_type = ItemConfig.PET_SKILL_TIP;
	return create_tip(x,y,data,nil,nil,nil,false);

end

--翅膀技能
function TipsWin:showWingSkillTip( x, y,data  )
	
	tip_type = ItemConfig.WING_SKILL_TIP;
	
	return create_tip(x,y,data,nil,nil,nil,false);
end

--美人卡牌
function TipsWin:showMeirenTip( x, y,data  )
	tip_type = ItemConfig.MEIREN_TIP;
	return create_tip(x,y,data);
end

-- 人物全身强化等级
function TipsWin:showStrongLevelsTip( x,y,data )
	
	tip_type = ItemConfig.STRONG_LEVELS_TIP;
	create_tip(x, y, data);

end

-- 人物全身宝石等级
function TipsWin:showStoneLevelsTip( x,y,data )
	
	tip_type = ItemConfig.STONE_LEVELS_TIP;
	create_tip(x, y, data);

end

-- 神兽
function TipsWin:showShenShouTip( x,y,data )
	
	tip_type = ItemConfig.SHENSHOU_CIFU_TIP;
	create_tip(x, y, data);

end

-- 法宝器魂tip
function TipsWin:showXianhunTip( x,y,data )
	tip_type = ItemConfig.GEM_GOUL_TIP; 
	create_tip(x,y,data)
end

-- 货币tip
function TipsWin:showMoneyTip( x,y,data )
	
	tip_type = ItemConfig.MONEY_TIP;
	return create_tip(x,y,data);

end

-- 结婚系统仙缘红心tip
function TipsWin:showHeartTip( x,y,data )
	tip_type = ItemConfig.HEART_TIP;
	return create_tip(x,y,data);
end
-- 结婚系统仙缘等级tip
function TipsWin:showXYTip( x,y,data )
	tip_type = ItemConfig.MARRY_XY_TIP;
	return create_tip(x,y,data);
end
-- 结婚系统仙缘详细信息
function TipsWin:showXYDetailTip( x, y, data  )
	tip_type = ItemConfig.MARRY_DETAIL_TIP;
	return create_tip(x,y,data);

end

function TipsWin:showSpecialMountTip( x,y,data )
	tip_type = ItemConfig.SPECIAL_MOUNT_TIP
	return create_tip(x,y,data,nil,nil,nil,false);
end

function TipsWin:showSimpleTip( x,y,data )
	tip_type = ItemConfig.SIMPLE_TIP
	create_tip(x,y,data,nil,nil,nil,false);
end