-- GuildAction.lua
-- created by xj on 2014-3-24
-- 仙宗动态页   require "UI/guild/GuildAction"


super_class.GuildAction( Window )

function GuildAction:create( )
    return GuildAction( "GuildAction", "", false, 850, 540 )
end

function GuildAction:__init( )
	self.row_t = {}                  -- 存储每一行的对象， 用来修改每行数据
    -- 1.仓库存取, 2.家族捐献, 3.家族升级, 4.人员变动
    self.action_type_img_t = {UIPIC_FAMILY_046, UIPIC_FAMILY_047, UIPIC_FAMILY_048, UIPIC_FAMILY_049}

	-- 创建个区域的面板
    self:create_main_panel( )

    GuildModel:request_action_list( 0 )     -- 向服务器请求全部仙宗动态数据
end


-- 所有元素的背景
function GuildAction:create_main_panel( )
	self.col_widthes = { 300, 95 }     -- 列宽，用于计算下一列的坐标.因为表头和内容显示的时候都要使用，所以在这定义
	self.select_row_index = nil                          -- 当前选中列

    local panel = self.view
    local panel_bg = CCBasePanel:panelWithFile(9, 115, 832, 422, UIPIC_FAMILY_011, 500, 500)
    panel:addChild(panel_bg)

    local title_bg_1 = CCZXImage:imageWithFile( 0, 385, 832, 39, UIPIC_FAMILY_012, 500, 500 )     -- 表头结束下面有个背景线
    panel_bg:addChild( title_bg_1 )

    self:create_table_title( title_bg_1 )      -- 创建表头（列名）
    self:create_all_row( panel_bg )           -- 创建所有行。 显示的时候只修改每个元素的值
    -- self:create_tab_button( panel )         -- 创建左边tab按钮
    self:create_page_button( panel )      -- 创建最下面的按钮

    self.main_panel = panel               -- 存储起来，其他方法要用
    return panel
end

-- 创建表头
function GuildAction:create_table_title( panel )

    -- 仙宗事件和仙宗仓库 的表头
    self.list_header_1 = CCBasePanel:panelWithFile( 0, 0, 850, 39, "", 500, 500 )
    panel:addChild( self.list_header_1 )

	-- 表头(列名)
    local title_x = 200            -- 第一列的起始x坐标，后面的坐标要依据它与列宽（self.col_widthes）计算
	local title_y = 21

    -- 详情
    local label_temp1 = UILabel:create_label_1( "#cffff00动态详情", CCSize( 300, 20 ), title_x, title_y, 16, CCTextAlignmentCenter, 255, 255, 255 ) -- [2340]="详情"
    self.list_header_1:addChild( label_temp1 )
    -- ZLabel:create(panel, LangGameString[2329], title_x, title_y, 15, CCTextAlignmentCenter, 0)

    -- 时间
    title_x = 756
    label_temp1 = UILabel:create_label_1( "#cffff00时间", CCSize( 100, 20 ), title_x, title_y, 16, CCTextAlignmentCenter, 255, 255, 255 ) -- [2238]="时间"
    self.list_header_1:addChild( label_temp1 )
    -- ZLabel:create(panel, LangGameString[2238], title_x, title_y, 15, CCTextAlignmentCenter, 0)


    -- -- 天元之战的表头
    -- self.list_header_2 = CCBasePanel:panelWithFile( 0, 0, 850, 39, "", 500, 500 )
    -- panel:addChild( self.list_header_2 )
    -- self.list_header_2:setIsVisible( false )

    -- -- 表头(列名)
    -- title_x = 100            -- 第一列的起始x坐标，后面的坐标要依据它与列宽（self.col_widthes）计算
    -- title_y = 21

    -- -- 玩家名字
    -- local label_temp2 = UILabel:create_label_1( LangGameString[865], CCSize( 100, 20 ), title_x, title_y, 16, CCTextAlignmentCenter, 255, 255, 255 ) -- [2340]="详情"
    -- self.list_header_2:addChild( label_temp2 )

    -- -- 活动排名
    -- title_x = title_x + 130
    -- label_temp2 = UILabel:create_label_1( LangGameString[2341], CCSize( 100, 20 ), title_x, title_y, 16, CCTextAlignmentCenter, 255, 255, 255 ) -- [2238]="时间"
    -- self.list_header_2:addChild( label_temp2 )

    -- -- 本周积分
    -- title_x = title_x + 140
    -- label_temp2 = UILabel:create_label_1( LangGameString[2342], CCSize( 100, 20 ), title_x, title_y, 16, CCTextAlignmentCenter, 255, 255, 255 ) -- [2238]="时间"
    -- self.list_header_2:addChild( label_temp2 )

    -- -- 参加次数
    -- title_x = title_x + 130
    -- label_temp2 = UILabel:create_label_1( LangGameString[2343], CCSize( 100, 20 ), title_x, title_y, 16, CCTextAlignmentCenter, 255, 255, 255 ) -- [2238]="时间"
    -- self.list_header_2:addChild( label_temp2 )

    -- -- 上次参与时间
    -- title_x = title_x + 130
    -- label_temp2 = UILabel:create_label_1( LangGameString[2344], CCSize( 100, 20 ), title_x, title_y, 16, CCTextAlignmentCenter, 255, 255, 255 ) -- [2238]="时间"
    -- self.list_header_2:addChild( label_temp2 )
