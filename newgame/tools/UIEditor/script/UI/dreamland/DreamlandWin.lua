-- Dreamland.lua 
-- createed by fangjiehua on 2012-12-24
-- 梦境系统窗口

 
super_class.DreamlandWin(NormalStyleWindow)

local _window_name="dreamland_win"
local _dream_base_size = CCSize(435, 605) --底板尺寸
--local _dream_bg_size = CCSize(391, 371) --二层底板尺寸

local _slot_num_size = CCSize(5, 5) --物品格矩阵


local _dream_tab_size = CCSize(101, 45) -- tab尺寸
local _dream_tab_padding = {left=17, top=40} --tab相对底板的间距

local _dream_slot_bg_region_padding = nil

local _dream_slot_bg_region_size = nil --物品格背景区域尺寸 不包括tab
local _dream_slot_bg_region_rect = nil


local _dream_tab_rect = nil

local _dream_slot_bg_regionimg_padding = {left=10,top=10,right=10,bottom=10}
local _dream_slot_bg_regionimg_rect = nil
	

local _dream_slot_region_padding = {left=12, top=18, right=12, bottom=18} --物品格区域相对二层底板的间距
local _dream_slot_region_size=nil

local _dream_slot_small_size = CCSize(58, 58) --梦境小物品格尺寸
local _dream_slot_big_size = CCSize(79, 79) --梦境大物品格尺寸


local _dream_tab_xy = nil;	--星蕴tab
local _dream_tab_xy_lab = nil; -- 文字


local dream_tab_yh = nil;	--月华tab
local dream_tab_yh_lab = nil; -- 文字

local dream_tab_ry = nil;	--日曜tab
local dream_tab_ry_lab = nil; -- 文字

local tanbao_btn_1 = nil;	--探宝按钮1
local tanbao_btn_2 = nil;	--探宝按钮2
local tanbao_btn_3 = nil;	--探宝按钮3

local tanbao_money_lab_1 = nil	--探宝需要花费的元宝lab
local tanbao_money_lab_2 = nil	--探宝需要花费的元宝lab
local tanbao_money_lab_3 = nil	--探宝需要花费的元宝lab

local yuanbao_count = nil;  --元宝余额
local bindyuanbao_count = nil -- 绑元余额
local jiejin_count 	= nil;	--星蕴结晶
local jiejin_lab	= nil;	--结晶label
local _tip_lab 		= nil;	--优先使用xx
local _tip_lab_pos = CCPoint(120, 78)
local _tip_lab_size = CCSize(180,30)

local _cangku_btn = nil --仓库按钮
local _cangku_btn_size = CCSize(118, 48) --仓库按钮的尺寸
local _cangku_btn_lab = nil;	--仓库按钮lab
local _cangku_btn_padding = {top=15,right=20, bottom=24} --仓库按钮相对底板的间距
local _cangku_btn_fontsize = 16

local item_big_icon_1 = nil;	--大icon
local item_big_icon_2 = nil;	--icon
local icon_v_table 	= {};	--纵向的item icon
local icon_h_table 	= {};	--横向的item icon
--星蕴梦境的item id 配置
local xy_icon_v_dic = {};
local xy_icon_h_dic = {};

local yh_icon_v_dic = {};
local yh_icon_h_dic = {};

local tb_icon_v_dic = {};
local tb_icon_h_dic = {};

local ry_icon_v_dic = {} --日曜梦境
local ry_icon_h_dic = {}

local _font_size = 16
local _icon_offset = 0

local tanbao_btn_size = CCSize(82, 82)
local _tanbao_btn_height = 178

local yuanbao_panel_size = CCSize(220, _font_size) --元宝区域尺寸
local yuanbao_panel_padding = {left=33, top=14} --元宝区域相对底板的间距
local yuanbao_textbg_size = CCSize(110, 26) --元宝数量背景尺寸
local yuanbao_textbg_padding = {left=10, bottom=(yuanbao_panel_size.height-yuanbao_textbg_size.height)/2}	--相对panel的间距
local yuanbao_lab_pos = CCPointMake(0, (yuanbao_panel_size.height-_font_size)/2) --label的位置
local yuanbao_count_pos = CCPointMake(5, (yuanbao_textbg_size.height-_font_size)/2) --元宝数字的位置

-- local tanbaobtn_pos={
-- 	num1_pos={
-- 		pos = CCSize()
-- 	}
-- }

-- 选中了淘宝树
local function dreamland_tab_tb_event( eventType )
	if eventType == TOUCH_CLICK then
	
		DreamlandModel:set_dreamland_type(DreamlandModel.DREAMLAND_TYPE_TBS);
		DreamlandWin:change_dreamlandType(DreamlandModel:get_dreamland_type());
		jiejin_lab:setText("#cffff00淘宝金币:");
		_tip_lab:setText("#cffff00优先使用淘宝金币")
		local crystal_id = DreamlandModel:get_current_crystal();
		local jiejin_str = string.format("#cfff000%d",ItemModel:get_item_count_by_id(crystal_id));
		jiejin_count:setText(jiejin_str);

		tanbao_money_lab_1:setText(LangGameString[886]); -- [886]="#c38ff3310元宝"
		tanbao_money_lab_2:setText(LangGameString[887]); -- [887]="#c38ff3390元宝"
		tanbao_money_lab_3:setText(LangGameString[888]); -- [888]="#c38ff33450元宝"

		item_big_icon_1:set_icon_texture(ItemConfig:get_item_icon(24452));
		--item_big_icon_1:set_color_frame(24452, -2, -2, 68, 68)
		item_big_icon_1:set_color_frame(24452, -_icon_offset, -_icon_offset, 
				_dream_slot_big_size.width+_icon_offset*2, _dream_slot_big_size.height+_icon_offset*2)

		item_big_icon_2:set_icon_texture(ItemConfig:get_item_icon(18615));
		--item_big_icon_2:set_color_frame(44719, -2, -2, 68, 68)
		item_big_icon_2:set_color_frame(18615, -_icon_offset, -_icon_offset, 
				_dream_slot_big_size.width+_icon_offset*2, _dream_slot_big_size.height+_icon_offset*2)

		--重新设置纵向icon
		for i,v in ipairs(icon_v_table) do
			local item_id = tb_icon_v_dic[i];   --xy_icon_v_dic[i];
			v:set_icon_texture(ItemConfig:get_item_icon(item_id));
			--v:set_color_frame(item_id, -2, -2, 68, 68);
			v:set_color_frame(item_id, -_icon_offset, -_icon_offset, 
				_dream_slot_small_size.width+_icon_offset*2, _dream_slot_small_size.height+_icon_offset*2)
		end
		--重新设置横向icon
		for i,v in ipairs(icon_h_table) do
			local item_id =  tb_icon_h_dic[i]; --xy_icon_h_dic[i];
			v:set_icon_texture(ItemConfig:get_item_icon(item_id));
			--v:set_color_frame(item_id, -2, -2, 68, 68);
			v:set_color_frame(item_id, -_icon_offset, -_icon_offset, 
				_dream_slot_small_size.width+_icon_offset*2, _dream_slot_small_size.height+_icon_offset*2)
		end

		-- 
		DreamlandCC:req_taobao_tree_zhenpin(  )
	end
	return true;
end


