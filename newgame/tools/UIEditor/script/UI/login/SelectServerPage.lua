-- SelectServerPage.lua
-- created by lyl on 2013-2-26
-- 服务器选择窗口  select_server

require "UI/component/Window"
super_class.SelectServerPage()

-- ui 位置调整
local ui_upanel_h = 403     -- 上面左右面板高度
local ui_lpanel_w = 165     -- 上面左面板宽度
local ui_rpanel_w = 593     -- 上面有面板宽度

-- 服务器tab按钮选中效果表{}
local slt_btn_fram_t = {}


local _state_word = { [0] = LangGameString[1352], [1] = LangGameString[1353], [2] = LangGameString[1354], [3] = LangGameString[1355], [4] = LangGameString[1356],[5]=LangGameString[1357] }     -- 表示状态的字符串 -- [1352]="#cff0000未开服" -- [1353]="#cff0000火爆" -- [1354]="#cffc000推荐" -- [1355]="畅通" -- [1356]="#c101010维护" -- [1357]="新服"
local _state_word_image = { [0] = "ui2/login/weikaifu.png", [1] = "ui2/login/huobao.png", [2] = "ui2/login/tuijian.png", [3] = "ui2/login/changtong.png", [4] = "ui2/login/weihu.png" }

local _NEW_SERVER_STATE = 5

local _refWidth =  UIScreenPos.relativeWidth
local _refHeight = UIScreenPos.relativeHeight

local _screenWidth = _refWidth(1.0)
local _screenHeight = _refHeight(1.0)

local _rx = UIScreenPos.designToRelativeWidth
local _ry = UIScreenPos.designToRelativeHeight
-- 测试用服务器列表
local _my_server_t = {  { row_id = 1, state = 1, server_name = LangGameString[1358], login_time = LangGameString[1359], player_name = LangGameString[1358], player_level = "45" ,sex = 2, job = 1 },  -- [1358]="default配置" -- [1359]="2012年12月22日" -- [1358]="default配置"
                        { row_id = 7, state = 2, server_name = LangGameString[1360], login_time = LangGameString[1359], player_name = LangGameString[1360], player_level = "45" ,sex = 1, job = 1, ip = "119.254.95.164", server_id = 1, port = 8001 },  -- [1360]="外网" -- [1359]="2012年12月22日" -- [1360]="外网"
                        { row_id = 8, state = 3, server_name  = LangGameString[1361], login_time = LangGameString[1359], player_name = LangGameString[1362], player_level = "45" ,sex = 2, job = 2, ip = "192.168.17.201", server_id = 25, port = 9005 }, -- [1361]="25服" -- [1359]="2012年12月22日" -- [1362]="内网25服"
                        { row_id = 2, state = 4, server_name = LangGameString[1363], login_time = LangGameString[1359], player_name = LangGameString[1364], player_level = "45" ,sex = 1, job = 2, ip = "192.168.17.101", server_id = 42}, -- [1363]="一区一区均能" -- [1359]="2012年12月22日" -- [1364]="均能均能均能"
                        { row_id = 3, state = 4, server_name = LangGameString[1365], login_time = LangGameString[1359], player_name = LangGameString[1366], player_level = "45" ,sex = 2, job = 3, ip = "192.168.17.100", server_id = 43}, -- [1365]="一区一区志远" -- [1359]="2012年12月22日" -- [1366]="志远志远志远"
                        { row_id = 4, state = 3, server_name = LangGameString[1367], login_time = LangGameString[1359], player_name = LangGameString[1368], player_level = "45" ,sex = 1, job = 3, ip = "192.168.17.102", server_id = 41}, -- [1367]="一区一区妙明" -- [1359]="2012年12月22日" -- [1368]="妙明妙明妙明"
                        { row_id = 5, state = 1, server_name = LangGameString[1369], login_time = LangGameString[1359], player_name = LangGameString[1370], player_level = "45" ,sex = 2, job = 4, ip = "192.168.17.94", server_id = 44}, -- [1369]="一区一区建辉" -- [1359]="2012年12月22日" -- [1370]="建辉建辉建辉"
                        { row_id = 6, state = 2, server_name = LangGameString[1371], login_time = LangGameString[1359], player_name = LangGameString[1372], player_level = "45" ,sex = 1, job = 4, ip = "192.168.17.21", server_id = 9},  -- [1371]="一区一区湘君" -- [1359]="2012年12月22日" -- [1372]="湘君湘君湘君"
                        { row_id = 5, state = 1, server_name = LangGameString[1373], login_time = LangGameString[1359], player_name = LangGameString[1374], player_level = "45" ,sex = 2, job = 4, ip = "192.168.17.96", server_id = 66}, -- [1373]="一区一区杰桦" -- [1359]="2012年12月22日" -- [1374]="杰桦杰桦杰桦"
                        { row_id = 9, state = 1, server_name = LangGameString[1375], login_time = LangGameString[1359], player_name = LangGameString[1376], player_level = "45" ,sex = 2, job = 4, ip = "192.168.17.93", server_id = 68}, -- [1375]="一区一区玉龙" -- [1359]="2012年12月22日" -- [1376]="玉龙玉龙玉龙"
                        { row_id = 9, state = 1, server_name = LangGameString[1377], login_time = LangGameString[1359], player_name = LangGameString[1378], player_level = "45" ,sex = 2, job = 4, ip = "192.168.17.25", server_id = 70}, -- [1377]="一区一区九福" -- [1359]="2012年12月22日" -- [1378]="九福九福九福"
                        { row_id = 9, state = 1, server_name = LangGameString[1379], login_time = LangGameString[1359], player_name = LangGameString[1380], player_level = "45" ,sex = 2, job = 4, ip = "192.168.17.99", server_id = 69}, -- [1379]="一区一区广成" -- [1359]="2012年12月22日" -- [1380]="广成广成广成"
                        { row_id = 9, state = 1, server_name = LangGameString[1379], login_time = LangGameString[1359], player_name = LangGameString[1381], player_level = "45" ,sex = 2, job = 4, ip = "192.168.17.97", server_id = 46}, -- [1379]="一区一区广成" -- [1359]="2012年12月22日" -- [1381]="晓明晓明晓明"
                        { row_id = 9, state = 1, server_name = LangGameString[1382], login_time = LangGameString[1359], player_name = LangGameString[1383], player_level = "45" ,sex = 2, job = 4, ip = "192.168.17.95", server_id = 72}, -- [1382]="一区一区成龙" -- [1359]="2012年12月22日" -- [1383]="成龙成龙成龙"
                        { row_id = 9, state = 1, server_name = LangGameString[1382], login_time = LangGameString[1359], player_name = LangGameString[1384], player_level = "45" ,sex = 2, job = 4, ip = "192.168.17.98", server_id = 56}, -- [1382]="一区一区成龙" -- [1359]="2012年12月22日" -- [1384]="陈晋陈晋陈晋"
                        { row_id = 9, state = 1, server_name = LangGameString[1385], login_time = LangGameString[1359], player_name = LangGameString[1385], player_level = "45" ,sex = 2, job = 4, ip = "119.254.95.50", server_id = 1, port = 8001 }, -- [1385]="外网测试服" -- [1359]="2012年12月22日" -- [1385]="外网测试服"
                    }

