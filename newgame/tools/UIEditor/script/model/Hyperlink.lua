------------------------------------
------------------------------------
------------------------------------
------HJH
------超连接解析器
------2013-1-22
------说明
------ "#c%s%s%s#cffffff在万众瞩目下，激活#cfae003全身宝石级别 %d #cffffff效果，发出绚丽的#ced0ee1 %s 光环#cffffff！属性大增！ ##textbutton,#c00fe00#u1宝石镶嵌#u0#info,@@showSysWin,1,1## ", --tpStoneNoticeChat,
------超连接文本规则
------@@showSysWin.%d,%d 打开一个窗口，前一个数值代表窗口，后一个数值代表窗口中的某一页（要那个窗口提供函数，这个数值可不填），要添加新窗口数值时要与策划绡商
------@@joinGuild,%d 加入一个仙宗后一个数值为仙宗ID
------@@joinWedding,%d 加入婚姻，后面的是ID
------@@joinTeam,%u
------@@challengeSL 仙宗领地
------m%s:0:0:%s 移动到指定NPC 第一个参数是地点，第二个参数是NPC名字
------f%s:0:0:%s 速传到指定NPC 第一个参数是地点，第二个参数是NPC名字
------------------------------------
super_class.Hyperlink(Window)

local _self_script_id = nil


------------------------------------
-----------这是以前页游的一级标志位
local _first_target_function = "@"
local _first_target_move = "m"
local _first_target_view = "v"
local _first_target_fast_move = "f"
local _first_target_move_to_player_fast = "p"
local _first_target_join_team = "j"
local _first_target_h = "h"
------------------------------------
-----------这是以前页游二级标志位
local _second_target_function = "@"
local _second_target_name = "n"
local _second_target_pet = "p"
local _second_target_item = "i"
local _second_target_mount = "m"
local _second_target_pet = "p"
local _second_target_wing = "w"
------------------------------------
-----------这是以页游的三级标志位
local _third_target_open_sys_win = "@showSysWin" 				-----打开一个指定窗口
local _third_target_sl = "@challengeSL" 						-----仙宗领地
local _third_target_guide_pet = "@guidPet" 						-----
local _third_target_guide_medicine = "@guideMedicine"			-----
local _third_target_storage = "@showStorageWin"					-----我要变强界面
local _third_target_create_guild = "@createGuildNow"			-----创建仙宗
local _third_target_input_num = "@ShowInputNumber"				-----
local _third_target_input = "@ShowInput"						-----
local _third_target_new_player_num = "@checkNewPlayerNumber"	-----
local _third_target_help = "@showHelpWin"						-----帮助界面
local _third_target_join_guid = "@joinGuild" 				 	------加入仙宗
local _third_target_join_wedding = "@joinWedding"
local _third_target_join_team  = "@joinTeam"

local _string_gmatch = string.gmatch
local _string_gsub = string.gsub

------------------------------------
-----------这是以新增的标志位
------------------------------------
local _default_info_split_target = ","
------------------------------------
-- added by aXing on 2013-5-25
function Hyperlink:fini( ... )

end
------------------------------------
function Hyperlink:get_first_function_target()
	return _first_target_function
end
------------------------------------
function Hyperlink:get_first_move_target()
	return _first_target_move
end
------------------------------------
function Hyperlink:get_first_view_target()
	return _first_target_view
end
------------------------------------
function Hyperlink:get_second_name_target()
	return _second_target_name
end
------------------------------------
function Hyperlink:get_second_item_target()
	return _second_target_item
end
------------------------------------
function Hyperlink:get_second_mount_target()
	return _second_target_mount
end
------------------------------------
function Hyperlink:get_second_pet_target()
	return _second_target_pet
end
------------------------------------
function Hyperlink:get_second_wing_target()
	return _second_target_wing
end
------------------------------------
function Hyperlink:get_third_open_sys_win_target()
	return _third_target_open_sys_win
end
------------------------------------
function Hyperlink:get_third_mount_target()
	return _third_target_guide_pet
