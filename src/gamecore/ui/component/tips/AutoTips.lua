--AutoTips.lua
--cteate by tjh 
--自动生成tips

AutoTips = simple_class()

--支持的控件类型
AutoTips.TYPE_COUNTENT = "countent"
AutoTips.TYPE_LABEL    = "label"
AutoTips.TYPE_TEXT      = "text"
AutoTips.TYPE_IMG       = "img"
--容器方向 vertical竖向 horizontal横向
AutoTips.TAG_DIRECTION_V = "vertical"
AutoTips.TAG_DIRECTION_H = "horizontal"
--value 为-1 表示不创建
AutoTips._NO_CREATE_VALUE = -1

--配置文件说明
--一个table就是一个容器
--bg_img = 一个容器的背景九宫格图片资源

--tag = "vertical", 容器方向 vertical竖向 horizontal横向
-- AutoTips.TAG_DIRECTION_V = "vertical"
-- AutoTips.TAG_DIRECTION_H = "horizontal"

--	xOffset = 0,--容器相对父节点偏移位置 
				-- 注意：具体控件的偏移位置并非相对父节点（(table顺序)第一个控件相对父节点，下面的控件相对上一个控件）
--	yOffset = 0,
--具体某个控件的 ：--------
--target 用来根据参数修改数据 值等于传入数据table的key

--type 控件类型 label,img,..  不换行文字用label 换行用text
--支持的控件类型---------
-- AutoTips.TYPE_COUNTENT = "countent"
-- AutoTips.TYPE_LABEL    = "label"
-- AutoTips.TYPE_TEXT      = "text"
-- AutoTips.TYPE_IMG       = "img"
-------------------------------

--value 控件的值 (value == -1 AutoTips._NO_CREATE_VALUE) 表示不创建这个空间
--size 字体大小
--------------------------
local config = 
{
	bg_img = _PATHE_COMMON_BG_IMG,
	tag =  AutoTips.TAG_DIRECTION_V,
	--xOffsetx = 10,--默认tips 内容距离背景的x坐标
	--xOffsety = 10,--默认tips 内容距离背景的高度
	--text_max_width = 100, 默认text 自动换行文字最大宽度
	--tips_max_height = 200, 默认tips高度 除按钮外
	--btn_height =50,默认按钮高度
	{ 
	tag = AutoTips.TAG_DIRECTION_V,--容器方向
	xOffset = 0,--容器相对父节点偏移位置 
				-- 注意：具体控件的偏移位置并非相对父节点（(table顺序)第一个控件相对父节点，下面的控件相对上一个控件）
	yOffset = 0,
	--bg_img = "ui/common_tip_bg.png",
		{ 
		tag =  AutoTips.TAG_DIRECTION_V,
		xOffset = 0,
		yOffset = 0,
			--{type="img",value = "audio_btn_press.png",size=20,target="wupu"},
			{type=AutoTips.TYPE_LABEL,value = [[123456789101112131sdassssssssnssssssasdddd]],size=20,xOffset = 0,	yOffset = 10,},
			{type=AutoTips.TYPE_LABEL,value = "222222",size=20,xOffset = 0,	yOffset = 10,},
			--{type="label",value = "333333",size=20},
    	},

		{ 
		tag =  AutoTips.TAG_DIRECTION_V,
			{type=AutoTips.TYPE_LABEL,value = "aaaaaaaaaa",size=20,xOffset = -30},
    	}
	},

	{ 
	tag =  AutoTips.TAG_DIRECTION_V,
		xOffset = 0,
		yOffset = 0,
		{type=AutoTips.TYPE_IMG,value = "ui/audio_btn_press.png",size=20,target="wupu"},
		--{type="text",value = "xxxxxxxxxxxx",size=20,target="shuoming",xOffset = 10,	yOffset = 0,},
	},

	{ 
	tag =  AutoTips.TAG_DIRECTION_H,
		{type=AutoTips.TYPE_IMG,value = "ui/audio_btn_press.png",size=20,target="wupu",xOffset = 0,},
		{type=AutoTips.TYPE_TEXT,value = "xxxxxxxxxxxx萨达是很快乐的哈市的哈开始的贺卡上的痕迹卡啥事",size=20,target="shuoming",xOffset=10},
	},


	--按钮配置 用数组
	btn = {
		{
			value = "使用", --按钮文字
			target="shiyong", --按钮target 回调使用
			normal_img = _PATH_COMMON_BTN_NORMAL, --正常图片 --没有这个字段使用默认资源
			press_img = _PATH_COMMON_BTN_PRESS,  --按下图片 --没有这个字段使用默认资源
			size=30, --按钮文字字体大小
			xOffset = 30,	--偏移位置x
			yOffset = 0,   --偏移位置y
			scale_x = 0.5,
			scale_y = 0.7,
		},
		{value = "存入",target="cunru",size=20,xOffset = 30,	yOffset = 0,},
		--{value = "丢弃",target="duiqi",size=20,xOffset = 30,	yOffset = 0,},
	},
}



--距离背景的x
local _offset_x = 10
local _offset_y = 10

