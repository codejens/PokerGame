-- ApplyList.lua
-- created by lyl on 2012-1-28
--alter by xiehande on 2014-12-11
local window_width =880
local window_height = 520

super_class.ApplyList(Window)
function ApplyList:create(  )
    return ApplyList("ApplyList",  "", false, window_width,window_height )
end

function ApplyList:__init( )
    window_width = self.view:getSize().width
    window_height =  self.view:getSize().height
	self.row_t   = {}                  -- 存储每一行的对象， 用来修改每行数据
    local panel = self.view
	-- 创建个区域的面板
    self:create_main_panel(panel )
    self:init_all_row( )


    -- GuildModel:request_apply_join_list(  )     -- 申请数据
end


-- 所有元素的背景
function ApplyList:create_main_panel(panel )
	self.col_widthes = { 131, 131, 142, 202,}     -- 列宽，用于计算下一列的坐标.
	self.select_row_index = nil                          -- 当前选中列

    local panel_bg = CCBasePanel:panelWithFile(0, 0, window_width, window_height, UILH_COMMON.normal_bg_v2, 500, 500)   --60 为分页栏高度
    panel:addChild(panel_bg)

    --第二层背景图
    panel_bg:addChild( CCZXImage:imageWithFile( 13, 14, 853, window_height - 26, UILH_COMMON.bottom_bg, 500, 500 ) )

    --创建表头
    local title_bg_1 = CCZXImage:imageWithFile( 5, 472, 850, 31, UILH_NORMAL.title_bg4, 500, 500 )     -- 表头结束下面有个背景线
    panel_bg:addChild( title_bg_1 )
    self:create_table_title( title_bg_1 )      -- 创建表头（列名）

    self:create_all_row( panel_bg )           -- 创建所有行。 显示的时候只修改每个元素的值

        --分页按钮的底板
    local page_panel = CCBasePanel:panelWithFile(4,16,860,60,"",500,500)
   self:create_page_button( page_panel )      -- 创建最下面的按钮
    panel:addChild(page_panel)


    self.main_panel = panel               -- 存储起来，其他方法要用
    return panel
end

-- 创建表头
function ApplyList:create_table_title( panel )
	-- 表头(列名)
    local title_x = 38            -- 第一列的起始x坐标，后面的坐标要依据它与列宽（self.col_widthes）计算
    local title_y = 16
     self.colTX = { 68, 215, 333, 486, 719}
    local label_temp = UILabel:create_label_1(LH_COLOR[2]..Lang.guild.apply[1], CCSize(100,20), self.colTX[1], title_y, 15, CCTextAlignmentCenter, 255, 255, 255) -- [1118]="申请人"
    panel:addChild( label_temp )

   -- title_x = title_x + self.col_widthes[1]     -- 计算下一列坐标
    local label_temp = UILabel:create_label_1(LH_COLOR[2]..Lang.guild.list[18], CCSize(100,20), self.colTX[2], title_y, 15, CCTextAlignmentCenter, 255, 255, 255) -- [1053]="等级"
    panel:addChild( label_temp )

   -- title_x = title_x + self.col_widthes[2]     -- 计算下一列坐标
    local label_temp = UILabel:create_label_1(LH_COLOR[2]..Lang.guild.list[19], CCSize(100,20), self.colTX[3], title_y, 15, CCTextAlignmentCenter, 255, 255, 255) -- [1054]="职业"
    panel:addChild( label_temp )

   -- title_x = title_x + self.col_widthes[3]     -- 计算下一列坐标
    local label_temp = UILabel:create_label_1(LH_COLOR[2]..Lang.guild.list[20], CCSize(100,20), self.colTX[4], title_y, 15, CCTextAlignmentCenter, 255, 255, 255) -- [1119]="战斗力"
    panel:addChild( label_temp )

  --  title_x = title_x + self.col_widthes[4]     -- 计算下一列坐标
    local label_temp = UILabel:create_label_1(LH_COLOR[2]..Lang.guild[21], CCSize(100,20), self.colTX[5], title_y, 15, CCTextAlignmentCenter, 255, 255, 255) -- [1120]="操作"
    panel:addChild( label_temp )

