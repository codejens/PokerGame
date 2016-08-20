-- PacketDispatcher.lua
-- created by aXing on 2012-11-27
-- 网络消息派发器
-- 单单用于处理网络消息

-- require "control/ItemCC";
-- require "control/CangKuCC";
-- require "control/WingCC";
-- require "control/MallCC";
-- require "control/LingGenCC";
-- require "control/AchieveCC";

-- super_class.PacketDispatcher()
PacketDispatcher = {}

--[[
 这里声明一下net packetage有哪些读取方法
 	void 			writeString(const char *str);
	char* 			readString();

	unsigned char 	readByte();
	char 			readChar();
	unsigned short  readWord();
	short 			readShort();
	int 			readInt();
	unsigned int 	readUInt();
	double 			readUint64();
	double 			readInt64();

	void			writeByte(unsigned char btValue);
	void 			writeChar(char cValue);
	void 			writeWord(unsigned short wValue);
	void 			writeShort(short wValue);
	void 			writeInt(int  nValue);
	void 			writeUInt(unsigned int  uValue);	
	void 			writeUint64(double value);
	void 			writeInt64(double value); 
]]--

-- 初始化每个系统协议的方法
-- 选择角色系统
local function init_select_role_cc(  )
	-- require "control/SelectRoleCC"
	local func = {};
	func[2] = SelectRoleCC.do_result_create_role;
	func[3] = SelectRoleCC.do_result_delete_role;
	func[4] = SelectRoleCC.do_query_role_list;
	func[5] = SelectRoleCC.do_result_enter_game;
	func[6] = SelectRoleCC.do_result_random_name;
	func[7] = SelectRoleCC.do_result_least_job;
	func[8] = SelectRoleCC.do_result_least_camp;
	func[9] = SelectRoleCC.do_exit;
	return func;
end 

-- 游戏实体逻辑系统
local function init_game_logic_cc(  )
	-- require "control/GameLogicCC"
	local func = {};
	func[1] = GameLogicCC.do_reset_player_avatar;
	func[2] = GameLogicCC.do_create_other_entity;
	func[3]	= GameLogicCC.do_create_player_avatar;
	func[4] = GameLogicCC.do_create_other_avatar;
	func[5] = GameLogicCC.do_destroy_entity;
	func[6] = GameLogicCC.do_entity_attribute_changed;
	func[7] = GameLogicCC.do_player_avatar_attribute_changed;
	func[8]	= GameLogicCC.do_entity_stop_moved;
	func[9] = GameLogicCC.do_entity_moved;
	func[10]= GameLogicCC.do_game_tick;
	func[11]= GameLogicCC.do_talk_to_npc;
	func[12]= GameLogicCC.do_open_window;
	func[13]= GameLogicCC.do_enter_scene;
	func[14]= GameLogicCC.do_entity_hp_changed;
	func[18]= GameLogicCC.do_entity_spell;
	func[19]= GameLogicCC.target_add_effect;
	func[20]= GameLogicCC.do_entity_hurted;
	func[24]= GameLogicCC.do_handle_result;
	func[27]= GameLogicCC.do_entity_teleport;
	func[28]= GameLogicCC.do_entity_critical;
	func[29]= GameLogicCC.do_entity_dodge;
	func[32]= GameLogicCC.scene_add_effect;
	func[33]= GameLogicCC.do_npc_have_quest;
	func[35]= GameLogicCC.do_entity_died;
	func[37]= GameLogicCC.entity_change_name_color;
	func[40]= GameLogicCC.entity_change_name;
	-- require "control/VIPCC"
	func[50]= VIPCC.do_vip_info;

	func[22] = GameLogicCC.do_message_dialog;

	func[38] = GameLogicCC.do_batter_cd_time;
	func[52] = GameLogicCC.do_create_human_monster;
	func[39] = GameLogicCC.target_remove_effect;
	return func;
end

-- 玩家技能系统
local function init_user_skill_cc(  )
	-- require "control/UserSkillCC"
	local func = {};
    func[1]  = UserSkillCC.do_query_skill_list;
	func[2]  = UserSkillCC.do_result_study_skill;
	func[3]  = UserSkillCC.do_study_scre_success;
	func[4]  = UserSkillCC.do_change_skill_exp;
	func[5]  = UserSkillCC.do_result_syn_cd;
	func[6]  = UserSkillCC.do_by_attacked_damage;
	func[7]  = UserSkillCC.do_to_attack_damage;
	func[8]  = UserSkillCC.do_target_absorb_damage;
	func[9]  = UserSkillCC.do_result_stop_skill;
	func[10] = UserSkillCC.do_result_dele_scre_effi;
	func[11] = UserSkillCC.do_forget_skill;
	func[12] = UserSkillCC.do_set_cd_time;
	func[13] = UserSkillCC.do_set_sing_time;
	func[15] = UserSkillCC.do_use_skill_failed;

	--以下是秘籍的
	func[16] = SkillMiJiCC.do_fudai_result
	func[17] = SkillMiJiCC.do_xiezai_result
	func[18] = SkillMiJiCC.do_shengji_result
	func[19] = SkillMiJiCC.do_hecheng_result
	-- func[20] = SkillMiJiCC.do_others_miji 	-- 服务器不再使用
	func[21] = SkillMiJiCC.do_miji_info
	return func;
end 

