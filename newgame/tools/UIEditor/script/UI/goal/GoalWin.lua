--------HJH
--------2013-10-21
--------rewrite GoalWin
super_class.GoalWin(Window)
-------------------------------------
local _self_panel = nil
-------------------------------------
local function update_award_notic_fun(self)
    local temp_page_select = GoalModel:get_cur_page_select()
    local temp_award_select = GoalModel:get_cur_award_select()
    local achieve_group = GlobalConfig:get_achieve_group( 6 + temp_page_select )
    local curid = achieve_group[ temp_award_select ]
    local std_achieve = AchieveConfig:get_achieve( curid )
    self.right_dialog.view:setText( std_achieve.desc )
end
-------------------------------------
local function update_scroll_fun(self)
    local temp_page_select = GoalModel:get_cur_page_select()
    --local achieve_group = GlobalConfig:get_achieve_group( 6 + temp_page_select )
    --self.left_scroll:setMaxNum( 1 ) 
    self.left_scroll.view:reinitScroll()
    self.left_scroll:refresh()
end
-------------------------------------
local function update_award_fun(self)	
	local temp_page_select = GoalModel:get_cur_page_select()
	local temp_award_select = GoalModel:get_cur_award_select()
    print("update_award_fun temp_award_select", temp_award_select)
	local achieve_group = GlobalConfig:get_achieve_group( 6 + temp_page_select )
	local curid = achieve_group[ temp_award_select ]
    local temp_award_index = GlobalConfig:get_begin_goal_target_index() + temp_page_select
	local std_achieve = AchieveConfig:get_achieve( temp_award_index )
    print("update_award_fun curid,temp_award_index", curid, temp_award_index)
	local achieve = AchieveModel:getUserAchieve( curid )
	-------------------------------------
	for i , award in ipairs( std_achieve.awards ) do
		--print("update_award_fun type,id", award.type, award.id)
		if award.type == 0 then
			self.award_slot[i]:set_icon_ex( award.id )
			self.award_slot[i]:set_item_count( award.count )
            local temp_pos_x = self.award_slot[i]._count_image.view:getPositionX()
            local temp_pos_y = self.award_slot[i]._count_image.view:getPositionY()
            --print("temp_pos", temp_pos, temp_pos[0], temp_pos[1])
            self.award_slot[i]._count_image.view:setPosition( CCPoint( temp_pos_x + 5, temp_pos_y ) )
			self.award_slot[i]:set_gem_level( award.id )
			self.award_slot[i]:set_color_frame( award.id, -5, -5, 48, 47 )
		elseif award.type == 5 then
			self.award_slot[i]:set_icon_texture( "icon/money/0.pd" )
			self.award_slot[i]:set_item_count( 0 )
			self.award_slot[i]:set_gem_level( 0 )
			self.award_slot[i]:set_color_frame( 0 )
		elseif award.type == 7 then
			self.award_slot[i]:set_icon_texture( "icon/money/2.pd" )
			self.award_slot[i]:set_item_count( 0 )
			self.award_slot[i]:set_gem_level( 0 )
			self.award_slot[i]:set_color_frame( 0 )
		end
	end
	-------------------------------------
	for i = #std_achieve.awards + 1 , #self.award_slot do
		self.award_slot[i]:set_icon_texture( "" )
		self.award_slot[i]:set_item_count( 0 )
		self.award_slot[i]:set_gem_level( 0 )
		self.award_slot[i]:set_color_frame( 0 )
	end
	-------------------------------------
	self.right_dialog.view:setText( std_achieve.desc )
	-------------------------------------
	-- if achieve.hasGetAwards > 0 then
	-- 	self.get_award_btn.view:setCurState( CLICK_STATE_DISABLE )
	-- elseif achieve.hasDone > 0 then
	-- 	self.get_award_btn.view:setCurState( CLICK_STATE_UP )
	-- else
	-- 	self.get_award_btn.view:setCurState( CLICK_STATE_DISABLE )
	-- end
    local cur_page_award_info = GoalModel:check_cur_page_award_state()
    if cur_page_award_info.get_award == true then
        --print('2')
        self.get_award_btn.image.view:setTexture( UIResourcePath.FileLocate.normal .. "text_4.png" )
        self.get_award_btn.view:setCurState( CLICK_STATE_DISABLE )
    elseif cur_page_award_info.finish == true then
        --print("1")
        self.get_award_btn.image.view:setTexture( UIResourcePath.FileLocate.normal .. "get_award.png" )
        self.get_award_btn.view:setCurState( CLICK_STATE_UP )
    else
        --print("3")
        self.get_award_btn.image.view:setTexture( UIResourcePath.FileLocate.normal .. "get_award.png" )
        self.get_award_btn.view:setCurState( CLICK_STATE_DISABLE )
    end
