-- GuildTianyanLeft.lua
-- created by lyl on 2012-1.29
-- 仙宗天元之战页面

super_class.GuildTianyanLeft( Window )
local window_width =510
local window_height = 480
local font_size = 16
local  color_yellow = LH_COLOR[2]
function GuildTianyanLeft:create( )
	return GuildTianyanLeft( "GuildTianyanLeft", "", false, window_width, window_height)
end

function GuildTianyanLeft:__init( )
    self.label_t = {}                  -- 存储label使用，动态修改或者删除相关显示文字
	self.row_t   = {}                  -- 存储每一行的对象， 用来修改每行数据

    self:create_main_panel( )
end

-- 所有元素的背景
function GuildTianyanLeft:create_main_panel( )
	self.col_widthes = { 200, 200, }     -- 列宽，用于计算下一列的坐标.因为表头和内容显示的时候都要使用，所以在这定义

    local panel = self.view
    
    --底板
    local panel_bg = CCBasePanel:panelWithFile(0, 10, window_width, window_height, UILH_COMMON.bottom_bg, 500, 500)
    panel:addChild(panel_bg)


    --排行榜图片
    local title_bg = CCZXImage:imageWithFile( 92, 450, -1, -1, UILH_NORMAL.title_bg3, 500, 500 ) 
    local title = CCZXImage:imageWithFile(121, 14, -1, -1, UILH_GUILD.wancheng_top)

    local title_bg_size = title_bg:getSize()
    local title_size = title:getSize()
    title:setPosition(title_bg_size.width/2 - title_size.width/2,title_bg_size.height/2 - title_size.height/2)
    title_bg:addChild(title)
    -- local title_name =  UILabel:create_lable_2(LH_COLOR[5]..Lang.guild[32], 186, 10, font_size, ALIGN_LEFT ) 
    -- title_bg:addChild(title_name)
    panel_bg:addChild( title_bg )



    --创建表头
    self:create_table_title( panel_bg )      -- 创建表头（列名）
    self:create_all_row( panel_bg )           -- 创建所有行。 显示的时候只修改每个元素的值

    --分页按钮的底板
    local page_panel = CCBasePanel:panelWithFile(-15,16,window_width,60,"",500,500)
    self:create_page_button( page_panel )      -- 创建最下面的按钮
    panel:addChild(page_panel)


    -- local title_image = CCZXImage:imageWithFile( 80, 24, 173, 27, UIPIC_FAMILY_044)     -- 表头标题
    -- title_bg:addChild( title_image )

    --local title_bg_1 = CCZXImage:imageWithFile( 3, 240, 440, 26, UIResourcePath.FileLocate.common .. "coner1.png", 500, 500 )     -- 表头结束下面有个背景线
    --panel:addChild( title_bg_1 )

    -- 积分
   --local score_bg = CCZXImage:imageWithFile( 0, 3, 107, 19, UIResourcePath.FileLocate.common .. "title_bg_01_s.png", 500, 500 )
    --panel:addChild( score_bg )
    -- local score_title = UILabel:create_lable_2( LangGameString[1221], 20, 8, 16,  ALIGN_LEFT ) -- [1221]="#cffff00仙宗本周积分："
    -- panel:addChild( score_title )
    -- self.score_lable = UILabel:create_lable_2( "", 135, 8, 16,  ALIGN_LEFT )
    -- panel:addChild( self.score_lable )

    -- -- 排名
    -- --local ranking_bg = CCZXImage:imageWithFile( 200, 3, 107, 19, UIResourcePath.FileLocate.common .. "title_bg_01_s.png", 500, 500 )
    -- --panel:addChild( ranking_bg )
    -- local ranking_title = UILabel:create_lable_2( LangGameString[1222], 220, 8, 16,  ALIGN_LEFT ) -- [1222]="#cffff00排名："
    -- panel:addChild( ranking_title )
    -- self.ranking_lable = UILabel:create_lable_2( "", 265, 8, 16,  ALIGN_LEFT )
    -- panel:addChild( self.ranking_lable )

    self.main_panel = panel                        -- 存储起来，其他方法要用  
    GuildModel:req_tianyuan_battle_tongji(  )      -- 请求天元之战统计数据
    return panel
end