local _server_1_t = {   { row_id = 11, state = 1, server_name = LangGameString[1386], login_time = LangGameString[1359], player_name = LangGameString[1386], player_level = "45" , ip = "192.168.17.21", server_id = 9 }, -- [1386]="湘君" -- [1359]="2012年12月22日" -- [1386]="湘君"
                        { row_id = 7, state = 1, server_name  = LangGameString[1362], login_time = LangGameString[1359], player_name = LangGameString[1362], player_level = "45" , ip = "192.168.17.201", server_id = 25, port = 9005 }, -- [1362]="内网25服" -- [1359]="2012年12月22日" -- [1362]="内网25服"
                        { row_id = 13, state = 3, server_name = LangGameString[1387], login_time = LangGameString[1359], player_name = LangGameString[1387], player_level = "45", ip = "192.168.16.27", server_id = 43 },  -- [1387]="无服测试" -- [1359]="2012年12月22日" -- [1387]="无服测试"
                        { row_id = 14, state = 4, server_name = LangGameString[1388], login_time = LangGameString[1359], player_name = LangGameString[1389], player_level = "45" },  -- [1388]="一区开天辟地14" -- [1359]="2012年12月22日" -- [1389]="第14维"
                        { row_id = 15, state = 3, server_name = LangGameString[1390], login_time = LangGameString[1359], player_name = LangGameString[1391], player_level = "45" },  -- [1390]="一区开天辟地15" -- [1359]="2012年12月22日" -- [1391]="第15维"
                        { row_id = 16, state = 2, server_name = LangGameString[1392], login_time = LangGameString[1359], player_name = LangGameString[1393], player_level = "45" },  -- [1392]="一区开天辟地16" -- [1359]="2012年12月22日" -- [1393]="第16维"
                        { row_id = 17, state = 1, server_name = LangGameString[1394], login_time = LangGameString[1359], player_name = LangGameString[1395], player_level = "45" },  } -- [1394]="一区开天辟地17" -- [1359]="2012年12月22日" -- [1395]="第17维"

local _server_2_t = {   { row_id = 1, state = 1, server_name = LangGameString[1396], login_time = LangGameString[1359], player_name = LangGameString[1397], player_level = "45" }, -- [1396]="一区啊啊啊啊1" -- [1359]="2012年12月22日" -- [1397]="第31维"
                        { row_id = 2, state = 2, server_name = LangGameString[1398], login_time = LangGameString[1359], player_name = LangGameString[1399], player_level = "45" }, -- [1398]="一区啊啊啊啊2" -- [1359]="2012年12月22日" -- [1399]="第32维"
                        { row_id = 3, state = 3, server_name = LangGameString[1400], login_time = LangGameString[1359], player_name = LangGameString[1401], player_level = "45" },  -- [1400]="一区啊啊啊啊3" -- [1359]="2012年12月22日" -- [1401]="第33维"
                        { row_id = 4, state = 4, server_name = LangGameString[1402], login_time = LangGameString[1359], player_name = LangGameString[1403], player_level = "45" },  -- [1402]="一区啊啊啊啊4" -- [1359]="2012年12月22日" -- [1403]="第34维"
                        { row_id = 5, state = 3, server_name = LangGameString[1404], login_time = LangGameString[1359], player_name = LangGameString[1405], player_level = "45" },  -- [1404]="一区啊啊啊啊5" -- [1359]="2012年12月22日" -- [1405]="第35维"
                        { row_id = 6, state = 2, server_name = LangGameString[1406], login_time = LangGameString[1359], player_name = LangGameString[1407], player_level = "45" },  -- [1406]="一区啊啊啊啊6" -- [1359]="2012年12月22日" -- [1407]="第36维"
                        { row_id = 7, state = 1, server_name = LangGameString[1408], login_time = LangGameString[1359], player_name = LangGameString[1409], player_level = "45" },  } -- [1408]="一区啊啊啊啊7" -- [1359]="2012年12月22日" -- [1409]="第37维"