end
------------------------------------
-----------三级标志位显示窗口函数
function Hyperlink:third_show_window(arginfo)
	require "config/activity/SpecialActivityConfig"
	-- print("Hyperlink:third_show_window(arginfo)")
	-- for i=1,#arginfo do
	-- 	print(arginfo[i])
	-- end
	local winId = tonumber(arginfo[1])

	print(winId)
	--------------------------
	if winId == 1 then --装备强化
		local forg = UIManager:show_window("forge_win")
		if forg ~= nil then
			forg:change_page( tonumber(arginfo[2]) + 1 )
			if #arginfo >= 2 then
			end
		end
	elseif winId == 2 then --商城
		local mall_win = UIManager:show_window("mall_win")
		if mall_win ~= nil then
			mall_win:change_page( tonumber(arginfo[2]) + 1 )
		end
	elseif winId == 3 then --好友
		local friend = UIManager:show_window("friend_win")
	elseif winId == 4 then --技能
		local skill = UIManager:show_window("user_skill_win")
	elseif winId == 5 then --渡劫
		if GameSysModel:isSysEnabled( GameSysModel.DJ, true ) == true then
			local dj = UIManager:show_window("dujie_win")
		end
	elseif winId == 6 then --VIP
		local vip = UIManager:show_window("vipSys_win")
	elseif winId == 7 then --角色
		-- local role = UIManager:show_window("user_attr_win")
		-- if role ~= nil then
		-- 	rold:change_page( tonumber(arginfo[2]) + 1 )
		-- end
		local page = tonumber(arginfo[2]) + 1
		if page == 1 then
			UIManager:show_window("user_equip_win")
		elseif page == 2 or page == 3 then
			UIManager:show_window("user_attr_win")
		end
	elseif winId == 8 then --梦境
		if GameSysModel:isSysEnabled( GameSysModel.LOTTERY, true ) == true then
			local level = EntityManager:get_player_avatar().level
			local dream = UIManager:show_window("new_dreamland_win")

			if level < 50 then
				dream:choose_xymj_tab()
			else
				if tonumber(arginfo[2]) == 1 then
					dream:choose_yhmj_tab()
				else
					dream:choose_xymj_tab()
				end
			end
		end
	-- elseif winId == 9 then --翅膀强化预览

	elseif winId == 1003 then --春节每日限购活动
		local player = EntityManager:get_player_avatar();
		if player.level > 29 then
			require "config/activity/CommonActivityConfig" 
			DailyQuatoBuyModel:setActivityType(CommonActivityConfig.NewLonelyDay)
		    DailyQuatoBuyModel:refreshActivityId(SpecialActivityConfig.NewDailyQuatoBuy)
		    UIManager:show_window("dailyQuotaBuyWin")
		else
			GlobalFunc:create_screen_notic("30级以上才能参加该活动。");
		end

	elseif winId == 1002 then --情人节每日限购活动
		local player = EntityManager:get_player_avatar();
		if player.level > 29 then
			require "config/activity/CommonActivityConfig" 
		DailyQuatoBuyModel:setActivityType(CommonActivityConfig.ValentineDay)
   		DailyQuatoBuyModel:refreshActivityId(SpecialActivityConfig.OldDailyQuatoBuy)
        UIManager:show_window("dailyQuotaBuyWin")
		else
			GlobalFunc:create_screen_notic("30级以上才能参加该活动。");
		end
	elseif winId == 1004 then --妇女节每日限购活动
		local player = EntityManager:get_player_avatar();
		if player.level > 29 then
			require "config/activity/CommonActivityConfig" 
		DailyQuatoBuyModel:setActivityType(CommonActivityConfig.WomensDay)
   		DailyQuatoBuyModel:refreshActivityId(SpecialActivityConfig.WomanQuatoBuy)
        UIManager:show_window("dailyQuotaBuyWin")
		else
			GlobalFunc:create_screen_notic("30级以上才能参加该活动。");
		end
	elseif winId == 1005 then --劳动节每日限购活动
		local player = EntityManager:get_player_avatar();
		if player.level > 29 then
			require "config/activity/CommonActivityConfig" 
		DailyQuatoBuyModel:setActivityType(CommonActivityConfig.WorkDay)
   		DailyQuatoBuyModel:refreshActivityId(SpecialActivityConfig.WorkQuatoDay)
        UIManager:show_window("dailyQuotaBuyWin")
		else
			GlobalFunc:create_screen_notic("30级以上才能参加该活动。");
		end
	elseif winId == 10 then --仙宗
		if GameSysModel:isSysEnabled( GameSysModel.GUILD, true ) == true then
			local guild_win = UIManager:show_window("guild_win")
			if guild_win ~= nil then
			    guild_win:change_page( tonumber(arginfo[2]) + 1 )
		    end
		end

	elseif winId == 11 then --坐骑
		MountsModel:show_other_mounts_info( arginfo );

	elseif winId == 12 then --式神/法宝
		-- for i,v in ipairs(arginfo) do
		-- 	print(i,v)
		-- end
		local player_id = arginfo[2]
		local play_name = arginfo[3]
		-- print("elseif winId == 12 then --式神",player_id,play_name)
		-- SpriteCC:send_check_other_sprite(player_id,play_name)
		-- ElfinCC:req_see_other_elfin(player_id, play_name) --火影中查看式神
		local fabao = UIManager:show_window("lingqi_win")
		fabao:show_other_fabao( arginfo );
	elseif winId == 13 then --天元之战
		local tyzh = UIManager:show_window("activity_sub_win")
		tyzh:update(6)
	elseif winId == 14 then --活动
		local activity = UIManager:show_window("activity_Win")
		if activity ~= nil then
			activity:change_page( tonumber(arginfo[2]) + 1 )
		end
	elseif winId == 15 then --消费引导

	elseif winId == 16 then --新服活动

	elseif winId == 17 then --历练

	elseif winId == 18 then --兑换
		local exchange = UIManager:show_window("exchange_win")

	elseif winId == 19 then --翅膀
		if GameSysModel:isSysEnabled( GameSysModel.WING, true ) == true then
		 	-- UIManager:show_window("wing_sys_win")
		 	WingModel:openWingWin(WingModel.MINE_WING_INFO)
		end
	elseif winId == 20 then --竞技
		if GameSysModel:isSysEnabled( GameSysModel.JJC, true) == true then
			local dofatai = UIManager:show_window("doufatai_win")
		end
	elseif winId == 21 then --宠物
		if GameSysModel:isSysEnabled( GameSysModel.PET, true) == true then
			local pet = UIManager:show_window("pet_win")
			if pet ~= nil then
				local index = tonumber(arginfo[2]) + 1;
				pet:do_tab_button_method( index )
			end
		end
	elseif winId == 22 then --淘宝树 梦境
		local player = EntityManager:get_player_avatar()
		if player.level>=31 then 
	        DreamlandModel:set_dreamland_type(DreamlandModel.DREAMLAND_TYPE_TBS)
			local win = UIManager:show_window("new_dreamland_win");
			win:choose_tbmj_tba();

		else
			 GlobalFunc:create_screen_notic("淘宝树活动31级才可参与")
		end
	elseif winId == 23 then --NPC商店
		-- local npcshop = UIManager:show_window("shop_win")
		ShopWin:change_page( "drug" )
	elseif winId == 24 then --引导挂机

	elseif winId == 25 then --刷星
		ItemModel:use_item_by_item_id( 4822 )
	elseif winId == 26 then --打开跑环领奖

	elseif winId == 27 then --极品装备
		local player = EntityManager:get_player_avatar()
		-- 等级小于20级,不弹出极品装备窗口
		local can_get, had_get = MallModel:get_taozhuang_info()
		if player.level >= 20 and had_get == false then
			UIManager:show_window("jptz_dialog")
		else
			if player.level < 20 then
				GlobalFunc:create_screen_notic("20级才可参与活动")
			else
				GlobalFunc:create_screen_notic("您已参与过该活动")
			end
		end

    --美人后宫卡牌  xiehande
	elseif winId == 41 then --显示其他玩家炫耀的卡牌
		local card_id = arginfo[2]
		local star_num = arginfo[3]
		-- print("card_id star_num",card_id,star_num)

        if card_id~=nil  then
			HeluoBooksModel:show_other_meiren_tips( card_id, star_num )
        else
            local player = EntityManager:get_player_avatar();
	        if player.level < GameSysModel:get_sys_lv( GameSysModel.MEIRENHOURSE ) then
	           GlobalFunc:create_screen_notic( string.format(Lang.lingqi[16],GameSysModel:get_sys_lv( GameSysModel.MEIRENHOURSE)) );
	        else
	        	  local win  = UIManager:show_window("lingqi_win")
				   if win then
				   	 win:change_page(5)
				   end
	        end
        end



	elseif winId == 42 then --投资返利
		if GameSysModel:isSysEnabled( GameSysModel.TZFL, true) == true then
			-- UIManager:show_window( "renzhe_jijin_win" )
			TZFLModel:open_win()
		end
	elseif winId == 43 then --宠物查看
		-- 发送查看宠物的协议
		PetCC:req_get_other_pet_info( 0,tonumber(arginfo[2]),tonumber(arginfo[3] ));
	elseif winId == 44 then -- 密友抽奖
		local time_remain = FriendsDrawModel:get_activity_time()
		if time_remain == 0 then
			GlobalFunc:create_screen_notic( Lang.f_draw[2] )
		else
			UIManager:show_window("friends_draw_win")
		end
	elseif winId == 45 then -- 聚宝袋
		-- UIManager:show_window("jubao_bag_win");
		UIManager:show_window("shenmi_shop_win");
	elseif winId == 46 then -- 幸运转盘
		UIManager:show_window("luopan_win");
	elseif winId == 47 then -- 我要翻牌(修复城墙)
		UIManager:show_window("open_card_win")
	elseif winId == 51 then -- 超级团购
		-- UIManager:show_window("jubao_bag_win");
		UIManager:show_window("jing_kuang_win");
    --added by xiehande  美人后宫/卡牌
    elseif winId == 79 then
		if (GameSysModel:isSysEnabled(GameSysModel.MEIRENHOURSE ,true)) then
            MeirenHouse:show(1)
        end
	elseif winId == 81 then -- 超级团购
		-- UIManager:show_window("jubao_bag_win");
		UIManager:show_window("super_tuangou_win");
	elseif winId == 99 then -- 送花排行活动
		local player = EntityManager:get_player_avatar();
		if player.level > 30 then
			SendFlowerModel:refreshActivityId(winId)
			UIManager:show_window("sendFlowerWin");
		else
			GlobalFunc:create_screen_notic("30级以上才能参加该活动。");
		end
	elseif winId == 102 then --乾坤兑换
		UIManager:show_window("qian_kun_win");
	elseif winId == 1001 then -- 2015年情人节活动
		require "config/activity/CommonActivityConfig"  
		local t_remainTime = SmallOperationModel:getActivityRemainTime(CommonActivityConfig.ValentineDay)
		if t_remainTime > 0 then
	        ValentineDayModel:refreshActivityId(CommonActivityConfig.ValentineDay)
	        UIManager:show_window("valentineDayWin")  
		else
			GlobalFunc:create_screen_notic(Lang.screen_notic[14]);  --	[14] = "活动已经结束。"
		end
	elseif winId == 1005 then -- 2015年白色情人节活动
		require "config/activity/CommonActivityConfig"  
		local t_remainTime = SmallOperationModel:getActivityRemainTime(CommonActivityConfig.ValentineWhiteDay)
		if t_remainTime > 0 then
	        ValentineWhiteDayModel:refreshActivityId(CommonActivityConfig.ValentineWhiteDay)
	        UIManager:show_window("valentineWhiteDayWin")  
		else
			GlobalFunc:create_screen_notic(Lang.screen_notic[14]);  --	[14] = "活动已经结束。"
		end
	end
