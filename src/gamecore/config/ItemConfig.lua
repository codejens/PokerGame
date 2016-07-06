-- ItemConfig.lua
-- created by aXing on 2012-11-30
-- 物品属性配置

-- super_class.ItemConfig()

ItemConfig = {}

--物品配置示范
--[[
	{
		id = 0, --物品ID，必须是唯一的
		name ="test", --"测试物品"
		type = 0, --物品的类型，药品、技能书、任务物品等，使用数字类型编号
		sellType = 0,
		icon = 10, --物品图标图片编号
		--物品外观图片编号，可配置多个（一般是用于服装配置）。只对具有外形的装备类物品有意义，例如衣服、武器和坐骑
		--分别对应4个职业不同性别的外观，依次为天雷男、天雷女、蜀山男、蜀山女、圆月男、圆月女、云华男、云华女
		shape = {0,1,2,3,4,5,6,7}, --如果没外观，随便写一个数字，不需要8个
		dura = 1000, --装备耐久度，1000表示1耐久。非装备表示冷却时间，单位是毫秒，如没有冷却可以不填写。如果是技能书，这个就表示技能的等级1-4
		dup = 10, --叠加数量上限，默认值为0
		colGroup = 0, --冷却组，对于使用后具有冷却时间的物品来说，相同冷却组的物品将同时进入冷却恢复状态
		dealType = 0, --物品在商店中交易的货币类型，0为绑定货币，1为非绑定货币
		dealPrice = 10000, --物品在商店中售出的价格，售出和购买的货币的类型通过dealType配置
		time = 0, --物品的使用时限，单位是秒，0表示不限制使用时间。 
		validFbId=-1,		 -- 物品使用的有效副本ID。-1表明是不限制。对于配置了限制场景的物品，需要配置禁止交易、放入仓库等
		validSceneId=-1,	 -- 物品使用的有效场景ID。-1表明是不限制
		existScenes = {1,2,4,5,6}, --物品存在的有效场景集合。不在此场景列表中的物品会被删除。-1表示任何场景都可存在
		suitId =1,      --    套装的ID,
		
										 --  a)如果是装备表示装备的套装ID，
				 --  b)在功能物品里表示功能物品的子分类   1:磨刀石,2:大喇叭道具，3: 疾风令,4：gm大喇叭,
										 --                  5:表示能扩展背包的物品 6:黄钻vip道具,7：蓝钻vip道具,8:红钻vip道具,9:扩展宠物槽的道具,10:宠物的口粮，用于扩展增加宠物的忠诚度
										 --                  11表示宠物蛋,12 表示产生宝物的道具
										 --  c)在宝石里，suitId表示宝石的等级，比如5表示是5级宝石
										 --  d)在技能秘籍中，按2^(n-1)表示该秘籍开启的第几个效果，第1个效果是1，开启第2个效果是2，开启第3个秘籍效果是4，4个效果是8,开启1和4效果是9，以此类推                   
										 --  e)在宠物技能书里，表示的是 该技能书对应的宠物的技能的id

		--静态属性表，静态属性指物品原本具备的且不会改变的属性
		
	1)源泉类的装备,物品类型=12或者13的
	在物品的静态属性里配置
		
				 staitcAttrs =  
		
				 {
			
								{type=0,value =3000},    --表示回复时间是3000毫秒每次
			
								{type=0,value =25},      --表示每次回复的是25点
			
								{type=0,value =123},     --表示可以用ID为123的物品灌注,如果有多个物品可以在后面继续添加,,,
		{type=0,value =124},     --表示可以用ID为124的物品灌注
				 }
 
	2)药水类物品的配置，是buff药才需要这样配置,物品类型= 103，(可以多个buff，比如2个buff，下面的要配置8行,...)
		
						下面这个表示每次加3点HP,加30次，间隔为3秒，buffid=1

				3)宠物蛋的话，表示宠物的id，宝物蛋的话，填宝物的模型id 比如
				
				 staitcAttrs =  
		
				 {
			
								{type=0,value =1},    --宠物的id或者宝物的模型id
			
				 }

				staitcAttrs =
			 {        
			{type=11, value =3},    --type=增加的属性,value =每次添加的数值
			
						{type=0, value=30 },      --type=0,value= 作用次数    
			{type=0, value=3},        --type=0,value= 间隔时间，单位是秒 
			{type=0, value=1},        --type=0,value= buffID
		
			 }
	
			 3)速回药，灌注药的配置，物品类型= 104， 可以配置多个效果
			 staitcAttrs =
			 {        
						--表示一次性回复300点蓝
						{type=13, value =300},    --type=增加的属性,value =添加的数值
			 }

		staitcAttrs =
		{
			--一个属性的配置示范，type为属性类型，value为属性值
			{ type = 0, value = 0 },
		},
		--品质属性表，不具有品质属性的物品可以不进行配置
		qualityAttrs =
		{
			--品质的属性表
			{
				--一个属性的配置示范，type为属性类型，value为属性值
				{ type = 0, value = 0 },
			},
			--后续品质的属性表，每个品质等级的属性值是独立的，不会增加上一个品质等级的属性
		},
		--强化属性表，不能进行强化或不具有强化等级的物品可以不进行配置
		strongAttrs =
		{
			--强化+1的属性表
			{
				--一个属性的配置示范，type为属性类型，value为属性值
				{ type = 0, value = 0 },
			},
			--后续强化等级的属性表，每个强化等级的属性值是独立的，不会增加上一个强化等级的属性
		},


		--物品标志配置表，所有属性默认为false，如果不为true的属性，可以不填写 
		flags = 
		{
			recordLog = true,--是否记录物品流通日志
			denyStorage = false,--是否禁止存仓库
			denyAutoBindOnTake = false,--是否在穿戴后不自动绑定
			autoStartTime = false,--是否在获得时即开始计算时间，如果不具有此标志则将在装备第一次被穿戴的时候开始计时
			denyDeal = false,--是否禁止交易
			denySell = false,--是否禁止出售到商店
			denyDestroy = false,--是否禁止销毁
			destroyOnOffline = false,--是否在角色下线时自动消失
			destroyOnDie = false,--是否在角色死亡时自动消失
			denyDropdown = false,--是否禁止在死亡时爆出
			dieDropdown = false,--是否在角色死亡时强制爆出
			offlineDropdown= false,--是否在角色下线时强制爆出
			hasHole = false,--是否有宝石孔
			hideDura = false,--是否不显示耐久
			denySplite = false,--是否禁止在物品叠加后进行拆分（通常用于带有实现限制的物品）
			asQuestItem = false,--是否作为任务需求物品使用
			monAlwaysDropdown= false,--是否在怪物死亡爆出时不检查杀怪者等级差而均掉落
			hideQualityName = false,--是否隐藏装备的品质前缀文字
			useOnPractice = false,--是否可以再操练的时候使用 
		}, 
		--物品使用条件表
		conds = 
		{
			--必须到达10级或以上才能使用 
			{ cond = 1, value = 10 }, 
			--必须为value性别才能使用，0男1女2男女通用 注意:该项必须配置
			{ cond = 2, value = 0 },
			--必须为value职业才能使用，0:通用、1：天雷、2：蜀山、3： 圆月 、4：云华
			{ cond = 3, value = 0 }, 
			--结婚与否必须等于value才能使用，0表示未婚，1表示已婚
			{ cond = 4, value = 1 }, 
			--需要的骑术等级,value表示骑术的等级
			{ cond = 5, value = 1 }, 
			 --需要的阵营的职位,value表示职位的id
			{ cond = 6, value = 1 }, 
		},
		desc = "物品描述（说明）文字，可使用HTML语法", 
	},

