-- FabaoUplevelWin.lua
-- created by fangjiehua on 2013-5-23
-- 法宝系统--提升窗口

super_class.FabaoUplevelWin(NormalStyleWindow)

local _crystal_ids = {18603,18604,18605};

-- 初始化
function FabaoUplevelWin:__init( )

    --背景低图
    local base_bg = CCBasePanel:panelWithFile(10,12,366,376,UIPIC_GRID_nine_grid_bg3,500,500);
    self:addChild(base_bg);

	-- 标题
	local title = CCZXImage:imageWithFile(135,402,-1,-1,UIResourcePath.FileLocate.faBao .. "uplevel_title.png");
	self:addChild(title);

	-- 关闭按钮
	-- local close_btn = CCNGBtnMulTex:buttonWithFile(0, 0, -1, -1, UIResourcePath.FileLocate.common .. "close_btn_n.png")
 --    local exit_btn_size = close_btn:getSize()
 --    local spr_bg_size = self:getSize()
 --    close_btn:setPosition( spr_bg_size.width - exit_btn_size.width, spr_bg_size.height - exit_btn_size.height )
 --  	close_btn:addTexWithFile(CLICK_STATE_DOWN,UIResourcePath.FileLocate.common .. "close_btn_s.png")
 --  	--注册关闭事件
 --  	local function close_fun( eventType )
 --  		if eventType == TOUCH_CLICK then
	-- 	  	UIManager:hide_window("fabao_uplevel_win");
	--   	end
	--   	return true
 --  	end
	
	-- close_btn:registerScriptHandler(close_fun) 
 --    self:addChild(close_btn)

    -- 法宝名字
    local name_lab = UILabel:create_lable_2( LangGameString[944], 40, 348, 14, ALIGN_LEFT ); -- [944]="#c38ff33法宝名称:"
    self:addChild(name_lab);
    --
    self.fabao_name = UILabel:create_lable_2( LangGameString[96], 40+75, 348, 14, ALIGN_LEFT ); -- [96]="炼妖归元葫"
    self:addChild(self.fabao_name);

    -- 法宝等级
    local level_lab = UILabel:create_lable_2( LangGameString[945], 40, 348-25, 14, ALIGN_LEFT ); -- [945]="#c38ff33等    级:"
    self:addChild(level_lab);

    self.level = UILabel:create_lable_2( "1", 40+80, 348-25, 14, ALIGN_LEFT );
    self:addChild(self.level);

    -- 经验
    local progress_lab = UILabel:create_lable_2( LangGameString[946], 40, 348-50, 14, ALIGN_LEFT ); -- [946]="#c38ff33经    验:"
    self:addChild(progress_lab);

    self.progress_bar = ZXProgress:createWithValueEx( 0, 104, 160, 17,UILH_NORMAL.progress_bg2,UILH_NORMAL.progress_bar, true );
    self.progress_bar:setPosition(CCPointMake(40+82, 346-46));
    self:addChild(self.progress_bar);

    -- 分割层文字
    local split_img = ZImage:create(self.view,UIResourcePath.FileLocate.common .. "quan_bg.png",13,264,360,-1,nil ,500,500);

    --使用法宝晶石增加法宝经验:
    --local tip_lab = UILabel:create_lable_2( LangGameString[947], 40-15, 305-32, 14, ALIGN_LEFT ); -- [947]="#cfff000使用法宝晶石增加法宝经验:"
    --self:addChild(tip_lab);
    
    local tip_lab1 = UILabel:create_lable_2("#cfff000使用法宝晶石增加法宝经验" ,30, 305-34, 14, ALIGN_LEFT)
    self:addChild(tip_lab1);
    local tip_lab2 = UILabel:create_lable_2( LangGameString[948], 32+200, 305-34, 14, ALIGN_LEFT ); -- [948]="(兑换、商城购买)"
    self:addChild(tip_lab2);

    
    self.crystal_dict = {};
    for i=1,3 do

    	local function selected_crystal( eventType )

            if eventType == TOUCH_CLICK then
        		self:selected_crystal(i);
            end
            
            return true;

    	end 

        local panel = CCBasePanel:panelWithFile( 85, 200-(i-1)*65, 240, 62, "" );
        panel:registerScriptHandler(selected_crystal);
        self:addChild(panel);

    	local item = MUtils:create_one_slotItem( _crystal_ids[i], 0, 0, 48, 48 );
        
        -- local num = ItemModel:get_item_count_by_id( _crystal_ids[i] );
        -- item:set_item_count(num);
        -- if num == 0 then
        --     item:set_icon_dead_color();
        -- end


        local function tip_func(  )
            TipsModel:show_shop_tip( 0, 0, _crystal_ids[i], TipsModel.LAYOUT_LEFT)
        end
        item:set_click_event(tip_func);
    	panel:addChild(item.view);

        self.crystal_dict[i] = item;
    	local text ;
    	if i == 1 then
    		text = LangGameString[949] -- [949]="#c38ff33初级法宝晶石"
    	elseif i == 2 then
    		text = LangGameString[950] -- [950]="#c00c0ff中级法宝晶石"
    	elseif i == 3 then
    		text = LangGameString[951] -- [951]="#cff66cc高级法宝晶石"
    	end
    	local lab = UILabel:create_lable_2( text, 70, 15, 14, ALIGN_LEFT );
    	panel:addChild(lab);

    end
    -- 选中框
    self.crystal_select_frame = MUtils:create_zximg(self.view, "nopack/ani_corner2.png", 11, 200-12, 364, -1, 3, 3);
    --晶石选择索引
    self.crestal_select_index = 1;

    self:update_crystal_count();

    self.switch_btn_var = false;
    local function selected_switch_btn( bool )
        self.switch_btn_var = bool;
        SetSystemModel:set_one_date( SetSystemModel.COST_UPGRADE_GEM, self.switch_btn_var )
    end
    -- 材料不足时，使用元宝代替
    self.use_yb = UIButton:create_switch_button( 34, 22, 270, 30, UIResourcePath.FileLocate.common .. "dg-1.png", UIResourcePath.FileLocate.common .. "dg-2.png",
                         LangGameString[952], 23, 14, nil, nil, nil, nil, selected_switch_btn ); -- [952]="材料不足时，使用10元宝代替"
    self:addChild(self.use_yb.view);

    -- 使用按钮
    local uplevel_btn = TextButton:create(nil, 304, 20, 65, 30, LangGameString[834], UIResourcePath.FileLocate.common .. "button2.png"); -- [834]="使用"
    --申请提升法宝
    local function up_level_event(  )
        FabaoModel:req_up_fabao_level( self.crestal_select_index, self.switch_btn_var )
    end
    
    uplevel_btn:setTouchClickFun(up_level_event);
    self:addChild(uplevel_btn.view);


