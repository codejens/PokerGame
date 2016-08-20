-- GeniusHuaXingPage.lua 
-- createed by mwy @2012-5-7
-- 精灵装备页面


super_class.GeniusHuaXingPage(  )

function GeniusHuaXingPage:__init(pos_x,pos_y )
	self.attr_t={}
	local pos_x = x or 0
    local pos_y = y or 0
	self.view = CCBasePanel:panelWithFile( pos_x, pos_y, 835,  465+60, nil, 500, 500 )

	-- 底板
	local panel = self.view
	-- 右上
	local _right_up_panel = CCBasePanel:panelWithFile( 404+10, 222-6-2+46, 390+20, 263, UI_MountsWinNew_004, 500, 500 )
	panel:addChild(_right_up_panel)
	self.avator_panel=_right_up_panel
	-- 右下
	local _right_down_panel = CCBasePanel:panelWithFile( 404+10, 13, 390+20, 200+40, UI_MountsWinNew_004, 500, 500 )
	panel:addChild(_right_down_panel)
	-- 左
	_left_panel = CCBasePanel:panelWithFile( 11, 13, 390+10,465+44, UI_MountsWinNew_004, 500, 500 )
	panel:addChild(_left_panel)

	self:initUI(_left_panel,_right_up_panel,_right_down_panel)
end

-- 加载UI
function GeniusHuaXingPage:initUI( left_panel,right_up_panel,right_down_panel)

	self:init_left_view(left_panel)

	self:init_right_up_view(right_up_panel)

	self:init_right_down_view(right_down_panel)
end

function GeniusHuaXingPage:init_right_down_view( right_down_panel)
	--增加属性标题
	local _left_down_title_panel = CCBasePanel:panelWithFile( 1, 170+44, 120, -1, UI_MountsWinNew_005, 500, 500 )
	right_down_panel:addChild(_left_down_title_panel)
	local name_title = CCZXImage:imageWithFile(27, 3,-1,-1,UI_GeniusWin_0018,500,500)
	_left_down_title_panel:addChild(name_title)

	-- 字体背景
	for i=1,4 do
			local _attr_bg = CCBasePanel:panelWithFile( 122, 20+(i-1)*50, 250+4, -1, UI_MountsWinNew_006, 500, 500 )
			right_down_panel:addChild(_attr_bg)

			local item_t = {}
			local arrt_lab =  UILabel:create_lable_2( "111", 5, 6, 19, ALIGN_LEFT )
			_attr_bg:addChild(arrt_lab)

			-- local arrt_lab_add =  UILabel:create_lable_2( "#c0edc09升级:0", 175,6, 19, ALIGN_CENTER )
			-- _attr_bg:addChild(arrt_lab_add)

			item_t.attr=arrt_lab--属性基础值
			-- item_t.attr_add=arrt_lab_add--属性升级值

			table.insert(self.attr_t,item_t)
	end
	local x = 30-3
	local y = 25
	local offset_y = 2
	--生命
	local hp_lab = UILabel:create_lable_2( "生    命", x, y*7+offset_y, 19, ALIGN_LEFT );
	right_down_panel:addChild(hp_lab);

	-- 攻击
	local at_lab = UILabel:create_lable_2( "攻    击", x,  y*5+offset_y, 19, ALIGN_LEFT );
	right_down_panel:addChild(at_lab);

	-- 幻术防御
	local md_lab = UILabel:create_lable_2( "物理防御", x,y*3+offset_y, 19, ALIGN_LEFT );
	right_down_panel:addChild(md_lab);

	-- 忍书防御
	local bj_lab = UILabel:create_lable_2( "精神防御", x,y+offset_y, 19, ALIGN_LEFT );
	right_down_panel:addChild(bj_lab);

end

