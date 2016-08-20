-- GuildMember.lua
-- created by lyl on 2012-1-25
--alter by xiehande on 2014-12-11

-- 仙宗成员管理页

local if_sele_be_self = false

local font_size = 16
--窗体大小
local window_width =880
local window_height = 520
--分页按钮高度
local fenye_btn_h = 6
super_class.GuildMember( Window )

function GuildMember:create(  )
    return GuildMember( "GuildMember", "", false, window_width,window_height )
end

function GuildMember:__init( )
    window_width = self.view:getSize().width
    window_height =  self.view:getSize().height
	self.row_t   = {}                  -- 存储每一行的对象， 用来修改每行数据
    self.curr_page_label = nil         -- 下面按钮中的页数显示label:当前页
	-- 创建个区域的面板
    self:create_main_panel( )
    
    GuildModel:request_member_info(  )     -- 申请数据

    self:create_appoint_bg()
end

-- 所有元素的背景
function GuildMember:create_main_panel( )
	--self.col_widthes = { 118, 91, 91, 108, 141, 149}     -- 列宽，用于计算下一列的坐标.因为表头和内容显示的时候都要使用，所以在这定义
	self.select_row_index = nil                          -- 当前选中列

    local panel = self.view

    local panel_bg = CCBasePanel:panelWithFile(0, 0, window_width, window_height, UILH_COMMON.normal_bg_v2,500,500)
    panel:addChild(panel_bg)


    --第二层背景图
    panel_bg:addChild( CCZXImage:imageWithFile( 13, 14, 853, window_height - 26, UILH_COMMON.bottom_bg, 500, 500 ) )



    --创建表头
    local title_bg_1 = CCZXImage:imageWithFile( 5, 472, 850, 31, UILH_NORMAL.title_bg4, 500, 500 ) 
    panel_bg:addChild( title_bg_1 )
    self:create_table_title( title_bg_1 )      -- 创建表头（列名）


    self:create_all_row( panel_bg )           -- 创建所有行。 显示的时候只修改每个元素的值
    -- self:create_apply_button( panel )      -- 创建申请列表按钮

        --分页按钮的底板
    local page_panel = CCBasePanel:panelWithFile(4,16,860,60,"",500,500)
    self:create_page_button( page_panel )      -- 创建最下面的按钮
    panel:addChild(page_panel)


    self.main_panel = panel               -- 存储起来，其他方法要用
    return panel
end

-- 创建表头
function GuildMember:create_table_title( panel )
	-- 表头(列名)
    local title_y = 16
    self.colTX1 = { 68, 192, 298, 436,518, 613, 777 } 

    local label_temp = UILabel:create_label_1(LH_COLOR[2]..Lang.guild.list[10], CCSize(100,20), self.colTX1[1], title_y, font_size, CCTextAlignmentCenter, 255, 255, 255) -- [1193]="名称"
    panel:addChild( label_temp)

    --title_x = 156+20     -- 计算下一列坐标
    local label_temp = UILabel:create_label_1(LH_COLOR[2]..Lang.guild.list[18], CCSize(100,20), self.colTX1[2], title_y, font_size, CCTextAlignmentCenter, 255, 255, 255) -- [1053]="等级"
    panel:addChild( label_temp )

   -- title_x = 248+20     -- 计算下一列坐标
    local label_temp = UILabel:create_label_1(LH_COLOR[2]..Lang.guild.list[19], CCSize(100,20), self.colTX1[3], title_y, font_size, CCTextAlignmentCenter, 255, 255, 255) -- [1054]="职业"
    panel:addChild( label_temp )

  --  title_x = 340+20     -- 计算下一列坐标
    local label_temp = UILabel:create_label_1(LH_COLOR[2]..Lang.guild.list[11], CCSize(100,20), self.colTX1[4], title_y, font_size, CCTextAlignmentCenter, 255, 255, 255) -- [1194]="职位"
    panel:addChild( label_temp )

  --  title_x = 446+20     -- 计算下一列坐标
    -- local label_temp = UILabel:create_label_1("#cffff00"..Lang.guild.list[12], CCSize(100,20), self.colTX1[5], title_y, font_size, CCTextAlignmentCenter, 255, 255, 255) -- [1195]="性别"
    -- panel:addChild( label_temp )

 --   title_x = 588+20     -- 计算下一列坐标
    local label_temp = UILabel:create_label_1(LH_COLOR[2]..Lang.guild.list[21], CCSize(100,20), self.colTX1[6], title_y, font_size, CCTextAlignmentCenter, 255, 255, 255) -- [802]="仙宗贡献"
    panel:addChild( label_temp )

    --是否在线
  --  title_x = 736+10     -- 计算下一列坐标
    local label_temp = UILabel:create_label_1(LH_COLOR[2]..Lang.guild.list[24], CCSize(100,20), self.colTX1[7], title_y, font_size, CCTextAlignmentCenter, 255, 255, 255)
    panel:addChild( label_temp )
