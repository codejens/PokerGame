-- MailStruct.lua
-- created by lyl on 2013-3-11
-- 邮件结构

super_class.MailStruct()

-- 附件的信息结构
local function get_attachment_info( pack )
	local attachment_info           = {}
	attachment_info.attachment_type = pack:readInt()	 -- 附件类型（0 NULL 1 是物品 2 是金钱）
	attachment_info.item_id         = pack:readInt()	 -- 物品ID或金钱类型
	attachment_info.item_count      = pack:readInt()	 -- 物品或金钱数量
	attachment_info.if_bind         = pack:readInt()	 -- 是否绑定
	return attachment_info
end

function MailStruct:__init( pack )
	if pack ~= nil then
		self.mail_id	      = pack:readInt64()		 -- 邮件guid
		self.type	          = pack:readByte()		     -- 邮件类型
		self.state   	      = pack:readByte()		     -- 邮件状态（0是未读，1是已读）
		self.addressor_id     = pack:readInt()	         -- 发信人的ID
		self.addressor_name   = pack:readString()	     -- 发信人的名字
		self.send_time	      = pack:readUInt()		     -- 发信的时间 
		self.mail_content	  = pack:readString()		 -- 邮件内容 
		self.attachment_count = pack:readByte()		     -- 附件的个数
		
		self.attachment_info  = {}                       -- 附件信息 
		for i = 1, self.attachment_count do
            self.attachment_info[i] = get_attachment_info( pack )
		end
		
	end
end