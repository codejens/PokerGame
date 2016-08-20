-- FubenCC.lua
-- create by hcl on 2013-1-29
-- 副本系统 20

-- super_class.FubenCC()

FubenCC = {}

--20,1获取今日进入各个模式的副本的剩余次数
function FubenCC:req_get_fuben_enter_count()
	local pack = NetManager:get_socket():alloc(20, 1)
	NetManager:get_socket():SendToSrv(pack)
end

--20,1服务器下发今日进入各个模式的副本的剩余次数
function FubenCC:do_get_fuben_enter_count( pack )
	require "struct/FuBenStruct"
	local info_count = pack:readInt();
	for i=1,info_count do
		FuBenStruct(pack);
	end
end

-- 20,8 请求进入副本
function FubenCC:req_enter_fuben(fuben_id)
	local pack = NetManager:get_socket():alloc(20, 8)
	pack:writeInt(fuben_id)
	NetManager:get_socket():SendToSrv(pack)
end

-- s->c 20,8 第一次进入副本，运行新手指引
function FubenCC:do_first_fuben( pack )
	local fuben_id = pack:readInt()
	FuBenModel:set_first_fuben(fuben_id)
	FuBenModel:handle_first_fuben()
end

-- s->c 20,9 通用副本结算
function FubenCC:do_fuben_result( pack )
	local fuben_result = FuBenResultStruct(pack)
	AIManager:set_state(AIConfig.COMMAND_IDLE)
	local win = UIManager:show_window("fb_result_win")
	if win then
    	win:create_succss_panel(fuben_result)
    end 
end

-- s->c 20,10 下发成功进入副本
function FubenCC:do_success_enter_fuben(pack)
	local fuben_id = pack:readInt()
	UIManager:destroy_window("activity_Win")
	UIManager:destroy_window("fb_exp_win")

	--下发完成关闭页面
	local zhanyifuben = UIManager:find_visible_window("zhanyifuben_win")
	if  zhanyifuben then
		 UIManager:destroy_window("zhanyifuben_win")
	end
end

-- s->c 20,11 下发必杀技副本的副本结算  （已通用副本结算，不单于必杀技）
function FubenCC:do_unique_skill_fuben_result(pack)
	print("下发必杀技副本的副本结算")
	local fuben_result = {}
	fuben_result.player_chest_index = pack:readInt()
	fuben_result.chests_num = pack:readInt()
	fuben_result.chests = {}	-- 保存宝箱结果,第一个就是用户会抽中的
	for i=1,fuben_result.chests_num do
		fuben_result.chests[i] = {}
		fuben_result.chests[i].itemId = pack:readInt()
		fuben_result.chests[i].count = pack:readInt()
		print("第",i,"个物品的id",fuben_result.chests[i].itemId,fuben_result.chests[i].count,fuben_result.player_chest_index)
	end

	fuben_result.grade = pack:readInt()
	fuben_result.fubenId = pack:readInt()
	fuben_result.elapsed_time = pack:readInt()
	fuben_result.exp_grade = pack:readInt()
	fuben_result.exp_base = pack:readInt()		
	fuben_result.exp_addExpItem = pack:readInt()
	fuben_result.items = {}
	local item_num = pack:readInt()
	for i=1,item_num do
		fuben_result.items[i] = {}
		fuben_result.items[i].itemId = pack:readInt()
		fuben_result.items[i].count = pack:readInt()
	end

	-- 预防服务器重复发送副本结算数据。
	-- 一次必杀技结算面板多次展示数据可能会有问题，timer太多了。还是一次次来处理不容易出问题
	local win = UIManager:find_visible_window("us_fb_result_win")
	if win then
		print("服务器乱发数据了！！")
    	return;
    end

	AIManager:set_state(AIConfig.COMMAND_IDLE)

	UniqueSkillFBResultWin:set_is_unique(true)
	local win = UIManager:show_window("us_fb_result_win")
	if win then
		-- win:active(true,true)
    	win:create_succss_panel2(fuben_result)
    end 
end