end


-- 创建所有行
function GuildMember:create_all_row( panel )
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
function GuildMember:create_one_row( pos_x, pos_y, width, height, texture_name, index )
    local guild={ }
    local one_row = {}
    one_row.guild = guild               

    one_row.view = CCBasePanel:panelWithFile( pos_x, pos_y, width, height, texture_name, 500, 500 )
    one_row.selected_frame = CCZXImage:imageWithFile( 7, 2, width, height, UILH_COMMON.select_focus, 500, 500 )   -- 选中状态的框
    one_row.view:addChild( one_row.selected_frame )
    one_row.selected_frame:setIsVisible( false )

	local function f1(eventType,x,y)
        if eventType == TOUCH_ENDED then
            if one_row.guild then          -- 根据是否绑定了数据判断是否存在这一行
                GuildModel:show_guild_left_menu( one_row.guild )
                self:set_row_selected_by_index( index )
            end
            -- 如果是宗主，点击改行后任命
            -- GuildModel:show_nominate_menu( one_row.guild )
        end
        return true
    end
    one_row.view:registerScriptHandler(f1)
    

    --列表中值的位置
	self.colX1 = {65,188,296,433,508,613,776}
    local title_y = 32
	-- 名称
    --one_row.name = QQVIPName:create_qq_vip_info(0, "name")
    -- one_row.name = QQVipInterface:create_qq_vip_info( 0, "name" )
    -- one_row.view:addChild( one_row.name.view )
    -- one_row.name.view:setPosition( 0, 20 )
	one_row.name = UILabel:create_label_1( guild.name, CCSize(100,25), self.colX1[1], title_y, font_size, CCTextAlignmentCenter, 255, 255, 255 )
    one_row.view:addChild( one_row.name )

    -- 等级
    --title_x = 150+20
    one_row.level = UILabel:create_label_1( guild.level, CCSize(100,25), self.colX1[2], title_y, font_size, CCTextAlignmentCenter, 255, 255, 255 )
    one_row.view:addChild( one_row.level )

    -- 职业
 --   title_x = 242+20
    one_row.job = UILabel:create_label_1( guild.job, CCSize(100,25), self.colX1[3], title_y, font_size, CCTextAlignmentCenter, 255, 255, 255 )
    one_row.view:addChild( one_row.job )

    -- 职位
   -- title_x = 334+20
    one_row.standing = UILabel:create_label_1( guild.standing, CCSize(100,25), self.colX1[4], title_y, font_size, CCTextAlignmentCenter, 255, 255, 255 )
    one_row.view:addChild( one_row.standing )

    -- 性别
    --title_x = 442+20
    -- one_row.sex = UILabel:create_label_1( guild.sex, CCSize(100,25), self.colX1[5], title_y, font_size, CCTextAlignmentCenter, 255, 255, 255 )
    -- one_row.view:addChild( one_row.sex )

    -- 军团贡献
   -- title_x = 582+20
    one_row.contribution = UILabel:create_label_1( guild.all_contribution, CCSize(100,25), self.colX1[6], title_y, font_size, CCTextAlignmentCenter, 255, 255, 255 )
    one_row.view:addChild( one_row.contribution )
    
    -- 离线时间
   -- title_x = 732+10
    one_row.if_on_line = UILabel:create_label_1( "", CCSize(100,25), self.colX1[7], title_y, font_size, CCTextAlignmentCenter, 255, 255, 255 )
    one_row.view:addChild( one_row.if_on_line )


    --每一列的分割线
    local line = CCZXImage:imageWithFile( 21, 1, window_width-54, 3, UILH_COMMON.split_line )       -- 线
    one_row.view:addChild( line )  

    one_row.index = index                -- 一行的标识
    self.row_t[ one_row.index ] = one_row
	return one_row
