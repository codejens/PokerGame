-- ZhenYaoTaWin.lua
-- create by tjh 2014-5-21
-- 镇妖塔主窗口

super_class.ZhenYaoTaWin(NormalStyleWindow)

--查看层主按钮控制
-- local _look_floor_owner = false

--当前选中的层按钮索引
local _curr_florr_btn_index = 1

local basepath = "ui/zhenyaota/"

-- 每个大关按钮的位置和缩放比例
local rank_btn_pos =
{
	[1] = {x=194,y=53,scale = 0.6},
	[2] = {x=13,y=100,scale = 0.7},
	[3] = {x=182,y=204,scale = 0.8},
	[4] = {x=4,y=280,scale = 0.9},
	[5] = {x=170,y=365,scale = 1.0},
}

-----------------------------------------对外开放------------------------------------------
-----功能回调函数-----------------

--挑战对象查看回调
-- local function look_info_cb_func( index )
-- 	local floor = (_curr_florr_btn_index-1)*10 +index
-- 	ZhenYaoTaModel:look_info_cb_func( floor,ZhenYaoTaModel.CHALLENGE_TYPE )
-- end

-- 挑战回调
local function challenge_cb_func( index )
	local floor = (_curr_florr_btn_index - 1)*10 +index
	ZhenYaoTaModel:req_enter_fuben( floor )
	UIManager:hide_window( "zhenyaota_win" )
end

--神秘商店回调
local function secret_shop_cb_func(  )
	MysticalShopModel:open_shop_win_by_type( MysticalShopModel.ZYT_SHOP,"zhenyaota_win" )
end

--规则说明回调
local function guizhe_cb_func( str  )
    HelpPanel:show(3,UILH_NORMAL.title_tips,str);
end

--层范围切换回调
local function floor_change_cb_func( index )
	--_curr_florr_btn_index = index
	ZhenYaoTaModel:change_floor_cb_func( index )
end 

--查看层主回调
-- local function look_floor_owner_cb_func( self )
	-- if _look_floor_owner then
	-- 	self.rigth_challenge_page:setIsVisible(true)
	-- 	self.rigth_look_page:setIsVisible(false)
	-- 	self.look_floor_owner_label:setString( '查看层主' )
	-- else
	-- 	self.rigth_challenge_page:setIsVisible(false)
	-- 	self.rigth_look_page:setIsVisible(true)
	-- 	self.look_floor_owner_label:setString( '挑战副本' )
	-- end
	-- _look_floor_owner = not _look_floor_owner
-- end 

---------------------------------
-----------------更新相关-------------------

--更新层主
function ZhenYaoTaWin:update_one_row( index,name,time )
	--print("update_one_row",index,name,time )

	-- 没有显示各层层主的分页了，所以这段也注释掉
	-- local one_row_info = self.row_info[index]
	-- local row_name_lab = one_row_info.name_lab
	-- row_name_lab:setText("#c00c0ff"..name)
	-- local row_time_lab = one_row_info.time_lab
	-- row_time_lab:setText("#c38fe35"..time)
end

-- --更新我的信息
-- function ZhenYaoTaWin:update_my_info( date )
-- 	self:floor_change_btn_state(max_num)
-- end

-- --更新层切换按钮状态 max_num 当前通关最大层
-- function ZhenYaoTaWin:floor_change_btn_state( max_num )
-- 	local btn_num = math.ceil(max_num/10)
-- 	for i=1, 5 do
-- 		if i <= btn_num then
-- 			self.change_floor_btn[i]:setCurState( CLICK_STATE_UP )
-- 		else
-- 			self.change_floor_btn[i]:setCurState( CLICK_STATE_DISABLE )
-- 		end
-- 	end
-- end

--更新当前挑战对象页状态statr_num 起始编号,active_count可激活按钮个数
function ZhenYaoTaWin:update_curr_challenge_page_state( statr_num,active_count,index)
	local is_can_challenge = false
	local head_path = ""
	local curr_num_str = ""
	local curr_num = 1
	for i=1,10 do


		curr_num = statr_num + i
		head_path = ZhenYaoTaConfig:get_head_path( curr_num )
		--string.format("%stx_%d.png",basepath,curr_num)
		self.challenge_panel[i].update_all(head_path,curr_num)
		-- if i<= active_count and curr_num <= 30 then
		if i <= active_count then
			self.challenge_panel[i].setCurState(CLICK_STATE_UP)
		else
			self.challenge_panel[i].setCurState(CLICK_STATE_DISABLE)
		end
	end
	 _curr_florr_btn_index = index

   	-- 刷新选中框状态和位置
   	if index <= self.active_floor then
   		self.select_btn_img:setTexture(UILH_ZHENYAOTA.city_btn_focus)
   	else
		self.select_btn_img:setTexture(UILH_ZHENYAOTA.city_btn_gray_focus)
   	end
	self.select_btn_img:setPosition(rank_btn_pos[index].x,rank_btn_pos[index].y)
	self.select_btn_img:setScale(rank_btn_pos[index].scale)

	-- 更新当前选中的层的序号，切换层组时默认选中第一个
	self:update_curr_select_floor_item(statr_num + 1)
