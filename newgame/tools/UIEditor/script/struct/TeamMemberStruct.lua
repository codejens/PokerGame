-- TeamMemberStruct.lua
-- create by hcl on 2013-2-25
-- 队伍成员的struct

super_class.TeamMemberStruct()


function TeamMemberStruct:__init( pack )
	if pack ~=nil then
		self.handle = pack:readUint64();		-- 如果是一个离线玩家handle = 0
		self.actor_id = pack:readInt();		-- actorID
		self.name   = pack:readString();	-- 名字
		self.lv 	= pack:readByte();		-- 等级
		self.job 	= pack:readByte();		-- 职业
		self.hp		= pack:readInt();		--hp
		self.mp		= pack:readInt();		--mp
		self.maxHp	= pack:readInt();		--maxhp
		self.maxMp	= pack:readInt();		--maxmp
		self.scene_id = pack:readWord();	--场景id
		self.pos_x  = pack:readInt();		-- x
		self.pos_y  = pack:readInt();		-- y
		self.head_id = pack:readWord();		--头像ID
		self.sex	= pack:readByte();		--性别
		self.social = pack:readInt();		-- 社会关系
		--print("self.handle,self.actor_id,self.name,self.lv,self.job,self.hp,self.mp,self.maxHp,self.maxMp,self.scene_id,self.pos_x,self.pos_y,self.head_id,self.sex,self.social",self.handle,self.actor_id,self.name,self.lv,self.job,self.hp,self.mp,self.maxHp,self.maxMp,self.scene_id,self.pos_x,self.pos_y,self.head_id,self.sex,self.social)
	end

end
