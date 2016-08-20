-- GuildCC.lua
-- created by lyl on 2012-12-26
-- 仙宗系统

-- super_class.GuildCC()
GuildCC = {}

local is_me_cangku_to_bag =false  --是否 是自己拖出去到背包
-- c->s 10,1  申请本人帮派信息
function GuildCC:request_self_guild_info()
	local pack = NetManager:get_socket():alloc(10, 1)
	NetManager:get_socket():SendToSrv(pack)
end 

-- s->c 10,1 服务器下发本人帮派的详细信息
function GuildCC:do_result_self_guild_info( pack )
	require "struct/UserGuildInfo"
	local user_guild_info = UserGuildInfo(pack)
	GuildModel:set_user_guild_info( user_guild_info )
end

-- c->s 10,2  申请帮派成员列表
function GuildCC:request_guild_memb_list()
	local pack = NetManager:get_socket():alloc(10, 2)
	NetManager:get_socket():SendToSrv(pack)
end 

-- s->c 10,2 服务器下发帮派成员列表
function GuildCC:do_result_guild_memb_list( pack )
	local memb_online_count = pack:readInt()
	local memb_no_online_count = pack:readInt()
	local memb_infos = {}
	local all_count = memb_online_count + memb_no_online_count
	for i = 1, all_count do
		require "struct/GuildMembInfo"
        memb_infos[i] = GuildMembInfo( pack )
	end
	require "model/GuildModel"
	-- print("run do_result_guild_memb_list",memb_no_online_count)
	GuildModel:set_memb_infos( memb_infos, memb_online_count, memb_no_online_count )
	-------------
	require "model/ChatModel/ChatXZModel"
	ChatXZModel:reinit_scroll_info()

	if GuildModel:is_zongzhu() == true then 
		local win  = UIManager:find_window("guild_cangku_win")
	    if win then
	        win:update("control")--更新显示
	    end
	else
		GuildCC:req_lave_times()
	end

end

-- c->s 10,3  申请帮派列表
function GuildCC:request_guild_info_list( curr_page, num_per_page )
	local pack = NetManager:get_socket():alloc(10, 3)
	pack:writeWord(curr_page - 1)
    pack:writeWord(num_per_page)
	NetManager:get_socket():SendToSrv(pack)
end 

-- s->c 10,3 服务器下发帮派列表
function GuildCC:do_result_guild_info_list( pack )
	local guild_count = pack:readInt()
	local page_curr_num = pack:readInt()       -- 当前第几页，从0开始
	local page_total = pack:readInt()          -- 一共多少页，从0开始
    local guild_info = {}
	for i = 1, guild_count do
		require "struct/GuildInfo"
        guild_info[i] = GuildInfo( pack )
	end
	GuildModel:add_guild_info( guild_info, guild_count, page_curr_num, page_total )
end

-- c->s 10,4  申请创建帮派
function GuildCC:request_create_guild( icon_index, guild_name)
	local pack = NetManager:get_socket():alloc(10, 4)
	pack:writeWord(icon_index)
    pack:writeString(guild_name)
	NetManager:get_socket():SendToSrv(pack)
end 

-- s->c 10,4 服务器下发创建帮派结果
function GuildCC:do_result_create_guild( pack )
	local guild_id = pack:readInt()
    -- 创建成功，就重新申请玩家仙宗的数据
    -- GuildCC:request_self_guild_info()
    require "model/GuildModel"
    GuildModel:create_guild_result( guild_id )
end

-- c->s 10,5  申请 解散帮派
function GuildCC:request_dismiss_guild()
	local pack = NetManager:get_socket():alloc(10, 5)
	NetManager:get_socket():SendToSrv(pack)
end 

-- c->s 10,6  申请脱离帮派
function GuildCC:request_leave_guild()
	local pack = NetManager:get_socket():alloc(10, 6)
	NetManager:get_socket():SendToSrv(pack)
end 