--]]--

-- 道具类型的定义,type
ItemConfig.ITEM_TYPE_UNDEFINE			= 0   	-- 未定义类型的物品
ItemConfig.ITEM_TYPE_WEAPON    			= 1   	-- 武器
ItemConfig.ITEM_TYPE_DRESS     			= 2   	-- 衣服
ItemConfig.ITEM_TYPE_HELMET				= 3   	-- 头盔
ItemConfig.ITEM_TYPE_CUFF				= 4 	-- 护腕
ItemConfig.ITEM_TYPE_TROUSERS			= 5     -- 裤子
ItemConfig.ITEM_TYPE_RING				= 6     -- 戒指
ItemConfig.ITEM_TYPE_NECKLACE			= 7     -- 项链
ItemConfig.ITEM_TYPE_DECORATIONS		= 8     -- 饰品
ItemConfig.ITEM_TYPE_GIRDLE				= 9 	-- 腰带
ItemConfig.ITEM_TYPE_SHOES				= 10    -- 鞋子
ItemConfig.ITEM_TYPE_MARRIAGE_RING 		= 11 	-- 戒子
ItemConfig.ITEM_TYPE_PET 				= 12    -- 宠物
ItemConfig.ITEM_TYPE_ZUJI				= 13    -- 足迹
ItemConfig.ITEM_TYPE_WING 				= 14    -- 翅膀
ItemConfig.ITEM_TYPE_BADGE				= 15 	-- 阵营徽记
ItemConfig.ITEM_TYPE_FASHION_DRESS		= 16    -- 时装
ItemConfig.ITEM_TYPE_WEAPON_SHOW 		= 17	-- 武器外观
		
