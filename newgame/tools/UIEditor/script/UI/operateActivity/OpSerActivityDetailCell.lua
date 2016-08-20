-- OpSerActivityDetailCell.lua
-- created by fjh 2013-5-30 
-- 开服活动的详细cell

super_class.OpSerActivityDetailCell()

OpSerActivityDetailCell.CELL_STYLE_DEFAULT 	= 1;
OpSerActivityDetailCell.CELL_STYLE_RANK 	= 2;
OpSerActivityDetailCell.CELL_STYLE_GUILD	= 3;
OpSerActivityDetailCell.CELL_STYLE_CHONGZHI = 4

OpSerActivityDetailCell.AWARD_STATE_NOT_AWARD	= 1;
OpSerActivityDetailCell.AWARD_STATE_CAN_GET	= 2;
OpSerActivityDetailCell.AWARD_STATE_DID_GET	= 3;

local font_size = 16
local slot_w = 55
local slot_h = 55
local slot_x = 10
local slot_y = 9
local slot_y2 = 90
local slot_offset = 65
local btn_x = 440
local btn_y = 19
local btn_w = 149
local btn_h = 57
local btn_lab_x1 = 40
local btn_lab_x2 = 35
local btn_lab_y = 15
local btn_lab_w1 = 82
local btn_lab_w2 = 77
local btn_lab_h = 25
local title_y = 77
local title_y2 = 174
local title_x = 5

function OpSerActivityDetailCell:__init( type, x, y, w, h, data )
	
	self.view = CCBasePanel:panelWithFile(x,y,w,h,"");
	self.data = data;

	if type == OpSerActivityDetailCell.CELL_STYLE_DEFAULT then
		self:init_for_default(self.view);
	elseif type == OpSerActivityDetailCell.CELL_STYLE_RANK then
		self:init_for_rank(self.view);
	elseif type == OpSerActivityDetailCell.CELL_STYLE_GUILD then
		self:init_guild( self.view );
	elseif type == OpSerActivityDetailCell.CELL_STYLE_CHONGZHI then
		self:init_for_default(self.view, true)
	end

end

function OpSerActivityDetailCell:set_func_1( fn )
	self.func_1 = fn;
end

function OpSerActivityDetailCell:set_func_2( fn )
	self.func_2 = fn;
end

function OpSerActivityDetailCell:set_btn_state( btn, btn_lab, state )
	
	if state == OpSerActivityDetailCell.AWARD_STATE_DID_GET then
		btn:setCurState(CLICK_STATE_DISABLE);
		btn_lab:setTexture( UILH_BENEFIT.yilingqu );
		btn_lab:setSize(60, 24);
		-- btn_lab:setPosition(btn_lab_x2, btn_lab_y);
		--btn_lab:setCurState(CLICK_STATE_DISABLE);
	elseif state == OpSerActivityDetailCell.AWARD_STATE_CAN_GET then
		btn:setCurState(CLICK_STATE_UP);
		btn_lab:setTexture( UILH_ACHIEVE.reward );
		btn_lab:setSize(btn_lab_w1, btn_lab_h);
		-- btn_lab:setPosition(btn_lab_x1, btn_lab_y);
		-- btn_lab:setCurState(CLICK_STATE_UP);
	elseif state == OpSerActivityDetailCell.AWARD_STATE_NOT_AWARD then
		btn:setCurState(CLICK_STATE_DISABLE);
		btn_lab:setTexture( UILH_ACHIEVE.reward );
		btn_lab:setSize(btn_lab_w1, btn_lab_h);
		-- btn_lab:setPosition(btn_lab_x1, btn_lab_y);
		--btn_lab:setCurState(CLICK_STATE_DISABLE);
	end

end

