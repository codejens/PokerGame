-- KaJiTuiJianWin.lua
-- create by hcl on 2013-10-22
-- 卡级推荐界面

super_class.KaJiTuiJianWin(Window)

-- 1，诛仙阵2，心魔幻境
local check_fb_tab = { {11,1},{58,1},{60,1},{nil,2},{12,1},{65,1},{nil,3} };
local IMG_PATH = {"fuben_103.jpg","fuben_105.jpg","fuben_106.jpg","xianzong.jpg","fuben_104.jpg","fuben_109.jpg","fuben_108.jpg","fuben_110.jpg","zhanyaochumo.jpg"};

function KaJiTuiJianWin:show()
	-- local index = KaJiTuiJianWin:check_all_quest()
	-- print("index = ",index);
	-- if ( index > 0 ) then
	-- 	local win = UIManager:show_window("kajituijian_win")
	-- 	if win then
	-- 		win:update_all(index);
	-- 	end
	-- else
	-- UIManager:show_window("activity_Win");
	-- end

	-- 火之意志>心魔幻境>守护木叶>神树幻境>羁绊副本
	-- 读取activity_config
	-- 经验副本优先级
	local fb_seq = { 11, 58, 60, 65, 12 }
	local fb_idx = {}
	local data   = ActivityModel:get_activity_info_by_class("fuben")
	local player = EntityManager:get_player_avatar()
	-- found用于标识是否找到能完全满足条件的副本(等级足够、次数足够、按照优先级排序寻找得到的)
	local found  = false
	local index  = 0
	-- tibu_idx 当按照fb_seq的优先级次序,没有找到完全满足条件的副本,也就是玩家没有合适的副本可以进入
	-- 这个时候让玩家进入一个满足等级,但是剩余次数为0的副本(按照fb_seq次序查找到的第一个等级达标的副本)
	local tibu_idx = nil
	for i=1, #fb_seq do
		for key,value in ipairs(data) do
			-- 依次测试经验副本,是否满足条件
			if fb_seq[i] == value.FBID then
				if player.level >= value.level then
					-- 进入次数
					local enter_times = 0
					-- 最大次数
					local max_times   = 0
					-- 剩余次数
					local times_remain_count = 0
					enter_times,max_times = ActivityModel:get_parent_fuben_count(key)
					times_remain_count = max_times - enter_times
					-- 剩余次数 > 0
					if times_remain_count > 0 then
						found = true
						index = key
						break
					end
				elseif not tibu_idx then
					-- 存放没有找到完全满足条件下的,第一个不可进副本(等级满足、次数不满足)
					tibu_idx = key
				end
			end
		end
		-- 找到完全满足条件的副本,跳出循环
		if found then
			break
		end
	end
	-- 有完全满足条件的副本可进
	if found then
		local str = string.format("ShowFubenList,%d", index-1)
		GameLogicCC:req_talk_to_npc(0, str)
	-- 有等级满足、剩余进入次数不满足的副本
	elseif tibu_idx then
		local str = string.format("ShowFubenList,%d", tibu_idx-1)
		GameLogicCC:req_talk_to_npc(0, str)
	end
end

