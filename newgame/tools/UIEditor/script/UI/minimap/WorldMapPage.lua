-- WorldMapPage.lua
-- create by hcl on 2012-12-10
-- 世界地图页

super_class.WorldMapPage()

-- 总面板
local basePanel = nil;

-- 左边距
local l_m = 85;
-- 下边距
local b_m = 77;


-- 用户头像
local spr_user_head = nil;

local tab_scene = { [1] = 5, [2] = 4, [3] = 1, [4] = 7,
                    [5] = 13, [6] = 11, [7] = 3, [8] = 6,
                    [9] = 9, [10] = 10, [11] = 2 };

local area_id = {
    [1]  = 7,   [2]  = 10,  -- 西河郡, 安息国
    [3]  = 8,    [4]  = 4,  -- 罗马军营，白戎祖地
    [5]  = 6,    [6]  = 5,  -- 乌垒城，楼兰废墟
    [7]  = 3,   [8]  = 15,  -- 雁门关，夜郎古城
    [9]  = 9,   [10] = 11,  -- 荒山石窟，秦皇陵
    [11] = 2,   [12] = 14,  -- 潺夜古城，乌兹古城
}

local not_open_scene = {[17] = true, [18] = true, [19] = true, [20] = true}

local area_size = {
    {85, 85}, {85, 85},  -- 西河郡, 安息国
    {85, 85}, {85, 85},  -- 罗马军营，白戎祖地
    {85, 85}, {85, 85},  -- 乌垒城，楼兰废墟
    {120, 120}, {85, 85},  -- 雁门关，夜郎古城
    {85, 85}, {85, 85},  -- 荒山石窟，秦皇陵
    {85, 85}, {85, 85},  -- 潺夜古城，乌兹古城
}

-- local area_size = {
--     {-1, -1},{-1, -1},
--     {-1, -1},{-1, -1},
--     {-1, -1},{-1, -1},
--     {-1, -1},{-1, -1},
--     {-1, -1},{-1, -1},
--     {-1, -1},{-1, -1},
-- }

local area_pos = {
    {246, 322}, {88, 185},  -- 西河郡, 安息国
    {497, 361}, {202, 96},  -- 罗马军营，白戎祖地
    {284, 225}, {547, 255},  -- 乌垒城，楼兰废墟
    {395, 148}, {580, 92},  -- 雁门关，夜郎古城
    {726, 388}, {79, 326},  -- 荒山石窟，秦皇陵
    {674, 174}, {440, 31},  -- 潺夜古城，乌兹古城
}

--地区对应的等级
local lv_img = {
    [1] = "ui2/minimap/lv3.png", [2] = "ui2/minimap/lv6.png",
    [3] = "ui2/minimap/lv4.png", [4] = "ui2/minimap/lv2.png",
    [5] = "ui2/minimap/lv2.png", [6] = "ui2/minimap/lv2.png",
    [8] = "ui2/minimap/lv1.png",
    [9] = "ui2/minimap/lv5.png", [10] = "ui2/minimap/lv7.png",
    [11] = "ui2/minimap/lv1.png", [12] = "ui2/minimap/lv1.png",
}
-- 根据场景id，获取area_pos中这个场景的图标坐标
local function get_map_pos_by_scene_id( scene_id )
    for i,v in ipairs(area_id) do
        if v == scene_id then
            return area_pos[i][1], area_pos[i][2];
        end
    end
    return ;
end

-- 根据获取 (移动)前往的场景的出现坐标，需要根据当前所在场景来查找
local function get_to_scene_pos( cur_scene_id, to_scene_id )
   
    local scene = SceneConfig:get_scene_by_id( cur_scene_id )
    
    for i,teleport in ipairs(scene.teleport) do
        if teleport.toSceneid == to_scene_id then
            return teleport.toPosx,  teleport.toPosy;
        end
    end

    return;
end

-- 根据获取 (飞筋斗云)前往的场景的出现坐标
local function get_to_scene_area_center( to_scene_id )
    
    local scene = SceneConfig:get_scene_by_id( to_scene_id )
    local area = scene.area[1];

    return area.center[1], area.center[2];

end

function WorldMapPage:destroy( )
    
end