-- 普通奖励格式
function OpSerActivityDetailCell:init_for_default( view, cz_flag )

	-- 如果是充值，特殊处理
	if cz_flag then
		btn_y = 64
	else
		btn_y = 19
	end

	local title_str = "累积充值达到500元宝";	 -- [1637]="累积充值达到500元宝"
	if self.data then
		title_str = OpenSerConfig:get_detail_cell_title( self.data.act_index, self.data.cell_index );
	end

	self.desc_lab = UILabel:create_lable_2( LH_COLOR[13] .. title_str, title_x, title_y, font_size, ALIGN_LEFT );
	view:addChild(self.desc_lab);
	-- MUtils:create_zximg(view,UIPIC_Secretary_036, 0, 0, 380+55+150, -1, 500, 500)
	-- 分割线
    local line = CCZXImage:imageWithFile( 5, 0, 600, 3, UILH_COMMON.split_line )
    view:addChild(line)

	if self.data.award then
		for i,item in ipairs( self.data.award ) do
			local slot;
			if item.id == 3 then
				slot = MUtils:create_one_slotItem_align(nil,slot_x+slot_offset*(i-1), slot_y, slot_w, slot_h, 2, UILH_COMMON.slot_bg2 )
				slot:set_item_count(item.count);
				slot:set_money_icon(3);
			else
				slot = MUtils:create_one_slotItem_align( item.id, 
					slot_x+slot_offset*(i-1), slot_y, 
					slot_w, slot_h, 2, UILH_COMMON.slot_bg2 );
				slot:set_item_count(item.count);
				-- print("item.id     -----     item.count",item.id,item.count)
			end
			local function tip_func( slot_obj,eventType, args, msgid )
				local click_pos = Utils:Split(args, ":")
				local world_pos = self.view:getParent():convertToWorldSpace( CCPointMake( tonumber(click_pos[1]),tonumber(click_pos[2]) ) );
				if item.id == 3 then
					-- 显示元宝tip
					local data = {item_id = 3, item_count = item.count};
					TipsModel:show_money_tip( world_pos.x,world_pos.y, data );
				else
					-- print("道具 item id ",item.id);
					if item.id == 11402 then
						-- 如果奖励道具是个幻影金羽
						TipsModel:show_wing_tip_by_item_id(world_pos.x, world_pos.y, item.id)
					else
						TipsModel:show_shop_tip( world_pos.x,world_pos.y, item.id )
					end
				end
			end
			slot:set_click_event(tip_func)
			-- slot:play_activity_effect();
			view:addChild(slot.view);
		end
	end

	-- 领奖按钮
	local function btn_event( eventType )
		if eventType == TOUCH_CLICK then
			local bag_space_count = ItemModel:get_bag_space_gird_count();
			-- print("背包状态",bag_space_count);
			--需要的背包格子，放奖励
			local need_bag_count = 0;
			if OpenSerModel:get_activity_type() == OpenSerModel.ACTIVITY_TYPE_OPEN then
				if self.data.act_index == 2 then
					-- 如果是第二个活动，修仙初成，则不止需要一个格子，
					need_bag_count = #self.data.award;
				else
					need_bag_count = 1;
				end
			elseif OpenSerModel:get_activity_type() == OpenSerModel.ACTIVITY_TYPE_CLOSE_TEST then
				if self.data.act_index == 2 then
					--平台礼包
					need_bag_count = 1;
				end
			end
			if bag_space_count >= need_bag_count then
				if self.func_1 then	
					self.func_1();
					-- if self.data.act_index == 2 then
					-- 	local cur_player = EntityManager:get_player_avatar()
					-- 	if cur_player.level >= 30 then
					-- 		self:set_btn_state(self.btn, self.btn_lab,OpSerActivityDetailCell.AWARD_STATE_DID_GET);
					-- 	end
					-- else
						self:set_btn_state(self.btn, self.btn_lab,OpSerActivityDetailCell.AWARD_STATE_DID_GET);
					-- end
				end
			else
				GlobalFunc:create_screen_notic(LangGameString[1103]); -- [1103]="背包已满，无法领奖"
			end
		end
		return true
	end

	self.btn = MUtils:create_btn(view,
		UILH_NORMAL.special_btn, 
		UILH_NORMAL.special_btn, 
		btn_event,
		btn_x, btn_y, btn_w, btn_h);
	self.btn:addTexWithFile(CLICK_STATE_DISABLE, UILH_NORMAL.special_btn_d)
	self.btn_lab = MUtils:create_zximg(self.btn, 
		UILH_ACHIEVE.reward, 
		btn_lab_x1, btn_lab_y, 
		btn_lab_w1, btn_lab_h);
	self.btn_lab:setAnchorPoint(0.5, 0.5)
	self.btn_lab:setPosition(147/2, 57/2)
	self:set_btn_state(self.btn, self.btn_lab, OpSerActivityDetailCell.AWARD_STATE_NOT_AWARD);

	if OpenSerModel:get_activity_type(  ) == OpenSerModel.ACTIVITY_TYPE_OPEN then
		-- 根据领奖状态来设置按钮
		if self.data.award_status and self.data.act_index == 1 then
			-- 充值奖励
			local max_lv = self.data.award_status[1];
			local status = self.data.award_status[2];
			if self.data.cell_index+1 <= max_lv then
				self:set_btn_state(self.btn, self.btn_lab,OpSerActivityDetailCell.AWARD_STATE_CAN_GET);
			else
				self:set_btn_state(self.btn, self.btn_lab,OpSerActivityDetailCell.AWARD_STATE_NOT_AWARD);
			end
			if status == 1 then
				self:set_btn_state(self.btn, self.btn_lab,OpSerActivityDetailCell.AWARD_STATE_DID_GET);
			end
		elseif self.data.award_status and self.data.act_index == 2 then
			-- 修仙初成奖励
			local cell_award = self.data.award_status[self.data.cell_index];
			--cell index 刚好和这个奖励项的排序是一致的，
			--比如第一项总是人物等级项
			-- print("修仙初成奖励,",self.data.cell_index, cell_award.id,cell_award.status );
			if cell_award.id == self.data.cell_index then
				if cell_award.status == 0 then
					-- 不可领取的
					self:set_btn_state(self.btn, self.btn_lab,OpSerActivityDetailCell.AWARD_STATE_NOT_AWARD);
				elseif cell_award.status == 1 then
					-- 可领取
					self:set_btn_state(self.btn, self.btn_lab,OpSerActivityDetailCell.AWARD_STATE_CAN_GET);
				elseif cell_award.status == 2 then
					-- 已领取
					self:set_btn_state(self.btn, self.btn_lab,OpSerActivityDetailCell.AWARD_STATE_DID_GET);
				end
			end
			-- 忍者考试
			-- local award = self.data.award_status;
			-- local can_get = Utils:get_bit_by_position(award.has_award,self.data.cell_index);
			-- if can_get == 1 then
			-- 	local status = Utils:get_bit_by_position(award.status,self.data.cell_index);
			-- 	if status == 1 then
			-- 		-- 为1表示已经领过了
			-- 		self:set_btn_state(self.btn,self.btn_lab,OpSerActivityDetailCell.AWARD_STATE_DID_GET);	
			-- 	else 
			-- 		self:set_btn_state(self.btn,self.btn_lab,OpSerActivityDetailCell.AWARD_STATE_CAN_GET);
			-- 	end
			-- else
			-- 	self:set_btn_state(self.btn,self.btn_lab,OpSerActivityDetailCell.AWARD_STATE_NOT_AWARD);
			-- end
		elseif self.data.award_status and ( self.data.act_index == 10 or self.data.act_index == 11 ) then
			-- 套装奖励、渡劫奖励
			local award = self.data.award_status;

			local can_get = Utils:get_bit_by_position(award.has_award,self.data.cell_index);
			if can_get == 1 then
				local status = Utils:get_bit_by_position(award.status,self.data.cell_index);
				if status == 1 then
					-- 为1表示已经领过了
					self:set_btn_state(self.btn,self.btn_lab,OpSerActivityDetailCell.AWARD_STATE_DID_GET);	
				else 
					self:set_btn_state(self.btn,self.btn_lab,OpSerActivityDetailCell.AWARD_STATE_CAN_GET);
				end
			else
				self:set_btn_state(self.btn,self.btn_lab,OpSerActivityDetailCell.AWARD_STATE_NOT_AWARD);
			end
			
		end
	elseif OpenSerModel:get_activity_type() == OpenSerModel.ACTIVITY_TYPE_CLOSE_TEST then
		
		if self.data.act_index == 2 then
			--self.btn:setIsVisible(false);
		end
		-- print("self.data.award_status",self.data.award_status)
		if self.data.award_status then
			-- 修仙初成奖励
			local cell_award = nil
			if type( self.data.award_status ) == "table" then
				cell_award = self.data.award_status[self.data.cell_index].status;
			else
				cell_award = self.data.award_status
			end
			-- print("cell_award.status",cell_award)
			--cell index 刚好和这个奖励项的排序是一致的，
		
			if cell_award == 0 then
				-- 不可领取的
				self:set_btn_state(self.btn, self.btn_lab,OpSerActivityDetailCell.AWARD_STATE_NOT_AWARD);
			elseif cell_award == 1 then
				-- 可领取
				self:set_btn_state(self.btn, self.btn_lab,OpSerActivityDetailCell.AWARD_STATE_CAN_GET);
			elseif cell_award == 2 then
				-- 已领取
				self:set_btn_state(self.btn, self.btn_lab,OpSerActivityDetailCell.AWARD_STATE_DID_GET);
			end
		end
	end

	-- --分割线
	-- local split_img = CCZXImage:imageWithFile(0,0,view:getSize().width,2,UIResourcePath.FileLocate.common .. "jgt_line.png");
 --    view:addChild(split_img);
 	-- 分割线
		local line = CCZXImage:imageWithFile( 5, 0, 600, 3, UILH_COMMON.split_line )
		view:addChild(line)
