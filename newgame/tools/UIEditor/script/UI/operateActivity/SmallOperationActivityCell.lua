-- SmallOperationActivityCell.lua
-- 小型运营活动面板里的cell create by fjh 2013-8-2

super_class.SmallOperationActivityCell()

SmallOperationActivityCell.STYLE_DEFAULT = 1;	--默认风格 

SmallOperationActivityCell.BTN_STATE_GET = 1; 	--可领取
SmallOperationActivityCell.BTN_STATE_NOT_GET = 2;		--无法领取
SmallOperationActivityCell.BTN_STATE_DID_GET = 3;	--已领取

local num_arr = {
	[1] = UILH_MRCZ.num_1,
	[2] = UILH_MRCZ.num_2,
	[3] = UILH_MRCZ.num_3,
	[4] = UILH_MRCZ.num_4,
}
function SmallOperationActivityCell:__init( style, x, y, index )
	self.style = style;
	self.index = index;
	self.view = CCBasePanel:panelWithFile( x, y, 700, 98, "", 600, 600 );

	if style == SmallOperationActivityCell.STYLE_DEFAULT then
		self:init_default_cell( index );
	end
end

function SmallOperationActivityCell:init_default_cell( index )
    
	local title = OperationActivityConfig:get_cell_title_by_type( SmallOperationModel:get_operation_act_type() );
	local str;
	if SmallOperationModel:get_operation_act_type() == ServerActivityConfig.ACT_TYPE_STRONG_HERO then
		str = string.format("#cd40404"..title,index+5);
	elseif SmallOperationModel:get_operation_act_type() == ServerActivityConfig.ACT_TYPE_POWER_PET then
		if index == 5 then
			str = string.format("#cd40404"..title,40);
		else
			str = string.format("#cd40404"..title,index*5+10);	
		end
		
	elseif SmallOperationModel:get_operation_act_type() == ServerActivityConfig.ACT_TYPE_POWER_FABAO then
		str = string.format("#cd40404"..title,index*10);
	elseif SmallOperationModel:get_operation_act_type() == ServerActivityConfig.ACT_TYPE_GUOQING then
		if ( index == 1 ) then
			str = LangGameString[1102] -- [1102]="#cd40404每日登录礼包"
		else
			str = string.format("#cd40404"..title,OperationActivityConfig.guoqing_login_award_day[index-1]);
		end
	elseif SmallOperationModel.get_operation_act_type() == ServerActivityConfig.ACT_TYPE_QIANGLILAIXI then
		if index == 1 then
			str = string.format("#cd40404"..title,"任意金额");
		else
			str = string.format("#cd40404"..title,OperationActivityConfig.qianglilaixi_chongzhi_yuanbao[index]);
		end
	elseif SmallOperationModel.get_operation_act_type() == ServerActivityConfig.ACT_TYPE_MEIRIXIAOFEI then
		    local txt_bg = MUtils:create_zximg(self.view, UILH_MRCZ.txt_bg, 53, 20, -1, -1,1)
		    local num_bg = MUtils:create_zximg(txt_bg, UILH_MRCZ.num_bg, -60, -15, -1, -1,2)
		    local num =  MUtils:create_zximg(num_bg, num_arr[index], 33,31, -1, -1)
		    local txt_1 = MUtils:create_zximg(txt_bg, UILH_MRCZ.txt_1, 27, 28, -1, -1)
		    local txt_2 = MUtils:create_zximg(txt_bg, UILH_MRCZ.txt_2, 65, 3, -1, -1)
		-- if index == 1 then
			-- str = string.format(LH_COLOR[10]..title,"888");
		-- else
			str = string.format(LH_COLOR[10]..title,OperationActivityConfig:get_xiaofei_txt_config(SmallOperationModel.get_operation_act_type() ,index));
		-- end	
	end
	
	local lab = UILabel:create_lable_2( str, 167, 61, 18, ALIGN_CENTER );
	self.view:addChild(lab);

	-- award item 奖励道具

	local award_dict = SmallOperationModel:get_act_award_config( index );
	for i,v in ipairs(award_dict) do
       -- local item = MUtils:create_slot_item2(parent,bg_path,pos_x,pos_y,width,height,item_id,fun,icon_offset)
		local item = MUtils:create_one_slotItem( v.id, 320+(i-1)*(62), 25, 56, 56 );
		self.view:addChild(item.view);
		item:set_color_frame(nil);
		item:set_icon_bg_texture( UILH_COMMON.slot_bg2, -6, -6, 74, 74 )
		item:set_count(v.count);

		local function item_click_event(...)
			local a, b, arg = ...
            local click_pos = Utils:Split(arg, ":")
            local world_pos = item.view:getParent():convertToWorldSpace( CCPointMake( tonumber(click_pos[1]),tonumber(click_pos[2]) ) )
            TipsModel:show_shop_tip( world_pos.x, world_pos.y, v.id );

		end
		item:set_click_event(item_click_event);
	--	item:play_activity_effect();
		
	end


	-- 领取奖励 
	local function get_award( eventType )
		if eventType == TOUCH_CLICK then
			local bag_space_count = ItemModel:get_bag_space_gird_count();
			if bag_space_count > 0 then
				SmallOperationModel:req_get_act_award( self.index )
				print(" 领取奖励 ");
				self:set_get_award_btn_state( SmallOperationActivityCell.BTN_STATE_DID_GET );
			else
				GlobalFunc:create_screen_notic(LangGameString[1103]); -- [1103]="背包已满，无法领奖"
			end
		end
		return true;
	end
	self.get_award_btn = MUtils:create_btn( self.view,
		UILH_COMMON.btn4_nor, 
		UILH_COMMON.btn4_nor, 
		get_award,710,22,-1,-1 );
	self.get_award_btn:addTexWithFile(CLICK_STATE_DISABLE, UILH_COMMON.btn4_dis)
	self.btn_lab = MUtils:create_zximg(self.get_award_btn, UILH_BENEFIT.lingqujiangli, 40, 15, -1, -1)
	local btn_size = self.get_award_btn:getSize()
	local lab_size = self.btn_lab:getSize()
	self.btn_lab:setPosition(btn_size.width/2 - lab_size.width/2,btn_size.height/2-lab_size.height/2+1)

	 local line = CCZXImage:imageWithFile( 10, 0, 815, 3, UILH_COMMON.split_line )     
     self.view:addChild( line )  
