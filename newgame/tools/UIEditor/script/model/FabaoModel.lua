-- FabaoModel.lua
-- created by fjh on 2013-5-21
-- 法宝model

FabaoModel = {};

local FABAO_MAX_LV = 50

local _old_jingjie = 1;
local _fabao_info = nil;
-- 法宝界面的器魂列表
local _fabao_xianhun = {};
-- 炼魂界面的器魂列表
local _lianhun_xianhun_list = {};
-- 炼魂师列表
local _lianhunshi_list = {};

--是不是第一个申请灵器信息
local is_first = true
-- added by aXing on 2013-5-25
function FabaoModel:fini(  )
	_old_jingjie = 1;
	_fabao_info = nil;
	_fabao_xianhun = {};
	_lianhunshi_list = {};
	_lianhun_xianhun_list = {};
end

---- 法宝信息
function FabaoModel:set_fabao_info( info )
	if _fabao_info then
		_old_jingjie = _fabao_info.jingjie;
	end
	_fabao_info = info;
end
function FabaoModel:get_fabao_info( )
	return _fabao_info;
end

---- 法宝镶嵌的器魂
function FabaoModel:set_fabao_xianhun( open_count, list )
	_fabao_xianhun = {count = open_count, xianhuns = list};
end
function FabaoModel:get_fabao_xianhun(  )
	return _fabao_xianhun;
end


---- 炼魂界面的器魂列表
-- function FabaoModel:set_lianhun_xianhun_list( xianhun_list )
-- 	_lianhun_xianhun_list = xianhun_list;
-- end
function FabaoModel:set_lianhun_xianhun_list(open_count,list )
	_lianhun_xianhun_list = {count = open_count ,xianhun_list = list};
end

function FabaoModel:get_lianhun_xianhun_list(  )
	return _lianhun_xianhun_list;
end
-- 查询炼魂背包是否满了
function FabaoModel:get_lianhun_bag_is_full(  )
	if #_lianhun_xianhun_list >= 20 then
		return true;
	end
	return false; 
end

-- 炼魂师列表
function FabaoModel:set_lianhunshi_list( lianhunshi_list )
	_lianhunshi_list = lianhunshi_list;
end
function FabaoModel:get_lianhunshi_list(  )
	return _lianhunshi_list;
end



-------------------------------------- 游戏逻辑
-- 器魂的吞噬逻辑
function FabaoModel:xiahun_swallow_logic( cur_cell, other_slot )
	if cur_cell.data then
     		-- print("当前cell存在数据");
		local cur_xianhun = cur_cell.data;
		local oth_xianhun = other_slot.obj_data;

		if cur_xianhun.quality > oth_xianhun.quality then
			-- cur_xianhun 吞噬 oth_xianhun
			FabaoModel:req_swallow_xianhun( cur_cell.win, cur_xianhun, other_slot.win, oth_xianhun )

		elseif cur_xianhun.quality < oth_xianhun.quality then
			-- oth_xianhun 吞噬 cur_xianhun
			FabaoModel:req_swallow_xianhun( other_slot.win, oth_xianhun, cur_cell.win, cur_xianhun )			

		elseif cur_xianhun.quality == oth_xianhun.quality then
			if cur_xianhun.level > oth_xianhun.level then
				-- cur_xianhun 吞噬 oth_xianhun
				FabaoModel:req_swallow_xianhun( cur_cell.win, cur_xianhun, other_slot.win, oth_xianhun )

			elseif cur_xianhun.level < oth_xianhun.level then
				-- oth_xianhun 吞噬 cur_xianhun
				FabaoModel:req_swallow_xianhun( other_slot.win, oth_xianhun, cur_cell.win, cur_xianhun )			

			elseif cur_xianhun.level == oth_xianhun.level then
				-- 如果品质等级都相等，默认cur_xianhun 吞噬 oth_xianhun
				FabaoModel:req_swallow_xianhun( cur_cell.win, cur_xianhun, other_slot.win, oth_xianhun )
			end
			
		end

    else

        if cur_cell.win ~= other_slot.win then
            -- win的名字不同,从其他界面拖过来的，意味要么卸下，要么装备
            if cur_cell.win == "lianhun_win" then
            	--有器魂拖到炼魂界面，意味着卸下器魂
            	local xianhun_id = other_slot.obj_data.id;
            	FabaoModel:unequip_a_xianhun( xianhun_id );
           -- elseif cur_cell.win == "fabao_win" then
            elseif cur_cell.win == "lq_left_win" then
            	--有器魂拖到法宝界面，意味着装备器魂
            	if cur_cell.seal_icon_visible == false then
            		FabaoModel:equip_a_xianhun( other_slot.obj_data );
            	else 
            		--如果格子是封印着的，则无法装备
            	end
            end
        else
        end

    end