end
-------------------------------------
local function update_process_fun(self)
    local cur_page_select = GoalModel:get_cur_page_select()
    local achieve_group = GlobalConfig:get_achieve_group( 6 + cur_page_select )
    local hole_num = #achieve_group
    local finish_num = 0
    for i = 1, hole_num do
        local achieveId = achieve_group[ i ]
        local achieve = AchieveModel:getUserAchieve( achieveId )
        if achieve.hasGetAwards > 0 then
            finish_num = finish_num + 1
        elseif achieve.hasDone > 0 then
            finish_num = finish_num + 1
        end
    end
    --print("finish_num, hole_num", finish_num, hole_num)
    self.chapter_progress.view:setText( string.format( "(%d/%d)", finish_num, hole_num ) )
end
-------------------------------------
local function left_scroll_create_fun( self, index )
    local cur_page_select = GoalModel:get_cur_page_select()
    local achieve_group = GlobalConfig:get_achieve_group( 6 + cur_page_select )
    local len = #achieve_group
    --print("left_scroll_create_fun len", len)
    local temp_item_info = {}
    local sum_height = 0
    -------------------------------------
    for i = 1, len do
    	-------------------------------------
	    local achieveId = achieve_group[ i ]
	    local std_achieve = AchieveConfig:get_achieve( achieveId )
	    local achieve = AchieveModel:getUserAchieve( achieveId )
	    local str
	    local ttype 
	    ------------------ 
	    --print("achieve.hasGetAwards,achieve.hasDone",achieve.hasGetAwards,achieve.hasDone)
	    if achieve.hasGetAwards > 0 then
	        str = "#c00c0ff·" .. std_achieve.name .. LangGameString[1109] -- [1109]="(已完成)"
            --str = "#c00c0ff·" .. std_achieve.name .. LangGameString[1108] -- [1108]="(已获取)"
	        ttype = 0
	    elseif achieve.hasDone > 0 then
	        str = "#c38ff33·" .. std_achieve.name .. LangGameString[1109] -- [1109]="(已完成)"
	        ttype = 1
	    else 
	        str = "#cff66cc·" .. std_achieve.name .. LangGameString[1110] -- [1110]="(未完成)"
	        ttype = 2
	    end
	    -----按下任务后的底色
	    local button = ZButton:create( nil, { UIResourcePath.FileLocate.normal .. "empyt_tex.png", UIResourcePath.FileLocate.common .. "tishi_test_bg.png" }, nil, 0, 0, 353, 213 / 6, nil, 600, 600 )
	    local button_size = button:getSize()
	    local tar_img = ZImage:create( nil, UIResourcePath.FileLocate.achieveAndGoal .. "small_icon.png", 0, 0, -1, -1 )
	    local tar_img_size = tar_img:getSize()
	    if ttype == 2 then
	    	tar_img.view:setIsVisible( false )
	    end
	    tar_img:setPosition( 7, ( button_size.height - tar_img_size.height ) / 2 )
	    local label = ZLabel:create( nil, str, 40, 2, 15 )
	    local label_size = label:getSize()
	    label:setPosition( 40, ( button_size.height - label_size.height ) / 2 )
	    local line = ZImage:create( nil, UIResourcePath.FileLocate.common .. "fenge_bg.png", 0, 0, 363, 2 )
	    local line_size = line:getSize()
	    table.insert( temp_item_info, button )
	    local function temp_btn_function()
	    	local temp_index = i
	    	GoalModel:set_cur_award_select(temp_index)
            update_award_notic_fun(_self_panel)
	    	--update_award_fun(_self_panel)
	    end
	    button:setTouchClickFun(temp_btn_function)
	    button:addChild( label )
	    button:addChild( line )
	    button:addChild( tar_img )
	    sum_height = sum_height + button_size.height
	end
	-------------------------------------
	--print("sum_height", sum_height)
	local radio_btn = ZRadioButtonGroup:create( nil, 0, 0, 353, sum_height, 1 )
	for i = 1, #temp_item_info do
		radio_btn:addItem( temp_item_info[i] , 0, 1 )
	end
	return radio_btn
