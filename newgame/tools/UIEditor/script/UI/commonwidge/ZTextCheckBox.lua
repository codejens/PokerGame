---------HJH
---------2012-2-15
---------
require "UI/commonwidge/base/ZAbstractNode"
----------------------------------------------------------------------
----------------------------------------------------------------------
---------
---------后带文字复选按钮
super_class.ZTextCheckBox(ZAbstractBasePanel)
---------
---------

local STYLE_TABLE = { 
		[UISTYLE_ZTEXTCHECKBOX_ONE] = { UIResourcePath.FileLocate.common .. "toggle_n.png",
		 UIResourcePath.FileLocate.common .. "toggle_s.png"},
		[UISTYLE_ZTEXTCHECKBOX_TWO] = { "ui/normal/common_question_mark.png",
			"ui/normal/common_question_mark.png"},
  	}

local function TextCheckBoxCreateFunction(self, width, height, x, y, image, text,click_fun, gapSize, fontSize)
	local tPosX = x
	local tPosY = y
	local tWidth = width
	local tHeight = height
	local tFontSize = fontSize
	local tImage = image
	local tText = text
	local tGapSize = gapSize
	if x == nil then
		tPosX = 0
	end
	if y == nil then
		tPosY = 0
	end
	if width == nil then
		tWidth = -1
	end
	if height == nil then
		tHeight = -1
	end
	if image == nil then
		tImage = ""
	end
	if fontSize == nil then
		tFontSize = 16
	end
	if text == nil then
		tText = ""
	end
	if gapSize == nil then
		tGapSize = 0
	end
	---------
	require "UI/commonwidge/ZCheckBox"
	require "UI/commonwidge/ZLabel"
	require "UI/commonwidge/ZBasePanel"
	self.touch_click_fun = click_fun
	local checkbox = ZCheckBox:create(nil, tImage, nil, 0, 0, tWidth, tHeight)
	self.check_button = checkbox
	local checkboxsize = checkbox:getSize()
	checkbox.view:setEnableHitTest(false)
	checkbox:setTouchBeganReturnValue(false)
	checkbox:setTouchEndedReturnValue(false)
	checkbox:setTouchClickReturnValue(false)
	checkbox:setTouchDoubleClickReturnValue(false)

	local text = ZLabel:create(nil, tText, checkboxsize.width + tGapSize, 0, tFontSize)
	self.text = text
	local textsize = text:getSize()
	local height = nil
	if checkboxsize.height>=textsize.height then
		height = (checkboxsize.height-textsize.height)/2
    else
    	height = 0
    end
    text:setPosition(checkboxsize.width + tGapSize,height)
    local basepanel = nil
    if checkboxsize.height>=textsize.height then
	 basepanel = ZBasePanel:create(nil, nil, tPosX, tPosY, checkboxsize.width + textsize.width + tGapSize, checkboxsize.height )
    else
     basepanel = ZBasePanel:create(nil, nil, tPosX, tPosY, checkboxsize.width + textsize.width + tGapSize,  textsize.height)
	end
	basepanel.view:addChild(checkbox.view)
	basepanel.view:addChild(text.view)
	self.view = basepanel.view
	-- add by hcl on 2014/5/27 默认选中颜色
	if self.normal_color then
		self.text.view:setColor(tonumber(self.normal_color))
	end

end
---------
---------
function ZTextCheckBox:__init(fatherPanel)
	self.check_button = nil
	self.normal_color = 0xfffff000	--"0xfff000"
	self.select_color = 0xff66ff66		--"0x66ff66"
	-- self.normal_color = nil	
	-- self.select_color = nil		
	self.father_panel = fatherPanel
end
---------
---------参数说明：x、y代表位置。width、height代表图片长宽,image代表图片路径,text代表文本内容,fontSize代表文本字体字号
function ZTextCheckBox:create(fatherPanel, image, text,click_fun, x, y, width, height, gapSize, fontSize)
	local sprite = ZTextCheckBox(fatherPanel)
	TextCheckBoxCreateFunction(sprite, width, height, x, y, image, text,click_fun, gapSize, fontSize)
	sprite:registerScriptFun()
	if fatherPanel ~= nil then
		if fatherPanel.view ~= nil then
			fatherPanel.view:addChild( sprite.view )
		else
			fatherPanel:addChild( sprite.view )
		end
	end
	return sprite
