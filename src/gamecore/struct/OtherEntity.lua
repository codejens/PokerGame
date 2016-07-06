--OtherEntity.lua
-- 非玩家实体数据结构

OtherEntity=simple_class()

function OtherEntity:__init( pack )
	self.date = true
	if not pack then
		self.date = false
		return 
	end
	self.attris = {} --需要改变的属性
	self.name 			= pack:readString()				-- 实体名字
	--print("name = ",self.name);
	-- 潜规则，名字后面要用"\"分割字符串，然后取第一个
	self.name_table = Utils:Split(self.name , "\\");  
	self.name = self.name_table[1];

	self.entity_id		= pack:readInt()				-- 实体id,如果没有则为0
	self.attris.entity_id = self.entity_id	
	--print("---------------------------------------------entity_id",self.entity_id);
	self.entity_handle	= pack:readInt64()				-- 实体handle
	self.entity_type	= pack:readInt()				-- 实体类型
	
	--print("entity_handle",self.entity_handle,self.entity_type)
	-- 判断实体是否已经创建
	local is_exist_entity = EntityManager:get_entity(self.entity_handle)
	if ( is_exist_entity ) then
		print("实体已经创建.............................................................")
		self.date = false
		return ;
	end

	self.is_pet 		= EntityConfig:is_pet(self.entity_type)
	local is_monster 	= EntityConfig:is_monster(self.entity_type)
	local is_npc 		= EntityConfig:is_npc(self.entity_type)

	local entity 		= EntityManager:get_entity(self.entity_handle)
	
	if entity then
		self.date = false
		return 
	end

	self.attris.x	= pack:readInt()
	self.attris.y	= pack:readInt()

	self.attris.tx	= pack:readInt()
	self.attris.ty 	= pack:readInt()
	local body 		= pack:readInt()

	if (is_monster or self.is_pet) then
		--table.insert(self.attris,{"face",Utils:low_word(body)})		-- 怪物和宠物的Face取低位  高位是称号
	else
	
		self.attris.face = body
	end

	-- 以下是只有怪物才有的属性
	if (self.is_pet or is_monster or is_npc) then

	end
	self.attris.name = self.name
	--self.attris.body = self.body


	self.attris.dir  = pack:readByte()

	local moveSpeed = 0

	-- 下面是只有怪物和npc才有的属性
	if (self.is_pet or is_monster or is_npc) then
		self.attris.level 			= pack:readByte()						-- 等级
		self.attris.hp 				= pack:readUInt()						-- 血量
		self.attris.mp 				= pack:readUInt()						-- 蓝量
		self.attris.maxHp 			= pack:readUInt()						-- 最大血量
		self.attris.maxMp 			= pack:readUInt()						-- 最大蓝量
		self.attris.moveSpeed 		= pack:readShort()						-- 移动速度
		self.attris.attackSpeed 	= pack:readWord()						-- 攻击速度
		self.attris.state 			= pack:readUInt()						-- 玩家状态
		local name_color		= pack:readUInt()
		if name_color == 0 then
			name_color 	= 0xffffff
		end
		--name_color 		= ZXLuaUtils:band(name_color, 0xffffff)			-- 名称颜色
		self.attris.wing 			= pack:readByte()						-- 怪物的官职和攻击类型或NPC任务状态
		self.attris.func			= pack:readInt()						-- npc功能类型，怪物暂时没有意义
		self.attris.attackSprite 	= pack:readInt()						-- 宠物的称号 低2位是悟性称号 高2位是成长称号，其他实体没意义
		self.attris.title 			= pack:readInt()						-- 阵营和排行称号信息
		
		self.attris.pet_titile_id		= pack:readInt() --宠物称号id
		self.attris.is_new 			= pack:readByte()				-- 是否新新出现 1是0不是
		self.attris.new_type 			= pack:readByte()				-- 出现形式
		self.attris.void_byte 		= pack:readShort()				-- 保留字段

		-- 阵营和排行称号信息
		if (self.is_pet or is_monster) then
			-- table.insert(self.attris,{"camp", Utils:low_word(title)})
			-- table.insert(self.attris,{"hpStore", Utils:high_word(title)})
		end
	end


	if self.is_pet then
		self.master_handle = pack:readUint64()
		self.attris.master_handle = self.master_handle
		self.entity_type = -2
	end
	-- print("插入type")
	-- self.attris.type = self.entity_type
	-- 添加读取buff			2013-4-13
	local buff_count	= pack:readByte()
	for i=1,buff_count do
		local buff 		= BuffStruct(pack)
		--new_entity:add_buff(buff)
	end


	-- 添加读取实体特效id
	local effect_count	= pack:readByte()
	for i=1,effect_count do
		local effect_type	= pack:readByte()
		local effect_id		= pack:readWord()
		local duration 		= pack:readUInt()			-- 毫秒
		--new_entity:add_effect(effect_type, effect_id, duration)
	end

end