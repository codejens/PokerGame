-- TeamFamPage.lua  
-- created by zyb on 2014-4-10
-- 聚仙令》副本组队 分页  

super_class.TeamFamPage()

-- 副本开启条件
local _fuben_open_level = {45,49,52}
-- 3个副本的id
local fuben_id = {81,82,83}
-- 副本开启等级
local open_lv = {45,49,52}

function TeamFamPage:create(  )
    -- local temp_panel_info = { texture = "", x = 10, y = 12, width = 760, height = 355 }
	return TeamFamPage()
end

function TeamFamPage:__init()
	self.view = CCBasePanel:panelWithFile( 5, 8, 890, 518, UILH_COMMON.normal_bg_v2, 500, 500 )

	local sx = 10--起始x
	local sy = 78--起始y
	local spx = 288--3个副本面板x间距
	-- 底部横条
	ZImage:create(self.view, UILH_NORMAL.title_bg_selected,15,13,858,65, 1,500,500)
	-- “当前拥有：”
	ZLabel:create(self.view, Lang.juxianling[11], 23, 40, 16, ALIGN_LEFT, 1)	-- [11] = "当前拥有：",
	-- 底部令牌的坐标和间距
	local sx2 = 205
	local sy2 = 40
	local spx2 = 200
	-- (玄令) (地令) (天令)
	ZLabel:create(self.view, Lang.juxianling[3], sx2,        sy2, 16, ALIGN_LEFT, 1)
	ZLabel:create(self.view, Lang.juxianling[4], sx2+spx2,   sy2, 16, ALIGN_LEFT, 1)
	ZLabel:create(self.view, Lang.juxianling[5], sx2+spx2*2, sy2, 16, ALIGN_LEFT, 1)
	-- 3令的剩余数量
	self.token_count_txt = {}
	self.token_count_txt[1] = ZLabel:create(self.view, string.format("%s%d","#cffff00",0), sx2+53,        sy2, 16, ALIGN_LEFT, 1)
	self.token_count_txt[2] = ZLabel:create(self.view, string.format("%s%d","#cffff00",0), sx2+53+spx2,   sy2, 16, ALIGN_LEFT, 1)
	self.token_count_txt[3] = ZLabel:create(self.view, string.format("%s%d","#cffff00",0), sx2+53+spx2*2, sy2, 16, ALIGN_LEFT, 1)
	-- 3令的图标
	ZImage:create(self.view, string.format("%s%s",UIResourcePath.FileLocate.lh_juxianling,"token_img1.png"),sx2-70     ,10,63,66, 1)
	ZImage:create(self.view, string.format("%s%s",UIResourcePath.FileLocate.lh_juxianling,"token_img2.png"),sx2-70+spx2  ,10,63,66, 1)
	ZImage:create(self.view, string.format("%s%s",UIResourcePath.FileLocate.lh_juxianling,"token_img3.png"),sx2-70+spx2*2,10,63,66, 1)
	--  副本信息面板，目前有3个
	self.fuben_info_t = {}
	self.fuben_img_table = {"nopack/MiniMap/xssh.jpg","nopack/MiniMap/wxlz.jpg","nopack/MiniMap/htz2.jpg"}
	for i=1,3 do
		self.fuben_info_t[i] = self:creat_fuben_info_panel(self.view, i, sx+(i-1)*spx, sy)
	end

	local function explain_but_fun()
		HelpPanel:show( 3, UILH_NORMAL.title_tips, Lang.juxianling.shuoming ,16)
	end
	local explain_but = ZImageButton:create(self.view,UILH_NORMAL.wenhao,nil,explain_but_fun, 827, 28, -1, -1, 1)
end

