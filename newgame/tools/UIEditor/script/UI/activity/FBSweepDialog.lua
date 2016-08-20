-- FBSweepDialog.lua
-- created by Little White on 2014-8-21
-- 副本扫荡窗口

super_class.FBSweepDialog(Window)

function FBSweepDialog:__init(window_name, texture_name)

	panel = self.view

    self.label_display_count = 0

    local spr_bg = CCZXImage:imageWithFile( 0, 0, 416,331, UIPIC_ConfirmWin_001,500,500)
    panel:addChild( spr_bg )

    local bg_1 = CCBasePanel:panelWithFile(18, 71, 380, 200,UIPIC_ConfirmWin_008, 500, 500)
    panel:addChild(bg_1)
    local bg_2 = CCBasePanel:panelWithFile(28, 82, 360, 180,UIPIC_ConfirmWin_009, 500, 500)
    panel:addChild(bg_2)

    self.content_text = MUtils:create_zxfont( panel, "测试1",210,230,2,18 )

    -- self.switch_but_t = {}          -- 存储所有选择按钮
    -- self:create_one_rate_but( panel, 80, 135, 100, 40, LangGameString[2468], 1 ) -- [2468]="#cffff00 1次"
	-- self:create_one_rate_but( panel, 180, 135, 100, 40, LangGameString[2469], 2 ) -- [2469]="#cffff00 2次"
	-- self:create_one_rate_but( panel, 280, 135, 100, 40, LangGameString[2470], 3 ) -- [2470]="#cffff00 3次"

    local begin_x = 70 
    local begin_y = 190 
    local interval_x = 150
    local interval_y = 30

    self.label_tab = {}
    self:create_a_label(panel,"测试1",begin_x + interval_x*0,begin_y - interval_y * 0,1,17)
    self:create_a_label(panel,"测试2",begin_x + interval_x*0,begin_y - interval_y * 1,1,17)
    self:create_a_label(panel,"测试3",begin_x + interval_x*0,begin_y - interval_y * 2,1,17)
    self:create_a_label(panel,"测试4",begin_x + interval_x*0,begin_y - interval_y * 3,1,17)
    self:create_a_label(panel,"测试5",begin_x + interval_x*1,begin_y - interval_y * 0,1,17)
    self:create_a_label(panel,"测试6",begin_x + interval_x*1,begin_y - interval_y * 1,1,17)
    self:create_a_label(panel,"测试7",begin_x + interval_x*1,begin_y - interval_y * 2,1,17)
    self:create_a_label(panel,"测试8",begin_x + interval_x*1,begin_y - interval_y * 3,1,17)

    local function btn_ok_fun(eventType,x,y)
        if self.fuben_info then
            EntrustCC:request_sweep_fuben(self.fuben_info.fbListId)
        end 
    	UIManager:hide_window("fb_sweep_win")
        return true
    end
    
    self.btn1=ZTextButton:create(panel,"确定",UIPIC_COMMOM_002, btn_ok_fun, 55,17,-1,-1, 1)

    local function btn_cancel_fun(eventType,x,y)
    	UIManager:hide_window("fb_sweep_win")
        return true
    end
    self.btn2=ZTextButton:create(panel,"取消",UIPIC_COMMOM_002, btn_cancel_fun, 230,17,-1,-1, 1)

    local spr_bg_size = self.view:getSize()

    -- title
    self.window_title = CCZXImage:imageWithFile( 0, 0, -1, -1, UIPIC_ConfirmWin_007)
    self.window_title:setAnchorPoint( 0.5, 0 )
    local window_size = self.view:getSize()
    self.window_title:setPosition( window_size.width / 2, window_size.height - 37 )
    self:addChild( self.window_title )
end

-- 创建单个次数选择控件
function FBSweepDialog:create_one_rate_but( panel, x, y, w, h, content,index )
	local switch_but = nil               -- 单个开关控件对象. 调用create_switch_button方法创建后才是对象
    
	local function callback_fun(  )
		self:choose_one_but( switch_but )
	end

    local font_x = 35
	switch_but = UIButton:create_switch_button( x, y, w, h, UIPIC_Secretary_019, UIPIC_Secretary_020, content, font_x, 18, nil, nil, nil, nil, callback_fun )

    panel:addChild( switch_but.view )
    switch_but.index = index
    self.switch_but_t[index] = switch_but
	return switch_but
end


function FBSweepDialog:create_a_label(panel,str,pos_x,pos_y,align,font_size)
    local lab = MUtils:create_zxfont(panel,str,pos_x,pos_y,align,font_size)
    table.insert(self.label_tab,lab)
end 

-- 实现倍率按钮的单选  参数：一个 按钮对象（由FBSweepDialog:create_one_rate_but 创建的按钮）
function FBSweepDialog:choose_one_but( switch_but )
	for key, but in pairs(self.switch_but_t) do
        but.set_state( false )
	end
    self.current_rate_index = switch_but.index    -- 当前选中的倍率序列号
	switch_but.set_state( true )
end

function FBSweepDialog:show( fuben_info,fuben_config_data)
	local win = UIManager:show_window("fb_sweep_win")
	if win then
		win:update_content(fuben_info,fuben_config_data)
	end
end

function FBSweepDialog:update_content(fuben_info,fuben_config_data)
	if fuben_info then
        self.fuben_info = fuben_info
		-- LangGameString[2467]="确定委托%s么?"
		self.content_text:setText(string.format("#cfff000"..LangGameString[2467],fuben_config_data.fuben_name))

        for i=1,#self.label_tab do
            if i > fuben_info.available_progress then
                self.label_tab[i]:setIsVisible(false)
            else
                local sub_data = FubenConfig:get_fuben_info_by_id( fuben_info.fubenId_list[i] )
                local sub_remainCount = 0

                if i > fuben_info.progress and fuben_info.progress~=0 then
                    sub_remainCount = fuben_info.sub_list[1].remainCount + 1
                else
                    sub_remainCount = fuben_info.sub_list[1].remainCount
                end 

                local str = "#cfff000"..sub_data.fbname.."×"..sub_remainCount  
                self.label_tab[i]:setText(str) 

                -- label重排
                local begin_x = 70 
                local begin_y = 190 
                local interval_x = 150
                local interval_y = 30

                if sub_remainCount ~= 0 then
                    if self.label_display_count < 4 then
                        self.label_tab[i]:setPosition(begin_x + interval_x*0,begin_y - interval_y * self.label_display_count)
                    else
                        self.label_tab[i]:setPosition(begin_x + interval_x*1,begin_y - interval_y * (self.label_display_count-4))
                    end 
                    self.label_display_count = self.label_display_count + 1
                    self.label_tab[i]:setIsVisible(true)
                else
                    self.label_tab[i]:setIsVisible(false)
                end 
            end 
        end
	end 
end

function FBSweepDialog:active(show)
    if self.exit_btn then
        self.exit_btn:setPosition(363,278)
    end 
end

function FBSweepDialog:destory()
    Window:destory(self)
end