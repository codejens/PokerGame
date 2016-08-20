-- AchieveDetailsPage.lua
-- created by charles on 2013-1-5
-- 成就详细信息页面

-- require "UI/component/Window"
super_class.AchieveDetailsPage(Window)

-- require "../data/std_achieves"
--require "../data/client_global_config"

local _groupId = 1; -- 显示的分组ID
local _panel;
local _scroll;

--创建右侧物品栏的一个item 和 信息。因为和左侧物品处理方式不一样，要分开写一个方法。
--参数：父panel、物品id（当使用默认图标时，使用nil）、坐标、大小、num表示等级或者数量
local function create_item_right( index )
    local panel = CCBasePanel:panelWithFile(0, 0, 855, 125, "", 500, 500)
    local panel_bg = ZImage:create(panel, UILH_COMMON.bottom_bg, 5, 0, 840, 125, nil, 500, 500)
	local achieveId = GlobalConfig:get_achieve_group(_groupId)[index];
    local std_achieve = AchieveConfig:get_achieve( achieveId )
	require "UI/component/SlotBase"
    require "utils/UI/UILabel"
    local slot_bg = ZImage:create(panel, UILH_NORMAL.light_grid, 20, 15, -1, -1)
    local slot = SlotBase(64, 64);
    slot_bg.view:addChild(slot.view)

    --slot.view:setTexture("ui/common/bg_06.png")
    slot:set_icon_bg_texture(UILH_COMMON.slot_bg, -11, -11, 86, 85 )   -- 背框
    slot:set_icon_texture( string.format("icon/achieve/%05d.pd",  std_achieve.icon or 2) );
    --slot:set_icon_texture( string.format("icon/achieve/%05d.png",  std_achieve.icon or 2) );
    -- slot:set_icon_size(72, 72);
    slot.icon:setScale(1.15)
    -- slot.icon:setPosition(35, 46);
    slot:setPosition(15, 15)
    
    local dimensions = CCSize(600,15)
    local label = UILabel:create_label_1(std_achieve.name, dimensions, 420 , 95,  17, CCTextAlignmentLeft, 216, 138, 0)
    panel:addChild( label );

    label = UILabel:create_label_1(Lang.achieve.detail[1].. std_achieve.desc, dimensions, 420, 65, 16, CCTextAlignmentLeft, 54, 172, 208) -- [533]="成就目标："
    panel:addChild( label );

    label = UILabel:create_label_1(Lang.achieve.detail[2]..AchieveModel:getAwardPoint(std_achieve), dimensions, 420, 35, 16, CCTextAlignmentLeft, 54, 172, 208) -- [534]="成就奖励：成就点+"
    panel:addChild( label );
    local progress = nil
    -- print("AchieveModel:getUserAchieve( achieveId ).hasDone achieveId",AchieveModel:getUserAchieve( achieveId ).hasDone,achieveId)
    if AchieveModel:getUserAchieve( achieveId ).hasDone > 0 then
        progress = MUtils:create_progress_bar(610, 15, 212, 16, UILH_NORMAL.progress_bg2, UILH_NORMAL.progress_bar_orange, 100, {14}, {1,1,1,1}, true)
        progress.set_max_value(AchieveModel:getAchieveTargetCount( achieveId ))
        progress.set_current_value(AchieveModel:getAchieveTargetCount( achieveId ))
    else
        progress = MUtils:create_progress_bar(610, 15, 212, 16, UILH_NORMAL.progress_bg2, UILH_NORMAL.progress_bar_orange, 100, {14}, {1,1,1,1}, true)
        progress.set_max_value(AchieveModel:getAchieveTargetCount( achieveId ))
        progress.set_current_value(AchieveModel:getUserAchieveProgress( achieveId ))
    end
    panel:addChild(progress.view);

    --MUtils:create_zximg(slot.view,UIResourcePath.FileLocate.common .. "fenge_bg.png", 12,0,740,2,1,0);

    return panel;
end

local function create_scroll( self )
	if _scroll then
		_panel:removeChild( _scroll, true );
	end

	--_scroll = CCScroll:scrollWithFile(0, 0, 700, 310, 4, 1, #client_global_config.achieveDisplayOrder[_groupId], nil, TYPE_VERTICAL, 500, 500);
    --_scroll:setEnableCut(true);
    local temp_info = GlobalConfig:get_achieve_group(_groupId)
    _scroll = CCScroll:scrollWithFile( 10, 15, 855, 487, #temp_info, "", TYPE_HORIZONTAL, 600, 600)
    _scroll:setScrollLump(UILH_COMMON.up_progress, UILH_COMMON.down_progress, 10, 30, 502)
    _scroll:setScrollLumpPos(848)
    local arrow_up = CCZXImage:imageWithFile(858, 492, 10, -1 , UILH_COMMON.scrollbar_up, 500, 500)
    local arrow_down = CCZXImage:imageWithFile(858, 14, 10, -1, UILH_COMMON.scrollbar_down, 500 , 500)

    local function scrollfun(eventType, args, msg_id)
        if (eventType or args or msg_id) == nil then 
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
            --local index = y + 1;
            local index = x + 1
    	    local bg = create_item_right( index );
            -- local bg = CCBasePanel:panelWithFileS(CCPointMake(6,0), CCSizeMake(810, 100), "")
            -- bg:addChild(slot.view);
            _scroll:addItem(bg);
            _scroll:refresh();
            return false
        end
    end
    _scroll:registerScriptHandler(scrollfun)
    _scroll:refresh();

    _panel:addChild( _scroll );
    self.view:addChild(arrow_up)
    self.view:addChild(arrow_down)
    self.r_down_scroll = _scroll;
end

function AchieveDetailsPage:create(  )
    return AchieveDetailsPage("AchieveDetailsPage", "", false, 880, 514 )
end

function AchieveDetailsPage:__init()
    local page = self.view;
    -- 底板
    local panel_bg = CCBasePanel:panelWithFile( 0, 0, 884, 514, UILH_COMMON.normal_bg_v2, 500, 500 )
    page:addChild(panel_bg)

    _panel = panel_bg
end

function AchieveDetailsPage:update( groupId )
	_groupId = groupId;
	create_scroll( self );
end

function AchieveDetailsPage:destroy( )
    Window.destroy(self)
end