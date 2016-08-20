-- XSZYManager.lua
-- created by hcl on 2013-3-14
-- 新手指引管理器

require "utils/MUtils"
require "config/XSZYConfig"

super_class.XSZYManager()

local ui_node = nil;

-- 新手指引的框和箭头的z值
local JT_ZORDER = 640;


function XSZYManager:init()
	-- local parent_ui_node = ZXLogicScene:sharedScene():getUINode();
	-- ui_node = CCNode:node();
	-- parent_ui_node:addChild(ui_node);
	ui_node = ZXLogicScene:sharedScene():getUINode();
end

-- 从大到小的框
local zximg_corner = nil;
-- 计时器
local time = 0;
local scale_timer = timer();
local new_sys_cb = callback:new()
-- 新手指引状态 -- 根据可接任务来判断当前的新手指引状态
-- 1,装备指引 2,宠物指引 3 背包指引
local XSZY_STATE = 0;
-- 指引的第几步
local XSZY_STEP = 1;
-- 新手指引当前状态需要用到的数据
local XSZY_DATA = nil;
-- 开启新系统动画的面板
local new_sys_panel = nil;

function XSZYManager:get_state()
	return XSZY_STATE;
end

function XSZYManager:get_data()
	return XSZY_DATA;
end

function XSZYManager:set_step( step )
	XSZY_STEP = step;
end

function XSZYManager:get_step()
	return XSZY_STEP;
end

function XSZYManager:set_state_and_data(state,data)
	-- XSZY_STATE = state;
	-- XSZY_DATA = data;
end

-- 框的从大到小的动画
function XSZYManager:play_select_rect_animation( rect_x,rect_y,rect_width,rect_height)

	-- 如果有之前的动画，则清除掉
	if ( zximg_corner ) then
		--dismiss_scheduler_cb:cancel()
		scale_timer:stop()
		zximg_corner:removeFromParentAndCleanup(true);
		zximg_corner = nil;
	end


	local scale_y = 630 / rect_height;
	local scale_x = 900 / rect_width;
	local scale = math.min( scale_x,scale_y);

	local dx = rect_width * scale;
	local dy = rect_height * scale;
	local anchor_x,anchor_y;
	
	local x1 = rect_x/900;
	local y1 = rect_y/630;
	
	local pos_x = ( 900 - dx ) * x1 ;
	local pos_y = ( 630 - dy ) * y1 ;

	anchor_x = ( rect_x - pos_x ) / dx;
	anchor_y = ( rect_y - pos_y ) / dy;
	
	--print("dx,dy,anchor_x,anchor_y = ",dx,dy,anchor_x,anchor_y);

	if not ui_node then ui_node = ZXLogicScene:sharedScene():getUINode() end
	zximg_corner = MUtils:create_zximg(ui_node,"nopack/ani_corner.png",rect_x + rect_width * anchor_x,rect_y+ rect_height * anchor_y,dx,dy,3,3,JT_ZORDER);
	zximg_corner:setAnchorPoint(anchor_x,anchor_y);

	local each_x = ( dx - rect_width  ) / 10;
	local each_y = ( dy - rect_height ) / 10;

	time = 0;

	local function dismiss( dt )
		--print("running dismiss/////////////////////////");
		time = time + 1;
		zximg_corner:setSize(dx - time * each_x,dy - time * each_y);
		if ( time == 10 ) then
	      --  print("unscheduleScriptEntry.....................")
	        zximg_corner:removeFromParentAndCleanup(true);
	        zximg_corner = nil;     
	        scale_timer:stop()
	    end
    end
    scale_timer:start(t_xsyd0,dismiss)

end


local zximg_jt = nil;
-- 箭头动画		direction 1 = 左 ,direction 2 = 右,direction 3 = 上,direction 4 = 下
function XSZYManager:play_jt_animation( x,y,img_id ,direction,width,height )
	if ( img_id == nil ) then
		img_id = 5;
	end
	if ( zximg_jt ) then
		zximg_jt:removeFromParentAndCleanup(true);
		zximg_jt = nil;
	end
	if not ui_node then ui_node = ZXLogicScene:sharedScene():getUINode() end
	--str = "#c66ff66" .. str;
	-- 如果是左或者右
	if ( direction == 1 ) then
		zximg_jt = MUtils:create_zximg2(ui_node,"nopack/ani_xszy3.png",x  + width , y + height/2,117,39, 45,39,20,39,45,39,20,39,JT_ZORDER);
		zximg_jt:setAnchorPoint(0,0.5);
		--MUtils:create_zxfont(zximg_jt,str,71,12,2,17,2);
		MUtils:create_sprite(zximg_jt,"nopack/xszy/"..img_id..".png",71,23);
	elseif ( direction == 2 ) then
		zximg_jt = MUtils:create_zximg2(ui_node,"nopack/ani_xszy3.png",x - 117 ,y+ height/2,117,39, 45,39,20,39,45,39,20,39,JT_ZORDER);
		zximg_jt:setFlipX(true);
		zximg_jt:setAnchorPoint(0,0.5);
		--MUtils:create_zxfont(zximg_jt,str,71,12,2,17,2);
		MUtils:create_sprite(zximg_jt,"nopack/xszy/"..img_id..".png",45,23);
	elseif ( direction == 3 ) then
		zximg_jt = MUtils:create_zximg2(ui_node,"nopack/ani_xszy2.png",x + width/2 , y - 69 , 88, 69,44, 16, 44, 16,  44, 49, 44, 49,JT_ZORDER);
		zximg_jt:setAnchorPoint(0.5,0);
		--MUtils:create_zxfont(zximg_jt,str,44,8,2,17,2);
		MUtils:create_sprite(zximg_jt,"nopack/xszy/"..img_id..".png",44,17);
	elseif ( direction == 4 ) then
		zximg_jt = MUtils:create_zximg2(ui_node,"nopack/ani_xszy2.png",x + width/2, y + height , 88, 69,44, 16, 44, 16,  44, 49, 44, 49,JT_ZORDER);
		zximg_jt:setFlipY(true);
		zximg_jt:setAnchorPoint(0.5,0);
		--MUtils:create_zxfont(zximg_jt,str,44,8,2,17,2);
		MUtils:create_sprite(zximg_jt,"nopack/xszy/"..img_id..".png",44,52);
	end



	LuaEffectManager:run_move_animation( direction ,zximg_jt);
