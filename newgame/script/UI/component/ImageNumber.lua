-- ImageNumber.lua
-- created by aXing on 2013-8-23
-- 添加美术字，纯数字控件

ImageNumber = {}

local _textGap = 9
local _textHeight = 38

-- 创建控件
function ImageNumber:create( numbermessage, colortype , textWidth, textHeight )
    local obj = {}

    setmetatable(obj, self)
    self.__index = self

	if colortype == nil then
		obj.colortype = FLOW_COLOR_TYPE_YELLOW_COUNT
	else
		obj.colortype = colortype
	end

	obj.textWidth = textWidth or _textGap
	obj.textHeight = textHeight or _textHeight

	obj.view = CCSpriteBatchNode:batchNodeWithFile('ui/fonteffect/y0.png')
	
	local str_len = obj:set_number( numbermessage, obj.colortype )

	obj.view:setAnchorPoint(CCPointMake(0.5,0.5))
	--obj.view:setContentSize(CCSizeMake((str_len - 1) * textGap, textHeight))

	return obj
end

-- 设置数字
function ImageNumber:set_number( numbermessage, colortype ,scale)
	local offerX = 0
	if scale == nil or scale == 1 then 
		offerX = 0
	else
		offerX = (1- scale) * 67
	end
	if self.view == nil then
		return
	end

	if colortype ~= nil then
		self.colortype = colortype
	end

	self.view:removeAllChildrenWithCleanup(true)
	numbermessage = tostring(numbermessage)
	local str_len = string.len(numbermessage) 
	local x = 0
	local ntable = Flow_Text_Config[self.colortype]
	local textGap = self.textWidth
	------print('>>>>>>>>',numbermessage)
	for i=1, str_len do 
		local bytecode = numbermessage:byte(i)
		local name = ntable[bytecode]
		if bytecode == 32 then
			x = x + textGap
		else
--@debug_begin
			assert(name,bytecode)
--@debug_end
			if name then
				local b = CCSprite:spriteWithFile(name)
				b:setPositionX(x-offerX)
				self.view:addChild(b)
				x = x + textGap
			end
		end
	end

	local textHeight = self.textHeight
	self.view:setContentSize(CCSizeMake((str_len - 1) * textGap, textHeight))

	return str_len
end

ImageNumberEx = {}

--根据获取数字图片名称
local function get_num_ima(one_num)
	return string.format("ui/fonteffect/u%d.png", one_num)
end

--创建控件
function ImageNumberEx:create(numbermessage, getPathFunc, textW, textH)
    local obj = {}
    obj.num_t = {}
    setmetatable(obj, self)
    self.__index = self
    obj.textW = textW or 35
    obj.textH = textH or 40
    obj.getPathFunc = getPathFunc or get_num_ima
	obj.view = CCSpriteBatchNode:batchNodeWithFile(obj.getPathFunc(0))
	obj:set_number(numbermessage)
	return obj
end

--设置数字
function ImageNumberEx:set_number(num, jianhua)
	self.view:removeAllChildrenWithCleanup(true)
	local need_wan = false
	if jianhua == true then
		local _num = math.floor(num/10000)
		if _num >= 1 then
			num      = _num
			need_wan = true
		end
	end
    local num_str = tostring(num)  --把数字转成字符串
    local i = 1                    --获取字符索引
    local widthSum = 0
    if num_str ~= nil or num_str ~= "" then
        local a_char = string.sub(num_str, i, i)
        while a_char ~= "" do
            local num_ima = CCSprite:spriteWithFile(self.getPathFunc(a_char))
            self.view:addChild(num_ima)
            num_ima:setPosition(widthSum, 0)
            self.num_t[i] = num_ima
            i = i+1
            a_char = string.sub(num_str, i, i)
            widthSum = widthSum+self.textW
        end
        if need_wan == true then
            local num_wan = CCSprite:spriteWithFile(self.getPathFunc("wan"))
            self.view:addChild(num_wan)
            num_wan:setPosition(widthSum, 0)
            self.num_t[i] = num_wan
            widthSum = widthSum+self.textW
        end
    end
    self.view:setContentSize(CCSizeMake(widthSum, self.textH))
end


-- @tjxs by chj
-- 添加动作（runAction），实际引用，淡入淡出
function ImageNumberEx:runAction( action_od )
	if action_od == 1 then
		for k,v in pairs(self.num_t) do
		    local array = CCArray:array();
			array:addObject(CCScaleTo:actionWithDuration(0.01, 0.9));
			array:addObject(CCScaleTo:actionWithDuration(0.03, 1.6));
			array:addObject(CCScaleTo:actionWithDuration(0.06, 1.8));
			array:addObject(CCScaleTo:actionWithDuration(0.01, 2.0));
			array:addObject(CCScaleTo:actionWithDuration(0.04, 1.8));
			array:addObject(CCScaleTo:actionWithDuration(0.03, 1.6));
			array:addObject(CCScaleTo:actionWithDuration(0.03, 1.0));
			action = CCSequence:actionsWithArray(array)
			-- local seq = CCSequence:actionsWithArray(array);
			-- local action = CCRepeatForever:actionWithAction(seq);
		    v:runAction(action)
		end
	elseif action_od == 2 then
			for k,v in pairs(self.num_t) do
		    local array = CCArray:array()
		    array:addObject(CCScaleTo:actionWithDuration(0.001, 1.05))
		    local delay2 = CCDelayTime:actionWithDuration(0.1)
		    array:addObject(delay2)
			array:addObject(CCScaleTo:actionWithDuration(0.001, 2.1))
			local delay2 = CCDelayTime:actionWithDuration(0.1)
			array:addObject(delay2)
			array:addObject(CCScaleTo:actionWithDuration(0.001, 1.05))
			-- local delay2 = CCDelayTime:actionWithDuration(0.124)
			-- array:addObject(delay2)
			-- array:addObject(CCScaleTo:actionWithDuration(0.001, 1))
			action = CCSequence:actionsWithArray(array)
			-- local seq = CCSequence:actionsWithArray(array);
			-- local action = CCRepeatForever:actionWithAction(seq);
		    v:runAction(action)
		end
	end
end