ItemConfig.ITEM_TYPE_PET_NECKLACE 		= 50    -- 宠物的项链  
ItemConfig.ITEM_TYPE_PET_CUFF			= 51    -- 宠物的护腕
ItemConfig.ITEM_TYPE_PET_DECORATIONS	= 52  	-- 宠物的饰品
ItemConfig.ITEM_TYPE_PET_ARMOR			= 53    -- 宠物的护甲
		
ItemConfig.ITEM_TYPE_XIANG				= 73    -- 赎罪香

ItemConfig.ITEM_TYPE_QUEST_ITEM 		= 81	-- 任务物品
ItemConfig.ITEM_TYPE_FUNCTION_ITEM		= 82	-- 功能物品，可以双击执行功能脚本的
ItemConfig.ITEM_TYPE_MEDICAMENTS		= 83    -- 普通药品
ItemConfig.ITEM_TYPE_FAST_MEDICAMENT	= 84	-- 速回药品
ItemConfig.ITEM_TYPE_GEM				= 85	-- 宝石
ItemConfig.ITEM_TYPE_EQUIVALENCE		= 86    -- 等价道具，可以用来出售换钱的道具 增加了一种物品类型
ItemConfig.ITEM_TYPE_EQUIP_ENHANCE		= 87    -- 装备强化类，比如强化石等
ItemConfig.ITEM_TYPE_EQUIP_UPGRADE		= 88    -- 装备升级材料

ItemConfig.ITEM_TYPE_PET_SKILL			= 89    -- 宠物技能书
ItemConfig.ITEM_TYPE_PET_MEDICAMENTS	= 90    -- 宠物普通恢复药品(持续恢复)
ItemConfig.ITEM_TYPE_PET_FAST_MEDICAMENTS= 91	-- 宠物速回药
ItemConfig.ITEM_TYPE_MP_STORE			= 92    -- 法力存储包
ItemConfig.ITEM_TYPE_HP_STORE			= 93    -- 生命存储包
ItemConfig.ITEM_TYPE_PET_HP_STORE		= 94    -- 宠物生命存储包

ItemConfig.ITEM_TYPE_ATTRI_MEDICAMENTS	= 95	-- 增加人物属性的药品
ItemConfig.ITEM_TYPE_SKILL_MIJI			= 96	-- 技能秘籍卷
ItemConfig.ITEM_TYPE_SPECIAL_RIDE  		= 97	-- 特殊坐骑


ItemConfig.ITEM_TYPE_PAY_GIFT			= 200	-- 付费礼包
ItemConfig.ITEM_TYPE_TIME_END_OPPEN		= 201	-- 倒计时为0后才能打开

