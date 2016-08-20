-- ReadMailPage.lua  
-- created by lyl on 2013-3-12
-- 读取邮件

super_class.ReadMailPage(Window)

-- 各状态下的图片和大小信息
local _mail_state_image_t = { 
{UILH_MAIL.mail_unread, 70, 70}, 
{UILH_MAIL.mail_box, 70, 70},
{UILH_MAIL.mail_read, 70, 70}, 
{UILH_MAIL.mail_read, 70, 70} 
}


function ReadMailPage:create(  )
	return ReadMailPage( "ReadMailPage", "", true, 420, 520 )
end


function ReadMailPage:__init( window_name, texture_name )
	self.row_t   = {}                        -- 存储每一行的对象， 用来修改每行数据
	self.current_select_row_id  = nil     -- 当前选中行id

	local panel = self.view

    -- 背景
    local bg = CCZXImage:imageWithFile( 0, 3, 420, 520-1, UILH_COMMON.normal_bg_v2, 500, 500 )
    panel:addChild(bg)

    -- 类型选择文字
    panel:addChild( UILabel:create_lable_2( Lang.mail[5], 20, 477, 18, ALIGN_LEFT ) ) -- [1434]="#cffff00类型:"

    -- 类型按钮
    local function but_1_fun(eventType,x,y)
        if eventType == TOUCH_CLICK then 
            MailModel:show_mail_type_menu(  )
            return true
        end
        return true
    end

    -- 类型选择区域背景图
    self.type_panel = CCBasePanel:panelWithFile( 75 , 463, 131, 45, UILH_COMMON.bg_02, 500, 500 )
    self.type_panel:registerScriptHandler( but_1_fun )                  -- 注册
    panel:addChild( self.type_panel )

    -- 类型选择下拉按钮
    local push_but = CCZXImage:imageWithFile( 88, 2, -1, -1, UILH_MAIL.list_button )  -- 下拉按钮
    push_but:setDefaultMessageReturn(false)  -- 设置可穿透
    self.type_panel:addChild( push_but )
    --  类型名称
    self.type_name = UILabel:create_lable_2( Lang.mail[6], 44, 17, 15, ALIGN_CENTER ) -- [1435]="全部邮件"
    self.type_panel:addChild( self.type_name )

    -- 提取后删除 单选
    local function callback_fun( if_selected )
        MailModel:set_delete_after_get( if_selected )
    end
    self.after_get_delete = UIButton:create_switch_button2( 241, 465, 140, 37, UILH_COMMON.dg_sel_1, UILH_COMMON.dg_sel_2, Lang.mail[7], 45, 13, 16, nil, nil, nil, nil, callback_fun ) -- [1436]="#c66ff66提取后删除"
    panel:addChild( self.after_get_delete.view )

    -- 邮件列表背景
    local mail_bg = CCZXImage:imageWithFile( 10, 77, 399, 382, UILH_COMMON.bottom_bg, 500, 500 )
    panel:addChild(mail_bg)
    -- 邮件列表
    self:create_mail_scroll();
    local arrow_up = CCZXImage:imageWithFile(397 , 446, 10, -1 , UILH_COMMON.scrollbar_up, 500, 500)
    local arrow_down = CCZXImage:imageWithFile(397, 80, 10, -1, UILH_COMMON.scrollbar_down, 500 , 500)
    panel:addChild(arrow_up,1)
    panel:addChild(arrow_down,1)

    -- 删除已读按钮
    local function delete_but_CB()
        MailModel:delete_had_read_mail()
    end
    local delete_btn = ZButton:create(panel,{UILH_COMMON.btn4_nor,UILH_COMMON.btn4_sel},delete_but_CB,53, 18,-1,-1)
    MUtils:create_zxfont(delete_btn,Lang.mail[3],121/2,20,2,16);     -- 删除已读

    -- 一键提取按钮
    local function key_get_but_CB()
        MailModel:key_to_get_all_attachment()
    end
    local key_get_btn = ZButton:create(panel,{UILH_COMMON.btn4_nor,UILH_COMMON.btn4_sel},key_get_but_CB,243, 18,-1,-1)
    MUtils:create_zxfont(key_get_btn,Lang.mail[4],121/2,20,2,16);     -- 一键提取

    MailModel:request_mail_list(  )        -- 申请邮件列表
end

-- 创建邮件列表入口
function ReadMailPage:create_mail_scroll()
    self.mail_list_date = MailModel:get_mail_list(  )
    self.mail_list_scroll = self:create_scroll_area( self.mail_list_date , 12, 90, 395, 366, 1, 4, "")
    self.view:addChild( self.mail_list_scroll )