end
------------------------------------
-----------二级标志位@函数
function Hyperlink:second_target_function(info)
	local temp_info = Utils:Split( info, _default_info_split_target )
	local function_target = temp_info[1]
	local data_info = {}
	for i = 2 , #temp_info do
		data_info[i - 1] = temp_info[i]
	end
	if function_target == _third_target_open_sys_win then   --显示窗口
		Hyperlink:third_show_window(data_info)
	elseif function_target == _third_target_sl then --
		local entity = EntityManager:get_player_avatar()
		local curSceneId = SceneManager:get_cur_scene()
		local curFubenId = SceneManager:get_cur_fuben()
		-- print("curSceneId",curSceneId)
		-- print("curFubenId",curFubenId)
		if curSceneId ==  1046 then
			GlobalFunc:create_screen_notic(Lang.misc_info.InXianZongLingDi)
		else
			--local head = _first_target_move .. Lang.misc_info.XianZongGuanLiYuan
			--Hyperlink:analyze_info(head)
			GlobalFunc:ask_npc( 3, Lang.misc_info.XianZongGuanLiYuan )
		end
	elseif function_target == _third_target_guide_pet then
		UIManager:hide_window("pet_win")
	elseif function_target == _third_target_guide_medicine then
		UIManager:hide_window("bag_win")
	elseif function_target == _third_target_storage then
		local bag = UIManager:show_window("bag_win")
		local cangku = UIManager:show_window("cangku_win")
	elseif function_target == _third_target_create_guild then

	elseif function_target == _third_target_input_num then

	elseif function_target == _third_target_input then

	elseif function_target == _third_target_new_player_num then

	elseif function_target == _third_target_help then

	elseif function_target == _third_target_join_guid then ----加入仙宗
		if GuildModel:check_if_join_guild() == true then
			GlobalFunc:create_screen_notic(Lang.guild_info.join_notice_1)
		else
			if tonumber( temp_info[2] ) > 0 then
				GuildCC:request_apply_join_guild( tonumber(temp_info[2]) )
			end
		end
	elseif function_target == _third_target_join_wedding then
		local marry_id = tonumber(temp_info[2])
		MarriageModel:req_join_wedding( marry_id );
		UIManager:hide_window("marriage_win_new");
	elseif function_target == _third_target_join_team then
		local team_id = tonumber(temp_info[2])
		local num_fuben = tonumber(temp_info[3])
		-- 经过天将雄师的组队页面改版，现在num_fuben只能为1，这个字段已经没意义了，用1就行 note by gzn
		num_fuben = 1;
		TeamActivityCC:req_apply_team(team_id)
		UIManager:hide_window("chat_win");
		TeamWin:show(num_fuben)
	end
