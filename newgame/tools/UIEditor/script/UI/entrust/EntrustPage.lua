-- EntrustPage.lua  
-- created by lyl on 2013-5-16
--alter by xiehande 2014-11-15
--去除 entrust_win_config配置文件
-- 副本委托页

super_class.EntrustPage(Window)
local _page_info = nil
local _layout_info = nil            -- 布局信息临时变量

local fuben_list_ids = {
--破狱之战
[58] = {58,98,99,100,101,102},
--皇陵秘境
[65] = {65,84,85,86,87,88,},
--天魔塔
[64] = {64,114,115,116,117,118}
}


function EntrustPage:create(  )
    --创建页面信息数据
    return EntrustPage("EntrustPage", UILH_COMMON.normal_bg_v2,true, 890, 560 )
end

function EntrustPage:__init( window_name, texture_name )
	self.times_select_but_t = {}                 -- 次数选择按钮
	-- self.times_but_curr = 1                      -- 当前选择的委托次数
    self.cangku_item_t = {}                      -- 存放仓库道具的表
    self.current_fuben_id = nil                  -- 先前显示的副本id
    self.current_times_t = {
        [EntrustModel.lilianfuben]     = 4,
        [EntrustModel.zhuxianzhen]     = 3,
        [EntrustModel.shangjinfuben]   = 4,
        [EntrustModel.huantianmijing]  = 4,
        [EntrustModel.xinmohuanjing]   = 4,
        [EntrustModel.mojierukou]      = 4,
        [EntrustModel.xuantianfengyin] = 4,
        [EntrustModel.tianmota]        = 4,
    }
    
        -- 副本配置数据
    local fuben_list_data = ActivityModel:get_activity_info_by_class( "fuben" )
    self._fuben_list_data = fuben_list_data


    self:create_right_panel(self.view)
    self:update_award()
end


--创建右边
function EntrustPage:create_right_panel(panel)
    local right_panel = CCBasePanel:panelWithFile(239, 12, 637, 537, UILH_COMMON.bottom_bg, 500, 500)
    panel:addChild(right_panel)
    self:create_right_top(right_panel,0, 245-30, 640, 290+30,"")
    -- self:create_right_middle(right_panel)
    self:create_right_down(right_panel,0,0,640, 148+70, "")
    return right_panel
end


