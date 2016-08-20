----HJH
----2013-1-10
------------------聊天表情栏
super_class.ChatFaceWin(Window)
------------------
local scrollInfo = { texture = UILH_COMMON.up_progress2 }
local backinfo = { texture = UILH_COMMON.bg_02}
function ChatFaceWin:create_face(width, height)
	------------------
	-- require "UI/component/Scroll"
	-- require "UI/component/Button"
	-- require "UI/component/Image"
	-- require "model/ChatModel/ChatFaceModel"
	------------------
	local scroll_info = {reserveSize = 14, width = 0, gapSize = 20, maxnum = 3, pageItemNum = 10, ttype = TYPE_VERTICAL_EX }
	scroll_info.width = width - scroll_info.reserveSize * 2
	local exit_info	 = {width = 50, height = 50, image = UILH_COMMON.close_btn_z }
	-- ------------------退出按钮
	self.exit_btn = ZButton:create( self.view, exit_info.image, ChatFaceModel.exit_btn_fun, 0, 0, 50, 50)
	local exit_size = self.exit_btn:getSize()
	exit_info.width = exit_size.width
	exit_info.height = exit_size.height
	self.exit_btn:setPosition( width - exit_size.width, height - exit_size.height)
	--self.exit_btn:setTouchClickFun()
	------------------滑动条对象
	self.scroll = ScrollPage:create( nil, scroll_info.reserveSize, 0, scroll_info.width, height - exit_info.height, scroll_info.maxnum, scroll_info.ttype, scroll_info.gapSize)
	self.scroll.view:setLimitSize(8)
	--self.scroll:setScrollRunType(RUN_TYPE_PAGE)
	self.scroll:setScrollCreatFunction(ChatFaceModel.scroll_create_fun)
	self.scroll.view:setScrollLump( scrollInfo.texture, (width - scroll_info.reserveSize * 2) / 3, 10 )
	self.scroll.view:setScrollLumpPos(0.5)
	--self.scroll:initLocatePoint("ui/common/common_toggle_n.png", "ui/common/common_toggle_s.png", 22, 22, 10)
	--self.scroll.view:setScrollLump("ui/common/common_progress.png",20, 10)
	------------------底图
	self.bg = ZImage:create( nil, backinfo.texture, 4, 0, width - 8, height - exit_info.height, nil, 600, 600)
	------------------
	self.view:addChild(self.bg.view)
	self.view:addChild(self.scroll.view)
	-- 左右箭头
	local left_arrow = ZImage:create(self.view, UILH_COMMON.scrollbar_up2, scroll_info.reserveSize-9, 0.5, -1, -1)
	local right_arrow = ZImage:create(self.view, UILH_COMMON.scrollbar_down2, scroll_info.reserveSize+scroll_info.width, 0.5, -1, -1)
	-- self.view:addChild(self.exit_btn.view)
end
------------------
function ChatFaceWin:__init(window_name, texture_name, is_grid, width, height )
	self:create_face(width, height)
	self:setTouchBeganReturnValue(false)
	self:setTouchEndedReturnValue(false)
	self.view:setDefaultMessageReturn(false)
end
------------------设置退出按钮显隐
function ChatFaceWin:set_exit_btn_visible(hide)
	-- print("ChatFaceWin:set_exit_btn_visible",self.exit_btn)
	if self.exit_btn ~= nil then
		self.exit_btn.view:setIsVisible(hide)
	end
end
------------------取得滑动条信息
function ChatFaceWin:get_scroll_info()
	if self.scroll ~= nil then
		local scrollSize = self.scroll:getSize()
		local scrollMaxNum = self.scroll:getMaxNum()
		local info = {width = scrollSize.width, height = scrollSize.height, maxNum = scrollMaxNum}
		return info
	end
end
------------------消除当前滑动条内容
function ChatFaceWin:clear_scroll()
	if self.scroll ~= nil then
		self.scroll:clear()
	end
end
------------------刷新当前滑动条内容
function ChatFaceWin:refresh_scroll()
	if self.scroll ~= nil then
		self.scroll:refresh()
	end
end
------------------
function ChatFaceWin:active(show)
	if show then
		local face_type = ChatFaceModel:get_chat_face_type()
		local need_refresh = ChatFaceModel:get_need_clear_and_refresh()
		if self.scroll.view:getCurPageNum() <= 0 or need_refresh == true then
			print("run refresh chat face win ------------------")
			self.scroll.view:clear()
			self.scroll.view:refresh()
		end
	end
end