end
------------------------------------
-----------二级标志位名字函数
function Hyperlink:second_target_name(info)
	print("second_target_name",info)
	local temp_info = Utils:Split( info, _default_info_split_target )
	local myselfname = EntityManager:get_player_avatar().name
	local tempdata = { roleId = tonumber(temp_info[3]), roleName = temp_info[2], qqvip = tonumber(temp_info[10]), level = tonumber(temp_info[8]), camp = tonumber(temp_info[6]), job = tonumber(temp_info[7]), sex = tonumber(temp_info[4]) }
	if temp_info[2] == myselfname then
		--LeftClickMenuMgr:show_left_menu("chat_other_list_menu", tempdata)
		--LeftClickMenuMgr:show_left_menu("chat_my_list_menu", info)
	elseif FriendModel:is_my_friend(tempdata.roleId) == true then
		tempdata.ttype = 1
		if GuildModel:check_ask_join_right(  ) == true then
			LeftClickMenuMgr:show_left_menu("chat_friend_list_menu_guild", tempdata, 375, 180, false)
		else
			LeftClickMenuMgr:show_left_menu("chat_friend_list_menu", tempdata, 375, 180, false)
		end
	else
		if GuildModel:check_ask_join_right(  ) == true then
			LeftClickMenuMgr:show_left_menu("chat_other_list_menu_guild", tempdata, 375, 180, false)
		else
			LeftClickMenuMgr:show_left_menu("chat_other_list_menu", tempdata, 375, 180, false)
		end
	end