-- s->c 20,14 下发必杀技副本的副本结算  （已通用副本结算，不单于必杀技）
function FubenCC:do_common_fuben_result(pack)
	print("下发通用的副本结算")
	local fuben_result = {}
	fuben_result.player_chest_index = pack:readInt() --抽到的宝箱子
	fuben_result.chests_num = pack:readInt()    --宝箱数量

	fuben_result.chests = {}	-- 保存宝箱结果,第一个就是用户会抽中的
	for i=1,fuben_result.chests_num do
		fuben_result.chests[i] = {}       --宝箱列表
		fuben_result.chests[i].itemId = pack:readInt()  --道具id
		fuben_result.chests[i].count = pack:readInt()     --数量
	end
   
	fuben_result.grade = pack:readInt() -- 评级
	fuben_result.fubenId = pack:readInt()  --副本ID

	fuben_result.elapsed_time = pack:readInt()  --使用时间

	--实际获取列表 评级获取列表 药物加成获取列表 里面都是key 和value 的形式 对应的类型为：
	--类型为
	-- 0        铜币
	-- 1        银币
	-- 2        礼券
	-- 3        元宝
	-- 11       经验
	-- 12       历练
	fuben_result.real_grade = pack:readInt() --实际获取数量
	fuben_result.real_grade_array={}  --实际获取的列表  列表里为key value 形式  

	for i=1,fuben_result.real_grade do
	fuben_result.real_grade_array[i] = {}       --宝箱列表
	fuben_result.real_grade_array[i].itemId = pack:readInt()  --道具id
	fuben_result.real_grade_array[i].count = pack:readInt()     --数量
	end
   
    --评级列表
	fuben_result.pingji_grade = pack:readInt() --评级获取数量
	fuben_result.pingji_grade_array={}  --评级获取的列表  列表里为key value 形式  
	for i=1,fuben_result.pingji_grade do
	fuben_result.pingji_grade_array[i] = {}       --宝箱列表
	fuben_result.pingji_grade_array[i].itemId = pack:readInt()  --道具id
	fuben_result.pingji_grade_array[i].count = pack:readInt()     --数量
	end

    --药物加成列表
	fuben_result.drug_grade = pack:readInt() --评级获取数量
	fuben_result.drug_grade_array={}  --评级获取的列表  列表里为key value 形式  
	for i=1,fuben_result.drug_grade do
	fuben_result.drug_grade_array[i] = {}       --宝箱列表
	fuben_result.drug_grade_array[i].itemId = pack:readInt()  --道具id
	fuben_result.drug_grade_array[i].count = pack:readInt()     --数量
	end


	-- fuben_result.exp_grade = pack:readInt()   --评级经验
	-- fuben_result.exp_base = pack:readInt()		--杀怪获得经验
	-- fuben_result.exp_addExpItem = pack:readInt()  --经验丹加成经验
	fuben_result.items = {}  
	local item_num = pack:readInt()  --获得宝箱个数
	for i=1,item_num do
		fuben_result.items[i] = {}
		fuben_result.items[i].itemId = pack:readInt()  --获得物品明细
		fuben_result.items[i].count = pack:readInt()
	end

	-- 预防服务器重复发送副本结算数据。
	-- 一次必杀技结算面板多次展示数据可能会有问题，timer太多了。还是一次次来处理不容易出问题
	local win = UIManager:find_visible_window("us_fb_result_win")
	if win then
		print("服务器乱发数据了！！")
    	return;
    end

	AIManager:set_state(AIConfig.COMMAND_IDLE)

		UniqueSkillFBResultWin:set_is_unique(false)
	local win = UIManager:show_window("us_fb_result_win")
	if win then
		-- win:active(true,true)
    	win:create_succss_panel2(fuben_result)
    end 

	-- local win = UIManager:show_window("us_fb_result_win")
	-- if win then
	-- 	win:active(true,false)
	-- 	for k,v in pairs(fuben_result) do
	-- 		print(k,v)
	-- 	end
 --    	-- win:create_succss_panel(fuben_result)
 --    	win:create_succss_panel2(fuben_result)
 --    end 
end


-- s->c 20,12 下发必杀技副本的统计面板的经验
function FubenCC:do_bishaji_fuben_tongji_exp(pack)
	local exp = pack:readInt()
	local fb_id = SceneManager:get_cur_fuben();
	-- 目前必杀技副本id是11
	if fb_id == 11 then
		FubenTongjiModel:do_bishaji_fuben_exp(exp);
	end
end


--20 13
-- 天降雄狮新协议 下发物品飞到统计面板
function  FubenCC:do_play_get_item_effect(pack)
	local item_type = pack:readChar();   --飘到统计面板的类型  1. 为角色属性类型，如金钱、历练、经验等   2. 为怪物掉落的物品
	local item_id = pack:readInt();
-- 	对应于第一个字段为1时
-- ----qatEquipment=0,             //物品或者装备----
-- 		qatXiuwei = 1,	            //修为
-- 		qatExp = 2,                	//角色经验值
-- 		qatGuildContribution = 3,	//帮派贡献值
-- 		qatZYContribution = 4,		//阵营贡献
-- 		qatBindMoney = 5,           //绑定银两
-- 		qatMoney = 6,	            //银两
-- 		qatLiJin = 7,	            //绑定元宝
-- 		qatTitle = 8,	            //称谓
-- 		qatSkill = 9,	            //技能-----
-- 		qatZhanhun = 10,	        //战魂
-- 		qatAchievePoint =11,        //成就点
-- 		qatRenown=12,                //历练
-- 	--qatCustomize = 127,		    //自定义奖励


-- 对应于第一个字段为2时
-- 物品ID

   local  item_num = pack:readInt()  --规定第二个字段的数量值
 
   print("item_type",item_type)
   print("item_id",item_id)
   print("item_num",item_num)
   local item_info_table = {}

   --物品飞到统计面板
   LuaEffectManager:play_get_items_effect2(item_type,item_id,item_num)
end

