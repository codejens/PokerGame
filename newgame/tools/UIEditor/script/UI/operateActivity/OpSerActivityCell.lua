-- OpSerActivityCell.lua
-- created by fjh 2013-5-30 
-- 开服活动的cell

super_class.OpSerActivityCell()

function OpSerActivityCell:__init( x, y, w, h , index)
	
	self.view = CCBasePanel:panelWithFile(x, y, w, h, "", 500, 500)

	local icon_img = OpenSerConfig:get_activity_icon( index )

	local split_img = CCZXImage:imageWithFile(0,4,180,68,UIResourcePath.FileLocate.common .. "pet_bg.png");
    self.view:addChild(split_img);

	self.slot_item = MUtils:create_one_slotItem( nil, 7+5, 13, 48, 48 );
	self.slot_item:set_icon_texture(icon_img);
	self.slot_item:set_select_effect_state(true);
	self.view:addChild(self.slot_item.view);
	local function touch_click(  )
		self.click_event();
	end 
 	self.slot_item:set_click_event(touch_click);

 	-- 获取主副标题
	local title_up ,title_down = OpenSerConfig:get_activity_title( index );

	local activity_title_up = UILabel:create_lable_2( "#cfff000"..title_up, 76, 36, 16, ALIGN_LEFT );
	self.view:addChild(activity_title_up);

	local activity_title_down = UILabel:create_lable_2( title_down, 76, 14, 14, ALIGN_LEFT );
	self.view:addChild(activity_title_down);




    local function click_event( eventTpye )
    	
    	if eventTpye == TOUCH_CLICK then
    		SlotEffectManager.play_effect_by_slot_item( self.slot_item );
    		self.click_event( index );
    	end
    	return true;

    end

    self.view:registerScriptHandler(click_event);
end

function OpSerActivityCell:set_click_event( fn )
	self.click_event = fn;
end

function OpSerActivityCell:play_effect(  )
	if self.slot_item then
		
		SlotEffectManager.play_effect_by_slot_item( self.slot_item );
	end
end