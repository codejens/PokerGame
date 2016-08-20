-- XianhunCell.lua
-- created by fangjiehua on 2013-5-22
-- 法宝系统-- 器魂cell

super_class.XianhunCell();

XianhunCell.CELL_FOR_SCROLL = 1;
XianhunCell.CELL_FOR_INTRO_SCROLL = 2;
XianhunCell.CELL_FOR_LOOP 	= 3;
XianhunCell.CELL_FOR_BAG_LIST = 4;


function XianhunCell:update_scroll_cell( data )
	self.data = data;
	if self.data == nil then
		return;
	end

	--器魂形象
	if self.fabao_animate then
		self.fabao_animate:removeFromParentAndCleanup(true);
		self.fabao_animate = nil;
	end

	local texture_name ;
	if self.data.quality == 2 then
		texture_name = "frame/gem/00201";
	else
		local num = self.data.quality * 100 + self.data.type;
		texture_name = "frame/gem/"..string.format("%05d",num);
	end

	local action = {0,0,5,0.2};
    self.fabao_animate = MUtils:create_animation(45,34,texture_name,action );
    view:addChild(self.fabao_animate);

    -- 器魂的配置
    local xianhun_config = FabaoConfig:get_xianhun( self.data.quality, self.data.type, self.data.level );
    -- 器魂的颜色
    local xianhun_color = FabaoConfig:get_xianhun_color_by_quality( self.data.quality );
    local str_name = xianhun_color..xianhun_config.name;
    
    -- 名字
    if self.xianhun_name then
    	self.xianhun_name:setText( str_name );
    end
    -- 属性
   	local detail_str = Lang.lingqi.lianhun[8]..self.data.level.."  #c38ff33"..staticAttriTypeList[xianhun_config.attrs.type].." #cffffff+"..math.abs(xianhun_config.attrs.value); -- [978]="#c38ff33等级: #cffffff"
    self.xianhun_detail:setText(detail_str);

    --经验
    local exp_str = Lang.lingqi.lianhun[9]..self.data.value.."/"..xianhun_config.upExp; -- [979]="#c38ff33经验: #cffffff"
    self.xianhun_exp:setText(exp_str);
end

-- 为scrollview创建cell
function XianhunCell:init_for_scroll( view )
	
	local bg = MUtils:create_zximg(view, UILH_LINGQI.xianhun_bg,45-54/2,34-54/2,87,85)
	-- bg:setScale( 54/68 );

	-- 器魂形象
	if self.data then


		local texture_name ;
		if self.data.quality == 2 then
			texture_name = "frame/gem/00201";
		else
			local num = self.data.quality * 100 + self.data.type;
			texture_name = "frame/gem/"..string.format("%05d",num);
		end

		local action = {0,0,5,0.2};
	    self.fabao_animate = MUtils:create_animation(45,34,texture_name,action );
	    view:addChild(self.fabao_animate);
	end

	local str_name = "";
	local detail_str = "";
	local exp_str = "";
	if self.data then
		-- 器魂的配置
	    local xianhun_config = FabaoConfig:get_xianhun( self.data.quality, self.data.type, self.data.level );
	    -- 器魂的颜色
	    local xianhun_color = FabaoConfig:get_xianhun_color_by_quality( self.data.quality );
	    str_name = xianhun_color..xianhun_config.name;
	
		-- 器魂详细数据 
		-- print("器魂加成属性", staticAttriTypeList[xianhun_config.attrs.type], xianhun_config.attrs.value);
	    detail_str = LangGameString[978]..self.data.level.." #c38ff33"..staticAttriTypeList[xianhun_config.attrs.type].." #cffffff+"..math.abs(xianhun_config.attrs.value); -- [978]="#c38ff33等级: #cffffff"
		
		--器魂经验
		exp_str = LangGameString[979]..self.data.value.."/"..xianhun_config.upExp; -- [979]="#c38ff33经验: #cffffff"
	end

	-- 器魂名字
	self.xianhun_name = UILabel:create_lable_2( str_name, 45,6, 14, ALIGN_CENTER );
	view:addChild(self.xianhun_name);

	-- 器魂详细数据
	self.xianhun_detail = MUtils:create_ccdialogEx(view, detail_str, 130, 30, 230,20,2,13);

	-- 器魂经验
	self.xianhun_exp = UILabel:create_lable_2( exp_str, 130,11, 14, ALIGN_LEFT );
	view:addChild(self.xianhun_exp);

	local split_img = CCZXImage:imageWithFile(2,0,360,-1,UILH_COMMON.split_line);
    view:addChild(split_img);
end