end

-- 闪烁框的列表
--local blink_view_table = {};
local blink_view = nil;
local blink_scheduler_id = nil;
-- tag 闪烁框的tag,对应不同的view;
function XSZYManager:play_blink_animation( x,y,width,height ,tag)
	if ( blink_scheduler_id ) then
		CCScheduler:sharedScheduler():unscheduleScriptEntry(blink_scheduler_id);
		blink_scheduler_id = nil;
	end
	if ( blink_view ) then
		blink_view:removeFromParentAndCleanup(true);
		blink_view = nil;
	end


	x = x - 2;
	y = y - 2;
	width = width + 4;
	height = height + 4;

	-- 显示一个不停闪烁的框
    blink_view = MUtils:create_zximg(ui_node,"nopack/ani_corner.png",x,y,width,height,3,3,JT_ZORDER);
    local function blink( dt )
    	local blink_rect_color = blink_view:getColor();
    	if ( blink_rect_color == 0xffffffff) then 
	    	blink_view:setColor(0xffff0000);
	    else
	    	blink_view:setColor(0xffffffff);
	    end
    end
    blink_scheduler_id = CCScheduler:sharedScheduler():scheduleScriptFunc(blink, t_xsydblind , false);

   -- print("-------------------------tag = ",blink_scheduler_id);
end

-- xszy退出时销毁按钮
function XSZYManager:destroy( TAG )
	--print("destroy_jt")
	XSZYManager:destroy_jt()
	-- 置空xszy的状态
	self:set_state_and_data(0,nil);
	XSZY_STEP = 1;
	--print("destroy_select_rect")
	if ( TAG ) then
		XSZYManager:destroy_select_rect( TAG );
	end
	--print("destroy_select_rect2")
end
local old_tag = nil;
-- 销毁箭头动画
function XSZYManager:destroy_jt( tag )
	if ( zximg_jt ) then
		--print("...................destroy_jt")
		zximg_jt:stopAllActions();
		zximg_jt:removeFromParentAndCleanup(true);
		zximg_jt = nil;
		if ( tag ) then 
			XSZYManager:destroy_select_rect( tag );
		end
	end
	old_tag = nil;
end

-- 销毁选中框
function XSZYManager:destroy_select_rect( tag )
	-- local view = blink_view_table[tag];
	-- if ( view ) then 
	-- --	print("view = ",view);
	-- 	local scheduler_tag = view:getTag();
	-- 	--print("destroy_select_rect-------------------------scheduler_tag = ",scheduler_tag);
	-- 	CCScheduler:sharedScheduler():unscheduleScriptEntry(scheduler_tag);
	-- 	blink_view_table[tag]:removeFromParentAndCleanup(true);
	-- 	blink_view_table[tag] = nil;
	-- end
	if ( blink_scheduler_id ) then
		CCScheduler:sharedScheduler():unscheduleScriptEntry(blink_scheduler_id);
		blink_scheduler_id = nil;
	end
	if ( blink_view ) then
		blink_view:removeFromParentAndCleanup(true);
		blink_view = nil;
	end

end

-- 取得当前是否有指引
function XSZYManager:is_have_zy_ani()
	if ( zximg_jt or new_sys_panel ) then
		return true;
	end
	return false;
end

-- xszy 播放指引
function XSZYManager:play_jt_and_kuang_animation( x,y,img_id ,direction,width,height ,tag)

	if ( tag == nil ) then
		XSZYManager:play_select_rect_animation( x,y,width,height )
		XSZYManager:play_jt_animation( x,y,img_id ,direction,width,height )
		old_tag = nil;
	elseif ( tag and old_tag ~= tag ) then
		XSZYManager:play_select_rect_animation( x,y,width,height )
		XSZYManager:play_jt_animation( x,y,img_id ,direction,width,height )
		--if ( tag ) then
		XSZYManager:play_blink_animation( x,y,width,height ,tag)
		--end
		old_tag = tag;
	end

end

-- added by aXing on 2013-4-22
-- 添加配置接口
function XSZYManager:play_jt_and_kuang_animation_by_id( id, step, tag, x, y, img_id, direction, width, height )
	-- print("id, step",id, step)
	local config = XSZYConfig:get_config(id, step)
	if config ~= nil then
		-- print("config.x, config.y, config.str,config.direction, config.width, config.height,",config.x, config.y, config.str, 
		-- 	config.direction, config.width, config.height);
		if ( x and y ) then
			config.x = x;
			config.y = y;
		end
		XSZYManager:play_jt_and_kuang_animation(config.x, config.y, config.img_id, 
			config.direction, config.width, config.height, tag)
	end
end

