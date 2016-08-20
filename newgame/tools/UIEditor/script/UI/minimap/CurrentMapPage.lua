-- CurrentMapPage.lua
-- create by hcl on 2013-2-18
-- 当前地图页(小地图)

super_class.CurrentMapPage()


-- 是否使用筋斗云
-- local self.is_use_jingdouyun = false;

local _is_npc = true;

local _scene_id = 0;
-- 场景的地图名字
local _scene_mapfile = nil;
--大场景的像素尺寸
local _scene_size = nil;
--大场景与小地图的比例
local _scene_scale = 1;
--小地图配置
local _mini_map_info = nil;

-- npc 列表
local _npc_dict = nil;
-- local _npc_btn_dict = nil
local _npc_tasks = nil;
-- 怪物列表
local _monster_dict = nil;
-- local _monster_btn_dict = nil;
-- 传送阵列表
local _teleport_dict = nil;
-- local _monster_btn_dict = nil;
-- 保存一份主角当前坐标
local _player_curr_pos = {x=0,y=0};

local _frame_size=nil
local _right_ycursor=nil

local _font_size=16
local _text_color = "#ccdbda4"

local _scrollbar={
	size = CCSize(12, 0), --尺寸
	slider={ --滑块
		size = CCSize(10, 10), --滑块尺寸
		--padding={left=2, top=2, right=2, bottom=2},
		--size=CCSize(_scrollbar.size.width-padding.left-padding.right,	22)
	},
	upbar={
		padding={left=0, top=0, right=0},
		size=CCSize(12, 12)
	},
	downbar={
		padding={left=0, right=0, bottom=0},
		size=CCSize(12, 12)
	},
}

local _switch_btn=nil