-- 为器魂介绍页面的scroll创建cell
function XianhunCell:init_for_intro_scroll( view )
	
	-- for k,v in pairs(data) do
	-- 	print(k,v)
	-- end
	local bg = MUtils:create_zximg(view, UILH_LINGQI.xianhun_bg,45-54/2+28,19,87,85)
	-- bg:setScale( 54/68 );
	-- 弹出tip的回调方法
    local function xianhun_tip( eventType,arg,msgid,selfitem )
    	  if  eventType == TOUCH_BEGAN then
    	        return true;
          elseif eventType == TOUCH_CLICK then
        --   	    local 	xianhun_dict[i] = {id = xianhun_id, type = xianhun_type, quality = xianhun_quality,
							 -- level = xianhun_level, value = xianhun_value};
							 
			    -- if xianhun_list[i] then
			    --     TipsModel:show_fabao_xianhun( 0,0, xianhun_list[i], TipsModel.LAYOUT_LEFT );
			    -- end
        	return true;
          end
          return true;

	end

	bg:registerScriptHandler(xianhun_tip)
   
	-- 器魂形象
	local texture_name ;
	if self.data.name == Lang.lingqi.lianhun[10] then -- [980]="六道轮回魂"
		self.data.quality = 2;
		texture_name = "frame/gem/00201";
	else
		local num = self.data.quality * 100 + self.data.type;
		texture_name = "frame/gem/"..string.format("%05d",num);
	end

	local action = {0,0,5,0.15};
    self.fabao_animate = MUtils:create_animation( 87/2,85/2, texture_name, action );
    bg:addChild(self.fabao_animate);

	-- 器魂名字
	local color = FabaoConfig:get_xianhun_color_by_quality( self.data.quality );

	local xianhun_name = UILabel:create_lable_2( color..self.data.name, 138,81, 14, ALIGN_LEFT );
	view:addChild(xianhun_name);

	-- 器魂详细数据

	local desc_text, attri_text;
	if self.data.quality == 2 then
		desc_text = color..Lang.lingqi.lianhun[14]; -- [981]="LV.10"
		attri_text = color..Lang.lingqi.lianhun[11]; -- [982]="蕴含1600灵力值"
	else
        desc_text = color..Lang.lingqi.lianhun[14]; -- [983]="增加玩家"
        -- desc_text = color..staticAttriTypeList[self.data.attrs.type]; -- [983]="增加玩家"
		attri_text = color..staticAttriTypeList[self.data.attrs.type].." +"..math.abs(self.data.attrs.value); 
	end
	local xianhun_desc = UILabel:create_lable_2( desc_text, 141,56, 14, ALIGN_LEFT );
	view:addChild(xianhun_desc);
	-- 器魂加成的数据
	local xianhun_efft = UILabel:create_lable_2( attri_text, 141,33, 14, ALIGN_LEFT );
	view:addChild(xianhun_efft);	
	
	--分割线
	local split_img = CCZXImage:imageWithFile(-30,0,400,4,UILH_COMMON.split_line);
    view:addChild(split_img);
end


-- 清空loop cell
function XianhunCell:clear_loop_cell( )
	if self.xianhun_animate then
		self.xianhun_animate:removeFromParentAndCleanup(true);
		self.xianhun_animate = nil;
	end
	if self.xianhun_name then
    	self.xianhun_name:setText( "" );
    end
    if self.xianhun_lv then
    	self.xianhun_lv:setText( "" );
    end
    -- 置空slot
    self.slot:set_drag_info( 4, nil, nil );
    self.slot:set_icon_texture(nil);
    

    self.data = nil;

end

function XianhunCell:set_seal_visible( bool )
	self.seal_icon_visible = bool;
	self.seal_icon:setIsVisible(bool);
end

-- 更新loop cell
function XianhunCell:update_loop_cell( data )
	
	self.data = data;
	
	-- 设置slot item 
	self.slot:set_drag_info( 4, self.win, data );

	-- 器魂形象
	if self.xianhun_animate ~= nil then
		self.xianhun_animate:removeFromParentAndCleanup(true);
		self.xianhun_animate = nil;
	end
	local texture_name ;
	if data.quality == 2 then

		texture_name = "frame/gem/00201";
	else
		local num = data.quality * 100 + data.type;
		texture_name = "frame/gem/"..string.format("%05d",num);
	end
	local action = {0,0,5,0.2};
	self.xianhun_animate =  MUtils:create_animation(78/2,80/2, texture_name, action );
    self.view:addChild(self.xianhun_animate,0);

    -- 器魂的配置

    local xianhun_config = FabaoConfig:get_xianhun( data.quality, data.type, data.level );
    -- 器魂的颜色
    local xianhun_color = FabaoConfig:get_xianhun_color_by_quality( data.quality );
    local str_name = xianhun_color..xianhun_config.name;
    local str_level = xianhun_color.."lv"..data.level;

    if self.xianhun_name then
    	-- print("器魂名字", str_name);
    	self.xianhun_name:setText( str_name );
    end
    if self.xianhun_lv then
    	self.xianhun_lv:setText( str_level );
    end

end

