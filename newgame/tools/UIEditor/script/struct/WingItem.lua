-- filename: WingItem.lua
-- author: created by fanglilian on 2012-12-14.
-- function: 翅膀道具类

require "struct/UserWingSkill"

super_class.WingItem();

function WingItem:__init(pack)
	if pack == nil then
		return;
	end
	self.isOpened = pack:readByte(); 	-- 是否已开启坐骑系统，1开启，0未开启，后面的字段就不用读了
	self.player_id = pack:readInt();	-- 玩家id
	self.level = pack:readInt();		-- 翅膀等级
	self.stage = pack:readInt();		-- 翅膀几阶
	self.star = pack:readInt();			-- 翅膀几星
	self.score = pack:readInt();		-- 评分
	self.modelId = pack:readInt();		-- 使用的是几阶的模型
	self.wishes = pack:readInt();		-- 祝福值

	-- 4个属性值，是基础值加上进阶属性值
	self.attack = pack:readInt();		-- 攻击.
	self.outDefence = pack:readInt();	-- 物防
	self.inDefence = pack:readInt();	-- 法防
	self.hp = pack:readInt();			-- 生命
	-- 技能的等级
	self.skills = {};
	self.skills_level = {}

	local count = WingConfig:getWingSkillNum()
	for i=1, count do
		self.skills[i] = WingConfig:get_index_wing_skills(i)
		self.skills_level[i] = pack:readInt();
	end

	--技能的熟练度
	for i=1,count do
		self.skills[i].exp = pack:readInt();
	end
end