-- c->s 10,7  申请 邀请玩家加入帮派
function GuildCC:request_ask_join_guild( player_id, player_name)
	-- print("GuildCC:request_ask_join_guild( player_id, player_name)")
	local pack = NetManager:get_socket():alloc(10, 7)
	pack:writeInt(player_id)
    pack:writeString(player_name)
	NetManager:get_socket():SendToSrv(pack)
end 

-- s->c 10,7 服务器 通知邀请信息，（必须回应接受还是拒绝）
function GuildCC:do_notice_ask_join( pack )
	local guild_id = pack:readInt()
	local guild_name = pack:readString()
	local asker_name = pack:readString()
	-- print(" GuildCC:do_notice_ask_join(guild_id, guild_name, asker_name)",guild_id, guild_name, asker_name)
	GuildModel:asked_join_guild( guild_id, guild_name, asker_name  )
end

-- c->s 10,8  回应服务器是否接受加入帮派
function GuildCC:request_if_accept_join( if_accept, guild_id )
	local pack = NetManager:get_socket():alloc(10, 8)
	pack:writeInt(if_accept)
    pack:writeInt(guild_id)
	NetManager:get_socket():SendToSrv(pack)
end 

-- c->s 10,9  申请加入帮派
function GuildCC:request_apply_join_guild( guild_id )
	local pack = NetManager:get_socket():alloc(10, 9)
	pack:writeInt(guild_id)
	NetManager:get_socket():SendToSrv(pack)
end 

-- s->c 10,9 申请加入帮派的结果
function GuildCC:do_result_apply_join( pack )
	local guild_id = pack:readInt()
	local result = pack:readInt()           -- 0 成功， 1 失败

    require "model/GuildModel"
    local result_bool = (result == 0)
    GuildModel:apply_join_guild_result( guild_id, result_bool )
end

-- c->s 10,10  申请加入帮派的审核结果  0 拒绝  1 接受
function GuildCC:request_apply_join_result( resp_result, player_id)
	local pack = NetManager:get_socket():alloc(10, 10)
	pack:writeInt(resp_result)
	pack:writeInt(player_id)
	NetManager:get_socket():SendToSrv(pack)
end 

-- s->c 10,10 服务器下发 申请加入帮派的审核结果
function GuildCC:do_result_join_result( pack )
	local guild_name = pack:readString()
	
end

-- c->s 10,11  申请加入帮派的消息列表
function GuildCC:request_apply_join_list()
	local pack = NetManager:get_socket():alloc(10, 11)
	NetManager:get_socket():SendToSrv(pack)
end 

-- s->c 10,11 服务器 下发申请加入帮派的消息列表
function GuildCC:do_result_apply_join_list( pack )
	local count = pack:readInt() 
	local applier_info = {}
	for i = 1, count do 
        require "struct/GuildApplierInfo"
        applier_info[i] = GuildApplierInfo( pack )
	end
	require "model/GuildModel"
	GuildModel:set_apply_infos( applier_info )
end

-- c->s 10,12  申请 升降级
function GuildCC:request_up_down_grade(player_id, position)
	local pack = NetManager:get_socket():alloc(10, 12)
	pack:writeInt(player_id)
	pack:writeInt(position)
	NetManager:get_socket():SendToSrv(pack)
end 

-- c->s 10,13  申请 开除成员
function GuildCC:request_fire_member( player_id )
	local pack = NetManager:get_socket():alloc(10, 13)
	pack:writeInt(player_id)
	NetManager:get_socket():SendToSrv(pack)
end 

-- c->s 10,14  申请 更新公告或者群聊
function GuildCC:request_flash_notice( notice_type , content )
	local pack = NetManager:get_socket():alloc(10, 14)
	pack:writeInt(notice_type)
	pack:writeString(content)
	NetManager:get_socket():SendToSrv(pack)
end 

-- c->s 10,15  申请 领取每日福利
function GuildCC:request_get_welfare()
	local pack = NetManager:get_socket():alloc(10, 15)
	NetManager:get_socket():SendToSrv(pack)
end 

-- s->c 10,15 服务器 领取帮派福利结果
function GuildCC:do_result_get_welfare( pack )
	local result = pack:readByte()
	local msg = pack:readString()
	require "model/GuildModel"
	GuildModel:get_welfare_result( result, msg )
