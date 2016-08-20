-- LuoPanWin.lua
-- created by lyl 2013-9-3
-- 罗盘窗口  luopan_win


super_class.LuoPanWin(NormalStyleWindow);

local _layout_info = nil                                -- 布局信息临时变量
local _luopan_activity_id = 4;  -- 罗盘活动的id，用于获取活动时间进行显示


function LuoPanWin:__init( window_name, texture_name )
	reload("UI/luopan/luo_pan_win_config")
    self.page_info = luo_pan_win_config.window_config
    self.luopan_page = nil       -- 罗盘页对象
    self.appear_info_cb = nil    -- 刷新珍品 的控制时间回调 

    -- 标题 背景
   --  _layout_info = self.page_info.win_title_bg
   --  local win_title_bg = CCZXImage:imageWithFile( _layout_info.x, _layout_info.y, _layout_info.w, _layout_info.h, _layout_info.img ) 
  	-- self.view:addChild( win_title_bg )
  	-- 标题 文字
  	-- _layout_info = self.page_info.win_title
   --  local win_title = CCZXImage:imageWithFile( _layout_info.x, _layout_info.y, _layout_info.w, _layout_info.h, _layout_info.img ) 
  	-- self.view:addChild( win_title )

    -- 大背景
    _layout_info = self.page_info.big_bg
    local big_bg = CCZXImage:imageWithFile( _layout_info.x, _layout_info.y, _layout_info.w, _layout_info.h, _layout_info.img, 500, 500 ) 
    self.view:addChild( big_bg )

    -- 美女图片
    _layout_info = self.page_info.girl_img
    local girl_img = CCZXImage:imageWithFile( _layout_info.x, _layout_info.y, _layout_info.w, _layout_info.h, _layout_info.img) 
    self.view:addChild( girl_img )

    self:create_luopan_area()
    self:create_info_area()

    -- 充值按钮
    local function recharge_event( eventType, x, y)         
        if eventType == TOUCH_CLICK then      
            -- Analyze:parse_click_main_menu_info(201) 
            GlobalFunc:chong_zhi_enter_fun() 
        end
        return true
    end
    self.chongzhi_btn = MUtils:create_btn(self.view,UILH_COMMON.lh_button_4_r,UILH_COMMON.lh_button_4_r,recharge_event,757,37,-1,-1)
    MUtils:create_zxfont(self.chongzhi_btn,Lang.vip.btn_recharge_text,121/2,20,2,16)

    -- -- 关闭按钮
    -- local function close_but_CB( )
    --     UIManager:hide_window( window_name )
    --     -- UIManager:destroy_window( window_name )
    -- end
    -- local close_but = UIButton:create_button_with_name( 0, 0, -1, -1, UIResourcePath.FileLocate.common .. "close_btn_n.png", UIResourcePath.FileLocate.common .. "close_btn_s.png", nil, "", close_but_CB )
    -- local exit_btn_size = close_but:getSize()
    -- local spr_bg_size = self.view:getSize()
    -- close_but:setPosition( spr_bg_size.width - exit_btn_size.width, spr_bg_size.height - exit_btn_size.height )
    -- self.view:addChild( close_but )

    LuopanModel:req_luopan_item_record(  )
    LuopanModel:req_luopan_my_item_record()
end

-- 创建罗盘区域
function LuoPanWin:create_luopan_area(  )
	self.luopan_page = LuoPanPage()
	self.view:addChild( self.luopan_page.view )
end

