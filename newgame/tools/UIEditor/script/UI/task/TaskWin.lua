-- TaskWin.lua
-- create by hcl on 2013-1-10
-- 任务界面


super_class.TaskWin(NormalStyleWindow)

	
local basePanel = nil;
-- 可接任务信息
local task_table = nil;

local curr_selected_page = 1;

-- ui
local panel_h = 505
local panel_left_w = 315
local panel_right_w = 540
local font_align = 30

-- 任务奖励文字位置
local font_award_y_1 = 160
local font_award_y_2 = 70

function TaskWin:__init( window_name, texture_name)
	-- 空面板
    basePanel = self.view;

    --背景
    local bg = CCBasePanel:panelWithFile( 7, 3, 888, 528, UILH_COMMON.normal_bg_v2, 500, 500); 
    self.view:addChild( bg )

    -- 可接和已接的分页
    self.normal_page = CCBasePanel:panelWithFile(0, 0, 900, 515, "")
    basePanel:addChild(self.normal_page)

    -- 下拉任务列表控件
	self.synthSpinner = nil 

 -- self.btn_name_t = {}  --标签不同文字贴图集合

    -- MUtils:create_zximg( basePanel,
    -- 	UIPIC_GRID_nine_grid_bg3,
    -- 	32, 20, 854, 490+50, 25, 25)
    -- MUtils:create_zximg( basePanel,
    -- 	"",
    -- 	252, 30, 625, 470+50, 15, 15)
    -- MUtils:create_zximg( basePanel,
    -- 	"",
    -- 	42, 30, 205, 470+50, 15, 15);

    self:create_radio_button_group();
    self.raido_btn_group:selectItem(2)
    -- self:create_left_task_panel()
    self:create_right_task_info();
    self:do_tab_button_method(3);
end

function TaskWin:create_radio_button_group()

    local raido_btn_group = CCRadioButtonGroup:buttonGroupWithFile( 20, 605-80, 101*3, 44, nil);
    basePanel:addChild(raido_btn_group);
    self.raido_btn_group =raido_btn_group
    -- 2个按钮 1已接任务2可接任务
    -- local base_tab_path = UIResourcePath.FileLocate.task .. "task_t_";
    --  local selected_tab_path = UIResourcePath.FileLocate.task .. "task_";
    
    for i = 1,3 do
		local function btn_fun(eventType,x,y)
            if eventType == TOUCH_CLICK then
            	self:do_tab_button_method(i);
                return true;
            elseif eventType == TOUCH_BEGAN then
            	
                return true;
            elseif eventType == TOUCH_ENDED then
                return true;
            end
        end
    	if i < 3 then
	        local x = 101 * i;
	        local y = 0;
	        local btn = MUtils:create_radio_button( raido_btn_group,
	        	UILH_COMMON.tab_gray,
	         	UILH_COMMON.tab_light,       	
	        	btn_fun, x, -1, -1, -1, false);

	        local but_name = nil
	        if i == 1 then
	        	but_name = Lang.task[1]
	        elseif i == 2 then
	        	but_name = Lang.task[2]
	        end
	        local tab_name = UILabel:create_lable_2(but_name, 101/2, 10, font_size, ALIGN_CENTER)
	    	btn:addChild( tab_name )
		else
			local btn = MUtils:create_radio_button( raido_btn_group,
	        	UILH_COMMON.tab_gray,
	         	UILH_COMMON.tab_light,       	
	        	btn_fun, 0, -1, -1, -1, false);
			local tab_name = UILabel:create_lable_2(Lang.task[50], 101/2, 10, font_size, ALIGN_CENTER)
	    	btn:addChild( tab_name )
		end
    end 
end

--xiehande  点击按钮切换字体贴图
function  ForgeWin:create_btn_name( btn_name_n,btn_name_s,name_x,name_y,btn_name_size_w,btn_name_size_h )
    -- 按钮名称贴图集合
    local  button_name = {}
    local  button_name_image = CCZXImage:imageWithFile(name_x,name_y,btn_name_size_w,btn_name_size_h,btn_name_n)
    button_name_image:setAnchorPoint(0.5,0.5)
    button_name.view = button_name_image
    --按钮被选中，调用函数切换贴图至btn_name_s
    button_name.change_to_selected = function ( )
        button_name_image:setTexture(btn_name_s)
    end

    --按钮变为未选时  切换贴图到btn_name_n
    button_name.change_to_no_selected = function ( )
        button_name_image:setTexture(btn_name_n)
    end

    return button_name

end

