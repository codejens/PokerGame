-- LingqiWin.lua
-- created by xiehande on 2014-10-28
-- 灵器主窗口
super_class.LingqiWin(NormalStyleWindow)
--当前页
local _current_page = nil
--记录标签页数
local _radio_group_page = 1 

function LingqiWin:__init( window_name, texture_name, is_grid, width, height,title_text )

   local base_bg = CCBasePanel:panelWithFile(5,7,890,520,UILH_COMMON.normal_bg_v2,500,500);
    self:addChild(base_bg);

  --所有的页面保存
	self.all_page_t = {}

	self.btn_name_t = {}  --标签不同文字贴图集合
    
    self.is_other_fabao =false
  --背景框
  local bgPanel = self.view
  

   -- 顶部所有按钮
    local win_size = self.view:getSize();
    local but_beg_x = 20          --按钮起始x坐标
    local but_beg_y = win_size.height - 110        --按钮起始y坐标
    local but_int_x = 101          --按钮x坐标间隔 102
    local btn_w = 101  --96
    local btn_h = 48
    local btn_n = 8
    local btn_i = 1

--标签按钮
    self.raido_btn_group = CCRadioButtonGroup:buttonGroupWithFile(but_beg_x, but_beg_y , but_int_x * btn_n, btn_h,nil)
    bgPanel:addChild(self.raido_btn_group)
    
    --灵器信息

    self.lingqiInfoPage = self:create_a_button(self.raido_btn_group, 1 + but_int_x * (btn_i - 1), 1, btn_w, btn_h, 
    UILH_COMMON.tab_gray,
    UILH_COMMON.tab_light,
    Lang.lingqi.tab[1], 
    "",
    -1, -1, btn_i)


    --灵器升级
    btn_i = btn_i + 1
    self.lingqiUpLevelWin = self:create_a_button(self.raido_btn_group, 1 + but_int_x * (btn_i - 1), 1, btn_w, btn_h, 
        UILH_COMMON.tab_gray,
        UILH_COMMON.tab_light,
       Lang.lingqi.tab[2], 
        "",
        -1, -1, btn_i)

    --灵器炼魂
    btn_i = btn_i + 1
    self.lingqiLianHunWin = self:create_a_button(self.raido_btn_group, 1 + but_int_x * (btn_i - 1), 1, btn_w, btn_h, 
        UILH_COMMON.tab_gray,
        UILH_COMMON.tab_light,
        Lang.lingqi.tab[3], 
        "",
        -1, -1, btn_i)

    --灵器一览
    btn_i = btn_i + 1
    self.lingqiIntroWin = self:create_a_button(self.raido_btn_group, 1 + but_int_x * (btn_i - 1), 1, btn_w, btn_h, 
        UILH_COMMON.tab_gray,
        UILH_COMMON.tab_light,
        Lang.lingqi.tab[4], 
        "",
        -1, -1, btn_i)

    btn_i = btn_i + 1
    self.meirenHouseWin = self:create_a_button(self.raido_btn_group, 1 + but_int_x * (btn_i - 1), 1, btn_w, btn_h, 
        UILH_COMMON.tab_gray,
        UILH_COMMON.tab_light,
        Lang.lingqi.hougong[1], 
        "",
        -1, -1, btn_i)

    local player = EntityManager:get_player_avatar()
    if player.level == 50 or player.level > 50 then
        btn_i = btn_i + 1
        self.meirenHouseWin = self:create_a_button(self.raido_btn_group, 1 + but_int_x * (btn_i - 1), 1, btn_w, btn_h, 
            UILH_COMMON.tab_gray,
            UILH_COMMON.tab_light,
            "铸卡室", 
            "",
            -1, -1, btn_i)
    end

    --创建左页 器魂镶嵌页面
    self:create_left(bgPanel)
    
    --默认打开属性页面
    self:change_page(1)
end

--创建左页面  镶嵌页面
function  LingqiWin:create_left(panel,pos_x, pos_y, width, height, texture_name)
    self.lingqi_left = LingqiLeft:create(423,497,UILH_COMMON.bottom_bg)
    self.lingqi_left:setPosition(17,17)
	-- self.lingqi_left = LingqiLeft:create(17,17,423,497,UILH_COMMON.bottom_bg)
	panel:addChild(self.lingqi_left.view)
