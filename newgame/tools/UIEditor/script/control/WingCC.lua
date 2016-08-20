-- filename: WingCC.lua
-- author: created by fanglilian on 2012-12-14.
-- function: 该文件实现翅膀数据模型

-- super_class.WingCC();
WingCC = {}

-- 翅膀子系统cmd=40
local wing_cmd = 40;

-- 40.1 C->S
-- 查看自己或其他人的翅膀信息
-- player_id(int): 玩家ID
-- player_name(string): 玩家名字
function WingCC:req_lookup_info(player_id, player_name)
-- print ("WingCC:req_lookup_info.................player_id: ", player_id, ", player_name: ", player_name);
	local pack = NetManager:get_socket():alloc (40, 1);
	pack:writeInt(player_id);
	pack:writeString(player_name);
	NetManager:get_socket():SendToSrv(pack);
end

-- 40.1 S->C
-- 查看自己或其他人的翅膀信息
function WingCC:do_lookup_info(pack)
	print ("WingCC:do_lookup_info..........................")
	--WingModel:get_wing_item_data()
	local wingItem = WingItem(pack);
	--WingModel:get_wing_item_data()
	-------------modify by HJH 2013-7-15
	-------------wing check other info
	local self_id = EntityManager:get_player_avatar()--.id
	if self_id ~= nil then
		self_id = self_id.id
	end
	print('--------------self_id: ', self_id, wingItem.player_id)
	if self_id ~= wingItem.player_id and self_id ~= nil then
		print("-------------38")
		-- WingSysWin:show_other_wing( wingItem );
		WingModel:setIsShowOtherWing(true)
		WingModel:setOtherWingData(wingItem)
		WingModel:showOtherWing()
	else
		WingModel:set_wing_item_data(wingItem);
	end
end

-- 40.2, C->S
-- 请求升级翅膀
function WingCC:req_upgrade_wing(AutoBuy, money_type)
	-- print (LangGameString[457]) -- [457]="WingCC:req_upgrade_wing..........................请求升级翅膀"
	local pack = NetManager:get_socket():alloc (wing_cmd, 2);
	-- print("~~~~~~~~~~~~~~~~AutoBuy=",AutoBuy)
	pack:writeChar(AutoBuy);  --是否自动购买材料
	pack:writeByte(money_type)
	NetManager:get_socket():SendToSrv(pack);
end

-- 40.2, S->C
-- 升级翅膀结果
function WingCC:do_upgrade_wing(pack)
	print('-- WingCC:do_upgrade_wing --')
	-- 升级结果, 0失败1成功
	local result = pack:readByte();
	if (result == 0) then
		print (LangGameString[458]) -- [458]="WingCC:do_upgrade_wing..........升级翅膀结果，失败！"
	else
		print (LangGameString[459]) -- [459]="WingCC:do_upgrade_wing..........升级翅膀结果，成功！"
	end
	-- 升级后等级	
	local level = pack:readInt();
	-- 升级后祝福值
	local wishes = pack:readInt();
	-- 升级成功，修改翅膀属性
	local wing_item_data = WingModel:get_wing_item_data();
	wing_item_data.level = level;
	wing_item_data.wishes = wishes;
	WingModel:set_wing_item_data(wing_item_data);

	WingModel:do_up_wing_level( result );
	-- WingSysWin:update_tab_btns_tip(false)
end

-- 40.3, C->S
-- 提升阶值
-- wing_id(uint64): 翅膀的guid
function WingCC:req_upgrade_stage(wing_id)
	local pack = NetManager:get_socket():alloc (wing_cmd, 3);
	pack:writeUint64(wing_id);
	NetManager:get_socket():SendToSrv(pack);
end

-- 40.3, S->C
-- 提升阶值
function WingCC:do_upgrade_stage(pack)
	local stage_value = pack:readInt(); 		-- 阶值
	local star_value = pack:readInt();			-- 几星
	WingModel:do_upgrade_stage(stage_value, star_value);
	
	-- local win = UIManager:find_visible_window("wing_jinjie")
	-- if win then 
	-- 	win:update_tab_btns_tip(false)
	-- end
end

-- 40.4, C->S
-- 化形
-- which_stage: 选择的哪个阶的外观
function WingCC:req_hua_xing(which_stage)
	-- print (LangGameString[460]..which_stage); -- [460]="WingCC:req_hua_xing..........选择的哪个阶的外观, which_stage: "
	local pack = NetManager:get_socket():alloc (wing_cmd, 4);
	pack:writeInt(which_stage);
	NetManager:get_socket():SendToSrv(pack);
end

-- 40.4, S->C 
-- 化形结果
function WingCC:do_hua_xing(pack)
	-- 翅膀模型id(失败不返回)
	local modelId = pack:readInt();
	WingModel:set_model_id(modelId);
	WingModel:updateWingRightWin("changeShapeEffect")