end
-------------------------------------
local function create_top_panel( self, x, y, width, height )
    local base_panel = ZBasePanel:create( nil, nil, x, y, width, height )
    local bg = ZImage:create( nil, UIResourcePath.FileLocate.achieveAndGoal .. "bg_top.jpg", 0, 0, -1, -1 )
    base_panel:addChild(bg)
    --self:addChild( base_panel.view )
    local chapter_info =
    { 
        btn_info = { UIResourcePath.FileLocate.achieveAndGoal .. "btn_normal.png", UIResourcePath.FileLocate.achieveAndGoal .. "btn_select.png" },
        --title_info =  UIResourcePath.FileLocate.achieveAndGoal .. "chapter_%d.png",
        text_info = UIResourcePath.FileLocate.achieveAndGoal .. "text_info_%d.png",
        level_info = { LangGameString[1113], LangGameString[1114], LangGameString[1115], LangGameString[1116], LangGameString[1117] }, -- [1113]="(1-30)级" -- [1114]="(30-40)级" -- [1115]="(40-50)级" -- [1116]="(50-60)级" -- [1117]="(60-70)级"
    }
    -------------------------------------
    local chapter_sprite = {}
    for i = 1, #chapter_info.level_info do
        chapter_sprite[i] = ZButton:create( nil, chapter_info.btn_info, nil, 0, 0, -1, -1 )
        -------------------------------------
        local function temp_btn_fun()
            local temp_index = i
            local temp_cur_select = GoalModel:get_cur_page_select()
            if GoalModel:check_level(temp_index) == true then
                GoalModel:set_cur_page_select(temp_index)
               	if temp_cur_select ~= temp_index then
                    GoalModel:set_cur_award_select(1)
                    _self_panel:update_function(GoalModel.UpdateType.all)
                end
            else
                GlobalFunc:create_screen_notic(Lang.goal_info.notic_info)
                _self_panel.radio_btn:selectItem(temp_cur_select - 1)
            end
        end
        chapter_sprite[i]:setTouchClickFun(temp_btn_fun)
        local chapter_sprite_size = chapter_sprite[i]:getSize()
        -------------------------------------
        --local temp_title = ZImage:create( nil, string.format( chapter_info.title_info, i ), 0, 0, -1, -1 )
        --chapter_sprite[i]:addChild(temp_title)
        --local temp_title_size = temp_title:getSize()
        --temp_title:setPosition( 0, chapter_sprite_size.height - temp_title_size.height )
        -------------------------------------
        local temp_text = ZImage:create( nil, string.format( chapter_info.text_info, i ), 0, 0, -1, -1 )
        chapter_sprite[i]:addChild(temp_text)
        local temp_text_size = temp_text:getSize()
        temp_text:setPosition( ( chapter_sprite_size.width - temp_text_size.width ) / 2, ( chapter_sprite_size.height - temp_text_size.height ) / 2 )
        -------------------------------------
        local temp_level = ZLabel:create( nil, chapter_info.level_info[i], 0, 0 , 12)
        chapter_sprite[i]:addChild(temp_level)
        local temp_level_size = temp_level:getSize()
        temp_level:setPosition( ( chapter_sprite_size.width - temp_level_size.width ) / 2, -11 )       
    end
    -------------------------------------
    local radio_btn = ZRadioButtonGroup:create( nil, 30, -21, width, height )
    base_panel:addChild( radio_btn )
    self.radio_btn = radio_btn
    for i = 1, #chapter_sprite do
        radio_btn:addItem( chapter_sprite[i], 48 )
    end
    -------------------------------------
    self:addChild( base_panel.view )
end
--------------左下角区域
local function create_left_panel(self, x, y, width, height)
    local left_panel = ZBasePanel:create( nil, UIPIC_GRID_nine_grid_bg3, x, y, width, height, 600, 600 )
    --------需要完成目标
    local target_img = ZImageImage:create( nil, UIResourcePath.FileLocate.achieveAndGoal .. "need_target.png",UIResourcePath.FileLocate.common.."quan_bg.png", 2, height - 30, 366, -1 ,500,500)
    left_panel:addChild( target_img )
    local target_img_size = target_img:getSize()
    ---------进度
    self.chapter_progress = ZLabel:create( nil, "(0/0)", target_img_size.width - 120 , height - 24 )
    left_panel:addChild( self.chapter_progress )
    -------------------------------------
    self.left_scroll = ZScroll:create( nil, nil, 0, 5, width, 213, 1, TYPE_HORIZONTAL )
    left_panel:addChild( self.left_scroll )
    self.left_scroll:setScrollCreatFunction(left_scroll_create_fun)
    self.left_scroll:setScrollLump( 10, 0, 100 )
    -------------------------------------
    self:addChild( left_panel.view )