end


--创建button
function LingqiWin:create_a_button(panel, pos_x, pos_y, size_w, size_h, image_n, image_s ,but_name,but_name_s, but_name_siz_w, but_name_siz_h, but_index)

    local radio_button = CCRadioButton:radioButtonWithFile(pos_x, pos_y, size_w, size_h, image_n)
    radio_button:addTexWithFile(CLICK_STATE_DOWN,image_s)

	local function but_1_fun(eventType,x,y)
		if eventType == TOUCH_BEGAN  then 
			return true
        elseif eventType == TOUCH_CLICK then
            -- Instruction:handleUIComponentClick(instruct_comps.FORGE_WIN_OK_PAGE_BASE + but_index)
            --美人后宫 需要特殊处理
            if but_index ==5 then
                local player = EntityManager:get_player_avatar();
                if player.level < GameSysModel:get_sys_lv( GameSysModel.MEIRENHOURSE ) then
                   GlobalFunc:create_screen_notic( string.format(Lang.lingqi[16],GameSysModel:get_sys_lv( GameSysModel.MEIRENHOURSE)) ); -- [1]="当前不能移动"
                   return true;
                end
            end
            self:change_page( but_index )
            return true;
        elseif eventType == TOUCH_ENDED then
            return true;
		end
	end

    radio_button:registerScriptHandler(but_1_fun)    --注册
    panel:addGroup(radio_button)
    --按钮显示的名称
  --  local name_image = CCZXImage:imageWithFile( 13, 10+5+3, but_name_siz_w, but_name_siz_h, but_name );  
    --self.btn_name_t[but_index] = LingqiWin:create_btn_name(but_name,but_name_s,size_w/2,size_h/2,-1,-1)
    self.btn_name_t[but_index] = ZLabel:create( nil, but_name, 0, 0)
    local btn_size = radio_button:getSize()
    local lab_size = self.btn_name_t[but_index]:getSize()
    self.btn_name_t[but_index]:setPosition( ( btn_size.width - lab_size.width ) / 2, ( btn_size.height - lab_size.height ) / 2 )
    radio_button:addChild( self.btn_name_t[but_index].view )
    return radio_button
end


--创建标签按钮美术字  暂时没有使用
-- function  LingqiWin:create_btn_name( btn_name_n,btn_name_s,name_x,name_y,btn_name_size_w,btn_name_size_h )
--     -- 按钮名称贴图集合
--     local  button_name = {}
--     local  button_name_image = CCZXImage:imageWithFile(name_x,name_y,btn_name_size_w,btn_name_size_h,btn_name_n)
--     button_name_image:setAnchorPoint(0.5,0.5)
--     button_name.view = button_name_image
--     --按钮被选中，调用函数切换贴图至btn_name_s
--     button_name.change_to_selected = function ( )
--         button_name_image:setTexture(btn_name_s)
--     end
--     --按钮变为未选时  切换贴图到btn_name_n
--     button_name.change_to_no_selected = function ( )
--         button_name_image:setTexture(btn_name_n)
--     end
--     return button_name
-- end


--灵器页面刷新
function  LingqiWin:lingqi_win_update( update_type ,args )
   local win  = UIManager:find_visible_window("lingqi_win")
   if win then
   	 win:update( update_type, server_resp)
   end
end

--按照页面刷新
function LingqiWin:update( update_type,args)
end

