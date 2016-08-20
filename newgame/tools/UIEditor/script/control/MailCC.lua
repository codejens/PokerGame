-- MailCC.lua
-- created by lyl on 2013-3-11
-- 邮件系统

-- super_class.MailCC()

MailCC = {}

-- c->s 41,1  申请玩家邮件列表
function MailCC:request_mail_list(  )
	-- print("c->s 41,1  申请玩家邮件列表")
	local pack = NetManager:get_socket():alloc(41, 1)
	NetManager:get_socket():SendToSrv(pack)
end

-- s->c 41,1 返回玩家邮件列表
function MailCC:do_result_mail_list( pack )
	-- print("s->c 41,1 返回玩家邮件列表")
	local count = pack:readInt()
	local mail_list = {}         
	require "struct/MailStruct"
	for i = 1, count do
        mail_list[i] = MailStruct( pack )
	end

    require "model/MailModel"
	MailModel:set_mail_list( mail_list )
end

-- s->c 41,2 服务端通知客户端有新邮件
function MailCC:do_notice_new_mail( pack )
	-- print("s->c 41,2 服务端通知客户端有新邮件")
	MailModel:receive_new_mail(  )
end

-- c->s 41,3  申请提取附件  attachment_type 0表示一键提取，1表示单个。  如果为0，不需要mail_id
function MailCC:request_get_attachment( attachment_type, mail_id )
	local pack = NetManager:get_socket():alloc(41, 3)
	pack:writeByte( attachment_type )
	pack:writeInt64( mail_id )
	NetManager:get_socket():SendToSrv(pack)
end

-- s->c 41,3 通知客户端提取操作成功
function MailCC:do_notice_get_success( pack )
	-- print("s->c 41,3 通知客户端提取操作成功")
	MailModel:get_attachment_success(  )
end

-- c->s 41,4  删除邮件  mail_type 类型  count 要删除的个数      mail_id_list 邮件的id 列表
function MailCC:request_delete_mail( mail_type, count, mail_id_list )
	-- print("c->s 41,4  删除邮件  ", mail_type, count, mail_id_list)
	local pack = NetManager:get_socket():alloc(41, 4)
	pack:writeByte( mail_type )
	pack:writeByte( count )
	for i = 1, #mail_id_list do
        pack:writeInt64( mail_id_list[i] )
	end
	NetManager:get_socket():SendToSrv(pack)
end

-- s->c 41,4 通知客户端删除操作成功
function MailCC:do_result_delete_mail( pack )
	-- print("s->c 41,4 通知客户端删除操作成功")
	MailModel:do_delete_success(  )
end

-- c->s 41,5  发邮件    收件人名称    内容   附件个数     附件
function MailCC:request_send_mail( addressee, content, attachment_count, attachment_info )
	local pack = NetManager:get_socket():alloc(41, 5)
	pack:writeString( addressee )
	pack:writeString( content )
	pack:writeByte( attachment_count )
	for i = 1, #attachment_info do
        pack:writeInt( attachment_info[i][1] )       -- 附件类型（0是物品，1是金钱）
        pack:writeInt( attachment_info[i][2] )       -- 物品ID或金钱类型
        pack:writeInt( attachment_info[i][3] )       -- 物品或金钱数量
        pack:writeInt( attachment_info[i][4] )       -- 是否绑定
	end 
	NetManager:get_socket():SendToSrv(pack)
end

-- s->c 41,5 通知发送操作成功
function MailCC:do_result_send_mail( pack )
    -- print("s->c 41,5 通知发送操作成功")
	MailModel:send_mail_success(  )
end

-- s->c 41,6 通知客户端预读操作成功
function MailCC:do_result_read_mail( pack )
	-- print("s->c 41,6 通知客户端预读操作成功")
	local result = pack:readByte()
	-- todo
	-- MailCC:request_mail_list(  )
	MailModel:read_mail_success(  )
end

-- c->s 41,6  阅读邮件
function MailCC:request_read_mail( read_count, mail_id_list )
	-- print("c->s 41,6  阅读邮件   ", read_count, mail_id_list)
	local pack = NetManager:get_socket():alloc(41, 6)
	pack:writeInt( read_count )
	for i = 1, #mail_id_list do
        pack:writeInt64( mail_id_list[i] )
	end
	NetManager:get_socket():SendToSrv(pack)
end

-- s->c 41,7 通知客户端邮件快满了
function MailCC:notice_mail_will_full( pack )
	-- print("s->c 41,7 通知客户端邮件快满了")
	-- todo
end

-- s->c 41,8 通知客户端还有附件没有领取
function MailCC:notice_mail_had_not_get( pack )
	-- print("s->c 41,8 通知客户端还有附件没有领取")
	-- todo
end