-- 根据新增可接或已接任务id来更新新手指引的状态
function XSZYManager:update_state( quest_id ,type)

	-- --------------HJH
	-- --------------2013-10-30
	-- --------------根据上一次状态与当前状态对比，处理新手指引技能拖拽图片残留问题
	-- local temp_last_state = XSZY_STATE 
	-- if temp_last_state == XSZYConfig.JINENG_ZY and type == 1  then
	-- 	if (quest_id == 51 or quest_id == 80 or quest_id == 22) then
			
	-- 	else
	-- 		XSZYManager:destroy_drag_out_animation()
	-- 	end
	-- end

	---------------modify end
	-- if ( type == 1 ) then
	-- 	-- 赠送灵宠任务	 宠物指引
	-- 	if ( quest_id == 315 or quest_id == 316 or quest_id == 317 ) then
	-- 		self:set_state_and_data(XSZYConfig.CHONG_WU_ZY,quest_id)
	-- 		local win = UIManager:find_window("menus_panel");
	-- 		win:insert_btn( 5 );
	-- 		win:show_or_hide_panel(true);
	-- 		return true;
	-- 	-- 斩除炎魔    挂机指引
	-- 	elseif ( quest_id == 24 or quest_id == 53 or quest_id == 82 ) then
	-- 		self:set_state_and_data(XSZYConfig.GUA_JI_ZY,quest_id)
	-- 	--  坐骑指引任务
	-- 	elseif (quest_id == 28 or quest_id == 57 or quest_id == 86) then
	-- 		self:set_state_and_data(XSZYConfig.ZUO_QI_ZY,quest_id)
	-- 		-- 把下面的按钮弹起来
	-- 		local win = UIManager:find_window("menus_panel");
	-- 		win:insert_btn( 6 );
	-- 		win:show_or_hide_panel(true);
	-- 		-- 打开坐骑界面的cb
	-- 		local function cb()
	-- 			-- UIManager:show_window("mounts_win");
	-- 			win:doMenuFunction(6)
	-- 		end
	-- 		-- 然后马上开始坐骑指引任务 锁定坐骑按钮，其他区域不能点
	-- 		XSZYManager:lock_screen( 70+66*5,6,66,56 , cb);
	-- 		return true;
	-- 	-- 一键征友 屏幕上飘一个征字
	-- 	elseif ( quest_id == 29 or quest_id == 58 or quest_id == 87 ) then
	-- 		local function cb()
	-- 			-- 一键征友
	-- 			FriendCC:send_get_friend();
	-- 		end
	-- 		MiniBtnWin:show( 16 , cb  )
	-- 	-- 商店指引
	-- 	elseif ( quest_id == 89 ) then
	-- 		self:set_state_and_data(XSZYConfig.SHANG_DIAN_ZY,quest_id)
	-- 		-- 弹出打坐指引对话框
	-- 		UIManager:show_window("dazuo_tip")
	-- 	-- 副本指引
	-- 	elseif ( quest_id == 102 ) then
	-- 		self:set_state_and_data(XSZYConfig.FUBEN_ZY,quest_id)
	-- 	-- 兑换指引
	-- 	elseif ( quest_id == 103) then
	-- 		self:set_state_and_data(XSZYConfig.DUI_HUAN_ZY,quest_id)
	-- 		-- 显示右上角的图标 
	-- 		local win = UIManager:find_visible_window("right_top_panel")
	-- 		if win then
	-- 			if win.is_show == false then
	-- 				win:do_hide_menus_fun();
 --        			win.hide_btn:show_frame(1) 
	-- 			end
	-- 		end
	-- 		local function cb()
	-- 			-- XSZYManager:unlock_screen();
	-- 			UIManager:show_window("menus_panel_t");
	-- 			XSZYManager:play_jt_and_kuang_animation_by_id( XSZYConfig.DUI_HUAN_ZY,1 , XSZYConfig.OTHER_SELECT_TAG );
	-- 		end
	-- 		XSZYManager:lock_screen_by_id( XSZYConfig.GONGNENGCAIDAN_BTN, 1, cb )
	-- 		-- -- 先指向功能菜单 120,75,60,60
	-- 		-- XSZYManager:play_jt_and_kuang_animation_by_id( XSZYConfig.GONGNENGCAIDAN_BTN,1 , XSZYConfig.OTHER_SELECT_TAG );
	-- 		return true;
	-- 	-- 渡劫指引
	-- 	elseif ( quest_id == 110 ) then
	-- 		self:set_state_and_data(XSZYConfig.DU_JIE_ZY,quest_id)
	-- 	-- 渡劫2
	-- 	elseif ( quest_id == 118 ) then
	-- 		XSZY_STATE = XSZYConfig.DU_JIE_ZY2;
	-- 		XSZY_DATA = quest_id;
	-- 	-- 诛仙剑阵指引
	-- 	elseif ( quest_id == 133 ) then
	-- 		-- 取消之前的vip3指引
	-- 		local win = MiniTaskPanel:get_miniTaskPanel()
	-- 		if ( win ) then
	-- 			win:stop_xszy()
	-- 		end

	-- 		XSZY_STATE = XSZYConfig.ZXJZ_ZY;
	-- 		XSZY_DATA = quest_id;
	-- 	-- 宠物岛指引
	-- 	elseif ( quest_id == 321 ) then
	-- 		XSZY_STATE = XSZYConfig.CWD_ZY
	-- 		XSZY_DATA = quest_id;
	-- 	-- 宠物融合
	-- 	elseif ( quest_id == 322 ) then
	-- 		XSZY_STATE = XSZYConfig.CWRH_ZY;
	-- 		XSZY_DATA = quest_id;	
	-- 		-- -- 自动打开背包
	-- 		-- UIManager:show_window("bag_win");
	-- 		-- 然后锁定宠物蛋 28292
	-- 	  	if ( PetModel:get_is_max_pet() == false ) then
 --                UIManager:show_window("pet_win");
 --            else
 --            	UIManager:show_window("bag_win");
 --            end
 --            return true;
 --        -- 284蚩尤复苏
 --    	elseif ( quest_id == 284 ) then
 --    		XSZY_STATE = XSZYConfig.FENMODIAN;
	-- 		XSZY_DATA = quest_id;
	-- 	-- 323斩妖除魔指引
	-- 	elseif ( quest_id == 332 ) then
 --    		XSZY_STATE = XSZYConfig.ZYCM_ZY;
	-- 		XSZY_DATA = quest_id;
	-- 	-- 153前尘旧事,姥魔剧情
	-- 	elseif ( quest_id == 153 ) then
	-- 		XSZY_STATE = XSZYConfig.QHZ_ZY;
	-- 		XSZY_DATA = quest_id;
	-- 	-- 灵根指引
	-- 	-- elseif ( quest_id == 333) then

	-- 	-- 	return true;
	-- 	-- 技能指引
	-- 	elseif ( quest_id == 51 or quest_id == 80 or quest_id == 22  ) then
	-- 		XSZY_STATE = XSZYConfig.JINENG_ZY;
	-- 		XSZY_DATA = quest_id;
	-- 		-- 把下面的按钮弹起来
	-- 		local win = UIManager:find_window("menus_panel");
	-- 		win:show_or_hide_panel(true);
	-- 		local function cb()
	-- 			-- UIManager:show_window("user_skill_win");
	-- 			win:doMenuFunction(3)
	-- 		end
	-- 	    -- 指向技能 
	-- 		XSZYManager:lock_screen( 70+66*2,6,66,56 ,cb)
	-- 		return true;
	-- 	-- 炎帝幻境动画
	-- 	elseif ( quest_id == 197 ) then
	-- 		XSZY_STATE = XSZYConfig.YANLUHUANJING_ZY;
	-- 		XSZY_DATA = quest_id;
	-- 	-- 额外增加一个双击传送指引
	-- 	elseif ( quest_id == 135 ) then
	-- 		XSZY_STATE = XSZYConfig.VIP_ZY;
	-- 	-- 取消双击传送指引
	-- 	elseif ( quest_id == 136 ) then
	-- 		XSZY_STATE = 0;
	-- 		-- 跑环指引
	-- 	elseif quest_id == 1006 then
	-- 		XSZY_STATE = XSZYConfig.PAOHUAN_ZY;
	-- 		XSZY_DATA = quest_id;
	-- 		-- 显示右上角的图标 
	-- 		local win = UIManager:find_visible_window("right_top_panel")
	-- 		if win then
	-- 			if win.is_show == false then
	-- 				win:do_hide_menus_fun();
 --        			win.hide_btn:show_frame(1) 
	-- 			end
	-- 		end
	-- 		local function cb()
	-- 			-- XSZYManager:unlock_screen();
	-- 			UIManager:show_window("activity_menus_panel");
	-- 			XSZYManager:play_jt_and_kuang_animation_by_id( XSZYConfig.PAOHUAN_ZY,1 , XSZYConfig.OTHER_SELECT_TAG );
	-- 		end
	-- 		XSZYManager:lock_screen_by_id( XSZYConfig.HUODONG_BTN, 1, cb )		
	-- 	end

	-- elseif ( type == 2) then
	-- 	-- 凌波仙子任务时 装备指引1   狐妖踪迹，装备指引2
	-- 	if ( quest_id == 59 or quest_id == 30 or quest_id == 1 or quest_id == 4 or quest_id == 62 or quest_id == 33) then
	-- 		XSZY_STATE = XSZYConfig.ZHUANG_BEI_ZY;
	-- 		return true;
	-- 	-- 宗门内奸任务, 背包指引
	-- 	elseif ( quest_id == 13 or quest_id == 71 or quest_id == 42 ) then
	-- 		XSZY_STATE = XSZYConfig.BEI_BAO_ZY;
	-- 		-- 把下面的按钮弹起来
	-- 		local win = UIManager:find_window("menus_panel");
	-- 		win:show_or_hide_panel(true);
	-- 		-- 打开背包界面的cb
	-- 		local function cb()
	-- 			-- UIManager:show_window("bag_win");
	-- 			win:doMenuFunction(2)
	-- 		end
	-- 		-- 然后马上开始背包指引任务 锁定背包按钮，其他区域不能点
	-- 		XSZYManager:lock_screen( 70 +66,6,66,56 , cb);
	-- 		return true;
	-- 	-- 坐骑进阶指引
	-- 	elseif ( quest_id == 98 ) then
	-- 		XSZY_STATE = XSZYConfig.ZUO_QI_JINJIE_ZY;
	-- 		-- 马上开始坐骑进阶指引
	-- 		-- 把下面的按钮弹起来
	-- 		local win = UIManager:find_window("menus_panel");
	-- 		win:show_or_hide_panel(true);
	-- 		-- 打开坐骑界面的cb
	-- 		local function cb()
	-- 			-- UIManager:show_window("mounts_win");
	-- 			win:doMenuFunction(6)
	-- 		end
	-- 		-- 然后马上开始坐骑指引任务 锁定背包按钮，其他区域不能点
	-- 		XSZYManager:lock_screen( 70+66*5,6,66,56 , cb);
	-- 		return true;
	-- 	-- 炼器指引
	-- 	elseif ( quest_id == 120 ) then
	-- 		local function cb ()
	-- 			local function cb2()
	-- 				-- UIManager:show_window("forge_win");
	-- 				local win = UIManager:find_window("menus_panel");
	-- 				win:doMenuFunction(7)
	-- 			end
	-- 			XSZYManager:lock_screen( 70 + 66*6,6,66,56 ,cb2)
	-- 		end
	-- 	    -- 开启炼器动画
	-- 		XSZYManager:open_new_sys( 3,cb );
	-- 		XSZY_STATE = XSZYConfig.LIAN_QI_ZY;
	-- 		return true;
	-- 	-- 开启仙宗动画
	-- 	elseif ( quest_id == 125 ) then
	-- 		local function cb()
	-- 			UIManager:show_window("guild_win");
	-- 		end
	-- 		-- 开启炼器动画
	-- 		XSZYManager:open_new_sys( 2,cb );
	-- 		XSZY_STATE = XSZYConfig.XIAN_ZONG_ZY;
	-- 		return true;
	-- 	elseif ( quest_id == 132 ) then
	-- 		-- 清除掉vip3的新手任务指引
	-- 		XSZYManager:destroy();
	-- 		MiniTaskPanel:get_miniTaskPanel():stop_xszy()
	-- 	elseif ( quest_id == 324 ) then
	-- 		-- 开启梦境动画
	-- 		local function cb ()
	-- 			local function cb2()
	-- 				-- UIManager:show_window("dreamland_win");
	-- 				local win = UIManager:find_window("menus_panel");
	-- 				win:doMenuFunction(9)
	-- 			end
	-- 			XSZYManager:lock_screen( 70+66*8,6,66,56,cb2 )
	-- 		end
	-- 		XSZYManager:open_new_sys( 4,cb );
	-- 		XSZY_STATE = XSZYConfig.MENG_JING_ZY;
	-- 		return true;
	-- 	-- vip3新手指引
	-- 	elseif (quest_id == 325) then
	-- 		XSZY_STATE = XSZYConfig.VIP_ZY;
	-- 		-- 打开vip3界面
	-- 		UIManager:show_window("vip3_dialog");
	-- 		return true;
	-- 	-- 灵根剧情
	-- 	elseif ( quest_id == 285) then
	-- 		XSZY_STATE = XSZYConfig.LINGGEN_JQ;
	-- 		JQDH:play_animation( 7 ); 
	-- 		return true;
	-- 		-- 支线任务指引
	-- 	elseif ( quest_id == 116 ) then
	-- 		XSZY_STATE = XSZYConfig.ZHIXIAN_ZY;
	-- 	-- 南诏王剧情
	-- 	elseif ( quest_id == 221 ) then
	-- 		XSZY_STATE = XSZYConfig.NANZHAOWANG_ZY;
	-- 		XSZY_DATA = 222;
	-- 		JQDH:play_animation( 11 ) 
	-- 	elseif ( quest_id == 244 ) then
	-- 		XSZY_STATE = XSZYConfig.HEILONGZHIHUN_ZY;
	-- 		XSZY_DATA = 245;
	-- 		JQDH:play_animation( 12 ) 
	-- 	elseif quest_id == 1015 then
	-- 		XSZY_STATE = XSZYConfig.HUOYUE_ZY;
	-- 		XSZY_DATA = 169;
	-- 		local win = UIManager:find_visible_window("right_top_panel")
	-- 		if win then
	-- 			if win.is_show == false then
	-- 				win:do_hide_menus_fun();
 --        			win.hide_btn:show_frame(1) 
	-- 			end
	-- 		end
	-- 		local function cb()
	-- 			UIManager:show_window("activity_Win");
	-- 			XSZYManager:play_jt_and_kuang_animation_by_id( XSZYConfig.HUOYUE_ZY,1 , XSZYConfig.OTHER_SELECT_TAG );
	-- 		end
	-- 		XSZYManager:lock_screen_by_id( XSZYConfig.DAILY_BTN, 1, cb )		
	-- 	end
	-- end
	return false;