end

-- 创建可拖动区域   参数：放入scroll的panel的集合, 坐标， 区域大小，列数，可见行数， 背景名称
function ReadMailPage:create_scroll_area( panel_table_para , pos_x, pos_y, size_w, size_h, colu_num, sight_num, bg_name)
    local row_num = math.ceil( #panel_table_para / colu_num )
    -- 不知道为什么要有这个判断代码，这会导致滑动条的高度异常
    -- if row_num < 4 then
        -- row_num = 4
    -- end
    -- local scroll = CCScroll:scrollWithFile(pos_x, pos_y, size_w, size_h, sight_num, colu_num, row_num , bg_name, TYPE_VERTICAL, 500,500)
    -- scroll:setEnableCut(true)
    local _scroll_info = { x = pos_x, y = pos_y, width = size_w, height = size_h, maxnum = row_num, image = bg_name, stype= TYPE_HORIZONTAL }
    local scroll = CCScroll:scrollWithFile( _scroll_info.x, _scroll_info.y, _scroll_info.width, _scroll_info.height, _scroll_info.maxnum, _scroll_info.image, _scroll_info.stype )
    scroll:setScrollLump(UILH_COMMON.up_progress, UILH_COMMON.down_progress, 10, 30, 95 )
    scroll:setScrollLumpPos(size_w-10)

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

            local temparg = Utils:Split(args,":")
            local x = temparg[1]              -- 行
            local y = temparg[2]              -- 列
            local index = y * colu_num + x + 1

            if panel_table_para[index] then
                local bg = CCBasePanel:panelWithFile( 0, 0, 384, 105, "", 500, 500 )
                local row = self:create_one_row( 0, 1, 384, 105, panel_table_para[index], index )
                bg:addChild( row.view )
                scroll:addItem( bg )
            else
                local bg = CCBasePanel:panelWithFile( 0, 0, 384, 0, "", 500, 500 )
                -- local row = self:create_one_row( 0, 5, 307, 85, panel_table_para[index], index )
                -- bg:addChild( row.view )
                scroll:addItem( bg )
            end

            scroll:refresh()
            return false
        end
    end
    scroll:registerScriptHandler(scrollfun)
    scroll:refresh()

    return scroll
end

-- 创建一个邮件面板
local row_index_count = 1         -- 存储入self.row_t 的序号，用来防止多次创建，key重复，造成scroll销毁，通知从self.row_t删除。而新建的也被删了。
function ReadMailPage:create_one_row( pos_x, pos_y, width, height, row_date, index )
	local one_row = {}                -- 邮件面板对象

	one_row.view = CCBasePanel:panelWithFile( pos_x, pos_y, width, height, nil, 500, 500 )

	if row_date == nil then
        return one_row
	end

    -- 保存一些绑定数据， 因为可能创建一个空行，只有view，所以在这里才赋值
    one_row.mail_id = row_date.mail_id
    one_row.date = row_date
    row_index_count = row_index_count + 1
    one_row.row_t_index = row_index_count

    one_row.selected_frame = CCZXImage:imageWithFile( 0, -1, width, height+1, UILH_COMMON.select_focus, 500, 500 )   -- 选中状态的框
    one_row.view:addChild( one_row.selected_frame,10)
    if self.current_select_row_id ~= one_row.mail_id then
        one_row.selected_frame:setIsVisible( false )
    end
	local function f1(eventType, arg, imsgid, selfitem)
        if eventType == nil or arg == nil or imsgid == nil or selfitem == nil then
            return
        end
        if eventType == TOUCH_ENDED then
            self:set_row_selected_by_index( one_row.row_t_index )
        elseif eventType == TOUCH_CLICK then
            return true
        elseif eventType == TOUCH_DOUBLE_CLICK then
            return true
        elseif eventType == ITEM_DELETE then           
            self.row_t[ one_row.row_t_index ] = nil       -- 拖动使行隐藏后，c++销毁panel，这时有 事件通知，就删除该行
        end
        return true
    end
    one_row.view:registerScriptHandler(f1)
    one_row.view:setEnableDoubleClick(true)
    -- 邮件状态
	local mail_state = MailModel:check_mail_icon_type( row_date )
	one_row.mail_state_image = CCZXImage:imageWithFile( 8, 15, _mail_state_image_t[mail_state][2], _mail_state_image_t[mail_state][3], _mail_state_image_t[mail_state][1])
	one_row.view:addChild( one_row.mail_state_image )

    -- 如果是系统邮件，显示特殊颜色
    local name_color = LH_COLOR[15]
    local time_title_color = LH_COLOR[6]
    local time_content_color = LH_COLOR[15]
    local valid_date_title_color = LH_COLOR[13]
    local valid_date_content_color = LH_COLOR[15]
    if row_date.addressor_id == 0 then
        name_color = LH_COLOR[1]
        time_title_color = LH_COLOR[1]
        time_content_color = LH_COLOR[1]
        valid_date_title_color = LH_COLOR[1]
        valid_date_content_color = LH_COLOR[1]
    end

    -- 发件人名称
	one_row.laddressor_name_lable = UILabel:create_lable_2( name_color..row_date.addressor_name, 52, 30, 16, ALIGN_LEFT )
	one_row.view:addChild( one_row.laddressor_name_lable ,5)

    -- 发送时间
    local send_time = MailModel:change_to_send_time( row_date )
        print("ReadMailPage:create_one_row send_time", send_time)
    one_row.send_time_lable = UILabel:create_lable_2( time_title_color..Lang.mail[14]..time_content_color..send_time, 170, 58, 14, ALIGN_LEFT ) -- Lang.mail[14] =发送
    one_row.view:addChild( one_row.send_time_lable )

    -- 过期时间
    local overdue_time = MailModel:change_to_overdue_time( row_date )
    one_row.overdue_time_lable = UILabel:create_lable_2( valid_date_title_color..Lang.mail[15]..valid_date_content_color..overdue_time, 170, 30, 14, ALIGN_LEFT ) -- [1440]="#c66ff66有效:"
    one_row.view:addChild( one_row.overdue_time_lable )

    -- 提供方法
    -- 更新邮件状态
    one_row.update_state = function(  )
        local new_state = MailModel:get_mail_state_by_id( one_row.date.mail_id )     -- 获取最新的状态
        one_row.date.state = new_state                                               -- 该行的邮件信息，设置最新状态
        one_row.view:removeChild( one_row.mail_state_image, true )                         -- 先删除icon， 再添加
        local icon_index = MailModel:check_mail_icon_type( one_row.date )            -- 获取图标序列号
        one_row.mail_state_image = CCZXImage:imageWithFile( 8, 15, _mail_state_image_t[icon_index][2], _mail_state_image_t[icon_index][3], _mail_state_image_t[icon_index][1])
        one_row.view:addChild( one_row.mail_state_image )
    end

    -- 分割线
    local line = CCZXImage:imageWithFile( 0, -2, width, 3, UILH_COMMON.split_line )
    one_row.view:addChild(line)

    
    self.row_t[ one_row.row_t_index ] = one_row
	return one_row
end

-- 设置某行为选中状态
function ReadMailPage:set_row_selected_by_index( row_t_index )
	for key, row in  pairs( self.row_t ) do
		if row and row.selected_frame then
            row.selected_frame:setIsVisible( false )
        end
	end
	self.row_t[ row_t_index ].selected_frame:setIsVisible( true )
    self.current_select_row_id = self.row_t[ row_t_index ].mail_id
    MailModel:open_mail_content( self.row_t[ row_t_index ].date )         -- 打开某个邮件信息窗口
end

-- 更新邮件类型
function ReadMailPage:update_mail_type(  )
	local mail_type = MailModel:get_mail_type(  )
	local mail_type_name_t = { Lang.mail[6], Lang.mail[8], Lang.mail[9] } -- [1435]="全部邮件" -- [1441]="未读邮件" -- [1442]="已读邮件"
	local mail_type_name = mail_type_name_t[ mail_type ] or ""
	self.type_name:setString(mail_type_name)

    self:update_mail_list(  )
end

-- 更新邮件列表
function ReadMailPage:update_mail_list(  )
    self.row_t = {}
	self.view:removeChild( self.mail_list_scroll, true )
    self:create_mail_scroll(panel);
end

-- 更新邮件的状态
function ReadMailPage:update_mail_state(  )
    for key, one_row in pairs( self.row_t ) do
        one_row.update_state()
    end
    self.mail_list_date = MailModel:get_mail_list(  )   -- 更新列表数据
end

-- 更新数据 
function ReadMailPage:update( update_type )
    print("run ReadMailPage:update", update_type)
    if update_type == "mail_type" then
        self:update_mail_type(  )
    elseif update_type == "mail_list" then
        self:update_mail_list(  )
    elseif update_type == "mail_state" then
        self:update_mail_state(  )
    elseif update_type == "all" then
        self:update_mail_type(  )
        -- self:update_mail_list(  )       -- 更新类型已经更新过列表了，不用再更新
        self:update_mail_state(  )
        self:update_mail_list(  )
    end
end