end

-- c->s 10,16  申请 升级帮派
function GuildCC:request_upgr_guild( build_id )
	local pack = NetManager:get_socket():alloc(10,16)
	pack:writeInt(build_id)
	NetManager:get_socket():SendToSrv(pack)
end 

-- s->c 10,16 服务器 升级帮派的结果set_memb_infos
function GuildCC:do_result_upgr_guil( pack )
	local level = pack:readInt()
	require "model/GuildModel"
	GuildModel:set_self_guild_level( level )
end

-- s->c 10,17 服务器 更新帮派信息。客户端收到后，要重新申请帮派数据
function GuildCC:do_flash_guild_info( pack )
	local content_type = pack:readByte()   -- 变化的内容，对于没有打开仙宗窗口的用户，这条可以直接忽略
	require "model/GuildModel"
	GuildModel:server_guild_info_change( content_type )
end

-- c->s 10,17  申请 捐献
function GuildCC:request_donate( gold_count, money_type)
	local pack = NetManager:get_socket():alloc(10,17)
	pack:writeInt(gold_count)
	pack:writeByte(money_type)
	NetManager:get_socket():SendToSrv(pack)
end 

-- c->s 10,18  申请 在商店里购买物品
function GuildCC:request_buy_good( item_id, num )
	local pack = NetManager:get_socket():alloc(10,18)
	pack:writeInt(item_id)
	pack:writeInt(num)
	NetManager:get_socket():SendToSrv(pack)
end 

-- c->s 10,19  申请 请求仙宗等级信息，返回协议16
function GuildCC:request_guild_level()
	local pack = NetManager:get_socket():alloc(10,19)
	NetManager:get_socket():SendToSrv(pack)
end 

-- s->c 10,20 服务器 灵石数量发生改变
function GuildCC:do_stone_num_change( pack )
	local stone_count = pack:readInt()
	GuildModel:change_user_guild_info( "stone_num", stone_count )
end

-- s->c 10,21 服务器 总的帮派贡献改变
function GuildCC:do_total_cont_change( pack )
	local curr_value = pack:readInt()
	
end

-- c->s 10,22  申请 帮派聊天
function GuildCC:request_guild_chat( color, chat_content )
	local pack = NetManager:get_socket():alloc(10,22)
	pack:writeByte(color)
	pack:writeString(chat_content)
	NetManager:get_socket():SendToSrv(pack)
	-- print("GuildCC:request_guild_chat")
end 

-- s->c 10,22 服务器 帮派聊天
function GuildCC:do_result_guild_chat( pack )
	local color = pack:readByte()
	local position = pack:readByte()
	local qqvip = pack:readInt()
	local name     = pack:readString()
	local chat_content = pack:readString()
	-----
	--require "model/ChatModel/ChatXZModel"
	-- print("GuildCC:do_result_guild_chat",position,name,chat_content)
	ChatXZModel:set_chat_info(position, name, qqvip, chat_content)
end

-- c->s 10,23  申请 勾选不再显示聊天框
function GuildCC:request_sele_no_chat( if_show_chat)
	local pack = NetManager:get_socket():alloc(5, 1)
	pack:writeByte(if_show_chat)
	NetManager:get_socket():SendToSrv(pack)
end 

-- s->c 10,23 服务器 勾选不再显示聊天框
function GuildCC:do_result_no_chat( pack )
	-- TODO
	
end

-- c->s 10,24  申请 获取是否显示聊天框
function GuildCC:request_if_show_chat()
	local pack = NetManager:get_socket():alloc(10,24)
	NetManager:get_socket():SendToSrv(pack)
end 

-- s->c 10,24 服务器 是否显示聊天框
function GuildCC:do_result_if_show_chat( pack )
	local if_show_chat = pack:readByte()
	
end

-- s->c 10,25 服务器 通知帮派成员是否上线
function GuildCC:do_if_memb_on_line( pack )
	local player_id = pack:readInt()
	local player_if_online = pack:readByte()
	
end

