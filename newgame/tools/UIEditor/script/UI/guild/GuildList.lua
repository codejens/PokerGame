-- GuildList.lua
-- created by lyl on 2012-12-26
--alter by xiehande on 2014-12-11

-- 仙宗列表主窗口

super_class.GuildList( Window )

-- local _count_per_page = 6      -- 每页显示的行数
-- local _page_curr      = 0      -- 记录当前页
-- local _page_total     = 0      -- 记录最大页数，跳转至末页功能用

local font_size = 16
local color_yellow = LH_COLOR[2]

local fenye_btn_h = 6

--窗体大小
local window_width =880
local window_height = 520

function GuildList:create(  )
    return GuildList("GuildList", "", false, window_width, window_height )
end

function GuildList:__init( )
     window_width = self.view:getSize().width
    window_height =  self.view:getSize().height
	self.label_t = {}                  -- 存储label使用，动态修改或者删除相关显示文字
	self.row_t   = {}                  -- 存储每一行的对象， 用来修改每行数据
	self.curr_page_label = nil         -- 下面按钮中的页数显示label:当前页
	self.total_page_label = nil        -- 下面按钮中的页数显示label:总也数 
	self.apply_guild_t   = {}          -- 记录已经申请过的仙宗，申请过的，就显示已申请

	-- 创建个区域的面板
    self:create_main_panel( )

    GuildModel:init_guild_info()


end

-- 所有元素的背景
function GuildList:create_main_panel( )
	-- self.col_widthes = { 126, 144, 84, 84, 136, 136, 150}     -- 列宽，用于计算下一列的坐标.因为表头和内容显示的时候都要使用，所以在这定义  
    --未加入/加入 坐标
    self.colTX1 = { 42, 134, 283, 401, 505,591, 688, 797 }
    self.colTX2 = { 42, 138, 283, 424, 538, 649,758, 2000 }
    --未加入/加入
    self.colX1 = { 34, 139, 281, 397, 499,591, 685, 796 }
    self.colX2 = { 34, 134, 282, 423, 533,647, 752, 2000 }

    local panel = self.view

    local panel_bg = CCBasePanel:panelWithFile(0, 0, window_width, window_height, UILH_COMMON.normal_bg_v2, 500, 500)   --60 为分页栏高度
    panel:addChild(panel_bg)

    --第二层背景图
    panel_bg:addChild( CCZXImage:imageWithFile( 13, 14, 853, window_height - 26, UILH_COMMON.bottom_bg, 500, 500 ) )
    --创建表头
    local title_bg_1 = CCZXImage:imageWithFile( 5, 472, 850, 31, UILH_NORMAL.title_bg4, 500, 500 )     -- 表头结束下面有个背景线
    panel:addChild( title_bg_1)
    self:create_table_title( title_bg_1 )      -- 创建表头（列名）


    self:create_all_row( panel_bg )           -- 创建所有行。 显示的时候只修改每个元素的值

    --分页按钮的底板
    local page_panel = CCBasePanel:panelWithFile(4,16,860,60,"",500,500)
   self:create_page_button( page_panel)      -- 创建最下面的按钮
    panel:addChild(page_panel)

    self.main_panel = panel               -- 存储起来，其他方法要用
    return panel
end


