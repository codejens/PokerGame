-- OpenBoxDialog.lua
-- created by hcl on 2013/11/26
-- 开箱子的提示对话框

local YS_ITEM_ID = 64713;

super_class.OpenBoxDialog(Window)

function OpenBoxDialog:show( item_series )
	local win = UIManager:show_window("openbox_dialog")
	if win then
		win:init_with_args( item_series );
	end
end

function OpenBoxDialog:__init(window_name, texture_name)
	 local spr_bg = CCBasePanel:panelWithFile( 0, 0, 430, 230, "", 120,88,120,88,120,74,120,74 );
	 self.view:addChild( spr_bg );

   spr_bg:addChild( CCZXImage:imageWithFile( 10, 72, 420, 195, UILH_COMMON.bottom_bg, 500, 500 ) )


    local function btn_ysdk_fun(eventType,x,y)
        if eventType == TOUCH_CLICK then
        	UIManager:destroy_window("openbox_dialog")
      		OpenBoxWin:show(2,self.item_series);
        end
        return true;
    end
   	self.ys_open_btn = MUtils:create_btn(spr_bg,UILH_NORMAL.special_btn,UILH_NORMAL.special_btn,btn_ysdk_fun,30,13,-1,-1);
    self.ys_open_btn:addTexWithFile(CLICK_STATE_DISABLE, UILH_NORMAL.special_btn_d)
    -- MUtils:create_sprite(self.ys_open_btn,UILH_OPENBOX.t_xydj,53 ,20.5 );

    local open_btn_txt = CCZXImage:imageWithFile( 53, 20, -1, -1, UILH_OPENBOX.t_yskq ) 
    self.ys_open_btn:addChild(open_btn_txt)
    local open_btn_size = self.ys_open_btn:getSize()
    local open_txt_size = open_btn_txt:getSize()
    open_btn_txt:setPosition(open_btn_size.width/2-open_txt_size.width/2,open_btn_size.height/2-open_txt_size.height/2)



    local function btn_stzk_fun(eventType,x,y)
        if eventType == TOUCH_CLICK then
        	UIManager:destroy_window("openbox_dialog")
      		OpenBoxWin:show(1,self.item_series);
        end
        return true;
    end
   	local btn1 = MUtils:create_btn(spr_bg,UILH_NORMAL.special_btn,UILH_NORMAL.special_btn,btn_stzk_fun,250,13,-1,-1);
    local btn_txt = CCZXImage:imageWithFile( 53, 20, -1, -1, UILH_OPENBOX.t_zkxz ) 
    btn1:addChild(btn_txt)
    local btn_size = btn1:getSize()
    local txt_size = btn_txt:getSize()
    btn_txt:setPosition(btn_size.width/2-txt_size.width/2,btn_size.height/2-txt_size.height/2)


    local dialog = ZDialog:create(spr_bg,"#cd0cda2使用神秘钥匙开启有更高的几率获得更多稀有道具,是否消耗1把神秘钥匙开启?",23,250,400,40,17);
    dialog.view:setAnchorPoint(0,1.0)

    local slot_item = MUtils:create_slot_item(spr_bg,UILH_COMMON.slot_bg,175,120,84,84,YS_ITEM_ID);
    -- slot_item.view:setScale(48/62);
    self.ys_count = ZLabel:create(spr_bg,"999/1",218,95,16,2);
end

function OpenBoxDialog:init_with_args( item_series )
	self.item_series = item_series;
	local ys_count = ItemModel:get_item_count_by_id( YS_ITEM_ID );
	if ys_count > 0 then
		self.ys_open_btn:setCurState( CLICK_STATE_UP )
		self.ys_count:setText(ys_count.."/1");
	else
		self.ys_open_btn:setCurState( CLICK_STATE_DISABLE )
		self.ys_count:setText("#cff66cc"..ys_count.."/1");
	end

end

