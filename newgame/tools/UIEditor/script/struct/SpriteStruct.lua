-- SpriteStruct.lua
-- created by mwy on 2014-5-12
-- 精灵系统数据结构

super_class.SpriteStruct()

function SpriteStruct:__init( pack )
	-- 基础
	self.fight_value	= pack:readInt()		-- 精灵评分、战斗力
	self.model_id 		= pack:readInt()		-- 精灵模型score 
	self.level			= pack:readInt()		-- 精灵等级
	self.exp			= pack:readInt()		-- 经验

	-- 等阶
	self.stage_level	= pack:readInt()		-- 等阶(索引从1开始)
	self.star_level		= pack:readInt()		-- 星级(索引从0开始)
	self.blessing		= pack:readInt()		-- 祝福值

	--轮回 
	self.lunhui_level		= pack:readInt()	-- 轮回转数(索引从0开始)
	self.lunhui_star_level	= pack:readInt()	-- 轮回星级(索引从0开始)
	-- print('----------------SpriteStruct----------------self.lunhui_level,self.lunhui_star_level,self.model_id',self.lunhui_level,self.lunhui_star_level,self.model_id)

	-- 四个基本属性
	self.attr_life		= pack:readInt()		-- 生命
	self.attr_attack	= pack:readInt()		-- 攻击
	self.attr_wDefense	= pack:readInt()		-- 物防
	self.attr_mDefense	= pack:readInt()		-- 魔防

	-- 技能
	self.skill_count	= pack:readInt()		-- 开启技能个数
	self.skills = {};		--技能
	self.skills_level = {}  --技能等级
	for i=1,self.skill_count do
		self.skills[i] =SpriteConfig:get_skill_by_index(i) 	    -- 技能
		self.skills_level[i] = pack:readInt(); 					-- 技能等级
		self.skills[i].exp = pack:readInt();   					-- 技能熟练度
	end	

	--装备 
	self.equip_count	= pack:readInt()	    						-- 开启装备个数
	self.equips         ={}												-- 闪耀技能
	self.equips_level   ={}												-- 闪耀等级
	for i=1,self.equip_count do
		self.equips[i]       = SpriteConfig:get_equip_by_index(i) 	    --  闪耀技能
		self.equips_level[i] = pack:readInt(); 					        --  闪耀等级
		self.equips[i].exp   = pack:readInt();   					    --  闪耀经验
	end	

	-- 元宝升级次数
	self.upstage_times =0

	 -- ZXLog("-----SpriteStruct ----",self.model_id)
end