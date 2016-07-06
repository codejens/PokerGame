--TaskWin.lua
--create by tjh on 2015/5/25
--任务对话窗口

TaskWin = simple_class(GUIWindow)

function TaskWin:__init( view )
	self.content_text = nil
	self.btn = nil
end

--测试 先自己创建 以后用stduio
function TaskWin:create(  )
	local bg = GUIPanel:create9Img(_PATHE_COMMON_BG_IMG)
	bg:setContentSize(400,300)
	local win = self(bg.view)
	if win then
		win:viewCreateCompleted(  )
	end
	return win
end

function TaskWin:viewCreateCompleted(  )

	self.btn = GUIButton:create(_PATH_COMMON_BTN_NORMAL,_PATH_COMMON_BTN_PRESS)
	self.btn:setPosition(200,50)
	self.view:addChild(self.btn.view)

	local function click_func( ... )
		GUIManager:hide_window("task")
	end 

	self:addCLickEventListener(click_func)
end


function TaskWin:update( date_t )

	self.btn:setVisible(true)
	print("date_t.state",date_t.state)
	self:update_content(date_t.content)
	if date_t.state == TaskCC.ACCEPT_TASK then
		self.btn:setTitleText("接受任务")
	elseif date_t.state == TaskCC.FINISH_TASK then
		self.btn:setTitleText("完成任务")
	elseif date_t.state == TaskCC.TALK_TASK then
		self.btn:setVisible(false)
	elseif date_t.state == TaskCC.CHOOSE_TASK then

	end
end

function TaskWin:update_content( str )
	if self.content_text then
		self.content_text:removeFromParent(true)
	end

	self.content_text = GUIRichText:create(str,cc.size(300,0))
	self.content_text:setPosition(180,200)
	self.view:addChild(self.content_text.view)

end