-- c->s 10,26  申请 获取帮派公告
function GuildCC:request_get_guild_notice()
	local pack = NetManager:get_socket():alloc(10,26)
	NetManager:get_socket():SendToSrv(pack)
end 

-- s->c 10,26  服务器 获取帮派公告
function GuildCC:do_result_guild_notice( pack )
	local notice = pack:readString()
	
end

-- c->s 10,52  取消申请加入仙宗
function GuildCC:request_cancel_join_guild( guild_id, player_id )
	local pack = NetManager:get_socket():alloc(10, 52)
	-- print('取消申请:',guild_id, player_id )
	pack:writeInt(guild_id)
	pack:writeInt(player_id)
	NetManager:get_socket():SendToSrv(pack)
end 

-- s->c 10,52 取消申请加入仙宗的结果
function GuildCC:do_result_cancel_join( pack )
	local guild_id = pack:readInt()
	local result = pack:readInt()           -- 0 成功， 1 失败
	-- print('取消申请结果:' .. guild_id)
    require "model/GuildModel"
    local result_bool = (result == 0)
    GuildModel:cancel_join_guild_result( guild_id, result_bool )
end



------------------------------------------------------
---

-- c->s 10, 31
function GuildCC:client_send_guild_altar_info()
	-- print("run GuildCC:client_send_guild_altar_info---------------------------")
	local pack = NetManager:get_socket():alloc(10, 31)
	NetManager:get_socket():SendToSrv(pack)
end

-- s->c 10,31
function GuildCC:server_receive_guild_altar_info(pack)
	local gem_index = pack:readByte()
	local gem_exp = pack:readInt()
	local pet_level = pack:readByte()
	local pet_exp = pack:readInt()
	local touch_num = pack:readInt()
	local xian_guo_num = pack:readInt()
	-- print("服务器返回军旗数据")
	-- print("GuildCC:server_receive_guild_altar_info gem_index,gem_exp,pet_level,pet_exp,touch_num,xian_guo_num",gem_index,gem_exp,pet_level,pet_exp,touch_num,xian_guo_num)
	GuildModel:update_guild_altar_info(gem_index, gem_exp, pet_level, pet_exp, touch_num, xian_guo_num)
end

-- c->s 10, 32
function GuildCC:client_send_touch()
	-- print("GuildCC:client_send_touch")
	local pack = NetManager:get_socket():alloc(10, 32)
	NetManager:get_socket():SendToSrv(pack)
end

-- s->c 10, 32
function GuildCC:server_receive_player_altar_info(pack)
	local remain_num = pack:readInt()
	local find_num = pack:readInt()
	local touch_num = pack:readInt()
	-- print("GuildCC:server_receive_player_altar_info remain_num, find_num, touch_num",remain_num, find_num, touch_num)
	GuildModel:update_altar_num_info(remain_num, find_num, touch_num)
end

-- c->s 10, 33
function GuildCC:client_send_xian_guo(index)
local pack = NetManager:get_socket():alloc(10, 33)
	pack:writeInt(index)
	NetManager:get_socket():SendToSrv(pack)
end

-- c->s 10, 34
function GuildCC:client_send_find_touch_num(num)
	local pack = NetManager:get_socket():alloc(10, 34)
	pack:writeInt(num)
	NetManager:get_socket():SendToSrv(pack)
end

-- c->s 10, 35
function GuildCC:client_send_get_xian_guo_info()
	local pack = NetManager:get_socket():alloc(10, 35)
	NetManager:get_socket():SendToSrv(pack)
end

-- s->c 10, 35
function GuildCC:server_receive_xian_guo_info(pack)	
	local num = pack:readInt()
	-- print("GuildCC:server_receive_xian_guo_info num",num)
	if num <= 0 then
		return
	end
	local temp_info = {}
	for i = 1, num do
		temp_info[i] = GuildAltarInfo(pack)
	end
	GuildModel:update_guild_altar_notic_info( temp_info )
end

-- s->c 10,36
function GuildCC:server_receive_one_xian_guo_info(pack)
	local temp = GuildAltarInfo(pack)
	-- print("GuildCC:server_receive_one_xian_guo_info--------------------")
