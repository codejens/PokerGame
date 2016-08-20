-- BenefitLoginCell.lua
-- created by LittleWhite 2014-7-24 
-- 登陆奖励单元格

super_class.BenefitLoginCell()

BenefitLoginCell.AWARD_STATE_NOT_AWARD	= 1;
BenefitLoginCell.AWARD_STATE_CAN_GET	= 2;
BenefitLoginCell.AWARD_STATE_DID_GET	= 3;

function BenefitLoginCell:__init(x, y, w, h, data )
	
	self.view = CCBasePanel:panelWithFile(x,y,w,h,"")
	self.data = data
	self.slot_table={}          -- 保存创建的slot
	self:initializeUI()
end

function BenefitLoginCell:initializeUI()

	local slot_w = 72
	local slot_h = 72
	local slot_x = 20
	local slot_y = 10
	local slot_offset = 85

	if self.data.awards.items then
		for i=1,#self.data.awards.items do
			local slot;
			local item = self.data.awards.items[i]
			if item.itemid == 3 then
				slot = MUtils:create_one_slotItem( nil, 
					slot_x+slot_offset*(i-1), slot_y, 
					slot_w, slot_h )
				slot:set_item_count(item.count)
				slot:set_money_icon(3)
			else
				slot = MUtils:create_one_slotItem( item.itemid, 
					slot_x+slot_offset*(i-1), slot_y, 
					slot_w, slot_h );
				slot:set_item_count(item.count)
				if item.effect then
					LuaEffectManager:stop_view_effect( item.effect,slot.icon)
            		slot.effect = LuaEffectManager:play_view_effect( item.effect,0,0,slot.icon ,true);
            		slot.effect:setPosition(CCPointMake(24, 24))
				end 
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
			self.view:addChild(slot.view)
			self.slot_table[i] = slot
		end
	end

	--累计登陆x天奖励
	local title = ZImageImage:create(self.view, UIPIC_Benefit_014, UIPIC_Benefit_013, 285,28,-1,-1)
	self.day_text = UILabel:create_lable_2( "#cfff000"..self.data.days_index, 65,8 , 17, ALIGN_CENTER )
	title.view:addChild(self.day_text)

	-- 分隔线
	MUtils:create_zximg(self.view,UIPIC_Benefit_024,15,0,410,2,500,500)

	-- 领奖按钮
	local function btn_event( eventType )
		if eventType == TOUCH_CLICK then
			local bag_space_count = ItemModel:get_bag_space_gird_count();
			-- print("背包状态",bag_space_count);
			--需要的背包格子，放奖励
			local need_bag_count = self.data.awards.needbagnum

			if bag_space_count >= need_bag_count then
				if self.func then	
					self.func();
					self:set_btn_state(self.btn, self.btn_lab,BenefitLoginCell.AWARD_STATE_DID_GET);
				end
			else
				GlobalFunc:create_screen_notic(LangGameString[1103]); -- [1103]="背包已满，无法领奖"
			end
		end
		return true
	end

	self.btn = MUtils:create_btn(self.view,UIPIC_Benefit_015, UIPIC_Benefit_015,btn_event,450, 13, -1, -1);
	self.btn:addTexWithFile(CLICK_STATE_DISABLE,UIPIC_Benefit_016)

	self.btn_lab = MUtils:create_zximg(self.btn,UIPIC_Benefit_017,40, 15, -1, -1)
	self.btn_lab:setAnchorPoint(0.5, 0.5)
	self.btn_lab:setPosition(147/2, 57/2)
	self:set_btn_state(self.btn, self.btn_lab, BenefitLoginCell.AWARD_STATE_NOT_AWARD)

	if self.data.has_award == 1 then
		self:set_btn_state(self.btn, self.btn_lab,BenefitLoginCell.AWARD_STATE_CAN_GET)
	else
		self:set_btn_state(self.btn, self.btn_lab,BenefitLoginCell.AWARD_STATE_NOT_AWARD)
	end 

	if self.data.status == 1 then
		self:set_btn_state(self.btn, self.btn_lab,BenefitLoginCell.AWARD_STATE_DID_GET);
	end
end

function BenefitLoginCell:update(data)
	if data then
		self.data = data
		self.day_text:setText("#cfff000"..self.data.days_index)

		if self.data.awards.items then
			for i=1,#self.data.awards.items do
				local item = self.data.awards.items[i]
				self.slot_table[i]:update(item.itemid,item.count,nil)
				print("!!!!!(self.data.days_index,item.itemid,item.effect)",self.data.days_index,item.itemid,item.effect)
				if item.effect then
					LuaEffectManager:stop_view_effect( item.effect,self.slot_table[i].icon )
            		self.slot_table[i].effect = LuaEffectManager:play_view_effect( item.effect,0,0,self.slot_table[i].icon ,true);
            		self.slot_table[i].effect:setPosition(CCPointMake(24, 24))
            	else
            		LuaEffectManager:stop_view_effect(57,self.slot_table[i].icon )
            		-- if self.slot_table[i].effect then
            		-- 		self.slot_table[i].effect:removeFromParentAndCleanup(true)
            		-- end 
				end 
			end 
		end 

		if self.data.has_award == 1 then
			self:set_btn_state(self.btn, self.btn_lab,BenefitLoginCell.AWARD_STATE_CAN_GET)
		else
			self:set_btn_state(self.btn, self.btn_lab,BenefitLoginCell.AWARD_STATE_NOT_AWARD)
		end 

		if self.data.status == 1 then
			self:set_btn_state(self.btn, self.btn_lab,BenefitLoginCell.AWARD_STATE_DID_GET);
		end
	end 
end

function BenefitLoginCell:set_btn_state( btn, btn_lab, state )
	if state == BenefitLoginCell.AWARD_STATE_DID_GET then
		btn:setCurState(CLICK_STATE_DISABLE)
		btn_lab:setTexture(UIPIC_Benefit_018)
		btn_lab:setSize(77, 29)
	elseif state == BenefitLoginCell.AWARD_STATE_CAN_GET then
		btn:setCurState(CLICK_STATE_UP)
		btn_lab:setTexture(UIPIC_Benefit_017)
		btn_lab:setSize(66, 29)
	elseif state == BenefitLoginCell.AWARD_STATE_NOT_AWARD then
		btn:setCurState(CLICK_STATE_DISABLE)
		btn_lab:setTexture(UIPIC_Benefit_017)
		btn_lab:setSize(66, 29)
	end
end


function BenefitLoginCell:set_click_func( func)
	self.func = func 
end