-- 选中了星蕴tab分页的事件
local function dream_tab_xy_event( eventType,x,y )
	if eventType == TOUCH_BEGAN then
		return true
	elseif eventType == TOUCH_CLICK then
		DreamlandModel:set_dreamland_type(DreamlandModel.DREAMLAND_TYPE_XY);
		DreamlandWin:change_dreamlandType(DreamlandModel:get_dreamland_type());

		jiejin_lab:setText(Lang.dreamland.label_xyjiejing_text); -- [889]="#c38ff33星蕴结晶:"
		_tip_lab:setText(Lang.dreamland.label_youxianxyjiejin) -- [890]="#c38ff33优先使用星蕴结晶"
		local crystal_id = DreamlandModel:get_current_crystal();
		local jiejin_str = string.format("%d",ItemModel:get_item_count_by_id(crystal_id));
		jiejin_count:setText(jiejin_str);

		tanbao_money_lab_1:setText(Lang.dreamland.label_yuanbao_take[1]); -- [886]="#c38ff3310元宝"
		tanbao_money_lab_2:setText(Lang.dreamland.label_yuanbao_take[2]); -- [887]="#c38ff3390元宝"
		tanbao_money_lab_3:setText(Lang.dreamland.label_yuanbao_take[3]); -- [888]="#c38ff33450元宝"

		item_big_icon_1:set_icon_texture(ItemConfig:get_item_icon(38202));
		--item_big_icon_1:set_color_frame(38202, -2, -2, 68, 68)
		item_big_icon_1:set_color_frame(38202, -_icon_offset, -_icon_offset, 
				_dream_slot_big_size.width+_icon_offset*2, _dream_slot_big_size.height+_icon_offset*2)

		item_big_icon_2:set_icon_texture(ItemConfig:get_item_icon(18615));
		--item_big_icon_2:set_color_frame(44719, -2, -2, 68, 68)
		item_big_icon_2:set_color_frame(18615, -_icon_offset, -_icon_offset, 
				_dream_slot_big_size.width+_icon_offset*2, _dream_slot_big_size.height+_icon_offset*2)

		--重新设置纵向icon
		for i,v in ipairs(icon_v_table) do
			local item_id = xy_icon_v_dic[i];
			v:set_icon_texture(ItemConfig:get_item_icon(item_id));
			--v:set_color_frame(item_id, -2, -2, 68, 68);
			v:set_color_frame(item_id, -_icon_offset, -_icon_offset, 
				_dream_slot_small_size.width+_icon_offset*2, _dream_slot_small_size.height+_icon_offset*2)

		end
		--重新设置横向icon
		for i,v in ipairs(icon_h_table) do
			local item_id = xy_icon_h_dic[i];
			v:set_icon_texture(ItemConfig:get_item_icon(item_id));
			--v:set_color_frame(item_id, -2, -2, 68, 68);
			v:set_color_frame(item_id, -_icon_offset, -_icon_offset, 
				_dream_slot_small_size.width+_icon_offset*2, _dream_slot_small_size.height+_icon_offset*2)
		end

		return true
	end
	return true
end

--  选中了月华tab分页
local function dream_tab_yh_event( eventType,x,y )
	if eventType == TOUCH_BEGAN then
		return true
	elseif eventType == TOUCH_CLICK then
		DreamlandModel:set_dreamland_type(DreamlandModel.DREAMLAND_TYPE_YH);
		DreamlandWin:change_dreamlandType(DreamlandModel:get_dreamland_type());

		jiejin_lab:setText(Lang.dreamland.label_yhjiejing_text); -- [891]="#c38ff33月华结晶:"
		_tip_lab:setText(Lang.dreamland.label_youxianyhjiejin) -- [892]="#c38ff33优先使用月华结晶"
		local crystal_id = DreamlandModel:get_current_crystal();
		local jiejin_str = string.format("%d",ItemModel:get_item_count_by_id(crystal_id));
		jiejin_count:setText(jiejin_str);

		tanbao_money_lab_1:setText(Lang.dreamland.label_yuanbao_take[4]); -- [893]="#c38ff3320元宝"
		tanbao_money_lab_2:setText(Lang.dreamland.label_yuanbao_take[5]); -- [894]="#c38ff33180元宝"
		tanbao_money_lab_3:setText(Lang.dreamland.label_yuanbao_take[6]); -- [895]="#c38ff33900元宝"

		item_big_icon_1:set_icon_texture(ItemConfig:get_item_icon(18636));
		--item_big_icon_1:set_color_frame(18636, -2, -2, 68, 68)
		item_big_icon_1:set_color_frame(18636, -_icon_offset, -_icon_offset, 
				_dream_slot_big_size.width+_icon_offset*2, _dream_slot_big_size.height+_icon_offset*2)
		item_big_icon_2:set_icon_texture(ItemConfig:get_item_icon(18614));
		--item_big_icon_2:set_color_frame(18614, -2, -2, 68, 68)
		item_big_icon_2:set_color_frame(18614, -_icon_offset, -_icon_offset, 
				_dream_slot_big_size.width+_icon_offset*2, _dream_slot_big_size.height+_icon_offset*2)

		--重新设置纵向icon
		for i,v in ipairs(icon_v_table) do
			local item_id = yh_icon_v_dic[i];
			v:set_icon_texture(ItemConfig:get_item_icon(item_id));
			--v:set_color_frame(item_id, -2, -2, 68, 68);
			v:set_color_frame(item_id, -_icon_offset, -_icon_offset, 
				_dream_slot_small_size.width+_icon_offset*2, _dream_slot_small_size.height+_icon_offset*2)
		end
		--重新设置横向icon
		for i,v in ipairs(icon_h_table) do
			local item_id = yh_icon_h_dic[i];
			v:set_icon_texture(ItemConfig:get_item_icon(item_id));
			--v:set_color_frame(item_id, -2, -2, 68, 68);
			v:set_color_frame(item_id, -_icon_offset, -_icon_offset, 
				_dream_slot_small_size.width+_icon_offset*2, _dream_slot_small_size.height+_icon_offset*2)
		end

		return true
	end
	return true
end

--  选中了日曜tab分页
local function dream_tab_ry_event( eventType,x,y )
	if eventType == TOUCH_BEGAN then
		return true
	elseif eventType == TOUCH_CLICK then
		DreamlandModel:set_dreamland_type(DreamlandModel.DREAMLAND_TYPE_RY);
		DreamlandWin:change_dreamlandType(DreamlandModel:get_dreamland_type());

		jiejin_lab:setText(Lang.dreamland.label_ryjiejing_text); -- [891]="#c38ff33日曜结晶:"
		_tip_lab:setText(Lang.dreamland.label_youxianryjiejin) -- [892]="#c38ff33优先使用日曜结晶"
		local crystal_id = DreamlandModel:get_current_crystal();
		local jiejin_str = string.format("%d",ItemModel:get_item_count_by_id(crystal_id));
		jiejin_count:setText(jiejin_str);

		tanbao_money_lab_1:setText(Lang.dreamland.label_yuanbao_take[4]); -- [893]="#c38ff3320元宝"
		tanbao_money_lab_2:setText(Lang.dreamland.label_yuanbao_take[5]); -- [894]="#c38ff33180元宝"
		tanbao_money_lab_3:setText(Lang.dreamland.label_yuanbao_take[6]); -- [895]="#c38ff33900元宝"

		item_big_icon_1:set_icon_texture(ItemConfig:get_item_icon(18636));
		--item_big_icon_1:set_color_frame(18636, -2, -2, 68, 68)
		item_big_icon_1:set_color_frame(18636, -_icon_offset, -_icon_offset, 
				_dream_slot_big_size.width+_icon_offset*2, _dream_slot_big_size.height+_icon_offset*2)
		item_big_icon_2:set_icon_texture(ItemConfig:get_item_icon(18614));
		--item_big_icon_2:set_color_frame(18614, -2, -2, 68, 68)
		item_big_icon_2:set_color_frame(18614, -_icon_offset, -_icon_offset, 
				_dream_slot_big_size.width+_icon_offset*2, _dream_slot_big_size.height+_icon_offset*2)

		--重新设置纵向icon
		for i,v in ipairs(icon_v_table) do
			local item_id = yh_icon_v_dic[i];
			v:set_icon_texture(ItemConfig:get_item_icon(item_id));
			--v:set_color_frame(item_id, -2, -2, 68, 68);
			v:set_color_frame(item_id, -_icon_offset, -_icon_offset, 
				_dream_slot_small_size.width+_icon_offset*2, _dream_slot_small_size.height+_icon_offset*2)
		end
		--重新设置横向icon
		for i,v in ipairs(icon_h_table) do
			local item_id = yh_icon_h_dic[i];
			v:set_icon_texture(ItemConfig:get_item_icon(item_id));
			--v:set_color_frame(item_id, -2, -2, 68, 68);
			v:set_color_frame(item_id, -_icon_offset, -_icon_offset, 
				_dream_slot_small_size.width+_icon_offset*2, _dream_slot_small_size.height+_icon_offset*2)
		end

		return true
	end
	return true