end



-- s->c 10,40
function GuildCC:server_receive_one_change_count_info(pack)
	local item_series = pack:readInt64();
	local new_num = pack:readShort();
	GuildCangKuItemModel:change_item_attr(item_series,"count",new_num)
	if is_me_cangku_to_bag == true and GuildModel:is_zongzhu() == false then--如果是自己拖出的，更新下剩余取出数量
		GuildCC:req_lave_times()
		is_me_cangku_to_bag = false
	end
end

-- c->s 10, 41
function GuildCC:client_send_guild_event_info( req_type )
	local pack = NetManager:get_socket():alloc(10, 41)
	pack:writeInt( req_type )
	NetManager:get_socket():SendToSrv(pack)
end

-- s->c 10, 41
function GuildCC:server_receive_guild_event_info(pack)
	local num = pack:readInt()
	local action_info = {}
	local idx = 1
	local req_type = GuildModel:get_action_curr_type()
	for i = 1, num do
		local temp = GuildEventInfo(pack)
		print(i, "temp.event_type=", temp.event_type)
		if req_type == 0 then
			if temp.event_type ~= 6 and temp.event_type ~= 7 and temp.event_type ~= 8	then		-- 玩家升级建筑事件不需要显示
				action_info[idx] = temp
				idx = idx + 1
			end
		elseif req_type == 1 then
			if temp.event_type ~= 8	then		-- 玩家升级建筑事件不需要显示
				action_info[idx] = temp
				idx = idx + 1
			end
		end
	end

	GuildModel:set_action_infos(action_info)
end

-- s->c 10, 42
function GuildCC:server_receive_guild_one_event_info(pack)
	local temp_info = GuildEventInfo(pack)
	local req_type = GuildModel:get_action_curr_type()
	
	if temp_info.event_type ~= 8 then
		if req_type == 0 then
			GuildModel:add_action_info( temp_info )
		elseif req_type == 1 then
			if temp_info.event_type == 6 or temp_info.event_type == 7 then
				GuildModel:add_action_info( temp_info )
			end
		end
	end
end
-----------------------------------------------------------------
-- c->s 10,37 福地之战_开启副本
function GuildCC:req_fudizhizhan_data()
	local pack = NetManager:get_socket():alloc(10, 37);
	NetManager:get_socket():SendToSrv(pack);
	print("GuildCC:req_fudizhizhan_data---")
end

-- s->c 10,37 福地之战_返回开启配置
function GuildCC:do_fudizhizhan_data(pack)

	local param ={}
	guild_times = pack:readChar();--本周帮派剩余次数
	person_times = pack:readChar();--本周个人进入剩余次数
	GuildModel:set_fuben_times(guild_times,person_times)
	local win = UIManager:find_window("guild_fuben_right")
	if win then
		win:update("data")
	end
	print(" s->c 10,37 福地之战_返回开启配置")
end


-- c->s 10,38 福地之战_开启副本
function GuildCC:req_fudizhizhan_fuben(diff)
	local pack = NetManager:get_socket():alloc(10, 38);
	pack:writeChar(diff); --难度
	NetManager:get_socket():SendToSrv(pack);
	print("GuildCC:req_fudizhizhan_fuben--------------------diff=",diff)
end
-- s->c 10,39 福地之战_开启副本
function GuildCC:do_fudizhizhan_fuben(pack)
	local diff = pack:readChar();
	print("do_fudizhizhan_fuben diff=",diff)
	print(" s->c 10,39 福地之战_开启副本")

	if diff == 0 then --打完副本后 会下发0
		GuildModel:set_fuben_btn_status(3)--
		local win = UIManager:find_window("guild_fuben_right")
		if win then
			win:update("btn")
		end		
	else --其他开启副本  会广播下发到副本难度
		GuildModel:set_fuben_diff(diff)
		local win = UIManager:find_window("guild_fuben_right")
		if win then
			win:update("xiala")
		end		
	end