function KaJiTuiJianWin:__init( )
	-- self:create_close_btn_and_title()

	-- self.window_title_bg.view:removeFromParentAndCleanup(true);

	-- local spr_bg = CCZXImage:imageWithFile( 0, 0, 400, 408, UIResourcePath.FileLocate.common .. "bg_blue.png",  120,88,120,88,120,74,120,74 );
 --    self.view:addChild( spr_bg );

    local bg = ZImage:create(self.view,UIPIC_GRID_nine_grid_bg3,200,260,360+10,184+10,0,500,500);
    bg.view:setAnchorPoint(0.5,0.5)

	self.img_bg = MUtils:create_zximg(self.view,"",200,260,360,184);
	self.img_bg:setAnchorPoint(0.5,0.5)
	-- MUtils:create_sprite(self.view,"ui/dailyActivity/tj.png",80,350);

	-- 名字
	self.name = MUtils:create_zxfont(self.view,"",200,330,2,20);
	-- self.content = MUtils:create_ccdialogEx(self.view,"诛仙阵乃考验必杀技之阵，可获得海量经验和珍稀",20,177,334,50,30,16)
	-- self.content:setAnchorPoint(0,1.0);
	self.content = MUtils:create_zxfont(self.view,"",200,177,2,14);
	-- MUtils:create_zximg(self.view,"ui/common/dujie_bg_2.png",20,170,360,27,500,500)
	-- -- 速传 和立即参加按钮
	-- local function sc( event_type,args,msgid )
	-- 	if event_type == TOUCH_CLICK then

	-- 	end
	-- 	return true;
	-- end
	-- MUtils:create_common_btn( self.view,"速传",sc,130,220 )
	-- local function join( event_type,args,msgid )
	-- 	if event_type == TOUCH_CLICK then

	-- 	end
	-- 	return true;
	-- end
	-- MUtils:create_common_btn( self.view,"立即参加",join,250,220 )

	-- self.content2 = MUtils:create_ccdialogEx(self.view,"#c35C3F7诀窍：提升一定的战斗力再去挑战副本，可以轻松挑战更高的层级",30,210,325,50,50,16)
	-- self.content2:setAnchorPoint(0,1.0);

	
	-- MUtils:create_sprite(self.view,"ui/kajituijian/t.png",140,123);
	local btn_str_tab = {"ui/dailyActivity/character_fly.png","ui/dailyActivity/character_go.png"}
	for i=1,2 do
		local function btn_fun(event_type,args,msgid)
			if event_type == TOUCH_CLICK then
				self:do_btn_method(i);
			end
			return true;
		end
		local btn = MUtils:create_btn(self.view,"ui/common/button_bg3_s.png",nil,btn_fun,105+(i-1)*110,35,-1,-1);
		MUtils:create_sprite(btn,btn_str_tab[i],38.5,39);
	end

	self.star_name_1 = MUtils:create_zxfont(self.view,"",35,140,1,16)
	self.star_name_2 = MUtils:create_zxfont(self.view,"",35,110,1,16)
    self.star_range_1  = MUtils:create_star_range( self.view, 80, 140, 16, 16, 4 ) 
    self.star_range_2  = MUtils:create_star_range( self.view, 80, 110, 16, 16, 5 ) 

    local function text_btn_fun( event_type)
    	if event_type == TOUCH_CLICK then
    		UIManager:show_window("activity_Win");
    	end
    	return true;
    end

    MUtils:create_text_btn(self.view,LangGameString[1305],310,22,100,30,text_btn_fun,16) -- [1305]="#cFF49F4#u1更多...#u0"

end

function KaJiTuiJianWin:do_btn_method(index)
	if self._type == 3 then
		-- 打开斩妖除魔榜
		GlobalFunc:open_or_close_window( 16 ,0 ,nil );
	else
		if self.target_scene and self.target_name then
			if index == 1 then
				GlobalFunc:teleport( self.target_scene,self.target_name )
			elseif index == 2 then
				GlobalFunc:ask_npc( self.target_scene,self.target_name  )
			end
		end
	end

end

function KaJiTuiJianWin:create_close_btn_and_title()
    -- -- 标题
    -- local wing_title_sp = CCZXImage:imageWithFile(389/2-230/2+18,429-45,226,46,UIResourcePath.FileLocate.common .. "win_title1.png");
    -- self.view:addChild(wing_title_sp,99);
    -- self.title = CCZXImage:imageWithFile(226/2-107/2-5,46/2-30/2+4,113,22,"");
    -- wing_title_sp:addChild(self.title);
    -- local function close_fun(event_type,args,msgid )
    --     if event_type == TOUCH_CLICK then
    --         UIManager:hide_window("kajituijian_win");
    --     end
    --     return true
    -- end

    -- -- 关闭按钮
    -- local close_btn = CCNGBtnMulTex:buttonWithFile(344, 370, -1, -1, UIResourcePath.FileLocate.common .. "close_btn_n.png")
    -- local exit_btn_size = close_btn:getSize()
    -- local spr_bg_size = self:getSize()
    -- close_btn:setPosition( spr_bg_size.width - exit_btn_size.width, spr_bg_size.height - exit_btn_size.height )
    -- close_btn:addTexWithFile(CLICK_STATE_DOWN,UIResourcePath.FileLocate.common .. "close_btn_s.png")
    -- --注册关闭事件
    -- close_btn:registerScriptHandler(close_fun) 
    -- self.view:addChild(close_btn,99)
end

