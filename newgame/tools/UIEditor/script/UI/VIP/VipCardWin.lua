-- VipCardWin.lua 
-- created by MWY on 2014-7-24
-- vip体验卡

super_class.VipCardWin(NormalStyleWindow)

function VipCardWin:active( show )
	if show then
		-- AIManager:pause()
		self:update()
	else
		-- AIManager:resume()
	end
end

function VipCardWin:__init(window_name, texture_name, is_grid, width, height)
	local vip_info_bg = CCBasePanel:panelWithFile( 15, 80, 400, 265, UILH_COMMON.bottom_bg, 500, 500 )
    self.view:addChild(vip_info_bg)
    local text_bg = ZImage:create(self.view, UILH_NORMAL.title_bg4, 85, 200, 270, -1, 0, 500, 500)
    local text = ZLabel:create(text_bg.view, Lang.vipcard[1], 138, 9, 16, 2)
    local tips = ZImage:create(self.view, UILH_VIPCARD.explain, 140, 170, -1, -1)
 --    local down_bg = CCBasePanel:panelWithFile( 28, 16, 380,268, UIPIC_GRID_nine_grid_bg3, 500, 500 )
 --    self.view:addChild(down_bg)

 --    local top_bg = CCBasePanel:panelWithFile( 10, 100, 360,158, "", 500, 500 )
 --    down_bg:addChild(top_bg)

 --    -- 物品ID VIP3体验卡的物品id：19002
    self.item_icon =  MUtils:create_slot_item(self.view,UILH_COMMON.slot_bg,181,250,83,83,48200);
    self.item_icon:set_color_frame()

    local ccdialogEx = MUtils:create_ccdialogEx(self.view,Lang.vipcard[2],135,160,225,100,99,16);
    ccdialogEx:setLineEmptySpace(10)
	ccdialogEx:setAnchorPoint(0,1.0);
	-- self.item_icon.view:setScale(1.1)
 --    --vip说明
 --    ZImage:create(down_bg, "ui/vipcard/exp_explain.png", 50, 170, -1, -1)

 --    --Vip连接
 --     ZImage:create(down_bg,"ui/vipcard/exp_link.png" , 93, 120, -1, -1)

 --    --链接按钮
 --    local function link_fun( event_type,args,msgid)
	-- 	if event_type == TOUCH_CLICK then
	-- 		UIManager:hide_window("vip_card_win")
	-- 		UIManager:show_window("vipSys_win")
	-- 	end
	-- 	return true;
	-- end
	-- MUtils:create_btn(down_bg,"",nil,link_fun,86,110,220,60)

    --
    local function fucking_fun()
    	Instruction:handleUIComponentClick(instruct_comps.ANY_BTN)
		ItemModel:use_item_by_item_id(48200)
		UIManager:hide_window("vip_card_win")
	end
	self.fucking_btn   = ZButton:create(self.view, UILH_NORMAL.special_btn, fucking_fun, 140, 20, -1, -1)
	self.fucking_btn:addImage(CLICK_STATE_DISABLE, UILH_NORMAL.special_btn_d)
	self.fucking_btn.view:setCurState(CLICK_STATE_UP)

	self.fucking_lab = ZImage:create(self.fucking_btn, UILH_VIPCARD.get, 42, 13, -1, -1)

	local function close_fun( )
		Instruction:handleUIComponentClick(instruct_comps.ANY_BTN)
		UIManager:hide_window("vip_card_win")
	end
	self:setExitBtnFun(close_fun)
end


function VipCardWin:update()
	local vip_exp_time = VIPModel:get_expe_vip_time()
	if vip_exp_time > 0 then
		self:update_btn_state( false )
	else
		self:update_btn_state( true )
	end
end

function VipCardWin:update_btn_state( enable )
	if enable then
		self.fucking_btn.view:setCurState(CLICK_STATE_UP)
		-- self.fucking_lab.view:setTexture("ui/vipcard/exp_btn_n.png")
	else
		self.fucking_btn.view:setCurState(CLICK_STATE_DISABLE)
		-- self.fucking_lab.view:setTexture("ui/vipcard/exp_btn_s.png")
	end
end