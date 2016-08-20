-- PetCC.lua
-- create by hcl on 2012-12-10
-- 宠物系统

-- super_class.PetCC()
PetCC = {}

-- 获取现有的宠物列表 1
function PetCC:req_get_pet_list()
	--print("----req_get_pet_list----");
	local pack = NetManager:get_socket():alloc(34,1);
	NetManager:get_socket():SendToSrv(pack);
end

function PetCC:req_get_pet_list_from_dummy_server()
	local pack = NetManager:get_socket():alloc(34, 1)
	NetManager.SendToDummyServer(pack)
end

-- 服务器返回获取现有的宠物列表
function PetCC:do_get_pet_list(pack, is_client)
	local curSceneId = SceneManager:get_cur_scene()
	-- if curSceneId == 27 and not is_client then
	-- 	return
	-- end
	-- 宠物栏的大小
	local pet_max_num = pack:readInt();
	-- 宠物的数量
	local pet_curr_num = pack:readInt();

	--print("pet_max_num = "..pet_max_num.."pet_curr_num"..pet_curr_num);
	
	local tab_pet_info = {};
	-- 宠物的信息array
	require "struct/PetStruct"
	for i = 1,pet_curr_num do
		tab_pet_info[i] = PetStruct(pack);
	end
	require "model/PetModel"
	PetModel:init_data(pet_max_num,pet_curr_num,tab_pet_info);


end

-- 宠物出战或回收 2
-- c->s 34,2
function PetCC:req_fight(pet_id,do_type)
	local pack = NetManager:get_socket():alloc(34,2);
	pack:writeInt(pet_id);
	pack:writeInt(do_type);
	NetManager:get_socket():SendToSrv(pack);
end

-- 宠物出战或回收结果
-- s->c 34,2
function PetCC:do_fight(pack)

	-- 宠物的id
	local pet_id = pack:readInt();			-- 宠物的id
	local pet_do_type = pack:readInt();		-- 0回收，1出战
	local result = pack:readInt(); 			-- 结果 0 成功 ,1代表失败
	
	-- 如果成功
	if(result == 0) then 
	--	print("PetCC:do_fight",pet_id,pet_do_type,result);
		PetModel:set_current_pet_id(pet_id);
		-- 回收则当前宠物休息，出战则当前宠物出战
		if (pet_do_type == 0) then
			PetModel:set_current_pet_is_fight(false);
		else
			PetModel:set_current_pet_is_fight(true);
		end
		local win = UIManager:find_visible_window( "pet_win")
		if ( win ) then
			win:cb_fight(result,pet_do_type,pet_id);
		end
	end

end

-- 删除宠物 3
function PetCC:req_delete_pet(pet_id)
	local pack = NetManager:get_socket():alloc(34,3);
	pack:writeInt(pet_id);
	NetManager:get_socket():SendToSrv(pack);
end

-- 删除宠物结果
function PetCC:do_delete_pet(pack)
	local pet_id = pack:readInt();	--	宠物id
	local pet_index = PetModel:get_index_by_pet_id( pet_id );
    -- 删除宠物数据
    PetModel:delete_pet_info_by_pet_id( pet_id )
	-- 更新宠物界面
	local win = UIManager:find_window("pet_win");
	if ( win ) then
		win:update(3,{pet_id,pet_index});
	end
--	print("pet_id = ",pet_id, PetModel:get_current_pet_id())
	-- 更新主界面
	if ( pet_id == PetModel:get_current_pet_id() or PetModel:get_current_pet_id() == 0 ) then
--		print("删除宠物......")
		local win = UIManager:find_visible_window("user_panel")
		if ( win ) then
			win:delete_pet(  );
		end
	end

end

-- 改变宠物的名字 4
function PetCC:req_change_pet_name(pet_id,pet_name)
	print("PetCC:req_change_pet_name pet_name", pet_name)
	local pack = NetManager:get_socket():alloc(34,4);
	pack:writeInt(pet_id);
	pack:writeString(pet_name);
	NetManager:get_socket():SendToSrv(pack);