-- 仙宗
local function init_guild_cc(  )
	-- require "control/GuildCC"
	local func = {};
    func[1]  = GuildCC.do_result_self_guild_info;
	func[2]  = GuildCC.do_result_guild_memb_list;
	func[3]  = GuildCC.do_result_guild_info_list;
	func[4]  = GuildCC.do_result_create_guild;
	func[7]  = GuildCC.do_notice_ask_join;
	func[9]  = GuildCC.do_result_apply_join;
	func[10] = GuildCC.do_result_join_result;
	func[11] = GuildCC.do_result_apply_join_list;
	func[15] = GuildCC.do_result_get_welfare;
	func[16] = GuildCC.do_result_upgr_guil;
	func[17] = GuildCC.do_flash_guild_info;
	func[20] = GuildCC.do_stone_num_change;
	func[21] = GuildCC.do_total_cont_change;
	func[22] = GuildCC.do_result_guild_chat;
	func[23] = GuildCC.do_result_no_chat;
	func[24] = GuildCC.do_result_if_show_chat;
	func[25] = GuildCC.do_if_memb_on_line;
	func[26] = GuildCC.do_result_guild_notice;
	
	func[27] = GuildCC.do_item_list;
	func[28] = GuildCC.do_add_item;
	func[29] = GuildCC.do_del_item;
	func[30] = GuildCC.req_trim_cangku;

	func[31] = GuildCC.server_receive_guild_altar_info
	func[32] = GuildCC.server_receive_player_altar_info
	func[35] = GuildCC.server_receive_xian_guo_info
	func[36] = GuildCC.server_receive_one_xian_guo_info
	func[37] = GuildCC.do_fudizhizhan_data
	func[39] = GuildCC.do_fudizhizhan_fuben
	func[40] = GuildCC.server_receive_one_change_count_info
	func[41] = GuildCC.server_receive_guild_event_info
	func[42] = GuildCC.server_receive_guild_one_event_info
	func[43] = GuildCC.do_lave_times
	func[44] = GuildCC.server_receive_tianyuan_rank_info
	func[45] = GuildCC.server_receive_personal_tianyuan_rank_info
	func[52] = GuildCC.do_result_cancel_join
	return func;

end

-- 9 聊天
local function init_chat_cc(  )
	-- require "control/ChatCC"
	local func = {};
	func[1] = ChatCC.receive_message;
	func[2] = ChatCC.receive_sys_chat;
	func[3] = ChatCC.receive_private_chat;
	func[4] = ChatCC.receive_area_chat;
	func[5] = ChatCC.receive_announcement;
	func[6] = ChatCC.receive_vip_icon;
	func[7] = ChatCC.receive_tip;
	func[8] = ChatCC.receive_happy_hour_msg;
	func[9] = ChatCC.receive_last_msg;
	return func;
end

-- 13 交易
local function init_buniess_cc()
	local func = {}
	func[1] = BuniessCC.receive_buniess_request
	func[2] = BuniessCC.receive_reject_buniess
	func[3] = BuniessCC.receive_begin_buniess
	func[4] = BuniessCC.receive_change_item
	func[5] = BuniessCC.receive_add_buniess_item
	func[6] = BuniessCC.receive_myself_money_change
	func[7] = BuniessCC.receive_other_money_change
	func[8] = BuniessCC.receive_lock_buniess
	func[9] = BuniessCC.receive_cancel_buniess
	func[10] = BuniessCC.receive_buniess_unlock
	func[11] = BuniessCC.receive_finish_buniess
	return func
end

-- 16 组队熊
local function init_team_cc()
	-- require "control/TeamCC"
	local func = {};
	func[1] = TeamCC.do_init_team_info
	func[2] = TeamCC.do_player_join
	func[9] = TeamCC.do_player_req_join_team
	func[10] = TeamCC.do_leader_invate_join
	func[4] = TeamCC.do_set_leader
	func[7] = TeamCC.do_player_offline
	func[8] = TeamCC.do_player_attr_change
	func[3] = TeamCC.do_kick_player
	func[11] = TeamCC.do_broadcast_player_state
	func[12] = TeamCC.do_broadcast_scene_state
	func[13] = TeamCC.do_ready_status
	return func;
end

-- 17 打坐双修 
local function init_shuangxiu_cc(  )
	-- require "control/ShuangXiuCC"
	local func = {};
	func[1] = ShuangXiuCC.do_start_normal_dazuo;
	func[2] = ShuangXiuCC.do_shuangxiu;
	func[4] = ShuangXiuCC.do_can_invite_shuangxiu_players;
	return func;
end

-- 20 副本
local function init_fuben_cc(  )
	-- require "control/FubenCC"
	local func = {};
	func[1]  = FubenCC.do_get_fuben_enter_count;
	func[8]  = FubenCC.do_first_fuben
	func[9]  = FubenCC.do_fuben_result
	func[10] = FubenCC.do_success_enter_fuben
	func[11] = FubenCC.do_unique_skill_fuben_result
	func[12] = FubenCC.do_bishaji_fuben_tongji_exp
	func[13] = FubenCC.do_play_get_item_effect
	func[14] = FubenCC.do_common_fuben_result
	return func;
end

-- 24 pkmodel
local function init_pk_cc(  )
	-- require "control/PKCC"
	local func = {};
	--func[3] = PKCC.do_set_pk_mode;
	return func;
end


--25 好友
local function init_friend_cc()
	-- require "control/FriendCC"
	local func = {}
	func[1] = FriendCC.receive_friend_enemy_black_info
	func[2] = FriendCC.receive_chat_info
	func[3] = FriendCC.receive_friend_number
	func[5] = FriendCC.receive_add_friend
	func[7] = FriendCC.receive_friend_enemy_black_info_sevent
	func[8] = FriendCC.receive_delete_friend_black_enemy
	func[9] = FriendCC.receive_friend_online
	func[10] = FriendCC.receive_friend_online_change
	func[11] = FriendCC.receive_friend_update_notic
	func[12] = FriendCC.receive_friend_info
	func[13] = FriendCC.receive_today_get_friend_num
	func[14] = FriendCC.receive_radar_get
	return func
end
----26 杂七杂八
local function init_others_cc()
	--print("run init_other_cc")
	-- require "control/OthersCC"
	local fun = {}
	fun[1] 		= OthersCC.receive_player_info
	fun[18] 	= OthersCC.do_play_global_effect
	fun[19] 	= OthersCC.do_play_global_effect_local
	fun[21]		= OthersCC.receive_top_list_data
	fun[22]		= OthersCC.receive_personal_top_list_info
	fun[23] 	= OthersCC.receive_my_top_list_info
	fun[25]		= OthersCC.do_has_zc_num
	fun[24] 	= OthersCC.do_collection
	fun[28]		= OthersCC.do_get_enter_fuben_count
	fun[26]     = OthersCC.do_fuben_tongji
	fun[29]     = OthersCC.do_result_activity_award_info
	fun[30]     = OthersCC.do_activity_event
	fun[31]     = OthersCC.do_result_get_activity_award
	fun[34]		= OthersCC.do_close_fuben_tongji
	fun[35]		= OthersCC.do_world_boss_date
	fun[36]		= OthersCC.do_activity_notification
	fun[37]		= OthersCC.do_result_boss_killer
	fun[38]		= OthersCC.do_update_enter_fuben_info
	fun[40] 	= OthersCC.do_show_tycz
	fun[42]		= OthersCC.server_send_clear_and_update_top_list
	fun[43]		= OthersCC.do_log_move_error
	return fun
	
