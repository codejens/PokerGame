--create by jiangjinhong
--装备升级提示 通用框
--UserEquipPrompt.lua
super_class.UserEquipPrompt(Window)
function UserEquipPrompt:__init( window_name, texture_name )
	--texture = "ui/common/bg_03.png" width = 420, height = 331
	local function close_fun(eventType,x,y )
		if eventType == TOUCH_BEGAN then
			UIManager:destroy_window("user_equip_prompt_win");
			return true
		end
		return false;
	end
	local function btn_close_fun( )
		UIManager:destroy_window("user_equip_prompt_win");
	end
	self.view:setOpacity(175)
	self.view:registerScriptHandler(close_fun);
	local width = UIScreenPos.relativeWidth(1)
	local hight = UIScreenPos.relativeHeight(1)

	self.my_panel = CCBasePanel:panelWithFile( width/2,hight/2, 420,331, UIResourcePath.FileLocate.common .. "bg_03.png", 500, 500);
	self.my_panel:setAnchorPoint(0.5,0.5);
	self.view:addChild(self.my_panel);
	local function do_fun( eventType,x,y )
		return true 
	end
	self.my_panel:registerScriptHandler(do_fun);

	local exit_btn = ZButton:create(self.my_panel, UIResourcePath.FileLocate.common .. "close_btn_z.png", btn_close_fun,0,0,60,60,999);
    local exit_btn_size = exit_btn:getSize()
    local spr_bg_size = self.my_panel:getSize()

    exit_btn:setPosition( spr_bg_size.width - exit_btn_size.width +10,spr_bg_size.height - exit_btn_size.height+6 )

    self.current_skill_id = 0
    --title 
    self.title  = UILabel:create_lable_2("#cfff000装备推荐", 210, 295, 18, ALIGN_CENTER)
    self.my_panel:addChild( self.title )

