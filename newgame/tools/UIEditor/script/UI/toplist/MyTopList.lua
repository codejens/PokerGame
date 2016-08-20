------------------------------
------------------------------
----HJH
----2013-2-27
----我的排行榜界面
------------------------------
super_class.MyTopList(Window)
------------------------------
local function createMyTopList(self, width, height)
	------------------------------
	local _exit_info = { width = -1, height = -1, image = {UILH_COMMON.close_btn_z, UILH_COMMON.close_btn_z} }

	local _title_info = { image =UILH_TOPLIST.my_top_list_title, text = Lang.topList.mytoplist[1], fontsize = 23 } -- [2098]="我的排行榜"
	local _detial_info = { text = {Lang.topList.mytoplist[2], Lang.topList.mytoplist[3], Lang.topList.mytoplist[4], Lang.topList.mytoplist[16]}, fontsize = 18 } -- [2099]="#cfff000个人实力" -- [2100]="#cfff000坐骑法宝" -- [2101]="#cfff000鲜花魅力"
	local _other_info = { fontsize = 16, text = {Lang.topList.mytoplist[5],Lang.topList.mytoplist[6], Lang.topList.mytoplist[7], Lang.topList.mytoplist[8], Lang.topList.mytoplist[9], Lang.topList.mytoplist[10], Lang.topList.mytoplist[11], Lang.topList.mytoplist[12],Lang.topList.mytoplist[13],Lang.topList.mytoplist[14] } } 
	-- [2102]="#c00ff00战斗力排行" -- [2103]="#c00ff00等级排行" -- [2104]="#c00ff00灵根排行" -- [2105]="#c00ff00成就排行" -- [2106]="#c00ff00坐骑排行" -- [2107]="#c00ff00法宝排行" -- [2108]="#c00ff00魅力排行" -- [2109]="#c00ff00每周魅力排行"
	------------------------------
	-- require "UI/component/Label"
	-- require "UI/component/Button"
	-- require "UI/component/Image"
	-- require "UI/component/ListVertical"
	-- require "model/TopListModel"

	local brid = ZImage:create(self, UILH_COMMON.style_bg, -15, -15, width+20, height+20, nil, 600, 600)
	-- local bg = ZImage:create(self, UILH_COMMON.bg_02, 10, 8, width-30, height-50, 0, 500, 500)
	-- bg.view:setOpacity(210)
	----标题栏
	local title_bg = ZImage:create(self, UILH_COMMON.title_bg, 0, 0, -1, 60)
	local title_bg_size = title_bg:getSize()
	title_bg:setPosition( ( width - title_bg_size.width ) / 2, height - title_bg_size.height + 20 )
	self.win_title = ZImage:create( title_bg, _title_info.image,  title_bg_size.width/2,  title_bg_size.height-27, -1, -1) --Label:create( nil, 0, 0, _title_info.text, _title_info.fontsize )
	self.win_title.view:setAnchorPoint(0.5,0.5)
	----关闭按钮
	
	self.exit_button = ZButton:create( nil, _exit_info.image, nil, 0, 0, 60, 60)
	local exit_size = self.exit_button.view:getSize()
	self.exit_button:setPosition(width - 60, height - 40)
	self.exit_button:setTouchClickFun(TopListModel.my_top_list_exit_button_click_fun)

	-------底板 (254,44) && (77, 22)
	local  top_bg = ZImage:create(self,UILH_COMMON.normal_bg_v2, 0, -5, 420, 490, 0, 500, 500)
	local type_img1		= ZImage:create(self, UILH_COMMON.bottom_bg, 15, 340, 390, 110, nil, 500, 500)
	local type_bg1		= ZImage:create(self, UILH_NORMAL.title_bg3, 30, 425, -1, -1)
	local type_title1	= ZImage:create(type_bg1, UILH_TOPLIST.my_text1, 140, (44-22)*0.5, -1, -1)
	-- local type_title1	= ZLabel:create(type_bg1, _detial_info.text[1], 178, 17, 16, 2)
	local type_img2		= ZImage:create(self, UILH_COMMON.bottom_bg, 15, 230, 390, 85, nil, 500, 500)
	local type_bg2		= ZImage:create(self, UILH_NORMAL.title_bg3, 30, 290, -1, -1)
	local type_title2	= ZImage:create(type_bg2, UILH_TOPLIST.my_text3, 140, (44-22)*0.5, -1, -1)
	-- local type_title2	= ZLabel:create(type_bg2, _detial_info.text[2], 178, 17, 16, 2)
	local type_img3		= ZImage:create(self, UILH_COMMON.bottom_bg, 15, 120, 390, 85, nil, 500, 500)
	local type_bg3		= ZImage:create(self, UILH_NORMAL.title_bg3, 30, 180, -1, -1)
	local type_title3	= ZImage:create(type_bg3, UILH_TOPLIST.my_text2, 140, (44-22)*0.5, -1, -1)
	-- local type_title3	= ZLabel:create(type_bg3, _detial_info.text[3], 178, 17, 16, 2)
	local type_img4		= ZImage:create(self, UILH_COMMON.bottom_bg, 15, 10, 390, 85, nil, 500, 500)
	local type_bg4		= ZImage:create(self, UILH_NORMAL.title_bg3, 30, 70, -1, -1)
	local type_title4	= ZImage:create(type_bg4, UILH_TOPLIST.my_text4, 140, (44-22)*0.5, -1, -1)
	-- local type_title4	= ZLabel:create(type_bg4, _detial_info.text[4], 178, 17, 16, 2)
	-------------------------
	local left_star_pos = {x = 20, y = height - 80 }
	local title_gap = 40
	local info_text_size = 20
	local size_info = { 95, 95, 95, 45 }
	-- 个人实力
	-- self.personal_title = ZImageImage:create(nil,UIPOS_MyTopList_05 ,nil, left_star_pos.x-30, left_star_pos.y-15, 150, -1, 500, 500)	
	--ZLabel:create( nil, _detial_info.text[1], left_star_pos.x, left_star_pos.y , _detial_info.fontsize )
	-- local personal_title_pos = self.personal_title:getPosition()

    ----战力排名  等级排名-------------------------------------------------
	local default_text = Lang.topList.mytoplist[15] -- [15]="未上榜"
	local attack_name_label = ZLabel:create( nil, Lang.topList.mytoplist[5], 0, 0, _other_info.fontsize )
	local attack_score_label = ZLabel:create( nil, default_text, 0, 0, _other_info.fontsize )
	local level_name_label = ZLabel:create( nil, Lang.topList.mytoplist[6], 0, 0, _other_info.fontsize )
	local level_score_lable = ZLabel:create( nil, default_text, 0, 0, _other_info.fontsize )

	self.one_info = ZListVertical:create( nil, left_star_pos.x+10, 400, width - left_star_pos.x * 2, _other_info.fontsize, size_info, 1, 2 )
	self.one_info:addItem(attack_name_label)
	self.one_info:addItem(attack_score_label)
	self.one_info:addItem(level_name_label)
	self.one_info:addItem(level_score_lable)
	local one_info_pos = self.one_info:getPosition()

	-------成就，奇经八脉排名----------------------------------------------

	local achieve_name_label = ZLabel:create( nil, Lang.topList.mytoplist[8], 0, 0, _other_info.fontsize )
	local achieve_score_label = ZLabel:create( nil, default_text, 0, 0, _other_info.fontsize )
	local lg_name_label = ZLabel:create( nil, Lang.topList.mytoplist[7], 0, 0, _other_info.fontsize )
	local lg_score_label = ZLabel:create( nil, default_text, 0, 0, _other_info.fontsize )

	self.two_info = ZListVertical:create( nil, left_star_pos.x+10, one_info_pos.y - _other_info.fontsize - 25, width - left_star_pos.x * 2, _other_info.fontsize, size_info, 1, 2 )
	self.two_info:addItem(achieve_name_label)
	self.two_info:addItem(achieve_score_label)
	self.two_info:addItem(lg_name_label)
	self.two_info:addItem(lg_score_label)


	--self.pet_fb_title = ZImageImage:create(nil, UIPOS_MyTopList_07,nil, left_star_pos.x-30, two_info_pos.y - _detial_info.fontsize - title_gap+33, 150, -1, 500, 500)
	--ZLabel:create( nil, _detial_info.text[2], left_star_pos.x, two_info_pos.y - _detial_info.fontsize - title_gap, _detial_info.fontsize)
	--local pet_fb_title_pos = self.pet_fb_title:getPosition()

     ------------翅膀排名： 灵器排名：-------------------------------
    local wing_name_label = ZLabel:create( nil, Lang.topList.mytoplist[10], 0, 0, _other_info.fontsize )
	local wing_score_label = ZLabel:create( nil, default_text, 0, 0, _other_info.fontsize )
	local trump_name_label = ZLabel:create( nil, Lang.topList.mytoplist[13], 0, 0, _other_info.fontsize )
	local trump_score_label = ZLabel:create( nil, default_text, 0, 0, _other_info.fontsize )

	self.three_info = ZListVertical:create( nil, left_star_pos.x+10, 258, width - left_star_pos.x, _other_info.fontsize, size_info, 1, 2 )

	self.three_info:addItem(wing_name_label)
	self.three_info:addItem(wing_score_label)
	self.three_info:addItem(trump_name_label)
	self.three_info:addItem(trump_score_label)

	local three_info_pos = self.three_info:getPosition()

    --伙伴排名 坐骑排名
	local pet_name_label = ZLabel:create( nil, Lang.topList.mytoplist[14], 0, 0, _other_info.fontsize )
	local pet_score_label = ZLabel:create( nil, default_text, 0, 0, _other_info.fontsize )

    local mount_name_label = ZLabel:create( nil, Lang.topList.mytoplist[9], 0, 0, _other_info.fontsize )
	local mount_score_label = ZLabel:create( nil, default_text, 0, 0, _other_info.fontsize )

	self.four_info = ZListVertical:create( nil, left_star_pos.x+10, 148, width - left_star_pos.x, _other_info.fontsize, size_info, 1, 2 )
	self.four_info:addItem(pet_name_label)
	self.four_info:addItem(pet_score_label)
	self.four_info:addItem(mount_name_label)
	self.four_info:addItem(mount_score_label)


	-----------鲜花魅力
	-- size_info = { 90, 70, 125, 45 }
	-- self.flower_charm_title = ZImageImage:create(nil, UIPOS_MyTopList_06,nil, left_star_pos.x-30, four_info_pos.y - _other_info.fontsize - title_gap+33, 150, -1, 500, 500)
	--ZLabel:create( nil, _detial_info.text[3], left_star_pos.x, three_info_pos.y - _other_info.fontsize - title_gap, _detial_info.fontsize )
	-- local flower_charm_title_pos = self.flower_charm_title:getPosition()
	---------
	local charm_name_label = ZLabel:create( nil, Lang.topList.mytoplist[11], 0, 0, _other_info.fontsize )
	local charm_score_label = ZLabel:create( nil, default_text, 0, 0, _other_info.fontsize )
	local per_week_charm_name_label = ZLabel:create( nil, Lang.topList.mytoplist[12], 0, 0, _other_info.fontsize )
	local per_week_charm_score_label = ZLabel:create( nil, default_text, 0, 0, _other_info.fontsize )
	local size_info2 = {105, 85, 105, 45}
	self.five_info = ZListVertical:create( nil, left_star_pos.x+10, 38, width - left_star_pos.x, _other_info.fontsize, size_info2, 1, 2 )
	self.five_info:addItem(charm_name_label)
	self.five_info:addItem(charm_score_label)
	self.five_info:addItem(per_week_charm_name_label)
	self.five_info:addItem(per_week_charm_score_label)
	-------------------------------

	-------------------------------
	-- self.view:addChild(self.personal_title.view)
	--self.view:addChild(self.pet_fb_title.view)
	-- self.view:addChild(self.flower_charm_title.view)
	self.view:addChild(self.one_info.view)
	self.view:addChild(self.two_info.view)
	self.view:addChild(self.three_info.view)
	self.view:addChild(self.four_info.view)
	self.view:addChild(self.five_info.view)
	self.view:addChild(self.exit_button.view)
	--------------------------------
