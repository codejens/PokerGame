---------------HJH
---------------2013-1-16
---------------
ChatModel = {}
------------------
local _is_run_chat_safe_check = false
local _cur_bag_info = {}
local _cur_bag_count_info = {}
local _update_chat_face_win = true
------------------
------------------
------------------各个频道信息
local _common_info = {}
local _world_info = {}
local _camp_info = {}
local _xz_info = {}
local _group_info = {}
local _near_info = {}
local _chanel_all_info = {{}, {}, {}, {}, {}, {}}
------------------
local _info_max_num = 50
------------------
local _chanel_select = ChatConfig.Chat_chanel.CHANNEL_MAP
----------------
local _chat_win_panel = nil
local _new_line_target = "#r"
local _auto_chat_info = 1
local _normal_chat_info = 2
local _thank_chat_info = 3
----------------


--设置为全局方法，以便多处使用
 function need_money_callback(  )    
   local win = UIManager:find_visible_window("theHelper_Win")
   if win then
   	  win:need_money_func()
   else
   	  local win2 =  UIManager:show_window("theHelper_Win")
   	  win2:need_money_func()
   end
end

 function need_exp_callback(  )    
   local win = UIManager:find_visible_window("theHelper_Win")
   if win then
   	  win:need_exp_func()
   else
   	  local win2 =  UIManager:show_window("theHelper_Win")
   	  win2:need_exp_func()
   end
end


-- added by aXing on 2013-5-25
function ChatModel:fini( ... )
	_common_info = {}
	_world_info = {}
	_camp_info = {}
	_xz_info = {}
	_group_info = {}
	_near_info = {}
	_chanel_all_info = {{}, {}, {}, {}, {}, {}}
	--_chanel_select = ChatConfig.Chat_chanel.CHANNEL_MAP
	_chat_win_panel = nil
	_cur_bag_info = nil
	_cur_bag_info = {}
	_cur_bag_count_info = nil
	_cur_bag_count_info = {}
	_update_chat_face_win = true
	local chat_win = UIManager:find_window("chat_win")
	if chat_win ~= nil then
		chat_win:clear_chanel_info()
	end
end
----------------
function ChatModel:data_find_bag_count_info(id)
	for i = 1, #_cur_bag_count_info do
		if _cur_bag_count_info[i].item_id == id then
			return i
		end
	end
	return nil
end
----------------
function ChatModel:data_delete_bag_count_info(id)
	for i = 1, #_cur_bag_count_info do
		if _cur_bag_count_info[i].item_id == id then
			_cur_bag_count_info[i].count = _cur_bag_count_info[i].count - 1 
			if _cur_bag_count_info[i].count <= 0 then
				table.remove( _cur_bag_count_info, i )
				return
			end
			return
		end
	end
end
----------------
function ChatModel:init_bag_info(bag_info)
	_cur_bag_count_info = nil
	_cur_bag_count_info = {}
	for i = 1, #bag_info do
		ChatModel:data_add_bag_item( bag_info[i] )
	end
end
----------------
function ChatModel:data_delete_bag_item( id )
	for i = 1, #_cur_bag_info do
		if _cur_bag_info[i].series == id then
			local item_id = _cur_bag_info[i].item_id
			ChatModel:data_delete_bag_count_info( item_id )
			table.remove( _cur_bag_info, i )
			ChatFaceModel:set_need_clear_and_refresh_item(true)
			return
		end
	end
end
----------------
function ChatModel:data_add_bag_item( info )
	local index = ChatModel:data_find_bag_count_info( info.item_id )
	local temp_name
	local temp_index
	if index == nil then
		temp_name = ItemConfig:get_item_by_id( info.item_id ).name
		local temp_count_info = ChatTarCountStruct( info.item_id )
		temp_index = temp_count_info.count_index
		table.insert( _cur_bag_count_info, temp_count_info ) 
	else
	 	temp_name = ItemConfig:get_item_by_id( info.item_id ).name	 	
	 	_cur_bag_count_info[ index ].count = _cur_bag_count_info[ index ].count + 1
	 	_cur_bag_count_info[ index ].count_index = _cur_bag_count_info[ index ].count_index + 1
	 	temp_index = _cur_bag_count_info[ index ].count_index
	end
	local temp_info = ChatTarStruct(info.series, info.item_id, temp_name, temp_index, ChatConfig.ChatTarType.TYPE_ITEM )
	table.insert( _cur_bag_info, temp_info )
	ChatFaceModel:set_need_clear_and_refresh_item(true)
end
----------------
function ChatModel:data_find_bag_item_info_by_id(id)
	for i = 1, #_cur_bag_info do
		if _cur_bag_info[i].series == id then
			return _cur_bag_info[i]
		end
	end
	return nil
end
----------------
function ChatModel:data_find_bag_item_info_by_name( name )
	for i = 1, #_cur_bag_info do
		if _cur_bag_info[i]:chat_is_same_by_name( name ) then
			return _cur_bag_info[i]
		end
	end
	return nil
end
----------------
function ChatModel:get_bag_info()
	return _cur_bag_info
end
----------------
function ChatModel:get_update_chat_face_win()
	return _update_chat_face_win
end
----------------
function ChatModel:set_update_chat_face_win(result)
	_update_chat_face_win = result
end
----------------取得换行符
function ChatModel:get_new_line_target()
	return _new_line_target
end
----------------设置当前频道索引
function ChatModel:set_cur_chanel_select(index)
	_chanel_select = index
end
----------------取得当前频道索引
function ChatModel:get_cur_chanel_select()
	return _chanel_select
end
function ChatModel:save_msg(idx, info)
	local common_info_num = #_chanel_all_info[idx]
	if common_info_num > _info_max_num then
		table.remove(_chanel_all_info[idx], 1)
		common_info_num = #_chanel_all_info[idx]
	end
	table.insert(_chanel_all_info[idx], common_info_num+1, info)
end
function ChatModel:get_all_msg()
	return _chanel_all_info
end
----------------设置指定频道显示信息
function ChatModel:data_set_chat_chanel_info(chanel, info)
	print("ChatModel:data_set_chat_chanel_info(chanel, info)",chanel)
	---------------------
	if chanel == ChatConfig.Chat_chanel.CHANNEL_WORLD then
		if _world_info == nil then
			_world_info = {}
		end
		local world_info_num = #_world_info
		if world_info_num > _info_max_num then
			table.remove(_world_info, 1)
			world_info_num = #_world_info
		end
		-- print("ChatModel:data_set_chat_chanel_info _world_info add info")
		table.insert(_world_info, world_info_num + 1, info)
	elseif chanel == ChatConfig.Chat_chanel.CHANNEL_SCHOOL then
		if _camp_info == nil then
			_camp_info = {}
		end
		local camp_info_num = #_camp_info
		if camp_info_num > _info_max_num then
			table.remove(_camp_info, 1)
			camp_info_num = #_camp_info
		end
		-- print("ChatModel:data_set_chat_chanel_info _camp_info add info")
		table.insert(_camp_info, camp_info_num + 1, info)
	elseif chanel == ChatConfig.Chat_chanel.CHANNEL_GUILD then
		if _xz_info == nil then
			_xz_info = {}
		end
		local xz_info_num = #_xz_info
		if xz_info_num > _info_max_num then
			table.remove(_xz_info,1)
			xz_info_num = #_xz_info
		end
		-- print("ChatModel:data_set_chat_chanel_info _xz_info add info")
		table.insert(_xz_info, xz_info_num + 1, info)
	elseif chanel == ChatConfig.Chat_chanel.CHANNEL_TEAM then
		if _group_info == nil then
			_group_info = {}
		end
		local group_info_num = #_group_info
		if group_info_num > _info_max_num then
			table.remove(_group_info, 1)
			group_info_num = #_group_info
		end
		-- print("ChatModel:data_set_chat_chanel_info _group_info add info")
		table.insert(_group_info, group_info_num + 1, info)
	elseif chanel == ChatConfig.Chat_chanel.CHANNEL_MAP then
		if _near_info == nil then
			_near_info = {}
		end
		local near_info_num = #_near_info
		if near_info_num > _info_max_num then
			table.remove(_near_info, 1)
			near_info_num = #_near_info
		end
		-- print("ChatModel:data_set_chat_chanel_info _near_info add info")
		table.insert(_near_info, near_info_num + 1, info)
	--end
	---------------------
	elseif chanel == ChatConfig.Chat_chanel.CHANNEL_ALL then
		if _common_info == nil then
			_common_info = {}
		end
		local common_info_num = #_common_info
		if common_info_num > _info_max_num then
			table.remove(_common_info, 1)
			common_info_num = #_common_info
		end
		-- print("ChatModel:data_set_chat_chanel_info _common_info add info",info)
		table.insert(_common_info, common_info_num + 1, info)
	end
	---------------------
end

local function temp_test_pay()
    local _item_id  = 1
	local _userId   = RoleModel:get_login_info().user_name
	local _serverId = RoleModel:get_login_info().server_id

	local _orderId = "LionHeart_37wan-37wan".._userId.."_".._serverId.."_"..os.time();

	-- ZXLog ("-- PlatformNoPlatform 平台 ---", orderId, price,_userId,_serverId)
	-- MUtils:toast("充值中", 2048, 3)

	-- RoleModel:change_login_page( "login" )
	local json_table_temp = {}
	-- json_table_temp[ "message_type" ]	= PlatformSqw.MESSAGE_TYPE	--消息类型，必传字段
	-- json_table_temp[ "function_type" ] = PlatformSqw.FUNC_PAY
	json_table_temp[ "outorderid" ] = _orderId
	json_table_temp[ "serverId" ] = _serverId
	json_table_temp[ "pext" ] = ""
	json_table_temp[ "money" ] = _item_id
	require 'json/json'
	local jcode = json.encode( json_table_temp )
	send_message_to_java( jcode )