end
------------------------------------
-----------二级标志位查看函数
function Hyperlink:second_target_view(info)
	local second_target = string.sub( info, 1, 1 )
	local tempinfo = string.sub( info, 2, -1 )
	print("ChatModel:run_chat_info_item_fun tempinfo",tempinfo)
	local info = Utils:Split(tempinfo,",")
	if second_target == _second_target_item then  ----查看装备

		 --info arg = empyt, type, name, id, sex, vip,campId, job, level, iconId, yeallowDiamon, msgInfo
		if info ~= nil then
			local item = UserItem()
			item.series 		= tonumber(info[2])				-- 物品唯一的一个序列号
			item.item_id		= tonumber(info[3])				-- 标准物品id
			item.quality		= tonumber(info[4])				-- 物品品质等级
			item.strong			= tonumber(info[5])				-- 物品强化等级
			item.duration		= tonumber(info[6])				-- 物品耐久度
			item.duration_max	= tonumber(info[7])				-- 物品耐久度最大值
			item.count			= tonumber(info[8])				-- 此物品的数量，默认为1，当多个物品堆叠在一起的时候此值表示此类物品的数量
			item.flag			= tonumber(info[9])			-- 物品标志，使用比特位标志物品的标志，例如绑定否
			item.holes[1]		= tonumber(info[10])			-- 宝石孔
			item.holes[2]		= tonumber(info[11])
			item.holes[3]		= tonumber(info[12])
			item.deadline		= tonumber(info[13])			-- 道具使用时间
			item.void_bytes_tab = {}
			item.void_bytes_tab[1] = tonumber(info[14])
			item.void_bytes_tab[2] = tonumber(info[15])
			item.void_bytes_tab[3] = tonumber(info[16])
			item.void_bytes_tab[4] = tonumber(info[17])
			item.void_bytes_tab[5] = tonumber(info[18])
			item.void_bytes_tab[6] = tonumber(info[19])
			item.void_bytes_tab[7] = tonumber(info[20])
			item.void_bytes_tab[8] = tonumber(info[21])
			-- local void_byte 	= tonumber(info[22])
			item.smith_num		= tonumber(info[22])			-- 物品的洗炼属性开启个数
			item.smiths[1]		= {type = tonumber(info[23]),value = tonumber(info[24])}
			item.smiths[2]		= {type = tonumber(info[25]),value = tonumber(info[26])}
			item.smiths[3]		= {type = tonumber(info[27]),value = tonumber(info[28])}
			TipsModel:show_tip( 300, 200, item, nil, nil, nil, nil, nil, 1);
			--TipsWin:showTip(300, 200, item, nil, nil, false)
		end
	elseif second_target == _second_target_mount then

	elseif second_target == _second_target_pet then

	elseif second_target == _second_target_wing then  -----查看翅膀
		print("_second_target_wing,",info)
		local wing = {};
		wing.player_id = tonumber(info[2])
		wing.level = tonumber(info[3])
		wing.stage = tonumber(info[4])
		wing.star = tonumber(info[5])
		wing.score = tonumber(info[6])
		wing.modelId = tonumber(info[7])
		wing.wishes = tonumber(info[8])
		wing.attack = tonumber(info[9]);
		wing.outDefence = tonumber(info[10])
		wing.inDefence = tonumber(info[11])
		wing.hp = tonumber(info[12])
		wing.skill1_level = tonumber(info[13])
		wing.skill2_level = tonumber(info[14])
		wing.skill3_level = tonumber(info[15])
		wing.skill4_level = tonumber(info[16])
		wing.skill5_level = tonumber(info[17])
		wing.skill6_level = tonumber(info[18])
		wing.skill7_level = tonumber(info[19])
		wing.skill8_level = tonumber(info[20])
		wing.skill9_level = tonumber(info[21])

		wing.item_id = WingConfig:get_wing_item_id_by_stage(wing.stage);
		wing.is_hyperlink = true;
		TipsModel:show_tip( 400, 240, wing, nil, nil, nil, nil, nil, 1);
	end