--创建右上
function EntrustPage:create_right_top(panel,x,y,w,h,img)
    
    --右上面板
    self.right_top_panel = CCBasePanel:panelWithFile(x,y,w,h,img)
    panel:addChild(self.right_top_panel)

    local y_gas = 30
    local layout_y = 298
        -- 需要等级
     _layout_info = {x = 24 , y = layout_y, size = 16}
    get_info = {x = _layout_info.x+100, y = _layout_info.y, size = 16}
    local need_level_title = UILabel:create_lable_2( LH_COLOR[2]..Lang.entrust[2],_layout_info.x,_layout_info.y, _layout_info.size,ALIGN_LEFT)
    self.right_top_panel:addChild( need_level_title )

    self.need_level = UILabel:create_lable_2( "0",get_info.x ,get_info.y,get_info.size, ALIGN_LEFT )
    self.right_top_panel:addChild( self.need_level )
    
    -- 需要时间
    _layout_info = {x = 228 , y = layout_y, size = 16}
    get_info = {x = _layout_info.x+100, y = _layout_info.y, size = 16}
    local need_time_title = UILabel:create_lable_2(  LH_COLOR[2]..Lang.entrust[3],_layout_info.x,  _layout_info.y, _layout_info.size, ALIGN_LEFT ) 
    self.right_top_panel:addChild( need_time_title )
    self.need_time = UILabel:create_lable_2( "0", get_info.x, get_info.y ,  get_info.size, ALIGN_LEFT )
    self.right_top_panel:addChild( self.need_time )



    -- 获得经验
    layout_y = layout_y -y_gas
    _layout_info = {x = 24 , y = layout_y, size = 16}
    get_info = {x = _layout_info.x+100 , y = _layout_info.y, size = 16}
    self.get_exp_title = UILabel:create_lable_2( LH_COLOR[2]..Lang.entrust[4], _layout_info.x, _layout_info.y, _layout_info.size, ALIGN_LEFT ) -- [919]="#c66ff66获得经验："
    self.right_top_panel:addChild( self.get_exp_title )
    self.get_exp = UILabel:create_lable_2( "0", get_info.x, get_info.y, get_info.size, ALIGN_LEFT )
    self.right_top_panel:addChild( self.get_exp )


    -- 获得历练  (坐标和 “获得经验”一样)
    self.get_lilian_title = UILabel:create_lable_2(  LH_COLOR[2]..Lang.entrust[5], _layout_info.x, _layout_info.y, _layout_info.size, ALIGN_LEFT ) -- [920]="#c66ff66获得历练："
    self.right_top_panel:addChild( self.get_lilian_title )
    self.get_lilian = UILabel:create_lable_2( "0", get_info.x, get_info.y, get_info.size, ALIGN_LEFT )
    self.right_top_panel:addChild( self.get_lilian )

    -- 获得铜币  (坐标和 “获得经验”一样)
    self.get_xianbi_title = UILabel:create_lable_2(  LH_COLOR[2]..Lang.entrust[6], _layout_info.x, _layout_info.y, _layout_info.size, ALIGN_LEFT ) -- [921]="#c66ff66获得仙币："
    self.right_top_panel:addChild( self.get_xianbi_title )
    self.get_xianbi = UILabel:create_lable_2( "0", get_info.x, get_info.y, get_info.size, ALIGN_LEFT )
    self.right_top_panel:addChild( self.get_xianbi )

    -- 获得银两  (坐标和 “获得经验”一样)
     _layout_info = {x = 228 , y = layout_y, size = 16}
    get_info = {x = _layout_info.x+100 , y = _layout_info.y, size = 16}
    self.get_yingliang_title = UILabel:create_lable_2(  LH_COLOR[2]..Lang.entrust[7], _layout_info.x, _layout_info.y, _layout_info.size, ALIGN_LEFT ) -- [922]="#c66ff66获得银两："
    self.right_top_panel:addChild( self.get_yingliang_title )
    self.get_yingliang = UILabel:create_lable_2( "0", get_info.x, get_info.y, get_info.size, ALIGN_LEFT )
    self.right_top_panel:addChild( self.get_yingliang )


   layout_y = layout_y - y_gas
        -- 委托层数
    _layout_info = { x = 24 , y = layout_y, size = 16}
    self.entrust_level_title = UILabel:create_lable_2(  LH_COLOR[2]..Lang.entrust[9], _layout_info.x, _layout_info.y, _layout_info.size, ALIGN_LEFT ) -- [924]="#c66ff66委托层数："
    self.right_top_panel:addChild( self.entrust_level_title )

    -- 可委托层数
    _layout_info = { x = 140 , y = layout_y, size = 16}
    self.can_entrust_num = UILabel:create_lable_2(  LH_COLOR[2]..Lang.entrust[10], _layout_info.x, _layout_info.y, _layout_info.size, ALIGN_LEFT ) -- [925]="19层#c35c3f7(历史最高通关层数)"
    self.right_top_panel:addChild( self.can_entrust_num )

    layout_y = layout_y - y_gas
    self.get_jiangli_title = UILabel:create_lable_2( LH_COLOR[2]..Lang.entrust[44],24, 205, _layout_info.size, ALIGN_LEFT ) 
    self.right_top_panel:addChild( self.get_jiangli_title )


    -- 创建次数选择按钮
    self:create_times_select( self.right_top_panel )
    self:set_select_times_but(  ) 


    --竖线分割
    local frame_bg_3 = CCZXImage:imageWithFile( 500 , 3, 3,  h-10,  UILH_COMMON.split_line_v)           -- 线
    self.right_top_panel:addChild( frame_bg_3 )
     


    --铜币委托 元宝委托面板
    local right_top_r_panel = CCBasePanel:panelWithFile(507, 2, 130, 290, "")
    self.right_top_panel:addChild(right_top_r_panel)
     -- 神秘商店按钮
    _layout_info =  { x = 375+80 , y = 200, w = -1, h = -1, normal_image = UILH_COMMON.btn4_nor, select_image =UILH_COMMON.btn4_nor }

    local function mystical_shop_but_func()
        -- print("神秘商店。。。")
        EntrustModel:open_mystical_shop(  )
    end
    self.mystical_shop_but = UIButton:create_button_with_name( _layout_info.x, _layout_info.y, _layout_info.w, _layout_info.h, _layout_info.normal_image, _layout_info.select_image, nil, "", mystical_shop_but_func, true )
    self.mystical_shop_but.view:addChild( UILabel:create_lable_2( LH_COLOR[2].. Lang.entrust[11], 12, 6, 16, ALIGN_LEFT ) ) -- [926]="神秘商店"
    right_top_r_panel:addChild( self.mystical_shop_but.view )

    local layout_y = 250
    local y_gas = 110
    -- 铜币委托按钮
    _layout_info ={ x = 0 , y = layout_y, w = -1, h = -1, normal_image = UILH_COMMON.btn4_nor, select_image = UILH_COMMON.btn4_nor }
    local function xianbi_but_func()
        EntrustModel:request_entrust( self.current_fuben_id, 0, self:get_current_times(  ) )
    end
    self.xianbi_but = UIButton:create_button_with_name( _layout_info.x, _layout_info.y, _layout_info.w, _layout_info.h, _layout_info.normal_image, _layout_info.select_image, nil, "", xianbi_but_func, true )
    self.xianbi_but.view:addChild( UILabel:create_lable_2( LH_COLOR[2].. Lang.entrust[12], 24, 21, 16, ALIGN_LEFT ) ) -- [927]="仙币委托"
    right_top_r_panel:addChild( self.xianbi_but.view )   



    -- 元宝委托按钮
    layout_y = layout_y -y_gas
    _layout_info = { x = 0 , y = layout_y, w = -1, h = -1, normal_image = UILH_COMMON.lh_button_4_r, select_image = UILH_COMMON.lh_button_4_r }
    local function yuanbao_but_func()
        EntrustModel:request_entrust( self.current_fuben_id, 1, self:get_current_times(  ) )
    end
    self.yuanbao_but = UIButton:create_button_with_name( _layout_info.x, _layout_info.y, _layout_info.w, _layout_info.h, _layout_info.normal_image, _layout_info.select_image, nil, "", yuanbao_but_func, true )
    self.yuanbao_but.view:addChild( UILabel:create_lable_2( LH_COLOR[2].. Lang.entrust[13], 24, 21, 16, ALIGN_LEFT ) ) -- [928]="元宝委托"
    right_top_r_panel:addChild( self.yuanbao_but.view )  


    -- 元宝委托提示
    _layout_info =  { x = -17 , y = 127, size = 14}         -- 元宝委托提示
    self.yuanbao_notice = UILabel:create_lable_2( Lang.entrust[14], _layout_info.x, _layout_info.y, _layout_info.size, ALIGN_LEFT ) -- [929]="#c35c3f7可获得#cffff00125%#c35c3f7的经验"
    right_top_r_panel:addChild( self.yuanbao_notice )

    -- 委托次数
    -- _layout_info = {x = 24 , y = 110, size = 16}
    -- self.entrust_count_title = UILabel:create_lable_2( Lang.entrust[8], _layout_info.x, _layout_info.y, _layout_info.size, ALIGN_LEFT ) -- [923]="#c66ff66委托次数："
    -- self.right_top_panel:addChild( self.entrust_count_title )

    --增加副本次数

    _layout_info = { x = 0 , y = 24,   w = -1, h = -1, normal_image =UILH_COMMON.btn4_nor, select_image = UILH_COMMON.btn4_nor }
    local function add_times_but_func()
        if self.current_fuben_id == 58 or self.current_fuben_id == 64 or self.current_fuben_id == 65 then
            ActivityModel:apply_add_enter_fuben_count( self.current_fuben_id,true)
        else
            ActivityModel:apply_add_enter_fuben_count( self.current_fuben_id,false)
        end

    end
    --增加次数
    self.add_times_but = UIButton:create_button_with_name(_layout_info.x, _layout_info.y,  _layout_info.w, _layout_info.h, _layout_info.normal_image, _layout_info.select_image, nil, "", add_times_but_func, true )
    self.add_times_but.view:addChild( UILabel:create_lable_2( LH_COLOR[2]..Lang.entrust[20], 24, 21, 16, ALIGN_LEFT ) ) -- [2320]="增加次数"
    right_top_r_panel:addChild( self.add_times_but.view )    