end






-- 炫耀法宝
function FabaoModel:xuanyao_fabao(  )
	if _fabao_info then

		local head = string.format("%s%d%s%d%s%d%s%s%s,%s,",ChatConfig.message_split_target.CHAT_INFO_SPLITE_TARGET,
			ChatConfig.ChatSpriteType.TYPE_TEXTBUTTON, ChatConfig.message_split_target.CHAT_INFO_HEAD_TARGET,
			ChatConfig.ChatAdditionInfo.TYPE_FABAO, ChatConfig.message_split_target.CHAT_INFO_HEAD_TARGET,
			_fabao_info.jingjie, ChatConfig.message_split_target.CHAT_INFO_HEAD_TARGET,
			Hyperlink:get_first_function_target(), Hyperlink:get_third_open_sys_win_target(),"12");
		-- local head = ChatConfig.message_split_target.CHAT_INFO_SPLITE_TARGET..ChatConfig.ChatSpriteType.TYPE_TEXTBUTTON..","..ChatConfig.message_split_target.CHAT_INFO_HEAD_TARGET..","..ChatConfig.ChatAdditionInfo.TYPE_FABAO..","..ChatConfig.message_split_target.CHAT_INFO_HEAD_TARGET..",".._fabao_info.jingjie..","..ChatConfig.message_split_target.CHAT_INFO_HEAD_TARGET..","..Hyperlink:get_first_function_target()..","..Hyperlink:get_third_open_sys_win_target()..","..tostring(12)..",";

		--modify by hcl on 2013/12/25--
			local level = _fabao_info.level - (_fabao_info.jingjie-1)*10;
		--modify by hcl on 2013/12/25--

		local body_1 = _fabao_info.jingjie..","..level..",".._fabao_info.exp..",".._fabao_info.fight..",";
		local body_2 = _fabao_xianhun.count..","..#_fabao_xianhun.xianhuns..",";
		for i,v in ipairs(_fabao_xianhun.xianhuns) do
			-- xianhun_dict[i] = {id = xianhun_id, type = xianhun_type, quality = xianhun_quality,
			-- 					 level = xianhun_level, value = xianhun_value};
			body_2 = body_2..v.id..","..v.type..","..v.quality..","..v.level..","..v.value..",";
		end
		local bottom = ChatConfig.message_split_target.CHAT_INFO_SPLITE_TARGET;
		local text = head..body_1..body_2..bottom;
		ChatCC:send_chat(ChatModel:get_cur_chanel_select(), 0, text)
	   end
end

-- 从超链接发来的字典中格式出 法宝信息
function FabaoModel:fabao_info_format( data )
	if #data == 2 then
		return data[1];
	else
		local fabao_info = {};
		fabao_info.jingjie = tonumber(data[2]);
		fabao_info.level = tonumber(data[3]);
		fabao_info.exp = tonumber(data[4]);
		fabao_info.fight = tonumber(data[5]);
		return fabao_info;
	end
end
-- 从超链接发来的字典中格式出 法宝镶嵌的器魂信息
function FabaoModel:fabao_xianhuns_format( data )

	if #data == 2 then
		return data[2];
	else
		local fabao_xianhun = {};
		fabao_xianhun.count = tonumber(data[6]);

		local xianhun_dict = {};
		for i=1,tonumber(data[7]) do
			xianhun_dict[i] = {id = tonumber(data[8+(i-1)*5]), type = tonumber(data[9+(i-1)*5]), quality = tonumber(data[10+(i-1)*5]),
								 level = tonumber(data[11+(i-1)*5]), value = tonumber(data[12+(i-1)*5]) };
		end
		fabao_xianhun.xianhuns = xianhun_dict;
		return fabao_xianhun;
	end

end

--------------------------------------- 网络请求
-- 请求法宝信息
function FabaoModel:req_fabao_info(  )
	FabaoCC:req_fabao_info(  )