end

function GuildMember:format_time( time )
    local hour = math.floor(time/3600)
    if hour > 24 then
        return math.floor(hour/24)..Lang.guild.list[25]
    elseif hour > 0 then
        return hour..Lang.guild.list[26]
    else
        return 0;
    end
end

-- 创建申请管理按钮
function GuildMember:create_apply_button( bgpanel )
    local function apply_but_fun( eventType, x, y )
        if eventType == TOUCH_CLICK then
            GuildModel:show_apply_list_win( )
        end
        return true
    end
    MUtils:create_common_btn( bgpanel, Lang.guild.tab[3], apply_but_fun, 10, 8 ) -- [2357]="申请列表"
end

-- 创建最下方的翻页按钮
function GuildMember:create_page_button( bgpanel )

	-- 首页
    local function first_page_but_fun()
        print("首页")
        GuildModel:member_first_page(  )
    end

    local btn = ZTextButton:create(bgpanel,LH_COLOR[2]..Lang.guild[24],UILH_COMMON.button4, first_page_but_fun, 220, fenye_btn_h,-1,-1, 1)
    -- MUtils:create_common_btn( bgpanel, LangGameString[1123], first_page_but_fun, 160, 12 ) -- [1123]="首页"
    -- local first_page_but = UIButton:create_button_with_name( 130 + 50, 5, 60, 31, "ui/common/button2_bg.png", "ui/common/button2_bg.png", nil, "首页", first_page_but_fun )
    -- bgpanel:addChild( first_page_but )
    
    -- 上页
    local function pre_page_but_fun()
                print("上页")
        GuildModel:member_pre_page(  )
    end
    btn = ZTextButton:create(bgpanel,LH_COLOR[2]..Lang.guild[25],UILH_COMMON.button4, pre_page_but_fun, 308, fenye_btn_h,-1,-1, 1)
    -- MUtils:create_common_btn( bgpanel, LangGameString[1124], pre_page_but_fun, 260, 12) -- [1124]="上页"
    -- local pre_page_but = UIButton:create_button_with_name( 200 + 50, 5, 60, 31, "ui/common/button2_bg.png", "ui/common/button2_bg.png", nil, "上页", pre_page_but_fun )
    -- bgpanel:addChild( pre_page_but )


    -- 下页
    local function next_page_but_fun()
         print("下页")
        GuildModel:member_next_page(  )
    end
    btn = ZTextButton:create(bgpanel,LH_COLOR[2]..Lang.guild[26],UILH_COMMON.button4, next_page_but_fun, 466, fenye_btn_h,-1,-1, 1)
    -- MUtils:create_common_btn( bgpanel, LangGameString[1125], next_page_but_fun, 430, 12 ) -- [1125]="下页"
    -- local next_page_but = UIButton:create_button_with_name( 340 + 50, 5, 60, 31, "ui/common/button2_bg.png", "ui/common/button2_bg.png", nil, "下页", next_page_but_fun )
    -- bgpanel:addChild( next_page_but )


    -- 当前页和页数。 
    --local cur_page_frame = CCBasePanel:panelWithFile( 398, 50, 70, 50, "", 500, 500 )
    self.curr_page_label = UILabel:create_label_1( LH_COLOR[2].."0/0", CCSize(70,25), 423, fenye_btn_h+23, 17, CCTextAlignmentCenter, 255, 255, 255 )
     --bgpanel:addChild(curr_page_label)
  --  cur_page_frame:addChild(self.curr_page_label)
   bgpanel:addChild(self.curr_page_label)


    -- 末页
    local function last_page_but_fun()
        GuildModel:member_last_page(  )
    end
    btn = ZTextButton:create(bgpanel,LH_COLOR[2]..Lang.guild[27],UILH_COMMON.button4, last_page_but_fun, 556, fenye_btn_h,-1,-1, 1)
    -- MUtils:create_common_btn( bgpanel, LangGameString[1126], last_page_but_fun, 530, 12 ) -- [1126]="末页"
    -- local last_page_but = UIButton:create_button_with_name( 410 + 50, 5, 60, 31, "ui/common/button2_bg.png", "ui/common/button2_bg.png", nil, "末页", last_page_but_fun )
    -- bgpanel:addChild( last_page_but )


    -- 任命
    local function nominaate_but_fun(eventType,x,y)
        if eventType == TOUCH_CLICK then
           --弹出alertWin的窗体
           -- GuildModel:show_nominate_menu( self.row_t[ self.select_row_index ].guild )
           --弹出任命窗体
           GuildModel:show_appoint_menu(self.row_t[ self.select_row_index ].guild )
        end
        return true
    end
    self.nominate_but = MUtils:create_btn(bgpanel,
        UILH_COMMON.button4,
        UILH_COMMON.button4,
        nominaate_but_fun,
        749, fenye_btn_h, -1, -1)
    local btn_txt = UILabel:create_lable_2(LH_COLOR[2]..Lang.guild.list[14], 96/2, 21, 16)
    local nominate_size = self.nominate_but:getSize()
    local txt_size  = btn_txt:getSize()
    btn_txt:setPosition(nominate_size.width/2-txt_size.width/2,nominate_size.height/2-txt_size.height/2+3)
    self.nominate_but:addChild(btn_txt)
    -- self.nominate_but = MUtils:create_common_btn( bgpanel, LangGameString[1197], nominaate_but_fun, 640, 12 ) -- [1197]="任命"
    -- self.nominate_but = UIButton:create_button_with_name( 480 + 88, 5, 60, 31, "ui/common/button2_bg.png", "ui/common/button2_bg.png", nil, "任命", nominaate_but_fun )
    -- bgpanel:addChild( self.nominate_but )


    -- 踢出
    local function goto_page_but_fun(eventType,x,y)
        if eventType == TOUCH_CLICK then
            -- GuildModel:shot_off_member( self.row_t[ self.select_row_index ].guild.ActorId )
            GuildModel:shot_off_member2( self.row_t[ self.select_row_index ].guild )
        end
        return true
    end
    self.shot_off_but = MUtils:create_btn(bgpanel,
        UILH_COMMON.button4,
        UILH_COMMON.button4,
        goto_page_but_fun,
        26, fenye_btn_h, -1, -1)
    local btn_txt = UILabel:create_lable_2(LH_COLOR[2]..Lang.guild.list[15], 96/2, 21, 16)
    local shot_size = self.shot_off_but:getSize()
    local txt_size  = btn_txt:getSize()
    btn_txt:setPosition(shot_size.width/2-txt_size.width/2,shot_size.height/2-txt_size.height/2+3)
    self.shot_off_but:addChild(btn_txt)
    -- self.shot_off_but = MUtils:create_common_btn( bgpanel, LangGameString[1198], goto_page_but_fun, 740, 12 ) -- [1198]="踢出"
    -- self.shot_off_but = UIButton:create_button_with_name( 550 + 88, 5, 60, 31, "ui/common/button2_bg.png", "ui/common/button2_bg.png", nil, "踢出", goto_page_but_fun )
    -- bgpanel:addChild( self.shot_off_but )