end

function DreamlandWin:choose_xymj_tab( )
	dream_tab_xy_event(TOUCH_CLICK,0,0);
end
function DreamlandWin:choose_yhmj_tab( )
	dream_tab_yh_event(TOUCH_CLICK,0,0);
end
function DreamlandWin:choose_tbmj_tba(  )
	dreamland_tab_tb_event(TOUCH_CLICK);
end
function DreamlandWin:choose_rymj_tab( )
	dream_tab_ry_event(TOUCH_CLICK,0,0);
end

--关闭按钮事件
local function dreamland_close_fun(eventType,x,y)
	
	if eventType == TOUCH_BEGAN then
		return true
	elseif eventType == TOUCH_CLICK then
	 
		UIManager:hide_window("dreamland_win");
		
		return true
	end
	return true
end

--探宝1次
local function tanbao_1_event( eventType, arg, msgid, selfItem )
	
	if eventType == TOUCH_CLICK then
		Instruction:handleUIComponentClick(instruct_comps.DREAMLAND_TANBO1)
		Analyze:parse_click_main_menu_info(256)
		DreamlandModel:req_tao_bao(1);
		--DreamlandWin:tanbao_callback()
		-- 新手指引代码
		-- if ( XSZYManager:get_state() == XSZYConfig.MENG_JING_ZY ) then
		-- 	-- 指向关闭按钮
		-- 	XSZYManager:destroy_jt( XSZYConfig.OTHER_SELECT_TAG );
		-- 	-- 
		-- 	XSZYManager:play_jt_and_kuang_animation_by_id( XSZYConfig.MENG_JING_ZY ,2 ,XSZYConfig.OTHER_SELECT_TAG );
		-- end
	end
	return true
end

--探宝10次
local function tanbao_10_event( eventType )

	if eventType == TOUCH_CLICK then
		Instruction:handleUIComponentClick(instruct_comps.DREAMLAND_TANBO1)
		-- Instruction:handleUIComponentClick(instruct_comps.DREAMLAND_TANBO10)
		DreamlandModel:req_tao_bao(10);
		--DreamlandWin:tanbao_callback()
	end
	return true
end
--探宝50次
local function tanbao_50_event( eventType, arg, msgid, selfItem )
	if eventType == TOUCH_CLICK then
		-- Instruction:handleUIComponentClick(instruct_comps.DREAMLAND_TANBO50)
		DreamlandModel:req_tao_bao(50);
		--DreamlandWin:tanbao_callback()
	end
	return true
end
--探宝回调
function DreamlandWin:tanbao_callback( item_table )
	--更新界面数据
	--print("###tanbao_callback###")
	DreamlandWin:update();

end
--打开仓库
local function open_cangku( eventType,x,y )
	-- body
	--if eventType == TOUCH_CLICK then
		Instruction:handleUIComponentClick(instruct_comps.DREAMLAND_OPENWAREHOUSE)
		if UIManager:find_visible_window("dreamland_info_win") then
			--_cangku_btn_lab:setTexture(UIPIC_DREAMLAND_015);
			_cangku_btn:setText(Lang.dreamland.btn_dreaminfo_text)
			UIManager:hide_window("dreamland_info_win");
			UIManager:show_window("dreamland_cangku_win");
		elseif UIManager:find_visible_window("dreamland_cangku_win") then
			--_cangku_btn_lab:setTexture(UIPIC_DREAMLAND_019);
			_cangku_btn:setText(Lang.dreamland.btn_dreamcangku_text)
			UIManager:show_window("dreamland_info_win");
			UIManager:hide_window("dreamland_cangku_win");
		else
			--_cangku_btn_lab:setTexture(UIPIC_DREAMLAND_015);
			_cangku_btn:setText(Lang.dreamland.btn_dreaminfo_text)
			UIManager:hide_window("dreamland_info_win");
			UIManager:show_window("dreamland_cangku_win");
		end
		
	--end
	return true
end



function DreamlandWin:change_dreamlandType(type )
	
	if type == DreamlandModel.DREAMLAND_TYPE_XY then
		-- 星蕴梦境
		--_dream_tab_xy_lab:setTexture( UIPIC_DREAMLAND_005 );
		--dream_tab_yh_lab:setTexture( UIPIC_DREAMLAND_030 );
		_dream_tab_xy:setCurState(CLICK_STATE_DISABLE);
		dream_tab_yh:setCurState(CLICK_STATE_UP);
		dream_tab_ry:setCurState(CLICK_STATE_UP)

	elseif type == DreamlandModel.DREAMLAND_TYPE_YH then
		-- 月华梦境
		--dream_tab_yh_lab:setTexture( UIPIC_DREAMLAND_009 );
		--_dream_tab_xy_lab:setTexture( UIPIC_DREAMLAND_029 );
		_dream_tab_xy:setCurState(CLICK_STATE_UP);
		dream_tab_yh:setCurState(CLICK_STATE_DISABLE);		
		dream_tab_ry:setCurState(CLICK_STATE_UP)

	-- elseif type == DreamlandModel.DREAMLAND_TYPE_TBS then
	-- 	-- 淘宝树
	-- 	--_dream_tab_xy_lab:setTexture( UIPIC_DREAMLAND_016 );
	-- 	_dream_tab_xy:setCurState(CLICK_STATE_UP);
	-- 	--dream_tab_yh:setIsVisible(false);
	-- 	_dream_tab_yh:setCurState(CLICK_STATE_UP);
	elseif type == DreamlandModel.DREAMLAND_TYPE_RY then
		-- 月华梦境
		--dream_tab_yh_lab:setTexture( UIPIC_DREAMLAND_009 );
		--_dream_tab_xy_lab:setTexture( UIPIC_DREAMLAND_029 );
		_dream_tab_xy:setCurState(CLICK_STATE_UP);
		dream_tab_yh:setCurState(CLICK_STATE_UP);		
		dream_tab_ry:setCurState(CLICK_STATE_DISABLE)
	end
	 
	-- UIManager:show_window("dreamland_info_win");

end

function DreamlandWin:update_bindYuanbao( )
	-- 设置绑元数量
	if bindyuanbao_count~=nil then
		local avatar = EntityManager:get_player_avatar();
		local bindyuanbao_str = string.format("#cfff000%d", avatar.bindYuanbao)
		bindyuanbao_count:setText(bindyuanbao_str)
	end
end

function DreamlandWin:update_yuanbao(  )
	--设置元宝数量
	if yuanbao_count then
		local avatar = EntityManager:get_player_avatar();
		local yuanbao_str = string.format("%d", avatar.yuanbao);
		yuanbao_count:setText(yuanbao_str);	
		--print("##############update_yuanbao##################")
		--print("avatar.yuanbao:#" .. avatar.yuanbao .. "#")
		--update_timer:stop();
	end
end