end
-- 法宝信息刷新callback
function FabaoModel:do_fabao_info(  )
	local win = UIManager:find_visible_window("lingqi_win");
	if win then
	 if win.lingqi_left then 
	 	--更新法宝信息
		win.lingqi_left:update_fabao_info();
		if _old_jingjie < _fabao_info.jingjie then
			if _fabao_xianhun.count ~= nil then
				_fabao_xianhun.count = _fabao_xianhun.count + 1;
			end 
			
			--更新器魂环信息
			win.lingqi_left:update_xianhun_loop();
		end
		
		--更新当前法宝形象
		win.lingqi_left:update_current_fabao_avatar( _fabao_info.jingjie );
      end
    
    if is_first then 
    	self:req_fabao_xianhun_info()
    	is_first =false
    end
    --属性页面
    if win.all_page_t[1] then
       win.all_page_t[1]:update("all")  --刷新属性页面的数据
    end

    if win.all_page_t[2] then
       win.all_page_t[2]:active(true)  --刷新升级页面的数据
    end
	end
end


-- 请求法宝镶嵌的器魂信息
function FabaoModel:req_fabao_xianhun_info( )
	FabaoCC:req_used_xianhun_info();
end

--返回法宝镶嵌的器魂信息
function FabaoModel:do_fabao_xianhun_info(  )
	local win = UIManager:find_visible_window("lingqi_win");
	if win then
		if win.lingqi_left then
		   win.lingqi_left:update_xianhun_loop();
	    end
	end
end

-- 请求使用法宝晶石(或元宝)提升法宝等级
-- gem_type:	晶石类型，1=初级晶石, 2=中级晶石, 3=高级晶石
-- used_yb:		是否使用元宝提升

--modified by zyz,old code
-------------------------------------------------------------------------------------------------
-- function FabaoModel:req_up_fabao_level( gem_type, used_yb )
-- 	if used_yb then
-- 		local player = EntityManager:get_player_avatar();
-- 		local need_yb ;
-- 		if gem_type == 1 then
-- 			need_yb = 10;
-- 		elseif gem_type == 2 then
-- 			need_yb = 25;
-- 		elseif gem_type == 3 then
-- 			need_yb = 80;
-- 		end
-- 		if need_yb > player.yuanbao then
-- 			-- GlobalFunc:create_screen_notic( "元宝不足" );
-- 			local function confirm2_func()
-- 	            GlobalFunc:chong_zhi_enter_fun()
-- 	            --UIManager:show_window( "chong_zhi_win" )
-- 	    	end
-- 	    	ConfirmWin2:show( 2, 2, "",  confirm2_func)
-- 			return ;
-- 		end
-- 		used_yb = 1;
-- 	else
-- 		local count;
-- 		if gem_type == 1 then
-- 			count = ItemModel:get_item_count_by_id( 18603 );
-- 		elseif gem_type == 2 then
-- 			count = ItemModel:get_item_count_by_id( 18604 );
-- 		elseif gem_type == 3 then
-- 			count = ItemModel:get_item_count_by_id( 18605 );
-- 		end
-- 		if count <= 0 then
-- 			GlobalFunc:create_screen_notic( "法宝晶石不足" );
-- 			return ;
-- 		end
-- 		used_yb = 0;
-- 	end

-- 	FabaoCC:req_fabao_uplevel( gem_type, used_yb )
-- end
-------------------------------------------------------------------------------------------------

--new code
-------------------------------------------------------------------------------------------------
function FabaoModel:req_up_fabao_level( gem_type, used_yb,used_ten)
	--获取所选择的晶石数量及对应元宝
		local count = nil;
		local need_yb = nil;
		
		if gem_type == 1 then
			count = ItemModel:get_item_count_by_id( 18603 );
			need_yb = 10;
		elseif gem_type == 2 then
			count = ItemModel:get_item_count_by_id( 18604 );
			need_yb = 25;
		elseif gem_type == 3 then
			count = ItemModel:get_item_count_by_id( 18605 );
			need_yb = 80;
		end
	--优先使用晶石提升
	 if count > 0 then	
	 	--如果选中一键十次
	 	if used_ten then
	 	 FabaoCC:req_fabao_uplevel( gem_type, 0, 1 )
        else 
         FabaoCC:req_fabao_uplevel( gem_type, 0, 0 )
        end
   
	 --晶石不足时，如果勾选使用元宝
	 elseif used_yb then
	 	local player = EntityManager:get_player_avatar();
		--元宝不足时，弹 快速充值 界面
		if need_yb > player.yuanbao then
			-- GlobalFunc:create_screen_notic( "元宝不足" );
			local function confirm2_func()
	            GlobalFunc:chong_zhi_enter_fun()
	            --UIManager:show_window( "chong_zhi_win" )
	    	end
	    	ConfirmWin2:show( 2, 2, "",  confirm2_func)
	    --元宝充足时,使用元宝提升
    else
	    --如果选中一键十次
		 	if used_ten then
		 	 FabaoCC:req_fabao_uplevel( gem_type, 1, 1 )
	        else 
	         FabaoCC:req_fabao_uplevel( gem_type, 1, 0 )
	        end
	    end
	 --晶石不足，且未勾选使用元宝时
	else
		GlobalFunc:create_screen_notic(Lang.lingqi[1],16,700,250 );
	end
