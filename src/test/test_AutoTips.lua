module(...,package.seeall)
--test_AutoTips.lua
--配置文件说明
--bg_img = 一个容器的背景九宫格图片资源
--tag = "vertical", 容器方向 vertical竖向 horizontal横向
--	xOffset = 0,--容器相对父节点偏移位置 
				-- 注意：具体控件的偏移位置并非相对父节点（(table顺序)第一个控件相对父节点，下面的控件相对上一个控件）
--	yOffset = 0,
--具体某个控件的 ：--------
--target 用来根据参数修改数据 值等于传入数据table的key
--type 控件类型 label,img,..
--value 控件的值
--size 字体大小
--------------------------
local config = 
{
	bg_img = "common_tip_bg.png",
	tag = "vertical",
	{ 
	tag = "horizontal",--容器方向
	xOffset = 0,--容器相对父节点偏移位置 
				-- 注意：具体控件的偏移位置并非相对父节点（(table顺序)第一个控件相对父节点，下面的控件相对上一个控件）
	yOffset = 0,
	bg_img = "common_tip_bg.png",
		{ 
		tag = "vertical",
		xOffset = 0,
		yOffset = 0,
			--{type="img",value = "audio_btn_press.png",size=20,target="wupu"},
			{type="label",value = "1111111111",size=20,xOffset = 0,	yOffset = 10,},
			{type="label",value = "11111",size=20,xOffset = 0,	yOffset = 10,},
			{type="label",value = "111111",size=20},
    	},

		{ 
		tag = "vertical",
			{type="label",value = "aaaaaaaaaa",size=20},

			-- {type="label",value = "bbbbbbbb",size=20,target="name"},

			-- {type="label",value = "cccccc",size=20}
    	}
	},

	{ 
	tag = "horizontal",
		xOffset = 50,
		yOffset = 0,
		{type="img",value = "audio_btn_press.png",size=20,target="wupu"},
		{type="label",value = "xxxxxxxxxxxx",size=20,target="shuoming",xOffset = 30,	yOffset = 0,},
	},

	{ 
	tag = "horizontal",
		--{type="img",value = "audio_btn_press.png",size=20,target="wupu"},
		{type="label",value = "xxxxxxxxxxxx",size=20,target="shuoming"},
	},


	--按钮配置 用数组
	btn = {
		{
			value = "使用", --按钮文字
			target="shiyong", --按钮target 回调使用
			normal_img = _PATH_COMMON_BTN_NORMAL, --正常图片 --没有这个字段使用默认资源
			press_img = _PATH_COMMON_BTN_PRESS,  --按下图片 --没有这个字段使用默认资源
			size=20, --按钮文字字体大小
			xOffset = 30,	--偏移位置x
			yOffset = 0,   --偏移位置y
		},
		{value = "存入",target="cunru",size=20,xOffset = 30,	yOffset = 0,},
		{value = "丢弃",target="duiqi",size=20,xOffset = 30,	yOffset = 0,},
	},
}

test_AutoTips = simple_class()