end


-- 更新副本奖励
function EntrustPage:update_award(  )
    local activity_id = nil
    for i=1,#self._fuben_list_data do
        if self.current_fuben_id then
            if self._fuben_list_data[i].FBID == self.current_fuben_id then
                activity_id =  self._fuben_list_data[i].id
                break
            end
        end
    end
    -- 道具
    local item_t = ActivityModel:get_fuben_activity_award_items( activity_id )
    if self.award_item_list then
         self.right_top_panel:removeChild( self.award_item_list, true)
    end
    if #item_t > 0 then
        self.award_item_list = self:create_item_horizontal_two_row( item_t , 119, 91, 55, 55, 72,72,2,5)
        self.right_top_panel:addChild( self.award_item_list )
    end
end

function EntrustPage:create_item_horizontal_two_row( panel_table_para , pos_x, pos_y, item_w, item_h, item_inter_x,item_inter_y,row_num,col_num )
    require "UI/activity/ActivityCommon"
    local item_panel = ActivityCommon:create_item_horizontal_two_row(panel_table_para, pos_x, pos_y, item_w, item_h, item_inter_x,item_inter_y,row_num,col_num)
    return item_panel
end

--创建右中
-- function  EntrustPage:create_right_middle(panel )
--     local right_mid_panel = CCBasePanel:panelWithFile(0, 147, 640, 145, "", 500, 500)
--     panel:addChild(right_mid_panel)
--     -- 当前委托信息
--     -- _layout_info = _page_info.entrusting_dialog
--     -- self.entrusting_dialog = CCDialog:dialogWithFile( _layout_info.x, _layout_info.y, _layout_info.w, _layout_info.h, 20, "", TYPE_HORIZONTAL, ADD_LIST_DIR_UP )
--     -- self.entrusting_dialog:setText( "第X次" )
--     -- panel:addChild( self.entrusting_dialog )
--     -- 委托结果
--     _layout_info = { x = 16 , y = 112, size = 16}          -- 委托结果显示
--     self.entrust_result = UILabel:create_lable_2( "", _layout_info.x, _layout_info.y, _layout_info.size, ALIGN_LEFT )
--     right_mid_panel:addChild( self.entrust_result )