end



-- 开启新系统动画
function XSZYManager:open_new_sys( sys_id ,cb)
	print("open_new_sys---------------------------------sys_id = ",sys_id);
	local path = nil;
    local to_pos_x,to_pos_y = nil;
    local index = nil;
    -- 炼器3
    if ( sys_id == 3) then
    	path = "ui/main/menus/7.png";
   		index = 7;
   	-- 仙宗
   	elseif ( sys_id == 2 ) then
   		path = "ui/main/menus/8.png";
   		index = 8;
   	-- 梦境
   	elseif ( sys_id == 4 ) then
   		path = "ui/main/menus/9.png";
   		index = 9;
    end

    if ( path ) then
    	new_sys_panel = CCArcRect:arcRectWithColor(0,0,800,480, 0x00000055);
		ui_node:addChild(new_sys_panel,99998);
		local function panel_fun(eventType,x,y)
	        if  eventType == TOUCH_BEGAN then
	            return true;
	        elseif eventType == TOUCH_CLICK then
	        	return true;
	        end
	        return true;
	    end
	    new_sys_panel:registerScriptHandler(panel_fun);

	 	to_pos_x = (index-1) * 80 + 40;
		to_pos_y = 40;

		-- 要先把下面的按钮弹上来
		local win = UIManager:find_window("menus_panel");
		win:show_or_hide_panel(true);

    	local spr = MUtils:create_sprite(ui_node,path,400,370,99999);
    	-- 创建闪烁特效
    	LuaEffectManager:play_view_effect( 30002,36,32,spr,true,-1 )

    	-- 创建加速移动动画
    	local move_to = CCMoveTo:actionWithDuration(3.0,CCPoint(to_pos_x,to_pos_y));
    	local move_ease_in = CCEaseIn:actionWithAction(move_to,5.0);
    	
    	local function dismiss( dt )
    		spr:stopAllActions();
    		spr:removeFromParentAndCleanup(true);
    		new_sys_panel:removeFromParentAndCleanup(true);
    		new_sys_panel = nil;
    		win:insert_btn( index );
    		if cb ~= nil then
    			cb()
    		end
	    end

	    new_sys_cb:cancel()
	    new_sys_cb:start( t_xsyd1,dismiss)
	    spr:runAction( move_ease_in );
    end