end
-- 装备
local function init_equip_cc(  )
	-- require "control/UserEquipCC"
	local func = {};
	func[1] = UserEquipCC.do_result_equip_one;
	func[2] = UserEquipCC.do_result_unequip_by_id;
	func[3] = UserEquipCC.do_result_get_equi;
	func[4] = UserEquipCC.do_change_equi_dura;
	func[5] = UserEquipCC.do_result_other_equip;
	func[6] = UserEquipCC.do_dele_equi_id;
	return func;
end 

-- 6:任务
local function init_task_cc()
	local func = {};
	-- require "control/TaskCC"
	func[1] = TaskCC.do_task_list;
	func[2] = TaskCC.do_new_task;
	func[3] = TaskCC.do_finish_task;
	func[4] = TaskCC.do_give_up_task;
	func[5] = TaskCC.do_get_task_list;
	func[7] = TaskCC.do_task_time_out;
	func[8] = TaskCC.do_set_task_percent;
	func[9] = TaskCC.do_add_kejie_task;
	func[10] = TaskCC.do_rapid_finish_task;
	func[11] = TaskCC.do_delete_task;
	func[14] = TaskCC.do_get_chapters;
	return func;
end 

-- 34:宠物
local function init_pet_cc()
	local func = {};
	-- require "control/PetCC"
	func[1] = PetCC.do_get_pet_list;
	func[2] = PetCC.do_fight;
	func[3] = PetCC.do_delete_pet;
	func[4] = PetCC.do_change_pet_name;
	func[5] = PetCC.do_change_pet_attr;
	func[6] = PetCC.do_add_pet_max_num;
	func[7] = PetCC.do_add_new_pet;
	--func[8] = PetCC.
	func[9] = PetCC.do_use_pet_hp_bottle;
	--func[10] = PetCC.
	--func[11] = PetCC.
	--func[12] = PetCC.
	func[13] = PetCC.do_merge;
	func[14] = PetCC.do_study_skill;
	func[15] = PetCC.do_forget_skill;
	func[16] = PetCC.do_pet_dead;
	func[17] = PetCC.do_skill_keyin;
	func[18] = PetCC.do_skill_move_store;
	func[19] = PetCC.do_remove_skill_form_store;
	func[20] = PetCC.do_store_skill_list;
	func[21] = PetCC.do_get_huan_hun_yu_info;
	--func[22] = PetCC.
	func[23] = PetCC.do_wake_skill;
	--func[24] = PetCC.
	func[25] = PetCC.do_use_skill;
	func[26] = PetCC.do_use_skill;
	func[27] = PetCC.do_recover_pet;
	func[28] = PetCC.do_get_other_pet_info;
	func[29] = PetCC.do_send_current_pet_id;
	return func;
end 

-- 39:斗法台
local function init_dft_cc()
	local func = {};
	-- require "control/DouFaTaiCC"
	func[1] = DouFaTaiCC.do_get_info;
	func[2] = DouFaTaiCC.do_start_pk;
	func[3] = DouFaTaiCC.do_clear_cd;
	func[4] = DouFaTaiCC.do_add_fight_num;
	func[5] = DouFaTaiCC.do_top_info;
	func[6] = DouFaTaiCC.do_get_zj_info;
	func[7] = DouFaTaiCC.do_get_reward_info;
	func[9] = DouFaTaiCC.do_add_zj;
	func[10] = DouFaTaiCC.do_fight_result;
	func[11] = DouFaTaiCC.do_catch_result;

	return func;
end 

-- 41:邮件
local function init_mail_cc()
	local func = {};
	-- require "control/MailCC"
	func[1] = MailCC.do_result_mail_list;
	func[2] = MailCC.do_notice_new_mail;
	func[3] = MailCC.do_notice_get_success;
	func[4] = MailCC.do_result_delete_mail;
	func[5] = MailCC.do_result_send_mail;
	func[6] = MailCC.do_result_read_mail;
	func[7] = MailCC.notice_mail_will_full;
	func[8] = MailCC.notice_mail_had_not_get;
	return func;
end 

-- 42: 委托
local function init_entrust_cc( ... )
	local func = {}
	func[1] = EntrustCC.do_result_depot_item_list
	func[2] = EntrustCC.do_result_depot_item_move
	func[3] = EntrustCC.add_item_to_depot
	func[4] = EntrustCC.depot_item_count_change
	func[5] = EntrustCC.do_result_fuben_info
	func[6] = EntrustCC.begin_entrust
	func[7] = EntrustCC.entrust_end
	func[8] = EntrustCC.do_result_get_exp
	func[9] = EntrustCC.fuben_max_tier_change
	return func
end

--	19：坐骑系统
local function init_mounts_cc()
	-- body
	local func = {};
	-- require "control/MountsCC"
	func[1] = MountsCC.do_mounts_info;
	func[2] = MountsCC.do_up_level;
	func[3] = MountsCC.do_fight_value_change;
	func[4] = MountsCC.do_up_pinjie;
	func[5] = MountsCC.do_xiliang_option;
	func[7] = MountsCC.do_base_attribute_change;
	func[8] = MountsCC.do_up_lingxi;
	func[9] = MountsCC.do_huaxing;
	func[12]= MountsCC.do_update_free_shengjie_times;
	func[13]= MountsCC.do_update_free_xilian_times;
	func[14]= MountsCC.do_active_spe_mounts;

	return func;

end 

