
-- TransformSkillPage.lua 
-- createed by mwy @2012-5-26
-- 新建变身秘籍页面

super_class.TransformSkillPage(  )

local _current_skill_level=0 --当前选中技能的等级,主要是为了做自动进阶那个垃圾功能。（自动进阶一级）

function TransformSkillPage:__init( x,y)
	self.items_dict={} --
	self.select_index=1--点选的技能ID 
	self.auto_up=false --是否自动进阶

	local pos_x = x or 0
    local pos_y = y or 0
	self.view = CCBasePanel:panelWithFile( pos_x, pos_y, 835, 386+102, nil, 500, 500 )

	-- 底板
	local panel = self.view
	-- 左
	local _left_up_panel = ZBasePanel.new(UI_TransformWin_002, 380, 407)
	_left_up_panel:setPosition(11, 112)
    panel:addChild(_left_up_panel.view)
    -- 左下
    local _left_down_panel = ZBasePanel.new(UI_TransformWin_002, 380, 96)
	_left_down_panel:setPosition(11, 12)
    panel:addChild(_left_down_panel.view)

    -- 右秘籍时显示面板
	self._right_panel_1 = ZBasePanel.new(UI_TransformWin_001, 393, 507)
	self._right_panel_1:setPosition(395, 12)
    panel:addChild(self._right_panel_1.view)
 
 	--无秘籍时显示面板
    self._right_panel_2 = ZBasePanel.new(UI_TransformWin_001, 393, 507)
	self._right_panel_2 :setPosition(395, 12)
    panel:addChild( self._right_panel_2 .view)
    self._right_panel_2.view:setIsVisible(false)--默认隐藏掉

    -- 
    self:create_left_up_panel(_left_up_panel)
    self:create_left_down_panel(_left_down_panel)
    self:create_right_panel(self._right_panel_1)
    self:create_right_hide_panel(self._right_panel_2)
    --
end

-- 切换有地板显示页面
function TransformSkillPage:change_info_panel( is_miji_active)
	if is_miji_active then
		self._right_panel_1.view:setIsVisible(true)
		self._right_panel_2.view:setIsVisible(false)
	else
		self._right_panel_1.view:setIsVisible(false)
		self._right_panel_2.view:setIsVisible(true)
	end
end

function TransformSkillPage:selected_icon_cell( i )
    -- local y =0
    -- if i==1 then
    --     y = 303
    -- elseif i == 2 then
    --     y = 303-100
    -- elseif i == 3 then
    --     y = 303-200
    -- elseif i == 4 then    
    --      y = 303-300
    -- end
    -- -- 移动
    -- local move_to = CCMoveTo:actionWithDuration(0.3, CCPointMake(0,y));
    -- local act_easa = CCEaseExponentialOut:actionWithAction(move_to);
    -- self.crystal_select_frame:runAction(act_easa);
    self.crestal_select_index = i;

    for k,v in pairs(self.items_dict) do
        v:set_selected(false)
    end
    self.items_dict[i]:set_selected(true)
end

-- 创建左上底版显示内容
function TransformSkillPage:create_left_up_panel( panel)
    -- for i=1,4 do
    -- 	local function icon_click_callback( )
    -- 		self.select_index=i
    -- 		self:update_miji_info(i,true)
    --         self:selected_icon_cell(self.select_index)
    -- 	end
    -- 	local cell = TransformIconCell(2,304-(i-1)*100,376,100,"非银针奥义",icon_click_callback)
    -- 	panel:addChild(cell)
    -- 	self.items_dict[i]=cell
    -- end
      -- 选中框
    -- self.crystal_select_frame = MUtils:create_zximg(panel, "nopack/ani_corner2.png",0,303, 378,102, 500, 500);
    local data_para = TransformConfig:get_all_miji( )
    local scroll = self:create_scroll_area(data_para, 8, 10, 362, 389, 1, 4, nil)
    panel:addChild(scroll)
end