end


-- 创建所有行
function GuildAction:create_all_row( panel )
    local row_begin_x = 6
    local row_begin_y = 330
    local row_height = 52
    local row_width  = 818
    local count_per_page = GuildModel:get_rows_count_per_page( )
    self.bottom_row_view = nil      -- 列表中最底下的一行，如果是"天元之战"，则显示玩家自身的排名和积分
    for i = 1, count_per_page do
        local one_row = self:create_one_row( row_begin_x, row_begin_y - (i - 1) * row_height, row_width, row_height, "", i )
        panel:addChild( one_row.view )

        if i == count_per_page then
            self.bottom_row_view = one_row.view
        end
    end

    -- self.bottom_row_view_tianyuan = CCBasePanel:panelWithFile( row_begin_x, row_begin_y - (count_per_page - 1) * row_height, row_width, row_height, "", 500, 500 )
    -- self.bottom_row_view_tianyuan:setIsVisible( false )
    -- panel:addChild( self.bottom_row_view_tianyuan )

    -- local title_x = 200            -- 第一列的起始x坐标，后面的坐标要依据它与列宽（self.col_widthes）计算
    -- local title_y = 17

    -- -- 我本周排名
    -- self.personal_rank = ZLabel:create(self.bottom_row_view_tianyuan, "", title_x, title_y, 16, ALIGN_LEFT, 10)

    -- -- 积分
    -- title_x = title_x + 200
    -- self.personal_point = ZLabel:create(self.bottom_row_view_tianyuan, "", title_x, title_y, 16, ALIGN_CENTER, 10)
end


-- 创建一行。 参数：坐标 宽高 背景图名称  标识序列号（数字）
function GuildAction:create_one_row( pos_x, pos_y, width, height, texture_name, index )
    local guild = {}
    local one_row = {}

    one_row.view = CCBasePanel:panelWithFile( pos_x, pos_y, width, height, texture_name, 500, 500 )
	
    local title_x = 0            -- 第一列的起始x坐标，后面的坐标要依据它与列宽（self.col_widthes）计算
    local title_y = 17

    -- 标签
    one_row.type = guild.type
    one_row.tag = nil

    -- 详情
    title_x = title_x + 100
    one_row.desc = ZLabel:create(one_row.view, "", title_x, title_y, 16, ALIGN_LEFT, 10)
    --one_row.desc = UILabel:create_label_1( "guild.desc", CCSize( self.col_widthes[1], 25 ), title_x, title_y, 20, CCTextAlignmentLeft, 255, 255, 255 )
    --one_row.view:addChild( one_row.desc )

    -- 时间
    title_x = 750
    one_row.time = ZLabel:create(one_row.view, "", title_x, title_y, 16, ALIGN_CENTER, 10)
    --one_row.time = UILabel:create_label_1( "2014-3-23", CCSize( self.col_widthes[2], 25 ), title_x, title_y, 20, CCTextAlignmentCenter, 255, 255, 255 )
    --one_row.view:addChild( one_row.time )

    -- title_x = 0            -- 第一列的起始x坐标，后面的坐标要依据它与列宽（self.col_widthes）计算

    -- -- 玩家名字
    -- one_row.name = ZLabel:create(one_row.view, "", title_x, title_y, 16, ALIGN_LEFT, 10)

    -- -- 活动排名
    -- title_x = title_x + 130
    -- one_row.rank = ZLabel:create(one_row.view, "", title_x, title_y, 16, ALIGN_LEFT, 10)

    -- -- 本周积分
    -- title_x = title_x + 140
    -- one_row.point = ZLabel:create(one_row.view, "", title_x, title_y, 16, ALIGN_LEFT, 10)

    -- -- 参加次数
    -- title_x = title_x + 130
    -- one_row.count = ZLabel:create(one_row.view, "", title_x, title_y, 16, ALIGN_LEFT, 10)

    -- 上次参与时间
    --title_x = title_x + 130
    --one_row.last_time = ZLabel:create(one_row.view, "", title_x, title_y, 16, ALIGN_LEFT, 10)

    local line = CCZXImage:imageWithFile( 1, 1, 816, 2, UIPIC_DREAMLAND_028 )      -- 线
    one_row.view:addChild( line )  

    one_row.index = index                -- 一行的标识
    self.row_t[ one_row.index ] = one_row
	return one_row