-- 初始化
function SelectServerPage:__init( window_name, texture_name, is_grid, width, height  )
    -- 创建 背景基础层
    self.view = CCBasePanel:panelWithFile( 0, 0, width, height, texture_name, 500, 500 )
    self.view:setTag(100)
    safe_retain(self.view)

    -- 大背景层
    self.grid_bg = CCBasePanel:panelWithFile( _refWidth(0.5), _refHeight(0.47), 
                                                        835, 565, 
                                                        UILH_COMMON.dialog_bg, 500, 500 )
    self.grid_bg:setAnchorPoint(0.5,0.5)
    self.view:addChild(self.grid_bg)

    -- 里面背景层
    self.panel_inside = CCBasePanel:panelWithFile( 14, 10, 
                                                        810, 530, 
                                                        UILH_COMMON.normal_bg_v2, 500, 500 )
    self.grid_bg:addChild(self.panel_inside)

    -- 服务器背景层
    self.selectServerPanel = CCBasePanel:panelWithFile( 835*0.5, 565*0.59, 
                                                        800, 430, 
                                                        "" )
    self.selectServerPanel:setAnchorPoint(0.5,0.5)

    local panel_inside_list = CCBasePanel:panelWithFile( ui_lpanel_w+10, 5, ui_rpanel_w+20, ui_upanel_h, UILH_COMMON.bottom_bg, 500, 500 )
    self.selectServerPanel:addChild( panel_inside_list, -1 )

    self.grid_bg:addChild(self.selectServerPanel)

    -- -- 竖直分割线
    -- MUtils:create_zximg( self.selectServerPanel, UILH_COMMON.split_line_v, 179, 16, 3, 400, 0, 0 )

    -- temp 数据
    self.page_index = 1                         -- 记录当前页
    self.row_t   = {}                           -- 存储每一行的对象， 用来修改每行数据
    self.current_select_row_id =  nil           -- 当前选中的行 的id
    self.col_widthes = { 95, 135, 135, 20, 75 }     -- 列宽，用于计算下一列的坐标.

    -- todo 临时解决sroll奔溃问题   以后要删除
    self.page_to_row = {}                       -- 保存每页的所有行， 页号为key, 每个元素是table(保存row)
    self.scroll_t = {}                          -- 滚动列表保存  key为页号  

    -- title 选择服务器
    local title_bg = CCZXImage:imageWithFile( 270, 525, -1, -1, UILH_COMMON.title_bg, 500, 500 )
    self.grid_bg:addChild( title_bg )
    local bg_3 = CCZXImage:imageWithFile( 68, 17, -1, -1, "ui2/login/lh_title_server.png", 500, 500 )
    title_bg:addChild( bg_3 )

    -- 创建 服务器选择标签tab 页
    self:create_server_list(  )

    -- 返回登录
    local function left_bottom_but_CB(  )
        require "model/RoleModel"
        RoleModel:open_login_page();
    end

    if PlatformInterface.logoutable then
        -- local left_bottom_but = ZImageButton:create( self.view, 'ui2/login/lh_back.png',
        --  "ui2/login/fanhuidenglu.png", left_bottom_but_CB, 2, 0 )
        ZTextButton:create(self.grid_bg, LH_COLOR[2].."返回", UILH_COMMON.lh_button2, 
                                        left_bottom_but_CB, 35, 40, -1, -1, 1)--“增 加”
    end

    -- 开始游戏
    local function right_bottom_2_CB(  )
        local last_login_server_date = RoleModel:get_server_info_list(  )[1];
        if ( last_login_server_date ) then
            -- print("开始游戏按钮响应******")
            local function cb_function(  )
                RoleModel:land_to_game_server( last_login_server_date )
            end
            self:show_connecting( true )
            local callback = callback:new()
            callback:start( 0, cb_function )         -- 先显示登录中的图片，下一帧后登录
        end
    end

    --if PlatformInterface.logoutable then
    local right_bottom_2_but = ZImageButton:create( self.grid_bg, UILH_NORMAL.special_btn,
         "ui2/login/lh_enter.png", right_bottom_2_CB, 835-20, 40 )
    right_bottom_2_but.view:setAnchorPoint(1.0,0.0)
    right_bottom_2_but.view:setFlipX(true)       
end

-- 选择服务器列表
function SelectServerPage:create_server_list(  )
    --=======================================
    -- 天将雄狮(tjxs) modify by chj 14.10.15    
    --=======================================
    -- -- 左面板按钮:我的服务器分页按钮
    self.left_panel = CCBasePanel:panelWithFile( 10, 5, ui_lpanel_w, ui_upanel_h, UILH_COMMON.bottom_bg, 500, 500 );
    self.selectServerPanel:addChild(self.left_panel)

    -- 我的服务器
    local function btn_mine_fun()
        -- 隐藏选中效果
        for i=1, #slt_btn_fram_t do
            slt_btn_fram_t[i]:setIsVisible(false)
        end
        -- local temp_tab_1_index = _tap_index_server_info.btn_index[1]
        self:select_but_callback_func( 1 )
    end
    local temp_tab_1 = ZImageButton:create( nil, UILH_COMMON.button7 , "",  -- 148,97
                                              btn_mine_fun, 12, ui_upanel_h-103, -1, -1,nil)
    self.left_panel:addChild( temp_tab_1.view )
    local mine_txt = UILabel:create_lable_2( "我的服务器", 148/2, 45, 17, ALIGN_CENTER )
    temp_tab_1:addChild( mine_txt )

    -- 1-n 服务器
    local r_btn_h = 56
    local r_btn_w = 135
    local num_page = RoleModel:get_server_total_page(  )

    -- self.slt_btn_frame = CCZXImage:imageWithFile( 0, 0, -1, -1, "ui/lh_common/slot_focus.png" );
    -- safe_retain(self.slt_btn_frame)
      
      -- scroll背景  
    local scroll_bg = CCBasePanel:panelWithFile( 9, 7, 150, 285, UILH_COMMON.bg_07, 500, 500 )
    self.left_panel:addChild( scroll_bg )
      
      -- 创建scroll   
    local scroll = CCScroll:scrollWithFile(9, 8, 150-12, 283, 1, "", TYPE_HORIZONTAL)
    self.left_panel:addChild(scroll)
    scroll:setScrollLump( UILH_COMMON.up_progress, UILH_COMMON.down_progress, 10, 20, 42)

        -- 添加 滚动条上下箭头
    local arrow_up = CCZXImage:imageWithFile(ui_lpanel_w-18, ui_upanel_h-123, 11, -1 , UILH_COMMON.scrollbar_up, 500, 500)
    self.left_panel:addChild( arrow_up, 1 )
    local arrow_down = CCZXImage:imageWithFile(ui_lpanel_w-18, 9, 11, -1, UILH_COMMON.scrollbar_down, 500 , 500)
    self.left_panel:addChild( arrow_down, 1 )

    --scroll:setEnableCut(true)
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

            -- 创建 服务器分页
            -- self.radio_buts_ex = CCRadioButtonGroup:buttonGroupWithFile( 10 ,10 , r_btn_w, num_page*r_btn_h, "", 600, 600 )
            self.btns_bg_ex = CCBasePanel:panelWithFile( 0, 0, r_btn_w, num_page*r_btn_h, "", 500, 500 )
            local ser_num_page = RoleModel:get_server_num_per_page( )
            -- local btn_name = { "0-20", "21-40" }
            for i=1, num_page do
                -- self:create_a_button(self.radio_buts_ex, 5, r_btn_h*(num_page-i), r_btn_w, r_btn_h, "ui2/login/server_bg.png", "ui2/login/server_bg.png", btn_name[i], i)
                self:create_a_button2(self.btns_bg_ex, 3, r_btn_h*(num_page-i), r_btn_w, r_btn_h, "", string.format( "%d-%d", ser_num_page*(i-1)+1, ser_num_page*i ), i)
            end

            scroll:addItem( self.btns_bg_ex )
            scroll:refresh()
            return false
        end
    end
    scroll:registerScriptHandler(scrollfun)
    scroll:refresh()
    --======================================end

    -- 新服 上次登录
    -- MUtils:create_sprite(self.grid_bg,"ui2/login/ss_new_server.png",_rx(182),35)
    -- MUtils:create_sprite(self.grid_bg,"ui2/login/ss_last_login.png",_rx(514),35)