end
-------------------------------------------------------------------------------------------------

-- 使用炼魂师炼魂
function FabaoModel:req_lianhun( lianhunshi_id, used_yb )
	if used_yb then	
		
		local player = EntityManager:get_player_avatar();
		
		if player.yuanbao < 200 then
			-- GlobalFunc:create_screen_notic( "元宝不足" );
			local function confirm2_func()
	            GlobalFunc:chong_zhi_enter_fun()
	            --UIManager:show_window( "chong_zhi_win" )
	    	end
	    	ConfirmWin2:show( 2, 2, "",  confirm2_func)
			return;
		end
		
		FabaoCC:req_lianhun( lianhunshi_id, 1);

	else

		FabaoCC:req_lianhun( lianhunshi_id, 0);
	end
end

-- 点亮了新的炼魂师
function FabaoModel:do_new_lianhunshi(  )
	
	local win = UIManager:find_visible_window("lingqi_win");
	if win then
	   if win.all_page_t[3] then
		win.all_page_t[3]:update_lianhunshi_list( )
	   end
	end
end

-- 一键炼魂
function FabaoModel:req_one_key_lianhun(  )
	FabaoCC:req_one_key_lianhun(  );
end

-- 一键合成
function FabaoModel:req_one_key_hecheng( )
	FabaoCC:req_one_key_hecheng( )
end

-- 一键合成的结果
function FabaoModel:do_one_key_hecheng( status )
	
end

-- 请求炼魂界面(器魂背包)里的器魂列表
function FabaoModel:req_lianhun_bag_list(  )
	FabaoCC:req_liehun_win_info(  );
end

-- 下发炼魂界面(器魂背包)里的器魂列表
function FabaoModel:do_lianhun_bag_list( xianhun_list )
	-- local win = UIManager:find_visible_window("lianhun_win");
	-- if win then
	-- 	win:update_xianhun_list();
	-- end
	-- print("===  FabaoModel:do_lianhun_bag_list( xianhun_list )  ====")
    local  win = UIManager:find_visible_window("lingqi_win")
    if win then
    	 if win.all_page_t[3] then
    	 	-- print("存在")
    	 	win.all_page_t[3]:update_xianhun_list();
    	 end
    end
end