end

function ZhenYaoTaWin:update_my_info(my_floor,active_floor )
	self.active_floor = active_floor
	if my_floor and my_floor > 0 then 
		self.my_floor_lab:setText(Lang.zhenyaota[6]..my_floor..Lang.zhenyaota[3])	-- [3] = "层层主",
	end
	for i=1,5 do
		if i <= active_floor then
			self.change_floor_btn[i]:addTexWithFile(CLICK_STATE_UP,UILH_ZHENYAOTA.city_btn);
			self.change_floor_btn[i]:setCurState(CLICK_STATE_UP)
			-- self.change_floor_btn[i]:setCurState( CLICK_STATE_UP )
			-- self.change_floor_img[i]:setIsVisible(false)
		else
			self.change_floor_btn[i]:addTexWithFile(CLICK_STATE_UP,UILH_ZHENYAOTA.city_btn_gray);
			self.change_floor_btn[i]:setCurState(CLICK_STATE_UP)
			-- self.change_floor_btn[i]:setCurState( CLICK_STATE_DISABLE )
			-- self.change_floor_img[i]:setIsVisible(true)
		end
	end
end

-- model收到数据下发后，win更新当前选中层的数据
function ZhenYaoTaWin:update_current_floor_data()
	local floor_num = (_curr_florr_btn_index-1)*10 + self.curr_select_index;
	-- 刷新说明文字
   	self.floor_guide:setText(ZhenYaoTaConfig:get_boss_gonglue(floor_num))
	self.floor_num_label:setText( Lang.zhenyaota[28]..floor_num..Lang.zhenyaota[29])	-- [28] = "第",	[29] = "关",
   	self.floor_master:setText(Lang.zhenyaota[4]..ZhenYaoTaModel:get_floor_master_by_index( floor_num ))	-- [4] = "层主：",
   	self.floor_time:setText(Lang.zhenyaota[5]..ZhenYaoTaModel:get_floor_time_by_index( floor_num ))	-- [5] = "层主用时：",
end

-- 更新当前选中的层的序号
function ZhenYaoTaWin:update_curr_select_floor_item(floor_num)
	local old_select_index = self.curr_select_index
	self.curr_select_index = floor_num%10
	if self.curr_select_index == 0 then
		self.curr_select_index = 10
	end
	-- print("选中",self.curr_select_index)
	-- 刷新说明文字
   	self.floor_guide:setText(ZhenYaoTaConfig:get_boss_gonglue(floor_num))
	self.floor_num_label:setText( Lang.zhenyaota[28]..floor_num..Lang.zhenyaota[29])	-- [28] = "第",	[29] = "关",
   	self.floor_master:setText(Lang.zhenyaota[4]..ZhenYaoTaModel:get_floor_master_by_index( floor_num ))	-- [4] = "层主：",
   	self.floor_time:setText(Lang.zhenyaota[5]..ZhenYaoTaModel:get_floor_time_by_index( floor_num ))	-- [5] = "层主用时：",

   	-- 刷新奖励道具item数量
   	local num = 100+(floor_num-1)*10
	if floor_num == 50 then
		num = num  + 10
	end
	self.award_item:set_item_count( num )

	-- 刷新选中框
	self.challenge_panel[old_select_index].setSelectedImage(false)
	self.challenge_panel[self.curr_select_index].setSelectedImage(true)
end

---------------------------------------------------------------------------------------