-- 创建信息区域
function LuoPanWin:create_info_area(  )
	-- 滚动信息区域背景1
    _layout_info = self.page_info.info_area_bg1
    local info_area_bg1 = CCZXImage:imageWithFile( _layout_info.x, _layout_info.y, _layout_info.w, _layout_info.h, _layout_info.img, 500, 500 ) 
  	self.view:addChild( info_area_bg1 )

    -- 滚动信息区域标题1
    local title_panel1 = CCBasePanel:panelWithFile( 0, 176, 290, 35, UILH_NORMAL.title_bg4, 500, 500 )
    info_area_bg1:addChild(title_panel1)
    MUtils:create_zxfont(title_panel1,Lang.luopan[1],290/2,11,2,15);

    -- 滚动信息区域背景2
    _layout_info = self.page_info.info_area_bg2
    local info_area_bg2 = CCZXImage:imageWithFile( _layout_info.x, _layout_info.y, _layout_info.w, _layout_info.h, _layout_info.img, 500, 500 ) 
    self.view:addChild( info_area_bg2 )

    -- 滚动信息区域标题2
    local title_panel2 = CCBasePanel:panelWithFile( 0, 176, 290, 35, UILH_NORMAL.title_bg4, 500, 500 )
    info_area_bg2:addChild(title_panel2)
    MUtils:create_zxfont(title_panel2,Lang.luopan[2],290/2,11,2,15);

  	-- 获得者标题
  	-- _layout_info = self.page_info.player_scroll_title
   --  local player_scroll_title = CCZXImage:imageWithFile( _layout_info.x, _layout_info.y, _layout_info.w, _layout_info.h, _layout_info.img, 500, 500 ) 
  	-- self.view:addChild( player_scroll_title )

  	--滑动区域顶部分割线
    -- _layout_info = self.page_info.split_line_top
    -- local split_line_top = CCZXImage:imageWithFile( _layout_info.x, _layout_info.y, _layout_info.w, _layout_info.h, _layout_info.img, 50, 50 );
    -- self.view:addChild( split_line_top );

  	-- 滑动区域， 奖励详细显示
	_layout_info = self.page_info.award_scroll
    local function create_func( panel_index )
        print("panel_index", panel_index)
        _layout_info = self.page_info.row_bg
        local one_row = self:create_one_row( 0, 0, _layout_info.w, _layout_info.h, _layout_info.img, panel_index )
        return one_row.view
    end
    self.row_scroll = MUtils:create_one_scroll( _layout_info.x, _layout_info.y, _layout_info.w, _layout_info.h, _layout_info.max_num, _layout_info.img, _layout_info.scroll_type, create_func )
    -- _layout_info = self.page_info.scroll_bar
    -- self.row_scroll:setScrollLump( _layout_info.bar_img, _layout_info.bar_w, _layout_info.bar_h, _layout_info.item_size )
    self.view:addChild( self.row_scroll )

    -- 我的珍品记录
    _layout_info = self.page_info.my_award_scroll
    local function create_func( panel_index )
        print("MY_panel_index", panel_index)
        _layout_info = self.page_info.row_bg
        local one_row = self:create_one_row_my( 0, 0, _layout_info.w, _layout_info.h, _layout_info.img, panel_index )
        return one_row.view
    end
    self.my_row_scroll = MUtils:create_one_scroll( _layout_info.x, _layout_info.y, _layout_info.w, _layout_info.h, _layout_info.max_num, _layout_info.img, _layout_info.scroll_type, create_func )
    self.view:addChild( self.my_row_scroll )

  	-- 活动说明标题
  	-- _layout_info = self.page_info.explain_title
   --  local explain_title = CCZXImage:imageWithFile( _layout_info.x, _layout_info.y, _layout_info.w, _layout_info.h, _layout_info.img, 500, 500 ) 
  	-- self.view:addChild( explain_title )

    -- 说明内容
  	-- _layout_info = self.page_info.explain_content_1
   --  local explain_content_1 = UILabel:create_lable_2( _layout_info.words, _layout_info.x, _layout_info.y, _layout_info.size, _layout_info.align )
   --  self.view:addChild( explain_content_1 )

    -- 活动说明
    _layout_info = self.page_info.explain_content_2
    local explain_content_2 = UILabel:create_lable_2( _layout_info.words, _layout_info.x, _layout_info.y, _layout_info.size, _layout_info.align )
    self.view:addChild( explain_content_2 )

    _layout_info = self.page_info.explain_content_3
    local explain_content_3 = UILabel:create_lable_2( _layout_info.words, _layout_info.x, _layout_info.y, _layout_info.size, _layout_info.align )
    self.view:addChild( explain_content_3 )

    -- 活动时间标题
    _layout_info = self.page_info.activity_time_title_label
    local activity_time_title_label = UILabel:create_lable_2( _layout_info.words, _layout_info.x, _layout_info.y, _layout_info.size, _layout_info.align )
    self.view:addChild( activity_time_title_label )

    -- 活动时间
    local function count_down_end_callback()
        if self.remainTimeLabel ~= nil then
            self.remainTimeLabel:setString(Lang.luopan[9])  -- [9] = "活动已截止",
        end
    end
    _layout_info = self.page_info.activity_time_label
    self.remainTimeLabel = TimerLabel:create_label(self.view,_layout_info.x,_layout_info.y,_layout_info.size,0, "", count_down_end_callback, false, ALIGN_LEFT,false)

    -- 获取活动时间进行设置
    local t_remainTime = SmallOperationModel:getActivityRemainTime(_luopan_activity_id)
    if t_remainTime == 0 then
        self.remainTimeLabel:setString(Lang.luopan[9])  -- [9] = "活动已截止",
    else
        self.remainTimeLabel:setText(t_remainTime)
    end

    -- _layout_info = self.page_info.explain_content_4
    -- local explain_content_4 = UILabel:create_lable_2( _layout_info.words, _layout_info.x, _layout_info.y, _layout_info.size, _layout_info.align )
    -- self.view:addChild( explain_content_4 )

    -- 月饼 title
    _layout_info = self.page_info.moon_cake_num_title
    local moon_cake_num_title = UILabel:create_lable_2( _layout_info.words, _layout_info.x, _layout_info.y, _layout_info.size, _layout_info.align )
    self.view:addChild( moon_cake_num_title )
    -- 数量
    _layout_info = self.page_info.moon_cake_num
    self.moon_cake_num = UILabel:create_lable_2( _layout_info.words, _layout_info.x, _layout_info.y, _layout_info.size, _layout_info.align )
    self.view:addChild( self.moon_cake_num )

    -- 元宝 title
    _layout_info = self.page_info.yuanbao_title
    local yuanbao_title = UILabel:create_lable_2( _layout_info.words, _layout_info.x, _layout_info.y, _layout_info.size, _layout_info.align )
    self.view:addChild( yuanbao_title )
    -- 元宝数量
    _layout_info = self.page_info.yuanbao
    self.yuanbao = UILabel:create_lable_2( _layout_info.words, _layout_info.x, _layout_info.y, _layout_info.size, _layout_info.align )
    self.view:addChild( self.yuanbao )
    -- 抽元宝次数
    -- _layout_info = self.page_info.need_yuanbao
    -- local yuanbao_need = UILabel:create_lable_2( _layout_info.words, _layout_info.x, _layout_info.y, _layout_info.size, _layout_info.align )
    -- self.view:addChild( yuanbao_need )

    -- -- 充值按钮
    -- _layout_info = self.page_info.recharge_but
    -- local function but_func()
    --     UIManager:show_window( "chong_zhi_win" )
    -- end
    -- self.recharge_but = UIButton:create_button_with_name( _layout_info.x, _layout_info.y, _layout_info.w, _layout_info.h, _layout_info.img_n, _layout_info.img_s, nil, nil, but_func )
    -- self.view:addChild( self.recharge_but );
    -- 跳过动画
    local function use_shield_fun(if_selected)
        -- local _is_pass_ani = LuopanModel:get_is_pass_ani();
        -- LuopanModel:set_is_pass_ani( not _is_pass_ani )
        print("设置跳过动画",if_selected)
        LuopanModel:set_is_pass_ani(if_selected)
    end
    self.is_pass_ani_view = UIButton:create_switch_button2(221,132, 120, 35, UILH_COMMON.dg_sel_1, UILH_COMMON.dg_sel_2, Lang.luopan[3], 40, 13, 16, nil, nil, nil, nil, use_shield_fun )  -- 跳过动画
    self.view:addChild(self.is_pass_ani_view.view);
    self.is_pass_ani_view.set_state(LuopanModel:get_is_pass_ani(),true);

    -- 一键十次
    local function key_to_ten_fun(if_selected)
        -- local _key_to_ten = LuopanModel:get_is_key_to_ten();
        -- LuopanModel:set_is_key_to_ten( not _key_to_ten )
        print("设置一键十次",if_selected)
        LuopanModel:set_is_key_to_ten(if_selected)
    end
    local key_to_ten_view = UIButton:create_switch_button2(410,132, 120, 35, UILH_COMMON.dg_sel_1, UILH_COMMON.dg_sel_2, Lang.luopan[4], 40, 13, 16, nil, nil, nil, nil, key_to_ten_fun )  -- 一键十次
    self.view:addChild(key_to_ten_view.view);
    key_to_ten_view.set_state(LuopanModel:get_is_key_to_ten(),true);
