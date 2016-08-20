-- MiJiStruct.lua
-- create by tjh on 2014-6-3
-- 秘籍结构体

super_class.MiJiStruct()


function MiJiStruct:__init( pack )
    self.is_all  = pack:readByte()           -- 是否全部
    self.fight 	 = pack:readInt()              --战力
    self.skill_num    = pack:readByte()        --技能总数
   -- print("MiJiStruct:__init", self.is_all,self.fight,  self.skill_num )
    self.miji_date = {}

    for i=1,self.skill_num  do
        self.miji_date[i] = {}
      	self.miji_date[i].skill_id = pack:readWord()
      	self.miji_date[i].userItem = UserItem(pack)
    end  
end