-- 创建可拖动区域   参数：放入scroll的panel的集合, 坐标， 区域大小，列数，可见行数， 背景名称
function TransformSkillPage:create_scroll_area( panel_table_para, pos_x, pos_y, size_w, size_h, colu_num, sight_num, bg_name)
    local row_num = math.ceil( #panel_table_para / colu_num )
    local _scroll_info = { x = pos_x, y = pos_y, width = size_w, height = size_h, max_num = 1, image = bg_name, stype = TYPE_HORIZONTAL }
    local scroll = CCScroll:scrollWithFile( _scroll_info.x, _scroll_info.y, _scroll_info.width, _scroll_info.height, _scroll_info.max_num, _scroll_info.image, _scroll_info.stype, 600, 600 )

    local bg = CCBasePanel:panelWithFile(0, 0, size_w, 100*row_num, nil)
    for i,v in ipairs(panel_table_para) do
        local data= v
        if data then
            local skill_panel = self:create_one_skill(data, 0, 100*(row_num-i), size_w, 100)
            bg:addChild( skill_panel.view )
        end
    end

    local function scrollfun(eventType, args, msg_id)
        if eventType == nil or args == nil or msg_id == nil then 
            return
        end
        if eventType == TOUCH_BEGAN then
            return true
        elseif eventType == TOUCH_MOVED then
            return true
        elseif eventType == TOUCH_ENDED then
            return true
        elseif eventType == SCROLL_CREATE_ITEM then
            local temparg = Utils:Split(args,":")
            local x = temparg[1]              -- 行
            local y = temparg[2]              -- 列
            local index = x * colu_num
            -- local bg = CCBasePanel:panelWithFile(0, 0, size_w, 100, nil)

            -- for i = 1, colu_num do
            --     local data= panel_table_para[index+i]

            --     if data then
            --         local skill_panel = self:create_one_skill(data, ( size_w / colu_num) * ( i - 1), 0, size_w / colu_num, 100)
            --         bg:addChild( skill_panel.view )
            --     end
            -- end
            scroll:addItem(bg)
            scroll:refresh()
            return false
        end
    end
    scroll:registerScriptHandler(scrollfun)
    scroll:refresh()
    return scroll
end

function TransformSkillPage:create_one_skill( data, x, y, w, h )
    local function icon_click_callback( )
        self.select_index = data.id
        self:update_miji_info(data.id, true)
        self:selected_icon_cell(self.select_index)
    end
    local cell = TransformIconCell(x, y, w, h,"非银针奥义", 0, icon_click_callback)
    cell:set_icon(data.jihuoitem)
    cell:set_item_text(data.name)
    self.items_dict[data.id]=cell
    return cell
end

 function TransformSkillPage:create_left_down_panel( panel )
 	--增加属性标题
	local _left_down_title_panel = CCBasePanel:panelWithFile( 1, 67, 120, -1, UI_MountsWinNew_005, 500, 500 )
	panel:addChild(_left_down_title_panel)
	local name_title = CCZXImage:imageWithFile(27, 3,-1,-1,UI_TransformWin_007,500,500)
	_left_down_title_panel:addChild(name_title)
	-- 
	local effect_str = "提升不同奥义阶数可获得#c0edc09属性#cffffff永久增加和提升#c0edc09奥义抵抗#cffffff效果";
  	local temp_skill_dialog = ZDialog:create( panel, effect_str, 8, 66, 370, 60, 15 )
  	temp_skill_dialog:setAnchorPoint(0, 1)
  	temp_skill_dialog.view:setLineEmptySpace(5)
  	self.skill_effect = temp_skill_dialog.view
 end

 -- 创建一个隐藏的右底版，在秘籍未激活的情况下显示秘籍的相关信息
 function TransformSkillPage:create_right_hide_panel( panel )
 	-- 右
	local panel1 = ZBasePanel.new(UI_TransformWin_002, 373, 216)
	panel1:setPosition(10, 280)
    panel:addChild(panel1.view)
	MUtils:create_zximg(panel1, UI_TransformWin_0010, 100,160, -1, -1);

    -- 抗暴击
    local need_text = ZLabel.new("需要奥义秘籍:")
    need_text:setPosition(40, 100)
    panel1:addChild(need_text)

    -- 奥义来源
     self.source_text = UILabel:create_lable_2( "奥义来十分广泛受到过分割:",186,25,19, ALIGN_CENTER );
	panel1:addChild( self.source_text);

     -- slotitem
    self.slotitem_need= MUtils:create_one_slotItem( nil, 200, 70, 48, 48 )
    -- local item_id = TransformConfig:get_curr_stage_crystal_item_id(  )
    local function tip_func(  )
	    TipsModel:show_shop_tip( 400, 240, self.slotitem_need.need_id )
    end
    self.slotitem_need:set_click_event(tip_func)
    panel1:addChild(self.slotitem_need.view)
 	self.slotitem_need:set_icon(nil)
 	self.slotitem_need:set_icon_dead_color()

    -- 附加属性
    local panel2 = ZBasePanel.new(UI_TransformWin_002, 373, 145)
	panel2:setPosition(10, 130)
    panel:addChild(panel2.view)
	local _left_down_title_panel = CCBasePanel:panelWithFile( 1, 116, 120, -1, UI_MountsWinNew_005, 500, 500 )
	panel2:addChild(_left_down_title_panel)
	local name_title = CCZXImage:imageWithFile(27, 3,-1,-1,UI_TransformWin_008,500,500)
	_left_down_title_panel:addChild(name_title)
	MUtils:create_zximg(panel2, UI_TransformWin_0010, 100,50, -1, -1);

	--进阶效果
	local panel3 = ZBasePanel.new(UI_TransformWin_002, 373, 115)
	panel3:setPosition(10, 10)
    panel:addChild(panel3.view)
	local _left_down_title_panel = CCBasePanel:panelWithFile( 1, 67+20, 120, -1, UI_MountsWinNew_005, 500, 500 )
	panel3:addChild(_left_down_title_panel)
	local name_title = CCZXImage:imageWithFile(27, 3,-1,-1,UI_TransformWin_009,500,500)
	_left_down_title_panel:addChild(name_title)
	MUtils:create_zximg(panel3, UI_TransformWin_0010, 100,35, -1, -1);
 end

-- 创建右底版
 function TransformSkillPage:create_right_panel( panel )
 	-- 右
	local panel1 = ZBasePanel.new(UI_TransformWin_002, 373, 216)
	panel1:setPosition(10, 280)
    panel:addChild(panel1.view)
    -- panel1.view:setIsVisible(false)

    -- 进度条
	self.progress_bar = ZXProgress:createWithValueEx(80,100,310,31,'ui/common/progress_pink.png','ui/common/process_yellow.png',false);
	self.progress_bar:setProgressValue(0,100);	
	self.progress_bar:setAnchorPoint(CCPointMake(0,0));
	self.progress_bar:setPosition(CCPointMake(30,170));
	panel1:addChild(self.progress_bar)

	self.progress_text = ZLabel.new("#cfff000祝福值:50")
 	self.progress_text:setPosition(115, 9)
    self.progress_bar:addChild(self.progress_text.view)

	-- 抗暴击
    self.label_def_critical = ZLabel.new("祝福值越高成功率越高")
    self.label_def_critical:setPosition(85, 140)
    panel1:addChild(self.label_def_critical)

     -- 开始进阶
    local function btn_up_fun1(eventType,x,y)
        if eventType == TOUCH_CLICK then
        	local auto_buy = self._is_switch_select
        	local id = self.select_index
        	-- self.auto_up=false
        	-- self:up_grade_miji(id,auto)
            TransformModel:set_auto_upgrade_skill( false )
            TransformModel:up_grade_miji( id, auto_buy )
        end
        return true
    end
    -- local btn1= MUtils:create_btn(panel1,UIPIC_COMMOM_002,UI_GeniusWin_0020,btn_up_fun1,50,8,120,40)

    self.jinjie_btn = CCNGBtnMulTex:buttonWithFile(50,8,126,43, UIPIC_COMMOM_002, 500, 500)
    self.jinjie_btn:addTexWithFile(CLICK_STATE_DOWN, UIPIC_COMMOM_002)
    --UI_TransformWin_003
    self.jinjie_btn:addTexWithFile(CLICK_STATE_DISABLE,UIPIC_COMMOM_004)
    self.jinjie_btn:registerScriptHandler(btn_up_fun1)
    panel1:addChild(self.jinjie_btn)
    MUtils:create_zxfont(self.jinjie_btn, "开始进阶", 126/2, 15, 2, 16)

     --自动进阶
    local function btn_up_fun11(eventType,x,y)
        if eventType == TOUCH_CLICK then
        	local auto_buy = self._is_switch_select
        	local id = self.select_index
        	-- self.auto_up=true
            local _miji_info = TransformModel:get_miji_info_by_id(id)
            if _miji_info then
                local skill_level = _miji_info.level
        		-- _current_skill_level=skill_level
        		-- local yb_cost = TransformConfig:get_upgrad_cost_by_level(skill_level)
        		-- if  PlayerAvatar:check_is_enough_money(4,yb_cost) then
        		-- 	TransformCC:request_upgrade_skill( id,auto )
        		-- end	
            TransformModel:set_auto_upgrade_skill( true )
            TransformModel:set_current_miji_level( skill_level )
            TransformModel:auto_upgrade( id, auto_buy )
        	end
        end
        return true
    end
    -- local btn11= MUtils:create_btn(panel1,UIPIC_COMMOM_002,UI_GeniusWin_0020,btn_up_fun11,205,8,120,40)
    self.aoto_jinjie_btn = CCNGBtnMulTex:buttonWithFile(205,8,126,43, UIPIC_COMMOM_002, 500, 500)
    self.aoto_jinjie_btn:addTexWithFile(CLICK_STATE_DOWN, UIPIC_COMMOM_002)
    --UI_TransformWin_003
    self.aoto_jinjie_btn:addTexWithFile(CLICK_STATE_DISABLE,UIPIC_COMMOM_004)
    self.aoto_jinjie_btn:registerScriptHandler(btn_up_fun11)
    panel1:addChild(self.aoto_jinjie_btn)
    MUtils:create_zxfont(self.aoto_jinjie_btn, "自动进阶", 126/2, 15, 2, 16)

    -- 点选按钮
	self.switch_but= self:create_one_switch_but( 200, 80, 160, 33, UIResourcePath.FileLocate.common .. 
        "dg-1.png", UIResourcePath.FileLocate.common .. "dg-2.png", "自动购买材料", 33+5, 14,"kSwitch")
    panel1:addChild( self.switch_but.view )
    self._is_switch_select=false

    -- slotitem
    self.slotitem = MUtils:create_one_slotItem( nil, 80, 60, 48, 48 )
    local item_id = TransformConfig:get_curr_stage_crystal_item_id(  )
    local function tip_func(  )
	    TipsModel:show_shop_tip( 400, 240, item_id )
    end
    self.slotitem:set_click_event(tip_func)
    panel1:addChild(self.slotitem.view)
 	self.slotitem:set_icon(item_id)
 	self._crystal_count_text = UILabel:create_label_1("0", CCSizeMake(40,20), 64-20, 0+8, 15, CCTextAlignmentRight, 255, 255, 255)
    self.slotitem.view:addChild(self._crystal_count_text,9)

    -- 附加属性
    local panel2 = ZBasePanel.new(UI_TransformWin_002, 373, 145)
	panel2:setPosition(10, 130)
    panel:addChild(panel2.view)
	local _left_down_title_panel = CCBasePanel:panelWithFile( 1, 116, 120, -1, UI_MountsWinNew_005, 500, 500 )
	panel2:addChild(_left_down_title_panel)
	local name_title = CCZXImage:imageWithFile(27, 3,-1,-1,UI_TransformWin_008,500,500)
	_left_down_title_panel:addChild(name_title)

	-- 攻击
    self.label_attack = ZLabel.new("攻    击：0")
    self.label_attack:setPosition(25, 90+2)
    panel2:addChild(self.label_attack)

    -- 抗暴击
    self.label_rcrit = ZLabel.new("抗 暴 击：0")
    self.label_rcrit:setPosition(208, 90+2)
    panel2:addChild(self.label_rcrit)

    -- 生命
    self.label_hp = ZLabel.new("生    命：0")
    self.label_hp:setPosition(25, 62+2)
    panel2:addChild(self.label_hp)

    -- 命中
    self.label_focus = ZLabel.new("命    中：0")
    self.label_focus:setPosition(208, 62+2)
    panel2:addChild(self.label_focus)

    -- 暴击
    self.label_crit = ZLabel.new("暴    击：0")
    self.label_crit:setPosition(25, 35+2)
    panel2:addChild(self.label_crit)

    -- 闪避
    self.label_dodge = ZLabel.new("闪    避：0")
    self.label_dodge:setPosition(208, 35+2)
    panel2:addChild(self.label_dodge)

    --精神防御
    self.label_mdef = ZLabel.new("精神防御：0")
    self.label_mdef:setPosition(25, 10+2)
    panel2:addChild(self.label_mdef)

    -- 物理防御
    self.label_wdef = ZLabel.new("物理防御：0")
    self.label_wdef:setPosition(208, 10)
    panel2:addChild(self.label_wdef)

	--进阶效果
	local panel3 = ZBasePanel.new(UI_TransformWin_002, 373, 115)
	panel3:setPosition(10, 10)
    panel:addChild(panel3.view)
	local _left_down_title_panel = CCBasePanel:panelWithFile( 1, 87, 120, -1, UI_MountsWinNew_005, 500, 500 )
	panel3:addChild(_left_down_title_panel)
	local name_title = CCZXImage:imageWithFile(27, 3,-1,-1,UI_TransformWin_009,500,500)
	_left_down_title_panel:addChild(name_title)

	local effect_str = "";
  	local temp_skill_dialog = ZDialog:create( panel, effect_str,20, 90, 330+25, 70, 16 )
  	temp_skill_dialog:setAnchorPoint(0, 1)
  	temp_skill_dialog.view:setLineEmptySpace(5)
  	self.skill_effect = temp_skill_dialog.view
 end

--升级秘籍
function TransformSkillPage:up_grade_miji( moji_id,_is_auto_buy )
	-- body
	local auto =_is_auto_buy
	local id = moji_id
	-- local _transform_info = TransformModel:get_transform_data( )
    local _miji_info = TransformModel:get_miji_info_by_id(id)
	-- local skill_level = _transform_info.mijis[id].level
    local skill_level = _miji_info.level
	if auto then--自动购买道具
		local yb_cost = TransformConfig:get_upgrad_cost_by_level(skill_level)
		if  PlayerAvatar:check_is_enough_money(4,yb_cost) then
			TransformCC:request_upgrade_skill( id,auto )
		end
    else       --纯道具升阶
    	-- 从背包获取当前阶级晶片的数量
		local count = TransformModel:get_yuli_crystal_count()
		local ciritical_count=TransformConfig:get_upgrad_need_critical(skill_level)
		if  ciritical_count > count then
			GlobalFunc:create_screen_notic( "进阶丹不足." );
		else
			TransformCC:request_upgrade_skill( id,auto )
		end
	end
end

-- -- 自动购买按钮，检测是否继续购买下去
-- -- 终止条件：1:技能等阶升级停止 2：元宝不足停止
--   function TransformSkillPage:auto_up_skill(  )
--   	if not self.auto_up then
--   		return
--   	end
--   	local auto = self._is_switch_select
--     local id = self.select_index
-- 	-- local _transform_info = TransformModel:get_transform_data( )
--     local _miji_info = TransformModel:get_miji_info_by_id(id)
-- 	-- if _transform_info then
--     if _miji_info then
-- 		-- local skill_level = _transform_info.mijis[id].level
--         local skill_level = _miji_info.level
-- 		if _current_skill_level==skill_level then
-- 			local yb_cost = TransformConfig:get_upgrad_cost_by_level(skill_level)
-- 			if  PlayerAvatar:check_is_enough_money(4,yb_cost) then
-- 				TransformCC:request_upgrade_skill( id,auto )
-- 			end	
-- 		end
-- 	end
--   end

-- 创建一个选择控件
function TransformSkillPage:create_one_switch_but( x, y, w, h, image_n, image_s, words, words_x, fontsize, but_key )
    local function switch_button_func(  )
        self._is_switch_select=not self._is_switch_select
    end
    local switch_but = UIButton:create_switch_button( x, y, w, h, image_n, image_s, words, words_x, fontsize, nil, nil, nil, nil, switch_button_func )
    switch_but.but_key = but_key
    return switch_but
end

-- 更新
 function TransformSkillPage:update(  )
    -- local _transform_info = TransformModel:get_transform_data( )
    self:selected_icon_cell(self.select_index)
 	self:update_miji_info(self.select_index, false)
 end

 function TransformSkillPage:active( show )
     if show then
        self:update()
    end
 end

-- 询问秘籍是否已经激活
 function TransformSkillPage:is_miji_active(miji_id)
    local _transform_info = TransformModel:get_transform_data( )
 	 for i,v in ipairs(_transform_info.mijis) do
 		if v.id==miji_id then
 			return true
 		end
 	 end
 	 return false
 end

-- 更新某一秘籍的信息
-- @param:秘籍ID
 function TransformSkillPage:update_miji_info(miji_id,show)

    for k,v in pairs(self.items_dict) do
        if not self:is_miji_active(k) then
            v.item:set_icon_dead_color()
        end

        local _miji_info = TransformModel:get_miji_info_by_id( k )
        local miji_level = _miji_info and _miji_info.level or 0
        v:set_item_level(miji_level)
    end

 	if (not self:is_miji_active(miji_id)) then
 		 self.jinjie_btn:setCurState(CLICK_STATE_DISABLE)
 		 self.aoto_jinjie_btn:setCurState(CLICK_STATE_DISABLE)
 		 self:change_info_panel(false)
 		 self.source_text:setText(TransformConfig:get_miji_source(miji_id))
 		 
 		local miji_icon= TransformConfig:get_miji_icon_path( miji_id)
        self.slotitem_need.need_id = TransformConfig:get_need_miji_id(miji_id)
 		self.slotitem_need:set_icon(self.slotitem_need.need_id)
 		-- self.slotitem_need:set_icon_dead_color()
 		
 		 if show then
 		 	-- GlobalFunc:create_screen_notic( "该秘籍还没激活" );
 		 end
 		 return
 	end

 	self:change_info_panel(true)
 	 self.jinjie_btn:setCurState(CLICK_STATE_UP)
 	 self.aoto_jinjie_btn:setCurState(CLICK_STATE_UP)
 	-- 获取加成属性
 	-- local _transform_info = TransformModel:get_transform_data( )
 	-- 秘籍信息
    local _miji_info = TransformModel:get_miji_info_by_id( miji_id )
 	local miji_info = TransformConfig:get_miji_info_by_id(miji_id)
 	local miji_level = _miji_info.level

    if miji_level == 10 then
        self.jinjie_btn:setCurState(CLICK_STATE_DISABLE)
        self.aoto_jinjie_btn:setCurState(CLICK_STATE_DISABLE)
     end
 	
 	-- 设置当前显示icon
 	-- 从背包获取当前阶级晶片的数量
    local count = TransformModel:get_yuli_crystal_count()
    -- 如果背包中相应阶晶石数为0，则置灰晶石图片
    if count == 0 then
        self.slotitem:set_slot_disable();
        self._crystal_count_text:setText("");
    else
        self.slotitem:set_slot_enable();
        if count > 1 then
            self._crystal_count_text:setText(tostring(count));
        end
    end
 	-- 进阶效果
 	local persent = TransformConfig:get_miji_defvalue( miji_id ,miji_level)/100
 	local persent_desc = persent .. TransformConfig:get_miji_effect(miji_id)
 	self.skill_effect:setText(persent_desc)
 	-- 进度条
 	local current_zhufu = _miji_info.Zhufu
 	local max_zhifu =TransformConfig:get_max_zhufu_by_level(miji_level)
 	self.progress_bar:setProgressValue(current_zhufu,max_zhifu);	
 	-- 更新加成属性
 	local atrr_add = TransformConfig:get_miji_attrs( miji_id ,miji_level)
 	self:update_miji_attr_info(atrr_add.attack,atrr_add.rcrit,atrr_add.lift,atrr_add.focus,atrr_add.crit,atrr_add.dodge,atrr_add.mdef,atrr_add.wdef,current_zhufu)

 end

-- 更新属性列表数据
 function TransformSkillPage:update_miji_attr_info(attack,rcrit,lift,focus,crit,dodge,mdef,wdef,zhufu)
  	-- 攻击
    self.label_attack :setText("攻    击："..attack)
    -- 抗暴击
    self.label_rcrit :setText("抗 暴 击："..rcrit)
    -- 生命
    self.label_hp :setText("生    命："..lift)
    -- 命中
    self.label_focus:setText("命    中："..focus)
    -- 暴击
    self.label_crit:setText("暴    击："..crit)
    -- 忍防
    self.label_dodge:setText("闪    避："..dodge)
    -- 暴击
    self.label_mdef:setText("精神防御："..mdef)
    -- 忍防
    self.label_wdef:setText("物理防御："..wdef)

    self.progress_text:setText("#cfff000祝福值:"..zhufu)
  end