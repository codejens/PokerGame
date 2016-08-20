-- ZSlotSkill.lua
-- created by aXing on 2014-5-12
-- 技能格子

-- @ 暂时不实现拖动功能（要改动不难）
-- @ 默认底框
-- @ 技能等级
-- @ 被动技能标志
-- @ 技能类型标志

super_class.ZSlotSkill(ZSlotBase)		-- 这里必须说明，暂时技能格子不需要拖动属性
										-- 如果有需要拖动的时候，理论上只要把父类改为XSlotMove即可

local DEFAULT_BACKGROUNG_TEXTURE = UIResourcePath.FileLocate.skill .. "skill_item_bg2_1.png"	-- 默认技能背景框(圆形的)

-- 初始化
-- @width 			格子宽度
-- @height			格子高度
-- @without_bg		是否不带底框(默认携带)
function ZSlotSkill:__init( width, height, without_bg )

	self.without_bg = without_bg or false

	if not self.without_bg then
		self:create_bg(DEFAULT_BACKGROUNG_TEXTURE)
		-- 既然创建了底框，则需要移动图标
		if self.icon ~= nil then
			-- self.icon:setPosition(2, 2)				-- 认为外框是高宽4个像素
			local icon_width = width  - 4
			local icon_height= height - 4
			self.icon:setSize(icon_width, icon_height)
		end
	end
end

function ZSlotSkill:fini(  )
	-- body
end

-------------------------------------------
--
--  私有方法
--
-------------------------------------------

-- 创建背景
function ZSlotSkill:create_bg( texture )
	if self.bg == nil then
		self.bg = ZImage.new(texture)
		self.bg:setSize(self.width, self.height)
		self:addChild(self.bg, 0)
	end
end


-------------------------------------------
--
--  公有方法
--
-------------------------------------------

-- 设置技能图标
function ZSlotSkill:set_icon( skill_id )
	if ( skill_id == nil  ) then
        self:set_icon_texture("");
    else
        local texture = SkillConfig:get_skill_icon(skill_id)
        self:set_icon_texture(texture)
    end
end

-- 根据数据内容填充slot
-- @data 类型是userSkill
function ZSlotSkill:update_userSkill( data )
	self:set_icon(data.id)
end