--用于tip类型区分
ItemConfig.PERSON_SKILL_TIP				= 999	-- 人物技能tip
ItemConfig.PET_SKILL_TIP				= 1000  -- 宠物技能tip
ItemConfig.WING_SKILL_TIP				= 1001	-- 翅膀技能tip
ItemConfig.STRONG_LEVELS_TIP			= 1002  -- 人物全身强化等级加成tip
ItemConfig.STONE_LEVELS_TIP				= 1003 	-- 人物全身宝石等级加成tip
ItemConfig.GEM_GOUL_TIP					= 1004	-- 法宝仙魂的tip
ItemConfig.MONEY_TIP					= 1005	-- 货币tip
ItemConfig.HEART_TIP					= 1006	-- 结婚系统的红心tip
ItemConfig.MARRY_XY_TIP					= 1007	-- 结婚系统的仙缘等级tip
ItemConfig.MARRY_DETAIL_TIP				= 1008	-- 结婚系统的仙缘详细信息tip
ItemConfig.SHENQI_SKILL_TIP				= 1009	-- 神器技能tip
ItemConfig.PET_LINGZHEN_ATTRS_TIP		= 1012 	-- 宠物灵阵，属性统计
ItemConfig.XIAN_YIN_TIP					= 1013 	-- 仙印总览TIPS
ItemConfig.XIAN_YIN_SKILL_TIP			= 1014 	-- 仙印技能TIPS
ItemConfig.LIST_CONTENT_TIP				= 1015 	-- 列表形式的tips
ItemConfig.HOLYWEAPON_SKILLS_TIP		= 1016 	-- 神兵技能列表tips
ItemConfig.HELUOTUSHU_DETAIL_TIP		= 1017 	-- 河洛图书信息tips
ItemConfig.HELUOTUSHU_SERIES_TIP		= 1018 	-- 洛书系列信息tips
ItemConfig.FOUR_GUARDIAN_TIP			= 1019 	-- 四灵技能tips
-- 下面是功能物品的类型定义(非装备),用 suitId 保存
ItemConfig.ITEM_TYPE_FI_KNIFE_STONE		= 1 	-- 磨刀石
ItemConfig.ITEM_TYPE_FI_BIG_SPEAKER		= 2 	-- 大喇叭
ItemConfig.ITEM_TYPE_FI_MOVE_IMMEDIATELY= 3 	-- 疾风令
ItemConfig.ITEM_TYPE_FI_GM_SPEAKER		= 4     -- GM用的消息发送道具
ItemConfig.ITEM_TYPE_FI_BAG_DILATATION	= 5     -- 背包扩展相关物品
ItemConfig.ITEM_TYPE_FI_PET_WX			= 6     -- 宠物悟性丹 悟性保护丹
ItemConfig.ITEM_TYPE_FI_PET_GROW 		= 7     -- 宠物成长丹 成长保护丹
ItemConfig.ITEM_TYPE_FI_PET_SKILL_MARK	= 8     -- 宠物技能封印

		
-- 宠物蛋,宝物蛋类型,也是用suitID保存
ItemConfig.ITEM_TYPE_FI_PET_EGG 		= 11
ItemConfig.ITEM_TYPE_FI_MOUNT_EGG 		= 12

-- 使用条件类型
ItemConfig.USER_COND_TYPE_LEVEL         = 1
ItemConfig.USER_COND_TYPE_SEX           = 2
ItemConfig.USER_COND_TYPE_JOB           = 3
ItemConfig.USER_COND_TYPE_MARRY         = 4
ItemConfig.USER_COND_TYPE_RIDE          = 5
ItemConfig.USER_COND_TYPE_CAMP          = 6
		
-- 下面是物品归属类型
ItemConfig.ITEM_BELONG_ID 				= 1 	-- 账户绑定
ItemConfig.ITEM_BELONG_CHAR 			= 2 	-- 角色绑定

-- 下面是一些在脚本中用到的物品item_id, 
ItemConfig.ITEM_ID_YUE_BING				= 44465	--中秋月饼
ItemConfig.ITEM_ID_ZHAO_CAI_SHEN_FU     = 18227 --招财神符

ItemConfig.SIMPLE_TIP					= 1010  -- 简单tip，只有一段dialog(衣柜星级tip用到)
ItemConfig.SIMPLE_TIP2					= 1011  -- 简单tip，只有一段dialog(尺寸不同，坐骑化形界面用到)

--记录所有item，分类
local item_table = {}
local prefix = "../data/"
local data_name = "std_items"
--读取item表
local function load_item_config( item_id )
	item_id = item_id or 0
	--获取主index
	local index = math.floor(item_id / 500)			-- 这个步长是根据拆分文件大小少于100kb来划分的，
													-- 如果需要改这个步长，则必须把打包文件也一齐修改了
	--检索读过没有
	local config = item_table[index]
	--读取
	if not config then
		local config_index = data_name .. index
		local file = prefix .. config_index
		-- print("路径。。。 ", file)
		require(file)
		--从全局表检索
		config = _G[config_index]
		--记录
		item_table[index] = config
	end
	return config[item_id]