end

-- 创建一个按钮:参数： 要加入的panel， 坐标和长宽， 按钮两种状态背景图， 序列号（用于触发事件判断调用的方法）
-- function SelectServerPage:create_a_button(panel, pos_x, pos_y, size_w, size_h, image_n, image_s, but_name, but_index)
--     local radio_button = CCRadioButton:radioButtonWithFile(pos_x, pos_y, size_w, size_h, image_n, 1,500,500)
--     radio_button:addTexWithFile(CLICK_STATE_DOWN,image_s)
--     local function but_1_fun(eventType,x,y)
--         if eventType == TOUCH_CLICK then 
--             -- 添加点击效果
--             for i=1, #slt_btn_fram_t do
--                 slt_btn_fram_t[i]:setIsVisible(false)
--             end
--             slt_btn_fram_t[but_index]:setIsVisible(true)
--             --根据序列号来调用方法
--             -- local temp_tab_index = _tap_index_server_info.btn_index[but_index]
--             print("----------run but_index: ", but_index+1)
--             self:select_but_callback_func( but_index+1 )
--             return true
--         elseif eventType == TOUCH_BEGAN then
--             return true;
--         elseif eventType == TOUCH_ENDED then
--             return true;
--         end
--     end
--     radio_button:registerScriptHandler(but_1_fun)    --注册
--     panel:addGroup(radio_button)

--     --获取按钮的宽高
--     local t_radioSize = radio_button:getSize()
--     local t_width = t_radioSize.width
--     local t_height = t_radioSize.height

--     --按钮显示的名称
--     local name_txt = UILabel:create_lable_2( LH_COLOR[2] .. but_name, t_width/2, t_height/2-5, 17, ALIGN_CENTER )
--     radio_button:addChild(name_txt)

--     -- 分割线
--     local split_line = CCZXImage:imageWithFile( 0, 0, size_w,2, UILH_COMMON.split_line );
--     radio_button:addChild( split_line );

--     -- 添加选中效果
--     local slt_btn_frame = CCZXImage:imageWithFile( 0, 0, size_w, size_h, "ui/lh_common/slot_focus.png" );
--     radio_button:addChild(slt_btn_frame)
--     slt_btn_frame:setIsVisible( false )
--     slt_btn_fram_t[but_index] = slt_btn_frame 

--     return radio_button
-- end

-- 创建一个按钮:参数： 要加入的panel， 坐标和长宽， 按钮两种状态背景图， 序列号（用于触发事件判断调用的方法）
function SelectServerPage:create_a_button2(panel, pos_x, pos_y, size_w, size_h, image_texture, but_name, but_index)
    local slt_item_btn = CCBasePanel:panelWithFile( pos_x, pos_y, size_w, size_h, image_texture )
    local function slt_btn_fun(eventType, arg, msgid, selfitem)
        if eventType == nil or arg == nil or msgid == nil or selfitem == nil then
            return
        end
        if eventType == TOUCH_BEGAN then
            -- 添加点击效果
            for i=1, #slt_btn_fram_t do
                slt_btn_fram_t[i]:setIsVisible(false)
            end
            slt_btn_fram_t[but_index]:setIsVisible(true)
            -- print("----------run but_index: ", but_index+1)
            self:select_but_callback_func( but_index+1 )
            return true
        elseif eventType == TOUCH_CLICK then
            return true;
        end
        return true;
    end
    slt_item_btn:registerScriptHandler(slt_btn_fun)    --注册
    panel:addChild(slt_item_btn)

    --获取按钮的宽高
    local t_radioSize = slt_item_btn:getSize()
    local t_width = t_radioSize.width
    local t_height = t_radioSize.height
    --按钮显示的名称
    local name_txt = UILabel:create_lable_2( LH_COLOR[2] .. but_name, t_width/2, t_height/2-5, 17, ALIGN_CENTER )
    slt_item_btn:addChild(name_txt)

    -- 分割线
    local split_line = CCZXImage:imageWithFile( 0, 0, size_w,3, UILH_COMMON.split_line );
    slt_item_btn:addChild( split_line );


    -- 添加选中效果
    local slt_btn_frame = CCBasePanel:panelWithFile( 0, 0, size_w, size_h, UILH_COMMON.select_focus );
    slt_item_btn:addChild(slt_btn_frame)
    slt_btn_frame:setIsVisible( false )
    slt_btn_fram_t[but_index] = slt_btn_frame 

    return slt_item_btn