local _btn_height = 50
--tips允许的最大宽高
local _tips_max_height = 200
--text最大宽度
local _text_max_width = 200

--行距
local _row_spacing = 5

--创建tips
--file tips配置文件
--date tips更新数据（table） 所有需要更新的控件都可以通过target来更新
--保证控件的target的值跟 date(table）的key一致即可
function AutoTips:create( date,file )
	return self(file,date)
end

--设置按钮回调 回调返回按钮target 需要使用者自己判断target
function AutoTips:set_btn_func( func )
	self.btn_func = func
end

-- --设置回调by target 只有按钮配置同样的target点击才回调
-- function AutoTips:set_btn_func_by_target( target,func )
-- 	if not self.btn_func_table then
-- 		self.btn_func_table = {}
-- 	end
-- 	self.btn_func_table[target] = func

-- end

--设置位置
function AutoTips:setPosition( x,y )
	self.view:setPosition(x,y)
end

-------------------扩展tips 使用
--添加具体创建类型，配置文件使用新类型即可
-------------------------------

--具体控件img创建
local function createImgType( v,date )
	local countent = {}
	countent.pos=cc.p(0,0)
	countent.type = AutoTips.TYPE_IMG
	countent.xOffset = v.xOffset or 0
 	countent.yOffset = v.yOffset or 0
 	local row_spacing = _row_spacing
 	if v.target and date[v.target] then
 		if date[v.target] ==AutoTips._NO_CREATE_VALUE then
 			countent.view = GUIImg:create().view
 			_row_spacing = 0
 		else
 			countent.view = GUIImg:create(date[v.target]).view
 		end
 	else
 		countent.view = GUIImg:create(v.value).view	
 	end
	countent.size = countent.view:getContentSize()
	countent.size.height = countent.size.height +row_spacing
	countent.view:setAnchorPoint(0,0)
	return countent
end

local _istest = false
--具体控件Lbael创建
local function createLbaelType( v,date )
	local countent = {}
	countent.pos=cc.p(0,0)
	countent.type =AutoTips.TYPE_LABEL
	countent.xOffset = v.xOffset or 0
 	countent.yOffset = v.yOffset or 0
 	local label = GUIText:create()
 	label:setAnchorPoint(0, 0)
 	local row_spacing = _row_spacing
 	if v.size then
 		label:setFontSize(v.size)
 	end
 	if v.target and date[ v.target] then
 		if date[v.target] ~= AutoTips._NO_CREATE_VALUE then
			label:setString(date[ v.target] )
		else
			row_spacing = 0
		end
	else
		label:setString(v.value or "")
	end
	countent.view = label.view
	countent.size = countent.view:getContentSize()
	countent.size.height = countent.size.height +row_spacing
	return countent
end

--具体控件Text创建
local function createTextType( v,date,self)
	local countent = {}
	countent.pos=cc.p(0,0)
	countent.type = AutoTips.TYPE_TEXT
	countent.xOffset = v.xOffset or 0
 	countent.yOffset = v.yOffset or 0
 	local row_spacing = _row_spacing
	local instance = guiex.RichTextCreator:getInstance()
	local max_width = self.file.text_max_width or _text_max_width
	local  strText = v.value or ""
	--使用用户数据
	if v.target and date and date[v.target] then
		strText = date[v.target]
		if date[v.target] == AutoTips._NO_CREATE_VALUE then
			strText = ""
			row_spacing = 0
		end
	end
	local text = GUIRichText:create(strText, cc.size(max_width,0))
	countent.view = text.view
	text:setAnchorPoint(0.25, 0.25)
	countent.size = text:getContentSize()
	countent.size.height = countent.size.height +row_spacing
	return countent
end

--具体容器创建
local function create_content( v )
	local countent = {}
	countent.size = cc.size(0,0)
	countent.pos=cc.p(0,0)
	countent.type = AutoTips.TYPE_COUNTENT
	countent.tag = v.tag 
	countent.xOffset = v.xOffset or 0
 	countent.yOffset = v.yOffset or 0
 	local path = v.bg_img or _PATHE_COMMON_BG_IMG
 	if v.bg_img then
 		countent.view = GUIImg:create9Img( v.bg_img).view
 	else
 		countent.view = GUIWidget:create().view
 	end
	countent.view:setAnchorPoint(0,0)

	return countent
end

local createfun = {
	label=createLbaelType,
	img =createImgType,
	text=createTextType,
}


--计算每个root大小
local function calculation_size( root )
	local max_x = 0
	local max_y = 0
	local countent = nil
	local _root = nil

	for i=1, #root do
		_root = root[i]
		if _root.type == AutoTips.TYPE_COUNTENT then --一个容器
			calculation_size(_root)
		end 
		--计算一个容器大小
		countent = _root
		if root.tag == AutoTips.TAG_DIRECTION_V  then
			max_x = math.max(max_x ,countent.size.width+countent.xOffset )
			max_y = max_y + countent.size.height+countent.yOffset
		else
			max_y = math.max(max_y ,countent.size.height + countent.yOffset )
			max_x = max_x + countent.size.width + countent.xOffset
		end

		--end
	end

	root.size = {width=max_x,height=max_y}
end

--控件排序
local function adjust( root )
	local sx = 1
	local sy = root.size.height
	for k,v in ipairs(root) do
		if v.type == AutoTips.TYPE_COUNTENT then
			v.view:setContentSize(v.size)
			adjust(v)
			--xOffset = 0
		else
			--xOffset = 10
		end
			local x = 1
			local y = 1
			if root.tag == AutoTips.TAG_DIRECTION_V  then
				 x = v.xOffset
				 y = sy - v.size.height - v.yOffset
				 sy = y
			else
				x = sx+v.xOffset
				sx = x + v.size.width
				y = (root.size.height-v.size.height) / 2 - v.yOffset
			end
		v.view:setPosition(x,y)
	end
end


--初始化
function AutoTips:__init( file ,date)

	self.file = file or config

	self.date = date or {}

	self.btn_func = nil -- 按钮回调 所有按钮通过这个函数回调

	self.btn_func_table  = nil --多个按钮回调 通过target添加

	self.btn_height = 0

	self.offset_x = self.file.xOffset or _offset_x
	self.offset_y = self.file.yOffset or _offset_y

	local v = { tag = AutoTips.TAG_DIRECTION_V } --tips 总体方向
	--创建根节点
	self.root = self:createOne(v) 
	--创建配置文件所以控件
	self:create_list( self.file,self.root ) 

	--创建背景
	local bg = GUIImg:create9Img("ui/common_tip_bg.png")
	bg:setAnchorPoint(0,0)
	--bg:setContentSize(self.root.size.width,self.root.size.height)
	self.view = bg.view
	--self.view:addChild(self.root.view)
	
	--创建按钮
	if self.file.btn then
		self.btn_height = _btn_height
		self:create_btn(self.file.btn)
	end
	self:create_listview(0,0)
	--排序
	self:_adjust()
end

function AutoTips:_adjust( ... )
	--计算大小
	calculation_size(self.root)
	--调整位置
 	adjust(self.root,self.file.tag)
 	--调整背景
 	local width = self.root.size.width
 	local height = self.root.size.height
 	self.root.view:setContentSize(width,height)
 	if height >= _tips_max_height then
 		height = _tips_max_height
 	end
 	self.view:setContentSize(width+2*self.offset_x,height+self.btn_height+self.offset_y*2)
 	--self:create_listview(width,_tips_max_height)
 	self.listView:setContentSize(cc.size(width,_tips_max_height))
end

--创建滑动视图
function AutoTips:create_listview( width,height )

    self.listView = ccui.ListView:create()
    local x = self.file.offset_x or _offset_x
    local y = self.file.offset_x or _offset_y
    self.listView:setPosition(x,self.btn_height+y)
	self.listView:insertCustomItem(self.root.view,0)
	self.view:addChild(self.listView)

end
--按钮回调
function AutoTips:btn_cb_func( target )
	if self.btn_func then
		self.btn_func(target)
	end
	if self.btn_func_table then
		if self.btn_func_table[target] then
			self.btn_func_table[target]()
		end
	end
end

--创建tips下面的按钮
function AutoTips:create_btn( btn_t )
	local btn_x = 0
	local texture = nil
	local btn = nil
	local x = 0
	local y =  0
	local target = nil
	local value = nil
	for i=1 , #btn_t do
		target = btn_t[i].target
		value = btn_t[i].value
		if target  then
			value = self.date[target] or value
		end
		if value ~= AutoTips._NO_CREATE_VALUE then
			texture = btn_t[i].normal_img or _PATH_COMMON_BTN_NORMAL
			local btn = GUIButton:create(texture)
			btn:setAnchorPoint(0,0)
			btn:setTexturePressed(btn_t[i].press_img or _PATH_COMMON_BTN_PRESS)
			btn:setTitleText(value)
			btn:setScale( btn_t[i].scale_x or 1, btn_t[i].scale_y or 1)
			if btn_t[i].size then
				btn:setTitleFontSize(btn_t[i].size )
			end
			x = btn_x + (btn_t[i].xOffset or 0)
			btn:setPosition(x+self.offset_x,y+self.offset_y)
			self.view:addChild(btn.view)

			local function btn_cb_func( sender )
				self:btn_cb_func(btn_t[i].target)
			end
			-- btn:addCLickEventListener(btn_cb_func)
			btn:set_click_func(btn_cb_func)
			----自动偏移
			btn_x = btn_x + btn:getContentSize().width
		end
	end
end

--递归生成配置文件控件
function AutoTips:create_list( file,root )
	local count = 1

	for k,v in ipairs(file) do
		if type(v) == "table" then --一个容器
			local countent = self:createOne(v)
			if countent then
				root[count] = countent
				count = count + 1
				root.view:addChild(countent.view)
				if v.tag  then
					self:create_list(v,countent) --递归
				end
			end
		end
	end
end

--创建一个元素（容器或者控件）
function AutoTips:createOne( v )
	if v.tag then
		return create_content( v )
	else
		if createfun[v.type] then
			return createfun[v.type](v,self.date,self)
		else
			print("AutoTips not this type widget",v.type)
		end
	end
end