end

-- 开启特殊的系统动画
function XSZYManager:open_menus_panel_sys( sys_id )
	-- xprint(sys_id);
	local path = nil;
    local to_pos_x,to_pos_y = nil;
    -- 法宝
   	if ( sys_id == GameSysModel.GEM ) then
		path = UIResourcePath.FileLocate.mainMenu .. "fabao.png"
	-- 签到
	elseif ( sys_id == GameSysModel.QianDao ) then
		path = UIResourcePath.FileLocate.mainMenu .. "qiandao.png"
	-- 招财
	elseif sys_id ==  GameSysModel.MONEY_TREE then
		path = UIResourcePath.FileLocate.mainMenu .. "zhaocai.png"
	-- 斗法台
	elseif sys_id == GameSysModel.FIGHTSYS then
		path = UIResourcePath.FileLocate.mainMenu .. "doufatai.png"
	end
	if ( path ) then
    	new_sys_panel = CCArcRect:arcRectWithColor(0,0,800,480, 0x00000000);
		ui_node:addChild(new_sys_panel,99998);
		local function panel_fun(eventType,x,y)
	        if  eventType == TOUCH_BEGAN then
	            return true;
	        elseif eventType == TOUCH_CLICK then
	        	return true;
	        end
	    end
	    new_sys_panel:registerScriptHandler(panel_fun);

	 	to_pos_x = 672;
		to_pos_y = 450;

    	local spr = MUtils:create_sprite(ui_node,path,400,370,99999);
    	-- 创建闪烁特效
    	LuaEffectManager:play_view_effect( 30002,36,32,spr,true,-1 )

    	-- 创建加速移动动画
    	local move_to = CCMoveTo:actionWithDuration(3.0,CCPoint(to_pos_x,to_pos_y));
    	local move_ease_in = CCEaseIn:actionWithAction(move_to,5.0);
    	
    	local function dismiss( dt )
    		spr:stopAllActions();
    		spr:removeFromParentAndCleanup(true);
    		new_sys_panel:removeFromParentAndCleanup(true);
    		new_sys_panel = nil;
	    end

	    new_sys_cb:cancel()
	    new_sys_cb:start( t_xsyd1,dismiss)
	    spr:runAction( move_ease_in );
    end
