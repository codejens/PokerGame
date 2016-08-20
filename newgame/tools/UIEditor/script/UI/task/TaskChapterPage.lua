-- TaskChapterPage.lua 
-- createed by chj on 2014-1-6
-- 章节主线任务

super_class.TaskChapterPage(  )

-- 控件坐标
local win_w = 900
local win_h = 605
local right_bg_w = 572
-- 右上角的scroll信息
local scroll_info = {x = 5, y = 325, width = right_bg_w-20, height = 140,maxnum = 1}

local award_item = nil	--记录右侧奖励
function TaskChapterPage:__init( )
	require "../data/chapter_award"
	self.view = ZBasePanel.new("", 888, 528).view
	self.chapter_info = {}
	self.scroll_panel = {}	--记录scroll里面的panel
	self.slot_panel = nil   -- 奖励panel
	self.slot_items	= {}	-- 记录奖励信息
	selectIndex = 0 	-- 选中的章节id(显示奖励用)
	self.selectChapter = nil	-- 选中的章节信息
	local panel_bg = CCZXImage:imageWithFile(20, 15, 860, 505, UILH_COMMON.bottom_bg, 500, 500)
	self.view:addChild(panel_bg)

	self.right_panel = self:create_right_panel()
	self.view:addChild(self.right_panel)

	local left_panel = self:create_left_panel()
	self.view:addChild(left_panel)



	-- if TYPE_YIJIE == TYPE_YIJIE then
	-- 	self.synthSpinner:slt_title_func(chapter.cid)
	-- else
	-- 	self.synthSpinner:slt_title_func(1)
	-- end
end

function TaskChapterPage:change_state_by_id( cid )
	if not cid or not self.get_btn then return end
	local state = TaskModel:get_state_by_id(cid)
	print(state, cid)
	-- 点击状态
	LuaEffectManager:stop_view_effect( 418,self.get_btn.view )
	if state == 2 then
		self.get_btn.view:setCurState(CLICK_STATE_UP)
		LuaEffectManager:play_view_effect( 418,60,27,self.get_btn.view,true,999 )
	else
		self.get_btn.view:setCurState(CLICK_STATE_DISABLE)
	end
	-- 按钮文字
	if state == 1 then
		self.get_btn:set_image_texture(UILH_BENEFIT.yilingqu) 
	else
		self.get_btn:set_image_texture(UILH_BENEFIT.lingqujiangli) 
	end
end