function TaskWin:do_tab_button_method(index)
    --xiehande
    -- for k,v in pairs(self.btn_name_t) do
    --            v.change_to_no_selected()
    --         end
    -- self.btn_name_t[index].change_to_selected()
    curr_selected_page = index;
    if index < 3 then
    	-- 控制分页
		self.normal_page:setIsVisible(true)
		if self.chapter_page then
			self.chapter_page.view:setIsVisible(false)
		end
		self:update_left_task_panel_tjxs(index, self.normal_page);


	else
		self.normal_page:setIsVisible(false)
		if not self.chapter_page then
			self.chapter_page = TaskChapterPage()
			self.chapter_page.view:setPosition(0, 0)
            self.view:addChild(self.chapter_page.view)
		else
			self.chapter_page.view:setIsVisible(true)
		end
		self.chapter_page:update()
	end
end

local update_view_left_task_panel = {};

local zhuxian_task_num = 0;
local zhixian_task_num = 0;
local richang_task_num = 0;

local mubiao_task_info  = {index = 4,title = {posx = 512/2,posy = 15,w = -1, h = -1, font=16},bg = {posx = 346,posy = 475, w = 537, h = 45}}
local miaoshu_task_info = {index = 5,title = {posx = 512/2,posy = 15,w = -1, h = -1, font=16},bg = {posx = 346,posy = 315+30, w = 537, h = 45}}
local jiangli_task_info = {index = 6,title = {posx = 512/2,posy = 15,w = -1, h = -1, font=16},bg = {posx = 346,posy = 165+25, w = 537, h = 45}}

----------------------------------------------------------------------------------------------------

function TaskWin:create_text_btn(parent,pos_x,pos_y,width,height,str,func)

	local text_btn = CCTextButton:textButtonWithFile(63, 12, 50, 30, str, "");
	text_btn:setFontSize(17)
	-----HJH
	local base_panel = BasePanel:create( nil, 0, 0, 200, 40, "" )
-------------------------------------------------------------------
	base_panel.view:registerScriptHandler(func)
	base_panel.view:addChild(text_btn)
	text_btn:setDefaultMessageReturn(false)
	----
	local line = CCZXImage:imageWithFile( 0, 0, 200, 2, UIResourcePath.FileLocate.common .. "jgt_line.png" )      -- 线
    base_panel.view:addChild( line )  

	parent:addChild(base_panel.view)
end

function TaskWin:create_btn_function(index)

	local function text_btn_function(eventType,args,msg_id)
		if eventType == TOUCH_CLICK then
			self:update_right_task_info(task_table[index]);
		end
		return true;
	end
	return text_btn_function;
end

-- index 1 = 主线任务, 2=支线任务, 3=日常任务
function TaskWin:create_title( parent, path, info, title_name )
	--title background
	local title_bg = CCBasePanel:panelWithFile(info.bg.posx, info.bg.posy, info.bg.w, info.bg.h, path, 500, 500)
	parent:addChild( title_bg )
	--title
	local tab_name = UILabel:create_lable_2( LH_COLOR[1] .. title_name , info.title.posx, info.title.posy, info.title.font, ALIGN_CENTER)
    title_bg:addChild( tab_name )

end
-------------------------------------------------------------------
local update_view_right_task_panel = {};