function ZhenYaoTaWin:__init(  )

	self.curr_select_index = 1  -- 当前层中选中的格子，范围是1~10

	--保存切换层按钮
	self.change_floor_btn = {}
	-- self.change_floor_img = {} --上锁的图片
	self.active_floor = 1 -- 记录玩家目前打到的大层数（1~5）
	--保存挑战对象
	self.challenge_panel = {}
	--保存每层层主信息
	-- self.row_info = {}

	-- 创建大背景
	local big_bg = CCBasePanel:panelWithFile(10, 12, 880, 555,UILH_COMMON.normal_bg_v2,500,500);
	self.view:addChild(big_bg)

	-- 创建内层背景
	local big_bg2 = CCBasePanel:panelWithFile(13, 13, 852, 529,UILH_COMMON.bottom_bg,500,500);
	big_bg:addChild(big_bg2)

    --创建左侧
    self:create_left( )
    --创建右侧
    self:create_rigth( )

    -- _look_floor_owner = false

    _curr_florr_btn_index = 1
end

--创建左侧
function ZhenYaoTaWin:create_left( )
	local panel_path = UILH_COMMON.bottom_bg
	local left_panel= CCBasePanel:panelWithFile( 35, 40, 302, 500,panel_path, 500, 500 )
	self.view:addChild(left_panel)

	--镇妖塔图
	local ta_bg= CCBasePanel:panelWithFile( 0, 0, -1, -1,UILH_ZHENYAOTA.left_bg, 500, 500 )
	left_panel:addChild(ta_bg)
	--创建按钮
	self:create_change_floor_btns(left_panel,50,70,100)

	--查看层主
	-- local function btn_cb_func( )
	-- 	look_floor_owner_cb_func(self)
	-- end
 --    self.look_floor_owner_btn = ZButton:create( left_panel, {UILH_COMMON.button8,UILH_COMMON.button8}, btn_cb_func, 45, 20, 95, 40 )
 --    self.look_floor_owner_label = MUtils:create_zxfont(self.look_floor_owner_btn,"查看层主",95/2,14,2,15);

 	-- 创建一个“过关斩将”的美术字
 	MUtils:create_zximg(left_panel,UILH_ZHENYAOTA.subtitle,97, 12,-1,-1)
end

--创建右侧
function ZhenYaoTaWin:create_rigth( )
	self.rigth_challenge_page = self:create_challenge_page()
	self.view:addChild(self.rigth_challenge_page)

	-- self.rigth_look_page = self:create_look_page()
	-- self.view:addChild(self.rigth_look_page)
	-- self.rigth_look_page:setIsVisible(false)
end

--创建挑战页
function ZhenYaoTaWin:create_challenge_page( )
	local panel_path = UILH_COMMON.bottom_bg
	local rigth_challenge_panel= CCBasePanel:panelWithFile( 339, 32, 540, 515,"", 500, 500 )

	--创建右侧的上测
	local rigth_top_panel = self:create_rigth_top( )
	rigth_challenge_panel:addChild(rigth_top_panel)
	--创建右侧的下测
	local left_top_panel = self:create_rigth_down( )
	rigth_challenge_panel:addChild(left_top_panel)

	return 	rigth_challenge_panel
end

--创建查看层主页
-- function ZhenYaoTaWin:create_look_page( )
-- 	local panel_path = UILH_COMMON.bottom_bg
-- 	local rigth_look_panel= CCBasePanel:panelWithFile( 210, 10, 540, 370,panel_path, 500, 500 )

-- 	--层数
-- 	local my_lab = UILabel:create_lable_2( "层数", 35, 337,20,1)
-- 	rigth_look_panel:addChild(my_lab)

-- 	--层主
-- 	local my_lab = UILabel:create_lable_2( "层主", 135+20, 337,20,1)
-- 	rigth_look_panel:addChild(my_lab)

-- 	--用时
-- 	local my_lab = UILabel:create_lable_2( "用时", 235+45, 337,20,1)
-- 	rigth_look_panel:addChild(my_lab)

-- 	--奖励
-- 	local my_lab = UILabel:create_lable_2( "奖励", 335+90, 337,20,1)
-- 	rigth_look_panel:addChild(my_lab)


-- 	local function create_func( panel_index )
--     	local panel = self:create_scroll_row( panel_index )
--     	return panel
--     end

-- 	self.scroll = MUtils:create_one_scroll( 0, 0, 580, 330, 1, "", TYPE_HORIZONTAL, create_func )
-- 	rigth_look_panel:addChild(self.scroll )
-- 	return rigth_look_panel
-- end

--层主scroll创建
-- function ZhenYaoTaWin:create_scroll_row( index )