function DreamlandWin:update(  )
 
 	--local update_timer = timer();
 	
	
	--update_timer:start(1, update_yuanbao);

	--self:update_bindYuanbao()
	self:update_yuanbao()
	--设置星蕴18606/18607月华结晶数量
   
	local dream_type = DreamlandModel:get_dreamland_type();
	local crystal_id = DreamlandModel:get_current_crystal();
	local jiejin_str = string.format("%d",ItemModel:get_item_count_by_id( crystal_id ));
	jiejin_count:setText(jiejin_str);
 
	local vip = VIPModel:get_vip_info();

	self:showTanbaoBtn_by_vip_level(vip.level);

	-- 判断是否达到了50级开启月华梦境
	local avatar = EntityManager:get_player_avatar();
	local type = DreamlandModel:get_dreamland_type( );
	--print("avatar.yuanbao:#" .. avatar.yuanbao .. "#")
	--print("avatar.yuanbao:#" .. avatar.yuanbao .. "#")
	--if DreamlandModel.DREAMLAND_TYPE_TBS ~= type then
		if avatar.level < 50 then
			dream_tab_yh:setIsVisible(false)
			--dream_tab_ry:setIsVisible(false)
		elseif avatar.level >= 50 and avatar.level<60 then
			dream_tab_yh:setIsVisible(true)
			--dream_tab_ry:setIsVisible(false)
		elseif avatar.level >= 60 then
			dream_tab_yh:setIsVisible(true)
			--dream_tab_ry:setIsVisible(true)
		end
	--else
	--	dream_tab_yh:setIsVisible(false);
	--end

end

function DreamlandWin:active( show )

	if show == true then
		 
		--选中星蕴梦境
		self:change_dreamlandType(DreamlandModel:get_dreamland_type());
 		
 		--更新界面的动态数据
		self:update();

		-- if DreamlandModel:get_dreamland_type() == DreamlandModel.DREAMLAND_TYPE_TBS then
		UIManager:show_window("dreamland_info_win");
 
		--拉去仓库的数据
		DreamlandCC:request_cangku_list();
		--_cangku_btn_lab:setTexture(UIPIC_DREAMLAND_019);
		_cangku_btn:setText(Lang.dreamland.btn_dreamcangku_text)
	else 
		
		dream_tab_xy_event( TOUCH_CLICK )
		
		UIManager:hide_window("dreamland_info_win");
		UIManager:hide_window("dreamland_cangku_win");
	end

	-- 新手指引代码
	--[[if ( XSZYManager:get_state() == XSZYConfig.MENG_JING_ZY ) then
		if ( show ) then 
			-- XSZYManager:unlock_screen();
			local vip_info = VIPModel:get_vip_info();
		    local vip_level = 0 ;
		    if ( vip_info ) then
		        vip_level = vip_info.level;
		    end
		    --print("vip_level = ",vip_level);
		    local btn_x = 177;
		    if ( vip_level >= 4 ) then
		    	btn_x = 102
		    end
			-- 指向探宝 103,151,80,73
			XSZYManager:play_jt_and_kuang_animation_by_id( XSZYConfig.MENG_JING_ZY ,1, XSZYConfig.OTHER_SELECT_TAG ,btn_x,151);
		else
			AIManager:do_quest(TaskModel:get_zhuxian_quest());
			XSZYManager:destroy( XSZYConfig.OTHER_SELECT_TAG );
			-- 隐藏菜单栏
            local win = UIManager:find_window("menus_panel");
            win:show_or_hide_panel(false);
		end
	end--]]

end
--根据vip等级显示探宝按钮
function DreamlandWin:showTanbaoBtn_by_vip_level( vip_level )

	if vip_level <= 3 then 
		tanbao_btn_1:setPosition(200,_tanbao_btn_height);
		_tip_lab:setPosition(_tip_lab_pos);
		tanbao_btn_2:setIsVisible(false);
		tanbao_btn_3:setIsVisible(false);
	elseif vip_level >= 4 and vip_level <6 then
		tanbao_btn_1:setPosition(145,_tanbao_btn_height);
		_tip_lab:setPosition(_tip_lab_pos);
		tanbao_btn_2:setIsVisible(true);
		tanbao_btn_2:setPosition(255,_tanbao_btn_height);
		tanbao_btn_3:setIsVisible(false);
	elseif vip_level >=6 then
		tanbao_btn_1:setPosition(124,_tanbao_btn_height);
		_tip_lab:setPosition(_tip_lab_pos);
		tanbao_btn_2:setIsVisible(true);
		tanbao_btn_3:setIsVisible(true);
		tanbao_btn_2:setPosition(203,_tanbao_btn_height);
		tanbao_btn_3:setPosition(282,_tanbao_btn_height);		
	end

end


local function get_item_by_tag( tag )
	local item_tag = tag;
    local item_data = nil;
    local Type = DreamlandModel:get_dreamland_type()
    if DreamlandModel:get_dreamland_type() == DreamlandModel.DREAMLAND_TYPE_XY  then --梦境类型，1为星蕴，2为月华
    	if item_tag <= 10 then
    		--当tag小于10 则为星蕴纵向的icon
    		item_data = ItemConfig:get_item_by_id(xy_icon_v_dic[item_tag]);
    	elseif item_tag > 10 and item_tag < 100 then
    		--当tag大于于10 则为星蕴横向的icon，这里要减去冗余的10
    		item_data = ItemConfig:get_item_by_id(xy_icon_h_dic[item_tag-10]);	
    	elseif item_tag == 100 then
    		item_data = ItemConfig:get_item_by_id( (DreamlandConfig:get_xy_big_items())[1] );
    	elseif item_tag == 101 then
    		item_data = ItemConfig:get_item_by_id( (DreamlandConfig:get_xy_big_items())[2] );
    	end
    elseif DreamlandModel:get_dreamland_type() == DreamlandModel.DREAMLAND_TYPE_YH then
    	if item_tag <= 10 then
    	--当tag小于10 则为月华纵向的icon
    		item_data = ItemConfig:get_item_by_id(yh_icon_v_dic[item_tag]);
    	elseif item_tag > 10 and item_tag < 100 then
    		--当tag大于于10 则为月华横向的icon，这里要减去冗余的10
    		item_data = ItemConfig:get_item_by_id(yh_icon_h_dic[item_tag-10]);
    	elseif item_tag == 100 then 
    		item_data = ItemConfig:get_item_by_id( (DreamlandConfig:get_yh_big_items())[1] );
    	elseif item_tag == 101 then 
    		item_data = ItemConfig:get_item_by_id( (DreamlandConfig:get_yh_big_items())[2] );
    	end
    -- elseif DreamlandModel:get_dreamland_type() == DreamlandModel.DREAMLAND_TYPE_TBS then
    -- 	if item_tag <= 10 then
    -- 	--当tag小于10 则为月华纵向的icon
    -- 		item_data = ItemConfig:get_item_by_id(tb_icon_v_dic[item_tag]);
    -- 	elseif item_tag > 10 and item_tag < 100 then
    -- 		--当tag大于于10 则为月华横向的icon，这里要减去冗余的10
    -- 		item_data = ItemConfig:get_item_by_id(tb_icon_h_dic[item_tag-10]);
    -- 	elseif item_tag == 100 then 
    -- 		item_data = ItemConfig:get_item_by_id( (DreamlandConfig:get_taobao_tree_big_items())[1] );
    -- 	elseif item_tag == 101 then 
    -- 		item_data = ItemConfig:get_item_by_id( (DreamlandConfig:get_taobao_tree_big_items())[2] );
    -- 	end

    elseif DreamlandModel:get_dreamland_type() == DreamlandModel.DREAMLAND_TYPE_RY then
    	if item_tag <= 10 then
    	--当tag小于10 则为日曜纵向的icon
    		item_data = ItemConfig:get_item_by_id(ry_icon_v_dic[item_tag]);
    	elseif item_tag > 10 and item_tag < 100 then
    		--当tag大于于10 则为日曜横向的icon，这里要减去冗余的10
    		item_data = ItemConfig:get_item_by_id(ry_icon_h_dic[item_tag-10]);
    	elseif item_tag == 100 then 
    		item_data = ItemConfig:get_item_by_id( (DreamlandConfig:get_ry_big_items())[1] );
    	elseif item_tag == 101 then 
    		item_data = ItemConfig:get_item_by_id( (DreamlandConfig:get_ry_big_items())[2] );
    	end

    end
    return item_data;
