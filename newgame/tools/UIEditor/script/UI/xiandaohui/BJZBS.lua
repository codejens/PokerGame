-- BJZBS.lua
-- create by hcl on 2013-8-13
-- 本届争霸赛

super_class.BJZBS()

function BJZBS:__init()
	local panel = CCBasePanel:panelWithFile(12,12,875,510,nil,500,500);
	self.view = panel;
	self.tab_player_name = {};
	-- 名字表
	for i=1,8 do
		local bg_1 = MUtils:create_zximg(panel,UILH_COMMON.bg_10,20,500-i*58,170,40,500,500,10)
		self.tab_player_name[i] = MUtils:create_zxfont(bg_1,"",170/2,14,2,16);
		local bg_2 = MUtils:create_zximg(panel,UILH_COMMON.bg_10,675,500-i*58,170,40,500,500,10)
		self.tab_player_name[8+i] = MUtils:create_zxfont(bg_2,"",170/2,14,2,16);
	end

	-- 中间的仙王头像背景
	local head_bg = MUtils:create_zximg(panel,UILH_NORMAL.skill_bg1,393,312,-1,-1)
	MUtils:create_zxfont(head_bg,Lang.xiandaohui[49],89/2,100,2,16)

	-- 龙
	-- MUtils:create_sprite(panel,UIResourcePath.FileLocate.xiandaohui.."zbs_long.png",362,130,3)

	self:create_line( panel );

	self:create_tz_btns()

	-- 仙王头像  (112-75)/2
	self.xw_head_spr = MUtils:create_zximg(head_bg,UIResourcePath.FileLocate.lh_normal .. "head/head10.png",89/2,90/2,-1,-1)
	self.xw_head_spr:setAnchorPoint(0.5,0.5)
	self.xw_head_spr:setScale(0.8)
	self.xw_head_spr:setIsVisible(false);
	-- 仙王名字
	self.xw_name_lab = MUtils:create_zxfont(head_bg,"",89/2,-15,2,16)

	self.title_text = {Lang.xiandaohui[68],Lang.xiandaohui[69],Lang.xiandaohui[70],Lang.xiandaohui[71],Lang.xiandaohui[72]}
	self.label_zbs_state = MUtils:create_zxfont(self.view,"",875/2,25,2,18)	-- 	[68] = "周六揭晓对战人员，敬请期待！",

	return panel;
end