end
function UserEquipPrompt:create_prompt_one(  )
	local recommend_equip = UserInfoModel:get_recomme_equip(  )
	local come_form = UserInfoModel:get_equip_come_where(  )
	self.title:setText("#c00ff00装备推荐")

	local slotItem = SlotItem(60, 60)
    slotItem:setPosition( 207,205 )
    slotItem.view:setAnchorPoint( 0.5,0.5)
    self.my_panel:addChild( slotItem.view, 999 )
    slotItem:set_icon_bg_texture( UIPIC_EQ_SLOT,  -4 ,  -4, 60+12, 60+12 )
 
    if come_form == 1 then 
	    slotItem:set_icon( recommend_equip.item_id )
	    slotItem:set_lock( recommend_equip.flag == 1 )         -- 是否绑定(锁)
	    slotItem:set_color_frame( recommend_equip.item_id, -2, -2, 68, 68 )    -- 边框颜色
	    slotItem:set_item_count( recommend_equip.count )       -- 数量
	    slotItem:set_strong_level( recommend_equip.strong )    -- 强化等级
	    slotItem:set_gem_level( recommend_equip.item_id )      -- 宝石的等级
	elseif come_form == 2 then 
		slotItem:set_icon( recommend_equip )
    	slotItem:set_color_frame( recommend_equip, -2, -2, 68, 68 )    -- 边框颜色
	end 
  
     -- 单击触发
     local function click_fn (slot_obj, eventType, arg, msgid)
     	if slotItem then 
	        local position = Utils:Split(arg,":");
	        -- 将相对坐标转化成屏幕坐标(即OpenGL坐标 800x480)
	        local pos = slotItem.view:convertToWorldSpace( CCPointMake(position[1],position[2]) );
	        if come_form == 1 then 
	       		 UserInfoModel:show_tips(  pos.x , pos.y,recommend_equip.item_id )
	       	elseif come_form == 2 then 
	       		UserInfoModel:show_tips(  pos.x , pos.y,recommend_equip)
	       	end   
    	end 
    end
    slotItem:set_click_event( click_fn )


	--道具名
    local equip_bg = CCZXImage:imageWithFile( 210, 130, 152, -1, UIResourcePath.FileLocate.common .. "wzk-2.png", 500, 500)
    self.my_panel:addChild(equip_bg)
    equip_bg:setAnchorPoint(0.5,0.5)
    local equip_id 
    if come_form ==1 then 
    	equip_id = recommend_equip.item_id
    elseif come_form == 2 then 
    	equip_id = recommend_equip
    end 
    local equip_name = ItemModel:get_item_name_with_color( equip_id )
    self.lab = UILabel:create_lable_2(equip_name, 76, 8, 16, ALIGN_CENTER)
    equip_bg:addChild(self.lab)
	
    if 	come_form == 2 then 
	    --历练值
	    local price_name, price_value = ExchangeModel:get_item_need_money( recommend_equip, "equipment" )
	    local player =EntityManager:get_player_avatar()
	    local player_lilian = player.lilian
	    local btn_text = "获取历练" 
	    local color = "#cff0000"
	    if player_lilian>=price_value then 
	    	color = "#c00ff00"
	    	btn_text = "兑  换"
	    end 
  
	    self.experience_cost = CCZXLabel:labelWithText( 27, 82, color.."消耗历练:"..price_value, 15, ALIGN_LEFT)
	    self.experience_have = CCZXLabel:labelWithText( 27, 50, color.."所持历练:"..player_lilian, 15, ALIGN_LEFT)
	    self.my_panel:addChild(self.experience_have)
	    self.my_panel:addChild(self.experience_cost)
	     --兑换或者获取历练
	    local function btn_fun(  )
	        if btn_text == "获取历练" then
	        	UIManager:destroy_window("user_equip_prompt_win") 
	        	local win = UIManager:show_window( "activity_Win")
	        	if win then 
    				win:change_page( 2 )
    			end 
	        elseif btn_text == "兑  换" then 
	        	NPCTradeCC:req_buy_exp_item(recommend_equip, 1, 0, 0, 1);
	        	UIManager:destroy_window("user_equip_prompt_win")
	        end 
	    end
	    local exchange_btn = ZButton:create( self.my_panel, 
	                                         UIResourcePath.FileLocate.common.."btn_hong.png",
	                                         btn_fun, 250,40,-1,-1);
	    local exchange_btn_lab = CCZXLabel:labelWithText( 126/2, 21, btn_text, 18, ALIGN_CENTER)
	    exchange_btn:addChild( exchange_btn_lab );
	elseif come_form == 1 then
	     --穿戴
	    local function btn_fun(  )
	        ItemCC:req_use_item (recommend_equip.series, 0)
	    end
	    local use_btn = ZButton:create( self.my_panel, 
	                                         UIResourcePath.FileLocate.common.."btn_hong.png",
	                                         btn_fun, 210-63,40,-1,-1);
	    local use_btn_lab = CCZXLabel:labelWithText( 126/2, 21, "穿  戴", 18, ALIGN_CENTER)
	    use_btn:addChild( use_btn_lab );
	end 

