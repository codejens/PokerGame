----------------------------
----HJH
----2013-9-2
----normal dialog show text only
super_class.NoticDialog(Window)
----------------------------
function NoticDialog:__init( window_name, texture,grid,width,height )
	self.title = ImageImage:create( nil, 0, 0, width, 22, texture, nil, 600, 600 )
	self:addChild( self.title.view )
	local title_size = self.title.view:getSize()
	self.title.view:setPosition( (width - title_size.width ) / 2, height - title_size.height - 10 )
	local title_pos = self.title.view:getPositionS()
	self.dialog = Dialog:create( nil, 15, title_pos.y - 10, width - 30, height - 55, ADD_LIST_DIR_UP, 99999999 )
	self.dialog.view:setAnchorPoint( 0, 1 )
	self:addChild( self.dialog.view )
end
----------------------------
function NoticDialog:show(info)
	local win = UIManager:show_window("notic_dialog", true)
	win.dialog.view:setText( info )
end