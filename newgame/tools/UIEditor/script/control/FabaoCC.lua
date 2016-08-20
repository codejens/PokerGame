-- FabaoCC.lua
-- create by fjh on 2013-5-20
-- 法宝系统

FabaoCC = {}
	
--获取使用中的器魂信息
-- c->s 33,1
function FabaoCC:req_used_xianhun_info(  )
	local pack = NetManager:get_socket():alloc(33, 1)
	NetManager:get_socket():SendToSrv(pack)
end
-- s->c 33,1
function FabaoCC:do_used_xianhun_info( pack )
	-- print("======== FabaoCC:do_used_xianhun_info( pack )====== 33 1 法宝器魂")
	--开启的槽位
	local open_count = pack:readInt();
	local count = pack:readInt();
	local xianhun_dict = {};
	for i=1,count do
		--器魂id
		local xianhun_id = pack:readInt();
		--器魂种类
		local xianhun_type = pack:readByte();
		--器魂品质
		local xianhun_quality = pack:readByte();
		--器魂等级
		local xianhun_level = pack:readByte();
		--器魂灵力值
		local xianhun_value = pack:readInt();

		xianhun_dict[i] = {id = xianhun_id, type = xianhun_type, quality = xianhun_quality,
							 level = xianhun_level, value = xianhun_value};
							 
	end

    --设置器魂数据列表
	FabaoModel:set_fabao_xianhun( open_count, xianhun_dict );

    --返回后的操作
	FabaoModel:do_fabao_xianhun_info();
	
end


--获取玩家的法宝信息
-- c->s 33,2
function FabaoCC:req_fabao_info(  )
	local pack = NetManager:get_socket():alloc(33, 2)
	NetManager:get_socket():SendToSrv(pack)
end

--s->c 33,2
function FabaoCC:do_fabao_info( pack )
	-- 法宝境界
	local fabao_jingjie = pack:readInt();
	-- 法宝等级
	local fabao_level = pack:readInt();
	-- 法宝exp
	local fabao_exp = pack:readInt();
	-- 法宝评分
	local fabeo_fight_value = pack:readInt();

	local fabao_info = {jingjie = fabao_jingjie, level = (fabao_jingjie-1)*10 + fabao_level, exp = fabao_exp, fight = fabeo_fight_value};

	FabaoModel:set_fabao_info( fabao_info );

	FabaoModel:do_fabao_info();

end

--获取猎魂界面的信息
-- c->s 33,4
function FabaoCC:req_liehun_win_info(  )
	-- print("  FabaoCC:req_liehun_win_info(  )  33 4 申请猎魂界面的信息")
	local pack = NetManager:get_socket():alloc(33, 4)
	NetManager:get_socket():SendToSrv(pack)

end
-- s->c 33,3
function FabaoCC:do_liehun_win_info( pack )
	-- print("  FabaoCC:do_liehun_win_info( pack )  33 3 返回猎魂界面的信息")
	--开启的槽位个数
	local open_count = pack:readInt();
	--器魂数量
	local count = pack:readInt();
	-- print("器魂背包里的器魂数量", count,open_count);
	
	local xianhun_dict = {};
	for i=1,count do
		--器魂id
		local xianhun_id = pack:readInt();
		--器魂种类
		local xianhun_type = pack:readByte();
		--器魂品质
		local xianhun_quality = pack:readByte();
		--器魂等级
		local xianhun_level = pack:readByte();
		--器魂灵力值
		local xianhun_value = pack:readInt();

		xianhun_dict[i] = {id = xianhun_id, type = xianhun_type, quality = xianhun_quality,
							 level = xianhun_level, value = xianhun_value};
	end

	-- FabaoModel:set_lianhun_xianhun_list( xianhun_dict );
	FabaoModel:set_lianhun_xianhun_list(open_count,xianhun_dict );
	FabaoModel:do_lianhun_bag_list( xianhun_dict );

end


-- 使用法宝晶石提升法宝, 发送后，服务器通过33,2协议来更新法宝的信息
-- c->s 33,3
-- gem_type:	晶石类型，1=初级晶石, 2=中级晶石, 3=高级晶石
-- used_yb:		是否使用元宝提升
--used_ten      是否使用一键十次
function FabaoCC:req_fabao_uplevel( gem_type, used_yb,used_ten )
	local pack = NetManager:get_socket():alloc(33, 3)
	pack:writeByte(gem_type);
	pack:writeByte(used_yb);
	pack:writeInt(used_ten)
	NetManager:get_socket():SendToSrv(pack)
end


-- 装备上器魂
-- c->s 33,5
function FabaoCC:req_equip_xianhun( xianhun_id )
	local pack = NetManager:get_socket():alloc(33, 5)
	pack:writeInt(xianhun_id);
	NetManager:get_socket():SendToSrv(pack)