function TaskChapterPage:create_left_scroll()
	local zx_task, task_type = TaskModel:get_zhuxian_quest()
	if not zx_task then zx_task = 99999 end
	local task_chapter, tasks = TaskModel:get_chapter_info(zx_task)

	local panel_w = 255
	local e_h = 170
	local panel_height = e_h*#chapter_award
	local base_panel = ZBasePanel:create( nil, nil, 0, 0, panel_w, panel_height )
	for idx, chapter in ipairs (chapter_award) do	
		-- 存储panel
		local p_t = {view = small_panel,}
		local panel_bg = string.format("ui/lh_chapter/bg%d.jpg", idx)
		-- if not panel_bg then break end
		local small_panel = CCBasePanel:panelWithFile(5, panel_height-e_h*idx, panel_w, e_h - 3, UILH_COMMON.bg_07, 500,500)
		base_panel.view:addChild(small_panel)
		local chapter_img = CCZXImage:imageWithFile(5, 5, panel_w - 10, e_h - 15, panel_bg)
		small_panel:addChild(chapter_img)
		local c_title = ZLabel:create(small_panel, '', panel_w/2-30, 45, 18)
		ZLabel:create(small_panel, Lang.task[55], 10, 13, 16)
		local progress = MUtils:create_progress_bar(55, 10, panel_w-65, 18, UILH_NORMAL.progress_bg2, UILH_NORMAL.progress_bar_blue2, 100, {14}, nil, true);
		small_panel:addChild(progress.view)
		local chapter_tasks = TaskModel:get_exist_task( idx )
		progress.set_max_value(#chapter_tasks)
		local cur_idx = 0
		local task_cid = task_chapter and task_chapter.cid or 1
		if task_chapter and idx == task_cid then
			local cur = 1
			for idx, v in ipairs(tasks) do
				if v == zx_task then
					cur = idx
					break
				end
			end
			cur_idx = cur
			local per = math.floor((cur-1)/#tasks * 100)
		elseif zx_task == 99999 or (task_chapter and idx < task_cid) then
			cur_idx = #chapter_tasks
		end
		progress.set_current_value(cur_idx)
		--选中框
		local select_img = CCZXImage:imageWithFile(0, 0, panel_w, e_h - 5, UILH_COMMON.slot_focus, 500, 500)
		small_panel:addChild(select_img)
		if idx ~= 1 then
			select_img:setIsVisible(false)
		end

		local function click_panel_func( eventType)
			if eventType == nil then
				return
			end

			if eventType == TOUCH_CLICK then
				if selectIndex == idx then
					return
				end
				self:clear_select()
				selectIndex = idx
				select_img:setIsVisible(true)
				
				self:create_award_items(chapter.award)
				self.chapter_text:setText(LH_COLOR[2] .. Lang.task[55+idx])
				self.dialog:setText(LH_COLOR[2] .. chapter.desc)
				local icon = string.format("ui/lh_chapter/icon%d.png", idx)
				if icon then
					self.chapter_icon:setTexture(icon)
				end
				self:change_state_by_id(idx)

				local text_img1 = string.format("ui/lh_chapter/text%d1.png", idx)
				local text_img2 = string.format("ui/lh_chapter/text%d2.png", idx)
				local text_img3 = string.format("ui/lh_chapter/text%d3.png", idx)
				self.text1:setTexture(text_img1)
				self.text2:setTexture(text_img2)
				self.text3:setTexture(text_img3)
			end
		end
		--做一个遮罩处理点击事件
		local conten = self.view:getSize()
		local click_panel = CCBasePanel:panelWithFile( 0, panel_height-e_h*idx, panel_w, e_h,nil);
		click_panel:setAnchorPoint(0,0)
		base_panel.view:addChild(click_panel,99)
		click_panel:registerScriptHandler(click_panel_func)
		if idx == task_cid then
			click_panel_func(TOUCH_CLICK)
		end
		p_t.select_img = select_img
		-- 保存创建的scroll
		table.insert(self.scroll_panel, p_t)
	end

	return base_panel
end

-------------------------
-- 创建左边面板
-------------------------
function TaskChapterPage:create_left_panel( )
	local p_w = 275
	local panel = CCBasePanel:panelWithFile( 20, 15, p_w, 505, nil)
	local beg_y = 500
	local int_h = 35

	self.left_scroll = ZScroll:create(panel, nil, 3, 10, p_w-13, 485, 1, TYPE_HORIZONTAL)
	self.left_scroll:setScrollLump(10, 10, 40)
	self.left_scroll:setScrollCreatFunction(bind(TaskChapterPage.create_left_scroll, self))
	self.left_scroll:refresh()
	local arrow_up = CCZXImage:imageWithFile(p_w-10, 487, 10, -1 , UILH_COMMON.scrollbar_up, 500, 500)
	local arrow_down = CCZXImage:imageWithFile(p_w-10, 7, 10, -1, UILH_COMMON.scrollbar_down, 500 , 500)
	panel:addChild(arrow_up)
	panel:addChild(arrow_down)
	return panel
end
-------------------------
-- 创建右边面板
-------------------------
function TaskChapterPage:create_right_panel(  )
	local panel = CCBasePanel:panelWithFile( 298, 15, right_bg_w, 505, nil )
	-- 上面板
	local up_panel = CCBasePanel:panelWithFile(0, 380, -1, -1, UILH_CHAPTER.frame_bg1)

	--下边面板
	local down_panel = CCBasePanel:panelWithFile(0, 10, right_bg_w, 365, UILH_COMMON.bg_08, 500, 500)

	--文字背景
	ZImage:create(down_panel, UILH_CHAPTER.frame_bg2, 40, 230, -1, -1)
	self.text1 = ZImage:create(down_panel, "ui/lh_chapter/text11.png", -40, 320, -1, -1)
	self.text2 = ZImage:create(down_panel, "ui/lh_chapter/text12.png", 50, 280, -1, -1)
	self.text3 = ZImage:create(down_panel, "ui/lh_chapter/text13.png", 130, 240, -1, -1)

	-- 奖励信息
	local t_bg = ZImage:create(down_panel, UILH_NORMAL.title_bg, 365, 320)
	ZLabel:create(t_bg.view, LH_COLOR[2] .. Lang.task[53], 102, 11, 16, 2)
	-- 章节icon
	self.chapter_icon = ZImage:create(down_panel, "ui/lh_chapter/icon1.png", 414, 210, -1, -1)
	local text_bg = ZImage:create(down_panel, UILH_NORMAL.level_bg, 414, 180, 108, 45)
	self.chapter_text = ZLabel:create(text_bg.view, Lang.task[56], 54, 15, 16, 2)
	--奖励容器
	self.slot_panel = CCBasePanel:panelWithFile(380, 80, 180, 90, nil)
	down_panel:addChild(self.slot_panel)

	-- 章节描述
	self.dialog = MUtils:create_ccdialogEx(down_panel, "", 30, 70, 310, 150, 120, 16, 1, ADD_LIST_DIR_UP)
	self.dialog:setLineEmptySpace(5)
	self.dialog:enableGradient(false)
	local function get_award_func()
		TaskModel:req_chapter_award(selectIndex)
	end

	--领取奖励按钮
	self.get_btn = ZImageButton:create(down_panel, UILH_COMMON.btn4_nor, UILH_BENEFIT.lingqujiangli,get_award_func, 414, 15, -1, -1)
	self.get_btn.view:addTexWithFile(CLICK_STATE_DISABLE,UILH_COMMON.btn4_dis)
	self.get_btn.view:setCurState(CLICK_STATE_DISABLE)
	panel:addChild(up_panel)
	panel:addChild(down_panel)

	return panel
end

local awards_img = {
	[1]="nopack/task/zhenqi.png" ,[2] = "nopack/task/exp.png",[3]="nopack/task/guild_jl_1.png", 
	[5] = "icon/money/0.pd", [6] = "icon/money/1.pd",[7] = "icon/money/2.pd",
	[14]="nopack/task/guild_jl_2.png",
}
-- 创建奖励item
function TaskChapterPage:create_gold_exp(parent, bg, x, y)
	local slot_item = MUtils:create_slot_item( parent, bg, x, y, 83, 83, nil);
	slot_item:set_icon_bg_texture( bg, -9, -9, 83, 83 )   -- 背框
	function slot_item:set_icon_and_num(type, arg1, arg2)
		if type == 1 then
			local icon = awards_img[arg2] or ""
			slot_item:set_icon_texture(icon);
			slot_item:set_item_count(arg1)
		else
			slot_item:set_icon_ex(arg2)
			slot_item:set_item_count(arg1);
			slot_item:set_color_frame( arg2, -1, -1, 67, 67);
			local function f1()
				TipsModel:show_shop_tip( 450, 323, arg2,TipsModel.LAYOUT_LEFT );
			end
			slot_item:set_click_event( f1 )
		end
	end
	-- slot_item.view:setScale(1.3)
	return slot_item
end
function TaskChapterPage:create_award_items( awards)
	local beg_x = -80
	if #awards == 1 then
		beg_x = -35
	end
	for i, val in ipairs(awards) do
		self.slot_items[i] = self:create_gold_exp(self.slot_panel, UILH_NORMAL.item_bg2, beg_x + i * 86, 0);
		if ( val.type == 0) then
			self.slot_items[i]:set_icon_and_num( 0, val.count ,val.id);
		else
			self.slot_items[i]:set_icon_and_num( 1, val.count ,val.type);
		end
	end
end
--清除选择框
function TaskChapterPage:clear_select( )
	for i, temp in ipairs(self.scroll_panel) do
		if temp.select_img then
			temp.select_img:setIsVisible(false)
		end
	end
	for i, item in ipairs(self.slot_items) do
		item.view:removeFromParentAndCleanup(true)
	end
	self.slot_items = {}
end

-- ===============================================
-- 更新
-- ===============================================
function TaskChapterPage:update( update_type )
	self:change_state_by_id(selectIndex)
end

function TaskChapterPage:destroy( )
	self.scroll_panel = {}
	self.selectChapter = nil
	award_item = nil
	if self.get_btn then
		self.get_btn.view:removeFromParentAndCleanup(true)
		self.get_btn = nil
	end
	-- self:clear_select()
end