-- 创建表头
function GuildList:create_table_title( panel )
	-- 表头(列名)
    local title_x = 38            -- 第一列的起始x坐标，后面的坐标要依据它与列宽（self.col_widthes）计算
	local title_y = 10
    self.title_ranking = UILabel:create_label_1(color_yellow..Lang.guild.list[1], CCSize(100,20), self.colTX1[1], title_y, font_size, CCTextAlignmentCenter, 255, 255, 255) -- [1184]="排名"
    panel:addChild( self.title_ranking,1 )

    -- title_x = title_x + self.col_widthes[1]     -- 计算下一列坐标
    self.title_guild_name = UILabel:create_label_1(color_yellow..Lang.guild.list[2], CCSize(100,20), self.colTX1[2], title_y, font_size, CCTextAlignmentCenter, 255, 255, 255) -- [1185]="仙宗名称"
    panel:addChild( self.title_guild_name,1 )

    -- title_x = title_x + self.col_widthes[2]     -- 计算下一列坐标
    self.title_wang_name = UILabel:create_label_1(color_yellow..Lang.guild.list[3], CCSize(100,20), self.colTX1[3], title_y, font_size, CCTextAlignmentCenter, 255, 255, 255) -- [1186]="仙宗宗主"
    panel:addChild( self.title_wang_name,1 )

    -- title_x = title_x + self.col_widthes[3]     -- 计算下一列坐标
    self.title_level = UILabel:create_label_1(color_yellow..Lang.guild.list[18], CCSize(100,20), self.colTX1[4], title_y, font_size, CCTextAlignmentCenter, 255, 255, 255) -- [1053]="等级"
    panel:addChild( self.title_level,1 )

    -- title_x = title_x + self.col_widthes[4]     -- 计算下一列坐标
    self.title_memb_count = UILabel:create_label_1(color_yellow..Lang.guild.list[4], CCSize(100,20), self.colTX1[5], title_y, font_size, CCTextAlignmentCenter, 255, 255, 255) -- [1187]="仙宗成员"
    panel:addChild( self.title_memb_count,1 )

    -- title_x = title_x + self.col_widthes[5]     -- 计算下一列坐标
    self.title_camp = UILabel:create_label_1(color_yellow .. Lang.guild.list[31], CCSize(100,20), self.colTX1[6], title_y, font_size, CCTextAlignmentCenter, 255, 255, 255) -- [722]="阵营"
    panel:addChild( self.title_camp ,1)

    -- title_x = title_x + self.col_widthes[6]     -- 计算下一列坐标
    self.title_introduce = UILabel:create_label_1(color_yellow..Lang.guild.list[5], CCSize(100,20), self.colTX1[7], title_y, font_size, CCTextAlignmentCenter, 255, 255, 255) -- [1188]="仙宗介绍"
    panel:addChild( self.title_introduce,1 )

    -- title_x = title_x + self.col_widthes[7]     -- 计算下一列坐标
    self.title_apply = UILabel:create_label_1(color_yellow..Lang.guild.list[6], CCSize(100,20), self.colTX1[8], title_y, font_size, CCTextAlignmentCenter, 255, 255, 255) -- [1189]="加入仙宗"
    panel:addChild( self.title_apply,1 )
end

-- 创建所有行
function GuildList:create_all_row( panel )
    local row_begin_x = 6
    local row_begin_y = 405
    local row_height = 66
    local row_width  = 850
    local count_per_page = GuildModel:get_rows_count_per_page(  )
    for i = 1, count_per_page do
        local one_row = self:create_one_row( row_begin_x, row_begin_y - (i - 1) * row_height, row_width, row_height, "" )
        panel:addChild( one_row.view )
    end

    -- 前三名的名次图标.  这三个图标的位置是固定的，只要控制是否显示就行了
    -- self.ranking_first_image = CCZXImage:imageWithFile( 17, 250 + 15, 47, 34, "ui/guild/ranging_diyi.png", 500, 500 )
    -- panel:addChild( self.ranking_first_image, 10 )
    -- self.ranking_second_image = CCZXImage:imageWithFile( 17, 210 + 15, 47, 34, "ui/guild/ranging_dier.png", 500, 500 )
    -- panel:addChild( self.ranking_second_image, 10 )
    -- self.ranking_third_image = CCZXImage:imageWithFile( 17, 170 + 15, 47, 34, "ui/guild/ranging_disan.png", 500, 500 )
    -- panel:addChild( self.ranking_third_image, 10 )

end