--  任务详细信息
function TaskWin:create_right_task_info()

	-- 背景图
	MUtils:create_zximg( self.normal_page,
    	UILH_COMMON.bottom_bg,
    	panel_left_w+23, 15, panel_right_w, panel_h, 500, 500)

	self:create_title(self.normal_page, UILH_NORMAL.title_bg4, mubiao_task_info, Lang.task[3])
	self:create_title(self.normal_page, UILH_NORMAL.title_bg4, miaoshu_task_info, Lang.task[4])
	self:create_title(self.normal_page, UILH_NORMAL.title_bg4, jiangli_task_info, Lang.task[5])

	-- 标题1
	update_view_right_task_panel[1] = MUtils:create_ccdialogEx(self.normal_page,"",panel_left_w+font_align+10, 465,510,30,10,16);
	update_view_right_task_panel[1]:setAnchorPoint(0, 1)
	update_view_right_task_panel[1]:setMessageCut(true)
	local function do_quest_fun(eventType,args,msgid)
		if ( eventType == TOUCH_CLICK ) then
			--print("self.selected_quest_id = ",self.selected_quest_id)
			AIManager:do_quest( self.selected_quest_id,curr_selected_page );
		end
		return true
	end
	update_view_right_task_panel[1]:registerScriptHandler(do_quest_fun);

	ZLabel:create( self.normal_page, LH_COLOR[7] .. "(点击任务目标描述可以寻路前往)", 580, 400)

	-- 标题2
	update_view_right_task_panel[2] = MUtils:create_ccdialogEx(self.normal_page,"",panel_left_w+font_align+10, 332,510,30,10,16);
	update_view_right_task_panel[2]:setAnchorPoint(0, 1)

	-- 标题3 
	update_view_right_task_panel[3] = MUtils:create_zxfont(self.normal_page,"",panel_left_w+font_align+10, 70,1,16);
	update_view_right_task_panel[4] = MUtils:create_zxfont(self.normal_page,"",panel_left_w+font_align+150+10, 70,1,16);
	update_view_right_task_panel[5] = MUtils:create_zxfont(self.normal_page,"",panel_left_w+font_align+250+10, 70,1,16);

	-- 3个物品框
	for i=1,3 do
		update_view_right_task_panel[11 + i ] =  QuestAwardView(self.normal_page,panel_left_w+font_align + (i-1)*83+10,95 );
		update_view_right_task_panel[11 + i ].view:setIsVisible(false)
	end

	--放弃任务
	local function btn_cancel_fun(eventType,x,y)
        if eventType == TOUCH_CLICK then
        	TaskCC:req_give_up_task( self.selected_quest_id )
        end
        return true
    end
	--xiehande 通用按钮  btn_hong.png ->button3
    self.give_up_btn = MUtils:create_btn(self.normal_page,
        UILH_COMMON.btn4_nor,
        UILH_COMMON.btn4_sel,
        btn_cancel_fun,
        750, 25, -1, -1)
    local btn_txt = UILabel:create_lable_2(LangGameString[1943], 126/2,22, 16, ALIGN_CENTER)
    self.give_up_btn:addChild(btn_txt)
end

function TaskWin:update(type,tab_args)
	if ( type == 1 ) then
		self:update_left_task_panel_tjxs(tab_args[1], self.view);
	elseif type == 3 and self.chapter_page then
		self.chapter_page:update()
	end
end


-- 更新右边的面板
function TaskWin:update_right_task_info(task_id)

	if ( task_id ) then
		self.selected_quest_id = task_id;
		--print("self.selected_quest_id = ",self.selected_quest_id);
		
		local target_str,content_str,tab_awards = TaskModel:get_task_str_by_task_id( task_id ,curr_selected_page);
		update_view_right_task_panel[1]:setText("");
		update_view_right_task_panel[1]:setText( LH_COLOR[2] .. target_str);
		update_view_right_task_panel[2]:setText("");
		update_view_right_task_panel[2]:setText( LH_COLOR[2] .. content_str);

		for i=1,3 do
			if (update_view_right_task_panel[5+i]) then
				update_view_right_task_panel[5+i]:removeFromParentAndCleanup(true);
				update_view_right_task_panel[5+i] = nil;
			end
			update_view_right_task_panel[11+i].view:setIsVisible(false);
			update_view_right_task_panel[2+i]:setText("");
		end

		local item_index = 1;
		local text_index = 1;
		for i=1,#tab_awards do
			local table = tab_awards[i];
			-- 道具
			if ( table.show_type == 0) then
				update_view_right_task_panel[11 + item_index ]:set_icon_and_num( table.icon_path,table.icon_count,table.item_id);
				-- update_view_right_task_panel[11 + item_index]:set_item_name(table.icon_name);
				update_view_right_task_panel[11 + item_index].view:setIsVisible(true);
				item_index = item_index + 1;	
				-- add after tjxs
				update_view_right_task_panel[3]:setPositionY(font_award_y_2)
				update_view_right_task_panel[4]:setPositionY(font_award_y_2)
				update_view_right_task_panel[5]:setPositionY(font_award_y_2)
				-- end tjxs
			elseif ( table.show_type == 1) then
				update_view_right_task_panel[2+text_index]:setText(LH_COLOR[2] .. table.str);
				text_index = text_index + 1;
				-- add after tjxs
				update_view_right_task_panel[3]:setPositionY(font_award_y_1)
				update_view_right_task_panel[4]:setPositionY(font_award_y_1)
				update_view_right_task_panel[5]:setPositionY(font_award_y_1)
				-- end tjxs
			end
		end

		-- 如果是已接任务就显示放弃任务按钮，如果是可接任务就要隐藏掉按钮
		if ( curr_selected_page == 1 ) then
			self.give_up_btn:setIsVisible(true);
		else
			self.give_up_btn:setIsVisible(false);
		end
	else
		update_view_right_task_panel[1]:setText("");
		update_view_right_task_panel[2]:setText("");
		for i=1,3 do
			if (update_view_right_task_panel[5+i]) then
				update_view_right_task_panel[5+i]:removeFromParentAndCleanup(true);
				update_view_right_task_panel[5+i] = nil;
			end
			update_view_right_task_panel[11+i].view:setIsVisible(false);
			update_view_right_task_panel[2+i]:setText("");
		end
		self.give_up_btn:setIsVisible(false);
	end
