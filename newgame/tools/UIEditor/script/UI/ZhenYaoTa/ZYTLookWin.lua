-- ZYTLookWin.lua
-- create by tjh 2014-5-21
-- 镇妖塔查看窗口

super_class.ZYTLookWin(NormalStyleWindow)

--当前层索引
local _curr_floor_index = 1

--挑战回调
local function challenge_cb_func( )
	ZhenYaoTaModel:req_enter_fuben( _curr_floor_index )
	UIManager:hide_window( "zhenyaota_look_win" )
	UIManager:hide_window( "zhenyaota_win" )
end

--关闭回调
local function close_cb_func(  )
	UIManager:hide_window("zhenyaota_look_win")
end 

function ZYTLookWin:__init( window_name, texture_name, is_grid, width, height,title_text )

	-- 再用一层背景覆盖住父类的bg
	ZImage:create( self.view, UILH_COMMON.dialog_bg, 0, 0, width, height - 25, -1,500,500 )
	
	--当前层最大奖励
	self.award_item = {}

	local panel_path = UILH_COMMON.bottom_bg

	-- 层数标题
	self.title_lab = UILabel:create_lable_2( "", 32, 289,16,1)
	self.view:addChild(self.title_lab)


	local panel_path1 = UILH_COMMON.bottom_bg
	local bg_panel1 = CCBasePanel:panelWithFile( 15,60, 386, 220,panel_path1, 500, 500 )
	self.view:addChild(bg_panel1)

	--攻略
	-- local my_lab = UILabel:create_lable_2( "#cfff000BOOS攻略", 10, 260,18,1)
	-- self.view:addChild(my_lab)

    -- 攻略标题
    local guide_title_bg = CCZXImage:imageWithFile(20,247,110,28,UILH_NORMAL.bg_red,0,0)
    self.view:addChild( guide_title_bg );
    MUtils:create_zxfont(guide_title_bg,Lang.zhenyaota[27],110/2,7,2,16);	-- [27] = "BOSS攻略",

	--层主
	local my_lab = UILabel:create_lable_2( "#cfff000"..Lang.zhenyaota[4], 231, 253,16,1)	-- [4] = "层主：",
	self.view:addChild(my_lab)

	--层主
	self.master_lab = UILabel:create_lable_2( Lang.zhenyaota[1], 286, 253,16,1)	-- [1] = "暂无",
	self.view:addChild(self.master_lab)


    self.notice_dialog = CCDialogEx:dialogWithFile( 26, 248, 365, 75, 50, nil, 1 ,ADD_LIST_DIR_UP)
     self.notice_dialog:setFontSize(15)
    self.notice_dialog:setText( Lang.zhenyaota[1] ) -- [1] = "暂无",
    self.notice_dialog:setAnchorPoint(0,1);
    self.view:addChild( self.notice_dialog )


    local split_line = CCZXImage:imageWithFile( 23, 146, 370, 3, UILH_COMMON.split_line);
    self.view:addChild( split_line );

    --奖励
	local my_lab = UILabel:create_lable_2( Lang.zhenyaota[8], 26, 101,16,1);
	self.view:addChild(my_lab)

	local x = 115
	for i=1,3 do
		-- local panel = CCBasePanel:panelWithFile(x,50, 60, 60,panel_path, 500, 500 )
		-- self.view:addChild(panel)
		self.award_item[i] = MUtils:create_slot_item2(self.view,UILH_COMMON.slot_bg2,x, 75, 64, 64, nil, nil,5);
		x = x +100
		--self.award_item[i]:update(24995,3)
	end

	--挑战按钮
 --    self.challenge_btn = ZButton:create( self.view, {UILH_COMMON.button8,UILH_COMMON.button8}, challenge_cb_func, 130, 10, 95, 40 )
	-- MUtils:create_zxfont(self.challenge_btn,"挑战",95/2,14,2,15);

    self.close_btn = ZButton:create( self.view, {UILH_COMMON.lh_button2,UILH_COMMON.lh_button2_s}, close_cb_func, 162, 7, 99, 53 )
	MUtils:create_zxfont(self.close_btn,Lang.common.confirm[20],99/2,21,2,15);	-- [20] = "关闭",
    self.close_btn.view:setIsVisible(false)
end

function ZYTLookWin:update_win( floor,name,str,wtype,award)

	_curr_floor_index = floor
	if name == "" or name == nil then 
		name = Lang.zhenyaota[1]	 -- [1] = "暂无",
	end
	self.master_lab:setText("#cfff000"..name)

	local str_title = string.format(Lang.zhenyaota[14],floor)	-- [14] = "第%d层"
	self.title_lab:setText("#cfff000"..str_title)

	self.notice_dialog:setText(str)

  
	if wtype == ZhenYaoTaModel.CLOSE_TYPE then
		-- self.challenge_btn.view:setIsVisible(false)
		self.close_btn.view:setIsVisible(true)
	elseif wtype == ZhenYaoTaModel.CHALLENGE_TYPE then
		-- 本来是由镇妖塔主页面进入这里的，现在这个路径已经废弃了。
		-- self.challenge_btn.view:setIsVisible(true)
		self.close_btn.view:setIsVisible(true)
	end

	for i=1,3 do
		if i <= #award then
			if self.award_item[i] then
				self.award_item[i]:update( award[i].itemid ,award[i].count,nil,0,0,64,64);
			end
		else
			self.award_item[i]:set_icon_ex()
		end
	end

end