end

--创建物品项
local function create_item_obj(tag,x, y, width, height, icon, bg)
	local slot_width = width
	local slot_height = height
    local item_obj = SlotBag(slot_width, slot_height);
    item_obj:setPosition (x, y);
    --item_obj:setAnchor(0.5,0.5);
    item_obj:set_icon_texture(icon);
    -- item_obj:set_icon_size(48*width/slot_width, 48*height/slot_height);
    item_obj:set_tag(tag);
    
    item_obj:set_icon_bg_texture(UIPIC_DREAMLAND.slot_item, -_icon_offset, -_icon_offset, slot_width+_icon_offset*2, slot_height+_icon_offset*2)

    --道具单击事件回调
    local function item_clicked()
    	local item_data = get_item_by_tag( item_obj:get_tag() );
      	TipsModel:show_shop_tip( 400,240,item_data.id ,TipsModel.LAYOUT_RIGHT);
    end
    local item_data = get_item_by_tag( item_obj:get_tag() );
    if item_data.id == 18614 or item_data.id == 18636 or item_data.id == 18615 or item_data.id == 38202 or
    	item_data.id == 38206 or item_data.id == 48265 then
    else  
   	 	item_obj:set_color_frame( item_data.id );
   	end
    item_obj:set_click_event(item_clicked);

    return item_obj;
end

--- 从配置里拿取梦境物品列表
function DreamlandWin:update_display_items( )

	local xy_items = (DreamlandConfig:get_dreamland_items())[1];
	local yh_items = (DreamlandConfig:get_dreamland_items())[2];
	local tb_items = DreamlandConfig:get_taobao_tree_items();

	-- -- 梦境显示的物品
	xy_icon_v_dic = {xy_items[1],xy_items[2],xy_items[3],xy_items[4],xy_items[5],
					xy_items[6],xy_items[7],xy_items[8],xy_items[9],xy_items[10]};
	xy_icon_h_dic = {xy_items[11],xy_items[12],xy_items[13],xy_items[14],xy_items[15],
					xy_items[16],};
	yh_icon_v_dic = {yh_items[1],yh_items[2],yh_items[3],yh_items[4],yh_items[5],
					yh_items[6],yh_items[7],yh_items[8],yh_items[9],yh_items[10]};
	yh_icon_h_dic = {yh_items[11],yh_items[12],yh_items[13],yh_items[14],yh_items[15],
					yh_items[16],};

	ry_icon_v_dic = {tb_items[1],tb_items[2],tb_items[3],tb_items[4],tb_items[5],
					tb_items[6],tb_items[7],tb_items[8],tb_items[9],tb_items[10]};
	ry_icon_h_dic = {tb_items[11],tb_items[12],tb_items[13],tb_items[14],tb_items[15],
					tb_items[16]};

end


--xiehande  点击按钮切换字体贴图
function DreamlandWin:change_btn_name( index )
	-- body
	for i,v in ipairs(self.radio_button.item_group) do
		if(i==index) then
          self.radio_button:getIndexItem(i-1):set_image_texture(self._radio_item_info.image[i][1])
		else
          self.radio_button:getIndexItem(i-1):set_image_texture(self._radio_item_info.image[i][2])
		end
	end
end



