-- HLDMsgStruct.lua
-- created by hcl on 2013-9-16
-- 欢乐斗消息结构

super_class.HLDMsgStruct()

function HLDMsgStruct:__init( pack )

	self.send_time = pack:readInt();
	self.msg_type = pack:readInt();
	self.msg_id = pack:readInt();
	self.targetNum  = pack:readInt();
	self.target_info_table = {};
	for i=1,self.targetNum do
		self.target_info_table[i] = HLDUserStruct(pack);
	end

end