-- TopListPersonalStruct
-- HJH
-- 2013-3-4
--

super_class.TopListPersonalStruct()

function TopListPersonalStruct:__init( pack )
	if pack ~= nil then
        local have_mount = 0
        self.playerId = pack:readInt()
        self.rankId = pack:readInt()
        local have_mount = pack:readInt()
        self.mountInfo = nil 
        if have_mount == 1 then
        	self.mountInfo = MountsStruct(pack)
        end
        local role_equip_num = pack:readInt()
        self.userItem = nil 
        for i = 1, role_equip_num do
        	self.user_item[i] = UserItem(pack)
        end
        local have_gem = pack:readInt()
        self.gemInfo = nil 
        if have_gem ~= 0 then

        end
        local soul_num = pack:readint()
        self.soulInfo = nil 
        for i = 1, soul_num do
        	--self.soul_info[i] = 
        end
        local have_pet = pack:readint()
        if have_pet ~= 0 then
	        self.petId = pack:readInt()
	        self.zzId = pack:readInt()
	        self.petTitleWx = pack:readWord()
	        self.petTitleGrow = pack:readWord()
	        local wx = pack:readWord()
	        self.petWxMax = Utils:rshift( Utils:lshift(wx, 8) , 8 )
	        self.petWx = Utils:rshift( wx, 8 )
	        local grow = pack:readWord()
	        self.petGrowMax = Utils:rshift( Utils:lshift(grow, 8), 8 )
	        self.petGrow = Utils:rshift( grow, 8 )
	        self.petAttack = pack:readWord()
	        self.petDefence = pack:readWord()
	        self.petLq = pack:readWord()
	        self.petSf = pack:readWord()
	        local pet_skill_num = pack:readWord()
	        self.petSkillInfo = {}
	        for i = 1, pet_skill_num do
	        	local skill = PetSkillStruct()
	        	local skill_info = pack:readInt()
	        	skill.skillId = Utils:rshift( Utils:lshift(skill_info, 16) , 16 )
	        	skill.skillLv = Utils:rshift( skill_info, 16)
	        	self.petSkillInfo[i] = skill_info
	        end
	    end
	end
end