end


-- 创建最下方的翻页按钮
function GuildAction:create_page_button( bgpanel )
	-- 首页
    local function first_page_but_fun()
        GuildModel:action_goto_first()
    end
    local btn = ZTextButton:create(bgpanel,LangGameString[1123],UIResourcePath.FileLocate.common .. "button2.png", first_page_but_fun, 190, 38,-1,-1, 1)
    -- MUtils:create_common_btn( bgpanel, LangGameString[1123], first_page_but_fun, 194, 12 ) -- [1123]="首页"
    -- local first_page_but = UIButton:create_button_with_name( 130 + 50, 5, 60, 31, "ui/common/button2_bg.png", "ui/common/button2_bg.png", nil, "首页", first_page_but_fun )
    -- bgpanel:addChild( first_page_but )
    
    -- 上页
    local function pre_page_but_fun()
    	GuildModel:action_pre_page()
    end
    btn = ZTextButton:create(bgpanel,LangGameString[1124],UIResourcePath.FileLocate.common .. "button2.png", pre_page_but_fun, 290, 38,-1,-1, 1)
    -- MUtils:create_common_btn( bgpanel, LangGameString[1124], pre_page_but_fun, 294, 12 ) -- [1124]="上页"
    -- local pre_page_but = UIButton:create_button_with_name( 200 + 50, 5, 60, 31, "ui/common/button2_bg.png", "ui/common/button2_bg.png", nil, "上页", pre_page_but_fun )
    -- bgpanel:addChild( pre_page_but )

    -- 下页
    local function next_page_but_fun()
    	GuildModel:action_next_page()
    end
    btn = ZTextButton:create(bgpanel,LangGameString[1125],UIResourcePath.FileLocate.common .. "button2.png", next_page_but_fun, 460, 38,-1,-1, 1)
    -- MUtils:create_common_btn( bgpanel, LangGameString[1125], next_page_but_fun, 464, 12 ) -- [1125]="下页"
    -- local next_page_but = UIButton:create_button_with_name( 340 + 50, 5, 60, 31, "ui/common/button2_bg.png", "ui/common/button2_bg.png", nil, "下页", next_page_but_fun )
    -- bgpanel:addChild( next_page_but )


    -- 当前页和页数。 这里都是静态的东西，先在这里写好，到刷新列表的时候，再动态设置
    local cur_page_frame = CCBasePanel:panelWithFile( 398, 50, -1, -1, UIPIC_FAMILY_013, 500, 500 )
    self.curr_page_label = UILabel:create_label_1( "0/0", CCSize(70,25), 25, 16, 16, CCTextAlignmentCenter, 255, 255, 255 )
    cur_page_frame:addChild(self.curr_page_label)
    bgpanel:addChild(cur_page_frame)

    -- 末页
    local function last_page_but_fun()
    	GuildModel:action_goto_last()
    end
    btn = ZTextButton:create(bgpanel,LangGameString[1126],UIResourcePath.FileLocate.common .. "button2.png", last_page_but_fun, 560, 38,-1,-1, 1)
    -- MUtils:create_common_btn( bgpanel, LangGameString[1126], last_page_but_fun, 564, 12 ) -- [1126]="末页"
    -- local last_page_but = UIButton:create_button_with_name( 410 + 50, 5, 60, 31, "ui/common/button2_bg.png", "ui/common/button2_bg.png", nil, "末页", last_page_but_fun )
    -- bgpanel:addChild( last_page_but )

