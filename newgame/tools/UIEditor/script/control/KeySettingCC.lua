-- KeySettingCC.lua
-- created by hcl on 2013-4-23
-- 快捷键系统 134


KeySettingCC = {}

-- 请求服务器设置一个快捷键
function KeySettingCC:req_set_a_key( key_index,key_value,key_type )
	print("c->s: 134, 1.................KeySettingCC:req_set_a_key(  )")
	local pack = NetManager:get_socket():alloc(134, 1)
	pack:writeByte( key_index );
	pack:writeByte( key_type );
	pack:writeWord( key_value );
	NetManager:get_socket():SendToSrv(pack)
end

-- 返回结果
function KeySettingCC:do_set_a_key( pack )
	--print(".................KeySettingCC:do_set_a_key(  )")
	print("s->c : 134, 1")
	local result = pack:readByte();
	-- 技能面板技能处理
	if result then
		-- local win = UIManager:find_visible_window( "user_skill_win" )
		-- local curSceneId = SceneManager:get_cur_scene()
		-- if win then
			KeySettingCC:req_get_key_setting()
		-- end
	end
end

-- 客户端请求快捷键设置
function KeySettingCC:req_get_key_setting( )
	print("c->s:134, 2 .................KeySettingCC:req_get_key_setting(  )")
	local pack = NetManager:get_socket():alloc(134, 2)
	NetManager:get_socket():SendToSrv(pack)

end

-- 服务端返回快捷键设置数据
function KeySettingCC:do_get_key_setting( pack )
	print("s->c:134,2 , ----do_get_key_setting ")
	local num = pack:readByte();
	local keyStruct_table = {};
	for i=1,num do
		keyStruct_table[i] = KeyStruct(pack);
	end
	KeyModel:set_key_table( keyStruct_table );
	-- 当返回快捷键数据以后，要通知主界面去更新技能面板
	-- 更新主界面技能按钮
	local win = UIManager:find_visible_window("menus_panel");
	local skill_win = UIManager:find_visible_window( "user_skill_win" ) -- 技能面板
	if ( num == 0 ) then
		local skill_table = UserSkillModel:get_skill_list(  );
		if ( win ) then
			win:set_btn_skill_by_index( 1 ,skill_table[1].id);
		end
		if ( skill_win ) then  -- 技能面板
			skill_win:set_btn_skill_by_index( 1 ,skill_table[1].id);
		end
	else
		if ( win ) then
			for i=1,num do
				-- 1技能2物品
				if ( keyStruct_table[i].key_type == 1 and keyStruct_table[i].key_value~= 0 ) then
					win:set_btn_skill_by_index(keyStruct_table[i].key_index,keyStruct_table[i].key_value);
				end
			end
			-- local curSceneId = SceneManager:get_cur_scene()
			-- if curSceneId == 27 then
			-- 	for i=num+1,4 do
			-- 		win:set_btn_empty(i);
			-- 	end
			-- end
		end
		if ( skill_win ) then -- 技能面板
			for i=1, num do     -- 4个目前技能键
				-- 1技能2物品
				if ( keyStruct_table[i].key_type == 1 and keyStruct_table[i].key_value~= 0 ) then
					skill_win:set_btn_skill_by_index(keyStruct_table[i].key_index,keyStruct_table[i].key_value);
				end
			end
		end
	end
end