end
----------------打开聊天界面
function ChatModel:open_chat_win()
	-- temp_test_pay()
	local chat_win = UIManager:show_window("chat_win")
	ChatFaceModel:set_cur_atcive_win(chat_win)
	local chat_info = chat_win:get_info_target()
	local cur_select = chat_info.chanel_radio_button:getCurSelect() + 1
	local temp_info = ""
	local info_data = {_common_info, _world_info, _camp_info, _xz_info, _group_info, _near_info}
	--ChatFaceModel:set_cur_atcive_win(chat_win)
	if info_data[cur_select] ~= nil then
		for i = 1, #info_data[cur_select] do
			print("------------------------------------------------")
			print("info_data[cur_select][i]",info_data[cur_select][i])
			print("------------------------------------------------")
			chat_info:set_index_info(cur_select, info_data[cur_select][i])
			--temp_info = temp_info .. _new_line_target .. info_data[cur_select][i]
		end
		-- for i = 1, #info_data[cur_select] do
		-- 	temp_info = temp_info .. _new_line_target .. info_data[cur_select][i]
		-- end
		if cur_select == 1 then
			_common_info = nil
		elseif cur_select == 2 then
			_world_info = nil
		elseif cur_select == 3 then
			_camp_info = nil 
		elseif cur_select == 4 then
			_xz_info = nil 
		elseif cur_select == 5 then
			_group_info = nil 
		elseif cur_select == 6 then
			_near_info = nil
		end
	end
end



