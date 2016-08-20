-- 一键雷达征友界面
super_class.OneKeyAddWin(NormalStyleWindow)

local max_num 		= 36 --总的位置index
local delay_time	= 3.5 --雷达转一圈的时间
local _refWidth =  UIScreenPos.relativeWidth
local _refHeight = UIScreenPos.relativeHeight

--关闭按钮y坐标
local close_y = _refHeight(0.85)
function OneKeyAddWin:active( show )
	if show == true then

	else

	end
end

function OneKeyAddWin:create_entity_slot(x, y, entity_info, avatar_num)
	--实体面板
	local ent_panel = ZBasePanel:create( self.view, "", x, y, 74, 74);
	local head_bg = ZCCSprite:create(ent_panel.view,UILH_RADAR.light_bg,37,37)
	head_bg.view:setScale(80/74)
	local head_path = UIResourcePath.FileLocate.lh_normal .. "head/head"..entity_info.job..entity_info.sex..".png"
	-- 头像
	-- local ent_head = ZImage:create(ent_panel, head_path, 6, 6, 53, 53)
	local ent_head = ZCCSprite:create(ent_panel,head_path,37, 37)
	ent_head.view:setScale(70/74)
	-- 名字
	local ent_name = ZLabel:create(ent_panel, entity_info.name, 37, 79, 16, 2)

	head_bg.view:setOpacity(0)
	ent_head.view:setOpacity(0)

	local one_delay = delay_time/avatar_num
	local fadeTo = CCFadeTo:actionWithDuration(0.3, 255)
	local fadeTo2 = CCFadeTo:actionWithDuration(0.3, 255)
	-- ent_panel.view:stopAllActions()
	-- ent_head.view:stopAllActions()
	head_bg.view:runAction(fadeTo)
	ent_head.view:runAction(fadeTo2)
	-- ent_name.view:runAction(fadeOut)
	return ent_panel
end