end


-- 创建所有行
function ApplyList:create_all_row( panel )
    local row_begin_x = 6
    local row_begin_y = 405
    local row_height = 66
    local row_width  = 850
    local count_per_page = GuildModel:get_rows_count_per_page(  )
    for i = 1, count_per_page do
        local one_row = self:create_one_row( row_begin_x, row_begin_y - (i - 1) * row_height, row_width, row_height, "" , i)
        panel:addChild( one_row.view )
    end
end


-- 创建一行。 参数：坐标 宽高 背景图名称  标识序列号（数字）
function ApplyList:create_one_row( pos_x, pos_y, width, height, texture_name, index )
    local guild={ }
    local one_row = {}
    self.colX = {69,211,331,482,635,781}
    one_row.view = CCBasePanel:panelWithFile( pos_x, pos_y, width, height, texture_name, 500, 500 )
	
    local title_y = 32
	-- 名称
    --one_row.name = QQVIPName:create_qq_vip_info(0, "name")
    -- one_row.name = QQVipInterface:create_qq_vip_info( 0, "name" )
    -- one_row.name:setPosition( 20, 18 )
    -- one_row.view:addChild( one_row.name.view )

	one_row.name = UILabel:create_label_1( guild.name, CCSize(100,25), self.colX[1], title_y, 16, CCTextAlignmentCenter, 255, 255, 255 )
    one_row.view:addChild( one_row.name )

    -- 等级
    one_row.level = UILabel:create_label_1( guild.level, CCSize(100,25), self.colX[2], title_y, 16, CCTextAlignmentCenter, 255, 255, 255 )
    one_row.view:addChild( one_row.level )

    -- 职业
    one_row.job = UILabel:create_label_1( guild.job, CCSize(100,25), self.colX[3], title_y, 16, CCTextAlignmentCenter, 255, 255, 255 )
    one_row.view:addChild( one_row.job )

    -- 战斗力
    one_row.attack = UILabel:create_label_1( guild.standing, CCSize(100,25), self.colX[4], title_y, 16, CCTextAlignmentCenter, 255, 255, 255 )
    one_row.view:addChild( one_row.attack )

    -- 同意
    local function but_1_fun(eventType,x,y)
        if eventType == TOUCH_CLICK then
            GuildModel:response_apply_join( 1, one_row.guild.actorId )
            GuildCC:request_apply_join_list()
        end
        return true
    end
    one_row.accept_but = MUtils:create_btn(one_row.view,
          UILH_COMMON.lh_button2,
        UILH_COMMON.lh_button2,
        but_1_fun,
        self.colX[5], 6, -1, -1)
    local btn_txt = UILabel:create_lable_2(LH_COLOR[2]..Lang.guild[22], 96/2, 15, 16)
    local b_size =  one_row.accept_but:getSize()
    local t_size =  btn_txt:getSize()
    btn_txt:setPosition(b_size.width/2-t_size.width/2,b_size.height/2-t_size.height/2+3)
    one_row.accept_but:addChild(btn_txt)
    one_row.accept_but:setAnchorPoint(0.5, 0)

    -- one_row.accept_but = MUtils:create_common_btn( one_row.view, LangGameString[1121], but_1_fun, 570, 5 ) -- [1121]="同意"
    -- one_row.accept_but = UIButton:create_button_with_name( title_x - 65, 5, 60, 31, "ui/common/button2_bg.png", "ui/common/button2_bg.png", nil, "同意", but_1_fun )
    -- one_row.view:addChild(one_row.accept_but)

    -- 拒绝
    local function but_2_fun(eventType,x,y)
        if eventType == TOUCH_CLICK then
        	-- print("拒绝")
            GuildModel:response_apply_join( 0, one_row.guild.actorId )
            GuildCC:request_apply_join_list()
        end
        return true
    end
    one_row.refuse_but = MUtils:create_btn(one_row.view,
        UILH_COMMON.lh_button_4_r,
        UILH_COMMON.lh_button_4_r,
        but_2_fun,
        self.colX[6], 6, 99, 53)
    local btn_txt = UILabel:create_lable_2(LH_COLOR[2]..Lang.guild[23], 96/2, 15, 16)
    local b_size =  one_row.refuse_but:getSize()
    local t_size =  btn_txt:getSize()
    btn_txt:setPosition(b_size.width/2-t_size.width/2,b_size.height/2-t_size.height/2+3)
    one_row.refuse_but:addChild(btn_txt)
    one_row.refuse_but:setAnchorPoint(0.5, 0)
    -- one_row.refuse_but = MUtils:create_common_btn( one_row.view, LangGameString[1122], but_2_fun, 672, 5 ) -- [1122]="拒绝"
    -- one_row.refuse_but = UIButton:create_button_with_name( title_x + 5, 5, 60, 31, "ui/common/button2_bg.png", "ui/common/button2_bg.png", nil, "拒绝", but_1_fun )
    -- one_row.view:addChild(one_row.refuse_but)

    local line = CCZXImage:imageWithFile( 21, 1, window_width-54, 3, UILH_COMMON.split_line )     
    one_row.view:addChild( line )  

    one_row.index = index                -- 一行的标识
    self.row_t[ one_row.index ] = one_row
	return one_row