-- 28：成就
local function init_achieve_cc()
	local func = {};
	-- require "control/AchieveCC"
	func[1] = AchieveCC.do_request_achieve_info;
	func[2] = AchieveCC.do_finish_achieve;
	func[3] = AchieveCC.do_progress;
	func[4] = AchieveCC.do_get_award;
	func[5] = AchieveCC.do_self_title;
	func[6] = AchieveCC.do_add_avatar_title;
	func[7] = AchieveCC.do_remove_avatar_title;
	return func;
end

-- 36：梦境系统
local function init_dreamland_cc( )
	-- body
	local func = {};
	-- require "control/DreamlandCC"
	func[1] = DreamlandCC.do_tanbao;
	func[2] = DreamlandCC.do_cangku_list;
	func[3] = DreamlandCC.do_moveItem_to_package;
	func[4] = DreamlandCC.do_zhenpin_jilu;
	func[5] = DreamlandCC.do_add_item;
	func[6] = DreamlandCC.do_item_count_change;
	func[8] = DreamlandCC.do_taobao_tree_tan_bao;
	func[9] = DreamlandCC.do_taobao_tree_zhenpin;
	func[11] = DreamlandCC.do_get_free_count
	return func;
end

-- 200, 封测活动
local function init_fc_activity_cc(  )
	local func = {};
	func[1] = ClosedBateActivityCC.do_level_award;
	func[2] = ClosedBateActivityCC.do_daily_login_award;
	func[3] = ClosedBateActivityCC.do_online_period_award;
	func[4] = ClosedBateActivityCC.do_activity_award;
	func[5] = ClosedBateActivityCC.do_online_duration_award;
	func[6] = ClosedBateActivityCC.do_fc_activity_is_open;
	func[7] = ClosedBateActivityCC.do_xiuxian_award_status;
	func[9] = ClosedBateActivityCC.do_meitilibao
	func[10] = ClosedBateActivityCC.update_seven_day_award_info
	func[11] = ClosedBateActivityCC.do_login_award_win_visible
	func[12] = ClosedBateActivityCC.do_fp_count
	func[13] = ClosedBateActivityCC.do_start_fp
	func[14] = ClosedBateActivityCC.do_login_award_p
	func[15] = ClosedBateActivityCC.do_accept_login_award
	func[16] = ClosedBateActivityCC.do_luck_guess_win_visible
	func[17] = ClosedBateActivityCC.do_luck_guess_count
	func[18] = ClosedBateActivityCC.do_luck_guess_p
	func[19] = ClosedBateActivityCC.do_start_guess
	func[20] = ClosedBateActivityCC.do_open_b
	func[21] = ClosedBateActivityCC.do_start_xp

	return func;
end


-- 129, 设置系统
local function init_set_cc(  )
	local func = {}
    -- require "control/SetSystemCC"
    func[1]  = SetSystemCC.do_result_set_date
    return func
end

-- 139,
local function init_misc_cc( )
	local func = {};
	-- require "control/MiscCC"
	func[22] = MiscCC.receive_flower
	func[32] = MiscCC.do_zhaocai;

	--天元之战的统计数据
	func[35] = MiscCC.do_tianyuan_battle_tongji;
	func[36] = MiscCC.do_result_self_guild_tianyuan_range;

	func[37] = MiscCC.do_refresh_quest_star;
	func[40] = MiscCC.do_relive;
	--渡劫
	func[41] = MiscCC.do_dujie_info;
	func[42] = MiscCC.do_dujie_succss;
	func[43] = MiscCC.do_dujie_fail;

	func[45] = MiscCC.do_receive_quest;
	func[44] = MiscCC.do_refresh_quest_star_count;	
	func[46] = MiscCC.do_shangjin_money;
	func[47] = MiscCC.do_drop_chest_in_fuben;

	func[50] = MiscCC.do_battle_info;
	func[51] = MiscCC.do_enter_battle;
	func[52] = MiscCC.receive_camp_battle_top_list_info;
	func[53] = MiscCC.do_battle_reward;
	func[54] = MiscCC.do_zhenying_battle_tongji;
	func[56] = MiscCC.do_camp_battle_result_rank;
	func[57] = MiscCC.do_campBattle_league_status;
	
	func[59] = MiscCC.do_broadcast_playAction;
	func[60] = MiscCC.do_playAction_count;

	func[62] = MiscCC.do_add_gather_pink_count;
	func[63] = MiscCC.do_use_a_item;
	func[65] = MiscCC.do_vip_experience_time;
	func[67] = MiscCC.do_play_get_item_effect;
	func[68] = MiscCC.do_play_exp_effect;
	func[70] = MiscCC.do_result_exp_back_date;
	func[72] = MiscCC.do_npc_task_status;

	func[75] = MiscCC.do_get_qd_info;
	func[76] = MiscCC.do_get_award_accept_info;

	func[79] = MiscCC.receive_tzfl_icon_state
	func[80] = MiscCC.receive_tzfl_info
	func[85] = MiscCC.do_result_HZYX_count
	func[86] = MiscCC.do_result_check_online

	func[88] = MiscCC.do_camp_battle_task;
	func[90] = MiscCC.do_baguadigong_tongji_info;
	func[91] = MiscCC.do_baguadigong_boss_refresh_time;
	func[92] = MiscCC.did_enter_baguadidong;

	func[100] = MiscCC.do_result_luopan_data;
	func[101] = MiscCC.do_result_luopan_appear_items;
	func[102] = MiscCC.do_result_luopan_get_award;
	func[103] = MiscCC.luopan_add_item;
	func[124] = MiscCC.do_item_info;
	
	func[94] = CaiQuanCC.do_self_info;
	func[95] = CaiQuanCC.do_system_matching;
	func[97] = CaiQuanCC.do_get_match_info;
	func[98] = CaiQuanCC.do_take_caiquan;

	func[106] = MiscCC.do_shenmi_info;
	func[109] = MiscCC.do_show_hide_icon;
	func[110] = MiscCC.do_update_remain_time;

	func[123]= MiscCC.do_get_server_time
	func[125]= MiscCC.do_get_fuben_times_remain

	-- 获取宝石材料
	func[127] = ItemCC.do_gem_meta
	func[128] = MiscCC.do_fuben_info
	func[129] = MiscCC.do_buy_and_present

	func[131] = MiscCC.do_get_gem_meta
	func[132] = MiscCC.do_put_gem_meta
	func[133] = MiscCC.do_add_fuben_count
	func[135] = MiscCC.do_indicate_direction
	func[136] = MiscCC.do_get_enter_fuben_count

	func[140] = MiscCC.do_fuben_pass_info

	--至尊特惠
	func[142] = MiscCC.do_tehui_sub_info


	func[145] = MiscCC.do_get_login_award_data
	func[148] = MiscCC.do_luopan_my_item_record -- 幸运转盘
	func[149] = MiscCC.do_add_enter_fuben_count 

	-- 我要翻牌(修复雁门关)
	func[150] = OpenCardCC.do_card_info
	func[151] = OpenCardCC.do_open_card

	func[160] = MiscCC.do_rename_result
	func[161] = MiscCC.do_check_name_result
	return func;
