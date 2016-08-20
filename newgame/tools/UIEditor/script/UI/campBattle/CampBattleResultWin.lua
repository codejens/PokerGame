-- CampBattleResultWin.lua
-- created by fjh on 2013-6-20
-- 阵营战结束的结果窗口
super_class.CampBattleResultWin(NormalStyleWindow)


function CampBattleResultWin:__init(  )
	--窗口标题
	-- local win_title = ZImage:create( self.view,UILH_CAMP.title , 146, 358, -1, -1)
end


function CampBattleResultWin:init_rank_data(my_rank,data )
	-- xprint("function CampBattleResultWin:init_rank_data(my_rank,data )")
    -- 背景底图

    local bg_img2 = MUtils:create_zximg(self.view,UILH_COMMON.bg_grid, 5, 77, 332+35+20, 253,500,500);
    local bg_img3 = MUtils:create_zximg(bg_img2,UILH_CAMP.camp_title, 15, 219, -1, -1);
    
    --阵营试炼前三名
    local lab1 = MUtils:create_zximg( bg_img2,UILH_CAMP.camp_res_lab2, 126, 230, -1, -1);


    local txt_bg_img = MUtils:create_zximg(bg_img2,UILH_CAMP.title_txt_bg, -8, 186, -1, -1);
    local rank_lab = UILabel:create_lable_2( LH_COLOR[2]..Lang.camp[1], 43, 195, 14, ALIGN_CENTER ) -- [677]="#c33ff36"
    bg_img2:addChild(rank_lab);

    local name_lab = UILabel:create_lable_2( LH_COLOR[2]..Lang.camp[2], 134, 195, 14, ALIGN_CENTER ) -- [678]="#c33ff36名字"
    bg_img2:addChild(name_lab);

    local score_lab = UILabel:create_lable_2(LH_COLOR[2]..Lang.camp[3], 235, 195, 14, ALIGN_CENTER ) -- [679]="#c33ff36积分"
    bg_img2:addChild(score_lab);

    local kills_lab = UILabel:create_lable_2( LH_COLOR[2]..Lang.camp[4], 335, 195, 14, ALIGN_CENTER ) -- [680]="#c33ff36击杀"
    bg_img2:addChild(kills_lab);

    -- local data = {{"sssss",222,12},{"sssss",222,12},{"sssss",222,12}};
    local length;
    if #data >= 3 then
    	length = 3;
    else
    	length = #data;
    end
    for i=1,length do
    	if data[i] then
    		self:create_rank_cell( bg_img2, 162-(i-1)*25, i, data[i][2], data[i][10], data[i][7]);
    	end
    end

    ---------------------------昏割线
	local split_img = CCZXImage:imageWithFile( 10,92,370,3,UILH_COMMON.split_line);
	bg_img2:addChild(split_img);

	-- 我的排名
	local lab2 = MUtils:create_zximg( bg_img2,UILH_CAMP.my_rank, 156, 60, -1, -1);

	local my_data = CampBattleModel:get_battle_data( );
	if my_data then
		local player = EntityManager:get_player_avatar();
		self:create_rank_cell( bg_img2, 27, my_rank, player.name, my_data[2], my_data[3]);
	end
	---------------------------昏割线
	-- local split_img = CCZXImage:imageWithFile( 10, 2, 318, 2,UILH_COMMON.split_line);
	-- bg_img2:addChild(split_img);


	local function get_award_func( eventType )
		if eventType == TOUCH_CLICK then
			CampBattleModel:req_battle_reward(  )

			UIManager:hide_window("camp_result_win");
			
		end
		return true;
	end


	local get_award_btn = MUtils:create_btn( self.view, UILH_COMMON.btn4_nor,UILH_COMMON.btn4_nor,get_award_func,138,16,-1,-1);
	--领取奖励文字
	local get_award = UILabel:create_lable_2(LH_COLOR[2]..Lang.activity.fuben[6],62,20,16,ALIGN_CENTER)
	get_award_btn:addChild(get_award)
	-- MUtils:create_zximg(get_award_btn, UIResourcePath.FileLocate.normal .. "get_award.png", 131/2-106/2, 52/2-22/2, 106, 22);


end

function CampBattleResultWin:create_rank_cell( view, height, rank, name, score, kill)
	-- 排名
	-- print("排名,名字,积分,击杀",rank, name, score, kill)
	local rank = UILabel:create_lable_2( LH_COLOR[2]..rank, 41, height, 14, ALIGN_CENTER )
	view:addChild(rank);
	--名字
	local name = UILabel:create_lable_2( LH_COLOR[2]..name, 137, height, 14, ALIGN_CENTER );
	view:addChild(name);
	--积分
	local score = UILabel:create_lable_2( LH_COLOR[2]..score, 233, height, 14, ALIGN_CENTER );
	view:addChild(score);
	--击杀
	local kill = UILabel:create_lable_2( LH_COLOR[3]..kill, 334, height, 14, ALIGN_CENTER );
	view:addChild(kill);

end

function CampBattleResultWin:destory()
	Window.destory(self)
end