end

-- 锁定屏幕某一块区域根据xszy_id
function XSZYManager:lock_screen_by_id( id, step, cb )
	local config = XSZYConfig:get_config(id, step)
	if config ~= nil then
		XSZYManager:lock_screen(config.x, config.y,config.width, config.height, cb, 
			config.direction)
	end
end

local lock_panel = nil;

-- 锁定屏幕某一块区域
function XSZYManager:lock_screen( unlock_rect_x,unlock_rect_y,unlock_rect_width,unlock_rect_height ,cb,direction,img_id,is_double_click)
	
	if ( lock_panel ) then 
		return;
	end

	-- 先停止玩家的所有动作
	local player = EntityManager:get_player_avatar();
	player:stop_all_action();

	lock_panel = CCArcRect:arcRectWithColor(0,0,800,480, 0xffffff00);
	local function panel_fun(eventType,arg,msgid,selfitem)
		if eventType == nil or arg == nil or msgid == nil or selfitem == nil then
			return
		end
		--print("panel_fun...........")
        if  eventType == TOUCH_BEGAN then
            XSZYManager:play_select_rect_animation( unlock_rect_x,unlock_rect_y,unlock_rect_width,unlock_rect_height );
            return true;
        elseif eventType == TOUCH_CLICK then
        	return true;
        end
        return true;
    end
    lock_panel:registerScriptHandler(panel_fun);
	ui_node:addChild(lock_panel,JT_ZORDER-1);

	local unlock_panel = CCBasePanel:panelWithFile(unlock_rect_x,unlock_rect_y,unlock_rect_width,unlock_rect_height,nil,0,0);
	lock_panel:addChild(unlock_panel);
	local function unlock_panel_fun(eventType,x,y)
        if  eventType == TOUCH_BEGAN then
            return true;
        elseif eventType == TOUCH_ENDED then
        	return true
        elseif eventType == TOUCH_CLICK then
        	if ( is_double_click == nil ) then
        		XSZYManager:unlock_screen(  ) 
	        	cb();
	        end
        	return true;
        elseif eventType == TOUCH_DOUBLE_CLICK then
        	if ( is_double_click ) then
        		XSZYManager:unlock_screen(  )
        		cb();
        	end
        	return true;
        end
        return true;
    end
    unlock_panel:registerScriptHandler(unlock_panel_fun);
    unlock_panel:setEnableDoubleClick(true);

    if ( direction == nil ) then
    	direction = 4;
    end
    if ( img_id == nil ) then
    	img_id = 5;
    end

    XSZYManager:play_jt_and_kuang_animation( unlock_rect_x,unlock_rect_y, img_id,direction,unlock_rect_width,unlock_rect_height ,XSZYConfig.OTHER_SELECT_TAG);

end
-- 解除屏幕锁定
function XSZYManager:unlock_screen(  )
	if ( lock_panel ) then 
		lock_panel:removeFromParentAndCleanup(true);
		lock_panel = nil;
		XSZYManager:destroy_jt(XSZYConfig.OTHER_SELECT_TAG)
	end
end

-- 取得当前是否已经锁定屏幕
function XSZYManager:get_is_locking_screen()
	if lock_panel then
		return true;
	end
	return false;
end

local drag_out_spr = nil;
-- 显示拖动帮助动画
function XSZYManager:create_drag_out_animation( x,y,_type)

 	if ( _type == 1 ) then
		drag_out_spr = ZXEffectManager:sharedZXEffectManager():run_bezier_action("nopack/drag_out_help.png","nopack/ani/hand1.png", x,y,CCPoint(52, 45),CCPoint(179, 14),CCPoint(273,-50),CCPoint(17,60));
		XSZYManager:play_jt_and_kuang_animation( x,y, 11 ,3,62,62  );
	elseif ( _type == 2 ) then
		drag_out_spr = ZXEffectManager:sharedZXEffectManager():run_bezier_action("nopack/drag_out_help2.png","nopack/ani/hand1.png", x,y,CCPoint(123, 11),CCPoint(258, -8),CCPoint(478,-190),CCPoint(27,185));
		XSZYManager:play_jt_and_kuang_animation( x-20,y+60, 11 ,2,62,62  );
	end
	ui_node:addChild(drag_out_spr,JT_ZORDER)
end

-- 清除拖动帮助
function XSZYManager:destroy_drag_out_animation()
	if ( drag_out_spr ) then 
		drag_out_spr:removeFromParentAndCleanup(true);
		drag_out_spr = nil;
		XSZYManager:destroy_jt(  );
	end
end