end
function UserEquipPrompt:create_prompt_two( )
	self.title:setText("#c00ff00升级提示")
	self.slotItem_tb = {}
	local upgrade_info = UserInfoModel:get_upgrade_equip_info(  )
	local position = {{180,196},{75,101},{285,101}}
	for i=1,3 do
		local slotItem = SlotItem(60, 60)
		local one_pos = position[i]
	    slotItem:setPosition( one_pos[1],one_pos[2] )
	    slotItem.view:setAnchorPoint( 0,0)
	    self.my_panel:addChild( slotItem.view, 999 )
	    slotItem:set_icon_bg_texture( UIPIC_EQ_SLOT,  -6 ,  -6, 60+12, 60+12 )
	     -- 单击触发
	    local function click_fn(slot_obj, eventType, arg, msgid)
	        if self.slotItem_tb[i] then 
		        local position = Utils:Split(arg,":");
		        -- 将相对坐标转化成屏幕坐标(即OpenGL坐标 800x480)
		        local pos = self.slotItem_tb[i].view:convertToWorldSpace( CCPointMake(position[1],position[2]) );
		        
		       	UserInfoModel:show_tips(  pos.x , pos.y,upgrade_info[i])
		         
	    	end 
	    end
	    slotItem:set_click_event( click_fn )
	    self.slotItem_tb[i] = slotItem
	end
	if upgrade_info[1] ~= nil then 
		for i=1,3 do
			self.slotItem_tb[i]:set_icon( upgrade_info[i] )
    		self.slotItem_tb[i]:set_color_frame( upgrade_info[i], -4, -4, 68, 68 )    -- 边框颜色
		end
	end 

	local line = CCZXImage:imageWithFile(99, 155, 224, -1,"ui/common/equip_line.png")
	local add_img = CCZXImage:imageWithFile( 194, 115, -1, -1,UIPIC_UserEquipPanel_009);
	self.my_panel:addChild(add_img)
	self.my_panel:addChild(line)

	local num_equip = UserInfoModel:get_equip_num(  )

	local now_equip = num_equip[1]
	local meta_equip = num_equip[2]
	--已装备的道具在背包中不存在 但是至少i有一个
	local now_num = now_equip[2]+1
	local equip_num_lab = UILabel:create_lable_2( now_num.."/".."1", 63, 5, 15, ALIGN_RIGHT)
	local mete_equip_num_lab = UILabel:create_lable_2( meta_equip[2].."/"..meta_equip[3], 63, 5, 15, ALIGN_RIGHT )
	self.slotItem_tb[2].view:addChild(equip_num_lab,99)
	self.slotItem_tb[3].view:addChild(mete_equip_num_lab,99)

	local function upgrade_fun(  )
		 UIManager:destroy_window("user_equip_prompt_win")
		local if_open_smelt_equip_sys = GameSysModel:isSysEnabled(GameSysModel.ENHANCED)
		if if_open_smelt_equip_sys == true then 
			local player = EntityManager:get_player_avatar()
			if player.level <40 then 
				GlobalFunc:create_screen_notic("任务等级达到40级才能升级装备")
			else
				local win = UIManager:toggle_window("forge_win")
				if win then 
					win:change_page(4)

					local item_id = upgrade_info[2]
					local useritem = UserInfoModel:get_a_equi( item_id )
					UserInfoModel:set_now_upgrade_select_equip( useritem.series )
					win:update( "select_a_equip" )
				end 
			end 
		else 
			GlobalFunc:create_screen_notic("您还没有开启炼器系统！")
		end 
		
	end

    if meta_equip[2]- meta_equip[3]<0 then 
    	--前往升级
		self.upgrade_btn= ZImageButton:create(self.my_panel, UIResourcePath.FileLocate.common.."button3.png","",upgrade_fun,42,31,-1,-1)
	    self.upgrade_btn.view:addTexWithFile(CLICK_STATE_DISABLE, UIResourcePath.FileLocate.common.."button3_d.png")
	    self.upgrade_btn_lab = UILabel:create_lable_2( "前往升级", 63, 22, 15, ALIGN_CENTER )
	    self.upgrade_btn.view:addChild(self.upgrade_btn_lab)
    	self.upgrade_btn:setCurState(CLICK_STATE_DISABLE)
	     --获得
	    local function get_btn_fun(  ) 
	    	UIManager:destroy_window("user_equip_prompt_win")
            --Instruction:handleUIComponentClick(instruct_comps.ANY_BTN)
            local win_type = 2
            local item_id = upgrade_info[3]
            ForgeDialog:show(win_type, item_id)
	    end
	    local get_btn = ZButton:create( self.my_panel, 
	                                         UIResourcePath.FileLocate.common.."button3.png",
	                                         get_btn_fun, 253,31,-1,-1);
	    local get_btn_lab = CCZXLabel:labelWithText( 63, 22, "获取材料", 15, ALIGN_CENTER)
	    get_btn:addChild( get_btn_lab );
	else 
		--前往升级
		local upgrade_btn= ZImageButton:create(self.my_panel, UIResourcePath.FileLocate.common.."button3.png","",upgrade_fun,147,31,-1,-1)
	    upgrade_btn.view:addTexWithFile(CLICK_STATE_DISABLE, UIResourcePath.FileLocate.common.."button3_d.png")
	    local upgrade_btn_lab = UILabel:create_lable_2( "前往升级", 63, 22, 15, ALIGN_CENTER )
	    upgrade_btn.view:addChild(upgrade_btn_lab)
	end 
end 
function UserEquipPrompt:update( update_type )
	if update_type == "not_have_equip" then 
  		self:create_prompt_one()
  	elseif update_type == "have_equip" then 
  		self:create_prompt_two()
  	end 
end
function UserEquipPrompt:active( act )

end 