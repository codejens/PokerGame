-- SkillConfig.lua
-- created by aXing on 2012-12-10
-- 技能配置

-- super_class.SkillConfig()
SkillConfig = {}

-- require "../data/std_skill"

---示范技能,不要删除,用于程序占位
--[[
{
	id=0,--技能的ID
	name=Lang.Skill.s0Name,--技能的名字
	desc=Lang.Skill.s0Desc,--技能介绍
	vocation=1,--使用职业,如果是0，那么就任何职业都能学习天雷=1,蜀山=2,圆月=3,云华=4,易筋=5,洗髓=6,剑士=7,忍者=8,怪物=9,其他=10

	skillType=0,--技能的类型(从技能的功能上划分),0表示内功单体,1被动,2内功群体,3,外功单体，4,外功群体,5表示生活技能,7普通攻击,8其他特殊技能(比如光环类)，9宠物给人加的被动技能

    skillClass =0,--技能的分类(从系统上做区分的技能的分类),1玩家职业基本技能，2玩家阵营技能,3必杀技,4玩家侠侣技能，5玩家职业绝学，6 玩家江湖绝学，7玩家通用技能,8宠物技能，9怪物技能

    skillSpellType=0,	
	
		0表示直接释放，如果选择了目标将直接释放
		1表示点击了技能图标以后，还需要选择一个目标才会释放,
		2表示点击技能图标以后,还需要选择一个点才会释放，
		3 表示仅对自己使用，这时将忽略选中的目标
	
	specialBuffCond =0,
	
		封是封内功，断是断外功
		技能在特殊的buff的下是否能够使用
		0表示在封断和晕眩都不能使用，默认是0
		1表示在封断的时候能够使用
		2表示在晕眩的时候能够使用
		3表示在晕眩和封断的时候都能使用
	
    canbeDefault = true, --能否作为默认技能，不填写就是false

    notAutoUse = false, --挂机时不自动使用,默认都是false
	
	commonCd=0,--使用的时候触发的公共的cd时间，单位是毫秒

    priority=0,  --技能的优先级，优先级高的在同等条件下放

	--下面是技能的各等级的信息
	skillSubLevel=
	{
--#include "Skill_sample_1.txt"	
	}
},
--]]--