local _dqmb_slot_item = nil;
local _dqmb_lab = nil;
local old_item_id = nil;
-- 显示短期目标的道具
function XSZYManager:show_dqmb_award_item( item_id , item_num,dqmb_lv,state )
	
	if ( state == 1 ) then
		if old_item_id and old_item_id == item_id then
			return;
		end

		if ( _dqmb_slot_item ) then
			XSZYManager:destroy_dqmb_award();
		end
		local function cb()
			local player = EntityManager:get_player_avatar();
			if ( player.level >= dqmb_lv ) then 
				DQMBCC:req_get_award( )
			else
				GlobalFunc:create_screen_notic( dqmb_lv .. LangGameString[2306] ); -- [2306]="级领取"
			end
		end
		_dqmb_slot_item = MUtils:create_slot_item( ui_node ,"",520,298,62,62,item_id,cb)
		_dqmb_slot_item:set_item_count( item_num );
		_dqmb_lab = MUtils:create_zxfont(_dqmb_slot_item.view,dqmb_lv .. "级领取",25,-22,2,15);
		_dqmb_slot_item.view:setScale(50/62)

		local action_move = CCMoveBy:actionWithDuration(1,CCPoint(150,0));
		_dqmb_slot_item.view:runAction( action_move );

	elseif ( state == 2 ) then

		-- 如果旧的item_id 与当前item_id 不同,则要删除旧的item
		if ( old_item_id and old_item_id ~= item_id) then
			XSZYManager:destroy_dqmb_award();
		end

		if ( _dqmb_slot_item == nil ) then
			local function cb()
				local player = EntityManager:get_player_avatar();
				if ( player.level >= dqmb_lv ) then 
					DQMBCC:req_get_award( )
				else
					GlobalFunc:create_screen_notic( dqmb_lv .. LangGameString[2306] ); -- [2306]="级领取"
				end
			end
			_dqmb_slot_item = MUtils:create_slot_item( ui_node ,"",670,298,62,62,item_id,cb)
			_dqmb_slot_item:set_item_count( item_num );
			_dqmb_lab = MUtils:create_zxfont(_dqmb_slot_item.view,dqmb_lv .. "级领取",25,-22,2,15);
			_dqmb_slot_item.view:setScale(50/62)
		end
		local action_move = CCMoveTo:actionWithDuration(1,CCPoint(430,298));
		_dqmb_slot_item.view:runAction( action_move );
	end

	old_item_id = item_id;
end

function XSZYManager:destroy_dqmb_award()
	if ( _dqmb_slot_item ) then 
		_dqmb_slot_item.view:removeFromParentAndCleanup(true);
		_dqmb_slot_item = nil;
	end
end

function XSZYManager:set_dqmb_visible( visible )
	if ( _dqmb_slot_item ) then 
		_dqmb_slot_item.view:setIsVisible( visible )
	end
end

-- 当切换副本时要询问下新手指引
function XSZYManager:on_enter_scene( )
	-- 如果没有新手指引就直接返回
	if ( XSZYManager:get_state() == XSZYConfig.NONE ) then
		return;
	end

	local fb_id = SceneManager:get_cur_fuben();
	print("XSZYManager:get_state() = ",XSZYManager:get_state(),"SceneManager:get_cur_scene()",SceneManager:get_cur_scene(),"fb_id",fb_id);
	-- 新手指引代码
	if ( XSZYManager:get_state() == XSZYConfig.GUA_JI_ZY or 
		 ( XSZYManager:get_state() == XSZYConfig.FUBEN_ZY and fb_id == 4 )or 
		 ( XSZYManager:get_state() == XSZYConfig.CWD_ZY and fb_id == 63 ) or 
		 ( XSZYManager:get_state() == XSZYConfig.ZXJZ_ZY and fb_id == 11 ) or
		 ( XSZYManager:get_state() == XSZYConfig.DU_JIE_ZY2 and fb_id == 10) ) then
        if ( fb_id ~= 0 ) then
        	--print("sdlfksdfljskdlfjskldjflskdfkl..................................")
        	XSZYManager:destroy_jt( XSZYConfig.OTHER_SELECT_TAG );
	        -- -- 马上开始挂机指引
	        -- XSZYManager:play_jt_and_kuang_animation( 729, 305,"",2,60,60 , XSZYConfig.OTHER_SELECT_TAG );
	        XSZYManager:play_jt_and_kuang_animation_by_id( XSZYConfig.GUAJI_BTN ,1, XSZYConfig.OTHER_SELECT_TAG);
	    end
	-- 渡劫指引
	elseif ( XSZYManager:get_state() == XSZYConfig.DU_JIE_ZY and fb_id == 9 ) then
		JQDH:play_animation( 2 ) ;
	elseif ( XSZYManager:get_state() == XSZYConfig.YANLUHUANJING_ZY and fb_id == 57 ) then
		JQDH:play_animation( 9 )
	-- 渡劫指引出来时 轩辕墟
	elseif ( XSZYManager:get_state() == XSZYConfig.DU_JIE_ZY and XSZY_STEP == 2 and SceneManager:get_cur_scene() == 4) then 
    	XSZY_STEP = 1;
    	-- 继续做任务
    	local quest_id = XSZYManager:get_data();
        AIManager:do_quest( quest_id,1 );
    -- 渡劫指引2出来时 常青谷
	elseif ( XSZYManager:get_state() == XSZYConfig.DU_JIE_ZY2  and SceneManager:get_cur_scene() == 17) then 
    	XSZY_STEP = 1;

    	-- 继续做任务
    	local quest_id = XSZYManager:get_data();
        AIManager:do_quest( quest_id,1 );
    -- 封魔殿副本
    elseif ( XSZYManager:get_state() == XSZYConfig.FENMODIAN  ) then
    	if ( fb_id == 5 ) then
    		JQDH:play_animation( 3 );
    	else
    		XSZYManager:continue_do_quest()
    	end 
    -- 5:姥魔动画
    elseif ( XSZYManager:get_state() == XSZYConfig.QHZ_ZY ) then
    	if ( fb_id == 6 ) then 
			JQDH:play_animation( 5 );
		else
			XSZYManager:continue_do_quest()
		end
	elseif ( XSZYManager:get_state() == XSZYConfig.BISHAJI_ZY ) then
		-- s1047 = "炎魔洞",s1048 = "炎魔窟",s1049 = "炎魔宫",
		if ( fb_id <1000 ) then
			XSZYManager:continue_do_quest()
		end	
    -- 历练副本和诛仙剑阵指引和宠物岛指引出来后如果在天元城
    elseif ( XSZYManager:get_state() == XSZYConfig.FUBEN_ZY
    	or XSZYManager:get_state() == XSZYConfig.ZXJZ_ZY 
    	or XSZYManager:get_state() == XSZYConfig.CWD_ZY 
    	and SceneManager:get_cur_scene() == 11 ) then
 		XSZYManager:continue_do_quest()
	end
