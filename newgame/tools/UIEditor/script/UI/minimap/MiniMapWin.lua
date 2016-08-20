-- MiniMapWin.lua
-- create by hcl on 2012-12-10
-- 小地图窗口

 
super_class.MiniMapWin(NormalStyleWindow)
 
local _base_size = CCSize(900, 605)
-- 子页面的table
local tab_page = {};
-- 当前选中的子面板索引
local curr_select_page_index = -1;

-- 左边距
local l_m = 19;
-- 下边距
local b_m = 39;

-- 要更新的view
local update_view = {};

-- 当前坐标
local _currentCoordinate = {x=0,y=0};

local _font_size = 16
local _font_size_s = 14
local _bg_region=nil
local _map_region=nil
local _text_color = {
    gray = "#ccdbda4",
    white = "#cffffff",
}

local temp_btn_lab={}

function MiniMapWin:destroy(  )
    for i=1,2 do
        if ( tab_page[i] ) then
            tab_page[i].view:removeFromParentAndCleanup(true);
            tab_page[i]:destroy();
            tab_page[i] = nil;
        end
    end  
    Window.destroy(self);  
    tab_page = {};
    curr_select_page_index = -1;
    update_view ={};  
    _bg_region=nil 
    _map_region=nil 
    -- for i=1, #temp_btn_lab do
    --     temp_btn_lab[i]=nil
    -- end
    temp_btn_lab={}
end

function MiniMapWin:show()
    if show == true then
        UIManager:show_window("mini_map_win");
    end
    
end

-- UIManager使用来创建
-- function MiniMapWin:create( texture_name )
-- 	--local view = PetWin("ui/common/bg02.png",20,30,760,424);
--     local view = MiniMapWin(nil,l_m,b_m,760,424);
-- 	return view;
-- end

function MiniMapWin:active( show )
     
    if show == true then
        if curr_select_page_index == 2 then 
            MiniMapModel:set_mini_map_open( true );
        end
    else
        MiniMapModel:set_mini_map_open( false );
        UIManager:destroy_window("mini_map_win");
    end