-- 为loop创建cell
function XianhunCell:init_for_loop( view )
	
	-- slot item 
	local function tip_event(  )
		if self.click_event then
			self.click_event();
		end
	end
	local function double_click( )
		if self.double_click_event and self.data then
			self.double_click_event();
		end
	end
	local function drag_began_event(  )
		-- 开始拖拽事件
		if self.drag_began then
			self.drag_began();
		end
	end
	local function drag_in_callback(  )
		-- 拖入目标格子的回调
		if self.drag_callbcak then
			self.drag_callbcak();
		end
	end
	local function drag_in_event( slot )
		-- print("有格子拖入的事件", slot.obj_data.id, slot.win);
		-- 有格子拖入的事件
		if self.drag_in then
			self.drag_in( self, slot);
		end
	end
	local function drag_in_invalid( )
		
	end


	self.slot = MUtils:create_slot_item(view,UILH_LINGQI.xianhun_bg,0,0,87,85,nil,tip_event);
	self.slot:set_double_click_event( double_click );
	self.slot:set_drag_out_event(drag_began_event);
	self.slot:set_drag_in_callback(drag_in_callback);
	self.slot:set_drag_in_event(drag_in_event);
	self.slot:set_drag_invalid_callback(drag_in_invalid);
    self.slot.view:setScale(80/87)
		-- seal icon 封印的图标
	self.seal_icon = MUtils:create_zximg(view,UILH_LINGQI.feng,-2,-1,87,85);
	self.seal_icon:setScale(80/87)

	self.seal_icon:setIsVisible(false);
	self.seal_icon_visible = false;
	--点击可拓展
	self.seal_icon_buy = false
    self.word_icon = nil


	-- 器魂形象
	self.xianhun_animate = nil;
	if self.data then
		local texture_name ;
		if self.data.quality == 2 then
			texture_name = "frame/gem/00201";
		else
			local num = self.data.quality * 100 + self.data.type;
			texture_name = "frame/gem/"..string.format("%05d",num);
		end

		local action = {0,0,5,0.2};
		self.xianhun_animate =  MUtils:create_animation(78/2,80/2, texture_name, action );
	    view:addChild(self.xianhun_animate);
	end

	local xianhun_name = "";
	local xianhun_level = "";
	if self.data then
    	-- 器魂的配置
	    local xianhun_config = FabaoConfig:get_xianhun( self.data.quality, self.data.type, self.data.level );
	    -- 器魂的颜色
	    local xianhun_color = FabaoConfig:get_xianhun_color_by_quality( self.data.quality );
	    xianhun_name = xianhun_color..xianhun_config.name;
	    xianhun_level = xianhun_color.."lv"..self.data.level;
	end

    --器魂名字
    self.xianhun_name = UILabel:create_lable_2( xianhun_name, 87/2, 0, 12, ALIGN_CENTER );
	view:addChild(self.xianhun_name,99);

	-- 等级
	self.xianhun_lv = UILabel:create_lable_2( xianhun_level, 87/2, 13, 12, ALIGN_CENTER );
	view:addChild( self.xianhun_lv ,100);

end

function XianhunCell:__init( type, x, y, w, h, data)
	
	self.view = CCBasePanel:panelWithFile(x,y,w,h,"");
	self.data = data;

	if type == XianhunCell.CELL_FOR_SCROLL then
		self:init_for_scroll( self.view );

	elseif type == XianhunCell.CELL_FOR_INTRO_SCROLL then
		
		self:init_for_intro_scroll( self.view );

	elseif type == XianhunCell.CELL_FOR_LOOP then
		self:init_for_loop( self.view );
	end

end

-------------------------属性函数
-- 设置单击函数
function XianhunCell:set_click_event( fn )
	self.click_event = fn;
end
-- 设置双击函数
function XianhunCell:set_double_click_event( fn )
	self.double_click_event = fn;
end
--设置开始拖拽事件
function XianhunCell:set_drag_began_event( fn )
	self.drag_began = fn;
end
-- 设置拖拽入目标格子后的回调
function XianhunCell:set_drag_in_callback( fn )
	self.drag_callbcak = fn;
end
-- 设置有格子拖进来的事件
function XianhunCell:set_drag_in( fn )
	self.drag_in = fn;
end
-- 设置改cell从属那个界面 0=法宝界面，1=炼魂界面create_for_intro_scroll
function XianhunCell:set_win_name( win_name )
	self.win = win_name;
end


------------------------静态函数
function XianhunCell:create_for_scroll( x, y, w, h, data)
	return XianhunCell( XianhunCell.CELL_FOR_SCROLL, x, y, w, h, data )
end

function XianhunCell:create_for_intro_scroll( x, y, w, h, data )
	-- for k,v in pairs(data) do
	-- 	print(k,v)
	-- end
	return XianhunCell( XianhunCell.CELL_FOR_INTRO_SCROLL, x, y, w, h, data )
end

function XianhunCell:create_for_loop( x, y, w, h, data, use_func)
	return XianhunCell( XianhunCell.CELL_FOR_LOOP, x, y, w, h, data );
end


