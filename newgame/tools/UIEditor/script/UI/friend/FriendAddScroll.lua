-----friendaddscroll.lua
-----HJH
-----2013-8-13
-----------
super_class.FriendAddScroll(Window)
---------------------------------
local function create_page( self, width, height )
	---------------------------------
	-- local exit_btn = ZButton:create( nil, { UIPIC_COMMOM_008, UIPIC_COMMOM_008 }, nil, 0, 0, -1, -1 )
	-- self:addChild( exit_btn.view )

	local accept_all = TextButton:create( nil, 25, 20, -1, -1, Lang.friend.common[2], UIPIC_COMMON_BUTTON_001 ) -- [2]="全部祝贺"
	self:addChild( accept_all.view )

	local cancel_all = TextButton:create( nil, 0, 0, -1, -1, Lang.chat.private[7], UIPIC_COMMON_BUTTON_001 ) -- [7]="全部忽略"
	self:addChild( cancel_all.view )
	local cancel_all_size = cancel_all.view:getSize()
	---------------------------------
	self.scroll = Scroll:create( nil, 20, 20 + cancel_all_size.height, 295, 130, 30, TYPE_HORIZONTAL )
end
---------------------------------
function FriendAddScroll:__init(window_name, texture_name, is_grid, width, height)
	create_page(self, width, height)
end
