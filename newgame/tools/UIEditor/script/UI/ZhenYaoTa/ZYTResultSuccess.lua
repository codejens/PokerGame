-- ZYTResultSuccess.lua
-- create by tjh 2014-5-21
-- 镇妖塔挑战成功结果

super_class.ZYTResultSuccess(NormalStyleWindow)



function ZYTResultSuccess:__init( window_name, texture_name, is_grid, width, height,title_text )

    -- 再用一层背景覆盖住父类的bg
    ZImage:create( self.view, UILH_COMMON.dialog_bg, 0, 0, width, height - 25, -1,500,500 )

	--保存奖励
 	self.award_item = {}

    local bg_panel = CCBasePanel:panelWithFile( 10, 62, 310, 225,UILH_COMMON.bottom_bg, 500, 500 )
    self.view:addChild(bg_panel)

    self.award_label = UILabel:create_lable_2( Lang.zhenyaota[19], 21, 238,16,1)    -- [19] = "#cfff000获得以下奖励",
    self.award_label:setIsVisible(false)
    self.view:addChild(self.award_label)

    for i=1,3 do
    	self.award_item[i] = MUtils:create_slot_item2(self.view,UILH_COMMON.slot_bg2,i*80+5, 213, 60, 60,nil,nil,5);
        self.award_item[i].view:setIsVisible(false);
    end

    local split_line = CCZXImage:imageWithFile( 18, 195, 295, 3, UILH_COMMON.split_line);
    self.view:addChild( split_line );

    self.ts_lab = UILabel:create_lable_2( Lang.zhenyaota[20], 330/2, 238,16,2) -- [20] = "每周首次通关副本可获得奖励",
    self.view:addChild(self.ts_lab)
    --self.ts_lab:setIsVisible(false)

    self.my_time_lab = UILabel:create_lable_2( Lang.zhenyaota[21]..Lang.zhenyaota[1], 330/2, 170,16,2)   -- [21] = "#c38fe35通关用时：",
    self.view:addChild(self.my_time_lab)
    self.master_time_lab = UILabel:create_lable_2( Lang.zhenyaota[25]..Lang.zhenyaota[1], 330/2, 145,16,2)   --[25] = "#c38fe35层主用时：",
    self.view:addChild(self.master_time_lab)
    self.status_lab = UILabel:create_lable_2( Lang.zhenyaota[22], 330/2, 110,16,2)  -- [22] = "#cfff000只有用时最少，才能成为层主",
    self.view:addChild(self.status_lab)
    	---按钮回调
	local function new_challenges_cb_func( )
        if self.timelab ~= nil then
            self.timelab:destroy();
            self.timelab = nil;
        end
		ZhenYaoTaModel:req_next_fuben(  )
		UIManager:destroy_window("zyt_result_success_win")
	end

	local function exit_cb_func( )
        if self.timelab ~= nil then
            self.timelab:destroy();
            self.timelab = nil;
        end
		OthersCC:req_exit_fuben()
		UIManager:destroy_window("zyt_result_success_win")
	end

	local function end_time_cb_func( )
		exit_cb_func()
	end 

    self.timelab = TimerLabel:create_label(self.view, 167, 80, 14, 10, "#cfff000", end_time_cb_func,false,ALIGN_CENTER)
    local sm_lab = UILabel:create_lable_2( Lang.zhenyaota[15], 65, 80,14,1)    -- [15] = "本副本将于",
    self.view:addChild(sm_lab)
    local my_lab = UILabel:create_lable_2( Lang.zhenyaota[16], 189, 80,14,1)    -- [16] = "后结束",
    self.view:addChild(my_lab)
    
    self.next_floor_btn = ZButton:create( self.view, {UILH_COMMON.btn4_nor,UILH_COMMON.btn4_sel}, new_challenges_cb_func, 40, 8, 121, 53 )
    MUtils:create_zxfont(self.next_floor_btn,Lang.zhenyaota[26],122/2,21,2,16); --"进入下层"

    local btn = ZButton:create( self.view, {UILH_COMMON.btn4_nor,UILH_COMMON.btn4_sel}, exit_cb_func, 180, 8, 121, 53 )
    MUtils:create_zxfont(btn,Lang.zhenyaota[18],122/2,21,2,16); -- "结束挑战"

    -- 不能让玩家点击关闭按钮
    self._exit_btn.view:setIsVisible(false)
end

function ZYTResultSuccess:destroy(  )
    if self.timelab ~= nil then
        self.timelab:destroy();
        self.timelab = nil;
    end
     Window:destroy(self)
end

--更新
function ZYTResultSuccess:update_win( date )
	
	local time_fen = math.floor(date.my_time/60) --分
	local time_miao = date.my_time%60          --秒
	local time_str = string.format(Lang.zhenyaota[2],time_fen,time_miao)   -- [2] = "%d分%d秒",
    self.my_time_lab:setText(Lang.zhenyaota[21]..time_str)  -- [21] = "#c38fe35通关用时：",

    if date.master_time ~= 0 then
      	time_fen = math.floor(date.master_time/60) --分
    	time_miao = date.master_time%60          --秒
    	time_str = string.format(Lang.zhenyaota[2],time_fen,time_miao) -- [2] = "%d分%d秒",
    else
        time_str = Lang.zhenyaota[1];   -- [1] = "暂无",
    end
    self.master_time_lab:setText(Lang.zhenyaota[25]..time_str)  -- [25] = "#c38fe35层主用时：",

    local str = Lang.zhenyaota[22]  -- [22] = "#cfff000只有用时最少，才能成为层主",
    if date.master_relation == 0 then
        str = Lang.zhenyaota[22]
    elseif date.master_relation == 1 then
        str =  string.format(Lang.zhenyaota[23],date.floor_index)   -- [23] = "#cfff000你成为了%d层层主",
    elseif date.master_relation == 2 then
    	str =  string.format(Lang.zhenyaota[24],date.floor_index)  -- [24] = "#cfff000你已经是%d层层主",
    end
    self.status_lab:setText(str) 

    for i=1,3 do
        if i <= date.award_count then
            self.award_item[i]:update( date.award_table[i].item_id ,date.award_table[i].item_count,nil,0,0,60,60);
            self.award_item[i].view:setIsVisible(true);
        else
            self.award_item[i]:set_icon_ex()
            self.award_item[i].view:setIsVisible(false);
        end
    end
    if date.award_count == 0 then 
        self.ts_lab:setIsVisible(true)
        self.award_label:setIsVisible(false)
    else
        self.ts_lab:setIsVisible(false)
        self.award_label:setIsVisible(true)
    end

    -- 第50层，不显示下一层按钮
    if date.curr_floor == 50 then
        self.next_floor_btn.view:setIsVisible(false);
    else
        self.next_floor_btn.view:setIsVisible(true);
    end
end