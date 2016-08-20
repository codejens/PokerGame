-- ZYTResultFail.lua
-- create by tjh 2014-5-21
-- 镇妖塔挑战失败结果

super_class.ZYTResultFail(NormalStyleWindow)



function ZYTResultFail:__init( window_name, texture_name, is_grid, width, height,title_text )

	-- 再用一层背景覆盖住父类的bg
	ZImage:create( self.view, UILH_COMMON.dialog_bg, 0, 0, width, height - 25, -1,500,500 )

	local panel_path = UILH_COMMON.bottom_bg
	local bg_panel = CCBasePanel:panelWithFile( 12, 12, 285, 130,panel_path, 500, 500 )
	self.view:addChild(bg_panel)

    	---按钮回调
	local function new_challenges_cb_func( )
		if self.timelab ~= nil then
			self.timelab:destroy();
			self.timelab = nil;
		end
		ZhenYaoTaModel:req_again_challenge(  )
		UIManager:destroy_window("zyt_result_fail_win")
	end

	local function exit_cb_func( )
		if self.timelab ~= nil then
			self.timelab:destroy();
			self.timelab = nil;
		end
		OthersCC:req_exit_fuben()
		UIManager:destroy_window("zyt_result_fail_win")
	end

	local function end_time_cb_func( )
		exit_cb_func()
	end 

    self.timelab = TimerLabel:create_label(self.view, 163, 35, 14, 10, "#cfff000", end_time_cb_func,false,ALIGN_CENTER)
    local sm_lab = UILabel:create_lable_2( Lang.zhenyaota[15], 58, 35,14,1)	-- [15] = "本副本将于",
    self.view:addChild(sm_lab)
    local my_lab = UILabel:create_lable_2( Lang.zhenyaota[16], 185, 35,14,1)	-- [16] = "后结束",
    self.view:addChild(my_lab)

    local btn = ZButton:create( self.view, {UILH_COMMON.btn4_nor,UILH_COMMON.btn4_sel}, new_challenges_cb_func, 25, 65, 121, 53 )
    MUtils:create_zxfont(btn,Lang.zhenyaota[17],122/2,21,2,16);	--[17] = "重新挑战",

    local btn = ZButton:create( self.view, {UILH_COMMON.btn4_nor,UILH_COMMON.btn4_sel}, exit_cb_func, 165, 65, 121, 53 )
    MUtils:create_zxfont(btn,Lang.zhenyaota[18],122/2,21,2,16);	-- [18] = "结束挑战",

    -- 不能让玩家点击关闭按钮
	self._exit_btn.view:setIsVisible(false)
end

function ZYTResultFail:destroy(  )
	if self.timelab ~= nil then
		self.timelab:destroy();
		self.timelab = nil;
	end
   	Window:destroy(self)
end