end

function SelectServerPage:get_server_index(arg)
    local temp_index = 1
    local last_index = 1
    local begin_index = nil
    print("arg", arg)
    while temp_index <= string.len(arg) do
        local target_info = string.sub(arg, temp_index, temp_index)
        local temp = CCTextAnalyze:getUTF8LenEx(target_info)
        if temp < 3 then
            if begin_index == nil then
                begin_index = temp_index
            end
            last_index = temp_index + temp
        end
        temp_index = temp_index + temp
    end
    local index = nil
    if begin_index ~= nil then
        index = string.sub(arg, begin_index, last_index - 1)
    end
    --print("index",index)
    return tonumber(index)
end

require "../data/server_name_config"
-- 创建一行。 参数：坐标 宽高 背景图名称  标识序列号（数字） 该行的数据
function SelectServerPage:create_one_row2( pos_x, pos_y, width, height, texture_name, index, server_date )
    local panel = CCBasePanel:panelWithFile( pos_x, pos_y, width, height, texture_name, 500, 500 );
    local num_row = 3 -- 一行4个
    local row_space = 10
    local btn_ser_h = height
    local btn_ser_w = (width-((num_row-1)*10))/num_row
    for i=1,num_row do
        local date = server_date[(index-1)*num_row+i]
        if ( date ) then
            local function btn_fun(eventType, arg, imsgid, selfitem)
                if eventType == TOUCH_CLICK then
                    self:show_connecting( true )
                    RoleModel:land_to_game_server( date );
                end
                return true;
            end
            local btn = MUtils:create_btn(panel, "ui2/login/lh_ser_bg2.png",
                                                "ui2/login/lh_ser_bg2.png",
                                                btn_fun,(i-1)*(btn_ser_w+row_space),7.5, btn_ser_w, btn_ser_h-12, 500,500);
            local server_state = date.state;
            local server_id = date.server_id;
            local server_name = date.server_name;
            server_id = SelectServerPage:get_server_index(server_name)
            if server_id == nil then
                server_id = date.server_id
            end
            local img_path = "";
            -- print("server_state",server_state);
            if ( _state_word[tonumber(server_state)] ) then
                img_path = "ui2/login/lh_ser_state_"..server_state..".png";
            else
                img_path = "ui2/login/ss_state_6.png"
            end
            if Target_Platform ~= Platform_Type.NOPLATFORM then
                MUtils:create_zxfont(btn, LH_COLOR[2] .. "["..server_name.. "]", btn_ser_w*0.5, btn_ser_h*0.5-10,2,16); -- [1411]="服]"
            else
                MUtils:create_zxfont(btn, LH_COLOR[2] .. "["..server_id..LangGameString[1411], btn_ser_w*0.5, btn_ser_h*0.5-10,2,16); -- [1411]="服]"
            end
            MUtils:create_sprite(btn,img_path,25,43);

            -- if #server_name_config > tonumber(server_id) then
            --     MUtils:create_font_spr( server_name_config[tonumber(server_id)] ,btn,82,60,"ui2/server/");
            -- end
        end
    end
    return panel;
end