end

-- 清空一行的数据
function GuildAction:init_one_row( one_row )
    if one_row.tag ~= nil then
        one_row.tag.view:removeFromParentAndCleanup(true)
    end
    one_row.tag = nil

    one_row.desc:setText( "" )
    one_row.time:setText( "" )
    -- one_row.name:setText( "" )
    -- one_row.rank:setText( "" )

    one_row.GuildAction = nil
end

-- 删除所有行
function GuildAction:init_all_row( )
    for key, one_row in pairs( self.row_t ) do
        self:init_one_row( one_row )
    end
end

-- 使用一个仙宗动态结构设置一行的数据
function GuildAction:set_one_row_by_data( one_row, action, req_type )

    if req_type == 0 or req_type == 1 then
        local tag_img_t = {
            UIPIC_FAMILY_049,
            UIPIC_FAMILY_047,
            UIPIC_FAMILY_047,
            UIPIC_FAMILY_046,
            UIPIC_FAMILY_046,
            UIPIC_FAMILY_048
        }
        local tagname = ""
        local event_type = action.event_type --事件类型 unsigned char 从0开始表示任命，罢免，加入仙宗，踢出仙宗，退出仙宗，捐献，存入仙宗仓库，从仙宗仓库取出，升级建筑，天元之战获得灵石，福地之战获得灵石
        
        if event_type >= 0 and event_type <= 4 then
            one_row.type = 1        -- 人事变动
            tagname = LangGameString[2345]
        elseif event_type == 5 then
            one_row.type = 2        -- 仙宗贡献
            tagname = LangGameString[802]
        elseif event_type == 6 then
            one_row.type = 4        -- 存入物品
            tagname = LangGameString[2347]
        elseif event_type == 7 then
            one_row.type = 5        -- 取出物品
            tagname = LangGameString[2348]
        elseif event_type == 8 then
            one_row.type = 6        -- 其他
            tagname = LangGameString[1024]
        elseif event_type == 9 then
            one_row.type = 3        -- 仙宗活动
            tagname = LangGameString[2346]
        elseif event_type == 10 then
            one_row.type = 3        -- 仙宗活动
            tagname = LangGameString[2346]
        end

        local title_x = 0            -- 第一列的起始x坐标，后面的坐标要依据它与列宽（self.col_widthes）计算
        local title_y = 0
        --one_row.tag = ZImage:create( one_row.view, UIResourcePath.FileLocate.common .. "tag_bg.png", title_x, title_y, -1, -1 )
        --local _text_img = ZImage:create( one_row.tag, UIResourcePath.FileLocate.guild .. "color_tag_" .. one_row.type .. ".png", 8, 13, -1, -1 )
        --local size = one_row.tag.label:getPosition( )
        --one_row.tag.label:setPosition( size.x - 2, size.y + 3 )
        one_row.tag = ZImage:create( one_row.view, tag_img_t[one_row.type], title_x, title_y, -1, -1 )

        local desc = GuildAction:getActionDesc( action )
        one_row.desc:setText( desc )

        local time = Utils:get_custom_format_time( "%Y-%m-%d", action.time )
        one_row.time:setText( time )

        one_row.GuildAction = action

    elseif req_type == 2 then
        -- one_row.name:setText( "#cfff000" .. action.name )
        -- one_row.rank:setText( action.rank )
        -- one_row.point:setText( string.format( "%d", action.point ) )
        -- one_row.count:setText( string.format( "%d", action.count ) )
        local time = Utils:get_custom_format_time( "%Y-%m-%d", action.time )
        one_row.time:setText( time )
        
    end
end

