-- TransformCardPage.lua 
-- createed by mwy @2012-5-26
-- 新建坐骑洗炼页面

super_class.TransformCardPage(  )

local not_active = 1         --未激活
local is_transformming = 2   --变身
local recover_transform = 3  --还原变身
local not_has_transform = 4  --未激活变身
local _select_index = 1

function TransformCardPage:__init( x,y)
	self.items_dict={}
	local pos_x = x or 0
    local pos_y = y or 0
	self.view = ZBasePanel.new(nil, 800, 530).view
	 -- CCBasePanel:panelWithFile( pos_x, pos_y, 835, 386+102, nil, 500, 500 )
	 -- _select_index=1
	-- 底板
	local panel = self.view

	-- 左
	local _left_panel = ZBasePanel.new(UI_MountsWinNew_004, 380, 507)
	_left_panel:setPosition(11, 12)
    panel:addChild(_left_panel.view)

    -- 右上
	local _right_up_panel = ZBasePanel.new(UI_MountsWinNew_004, 393, 150+10)
	_right_up_panel:setPosition(395, 18+350-10)
    panel:addChild(_right_up_panel.view)

    -- 右中
	self._right_mid_panel = ZBasePanel.new(UI_MountsWinNew_004, 393, 195)
	self._right_mid_panel:setPosition(395, 170-10)
    panel:addChild(self._right_mid_panel.view)
    -- 右下
    local _right_down_panel = ZBasePanel.new(UI_MountsWinNew_004, 393, 100)
	_right_down_panel:setPosition(395, 12+55-10)
    panel:addChild(_right_down_panel.view)

	--CCBasePanel:panelWithFile( 11, 12, 390+10,465, UI_MountsWinNew_004, 500, 500 )
	-- panel:addChild(_left_panel)

	self:create_left_panel(_left_panel)
	self:create_right_up_panel(_right_up_panel)
	self:create_right_mid_panel(self._right_mid_panel)
	self:create_right_down_panel(_right_down_panel)

    -- 培养按钮
    local function py_btn_even(eventType,x,y)
        if eventType == TOUCH_CLICK then
        	-- TransformModel:request_active_transform(_select_index)--激活某个变身
        	-- TransformCC:request_recover_transform( )
        	local win= UIManager:show_window("transform_dev_win");
        	-- local stage_level = TransformModel:get_transform_stage_level_by_id(_select_index )
        	win:set_transform_info(_select_index)

        end
        return true
    end
    self.py_btn = CCNGBtnMulTex:buttonWithFile(440,10,120,40, UIPIC_COMMOM_002, 500, 500)
    self.py_btn:addTexWithFile(CLICK_STATE_DOWN, UIPIC_COMMOM_002)
    --UIPIC_COMMOM_004
    self.py_btn:addTexWithFile(CLICK_STATE_DISABLE,UIPIC_COMMOM_004)
    self.py_btn:registerScriptHandler(py_btn_even)
    panel:addChild(self.py_btn)
     MUtils:create_zxfont(self.py_btn,"培 养",35,14,1,16)
	-- self.py_btn:setCurState(CLICK_STATE_DISABLE)

    -- 仙化按钮
    local function xh_btn_even(eventType,x,y)
        if eventType == TOUCH_CLICK then
        	TransformModel:request_transform(1)
        end
        return true
    end
    self.xb_btn = CCNGBtnMulTex:buttonWithFile(620,10,120,40, UIPIC_COMMOM_002, 500, 500)
    self.xb_btn:addTexWithFile(CLICK_STATE_DOWN, UIPIC_COMMOM_002)
    --UI_TransformWin_003
    self.xb_btn:addTexWithFile(CLICK_STATE_DISABLE,UIPIC_COMMOM_004)
    self.xb_btn:registerScriptHandler(xh_btn_even)
    panel:addChild(self.xb_btn)
     MUtils:create_zxfont(self.xb_btn,"仙 化",35,14,1,16)
	self.xb_btn:setCurState(CLICK_STATE_DISABLE)

    -- 人物加个特效 100002
end

-- 创建左底版显示内容
function TransformCardPage:create_left_panel( panel)

	local ninja_models =TransformConfig:get_all_ninja_models(  )
	self.equip_sell_scroll = self:create_scroll_area(ninja_models, 5, 40, 370, 496-35, 3, 7, "" )
	panel:addChild( self.equip_sell_scroll )

    -- 总评分
    self.all_fight_val = MUtils:create_zxfont(panel, "#cfff000总战斗力：0", 15, 12, 1, 16)
end

