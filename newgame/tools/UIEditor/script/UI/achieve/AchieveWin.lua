-- AchieveWin.lua
-- created by charles on 2013-1-4
-- 成就窗口

-- require "UI/component/Window"
super_class.AchieveWin(NormalStyleWindow)

require "UI/achieve/AchieveOverviewPage"
require "UI/achieve/AchieveDetailsPage"


local _page_overview;   -- 总览分页
local _page_details;    -- 详情分页
local _current_page;    -- 分页索引
local _nav_button;    -- 导航按钮

--切换功能窗口:   1:成就总览   2~7：成就分类
local function nav_change( panel, button_index )
    if button_index == _current_page then
        return;
    end
    if _current_page == 1 then
        _page_overview:stop_effect()
        panel:removeChild(_page_overview.view, true);
    else
        panel:removeChild(_page_details.view, true);
    end

    _current_page = button_index;

    if button_index == 1 then
        panel:addChild(_page_overview.view);
        _page_overview:update();
    else
        panel:addChild(_page_details.view);
        _page_details:update( _current_page - 1 );
    end
end

-- 创建一个按钮:参数： 要加入的panel， 坐标和长宽，按钮两种状态背景图，显示文字图片，文字图片的长宽，序列号（用于触发事件判断调用的方法）
local function create_nav_button(panel, pos_x, pos_y, image_n, image_s ,but_name, but_name_siz_w, but_name_siz_h, but_index)
	local nav_button = CCNGBtnMulTex:buttonWithFile( pos_x, pos_y, 94, 37, image_n, 500, 500)
    nav_button:addTexWithFile(CLICK_STATE_DOWN, image_s)
    --nav_button:addTexWithFile(CLICK_STATE_DISABLE, image_s)
    nav_button:registerScriptHandler(nav_button_fun)    --注册
    panel:addChild(nav_button)
    _nav_button[ but_index ] = nav_button

    --按钮显示的名称
    local name_image = CCZXImage:imageWithFile( pos_x + 12, pos_y + 8, but_name_siz_w, but_name_siz_h, but_name );  --一键升级的文字
    panel:addChild( name_image )
end

-- 初始化
function AchieveWin:__init( window_name,texture_name )
    self.btn_name_t = {}  --标签不同文字贴图集合
     --背景框
    local bgPanel = self.view;

    _nav_button = {};              -- 存放所有按钮，设置按钮状态

    -- 顶部所有按钮
    local but_beg_x = 50;          --按钮起始x坐标
    local but_beg_y = 530;         --按钮起始y坐标
    local but_int_y = 117;          --按钮x坐标间隔
    local btn_w = 110
    local btn_h = 60

    local radio_btn_group = CCRadioButtonGroup:buttonGroupWithFile(but_beg_x, but_beg_y, but_int_y * 7, btn_h, nil);
    bgPanel:addChild(radio_btn_group);
    local base_tab_path = UIResourcePath.FileLocate.achieveAndGoal .. "nav_button";
    local tab_t = {
        {UIPIC_ACHIEVE_008,UIPIC_ACHIEVE_014},
        {UIPIC_ACHIEVE_002,UIPIC_ACHIEVE_015},
        {UIPIC_ACHIEVE_004,UIPIC_ACHIEVE_016},
        {UIPIC_ACHIEVE_007,UIPIC_ACHIEVE_017},
        {UIPIC_ACHIEVE_006,UIPIC_ACHIEVE_018},
        {UIPIC_ACHIEVE_003,UIPIC_ACHIEVE_019},
        {UIPIC_ACHIEVE_005,UIPIC_ACHIEVE_020},
    }
    --local y = 402-b_m;
    local tab_text = Lang.achieve.tab_text
    self.radio_button = ZRadioButtonGroup:create( bgPanel, 15, 520, 117 * #tab_text, 44 )
    for i, v in ipairs(tab_text) do 
        local x = but_int_y*(i-1);
        local y = 1;
        local btn = self:create_btn_name(bgPanel, 0, 0, -1, -1, UILH_COMMON.tab_gray, UILH_COMMON.tab_light, v, i)
        self.radio_button:addItem( btn, 0)
    end 
    self.radio_button:selectItem( 0 )
    -- 默认打开的是总览页面
    _page_overview = AchieveOverviewPage:create();
    _page_overview:setPosition(7, 10)
    _page_details = AchieveDetailsPage:create();
    _page_details:setPosition(7, 10)
    _current_page = 1;
    bgPanel:addChild( _page_overview.view );
    -- self.btn_name_t[1].change_to_selected()
end

function  AchieveWin:create_btn_name(panel, pos_x, pos_y, size_w, size_h, image_n, image_s ,but_name, index )
    -- local radio_btn = ZTextButton:create(nil, but_name, {image_n,image_s}, nil, pos_x, pos_y, size_w, size_h)
    local radio_btn = ZButton:create(nil, {image_n,image_s}, nil, pos_x, pos_y, size_w, size_h)
    local btn_name = ZLabel:create(radio_btn.view, but_name, 51, 11, 16, 2)
    -- btn_name.view:setAnchorPoint(CCPoint(0.5, 0))
    local function btn_fun()
        local btn_index = index 
        self.radio_button:selectItem( index - 1 )
        nav_change(panel, index)
    end
    radio_btn:setTouchClickFun(btn_fun)
    return radio_btn
end

function AchieveWin:change_btn_name( index )
    -- body
    for i,v in ipairs(self.radio_button.item_group) do
        if(i==index) then
          self.radio_button:getIndexItem(i-1).view:setTexture(UILH_COMMON.tab_light)
        else
          self.radio_button:getIndexItem(i-1).view:setTexture(UILH_COMMON.tab_gray)
        end
    end
end

function AchieveWin:active( show )
    if show then
        if _current_page == 1 then
            _page_overview:update();
        else
            _page_details:update( _current_page - 1);
        end
    end
end

function AchieveWin:update( event )
    if event == "finishAchieve" or event == "updateProgress" then
        if _current_page ~= 1 then
            _page_details:update( _current_page - 1 );
        end
    elseif event == "getAward" then
        if _current_page == 1 then
            _page_overview:update();
        end
    end
end

function AchieveWin:destroy()
    Window.destroy(self)
    if _page_overview ~= nil then
        _page_overview:destroy()
    end
    if _page_details ~= nil then
        _page_details:destroy()
    end
end