end

function LuoPanWin:set_skip_animation(is_skip)
    self.is_pass_ani_view.set_state(is_skip,true)
end

-- 创建 珍品获得者 scroll
function LuoPanWin:create_all_rows_bg(  )
	local recharge_award_list = LuopanModel:get_appear_items(  )
    local row_num = #recharge_award_list                      -- 奖励数量

    -- scroll的一个项， 所有行的背景
	_layout_info = self.page_info.scroll_bg
    local scroll_bg_h = row_num * self.page_info.scroll_row_height          -- 计算背景的高度
	self.rows_bg_panel = self:panelWithFile( _layout_info.x, _layout_info.y, _layout_info.w, scroll_bg_h, _layout_info.img )
    
    -- 创建所有行放到背景中
    for i = 1, row_num do 
        _layout_info = self.page_info.row_bg
        local row_y = scroll_bg_h - i * _layout_info.h        -- 计算该行在背景中的h坐标
        local one_row = self:create_one_row( _layout_info.x, row_y, _layout_info.w, _layout_info.h, _layout_info.img, i )
        self.rows_bg_panel:addChild( one_row.view )
    end
    
	return self.rows_bg_panel
end

-- 创建一行
function LuoPanWin:create_one_row( x, y, w, h, img, index )
    local one_row = {}

    one_row.view = CCBasePanel:panelWithFile( x, y, w, h, img )    --背景
    local row_info = LuopanModel:get_appear_item( index ) or {}

    -- 玩家名称
    _layout_info = self.page_info.row_player_name
    _layout_info.words = row_info.player_name or ""
    local row_player_name = UILabel:create_lable_2( _layout_info.words, _layout_info.x, _layout_info.y, _layout_info.size, _layout_info.align )
    one_row.view:addChild( row_player_name )

    -- 道具名称
    _layout_info = self.page_info.item_name
    _layout_info.words = row_info.item_name or ""
    local item_name = UILabel:create_lable_2( _layout_info.words, _layout_info.x, _layout_info.y, _layout_info.size, _layout_info.align )
    one_row.view:addChild( item_name )

    --分割线
    _layout_info = self.page_info.split_line
    local split_line = CCZXImage:imageWithFile( _layout_info.x, _layout_info.y, _layout_info.w, _layout_info.h, _layout_info.img );
    one_row.view:addChild( split_line );

    return one_row