-- 显示当前页所有行
function GuildAction:show_all_row( )
    local req_type = GuildModel:get_action_curr_type( )
    local datas, start_index, end_index = GuildModel:get_action_curr_page_data( req_type )    -- 获取当前页数据

    local row_count = 1                           -- 行数计数
    for i = start_index, end_index do
        self:set_one_row_by_data( self.row_t[row_count], datas[i], req_type )
        row_count = row_count + 1
    end

    
    -- 页号显示
    local page_curr  = GuildModel:get_action_curr_page(  )
    local page_total = GuildModel:get_action_page_total(  )
    self.curr_page_label:setString( page_curr.."/"..page_total )

    local personal = GuildModel:get_personal_tianyuan_info()
    if personal.rank then
        self.personal_rank:setText( string.format( LangGameString[2361], personal.rank ) )
    end

    if personal.point then
        self.personal_point:setText( string.format( LangGameString[2362], personal.point ) )
    end
    -- self:flash_nomi_shot_off_but( )
end

-- 更新
function GuildAction:update( update_type )
    if update_type == "all" then
        self:update_all( )
    elseif update_type == "action_list" then
        self:update_all( )
    elseif update_type == "action_page" then
        self:update_page( )
    end
end

-- 更新页面所有动态信息
function GuildAction:update_all( )
	self:init_all_row()
	self:show_all_row()
end

-- 翻页更新
function GuildAction:update_page( )
	self:init_all_row()
	self:show_all_row()
end

-- 创建左方的tab按钮组（仙宗事件、仙宗仓库、天元之战）
function GuildAction:create_tab_button( bgpanel )
    self.radio_btn_group = CCRadioButtonGroup:buttonGroupWithFile( 4, 20, 45, 300, nil )
    bgpanel:addChild(self.radio_btn_group)

    local function change_tab( tab )
        if tab == 0 or tab == 1 then
            self.list_header_1:setIsVisible( true )
            self.list_header_2:setIsVisible( false )
            self.bottom_row_view:setIsVisible( true )
            self.bottom_row_view_tianyuan:setIsVisible( false )
        elseif tab == 2 then
            self.list_header_1:setIsVisible( false )
            self.list_header_2:setIsVisible( true )
            self.bottom_row_view:setIsVisible( false )
            self.bottom_row_view_tianyuan:setIsVisible( true )
        end
        self:init_all_row()
    end

    -- 仙宗事件
    local function action_all_but_fun( eventType, x, y )
        if eventType == TOUCH_CLICK then
            change_tab( 0 )
            GuildModel:request_action_list( 0 )
            GuildModel:action_goto_curr( 0 )
        end
        return true
    end

    local _tab_action_all = CCNGBtnMulTex:buttonWithFile( 45, 240 - 24, -1, -1, UIResourcePath.FileLocate.common .. "xxk-1.png" )
    _tab_action_all:setAnchorPoint( 1, 0 )
    self.radio_btn_group:addGroup( _tab_action_all )
    _tab_action_all:addTexWithFile( CLICK_STATE_DOWN, UIResourcePath.FileLocate.common .. "xxk-2.png" )
    _tab_action_all:registerScriptHandler( action_all_but_fun )
    -- 按钮文字
    local _tab_action_all_lab = CCZXImage:imageWithFile(30, 9, 23, 70, UIResourcePath.FileLocate.guild .. "action_even.png" )
    _tab_action_all_lab:setAnchorPoint( 1, 0 )
    _tab_action_all:addChild( _tab_action_all_lab )
    
    -- 仙宗仓库
    local function action_storage_but_fun( eventType, x, y )
        if eventType == TOUCH_CLICK then
            change_tab( 1 )
            GuildModel:request_action_list( 1 )
            GuildModel:action_goto_curr( 1 )
        end
        return true
    end
    local _tab_action_storage = CCNGBtnMulTex:buttonWithFile( 45, 240 - 24 - 90, -1, -1, UIResourcePath.FileLocate.common .. "xxk-1.png" )
    _tab_action_storage:setAnchorPoint( 1, 0 )
    self.radio_btn_group:addGroup( _tab_action_storage )
    _tab_action_storage:addTexWithFile( CLICK_STATE_DOWN, UIResourcePath.FileLocate.common .. "xxk-2.png" )
    _tab_action_storage:registerScriptHandler( action_storage_but_fun )
    -- 按钮文字
    local _tab_action_storage_lab = CCZXImage:imageWithFile(30, 9, 23, 70, UIResourcePath.FileLocate.guild .. "action_storage.png" )
    _tab_action_storage_lab:setAnchorPoint( 1, 0 )
    _tab_action_storage:addChild( _tab_action_storage_lab )

    -- 天元之战
    local function action_tianyuan_but_fun( eventType,x,y )
        if eventType == TOUCH_CLICK then
            change_tab( 2 )
            GuildModel:request_personal_tianyuan_rank( )
            GuildModel:request_action_list( 2 )
            GuildModel:action_goto_curr( 2 )
        end
        return true
    end
    local _tab_action_tianyuan = CCNGBtnMulTex:buttonWithFile( 45, 240 - 24 - 180, -1, -1, UIResourcePath.FileLocate.common .. "xxk-1.png" )
    _tab_action_tianyuan:setAnchorPoint( 1, 0 )
    self.radio_btn_group:addGroup( _tab_action_tianyuan )
    _tab_action_tianyuan:addTexWithFile( CLICK_STATE_DOWN, UIResourcePath.FileLocate.common .. "xxk-2.png" )
    _tab_action_tianyuan:registerScriptHandler( action_tianyuan_but_fun )
    _tab_action_tianyuan:setIsVisible( false )
    -- 按钮文字
    local _tab_action_tianyuan_lab = CCZXImage:imageWithFile( 30, 9, 23, 70, UIResourcePath.FileLocate.guild .. "action_tianyuan.png" )
    _tab_action_tianyuan_lab:setAnchorPoint( 1, 0 )
    _tab_action_tianyuan:addChild( _tab_action_tianyuan_lab )



    -- local line = CCZXImage:imageWithFile( 47, 312, 300, 2, UIResourcePath.FileLocate.common .. "fenge_bg.png" )
    -- line:setRotation( 90 )        -- 把横线旋转90度
    -- bgpanel:addChild( line, 10000 )

    self.radio_btn_group:selectItem( 0 )
