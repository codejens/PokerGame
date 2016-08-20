-- BlueDiamondWin.lua
-- create by hcl on 2013-12-13
-- 蓝钻贵族界面 
----------------------------------
super_class.BlueDiamondWin(Window)
----------------------------------
function BlueDiamondWin:__init(  )	
	local self_size = self:getSize()
	self:create_close_btn_and_title();
	self.btn_table = {};
	-- 道具和按钮
	-- for i=1,5 do
	-- 	local x = 24 + (i-1)*87;
	local function btn_fun()
		OnlineAwardCC:server_get_blue_activity_award()
	end
	MUtils:create_slot_item(self.view,"", ( self_size.width - 62 ) / 2 - 4, 186 - 4, 62, 62, 64730);
	self.btn_table = ZButton:create(self.view,"ui/qqvip/lzgz_lq.png",btn_fun);
	local btn_table_size = self.btn_table:getSize()
	self.btn_table:setPosition( ( self_size.width - btn_table_size.width ) / 2, 140 )
	--end
	-- 倒计时
	self.timer_lab = TimerLabel:create_label(self.view, 200, 295, 14, 0);
	-- 充值蓝钻按钮
	local function blue_diamond_btn()
		if QQVipInterface.QQVipInterface_Get_Platform_QQvip_Recharge_Url_Function then
			local temp_url = QQVipInterface.QQVipInterface_Get_Platform_QQvip_Recharge_Url_Function()
			phoneGotoURL(temp_url) 
		end
	end
	ZButton:create(self.view,"ui/qqvip/lzgz_ktlz.png",blue_diamond_btn,146,20)
end
----------------------------------
function BlueDiamondWin:create_close_btn_and_title()

    local function close_fun(event_type,args,msgid )
        if event_type == TOUCH_CLICK then
            UIManager:destroy_window("blue_diamond_win");
        end
        return true
    end
    MUtils:create_btn(self.view,"ui/loginaward/b_close.png",nil,close_fun,420,360,-1,-1)

end
----------------------------------
function BlueDiamondWin:update_all( item_tab )

end
----------------------------------
function BlueDiamondWin:destroy(  )
	if self.timer_lab then 
		self.timer_lab:destroy();
		self.timer_lab = nil;
	end
	Window.destroy(self);
end
----------------------------------
function BlueDiamondWin:active(show)
	if show then
		self.timer_lab:setText(QQBlueDiamonTimeAwardModel:get_remian_time())
	end
end
