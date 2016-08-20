-- PaoHuanCC.lua
-- create by hcl on 2013-8-2
-- 跑环协议 146

PaoHuanCC = {}

-- 146,1请求周环任务信息
function PaoHuanCC:req_get_zh_list()
	local pack = NetManager:get_socket():alloc(146,1);
	NetManager:get_socket():SendToSrv(pack);
end

-- 146,1下发周环任务信息
function PaoHuanCC:do_get_zh_list( pack )
	-- print("PaoHuanCC:do_get_zh_list( pack ).......................................")
	local ph_info = {};
	ph_info.icon_state = pack:readChar();				-- 图标状态 0不显示1:显示但不可领
	ph_info.total_huan_num = pack:readInt();			-- 总环数
	ph_info.finish_huan_num = pack:readInt();			-- 已完成环数
	ph_info.curr_huan_num = pack:readInt();				-- 当前环数
	ph_info.curr_quest_id = pack:readInt();				-- 当前环任务id
	--ph_info.curr_get_award_huan_num = pack:readInt();	-- 当前可领奖的最高环数
	ph_info.award_state_num = pack:readInt();			-- 奖励领取情况列表长度
	-- print("ph_info.award_state_num,curr_get_award_huan_num",ph_info.award_state_num,ph_info.curr_get_award_huan_num);
	ph_info.award_state_table = {}
	local is_need_show_window = false;
	for i=1,ph_info.award_state_num do
		ph_info.award_state_table[i] = {};
		ph_info.award_state_table[i].huan_num = pack:readInt();
		ph_info.award_state_table[i].state = pack:readChar(); 	-- 0不可领，1当前可领取，2已领取过
		if ( ph_info.award_state_table[i].huan_num == ph_info.finish_huan_num and ph_info.award_state_table[i].state == 1 ) then
			is_need_show_window = true;
		end
		if ( i == ph_info.award_state_num ) then
			if ( ph_info.award_state_table[i].state == 2 ) then
				ActivityMenusPanel:remove_btn( 10 ) 
			end
		end
	end

	PaoHuanModel:set_ph_info( ph_info )

	local win = UIManager:find_visible_window( "pao_huan_win" )
	if ( win ) then
		win:update_view();
	else
		if ( is_need_show_window ) then 
			PaoHuanWin:show(  )
		end
	end
end

-- 146,2 领取周跑环阶段奖励
function PaoHuanCC:req_award( huan_index )
	local pack = NetManager:get_socket():alloc(146,2);
	pack:writeInt(huan_index);
	NetManager:get_socket():SendToSrv(pack);
	-- print("PaoHuanCC:req_award( huan_index ).............",huan_index)
end

-- 146,3 解环
function PaoHuanCC:req_jiehuan()
	local pack = NetManager:get_socket():alloc(146,3);
	NetManager:get_socket():SendToSrv(pack);
	-- print("解环.........................")
end

-- 146,4 丢骰子结果
function PaoHuanCC:do_dsz_result( pack )
	local exp_rate = pack:readChar();	--丢骰子结果(经验倍数)
	local finish_huan_num = pack:readInt(); -- 已完成的环数
	
	--全屏大小
	local _ui_width = GameScreenConfig.ui_screen_width 
	local _ui_height = GameScreenConfig.ui_screen_height

	local function fun()
		local ui_node = ZXLogicScene:sharedScene():getUINode();
		--全屏大小
		local _ui_width = GameScreenConfig.ui_screen_width 
		local _ui_height = GameScreenConfig.ui_screen_height

		local lock_panel = CCArcRect:arcRectWithColor(0,0,_ui_width,_ui_height, 0x00000088);
		local panel = CCBasePanel:panelWithFile( 0, 0, _ui_width, _ui_height, nil)

		local function panel_fun(eventType,arg,msgid,selfitem)
		if eventType == nil or arg == nil or msgid == nil or selfitem == nil then
			return
		end
        if  eventType == TOUCH_BEGAN then
          	lock_panel:removeFromParentAndCleanup(true);
          	panel:removeFromParentAndCleanup(true);
          	lock_panel = nil;
          	panel = nil;
          	PaoHuanCC:req_get_exp()
            return true;
        elseif eventType == TOUCH_CLICK then
        	return true;
        end
        return true;
    end
    lock_panel:registerScriptHandler(panel_fun);
	ui_node:addChild(lock_panel,499);
		-- 先播一段动画然后领取经验
		ui_node:addChild(panel,500)
		LuaEffectManager:play_view_effect( 11015,_ui_width/2,_ui_height/2,panel,false,999 )
		local finish_cb = callback:new()
		local function cb_fun()
			if ( lock_panel ) then
				print("cb...........................................................................")
				lock_panel:removeFromParentAndCleanup(true);
				panel:removeFromParentAndCleanup(true);
				panel = nil;
	        	PaoHuanCC:req_get_exp()
	        end
		end
		finish_cb:start( 2,cb_fun)

		local  change_spr_cb = callback:new();
		local function change_fun()
			if ( panel ) then
				MUtils:create_sprite(panel,"ui/lh_paohuan/sz_"..exp_rate..".png",_ui_width/2,_ui_height/2-100);
			end
		end
		change_spr_cb:start( 1,change_fun );
	end
	-- 弹一个丢骰子的对话框
	NormalDialog:show(LangGameString[450]..finish_huan_num..LangGameString[451],fun,2,nil,false); -- [450]="已完成环数" -- [451]="，恭喜你获得1次丢骰子决定本环任务经验倍数的机会！"
end

-- 146,5 接任务
function PaoHuanCC:req_receive_quest()
	local pack = NetManager:get_socket():alloc(146,5);
	NetManager:get_socket():SendToSrv(pack);	
end

-- 146,6 领取任务特殊环附加经验奖励
function PaoHuanCC:req_get_exp()
	local pack = NetManager:get_socket():alloc(146,6);
	NetManager:get_socket():SendToSrv(pack);		
end