function DreamlandWin:initPanel(self_panel)
	
	self:update_display_items( );

	--星蕴tab 按钮 96 42 ->110,45
	_dream_tab_xy = CCNGBtnMulTex:buttonWithFile(_dream_tab_rect.origin.x, _dream_tab_rect.origin.y,
	 _dream_tab_size.width, _dream_tab_size.height, UIPIC_DREAMLAND.tab_gray)	
	self_panel:addChild(_dream_tab_xy);
	_dream_tab_xy:addTexWithFile(CLICK_STATE_DISABLE, UIPIC_DREAMLAND.tab_light)
	_dream_tab_xy:registerScriptHandler(dream_tab_xy_event);


	-- _dream_tab_xy = ZTextButton:create(self_panel, Lang.dreamland.tab_text[1], UIPIC_CangKuWin_0003, 
 --        dream_tab_xy_event, arrange_btn_left, arrange_btn_bottom, _arrange_btn_size.width, _arrange_btn_size.height)
 --    arrange_btn:setFontSize(_arrange_btn_textfontsize) --设置字体大小

	-- 按钮文字
	--_dream_tab_xy_lab = CCZXImage:imageWithFile(12, 12, -1, -1, UIPIC_DREAMLAND_029)
	--_dream_tab_xy:addChild(_dream_tab_xy_lab)
	_dream_tab_xy_lab = MUtils:create_zxfont(
		_dream_tab_xy, Lang.dreamland.tab_text[1], 
		_dream_tab_size.width/2, _dream_tab_size.height/2, ALIGN_CENTER, _font_size)
    _dream_tab_xy_lab:setAnchorPoint(CCPointMake(0, 0.5))

	--月华tab 按钮 150->117
	dream_tab_yh = CCNGBtnMulTex:buttonWithFile(
		_dream_tab_rect.origin.x+_dream_tab_size.width, _dream_tab_rect.origin.y, 
		_dream_tab_size.width, _dream_tab_size.height, UIPIC_DREAMLAND.tab_gray);
	self_panel:addChild(dream_tab_yh);
	dream_tab_yh:addTexWithFile(CLICK_STATE_DISABLE, UIPIC_DREAMLAND.tab_light)
	dream_tab_yh:registerScriptHandler(dream_tab_yh_event);
	-- 按钮文字
    --dream_tab_yh_lab = CCZXImage:imageWithFile(12, 12, -1, -1, UIPIC_DREAMLAND_030);
	--dream_tab_yh:addChild(dream_tab_yh_lab);
	dream_tab_yh_lab = MUtils:create_zxfont(
		dream_tab_yh, Lang.dreamland.tab_text[2], 
		_dream_tab_size.width/2, _dream_tab_size.height/2, ALIGN_CENTER, _font_size)
    dream_tab_yh_lab:setAnchorPoint(CCPointMake(0, 0.5))

    --日曜tab 按钮 150->117
	dream_tab_ry = CCNGBtnMulTex:buttonWithFile(
		_dream_tab_rect.origin.x+_dream_tab_size.width*2, _dream_tab_rect.origin.y, 
		_dream_tab_size.width, _dream_tab_size.height, UIPIC_DREAMLAND.tab_gray);
	self_panel:addChild(dream_tab_ry);
	dream_tab_ry:addTexWithFile(CLICK_STATE_DISABLE, UIPIC_DREAMLAND.tab_light)
	dream_tab_ry:registerScriptHandler(dream_tab_ry_event);
	dream_tab_ry:setIsVisible(false)
	-- 按钮文字
    --dream_tab_yh_lab = CCZXImage:imageWithFile(12, 12, -1, -1, UIPIC_DREAMLAND_030);
	--dream_tab_yh:addChild(dream_tab_yh_lab);
	dream_tab_ry_lab = MUtils:create_zxfont(
		dream_tab_ry, Lang.dreamland.tab_text[3], 
		_dream_tab_size.width/2, _dream_tab_size.height/2, ALIGN_CENTER, _font_size)
    dream_tab_ry_lab:setAnchorPoint(CCPointMake(0, 0.5))


	-- 九宫格底图
	local normal_bg = ZImage:create(self_panel, UILH_COMMON.normal_bg_v2, 5, 15, 427, 515, 0, 500, 500)
	local bg_pos = CCPointMake(_dream_slot_bg_region_rect.origin.x-5,_dream_slot_bg_region_rect.origin.y);
	local bg_size = CCSizeMake(_dream_slot_bg_region_size.width+10,_dream_slot_bg_region_size.height);
	local coner_size = CCSizeMake(500,500);
	local dreamland_bg	= CCBasePanel:panelWithFile(
		bg_pos.x,
		bg_pos.y,
		bg_size.width,
		bg_size.height,
		UILH_COMMON.bottom_bg,
		coner_size.width,
		coner_size.height);
	self_panel:addChild(dreamland_bg);

	--背景图
	local dream_bg_sp = CCBasePanel:panelWithFile(
		_dream_slot_bg_regionimg_rect.origin.x,
		_dream_slot_bg_regionimg_rect.origin.y, 
		_dream_slot_bg_regionimg_rect.size.width, 
		_dream_slot_bg_regionimg_rect.size.height, 
		"");
	dreamland_bg:addChild(dream_bg_sp);

	local dreamland_bg_centerpos = CCPointMake(_dream_slot_bg_regionimg_rect.size.width/2, _dream_slot_bg_regionimg_rect.size.height/2)
	local dream_bg_sp_bg_1 = CCZXImage:imageWithFile(
		dreamland_bg_centerpos.x, dreamland_bg_centerpos.y, _dream_slot_bg_regionimg_rect.size.width/2, _dream_slot_bg_regionimg_rect.size.height, "nopack/BigImage/dreamland_bg.png")
	dream_bg_sp_bg_1:setAnchorPoint(1, 0.5)
  	dream_bg_sp:addChild(dream_bg_sp_bg_1)


  	local dream_bg_sp_bg_2 = CCZXImage:imageWithFile(
		dreamland_bg_centerpos.x, dreamland_bg_centerpos.y, _dream_slot_bg_regionimg_rect.size.width/2, _dream_slot_bg_regionimg_rect.size.height, "nopack/BigImage/dreamland_bg.png")
	dream_bg_sp_bg_2:setAnchorPoint(0, 0.5)
  	dream_bg_sp:addChild(dream_bg_sp_bg_2)
  	dream_bg_sp_bg_2:setFlipX(true)

  	local slot_gap_size = CCSize(  --物品格间距
		(_dream_slot_region_size.width-_slot_num_size.width*_dream_slot_small_size.width)/(_slot_num_size.width-1),
		(_dream_slot_region_size.height-_slot_num_size.height*_dream_slot_small_size.height)/(_slot_num_size.height-1)
		)

  	local centerX = _dream_slot_bg_regionimg_rect.size.width/2
	local slot_region_padding_bg_sp={  --物品区域相对bg_sp的间距
		left=_dream_slot_region_padding.left-_dream_slot_bg_regionimg_padding.left+5,
		top=_dream_slot_region_padding.top-_dream_slot_bg_regionimg_padding.top,
		right=_dream_slot_region_padding.right-_dream_slot_bg_regionimg_padding.right,
		bottom=_dream_slot_region_padding.bottom-_dream_slot_bg_regionimg_padding.bottom
		}

	--两个大icon
	--tag为100,
	local slot_width = _dream_slot_big_size.width
    local slot_height = _dream_slot_big_size.height

   
    local bigiconpos1 = CCPoint(
    	centerX-slot_gap_size.width/2,
    	_dream_slot_bg_regionimg_rect.size.height-slot_region_padding_bg_sp.top-_dream_slot_small_size.height - slot_gap_size.height - 7)


	item_big_icon_1 = create_item_obj(100, bigiconpos1.x, bigiconpos1.y, slot_width, slot_height, ItemConfig:get_item_icon(38202), UIPIC_DREAMLAND.slot_item);
	item_big_icon_1:setAnchor(1, 1)
	item_big_icon_1:set_color_frame(38202, -_icon_offset, -_icon_offset, slot_width+_icon_offset*2, slot_height+_icon_offset*2)
	dream_bg_sp:addChild(item_big_icon_1.view);


	local bigiconpos2 = CCPoint(
    	centerX+slot_gap_size.width/2,
    	bigiconpos1.y)


	--tag为101
	item_big_icon_2 = create_item_obj(101, bigiconpos2.x, bigiconpos2.y, slot_width, slot_height, ItemConfig:get_item_icon(18615), UIPIC_DREAMLAND.slot_item);
	item_big_icon_2:setAnchor(0, 1)
	item_big_icon_2:set_color_frame(18615, -_icon_offset, -_icon_offset, slot_width+_icon_offset*2, slot_height+_icon_offset*2)
	dream_bg_sp:addChild(item_big_icon_2.view);

	local small_slot_width = _dream_slot_small_size.width
	local small_slot_height = _dream_slot_small_size.height

	
	-- print("slot_region_padding_bg_sp.left:" .. slot_region_padding_bg_sp.left
	-- 	.. " top:" .. slot_region_padding_bg_sp.top
	-- 	.. " right:" .. slot_region_padding_bg_sp.right
	-- 	.. " bottom:" .. slot_region_padding_bg_sp.bottom)
	

	for i=1,10 do
		--icon
		local item_id = xy_icon_v_dic[i];
		local itempos = CCPoint(0, 0)
		if i<=5 then
			itempos = CCPoint(
				slot_region_padding_bg_sp.left,
				slot_region_padding_bg_sp.bottom + (_dream_slot_small_size.height+slot_gap_size.height)*(i-1));
		else
			itempos = CCPoint(
				slot_region_padding_bg_sp.left+_dream_slot_region_size.width-_dream_slot_small_size.width,
				slot_region_padding_bg_sp.bottom + (_dream_slot_small_size.height+slot_gap_size.height)*(i-6));
		end
		--print("itempos x y" .. itempos.x .. " " .. itempos.y)
		local small_item = create_item_obj(i,
			itempos.x, 
			itempos.y,
			small_slot_width,
			small_slot_height,
			ItemConfig:get_item_icon(item_id),
			UIPIC_DREAMLAND.slot_item);


		small_item:set_color_frame(item_id, -_icon_offset, -_icon_offset, small_slot_width+_icon_offset*2, small_slot_height+_icon_offset*2)
		--small_item.view:setScaleX(small_slot_width/slot_width);
		--small_item.view:setScaleY(small_slot_height/slot_height)
		dream_bg_sp:addChild(small_item.view);
		--保存icon对象
		icon_v_table[i] = small_item;

		-- if i<=5 then
		-- 	small_item:setPosition(
		-- 		slot_region_padding_bg_sp.left,
		-- 		slot_region_padding_bg_sp.bottom + (_dream_slot_small_size.height+slot_gap_size.height)*(i-1));
		-- else
		-- 	small_item:setPosition(
		-- 		slot_region_padding_bg_sp.left+_dream_slot_region_size.width-_dream_slot_small_size.width,
		-- 		slot_region_padding_bg_sp.bottom + (_dream_slot_small_size.height+slot_gap_size.height)*(i-6));
		-- end
	end

	for i=1,6 do
		--icon
		local item_id = xy_icon_h_dic[i];

		local itempos = CCPoint(0, 0)
		if i<=3 then
			itempos = CCPoint(
				slot_region_padding_bg_sp.left + (_dream_slot_small_size.width + slot_gap_size.width)*i, 
				_dream_slot_bg_regionimg_rect.size.height-slot_region_padding_bg_sp.top-_dream_slot_small_size.height);
		else
			itempos = CCPoint(
				slot_region_padding_bg_sp.left + (_dream_slot_small_size.width + slot_gap_size.width)*(i-3), 
				slot_region_padding_bg_sp.bottom);
		end

		local small_item = create_item_obj(10+i,
			itempos.x, 
			itempos.y,
			small_slot_width,
			small_slot_height,
			ItemConfig:get_item_icon(item_id),
			UIPIC_DREAMLAND.slot_item);
		small_item:set_color_frame(item_id, -_icon_offset, -_icon_offset, small_slot_width+_icon_offset*2, small_slot_height+_icon_offset*2)
		--small_item.view:setScaleX(small_slot_width/slot_width);
		--small_item.view:setScaleY(small_slot_height/slot_height)
		dream_bg_sp:addChild(small_item.view);
		--保存icon对象
		icon_h_table[i] = small_item;

		-- if i<=3 then
		-- 	small_item:setPosition(
		-- 		slot_region_padding_bg_sp.left + (_dream_slot_small_size.width + slot_gap_size.width)*i, 
		-- 		_dream_slot_bg_regionimg_rect.size.height-slot_region_padding_bg_sp.top-_dream_slot_small_size.height);
		-- else
		-- 	small_item:setPosition(
		-- 		slot_region_padding_bg_sp.left + (_dream_slot_small_size.width + slot_gap_size.width)*(i-3), 
		-- 		slot_region_padding_bg_sp.bottom);
		-- end
	end

	--仓库按钮
	-- local cangku_btn_pos = CCPoint(
	-- 	_dream_base_size.width - _cangku_btn_padding.right, 
	-- 	_dream_slot_bg_region_rect.origin.y-_cangku_btn_padding.top)
	local cangku_btn_pos = CCPoint(
		_dream_base_size.width - _cangku_btn_padding.right, 
		_cangku_btn_padding.bottom)
	_cangku_btn = ZTextButton:create(self_panel, Lang.dreamland.btn_dreamcangku_text, UIPIC_CangKuWin_0003, 
        open_cangku, cangku_btn_pos.x, cangku_btn_pos.y, _cangku_btn_size.width, _cangku_btn_size.height)
    _cangku_btn:setFontSize(_font_size) --设置字体大小
	_cangku_btn:setAnchorPoint(1,0);
	--_cangku_btn:addTexWithFile(CLICK_STATE_DOWN,UIPIC_CangKuWin_0006);

	-- _cangku_btn = CCNGBtnMulTex:buttonWithFile(cangku_btn_pos.x, cangku_btn_pos.y,
	--  _cangku_btn_size.width, _cangku_btn_size.height, UIPIC_CangKuWin_0003);
	-- _cangku_btn:setAnchorPoint(1,1);
	-- self_panel:addChild(_cangku_btn);
	-- _cangku_btn:addTexWithFile(CLICK_STATE_DOWN,UIPIC_CangKuWin_0006);
	-- _cangku_btn:registerScriptHandler(open_cangku);
	-- _cangku_btn:setText(Lang.dreamland.btn_dreamcangku_text)


	-- 按钮文字
	-- _cangku_btn_lab = CCZXImage:imageWithFile(73,29,-1,-1,UIPIC_DREAMLAND_019);
	-- _cangku_btn_lab:setAnchorPoint(0.5,0.5);
	-- _cangku_btn:addChild(_cangku_btn_lab);
	
	-- local tanbao_top_padding = 15
	-- local tanbao_num1_pos1 = CCPointMake(0, bigiconpos1.y-_dream_slot_big_size.height - tanbao_top_padding)

	--探宝按钮1
	tanbao_btn_1 = CCNGBtnMulTex:buttonWithFile(0,_tanbao_btn_height,tanbao_btn_size.width,tanbao_btn_size.height,UIPIC_DREAMLAND.tanbao_btn);
	tanbao_btn_1:setAnchorPoint(0.5,0.5);
	tanbao_btn_1:addTexWithFile(CLICK_STATE_DOWN,UIPIC_DREAMLAND.tanbao_btn);
	tanbao_btn_1:registerScriptHandler(tanbao_1_event);
	dreamland_bg:addChild(tanbao_btn_1);

	local btnsize = tanbao_btn_1:getSize()
	local tanbao_lab_1 = CCZXImage:imageWithFile(btnsize.width/2, btnsize.height/2, -1, -1, UIPIC_DREAMLAND.tanbao1)
	tanbao_btn_1:addChild(tanbao_lab_1);
	tanbao_lab_1:setAnchorPoint(0.5, 0.5)

	local text_bg1 = CCZXImage:imageWithFile(btnsize.width/2, -5, -1, -1, UIPIC_DREAMLAND.text_bg)
	tanbao_btn_1:addChild(text_bg1)
	text_bg1:setAnchorPoint(0.5, 0.5)

	tanbao_money_lab_1 = CCZXLabel:labelWithTextS(CCPointMake(38,10), LangGameString[886], _font_size, ALIGN_CENTER); -- [886]="#c38ff3310元宝"
	text_bg1:addChild(tanbao_money_lab_1);


	-- [898]="#c38ff33优先使用#r星蕴结晶"
	_tip_lab = MUtils:create_ccdialogEx(dreamland_bg, Lang.dreamland.label_youxianxyjiejin,_tip_lab_pos.x,_tip_lab_pos.y,_tip_lab_size.width,_tip_lab_size.height,ALIGN_CENTER,_font_size) 

	--探宝按钮2
	tanbao_btn_2 = CCNGBtnMulTex:buttonWithFile(50+82,_tanbao_btn_height,tanbao_btn_size.width,tanbao_btn_size.height,UIPIC_DREAMLAND.tanbao_btn);
	tanbao_btn_2:setAnchorPoint(0.5,0.5);
	tanbao_btn_2:addTexWithFile(CLICK_STATE_DOWN,UIPIC_DREAMLAND.tanbao_btn);
	tanbao_btn_2:registerScriptHandler(tanbao_10_event);
	dreamland_bg:addChild(tanbao_btn_2);
	btnsize = tanbao_btn_2:getSize()
	local tanbao_lab_2 = CCZXImage:imageWithFile(btnsize.width/2, btnsize.height/2, -1, -1, UIPIC_DREAMLAND.tanbao10)
	tanbao_btn_2:addChild(tanbao_lab_2);
	tanbao_lab_2:setAnchorPoint(0.5, 0.5)
	local text_bg2 = CCZXImage:imageWithFile(btnsize.width/2, -5, -1, -1, UIPIC_DREAMLAND.text_bg)
	tanbao_btn_2:addChild(text_bg2)
	text_bg2:setAnchorPoint(0.5, 0.5)
	tanbao_money_lab_2 = CCZXLabel:labelWithTextS(CCPointMake(38,10), LangGameString[887], _font_size, ALIGN_CENTER); -- [887]="#c38ff3390元宝"
	text_bg2:addChild(tanbao_money_lab_2);

	--探宝按钮3
	tanbao_btn_3 = CCNGBtnMulTex:buttonWithFile(50+82*2,_tanbao_btn_height,tanbao_btn_size.width,tanbao_btn_size.height,UIPIC_DREAMLAND.tanbao_btn);
	tanbao_btn_3:setAnchorPoint(0.5,0.5);
	tanbao_btn_3:addTexWithFile(CLICK_STATE_DOWN,UIPIC_DREAMLAND.tanbao_btn);
	tanbao_btn_3:registerScriptHandler(tanbao_50_event);
	dreamland_bg:addChild(tanbao_btn_3);
	btnsize = tanbao_btn_3:getSize()
	local tanbao_lab_3 = CCZXImage:imageWithFile(btnsize.width/2, btnsize.height/2, -1, -1, UIPIC_DREAMLAND.tanbao50)
	tanbao_btn_3:addChild(tanbao_lab_3);
	tanbao_lab_3:setAnchorPoint(0.5, 0.5)
	local text_bg3 = CCZXImage:imageWithFile(btnsize.width/2, -5, -1, -1, UIPIC_DREAMLAND.text_bg)
	tanbao_btn_3:addChild(text_bg3)
	text_bg3:setAnchorPoint(0.5, 0.5)
	tanbao_money_lab_3 = CCZXLabel:labelWithTextS(CCPointMake(38,10), LangGameString[888], _font_size, ALIGN_CENTER); -- [888]="#c38ff33450元宝"
	text_bg3:addChild(tanbao_money_lab_3);

	--元宝余额	
	
	local yuanbao_panel_pos = CCPointMake(
		yuanbao_panel_padding.left,
		_dream_slot_bg_region_rect.origin.y-yuanbao_panel_padding.top)	
	--print("yuanbao_panel_pos:x y " .. yuanbao_panel_pos.x .. " " .. yuanbao_panel_pos.y)
	local yuanbao_panel = CCBasePanel:panelWithFile(
		yuanbao_panel_pos.x, 
		yuanbao_panel_pos.y, 
		yuanbao_panel_size.width, 
		yuanbao_panel_size.height, 
		"")		
	yuanbao_panel:setAnchorPoint(0, 1) --以left top为基准
	self_panel:addChild(yuanbao_panel)

	
	local yuanbao_lab = CCZXLabel:labelWithTextS(yuanbao_lab_pos, Lang.dreamland.label_yuanbao_text, _font_size, ALIGN_LEFT); -- [901]="#c38ff33元    宝:"
	local yuanbaolabelsize = yuanbao_lab:getSize() --文字尺寸		
	yuanbao_panel:addChild(yuanbao_lab)

	
	local yuanbao_textbg_pos = CCPointMake(yuanbao_lab_pos.x+yuanbaolabelsize.width+yuanbao_textbg_padding.left, yuanbao_textbg_padding.bottom)
	local yuanbao_textbg = CCBasePanel:panelWithFile(
		yuanbao_textbg_pos.x, yuanbao_textbg_pos.y, yuanbao_textbg_size.width, yuanbao_textbg_size.height, 
		"", 500, 500);
	yuanbao_panel:addChild(yuanbao_textbg)
	--yuanbao_textbg:setIsVisible(false)

	yuanbao_count = CCZXLabel:labelWithTextS(yuanbao_count_pos,"0", _font_size, ALIGN_LEFT)
	yuanbao_textbg:addChild(yuanbao_count)

	


	--绑元余额
	-- local bindyuanbao_lab = CCZXLabel:labelWithTextS(CCPointMake(10,-26-10-20-5), "#cfff000绑    元", _font_size, ALIGN_LEFT); -- [901]="#c38ff33元    宝:"
	-- dreamland_bg:addChild(bindyuanbao_lab);
	-- local bindyuanbao_bg = CCBasePanel:panelWithFile(88, -32-10-20-5, 110, 26, UIPIC_DREAMLAND_010, 500, 500);
	-- dreamland_bg:addChild(bindyuanbao_bg)
	-- bindyuanbao_count = CCZXLabel:labelWithTextS(CCPointMake(96,-28-10-20-5+2),"", _font_size, ALIGN_LEFT);
	-- dreamland_bg:addChild(bindyuanbao_count);

	--星蕴结晶
	local jiejin_panel_size = yuanbao_panel_size  --区域的尺寸
	local jiejin_panel_padding = {left=yuanbao_panel_padding.left, top=12} --区域相对底板的间距
	local jiejin_panel_pos = CCPointMake(  --区域相对底板的位置
		jiejin_panel_padding.left,
		yuanbao_panel_pos.y-yuanbao_panel_size.height-jiejin_panel_padding.top)	
	--print("yuanbao_panel_pos:x y " .. yuanbao_panel_pos.x .. " " .. yuanbao_panel_pos.y)
	local jiejin_panel = CCBasePanel:panelWithFile(
		jiejin_panel_pos.x, 
		jiejin_panel_pos.y, 
		jiejin_panel_size.width, 
		jiejin_panel_size.height, 
		"")		
	jiejin_panel:setAnchorPoint(0, 1)
	self_panel:addChild(jiejin_panel)


	local jiejin_lab_pos = CCPointMake(yuanbao_lab_pos.x, (jiejin_panel_size.height-_font_size)/2)
	jiejin_lab = CCZXLabel:labelWithTextS(jiejin_lab_pos, Lang.dreamland.label_xyjiejing_text, _font_size, ALIGN_LEFT); -- [889]="#c38ff33星蕴结晶:"
	local jiejinlabelsize = jiejin_lab:getSize() --文字尺寸	
	jiejin_panel:addChild(jiejin_lab)

	local jiejin_textbg_size = yuanbao_textbg_size
	local jiejin_textbg_padding = {left=yuanbao_textbg_padding.left-2, bottom=(jiejin_panel_size.height-jiejin_textbg_size.height)/2}	
	local jiejin_textbg_pos = CCPointMake(jiejin_lab_pos.x+jiejinlabelsize.width+jiejin_textbg_padding.left, jiejin_textbg_padding.bottom)
	local jiejie_textbg = CCBasePanel:panelWithFile(
		jiejin_textbg_pos.x, jiejin_textbg_pos.y, jiejin_textbg_size.width, jiejin_textbg_size.height, 
		"", 500, 500);
	jiejin_panel:addChild(jiejie_textbg)
	--jiejie_textbg:setIsVisible(false)

	local jiejin_count_pos = CCPointMake(yuanbao_count_pos.x, (jiejin_textbg_size.height-_font_size)/2)
	jiejin_count = CCZXLabel:labelWithTextS(yuanbao_count_pos,"0", _font_size, ALIGN_LEFT) --#cfff00088888
	jiejie_textbg:addChild(jiejin_count);
	