end

-- 清空一行的数据
function GuildMember:init_one_row( one_row )
    -- QQVipInterface:reinit_info( one_row.name, 0, "" )
    --QQVIPName:reinit_info( one_row.name, 0, "" )
    one_row.name:setString("")
    one_row.level:setString("")
    one_row.job:setString("")
    one_row.standing:setString("")
   -- one_row.sex:setString("")
    one_row.contribution:setString("")
    one_row.if_on_line:setString("")

    one_row.guild = nil
end

-- 删除所有行
function GuildMember:init_all_row(  )
    for key, one_row in pairs(self.row_t) do
        self:init_one_row( one_row )
    end
end

-- 使用一个仙宗结构设置一行的数据
function GuildMember:set_one_row_by_guild( one_row, guild )
    local check_online = GuildModel:check_member_if_online( guild.ActorId )
  ---  print("check_online= ",check_online)
    local color_value = LH_COLOR[2]
    if check_online then
        one_row.if_on_line:setString( LH_COLOR[2]..Lang.guild.list[16])	
    else
        one_row.if_on_line:setString( LH_COLOR[3]..Lang.guild.list[17] )
        color_value = LH_COLOR[3]
    end
    if not check_online then
        color_value = LH_COLOR[3]
    end
    -- QQVipInterface:reinit_info( one_row.name, guild.qqvip, color_value..guild.name )
    --QQVIPName:reinit_info( one_row.name, guild.qqvip, guild.name )
    --one_row.name:setString( guild.name )
    one_row.name:setString( color_value..guild.name )   --名称
    one_row.level:setString( color_value..guild.level ) --等级
    one_row.job:setString( color_value.._com_attr_job_name[ guild.job ] )  --职业
    one_row.standing:setString( color_value..GuildModel:get_guild_standing_name( guild.standing ) )  --职位
    --one_row.sex:setString( color_value..(Lang.sex_info_ex[guild.sex+1]  or "") )
    one_row.contribution:setString( color_value..guild.contribution.."/"..guild.all_contribution )  --贡献
    -- local fight_val = guild.fight_value
    -- print("=========== fightVal: ", fight_val)

    -- local offline_time_str = GuildMember:format_time( guild.offline_time )
    -- one_row.if_on_line:setString(color_value..offline_time_str); 
    
    -- 一些行操作需要存储的数据
    one_row.guild = guild            