function BJZBS:create_line( panel )
	self.tab_line_view = {};
	-- 比赛图
	-- 16强图(tab_line_view从1到16，分四组创建，每组取i，i+1，i+8和i+9)
	for i=1,7,2 do
		self.tab_line_view[i] = MUtils:create_zximg3(panel,UILH_XIANDAOHUI.xdh_line1_gray,177,486-i*58,1)
		self.tab_line_view[i+1] = MUtils:create_zximg3(panel,UILH_XIANDAOHUI.xdh_line1_gray,177,486-i*58-26,1)
		self.tab_line_view[i+1]:setFlipY(true);

		self.tab_line_view[i+8] = MUtils:create_zximg3(panel,UILH_XIANDAOHUI.xdh_line1_gray,626,486-i*58,1)
		self.tab_line_view[i+8]:setFlipX(true);
		self.tab_line_view[i+9] = MUtils:create_zximg3(panel,UILH_XIANDAOHUI.xdh_line1_gray,626,486-i*58-26,1)	
		self.tab_line_view[i+9]:setFlipX(true);
		self.tab_line_view[i+9]:setFlipY(true);
	end
	-- for i=1,4 do
	-- 	self.tab_line_view[16+(i-1)*2+1] = MUtils:create_zximg3(panel,UIResourcePath.FileLocate.xiandaohui.."zbs_16_line3.png",122+59-14,350-((i-1)*2+1)*40+5,8)
	-- 	self.tab_line_view[16+(i-1)*2+1]:setAnchorPoint(0.5,1.0);
	-- 	self.tab_line_view[16+(i-1)*2+2] = MUtils:create_zximg3(panel,UIResourcePath.FileLocate.xiandaohui.."zbs_16_line3.png",122+59-14,350-((i-1)*2+2)*40-5,8)
	-- 	self.tab_line_view[16+(i-1)*2+2]:setAnchorPoint(0.5,0);
	-- 	self.tab_line_view[16+(i-1)*2+2]:setFlipY(true);

	-- 	self.tab_line_view[24+(i-1)*2+1] = MUtils:create_zximg3(panel,UIResourcePath.FileLocate.xiandaohui.."zbs_16_line3.png",602-59+14,350-((i-1)*2+1)*40+5,8)
	-- 	self.tab_line_view[24+(i-1)*2+1]:setAnchorPoint(0.5,1.0);
	-- 	self.tab_line_view[24+(i-1)*2+1]:setFlipX(true);
	-- 	self.tab_line_view[24+(i-1)*2+2] = MUtils:create_zximg3(panel,UIResourcePath.FileLocate.xiandaohui.."zbs_16_line3.png",602-59+14,350-((i-1)*2+2)*40-5,8)
	-- 	self.tab_line_view[24+(i-1)*2+2]:setAnchorPoint(0.5,0);
	-- 	self.tab_line_view[24+(i-1)*2+2]:setFlipY(true);
	-- 	self.tab_line_view[24+(i-1)*2+2]:setFlipX(true);
	-- end
	-- 8强图
	for i=1,2 do
		self.tab_line_view[32+(i-1)*2+1] = MUtils:create_zximg3(panel,UILH_XIANDAOHUI.xdh_line2_gray,232,436 - (i-1)*232,3)
		self.tab_line_view[32+(i-1)*2+1]:setAnchorPoint(0,1);
		self.tab_line_view[32+(i-1)*2+2] = MUtils:create_zximg3(panel,UILH_XIANDAOHUI.xdh_line2_gray,232,314- (i-1)*232,3)
		self.tab_line_view[32+(i-1)*2+2]:setAnchorPoint(0,0);
		self.tab_line_view[32+(i-1)*2+2]:setFlipY(true);

		self.tab_line_view[36+(i-1)*2+1] = MUtils:create_zximg3(panel,UILH_XIANDAOHUI.xdh_line2_gray,632,436 - (i-1)*232,3)
		self.tab_line_view[36+(i-1)*2+1]:setAnchorPoint(1,1);
		self.tab_line_view[36+(i-1)*2+1]:setFlipX(true);
		self.tab_line_view[36+(i-1)*2+2] = MUtils:create_zximg3(panel,UILH_XIANDAOHUI.xdh_line2_gray,632,314- (i-1)*232,3)
		self.tab_line_view[36+(i-1)*2+2]:setAnchorPoint(1,0);
		self.tab_line_view[36+(i-1)*2+2]:setFlipX(true);
		self.tab_line_view[36+(i-1)*2+2]:setFlipY(true);
	end
	-- 4强图
	self.tab_line_view[41] = MUtils:create_zximg3(panel,UILH_XIANDAOHUI.xdh_line3_gray,272,254,5)
	self.tab_line_view[41]:setAnchorPoint(0,0);
	self.tab_line_view[42] = MUtils:create_zximg3(panel,UILH_XIANDAOHUI.xdh_line3_gray,272,263,5)
	self.tab_line_view[42]:setAnchorPoint(0,1);
	self.tab_line_view[42]:setFlipY(true);

	self.tab_line_view[43] = MUtils:create_zximg3(panel,UILH_XIANDAOHUI.xdh_line3_gray,594,254,5)
	self.tab_line_view[43]:setAnchorPoint(1.0,0);
	self.tab_line_view[43]:setFlipX(true);
	self.tab_line_view[44] = MUtils:create_zximg3(panel,UILH_XIANDAOHUI.xdh_line3_gray,594,263,5)
	self.tab_line_view[44]:setAnchorPoint(1.0,1);
	self.tab_line_view[44]:setFlipX(true);
	self.tab_line_view[44]:setFlipY(true);

	-- 决赛线
	self.tab_line_view[45] = MUtils:create_zximg3(panel,UILH_XIANDAOHUI.xdh_line4_gray,341,258,7)
	self.tab_line_view[45]:setAnchorPoint(0,0.5);
	self.tab_line_view[45]:setFlipX(true);
	self.tab_line_view[46] = MUtils:create_zximg3(panel,UILH_XIANDAOHUI.xdh_line4_gray,528,258,7)
	self.tab_line_view[46]:setAnchorPoint(1,0.5);
