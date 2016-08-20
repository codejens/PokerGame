-- MailModel.lua
-- created by lyl on 2013-3-11
-- 邮件系统

-- super_class.MailModel()
MailModel = {}

local _mail_list = {}           -- 邮件列表

local _mail_type = 1            -- 读取界面，邮件类型  1:全部邮件  2：未读邮件  3：已读邮件
local _current_mail_info = nil  -- 记录当前选中的邮件， 在内容界面使用
local _delete_mail_id_t  = nil  -- 记录当前删除的邮件id(服务器提示成功时，没有返回id，所以要这里记录)
local _delete_after_get  = false-- 是否提取后删除
local _if_key_to_delete  = false-- 是否一键提取
--------------------
---HJH 2013-12-19
local _fini = false
-- added by aXIng on 2013-5-25
function MailModel:fini( ... )
	_mail_list = {} 
	_mail_type = 1
	_current_mail_info = nil
	_delete_mail_id_t  = nil
	_delete_after_get  = false
	_if_key_to_delete  = false
	_fini = true
end

function MailModel:get_is_fini()
	return _fini
end

function MailModel:reset_info()
	_fini = false
	MailModel:request_mail_list(  ) 
end
-- ================================
-- 更新
-- ================================
-- 邮件窗口
function MailModel:update_mail_win( update_type )
	require "UI/mail/MailWin"
	MailWin:update_win( update_type )
end

-- 邮件内容窗口
function MailModel:update_mail_content_win( update_type )
	require "UI/mail/MailContentWin"
	MailContentWin:update_win( update_type )
end


--================================================================
--  数据操作
--================================================================
-- 设置邮件列表
function MailModel:set_mail_list( mail_list )
	_mail_list = mail_list
	MailModel:update_mail_win( "mail_list" )
end