-- 	local panel_path = UILH_COMMON.bottom_bg
-- 	local panel_bg =  CCBasePanel:panelWithFile( 0, 0, 540, 2310, "", 500, 500 )
-- 	local x = 0
-- 	local y = 5
-- 	for i=1,50 do
-- 		self.row_info[i] = self:create_one_row(x,y,i)
-- 		panel_bg:addChild(self.row_info[i].view)
-- 		y = y + 46
-- 	end


--     return panel_bg
-- end
--创建一行层主信息
-- function ZhenYaoTaWin:create_one_row(x,y,index)
-- 	local one_row = {}
-- 	local panel_path = UILH_COMMON.bottom_bg
-- 	local panel_bg =  CCBasePanel:panelWithFile( x, y, 540, 47, "", 500, 500 )
-- 	one_row.view = panel_bg
--     --层数
-- 	local my_lab = UILabel:create_lable_2( index.."层", 52, 15,16,2)
-- 	panel_bg:addChild(my_lab)

-- 	--层主
-- 	one_row.name_lab = UILabel:create_lable_2( "", 135+40, 15,16,2)
-- 	panel_bg:addChild(one_row.name_lab)

-- 	--用时
-- 	one_row.time_lab = UILabel:create_lable_2( "", 235+70, 15,16,2)
-- 	panel_bg:addChild(one_row.time_lab)

-- 	--奖励
-- 	local num = 100+(index-1)*10
-- 	if index == 50 then
-- 		num = num  + 10
-- 	end
-- 	local my_lab = UILabel:create_lable_2( "#cfff000秘籍经验丹*"..num, 335+40, 15,16,1)
-- 	panel_bg:addChild(my_lab)

--     local split_line = CCZXImage:imageWithFile( 0, 0, 565, 3, UILH_COMMON.split_line);
--     panel_bg:addChild( split_line );

-- 	return one_row
-- end


--创建右侧的上测
function ZhenYaoTaWin:create_rigth_top( )
	local panel_path = UILH_COMMON.bottom_bg
	local rigth_panel_top = CCBasePanel:panelWithFile( 0, 248, 530, 280,'', 500, 500 )
	--创建按钮
	local x = 10
	local y = 10
	for i=1,10 do
		x = 10+ math.ceil((i-1)%5)*102
		y = 10 + math.floor(i/6)*130
		self.challenge_panel[i] = self:create_challenge_object(i,x,y)
		self.challenge_panel[i].setCurState(CLICK_STATE_DISABLE)
		rigth_panel_top:addChild(self.challenge_panel[i].view)

		-- 默认第一个是选中的
		if i == 1 then
			self.challenge_panel[i].setSelectedImage(true)
		end
	end

	-- 创建分割线
    local split_line = CCZXImage:imageWithFile( 3, 3, 525, 3, UILH_COMMON.split_line);
    rigth_panel_top:addChild( split_line );
	return rigth_panel_top
end