end

function BJZBS:do_xz_function(lei_tai,xdh_zbs_user_struct1,xdh_zbs_user_struct2)
	XiaZhuDialog:show( lei_tai,xdh_zbs_user_struct1,xdh_zbs_user_struct2 )
end

function BJZBS:create_tz_btns()
	self.tab_16q_btn = {};
	local x = 208;
	-- 16强的8个投注按钮
	for i=1,8 do
		if ( i == 5 ) then
			x = 602
		end
		local function func( event_type,args,msgid)
			if ( event_type == TOUCH_CLICK ) then
				if ( SceneManager:get_cur_fuben() ~= 72 ) then
					GlobalFunc:create_screen_notic( Lang.xiandaohui[28] ) -- [2217]="争霸赛场景内才能下注"
					return;
				end
				local player_index1 = (i-1)*2+1;
				local player_index2 = (i-1)*2+2;
				local xiazhu_index = self.pk_state_info[i].my_bet;
				local leitai_index = (i-1)%4+1
				local pk_state_index = i;
				XiaZhuDialog:show( leitai_index ,self.xdhzbs_player_table[player_index1],self.xdhzbs_player_table[player_index2],player_index1,player_index2 ,xiazhu_index,pk_state_index )
			end
			return true;
		end
		self.tab_16q_btn[i] = MUtils:create_btn( self.view,UILH_XIANDAOHUI.xiazhu_btn,UILH_XIANDAOHUI.xiazhu_btn,func,x,401 - ((i-1)%4)*117,-1,-1,10);
		self.tab_16q_btn[i]:setIsVisible(false);
		-- self.tab_16q_btn[i]:addTexWithFile(CLICK_STATE_DISABLE,UILH_XIANDAOHUI.xiazhu_btn_d);
		-- self.tab_16q_btn[i]:setCurState(CLICK_STATE_DISABLE)
		MUtils:create_zxfont(self.tab_16q_btn[i],Lang.xiandaohui[50],66/2,25,2,16)	-- "#cffffff下注",
	end

	self.tab_8q_btn = {};
	x = 248;
	-- 8强的4个投注按钮
	for i=1,4 do
		if ( i == 3 ) then
			x = 563
		end
		local function func( event_type,args,msgid)
			if ( event_type == TOUCH_CLICK ) then
				if ( SceneManager:get_cur_fuben() ~= 72 ) then
					GlobalFunc:create_screen_notic( Lang.xiandaohui[28] ) -- [2217]="争霸赛场景内才能下注"
					return;
				end
				local xdh_zbs_user_struct1,xdh_zbs_user_struct2,player_index1,player_index2 = self:get_tz_player_info(1,i);
				local xiazhu_index = self.pk_state_info[8+i].my_bet;
				local pk_state_index = 8 + i;
				XiaZhuDialog:show( i,xdh_zbs_user_struct1,xdh_zbs_user_struct2,player_index1,player_index2 ,xiazhu_index ,pk_state_index)
			end
			return true;
		end
		self.tab_8q_btn[i] = MUtils:create_btn( self.view,UILH_XIANDAOHUI.xiazhu_btn,UILH_XIANDAOHUI.xiazhu_btn,func,x,344 - ((i-1)%2)*234,-1,-1,10);
		self.tab_8q_btn[i]:setIsVisible(false);
		-- self.tab_8q_btn[i]:addTexWithFile(CLICK_STATE_DISABLE,UILH_XIANDAOHUI.xiazhu_btn_d);
		-- self.tab_8q_btn[i]:setCurState(CLICK_STATE_DISABLE)
		MUtils:create_zxfont(self.tab_8q_btn[i],Lang.xiandaohui[50],66/2,25,2,16)	-- "#cffffff下注",
	end
	-- 4强的2个投注按钮
	self.tab_4q_btn = {};
	local function fun1( event_type,args,msgid)
		if ( event_type == TOUCH_CLICK ) then
			if ( SceneManager:get_cur_fuben() ~= 72 ) then
				GlobalFunc:create_screen_notic( Lang.xiandaohui[28] ) -- [2217]="争霸赛场景内才能下注"
				return;
			end
			local xdh_zbs_user_struct1,xdh_zbs_user_struct2,player_index1,player_index2 = self:get_tz_player_info( 2,1 )
			local xiazhu_index = self.pk_state_info[13].my_bet;
			local pk_state_index = 13
			XiaZhuDialog:show( 1,xdh_zbs_user_struct1,xdh_zbs_user_struct2,player_index1,player_index2 ,xiazhu_index,pk_state_index)
		end
		return true;
	end
	self.tab_4q_btn[1] = MUtils:create_btn( self.view,UILH_XIANDAOHUI.xiazhu_btn,UILH_XIANDAOHUI.xiazhu_btn,fun1,315,225,-1,-1,10);
	self.tab_4q_btn[1]:setIsVisible(false);
	-- self.tab_4q_btn[1]:addTexWithFile(CLICK_STATE_DISABLE,UILH_XIANDAOHUI.xiazhu_btn_d);
	-- self.tab_4q_btn[1]:setCurState(CLICK_STATE_DISABLE)
	MUtils:create_zxfont(self.tab_4q_btn[1],Lang.xiandaohui[50],66/2,25,2,16)	-- "#cffffff下注",
	local function fun2( event_type,args,msgid)
		if ( event_type == TOUCH_CLICK ) then
			if ( SceneManager:get_cur_fuben() ~= 72 ) then
				GlobalFunc:create_screen_notic( Lang.xiandaohui[28] ) -- [2217]="争霸赛场景内才能下注"
				return;
			end
			local xdh_zbs_user_struct1,xdh_zbs_user_struct2,player_index1,player_index2 = self:get_tz_player_info( 2,2 )
			local xiazhu_index = self.pk_state_info[14].my_bet;
			local pk_state_index = 14;
			XiaZhuDialog:show( 2,xdh_zbs_user_struct1,xdh_zbs_user_struct2,player_index1,player_index2,xiazhu_index ,pk_state_index)
		end
		return true;
	end
	self.tab_4q_btn[2] = MUtils:create_btn( self.view,UILH_XIANDAOHUI.xiazhu_btn,UILH_XIANDAOHUI.xiazhu_btn,fun2,505,225,-1,-1,10);
	self.tab_4q_btn[2]:setIsVisible(false);
	-- self.tab_4q_btn[2]:addTexWithFile(CLICK_STATE_DISABLE,UILH_XIANDAOHUI.xiazhu_btn_d);
	-- self.tab_4q_btn[2]:setCurState(CLICK_STATE_DISABLE)
	MUtils:create_zxfont(self.tab_4q_btn[2],Lang.xiandaohui[50],66/2,25,2,16)	-- "#cffffff下注",
	-- 决赛的投注按钮
	local function fun3( event_type,args,msgid)
		if ( event_type == TOUCH_CLICK ) then
			if ( SceneManager:get_cur_fuben() ~= 72 ) then
				GlobalFunc:create_screen_notic( Lang.xiandaohui[28] ) -- [2217]="争霸赛场景内才能下注"
				return;
			end
			local xdh_zbs_user_struct1,xdh_zbs_user_struct2,player_index1,player_index2 = self:get_tz_player_info( 3,1 )
			local xiazhu_index = self.pk_state_info[15].my_bet;
			local pk_state_index = 15;
			XiaZhuDialog:show( 1,xdh_zbs_user_struct1,xdh_zbs_user_struct2,player_index1,player_index2,xiazhu_index ,pk_state_index)
		end
		return true;
	end
	self.js_btn = MUtils:create_btn( self.view,UILH_XIANDAOHUI.xiazhu_btn,UILH_XIANDAOHUI.xiazhu_btn,fun3,410,225,-1,-1,10);
	self.js_btn:setIsVisible(false);
	-- self.js_btn:addTexWithFile(CLICK_STATE_DISABLE,UILH_XIANDAOHUI.xiazhu_btn_d);
	-- self.js_btn:setCurState(CLICK_STATE_DISABLE)
	MUtils:create_zxfont(self.js_btn,Lang.xiandaohui[50],66/2,25,2,16)	-- "#cffffff下注",
