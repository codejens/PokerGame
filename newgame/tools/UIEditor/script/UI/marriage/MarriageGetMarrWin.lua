-- MarriageGetMarrWin.lua
-- create by fjh 2013-8-19
-- 求婚窗口

super_class.MarriageGetMarrWin(Window)

function MarriageGetMarrWin:__init( window_name, texture_name, is_grid, width, height,title_text )
		
	-- 古诗句
	local lab = UILabel:create_lable_2( Lang.marriage[10], 493/2, 278, 16, ALIGN_CENTER ); -- [1485]="#cfff000谁谁谁谁谁谁#cffffff掏出一枚戒指向你求婚"
	self.view:addChild(lab);

	--求婚词
	self.marriage_lab = UILabel:create_lable_2( LangGameString[1485], 493/2, 253, 16, ALIGN_CENTER ); -- [1485]="#cfff000谁谁谁谁谁谁#cffffff掏出一枚戒指向你求婚"
	self.view:addChild(self.marriage_lab);

	-- 同意按钮
	local function agree_btn_event(  )
		-- 同意他人的求婚
		MarriageModel:req_agree_other_get_marriage(  )
		UIManager:destroy_window( "get_marriage_win" );
	end
	ZImageButton:create(self.view,UILH_MARRIAGE.btn1,UILH_MARRIAGE.woyuanyi,agree_btn_event,493/2-10-123, 95);
	-- local agree_btn = TextButton:create( nil, 83+55-13, 225, 70, 34, LangGameString[1483], UIResourcePath.FileLocate.marriage.."button.png" ); -- [1483]="#cfafed0我愿意"
	-- self.view:addChild( agree_btn.view );
	-- agree_btn:setTouchClickFun(agree_btn_event);

	-- 拒绝按钮
	local function reject_btn_event(  )
		-- 拒绝他人的求婚
		MarriageModel:req_reject_other_get_marriage(  )
		UIManager:destroy_window( "get_marriage_win" );
	end
	ZImageButton:create(self.view,UILH_MARRIAGE.btn1,UILH_MARRIAGE.jujue,reject_btn_event,493/2+10, 95);
	-- local reject_btn = TextButton:create( nil, 83+162+55, 225, 70, 34, LangGameString[1484], UIResourcePath.FileLocate.marriage.."button.png" ); -- [1484]="#cfafed0拒绝"
	-- self.view:addChild( reject_btn.view );
	-- reject_btn:setTouchClickFun(reject_btn_event);

	-- 求婚戒指
	self.marriage_ring = MUtils:create_one_slotItem( 11101, 493/2-64/2, 168, 64, 64 );
	self.marriage_ring:set_icon_bg_texture( UILH_MARRIAGE.item_bg, -4.5, -4.5, 73, 73)
	self.marriage_ring:set_color_frame(nil)
	self.view:addChild(self.marriage_ring.view);

	-- local lab = UILabel:create_lable_2( LangGameString[1486], 250, 155, 14, ALIGN_CENTER ); -- [1486]="#c33ff36山无棱,天地合,乃敢与君绝!"
	-- self.view:addChild( lab );

	-- local lab = UILabel:create_lable_2( LangGameString[1487], 250, 130, 14, ALIGN_CENTER ); -- [1487]="#c33ff36吾愿与君相守一生，君愿否？"
	-- self.view:addChild( lab );

	-- 增加关闭按钮
	local function _close_btn_fun()
		Instruction:handleUIComponentClick(instruct_comps.CLOSE_BTN)
		UIManager:hide_window("get_marriage_win")
	end
	local _exit_btn_info = { img = UILH_MARRIAGE.close_btn_big, z = 1000, width = 80, height = 80 }
	self._exit_btn = ZButton:create(self.view, _exit_btn_info.img, _close_btn_fun,0,0,_exit_btn_info.width,_exit_btn_info.height,_exit_btn_info.z);
	local exit_btn_size = self._exit_btn:getSize()
	self._exit_btn:setPosition( width - exit_btn_size.width, height - exit_btn_size.height)
end

function MarriageGetMarrWin:update( ring_id, player_name )
	
	self.marriage_ring:set_icon( ring_id );
	-- self.marriage_ring:set_color_frame(ring_id);
	self.marriage_ring:set_color_frame(nil);	-- 不显示品质框，背景框是粉色，不适合品质框显示
	
	local function show_ring_tip(obj, eventType, arg,msgid)
        local click_pos = Utils:Split(arg, ":")
        local world_pos = self.marriage_ring.view:getParent():convertToWorldSpace( CCPointMake( tonumber(click_pos[1]),tonumber(click_pos[2]) ) )

		TipsModel:show_marriage_ring( ring_id, 0, nil, world_pos.x,world_pos.y)
	end
	self.marriage_ring:set_click_event( show_ring_tip );

	self.marriage_lab:setText( "#cfff000"..player_name..LangGameString[1488] ); -- [1488]="#cffffff掏出一枚戒指向你求婚"

end
