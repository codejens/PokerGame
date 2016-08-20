-- SlotPetSkill.lua
-- created by hcl on 2013-12-18
-- 继承自SlotItem
-- 用于放宠物技能


super_class.SlotPetSkill(SlotItem)

local OriginalSize = 67 

function SlotPetSkill:__init( width, height )
	
	self.scale = width / OriginalSize
    self.icon:setScale(self.scale)

end

-- 设置宠物技能图标
function SlotPetSkill:set_pet_skill_icon( skill_id,skill_lv ) 
    if ( skill_id == nil or skill_lv == nil ) then
        self:set_icon_texture("");
    else
        local texture = SkillConfig:get_skill_icon_path( skill_id,skill_lv)
        self:set_icon_texture(texture)
    end
end