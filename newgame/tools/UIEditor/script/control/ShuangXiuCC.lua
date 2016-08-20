-- ShuangXiuCC.lua
-- create by hcl on 2013-2-16
-- 宠物系统

-- super_class.ShuangXiuCC()
ShuangXiuCC = {}

-- 17,1:开始停止打坐,注意:普通打坐才调用这个接口 0 停止，1开始
function ShuangXiuCC:req_start_normal_dazuo( is_start, dazuo_style )
	local pack = NetManager:get_socket():alloc(17,1);
	pack:writeByte(is_start);
	pack:writeByte(dazuo_style);
	NetManager:get_socket():SendToSrv(pack);
end

-- 17,1:服务器返回打坐状态变更
function ShuangXiuCC:do_start_normal_dazuo(pack)
	local dazuo_state = pack:readByte();   -- 0表示没有在打坐1表示普通打坐，2表示双修
	local time 		  = pack:readInt();
	-- 开始打坐
	if ( dazuo_state == 0 ) then
		
	elseif ( dazuo_state == 1 ) then

	elseif ( dazuo_state == 2 ) then	
		-- 关闭双修窗口
		UIManager:hide_window("xunrenshuangxiu_win");
		UIManager:hide_window("yqsx_win");
	end
end

-- 17,2:邀请双修 邀请别人
function ShuangXiuCC:req_shuangxiu( other_player_name , dazuo_style )
	print("邀请别人双修.........................")
	local pack = NetManager:get_socket():alloc(17,2);
	pack:writeString(other_player_name);
	pack:writeByte(dazuo_style);
	NetManager:get_socket():SendToSrv(pack);
end

-- 17,2:服务器下发邀请双修的信息 被邀请
function ShuangXiuCC:do_shuangxiu(pack)
	print("被邀请双修.........................")
	
	-- 接受邀请双修的人的信息
	local struct = ShuangXiuPlayerStruct(pack);
	SXModel:add_invite_shuangxiu_player_table(struct);

	-- 如果当前在打坐才自动同意
	local player = EntityManager:get_player_avatar();
	-- 取得是否自动双修
	if ( SetSystemModel:get_date_value_by_key( SetSystemModel.ACCEPT_COUPLE_ZAZEN_INVITATION ) and ZXLuaUtils:band( player.state, EntityConfig.ACTOR_STATE_ZANZEN) > 0 and ZXLuaUtils:band( player.state, EntityConfig.ACTOR_STATE_COUPLE_ZANZEN) == 0) then
		-- 自动回复同意
		ShuangXiuCC:req_shuangxiu_response( struct.name, 1 );
	else
		local function cb_fun()
			YQSXWin:show();
		end
		-- 飘字，点击显示UI
		MiniBtnWin:show( 10 , cb_fun );
	end

end

-- 17,3:邀请双修的回复 邀请回复
function ShuangXiuCC:req_shuangxiu_response( other_player_name,result )
	print("邀请双修回复.........................")
	local pack = NetManager:get_socket():alloc(17,3);
	pack:writeString(other_player_name);
	pack:writeByte(result);
	NetManager:get_socket():SendToSrv(pack);
end

-- 17,4:请求可以邀请的双修的玩家列表
function ShuangXiuCC:req_can_invite_shuangxiu_players( )
	local pack = NetManager:get_socket():alloc(17,4);
	NetManager:get_socket():SendToSrv(pack);
end

-- 17,4:服务器下发可以邀请的双修的玩家列表
function ShuangXiuCC:do_can_invite_shuangxiu_players(pack)
	local can_invite_player_num = pack:readWord();
	local can_invite_player_table = {};
	for i=1,can_invite_player_num do
		-- 能邀请双修的人的信息
		can_invite_player_table[i] = ShuangXiuPlayerStruct(pack);
	end

	SXModel:set_can_invite_shuangxiu_player_table(can_invite_player_table);
	local win = UIManager:find_visible_window("xunrenshuangxiu_win");
	if ( win ) then
		win:update(1);
	end

end