-- 创建一行。 参数：坐标 宽高 背景图名称  标识序列号（数字） 该行的数据
function SelectServerPage:create_one_row( pos_x, pos_y, width, height, texture_name, index, row_date )
    -- local row_date={ }
    local one_row = {}       -- 行对象
    one_row.row_date = row_date
    one_row.row_id = index
    -- todo 7.2
    one_row.page_index = self.page_index    -- 创建的时候就与页绑定了

    one_row.view = CCBasePanel:panelWithFile( pos_x, pos_y, width, height, texture_name, 500, 500 )
    one_row.selected_frame = CCZXImage:imageWithFile( 0, 5, width, height - 10, "ui2/login/list_select.png", 500, 500 )   -- 选中状态的框
    one_row.view:addChild( one_row.selected_frame )
    if self.current_select_row_id ~= one_row.row_id then
        one_row.selected_frame:setIsVisible( false )
    end
    local function f1(eventType, arg, imsgid, selfitem)
        if eventType == nil or arg == nil or imsgid == nil or selfitem == nil then
            return
        end

        if eventType == TOUCH_BEGAN then
            self:set_row_selected_by_index( one_row.row_id, one_row.page_index )
            return true
        elseif eventType == TOUCH_DOUBLE_CLICK then
            self:set_row_selected_by_index( one_row.row_id, one_row.page_index )
            self:show_connecting( true )

            local function cb_function(  )
                RoleModel:land_to_game_server( row_date )
            end
            local callback = callback:new()
            callback:start( 0.1, cb_function )         -- 先显示登录中的图片，0.1秒后登录

            return true
        elseif eventType == ITEM_DELETE then           
            -- self:remove_row_by_id( one_row.row_id )    -- 拖动使行隐藏后，c++销毁panel，这时有 事件通知，就删除该行
            -- todo 7.2
            self:remove_row_by_id( one_row.row_id, one_row.page_index )    -- 拖动使行隐藏后，c++销毁panel，这时有 事件通知，就删除该行
        end
    end
    one_row.view:registerScriptHandler(f1)
    one_row.view:setEnableDoubleClick(true)
    local title_x = 60            -- 第一列的起始x坐标，后面的坐标要依据它与列宽（self.col_widthes）计算
    local title_y = 20
    -- 状态
    -- local state = _state_word[row_date.state] or "#cff0000火爆"
    -- one_row.state_lable = UILabel:create_lable_2( "#c66ff66"..state, title_x, title_y, 16, ALIGN_CENTER )
    -- one_row.view:addChild( one_row.state_lable )
    -- print("状态。。。。。", row_date.state, _state_word_image[ row_date.state ], _state_word_image[ 1 ] )
    row_date.state = tonumber( row_date.state )
    -- print("状态。。。。。", row_date.state, _state_word_image[ row_date.state ], _state_word_image[ 1 ] )
    local state_image_path = _state_word_image[ row_date.state ] or _state_word_image[ 1 ]
    local state_image = CCZXImage:imageWithFile( title_x - 35, title_y - 12, -1, -1, state_image_path, 500, 500 )
    one_row.view:addChild( state_image )
    -- 如果是新服，就加个新字
    if row_date.state == RoleModel.NEW_SERVER_STATE then 
        one_row.view:addChild( CCZXImage:imageWithFile( 30, 25, -1, -1, "ui2/login/new.png" ) )
    end

    -- 服务器名称
    title_x = title_x + self.col_widthes[1] 
    one_row.server_name = UILabel:create_lable_2( row_date.server_name, title_x, title_y, 16, ALIGN_CENTER )
    one_row.view:addChild( one_row.server_name )

    -- 最近登录时间
    title_x = title_x + self.col_widthes[2] 
    local login_date = (row_date.login_time == "null") and LangGameString[1412] or row_date.login_time -- [1412]="祝大家游戏愉快"
    one_row.login_time = UILabel:create_lable_2( login_date, title_x, title_y, 16, ALIGN_CENTER )
    one_row.view:addChild( one_row.login_time )

    -- 头像
    title_x = title_x + self.col_widthes[3] 
    local head_image_path = self:get_head_by_job_sex( row_date.job, row_date.sex )
    local head_image = CCZXImage:imageWithFile( title_x - 50, title_y - 15, 55, 55, head_image_path )
    one_row.view:addChild( head_image )

    -- 角色名字
    title_x = title_x + self.col_widthes[4] 
    local player_name = (row_date.player_name == "null" or row_date.player_name == "" ) and LangGameString[1413] or row_date.player_name -- [1413]="没有角色"
    one_row.player_name = UILabel:create_lable_2( player_name, title_x, title_y + 10, 16, ALIGN_LEFT )
    one_row.view:addChild( one_row.player_name )

    -- 等级
    -- title_x = title_x + self.col_widthes[5] 
    local player_level = (row_date.player_level == "null" or row_date.player_level == "") and "0" or row_date.player_level
    one_row.player_level = UILabel:create_lable_2( player_level..LangGameString[1136], title_x, title_y - 10, 16, ALIGN_LEFT ) -- [1136]="级"
    one_row.view:addChild( one_row.player_level )

    one_row.view:addChild( CCZXImage:imageWithFile( 0, 0, width, 1, "ui2/login/line.png" ) )

    -- todo  原来的7.2
    -- self.row_t[ one_row.row_id ] = one_row

    -- todo 临时 7.2
    if self.page_to_row[ one_row.page_index ] == nil then 
        self.page_to_row[ one_row.page_index ] = {}
    end
    self.page_to_row[ one_row.page_index ][ one_row.row_id ] = one_row
    
    return one_row
end

-- 根据row_id，删除一行,  
function SelectServerPage:remove_row_by_id( row_id, page_index )
    self.page_to_row[ page_index ][ row_id ] = nil
end

-- 设置某行为选中状态    -- todo 7.2
function SelectServerPage:set_row_selected_by_index( index, page_index )
    if self.page_to_row[page_index] == nil then 
        return
    end
    for key, row in  pairs( self.page_to_row[page_index] ) do
        if row and row.selected_frame then
            row.selected_frame:setIsVisible( false )
        end
    end
    if self.page_to_row[page_index][ index ] then 
        self.page_to_row[page_index][ index ].selected_frame:setIsVisible( true )
        self.current_select_row_id = self.page_to_row[page_index][ index ].row_id
    end
end