end

function GuildAction:getActionDesc(action)
    local desc = ""
    local job = ""
    local item = ""
    local name1 = ""
    if action.player_name_one then
        name1 = "#cfff000" .. action.player_name_one .. "#cffffff"
    end
    local name2 = ""
    if action.player_name_two then
        name2 = "#cfff000" .. action.player_name_two .. "#cffffff"
    end

    local event_type = action.event_type --事件类型 unsigned char 从0开始表示任命，罢免，加入仙宗，踢出仙宗，退出仙宗，捐献，存入仙宗仓库，从仙宗仓库取出，升级建筑，天元之战获得灵石，福地之战获得灵石
    if event_type == 0 then
        job = Lang.guild_info.position_name_t[action.other_one + 1]
        desc = string.format( LangGameString[2349], name2, name1, job )
    elseif event_type == 1 then
        job = Lang.guild_info.position_name_t[action.other_one + 1]
        desc = string.format( LangGameString[2350], name2, name1, job )
    elseif event_type == 2 then
        desc = string.format( LangGameString[2351], name1 )
    elseif event_type == 3 then
        desc = string.format( LangGameString[2352], name2, name1 )
    elseif event_type == 4 then
        desc = string.format( LangGameString[2353], name1 )
    elseif event_type == 5 then
        desc = string.format( LangGameString[2354], name1, action.other_one, action.other_two, action.other_three )
    elseif event_type == 6 then
        item = ItemModel:get_item_name_with_color( action.other_one )
        desc = string.format( LangGameString[2355], name1, action.other_two, item )
    elseif event_type == 7 then
        item = ItemModel:get_item_name_with_color( action.other_one )
        desc = string.format( LangGameString[2356], name1, action.other_two, item )
    elseif event_type == 8 then
        desc = LangGameString[1024]
    elseif event_type == 9 then
        desc = string.format( LangGameString[2358], action.other_one )
    elseif event_type == 10 then
        desc = string.format( LangGameString[2359], action.other_one )
    end

    return desc
end