end

-- 138, 在线奖励系统
local function init_online_award_cc(  )
	local func = {}
    -- require "control/OnlineAwardCC"
    func[6]  = OnlineAwardCC.do_result_login_award_list
    func[10] = OnlineAwardCC.do_result_off_line_exp
    func[12] = OnlineAwardCC.do_result_login_current_item
    func[14] = OnlineAwardCC.do_result_if_had_get_vip_award
    func[16] = OnlineAwardCC.do_recharge_award_date

    func[18] = OnlineAwardCC.do_rank_list_award_data;
    func[19] = OnlineAwardCC.do_someone_rank_data;
    func[20] = OnlineAwardCC.do_get_rank_award;
    func[22] = OnlineAwardCC.do_guild_award_info;
    func[24] = OnlineAwardCC.do_suit_award_info;
    func[26] = OnlineAwardCC.do_dujie_award_info;

    func[32] = OnlineAwardCC.do_award_state;
    func[33] = OnlineAwardCC.do_award_info;
    func[34] = OnlineAwardCC.do_get_award_oneday;

    func[37] = OnlineAwardCC.server_blue_qqvip_info
    func[38] = OnlineAwardCC.do_miyou;
    func[39] = OnlineAwardCC.do_miyou_sendGift;
    func[40] = OnlineAwardCC.do_miyou_get;
    func[42] = OnlineAwardCC.do_miyou_remainTime;
    func[46] = OnlineAwardCC.do_get_huodonglibao;
    func[47] = OnlineAwardCC.do_xiuxian_award_info;
    func[49] = OnlineAwardCC.do_result_lingqi_not_online;
    func[51] = OnlineAwardCC.receive_consume_item;
    func[52] = OnlineAwardCC.do_activitys_list;
    func[53] = OnlineAwardCC.do_strong_hero;
    func[55] = OnlineAwardCC.do_get_power_pet;
    func[57] = OnlineAwardCC.do_get_power_fabao;
    func[72] = OnlineAwardCC.do_open_bh_window;
    func[73] = OnlineAwardCC.do_choujiang;
    func[75] = OnlineAwardCC.do_open_guoqing_activity_win;
    func[80] = OnlineAwardCC.do_result_activity_data_com;
    func[82] = OnlineAwardCC.do_result_activity_rank_com;
    func[85] = OnlineAwardCC.do_smlbcj;
    func[87] = OnlineAwardCC.do_smbbcj;
    func[91] = OnlineAwardCC.server_qq_blue_vip_open_state
    func[94] = OnlineAwardCC.server_get_blue_activity_open;
    func[95] = OnlineAwardCC.client_get_blue_activity_award
    func[96] = OnlineAwardCC.do_sdsl_data
    func[106] =OnlineAwardCC.do_qqbrowser_award
    func[107] =OnlineAwardCC.do_get_award_state
    func[110] =OnlineAwardCC.do_get_jubaodai_rank
    func[113] =OnlineAwardCC.do_login_benefit
    func[114] =OnlineAwardCC.do_enter_xinshoucun

    -- 九宫神藏
    func[181] = OnlineAwardCC.do_send_jiugong_info
    func[182] = OnlineAwardCC.do_send_choujiang_info
    
    func[200] =OnlineAwardCC.receiverGroupBuyPointQueue
    func[201] =OnlineAwardCC.receiverGroupBuyInfo

    func[205] =OnlineAwardCC.do_main_info
    func[206] =OnlineAwardCC.do_gift_order
    func[207] =OnlineAwardCC.do_draw_result
    func[223] = OnlineAwardCC.receiveSendFlowerRanking	    --送花排行榜活动
    func[225] = OnlineAwardCC.receiveExchangeInfoList	    --春节兑换活动
    func[235] = OnlineAwardCC.recvLimitBuyCount
    func[239] = OnlineAwardCC.recvActivityTag
    func[243] = OnlineAwardCC.receive_qiankun_info
    func[244] = OnlineAwardCC.rec_qiankun_items
    -- func[240] = OnlineAwardCC.do_get_ReceiveFlowerData    -- 收花数据
    func[245] = OnlineAwardCC.rechieve_chongzhi_value
    func[247] = OnlineAwardCC.do_get_ReceiveFlowerRank	  -- 收花排行榜数据

    -- 连续充值
    func[248] = OnlineAwardCC.do_seriescz_info   

    func[250] = OnlineAwardCC.receive_tower_info		--神龙密塔数据
    return func
end 

-- 27 寄卖系统
local function init_jishou_cc()
	local func = {}
	func[1] = JiShouCC.receive_my_item_list
	func[2] = JiShouCC.receive_search_result
	func[3] = JiShouCC.receive_item_result
	func[5] = JiShouCC.receive_item_buy_result
	func[7] = JiShouCC.receive_jishou_price
	func[4] = JiShouCC.receive_delete_item
	return func
end

-- 133, npc交易子系统
local function init_npc_trade_cc_133( )
	local func = {};
	-- require "control/NPCTradeCC"
	func[1] = NPCTradeCC.do_get_res_from_shop
	func[2] = NPCTradeCC.do_trade_result
	func[3] = NPCTradeCC.do_get_item_data
	func[4] = NPCTradeCC.do_sold_res_to_shop
	func[5] = NPCTradeCC.do_buyback_res
	return func;
