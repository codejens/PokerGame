-- LeftClickMenuMgr.lua
-- created by lyl on 2012-1-25
-- 提示窗口

-- super_class.LeftClickMenuMgr(  )
LeftClickMenuMgr = {}

-- added by aXing on 2013-5-25
function LeftClickMenuMgr:fini( ... )
	-- body
end

-- ===============================================
-- 选项函数定义
-- ================================================
local function print_error( memb_info )
	print(" !!!   error   !!!  参数不正确  ")
	require "utils/Utils"
	Utils:print_table_key_value( memb_info )
end
-- 实例函数
function LeftClickMenuMgr:key1(  )
	print(" ... key1_fun ...   params  " )
end
-- 实例函数
function LeftClickMenuMgr:key2( params )
	print(" ... key2_fun ...   params  " , unpack( params ) )
end

-- 任命家族   帮主
function LeftClickMenuMgr:nomi_wang( params )
	local memb_info = params[1]
	if memb_info and memb_info.ActorId then
	    require "model/GuildModel"
	    GuildModel:send_nominate_member( memb_info.ActorId, 4 )
    else
        print_error( memb_info )
    end
end

-- 任命家族   副帮主
function LeftClickMenuMgr:nomi_deputy( params )
	local memb_info = params[1]
	if memb_info and memb_info.ActorId then
	    require "model/GuildModel"
	    GuildModel:send_nominate_member( memb_info.ActorId, 3 )
    else
        print_error( memb_info )
    end
end

-- 任命家族   护法
function LeftClickMenuMgr:nomi_hufa( params )
	local memb_info = params[1]
	if memb_info and memb_info.ActorId then
	    require "model/GuildModel"
	    GuildModel:send_nominate_member( memb_info.ActorId, 2 )
    else
        print_error( memb_info )
    end
end

-- 任命家族   精英
function LeftClickMenuMgr:nomi_elite( params )
	local memb_info = params[1]
	if memb_info and memb_info.ActorId then
	    require "model/GuildModel"
	    GuildModel:send_nominate_member( memb_info.ActorId, 1 )
    else
        print_error( memb_info )
    end
end

-- 任命家族   成员
function LeftClickMenuMgr:nomi_follower( params )
	local memb_info = params[1]
	if memb_info and memb_info.ActorId then
	    require "model/GuildModel"
	    GuildModel:send_nominate_member( memb_info.ActorId, 0 )
    else
        print_error( memb_info )
    end
end

-- =========================================================================
-- 邮件类型切换
-- =========================================================================
-- 全部邮件
function LeftClickMenuMgr:mail_type_all(  )
	MailModel:set_mail_type( 1 )
end

-- 未读邮件
function LeftClickMenuMgr:mail_type_no_read(  )
	MailModel:set_mail_type( 2 )
end

-- 已读邮件
function LeftClickMenuMgr:mail_type_had_read(  )
	MailModel:set_mail_type( 3 )
end

------------------------------------------------------------------------
------------------------------------------------------------------------
------------------------------------------------------------------------
---复制名字
function LeftClickMenuMgr:copy_name(params)

end
---私聊界面
function LeftClickMenuMgr:private_chat(params)
	----params info : 角色ID,角色名字,角色等级,角色阵营,角色职业,角色性别
	--print("params.roleId, params.roleName, params.level,params.camp, params.job, params.sex",params.roleId, params.roleName, params.level,params.camp, params.job, params.sex)
	ChatModel:info_exit_fun()
	local private_win = UIManager:show_window("chat_private_win")
	--require "model/ChatModel/ChatPrivateChatModel"
	ChatPrivateChatModel:data_set_data_info(params.roleId, params.roleName, params.qqvip, params.level,params.camp, params.job, params.sex)
	ChatPrivateChatModel:set_cur_chat_info(params.roleId)
	ChatPrivateChatModel:reinit_panel_info()