end

-- 排行奖励格式
function OpSerActivityDetailCell:init_for_rank( view, cz_flag )

	if cz_flag then
		btn_y = 64
	else
		btn_y = 19
	end
	-- MUtils:create_zximg(view,UIPIC_Secretary_036, 0, 0, 380+55+150, -1, 500, 500)
	
	--获得者的名字
	local player_name = "";
	if self.data.award_status then
		player_name = self.data.award_status.rank_data.player_name;
	end
	if player_name == nil then
		player_name = "";
	end

	local rank_str = string.format( "排名第%d名", self.data.cell_index); -- [1638]="排名第#cfff000%d#cffffff名"
	self.player_name = UILabel:create_lable_2( LH_COLOR[13] ..rank_str, title_x, title_y, font_size, ALIGN_LEFT );
	view:addChild(self.player_name);

	--奖励礼包
	if self.data.award then	
		print("------self.data.award.id:", self.data.award.id)
		local slot = MUtils:create_one_slotItem_align( self.data.award.id, slot_x, slot_y, slot_w, slot_h, 2, UILH_COMMON.slot_bg2 );
		local function tip_func( slot_obj, eventType, args, msgid )

			local click_pos = Utils:Split(args, ":")
			local world_pos = self.view:getParent():convertToWorldSpace( CCPointMake( tonumber(click_pos[1]),tonumber(click_pos[2]) ) );
			TipsModel:show_shop_tip( world_pos.x,world_pos.y, self.data.award.id )

		end
		slot:set_click_event(tip_func)
		view:addChild(slot.view);
	end
	
	if player_name ~= "" then
		self.own_name = UILabel:create_lable_2( LangGameString[1639]..player_name, 250, 20, font_size, ALIGN_LEFT ); -- [1639]="#c38ff33获得者:  #cfff000"
		view:addChild(self.own_name);
	end

	local function btn_event( eventType )
		if eventType == TOUCH_CLICK then
			local bag_space_count = ItemModel:get_bag_space_gird_count();
			if bag_space_count >= 1 then
				if self.func_1 then
					self.func_1();
					self:set_btn_state(self.btn, self.btn_lab,OpSerActivityDetailCell.AWARD_STATE_DID_GET);
				end
			else
				GlobalFunc:create_screen_notic(LangGameString[1103]); -- [1103]="背包已满，无法领奖"
			end
		end
		return true
	end

	-- self.btn = MUtils:create_btn(view, 
	-- 	UIResourcePath.FileLocate.common .. "button_red.png",
	-- 	UIResourcePath.FileLocate.common .. "button_red.png",
	-- 	btn_event, 402, 10, 131, 42);
	-- self.btn_lab = MUtils:create_zximg(self.btn, 
	-- 	UIResourcePath.FileLocate.normal .. "get_award.png", 
	-- 	131/2-106/2, 42/2-22/2, 106, 22); 

	self.btn = MUtils:create_btn(view,
		UILH_NORMAL.special_btn, 
		UILH_NORMAL.special_btn, 
		btn_event,
		btn_x, btn_y, btn_w, btn_h);
	self.btn:addTexWithFile(CLICK_STATE_DISABLE, UILH_NORMAL.special_btn_d)
	self.btn_lab = MUtils:create_zximg(self.btn, 
		UILH_ACHIEVE.reward, 
		btn_lab_x1, btn_lab_y, btn_lab_w1, btn_lab_h);
	self.btn_lab:setAnchorPoint(0.5, 0.5)
	self.btn_lab:setPosition(147/2, 57/2)

	if self.data.award_status then

		print(self.data.award_status.rank_data.player_name,"领奖状态",self.data.award_status.has_award,self.data.award_status.award_status);

		local rank = self.data.award_status;
		if rank.has_award == 1 then
			--等于1，意味着上榜了
			if EntityManager:get_player_avatar().id == rank.rank_data.player_id then
				-- 如果该排名是自己
				if rank.award_status == 1 then
					-- 1 为已领取
					self:set_btn_state(self.btn, self.btn_lab,OpSerActivityDetailCell.AWARD_STATE_DID_GET);		
				else
					self:set_btn_state(self.btn, self.btn_lab,OpSerActivityDetailCell.AWARD_STATE_CAN_GET);	
				end
			else
				self:set_btn_state(self.btn, self.btn_lab,OpSerActivityDetailCell.AWARD_STATE_NOT_AWARD);	
			end
		else 
			self:set_btn_state(self.btn, self.btn_lab,OpSerActivityDetailCell.AWARD_STATE_NOT_AWARD);
		end 
	end

	-- --分割线
	-- local split_img = CCZXImage:imageWithFile(0,0,view:getSize().width,2,UIResourcePath.FileLocate.common .. "jgt_line.png");
 --    view:addChild(split_img);
 	-- 分割线
    local line = CCZXImage:imageWithFile( 5, 0, 600, 3, UILH_COMMON.split_line )
    view:addChild(line)
