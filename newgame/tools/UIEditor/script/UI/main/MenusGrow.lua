-- MenusGrow.lua
-- 成长之路面板
-- 按钮的添加方式与功能菜单相似
-- 配置文件:menus_grow
super_class.MenusGrow(NormalStyleWindow)

local title_text = {UILH_TARGET.text1, UILH_TARGET.text2, UILH_TARGET.text3}
local title_img = {UILH_TARGET.icon1, UILH_TARGET.icon2, UILH_TARGET.icon3}
-- 处理配表信息，把配表中已开放的项目信息提取出来
local function get_curr_page_info( pram_t)
   local t = {}
   for i, tab in ipairs(pram_t) do
   		local e_t = {}
   		for _, item in ipairs(tab or {}) do
	        if item.openType == 0 then 
	            table.insert(e_t,item)
	        elseif item.openType == 1 then 
	            if GameSysModel:isSysEnabled( item.value, false) then
	                table.insert(e_t,item)
	            end
	        elseif item.openType == 2 then 
	            if EntityManager:get_player_avatar().level >= item.value then 
	                table.insert(e_t,item)
	            end
	        end
	    end
	    table.insert(t, e_t)
   end
   return t
end

function MenusGrow:create_one_panel(x, y, width, height, index)
	local panel = CCBasePanel:panelWithFile(x, y, width, height, "", 500, 500)
    local bg_left = ZImage:create(panel, "nopack/BigImage/target_bg.png", 0, 0, -1, -1)
    local bg_right = ZImage:create(panel, "nopack/BigImage/target_bg.png", 143, 0, -1, -1)
    bg_right.view:setFlipX(true)
    local frame = ZImage:create(panel, UILH_TARGET.frame, 50, 385, -1, -1)
    local frame_text = ZImage:create(frame.view, title_text[index], 74, 133, -1, -1)
    local frame_img = ZImage:create(frame.view, title_img[index], 55, 30, -1, -1)
	self.grow_config_info = get_curr_page_info(self.grow_config)
	local btns_info = self.grow_config_info[index]
	if btns_info and #btns_info > 0 then
		local maxnum = math.ceil(#btns_info/2);
		local _scroll_info = { x = 10, y = 10, width = width-20, height = height-180, maxnum = maxnum, stype = TYPE_HORIZONTAL }
	    local scroll = CCScroll:scrollWithFile( _scroll_info.x, _scroll_info.y, _scroll_info.width, _scroll_info.height, _scroll_info.maxnum, "", _scroll_info.stype )
	    panel:addChild(scroll);
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

	            local row = temparg[1] +1             -- 行
	            local beg_y = 300
	            local sub_panel = CCBasePanel:panelWithFile(0,0,260,90,nil,0,0);
	            scroll:addItem(sub_panel);
	            self:create_scroll_item(row, sub_panel, index);
	        	scroll:refresh();
	            return false
	        end
	    end
	    scroll:registerScriptHandler(scrollfun);
	    scroll:refresh()
	end
	return panel
end

function MenusGrow:__init( ... )
	local panel = self.view
	self.grow_config_info = {}
    self._instruction_components = {}

    -- 成长之路按钮 表(tabel)
    self.numtip_t = {}

	-- ZImage:create(self.view,UILH_COMMON.bg_grid, 10, 10, 882, 565, 0, 500, 500);
	require "../data/menus_grow"
	self.grow_config = grow_config
	local beg_x = 17
	local beg_y = 17
	local int_w = 288
	for i = 1, 3 do
		local temp = self:create_one_panel(beg_x + int_w*(i-1), beg_y, int_w, 550, i)
		panel:addChild(temp)
	end
end

function MenusGrow:create_scroll_item(row, parent, type)
	for i = 1, 2 do
		local index = (row-1)*2 + i;
        if index > #self.grow_config_info[type] then return end
        local btn_t = {}
        local btn_info = self.grow_config_info[type][index]
        local menus_name = btn_info.name;
        local function btn_fun(eventType,x,y)
            if eventType == TOUCH_CLICK then
                Instruction:handleUIComponentClick(instruct_comps.MENU_GROW_WIN_BASE + type*100 + btn_info.idx)
                self:do_btn_function( menus_name );
            end
            return true
        end
        local  pos_x = (i-1) * 115 + 40
        local  pos_y = ( 90 - 70 ) / 2

        local str = string.format(UIResourcePath.FileLocate.lh_mainmenu ..menus_name..".png",index);
        local btn = MUtils:create_btn(parent,UILH_MAINMENU.bg,UILH_MAINMENU.bg,btn_fun,pos_x, pos_y,70,70)
    
        MUtils:create_sprite(btn,str,35,35)
        self._instruction_components[instruct_comps.MENU_GROW_WIN_BASE + type*100 + btn_info.idx] = { view = btn, name=menus_name }
	end
end

function MenusGrow:active( show)
	if show then
        DouFaTaiCC:req_get_info()                   -- 成长之路点将台(数字角标)
	end
end

function MenusGrow:find_component(id)
    return self._instruction_components[id]
end

function MenusGrow:do_btn_function( menus_name )
	
    Instruction:handleUIComponentClick(menus_name)

	UIManager:hide_window("menus_panel_t");
	if(menus_name == "duihuan") then
        UIManager:show_window("exchange_win");
    elseif(menus_name == "meirenchouka") then
    	UIManager:show_window("beauty_card_win");
	elseif(menus_name == "linggen") then 
        LingGen:show();
	elseif(menus_name == "chengjiu") then
        UIManager:show_window("achieve_win"); 
	elseif(menus_name == "zhaocai") then   
		Analyze:parse_click_main_menu_info(260)  
        -- 招财进宝
        UIManager:show_window("zhaocai_win")
	elseif(menus_name == "dujie") then 
        --DouFaTaiWin:show();
        Analyze:parse_click_main_menu_info(254)
        if ( GameSysModel:isSysEnabled(GameSysModel.DJ) ) then 
            UIManager:show_window("dujie_win");
        end
	elseif(menus_name == "bangdan") then
        UIManager:show_window("top_list_win")
    elseif menus_name == "fabao" then
       if (GameSysModel:isSysEnabled(GameSysModel.GEM)) then
           UIManager:show_window("lingqi_win");
       end
    elseif menus_name == "doufatai" then
    	Analyze:parse_click_main_menu_info(258)
        DouFaTaiWin:show();
    elseif menus_name == "paohuan" then
        PaoHuanWin:show();
    elseif menus_name == "marriage" then
        if (GameSysModel:isSysEnabled(GameSysModel.MARRY)) then
            UIManager:show_window("marriage_win_new");
        end
    elseif menus_name == "xiandaohui" then
    	local player = EntityManager:get_player_avatar();
    	if(player ~= nil and player.level ~= nil and player.level >= 40 ) then
            XianDaoHuiWin:show();
        else
        	NormalDialog:show(Lang.xiandaohui[45]); -- [45] = "群雄争霸必须达到40级才可以参与！",
        end
    elseif menus_name == "zhenyaota" then
        --镇妖塔
        ZhenYaoTaModel:show_window(  )
    elseif menus_name == "juxianling" then
    	UIManager:show_window("juxianling_win")
    end
    
end

-- 添加数字角标 
function MenusGrow:add_num_tip( menus_name, num )


	for k,v in pairs(self.numtip_t) do 
		if v.name == menus_name then
			v.view:removeFromParentAndCleanup(true)
			v.view = nil
			v.name = nil
			v = nil
		end
	end

	if num == 0 then
		return 
	end

	for k, v in pairs(self._instruction_components) do
		if v.name == menus_name then
			local num_temp = #self.numtip_t
			self.numtip_t[num_temp+1] = {}
			self.numtip_t[num_temp+1].name = menus_name
			self.numtip_t[num_temp+1].view = CCBasePanel:panelWithFile(35, 35, -1, -1, UILH_MAIN.remain_bg)
			v.view:addChild(self.numtip_t[num_temp+1].view)

			local num_tip = ZXLabelAtlas:createWithString( num, "ui/lh_other/tip_num_" )
			if num > 9 then
		    	num_tip:setPosition(CCPointMake( 7, 12))
		    else
		    	num_tip:setPosition(CCPointMake( 15, 12))
		    end
		    num_tip:setAnchorPoint( CCPointMake(0, 0) )
		    self.numtip_t[num_temp+1].view:addChild( num_tip )
		end
	end
end

function MenusGrow:destroy( )
	Window.destroy(self);
end