end

-- 卸下器魂
-- c->s 33,6
function FabaoCC:req_unequip_xianhun( xianhun_id )
	local pack = NetManager:get_socket():alloc(33, 6)
	pack:writeInt(xianhun_id);
	NetManager:get_socket():SendToSrv(pack)
end

-- 炼魂
-- c->s 33,7  返回  33,4 do_new_lianhunshi
function FabaoCC:req_lianhun( lianhun_id, used_yb )
	-- print("==== FabaoCC:req_lianhun( lianhun_id, used_yb )====")
	local pack = NetManager:get_socket():alloc(33, 7)
	pack:writeInt(lianhun_id);
	pack:writeByte(used_yb);
	NetManager:get_socket():SendToSrv(pack)
end

-- 一键炼魂
-- c->s 33,8
function FabaoCC:req_one_key_lianhun(  )
	local pack = NetManager:get_socket():alloc(33, 8);
	NetManager:get_socket():SendToSrv(pack)
end

-- 点亮新的炼魂师
-- s->c 33,4
function FabaoCC:do_new_lianhunshi( pack )
	-- print("===== = FabaoCC:do_new_lianhunshi( pack ) ======")
	local count = pack:readByte();
	-- 点亮炼魂师的id列表
	local lianhunshi_list = {};
	for i=1,count do
		local id = pack:readByte();
		lianhunshi_list[i] = id;
		-- print("更新魂师列表",id);
	end
	
	FabaoModel:set_lianhunshi_list( lianhunshi_list )
	FabaoModel:do_new_lianhunshi( );
end

-- 一键合成
-- c->s 33,9
function FabaoCC:req_one_key_hecheng( )
	local pack = NetManager:get_socket():alloc(33, 9);
	NetManager:get_socket():SendToSrv(pack)
end

-- 一键合成结果
-- s->c 33,10
function FabaoCC:do_one_key_hecheng( pack )
	local status_code = pack:readInt();
end


-- 开启炼魂界面的器魂槽
-- c->s 33,10
function FabaoCC:req_open_xianhun_slot( open_count )
	local pack = NetManager:get_socket():alloc(33, 10);
	pack:writeInt(open_count);
	NetManager:get_socket():SendToSrv(pack)
end

--开启开启炼魂界面的器魂槽 结果
-- s->c 33,5
function FabaoCC:do_open_xianhun_slot( pack )
	-- 错误码 0=成功，-1=没有足够的元宝
	local status_code = pack:readInt();
	--开启后总共的槽位
	local all_slot_count = pack:readInt();
	FabaoModel:do_open_xianhun_slot(status_code,all_slot_count);
	
end

-- 吞噬器魂
-- c->s 33,11
-- first_from_win: 主动吞噬器魂来自哪个界面,0=法宝界面, 1=猎魂界面
-- second_from_win: 被动吞噬器魂来自哪个界面,同上 
function FabaoCC:req_swallow_xianhun( first_from_win, first_xianhun_id, second_from_win, second_xianhun_id )
	-- print("=== FabaoCC:req_swallow_xianhun( first_from_win, first_xianhun_id, second_from_win, second_xianhun_id )  请求吞噬灵魂-=======")
	local pack = NetManager:get_socket():alloc(33, 11)
	pack:writeByte( first_from_win );
	pack:writeInt( first_xianhun_id );
	pack:writeByte( second_from_win );
	pack:writeInt( second_xianhun_id );
	NetManager:get_socket():SendToSrv(pack)

end

-- 添加器魂
-- s->c 33,6

function FabaoCC:do_add_xianhun( pack )
	
	-- win 目标界面, 0=法宝界面，1=炼魂界面	
	local win = pack:readByte();
	local xianhun_id = pack:readInt();
	local xianhun_type = pack:readByte();
	local xianhun_quality = pack:readByte();
	local xianhun_level = pack:readByte();
	local xianhun_value = pack:readInt();

	local xianhun = {id = xianhun_id, type = xianhun_type, quality = xianhun_quality,
							 level = xianhun_level, value = xianhun_value};
	
	FabaoModel:do_add_xianhun( win, xianhun );

end

-- 删除器魂
-- s->c 33,7
function FabaoCC:do_delete_xianhun( pack )
	-- win 目标界面, 0=法宝界面，1=炼魂界面
	local win = pack:readByte();
	local count = pack:readByte();

	local delete_list = {};
	for i=1,count do
		local delete_xianhun_id = pack:readInt();
		delete_list[i] = delete_xianhun_id;
		-- print("删除器魂list",win,delete_xianhun_id);

	end
	
		--删除器魂
	FabaoModel:do_delete_xianhun( win, delete_list )
	
