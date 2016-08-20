-- UserEquipCC.lua
-- created by lyl on 2012-12-6
-- 人物装备系统

-- super_class.UserEquipCC()
UserEquipCC = {}

--申请穿上装备
function UserEquipCC:request_equip_one( equi_id)
	local pack = NetManager:get_socket():alloc(7, 1)
	pack:writeUint64(equi_id)
	NetManager:get_socket():SendToSrv(pack)
end

--服务器：通知客户端装备一件物品
function UserEquipCC:do_result_equip_one( pack )
	-- print("UserEquipCC:do_result_equip_one服务器：通知客户端装备一件物品")
	local equi_series = pack:readUint64()
	
	UserInfoModel:get_on_one_equipment( equi_series )
end

--申请脱下装备
function UserEquipCC:request_unequip_by_id( equi_series )
	local pack = NetManager:get_socket():alloc(7, 2)
	pack:writeUint64(equi_series)
	NetManager:get_socket():SendToSrv(pack)
end

--申请脱下指定位置的装备
function UserEquipCC:request_equip_by_place( equi_plac )
	local pack = NetManager:get_socket():alloc(7, 3)
	NetManager:get_socket():SendToSrv(pack)
end

--申请获取玩家身上的装备 
function UserEquipCC:request_get_equi()
	local pack = NetManager:get_socket():alloc(7, 4)
	NetManager:get_socket():SendToSrv(pack)
end

--服务器：下发装备列表
function UserEquipCC:do_result_get_equi( pack )
	-- print("UserEquipCC:do_result_get_equi 服务器：下发装备列表")
	local count     = pack:readByte()
    local equi_data = {} 
	for i = 1, count do
        equi_data[i] = UserItem(pack)
	end
	require "model/UserInfoModel"
	UserInfoModel:set_equi_info( equi_data )
	
end

--服务器：脱下装备
function UserEquipCC:do_result_unequip_by_id( pack )
	print("UserEquipCC:do_result_unequip_by_id 服务器：脱下装备")
	local equi_series = pack:readInt64()
	require "model/UserInfoModel"
	UserInfoModel:get_off_one_equipment( equi_series )

end

--服务器：装备的耐久发生变化
function UserEquipCC:do_change_equi_dura( pack )
	print("UserEquipCC:do_change_equi_dura 服务器：装备的耐久发生变化")
	local equi_series    = pack:readUint64()
    local dura_num   = pack:readUInt()
	
	UserInfoModel:change_a_equi_attr( equi_series, "duration", dura_num )
end

--申请查看其它玩家的装备
function UserEquipCC:request_others_equip( play_name )
	local pack = NetManager:get_socket():alloc(7, 5)
	pack:writeString(play_name)
	NetManager:get_socket():SendToSrv(pack)
end

--服务器：下发其它玩家的装备
function UserEquipCC:do_result_other_equip( pack )
	print("UserEquipCC:do_result_other_equip 服务器：下发其它玩家的装备")
	-- -- TODO
	-- ----add by HJH
	-- ----以后写接口的人要把读包数据自已加上！！！！
	-- local player_name = pack:readString()												----名字
	-- print("name",player_name)
	-- local player_job = pack:readByte()													----职业
	-- print("job",player_job)
	-- local player_level = pack:readByte()												----等级
	-- print("level",player_level)
	-- local player_sex = pack:readByte()													----性别
	-- print("sex",player_sex)
	-- local player_modeid = pack:readUInt()												----modleID
	-- print("modeid",player_modeid)
	-- local player_weapon = pack:readUInt()												----武器外观
	-- print("weapon",player_weapon)
	-- local player_mount = pack:readUInt()												----坐骑外观
	-- print("mount",player_mount)
	-- local player_vip = pack:readInt()													----VIP
	-- print("vip",player_vip)
	-- local player_item_num = pack:readByte()												----装备数量
	-- print("player_item_num",player_item_num)
	-- local player_item_arr = {}
	-- for i = 1, player_item_num do
	-- 	player_item_arr[i] = UserItem(pack)
	-- end
	-- -- local player_item_arr = pack:readString()											----装备列表
	-- local player_is_treasure = pack:readByte()											----是否有宝物
	-- print("treasure",player_is_treasure)
	-- -- local player_treasure = pack:readString()											----宝物数据
	-- local player_inside_attack = pack:readUInt()										----内功攻击
	-- print("insideattack",player_inside_attack)
	-- local player_outside_attack = pack:readUInt()										----外功攻击
	-- print("outsideattack",player_outside_attack)
	-- local player_inside_defence = pack:readUInt()										----内功防御
	-- print("inside_defence",player_inside_defence)
	-- local player_outside_defence = pack:readUInt()										----外功防御
	-- print("outside_defence",player_outside_defence)
	-- local player_accurate = pack:readUInt()												----命中
	-- print("accurate", player_accurate)
	-- local player_sidestep = pack:readUInt()												----闪避
	-- print("sidestept",player_sidestep)
	-- local player_crit = pack:readUInt()													----暴击
	-- print("crit",player_crit)
	-- local player_cur_hp = pack:readUInt()												----当前HP
	-- print("curhp",player_cur_hp)
	-- local player_max_hp = pack:readUInt()												----最大HP
	-- print("maxhp",player_max_hp)
	-- local player_cur_mp = pack:readUInt()												----当前MP
	-- print("curmp", player_cur_mp)
	-- local player_max_mp = pack:readUInt()												----最大MP
	-- print("maxmp",player_max_mp)
	-- local player_item_score = pack:readUInt()											----装备总分
	-- print("itemscore", player_item_score)
	-- local player_camp_score = pack:readUInt()											----阵营贡献
	-- print("campscore",player_camp_score)
	-- local player_zh_score = pack:readUInt()												----战魂值
	-- print("zhscroe",player_zh_score)
	-- local player_pk_score = pack:readUInt()												----PK值
	-- print("pkscore",player_pk_score)
	-- local player_charm_score = pack:readUInt()											----魅力值
	-- print("charmscore", player_charm_score)
	-- ----聊天、私聊界面查看角色装备
	-- print("run do_result_other_equip")
	-- local chat_win = UIManager:find_window("chat_win")
	-- local user_attr_win = UIManager:show_window("user_attr_win")
	-- print("chat_win",chat_win)
	-- print("user_attr_win",user_attr_win)
	-- print("chat_win:chat_win_function(1016,0)",chat_win:chat_win_function(1016,0))
	-- if chat_win ~= nil and user_attr_win ~= nil and chat_win:chat_win_function(1016,0) == true then
	-- 	print("pass if")
	-- 	local camp = chat_win:chat_win_function(1017,7)
	-- 	local entity = UserEquipCC:init_entity_data({player_name, player_job, player_level, player_sex, player_modeid, player_weapon, player_mount, player_vip, 
	-- 		player_inside_attack, player_outside_attack, player_inside_defence, player_outside_defence, player_accurate, player_sidestep, player_crit, player_cur_hp,
	-- 		player_max_hp, player_cur_mp, player_max_mp, player_item_score, player_camp_score, player_zh_score, player_pk_score, player_charm_score, camp})
	-- 	user_attr_win:open_other_panel(entity, player_item_arr)
	-- end

end

--服务器：删除装备
function UserEquipCC:do_dele_equi_id( pack )
	print("UserEquipCC:do_dele_equi_id 服务器：删除装备")
	local equi_series = pack:readUint64()
	UserInfoModel:remove_a_equipment( equi_series )
end