-- 创建副本信息的显示面板
function TeamFamPage:creat_fuben_info_panel( parent,index,x,y)
	local t = {}
	t.index = index
	t.container = CCBasePanel:panelWithFile( x, y, 292, 430, UILH_JUXIANLING.subpage_bg, 500, 500 )
	t.container:setPosition(x,y)
	parent:addChild(t.container)
	t.title_bg           = ZImage:create(t.container, UILH_NORMAL.title_bg6,63,362,-1,-1,  100)
	t.title              = ZImage:create(t.container, string.format("%s%s%d%s",UIResourcePath.FileLocate.lh_juxianling,"subtitle",index,".png"),147,402,-1,-1,  100, 500, 500)
	t.title.view:setAnchorPoint(0.5,0.5)
	ZImage:create(t.container, UILH_COMMON.dg_sel_1,11,197,271,180,  1,500,500)
	ZImage:create(t.container, UILH_COMMON.dg_sel_1,11,16,271,180,  1,500,500)
	t.fuben_icon         = ZImage:create(t.container, self.fuben_img_table[index],17,202,259,170,  1, 0, 0)
	t.remain_times_label = ZLabel:create(t.container, Lang.juxianling[13], 20, 167, 16, ALIGN_LEFT, 1) -- [13] = "副本次数：",
	t.award_label        = ZLabel:create(t.container, Lang.juxianling[14], 20,  100, 16, ALIGN_LEFT, 1) -- [14] = "副本奖励：",
	t.remain_times_txt   = ZLabel:create(t.container, "0/0",110, 167, 14, ALIGN_LEFT, 1)
	t.award_icon         = ZImage:create(t.container, string.format("%s%s%d%s",UIResourcePath.FileLocate.lh_juxianling,"token_img",index,".png"),120,73,75,79, 1)
	local function add_time_btn_fun()
		TeamActivityCC:req_add_fuben_times(fuben_id[index])
	end
	local function easy_team_fun()
		local a1,b1 = TeamActivityMode:get_enter_fuben_count( fuben_id[index] )
		-- if a1 >= b1 then --剩余次数不足
		if a1 <= 0 then --剩余次数不足
			GlobalFunc:create_screen_notic("副本剩余次数不足")
		else
			-- 先判断是不是组队了
			if TeamModel:get_team_id() == 0 then
				local function confirm_func()
					TeamWin:show(1);
				end
				NormalDialog:show( Lang.juxianling[9], confirm_func, 1 )	-- [9] = "你还没有组队，是否前往组队页面？"
			else
				local function confirm_func2()
					TeamActivityCC:req_enter_fuben(1,fuben_id[index])
				end

				-- 组队不满5个人时候给个提示
				if (#TeamModel:get_team_table()) < 4 then
					NormalDialog:show( Lang.juxianling[10], confirm_func2, 1 )	-- [10] = "队伍人数未满5人，可能挑战此副本会比较困难，仍然要进入副本吗？",
				else
					confirm_func2();
				end
			end
		end
	end
	-- 未开启挡板的空函数 
	local function do_nothing_fun(eventType)
		return true
	end
	t.add_time_btn       = ZTextButton:create(t.container, Lang.juxianling[15], UILH_COMMON.button8, add_time_btn_fun, 197, 150, 77, 40, 1)
	t.team_btn           = ZTextButton:create(t.container,Lang.juxianling[16], {UILH_COMMON.btn4_nor,UILH_COMMON.btn4_sel}, easy_team_fun, 82, 20, 121, 53, 1)
	-- 未开启时显示的遮挡.[15] = "增加",[16] = "挑战副本",[17] = "%d级开启",
	t.locked_mask		 = CCBasePanel:panelWithFile( 0, 0, 292, 430, UILH_JUXIANLING.subpage_bg, 500, 500 )
	t.locked_img		 = ZImage:create(t.locked_mask, UILH_JUXIANLING.lock, -5,  150,-1,-1, 1)
	t.open_lv_label		 = ZLabel:create(t.locked_mask, string.format(Lang.juxianling[17],open_lv[index]), 292/2, 120, 18, ALIGN_CENTER, 1)
	t.locked_mask:registerScriptHandler(do_nothing_fun)

	t.container:addChild(t.locked_mask,99)

	return t
end

-- 刷新
function TeamFamPage:update(update_type)
	local a1,b1 = TeamActivityMode:get_enter_fuben_count( fuben_id[1] )
	self.fuben_info_t[1].remain_times_txt:setText(string.format("#cff4100%d/%d",a1,b1))
	local a2,b2 = TeamActivityMode:get_enter_fuben_count( fuben_id[2] )
	self.fuben_info_t[2].remain_times_txt:setText(string.format("#cff4100%d/%d",a2,b2))
	local a3,b3 = TeamActivityMode:get_enter_fuben_count( fuben_id[3] )
	self.fuben_info_t[3].remain_times_txt:setText(string.format("#cff4100%d/%d",a3,b3))

	self.token_count_txt[1]:setText(string.format("%s%d","#cffff00",TeamActivityMode:get_tokens_count()[1]))
	self.token_count_txt[2]:setText(string.format("%s%d","#cffff00",TeamActivityMode:get_tokens_count()[2]))
	self.token_count_txt[3]:setText(string.format("%s%d","#cffff00",TeamActivityMode:get_tokens_count()[3]))

	local player_lv = EntityManager:get_player_avatar().level
	if player_lv >= open_lv[1] then 
		self.fuben_info_t[1].locked_mask:setIsVisible(false)
	else
		self.fuben_info_t[1].locked_mask:setIsVisible(true)
	end
	if player_lv >= open_lv[2] then 
		self.fuben_info_t[2].locked_mask:setIsVisible(false)
	else
		self.fuben_info_t[2].locked_mask:setIsVisible(true)
	end
	if player_lv >= open_lv[3] then 
		self.fuben_info_t[3].locked_mask:setIsVisible(false)
	else
		self.fuben_info_t[3].locked_mask:setIsVisible(true)
	end
end