end

function XSZYManager:continue_do_quest( task_type )

	if task_type == nil then 
		task_type = 1;
	end

   	-- 继续做任务
	local quest_id = XSZYManager:get_data();
	if ( quest_id ) then
   	 	AIManager:do_quest( quest_id,task_type );
   	else
   		print("quest_id为空");
   	end
    XSZYManager:destroy( XSZYConfig.OTHER_SELECT_TAG );
end

-- 播放坐骑指引的滑动动画
function XSZYManager:play_zqzy_animation()
	lock_panel = CCArcRect:arcRectWithColor(0,0,800,480, 0x00000055);

	local drag_out_bg = CCProgressTimer:progressWithFile("nopack/up.png");
	drag_out_bg:setAnchorPoint(CCPoint(0.5,0));
	drag_out_bg:setType( kCCProgressTimerTypeVerticalBarBT );
	drag_out_bg:setPosition(CCPoint(400,200));

	local spr_hand = CCSprite:spriteWithFile("nopack/ani/hand1.png");
	spr_hand:setAnchorPoint(CCPoint(0.5,0))
	spr_hand:setPosition(CCPoint(460,170));

	ui_node:addChild(spr_hand,99999);
	ui_node:addChild(drag_out_bg,99999);

	local start_x,start_y = 0,0;

	local function panel_fun(eventType,arg,msgid,selfitem)
		if eventType == nil or arg == nil or msgid == nil or selfitem == nil then
			return
		end
        if  eventType == TOUCH_BEGAN then
        	local click_pos = Utils:Split(arg, ":")
        	start_x = click_pos[1];
		    start_y = click_pos[2];
            return true;
        elseif eventType == TOUCH_CLICK then
        	return true;
        elseif eventType == TOUCH_ENDED then
        	local click_pos = Utils:Split(arg, ":")
        	local end_x = click_pos[1];
    		local end_y = click_pos[2];
	    	if ( end_y - start_y > 100 ) then
		    	-- 上坐骑
		    	MountsModel:ride_a_mount( )
		    	lock_panel:removeFromParentAndCleanup(true);
				lock_panel = nil;
				drag_out_bg:removeFromParentAndCleanup(true);
				spr_hand:removeFromParentAndCleanup(true);

				-- 继续做任务
				AIManager:do_quest( XSZYManager:get_data(), 1);
				XSZYManager:destroy(XSZYConfig.OTHER_SELECT_TAG)
		    end
        	return true;
        end
        return true;
    end
    lock_panel:registerScriptHandler(panel_fun);
	ui_node:addChild(lock_panel,JT_ZORDER-1);



	local moveto1 = CCMoveTo:actionWithDuration(1.2,CCPoint(460,300))
	local delay_time = CCDelayTime:actionWithDuration(0.49);
	local moveto   = CCMoveTo:actionWithDuration(0.01,CCPoint(460,170));
	
	local _array = CCArray:array();
	_array:addObject(moveto1)
	_array:addObject(delay_time)
	_array:addObject(moveto);

	local sequence = CCSequence:actionsWithArray(_array);
	local repeatForever = CCRepeatForever:actionWithAction(sequence);

	local progressTo_action  = CCProgressTo:actionWithDuration(1.2, 100);
	local delay_time2 = CCDelayTime:actionWithDuration(0.5);
	local _array2 = CCArray:array();
	_array2:addObject(progressTo_action)
	_array2:addObject(delay_time2)

	local sequence2 = CCSequence:actionsWithArray(_array2);
	local repeatForever2 = CCRepeatForever:actionWithAction(sequence2);
	
	drag_out_bg:runAction(repeatForever2);
	spr_hand:runAction(repeatForever);

	XSZYManager:play_jt_and_kuang_animation( 415,200, 19 ,1,62,62  );
end

function XSZYManager:destroy_all()
	-- 计时器
	time = 0;
	scale_timer:stop();
	-- 从大到小的框
	if ( zximg_corner ) then
		zximg_corner:removeFromParentAndCleanup(true);
		zximg_corner = nil;
	end
	new_sys_cb:cancel();
	XSZY_STATE = 0;
	-- 指引的第几步
	XSZY_STEP = 1;
	-- 新手指引当前状态需要用到的数据
	XSZY_DATA = nil;

	if ( blink_scheduler_id ) then 
		CCScheduler:sharedScheduler():unscheduleScriptEntry(blink_scheduler_id);
		blink_scheduler_id = nil;
	end
	if ( blink_view ) then
		blink_view:removeFromParentAndCleanup(true);
		blink_view = nil;
	end

	XSZYManager:destroy(  )
	XSZYManager:destroy_drag_out_animation()
	XSZYManager:destroy_dqmb_award()
	XSZYManager:unlock_screen();

	if ( new_sys_panel ) then
		new_sys_panel:removeFromParentAndCleanup(true);
		new_sys_panel = nil;
	end

	ui_node = nil;

end

function XSZYManager:on_show_window(  )
	XSZYManager:is_richang_zy()
end

function XSZYManager:is_richang_zy()
	local player = EntityManager:get_player_avatar();
	-- 是否日常指引
	if ( player and player.mvzs_zy ) then
		XSZYManager:destroy( XSZYConfig.OTHER_SELECT_TAG );
	end
end