end

-- 显示当前页所有行
function GuildMember:show_all_row( )
    local _memb_infos, start_index, end_index = GuildModel:get_mem_curr_page_date(  )    -- 获取当前页数据

    local row_count = 1                           -- 行数计数
    for i = start_index, end_index do
        self:set_one_row_by_guild( self.row_t[row_count], _memb_infos[i] )
        row_count = row_count + 1
    end

    -- 页号显示
    local page_curr  = GuildModel:get_memb_curr_page(  )
    local page_total = GuildModel:get_memb_total_page(  )
    self.curr_page_label:setString( LH_COLOR[2]..page_curr.."/"..page_total )

    
    self:check_sele_self(  )
    self:flash_nomi_shot_off_but(  )
end

-- 设置某行为选中状态
function GuildMember:set_row_selected_by_index( index )
	for key, row in  pairs( self.row_t ) do
        row.selected_frame:setIsVisible( false )
	end
	self.row_t[ index ].selected_frame:setIsVisible( true )
    self.select_row_index = index
    self:check_sele_self(  )
    self:flash_nomi_shot_off_but(  )
end

-- 根据是否选中列，设置 任命 提出 两个按钮 的状态
function GuildMember:flash_nomi_shot_off_but(  )
	if self.select_row_index then
		self.nominate_but:setCurState( CLICK_STATE_UP )
        self.shot_off_but:setCurState( CLICK_STATE_UP )
	else
        self.nominate_but:setCurState( CLICK_STATE_DISABLE )
        self.shot_off_but:setCurState( CLICK_STATE_DISABLE )
	end

    -- 只有宗主才显示任命按钮 . 
    if GuildModel:check_if_be_position( "wang" ) and ( not if_sele_be_self ) and self.row_t[self.select_row_index] then
        self.nominate_but:setIsVisible( true )
    else
        self.nominate_but:setIsVisible( false )
    end
    -- 只有自己是副宗主以上并且选中的不是宗主才显示提出按钮
    if ( GuildModel:check_if_be_position( "wang" ) or GuildModel:check_if_be_position( "deputy" ) )
        and  ( not if_sele_be_self ) 
        and self.row_t[self.select_row_index] and self.row_t[self.select_row_index].guild and self.row_t[self.select_row_index].guild.standing ~= 4 then
        self.shot_off_but:setIsVisible( true )
    else
        self.shot_off_but:setIsVisible( false )
    end