-- 创建右底版显示内容
function TransformCardPage:create_right_up_panel( panel)
	--增加属性标题
	local _left_down_title_panel = CCBasePanel:panelWithFile( 1, 120+10, 120, -1, UI_MountsWinNew_005, 500, 500 )
	panel:addChild(_left_down_title_panel)
	local name_title = CCZXImage:imageWithFile(27, 3,-1,-1,UI_GeniusWin_0018,500,500)
	_left_down_title_panel:addChild(name_title)

	-- 忍者介绍
	local effect_str = "第三方桂附地黄个人的更好地发挥风格风格结合国家刚回家话费";
  	local temp_skill_dialog = ZDialog:create( panel, effect_str,5, 110+10+10, 385, 80, 16 )
  	temp_skill_dialog:setAnchorPoint(0, 1)
  	temp_skill_dialog.view:setLineEmptySpace(2)
  	self.skill_effect = temp_skill_dialog.view

	-- 技能
	self.arrt_skill =  UILabel:create_lable_2( "技能：心灵控制",5,40+10+10, 18, ALIGN_LEFT )
	panel:addChild(self.arrt_skill)
	-- 技能说明
	-- self.skill_desc =  UILabel:create_lable_2( "#c0edc09攻击时可以将目标杀死100次,持续10秒.", 5, 10, 15, ALIGN_LEFT )
	-- panel:addChild(self.skill_desc)
    temp_skill_dialog = ZDialog:create( panel, "#c0edc09攻击时可以将目标杀死100次,持续10秒.", 5, 54, 385, 40, 15 )
    temp_skill_dialog:setAnchorPoint(0, 1)
    temp_skill_dialog.view:setLineEmptySpace(2)
    self.skill_desc = temp_skill_dialog.view
end
-- 创建右底版显示内容
function TransformCardPage:create_right_mid_panel( panel)
    -- 称号
    self.ninja_lv_name = MUtils:create_zxfont( panel, "上忍精英", 5, 170, 1, 16)
    self.ninja_fight_val = MUtils:create_zxfont( panel, "妈逼战斗力你去死", 385, 170, 3, 16)
    self.ninja_lv_name:setIsVisible(false)
    self.ninja_lv_name:setIsVisible(false)

	-- 创建人物模型
    local action = UI_TRANSFORM_ACTION;
    self.ninja_animate = MUtils:create_animation(200, 60, nil, action)
    panel:addChild(self.ninja_animate)

    -- 变身按钮
    local function btn_up_fun(eventType,x,y)
        if eventType == TOUCH_CLICK then
            Instruction:handleUIComponentClick(instruct_comps.ANY_BTN)
        	local ninja_id = _select_index
            local cur_transform_id = TransformModel:get_cur_transform_id()
			if self.statues==is_transformming then--变身状态，可以请求还原到未变身状态
                if ninja_id == cur_transform_id then
    				-- 请求变身还原
    				TransformModel:request_recover_transform()
                else
                    -- 请求变身
                    TransformModel:request_transform(ninja_id)
                end
			elseif self.statues==recover_transform then--未变身状态，可以请求变身
				-- 请求变身
				TransformModel:request_transform(ninja_id)
			elseif self.statues==not_active then--未激活状态
				TransformModel:request_active_transform(ninja_id)--激活某个变身
			elseif self.statues==not_has_transform then--未激活状态	
				-- 请求变身
			end
        end
        return true
    end
    self.transform_btn = CCNGBtnMulTex:buttonWithFile(140,70-60,120,40, UIPIC_COMMOM_002, 500, 500)
    self.transform_btn:addTexWithFile(CLICK_STATE_DOWN, UIPIC_COMMOM_002)
    --UI_TransformWin_003
    self.transform_btn:addTexWithFile(CLICK_STATE_DISABLE,UIPIC_COMMOM_004)
    self.transform_btn:registerScriptHandler(btn_up_fun)
    panel:addChild(self.transform_btn)
    self.statues_text=MUtils:create_zxfont( self.transform_btn,"变  身",126/2,15,2,16)

end
-- 创建右底版显示内容
function TransformCardPage:create_right_down_panel( panel)
	-- 是否已经获得忍者
	self.desc_1 =  UILabel:create_lable_2( "尚未获得该忍者.",205,63, 18, ALIGN_CENTER )
	panel:addChild(self.desc_1)
	-- 获取途径
	self.desc_2 =  UILabel:create_lable_2( "#c0edc09获取途径：产生反感的风格回复的话.", 200, 25, 15, ALIGN_CENTER )
	panel:addChild(self.desc_2)
end