end
-------------------------------
-------------------------------
function MyTopList:__init(window_name,texture_name, is_grid, width, height)
	createMyTopList(self, width, height-25)
end
-------------------------------
-------------------------------初始化我的排行信息
function MyTopList:reinit_info(fight, level, lg, achieve, mount, fb, charm, perweekcharm,wing,pet)
	local tempInfo = Lang.topList.mytoplist[15] -- [15]="未上榜"
	local tFightValue = fight  --战力
	local tLevelValue = level  --等级
	local tLgValue = lg   --忍书
	local tAchieveValue = achieve  --成就
	local tMountValue = mount      --坐骑
	local tFbValue = fb            --法宝（式神）
	local tCharmValue = charm      --累积魅力
	local tPerWeekCharmValue = perweekcharm   --本周魅力
	local twingValue = wing
	local tpetValue  = pet
	local text_color = LH_COLOR[2]
	if fight == 0 or not fight then 
		tFightValue = tempInfo
	end
	if level == 0 or not level then
		tLevelValue = tempInfo
	end
	if lg == 0 or not lg then
		tLgValue = tempInfo
	end
	if achieve == 0 or not achieve then
		tAchieveValue = tempInfo
	end
	if mount == 0 or not mount then
		tMountValue = tempInfo
	end
	if fb == 0 or not fb then
		tFbValue = tempInfo
	end
	if charm == 0 or not charm then
		tCharmValue = tempInfo
	end
	if perweekcharm == 0 or not perweekcharm then
		tPerWeekCharmValue = tempInfo
	end
	if wing == 0 or not wing then
		twingValue = tempInfo
	end
	if pet == 0 or not pet then
		tpetValue = tempInfo
	end


	local fight_label = self.one_info:getIndexItem(2)
	fight_label:setText( text_color .. tFightValue )
	local level_label = self.one_info:getIndexItem(4)
	level_label:setText( text_color .. tLevelValue )

	local achieve_label = self.two_info:getIndexItem(2)
	achieve_label:setText( text_color .. tAchieveValue )
	local lg_label = self.two_info:getIndexItem(4)
	lg_label:setText( text_color .. tLgValue )

	local  wing_label  =  self.three_info:getIndexItem(2)
	wing_label:setText(text_color .. twingValue)
	local trump_label = self.three_info:getIndexItem(4)
	trump_label:setText( text_color .. tFbValue )

	local pet_label = self.four_info:getIndexItem(2)
	pet_label:setText( text_color .. tpetValue )
	local mount_label = self.four_info:getIndexItem(4)
	mount_label:setText( text_color .. tMountValue )

	local charm_label = self.five_info:getIndexItem(2)
	charm_label:setText( text_color .. tCharmValue )
	local per_week_charm_label = self.five_info:getIndexItem(4)
	per_week_charm_label:setText( text_color .. tPerWeekCharmValue )
end