-- end



--创建右下
function EntrustPage:create_right_down( panel,x,y,w,h,img)  
    local right_down_panel = CCBasePanel:panelWithFile(x,y,w,h,img, 500, 500)
    panel:addChild(right_down_panel)
    
    --横线
    local frame_bg= CCZXImage:imageWithFile( 12 ,  h-6, w-25,  3,  UILH_COMMON.split_line)           -- 线
    right_down_panel:addChild( frame_bg )


    local title_bg = CCZXImage:imageWithFile( 1, 172, -1, -1, UILH_ENTRUST.month_bg, 500, 500 )
    --标题图片
    MUtils:create_zximg(title_bg,UILH_ENTRUST.weituo_cangku,6,7,-1,-1)
    right_down_panel:addChild(title_bg)


    _layout_info = { x = 148 , y = 186, size = 14}          -- 委托前须清理仓库
    local get_but_notice_1 = UILabel:create_lable_2(LH_COLOR[2]..Lang.entrust[1], _layout_info.x, _layout_info.y, _layout_info.size, ALIGN_LEFT ) -- [933]="#c35c3f7委托前须清理仓库"
    right_down_panel:addChild( get_but_notice_1 )



     -- 剩余时间
    _layout_info = { x = 518 , y = 113, size = 16}         -- 剩余时间
    self.remain_time_title = UILabel:create_lable_2(LH_COLOR[2]..Lang.entrust[15], _layout_info.x, _layout_info.y, _layout_info.size, ALIGN_LEFT ) -- [930]="#c66ff66剩余时间"
    right_down_panel:addChild( self.remain_time_title )
    _layout_info =  { x = 539 , y = 77, size = 16}         -- 剩余时间
    self.remain_time = UILabel:create_lable_2( "0:0:0", _layout_info.x, _layout_info.y, _layout_info.size, ALIGN_LEFT )
    right_down_panel:addChild( self.remain_time )
    -- self.remain_time = TimerLabel:create_label( panel, _layout_info.x, _layout_info.y, _layout_info.size, 60 * 60 * 24, "#cffff00", nil, true, ALIGN_LEFT )


    -- 委托结果
    -- _layout_info = { x = 16 , y = 112, size = 16}          -- 委托结果显示
    -- self.entrust_result = UILabel:create_lable_2( "", _layout_info.x, _layout_info.y, _layout_info.size, ALIGN_LEFT )
    -- right_down_panel:addChild( self.entrust_result )


    -- 立刻完成按钮
    _layout_info = { x = 502 , y = 9, w = -1, h = -1, normal_image =UILH_COMMON.btn4_nor, select_image = UILH_COMMON.btn4_nor,disable_image = UILH_COMMON.btn4_dis }
    local function complete_but_func()
        EntrustModel:request_complete_immediately( self.current_fuben_id )
    end
    self.complete_but = UIButton:create_button_with_name( _layout_info.x, _layout_info.y, _layout_info.w, _layout_info.h, _layout_info.normal_image, _layout_info.select_image, _layout_info.disable_image, "", complete_but_func, true )
    self.complete_but.view:addTexWithFile(CLICK_STATE_DISABLE, _layout_info.disable_image )
    self.complete_but.view:addChild( UILabel:create_lable_2( LH_COLOR[2]..Lang.entrust[16] , 24, 21, 16, ALIGN_LEFT ) ) -- [931]="立刻完成"
    right_down_panel:addChild( self.complete_but.view )  


    --委托仓库
    self:create_cangku_item(right_down_panel)

        -- 领取经验按钮
    _layout_info = { x = 503 , y = 104, w = -1, h = -1, normal_image = UILH_COMMON.btn4_nor, select_image =  UILH_COMMON.btn4_nor,disable_image = UILH_COMMON.btn4_dis}

    local function get_exp_but_func()
        if EntrustModel:check_if_had_not_get_award( self.current_fuben_id ) then 
            EntrustModel:request_get_exp( self.current_fuben_id )
        end
        EntrustModel:request_depot_item_move_to_bag( 0 )
        -- 领取完后，结果清空
        -- EntrustModel:set_entrust_result_str( self.current_fuben_id, ""  )
        -- print("领取经验按钮")
    end
    self.get_exp_but = UIButton:create_button_with_name( _layout_info.x, _layout_info.y, _layout_info.w, _layout_info.h, _layout_info.normal_image, _layout_info.select_image, nil, "", get_exp_but_func, true )
    self.get_exp_but.view:addTexWithFile(CLICK_STATE_DISABLE, _layout_info.disable_image )
    self.get_exp_but.view:addChild( UILabel:create_lable_2( LH_COLOR[2].. Lang.entrust[17], 24, 21, 16, ALIGN_LEFT ) ) -- [932]="领取奖励"
    right_down_panel:addChild( self.get_exp_but.view )  