end
-- 
function MiniMapWin:__init( window_name, texture_name)
    --标题和背景框
    local bgSize = _base_size

    local bg_region_padding={left=10, top=35, right=10, bottom=10} --_bg_region包括tab和地图区域
    local bg_region_size=CCSize(
        bgSize.width-bg_region_padding.left-bg_region_padding.right,
        bgSize.height-bg_region_padding.top-bg_region_padding.bottom)
    local bg_region_pos=CCPointMake(bg_region_padding.left, bg_region_padding.bottom)
    _bg_region = CCBasePanel:panelWithFile(bg_region_pos.x, bg_region_pos.y, bg_region_size.width, bg_region_size.height, "")
    self.view:addChild(_bg_region)   

    local raido_btn_group_padding={left=15, top=0, right=0, bottom=0}
    local raido_btn_group_size=CCSize(200, 50)
    local raido_btn_group_pos=CCPointMake(raido_btn_group_padding.left, bg_region_size.height)
    local raido_btn_group = ZRadioButtonGroup:create(
        _bg_region, raido_btn_group_pos.x, raido_btn_group_pos.y, raido_btn_group_size.width, raido_btn_group_size.height )
    self.raido_btn_group = raido_btn_group
    self:create_radio_button_group(raido_btn_group);
    raido_btn_group:setAnchorPoint(0, 1)

    --local tab_size = CCSize()
    local map_region_padding={left=0, top=raido_btn_group_padding.top+raido_btn_group_size.height, right=0, bottom=0}
    local map_region_size=CCSize(
        bg_region_size.width-map_region_padding.left-map_region_padding.right, 
        bg_region_size.height-map_region_padding.top-map_region_padding.bottom)
    local map_region_pos=CCPointMake(map_region_padding.left, map_region_padding.bottom)
    _map_region = CCTouchPanel:touchPanel(
        map_region_pos.x,map_region_pos.y,map_region_size.width,map_region_size.height+7) --,UILH_COMMON.bg_02,500,500
    _bg_region:addChild(_map_region)


    local mapbg_padding={left=0, top=0, right=0, bottom=0}
    local mapbg_size=CCSize(
        map_region_size.width-mapbg_padding.left-mapbg_padding.right,
        map_region_size.height-mapbg_padding.top-mapbg_padding.bottom)
    local mapbg_pos=CCPointMake(mapbg_padding.left, mapbg_padding.bottom)
    local mapbg = CCBasePanel:panelWithFile(mapbg_pos.x, mapbg_pos.y, mapbg_size.width, mapbg_size.height+10, UILH_COMMON.normal_bg_v2, 500, 500)
    _map_region:addChild(mapbg,-1)
    --_bg_region:addChild(CCBasePanel:panelWithFile(
    --   map_region_pos.x,map_region_pos.y,map_region_size.width,map_region_size.height,UILH_COMMON.bg_04,500,500));

    -- 默认显示第二个当前地图
    raido_btn_group:selectItem(1);
    self:do_tab_button_method(2);


    -- 所在场景的名字
    self.scene_name_str = SceneConfig:get_scene_name_by_id(SceneManager:get_cur_scene(), SceneManager:get_cur_fuben())
    -- self.scene_name = MUtils:create_zxfont(self.view, "#cffff00" .. scene_name_str,458, title_pos_y,ALIGN_RIGHT,18)
    
    local player = EntityManager:get_player_avatar( )
    local tile_x,tile_y = SceneManager:pixels_to_tile( player.x, player.y );
    self.coor_str = string.format("（%d,%d）",tile_x,tile_y+1);
    -- self.coordinate = MUtils:create_zxfont(self.view, "#cffff00" .. coor_str, 458, title_pos_y,ALIGN_LEFT,17)

     --local title_pos_x = (bgSize.width -80)/2
    --local title_pos_y = bgSize.height-80-15-30
    local pos_lab_padding={top=-10}
    local pos_lab_pos=CCPointMake(map_region_size.width/2, map_region_size.height-pos_lab_padding.top)
    self.pos_lab = MUtils:create_zxfont(
        _bg_region, _text_color.gray .. self.scene_name_str .. self.coor_str, pos_lab_pos.x, pos_lab_pos.y, ALIGN_CENTER, _font_size, 99)

    -- print("------------2222---------------")
    -- local function btn_close_fun(eventType,x,y)
    --     UIManager:destroy_window("mini_map_win");
    --     --回收纹理
    --     ResourceManager:set_resource_dirty()
    --     --设置是否打开当前地图
    --     MiniMapModel:set_mini_map_open( false );
    -- end
    -- self.exit_btn:setTouchClickFun(btn_close_fun);
    -- print("------------3333---------------")
    -- 是否使用筋斗云
    local function use_jindouyun_fun()
        MiniMapModel:set_teleport_selected( not MiniMapModel:get_teleport_selected() );
    end
    
    --UIButton:create_switch_button( x, y, w, h, image_n, image_s, words, words_x, fontsize, image_n_w, image_n_h
    self.auto_telep_btn = UIButton:create_switch_button( 24, 24, 200, 45, 
        UILH_COMMON.dg_sel_1, 
        UILH_COMMON.dg_sel_2,
        LangGameString[1555], 40, 16, nil, nil, nil, nil, use_jindouyun_fun ); -- [1555]="自动传送(筋斗云个)"

    _map_region:addChild(self.auto_telep_btn.view,99);
    self.auto_telep_btn.setString(string.format(LangGameString[1556],MiniMapModel:get_jindouyun_count())); -- [1556]="自动传送(筋斗云%d个)"
    self.auto_telep_btn.set_state(MiniMapModel:get_teleport_selected())

end

--xiehande  点击按钮切换字体贴图
function MiniMapWin:change_btn_name( index )
    -- body
    local selected_tab_path = "ui2/minimap/map_t_n";
    local base_tab_path = "ui2/minimap/map_t_";
    for i,v in ipairs(self.raido_btn_group.item_group) do
        if(i==index) then
          self.raido_btn_group:getIndexItem(i-1):set_image_texture(base_tab_path..i..".png")
        else
          self.raido_btn_group:getIndexItem(i-1):set_image_texture(selected_tab_path..i..".png")
        end
    end
end

function MiniMapWin:create_radio_button_group(raido_btn_group)
    
    -- local raido_btn_group = CCRadioButtonGroup:buttonGroupWithFile(24 ,480-65- b_m-9 , 190,35,nil);
    -- self.view:addChild(raido_btn_group);
    -- 宠物栏上面的6个按钮 1,宠物信息，2悟性提升，3成长提升，4技能学习，5技能刻印，6宠物融合
    local base_tab_path = "ui2/minimap/map_t_";
    local basesize=raido_btn_group:getSize()
    --local y = 402-b_m;
    for i=1,2 do
        local function btn_fun()
            self:do_tab_button_method(i);
        end
        local temp_btn = ZImageButton:create( nil, {UILH_COMMON.tab_gray,UILH_COMMON.tab_light}, nil, btn_fun)  --base_tab_path ..i .. ".png"
        raido_btn_group:addItem(temp_btn,7)
        

        local btnsize = temp_btn:getSize()
        temp_btn:setPosition(btnsize.width *(i-1), basesize.height)
        temp_btn:setAnchorPoint(0, 1)


        temp_btn_lab[i] = MUtils:create_zxfont(
            temp_btn, Lang.minimap.tab_text[i], btnsize.width/2, btnsize.height/2, ALIGN_CENTER, _font_size_s)
        temp_btn_lab[i]:setAnchorPoint(CCPointMake(0, 0.5))
        -- local function btn_fun(eventType,x,y)
        --     if eventType == TOUCH_CLICK then
        --         --按钮抬起时处理事件.
                
        --         return true;
        --     elseif eventType == TOUCH_BEGAN then
        --         self:do_tab_button_method(i);
        --         return true;
        --     elseif eventType == TOUCH_ENDED then
        --         return true;
        --     end
        -- end
        -- local x = 85*(i-1);
        -- local y = 0;
        -- local btn = MUtils:create_radio_button(raido_btn_group,UIResourcePath.FileLocate.common .. "common_tab_n.png",UIResourcePath.FileLocate.common .. "common_tab_s.png",btn_fun,x,y,-1,-1,false);
        -- if i == 1 then
        --     MUtils:create_zximg(btn,base_tab_path ..i .. ".png",4,5,79,21);
        -- else 
        --     MUtils:create_zximg(btn,base_tab_path ..i .. ".png",5,5,73,18);
        -- end
    end 
end

-- tab上button的回调
function MiniMapWin:do_tab_button_method(index)
    --print("do_tab_button_method")
    if ( curr_select_page_index == index ) then
        return;
    end


    if ( tab_page[ curr_select_page_index ] ) then
        tab_page[ curr_select_page_index ].view:setIsVisible(false);
    end
    curr_select_page_index = index;
    --self:change_btn_name(index)
	if ( curr_select_page_index == 1 ) then
		 
        MiniMapModel:set_mini_map_open( false )

        if ( tab_page[curr_select_page_index] ) then
            tab_page[curr_select_page_index].view:setIsVisible(true);
        else
            --世界地图
            -- local map_region_size = _map_region:getContentSize() 
            -- print("_map_region1 ", _map_region)
            -- print("map_region_size1 ", map_region_size.x, map_region_size.y)
            tab_page[curr_select_page_index] = WorldMapPage(_map_region)
            _map_region:addChild(tab_page[curr_select_page_index].view);
        end

        temp_btn_lab[1]:setText(_text_color.white .. Lang.minimap.tab_text[1])
        temp_btn_lab[2]:setText(_text_color.gray .. Lang.minimap.tab_text[2])

	elseif ( curr_select_page_index == 2 ) then
 
        MiniMapModel:set_mini_map_open( true )

    	if (tab_page[curr_select_page_index]) then 
            tab_page[curr_select_page_index].view:setIsVisible(true);
        else
            --小地图
            local scene_id = SceneManager:get_cur_scene();

            -- local map_region_size = _map_region:getSize() 
            -- print("_map_region2 ", _map_region)
            -- print("map_region_size2 ", map_region_size.x, map_region_size.y)
            tab_page[curr_select_page_index] = CurrentMapPage(_map_region, scene_id);
            _map_region:addChild(tab_page[curr_select_page_index].view);
        end
        temp_btn_lab[2]:setText(_text_color.white .. Lang.minimap.tab_text[2])
        temp_btn_lab[1]:setText(_text_color.gray .. Lang.minimap.tab_text[1])
	end
end



-----------------------------------界面更新
-- 同步小地图上主角的坐标
function MiniMapWin:sync_player_position( w_pos_x,w_pos_y )
    
    if _currentCoordinate.x == w_pos_x and _currentCoordinate.y == w_pos_y then
    else 
        local tile_x,tile_y = SceneManager:pixels_to_tile( w_pos_x, w_pos_y );
        -- self.coordinate:setText(string.format("(%d,%d)",tile_x,tile_y));
        self.coor_str = string.format("（%d,%d）",tile_x,tile_y)
        self.pos_lab:setText(_text_color.gray .. self.scene_name_str .. self.coor_str)
        _currentCoordinate.x = w_pos_x;
        _currentCoordinate.y = w_pos_y;
    end
    
    if curr_select_page_index == 2 then

        local currenMapPage = tab_page[curr_select_page_index];
        if currenMapPage ~= nil then 
            currenMapPage:sync_player_head(w_pos_x, w_pos_y );
        end
         
    end

end

-- npc的任务状态
function MiniMapWin:do_npc_task_status( scene_id, npcs  )
    if curr_select_page_index == 2 then
        local currenMapPage = tab_page[curr_select_page_index];
        if currenMapPage ~= nil then 
            currenMapPage:do_npc_task_status( scene_id, npcs );
        end
    end
end


-- 更新筋斗云的消耗

function MiniMapWin:update_auto_telep_btn(  )
    print("更新筋斗云的消耗");
    if self.auto_telep_btn then
        self.auto_telep_btn.setString(string.format(LangGameString[1556],MiniMapModel:get_jindouyun_count())); -- [1556]="自动传送(筋斗云%d个)"
    end
end
