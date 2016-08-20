--SEditBox.lua
--create by tjh on 2015.7.13
--输入框控件

SEditBox = simple_class(STouchBase)

function SEditBox:__init( view,layout )
	STouchBase.__init(self,view,layout)
end

--创建输入框控件函数
--@param width, height 宽高
--@param bg_img 背景图片 
--@param tMaxNum文字最大数 可选 默认EDIT_NUM_MIN 参考SWidgetConfig
--@param tFontSize字体大学 可选 默认FONT_DEF_SIZE 参考SWidgetConfig
function SEditBox:create( width, height, bg_img, tMaxNum,tFontSize )
	local tMaxNum = tMaxNum or EDIT_NUM_MIN
	local tFontSize = tFontSize or FONT_DEF_SIZE
	local view = CCZXAnalyzeEditBox:editWithFile( 0, 0, width, height, bg_img, tMaxNum, tFontSize , EDITBOX_TYPE_NORMAL,500,500)
	return self(view)
end

function SEditBox:create_by_layout( layout )
	local view = CCZXAnalyzeEditBox:editWithFile( layout.pos[1], layout.pos[2], layout.size[1], layout.size[2],
	 layout.img_n, layout.maxnum, layout.fontsize , EDITBOX_TYPE_NORMAL,500,500)
	return self(view,layout)
end

function SEditBox:setText( str )
	self.view:setText(str)
end

function SEditBox:getText( ... )
	return self.view:getText()
end

function SEditBox:setMaxTextNum(max_num)
	if self.view then
		self.view:setMaxTextNum(max_num)
	end
end

function SEditBox:registerScriptHandler(callback)
	if self.view then
		self.view:registerScriptHandler(callback)
	end
end

function SEditBox:detachWithIME()
	if self.view then
		self.view:detachWithIME()
	end
end

--设置居中显示
--@param flags true居中 默认false不居中
function SEditBox:setCenter( flags )
	self.view:setCenter(flags)
end

--设置输入框颜色
function SEditBox:setInputColor( color )
	self.view:setInputColor(color or "#cffffff")
end