-- 创建表头
function GuildTianyanLeft:create_table_title( panel )
	-- 表头(列名)
    local title_x = 47            -- 第一列的起始x坐标，后面的坐标要依据它与列宽（self.col_widthes）计算
	local title_y = 21
    
    --表的标题   
    local title_bg_1 = CCZXImage:imageWithFile( 2, 406, 536, 40, "", 500, 500 )    
    panel:addChild( title_bg_1 )

    local label_temp = UILabel:create_label_1(color_yellow..Lang.guild.list[1], CCSize(100,20), title_x, title_y, font_size, CCTextAlignmentCenter, 255, 255, 0) -- [1184]="排名"
    title_bg_1:addChild( label_temp )

    title_x = title_x + self.col_widthes[1]     -- 计算下一列坐标
    local label_temp = UILabel:create_label_1(color_yellow..Lang.guild.tianyuan[3], CCSize(100,20), title_x, title_y, font_size, CCTextAlignmentCenter, 255, 255, 0) -- [1223]="参加仙宗"
    title_bg_1:addChild( label_temp )

    title_x = title_x + self.col_widthes[2]     -- 计算下一列坐标
    local label_temp = UILabel:create_label_1(color_yellow..Lang.guild.tianyuan[4], CCSize(100,20), title_x, title_y, font_size, CCTextAlignmentCenter, 255, 255, 0) -- [1224]="仙宗积分"
    title_bg_1:addChild( label_temp )

end


-- 创建所有行
function GuildTianyanLeft:create_all_row( panel )
    local row_begin_x = 2
    local row_begin_y = 375
    local row_height = 42
    local row_width  = 534
    local count_per_page = GuildModel:get_rows_count_per_page(  )+2
    for i = 1, count_per_page do
        local one_row = self:create_one_row( row_begin_x, row_begin_y - (i - 1) * row_height, row_width, row_height, "" , i)
        panel:addChild( one_row.view )
    end
end

-- 创建一行。 参数：坐标 宽高 背景图名称  标识序列号（数字）
function GuildTianyanLeft:create_one_row( pos_x, pos_y, width, height, texture_name, index )
    local guild={ }
    local one_row = {}

    one_row.view = CCBasePanel:panelWithFile( pos_x, pos_y, width, height, texture_name, 500, 500 )
	
    local title_x = 45            -- 第一列的起始x坐标，后面的坐标要依据它与列宽（self.col_widthes）计算
    local title_y = 6
	-- 排名
	-- one_row.range = UILabel:create_label_1( "", CCSize(self.col_widthes[1],25), title_x, title_y, 20, CCTextAlignmentCenter, 255, 255, 255 )
    one_row.range = UILabel:create_lable_2( color_yellow.."", title_x, title_y, 16,  ALIGN_CENTER )
    one_row.view:addChild( one_row.range )

    -- 参加仙宗
    title_x = title_x + self.col_widthes[1] 
    -- one_row.guild_name = UILabel:create_label_1( "", CCSize(self.col_widthes[2],25), title_x, title_y, 20, CCTextAlignmentCenter, 255, 255, 255 )
    one_row.guild_name = UILabel:create_lable_2( color_yellow.."", title_x, title_y, 16,  ALIGN_CENTER )
    one_row.view:addChild( one_row.guild_name )

    -- 仙宗积分
    title_x = title_x + self.col_widthes[2] 
    -- one_row.score = UILabel:create_label_1( "", CCSize(self.col_widthes[3],25), title_x, title_y, 20, CCTextAlignmentCenter, 255, 255, 255 )
    one_row.score = UILabel:create_lable_2( color_yellow.."", title_x, title_y, 16,  ALIGN_CENTER )
    one_row.view:addChild( one_row.score )

  --每一列的分割线
    local line = CCZXImage:imageWithFile( 11, 1, width - 50, 3, UILH_COMMON.split_line )      -- 线
    one_row.view:addChild( line )  

    one_row.index = index                -- 一行的标识
    self.row_t[ one_row.index ] = one_row
	return one_row
end