end

-- 改变宠物名字结果
function PetCC:do_change_pet_name(pack)
	local pet_id 		= pack:readInt();	--	宠物id
	local result		= pack:readInt();	--  结果，0成功，1失败，如果失败，后面的名字不用读
	if(result == 0) then
		local pet_new_name = pack:readString();		--	宠物的新名字 
		print("PetCC:do_change_pet_name pet_new_name",pet_new_name)
		--print("pet_new_name = ",pet_new_name);
		local win = UIManager:find_window("pet_win");
		if ( win ) then
			win:update(4,{pet_id,pet_new_name});
		end
		-- if ( pet_id == PetModel:get_current_pet_id() ) then
		-- 	local win = UIManager:find_window("user_panel");
		-- 	if ( win ) then
		-- 		win:update_pet(5,{pet_new_name});
		-- 	end
		-- end
	end	
end

-- 修改宠物的战斗类型 5
function PetCC:req_change_pet_fight_type(pet_id,fight_type)
	-- 如果玩家是在新手体验副本中,点击宠物头像的,则不向服务器发送消息
	-- local curSceneId = SceneManager:get_cur_scene()
	-- if curSceneId == 27 then
	-- 	local win = UIManager:find_visible_window("user_panel");
	-- 	if win then
	-- 		-- 更新宠物战斗类型
	-- 		fight_type = (fight_type >= 1 and fight_type <= 3) and fight_type or 1
	-- 		win:set_pet_fight_type( fight_type )
	-- 		PetAI:set_fight_type( fight_type )
	-- 	end
	-- 	return
	-- end

	local pack = NetManager:get_socket():alloc(34,5);
	pack:writeInt(pet_id);		
	pack:writeInt(fight_type); 				-- 战斗类型 防御型1，主动型2,跟随型3
	NetManager:get_socket():SendToSrv(pack);
end

-- 修改宠物的战斗类型结果
function PetCC:do_change_pet_attr(pack)

	local pet_id = pack:readInt();				--	宠物id
	local pet_change_attr_num = pack:readInt();	--	变化的属性个数
	--print("-------------PetCC:do_change_pet_attr------------- pet_id = " .. pet_id);
	-- 根据宠物id取得对应的宠物数据
	local pet_struct = PetModel:get_struct_by_id(pet_id);

	-- 测试用
	local test_str = "";
	local first_attr_id = -1;

	local is_curr_pet = false;
	if ( pet_id == PetModel:get_current_pet_id() ) then
		is_curr_pet = true;
	end

	-- 先更新数据
	-- 第一次读是属性id,第二次读是属性值
	for i=1,pet_change_attr_num do
		-- attr_id 从0开始
		local attr_id = pack:readInt();
		local attr_value = pack:readInt();

		if (i == 1) then
			first_attr_id = attr_id;
		end
		-- 更新数据
		pet_struct:change_pet_attr( attr_id+1,attr_value,PetModel:get_pet_win_is_open(),is_curr_pet );

		--test_str = test_str .. attr_id .. " = " .. attr_value .. "   ";
	end
	--print(test_str .. "\n");

end


-- 扩展宠物栏 6
function PetCC:req_add_pet_max_num(moneyType)
	local pack = NetManager:get_socket():alloc(34,6);
	NetManager:get_socket():SendToSrv(pack);
end

-- 扩展宠物栏结果
function PetCC:do_add_pet_max_num(pack)
	local result		= pack:readInt();	-- 0成功,1失败
	if ( result == 0 ) then
		local new_max_num	= pack:readInt();	-- 新的大小
		require "UI/pet/PetWin"
		PetWin:update(6,{new_max_num});
		PetModel:update_pet_num( new_max_num )
	end
	
end