end

-- 134 快捷键系统
local function init_key_cc()
	local func = {};
	func[1] = KeySettingCC.do_set_a_key
	func[2] = KeySettingCC.do_get_key_setting
	return func;
end

-- 145 短期目标系统
local function init_dqmb_cc(  )
	local func = {};
	func[1] = DQMBCC.do_change_DQMB_state
	return func;
end

-- 15, 拾取子系统
local function init_drop_item_cc(  )
	local func = {}
	-- require "control/DropItemCC"
	func[2] = DropItemCC.do_drop_item_appear
	func[3] = DropItemCC.do_drop_item_disappear
	return func
end

-- 4, buff系统
local function  init_buff_cc(  )
	local func = {};
	-- require "control/BuffCC"
	func[1] = BuffCC.do_add_buff;
	func[2] = BuffCC.do_delete_buff
	func[3] = BuffCC.do_delete_buff_type
	func[4] = BuffCC.do_init_buff

	return func;
end

-- 33, 法宝系统
local function init_fabao_cc( )
	local func = {};
	func[1] = FabaoCC.do_used_xianhun_info;
	func[2] = FabaoCC.do_fabao_info;
	func[3] = FabaoCC.do_liehun_win_info;
	func[4] = FabaoCC.do_new_lianhunshi;
	func[5] = FabaoCC.do_open_xianhun_slot;
	func[6] = FabaoCC.do_add_xianhun;
	func[7] = FabaoCC.do_delete_xianhun;
	func[8] = FabaoCC.do_update_xianhun_info;
	func[9] = FabaoCC.do_update_fabao_fight;
	func[10] = FabaoCC.do_one_key_hecheng;
	func[11] = FabaoCC.do_show_other_fabao_info;
	func[13] = FabaoCC.do_vip_user_call_fourth_lianhunshi_count;
	func[14] = FabaoCC.do_show_uplevle_bj_type;
	func[15] = FabaoCC.do_show_message_tips;

	return func;
end
-- 141, 答题系统
local function init_question_cc( )
	
	local func = {};
	func[1] = QuestionCC.do_all_question_info;
	func[2] = QuestionCC.do_commit_answer;
	func[3] = QuestionCC.do_use_assistant_system;
	func[4] = QuestionCC.do_show_correct_answer;
	func[5] = QuestionCC.do_did_jion_activity_count;
	return func;

end

-- 144,欢乐斗
local function init_huanledou_cc(  )
	local func = {};
	func[1] = HuanLeDouCC.do_msg_info;
	func[2] = HuanLeDouCC.do_hld_info;
	func[3] = HuanLeDouCC.do_loser_list;
	func[4] = HuanLeDouCC.do_duo_pu_list;
	func[5] = HuanLeDouCC.do_kugong_list;
	func[6] = HuanLeDouCC.do_can_save_list;
	func[7] = HuanLeDouCC.do_kugong_list;
	func[17] = HuanLeDouCC.do_get_my_guild_list;
	func[19] = HuanLeDouCC.do_this_player_have_master;
	func[20] = HuanLeDouCC.do_new_msg;
	return func;
end

-- 146, 跑环系统
local function init_paohuan_cc( )
	local func = {};
	func[1] = PaoHuanCC.do_get_zh_list;
	func[4] = PaoHuanCC.do_dsz_result;
	return func;
end

-- 160 晶矿
local function init_jingkuang_cc()
	local fun = {}
	fun[1] = JingKuangCC.do_send_kuang_info
	fun[8] = JingKuangCC.do_send_miner_info
	fun[9] = JingKuangCC.do_send_kuangchang_list
	fun[10] = JingKuangCC.do_send_shoukuang_info
	fun[11] = JingKuangCC.do_send_kaikuang_info
	fun[14] = JingKuangCC.do_xiezhu_wakuang
	fun[15] = JingKuangCC.do_open_result
	return fun
end

local function init_lg_zhenqi_cc( )
	local func = {};
	func[1] = LingGenCC.do_zhenqixiulian_data;
	func[2] = LingGenCC.do_qianxin_result;
	func[3] = LingGenCC.do_change_result;
	func[4] = LingGenCC.do_popup_bubble;
	return func;
end


--154 组队副本
local function init_team_activity_cc(  )
	local fun = {}

	fun[1] = TeamActivityCC.do_fuben_team_info
	fun[2] = TeamActivityCC.do_apply_ans
	fun[3] = TeamActivityCC.do_cancel_recruit
	fun[5] = TeamActivityCC.do_join_req
	fun[9] = TeamActivityCC.do_team_info
	fun[10] = TeamActivityCC.do_tokens_count
	fun[13] = TeamActivityCC.do_team_ready;
	fun[15] = TeamActivityCC.do_leader_recruit_info
	return fun;
end

--157,洞府
local function init_plant_cc()
	local fun = {}
	fun[1] = PlantCC.server_enter_info
	fun[3] = PlantCC.server_level_up
	fun[4] = PlantCC.server_water_power
	fun[5] = PlantCC.server_seed_select_type
	fun[8] = PlantCC.server_plant
	fun[11] = PlantCC.server_plant_state
	fun[12] = PlantCC.server_plant_event
	fun[13] = PlantCC.server_quick
	fun[14] = PlantCC.server_clear
	fun[15] = PlantCC.server_get
	fun[17] = PlantCC.server_luck
	fun[19] = PlantCC.server_event
	fun[21] = PlantCC.server_get_auto_plant_info
	fun[22] = PlantCC.server_return_friend_state
	fun[23] = PlantCC.server_update_cur_state
	fun[25] = PlantCC.server_update_my_state
	return fun
end

