-- BenefitLoginPage.lua 
-- createed by LittleWhite @2014-7-23
-- 登陆福利页面
--天降雄狮中没有使用
super_class.BenefitLoginPage()

function BenefitLoginPage:__init(x,y)
	local pos_x = x or 0
    local pos_y = y or 0
	self.view = CCBasePanel:panelWithFile( pos_x, pos_y,662,540, nil, 500, 500 )
    --self.view:setEnableHitTest(false)
	-- self:create_up_panel()
    self:create_awards_panel()
    self:create_bottom_panel()
end

function BenefitLoginPage:create_up_panel()
	local up_panel = CCBasePanel:panelWithFile( 0, 450, 593, 87,UIPIC_Benefit_003, 500, 500 )
	self.view:addChild( up_panel )

	MUtils:create_zximg(up_panel,UIPIC_Benefit_007,19,39,-1,-1)

	MUtils:create_zximg(up_panel,UIPIC_Benefit_012,429,11,-1,-1)

	local text_login_days = "#cfff000"..BenefitModel:get_login_days().."天"

	MUtils:create_zxfont(up_panel,text_login_days,540,13,1,17)
end

-- 新版滚动条
function BenefitLoginPage:create_awards_panel()

    -- 背景容器
	self.awards_panel = CCBasePanel:panelWithFile( 0, 120, 655, 417,UIPIC_Benefit_003, 500, 500 )
    --self.awards_panel:setEnableHitTest(false)
    self.view:addChild( self.awards_panel ,2)    

    local panel = self.awards_panel

    -- 累积登陆xx天
    MUtils:create_zximg(panel,UIPIC_Benefit_012,15,385,-1,-1)
    local text_login_days = "#cfff000"..BenefitModel:get_login_days().."天"
    MUtils:create_zxfont(panel,text_login_days,123,387,1,17)

    MUtils:create_zxfont(panel,"#cfff000PS:滑动可以查看更多奖励",450,387,1,14)

    -- 滑动图片
    local  scroll_pic_1 = MUtils:create_sprite(panel,UILH_FORGE.force_jt,630,330)
    scroll_pic_1:setRotation(270)

    local  scroll_pic_2 = MUtils:create_sprite(panel,UILH_FORGE.force_jt,630,43)
    scroll_pic_2:setRotation(90)

    local max_number = BenefitConfig:get_max_awards_number() or 30

    local function createBenefitLoginCell(index,newComp)

    	local awards = {}
    	-- print("createBenefitLoginCell(index)",index)
        --首月
        if BenefitModel:get_benefit_type() == 1 then
        	awards = BenefitConfig:get_firstrawards(index)
        else
        	awards = BenefitConfig:get_normalrewards(index)
        end 

        local cell_height = 80;
        local login_days = BenefitModel:get_login_days()
        local login_status_flags = BenefitModel:get_status_flags()
        local award_status = Utils:get_bit_by_position(login_status_flags,index )
        local has_award = 0

        if login_days < index then
        	has_award = 0
        else
        	has_award = 1
        end 

        local data = {days_index = index , awards = awards , has_award = has_award, status = award_status}
        
        local function get_award_event( )
            --领奖按钮
            self:click_get_award_btn(index);
        end

		if not newComp then
			newComp = BenefitLoginCell(0, 0, 610, cell_height, data )
        	newComp:set_click_func(get_award_event)
        else
        	newComp:update(data)
        	newComp:set_click_func(get_award_event)
		end

		return newComp
	end

    local function generate_num_list(max_num)
       local num_list = {}
       for i=1,max_num do
           table.insert(num_list,i)
       end
       return num_list
    end 

    local num_list = generate_num_list(max_number)

	self.scroll = TouchListVertical(5,8,610,360,93,0)
    self.scroll:BuildList(90,0,4,num_list,createBenefitLoginCell)

	panel:addChild(self.scroll.view);
end 