end

-- 更新器魂
-- s->c 33,8
function FabaoCC:do_update_xianhun_info( pack )
	-- win 目标界面, 0=法宝界面，1=炼魂界面
	local win = pack:readByte();
	local xianhun_id = pack:readInt();
	local xianhun_type = pack:readByte();
	local xianhun_quality = pack:readByte();
	local xianhun_level = pack:readByte();
	local xianhun_value = pack:readInt();

	local xianhun = {id = xianhun_id, type = xianhun_type, quality = xianhun_quality,
							 level = xianhun_level, value = xianhun_value};
	-- print("更新器魂,",xianhun_id,xianhun_level,xianhun_value);

	FabaoModel:update_someone_xianhun( win, xianhun );
end


-- 法宝评分的更新
-- s->c 33,9
function FabaoCC:do_update_fabao_fight( pack )
	
	local fight_value = pack:readInt();

	FabaoModel:do_fabao_fight_value( fight_value )
end

-- 查看他人法宝
-- c->s 33,12
function FabaoCC:req_show_other_fabao_info( target_id, target_name  )
	local pack = NetManager:get_socket():alloc(33, 12)
	
	pack:writeInt( target_id );
	pack:writeString( target_name );

	NetManager:get_socket():SendToSrv(pack)
end
-- s->c 33,11
function FabaoCC:do_show_other_fabao_info( pack )

	-- 是否开启了法宝系统，0=否，1=是
	local is_open_sys = pack:readByte();

	---------------法宝信息
	-- 法宝境界
	local fabao_jingjie = pack:readInt();
	-- 法宝等级
	local fabao_level = pack:readInt();
	-- 法宝exp
	local fabao_exp = pack:readInt();
	-- 法宝评分
	local fabao_fight_value = pack:readInt();

	local fabao = {jingjie = fabao_jingjie, level = fabao_level, exp = fabao_exp, fight = fabao_fight_value};
	----------------已经装备的器魂信息
	--开启的槽位
	local open_count = pack:readInt();

	local count = pack:readInt();
	local xianhun_dict = {};
	for i=1,count do
		--器魂id
		local xianhun_id = pack:readInt();
		--器魂种类
		local xianhun_type = pack:readByte();
		--器魂品质
		local xianhun_quality = pack:readByte();
		--器魂等级
		local xianhun_level = pack:readByte();
		--器魂灵力值
		local xianhun_value = pack:readInt();

		xianhun_dict[i] = {id = xianhun_id, type = xianhun_type, quality = xianhun_quality,
							 level = xianhun_level, value = xianhun_value};
	end
	local xianhun = {count = open_count, xianhuns = xianhun_dict};


	local data = {fabao, xianhun};
    
	local win = UIManager:show_window("lingqi_win");
	if win then 
		win:show_other_fabao(data)
	end

end


-- 获取今天vip用户召唤第四个炼魂师的次数
-- c->s 33，13
function FabaoCC:req_vip_user_call_fourth_lianhunshi_count(  )
	local pack = NetManager:get_socket():alloc(33, 13)
	NetManager:get_socket():SendToSrv(pack)
end
-- s->c 33,13
function FabaoCC:do_vip_user_call_fourth_lianhunshi_count( pack )
	local count = pack:readInt();
	FabaoModel:do_call_yinyang_count( count );
end

-- 返回提升法宝出现的暴击类型
-- s->c 33,14
function FabaoCC:do_show_uplevle_bj_type( pack )

	-- 1=小暴击, 2=中暴击, 3=打暴击
	local type = pack:readInt();
	-- print("fabao 暴击......................................",type)
	-- 播放法宝升级暴击特效
	-- local win = UIManager:find_visible_window("fabao_uplevel_win")
	-- if ( win ) then
	-- 	-- print("win 暴击......................................",type)
	-- 	win:play_cri_animation( type );
	-- end
	local win = UIManager:find_visible_window("lingqi_win")
	if ( win ) then
		-- print("win 暴击......................................",type)
		if win.all_page_t[2] then  --提升页面
		win.all_page_t[2]:play_cri_animation( type );
	    end
	end


end

-- 返回服务器的提示
-- s->c 33,15
function FabaoCC:do_show_message_tips( pack )
	
	-- 0=召唤出更高级的炼魂师
	-- 1=获得xxx器魂
	-- 2=法宝获得N点经验
	-- 3=炼魂空间已满
	-- 4=法宝晶石不足
	local tips_type = pack:readInt();

	local message = pack:readString();

	FabaoModel:do_show_server_message( tips_type, message );

end