--local _base_size=nil
-- 请求当前场景所有npc任务状态的回调
function CurrentMapPage:do_npc_task_status( scene_id, npcs )
	if scene_id == _scene_id then
		if #npcs > 0 then
			_npc_tasks = npcs;
			if self.scroll then
				 print("CurrentMapPage,npc任务",#_npc_tasks);
				self.scroll:clear();
				self.scroll:setMaxNum(#_npc_tasks);
				self.scroll:refresh();
			end
		end
	end
end

-- 开始每隔3秒钟轮询一次AOI内的实体坐标
--@brief:因策划要求，暂时不做该功能
-- function CurrentMapPage:start_update_AOI_entity(  )
	
-- 	local function update_tick(  )
		
-- 		local enitites = EntityManager:get_entities( )
-- 		for handle,entity in pairs(enitites) do
-- 			local entity_type = EntityConfig.ENTITY_TYPE[entity.type];
-- 			if entity_type == "Avatar" or entity_type == "PlayerPet" or entity_type == "Pet" then
-- 				-- print("每隔3秒钟,实体坐标,",entity_type,entity.model.m_x, entity.model.m_y);
-- 				local pos_x = entity.model.m_x * _scene_scale;
-- 				--y轴翻转
-- 				local pos_y = self.map_panel:getSize().height - entity.model.m_y * _scene_scale;

-- 			end
-- 		end
-- 	end
-- 	update_tick();
-- 	self.update_timer = timer();
-- 	self.update_timer:start(3, update_tick);
-- end

function CurrentMapPage:destroy(  )
	print("销毁当前地图");
	_is_npc = true;
	_scene_id = 0;
	_scene_mapfile = nil;
	_scene_size = nil; 
	_scene_scale = 1; 
	_mini_map_info = nil; 
	_npc_dict = nil;
	-- _npc_btn_dict = nil
	_npc_tasks = nil;
	_monster_dict = nil;
	-- _monster_btn_dict = nil;
	_teleport_dict = nil;
	-- _monster_btn_dict = nil; 
	_player_curr_pos = {x=0,y=0};
	
	self.scroll = nil;
	self.map_panel = nil;
	self.map_sp = nil;
	self.player_head = nil;
	self.indicator_sp = nil;

end

-------------------------------------
function CurrentMapPage:__init(parentpanel, scene_id )
	local parentsize = parentpanel:getSize()  --map_panel
	--_base_size = parentsize

	--frame_width = parentsize.width
	--frame_height = parentsize.height

	--加载场景配置
	self:load_scene_data(scene_id);
	--UIPIC_GRID_nine_grid_bg3
	local basePanel_padding={left=0, top=7, right=0, bottom=7}
    local basePanel_size=CCSize(
        parentsize.width-basePanel_padding.left-basePanel_padding.right,
        parentsize.height-basePanel_padding.top-basePanel_padding.bottom)
    local basePanel_pos=CCPointMake(basePanel_padding.left, basePanel_padding.bottom)
    --local basePanel_pos=CCPointMake(basePanel_size.width/2, basePanel_size.height-basePanel_padding.top)
    local basePanel = CCBasePanel:panelWithFile(basePanel_pos.x,basePanel_pos.y,basePanel_size.width,basePanel_size.height,nil,0,0);
    --basePanel:setAnchorPoint(0.5, 1)
	--self.view = CCBasePanel:panelWithFile(40,22,840,500-16,nil,500,500);
	self.view = basePanel

	-- 创建小地图
	if self.view ~= nil then
		self:create_mini_map(basePanel);
	end


	--local bg_panel = CCBasePanel:panelWithFile()

	-- npc、怪物列表面板
	local list_view_padding={top=10, right=10, bottom=10}
	local list_view_size=CCSize(235, basePanel_size.height-list_view_padding.top-list_view_padding.bottom)
	local list_view_pos=CCPointMake(basePanel_size.width-list_view_padding.right, basePanel_size.height/2)
	local list_view = CCBasePanel:panelWithFile(
		list_view_pos.x, list_view_pos.y,list_view_size.width, list_view_size.height,nil);
	basePanel:addChild(list_view);
	list_view:setDefaultMessageReturn(false);
	list_view:setAnchorPoint(1, 0.5)


	--小面板
	local list_panel_padding={top=0, right=0, bottom=0}
	local list_panel_size = CCSize(
		182,
        list_view_size.height-list_panel_padding.top-list_panel_padding.bottom)
	--local list_panel_pos = CCPointMake(list_panel_padding.left, list_panel_padding.bottom)
	local list_panel_pos = CCPointMake(list_view_size.width-list_panel_padding.right, list_panel_padding.bottom)
	local list_panel = CCBasePanel:panelWithFile(list_panel_pos.x, list_panel_pos.y, 
		list_panel_size.width, list_panel_size.height, UILH_COMMON.bg_01, 500, 500);
	list_view:addChild(list_panel);
	list_panel:setAnchorPoint(1, 0)

	_right_ycursor = list_panel_size.height

	-- 开关导航列表
	self.list_view_switch_open = true;
	local function switch_list_panel( eventType )
		if eventType == TOUCH_CLICK then

			if self.list_view_switch_open then
				-- 如果 状态为open，则执行关闭操作
				self.list_view_switch_open = not self.list_view_switch_open;
				local move_by_act = CCMoveBy:actionWithDuration(0.5, CCPointMake(list_panel_size.width, 0));
				local act_easa = CCEaseExponentialOut:actionWithAction(move_by_act);
				list_view:runAction(act_easa);

				-- local move_by_act2 = CCMoveBy:actionWithDuration(0.5, CCPointMake(basePanel_size.width,20));
				-- local act_easa2 = CCEaseExponentialOut:actionWithAction(move_by_act2);
				
				-- _switch_btn:runAction(act_easa2);
				--print("_switch_btn:runAction(act_easa2);")

				--_switch_btn:setPosition(basePanel_size.width,20)
				_switch_btn:setFlipX(false)

			else
				-- 如果 状态为close，则执行开启操作
				self.list_view_switch_open = not self.list_view_switch_open;
				local move_by_act = CCMoveBy:actionWithDuration(0.5, CCPointMake(-list_panel_size.width, 0));
				local act_easa = CCEaseExponentialOut:actionWithAction(move_by_act);
				list_view:runAction(act_easa);

				--_switch_btn:setPosition(basePanel_size.width-list_view_size.width,20)
				-- local move_by_act3 = CCMoveBy:actionWithDuration(0.5, CCPointMake(basePanel_size.width-180,20));
				-- local act_easa3 = CCEaseExponentialOut:actionWithAction(move_by_act3);
				
				-- _switch_btn:runAction(act_easa3);
				--print("_switch_btn:runAction(act_easa3);")

				--_switch_btn:setPosition(basePanel_size.width-180,20)
				_switch_btn:setFlipX(true)
			end
		end
		return true;
	end

	-- local switch_btn = MUtils:create_btn(
	-- 	list_view, "ui2/minimap/map_list.png","ui2/minimap/map_list.png",switch_list_panel,0,0,-1,-1);
	-- local switch_btn1 = MUtils:create_btn(
	-- 	switch_btn, UILH_COMMON.page,UILH_COMMON.page,switch_list_panel,50,0,-1,-1, 999);


	-- local switch_btn = ZImageButton:create(
	-- 	list_panel, UILH_COMMON.page, UILH_COMMON.page, switch_list_panel, 0, 0,-1,-1)
	_switch_btn = CCNGBtnMulTex:buttonWithFile(
		0,20,-1,-1, UILH_COMMON.page);
	_switch_btn:setFlipX(true)
	list_view:addChild(_switch_btn)
	_switch_btn:addTexWithFile(CLICK_STATE_DOWN, UILH_COMMON.page)
	_switch_btn:registerScriptHandler(switch_list_panel)	
	_switch_btn:setAnchorPoint(0, 0)

	local btnsize = _switch_btn:getSize()
	local btnlabel = ZLabel:create(_switch_btn, Lang.minimap.list_text, 0, btnsize.height/2+2, _font_size, ALIGN_LEFT, -1)
	btnlabel.view:setAnchorPoint(CCPointMake(1, 0.5))
	-- local switch_btn = MUtils:create_double_btn( list_view, {file = UIResourcePath.FileLocate.other .. "map_list_lab.png",x=0,y=0,w=40,h=24}, 
	-- 							{file=UIResourcePath.FileLocate.normal .. "m_hide_l.png",x=40,y=0,w=25,h=24}, switch_list_panel, 0, 310, 70, 25 );

	-- local switch_btn = MUtils:create_btn(list_view,"ui/main/m_hide_l.png","ui/main/m_hide_l.png",
											-- switch_list_panel, 0, 0, 31, 32);

	-- local tip_lab = MUtils:create_zximg(switch_btn,"ui/common/map_list_lab.png",-40,5,40,24);

	-- MUtils:create_zximg(list_panel,UIResourcePath.FileLocate.common .. "coner1.png",0,376-26-35,155,26,500,500);
	-- MUtils:create_zximg(list_panel,UIResourcePath.FileLocate.common .. "quan_bg.png",3,376-90-23,149,1,0,0);

	--radiobutton背景
	local radiobtn_bg_padding={left=12, top=12, right=12, bottom=0}
	local radiobtn_bg_size=CCSize(list_panel_size.width-radiobtn_bg_padding.left-radiobtn_bg_padding.right, 138)
	local radiobtn_bg_pos=CCPointMake(list_panel_size.width/2, list_panel_size.height-radiobtn_bg_padding.top)
	local radiobtn_bg = CCBasePanel:panelWithFile(
		radiobtn_bg_pos.x, radiobtn_bg_pos.y, radiobtn_bg_size.width, radiobtn_bg_size.height, UILH_COMMON.bg_02, 500 ,500)
	list_panel:addChild(radiobtn_bg)
	radiobtn_bg:setAnchorPoint(0.5, 1)

	

	-- -- 分割线
	-- local split_line = CCZXImage:imageWithFile(
	-- 	list_panel_size.width/2 , 500-90-28,  122, 2, UIResourcePath.FileLocate.common .. "jgt_line.png" ,0,0)
	-- list_panel:addChild(split_line)
	-- split_line:setAnchorPoint(0.5, 0) 


	--单选按钮
	self:create_radio_btn(radiobtn_bg);

	_right_ycursor = _right_ycursor-radiobtn_bg_padding.top-radiobtn_bg_size.height

	-- scroll
	self:create_entity_list_scroll(list_panel,scene_id);

	-- 请求当前场景npc的任务状态
	MiniMapModel:req_npc_task_status( scene_id );

end


-- 抽取场景配置 数据
function CurrentMapPage:load_scene_data( scene_id )


	--场景id
	_scene_id = scene_id;
  
	local scene = SceneConfig:get_scene_by_id(scene_id);
	--地图文件名
	_scene_mapfile = scene.mapfilename;

	--小地图配置
	_mini_map_info = SceneConfig:get_mini_map_info( _scene_mapfile);



	-- 获取npc数据	
	-- if #scene.npc ~= 0 then
	_npc_dict = scene.npc;
	-- end

	--获取怪物数据
	_monster_dict = SceneConfig:get_curr_scene_monster_category(scene_id);
	
	--获取传送阵数据
	if #scene.teleport ~= 0 then
		_teleport_dict = scene.teleport;
	end

	--获取场景的大小
	_scene_size = {width = scene.sceneWidth * 32, height = scene.sceneHeight * 32};
end


-- 创建 单选按钮
function CurrentMapPage:create_radio_btn( panel )
	-- radio btn
	local panelsize=panel:getSize()
	local raido_btn_group_padding={left=0, top=0, right=0, bottom=0}
	local raido_btn_group_size=CCSize(
		panelsize.width-raido_btn_group_padding.left-raido_btn_group_padding.right,
		panelsize.height-raido_btn_group_padding.top-raido_btn_group_padding.bottom)
	local raido_btn_group = CCRadioButtonGroup:buttonGroupWithFile(
		raido_btn_group_padding.left ,raido_btn_group_padding.bottom , raido_btn_group_size.width, raido_btn_group_size.height, nil);
    panel:addChild(raido_btn_group);
 
    for i=1,2 do
        local function btn_fun(eventType,x,y)
            if eventType == TOUCH_CLICK then
				if i == 1 then
					_is_npc = true;
				else 
					_is_npc = false;
				end 
				self:show_NPC_or_monster(_is_npc);
            end
            return true;
        end
        --local x = 50;
        --local y = 36+(i-1) * 60;
        local btn_pos = CCPointMake(50, 36+(i-1) * 60)
        local btn = MUtils:create_radio_button(
        	raido_btn_group, UILH_COMMON.fy_bg, UILH_COMMON.fy_select, btn_fun, btn_pos.x, btn_pos.y,-1,-1,false);
    	btn:setAnchorPoint(0.5, 0.5)

    	local str = "NPC";
    	if i == 2 then
    	    str = LangGameString[1553]; -- [1553]="怪物"
    	end
    	str = _text_color .. str
    	local text_btn = TextButton:create(nil, btn_pos.x+45, btn_pos.y+2, -1, -1, str, nil);
    	local function radio_click(  )
    		raido_btn_group:selectItem(i-1);
    		btn_fun(TOUCH_CLICK);
    		return true;
    	end
    	text_btn:setTouchClickFun( radio_click );
    	panel:addChild(text_btn.view);
    	text_btn:setAnchorPoint(0, 0.5)
    end 
end

-- 显示NPC 或 怪物列表
function CurrentMapPage:show_NPC_or_monster( is_npc )
	if self.scroll ~= nil then
		self.scroll:clear();
		if is_npc then
			if _npc_dict ~= nil then 
				self.scroll:setMaxNum(#_npc_dict);
			end
		else
			if _monster_dict ~= nil then
				self.scroll:setMaxNum(#_monster_dict);
			end
		end
		self.scroll:refresh();
	end
end

function CurrentMapPage:create_npc_func_img( scene_id,npc_name,parent ,layout)
    local npc = SceneConfig:get_npc_data(scene_id, npc_name)
	if ( npc.funcid and npc.funcid ~= 7 )then
		local lab_width = parent:getSize().width;
		--print("CurrentMapPage:create_npc_func_img npc_name,width^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^",npc_name,lab_width);
		if layout == 2 or layout == 4 then
			-----HJH 2014-1-25
			-----将ZImage改成CCSprite
			-----new code
			local temp_image = CCSprite:spriteWithFile("ui/npctitle/map_"..npc.funcid..".png")
			temp_image:setAnchorPoint(CCPointMake(0,0))
			temp_image:setPosition(CCPointMake(lab_width/2+3,-8))
			-----old code
			--ZImage:create(parent,"ui/npctitle/map_"..npc.funcid..".png",lab_width/2+3,-8);
		elseif layout == 3 then
			-----HJH 2014-1-25
			-----将ZImage改成CCSprite
			-----new code
			local temp_image = CCSprite:spriteWithFile("ui/npctitle/map_"..npc.funcid..".png")
			temp_image:setAnchorPoint(CCPointMake(0,0))
			temp_image:setPosition(CCPointMake(3,8))
			-----old code
			--ZImage:create(parent,"ui/npctitle/map_"..npc.funcid..".png",3,-8);
		else
			-----HJH 2014-1-25
			-----将ZImage改成CCSprite
			-----new code
			local temp_image = CCSprite:spriteWithFile("ui/npctitle/map_"..npc.funcid..".png")
			temp_image:setAnchorPoint(CCPointMake(0,0))
			temp_image:setPosition(CCPointMake(lab_width+3,-8))
			-----old code
			--ZImage:create(parent,"ui/npctitle/map_"..npc.funcid..".png",lab_width+3,-8);
		end
		
	end
end

--创建cell
function CurrentMapPage:get_scroll_cell( index ,scene_id)

	local cell = CCBasePanel:panelWithFile(0,0,175,55,nil);
	-- print("创建cell，npc列表长度", #_npc_dict);
	if _is_npc then
		if _npc_dict ~= nil and #_npc_dict ~= 0 then
			
			local npc = _npc_dict[index+1];
			local name = Utils:parseNPCName(npc.name)
			local lab = UILabel:create_lable_2( _text_color .. name, 20, 25, _font_size, ALIGN_LEFT );
	    	cell:addChild(lab);
	    	-- 添加npc的功能图标  by hcl on 2013/11/20
	    	self:create_npc_func_img( scene_id,npc.name,lab )

	    	-- 点击了npc名字的事件
	    	local function npc_btn_event( )
		    	if MiniMapModel:get_teleport_selected() then
		    		if SceneManager:get_cur_scene() ~= 1128 then
						-- 八卦地宫不能传送
						GlobalFunc:teleport( _scene_id, _npc_dict[index+1].name )
					else
						GlobalFunc:create_screen_notic( LangGameString[1554] ); -- [1554]="当前场景不能速传"
					end
		    		
		    	else 
		    		GlobalFunc:ask_npc( _scene_id, _npc_dict[index+1].name  );
	    		end
	    	end
	 		--npc名字按钮
	    	local npc_btn = TextButton:create(nil, 20, 25, 60, 20, nil, nil);
			npc_btn:setTouchClickFun(npc_btn_event);
			cell:addChild(npc_btn.view);

			--任务状态
			if _npc_tasks ~= nil then
				local statu_img = nil ;
				local w = 22;
				local h = 28;
				for i,v in ipairs(_npc_tasks) do
					if v.name == npc.name then
						-- print(v.name,"的状态",v.status);
						if v.status == 0 then
						elseif v.status == 1 then
							statu_img = "ui2/minimap/map_gantan.png";
							w = 12;
							h = 26;
						elseif v.status == 2 then
							statu_img = "ui2/minimap/map_wenhaoy.png";
						elseif v.status == 3 then
							statu_img = "ui2/minimap/map_wenhaob.png";
						end
						break;
					end
				end
				if statu_img then
					MUtils:create_zximg(cell, statu_img, 20+100, 5,w,h);
				end
			end 

		end
	else
		if _monster_dict ~= nil and #_monster_dict ~= 0 then 
		
			local monster = _monster_dict[index+1];
	 
			local mons = MonsterConfig:get_monster_by_id(monster.entityid );
			local lab = UILabel:create_lable_2( _text_color .. mons.name, 20, 25, _font_size, ALIGN_LEFT );
	    	cell:addChild(lab);

	    	local function monster_btn_event( )
	    		-- 移动到某个坐标
	    		if MiniMapModel:get_teleport_selected() then
	    			if SceneManager:get_cur_scene() ~= 1128 then
						-- 八卦地宫不能传送
						GlobalFunc:teleport_to_target_scene( _scene_id, _monster_dict[index+1].mapx2, _monster_dict[index+1].mapy2 ) 
					else
						GlobalFunc:create_screen_notic( LangGameString[1554] ); -- [1554]="当前场景不能速传"
					end
	    			
	    		else
	    			GlobalFunc:move_to_target_scene( _scene_id, _monster_dict[index+1].mapx2 * 32, _monster_dict[index+1].mapy2 * 32) 
	    		end
	    	end
	    	local monster_btn = TextButton:create(nil, 20, 25, 60, 20, nil, nil);
			monster_btn:setTouchClickFun(monster_btn_event);
			cell:addChild(monster_btn.view);
		end
	end
	local line = ZImage:create(cell, UILH_COMMON.split_line, 5, 0, 135, 2, 0, 500)
	return cell;
end

-- 创建 该场景的实体列表 (NPC和怪物)
function CurrentMapPage:create_entity_list_scroll( panel,scene_id )
	local panelsize = panel:getSize()
	local max_row = 0;
	if _is_npc then
		if _npc_dict ~= nil then
			max_row = #_npc_dict;
		end
	else
		if _monster_dict ~= nil then 
			max_row = #_monster_dict;
		end
	end
	
	local scroll_bg_padding={left=10, top=panelsize.height-_right_ycursor+15, right=10, bottom=25}
	local scroll_bg_size = CCSize(
		panelsize.width-scroll_bg_padding.left-scroll_bg_padding.right,
		panelsize.height-scroll_bg_padding.top-scroll_bg_padding.bottom)
	
	local scroll_bg_pos = CCPointMake(scroll_bg_padding.left, scroll_bg_padding.bottom)
	local scroll_bg = CCBasePanel:panelWithFile(scroll_bg_pos.x, scroll_bg_pos.y, scroll_bg_size.width, scroll_bg_size.height, nil)
	panel:addChild(scroll_bg)

	local scroll_padding={left=0, top=0, right=14, bottom=0}
	local scroll_size=CCSize(
		scroll_bg_size.width-scroll_padding.left-scroll_padding.right,
		scroll_bg_size.height-scroll_padding.top-scroll_padding.bottom)
	local scroll_pos = CCPointMake(scroll_padding.left, scroll_padding.bottom)
	self.scroll = CCScroll:scrollWithFile(scroll_pos.x, scroll_pos.y, scroll_size.width, scroll_size.height, max_row, nil);
	scroll_bg:addChild(self.scroll)

	_scrollbar.size.height = scroll_size.height

	self.scroll:setScrollLump(UIPIC_DREAMLAND.scrollbar_move, UIPIC_DREAMLAND.scrollbar_bg, _scrollbar.size.width, _scrollbar.size.height, _scrollbar.slider.size.height)

	local scrollbar_uparrow_pos = CCPointMake(
		scroll_bg_size.width-_scrollbar.upbar.padding.right - 2, 
		_scrollbar.size.height-_scrollbar.upbar.padding.top + 12)
	local scrollbar_uparrow=ZImage:create(
		scroll_bg, UIPIC_DREAMLAND.scrollbar_up, 
		scrollbar_uparrow_pos.x, scrollbar_uparrow_pos.y, _scrollbar.upbar.size.width, _scrollbar.upbar.size.height)
	scrollbar_uparrow:setAnchorPoint(1, 1)

	local scrollbar_downarrow_pos = CCPointMake(
		scroll_bg_size.width-_scrollbar.downbar.padding.right - 2, 
		_scrollbar.downbar.padding.bottom - 12)
	local scrollbar_downarrow=ZImage:create(
		scroll_bg, UIPIC_DREAMLAND.scrollbar_down, 
		scrollbar_downarrow_pos.x, scrollbar_downarrow_pos.y, _scrollbar.downbar.size.width, _scrollbar.downbar.size.height)
	scrollbar_downarrow:setAnchorPoint(1, 0)


	local function scrollfun(eventType, arg, msgid)
		if eventType == nil or arg == nil or msgid == nil then
			return false
		end
		local temparg = Utils:Split(arg,":")
		local row = temparg[1]	--行数
		
		if eventType == TOUCH_BEGAN then
			return true
		elseif eventType == TOUCH_MOVED then
			return true
		elseif eventType == TOUCH_ENDED then
			return true
		elseif eventType == SCROLL_CREATE_ITEM then
			
			local cell = self:get_scroll_cell( row ,scene_id);
			self.scroll:addItem(cell); 
			self.scroll:refresh()

			return true
		end
	end
	self.scroll:registerScriptHandler(scrollfun)
	self.scroll:refresh()

	

end

-- 生成可点击的点
function CurrentMapPage:create_point( layer, p_x, p_y, entity_name,file_w, file_h, filename, layout, func,is_npc )

	local monster_point = TextButton:create(nil, p_x, p_y, file_w, file_h, nil, {filename, filename});
	monster_point.view:setAnchorPoint(0.5,0.5)
	monster_point:setTouchClickFun(func);
	layer:addChild(monster_point.view);
	local lab = nil
	local lab_name = entity_name
	if is_npc then
		lab_name = Utils:parseNPCName(entity_name)
	end

	-- 名字
	if layout == 1 then 
		-- 右边
		lab = UILabel:create_lable_2(lab_name, 15, 0, 14, ALIGN_LEFT );
		monster_point.view:addChild(lab);
	elseif layout == 2 then
		-- 下边
		lab = UILabel:create_lable_2(lab_name, 4, -15, 14, ALIGN_CENTER );
		monster_point.view:addChild(lab);
	elseif layout == 3 then
		--左边
		lab = UILabel:create_lable_2(lab_name, 0, 0, 14, ALIGN_RIGHT );
		monster_point.view:addChild(lab);
	elseif layout == 4 then
		-- 上边
		lab = UILabel:create_lable_2(lab_name, 4, 15, 14, ALIGN_CENTER );
		monster_point.view:addChild(lab);
	end

	-- modify by hcl on 2013/11/20
	if is_npc then 
		self:create_npc_func_img( _scene_id,entity_name,lab ,layout)
	end

	
	
	local fbdata = FubenConfig:get_fuben_by_name(entity_name)

	if fbdata then
		local player = EntityManager:get_player_avatar()
		local enter_times, max_tiems = ActivityModel:get_enter_fuben_count( fbdata.fbid ) 
		if player and max_tiems > enter_times and player.level >= fbdata.minLevel then
			local c = CCSprite:spriteWithFile("nopack/task/npc_state1.png")
			c:setAnchorPoint(CCPointMake(0.5,0.5))
			c:setScale(0.5)
			c:setPosition(CCPointMake(6,24))

			monster_point.view:addChild(c)
		end
		lab:setColor('0xff64ffff')
	end

	local Quest_NPC = self.Quest_NPC[entity_name]
	if Quest_NPC then
		local c = CCSprite:spriteWithFile("nopack/task/npc_state" .. tonumber(Quest_NPC) ..".png")
		c:setAnchorPoint(CCPointMake(0.5,0.5))
		c:setScale(0.5)
		c:setPosition(CCPointMake(6,24))
		monster_point.view:addChild(c)
		lab:setColor('0xffffff64')
	end

end

--创建小地图上的可点击实体
function CurrentMapPage:create_map_entity( layer )
  
	--小地图的大小
	local layer_size = layer:getSize();
	
	--可接
	self.Quest_NPC = {}
	local tab_kejie_tasks,kejie_task_num = TaskModel:get_kejie_tasks_list()
	for k,v in pairs(tab_kejie_tasks) do
		local quest = TaskModel:get_info_by_task_id(v)
		if quest.prom.npc then
			self.Quest_NPC[quest.prom.npc] = 1
		end
	end

	--已接任务
	local tab_yijie_tasks,yijie_task_num = TaskModel:get_yijie_tasks_list()
	for k,quest_id in pairs(tab_yijie_tasks) do
		local quest = TaskModel:get_info_by_task_id(quest_id)
        -- 判断任务是否完成

        -- 当前进度值
        local curr_process_value = TaskModel:get_process_value(quest_id);
        if ( curr_process_value == nil ) then
            curr_process_value = 0;
        end

        local tab_target = quest.target;
        if type(tab_target) == 'table' then
	        local target_struct = tab_target[1];
	        if not target_struct or ( curr_process_value >= target_struct.count ) then
				if quest.comp.npc then
					self.Quest_NPC[quest.comp.npc] = 2
				end
			else
				if quest.comp.npc then
					self.Quest_NPC[quest.comp.npc] = 3
				end
			end
		end
	end

	--怪物点
	if _monster_dict ~= nil then
		for i,monster in ipairs(_monster_dict) do

			local function monster_func(  )
				-- print("寻路到", _monster_dict[i].entityid,MonsterConfig:get_monster_by_id(monster.entityid ).name,"使用筋斗云",self.is_use_jingdouyun);
				
				if MiniMapModel:get_teleport_selected() then 
					
					if SceneManager:get_cur_scene() ~= 1128 then
						-- 八卦地宫不能传送
						GlobalFunc:teleport_to_target_scene( _scene_id, monster.mapx2, monster.mapy2 ); 
					else
						GlobalFunc:create_screen_notic( LangGameString[1554] ); -- [1554]="当前场景不能速传"
					end

				else

					GlobalFunc:move_to_target_scene( _scene_id, monster.mapx2 * 32, monster.mapy2 * 32);
				end

				return true;
			end	

			local p_x = ( monster.mapx2 * 32 - 32/2 ) * _scene_scale;
			--从大地图的左上角原点 转化为 小地图的左下角原点
			local p_y = layer_size.height - ( monster.mapy2 * 32 - 32/2 ) * _scene_scale;
			
			local mons = MonsterConfig:get_monster_by_id(monster.entityid );
			
			-- 怪物阵名字的layout，可指定名字是 居圆点的左、右、上、下4个布局
			local layout = 1;
			if monster.layout ~= nil then
				layout = monster.layout;
			end	
			self:create_point(layer,p_x,p_y, mons.name, 14, 14, "ui2/minimap/map_crr.png", layout, monster_func);		
		end
	end

	--npc点
	if _npc_dict ~= nil then
		for i,npc in ipairs(_npc_dict) do
			local function npc_func(  )
				
				if MiniMapModel:get_teleport_selected() then
					if SceneManager:get_cur_scene() ~= 1128 then
						--八卦地宫不能传送
						GlobalFunc:teleport( _scene_id, npc.name )
					else
						GlobalFunc:create_screen_notic( LangGameString[1554] ); -- [1554]="当前场景不能速传"
					end
		    		
		    	else 
		    		GlobalFunc:ask_npc( _scene_id, npc.name );
	    		end
				return true;
			end	

			local p_x = ( npc.posx * 32 - 32/2 ) * _scene_scale;
			--从大地图的左上角原点 转化为 小地图的左下角原点
			local p_y = layer_size.height - ( npc.posy * 32 - 32/2 ) * _scene_scale;
			-- npc名字的layout，可指定名字是 居圆点的左、右、上、下4个布局
			local layout = 1;
			if npc.layout ~= nil then
				layout = npc.layout;
			end	
			self:create_point(layer,p_x,p_y, npc.name, 14, 14, "ui2/minimap/map_crg.png",layout, npc_func,true);

		end
	end
	
	--传送阵点
	if _teleport_dict ~= nil then 
		for i,teleport in ipairs(_teleport_dict) do
			
			local function teleport_func(  )
				-- print("寻路到", _teleport_dict[i].modelid, teleport.name,"使用筋斗云",self.is_use_jingdouyun);
				if MiniMapModel:get_teleport_selected() then 
					
					if SceneManager:get_cur_scene() ~= 1128 then
						-- 八卦地宫不能传送
						GlobalFunc:teleport_to_target_scene( _scene_id, teleport.posx, teleport.posy ); 
					else
						GlobalFunc:create_screen_notic( LangGameString[1554] ); -- [1554]="当前场景不能速传"
					end
				else
					GlobalFunc:move_to_target_scene( _scene_id, teleport.posx * 32, teleport.posy * 32 );
				end
				return true;
			end	

			local p_x = ( teleport.posx * 32 - 32/2 ) * _scene_scale;
			--从大地图的左上角原点 转化为 小地图的左下角原点
			local p_y = layer_size.height - ( teleport.posy * 32 - 32/2 ) * _scene_scale;

			-- 传送阵名字的layout，可指定名字是 居圆点的左、右、上、下4个布局
			local layout = 2;
			if teleport.layout ~= nil then
				layout = teleport.layout;
			end	
			self:create_point(layer,p_x,p_y, teleport.name, 9, 16, "ui2/minimap/map_blue.png", layout, teleport_func);
			-- print("创建了小地图上的传送阵",teleport.name);
		end
	end
end

--创建小地图上主角的头像
function CurrentMapPage:create_palyer_head( map_panel, head_icon, w_pos_x, w_pos_y )
	
	--主角头像
	self.player_head = CCZXImage:imageWithFile(0 , 0, 38, 38,head_icon);
	self.player_head:setAnchorPoint(0.5,0.5);
	map_panel:addChild(self.player_head)
	-- self.player_head:setScale(0.5);
	self:sync_player_head(w_pos_x, w_pos_y)

	if self.map_panel and self.map_panel:getSize().width >= _frame_size.width then
		-- 将主角头像置中
		local pos_x = w_pos_x * _scene_scale;
			--y轴翻转
		local pos_y = self.map_panel:getSize().height - w_pos_y * _scene_scale;

		local map_x = self.map_panel:getPositionS().x;
		local map_y = self.map_panel:getPositionS().y;

		if pos_x < _frame_size.width/2 then
			-- 地图最左边
			map_x = 0;
		elseif pos_x > self.map_panel:getSize().width - _frame_size.width/2 then
			-- 地图最右边
			map_x = - (self.map_panel:getSize().width - _frame_size.width);
		else
			map_x = -pos_x + _frame_size.width/2;
		end
		if self.map_panel:getSize().height < _frame_size.height then
			-- 当地图的高度小于scrollView的高度，这种情况一般是新手村这种比例严重失衡的地图出现
			-- 这种情况下，y轴坐标不需处理,保持居中
		else
			if pos_y < _frame_size.height/2 then
				-- 地图最下边
				map_y = 0;
			elseif pos_y > self.map_panel:getSize().height - _frame_size.height/2 then
				-- 地图最上边
				map_y = -(self.map_panel:getSize().height - _frame_size.height);
			else
				map_y = -pos_y + _frame_size.height/2;
			end
		end
		
		self.map_panel:setPosition(map_x,map_y);
	end
end

-- 同步小地图上主角的头像
function CurrentMapPage:sync_player_head( w_pos_x, w_pos_y )

	if self.player_head ~= nil then 
		-- print("主角坐标",w_pos_x,w_pos_y)
		local pos_x = w_pos_x * _scene_scale;
		--y轴翻转
		local pos_y = self.map_panel:getSize().height - w_pos_y * _scene_scale;

		if _player_curr_pos.x == pos_x and _player_curr_pos.y == pos_y then 
		else
			self.player_head:setPosition(pos_x,pos_y);
		end

		
		-- --将世界像素坐标转化成世界逻辑坐标
		-- if self.coordinate then
		-- 	local tile_x,tile_y = SceneManager:pixels_to_tile( w_pos_x, w_pos_y );
		-- 	self.coordinate:setText(string.format("#cff66cc坐标：%d,%d",tile_x,tile_y));
		-- end

	end
end

-- 创建小地图
function CurrentMapPage:create_mini_map(parentpanel)
	--边框
	local parentsize = parentpanel:getSize()
	local frame_padding={left=10, top=2, right=10, bottom=2}	
	_frame_size=CCSize(
        parentsize.width-frame_padding.left-frame_padding.right,
        parentsize.height-frame_padding.top-frame_padding.bottom)
	local frame_pos = CCPointMake(frame_padding.left, frame_padding.bottom)
	self.frame_view = CCScrollView:scrollWithFile(frame_pos.x,frame_pos.y,_frame_size.width,_frame_size.height)
	self.frame_view:setLimitSize(1);
	self.frame_view:setAnchorPoint(0,0);
	parentpanel:addChild(self.frame_view)

	--边框的中点坐标
	--local frame_view_ceneter = {x=frame_width/2,y=frame_height/2};

	--地图
	local map_width = _mini_map_info.width * _mini_map_info.scale;
	local map_height =  _mini_map_info.height * _mini_map_info.scale;

	--大地图与小地图的比例
	_scene_scale =  map_width / _scene_size.width ;

	self.map_panel = CCBasePanel:panelWithFile(0, 0, map_width, map_height, nil);

	self.map_panel:setAnchorPoint(0,0)
	self.frame_view:addItem(self.map_panel);


	-- 地图内容视图
	self.map_sp = ZXMiniMap:createWithFile("nopack/MiniMap/".._scene_mapfile..".jpg", _mini_map_info.scale);
	self.map_sp:setAnchorPoint(CCPointMake(0,0));
	self.map_panel:addChild(self.map_sp);

	ZXLog('----------ss---------',self.map_sp:getContentSize().width,self.map_sp:getContentSize().height)

	-- 创建地图上的可点击实体
	self:create_map_entity( self.map_panel );

	-- 创建地图上，主角的头像
	local player = EntityManager:get_player_avatar( )
	--
	-- local head_icon = "ui2/minimap/map_head.png"
	local head_icon = UIResourcePath.FileLocate.lh_normal .. "head/head"..player.job..player.sex..".png";
	self:create_palyer_head( self.map_panel, head_icon, player.x, player.y )


	local function touch_event( eventType,arg,msgid, selfItem )
		if eventType == nil or arg == nil or msgid == nil or selfItem == nil then
			return
		end
		local x, y;
		if arg ~= nil then
			  
			local temparg = Utils:Split(arg,":")
			x = temparg[1]	--x坐标
			y = temparg[2]	--y坐标
			
		end

		if eventType == TOUCH_CLICK then
			--将坐标从frame_view的坐标系转化成map坐标
			local function map_position_to_logic_position(f_pos_x, f_pos_y )

				local pos = self.map_panel:getPositionS();

				f_pos_x = f_pos_x - pos.x; --补上地图位移的偏差
				f_pos_y = f_pos_y - pos.y; --

				local w_pos_x = f_pos_x / _scene_scale;
				-- 游戏坐标系与 触摸坐标系的y轴是反转的
				local w_pos_y = (self.map_panel:getSize().height - f_pos_y) / _scene_scale;
				return SceneManager:pixels_to_tile( w_pos_x, w_pos_y );
			end
			
			local logic_pos_x, logic_pos_y = map_position_to_logic_position(x, y);
			
			self:update_coordinate_indicator( x,y );

			if MiniMapModel:get_teleport_selected() then 
				if SceneManager:get_cur_scene() ~= 1128 then
					-- 八卦地宫不能传送
					GlobalFunc:teleport_to_target_scene( _scene_id, logic_pos_x, logic_pos_y ); 
				else
					GlobalFunc:create_screen_notic( LangGameString[1554] ); -- [1554]="当前场景不能速传"
				end
			else
				print("点击了地图坐标:",x, y, "逻辑坐标", logic_pos_x, logic_pos_y);
				GlobalFunc:move_to_target_scene( _scene_id, logic_pos_x*32, logic_pos_y*32 );
			end
		end

		return true;
	end

	self.map_panel:registerScriptHandler(touch_event);


end

function CurrentMapPage:update_coordinate_indicator( x,y )
	
	local pos = self.map_panel:getPositionS();
	x = x - pos.x; --补上地图位移的偏差
	y = y - pos.y; --

	if self.indicator_sp == nil then
		local action = {0,0,7,0.2};
		self.indicator_sp = MUtils:create_animation(x,y,"frame/effect/jm/37",action );
		self.map_panel:addChild(self.indicator_sp,0);
	else
		self.indicator_sp:setPosition(x,y);
	end

	

end




-------------------------- update

function CurrentMapPage:sync_player_position( tile_x,tile_y )
	


end