end



-- 创建仓库道具列表
function EntrustPage:create_cangku_item( panel)
	_layout_info= { begin_x = 14 , begin_y = 2, interval_x = 80, interval_y = 80, column_num = 15, rows_num = 2  }
	local begin_x = _layout_info.begin_x
	local begin_y = _layout_info.begin_y
	local interval_x = _layout_info.interval_x
	local interval_y = _layout_info.interval_y
	local column_num = _layout_info.column_num
	local rows_num = _layout_info.rows_num
    --local temp_item_info = {}
    local temp_base_panel = BasePanel:create( nil, 0, 0, interval_x * column_num, interval_y * rows_num )
    for i = 1, column_num do --x
        for j = 1, rows_num do --y
            self:create_one_slotItem( temp_base_panel.view, (i - 1) *  rows_num + j, 5 + interval_x * ( i - 1), 5 + interval_y * ( rows_num - j ),70,70) 
        end
    end
    -- for j = 1, column_num do --15
    --    for i = 1, rows_num do --2
    --        self:create_one_slotItem( temp_base_panel.view, (i - 1) * column_num + j, 5 + interval_x * ( j - 1) , 5 + interval_y * ( i - 1 ) )
    --    end
    -- end
    local scroll = Scroll:create( nil, begin_x, begin_y , 483, 180, 1, TYPE_VERTICAL )
    --scroll.view:setTexture("ui/common/bg03.png")
    scroll:addItem( temp_base_panel )
    panel:addChild( scroll.view )
end

-- 创建一个空的道具slot，数值等刷新的时候设置
function EntrustPage:create_one_slotItem( panel, index, x, y, w, h )
	-- print(index)
	local slotItem = MUtils:create_one_slotItem( nil, x, y, w, h  )
	slotItem.index = index

    -- 单击回调
    local function item_click_fun ()
        if slotItem.item_date then       -- item_date 会在设置数据的时候设置上去
            EntrustModel:show_tips( slotItem.item_date )
        end
    end
    slotItem:set_click_event( item_click_fun )

	panel:addChild( slotItem.view )
    self.cangku_item_t[ index ] = slotItem
    return slotItem
end


-- 创建次数选择
function EntrustPage:create_times_select( panel )
    local times_select_but = { begin_x = 20 , begin_y = 0, interval = 120, normal_image = UI_WELFARE.btn_gray, select_image = UI_WELFARE.btn_gray, but_area_w = -1, but_area_h = -1 }
    local begin_x = times_select_but.begin_x               -- 第一个的位置
    local begin_y = times_select_but.begin_y
    local interval = times_select_but.interval             -- 间隔
    local but_area_w = times_select_but.but_area_w         -- 每个的响应区域
    local but_area_h = times_select_but.but_area_h
    local normal_image = times_select_but.normal_image     -- 非选中状态图片
    local select_image = times_select_but.select_image     -- 选中状态图片

    self:create_one_switch_but( panel, begin_x+ interval * ( 1 - 1 ) , begin_y , but_area_w, but_area_h, normal_image, select_image, "", 27, 14, 1 ) -- [934]="1次"
    self:create_one_switch_but( panel, begin_x+ interval * ( 2 - 1 ), begin_y , but_area_w, but_area_h, normal_image, select_image, "", 27, 14, 2 ) -- [935]="2次"
    self:create_one_switch_but( panel, begin_x+ interval * ( 3 - 1 ),  begin_y  , but_area_w, but_area_h, normal_image, select_image, "", 27, 14, 3 ) -- [936]="3次"
    self:create_one_switch_but( panel, begin_x+ interval * ( 4 - 1 ) , begin_y , but_area_w, but_area_h, normal_image, select_image, "", 27, 14, 4 ) -- [937]="4次"


end