-- 增加一个宠物结果 7
function PetCC:do_add_new_pet(pack)
	--print("PetCC:增加一个宠物");
	local pet_from = pack:readInt();	--	获得宠物的来源,1:宠物蛋,2:系统开启直接获得
	-- 当前宠物数量增加一
	local pet_info = PetModel:get_pet_info(); 
	pet_info.curr_num = pet_info.curr_num + 1;
	require "struct/PetStruct"
	local pet_struct = PetStruct(pack);
	pet_info.tab[#pet_info.tab + 1] = pet_struct;

	if ( pet_from == 1 ) then
		-- 打开宠物开蛋界面
		PetOpenEggWin:show( pet_struct )
		-- 更新宠物界面
		local win = UIManager:find_window("pet_win");
		if ( win ) then
			win:left_pet_panel_add_pet(pet_info.curr_num,pet_struct);
		end
	end
	

end

-- 延寿，玩耍，喂食操作 8 
function PetCC:req_add_live_play_feed(pet_id,type)
	local pack = NetManager:get_socket():alloc(34,8);
	pack:writeInt(pet_id);
	pack:writeInt(type);
	NetManager:get_socket():SendToSrv(pack);
	--print("req_add_live_play_feed: pet_id = " .. pet_id);
end

-- 使用宠物存储血量,9
function PetCC:req_use_pet_hp_bottle(pet_id)
	local pack = NetManager:get_socket():alloc(34,9);
	pack:writeInt(pet_id);
	NetManager:get_socket():SendToSrv(pack);
end

function PetCC:do_use_pet_hp_bottle(pack)
	local pet_id = pack:readInt();	--	宠物id
	local result = pack:readInt();	-- 0 成功,1失败
	if ( result == 1) then
		print("使用宠物血包失败");
	end
end

-- c->s 提悟性 (34,10)
function PetCC:req_add_wu(pet_id,isUseShield,AutoBuy, moneyType)
	print("PetCC:req_add_wu(pet_id,isUseShield,AutoBuy,moneyType)",pet_id,isUseShield,AutoBuy,moneyType)
	local pack  = NetManager:get_socket():alloc(34,10);
	pack:writeInt(pet_id);
	pack:writeInt(isUseShield);				-- 是否使用保护符 0:不需要,1:需要
	pack:writeChar(AutoBuy);
	pack:writeByte(moneyType)
	NetManager:get_socket():SendToSrv(pack);
end

-- c-> 提成长 (34,11)
function PetCC:req_add_grow_up(pet_id,isUseShield,AutoBuy ,moneyType)
	print(" grow_up AutoBuy=",AutoBuy)
	local pack = NetManager:get_socket():alloc(34,11);
	pack:writeInt(pet_id);
	pack:writeInt(isUseShield);
	pack:writeChar(AutoBuy);
	pack:writeByte(moneyType)
	NetManager:get_socket():SendToSrv(pack);
end

-- 12 转换攻击类型(法术或物理)，结果会作为属性下发 
function PetCC:req_attack_type(pet_id)
	local pack = NetManager:get_socket():alloc(34,12);
	pack:writeInt(pet_id);
	NetManager:get_socket():SendToSrv(pack);
end

-- 融合 13
function PetCC:req_merge(pet_id,pet_id2)
	print("req_merge")
	local pack = NetManager:get_socket():alloc(34,13);
	pack:writeInt(pet_id);
	pack:writeInt(pet_id2);
	NetManager:get_socket():SendToSrv(pack);
end

-- 融合结果
function PetCC:do_merge(pack)
	local result = pack:readInt(); -- 0 成功 1,失败
	if ( result == 0) then
		local win = UIManager:find_visible_window("pet_win");
		if ( win ) then
			win:update(13);
		end
	end

end

-- 学习技能14
function PetCC:req_study_skill(pet_id,skill_index)
	local pack = NetManager:get_socket():alloc(34,14);
	pack:writeInt(pet_id);
	pack:writeInt64(skill_index);
	NetManager:get_socket():SendToSrv(pack);
end

-- 学习技能结果
function PetCC:do_study_skill( pack )
	--print("PetCC:do_study_skill")
	local pet_id  =	pack:readInt();
	local skill_id = pack:readInt();	-- 技能id
	local skill_level = pack:readInt();	-- 技能等级
	local win = UIManager:find_visible_window("pet_win");
		if ( win ) then
		win:update(14,{pet_id,skill_id,skill_level});
	end

end

-- 遗忘技能 15
function PetCC:req_forget_Skill(pet_id,skill_id)
	local pack = NetManager:get_socket():alloc(34,15);
	pack:writeInt(pet_id);
	pack:writeInt(skill_id);
	NetManager:get_socket():SendToSrv(pack);
end

-- 遗忘技能结果
function PetCC:do_forget_skill( pack )
	local pet_id  =	pack:readInt();
	local skill_id = pack:readInt();	-- 技能id
	local win = UIManager:find_visible_window("pet_win");
	if ( win ) then
		win:update(15);
	end
end

-- 宠物死亡 16
function PetCC:do_pet_dead(pack)
	local pet_id = pack:readInt();
end

-- 技能刻印 17
function PetCC:req_skill_keyin(pet_id,skill_id)
	--print("PetCC:req_skill_keyin   pet_id = " .. pet_id .. "  skill_id = " .. skill_id );
	local pack = NetManager:get_socket():alloc(34,17);
	pack:writeInt(pet_id);
	pack:writeInt(skill_id);
	NetManager:get_socket():SendToSrv(pack);
end

-- 技能刻印结果 17
function PetCC:do_skill_keyin( pack )
	--print("PetCC:do_skill_keyin");
	local pet_id  =	pack:readInt();
	local skill_id = pack:readInt();	-- 技能id
	local win = UIManager:find_visible_window("pet_win");
		if ( win ) then
		win:update(17,{pet_id,skill_id});
	end
end

-- 技能移到仓库结果 18
function PetCC:do_skill_move_store(pack)
	--print("PetCC:do_skill_move_store");	

	local pet_id = pack:readInt();
	local skill_id = pack:readInt();
	local item_index = pack:readInt64();

	local win = UIManager:find_visible_window("pet_win");
	if ( win ) then
		win:update(18,{pet_id,item_index});
	end
	
end

-- 技能从仓库移出 19
function PetCC:req_remove_skill_form_store(skill_index,pet_id)
	--print("PetCC:req_remove_skill_form_store");
	local pack = NetManager:get_socket():alloc(34,19);
	pack:writeInt64(skill_index);
	pack:writeInt(pet_id);
	NetManager:get_socket():SendToSrv(pack);
end

-- 技能从仓库移出结果 19
function PetCC:do_remove_skill_form_store( pack )
	--print("PetCC:do_remove_skill_form_store");
	local index = pack:readInt64();		-- 序列号
	local pet_id  =	pack:readInt();		-- 移到的宠物id
	local win = UIManager:find_visible_window("pet_win");
	if ( win ) then
		win:update(19);
	end
end

-- 请求仓库技能列表 20
function PetCC:req_store_skill_list()
	--print("PetCC:req_store_skill_list");
	local pack = NetManager:get_socket():alloc(34,20);
	NetManager:get_socket():SendToSrv(pack);
end

-- 请求仓库技能列表结果20
function PetCC:do_store_skill_list(pack)
	--print("PetCC:do_store_skill_list");
	local store_skill_num = pack:readInt();
	--print("PetCC:store_skill_num = " .. store_skill_num);
	require "struct/PetStoreSkillStruct"
	local tab = {}
	for i=1,store_skill_num do
		tab[i] = PetStoreSkillStruct(pack);
	end
	require "model/PetModel"
	PetModel:set_pet_skill_store(tab);
end

-- 刷新唤魂玉或获取唤魂玉的数据 21
function PetCC:req_get_huan_hun_yu_info(item_index,_type,money_type)
	local pack = NetManager:get_socket():alloc(34,21);
	pack:writeInt64(item_index);
	--print("series = " .. item_index );
	pack:writeInt(_type);		-- 类型，1：单次刷，2：批量刷（9次）3,获取数据，显示用
	if (_type ~=3)then
		pack:writeInt(money_type);	-- 消耗货币类型，1：元宝，2：绑定元宝，只有刷新才发这个字段
	end
	NetManager:get_socket():SendToSrv(pack);
end

-- 刷新唤魂玉或获取唤魂玉的数据结果
function PetCC:do_get_huan_hun_yu_info(pack)
	local item_index = pack:readInt64();
	local time	= pack:readInt();
	--print("series = " .. item_index .. "time = " .. time);
	local item_num = pack:readInt();
	-- array 每个格子刷出来的技能书id
	local tab = {};
	for i=1,item_num do
		local index = pack:readInt();
		local skill_item_id = pack:readInt();
		tab[i] = {}
		tab[i].index         = index
		tab[i].skill_item_id = skill_item_id;
	end
	-- 刷新宠物界面 打开窗口并且是单次才刷新
	-- local petWin = UIManager:find_visible_window("pet_win")
	-- if petWin then
	-- 	if item_num > 0 and tab[1].skill_item_id ~= 0 then
	-- 		petWin:cb_refresh_skill(tab[1].skill_item_id)
	-- 	else
	-- 		petWin:cb_refresh_skill(0)
	-- 	end
	-- end
	-- 刷新苏醒界面 打开窗口才刷新
	local suXingWin = UIManager:find_visible_window("suxing_win")
	if suXingWin then
		suXingWin:cb_refresh(item_index, time ,item_num,tab)
	end
end

-- 苏醒技能 23
function PetCC:req_wake_skill( item_index,index )
	-- print("============PetCC:req_wake_skill");
	local pack = NetManager:get_socket():alloc(34,23);
	pack:writeInt64(item_index);	-- 物品序列号
	pack:writeInt(index);		-- 顺序号，0表示单次刷新的那个格子，1-9表示批量刷新的
	NetManager:get_socket():SendToSrv(pack);
end

-- 苏醒技能 结果
-- 坑！！原来这个协议早没服务器下发了！！移步ItemModel:pet_update_on_item_delete
function PetCC:do_wake_skill(pack)
	local item_index = pack:readInt64();	--物品序列号
	local result = pack:readInt();	--0成功，1失败
	-- if result == 0 then
		-- local petWin = UIManager:find_visible_window("pet_win")
		-- if petWin then
		-- 	petWin:cb_refresh_skill(0)
		-- end
		-- local suXingWin = UIManager:find_visible_window("suxing_win")
		-- if suXingWin then
		-- 	suXingWin:clear_refresh()
		-- 	UIManager:hide_window("suxing_win")
		-- 	UIManager:show_window("pet_win")
		-- end
	-- end
	-- print("===============PetCC:do_wake_skill(pack)",result);
	if ( result == 0 ) then
		-- local suXingWin = UIManager:find_visible_window("suxing_win")
		-- if suXingWin then
		-- 	suXingWin:clear_refresh()
		-- end

		local win = UIManager:find_visible_window("pet_win");
		if ( win == nil ) then
			UIManager:hide_window("suxing_win");

			local page_index = PetModel:get_cur_page_index(); -- 创建宠物窗口后，页数会被重置，所以先保存一下
			win = UIManager:show_window("pet_win");
			win:change_pet_index(PetModel:get_cur_pet_index())
			win:goto_page(page_index)
			win:update(23,{item_index});
		end
	end
end

-- 24 出战的宠物选择一个实体作为目标，用于技能攻击
function PetCC:req_pet_target(handle)
	local pack = NetManager:get_socket():alloc(34,24);
	pack:writeInt64(handle);	-- 实体handle
	NetManager:get_socket():SendToSrv(pack);
end

-- 25 使用技能
function PetCC:req_use_skill(skill_id,target,target_x,target_y,direction)
	local pack = NetManager:get_socket():alloc(34,25);
	pack:writeWord(skill_id);	-- 技能id
	pack:writeInt64(target);	-- 目标的handle
	pack:writeWord(target_x);	--	目标的x
	pack:writeWord(target_y);	-- 目标的y
	pack:writeByte(direction);	-- 我的面向
	NetManager:get_socket():SendToSrv(pack);
end

-- 使用假技能
function PetCC:req_use_dummy_skill(skill_id, target)
	local entity = EntityManager:get_entity(target)
    local dummy  = NewerCampModel:GetDummyControlObj()
    local process= NewerCampModel:get_curr_progress()
    -- 怪物掉血、添加主角释放技能的特效
    if entity and dummy then
        dummy:processMonsterDamage(entity, 1, skill_id, process)
    end
end

-- 使用技能（包括肉搏) 结果
function PetCC:do_use_skill(pack)
	local skill_id = pack:readInt();	-- 技能id，0表示肉搏
	local result	= pack:readInt();	--0成功，1失败
	local cd		= pack:readInt();	-- cd时间，通常失败都是因为cd，所以这里直接下发cd时间
	--print("skill_id,result,cd = ",skill_id,result,cd);
	-- 设置宠物技能cd
	if ( result == 0 ) then 
		local pet = EntityManager:get_player_pet();
		-- 如果宠物还存在
		if ( pet ) then 
			pet:set_skill_cd( skill_id,cd );
		end
	end