end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--仙宗仙宗仓库
-- filename: GuildCangkuCC.lua
-- author: created by liuguowang on 2014-3-24
-- 功能：本文件实现仙宗仓库子系统网络数据交互

--10, 27, C->S
-- 获取仙宗仓库物品列表
function GuildCC:req_cangku_items()
	print("10, 27, C->S")
	local pack = NetManager:get_socket():alloc(10, 27);
	NetManager:get_socket():SendToSrv(pack);
end

-- 10, 27 S->C
-- 下发仙宗仓库的物品列表
function GuildCC:do_item_list (pack)
	print("服务器通知：", "下发仙宗仓库的物品列表")
	-- unsigned char, 物品的数量
	local item_count = pack:readInt();
	-- array(UserItem), 仙宗仓库的物品列表
	local items = {};
	for i=1, item_count do
		items[i] = UserItem(pack);
		print("items[i].item_id=",items[i].item_id)
	end
    GuildCangKuItemModel:set_items_date( items, item_count )
end




-- 10, 28, C->S
-- 背包拖一个物品到仙宗仓库
-- item_id: 物品的guid
-- target_id: 目标位置物品的guid, 如果为0表示放在空的格子上面
function GuildCC:req_bag_to_cangku (item_series, target_series)
	print("10, 28, C->S")
	local pack = NetManager:get_socket():alloc(10, 28);
	pack:writeInt64(item_series);
	pack:writeInt64(target_series);
	NetManager:get_socket():SendToSrv(pack);
end

-- 10, 28   S->C
-- 添加物品
function GuildCC:do_add_item (pack)
	print("服务器下发：", "仙宗仓库添加物品")
	local item = UserItem(pack);
    GuildCangKuItemModel:add_item( item )
end
-- 10, 29, C->S
-- 仙宗仓库拖一个物品到背包
-- item_id: 物品的guid
-- target_id: 目标位置物品的guid, 如果为0表示放在空的格子上面
function GuildCC:req_cangku_to_bag(item_series, target_series,select_num)
	print("10, 29, C->S")
	print("item_series=",item_series)
	print("target_series=",target_series)
	print("select_num=",select_num)
	is_me_cangku_to_bag = true
	local pack = NetManager:get_socket():alloc(10, 29);
	pack:writeInt64(item_series);
    pack:writeInt64(target_series);
    pack:writeInt(select_num);
	NetManager:get_socket():SendToSrv(pack);
end


-- 10.29, S->C
-- 删除物品
function GuildCC:do_del_item (pack)
	print("请求服务器：", "仙宗仓库删除物品")
	-- 物品的guid
	local item_series = pack:readInt64();
	GuildCangKuItemModel:remove_item_from_cangku( item_series )

	if is_me_cangku_to_bag == true   and GuildModel:is_zongzhu() == false then--如果是自己拖出的,且是非宗主，更新下剩余取出数量
		GuildCC:req_lave_times()
		is_me_cangku_to_bag = false
	end
end


-- 23.9, C->S
-- 整理仙宗仓库物品
function GuildCC:req_trim_cangku()  --aa
	print("请求服务器：", "整理仙宗仓库物品")
	local pack = NetManager:get_socket():alloc(10, 30);
	NetManager:get_socket():SendToSrv(pack);
end


-- 10.30, C->S
-- 整理仙宗仓库物品
function GuildCC:req_trim_cangku()  --aa
	print("请求服务器：", "整理仙宗仓库物品")
	local pack = NetManager:get_socket():alloc(10, 30);
	NetManager:get_socket():SendToSrv(pack);
end
-- 10.43, C->S
-- 整理仙宗仓库物品

function GuildCC:req_lave_times() 
	print("请求服务器：", "角色剩余次数")
	local pack = NetManager:get_socket():alloc(10, 43);
	NetManager:get_socket():SendToSrv(pack);
end


function GuildCC:do_lave_times(pack) 
	print("下发服务器：", "角色剩余次数")
	local times = pack:readInt();
	print("times=",times)
	local win = UIManager:find_visible_window("guild_cangku_win")
    if win then
        win:update("control",times ); --更新控件
    end
end