function OneKeyAddWin:__init( window_name, texture_name, grid, width, height, title_text )

	local window_size = self.view:getSize()
	local panel_bg = CCBasePanel:panelWithFile(0, 0, window_size.width, window_size.height, UILH_RADAR.black)
	panel_bg:setOpacity(200)
	self.view = panel_bg
	-- 搜索中的提示
	self.tips_lab = ZImage:create(self.view, UILH_RADAR.tips_text, width/2, close_y, -1, -1)
	self.tips_lab.view:setAnchorPoint(0.5, 0)
	self.tips_lab.view:setIsVisible(false)
	local frame = ZImage:create(self.view, "nopack/BigImage/radar_bg.png", width/2-40, height/2, -1, -1)
	frame.view:setAnchorPoint(0.5, 0.5)
	local big_circle = ZImage:create(self.view, UILH_RADAR.circle, width/2, height/2 , -1, -1)
	big_circle.view:setAnchorPoint(0.5, 0.5)
	local cd_img = UILH_NORMAL.item_bg3_sld
	self.can_click = true
	self.near_person = {}	-- 记录附近玩家slot表
	-- local circle = 
	local line = ZImage:create(self.view, "ui/lh_radar/line.png", width/2, height/2, -1, -1)
	line.view:setFlipX(true)
	line.view:setAnchorPoint(1.0,0)
	-- line.view:setIsVisible(false)

	local player = EntityManager:get_player_avatar()

	local head_bg = ZImage:create(self.view, UILH_RADAR.light_bg, width/2, height/2, 74, 74)
	head_bg.view:setAnchorPoint(0.5, 0.5)
	local head_path = UIResourcePath.FileLocate.lh_normal .. "head/head"..player.job..player.sex..".png"
	local player_head = ZImage:create(head_bg.view, head_path, 37, 37, 69, 69, 2)
	player_head.view:setAnchorPoint(0.5, 0.5)
	-- self.think:start(0.3, circle_func)
	local beg_x = _refWidth(0.215) 	--起始X坐标
	local beg_y = close_y
	local int_w = 82
	local int_h = 100
	local w_num = 8 --横排数量
	local h_num = 4 --竖排数量
	local head_pos = {[12] = true, [13] = true, [20] = true, [21] = true, }	--头像位置
	max_num = w_num * h_num
	local function btn1_func()
		Instruction:handleUIComponentClick(instruct_comps.RADAR_SEARCH)
		local get_times_remain = FriendModel:get_get_times_num() -- 剩余次数
		-- 获取附近玩家
		FriendModel:send_get_radar_info()
		if get_times_remain <= 0 then
			return
		end
		self.can_click = false
		line.view:setIsVisible(true)
		self.tips_lab.view:setIsVisible(true)
		-- line.view:stopAction()
		-- 删除已创建的panel
		for i, v in ipairs(self.near_person) do
			v.view:removeFromParentAndCleanup(true)
		end
		self.near_person = {}
		-- 雷达扫描
		local array_1 = CCArray:array()
		local t0 = CCRotateTo:actionWithDuration(0, 0)
		local t1 = CCRotateBy:actionWithDuration(delay_time, 360)
		array_1:addObject(t1)
		array_1:addObject(t0)
		local seq_1 = CCSequence:actionsWithArray(array_1)
		line.view:runAction( seq_1 )
		local function get_result()
			-- 附近玩家处理回调函数
			local t = {}	-- 记录创建的随机数表
			math.randomseed(tostring(os.time()):reverse():sub(1, 6))
			-- 过滤3个劣质随机数
			math.random(1,max_num)
			math.random(1,max_num)
			math.random(1,max_num)
			self.show_timer = timer()
			local function cb_fun()
				local avatars =  FriendModel:get_radar_info()
				if #self.near_person >= #avatars then
					if self.show_timer then
						self.show_timer:stop()
						self.show_timer = nil
					end
					return
				end
				local ent_info = avatars[#self.near_person + 1]
				if ent_info then
					local pos = 1
					while(1) do
						pos = math.random(1,max_num)
						if not t[pos] and not head_pos[pos] then
							t[pos] = true
							break
						end
					end
					local dy_num = math.ceil(pos/w_num)
					local dx_num = pos%w_num
					dx_num = dx_num == 0 and w_num or dx_num
					-- print("pos:", pos, dy_num, dx_num)
					local slot = self:create_entity_slot(beg_x + int_w *(dx_num - 1), beg_y - int_h *(dy_num), ent_info, #avatars)
					table.insert(self.near_person, slot)
				end
			end
			self.show_timer:start(0.4, cb_fun)
		end
		self.get_timer = callback:new()
		self.get_timer:start(0.6, get_result)

		local function cb2_fun()
			self.can_click = true
		end
		self.click_timer = callback:new()
		self.click_timer:start(delay_time, cb2_fun)

		local function cb3_fun()
			self.tips_lab.view:setIsVisible(false)
		end
		self.tips_timer = callback:new()
		self.tips_timer:start(delay_time, cb3_fun)
	end

	local function btn2_func()
		Instruction:handleUIComponentClick(instruct_comps.RADAR_ADD_FRIEND)
		local avatars =  FriendModel:get_radar_info()
		if not self.near_person or #self.near_person <= 0 then
			return GlobalFunc:create_screen_notic( Lang.radar[2] );
		end
		for i, avatar in ipairs(avatars) do
			FriendCC:request_add_friend(avatar.id, avatar.name)
		end
		-- 申请完好友后清除面板数据
		GlobalFunc:create_screen_notic( Lang.radar[1] );
		FriendModel:set_radar_info({})
		-- 删除已创建的panel
		for i, v in ipairs(self.near_person) do
			v.view:removeFromParentAndCleanup(true)
		end
		self.near_person = {}
	end

	local btn1 = ZImageButton:create(self.view, UILH_RADAR.btn_bg, UILH_RADAR.btn_text1,btn1_func, 220, 20, -1, -1)
	local btn2 = ZImageButton:create(self.view, UILH_RADAR.btn_bg, UILH_RADAR.btn_text2,btn2_func, _refWidth(1.0) - 400, 20, -1, -1)

	local function exit_fun()
		Instruction:handleUIComponentClick(instruct_comps.CLOSE_BTN)
		UIManager:hide_window("onekeyadd_win")
	end

	local close_btn = ZButton:create(self.view, UILH_RADAR.close, exit_fun, _refWidth(0.7), close_y, -1, -1)
	local function self_view_func( eventType )
	    if eventType == TOUCH_BEGAN then
	        
	    end
	    return not self.can_click
    end
    -- chat_input_edit.view:registerScriptHandler(self_view_func)
    -- chat_info.group_scroll:registerScriptHandler(self_view_func)

    -- 雷达扫描过程中屏蔽点击
	local content = self.view:getSize()
	local basepanel = CCBasePanel:panelWithFile( 0, 0, content.width,content.height,nil);
	basepanel:setAnchorPoint(0,0)
	self.view:addChild(basepanel,500)
	basepanel:registerScriptHandler(self_view_func)
end

function OneKeyAddWin:destroy()
	if self.get_timer then
		self.get_timer:cancel()
		self.get_timer = nil
	end

	if self.show_timer then
		self.show_timer:stop()
		self.show_timer = nil
	end

	if self.click_timer then
		self.click_timer:cancel()
		self.click_timer = nil
	end

	if self.tips_timer then
		self.tips_timer:cancel()
		self.tips_timer = nil
	end
	Window.destroy(self)
end