--技能0的1级
--[[
{
	--技能的三个动作的播放顺序,act动作编号effect施法特效编号
	actions=
	{
		{act=0,effect=10,},
		{act=1,effect=20,},
		{act=2,effect=30,},
	},
	
	desc=Lang.Skill.s1L1Desc,--技能的描述
	
	iconID=1,--图标的ID
	
	--作用范围表
	actRange=
	{
		{
			--[范围筛选,假设相对中心点的位置偏移
					yStart
					|
			xStart<-中心点->xEnd
					|
					yEnd
			--]
			xStart=0,--相对于中心点x左边的相对坐标
			xEnd=0,--相对于中心点x右边的相对坐标
			yStart=0,--相对于中心点y上边的相对坐标
			yEnd=0,--相对于中心点y下边的相对坐标

		rangeType=0,			--[   范围的类型
										0:无范围，仅针对目标的单体技能(单体)
										1:线性旋转(单体)
										2:线性范围(群体)
										3:范围(群体)
								--]
	
		rangeCenter=0,	
								--[
									范围中心类型
									0:目标
									1:施法者自己
									2:施法点（鼠标落点）
									--]		

			--这个是在一定条件下产生的结果
		acts=
			{
				{
					
				   	targetType=1,--不进行目标筛选也可以施放

					--目标筛选条件表
					conds=
					{
						--[cond表示条件类型，有如下值:
							1：目标为敌人,valueasbool
							2：目标为友方,valueasbool
							3：目标为自己,valueasbool
							4: 目标为队伍成员,valueasbool
							5: 目标为怪物,0表示所有怪物有效，1表示普通怪，2精英，3头目，4boss
							6: 目标为玩家,valueasbool
							7：目标等级>=value,
							8：目标等级<=value
							9: pk值低于数值,整数
							10:pk值高于数值,整数
							11:随机概率,5000表示百分之50概率，单位万分之1
							12:死亡,valueasbool
							13:可攻击,valueasbool
							14:等级差小于等于,就是自己的等级减目标的等级小于等于这个数值
							15:反向等级差小于等于，就是目标的等级减自己的等级小于等于这个数值
							16:存在buff：目标身上是否有这个buff,value={type=buff类型,id=buff的组(buffid,如果匹配所有填-1)}
							17:不存在buff:目标身上是否不存在这个buff,value={type=buff类型,id=buff的组(buffid,如果匹配所有填-1)}
							18:驯服成功,valueasbool
							19:目标存在技能标识,整数
							20:目标存不在技能标识，整数
							21:自己存在技能标识，整数
							22:自己不存在技能标识，整数
							23: HP高于百分比,整数，用万分数表示,6000表示60%
							24: HP低于百分比,整数，用万分数表示,6000表示60%
							25: MP高于百分比,整数，用万分数表示,6000表示60%
							26: MP低于百分比,整数，用万分数表示,6000表示60%
							27: 帮派相同,valueasbool
							28: 需要目标，并且要面向目标,value=1
							29：需要目标，并且要和目标的方向一样,value=1表示方向一致，value=0，表示方向相反
							30: 是怪物，并且value =怪物id
							31: 阵营相同,valueasbool
							32: 自身的血量高于百分比，用万分数表示,6000表示60%
							33: 自身的血量低于百分比，用万分数表示,6000表示60%
							34: 目标和自己是结拜关系,valueasbool
							35: 目标是自己的主人,valueasbool
							36: 目标是自己的下属，value=ture表示只打下属，否则表示攻击非下属的实体
						--]
						{cond = 5,value =true},
					},

					--针对目标的实际作用,
					results=
					{
						--[
							mj：无效
							delay:表示这个结果将延迟多长时间出现,单位为毫秒
							timeParam:表示作用的时长,或者作用的次数
							type表示作用类型，有如下值:
							1：加buff，type是物品buff效果,
								type效果id,比如加血,这个在另外一张表里配置
								id:技能的ID，或者技能的组
								rate：相对于玩家自身攻击值(或者治疗属性)的一个比率(正数对应治疗，负数对应攻击)，使用整数配置，填写的是10000分之几，比如4000表示40%，如果没有填0
								value表示附加的数值,也就是玩家的自身攻击(治疗)上附加加的数值，如果和玩家的攻击不关联的话就直接rate填0
								interval是buff的作用作用的间隔,单位秒
								timeParam:表示作用次数
								vt=1表示value是浮点数(万分之1),0表示是整数
							2:删除buff,value={type=1,id=2}表示删除type=1,id=2的buff
							3：法术伤害,rate表示技能的伤害系数，也是万分之1的配置,value表示技能的附加伤害，id表示造成连击效果的概率,最大100，type表示连击额外伤害的次数，id和type不配置默认是0
							4:物理伤害,rate表示技能的伤害系数，也是万分之1的配置,value表示技能的附加伤害，id表示造成连击效果的概率,最大100，type表示连击额外伤害的次数，id和type不配置默认是0
							5:改变吟唱时间,value=-1表示吟唱时间的降低1秒 (废弃，没有实现)
							6:改变冷却时间,value=-1表示冷却时间降低1秒  (废弃，没有实现)
							7:修改玩家的属性,value={id=属性加成ID,value=属性加成的数值,vt=1表示是浮点数(万分之1),0表示是整数}
							8:超级爆击value={rate=超级暴击的比率，万分之1(1000表示10%),value=超级暴击暴击的基础上的伤害加成,暴击是150%，如果超级暴击是180%的话这里填3000}
							9:瞬移到目标的坐标
							10:把目标抓到自己的身边,抓取的坐标在范围里配置
							11:投掷事件,value={id=特效库的标号,1表示skill目录,2表示effect,3表示event,value=特效的ID}
							12:攻击目标设置为我
							13:治疗,value={rate=1667,value=20},rate表示与自己治疗属性的比例，单位为万分之1，这里1667表示16.67%,value表示附加治疗数值
							14:冲锋,value表示冲锋的距离
							15:丢弃目标
							16:删除特效 type 表示特效的类型 id 表示特效的ID
							17:刷出一个怪物{id=1,value=1000,count=1} id表示怪物的id,value表示存活时间，单位是秒，如果是0表示一直存在,count=1表示数量,vt表示实体类型，vt=1是怪物，12是采集怪
							18:玩家客户端振屏，rate表示振屏的像素大小，数值越大越厉害,value表示振屏的持续时间，单位毫秒
							19:将符合条件的对象全部拉到自己的旁边，value={x=相对自己的坐标x,y=相对自己的坐标y,vt=0} vt=0表示不线性旋转，vt=1表示线性旋转
							20:添加技能标记 value={id=1,value=1}，技能的标记如果不填就是0,timeParam表示技能作用的时间,单位ms
							21:删除技能标记 value为技能标记的id
							22:（取消暴击的几率功能，暴击伤害功能保留，所以只设置伤害值就可以了）本次攻击暴击的几率和伤害的提高 value={rate=暴击的比率提高，万分之1(1000表示10%),value=打出暴击的基础上的伤害加成,暴击是150%，如果不加成就是0}
							23:(取消）本次攻击命中概率的提升，value为提升的数值，万分之1的比例
							24:说话，value={type=1,id=2} id为MonsterSay.txt里配置的话的id,type表示广播的类型  1：附近  2：场景 3：副本  4：世界 5：同阵营广播
							25:牺牲自己当前生命值的 value={rate=自身的血量降低多少(1000表示10%),value=将自身血量降低的多少比例给目标,8000表示自身血量降低的80%加给目标}
							26:删除特定技能的冷却CD,立刻可以使用,value表示该技能的ID
							27:法术或者物理伤害,rate表示技能的伤害系数，也是万分之1的配置,value表示技能的附加伤害，攻击值取法术攻击和物理攻击的最大值,id表示造成连击效果的概率,最大100，type表示连击额外伤害的次数，id和type不配置默认是0
							--]
							
						{mj=0,timeParam=5,type=1,delay=0,value={type=1,id=80,rate=3000,value=200,interval=15,vt=0}},
						{mj=0,timeParam=1,type=2,delay=0,value={type=1,id=2}},
						{mj=0,timeParam=1,type=3,delay=0,value={rate=3000,value=200, id=10,type=2}},
						{mj=0,timeParam=1,type=4,delay=0,value={rate=3000,value=200}},
						{mj=0,timeParam=1,type=5,delay=0,value=-1},
						{mj=0,timeParam=1,type=6,delay=0,value=-1},
						{mj=0,timeParam=1,type=7,delay=0,value={id=1,value=100,vt=0}},
						{mj=0,timeParam=1,type=8,delay=0,value={rate=1000,value=3000}},
						{mj=0,timeParam=1,type=9,delay=0,value=-1},
						{mj=0,timeParam=1,type=10,delay=0,value=1},
						{mj=0,timeParam=1,type=11,delay=0,value={id=1,value=1}},
            			{mj=0,timeParam=1,type=16,delay=0,value={type=1,id=1000}},
					},
					--特效always
					--[
					技能产生的特效组。一个技能可能产生几个特效。
					specialEffects表示技能产生的特效,比如火团，陷阱等
					type：特效的类型,无效果=0,挥洒=1,中心爆炸=2,飞行=3,脚下爆炸=4,脚下持续=5,持续=6
					id:特效的ID
					keepTime:持续时间,单位是毫秒
					delay:效果延续多长时间出现	,单位是毫秒
					always:是否总是打出特效,如果为false只在命中的时候打出特效
					targetpos:是否在目标的位置播放特效，默认是false（不用填），注意：增加这个字段的目的是避免因为被攻击的目标死亡而播不出特效的问题
					--]
					specialEffects=
					{
						{type=1,mj=0,id=22,keepTime=10000,delay=500,always=false},
					},
				},
			},
		},
	},

	--[
	技能升级和释放的条件的配置，可能有多种的类型，这里使用条件ID,数值，是否消耗的三元组来表示
	condition的类型
	1:等级
	2:银两的消耗,value为银两消耗的数值
	3:存在物品
	4:经验
	5:修为
	6:职业:天雷=1,蜀山=2,圆月=3,云华=4,
	7:HP消耗value,
	8:MP消耗value	
	9:目标存在
	10:检查指定宠物数量
	11:存在buff,value为buff的type
	12:不存在buff,value为buff的type
	13:和目标的距离必须小于等于一定的距离,value表示距离
	14:和目标不能坐标重合，如果不能重合value=1
	15:需要目标，并且要面向目标,value=1
	16:需要目标，并且要和目标的方向一样,value=1
	17:坐骑经验必须大于等于value，value为坐骑经验的值，用于骑术的升级，
	18:自身的血的比例必须<=一定的比率,value为比例，百分之1，如果是小于等于20%，value=20
	19:需要目标，并且目标是特定的类型value=1表示敌人,value=2表示友方
	20:需要目标，并且目标可攻击,value可以填1
	21:生活技能熟练度value为熟练度的数值
	22:跳跃体力的消耗,value为体力消耗的数值
	23:仙币的消耗,value为绑定银两消耗的数值
	24:需要阵营的职位,value表示职位的id
		1="盟主" 2="奉天盟使",  3="承坤盟使", 4="冥苍护法",  5="逸白护法", 6="炎朱护法", 7="铁玄护法", 
		8="蟠云卫",9="坎雷卫",10="玉风卫",11="啸电卫",12="南明卫",13="璃火卫",14="紫川卫",15="灵武卫",
	25:需要结拜人数>=value,value表示结拜人数的个数,不包含自己
	26:需要目标，并且和目标的y轴的绝对距离少于等于value
	27: 队伍里的在线的结拜好友的数量 >= value，不包括自己
	28: 消耗基础蓝的万分比  value表示基础蓝的万分比，比如8500表示85%，玩家的基础蓝表示等级带来的MaxMp,不包括buff，装备等附加的
	29: 消耗基础血的万分比  value表示基础血的万分比，比如8500表示85%，玩家的基础血表示等级带来的MaxHp,不包括buff，装备等附加的
	30: 消耗怒气值
		consume表示是否消耗，如果true表示要消耗，否则不需要
	--]
	--升级条件
	trainConds=
	{
		{cond=1,value=10,consume=false},--表示等级要10级
		{cond=6,value=1,consume=true},--需要天雷职业
	},
	
	spellConds=
	{
		--[
			cond表示条件类型，类型同上的定义
		--]
		{cond=7,value=10,consume=false},
		{cond=8,value=10,consume=false},--消耗蓝10
	},

	singTime=1000,		--吟唱时间,单位是毫秒

	cooldownTime=1000,	--冷却时间,单位是毫秒

},
--]]--

-- 技能标志位
SkillConfig.DefaultSkill 		= 0x00000001			-- 可作为默认技能
SkillConfig.CanUseOnFriend		= 0x00000002			-- 可对友军使用
SkillConfig.NeedSelectRange		= 0x00000004			-- 需要释放范围(这个手机版本不用)
SkillConfig.NeedSelectTarget	= 0x00000008			-- 需要单独选择目标
SkillConfig.AlwaysUse			= 0x00000010			-- 在麻痹状态下依然可以使用
SkillConfig.OnlyUseForSelf		= 0x00000020			-- 仅对自己使用

-- 技能配置
-- 0 表示直接释放，如果选择了目标将直接释放
-- 1 表示点击了技能图标以后，还需要选择一个目标才会释放,
-- 2 表示点击技能图标以后,还需要选择一个点才会释放，
-- 3 表示仅对自己使用，这时将忽略选中的目标
SkillConfig.ST_DIRECTLY				= 0 
SkillConfig.ST_NEED_TARGET			= 1
SkillConfig.ST_NEED_POINT			= 2
SkillConfig.ST_TO_SELF				= 3

-- 技能使用条件
SkillConfig.SC_LEVEL				= 1 				-- 等级
SkillConfig.SC_MONEY				= 2 				-- 金钱
SkillConfig.SC_ITEM					= 3 				-- 存在物品
SkillConfig.SC_EXP					= 4 				-- 经验
SkillConfig.SC_XIUWEI				= 5 				-- 修为
SkillConfig.SC_JOB					= 6 				-- 职业
SkillConfig.SC_HP 					= 7 				-- 消耗hp
SkillConfig.SC_MP					= 8 				-- 消耗mp
SkillConfig.SC_TARGET				= 9 				-- 目标存在
SkillConfig.SC_PET_COUNT			= 10 				-- 检查指定宠物数量
SkillConfig.SC_BUFF 				= 11 				-- 存在buff,value为buff的type
SkillConfig.SC_NO_BUFF				= 12 				-- 不存在buff
SkillConfig.SC_MAX_TARGET_DIST		= 13  				-- 和目标的距离必须小于等于一定的距离,value表示距离
SkillConfig.SC_NOT_OVERLAP_TARGET	= 14 				-- 和目标不能坐标重合，如果不能重合value=1
SkillConfig.SC_FACE_TO_TARGET		= 15 				-- 需要目标，并且要面向目标, value=1
SkillConfig.SC_SAME_DIR_WITH_TARGET	= 16 				-- 需要目标，并且要和目标的方向一样,value=1
SkillConfig.SC_MIN_RIDE_EXP			= 17 				-- 坐骑经验必须大于等于value，value为坐骑经验的值，用于骑术的升级
SkillConfig.SC_MAX_HP_PERCENT		= 18 				-- 自身的血的比例必须<=一定的比率,value为比例，百分之1，如果是小于等于20%，value= 20
SkillConfig.SC_APPOINT_TARGET		= 19				-- 需要目标，并且目标是特定的类型 value=1表示敌人,value=2表示友方
SkillConfig.SC_ASSAULTABLE_TARGET	= 20 				-- 需要目标，并且目标可攻击,value可以填1
SkillConfig.SC_LIFE_SKILL_EXP		= 21 				-- 生活技能熟练度 value为熟练度的数值
SkillConfig.SC_JUMP_CONSUME			= 22 				-- 跳跃体力的消耗,value为体力消耗的数值
SkillConfig.SC_BIND_YINLIANG		= 23 				-- 绑定银两的消耗,value为绑定银两消耗的数值
SkillConfig.SC_ZY_POSITION			= 24 				-- 需要阵营的职位,value表示职位的id
SkillConfig.SC_JB_COUNT				= 25 				-- 需要结拜人数>=value,value表示结拜人数的个数
SkillConfig.SC_MAX_TARGET_DIST_Y	= 26 				-- 需要目标，并且和目标的y轴的绝对距离少于等于value
SkillConfig.SC_MIN_SWORN_FRIEND_OL	= 27 				-- 队伍里的在线的结拜好友的数量 >= value，不包括自己
SkillConfig.SC_GONGXIAN				= 28 				-- 帮派贡献
SkillConfig.SC_YUESHI				= 29 				-- 月石


SkillConfig.SKILL_TYPE_BEIDONG      = 1                  -- 被动技能类型

--记录所有skill，分类
local skill_table = {}
local prefix = "../data/"
local data_name = "std_skill"
--读取item表
local function load_skill_config( skill_id )
	--获取主index
	local index = math.floor(skill_id / 3)			-- 这个步长是根据拆分文件大小少于100kb来划分的，
													-- 如果需要改这个步长，则必须把打包文件也一齐修改了
	--检索读过没有
	local config = skill_table[index]
	--读取
	if not config then
		local config_index = data_name .. index
		local file = prefix .. config_index
		require(file)
		--从全局表检索
		config = _G[config_index]
		--记录
		skill_table[index] = config
	end
	return config[skill_id]
end

-- 根据技能id获取静态技能配置
function SkillConfig:get_skill_by_id( skill_id )
	skill_id = skill_id or 0
	local skill = load_skill_config(skill_id)
	if skill == nil then
		print("There is not this skill: " .. tostring(skill_id) )
	end
	return skill
end

-- 技能的icon路径
local icon_path = "icon/skill/"

-- 返回技能的icon路径
function SkillConfig:get_skill_icon( skill_id )	
	local skill = load_skill_config(skill_id)
	if skill == nil then
		print("There is not this skill: " .. skill_id)
		return icon_path .. "default.pmt"
	end
	-- 暂时先
	-- return icon_path .. "default.png"
	return string.format("%s%05d.pmt", icon_path, skill.skillSubLevel[1].iconID)
end
	

-- 返回宠物技能的icon路径
function SkillConfig:get_skill_icon_path( skill_id,skill_lv)
	local skill = load_skill_config(skill_id)
    local icon_id = skill.skillSubLevel[skill_lv].iconID;
	if icon_id == nil then
		return icon_path .. "default.pmt"
	end	
	local path = "icon/skill/00" .. icon_id .. ".pmt";
	return path;
end

--返回仙印技能路径
function SkillConfig:get_xianyin_skill_icon_path( skill_id )
	
end

-- 根据职业获取角色的职业技能表
function SkillConfig:get_skills_by_job( job_type )
	local skill_t = {}
	local job_to_skill_id = { [1] = { 1, 2, 3, 4, 5, 6, 7, 8, 33 },
	                          [2] = { 9, 10, 11, 12, 13, 14, 15, 16, 34 },
	                          [3] = { 17, 18, 19, 20, 21, 22, 23, 24, 35 },
	                          [4] = { 25, 26, 27, 28, 29, 30, 31, 32, 36 }}

    for i = 1, #job_to_skill_id[job_type] do
        local skill = SkillConfig:get_skill_by_id( job_to_skill_id[job_type][i] )
        skill_t[ #skill_t + 1] = skill
    end
	return skill_t;
end

-- 测试，打印所有技能，的某个属性  desc
function SkillConfig:print_all_skill_attr( attr_name )
	for i = 1, #(std_skill) do
		if std_skill[i] then
	        local skill = std_skill[i]
            for j = 1, #skill.skillSubLevel do
                print("  等级 ：",j, " 名称： ", string.gsub(skill.name, "%%", "%%%%") )
                print(tostring(skill.skillSubLevel[j]))
                local desc_str = ""
                if skill.skillSubLevel[j][attr_name] then
                    desc_str = string.gsub(skill.skillSubLevel[j][attr_name], "%%", "%%%%")
                end
                print("属性 "..attr_name, desc_str )
            end
        else
        	print( i.."  技能id找不到技能" )
        end
	end
end

-- 获取技能的施法距离
function SkillConfig:get_spell_distance( id, level )
	local skill  = load_skill_config(id)
	local entity = skill.skillSubLevel[level]		-- 技能每个等级的配置
	local ret = {1,0}
	for key,cond in pairs(entity.spellConds) do
		if cond.cond == SkillConfig.SC_MAX_TARGET_DIST then
			-- 攻击范围不能小于1
			if cond.value < 1 then
				cond.value = 1
			end
			ret[1] = cond.value
			ret[2] = cond.value
		elseif cond.cond == SkillConfig.SC_MAX_TARGET_DIST_Y then
			ret[2] = cond.value
		end
	end
	return ret
end

-- 获取技能播放动作和特效
function SkillConfig:get_spell_action( id, level )
	local skill  	= load_skill_config(id)
	local entity 	= skill.skillSubLevel[level]		-- 技能每个等级的配置
	
	if entity.actions ~= nil then
		-- 虽然配置可能有很多动作序列，但我们目前只用第一个
		local action_id	= entity.actions[1].act
		local effect_id	= entity.actions[1].effect

		-- 动作id需要转换一下
		-- 现在暂时0动作1,1和2动作2
		if action_id > 0 and action_id <= 2 then
			action_id = ZX_ACTION_HIT_2
		else
			action_id = ZX_ACTION_HIT
		end
		return action_id, effect_id
	end
	return nil, nil
end

-- 获取技能的cd时间(毫秒)
function SkillConfig:get_skill_duration( id, level )
	local skill  	= load_skill_config(id)
	local entity 	= skill.skillSubLevel[level]		-- 技能每个等级的配置
	return entity.cooldownTime
end

-- 取得技能的名字
function SkillConfig:get_skill_name_by_id( skill_id )
	local skill = load_skill_config(skill_id)
	if ( skill ) then
		return skill.name;
	end
	return "";
end

-----------------以上是灭天的 先移植过来 慢慢删除
--
function SkillConfig:get_skill_effect_josn( skill_id )
	require "res.data.skill_effect_json"
	return SkillEffectJson[skill_id]
end
function SkillConfig:get_skill_effect_action( skill_id )
	--lp todo 临时
	if skill_id > 3 then
		return 0
	end
	return -1 
end