-- 创建一行
function GuildList:create_one_row( pos_x, pos_y, width, height, texture_name )
    local guild={}
    local one_row = {}
  --  local ranking_image_t = {}                 -- 存储前三名图标图片
    one_row.view = CCBasePanel:panelWithFile( pos_x, pos_y, width, height, texture_name )
	local function f1(eventType,x,y)
        if eventType == TOUCH_BEGAN then
            return false               -- 让主面板可以相应，关闭tips
        end
        return true
    end
    one_row.view:registerScriptHandler(f1)    --注册
	
   -- local title_x = 40            -- 第一列的起始x坐标，后面的坐标要依据它与列宽（self.col_widthes）计算
    local title_y = 48
	-- 排名  
	one_row.ranking = UILabel:create_label_1(guild.ranking, CCSize(100,25), self.colX1[1], title_y, 16, CCTextAlignmentCenter, 208, 205, 162 )
    one_row.view:addChild( one_row.ranking )

    -- 前三名的名次图标. 
    -- ranking_image_t[ 1 ] = CCZXImage:imageWithFile( 5, 10, 47, 34, UIResourcePath.FileLocate.guild .. "ranging_diyi.png", 500, 500 )
    -- one_row.view:addChild( ranking_image_t[ 1 ], 10 )
    -- ranking_image_t[ 2 ] = CCZXImage:imageWithFile( 5, 10, 47, 34, UIResourcePath.FileLocate.guild .. "ranging_dier.png", 500, 500 )
    -- one_row.view:addChild( ranking_image_t[ 2 ], 10 )
    -- ranking_image_t[ 3 ] = CCZXImage:imageWithFile( 5, 10, 47, 34, UIResourcePath.FileLocate.guild .. "ranging_disan.png", 500, 500 )
    -- one_row.view:addChild( ranking_image_t[ 3 ], 10 )

    local function update_ranking( ranking_value )
        one_row.ranking:setString( ranking_value )
        -- for key, image in pairs(ranking_image_t) do
        --     image:setIsVisible( false )
        -- end
        -- if ranking_value == 1 or ranking_value == 2 or ranking_value == 3 then
        --     ranking_image_t[ ranking_value ]:setIsVisible( true )
        -- end
    end

    -- 仙宗名称
    -- title_x = title_x + self.col_widthes[1] 
    one_row.name = UILabel:create_label_1(guild.name, CCSize(100,25), self.colX1[2], title_y, 16, CCTextAlignmentCenter, 208, 205, 162)
    one_row.view:addChild( one_row.name )

    -- 仙宗宗主
    -- title_x = title_x + self.col_widthes[2] 
    -- one_row.wang_name = QQVipInterface:create_qq_vip_info( 0, "name" )
    --one_row.wang_name = QQVIPName:create_qq_vip_info(0, "name")
    -- one_row.wang_name:setAnchorPoint(0.5, 0)
    -- one_row.wang_name:setPosition( self.colX1[3], title_y-7 )
    -- one_row.view:addChild( one_row.wang_name.view )
    one_row.wang_name = UILabel:create_label_1(  guild.wang_name, CCSize(100,25), self.colX1[3], title_y, 16, CCTextAlignmentCenter, 208, 205, 162 )
    one_row.view:addChild( one_row.wang_name )

    -- 等级
    -- title_x = title_x + self.col_widthes[3] 
    one_row.level = UILabel:create_label_1(  guild.level, CCSize(100,25), self.colX1[4], title_y, 16, CCTextAlignmentCenter, 208, 205, 162 )
    one_row.view:addChild( one_row.level )

    -- 仙宗成员数量
    -- title_x = title_x + self.col_widthes[4] 
    one_row.memb_count = UILabel:create_label_1( guild.memb_count, CCSize(100,25), self.colX1[5], title_y, 16, CCTextAlignmentCenter, 208, 205, 162 )
    one_row.view:addChild( one_row.memb_count )

    -- 阵营
   -- title_x = title_x + self.col_widthes[5] 

    one_row.camp = UILabel:create_label_1(guild.camp, CCSize(100,25), self.colX1[6], title_y, 16, CCTextAlignmentCenter, 208, 205, 162 )
    one_row.view:addChild( one_row.camp )
    

    -- 查看按钮
    local function but_1_fun(eventType,x,y)
        if eventType == TOUCH_CLICK then
            GuildModel:show_guild_detail( one_row.guild )
        end
        return true
    end
    one_row.introduce_but = MUtils:create_btn(one_row.view,
        UILH_COMMON.button2_sel,
        UILH_COMMON.button2_sel,
        but_1_fun,
        self.colX1[7], 5, -1, -1)
    local btn_txt = UILabel:create_lable_2(color_yellow..Lang.guild.list[30], 126/2, 15, 16)
    local b_size =  one_row.introduce_but:getSize()
    local t_size =  btn_txt:getSize()
    btn_txt:setPosition(b_size.width/2-t_size.width/2,b_size.height/2-t_size.height/2+3)
    one_row.introduce_but:addChild(btn_txt)
    one_row.introduce_but:setAnchorPoint(0.5, 0)
    one_row.introduce_but:setIsVisible( false )



    -- 已经申请   -->现在改为 取消申请   点击后取消申请
    local function but_2_fun(eventType,x,y)
          if eventType == TOUCH_CLICK then
          local player = EntityManager:get_player_avatar()
          GuildModel:cancel_to_join_guild(one_row.guild.guild_id, player.id)
          end
        return true
    end
    one_row.join_but_had_apply = MUtils:create_btn(one_row.view,
        UILH_COMMON.lh_button2,
        UILH_COMMON.lh_button2,
        but_2_fun,
        self.colX1[8], 5, -1, -1)
    one_row.join_but_had_apply:addTexWithFile(CLICK_STATE_DISABLE, UILH_COMMON.btn_dis)
    local btn_txt = UILabel:create_lable_2(color_yellow..Lang.guild.list[7], 126/2, 15, 16)
    local b_size =  one_row.join_but_had_apply:getSize()
    local t_size =  btn_txt:getSize()
    btn_txt:setPosition(b_size.width/2-t_size.width/2,b_size.height/2-t_size.height/2+3)

    one_row.join_but_had_apply:addChild(btn_txt)
    one_row.join_but_had_apply:setAnchorPoint(0.5, 0)
    one_row.join_but_had_apply:setIsVisible( false )
    one_row.join_but_had_apply:setCurState( CLICK_STATE_DISABLE ) 


    -- 申请加入
    local function but_3_fun(eventType,x,y)
        if eventType == TOUCH_CLICK then
            if GuildModel:join_guild_num() >= 3 then
                return GlobalFunc:create_screen_notic(Lang.guild.apply[2])
            end
            if not GuildModel:check_if_had_apply_guild( one_row.guild.guild_id ) then
                GuildModel:apply_to_join_guild( one_row.guild.guild_id )
            end
        end
        return true
    end
    one_row.join_but_not_apply = MUtils:create_btn(one_row.view,
        UILH_COMMON.lh_button2,
        UILH_COMMON.lh_button2,
        but_3_fun,
        self.colX1[7], 5, -1, -1)
    local btn_txt = UILabel:create_lable_2(color_yellow..Lang.guild.list[8], 126/2, 15, 16) --申请加入

     b_size =  one_row.join_but_not_apply:getSize()
     t_size =  btn_txt:getSize()
    btn_txt:setPosition(b_size.width/2-t_size.width/2,b_size.height/2-t_size.height/2+3)
    one_row.join_but_not_apply:addChild(btn_txt)
    one_row.join_but_not_apply:setAnchorPoint(0.5, 0)
    one_row.join_but_not_apply:setIsVisible( false )


    --每一行的分割线
    local line = CCZXImage:imageWithFile( 21, 1, window_width-54, 3, UILH_COMMON.split_line )     
    one_row.view:addChild( line )  


    -- 提供给外部调用的方法
    one_row.update_ranking2 = function( ranking_value )
        update_ranking( ranking_value )
    end

    self.row_t[ #self.row_t + 1 ] = one_row
	return one_row
end


-- 创建最下方的翻页按钮
function GuildList:create_page_button( bgpanel )
	-- 首页
    local function first_page_but_fun()
        GuildModel:guild_first_first_page(  )
    end
    --xiehande  通用按钮修改  --btn_lv2.png ->button2.png
    local btn = ZTextButton:create(bgpanel,color_yellow..Lang.guild[24],UILH_COMMON.button4, first_page_but_fun, 220, fenye_btn_h,-1,-1, 1)
    -- MUtils:create_common_btn( bgpanel, LangGameString[1123], first_page_but_fun, 194, 12 ) -- [1123]="首页"
    -- local first_page_but = UIButton:create_button_with_name( 130 + 50, 5, 60, 31, "ui/common/button2_bg.png", "ui/common/button2_bg.png", nil, "首页", first_page_but_fun )
    -- bgpanel:addChild( first_page_but )
    
    -- 上页
    local function pre_page_but_fun()
        GuildModel:guild_list_pre_page( )
    end
    btn = ZTextButton:create(bgpanel,color_yellow..Lang.guild[25],UILH_COMMON.button4, pre_page_but_fun, 308, fenye_btn_h,-1,-1, 1)
    -- MUtils:create_common_btn( bgpanel, LangGameString[1124], pre_page_but_fun, 294, 12 ) -- [1124]="上页"
    -- local pre_page_but = UIButton:create_button_with_name( 200 + 50, 5, 60, 31, "ui/common/button2_bg.png", "ui/common/button2_bg.png", nil, "上页", pre_page_but_fun )
    -- bgpanel:addChild( pre_page_but )

    -- 下页
    local function next_page_but_fun()
        GuildModel:guild_list_next_page( )
    end
    btn = ZTextButton:create(bgpanel,color_yellow..Lang.guild[26],UILH_COMMON.button4, next_page_but_fun, 466, fenye_btn_h,-1,-1, 1)
    -- MUtils:create_common_btn( bgpanel, LangGameString[1125], next_page_but_fun, 464, 12 ) -- [1125]="下页"
    -- local next_page_but = UIButton:create_button_with_name( 340 + 50, 5, 60, 31, "ui/common/button2_bg.png", "ui/common/button2_bg.png", nil, "下页", next_page_but_fun )
    -- bgpanel:addChild( next_page_but )

    -- 当前页和页数。 这里都是静态的东西，先在这里写好，到刷新列表的时候，再动态设置
    --local cur_page_frame = CCBasePanel:panelWithFile( 399, fenye_btn_h+12, -1, -1, "")
    self.curr_page_label = UILabel:create_label_1( color_yellow.."0/0", CCSize(70,25), 423, fenye_btn_h+23, 17, CCTextAlignmentCenter, 255, 255, 255 )
    bgpanel:addChild(self.curr_page_label)
   -- bgpanel:addChild(cur_page_frame)

    -- 末页
    local function last_page_but_fun()
        GuildModel:guild_last_first_page(  )
    end
    btn = ZTextButton:create(bgpanel,color_yellow..Lang.guild[27],UILH_COMMON.button4, last_page_but_fun, 556, fenye_btn_h,-1,-1, 1)
    -- MUtils:create_common_btn( bgpanel, LangGameString[1126], last_page_but_fun, 564, 12 ) -- [1126]="末页"
    -- local last_page_but = UIButton:create_button_with_name( 410 + 50, 5, 60, 31, "ui/common/button2_bg.png", "ui/common/button2_bg.png", nil, "末页", last_page_but_fun )
    -- bgpanel:addChild( last_page_but )

    -- 跳转的页数输入框
    self.enter_frame = CCBasePanel:panelWithFile( 696, fenye_btn_h+7, 55, 30, UILH_NORMAL.text_bg2,500,500)
    bgpanel:addChild( self.enter_frame )
    local function enter_frame_fun(eventType,x,y)
        if eventType == TOUCH_CLICK then
            GuildModel:enter_num_go_to_page( )
            return false 
        end
        return true
    end
    self.enter_frame:registerScriptHandler( enter_frame_fun ) 
    -- 输入框中数字
    self.enter_frame_lable = UILabel:create_label_1( "1", CCSize(100,20), 29, 17, 17,  CCTextAlignmentCenter, 255, 255, 255)
    self.enter_frame:addChild( self.enter_frame_lable )

    -- 跳转
    local function goto_page_but_fun()
        GuildModel:guild_list_goto_page( )
    end
    btn = ZTextButton:create(bgpanel,color_yellow..Lang.guild.list[9],UILH_COMMON.button4, goto_page_but_fun, 766, fenye_btn_h,-1,-1, 1)
    -- MUtils:create_common_btn( bgpanel, LangGameString[1192], goto_page_but_fun, 738, 12 ) -- [1192]="跳转"
    -- local goto_page_but = UIButton:create_button_with_name( 550 + 88, 5, 60, 31, "ui/common/button2_bg.png", "ui/common/button2_bg.png", nil, "跳转", goto_page_but_fun )
    -- bgpanel:addChild( goto_page_but )

end

-- 清空一行的数据
function GuildList:init_one_row( one_row )
    -- one_row.ranking:setString("")
    one_row.update_ranking2( "" )
    one_row.name:setString("")
    one_row.wang_name:setString("")
    --QQVIPName:reinit_info( one_row.wang_name, 0, "" )
    -- QQVipInterface:reinit_info( one_row.wang_name, 0, "" )
    one_row.level:setString("")
    one_row.memb_count:setString("")
     one_row.camp:setString("")
    one_row.introduce_but:setIsVisible( false )
    one_row.join_but_had_apply:setIsVisible( false )
    one_row.join_but_not_apply:setIsVisible( false )

    one_row.guild = nil
end

-- 删除所有行
function GuildList:init_all_row(  )
    for key, one_row in pairs(self.row_t) do
        self:init_one_row( one_row )
    end
end

-- 使用一个仙宗结构设置一行的数据
function GuildList:set_one_row_by_guild( one_row, guild )
    -- one_row.ranking:setString( guild.ranking )
    one_row.update_ranking2( color_yellow..guild.ranking )
    one_row.name:setString( color_yellow..guild.name )
    one_row.wang_name:setString( color_yellow..guild.wang_name )
    -- QQVipInterface:reinit_info( one_row.wang_name, guild.qqvip, guild.wang_name )
    --QQVIPName:reinit_info(one_row.wang_name, guild.qqvip, guild.wang_name)
    one_row.level:setString( color_yellow..guild.level )
    local max_memb_count = GuildModel:get_guild_level_max_count( guild ) or ""
    one_row.memb_count:setString( color_yellow..guild.memb_count.."/"..max_memb_count )
     local camp_name_t = {Lang.guild.create.camp[1], Lang.guild.create.camp[2], Lang.guild.create.camp[3]} -- [1179]="#cff1493逍遥" -- [1180]="#c0000ff星辰" -- [1181]="#c00ff00逸仙"
    one_row.camp:setString( color_yellow..camp_name_t[guild.camp] or "")
    one_row.introduce_but:setIsVisible( true )
    -- print( guild.guild_id )
    -- print(GuildModel:check_if_had_apply_guild( guild.guild_id ))
    if GuildModel:check_if_had_apply_guild( guild.guild_id ) then
        one_row.join_but_had_apply:setIsVisible( true )
        one_row.join_but_not_apply:setIsVisible( false )
    else
        one_row.join_but_had_apply:setIsVisible( false )
        one_row.join_but_not_apply:setIsVisible( true )
        -- 如果仙宗已满，变成不可点击状态
        if GuildModel:check_guild_count_full( guild ) then
            one_row.join_but_not_apply:setCurState( CLICK_STATE_DISABLE ) 
        else
            one_row.join_but_not_apply:setCurState( CLICK_STATE_UP ) 
        end
    end
    -- 一些行操作需要存储的数据
    one_row.guild = guild            
end


-- 显示当前页所有行
function GuildList:show_all_row( )
    local guild_info = GuildModel:get_curr_page_date()    -- 获取当前页数据
    for i = 1, #guild_info do
        self:set_one_row_by_guild( self.row_t[i], guild_info[i] )
    end

    -- 页号显示
    local guild_page_curr, guild_page_total = GuildModel:get_guild_info_page_info(  )
    self.curr_page_label:setString( color_yellow..guild_page_curr.."/"..guild_page_total )

    -- -- 显示前三名图标
    -- local ranking_first_check, ranking_second_check, ranking_third_check = GuildModel:check_if_has_three_ranking(  )
    -- if ranking_first_check then
    --     self.ranking_first_image:setIsVisible( true )
    -- else
    --     self.ranking_first_image:setIsVisible( false )
    -- end
    -- if ranking_second_check then
    --     self.ranking_second_image:setIsVisible( true )
    -- else
    --     self.ranking_second_image:setIsVisible( false )
    -- end
    -- if ranking_third_check then
    --     self.ranking_third_image :setIsVisible( true )
    -- else
    --     self.ranking_third_image:setIsVisible( false )
    -- end

    -- 根据当前是未加入仙宗的页面还是已加入仙宗的页面，改变显示坐标
    self:reflash_colums_position(  )

end

-- 根据当前是否加入仙宗，从新设置列的位置
function GuildList:reflash_colums_position(  )
    local title_x = 38 
    local title_y = 10
    local colTX = nil
    if GuildModel:check_if_join_guild( ) then
        colTX = self.colTX2   -- 已加入仙宗状态下的列宽
    else
        colTX = self.colTX1     -- 列宽，用于计算下一列的坐标.
    end
    self.title_ranking:setPosition( colTX[1], title_y )
    -- title_x = title_x + self.col_widthes[1]     -- 计算下一列坐标
    self.title_guild_name:setPosition( colTX[2], title_y )
    -- title_x = title_x + self.col_widthes[2]     -- 计算下一列坐标
    self.title_wang_name:setPosition( colTX[3], title_y )
    -- title_x = title_x + self.col_widthes[3]     -- 计算下一列坐标
    self.title_level:setPosition( colTX[4], title_y )
    -- title_x = title_x + self.col_widthes[4]     -- 计算下一列坐标
    self.title_memb_count:setPosition( colTX[5], title_y )
    -- title_x = title_x + self.col_widthes[5]     -- 计算下一列坐标
    self.title_camp:setPosition(  colTX[6], title_y )
    -- title_x = title_x + self.col_widthes[6]     -- 计算下一列坐标
    self.title_introduce:setPosition( colTX[7], title_y )
    -- title_x = title_x + self.col_widthes[7]     -- 计算下一列坐标
    self.title_apply:setPosition( colTX[8], title_y )

    for key, one_row in ipairs( self.row_t ) do
        self:reflash_rows_position( one_row )
    end
end

-- 设置一列的坐标
function GuildList:reflash_rows_position( one_row )
    local title_x = 35            -- 第一列的起始x坐标，后面的坐标要依据它与列宽（self.col_widthes）计算
    local title_y = 28
    local colX = nil
    if GuildModel:check_if_join_guild( ) then
        colX = self.colX2   -- 已加入仙宗状态下的列宽
    else
        colX = self.colX1     -- 列宽，用于计算下一列的坐标.
    end
    one_row.ranking:setPosition( colX[1], title_y )
    -- title_x = title_x + self.col_widthes[1] 
    one_row.name:setPosition( colX[2], title_y )
    -- title_x = title_x + self.col_widthes[2] 
    one_row.wang_name:setPosition( colX[3], title_y )
    -- title_x = title_x + self.col_widthes[3] 
    one_row.level:setPosition( colX[4], title_y )
    -- title_x = title_x + self.col_widthes[4] 
    one_row.memb_count:setPosition( colX[5], title_y )
    -- title_x = title_x + self.col_widthes[5] 
    one_row.camp:setPosition( colX[6], title_y )
    -- title_x = title_x + self.col_widthes[6] 
    one_row.introduce_but:setPosition( colX[7], 6  )
    -- title_x = title_x + self.col_widthes[7] 
    one_row.join_but_had_apply:setPosition( colX[8], 6 )
    -- title_x = title_x + self.col_widthes[7] 
    one_row.join_but_not_apply:setPosition( colX[8], 6 )


end

-- 更新
function GuildList:update( update_type )
    -- ZXLog("===========GuildList:update: ", update_type)
    if update_type == "guild_list" then
        self:update_guild_list( )
    elseif update_type == "goto_page_num" then
        self:set_enter_frame_num(  )
    elseif update_type == "all" then
        self:update_guild_list( )
        if GuildModel:check_if_join_guild( ) then
            GuildModel:guild_list_goto_page( )
        end
    end
end

-- 更新仙宗列表
function GuildList:update_guild_list( )
    -- 如果包含有参数guild_id，就要改变加入已申请表
    -- if guild_id then
    --     self.apply_guild_t[ tostring(guild_id) ] = true
    -- end
    self:init_all_row(  )
    self:show_all_row( )
end

-- 设置当前输入的跳转的页面数字
function GuildList:set_enter_frame_num(  )
    local num = GuildModel:get_enter_goto_page_num( )
    self.enter_frame_lable:setString( num )
end
