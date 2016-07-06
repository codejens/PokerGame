-- SlotXianYin.lua
-- created by lyl on 2014-9-16
-- 仙印

super_class.SlotXianYin( SlotBase )

-- 初始化格子
function SlotXianYin:__init( width, height )
	self.skill_id = nil
    
end

-- 设置仙印id （和技能用的是同一个配置，即技能id）
function SlotXianYin:set_skill_id( skill_id )
	self.skill_id = nil

    self:set_icon_by_id( skill_id )
end

-- 设置icon
function SlotXianYin:set_icon_by_id( skill_id )
	if ( skill_id == nil  ) then
        self:set_icon_texture("");
    else
        local texture = SkillConfig:get_skill_icon(skill_id)
        self:set_icon_texture(texture)
    end
end