end

-- 根据道具id获得静态道具配置
function ItemConfig:get_item_by_id( item_id )
	 --print("ItemConfig:get_item_by_id   ... ", item_id)
	local item = load_item_config( item_id )
	if item == nil then
		print("There is not this item: " .. tostring(item_id))
	end
	return item
end

-- 道具的icon路径
local icon_path = "icon/item/"

-- 返回道具的icon路径
function ItemConfig:get_item_icon( item_id )
	-- if item_id == nil then
	-- 	print("ItemConfig warring : get_item_icon - item_id is nil" )
	-- 	return "icon/skill/default.png";
	-- end
	-- local item = load_item_config( item_id )
	-- if item == nil then
	-- 	print("There is not this item: " .. item_id)
	-- 	return "icon/skill/default.pmt";
	-- end
	-- lp todo 测试用
	return "ui/slot/test_item.png"
	-- return "ui/test/yifu.png"
	-- TODO:: 这里需要检查一下是否存在这个图标
	-- return string.format("%s%05d.pmt", icon_path, item.icon)
end

-- 根据id获取道具的基础属性（例如装备的基础攻击，宝石的基础加成）
function ItemConfig:get_staitc_attrs_by_id( item_id )
	local item = load_item_config( item_id )
	if item == nil then
		print("There is not this item: " .. item_id)
		return {}
	end
	return item.staitcAttrs
end

-- 根据加强等级获取 加强的属性
function ItemConfig:get_strong_attr_by_level( item_id, strong_level )
	local item = load_item_config( item_id )
	if item == nil then
		print("There is not this item: " .. item_id)
		return {}
	end
	return item.strongAttrs[strong_level]
end

-- 根据item_id判定是否是翅膀
function ItemConfig:is_wing( item_id ) 
	local item = load_item_config( item_id )
	if item == nil then
		print("There is not this item: " .. item_id)
	end
	return item.type == ItemConfig.ITEM_TYPE_WING
end

-- 根据技能书id取得对应的技能id
function ItemConfig:get_skill_id_by_item_id( item_id )
	local item = load_item_config( item_id )
	if item == nil then
		print("There is not this item: " .. item_id)
	end
	return item.suitId;
end

-- 根据装备id取得对应的名字
function ItemConfig:get_item_name_by_item_id( item_id )
	local item = load_item_config( item_id )
	if item == nil then
		print("There is not this item: " .. item_id)
	end
	return item.name;
end
-------取得道具颜色
function ItemConfig:get_item_color(quality)
	local color = {"FFFFFF", "66FF66", "35C3F7", "FF49F4", "FFC000", "FF0000"}
	return color[quality]
end

-- 获取宝石等级对应的颜色配置
function ItemConfig:get_gem_color( item_id )
	if item_id >= 18510 and item_id <= 18549 then
		local item = item_id-18500;
		local num = item%10+1;
		
		if num>=1 and num <=2 then
			--1、2级为绿色
			return "#c38ff33";
		elseif num>=3 and num <=4 then
			--3、4级为蓝色
			return "#c00c0ff";
		elseif num>=5 and num <=6 then
			--5、6级为紫色
			return "#cff66cc";
		elseif num>=7 and num <=8 then
			--7、8级为黄色
			return "#cfff000";
		elseif num>=9 and num <=10 then
			--9、10级为红色
			return "#cff0000";
		end
	end
end

-- 宠物蛋品质对应的颜色
function ItemConfig:get_pet_egg_color_by_quality( quality )
	--print("宠物蛋的品质",quality);
	if quality == 1 then
		return "#c38ff33";
	elseif quality == 2 then
		return "#c00c0ff";
	elseif quality == 3 then
		return "#cff66cc";
	elseif quality == 4 then
		return "#cfff000";
	end
	return "#cffffff";
end