function KaJiTuiJianWin:check_all_quest()
	local curr_index = 0;
	local player = EntityManager:get_player_avatar();
	for i,v in ipairs(check_fb_tab) do
		if ( v[2] == 1 ) then
			local max_count = FuBenModel:get_enter_fuben_max_count( v[1] )
			local fuben_info = FuBenModel:get_fuben_info_table()
			local activity_info = ActivityModel:get_activity_info_by_id( "fuben",v[1] )
			if player.level >= activity_info.level and fuben_info[v[1]+1].count < max_count then
				curr_index = i;
				break;
			end
		elseif ( v[2] == 2 and GuildModel:check_if_join_guild( ) ) then
			-- 取得仙宗任务次数
			local max_count = SecretaryModel:get_xianzong_count(  );
			-- print("xianzong_count---------------------------------------",max_count)
			if ( max_count > 0 ) then
				curr_index = i;
			end
		elseif ( v[2] == 3 ) then
			-- 取得斩妖除魔任务次数
			local max_count = SecretaryModel:get_zhanyao_count(  );
			-- print("zhanyaorenwu_count------------------------------------------",max_count)
			if ( max_count > 0 ) then
				curr_index = i;
			end
		end
	end
	return curr_index;
end

function KaJiTuiJianWin:update_all( curr_index )

	-- 先判断副本次数是否有
	if ( curr_index > 0 ) then
		local _type = check_fb_tab[curr_index][2];
		if ( _type == 1 ) then
			local fb_id = check_fb_tab[curr_index][1]
			local activity_info = ActivityModel:get_activity_info_by_id( "fuben",fb_id )
			print(activity_info.location.name,activity_info.desc)
			self.name:setText("#cfff000"..activity_info.location.entityName);
			self.content:setText(Lang.fuben_tip[fb_id]);
			local stars_info_ret_t = self:get_stars_info( activity_info )
			if ( stars_info_ret_t[1] ) then
				self.star_name_1:setText( "#cffff00"..stars_info_ret_t[1].name..": " )
		        self.star_range_1.change_star_num( stars_info_ret_t[1].num )
		    else
		    	self.star_name_1:setText("")
		        self.star_range_1.change_star_num( 0 )
		    end
	        if ( stars_info_ret_t[2] ) then
		        self.star_name_2:setText( "#cffff00"..stars_info_ret_t[2].name..": " )
		        self.star_range_2.change_star_num( stars_info_ret_t[2].num )
		    else
		    	self.star_name_2:setText("")
		        self.star_range_2.change_star_num( 0 )
		    end
		    self.target_scene = activity_info.location.sceneid;
		    self.target_name = activity_info.location.entityName;
		elseif ( _type == 2 ) then
			self.name:setText(LangGameString[1306]); -- [1306]="#cfff000仙宗任务"
			self.content:setText(Lang.fuben_tip[800]);
			self.star_name_1:setText(LangGameString[1307]) -- [1307]="经验"
		    self.star_range_1.change_star_num( 4 )
		    self.star_name_2:setText("")
		    self.star_range_2.change_star_num( 0 )
		    self.target_scene = 11;
		    self.target_name = LangGameString[1308]; -- [1308]="仙宗管理员"
		elseif ( _type == 3 ) then
			self.name:setText(LangGameString[1309]); -- [1309]="#cfff000斩妖除魔"
			self.content:setText(Lang.fuben_tip[900]);
			self.star_name_1:setText(LangGameString[1307]) -- [1307]="经验"
		    self.star_range_1.change_star_num( 4 )
		    self.star_name_2:setText("")
		    self.star_range_2.change_star_num( 0 )
		    self.target_scene = nil;
		    self.target_name = "";
		end
		self.img_bg:setTexture("ui/dailyActivity/scene/"..IMG_PATH[curr_index]);
		self._type = _type;
	end
end

function KaJiTuiJianWin:get_stars_info( activity_info )
	local stars_info_ret_t = {}        -- 返回的信息
	local name_t = { LangGameString[1307], LangGameString[1310], LangGameString[415], LangGameString[411], LangGameString[1311], LangGameString[1312], LangGameString[412] } -- [1307]="经验" -- [1310]="灵气" -- [415]="历练" -- [411]="仙币" -- [1311]="装备" -- [1312]="道具" -- [412]="银两"
	require "config/ActivityConfig"
	if activity_info then
	    local stars_t = activity_info.stars
	    for i = 1, #stars_t do
	    	stars_info_ret_t[i] = {}
            stars_info_ret_t[i].name = name_t[ stars_t[i][1] ] or ""
            stars_info_ret_t[i].num  = stars_t[i][2] or 1
	    end
	end
	return stars_info_ret_t
end
-- 每次退出更新次数
function KaJiTuiJianWin:active(show)
	if show == false then
		SecretaryModel:request_HZYX_count(  )
	end
end