end


-- 创建最下方的翻页按钮
function ApplyList:create_page_button( bgpanel )

    local  fenye_btn_h = 6
	-- 首页
    local function first_page_but_fun()
        GuildModel:apply_goto_first(  )
    end
     --xiehande  通用按钮修改  --btn_lv2.png ->button2.png
    local btn = ZTextButton:create(bgpanel,LH_COLOR[2]..Lang.guild[24],UILH_COMMON.button4, first_page_but_fun, 220, fenye_btn_h,-1,-1, 1)
    -- MUtils:create_common_btn( bgpanel, LangGameString[1123], first_page_but_fun, 194, 12 ) -- [1123]="首页"
    -- local first_page_but = UIButton:create_button_with_name( 130 + 50, 5, 60, 31, "ui/common/button2_bg.png", "ui/common/button2_bg.png", nil, "首页", first_page_but_fun )
    -- bgpanel:addChild( first_page_but )
    
    -- 上页
    local function pre_page_but_fun()
    	GuildModel:apply_pre_page(  )
    end
    --xiehande  通用按钮修改  --btn_lv2.png ->button2.png
    btn = ZTextButton:create(bgpanel,LH_COLOR[2]..Lang.guild[25],UILH_COMMON.button4, pre_page_but_fun, 308, fenye_btn_h,-1,-1, 1)
    -- MUtils:create_common_btn( bgpanel, LangGameString[1124], pre_page_but_fun, 294, 12 ) -- [1124]="上页"
    -- local pre_page_but = UIButton:create_button_with_name( 200 + 50, 5, 60, 31, "ui/common/button2_bg.png", "ui/common/button2_bg.png", nil, "上页", pre_page_but_fun )
    -- bgpanel:addChild( pre_page_but )

    -- 下页
    local function next_page_but_fun()
    	GuildModel:apply_next_page(  )
    end
    btn = ZTextButton:create(bgpanel,LH_COLOR[2]..Lang.guild[26],UILH_COMMON.button4, next_page_but_fun, 466, fenye_btn_h,-1,-1, 1) --btn_lv2.png ->button2.png
    -- MUtils:create_common_btn( bgpanel, LangGameString[1125], next_page_but_fun, 464, 12 ) -- [1125]="下页"
    -- local next_page_but = UIButton:create_button_with_name( 340 + 50, 5, 60, 31, "ui/common/button2_bg.png", "ui/common/button2_bg.png", nil, "下页", next_page_but_fun )
    -- bgpanel:addChild( next_page_but )

        -- 当前页和页数
    --local cur_page_frame = CCBasePanel:panelWithFile( 398, 50, -1, -1, UIPIC_FAMILY_013, 500, 500 )
    self.curr_page_label = UILabel:create_label_1( LH_COLOR[2].."0/0", CCSize(70,25), 423, fenye_btn_h+23, 17, CCTextAlignmentCenter, 255, 255, 255 )
       bgpanel:addChild(self.curr_page_label)
    -- cur_page_frame:addChild(self.curr_page_label)
    -- bgpanel:addChild(cur_page_frame)

    -- 末页
    local function last_page_but_fun()
    	GuildModel:apply_goto_last(  )
    end
    btn = ZTextButton:create(bgpanel,LH_COLOR[2]..Lang.guild[27],UILH_COMMON.button4, last_page_but_fun, 556, fenye_btn_h,-1,-1, 1)
    -- MUtils:create_common_btn( bgpanel, LangGameString[1126], last_page_but_fun, 564, 12 ) -- [1126]="末页"
    -- local last_page_but = UIButton:create_button_with_name( 410 + 50, 5, 60, 31, "ui/common/button2_bg.png", "ui/common/button2_bg.png", nil, "末页", last_page_but_fun )
    -- bgpanel:addChild( last_page_but )