end


-- 仙宗奖励格式
function OpSerActivityDetailCell:init_guild( view, cz_flag )
	if cz_flag then
		btn_y = 64
	else
		btn_y = 19
	end

	-- MUtils:create_zximg(view,UIPIC_Secretary_036, 0, 0, 380+55+150, -1, 500, 500)

	-- print("创建仙宗cel");
	local title_str = LangGameString[246] -- [246]="所在仙宗达到2级"
	if self.data then
		title_str = OpenSerConfig:get_detail_cell_title( self.data.act_index, self.data.cell_index )
	end

	local title = UILabel:create_lable_2( LH_COLOR[13] ..title_str, title_x, title_y2, font_size, ALIGN_LEFT );
	view:addChild(title);

	--宗主奖励礼包
	if self.data.award then
		
		local function tip_func( slot_obj, eventType, args, msgid )

			local click_pos = Utils:Split(args, ":")
			local world_pos = self.view:getParent():convertToWorldSpace( CCPointMake( tonumber(click_pos[1]),tonumber(click_pos[2]) ) );
			-- print("奖励tip坐标",click_pos[1],click_pos[2],world_pos.x,world_pos.y);
			TipsModel:show_shop_tip( world_pos.x,world_pos.y, self.data.award[1].id )

		end

		local slot_guild_own = MUtils:create_one_slotItem( self.data.award[1].id, slot_x, slot_y2, slot_w, slot_h );
		slot_guild_own:set_item_count(self.data.award[1].count);
		slot_guild_own:set_click_event(tip_func);
		view:addChild(slot_guild_own.view);
	end

	--宗主额外礼包 lab
	local main_lab = UILabel:create_lable_2( LH_COLOR[12] .. "军团长额外礼包", 445, 138, font_size, ALIGN_LEFT ); -- [1640]="#c38ff33宗主额外礼包"
	view:addChild( main_lab );

	-- 领取奖励按钮
	local function btn_event( eventType )
		if eventType == TOUCH_CLICK then
			local bag_space_count = ItemModel:get_bag_space_gird_count();
			if bag_space_count >= 1 then
				if self.func_1 then
					self.func_1();
					self:set_btn_state(self.btn, self.btn_lab,OpSerActivityDetailCell.AWARD_STATE_DID_GET)
				end
			else
				GlobalFunc:create_screen_notic(LangGameString[1103]); -- [1103]="背包已满，无法领奖"
			end
		end
		return true
	end
	-- self.btn = MUtils:create_btn( view,
	-- 	UIResourcePath.FileLocate.common .. "button_red.png",
	-- 	UIResourcePath.FileLocate.common .. "button_red.png",
	-- 	btn_event, 405,90,131,42);
	-- self.btn_lab = MUtils:create_zximg(self.btn, 
	-- 	UIResourcePath.FileLocate.normal .. "get_award.png", 
	-- 	131/2-106/2, 42/2-22/2, 106, 22); 
	
	self.btn = MUtils:create_btn(view,
		UILH_NORMAL.special_btn, 
		UILH_NORMAL.special_btn, 
		btn_event,
		btn_x, 80, btn_w, btn_h);
	self.btn:addTexWithFile(CLICK_STATE_DISABLE, UILH_NORMAL.special_btn_d)
	self.btn_lab = MUtils:create_zximg(self.btn, 
		UILH_ACHIEVE.reward, 
		btn_lab_x1, btn_lab_y, btn_lab_w1, btn_lab_h);
	self.btn_lab:setAnchorPoint(0.5, 0.5)
	self.btn_lab:setPosition(147/2, 57/2)

	--仙宗成员奖励礼包
	if self.data.award then
		for i,item in ipairs(self.data.award[2]) do
			local slot_guild_member = MUtils:create_one_slotItem_align( item.id, 
				slot_x+slot_offset*(i-1), slot_y, 
				slot_w, slot_h, 2, UILH_COMMON.slot_bg2  );
			slot_guild_member:set_item_count(item.count);

			local function tip_func( slot_obj, eventType, args, msgid )
				local click_pos = Utils:Split(args, ":")
				local world_pos = self.view:getParent():convertToWorldSpace( CCPointMake( tonumber(click_pos[1]),tonumber(click_pos[2]) ) );
				-- print("奖励tip坐标",click_pos[1],click_pos[2],world_pos.x,world_pos.y);
				TipsModel:show_shop_tip( world_pos.x,world_pos.y, item.id )
			end
			slot_guild_member:set_click_event(tip_func);
			view:addChild( slot_guild_member.view );
		end
	end

	--宗派成员礼包
	local gen_lab = UILabel:create_lable_2( LH_COLOR[12] .. "军团成员礼包", 455, 56, font_size, ALIGN_LEFT ); -- [1641]="#c38ff33宗派成员礼包"
	view:addChild( gen_lab );

	-- 领取按钮
	local function btn_2_event( eventType )
		if eventType == TOUCH_CLICK then
			local bag_space_count = ItemModel:get_bag_space_gird_count();
			if bag_space_count >= 1 then
				if self.func_2 then
					self.func_2();
					self:set_btn_state(self.btn_2, self.btn_lab_2, OpSerActivityDetailCell.AWARD_STATE_DID_GET)
				end
			else
				GlobalFunc:create_screen_notic(LangGameString[1103]); -- [1103]="背包已满，无法领奖"
			end
		end
		return true
	end
	-- self.btn_2 = MUtils:create_btn(	view,
	-- 	UIResourcePath.FileLocate.common .. "button_red.png",
	-- 	UIResourcePath.FileLocate.common .. "button_red.png",
	-- 	btn_2_event, 402,10,131,42);
	-- self.btn_lab_2 = MUtils:create_zximg(self.btn_2, 
	-- 	UIResourcePath.FileLocate.normal .. "get_award.png", 
	-- 	131/2-106/2, 42/2-22/2, 106, 22); 

	self.btn_2 = MUtils:create_btn(view,
		UILH_NORMAL.special_btn, 
		UILH_NORMAL.special_btn, 
		btn_2_event,
		btn_x, 0, btn_w, btn_h);
	self.btn_2:addTexWithFile(CLICK_STATE_DISABLE, UILH_NORMAL.special_btn_d)
	self.btn_lab_2 = MUtils:create_zximg(self.btn_2, 
		UILH_ACHIEVE.reward, 
		btn_lab_x1, btn_lab_y, btn_lab_w1, btn_lab_h);
	self.btn_lab_2:setAnchorPoint(0.5, 0.5)
	self.btn_lab_2:setPosition(147/2, 57/2)

	--已领取  ui/common/text_4.png
	self:set_btn_state( self.btn,self.btn_lab,OpSerActivityDetailCell.AWARD_STATE_NOT_AWARD );
	self:set_btn_state( self.btn_2,self.btn_lab_2,OpSerActivityDetailCell.AWARD_STATE_NOT_AWARD );
	-- 领奖状态
	if self.data.award_status then

		if self.data.award_status.guild_lv  == self.data.cell_index+1 then
			--仙宗等级达到，可以领奖 

			local member_can_get = Utils:get_bit_by_position( self.data.award_status.status, 1 );
			local president_can_get = Utils:get_bit_by_position( self.data.award_status.status, 2 );
			local member_did_get = Utils:get_bit_by_position( self.data.award_status.status, 3 );
			local president_did_get = Utils:get_bit_by_position( self.data.award_status.status, 4 );
			
			if member_can_get == 1 then
				self:set_btn_state( self.btn_2,self.btn_lab_2,OpSerActivityDetailCell.AWARD_STATE_CAN_GET );
			end
			if president_can_get == 1 then
				self:set_btn_state( self.btn,self.btn_lab,OpSerActivityDetailCell.AWARD_STATE_CAN_GET );
			end
			if member_did_get == 1 then
				self:set_btn_state( self.btn_2,self.btn_lab_2,OpSerActivityDetailCell.AWARD_STATE_DID_GET );
			end
			if president_did_get == 1 then
				self:set_btn_state( self.btn,self.btn_lab,OpSerActivityDetailCell.AWARD_STATE_DID_GET );
			end
		else
			self:set_btn_state( self.btn,self.btn_lab,OpSerActivityDetailCell.AWARD_STATE_NOT_AWARD );
			self:set_btn_state( self.btn_2,self.btn_lab_2,OpSerActivityDetailCell.AWARD_STATE_NOT_AWARD );
		end

	end

	-- --分割线
	-- local split_img = CCZXImage:imageWithFile(0,0,view:getSize().width,2,UIResourcePath.FileLocate.common .. "jgt_line.png");
 --    view:addChild(split_img);
 	-- 分割线
    local line = CCZXImage:imageWithFile( 0, 0, 600, 3, UILH_COMMON.split_line )
    view:addChild(line)

end
