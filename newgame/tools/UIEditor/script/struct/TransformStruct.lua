-- transformStruct.lua
-- created by mwy on 2014-5-28
-- 变身系统数据结构

super_class.transformStruct()

function transformStruct:__init( pack )
	-- 基础
	self.fight_value			  = pack:readInt()		                -- 精灵评分、总战斗力
	-- print("========fight_value: ", self.fight_value)
	---------------变身数据---------------
	self.transform_count 		  = pack:readChar()		                -- 变身的个数
	self.transforms 			  = {};		                            -- 变身
	for i=1,self.transform_count do
		local id     = pack:readWord();   				    -- 变身id
		self.transforms[i] 		  = TransformConfig:get_ninja_model_by_id(id) 	-- 技能
		self.transforms[i].id 	  = id
		self.transforms[i].level  = pack:readByte();   					-- 变身等级,为0时为未激活状态
		self.transforms[i].pieces = pack:readByte();   					-- 碎片数量
		local info 		          = pack:readInt();   					-- 培养数据,低16位为阶段，高16为当前阶段的等级
		self.transforms[i].stage  = Utils:low_word(info) 		
		self.transforms[i].stage_level  = Utils:high_word(info)
		self.transforms[i].fight_value = pack:readInt()					-- 评分、战斗力
		-- print("===transforms[i].fight_value==", self.transforms[i].fight_value)
		-- ZXLog("----id，level，碎片个数,stage,stage_level--------------",self.transforms[i].id,self.transforms[i].level,self.transforms[i].pieces,self.transforms[i].stage,self.transforms[i].stage_level)
	end	
	---------------秘籍数据---------------
	self.miji_count	              = pack:readChar()	    				-- 秘籍装备个数
	self.mijis                    ={}									-- 闪耀技能
	for i=1,self.miji_count do
		local id          = pack:readWord();   					-- 秘籍ID
		self.mijis[i]             = TransformConfig:get_miji_info_by_id( id ) -- 秘籍
		self.mijis[i].id 		  = id
		self.mijis[i].level       = pack:readByte();   				    -- 秘籍等级
		self.mijis[i].Zhufu       = pack:readWord();   				    -- 祝福值
		self.mijis[i].fight_value = pack:readInt()						-- 评分
		-- ZXLog("------------变身秘籍id，level，zhufu-----------",self.mijis[i].id,self.mijis[i].level,self.mijis[i].Zhufu)
	end	
	--------------------------------------
	self.xianhua_times            = pack:readWord();                    -- 仙化次数
	self.current_transform_id	  = EntityManager:get_curren_transform_id(  )									-- 保存当前变身的id
	self.current_transform_stage  = EntityManager:get_curren_transform_stage()									-- 保存当前变身的阶段

end