--创建右侧的下测
function ZhenYaoTaWin:create_rigth_down( )
	local panel_path = ""
	local rigth_panel_dowm = CCBasePanel:panelWithFile( 0, 0, 535, 250,panel_path, 500, 500 )

	--我的专属层
	self.my_floor_lab = UILabel:create_lable_2( Lang.zhenyaota[6]..Lang.zhenyaota[7], 453, 175,16,2) -- [6] = "我的专属层：",-- [7] = "无",
	rigth_panel_dowm:addChild(self.my_floor_lab)

	-- 左右两侧的分割线
    local split_line_v = CCZXImage:imageWithFile( 378, 3, 3, 245, UILH_COMMON.split_line_v);
    rigth_panel_dowm:addChild( split_line_v );

    -- 攻略标题
    local guide_title_bg = CCZXImage:imageWithFile(5,220,110,28,UILH_NORMAL.bg_red,0,0)
    rigth_panel_dowm:addChild( guide_title_bg );
    MUtils:create_zxfont(guide_title_bg,Lang.zhenyaota[27],110/2,7,2,16);	-- [27] = "BOSS攻略",

	-- 攻略说明
    self.floor_guide = CCDialogEx:dialogWithFile( 10, 125, 354, 95, 100, nil, TYPE_VERTICAL, ADD_LIST_DIR_UP)
    self.floor_guide:setText(ZhenYaoTaConfig:get_boss_gonglue(1))
    rigth_panel_dowm:addChild( self.floor_guide )

    -- 上下两侧的分割线
    local split_line = CCZXImage:imageWithFile( 3, 113, 370, 3, UILH_COMMON.split_line);
    rigth_panel_dowm:addChild( split_line );

    -- 显示第几关
    self.floor_num_label = UILabel:create_lable_2( Lang.zhenyaota[28].."1"..Lang.zhenyaota[29], 8, 82,16,1) -- 	[28] = "第",	[29] = "关",
	rigth_panel_dowm:addChild(self.floor_num_label)

    -- 层主名字
    self.floor_master = UILabel:create_lable_2( "", 8, 52,16,1)
    self.floor_master:setText(Lang.zhenyaota[4]..ZhenYaoTaModel:get_floor_master_by_index( 1 ))	-- [4] = "层主：",
	rigth_panel_dowm:addChild(self.floor_master)

	-- 层主用时
	self.floor_time = UILabel:create_lable_2( "", 8, 22,16,1)
    self.floor_time:setText(Lang.zhenyaota[5]..ZhenYaoTaModel:get_floor_time_by_index( 1 ))	-- [5] = "层主用时：",
	rigth_panel_dowm:addChild(self.floor_time)

	-- 奖励说明
	local my_lab = UILabel:create_lable_2( Lang.zhenyaota[30], 180, 82,16,1)	-- [8] = "奖励：",
	rigth_panel_dowm:addChild(my_lab)

	-- 奖励展示的items
	local item_id = 29660
    self.award_item = MUtils:create_slot_item2(rigth_panel_dowm,UILH_COMMON.slot_bg,280,25,68,68,item_id,nil,7.5);
    self.award_item:set_color_frame(item_id,0,0,68,68)
   	local num = 100+(1-1)*10
	if 1 == 50 then
		num = num  + 10
	end
	self.award_item:set_item_count( num )

	--神秘商店按钮
    local btn1 = ZButton:create( rigth_panel_dowm, {UILH_COMMON.lh_button_4_r,UILH_COMMON.lh_button_4_r}, secret_shop_cb_func, 395,100, 121, 53 )
    MUtils:create_zxfont(btn1,Lang.zhenyaota[9],121/2,21,2,16);	-- [9] = "神秘商店",

    --规则说明
    local str = Lang.zhenyaota.helpText
    local function cb_func(  )
    	guizhe_cb_func(str)
    end
    local btn2 = ZButton:create( rigth_panel_dowm, {UILH_COMMON.btn4_nor,UILH_COMMON.btn4_sel}, cb_func, 395, 40, 121, 53 )
    MUtils:create_zxfont(btn2,Lang.zhenyaota[10],122/2,21,2,16);	-- [10] = "规则说明",

	return rigth_panel_dowm
end


--创建层切换按钮
function ZhenYaoTaWin:create_change_floor_btns( panel,start_x,start_y,distance)
	local x = start_x
	local y = start_y
	--选中底图
	local select_btn_path = UILH_ZHENYAOTA.city_btn_focus
	self.select_btn_img = MUtils:create_zximg(panel,select_btn_path,rank_btn_pos[1].x,rank_btn_pos[1].y,-1,-1)
	self.select_btn_img:setScale(rank_btn_pos[1].scale)

	--按钮文字
	local btn_text = "1-10层"
	local start_floor = 1 --起始层
	local end_floor = 1 --终点层
	for i=1,5 do
	
		local function btn_cb_func(eventType,arg,msgid,selfitem)
			if eventType == nil or arg == nil or msgid == nil or selfitem == nil then
				return
			end
	        if eventType == TOUCH_CLICK then
	           	floor_change_cb_func(i)
	         end
			return true
		end 
		-- 默认情况，在还没拿到数据刷新时候，先将第一大层设置为亮色，其他为暗色
		local btn_path_n = UILH_ZHENYAOTA.city_btn
		local btn_path_s = UILH_ZHENYAOTA.city_btn
		if i ~= 1 then
			btn_path_n = UILH_ZHENYAOTA.city_btn_gray
			btn_path_s = UILH_ZHENYAOTA.city_btn_gray
	    end
	    self.change_floor_btn[i] =  MUtils:create_btn( panel,btn_path_n,btn_path_s,btn_cb_func,rank_btn_pos[i].x, rank_btn_pos[i].y, -1, -1)
		self.change_floor_btn[i]:setScale(rank_btn_pos[i].scale)

		-- 创建层数说明的label
		-- start_floor = (i-1)*10 + 1
		-- end_floor = start_floor + 9
		-- btn_text = string.format(Lang.zhenyaota[11],start_floor,end_floor)	-- [11] = "#cfdde9d%d—%d层",
		-- local btn_label = UILabel:create_lable_2( btn_text, 44,10, 14, 2 )
		-- self.change_floor_btn[i]:addChild(btn_label)
		-- 创建层数说明的img
		MUtils:create_zximg(panel,"ui/lh_zhenyaota/rank"..i..".png",rank_btn_pos[i].x+i*2, rank_btn_pos[i].y+10,-1,-1)

		-- self.change_floor_img[i] = MUtils:create_zximg(self.change_floor_btn[i] ,basepath.."btn_bg_s.png",-3,5,-1,-1)
		
		
		y = y + distance

	end