-- 判断某个物品是否是攻击宝石
function ItemConfig:is_attack_gem( item_id )
	if item_id == nil then
        return nil
	end
	--攻击宝石的id集合，用来判断某件物品是否是攻击宝石
    local _attr_gem_num_t = { [18510] = true, [18511] = true, [18512] = true, [18513] = true,
                    [18514] = true, [18515] = true, [18516] = true, [18517] = true,
                    [18518] = true ,[18519] = true ,}
    return _attr_gem_num_t[ item_id ]
end

-- 判断某个物品是否是防御宝石
function ItemConfig:is_prot_gem( item_id )
	if item_id == nil then
        return nil
	end
	--防御宝石的id集合，用来判断某件物品是否是防御宝石
    local _prot_gem_num_t = { [18520] = true, [18521] = true, [18522] = true, [18523] = true,
                    [18524] = true, [18525] = true, [18526] = true, [18527] = true,
                    [18528] = true, [18529] = true, [18530] = true, [18531] = true,
                    [18532] = true, [18533] = true, [18534] = true, [18535] = true,
                    [18536] = true, [18537] = true, [18538] = true, [18539] = true,}
    return _prot_gem_num_t[ item_id ]            
end

-- 判断某个物品是否是生命宝石
function ItemConfig:is_life_gem( item_id )
	if item_id == nil then
        return nil
	end
	--防御宝石的id集合，用来判断某件物品是否是防御宝石
    local _hp_gem_num_t = { [18540] = true, [18541] = true, [18542] = true, [18543] = true,
                    [18544] = true, [18545] = true, [18546] = true, [18547] = true,
                    [18548] = true ,[18549] = true ,}
    return _hp_gem_num_t[ item_id ]            
end

function ItemConfig:is_use_in_lianfu( datebase )
    local _MEDICAMENTS_t = 
    {
        [ItemConfig.ITEM_TYPE_MEDICAMENTS]          = {optType = 1},    -- 普通药品
        [ItemConfig.ITEM_TYPE_FAST_MEDICAMENT]      = {optType = 1},   -- 速回药品
        [ItemConfig.ITEM_TYPE_PET_MEDICAMENTS]      = {optType = 1},    -- 宠物普通恢复药品(持续恢复)
        [ItemConfig.ITEM_TYPE_PET_FAST_MEDICAMENTS] = {optType = 1},    -- 宠物速回药
        [ItemConfig.ITEM_TYPE_MP_STORE]             = {optType = 1},   -- 法力存储包
        [ItemConfig.ITEM_TYPE_HP_STORE]             = {optType = 1},   -- 生命存储包
        [ItemConfig.ITEM_TYPE_PET_HP_STORE]         = {optType = 1},   -- 宠物生命存储包
        [ItemConfig.ITEM_TYPE_FUNCTION_ITEM]		= {optType = 2, idIndexTable = { [28273] = true, [28210] = true}}, --宠物拨浪鼓
    }

	if _MEDICAMENTS_t[datebase.type] then
    	if _MEDICAMENTS_t[datebase.type].optType  == 1 then
        	return  true
    	elseif _MEDICAMENTS_t[datebase.type].optType  == 2 then
    		if _MEDICAMENTS_t[datebase.type].idIndexTable[datebase.id] then
    			return true
    		else
    			return false
    		end
    	end
    else
        return false
    end
end

-- 获得品质对于的名字
function ItemConfig:get_equip_quality_name_by_quality( quality )
	if quality == 1 then
		return "[普通]";
	elseif quality == 2 then
		return "[优秀]";
	elseif quality == 3 then
		return "[精良]"
	elseif quality == 4 then
		return "[完美]"
	elseif quality == 5 then
		return "[神圣]"
	elseif quality == 6 then
		return "[混沌]"
	elseif quality == 7 then
		return "[太虚]"
	end
end

--取得道具使用条件
function ItemConfig:get_conds_info( item_id )
	local item = load_item_config( item_id )
	if item == nil then
		print("There is not this item: " .. item_id)
	end
	return item.conds;	
end

--是否可以批量使用
function ItemConfig:is_batch_use_item( item_id )
	local _t_batch_item =
	{
		[ItemConfig.ITEM_ID_ZHAO_CAI_SHEN_FU] = true,	--招财神符
		--[45265] = true,									--大富翁环游礼包
	}

	if _t_batch_item[item_id] then
		return true
	else
		return false
	end
end