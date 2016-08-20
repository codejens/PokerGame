-- FBExpDialog.lua
-- created by Little White on 2014-8-22
-- 副本使用经验丹窗口

super_class.FBExpDialog(Window)

label_config_tab={ [1]= Lang.activity.fuben[19],
			[2]= Lang.activity.fuben[20],
			[3]= Lang.activity.fuben[21],
}
--[19]= "#cffff00高级经验丹:(%d)"
--[20]= "#cffff00中级经验丹:(%d)"
--[21]= "#cffff00低级经验丹:(%d)"

function FBExpDialog:__init(window_name, texture_name)
	panel = self.view

    local spr_bg = CCZXImage:imageWithFile( 0, 0, 416,331, UIPIC_ConfirmWin_001,500,500)
    panel:addChild( spr_bg )

    local bg_1 = CCBasePanel:panelWithFile(18, 71, 380, 200,UIPIC_ConfirmWin_008, 500, 500)
    panel:addChild(bg_1)
    local bg_2 = CCBasePanel:panelWithFile(28, 82, 360, 180,UIPIC_ConfirmWin_009, 500, 500)
    panel:addChild(bg_2)

    -- Lang.activity.fuben[22]="#cffff00使用经验丹进行关卡挑战!"
    self.content_text = MUtils:create_zxfont( panel,Lang.activity.fuben[22],210,238,2,18 )

    self.switch_but_t = {}          -- 存储所有选择按钮
    self:create_one_rate_but( panel, 200, 200, 100, 40, label_config_tab[1], 1 ) 
	self:create_one_rate_but( panel, 200, 150, 100, 40, label_config_tab[2], 2 ) 
	self:create_one_rate_but( panel, 200, 100, 100, 40, label_config_tab[3], 3 ) 

    local function btn_ok_fun(eventType,x,y)
        if self.selected_fbId and self.current_rate_index then
            -- local str_exp = string.format("useFubenAddExpItem,%d",self.exp_medicine_info[self.current_rate_index].itemId)
            -- GameLogicCC:req_talk_to_npc( 0, str_exp)

            print("self.selected_fbId,self.exp_medicine_info[self.current_rate_index].itemId",self.selected_fbId,self.exp_medicine_info[self.current_rate_index].itemId)
            local str_enter = string.format("OnEnterFubenFunc,%d,%d",self.selected_fbId,self.exp_medicine_info[self.current_rate_index].itemId)
            GameLogicCC:req_talk_to_npc( 0, str_enter)

            UIManager:destroy_window("fb_exp_win")
        end 
        return true
    end

 	local window_size = self.view:getSize()
    --Lang.common.confirm[0] = "确定"
    self.btn1=ZTextButton:create(panel,Lang.common.confirm[0],UIPIC_COMMOM_002, btn_ok_fun, 55,17,-1,-1, 1)

    local function btn_cancel_fun(eventType,x,y)
        print("self.selected_fbId",self.selected_fbId)
        if self.selected_fbId then
            local  str = string.format("OnEnterFubenFunc,%d",self.selected_fbId)
            GameLogicCC:req_talk_to_npc( 0, str)
            UIManager:destroy_window("fb_exp_win")
        end
        return true
    end
    --[23] = "不使用"
    self.btn1=ZTextButton:create(panel,Lang.activity.fuben[23],UIPIC_COMMOM_002, btn_cancel_fun, 230,17,-1,-1, 1)

    -- title
    self.window_title = CCZXImage:imageWithFile( 0, 0, -1, -1, UIPIC_ConfirmWin_007)
    self.window_title:setAnchorPoint( 0.5, 0 )   
    self.window_title:setPosition( window_size.width / 2, window_size.height - 37 )
    self:addChild( self.window_title )
end

-- 创建单个次数选择控件
function FBExpDialog:create_one_rate_but( panel, x, y, w, h, content,index )
	local switch_but = nil              -- 单个开关控件对象. 调用create_switch_button方法创建后才是对象
    
	local function callback_fun(  )
		self:choose_one_but( switch_but )
	end

    local interval_x = 100
    local interval_y = 15

	switch_but = UIButton:create_switch_button( x + interval_x, y - interval_y, w, h, UIPIC_Secretary_019, UIPIC_Secretary_020, "", 0, 18, nil, nil, nil, nil, callback_fun )
	switch_but.label = MUtils:create_zxfont( panel,content,x,y,2,16)

    panel:addChild( switch_but.view )
    switch_but.index = index
    self.switch_but_t[index] = switch_but
	return switch_but
end

-- 实现经验按钮的单选  参数：一个 按钮对象（由FBSweepDialog:create_one_rate_but 创建的按钮）
function FBExpDialog:choose_one_but( switch_but )
	for key, but in ipairs(self.switch_but_t) do
        but.set_state( false )
	end
    self.current_rate_index = switch_but.index    -- 当前选中的单选序列号
	switch_but.set_state( true )
    print("FBExpDialog:choose_one_but(self.exp_medicine_info[self.current_rate_index].itemId)",self.exp_medicine_info[self.current_rate_index].itemId)
end

function FBExpDialog:show(exp_medicine_info,selected_fbId)
	local win = UIManager:show_window("fb_exp_win")
	if win then
		win:update_content(exp_medicine_info,selected_fbId)
	end
end

function FBExpDialog:update_content(exp_medicine_info,selected_fbId)
    print("FBExpDialog:update_content(exp_medicine_info,selected_fbId)",exp_medicine_info,selected_fbId)
	if exp_medicine_info then
		self.exp_medicine_info = exp_medicine_info
        for i=1,#self.switch_but_t do
            local str = string.format(label_config_tab[i],exp_medicine_info[i].count)
            self.switch_but_t[i].label:setText(str)
            -- 默认勾选最高级
            if exp_medicine_info[i].count > 0 then
                if i == 1 then
                    self:choose_one_but(self.switch_but_t[i])
                else
                    if self.current_rate_index == nil then
                        self:choose_one_but(self.switch_but_t[i])
                    end 
                end 
            end 
        end
	end 

    if selected_fbId then
        self.selected_fbId = selected_fbId
    end 
end

function FBExpDialog:active(show)
    if self.exit_btn then
        self.exit_btn:setPosition(363,278)
    end 
end