end

-- 判断是否选中自己，来设置两个按钮的状态
function GuildMember:check_sele_self(  )
    
    if self.select_row_index and self.row_t[ self.select_row_index ] then
        if_sele_be_self = GuildModel:Check_if_be_self( self.row_t[ self.select_row_index ].guild )
    end
    
    if if_sele_be_self then
        self.nominate_but:setCurState( CLICK_STATE_DISABLE )
        self.shot_off_but:setCurState( CLICK_STATE_DISABLE )
    end
end

-- 更新
function GuildMember:update( update_type )
    if update_type == "guild_member_info" then
        self:update_all(  )
    elseif update_type == "page" then
        self:update_page(  )
    elseif update_type == "all" then
        self:update_all(  )
        GuildModel:request_member_info(  )
    end
end

-- 更新页面所有动态信息
function GuildMember:update_all(  )
	self:init_all_row(  )
	self:show_all_row( )
end

-- 翻页更新
function GuildMember:update_page(  )
	self:init_all_row()
	self:show_all_row()
end


--创建一个空白框回收任命框
function  GuildMember:create_appoint_bg( ... )

    local function self_view_func( eventType )
        if eventType == TOUCH_BEGAN then
            local  win = UIManager:find_visible_window("guild_win")
            if win then
                if self.appointWin then  
                    self:hide_appoint_win()
                end
            end
            return true
        end
        return false
    end
    
    local conten = self.view:getSize()
    local basepanel = CCBasePanel:panelWithFile( 0, 60, conten.width,conten.height-10,nil);
    basepanel:setAnchorPoint(0,0)
    self.view:addChild(basepanel,999)
    basepanel:registerScriptHandler(self_view_func)

end


