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

function SEditBox:edit_box_handler(eventType,arg,msgid)
	if eventType == nil or arg == nil or msgid == nil then
        return true
    end
    if self.limit_input_flag ~= nil then
	    self:do_limit_input_hadler(eventType)
    end
    if self.callback then
    	return self.callback(eventType,arg,msgid)
    end
    return true
end

function SEditBox:do_limit_input_hadler(eventType)
	if eventType == KEYBOARD_CLICK then --输入
		local str = self:getText()
		local all_str = ""
    	for _ , str in ipairs(self.default_str_list) do
    		all_str = all_str .. str 
    	end
		if self:is_can_input(str) == true then
	    	local last_count = #self.default_str_list
	    	local now_str = self:getText()
	    	local last_str_len = string.len(all_str) + 1 	--有记录过
	    	local now_str_len = string.len(now_str)   --第一次输入到这里
	    	local one_str = string.sub(now_str,last_str_len,now_str_len)
	    	if one_str ~= nil and one_str ~= "" then
		    	table.insert(self.default_str_list,one_str)
		    end
	    else
	    	self:setText(self.input_color .. all_str)
	    end
    elseif eventType == KEYBOARD_BACKSPACE then --退格
    	local str = self:getText()
		local all_str = ""
		local all_count = #self.default_str_list
    	for index = 1 , all_count - 1 do
    		all_str = all_str .. self.default_str_list[index] 
    	end
    	if all_count > 0 then
    		table.remove(self.default_str_list,all_count)
    	end
    	if all_str == "" then
    		-- self:setText(self.normal_str)
    	else
    		self:setText(self.input_color .. all_str)
    	end
    end
end

function SEditBox:is_can_input(str)
	if str ~= nil and str == "" then
        return false
    end
	if self.limit_input_flag == 1 then 						--只能输入数字
	    return nil == string.find(str,"[^%d]")
	elseif self.limit_input_flag == 2 then					--只能输入26字母
	    return nil == string.find(str,"[^%a]")
    elseif self.limit_input_flag == 3 then 					--只能输入数字+.
    	local b = string.find(str,"[^%d]") 
    	if b ~= nil then --除了数字,还有别的
    		if nil ~= string.find(str,"%.") or nil ~= string.find(str,"/") or nil ~= string.find(str,":") then --不是.
    			b = nil
    		end
    	end
    	return b == nil
	elseif self.limit_input_flag == 4 then 					--只能输入数字+字母
		return nil == string.find(str,"%W%W")
	elseif self.limit_input_flag == 5 then 					--不能全是空格
		return nil ~= string.find(str,"[^%s]")
	end
end

function SEditBox:set_limit_input(flag,default_str_list)
	-- self.normal_str = normal_str or ""
	self.default_str_list = default_str_list or {}
	self.limit_input_flag = flag
end

function SEditBox:set_default_param()
	self.limit_input_flag = self.limit_input_flag or 5
	self.default_str_list = self.default_str_list or {}
end

function SEditBox:registerScriptHandler(callback)
	if self.view then
		self.callback = callback
		self:set_default_param()
		local function callback(eventType,arg,msgid)
			return self:edit_box_handler(eventType,arg,msgid)
		end
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
	color = color or "#cffffff"
	self.view:setInputColor(color)
	self.input_color = color
end