--创建tips
--file tips配置文件
--date tips更新数据（table） 所有需要更新的控件都可以通过target来更新
--保证控件的target的值跟 date(table）的key一致即可
function test_AutoTips:create_tips( file,date )
	return test_AutoTips(file,date)
end

--设置按钮回调 回调返回按钮target 需要使用者自己判断target
function test_AutoTips:set_btn_func( func )
	self.btn_func = func
end

--设置回调by target 只有按钮配置同样的target点击才回调
function test_AutoTips:set_btn_func_by_target( target,func )
	if not self.btn_func_table then
		self.btn_func_table = {}
	end
	self.btn_func_table[target] = func

end


-------------------扩展tips 使用
--添加具体创建类型，配置文件使用新类型即可
-------------------------------

--具体控件img创建
local function createImgType( v )
	local countent = {}
	countent.pos=cc.p(0,0)
	countent.type = "img"
	countent.xOffset = v.xOffset or 0
 	countent.yOffset = v.yOffset or 0
	countent.view = GUIImg:create(v.value).view
	countent.size = countent.view:getContentSize()
	countent.view:setAnchorPoint(0,0)
	return countent
end

--具体控件Lbael创建
local function createLbaelType( v )
	local countent = {}
	countent.pos=cc.p(0,0)
	countent.type = "label"
	countent.xOffset = v.xOffset or 0
 	countent.yOffset = v.yOffset or 0
	countent.view = GUIText:create(v.value).view
	countent.view:setFontSize(v.size)
	if v.target and self.date[ v.target] then
		countent.view:setString(self.date[ v.target])
	end
	countent.view:setAnchorPoint(0, 0)
	countent.size = countent.view:getContentSize()
	return countent
end

--具体控件Text创建
local function createTextType( v )

end

--具体容器创建
local function create_content( v )
	local countent = {}
	countent.size = {width=0,height=0}
	countent.pos=cc.p(0,0)
	countent.type = "countent"
	countent.tag = v.tag 
	countent.xOffset = v.xOffset or 0
 	countent.yOffset = v.yOffset or 0
 	local path = v.bg_img or "common_tip_bg.png"
 	if v.bg_img then
 		countent.view = GUINineImg:create( "common_tip_bg.png" ).view
 	else
 		countent.view = GUIWidget:create()
 	end
	countent.view:setAnchorPoint(0,0)

	return countent
end

local createfun = {
	label=createLbaelType,
	img =createImgType,
	text=createTextType,
}


--控件排序
local function adjust( root )
	print(root.size.width,root.size.height)
	local sx = 1
	local sy = root.size.height
	for k,v in ipairs(root) do
		if v.type == "countent" then
			v.view:setContentSize(v.size)
			adjust(v)
			--xOffset = 0
		else
			--xOffset = 10
		end
			local x = 1
			local y = 1
			if root.tag == "vertical" then
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
function test_AutoTips:__init( file ,date)
	file = config

	self.date = date

	self.btn_func = nil -- 按钮回调 所有按钮通过这个函数回调

	self.btn_func_table  = nil --多个按钮回调 通过target添加

	local v = { tag = "vertical"} --tips 总体方向
	--创建根节点
	self.root = self:createOne(v) 
	--创建配置文件所以控件
	self:create_list( file,self.root ) 
	--排序
	adjust(self.root,file.tag)
	--创建背景
	local bg = GUINineImg:create(file.bg_img)
	bg:setContentSize(self.root.size.width,self.root.size.height)
	self.view = bg.view
	self.view:addChild(self.root.view)
	
	--创建按钮
	if file.btn then
		self:create_btn(file.btn)
	end

end

--按钮回调
function test_AutoTips:btn_cb_func( target )
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
function test_AutoTips:create_btn( btn_t )
	local btn_x = 0
	local texture = nil
	local btn = nil
	local x = 0
	local y = self.view:getContentSize().height - 10
	for i=1 , #btn_t do
		texture = btn_t[i].normal_img or _PATH_COMMON_BTN_NORMAL
		btn = GUIButton:create(texture)
		btn:setTexturePressed(btn_t[i].press_img or _PATH_COMMON_BTN_NORMAL)
		x = btn_x + btn_t[i].xOffset
		btn:setPosition(x,y)
		self.view:addChild(btn.view)

		local function btn_cb_func(  )
			self:btn_cb_func(btn_t[i].target)
		end
		btn:addCLickEventListener(btn_cb_func)
		--自动偏移
		btn_x = btn_x + btn:getContentSize().width
	end
end

--递归生成配置文件控件
function test_AutoTips:create_list( file,root )
	local max_x = 0
	local max_y = 0
	local max_countent_x = 0
	local max_countent_y = 0
	local count = 1

	for k,v in pairs(file) do
		if type(v) == "table" then --一个容器
			local countent = self:createOne(v)
			root[count] = countent
			count = count + 1
			root.view:addChild(countent.view)
			if v.tag  then
				self:create_list(v,countent) --递归
			end
			--计算容器大小
			if root.tag == "vertical" then
				max_x = math.max(max_x ,countent.size.width+countent.xOffset )
				max_y = max_y + countent.size.height+countent.yOffset
			else

				max_y = math.max(max_y ,countent.size.height + countent.yOffset )
				max_x = max_x + countent.size.width + countent.xOffset
			end

		end
	end

	root.size = {width=max_x,height=max_y}

end

--
function test_AutoTips:createOne( v )
	if v.tag then
		return test_AutoTips.create_content( v )
	else
		return createfun[v.type](v)
	end
end