end

-- 创建一行
function LuoPanWin:create_one_row_my( x, y, w, h, img, index )
    local one_row = {}

    one_row.view = CCBasePanel:panelWithFile( x, y, w, h, img )    --背景
    local row_info = LuopanModel:get_my_appear_item( index ) or {}

    -- 玩家名称
    _layout_info = self.page_info.row_player_name
    _layout_info.words = row_info.player_name or ""
    local row_player_name = UILabel:create_lable_2( _layout_info.words, _layout_info.x, _layout_info.y, _layout_info.size, _layout_info.align )
    one_row.view:addChild( row_player_name )

    -- 道具名称
    _layout_info = self.page_info.item_name
    _layout_info.words = row_info.item_name or ""
    local item_name = UILabel:create_lable_2( _layout_info.words, _layout_info.x, _layout_info.y, _layout_info.size, _layout_info.align )
    one_row.view:addChild( item_name )

    --分割线
    _layout_info = self.page_info.split_line
    local split_line = CCZXImage:imageWithFile( _layout_info.x, _layout_info.y, _layout_info.w, _layout_info.h, _layout_info.img );
    one_row.view:addChild( split_line );

    return one_row
end

-- 更新元宝和次数
function LuoPanWin:update_gold_and_remain(  )
    local remain_times = LuopanModel:get_remain_times(  ) or 0
    local gold_num = LuopanModel:get_gold_num(  ) or 0
    self.moon_cake_num:setString( remain_times )
    self.yuanbao:setString( gold_num )
end

-- 刷新珍宝记录
 function LuoPanWin:update_appear_item_info(  )
    -- 罗盘旋转，为防止手机网络延时较长问题，先得到结果，再开始旋转。旋转时间根据计算规则，不超过 * 秒。*秒后才更新珍宝记录
    -- local function callback_func(  )
        self.row_scroll:clear()
        self.row_scroll:refresh()    
    -- end
    -- if self.appear_info_cb then 
    --     self.appear_info_cb:cancel()
    --     self.appear_info_cb = nil    -- 刷新珍品 的控制时间回调 
    -- end
    -- self.appear_info_cb = callback:new()
    -- self.appear_info_cb:start( LuoPanPage.EXPECT_LUOPAN_ROTATE_TIME, callback_func )
 end

 -- 刷新我的珍宝记录
 function LuoPanWin:update_my_appear_item_info(  )
    self.my_row_scroll:clear()
    self.my_row_scroll:refresh()    
 end

-- 更新 静态方法
function LuoPanWin:update_static( update_type )
    local win = UIManager:find_visible_window( "luopan_win" )
    if win then 
        win:update( update_type )           -- 窗口更新
    end
end

-- 更新
function LuoPanWin:update( update_type )
    if update_type == "luopan_date"  then 
        self:update_gold_and_remain(  )
    elseif update_type == "appear_items" then 
        self:update_appear_item_info(  )
    elseif update_type == "my_appear_items" then 
        self:update_my_appear_item_info(  )
    elseif update_type == "luopan_result" then 
        self.luopan_page:begin_luopan(  )
    elseif update_type == "all" then 
        -- LuopanModel:req_luopan_item_record(  )
        LuopanModel:req_luopan_data(  )
        self.luopan_page:syn_luopan(  )
    end
end

function LuoPanWin:destroy(  )
    if self.luopan_page and self.luopan_page.destroy then
        self.luopan_page:destroy()
    end

    Window.destroy(self)
    if self.appear_info_cb then 
        self.appear_info_cb:cancel()
        self.appear_info_cb = nil    -- 刷新珍品 的控制时间回调 
    end
    --销毁时间控件
    self.remainTimeLabel:destroy()
    self.remainTimeLabel = nil;
end

--
function LuoPanWin:active( active )
    if active then 
        self:update( "all" )
    end
end