end
--------------右下角区域
local function create_right_panel( self, x, y, width, height )
    local right_panel = ZBasePanel:create( nil, UIPIC_GRID_nine_grid_bg3, x, y, width, height, 600, 600 )
    -------------------------------------
    local notic_img = ZImageImage:create( nil, UIResourcePath.FileLocate.achieveAndGoal .. "notic.png",UIResourcePath.FileLocate.common.."bluecmae_bg.png", 114, height - 18, 146, -1 ,500 ,500)
    right_panel:addChild( notic_img )
    -------------------------------------
    self.right_dialog = ZDialog:create( nil, nil, 26, height - 20, 340, 50 )
    self.right_dialog.view:setAnchorPoint( 0, 1 )
    right_panel:addChild( self.right_dialog )

    ---分割线
    local fenge = ZImage:create(right_panel, UIResourcePath.FileLocate.common.."fenge_bg.png",2,height - 66 ,376 ,-1)
    -------------------------------------
    local chapter_award_img = ZImageImage:create( nil, UIResourcePath.FileLocate.achieveAndGoal .. "chapter_award.png" ,UIResourcePath.FileLocate.common.."bluecmae_bg.png", 114, height - 80, 146, -1)
    right_panel:addChild( chapter_award_img )
    -------------------------------------
    local right_slot_begin_x = 45
    local right_slot_cur_x = right_slot_begin_x
    local right_slot_begin_y = height - 133
    local right_slot_gap = 60
    local right_slot_size = 38
    self.award_slot = {}
    for i = 1, 10 do
        self.award_slot[i] = SlotItem( right_slot_size, right_slot_size )
        self.award_slot[i]:set_icon_bg_texture( UIPIC_ITEMSLOT, -7, -7, 52, 52 )
        self.award_slot[i]:setPosition( right_slot_cur_x, right_slot_begin_y )
        right_slot_cur_x = right_slot_cur_x + right_slot_gap
        right_panel:addChild( self.award_slot[i] )
        if i % 5 == 0 then
            right_slot_begin_y = right_slot_begin_y - right_slot_gap
            right_slot_cur_x = right_slot_begin_x
        end
        local function slot_fun(arg)
        	local temp_index = i
        	local click_pos = Utils:Split(arg, ":")
			local world_pos = self.award_slot[i].view:getParent():convertToWorldSpace( CCPointMake( tonumber(click_pos[1]),tonumber(click_pos[2]) ) )
        	GoalModel:slot_btn_fun(temp_index, world_pos)
        end
       	self.award_slot[i]:set_click_event( slot_fun )
    end
    -------------------------------------
    self.get_award_btn = ZImageButton:create( nil, UIResourcePath.FileLocate.common .. "tishi_button.png",
                                            UIResourcePath.FileLocate.normal .. "get_award.png", nil, ( width - 110 ) / 2, 4, 110, 40 , nil, 600, 600 )
    self.get_award_btn:setTouchClickFun( GoalModel.get_btn_fun )
    right_panel:addChild( self.get_award_btn )
    -------------------------------------
    self:addChild( right_panel.view )
end
-------------------------------------
function GoalWin:__init(window_name, window_info)
    ----------------------------------------
    -- local title = ZImageImage:create( nil, UIResourcePath.FileLocate.qqvip .. "title.png", UIResourcePath.FileLocate.common .. "win_title1.png" , 0, 0, -1, -1)
    -- title:setGapSize( -10, 3)
    -- self:addChild( title.view )
    -- local title_size = title.view:getSize()
    -- title:setPosition( (window_info.width - title_size.width) / 2, window_info.height - title_size.height + 10 )
    ---3个区域
    create_top_panel( self, 10, window_info.height - 180, 759, 136 )
    create_right_panel( self, 368 + 22, window_info.height - 430, 380, 246 )
    create_left_panel( self, 10, window_info.height - 430, 372, 246 )
    ----------------------------------------
    -- local exit = ZButton:create( nil, { UIResourcePath.FileLocate.common .. "close_btn_n.png", UIResourcePath.FileLocate.common .. "close_btn_s.png"}, nil, 0, 0, -1, -1 )
    -- self:addChild( exit.view )
    -- local exit_size = exit:getSize()
    -- exit:setPosition( width - exit_size.width, height - exit_size.height )
    -- local function exit_btn_fun()
    --     UIManager:hide_window("goal_win")
    -- end
    -- exit:setTouchClickFun(exit_btn_fun)  
    _self_panel = self
end
-------------------------------------
-------------------------------------
function GoalWin:update_function(index)
    if index == GoalModel.UpdateType.all then
		update_scroll_fun(self)
		update_award_fun(self)
        update_award_notic_fun(self)
        update_process_fun(self)
    elseif index == GoalModel.UpdateType.scroll then
    	update_scroll_fun(self)
    elseif index == GoalModel.UpdateType.process then
        update_process_fun(self)
    elseif index == GoalModel.UpdateType.reward_item then
    	update_award_fun(self)
    end
end
-------------------------------------
-------------------------------------
function GoalWin:active(show)
	if show == true then
		if GoalModel:get_reinit() == true then
			GoalModel:reinit_panel_info()
			self:update_function( GoalModel.UpdateType.all )
		end	
	end
end