end

function SmallOperationActivityCell:update_btn_status( data ,sub_activity_id)
	if data == nil then
		self.get_award_btn:setCurState(CLICK_STATE_DISABLE);
	else
		if sub_activity_id == 1 or sub_activity_id == 2 or sub_activity_id == 3 or sub_activity_id == 12
			or sub_activity_id == 13 then 
			-- 是否可以领取
			local can_get_record = Utils:get_bit_by_position( data.can_get_record, self.index );
			-- 是否领取过了
			local had_get_record = Utils:get_bit_by_position( data.had_get_record, self.index );

			if can_get_record == 0 then
				-- 未达到
				self:set_get_award_btn_state( SmallOperationActivityCell.BTN_STATE_NOT_GET );
			else
				-- 已达到
				if had_get_record == 0 then
					-- 未领取
					self:set_get_award_btn_state( SmallOperationActivityCell.BTN_STATE_GET );
				elseif had_get_record == 1 then
					--已经领取
					self:set_get_award_btn_state( SmallOperationActivityCell.BTN_STATE_DID_GET );
				end

			end
		elseif sub_activity_id == 4 or sub_activity_id == 5 or sub_activity_id == 7 or sub_activity_id == 8 then
			if self.index == 1 then
				if data.can_get_record == 1 then
					self:set_get_award_btn_state( SmallOperationActivityCell.BTN_STATE_GET );
				elseif data.can_get_record == 0 then
					self:set_get_award_btn_state( SmallOperationActivityCell.BTN_STATE_NOT_GET );
				elseif data.can_get_record == 2 then
					self:set_get_award_btn_state( SmallOperatllionActivityCell.BTN_STATE_DID_GET );
				end
			end
		elseif sub_activity_id == 10 then
			-- 领取标识
			local num = data.had_get_record[self.index]
			print("领取状态 num",num)
			if num then
				if num == 0 then
					self:set_get_award_btn_state( SmallOperationActivityCell.BTN_STATE_NOT_GET );
				elseif num > 0 then
					self:set_get_award_btn_state( SmallOperationActivityCell.BTN_STATE_GET );
				end
			-- else
				-- self:set_get_award_btn_state( SmallOperationActivityCell.BTN_STATE_NOT_GET );
			end
		end
	end
end

function SmallOperationActivityCell:set_get_award_btn_state( state )
	if self.get_award_btn then
		if state == SmallOperationActivityCell.BTN_STATE_GET then
			self.btn_lab:setTexture( UILH_BENEFIT.lingqujiangli);
			--self.btn_lab:setSize(66,29);
		--	self.btn_lab:setPosition(40, 15);
			self.get_award_btn:setCurState(CLICK_STATE_UP);

		elseif state == SmallOperationActivityCell.BTN_STATE_NOT_GET then
			self.btn_lab:setTexture( UILH_BENEFIT.lingqujiangli);
			--self.btn_lab:setSize(66,29);
			--self.btn_lab:setPosition(40, 15);
			self.get_award_btn:setCurState(CLICK_STATE_DISABLE);

		elseif state == SmallOperationActivityCell.BTN_STATE_DID_GET then
			-- self.btn_lab:setTexture( UI_WELFARE.yilingqu);
		--	self.btn_lab:setSize(77,29);
		--	self.btn_lab:setPosition(35, 15);
			-- self.get_award_btn:setCurState(CLICK_STATE_DISABLE);
		end
	end
end