--创建任命框
function  GuildMember:create_appoint(param)
  local  win = UIManager:find_visible_window("guild_win")
   local  text_info = {
   text = {Lang.guild_info.position_name_t[5],Lang.guild_info.position_name_t[4],Lang.guild_info.position_name_t[3],Lang.guild_info.position_name_t[2],Lang.guild_info.position_name_t[1]},
   image = {UILH_COMMON.button8,UILH_COMMON.button8},
   width = -1, height = -1,
   gap  = 2
    }

  if win then 
      self.appointWin = CCBasePanel:panelWithFile( 760, 72, 80, 210, UILH_COMMON.bg_grid1
, 500, 500 )
      win.view:addChild(self.appointWin)
       width = self.appointWin:getSize().width
      height = self.appointWin:getSize().height
      local _mem_info = param

  --选中触发事件
       local function select_fun1( eventType,x,y )
           LeftClickMenuMgr:nomi_wang(_mem_info)
           self:hide_appoint_win()
      end

       local function select_fun2( eventType,x,y )
           LeftClickMenuMgr:nomi_deputy(_mem_info)
            self:hide_appoint_win()
      end

         local function select_fun3( eventType,x,y )
           LeftClickMenuMgr:nomi_hufa(_mem_info)
            self:hide_appoint_win()
      end

         local function select_fun4( eventType,x,y )
             LeftClickMenuMgr:nomi_elite(_mem_info)
              self:hide_appoint_win()
      end

         local function select_fun5( eventType,x,y )
             LeftClickMenuMgr:nomi_follower(_mem_info)
              self:hide_appoint_win()
      end


    --帮主  军团长
        self.wang_role = ZTextButton:create(nil, LH_COLOR[2]..text_info.text[1], text_info.image, nil, 0, 0, text_info.width, text_info.height, nil, 600, 600)
        local w_size = self.wang_role:getSize()
        self.wang_role:setPosition((width - w_size.width)/2,height - w_size.height-1)
        self.wang_role:setTouchClickFun(select_fun1)
        self.appointWin:addChild(self.wang_role.view)

      local t_pos = self.wang_role:getPosition()

      --副帮主  副军团长
      self.assistant_role = ZTextButton:create(nil, LH_COLOR[2]..text_info.text[2], text_info.image, nil, 0, 0, text_info.width, text_info.height, nil, 600, 600)
      local a_size = self.assistant_role:getSize()
      self.assistant_role:setPosition((width - a_size.width)/2,t_pos.y - a_size.height -text_info.gap)
      self.assistant_role:setTouchClickFun(select_fun2)
      self.appointWin:addChild(self.assistant_role.view)
      t_pos = self.assistant_role:getPosition()

      --长老  尉官
      self.zhanglao_role = ZTextButton:create(nil, LH_COLOR[2]..text_info.text[3], text_info.image, nil, 0, 0, text_info.width, text_info.height, nil, 600, 600)
      local z_size = self.zhanglao_role:getSize()
      self.zhanglao_role:setPosition((width - z_size.width)/2,t_pos.y - z_size.height -text_info.gap)
      self.zhanglao_role:setTouchClickFun(select_fun3)
      self.appointWin:addChild(self.zhanglao_role.view)
     t_pos = self.zhanglao_role:getPosition()

     --  --堂主  校官
      self.tangzhu_role = ZTextButton:create(nil, LH_COLOR[2]..text_info.text[4], text_info.image, nil, 0, 0, text_info.width, text_info.height, nil, 600, 600)
      local t_size = self.tangzhu_role:getSize()
      self.tangzhu_role:setPosition((width - t_size.width)/2,t_pos.y - t_size.height -text_info.gap)
      self.tangzhu_role:setTouchClickFun(select_fun4)
      self.appointWin:addChild(self.tangzhu_role.view)
     t_pos = self.tangzhu_role:getPosition()
     --  --帮众  军士
      self.bangzong_role = ZTextButton:create(nil, LH_COLOR[2]..text_info.text[5], text_info.image, nil, (width - text_info.width)/2, t_pos.y - text_info.height, text_info.width, text_info.height, nil, 600, 600)
      local b_size = self.bangzong_role:getSize()
      self.bangzong_role:setPosition((width - b_size.width)/2,t_pos.y - b_size.height -text_info.gap)
      self.bangzong_role:setTouchClickFun(select_fun5)
      self.appointWin:addChild(self.bangzong_role.view)

    
   end

end

--任命弹出窗体
function  GuildMember:show_appoint_win( param )
    local  win = UIManager:find_visible_window("guild_win")
    if win then 
      if self.appointWin then 
          self.appointWin:setIsVisible(true)
      else
         self:create_appoint(param)
      end
    end
end


function GuildMember:hide_appoint_win( )
    local  win = UIManager:find_visible_window("guild_win")
    if win then 
        if self.appointWin then
            self.appointWin:setIsVisible(false)
        end
    end
end