-- 创建可拖动区域   参数：放入scroll的panel的集合, 坐标， 区域大小，列数，可见行数， 背景名称
function TransformCardPage:create_scroll_area( panel_table_para,pos_x, pos_y, size_w, size_h, colu_num, sight_num, bg_name)

	local mount_index = 1
    local row_num = math.ceil( #panel_table_para / colu_num )
    if row_num < 3 then
        row_num = 3
    end
    --local scroll = CCScroll:scrollWithFile(pos_x, pos_y, size_w, size_h, sight_num, colu_num, row_num , bg_name, TYPE_VERTICAL, 500,500)
    local _scroll_info = { x = pos_x, y = pos_y, width = size_w, height = size_h, max_num = row_num, image = bg_name, stype = TYPE_HORIZONTAL }

    local scroll = CCScroll:scrollWithFile( _scroll_info.x, _scroll_info.y, _scroll_info.width, _scroll_info.height, _scroll_info.max_num, _scroll_info.image, _scroll_info.stype, 600, 600 )

    -- scroll:setScrollLump( UIResourcePath.FileLocate.common .. "up_progress.png", UIResourcePath.FileLocate.common .. "down_progress.png", 4, 20, size_h / row_num )
    -- print("@@@@@@@@@@@@@@@@@@@@@size_h / row_num=",size_h / row_num)
    --scroll:setEnableCut(true)
    local had_add_t = {}
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

            local index = x * colu_num--y * colu_num + x + 1

            local bg = CCBasePanel:panelWithFile(0, 0, size_w, 120, nil)

            for i = 1, colu_num do     
            	local mounts_model= panel_table_para[mount_index]

            	if mounts_model then            		
	            	
		            local sell_panel = self:create_one_scroll_sell_panel( mounts_model,mount_index, ( size_w / colu_num) * ( i - 1), 0, size_w / colu_num, size_h / row_num)
	                bg:addChild( sell_panel )

	                 mount_index=mount_index+1
            	end
            end
            scroll:addItem(bg)
            scroll:refresh()
            return false
        end
    end
    scroll:registerScriptHandler(scrollfun)
    scroll:refresh()
    return scroll
end
-- 创建一个 scroll 中的  出售panel
function TransformCardPage:create_one_scroll_sell_panel( panel_table_para ,index,x, y, w, h  )
    local sell_panel_bg = CCBasePanel:panelWithFile( x, y , w, h , nil )
    if panel_table_para == nil then
        return sell_panel_bg
    end
    -- 匹配
    local function match_btn_click( model_index,item)
    	_select_index=model_index
    	-- 获取点选的变身等级
    	local level = TransformModel:get_transform_level_by_id(model_index )
    	-- 更新
        self:update_ninja_info_by_id(model_index,level)
        -- 播放选中特效
        local spr = SlotEffectManager.play_effect_by_slot_item( item )
        spr:setPosition(CCPointMake(24, 24))
        -- item:play_activity_effect()
    end
    local callback = match_btn_click
    local icon_cell = NinjiaIconHead(panel_table_para, index, 5, 3,callback )
    table.insert(self.items_dict,icon_cell)
    sell_panel_bg:addChild( icon_cell.view )
    return sell_panel_bg
end

-- 更新当前法宝形象
function TransformCardPage:update_current_ninja_avatar( model_id )
    if self.ninja_animate then
        self.ninja_animate:removeFromParentAndCleanup(true);
    end
    -- 获取模型ID
    local _model_id = TransformConfig:get_ninja_modelid_by_id( model_id )

    local frame_str='frame/human/0/'.._model_id

    local action = UI_TRANSFORM_ACTION;
    self.ninja_animate = MUtils:create_animation( 200, 60,frame_str,action );
    self._right_mid_panel:addChild( self.ninja_animate );
end

 function TransformCardPage:update_ninja_info_by_id( model_id,stage_level )

    --选中当前变身卡
    local icon_item = self.items_dict[model_id].item
    local spr = SlotEffectManager.play_effect_by_slot_item( icon_item )
    spr:setPosition(CCPointMake(24, 24))
    
    -- 更新变身动画
    self:update_current_ninja_avatar(model_id)
    -- 变身信息显示
    local ninja_model = TransformConfig:get_ninja_model_by_id(model_id)
    local getway = TransformConfig:get_ninja_orige_way_by_id( model_id )

    local name =ninja_model.name
    local pieceNum = ninja_model.pieceNum
    local skillid = ninja_model.skillid
    local modelid = ninja_model.modelid
    local desc = ninja_model.desc
    local attrs = ninja_model.attrs
    -- 暂时修正一下
    if stage_level ==0 then
        stage_level=1
    end
    local skill_name,skill_desc = SkillConfig:get_skill_by_id_and_level(skillid,stage_level)

    self.skill_effect:setText(desc);
    self.arrt_skill:setText( "技能："..skill_name)
    self.skill_desc:setText("#c0edc09"..skill_desc)
    self.desc_2:setText("#c0edc09"..getway)

    -- 是否已经获得该变身
    if not TransformModel:is_has_transformm(model_id) then --尚未获得变身
    	-- GlobalFunc:create_screen_notic( "尚未获得变身." );
        local piece = TransformModel:get_transform_pieces( model_id )
        local need_piece = TransformConfig:get_piece_num_by_id( model_id )
    	self:set_op_statues( 4, piece, need_piece )

        self.ninja_lv_name:setIsVisible(false)
        self.ninja_fight_val:setIsVisible(false)
    	return
    end
    -------- 已经获得该变身
    self.ninja_lv_name:setIsVisible(true)
    self.ninja_fight_val:setIsVisible(true)
    local stage = TransformModel:get_transform_stage_by_id(model_id)
    local title = TransformConfig.title_t[stage + 1] or TransformConfig.title_t[stage]
    self.ninja_lv_name:setText(title)
    local fight_val = TransformModel:get_point_by_id(model_id)
    self.ninja_fight_val:setText("战斗力：" .. fight_val)
    
    local level =  TransformModel:get_transform_level_by_id(model_id ) 
    local cur_transform_id = TransformModel:get_cur_transform_id()
    -- 获取变身等级
    --是否已经激活变身
    -- ZXLog('--------------------------------')
	if TransformModel:is_transform_active( model_id,level) then  
		--是否正在变身状态
		if TransformModel:is_transformming() then
			--显示变身状态
            if cur_transform_id == model_id then
                self:set_op_statues( is_transformming )
            else
                self:set_op_statues( recover_transform )
            end
		else
			-- 显示未变身状态
			self:set_op_statues( 3 )
		end
	else
		self:set_op_statues( 1 )
	end
 end

 function TransformCardPage:update(  )
 	local model_id = _select_index
 	local model_level = TransformModel:get_transform_level_by_id(model_id )
 	self:update_ninja_info_by_id(model_id,model_level)
 	self:update_ninjia_card()
    self:update_point()
 end

-- 更新忍者卡列表
function TransformCardPage:update_ninjia_card(  )
	local _transforms    = TransformModel:get_transform_data( ).transforms
	for i=1,#self.items_dict do
		local icon_cell = self.items_dict[i]
		icon_cell.item:set_icon_dead_color()
	end
    --
	for i=1,#_transforms do
		local icon_cell = self.items_dict[_transforms[i].id]
        if TransformModel:is_has_transformm(icon_cell.model_id) then
            icon_cell.item:set_icon_light_color()
        end
	end
end

-- 更新变身按钮状态
function TransformCardPage:set_op_statues( op_type, piece, need_piece )
	 self.statues=op_type
	if op_type==not_active then
		  self.transform_btn:setCurState(CLICK_STATE_UP)
		   self.py_btn:setCurState(CLICK_STATE_DISABLE)
		  self.desc_1:setText(LangGameString[2427]) -- "已获得该忍者,请激活."
		  self.statues_text:setText(LangGameString[2428]) -- "激  活"
		  -- self.statues_text:setPosition(42,14)
	elseif op_type==is_transformming then
		  self.transform_btn:setCurState(CLICK_STATE_UP)
		  self.py_btn:setCurState(CLICK_STATE_UP)
		  self.statues_text:setText(LangGameString[2429]) -- "还  原"
		  self.desc_1:setText(LangGameString[2426]) -- "已获得该忍者."
		  -- self.statues_text:setPosition(42,14)
	elseif op_type==recover_transform then
		  self.transform_btn:setCurState(CLICK_STATE_UP)
		  self.py_btn:setCurState(CLICK_STATE_UP)
		  self.desc_1:setText(LangGameString[2425]) -- "已获得该忍者."
		  self.statues_text:setText(LangGameString[2430]) -- "变  身"
		  -- self.statues_text:setPosition(42,14)
    elseif op_type==not_has_transform then
		  self.transform_btn:setCurState(CLICK_STATE_DISABLE)
		  self.py_btn:setCurState(CLICK_STATE_DISABLE)
		  self.desc_1:setText(string.format(LangGameString[2423], (piece or 0), (need_piece or 30))) -- "尚未获得该忍者."
		  self.statues_text:setText(LangGameString[2424])  -- "尚未获得"
		  -- self.statues_text:setPosition(22,14)
	end
end

function TransformCardPage:update_point()
    local point = TransformModel:get_total_point(  )
    self.all_fight_val:setText("#cfff000总战斗力：" .. point)
end