end

-- 40.6, S->C
-- 评分
function WingCC:do_assess(pack)
	local assess = pack:readInt();	-- 评分
	WingModel:do_assess( assess );
end

-- 40.5, S->C
-- 属性改变
function WingCC:do_attr_changed(pack)
	-- 4个属性值
	local attack = pack:readInt();		-- 攻击
	local outDefence = pack:readInt();	-- 物防
	local inDefence = pack:readInt();	-- 法防
	local hp = pack:readInt();			-- 生命
	-- TODO
	
end

-- 40.5, C->S
-- 领取翅膀
-- get_type: 领取类型(0普通领取，1元宝领取)
function WingCC:req_get_wing(get_type)
	local pack = NetManager:get_socket():alloc (wing_cmd, 5);
	pack:writeByte(get_type);
	NetManager:get_socket():SendToSrv(pack);
	print('----- WingCC:req_get_wing')
end

-- 40.6, C->S
-- 升级翅膀技能
-- which_skill(int): 升的是哪个技能
function WingCC:req_wing_skill(which_skill,auto_buy, money_type)
	print("which_skill=",which_skill)
	print("auto_buy=",auto_buy)
	local pack = NetManager:get_socket():alloc (wing_cmd, 6);
	pack:writeInt(which_skill);
	pack:writeChar(auto_buy);
	pack:writeByte(money_type)
	NetManager:get_socket():SendToSrv(pack);
end

-- 40.7, S->C
-- 技能等级改变
function WingCC:do_skill_level_changed(pack)
	print("WingCC,40.7, S->C,技能等级改变")
	-- 5个技能等级
	local levels = {};
	local wing_item_data = WingModel:get_wing_item_data();
	local num = WingConfig:getWingSkillNum()
	for i=1, num do
		wing_item_data.skills_level[i] = pack:readInt();
	end
	WingModel:set_wing_item_data(wing_item_data);
	-- WingModel:update_exp_progress()
	WingModel:update_skill_level( );
end

-- 40.8, S->C
-- 技能熟练度改变 
function WingCC:do_skill_exp_changed(pack)
	print("WingCC,40.8, S->C,技能熟练度改变")
	-- 5个熟练度, 对应5个技能
	local skill_exps = {};
	local num = WingConfig:getWingSkillNum()
	for i=1, num do
		skill_exps[i] = pack:readInt();
		-- print("skill_exps",i,"=",skill_exps[i]);
	end
	WingModel:do_skill_exp_changed(skill_exps);
end

-- 40.7, C->S
-- 翅膀转换声望
-- wing_id(uint64): 背包里翅膀的guid
function WingCC:req_wing_to_exp(wing_guid)
	local pack = NetManager:get_socket():alloc (wing_cmd, 7);
	pack:writeUint64(wing_guid);
	NetManager:get_socket():SendToSrv(pack);
end

-- 40.9, S->C
-- 升级翅膀技能结果
function WingCC:do_upgrade_wing_skill(pack)
	print("WingCC,40.9, S->C,升级翅膀技能结果")
	--是否暴击, 0否1是
	local is_attack = pack:readChar();
	-- 增加经验值
	local added_exp = pack:readInt();
	
	WingModel:do_upgrade_wing_skill(is_attack, added_exp);
	
end

-- 40.10, S->C
-- 是否已经领过翅膀
function WingCC:do_has_got_wing(pack)
	-- 1有0无
	local has_got = pack:readChar();  -- 普通领取
	local vipGot = pack:readChar() 		-- 充值领取
	-- 如果has_got为1表示已经领取过翅膀，则启动检测翅膀信息
	if (has_got == 1 or vipGot == 1) then
		local player = EntityManager:get_player_avatar();
		WingCC:req_lookup_info(player.id, player.name);
	else
		-- 否则领取翅膀
--		WingCC:req_get_wing(0);
	end

	WingModel:setGotWingStatus(has_got, vipGot)
	WingModel:updateWingGetWin()
	-- SCLBModel:set_sclb_btn_visible()
end

-- 为PacketDispatcher初始化网络数据处理接口
function WingCC:init_wing_cc()
	local func = {};
	func[1] = WingCC.do_lookup_info;
	func[2] = WingCC.do_upgrade_wing;
	func[3] = WingCC.do_upgrade_stage;
	func[4] = WingCC.do_hua_xing;
	func[5] = WingCC.do_attr_changed;
	func[6] = WingCC.do_assess;
	func[7] = WingCC.do_skill_level_changed;
	func[8] = WingCC.do_skill_exp_changed;
	func[9] = WingCC.do_upgrade_wing_skill;
	func[10] = WingCC.do_has_got_wing;

	return func;
end