-- 创建一个次数选择开关
function EntrustPage:create_one_switch_but( father_node, x, y, w, h, image_n, image_s, words, words_x, fontsize, but_key )

    local function switch_button_func(  )
        self:set_current_times( but_key )
    	self:set_select_times_but(  )
        self:update_entrust_info(  )
        --更新副本奖励
        self:update_award()
    end
	-- local switch_but = UIButton:create_switch_button( x, y, w, h, image_n, image_s, words, words_x, fontsize, nil, nil, nil, nil, switch_button_func )

    switch_but = UIButton:create_button_with_name( x, y, w, h,image_n, image_s, nil, "", switch_button_func )
	switch_but.but_key = but_key

         --选中框
    switch_but.select_frame = MUtils:create_zximg(switch_but.view, UI_WELFARE.again_select, -4, -5, -1, -1);
    switch_but.select_frame:setIsVisible(false)
    
    if but_key == 1 then
        switch_but.num_img =  MUtils:create_zximg(switch_but.view, UILH_ENTRUST.one, 24,32, -1, -1);
    elseif but_key ==2 then
         switch_but.num_img =  MUtils:create_zximg(switch_but.view, UILH_ENTRUST.two, 24,32, -1, -1);
    elseif but_key==3 then
         switch_but.num_img =  MUtils:create_zximg(switch_but.view, UILH_ENTRUST.three, 24,32, -1, -1);
    elseif but_key ==4 then
         switch_but.num_img = MUtils:create_zximg(switch_but.view, UILH_ENTRUST.four, 24,32, -1, -1);
    end

	father_node:addChild( switch_but.view )
	self.times_select_but_t[ but_key ] = switch_but


	return switch_but
end

-- 设置次数选择
function EntrustPage:set_select_times_but(  )
	for key, switch_but in pairs(self.times_select_but_t) do
        -- switch_but.set_state( false )
         switch_but.select_frame:setIsVisible(false)
	end

    local curr_times = self:get_current_times(  )
	if curr_times and self.times_select_but_t[ curr_times ] then
        -- self.times_select_but_t[ curr_times ].set_state( true )
        self.times_select_but_t[ curr_times ].select_frame:setIsVisible(true)
	end
end

-- 获取当前选择的次数
function EntrustPage:get_current_times(  )
    -- print("EntrustPage:get_current_times:",self.current_times_t[ self.current_fuben_id ])
    return self.current_times_t[ self.current_fuben_id ]
end

-- 设置当前选择的次数
function EntrustPage:set_current_times( curr_times )
    -- print("EntrustPage:set_current_times:",curr_times)
    self.current_times_t[ self.current_fuben_id ] = curr_times
end

-- 更新副本委托基础信息信息( 跟动态数据无关的信息 )
function EntrustPage:update_entrust_base_info(  )
    if self.current_fuben_id then
        local entrust_base_info = EntrustModel:get_entrust_base_info( self.current_fuben_id )
        if entrust_base_info then
            self.need_level:setString( entrust_base_info.level )
        end
    end
    self:set_select_times_but(  )
end

-- 更新副本委托动态数据信息
function EntrustPage:update_entrust_info(  )
    if self.current_fuben_id then
        -- 委托次数
        self:update_entrust_times_but(  )

        -- 需要时间
        local need_time = EntrustModel:calculate_need_time( self.current_fuben_id )
        local cur_fuben_count = self:get_current_times()
        need_time = cur_fuben_count * need_time
        local need_time_str = Utils:formatTime( need_time, false )
        self.need_time:setString( need_time_str )

        -- 获得经验
        local total_exp = EntrustModel:calculate_total_award_by_type( self.current_fuben_id, 1 )
        total_exp = cur_fuben_count * total_exp
        self.get_exp:setString( total_exp )

        -- 获得历练
        local total_lilian = EntrustModel:calculate_total_award_by_type( self.current_fuben_id, 2 )
        total_lilian = cur_fuben_count * total_lilian
        self.get_lilian:setString( total_lilian )

        -- 获得仙币
        local total_xianbi = EntrustModel:calculate_total_award_by_type( self.current_fuben_id, 3 )
        total_xianbi = cur_fuben_count * total_xianbi
        self.get_xianbi:setString( total_xianbi )

        -- 获得银两
        local total_yingliang = EntrustModel:calculate_total_award_by_type( self.current_fuben_id, 4 )
        total_yingliang = cur_fuben_count * total_yingliang
        self.get_yingliang:setString( total_yingliang )

        -- 委托层数
        local max_tier = EntrustModel:get_max_entrust_tier( self.current_fuben_id )
        self.can_entrust_num:setString( max_tier..Lang.entrust[18])  -- [938]="层#c35c3f7(历史最高通关层数)"

        -- 神秘商店的显示
        self:update_mystical_shop_but(  )
        
        --更新领取奖励按钮显示
        self:update_get_exp_but(  )


        --更新立即完成按钮
        self:update_complete_but()
    end
end