-- 创建左底版显示内容
function GeniusHuaXingPage:init_left_view( left_panel)
	local sprites_model = SpriteConfig:get_all_sprite_model( )

	self.equip_sell_scroll = self:create_scroll_area(sprites_model, 2, 10, 390, 490, 3, 7, "" )

	left_panel:addChild( self.equip_sell_scroll )

end

-- 创建右上底版显示内容
function GeniusHuaXingPage:init_right_up_view( right_up_panel)
	-- 坐骑背景
	self.fabao_panel = CCBasePanel:panelWithFile( 1,1,390+20-2, 263-2, UI_GeniusWin_0013, 500, 500 )
	right_up_panel:addChild(self.fabao_panel)

	-- 底图边角
	local corner_1 = MUtils:create_sprite(self.fabao_panel,UI_GeniusWin_0052,20,241)
	corner_1:setRotation(270)

	local corner_2 = MUtils:create_sprite(self.fabao_panel,UI_GeniusWin_0052,389,241)

	-- 式神底圈
	local bottom_circle= CCZXImage:imageWithFile(74, 27,-1,-1,UI_GeniusWin_0051,500,500)
	self.fabao_panel:addChild(bottom_circle)

	-- 法宝动画形象
    local action = UI_GENIUS_ACTION;
    self.fabao_animate = MUtils:create_animation(162+39,160-18,"frame/gem/00001",action );
    self.fabao_panel:addChild(self.fabao_animate);

	--坐骑名底色
	local name_bg = CCZXImage:imageWithFile(114+20, 250-22,145,-1,UI_MountsWinNew_016,500,500)
	self.fabao_panel:addChild(name_bg)

	-- 坐骑名字 	
	self.fabao_name = UILabel:create_lable_2( "#cfff000白虎", 70, 6, 20, ALIGN_CENTER );
	name_bg:addChild(self.fabao_name);

	-- 战斗力
	-- local _power_bg = CCBasePanel:panelWithFile( 73,8,260, -1, UI_MountsWinNew_017, 500, 500 )
	-- self.fabao_panel:addChild(_power_bg)
	-- -- 战斗力文字
	-- local _power_title = CCZXImage:imageWithFile(60,17,-1,-1,UI_MountsWinNew_018)
 --    _power_bg:addChild(_power_title)
 --    -- 战斗力值
	-- self.mounts_fight = ZXLabelAtlas:createWithString("99999",UIResourcePath.FileLocate.normal .. "number");
	-- self.mounts_fight:setPosition(CCPointMake(130,17));
	-- self.mounts_fight:setAnchorPoint(CCPointMake(0,0));
	-- _power_bg:addChild(self.mounts_fight);

	-- 化形按钮事件
	local function huaxing_event()
		if self.cur_model_id then
			SpriteModel:req_sprite_huaxing( self.cur_model_id)
		end
		return true
	end

	-- 化形按钮
	self.huaxing_btn = ZButton:create(nil,UI_GeniusWin_0042,huaxing_event, 130, 12, -1, -1);
	self.fabao_panel:addChild(self.huaxing_btn.view,256)
	self.huaxing_btn.view:addTexWithFile(CLICK_STATE_DISABLE, UI_GeniusWin_0043)
	--更改外观按钮
	local tihuan_lab = CCZXImage:imageWithFile(11, 13,-1,-1,UI_GeniusWin_0047,500,500);
	self.huaxing_btn:addChild(tihuan_lab)
end

function GeniusHuaXingPage:update( )
	-- body
	self:update_sprite_info(  )

end