end

-- 26 使用肉搏攻击，结果会以25协议返回
function PetCC:req_attack(target_handle,action_id,effect_id)
	local pack = NetManager:get_socket():alloc(34,26);
	pack:writeInt64(target_handle);	-- 目标的handle
	pack:writeByte(effect_id);	-- 特效的id
	pack:writeWord(action_id);	-- 动作的id
	NetManager:get_socket():SendToSrv(pack);
end

-- 27 宠物强行回收，并有5秒的cd
function PetCC:do_recover_pet(pack)
	print("PetCC:do_recover_pet(pack)..............")
	local pet_id = pack:readInt();
	PetModel:set_current_pet_is_fight(false)
	local win = UIManager:find_visible_window("user_panel")
	if win then
		win:play_pet_cd_animation( 8 )
	end 
	
end

-- 28 获取其他玩家的宠物信息
function PetCC:req_get_other_pet_info( handle,user_id,pet_add_id )
	local pack = NetManager:get_socket():alloc(34,28);
	pack:writeInt64( handle );	-- 怪物的handle
	pack:writeInt( user_id );	--  玩家的id
	pack:writeInt( pet_add_id );	-- 宠物自增的id
	NetManager:get_socket():SendToSrv(pack);
end

-- 28 获取其他玩家的宠物信息 结果
function PetCC:do_get_other_pet_info(pack)
	local pet_struct = PetStruct(pack);
	PetShowWin:show( pet_struct );
end

-- 29 发送当前宠物id
function PetCC:do_send_current_pet_id(pack)
	local pet_id  = pack:readInt();	-- 宠物自增的id
--	require "model/PetModel"
	PetModel:set_current_pet_id(pet_id);
	-- print("PetCC:发送当前宠物id= "..pet_id);
	-- 更新主界面宠物信息
--	require "UI/main/UserPanel"
	local win = UIManager:find_window("user_panel")
	win:update(3);
end

-- s -> c(34,30)服务器提示悟性或成长提升失败
-- function PetCC:do_wx_or_cz_fail( pack )
-- 	local wx_or_cz = pack:readInt();
-- 	print("PetCC:do_wx_or_cz_fail(wx_or_cz)",wx_or_cz)
-- end