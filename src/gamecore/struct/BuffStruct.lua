-- BuffStruct.lua
-- create by fjh on 2013-3-13
-- Buff的数据结构

BuffStruct = simple_class()

function BuffStruct:__init( pack )
	--buff类型
	self.buff_type 	= pack:readByte();
	--buff的group id
	self.buff_group = pack:readByte();
	--buff的剩余时间
	self.alive_time = pack:readInt();
	--buff数值的类型
	self.buff_value_type = pack:readByte();
	
	--buff数值
	if self.buff_value_type == 1 then
		self.buff_value = pack:readChar();
	elseif self.buff_value_type == 2 then
		self.buff_value = pack:readByte();
	elseif self.buff_value_type == 3 then
		self.buff_value = pack:readShort();
	elseif self.buff_value_type == 4 then
		self.buff_value = pack:readWord();
	elseif self.buff_value_type == 5 then
		self.buff_value = pack:readInt();
	elseif self.buff_value_type == 6 then
		self.buff_value = pack:readUInt();
	elseif self.buff_value_type == 7 then
		self.buff_value = pack:readFloat();
	end
	--buff名字
	self.buff_name = pack:readString();
	
end