end
------------------------------------
-----字符解析函数
-----信息组成:信息头,信息体
-----信息体为自定义,信息头与信息体中间要用_default_info_split_target分隔
-----注：由于Utils:Split函数问题分解出来的信息第一个不用
function Hyperlink:analyze_info(info)
	----------------
	require "utils/Utils"
	----------------
	local tempInfo = Utils:Split(info, _default_info_split_target)
	----------------
	if type(tempInfo) == "table" and #tempInfo >= 2 then
		----------------
		print("run analyze_info tempInfo",info)
		local first_target = string.sub( tempInfo[2], 1, 1 )
		first_target = string.lower(first_target)
		--local function_target = string.sub( tempInfo[2], 2, -1 )
		local data_target = string.sub( info, 3, -1 )
		print("first_target=",first_target)
		print("data_target=",data_target)
		----------------
		if first_target == _first_target_function then
			local second_target = string.sub( tempInfo[2], 2, 2 )
			if second_target == _second_target_function then
				Hyperlink:second_target_function(data_target)
			elseif second_target == _second_target_name then
				Hyperlink:second_target_name(data_target)
			elseif second_target == _second_target_pet then

			end
		elseif first_target == _first_target_move then
			local entity = EntityManager:get_player_avatar()
			local curSceneId = SceneManager:get_cur_scene()
			local curFubenId = SceneManager:get_cur_fuben()
			if curFubenId > 0 and curFubenId ~= 69 then
				GlobalFunc:create_screen_notic(Lang.misc_info.FuBenBuXunLu)
				return
			end
			local temp_info = Utils:Split(data_target, ":" )
			local sceneId = SceneConfig:get_id_by_name(temp_info[1])
			print("sceneId",sceneId)
			if temp_info[4] == "" then
				GlobalFunc:move_to_target_scene( sceneId, tonumber(temp_info[2]), tonumber(temp_info[3]) )
			else
				GlobalFunc:ask_npc( sceneId, temp_info[4] )
			end
		elseif first_target == _first_target_view then 			-----查看处理
			Hyperlink:second_target_view(data_target)
		elseif first_target == _first_target_fast_move then 	-----传送处理
			local entity = EntityManager:get_player_avatar()
			local curSceneId = SceneManager:get_cur_scene()
			local curFubenId = SceneManager:get_cur_fuben()
			if curFubenId > 0 then
				GlobalFunc:create_screen_notic(Lang.misc_info.FuBenBuSuChuan)
				return
			end
			local temp_info = Utils:Split(data_target, ":" )
			GlobalFunc:teleport_by_name( temp_info[1], temp_info[4] )
		elseif first_target == _first_target_move_to_player_fast then  ------速传处理
			--none
		elseif first_target == _first_target_join_team then 			------加入队伍
			--none
		elseif first_target == _first_target_h then
			--none
		end
	end
end
------------------------------------
------------------------------------
------------------------------------
------------------------------------
function Hyperlink:touch_began_function(info)

end
------------------------------------
function Hyperlink:touch_moved_function(info)

end
------------------------------------
function Hyperlink:touch_ended_function(info)

end
------------------------------------
function Hyperlink:touch_cancel_function(info)

end
------------------------------------
function Hyperlink:touch_click_function(info)
	Hyperlink:analyze_info(info)
end
------------------------------------
function Hyperlink:touch_double_click_function(info)

end
------------------------------------
function Hyperlink:message_function(eventType, arg, msgid, selfItem)
	------------------------------------
	print("eventType, arg, msgid, selfItem",eventType, arg, msgid, selfItem)
	if eventType == nil or arg == nil or msgid == nil or selfItem == nil then
		return
	end
	------------------------------------
	local item_info = selfItem:getDataInfo()
	------------------------------------
	if eventType == TOUCH_BEGAN then
		Hyperlink:touch_began_function(item_info)
		return true
	elseif eventType == TOUCH_MOVED then
		Hyperlink:touch_moved_function(item_info)
		return true
	elseif eventType == TOUCH_ENDED then
		Hyperlink:touch_ended_function(item_info)
		return true
	elseif eventType == TOUCH_CANCEL then
		Hyperlink:touch_cancel_function(item_info)
		return true
	elseif eventType == TOUCH_CLICK then
		print("run touch_click_function")
		Hyperlink:touch_click_function(item_info)
		return true
	elseif eventType == TOUCH_DOUBLE_CLICK then
		Hyperlink:touch_double_click_function(item_info)
		return true
	elseif eventType == TIMER then
		return true
	end
	------------------------------------
end
------------------------------------
------------------------------------
------------------------------------
------------------------------------
function Hyperlink:__init(window_name, texture_name, pos_x, pos_y, width, height)
	-- 初始化构建控件
	local function message_function(eventType, arg, msgid, selfItem)
		------------------------------------
		if eventType == nil or arg == nil or msgid == nil or selfItem == nil then
			return
		end
		------------------------------------
		if eventType == ITEM_DELETE then
			return
		end
		local item_info = selfItem:getDataInfo()
		------------------------------------
		if eventType == TOUCH_BEGAN then
			Hyperlink:touch_began_function(item_info)
			return true
		elseif eventType == TOUCH_MOVED then
			Hyperlink:touch_moved_function(item_info)
			return true
		elseif eventType == TOUCH_ENDED then
			Hyperlink:touch_ended_function(item_info)
			return true
		elseif eventType == TOUCH_CANCEL then
			Hyperlink:touch_cancel_function(item_info)
			return true
		elseif eventType == TOUCH_CLICK then
			Hyperlink:touch_click_function(item_info)
			return true
		elseif eventType == TOUCH_DOUBLE_CLICK then
			Hyperlink:touch_double_click_function(item_info)
			return true
		elseif eventType == TIMER then
			return true
		end
	------------------------------------
	end
	------1.07
	-- self._message_function = message_function
 --    self.view:registerScriptHandler(self._message_function)
    ------1.08
    self.view:registerScriptHandler(message_function)
    _self_script_id = self.view:getScriptHandler()