-- 创建最下方的翻页按钮
function GuildTianyanLeft:create_page_button( bgpanel )
    --分页按钮高度
    local fenye_btn_h = 4

	-- 首页
    local function first_page_but_fun(eventType,x,y)
            GuildModel:tianyuan_first_page(  )
    end
    -- MUtils:create_common_btn( bgpanel, Lang.guild[24], first_page_but_fun, 25, 1 ) -- [1123]="首页"
     local first_page_but = ZTextButton:create(bgpanel,color_yellow..Lang.guild[24],UILH_COMMON.button4, first_page_but_fun, 61, fenye_btn_h,-1,-1, 1)
    

    -- 上页
    local function pre_page_but_fun(eventType,x,y)
            GuildModel:tianyuan_pre_page(  )
    end
    -- MUtils:create_common_btn( bgpanel, Lang.guild[25], pre_page_but_fun, 125, 1 ) -- [1124]="上页"
     local pre_page_but = ZTextButton:create(bgpanel,color_yellow..Lang.guild[25],UILH_COMMON.button4, pre_page_but_fun, 150, fenye_btn_h,-1,-1, 1)


    -- 下页
    local function next_page_but_fun(eventType,x,y)
            GuildModel:tianyuan_next_page(  )
    end
    -- MUtils:create_common_btn( bgpanel, Lang.guild[26], next_page_but_fun, 286, 1 ) -- [1125]="下页"
    local next_page_but = ZTextButton:create(bgpanel,color_yellow..Lang.guild[26],UILH_COMMON.button4, next_page_but_fun, 303, fenye_btn_h,-1,-1, 1)


    -- 当前页和页数。 这里都是静态的东西，先在这里写好，到刷新列表的时候，再动态设置
    self.curr_page_label = UILabel:create_label_1( color_yellow.."0/0", CCSize(70,25), 266, fenye_btn_h+23, 17, CCTextAlignmentCenter, 255, 255, 255 )
    bgpanel:addChild(self.curr_page_label)


    -- 末页
    local function last_page_but_fun(eventType,x,y)
            GuildModel:tianyuan_last_page(  )
    end
    -- MUtils:create_common_btn( bgpanel, Lang.guild[27], last_page_but_fun, 386, 1 ) -- [1126]="末页"
     local last_page_but = ZTextButton:create(bgpanel,color_yellow..Lang.guild[27],UILH_COMMON.button4, last_page_but_fun, 396, fenye_btn_h,-1,-1, 1)

end

-- 清空一行的数据
function GuildTianyanLeft:init_one_row( one_row )
    one_row.range:setString("")
    one_row.guild_name:setString("")
    one_row.score:setString("")
    one_row.guild = nil
end

-- 删除所有行
function GuildTianyanLeft:init_all_row(  )
    for key, one_row in pairs(self.row_t) do
        self:init_one_row( one_row )
    end
end

-- 使用一个结构设置一行的数据
function GuildTianyanLeft:set_one_row_by_guild( one_row, info, index )
    one_row.range:setString( color_yellow..index )
    one_row.guild_name:setString( color_yellow..info.name )
    one_row.score:setString( color_yellow..info.score )

    -- -- 一些行操作需要存储的数据
    one_row.guild = info            
end

-- 显示当前页所有行
function GuildTianyanLeft:show_all_row( )
    local _guild_tianyuan_list, start_index, end_index = GuildModel:get_tianyuan_curr_page_date(  )    -- 获取数据，和当前页的序列号
    local count_per_page = GuildModel:get_rows_count_per_page(  )+2
    for i = 1, count_per_page do
        if _guild_tianyuan_list[ start_index + i - 1 ] then
            self:set_one_row_by_guild( self.row_t[i] , _guild_tianyuan_list[ start_index + i - 1 ], start_index + i - 1 )
        end
    end

    -- 页号显示
    local guild_page_curr, guild_page_total = GuildModel:get_tianyuan_page_info(  )
    self.curr_page_label:setString( LH_COLOR[2]..guild_page_curr.."/"..guild_page_total )

end

-- 更新列表
function GuildTianyanLeft:update_list(  )
    self:init_all_row(  )
    self:show_all_row()
end

-- -- 更新本仙宗天元战信息
-- function GuildTianyanLeft:update_self_guild_info(  )
--     local  guild_tianyuan_range, guild_tianyuan_score = GuildModel:get_self_tianyuan_range_info(  )
--     self.score_lable:setString( " "..guild_tianyuan_score )
--     self.ranking_lable:setString( guild_tianyuan_range )
-- end

function GuildTianyanLeft:update( update_type )
    if update_type == "all" then
        self:update_list(  )
    end
end

-- function GuildTianyanLeft:destroy(  )
--    print("GuildTianyanLeft:destroy(  )")
--    Window:destroy(self)
-- end