--换页
function LingqiWin:change_page( but_index )
            
    self.raido_btn_group:selectItem( but_index - 1)

    if _current_page and _current_page.view then
        _current_page.view:setIsVisible(false)
    end

    if but_index == 1 then

        if self.all_page_t[1] == nil then
            self.all_page_t[1] = LingqiInfoPage:create()
            self.all_page_t[1]:setPosition(10, 17)
            self.view:addChild( self.all_page_t[1].view )
        end
        if self.lingqi_left then
        	self.lingqi_left.view:setIsVisible(false)
        end
        _current_page = self.all_page_t[1]
        _current_page:active(true)
    elseif  but_index == 2 then
        if self.all_page_t[2] == nil then
            self.all_page_t[2] = LingqiUpLevelWin:create()
            self.all_page_t[2]:setPosition(10, 17)
            self.view:addChild( self.all_page_t[2].view)
        end
        if self.lingqi_left then
            self.lingqi_left.view:setIsVisible(false)
        end
        _current_page = self.all_page_t[2]
        _current_page:active(true)
    elseif  but_index == 3 then

        if self.all_page_t[3] == nil then
            self.all_page_t[3] = LingqiLianhunWin:create( )
            self.all_page_t[3]:setPosition(443, 17)
            self.view:addChild( self.all_page_t[3].view )
        end
        if self.lingqi_left then
        	self.lingqi_left.view:setIsVisible(true)
        end
        _current_page = self.all_page_t[3]
        _current_page:active(true)

    elseif  but_index == 4 then
            if self.all_page_t[4] == nil then
                self.all_page_t[4] = QihunIntroWin:create()
                self.all_page_t[4]:setPosition(10, 17)
                self.view:addChild( self.all_page_t[4].view )
            end
            if self.lingqi_left then
            	self.lingqi_left.view:setIsVisible(false)
            end
            _current_page = self.all_page_t[4]
    elseif  but_index == 5 then
            if self.all_page_t[5] == nil then
              --  美人后宫
                self.all_page_t[5] = MeirenHouse:create()
                self.all_page_t[5]:setPosition(10, 17)
                self.view:addChild( self.all_page_t[5].view )
            end
            if self.lingqi_left then
                self.lingqi_left.view:setIsVisible(false)
            end
            _current_page = self.all_page_t[5]
            _current_page:active(true)
    elseif  but_index == 6 then
            if self.all_page_t[6] == nil then
              --  美人后宫
                self.all_page_t[6] = MakeCardPage:create()
                self.all_page_t[6]:setPosition(10, 17)
                self.view:addChild( self.all_page_t[6].view )
            end
            if self.lingqi_left then
                self.lingqi_left.view:setIsVisible(false)
            end
            _current_page = self.all_page_t[6]
            _current_page:active(true)
    end

    _current_page.view:setIsVisible(true)

    if _current_page and _current_page.update then
        _current_page:update( "all" )
    end
end


--销毁方法
function LingqiWin:destroy()
    Window.destroy(self)
    self.lingqi_left:destroy()
    for key, page in pairs(self.all_page_t) do
        page:destroy()
    end
end

--显示他人元宝控制方法
function LingqiWin:show_other_fabao(other_fabao)
      UIManager:hide_window("lingqi_win");
      local win = UIManager:show_window("lingqi_win");
      win.is_other_fabao = true
      --查看他人的灵器的时候  至需要显示灵器信息页面
    if win then
        if win.window_title then
             win.window_title:setTexture(UILH_OTHER.show_lingqi_title)
        end

        win.all_page_t[1]:show_other_fabao( other_fabao )
        win.lingqiUpLevelWin:setIsVisible(false)
        win.lingqiLianHunWin:setIsVisible(false)
        if win.meirenHouseWin then
           win.meirenHouseWin:setIsVisible(false)
        end
        win.lingqi_left.view:setIsVisible(false)
        win.lingqiInfoPage:setIsVisible(true)
    end
end

--更新洛书战斗力
function LingqiWin:update_fight_value( fight_value )
    if self.all_page_t[5] then
        self.all_page_t[5]:update_fight_value( fight_value)
    end
end


--更新美人卡牌
function LingqiWin:update_card_data( page, card )
    if self.all_page_t[page] then
        self.all_page_t[page]:update_card_panel( card)
    end
end



--激活之后触发
function LingqiWin:active( show )
    if ( show ) then
        if ( _current_page ) then
            _current_page:active( show );
        end
    else
        local help_win = UIManager:find_visible_window("help_panel")
        if help_win ~= nil then
            UIManager:hide_window("help_panel")
        end
    end
end