end
------------------------------------
------------------------------------
------------------------------------
------------------------------------
function Hyperlink:get_script_head()
	return _self_script_id
	-- if self.view ~= nil then
	-- 	-----1.07
	-- 	-- return GetLuaFuncID(self._message_function)
	-- 	-----1.08
	-- 	return self.view:getScriptHandler()
	-- else
	-- 	return 0
	-- end
end
------------------------------------
------------------------------------
------------------------------------
------------------------------------
----
----ignore it
----
------------------------------------
-----聊天表情信息
local ChatFaceSize = 32
local ChatFaceRelateTime = 0.2
Hyperlink.ChatFaceInfo = {
	[1] = { id = 00001, info = string.format("chat_face/%d,%d,%f,%d", 1, 2, ChatFaceRelateTime, ChatFaceSize) },
	[2] = { id = 00002, info = string.format("chat_face/%d,%d,%f,%d", 2, 2, ChatFaceRelateTime, ChatFaceSize) },
	[3] = { id = 00003, info = string.format("chat_face/%d,%d,%f,%d", 3, 2, ChatFaceRelateTime, ChatFaceSize) },
	[4] = { id = 00004, info = string.format("chat_face/%d,%d,%f,%d", 4, 2, ChatFaceRelateTime, ChatFaceSize) },
	[5] = { id = 00005, info = string.format("chat_face/%d,%d,%f,%d", 5, 2, ChatFaceRelateTime, ChatFaceSize) },
	[6] = { id = 00006, info = string.format("chat_face/%d,%d,%f,%d", 6, 2, ChatFaceRelateTime, ChatFaceSize) },
	[7] = { id = 00007, info = string.format("chat_face/%d,%d,%f,%d", 7, 2, ChatFaceRelateTime, ChatFaceSize) },
	[8] = { id = 00008, info = string.format("chat_face/%d,%d,%f,%d", 8, 2, ChatFaceRelateTime, ChatFaceSize) },
	[9] = { id = 00009, info = string.format("chat_face/%d,%d,%f,%d", 9, 4, ChatFaceRelateTime, ChatFaceSize) },
	[10] = { id = 00010, info = string.format("chat_face/%d,%d,%f,%d", 10, 6, ChatFaceRelateTime, ChatFaceSize) },
	[11] = { id = 00011, info = string.format("chat_face/%d,%d,%f,%d", 11, 2, ChatFaceRelateTime, ChatFaceSize) },
	[12] = { id = 00012, info = string.format("chat_face/%d,%d,%f,%d", 12, 5, ChatFaceRelateTime, ChatFaceSize) },
	[13] = { id = 00013, info = string.format("chat_face/%d,%d,%f,%d", 13, 2, ChatFaceRelateTime, ChatFaceSize) },
	[14] = { id = 00014, info = string.format("chat_face/%d,%d,%f,%d", 14, 8, ChatFaceRelateTime, ChatFaceSize) },
	[15] = { id = 00015, info = string.format("chat_face/%d,%d,%f,%d", 15, 5, ChatFaceRelateTime, ChatFaceSize) },
	[16] = { id = 00016, info = string.format("chat_face/%d,%d,%f,%d", 16, 2, ChatFaceRelateTime, ChatFaceSize) },
	[17] = { id = 00017, info = string.format("chat_face/%d,%d,%f,%d", 17, 2, ChatFaceRelateTime, ChatFaceSize) },
	[18] = { id = 00018, info = string.format("chat_face/%d,%d,%f,%d", 18, 2, ChatFaceRelateTime, ChatFaceSize) },
	[19] = { id = 00019, info = string.format("chat_face/%d,%d,%f,%d", 19, 2, ChatFaceRelateTime, ChatFaceSize) },
	[20] = { id = 00020, info = string.format("chat_face/%d,%d,%f,%d", 20, 2, ChatFaceRelateTime, ChatFaceSize) },
	[21] = { id = 00021, info = string.format("chat_face/%d,%d,%f,%d", 21, 2, ChatFaceRelateTime, ChatFaceSize) },
	[22] = { id = 00022, info = string.format("chat_face/%d,%d,%f,%d", 22, 1, ChatFaceRelateTime, ChatFaceSize) },
	[23] = { id = 00023, info = string.format("chat_face/%d,%d,%f,%d", 23, 2, ChatFaceRelateTime, ChatFaceSize) },
	[24] = { id = 00024, info = string.format("chat_face/%d,%d,%f,%d", 24, 2, ChatFaceRelateTime, ChatFaceSize) },
	[25] = { id = 00025, info = string.format("chat_face/%d,%d,%f,%d", 25, 4, ChatFaceRelateTime, ChatFaceSize) },
	[26] = { id = 00026, info = string.format("chat_face/%d,%d,%f,%d", 26, 2, ChatFaceRelateTime, ChatFaceSize) },
	[27] = { id = 00027, info = string.format("chat_face/%d,%d,%f,%d", 27, 6, ChatFaceRelateTime, ChatFaceSize) },
	[28] = { id = 00028, info = string.format("chat_face/%d,%d,%f,%d", 28, 2, ChatFaceRelateTime, ChatFaceSize) },
	[29] = { id = 00029, info = string.format("chat_face/%d,%d,%f,%d", 29, 7, ChatFaceRelateTime, ChatFaceSize) },
	[30] = { id = 00030, info = string.format("chat_face/%d,%d,%f,%d", 30, 2, ChatFaceRelateTime, ChatFaceSize) },
	[31] = { id = 00031, info = string.format("chat_face/%d,%d,%f,%d", 31, 2, ChatFaceRelateTime, ChatFaceSize) },
	[32] = { id = 00032, info = string.format("chat_face/%d,%d,%f,%d", 32, 2, ChatFaceRelateTime, ChatFaceSize) },
	[33] = { id = 00033, info = string.format("chat_face/%d,%d,%f,%d", 33, 2, ChatFaceRelateTime, ChatFaceSize) },
	[34] = { id = 00034, info = string.format("chat_face/%d,%d,%f,%d", 34, 2, ChatFaceRelateTime, ChatFaceSize) },
	[35] = { id = 00035, info = string.format("chat_face/%d,%d,%f,%d", 35, 2, ChatFaceRelateTime, ChatFaceSize) },
	[36] = { id = 00036, info = string.format("chat_face/%d,%d,%f,%d", 36, 2, ChatFaceRelateTime, ChatFaceSize) },
	[37] = { id = 00037, info = string.format("chat_face/%d,%d,%f,%d", 37, 2, ChatFaceRelateTime, ChatFaceSize) },
	[38] = { id = 00038, info = string.format("chat_face/%d,%d,%f,%d", 38, 4, ChatFaceRelateTime, ChatFaceSize) },
	[39] = { id = 00039, info = string.format("chat_face/%d,%d,%f,%d", 39, 2, ChatFaceRelateTime, ChatFaceSize) },
	[40] = { id = 00040, info = string.format("chat_face/%d,%d,%f,%d", 40, 5, ChatFaceRelateTime, ChatFaceSize) },
	[41] = { id = 00041, info = string.format("chat_face/%d,%d,%f,%d", 41, 2, ChatFaceRelateTime, ChatFaceSize) },
	[42] = { id = 00042, info = string.format("chat_face/%d,%d,%f,%d", 42, 2, ChatFaceRelateTime, ChatFaceSize) },
	[43] = { id = 00043, info = string.format("chat_face/%d,%d,%f,%d", 43, 4, ChatFaceRelateTime, ChatFaceSize) },
	[44] = { id = 00044, info = string.format("chat_face/%d,%d,%f,%d", 44, 2, ChatFaceRelateTime, ChatFaceSize) },
	[45] = { id = 00045, info = string.format("chat_face/%d,%d,%f,%d", 45, 2, ChatFaceRelateTime, ChatFaceSize) },
	[46] = { id = 00046, info = string.format("chat_face/%d,%d,%f,%d", 46, 2, ChatFaceRelateTime, ChatFaceSize) },
	[47] = { id = 00047, info = string.format("chat_face/%d,%d,%f,%d", 47, 2, ChatFaceRelateTime, ChatFaceSize) },
	[48] = { id = 00048, info = string.format("chat_face/%d,%d,%f,%d", 48, 2, ChatFaceRelateTime, ChatFaceSize) },
	[49] = { id = 00049, info = string.format("chat_face/%d,%d,%f,%d", 49, 2, ChatFaceRelateTime, ChatFaceSize) },
	[50] = { id = 00050, info = string.format("chat_face/%d,%d,%f,%d", 50, 4, ChatFaceRelateTime, ChatFaceSize) },
}
------------------------------------
function Hyperlink.getFace(id, size)
	local file = Hyperlink.ChatFaceInfo[id]
	-- print("file",file)

	return string.format('##animate,%s#info ##', file.info)
end

function Hyperlink.parse_face(content,postfix)
    local pat = '<(%d+)>'
    local rep_list = {}
    for face_id in _string_gmatch(content,pat) do
        rep_list[#rep_list+1] = tonumber(face_id)
    end

    for i,v in ipairs(rep_list) do
        local rep = Hyperlink.getFace(v)
        if postfix then
            rep = rep .. postfix
        end
        content = _string_gsub(content,string.format(pat,v),rep)
    end
    return content
end

------------------------------------
------------------------------------
------------------------------------