-- 更新领取奖励按钮  当可以领取的时候才可以点击
function EntrustPage:update_get_exp_but(  )
    if EntrustModel:check_if_had_not_get_award( self.current_fuben_id ) or EntrustModel:check_depot_exist_item(  ) then

        self.get_exp_but.view:setCurState( CLICK_STATE_UP )        
        LuaEffectManager:stop_view_effect( 9,self.get_exp_but.view ); 
        LuaEffectManager:play_view_effect( 9, 50, 15, self.get_exp_but.view, false )
    else
        self.get_exp_but.view:setCurState( CLICK_STATE_DISABLE )  
        -- LuaEffectManager:stop_view_effect( 9,self.get_exp_but );      
    end
end

-- 更新最大委托次数选项
function EntrustPage:update_entrust_times_but(  )
    -- local max_times = EntrustModel:get_fuben_remain_times( self.current_fuben_id )
    local max_times=0
    --如果存在 则是分层副本 取各层中最少的副本次数
    local temp = 10
    if fuben_list_ids[self.current_fuben_id] then
       for i,v in ipairs(fuben_list_ids[self.current_fuben_id]) do
           if ActivityModel:get_enter_fuben_count(v) <= temp then
              temp = ActivityModel:get_enter_fuben_count(v) 
           end
       end
       max_times = temp
    else
    --其他副本 
       max_times = ActivityModel:get_enter_fuben_count(self.current_fuben_id) 
    end
    
    if max_times == nil then
       max_times = EntrustModel:get_fuben_remain_times( self.current_fuben_id )
    end

    -- 把大于可选次数的选择隐藏
    for key, times_but in pairs( self.times_select_but_t ) do
        if times_but.but_key > max_times then
            times_but.view:setIsVisible( false )
        else
            times_but.view:setIsVisible( true )
        end
    end
    if max_times < self:get_current_times(  ) then
        -- self.times_but_curr = max_times
        self:set_current_times( max_times )
        self:set_select_times_but()
    elseif max_times > 0 and self:get_current_times(  ) <= 0 then
        self:set_current_times( max_times )
        self:set_select_times_but()
    end
    if max_times < 1 or self:get_current_times(  ) < 1 then   -- 最大次数小于1的时候
        self.xianbi_but.view:setCurState( CLICK_STATE_DISABLE )    
        self.yuanbao_but.view:setCurState( CLICK_STATE_DISABLE )    
        -- self.entrust_count_title:setString(  Lang.entrust[19]) -- [939]="#c66ff66委托次数： 0"
    else
        self.xianbi_but.view:setCurState( CLICK_STATE_UP )    
        self.yuanbao_but.view:setCurState( CLICK_STATE_UP ) 
        -- self.entrust_count_title:setString( Lang.entrust[8] ) -- [923]="#c66ff66委托次数："
    end
end

-- 副本委托切换
function EntrustPage:change_page( fuben_id )
    self.current_fuben_id = fuben_id
    -- print("EntrustPage:change_page fuben_id", fuben_id)
    --需要等级
    self:update_entrust_base_info(  )
    -- local fuben_info = EntrustModel:get_entrust_info_by_fuben_id( fuben_id )
    self:change_page_present(  )


    self:update( "all" )
    -- if fuben_info == nil then             -- 如果获取不到该副本id对应的动态信息，就请求副本委托数据
    EntrustModel:request_entrust_fuben_info( fuben_id )
    -- end
end

-- 根据副本不同，控制显示项
function EntrustPage:change_page_present(  )
    local exp_type, lilian_type, xianbi_type, yingliang_type = EntrustModel:check_fuben_award_type( self.current_fuben_id )

    -- ******奖励*****************
    --获得经验
    self.get_exp_title:setIsVisible( false )
    self.get_exp:setIsVisible( false )
    
    --获得历练
    self.get_lilian_title:setIsVisible( false )
    self.get_lilian:setIsVisible( false )

    --获得铜币
    self.get_xianbi_title:setIsVisible( false )
    self.get_xianbi:setIsVisible( false )

    -- 经验，历练，仙币只会有一个显示(位置也相同)
    if exp_type then
        self.get_exp_title:setIsVisible( true )
        self.get_exp:setIsVisible( true )

    elseif lilian_type then
        self.get_lilian_title:setIsVisible( true )
        self.get_lilian:setIsVisible( true )
        
    elseif xianbi_type then
        self.get_xianbi_title:setIsVisible( true )
        self.get_xianbi:setIsVisible( true )
    end

    -- 银两
    if yingliang_type then
        self.get_yingliang_title:setIsVisible( true )
        self.get_yingliang:setIsVisible( true )
    else
        self.get_yingliang_title:setIsVisible( false )
        self.get_yingliang:setIsVisible( false )
    end

    -- 特殊显示
    -- 元宝委托  
    if self.current_fuben_id == EntrustModel.lilianfuben or 
        self.current_fuben_id == EntrustModel.shangjinfuben then
        self.yuanbao_but.view:setIsVisible( false )
        self.yuanbao_notice:setIsVisible( false )
    else
        self.yuanbao_but.view:setIsVisible( true )
        self.yuanbao_notice:setIsVisible( true )
    end 
    -- 委托层数
    if self.current_fuben_id == EntrustModel.lilianfuben or 
        self.current_fuben_id == EntrustModel.shangjinfuben then
        self.entrust_level_title:setIsVisible( false )
        self.can_entrust_num:setIsVisible( false )
    else
        self.entrust_level_title:setIsVisible( true )
        self.can_entrust_num:setIsVisible( true )
    end 

    -- 委托结果
    -- self:update_entrust_result(  )