function WorldMapPage:__init(parentpanel)
    local parentsize = parentpanel:getSize()
    local basePanel_padding={left=9, top=7, right=9, bottom=7}
    local basePanel_size=CCSize(
        parentsize.width-basePanel_padding.left-basePanel_padding.right,
        parentsize.height-basePanel_padding.top-basePanel_padding.bottom)
    local basePanel_pos=CCPointMake(basePanel_padding.left, basePanel_padding.bottom)
    --local basePanel_pos=CCPointMake(basePanel_size.width/2, basePanel_size.height-basePanel_padding.top)
    basePanel = CCBasePanel:panelWithFile(basePanel_pos.x,basePanel_pos.y,basePanel_size.width,basePanel_size.height,nil,0,0);
    --basePanel:setAnchorPoint(0.5, 1)
    local function panel_fun(eventType,x,y)
        if eventType == TOUCH_CLICK then
            return false;
        end
        return true
    end

    basePanel:registerScriptHandler(panel_fun);
    self.view = basePanel;

    local spr_padding={left=2, top=2, right=2, bottom=2}
    local spr_size = CCSize(
        basePanel_size.width-spr_padding.left-spr_padding.right,
        basePanel_size.height-spr_padding.top-spr_padding.bottom)
    local spr_pos = CCPointMake(basePanel_size.width/2, basePanel_size.height-spr_padding.top)

    local spr = MUtils:create_zximg(basePanel,UILH_MAP.map_world,spr_pos.x,spr_pos.y,spr_size.width,spr_size.height,0,0);
    spr:setAnchorPoint(0.5, 1)

    local base_map_path = "ui2/minimap/map_";
    -- 为了给37wan看包，暂时屏蔽
    for i=1, #area_pos do

        local function btn_fun(eventType, args, msg_id)
            if eventType == TOUCH_CLICK then
                
                if SceneManager:get_cur_scene() ~= 1128 then
                    -- 八卦地宫不能传送
                    self:move_to_map( i )
                else
                    GlobalFunc:create_screen_notic( LangGameString[1557] ); -- [1557]="在当前场景中不能前往"
                end

                return true
            end
            return true
        end

        local btn = MUtils:create_btn(basePanel, 
            base_map_path..i..".png", 
            base_map_path..i..".png", 
            btn_fun, 
            area_pos[i][1], area_pos[i][2], 
            area_size[i][1], area_size[i][2]);
        if lv_img[i] then
            local level = ZImage:create(btn, lv_img[i], -20, area_size[i][2]*0.5, -1, -1)
            level.view:setAnchorPoint(0, 0.5)
        end
    end

    -- 主角头像
    local scene_id = SceneManager:get_cur_scene();
    local pos_x, pos_y = get_map_pos_by_scene_id( scene_id )
    if pos_x ~= nil then
        -- 为了给37wan看包，暂时屏蔽头像
        -- spr_user_head = MUtils:create_zximg(basePanel,"ui2/minimap/map_head.png",pos_x+22,pos_y+43, -1, -1)--MUtils:create_sprite(basePanel,"ui2/minimap/map_head.png",0,0);
        -- spr_user_head:runAction(self:get_action());
    end
end

function WorldMapPage:move_to_map( index )
    
    local cur_scene_id = SceneManager:get_cur_scene();
    local to_scene_id = area_id[index];

    if not_open_scene[to_scene_id] then
        GlobalFunc:create_screen_notic( Lang.minimap.notopen_tip ); -- [1557]="在当前场景中不能前往"
        return
    end

    if ( cur_scene_id == to_scene_id ) then
        -- print("当前地图");
        return;
    end

    if MiniMapModel:get_teleport_selected() then
        local to_pos_x, to_pos_y = get_to_scene_area_center(to_scene_id);
        GlobalFunc:teleport_to_target_scene( to_scene_id, to_pos_x, to_pos_y ) 
    else 
        --local to_pos_x, to_pos_y = get_to_scene_pos(cur_scene_id, to_scene_id);
        -- move_to_target_scene 不传第二三参数的话就直接到达该地图后就不再移动
        GlobalFunc:move_to_target_scene( to_scene_id) 
    end
end

function WorldMapPage:get_action( )
    local array = CCArray:array();
    array:addObject(CCMoveBy:actionWithDuration(0.7,CCPoint(0,20)));
    array:addObject(CCMoveBy:actionWithDuration(0.7,CCPoint(0,-20)));
    local action_sequence = CCSequence:actionsWithArray(array);
    local action = CCRepeatForever:actionWithAction(action_sequence);
    return action;
end