-- 更新法宝信息
function GeniusHuaXingPage:update_sprite_info(  )
	 local sprite_info = SpriteModel:get_sprite_info( ) 
    if sprite_info then
        -- 更新精灵属性
        local rebirth_config = SpriteConfig:get_sprite_data_by_rebirthLv(sprite_info.lunhui_level);
        self.fabao_name:setText( rebirth_config.name );

        -- 获取精灵当前级别再升一级加成的属性
        local attr_t = SpriteConfig:get_spirits_attr_add(sprite_info.level,sprite_info.lunhui_level,sprite_info.lunhui_star_level)

        -- 四个基本属性
        -- 生命
		self.attr_t[4].attr:setText(tostring(sprite_info.attr_life))
		-- self.attr_t[4].attr_add:setText('升级:+'..tostring(attr_t.life_add))
		-- 攻击
		self.attr_t[3].attr:setText(tostring(sprite_info.attr_attack))
		-- self.attr_t[3].attr_add:setText('升级:+'..tostring(attr_t.attack_add))
		-- 物防
		self.attr_t[2].attr:setText(tostring(sprite_info.attr_wDefense))
		-- self.attr_t[2].attr_add:setText('升级:+'..tostring(attr_t.w_defence_add))
		-- 魔防
		self.attr_t[1].attr:setText(tostring(sprite_info.attr_mDefense))
		-- self.attr_t[1].attr_add:setText('升级:+'..tostring(attr_t.m_defence_add))

	    -- 更新法宝模型
	    self:update_current_sprite_avatar( sprite_info.model_id  )
    end

end

-- 创建可拖动区域   参数：放入scroll的panel的集合, 坐标， 区域大小，列数，可见行数， 背景名称
function GeniusHuaXingPage:create_scroll_area( panel_table_para,pos_x, pos_y, size_w, size_h, colu_num, sight_num, bg_name)

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

            local bg = CCBasePanel:panelWithFile(0, 0, size_w, 110, nil)

            for i = 1, colu_num do     
            	local mounts_model= panel_table_para[mount_index]
            	if mounts_model then
	            	mount_index=mount_index+1
		            local sell_panel = self:create_one_scroll_sell_panel( mounts_model,16+ ( size_w / colu_num -10) * ( i - 1), 0, size_w / colu_num, size_h / row_num)
	                bg:addChild( sell_panel )
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
function GeniusHuaXingPage:create_one_scroll_sell_panel( panel_table_para ,x, y, w, h  )
    local sell_panel_bg = CCBasePanel:panelWithFile( x, y , w, h , nil )
    if panel_table_para == nil then
        return sell_panel_bg
    end
    -- 匹配
    local function match_btn_click( model_id)
    	-- local model_id = SpriteModel:get_sprite_modle_id(fabao_id)
        self:update_current_sprite_avatar(model_id)
    end
    local callback = match_btn_click
    local _geniusIconCell = GeniusIconCell(panel_table_para, 5, 5,callback )
    sell_panel_bg:addChild( _geniusIconCell.view )
    return sell_panel_bg
end

-- 更新当前法宝形象
function GeniusHuaXingPage:update_current_sprite_avatar( model_id )
    if self.fabao_animate then
        self.fabao_animate:removeFromParentAndCleanup(true);
    end
    local frame_str = string.format("frame/gem/%05d",model_id);
    local action = UI_GENIUS_ACTION;
    self.fabao_animate = MUtils:create_animation( 162+39,160-18,frame_str,action );
    self.fabao_panel:addChild( self.fabao_animate );

    -- 设置当前的化形模型ID
	self.cur_model_id = model_id;

	-- 更新精灵名称
	local rebirth_config = SpriteConfig:get_sprite_data_by_rebirthLv(self.cur_model_id);
    
    self.fabao_name:setText( rebirth_config.name );

	--所选式神阶级小于玩家当前阶级
	local sprite_info = SpriteModel:get_sprite_info()
	
	if sprite_info~= nil then
		if self.cur_model_id <= SpriteModel:get_sprite_modle_id(sprite_info.lunhui_level) then
			self.huaxing_btn:setCurState(CLICK_STATE_UP);
		else
			self.huaxing_btn:setCurState(CLICK_STATE_DISABLE);
		end
	end		
end

--xiehande 点击化形之后将按钮灰化
function GeniusHuaXingPage:update_state(  )
	self.update();
	self.huaxing_btn:setCurState(CLICK_STATE_DISABLE);
end
