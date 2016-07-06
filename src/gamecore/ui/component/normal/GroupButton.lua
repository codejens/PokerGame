-----------------------------------------------------------------------------
-- 组选控件
-- @author tjh
-- @release 1
-----------------------------------------------------------------------------

--!class GroupButton
GroupButton = simple_class()

--================================
--- 构造函数
-- @param bt_table  一个由按钮组成的数组table
-- @param callback: 按钮回调 参数返回一个索引
-- @param selecet_img: 选中时要显示的九宫格图片
-- @param rect:构建九宫格的rect 默认rect ={10,10,10,10}
function GroupButton:__init( bt_table,callback,selecet_img,rect )
	self.selecet_img = {}
	self.currselect = nil;
	for i=1,#bt_table do
		self.selecet_img[i] = GUIImg:create9Img( selecet_img,rect )
		local size = bt_table[i]:getContentSize()
		self.selecet_img[i]:setPosition(size.width/2,size.height/2)
		self.selecet_img[i]:setContentSize(size)
		self.selecet_img[i]:setVisible(false)
		bt_table[i]:addChild(self.selecet_img[i].view)
		local function touchEvent(sender,eventType  )
			if eventType == ccui.TouchEventType.ended then
				callback(i)
				self.currselect:setVisible(false)
				self.currselect = self.selecet_img[i]
				self.currselect:setVisible(true)
			end
		end
		bt_table[i]:addTouchEventListener(touchEvent)
	end
	self.currselect = self.selecet_img[1]
	self.currselect:setVisible(true)
end
--- 设置选中图片大小函数
-- @param width,height 宽，高
function GroupButton:set_select_size( width,height )
	for i=1,#self.selecet_img do
		self.selecet_img[i]:setContentSize(width,height)
	end
end