end

function FabaoUplevelWin:selected_crystal( i )
    local yb,y ;
    if i==1 then
        yb = 10;
        y = 189;
    elseif i == 2 then
        yb = 25;
        y = 189-65;
    elseif i == 3 then
        yb = 80;
        y = 189-65*2;
    end
    self.use_yb.setString(string.format(LangGameString[953],yb)); -- [953]="材料不足时，使用%d元宝代替"
    -- 移动
    local move_to = CCMoveTo:actionWithDuration(0.3, CCPointMake(11,y));
    local act_easa = CCEaseExponentialOut:actionWithAction(move_to);
    self.crystal_select_frame:runAction(act_easa);
    
    self.crestal_select_index = i;
end

--------------------界面更新
function FabaoUplevelWin:active( show )
    
    self:update();

    if ( show ) then
        -- 打开前先删除一次性的特效
        -- LuaEffectManager:stop_view_effect( 82,self.view );
        -- LuaEffectManager:stop_view_effect( 83,self.view );
        -- LuaEffectManager:stop_view_effect( 84,self.view );
        LuaEffectManager:stop_view_effect( 10015,self.view );
        LuaEffectManager:stop_view_effect( 9,self.view );
        self:update_crystal_count();

        if FabaoModel:if_can_upgrade( )==true then 
            LuaEffectManager:play_view_effect( 9, 340, 33, self.view, false )
        end        
    end
end

function FabaoUplevelWin:update(  )

    local fabao_info = FabaoModel:get_fabao_info( ) 
    if fabao_info then
        -- 更新法宝属性
        local fabao_config = FabaoConfig:get_fabao( fabao_info.jingjie, fabao_info.level - (fabao_info.jingjie-1)*10 );
        self.fabao_name:setText( fabao_config.name );
        self.level:setText( fabao_info.level );
        self.progress_bar:setProgressValue( fabao_info.exp, fabao_config.baseAttrs.upExp );

    end
    self:update_crystal_count();

    -- 更新选择框
    self.switch_btn_var = SetSystemModel:get_date_value_by_key( SetSystemModel.COST_UPGRADE_GEM );
    self.use_yb.set_state( self.switch_btn_var );
end

-- 播放暴击特效
-- effect_type 1,初级晶石暴击 2,中级晶石暴击 3,高级晶石暴击
function FabaoUplevelWin:play_cri_animation( effect_type )
    -- 暂时屏蔽
    -- local effect_id = 0;
    -- if ( effect_type == 1 ) then
    --     effect_id = 82;
    -- elseif effect_type == 2 then
    --     effect_id = 83;
    -- elseif effect_type == 3 then
    --     effect_id = 84;
    -- end 
     LuaEffectManager:play_view_effect( 10015,260,240,self.view,false,5 );
end

-- 更新晶石数量
function FabaoUplevelWin:update_crystal_count(  )
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
    local win  = UIManager:find_visible_window("fabao_win")
    if win then 
        win:update_fabao_upgrade_tip()
    end 
end
