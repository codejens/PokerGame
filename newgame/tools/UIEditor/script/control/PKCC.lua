-- PKCC.lua
-- create by hcl on 2013-3-05
-- pk系统

-- super_class.PKCC()
PKCC = {}

--和平模式
--fpPeaceful = 0,
--团队模式
--fpTeam = 1,
--帮派模式
--fpGuild = 2,
--阵营模式
--fpZY =3,
--杀戮模式
--fpPk = 4,

-- 设置玩家的自由pk模式 24 ,3 c->s
function PKCC:req_set_pk_mode( pk_mode )
	print("==========================req_set_pk_mode=================pk_mode = ",pk_mode);
	--print("req_set_pk_mode")
	local pack = NetManager:get_socket():alloc(24,3);
	pack:writeByte( pk_mode );
	NetManager:get_socket():SendToSrv(pack);
end

-- 下发玩家的自由pk模式 24 ,3 s->c
function PKCC:do_set_pk_mode(pack)
	local pk_mode_value = pack:readByte();
	local win = UIManager:find_visible_window("user_panel");
	if ( win ) then
		win:update(9,{ pk_mode_value });
	end
	print("==========================do_set_pk_mode=================pk_mode_value = ",pk_mode_value);
end