end

function TaskWin:active( show ) 
	if ( show ) then
		-- 如果已经创建了就要更新下
		if ( update_view_left_task_panel[1] ) then
			self:update(1,{1});
		end
	end
end

-- test by chj
function TaskWin:update_left_task_panel_tjxs( task_index, panel )
    if self.synthSpinner ~= nil then
		self.synthSpinner.view:removeFromParentAndCleanup(true)
		self.synthSpinner = nil
	end
	local item_data = {
        [1] = {
        	Lang.task[6], items = {}
        },
        [2] = {
        	Lang.task[7], items = {}
        },
        [3] = {
        	Lang.task[8], items = {}
        },
    }

    -- 获取任务列表
	local num = 0;
	if ( task_index == 1 ) then
		task_table,num = TaskModel:get_yijie_tasks_list();
	elseif ( task_index == 2 )then
		task_table,num = TaskModel:get_kejie_tasks_list();
	end

	if ( num > 0 ) then
		-- 计算主线支线日常的任务分别有多少个 
		for i=1,#task_table do
			local task = TaskModel:get_info_by_task_id( task_table[i] );
			if ( task.type == 0 ) then
				local temp_t = { [1]=LH_COLOR[2] .. task.name, [2]=task_table[i] }
				table.insert( item_data[1].items, temp_t )
				-- zhuxian_task_num = zhuxian_task_num + 1;
			elseif ( task.type == 1 ) then
				local temp_t = { [1]=LH_COLOR[2] .. task.name, [2]=task_table[i] }
				table.insert( item_data[2].items, temp_t )
				-- zhixian_task_num = zhixian_task_num + 1;
			elseif ( task.type == 3 ) then
				local temp_t = { [1]=LH_COLOR[2] .. task.name, [2]=task_table[i] }
				table.insert( item_data[3].items, temp_t )
				-- richang_task_num = richang_task_num + 1;
			end
		end
	end

    local ui_params = { title_h = 45, title_w = 305, item_h = 45, item_w = 321, title_x = 5 }

    require "UI/task/LHExpandListView"
    self.synthSpinner = LHExpandListView:create( panel, item_data, ui_params, 1, 20, 15, panel_left_w, panel_h, UILH_COMMON.bottom_bg, 500, 500 ) --UILH_COMMON.bg_grid

    -- 主线任务
    local btnAttackStone = CCBasePanel:panelWithFile( ui_params.title_x, 467, ui_params.title_w, ui_params.title_h, UILH_NORMAL.title_bg5, 500, 500)
    self.synthSpinner:addTitle(btnAttackStone, 1 )

    -- 支线任务(P-physical)
    local btnDefendStone_P = CCBasePanel:panelWithFile( ui_params.title_x, 422, ui_params.title_w, ui_params.title_h, UILH_NORMAL.title_bg5, 500, 500)
    self.synthSpinner:addTitle(btnDefendStone_P, 2 )

    -- 日常任务(M-magic)
    local btnDefendSone_M = CCBasePanel:panelWithFile( ui_params.title_x, 377, ui_params.title_w, ui_params.title_h, UILH_NORMAL.title_bg5, 500, 500)
    self.synthSpinner:addTitle(btnDefendSone_M, 3 )        

    local function spinner_nil_func()
    	self:update_right_task_info( nil )
    end
    self.synthSpinner:registerNilFunc_nil( spinner_nil_func )

    local function spinner_title_func( title_index, item_index )
        -- print( "------------spinner_title_func:", title_index, item_index )
    end
    self.synthSpinner:registerScriptFunc_t( spinner_title_func )

    local function spinner_item_func( title_index, item_index, item_value )
        self:update_right_task_info( item_value );
    end
    self.synthSpinner:registerScriptFunc_i( spinner_item_func )

    self.synthSpinner:init_slt()
end

function TaskWin:destroy( )
	if self.chapter_page then
		self.chapter_page:destroy()
	end
	Window.destroy(self)
end