end

--创建一个挑战对象
function ZhenYaoTaWin:create_challenge_object(index,x,y)
	local one_challenge_object = {}

	local panel_path = UILH_COMMON.bottom_bg
	local bg_panel = CCBasePanel:panelWithFile( x, y, 105, 120,"", 500, 500 )
	one_challenge_object.view = bg_panel


	local heand_panel = CCBasePanel:panelWithFile( 7, 35, 90, 90,UILH_NORMAL.skill_bg1, 500, 500 )
	bg_panel:addChild(heand_panel)

	local heand_bg_panel = CCBasePanel:panelWithFile( 12, 40, 80, 80,"", 500, 500 )
	bg_panel:addChild(heand_bg_panel)
		-- 点击头像 改为查看该层资料
    local function enter_fuben_func(eventType,x,y)
        if eventType == TOUCH_CLICK then
           	-- look_info_cb_func(index)
           	-- 拿到当前item对应的层数序号，刷新数据
           	local floor_num = (_curr_florr_btn_index-1)*10 +index
           	self:update_curr_select_floor_item(floor_num)
            return false 
        end
        return true
    end
    heand_bg_panel:registerScriptHandler( enter_fuben_func ) 
	--MUtils:create_sprite(bg_panel,basepath.."head_bg.png",50,50);
    local head_path ="ui/lh_zhenyaota/tx_1.png";
    -- 当层怪物头像
    local head_img = MUtils:create_zximg(heand_panel,head_path,10,9,72,72,0,0);
	-- 创建选中框
	local floor_selected_img = CCZXImage:imageWithFile(6,6,80,80,UILH_ZHENYAOTA.floor_focus,0,0)
	floor_selected_img:setIsVisible(false)
	heand_panel:addChild(floor_selected_img)
    -- 层数的序号和序号背景
    local num_label_bg = CCZXImage:imageWithFile(-5,53,37,37,UILH_MAIN.remain_bg,0,0)
    heand_panel:addChild(num_label_bg)
    local num_label = UILabel:create_lable_2( "0", 18, 14, 14, 2 )
    num_label_bg:addChild(num_label)

    --挑战按钮
    local function btn_cb_func(eventType,arg,msgid,selfitem)
		if eventType == nil or arg == nil or msgid == nil or selfitem == nil then
			return
		end
        if eventType == TOUCH_CLICK then
           	challenge_cb_func( index )
         end
    	return true
    end 
    local btn =  MUtils:create_btn( bg_panel,UILH_COMMON.button4,UILH_COMMON.button4,btn_cb_func,15, 0, 77,40)
    btn:addTexWithFile(CLICK_STATE_DISABLE,UILH_COMMON.button4_dis);

    local btn_label = UILabel:create_lable_2( Lang.zhenyaota[12], 77/2, 13, 16, 2 )	-- [12] = "挑 战",
    btn:addChild(btn_label)
    one_challenge_object.update_all = function( head_path,num)
    	head_img:setTexture(head_path)
    	num_label:setText(num)
	end
    one_challenge_object.setCurState = function( currState )
    		head_img:setCurState(currState)
    		btn:setCurState(currState)
    		-- heand_bg_panel:setCurState(currState)
    		if currState == CLICK_STATE_DISABLE then
    			btn_label:setText("#ca7a7a7"..Lang.zhenyaota[12])	-- [12] = "挑 战",
    			floor_selected_img:setTexture(UILH_ZHENYAOTA.floor_focus_gray)
    		else
    			btn_label:setText("#cffffff"..Lang.zhenyaota[12])	-- [12] = "挑 战",
    			floor_selected_img:setTexture(UILH_ZHENYAOTA.floor_focus)
    		end
	end
	one_challenge_object.setSelectedImage = function( is_selected )
		if is_selected == true then
			floor_selected_img:setIsVisible(true)
		else
			floor_selected_img:setIsVisible(false)
		end
	end
	
   return one_challenge_object
end