end

---------
function ZTextCheckBox:setClickStateColor(normalColor, selectColor)
	self.normal_color = normalColor
	self.select_color = selectColor
	if self.normal_color then
		self.text.view:setColor(tonumber(self.normal_color))
	end
end
---------
function ZTextCheckBox:setCheck(state) --是否要勾选
	if state == true then
		self.check_button:setCurState(CLICK_STATE_DISABLE)
	else
		self.check_button:setCurState(CLICK_STATE_UP)
	end
end

function ZTextCheckBox:getCheck()  --获取是否勾选
	if self.check_button.view:getCurState() == CLICK_STATE_UP then
		return false
	else
		return true
	end
end
---------
function ZTextCheckBox:getText()
	if self.text ~= nil then
		return self.text:getText()
	end
end

function ZTextCheckBox:setText(text)
	if self.text ~= nil then
		return self.text:setText(text)
	end
end

-- 设置label 位置
function ZTextCheckBox:set_label_position( ps_x,ps_y )
	if self.text ~= nil  then
        self.text:setPosition(ps_x,ps_y)
	end
end

---------

function ZTextCheckBox:registerClickFun(click_fun)
	self.touch_click_fun = click_fun
end

function ZTextCheckBox:registerDoubleClickFun(double_click_fun)
	self.touch_double_click_fun = double_click_fun
end

---------
function ZTextCheckBox:registerScriptFun()
	if self.view ~= nil then
		local function basePanelMessageFun(eventType, args, msgid, selfItem)
			-------
			if eventType == nil or args == nil or msgid == nil or selfItem == nil then
				return 
			end
			-------
			if eventType == TOUCH_BEGAN then
				if self.touch_begin_fun ~= nil then
					self.touch_begin_fun(args)
				end
				return self.touch_begin_return
			elseif eventType == TOUCH_MOVED then
				if self.touch_move_fun ~= nil then
					self.touch_move_fun(args)
				end
				return self.touch_move_return
			elseif eventType == TOUCH_ENDED then
				if self.touch_end_fun ~= nil then
					self.touch_end_fun(args)
					if self.check_button.view:getCurState() == CLICK_STATE_UP then
						if self.normal_color ~= nil then
							self.text.view:setColor(tonumber(self.normal_color))
						end
					else
						if self.select_color ~= nil then
							self.text.view:setColor(tonumber(self.select_color))
						end
					end
				end
				return self.touch_end_return
			elseif eventType == TOUCH_CLICK then
				if self.check_button.view:getCurState() == CLICK_STATE_UP then
					if self.normal_color ~= nil then
						print("self.normal_color",self.normal_color)
						self.text.view:setColor(tonumber(self.normal_color))
					end
				else
					if self.select_color ~= nil then
						self.text.view:setColor(tonumber(self.select_color))
					end
				end
				if self.touch_click_fun ~= nil then
					self.touch_click_fun(args)
				end
				return self.touch_click_return
			elseif eventType == TOUCH_DOUBLE_CLICK then
				if self.touch_double_click_fun ~= nil then
					self.touch_double_click_fun(args)
				end
				return self.touch_double_click_return
			elseif eventType == TIMER then
				if self.touch_timer_fun ~= nil then
					self.touch_timer_fun()
				end
				return true
			elseif eventType == OUT_OF_FOCUS then
				if self.normal_color ~= nil then
					self.text.view:setColor(tonumber(self.normal_color))
				end
			elseif eventType == ON_FOCUS then
				if self.select_color ~= nil then
					self.text.view:setColor(tonumber(self.select_color))
				end
			end
		end
		-------
		self.view:registerScriptHandler(basePanelMessageFun)
	end
end

function ZTextCheckBox:createByStyle( _style,layout )
	local image = STYLE_TABLE[_style]
	print("layout.posY=", layout.posY)
	local component = ZTextCheckBox:create(nil, image, layout.text,nil, layout.posX, layout.posY, 
		layout.width, layout.height, layout.gapSize, layout.fontSize);
	return component
end