--c->s 请求天元之战排名榜
function GuildCC:req_tianyuan_rank_info()
	local pack = NetManager:get_socket():alloc(10, 44)
	NetManager:get_socket():SendToSrv(pack)
end

-- s->c 服务器返回天元之战排名榜
function GuildCC:server_receive_tianyuan_rank_info(pack)
	local num = pack:readInt()
	local temp_info = {}
	for i = 1, num do
		temp_info[i] = GuildTianyuanRankInfo(pack)
	end
	GuildModel:set_action_tianyuan_infos(temp_info)
end

--c->s 请求本人的天元之战排名信息
function GuildCC:req_personal_tianyuan_rank_info()
	local pack = NetManager:get_socket():alloc(10, 45)
	NetManager:get_socket():SendToSrv(pack)
end

-- s->c 服务器返回本人的天元之战排名信息
function GuildCC:server_receive_personal_tianyuan_rank_info(pack)
	local _info = GuildTianyuanRankInfo(pack)
	GuildModel:set_personal_tianyuan_info(_info)
end

-- -- 23.4, C->S
-- -- 丢弃仙宗仓库物品
-- -- item_id: 物品的guid
-- function GuildCC:req_del_item (item_id)
-- 	local pack = NetManager:get_socket():alloc(23, 4);
-- 	pack:writeUint64(item_id);
-- 	NetManager:get_socket():SendToSrv(pack);
-- end

-- -- 23.5, C->S
-- -- 扩展仙宗仓库格子数量
-- function GuildCC:req_expand_grid_count ()
-- 	local pack = NetManager:get_socket():alloc(23, 5);
-- 	NetManager:get_socket():SendToSrv(pack);
-- end

-- -- 23.6, C->S
-- -- 获取扩展仙宗仓库格子的费用列表
-- function GuildCC:req_cost_for_expand_grid ()
-- 	local pack = NetManager:get_socket():alloc(23, 6);
-- 	NetManager:get_socket():SendToSrv(pack);
-- end




-- -- 23.4, S->C
-- -- 仙宗仓库的物品数量发生改变
-- function GuildCC:do_items_changed (pack)
-- 	print("服务器通知：", "仙宗仓库的物品数量发生改变")
-- 	-- 物品的guid
-- 	local item_series = pack:readUint64();
-- 	-- 物品的新数量
-- 	local item_new_count = pack:readByte();

-- 	CangKuItemModel:change_item_attr( item_series, "count", item_new_count )
-- end

-- -- 23.5, S->C
-- -- 发送仙宗仓库扩展需要的费用
-- function GuildCC:do_cost_for_expand_cangku(pack)
-- 	print("服务器通知：", "发送仙宗仓库扩展需要的费用")
-- 	-- 需要的元宝数量
-- 	local yuanbao_count = pack:readInt();
-- 	-- 扩展的背包的格子数量
-- 	local grid_count = pack:readByte();
    
--     GuildCangKuWin:show_expand_bag_confirm_win( yuanbao_count, grid_count )
-- end

-- -- 23.7, C->S
-- -- 拆分仙宗仓库物品
-- -- item_id: 拆分物品的GUID
-- -- count: 拆分出来的物品数量
-- function GuildCC:req_seperate_cangku_item(item_id, count)
-- 	print("服务器通知：", "拆分仙宗仓库物品")
-- 	local pack = NetManager:get_socket():alloc(23, 7);
-- 	pack:writeInt64(item_id);
-- 	pack:writeByte(count);
-- 	NetManager:get_socket():SendToSrv(pack);
-- end

-- -- 23.8, C->S
-- -- 合并仙宗仓库物品
-- -- src_id: 源物品的guid
-- -- dst_id: 目标物品的guid
-- function GuildCC:req_merge_items(src_id, dst_id)
-- 	print("服务器通知：", "合并仙宗仓库物品")
-- 	local pack = NetManager:get_socket():alloc(23, 8);
-- 	pack:writeInt64(src_id);
-- 	pack:writeInt64(dst_id);
-- 	NetManager:get_socket():SendToSrv(pack);
-- end