end

 -- 初始化函数
function DreamlandWin:__init( texture_name )	
	--_dream_base_size = self.view:getSize()

_dream_slot_bg_region_padding = {
	left=_dream_tab_padding.left-2, 
	top=_dream_tab_padding.top+_dream_tab_size.height-4, 
	right=_dream_tab_padding.left-2, 
	bottom=90}

_dream_slot_bg_region_size = CCSize(
	_dream_base_size.width-_dream_slot_bg_region_padding.left-_dream_slot_bg_region_padding.right, 
	_dream_base_size.height-_dream_slot_bg_region_padding.top-_dream_slot_bg_region_padding.bottom
	) --物品格背景区域尺寸 不包括tab
--_dream_slot_bg_region_size.height = _dream_base_size.height-_dream_slot_bg_region_padding.top - _dream_slot_bg_region_padding.bottom
_dream_slot_bg_region_rect = CCRect(
	_dream_slot_bg_region_padding.left, 
	_dream_slot_bg_region_padding.bottom,
	_dream_slot_bg_region_size.width, 
	_dream_slot_bg_region_size.height)


_dream_tab_rect = CCRect(
	_dream_tab_padding.left+10,
	_dream_base_size.height-_dream_tab_padding.top-_dream_tab_size.height,
	_dream_tab_size.width,
	_dream_tab_size.height
	)