end

-- 清空一行的数据
function ApplyList:init_one_row( one_row )
    --QQVIPName:reinit_info( one_row.name, 0, "" )
    -- QQVipInterface:reinit_info( one_row.name, 0, "" )
    one_row.name:setString("")
    one_row.level:setString("")
    one_row.job:setString("")
    one_row.attack:setString("")

    one_row.accept_but:setIsVisible( false )
    one_row.refuse_but:setIsVisible( false )

    one_row.guild = nil
end

-- 删除所有行
function ApplyList:init_all_row(  )
    for key, one_row in pairs(self.row_t) do
        self:init_one_row( one_row )
    end
end

-- 使用一个仙宗结构设置一行的数据
function ApplyList:set_one_row_by_guild( one_row, guild )
    -- QQVipInterface:reinit_info( one_row.name, guild.qqvip, guild.name )
    --QQVIPName:reinit_info( one_row.name, guild.qqvip, guild.name )
    one_row.name:setString( LH_COLOR[2]..guild.name )
    one_row.level:setString(LH_COLOR[2]..guild.level )
    one_row.job:setString(LH_COLOR[2].._com_attr_job_name[ guild.job ] )
    one_row.attack:setString( LH_COLOR[2]..guild.attack )
    one_row.accept_but:setIsVisible( true )
    one_row.refuse_but:setIsVisible( true )

    -- 只有护法级别以上的才可以同意或者拒绝
    if GuildModel:check_if_be_position( "wang" ) or GuildModel:check_if_be_position( "deputy" ) 
    	or GuildModel:check_if_be_position( "hufa" ) then

        one_row.accept_but:setIsVisible( true )
        one_row.refuse_but:setIsVisible( true )
    else
        one_row.accept_but:setIsVisible( false )
        one_row.refuse_but:setIsVisible( false )
    end

    -- 一些行操作需要存储的数据
    one_row.guild = guild            
end

-- 显示当前页所有行
function ApplyList:show_all_row( )
    local dates, start_index, end_index = GuildModel:get_apply_curr_page_date(  )    -- 获取当前页数据

    local row_count = 1                           -- 行数计数
    for i = start_index, end_index do
        self:set_one_row_by_guild( self.row_t[row_count], dates[i] )
        row_count = row_count + 1
    end

    -- 页号显示
    local page_curr  = GuildModel:get_apply_curr_page(  )
    local page_total = GuildModel:get_apply_page_total(  )
    self.curr_page_label:setString( LH_COLOR[2]..page_curr.."/"..page_total )

    -- self:flash_nomi_shot_off_but(  )
end

-- 更新
function ApplyList:update( update_type )
    -- print("=====ApplyList:update( update_type )===", update_type)
    if update_type == "all" then
        GuildModel:request_apply_join_list(  )
        self:update_all(  )
    elseif update_type == "apply_list" then
        self:update_all(  )
    elseif update_type == "apply_page" then
        self:update_page(  )
    end
end

-- 更新页面所有动态信息
function ApplyList:update_all(  )
	self:init_all_row(  )
	self:show_all_row( )
    -- GuildModel:request_apply_join_list(  )     -- 申请数据
end

-- 翻页更新
function ApplyList:update_page(  )
	self:init_all_row()
	self:show_all_row()
end

function ApplyList:destroy(  )
     Window.destroy(self);
end