-- 添加了一个器魂
function FabaoModel:do_add_xianhun( win, xianhun )
	
	-- 0 = 法宝界面， 1 = 炼魂界面
	if win == 1 then
		-- 向炼魂界面的器魂列表里压入一个元素
		-- table.insert(_lianhun_xianhun_list, xianhun);
		local xianhun_list = _lianhun_xianhun_list.xianhun_list;
		table.insert(xianhun_list, xianhun);

		--更新炼魂界面的器魂列表
		local win = UIManager:find_visible_window("lingqi_win");
		if win then
			if win.all_page_t[3] then
				win.all_page_t[3]:update_xianhun_list();
			end
			
		end
	elseif win == 0 then
		-- 向法宝界面的器魂列表里压入一个元素
		-- print("向法宝界面的器魂列表里压入一个元素",#_fabao_xianhun, xianhun.id)
		local xianhuns = _fabao_xianhun.xianhuns;
		table.insert(xianhuns, xianhun);
		_fabao_xianhun.xianhuns = xianhuns;
		--更新法宝界面的器魂列表
		-- local win = UIManager:find_visible_window("fabao_win");
		-- if win then
		-- 	win:update_xianhun_loop();
		-- end
		local win = UIManager:find_visible_window("lingqi_win");
		if win then
			if win.lingqi_left then
			win.lingqi_left:update_xianhun_loop();
		    end
		    if win.all_page_t[1] then
		    	win.all_page_t[1]:update("all")
		    end
		end
	end
end

-- 删除一个器魂
function FabaoModel:do_delete_xianhun( win, delete_list )
	

	-- 0 = 法宝界面， 1 = 炼魂界面
	local xianhun_list ;
	if win == 1 then 
		-- xianhun_list = _lianhun_xianhun_list;
		xianhun_list = _lianhun_xianhun_list.xianhun_list;
	elseif win == 0 then
		xianhun_list = _fabao_xianhun.xianhuns;
	end

	-- 删除操作
	for i,xianhun_id in ipairs(delete_list) do	
		-- print("删除器魂",xianhun_id);	
		for i,xianhun in ipairs(xianhun_list) do
			if xianhun.id == xianhun_id then
				table.remove(xianhun_list, i);
				break;
			end
		end
	end

local cur_win = UIManager:find_visible_window("lingqi_win");

	if win == 1 then
		--更新炼魂界面的器魂列表
		--local win = UIManager:find_visible_window("lianhun_win");
		-- if win then
		-- 	win:update_xianhun_list();
		-- end
        --炼魂页面刷新
		if cur_win.all_page_t[3] then
			cur_win.all_page_t[3]:update_xianhun_list();
		end
		
	    if cur_win.all_page_t[1] then
	    	cur_win.all_page_t[1]:update("all")
	    end

	elseif win == 0 then
		--同时要刷新页面
		if cur_win.lingqi_left then
			cur_win.lingqi_left:update_xianhun_loop();
		end
      
      if cur_win.all_page_t[1] then
			cur_win.all_page_t[1]:update("all");
		end

	    if cur_win.all_page_t[3] then
			cur_win.all_page_t[3]:update_xianhun_list();
		end

	end
end


-- 装备一个器魂
function FabaoModel:equip_a_xianhun( xianhun  )
    if xianhun.quality < 3 then
        GlobalFunc:create_screen_notic( Lang.lingqi[2],16,700,250 );
    else
    	FabaoCC:req_equip_xianhun( xianhun.id )       
    end
	
end

-- 卸载一个器魂
function FabaoModel:unequip_a_xianhun( xianhun_id )
	FabaoCC:req_unequip_xianhun( xianhun_id )

end

-- 吞噬器魂
function FabaoModel:req_swallow_xianhun( first_from_win, first_xianhun, second_from_win, second_xianhun )
    
	local function win_name_conver_num( win_name )
		--if win_name == "fabao_win" then
		if win_name == "lq_left_win" then
			return 0;
		elseif win_name == "lianhun_win" then
			return 1;
		end
		return nil;
	end

	local first_from_win_num = win_name_conver_num( first_from_win );
	local second_from_win_num = win_name_conver_num( second_from_win );

	local first_color = FabaoConfig:get_xianhun_color_by_quality( first_xianhun.quality );
	local second_color = FabaoConfig:get_xianhun_color_by_quality( second_xianhun.quality );
	local first_name = FabaoConfig:get_xianhun( first_xianhun.quality, first_xianhun.type, first_xianhun.level ).name;
	local second_name = FabaoConfig:get_xianhun( second_xianhun.quality, second_xianhun.type, second_xianhun.level ).name;

	-- print("被吞噬器魂",second_xianhun.level, second_xianhun.value);

	local text = first_color..first_name..Lang.lingqi[3]..second_color..second_name..Lang.lingqi[4]..second_xianhun.value..Lang.lingqi[5];
	
	local function sure_func(  )
		FabaoCC:req_swallow_xianhun( first_from_win_num, first_xianhun.id, second_from_win_num, second_xianhun.id );
	end

	NormalDialog:show(text,sure_func,1);
	
end

-- 法宝战斗力更新
function FabaoModel:do_fabao_fight_value( fight_value )
	
	local win = UIManager:find_visible_window("lingqi_win");
	if win then
		if win.lingqi_left then
			win.lingqi_left:update_fight_value( fight_value );
		end
		
	end

end

-- 返回服务器的提示

function FabaoModel:do_show_server_message( type, message )
	-- type : 
	-- 0=召唤出更高级的炼魂师
	-- 1=获得xxx器魂
	-- 2=法宝获得N点经验
	-- 3=炼魂空间已满
	-- 4=法宝晶石不足 

	GlobalFunc:create_screen_notic(message,16,700,250 );

end

-- 请求今天使用了召唤阴阳印的次数
function FabaoModel:req_call_yinyang_count(  )
	FabaoCC:req_vip_user_call_fourth_lianhunshi_count(  )
end

--获取今天能使用的召唤阴阳印的次数
function FabaoModel:do_call_yinyang_count( count )
		

    local vip = VIPModel:get_vip_info();

    local all_count = 0;
    if vip.level >= 5 then 
        all_count = 30;
    end
    if vip.level >= 8 then
        all_count = 50;
    end

	-- local win = UIManager:find_visible_window("lianhun_win");
	local win = UIManager:find_visible_window("lingqi_win")
	if win then
		if win.all_page_t[3] then
			count = all_count - count;
			if count <= 0 then
				count = 0;
			end
			win.all_page_t[3]:update_yinyang_count( count, all_count );

		end
	end

end


-- 更新某个器魂的数据
function FabaoModel:update_someone_xianhun( win, xianhun )
	-- win 目标界面, 0=法宝界面，1=炼魂界面

	if win == 0 then

		for i,v in ipairs(_fabao_xianhun.xianhuns) do
			if v.id == xianhun.id then
				_fabao_xianhun.xianhuns[i] = xianhun;
			end
		end

		 --更新法宝界面的器魂列表
		-- local win = UIManager:find_visible_window("fabao_win");
		-- if win then
		-- 	win:update_xianhun_loop();
		-- end
		local win = UIManager:find_visible_window("lingqi_win");
		if win then
			if win.lingqi_left then
			win.lingqi_left:update_xianhun_loop();
	    	end
		end

	elseif win == 1 then

		-- for i,v in ipairs(_lianhun_xianhun_list) do
		-- 	if v.id == xianhun.id then
		-- 		_lianhun_xianhun_list[i] = xianhun;
		-- 	end
		-- end
		for i,v in ipairs(_lianhun_xianhun_list.xianhun_list) do
			if v.id == xianhun.id then
				_lianhun_xianhun_list.xianhun_list[i] = xianhun;
			end
		end


		--更新炼魂界面的器魂列表
		local win = UIManager:find_visible_window("lingqi_win");
		if win then
			if win.all_page_t[3] then
					win.all_page_t[3]:update_xianhun_list();
			end
		
		end
	end

end

function FabaoModel:if_can_upgrade( )
	local fabao_info = FabaoModel:get_fabao_info()
	if fabao_info then
		local fabao_lv = fabao_info.level
	    local temp_count = 0
	    temp_count = ItemModel:get_item_count_by_id(18603)
	    if temp_count <= 0 then
	        temp_count = ItemModel:get_item_count_by_id(18604)
	    end
	    if temp_count <= 0 then
	        temp_count = ItemModel:get_item_count_by_id(18605)
	    end
	    if (temp_count > 0) and (fabao_lv<FABAO_MAX_LV) then
	        return true
	    else
	        return false
	    end
	    return false
	end
end

function FabaoModel:get_fabao_max_lv()
	return FABAO_MAX_LV end


--刷新灵器左页
function  FabaoModel:flash_lingqi()
		--打开灵器属性页面之后 需要刷新左边的页面数据
	  local win = UIManager:find_visible_window("lingqi_win");
    	if win then
           if win.lingqi_left then
           	  --刷新数据
           	  win.lingqi_left.active(true)
           	  -- win.lingqi_left.view:setIsVisible(true)
           end
	    end 
end

--开启炼魂界面的器魂槽
function  FabaoModel:req_open_xianhun_slot( open_count)
	FabaoCC:req_open_xianhun_slot(open_count)
end

--刷新仙魂背包
function  FabaoModel:do_open_xianhun_slot(code,count)
    if code ==1 then   --code  0：成功 1：没有足够的元宝
    	  local alert_text =Lang.lingqi.lianhun[19]
          GlobalFunc:create_screen_notic(alert_text,16,700,250 );
    elseif code ==0 then
       	--更新炼魂界面的器魂列表
       	local xianhuns_data = FabaoModel:get_lianhun_xianhun_list()
       	local xianhuns = xianhuns_data.xianhun_list
       	FabaoModel:set_lianhun_xianhun_list(count,xianhuns)
		local win = UIManager:find_visible_window("lingqi_win");
		if win then
			if win.all_page_t[3] then
					win.all_page_t[3]:update_xianhun_list();
			end
		
		end
    end
end


---更新元宝与银两
function FabaoModel:update_yb_yl()
	local lingqi_win = UIManager:find_window("lingqi_win")
	if lingqi_win ~= nil then
		local player = EntityManager:get_player_avatar()
		local cur_yb = player.yuanbao
		local cur_yl = player.yinliang
		if lingqi_win.all_page_t[3] then
		   lingqi_win.all_page_t[3]:update_money(cur_yb, cur_yl)
	    end
	end
end