--print("_dream_tab_rect.origin.y:" .. _dream_tab_rect.origin.y)

_dream_slot_bg_regionimg_rect = CCRect(  --相对二层底板的位置
	_dream_slot_bg_regionimg_padding.left,
	_dream_slot_bg_regionimg_padding.bottom,
	_dream_slot_bg_region_rect.size.width-_dream_slot_bg_regionimg_padding.left-_dream_slot_bg_regionimg_padding.right,
	_dream_slot_bg_region_rect.size.height-_dream_slot_bg_regionimg_padding.top-_dream_slot_bg_regionimg_padding.bottom
	)
	

_dream_slot_region_size=CCSize(
	_dream_slot_bg_region_rect.size.width-_dream_slot_region_padding.left-_dream_slot_region_padding.right,
	_dream_slot_bg_region_rect.size.height-_dream_slot_region_padding.top-_dream_slot_region_padding.bottom
	)



	-- 构造面板内容
	self:initPanel(self.view)
end
-- -- 创建函数
-- function DreamlandWin:create(texture_name)
-- 	return DreamlandWin(texture_name,10,50,389,429);
-- end

function DreamlandWin:destroy()
	local winname = DreamlandCangkuWin:getwinname()
	if UIManager:find_visible_window(winname) then
		UIManager:hide_window(winname)
	end
	winname = DreamlandInfoWin:getwinname()
	if UIManager:find_visible_window(winname) then
		UIManager:hide_window(winname)
	end
end

function DreamlandWin:getwinname()
	return _window_name
end