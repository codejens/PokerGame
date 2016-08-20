-----friendcelebratescroll.lua
-----HJH
-----2013-8-13
-----------
super_class.FriendCelebrateScroll(NormalStyleWindow)

local _ui_width = GameScreenConfig.ui_screen_width 
local _ui_height = GameScreenConfig.ui_screen_height

---------------------------
local function create_page(self, width, height)
	-- local bg = ZImage:create( nil, UIResourcePath.FileLocate.common .. "bg_blue.png", 0, 0, width, height, nil, 600, 600 )
	-- self:addChild( bg.view )
	local bg_1 = CCBasePanel:panelWithFile(20, 26, 380, 240,UILH_COMMON.normal_bg_b2, 500, 500)
    self:addChild(bg_1)
    local bg = CCBasePanel:panelWithFile(28, 100, 364, 224-70,UILH_COMMON.bottom_bg, 500, 500)
    self:addChild(bg)
	---------------------------------
	-- local spr_bg_size = self.view:getSize()
	-- self.window_title = ZImage:create( self.view, UILH_COMMON.title_tips, spr_bg_size.width/2,  spr_bg_size.height-29, -1,-1,999 );
	-- self.window_title.view:setAnchorPoint(0.5,0.5)

	-- local exit_btn = ZButton:create( nil, { UIPIC_COMMOM_008, UIPIC_COMMOM_008 }, nil, 0, 0, -1, -1  )
	-- local exit_btn_size = exit_btn:getSize()
	-- exit_btn:setPosition( 373, 288 )
	-- self:addChild( exit_btn.view )
	-- exit_btn:setTouchClickFun( FriendCelerbrateModel.ignore_all )
	self:setExitBtnFun(FriendCelerbrateModel.ignore_all)
	---------------------------------
	--xiehande 通用按钮修改 btn_lv->button3
	local accept_all = ZTextButton:create( nil, Lang.friend.common[2], UILH_COMMON.btn4_nor , nil, 44, 40, -1, -1) -- [2]="全部祝贺"
	self:addChild( accept_all.view )
	accept_all:setTouchClickFun( FriendCelerbrateModel.celerbrate_all )
	  --xiehande 通用按钮  btn_hong.png ->button3
	local cancel_all = ZTextButton:create( nil, Lang.chat.private[7], UILH_COMMON.btn4_nor , nil, 0, 0, -1, -1) -- [7]="全部忽略"
	local cancel_all_size = cancel_all:getSize()
	cancel_all:setPosition( 244, 40 )
	self:addChild( cancel_all.view )
	cancel_all:setTouchClickFun( FriendCelerbrateModel.ignore_all )
	local cancel_all_size = cancel_all.view:getSize()
	---------------------------------
	self.scroll = ZScroll:create( nil, nil, 58, 114, 295, 130, 30, TYPE_HORIZONTAL )
	self:addChild( self.scroll.view )
	---------------------------------
	local function scroll_fun(self, index)
		local temp_info = FriendCelerbrateModel:get_index_celerbrate_info(index + 1)
		print("index, temp_info, temp_info.name", index, temp_info, temp_info.name)
		if temp_info == nil then
			return nil
		end
		local base_panel = ZBasePanel:create( nil, nil, 0, 0, 295, 130 / 3)
		local base_panel_size = base_panel:getSize()
		local label = ZLabel:create( nil, string.format(Lang.friend.celebrate[4], temp_info.name), 0, 0 ) -- [4]="%s的祝贺"
		local label_size = label:getSize()
		label:setPosition( 20, ( base_panel_size.height - label_size.height ) / 2 )
		local button = ZTextButton:create( nil, Lang.chat.private[6], UIPIC_COMMON_BUTTON_003, nil, 0, 0, 96, 43) -- Lang.chat.private[6]="查看"
		local button_size = button:getSize()
		button:setPosition( base_panel_size.width - button_size.width - 10, ( base_panel_size.height - button_size.height ) / 2 )
		base_panel.view:addChild(label.view)
		base_panel.view:addChild(button.view)
		local function check_fun()
			local id = temp_info.role_id
			FriendCelerbrateModel:open_friend_celerbrate(id)
		end
		button:setTouchClickFun( check_fun )
		local line = ZImage:create( nil, UILH_COMMON.split_line , 0, 0, 295, 2)
		base_panel.view:addChild( line.view )
		return base_panel
	end
	self.scroll:setScrollCreatFunction( scroll_fun )
end
---------------------------
function FriendCelebrateScroll:__init(window_name, texture_name, is_grid, width, height)
	create_page(self, width, height)
	self.view:setAnchorPoint(0.5, 0.5)
	self.view:setPosition(_ui_width/2 , _ui_height/2)
end
---------------------------
function FriendCelebrateScroll:active(show)
	if show then
		local num = FriendCelerbrateModel:get_friend_celerbrate_info_num()
		print("FriendCelebrateScroll:active num", num)
		self.scroll:setMaxNum(num)
		self.scroll.view:reinitScroll()
		self.scroll:refresh()
	else
		FriendCelerbrateModel:ignore_all()
	end
end