end

function BJZBS:update( _type,args)
    if ( _type == "zbs_info" ) then
    	self:update_zbs_info( args );
    elseif ( _type == "sub_panel") then
		XianDaoHuiCC:req_zbs_info(  )
    end
end

function BJZBS:active()
	XianDaoHuiCC:req_zbs_info(  )
end

function BJZBS:update_zbs_info( zbs_info )
	local turn = zbs_info.turn;		--第几轮
	local state = zbs_info.lt_state;		--擂台赛状态		0,未开始1,准备2,开始3,结束
	local state_left_time = zbs_info.state_left_time; -- 状态结束时间
	self.xdhzbs_player_table = zbs_info.xdhzbs_player_table;	--玩家数据
	self.pk_state_info = zbs_info.pk_state_info;	--每轮每组pk状态

	print("turn =",turn,"state = ",state,"#xdhzbs_player_table=",#self.xdhzbs_player_table,"#pk_state_info",#self.pk_state_info);

	-- 更新比赛胜负的线
	self:update_line( turn,self.pk_state_info,state);

	-- 更新按钮
	self:udpate_btns( turn,state )
	for i=1,16 do
		if i <= #self.xdhzbs_player_table then
			self.tab_player_name[i]:setText(self.xdhzbs_player_table[i].name)
		else
			self.tab_player_name[i]:setText("");
		end
	end

	-- if ( self.spr_zbs_state ) then
	-- 	self.spr_zbs_state:removeFromParentAndCleanup(true);
	-- 	self.spr_zbs_state = nil;
	-- end
	-- if ( state == 1 ) then
	-- 	self.spr_zbs_state = MUtils:create_sprite(self.view,UIResourcePath.FileLocate.xiandaohui.."zbs_t_"..turn..".png",362,30);
	-- end
	if (state == 1) then
		self.label_zbs_state:setText(self.title_text[turn+1])
	else
		self.label_zbs_state:setText(self.title_text[turn+1])
	end
end

-- 更新比赛胜负的线
function BJZBS:update_line( turn,pk_state_info ,state)
	local tab_line_tex_path = {};

	for i=1,8 do
		local win_index = pk_state_info[i].player_index;
		-- print(i,"的win_index",win_index)
		if ( win_index ~= 0 ) then
			local lost_index = 0;
			if ( win_index%2== 0 ) then
				lost_index = win_index - 1
			else
				lost_index = win_index + 1;
			end
			print("win_index = ",win_index,"lost_index",lost_index);
			tab_line_tex_path[win_index] =  UILH_XIANDAOHUI.xdh_line1
			self.view:reorderChild(self.tab_line_view[win_index],2)
			tab_line_tex_path[lost_index] =  UILH_XIANDAOHUI.xdh_line1_gray
			self.view:reorderChild(self.tab_line_view[lost_index],1)
			-- tab_line_tex_path[win_index+16] =  UIResourcePath.FileLocate.xiandaohui.."zbs_16_line4.png"
			-- self.view:reorderChild(self.tab_line_view[win_index+16],8)
			-- tab_line_tex_path[lost_index+16] =  UIResourcePath.FileLocate.xiandaohui.."zbs_16_line3.png"
			-- self.view:reorderChild(self.tab_line_view[lost_index+16],7)
		else
			tab_line_tex_path[(i-1)*2+1] =  UILH_XIANDAOHUI.xdh_line1_gray
			tab_line_tex_path[(i-1)*2+2] =  UILH_XIANDAOHUI.xdh_line1_gray
			-- tab_line_tex_path[(i-1)*2+1+16] =  UIResourcePath.FileLocate.xiandaohui.."zbs_16_line3.png" 
			-- tab_line_tex_path[(i-1)*2+2+16] =  UIResourcePath.FileLocate.xiandaohui.."zbs_16_line3.png" 
		end
	end
	for i=1,4 do
		local win_index = pk_state_info[i+8].player_index;
		if ( win_index~= 0 ) then
			local win_img_index = 0;
			local lost_img_index = 0;
			if ( ( (win_index-1)%4 ) <2 ) then 
				win_img_index = 32 + (i-1)*2+1;
				lost_img_index = win_img_index +1;
			else
				win_img_index = 32 + (i-1)*2+2;
				lost_img_index = win_img_index - 1;
			end
			tab_line_tex_path[win_img_index] =  UILH_XIANDAOHUI.xdh_line2
			self.view:reorderChild(self.tab_line_view[win_img_index],4) 
			tab_line_tex_path[lost_img_index] =  UILH_XIANDAOHUI.xdh_line2_gray
			self.view:reorderChild(self.tab_line_view[lost_img_index],3)
		else
			tab_line_tex_path[32 + (i-1)*2+1] =  UILH_XIANDAOHUI.xdh_line2_gray
			tab_line_tex_path[32 + (i-1)*2+2] =  UILH_XIANDAOHUI.xdh_line2_gray
		end
	end
	for i=1,2 do
		local win_index = pk_state_info[i+12].player_index
		if ( win_index ~= 0 ) then
			local lost_index = 0;
			if ( ( (win_index-1)%8 ) <4 ) then
				win_index = 40 + (i-1)*2 + 1;
				lost_index = win_index +1;
			else
				win_index = 40 + (i-1)*2+2;
				lost_index = win_index - 1;
			end
			tab_line_tex_path[win_index] =  UILH_XIANDAOHUI.xdh_line3
			self.view:reorderChild(self.tab_line_view[win_index],6)
			tab_line_tex_path[lost_index] =  UILH_XIANDAOHUI.xdh_line3_gray
			self.view:reorderChild(self.tab_line_view[lost_index],5) 
		else
			tab_line_tex_path[40 + (i-1)*2 + 1] =  UILH_XIANDAOHUI.xdh_line3_gray 
			tab_line_tex_path[40 + (i-1)*2 + 2] =  UILH_XIANDAOHUI.xdh_line3_gray 
		end
	end

	local win_index = pk_state_info[15].player_index
	if ( win_index ~= 0 ) then
		-- 更新仙王头像和名字
		print("win_index",win_index)
		local xw_info = XDHModel:get_zbs_info().xdhzbs_player_table[win_index];
		print("xw_info.name",xw_info.name)
		self.xw_head_spr:setTexture( UIResourcePath.FileLocate.lh_normal.."head/head"..(xw_info.head+1)..xw_info.sex..".png" )
		self.xw_head_spr:setIsVisible(true);
		self.xw_name_lab:setText(xw_info.name)
		self.xw_name_lab:setIsVisible(true);

		local lost_index = 0;
		if ( ((win_index-1)%16) <8 ) then
			win_index = 44  +1;
			lost_index = win_index +1;
		else
			win_index = 44 +2;
			lost_index = win_index -1;
		end
		tab_line_tex_path[win_index] =  UILH_XIANDAOHUI.xdh_line4
		self.view:reorderChild(self.tab_line_view[win_index],8)
		tab_line_tex_path[lost_index] =  UILH_XIANDAOHUI.xdh_line4_gray
		self.view:reorderChild(self.tab_line_view[lost_index],7)
	else
		tab_line_tex_path[45] =  UILH_XIANDAOHUI.xdh_line4_gray
		tab_line_tex_path[46] =  UILH_XIANDAOHUI.xdh_line4_gray
		self.xw_head_spr:setIsVisible(false);
		self.xw_name_lab:setIsVisible(false);
	end

	for i=1,46 do
		--self.tab_line_view[i]:setTexture("");
		if self.tab_line_view[i] ~= nil and tab_line_tex_path[i] ~= nil then
			self.tab_line_view[i]:setTexture(tab_line_tex_path[i]);
		end
	end

end

-- 更新投注按钮
function BJZBS:udpate_btns( turn,state )
	if ( state == 1  ) then 
		if ( turn == 1  ) then
			for i=1,#self.tab_16q_btn do
				self.tab_16q_btn[i]:setIsVisible(true);
			end
			for i=1,#self.tab_8q_btn do
				self.tab_8q_btn[i]:setIsVisible(false);
			end
			for i=1,#self.tab_4q_btn do
				self.tab_4q_btn[i]:setIsVisible(false);
			end
			self.js_btn:setIsVisible(false);
		elseif ( turn == 2 ) then
			for i=1,#self.tab_16q_btn do
				self.tab_16q_btn[i]:setIsVisible(false);
			end
			for i=1,#self.tab_8q_btn do
				self.tab_8q_btn[i]:setIsVisible(true);
			end
			for i=1,#self.tab_4q_btn do
				self.tab_4q_btn[i]:setIsVisible(false);
			end
			self.js_btn:setIsVisible(false);
		elseif ( turn == 3 ) then
			for i=1,#self.tab_16q_btn do
				self.tab_16q_btn[i]:setIsVisible(false);
			end
			for i=1,#self.tab_8q_btn do
				self.tab_8q_btn[i]:setIsVisible(false);
			end
			for i=1,#self.tab_4q_btn do
				self.tab_4q_btn[i]:setIsVisible(true);
			end
			self.js_btn:setIsVisible(false);
		elseif ( turn == 4 ) then
			for i=1,#self.tab_16q_btn do
				self.tab_16q_btn[i]:setIsVisible(false);
			end
			for i=1,#self.tab_8q_btn do
				self.tab_8q_btn[i]:setIsVisible(false);
			end
			for i=1,#self.tab_4q_btn do
				self.tab_4q_btn[i]:setIsVisible(false);
			end
			self.js_btn:setIsVisible(true);
		end
	else
		for i=1,#self.tab_16q_btn do
			self.tab_16q_btn[i]:setIsVisible(false);
		end
		for i=1,#self.tab_8q_btn do
			self.tab_8q_btn[i]:setIsVisible(false);
		end
		for i=1,#self.tab_4q_btn do
			self.tab_4q_btn[i]:setIsVisible(false);
		end
		self.js_btn:setIsVisible(false);
	end
end

-- _type 比赛类型1,8强投注  2,4强投注  3,决赛投注 
-- match_index 比赛索引
function BJZBS:get_tz_player_info( _type,match_index )
	local d = 0;
	if ( _type == 1 ) then
		-- 16强中胜利的两位选手
		local player_1_index = self.pk_state_info[(match_index-1)*2+1].player_index;
		local player_2_index = self.pk_state_info[(match_index-1)*2+2].player_index;
		return self.xdhzbs_player_table[player_1_index],self.xdhzbs_player_table[player_2_index],player_1_index,player_2_index;
	elseif (_type == 2 ) then
		-- 8强中胜利的两位选手
		local player_1_index = self.pk_state_info[8+(match_index-1)*2+1].player_index;
		local player_2_index = self.pk_state_info[8+(match_index-1)*2+2].player_index;
		return self.xdhzbs_player_table[player_1_index],self.xdhzbs_player_table[player_2_index],player_1_index,player_2_index;
	elseif (_type == 3 ) then
		-- 4强中胜利的两位选手
		local player_1_index = self.pk_state_info[12+(match_index-1)*2+1].player_index;
		local player_2_index = self.pk_state_info[12+(match_index-1)*2+2].player_index;
		return self.xdhzbs_player_table[player_1_index],self.xdhzbs_player_table[player_2_index],player_1_index,player_2_index;
	end
	

end