-- 老版滚动条，已作废
function BenefitLoginPage:create_down_panel()
	self.down_panel = CCBasePanel:panelWithFile( 0, 120, 593, 327,UIPIC_Benefit_003, 500, 500 )
    self.view:addChild( self.down_panel )    

    local panel = self.down_panel

    local max_number = BenefitConfig:get_max_awards_number() or 30
    self.detail_scroll = CCScroll:scrollWithFile( 5, 8, 590, 310, max_number, "", TYPE_HORIZONTAL, 600, 600 )

    local function scrollfun(eventType, arg, msgid)
        if eventType == nil or arg == nil or msgid == nil then
            return false
        end
        local temparg = Utils:Split(arg,":")
        local row = temparg[1]  --列数
        if row == nil then 
            return false;
        end
        
        if eventType == SCROLL_CREATE_ITEM then
                  
            row = tonumber(row);
            -- 奖励的itemlist

            local awards = {}

            --首月
            if BenefitModel:get_benefit_type() == 1 then
            	awards = BenefitConfig:get_firstrawards(row+1)
            else
            	awards = BenefitConfig:get_normalrewards(row+1)
            end 

            local cell_height = 105;
            local login_days = BenefitModel:get_login_days()
            local login_status_flags = BenefitModel:get_status_flags()
            local award_status = Utils:get_bit_by_position(login_status_flags,row + 1 )
            local has_award = 0

            if login_days < row +1 then
            	has_award = 0
            else
            	has_award = 1
            end 

            local data = {days_index = row+1, awards = awards , has_award = has_award, status = award_status}
            
            local function get_award_event( )
                --领奖按钮
                self:click_get_award_btn( row + 1);
            end

            local cell = BenefitLoginCell(0, 0, 590, cell_height, data )
            cell:set_click_func(get_award_event)

            self.detail_scroll:addItem( cell.view )
            self.detail_scroll:refresh( ) 
        end
        return true
    end
    
    self.detail_scroll:registerScriptHandler(scrollfun)
    self.detail_scroll:refresh()
    panel:addChild(self.detail_scroll);
end

function BenefitLoginPage:create_bottom_panel()
	local bottom_panel = CCBasePanel:panelWithFile( 0, 0, 655, 117,UIPIC_Benefit_003, 500, 500 )
	self.view:addChild( bottom_panel )

	MUtils:create_zximg(bottom_panel,UIPIC_Benefit_020,0,5,655,-1,500,500)

	MUtils:create_zximg(bottom_panel,UIPIC_Benefit_019,445,20,-1,-1)

	local awards = {}
	if BenefitModel:get_benefit_type() == 1 then
		awards = BenefitConfig:get_first_showrewards()
	else
		awards = BenefitConfig:get_normal_showrewards()
	end 

	local slot_w = 72
	local slot_h = 72
	local slot_x = 25
	local slot_y = 28
	local slot_offset = 85

	if awards.items then
		for i,item in ipairs( awards.items) do
			local slot;
			if item.itemid == 3 then
				slot = MUtils:create_one_slotItem( nil, 
					slot_x+slot_offset*(i-1), slot_y, 
					slot_w, slot_h );
				slot:set_item_count(item.count);
				slot:set_money_icon(3);
			else
				slot = MUtils:create_one_slotItem( item.itemid, 
					slot_x+slot_offset*(i-1), slot_y, 
					slot_w, slot_h );
				slot:set_item_count(item.count);
				-- print("item.itemid  ----- item.count",item.itemid,item.count)
			end
			local function tip_func( slot_obj,eventType, args, msgid )
				local click_pos = Utils:Split(args, ":")
				local world_pos = self.view:getParent():convertToWorldSpace( CCPointMake( tonumber(click_pos[1]),tonumber(click_pos[2]) ) );
				if item.itemid == 3 then
					-- 显示元宝tip
					local data = {item_id = 3, item_count = item.count};
					TipsModel:show_money_tip( world_pos.x,world_pos.y, data );
				else
					-- print("道具 item id ",item.id);
					TipsModel:show_shop_tip( world_pos.x,world_pos.y, item.itemid)
				end
			end
			slot:set_click_event(tip_func)
			-- slot:play_activity_effect()
			LuaEffectManager:stop_view_effect( 11009,slot.icon )
            local spr = LuaEffectManager:play_view_effect( 11009,0,0,slot.icon ,true);
            spr:setPosition(CCPointMake(24, 24))
			bottom_panel:addChild(slot.view)
		end
	end
end

-- 领奖按钮 
function BenefitLoginPage:click_get_award_btn( days_index )
	-- print("BenefitLoginPage:click_get_award_btn( days_index )",days_index)
 	OnlineAwardCC:req_get_login_benefit(days_index)
end

function BenefitLoginPage:update()
	local login_status_flags = BenefitModel:get_status_flags()
	local max_number = BenefitConfig:get_max_awards_number()

	for i=1,max_number do
		local flag = Utils:get_bit_by_position(login_status_flags,i)
		-- print("BenefitLoginPage:update(i,flag)",i,flag)
		if flag == 0 then
			self.scroll:setIndex(i)
			return;
		end 

        if i == max_number - 2 then
            self.scroll:setIndex(i)
            return
        end 
	end
end

function BenefitLoginPage:active( show )
	if show == true then
		self:update();
	end
end

-- 销毁
function BenefitLoginPage:destroy()
    -- print("BenefitLoginPage:destroy()")
	self.scroll:destroy()
end