end
---查看资料
function LeftClickMenuMgr:check_player_data(params)
	----params info : 角色ID, 角色名字
	require "control/OthersCC"
	--print("params.roleId, params.roleName",params.roleId, params.roleName)
	OthersCC:check_player_info(params.roleId, params.roleName)	
end
----添加好友
function LeftClickMenuMgr:add_friend(params)
	----params info :角色ID,角色名字
	require "control/FriendCC"
	FriendCC:request_add_friend(params.roleId,params.roleName)
end
--friend panel invote group
function LeftClickMenuMgr:friend_panel_invote_group(params)
	-- 首先判断自己有没队伍
	-- 有队伍数据就是有队伍
	if (  #TeamModel:get_team_table() > 0 ) then
		-- 邀请对方加入
		TeamCC:req_invate_join_team( params.name );
	else
		-- 申请加入队伍
		TeamCC:req_join_team( params.name );
	end
end
--friend panel business
function LeftClickMenuMgr:friend_panel_business(params)

end
--friend panel delete friend
function LeftClickMenuMgr:friend_panel_delete_friend(params)
	--params[1] = id,params[2] = type
end
---添加黑名单
function LeftClickMenuMgr:add_black_list(params)
	----params info :角色ID,角色名字
	require "control/FriendCC"
	FriendCC:send_add_black_list(params.roleId,params.roleName)
end
----添加仇人
function LeftClickMenuMgr:add_enemy(params)
	----params info :角色ID,角色名字
	require "control/FriendCC"
	FriendCC:send_add_enemy(params.roleId,params.roleName)
	---- delete friend info
	-- require "model/FriendModel/FriendModel"
	-- FriendModel:
end
----赠送鲜花
function LeftClickMenuMgr:send_flower(params)
	----params info :角色名字
	ChatModel:info_exit_fun()
	UIManager:close_all_window()
	local flower_send_win = UIManager:show_window("chat_flower_send_win")
	flower_send_win:reinit_info(params.roleName)
end
----邀请组队
function LeftClickMenuMgr:invote_to_group(params)
	--判断是否在自由赛或者争霸赛场景
	local fuben_id = SceneManager:get_cur_fuben() 
	local scene_id = SceneManager:get_cur_scene()
	if fuben_id == 71 or fuben_id == 72 or scene_id == 18 then
		GlobalFunc:create_screen_notic(Lang.screen_notic[10])	-- [40003]="比賽場景內不能組隊"
		return 
	end
	-- 首先判断自己有没队伍
	print("右键菜单..............params.name ",params.roleName );
	-- 有队伍数据就是有队伍
	TeamCC:req_invate_join_team( params.roleName );
	-- require "model/TeamModel"
	-- if (  #TeamModel:get_team_table() > 0 ) then
	-- 	-- 邀请对方加入
	-- 	TeamCC:req_invate_join_team( params[3] );
	-- else
	-- 	-- 申请加入队伍
	-- 	TeamCC:req_join_team( params[3] );
	-- end
end
-- 加入队伍
function LeftClickMenuMgr:join_in_group(params)
	--判断是否在自由赛或者争霸赛场景
	local fuben_id = SceneManager:get_cur_fuben()
	local scene_id = SceneManager:get_cur_scene()
	if fuben_id == 71 or fuben_id == 72 or scene_id == 18 then
		GlobalFunc:create_screen_notic(Lang.screen_notic[10])	-- [40003]="比賽場景內不能組隊"
		return 
	end
	TeamCC:req_join_team( params.roleName );
end

----------------------------玩家菜单------------------------------------
-- 跟随
function LeftClickMenuMgr:player_follow( params )
	local entity = EntityManager:get_entity( params.handle );
	if ( entity ) then
		local player = EntityManager:get_player_avatar(  )
		player:stop_dazuo();
		AIManager:set_state( AIConfig.COMMAND_FOLLOW,params.handle );
	end
end
----发送交易
function LeftClickMenuMgr:begin_business(params)
	--判断是否在自由赛或者争霸赛场景
	local fuben_id = SceneManager:get_cur_fuben()
	local scene_id = SceneManager:get_cur_scene()
	if fuben_id == 71 or fuben_id == 72 or scene_id == 18 then
		GlobalFunc:create_screen_notic(Lang.screen_notic[5]) 	-- [40004]="比賽場景內不能交易"
		return 
	end	
	BuniessCC:send_begin_buniess(params.roleId)
end
----删除好友或黑名单或仇人
function LeftClickMenuMgr:delete_friend_or_enemy_or_black_list(params)
	require "control/FriendCC"
	print("run delete_friend_or_enemY_or_black_list params.roleId,params.ttype",params.roleId,params.ttype)
	FriendCC:send_delete_friend_black_enemy(params.roleId,params.ttype)
end
-- 邀请入宗
function LeftClickMenuMgr:ask_other_join_guild(params)
	print("LeftClickMenuMgr:ask_other_join_guild(params.roleId,params.roleName)",params.roleId,params.roleName)
	GuildModel:ask_other_join_guild( tonumber(params.roleId), params.roleName )
end

--------------------------- 宠物菜单---------------------------------------------
-- 查看宠物资料
function LeftClickMenuMgr:show_pet( params )
	local master_id = 0;
	local pet_id = 0;
	local pet_handle = 0;
	if ( params.handle ) then
		pet_handle = params.handle;
	else
		master_id = params.master_id;
		pet_id = params.pet_id;
	end
	PetCC:req_get_other_pet_info( pet_handle,master_id, pet_id )
end
--------------------------- mount菜单---------------------------------------------
--show mount
--查看坐骑
function LeftClickMenuMgr:show_mount( params )
	MountsCC:send_check_other_mount( params.roleId, params.roleName )
end

function LeftClickMenuMgr:show_wing( params )
	-- WingCC:req_lookup_info(params.roleId, params.roleName);
	WingModel:observed_other_wing( params )
end

--改为查看式神  天降雄狮 ->查看灵器
function LeftClickMenuMgr:show_trump( params )
	--查看法宝/灵器
	FabaoCC:req_show_other_fabao_info( params.roleId, params.roleName )
	-- SpriteCC:send_check_other_sprite( params.roleId, params.roleName)
	--查看式神
	-- ElfinCC:req_see_other_elfin(params.roleId, params.roleName)
end

function LeftClickMenuMgr:get_marriage( params )
	--判断是否在自由赛或者争霸赛场景
	local fuben_id = SceneManager:get_cur_fuben()
	local scene_id = SceneManager:get_cur_scene()
	if fuben_id == 71 or fuben_id == 72 or scene_id == 18 then
		GlobalFunc:create_screen_notic(Lang.screen_notic[6]) 	--[2876]="比赛场景内不能求婚!"
		return 
	end	
	-- 向他人求婚
	MarriageModel:req_mine_get_marriage_other( params )
end
------------------------------------------------------------------------
------------------------------------------------------------------------
------------------------------------------------------------------------
-----------------------------------------------------------------
------------------------------------------------------------------------
------------------------------------------------------------------------
-- 选项的显示名称

local _item_name = {
	key1   = LangModelString[346],                    -- 示例 -- [346]="选项1"
	key2   = LangModelString[347],                    -- 示例 -- [347]="选项2"
	key3   = LangModelString[348],                    -- 示例 -- [348]="选项3"
	key4   = LangModelString[349],                    -- 示例 -- [349]="选项4"

    -- 家族 任命
	nomi_wang       = Lang.guild_info.position_name_t[5],  -- [5]="军团长"
	nomi_deputy     = Lang.guild_info.position_name_t[4],  -- [4]="副军团长"
	nomi_hufa       = Lang.guild_info.position_name_t[3],  -- [3]="尉官"
	nomi_elite      = Lang.guild_info.position_name_t[2],  -- [2]="校官"
	nomi_follower   = Lang.guild_info.position_name_t[1],  --【1】=军士

	-- 邮件类型
	mail_type_all       = LangModelString[353],  -- [353]="全部邮件"
	mail_type_no_read   = LangModelString[354],  -- [354]="未读邮件"
	mail_type_had_read  = LangModelString[355], -- [355]="已读邮件"

	--好友系统弹出菜单
	private_chat										= Lang.friend.model[8], -- [356]="#ce0e0b5窗口私聊"
	check_player_data									= Lang.friend.model[9], -- [357]="#ce0e0b5查看资料"
	--friend_panel_copy_name							= "复制名称",
	invote_to_group										= Lang.friend.model[10], -- [358]="#ce0e0b5邀请组队"
	join_in_group										= Lang.friend.model[11], -- [359]="#ce0e0b5申请入队"
	begin_business										= Lang.friend.model[12], -- [360]="#ce0e0b5发起交易"
	delete_friend_or_enemy_or_black_list				= Lang.friend.model[13], -- [361]="删除"
	add_enemy											= Lang.friend.model[14], -- [362]="拉入仇人"
	add_black_list										= Lang.friend.model[15], -- [363]="拉入黑名单"
	add_friend											= Lang.friend.model[16], -- [364]="加为好友"
	send_flower											= Lang.friend.model[17], -- [365]="赠送鲜花"



	-- 人物菜单跟随 
	player_follow= LangModelString[366], -- [366]="跟随"
	--家族
	ask_other_join_guild 								= Lang.guild[45], -- [367]="邀请入宗"
	-- 查看宠物
	show_pet											= Lang.pet.show_pet, -- [368]="查看宠物"
	--查看坐骑
	show_mount											= Lang.mounts.show_mount, -- [369]="查看坐骑"
	--
	show_wing										    = Lang.wing[53], -- [370]="查看翅膀"
	--
	show_trump											= Lang.lingqi[15], -- [371]="查看式神"

	get_marriage										= "求婚",

	-- 一键合成 宝石等级选项
	stone_lv_1	 	= string.format(Lang.forge.synth[1],1),
	stone_lv_2	 	= string.format(Lang.forge.synth[1],2),
	stone_lv_3	 	= string.format(Lang.forge.synth[1],3),
	stone_lv_4	 	= string.format(Lang.forge.synth[1],4),
	stone_lv_5	 	= string.format(Lang.forge.synth[1],5),
	stone_lv_6	 	= string.format(Lang.forge.synth[1],6),
	stone_lv_7	 	= string.format(Lang.forge.synth[1],7),
	stone_lv_8	 	= string.format(Lang.forge.synth[1],8),
	stone_lv_9	 	= string.format(Lang.forge.synth[1],9),
	stone_lv_10	 	= string.format(Lang.forge.synth[1],10),
	-- 一键合成 宝石类型选项
	stone_all		= Lang.forge.synth[2],
	stone_attack	= Lang.forge.synth[3],
	stone_phy_def	= Lang.forge.synth[4],
	stone_mag_def	= Lang.forge.synth[5],
	stone_hp		= Lang.forge.synth[6],
}

-- 选项对应的函数
-- local _item_funs_t = {
-- 	key1 = key1_fun,
-- 	key2 = key2_fun,

--     -- 家族 任命
-- 	nomi_wang       = nomi_wang_fun, 
-- 	nomi_deputy     = nomi_deputy_fun, 
-- 	nomi_hufa       = nomi_hufa_fun, 
-- 	nomi_elite      = nomi_elite_fun, 
-- 	nomi_follower   = nomi_follower_fun,
    
-- }

-- 菜单具体的选项 配置
local _menu_item_config = {
	menu1 = { { "key1", "key2", "key3", "key4", },
	          { x = 300, y = 200}  } ,-- 示例

	-- 家族任命
	guild_nominate_1 = { { "nomi_wang", "nomi_deputy", "nomi_hufa", "nomi_elite", "nomi_follower", },
	          { x = 670, y = 130}  } ,

	-- 邮件类型
	mail_type_menu = { { "mail_type_all", "mail_type_no_read", "mail_type_had_read" },
	          { x = 106, y = 280}  } ,

    ------------------------------------------------------------------------
    ------------------------------------------------------------------------
    ------------------------------------------------------------------------
    --好友系统
    ----
    my_friend_online_menu = {
    	{
    	"private_chat", 
    	"check_player_data", 
    	"invote_to_group",
    	"join_in_group",
    	--"begin_business",
    	"delete_friend_or_enemy_or_black_list",
    	"add_enemy",
    	"add_black_list",
    	"send_flower",
    	},
    	{x = 670, y = nil},
	},
	----
	my_friend_online_menu_guild = {
    	{
    	"private_chat", 
    	"check_player_data", 
    	"invote_to_group",
    	"join_in_group",
    	"ask_other_join_guild",
    	--"begin_business",
    	"delete_friend_or_enemy_or_black_list",
    	"add_enemy",
    	"add_black_list",
    	"send_flower",
    	},
    	{x = 670, y = nil},
	},
	----
	my_friend_offline_menu = {
		{
		"delete_friend_or_enemy_or_black_list",
		},
		{x = 670, y = nil},
	},

	----
	my_enemy_online_menu = {
		{
		"private_chat",
		"check_player_data",
		"add_friend",
		"delete_friend_or_enemy_or_black_list",
		--"add_black_list",
		},
		{ x = 670, y = nil},
	},

	----
	my_black_list_menu = {
		{
		"private_chat",
		"check_player_data",
		"add_friend",
		"delete_friend_or_enemy_or_black_list",
		--"add_enemy",
		},
		{ x = 670, y = nil},
	},
	----
	my_black_offline_menu = {
		{
		"delete_friend_or_enemy_or_black_list",
		},
		{ x = 670, y = nil},
	},
	----
	near_online_menu = {
		{
	    "private_chat", 
		"check_player_data", 
		"invote_to_group",
		--"begin_business",
		"add_friend",
		--"delete_friend_or_enemy_or_black_list",
		"add_enemy",
		"add_black_list",
		"send_flower",
		},
		{x = 670, y = nil},
	},
	----
	near_online_menu_guild = {
		{
	    "private_chat", 
		"check_player_data", 
		"invote_to_group",
		"ask_other_join_guild",
		--"begin_business",
		"add_friend",
		--"delete_friend_or_enemy_or_black_list",
		"add_enemy",
		"add_black_list",
		"send_flower",
		},
		{x = 670, y = nil},
	},
	----
	near_offline_menu = {
		{
		"delete_friend_or_enemy_or_black_list",
		},
		{ x = 670, y = nil},
	},

	----
	------------------------------------------------------------------------
	------------------------------------------------------------------------
	------------------------------------------------------------------------
	----聊天系统
	----
	----查看他人
	chat_other_list_menu = {
		{
		"private_chat",
		"check_player_data",
		--"chat_panel_copy_name",
		"invote_to_group",
		"join_in_group",
		"add_friend",
		"send_flower",
		},
		{ x = 670, y = nil},
	},
	----
	---
	chat_other_list_menu_guild = {
		{
		"private_chat",
		"check_player_data",
		--"chat_panel_copy_name",
		"invote_to_group",
		"join_in_group",
		"ask_other_join_guild",
		"add_friend",
		"send_flower",
		},
		{ x = 670, y = nil},
	},
	----
	----查看好友
	chat_friend_list_menu = {
		{
		"private_chat",
		"check_player_data",
		--"chat_panel_copy_name",
		"invote_to_group",
		"join_in_group",
		"delete_friend_or_enemy_or_black_list",
		"send_flower",
		},
		{ x = 670, y = nil},
	},
	----
	----
	chat_friend_list_menu_guild = {
		{
		"private_chat",
		"check_player_data",
		--"chat_panel_copy_name",
		"invote_to_group",
		"join_in_group",
		"ask_other_join_guild",
		"delete_friend_or_enemy_or_black_list",
		"send_flower",
		},
		{ x = 670, y = nil},
	},
	----
	----
	chat_my_list_menu = {
		{
		--"chat_panel_copy_name",
		},
		{ x= 670, y = 400},
	},
	----
	----
	-- chat_chanel_select = {
	-- 	{
	-- 	"chat_panel_select_near_chanel",
	-- 	"chat_panel_select_world_chanel",
	-- 	"chat_panel_select_camp_chanel",
	-- 	"chat_panel_select_xz_chanel",
	-- 	"chat_panel_select_team_chanel",
	-- 	},
	-- 	{ x = 14, y = 245},
	-- },
	-- 玩家菜单 已是好友
	player_menu = {
    	{
    	"player_follow",
    	"private_chat", 
    	"check_player_data", 
    	"begin_business",
    	"invote_to_group",
    	"join_in_group",
    	"delete_friend_or_enemy_or_black_list",
    	"add_enemy",
    	"add_black_list",
    	"send_flower",
    	"get_marriage",
    	},
    	{x = 670, y = nil},
	},
	-- 玩家菜单 不是好友
	player_menu_not_friend = {
    	{
    	"player_follow",
    	"private_chat", 
    	"check_player_data", 
    	"begin_business",
    	"invote_to_group",
    	"join_in_group",
    	"add_friend",
    	"add_enemy",
    	"add_black_list",
    	"send_flower",
    	"get_marriage",
    	},
    	{x = 670, y = nil},
	},
	-- 玩家菜单 族长
	player_menu_guild = {
    	{
    	"player_follow",
    	"private_chat", 
    	"check_player_data", 
    	"begin_business",
    	"invote_to_group",
    	"join_in_group",
    	"ask_other_join_guild",
    	"delete_friend_or_enemy_or_black_list",
    	"add_enemy",
    	"add_black_list",
    	"send_flower",
    	"get_marriage",
    	},
    	{x = 670, y = nil},
	},
	-- 玩家菜单 族长 邀请非好友
	player_menu_not_friend_guild = {
    	{
    	"player_follow",
    	"private_chat", 
    	"check_player_data", 
    	"begin_business",
    	"invote_to_group",
    	"join_in_group",
    	"ask_other_join_guild",
    	"add_friend",
    	"add_enemy",
    	"add_black_list",
    	"send_flower",
    	"get_marriage",
    	},
    	{x = 670, y = nil},
	},

	-- 宠物菜单
	pet_menu = {
		{
			"show_pet",
		},
		{x =670,y = nil},
	},
	--排行榜宠物
	top_list_pet =
	{
		{
		"private_chat",
		"check_player_data", 
		"show_pet",
		--"chat_panel_copy_name",
		"invote_to_group",
		"join_in_group",
		"ask_other_join_guild",
		"add_friend",
		"send_flower",
		},
		{ x = 670, y = nil},
	},
	--排行榜坐骑
	top_list_mount =
	{
		{
		"private_chat",
		"check_player_data", 
		"show_mount",
		--"chat_panel_copy_name",
		"invote_to_group",
		"join_in_group",
		"ask_other_join_guild",
		"add_friend",
		"send_flower",
		},
		{ x = 670, y = nil},		
	},
	----top list wing
	top_list_wing = {
		{
		"private_chat",
		"check_player_data",
		"show_wing",
		--"chat_panel_copy_name",
		"invote_to_group",
		"join_in_group",
		"add_friend",
		"send_flower",
		},
		{ x = 670, y = nil},
	},
	----top list trump(改为式神查看)  天降雄狮：灵器查看
	top_list_trump = {
		{
		"private_chat",
		"check_player_data",
		"show_trump",
		--"chat_panel_copy_name",
		"invote_to_group",
		"join_in_group",
		"add_friend",
		"send_flower",
		},
		{ x = 670, y = nil},
	},
	----一键合成，宝石等级选项
	synth_level_list = {
		{
			"stone_lv_1",
			"stone_lv_2",
			"stone_lv_3",
			"stone_lv_4",
			"stone_lv_5",
			"stone_lv_6",
			"stone_lv_7",
			"stone_lv_8",
			"stone_lv_9",
			"stone_lv_10",
		},
		{x = 320, y = nil},
	},
	----一件合成，宝石类型选项
	synth_type_list = {
		{
			"stone_all",
			"stone_attack",
			"stone_phy_def",
			"stone_mag_def",
			"stone_hp",
		},
		{x = 320, y = nil},
	},
}


--  选项回调函数的参数  
local _menu_item_params = nil

-- 菜单

-- ==============================================
-- 静态方法 
-- ==============================================
-- 显示菜单
-- menu_key:   字符串 ，用于获取具体菜单项
-- prams   :   table类型, 菜单选项对应函数的参数. 
-- menu_x, menu_y： 菜单的坐标。 可以为空。 优先使用传入坐标， 再使用配置坐标，
function LeftClickMenuMgr:show_left_menu( menu_key, params, menu_x, menu_y, if_pop_in_right)
	_menu_item_params = params           -- 保存选项参数

	require "UI/component/LeftClickMenu"

	local config_x, config_y = self:get_menu_position( menu_key )
	local pos_x = menu_x or config_x
	local pos_y = menu_y or config_y
	local adjust_y = false
	if menu_y == nil then
		adjust_y = true
	end
	 local cur_left_menu = LeftClickMenu:show_Left_click_menu( menu_key, pos_x, pos_y )
    if adjust_y then
    	local cur_size = cur_left_menu.view:getSize()
    	local win_size = { width = 960, height = 640 }
    	cur_left_menu.view:setPosition( pos_x, ( win_size.height - cur_size.height ) * 0.5 )
    end
	-- local if_disp = (if_disposable == nil and true) or if_disposable      -- 如果为 nil，if_disp设置为true， 否知设置为传入值
    -- local cur_left_menu = LeftClickMenu:show_Left_click_menu( menu_key, pos_x, pos_y )
    -- if if_pop_in_right == false then
    -- 	cur_left_menu.view:setPosition(pos_x,pos_y)
    -- else
    -- 	UIScreenPos.screen9GridPosWithAction(cur_left_menu,6)
    -- end
end

-- 获取某个菜单所有选项的table
function LeftClickMenuMgr:get_one_menu_item( menu_key )
	if _menu_item_config[ menu_key ] then
        return _menu_item_config[ menu_key ][1]
    else
    	print(" !!! error !!!  找不到 菜单项 ！！！ ", tostring( menu_key ) )
    	return {}
	end
end

-- 获取选项具体名称
function LeftClickMenuMgr:get_item_name_by_key( item_key )
	if _item_name[ item_key ] then
        return _item_name[ item_key ]
    else    
    	print(" !!! error !!!  找不到 菜单项名称！！！ ", tostring( item_key ) )
    	return ""
	end
end

-- 调用选项的函数   item_key  选项的关键字
function LeftClickMenuMgr:run_item_fun( item_key )
	if LeftClickMenuMgr[ item_key ] then
        LeftClickMenuMgr[ item_key ]( nil, _menu_item_params )
    else
    	print(" !!! error !!!  找不到 菜单项 函数！！！ ", tostring( item_key ) )
	end
end

-- 获取某个菜单所有项中，最长选项的字符数
function LeftClickMenuMgr:get_menu_max_length( menu_key )
	local ret_max_length = 0
	local menu_items = LeftClickMenuMgr:get_one_menu_item( menu_key )
	for key, value in pairs( menu_items ) do
        if string.len( _item_name[value] ) > ret_max_length then
            ret_max_length = string.len( _item_name[value] )
        end
	end
	return ret_max_length
end

-- 获取某个菜单的坐标
function LeftClickMenuMgr:get_menu_position( menu_key )
	local ret_x = 0 
	local ret_y  = 0
	if _menu_item_config[ menu_key ] and _menu_item_config[ menu_key ][2] then
        ret_x = _menu_item_config[ menu_key ][2].x or 0
        ret_y = _menu_item_config[ menu_key ][2].y or 0
	end
	return ret_x, ret_y
end

------------------------一键合成------------------------------------------------
function LeftClickMenuMgr:stone_lv_1()
	print("选择宝石等级1")
	local win = UIManager:find_visible_window("synth_confirm_win")
	if win then 
		win:set_select_lv(1,_item_name["stone_lv_1"])
	end
end
function LeftClickMenuMgr:stone_lv_2()
	print("选择宝石等级2")
	local win = UIManager:find_visible_window("synth_confirm_win")
	if win then 
		win:set_select_lv(2,_item_name["stone_lv_2"])
	end
end
function LeftClickMenuMgr:stone_lv_3()
	print("选择宝石等级3")
	local win = UIManager:find_visible_window("synth_confirm_win")
	if win then 
		win:set_select_lv(3,_item_name["stone_lv_3"])
	end
end
function LeftClickMenuMgr:stone_lv_4()
	print("选择宝石等级4")
	local win = UIManager:find_visible_window("synth_confirm_win")
	if win then 
		win:set_select_lv(4,_item_name["stone_lv_4"])
	end
end
function LeftClickMenuMgr:stone_lv_5()
	print("选择宝石等级5")
	local win = UIManager:find_visible_window("synth_confirm_win")
	if win then 
		win:set_select_lv(5,_item_name["stone_lv_5"])
	end
end
function LeftClickMenuMgr:stone_lv_6()
	print("选择宝石等级6")
	local win = UIManager:find_visible_window("synth_confirm_win")
	if win then 
		win:set_select_lv(6,_item_name["stone_lv_6"])
	end
end
function LeftClickMenuMgr:stone_lv_7()
	print("选择宝石等级7")
	local win = UIManager:find_visible_window("synth_confirm_win")
	if win then 
		win:set_select_lv(7,_item_name["stone_lv_7"])
	end
end
function LeftClickMenuMgr:stone_lv_8()
	print("选择宝石等级8")
	local win = UIManager:find_visible_window("synth_confirm_win")
	if win then 
		win:set_select_lv(8,_item_name["stone_lv_8"])
	end
end
function LeftClickMenuMgr:stone_lv_9()
	print("选择宝石等级9")
	local win = UIManager:find_visible_window("synth_confirm_win")
	if win then 
		win:set_select_lv(9,_item_name["stone_lv_9"])
	end
end
function LeftClickMenuMgr:stone_lv_10()
	print("选择宝石等级10")
	local win = UIManager:find_visible_window("synth_confirm_win")
	if win then 
		win:set_select_lv(10,_item_name["stone_lv_10"])
	end
end
--
function LeftClickMenuMgr:stone_all()
	print("选择宝石类型全部")
	local win = UIManager:find_visible_window("synth_confirm_win")
	if win then 
		win:set_select_type(0,_item_name["stone_all"])
	end
end
function LeftClickMenuMgr:stone_attack()
	print("选择宝石类型攻击")
	local win = UIManager:find_visible_window("synth_confirm_win")
	if win then 
		win:set_select_type(1,_item_name["stone_attack"])
	end
end
function LeftClickMenuMgr:stone_phy_def()
	print("选择宝石类型物理防御")
	local win = UIManager:find_visible_window("synth_confirm_win")
	if win then 
		win:set_select_type(2,_item_name["stone_phy_def"])
	end
end
function LeftClickMenuMgr:stone_mag_def()
	print("选择宝石类型法术防御")
	local win = UIManager:find_visible_window("synth_confirm_win")
	if win then 
		win:set_select_type(3,_item_name["stone_mag_def"])
	end
end
function LeftClickMenuMgr:stone_hp()
	print("选择宝石类型生命值")
	local win = UIManager:find_visible_window("synth_confirm_win")
	if win then 
		win:set_select_type(4,_item_name["stone_hp"])
	end
end