----------------综合按钮函数
function ChatModel:info_common_fun()
	-- local temp_url = "http://pay.qq.com/h5/index.shtml?m=buy&c=xxqgame&pf=%s&tabService=xxqgame,xxzxgp&aid=%s&u=%s&sid=%s"
	-- local open_id, access_token, pf, pf_key, pay_token = PlatformInterface:getLoginRet()
 --    local result = string.format( temp_url, tostring(pf), tostring(PlatformInterface.AppId), tostring("847053634"), tostring(open_id) )
 --    print("result",result)
 --    print("open_id", open_id)
 --    phoneGotoURL(result)	
	--print(CCTextAnalyze:getUTF8LenEx("2"))
	--ChatModel:set_common_info("#cb4f000【仙宗】#cffffff##textbutton,abc,,3oi,#info,do##")
	--GlobalFunc:create_screen_run_notic( "天元城宝光一现，竟然是仙界“淘宝树”降临~！极品功夫熊猫、大量稀有道具应有尽有，开放时间7月17日更新后至7月23日，时间有限，千万不要错过哦~！（详情请点击天元城中心“淘宝树”）")
	--QQVipInterface:QQVipInterface_Recharge_Game_Vip_Function()
	-- ChatModel:set_cur_chanel_select(ChatConfig.Chat_chanel.CHANNEL_ALL)
	local chat_win = UIManager:find_visible_window("chat_win")
	if chat_win ~= nil then
		
		chat_win:set_index_info_scroll_visible(1)
		print("_common_info",_common_info)
		if _common_info ~= nil then
			print("run info_common_fun #_common_info",#_common_info)
			local info_num = #_common_info
			if info_num > 0 then 
				for i = 1 , #_common_info do
					local tempinfo = ""
					tempinfo = tempinfo .. _new_line_target .. _common_info[i]
					chat_win:get_info_target():set_index_info( 1, tempinfo)
				end
				_common_info = nil				
			end
		end
	end
end
----------------世界按钮函数
function ChatModel:info_world_fun()
	-- ChatModel:set_cur_chanel_select(ChatConfig.Chat_chanel.CHANNEL_WORLD)
	local chat_win = UIManager:find_visible_window("chat_win")
	if chat_win ~= nil then
		chat_win:set_index_info_scroll_visible(2)
		
		if _world_info ~= nil then
			--print("run info_world_fun #_world_info",#_world_info)
			local info_num = #_world_info
			if info_num > 0 then 
				for i = 1 , #_world_info do
					local tempinfo = ""
					tempinfo = tempinfo .. _new_line_target .. _world_info[i]
					chat_win:get_info_target():set_index_info( 2, tempinfo)
				end
				_world_info = nil				
			end
		end
	end
end
----------------阵营按钮函数 
function ChatModel:info_camp_fun()
	local chat_win = UIManager:find_visible_window("chat_win")
	if chat_win ~= nil then
		chat_win:set_index_info_scroll_visible(3)
		
		if _camp_info ~= nil then
			--print("run info_camp_fun #_camp_info",#_camp_info)
			local info_num = #_camp_info
			if info_num > 0 then
				for i = 1 , #_camp_info do
					local tempinfo = ""
					tempinfo = tempinfo .. _new_line_target .. _camp_info[i]
					chat_win:get_info_target():set_index_info( 3, tempinfo)
				end
				_camp_info = nil
				
			end
		end
	end
end
----------------仙宗按钮函数
function ChatModel:info_zx_fun()
	-- ChatModel:set_cur_chanel_select(ChatConfig.Chat_chanel.CHANNEL_GUILD)
	local chat_win = UIManager:find_visible_window("chat_win")
	if chat_win ~= nil then
		chat_win:set_index_info_scroll_visible(4)
		
		if _xz_info ~= nil then
			--print("run info_zx_fun #_xz_info",#_xz_info)
			local info_num = #_xz_info
			if info_num > 0 then
				for i = 1 , #_xz_info do
					local tempinfo = ""
					tempinfo = tempinfo .. _new_line_target .. _xz_info[i]
					chat_win:get_info_target():set_index_info( 4, tempinfo)
				end
				_xz_info = nil
				
			end
		end
	end
end
----------------队伍按钮函数 
function ChatModel:info_group_fun()
	-- ChatModel:set_cur_chanel_select(ChatConfig.Chat_chanel.CHANNEL_TEAM)
	local chat_win = UIManager:find_visible_window("chat_win")
	if chat_win ~= nil then
		chat_win:set_index_info_scroll_visible(5)
		
		if _group_info ~= nil then
			--print("run info_group_fun #_group_info",#_group_info)
			local info_num = #_group_info
			if info_num > 0 then
				for i = 1 , #_group_info do
					local tempinfo = ""
					tempinfo = tempinfo .. _new_line_target .. _group_info[i]
					chat_win:get_info_target():set_index_info( 5, tempinfo)
				end
				_group_info = nil
				
			end
		end
	end
end
----------------附近按钮函数
function ChatModel:info_near_fun()
	-- ChatModel:set_cur_chanel_select(ChatConfig.Chat_chanel.CHANNEL_MAP)
	local chat_win = UIManager:find_visible_window("chat_win")
	if chat_win ~= nil then
		chat_win:set_index_info_scroll_visible(6)
		print("run info_near_fun #_near_info",_near_info)
		if _near_info ~= nil then
			print("run info_near_fun #_near_info",#_near_info)
			local info_num = #_near_info
			if info_num > 0 then
				--print("#_near_info",#_near_info)
				for i = 1 , #_near_info do
					local tempinfo = ""
					tempinfo = tempinfo .. _new_line_target .. _near_info[i]
					chat_win:get_info_target():set_index_info( 6, tempinfo)
				end
				--print("tempinfo",tempinfo)
				_near_info = nil
				
			end
		end
	end
end
----------------发言按钮函数 
function ChatModel:info_chat_fun()
	-- local chat_win = UIManager:find_visible_window("chat_win")
	-- if chat_win ~= nil then
	-- 	local chat_info = chat_win:get_info_target()
	-- 	local chat_insert = chat_win:get_insert_target()
	-- 	chat_info.view:setIsVisible(true)
	-- 	chat_insert.view:setIsVisible(true)
	-- 	chat_info:set_chat_to_chat_visible(false)
	-- 	chat_win:set_info_timer(0.01)
	-- 	ChatFaceModel:set_chat_face_type(1)
	-- 	local face_win = UIManager:show_window("chat_face_win")
	-- 	face_win:set_exit_btn_visible(false)
	-- 	local face_win_pos = face_win:getPosition()
	-- 	face_win.view:setPosition(face_win_pos.x, 8 - 200 - 24-5)
	-- 	-- face_win:clear_scroll()
	-- 	-- face_win:refresh_scroll()
	-- end
end
----------------聊天信息定时器函数
function ChatModel:info_timer_fun()
	-- local perstept		= 10
	-- local minsizey		= 235
	-- local chat_face = UIManager:find_window("chat_face_win")
	-- local chat_win = UIManager:find_window("chat_win")
	-- local chat_info = chat_win:get_info_target()
	-- local chat_input = chat_win:get_insert_target()
	-- local chatinfosize 	= chat_info:getSize()
	-- local chatinfopos	= chat_info:getPosition()
	-- local chatinputpos 	= chat_input:getPosition()
	-- local chatfacepos  	= chat_face:getPosition()
	-- local tempsizey 	= chatinfosize.height - perstept
	-- if chatinfosize.height - perstept < minsizey then
	-- 	perstept = chatinfosize.height - minsizey
	-- 	chat_info.view:setTimer(0)
	-- end
	-- chatinfosize.height = chatinfosize.height - perstept
	-- chat_info:setSize(chatinfosize.width, chatinfosize.height)
	-- chatinfopos.y = chatinfopos.y + perstept
	-- chat_info:setPosition(chatinfopos.x, chatinfopos.y)
	-- chatinputpos.y = chatinputpos.y + perstept
	-- chat_input:setPosition(chatinputpos.x, chatinputpos.y)
	-- chatfacepos.y = chatfacepos.y + perstept
	-- chat_face:setPosition(chatfacepos.x, chatfacepos.y)
	-- chat_info:adjustPos(0, -perstept)
end
----------------
function ChatModel:info_common_scroll_create_fun(index)

end
----------------
function ChatModel:info_world_scroll_create_fun(index)

end
----------------
function ChatModel:info_camp_scroll_create_fun(index)

end
----------------
function ChatModel:info_zx_scroll_create_fun(index)

end
----------------
function ChatModel:info_group_scroll_create_fun(index)

end
----------------
function ChatModel:info_near_scroll_create_fun(index)

end
----------------聊天界面退出函数
function ChatModel:run_exit_chat_win()
	-- local chat_face = UIManager:show_window("chat_face_win")
	-- local face_pos = chat_face:getPosition()
	-- local face_scroll_info = chat_face:get_scroll_info()
	-- if face_pos.y > 0 then
	-- 	chat_face:setPosition(face_pos.x, face_pos.y - face_scroll_info.height)
	-- end
	-- UIManager:hide_window("chat_face_win")
	-- UIManager:hide_window("chat_chanel_select_win")
end
----------------
function ChatModel:run_open_chat_win()
	-- local chat_win = UIManager:find_visible_window("chat_win")
	-- local chat_info = chat_win:get_info_target()
	-- local chat_input = chat_win:get_insert_target()
	-- chat_input.view:setIsVisible(false)
	-- local maxsizey		= 460
	-- local chatinfosize 	= chat_info:getSize()
	-- local chatinfopos	= chat_info:getPosition()
	-- local chatinputpos 	= chat_input:getPosition()
	-- if chatinfosize.height  < maxsizey then
	-- 	local disy = maxsizey - chatinfosize.height
	-- 	chatinfosize.height = maxsizey
	-- 	chat_info:setSize(chatinfosize.width, chatinfosize.height)
	-- 	chatinfopos.y = chatinfopos.y - disy
	-- 	chat_info:setPosition(chatinfopos.x, chatinfopos.y)
	-- 	chatinputpos.y = chatinputpos.y - disy
	-- 	chat_input:setPosition(chatinputpos.x, chatinputpos.y)
	-- 	chat_info:adjustPos(0, disy)
	-- end
	-- chat_info:set_chat_to_chat_visible(true)
end
----------------聊天信息栏退出定时器函数
function ChatModel:info_exit_fun()
	-- local chat_win = UIManager:find_visible_window("chat_win")
	-- if chat_win == nil then
	-- 	return
	-- end
	-- local chat_face = UIManager:show_window("chat_face_win")
	-- local chat_info = chat_win:get_info_target()
	-- local chat_input = chat_win:get_insert_target()
	-- chat_input.view:setIsVisible(false)
	-- local maxsizey		= 460
	-- local chatinfosize 	= chat_info:getSize()
	-- local chatinfopos	= chat_info:getPosition()
	-- local chatinputpos 	= chat_input:getPosition()
	-- local chatfacepos  	= chat_face:getPosition()
	-- if chatinfosize.height  < maxsizey then
	-- 	local disy = maxsizey - chatinfosize.height
	-- 	chatinfosize.height = maxsizey
	-- 	chat_info:setSize(chatinfosize.width, chatinfosize.height)
	-- 	chatinfopos.y = chatinfopos.y - disy
	-- 	chat_info:setPosition(chatinfopos.x, chatinfopos.y)
	-- 	chatinputpos.y = chatinputpos.y - disy
	-- 	chat_input:setPosition(chatinputpos.x, chatinputpos.y)
	-- 	chatfacepos.y = chatfacepos.y - disy
	-- 	chat_face:setPosition(chatfacepos.x, chatfacepos.y)
	-- 	chat_info:adjustPos(0, disy)
	-- end
	-- chat_info:set_chat_to_chat_visible(true)
	UIManager:hide_window("chat_win")
	UIManager:hide_window("chat_face_win")
	UIManager:hide_window("chat_chanel_select_win")
	-- MenusPanel:set_chat_panel_visible(true)
end
----------------
----------------
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
----------------
----------------chat input model
----------------
----------------聊天输入框当前频道按钮函数 
function ChatModel:input_cur_chanel_fun()
	if ChatChanelSelectModel:get_show_type() ~= 2 then UIManager:toggle_window("chat_chanel_select_win") end
end
----------------
----------------聊天输入栏删除按钮函数
function ChatModel:input_delete_fun()
	local chat_win = UIManager:find_window("chat_win")
	local input = chat_win:get_insert_target()
	input:set_edit_box_info("")
end
---------------聊天输入栏取得自身位置按钮函数
function ChatModel:get_self_pos_info()
	local entity = EntityManager:get_player_avatar()
	local curSceneId = SceneManager:get_cur_scene()
	local curFubenId = SceneManager:get_cur_fuben()
	local locate = ""
	-- print("curFubenId",curFubenId)
	if curFubenId ~= nil and curFubenId > 0 then
		-- print("run if")
		locate = SceneConfig:get_fuben_by_id(curFubenId).scenes[1].area[1].name
	else
		locate = SceneConfig:get_scene_by_id(curSceneId).scencename
	end
	local msginfo = locate .. Lang.chat.bracket[1] .. tostring(math.ceil(entity.model.m_x)) .. ":" .. tostring(math.ceil(entity.model.m_y)) .. Lang.chat.bracket[2] -- [1]="【" -- [2]="】"
	local posinfo = { msginfo, locate, tostring(math.ceil(entity.model.m_x)), tostring(math.ceil(entity.model.m_y)) }
	--print("entity.model.m_x,entity.model.m_y",entity.model.m_x,entity.model.m_y,"entity.x,entity.y",entity.x,entity.y)
	local locateinfo = string.format("%s%d%s%d%s%d%s%s,%s,%s,%s%s",
	--posinfo[1],
	ChatConfig.message_split_target.CHAT_INFO_SPLITE_TARGET,
	ChatConfig.ChatSpriteType.TYPE_TEXTBUTTON, ChatConfig.message_split_target.CHAT_INFO_HEAD_TARGET,
	ChatConfig.ChatAdditionInfo.TYPE_POSITION, ChatConfig.message_split_target.CHAT_INFO_HEAD_TARGET,
	0, ChatConfig.message_split_target.CHAT_INFO_HEAD_TARGET,
	Hyperlink:get_first_move_target(),
	posinfo[2], posinfo[3], posinfo[4],
	ChatConfig.message_split_target.CHAT_INFO_SPLITE_TARGET )
	return locateinfo
end
----------------
----------------聊天输入栏自身位置按钮函数
function ChatModel:input_pos_fun()
	local chat_win = UIManager:find_window("chat_win")
	local input = chat_win:get_insert_target()
	local tempinfo = input:get_edit_box_info()
	local posinfo = ChatModel:get_self_pos_info()
	ChatCC:send_chat(_chanel_select, 0, posinfo)
end
----------------
----------------聊天输入栏表情按钮函数
function ChatModel:input_face_fun()
	ChatFaceModel:set_cur_atcive_win(UIManager:find_window("chat_win"))
	--require "model/ChatModel/ChatFaceModel"
	local last_face_type = ChatFaceModel:get_chat_face_type()
	local face_win = UIManager:find_visible_window("chat_face_win")
	ChatFaceModel:set_chat_face_type(1)
	if last_face_type ~= 3 then
		UIManager:toggle_window("chat_face_win", true)
	end
end
----------------
----------------聊天输入栏背包按钮函数 
function ChatModel:input_bag_fun()
	--require "model/ChatModel/ChatFaceModel"
	local last_face_type = ChatFaceModel:get_chat_face_type()
	ChatFaceModel:set_chat_face_type(2)
	local face_win = UIManager:find_visible_window("chat_face_win")
	-- local chanel_select = UIManager:find_visible_window("chat_chanel_select_win")
	if last_face_type ~= 4 then
		UIManager:toggle_window("chat_face_win", true)
	end
end
----------------
----------------聊天输入栏发送按钮函数 
function ChatModel:input_send_fun()
	local chat_win = UIManager:find_window("chat_win")
	local input = chat_win:get_insert_target()
	local msg = input:get_edit_box_info_ex()
	--print("msg:",msg)
	if msg == "" then
		return
	end
	--print("ChatModel input_send_fun before msg",msg)
	msg = ChatModel:format_chat_send_info( msg )
	--print("ChatModel input_send_fun after msg",msg)
	ChatCC:send_chat(_chanel_select, 0, msg)
	input:set_edit_box_info("")
end
----------------
----------------聊天输入栏退出按钮函数
function ChatModel:input_exit_fun()
	-- local chat_win = UIManager:find_window("chat_win")
	-- UIManager:hide_window("chat_chanel_select_win")
	-- local input = chat_win:get_insert_target()
	-- input.view:setTimer(0.01)
end
----------------
----------------聊天输入栏退出按钮定时器函数
function ChatModel:input_timer_fun()
	-- local perstept		= 10
	-- local maxsizey		= 460
	-- local chat_face = UIManager:find_window("chat_face_win")
	-- local chat_win = UIManager:find_window("chat_win")
	-- local chat_info = chat_win:get_info_target()
	-- local chat_input = chat_win:get_insert_target()
	-- local chanel_select = chat_win:get_chanel_select_target()
	-- local chatinfosize 	= chat_info:getSize()
	-- local chatinfopos	= chat_info:getPosition()
	-- local chatinputpos 	= chat_input:getPosition()
	-- local chatfacepos  	= chat_face:getPosition()
	-- if chatinfosize.height + perstept > maxsizey then
	-- 	perstept = maxsizey - chatinfosize.height 
	-- 	chat_input.view:setTimer(0)
	-- 	chat_input.view:setIsVisible(false)
	-- 	UIManager:hide_window("chat_face_win")
	-- 	chat_info:set_chat_to_chat_visible(true)
	-- 	ChatFaceModel:hide_face_fun(chat_win)
	-- end
	-- chatinfosize.height = chatinfosize.height + perstept
	-- chat_info:setSize(chatinfosize.width, chatinfosize.height)
	-- chatinfopos.y = chatinfopos.y - perstept
	-- chat_info:setPosition(chatinfopos.x, chatinfopos.y)
	-- chatinputpos.y = chatinputpos.y - perstept
	-- chat_input:setPosition(chatinputpos.x, chatinputpos.y)
	-- chatfacepos.y = chatfacepos.y - perstept
	-- chat_face:setPosition(chatfacepos.x, chatfacepos.y)
	-- chat_info:adjustPos(0,perstept)
end
----------------
----------------
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-------------------------格式化聊天框频道信息
function ChatModel:format_chat_chanel_info(chanelId)
	local returnInfo = {chanelIndex = 0 ,chanelName = ""}
	if chanelId == ChatConfig.Chat_chanel.CHANNEL_SECRE then
		returnInfo.chanelIndex = nil
	elseif chanelId == ChatConfig.Chat_chanel.CHANNEL_HEARSAY then
		returnInfo.chanelIndex = 2
		returnInfo.chanelName = Lang.chanel_info[chanelId + 1]
	elseif chanelId == ChatConfig.Chat_chanel.CHANNEL_SPEAKER then
		returnInfo.chanelIndex = nil
	elseif chanelId == ChatConfig.Chat_chanel.CHANNEL_GUILD then
		returnInfo.chanelIndex = 4
		returnInfo.chanelName = Lang.chanel_info[chanelId + 1]--"#cb4f000【仙宗】"
	elseif chanelId == ChatConfig.Chat_chanel.CHANNEL_TEAM then
		returnInfo.chanelIndex = 5
		returnInfo.chanelName = Lang.chanel_info[chanelId + 1]--"#cfe9ccb【队伍】"
	elseif chanelId == ChatConfig.Chat_chanel.CHANNEL_MAP then
		returnInfo.chanelIndex = 6
		returnInfo.chanelName = Lang.chanel_info[chanelId + 1]--"#cfefefe【附近】"
	elseif chanelId == ChatConfig.Chat_chanel.CHANNEL_WORLD then
		returnInfo.chanelIndex = 7
		returnInfo.chanelName = Lang.chanel_info[chanelId + 1]--"#c2eebdb【世界】"
	elseif chanelId == ChatConfig.Chat_chanel.CHANNEL_SCHOOL then
		returnInfo.chanelIndex = 8
		returnInfo.chanelName = Lang.chanel_info[chanelId + 1]--"#cb4f000【阵营】"
	elseif chanelId == ChatConfig.Chat_chanel.CHANNEL_SYSTEM then
		returnInfo.chanelIndex = 9
		returnInfo.chanelName = Lang.chanel_info[chanelId + 1]--"#cff0000【系统】"
	elseif chanelId == ChatConfig.Chat_chanel.CHANNEL_SOS then
		returnInfo.chanelIndex = nil
	end
	return returnInfo
end
-------------------------格式化聊天框阵营信息
function ChatModel:format_chat_camp_info(campId)
	-----
	local temp_info = Lang.camp_info_ex[campId]
	local returnInfo = { campName = temp_info.name[1], color = temp_info.color }
	--print("campId",campId)
	-- if campId == GameConfig.CAMP_XIAOYAO then
	-- 	returnInfo.color = "#cff1493"
	-- 	returnInfo.campName = "#cff1493[逍遥]"
	-- elseif campId == GameConfig.CAMP_XINGCHEN then
	-- 	returnInfo.color = "#c00c0ff"
	-- 	returnInfo.campName = "#c00c0ff[星辰]"
	-- elseif campId == GameConfig.CAMP_YIXIAN then
	-- 	returnInfo.color = "#c00ff00"
	-- 	returnInfo.campName = "#c00ff00[逸仙]"
	-- end
	return returnInfo
end
-------------------------格式化聊天名字信息
function ChatModel:format_chat_name_info(msgInfo, color, name, id, sex, vip, campId, job, level, iconId, yeallowDiamon)
	local vip_info = QQVipInterface:get_qq_vip_platform_info(yeallowDiamon)
	local vip_img_info = QQVipInterface:get_qq_vip_image_info(yeallowDiamon)
	-- local vip_info = QQVIPName:get_user_qq_vip_info(yeallowDiamon)
	-- local vip_img_info = QQVIPName:get_qq_vip_image_info(yeallowDiamon)
	local info = ""
	if vip_info.is_vip == 1 or vip_info.is_super_vip == 1 then
		if vip_info.is_year_vip == 1 then
			info = string.format("##image,-1,-1,%s####image,-1,-1,%s####textbutton,%s%s#info,%s%s,%s,%s,%s,%s,%s,%s,%s,%s,%s##:%s",
					vip_img_info.vip_icon,vip_img_info.year_icon,color, name, 
					Hyperlink:get_first_function_target(), Hyperlink:get_second_name_target(),
					name, id, sex, vip, campId, job, level, iconId, yeallowDiamon, msgInfo)
		else
			info = string.format("##image,-1,-1,%s####textbutton,%s%s#info,%s%s,%s,%s,%s,%s,%s,%s,%s,%s,%s##:%s",
					vip_img_info.vip_icon,color, name, 
					Hyperlink:get_first_function_target(), Hyperlink:get_second_name_target(),
					name, id, sex, vip, campId, job, level, iconId, yeallowDiamon, msgInfo)
		end
	else
		if vip_info.is_year_vip == 1 then
			info = string.format("##image,-1,-1,%s####textbutton,%s%s#info,%s%s,%s,%s,%s,%s,%s,%s,%s,%s,%s##:%s",
					vip_img_info.year_icon,color, name, 
					Hyperlink:get_first_function_target(), Hyperlink:get_second_name_target(),
					name, id, sex, vip, campId, job, level, iconId, yeallowDiamon, msgInfo)
		else
			info = string.format("##textbutton,%s%s#info,%s%s,%s,%s,%s,%s,%s,%s,%s,%s,%s##:%s",color, name, 
					Hyperlink:get_first_function_target(), Hyperlink:get_second_name_target(),
					name, id, sex, vip, campId, job, level, iconId, yeallowDiamon, msgInfo)
		end		
	end
	return info
end
-----------------向服务器发送聊天信息
function ChatModel:send_chat_info(chanelId, needMoney, chatMsg)
	ChatCC:send_chat(chanelId, needMoney, chatMsg)
end
-----------------向服务器发私聊信息
function ChatModel:send_private_chat_info(id, needMoney, name, chatMsg)
	ChatCC:send_private_chat(id, needMoney, name, chatMsg)
end
-----------------向服务器发送GM公告
function ChatModel:send_gm_chat_info(chatMsg, pos)
	ChatCC:sent_gm_chat(chatMsg, pos)
end

function ChatModel:set_common_info(info)
	-- print("info",info)
	local chat_win = UIManager:find_visible_window("chat_win")
	local chat_info = chat_win:get_info_target()
	chat_info:set_index_info(1, info)
end
-----------------
function ChatModel:check_safe(msg)
	if _is_run_chat_safe_check == false then
		return msg
	end
	print("msg",msg)
	local msg_num = string.len(msg)
	local cur_index = 1
	local info_index = 0
	-- print("ChatModel:check_safe msg_num",msg_num)
	for i = 1, msg_num do
		-- print("------------------------------")
		local temp_info = string.sub( msg, cur_index, cur_index )
		if not temp_info or temp_info == '' then
			return nil
		end
		local _len = ZXTexAn:shareTexAn():getUTF8Len(temp_info)

		if info_index + _len > msg_num then
			-- print("chatModel:check_safe fail--------------info_index",info_index,_len)
			return nil
		else
			-- print("temp_len:",_len)
			info_index = info_index + _len
			cur_index = cur_index + _len
			-- print("L 699:i",i)
			i = i + _len
			-- print("i",i,_len)
			-- print("cur_index",cur_index,_len)
			if cur_index -1 >= msg_num then
				break
			end
		end
	end
	if cur_index - 1 == msg_num then

	-- print("chatModel:check_safe OK-----------")
	return msg
	else
		return nil
	end
end
-----------------服务器向客户端发送聊天信息
function ChatModel:receive_normal_chat_info(id, chanelId, sex, vip, campId, job, level, iconId, yeallowDiamon, name, chatMsg)
	-- print("chanelId:",chanelId)
	chatMsg = ChatModel:check_safe(chatMsg)
	if chatMsg == nil then
		return false
	end
	local tempChanelInfo = ChatModel:format_chat_chanel_info(chanelId)
	local tempCampInfo = ChatModel:format_chat_camp_info(campId)
	local tempSexInfo = Lang.sex_info[sex + 1]
	local tempMsgInfo = ChatModel:AnalyzeInfo(chatMsg)
	-- print("ChatMode:receive_normal_chat_info tempMsgInfo",tempMsgInfo)
	local tempNameInfo = ChatModel:format_chat_name_info(tempMsgInfo, tempCampInfo.color, name,
						id, sex, vip, campId, job, level, iconId, yeallowDiamon)	
	local tempstring = string.format("%s%s%s%s%s",tempChanelInfo.chanelName, tempCampInfo.color, tempCampInfo.campName, tempSexInfo, tempNameInfo)
	-- print("ChatModel:receive_normal_chat_info tempstring",tempstring)
	local is_sys = false
	if chanelId == ChatConfig.Chat_chanel.CHANNEL_SYSTEM then
		is_sys = true
	end
	-- MenusPanel:set_chat_panel_text(tempstring, is_sys)
	MenusPanel:setDialogInfo( tempstring, is_sys )
	--print("run receive_normal_chat_info chanelid:",tempChanelInfo.chanelIndex)
	local chat_win = UIManager:find_visible_window("chat_win")
	--print("run receive_normal_chat_info chat_win:",chat_win)
	if chat_win ~= nil then
		local chat_info = chat_win:get_info_target()
		local cur_select = chat_info.chanel_radio_button:getCurSelect() + 1
		print("tempChanelInfo.chanelIndex:",tempChanelInfo.chanelIndex)
		print("cur_select",cur_select)
		print("tempstring:",tempstring)
		local chanel_select = {
			[1] = 100,
			[2] = 7,
			[3] = 8,
			[4] = 4,
			[5] = 5,
			[6] = 6,
		}
		if chanel_select[cur_select] == tempChanelInfo.chanelIndex then
			chat_info:set_index_info(cur_select, tempstring)
			if cur_select ~= 1 then
				ChatModel:data_set_chat_chanel_info(ChatConfig.Chat_chanel.CHANNEL_ALL, tempstring)
			end
		elseif cur_select == 1 then
			chat_info:set_index_info(1, tempstring)
			ChatModel:data_set_chat_chanel_info(chanelId, tempstring)
		else
			ChatModel:data_set_chat_chanel_info(chanelId, tempstring)
			ChatModel:data_set_chat_chanel_info(ChatConfig.Chat_chanel.CHANNEL_ALL, tempstring)
		end
	else
		ChatModel:data_set_chat_chanel_info(chanelId, tempstring)
		ChatModel:data_set_chat_chanel_info(ChatConfig.Chat_chanel.CHANNEL_ALL, tempstring)
	end
	return true
	--_chat_win_panel:setChatInfoIndexMsg(tempChanelInfo.chanelIndex,tempstring)
end
-----------------服务器向客户端发送系统提示
function ChatModel:receive_sys_chat_info(level, showPos, chatMsg)
	-- 1, //只在右侧提示栏显示
    -- 2, //屏幕中央，用于强化到6级之类的全服公告
    -- 3, //弹出框
    -- 4, //公告栏，用于GM发通知 --传闻
    -- 5, //短消息，在屏幕中央，会自动消失
    -- 6, //温馨提示
    -- 7, //Gm提示信息
    -- 8, //左侧聊天栏里，用于一些系统公告在聊天栏显示
    --print("run receive sys chat info")
    chatMsg = ChatModel:check_safe(chatMsg)
	if chatMsg == nil then
		return
	end
    local tempPos = showPos
    local tempMsgInfo = ChatModel:AnalyzeInfo(chatMsg)
    -- print("ChatModel:receive_sys_chat_info chatMsg",chatMsg)
    -- print("ChatModel:receive_sys_chat_info tempMsgInfo",tempMsgInfo)
  	if tempPos > 0 then
	    local tempPosInfo = { 128, 64, 32, 16, 8, 4, 2, 1 }
	    for i = 1 , #tempPosInfo do
	    	--print("tempPos",tempPos)
	    	if tempPos == 0 then
	    		break
	    	end
	    	local hit_target = false
			if tempPos >= tempPosInfo[1] and hit_target == false then 						--- 8 ---128
				local tempstring = string.format("%s%s",Lang.chanel_info[10], chatMsg)
				--ChatModel:data_set_chat_chanel_info(ChatConfig.Chat_chanel.CHANNEL_ALL, tempstring)
				--MenusPanel:set_chat_panel_text(tempstring)
				local chat_win = UIManager:find_visible_window("chat_win")
				if chat_win ~= nil then
					local chat_info = chat_win:get_info_target()
					local cur_select = chat_info.chanel_radio_button:getCurSelect() + 1
					if cur_select == 1 then
						chat_win:get_info_target():set_index_info( 1, tempstring)
					else
						ChatModel:data_set_chat_chanel_info(ChatConfig.Chat_chanel.CHANNEL_ALL, tempstring)
					end
				else
					ChatModel:data_set_chat_chanel_info(ChatConfig.Chat_chanel.CHANNEL_ALL, tempstring)
				end
				tempPos = tempPos - tempPosInfo[1]
				hit_target = true
			elseif tempPos >= tempPosInfo[2] and hit_target == false then 				---- 7 ----64
				tempPos = tempPos - tempPosInfo[2]
				hit_target = true
				GlobalFunc:create_screen_run_notic( chatMsg)
				--require "UI/main/MenusPanel"
				--MenusPanel:set_chat_panel_text(tempMsgInfo, true)
			elseif tempPos >= tempPosInfo[3] and hit_target == false then 				---- 6 ----32
				tempPos = tempPos - tempPosInfo[3]
				hit_target = true
				--require "GlobalFunc"
				-- GlobalFunc:create_screen_notic(tempMsgInfo)
				--xiehande modified  by 2015-1-7 全局修改代价很大 这里做写死特殊处理 别喷
				--天降雄狮修改  如果是铜币不足/银两不足/经验不足 做我要变强处理
                if tempMsgInfo =="铜币不足" then
                	 local confirmWin_temp = ConfirmWin2:show( nil, 13, Lang.screen_notic[11],  need_money_callback, nil, nil )
                elseif tempMsgInfo =="经验不足" then
                	 local confirmWin_temp = ConfirmWin2:show( nil, 14, Lang.screen_notic[12],  need_exp_callback, nil, nil )
                elseif tempMsgInfo =="银两不足" then
               	 	 local confirmWin_temp = ConfirmWin2:show( nil, 15, Lang.screen_notic[13],  need_money_callback, nil, nil )
                else
                	GlobalFunc:create_screen_notic(tempMsgInfo)
                end
			elseif tempPos >= tempPosInfo[4] and hit_target == false then 				---- 5 ----16
				tempPos = tempPos - tempPosInfo[4]
				hit_target = true
				--require "GlobalFunc"
				-- GlobalFunc:create_screen_notic(tempMsgInfo)
				--xiehande modified  by 2015-1-7 全局修改代价很大 这里做写死特殊处理 别喷
				--天降雄狮修改  如果是铜币不足/银两不足/经验不足 做我要变强处理
          	if tempMsgInfo =="铜币不足" then
                	 local confirmWin_temp = ConfirmWin2:show( nil, 13, Lang.screen_notic[11],  need_money_callback, nil, nil )
                elseif tempMsgInfo =="经验不足" then
                	 local confirmWin_temp = ConfirmWin2:show( nil, 14, Lang.screen_notic[12],  need_exp_callback, nil, nil )
                elseif tempMsgInfo =="银两不足" then
               	 	 local confirmWin_temp = ConfirmWin2:show( nil, 15, Lang.screen_notic[13],  need_money_callback, nil, nil )
                else
                	GlobalFunc:create_screen_notic(tempMsgInfo)
                end

			elseif tempPos >= tempPosInfo[5] and hit_target == false then 				---- 4 ----8
				tempPos = tempPos - tempPosInfo[5]
				hit_target = true
				--require "UI/main/MenusPanel"
				--MenusPanel:set_chat_panel_text(tempMsgInfo)
				--GlobalFunc:create_screen_notic(chatMsg)
				local tempstring = string.format("%s%s",Lang.chanel_info[2], chatMsg)
				--ChatModel:data_set_chat_chanel_info(ChatConfig.Chat_chanel.CHANNEL_ALL, tempstring)
				--MenusPanel:set_chat_panel_text(tempstring)
				local chat_win = UIManager:find_visible_window("chat_win")
				if chat_win ~= nil then
					local chat_info = chat_win:get_info_target()
					local cur_select = chat_info.chanel_radio_button:getCurSelect() + 1
					if cur_select == 1 then
						chat_win:get_info_target():set_index_info( 1, tempstring)
					else
						ChatModel:data_set_chat_chanel_info(ChatConfig.Chat_chanel.CHANNEL_ALL, tempstring)
					end
				else
					ChatModel:data_set_chat_chanel_info(ChatConfig.Chat_chanel.CHANNEL_ALL, tempstring)
				end
			elseif tempPos >= tempPosInfo[6] and hit_target == false then 				---- 3 ----4
				tempPos = tempPos - tempPosInfo[6]
				hit_target = true
				--require "UI/main/MenusPanel"
				--MenusPanel:set_chat_panel_text(tempMsgInfo)
				NormalDialog:show(chatMsg,nil,2)
			elseif tempPos >= tempPosInfo[7] and hit_target == false then 				---- 2 ----2
				tempPos = tempPos - tempPosInfo[7]
				hit_target = true
				--require "GlobalFunc"
				GlobalFunc:create_center_notic(chatMsg)
			elseif tempPos >= tempPosInfo[8] and hit_target == false then 				---- 1 ----1
				tempPos = tempPos - tempPosInfo[8]
				hit_target = true
				--require "UI/main/MenusPanel"
				-- MenusPanel:set_chat_panel_text(chatMsg, true)
				MenusPanel:setDialogInfo( chatMsg, true )
			end
		end
	else
		local tempstring = string.format("%s%s",Lang.chanel_info[10], tempMsgInfo)
		local chat_win = UIManager:find_visible_window("chat_win")
		if chat_win ~= nil then
			local chat_info = chat_win:get_info_target()
			local cur_select = chat_info.chanel_radio_button:getCurSelect() + 1
			if cur_select == 1 then
				chat_win:get_info_target():set_index_info( 1, tempstring)
				--chat_win:setChatInfoIndexMsg(1,tempstring)
			else
				ChatModel:data_set_chat_chanel_info(ChatConfig.Chat_chanel.CHANNEL_ALL, tempstring)
			end
		else
			ChatModel:data_set_chat_chanel_info(ChatConfig.Chat_chanel.CHANNEL_ALL, tempstring)
		end	
	end
	--print("end receive sys info")
end
-----------------服务器向客户端发送私聊信息
function ChatModel:receive_private_chat_info(id, sex, job, campId, level, iconId, groupId, qqvip, name, chatMsg)
	--print("ChatModel:receive_private_chat_info, id, sex, job, campId, level, iconId, groupId, qqvip, name, chatMsg",id, sex, job, campId, level, iconId, groupId, qqvip, name, chatMsg)
	chatMsg = ChatModel:check_safe(chatMsg)
	if chatMsg == nil then
		return
	end
	-- require "model/FriendModel/FriendPersonalSetModel"
	-- require "model/FriendModel/FriendModel"
	local reject_chat = FriendPersonalSetModel:get_reject_other()
	local auto_chat = FriendPersonalSetModel:get_auto_chat()
	--print("begin run ChatModel:format_private_chat_message_info")
	local temp_msg = ChatModel:format_private_chat_message_info(chatMsg)
	--print("end run ChatModel:format_private_chat_message_info")
	local chat_msg = chatMsg
	local receive_auto_chat = FriendPersonalSetModel:get_receive_auto_chat()
	----check is auto chat
	if type(temp_msg) == 'table' and #temp_msg > 1 then
		if tonumber(temp_msg[1]) == ChatConfig.PrivateChatType.TYPE_THANK_CHAT_INFO and EntityManager:get_player_avatar().name == name then
			return
	 	elseif tonumber(temp_msg[1]) == ChatConfig.PrivateChatType.TYPE_AUTO_CHAT_INFO then--_auto_chat_info then
	 		if EntityManager:get_player_avatar().name ~= name then
		 		if receive_auto_chat == true then
					return
				end
		 		FriendPersonalSetModel:set_receive_auto_chat(true)
		 		receive_auto_chat = true
		 		chat_msg = temp_msg[2]
		 	else
		 		return
		 	end
		else
			chat_msg = temp_msg[2]
		end
	else
		FriendPersonalSetModel:set_receive_auto_chat(false)
		receive_auto_chat = false
		chat_msg = chatMsg
	end
	------check is friend chat
	if reject_chat == true and FriendModel:is_my_friend(id) == false then
		return	
	end
	-----send auto chat
	if auto_chat == true and receive_auto_chat == false and name ~= EntityManager:get_player_avatar().name then
		local auto_msg = FriendPersonalSetModel:get_auto_chat_msg()
		auto_msg = string.format("%d%s%s",ChatConfig.PrivateChatType.TYPE_AUTO_CHAT_INFO, ChatConfig.message_split_target.CHAT_INFO_PRIVAT_TARGET, auto_msg)
		ChatCC:send_private_chat(id, 0, "", auto_msg)
	end
	local private_chat_win = UIManager:find_visible_window("chat_private_win")
	local private_chat_scroll = UIManager:find_visible_window("chat_private_scroll")
	--print("receive_private_chat_info private_chat_win=",private_chat_win)
	if private_chat_win ~= nil or private_chat_scroll ~= nil then
		--print("set whisper timer 0")
		UserPanel:set_whisper_btn_visible(false)
		UserPanel:set_whisper_btn_timer(0)
	else
		--print("set whisper timer 0.5")
		UserPanel:set_whisper_btn_visible(true)
		UserPanel:set_whisper_btn_timer(0.5)
	end
	-- if _chat_win_panel:get_private_chat_is_active() == false then
	-- 	_chat_win_panel:initPrivateChatInfo(name, level, campId, job, id, sex)
	-- end
	--local tempMsgInfo = ChatModel:AnalyzeInfo(chat_msg)
	--print("begin run ChatPrivateChatModel:format_private_chat_info")
	local tempstring = ChatPrivateChatModel:format_private_chat_info(name, chat_msg, qqvip)
	--print("format_private_chat_info tempstring",tempstring)
	--require "model/ChatModel/ChatPrivateChatModel"
	ChatPrivateChatModel:set_private_chat_info( id, name, qqvip, level, campId, job, sex, tempstring )
	-- print("ChatMode:receive_private_chat_info",tempstring)
	--_chat_win_panel:setChatPrivateChatMsg(tempstring)
	SoundManager:playUISound('private_chat',false)
end
-----------------服务器向客户端发送附近非玩家信息
function ChatModel:receive_near_npc_chat_info(handle, chatMsg)
	return
end
-----------------服务器向客户端发送公告信息
function ChatModel:receive_announcement_chat_info(chatMsg, showPos)
	return
end
-----------------服务器向客户端发送VIP表情信息
function ChatModel:receive_vip_icon_chat_info(handle, iconId)
	return
end
------------------服务器向客户端发送弹出飞出提示信息
function ChatModel:receive_fly_chat_info(chatMsg)
	return
end
------------------服务器向客户端发送灵泉信息
function ChatModel:receive_happy_time_chat_info(chatMsg)
	return
end
------------------服务器向客户端发送弹最后一条信息
function ChatModel:receive_last_chat_info(id, chanelId, sex, vip, campId, job, level, iconId, yeallowDiamon, name, chatMsg)
	return
end
--------------------------------
----聊天解包
---第一数值代表精灵类型，第二数值代表
function ChatModel:AnalyzeInfo(chatMsg)
	-- print("ChatModel:AnalyzeInfo chatMsg",chatMsg)
	require "utils/Utils"
	local tarInfo = Utils:Split(chatMsg, ChatConfig.message_split_target.CHAT_INFO_SPLITE_TARGET)
	local result = ""
	for i = 1 , #tarInfo do 
		--print("tarInfo[i]:",tarInfo[i])
		local tempInfo = Utils:Split(tarInfo[i], ChatConfig.message_split_target.CHAT_INFO_HEAD_TARGET)
		if #tempInfo > 3 then
			--print(string.format("tempInfo[1]=%s,tempInfo[2]=%s,tempInfo[3]=%s,tempInfo[4]=%s",tempInfo[1],tempInfo[2],tempInfo[3],tempInfo[4]))
			local spriteType = tonumber(tempInfo[1])
			local addInfoType = tonumber(tempInfo[2])
			-- print("spriteType",spriteType)
			--print("addInfoType",addInfoType)
			local addInfo = tempInfo[3]
			local special = false
			------------------
			if spriteType == ChatConfig.ChatSpriteType.TYPE_BUTTON then
				special = true
				result = result .. "##button"
			elseif spriteType == ChatConfig.ChatSpriteType.TYPE_TEXTBUTTON then
				special = true
				result = result .. "##textbutton"
			elseif spriteType == ChatConfig.ChatSpriteType.TYPE_ANIMATE then
				special = true
				result = result .. "##animate"
			end
			------------------
			if addInfoType == ChatConfig.ChatAdditionInfo.TYPE_FACE then
				require "model/Hyperlink"
				local file = Hyperlink.ChatFaceInfo[tonumber(addInfo)]
				-- print("file",file)
				result = result .. "," .. file.info
			end
			------------------
			if addInfoType == ChatConfig.ChatAdditionInfo.TYPE_ITEM and spriteType == ChatConfig.ChatSpriteType.TYPE_TEXTBUTTON then
				local itemName = ItemConfig:get_item_name_by_item_id(tonumber(addInfo))
				local tempInfo = Utils:Split(tempInfo[4], ",")
				local itemColor = ItemConfig:get_item_color(tonumber(tempInfo[4]) + 1)
				result = string.format("%s,[#u1#c%s%s#u0#cffffff]#info,", result, itemColor, itemName)
			end
			------------------
			if spriteType == ChatConfig.ChatSpriteType.TYPE_TEXTBUTTON and addInfoType == ChatConfig.ChatAdditionInfo.TYPE_POSITION then
				local position_info = Utils:Split( tempInfo[4], ",")
				result = string.format( Lang.chat.mode_str[1], result, position_info[2], tonumber(position_info[3]) / 32, tonumber(position_info[4]) / 32 ) -- [1]="%s,#cffd700#u1%s【%d:%d】#u0#info,"
				tempInfo[4] = string.format("%s%s:%s:%s:%s",position_info[1], position_info[2], position_info[3], position_info[4],"")
			end
			------------------
			if addInfoType == ChatConfig.ChatAdditionInfo.TYPE_MOUNT and spriteType == ChatConfig.ChatSpriteType.TYPE_TEXTBUTTON then
				local petName = MountsConfig:get_mount_data_by_id( tonumber(addInfo) )
				result = string.format( Lang.chat.mode_str[2], result, petName.name ) -- [2]="%s,#cfff000#u1【%s】#u0#info,"
			end

			if addInfoType == ChatConfig.ChatAdditionInfo.TYPE_SPRITE and spriteType == ChatConfig.ChatSpriteType.TYPE_TEXTBUTTON then
				local sprite_name = SpriteModel:get_spritename_by_modelid(tonumber(addInfo))
				result = string.format( Lang.chat.mode_str[2], result, sprite_name) -- [2]="%s,#cfff000#u1【%s】#u0#info,"
			end

		    if addInfoType == ChatConfig.ChatAdditionInfo.TYPE_BOOK and spriteType == ChatConfig.ChatSpriteType.TYPE_TEXTBUTTON then
				result = string.format( "%s,#cfff000#u1【%s】#u0#info,", result, addInfo )
			end

			------------------
			if addInfoType == ChatConfig.ChatAdditionInfo.TYPE_FABAO and spriteType == ChatConfig.ChatSpriteType.TYPE_TEXTBUTTON then
				local fabaoName = FabaoConfig:get_fabao_name( tonumber(addInfo) )
				result = string.format( Lang.chat.mode_str[2], result, fabaoName ) -- [2]="%s,#cfff000#u1【%s】#u0#info,"
			end
			------------------
			if addInfoType == ChatConfig.ChatAdditionInfo.TYPE_WING and spriteType == ChatConfig.ChatSpriteType.TYPE_TEXTBUTTON then
				local wing_name = WingConfig:get_wing_name( tonumber(addInfo) )
				result = string.format( "%s,#cff66cc#u1%s#u0#info,", result, wing_name )
			end
			------------------
			if addInfoType == ChatConfig.ChatAdditionInfo.TYPE_PET and spriteType == ChatConfig.ChatSpriteType.TYPE_TEXTBUTTON then
				local pet_name = "#c"..addInfo;
				-- print("pet_name = ",pet_name)
				--local pet_name = MonsterConfig:get_monster_by_id( pet_id ).name
				result = string.format( "%s,#cff66cc#u1%s#u0#info,", result, pet_name )
			end
			------------------
			result = result .. tempInfo[4]
			------------------
			if special == true then
				result = result .. "##"
			end
			------------------
		else
			result = result .. tarInfo[i]
		end
	end
	-- print("result",result)
	return result
end
--------------------------------格式化私聊信息
function ChatModel:format_private_chat_message_info(info)
	require "utils/Utils"
	-- print("info",info)
	-- print("ChatConfig.message_split_target.CHAT_INFO_PRIVAT_TARGET",ChatConfig.message_split_target.CHAT_INFO_PRIVAT_TARGET)
	return Utils:Split(info, ChatConfig.message_split_target.CHAT_INFO_PRIVAT_TARGET)
end
--------------------------------
--------------------------------
function ChatModel:format_chat_info_from_data( spriteType, addtionType, addtionInfo, msgInfo )
	local temp_info = string.format( "%d%s%d%s%d%s,msgInfo",
	 spriteType, ChatConfig.message_split_target.CHAT_INFO_HEAD_TARGET,
	 addtionType, ChatConfig.message_split_target.CHAT_INFO_HEAD_TARGET,
	 addtionInfo, ChatConfig.message_split_target.CHAT_INFO_HEAD_TARGET,
	 msgInfo)
	return temp_info
end
--------------------------------
--------------------------------格式化跑马灯与主屏公告内容
function ChatModel:format_screen_and_center_notic_info(info)
	-- print("format_screen_and_center_notic_info",info)
	local temp_begin = 1
	local temp_end = string.len(info)
	local temp_info = ""
	local cur_info = info
	local target_info = ""
	local hit_target = false
	---------
	for temp_begin = 1, temp_end do
		local k,l = string.find(cur_info,"##")
		if k == nil and l == nil then
			if temp_info ~= "" then
				return temp_info
			else
				return info
			end
		end
		--print("k,l",k,l)
		---------
		if k ~= l then
			if hit_target == true then
				hit_target = false
			else
				hit_target = true
			end
		end
		--print("hit_target",hit_target)
		---------
		if k <= 0 then
			k = k + 1
		end
		---------
		if hit_target == true then
			temp_info = temp_info .. string.sub( cur_info, temp_begin, k - 1 )
			cur_info = string.sub( cur_info, l, -1)
			temp_begin = l
		else
			local split_target = string.sub( cur_info, temp_begin, k - 1 )
			local split_info = Utils:Split( split_target, "," )
			local m,n = string.find( split_info[2], "#info" )
			temp_info = temp_info .. string.sub( split_info[2], 1, m - 1 )
			cur_info = string.sub( cur_info, l, -1 )
			temp_begin = l
		end
		-- print("cur_info",cur_info)
		-- print("temp_begin", temp_begin)
		-- print("temp_info", temp_info)
	end
	---------
 	-- print("format finish temp_info",temp_info)
	return temp_info
end
--------------------------------
--------------------------------
function ChatModel:format_chat_content_info()
	local chat_win = UIManager:find_visible_window("chat_win")
	if chat_win ~= nil then
		local temp_info = chat_win:get_insert_target():get_edit_box_info()
	end
end
--------------------------------
--------------------------------格式化手机输入框输入完成信息，可用于生成对应对象
function ChatModel:format_chat_finish_edit_info(info)
	local result = ""
	local face_begin_index = nil
	local item_begin_index = nil
	for i = 1 , string.len(info) do
		local ascii_index = string.byte( info[i] )
		if ascii_index == 0x3c then
			face_begin_index = i
		elseif ascii_index == 0x3e then
			local face_info = string.sub( face_begin_index, i )
		end
	end	
end
--------------------------------
--------------------------------
function ChatModel:format_chat_send_info(info)
	-- print("run format_chat_send_info info=",info)
	local result = ""
	local face_begin_index = nil
	local item_begin_index = nil
	local cur_info_index = 1
	for i = 1 , string.len(info) do
		-- print("info[i]",string.sub(info, i, i))
		local ascii_index = string.byte( string.sub(info, i, i) )
		if ascii_index == 0x3c then ----------------------<
			face_begin_index = i + 1
			if cur_info_index ~= i then
				local temp_info = string.sub( info, cur_info_index, i - 1 )
				local temp_info_len = string.len(temp_info)
				if temp_info_len > 1 or ( string.len(temp_info) <= 1 and string.byte(temp_info) ~= 0x3e and string.byte(temp_info) ~= 0x5d ) then
					result = result .. ChatConfig.message_split_target.CHAT_INFO_SPLITE_TARGET .. temp_info
					-- print("chat model L 1159 result",result)
				end
				cur_info_index = i
			end
		elseif ascii_index == 0x3e then -------------------->
			if face_begin_index ~= nil then
				local face_info = string.sub( info, face_begin_index, i - 1 )
				-- print("chat model L 1166 face_info",face_info)
				face_begin_index = nil
				local face_struct = ChatTarStruct( tonumber(face_info), 0, "", 0, ChatConfig.ChatTarType.TYPE_FACE )
				local face_send_info = face_struct:format_send_info()
				-- print("chat model L 1170 face_send_info",face_send_info)
				cur_info_index = i + 1
				result = result .. ChatConfig.message_split_target.CHAT_INFO_SPLITE_TARGET .. face_send_info
				-- print("chat model L 1173 result",result)
			else
				face_begin_index = nil
				if cur_info_index ~= i then
					local temp_info = string.sub( info, cur_info_index, i )
					local temp_info_len = string.len(temp_info)
					if temp_info_len > 1 or ( string.len(temp_info) <= 1 and string.byte(temp_info) ~= 0x3e and string.byte(temp_info) ~= 0x5d ) then
						result = result .. ChatConfig.message_split_target.CHAT_INFO_SPLITE_TARGET .. temp_info
						-- print("chat model L 1181 result",result)
					end
					cur_info_index = i + 1
				end
			end
		elseif ascii_index == 0x5b then --------------------[
			item_begin_index = i + 1
			if cur_info_index ~= i then
				local temp_info = string.sub( info, cur_info_index, i - 1 )
				local temp_info_len = string.len(temp_info)
				if temp_info_len > 1 or ( string.len(temp_info) <= 1 and string.byte(temp_info) ~= 0x3e and string.byte(temp_info) ~= 0x5d ) then
					result = result .. ChatConfig.message_split_target.CHAT_INFO_SPLITE_TARGET .. temp_info
					-- print("chat model L 1193 result",result)
				end
				cur_info_index = i
			end
		elseif ascii_index == 0x5d then ---------------------]
			if item_begin_index ~= nil then
				local item_info = string.sub( info, item_begin_index, i - 1)
				-- print("chat model L 1200 item_info",item_info)
				item_begin_index = nil
				local item_struct = ChatModel:data_find_bag_item_info_by_name( item_info )
				if item_struct then 
					local item_send_info = item_struct:format_send_info()
					cur_info_index = i + 1
					result = result .. ChatConfig.message_split_target.CHAT_INFO_SPLITE_TARGET .. item_send_info
				else
					-- 这里的处理，让它忽略符号。 最后结果当成 普通信息处理。  lyl
                    result = ""
                    cur_info_index = 1
				end
			else
				item_begin_index = nil
				if cur_info_index ~= i then
					local temp_info = string.sub( info, cur_info_index, i )
					local temp_info_len = string.len(temp_info)
					if temp_info_len > 1 or ( string.len(temp_info) <= 1 and string.byte(temp_info) ~= 0x3e and string.byte(temp_info) ~= 0x5d ) then
						result = result .. ChatConfig.message_split_target.CHAT_INFO_SPLITE_TARGET .. temp_info
						-- print("chat model L 1214 result",result)
					end
					cur_info_index = i + 1
				end
			end
		end
	end
	if cur_info_index <= string.len(info) then
		if result == "" then
			result = result .. string.sub( info, cur_info_index, string.len(info) )
		else
			result = result .. ChatConfig.message_split_target.CHAT_INFO_SPLITE_TARGET .. string.sub( info, cur_info_index, string.len(info) )
		end
	end
	-- print("chat model L 1200 result", result)
	return result
end
--------------------------------
--------------------------------
function ChatModel:format_chat_right_panel_info( info, is_sys )
	-- print("info, is_sys", info, is_sys)
	--------------------------------
	local temp = "abc"
	if string.find( temp, "a") ~= nil then
		-- print("djfosfosf")
	end
	local returnInfo = info
	local target_info = { { text = Lang.chat.mode_str[3], color = "#c38ff33" }, { text = Lang.chat.mode_str[4], color = "#cff0000" } } -- [3]="获得" -- [4]="失去"
	if is_sys == false then
		for i = 1, #target_info do
			if string.find( info, target_info[i].text ) ~= nil then
				returnInfo = target_info[i].color
				break
			end
		end
		returnInfo =  returnInfo .. info
	end
	-- print("returnInfo", returnInfo)
	return returnInfo
end
--------------------------------
--------------------------------
function ChatModel:set_common_info(info)
	local chat_win = UIManager:find_visible_window("chat_win")
	local chat_info = chat_win:get_info_target()
	chat_info:set_index_info(1, info)
end
-----------------------------------------------------------------------------------------
--------------------------------
local asciiSharp = 0x23			----#
local asciiComma = 0x2c			----,
local asciiC = 0x63				----c
local asciiU = 0x75				----u
local asciiV = 0x76				----v
local asciiH = 0x68				----h
local asciiT = 0x74				----t
local asciiA = 0x61				----a
function ChatModel:safe_check(info)
	local safe_info = {}
	local double_sharp = false
	local cur_double_sharp_index = 0
	local single_sharp_index = 0
	local cur_sharp_num = 0
	local info_illegal = false
	local last_target_index = 1
	----------------------
	local is_text_button = false
	--local text_button_target_hit_num = 0
	----------------------
	local is_animation = false
	--local animation_targetr_hit_num = 0
	----------------------
	local is_continue = false
	local info_length = string.len(info)
	----------------------
	for i = 1 , info_length do
		local ascii_index = string.byte( info, i )
		------------------------------------------
		----safe check #
		if is_continue == false and ascii_index == asciiSharp then
			-- print("run safe check # L 1134 last_target_index,cur_double_sharp_index,single_sharp_index",last_target_index, cur_double_sharp_index, single_sharp_index)
			if last_target_index ~= i and cur_double_sharp_index == 0 and single_sharp_index == 0 then
				local temp_info = string.sub( info, last_target_index, i - 1 )
				-- print("temp_info L 1137: ",temp_info)
				table.insert( safe_info, temp_info )
				last_target_index = i
			end
			-------------------------------
			cur_sharp_num = cur_sharp_num + 1
			--------------------------------
			----get the next text ascii
			--local next_ascii = string.byte( info, i + 1 )
			--------------------------------
			----check is begin single
			-- print("check begin single is_continue,cur_sharp_num,cur_double_sharp_index,single_sharp_index,i",
				-- is_continue,cur_sharp_num,cur_double_sharp_index,single_sharp_index,i)
			if is_continue == false and cur_sharp_num == 2 and cur_double_sharp_index == 0 and single_sharp_index + 1 == i then
				-- print("check begin single succeed --------------------")
				cur_double_sharp_index = i - 1
				single_sharp_index = 0
				cur_sharp_num = 0
				is_continue = true
			end
			--------------------------------
			----check is last single
			-- print("check last single is_continue,cur_double_sharp_index,cur_sharp_num,single_sharp_index,i",
				-- is_continue,cur_double_sharp_index,cur_sharp_num,single_sharp_index,i)
			if is_continue == false and cur_double_sharp_index ~= 0 and cur_sharp_num == 2 and single_sharp_index + 1 == i then
				-- print("check last single succeed --------------------")
				if info_illegal == false then
					local temp_info = string.sub(info, cur_double_sharp_index, i)
					--------------------------
					------text button safe check
					if is_text_button == true then
						info_illegal = ChatModel:safe_check_text_button(temp_info)
					end
					---------------------------
					------animation safe check
					if is_animation == true then
						info_illegal = ChatModel:safe_check_animation(temp_info)
					end
					---------------------------
					------add safe info
					if info_illegal == false then				
						table.insert( safe_info, temp_info )
					end
				end
				is_continue = true
				info_illegal = false
				cur_double_sharp_index = 0
				single_sharp_index = 0
				is_continue = true
				is_text_button = false
				--text_button_target_hit_num = 0
				is_animation = false
				if i + 1 < info_length then
					last_target_index = i + 1
				else
					last_target_index = i
				end
				--animation_targetr_hit_num = 0
			end
			-------------------------------
			----check is last
			if i + 1 > info_length then
				info_illegal = true
				is_continue = true
			end
			--------------------------------
			----check single sharp index
			if is_continue == false then
				if i - single_sharp_index > 1 then
					cur_sharp_num = 1
				end 
				single_sharp_index = i
			end
		end
		--------------------------------
		----safe check #,
		if is_continue == false and ascii_index == asciiComma and single_sharp_index + 1 == i then
			info_illegal = true
		end
		--------------------------------
		----safe check #c??????
		if is_continue == false and ascii_index == asciiC and single_sharp_index + 1 == i then
			local temp_index = i + 1
			local temp_ascii = nil
			for j = temp_index , j < 6 do
				if j < info_length then
					temp_ascii = string.byte( info, j )
					if temp_ascii < 0x30 or ( temp_ascii > 0x39  and temp_ascii < 0x61 ) or temp_ascii > 0x66 then
						info_illegal = true
						is_continue = true
						break
					end
				end
			end
		end
		--------------------------------
		----safe check #r
		--------------------------------
		----safe check #u?
		if is_continue == false and ascii_index == asciiU and single_sharp_index + 1 == i then 
			if i + 1 > info_length then
				info_illegal = true
				is_continue = true
			end
		end
		--------------------------------
		----safe check #v
		if is_continue == false and ascii_index == asciiV and single_sharp_index + 1 == i then
			if i + 1 > info_length then
				info_illegal = true
				is_continue = true
			end
		end
		--------------------------------
		----safe check #h
		if is_continue == false and ascii_index == asciiH and single_sharp_index + 1 == i then
			if i + 1 > info_length then
				info_illegal = true 
				is_continue = true
			end
		end
		--------------------------------
		----check is target textbutton
		-- print("is_continue,ascii_index,cur_double_sharp_index,i",is_continue,ascii_index,cur_double_sharp_index,i)
		if is_continue == false and ascii_index == asciiT and cur_double_sharp_index + 2 == i then
			is_text_button = ChatModel:check_text_button_target( info, i , info_length )
			-- print("ChatModel:check_text_button_target is_text_button",is_text_button)
		end
		--------------------------------
		----check is target animage
		if is_continue == false and ascii_index == asciiA and cur_double_sharp_index + 12 == i then
			is_animation = ChatModel:check_animation_target( info, i , info_length )
			-- print("ChatModel:check_animation_target is_animation",is_animation)
		end
		--------------------------------
		----
		--print("run L 1258 i,info_length,last_target_index,info_illegal",i,info_length,last_target_index,info_illegal)
		if i == info_length and last_target_index ~= i and info_illegal == false and cur_double_sharp_index == 0 and single_sharp_index == 0 then
			local temp_info = string.sub( info, last_target_index, i )
			-- print("temp_info",temp_info)
			table.insert( safe_info, temp_info )
		end
		--------------------------------
		if is_continue == true then
			is_continue = false
		end
	end
	----------------------
	local return_info = ""
	if #safe_info > 0 then
		for i = 1 , #safe_info do
			return_info = string.format( "%s%s", return_info, safe_info[i] )
		end
	else
		return_info = nil
	end
	-- print("ChatModel:safe_check return_info",return_info)
	return return_info
end
--------------------------------
function ChatModel:safe_check_text_button(info)
	-- print("safe_check_text_button info:",info)
	local comma_num = 0
	local safe_comma_num = 1
	local info_length = string.len( info )
	local comma_index = 0
	local first_comma_index = nil
	for i = 1 , info_length do
		if string.byte( info, i ) == asciiComma then
			comma_num = comma_num + 1
			comma_index = i
			if first_comma_index == nil then
				first_comma_index = i
			end
		end
	end
	-- print("comma_num,comma_index,info_lenght:",comma_num,comma_index,info_length)
	if comma_num < safe_comma_num then
		return true
	elseif comma_num == safe_comma_num and comma_index + 2 == info_length then
		return true
	elseif comma_num > safe_comma_num and string.byte( info, first_comma_index + 1 ) == 0x23 then
		return true
	else
		return false
	end
end
--------------------------------
function ChatModel:safe_check_animation(info)

end
--------------------------------
function ChatModel:safe_check_sharp(info)
	if string.find( info, "#" ) ~= nil or string.find( info, " " ) ~= nil then
		return true
	else
		return false
	end
	--return string.gsub(info, "#", "" )
end
--------------------------------
function ChatModel:check_text_button_target( info, i , maxlen )
	local targe_hit_num = 1
	--textbutton
	local text_button_target_all_num = 10
	for j = 1 , string.len("extbutton") do
		if j + i < maxlen then
			if j == 1 and string.byte( info, j + i ) == 0x65 then -----e
				-- print("e")
				targe_hit_num = targe_hit_num + 1
			elseif j == 2 and string.byte( info, j + i ) == 0x78 then -----x
				-- print("x")
				targe_hit_num = targe_hit_num + 1
			elseif j == 3 and string.byte( info, j + i ) == 0x74 then -----t
				-- print("t")
				targe_hit_num = targe_hit_num + 1
			elseif j == 4 and string.byte( info, j + i ) == 0x62 then -----b
				-- print("b")
				targe_hit_num = targe_hit_num + 1
			elseif j == 5 and string.byte( info, j + i ) == 0x75 then -----u
				-- print("u")
				targe_hit_num = targe_hit_num + 1 
			elseif j == 6 and string.byte( info, j + i ) == 0x74 then -----t
				-- print("t")
				targe_hit_num = targe_hit_num + 1
			elseif j == 7 and string.byte( info, j + i ) == 0x74 then -----t 
				-- print("t")
				targe_hit_num = targe_hit_num + 1
			elseif j == 8 and string.byte( info, j + i ) == 0x6f then -----o
				-- print("o")
				targe_hit_num = targe_hit_num + 1
			elseif j == 9 and string.byte( info, j + i ) == 0x6e then -----n
				-- print("n")
				targe_hit_num = targe_hit_num + 1
			end
		end
	end
	-- print("targe_hit_num",targe_hit_num)
	if targe_hit_num == text_button_target_all_num then
		return true	
	else
		return false
	end
end
--------------------------------
function ChatModel:check_animation_target( info, i , maxlen )
	local target_hit_num = 1
	--animate
	local animation_target_all_num = 7
	for j = 1 , j < 7 do
		if j + i < maxlen then
			if j == 1 and string.byte( info, j + i ) == 0x6e then -----n
				target_hit_num = target_hit_num + 1
			elseif j == 2 and string.byte( info, j + i ) == 0x69 then -----i
				target_hit_num = target_hit_num + 1
			elseif j == 3 and string.byte( info, j + i ) == 0x6d then -----m
				target_hit_num = target_hit_num + 1 
			elseif j == 4 and string.byte( info, j + i ) == 0x61 then -----a
				target_hit_num = target_hit_num + 1 
			elseif j == 5 and string.byte( info, j + i ) == 0x74 then -----t
				target_hit_num = target_hit_num + 1
			elseif j == 6 and string.byte( info, j + i ) == 0x65 then -----e
				target_hit_num = target_hit_num + 1 
			end
		end
	end
	if target_hit_num == animation_target_all_num then
		return true
	else
		return false
	end
end

--add By Shan Lu  2013/12/02 开关聊天界面
function ChatModel:toggleChatWin()

	local chat_win = UIManager:find_visible_window("chat_win")
	--xprint(chat_win)
	if chat_win then
		UIManager:hide_window('chat_win')
	else
    	ChatModel:open_chat_win()
    end
end
--------------------------------