end

-- 更新是否显示神秘商店按钮
function EntrustPage:update_mystical_shop_but(  )
    if self.current_fuben_id == EntrustModel.xinmohuanjing then
        -- print(" self.current_fuben_id == EntrustModel.xinmohuanjing ", self.current_fuben_id ,EntrustModel.xinmohuanjing )
        self.mystical_shop_but.view:setIsVisible(true)
        -- print("EntrustModel:check_if_can_show_mystical_shop(  )",EntrustModel:check_if_can_show_mystical_shop(  ))
        if EntrustModel:check_if_can_show_mystical_shop(  ) then
            self.mystical_shop_but.view:setCurState( CLICK_STATE_UP )
        else
            self.mystical_shop_but.view:setCurState( CLICK_STATE_DISABLE )
        end
    else
        self.mystical_shop_but.view:setIsVisible(false)
    end
end

-- 立即完成按钮
function EntrustPage:update_complete_but(  )
    local remain_time = EntrustModel:get_entrust_remain_time( self.current_fuben_id )
    print(remain_time)
    if remain_time > 0 then
        self.complete_but.view:setCurState(CLICK_STATE_UP)
    else
        self.complete_but.view:setCurState( CLICK_STATE_DISABLE )
    end
end

-- 更新仓库物品
function EntrustPage:update_depot_item(  )
    local depot_item_list = EntrustModel:get_depot_item_list(  )
    for i = 1, EntrustModel.DEPT_ITEM_GRID_COUNT do
        if depot_item_list[i] then
            self.cangku_item_t[i].set_date( depot_item_list[i] )
        else
            self.cangku_item_t[i].init()
        end
    end
    self:update_get_exp_but(  )
end

-- 更新委托中信息
function EntrustPage:update_entrusting_info(  )
    -- print("EntrustPage:update_entrusting_info......")
    local info_t = EntrustModel:get_fuben_entrusting_info( self.current_fuben_id )
    --self.entrusting_dialog:setText( "" )
    -- for i = 1, #info_t do
    --     self.entrusting_dialog:setText( info_t[i] )
    -- end
end

-- 更新剩余时间
function EntrustPage:update_entrust_remain_time(  )
    local remain_time = EntrustModel:get_entrust_remain_time( self.current_fuben_id )
    -- print("~!@!~!@~!@~!@~!@", remain_time)
    if remain_time and tonumber(remain_time) > 0 then
        self.complete_but.view:setCurState( CLICK_STATE_UP )
        self.remain_time:setIsVisible( true )
        self.remain_time_title:setIsVisible( true )
    else
        self.complete_but.view:setCurState( CLICK_STATE_DISABLE )
        self.remain_time:setIsVisible( false )
        self.remain_time_title:setIsVisible( false )
    end

    remain_time = Utils:second_to_24time_str( remain_time )
    self.remain_time:setString( remain_time )
end

-- 更新委托结果
-- function EntrustPage:update_entrust_result(  )
--     local result_str = EntrustModel:get_entrust_result_str( self.current_fuben_id )
--     self.entrust_result:setString(LH_COLOR[2]..result_str )
-- end

-- 更新数据 
function EntrustPage:update( update_type )
	-- print("EntrustPage:update......", update_type)
    if update_type == "all" then
        self:update_entrust_info(  )
        self:update_depot_item(  )
        self:update_entrusting_info(  )
        self:update_entrust_remain_time(  )
        self:update_award()
    elseif update_type == "entrust_info" then
        self:update_entrust_info(  )
    elseif update_type == "depot_item" then
        self:update_depot_item(  )
    elseif update_type == "entrusting_info" then
        self:update_entrusting_info(  )
    elseif update_type == "entrust_remain_time" then
        self:update_entrust_remain_time(  )
    elseif update_type == "fuben_times" then    -- 进入副本次数更新
        self:update_entrust_times_but(  )
    elseif update_type == "entrust_result" then 
        -- self:update_entrust_result(  )
    end
end