-- 147,仙道会
local function init_xdh_cc()
	local func = {};
	func[1] = XianDaoHuiCC.do_match_info;
	func[2] = XianDaoHuiCC.do_rank_top_info;
	func[3] = XianDaoHuiCC.do_zbs_info;
	func[4] = XianDaoHuiCC.do_last_zbs_16_info;
	func[5] = XianDaoHuiCC.do_xw_info;
	func[6] = XianDaoHuiCC.do_matching_start;
	func[7] = XianDaoHuiCC.do_pk_start;
	func[8] = XianDaoHuiCC.do_pk_end;
	func[9] = XianDaoHuiCC.do_xz;
	func[10] = XianDaoHuiCC.do_lt_state_change;
	func[11] = XianDaoHuiCC.do_flower;
	func[12] = XianDaoHuiCC.do_zys_state_change;
	func[13] = XianDaoHuiCC.do_ry_award;
	func[16] = XianDaoHuiCC.do_value_top;
	func[18] = XianDaoHuiCC.do_jjc_start_time;
	func[19] = XianDaoHuiCC.do_xdh_info_refresh;
	func[20] = XianDaoHuiCC.do_flower_num;
	func[21] = XianDaoHuiCC.do_player_value;
	func[22] = XianDaoHuiCC.do_zbs_pk_result;
	func[23] = XianDaoHuiCC.do_zbs_change;
	return func;
	
end

local function init_marriage_cc(  )
	
	local func = {};
	func[1] = MarriageCC.do_wedding_info;
	func[3] = MarriageCC.do_wedding;
	func[4] = MarriageCC.do_marriage_record_list;
	func[5] = MarriageCC.do_get_marriage;
	func[7] = MarriageCC.do_observor_xianyuan;
	func[9] = MarriageCC.do_join_wedding;
	func[11] = MarriageCC.do_wedding_play;
	func[13] = MarriageCC.do_get_wedding_list;
	func[14] = MarriageCC.do_new_marriage_record;
	func[15] = MarriageCC.do_wedding_over;
	return func;

end

--149 其他活动
local function init_other_activities_cc()
	local func = {};
	func[1] = OtherActivitiesCC.do_login_gift;
	func[3] = OtherActivitiesCC.do_camp_battle_rank_info;
	func[5] = OtherActivitiesCC.do_recharge_gift_info;
	func[7] = OtherActivitiesCC.do_tyzz_info;
	func[9] = OtherActivitiesCC.do_seven_day_activity_info
	return func;
end

local function init_transform_cc()
	local func = {}
	func[1] = TransformCC.do_init
	func[2] = TransformCC.do_change_data
	func[3] = TransformCC.do_result_upgrade_stage
	func[4] = TransformCC.do_result_develop
	func[5] = TransformCC.do_result_upgrade_skill
	func[6] = TransformCC.do_get_total_point
	func[7] = TransformCC.do_get_new_skill
	func[8] = TransformCC.do_get_point
	func[9] = TransformCC.do_get_count_down
	func[10]= TransformCC.do_get_transform_system
	return func
end

local function init_sprite_cc()
	local func = {};
	func[2] = SpriteCC.do_sprite_info;
	func[3] = SpriteCC.do_sprite_up_level_info;
	func[4] = SpriteCC.do_upgrade_stage_change;
	func[5] = SpriteCC.do_sprite_model_change;
	func[6] = SpriteCC.do_upgrade_skill_change;
	func[7] = SpriteCC.do_lunhui_stage_change;
	func[8] = SpriteCC.do_equip_stage_change;
	func[9] = SpriteCC.do_sprite_info_change;
	func[10] = SpriteCC.do_sprite_fight_value_change;
	func[11] = SpriteCC.do_sprite_baoji_value_change;
	func[12] = SpriteCC.do_equip_upstage_times_change;
	func[13] = SpriteCC.do_get_sprite_condition;

	return func;
end

local function init_elfin_cc( )
	local func = {}
	func[1] = ElfinCC.do_elfin_data
	func[2] = ElfinCC.do_bag_or_storage
	func[3] = ElfinCC.do_get_out_from_storage
	func[4] = ElfinCC.do_level_up_elfin
	func[5] = ElfinCC.do_wear_equipment
	func[6] = ElfinCC.do_takeoff_equipment
	func[7] = ElfinCC.do_level_up_equip
	func[8] = ElfinCC.do_smelt_equip
	func[9] = ElfinCC.do_open_bronze_box
	func[10] = ElfinCC.do_call_gold_box
	-- func[11] = ElfinCC.do_explore
	-- func[12] = ElfinCC.do_get_explore_award
	func[13] = ElfinCC.do_explore_status
	func[14] = ElfinCC.do_get_explore_award
	func[15] = ElfinCC.do_open_explore_level
	func[16] = ElfinCC.do_smelt_val
	func[20] = ElfinCC.do_init_elfin_data
	func[21] = ElfinCC.do_remove_item
	func[22] = ElfinCC.do_add_item
	func[23] = ElfinCC.do_change_model
	func[24] = ElfinCC.do_change_fight
	func[25] = ElfinCC.do_change_call_box_num
	func[26] = ElfinCC.do_change_extend_explore_dt_num
	func[27] = ElfinCC.do_open_equip_slot
	func[28] = ElfinCC.do_booooom
	
	return func
end

--48 镇妖塔
local function init_zhenyaota_cc(  )
	local fun = {}
	fun[5] = ZhenYaoTaCC.do_player_clearance_info
	fun[9] = ZhenYaoTaCC.do_challenge_result
	fun[10] = ZhenYaoTaCC.do_challenge_fail
	fun[11] = ZhenYaoTaCC.do_floor_master_change
	fun[12] = ZhenYaoTaCC.do_floor_master
	return fun
end 

local function init_newercamp_cc()
	local func = {}
	func[1] = NewerCampCC.do_newercamp_progress

	return func
end

-- 164,河图洛书
--美人后宫 卡牌
local function init_heluo_books_cc()
	local func = {}
	func[1] = HeLuoBooksCC.do_base_heluo_info
	func[2] = HeLuoBooksCC.do_update_one_book_info
	func[6] = HeLuoBooksCC.do_update_heluo_jingyan
	func[7] = HeLuoBooksCC.do_duihuan_count
	func[10] = HeLuoBooksCC.do_update_meiren_po
	return func
end

