-- DragonTower.lua
-- 神龙密塔
-- created by hwl	2015-3-18

super_class.DragonTower(NormalStyleWindow)

local act_id = 15	--神龙密塔的活动ID
function DragonTower:create_need_items(panel, items)
	local item_tab = {}		--item表
	local beg_x =  10 + (5 - #items) * 65
	for i , v in ipairs(items) do
		local temp = ZBasePanel:create(panel, UILH_COMMON.bg_10, beg_x + (i-1) * 120, 4, 118, 74, 500, 500 )
		temp.front = ZImage:create(temp.view, UILH_TOWER.rect, 0, 0, -1, -1)
		temp.front.view:setIsVisible(false)
		ZLabel:create(temp.view, Lang.dragontext[1], 65, 55, 17, 2)
		local item_name = ""
		if v[1] <= 10 then
			item_name = Lang.dragontext[2+v[1]] or ""
		else
			item_name = ItemConfig:get_item_name_by_item_id(v[1])
		end
		local name_lab = ZLabel:create(temp.view, item_name, 60, 32, 16, 2)
		temp.need_item = v[1]
		temp.need_num = v[2]
		temp.need_lab = ZLabel:create(temp.view, "0/" .. v[2], 60, 9, 16, 2)
		table.insert(item_tab, temp)
	end


	if #items ~= 5 then
		local width = 285
		local line = ZImage:create(panel, UILH_TOWER.line, 619 , 41, width - 56 * #items, -1, 0, 500)
		line.view:setAnchorPoint(1, 0)
	end

	return item_tab
end

function DragonTower:__init( ... )
	--配置表
	require '../data/magicdragonconf'

	self.r_rewards = magicdragonconf.rewards --右侧奖励表
	self.l_collect = magicdragonconf.collectItem -- 左侧收集列表
	self.scroll_tab = {}	--scroll item表
	ZImage:create(self.view,UILH_COMMON.normal_bg_v2 ,10 ,10,882,550,0,500,500);

	ZImage:create(self.view, UILH_TOWER.text1, 185, 510, -1, -1)
	ZImage:create(self.view, UILH_TOWER.text2, 516, 510, -1, -1)

	ZLabel:create(self.view, LH_COLOR[6] .. Lang.dragontext[2], 220, 490, 16)
	local time_remain = SmallOperationModel:getActivityRemainTime(act_id) or 0
	if time_remain == 0 then
        ZLabel:create( self.view, LH_COLOR[6] .. Lang.f_draw[2], 350, 490, 16, ALIGN_LEFT )
    else
        local function end_call_func()
            ZLabel:create( self.view, LH_COLOR[6] .. Lang.f_draw[2], 350, 490, 16, ALIGN_LEFT )
        end
        self.timer_label = TimerLabel:create_label( self.view, 350, 490, 16, time_remain, LH_COLOR[6], end_call_func )
    end
	ZImage:create(self.view, UILH_TOWER.sign, 90, 350, -1, -1)
	local function scroll_func( )
		local temp_height = 89
		local panel_height = temp_height * 5
		local panel = ZBasePanel:create(nil, nil, 0, 0, 852, panel_height )
		for i, col in ipairs(self.l_collect) do
			local temp = ZBasePanel:create(panel.view, nil, 0, panel_height - temp_height*i, 852, temp_height )
			temp.con_items = self:create_need_items(temp.view, col)
			local award_info = self.r_rewards[i]
			local item_id = award_info[1]
			local item_n = award_info[2]
			local award_slot = SlotItem(64, 64)
			award_slot:set_icon_bg_texture(UILH_COMMON.slot_bg, -7, -7, 79, 79)
			local function f1( ... )
				if ( item_id ) then 
					local a, b, arg = ...
					local click_pos = Utils:Split(arg, ":")
					local world_pos = award_slot.view:getParent():convertToWorldSpace( CCPointMake( tonumber(click_pos[1]),tonumber(click_pos[2]) ) )
					TipsModel:show_shop_tip( world_pos.x, world_pos.y, item_id );
				end
			end
			award_slot:set_click_event( f1 )
			award_slot:set_icon(item_id)
			award_slot:set_color_frame( item_id, -2, -2, 68, 68 )    -- 边框颜色
			award_slot:set_item_count(item_n)
			temp.view:addChild(award_slot.view)
			award_slot.view:setPosition(640, 10)
			local function get_award()
				OnlineAwardCC:req_tower_award(act_id, i)
			end

			ZImage:create(temp.view, UILH_TOWER.jiantou, 615, 35, -1, -1)
			--领取奖励按钮
			temp.get_btn = ZImageButton:create(temp.view, UILH_COMMON.btn4_nor, UILH_BENEFIT.lingqujiangli, get_award, 715, 19, -1, -1 )
			temp.get_btn.view:addTexWithFile(CLICK_STATE_DISABLE, UILH_COMMON.btn4_dis)
			table.insert(self.scroll_tab, temp)
		end
		OnlineAwardCC:req_tower_info( act_id )
		return panel
	end

	self.scroll = ZScroll:create(self.view, scroll_func, 25, 25, 852, 450, 1, TYPE_HORIZONTAL)
	self.scroll:setScrollLump(10, 10, 40)
	self.scroll.view:setScrollLumpPos(840)
	local arrow_up = CCZXImage:imageWithFile(865, 464, 10, -1 , UILH_COMMON.scrollbar_up, 500, 500)
	local arrow_down = CCZXImage:imageWithFile(865, 25, 10, -1, UILH_COMMON.scrollbar_down, 500 , 500)
	self.view:addChild(arrow_up)
	self.view:addChild(arrow_down)
	self.scroll:refresh()

end

--提供给外部调用,更新界面
function DragonTower:update( awards_state, items_state )
	for i, temp in ipairs(self.scroll_tab) do
		local state = awards_state[i]
		--更新奖励领取按钮状态
		if state == 2 then
			temp.get_btn.view:setCurState(CLICK_STATE_DISABLE)
			temp.get_btn:set_image_texture(UILH_BENEFIT.yilingqu)	
		elseif state == 1 then
			temp.get_btn.view:setCurState(CLICK_STATE_UP)
			temp.get_btn:set_image_texture(UILH_BENEFIT.lingqujiangli)
		else
			temp.get_btn.view:setCurState(CLICK_STATE_DISABLE)
			temp.get_btn:set_image_texture(UILH_BENEFIT.lingqujiangli)
		end
		-- 更新每一行的条件满足情况
		if temp.con_items then
			for k, item in ipairs(temp.con_items) do
				local item_id = item.need_item
				local item_num = item.need_num
				if items_state[item_id] then
					local cur_num = items_state[item_id] < item_num and items_state[item_id] or item_num
					if cur_num == item_num then
						item.front.view:setIsVisible(true)
					else
						item.front.view:setIsVisible(false)
					end
					item.need_lab:setText(cur_num .. '/' .. item_num)
				end
			end
		end
	end
end

function DragonTower:destroy( )
	if self.timer_label then
        self.timer_label:destroy()
        self.timer_label = nil
    end
end