-- 获取邮件列表
function MailModel:get_mail_list(  )
	-- print("MailModel:get_mail_list #_mail_list", #_mail_list)
	local ret_list = {}
    -- 根据邮件累类型过滤
    if _mail_type == 1 then
        ret_list = _mail_list
    elseif _mail_type == 2 then
        for i = 1, #_mail_list do
            if not MailModel:check_mail_if_read( _mail_list[i] ) then
                table.insert( ret_list, _mail_list[i] )
            end
        end
    elseif _mail_type == 3 then
        for i = 1, #_mail_list do
            if MailModel:check_mail_if_read( _mail_list[i] ) then
                table.insert( ret_list, _mail_list[i] )
            end
        end

    end

    MailModel:reverse_mail_list( ret_list )-- 服务器邮件是按时间升序排的，做个反序
	return ret_list
end

-- 服务器邮件是按时间排序
function MailModel:reverse_mail_list( mail_list )
	local function comp_func( mail1, mail2 )
		if mail1.send_time > mail2.send_time then 
            return true
        else
        	return false
	    end
	end
	table.sort (mail_list , comp_func)
end

-- 设置读取界面，邮件类型
function MailModel:set_mail_type( mail_type )
	_mail_type = mail_type
	MailModel:update_mail_win( "mail_type" )
end

-- 获取邮件类型
function MailModel:get_mail_type(  )
	return _mail_type
end

-- 获取当前选中的邮件对象
function MailModel:get_current_mail(  )
	return _current_mail_info
end

-- 设置邮件是否读取的状态
function MailModel:set_mail_state( mail_id, state )
	for key, mail in pairs(_mail_list) do
        if mail.mail_id == mail_id then
            mail.state = state
        end
	end
	MailModel:update_mail_win( "mail_state" )
end
-- 获取未读取邮件的长度
function MailModel:get_unread_mail_count( )
	local count = 0
	for key, mail in pairs(_mail_list) do
		if mail.state == 0 then 
			count = count + 1
		end
	end
	return count
end
-- 根据邮件id获取邮件
function MailModel:get_mail_by_id( mail_id )
	for key, mail in pairs(_mail_list) do
        if mail.mail_id == mail_id then
            return mail
        end
	end
	return nil
end

-- 根据id，获取邮件的状态
function MailModel:get_mail_state_by_id( mail_id )
	local mail = MailModel:get_mail_by_id( mail_id )
	if mail then
        return mail.state
	end
	return 0
end

-- 根据邮件id删除单个邮件
function MailModel:remove_mail_by_id( mail_id )
	for i = 1, #_mail_list do
        if _mail_list[i].mail_id == mail_id then
            table.remove( _mail_list, i )
            return                        -- 本方法只删除一个邮件，删完就返回
        end
	end
end

--  设置提取附件后是否删除
function MailModel:set_delete_after_get( if_delete )
	_delete_after_get = if_delete
end

-- 删除当前选中邮件的附件
function MailModel:delete_current_mail_attachment(  )
	_current_mail_info.attachment_count = 0
	_current_mail_info.attachment_info  = {}
	MailModel:update_mail_win( "mail_list" )
end

-- 删除所有邮件的附件
function MailModel:delete_all_mail_attachment(  )
	for key, mail in pairs(_mail_list) do
        mail.attachment_count = 0
	    mail.attachment_info  = {}
	end
	if _current_mail_info then 
		_current_mail_info.attachment_count = 0
		_current_mail_info.attachment_info  = {}
	end
end

-- ================================
-- 逻辑相关
-- ================================
-- 显示邮件类型选择菜单
function MailModel:show_mail_type_menu(  )
	require "model/LeftClickMenuMgr"
	LeftClickMenuMgr:show_left_menu( "mail_type_menu", {}, 98, 333, false )
end

-- 读取邮件页，判断显示邮件icon的类型 返回： 1:未打开 无附件    2：未打开 有附件   3：已打开 无附件  4：已打开 有附件 
function MailModel:check_mail_icon_type( mail_struct )
	local count = #mail_struct.attachment_info
	if mail_struct.state == 0 then   -- 未读
        if count < 1 then            -- 无附件
            return 1
        else
        	return 2
        end
    else                             -- 已读
    	if count < 1 then            -- 无附件
            return 3
        else
        	return 4
        end
	end
end

-- 获取发送时间
function MailModel:change_to_send_time( mail_struct )
	local send_time = Utils:get_custom_format_time( "%Y/%m/%d %H:%M", mail_struct.send_time )
	return send_time
end

-- 获取失效时间  无道具7天失效  有道具15天失效
function MailModel:change_to_overdue_time( mail_struct )
	local count = #mail_struct.attachment_info
	local active_time = 15      -- 有效时间
	if count < 1 then           -- 无附件
        active_time = 7
	end
    local overdue_time = Utils:get_custom_format_time( "%Y/%m/%d %H:%M", mail_struct.send_time + active_time * 24 * 60 * 60 )
    return overdue_time
end

-- 打开邮件内容窗口
function MailModel:open_mail_content( mail_struct )
	_current_mail_info = mail_struct
	MailModel:request_read_mail( mail_struct.mail_id )
	local win = UIManager:show_window( "mail_content_win", false )   -- 打开内容窗口
	if win then
        win:update( "mail_content" )
	end
	MailModel:update_mail_win( "mail_content" )

	-- 设置状态为打开状态
    -- MailModel:set_mail_state( mail_struct.mail_id, 1 )
end

-- 判断是否包含附件  包含：返回true
function MailModel:check_if_exist_attachment( mail_struct )
	local count = #mail_struct.attachment_info
	if count < 1 then
        return false
    else
    	return true
	end
end

-- 判断是否已读   已读：返回true
function MailModel:check_mail_if_read( mail_struct )
	if mail_struct.state == 1 then
        return true
    else
    	return false
	end
end

-- 回复  切换到发件页  并且收件人名称为当前选中邮件的发件人
function MailModel:replay_mail(  )
	local win = UIManager:show_window( "mail_win", false )   -- 打开内容窗口
	if win then
        win:change_page( 2 )
	end
	MailModel:update_mail_win( "reply" )
end

-- 显示tips     如果是货币类型，要传 整个结构
function MailModel:show_item_tips( item_id, x, y, money_date )
	if item_id == nil then 
        return
	end
	print(" 邮件的item_id", item_id);
    if item_id < 4 and item_id >= 0 then    -- 钱
    	print("邮件， 金钱",x, y);
    	print("money_date", money_date)
        TipsModel:show_money_tip( x, y, money_date )
    else
    	print("邮件， 非金钱");
        TipsModel:show_shop_tip( x, y, item_id )
    end
end

-- ================================
-- 与服务器通讯
-- ================================
-- 申请玩家邮件列表
function MailModel:request_mail_list(  )
	require "control/MailCC"
	MailCC:request_mail_list(  )
end

-- 一键提取
function MailModel:key_to_get_all_attachment(  )
	_if_key_to_delete = true
	require "control/MailCC"
    MailCC:request_get_attachment( 0, 1 )
end

-- 申请提取当前选中的邮件的附件
function MailModel:request_get_current_mail_attachment(  )
	_if_key_to_delete = false
	if _current_mail_info and _current_mail_info.mail_id then
		require "control/MailCC"
		MailCC:request_get_attachment( 1, _current_mail_info.mail_id )
	end
end

-- 提取成功  删除当前选中邮件的附件，并更新内容窗口
function MailModel:get_attachment_success(  )
	if _if_key_to_delete then
        MailModel:delete_all_mail_attachment()
        MailModel:update_mail_win( "mail_list" ) 
        MailModel:update_mail_content_win( "mail_content" )
        if _delete_after_get then

            MailModel:delete_no_attachment_mail(  )
        end       
	else
		MailModel:delete_current_mail_attachment()
	    MailModel:update_mail_content_win( "mail_content" )
		if _delete_after_get then
		    MailModel:request_delete_current_mail( )
	    end
	end
end

-- 通知服务器读取了一个邮件
function MailModel:request_read_mail( mail_id )
	require "control/MailCC"
	MailCC:request_read_mail( 1, {mail_id} )
end

-- 服务器通知读取成功
function MailModel:read_mail_success(  )
	if _current_mail_info then
        MailModel:set_mail_state(  _current_mail_info.mail_id, 1 )	
	end
end

-- 删除当前选中邮件 mail_type 类型  count 要删除的个数      mail_id_list 邮件的id 列表
function MailModel:request_delete_current_mail( )
	local function confirm_fun(  )
        require "control/MailCC"
		_delete_mail_id_t = {_current_mail_info.mail_id}
		MailCC:request_delete_mail( 1, 1, _delete_mail_id_t )
    end
	if _current_mail_info and _current_mail_info.mail_id then
		if MailModel:check_if_exist_attachment( _current_mail_info ) then
			require "UI/common/ConfirmWin"
            local notice_words = LangModelString[373] -- [373]="邮件中还有附件未提取，确定删除吗？"
            ConfirmWin( "select_confirm", nil, notice_words, confirm_fun, nil, 260, nil)
        else
        	confirm_fun(  )
		end
	end
end

-- 删除已经读取的邮件
function MailModel:delete_had_read_mail(  )
	_delete_mail_id_t = {}
	local function confirm_fun(  )
        require "control/MailCC"
		MailCC:request_delete_mail( 1, #_delete_mail_id_t, _delete_mail_id_t )
    end
    local if_contain_attachment = false       -- 判断所选邮件中是否包含附件
    for key, mail in pairs( _mail_list ) do
        if mail.state == 1 then
        	if MailModel:check_if_exist_attachment( mail ) then
                if_contain_attachment = true
        	end
            table.insert( _delete_mail_id_t, mail.mail_id )     -- 已打开的邮件，放入删除表中
        end
    end

    if if_contain_attachment then
        require "UI/common/ConfirmWin"
        local notice_words = LangModelString[373] -- [373]="邮件中还有附件未提取，确定删除吗？"
        ConfirmWin( "select_confirm", nil, notice_words, confirm_fun, nil, 260, nil)
    else
    	confirm_fun(  )
    end

end

-- 删除没有附件的邮件
function MailModel:delete_no_attachment_mail(  )
	-- 记录没有附件的邮件， 虽然服务器有直接的一个协议不需要这个表，但删除成功后，要马上更新显示。
	_delete_mail_id_t = {}
    for key, mail in pairs(_mail_list) do
    	if not MailModel:check_if_exist_attachment( mail ) then
            table.insert( _delete_mail_id_t, mail.mail_id )
    	end
    end
	require "control/MailCC"
	MailCC:request_delete_mail( 0, 0, {} )
end

-- 删除成功的处理
function MailModel:do_delete_success(  )
	for key, mail_id in pairs(_delete_mail_id_t) do
        MailModel:remove_mail_by_id( mail_id )
	end
	MailModel:update_mail_win( "mail_list" )
	UIManager:hide_window( "mail_content_win" )
end

-- 发送邮件
function MailModel:send_mail( addressee, content, attachment_count, attachment_info )
	require "control/MailCC"
	MailCC:request_send_mail( addressee, content, attachment_count, attachment_info )
end

-- 发送邮件成功
function MailModel:send_mail_success(  )
	require "GlobalFunc"
	GlobalFunc:create_screen_notic( LangModelString[374] ) -- [374]="发送邮件成功"
	MailModel:update_mail_win( "clear_all" )
end

-- 服务端通知有新邮件
function MailModel:receive_new_mail(  )
	MailModel:request_mail_list(  )

    -- 主界面弹出提示字
    local function mini_but_func(  )
    	UIManager:show_window( "mail_win" )
    end 
	MiniBtnWin:show( 14 , mini_but_func ,nil )
end