-- 165
local function init_magictree_cc()
	local func = {}
	func[1] = MagicTreeCC.do_magictree_info
	func[2] = MagicTreeCC.do_receive_log
	func[3] = MagicTreeCC.do_cangku_info
	func[4] = MagicTreeCC.do_friend_info
	func[5] = MagicTreeCC.do_opera_log
	return func
end

-- 166
local function init_beautycard_cc()
	local func = {}
	func[1] = BeautyCardCC.do_beautycard_info
	func[2] = BeautyCardCC.do_draw_card_result
	func[3] = BeautyCardCC.do_gold_free_time
	return func
end



local _packet_function = {};

-- 初始化函数包
local function init_packet_dispatcher(  )
	-- 选择角色系统
	_packet_function[255] 	= init_select_role_cc();
	-- 游戏实体逻辑系统
	_packet_function[0]		= init_game_logic_cc();
	-- buff系统
	_packet_function[4]		= init_buff_cc();
	-- 玩家技能系统
	_packet_function[5] 	= init_user_skill_cc();
	-- 任务系统
	_packet_function[6] 	= init_task_cc();
    -- 玩家装备系统
    _packet_function[7] 	= init_equip_cc();    
	-- 背包子系统
	_packet_function[8] 	= ItemCC.init_item_cc();
	-- 聊天
	_packet_function[9] 	= init_chat_cc();
	-- 仙宗系统
	_packet_function[10] 	=  init_guild_cc();
	-- 商城子系统
	_packet_function[12]	= MallCC:init_mall_cc();
	-- 交易系统
	_packet_function[13] 	= init_buniess_cc()
	-- 拾取子系统
	_packet_function[15]	= init_drop_item_cc()
	-- 组队系统
	_packet_function[16]	= init_team_cc();
	-- 打坐双修
	_packet_function[17]	= init_shuangxiu_cc();
	-- 坐骑
	_packet_function[19]  	= init_mounts_cc();
	-- 副本
	_packet_function[20]	= init_fuben_cc();
	-- 仓库子系统
	_packet_function[23] 	= CangKuCC.init_cangku_cc();
	-- pk系统
	_packet_function[24] 	= init_pk_cc(  );
	--好友
	_packet_function[25]	= init_friend_cc()
	--杂七杂八
	_packet_function[26]    = init_others_cc();
	--寄卖系统
	_packet_function[27] 	= init_jishou_cc()
	-- 成就子系统
	_packet_function[28]    = init_achieve_cc();
	-- 灵根子系统
	_packet_function[29]    = LingGenCC.init_linggen_cc();
	-- 法宝系统
	_packet_function[33] 	= init_fabao_cc();
	-- 宠物
	_packet_function[34] 	= init_pet_cc();
	--梦境
	_packet_function[36]	= init_dreamland_cc();
	-- 斗法台
	_packet_function[39]	= init_dft_cc();
	-- 翅膀子系统
	_packet_function[40] 	= WingCC:init_wing_cc();
	-- 邮件系统
	_packet_function[41] 	= init_mail_cc()
	-- 委托系统
	_packet_function[42] 	= init_entrust_cc()

	--变身系统
	_packet_function[44]	= init_transform_cc();

	--精灵系统
	_packet_function[45]	= init_elfin_cc() -- init_sprite_cc();

	--镇妖塔
	_packet_function[48]    = init_zhenyaota_cc(  )

	-- 设置系统
	_packet_function[129] 	= init_set_cc()
    -- npc交易子系统
	_packet_function[133]   = init_npc_trade_cc_133( )
	-- 快捷键系统
	_packet_function[134]   = init_key_cc()
	-- 在线奖励系统
	_packet_function[138]   = init_online_award_cc(  )
	--Misc系统
	_packet_function[139]   = init_misc_cc();
	-- 短期目标系统
	_packet_function[145] 	= init_dqmb_cc();
	-- 答题系统
	_packet_function[141]   = init_question_cc();
	-- 欢乐斗系统
	_packet_function[144]	= init_huanledou_cc();
	-- 跑环系统
	_packet_function[146]   = init_paohuan_cc();
	-- 仙道会系统
	_packet_function[147] 	= init_xdh_cc();
	-- 结婚系统
	_packet_function[148]	= init_marriage_cc();
	-- 其他活动系统
	_packet_function[149]	= init_other_activities_cc();
	-- 情人节活动
	_packet_function[151]   = QingrenjieCC:init_qingrenjie_cc();
	--组队副本
	_packet_function[154]   = init_team_activity_cc();
	--洞府
	_packet_function[157]	= init_plant_cc()
	-- 新手体验副本(离线副本)
	_packet_function[158]	= init_newercamp_cc()

	--晶矿
	_packet_function[160]	= init_jingkuang_cc()

	-- 灵根真气修炼(应该是29放在)
	_packet_function[161]	= init_lg_zhenqi_cc()

	-- 昆仑神树
	_packet_function[165]   = init_magictree_cc()

	-- 美人抽卡
	_packet_function[166]   = init_beautycard_cc()

	-- 封测活动
	_packet_function[200]	= init_fc_activity_cc();
	--河图洛书
	_packet_function[164]    = init_heluo_books_cc()

end 

-- 初始化函数包
init_packet_dispatcher()

local bi_server_url = CommonConfig:getDefault("bi_server_url")

-- 执行包函数
function PacketDispatcher:do_game_logic(sysid, pid, pack, size)
	-- ZXLog('-----------PacketDispatcher:do_game_logic------------',sysid, pid, pack, size)
	--print("sysid, pid",sysid, pid)
	local system = _packet_function[sysid]
	if system == nil then
		print("net packet has not registed this system: " .. sysid)
		return
	end
	local func = system[pid]
	if func == nil then
		--print("net packet has not registed this function: " .. sysid .. " " .. pid)
		return
	end
	if sysid == 10 then
		-- print("```````````````````pid=",pid)
	end

	-- 如果需要流量统计
	if bi_server_url ~= nil then
		-- TODO::这里还需要加上时间段限制
		require "analyze/Analyze"
		Analyze:parse_proto(sysid, pid, size)
	end
	func(nil, pack)				-- 因为都是静态方法，所以this指针传nil

end