-- OperationActivityConfig.lua
-- created by fjh on 2013-8-6
-- 小型面板运营活动配置

OperationActivityConfig = {}


local activity_desc = {"玩家在活动期间内，强化全身装备到达指定的等级，即可领取价值超额的礼包。",
"玩家在活动期间内，宠物成长达到指定的要求，即可领取价值超额的礼包。",
"玩家在活动期间内，法宝等级达到指定的要求，即可领取价值超额的礼包。",
[8] = "玩家在活动期间内，每日登录，即可领取登录礼包，连续登录还可以领取额外的节日礼包",
[12] = "玩家在活动期间内，充值累计达到指定的金额，即可领取超值大礼包",
[14] = "玩家在活动期间内，每日消费达到指定的元宝数，即可领取豪华大礼包。每日消费的元宝数会在第二天0点重新计算。",
};
local activity_cell_desc = {
	LangGameString[282], -- [282]="全身装备强化+%d即可领取"
	LangGameString[283], -- [283]="宠物成长达到%d级即可领取"
	LangGameString[284], -- [284]="法宝等级达到%d级即可领取"
	[8] = LangGameString[285], -- [285]="登录%d天礼包"
	[12] = "充值%s元宝，可领取",
	[14] = "%s",
};
local activity_target = {"全身强化:", "成长等级:","成长等级:",[8] = "登录天数:",[12] = "已充值元宝:",[14] = "今天已消费:"};

-- 国庆登录领奖天数
OperationActivityConfig.guoqing_login_award_day = {2,4,6};
-- 强礼来袭配置
OperationActivityConfig.qianglilaixi_chongzhi_yuanbao = {0,588,1888};

-- 获取强者之路奖励配置
function OperationActivityConfig:get_strong_hero_award_config( index )
	require "../data/newseraward_config"
	if index <= #newseraward_config.Strongroad then
		return newseraward_config.Strongroad[index];
	end

	return nil;
end

-- 获取至强伙伴奖励配置
function OperationActivityConfig:get_power_pet_award_config( index )
	require "../data/newseraward_config"
	if index <= #newseraward_config.Xeonpartner then
		return newseraward_config.Xeonpartner[index];
	end
	return nil;

end

-- 获取至强法宝奖励配置
function OperationActivityConfig:get_power_fabao_award_config( index )
	
	require "../data/newseraward_config"
	if index <= #newseraward_config.Theultimateweapon then
		return newseraward_config.Theultimateweapon[index];
	end
end

-- 获取国庆活动配置
function OperationActivityConfig:get_guoqing_award_config( index )
	
	require "../data/guoqingconf"
	if index <= #guoqingconf+1 then
		if ( index == 1 ) then
			return guoqingconf.dengluAward;
		else
			return guoqingconf[index-1];
		end
	end
end

-- 获取强礼来袭奖励
function OperationActivityConfig:get_qianglilaixi_config( index )
	require "../data/newseraward_config"
	if index <= #newseraward_config.qianglilaixiAward then
		return newseraward_config.qianglilaixiAward[index]
	end
end

-----------------------------
-- 根据活动类型获取活动配置
function OperationActivityConfig:get_config_by_type( type )
	local config = {};
	
	if type == ServerActivityConfig.ACT_TYPE_STRONG_HERO then
		config.title = UIResourcePath.FileLocate.operationAct.."strong_title.png";	
	elseif type == ServerActivityConfig.ACT_TYPE_POWER_PET then
		config.title = UIResourcePath.FileLocate.operationAct.."pet_title.png";
	elseif type == ServerActivityConfig.ACT_TYPE_POWER_FABAO then
		config.title = UIResourcePath.FileLocate.operationAct.."fabao_title.png";
	elseif type == ServerActivityConfig.ACT_TYPE_GUOQING then
		config.title = UIResourcePath.FileLocate.operationAct.."guoqing_t.png";
	elseif type == ServerActivityConfig.ACT_TYPE_QIANGLILAIXI then
		config.title = UIResourcePath.FileLocate.operationAct.."qianglilaixi_title.png";
	elseif type == ServerActivityConfig.ACT_TYPE_MEIRIXIAOFEI then
		config.title = ""
	end

	config.desc = activity_desc[type-10];

	config.target = activity_target[type-10];
	
	return config;	
end
-- 根据活动类型获取子项标题
function OperationActivityConfig:get_cell_title_by_type( type )
	return activity_cell_desc[type-10];
end

-- 根据活动类型获取子项奖励个数
function OperationActivityConfig:get_award_cell_count( type )
	
	
	if type == ServerActivityConfig.ACT_TYPE_STRONG_HERO then
		require "../data/activity_config/newseraward_config"
		return #newseraward_config.Strongroad;
	elseif type == ServerActivityConfig.ACT_TYPE_POWER_PET then
		require "../data/activity_config/newseraward_config"
		return #newseraward_config.Xeonpartner;
	elseif type == ServerActivityConfig.ACT_TYPE_POWER_FABAO then
		require "../data/activity_config/newseraward_config"
		return #newseraward_config.Theultimateweapon;
	elseif type == ServerActivityConfig.ACT_TYPE_GUOQING then
		require "../data/activity_config/guoqingconf"
		-- 登录天数奖励以及每日登录 
		return #guoqingconf + 1;
	elseif type == ServerActivityConfig.ACT_TYPE_QIANGLILAIXI then
		require "../data/activity_config/newseraward_config"
		return #newseraward_config.qianglilaixiAward;
	elseif type == ServerActivityConfig.ACT_TYPE_MEIRIXIAOFEI then
		require "../data/activity_config/newseraward_config"
		return #newseraward_config.meirixiaofeiAward;		
	end
end


function OperationActivityConfig:get_xiaofei_txt_config(type,index)
	if type == ServerActivityConfig.ACT_TYPE_MEIRIXIAOFEI then
		require "../data/activity_config/newseraward_config"
		return newseraward_config.meirixiaofeiAward.xiaofei[index];
	end

	return nil;
end