-- 创建可拖动区域   参数：放入scroll的panel的集合, 坐标， 区域大小，列数，可见行数， 背景名称
function SelectServerPage:create_scroll_area( panel_table_para , pos_x, pos_y, size_w, size_h, colu_num, sight_num, bg_name)
    local row_num = math.ceil( #panel_table_para / colu_num )
    -- print("row_num = ",row_num);
    --local scroll = CCScroll:scrollWithFile(pos_x, pos_y, size_w, size_h, sight_num, colu_num, row_num , bg_name, TYPE_VERTICAL)
    local scroll = CCScroll:scrollWithFile(pos_x, pos_y, size_w, size_h, row_num, "", TYPE_HORIZONTAL)
    scroll:setScrollLump("ui/lh_common/up_progress.png","ui/lh_common/down_progress.png", 10, 20, 42)
    scroll:setScrollLumpPos(585)
    -- scroll:setGapSize(4)  -- 列间距
    --scroll:setEnableCut(true)
    local had_add_t = {}
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

            local temparg = Utils:Split_old(args,":")
            local x = temparg[1]              -- 行
            local y = temparg[2]              -- 列
            --local index = y * colu_num + x + 1
            local index = x + 1
            -- print("index = ",index);
            local row = self:create_one_row2( 0, 0, size_w, size_h/5, "", index, panel_table_para )
            scroll:addItem( row )
            --if panel_table_para[index] then
      
            -- else
            --     local bg = CCBasePanel:panelWithFileS(CCPointMake(0,0),CCSizeMake(0,0),nil)
            --     scroll:addItem(bg)
            -- end

            scroll:refresh()
            return false
        end
    end
    scroll:registerScriptHandler(scrollfun)
    scroll:refresh()

    return scroll
end

-- 切换列表    -- todo change_list 改名为 create_list  7.2
function SelectServerPage:create_list( list_date )
    -- todo 下面五行，临时，以后恢复  7.2
    -- if self.server_list_scroll then 
    --     self.server_list_bg:removeChild( self.server_list_scroll, true )
    -- end
    -- self.server_list_scroll = self:create_scroll_area( list_date , 0, 15, 568 + 38, 230, 1, 4, "")
    -- self.server_list_bg:addChild( self.server_list_scroll ) 

    -- todo 临时解决代码以后删除  7.2
    -- 664,260
    -- print("list_date",#list_date)

    local server_list_scroll = self:create_scroll_area( list_date , ui_lpanel_w+18, 13, ui_rpanel_w-10, ui_upanel_h-20, 3, 5, "")

    -- 添加 滚动条上下箭头
    if not self.arrow_up then
        self.arrow_up = CCZXImage:imageWithFile(ui_lpanel_w+ui_rpanel_w+10, ui_upanel_h-15, 11, -1 , UILH_COMMON.scrollbar_up, 500, 500)
        self.selectServerPanel:addChild( self.arrow_up, 1 )
        self.arrow_down = CCZXImage:imageWithFile(ui_lpanel_w+ui_rpanel_w+10, 13, 11, -1, UILH_COMMON.scrollbar_down, 500 , 500)
        self.selectServerPanel:addChild( self.arrow_down, 1 )
    end

    return server_list_scroll
end

-- 根据职业和性别获取头像
function SelectServerPage:get_head_by_job_sex( job, sex )
    local head_image_path = ""
    -- return "ui2/head/head10.png"
    local job_temp = 1
    if job ~= nil and job ~= "" and job ~= "null" then
        job_temp = tonumber(job)
    end
    local sex_temp = 1
    if sex ~= nil and sex ~= "" and sex ~= "null" then
        sex_temp = tonumber(sex) + 1
    end 
    -- print( job_temp, sex_temp )
    local _head_image = { { "ui2/head/head10.png", "ui2/head/head11.png" },
                          { "ui2/head/head20.png", "ui2/head/head21.png" },
                          { "ui2/head/head30.png", "ui2/head/head31.png" },
                          { "ui2/head/head40.png", "ui2/head/head41.png" },
                        }

    if _head_image[job_temp] and _head_image[job_temp][sex_temp] then 
        head_image_path = _head_image[job_temp][sex_temp]
    else
        head_image_path = _head_image[1][1]
    end
    return _head_image[job_temp][sex_temp] or _head_image[1][1]
end

-- 选择按钮的回调
function SelectServerPage:select_but_callback_func( index )
    -- 隐藏选中效果
    for i=1, #slt_btn_fram_t do
        slt_btn_fram_t[i]:setIsVisible(false)
    end

    -- todo 临时解决代码
    self.page_index = index
    local scroll_date = {}              -- scroll的数据
    if index == 1 then                  -- 玩家登录过的服务器列表
        scroll_date = RoleModel:get_server_info_list(  )
    else                                -- 如果是其他的页，就显示服务器发来的服务器列表
        scroll_date = RoleModel:get_server_list_by_page_index( index - 1 )   -- page_index - 1 ，在显示层，是第二页了
        slt_btn_fram_t[index - 1]:setIsVisible(true)
    end
    -- 如果还没创建，就创建
    if self.scroll_t[index] == nil then 
        local scroll_temp = self:create_list( scroll_date )
        self.selectServerPanel:addChild( scroll_temp ) 
        self.scroll_t[index] = scroll_temp
        self:set_row_selected_by_index( 1, index )
    end
    -- 设置显示
    for key, one_scroll in pairs(self.scroll_t) do 
        if key == index then
            one_scroll:setIsVisible( true )
        else
            one_scroll:setIsVisible( false )
        end
    end

    self:set_row_selected_by_index( 1 )    
end

-- 控制  连接中  图片
function SelectServerPage:show_connecting( if_show )
--    if if_show then
--        self.connect_image:setIsVisible( true )
--    else
--        self.connect_image:setIsVisible( false )
--    end
end

-- 刷新服务器列表
function SelectServerPage:update_server_list(  )
    if RoleModel:check_if_had_save_server_info(  ) then
        self:select_but_callback_func( 1 )
        -- self.radio_buts:selectItem( 1 - 1)
    else
        self:select_but_callback_func( 2 )
        -- self.radio_buts:selectItem( 2 - 1)
    end

    -- 更新新服title
    local new_label =  UILabel:create_lable_2( LH_COLOR[2].."新开服：", 155, 58, 14, ALIGN_LEFT ) -- [1136]="级"
    self.grid_bg:addChild( new_label )
    -- 更新新服
    local new_server_list = RoleModel:get_new_server_list(  );
    if ( self.new_server_btn ) then
        self.new_server_btn:removeFromParentAndCleanup(true);
        self.new_server_btn = nil;
    end
    if ( new_server_list[1] ) then
        self.new_server_btn = self:create_server_btn_2(self.grid_bg, "ui2/login/lh_ser_bg2.png",
                                                                "ui2/login/lh_ser_bg2.png",
                                                                232, 25,new_server_list[1], 145, 90 );
    end
    -- 最近登录title
    local login_label =  UILabel:create_lable_2( LH_COLOR[2].."上次登录：", 390, 58, 14, ALIGN_LEFT ) -- [1136]="级"
    self.grid_bg:addChild( login_label )
    -- 更新最近登录的服务器
    local last_login_server_date = RoleModel:get_server_info_list(  )[1];
    if ( self.last_login_server_btn ) then
        self.last_login_server_btn:removeFromParentAndCleanup(true);
        self.last_login_server_btn = nil;  
    end
    if ( last_login_server_date ) then 
        self.last_login_server_btn = self:create_server_btn_2(self.grid_bg, "ui2/login/lh_ser_bg2.png",
                                                                       "ui2/login/lh_ser_bg2.png",
                                                                       485, 25,last_login_server_date, 145, 90 );

    end
end

-- 火影
function SelectServerPage:create_server_btn(parent, bg_path,bg_path_s,pos_x,pos_y,server_date, btn_w, btn_h )
    local btn_w_temp = btn_w or -1
    local btn_h_temp = btn_h or -1
    local function btn_fun(eventType, arg, imsgid, selfitem)
        if eventType == TOUCH_CLICK then
            self:show_connecting( true )
            RoleModel:land_to_game_server( server_date );
        end
        return true;
    end
    local btn = MUtils:create_btn( parent, bg_path, bg_path_s, btn_fun, pos_x, pos_y, btn_w_temp, btn_h_temp );
    local server_id = server_date.server_id;
    local server_name = server_date.server_name;
    MUtils:create_zxfont(btn,"["..server_id..LangGameString[1411],65,20,2,16);  -- [1411]="服]"
    -- MUtils:create_zxfont(btn,server_name,75,40,2,16); 
    -- print("server_name_config[server_id]",server_id,server_name_config[server_id]); 
    MUtils:create_font_spr( server_name_config[tonumber(server_id)] ,btn,30,52,"ui2/server/");
end

-- add after tjxs
function SelectServerPage:create_server_btn_2(parent, bg_path,bg_path_s,pos_x,pos_y,server_date, btn_w, btn_h )
    local btn_w_temp = btn_w or -1
    local btn_h_temp = btn_h or -1
    
    -------------------
    local server_item_btn = CCBasePanel:panelWithFile( pos_x, pos_y, btn_w, btn_h, bg_path, 500, 500 )
    local function title_btn_fun(eventType, arg, msgid, selfitem)
        if eventType == nil or arg == nil or msgid == nil or selfitem == nil then
            return
        end
        if eventType == TOUCH_BEGAN then
            return true
        elseif eventType == TOUCH_CLICK then
            self:show_connecting( true )
            RoleModel:land_to_game_server( server_date );
            return true;
        end
        return true;
    end
    ----------------
    server_item_btn:registerScriptHandler( title_btn_fun )  --注册
    parent:addChild( server_item_btn, 2 )

    -- local btn = MUtils:create_btn( parent, bg_path, bg_path_s, btn_fun, pos_x, pos_y, btn_w_temp, btn_h_temp );
    local server_id = server_date.server_id;
    local server_name = server_date.server_name;
    -- MUtils:create_zxfont(server_item_btn,"["..server_id..LangGameString[1411],65,20,2,16);  -- [1411]="服]"
    MUtils:create_zxfont(server_item_btn, LH_COLOR[2] .. "["..server_id..LangGameString[1411], btn_w*0.5, btn_h*0.5-7,2,16); -- [1411]="服]"
    -- MUtils:create_zxfont(btn,server_name,75,40,2,16); 
    -- print("server_name_config[server_id]",server_id,server_name_config[server_id]); 
    -- MUtils:create_font_spr( server_name_config[tonumber(server_id)] ,server_item_btn,30,52,"ui2/server/");
end
-- end

-- 重置所有 滚动条  页 选中行等数据
function SelectServerPage:reset_page(  )
    -- print("重置所有 滚动条  页 选中行等数据,,,,")
    if self.selectServerPanel and self.scroll_t then 
        for key, scroll in pairs(self.scroll_t) do 
            self.selectServerPanel:removeChild( scroll, true )
        end
    end

    self.page_index = 1                         -- 记录当前页
    self.row_t   = {}                           -- 存储每一行的对象， 用来修改每行数据
    self.current_select_row_id =  nil           -- 当前选中的行 的id    
    self.page_to_row = {}                       -- 保存每页的所有行， 页号为key, 每个元素是table(保存row)
    self.scroll_t = {}                          -- 滚动列表保存  key为页号  
end

-- 更新
function SelectServerPage:update( update_type )
    if update_type == "show_connecting" then
        self:show_connecting( true )
    elseif update_type == "hide_connecting" then
        self:show_connecting( false )
    elseif update_type == "server_list" then
        self:update_server_list(  )
    elseif update_type == "all" then 
        self:show_connecting( false )

        -- self:reset_page(  )
    end
end

function SelectServerPage:destroy(  )
    -- safe_release(self.slt_btn_frame)
    safe_release(self.view)
end

-- 隐藏  
function SelectServerPage:hide_to_left( show_type )
    local end_x = -_screenWidth
    if show_type == "login" then
        end_x = _screenWidth
    end
    local moveto = CCMoveTo:actionWithDuration( RoleModel:get_move_rate(  ), CCPoint( end_x, 0 ));          -- 动画
    self.view:runAction( moveto );
end

-- 显示
function SelectServerPage:show_to_center( show_type )
    local moveto = CCMoveTo:actionWithDuration( RoleModel:get_move_rate(  ), CCPoint( 0, 0 ));          -- 动画
    self.view:runAction( moveto );
    if show_type == "login" or show_type == "register" then 
        self:reset_page(  )
    end
end

function SelectServerPage:show_announcement()
    local _info_back = CCZXImage:imageWithFile( 0, _screenWidth, 244, 324, "ui2/login/grid_gg.png", 500, 500 ) 
    local content = CCDialogEx:dialogWithFile( 8, 10, 228, 280, 200 , "", TYPE_VERTICAL, ADD_LIST_DIR_UP )

    local textLabel = CCZXLabel:labelWithText(120-40,296,LangGameString[1414],18); -- [1414]="#cffff00系统公告"
    local an = UpdateManager.announcement or '祝你游戏愉快.'
    content:setText(an)
    _info_back:addChild(textLabel)
    _info_back:addChild(content)

    local moveTo = CCMoveTo:actionWithDuration(0.5,CCPointMake(0,90))
    local move0  = CCEaseIn:actionWithAction(moveTo,0.7);
    local move1 = CCMoveTo:actionWithDuration(0.2,CCPointMake(0,165))
    local move2 = CCMoveTo:actionWithDuration(0.1,CCPointMake(0,160))
    local array = CCArray:array();
    array:addObject(move0);
    array:addObject(move1);
    array:addObject(move2);
    local seq = CCSequence:actionsWithArray(array);
    _info_back:runAction(seq)

    return _info_back;
end
